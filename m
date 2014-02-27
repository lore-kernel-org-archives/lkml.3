Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaB0Mha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:37:30 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63124 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaB0Mh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:37:29 -0500
Date: Thu, 27 Feb 2014 18:07:17 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        josh@joshtriplett.org
Subject: [PATCH 46/46] kernel: Add prototype declaration to header file
 include/linux/sched.h
Message-ID: <a0024a2600d8a7afe58f223294b3272c516affd2.1393493278.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declaration of function to header file
include/linux/sched.h because it is used by more than one file.

This eliminates the following warning in kernel/sched/fair.c:
kernel/sched/fair.c:5254:22: warning: no previous prototype for ‘arch_scale_freq_power’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/sched.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f08958b..f83081b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -966,6 +966,7 @@ static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
 	return to_cpumask(sd->span);
 }
 
+unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu);
 extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 				    struct sched_domain_attr *dattr_new);
 asmlinkage void __sched preempt_schedule_irq(void);
-- 
1.7.9.5

