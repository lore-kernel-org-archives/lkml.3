Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3F1XPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:15:38 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53895 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3F1XPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:15:37 -0400
Message-ID: <51CE18FD.8010806@gmail.com>
Date: Sat, 29 Jun 2013 09:15:09 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net, mika.westerberg@iki.fi,
        broonie@kernel.org, grant.likely@linaro.org
Subject: Re: [PATCH 1/8] spi: spi-ep93xx: use read,write instead of __raw_*
 variants
References: <201306281142.36525.hartleys@visionengravers.com>
In-Reply-To: <201306281142.36525.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/06/13 04:42, H Hartley Sweeten wrote:

> The memory resource used by this driver is ioremap()'d and the normal
> read,write calls can be used instead of the __raw_* variants.
> 
> Remove the inline read,write helpers and just do the read,write
> directly in the callers.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/spi/spi-ep93xx.c | 64 +++++++++++++++---------------------------------
>  1 file changed, 20 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> index d7bac60..c633cd0 100644
> --- a/drivers/spi/spi-ep93xx.c
> +++ b/drivers/spi/spi-ep93xx.c
> @@ -158,30 +158,6 @@ struct ep93xx_spi_chip {
>  /* converts bits per word to CR0.DSS value */
>  #define bits_per_word_to_dss(bpw)	((bpw) - 1)
>  
> -static inline void
> -ep93xx_spi_write_u8(const struct ep93xx_spi *espi, u16 reg, u8 value)
> -{
> -	__raw_writeb(value, espi->regs_base + reg);
> -}
> -
> -static inline u8
> -ep93xx_spi_read_u8(const struct ep93xx_spi *spi, u16 reg)
> -{
> -	return __raw_readb(spi->regs_base + reg);
> -}


Is there a particular reason to drop these functions? It's basically just
bike-shedding, but they can make the code more readable at very little
cost. Even dropping the inline (which is preferred nowdays) the compiler
will still inline these, and it would also make this patch much smaller
to keep them.

~Ryan
