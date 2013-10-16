Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422Ab3JPJTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:19:10 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:57637 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760099Ab3JPJTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:19:07 -0400
Date: Wed, 16 Oct 2013 11:19:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 12/14] sched: make dl_bw a sub-quota of rt_bw
Message-ID: <20131016091901.GA23440@gmail.com>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
 <1381747426-31334-13-git-send-email-juri.lelli@gmail.com>
 <20131014140618.GA26604@gmail.com>
 <525D1234.5060001@gmail.com>
 <20131015102621.GE10651@twins.programming.kicks-ass.net>
 <20131015122522.GB2402@gmail.com>
 <20131015123527.GI10651@twins.programming.kicks-ass.net>
 <20131015131133.GC2402@gmail.com>
 <20131016085936.GU10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016085936.GU10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Oct 15, 2013 at 03:11:33PM +0200, Ingo Molnar wrote:
> > The scheduler has over 800 #ifdefs or similar preprocessor directives:
> > 
> >   comet:~/tip> git grep '^#' kernel/sched/ | grep -v include | wc -l
> >   855
> > 
> > I'd like to see this simplified a bit, _especially_ before we add new 
> > complexity ...
> 
> I agree; however I also think its unfair to pile this on Juri.

Well, it's that particular ugly #ifdef that caught my eye.

> [...] Esp the avenue pushed here, which will increase UP text and 
> (runtime) data sizes, to which I think some people will still object.
> 
> There's this entire 'maker' community (aka. internet of things) now 
> using very small Linux devices. Think Raspberry-Pi, Intel Quark (however 
> much I hate Intel for shipping a new 32bit device) etc.
> 
> These people are wanting to run Linux on these tiny devices, with tiny 
> memories etc; we shouldn't make their life harder than it already is.
> 
> Also; you didn't object about the 29 new #ifdefs currently in tip.

It was the straw that broke the camel's back.

> How about we use some of the 'quality' conference time in EDI to do some 
> big code shuffles to get rid of some of them. I'm sure we can reduce the 
> number of ifdeffery by simply merging various similar blocks and maybe 
> write a few extra helper functions.
> 
> This is how kernel/sched/ got created in the first place; as a means to 
> keep the fingers busy at a conference ;-)

LOL, agreed, we can try that ;-)

Also, we can certainly merge SCHED_DEADLINE first, as long as there's a 
hard feature stop afterwards and as long as cleanups will eventually 
arrive.

Thanks,

	Ingo
