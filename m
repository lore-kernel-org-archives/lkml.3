Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161505Ab3DGHze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 03:55:34 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:44969 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161460Ab3DGHzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 03:55:33 -0400
Date: Sun, 7 Apr 2013 09:55:26 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AVR32: fix building warnings caused by redifinitions
 of HZ
Message-ID: <20130407075526.GA28026@samfundet.no>
References: <1365266616-8424-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365266616-8424-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sun 07 Apr 2013 00:43:36 +0800 or thereabout, Jiang Liu wrote:
> Fix building warnings caused by redifinitions of HZ:
> In file included from /ws/linux/kernel/linux.git/include/uapi/linux/param.h:4,
>                  from include/linux/timex.h:63,
>                  from include/linux/jiffies.h:8,
>                  from include/linux/ktime.h:25,
>                  from include/linux/timer.h:5,
>                  from include/linux/workqueue.h:8,
>                  from include/linux/srcu.h:34,
>                  from include/linux/notifier.h:15,
>                  from include/linux/memory_hotplug.h:6,
>                  from include/linux/mmzone.h:777,
>                  from include/linux/gfp.h:4,
>                  from arch/avr32/mm/init.c:10:
> /ws/linux/kernel/linux.git/arch/avr32/include/asm/param.h:6:1: warning: "HZ" redefined
> In file included from /ws/linux/kernel/linux.git/arch/avr32/include/asm/param.h:4,
>                  from /ws/linux/kernel/linux.git/include/uapi/linux/param.h:4,
>                  from include/linux/timex.h:63,
>                  from include/linux/jiffies.h:8,
>                  from include/linux/ktime.h:25,
>                  from include/linux/timer.h:5,
>                  from include/linux/workqueue.h:8,
>                  from include/linux/srcu.h:34,
>                  from include/linux/notifier.h:15,
>                  from include/linux/memory_hotplug.h:6,
>                  from include/linux/mmzone.h:777,
>                  from include/linux/gfp.h:4,
>                  from arch/avr32/mm/init.c:10:
> /ws/linux/kernel/linux.git/arch/avr32/include/uapi/asm/param.h:6:1: warning: this is the location of the previous definition

Thanks for fixing.

> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Cc: linux-kernel@vger.kernel.org

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/include/uapi/asm/param.h |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/avr32/include/uapi/asm/param.h b/arch/avr32/include/uapi/asm/param.h
> index d28aa5e..abda103 100644
> --- a/arch/avr32/include/uapi/asm/param.h
> +++ b/arch/avr32/include/uapi/asm/param.h
> @@ -2,7 +2,11 @@
>  #define _UAPI__ASM_AVR32_PARAM_H
>  
>  
> -#ifndef HZ
> +#ifndef __KERNEL__
> +   /*
> +    * Technically, this is wrong, but some old apps still refer to it.
> +    * The proper way to get the HZ value is via sysconf(_SC_CLK_TCK).
> +    */

With this comment, are there AVR32 drivers/users that should be fixed? Or is
it parts of the tree in general?

>  # define HZ		100
>  #endif
>  
-- 
mvh
Hans-Christian Egtvedt
