Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaEYN0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 09:26:46 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44093 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaEYN0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 09:26:45 -0400
Message-ID: <5381EE7C.9010809@linux.vnet.ibm.com>
Date: Sun, 25 May 2014 18:52:04 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH v2 05/11] ARM: topology: use new cpu_power interface
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org> <1400860385-14555-6-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1400860385-14555-6-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052513-1344-0000-0000-000001C7AA25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

Why do we have two interfaces arch_scale_freq_power() and
arch_scale_cpu_power()? Does it make sense to consolidate them now ?

Regards
Preeti U Murthy


On 05/23/2014 09:22 PM, Vincent Guittot wrote:
> Use the new arch_scale_cpu_power in order to reflect the original capacity of
> a CPU instead of arch_scale_freq_power which is more linked to a scaling of
> the capacity linked to the frequency.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  arch/arm/kernel/topology.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index 71e1fec..6cc25a8 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -42,7 +42,7 @@
>   */
>  static DEFINE_PER_CPU(unsigned long, cpu_scale);
> 
> -unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
> +unsigned long arch_scale_cpu_power(struct sched_domain *sd, int cpu)
>  {
>  	return per_cpu(cpu_scale, cpu);
>  }
> @@ -166,7 +166,7 @@ static void update_cpu_power(unsigned int cpu)
>  	set_power_scale(cpu, cpu_capacity(cpu) / middle_capacity);
> 
>  	printk(KERN_INFO "CPU%u: update cpu_power %lu\n",
> -		cpu, arch_scale_freq_power(NULL, cpu));
> +		cpu, arch_scale_cpu_power(NULL, cpu));
>  }
> 
>  #else
> 

