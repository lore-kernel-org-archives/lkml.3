Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3AaMLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:11:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:55896 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab3AaMLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:22 -0500
Message-Id: <20130131120742.236009430@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 11/40] x86: uncore: Move teardown callback to CPU_DEAD
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline;
 filename=x86-uncore-refactor-hotplug-notifiers.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point calling this from the dying cpu.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_uncore.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2622,7 +2622,7 @@ static void __init uncore_pci_exit(void)
 	}
 }
 
-static void __cpuinit uncore_cpu_dying(int cpu)
+static void __cpuinit uncore_cpu_dead(int cpu)
 {
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
@@ -2803,8 +2803,8 @@ static int
 		uncore_cpu_starting(cpu);
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_DYING:
-		uncore_cpu_dying(cpu);
+	case CPU_DEAD:
+		uncore_cpu_dead(cpu);
 		break;
 	default:
 		break;


