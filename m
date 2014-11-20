Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbaKTHJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:09:55 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:59435 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaKTHJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:09:52 -0500
Date: Thu, 20 Nov 2014 07:09:51 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Vignesh R <vigneshr@ti.com>
cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ARM: OMAP2+: hwmod: AM335x/AM43x: add hwmod
 support for tscadc on am43x-evm
In-Reply-To: <1415099728-10959-3-git-send-email-vigneshr@ti.com>
Message-ID: <alpine.DEB.2.02.1411200706441.9204@utopia.booyaka.com>
References: <1415099728-10959-1-git-send-email-vigneshr@ti.com> <1415099728-10959-3-git-send-email-vigneshr@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014, Vignesh R wrote:

> This patch adds hwmod support for tscadc to work on am43xx-evm. The am33xx
> hwmod structures of tscadc has been moved to ipblock_data so that it can
> be reused in am43xx. The clock domain names are separately set for am33xx
> and am43xx. Thus tscadc dt entries can now be added to am43xx board
> dt files.
> 
> Signed-off-by: Vignesh R <vigneshr@ti.com>

...

> diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h
> index 6e57b8ad0db5..b92a7c7825fa 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h
> +++ b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h

...

> +static void am33xx_hwmod_clockdomain(void)
> +{
> +	CLKDMNAME(am33xx_l4_hs_hwmod, "l4hs_clkdm");
> +	CLKDMNAME(am33xx_adc_tsc_hwmod, "l4_wkup_clkdm");
> +}
> +
> +static void am43xx_hwmod_clockdomain(void)
> +{
> +	CLKDMNAME(am33xx_l4_hs_hwmod, "l3_clkdm");
> +	CLKDMNAME(am33xx_adc_tsc_hwmod, "l3s_tsc_clkdm");
> +}
> +

...

> +	am33xx_hwmod_clockdomain();

I looked at this patch and the one before it.  Is there some reason why we 
need to share these two hwmods between AM33xx and AM43xx?  It seems 
cleaner just to add the ADC data directly to the AM43xx hwmod data file, 
not touch the AM33xx data, and not add another runtime data update for the 
clockdomains.  Unless there's something that I'm missing?


- Paul
