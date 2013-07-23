Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab3GWHeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:34:12 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:42230 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3GWHeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:34:11 -0400
MIME-Version: 1.0
Date: Tue, 23 Jul 2013 15:34:09 +0800
Message-ID: <CAJxxZ0NJD102U6Ofm9XvF6rUkKQMuM34erPcOifvBjnc1HnSCA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinmux: Don't free pins requested by other devices
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping

On Wed, Jul 17, 2013 at 1:31 PM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> in pinmux_disable_setting after current device fails to request
> the same pins.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/pinctrl/pinmux.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> index 88cc509..9ebcf3b 100644
> --- a/drivers/pinctrl/pinmux.c
> +++ b/drivers/pinctrl/pinmux.c
> @@ -482,13 +482,14 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
>                                  pins[i]);
>                         continue;
>                 }
> +               /* And release the pins */
> +               if (desc->mux_usecount &&
> +                       !strcmp(desc->mux_owner, setting->dev_name))
> +                       pin_free(pctldev, pins[i], NULL);
> +
>                 desc->mux_setting = NULL;
>         }
>
> -       /* And release the pins */
> -       for (i = 0; i < num_pins; i++)
> -               pin_free(pctldev, pins[i], NULL);
> -
>         if (ops->disable)
>                 ops->disable(pctldev, setting->data.mux.func, setting->data.mux.group);
>  }
> --
> 1.8.2.3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
