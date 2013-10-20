Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233Ab3JTDgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 23:36:36 -0400
Received: from mail-ye0-f171.google.com ([209.85.213.171]:52699 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3JTDge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 23:36:34 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: kernel-br@googlegroups.com
Cc: "Geyslan G. Bem" <geyslan@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org (open list:CPU FREQUENCY DRI...),
        linux-pm@vger.kernel.org (open list:CPU FREQUENCY DRI...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] cpufreq: intel_pstate: fix possible integer overflow
Date: Sun, 20 Oct 2013 00:31:16 -0300
Message-Id: <1382239876-12688-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The expression 'pstate << 8' is evaluated using 32-bit arithmetic while
'val' expects an expression of type u64.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/cpufreq/intel_pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index badf620..43446b5 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -395,7 +395,7 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 	trace_cpu_frequency(pstate * 100000, cpu->cpu);
 
 	cpu->pstate.current_pstate = pstate;
-	val = pstate << 8;
+	val = (u64)pstate << 8;
 	if (limits.no_turbo)
 		val |= (u64)1 << 32;
 
-- 
1.8.4

