Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbbABLrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 06:47:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbbABLrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 06:47:21 -0500
Message-ID: <54A68540.7090808@redhat.com>
Date: Fri, 02 Jan 2015 06:47:12 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Rashika <rashika.kheria@gmail.com>, Dave Jiang <dave.jiang@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ioat: fail self-test if wait_for_completion times out
References: <1419763047-15414-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1419763047-15414-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/28/2014 05:37 AM, Nicholas Mc Guire wrote:
> wait_for_completion_timeout reaching timeout was being ignored,
> fail the self-test if timeout condition occurs.
> 
> Not sure about the indentations used (CodingStyle:Chapter 2)
> 
> this was only compile tested with
> x86_64_defconfig + CONFIG_DMA_ENGINE=y + CONFIG_INTEL_IOATDMA=y
> 
> patch is against linux-next 3.19.0-rc1 -next-20141226
> 

Seems straightforward to me, although I don't think I've ever seen a failure in
this code.

Acked-by: Prarit Bhargava <prarit@redhat.com>

P.

> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>  drivers/dma/ioat/dma_v3.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index be307182..0659215 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -1311,7 +1311,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
> 
>  	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
> 
> -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> +	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> +			!= DMA_COMPLETE) {
>  		dev_err(dev, "Self-test xor timed out\n");
>  		err = -ENODEV;
>  		goto dma_unmap;
> @@ -1377,7 +1378,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
> 
>  	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
> 
> -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> +	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> +			!= DMA_COMPLETE) {
>  		dev_err(dev, "Self-test validate timed out\n");
>  		err = -ENODEV;
>  		goto dma_unmap;
> @@ -1429,7 +1431,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
> 
>  	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
> 
> -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> +	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> +			!= DMA_COMPLETE) {
>  		dev_err(dev, "Self-test 2nd validate timed out\n");
>  		err = -ENODEV;
>  		goto dma_unmap;
> --
> 1.7.10.4
> 
