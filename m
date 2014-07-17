Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaGQHvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:51:17 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:43942 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaGQHvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:51:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1800ZfJLtGE6BpMBV1wuta4
Date: Thu, 17 Jul 2014 00:49:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [Re-send PATCH 1/1] arm: dra7xx: Add hwmod data for MDIO and CPSW
Message-ID: <20140717074948.GF18374@atomide.com>
References: <1404825399-10330-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404825399-10330-1-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mugunthan V N <mugunthanvnm@ti.com> [140708 06:18]:
> Adding hwmod data for CPSW and MDIO which is present in DRA7xx SoC
> 
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
> ---
> 
> This patch was already send twice on 2013-10-18 and 2014-05-13. Adding
> more people in Cc to review the patch.
> 
> ---
>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 65 +++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> index 20b4398..45b5113 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> @@ -273,6 +273,56 @@ static struct omap_hwmod dra7xx_ctrl_module_wkup_hwmod = {
>  };
>  
>  /*
> + * 'gmac' class
> + * cpsw/gmac sub system
> + */
> +static struct omap_hwmod_class_sysconfig dra7xx_gmac_sysc = {
> +	.rev_offs	= 0x0,
> +	.sysc_offs	= 0x8,
> +	.syss_offs	= 0x4,
> +	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE |
> +			   SYSS_HAS_RESET_STATUS),
> +	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | MSTANDBY_FORCE |
> +			   MSTANDBY_NO),
> +	.sysc_fields	= &omap_hwmod_sysc_type3,
> +};

We seem to have this layout WR_SOFT_RESET and WR_CONTROL in the TRM:

WR_SOFT_RESET
[0]     SOFT_RESET

WR_CONTROL
[3:2]   MMR_STDBYMODE   0 = force-idle, 1 = no-standby
[1:0]   MMR_IDLEMODE    0 = force-idle, 1 = no-idle

And so it seems to match what am33xx also has for am33xx_cpgmac_sysc
and am33xx TRM for 14.5.9 CONTROL register. So as far as I'm concerned:

Acked-by: Tony Lindgren <tony@atomide.com>
