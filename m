Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3LOM1D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 07:27:03 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:61713 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab3LOM1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 07:27:01 -0500
MIME-Version: 1.0
In-Reply-To: <1387108841.76039.YahooMailNeo@web140006.mail.bf1.yahoo.com>
References: <1386518000.90452.YahooMailNeo@web140004.mail.bf1.yahoo.com>
	<864985fbeb1d8148439e25ec01f47a67@ixit.cz>
	<52AAFF89.5080509@gmail.com>
	<1387051250.86178.YahooMailNeo@web140005.mail.bf1.yahoo.com>
	<ce679ca5-bf83-4c2a-9234-859cc7a4206b@email.android.com>
	<1387057337.97000.YahooMailNeo@web140004.mail.bf1.yahoo.com>
	<52ACECC4.208@zytor.com>
	<1387108841.76039.YahooMailNeo@web140006.mail.bf1.yahoo.com>
Date: Sun, 15 Dec 2013 13:27:00 +0100
Message-ID: <CAFLxGvxakZS5FFQcZ_ogTd9aUENT3ECj2Lxs+FCbZAiGqgOJ7g@mail.gmail.com>
Subject: Re: [PATCH] expand micro-optimizations in kernel to newer model CPUs
From: Richard Weinberger <richard.weinberger@gmail.com>
To: John <da_audiophile@yahoo.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david.heidelberger@ixit.cz" <david.heidelberger@ixit.cz>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 1:00 PM, John <da_audiophile@yahoo.com> wrote:
> ----- Original Message -----
>
>> From: H. Peter Anvin <hpa@zytor.com>
>> Sent: Saturday, December 14, 2013 6:41 PM
>> Subject: Re: Fw: [PATCH] expand micro-optimizations in kernel to newer model CPUs
>
>>
>> Please submit in the email form requested by the
>> Documentation/SubmittingPatches email; in particular we need the
>> Signed-off-by: statements.
>>
>>
>> ááá -hpa
>>
>
> From: John Audia <da_audiophile@yahoo.com>
>
>
> Signed-off-by: John Audia <da_audiophile@yahoo.com>
>
>
> This patch has been tested on and known to work with kernel versions from 3.2
> up to the latest git version (pulled on 12/14/2013).
>
> This patch will expand the number of microarchitectures to include new
> processors including: AMD K10-family, AMD Family 10h (Barcelona), AMD Family
> 14h (Bobcat), AMD Family 15h (Bulldozer), AMD Family 15h (Piledriver), AMD
> Family 16h (Jaguar), Intel 1st Gen Core i3/i5/i7 (Nehalem), Intel 2nd Gen Core
> i3/i5/i7 (Sandybridge), Intel 3rd Gen Core i3/i5/i7 (Ivybridge), and Intel 4th
> Gen Core i3/i5/i7 (Haswell). It also offers the compiler the 'native' flag.
>
> Small but real speed increases are measurable using a make endpoint comparing
> a generic kernel to one built with one of the respective microarchs.

A *very* small speedup.

And I really doubt your numbers.
Why are you using ANOVA? You're comparing *two* groups not more than two.
I had a quick look at your raw numbers, they don't seem to be normally
distributed at all.
Did you remove some peaks?

> See the following experimental evidence of this statement:
> https://github.com/graysky2/kernel_gcc_patch
>
> ---
> diff -uprN a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
> --- a/arch/x86/include/asm/module.h2013-11-03 18:41:51.000000000 -0500
> +++ b/arch/x86/include/asm/module.h2013-12-15 06:21:24.351122516 -0500
> @@ -15,6 +15,16 @@
> á#define MODULE_PROC_FAMILY "586MMX "
> á#elif defined CONFIG_MCORE2
> á#define MODULE_PROC_FAMILY "CORE2 "
> +#elif defined CONFIG_MNATIVE
> +#define MODULE_PROC_FAMILY "NATIVE "
> +#elif defined CONFIG_MCOREI7
> +#define MODULE_PROC_FAMILY "COREI7 "
> +#elif defined CONFIG_MCOREI7AVX
> +#define MODULE_PROC_FAMILY "COREI7AVX "
> +#elif defined CONFIG_MCOREAVXI
> +#define MODULE_PROC_FAMILY "COREAVXI "
> +#elif defined CONFIG_MCOREAVX2
> +#define MODULE_PROC_FAMILY "COREAVX2 "
> á#elif defined CONFIG_MATOM
> á#define MODULE_PROC_FAMILY "ATOM "
> á#elif defined CONFIG_M686
> @@ -33,6 +43,18 @@
> á#define MODULE_PROC_FAMILY "K7 "
> á#elif defined CONFIG_MK8
> á#define MODULE_PROC_FAMILY "K8 "
> +#elif defined CONFIG_MK10
> +#define MODULE_PROC_FAMILY "K10 "
> +#elif defined CONFIG_MBARCELONA
> +#define MODULE_PROC_FAMILY "BARCELONA "
> +#elif defined CONFIG_MBOBCAT
> +#define MODULE_PROC_FAMILY "BOBCAT "
> +#elif defined CONFIG_MBULLDOZER
> +#define MODULE_PROC_FAMILY "BULLDOZER "
> +#elif defined CONFIG_MPILEDRIVER
> +#define MODULE_PROC_FAMILY "PILEDRIVER "
> +#elif defined CONFIG_MJAGUAR
> +#define MODULE_PROC_FAMILY "JAGUAR "
> á#elif defined CONFIG_MELAN
> á#define MODULE_PROC_FAMILY "ELAN "
> á#elif defined CONFIG_MCRUSOE
> diff -uprN a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> --- a/arch/x86/Kconfig.cpu2013-11-03 18:41:51.000000000 -0500
> +++ b/arch/x86/Kconfig.cpu2013-12-15 06:21:24.351122516 -0500
> @@ -139,7 +139,7 @@ config MPENTIUM4
> á
> á
> áconfig MK6
> -bool "K6/K6-II/K6-III"
> +bool "AMD K6/K6-II/K6-III"
> ádepends on X86_32
> á---help---
> á áSelect this for an AMD K6-family processor. áEnables use of
> @@ -147,7 +147,7 @@ config MK6
> á áflags to GCC.
> á
> áconfig MK7
> -bool "Athlon/Duron/K7"
> +bool "AMD Athlon/Duron/K7"
> ádepends on X86_32
> á---help---
> á áSelect this for an AMD Athlon K7-family processor. áEnables use of
> @@ -155,12 +155,55 @@ config MK7
> á áflags to GCC.
> á
> áconfig MK8
> -bool "Opteron/Athlon64/Hammer/K8"
> +bool "AMD Opteron/Athlon64/Hammer/K8"
> á---help---
> á áSelect this for an AMD Opteron or Athlon64 Hammer-family processor.
> á áEnables use of some extended instructions, and passes appropriate
> á áoptimization flags to GCC.
> á
> +config MK10
> +bool "AMD 61xx/7x50/PhenomX3/X4/II/K10"
> +---help---
> + áSelect this for an AMD 61xx Eight-Core Magny-Cours, Athlon X2 7x50,
> +Phenom X3/X4/II, Athlon II X2/X3/X4, or Turion II-family processor.
> + áEnables use of some extended instructions, and passes appropriate
> + áoptimization flags to GCC.
> +
> +config MBARCELONA
> +bool "AMD Barcelona"
> +---help---
> + áSelect this for AMD Barcelona and newer processors.
> +
> + áEnables -march=barcelona
> +
> +config MBOBCAT
> +bool "AMD Bobcat"
> +---help---
> + áSelect this for AMD Bobcat processors.
> +
> + áEnables -march=btver1
> +
> +config MBULLDOZER
> +bool "AMD Bulldozer"
> +---help---
> + áSelect this for AMD Bulldozer processors.
> +
> + áEnables -march=bdver1
> +
> +config MPILEDRIVER
> +bool "AMD Piledriver"
> +---help---
> + áSelect this for AMD Piledriver processors.
> +
> + áEnables -march=bdver2
> +
> +config MJAGUAR
> +bool "AMD Jaguar"
> +---help---
> + áSelect this for AMD Jaguar processors.
> +
> + áEnables -march=btver2
> +
> áconfig MCRUSOE
> ábool "Crusoe"
> ádepends on X86_32
> @@ -251,8 +294,17 @@ config MPSC
> á áusing the cpu family field
> á áin /proc/cpuinfo. Family 15 is an older Xeon, Family 6 a newer one.
> á
> +config MATOM
> +bool "Intel Atom"
> +---help---
> +
> + áSelect this for the Intel Atom platform. Intel Atom CPUs have an
> + áin-order pipelining architecture and thus can benefit from
> + áaccordingly optimized code. Use a recent GCC with specific Atom
> + ásupport in order to fully benefit from selecting this option.
> +
> áconfig MCORE2
> -bool "Core 2/newer Xeon"
> +bool "Intel Core 2"
> á---help---
> á
> á áSelect this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and
> @@ -260,14 +312,40 @@ config MCORE2
> á áfamily in /proc/cpuinfo. Newer ones have 6 and older ones 15
> á á(not a typo)
> á
> -config MATOM
> -bool "Intel Atom"
> + áEnables -march=core2
> +
> +config MCOREI7
> +bool "Intel Core i7"
> á---help---
> á
> - áSelect this for the Intel Atom platform. Intel Atom CPUs have an
> - áin-order pipelining architecture and thus can benefit from
> - áaccordingly optimized code. Use a recent GCC with specific Atom
> - ásupport in order to fully benefit from selecting this option.
> + áSelect this for the Intel Nehalem platform. Intel Nehalem proecessors
> + áinclude Core i3, i5, i7, Xeon: 34xx, 35xx, 55xx, 56xx, 75xx processors.
> +
> + áEnables -march=corei7
> +
> +config MCOREI7AVX
> +bool "Intel Core 2nd Gen AVX"
> +---help---
> +
> + áSelect this for 2nd Gen Core processors including Sandy Bridge.
> +
> + áEnables -march=corei7-avx
> +
> +config MCOREAVXI
> +bool "Intel Core 3rd Gen AVX"
> +---help---
> +
> + áSelect this for 3rd Gen Core processors including Ivy Bridge.
> +
> + áEnables -march=core-avx-i
> +
> +config MCOREAVX2
> +bool "Intel Core AVX2"
> +---help---
> +
> + áSelect this for AVX2 enabled processors including Haswell.
> +
> + áEnables -march=core-avx2
> á
> áconfig GENERIC_CPU
> ábool "Generic-x86-64"
> @@ -276,6 +354,19 @@ config GENERIC_CPU
> á áGeneric x86-64 CPU.
> á áRun equally well on all x86-64 CPUs.
> á
> +config MNATIVE
> + bool "Native optimizations autodetected by GCC"
> + ---help---
> +
> + á GCC 4.2 and above support -march=native, which automatically detects
> + á the optimum settings to use based on your processor. -march=nativeá
> + á also detects and applies additional settings beyond -march specific
> + á to your CPU, (eg. -msse4). Unless you have a specific reason not to
> + á (e.g. distcc cross-compiling), you should probably be using
> + á -march=native rather than anything listed below.
> +
> + á Enables -march=native
> +
> áendchoice
> á
> áconfig X86_GENERIC
> @@ -300,7 +391,7 @@ config X86_INTERNODE_CACHE_SHIFT
> áconfig X86_L1_CACHE_SHIFT
> áint
> ádefault "7" if MPENTIUM4 || MPSC
> -default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
> +default "6" if MK7 || MK8 || MK10 || MBARCELONA || MBOBCAT || MBULLDOZER || MPILEDRIVER || MJAGUAR || MPENTIUMM || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2 || MATOM || MVIAC7 || X86_GENERIC || MNATIVE || GENERIC_CPU
> ádefault "4" if MELAN || M486 || MGEODEGX1
> ádefault "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
> á
> @@ -331,11 +422,11 @@ config X86_ALIGNMENT_16
> á
> áconfig X86_INTEL_USERCOPY
> ádef_bool y
> -depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2
> +depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || MNATIVE || X86_GENERIC || MK8 || MK7 || MK10 || MBARCELONA || MEFFICEON || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2
> á
> áconfig X86_USE_PPRO_CHECKSUM
> ádef_bool y
> -depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MVIAC7 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
> +depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MK10 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MVIAC7 || MEFFICEON || MGEODE_LX || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2 || MATOM || MNATIVE
> á
> áconfig X86_USE_3DNOW
> ádef_bool y
> @@ -363,17 +454,17 @@ config X86_P6_NOP
> á
> áconfig X86_TSC
> ádef_bool y
> -depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2 || MATOM) && !X86_NUMAQ) || X86_64
> +depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MK10 || MBARCELONA || MBOBCAT || MBULLDOZER || MPILEDRIVER || MJAGUAR || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2 || MCOREI7 || MCOREI7-AVX || MATOM) && !X86_NUMAQ) || X86_64 || MNATIVE
> á
> áconfig X86_CMPXCHG64
> ádef_bool y
> -depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
> +depends on X86_PAE || X86_64 || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM || MNATIVE
> á
> á# this should be set for all -march=.. options where the compiler
> á# generates cmov.
> áconfig X86_CMOV
> ádef_bool y
> -depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM || MGEODE_LX)
> +depends on (MK8 || MK10 || MBARCELONA || MBOBCAT || MBULLDOZER || MPILEDRIVER || MJAGUAR || MK7 || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MNATIVE || MATOM || MGEODE_LX)
> á
> áconfig X86_MINIMUM_CPU_FAMILY
> áint
> diff -uprN a/arch/x86/Makefile b/arch/x86/Makefile
> --- a/arch/x86/Makefile2013-11-03 18:41:51.000000000 -0500
> +++ b/arch/x86/Makefile2013-12-15 06:21:24.354455723 -0500
> @@ -61,11 +61,26 @@ else
> áKBUILD_CFLAGS += $(call cc-option,-mno-sse -mpreferred-stack-boundary=3)
> á
> á á á á á# FIXME - should be integrated in Makefile.cpu (Makefile_32.cpu)
> + á á á ácflags-$(CONFIG_MNATIVE) += $(call cc-option,-march=native)
> á á á á ácflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
> + á á á ácflags-$(CONFIG_MK10) += $(call cc-option,-march=amdfam10)
> + á á á ácflags-$(CONFIG_MBARCELONA) += $(call cc-option,-march=barcelona)
> + á á á ácflags-$(CONFIG_MBOBCAT) += $(call cc-option,-march=btver1)
> + á á á ácflags-$(CONFIG_MBULLDOZER) += $(call cc-option,-march=bdver1)
> + á á á ácflags-$(CONFIG_MPILEDRIVER) += $(call cc-option,-march=bdver2)
> + á á á ácflags-$(CONFIG_MJAGUAR) += $(call cc-option,-march=btver2)
> á á á á ácflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
> á
> á á á á ácflags-$(CONFIG_MCORE2) += \
> - á á á á á á á á$(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
> + á á á á á á á á$(call cc-option,-march=core2,$(call cc-option,-mtune=core2))
> + á á á ácflags-$(CONFIG_MCOREI7) += \
> + á á á á á á á á$(call cc-option,-march=corei7,$(call cc-option,-mtune=corei7))
> + á á á ácflags-$(CONFIG_MCOREI7AVX) += \
> + á á á á á á á á$(call cc-option,-march=corei7-avx,$(call cc-option,-mtune=corei7-avx))
> + á á á ácflags-$(CONFIG_MCOREAVXI) += \
> + á á á á á á á á$(call cc-option,-march=core-avx-i,$(call cc-option,-mtune=core-avx-i))
> + á á á ácflags-$(CONFIG_MCOREAVX2) += \
> + á á á á á á á á$(call cc-option,-march=core-avx2,$(call cc-option,-mtune=core-avx2))
> ácflags-$(CONFIG_MATOM) += $(call cc-option,-march=atom) \
> á$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
> á á á á ácflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
> diff -uprN a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
> --- a/arch/x86/Makefile_32.cpu2013-11-03 18:41:51.000000000 -0500
> +++ b/arch/x86/Makefile_32.cpu2013-12-15 06:21:24.354455723 -0500
> @@ -23,7 +23,14 @@ cflags-$(CONFIG_MK6)+= -march=k6
> á# Please note, that patches that add -march=athlon-xp and friends are pointless.
> á# They make zero difference whatsosever to performance at this time.
> ácflags-$(CONFIG_MK7)+= -march=athlon
> +cflags-$(CONFIG_MNATIVE) += $(call cc-option,-march=native)
> ácflags-$(CONFIG_MK8)+= $(call cc-option,-march=k8,-march=athlon)
> +cflags-$(CONFIG_MK10)+= $(call cc-option,-march=amdfam10,-march=athlon)
> +cflags-$(CONFIG_MBARCELONA)+= $(call cc-option,-march=barcelona,-march=athlon)
> +cflags-$(CONFIG_MBOBCAT)+= $(call cc-option,-march=btver1,-march=athlon)
> +cflags-$(CONFIG_MBULLDOZER)+= $(call cc-option,-march=bdver1,-march=athlon)
> +cflags-$(CONFIG_MPILEDRIVER)+= $(call cc-option,-march=bdver2,-march=athlon)
> +cflags-$(CONFIG_MJAGUAR)+= $(call cc-option,-march=btver2,-march=athlon)
> ácflags-$(CONFIG_MCRUSOE)+= -march=i686 $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
> ácflags-$(CONFIG_MEFFICEON)+= -march=i686 $(call tune,pentium3) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
> ácflags-$(CONFIG_MWINCHIPC6)+= $(call cc-option,-march=winchip-c6,-march=i586)
> @@ -32,6 +39,10 @@ cflags-$(CONFIG_MCYRIXIII)+= $(call cc-
> ácflags-$(CONFIG_MVIAC3_2)+= $(call cc-option,-march=c3-2,-march=i686)
> ácflags-$(CONFIG_MVIAC7)+= -march=i686
> ácflags-$(CONFIG_MCORE2)+= -march=i686 $(call tune,core2)
> +cflags-$(CONFIG_MCOREI7)+= -march=i686 $(call tune,corei7)
> +cflags-$(CONFIG_MCOREI7AVX)+= -march=i686 $(call tune,corei7-avx)
> +cflags-$(CONFIG_MCOREAVXI)+= -march=i686 $(call tune,core-avx-i)
> +cflags-$(CONFIG_MCOREAVX2)+= -march=i686 $(call tune,core-avx2)
> ácflags-$(CONFIG_MATOM)+= $(call cc-option,-march=atom,$(call cc-option,-march=core2,-march=i686)) \
> á$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
