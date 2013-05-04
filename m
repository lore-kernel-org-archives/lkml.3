Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761161Ab3EDQ0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 12:26:17 -0400
Received: from mail-gg0-f178.google.com ([209.85.161.178]:37213 "EHLO
	mail-gg0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761004Ab3EDQ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 12:26:15 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 May 2013 12:26:15 EDT
Date: Sat, 4 May 2013 11:21:17 -0400
From: Jake Champlin <jake.champlin.27@gmail.com>
To: willy@meta-x.org, gregkh@linuxfoundation.org, yamanetoshi@gmail.com,
        adam.buchbinder@gmail.com, peterhuewe@gmx.de, fengguang.wu@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: Panel: panel: Fixed checkpatch line length warnings
Message-ID: <20130504152058.GA20790@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed 4 cases of line length issues with checkpatch. Checkpatch is now clean
for panel.c.

Signed-off-by: 'Jake Champlin <jake.champlin.27@gmail.com>'
---
 drivers/staging/panel/panel.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index c54df39..cbc15c1 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1756,17 +1756,18 @@ static inline int input_state_high(struct logical_input *input)
 
 			if (input->high_timer == 0) {
 				char *press_str = input->u.kbd.press_str;
-				if (press_str[0])
-					keypad_send_key(press_str,
-							sizeof(input->u.kbd.press_str));
+				if (press_str[0]) {
+					int s = sizeof(input->u.kbd.press_str);
+					keypad_send_key(press_str, s);
+				}
 			}
 
 			if (input->u.kbd.repeat_str[0]) {
 				char *repeat_str = input->u.kbd.repeat_str;
 				if (input->high_timer >= KEYPAD_REP_START) {
+					int s = sizeof(input->u.kbd.repeat_str);
 					input->high_timer -= KEYPAD_REP_DELAY;
-					keypad_send_key(repeat_str,
-							sizeof(input->u.kbd.repeat_str));
+					keypad_send_key(repeat_str, s);
 				}
 				/* we will need to come back here soon */
 				inputs_stable = 0;
@@ -1802,10 +1803,11 @@ static inline void input_state_falling(struct logical_input *input)
 
 			if (input->u.kbd.repeat_str[0]) {
 				char *repeat_str = input->u.kbd.repeat_str;
-				if (input->high_timer >= KEYPAD_REP_START)
+				if (input->high_timer >= KEYPAD_REP_START) {
+					int s = sizeof(input->u.kbd.repeat_str);
 					input->high_timer -= KEYPAD_REP_DELAY;
-					keypad_send_key(repeat_str,
-							sizeof(input->u.kbd.repeat_str));
+					keypad_send_key(repeat_str, s);
+				}
 				/* we will need to come back here soon */
 				inputs_stable = 0;
 			}
@@ -1822,9 +1824,10 @@ static inline void input_state_falling(struct logical_input *input)
 				release_fct(input->u.std.release_data);
 		} else if (input->type == INPUT_TYPE_KBD) {
 			char *release_str = input->u.kbd.release_str;
-			if (release_str[0])
-				keypad_send_key(release_str,
-						sizeof(input->u.kbd.release_str));
+			if (release_str[0]) {
+				int s = sizeof(input->u.kbd.release_str);
+				keypad_send_key(release_str, s);
+			}
 		}
 
 		input->state = INPUT_ST_LOW;
-- 
1.8.2.1


-- 
Jake Champlin
jake.champlin.27@gmail.com
<MuttClient>
