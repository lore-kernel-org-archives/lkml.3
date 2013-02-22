Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3BVDFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 22:05:01 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:15975 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504Ab3BVDE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 22:04:59 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dI936eI1432I4015Ib922lzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275ch8275dhz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
Date: Thu, 21 Feb 2013 20:33:27 -0600
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
Message-ID: <20130221203327.6558f89277468f7ffffa6506@freescale.com>
In-Reply-To: <alpine.LFD.2.03.1302211134160.6419@syhkavp.arg>
References: <20130129181046.GC25415@pd.tnic>
	<1360344301.6066.263.camel@shinybook.infradead.org>
	<alpine.LFD.2.02.1302081503430.6300@xanadu.home>
	<1360363233.6066.283.camel@shinybook.infradead.org>
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
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013 11:40:54 -0500
Nicolas Pitre <nico@fluxnic.net> wrote:

> On Thu, 21 Feb 2013, Kim Phillips wrote:
> 
> > On Wed, 20 Feb 2013 23:29:58 -0500
> > Nicolas Pitre <nico@fluxnic.net> wrote:
> > 
> > > On Wed, 20 Feb 2013, Kim Phillips wrote:
> > > 
> > > > On Wed, 20 Feb 2013 10:43:18 -0500
> > > > Nicolas Pitre <nico@fluxnic.net> wrote:
> > > > 
> > > > > On Wed, 20 Feb 2013, Woodhouse, David wrote:
> > > > > > On Wed, 2013-02-20 at 09:06 -0500, Nicolas Pitre wrote:
> > > > > > > ... in which case there is no harm shipping a .c file and trivially 
> > > > > > > enforcing -O2, the rest being equal.
> > > > > > 
> > > > > > For today's compilers, unless the wind changes.
> > > > > 
> > > > > We'll adapt if necessary.  Going with -O2 should remain pretty safe anyway.
> > > > 
> > > > Alas, not so for gcc 4.4 - I had forgotten I had tested
> > > > Ubuntu/Linaro 4.4.7-1ubuntu2 here:
> > > > 
> > > > https://patchwork.kernel.org/patch/2101491/
> > > > 
> > > > add -O2 to that test script and gcc 4.4 *always* emits calls to
> > > > __bswap[sd]i2, even with -march=armv6k+.
> > 
> > argh, sorry - that script was testing support for 
> > __builtin_bswap{16,32,64} directly, which isn't the same as testing
> > code generation of a byte swap pattern in C.
> 
> Still, I'm not as confident as I was about this.

which part exactly?  Having -O2 as "protection"?  Yes, me neither.

> > I'll still try the assembly approach - gcc 4.4's armv6 output looks
> > worse than both the pre-armv6 and post-armv6 __arch_swab32
> > implementations currently in use:
> > 
> > mov     ip, sp
> > push    {fp, ip, lr, pc}
> > sub     fp, ip, #4
> 
> You should use -fomit-frame-pointer to compile this.  We don't need a 
> frame pointer here, especially for a leaf function that the compiler 
> decides to call on its own.
> 
> > and     r2, r0, #65280  ; 0xff00
> > lsl     ip, r0, #24
> > orr     r1, ip, r0, lsr #24
> > and     r0, r0, #16711680       ; 0xff0000
> > orr     r3, r1, r2, lsl #8
> > orr     r0, r3, r0, lsr #8
> 
> Other than that, it is true that the above is slightly suboptimal.

Here's the asm version I'm working on now, based on compiler
output of the C version.  Haven't tested beyond defconfig builds,
which pass ok.

Is there anything I have to do for thumb mode?  If so, how to test?

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index dedf02b..e8a41d0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -59,6 +59,7 @@ config ARM
 	select CLONE_BACKWARDS
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select ARCH_USE_BUILTIN_BSWAP
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 5cad8a6..a277e97 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -108,12 +108,12 @@ endif
 
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
@@ -155,6 +155,12 @@ ashldi3 = $(obj)/ashldi3.o
 $(obj)/ashldi3.S: $(srctree)/arch/$(SRCARCH)/lib/ashldi3.S
 	$(call cmd,shipped)
 
+# For __bswapsi2, __bswapdi2
+bswapsdi2 = $(obj)/bswapsdi2.o
+
+$(obj)/bswapsdi2.S: $(srctree)/arch/$(SRCARCH)/lib/bswapsdi2.S
+	$(call cmd,shipped)
+
 # We need to prevent any GOTOFF relocs being used with references
 # to symbols in the .bss section since we cannot relocate them
 # independently from the rest at run time.  This can be achieved by
@@ -176,7 +182,8 @@ if [ $(words $(ZRELADDR)) -gt 1 -a "$(CONFIG_AUTO_ZRELADDR)" = "" ]; then \
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
 
diff --git a/arch/arm/lib/bswapsdi2.S b/arch/arm/lib/bswapsdi2.S
new file mode 100644
index 0000000..e9c8ca7
--- /dev/null
+++ b/arch/arm/lib/bswapsdi2.S
@@ -0,0 +1,36 @@
+#include <linux/linkage.h>
+
+#if __LINUX_ARM_ARCH__ >= 6
+ENTRY(__bswapsi2)
+	rev	r0, r0
+	bx	lr
+ENDPROC(__bswapsi2)
+
+ENTRY(__bswapdi2)
+	rev	r3, r0
+	rev	r0, r1
+	mov	r1, r3
+	bx	lr
+ENDPROC(__bswapdi2)
+#else
+ENTRY(__bswapsi2)
+	eor     r3, r0, r0, ror #16
+	lsr     r3, r3, #8
+	bic     r3, r3, #65280  @ 0xff00
+	eor     r0, r3, r0, ror #8
+	mov     pc, lr
+ENDPROC(__bswapsi2)
+
+ENTRY(__bswapdi2)
+	mov     ip, r1
+	eor     r3, ip, ip, ror #16
+	eor     r1, r0, r0, ror #16
+	lsr     r1, r1, #8
+	lsr     r3, r3, #8
+	bic     r3, r3, #65280  @ 0xff00
+	bic     r1, r1, #65280  @ 0xff00
+	eor     r1, r1, r0, ror #8
+	eor     r0, r3, ip, ror #8
+	mov     pc, lr
+ENDPROC(__bswapdi2)
+#endif

Thanks,

Kim

