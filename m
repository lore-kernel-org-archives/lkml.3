Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaDPKNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:13:37 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:36440 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755152AbaDPKNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:13:32 -0400
Date: Wed, 16 Apr 2014 11:12:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Russ Dill <Russ.Dill@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Laura Abbott <lauraa@codeaurora.org>, Jiang Liu <liuj97@gmail.com>,
        Sricharan R <r.sricharan@ti.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
Message-ID: <20140416101243.GA6952@n2100.arm.linux.org.uk>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org> <1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 02:50:05AM -0800, Sebastian Capella wrote:
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index 8756e4b..d32adbb 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -291,6 +291,7 @@ static inline void *phys_to_virt(phys_addr_t x)
>   */
>  #define __pa(x)			__virt_to_phys((unsigned long)(x))
>  #define __va(x)			((void *)__phys_to_virt((phys_addr_t)(x)))
> +#define __pa_symbol(x)		__pa((unsigned long)(x))
>  #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)

I don't see the appropriate version on the mailing list, so I'll comment
here instead.  In 8011/1, you added here:

+#define virt_to_pfn(kaddr)      (__pa(kaddr) >> PAGE_SHIFT)

which conflicts with my solution (which fixes some rather horrid assembly
code).  You can find my change as e26a9e00afc4 (ARM: Better virt_to_page()
handling).  I can drop this from your patch, but it would be a good idea
if you could re-validate against v3.15-rc1.

Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
