Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbaG1D64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:58:56 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39424 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaG1D6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:58:53 -0400
From: Mohammad Merajul Islam Molla <meraj.enigma@gmail.com>
To: linux-pm@vger.kernel.org
Cc: rjw@rjwysocki.net, daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Mohammad Merajul Islam Molla <meraj.enigma@gmail.com>
Subject: [PATCH] cpuidle: ladder governor - use macro instead of hardcoded value
Date: Mon, 28 Jul 2014 09:58:50 +0600
Message-Id: <1406519930-5159-1-git-send-email-meraj.enigma@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use CPUIDLE_DRIVER_STATE_START, instead of hardcoded value 0. As,
CPUIDLE_DRIVER_STATE_START can be 1/0 based on
CONFIG_ARCH_HAS_CPU_RELAX is defined or not.

Signed-off-by: Mohammad Merajul Islam Molla <meraj.enigma@gmail.com>
---
 drivers/cpuidle/governors/ladder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index 9f08e8c..044ee0d 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -144,7 +144,7 @@ static int ladder_enable_device(struct cpuidle_driver *drv,
 
 	ldev->last_state_idx = CPUIDLE_DRIVER_STATE_START;
 
-	for (i = 0; i < drv->state_count; i++) {
+	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
 		state = &drv->states[i];
 		lstate = &ldev->states[i];
 
@@ -156,7 +156,7 @@ static int ladder_enable_device(struct cpuidle_driver *drv,
 
 		if (i < drv->state_count - 1)
 			lstate->threshold.promotion_time = state->exit_latency;
-		if (i > 0)
+		if (i > CPUIDLE_DRIVER_STATE_START)
 			lstate->threshold.demotion_time = state->exit_latency;
 	}
 
-- 
1.9.1

