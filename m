Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab3KRSY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:24:27 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:37370 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab3KRSYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:24:22 -0500
Message-ID: <528A5498.4030501@st.com>
Date: Mon, 18 Nov 2013 17:55:36 +0000
From: Stuart MENEFY <stuart.menefy@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 1/4] clocksource: arm_global_timer: Switch to sched_clock_register()
References: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org> <1384559315-18699-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1384559315-18699-2-git-send-email-sboyd@codeaurora.org>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, thanks.

Acked-by: Stuart Menefy <stuart.menefy@st.com>

On 15/11/13 23:48, Stephen Boyd wrote:
> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> the 64 bit function to allow us to remove the 32 bit registration
> interface. While we're here increase the number of bits that
> sched_clock can handle to 64 to make full use of the counter.
> 
> Cc: Stuart Menefy <stuart.menefy@st.com>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/clocksource/arm_global_timer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
> index c639b1a..0fc31d0 100644
> --- a/drivers/clocksource/arm_global_timer.c
> +++ b/drivers/clocksource/arm_global_timer.c
> @@ -202,7 +202,7 @@ static struct clocksource gt_clocksource = {
>  };
>  
>  #ifdef CONFIG_CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
> -static u32 notrace gt_sched_clock_read(void)
> +static u64 notrace gt_sched_clock_read(void)
>  {
>  	return gt_counter_read();
>  }
> @@ -217,7 +217,7 @@ static void __init gt_clocksource_init(void)
>  	writel(GT_CONTROL_TIMER_ENABLE, gt_base + GT_CONTROL);
>  
>  #ifdef CONFIG_CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
> -	setup_sched_clock(gt_sched_clock_read, 32, gt_clk_rate);
> +	sched_clock_register(gt_sched_clock_read, 64, gt_clk_rate);
>  #endif
>  	clocksource_register_hz(&gt_clocksource, gt_clk_rate);
>  }
> 


