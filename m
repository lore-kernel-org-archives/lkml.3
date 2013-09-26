Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3IZKmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:42:40 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:37399 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756019Ab3IZKmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:42:39 -0400
Message-ID: <52440EBE.3090304@st.com>
Date: Thu, 26 Sep 2013 11:38:54 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Preeti Murthy <preeti.lkml@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/4] clocksource/arm_global_timer: Set FEAT_PERCPU
 flag
References: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com> <1379530118-22813-3-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1379530118-22813-3-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/13 19:48, Soren Brinkmann wrote:
> The arm_global_timer is a per cpu device. Set the appropriate flag.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  drivers/clocksource/arm_global_timer.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
> index b66c1f3..c639b1a 100644
> --- a/drivers/clocksource/arm_global_timer.c
> +++ b/drivers/clocksource/arm_global_timer.c
> @@ -169,7 +169,8 @@ static int gt_clockevents_init(struct clock_event_device *clk)
>  	int cpu = smp_processor_id();
>  
>  	clk->name = "arm_global_timer";
> -	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
> +	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
> +		CLOCK_EVT_FEAT_PERCPU;
>  	clk->set_mode = gt_clockevent_set_mode;
>  	clk->set_next_event = gt_clockevent_set_next_event;
>  	clk->cpumask = cpumask_of(cpu);
> 

Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

