Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaFLXVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:21:13 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:65373 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaFLXVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:21:11 -0400
From: Robin Schroer <sulamiification@gmail.com>
To: w.d.hubbs@gmail.com
Cc: gregkh@linuxfoundation.org, speakup@braille.uwo.ca,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Robin Schroer <sulamiification@gmail.com>
Subject: [PATCH] drivers/staging/speakup/main: fixed jiffie comparison
Date: Fri, 13 Jun 2014 01:21:05 +0200
Message-Id: <1402615265-22524-1-git-send-email-sulamiification@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

speakup_key() used manual comparison of jiffies to determine the time
since the last keypress, replaced it with time_after()

Resend with kernel mailing list cc'ed (duh...)

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 drivers/staging/speakup/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index 7de79d5..0cd3cdb 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -2067,7 +2067,7 @@ speakup_key(struct vc_data *vc, int shift_state, int keycode, u_short keysym,
 			if (up_flag)
 				goto out;
 			if (last_keycode == keycode &&
-			    last_spk_jiffy + MAX_DELAY > jiffies) {
+			    time_after(last_spk_jiffy + MAX_DELAY, jiffies)) {
 				spk_close_press = 1;
 				offset = spk_shift_table[shift_info + 32];
 				/* double press? */
-- 
1.9.3

