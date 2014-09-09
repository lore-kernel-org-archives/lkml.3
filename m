Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbaIIABe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:01:34 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27769 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752856AbaIIABc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:01:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18wFmQY7AAVdrq7p0znQp6n
Date: Mon, 8 Sep 2014 17:01:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: twl4030-power: use 'ti,system-power-controller'
 as alternative way to support system power off
Message-ID: <20140909000126.GU3238@atomide.com>
References: <1409771208-21867-1-git-send-email-nm@ti.com>
 <1409771208-21867-3-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409771208-21867-3-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140903 12:07]:
> ti,system-power-controller is more or less the standard way of
> indicating that the PMIC is the system wide power controller and hence
> may be used to switch off the system. Almost ALL TI PMIC drivers and
> many Maxim PMIC drivers follow the same style.
> 
> So support 'ti,system-power-controller' in addition to the usual
> 'ti,use_poweroff' to indicate that the PMIC instance has control for
> switching off the system.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  drivers/mfd/twl4030-power.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> index 3bc969a..1c129ba 100644
> --- a/drivers/mfd/twl4030-power.c
> +++ b/drivers/mfd/twl4030-power.c
> @@ -627,6 +627,9 @@ static bool twl4030_power_use_poweroff(const struct twl4030_power_data *pdata,
>  	if (pdata && pdata->use_poweroff)
>  		return true;
>  
> +	if (of_property_read_bool(node, "ti,system-power-controller"))
> +		return true;
> +
>  	if (of_property_read_bool(node, "ti,use_poweroff"))
>  		return true;
>  
> -- 
> 1.7.9.5
> 
