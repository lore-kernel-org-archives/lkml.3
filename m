Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaIJQYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:24:04 -0400
Received: from [217.140.108.86] ([217.140.108.86]:60841 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751712AbaIJQYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:24:01 -0400
Message-ID: <540DBC0C.7080902@arm.com>
Date: Mon, 08 Sep 2014 15:24:12 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Robert Richter <rrichter@cavium.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] GICv3: Fixing 32 bit compatibility
References: <1410185480-5153-1-git-send-email-rric@kernel.org>
In-Reply-To: <1410185480-5153-1-git-send-email-rric@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On 08/09/14 15:11, Robert Richter wrote:
> From: Robert Richter <rrichter@cavium.com>
> 
> Fixing 32 bit compatibility by using ULL for u64 constants.
> 
> Signed-off-by: Robert Richter <rrichter@cavium.com>
> ---
>  drivers/irqchip/irq-gic-v3.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 57eaa5a0b1e3..9e13c87c7dfe 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -441,7 +441,7 @@ static u16 gic_compute_target_list(int *base_cpu, const struct cpumask *mask,
>  
>  		mpidr = cpu_logical_map(cpu);
>  
> -		if (cluster_id != (mpidr & ~0xffUL)) {
> +		if (cluster_id != (mpidr & ~0xffULL)) {
>  			cpu--;
>  			goto out;
>  		}
> @@ -479,7 +479,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>  	smp_wmb();
>  
>  	for_each_cpu_mask(cpu, *mask) {
> -		u64 cluster_id = cpu_logical_map(cpu) & ~0xffUL;
> +		u64 cluster_id = cpu_logical_map(cpu) & ~0xffULL;
>  		u16 tlist;
>  
>  		tlist = gic_compute_target_list(&cpu, mask, cluster_id);
> 

Yeah, and there are many more. I'm currently sitting on a rather long
queue of GICv3-related 32bit patches. I'll try to get that posted shortly.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
