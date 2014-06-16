Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaFPJWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:22:25 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:38134 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbaFPJWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:22:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/K7Dh/0UvhSWjGUJYf8MX9
Date: Mon, 16 Jun 2014 02:22:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Benoit Cousson <bcousson@baylibre.org>, Paul Walmsley <paul@pwsan.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sathya Prakash M R <sathyap@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [RESEND PATCH 1/2] ARM: AM43xx: hwmod: add DSS hwmod data
Message-ID: <20140616092219.GZ17845@atomide.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com>
 <1402676147-3711-2-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402676147-3711-2-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140613 09:17]:
> From: Sathya Prakash M R <sathyap@ti.com>
> 
> Add DSS hwmod data for AM43xx.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Rajendra Nayak <rnayak@ti.com>
> Signed-off-by: Sathya Prakash M R <sathyap@ti.com>
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
> 
> Note that this patch was originally send on May 9th [1], changes were requested
> and a new version was sent on May 19th [2], then on May 27th [3] Tomi pinged
> maintainer again and go no response.
> 
> Without this patch, we cannot get display working on any AM437x devices.
> 
> [1] http://marc.info/?l=linux-arm-kernel&m=139963677925227&w=2
> [2] http://marc.info/?l=linux-arm-kernel&m=140049799425512&w=2
> [3] http://marc.info/?l=linux-arm-kernel&m=140117232826754&w=2
> 
>  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 98 ++++++++++++++++++++++++++++++
>  arch/arm/mach-omap2/prcm43xx.h             |  1 +
>  2 files changed, 99 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
> index 5c2cc80..d2a7b6d 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
> @@ -19,6 +19,8 @@
>  #include "omap_hwmod.h"
>  #include "omap_hwmod_33xx_43xx_common_data.h"
>  #include "prcm43xx.h"
> +#include "omap_hwmod_common_data.h"
> +
>  
>  /* IP blocks */
>  static struct omap_hwmod am43xx_l4_hs_hwmod = {
> @@ -415,6 +417,70 @@ static struct omap_hwmod am43xx_qspi_hwmod = {
>  	},
>  };
>  
> +/* Display sub system - DSS */
> +
> +struct omap_dss_dispc_dev_attr am43xx_dss_dispc_dev_attr = {
> +	.manager_count		= 1,
> +	.has_framedonetv_irq	= 0
> +};
> +
> +
> +static struct omap_hwmod_class_sysconfig am43xx_dispc_sysc = {
> +	.rev_offs	= 0x0000,
> +	.sysc_offs	= 0x0010,
> +	.syss_offs	= 0x0014,
> +	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE),
> +	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
> +	.sysc_fields	= &omap_hwmod_sysc_type1,
> +};

Looking at the TRM, "Table 13-43. DISPC_SYSCFG Register Field
Descriptions" seems to list the folowing bits available:

13-12	MIDLEMODE 
9-8	CLOCK_ACTIVITY 
4-3	SIDLEMODE 
2	ENWAKEUP 
1	SOFTRESET 
0	AUTOIDLE 

Have I missed something or how come we don't define them all
as available?

The .idlemodes available values and .sysc_fields seems to match
the TRM.

Regards,

Tony
