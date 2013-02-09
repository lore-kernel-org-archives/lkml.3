Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab3BIBPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:15:42 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:15222
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932195Ab3BIBPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:15:40 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dI936eI1432I4015Ib922lzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275chz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
Date: Fri, 8 Feb 2013 19:12:08 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Nicolas Pitre <nico@fluxnic.net>
CC: "Woodhouse, David" <david.woodhouse@intel.com>,
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
Subject: Re: [RFC] arm: use built-in byte swap function
Message-ID: <20130208191208.2ef3d78bda71aa7b44d00d7b@freescale.com>
In-Reply-To: <alpine.LFD.2.02.1302081745500.6300@xanadu.home>
References: <20130129181046.GC25415@pd.tnic>
	<1359541333.3529.186.camel@shinybook.infradead.org>
	<20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com>
	<20130131092801.GV23505@n2100.arm.linux.org.uk>
	<20130131145947.f62474a0600848df86548b96@freescale.com>
	<20130201011712.GF23505@n2100.arm.linux.org.uk>
	<1359703995.23531.6.camel@shinybook.infradead.org>
	<20130205210436.670c62e26d2121330e87af35@freescale.com>
	<1360141322.6066.4.camel@shinybook.infradead.org>
	<20130206191905.ac8eb6743e69425f30888704@freescale.com>
	<20130207181315.GM17833@n2100.arm.linux.org.uk>
	<1360344301.6066.263.camel@shinybook.infradead.org>
	<alpine.LFD.2.02.1302081503430.6300@xanadu.home>
	<1360363233.6066.283.camel@shinybook.infradead.org>
	<alpine.LFD.2.02.1302081745500.6300@xanadu.home>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013 17:47:33 -0500
Nicolas Pitre <nico@fluxnic.net> wrote:

> On Fri, 8 Feb 2013, Woodhouse, David wrote:
> 
> > On Fri, 2013-02-08 at 15:04 -0500, Nicolas Pitre wrote:
> > > On Fri, 8 Feb 2013, Woodhouse, David wrote:
> > > 
> > > > On Thu, 2013-02-07 at 18:13 +0000, Russell King - ARM Linux wrote:
> > > > > 
> > > > > However, the biggest reason not to use libgcc is that we want to control
> > > > > what gets used in the kernel - for example, no floating point, and no
> > > > > use of 64 x 64bit division.
> > > > 
> > > > Which is all very sensible. But there's no particular reason we couldn't
> > > > add a __bswap[sd]i2 to the kernel's version of libgcc if we wanted to.
> > > 
> > > Absolutely.
> > 
> > And then ARM can just set ARCH_USE_BUILTIN_BSWAP like other
> > architectures do, right?
> 
> If that turns out to be beneficial over what we have now, then yes.
> I didn't read back the whole thread to form an opinion though.

The diff below implements __bswap[sd]i2 in arch/arm/lib, and
results in the following savings in vmlinux size:

column 1: name of defconfig
column 2: text+data+bss, linux-next-20130207 vanilla, gcc 4.6.3
column 3: text+data+bss, linux-next-20130207+below diff, gcc 4.6.3
column 4: col. 3 - col. 2 (ie., -ve numbers represent savings)

acs5k_tiny_defconfig: 	2886048 	2886016 	-32
ag5evm_defconfig: 	2767596 	2767564 	-32
am200epdkit_defconfig: 	3283557 	3283557 	0
ap4evb_defconfig: 	2059540 	2059524 	-16
armadillo800eva_defconfig: 	4521440 	4521200 	-240
assabet_defconfig: 	3562923 	3562603 	-320
at91_dt_defconfig: 	4195020 	4189164 	-5856
at91rm9200_defconfig: 	5804566 	5803742 	-824
at91sam9261_defconfig: 	4726625 	4725969 	-656
at91sam9263_defconfig: 	5115407 	5114459 	-948
at91sam9g20_defconfig: 	4175306 	4175138 	-168
at91x40_defconfig: 	1344264 	1344256 	-8
badge4_defconfig: 	3359661 	3359485 	-176
bcm_defconfig: 	3575901 	3575757 	-144
bonito_defconfig: 	2221729 	2221681 	-48
cerfcube_defconfig: 	3063610 	3063370 	-240
cns3420vb_defconfig: 	2595667 	2595651 	-16
collie_defconfig: 	3015148 	3014972 	-176
da8xx_omapl_defconfig: 	4168517 	4168165 	-352
davinci_all_defconfig: 	4060434 	4060110 	-324
dove_defconfig: 	4940257 	4939245 	-1012
ebsa110_defconfig: 	3236795 	3236587 	-208
ep93xx_defconfig: 	4169466 	4168986 	-480
eseries_pxa_defconfig: 	3090656 	3090448 	-208
exynos4_defconfig: 	3008671 	3008639 	-32
ezx_defconfig: 	10042035 	10041835 	-200
footbridge_defconfig: 	3662497 	3662369 	-128
h3600_defconfig: 	3471140 	3470820 	-320
h5000_defconfig: 	2976046 	2976030 	-16
h7201_defconfig: 	2158753 	2158705 	-48
h7202_defconfig: 	3395888 	3395520 	-368
hackkit_defconfig: 	3128690 	3128578 	-112
imote2_defconfig: 	9916412 	9916180 	-232
imx_v4_v5_defconfig: 	6866952 	6866272 	-680
imx_v6_v7_defconfig: 	7672373 	7667089 	-5284
integrator_defconfig: 	4224588 	4224284 	-304
iop13xx_defconfig: 	5229604 	5228468 	-1136
iop32x_defconfig: 	5616676 	5615492 	-1184
iop33x_defconfig: 	4611219 	4610835 	-384
ixp4xx_defconfig: 	4566094 	4564238 	-1856
jornada720_defconfig: 	3140569 	3140345 	-224
kota2_defconfig: 	3971280 	3971280 	0
kzm9d_defconfig: 	3042784 	3042784 	0
kzm9g_defconfig: 	4728939 	4728907 	-32
lart_defconfig: 	2941150 	2941054 	-96
lpc32xx_defconfig: 	5009215 	5004619 	-4596
mackerel_defconfig: 	4687162 	4686922 	-240
mini2440_defconfig: 	5095413 	5095037 	-376
msm_defconfig: 	2920312 	2920224 	-88
multi_v7_defconfig: 	3511744 	3511712 	-32
mvebu_defconfig: 	3871035 	3870931 	-104
mxs_defconfig: 	11091983 	11095679 	3696
netwinder_defconfig: 	3814476 	3814124 	-352
nhk8815_defconfig: 	4277138 	4276778 	-360
nuc910_defconfig: 	2527988 	2527956 	-32
nuc950_defconfig: 	2634352 	2634312 	-40
nuc960_defconfig: 	2546592 	2546552 	-40
omap2plus_defconfig: 	13801444 	13800144 	-1300
palmz72_defconfig: 	3345726 	3345758 	32
pcm027_defconfig: 	3634230 	3634158 	-72
pleb_defconfig: 	2847643 	2847515 	-128
prima2_defconfig: 	3080439 	3080347 	-92
pxa3xx_defconfig: 	4266677 	4266457 	-220
realview_defconfig: 	3891673 	3891465 	-208
realview-smp_defconfig: 	4157253 	4157045 	-208
rpc_defconfig: 	3974677 	3974661 	-16
s3c2410_defconfig: 	5217336 	5217000 	-336
s3c6400_defconfig: 	3209178 	3209178 	0
s5p64x0_defconfig: 	2843307 	2843275 	-32
s5pc100_defconfig: 	2696641 	2696657 	16
shannon_defconfig: 	3586908 	3586636 	-272
shark_defconfig: 	3565471 	3565423 	-48
simpad_defconfig: 	3681433 	3681161 	-272
socfpga_defconfig: 	4326480 	4326408 	-72
spear13xx_defconfig: 	4062410 	4062378 	-32
spear6xx_defconfig: 	3457392 	3457360 	-32
tct_hammer_defconfig: 	2406856 	2406824 	-32
trizeps4_defconfig: 	5869063 	5868483 	-580
u300_defconfig: 	2627488 	2627488 	0
versatile_defconfig: 	3789155 	3788787 	-368
vexpress_defconfig: 	5105737 	5105489 	-248
viper_defconfig: 	3309176 	3308920 	-256
xcep_defconfig: 	2820463 	2820367 	-96
zeus_defconfig: 	3775525 	3775367 	-158

gcc 4.7.3 runs haven't been as good across the board as gcc 4.6.3,
however:

acs5k_tiny_defconfig: 	2873380 	2873330 	-50
ag5evm_defconfig: 	2753016 	2753128 	112
am200epdkit_defconfig: 	3274245 	3274295 	50
ap4evb_defconfig: 	2051952 	2051944 	-8
armadillo800eva_defconfig: 	4531864 	4531718 	-146
assabet_defconfig: 	3540515 	3540337 	-178
at91_dt_defconfig: 	4211064 	4205394 	-5670
at91rm9200_defconfig: 	5785930 	5785368 	-562
at91sam9261_defconfig: 	4705357 	4705139 	-218
at91sam9263_defconfig: 	5098831 	5098501 	-330
at91sam9g20_defconfig: 	4163686 	4163576 	-110
at91sam9g45_defconfig: 	4675215 	4669553 	-5662
at91x40_defconfig: 	1342256 	1342192 	-64
badge4_defconfig: 	3338677 	3338615 	-62
bcm_defconfig: 	3568365 	3568259 	-106
bonito_defconfig: 	2225353 	2225355 	2
cerfcube_defconfig: 	3043650 	3043556 	-94
cns3420vb_defconfig: 	2589035 	2589049 	14
collie_defconfig: 	2994100 	2993972 	-128
da8xx_omapl_defconfig: 	4155189 	4155047 	-142
davinci_all_defconfig: 	4043450 	4043304 	-146
dove_defconfig: 	4902213 	4901627 	-586
ebsa110_defconfig: 	3216131 	3215953 	-178
ep93xx_defconfig: 	4154038 	4153796 	-242
eseries_pxa_defconfig: 	3076688 	3076610 	-78
exynos4_defconfig: 	3001451 	3001465 	14
ezx_defconfig: 	10022647 	10022553 	-94
footbridge_defconfig: 	3640857 	3640763 	-94
h3600_defconfig: 	3453932 	3453722 	-210
h5000_defconfig: 	2963034 	2963036 	2
h7201_defconfig: 	2148969 	2148987 	18
h7202_defconfig: 	3376072 	3375894 	-178
hackkit_defconfig: 	3107994 	3107916 	-78
imote2_defconfig: 	9899372 	9899278 	-94
imx_v4_v5_defconfig: 	6834892 	6834338 	-554
imx_v6_v7_defconfig: 	7637605 	7636935 	-670
integrator_defconfig: 	4204944 	4204674 	-270
iop13xx_defconfig: 	5193128 	5192790 	-338
iop32x_defconfig: 	5576144 	5575758 	-386
iop33x_defconfig: 	4584683 	4584585 	-98
ixp4xx_defconfig: 	4546578 	4545176 	-1402
jornada720_defconfig: 	3121377 	3121299 	-78
kota2_defconfig: 	3951220 	3951220 	0
kzm9d_defconfig: 	3055284 	3055252 	-32
kzm9g_defconfig: 	4742195 	4742161 	-34
lart_defconfig: 	2922550 	2926600 	4050
lpc32xx_defconfig: 	5036722 	5032072 	-4650
mackerel_defconfig: 	4660786 	4660612 	-174
mini2440_defconfig: 	5074529 	5074231 	-298
msm_defconfig: 	2911200 	2911240 	40
multi_v7_defconfig: 	3502888 	3502824 	-64
mvebu_defconfig: 	3853083 	3853165 	82
mxs_defconfig: 	11071139 	11070893 	-246
netwinder_defconfig: 	3791108 	3790884 	-224
netx_defconfig: 	3951133 	3950911 	-222
nhk8815_defconfig: 	4259910 	4259696 	-214
nuc910_defconfig: 	2523448 	2523408 	-40
nuc950_defconfig: 	2633644 	2633604 	-40
nuc960_defconfig: 	2541916 	2541876 	-40
omap2plus_defconfig: 	13770376 	13770026 	-350
palmz72_defconfig: 	3335850 	3335868 	18
pcm027_defconfig: 	3615962 	3615896 	-66
pleb_defconfig: 	2828707 	2828753 	46
prima2_defconfig: 	3021195 	3021213 	18
pxa3xx_defconfig: 	4250245 	4250135 	-110
realview_defconfig: 	3874745 	3874791 	46
realview-smp_defconfig: 	4144973 	4145051 	78
rpc_defconfig: 	3952749 	3952831 	82
s3c2410_defconfig: 	5191024 	5195006 	3982
s3c6400_defconfig: 	3208530 	3208548 	18
s5p64x0_defconfig: 	2837611 	2837625 	14
s5pc100_defconfig: 	2689877 	2689895 	18
shannon_defconfig: 	3567412 	3567234 	-178
shark_defconfig: 	3548103 	3548149 	46
simpad_defconfig: 	3657889 	3657763 	-126
socfpga_defconfig: 	4287524 	4287610 	86
spear13xx_defconfig: 	4040898 	4044932 	4034
spear6xx_defconfig: 	3446968 	3446998 	30
tct_hammer_defconfig: 	2394112 	2394126 	14
trizeps4_defconfig: 	5846883 	5846505 	-378
u300_defconfig: 	2622856 	2622934 	78
versatile_defconfig: 	3766635 	3766409 	-226
vexpress_defconfig: 	5076237 	5076279 	42
viper_defconfig: 	3293388 	3293294 	-94
xcep_defconfig: 	2804423 	2808549 	4126
zeus_defconfig: 	3760613 	3760539 	-74

Haven't looked at why.

In any case, some questions I have are:

(a) are the __bswap[sd]i2 implementations acceptable written in C,
as in the diff?  I don't speak ARM asm (yet at least).  The
generated code looks pretty optimal in both armv5 and 6+.

(b) would adding __bswap[sd]i2 to the kernel build need to be
disabled on armv6+? AFAICT, gcc doesn't emit calls - even for the
8-byte swap, even with -Os, on armv6+.

(c) testing allyesconfigs is proving to be a pain - lots of
breakeage - other than defconfig testing, is there any more I can do?

Thanks, and for your patience,

Kim

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4265a26..5e8b735 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -58,6 +58,7 @@ config ARM
 	select CLONE_BACKWARDS
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select ARCH_USE_BUILTIN_BSWAP
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index c9865f6..c225624 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -111,12 +111,12 @@ endif
 
 targets       := vmlinux vmlinux.lds \
 		 piggy.$(suffix_y) piggy.$(suffix_y).o \
-		 lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S \
+		 lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S bswapsdi2.o \
 		 font.o font.c head.o misc.o $(OBJS)
 
 # Make sure files are removed during clean
 extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern \
-		 lib1funcs.S ashldi3.S $(libfdt) $(libfdt_hdrs)
+		 lib1funcs.S ashldi3.S bswapsdi2.o $(libfdt) $(libfdt_hdrs)
 
 ifeq ($(CONFIG_FUNCTION_TRACER),y)
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
@@ -158,6 +158,12 @@ ashldi3 = $(obj)/ashldi3.o
 $(obj)/ashldi3.S: $(srctree)/arch/$(SRCARCH)/lib/ashldi3.S
 	$(call cmd,shipped)
 
+# For __bswapsi2, __bswapdi2
+bswapsdi2 = $(obj)/bswapsdi2.o
+
+$(obj)/bswapsdi2.o: $(srctree)/arch/$(SRCARCH)/lib/bswapsdi2.o
+	$(call cmd,shipped)
+
 # We need to prevent any GOTOFF relocs being used with references
 # to symbols in the .bss section since we cannot relocate them
 # independently from the rest at run time.  This can be achieved by
@@ -179,7 +185,8 @@ if [ $(words $(ZRELADDR)) -gt 1 -a "$(CONFIG_AUTO_ZRELADDR)" = "" ]; then \
 fi
 
 $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.$(suffix_y).o \
-		$(addprefix $(obj)/, $(OBJS)) $(lib1funcs) $(ashldi3) FORCE
+		$(addprefix $(obj)/, $(OBJS)) $(lib1funcs) $(ashldi3) \
+		$(bswapsdi2) FORCE
 	@$(check_for_multiple_zreladdr)
 	$(call if_changed,ld)
 	@$(check_for_bad_syms)
diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index 60d3b73..ba578f7 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -35,6 +35,8 @@ extern void __ucmpdi2(void);
 extern void __udivsi3(void);
 extern void __umodsi3(void);
 extern void __do_div64(void);
+extern void __bswapsi2(void);
+extern void __bswapdi2(void);
 
 extern void __aeabi_idiv(void);
 extern void __aeabi_idivmod(void);
@@ -114,6 +116,8 @@ EXPORT_SYMBOL(__ucmpdi2);
 EXPORT_SYMBOL(__udivsi3);
 EXPORT_SYMBOL(__umodsi3);
 EXPORT_SYMBOL(__do_div64);
+EXPORT_SYMBOL(__bswapsi2);
+EXPORT_SYMBOL(__bswapdi2);
 
 #ifdef CONFIG_AEABI
 EXPORT_SYMBOL(__aeabi_idiv);
diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
index af72969..5383df7 100644
--- a/arch/arm/lib/Makefile
+++ b/arch/arm/lib/Makefile
@@ -13,7 +13,7 @@ lib-y		:= backtrace.o changebit.o csumipv6.o csumpartial.o   \
 		   ashldi3.o ashrdi3.o lshrdi3.o muldi3.o             \
 		   ucmpdi2.o lib1funcs.o div64.o                      \
 		   io-readsb.o io-writesb.o io-readsl.o io-writesl.o  \
-		   call_with_stack.o
+		   call_with_stack.o bswapsdi2.o
 
 mmu-y	:= clear_user.o copy_page.o getuser.o putuser.o
 
diff --git a/arch/arm/lib/bswapsdi2.c b/arch/arm/lib/bswapsdi2.c
new file mode 100644
index 0000000..1923b2f
--- /dev/null
+++ b/arch/arm/lib/bswapsdi2.c
@@ -0,0 +1,19 @@
+unsigned int __bswapsi2(unsigned int x)
+{
+	return ((x & 0x000000ffUL) << 24) |
+	       ((x & 0x0000ff00UL) <<  8) |
+	       ((x & 0x00ff0000UL) >>  8) |
+	       ((x & 0xff000000UL) >> 24);
+}
+
+unsigned long long __bswapdi2(unsigned long long x)
+{
+	return ((x & 0x00000000000000ffULL) << 56) |
+	       ((x & 0x000000000000ff00ULL) << 40) |
+	       ((x & 0x0000000000ff0000ULL) << 24) |
+	       ((x & 0x00000000ff000000ULL) <<  8) |
+	       ((x & 0x000000ff00000000ULL) >>  8) |
+	       ((x & 0x0000ff0000000000ULL) >> 24) |
+	       ((x & 0x00ff000000000000ULL) >> 40) |
+	       ((x & 0xff00000000000000ULL) >> 56);
+}

