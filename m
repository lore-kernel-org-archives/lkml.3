Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaBZVdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:33:54 -0500
Received: from one.firstfloor.org ([193.170.194.197]:55685 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaBZVdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:33:53 -0500
Date: Wed, 26 Feb 2014 22:33:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
Message-ID: <20140226213351.GN22728@two.firstfloor.org>
References: <530D53EF.9090706@amacapital.net>
 <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
 <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com>
 <20140226185513.GL22728@two.firstfloor.org>
 <CALCETrVQ8SBg+YLuPmDevL+f2dzBjLJucfMvVHaB04E8QJSGXw@mail.gmail.com>
 <530E3E47.8010205@gmail.com>
 <CALCETrUHiDqT+VRbdEnGsEkMFqQt+ZqX+RTenp1ets8XMhrQ2Q@mail.gmail.com>
 <530E4B42.5090401@gmail.com>
 <20140226205322.GM22728@two.firstfloor.org>
 <20140226211540.GE22802@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226211540.GE22802@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Another issue is that you can't enable it on a lot of existing
> > libraries, sometimes not even with a recompile. For example
> > glibc assembler functions do not support it at all, which
> > is a very common case.
> 
> They're mostly all leaf functions, so it doesn't matter much if
> anything.

If you assume they don't destroy FP -- which many of them do.
A lot of str* and some mem* functions are problematic
(note it depends what CPU you use)

A common problem I ran into was that it was impossible
to profile through mutex locks (now fixed in latest glibc)

> 
> > They are designed to use dwarf, but in practice dwarf
> > is very slow (perf has to save the stack for every sample)
> > and in practice doesn't always work (too small stack saving,
> > wrong annotations, out of date or broken dwarf library etc.) 
> > 
> > LBR callstack mode is not perfect either, and it has 
> > its own tradeoffs, but in many cases it seems to be a good
> > and more efficient replacement for dwarf, when FP is not available.
> 
> But except for the lobbying Intel put into disabling FP because of that
> piece of shit Atom we'd all still have it enabled.

The original reason for getting rid of FP on 64bit (and later 32bit) was
the original AMD K8, which has similar pipeline stalls as Atom. That was
long before Atom existed. Most older CPUs had similar problems,
so it was eventually also done on 32bit.

-Andi

P.S.: Congratulations on getting every single statement
in the email wrong. That's a full jackpot.

-- 
ak@linux.intel.com -- Speaking for myself only.
