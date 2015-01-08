Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbbAHPvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:51:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:13594 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbbAHPvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:51:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,723,1413270000"; 
   d="scan'208";a="658786301"
From: "Jiang, Dave" <dave.jiang@intel.com>
To: "der.herr@hofr.at" <der.herr@hofr.at>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rashika.kheria@gmail.com" <rashika.kheria@gmail.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: Re: [PATCH v2] ioat: fail self-test if wait_for_completion times out
Thread-Topic: [PATCH v2] ioat: fail self-test if wait_for_completion times
 out
Thread-Index: AQHQK07cik91MZF4kkez5HZ+fkIoyZy25YCA
Date: Thu, 8 Jan 2015 15:51:45 +0000
Message-ID: <1420732305.207559.0.camel@djiang5-desk2.amr.corp.intel.com>
References: <1420726595-29152-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1420726595-29152-1-git-send-email-der.herr@hofr.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.2.105.66]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D6E20F9A103204ABEA7B193A4D4499F@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t08Fpu2t031558




On Thu, 2015-01-08 at 14:16 +0000, Nicholas Mc Guire wrote:
> wait_for_completion_timeout reaching timeout was being ignored,
> fail the self-test if timeout condition occurs.
> 
> v2: fixup of coding style issues.
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
Acked-by: Dave Jiang <dave.jiang@intel.com>

> ---
> 
> this was only compile tested with
> x86_64_defconfig + CONFIG_DMA_ENGINE=y + CONFIG_INTEL_IOATDMA=m
> 
> patch is against linux-next 3.19.0-rc3 -next-20150108
> 
>  drivers/dma/ioat/dma_v3.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index be307182..a26882e 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -1311,7 +1311,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
>  
>  	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
>  
> -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> +	if (tmo == 0 ||
> +	    dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
>  		dev_err(dev, "Self-test xor timed out\n");
>  		err = -ENODEV;
>  		goto dma_unmap;
> @@ -1377,7 +1378,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
>  
>  	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
>  
> -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> +	if (tmo == 0 ||
> +	    dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
>  		dev_err(dev, "Self-test validate timed out\n");
>  		err = -ENODEV;
>  		goto dma_unmap;
> @@ -1429,7 +1431,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
>  
>  	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
>  
> -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> +	if (tmo == 0 ||
> +	    dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
>  		dev_err(dev, "Self-test 2nd validate timed out\n");
>  		err = -ENODEV;
>  		goto dma_unmap;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
