Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3HUHjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:39:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:5943 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab3HUHja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:39:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,926,1367996400"; 
   d="scan'208";a="389591191"
Date: Wed, 21 Aug 2013 10:44:57 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: fix SPI_BIT_MASK() to use correct size for 32-bit
 transfer mask
Message-ID: <20130821074457.GB4898@intel.com>
References: <1377000932-5438-1-git-send-email-mika.westerberg@linux.intel.com>
 <52139B4E.6070700@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52139B4E.6070700@wwwdotorg.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:37:34AM -0600, Stephen Warren wrote:
> On 08/20/2013 06:15 AM, Mika Westerberg wrote:
> > When building a 64-bit kernel we get the following warning from the
> > compiler:
> > 
> >  drivers/spi/spi-pxa2xx.c: In function ‘pxa2xx_spi_probe’:
> >  drivers/spi/spi-pxa2xx.c:1152:3: warning: large integer implicitly truncated to unsigned type [-Woverflow]
> >    master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
> >    ^
> > This is due the fact that when the max range is specified as 32
> > SPI_BIT_MASK() expands to ~0UL which doesn't fit to the u32 type that the
> > master->bits_per_word_mask is.
> > 
> > Fix this by using ~0U instead.
> 
> The same patch is already in next-20130819 at least, as:
> b6aa23c spi: fix SPI_BIT_MASK so it always fits into 32-bits

Cool :) Thanks for letting me know.
