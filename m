Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3CTRHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:07:00 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49513 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3CTRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:06:59 -0400
Message-ID: <5149ECA9.9000100@free-electrons.com>
Date: Wed, 20 Mar 2013 18:06:49 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCHv3 08/10] clocksource: time-armada-370-xp: Fix sparse warning
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org> <1363198676-30417-9-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1363198676-30417-9-git-send-email-sboyd@codeaurora.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 07:17 PM, Stephen Boyd wrote:
> drivers/clocksource/time-armada-370-xp.c:217:13: warning: symbol
> 'armada_370_xp_timer_init' was not declared. Should it be static?
> 
> Also remove the __init marking in the prototype as it's
> unnecessary and drop the init.h file.
> 
> Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/clocksource/time-armada-370-xp.c | 3 ++-
>  include/linux/time-armada-370-xp.h       | 4 +---
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
> index 47a6730..efe4aef 100644
> --- a/drivers/clocksource/time-armada-370-xp.c
> +++ b/drivers/clocksource/time-armada-370-xp.c
> @@ -27,10 +27,11 @@
>  #include <linux/of_address.h>
>  #include <linux/irq.h>
>  #include <linux/module.h>
> +#include <linux/percpu.h>
> +#include <linux/time-armada-370-xp.h>
>  
>  #include <asm/sched_clock.h>
>  #include <asm/localtimer.h>
> -#include <linux/percpu.h>
>  /*
>   * Timer block registers.
>   */
> diff --git a/include/linux/time-armada-370-xp.h b/include/linux/time-armada-370-xp.h
> index dfdfdc0..6fb0856 100644
> --- a/include/linux/time-armada-370-xp.h
> +++ b/include/linux/time-armada-370-xp.h
> @@ -11,8 +11,6 @@
>  #ifndef __TIME_ARMADA_370_XPPRCMU_H
>  #define __TIME_ARMADA_370_XPPRCMU_H
>  
> -#include <linux/init.h>
> -
> -void __init armada_370_xp_timer_init(void);
> +void armada_370_xp_timer_init(void);
>  
>  #endif
> 
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
