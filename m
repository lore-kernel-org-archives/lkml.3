Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3FBL4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 07:56:15 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:61135 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3FBL4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 07:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <001501ce5e9a$15731080$40593180$@samsung.com>
References: <001501ce5e9a$15731080$40593180$@samsung.com>
Date: Sun, 2 Jun 2013 14:56:02 +0300
Message-ID: <CAHp75Vce+=1Fdb0Eqg0w+e511cAJeZ8cP6-d+9ng=s-5tJ5C+g@mail.gmail.com>
Subject: Re: [PATCH] rtc: rtc-pcf2123: replace strict_strtoul() with kstrtoul()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 10:31 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.

> --- a/drivers/rtc/rtc-pcf2123.c
> +++ b/drivers/rtc/rtc-pcf2123.c
> @@ -94,7 +94,7 @@ static ssize_t pcf2123_show(struct device *dev, struct device_attribute *attr,
>
>         r = container_of(attr, struct pcf2123_sysfs_reg, attr);
>
> -       if (strict_strtoul(r->name, 16, &reg))
> +       if (kstrtoul(r->name, 16, &reg))
>                 return -EINVAL;

ret = kstrtoul(...);
if (ret)
return ret;

> @@ -117,8 +117,7 @@ static ssize_t pcf2123_store(struct device *dev, struct device_attribute *attr,
>
>         r = container_of(attr, struct pcf2123_sysfs_reg, attr);
>
> -       if (strict_strtoul(r->name, 16, &reg)
> -               || strict_strtoul(buffer, 10, &val))
> +       if (kstrtoul(r->name, 16, &reg) || kstrtoul(buffer, 10, &val))
>                 return -EINVAL;

I see no harm to allow user to write octal values as well.
Thus, just
ret = kstrtoul(r->name, 0, &reg);
if (ret)
return ret;

Alessandro, what do you think?

--
With Best Regards,
Andy Shevchenko
