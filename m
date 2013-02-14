Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314Ab3BNWzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:55:31 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:56658 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759282Ab3BNWza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:55:30 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+dQW3CZP9x1aBtYaeuLnVY
Date: Thu, 14 Feb 2013 14:55:27 -0800
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: Re: [PATCH 4/9] ARM: omap: add include guard for soc.h
Message-ID: <20130214225526.GH11362@atomide.com>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
 <1360882071-4072668-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360882071-4072668-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [130214 14:51]:
> Commit e4c060db "ARM: OMAP: Split plat/cpu.h into local soc.h for
> mach-omap1 and mach-omap2" moved the bulk of "plat/cpu.h" into "cpu.h"
> but did not add an include guard for the new file that was present
> in the old one. There are cases where the file is indeed included
> multiple times, probably by accident, but adding the include
> guard ensures that this has no further consequences.
> 
> Without this patch, building allmodconfig results in lots of warnings like:
> 
> In file included from arch/arm/mach-omap2/drm.c:31:0:
> arch/arm/mach-omap2/soc.h:206:0: warning: "cpu_is_omap24xx" redefined [enabled by default]
> In file included from arch/arm/mach-omap2/drm.c:28:0:
> arch/arm/mach-omap2/soc.h:227:0: note: this is the location of the previous definition
> In file included from arch/arm/mach-omap2/drm.c:31:0:
> arch/arm/mach-omap2/soc.h:207:0: warning: "cpu_is_omap242x" redefined [enabled by default]

I left it out intentionally as these are private to mach-omap2,
and I'd like to simplify the indirect includes there further.
So I'd rather just remove the duplicate soc.h from drm.c.

If people really think this should be applied, I have no
objections to this patch naturally.

Regards,

Tony
 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/soc.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/soc.h b/arch/arm/mach-omap2/soc.h
> index c62116b..97dd373 100644
> --- a/arch/arm/mach-omap2/soc.h
> +++ b/arch/arm/mach-omap2/soc.h
> @@ -24,6 +24,8 @@
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>   *
>   */
> +#ifndef OMAP2_SOC_H
> +#define OMAP2_SOC_H
>  
>  #include "omap24xx.h"
>  #include "omap34xx.h"
> @@ -497,3 +499,4 @@ level(__##fn);
>  
>  #endif	/* __ASSEMBLY__ */
>  
> +#endif
> -- 
> 1.8.1.2
> 
