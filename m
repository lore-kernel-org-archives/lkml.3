Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3A0IKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 03:10:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52999 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab3A0IKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 03:10:34 -0500
Date: Sun, 27 Jan 2013 09:10:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Joonyoung Shim <jy0922.shim@samsung.com>
cc: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: fix to refer NULL pointer
In-Reply-To: <1359177589-13868-1-git-send-email-jy0922.shim@samsung.com>
Message-ID: <Pine.LNX.4.64.1301270906270.5137@axis700.grange>
References: <1359177589-13868-1-git-send-email-jy0922.shim@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:xoZnoSjvx0nM9xoZL56KU/VwPG0aHaUAaZAUZMts9LL
 QlRFsFdz5LMFG5v2JhOlblJUtZS5ydsx3ZmVOPoauYm1f3V7Ps
 bQYsG44vJjEpk8hxg3k1ZWR87Vm84w/pc6nHn/xFC9sf9e7MPX
 Zr60lO6/8NFfY+m64ypYo+HJEMwHxj7c3PcWxpkG1vXx2JSB1c
 Ckpb+gPEz9UeNEcpYMkx/yhyUJ5KVCYIdaOx3KwVXJO15aA2+l
 lO+DPoLPskqdbqTLvZkQ0hTXvLYAt16tQ6Ygn40q2271p7wX9L
 YI3gqlUUAOSqHbjXQPzaXIum2UG67drV4T+FN5ImsGBeUUGkKP
 zYGOgxvbSiBgXC6BItsb73WJV6ruGvY0fyHQi51wm6us898ePd
 3em8YnanEZ5yA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2013, Joonyoung Shim wrote:

> Check whether host->sdio_irq_thread is NULL before wake_up_process() is
> called about host->sdio_irq_thread.

Actually, mmc_signal_sdio_irq() shouldn't be called if SDIO IRQ isn't 
used...

Thanks
Guennadi

> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> ---
> Currently the kernel panic to refer NULL pointer about
> host->sdio_irq_thread are occuring at the trats board using Samsung
> SDHCI driver.
> 
>  include/linux/mmc/host.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 61a10c1..2950fea 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -372,7 +372,8 @@ static inline void mmc_signal_sdio_irq(struct mmc_host *host)
>  {
>  	host->ops->enable_sdio_irq(host, 0);
>  	host->sdio_irq_pending = true;
> -	wake_up_process(host->sdio_irq_thread);
> +	if (host->sdio_irq_thread)
> +		wake_up_process(host->sdio_irq_thread);
>  }
>  
>  #ifdef CONFIG_REGULATOR
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
