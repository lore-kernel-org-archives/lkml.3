Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbaHFRT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:19:56 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:39302 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbaHFRTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:19:55 -0400
MIME-Version: 1.0
In-Reply-To: <1407344128-9754-1-git-send-email-xerofoiffy@gmail.com>
References: <1407344128-9754-1-git-send-email-xerofoiffy@gmail.com>
Date: Wed, 6 Aug 2014 19:19:54 +0200
Message-ID: <CAFLxGvxfSD+dW1oUyKAqq8tUMHYS7fuJdsdRKOR94O+nD8RoMg@mail.gmail.com>
Subject: Re: [PATCH] spi: Fix warning about redefinition
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Nick Krause <xerofoiffy@gmail.com>
Cc: Mark Brown <broonie@kernel.org>,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 6:55 PM, Nick Krause <xerofoiffy@gmail.com> wrote:
> Fix the following warnings about redefining READ and write
>
> drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by default]
> include/linux/fs.h:193:0: note: this is the location of the previous definition
> drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by default]
> include/linux/fs.h:192:0: note: this is the location of the previous definition
>
> Signed-off-by: Nick Krause <xerofoiffy@gmail.com>
> ---
>  drivers/spi/spi-omap-100k.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
> index 5e91858..eb8ae4e 100644
> --- a/drivers/spi/spi-omap-100k.c
> +++ b/drivers/spi/spi-omap-100k.c
> @@ -70,6 +70,12 @@
>  #define SPI_STATUS_WE                   (1UL << 1)
>  #define SPI_STATUS_RD                   (1UL << 0)
>
> +#ifdef WRITE
> +#undef WRITE
> +#endif
> +#ifdef READ
> +#undef READ
> +#endif
>  #define WRITE 0
>  #define READ  1

Are these symbols even in use?

> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
