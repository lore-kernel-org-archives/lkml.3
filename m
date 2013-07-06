Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab3GFTtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 15:49:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:48726 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3GFTtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 15:49:32 -0400
Date: Sat, 6 Jul 2013 21:48:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: Wang YanQing <udknight@gmail.com>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
        deepthi@linux.vnet.ibm.com, peterz@infradead.org,
        rusty@rustcorp.com.au, heiko.carstens@de.ibm.com, rostedt@goodmis.org,
        miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        jens.axboe@oracle.com, tj@kernel.org, akpm@linux-foundation.org,
        svaidy@linux.vnet.ibm.com, shli@kernel.org, lig.fnst@cn.fujitsu.com,
        anton@samba.org
Subject: Re: [PATCH 2/3] smp/ipi:Clarify ambiguous comments around deadlock
 scenarios in smp_call_function variants.
In-Reply-To: <51D7CBD7.2060902@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1307062148040.32106@ionos.tec.linutronix.de>
References: <20130705162548.16888.18957.stgit@preeti.in.ibm.com> <20130705162711.16888.30274.stgit@preeti.in.ibm.com> <20130706061205.GA3518@udknight> <51D7CBD7.2060902@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jul 2013, Preeti U Murthy wrote:

> Hi Wang,
> 
> On 07/06/2013 11:42 AM, Wang YanQing wrote:
> > On Fri, Jul 05, 2013 at 09:57:11PM +0530, Preeti U Murthy wrote:
> >> Elaborate on when deadlocks can occur when a call is made to
> >> smp_call_function_single() and its friends. This avoids ambiguity about
> >> when to use these calls.
> >>
> >> +	 * 2. wait = 0: This function could be called from an interrupt
> >> +	 * context, and can get blocked on the csd_lock(csd) below in
> >> +	 * "non wait cases".
> >> +	 * This is because the percpu copy of csd of this_cpu is used
> >> +	 * in non wait cases. Under such circumstances, if the previous caller
> >> +	 * of this function who got preempted by this interrupt has already taken
> >> +	 * the lock under non wait condition, it will result in deadlock.
> >> +	 *
> > 
> > No, it will not cause deadlock, it is not mutex lock,  it is busy wait, so
> > when the CSD_FLAG_LOCK be cleared, the code will go on running.
> 
> A deadlock might not result, but a potential long wait in an interrupt
> context could result if the source cpu got preempted by an interrupt
> between  csd_lock(csd) and generic_exec_single(), where it actually
> sends an ipi to the target cpu.

See https://lkml.org/lkml/2013/7/5/183 and the related thread for real
deadlock scenarios.
 
Thanks,

	tglx
