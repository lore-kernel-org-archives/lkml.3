Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935078Ab3BNWvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:51:49 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:50134 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934965Ab3BNWvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:51:48 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX180kQLKQGHIO41eaK0nK3pz
Date: Thu, 14 Feb 2013 14:51:43 -0800
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Paul Walmsley <paul@pwsan.com>,
        Sebastien Guiriec <s-guiriec@ti.com>
Subject: Re: [PATCH 3/9] ARM: omap2: include linux/errno.h in hwmod_reset
Message-ID: <20130214225142.GG11362@atomide.com>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
 <1360882071-4072668-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360882071-4072668-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [130214 14:51]:
> The newly created omap_hwmod_reset.c is missing an
> include of linux/errno.h in commit c02060d8 "ARM:
> OMAP4+: AESS: enable internal auto-gating during
> initial setup". It still works in omap2_defconfig,
> but not in all other combinations.
> 
> Without this patch, building allmodconfig results in:
> 
> arch/arm/mach-omap2/omap_hwmod_reset.c: In function 'omap_hwmod_aess_preprogram':
> arch/arm/mach-omap2/omap_hwmod_reset.c:47:11: error: 'EINVAL' undeclared (first use in this function)
> arch/arm/mach-omap2/omap_hwmod_reset.c:47:11: note: each undeclared identifier is reported only once for each function it appears in
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Sebastien Guiriec <s-guiriec@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/mach-omap2/omap_hwmod_reset.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_reset.c b/arch/arm/mach-omap2/omap_hwmod_reset.c
> index bba43fa..65e186c 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_reset.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_reset.c
> @@ -24,6 +24,7 @@
>   * 02110-1301 USA
>   */
>  #include <linux/kernel.h>
> +#include <linux/errno.h>
>  
>  #include <sound/aess.h>
>  
> -- 
> 1.8.1.2
> 
