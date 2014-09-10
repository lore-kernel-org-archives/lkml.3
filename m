Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaIJES5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:18:57 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47262 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaIJESi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:18:38 -0400
Message-ID: <540FD084.6000805@gmail.com>
Date: Wed, 10 Sep 2014 09:46:04 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Robin Gong <b38343@freescale.com>, linux-arm-kernel@lists.infradead.org,
        broonie@kernel.org
CC: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, marex@denx.de,
        shawn.guo@linaro.org, Frank.Li@freescale.com
Subject: Re: [PATCH v5] spi: spi-imx: add DMA support
References: <1410312604-31949-1-git-send-email-b38343@freescale.com>
In-Reply-To: <1410312604-31949-1-git-send-email-b38343@freescale.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 07:00 AM, Robin Gong wrote:
> Enable DMA support on i.mx6. The read speed can increase from 600KB/s
> to 1.2MB/s on i.mx6q. You can disable or enable dma function in dts.

(...)

> +
> +static int spi_imx_sdma_init(struct device *dev, struct spi_imx_data *spi_imx,
> +			     struct spi_master *master,
> +			     const struct resource *res)
> +{
> +	struct dma_slave_config slave_config = {};
> +	int ret;
> +
> +	/* Prepare for TX DMA: */
> +	master->dma_tx = dma_request_slave_channel(dev, "tx");
> +	if (!master->dma_tx) {
> +		dev_err(dev, "cannot get the TX DMA channel!\n");
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	slave_config.direction = DMA_MEM_TO_DEV;
> +	slave_config.dst_addr = res->start + MXC_CSPITXDATA;
> +	slave_config.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
> +	slave_config.dst_maxburst = spi_imx_get_fifosize(spi_imx) / 2;
> +	ret = dmaengine_slave_config(master->dma_tx, &slave_config);
> +	if (ret) {
> +		dev_err(dev, "error in TX dma configuration.");
> +		

Missed terminating new line..

-- 
Regards,
Varka Bhadram.

