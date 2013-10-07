Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3JGP7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:59:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38995 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3JGP7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:59:52 -0400
Date: Mon, 7 Oct 2013 17:59:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Clean up cap_user_time* setting
Message-ID: <20131007155937.GT26785@twins.programming.kicks-ass.net>
References: <tip-nmgn0j0muo1r4c94vlfh23xy@git.kernel.org>
 <524F097A.9010506@intel.com>
 <20131004185539.GT15690@laptop.programming.kicks-ass.net>
 <20131006091054.GA4342@gmail.com>
 <20131007093322.GA3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007093322.GA3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 11:33:22AM +0200, Peter Zijlstra wrote:
> On Sun, Oct 06, 2013 at 11:10:54AM +0200, Ingo Molnar wrote:
> > I'm fully with you, please zap the 'notsc' boot option - it's an ancient 
> > relic, if any box is still broken with the TSC on we want to hear about it 
> > and fix it!
> 
> something like so?
> 
> ---
> Subject: x86: Remove 'notsc' option for X86_TSC=y kernels
> 
> The 'notsc' thing is an ancient relic, if there's still any hardware
> that needs this we need to hear about it.
> 
> This only removes the option for X86_TSC=y kernels; X86_TSC=n kernels
> can still use it to force remove the TSC capability flag.
> 
> Since this removes the tsc_disabled=1 assignment, also remove all
> tsc_disabled>0 tests as those will never be true.
> 
> Suggested-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

OK, so I forgot to compile this this morning; but I now found
apicpmtimer somehow calls notsc_setup(). I've no idea why, but can
someone who knows this crap take a look?
