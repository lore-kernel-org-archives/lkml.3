Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab3AQJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:56:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:29241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759375Ab3AQJ4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:56:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,484,1355126400"; 
   d="scan'208";a="248221578"
Date: Thu, 17 Jan 2013 12:00:04 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        eric.y.miao@gmail.com, linux@arm.linux.org.uk,
        haojian.zhuang@gmail.com, broonie@opensource.wolfsonmicro.com,
        chao.bi@intel.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 06/11] spi/pxa2xx: use the private DMA API only when
 CONFIG_ARCH_PXA is set
Message-ID: <20130117100004.GS2239@intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <1357555480-24022-7-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdZBF0SkW+Ux7+HdsSQwnnxXG6o4yNp9mrmufXD=yrTwTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZBF0SkW+Ux7+HdsSQwnnxXG6o4yNp9mrmufXD=yrTwTg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:36:19AM +0100, Linus Walleij wrote:
> On Mon, Jan 7, 2013 at 11:44 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > The PXA SPI driver uses PXA platform specific private DMA implementation
> > which does not work on non-PXA platforms. In order to use this driver on
> > other platforms we need to move the private DMA implementation into a
> > separate functions that get stubbed out when !CONFIG_ARCH_PXA.
> >
> > While we are there we can kill the dummy DMA bits in pxa2xx_spi.h as they
> > are not needed anymore for CE4100.
> >
> > Once this is done we can add the generic DMA engine support to the driver
> > that allows usage of any DMA controller that implements DMA engine API.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/spi/spi-pxa2xx.c       |  612 +++++++++++++++++++++++-----------------
> >  include/linux/spi/pxa2xx_spi.h |   80 ------
> 
> Can you even break this out to its own file?
> 
> Like drivers/spi/spi-pxa2xx-pxadma.c/.h
> with stubs in the header file or something so we need
> no #ifdefs in the main driver file?

Good point. I need to refresh the series anyway because of the x86 common
clock changes (which I'm hoping the x86 maintainers accept), so I can do
the file split as well.

> The kernel looks better after this patch anyway, so
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> in any case.

Thanks!
