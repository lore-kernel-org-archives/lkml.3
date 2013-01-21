Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3AUPop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 10:44:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51159 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab3AUPoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 10:44:44 -0500
Date: Mon, 21 Jan 2013 15:44:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com
Subject: Re: [PATCH v2 06/10] spi/pxa2xx: add support for DMA engine
Message-ID: <20130121154436.GL23505@n2100.arm.linux.org.uk>
References: <1358760723-32752-1-git-send-email-mika.westerberg@linux.intel.com> <1358760723-32752-7-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358760723-32752-7-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:31:59AM +0200, Mika Westerberg wrote:
> +bool dma_is_possible(size_t len)
> +int map_dma_buffers(struct driver_data *drv_data)
> +irqreturn_t dma_transfer(struct driver_data *drv_data)
> +int dma_prepare(struct driver_data *drv_data, u32 dma_burst)
> +void dma_start(struct driver_data *drv_data)
> +int dma_setup(struct driver_data *drv_data)
> +void dma_release(struct driver_data *drv_data)
> +void dma_resume(struct driver_data *drv_data)
> +int set_dma_burst_and_threshold(struct chip_data *chip,
> +				struct spi_device *spi,
> +				u8 bits_per_word, u32 *burst_code,
> +				u32 *threshold)

All the above function names end up in the global namespace in the kernel
image.  They're rather _too_ generic and non-specific for them to leak to
that visibility.  I think this needs fixing.

Also, I'd suggest that the long term plan is for PXA to move over to the
DMA engine API, so I'd recommend that the pxa2xx SPI driver have the
DMA engine API usage built into it, and let's treat the old PXA DMA
stuff as legacy code.
