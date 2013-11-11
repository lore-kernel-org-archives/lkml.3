Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3KKHmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:42:47 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46545 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3KKHmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:42:37 -0500
Date: Sun, 10 Nov 2013 23:42:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk, a.zummo@towertech.it,
        airlied@linux.ie, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Message-ID: <20131111074234.GF7645@core.coreip.homeip.net>
References: <1383724472-15475-1-git-send-email-duanj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383724472-15475-1-git-send-email-duanj.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 03:54:32PM +0800, Duan Jiong wrote:
> This patch fixes coccinelle error regarding usage of IS_ERR and
> PTR_ERR instead of PTR_ERR_OR_ZERO.
> 
> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>

Applied, thank you.

> ---
>  drivers/input/touchscreen/cyttsp4_spi.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/cyttsp4_spi.c b/drivers/input/touchscreen/cyttsp4_spi.c
> index a71e114..b19434c 100644
> --- a/drivers/input/touchscreen/cyttsp4_spi.c
> +++ b/drivers/input/touchscreen/cyttsp4_spi.c
> @@ -171,10 +171,7 @@ static int cyttsp4_spi_probe(struct spi_device *spi)
>  	ts = cyttsp4_probe(&cyttsp_spi_bus_ops, &spi->dev, spi->irq,
>  			  CY_SPI_DATA_BUF_SIZE);
>  
> -	if (IS_ERR(ts))
> -		return PTR_ERR(ts);
> -
> -	return 0;
> +	return PTR_ERR_OR_ZERO(ts);
>  }
>  
>  static int cyttsp4_spi_remove(struct spi_device *spi)
> -- 
> 1.8.3.1
> 

-- 
Dmitry
