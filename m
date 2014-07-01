Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaGAHAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:00:37 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64072 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaGAHAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:00:36 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: shalinmehta85@gmail.com, dan.carpenter@oracle.com, daeseok.youn@gmail.com,
        gregkh@linuxfoundation.org
Cc: speakup@braille.uwo.ca, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/1] staging: speakup: main.c - use time_after()
Date: Tue,  1 Jul 2014 12:30:22 +0530
Message-Id: <1404198022-19083-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this patch fixes jiffies comparision with a safer function to prevent
  any overflows

Signed-off-by: Anil Belur <askb23@gmail.com>
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
1.9.1

