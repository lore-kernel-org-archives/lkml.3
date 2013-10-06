Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab3JFJK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 05:10:59 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:57003 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3JFJK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 05:10:57 -0400
Date: Sun, 6 Oct 2013 11:10:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Clean up cap_user_time* setting
Message-ID: <20131006091054.GA4342@gmail.com>
References: <tip-nmgn0j0muo1r4c94vlfh23xy@git.kernel.org>
 <524F097A.9010506@intel.com>
 <20131004185539.GT15690@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004185539.GT15690@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Oct 04, 2013 at 09:31:22PM +0300, Adrian Hunter wrote:
> > On 4/10/2013 8:31 p.m., tip-bot for Peter Zijlstra wrote:
> > >Commit-ID:  d8b11a0cbd1c66ce283eb9dabe0498dfa6483f32
> > >Gitweb:     http://git.kernel.org/tip/d8b11a0cbd1c66ce283eb9dabe0498dfa6483f32
> > >Author:     Peter Zijlstra <peterz@infradead.org>
> > >AuthorDate: Thu, 3 Oct 2013 16:00:14 +0200
> > >Committer:  Ingo Molnar <mingo@kernel.org>
> > >CommitDate: Fri, 4 Oct 2013 09:58:55 +0200
> > >
> > >perf/x86: Clean up cap_user_time* setting
> > >
> > >Currently the cap_user_time_zero capability has different tests than
> > >cap_user_time; even though they expose the exact same data.
> > >
> > >Switch from CONSTANT && NONSTOP to sched_clock_stable to also deal
> > >with multi cabinet machines and drop the tsc_disabled() check.. non of
> > >this will work sanely without tsc anyway.
> > 
> > Unfortunately in the case that TSC is disabled, sched_clock is still
> > reported as stable, which means removing the tsc_disabled() check breaks
> > the capability bit. e.g.
> 
> I'm wanting to hear from the x86 people on why we have this absurd knob 
> to begin with; but I'm tempted to simply disable all of perf if you 
> touch it.

I'm fully with you, please zap the 'notsc' boot option - it's an ancient 
relic, if any box is still broken with the TSC on we want to hear about it 
and fix it!

Thanks,

	Ingo
