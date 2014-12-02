Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbaLBQu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:50:56 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:60772 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333AbaLBQuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:50:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Dec 2014 17:53:01 +0100
From: Stefan Agner <stefan@agner.ch>
To: vinod.koul@intel.com
Cc: jingchang.lu@freescale.com, dan.j.williams@intel.com,
        dmaengine@vger.kernel.org, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] dmaengine: fsl-edma: fix calculation of remaining bytes
In-Reply-To: <1415879762-12177-1-git-send-email-stefan@agner.ch>
References: <1415879762-12177-1-git-send-email-stefan@agner.ch>
Message-ID: <5f5e46d80c45693b12c3ad8691d3c90a@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Dec  2 17:50:20 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 547dedcc12812056531114
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-13 12:56, Stefan Agner wrote:
> If the current transfer control descriptor (TCD) was not yet started,
> the address will be the same as the initial address. Hence test if the
> current address is less than or equal to the start address of each TCD.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> This bug was discovered during development on a AC97 capable SAI driver,
> I don't think that this is currently a issue since only a few drivers
> use DMA on Vybrid so far and don't use the remaining bytes information.
> 
>  drivers/dma/fsl-edma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
> index 3c5711d..58c6fc7 100644
> --- a/drivers/dma/fsl-edma.c
> +++ b/drivers/dma/fsl-edma.c
> @@ -386,7 +386,7 @@ static size_t fsl_edma_desc_residue(struct
> fsl_edma_chan *fsl_chan,
>  					&(edesc->tcd[i].vtcd->daddr));
>  
>  		len -= size;
> -		if (cur_addr > dma_addr && cur_addr < dma_addr + size) {
> +		if (cur_addr >= dma_addr && cur_addr < dma_addr + size) {
>  			len += dma_addr + size - cur_addr;
>  			break;
>  		}

Hi Vinod,

Afaik, this has not been applied yet, any reasons why?

--
Stefan

