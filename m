Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaFJFWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:22:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:55374 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbaFJFWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:22:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352833879"
Date: Tue, 10 Jun 2014 05:18:20 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC PATCH 07/16 v3] Init Workload Consolidation flags in
 sched_domain
Message-ID: <20140609211820.GA5361@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
 <1401431772-14320-8-git-send-email-yuyang.du@intel.com>
 <20140603121416.GH30445@twins.programming.kicks-ass.net>
 <5395F541.60604@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5395F541.60604@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 06:56:17PM +0100, Dietmar Eggemann wrote:

Thanks, Dietmar.

> I'm running these patches on my ARM TC2 on top of
> kernel/git/torvalds/linux.git (v3.15-rc7-79-gfe45736f4134). There're
> considerable changes in the area of sched domain setup since Vincent's
> patchset 'rework sched_domain topology description' (destined for v3.16)
> which you can find on kernel/git/tip/tip.git .
> 

Yeah, PeterZ pointed it out. It was on top of mainline not tip.

> Why did you make SD_WORKLOAD_CONSOLIDATION controllable via sysctl? All
> the other SD flags are set during setup.
> 

I don't understand. Any flag or parameter in sched_domain can be modified
on-the-fly after booting via sysctl. The SD_XXX_INIT is a template to make
the sched_domain initialization easier, IIUC.

Yes, I should not unconditionally enable SD_WORKLOAD_CONSOLIDATION in MC
and CPU domain (pointed out by PeterZ), but I did so for the purpose of
testing this patchset at this moment. Eventually, this flag should not be
turned on for any domain by default for many reasons, not to mention CPU
topology is getting more diverse/complex.

I just checked Vincent's "rework sched_domain topology description". The
general picture for init sched_domain does not change. If you work on top
of tip tree, you can simply skip this patch (0007), and after booting
enable SD_WORKLOAD_CONSOLIDATION by:

sysctl -w kernel.sched_domain.cpuX.domainY.flags += 0x8000
sysctl -w kernel.sched_domain.cpu0.domain1.consolidating_coeff=180
sysctl -w kernel.sched_cc_wakeup_threshold=80

> Your top_flag_domain() function
> takes care of figuring out what is the highest sd level this is set on
> during load-balance but I can't find any good reason to do it this way
> other then for testing purposes?

Any flag is used for testing whether it is set on or not when encountering
it, including the flags in sched_domain for load balancing, this is why flag
is called flag. My flag is any excpetion?

Thanks,
Yuyang
