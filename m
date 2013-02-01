Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181Ab3BAWfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:35:11 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:49600 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913Ab3BAWfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:35:03 -0500
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, olofj@chromium.org, olof@lixom.net
Subject: [PATCH 1/4] Platform: x86: chromeos_laptop - Rename setup_lumpy_tp to setup_cyapa_smbus_tp
Date: Fri,  1 Feb 2013 14:34:43 -0800
Message-Id: <1359758086-2320-2-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359758086-2320-1-git-send-email-bleung@chromium.org>
References: <1359758086-2320-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Cypress trackpad on smbus is used on other systems
as well. Lets make the name more generic.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index a8329c3..6440d22 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -145,7 +145,7 @@ static struct i2c_client __init *add_smbus_device(const char *name,
 				       addr_list);
 }
 
-static int __init setup_lumpy_tp(const struct dmi_system_id *id)
+static int __init setup_cyapa_smbus_tp(const struct dmi_system_id *id)
 {
 	/* add cyapa touchpad on smbus */
 	tp = add_smbus_device("trackpad", &cyapa_device);
@@ -166,7 +166,7 @@ static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Lumpy"),
 		},
-		.callback = setup_lumpy_tp,
+		.callback = setup_cyapa_smbus_tp,
 	},
 	{
 		.ident = "Samsung Series 5 550 - Light Sensor",
-- 
1.8.1

