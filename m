Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3BQC5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 21:57:19 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:38731 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab3BQC5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 21:57:18 -0500
MIME-Version: 1.0
In-Reply-To: <1360608173-12907-2-git-send-email-shc_work@mail.ru>
References: <1360608173-12907-1-git-send-email-shc_work@mail.ru>
	<1360608173-12907-2-git-send-email-shc_work@mail.ru>
Date: Sun, 17 Feb 2013 10:57:16 +0800
Message-ID: <CAP1dx+yVg+CfRFjy2dTs6JRpDP=3bF9do_NQbQtBThj+2ijV5g@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mfd: syscon: Removed unneeded field "dev" from
 private driver structure
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 February 2013 02:42, Alexander Shiyan <shc_work@mail.ru> wrote:
>
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

> ---
>  drivers/mfd/syscon.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index e1886fb..4a7ed5a 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -24,17 +24,15 @@
>  static struct platform_driver syscon_driver;
>
>  struct syscon {
> -       struct device *dev;
>         void __iomem *base;
>         struct regmap *regmap;
>  };
>
>  static int syscon_match(struct device *dev, void *data)
>  {
> -       struct syscon *syscon = dev_get_drvdata(dev);
>         struct device_node *dn = data;
>
> -       return (syscon->dev->of_node == dn) ? 1 : 0;
> +       return (dev->of_node == dn) ? 1 : 0;
>  }
>
>  struct regmap *syscon_node_to_regmap(struct device_node *np)
> @@ -129,7 +127,6 @@ static int syscon_probe(struct platform_device *pdev)
>                 return PTR_ERR(syscon->regmap);
>         }
>
> -       syscon->dev = dev;
>         platform_set_drvdata(pdev, syscon);
>
>         dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
> --
> 1.7.12.4
>
