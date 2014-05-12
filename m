Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaELCEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:04:31 -0400
Received: from 1wt.eu ([62.212.114.60]:34576 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbaELBmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:35 -0400
Message-Id: <20140512003205.698107104@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>, Dave Jones <davej@redhat.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 121/143] [CPUFREQ] powernow-k6: set transition latency value so ondemand
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 governor can be used

From: Krzysztof Helt <krzysztof.h1@wp.pl>

Set the transition latency to value smaller than CPUFREQ_ETERNAL so
governors other than "performance" work (like the "ondemand" one).

The value is found in "AMD PowerNow! Technology Platform Design Guide for
Embedded Processors" dated December 2000 (AMD doc #24267A). There is the
answer to one of FAQs on page 40 which states that suggested complete transition
period is 200 us.

Tested on K6-2+ CPU with K6-3 core (model 13, stepping 4).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Dave Jones <davej@redhat.com>
(cherry picked from commit db2820dd5445a44b4726f15a2bc89b9ded2503eb)
[wt: in 2.6.32, we only need this one so that next series applies cleanly]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k6.c b/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
index f10dea4..cb01dac 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
@@ -164,7 +164,7 @@ static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 	}
 
 	/* cpuinfo and default policy values */
-	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
+	policy->cpuinfo.transition_latency = 200000;
 	policy->cur = busfreq * max_multiplier;
 
 	result = cpufreq_frequency_table_cpuinfo(policy, clock_ratio);
-- 
1.7.12.2.21.g234cd45.dirty



