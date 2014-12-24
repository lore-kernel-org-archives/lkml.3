Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaLXTCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 14:02:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbaLXTCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 14:02:03 -0500
Message-ID: <549B0DA5.3010700@redhat.com>
Date: Wed, 24 Dec 2014 14:01:57 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] incorrect use of init_completion fixup
References: <1419357151-22889-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1419357151-22889-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/23/2014 12:52 PM, Nicholas Mc Guire wrote:
> The successive init_completion calls should be reinit_completion here.
> 

Hi Nicholas,

I know enough about this code to break it ;) ... what condition did you hit that
led you to this patch?

P.

> patch is against 3.18.0 linux-next
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>  drivers/dma/ioat/dma_v3.c |    4 +-
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index 32eae38..3dbcc42 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -1353,7 +1353,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
>  	}
> 
>  	async_tx_ack(tx);
> -	init_completion(&cmp);
> +	reinit_completion(&cmp);
>  	tx->callback = ioat3_dma_test_callback;
>  	tx->callback_param = &cmp;
>  	cookie = tx->tx_submit(tx);
> @@ -1405,7 +1405,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
>  	}
> 
>  	async_tx_ack(tx);
> -	init_completion(&cmp);
> +	reinit_completion(&cmp);
>  	tx->callback = ioat3_dma_test_callback;
>  	tx->callback_param = &cmp;
>  	cookie = tx->tx_submit(tx);
> --
> 1.7.10.4
> 
