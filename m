Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbbA0Q2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:28:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:39397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbbA0Q2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:28:18 -0500
Date: Tue, 27 Jan 2015 17:28:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Xunlei Pang <pang.xunlei@linaro.org>, linux-kernel@vger.kernel.org,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH 5/5] sched/rt: Optimize find_lowest_rq() to select a
 cache hot cpu
Message-ID: <20150127162815.GG21418@twins.programming.kicks-ass.net>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
 <1421642980-10045-5-git-send-email-pang.xunlei@linaro.org>
 <20150127142136.GE21418@twins.programming.kicks-ass.net>
 <20150127095626.707e434d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127095626.707e434d@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 09:56:26AM -0500, Steven Rostedt wrote:
> On Tue, 27 Jan 2015 15:21:36 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, Jan 19, 2015 at 04:49:40AM +0000, Xunlei Pang wrote:
> > > In find_lowest_rq(), if we can't find a wake_affine cpu from
> > > sched_domain, then we can actually determine a cache hot cpu
> > > instead of simply calling "cpumask_any(lowest_mask)" which
> > > always returns the first cpu in the mask.
> > > 
> > > So, we can determine the cache hot cpu during the interation of
> > > sched_domain() in passing.
> > 
> > Steve, I'm not getting this. Why are we using WAKE_AFFINE here?
> > 
> 
> It originated from Gregory Haskins topology patches. See 
>  6e1254d2c41215da27025add8900ed187bca121d

Indeed so; it seems an arbitrary choice.

And the proposed patch seems like a convoluted way to simply remove the
->flags & SD_WAKE_AFFINE test.

Of course, the entire domain loop there assumes a lower domain is
better; yay for SMT being such a good counter example ;-)

Of course, if we remove it here; we should do too for deadline.

