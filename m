Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaB0Mdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:33:50 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61638 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaB0Mds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:33:48 -0500
Date: Thu, 27 Feb 2014 18:01:34 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        josh@joshtriplett.org
Subject: [PATCH 42/46] kernel: Add prototype declaration to appropriate
 header file include/linux/sched.h
Message-ID: <81ebe97993f951fe7e94a0514602ad9fae2d1954.1393493277.git.rashika.kheria@gmail.com>
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
include/linux/sched.h
because it used by more than one file.

This eliminates the following warning in kernel/sched/core.c:
kernel/sched/core.c:2822:25: warning: no previous prototype for ‘preempt_schedule_irq’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 56aa7ee..d162e3b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -967,7 +967,7 @@ static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
 
 extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 				    struct sched_domain_attr *dattr_new);
-
+asmlinkage void __sched preempt_schedule_irq(void);
 /* Allocate an array of sched domains, for partition_sched_domains(). */
 cpumask_var_t *alloc_sched_domains(unsigned int ndoms);
 void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
-- 
1.7.9.5

