Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaBEK2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:28:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43765 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaBEK2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:28:20 -0500
Date: Wed, 5 Feb 2014 11:28:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: junk@eslaf.co.uk
Cc: fweisbec@gmail.com, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] perf,x86: Fix Userspace RDPMC switch
Message-ID: <20140205102815.GG3229@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf,x86: Fix Userspace RDPMC switch
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Feb  5 11:19:56 CET 2014

The current code forgets to change the CR4 state on the current CPU.
User on_each_cpu() instead of smp_call_function().

Cc: fweisbec@gmail.com
Reported-by: Mark Davies <junk@eslaf.co.uk>
Suggested-by: Mark Davies <junk@eslaf.co.uk>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/cpu/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1826,7 +1826,7 @@ static ssize_t set_attr_rdpmc(struct dev
 
 	if (!!val != !!x86_pmu.attr_rdpmc) {
 		x86_pmu.attr_rdpmc = !!val;
-		smp_call_function(change_rdpmc, (void *)val, 1);
+		on_each_cpu(change_rdpmc, (void *)val, 1);
 	}
 
 	return count;
