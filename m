Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018AbaAEIKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 03:10:45 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41264 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaAEIKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 03:10:43 -0500
MIME-Version: 1.0
In-Reply-To: <1387734529-15622-1-git-send-email-badarkhe.manish@gmail.com>
References: <1387734529-15622-1-git-send-email-badarkhe.manish@gmail.com>
Date: Sun, 5 Jan 2014 13:40:42 +0530
Message-ID: <CAKDJKT5cCebTV5F0uS_TBxjrJL4PGiUc68kiv51q0mnMjQC3HQ@mail.gmail.com>
Subject: Re: [PATCH] mfd: max8997: Use "IS_ENABLED(CONFIG_OF)" for DT code.
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?B?4KSu4KSo4KS/4KS3IOCkrOCkpuCksOCkluClhw==?= 
	<badarkhe.manish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Sun, Dec 22, 2013 at 11:18 PM, Manish Badarkhe
<badarkhe.manish@gmail.com> wrote:
>
> Instead of "#if define CONFIG_OF" use "IS_ENABLED(CONFIG_OF)"
> option for DT code to avoid if-deffery in code.
>
> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> ---
> :100644 100644 791aea3... be9a8b0... M  drivers/mfd/max8997.c
>  drivers/mfd/max8997.c |   14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index 791aea3..be9a8b0 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> @@ -133,7 +133,6 @@ int max8997_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
>  }
>  EXPORT_SYMBOL_GPL(max8997_update_reg);
>
> -#ifdef CONFIG_OF
>  /*
>   * Only the common platform data elements for max8997 are parsed here from the
>   * device tree. Other sub-modules of max8997 such as pmic, rtc and others have
> @@ -164,24 +163,15 @@ static struct max8997_platform_data *max8997_i2c_parse_dt_pdata(
>
>         return pd;
>  }
> -#else
> -static struct max8997_platform_data *max8997_i2c_parse_dt_pdata(
> -                                       struct device *dev)
> -{
> -       return 0;
> -}
> -#endif
>
>  static inline int max8997_i2c_get_driver_data(struct i2c_client *i2c,
>                                                 const struct i2c_device_id *id)
>  {
> -#ifdef CONFIG_OF
> -       if (i2c->dev.of_node) {
> +       if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node) {
>                 const struct of_device_id *match;
>                 match = of_match_node(max8997_pmic_dt_match, i2c->dev.of_node);
>                 return (int)match->data;
>         }
> -#endif
>         return (int)id->driver_data;
>  }
>
> @@ -203,7 +193,7 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>         max8997->type = max8997_i2c_get_driver_data(i2c, id);
>         max8997->irq = i2c->irq;
>
> -       if (max8997->dev->of_node) {
> +       if (IS_ENABLED(CONFIG_OF) && max8997->dev->of_node) {
>                 pdata = max8997_i2c_parse_dt_pdata(max8997->dev);
>                 if (IS_ERR(pdata))
>                         return PTR_ERR(pdata);

Gentle ping.
Please let me know, Are there any review comments on this patch?

Regards
Manish Badarkhe
