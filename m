Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3GVPqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:46:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:34561 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab3GVPqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:46:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,720,1367996400"; 
   d="scan'208";a="369185095"
From: "Jiang, Dave" <dave.jiang@intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Dan Williams <djbw@fb.com>, "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ioatdma: silence GCC warnings
Thread-Topic: [PATCH v2] ioatdma: silence GCC warnings
Thread-Index: AQHOhXO9zpb9mUG4QEO3FmnOxZqGGZlxT72A
Date: Mon, 22 Jul 2013 15:46:36 +0000
Message-ID: <1374507997.43171.7.camel@djiang5-linux2.ch.intel.com>
References: <1371465315.26299.17.camel@x61.thuisdomein>
	 <CAA9_cmc9XWCvU=d2qu6rMaV+_sxBeMgrreZWU5ofzAd3dANT9w@mail.gmail.com>
	 <1374147757.26384.49.camel@x61.thuisdomein>
	 <1374343505.15242.12.camel@x61.thuisdomein>
In-Reply-To: <1374343505.15242.12.camel@x61.thuisdomein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.2.105.54]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDF0C9F2D3080D4E8EB7D4E10D999072@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6MFkxAE011518

On Sat, 2013-07-20 at 20:05 +0200, Paul Bolle wrote:
> Building dma_v3.o triggers a GCC warning:
>     drivers/dma/ioat/dma_v3.c: In function â€˜__ioat3_prep_pq16_lockâ€™:
>     drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]
>     drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]
> 
> This warning is caused by pq16_set_src(). It uses "int idx" as an index
> to an eight element array. Changing "idx" to "unsigned" silences this
> warning. Apparently GCC can then determine that "idx" will never be
> negative.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Dave Jiang <dave.jiang@intel.com>

> ---
> 0) v2: cut back to a one hunk change, as Dan suggested.
> 
> 1) Still just compile tested.
> 
>  drivers/dma/ioat/dma_v3.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index b642e03..2bb4601 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -251,7 +251,7 @@ static bool is_bwd_noraid(struct pci_dev *pdev)
>  }
>  
>  static void pq16_set_src(struct ioat_raw_descriptor *desc[3],
> -			dma_addr_t addr, u32 offset, u8 coef, int idx)
> +			dma_addr_t addr, u32 offset, u8 coef, unsigned idx)
>  {
>  	struct ioat_pq_descriptor *pq = (struct ioat_pq_descriptor *)desc[0];
>  	struct ioat_pq16a_descriptor *pq16 =

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
