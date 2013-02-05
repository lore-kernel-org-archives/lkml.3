Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab3BEOVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:21:34 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39688 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab3BEOVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:21:31 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: Ensure memory used for spi_write_then_read() is DMA safe
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1359268504-24937-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1359268504-24937-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Tue, 05 Feb 2013 14:21:28 +0000
Message-Id: <20130205142128.2E28D3E1265@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2013 14:35:04 +0800, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> Use GFP_DMA in order to ensure that the memory we allocate for transfers
> in spi_write_then_read() can be DMAed. On most platforms this will have
> no effect.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied, thanks.

g.

> ---
>  drivers/spi/spi.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 19ee901..14d0fba 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -1656,7 +1656,8 @@ int spi_write_then_read(struct spi_device *spi,
>  	 * using the pre-allocated buffer or the transfer is too large.
>  	 */
>  	if ((n_tx + n_rx) > SPI_BUFSIZ || !mutex_trylock(&lock)) {
> -		local_buf = kmalloc(max((unsigned)SPI_BUFSIZ, n_tx + n_rx), GFP_KERNEL);
> +		local_buf = kmalloc(max((unsigned)SPI_BUFSIZ, n_tx + n_rx),
> +				    GFP_KERNEL | GFP_DMA);
>  		if (!local_buf)
>  			return -ENOMEM;
>  	} else {
> -- 
> 1.7.10.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
