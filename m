Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3FBKg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 06:36:27 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:61852 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3FBKgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 06:36:22 -0400
MIME-Version: 1.0
In-Reply-To: <001101ce5e99$6c8efb00$45acf100$@samsung.com>
References: <001101ce5e99$6c8efb00$45acf100$@samsung.com>
Date: Sun, 2 Jun 2013 13:36:21 +0300
Message-ID: <CAHp75VdKTmoe4=Pb=Q7xGWm-js=grVELa8FVhYDv6GR-8VGW4w@mail.gmail.com>
Subject: Re: [PATCH] power: replace strict_strtoul() with kstrtoul()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Anton Vorontsov <cbou@mail.ru>, Anton Vorontsov <avorontsov@ru.mvista.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 10:27 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.

> --- a/drivers/power/ab8500_fg.c
> +++ b/drivers/power/ab8500_fg.c
> @@ -2467,7 +2467,7 @@ static ssize_t charge_full_store(struct ab8500_fg *di, const char *buf,
>         unsigned long charge_full;
>         ssize_t ret = -EINVAL;

Redundant assignment.

> --- a/drivers/power/pcf50633-charger.c
> +++ b/drivers/power/pcf50633-charger.c
> @@ -191,7 +191,7 @@ static ssize_t set_usblim(struct device *dev,
>         unsigned long ma;
>         int ret;
>
> -       ret = strict_strtoul(buf, 10, &ma);
> +       ret = kstrtoul(buf, 10, &ma);
>         if (ret)
>                 return -EINVAL;

return ret;

> @@ -228,7 +228,7 @@ static ssize_t set_chglim(struct device *dev,
>         if (!mbc->pcf->pdata->charger_reference_current_ma)
>                 return -ENODEV;
>
> -       ret = strict_strtoul(buf, 10, &ma);
> +       ret = kstrtoul(buf, 10, &ma);
>         if (ret)
>                 return -EINVAL;

Ditto.

--
With Best Regards,
Andy Shevchenko
