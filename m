Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaELS3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:29:22 -0400
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:49516 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751980AbaELS3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:29:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3872:4250:4321:5007:7652:7903:10004:10400:10848:10967:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: toys95_3448d51f9a03a
X-Filterd-Recvd-Size: 1865
Message-ID: <1399919357.9240.31.camel@joe-AO725>
Subject: Re: [PATCH 1/1] kernel/workqueue.c: pr_warning/pr_warn &
 printk/pr_info
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Mon, 12 May 2014 11:29:17 -0700
In-Reply-To: <20140512202657.43eca18f8add0ba43a4564ab@skynet.be>
References: <20140512195623.bedc6e41683596d8d3b486c7@skynet.be>
	 <1399918888.9240.28.camel@joe-AO725>
	 <20140512202657.43eca18f8add0ba43a4564ab@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 20:26 +0200, Fabian Frederick wrote:
> On Mon, 12 May 2014 11:21:28 -0700 Joe Perches <joe@perches.com> wrote:
> > On Mon, 2014-05-12 at 19:56 +0200, Fabian Frederick wrote:
[]
> > > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
[]
> > > @@ -4548,7 +4548,7 @@ void print_worker_info(const char *log_lvl, struct task_struct *task)
> > >  		probe_kernel_read(desc, worker->desc, sizeof(desc) - 1);
> > >  
> > >  	if (fn || name[0] || desc[0]) {
> > > -		printk("%sWorkqueue: %s %pf", log_lvl, name, fn);
> > > +		pr_info("%sWorkqueue: %s %pf", log_lvl, name, fn);
> > 
> > Not correct.
> > 
> > log_lvl already emits the appropriate level
> > and this overrides it with KERN_INFO.
> > 
> > The output will now be incorrect emitting
> > at KERN_INFO followed by an SOH and the
> > desired log level.
>
> Such printk can't be converted to pr_ ?

Correct.


