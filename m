Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab3GDNpC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:45:02 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41660 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3GDNo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:44:59 -0400
Date: Thu, 4 Jul 2013 15:44:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v2 4/7] perf, x86: Save/resotre LBR stack during
 context switch
Message-ID: <20130704134457.GS6123@two.firstfloor.org>
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com>
 <1372663387-11754-5-git-send-email-zheng.z.yan@intel.com>
 <20130704095735.GL18898@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704095735.GL18898@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 11:57:35AM +0200, Peter Zijlstra wrote:
> On Mon, Jul 01, 2013 at 03:23:04PM +0800, Yan, Zheng wrote:
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > @@ -185,6 +185,13 @@ void intel_pmu_lbr_reset(void)
> >  		intel_pmu_lbr_reset_32();
> >  	else
> >  		intel_pmu_lbr_reset_64();
> > +
> > +	wrmsrl(x86_pmu.lbr_tos, 0);
> > +}
> 
> I double checked; my SDM Jun 2013, Vol 3C 35-93 very explicitly states that
> MSR_LASTBRANCH_TOS is a read-only MSR. And afaicr all previous times I checked
> this it did say this too.

Evidently it's not read-only on Haswell at least.

And if we don't restore the TOS it can be completely wrong, and
the stack state would corrupt.

The LBR stack is quite sensitive to any corruption of the state,
that is different from other LBR uses.

I suppose the wrmsr could be made checking to catch any potential
failure. But normally Intel CPUs are quite consistent in things
like that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
