Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3AUQKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:10:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:39370 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab3AUQKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:10:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,507,1355126400"; 
   d="scan'208";a="274712517"
Date: Mon, 21 Jan 2013 18:14:01 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com
Subject: Re: [PATCH v2 06/10] spi/pxa2xx: add support for DMA engine
Message-ID: <20130121161400.GW2239@intel.com>
References: <1358760723-32752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358760723-32752-7-git-send-email-mika.westerberg@linux.intel.com>
 <20130121154436.GL23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121154436.GL23505@n2100.arm.linux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 03:44:36PM +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 21, 2013 at 11:31:59AM +0200, Mika Westerberg wrote:
> > +bool dma_is_possible(size_t len)
> > +int map_dma_buffers(struct driver_data *drv_data)
> > +irqreturn_t dma_transfer(struct driver_data *drv_data)
> > +int dma_prepare(struct driver_data *drv_data, u32 dma_burst)
> > +void dma_start(struct driver_data *drv_data)
> > +int dma_setup(struct driver_data *drv_data)
> > +void dma_release(struct driver_data *drv_data)
> > +void dma_resume(struct driver_data *drv_data)
> > +int set_dma_burst_and_threshold(struct chip_data *chip,
> > +				struct spi_device *spi,
> > +				u8 bits_per_word, u32 *burst_code,
> > +				u32 *threshold)
> 
> All the above function names end up in the global namespace in the kernel
> image.  They're rather _too_ generic and non-specific for them to leak to
> that visibility.  I think this needs fixing.

Indeed, good point. I will fix this.

> Also, I'd suggest that the long term plan is for PXA to move over to the
> DMA engine API, so I'd recommend that the pxa2xx SPI driver have the
> DMA engine API usage built into it, and let's treat the old PXA DMA
> stuff as legacy code.

In the previous version I had the old PXA DMA stuff behind #ifdef
CONFIG_ARCH_PXA and otherwise it used the DMA engine stuff. Do you mean
something like that (e.g keep both DMA in the single file)?
