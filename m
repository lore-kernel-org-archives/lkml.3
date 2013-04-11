Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3DKGlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 02:41:13 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:34505 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab3DKGlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 02:41:11 -0400
Message-ID: <51665AF6.1010402@stericsson.com>
Date: Thu, 11 Apr 2013 08:40:54 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: ab8500-ext: Make the return type of ab8500_ext_regulator_exit()
 void
References: <1365653058.17060.0.camel@phoenix>
In-Reply-To: <1365653058.17060.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 06:04 AM, Axel Lin wrote:
> ab8500_ext_regulator_exit() never fails.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Looks good to me.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>   drivers/regulator/ab8500-ext.c   |    4 +---
>   drivers/regulator/ab8500.c       |    9 +++------
>   include/linux/regulator/ab8500.h |    2 +-
>   3 files changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
> index dd582be..861ab04 100644
> --- a/drivers/regulator/ab8500-ext.c
> +++ b/drivers/regulator/ab8500-ext.c
> @@ -385,7 +385,7 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
>   	return 0;
>   }
>   
> -int ab8500_ext_regulator_exit(struct platform_device *pdev)
> +void ab8500_ext_regulator_exit(struct platform_device *pdev)
>   {
>   	int i;
>   
> @@ -398,8 +398,6 @@ int ab8500_ext_regulator_exit(struct platform_device *pdev)
>   
>   		regulator_unregister(info->rdev);
>   	}
> -
> -	return 0;
>   }
>   
>   MODULE_LICENSE("GPL v2");
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index 9ebd131..c200f8b 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -3194,12 +3194,9 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
>   		regulator_unregister(info->regulator);
>   	}
>   
> -	if (!is_ab8505(ab8500)) {
> -		/* remove external regulators (after Vaux1, 2 and 3) */
> -		err = ab8500_ext_regulator_exit(pdev);
> -		if (err)
> -			return err;
> -	}
> +	/* remove external regulators (after Vaux1, 2 and 3) */
> +	if (!is_ab8505(ab8500))
> +		ab8500_ext_regulator_exit(pdev);
>   
>   	/* remove regulator debug */
>   	err = ab8500_regulator_debug_exit(pdev);
> diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
> index 90b8b5a..7c5ff0c 100644
> --- a/include/linux/regulator/ab8500.h
> +++ b/include/linux/regulator/ab8500.h
> @@ -338,6 +338,6 @@ static inline int ab8500_regulator_debug_exit(struct platform_device *pdev)
>   
>   /* AB8500 external regulator functions. */
>   int ab8500_ext_regulator_init(struct platform_device *pdev);
> -int ab8500_ext_regulator_exit(struct platform_device *pdev);
> +void ab8500_ext_regulator_exit(struct platform_device *pdev);
>   
>   #endif

