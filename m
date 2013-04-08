Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936232Ab3DHPQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:16:15 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45036 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761733Ab3DHPQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:16:14 -0400
Date: Mon, 8 Apr 2013 17:16:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] locking: remove three unused Kconfig symbols
Message-ID: <20130408151609.GA13640@gmail.com>
References: <1365428154.1830.99.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365428154.1830.99.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Bolle <pebolle@tiscali.nl> wrote:

> The Kconfig symbols ARCH_INLINE_READ_UNLOCK_IRQ,
> ARCH_INLINE_SPIN_UNLOCK_IRQ, and ARCH_INLINE_WRITE_UNLOCK_IRQ were added
> in v2.6.33, but have never actually been used. It is safe to remove
> these.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested. These three symbols were added in commit
> 6beb000923882f6204ea2cfcd932e568e900803f ("locking: Make inlining
> decision Kconfig based").
> 
>  arch/s390/Kconfig    |  3 ---
>  kernel/Kconfig.locks | 10 ----------
>  2 files changed, 13 deletions(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index eb8fb62..8c544d2 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -70,7 +70,6 @@ config S390
>  	select ARCH_INLINE_READ_TRYLOCK
>  	select ARCH_INLINE_READ_UNLOCK
>  	select ARCH_INLINE_READ_UNLOCK_BH
> -	select ARCH_INLINE_READ_UNLOCK_IRQ
>  	select ARCH_INLINE_READ_UNLOCK_IRQRESTORE
>  	select ARCH_INLINE_SPIN_LOCK
>  	select ARCH_INLINE_SPIN_LOCK_BH
> @@ -80,7 +79,6 @@ config S390
>  	select ARCH_INLINE_SPIN_TRYLOCK_BH
>  	select ARCH_INLINE_SPIN_UNLOCK
>  	select ARCH_INLINE_SPIN_UNLOCK_BH
> -	select ARCH_INLINE_SPIN_UNLOCK_IRQ
>  	select ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
>  	select ARCH_INLINE_WRITE_LOCK
>  	select ARCH_INLINE_WRITE_LOCK_BH
> @@ -89,7 +87,6 @@ config S390
>  	select ARCH_INLINE_WRITE_TRYLOCK
>  	select ARCH_INLINE_WRITE_UNLOCK
>  	select ARCH_INLINE_WRITE_UNLOCK_BH
> -	select ARCH_INLINE_WRITE_UNLOCK_IRQ
>  	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
>  	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
>  	select ARCH_WANT_IPC_PARSE_VERSION
> diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
> index 44511d1..c438507 100644
> --- a/kernel/Kconfig.locks
> +++ b/kernel/Kconfig.locks
> @@ -25,9 +25,6 @@ config ARCH_INLINE_SPIN_UNLOCK
>  config ARCH_INLINE_SPIN_UNLOCK_BH
>  	bool
>  
> -config ARCH_INLINE_SPIN_UNLOCK_IRQ
> -	bool
> -
>  config ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
>  	bool
>  
> @@ -53,13 +50,9 @@ config ARCH_INLINE_READ_UNLOCK
>  config ARCH_INLINE_READ_UNLOCK_BH
>  	bool
>  
> -config ARCH_INLINE_READ_UNLOCK_IRQ
> -	bool
> -
>  config ARCH_INLINE_READ_UNLOCK_IRQRESTORE
>  	bool
>  
> -
>  config ARCH_INLINE_WRITE_TRYLOCK
>  	bool
>  
> @@ -81,9 +74,6 @@ config ARCH_INLINE_WRITE_UNLOCK
>  config ARCH_INLINE_WRITE_UNLOCK_BH
>  	bool
>  
> -config ARCH_INLINE_WRITE_UNLOCK_IRQ
> -	bool
> -
>  config ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
>  	bool

Erm, if you look at the code in question you'll see that they are unused I think 
due to a bug:

 config INLINE_READ_UNLOCK_IRQ
        def_bool y
        depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK_BH

Shouldn't that depend on ARCH_INLINE_READ_UNLOCK_IRQ?

Similarly for the others.

Thanks,

	Ingo
