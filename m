Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaF1XSX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 19:18:23 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:33801 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaF1XSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 19:18:21 -0400
Date: Sun, 29 Jun 2014 00:18:18 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Tony Luck <tony.luck@intel.com>, linux390@de.ibm.com,
        linux-ia64@vger.kernel.org, linux-s390@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] sched.h: Remove useless `const' from function return type
Message-ID: <alpine.LFD.2.11.1406242149270.23403@eddie.linux-mips.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes:

cc1: warnings being treated as errors
In file included from include/linux/ptrace.h:5,
                 from arch/mips/kernel/cpu-probe.c:16:
include/linux/sched.h:1002: warning: type qualifiers ignored on function return type
make[2]: *** [arch/mips/kernel/cpu-probe.o] Error 1

This is a regression introduced with commit 
143e1e28cb40bed836b0a06567208bd7347c9672 [sched: Rework sched_domain 
topology definition].  The warning itself is benign except in places like 
the arch/mips subtree where we use `-Werror' to enforce good coding 
practices.  Apparently the warning is GCC-version specific, some versions 
produce it and some do not.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
Vincent,

 Did you mean:

typedef int __attribute__((const)) (*sched_domain_flags_f)(void);

by any chance?

  Maciej

linux-sched-domain-flags-type.patch
Index: linux-20140623-swarm64/include/linux/sched.h
===================================================================
--- linux-20140623-swarm64.orig/include/linux/sched.h
+++ linux-20140623-swarm64/include/linux/sched.h
@@ -999,7 +999,7 @@ void free_sched_domains(cpumask_var_t do
 bool cpus_share_cache(int this_cpu, int that_cpu);
 
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
-typedef const int (*sched_domain_flags_f)(void);
+typedef int (*sched_domain_flags_f)(void);
 
 #define SDTL_OVERLAP	0x01
 
