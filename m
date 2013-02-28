Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3B1I4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:56:11 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:59113 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3B1I4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:56:08 -0500
MIME-Version: 1.0
In-Reply-To: <00ab01ce158f$6434eda0$2c9ec8e0$%han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
	<00ab01ce158f$6434eda0$2c9ec8e0$%han@samsung.com>
Date: Thu, 28 Feb 2013 09:56:05 +0100
X-Google-Sender-Auth: bTjDojeeP3Zzo2CdPfauTAAZJ1M
Message-ID: <CAMuHMdVgeXNUaGxzV=sicvVM8m_1sd0Xqm2njaRn9QqM=VibfQ@mail.gmail.com>
Subject: Re: [PATCH 07/19] rtc: rtc-ps3: remove erroneous __init/__exit annotations
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 9:41 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> __init/__exit annotations for probe()/remove() are supposed to be
> __devinit/__devexit, because __init/__exit for probe()/remove()
> are not correct. However, __devinit/__devexit are not used,
> because CONFIG_HOTPLUG was removed. Thus, these annotations
> should be removed.

Nack.

This driver does not use platform_driver_register(), but
platform_driver_probe().
Hence the .probe can only be called from platform_driver_probe()
(which is __init),
not at any later time.

I did not check the other drivers you sent patches for.

> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/rtc/rtc-ps3.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/rtc/rtc-ps3.c b/drivers/rtc/rtc-ps3.c
> index 968133c..8a24d11 100644
> --- a/drivers/rtc/rtc-ps3.c
> +++ b/drivers/rtc/rtc-ps3.c
> @@ -58,7 +58,7 @@ static const struct rtc_class_ops ps3_rtc_ops = {
>         .set_time = ps3_set_time,
>  };
>
> -static int __init ps3_rtc_probe(struct platform_device *dev)
> +static int ps3_rtc_probe(struct platform_device *dev)
>  {
>         struct rtc_device *rtc;
>
> @@ -71,7 +71,7 @@ static int __init ps3_rtc_probe(struct platform_device *dev)
>         return 0;
>  }
>
> -static int __exit ps3_rtc_remove(struct platform_device *dev)
> +static int ps3_rtc_remove(struct platform_device *dev)
>  {
>         rtc_device_unregister(platform_get_drvdata(dev));
>         return 0;
> @@ -82,7 +82,7 @@ static struct platform_driver ps3_rtc_driver = {
>                 .name = "rtc-ps3",
>                 .owner = THIS_MODULE,
>         },
> -       .remove = __exit_p(ps3_rtc_remove),
> +       .remove = ps3_rtc_remove,
>  };
>
>  static int __init ps3_rtc_init(void)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
