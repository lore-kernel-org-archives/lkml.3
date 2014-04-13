Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaDMRj2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:39:28 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:55209 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaDMRj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:39:26 -0400
Date: Sun, 13 Apr 2014 13:39:24 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
cc: linux@arm.linux.org.uk, santosh.shilimkar@ti.com, pawel.moll@arm.com,
        dave.martin@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] arm/mach-vexpress: array accessed out of bounds
In-Reply-To: <1397410311-8313-1-git-send-email-xypron.glpk@gmx.de>
Message-ID: <alpine.LFD.2.11.1404131337580.980@knanqh.ubzr>
References: <1397410311-8313-1-git-send-email-xypron.glpk@gmx.de>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2014, xypron.glpk@gmx.de wrote:

> From: Heinrich Schuchardt <xypron.glpk@gmx.de>
> 
> dcscb_allcpus_mask is an array of size 2.
> 
> The index variable cluster has to be checked against this limit
> before accessing the array.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>

Acked-by: Nicolas Pitre <nico@linaro.org>

Please send it to the ARM-SOC team.


> ---
>  arch/arm/mach-vexpress/dcscb.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-vexpress/dcscb.c b/arch/arm/mach-vexpress/dcscb.c
> index 14d4996..5cbf7fa 100644
> --- a/arch/arm/mach-vexpress/dcscb.c
> +++ b/arch/arm/mach-vexpress/dcscb.c
> @@ -51,12 +51,14 @@ static int dcscb_allcpus_mask[2];
>  static int dcscb_power_up(unsigned int cpu, unsigned int cluster)
>  {
>  	unsigned int rst_hold, cpumask = (1 << cpu);
> -	unsigned int all_mask = dcscb_allcpus_mask[cluster];
> +	unsigned int all_mask;
>  
>  	pr_debug("%s: cpu %u cluster %u\n", __func__, cpu, cluster);
>  	if (cpu >= 4 || cluster >= 2)
>  		return -EINVAL;
>  
> +	all_mask = dcscb_allcpus_mask[cluster];
> +
>  	/*
>  	 * Since this is called with IRQs enabled, and no arch_spin_lock_irq
>  	 * variant exists, we need to disable IRQs manually here.
> @@ -101,11 +103,12 @@ static void dcscb_power_down(void)
>  	cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
>  	cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
>  	cpumask = (1 << cpu);
> -	all_mask = dcscb_allcpus_mask[cluster];
>  
>  	pr_debug("%s: cpu %u cluster %u\n", __func__, cpu, cluster);
>  	BUG_ON(cpu >= 4 || cluster >= 2);
>  
> +	all_mask = dcscb_allcpus_mask[cluster];
> +
>  	__mcpm_cpu_going_down(cpu, cluster);
>  
>  	arch_spin_lock(&dcscb_lock);
> -- 
> 1.7.10.4
> 
