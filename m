Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399Ab3HMS4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:56:37 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:42422 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109Ab3HMS4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:56:36 -0400
MIME-Version: 1.0
In-Reply-To: <1375948794-6286-2-git-send-email-milo.kim@ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com> <1375948794-6286-2-git-send-email-milo.kim@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 13 Aug 2013 11:56:14 -0700
Message-ID: <CAK5ve-K10M3+=ctxu+5hU=pPz1_x6p1JgQS6jEin-LfxnP8Hog@mail.gmail.com>
Subject: Re: [PATCH 01/10] leds: lp55xx: add common data structure for program
To: Milo Kim <woogyom.kim@gmail.com>
Cc: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Milo Kim <milo.kim@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 12:59 AM, Milo Kim <woogyom.kim@gmail.com> wrote:
> LP55xx family devices have internal three program engines which are used for
> loading LED patterns.
> To maintain legacy device attributes, specific data structure is used, 'mode'
> and 'led_mux'.
> The mode is used for showing/storing current engine mode such like disabled,
> load and run.
> Then led_mux is used for showing/storing current output LED selection.
> This is only for LP5523/55231.
>

This patch looks good to me, but the commit message format is little
bit odd to me. I will fix that and merge into my tree.

Thanks,
-Bryan


> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp55xx-common.h |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
> index dbbf86d..04c1d4f 100644
> --- a/drivers/leds/leds-lp55xx-common.h
> +++ b/drivers/leds/leds-lp55xx-common.h
> @@ -20,6 +20,13 @@ enum lp55xx_engine_index {
>         LP55XX_ENGINE_1,
>         LP55XX_ENGINE_2,
>         LP55XX_ENGINE_3,
> +       LP55XX_ENGINE_MAX = LP55XX_ENGINE_3,
> +};
> +
> +enum lp55xx_engine_mode {
> +       LP55XX_ENGINE_DISABLED,
> +       LP55XX_ENGINE_LOAD,
> +       LP55XX_ENGINE_RUN,
>  };
>
>  struct lp55xx_led;
> @@ -72,6 +79,16 @@ struct lp55xx_device_config {
>  };
>
>  /*
> + * struct lp55xx_engine
> + * @mode       : Engine mode
> + * @led_mux    : Mux bits for LED selection. Only used in LP5523
> + */
> +struct lp55xx_engine {
> +       enum lp55xx_engine_mode mode;
> +       u16 led_mux;
> +};
> +
> +/*
>   * struct lp55xx_chip
>   * @cl         : I2C communication for access registers
>   * @pdata      : Platform specific data
> @@ -79,6 +96,7 @@ struct lp55xx_device_config {
>   * @num_leds   : Number of registered LEDs
>   * @cfg        : Device specific configuration data
>   * @engine_idx : Selected engine number
> + * @engines    : Engine structure for the device attribute R/W interface
>   * @fw         : Firmware data for running a LED pattern
>   */
>  struct lp55xx_chip {
> @@ -89,6 +107,7 @@ struct lp55xx_chip {
>         int num_leds;
>         struct lp55xx_device_config *cfg;
>         enum lp55xx_engine_index engine_idx;
> +       struct lp55xx_engine engines[LP55XX_ENGINE_MAX];
>         const struct firmware *fw;
>  };
>
> --
> 1.7.9.5
>
