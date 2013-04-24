Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab3DXILr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:11:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:38560 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab3DXILo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:11:44 -0400
Message-ID: <517793BD.30101@linutronix.de>
Date: Wed, 24 Apr 2013 10:11:41 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>
Subject: Re: [PREEMPT RT] SLUB and split softirq lock for v3.2-rt
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de> <1366770979.2626.3.camel@gandalf.local.home>
In-Reply-To: <1366770979.2626.3.camel@gandalf.local.home>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 04:36 AM, Steven Rostedt wrote:
> Hi Sebastian,

Hi Steven,

> Which version of 3.2-rt was this applied to. It does not apply, where
> patch 7/16 totally does not apply. I looked at the history of 3.2-rt and
> I can't find where it would apply.

I applied them on top of 2438ee33 ("Linux 3.2.37-rt55 REBASE"). I just
grabbed the patches from the mailing list and re-applied them on top of
this tree and is still works.

After doing the same thing on v3.2.43-rt63-rebase I got:

Applying: softirq: Make serving softirqs a task flag
Applying: softirq: Split handling function
Applying: softirq: Split softirq locks
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging include/linux/sched.h
Applying: rcu: rcutiny: Prevent RCU stall
Applying: softirq: Adapt NOHZ softirq pending check to new RT scheme
Applying: softirq: Add more debugging
Applying: softirq: Fix nohz pending issue for real
Applying: net: Use local_bh_disable in netif_rx_ni()
Applying: FIX [1/2] slub: Do not dereference NULL pointer in node_match
Applying: FIX [2/2] slub: Tid must be retrieved from the percpu area of
the current processor
Applying: slub: Use correct cpu_slab on dead cpu
Applying: smp: introduce a generic on_each_cpu_mask() function
Applying: smp: add func to IPI cpus based on parameter func
Applying: slub: only IPI CPUs that have per cpu obj to flush
Applying: mm: Enable SLUB for RT
Applying: slub: Enable irqs for __GFP_WAIT

git did not complain about patch 7 ("softirq: Fix nohz pending issue for
real") but about 3 ("softirq: Split softirq locks"). The diff between
the two queues (except different sha1, index and so) is:

--- old/0003-softirq-Split-softirq-locks.patch
+++ new/0003-softirq-Split-softirq-locks.patch
@@ -60,8 +60,8 @@
        int softirq_nestcnt;
 +      unsigned int softirqs_raised;
  #endif
- #if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
-       int kmap_idx;
+ #ifdef CONFIG_PREEMPT_RT_FULL
+ # if defined CONFIG_HIGHMEM || defined CONFIG_X86_32


and this looks good.

> Thanks,
> 
> -- Steve

Sebastian
