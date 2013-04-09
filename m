Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab3DIRG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:06:29 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47592 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759886Ab3DIRG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:06:27 -0400
Message-ID: <51644A98.1070904@gmail.com>
Date: Tue, 09 Apr 2013 19:06:32 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Josef Ahmad <josef.ahmad@intel.com>
CC: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] spi-gpio: init CS before spi_bitbang_setup()
References: <1365525613-27198-1-git-send-email-josef.ahmad@intel.com>
In-Reply-To: <1365525613-27198-1-git-send-email-josef.ahmad@intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mark

On 09.04.2013 18:40, Josef Ahmad wrote:
> spi_bitbang_setup() deasserts the chip select line to initialise
> the device. The chip select GPIO line is obtained from
> spi_gpio->cs_gpios[] private data.
> Currently, devices that are not registered under devicetree
> environment will call into spi_bitbang_setup() with stale
> cs_gpios[].
> 
> This patch ensures spi_gpio->cs_gpios[] is always initialised prior
> to calling spi_bitbang_setup().
> 
> Reviewed-by: Daniel Mack <zonque@gmail.com>
> Signed-off-by: Josef Ahmad <josef.ahmad@intel.com>
> ---
>  drivers/spi/spi-gpio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
> index c7cf0b7..0fa345c 100644
> --- a/drivers/spi/spi-gpio.c
> +++ b/drivers/spi/spi-gpio.c
> @@ -265,9 +265,9 @@ static int spi_gpio_setup(struct spi_device *spi)
>  		}
>  	}
>  	if (!status) {
> -		status = spi_bitbang_setup(spi);
>  		/* in case it was initialized from static board data */
>  		spi_gpio->cs_gpios[spi->chip_select] = cs;
> +		status = spi_bitbang_setup(spi);
>  	}
>  
>  	if (status) {
> 

