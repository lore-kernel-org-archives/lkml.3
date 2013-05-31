Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3EaKno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:43:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62588 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334Ab3EaKnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:43:39 -0400
Date: Fri, 31 May 2013 11:43:03 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH RFC 2/6] arm64/xen: arm/xen header changes to compile on
 arm64
Message-ID: <20130531104303.GB18045@localhost.cambridge.arm.com>
References: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com>
 <1369930713-6063-2-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369930713-6063-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 05:18:29PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/include/asm/xen/events.h |    4 ++++
>  arch/arm/include/asm/xen/page.h   |    2 ++
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/xen/events.h b/arch/arm/include/asm/xen/events.h
> index 8b1f37b..12e4e0b 100644
> --- a/arch/arm/include/asm/xen/events.h
> +++ b/arch/arm/include/asm/xen/events.h
> @@ -13,7 +13,11 @@ enum ipi_vector {
>  
>  static inline int xen_irqs_disabled(struct pt_regs *regs)
>  {
> +#ifdef CONFIG_ARM
>  	return raw_irqs_disabled_flags(regs->ARM_cpsr);
> +#else
> +	return raw_irqs_disabled_flags((unsigned long) regs->pstate);
> +#endif
>  }

At least for this part, it makes sense to live in the arch/arm64
directory.

>  #define xchg_xen_ulong(ptr, val) atomic64_xchg(container_of((ptr),	\
> diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
> index 30cdacb..cb2fa15 100644
> --- a/arch/arm/include/asm/xen/page.h
> +++ b/arch/arm/include/asm/xen/page.h
> @@ -1,7 +1,9 @@
>  #ifndef _ASM_ARM_XEN_PAGE_H
>  #define _ASM_ARM_XEN_PAGE_H
>  
> +#ifdef ARM
>  #include <asm/mach/map.h>
> +#endif
>  #include <asm/page.h>
>  #include <asm/pgtable.h>

Is there anything ARM-specific in this file?

-- 
Catalin
