Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161027Ab3BGSHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:07:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47149 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab3BGSHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:07:46 -0500
Message-ID: <5113ED43.1060609@ti.com>
Date: Thu, 7 Feb 2013 23:36:59 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Kumar, Anil" <anilkumar.v@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux@arm.linux.org.uk>, <khilman@deeprootsystems.com>, <hs@denx.de>,
        <mporter@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <mchehab@redhat.com>, <vaibhav.bedia@ti.com>, <b-cousson@ti.com>,
        <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>
Subject: Re: [PATCH V2 1/2] ARM: davinci: da850: add wdt DT node
References: <1360123204-9978-1-git-send-email-anilkumar.v@ti.com> <1360123204-9978-2-git-send-email-anilkumar.v@ti.com>
In-Reply-To: <1360123204-9978-2-git-send-email-anilkumar.v@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/2013 9:30 AM, Kumar, Anil wrote:
> Add da850 wdt DT node.
> Add OF_DEV_AUXDATA for wdt driver to use wdt clock.
> 
> Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>

> --- a/arch/arm/mach-davinci/da8xx-dt.c
> +++ b/arch/arm/mach-davinci/da8xx-dt.c
> @@ -37,11 +37,17 @@ static void __init da8xx_init_irq(void)
>  	of_irq_init(da8xx_irq_match);
>  }
>  
> +struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
> +	OF_DEV_AUXDATA("ti,davinci-wdt", 0x01c21000, "watchdog", NULL),
> +	{}
> +};
> +
>  #ifdef CONFIG_ARCH_DAVINCI_DA850
>  
>  static void __init da850_init_machine(void)
>  {
> -	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +	of_platform_populate(NULL, of_default_bus_match_table,
> +			da850_auxdata_lookup, NULL);

These hunks clashed with Manish's I2C0 node addition. I resolved it
locally. I pushed the commit to v3.9/dt-2 branch of my gitorious tree.
Please use this as the baseline for further DT patches.

Thanks,
Sekhar
