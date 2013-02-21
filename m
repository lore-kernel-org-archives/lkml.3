Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3BUQRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:17:31 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40877 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab3BUQR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:17:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] blackfin idle: Fix compile error
Date: Thu, 21 Feb 2013 17:24:05 +0100
Message-ID: <4371891.o6DvZ68ieT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1361440603-7209-1-git-send-email-lars@metafoo.de>
References: <1449748.lzaK5NRLYV@vostro.rjw.lan> <1361440603-7209-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 21, 2013 10:56:43 AM Lars-Peter Clausen wrote:
> Commit 26bab0c ("blackfin idle: delete pm_idle") introduced the following
> compile error:
> 	arch/blackfin/kernel/process.c: In function ‘cpu_idle’:
> 	arch/blackfin/kernel/process.c:83: error: ‘idle’ undeclared (first use in this function)
> 	arch/blackfin/kernel/process.c:83: error: (Each undeclared identifier is reported only once
> 	arch/blackfin/kernel/process.c:83: error: for each function it appears in.)
> 	arch/blackfin/kernel/process.c:88: error: implicit declaration of function ‘idle’
> 
> This patch fixes it.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Applied to linux-pm.git/linux-next, I'm going to push it to Linus later this
week.

Thanks,
Rafael


> ---
>  arch/blackfin/kernel/process.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
> index 8061426..9782c03 100644
> --- a/arch/blackfin/kernel/process.c
> +++ b/arch/blackfin/kernel/process.c
> @@ -80,12 +80,10 @@ void cpu_idle(void)
>  		if (cpu_is_offline(smp_processor_id()))
>  			cpu_die();
>  #endif
> -		if (!idle)
> -			idle = default_idle;
>  		tick_nohz_idle_enter();
>  		rcu_idle_enter();
>  		while (!need_resched())
> -			idle();
> +			default_idle();
>  		rcu_idle_exit();
>  		tick_nohz_idle_exit();
>  		preempt_enable_no_resched();
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
