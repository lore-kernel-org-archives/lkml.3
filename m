Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab3HAXry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:47:54 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:42329 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab3HAXrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:47:43 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Jiri Kosina <trivial@kernel.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 2/3] acpi: video: trivial style cleanups
Date: Thu,  1 Aug 2013 18:44:00 -0500
Message-Id: <1375400641-1694-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375400641-1694-1-git-send-email-felipe.contreras@gmail.com>
References: <1375400641-1694-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/video.c | 90 +++++++++++++++++++++++-----------------------------
 1 file changed, 40 insertions(+), 50 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index f021bf4..b07573f 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -88,7 +88,7 @@ module_param(allow_duplicates, bool, 0644);
 static bool use_bios_initial_backlight = 1;
 module_param(use_bios_initial_backlight, bool, 0644);
 
-static int register_count = 0;
+static int register_count;
 static int acpi_video_bus_add(struct acpi_device *device);
 static int acpi_video_bus_remove(struct acpi_device *device);
 static void acpi_video_bus_notify(struct acpi_device *device, u32 event);
@@ -247,7 +247,7 @@ static int acpi_video_get_brightness(struct backlight_device *bd)
 			 * The first two entries are special - see page 575
 			 * of the ACPI spec 3.0
 			 */
-			return i-2;
+			return i - 2;
 	}
 	return 0;
 }
@@ -304,11 +304,11 @@ video_set_cur_state(struct thermal_cooling_device *cooling_dev, unsigned long st
 	struct acpi_video_device *video = acpi_driver_data(device);
 	int level;
 
-	if ( state >= video->brightness->count - 2)
+	if (state >= video->brightness->count - 2)
 		return -EINVAL;
 
 	state = video->brightness->count - state;
-	level = video->brightness->levels[state -1];
+	level = video->brightness->levels[state - 1];
 	return acpi_video_device_lcd_set_level(video, level);
 }
 
@@ -349,7 +349,7 @@ acpi_video_device_lcd_query_levels(struct acpi_video_device *device,
 
 	return 0;
 
-      err:
+err:
 	kfree(buffer.pointer);
 
 	return status;
@@ -550,7 +550,7 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
 				if (device->brightness->levels[i] == *level) {
 					device->brightness->curr = *level;
 					return 0;
-			}
+				}
 			/*
 			 * BQC returned an invalid level.
 			 * Stop using it.
@@ -892,16 +892,13 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 {
 	acpi_handle h_dummy1;
 
-	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_ADR", &h_dummy1))) {
+	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_ADR", &h_dummy1)))
 		device->cap._ADR = 1;
-	}
-	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_BCL", &h_dummy1))) {
+	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_BCL", &h_dummy1)))
 		device->cap._BCL = 1;
-	}
-	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_BCM", &h_dummy1))) {
+	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_BCM", &h_dummy1)))
 		device->cap._BCM = 1;
-	}
-	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle,"_BQC",&h_dummy1)))
+	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_BQC", &h_dummy1)))
 		device->cap._BQC = 1;
 	else if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_BCQ",
 				&h_dummy1))) {
@@ -909,9 +906,8 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 		device->cap._BCQ = 1;
 	}
 
-	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_DDC", &h_dummy1))) {
+	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_DDC", &h_dummy1)))
 		device->cap._DDC = 1;
-	}
 
 	if (acpi_video_init_brightness(device))
 		return;
@@ -922,7 +918,7 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 		acpi_handle acpi_parent;
 		struct device *parent = NULL;
 		int result;
-		static int count = 0;
+		static int count;
 		char *name;
 
 		name = kasprintf(GFP_KERNEL, "acpi_video%d", count);
@@ -1006,24 +1002,18 @@ static void acpi_video_bus_find_cap(struct acpi_video_bus *video)
 {
 	acpi_handle h_dummy1;
 
-	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_DOS", &h_dummy1))) {
+	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_DOS", &h_dummy1)))
 		video->cap._DOS = 1;
-	}
-	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_DOD", &h_dummy1))) {
+	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_DOD", &h_dummy1)))
 		video->cap._DOD = 1;
-	}
-	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_ROM", &h_dummy1))) {
+	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_ROM", &h_dummy1)))
 		video->cap._ROM = 1;
-	}
-	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_GPD", &h_dummy1))) {
+	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_GPD", &h_dummy1)))
 		video->cap._GPD = 1;
-	}
-	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_SPD", &h_dummy1))) {
+	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_SPD", &h_dummy1)))
 		video->cap._SPD = 1;
-	}
-	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_VPO", &h_dummy1))) {
+	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_VPO", &h_dummy1)))
 		video->cap._VPO = 1;
-	}
 }
 
 /*
@@ -1082,7 +1072,7 @@ static int acpi_video_bus_check(struct acpi_video_bus *video)
  */
 
 /* device interface */
-static struct acpi_video_device_attrib*
+static struct acpi_video_device_attrib *
 acpi_video_get_device_attr(struct acpi_video_bus *video, unsigned long device_id)
 {
 	struct acpi_video_enumerated_device *ids;
@@ -1120,7 +1110,7 @@ acpi_video_bus_get_one_device(struct acpi_device *device,
 	unsigned long long device_id;
 	int status, device_type;
 	struct acpi_video_device *data;
-	struct acpi_video_device_attrib* attribute;
+	struct acpi_video_device_attrib *attribute;
 
 	status =
 	    acpi_evaluate_integer(device->handle, "_ADR", NULL, &device_id);
@@ -1142,7 +1132,7 @@ acpi_video_bus_get_one_device(struct acpi_device *device,
 
 	attribute = acpi_video_get_device_attr(video, device_id);
 
-	if((attribute != NULL) && attribute->device_id_scheme) {
+	if (attribute && attribute->device_id_scheme) {
 		switch (attribute->display_type) {
 		case ACPI_VIDEO_DISPLAY_CRT:
 			data->flags.crt = 1;
@@ -1160,24 +1150,24 @@ acpi_video_bus_get_one_device(struct acpi_device *device,
 			data->flags.unknown = 1;
 			break;
 		}
-		if(attribute->bios_can_detect)
+		if (attribute->bios_can_detect)
 			data->flags.bios = 1;
 	} else {
 		/* Check for legacy IDs */
 		device_type = acpi_video_get_device_type(video, device_id);
 		/* Ignore bits 16 and 18-20 */
 		switch (device_type & 0xffe2ffff) {
-			case ACPI_VIDEO_DISPLAY_LEGACY_MONITOR:
-				data->flags.crt = 1;
-				break;
-			case ACPI_VIDEO_DISPLAY_LEGACY_PANEL:
-				data->flags.lcd = 1;
-				break;
-			case ACPI_VIDEO_DISPLAY_LEGACY_TV:
-				data->flags.tvout = 1;
-				break;
-			default:
-				data->flags.unknown = 1;
+		case ACPI_VIDEO_DISPLAY_LEGACY_MONITOR:
+			data->flags.crt = 1;
+			break;
+		case ACPI_VIDEO_DISPLAY_LEGACY_PANEL:
+			data->flags.lcd = 1;
+			break;
+		case ACPI_VIDEO_DISPLAY_LEGACY_TV:
+			data->flags.tvout = 1;
+			break;
+		default:
+			data->flags.unknown = 1;
 		}
 	}
 
@@ -1318,7 +1308,7 @@ static int acpi_video_device_enumerate(struct acpi_video_bus *video)
 	video->attached_array = active_list;
 	video->attached_count = count;
 
- out:
+out:
 	kfree(buffer.pointer);
 	return status;
 }
@@ -1773,7 +1763,7 @@ static int acpi_video_bus_add(struct acpi_device *device)
 	if (!strcmp(device->pnp.bus_id, "VID")) {
 		if (instance)
 			device->pnp.bus_id[3] = '0' + instance;
-		instance ++;
+		instance++;
 	}
 	/* a hack to fix the duplicate name "VGA" problem on Pa 3553 */
 	if (!strcmp(device->pnp.bus_id, "VGA")) {
@@ -1845,16 +1835,16 @@ static int acpi_video_bus_add(struct acpi_device *device)
 
 	return 0;
 
- err_unregister_pm_notifier:
+err_unregister_pm_notifier:
 	unregister_pm_notifier(&video->pm_nb);
- err_stop_video:
+err_stop_video:
 	acpi_video_bus_stop_devices(video);
- err_free_input_dev:
+err_free_input_dev:
 	input_free_device(input);
- err_put_video:
+err_put_video:
 	acpi_video_bus_put_devices(video);
 	kfree(video->attached_array);
- err_free_video:
+err_free_video:
 	kfree(video);
 	device->driver_data = NULL;
 
-- 
1.8.3.4

