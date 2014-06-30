Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaF3MGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:06:46 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52037 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 084/181] ACPI / video: clean up DMI table for initial black screen problem
Date: Mon, 30 Jun 2014 13:51:45 +0200
Message-Id: <594d724ed36a435885cd599e78f2f917a7171eef.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Lu <aaron.lu@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 545ef368e08fda654b6e63ce522c66339aa29156 upstream.

With commit 2c62333a408f "ACPI / video: Quirk initial backlight level 0"
we do not need to have the following systems in DMI table, so remove them.
HP Pavilion m4, HP 1000 Notebook PC, HP Pavilion g6 Notebook PC,
HP Pavilion dm4, Fujitsu E753, HP Folio 13-2000.

With this change, the use_bios_initial_backlight module parameter is no
longer needed and thus removed.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Alex Hung <alex.hung@canonical.com> # for HP 1000 Notebook PC
Tested-by: Gustavo Maciel Dias Vieira <gustavo@sagui.org> # for HP Pavilion dm4
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Conflicts:
	drivers/acpi/video.c
---
 drivers/acpi/video.c | 87 ++++++++--------------------------------------------
 1 file changed, 12 insertions(+), 75 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index d2e069044a0f..47e4deb9dfcd 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -81,13 +81,6 @@ module_param(brightness_switch_enabled, bool, 0644);
 static bool allow_duplicates;
 module_param(allow_duplicates, bool, 0644);
 
-/*
- * Some BIOSes claim they use minimum backlight at boot,
- * and this may bring dimming screen after boot
- */
-static bool use_bios_initial_backlight = 1;
-module_param(use_bios_initial_backlight, bool, 0644);
-
 static int register_count;
 static int acpi_video_bus_add(struct acpi_device *device);
 static int acpi_video_bus_remove(struct acpi_device *device);
@@ -388,12 +381,6 @@ static int __init video_set_bqc_offset(const struct dmi_system_id *d)
 	return 0;
 }
 
-static int video_ignore_initial_backlight(const struct dmi_system_id *d)
-{
-	use_bios_initial_backlight = 0;
-	return 0;
-}
-
 static struct dmi_system_id video_dmi_table[] __initdata = {
 	/*
 	 * Broken _BQC workaround http://bugzilla.kernel.org/show_bug.cgi?id=13121
@@ -438,54 +425,6 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 7720"),
 		},
 	},
-	{
-	 .callback = video_ignore_initial_backlight,
-	 .ident = "HP Folio 13-2000",
-	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13 - 2000 Notebook PC"),
-		},
-	},
-	{
-	 .callback = video_ignore_initial_backlight,
-	 .ident = "Fujitsu E753",
-	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "FUJITSU"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E753"),
-		},
-	},
-	{
-	 .callback = video_ignore_initial_backlight,
-	 .ident = "HP Pavilion dm4",
-	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dm4 Notebook PC"),
-		},
-	},
-	{
-	 .callback = video_ignore_initial_backlight,
-	 .ident = "HP Pavilion g6 Notebook PC",
-	 .matches = {
-		 DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-		 DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion g6 Notebook PC"),
-		},
-	},
-	{
-	 .callback = video_ignore_initial_backlight,
-	 .ident = "HP 1000 Notebook PC",
-	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP 1000 Notebook PC"),
-		},
-	},
-	{
-	 .callback = video_ignore_initial_backlight,
-	 .ident = "HP Pavilion m4",
-	 .matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion m4 Notebook PC"),
-		},
-	},
 	{}
 };
 
@@ -827,20 +766,18 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 	if (!device->cap._BQC)
 		goto set_level;
 
-	if (use_bios_initial_backlight) {
-		level = acpi_video_bqc_value_to_level(device, level_old);
-		/*
-		 * On some buggy laptops, _BQC returns an uninitialized
-		 * value when invoked for the first time, i.e.
-		 * level_old is invalid (no matter whether it's a level
-		 * or an index). Set the backlight to max_level in this case.
-		 */
-		for (i = 2; i < br->count; i++)
-			if (level == br->levels[i])
-				break;
-		if (i == br->count || !level)
-			level = max_level;
-	}
+	level = acpi_video_bqc_value_to_level(device, level_old);
+	/*
+	 * On some buggy laptops, _BQC returns an uninitialized
+	 * value when invoked for the first time, i.e.
+	 * level_old is invalid (no matter whether it's a level
+	 * or an index). Set the backlight to max_level in this case.
+	 */
+	for (i = 2; i < br->count; i++)
+		if (level == br->levels[i])
+			break;
+	if (i == br->count || !level)
+		level = max_level;
 
 set_level:
 	result = acpi_video_device_lcd_set_level(device, level);
-- 
2.0.0

