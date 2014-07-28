Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaG1LG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:06:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:45713 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaG1LGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:06:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,748,1400050800"; 
   d="scan'208";a="550082795"
Message-ID: <1406545580.8530.28.camel@smile.fi.intel.com>
Subject: Re: [PATCH] spi/pxa2xx-pci: Enable DMA binding through device name
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, chiauee85@gmail.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Date: Mon, 28 Jul 2014 14:06:20 +0300
In-Reply-To: <5237362.DJsH7MtqlU@wuerfel>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com>
	 <5426556.OzZIXLrofJ@wuerfel> <1406285147.8530.13.camel@smile.fi.intel.com>
	 <5237362.DJsH7MtqlU@wuerfel>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 17:55 +0200, Arnd Bergmann wrote:
> On Friday 25 July 2014 13:45:47 Andy Shevchenko wrote:
> > On Fri, 2014-07-25 at 12:19 +0200, Arnd Bergmann wrote:
> > > On Friday 25 July 2014 12:55:59 Mika Westerberg wrote:
> > > > On Fri, Jul 25, 2014 at 12:07:14PM +0300, Mika Westerberg wrote:
> > > > > On Fri, Jul 25, 2014 at 10:38:36AM +0200, Arnd Bergmann wrote:
> > > > > > On Friday 25 July 2014 11:22:49 Mika Westerberg wrote:
> > 
> > []
> > 
> > > > Something like this?
> > 
> > Arnd, this dependency to certain DMA driver looks really bad.
> > 
> > If we go that way, can we split that part to [another] module and make
> > it dependent to DW_DMAC?
> 
> I don't see what you gain from that. The PCI ID will tell you which DMA
> engine is being used. The driver already hardcodes a slave_id based on
> the PCI ID today, and the 

"...and the..."?

> 
> > Or shall we introduce a dmaengine type field in the platform data and
> > dynamically choose proper filter-whatever-function to get the channel?
> 
> We already have an interface for this, in the form of
> dma_request_slave_channel(), which takes a string identifier that
> is used to look up all that information in either device tree or
> ACPI. It wouldn't be unreasonable to add a third path in there
> to handle hardcoded platform devices, but that's a lot of work.
> Note that you still need to encode a reference to the dma engine
> in some way to do this right. The current code (with or without Mika's
> patch) will break as soon as you have multiple DMA engine devices.

What about to keep PCI case still valid? We can pass struct pci_dev (or
actual struct device) of DMA controller to filter proper device.

> The current plan I think is to convert all platforms to use DT
> or ACPI so they get the right data from tables passed by the
> platform.

Good to know the road map.

[]

> > > What I think you got wrong here (by following my bad advice) is the master
> > > number. Looking at the code for dw_dma, I think src_master needs to be '1'
> > > for your driver.
> > 
> > On some SoCs we have up to 4 masters. It's blurry for me how the SPI
> > should choose those masters. Currently it works fine, but I suspect
> > there are [might be] performance issues.
> 
> I think it works because the dw-dma defaults to the values used by
> the specific implementation in your hardware.



> > What about AVR32 case? We have to fix drivers as well there.

> which ones?

arch/avr32/mach-at32ap/at32ap700x.c:1332:at32_add_device_mci

It seems opaque for me if it's used anywhere.


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

