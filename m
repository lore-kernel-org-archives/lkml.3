Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3BEGL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 01:11:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:59644 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab3BEGL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 01:11:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="252671291"
Date: Tue, 5 Feb 2013 08:15:14 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com
Subject: Re: [PATCH v3 05/10] spi/pxa2xx: break out the private DMA API usage
 into a separate file
Message-ID: <20130205061514.GO20771@intel.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358850393-23111-6-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdZyH-1SfFFaj_YMt4dcN1c9Y6Uy1iZrzHqqqt8o_AgMLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZyH-1SfFFaj_YMt4dcN1c9Y6Uy1iZrzHqqqt8o_AgMLw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 08:43:42PM +0100, Linus Walleij wrote:
> On Tue, Jan 22, 2013 at 11:26 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > The PXA SPI driver uses PXA platform specific private DMA implementation
> > which does not work on non-PXA platforms. In order to use this driver on
> > other platforms we break out the private DMA implementation into a separate
> > file that gets compiled only when CONFIG_SPI_PXA2XX_PXADMA is set. The DMA
> > functions are stubbed out if there is no DMA implementation selected (i.e
> > we are building on non-PXA platform).
> >
> > While we are there we can kill the dummy DMA bits in pxa2xx_spi.h as they
> > are not needed anymore for CE4100.
> >
> > Once this is done we can add the generic DMA engine support to the driver
> > that allows usage of any DMA controller that implements DMA engine API.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> > This patch was already acked by Linus W but since I changed this by
> > breaking out the PXA private implementation into a separate file, I'm
> > hoping to get new ack from him ;-)
> 
> Sorry for the long delay. This is a nice and clean cut.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks!
