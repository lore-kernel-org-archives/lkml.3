Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3HTIGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:06:04 -0400
Received: from antcom.de ([46.38.233.243]:55593 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab3HTIGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:06:01 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2013 04:06:01 EDT
Message-ID: <52132187.5030103@antcom.de>
Date: Tue, 20 Aug 2013 09:57:59 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130701 Icedove/17.0.7
MIME-Version: 1.0
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAX7301 GPIO: Reverting "Do not force SPI speed when
 using OF Platform"
References: <201308200629.r7K6TNUS010648@localhost.localdomain>
In-Reply-To: <201308200629.r7K6TNUS010648@localhost.localdomain>
X-Enigmail-Version: 1.5.2
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 08:29 AM, Christophe Leroy wrote:
> This patch reverts commit 047b93a35961f7a6561e6f5dcb040738f822b892 which breaks
> MAX7301 GPIO driver because that commit was dependant on a rejected patch that
> was implementing selection of SPI speed from the Device Tree.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Acked-by: Roland Stigge <stigge@antcom.de>

Good, thanks!

> 
> --- linux-3.11-rc6/drivers/gpio/gpio-max7301.c	2013-08-17 21:09:17.000000000 +0200
> +++ linux/drivers/gpio/gpio-max7301.c	2013-08-18 06:31:52.000000000 +0200
> @@ -56,8 +56,7 @@
>  	int ret;
>  
>  	/* bits_per_word cannot be configured in platform data */
> -	if (spi->dev.platform_data)
> -		spi->bits_per_word = 16;
> +	spi->bits_per_word = 16;
>  	ret = spi_setup(spi);
>  	if (ret < 0)
>  		return ret;
> 

