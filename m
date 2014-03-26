Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaCZMrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:47:49 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43164 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaCZMrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:47:47 -0400
Message-ID: <5332CC4D.9080906@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2014 18:17:09 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH 13/14] timer: simplify CPU_UP_PREPARE notifier code path
References: <cover.1395832156.git.viresh.kumar@linaro.org> <5d9ab05cbefb2dabe660c5ac57432fc097e06291.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <5d9ab05cbefb2dabe660c5ac57432fc097e06291.1395832156.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032612-9264-0000-0000-000005B66603
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 04:51 PM, Viresh Kumar wrote:
> Currently we are returning notifier_from_errno() from CPU_UP_PREPARE notifier
> when we detect an error while calling init_timers_cpu(). notifier_from_errno()
> already has enough checks within to do something similar. And so we can call it
> directly without checking if there was an error or not.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  kernel/timer.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 1d35dda..4360edc 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1646,9 +1646,7 @@ static int timer_cpu_notify(struct notifier_block *self,
>  	case CPU_UP_PREPARE:
>  	case CPU_UP_PREPARE_FROZEN:
>  		err = init_timers_cpu(cpu);
> -		if (err < 0)
> -			return notifier_from_errno(err);
> -		break;
> +		return notifier_from_errno(err);
>  #ifdef CONFIG_HOTPLUG_CPU
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
> 

