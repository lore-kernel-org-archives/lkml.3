Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaDDOnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:43:49 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36213 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaDDOns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:43:48 -0400
From: Stephen Chandler Paul <thatslyude@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Shawn Rutledge <shawn.t.rutledge@gmail.com>
Subject: [PATCH] Favor native backlight interface for ThinkPad Helix
Date: Fri,  4 Apr 2014 10:44:46 -0400
Message-Id: <1396622686-6373-1-git-send-email-thatslyude@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like many other Windows 8 laptops the ThinkPad Helix's backlight has a
broken ACPI interface and can only be properly adjusted by using the
video card's native backlight control. This adds the ThinkPad Helix to
the list of laptops affected with this issue so that
video.use_native_backlight is enabled by default.

Signed-off-by: Stephen Chandler Paul <thatslyude@gmail.com>
---
 drivers/acpi/video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 48c7e8a..8b6990e 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -488,6 +488,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 		},
 	},
 	{
+	.callback = video_set_use_native_backlight,
+	.ident = "Thinkpad Helix",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad Helix"),
+		},
+	},
+	{
 	 .callback = video_set_use_native_backlight,
 	 .ident = "Dell Inspiron 7520",
 	 .matches = {
-- 
1.8.3.2

