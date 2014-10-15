Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaJOJHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:07:19 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38675 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaJOJHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:07:16 -0400
Date: Wed, 15 Oct 2014 11:07:12 +0200
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Guenter Roeck <linux@roeck-us.net>, Pavel Machek <pavel@ucw.cz>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 5/8] mfd: ab8500: Use power_supply_*() API for accessing
 function attrs
Message-ID: <20141015090712.GB9900@lee--X1>
References: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
 <1413289246-31650-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413289246-31650-6-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2014, Krzysztof Kozlowski wrote:

> Replace direct calls to power supply function attributes with wrappers.
> Wrappers provide safe access access in case of unregistering the power
> supply (.e.g by removing the driver). Replace:
>  - get_property -> power_supply_get_property
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/ab8500-sysctrl.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
> index 8e0dae59844d..93b2d2c32ca3 100644
> --- a/drivers/mfd/ab8500-sysctrl.c
> +++ b/drivers/mfd/ab8500-sysctrl.c
> @@ -49,7 +49,8 @@ static void ab8500_power_off(void)
>  		if (!psy)
>  			continue;
>  
> -		ret = psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &val);
> +		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
> +				&val);
>  
>  		if (!ret && val.intval) {
>  			charger_present = true;
> @@ -63,8 +64,8 @@ static void ab8500_power_off(void)
>  	/* Check if battery is known */
>  	psy = power_supply_get_by_name("ab8500_btemp");
>  	if (psy) {
> -		ret = psy->get_property(psy, POWER_SUPPLY_PROP_TECHNOLOGY,
> -					&val);
> +		ret = power_supply_get_property(psy,
> +				POWER_SUPPLY_PROP_TECHNOLOGY, &val);
>  		if (!ret && val.intval != POWER_SUPPLY_TECHNOLOGY_UNKNOWN) {
>  			printk(KERN_INFO
>  			       "Charger \"%s\" is connected with known battery."

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
