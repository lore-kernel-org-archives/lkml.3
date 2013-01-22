Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3AVDqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:46:39 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64187 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3AVDqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:46:38 -0500
MIME-Version: 1.0
In-Reply-To: <1354869489-4054-1-git-send-email-sachin.kamat@linaro.org>
References: <1354869489-4054-1-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 22 Jan 2013 09:16:37 +0530
Message-ID: <CAK9yfHyHWieyXSrYnfhNciciJRJwmFn4gdj21D-w_AnAK=noFA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: 88pm80x: Remove unnecessary exit APIs
From: Sachin Kamat <sachin.kamat@linaro.org>
To: sameo@linux.intel.com
Cc: sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        Qiao Zhou <zhouqiao@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Could you please check this patch which is pending since some time.

On 7 December 2012 14:08, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> This driver uses devm_* APIs.
> Thus explicit exit calls (regmap_exit and devm_kfree) are not needed
> as they are device managed APIs.
>
> Cc: Qiao Zhou <zhouqiao@marvell.com>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/88pm80x.c |   19 +++----------------
>  1 files changed, 3 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/mfd/88pm80x.c b/drivers/mfd/88pm80x.c
> index 1adb355..3288a4a 100644
> --- a/drivers/mfd/88pm80x.c
> +++ b/drivers/mfd/88pm80x.c
> @@ -48,14 +48,12 @@ int pm80x_init(struct i2c_client *client,
>                 ret = PTR_ERR(map);
>                 dev_err(&client->dev, "Failed to allocate register map: %d\n",
>                         ret);
> -               goto err_regmap_init;
> +               return ret;
>         }
>
>         chip->id = id->driver_data;
> -       if (chip->id < CHIP_PM800 || chip->id > CHIP_PM805) {
> -               ret = -EINVAL;
> -               goto err_chip_id;
> -       }
> +       if (chip->id < CHIP_PM800 || chip->id > CHIP_PM805)
> +               return -EINVAL;
>
>         chip->client = client;
>         chip->regmap = map;
> @@ -82,19 +80,11 @@ int pm80x_init(struct i2c_client *client,
>         }
>
>         return 0;
> -
> -err_chip_id:
> -       regmap_exit(map);
> -err_regmap_init:
> -       devm_kfree(&client->dev, chip);
> -       return ret;
>  }
>  EXPORT_SYMBOL_GPL(pm80x_init);
>
>  int pm80x_deinit(struct i2c_client *client)
>  {
> -       struct pm80x_chip *chip = i2c_get_clientdata(client);
> -
>         /*
>          * workaround: clear the dependency between pm800 and pm805.
>          * would remove it after HW chip fixes the issue.
> @@ -104,9 +94,6 @@ int pm80x_deinit(struct i2c_client *client)
>         else
>                 g_pm80x_chip = NULL;
>
> -       regmap_exit(chip->regmap);
> -       devm_kfree(&client->dev, chip);
> -
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(pm80x_deinit);
> --
> 1.7.4.1
>



-- 
With warm regards,
Sachin
