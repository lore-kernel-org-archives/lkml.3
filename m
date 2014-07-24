Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbaGXOHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:07:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:46059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942AbaGXOHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:07:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,724,1400050800"; 
   d="scan'208";a="548427199"
Date: Thu, 24 Jul 2014 17:06:20 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, chiauee85@gmail.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] spi/pxa2xx-pci: Enable DMA binding through device name
Message-ID: <20140724140620.GP1857@lahna.fi.intel.com>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com>
 <10365151.12bEvS9Gvj@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10365151.12bEvS9Gvj@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 01:42:10PM +0200, Arnd Bergmann wrote:
> On Thursday 24 July 2014 18:01:51 Kweh Hock Leong wrote:
> > From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
> > 
> > Intel LPSS Baytrail supports two DMA controllers and SPI is only
> > using one of the DMA controller. During DMA channel request,
> > we need to ensure the requested Tx and Rx channels are from the correct
> > DMA controller. Thus, we add extra checking in filter callback funtion
> > by matching against the DMA controller device name.
> > 
> > Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> > Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
> 
> I'm confused. Doesn't  Bay Trail use ACPI to do the DMA
> engine configuration? That should set find the right device/chan_id/slave_id
> combination without any interaction, through the use of dma_request_slave_channel.

It is also possible that the corresponding Baytrail system doesn't have
ACPI enabled BIOS in which case it dma_request_slave_channel() doesn't
help here.

> On a related note, there seems to be a bug in this driver, which
> attempts to set the slave_id through dmaengine_slave_config(), which
> is wrong in both cases, ACPI and filter functions.

Good point. We will fix this, thanks.
