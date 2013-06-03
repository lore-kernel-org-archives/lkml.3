Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3FCKtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:49:51 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34524 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab3FCKtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:49:49 -0400
MIME-Version: 1.0
In-Reply-To: <000901ce6039$7071c670$51555350$@samsung.com>
References: <000901ce6039$7071c670$51555350$@samsung.com>
Date: Mon, 3 Jun 2013 13:49:49 +0300
Message-ID: <CAHp75Vdrhi=sX_MxeT6oqW6s8bbxqWr+rw4PsCYSepw+yffXWg@mail.gmail.com>
Subject: Re: [PATCH V2] power: replace strict_strtoul() with kstrtoul()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Anton Vorontsov <cbou@mail.ru>, Anton Vorontsov <avorontsov@ru.mvista.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 12:05 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Looks better.
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> ---
> Changes since v1:
> - Used return code from kstrtoul().
>
>  drivers/power/ab8500_fg.c        |    6 +++---
>  drivers/power/pcf50633-charger.c |    8 ++++----
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
> index c5391f5..308e511 100644
> --- a/drivers/power/ab8500_fg.c
> +++ b/drivers/power/ab8500_fg.c
> @@ -2465,9 +2465,9 @@ static ssize_t charge_full_store(struct ab8500_fg *di, const char *buf,
>                                  size_t count)
>  {
>         unsigned long charge_full;
> -       ssize_t ret = -EINVAL;
> +       ssize_t ret;
>
> -       ret = strict_strtoul(buf, 10, &charge_full);
> +       ret = kstrtoul(buf, 10, &charge_full);
>
>         dev_dbg(di->dev, "Ret %zd charge_full %lu", ret, charge_full);
>
> @@ -2489,7 +2489,7 @@ static ssize_t charge_now_store(struct ab8500_fg *di, const char *buf,
>         unsigned long charge_now;
>         ssize_t ret;
>
> -       ret = strict_strtoul(buf, 10, &charge_now);
> +       ret = kstrtoul(buf, 10, &charge_now);
>
>         dev_dbg(di->dev, "Ret %zd charge_now %lu was %d",
>                 ret, charge_now, di->bat_cap.prev_mah);
> diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
> index 17fd77f..771c4f0 100644
> --- a/drivers/power/pcf50633-charger.c
> +++ b/drivers/power/pcf50633-charger.c
> @@ -191,9 +191,9 @@ static ssize_t set_usblim(struct device *dev,
>         unsigned long ma;
>         int ret;
>
> -       ret = strict_strtoul(buf, 10, &ma);
> +       ret = kstrtoul(buf, 10, &ma);
>         if (ret)
> -               return -EINVAL;
> +               return ret;
>
>         pcf50633_mbc_usb_curlim_set(mbc->pcf, ma);
>
> @@ -228,9 +228,9 @@ static ssize_t set_chglim(struct device *dev,
>         if (!mbc->pcf->pdata->charger_reference_current_ma)
>                 return -ENODEV;
>
> -       ret = strict_strtoul(buf, 10, &ma);
> +       ret = kstrtoul(buf, 10, &ma);
>         if (ret)
> -               return -EINVAL;
> +               return ret;
>
>         mbcc5 = (ma << 8) / mbc->pcf->pdata->charger_reference_current_ma;
>         if (mbcc5 > 255)
> --
> 1.7.10.4
>
>



--
With Best Regards,
Andy Shevchenko
