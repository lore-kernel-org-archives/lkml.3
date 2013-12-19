Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab3LSMer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:34:47 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44339 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab3LSMeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:34:36 -0500
Message-ID: <52B2E7D9.4030908@gmail.com>
Date: Thu, 19 Dec 2013 20:34:33 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Revert "ARC: Add guard macro to uapi/asm/unistd.h"
References: <1387451598-14490-1-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1387451598-14490-1-git-send-email-vgupta@synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 07:13 PM, Vineet Gupta wrote:
> This reverts commit 97bc386fc12deeb41d5bff33548e3002b258d4e0.
> 
> Generic syscall table generator relies on ARCH unistd.h as follows:
> 
> 	void *sys_call_table[NR_syscalls] = {
> 		[0 ... NR_syscalls-1] = sys_ni_syscall,
> 	#include <asm/unistd.h>
> 	};
> 
> And turns out that prior dependencies already include that header by
> the time preprocessor hits the above. Meaning ARCH unistd.h needs to be
> able to included twice.
> 

OK, thanks, it sounds reasonable to me.

But why many other architectures contents these guard macros? (arm, sh,
blackfin, cris, frv, ia64, m32r, m68k, mips, s390, microblaze, mn10300,
parisc, powerpc, sparc, x86). Do they need improvement too?

And for our case, what xtensa has done looks like a better way to me.


Thanks.

> This however means that perf cross comilation warning will re-appear
> which needs to be discussed with perf folks (why they need to include
> both libc variant as well as kernel internal header directly).
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>  arch/arc/include/uapi/asm/unistd.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/arc/include/uapi/asm/unistd.h b/arch/arc/include/uapi/asm/unistd.h
> index 68125dd766c6..6f30484f34b7 100644
> --- a/arch/arc/include/uapi/asm/unistd.h
> +++ b/arch/arc/include/uapi/asm/unistd.h
> @@ -8,9 +8,6 @@
>  
>  /******** no-legacy-syscalls-ABI *******/
>  
> -#ifndef _UAPI_ASM_ARC_UNISTD_H
> -#define _UAPI_ASM_ARC_UNISTD_H
> -
>  #define __ARCH_WANT_SYS_EXECVE
>  #define __ARCH_WANT_SYS_CLONE
>  #define __ARCH_WANT_SYS_VFORK
> @@ -35,5 +32,3 @@ __SYSCALL(__NR_arc_gettls, sys_arc_gettls)
>  /* Generic syscall (fs/filesystems.c - lost in asm-generic/unistd.h */
>  #define __NR_sysfs		(__NR_arch_specific_syscall + 3)
>  __SYSCALL(__NR_sysfs, sys_sysfs)
> -
> -#endif
> 


-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
