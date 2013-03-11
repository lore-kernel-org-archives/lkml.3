Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3CKMm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 08:42:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:39024 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab3CKMmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 08:42:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,822,1355126400"; 
   d="scan'208";a="299073407"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: A proposal to check the device in generic way
Thread-Topic: A proposal to check the device in generic way
Thread-Index: AQHOHlOXs8g2THZZt02CceOgK5RzFZigbx0A
Date: Mon, 11 Mar 2013 12:42:40 +0000
Message-ID: <1363005746.18714.7.camel@smile>
References: <1363001537.18714.3.camel@smile>
	 <Pine.LNX.4.64.1303111302340.21241@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1303111302340.21241@axis700.grange>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D8249CC79CE424A888D86C48F15541E@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2BCh4Wv007036

On Mon, 2013-03-11 at 13:26 +0100, Guennadi Liakhovetski wrote: 
> > Currently in linux-next we have the following things:
> > 
> > $ git grep -n 'chan->device->dev->driver' drivers/dma/
> > 
> > drivers/dma/amba-pl08x.c:1594:  if (chan->device->dev->driver !=
> > &pl08x_amba_driver.drv)
> > drivers/dma/dmaengine.c:190:    return chan->device->dev->driver->owner;
> > drivers/dma/edma.c:609: if (chan->device->dev->driver ==
> > &edma_driver.driver) {
> > drivers/dma/omap-dma.c:654:     if (chan->device->dev->driver ==
> > &omap_dma_driver.driver) {
> > drivers/dma/pl330.c:2374:       if (chan->device->dev->driver !=
> > &pl330_driver.drv)
> > drivers/dma/sa11x0-dma.c:1080:  if (chan->device->dev->driver ==
> > &sa11x0_dma_driver.driver) 
> > 
> > I think it's a non-generic way to check which driver provides a channel
> > into filter function. First of all, I don't get why that comparison goes
> > as deep as driver structure. Isn't clearer to check chan->device->dev
> > against the struct dev passed in the custom parameter structure? Like:
> > 
> > struct filter_params {
> >  struct dev *dev;
> >  void *param;
> > };
> 
> I don't think you always know which DMA device you want to use with this 
> DMA client - sometimes there are several DMA engine devices, that can be 
> used with your DMA client, or even if it's only one, you don't necessarily 
> have a pointer to it in your DMA client.

Ah, right. But let's assume we will use filter_fn in conjunction with
xlate_fn. In that case we will have explicit understanding for which
device we registered specific xlate_fn. So, xlate_fn could provide
struct device pointer to be compared with, though I prefer to have more
suitable mechanism instead of filter_fn.

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
