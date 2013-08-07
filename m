Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3HGHxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:53:05 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:18435 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab3HGHxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:53:04 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, John Stultz <john.stultz@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Bo Shen <voice.shen@atmel.com>
Subject: [RFC PATCH] clock: correct the comparison parameter of MHz
Date: Wed,  7 Aug 2013 15:47:40 +0800
Message-Id: <1375861660-32525-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

correct the comparison parameter of MHz from 4,000,000 to 1,000,000

Signed-off-by: Bo Shen <voice.shen@atmel.com>

---
 kernel/time/sched_clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index a326f27..62885f7 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -128,7 +128,7 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 0);
 
 	r = rate;
-	if (r >= 4000000) {
+	if (r >= 1000000) {
 		r /= 1000000;
 		r_unit = 'M';
 	} else if (r >= 1000) {
-- 
1.7.9.5

