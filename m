Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbaCUKkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:40:33 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:45023 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120AbaCUKkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:40:32 -0400
Date: Fri, 21 Mar 2014 10:40:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] regulator: arizona-ldo1: Move setup processing from
 arizona-core
Message-ID: <20140321104027.GG15213@lee--X1>
References: <1395224338-3709-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1395224338-3709-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395224338-3709-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is more idiomatic to process things relating to the regulator in its
> driver. This patch moves both processing of device tree relating to the
> regulator and checking if the regulator is external from arizona-core
> into the regulator driver.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c       |   12 +++---------
>  drivers/regulator/arizona-ldo1.c |   30 ++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 333621e..c5fe3bb 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -539,7 +539,6 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
>  	int ret, i;
>  
>  	arizona_of_get_named_gpio(arizona, "wlf,reset", true, &pdata->reset);
> -	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true, &pdata->ldoena);
>  
>  	ret = of_property_read_u32_array(arizona->dev->of_node,
>  					 "wlf,gpio-defaults",
> @@ -671,6 +670,9 @@ int arizona_dev_init(struct arizona *arizona)
>  		return -EINVAL;
>  	}
>  
> +	/* Mark DCVDD as external, LDO1 driver will clear if internal */
> +	arizona->external_dcvdd = true;
> +

You don't need to do this, as it's already the default:

include/linux/mfd/arizona/core.h:

struct arizona {
 <snip>
        unsigned int external_dcvdd:1;
 <snip>
};

Also you're adding a bool value to a unsigned int.

Any reason for that?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
