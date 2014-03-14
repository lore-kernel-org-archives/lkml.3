Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbaCNQVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:21:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46584 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbaCNQVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:21:50 -0400
Date: Fri, 14 Mar 2014 17:21:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        namhyung@kernel.org, jolsa@redhat.com
Subject: Re: [PATCH 1/2] perf, x86: Disallow setting undefined bits for PEBS
 events
Message-ID: <20140314162137.GX27965@twins.programming.kicks-ass.net>
References: <1394745733-27855-1-git-send-email-andi@firstfloor.org>
 <20140314081338.GL27965@twins.programming.kicks-ass.net>
 <20140314135439.GD3793@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314135439.GD3793@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 06:54:39AM -0700, Andi Kleen wrote:
> On Fri, Mar 14, 2014 at 09:13:38AM +0100, Peter Zijlstra wrote:
> > On Thu, Mar 13, 2014 at 02:22:12PM -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > The SDM forbids setting various event qualifiers with PEBS
> > > events. The magic cycles:pp event uses it, but it has caused
> > > problems in the past. We continue allowing it for cycles:pp,
> > > but forbid it for all other events to follow the SDM.
> > 
> > Last time this came up I asked for what kind of problems it caused.
> 
> The original PEBS lockup on Sandy Bridge was caused by these bits.

I reread that thread (non-public sorry) and no; it was a clear hardware
fail there that got INST_RETIRED.ANY_P (0x00c0) retracted as PEBS
capable. It wasn't the extra bits, it would take your machine down just
fine without them.

And the work around suggested by Intel (the one currently in
intel_pebs_alias_snb) also didn't fail because of those extra bits
AFAIK. The thread suggests something else -- but again, that's all
non-public :-(

The very fact that we have Intel sanctioned events with those bits in
says they're not universally bad.

> The person who architected the hardware strongly advised to not
> use them with PEBS events.

That's a non statement; it doesn't contain anything useful, such
statements must be qualified with why he advises against them.

If its purely because the results are not guaranteed; we don't care. We
allow programming all kinds of crap into normal counters too; you get to
keep whatever nonsense the CPU counts.

> Besides we do what the SDM tells us to do. Do you disagree
> with that?

We don't, that thing is plenty wrong.

So stop trying to play the non-information game and state something
concrete already. Then again, frankly I don't trust you anymore so
pretty much anything you say will be doubted.
