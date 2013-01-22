Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3AVHio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:38:44 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49613 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab3AVHik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:38:40 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v5 14/45] rcu,
 CPU hotplug: Fix comment referring to stop_machine()
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        fweisbec@gmail.com, linux@arm.linux.org.uk, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2013 13:06:34 +0530
Message-ID: <20130122073630.13822.99359.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012207-0260-0000-0000-0000026FFDDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't refer to stop_machine() in the CPU hotplug path, since we are going
to get rid of it. Also, move the comment referring to callback adoption
to the CPU_DEAD case, because that's where it happens now.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/rcutree.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e441b77..ac94474 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2827,11 +2827,6 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
-		/*
-		 * The whole machine is "stopped" except this CPU, so we can
-		 * touch any data without introducing corruption. We send the
-		 * dying CPU's callbacks to an arbitrarily chosen online CPU.
-		 */
 		for_each_rcu_flavor(rsp)
 			rcu_cleanup_dying_cpu(rsp);
 		rcu_cleanup_after_idle(cpu);
@@ -2840,6 +2835,10 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_DEAD_FROZEN:
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
+		/*
+		 * We send the dead CPU's callbacks to an arbitrarily chosen
+		 * online CPU.
+		 */
 		for_each_rcu_flavor(rsp)
 			rcu_cleanup_dead_cpu(cpu, rsp);
 		break;

