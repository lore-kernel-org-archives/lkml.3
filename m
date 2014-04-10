Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030912AbaDJNT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:19:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38119 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030725AbaDJNTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:19:23 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-9b-53469a5ae861
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, aaro.koskinen@iki.fi,
        tony@atomide.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 07/13] extcon: extcon-class: improve
 get_cable_state_()/set_cable_state_() functions
Date: Thu, 10 Apr 2014 15:16:45 +0200
Message-id: <1397135811-12866-8-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
References: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRa0hTYRgHcN+ds7Pj6MBhLT0pYiyCEvNSIi9ooZDjJQwyv/khW3qc4m3t
	qHgBXXhD0zZNkXSpM83LZpIZqaW76IcsL5OFFuUltExLDZkaKZZb9e338P8/PB8eEhP14h5k
	UloGq0yTpUgIIf7mYIk+G1MvjQ7Y3/KBhq9h0PzsDDQvFMBZ+wofVi9vYrBpdJIPqzrvYVD9
	XceH6r5L0LTfD2Dhwx4CTq51Alg2sYxB6+cKArYN63GoK2nFoW1QS8CGVjUOWx4VY3BZN86D
	bbPTPPjhdgcB29d/E1BT143DxZEBAXy8WofD4qFRARy27vOh8e3lMC9kaDQAtLNdjSPb3Uoe
	GhzQ8pFGvQXQQP2cAHW22wk0sq3D0dMOH9TbVUagNf19Pvo485JAxgcGAaos3CDQatUegQZ2
	VYKr4hhhaDybkpTFKv0v3hAmjry344pBKttStoyrwLawHLiSDB3ELKyOE3/txljnew4tJEV0
	C2CsM/P/hlIes1ZkcrYI2pfp29UAh8U0xjTXTgFHCaPH+EyX2Yg5gqN0AtPxyuI0Tp9iSrYa
	nKboCKbIpD9cIA/PnWC01aEOutJSZsh20kHRYaO2W6IBVDNw6QLHWEWcgrspTz3nx8lSucw0
	uV9cemovcH7yi2c/6FJBC6BJIDlCmR5FRIv4siwuJ9UCGBKTiKkntdJoERUvy8lllemxyswU
	lrMATxKXuFPm4pAoES2XZbDJLKtglf9THunqoQLID9fbI93kBdbwpJ2xWwXG0fFs6tv1lqDA
	n3qtOGEq7506PM+qFTQ/33SvUZ73VYOlO+uLe97BF7zbfpTnhnk15VUH+E+4p0dqTR0b3OuK
	KPOCzat+LH/acHo2pmYwmf5ENQYXMxku9pKQa1d+cS3SmFLu+Nx6bEr5wYuVfAnOJcoCfTAl
	J/sDtHc6lMUCAAA=
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added check if pointer to edev is not NULL, and updated documentation of index
parameter. Function extcon_find_cable_index() has been deleted and cannot be
used to retrieve cable number.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-class.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 2be0ac9..2659805 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -285,10 +285,12 @@ EXPORT_SYMBOL_GPL(extcon_set_state);
 /**
  * extcon_get_cable_state_() - Get the status of a specific cable.
  * @edev:	the extcon device that has the cable.
- * @index:	cable index that can be retrieved by extcon_find_cable_index().
+ * @index:	cable index in extcon device.
  */
 int extcon_get_cable_state_(struct extcon_dev *edev, int index)
 {
+	if (!edev)
+		return -ENODEV;
 	if (index < 0 || (edev->max_supported && edev->max_supported <= index))
 		return -EINVAL;
 
@@ -312,8 +314,7 @@ EXPORT_SYMBOL_GPL(extcon_get_cable_state);
 /**
  * extcon_set_cable_state_() - Set the status of a specific cable.
  * @edev:		the extcon device that has the cable.
- * @index:		cable index that can be retrieved by
- *			extcon_find_cable_index().
+ * @index:		cable index in extcon device.
  * @cable_state:	the new cable status. The default semantics is
  *			true: attached / false: detached.
  */
@@ -322,6 +323,8 @@ int extcon_set_cable_state_(struct extcon_dev *edev,
 {
 	u32 state;
 
+	if (!edev)
+		return -ENODEV;
 	if (index < 0 || (edev->max_supported && edev->max_supported <= index))
 		return -EINVAL;
 
-- 
1.7.9.5

