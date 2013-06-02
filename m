Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3FBMIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 08:08:12 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:51395 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3FBMIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 08:08:07 -0400
MIME-Version: 1.0
In-Reply-To: <001701ce5e9a$e05feac0$a11fc040$@samsung.com>
References: <001701ce5e9a$e05feac0$a11fc040$@samsung.com>
Date: Sun, 2 Jun 2013 15:08:05 +0300
Message-ID: <CAHp75VdKBT+yPQ0412wiY7ZCqL27cwJCpKM9_yVw48mtGWWw0w@mail.gmail.com>
Subject: Re: [PATCH] misc: replace strict_strtoul() with kstrtoul()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Dimitri Sivanich <sivanich@sgi.com>, Robin Holt <holt@sgi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 10:37 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.

> --- a/drivers/misc/apds9802als.c
> +++ b/drivers/misc/apds9802als.c
> @@ -126,7 +126,7 @@ static ssize_t als_sensing_range_store(struct device *dev,
>         int ret_val;
>         unsigned long val;
>
> -       if (strict_strtoul(buf, 10, &val))
> +       if (kstrtoul(buf, 10, &val))
>                 return -EINVAL;

ret_val = kstrtoul();
if (ret_val)
return ret_val;

> --- a/drivers/misc/apds990x.c
> +++ b/drivers/misc/apds990x.c
> @@ -697,7 +697,7 @@ static ssize_t apds990x_lux_calib_store(struct device *dev,
>         struct apds990x_chip *chip = dev_get_drvdata(dev);
>         unsigned long value;
>
> -       if (strict_strtoul(buf, 0, &value))
> +       if (kstrtoul(buf, 0, &value))
>                 return -EINVAL;

Ditto. Here and across entire patch.

> @@ -895,7 +895,7 @@ static ssize_t apds990x_set_lux_thresh(struct apds990x_chip *chip, u32 *target,
>         int ret = 0;

Remove this assignment...

>         unsigned long thresh;
>
> -       if (strict_strtoul(buf, 0, &thresh))
> +       if (kstrtoul(buf, 0, &thresh))
>                 return -EINVAL;

...and use return code from kstrtoul().

> --- a/drivers/misc/carma/carma-fpga.c
> +++ b/drivers/misc/carma/carma-fpga.c
> @@ -1002,7 +1002,7 @@ static ssize_t data_en_set(struct device *dev, struct device_attribute *attr,
>         unsigned long enable;
>         int ret;
>
> -       ret = strict_strtoul(buf, 0, &enable);
> +       ret = kstrtoul(buf, 0, &enable);
>         if (ret) {
>                 dev_err(priv->dev, "unable to parse enable input\n");
>                 return -EINVAL;

return ret;

--
With Best Regards,
Andy Shevchenko
