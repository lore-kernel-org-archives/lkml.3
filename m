Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaG1L5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:57:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:60258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaG1L46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:56:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,748,1400050800"; 
   d="scan'208";a="576531160"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "arnd@arndb.de" <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "chiauee85@gmail.com" <chiauee85@gmail.com>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] spi/pxa2xx-pci: Enable DMA binding through device name
Thread-Topic: [PATCH] spi/pxa2xx-pci: Enable DMA binding through device name
Thread-Index: AQHPqlr0gNBtsofVVEaZbV9KO39Y6A==
Date: Mon, 28 Jul 2014 11:56:25 +0000
Message-ID: <1406548584.8530.35.camel@smile.fi.intel.com>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com>
	 <5426556.OzZIXLrofJ@wuerfel> <1406285147.8530.13.camel@smile.fi.intel.com>
	 <5237362.DJsH7MtqlU@wuerfel> <1406545580.8530.28.camel@smile.fi.intel.com>
In-Reply-To: <1406545580.8530.28.camel@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F32BCA7CAE2AF44EB81825B7FD8A6171@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6SBvA40015499

On Mon, 2014-07-28 at 14:06 +0300, Andy Shevchenko wrote:
> On Fri, 2014-07-25 at 17:55 +0200, Arnd Bergmann wrote:
> > On Friday 25 July 2014 13:45:47 Andy Shevchenko wrote:

[]

> > > > What I think you got wrong here (by following my bad advice) is the master
> > > > number. Looking at the code for dw_dma, I think src_master needs to be '1'
> > > > for your driver.
> > > 
> > > On some SoCs we have up to 4 masters. It's blurry for me how the SPI
> > > should choose those masters. Currently it works fine, but I suspect
> > > there are [might be] performance issues.
> > 
> > I think it works because the dw-dma defaults to the values used by
> > the specific implementation in your hardware.

[Missed in previous email]

Actually the defaults came from original driver for AVR32 case.

Regarding to DW DMA databook the AHB masters could be used each by any
channel, though it depends on what AHB layer is bound to (and
corresponding peripheral device).

Thus, like I said we might have the [minor] performance issues if we
use, for example, two out of four masters.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
