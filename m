Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbbAHJNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:13:21 -0500
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:46670 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbbAHJNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:13:18 -0500
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <54AE4A3A.1050806@smartplayin.com>
Date: Thu, 08 Jan 2015 14:43:30 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: ulf.hansson@linaro.org
CC: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux@arm.linux.org.uk, chris@printf.net
Subject: Re: [PATCH] mmc: mmci: Get rid of unused variable and operations
 on it
References: <1418737895-6404-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1418737895-6404-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

Any comment on this change?

Thanks
Pramod
On Tuesday 16 December 2014 07:21 PM, Pramod Gurav wrote:
> DMA configuration has been removed from function mmci_dma_setup but the
> local mask variable was not removed. This remains unused hence remove
> it from the function and operations on it
> 
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/mmc/host/mmci.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index f31d702..08bbeb0 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -435,7 +435,6 @@ static void mmci_init_sg(struct mmci_host *host, struct mmc_data *data)
>  static void mmci_dma_setup(struct mmci_host *host)
>  {
>  	const char *rxname, *txname;
> -	dma_cap_mask_t mask;
>  	struct variant_data *variant = host->variant;
>  
>  	host->dma_rx_channel = dma_request_slave_channel(mmc_dev(host->mmc), "rx");
> @@ -444,10 +443,6 @@ static void mmci_dma_setup(struct mmci_host *host)
>  	/* initialize pre request cookie */
>  	host->next_data.cookie = 1;
>  
> -	/* Try to acquire a generic DMA engine slave channel */
> -	dma_cap_zero(mask);
> -	dma_cap_set(DMA_SLAVE, mask);
> -
>  	/*
>  	 * If only an RX channel is specified, the driver will
>  	 * attempt to use it bidirectionally, however if it is
> 
