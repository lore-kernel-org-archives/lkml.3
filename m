Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaHSOK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:10:26 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60816 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaHSOKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:10:24 -0400
Date: Tue, 19 Aug 2014 07:10:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davidlohr@hp.com
Subject: Re: [PATCH BUGFIX] frv: Define cpu_relax_lowlatency()
Message-ID: <20140819141014.GA20807@roeck-us.net>
References: <1408392039.3718.6.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408392039.3718.6.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 01:00:39PM -0700, Davidlohr Bueso wrote:
> 3a6bfbc9 (arch,locking: Ciao arch_mutex_cpu_relax()) broke building the frv
> arch. Fixes errors such as:
> 
> kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of function 'cpu_relax_lowlatency'
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

inventing a new tag...

Compile-tested-by: Guenter Roeck <linux@roeck-us.net>

> ---
> Linus, as discussed, here's the resend.
> Original thread: https://lkml.org/lkml/2014/8/5/442
> 
>  arch/frv/include/asm/processor.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/frv/include/asm/processor.h b/arch/frv/include/asm/processor.h
> index a34f309..6554e78 100644
> --- a/arch/frv/include/asm/processor.h
> +++ b/arch/frv/include/asm/processor.h
> @@ -129,7 +129,8 @@ unsigned long get_wchan(struct task_struct *p);
>  #define	KSTK_EIP(tsk)	((tsk)->thread.frame0->pc)
>  #define	KSTK_ESP(tsk)	((tsk)->thread.frame0->sp)
>  
> -#define cpu_relax()    barrier()
> +#define cpu_relax() barrier()
> +#define cpu_relax_lowlatency() cpu_relax()
>  
>  /* data cache prefetch */
>  #define ARCH_HAS_PREFETCH
> -- 
> 1.8.1.4
> 
> 
> 
> 
