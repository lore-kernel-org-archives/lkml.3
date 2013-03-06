Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3CFRui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:50:38 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:62364 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3CFRuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:50:37 -0500
MIME-Version: 1.0
In-Reply-To: <1362546097-13740-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1362546097-13740-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 6 Mar 2013 09:50:15 -0800
Message-ID: <CAK5ve-LUMF-QvobozeUTmoj9rEADA1cidABCTMSA+CWAp=883g@mail.gmail.com>
Subject: Re: [PATCH] leds: wm8350: Complain if we fail to reenable DCDC
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, patches@opensource.wolfsonmicro.com,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 9:01 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> Provide some trace, though the hardware is most likely non-functional if
> this happens.
>

Thanks for the update, I will merge it.

-Bryan

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/leds/leds-wm8350.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/leds/leds-wm8350.c b/drivers/leds/leds-wm8350.c
> index ed15157..8a181d5 100644
> --- a/drivers/leds/leds-wm8350.c
> +++ b/drivers/leds/leds-wm8350.c
> @@ -129,7 +129,10 @@ static void wm8350_led_disable(struct wm8350_led *led)
>         ret = regulator_disable(led->isink);
>         if (ret != 0) {
>                 dev_err(led->cdev.dev, "Failed to disable ISINK: %d\n", ret);
> -               regulator_enable(led->dcdc);
> +               ret = regulator_enable(led->dcdc);
> +               if (ret != 0)
> +                       dev_err(led->cdev.dev, "Failed to reenable DCDC: %d\n",
> +                               ret);
>                 return;
>         }
>
> --
> 1.7.10.4
>
