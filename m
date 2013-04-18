Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936553Ab3DRTtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:49:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40281 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab3DRTtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:49:14 -0400
Message-ID: <51704F2C.6060901@ti.com>
Date: Thu, 18 Apr 2013 15:53:16 -0400
From: Matt Porter <mporter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christian Eggers <ceggers@gmx.de>
CC: <linux-kernel@vger.kernel.org>, <spi-devel-general@lists.sourceforge.net>
Subject: Re: spi: spi-davinci: Fix direction in dma_map_single()
References: <2298140.4jrJLRXeBJ@p2400>
In-Reply-To: <2298140.4jrJLRXeBJ@p2400>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 03:31 PM, Christian Eggers wrote:
> Commit 048177ce3b3962852fd34a7e04938959271c7e70 (spi: spi-davinci:
>
> convert to DMA engine API) introduced a regression: dma_map_single()
>
> is called with direction DMA_FROM_DEVICE for rx and for tx.
>
> Signed-off-by: Christian Eggers <ceggers@gmx.de>
>
> Cc: stable@vger.kernel.org

Cc: stable@vger.kernel.org # v3.7.x+
will get this applied to the correct stable kernels.

I'm wearing the brown bag for this one so other than fixing the Cc: it 
looks good.

Acked-by: Matt Porter <mporter@ti.com>

> --- drivers/spi/spi-davinci.c.orig 2013-04-18 20:54:02.728719412 +0200
>
> +++ drivers/spi/spi-davinci.c 2013-04-18 20:54:51.900623956 +0200
>
> @@ -608,7 +608,7 @@ static int davinci_spi_bufs(struct spi_d
>
> else
>
> buf = (void *)t->tx_buf;
>
> t->tx_dma = dma_map_single(&spi->dev, buf,
>
> - t->len, DMA_FROM_DEVICE);
>
> + t->len, DMA_TO_DEVICE);
>
> if (!t->tx_dma) {
>
> ret = -EFAULT;
>
> goto err_tx_map;
>

