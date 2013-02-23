Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab3BWCkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 21:40:22 -0500
Received: from relais.videotron.ca ([24.201.245.36]:31622 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3BWCkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 21:40:18 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 22 Feb 2013 21:40:17 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v6] arm: use built-in byte swap function
In-reply-to: <20130222194032.f7b44aefa5e2723d16767a1b@freescale.com>
Message-id: <alpine.LFD.2.03.1302222139170.6419@syhkavp.arg>
References: <20130129181046.GC25415@pd.tnic>
 <alpine.LFD.2.02.1302081745500.6300@xanadu.home>
 <20130208191208.2ef3d78bda71aa7b44d00d7b@freescale.com>
 <alpine.LFD.2.02.1302082102380.6300@xanadu.home>
 <20130219203115.114eab79e8d2099c6306d921@freescale.com>
 <alpine.LFD.2.03.1302192151280.6419@syhkavp.arg>
 <1361356696.13482.269.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302200835380.6419@syhkavp.arg>
 <1361367842.13482.279.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302200905300.6419@syhkavp.arg>
 <1361372008.13482.280.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302201040460.6419@syhkavp.arg>
 <20130220214943.9b28a5b208da9f081387c55e@freescale.com>
 <alpine.LFD.2.03.1302202327370.6419@syhkavp.arg>
 <20130221005221.15279b1372501af12c1e4f32@freescale.com>
 <alpine.LFD.2.03.1302211134160.6419@syhkavp.arg>
 <20130221203327.6558f89277468f7ffffa6506@freescale.com>
 <alpine.LFD.2.03.1302212219100.6419@syhkavp.arg>
 <20130222194032.f7b44aefa5e2723d16767a1b@freescale.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Kim Phillips wrote:

> On Thu, 21 Feb 2013 22:40:08 -0500
> Nicolas Pitre <nico@fluxnic.net> wrote:
> 
> > On Thu, 21 Feb 2013, Kim Phillips wrote:
> > 
> > > Here's the asm version I'm working on now, based on compiler
> > > output of the C version.  Haven't tested beyond defconfig builds,
> > > which pass ok.
> > > 
> > > Is there anything I have to do for thumb mode?  If so, how to test?
> > 
> > You just need to pick a config that uses some ARMv7 processor, and 
> > enable CONFIG_THUMB2_KERNEL.  I don't see any problem with your patch 
> > wrt Thumb2.
> 
> ok, I've addressed your comments and tested both pre-armv6 and armv6
> + bswapsi2s on i.mx hardware with CONFIG_CC_OPTIMIZE_FOR_SIZE and
> CONFIG_THUMB2_KERNEL set:
> 
> >From c22f4050174d8da71fdddba2cf67ae40c00ca5cc Mon Sep 17 00:00:00 2001
> From: Kim Phillips <kim.phillips@freescale.com>
> Date: Tue, 19 Feb 2013 17:16:11 -0600
> Subject: [PATCH] arm: use built-in byte swap function
> 
> Enable the compiler intrinsic for byte swapping on arch ARM.  This
> allows the compiler to detect and be able to optimize out byte
> swappings, and has a tiny benefit on vmlinux size (Linaro gcc 4.7.3):
> 
>    text	   data	    bss	    dec	    hex	filename
> 2754100	 121144	  56520	2931764	 2cbc34	vmlinux-lart #orig
> 2754050	 121144	  56520	2931714	 2cbc02	vmlinux-lart #builtin-bswap
> 6282699	 307852	5578076	12168627 b9adb3	vmlinux-mxs #orig
> 6282241	 307832	5578076	12168149 b9abd5	vmlinux-mxs #builtin-bswap
> 7200193	 364180	 361748	7926121	 78f169	vmlinux-imx_v6_v7 #orig
> 7199515	 364188	 361748	7925451	 78eecb	vmlinux-imx_v6_v7 #builtin-bswap
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Reviewed-by: Nicolas Pitre <nico@linaro.org>


> ---
> akin to: http://comments.gmane.org/gmane.linux.kernel.cross-arch/16016
> 
> based on linux-next-20130221.
> 
> changes from last diff:
> - addressed Nicolas' comments
> - updated commit text figures and reformatted as a patch
> 
> changes from diff before that:
> - 1st asm version
> 
> changes from diff before that:
> - enforce -O2 for bswapsdi2.o
> - fix building out-of-source tree
> 
> changes from diff before that:
> - implement custom __bswap[sd]i2 in arch/arm/lib/bswapsdi2.c
> 
> v5: re-work based on new gcc version test data:
>   - moved outside armv6 protection
>   - check for gcc 4.6+ demoted to gcc 4.5+ with:
>     !defined(CONFIG_CC_OPTIMIZE_FOR_SIZE)
> 
> v4:
> - undo v2-2's addition of ARCH_DEFINES_BUILTIN_BSWAP per Boris
>   and David - object is to find arches that define _HAVE_BSWAP
>   and clean it up in the future: patch is much less intrusive. :)
> 
> v3:
> - moved out of uapi swab.h into arch/arm/include/asm/swab.h
> - moved ARCH_DEFINES_BUILTIN_BSWAP help text into commit message
> - moved GCC_VERSION >= 40800 ifdef into GCC_VERSION >= 40600 block
> 
> v2:
> - at91 and lpd270 builds fixed by limiting to ARMv6 and above
>   (i.e., ARM cores that have support for the 'rev' instruction).
>   Otherwise, the compiler emits calls to libgcc's __bswapsi2 on
>   these ARMv4/v5 builds (and arch ARM doesn't link with libgcc).
>   All ARM defconfigs now have the same build status as they did
>   without this patch (some are broken on linux-next).
> 
> - move ARM check from generic compiler.h to arch ARM's swab.h.
>   - pretty sure it should be limited to __KERNEL__ builds
> 
> - add new ARCH_DEFINES_BUILTIN_BSWAP (see Kconfig help).
>   - if set, generic compiler header does not set HAVE_BUILTIN_BSWAPxx
>   - not too sure about this having to be a new CONFIG_, but it's hard
>     to find a place for it given linux/compiler.h doesn't include any
>     arch-specific files.
> 
> - move new selects to end of CONFIG_ARM's Kconfig select list,
>   as is done in David Woodhouse's original patchseries for ppc/x86.
> 
>  arch/arm/Kconfig                  |  1 +
>  arch/arm/boot/compressed/Makefile | 15 +++++++++++----
>  arch/arm/kernel/armksyms.c        |  4 ++++
>  arch/arm/lib/Makefile             |  2 +-
>  arch/arm/lib/bswapsdi2.S          | 36 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 53 insertions(+), 5 deletions(-)
>  create mode 100644 arch/arm/lib/bswapsdi2.S
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index dedf02b..e8a41d0 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -59,6 +59,7 @@ config ARM
>  	select CLONE_BACKWARDS
>  	select OLD_SIGSUSPEND3
>  	select OLD_SIGACTION
> +	select ARCH_USE_BUILTIN_BSWAP
>  	help
>  	  The ARM series is a line of low-power-consumption RISC chip designs
>  	  licensed by ARM Ltd and targeted at embedded applications and
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index 5cad8a6..d9b5ee5 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -108,12 +108,12 @@ endif
>  
>  targets       := vmlinux vmlinux.lds \
>  		 piggy.$(suffix_y) piggy.$(suffix_y).o \
> -		 lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S \
> -		 font.o font.c head.o misc.o $(OBJS)
> +		 lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S bswapsdi2.o \
> +		 bswapsdi2.S font.o font.c head.o misc.o $(OBJS)
>  
>  # Make sure files are removed during clean
>  extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern \
> -		 lib1funcs.S ashldi3.S $(libfdt) $(libfdt_hdrs)
> +		 lib1funcs.S ashldi3.S bswapsdi2.S $(libfdt) $(libfdt_hdrs)
>  
>  ifeq ($(CONFIG_FUNCTION_TRACER),y)
>  ORIG_CFLAGS := $(KBUILD_CFLAGS)
> @@ -155,6 +155,12 @@ ashldi3 = $(obj)/ashldi3.o
>  $(obj)/ashldi3.S: $(srctree)/arch/$(SRCARCH)/lib/ashldi3.S
>  	$(call cmd,shipped)
>  
> +# For __bswapsi2, __bswapdi2
> +bswapsdi2 = $(obj)/bswapsdi2.o
> +
> +$(obj)/bswapsdi2.S: $(srctree)/arch/$(SRCARCH)/lib/bswapsdi2.S
> +	$(call cmd,shipped)
> +
>  # We need to prevent any GOTOFF relocs being used with references
>  # to symbols in the .bss section since we cannot relocate them
>  # independently from the rest at run time.  This can be achieved by
> @@ -176,7 +182,8 @@ if [ $(words $(ZRELADDR)) -gt 1 -a "$(CONFIG_AUTO_ZRELADDR)" = "" ]; then \
>  fi
>  
>  $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.$(suffix_y).o \
> -		$(addprefix $(obj)/, $(OBJS)) $(lib1funcs) $(ashldi3) FORCE
> +		$(addprefix $(obj)/, $(OBJS)) $(lib1funcs) $(ashldi3) \
> +		$(bswapsdi2) FORCE
>  	@$(check_for_multiple_zreladdr)
>  	$(call if_changed,ld)
>  	@$(check_for_bad_syms)
> diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
> index 60d3b73..ba578f7 100644
> --- a/arch/arm/kernel/armksyms.c
> +++ b/arch/arm/kernel/armksyms.c
> @@ -35,6 +35,8 @@ extern void __ucmpdi2(void);
>  extern void __udivsi3(void);
>  extern void __umodsi3(void);
>  extern void __do_div64(void);
> +extern void __bswapsi2(void);
> +extern void __bswapdi2(void);
>  
>  extern void __aeabi_idiv(void);
>  extern void __aeabi_idivmod(void);
> @@ -114,6 +116,8 @@ EXPORT_SYMBOL(__ucmpdi2);
>  EXPORT_SYMBOL(__udivsi3);
>  EXPORT_SYMBOL(__umodsi3);
>  EXPORT_SYMBOL(__do_div64);
> +EXPORT_SYMBOL(__bswapsi2);
> +EXPORT_SYMBOL(__bswapdi2);
>  
>  #ifdef CONFIG_AEABI
>  EXPORT_SYMBOL(__aeabi_idiv);
> diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
> index af72969..5383df7 100644
> --- a/arch/arm/lib/Makefile
> +++ b/arch/arm/lib/Makefile
> @@ -13,7 +13,7 @@ lib-y		:= backtrace.o changebit.o csumipv6.o csumpartial.o   \
>  		   ashldi3.o ashrdi3.o lshrdi3.o muldi3.o             \
>  		   ucmpdi2.o lib1funcs.o div64.o                      \
>  		   io-readsb.o io-writesb.o io-readsl.o io-writesl.o  \
> -		   call_with_stack.o
> +		   call_with_stack.o bswapsdi2.o
>  
>  mmu-y	:= clear_user.o copy_page.o getuser.o putuser.o
>  
> diff --git a/arch/arm/lib/bswapsdi2.S b/arch/arm/lib/bswapsdi2.S
> new file mode 100644
> index 0000000..2ba43a0
> --- /dev/null
> +++ b/arch/arm/lib/bswapsdi2.S
> @@ -0,0 +1,36 @@
> +#include <linux/linkage.h>
> +
> +#if __LINUX_ARM_ARCH__ >= 6
> +ENTRY(__bswapsi2)
> +	rev	r0, r0
> +	bx	lr
> +ENDPROC(__bswapsi2)
> +
> +ENTRY(__bswapdi2)
> +	rev	r3, r0
> +	rev	r0, r1
> +	mov	r1, r3
> +	bx	lr
> +ENDPROC(__bswapdi2)
> +#else
> +ENTRY(__bswapsi2)
> +	eor     r3, r0, r0, ror #16
> +	mov     r3, r3, lsr #8
> +	bic     r3, r3, #0xff00
> +	eor     r0, r3, r0, ror #8
> +	mov     pc, lr
> +ENDPROC(__bswapsi2)
> +
> +ENTRY(__bswapdi2)
> +	mov     ip, r1
> +	eor     r3, ip, ip, ror #16
> +	eor     r1, r0, r0, ror #16
> +	mov     r1, r1, lsr #8
> +	mov     r3, r3, lsr #8
> +	bic     r3, r3, #0xff00
> +	bic     r1, r1, #0xff00
> +	eor     r1, r1, r0, ror #8
> +	eor     r0, r3, ip, ror #8
> +	mov     pc, lr
> +ENDPROC(__bswapdi2)
> +#endif
> -- 
> 1.8.1.4
> 
> 
