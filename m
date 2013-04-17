Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966422Ab3DQNxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:53:06 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:58492 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966116Ab3DQNxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:53:03 -0400
Message-ID: <516EA93E.1020409@slimlogic.co.uk>
Date: Wed, 17 Apr 2013 14:53:02 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@kernel.org, sameo@linux.intel.com, ian@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/3] regulator: palmas: clear sleep bits if not selected
References: <1366191793-13934-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1366191793-13934-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is good with me, I originally had it like this and I cannot
remember why I convinced myself not to do it this way.

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

On 17/04/13 10:43, Laxman Dewangan wrote:
> Clear the sleep/warm reset bits when it is not selected through
> regulator platform data. This will make sure that configuration
> is inline with the platform data regardless of boot/POR
> configuration.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/regulator/palmas-regulator.c |   18 ++++++++++++------
>  1 files changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index 7c54e31..7c7992b 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -444,24 +444,26 @@ static int palmas_smps_init(struct palmas *palmas, int id,
>  
>  	switch (id) {
>  	case PALMAS_REG_SMPS10:
> -		if (reg_init->mode_sleep) {
> -			reg &= ~PALMAS_SMPS10_CTRL_MODE_SLEEP_MASK;
> +		reg &= ~PALMAS_SMPS10_CTRL_MODE_SLEEP_MASK;
> +		if (reg_init->mode_sleep)
>  			reg |= reg_init->mode_sleep <<
>  					PALMAS_SMPS10_CTRL_MODE_SLEEP_SHIFT;
> -		}
>  		break;
>  	default:
>  		if (reg_init->warm_reset)
>  			reg |= PALMAS_SMPS12_CTRL_WR_S;
> +		else
> +			reg &= ~PALMAS_SMPS12_CTRL_WR_S;
>  
>  		if (reg_init->roof_floor)
>  			reg |= PALMAS_SMPS12_CTRL_ROOF_FLOOR_EN;
> +		else
> +			reg &= ~PALMAS_SMPS12_CTRL_ROOF_FLOOR_EN;
>  
> -		if (reg_init->mode_sleep) {
> -			reg &= ~PALMAS_SMPS12_CTRL_MODE_SLEEP_MASK;
> +		reg &= ~PALMAS_SMPS12_CTRL_MODE_SLEEP_MASK;
> +		if (reg_init->mode_sleep)
>  			reg |= reg_init->mode_sleep <<
>  					PALMAS_SMPS12_CTRL_MODE_SLEEP_SHIFT;
> -		}
>  	}
>  
>  	ret = palmas_smps_write(palmas, addr, reg);
> @@ -507,9 +509,13 @@ static int palmas_ldo_init(struct palmas *palmas, int id,
>  
>  	if (reg_init->warm_reset)
>  		reg |= PALMAS_LDO1_CTRL_WR_S;
> +	else
> +		reg &= ~PALMAS_LDO1_CTRL_WR_S;
>  
>  	if (reg_init->mode_sleep)
>  		reg |= PALMAS_LDO1_CTRL_MODE_SLEEP;
> +	else
> +		reg &= ~PALMAS_LDO1_CTRL_MODE_SLEEP;
>  
>  	ret = palmas_ldo_write(palmas, addr, reg);
>  	if (ret)

