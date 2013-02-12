Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3BLFrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 00:47:06 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36058 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3BLFrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 00:47:03 -0500
Message-ID: <5119D72D.3010605@ti.com>
Date: Tue, 12 Feb 2013 11:16:21 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: <linux-mmc@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <hs@denx.de>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <cjb@laptop.org>, <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ARM: davinci: da850: override mmc DT node device
 name
References: <1360223825-23929-1-git-send-email-prakash.pm@ti.com> <1360223825-23929-2-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1360223825-23929-2-git-send-email-prakash.pm@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/2013 1:27 PM, Manjunathappa, Prakash wrote:
> Populate OF_DEV_AUXDATA with desired device name expected by
> davinci_mmc driver. Without this clk_get of davinci_mmc DT driver
> fails.

But there is no mmc DT support for DaVinci at this time. This patch
should come after the driver DT support and .dts addition patches.

> diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
> index 37c27af..3362ca4 100644
> --- a/arch/arm/mach-davinci/da8xx-dt.c
> +++ b/arch/arm/mach-davinci/da8xx-dt.c
> @@ -39,9 +39,16 @@ static void __init da8xx_init_irq(void)
>  
>  #ifdef CONFIG_ARCH_DAVINCI_DA850
>  
> +static const struct of_dev_auxdata da8xx_auxdata[] __initconst = {
> +	OF_DEV_AUXDATA("ti,davinci-mmc-da830", 0x01c40000, "davinci_mmc.0",
> +			NULL),
> +	{},
> +};
> +
>  static void __init da850_init_machine(void)
>  {
> -	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +	of_platform_populate(NULL, of_default_bus_match_table, da8xx_auxdata,
> +			NULL);

This needs to be rebased on by v3.9/dt-2 branch. There are conflicts
with the code already present.

Thanks,
Sekhar
