Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3BUUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:16:29 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:49445 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3BUUPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:15:17 -0500
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: olofj@chromium.org, miletus@chromium.org,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 3/6] Platform: x86: chromeos_laptop - Add isl light sensor for Pixel
Date: Thu, 21 Feb 2013 12:14:57 -0800
Message-Id: <1361477700-26342-4-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361477700-26342-1-git-send-email-bleung@chromium.org>
References: <1361477700-26342-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Chromebook Pixel uses an isl29023 ambient light sensor on the PANEL
GMBus.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index d585548..3e405d7 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -180,6 +180,14 @@ static int __init setup_isl29018_als(const struct dmi_system_id *id)
 	return 0;
 }
 
+static int __init setup_isl29023_als(const struct dmi_system_id *id)
+{
+	/* add isl29023 light sensor on Panel GMBus */
+	als = add_i2c_device("lightsensor", I2C_ADAPTER_PANEL,
+			     &isl_als_device);
+	return 0;
+}
+
 static int __init setup_tsl2583_als(const struct dmi_system_id *id)
 {
 	/* add tsl2583 light sensor on smbus */
@@ -212,6 +220,14 @@ static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
 		.callback = setup_isl29018_als,
 	},
 	{
+		.ident = "Chromebook Pixel - Light Sensor",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Link"),
+		},
+		.callback = setup_isl29023_als,
+	},
+	{
 		.ident = "Acer C7 Chromebook - Touchpad",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Parrot"),
-- 
1.8.1.3

