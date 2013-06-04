Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab3FDVgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:36:18 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:43522
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819Ab3FDVgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:36:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MNW1C2-02-7IN-02
X-M-MSG: 
Date: Tue, 4 Jun 2013 16:36:00 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/microcode] x86, microcode, amd: Fix warnings and errors
 on with CONFIG_MICROCODE=m
Message-ID: <20130604213600.GA5021@jshin-Toonie>
References: <20130531150241.GA12006@jshin-Toonie>
 <tip-6b3389ac21b5e557b957f1497d0ff22bf733e8c3@git.kernel.org>
 <CAE9FiQUJOfcoU8c_Xwhosb1=9=dyaH6mXkERX-zxCUmEXjeNUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQUJOfcoU8c_Xwhosb1=9=dyaH6mXkERX-zxCUmEXjeNUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 02:02:43PM -0700, Yinghai Lu wrote:
> On Fri, May 31, 2013 at 2:59 PM, tip-bot for Jacob Shin
> <tipbot@zytor.com> wrote:
> > Commit-ID:  6b3389ac21b5e557b957f1497d0ff22bf733e8c3
> > Gitweb:     http://git.kernel.org/tip/6b3389ac21b5e557b957f1497d0ff22bf733e8c3
> > Author:     Jacob Shin <jacob.shin@amd.com>
> > AuthorDate: Fri, 31 May 2013 01:53:24 -0500
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Fri, 31 May 2013 13:56:58 -0700
> >
> > x86, microcode, amd: Fix warnings and errors on with CONFIG_MICROCODE=m
> >
> > Fix section mismatch warnings on microcode_amd_early.
> > Compile error occurs when CONFIG_MICROCODE=m, change so that early
> > loading depends on microcode_core.
> >
> > Reported-by: Yinghai Lu <yinghai@kernel.org>
> > Reported-by: Borislav Petkov <bp@alien8.de>
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > Link: http://lkml.kernel.org/r/20130531150241.GA12006@jshin-Toonie
> > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > ---
> >  arch/x86/Kconfig                      | 2 +-
> >  arch/x86/include/asm/microcode_amd.h  | 2 +-
> >  arch/x86/kernel/microcode_amd_early.c | 8 ++++----
> >  3 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 28dba52..2705532 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1065,7 +1065,7 @@ config MICROCODE_AMD_EARLY
> >
> >  config MICROCODE_EARLY
> >         bool "Early load microcode"
> > -       depends on (MICROCODE_INTEL || MICROCODE_AMD) && BLK_DEV_INITRD
> > +       depends on MICROCODE=y && BLK_DEV_INITRD
> >         select MICROCODE_INTEL_EARLY if MICROCODE_INTEL
> >         select MICROCODE_AMD_EARLY if MICROCODE_AMD
> >         default y
> > diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
> > index 24254aa..c6b043f 100644
> > --- a/arch/x86/include/asm/microcode_amd.h
> > +++ b/arch/x86/include/asm/microcode_amd.h
> > @@ -64,7 +64,7 @@ extern enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
> >  #ifdef CONFIG_MICROCODE_AMD_EARLY
> >  #ifdef CONFIG_X86_32
> >  #define MPB_MAX_SIZE PAGE_SIZE
> > -extern u8 __cpuinitdata amd_bsp_mpb[MPB_MAX_SIZE];
> > +extern u8 amd_bsp_mpb[MPB_MAX_SIZE];
> >  #endif
> >  extern void __init load_ucode_amd_bsp(void);
> >  extern void __cpuinit load_ucode_amd_ap(void);
> > diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
> > index 7e54d97..9618805 100644
> > --- a/arch/x86/kernel/microcode_amd_early.c
> > +++ b/arch/x86/kernel/microcode_amd_early.c
> > @@ -21,9 +21,9 @@ static u32 ucode_new_rev;
> >   * Microcode patch container file is prepended to the initrd in cpio format.
> >   * See Documentation/x86/early-microcode.txt
> >   */
> > -static __initdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
> > +static __cpuinitdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
> >
> > -static struct cpio_data __init find_ucode_in_initrd(void)
> > +static struct cpio_data __cpuinit find_ucode_in_initrd(void)
> >  {
> >         long offset = 0;
> >         struct cpio_data cd;
> 
> does not like right fix.
> 
> find_ucode_in_initrd should be __init.
> 
> > @@ -62,7 +62,7 @@ static struct cpio_data __init find_ucode_in_initrd(void)
> >   * load_microcode_amd() to save equivalent cpu table and microcode patches in
> >   * kernel heap memory.
> >   */
> > -static void __init apply_ucode_in_initrd(void)
> > +static void __cpuinit apply_ucode_in_initrd(void)
> >  {
> >         struct cpio_data cd;
> >         struct equiv_cpu_entry *eq;
> 
> it should not call find_ucode_in_initrd or
> it should be __init.

It's because the load_ucode_amd_ap() (which is __cpuinit because it
can be called during CPU hotplug on).

Hm.. but yes, I do agree with you, I'm waiting for feedback on this
follow up patch to allow multiple concatanated microcode files:

  https://lkml.org/lkml/2013/5/31/664

I'll submit multi-patch patchset to address your feedback as well.

Thank you,

