Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbaLWTDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 14:03:09 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38163 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaLWTDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 14:03:07 -0500
MIME-Version: 1.0
In-Reply-To: <1419361163-4762-1-git-send-email-gabriele.mzt@gmail.com>
References: <1419361163-4762-1-git-send-email-gabriele.mzt@gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 23 Dec 2014 11:02:46 -0800
Message-ID: <CAK5ve-+CgLNd0R6V21EFwgO-HmbV-RAixXipgxqyPKF9irOzuw@mail.gmail.com>
Subject: Re: [PATCH] leds: Don't allow brightness values greater than max_brightness
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 10:59 AM, Gabriele Mazzotta
<gabriele.mzt@gmail.com> wrote:
> Since commit 4d71a4a12b13 ("leds: Add support for setting brightness in
> a synchronous way") the value passed to brightness_set() is no longer
> limited to max_brightness and can be different from the internally saved
> brightness value.
>
Good catch, I will merge this soon.

Thanks,
-Bryan

> Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
> ---
>  drivers/leds/leds.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
> index 2348dbd..79efe57 100644
> --- a/drivers/leds/leds.h
> +++ b/drivers/leds/leds.h
> @@ -20,7 +20,8 @@
>  static inline void led_set_brightness_async(struct led_classdev *led_cdev,
>                                         enum led_brightness value)
>  {
> -       led_cdev->brightness = min(value, led_cdev->max_brightness);
> +       value = min(value, led_cdev->max_brightness);
> +       led_cdev->brightness = value;
>
>         if (!(led_cdev->flags & LED_SUSPENDED))
>                 led_cdev->brightness_set(led_cdev, value);
> --
> 2.1.4
>
