Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbaDVQOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:14:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:16280 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632AbaDVQOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:14:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,904,1389772800"; 
   d="scan'208";a="517381785"
Date: Tue, 22 Apr 2014 21:33:04 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: dan.j.williams@intel.com, nsekhar@ti.com, joelf@ti.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH v3 00/10] dma: edma: Fixes for cyclic (audio) operation
Message-ID: <20140422160303.GX32284@intel.com>
References: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 02:41:55PM +0300, Peter Ujfalusi wrote:
> Hi,
> 
> Changes since v2:
> - Dropped patch 10 from v2 (simplify direction configuration...)
> - Dropped the channel priority related patches since we are going to go via
>   different route for configuring the priority.
> - Added ACK from Joel for the patches since they are not changed since v2
> 
> Changes since v1:
> - ASoC patches removed
> - Comments from Andriy Shevchenko addressed
> - patch added to fix cases when src/dst_maxburst is set to 0
> 
> The series contains now only:
> Support for DMA pause/resume in cyclic mode
> device_slave_caps callback and DMA_CYCLIC flag correction.
> While debugging the edma to get things sorted out I noticed that the debug was
> too verbose and the important information was hidden even when the we did not
> asked for verbose dmaengine debug.
> I have included some debug cleanups for the edma dmaengine driver also.
> 
Applied all, expect 9th one!

-- 
~Vinod

> Regards,
> Peter
> ---
> Peter Ujfalusi (10):
>   platform_data: edma: Be precise with the paRAM struct
>   arm: common: edma: Save the number of event queues/TCs
>   dmaengine: edma: Correct the handling of src/dst_maxburst == 0
>   dmaengine: edma: Add support for DMA_PAUSE/RESUME operation
>   dmaengine: edma: Set DMA_CYCLIC capability flag
>   dmaengine: edma: Implement device_slave_caps callback
>   dmaengine: edma: Reduce debug print verbosity for non verbose
>     debugging
>   dmaengine: edma: Prefix debug prints where the text were identical in
>     prep callbacks
>   dmaengine: edma: Add channel number to debug prints
>   dmaengine: edma: Print the direction value as well when it is not
>     supported
> 
>  arch/arm/common/edma.c             |  4 ++
>  drivers/dma/edma.c                 | 87 ++++++++++++++++++++++++++++++--------
>  include/linux/platform_data/edma.h | 18 ++++----
>  3 files changed, 83 insertions(+), 26 deletions(-)
> 
> -- 
> 1.9.2
> 

-- 
