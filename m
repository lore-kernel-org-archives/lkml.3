Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaF3N0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:26:03 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53575 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaF3N0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:26:00 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: rusty@rustcorp.com.au, aybuke.147@gmail.com, kirk@reisers.ca,
        gregkh@linuxfoundation.org
Cc: speakup@braille.uwo.ca, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/1] staging: speakup: speakup_dectlk.c - use time_before_eq()
Date: Mon, 30 Jun 2014 18:55:48 +0530
Message-Id: <1404134748-25874-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this replaces jiffies comparision with safer function using
  time_after_eq()

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/speakup/speakup_dectlk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/speakup_dectlk.c b/drivers/staging/speakup/speakup_dectlk.c
index af84868..c07c967 100644
--- a/drivers/staging/speakup/speakup_dectlk.c
+++ b/drivers/staging/speakup/speakup_dectlk.c
@@ -267,7 +267,7 @@ static void do_catch_up(struct spk_synth *synth)
 		else if (ch <= SPACE) {
 			if (!in_escape && strchr(",.!?;:", last))
 				spk_serial_out(PROCSPEECH);
-			if (jiffies >= jiff_max) {
+			if (time_after_eq(jiffies, jiff_max)) {
 				if (!in_escape)
 					spk_serial_out(PROCSPEECH);
 				spin_lock_irqsave(&speakup_info.spinlock,
-- 
1.9.1

