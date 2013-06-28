Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3F1XR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:17:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51031 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3F1XR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:17:58 -0400
Message-ID: <51CE199A.4040606@gmail.com>
Date: Sat, 29 Jun 2013 09:17:46 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net, mika.westerberg@iki.fi,
        broonie@kernel.org, grant.likely@linaro.org
Subject: Re: [PATCH 3/8] spi: spi-ep93xx: always handle transfer specific
 settings
References: <201306281143.35130.hartleys@visionengravers.com>
In-Reply-To: <201306281143.35130.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/06/13 04:43, H Hartley Sweeten wrote:

> __spi_async(), which starts every SPI message transfer, initializes
> the bits_per_word and max speed for every transfer in the message.
> Since the conditional test in ep93xx_spi_process_transfer() will
> always succeed just remove it and always call ep93xx_spi_chip_setup()
> to configure the hardware for each transfer in the message.
> 
> Remove the redundant ep93xx_spi_chp_setup() in ep93xx_spi_process_transfer()
> which just initializes the hardware to the "default" based on the SPI
> device.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> ---


> +	err = ep93xx_spi_calc_divisors(espi, chip, t->speed_hz);
> +	if (err) {
> +		dev_err(&espi->pdev->dev, "failed to adjust speed\n");


Printing out the speed it was trying to set might be useful here?

~Ryan
