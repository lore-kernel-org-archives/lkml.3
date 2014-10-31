Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbaJaHVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:21:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55850 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbaJaHVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:21:20 -0400
Date: Fri, 31 Oct 2014 08:21:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] perf syscall error handling
Message-ID: <20141031072109.GD12706@worktop.programming.kicks-ass.net>
References: <20141030222814.GF15602@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 09:16:36PM -0400, Vince Weaver wrote:
> On Thu, 30 Oct 2014, Peter Zijlstra wrote:
> 
> > So would something simple, like an offset into the struct
> > perf_event_attr pointing at the current field we're trying to process
> > make sense? Maybe with negative offsets to indicate the syscall
> > arguments?
> > 
> > That would narrow down the 'WTF is wrong noaw' a lot I think. But then,
> > I've not actually done a lot of userspace the last few years, so maybe
> > I'm just dreaming things.
> 
> well, as someone who spends a lot of time in userspace trying to help 
> people who report probems like 'perf_event_open() returns EINVAL, what's 
> wrong' I can say pretty much anything will be an improvement.

Right, the situation is dire indeed :/

> What would really help is if we could somehow return the 
> filename/line-number of whatever source code file that's setting errno.
> 
> Even if perf_event_open() told me that hey, we're getting EOPNOTSUPP due 
> to the precise_ip parameter (something that happened just yesterday) it's 
> still a lot of grepping and poking around source files to find out what's 
> going on.  It would be much better if it just told me the issue was at
> kernel/events/core.c line 995 or so, but I'm not sure how you could pass 
> that back to the user, and one could argue it wouldn't help much the 
> average user without a kernel tree lying around.

Would an additional bit mask help? With that we'd be able to finger
the exact flag that causes pain.
