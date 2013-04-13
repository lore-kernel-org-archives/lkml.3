Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3DMOKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 10:10:40 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64918 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3DMOKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:10:38 -0400
MIME-Version: 1.0
X-Originating-IP: [114.39.107.246]
In-Reply-To: <1365424274.21989.2.camel@phoenix>
References: <1365424274.21989.2.camel@phoenix>
Date: Sat, 13 Apr 2013 22:10:38 +0800
Message-ID: <CAFRkauBC3mo3GiVeFJ-yUJscybpHje_94rC6oXZ1O5mm8M=9tA@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab8500: Fix get_mode for shared mode regulators
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

Hi Lee,
Can you review this patch.
I think this one is a bug fix.

Regards,
Axel

2013/4/8 Axel Lin <axel.lin@ingics.com>:
> The special handling code for getting shared mode status is wrong
> because it needs to check info->shared_mode->lp_mode_req for
> both regulators that shared the same mode register.
>
> In set_mode(), current code ensures we won't set mode to REGULATOR_MODE_IDLE
> if only one of the regulator requests to set idle.
>
> In get_mode(), we can just remove the special handling code for shared mode.
> Read the register value always returns correct status no matter the regulator
> has shared mode register or not.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/ab8500.c |    8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index 9ebd131..acdffc5 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -456,14 +456,6 @@ static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
>                 return -EINVAL;
>         }
>
> -       /* Need special handling for shared mode */
> -       if (info->shared_mode) {
> -               if (info->shared_mode->lp_mode_req)
> -                       return REGULATOR_MODE_IDLE;
> -               else
> -                       return REGULATOR_MODE_NORMAL;
> -       }
> -
>         if (info->mode_mask) {
>                 /* Dedicated register for handling mode */
>                 ret = abx500_get_register_interruptible(info->dev,
> --
> 1.7.10.4
>
>
>
