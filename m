Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3KLAyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:54:10 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38582 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab3KLAyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:54:05 -0500
MIME-Version: 1.0
In-Reply-To: <20131112004436.GA30125@july>
References: <20131112004436.GA30125@july>
Date: Tue, 12 Nov 2013 09:54:04 +0900
X-Google-Sender-Auth: TdnWk3Aqr2jHadk0btki3_lFFEE
Message-ID: <CAH9JG2V0_aFdJaNcVBOYnE=s1YP8hfFhQPjdQ=+HBr0Afy5fLw@mail.gmail.com>
Subject: Re: [PATCH] video: backlight: Remove backlight sysfs uevent
From: Kyungmin Park <kmpark@infradead.org>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org, kay@vrfy.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore it. strange mail system.

After feedback from previous mail, I'll re-send it.

Thank you,
Kyungmin Park

On Tue, Nov 12, 2013 at 9:44 AM, Kyungmin Park <kmpark@infradead.org> wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
>
> The most mobile phones have Ambient Light Sensors and it changes brightness according lux.
> It means it changes backlight brightness frequently by just writing sysfs node, so it generates uevent.
>
> Usually there's no user to use this backlight changes. But it forks udev worker threads and it takes about 5ms. The main problem is that it hurts other process activities. so remove it.
>
> Kay said
> "Uevents are for the major, low-frequent, global device state-changes,
>  not for carrying-out any sort of measurement data. Subsystems which
>  need that should use other facilities like poll()-able sysfs file or
>  any other subscription-based, client-tracking interface which does not
>  cause overhead if it isn't used. Uevents are not the right thing to
>  use here, and upstream udev should not paper-over broken kernel
>  subsystems."
>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index 94a403a..441272d 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -88,9 +88,6 @@ static void backlight_generate_event(struct backlight_device *bd,
>         char *envp[2];
>
>         switch (reason) {
> -       case BACKLIGHT_UPDATE_SYSFS:
> -               envp[0] = "SOURCE=sysfs";
> -               break;
>         case BACKLIGHT_UPDATE_HOTKEY:
>                 envp[0] = "SOURCE=hotkey";
>                 break;
> @@ -172,8 +169,6 @@ static ssize_t brightness_store(struct device *dev,
>         }
>         mutex_unlock(&bd->ops_lock);
>
> -       backlight_generate_event(bd, BACKLIGHT_UPDATE_SYSFS);
> -
>         return rc;
>  }
>  static DEVICE_ATTR_RW(brightness);
> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index 53b7794..d2a27dd 100644
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -29,7 +29,6 @@
>
>  enum backlight_update_reason {
>         BACKLIGHT_UPDATE_HOTKEY,
> -       BACKLIGHT_UPDATE_SYSFS,
>  };
>
>  enum backlight_type {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
