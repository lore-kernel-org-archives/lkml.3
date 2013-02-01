Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3BAWgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:36:05 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34382 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab3BAWfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:35:06 -0500
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, olofj@chromium.org, olof@lixom.net
Subject: [PATCH 2/4] Platform: x86: chromeos_laptop - Add Acer C7 trackpad
Date: Fri,  1 Feb 2013 14:34:44 -0800
Message-Id: <1359758086-2320-3-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359758086-2320-1-git-send-email-bleung@chromium.org>
References: <1359758086-2320-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Acer C7's trackpad, which is a reuse
of the Samsung Series 5 550 trackpad.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index 6440d22..9293c66 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -176,6 +176,13 @@ static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
 		},
 		.callback = setup_isl29018_als,
 	},
+	{
+		.ident = "Acer C7 Chromebook - Touchpad",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "Parrot"),
+		},
+		.callback = setup_cyapa_smbus_tp,
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(dmi, chromeos_laptop_dmi_table);
-- 
1.8.1

