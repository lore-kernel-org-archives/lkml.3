Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbaELS1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:27:09 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:25012 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297AbaELS1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:27:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUJAGYQcVNbsHLF/2dsb2JhbABZgwascwEFAZobAYEZF3SCJQEBBAEnExwjBQsIAxguOR4GE4g5DAHPPBeFVoh8B4RAAQOPJYoiAYsEiAODODs
Date: Mon, 12 May 2014 20:26:57 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] kernel/workqueue.c: pr_warning/pr_warn &
 printk/pr_info
Message-Id: <20140512202657.43eca18f8add0ba43a4564ab@skynet.be>
In-Reply-To: <1399918888.9240.28.camel@joe-AO725>
References: <20140512195623.bedc6e41683596d8d3b486c7@skynet.be>
	<1399918888.9240.28.camel@joe-AO725>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 11:21:28 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-05-12 at 19:56 +0200, Fabian Frederick wrote:
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  kernel/workqueue.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index 0ee63af..6824afc 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -4098,8 +4098,8 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
> >  	/* create a new pwq */
> >  	pwq = alloc_unbound_pwq(wq, target_attrs);
> >  	if (!pwq) {
> > -		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
> > -			   wq->name);
> > +		pr_warn("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
> > +			wq->name);
> >  		goto out_unlock;
> >  	}
> >  
> > @@ -4548,7 +4548,7 @@ void print_worker_info(const char *log_lvl, struct task_struct *task)
> >  		probe_kernel_read(desc, worker->desc, sizeof(desc) - 1);
> >  
> >  	if (fn || name[0] || desc[0]) {
> > -		printk("%sWorkqueue: %s %pf", log_lvl, name, fn);
> > +		pr_info("%sWorkqueue: %s %pf", log_lvl, name, fn);
> 
> Not correct.
> 
> log_lvl already emits the appropriate level
> and this overrides it with KERN_INFO.
> 
> The output will now be incorrect emitting
> at KERN_INFO followed by an SOH and the
> desired log level.
Such printk can't be converted to pr_ ?

> 
> >  		if (desc[0])
> >  			pr_cont(" (%s)", desc);
> >  		pr_cont("\n");
> 
> Trivially, it likely would be a bit better to avoid
> any possible output message interleaving by using:
> 
> 	if (fn || name[0] || desc[0]) {
> 		if (desc[0])
> 			printk("%sWorkqueue: %s %pf (%s)\n",
> 			       log_lvl, name, fn, desc);
> 		else
> 			printk("%sWorkqueue: %s %pf\n",
> 			       log_lvl, name, fn);
> 	}
> 
> 
> 


-- 
Fabian Frederick <fabf@skynet.be>
