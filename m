Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaFPRX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:23:57 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:64604 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaFPRXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:23:55 -0400
Date: Mon, 16 Jun 2014 18:23:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, spk.linux@gmail.com
Subject: Re: [PATCH Resend] mfd: asic3: Fix potential null pointer dereference
Message-ID: <20140616172348.GF14323@lee--X1>
References: <1402394434-903-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402394434-903-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Sachin Kamat wrote:

> We previously assumed 'mem_sdio' could be null but it is
> dereferenced in ioremap(). Add a check to avoid a potential
> null pointer dereference error.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/asic3.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> index 9f6294f2a070..9fc4186d4132 100644
> --- a/drivers/mfd/asic3.c
> +++ b/drivers/mfd/asic3.c
> @@ -899,13 +899,15 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
>  	ds1wm_resources[0].end   >>= asic->bus_shift;
>  
>  	/* MMC */
> -	asic->tmio_cnf = ioremap((ASIC3_SD_CONFIG_BASE >> asic->bus_shift) +
> +	if (mem_sdio) {
> +		asic->tmio_cnf = ioremap((ASIC3_SD_CONFIG_BASE >> asic->bus_shift) +
>  				 mem_sdio->start,
>  				 ASIC3_SD_CONFIG_SIZE >> asic->bus_shift);
> -	if (!asic->tmio_cnf) {
> -		ret = -ENOMEM;
> -		dev_dbg(asic->dev, "Couldn't ioremap SD_CONFIG\n");
> -		goto out;
> +		if (!asic->tmio_cnf) {
> +			ret = -ENOMEM;
> +			dev_dbg(asic->dev, "Couldn't ioremap SD_CONFIG\n");
> +			goto out;
> +		}
>  	}
>  	asic3_mmc_resources[0].start >>= asic->bus_shift;
>  	asic3_mmc_resources[0].end   >>= asic->bus_shift;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
