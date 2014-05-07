Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaEGOmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:42:55 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:54462 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaEGOmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:42:54 -0400
Date: Wed, 7 May 2014 16:43:06 +0200
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] mmc: atmel: don't test host->data
Message-ID: <20140507144306.GO7438@ldesroches-Latitude-E6320>
Mail-Followup-To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mmc@vger.kernel.org
References: <1399391006-16007-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1399391006-16007-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 05:43:26PM +0200, Alexandre Belloni wrote:
> Found using smatch:
> drivers/mmc/host/atmel-mci.c:827 atmci_pdc_complete() warn: variable
> dereferenced before check 'host->data' (see line 807)
> 
> Stop testing host->data as it is not NULL at that point.

I agree

> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

> ---
>  drivers/mmc/host/atmel-mci.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 42706ea0ba85..aece7cafbb97 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -820,16 +820,9 @@ static void atmci_pdc_complete(struct atmel_mci *host)
>  
>  	atmci_pdc_cleanup(host);
>  
> -	/*
> -	 * If the card was removed, data will be NULL. No point trying
> -	 * to send the stop command or waiting for NBUSY in this case.
> -	 */
> -	if (host->data) {
> -		dev_dbg(&host->pdev->dev,
> -		        "(%s) set pending xfer complete\n", __func__);
> -		atmci_set_pending(host, EVENT_XFER_COMPLETE);
> -		tasklet_schedule(&host->tasklet);
> -	}
> +	dev_dbg(&host->pdev->dev, "(%s) set pending xfer complete\n", __func__);
> +	atmci_set_pending(host, EVENT_XFER_COMPLETE);
> +	tasklet_schedule(&host->tasklet);
>  }
>  
>  static void atmci_dma_cleanup(struct atmel_mci *host)
> -- 
> 1.9.1
> 
