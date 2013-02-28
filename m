Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab3B1OsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:48:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42163 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab3B1OsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 060/139] HID: wiimote: fix nunchuck button parser
Date: Thu, 28 Feb 2013 14:43:30 +0000
Message-Id: <1362062689-2567-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Herrmann <dh.herrmann@gmail.com>

commit 89bdd0c6f38ccf0de43d5a36ede384a730f3394e upstream.

The buttons of the Wii Remote Nunchuck extension are actually active low.
Fix the parser to forward the inverted values. The comment in the function
always said "0 == pressed" but the implementation was wrong from the
beginning.

Reported-by: Victor Quicksilver <victor.quicksilver@gmail.com>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-wiimote-ext.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-wiimote-ext.c b/drivers/hid/hid-wiimote-ext.c
index aa95870..9e57285 100644
--- a/drivers/hid/hid-wiimote-ext.c
+++ b/drivers/hid/hid-wiimote-ext.c
@@ -378,14 +378,14 @@ static void handler_nunchuck(struct wiimote_ext *ext, const __u8 *payload)
 
 	if (ext->motionp) {
 		input_report_key(ext->input,
-			wiiext_keymap[WIIEXT_KEY_Z], !!(payload[5] & 0x04));
+			wiiext_keymap[WIIEXT_KEY_Z], !(payload[5] & 0x04));
 		input_report_key(ext->input,
-			wiiext_keymap[WIIEXT_KEY_C], !!(payload[5] & 0x08));
+			wiiext_keymap[WIIEXT_KEY_C], !(payload[5] & 0x08));
 	} else {
 		input_report_key(ext->input,
-			wiiext_keymap[WIIEXT_KEY_Z], !!(payload[5] & 0x01));
+			wiiext_keymap[WIIEXT_KEY_Z], !(payload[5] & 0x01));
 		input_report_key(ext->input,
-			wiiext_keymap[WIIEXT_KEY_C], !!(payload[5] & 0x02));
+			wiiext_keymap[WIIEXT_KEY_C], !(payload[5] & 0x02));
 	}
 
 	input_sync(ext->input);
-- 
1.8.1.2

