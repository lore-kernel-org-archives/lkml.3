Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbbA0KGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:06:04 -0500
Received: from mout.gmx.net ([212.227.17.21]:50420 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbbA0KGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:06:00 -0500
Date: Tue, 27 Jan 2015 11:05:49 +0100
From: Michael Brunner <mibru@gmx.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Darren Hart <dvhart@linux.intel.com>,
        Kevin Strasser <kevin.strasser@linux.intel.com>,
        Michael Brunner <michael.brunner@kontron.com>,
        Christian Rauch <christian.rauch@kontron.com>
Subject: [PATCH] mfd: Add support for COMe-cBL6 to Kontron PLD driver
Message-ID: <20150127110549.0e15be0e@hyperion>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:MD6y1e0R9Z0RX9GT9IT2K4U3iFWzhu2u+lYU4HcqVIu0XVsN/6s
 YeGwqBWi5i4z3WZhjdj3jBSH/77k4VEvJJUZdBwMO5Gq7VcRQlGUNIYrU16TRuhf38dlJMK
 XHRVTJcuzeIUW0dzOjyG46AyrXBpfGg4N0kYAGeRlifKftB+esbATVXJjjOuMCkrAAjIO0X
 TYJrRBdj135uS711OslaA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DMI system ID of the Kontron COMe-cBL6 board to
the Kontron PLD driver. The list of supported products in the module
description is also updated.

Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
Acked-by: Christian Rauch <christian.rauch@kontron.com>
---
 drivers/mfd/Kconfig       |  1 +
 drivers/mfd/kempld-core.c | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 2e6b731..0c066b9 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -352,6 +352,7 @@ config MFD_KEMPLD
 		* COMe-bIP#
 		* COMe-bPC2 (ETXexpress-PC)
 		* COMe-bSC# (ETXexpress-SC T#)
+		* COMe-cBL6
 		* COMe-cBT6
 		* COMe-cCT6
 		* COMe-cDC2 (microETXexpress-DC)
diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
index f38ec42..61a1f9b 100644
--- a/drivers/mfd/kempld-core.c
+++ b/drivers/mfd/kempld-core.c
@@ -508,8 +508,15 @@ static struct dmi_system_id kempld_dmi_table[] __initdata = {
 		},
 		.driver_data = (void *)&kempld_platform_data_generic,
 		.callback = kempld_create_platform_device,
-	},
-	{
+	}, {
+		.ident = "CBL6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-cBL6"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
 		.ident = "CCR2",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
-- 
1.8.5.1


