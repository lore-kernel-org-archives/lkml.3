Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3H2LXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:23:16 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:57802 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752618Ab3H2LXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:23:15 -0400
Date: Thu, 29 Aug 2013 12:22:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v5 3/5] ARM64: arch_timer: add support to configure and
 enable event stream
Message-ID: <20130829112239.GE13704@arm.com>
References: <1377686689-30828-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1377686689-30828-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377686689-30828-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:44:47AM +0100, Sudeep KarkadaNagesha wrote:
>  static inline u64 arch_counter_get_cntvct(void)
> diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
> index 6d4482f..530fa879 100644
> --- a/arch/arm64/include/asm/hwcap.h
> +++ b/arch/arm64/include/asm/hwcap.h
> @@ -30,6 +30,7 @@
>  #define COMPAT_HWCAP_IDIVA	(1 << 17)
>  #define COMPAT_HWCAP_IDIVT	(1 << 18)
>  #define COMPAT_HWCAP_IDIV	(COMPAT_HWCAP_IDIVA|COMPAT_HWCAP_IDIVT)
> +#define COMPAT_HWCAP_EVTSTRM	(1 << 21)
>  
>  #ifndef __ASSEMBLY__
>  /*
> @@ -37,11 +38,16 @@
>   * instruction set this cpu supports.
>   */
>  #define ELF_HWCAP		(elf_hwcap)
> -#define COMPAT_ELF_HWCAP	(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
> +#ifdef CONFIG_COMPAT
> +#define COMPAT_ELF_HWCAP	(compat_elf_hwcap)
> +#define COMPAT_ELF_HWCAP_DEFAULT	\
> +				(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
>  				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
>  				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
>  				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
>  				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
> +extern unsigned int compat_elf_hwcap;
> +#endif

I think you can move the default to the setup.c file, it's not of any
use apart from initialisation.

-- 
Catalin
