Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3H1Q5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:57:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18989 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3H1Q5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:57:02 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=jxQzypR4wcoA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qWrlR9Lw5PkA:10 a=TiaNW0bfAAAA:8 a=NEAV23lmAAAA:8 a=dtPOJR9oX_xSaj3Fd34A:9 a=CjuIK1q_8ugA:10 a=B0KwX_7kBuMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 28 Aug 2013 12:57:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vince Weaver <vince@deater.net>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20130828125701.1ca6ccd0@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1308281245370.6937@pianoman.cluster.toy>
References: <20130828034627.GA30596@redhat.com>
	<20130828103101.3f5679bc@gandalf.local.home>
	<20130828162321.GA14689@redhat.com>
	<alpine.DEB.2.02.1308281245370.6937@pianoman.cluster.toy>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 12:50:36 -0400 (EDT)
Vince Weaver <vince@deater.net> wrote:

> On Wed, 28 Aug 2013, Dave Jones wrote:
> > Quite often just rerunning that last syscall that caused the oops/warn
> > isn't sufficient to trigger an issue. (Though it may be for this specific
> > bug that may not be the case..)
> > 
> > Vince has a variant of trinity focussed just on perf which also has some
> > neat replay/bisecting capabilities to narrow down test cases.
> > I think I might need to add something like that at some point.
> 
> Yes, you can get the perf_fuzzer code here:
>    git clone https://github.com/deater/perf_event_tests.git
> in the fuzzer directory
> 
> Bisecting down which perf_event_open() call causes problems is still very 
> labor intensive even with the other tools I've added to help.  Even if the 
> bug is triggered right away (within the first 100,000 calls or so) it can 
> take hours to narrow things down to the two or three syscalls needed to 
> reproduce the problem.  Especially if you need to reboot after triggering 
> the issue.

Note, I have an idea that it's not even that many perf calls. I have a
good idea what perf syscalls with what options are the issue. I think
the issue is the calling order that is the problem.

Dave, I'm assuming that trinidy does things as threads, such that it
may be two threads calling perf with the same descriptor, and if we
don't have the proper locks, things can get bad, right?

-- Steve
