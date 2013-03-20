Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3CTLYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:24:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38527 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab3CTLYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:24:42 -0400
Message-ID: <51499C72.9030602@ti.com>
Date: Wed, 20 Mar 2013 16:54:34 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>
Subject: Re: [PATCH v2 2/3] arm: davinci: clock node support for ECAP & EHRPWM
References: <1363761714-15034-1-git-send-email-avinashphilip@ti.com> <1363761714-15034-3-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1363761714-15034-3-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/2013 12:11 PM, Philip Avinash wrote:
> Add clock node support for ECAP and EHRPWM modules.
> Also adds TBCLK for EHRWPM TBCLK to comply with pwm-tiehrpwm
> driver.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
> Changes Since v1:
> 	- TBCLK make it as actual clock with enable/disable feature.
> 
> :100644 100644 0c4a26d... dbed75c... M	arch/arm/mach-davinci/da850.c
> :100644 100644 de439b7... be77ce2... M	arch/arm/mach-davinci/include/mach/da8xx.h
>  arch/arm/mach-davinci/da850.c              |   46 ++++++++++++++++++++++++++++
>  arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
>  2 files changed, 47 insertions(+)
> 
> diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
> index 0c4a26d..dbed75c 100644
> --- a/arch/arm/mach-davinci/da850.c
> +++ b/arch/arm/mach-davinci/da850.c
> @@ -383,6 +383,49 @@ static struct clk dsp_clk = {
>  	.flags		= PSC_LRST | PSC_FORCE,
>  };
>  
> +static struct clk ehrpwm_clk = {
> +	.name		= "ehrpwm",
> +	.parent		= &pll0_sysclk2,
> +	.lpsc		= DA8XX_LPSC1_PWM,
> +	.gpsc		= 1,
> +	.flags		= DA850_CLK_ASYNC3,
> +};
> +
> +#define DA8XX_EHRPWM_TBCLKSYNC	BIT(12)
> +
> +void tblck_enable(struct clk *clk)

This should be static. Also, since tbclk is associated with ehrpwm,
please call the function ehrpwm_tbclk_enable().

> +{
> +	u32 val;
> +
> +	val = readl(DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP1_REG));
> +	val |= DA8XX_EHRPWM_TBCLKSYNC;
> +	writel(val, DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP1_REG));
> +}
> +
> +void tblck_disable(struct clk *clk)

Same comment as above applies.

Thanks,
Sekhar
