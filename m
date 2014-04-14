Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaDNTiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:38:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49272 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaDNTiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:38:19 -0400
Message-ID: <534C3929.8060501@codeaurora.org>
Date: Mon, 14 Apr 2014 12:38:17 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, tglx@linutronix.de
CC: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH 18/38] tick-common: don't set mode to CLOCK_EVT_MODE_UNUSED
 in tick_shutdown()
References: <cover.1397492345.git.viresh.kumar@linaro.org> <25b069afdaa6f28e561caefa74cd62c62974099a.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <25b069afdaa6f28e561caefa74cd62c62974099a.1397492345.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/14 09:23, Viresh Kumar wrote:
> tick_shutdown() calls clockevents_exchange_device() which already sets mode to
> CLOCK_EVT_MODE_UNUSED 

Yes it does.

> and so tick_shutdown() doesn't need to do it.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/time/tick-common.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index bb9a218..3954f4d 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -334,7 +334,6 @@ void tick_shutdown(unsigned int *cpup)
>  		 * Prevent that the clock events layer tries to call
>  		 * the set mode function!
>  		 */
> -		dev->mode = CLOCK_EVT_MODE_UNUSED;

But see the comment above this assignment. The point is to avoid calling
the ->set_mode function.

>  		clockevents_exchange_device(dev, NULL);
>  		dev->event_handler = clockevents_handle_noop;
>  		td->evtdev = NULL;

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

