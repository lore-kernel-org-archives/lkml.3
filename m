Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaJUQE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:04:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52702 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbaJUQE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:04:28 -0400
Date: Tue, 21 Oct 2014 18:04:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 0/5] CR4 handling improvements
Message-ID: <20141021160411.GF3219@twins.programming.kicks-ass.net>
References: <cover.1413323611.git.luto@amacapital.net>
 <alpine.DEB.2.10.1410210003300.5251@pianoman.cluster.toy>
 <CALCETrV0UCodO7FAi2fXd9ED6K_RHs-0yb+P4Ubmo=EUKZs3gg@mail.gmail.com>
 <alpine.DEB.2.10.1410211057120.1451@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410211057120.1451@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:00:26AM -0400, Vince Weaver wrote:
> On Mon, 20 Oct 2014, Andy Lutomirski wrote:
> 
> > ISTM it would be a lot better to use the perf subsystem for this.  You
> > can probably pin an event to a pmu.  
> 
> No, you cannot pin an event to a counter with perf_event.
> That's one of the big differences between perf_event and, say, perfmon2.
> 
> With perf_event the kernel controls which events go in which counters and 
> the user has no say.  That's part of why you need to check the mmap page 
> every time you want to use rdpmc because there's no other way of knowing 
> which counter to read to get the event you want.
> 
> perf_event is also fairly high overhead for setting up and starting 
> events,

Which you only do once at the start, so is that really a problem?

> and mildly high overhead when doing a proper rdpmc call (due to 
> the required looking at mmap, and the fact that you need to do two rdpmc 
> calls before/after to get your value).  This is why people really worried 
> about low-latency measurements bypass as much of perf_event as possible.

I still don't get that argument, 2 rdpmc's is cheaper than doing wrmsr,
not to mention doing wrmsr through a syscall. And looking at that mmap
page is 1 cacheline. Is that cacheline read (assuming you miss) the real
problem?
