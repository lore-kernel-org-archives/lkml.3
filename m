Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaLHEqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 23:46:42 -0500
Received: from ozlabs.org ([103.22.144.67]:56706 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaLHEql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 23:46:41 -0500
Date: Mon, 8 Dec 2014 15:46:38 +1100
From: Anton Blanchard <anton@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, yuyang.du@intel.com,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Daniel J Blueman <daniel@numascale.com>, subbaram@codeaurora.org,
        Brian Norris <computersforpeace@gmail.com>, sp@datera.io,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] kthread: kthread_bind fails to enforce CPU affinity
 (fixes kernel BUG at kernel/smpboot.c:134!)
Message-ID: <20141208154638.37c1ec18@kryten>
In-Reply-To: <CA+55aFw6gMN5VxONPo9xtJA_+p2iLArSaK-m_4vDL+L07Z6vuA@mail.gmail.com>
References: <1418009221-12719-1-git-send-email-anton@samba.org>
	<CA+55aFw6gMN5VxONPo9xtJA_+p2iLArSaK-m_4vDL+L07Z6vuA@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

> The __set_task_cpu() function does various other things too:
> 
>         set_task_rq(p, cpu);
>   #ifdef CONFIG_SMP
>         /*
>          * After ->cpu is set up to a new value, task_rq_lock(p, ...)
> can be
>          * successfuly executed on another CPU. We must ensure that
> updates of
>          * per-task data have been completed by this moment.
>          */
>         smp_wmb();
>         task_thread_info(p)->cpu = cpu;
>         p->wake_cpu = cpu;
>   #endif
> 
> which makes me worry about just setting the thread_info->cpu value.
> That set_task_rq() initializes various group scheduling things, an
> dthat whole "wake_cpu" thing seems relevant too.

Yeah, I would definitely like the scheduler guys to weigh in on this,
especially considering how difficult it can be to hit.

Anton
