Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935264Ab3BOBZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 20:25:17 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:41625 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759339Ab3BOBZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 20:25:16 -0500
MIME-Version: 1.0
In-Reply-To: <1360880818-4071454-5-git-send-email-arnd@arndb.de>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
	<1360880818-4071454-5-git-send-email-arnd@arndb.de>
Date: Fri, 15 Feb 2013 09:25:14 +0800
Message-ID: <CAN1soZybF=bqWe88NWNYb1m8etQGF_YeAxTmtqVwKDcNzCvX5g@mail.gmail.com>
Subject: Re: [PATCH 4/9] mfd: max8925: fix trivial build warning for non-dt
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Qing Xu <qingx@marvell.com>, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 6:26 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> Patch fe527ea5a "mfd: max8925: Support dt for backlight"
> added a new function for DT probing but introduced a
> build warning for the case where CONFIG_OF is disabled:
>
> drivers/video/backlight/max8925_bl.c: In function 'max8925_backlight_probe':
> drivers/video/backlight/max8925_bl.c:177:3: warning: statement with no effect [-Wunused-value]
>
> A much nicer fix is to use the IS_ENABLED keyword to
> have the same effect of dropping the device tree specific
> function when it's not needed.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Qing Xu <qingx@marvell.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/video/backlight/max8925_bl.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
> index 5ca11b0..9958fb1 100644
> --- a/drivers/video/backlight/max8925_bl.c
> +++ b/drivers/video/backlight/max8925_bl.c
> @@ -101,14 +101,13 @@ static const struct backlight_ops max8925_backlight_ops = {
>         .get_brightness = max8925_backlight_get_brightness,
>  };
>
> -#ifdef CONFIG_OF
>  static int max8925_backlight_dt_init(struct platform_device *pdev,
>                               struct max8925_backlight_pdata *pdata)
>  {
>         struct device_node *nproot = pdev->dev.parent->of_node, *np;
>         int dual_string;
>
> -       if (!nproot)
> +       if (!nproot || !IS_ENABLED(CONFIG_OF))
>                 return -ENODEV;
>         np = of_find_node_by_name(nproot, "backlight");
>         if (!np) {
> @@ -120,9 +119,6 @@ static int max8925_backlight_dt_init(struct platform_device *pdev,
>         pdata->dual_string = dual_string;
>         return 0;
>  }
> -#else
> -#define max8925_backlight_dt_init(x, y)        (-1)
> -#endif
>
>  static int max8925_backlight_probe(struct platform_device *pdev)
>  {
> --
> 1.8.1.2
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
