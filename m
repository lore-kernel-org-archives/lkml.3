Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3EaHAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:00:07 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:48609
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161Ab3EaHAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 03:00:03 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
X-WSS-ID: 0MNNI3V-02-2LB-02
X-M-MSG: 
Date: Fri, 31 May 2013 01:59:55 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/microcode] x86, microcode, amd: Early microcode patch
 loading support for AMD
Message-ID: <20130531065955.GA32212@jshin-Toonie>
References: <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
 <tip-757885e94a22bcc82beb9b1445c95218cb20ceab@git.kernel.org>
 <CAE9FiQWJbM=4WOzTfrAbNLgatkH_TXavK8vp1ZXHjw=bs-Obvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQWJbM=4WOzTfrAbNLgatkH_TXavK8vp1ZXHjw=bs-Obvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 11:10:23PM -0700, Yinghai Lu wrote:
> On Thu, May 30, 2013 at 8:31 PM, tip-bot for Jacob Shin
> <tipbot@zytor.com> wrote:
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
> >  Documentation/x86/early-microcode.txt  |  11 +-
> >  arch/x86/Kconfig                       |  14 ++-
> >  arch/x86/include/asm/microcode_amd.h   |  14 +++
> >  arch/x86/kernel/Makefile               |   1 +
> >  arch/x86/kernel/microcode_amd.c        |  22 ++++
> >  arch/x86/kernel/microcode_amd_early.c  | 222 +++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/microcode_core_early.c |  43 ++++++-
> >  7 files changed, 310 insertions(+), 17 deletions(-)
> >
> 
> WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x7115): Section
> mismatch in reference from the function load_ucode_amd_ap() to the
> function .init.text:find_ucode_in_initrd()
> The function __cpuinit load_ucode_amd_ap() references
> a function __init find_ucode_in_initrd().
> If find_ucode_in_initrd is only used by load_ucode_amd_ap then
> annotate find_ucode_in_initrd with a matching annotation.

Sorry about that, should have turned on CONFIG_DEBUG_SECTION_MISMATCH=y

This should fix the warnings:

>From 5c7ec96f218f08db25e449d7d5789ee2f66f2f92 Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Fri, 31 May 2013 01:53:24 -0500
Subject: [PATCH 1/1] x86/microcode/amd: fix section mismatch warnings on
 microcode_amd_early.c

Fix section mismatch warnings on microcode_amd_early.c

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/include/asm/microcode_amd.h  |    2 +-
 arch/x86/kernel/microcode_amd_early.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

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


