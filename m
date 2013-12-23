Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab3LWTJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 14:09:43 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56568 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab3LWTJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 14:09:40 -0500
Message-ID: <52B88A49.9020402@ti.com>
Date: Mon, 23 Dec 2013 13:08:57 -0600
From: "Anna, Suman" <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Florian Vaussard <florian.vaussard@epfl.ch>,
        Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/7] ARM: OMAP2+: Remove legacy data from hwmod for omap3
 isp iommu
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-7-git-send-email-florian.vaussard@epfl.ch>
In-Reply-To: <1387284818-28739-7-git-send-email-florian.vaussard@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On 12/17/2013 06:53 AM, Florian Vaussard wrote:
> The data are now passed using the devicetree.

Patch is good by itself. A similar change is needed for the IVA
MMU as well.

regards
Suman

>
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>   arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 8 --------
>   1 file changed, 8 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> index 0477131..6dccd46 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> @@ -2469,15 +2469,8 @@ static struct omap_hwmod_class omap3xxx_mmu_hwmod_class = {
>
>   /* mmu isp */
>
> -static struct omap_mmu_dev_attr mmu_isp_dev_attr = {
> -	.da_start	= 0x0,
> -	.da_end		= 0xfffff000,
> -	.nr_tlb_entries = 8,
> -};
> -
>   static struct omap_hwmod omap3xxx_mmu_isp_hwmod;
>
> -
>   /* l4_core -> mmu isp */
>   static struct omap_hwmod_ocp_if omap3xxx_l4_core__mmu_isp = {
>   	.master		= &omap3xxx_l4_core_hwmod,
> @@ -2489,7 +2482,6 @@ static struct omap_hwmod omap3xxx_mmu_isp_hwmod = {
>   	.name		= "mmu_isp",
>   	.class		= &omap3xxx_mmu_hwmod_class,
>   	.main_clk	= "cam_ick",
> -	.dev_attr	= &mmu_isp_dev_attr,
>   	.flags		= HWMOD_NO_IDLEST,
>   };
>
>

