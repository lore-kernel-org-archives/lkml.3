Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887Ab3JPUwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:52:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:56933 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761976Ab3JPUw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:52:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="394007860"
Date: Wed, 16 Oct 2013 13:52:27 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, dave.hansen@linux.intel.com,
        eranian@google.com, jmario@redhat.com, linux-kernel@vger.kernel.org,
        acme@infradead.org, mingo@kernel.org
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131016205227.GJ7456@tassilo.jf.intel.com>
References: <20131014203549.GY227855@redhat.com>
 <20131015101404.GD10651@twins.programming.kicks-ass.net>
 <20131015130226.GX26785@twins.programming.kicks-ass.net>
 <20131015143227.GY26785@twins.programming.kicks-ass.net>
 <20131015150736.GZ26785@twins.programming.kicks-ass.net>
 <20131015154104.GA227855@redhat.com>
 <20131016105755.GX10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016105755.GX10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So avoid having to call copy_from_user_nmi() for every instruction.
> Since we already limit the max basic block size, we can easily
> pre-allocate a piece of memory to copy the entire thing into in one
> go.

It would be better/more generic if you split copy_from_user_nmi() into
init() copy() end() 

(and some state that checks if the underlying page changes)

Then first you don't need the buffer and it could be also
be applied to the other cases, like the stack unwinding,
where copying everything is likely too slow.

-Andi
