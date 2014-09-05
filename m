Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaIEROa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:14:30 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62851 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaIERO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:14:26 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        Darren Hart <dvhart@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 1/5] toshiba_acpi: Additional hotkey scancodes
Date: Fri,  5 Sep 2014 11:14:03 -0600
Message-Id: <1409937247-2525-2-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Appart from reporting hotkeys, the INFO method is used
as a system wide event notifier for hardware or
software changes.

This patch adds additional "events" to the keymap list,
ignored by now, until we find them a good use.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index b062d3d..a149bc6 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -190,6 +190,7 @@ static const struct key_entry toshiba_acpi_keymap[] = {
 	{ KE_KEY, 0x101, { KEY_MUTE } },
 	{ KE_KEY, 0x102, { KEY_ZOOMOUT } },
 	{ KE_KEY, 0x103, { KEY_ZOOMIN } },
+	{ KE_KEY, 0x10f, { KEY_TAB } },
 	{ KE_KEY, 0x12c, { KEY_KBDILLUMTOGGLE } },
 	{ KE_KEY, 0x139, { KEY_ZOOMRESET } },
 	{ KE_KEY, 0x13b, { KEY_COFFEE } },
@@ -210,7 +211,11 @@ static const struct key_entry toshiba_acpi_keymap[] = {
 	{ KE_KEY, 0xb32, { KEY_NEXTSONG } },
 	{ KE_KEY, 0xb33, { KEY_PLAYPAUSE } },
 	{ KE_KEY, 0xb5a, { KEY_MEDIA } },
-	{ KE_IGNORE, 0x1430, { KEY_RESERVED } },
+	{ KE_IGNORE, 0x1430, { KEY_RESERVED } }, /* Wake from sleep */
+	{ KE_IGNORE, 0x1501, { KEY_RESERVED } }, /* Output changed */
+	{ KE_IGNORE, 0x1502, { KEY_RESERVED } }, /* HDMI plugged/unplugged */
+	{ KE_IGNORE, 0x1ABE, { KEY_RESERVED } }, /* Protection level set */
+	{ KE_IGNORE, 0x1ABF, { KEY_RESERVED } }, /* Protection level off */
 	{ KE_END, 0 },
 };
 
-- 
2.0.0

