Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaGNFB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 01:01:57 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:58895 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaGNFBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 01:01:49 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rjw@rjwysocki.net
Cc: viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: Fix latency for cpufreq_info
Date: Mon, 14 Jul 2014 01:01:44 -0400
Message-Id: <1405314104-9688-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the latency for the cpufreq policy to 1 million nanoseconds
that calls the function pxa_cpu_init for the member of the structure
called cpuinfo.transition_latency.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/cpufreq/pxa2xx-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index e24269a..e08bb98 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -372,7 +372,7 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
 	init_sdram_rows();
 
 	/* set default policy and cpuinfo */
-	policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
+	policy->cpuinfo.transition_latency = 1000, 000;
 
 	/* Generate pxa25x the run cpufreq_frequency_table struct */
 	for (i = 0; i < NUM_PXA25x_RUN_FREQS; i++) {
-- 
1.9.1

