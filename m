Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3BUQSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:18:40 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40885 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab3BUQSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:18:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] microblaze idle: Fix compile error
Date: Thu, 21 Feb 2013 17:25:17 +0100
Message-ID: <5556573.chQEm97ICB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1361441731-19900-1-git-send-email-lars@metafoo.de>
References: <fe98b401efe3034c1684b8625ac266601c3b4ad1.1360475150.git.len.brown@intel.com> <1361441731-19900-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 21, 2013 11:15:31 AM Lars-Peter Clausen wrote:
> Commit def8203 ("microblaze idle: delete pm_idle") introduced the following
> compile error:
> 
> 	arch/microblaze/kernel/process.c: In function 'cpu_idle':
> 	arch/microblaze/kernel/process.c:100: error: 'idle' undeclared (first use in this function)
> 	arch/microblaze/kernel/process.c:100: error: (Each undeclared identifier is reported only once
> 	arch/microblaze/kernel/process.c:100: error: for each function it appears in.)
> 	arch/microblaze/kernel/process.c:106: error: implicit declaration of function 'idle'
> 
> This patch fixes it.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Applied to linux-pm.git/linux-next, I'm going to push it to Linus later this
week.

Thanks,
Rafael


> ---
>  arch/microblaze/kernel/process.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
> index 6ff2dcf..08f8734 100644
> --- a/arch/microblaze/kernel/process.c
> +++ b/arch/microblaze/kernel/process.c
> @@ -97,13 +97,10 @@ void cpu_idle(void)
>  
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> -		if (!idle)
> -			idle = default_idle;
> -
>  		tick_nohz_idle_enter();
>  		rcu_idle_enter();
>  		while (!need_resched())
> -			idle();
> +			default_idle();
>  		rcu_idle_exit();
>  		tick_nohz_idle_exit();
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
