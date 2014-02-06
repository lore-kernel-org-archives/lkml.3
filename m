Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbaBFTYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:24:53 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:54472 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaBFTYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:24:50 -0500
MIME-Version: 1.0
In-Reply-To: <1390218087-14597-1-git-send-email-b38343@freescale.com>
References: <1390218087-14597-1-git-send-email-b38343@freescale.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 6 Feb 2014 11:24:28 -0800
Message-ID: <CAK5ve-Km-STOFra=Z4G6wjOFgzeguvumhaWzUq_juYUD3Gwg1A@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] leds: leds-gpio: add retain-state-suspended property
To: Robin Gong <b38343@freescale.com>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, galak@codeaurora.org,
        Rob Landley <rob@landley.net>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 3:41 AM, Robin Gong <b38343@freescale.com> wrote:
> Some gpio-leds need retain the state even in suspend, such as charger led.
> But this property missed in devicetree, add it.
>

Good catch, I just fold these 2 patches into one patch and applied.
Thanks,
-Bryan


> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  drivers/leds/leds-gpio.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
> index 78b0e27..1bb3f1a 100644
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -204,6 +204,9 @@ static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
>                                 led.default_state = LEDS_GPIO_DEFSTATE_OFF;
>                 }
>
> +               if (of_get_property(child, "retain-state-suspended", NULL))
> +                       led.retain_state_suspended = 1;
> +
>                 ret = create_gpio_led(&led, &priv->leds[priv->num_leds++],
>                                       &pdev->dev, NULL);
>                 if (ret < 0) {
> --
> 1.7.5.4
>
>
