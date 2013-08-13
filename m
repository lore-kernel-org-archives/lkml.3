Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab3HMTMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:12:51 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:42535 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab3HMTMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:12:50 -0400
MIME-Version: 1.0
In-Reply-To: <1375948794-6286-3-git-send-email-milo.kim@ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com> <1375948794-6286-3-git-send-email-milo.kim@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 13 Aug 2013 12:12:26 -0700
Message-ID: <CAK5ve-KgqN7Lo3XPjC5zDRdgkFuHdx=Tm=Bub9cUub7ZB-iP0g@mail.gmail.com>
Subject: Re: [PATCH 02/10] leds: lp55xx: add common macros for device attributes
To: Milo Kim <woogyom.kim@gmail.com>
Cc: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Milo Kim <milo.kim@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 12:59 AM, Milo Kim <woogyom.kim@gmail.com> wrote:
> This patch provides common macros for LP5521 and LP5523 device attributes and
> functions.
>
> (Device attributes)
> LP5521: 'mode', 'load' and 'selftest'
> LP5523: 'mode', 'load', 'leds' and 'selftest'
>
> (Permissions)
> mode: R/W
> load: Write-only
> leds: R/W
> selftest: Read-only
>
> Couple of lines are duplicate, so use these macros for adding device attributes
> in LP5521 and LP5523 drivers.
>

Good, I will merge this.
-Bryan

> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp55xx-common.h |   47 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>
> diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
> index 04c1d4f..cceab48 100644
> --- a/drivers/leds/leds-lp55xx-common.h
> +++ b/drivers/leds/leds-lp55xx-common.h
> @@ -29,6 +29,53 @@ enum lp55xx_engine_mode {
>         LP55XX_ENGINE_RUN,
>  };
>
> +#define LP55XX_DEV_ATTR_RW(name, show, store)  \
> +       DEVICE_ATTR(name, S_IRUGO | S_IWUSR, show, store)
> +#define LP55XX_DEV_ATTR_RO(name, show)         \
> +       DEVICE_ATTR(name, S_IRUGO, show, NULL)
> +#define LP55XX_DEV_ATTR_WO(name, store)                \
> +       DEVICE_ATTR(name, S_IWUSR, NULL, store)
> +
> +#define show_mode(nr)                                                  \
> +static ssize_t show_engine##nr##_mode(struct device *dev,              \
> +                                   struct device_attribute *attr,      \
> +                                   char *buf)                          \
> +{                                                                      \
> +       return show_engine_mode(dev, attr, buf, nr);                    \
> +}
> +
> +#define store_mode(nr)                                                 \
> +static ssize_t store_engine##nr##_mode(struct device *dev,             \
> +                                    struct device_attribute *attr,     \
> +                                    const char *buf, size_t len)       \
> +{                                                                      \
> +       return store_engine_mode(dev, attr, buf, len, nr);              \
> +}
> +
> +#define show_leds(nr)                                                  \
> +static ssize_t show_engine##nr##_leds(struct device *dev,              \
> +                           struct device_attribute *attr,              \
> +                           char *buf)                                  \
> +{                                                                      \
> +       return show_engine_leds(dev, attr, buf, nr);                    \
> +}
> +
> +#define store_leds(nr)                                         \
> +static ssize_t store_engine##nr##_leds(struct device *dev,     \
> +                            struct device_attribute *attr,     \
> +                            const char *buf, size_t len)       \
> +{                                                              \
> +       return store_engine_leds(dev, attr, buf, len, nr);      \
> +}
> +
> +#define store_load(nr)                                                 \
> +static ssize_t store_engine##nr##_load(struct device *dev,             \
> +                                    struct device_attribute *attr,     \
> +                                    const char *buf, size_t len)       \
> +{                                                                      \
> +       return store_engine_load(dev, attr, buf, len, nr);              \
> +}
> +
>  struct lp55xx_led;
>  struct lp55xx_chip;
>
> --
> 1.7.9.5
>
