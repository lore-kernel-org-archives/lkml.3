Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaJVTOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:14:41 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45154 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaJVTNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:13:25 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] eeepc-laptop: clean up control flow in eeepc_acpi_notify
Date: Wed, 22 Oct 2014 21:12:40 +0200
Message-Id: <1414005163-3461-6-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eeepc_acpi_notify increases the indentation level to a whopping four. If
we revise the conditions a bit, we can reduce that to a more soothing
two and satisfy the indentation guidelines in Documentation/CodingStyle.

Remove an unwanted space while we're in the neighbourhood.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 53 ++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 73e8d39..21ffe1f 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1213,7 +1213,7 @@ static void eeepc_input_exit(struct eeepc_laptop *eeepc)
 static void eeepc_input_notify(struct eeepc_laptop *eeepc, int event)
 {
 	if (!eeepc->inputdev)
-		return ;
+		return;
 	if (!sparse_keymap_report_event(eeepc->inputdev, event, 1, true))
 		pr_info("Unknown key %x pressed\n", event);
 }
@@ -1222,6 +1222,7 @@ static void eeepc_acpi_notify(struct acpi_device *device, u32 event)
 {
 	struct eeepc_laptop *eeepc = acpi_driver_data(device);
 	u16 count;
+	int old_brightness, new_brightness;
 
 	if (event > ACPI_MAX_SYS_NOTIFY)
 		return;
@@ -1231,34 +1232,32 @@ static void eeepc_acpi_notify(struct acpi_device *device, u32 event)
 					count);
 
 	/* Brightness events are special */
-	if (event >= NOTIFY_BRN_MIN && event <= NOTIFY_BRN_MAX) {
-
-		/* Ignore them completely if the acpi video driver is used */
-		if (eeepc->backlight_device != NULL) {
-			int old_brightness, new_brightness;
-
-			/* Update the backlight device. */
-			old_brightness = eeepc_backlight_notify(eeepc);
-
-			/* Convert event to keypress (obsolescent hack) */
-			new_brightness = event - NOTIFY_BRN_MIN;
-
-			if (new_brightness < old_brightness) {
-				event = NOTIFY_BRN_MIN; /* brightness down */
-			} else if (new_brightness > old_brightness) {
-				event = NOTIFY_BRN_MAX; /* brightness up */
-			} else {
-				/*
-				* no change in brightness - already at min/max,
-				* event will be desired value (or else ignored)
-				*/
-			}
-			eeepc_input_notify(eeepc, event);
-		}
-	} else {
-		/* Everything else is a bona-fide keypress event */
+	if (event < NOTIFY_BRN_MIN || event > NOTIFY_BRN_MAX) {
 		eeepc_input_notify(eeepc, event);
+		return;
+	}
+
+	/* Ignore them completely if the acpi video driver is used */
+	if (!eeepc->backlight_device)
+		return;
+
+	/* Update the backlight device. */
+	old_brightness = eeepc_backlight_notify(eeepc);
+
+	/* Convert event to keypress (obsolescent hack) */
+	new_brightness = event - NOTIFY_BRN_MIN;
+
+	if (new_brightness < old_brightness) {
+		event = NOTIFY_BRN_MIN; /* brightness down */
+	} else if (new_brightness > old_brightness) {
+		event = NOTIFY_BRN_MAX; /* brightness up */
+	} else {
+		/*
+		 * no change in brightness - already at min/max,
+		 * event will be desired value (or else ignored)
+		 */
 	}
+	eeepc_input_notify(eeepc, event);
 }
 
 static void eeepc_dmi_check(struct eeepc_laptop *eeepc)
-- 
2.1.0

