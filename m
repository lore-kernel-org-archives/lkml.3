Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbaDNLs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:48:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61427 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaDNLsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:48:51 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-ab-534bcb21c131
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 07/13] extcon: extcon-class: improve
 get_cable_state_()/set_cable_state_() functions
Date: Mon, 14 Apr 2014 13:46:18 +0200
Message-id: <1397475984-28001-8-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRa0hTYRgH8N6dy46jxWFaHRTEVomKWso+vJWZhMpbEih+q7SmHnTodGwq
	mYGGmCnq5kzUWuqctzkveL9k5o1ALFMUJ01LSPOagpfMNGtT+vZ7/s8fng8PhQk6cVtKEhvP
	ymPFMUKSh48cfqPdzo0EBF9+s+QJ65Z8YH+bM+z/mgKN24sEVM9vYLB0aJSAefp8DCrXtARU
	tvrCvoNOANN0jSQcXdEDmPlxHoNjC9kkrOw14FD7rAKHE90aEr6qUOKwvCodg/PaDxxYPzTL
	hZXGcQ40Pa0hYfWPvyRUFdbjcG6wiwsblgtxmP52iAt7xw4I2Fi0ivvYo7qSOoAmcnM4qLtL
	QyCVchOgrpezXKSv3ibR4I4WRy01Lqi5NpNEK4ZiAs1M9ZDo3es6LspJWyfRct4+ibp2U7ko
	t7UWBFrf5XlFsDGSRFZ+yfshL+rz1AxX1s1/tKV3TQU7vCxgRTG0iMlYmcWPfYYZ+9JIZgEe
	JaDLAWPYMxLHQwaH2Wqa41haJO3KtO6qgMU2NMaUFXw6MkYvEEzHr+sWW9MSRle0QVqM0xcZ
	w+YuYTGf9mNy16vMOWW+5sBo1F6W2Ir2Z/qL/2AWC8yVvjQTpgL8MnCiFpxmZeEyRVik1MNd
	IZYqEmIj3cPjpM3g6J/fbTuBPhUOAJoCwpP855qAYAEhTlQkSQcAQ2FCG75fmzniR4iTHrPy
	uAfyhBhWMQDsKFx4lt+Xfi1IQEeK49lolpWx8v9bDmVlmwpOaa9aOz4p3VZPru6riAv10zp5
	UGJTyMjNw3bd/Xs3WsImK0IrOxzWe1LK99xNNfImZ/vsWwU/M0opJ1/P8fc7IXdW7Yed1Icl
	xOLaGpK8CHJ2dAzV+rcnH8z8VmReSTa6qW8fxO9pzgsaYjt0w9MJNo0SZBJF24kCvWUiU74Q
	V0SJPVwwuUL8D5RP6kTLAgAA
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
index 40a33e2..e9e5e85 100644
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

