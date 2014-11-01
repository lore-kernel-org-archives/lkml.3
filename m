Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaKAF3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 01:29:44 -0400
Received: from smtpauth02h.mfg.siteprotect.com ([64.26.60.151]:55411 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750710AbaKAF3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 01:29:43 -0400
Date: Sat, 1 Nov 2014 01:30:39 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Stephane Eranian <eranian@google.com>
cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] perf syscall error handling
In-Reply-To: <CABPqkBS0gKWyTc=TFpGxRwOQkAe1o5zXtWaUyHezpO53LhCqrQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1411010130170.6256@pianoman.cluster.toy>
References: <20141030222814.GF15602@worktop.programming.kicks-ass.net> <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy> <20141031072109.GD12706@worktop.programming.kicks-ass.net> <20141031092713.GA23124@gmail.com> <20141031122824.GZ12020@console-pimps.org>
 <CABPqkBS0gKWyTc=TFpGxRwOQkAe1o5zXtWaUyHezpO53LhCqrQ@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020209.54546FC5.015E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Stephane Eranian wrote:

> On Fri, Oct 31, 2014 at 1:28 PM, Matt Fleming <matt@console-pimps.org> wrote:
> >
> > I guess we'd run into a problem if userspace doesn't want to just print
> > the kernel string but instead wants to parse it in some fashion.

If the string interface went in it would be a help when debugging 
perf_event_open().

Support would probably get added to PAPI, but PAPI has its own error 
reporting issues and it's not always easy to pass a string the whole way 
back to the user.

Also with PAPI many of the users reporting obscure perf_event_open() 
problems are often running 2.6.32-vendor-patched kernels, so sadly it will 
be years before any improved error handling filters down to many of the 
users.

This proposal also doesn't help with other weird failure modes in the 
interface, the most annoying of which is the watchdog stealing a counter 
so event groups perf_event_open() and start just fine but fail at read 
time.

> > That may or may not be a problem in practice, Vince can probably comment
> > on that. I'm just thinking along the lines of making the perf syscall
> > interface as useful as possible for tools other than tools/perf.
> >
> Maybe I missed something in the earlier thread, but I am trying to understand
> why perf_event_open() would need such extended error retrieval system when
> no other syscall does.

well perf_event_open() is so complex, with it's 40+ different parameters.  
Having a wrong value in any one of those (or one of the combinations of 
those) can trigger EINVAL and it's not clear where the issue is.  
I think other system calls tend to have slighly more straightforward 
interfaces.

Vince
