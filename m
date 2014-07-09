Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaGIOdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:33:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41312 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaGIOdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:33:36 -0400
Message-ID: <53BD52B1.4060608@ti.com>
Date: Wed, 9 Jul 2014 10:33:21 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, <rjw@rjwysocki.net>,
        <shawn.guo@linaro.org>
CC: <nm@ti.com>, <linaro-kernel@lists.linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <t.figa@samsung.com>,
        <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <thomas.ab@samsung.com>, <arvind.chauhan@arm.com>,
        <spk.linux@gmail.com>
Subject: Re: [PATCH 03/14] cpufreq: Add support for per-policy driver data
References: <cover.1404231535.git.viresh.kumar@linaro.org> <0614df495e361dd23ebe2d4e4ee3d40cb23948da.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <0614df495e361dd23ebe2d4e4ee3d40cb23948da.1404231535.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2014 12:32 PM, Viresh Kumar wrote:
> Drivers supporting multiple clusters or multiple 'struct cpufreq_policy'
> instances may need to keep per-policy data. If the core doesn't support them,
> they might do it in the most unoptimized way: 'per-cpu' data.
> 
> This patch adds another field in 'struct cpufreq_policy': 'driver_data'. It
> isn't accessed by core and is for driver's internal use.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  include/linux/cpufreq.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index ec4112d..d4b1108 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -112,6 +112,9 @@ struct cpufreq_policy {
>  	spinlock_t		transition_lock;
>  	wait_queue_head_t	transition_wait;
>  	struct task_struct	*transition_task; /* Task which is doing the transition */
> +
> +	/* For cpufreq driver's internal use */
> +	void			*driver_data;
>  };
>  
Minor comment for consistency either maintain same commenting style
for the above structure (description after the variable) or may
be clean up the comments in another patch.

Regards,
Santosh

