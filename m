Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaKBVPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 16:15:35 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46730 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaKBVPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 16:15:31 -0500
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] eeepc-laptop: clean up control flow in eeepc_acpi_notify
Date: Sun,  2 Nov 2014 22:14:58 +0100
Message-Id: <1414962898-13917-1-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20141028052517.GG60814@vmdeb7>
References: <20141028052517.GG60814@vmdeb7>
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
index 73e8d39..03ffbce 100644
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
@@ -1221,6 +1221,7 @@ static void eeepc_input_notify(struct eeepc_laptop *eeepc, int event)
 static void eeepc_acpi_notify(struct acpi_device *device, u32 event)
 {
 	struct eeepc_laptop *eeepc = acpi_driver_data(device);
+	int old_brightness, new_brightness;
 	u16 count;
 
 	if (event > ACPI_MAX_SYS_NOTIFY)
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

