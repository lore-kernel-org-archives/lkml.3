Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab3B1XQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:16:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54574 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab3B1XQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:16:18 -0500
Date: Fri, 1 Mar 2013 00:16:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [GIT PULL] x86/microcode for v3.9-rc1
Message-ID: <20130228231608.GA17468@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yinghai Lu <yinghai@kernel.org>
References: <201302220456.r1M4ua12006362@terminus.zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201302220456.r1M4ua12006362@terminus.zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 08:56:36PM -0800, H. Peter Anvin wrote:
> Hi Linus,
> 
> This patchset lets us update the CPU microcode very, very early in
> initialization if the BIOS fails to do so (never happens, right?)
> This is handy for dealing with things like the Atom erratum where we
> have to run without PSE because microcode loading happens too late.
> 
> As I mentioned in the x86/mm push request it depends on that
> infrastructure but it is otherwise a standalone feature.
> 
> ----------------------------------------------------------------
> 
> The following changes since commit ac2cbab21f318e19bc176a7f38a120cec835220f:
> 
>   x86: Don't panic if can not alloc buffer for swiotlb (2013-01-29 19:36:53 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/microcode
> 
> for you to fetch changes up to da76f64e7eb28b718501d15c1b79af560b7ca4ea:
> 
>   x86/Kconfig: Make early microcode loading a configuration feature (2013-01-31 13:20:42 -0800)
> 
> ----------------------------------------------------------------
> 
> Fenghua Yu (12):
>       x86, doc: Documentation for early microcode loading
>       x86/microcode_intel.h: Define functions and macros for early loading ucode
>       x86/common.c: Make have_cpuid_p() a global function
>       x86/common.c: load ucode in 64 bit or show loading ucode info in 32 bit on AP
>       x86/microcode_core_early.c: Define interfaces for early loading ucode
>       x86/microcode_intel_lib.c: Early update ucode on Intel's CPU
>       x86/tlbflush.h: Define __native_flush_tlb_global_irq_disabled()
>       x86/microcode_intel_early.c: Early update ucode on Intel's CPU
>       x86/head_32.S: Early update ucode in 32-bit
>       x86/head64.c: Early update ucode in 64-bit
>       x86/mm/init.c: Copy ucode from initrd image to kernel memory
>       x86/Kconfig: Make early microcode loading a configuration feature

Some strange build warnings I get here:

arch/x86/kernel/microcode_intel_early.c: In function `get_matching_model_microcode.isra.3.constprop.9':
arch/x86/kernel/microcode_intel_early.c:366:1: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]
arch/x86/kernel/microcode_intel_early.c: In function `save_mc_for_early':
arch/x86/kernel/microcode_intel_early.c:550:1: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]

What's up?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
