Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3FLJ1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:27:41 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:45507 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab3FLJ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:27:40 -0400
Date: Wed, 12 Jun 2013 10:27:34 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: 88pm860x: Use devm_regmap_init_i2c()
Message-ID: <20130612092734.GC4320@laptop>
References: <1371025543-4485-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371025543-4485-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013, Sachin Kamat wrote:

> devm_regmap_init_i2c() is device managed and makes cleanup simpler.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/88pm860x-core.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
> index ef6d82c..eeb481d 100644
> --- a/drivers/mfd/88pm860x-core.c
> +++ b/drivers/mfd/88pm860x-core.c
> @@ -1156,7 +1156,7 @@ static int pm860x_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  
>  	chip->id = verify_addr(client);
> -	chip->regmap = regmap_init_i2c(client, &pm860x_regmap_config);
> +	chip->regmap = devm_regmap_init_i2c(client, &pm860x_regmap_config);
>  	if (IS_ERR(chip->regmap)) {
>  		ret = PTR_ERR(chip->regmap);
>  		dev_err(&client->dev, "Failed to allocate register map: %d\n",
> @@ -1203,7 +1203,6 @@ static int pm860x_remove(struct i2c_client *client)
>  		regmap_exit(chip->regmap_companion);
>  		i2c_unregister_device(chip->companion);
>  	}
> -	regmap_exit(chip->regmap);
>  	return 0;
>  }

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
