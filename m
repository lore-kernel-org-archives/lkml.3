Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871Ab3DBNJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:09:17 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:45175 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760508Ab3DBNJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:09:15 -0400
Message-ID: <515AD866.2010207@stericsson.com>
Date: Tue, 2 Apr 2013 15:08:54 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: ab8500-ext: Don't update info->is_enabled
 if write to register fails
References: <1364907376.9803.1.camel@phoenix>
In-Reply-To: <1364907376.9803.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 02:56 PM, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>   drivers/regulator/ab8500-ext.c |    8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
> index 21b9bfb..7923e82 100644
> --- a/drivers/regulator/ab8500-ext.c
> +++ b/drivers/regulator/ab8500-ext.c
> @@ -72,9 +72,11 @@ static int enable(struct ab8500_ext_regulator_info *info, u8 *regval)
>   	ret = abx500_mask_and_set_register_interruptible(info->dev,
>   		info->update_bank, info->update_reg,
>   		info->update_mask, *regval);
> -	if (ret < 0)
> +	if (ret < 0) {
>   		dev_err(rdev_get_dev(info->rdev),
>   			"couldn't set enable bits for regulator\n");
> +		return ret;
> +	}
>   
>   	info->is_enabled = true;
>   
> @@ -117,9 +119,11 @@ static int disable(struct ab8500_ext_regulator_info *info, u8 *regval)
>   	ret = abx500_mask_and_set_register_interruptible(info->dev,
>   		info->update_bank, info->update_reg,
>   		info->update_mask, *regval);
> -	if (ret < 0)
> +	if (ret < 0) {
>   		dev_err(rdev_get_dev(info->rdev),
>   			"couldn't set disable bits for regulator\n");
> +		return ret;
> +	}
>   
>   	info->is_enabled = false;
>   

