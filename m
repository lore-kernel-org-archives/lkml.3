Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3FCLK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:10:29 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36784 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3FCLK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:10:26 -0400
MIME-Version: 1.0
In-Reply-To: <001501ce6039$c967d2b0$5c377810$@samsung.com>
References: <001501ce6039$c967d2b0$5c377810$@samsung.com>
Date: Mon, 3 Jun 2013 14:10:26 +0300
Message-ID: <CAHp75VdUzw3wwQU5VnBGe3oPYEoHc8HO51C6VmViNF=B-bazyw@mail.gmail.com>
Subject: Re: [PATCH V2] rtc: rtc-pcf2123: replace strict_strtoul() with kstrtoul()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 12:07 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.

There is an issue, after fixing it take my
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> --- a/drivers/rtc/rtc-pcf2123.c
> +++ b/drivers/rtc/rtc-pcf2123.c


> @@ -117,9 +118,9 @@ static ssize_t pcf2123_store(struct device *dev, struct device_attribute *attr,
>
>         r = container_of(attr, struct pcf2123_sysfs_reg, attr);
>
> -       if (strict_strtoul(r->name, 16, &reg)
> -               || strict_strtoul(buffer, 10, &val))
> -               return -EINVAL;
> +       ret = kstrtoul(r->name, 16, &reg) || kstrtoul(buffer, 10, &val);

This is not correct. Please, split to two sequential checks.

> +       if (ret)
> +               return ret;

--
With Best Regards,
Andy Shevchenko
