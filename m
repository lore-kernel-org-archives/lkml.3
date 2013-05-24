Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab3EXRTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:19:05 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.101]:50029 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406Ab3EXRTE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:19:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1369415911!8384935!27
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Stephen Warren <swarren@wwwdotorg.org>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
CC: "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Date: Fri, 24 May 2013 12:16:40 -0500
Subject: RE: [PATCH 2/2] spi: convert drivers to use bits_per_word_mask
Thread-Topic: [PATCH 2/2] spi: convert drivers to use bits_per_word_mask
Thread-Index: Ac5WlU267lM8AZbBS9KX9aDYJjQmkwCDJYkw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DA656FEA0@AUSP01VMBX24.collaborationhost.net>
References: <1369190195-14598-1-git-send-email-swarren@wwwdotorg.org>
 <1369190195-14598-2-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1369190195-14598-2-git-send-email-swarren@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 21, 2013 7:37 PM, Stephen Warren wrote:
>
> Fill in the recently added spi_master.bits_per_word_mask field in as
> many drivers as possible. Make related cleanups, such as removing any
> redundant error-checking, or empty setup callbacks.
>
> Cc: device-drivers-devel@blackfin.uclinux.org
> Cc: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---

<snip>

>  drivers/spi/spi-ep93xx.c        |   11 +----------

<snip>

> diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> index d7bac60..f1b1497 100644
> --- a/drivers/spi/spi-ep93xx.c
> +++ b/drivers/spi/spi-ep93xx.c
> @@ -296,12 +296,6 @@ static int ep93xx_spi_setup(struct spi_device *spi)
>  	struct ep93xx_spi *espi = spi_master_get_devdata(spi->master);
>  	struct ep93xx_spi_chip *chip;
>  
> -	if (spi->bits_per_word < 4 || spi->bits_per_word > 16) {
> -		dev_err(&espi->pdev->dev, "invalid bits per word %d\n",
> -			spi->bits_per_word);
> -		return -EINVAL;
> -	}
> -
>  	chip = spi_get_ctldata(spi);
>  	if (!chip) {
>  		dev_dbg(&espi->pdev->dev, "initial setup for %s\n",
> @@ -365,10 +359,6 @@ static int ep93xx_spi_transfer(struct spi_device *spi, struct spi_message *msg)
>  
>  	/* first validate each transfer */
>  	list_for_each_entry(t, &msg->transfers, transfer_list) {
> -		if (t->bits_per_word) {
> -			if (t->bits_per_word < 4 || t->bits_per_word > 16)
> -				return -EINVAL;
> -		}
>  		if (t->speed_hz && t->speed_hz < espi->min_rate)
>  				return -EINVAL;
>  	}
> @@ -1046,6 +1036,7 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
>  	master->bus_num = pdev->id;
>  	master->num_chipselect = info->num_chipselect;
>  	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
> +	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 16);
>  
>  	platform_set_drvdata(pdev, master);

Seems reasonable. For the spi-ep93xx driver:

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>


