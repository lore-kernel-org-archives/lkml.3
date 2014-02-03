Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaBCK32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:29:28 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:39198 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaBCK31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:29:27 -0500
Date: Mon, 3 Feb 2014 10:29:19 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Anthony Olech <anthony.olech.opensource@diasemi.com>" 
	<Anthony.Olech.OpenSource@diasemi.com>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V1] fix da9052 volatile register definition ommissions
Message-ID: <20140203102919.GP13529@lee--X1>
References: <201401281723.s0SHNmLa041140@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201401281723.s0SHNmLa041140@swsrvapps-02.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Three of the PMIC registers have some bits that are changed
> autonomously by the PMIC itself (some time) after being set
> by some component driver of the DA9052 PMIC and hence they
> need to be marked as volatile so that the regmap API will
> not cache their values.
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Signed-off-by: David Dajun Chen <david.chen@diasemi.com>

These are not correct.

Who authored the patch?

> ---
> This patch is relative to linux-next repository tag next-20140128
> 
> The bug that this patch fixes affects two components of DA9052 namely:
> 
> WATCHDOG - the first kick will work but sebsequent ones will not
>            thus the will timeout at 2 x interval.
> 
> REGULATORS - the first change to any DA9052 BUCK voltage will be
>              actioned, but sebsequent ones will not.

Which patch caused the bug?

>  drivers/mfd/da9052-core.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
> index 25838f1..e8af816 100644
> --- a/drivers/mfd/da9052-core.c
> +++ b/drivers/mfd/da9052-core.c
> @@ -279,6 +279,9 @@ static bool da9052_reg_volatile(struct device *dev, unsigned int reg)
>  	case DA9052_EVENT_B_REG:
>  	case DA9052_EVENT_C_REG:
>  	case DA9052_EVENT_D_REG:
> +	case DA9052_CONTROL_B_REG:
> +	case DA9052_CONTROL_D_REG:
> +	case DA9052_SUPPLY_REG:
>  	case DA9052_FAULTLOG_REG:
>  	case DA9052_CHG_TIME_REG:
>  	case DA9052_ADC_RES_L_REG:

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
