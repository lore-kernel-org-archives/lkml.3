Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab3B0Ang (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:43:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab3BZX6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Victor Quicksilver <victor.quicksilver@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 121/150] HID: wiimote: fix nunchuck button parser
Date: Tue, 26 Feb 2013 15:56:18 -0800
Message-Id: <20130226235536.671743228@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-wiimote-ext.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-wiimote-ext.c
+++ b/drivers/hid/hid-wiimote-ext.c
@@ -403,14 +403,14 @@ static void handler_nunchuck(struct wiim
 
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


