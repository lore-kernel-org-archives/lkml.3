Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab3DZIgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:36:51 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:51118 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896Ab3DZIgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:36:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130426171229.134dc25101970f908132d523@canb.auug.org.au>
References: <20130426171229.134dc25101970f908132d523@canb.auug.org.au>
Date: Fri, 26 Apr 2013 10:36:46 +0200
Message-ID: <CABYn4szu+auF9v76tJYzowZ0M2AWgeBuAcEcLsDaYwFDvro5hA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the renesas tree with the input tree
From: Bastian Hecht <hechtb@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Simon Horman <horms@verge.net.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

as long as the snippet below survives from the patch (which should),
from my side it's fine.

Thanks for merging Stephen,

 Bastian


 /* I2C */
+static struct st1232_pdata st1232_i2c0_pdata = {
+    .reset_gpio = 166,
+};
+
 static struct i2c_board_info i2c0_devices[] = {
     {
         I2C_BOARD_INFO("st1232-ts", 0x55),
         .irq = irq_pin(10),
+        .platform_data = &st1232_i2c0_pdata,
     },

2013/4/26 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi Simon,
>
> Today's linux-next merge of the renesas tree got a conflict in
> arch/arm/mach-shmobile/board-armadillo800eva.c between commit
> cbaf7f808081 ("ARM - shmobile: Armadillo800EVA: Move st1232 reset pin
> handling") from the input tree and commit 0c5ba87e1b2e ("ARM: shmobile:
> armadillo800eva: Register pinctrl mapping for INTC") from the renesas
> tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc arch/arm/mach-shmobile/board-armadillo800eva.c
> index b85b288,ff04d1e..0000000
> --- a/arch/arm/mach-shmobile/board-armadillo800eva.c
> +++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
> @@@ -1127,32 -1151,10 +1161,7 @@@ static void __init eva_init(void
>         gpio_request_one(61, GPIOF_OUT_INIT_HIGH, NULL); /* LCDDON */
>         gpio_request_one(202, GPIOF_OUT_INIT_LOW, NULL); /* LCD0_LED_CONT */
>
> --      /* Touchscreen */
> -       gpio_request(GPIO_FN_IRQ10,     NULL); /* TP_INT */
> -
>  -      gpio_request_one(166, GPIOF_OUT_INIT_HIGH, NULL); /* TP_RST_B */
>  -
>         /* GETHER */
> -       gpio_request(GPIO_FN_ET_CRS,            NULL);
> -       gpio_request(GPIO_FN_ET_MDC,            NULL);
> -       gpio_request(GPIO_FN_ET_MDIO,           NULL);
> -       gpio_request(GPIO_FN_ET_TX_ER,          NULL);
> -       gpio_request(GPIO_FN_ET_RX_ER,          NULL);
> -       gpio_request(GPIO_FN_ET_ERXD0,          NULL);
> -       gpio_request(GPIO_FN_ET_ERXD1,          NULL);
> -       gpio_request(GPIO_FN_ET_ERXD2,          NULL);
> -       gpio_request(GPIO_FN_ET_ERXD3,          NULL);
> -       gpio_request(GPIO_FN_ET_TX_CLK,         NULL);
> -       gpio_request(GPIO_FN_ET_TX_EN,          NULL);
> -       gpio_request(GPIO_FN_ET_ETXD0,          NULL);
> -       gpio_request(GPIO_FN_ET_ETXD1,          NULL);
> -       gpio_request(GPIO_FN_ET_ETXD2,          NULL);
> -       gpio_request(GPIO_FN_ET_ETXD3,          NULL);
> -       gpio_request(GPIO_FN_ET_PHY_INT,        NULL);
> -       gpio_request(GPIO_FN_ET_COL,            NULL);
> -       gpio_request(GPIO_FN_ET_RX_DV,          NULL);
> -       gpio_request(GPIO_FN_ET_RX_CLK,         NULL);
> -
>         gpio_request_one(18, GPIOF_OUT_INIT_HIGH, NULL); /* PHY_RST */
>
>         /* USB */
