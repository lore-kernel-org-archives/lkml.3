Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578Ab3CZIsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 04:48:35 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:53285 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759426Ab3CZIsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 04:48:33 -0400
Message-ID: <515160D3.5020908@stericsson.com>
Date: Tue, 26 Mar 2013 09:48:19 +0100
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] regulator: ab8500: Don't update is_enabled flag in
 error paths
References: <1364285594.27005.2.camel@phoenix>
In-Reply-To: <1364285594.27005.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 09:13 AM, Axel Lin wrote:
> This avoid setting is_enabled flag to wrong status if enable/disable fails.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Looks good to me, thanks.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
> v2: Just make the coding style consist with rest of the code.
>
>   drivers/regulator/ab8500.c |    8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index 12e2740..4a70323 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -117,9 +117,11 @@ static int ab8500_regulator_enable(struct regulator_dev *rdev)
>   	ret = abx500_mask_and_set_register_interruptible(info->dev,
>   		info->update_bank, info->update_reg,
>   		info->update_mask, info->update_val);
> -	if (ret < 0)
> +	if (ret < 0) {
>   		dev_err(rdev_get_dev(rdev),
>   			"couldn't set enable bits for regulator\n");
> +		return ret;
> +	}
>   
>   	info->is_enabled = true;
>   
> @@ -144,9 +146,11 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
>   	ret = abx500_mask_and_set_register_interruptible(info->dev,
>   		info->update_bank, info->update_reg,
>   		info->update_mask, 0x0);
> -	if (ret < 0)
> +	if (ret < 0) {
>   		dev_err(rdev_get_dev(rdev),
>   			"couldn't set disable bits for regulator\n");
> +		return ret;
> +	}
>   
>   	info->is_enabled = false;
>   

