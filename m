Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3H1VRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:17:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40182 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab3H1VRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:17:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Zhang <zhangwm@marvell.com>, Joseph Lo <josephl@nvidia.com>,
        linux-tegra@vger.kernel.org, stable@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 1/3] cpuidle: coupled: disable interrupts after entering safe state
Date: Wed, 28 Aug 2013 23:28:33 +0200
Message-ID: <16805669.URyPi50bbV@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1377287112-12018-1-git-send-email-ccross@android.com>
References: <1377287112-12018-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 23, 2013 12:45:10 PM Colin Cross wrote:
> Calling cpuidle_enter_state is expected to return with interrupts
> enabled, but interrupts must be disabled before starting the
> ready loop synchronization stage.  Call local_irq_disable after
> each call to cpuidle_enter_state for the safe state.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Colin Cross <ccross@android.com>

I've queued up all thress for 3.12, but I wonder what stable versions they
should be included into?  All of them or just a subset?

Rafael


> ---
>  drivers/cpuidle/coupled.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> index 2a297f8..db92bcb 100644
> --- a/drivers/cpuidle/coupled.c
> +++ b/drivers/cpuidle/coupled.c
> @@ -460,6 +460,7 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
>  		}
>  		entered_state = cpuidle_enter_state(dev, drv,
>  			dev->safe_state_index);
> +		local_irq_disable();
>  	}
>  
>  	/* Read barrier ensures online_count is read after prevent is cleared */
> @@ -485,6 +486,7 @@ retry:
>  
>  		entered_state = cpuidle_enter_state(dev, drv,
>  			dev->safe_state_index);
> +		local_irq_disable();
>  	}
>  
>  	if (cpuidle_coupled_clear_pokes(dev->cpu)) {
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
