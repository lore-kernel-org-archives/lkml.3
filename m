Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967911Ab3HIPeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:34:06 -0400
Received: from mailout08.t-online.de ([194.25.134.20]:48089 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965066Ab3HIPeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:34:04 -0400
Date: Fri, 9 Aug 2013 17:33:43 +0200
From: "Michael Brunner" <BrunnerMichael@t-online.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Chris Healy <chealy@imsco-us.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] mfd: Add support for COMe-bHL6 and COMe-cTH6 to Kontron PLD
 driver
Message-ID: <20130809173343.7843a13a@charybdis>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ID: XR33FqZQZhW50k2xN5nJLc-rU+VPWRt2J1s4xJbuYxRk7W3-RAHRC0P0V9QD4zpgEX
X-TOI-MSGID: f70833c5-51f0-4dbb-9054-7922c1a050d8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DMI system IDs for the new Kontron modules COMe-bHL6 and
COMe-cTH6 to the Kontron PLD driver.

Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
---
 drivers/mfd/kempld-core.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
index 686a456..ee28e76 100644
--- a/drivers/mfd/kempld-core.c
+++ b/drivers/mfd/kempld-core.c
@@ -413,6 +413,15 @@ static struct platform_driver kempld_driver = {
 
 static struct dmi_system_id __initdata kempld_dmi_table[] = {
 	{
+		.ident = "BHL6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-bHL6"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	},
+	{
 		.ident = "CCR2",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
@@ -596,6 +605,15 @@ static struct dmi_system_id __initdata kempld_dmi_table[] = {
 		.driver_data = (void *)&kempld_platform_data_generic,
 		.callback = kempld_create_platform_device,
 	},
+	{
+		.ident = "UTH6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-cTH6"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(dmi, kempld_dmi_table);
