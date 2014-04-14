Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaDNQTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:19:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47176 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbaDNQT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:19:26 -0400
Date: Mon, 14 Apr 2014 17:19:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 06/31] arch,arm: Convert smp_mb__*
Message-ID: <20140414161906.GA12916@arm.com>
References: <20140319064729.660482086@infradead.org>
 <20140319065204.099395624@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319065204.099395624@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 06:47:35AM +0000, Peter Zijlstra wrote:
> ARM uses ll/sc primitives that do not imply barriers for all regular
> atomic ops, therefore smp_mb__{before,after} need be a full barrier.
> 
> Since ARM doesn't use asm-generic/barrier.h include the required
> definitions in its asm/barrier.h
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

  Acked-by: Will Deacon <will.deacon@arm.com>

Will

> ---
>  arch/arm/include/asm/atomic.h  |    5 -----
>  arch/arm/include/asm/barrier.h |    3 +++
>  arch/arm/include/asm/bitops.h  |    4 +---
>  3 files changed, 4 insertions(+), 8 deletions(-)
> 
> --- a/arch/arm/include/asm/atomic.h
> +++ b/arch/arm/include/asm/atomic.h
> @@ -211,11 +211,6 @@ static inline int __atomic_add_unless(at
>  
>  #define atomic_add_negative(i,v) (atomic_add_return(i, v) < 0)
>  
> -#define smp_mb__before_atomic_dec()	smp_mb()
> -#define smp_mb__after_atomic_dec()	smp_mb()
> -#define smp_mb__before_atomic_inc()	smp_mb()
> -#define smp_mb__after_atomic_inc()	smp_mb()
> -
>  #ifndef CONFIG_GENERIC_ATOMIC64
>  typedef struct {
>  	long long counter;
> --- a/arch/arm/include/asm/barrier.h
> +++ b/arch/arm/include/asm/barrier.h
> @@ -79,5 +79,8 @@ do {									\
>  
>  #define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
>  
> +#define smp_mb__before_atomic()	smp_mb()
> +#define smp_mb__after_atomic()	smp_mb()
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* __ASM_BARRIER_H */
> --- a/arch/arm/include/asm/bitops.h
> +++ b/arch/arm/include/asm/bitops.h
> @@ -25,9 +25,7 @@
>  
>  #include <linux/compiler.h>
>  #include <linux/irqflags.h>
> -
> -#define smp_mb__before_clear_bit()	smp_mb()
> -#define smp_mb__after_clear_bit()	smp_mb()
> +#include <asm/barrier.h>
>  
>  /*
>   * These functions are the basis of our bit ops.
> 
> 
> 
