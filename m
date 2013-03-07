Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761Ab3CGMxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:53:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:45815 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460Ab3CGMxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:53:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,802,1355126400"; 
   d="scan'208";a="266021808"
Date: Thu, 7 Mar 2013 17:58:51 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ioatdma: allow all channels to have irq coalescing
 support
Message-ID: <20130307122851.GK13370@intel.com>
References: <20130226162036.4996.78263.stgit@djiang5-linux2.ch.intel.com>
 <84A937D219C2B44EB8EA44831ACA1E49171E519C@PRN-MBX02-3.TheFacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84A937D219C2B44EB8EA44831ACA1E49171E519C@PRN-MBX02-3.TheFacebook.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 10:30:01PM +0000, Dan Williams wrote:
> 
> 
> On 2/26/13 8:20 AM, "Dave Jiang" <dave.jiang@intel.com> wrote:
> 
> >Looks like only the RAID channels are allowed to have irq coalescing
> >support
> >in the existing code. Fixing that. The ioat3 cleanup code can handle
> >memcpy
> >ops anyways
> >
> >Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Applied thanks
> >---
> > drivers/dma/ioat/dma_v3.c |   12 +++---------
> > 1 file changed, 3 insertions(+), 9 deletions(-)
> >
> >diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> >index 47588dc..368a184 100644
> >--- a/drivers/dma/ioat/dma_v3.c
> >+++ b/drivers/dma/ioat/dma_v3.c
> >@@ -1268,15 +1268,9 @@ int __devinit ioat3_dma_probe(struct
> >ioatdma_device *device, int dca)
> > 	}
> > 
> > 
> >-	if (is_raid_device) {
> >-		dma->device_tx_status = ioat3_tx_status;
> >-		device->cleanup_fn = ioat3_cleanup_event;
> >-		device->timer_fn = ioat3_timer_event;
> >-	} else {
> >-		dma->device_tx_status = ioat_dma_tx_status;
> >-		device->cleanup_fn = ioat2_cleanup_event;
> >-		device->timer_fn = ioat2_timer_event;
> >-	}
> >+	dma->device_tx_status = ioat3_tx_status;
> >+	device->cleanup_fn = ioat3_cleanup_event;
> >+	device->timer_fn = ioat3_timer_event;
> > 
> > 	#ifdef CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA
> > 	dma_cap_clear(DMA_PQ_VAL, dma->cap_mask);
> 
> Acked-by: Dan Williams <djbw@fb.com>
> 
