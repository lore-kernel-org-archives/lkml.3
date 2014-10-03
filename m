Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750920AbaJCECO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 00:02:14 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38304 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaJCECM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 00:02:12 -0400
Date: Fri, 3 Oct 2014 06:02:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, eranian@google.com, tglx@linutronix.de,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] perf, x86: Use INTEL_FLAGS_UEVENT_CONSTRAINT for
 PRECDIST
Message-ID: <20141003040207.GA9049@gmail.com>
References: <1410310148-26260-1-git-send-email-andi@firstfloor.org>
 <1410310148-26260-2-git-send-email-andi@firstfloor.org>
 <20140910075926.GM6758@twins.programming.kicks-ass.net>
 <20140910140258.GI5387@tassilo.jf.intel.com>
 <20140910142232.GC4783@worktop.ger.corp.intel.com>
 <20140923095815.GA6179@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923095815.GA6179@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Sep 10, 2014 at 04:22:32PM +0200, Peter Zijlstra wrote:
> > On Wed, Sep 10, 2014 at 07:02:58AM -0700, Andi Kleen wrote:
> > > On Wed, Sep 10, 2014 at 09:59:26AM +0200, Peter Zijlstra wrote:
> > > > On Tue, Sep 09, 2014 at 05:49:08PM -0700, Andi Kleen wrote:
> > > > > From: Andi Kleen <ak@linux.intel.com>
> > > > > 
> > > > > The earlier commit 86a04461a made near all PEBS on
> > > > > Sandy/IvyBridge/Haswell to reject non zero flags.
> > > > 
> > > > What's magic about nehalem and westmere?
> > > 
> > > I wasn't able to confirm their behavior explicitly, so I felt
> > > it best to leave them alone.
> > > 
> > > But in principle adding the _FLAGS changes there too would
> > > make sense too.
> > 
> > Yeah please do that patch ASAP, having PEBS behave differently across
> > uarchs is wrong.
> 
> Ping!

Also, I have to NAK this patch for trivial style reasons: the 
patch adds gobs of misaligned, misplaced spaces instead of using 
proper tabs - and apparently that's not the first time Andi did 
that to the constraints tables.

This is annoying and ineffective and Andi Kleen continues to 
introduce trivial flaws into the kernel despite repeated 
complaints and requests for him to use available tools to check 
patch quality such as scripts/checkpatch.pl.

As a result I'm dropping most patches from Andi in the perf/core 
pipeline and I will delay them to at least until v3.19 when I 
might have more time to waste on reviewing trivially flawed 
patches.

I only took this single patch:

  perf/x86/intel/uncore: Fix minor race in box set up

which fixes a bug, and I've dropped all other patches from Andi.

Next time I see trivial flaws in Andi's patches I'll drop and 
delay them for two cycles, not one, to give them ample time to be 
improved.

Thanks,

	Ingo
