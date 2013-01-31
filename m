Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3AaGon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 01:44:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39440 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab3AaGok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 01:44:40 -0500
Date: Thu, 31 Jan 2013 07:44:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [RFC] arm: use built-in byte swap function
Message-ID: <20130131064435.GB4926@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kim Phillips <kim.phillips@freescale.com>,
	"Woodhouse, David" <david.woodhouse@intel.com>,
	Russell King <linux@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Santos <daniel.santos@pobox.com>,
	David Rientjes <rientjes@google.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Rob Herring <robherring2@gmail.com>
References: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
 <20130129083522.GA14302@pd.tnic>
 <1359478014.3529.157.camel@shinybook.infradead.org>
 <20130129174249.GB25415@pd.tnic>
 <1359482147.3529.161.camel@shinybook.infradead.org>
 <20130129181046.GC25415@pd.tnic>
 <1359541333.3529.186.camel@shinybook.infradead.org>
 <20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 08:09:00PM -0600, Kim Phillips wrote:
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 40e2b12..c8798b9 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -141,6 +141,16 @@ config ARCH_USE_BUILTIN_BSWAP
>  	 instructions should set this. And it shouldn't hurt to set it
>  	 on architectures that don't have such instructions.
>  
> +config ARCH_DEFINES_BUILTIN_BSWAP
> +       depends on ARCH_USE_BUILTIN_BSWAP
> +       bool
> +       help
> +	 ARCH selects this when it wants to control HAVE_BUILTIN_BSWAPxx

This is what threw me off: if ARCH selects this, I don't think we want
to have a help text and the option be user visible? Normally such
options are only bool and are selected automatically by hm.. ARCH, as
you say above and do so below. :-)

> +	 definitions over those in the generic compiler headers.  It
> +	 can be dependent on a combination of byte swapping instruction
> +	 availability, the instruction set version, and the state
> +	 of support in different compiler versions.
> +
>  config HAVE_SYSCALL_WRAPPERS
>  	bool
>  
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 73027aa..b5868c2 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -57,6 +57,8 @@ config ARM
>  	select CLONE_BACKWARDS
>  	select OLD_SIGSUSPEND3
>  	select OLD_SIGACTION
> +	select ARCH_USE_BUILTIN_BSWAP
> +	select ARCH_DEFINES_BUILTIN_BSWAP
>  	help

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
