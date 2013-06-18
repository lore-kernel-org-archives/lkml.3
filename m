Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3FRBUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:20:51 -0400
Received: from ozlabs.org ([203.10.76.45]:51208 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3FRBUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:20:48 -0400
From: Michael Neuling <mikey@neuling.org>
To: Grant Likely <grant.likely@linaro.org>
cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
        Linux PPC dev <linuxppc-dev@ozlabs.org>, sfr@canb.auug.org.au
Subject: Re: [PATCH v2 08/11] irqdomain: Refactor irq_domain_associate_many()
In-reply-to: <1371244086-9189-9-git-send-email-grant.likely@linaro.org>
References: <1371244086-9189-1-git-send-email-grant.likely@linaro.org> <1371244086-9189-9-git-send-email-grant.likely@linaro.org>
Comments: In-reply-to Grant Likely <grant.likely@linaro.org>
   message dated "Fri, 14 Jun 2013 22:08:03 +0100."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Tue, 18 Jun 2013 11:20:45 +1000
Message-ID: <4521.1371518445@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

In next-20130617 we are getting the below crash on POWER7.  Bisecting,
points to this patch (d39046ec72 in next)

Any clues?

Mikey


Using pSeries machine description
Page sizes from device-tree:
base_shift=12: shift=12, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=0
base_shift=24: shift=24, sllp=0x0100, avpnm=0x00000001, tlbiel=0, penc=0
base_shift=16: shift=16, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=1
base_shift=20: shift=20, sllp=0x0111, avpnm=0x00000000, tlbiel=0, penc=2
base_shift=34: shift=34, sllp=0x0120, avpnm=0x000007ff, tlbiel=0, penc=3
Using 1TB segments
Found initrd at 0xc000000002e60000:0xc000000002e60600
CPU maps initialized for 1 thread per core
Starting Linux PPC64 #48 SMP Tue Jun 18 11:10:17 EST 2013
-----------------------------------------------------
ppc64_pft_size                = 0x0
physicalMemorySize            = 0x80000000
htab_address                  = 0xc00000007fe00000
htab_hash_mask                = 0x3fff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpuacct
Linux version 3.10.0-rc5-14354-gd39046e (mikey@ka1) (gcc version 4.6.0 (GCC) ) #48 SMP Tue Jun 18 11:10:17 EST 2013
[boot]0012 Setup Arch
Zone ranges:
  DMA      [mem 0x00000000-0x7fffffff]
  Normal   empty
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00000000-0x7fffffff]
[boot]0015 Setup Done
PERCPU: Embedded 2 pages/cpu @c000000002100000 s88448 r0 d42624 u1048576
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 32740
Policy zone: DMA
Kernel command line: ipr.enabled=0
PID hash table entries: 4096 (order: -1, 32768 bytes)
Sorting __ex_table...
freeing bootmem node 0
Memory: 2061696k/2097152k available (11840k kernel code, 35456k reserved, 1792k data, 1072k bss, 704k init)
SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=256
Hierarchical RCU implementation.
	RCU restricting CPUs from NR_CPUS=2048 to nr_cpu_ids=1.
NR_IRQS:512 nr_irqs:512 16
error: reading the clock failed (-1)
clocksource: timebase mult[86bca1b] shift[23] registered
Console: colour dummy device 80x25
console [tty0] enabled
console [hvc0] enabled
pid_max: default: 32768 minimum: 301
Dentry cache hash table entries: 262144 (order: 5, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 4, 1048576 bytes)
Mount-cache hash table entries: 4096
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
error: hwirq 0x2 is too large for (null)
------------[ cut here ]------------
WARNING: at /scratch/mikey/src/linux-next/kernel/irq/irqdomain.c:276
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc5-14354-gd39046e #48
task: c00000007e500000 ti: c00000007e520000 task.ti: c00000007e520000
NIP: c00000000011433c LR: c000000000114338 CTR: c000000000422310
REGS: c00000007e523780 TRAP: 0700   Not tainted  (3.10.0-rc5-14354-gd39046e)
MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 28000084  XER: 02000000
SOFTE: 1
CFAR: c0000000007b0ab8

GPR00: c000000000114338 c00000007e523a00 c000000000cb9570 0000000000000028 
GPR04: 0000000000000000 0000000000000043 ffffffffffffffff 0000000000000000 
GPR08: 076507200766076f c000000000be3790 0000000000000720 0000000000000000 
GPR12: 0000000028000082 c00000000fe00000 c00000000000be60 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000000000 0000000000000000 0000000000000000 c000000000b704b0 
GPR24: c000000000d44a80 c000000000cb9570 0000000000000010 0000000000000002 
GPR28: c00000007e0c0000 0000000000000000 c00000007e0c0000 c00000007e052400 
NIP [c00000000011433c] .irq_domain_associate+0x1ec/0x260
LR [c000000000114338] .irq_domain_associate+0x1e8/0x260
PACATMSCRATCH [9000000032009032]
Call Trace:
[c00000007e523a00] [c000000000114338] .irq_domain_associate+0x1e8/0x260 (unreliable)
[c00000007e523aa0] [c000000000114bf0] .irq_create_mapping+0xa0/0x170
[c00000007e523b30] [c000000000af4574] .xics_smp_probe+0x38/0xa4
[c00000007e523ba0] [c000000000af7af0] .pSeries_smp_probe+0x10/0x68
[c00000007e523c10] [c000000000aed740] .smp_prepare_cpus+0x20c/0x244
[c00000007e523cd0] [c000000000ae44c0] .kernel_init_freeable+0x138/0x328
[c00000007e523db0] [c00000000000be7c] .kernel_init+0x1c/0x120
[c00000007e523e30] [c00000000000a05c] .ret_from_kernel_thread+0x5c/0x80
Instruction dump:
482ca915 60000000 7fa3eb78 4868ea09 60000000 4bffff7c 3c62ffd5 e8bc0010 
7f6407b4 3863c108 4869c731 60000000 <0fe00000> 3ba0ffea 4bffff7c 3c62ffd5 
---[ end trace 31fd0ba7d8756001 ]---
------------[ cut here ]------------
kernel BUG at /scratch/mikey/src/linux-next/arch/powerpc/sysdev/xics/xics-common.c:134!
cpu 0x0: Vector: 700 (Program Check) at [c00000007e5238b0]
    pc: c000000000af4580: .xics_smp_probe+0x44/0xa4
    lr: c000000000af4574: .xics_smp_probe+0x38/0xa4
    sp: c00000007e523b30
   msr: 9000000000029032
  current = 0xc00000007e500000
  paca    = 0xc00000000fe00000	 softe: 0	 irq_happened: 0x01
    pid   = 1, comm = swapper/0
kernel BUG at /scratch/mikey/src/linux-next/arch/powerpc/sysdev/xics/xics-common.c:134!
enter ? for help
[c00000007e523ba0] c000000000af7af0 .pSeries_smp_probe+0x10/0x68
[c00000007e523c10] c000000000aed740 .smp_prepare_cpus+0x20c/0x244
[c00000007e523cd0] c000000000ae44c0 .kernel_init_freeable+0x138/0x328
[c00000007e523db0] c00000000000be7c .kernel_init+0x1c/0x120
[c00000007e523e30] c00000000000a05c .ret_from_kernel_thread+0x5c/0x80
0:mon>  <no input ...>
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=2048 NUMA pSeries
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.10.0-rc5-14354-gd39046e #48
task: c00000007e500000 ti: c00000007e520000 task.ti: c00000007e520000
NIP: c000000000af4580 LR: c000000000af4574 CTR: 0000000000000002
REGS: c00000007e5238b0 TRAP: 0700   Tainted: G        W     (3.10.0-rc5-14354-gd39046e)
MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 28000084  XER: 02000000
SOFTE: 1
CFAR: c000000000114c1c

GPR00: 0000000000000001 c00000007e523b30 c000000000cb9570 0000000000000000 
GPR04: 0000000000000010 0000000000020000 c00000007e052600 c000000000dcdd10 
GPR08: c000000000b85ac8 fffffffffffeffff 0000000000000001 000000000001ffff 
GPR12: 0000000088000084 c00000000fe00000 c00000000000be60 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000000000 0000000000000000 0000000000000000 c000000000b704b0 
GPR24: c000000000d44a80 c000000000cb9570 c000000000cb9570 c000000000b703b0 
GPR28: c000000000b704b0 c000000000d40858 0000000000004000 0000000000000800 
NIP [c000000000af4580] .xics_smp_probe+0x44/0xa4
LR [c000000000af4574] .xics_smp_probe+0x38/0xa4
PACATMSCRATCH [9000000000029032]
Call Trace:
[c00000007e523b30] [c000000000af4574] .xics_smp_probe+0x38/0xa4 (unreliable)
[c00000007e523ba0] [c000000000af7af0] .pSeries_smp_probe+0x10/0x68
[c00000007e523c10] [c000000000aed740] .smp_prepare_cpus+0x20c/0x244
[c00000007e523cd0] [c000000000ae44c0] .kernel_init_freeable+0x138/0x328
[c00000007e523db0] [c00000000000be7c] .kernel_init+0x1c/0x120
[c00000007e523e30] [c00000000000a05c] .ret_from_kernel_thread+0x5c/0x80
Instruction dump:
39290f80 38800002 e86b0010 f8010010 f821ff91 e80a0028 e9290000 f8090008 
4b6205e1 60000000 7c600074 7800d182 <0b000000> 3d22000d 3ce2ffd3 3929fde0 
---[ end trace 31fd0ba7d8756002 ]---



> Originally, irq_domain_associate_many() was designed to unwind the
> mapped irqs on a failure of any individual association. However, that
> proved to be a problem with certain IRQ controllers. Some of them only
> support a subset of irqs, and will fail when attempting to map a
> reserved IRQ. In those cases we want to map as many IRQs as possible, so
> instead it is better for irq_domain_associate_many() to make a
> best-effort attempt to map irqs, but not fail if any or all of them
> don't succeed. If a caller really cares about how many irqs got
> associated, then it should instead go back and check that all of the
> irqs is cares about were mapped.
> 
> The original design open-coded the individual association code into the
> body of irq_domain_associate_many(), but with no longer needing to
> unwind associations, the code becomes simpler to split out
> irq_domain_associate() to contain the bulk of the logic, and
> irq_domain_associate_many() to be a simple loop wrapper.
> 
> This patch also adds a new error check to the associate path to make
> sure it isn't called for an irq larger than the controller can handle,
> and adds locking so that the irq_domain_mutex is held while setting up a
> new association.
> 
> v2: Fixup x86 warning. irq_domain_associate_many() no longer returns an
>     error code, but reports errors to the printk log directly. In the
>     majority of cases we don't actually want to fail if there is a
>     problem, but rather log it and still try to boot the system.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> ---
>  arch/x86/kernel/devicetree.c |   4 +-
>  include/linux/irqdomain.h    |  22 +++--
>  kernel/irq/irqdomain.c       | 185 +++++++++++++++++++++----------------------
>  3 files changed, 102 insertions(+), 109 deletions(-)
> 
> diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
> index b158152..4934890 100644
> --- a/arch/x86/kernel/devicetree.c
> +++ b/arch/x86/kernel/devicetree.c
> @@ -364,9 +364,7 @@ static void dt_add_ioapic_domain(unsigned int ioapic_num,
>  		 * and assigned so we can keep the 1:1 mapping which the ioapic
>  		 * is having.
>  		 */
> -		ret = irq_domain_associate_many(id, 0, 0, NR_IRQS_LEGACY);
> -		if (ret)
> -			pr_err("Error mapping legacy IRQs: %d\n", ret);
> +		irq_domain_associate_many(id, 0, 0, NR_IRQS_LEGACY);
>  
>  		if (num > NR_IRQS_LEGACY) {
>  			ret = irq_create_strict_mappings(id, NR_IRQS_LEGACY,
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index fd4b26f..f9e8e06 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -103,6 +103,7 @@ struct irq_domain {
>  	struct irq_domain_chip_generic *gc;
>  
>  	/* reverse map data. The linear map gets appended to the irq_domain */
> +	irq_hw_number_t hwirq_max;
>  	unsigned int revmap_direct_max_irq;
>  	unsigned int revmap_size;
>  	struct radix_tree_root revmap_tree;
> @@ -110,8 +111,8 @@ struct irq_domain {
>  };
>  
>  #ifdef CONFIG_IRQ_DOMAIN
> -struct irq_domain *__irq_domain_add(struct device_node *of_node,
> -				    int size, int direct_max,
> +struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
> +				    irq_hw_number_t hwirq_max, int direct_max,
>  				    const struct irq_domain_ops *ops,
>  				    void *host_data);
>  struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
> @@ -140,14 +141,14 @@ static inline struct irq_domain *irq_domain_add_linear(struct device_node *of_no
>  					 const struct irq_domain_ops *ops,
>  					 void *host_data)
>  {
> -	return __irq_domain_add(of_node, size, 0, ops, host_data);
> +	return __irq_domain_add(of_node, size, size, 0, ops, host_data);
>  }
>  static inline struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
>  					 unsigned int max_irq,
>  					 const struct irq_domain_ops *ops,
>  					 void *host_data)
>  {
> -	return __irq_domain_add(of_node, 0, max_irq, ops, host_data);
> +	return __irq_domain_add(of_node, 0, max_irq, max_irq, ops, host_data);
>  }
>  static inline struct irq_domain *irq_domain_add_legacy_isa(
>  				struct device_node *of_node,
> @@ -166,14 +167,11 @@ static inline struct irq_domain *irq_domain_add_tree(struct device_node *of_node
>  
>  extern void irq_domain_remove(struct irq_domain *host);
>  
> -extern int irq_domain_associate_many(struct irq_domain *domain,
> -				     unsigned int irq_base,
> -				     irq_hw_number_t hwirq_base, int count);
> -static inline int irq_domain_associate(struct irq_domain *domain, unsigned int irq,
> -					irq_hw_number_t hwirq)
> -{
> -	return irq_domain_associate_many(domain, irq, hwirq, 1);
> -}
> +extern int irq_domain_associate(struct irq_domain *domain, unsigned int irq,
> +					irq_hw_number_t hwirq);
> +extern void irq_domain_associate_many(struct irq_domain *domain,
> +				      unsigned int irq_base,
> +				      irq_hw_number_t hwirq_base, int count);
>  
>  extern unsigned int irq_create_mapping(struct irq_domain *host,
>  				       irq_hw_number_t hwirq);
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 280b804..80e9249 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -35,8 +35,8 @@ static struct irq_domain *irq_default_domain;
>   * register allocated irq_domain with irq_domain_register().  Returns pointer
>   * to IRQ domain, or NULL on failure.
>   */
> -struct irq_domain *__irq_domain_add(struct device_node *of_node,
> -				    int size, int direct_max,
> +struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
> +				    irq_hw_number_t hwirq_max, int direct_max,
>  				    const struct irq_domain_ops *ops,
>  				    void *host_data)
>  {
> @@ -52,6 +52,7 @@ struct irq_domain *__irq_domain_add(struct device_node *of_node,
>  	domain->ops = ops;
>  	domain->host_data = host_data;
>  	domain->of_node = of_node_get(of_node);
> +	domain->hwirq_max = hwirq_max;
>  	domain->revmap_size = size;
>  	domain->revmap_direct_max_irq = direct_max;
>  
> @@ -126,7 +127,7 @@ struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
>  {
>  	struct irq_domain *domain;
>  
> -	domain = __irq_domain_add(of_node, size, 0, ops, host_data);
> +	domain = __irq_domain_add(of_node, size, size, 0, ops, host_data);
>  	if (!domain)
>  		return NULL;
>  
> @@ -139,7 +140,7 @@ struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
>  				pr_info("Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
>  					first_irq);
>  		}
> -		WARN_ON(irq_domain_associate_many(domain, first_irq, 0, size));
> +		irq_domain_associate_many(domain, first_irq, 0, size);
>  	}
>  
>  	return domain;
> @@ -170,11 +171,12 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
>  {
>  	struct irq_domain *domain;
>  
> -	domain = __irq_domain_add(of_node, first_hwirq + size, 0, ops, host_data);
> +	domain = __irq_domain_add(of_node, first_hwirq + size,
> +				  first_hwirq + size, 0, ops, host_data);
>  	if (!domain)
>  		return NULL;
>  
> -	WARN_ON(irq_domain_associate_many(domain, first_irq, first_hwirq, size));
> +	irq_domain_associate_many(domain, first_irq, first_hwirq, size);
>  
>  	return domain;
>  }
> @@ -228,109 +230,109 @@ void irq_set_default_host(struct irq_domain *domain)
>  }
>  EXPORT_SYMBOL_GPL(irq_set_default_host);
>  
> -static void irq_domain_disassociate_many(struct irq_domain *domain,
> -					 unsigned int irq_base, int count)
> +static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
>  {
> -	/*
> -	 * disassociate in reverse order;
> -	 * not strictly necessary, but nice for unwinding
> -	 */
> -	while (count--) {
> -		int irq = irq_base + count;
> -		struct irq_data *irq_data = irq_get_irq_data(irq);
> -		irq_hw_number_t hwirq;
> +	struct irq_data *irq_data = irq_get_irq_data(irq);
> +	irq_hw_number_t hwirq;
>  
> -		if (WARN_ON(!irq_data || irq_data->domain != domain))
> -			continue;
> +	if (WARN(!irq_data || irq_data->domain != domain,
> +		 "virq%i doesn't exist; cannot disassociate\n", irq))
> +		return;
>  
> -		hwirq = irq_data->hwirq;
> -		irq_set_status_flags(irq, IRQ_NOREQUEST);
> +	hwirq = irq_data->hwirq;
> +	irq_set_status_flags(irq, IRQ_NOREQUEST);
>  
> -		/* remove chip and handler */
> -		irq_set_chip_and_handler(irq, NULL, NULL);
> +	/* remove chip and handler */
> +	irq_set_chip_and_handler(irq, NULL, NULL);
>  
> -		/* Make sure it's completed */
> -		synchronize_irq(irq);
> +	/* Make sure it's completed */
> +	synchronize_irq(irq);
>  
> -		/* Tell the PIC about it */
> -		if (domain->ops->unmap)
> -			domain->ops->unmap(domain, irq);
> -		smp_mb();
> +	/* Tell the PIC about it */
> +	if (domain->ops->unmap)
> +		domain->ops->unmap(domain, irq);
> +	smp_mb();
>  
> -		irq_data->domain = NULL;
> -		irq_data->hwirq = 0;
> +	irq_data->domain = NULL;
> +	irq_data->hwirq = 0;
>  
> -		/* Clear reverse map for this hwirq */
> -		if (hwirq < domain->revmap_size) {
> -			domain->linear_revmap[hwirq] = 0;
> -		} else {
> -			mutex_lock(&revmap_trees_mutex);
> -			radix_tree_delete(&domain->revmap_tree, hwirq);
> -			mutex_unlock(&revmap_trees_mutex);
> -		}
> +	/* Clear reverse map for this hwirq */
> +	if (hwirq < domain->revmap_size) {
> +		domain->linear_revmap[hwirq] = 0;
> +	} else {
> +		mutex_lock(&revmap_trees_mutex);
> +		radix_tree_delete(&domain->revmap_tree, hwirq);
> +		mutex_unlock(&revmap_trees_mutex);
>  	}
>  }
>  
> -int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
> -			      irq_hw_number_t hwirq_base, int count)
> +int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
> +			 irq_hw_number_t hwirq)
>  {
> -	unsigned int virq = irq_base;
> -	irq_hw_number_t hwirq = hwirq_base;
> -	int i, ret;
> +	struct irq_data *irq_data = irq_get_irq_data(virq);
> +	int ret;
>  
> -	pr_debug("%s(%s, irqbase=%i, hwbase=%i, count=%i)\n", __func__,
> -		of_node_full_name(domain->of_node), irq_base, (int)hwirq_base, count);
> +	if (WARN(hwirq >= domain->hwirq_max,
> +		 "error: hwirq 0x%x is too large for %s\n", (int)hwirq, domain->name))
> +		return -EINVAL;
> +	if (WARN(!irq_data, "error: virq%i is not allocated", virq))
> +		return -EINVAL;
> +	if (WARN(irq_data->domain, "error: virq%i is already associated", virq))
> +		return -EINVAL;
>  
> -	for (i = 0; i < count; i++) {
> -		struct irq_data *irq_data = irq_get_irq_data(virq + i);
> -
> -		if (WARN(!irq_data, "error: irq_desc not allocated; "
> -			 "irq=%i hwirq=0x%x\n", virq + i, (int)hwirq + i))
> -			return -EINVAL;
> -		if (WARN(irq_data->domain, "error: irq_desc already associated; "
> -			 "irq=%i hwirq=0x%x\n", virq + i, (int)hwirq + i))
> -			return -EINVAL;
> -	};
> -
> -	for (i = 0; i < count; i++, virq++, hwirq++) {
> -		struct irq_data *irq_data = irq_get_irq_data(virq);
> -
> -		irq_data->hwirq = hwirq;
> -		irq_data->domain = domain;
> -		if (domain->ops->map) {
> -			ret = domain->ops->map(domain, virq, hwirq);
> -			if (ret != 0) {
> -				/*
> -				 * If map() returns -EPERM, this interrupt is protected
> -				 * by the firmware or some other service and shall not
> -				 * be mapped. Don't bother telling the user about it.
> -				 */
> -				if (ret != -EPERM) {
> -					pr_info("%s didn't like hwirq-0x%lx to VIRQ%i mapping (rc=%d)\n",
> -					       domain->name, hwirq, virq, ret);
> -				}
> -				irq_data->domain = NULL;
> -				irq_data->hwirq = 0;
> -				continue;
> +	mutex_lock(&irq_domain_mutex);
> +	irq_data->hwirq = hwirq;
> +	irq_data->domain = domain;
> +	if (domain->ops->map) {
> +		ret = domain->ops->map(domain, virq, hwirq);
> +		if (ret != 0) {
> +			/*
> +			 * If map() returns -EPERM, this interrupt is protected
> +			 * by the firmware or some other service and shall not
> +			 * be mapped. Don't bother telling the user about it.
> +			 */
> +			if (ret != -EPERM) {
> +				pr_info("%s didn't like hwirq-0x%lx to VIRQ%i mapping (rc=%d)\n",
> +				       domain->name, hwirq, virq, ret);
>  			}
> -			/* If not already assigned, give the domain the chip's name */
> -			if (!domain->name && irq_data->chip)
> -				domain->name = irq_data->chip->name;
> +			irq_data->domain = NULL;
> +			irq_data->hwirq = 0;
> +			mutex_unlock(&irq_domain_mutex);
> +			return ret;
>  		}
>  
> -		if (hwirq < domain->revmap_size) {
> -			domain->linear_revmap[hwirq] = virq;
> -		} else {
> -			mutex_lock(&revmap_trees_mutex);
> -			radix_tree_insert(&domain->revmap_tree, hwirq, irq_data);
> -			mutex_unlock(&revmap_trees_mutex);
> -		}
> +		/* If not already assigned, give the domain the chip's name */
> +		if (!domain->name && irq_data->chip)
> +			domain->name = irq_data->chip->name;
> +	}
>  
> -		irq_clear_status_flags(virq, IRQ_NOREQUEST);
> +	if (hwirq < domain->revmap_size) {
> +		domain->linear_revmap[hwirq] = virq;
> +	} else {
> +		mutex_lock(&revmap_trees_mutex);
> +		radix_tree_insert(&domain->revmap_tree, hwirq, irq_data);
> +		mutex_unlock(&revmap_trees_mutex);
>  	}
> +	mutex_unlock(&irq_domain_mutex);
> +
> +	irq_clear_status_flags(virq, IRQ_NOREQUEST);
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(irq_domain_associate);
> +
> +void irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
> +			       irq_hw_number_t hwirq_base, int count)
> +{
> +	int i;
> +
> +	pr_debug("%s(%s, irqbase=%i, hwbase=%i, count=%i)\n", __func__,
> +		of_node_full_name(domain->of_node), irq_base, (int)hwirq_base, count);
> +
> +	for (i = 0; i < count; i++) {
> +		irq_domain_associate(domain, irq_base + i, hwirq_base + i);
> +	}
> +}
>  EXPORT_SYMBOL_GPL(irq_domain_associate_many);
>  
>  /**
> @@ -460,12 +462,7 @@ int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
>  	if (unlikely(ret < 0))
>  		return ret;
>  
> -	ret = irq_domain_associate_many(domain, irq_base, hwirq_base, count);
> -	if (unlikely(ret < 0)) {
> -		irq_free_descs(irq_base, count);
> -		return ret;
> -	}
> -
> +	irq_domain_associate_many(domain, irq_base, hwirq_base, count);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(irq_create_strict_mappings);
> @@ -535,7 +532,7 @@ void irq_dispose_mapping(unsigned int virq)
>  	if (WARN_ON(domain == NULL))
>  		return;
>  
> -	irq_domain_disassociate_many(domain, virq, 1);
> +	irq_domain_disassociate(domain, virq);
>  	irq_free_desc(virq);
>  }
>  EXPORT_SYMBOL_GPL(irq_dispose_mapping);
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
