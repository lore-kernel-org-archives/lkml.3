Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896AbaKLBhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:37:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933879AbaKLBg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:36:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olivier Gay <ogay@logitech.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.17 319/319] HID: add keyboard input assist hid usages
Date: Wed, 12 Nov 2014 10:17:37 +0900
Message-Id: <20141112011045.710023296@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Gay <ogay@logitech.com>

commit f974008f07a62171a9dede08250c9a35c2b2b986 upstream.

Add keyboard input assist controls usages from approved
hid usage table request HUTTR42:
http://www.usb.org/developers/hidpage/HUTRR42c.pdf

Signed-off-by: Olivier Gay <ogay@logitech.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-debug.c    |    6 ++++++
 drivers/hid/hid-input.c    |    7 +++++++
 include/uapi/linux/input.h |    7 +++++++
 3 files changed, 20 insertions(+)

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
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -859,6 +859,13 @@ static void hidinput_configure_usage(str
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
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -739,6 +739,13 @@ struct input_keymap_entry {
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


