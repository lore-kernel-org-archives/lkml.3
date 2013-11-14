Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab3KNBQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:16:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:63082 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab3KNBQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:16:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434925879"
Date: Thu, 14 Nov 2013 09:16:31 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Huang Ying <ying.huang@intel.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: performance regressions by "seqcount: Add lockdep functionality
 to seqcount/seqlock structures"
Message-ID: <20131114011631.GA11857@yliu-dev.sh.intel.com>
References: <20131113091408.GH22256@yliu-dev.sh.intel.com>
 <5283B9A0.2080502@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5283B9A0.2080502@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 09:40:48AM -0800, John Stultz wrote:
> On 11/13/2013 01:14 AM, Yuanhan Liu wrote:
> > Hi,
> >
> > FYI, we found some performance regressions caused by commit 1ca7d67c
> > ("seqcount: Add lockdep functionality to seqcount/seqlock structures")
> 
> So this is expected. seqlock readers are usually very very cheap

Yeah, sorry for not mentioning that we knew it's expected, but we want
to show you the exact number of slow downs.

Thanks.

	--yliu
> operations, and we're now doing lockdep tracking on every iteration
> around the loop. As the lockdep help states:
> 
>   | If you say Y here, the lock dependency engine will
> do                   |  
>   | additional runtime checks to debug itself, at the
> price                 |  
>   | of more runtime overhead.
> 
> 
> So now since we're also tracking seqlocks in addition to spinlocks, it
> creates more overhead.
> 
> 
> Disabling CONFIG_LOCKDEP should restore performance.
> 
> thanks
> -john
