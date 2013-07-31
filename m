Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898Ab3GaWOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:14:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:27756 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757533Ab3GaWOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:14:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,790,1367996400"; 
   d="scan'208";a="379170671"
From: "Jiang, Dave" <dave.jiang@intel.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: Dan Williams <djbw@fb.com>, "Koul, Vinod" <vinod.koul@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mason, Jon" <jon.mason@intel.com>
Subject: Re: ioatdma: add ioat_raid_enabled module parameter
Thread-Topic: ioatdma: add ioat_raid_enabled module parameter
Thread-Index: AQHOjjom0XMeyUNRoUmcakeh/vzoC5l/z3CA
Date: Wed, 31 Jul 2013 22:14:07 +0000
Message-ID: <1375308847.6448.6.camel@djiang5-linux2.ch.intel.com>
References: <51F98A3F.3000102@inria.fr>
In-Reply-To: <51F98A3F.3000102@inria.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.2.105.54]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE978987272F294C8E82E6DFA112EA25@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6VMEOQY015830

I'm ok with enabling this for people that just want to use DMA and not
RAID. 

Acked-by: Dave Jiang <dave.jiang@intel.com>

On Thu, 2013-08-01 at 00:05 +0200, Brice Goglin wrote:
> ioatdma: add ioat_raid_enabled module parameter
> 
> Commit f26df1a1 added a 64-byte alignment requirement for legacy
> operations to work around a silicon errata when mixing legacy and
> RAID descriptors.
> Passing ioat_raid_enabled=0 now disables RAID offload entirely in
> the ioatdma driver so that legacy operations (memcpy, etc.) can
> work without alignment restrictions anymore.
> 
> Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
> ---
>  drivers/dma/ioat/dma_v3.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Index: b/drivers/dma/ioat/dma_v3.c
> ===================================================================
> --- a/drivers/dma/ioat/dma_v3.c	2013-07-31 23:06:24.163810000 +0200
> +++ b/drivers/dma/ioat/dma_v3.c	2013-07-31 23:47:54.246719841 +0200
> @@ -67,6 +67,11 @@
>  #include "dma.h"
>  #include "dma_v2.h"
>  
> +static int ioat_raid_enabled = 1;
> +module_param(ioat_raid_enabled, int, 0444);
> +MODULE_PARM_DESC(ioat_raid_enabled,
> +		 "control support of RAID offload (default: 1)");
> +
>  /* ioat hardware assumes at least two sources for raid operations */
>  #define src_cnt_to_sw(x) ((x) + 2)
>  #define src_cnt_to_hw(x) ((x) - 2)
> @@ -1775,7 +1780,7 @@ int ioat3_dma_probe(struct ioatdma_devic
>  	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
>  	dma->device_free_chan_resources = ioat2_free_chan_resources;
>  
> -	if (is_xeon_cb32(pdev))
> +	if (is_xeon_cb32(pdev) && ioat_raid_enabled)
>  		dma->copy_align = 6;
>  
>  	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
> @@ -1783,7 +1788,7 @@ int ioat3_dma_probe(struct ioatdma_devic
>  
>  	device->cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
>  
> -	if (is_bwd_noraid(pdev))
> +	if (!ioat_raid_enabled || is_bwd_noraid(pdev))
>  		device->cap &= ~(IOAT_CAP_XOR | IOAT_CAP_PQ | IOAT_CAP_RAID16SS);
>  
>  	/* dca is incompatible with raid operations */
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
