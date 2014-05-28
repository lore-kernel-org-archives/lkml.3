Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaE1RPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:15:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:42489 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbaE1RPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:15:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,929,1392192000"; 
   d="scan'208";a="547899475"
Date: Wed, 28 May 2014 10:12:43 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528171243.GL29957@tassilo.jf.intel.com>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
 <20140528145831.GH29957@tassilo.jf.intel.com>
 <CABPqkBQZWC33egtrpGLUHKizzrFRAz68-AsP-GWxB=Q--bjf8g@mail.gmail.com>
 <20140528165144.GK29957@tassilo.jf.intel.com>
 <CABPqkBRBB0feNceYJCU43efOfyQqAugzaWzz04mr7mzEoJGhsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRBB0feNceYJCU43efOfyQqAugzaWzz04mr7mzEoJGhsw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, you're telling me this is a sanity check. That p->status can
> only have one bit set. Somehow that's not how I recall it working.

It can have multiple bits set. We don't know for sure for which
it is, but we should only deliver it for one anyways.

> The point is that a single PEBS record is enough for multiple
> events when the overflows occur simultaneously because they
> all get the same machine state which is correct.  A single entry
> also saves space in the buffer.

The CPU will generate multiple PEBS records in this case.
So if we delivered it for all you would overcount by factor 4x

[Again this is a very unlikely situation. Normally counters
are not in lock step]

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
