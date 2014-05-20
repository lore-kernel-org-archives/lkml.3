Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062AbaETFZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:25:09 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:25895 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbaETFZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:25:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgGAHvmelN5LL1s/2dsb2JhbABZgwarBwEBAQaaKQGBFBd0giUBAQQBJxMcIwULCAMOCgklDwUlAyETG4geB9JaFxaFP4h5B4RAAQOZX4sTiAuDSis
Date: Tue, 20 May 2014 15:24:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] mm/vmscan: Do not block forever at
 shrink_inactive_list().
Message-ID: <20140520052452.GG18954@dastard>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
 <20140520004449.GE18954@dastard>
 <201405200354.s4K3sTUx057458@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201405200354.s4K3sTUx057458@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 12:54:29PM +0900, Tetsuo Handa wrote:
> Dave Chinner wrote:
> > So, XFS should be passing kswapd context to the workqueue allocation
> > context. The patch below does this.
> > 
> > Tetsuo-san, when it comes to problems involving XFS, you should
> > really CC xfs@oss.sgi.com because very few people really know how
> > XFS works and even fewer still know how it is supposed to interact
> > with memory reclaim....
> 
> Thank you for the patch, but ...
> 
>   #define PF_KSWAPD       0x00040000      /* I am kswapd */
> 
>   static inline int current_is_kswapd(void)
>   {
>   	return current->flags & PF_KSWAPD;
>   }

> I think ((char) (current->flags & 0x00040000)) == 0.
> Your patch wants
> 
>   -args->kswapd = current_is_kswapd();
>   +args->kswapd = (current_is_kswapd() != 0);

Thanks for pointing that out, but I think:

-static inline int current_is_kswapd(void)
+static inline bool current_is_kswapd(void)

is a better solution. It can only be true or false.

But regardless, I need to change the boolean options in that XFS
structure to be, well, booleans.

Cheers,

dave.

-- 
Dave Chinner
david@fromorbit.com
