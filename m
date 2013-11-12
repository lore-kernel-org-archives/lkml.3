Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3KLQ3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:29:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55134 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab3KLQ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:29:46 -0500
Message-ID: <52825779.2050106@linaro.org>
Date: Tue, 12 Nov 2013 17:29:45 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 4/7] clocksource/cadence_ttc: Adjust interval in clock
 notifier
References: <1383945677-29674-1-git-send-email-soren.brinkmann@xilinx.com> <1383945677-29674-5-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1383945677-29674-5-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 10:21 PM, Soren Brinkmann wrote:
> The clockevent has to be reprogrammed if the timer's input
> clock frequency changes and the timer is in periodic mode, in order to
> maintain the correct timer interval.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>   drivers/clocksource/cadence_ttc_timer.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
> index a92350b55d32..68a336038d8f 100644
> --- a/drivers/clocksource/cadence_ttc_timer.c
> +++ b/drivers/clocksource/cadence_ttc_timer.c
> @@ -338,6 +338,10 @@ static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
>   		/* update cached frequency */
>   		ttc->freq = ndata->new_rate;
>
> +		if (ttcce->ce.mode == CLOCK_EVT_MODE_PERIODIC)
> +			ttc_set_interval(ttc, DIV_ROUND_CLOSEST(ttc->freq,
> +						PRESCALE * HZ));
> +

Couldn't be racy ?

>   		/* fall through */
>   	}
>   	case PRE_RATE_CHANGE:
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

