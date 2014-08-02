Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaHBF1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 01:27:33 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:42629 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHBF1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 01:27:31 -0400
Date: Sat, 2 Aug 2014 07:27:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, kan.liang@intel.com,
        alexander.shishkin@linux.intel.com, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] x86 perf: Protect LBR msrs accessing against
 potential #GP
Message-ID: <20140802052726.GB14766@gmail.com>
References: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
 <1406799663-18192-2-git-send-email-kan.liang@intel.com>
 <20140801073825.GG19379@twins.programming.kicks-ass.net>
 <20140801074430.GB3588@twins.programming.kicks-ass.net>
 <20140801132120.GO18735@two.firstfloor.org>
 <20140801185057.GK19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801185057.GK19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > > I yelled at BIOS engineers over their PMU usage and $vendor 
> > > added a BIOS knob to disable that, I'll yell at BIOS engineers 
> > > again, just give me their number.
> > > 
> > > Really, say NO already.
> > 
> > Ok, so no technical reason, merely a "me vs you" power play.

Andi, stop the silly arguments already and stop launching personal 
attacks against maintainers who are simply doing their job!

> Clearly you forgot the discussion we had back then, you want me to 
> find you a link or do you think you can Google it yourself? I'm not 
> the only one who thinks its a terrible idea for the BIOS to involve 
> itself in these things.

The BIOS has no business stealing or meddling with limited resources 
used by and managed by the kernel, such as PMU state. In addition to 
the loss of utility to users when the BIOS interferes, PMUs are buggy 
and fragile enough even without any undue BIOS interference.

This was escallated up to Linus last time around and he agreed that 
such BIOS meddling with kernel state is not acceptable, so you'll 
probably have to convince him as well in addition to having to 
convince every perf and x86 maintainer.

	Ingo
