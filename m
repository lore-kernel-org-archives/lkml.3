Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3IZWko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:40:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:55444 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab3IZWkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:40:43 -0400
Message-ID: <1380234046.28561.73.camel@pasglop>
Subject: Re: [PATCH 8/8] powerpc: Tell about irq stack coverage
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@au1.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Sep 2013 08:20:46 +1000
In-Reply-To: <1380212686-25897-9-git-send-email-fweisbec@gmail.com>
References: <1380212686-25897-1-git-send-email-fweisbec@gmail.com>
	 <1380212686-25897-9-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 18:24 +0200, Frederic Weisbecker wrote:
> Now that powerpc runs irq_exit() under the irq stack,
> let the softirq core know about that so that we spare
> the needless stack switch on irq exit's softirq processing.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc:

>  Paul Mackerras <paulus@au1.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Paul Mackerras <paulus@au1.ibm.com>
> Cc: James Hogan <james.hogan@imgtec.com>
> Cc: James E.J. Bottomley <jejb@parisc-linux.org>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/powerpc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 38f3b7e..b365d5c 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -138,6 +138,7 @@ config PPC
>  	select OLD_SIGSUSPEND
>  	select OLD_SIGACTION if PPC32
>  	select HAVE_DEBUG_STACKOVERFLOW
> +	select HAVE_IRQ_EXIT_ON_IRQ_STACK
>  
>  config EARLY_PRINTK
>  	bool


