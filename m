Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaLHJ1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:27:09 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:32795 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaLHJ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:27:08 -0500
Date: Mon, 8 Dec 2014 10:27:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] x86, microcode: Reloading fixes
Message-ID: <20141208092703.GA12347@gmail.com>
References: <1417879908-4851-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417879908-4851-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> From: Borislav Petkov <bp@suse.de>
> 
> Hi guys,
> 
> please pull three fixes for the microcode loader. More specifically,
> microcode reloading for 3.19. Patches are against tip/x86/microcode.
> 
> I have this also as a tag if you'd prefer to pull:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode_fixes_for_3.19
> 
> This will have a conflict when merging into Linus' tree after
> tip/x86/urgent has went in for 3.18 but resolving it should be easy. The
> final result should be this with the ifdef dropped:
> 
> ---
> diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
> index 08fe6e8a726e..15c29096136b 100644
> --- a/arch/x86/kernel/cpu/microcode/core.c
> +++ b/arch/x86/kernel/cpu/microcode/core.c
> @@ -465,16 +465,8 @@ static void mc_bp_resume(void)
>  
>         if (uci->valid && uci->mc)
>                 microcode_ops->apply_microcode(cpu);
> -#ifdef CONFIG_X86_64
>         else if (!uci->mc)
> -               /*
> -                * We might resume and not have applied late microcode but still
> -                * have a newer patch stashed from the early loader. We don't
> -                * have it in uci->mc so we have to load it the same way we're
> -                * applying patches early on the APs.
> -                */
> -               load_ucode_ap();
> -#endif
> +               reload_early_microcode();
>  }
> --
> 
> Thanks.
> 
> Boris Ostrovsky (1):
>   x86, microcode: Don't initialize microcode code on paravirt
> 
> Borislav Petkov (2):
>   x86, microcode, intel: Drop unused parameter
>   x86, microcode: Reload microcode on resume
> 
>  arch/x86/include/asm/microcode.h            |  2 ++
>  arch/x86/include/asm/microcode_amd.h        |  2 ++
>  arch/x86/include/asm/microcode_intel.h      |  2 ++
>  arch/x86/kernel/cpu/microcode/amd_early.c   | 18 +++++++++++
>  arch/x86/kernel/cpu/microcode/core.c        | 10 ++----
>  arch/x86/kernel/cpu/microcode/core_early.c  | 21 +++++++++++++
>  arch/x86/kernel/cpu/microcode/intel_early.c | 48 +++++++++++++++++++++++------
>  7 files changed, 85 insertions(+), 18 deletions(-)

Pulled into tip:x86/microcode, thanks a lot Boris!

	Ingo
