Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292Ab3CHP3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:29:03 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63919 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816Ab3CHP3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:29:01 -0500
Message-ID: <513A03B7.7000004@linaro.org>
Date: Fri, 08 Mar 2013 16:28:55 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: john.stultz@linaro.org, tglx@linutronix.de,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: viresh.kumar@linaro.org, jacob.jun.pan@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        rickard.andersson@stericsson.com, vincent.guittot@linaro.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 4/4][V2] ARM: timer-sp: Set dynamic irq affinity
References: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org> <1362219013-18173-5-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1362219013-18173-5-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2013 11:10 AM, Daniel Lezcano wrote:
> From: Viresh Kumar <viresh.kumar@linaro.org>
> 
> When a cpu goes to a deep idle state where its local timer is shutdown, it
> notifies the time frame work to use the broadcast timer instead.
> 
> Unfortunately, the broadcast device could wake up any CPU, including an idle one
> which is not concerned by the wake up at all.
> 
> This implies, in the worst case, an idle CPU will wake up to send an IPI to
> another idle cpu.
> 
> This patch fixes this for ARM platforms using timer-sp, by setting
> CLOCK_EVT_FEAT_DYNIRQ feature.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---

Hi Russell,

I asked Thomas if he could take this patch in its tree but it falls
under your umbrella. Thomas agreed to take it if you ack this patch.

Is this patch acceptable for you ?

Thanks in advance
  -- Daniel


>  arch/arm/common/timer-sp.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
> index 9d2d3ba..ae3c0f9 100644
> --- a/arch/arm/common/timer-sp.c
> +++ b/arch/arm/common/timer-sp.c
> @@ -158,7 +158,8 @@ static int sp804_set_next_event(unsigned long next,
>  }
>  
>  static struct clock_event_device sp804_clockevent = {
> -	.features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +	.features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
> +		CLOCK_EVT_FEAT_DYNIRQ,
>  	.set_mode	= sp804_set_mode,
>  	.set_next_event	= sp804_set_next_event,
>  	.rating		= 300,
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

