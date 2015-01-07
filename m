Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbbAGLaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:30:20 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56565 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbbAGLaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:30:17 -0500
Date: Wed, 7 Jan 2015 11:30:05 +0000
From: Will Deacon <will.deacon@arm.com>
To: Anton Blanchard <anton@samba.org>
Cc: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "mmarek@suse.cz" <mmarek@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jbaron@akamai.com" <jbaron@akamai.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "liuj97@gmail.com" <liuj97@gmail.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] jump_label: Allow asm/jump_label.h to be included in
 assembly
Message-ID: <20150107113004.GJ7485@arm.com>
References: <1420626958-31254-1-git-send-email-anton@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420626958-31254-1-git-send-email-anton@samba.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 10:35:56AM +0000, Anton Blanchard wrote:
> Wrap asm/jump_label.h for all archs with #ifndef __ASSEMBLY__.
> Since these are kernel only headers, we don't need #ifdef __KERNEL__
> so can simplify things a bit.
> 
> If an architecture wants to use jump labels in assembly, it
> will still need to define a macro to create the __jump_table
> entries (see ARCH_STATIC_BRANCH in the powerpc asm/jump_label.h
> for an example).
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>  arch/arm/include/asm/jump_label.h   | 5 ++---
>  arch/arm64/include/asm/jump_label.h | 8 ++++----
>  arch/mips/include/asm/jump_label.h  | 7 +++----
>  arch/s390/include/asm/jump_label.h  | 3 +++
>  arch/sparc/include/asm/jump_label.h | 5 ++---
>  arch/x86/include/asm/jump_label.h   | 5 ++---
>  6 files changed, 16 insertions(+), 17 deletions(-)

[...]

> diff --git a/arch/arm64/include/asm/jump_label.h b/arch/arm64/include/asm/jump_label.h
> index 076a1c7..c0e5165 100644
> --- a/arch/arm64/include/asm/jump_label.h
> +++ b/arch/arm64/include/asm/jump_label.h
> @@ -18,11 +18,12 @@
>   */
>  #ifndef __ASM_JUMP_LABEL_H
>  #define __ASM_JUMP_LABEL_H
> +
> +#ifndef __ASSEMBLY__
> +
>  #include <linux/types.h>
>  #include <asm/insn.h>
>  
> -#ifdef __KERNEL__
> -
>  #define JUMP_LABEL_NOP_SIZE		AARCH64_INSN_SIZE
>  
>  static __always_inline bool arch_static_branch(struct static_key *key)
> @@ -39,8 +40,6 @@ l_yes:
>  	return true;
>  }
>  
> -#endif /* __KERNEL__ */
> -
>  typedef u64 jump_label_t;
>  
>  struct jump_entry {
> @@ -49,4 +48,5 @@ struct jump_entry {
>  	jump_label_t key;
>  };
>  
> +#endif  /* __ASSEMBLY__ */
>  #endif	/* __ASM_JUMP_LABEL_H */

The arm64 bit looks fine to me:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
