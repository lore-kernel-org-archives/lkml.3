Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaIKSwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 14:52:55 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:54296 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaIKSwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 14:52:54 -0400
Date: Thu, 11 Sep 2014 14:52:44 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, riel@redhat.com,
        Morten.Rasmussen@arm.com, efault@gmx.de,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 05/12] ARM: topology: use new cpu_capacity interface
In-Reply-To: <1409051215-16788-6-git-send-email-vincent.guittot@linaro.org>
Message-ID: <alpine.LFD.2.11.1409111452170.16533@knanqh.ubzr>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org> <1409051215-16788-6-git-send-email-vincent.guittot@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Vincent Guittot wrote:

> Use the new arch_scale_cpu_capacity in order to reflect the original capacity
> of a CPU instead of arch_scale_freq_capacity which is more linked to a scaling
> of the capacity linked to the frequency.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/kernel/topology.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index e35d880..89cfdd6 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -42,7 +42,7 @@
>   */
>  static DEFINE_PER_CPU(unsigned long, cpu_scale);
>  
> -unsigned long arch_scale_freq_capacity(struct sched_domain *sd, int cpu)
> +unsigned long arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
>  {
>  	return per_cpu(cpu_scale, cpu);
>  }
> @@ -166,7 +166,7 @@ static void update_cpu_capacity(unsigned int cpu)
>  	set_capacity_scale(cpu, cpu_capacity(cpu) / middle_capacity);
>  
>  	printk(KERN_INFO "CPU%u: update cpu_capacity %lu\n",
> -		cpu, arch_scale_freq_capacity(NULL, cpu));
> +		cpu, arch_scale_cpu_capacity(NULL, cpu));
>  }
>  
>  #else
> -- 
> 1.9.1
> 
> 
