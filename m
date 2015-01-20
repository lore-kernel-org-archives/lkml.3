Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbbATHTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:19:16 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:54720 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbATHSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:18:22 -0500
Date: Tue, 20 Jan 2015 07:18:19 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>, bparrot@ti.com,
        detheridge@ti.com, balbi@ti.com
cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, devicetree@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        OMAP <linux-omap@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] ARM: AM43xx: hwmod: add VPFE hwmod entries
In-Reply-To: <1418919854-16164-2-git-send-email-prabhakar.csengg@gmail.com>
Message-ID: <alpine.DEB.2.02.1501200709440.5450@utopia.booyaka.com>
References: <1418919854-16164-1-git-send-email-prabhakar.csengg@gmail.com> <1418919854-16164-2-git-send-email-prabhakar.csengg@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, 18 Dec 2014, Lad, Prabhakar wrote:

> From: Benoit Parrot <bparrot@ti.com>
> 
> this patch adds VPFE HWMOD data for AM43xx.
> 
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Darren Etheridge <detheridge@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

...

> ---
>  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 56 ++++++++++++++++++++++++++++++
>  arch/arm/mach-omap2/prcm43xx.h             |  3 +-
>  2 files changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
> index fea01aa..bd9067e 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c

...

> @@ -750,6 +788,22 @@ static struct omap_hwmod_ocp_if am43xx_l4_ls__dss_rfbi = {
>  	.user		= OCP_USER_MPU | OCP_USER_SDMA,
>  };
>  
> +static struct omap_hwmod_ocp_if am43xx_l3__vpfe0 = {
> +	.master         = &am33xx_l3_main_hwmod,
> +	.slave          = &am43xx_vpfe0_hwmod,
> +	.clk            = "l3_gclk",
> +	.flags          = OCPIF_SWSUP_IDLE,
> +	.user           = OCP_USER_MPU,
> +};
> +
> +static struct omap_hwmod_ocp_if am43xx_l3__vpfe1 = {
> +	.master         = &am33xx_l3_main_hwmod,
> +	.slave          = &am43xx_vpfe1_hwmod,
> +	.clk            = "l3_gclk",
> +	.flags          = OCPIF_SWSUP_IDLE,
> +	.user           = OCP_USER_MPU,
> +};
> +
>  static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
>  	&am33xx_l4_wkup__synctimer,
>  	&am43xx_l4_ls__timer8,
> @@ -848,6 +902,8 @@ static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
>  	&am43xx_l4_ls__dss,
>  	&am43xx_l4_ls__dss_dispc,
>  	&am43xx_l4_ls__dss_rfbi,
> +	&am43xx_l3__vpfe0,
> +	&am43xx_l3__vpfe1,
>  	NULL,
>  };

According to SPRUHL7 Figure 14-1 "VPFE Integration" and Table 14-2 "VPFE 
Connectivity Attributes", a VPFE has two interconnect ports per instance: 
one L4-Per port as a register target, and one L3 port as a DMA initiator.  
It's unclear to me whether the L3 port can also serve as a register 
target, but Section 2.1 "ARM Cortex-A9 Memory Map", Table 4-1 "L3 
Master-Slave Connectivity", and Figure 4-2 "L4 Topology" suggest that it 
cannot.

So if that's correct, there should be two more struct omap_hwmod_ocp_if 
records added in this patch for the register target ports that are 
connected to the L4.  DSS is a good example: see am43xx_dss__l3_main and 
am43xx_l4_ls__dss in this same file.


- Paul
