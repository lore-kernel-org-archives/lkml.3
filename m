Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3HDMfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 08:35:54 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:40972 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3HDMfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 08:35:53 -0400
MIME-Version: 1.0
In-Reply-To: <1375478656-3577-1-git-send-email-gsmecher@threespeedlogic.com>
References: <1375478656-3577-1-git-send-email-gsmecher@threespeedlogic.com>
Date: Sun, 4 Aug 2013 20:35:51 +0800
Message-ID: <CAN1soZy98mM6aAyASDY8Ra+j-2Jsr8RDvuqU8vHBnVBNgjWx9w@mail.gmail.com>
Subject: Re: [PATCH] gpio: pca953x: Don't flip bits on PCA957x GPIO expanders
 when probing them.
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Graeme Smecher <gsmecher@threespeedlogic.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 3, 2013 at 5:24 AM, Graeme Smecher
<gsmecher@threespeedlogic.com> wrote:
> The pca957x driver supports a handful of I2C GPIO expanders from NXP, Maxim,
> and TI. For the PCA9574 and PCA9575 devices only, the driver resets the GPIO
> level and direction in the pca957x_probe function. This seems like the wrong
> thing to do, since it can cause hardware bit twiddles during warm reboots when
> the chip state and reset values don't match.
>
> This kind of initialization is best left upstream (in a bootloader) or
> downstream (in userspace). It's also an inconsistency across devices supported
> by this driver.
>
> Signed-off-by: Graeme Smecher <gsmecher@threespeedlogic.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
> ---
>  drivers/gpio/gpio-pca953x.c |   11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index 426c51d..47c08d8 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -683,17 +683,6 @@ static int device_pca957x_init(struct pca953x_chip *chip, u32 invert)
>         int ret;
>         u8 val[MAX_BANK];
>
> -       /* Let every port in proper state, that could save power */
> -       memset(val, 0, NBANK(chip));
> -       pca953x_write_regs(chip, PCA957X_PUPD, val);
> -       memset(val, 0xFF, NBANK(chip));
> -       pca953x_write_regs(chip, PCA957X_CFG, val);
> -       memset(val, 0, NBANK(chip));
> -       pca953x_write_regs(chip, PCA957X_OUT, val);
> -
> -       ret = pca953x_read_regs(chip, PCA957X_IN, val);
> -       if (ret)
> -               goto out;
>         ret = pca953x_read_regs(chip, PCA957X_OUT, chip->reg_output);
>         if (ret)
>                 goto out;
> --
> 1.7.10.4
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
