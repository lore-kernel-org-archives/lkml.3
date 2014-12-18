Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaLRKJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:09:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:24395 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaLRKJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:09:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,599,1413270000"; 
   d="scan'208";a="649738387"
Date: Thu, 18 Dec 2014 10:10:51 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sched: odd values for effective load calculations
Message-ID: <20141218021049.GA3210@intel.com>
References: <547E42F7.5070105@gmail.com>
 <20141213083012.GH32572@gmail.com>
 <20141215121227.GZ29390@twins.programming.kicks-ass.net>
 <20141215131410.GM10476@twins.programming.kicks-ass.net>
 <548FC338.4050409@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548FC338.4050409@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:29:28AM -0500, Sasha Levin wrote:
> On 12/15/2014 08:14 AM, Peter Zijlstra wrote:
> >>>> [  787.894288] ================================================================================
> >>>> > > > [  787.897074] UBSan: Undefined behaviour in kernel/sched/fair.c:4541:17
> >>>> > > > [  787.898981] signed integer overflow:
> >>>> > > > [  787.900066] 361516561629678 * 101500 cannot be represented in type 'long long int'
> >> > 
> >> > So that's:
> >> > 
> >> > 	this_eff_load *= this_load +
> >> > 		effective_load(tg, this_cpu, weight, weight);
> >> > 
> >> > Going by the numbers the 101500 must be 'this_eff_load', 100 * ~1024
> >> > makes that. Which makes the rhs 'large'. Do you have
> >> > CONFIG_FAIR_GROUP_SCHED enabled? If so, what kind of cgroup hierarchy
> >> > are you using?
> >> > 
> >> > In any case, bit sad this doesn't have a register dump included :/
> > Hmm, I was hoping to be able to see if it was this_load or the
> > effective_load() result being silly large, but going by the ASM output
> > of my compiler this isn't going to be available in registers, its all
> > stack spills.
> > 
> > Pinning my hopes on that reproducability thing :/
> 
> Okay, yeah, it's very reproducible. I've added:
> 

Hi Sasha,

I tried to reproduce this overflow, but got not luck (the trinity has been
running in a KVM VM for an hour)...

The trinity used is v1.4, and simply launched as ./trinity.

Could you detail your setup and procedure?

Thanks,
Yuyang
