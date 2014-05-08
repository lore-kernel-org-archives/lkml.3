Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaEHFHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 01:07:46 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:44064 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbaEHFHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 01:07:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMVAEgQa1NbskEF/2dsb2JhbABZgwasNwEBAQEBAQUBmgoCAgGBGBd0giUBAQQBOj8FCwgDGC45HgYTiDkMAc9gF4VWiHwHhD8BA48bihsBiwCHe4M2Ow
Date: Thu, 8 May 2014 07:07:38 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] kernel/stop_machine.c: remove false assignment to
 static
Message-Id: <20140508070738.02b3051a9766a012c4c1a923@skynet.be>
In-Reply-To: <20140507210411.GB2844@laptop.programming.kicks-ass.net>
References: <20140507224656.e06286af4392251135862718@skynet.be>
	<20140507210411.GB2844@laptop.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 23:04:11 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, May 07, 2014 at 10:46:56PM +0200, Fabian Frederick wrote:
> > This patch also fixes function prototype over 80 characters
> 
> And does it wrong.. Also does it really matter to GCC that we init the
> bool? Surely it can see its 0 and put it in .bss anyway?
It's considered redundant but maintainer's choice is the priority :)
 
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  kernel/stop_machine.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> > index 695f0c6..8d29ee2 100644
> > --- a/kernel/stop_machine.c
> > +++ b/kernel/stop_machine.c
> > @@ -42,7 +42,7 @@ struct cpu_stopper {
> >  
> >  static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
> >  static DEFINE_PER_CPU(struct task_struct *, cpu_stopper_task);
> > -static bool stop_machine_initialized = false;
> > +static bool stop_machine_initialized;
> >  
> >  /*
> >   * Avoids a race between stop_two_cpus and global stop_cpus, where
> > @@ -241,7 +241,8 @@ static void irq_cpu_stop_queue_work(void *arg)
> >   *
> >   * returns when both are completed.
> >   */
> > -int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *arg)
> > +int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn,
> > +		  void *arg)
> 
> Its only 84, so I didn't care to wrap it, its more readable this way,
> but if you want it split split it like:
> 
> int
> stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *arg)
> 
> Or if you really have to split arguments to it in groups that make
> sense; like:
> 
> int stop_two_cpus(unsigned int cpu1, unsigned int cpu2,
> 		  cpu_stop_fn_t fn, void *arg)
> 
> But really, these are two unrelated changes, and should therefore not be
> in a single patch.
Ok, thanks

Fabian
