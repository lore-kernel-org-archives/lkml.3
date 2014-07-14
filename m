Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaGNQJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:09:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:36180 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbaGNQIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:08:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,659,1400050800"; 
   d="scan'208";a="572902992"
Date: Mon, 14 Jul 2014 21:35:26 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: hongbo.zhang@freescale.com
Cc: vkoul@infradead.org, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        leo.li@freescale.com, scottwood@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] DMA: Freescale: driver cleanups and enhancements
Message-ID: <20140714160526.GL2296@intel.com>
References: <1400659383-6555-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400659383-6555-1-git-send-email-hongbo.zhang@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 04:03:00PM +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Hi Dan,
> Please have a look at this 3/3 as Vinod mentioned.
> 
> Hi Vinod Koul,
> Please have a look at the v5 patch set.

I dont see any objection, so applying all 3 with subject changed to reflect
correct subsystem name

-- 
~Vinod

> 
> v4 -> v5 changes:
>  - since previous 5 of 8 patches have been merged by Vinod, this iteration oly
>    inludes the last 3 patches of v4.
>  - patches order is changed for being reviewed and merged easier.
>  - remove the .prepare functions, and use the suspend_late and resume_early in
>    the suspend-and-resume patch.
> 
> v3 -> v4 changes:
>  - Fixed a typo in [2/8] commit message.
>  - There was a potential double call of list_del() when apply [4/8] only,
>    although this defect is removed again in later [6/8]. This version 
>    eliminates this problem by updating [4/8] and [6/8] slightly.
>  - Updated [8/8] to use register access method introduced by [2/8]
> 
> v2 -> v3 change:
> Only add "chan->pm_state = RUNNING" for patch[8/8].
> 
> v1 -> v2 change:
> The only one change is introducing a new patch[1/7] to remove the unnecessary
> macro FSL_DMA_LD_DEBUG, thus the total patches number is 8 now (was 7)
> 
> v1 notes:
> Note that patch 2~6 had beed sent out for upstream before, but were together
> with other storage patches at that time, that was not easy for being reviewed
> and merged, so I send them separately this time.
> 
> Hongbo Zhang (3):
>   DMA: Freescale: use spin_lock_bh instead of spin_lock_irqsave
>   DMA: Freescale: add suspend resume functions for DMA driver
>   DMA: Freescale: change descriptor release process for supporting
>     async_tx
> 
>  drivers/dma/fsldma.c |  297 ++++++++++++++++++++++++++++++++++++++------------
>  drivers/dma/fsldma.h |   32 +++++-
>  2 files changed, 260 insertions(+), 69 deletions(-)
> 
> -- 
> 1.7.9.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
