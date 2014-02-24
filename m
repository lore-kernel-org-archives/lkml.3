Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaBXHxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:53:55 -0500
Received: from mout.gmx.net ([212.227.17.20]:56870 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaBXHxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:53:54 -0500
Date: Mon, 24 Feb 2014 08:53:46 +0100
From: Michael Brunner <mibru@gmx.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Lee Jones <lee.jones@linaro.org>, Chris Healy <chealy@imsco-us.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Christian Rauch <christian.rauch@kontron.com>
Subject: [PATCH] mfd: Add support for COMe-mBT10, COMe-cBT6 and COMe-cHL6 to
 Kontron PLD driver
Message-ID: <20140224085346.4959ff7f@hyperion>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:rt/TMpfzoyTFxLwAVC8yukkxOMZNClrXo+JUrvcCN5+VCytER7l
 9H+o5dpls+pfG9LU/uK43fraSEia8/msQT0bUDs0B3T7Z1FfUoDIc10ntxv2XmOjewaxTn1
 B6CohlGlCdJZiZRQRxihbEbSExLls8TWtG5X67MJr6yek3HxJQsBl4uv+5wZGrwZEt6Z2uq
 UtdFHEPxbU5vLgMtl6CQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DMI system IDs for the Kontron modules COMe-mBT10, COMe-cBT6
and COMe-cHL6 to the Kontron PLD driver. The list of supported products in
the module description is also updated.

Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
Acked-by: Christian Rauch <christian.rauch@kontron.com>
---
 drivers/mfd/Kconfig       |  5 +++++
 drivers/mfd/kempld-core.c | 24 ++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 49bb445..f093401 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -270,13 +270,18 @@ config MFD_KEMPLD
 	  device may provide functions like watchdog, GPIO, UART and I2C bus.
 
 	  The following modules are supported:
+		* COMe-bHL6
 		* COMe-bIP#
 		* COMe-bPC2 (ETXexpress-PC)
 		* COMe-bSC# (ETXexpress-SC T#)
+		* COMe-cBT6
 		* COMe-cCT6
 		* COMe-cDC2 (microETXexpress-DC)
+		* COMe-cHL6
 		* COMe-cPC2 (microETXexpress-PC)
+		* COMe-mBT10
 		* COMe-mCT10
+		* COMe-mTT10 (nanoETXexpress-TT)
 		* ETX-OH
 
 	  This driver can also be built as a module. If so, the module
diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
index d3e2327..20a6afc 100644
--- a/drivers/mfd/kempld-core.c
+++ b/drivers/mfd/kempld-core.c
@@ -438,6 +438,14 @@ static struct dmi_system_id __initdata kempld_dmi_table[] = {
 		.driver_data = (void *)&kempld_platform_data_generic,
 		.callback = kempld_create_platform_device,
 	}, {
+		.ident = "CHL6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-cHL6"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
 		.ident = "CHR2",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
@@ -510,6 +518,14 @@ static struct dmi_system_id __initdata kempld_dmi_table[] = {
 		.driver_data = (void *)&kempld_platform_data_generic,
 		.callback = kempld_create_platform_device,
 	}, {
+		.ident = "CVV6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-cBT"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
 		.ident = "FRI2",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
@@ -533,6 +549,14 @@ static struct dmi_system_id __initdata kempld_dmi_table[] = {
 		.driver_data = (void *)&kempld_platform_data_generic,
 		.callback = kempld_create_platform_device,
 	}, {
+		.ident = "MVV1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-mBT"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
 		.ident = "NTC1",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
-- 
1.8.5.1
