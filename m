Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3EaPEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:04:01 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:37365
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538Ab3EaPDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:03:55 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
X-WSS-ID: 0MNO4GJ-01-0JU-02
X-M-MSG: 
Date: Fri, 31 May 2013 10:02:41 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <mingo@kernel.org>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <fenghua.yu@intel.com>, <tglx@linutronix.de>, <hpa@linux.intel.com>,
        <linux-tip-commits@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [tip:x86/microcode] x86, microcode, amd: Early microcode patch
 loading support for AMD
Message-ID: <20130531150241.GA12006@jshin-Toonie>
References: <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
 <tip-757885e94a22bcc82beb9b1445c95218cb20ceab@git.kernel.org>
 <20130531084133.GA14076@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130531084133.GA14076@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:41:33AM +0200, Borislav Petkov wrote:
> On Thu, May 30, 2013 at 08:31:08PM -0700, tip-bot for Jacob Shin wrote:
> > Commit-ID:  757885e94a22bcc82beb9b1445c95218cb20ceab
> > Gitweb:     http://git.kernel.org/tip/757885e94a22bcc82beb9b1445c95218cb20ceab
> > Author:     Jacob Shin <jacob.shin@amd.com>
> > AuthorDate: Thu, 30 May 2013 14:09:19 -0500
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Thu, 30 May 2013 20:19:25 -0700
> > 
> > x86, microcode, amd: Early microcode patch loading support for AMD
> > 
> > Add early microcode patch loading support for AMD.
> > 
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > Link: http://lkml.kernel.org/r/1369940959-2077-5-git-send-email-jacob.shin@amd.com
> > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > Cc: Fenghua Yu <fenghua.yu@intel.com>
> > ---
> 
> ...
> 
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index 7bd3bd3..6c3fcea 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -93,6 +93,7 @@ obj-$(CONFIG_MICROCODE_INTEL_LIB)	+= microcode_intel_lib.o
> >  microcode-y				:= microcode_core.o
> >  microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
> >  microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
> > +obj-$(CONFIG_MICROCODE_AMD_EARLY)	+= microcode_amd_early.o
> >  obj-$(CONFIG_MICROCODE)			+= microcode.o
> 
> This can't be right:
> 
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> arch/x86/built-in.o: In function `apply_ucode_in_initrd':
> /home/boris/kernel/linux-2.6/arch/x86/kernel/microcode_amd_early.c:118: undefined reference to `__apply_microcode_amd'
> arch/x86/built-in.o: In function `save_microcode_in_initrd_amd':
> /home/boris/kernel/linux-2.6/arch/x86/kernel/microcode_amd_early.c:216: undefined reference to `load_microcode_amd'
> arch/x86/built-in.o: In function `collect_cpu_info_amd_early':
> /home/boris/kernel/linux-2.6/arch/x86/kernel/microcode_amd_early.c:171: undefined reference to `ucode_cpu_info'
> /home/boris/kernel/linux-2.6/arch/x86/kernel/microcode_amd_early.c:172: undefined reference to `ucode_cpu_info'
> arch/x86/built-in.o: In function `load_ucode_amd_ap':
> /home/boris/kernel/linux-2.6/arch/x86/kernel/microcode_amd_early.c:185: undefined reference to `load_microcode_amd'
> /home/boris/kernel/linux-2.6/arch/x86/kernel/microcode_amd_early.c:190: undefined reference to `apply_microcode_amd'
> make: *** [vmlinux] Error 1
> 
> $ grep MICROCODE .config
> CONFIG_MICROCODE=m
> CONFIG_MICROCODE_INTEL=y
> CONFIG_MICROCODE_AMD=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_MICROCODE_INTEL_LIB=y
> CONFIG_MICROCODE_INTEL_EARLY=y
> CONFIG_MICROCODE_AMD_EARLY=y
> CONFIG_MICROCODE_EARLY=y
> 
> Jacob, as a tip for you: before sending out patches, always do a
> 
> for ARCH in "i386" "x86_64"
> do
>         for cfg in "defconfig" "allnoconfig" "allyesconfig" "allmodconfig"
>         do
>                 make -j<something> $ARCH $cfg
>         done
> done
> 
> to smoke-test your patches. I'm not saying this should catch all build
> errors but still...

So sorry .. lesson learned, will do.

Fix below. Yinghai, I appended this randconfig error fix to the
section mismatch fix I sent you earlier:
  https://lkml.org/lkml/2013/5/31/51

>From bdb3e0c8cde1a7cd12946a3be5e2ebf22421f462 Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Fri, 31 May 2013 01:53:24 -0500
Subject: [PATCH 1/1] x86/microcode/amd: fix warnings and errors on randconfig

Fix section mismatch warnings on microcode_amd_early.
Compile error occurs when CONFIG_MICROCODE=m, change so that early
loading depends on microcode_core.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/Kconfig                      |    2 +-
 arch/x86/include/asm/microcode_amd.h  |    2 +-
 arch/x86/kernel/microcode_amd_early.c |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 28dba52..2705532 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1065,7 +1065,7 @@ config MICROCODE_AMD_EARLY
 
 config MICROCODE_EARLY
 	bool "Early load microcode"
-	depends on (MICROCODE_INTEL || MICROCODE_AMD) && BLK_DEV_INITRD
+	depends on MICROCODE=y && BLK_DEV_INITRD
 	select MICROCODE_INTEL_EARLY if MICROCODE_INTEL
 	select MICROCODE_AMD_EARLY if MICROCODE_AMD
 	default y
diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
index 24254aa..c6b043f 100644
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -64,7 +64,7 @@ extern enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
 #ifdef CONFIG_MICROCODE_AMD_EARLY
 #ifdef CONFIG_X86_32
 #define MPB_MAX_SIZE PAGE_SIZE
-extern u8 __cpuinitdata amd_bsp_mpb[MPB_MAX_SIZE];
+extern u8 amd_bsp_mpb[MPB_MAX_SIZE];
 #endif
 extern void __init load_ucode_amd_bsp(void);
 extern void __cpuinit load_ucode_amd_ap(void);
diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
index 7e54d97..9618805 100644
--- a/arch/x86/kernel/microcode_amd_early.c
+++ b/arch/x86/kernel/microcode_amd_early.c
@@ -21,9 +21,9 @@ static u32 ucode_new_rev;
  * Microcode patch container file is prepended to the initrd in cpio format.
  * See Documentation/x86/early-microcode.txt
  */
-static __initdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
+static __cpuinitdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
 
-static struct cpio_data __init find_ucode_in_initrd(void)
+static struct cpio_data __cpuinit find_ucode_in_initrd(void)
 {
 	long offset = 0;
 	struct cpio_data cd;
@@ -62,7 +62,7 @@ static struct cpio_data __init find_ucode_in_initrd(void)
  * load_microcode_amd() to save equivalent cpu table and microcode patches in
  * kernel heap memory.
  */
-static void __init apply_ucode_in_initrd(void)
+static void __cpuinit apply_ucode_in_initrd(void)
 {
 	struct cpio_data cd;
 	struct equiv_cpu_entry *eq;
@@ -133,7 +133,7 @@ void __init load_ucode_amd_bsp(void)
 }
 
 #ifdef CONFIG_X86_32
-u8 __cpuinitdata amd_bsp_mpb[MPB_MAX_SIZE];
+u8 amd_bsp_mpb[MPB_MAX_SIZE];
 
 /*
  * On 32-bit, since AP's early load occurs before paging is turned on, we
-- 
1.7.9.5



