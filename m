Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbaEQOot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 10:44:49 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49660 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbaEQOoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 10:44:44 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-hotplug@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 2/2] dell-wmi: Add support for Fn key combinations
Date: Sat, 17 May 2014 16:43:37 +0200
Message-Id: <1400337817-14473-3-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400337817-14473-1-git-send-email-pali.rohar@gmail.com>
References: <201405171639.45722@pali>
 <1400337817-14473-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bios DMI table contains scancodes for some Fn key combinations. But
corresponding keycodes in DMI table have same value 255. And dell-wmi driver
map value 255 to KEY_PROG3. This means that it is not possible to distinguish
between Fn key combinations (e.g Fn+Q and Fn+W), because kernel reports for all
of them only KEY_PROG3.

This patch adding new table for mapping Bios DMI scancodes to linux keycodes
when bios DMI keycode is set to "generic" keycode 255. So different Fn key
combinations will have different keycodes.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/platform/x86/dell-wmi.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 390e8e3..c54d675 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -140,7 +140,27 @@ static const u16 bios_to_linux_keycode[256] __initconst = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	0, 0, 0, 0, 0, 0, 0, 0, 0, KEY_PROG3
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+};
+
+/* table for bios code 0xff */
+static const u16 scancode_to_linux_keycode[256] __initconst = {
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	KEY_FN_Q, KEY_FN_W, KEY_FN_E, KEY_FN_R,
+	KEY_FN_T, 0, 0, 0,
+	0, 0, 0, 0,
+	0, 0, KEY_FN_A, KEY_FN_S,
+	KEY_FN_D, KEY_FN_F, KEY_FN_G, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
 static struct input_dev *dell_wmi_input_dev;
@@ -212,6 +232,11 @@ static const struct key_entry * __init dell_wmi_prepare_new_keymap(void)
 		keymap[i].keycode = bios_entry->keycode < 256 ?
 				    bios_to_linux_keycode[bios_entry->keycode] :
 				    KEY_RESERVED;
+		if (bios_entry->keycode == 255 && bios_entry->scancode < 256)
+			keymap[i].keycode =
+				scancode_to_linux_keycode[bios_entry->scancode];
+		if (!keymap[i].keycode)
+			keymap[i].keycode = KEY_RESERVED;
 	}
 
 	keymap[hotkey_num].type = KE_END;
-- 
1.7.9.5

