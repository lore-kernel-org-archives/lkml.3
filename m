Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbaJaKAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:00:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49391 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408AbaJaKAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:00:20 -0400
Date: Fri, 31 Oct 2014 08:00:05 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] perf syscall error handling
Message-ID: <20141031100005.GH1313@kernel.org>
References: <20141030222814.GF15602@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 30, 2014 at 09:16:36PM -0400, Vince Weaver escreveu:
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
> 
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

But perhaps we can have a mode where we can say to perf to setup
function tracing in the sys_perf_event_open() for the perf tool pid,
that would output the lines leading to the return ERRNO.

Or use 'perf probe'  like stuff to insert/enable some kretprobes, both
ideas need some prototyping and would require root privilege :-\

- Arnaldo
