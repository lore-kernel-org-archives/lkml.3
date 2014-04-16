Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaDPIvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:51:10 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31392 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaDPIvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:51:06 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-ed-534e4476136a
Content-transfer-encoding: 8BIT
Message-id: <1397638263.6147.7.camel@AMDC1943>
Subject: Re: [PATCH 1/3] clocksource: exynos_mct: Fix stall after CPU
 hotplugging
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, stable@vger.kernel.org
Date: Wed, 16 Apr 2014 10:51:03 +0200
In-reply-to: <alpine.DEB.2.02.1404151753090.22697@ionos.tec.linutronix.de>
References: <1396011962-4467-1-git-send-email-k.kozlowski@samsung.com>
 <1397554445.29169.21.camel@AMDC1943> <534D25DC.4050400@linaro.org>
 <1397566023.29169.31.camel@AMDC1943>
 <alpine.DEB.2.02.1404151711250.22697@ionos.tec.linutronix.de>
 <1397576515.752.5.camel@AMDC1943>
 <alpine.DEB.2.02.1404151753090.22697@ionos.tec.linutronix.de>
X-Mailer: Evolution 3.8.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xK7plLn7BBv2vTS02zljPajHvs6xF
	74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7JYe+Quu8WCjY8YLdbPeM1isXnTVGYHbo871/aw
	ebw7d47dY/OSeo++LasYPT5vkgtgjeKySUnNySxLLdK3S+DKOLbxEEvBbOeK4//3MTYwLjXt
	YuTkkBAwkeg7cJodwhaTuHBvPVsXIxeHkMBSRomL766zgiR4BQQlfky+x9LFyMHBLCAvceRS
	NkiYWUBdYtK8RcwQ9Z8ZJfo/r2KBqNeTWNR8nQnEFhYIlvh7eiPYAjYBY4nNy5ewgdgiAhoS
	Gy/dAmtmFuhllnh59QQjSIJFQFXiVutCMJtTwEvi98sTYA1CAteYJBrfWkFcqiRxbt0axgmM
	ArOQ3DcL4b5ZSO5bwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkEr7uYFx6zOoQowAH
	oxIP74wc32Ah1sSy4srcQ4wSHMxKIrwKRn7BQrwpiZVVqUX58UWlOanFhxiZODilGhh7txqt
	sXJc/nPV6cbHpjdeu8a9X3Rieujng1dcFlhxPt5z2e7GlReKbItubjZJVVo1TcDK+Z7TN/Uw
	Tb8XHwqyr3FPf748gmV++evIL/GB1/RsajfuNzXhjOd86qppbTG1PD36pNIN7vXh2lnPuyzs
	ztktOHZpnfASl1UH5K37bmxbJLkw4ekXJZbijERDLeai4kQAxiaLgGICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-04-15 at 18:20 +0200, Thomas Gleixner wrote:
> B1;3202;0cOn Tue, 15 Apr 2014, Krzysztof Kozlowski wrote:
> > On wto, 2014-04-15 at 17:20 +0200, Thomas Gleixner wrote:
> > > On Tue, 15 Apr 2014, Krzysztof Kozlowski wrote:
> > > 
> > > > On wto, 2014-04-15 at 14:28 +0200, Daniel Lezcano wrote:
> > > > > On 04/15/2014 11:34 AM, Krzysztof Kozlowski wrote:
> > > > > > On pią, 2014-03-28 at 14:06 +0100, Krzysztof Kozlowski wrote:
> > > > > >> Fix stall after hotplugging CPU1. Affected are SoCs where Multi Core Timer
> > > > > >> interrupts are shared (SPI), e.g. Exynos 4210. The stall was a result of
> > > > > >> starting the CPU1 local timer not in L1 timer but in L0 (which is used
> > > > > >> by CPU0).
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > Do you have any comments on these 3 patches? They fix the CPU stall on
> > > > > > Exynos4210 and also on Exynos3250 (Chanwoo Choi sent patches for it
> > > > > > recently).
> > > > > 
> > > > > You describe this issue as impacting different SoC not only the exynos, 
> > > > > right ?
> > > > >
> > > > > Do you know what other SoCs are impacted by this ?
> > > > 
> > > > No, affected are only Exynos SoC-s. It was confirmed on Exynos4210
> > > > (Trats board) and Exynos3250 (new SoC, patches for it were recently
> > > > posted by Chanwoo).
> > > > 
> > > > Other Exynos SoC-s where MCT local timers use shared interrupts (SPI)
> > > > can also be affected. Candidates are Exynos 5250 and 5420 but I haven't
> > > > tested them.
> > > > 
> > > > > I guess this issue is not reproducible just with the line below, we need 
> > > > > a timer to expire right at the moment CPU1 is hotplugged, right ?
> > > > 
> > > > Right. The timer must fire in short time between enabling local timer
> > > > for CPU1 and setting the affinity for IRQ.
> > > 
> > > Why do you set the affinity in the CPU_ONLINE hotplug callback and not
> > > right away when the interrupt is requested?
> > 
> > Hi,
> > 
> > I think the problem in such code is in GIC. The gic_set_affinity() uses
> > cpu_online_mask:
> > 	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
> > In that time this CPU is not present in that mask so -EINVAL would be
> > returned.
> 
> Hmm, indeed. Stupid me.
> 
> Here is a complete solution to the problem. We really want the drivers
> to be fast and clean and not work around such issues.
> 
> I'm quite happy that I kept the 'force' argument of set_affinity
> callbacks. I knew that I'd need it at some point.
> 
> So with the flag set we can disable the online mask check and force
> the interrupt to the proper cpu.

Thanks for the solution.

I tested your patch on Exynos 3250 and it is still not sufficient. After
hotplugging CPU1 ~10 times the stall happens (set_next_event is called
on wrong CPU).

The patch 3/3 ("clocksource: exynos_mct: Fix too early ISR fire up on
wrong CPU") is needed as the clockevents_config_and_register should be
called a little later.

Do you have rest of patches (2/3 and 3/3) or should I resend them?

And one minor nit in your patch: 'cpu' local variable in
exynos4_mct_cpu_notify() is no longer used so it can be removed.

Best regards,
Krzysztof


> Thanks,
> 
> 	tglx
> 
> Index: linux-2.6/drivers/clocksource/exynos_mct.c
> ===================================================================
> --- linux-2.6.orig/drivers/clocksource/exynos_mct.c
> +++ linux-2.6/drivers/clocksource/exynos_mct.c
> @@ -430,6 +430,7 @@ static int exynos4_local_timer_setup(str
>  				evt->irq);
>  			return -EIO;
>  		}
> +		irq_force_affinity(mct_irqs[MCT_L0_IRQ + cpu], cpumask_of(cpu));
>  	} else {
>  		enable_percpu_irq(mct_irqs[MCT_L0_IRQ], 0);
>  	}
> @@ -461,12 +462,6 @@ static int exynos4_mct_cpu_notify(struct
>  		mevt = this_cpu_ptr(&percpu_mct_tick);
>  		exynos4_local_timer_setup(&mevt->evt);
>  		break;
> -	case CPU_ONLINE:
> -		cpu = (unsigned long)hcpu;
> -		if (mct_int_type == MCT_INT_SPI)
> -			irq_set_affinity(mct_irqs[MCT_L0_IRQ + cpu],
> -						cpumask_of(cpu));
> -		break;
>  	case CPU_DYING:
>  		mevt = this_cpu_ptr(&percpu_mct_tick);
>  		exynos4_local_timer_stop(&mevt->evt);
> Index: linux-2.6/drivers/irqchip/irq-gic.c
> ===================================================================
> --- linux-2.6.orig/drivers/irqchip/irq-gic.c
> +++ linux-2.6/drivers/irqchip/irq-gic.c
> @@ -246,10 +246,14 @@ static int gic_set_affinity(struct irq_d
>  			    bool force)
>  {
>  	void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
> -	unsigned int shift = (gic_irq(d) % 4) * 8;
> -	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
> +	unsigned int cpu, shift = (gic_irq(d) % 4) * 8;
>  	u32 val, mask, bit;
>  
> +	if (!force)
> +		cpu = cpumask_any_and(mask_val, cpu_online_mask);
> +	else
> +		cpu = cpumask_first(mask_val);
> +
>  	if (cpu >= NR_GIC_CPU_IF || cpu >= nr_cpu_ids)
>  		return -EINVAL;
>  
> Index: linux-2.6/include/linux/interrupt.h
> ===================================================================
> --- linux-2.6.orig/include/linux/interrupt.h
> +++ linux-2.6/include/linux/interrupt.h
> @@ -204,6 +204,7 @@ static inline int check_wakeup_irqs(void
>  extern cpumask_var_t irq_default_affinity;
>  
>  extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
> +extern int irq_force_affinity(unsigned int irq, const struct cpumask *cpumask);
>  extern int irq_can_set_affinity(unsigned int irq);
>  extern int irq_select_affinity(unsigned int irq);
>  
> Index: linux-2.6/kernel/irq/manage.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/manage.c
> +++ linux-2.6/kernel/irq/manage.c
> @@ -180,7 +180,7 @@ int irq_do_set_affinity(struct irq_data
>  	struct irq_chip *chip = irq_data_get_irq_chip(data);
>  	int ret;
>  
> -	ret = chip->irq_set_affinity(data, mask, false);
> +	ret = chip->irq_set_affinity(data, mask, force);
>  	switch (ret) {
>  	case IRQ_SET_MASK_OK:
>  		cpumask_copy(data->affinity, mask);
> @@ -192,7 +192,8 @@ int irq_do_set_affinity(struct irq_data
>  	return ret;
>  }
>  
> -int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
> +static int irq_do_set_affinity_locked(struct irq_data *data,
> +				      const struct cpumask *mask, bool force)
>  {
>  	struct irq_chip *chip = irq_data_get_irq_chip(data);
>  	struct irq_desc *desc = irq_data_to_desc(data);
> @@ -202,7 +203,7 @@ int __irq_set_affinity_locked(struct irq
>  		return -EINVAL;
>  
>  	if (irq_can_move_pcntxt(data)) {
> -		ret = irq_do_set_affinity(data, mask, false);
> +		ret = irq_do_set_affinity(data, mask, force);
>  	} else {
>  		irqd_set_move_pending(data);
>  		irq_copy_pending(desc, mask);
> @@ -217,13 +218,13 @@ int __irq_set_affinity_locked(struct irq
>  	return ret;
>  }
>  
> -/**
> - *	irq_set_affinity - Set the irq affinity of a given irq
> - *	@irq:		Interrupt to set affinity
> - *	@mask:		cpumask
> - *
> - */
> -int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
> +int __irq_set_affinity_locked(struct irq_data *data,const struct cpumask *mask)
> +{
> +	return irq_do_set_affinity_locked(data, mask, false);
> +}
> +
> +static int __irq_set_affinity(unsigned int irq, const struct cpumask *mask,
> +			      bool force)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);
>  	unsigned long flags;
> @@ -233,11 +234,33 @@ int irq_set_affinity(unsigned int irq, c
>  		return -EINVAL;
>  
>  	raw_spin_lock_irqsave(&desc->lock, flags);
> -	ret =  __irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask);
> +	ret = irq_do_set_affinity_locked(irq_desc_get_irq_data(desc), mask,
> +					 force);
>  	raw_spin_unlock_irqrestore(&desc->lock, flags);
>  	return ret;
>  }
>  
> +/**
> + *	irq_force_affinity - Force the irq affinity of a given irq
> + *	@irq:		Interrupt to set affinity
> + *	@mask:		cpumask
> + */
> +int irq_force_affinity(unsigned int irq, const struct cpumask *mask)
> +{
> +	return __irq_set_affinity(irq, mask, true);
> +}
> +
> +/**
> + *	irq_set_affinity - Set the irq affinity of a given irq
> + *	@irq:		Interrupt to set affinity
> + *	@mask:		cpumask
> + *
> + */
> +int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
> +{
> +	return __irq_set_affinity(irq, mask, false);
> +}
> +
>  int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
>  {
>  	unsigned long flags;

