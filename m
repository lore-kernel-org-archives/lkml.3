Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3AXKyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:54:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab3AXKxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:53:47 -0500
Date: Thu, 24 Jan 2013 11:53:43 +0100
From: Michal Marek <mmarek@suse.cz>
To: Alec Bickerton <alec@theangrymob.co.uk>
Cc: linux-kbuild@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add Intel Ivy bridge CPU flags
Message-ID: <20130124105343.GA30701@sepie.suse.cz>
References: <51002135.2060302@theangrymob.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51002135.2060302@theangrymob.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 06:43:17PM +0100, Alec Bickerton wrote:
> Hi,
> 
> I'd like to submit the attached patch to add Ivy Bridge processor support to the
> processor type menu in menuconfig. Setting this configures the appropriate
> CFLAGS (core-avx-i) for ivy bridge.
> 
> As this is my first kbuild patch, could somebody review it and let me know what
> I've done wrong. ;-)

You sent it to linux-kbuild instead of x86@kernel.org. The kbuild
maintainer is not really knowledgeable about gcc optimisation options ;).
Nevertheless, some random comments are below. Note that I am not
saying if the config option is useful or not.

> 
> Thanks
> Alec.

> From 2eaf7717da5b7f753c66e2158d29744aafbc2a0c Mon Sep 17 00:00:00 2001
> From: Alec Bickerton <alec.bickerton@gmail.com>
> Date: Mon, 1 Oct 2012 21:12:55 +0200
> Subject: [PATCH] Added Ivy bridge to menu
> 
> ---
>  arch/x86/Kconfig.cpu          |    5 +++++
>  arch/x86/Makefile             |    5 ++++-
>  arch/x86/Makefile_32.cpu      |    1 +
>  arch/x86/include/asm/module.h |    2 ++
>  4 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> index f3b86d0..e7834c0 100644
> --- a/arch/x86/Kconfig.cpu
> +++ b/arch/x86/Kconfig.cpu
> @@ -267,6 +267,11 @@ config MCORE2
>  	  53xx) CPUs. You can distinguish newer from older Xeons by the CPU
>  	  family in /proc/cpuinfo. Newer ones have 6 and older ones 15
>  	  (not a typo)
> +config MIVYBRIDGE

Keep the options separate by blank lines.

> +    bool "Intel Ivy Bridge"
> +    --help--
> +    
> +      Select this foe Intel 3770K family processors.
>  
>  config MATOM
>  	bool "Intel Atom"
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 474ca35..e945e58 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -61,7 +61,10 @@ else
>          cflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
>  
>          cflags-$(CONFIG_MCORE2) += \
> -                $(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
> +                $(call cc-option,-march=core2,$(call cc-option,-mtune=generic)
> +		)

No need to touch this?


> +        cflags-$(CONFIG_MIVYBRIDGE) += \
> +                $(call cc-option,-march=core-avx-i,$(call cc-option,-mtune=generic))
>  	cflags-$(CONFIG_MATOM) += $(call cc-option,-march=atom) \
>  		$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
>          cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
> diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
> index 86cee7b..f5194ff 100644
> --- a/arch/x86/Makefile_32.cpu
> +++ b/arch/x86/Makefile_32.cpu
> @@ -33,6 +33,7 @@ cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-f
>  cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
>  cflags-$(CONFIG_MVIAC7)		+= -march=i686
>  cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call tune,core2)
> +cflags-$(CONFIG_MIVYBRIDGE)		+= -march=i686 $(call tune,core-avx-i)
>  cflags-$(CONFIG_MATOM)		+= $(call cc-option,-march=atom,$(call cc-option,-march=core2,-march=i686)) \
>  	$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
>  
> diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
> index 9eae775..758a438 100644
> --- a/arch/x86/include/asm/module.h
> +++ b/arch/x86/include/asm/module.h
> @@ -17,6 +17,8 @@
>  #define MODULE_PROC_FAMILY "586MMX "
>  #elif defined CONFIG_MCORE2
>  #define MODULE_PROC_FAMILY "CORE2 "
> +#elif defined CONFIG_MIVYBRIDGE
> +#define MODULE_PROC_FAMILY "IVYBRIDGE"

Missing trailing space.


>  #elif defined CONFIG_MATOM
>  #define MODULE_PROC_FAMILY "ATOM "
>  #elif defined CONFIG_M686
> -- 
> 1.7.10.4
> 

Michal
