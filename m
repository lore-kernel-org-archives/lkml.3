Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaHYIHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:07:25 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:51393 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaHYIHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:07:22 -0400
X-Auth-Info: ZWKa/YMUQN4KSxO/sKK7yjSQn/vYTVTdfMM0qA7qGew=
From: Marek Vasut <marex@denx.de>
To: Robin Gong <b38343@freescale.com>
Subject: Re: [PATCH v4] spi: spi-imx: add DMA support
Date: Mon, 25 Aug 2014 10:07:22 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank.Li@freescale.com, shawn.guo@linaro.org
References: <1408752835-10995-1-git-send-email-b38343@freescale.com>
In-Reply-To: <1408752835-10995-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201408251007.22393.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 23, 2014 at 02:13:55 AM, Robin Gong wrote:
> After enable DMA

Please also add a commit message which describes the change, not only some test 
results.

[...]

> @@ -911,6 +1194,13 @@ static int spi_imx_probe(struct platform_device
> *pdev) goto out_put_per;
> 
>  	spi_imx->spi_clk = clk_get_rate(spi_imx->clk_per);
> +	/*
> +	 * Only validated on i.mx6 now, can remove the constrain if validated on
> +	 * other chips.
> +	 */

Given that the check below tests for imx51_ecspi_devtype_data ... does that 
mean, that this code was never tested on MX51 and MX53, yet will be enabled
for those chips and might possibly break them ?

> +	if (spi_imx->devtype_data == &imx51_ecspi_devtype_data
> +	    && spi_imx_sdma_init(&pdev->dev, spi_imx, master, res))
> +		dev_err(&pdev->dev, "dma setup error,use pio instead\n");
> 
>  	spi_imx->devtype_data->reset(spi_imx);
> 
> @@ -949,6 +1239,7 @@ static int spi_imx_remove(struct platform_device
> *pdev) writel(0, spi_imx->base + MXC_CSPICTRL);
>  	clk_unprepare(spi_imx->clk_ipg);
>  	clk_unprepare(spi_imx->clk_per);
> +	spi_imx_sdma_exit(spi_imx);
>  	spi_master_put(master);
> 
>  	return 0;

Best regards,
Marek Vasut
