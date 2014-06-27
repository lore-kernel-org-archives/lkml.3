Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaF0JUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:20:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56037 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaF0JUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:20:06 -0400
Message-ID: <53AD36E1.1010700@ti.com>
Date: Fri, 27 Jun 2014 14:48:25 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Keerthy <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <t-kristo@ti.com>
Subject: Re: [PATCH] regulator: tps65917: Fix SMPS enable/disable/is_enable
References: <1403807494-23907-1-git-send-email-nm@ti.com>
In-Reply-To: <1403807494-23907-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nishanth,

On Friday 27 June 2014 12:01 AM, Nishanth Menon wrote:
> We use regmap regulator ops to enable/disable and check if regulator
> is enabled for various SMPS. However, these depend on valid
> enable_reg, enable_mask and enable_value in regulator descriptor.
>
> So, similar to fix we did in commit 318dbb02b50c
> ("regulator: palmas: Fix SMPS enable/disable/is_enabled"), populate the
> same for TPS65917 SMPS registration. LDO definitions are already in place.
>
> Fixes: d6f83370ed97 ("regulator: palmas: Add tps65917 PMIC support")
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>
> Applies on:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git
> branch: topic/palmas (4c0c9ca Merge remote-tracking branch 'regulator/fix/palmas' into regulator-palmas)
>
> Note: Ignored the minor style check from checkpatch --strict as fixing
> it would create an 80 char warning
>
>   drivers/regulator/palmas-regulator.c |    8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index 7c8b441..c7aa1b1 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -1333,6 +1333,14 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
>   		pmic->current_reg_mode[id] = reg &
>   				PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
>   
> +		pmic->desc[id].enable_reg =
> +				PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
> +					palmas_regs_info[id].ctrl_addr);

This is wrong. Please change palmas_regs_info[id].ctrl_addr to
ddata->palmas_regs_info[id].ctrl_addr. The palmas_regs_info
should come from the driver data for specific instances as the regmap
is different for the different PMICs we support.

Once you make the above changes please feel free to add
Tested-by: Keerthy <j-keerthy@ti.com>.

> +		pmic->desc[id].enable_mask =
> +				PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
> +		/* set_mode overrides this value */
> +		pmic->desc[id].enable_val = SMPS_CTRL_MODE_ON;
> +
>   		pmic->desc[id].type = REGULATOR_VOLTAGE;
>   		pmic->desc[id].owner = THIS_MODULE;
>   

Regards,
Keerthy
