Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbbATNgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:36:44 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63622 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbATNgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:36:41 -0500
Date: Tue, 20 Jan 2015 13:36:34 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCHv2 18/19] mfd: ab8500: Decrement the power supply's
 device reference counter
Message-ID: <20150120133634.GH13701@x1>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
 <1420472882-10463-19-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420472882-10463-19-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2015, Krzysztof Kozlowski wrote:

> Use power_supply_put() to decrement the power supply's device reference
> counter.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>

You've sent this to me already Acked.  I don't see 00/00, so I have no
idea what's going on.  Do you want me to take this patch?  Can it be
taking on its own?

> ---
>  drivers/mfd/ab8500-sysctrl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
> index d4a4b24be7c6..0d1825696153 100644
> --- a/drivers/mfd/ab8500-sysctrl.c
> +++ b/drivers/mfd/ab8500-sysctrl.c
> @@ -51,6 +51,7 @@ static void ab8500_power_off(void)
>  
>  		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
>  				&val);
> +		power_supply_put(psy);
>  
>  		if (!ret && val.intval) {
>  			charger_present = true;
> @@ -73,6 +74,7 @@ static void ab8500_power_off(void)
>  			       pss[i]);
>  			machine_restart("charging");
>  		}
> +		power_supply_put(psy);
>  	}
>  
>  shutdown:

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
