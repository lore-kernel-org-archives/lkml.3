Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaCNN4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:56:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:53260 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372AbaCNN4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:56:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,655,1389772800"; 
   d="scan'208";a="499878632"
Date: Fri, 14 Mar 2014 06:56:52 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Srinivas <venkateshs@google.com>, linux-kernel@vger.kernel.org,
        eranian@google.com, mingo@elte.hu, zheng.z.yan@intel.com
Subject: Re: [PATCH] perf/x86/intel: Use rdmsrl_safe when initializing RAPL
 PMU.
Message-ID: <20140314135652.GE3793@tassilo.jf.intel.com>
References: <1394739386-22260-1-git-send-email-venkateshs@google.com>
 <20140314084429.GO27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314084429.GO27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 09:44:29AM +0100, Peter Zijlstra wrote:
> On Thu, Mar 13, 2014 at 12:36:26PM -0700, Venkatesh Srinivas wrote:
> > CPUs which should support the RAPL counters according to
> > Family/Model/Stepping may still issue #GP when attempting to access
> > the RAPL MSRs. This may happen when Linux is running under KVM and
> > we are passing-through host F/M/S data, for example. Use rdmsrl_safe
> > to first access the RAPL_POWER_UNIT MSR; if this fails, do not
> > attempt to use this PMU.
> 
> This kvm thing is getting tedious :-(

It sounds bogus to me too, VMs are supposed to return 0 
on reading unknown MSRs, no #GP.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
