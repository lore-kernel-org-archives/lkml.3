Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaBKQ0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:26:37 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46704 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaBKQ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:26:28 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 8/8] cpufreq: ppc: make use of of_find_matching_node_and_match
Date: Tue, 11 Feb 2014 10:24:06 -0600
Message-Id: <1392135847-30791-9-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of the of_find_matching_node()/of_match_node() pair, which requires two
iterations through the match table, make use of of_find_matching_node_and_match(),
which only iterates through the table once.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/cpufreq/ppc-corenet-cpufreq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index 051000f..041ef3a 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -278,7 +278,7 @@ static int __init ppc_corenet_cpufreq_init(void)
 	const struct soc_data *data;
 	unsigned int cpu;
 
-	np = of_find_matching_node(NULL, node_matches);
+	np = of_find_matching_node_and_match(NULL, node_matches, &match);
 	if (!np)
 		return -ENODEV;
 
@@ -288,7 +288,6 @@ static int __init ppc_corenet_cpufreq_init(void)
 		cpumask_copy(per_cpu(cpu_mask, cpu), cpu_core_mask(cpu));
 	}
 
-	match = of_match_node(node_matches, np);
 	data = match->data;
 	if (data) {
 		if (data->flag)
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

