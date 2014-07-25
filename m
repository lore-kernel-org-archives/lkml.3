Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbaGYKpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:45:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:5329 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760101AbaGYKpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:45:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,730,1400050800"; 
   d="scan'208";a="548916533"
Message-ID: <1406285147.8530.13.camel@smile.fi.intel.com>
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
Date: Fri, 25 Jul 2014 13:45:47 +0300
In-Reply-To: <5426556.OzZIXLrofJ@wuerfel>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com>
	 <20140725090714.GY1857@lahna.fi.intel.com>
	 <20140725095559.GA1857@lahna.fi.intel.com> <5426556.OzZIXLrofJ@wuerfel>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 12:19 +0200, Arnd Bergmann wrote:
> On Friday 25 July 2014 12:55:59 Mika Westerberg wrote:
> > On Fri, Jul 25, 2014 at 12:07:14PM +0300, Mika Westerberg wrote:
> > > On Fri, Jul 25, 2014 at 10:38:36AM +0200, Arnd Bergmann wrote:
> > > > On Friday 25 July 2014 11:22:49 Mika Westerberg wrote:

[]

> > Something like this?

Arnd, this dependency to certain DMA driver looks really bad.

If we go that way, can we split that part to [another] module and make
it dependent to DW_DMAC?

Or shall we introduce a dmaengine type field in the platform data and
dynamically choose proper filter-whatever-function to get the channel?

> > Hock Leong / Chiaue Ee, are you able to check if this works on your BYT
> > machines?

> What I think you got wrong here (by following my bad advice) is the master
> number. Looking at the code for dw_dma, I think src_master needs to be '1'
> for your driver.

On some SoCs we have up to 4 masters. It's blurry for me how the SPI
should choose those masters. Currently it works fine, but I suspect
there are [might be] performance issues.

What about AVR32 case? We have to fix drivers as well there.

> the dw_dma driver can be simplified a little by removing the special
> case for the request line setting.

Yes, this part I like.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

