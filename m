Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161612AbaJaBPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:15:54 -0400
Received: from smtpauth13.mfg.siteprotect.com ([64.26.60.145]:53772 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161496AbaJaBPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:15:52 -0400
Date: Thu, 30 Oct 2014 21:16:36 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] perf syscall error handling
In-Reply-To: <20141030222814.GF15602@worktop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy>
References: <20141030222814.GF15602@worktop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020206.5452E2C7.0181,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, Peter Zijlstra wrote:

> So would something simple, like an offset into the struct
> perf_event_attr pointing at the current field we're trying to process
> make sense? Maybe with negative offsets to indicate the syscall
> arguments?
> 
> That would narrow down the 'WTF is wrong noaw' a lot I think. But then,
> I've not actually done a lot of userspace the last few years, so maybe
> I'm just dreaming things.

well, as someone who spends a lot of time in userspace trying to help 
people who report probems like 'perf_event_open() returns EINVAL, what's 
wrong' I can say pretty much anything will be an improvement.

What would really help is if we could somehow return the 
filename/line-number of whatever source code file that's setting errno.

Even if perf_event_open() told me that hey, we're getting EOPNOTSUPP due 
to the precise_ip parameter (something that happened just yesterday) it's 
still a lot of grepping and poking around source files to find out what's 
going on.  It would be much better if it just told me the issue was at
kernel/events/core.c line 995 or so, but I'm not sure how you could pass 
that back to the user, and one could argue it wouldn't help much the 
average user without a kernel tree lying around.

Vince
