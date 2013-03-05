Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab3CETEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:04:15 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:58243 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3CETEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:04:13 -0500
MIME-Version: 1.0
In-Reply-To: <1362210046-13651-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1362210046-13651-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 5 Mar 2013 11:03:52 -0800
Message-ID: <CAK5ve-+FTv1OTfJozs_sy7B0Zd6SzzBOU_1En4AMQCw1RZjprw@mail.gmail.com>
Subject: Re: [PATCH] leds: wm8350: Complain if we fail to reenable DCDC
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, patches@opensource.wolfsonmicro.com,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 11:40 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> Provide some trace, though the hardware is most likely non-functional if
> this happens.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/leds/leds-wm8350.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/leds/leds-wm8350.c b/drivers/leds/leds-wm8350.c
> index ed15157..86bdab3 100644
> --- a/drivers/leds/leds-wm8350.c
> +++ b/drivers/leds/leds-wm8350.c
> @@ -129,7 +129,11 @@ static void wm8350_led_disable(struct wm8350_led *led)
>         ret = regulator_disable(led->isink);
>         if (ret != 0) {
>                 dev_err(led->cdev.dev, "Failed to disable ISINK: %d\n", ret);
> -               regulator_enable(led->dcdc);
> +               ret = regulator_enable(led->dcdc);
> +               if (ret != 0) {
looks like we don't need this bracket here.

> +                       dev_err(led->cdev.dev, "Failed to reenable DCDC: %d\n",
> +                               ret);
> +               }
ditto.

Thanks,
-Bryan
