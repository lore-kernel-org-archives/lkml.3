Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbbA0O4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:56:31 -0500
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:55727 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751888AbbA0O43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:56:29 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3165:3352:3622:3865:3866:3870:3872:5007:6119:6261:7875:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:12663:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grain59_5575d20935e31
X-Filterd-Recvd-Size: 1720
Date: Tue, 27 Jan 2015 09:56:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xunlei Pang <pang.xunlei@linaro.org>, linux-kernel@vger.kernel.org,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH 5/5] sched/rt: Optimize find_lowest_rq() to select a
 cache hot cpu
Message-ID: <20150127095626.707e434d@gandalf.local.home>
In-Reply-To: <20150127142136.GE21418@twins.programming.kicks-ass.net>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
	<1421642980-10045-5-git-send-email-pang.xunlei@linaro.org>
	<20150127142136.GE21418@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 15:21:36 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Jan 19, 2015 at 04:49:40AM +0000, Xunlei Pang wrote:
> > In find_lowest_rq(), if we can't find a wake_affine cpu from
> > sched_domain, then we can actually determine a cache hot cpu
> > instead of simply calling "cpumask_any(lowest_mask)" which
> > always returns the first cpu in the mask.
> > 
> > So, we can determine the cache hot cpu during the interation of
> > sched_domain() in passing.
> 
> Steve, I'm not getting this. Why are we using WAKE_AFFINE here?
> 

It originated from Gregory Haskins topology patches. See 
 6e1254d2c41215da27025add8900ed187bca121d

-- Steve
