Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaKYLVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:21:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58724 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaKYKmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olivier Gay <ogay@logitech.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 143/254] HID: add keyboard input assist hid usages
Date: Tue, 25 Nov 2014 10:38:13 +0000
Message-Id: <1416912004-5928-144-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Gay <ogay@logitech.com>

commit f974008f07a62171a9dede08250c9a35c2b2b986 upstream.

Add keyboard input assist controls usages from approved
hid usage table request HUTTR42:
http://www.usb.org/developers/hidpage/HUTRR42c.pdf

Signed-off-by: Olivier Gay <ogay@logitech.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-debug.c    | 6 ++++++
 drivers/hid/hid-input.c    | 7 +++++++
 include/uapi/linux/input.h | 7 +++++++
 3 files changed, 20 insertions(+)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 84c3cb15ccdd..8bf61d295ffd 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -946,6 +946,12 @@ static const char *keys[KEY_MAX + 1] = {
 	[KEY_BRIGHTNESS_MIN] = "BrightnessMin",
 	[KEY_BRIGHTNESS_MAX] = "BrightnessMax",
 	[KEY_BRIGHTNESS_AUTO] = "BrightnessAuto",
+	[KEY_KBDINPUTASSIST_PREV] = "KbdInputAssistPrev",
+	[KEY_KBDINPUTASSIST_NEXT] = "KbdInputAssistNext",
+	[KEY_KBDINPUTASSIST_PREVGROUP] = "KbdInputAssistPrevGroup",
+	[KEY_KBDINPUTASSIST_NEXTGROUP] = "KbdInputAssistNextGroup",
+	[KEY_KBDINPUTASSIST_ACCEPT] = "KbdInputAssistAccept",
+	[KEY_KBDINPUTASSIST_CANCEL] = "KbdInputAssistCancel",
 };
 
 static const char *relatives[REL_MAX + 1] = {
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index cb1b3faedb97..62e828655922 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -859,6 +859,13 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x28b: map_key_clear(KEY_FORWARDMAIL);	break;
 		case 0x28c: map_key_clear(KEY_SEND);		break;
 
+		case 0x2c7: map_key_clear(KEY_KBDINPUTASSIST_PREV);		break;
+		case 0x2c8: map_key_clear(KEY_KBDINPUTASSIST_NEXT);		break;
+		case 0x2c9: map_key_clear(KEY_KBDINPUTASSIST_PREVGROUP);		break;
+		case 0x2ca: map_key_clear(KEY_KBDINPUTASSIST_NEXTGROUP);		break;
+		case 0x2cb: map_key_clear(KEY_KBDINPUTASSIST_ACCEPT);	break;
+		case 0x2cc: map_key_clear(KEY_KBDINPUTASSIST_CANCEL);	break;
+
 		default:    goto ignore;
 		}
 		break;
diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index 19df18c9b8be..9be8c13b0cbf 100644
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -738,6 +738,13 @@ struct input_keymap_entry {
 #define KEY_BRIGHTNESS_MIN		0x250	/* Set Brightness to Minimum */
 #define KEY_BRIGHTNESS_MAX		0x251	/* Set Brightness to Maximum */
 
+#define KEY_KBDINPUTASSIST_PREV		0x260
+#define KEY_KBDINPUTASSIST_NEXT		0x261
+#define KEY_KBDINPUTASSIST_PREVGROUP		0x262
+#define KEY_KBDINPUTASSIST_NEXTGROUP		0x263
+#define KEY_KBDINPUTASSIST_ACCEPT		0x264
+#define KEY_KBDINPUTASSIST_CANCEL		0x265
+
 #define BTN_TRIGGER_HAPPY		0x2c0
 #define BTN_TRIGGER_HAPPY1		0x2c0
 #define BTN_TRIGGER_HAPPY2		0x2c1
-- 
2.1.0

