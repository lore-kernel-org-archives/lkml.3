Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaKIIg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 03:36:28 -0500
Received: from marmot.wormnet.eu ([188.246.204.87]:57752 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaKIIg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 03:36:26 -0500
X-Greylist: delayed 2450 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2014 03:36:26 EST
From: Jamie Lentin <jm@lentin.co.uk>
To: Jiri Kosina <jkosina@suse.cz>, Antonio Ospite <ao2@ao2.it>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Lentin <jm@lentin.co.uk>
Subject: [PATCH 1/2] HID: lenovo: Move USB KEY_FILE to 0x00f9 to prevent scancode clash
Date: Sun,  9 Nov 2014 07:54:29 +0000
Message-Id: <1415519670-24449-2-git-send-email-jm@lentin.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415519670-24449-1-git-send-email-jm@lentin.co.uk>
References: <1415519670-24449-1-git-send-email-jm@lentin.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bluetooth keyboard also generates 0x00fa when the middle button is
pressed. Move the made-up report out of the way so we don't trigger
KEY_FILE when middle button is pressed

Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
---
 drivers/hid/hid-lenovo.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index bf227f7..4716f1e 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -85,13 +85,13 @@ static int lenovo_input_mapping_cptkbd(struct hid_device *hdev,
 		case 0x00f8: /* Fn-F11: View open applications (3 boxes) */
 			map_key_clear(KEY_SCALE);
 			return 1;
-		case 0x00fa: /* Fn-Esc: Fn-lock toggle */
-			map_key_clear(KEY_FN_ESC);
-			return 1;
-		case 0x00fb: /* Fn-F12: Open My computer (6 boxes) USB-only */
+		case 0x00f9: /* Fn-F12: Open My computer (6 boxes) USB-only */
 			/* NB: This mapping is invented in raw_event below */
 			map_key_clear(KEY_FILE);
 			return 1;
+		case 0x00fa: /* Fn-Esc: Fn-lock toggle */
+			map_key_clear(KEY_FN_ESC);
+			return 1;
 		}
 	}
 
@@ -207,8 +207,8 @@ static int lenovo_raw_event(struct hid_device *hdev,
 			&& data[0] == 0x15
 			&& data[1] == 0x94
 			&& data[2] == 0x01)) {
-		data[1] = 0x0;
-		data[2] = 0x4;
+		data[1] = 0x00;
+		data[2] = 0x01;
 	}
 
 	return 0;
-- 
2.1.0

