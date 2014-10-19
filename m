Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaJSVfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 17:35:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:41960 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaJSVfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 17:35:36 -0400
Date: Sun, 19 Oct 2014 23:35:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
Message-ID: <20141019213534.GG23531@worktop.programming.kicks-ass.net>
References: <cover.1413323611.git.luto@amacapital.net>
 <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
 <CALCETrXRGNeUipujcGiT30SV+MDHCFpTxG7LOTXj4Z4CbtxdJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXRGNeUipujcGiT30SV+MDHCFpTxG7LOTXj4Z4CbtxdJQ@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 05:00:56PM -0700, Andy Lutomirski wrote:
> The current cap_user_rdpmc code seems rather confused to me.  On x86,
> *all* events set cap_user_rdpmc if the global rdpmc control is set.
> But only x86_pmu events define .event_idx, so amd uncore events won't
> actually expose their rdpmc index to userspace.
> 
> Would it make more sense to add a flag PERF_X86_EVENT_RDPMC_PERMITTED
> that gets set on all events created while rdpmc == 1, to change
> x86_pmu_event_idx to do something like:
> 
> if (event->hw.flags & PERF_X86_EVENT_RDPMC_PERMITTED)
>   return event->hw.event_base_rdpmc + 1;
> else
>   return 0;
> 
> and to change arch_perf_update_userpage cap_user_rdpmc to match
> PERF_X86_EVENT_RDPMC_PERMITTED?
> 
> Then we could ditch the static key and greatly simplify writes to the
> rdpmc flag by just counting PERF_X86_EVENT_RDPMC_PERMITTED events.
> 
> This would be a user-visible change on AMD, and I can't test it.

I have AMD hardware to test this. But yes something like that seems
fine.
