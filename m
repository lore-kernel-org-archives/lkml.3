Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaE1O7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:59:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:8499 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbaE1O7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:59:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,928,1392192000"; 
   d="scan'208";a="546201808"
Date: Wed, 28 May 2014 07:58:31 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, eranian@google.com
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528145831.GH29957@tassilo.jf.intel.com>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528081053.GP11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In particular, the 0x90 offset (IA32_PERF_GLOBAL_STATUS). Intel once
> confirmed to me that that is a direct copy of the similarly named MSR at
> the time of the PEBS assist.

That is correct.

> 
> This is a problem, since if multiple counters overflow multiple bits
> will be set and its (afaict) ambiguous which event is for which counter.

When a PEBS counter overflows it clears its respective GLOBAL_STATUS bit
automatically. You may see multiple STATUS bits in the PEBS record
if two PEBS counters overflow at exactly the same time, but that is no different
from the threshold==1 case (and relatively rare)

So the threshold > 1 and the threshold == 1 case work identically.

> So until you can give an official Intel answer on how all this demuxing
> is supposed to work and be correct this patch set isn't moving anywhere.

FWIW a patch signed off by intel.com is an official Intel statement.

> 
> > To supply a TID it
> > requires flushing on context switch. It can however supply the IP
> 
> On SNB+, previous to SNB it would need to have precise==1. I've seen no
> such logic in. Instead you seem to artificially limit it to SNB+, for no
> apparent reason to me.

Only tested on Sandy Bridge+

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
