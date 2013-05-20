Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab3ETVz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:55:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17762 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab3ETVzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:55:55 -0400
X-IronPort-AV: E=Sophos;i="4.87,709,1363158000"; 
   d="scan'208";a="49077607"
Message-ID: <519A9BEA.1010404@codeaurora.org>
Date: Mon, 20 May 2013 14:55:54 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv6 03/11] ARM: smp: Remove duplicate dummy timer implementation
References: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org> <1368473175-4841-4-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1368473175-4841-4-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/13 12:26, Stephen Boyd wrote:
> Drop ARM's version of the dummy timer now that we have a generic
> implementation in drivers/clocksource.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Russell, can you please ack this patch and patch #11?

> ---
>  arch/arm/kernel/smp.c | 22 ++--------------------
>  1 file changed, 2 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 47ab905..4dc883a 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -503,24 +503,6 @@ void tick_broadcast(const struct cpumask *mask)
>  }
>  #endif
>  
> -static void broadcast_timer_set_mode(enum clock_event_mode mode,
> -	struct clock_event_device *evt)
> -{
> -}
> -
> -static void __cpuinit broadcast_timer_setup(struct clock_event_device *evt)
> -{
> -	evt->name	= "dummy_timer";
> -	evt->features	= CLOCK_EVT_FEAT_ONESHOT |
> -			  CLOCK_EVT_FEAT_PERIODIC |
> -			  CLOCK_EVT_FEAT_DUMMY;
> -	evt->rating	= 100;
> -	evt->mult	= 1;
> -	evt->set_mode	= broadcast_timer_set_mode;
> -
> -	clockevents_register_device(evt);
> -}
> -
>  static struct local_timer_ops *lt_ops;
>  
>  #ifdef CONFIG_LOCAL_TIMERS
> @@ -544,8 +526,8 @@ static void __cpuinit percpu_timer_setup(void)
>  
>  	evt->cpumask = cpumask_of(cpu);
>  
> -	if (!lt_ops || lt_ops->setup(evt))
> -		broadcast_timer_setup(evt);
> +	if (lt_ops)
> +		lt_ops->setup(evt);
>  }
>  
>  #ifdef CONFIG_HOTPLUG_CPU


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

