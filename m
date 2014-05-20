Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaETMwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:52:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:14349 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaETMwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:52:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,874,1392192000"; 
   d="scan'208";a="514761842"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "emilio@elopez.com.ar" <emilio@elopez.com.ar>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "zhuzhenhua@allwinnertech.com" <zhuzhenhua@allwinnertech.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [linux-sunxi] [PATCH v7] DMA: sun6i: Add driver for the
 Allwinner A31 DMA controller
Thread-Topic: [linux-sunxi] [PATCH v7] DMA: sun6i: Add driver for the
 Allwinner A31 DMA controller
Thread-Index: AQHPdCjkVstB+kS5gUWDjVzoNLiqD5tJW6cA
Date: Tue, 20 May 2014 12:52:34 +0000
Message-ID: <1400590354.28000.14.camel@smile.fi.intel.com>
References: <1398349364-10726-1-git-send-email-maxime.ripard@free-electrons.com>
	 <1398349364-10726-2-git-send-email-maxime.ripard@free-electrons.com>
	 <537B4D55.5040804@elopez.com.ar>
In-Reply-To: <537B4D55.5040804@elopez.com.ar>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6952EE4279C1E44D9E09E91732966148@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4KCr8ed011903

On Tue, 2014-05-20 at 09:40 -0300, Emilio LÃ³pez wrote:
> El 24/04/14 11:22, Maxime Ripard escribiÃ³:
> > The Allwinner A31 has a 16 channels DMA controller that it shares with the
> > newer A23. Although sharing some similarities with the DMA controller of the
> > older Allwinner SoCs, it's significantly different, I don't expect it to be
> > possible to share the driver for these two.
> >
> > The A31 Controller is able to memory-to-memory or memory-to-device transfers on
> > the 16 channels in parallel.

...

> > diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> > index 5c5863842de9..360a10c71388 100644
> > --- a/drivers/dma/Kconfig
> > +++ b/drivers/dma/Kconfig
> > @@ -361,6 +361,14 @@ config FSL_EDMA
> >   	  multiplexing capability for DMA request sources(slot).
> >   	  This module can be found on Freescale Vybrid and LS-1 SoCs.
> >
> > +config DMA_SUN6I
> > +	tristate "Allwinner A31 SoCs DMA support"
> > +	depends on ARCH_SUNXI
> > +	select DMA_ENGINE
> > +	select DMA_VIRTUAL_CHANNELS
> 
> I think you also need to select DMA_OF here as you are using 
> of_dma_controller_register

of_dma_controller_register should have a stub (which it does).
No need to have such a dependency.

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
