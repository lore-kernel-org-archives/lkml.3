Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbbA0XEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:04:41 -0500
Received: from smtprelay0142.hostedemail.com ([216.40.44.142]:45063 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752403AbbA0XEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:04:40 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3871:3872:3873:3874:4250:4321:4385:5007:6119:6261:7875:10004:10400:10848:10967:11026:11232:11658:11914:12296:12517:12519:12555:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fish82_7fee8ee25421d
X-Filterd-Recvd-Size: 1836
Date: Tue, 27 Jan 2015 18:04:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xunlei Pang <pang.xunlei@linaro.org>, linux-kernel@vger.kernel.org,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH 4/5] sched/rt: Consider deadline tasks in cpupri_find()
Message-ID: <20150127180438.445d8e76@gandalf.local.home>
In-Reply-To: <20150127125859.GD21418@twins.programming.kicks-ass.net>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
	<1421642980-10045-4-git-send-email-pang.xunlei@linaro.org>
	<20150127125859.GD21418@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 13:58:59 +0100
Peter Zijlstra <peterz@infradead.org> wrote:


> Not a bad idea, Cc'ed Steve who likes to look after the RT bits,
> excessive quoting for him.

Yep I do.


> > index ade2958..48c9576 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -5652,6 +5652,8 @@ static int init_rootdomain(struct root_domain *rd)
> >  
> >  	if (cpupri_init(&rd->cpupri) != 0)
> >  		goto free_rto_mask;
> > +
> > +	rd->cpupri.cpudl = &rd->cpudl;
> 
> This is disgusting though; it breaks the cpuri abstraction. Why not pass
> in the mask in the one place you actually need it?

Yeah, probably should change cpupri_init() to take the rd->cpudl as a
parameter.

Rest looks good (ignoring Peter's other comment that he realized wasn't
an issue).

-- Steve

