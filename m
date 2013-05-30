Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966061Ab3E3Rus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:50:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:22239 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965865Ab3E3Rum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:50:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,772,1363158000"; 
   d="scan'208";a="248760869"
Date: Thu, 30 May 2013 22:42:26 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 3/6] dma: Add a jz4740 dmaengine driver
Message-ID: <20130530171225.GA3767@intel.com>
References: <1369931105-28065-1-git-send-email-lars@metafoo.de>
 <1369931105-28065-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369931105-28065-4-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 06:25:02PM +0200, Lars-Peter Clausen wrote:
> This patch adds dmaengine support for the JZ4740 DMA controller. For now the
> driver will be a wrapper around the custom JZ4740 DMA API. Once all users of the
> custom JZ4740 DMA API have been converted to the dmaengine API the custom API
> will be removed and direct hardware access will be added to the dmaengine
> driver.
> 
> +
> +#include <asm/mach-jz4740/dma.h>
Am bit worried about having header in arch. Why cant we have this drivers header
in linux/. That way same IP block cna be reused across archs.
I was hoping that you would have move it in 6th patch, but that isnt the case


> +static int jz4740_dma_alloc_chan_resources(struct dma_chan *c)
> +{
> +	struct jz4740_dmaengine_chan *chan = to_jz4740_dma_chan(c);
> +
> +	chan->jz_chan = jz4740_dma_request(chan, NULL);
> +	if (!chan->jz_chan)
> +		return -EBUSY;
> +
> +	jz4740_dma_set_complete_cb(chan->jz_chan, jz4740_dma_complete_cb);
> +
> +	return 0;
Sorry, I didnt reply on this one. The API expects you to allocate a pool of
descriptors. These descriptors are to be used in .device_prep_xxx calls later.

--
~Vinod
