Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3GXTdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:33:50 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:31925 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329Ab3GXTds convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:33:48 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 10
X-BigFish: VS10(zzbb2dI98dI9371I1432I67favzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Wed, 24 Jul 2013 14:33:31 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v5 4/4] DMA: Freescale: eliminate a compiling warning
To: <hongbo.zhang@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
References: <1374646870-5162-1-git-send-email-hongbo.zhang@freescale.com>
	<1374646870-5162-5-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1374646870-5162-5-git-send-email-hongbo.zhang@freescale.com>
	(from hongbo.zhang@freescale.com on Wed Jul 24 01:21:09 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1374694411.15592.63@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 01:21:09 AM, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> The variable cookie is initialized in a list_for_each_entry loop,  
> if(unlikely)
> the list is empty, this variable will be used uninitialized, so we  
> get a gcc
> compiling warning about this. This patch fixes this defect by setting  
> an
> initial value to the varialble cookie.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
>  drivers/dma/fsldma.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 16a9a48..14d68a4 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -406,7 +406,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct  
> dma_async_tx_descriptor *tx)
>  	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
>  	struct fsl_desc_sw *child;
>  	unsigned long flags;
> -	dma_cookie_t cookie;
> +	dma_cookie_t cookie = 0;
> 
>  	spin_lock_irqsave(&chan->desc_lock, flags);

This patch is unrelated to the rest of the patch series...

What are the semantics of this function if there are multiple entries  
in the list?  Returning the last cookie seems a bit odd.

Is zero the proper error value?  include/linux/dmaengine.h suggests  
that cookies should be < 0 to indicate error.

-Scott
