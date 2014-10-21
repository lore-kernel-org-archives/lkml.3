Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaJUO7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:59:48 -0400
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:43644 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751191AbaJUO7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:59:46 -0400
Date: Tue, 21 Oct 2014 11:00:26 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Andy Lutomirski <luto@amacapital.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 0/5] CR4 handling improvements
In-Reply-To: <CALCETrV0UCodO7FAi2fXd9ED6K_RHs-0yb+P4Ubmo=EUKZs3gg@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1410211057120.1451@pianoman.cluster.toy>
References: <cover.1413323611.git.luto@amacapital.net> <alpine.DEB.2.10.1410210003300.5251@pianoman.cluster.toy> <CALCETrV0UCodO7FAi2fXd9ED6K_RHs-0yb+P4Ubmo=EUKZs3gg@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020208.544674E2.0017,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014, Andy Lutomirski wrote:

> ISTM it would be a lot better to use the perf subsystem for this.  You
> can probably pin an event to a pmu.  

No, you cannot pin an event to a counter with perf_event.
That's one of the big differences between perf_event and, say, perfmon2.

With perf_event the kernel controls which events go in which counters and 
the user has no say.  That's part of why you need to check the mmap page 
every time you want to use rdpmc because there's no other way of knowing 
which counter to read to get the event you want.

perf_event is also fairly high overhead for setting up and starting 
events, and mildly high overhead when doing a proper rdpmc call (due to 
the required looking at mmap, and the fact that you need to do two rdpmc 
calls before/after to get your value).  This is why people really worried 
about low-latency measurements bypass as much of perf_event as possible.

Vince
