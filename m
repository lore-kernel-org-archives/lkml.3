Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab3GEQdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:33:33 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51126 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3GEQdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:33:32 -0400
Message-ID: <51D6F554.3070702@free-electrons.com>
Date: Fri, 05 Jul 2013 18:33:24 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@infradead.org,
        arm@kernel.org
Subject: Re: [PATCH 1/8] clocksource: armada-xp: always register local_timer_ops
References: <1373041417-217728-1-git-send-email-arnd@arndb.de> <1373041417-217728-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1373041417-217728-2-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 06:23 PM, Arnd Bergmann wrote:
> The call to local_timer_register is hidden behind an #ifdef, which
> turns the armada_370_xp_local_timer_ops into a potentially unused
> variable, causing this warning:
> 
> time-armada-370-xp.c:208:31: warning: 'armada_370_xp_local_timer_ops' defined but not used [-Wunused-variable]
>  static struct local_timer_ops armada_370_xp_local_timer_ops __cpuinitdata = {
>                                ^
> 
> Since local_timer_register() itself doesn't do anything, just removing
> the #ifdef makes the code look nicer and gets rid of the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Jason Cooper <jason@lakedaemon.net>
> Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/clocksource/time-armada-370-xp.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
> index 47a6730..4cd8520 100644
> --- a/drivers/clocksource/time-armada-370-xp.c
> +++ b/drivers/clocksource/time-armada-370-xp.c
> @@ -294,8 +294,6 @@ void __init armada_370_xp_timer_init(void)
>  				percpu_armada_370_xp_evt);
>  	if (!res) {
>  		enable_percpu_irq(armada_370_xp_clkevt.irq, 0);
> -#ifdef CONFIG_LOCAL_TIMERS
>  		local_timer_register(&armada_370_xp_local_timer_ops);
> -#endif
>  	}
>  }
> 

I thought this issue was kind of fixed by the patch
"clocksource: time-armada-370-xp: Divorce from local timer API" from Stephen Boyd.

But I can't find it in linux-next so maybe it has not been pulled, so in this case
you can also add my
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
