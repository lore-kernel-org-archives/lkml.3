Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbbAETgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:36:50 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:44473 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbbAETgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:36:48 -0500
MIME-Version: 1.0
In-Reply-To: <1419604558-29743-15-git-send-email-Julia.Lawall@lip6.fr>
References: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr> <1419604558-29743-15-git-send-email-Julia.Lawall@lip6.fr>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 5 Jan 2015 11:36:27 -0800
Message-ID: <CAK5ve-+jiFK+cZbVfg3G1X1y6LbcXw+F1LB+tv3KbsOb7pUuCw@mail.gmail.com>
Subject: Re: [PATCH 14/27] leds: Use setup_timer
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 6:35 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> Convert a call to init_timer and accompanying intializations of
> the timer's data and function fields to a call to setup_timer.
>
> A simplified version of the semantic match that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression t,f,d;
> @@
>
> -init_timer(&t);
> +setup_timer(&t,f,d);
> -t.function = f;
> -t.data = d;
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>

Thanks, applied.
-Bryan

> ---
>  drivers/leds/led-class.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index dbeebac..291ca45 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -239,9 +239,8 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
>
>         INIT_WORK(&led_cdev->set_brightness_work, set_brightness_delayed);
>
> -       init_timer(&led_cdev->blink_timer);
> -       led_cdev->blink_timer.function = led_timer_function;
> -       led_cdev->blink_timer.data = (unsigned long)led_cdev;
> +       setup_timer(&led_cdev->blink_timer, led_timer_function,
> +                   (unsigned long)led_cdev);
>
>  #ifdef CONFIG_LEDS_TRIGGERS
>         led_trigger_set_default(led_cdev);
>
