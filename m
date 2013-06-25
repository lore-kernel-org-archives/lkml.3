Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3FYXHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:07:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39744 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab3FYXHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:07:31 -0400
Date: Wed, 26 Jun 2013 01:07:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86, processor-flags: Fix the datatypes and add
 bit number defines
Message-ID: <20130625230727.GB4396@pd.tnic>
References: <tip-cwckhbrib2aux1qbteaebij0@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-cwckhbrib2aux1qbteaebij0@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 03:54:56PM -0700, tip-bot for H. Peter Anvin wrote:
> Commit-ID:  5d378644340de4c43dd3a50ed3a03e916c840d17
> Gitweb:     http://git.kernel.org/tip/5d378644340de4c43dd3a50ed3a03e916c840d17
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Sat, 27 Apr 2013 16:11:17 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue, 25 Jun 2013 15:50:05 -0700
> 
> x86, processor-flags: Fix the datatypes and add bit number defines
> 
> The control registers are unsigned long (32 bits on i386, 64 bits on
> x86-64), and so make that manifest in the data type for the various
> constants.  Add defines with a _BIT suffix which defines the bit
> number, as opposed to the bit mask.
> 
> This should resolve some issues with ~bitmask that Linus discovered.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Link: http://lkml.kernel.org/n/tip-cwckhbrib2aux1qbteaebij0@git.kernel.org
> ---
>  arch/x86/include/uapi/asm/processor-flags.h | 154 +++++++++++++++++++---------
>  1 file changed, 104 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/processor-flags.h b/arch/x86/include/uapi/asm/processor-flags.h
> index 1b34df5..180a0c3 100644
> --- a/arch/x86/include/uapi/asm/processor-flags.h
> +++ b/arch/x86/include/uapi/asm/processor-flags.h
> @@ -2,75 +2,129 @@
>  #define _UAPI_ASM_X86_PROCESSOR_FLAGS_H
>  /* Various flags defined: can be included from assembler. */
>  
> +#include <linux/const.h>
> +
>  /*
>   * EFLAGS bits
>   */
> -#define X86_EFLAGS_CF	0x00000001 /* Carry Flag */
> -#define X86_EFLAGS_FIXED 0x00000002 /* Bit 1 - always on */
> -#define X86_EFLAGS_PF	0x00000004 /* Parity Flag */
> -#define X86_EFLAGS_AF	0x00000010 /* Auxiliary carry Flag */
> -#define X86_EFLAGS_ZF	0x00000040 /* Zero Flag */
> -#define X86_EFLAGS_SF	0x00000080 /* Sign Flag */
> -#define X86_EFLAGS_TF	0x00000100 /* Trap Flag */
> -#define X86_EFLAGS_IF	0x00000200 /* Interrupt Flag */
> -#define X86_EFLAGS_DF	0x00000400 /* Direction Flag */
> -#define X86_EFLAGS_OF	0x00000800 /* Overflow Flag */
> -#define X86_EFLAGS_IOPL	0x00003000 /* IOPL mask */
> -#define X86_EFLAGS_NT	0x00004000 /* Nested Task */
> -#define X86_EFLAGS_RF	0x00010000 /* Resume Flag */
> -#define X86_EFLAGS_VM	0x00020000 /* Virtual Mode */
> -#define X86_EFLAGS_AC	0x00040000 /* Alignment Check */
> -#define X86_EFLAGS_VIF	0x00080000 /* Virtual Interrupt Flag */
> -#define X86_EFLAGS_VIP	0x00100000 /* Virtual Interrupt Pending */
> -#define X86_EFLAGS_ID	0x00200000 /* CPUID detection flag */
> +#define X86_EFLAGS_CF_BIT	0 /* Carry Flag */
> +#define X86_EFLAGS_CF		_BITUL(X86_EFLAGS_CF_BIT)

Btw, are you going to need those _BIT defines anywhere else?

Because if no, you could simply do:

#define X86_EFLAGS_CF		_BITUL(0) /* Carry Flag */

and so on, and drop the _BIT defines.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
