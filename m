Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaE1Oqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:46:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:49373 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbaE1Oqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:46:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,928,1392192000"; 
   d="scan'208";a="547820869"
Date: Wed, 28 May 2014 07:46:43 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, eranian@google.com
Subject: Re: [RFC PATCH 5/7] perf, x86: use the PEBS auto reload mechanism
 when possible
Message-ID: <20140528144643.GG29957@tassilo.jf.intel.com>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-6-git-send-email-zheng.z.yan@intel.com>
 <20140528075937.GO11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528075937.GO11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 09:59:37AM +0200, Peter Zijlstra wrote:
> On Wed, May 28, 2014 at 02:18:08PM +0800, Yan, Zheng wrote:
> > When a fixed period is specified, this patch make perf use the PEBS
> > auto reload mechanism. This makes normal profiling faster, because
> > it avoids one costly MSR write in the PMI handler.
> > 
> 
> You can't do this unconditionally. Like I think you mention in the next
> patch, we need the PMI to fix up lots of cases.

There are two cases:

(1) Fixed period specified with PEBS.
The PMI still runs with threshold=1, but we can use the PEBS
auto-reload mechanism to automatically rewrite the counter which is
faster.

(2) Free running mode with more constraints

This is case (1)

-andi

-- 
ak@linux.intel.com -- Speaking for myself only
