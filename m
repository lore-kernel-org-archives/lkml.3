Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934974Ab3DKILK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:11:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:39581 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab3DKILF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:11:05 -0400
Date: Thu, 11 Apr 2013 10:10:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Dave Hansen <dave@sr71.net>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] CPU hotplug, smpboot: Fix crash in smpboot_thread_fn()
In-Reply-To: <5165713D.7030503@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1304111007270.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos>
 <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net> <5165713D.7030503@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Srivatsa S. Bhat wrote:

> Interestingly, in every single stack trace, the crashing task is the migration
> thread. Now, migration thread belongs to the highest priority stop_task sched
> class, and this particular sched class is very unique in the way it implements
> its internal sched class functions, and I suspect this has a lot of bearing
> on how functions like kthread_bind(), wake_up_process() etc react with it
> (by looking at how it implements its functions such as select_task_rq(),
> enqueue_task(), dequeue_task() etc).

I don't think that's relevant. The migration thread can only be woken
via try_to_wakeup and my previous patch which implements a separate
task state makes sure that it cannot be woken accidentaly by anything
else than unpark.
 
> But note that __kthread_bind() can wake up the task if the task is an RT
> task. So it can be called only when the CPU (to which we want to bind the task)

kthread_bind() does NOT wakeup anything. It merily sets the cpus
allowed ptr without further ado.


Thanks,

	tglx
