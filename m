Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030651AbaDJWwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 18:52:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43515 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030537AbaDJWw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 18:52:29 -0400
Message-ID: <53472093.7040502@ti.com>
Date: Thu, 10 Apr 2014 17:52:03 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: Re: [PATCH v2 00/14] dma: edma: Fixes for cyclic (audio) operation
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Other than patches 8/14 and 10/14 which I responded to, you could add my
Acked-by, or add it to the series itself once you make the changes and
drop 10.

Acked-by: Joel Fernandes <joelf@ti.com>

Thanks,
-Joel

On 04/01/2014 08:06 AM, Peter Ujfalusi wrote:
> Hi,
> 
> This is basically a resend of the previous series:
> https://lkml.org/lkml/2014/3/13/119
> with removed ASoC patches (most of them are applied already).
> 
> Changes since v1:
> - ASoC patches removed
> - Comments from Andriy Shevchenko addressed
> - patch added to fix cases when src/dst_maxburst is set to 0
> 
> Adding support for DMA pause/resume
> Possibility to select non default event queue/TC for cyclic (audio) dma
> channels: all devices using the eDMA via dmaengine was assigned to the default
> EQ/TC (mmc, i2c, spi, etc, and audio). This is not optimal from system
> performance point of view since sharing the same EQ/TC can cause latency spikes
> for cyclic channels (long DMA transfers for MMC for example).
> 
> While debugging the edma to get things sorted out I noticed that the debug was
> too verbose and the important information was hidden even when the we did not
> asked for verbose dmaengine debug.
> I have included some debug cleanups for the edma dmaengine driver also.
> 
> Regards,
> Peter
> ---
> Peter Ujfalusi (14):
>   platform_data: edma: Be precise with the paRAM struct
>   dma: edma: Correct the handling of src/dst_maxburst == 0
>   dma: edma: Add support for DMA_PAUSE/RESUME operation
>   dma: edma: Set DMA_CYCLIC capability flag
>   arm: common: edma: Select event queue 1 as default when booted with DT
>   arm: common: edma: Save the number of event queues/TCs
>   arm: common: edma: API to request non default queue for a channel
>   DMA: edma: Use different eventq for cyclic channels
>   dma: edma: Implement device_slave_caps callback
>   dma: edma: Simplify direction configuration in edma_config_pset()
>   dma: edma: Reduce debug print verbosity for non verbose debugging
>   dma: edma: Prefix debug prints where the text were identical in prep
>     callbacks
>   dma: edma: Add channel number to debug prints
>   dma: edma: Print the direction value as well when it is not supported
> 
>  arch/arm/common/edma.c             | 34 +++++++++++++-
>  drivers/dma/edma.c                 | 96 +++++++++++++++++++++++++++++---------
>  include/linux/platform_data/edma.h | 20 ++++----
>  3 files changed, 119 insertions(+), 31 deletions(-)
> 

