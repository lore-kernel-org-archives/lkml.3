Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaDNTwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:52:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50078 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaDNTwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:52:07 -0400
Message-ID: <534C3C65.1030808@codeaurora.org>
Date: Mon, 14 Apr 2014 12:52:05 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, tglx@linutronix.de
CC: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH 22/38] tick-sched: no need to recheck cpu_online() in
 can_stop_idle_tick()
References: <cover.1397492345.git.viresh.kumar@linaro.org> <74d448a200afd0424fb185e2fb2ac5c31fd6b205.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <74d448a200afd0424fb185e2fb2ac5c31fd6b205.1397492345.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/14 09:23, Viresh Kumar wrote:
> We have already checked if 'cpu' is online or not and so don't need to recheck
> it.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Hm... doing some git archeology shows fa116ea35ec7 (nohz: no softirq
pending warnings for offline cpus, 2008-12-11), where the cpu_online()
check was added. Before that commit we already checked cpu_online()
similar to how the code is today. Perhaps we need to add a comment here?

> ---
>  kernel/time/tick-sched.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 9cbba513..c81b6cf 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -716,7 +716,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>  	if (need_resched())
>  		return false;
>  
> -	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
> +	if (unlikely(local_softirq_pending())) {
>  		static int ratelimit;
>  
>  		if (ratelimit < 10 &&


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

