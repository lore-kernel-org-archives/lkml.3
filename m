Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966303Ab3HHTdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:33:09 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:46531
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966268Ab3HHTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:33:00 -0400
X-IronPort-AV: E=Sophos;i="4.89,841,1367964000"; 
   d="scan'208";a="23548391"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: convert comma to semicolon
Date: Thu,  8 Aug 2013 21:32:52 +0200
Message-Id: <1375990372-19033-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1375990372-19033-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1375990372-19033-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace a comma between expression statements by a semicolon.

The rule is quite conservative in that it only finds cases where this
pattern appears after a statement that ends with a semicolon, to ensure
that the expression statements do not form an if branch or loop body that
would require adding braces.  This leads to some false negatives, some of
which are apparent in the context code of the patch.  To have a patch that
is entirely machine generated, these false negatives are left untouched,
but could be fixed by other rules.

The patched kernel has been compiled, and there is no change in the object
code for the files that it was possible to compile.

A simplified version of the semantic patch that performs this
transformation is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression e1,e2,e;
type T;
identifier i;
@@

(
T i = ...;
|
 e;
)
 e1
-,
+;
 e2;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Tested-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index f2360a7..c41b5ec 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -246,7 +246,7 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
 		childstack->r26 = (unsigned long) ret_from_kernel_thread;
 		childstack->r9 = usp;	/* function */
 		childstack->r10 = arg;
-		childregs->hae = alpha_mv.hae_cache,
+		childregs->hae = alpha_mv.hae_cache;
 		childti->pcb.usp = 0;
 		return 0;
 	}
diff --git a/arch/arm/mach-davinci/pm.c b/arch/arm/mach-davinci/pm.c
index a508fe5..03e2269 100644
--- a/arch/arm/mach-davinci/pm.c
+++ b/arch/arm/mach-davinci/pm.c
@@ -58,7 +58,7 @@ static void davinci_pm_suspend(void)
 
 	/* Configure sleep count in deep sleep register */
 	val = __raw_readl(pdata->deepsleep_reg);
-	val &= ~DEEPSLEEP_SLEEPCOUNT_MASK,
+	val &= ~DEEPSLEEP_SLEEPCOUNT_MASK;
 	val |= pdata->sleepcount;
 	__raw_writel(val, pdata->deepsleep_reg);
 
diff --git a/arch/arm/mach-pxa/eseries.c b/arch/arm/mach-pxa/eseries.c
index 8280ebc..1da3f9a 100644
--- a/arch/arm/mach-pxa/eseries.c
+++ b/arch/arm/mach-pxa/eseries.c
@@ -550,7 +550,7 @@ static void __init e740_init(void)
 	pxa_set_stuart_info(NULL);
 	eseries_register_clks();
 	clk_add_alias("CLK_CK48M", e740_t7l66xb_device.name,
-			"UDCCLK", &pxa25x_device_udc.dev),
+			"UDCCLK", &pxa25x_device_udc.dev);
 	eseries_get_tmio_gpios();
 	platform_add_devices(ARRAY_AND_SIZE(e740_devices));
 	pxa_set_ac97_info(NULL);
@@ -749,7 +749,7 @@ static void __init e750_init(void)
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
 	clk_add_alias("CLK_CK3P6MI", e750_tc6393xb_device.name,
-			"GPIO11_CLK", NULL),
+			"GPIO11_CLK", NULL);
 	eseries_get_tmio_gpios();
 	platform_add_devices(ARRAY_AND_SIZE(e750_devices));
 	pxa_set_ac97_info(NULL);
@@ -962,7 +962,7 @@ static void __init e800_init(void)
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
 	clk_add_alias("CLK_CK3P6MI", e800_tc6393xb_device.name,
-			"GPIO11_CLK", NULL),
+			"GPIO11_CLK", NULL);
 	eseries_get_tmio_gpios();
 	platform_add_devices(ARRAY_AND_SIZE(e800_devices));
 	pxa_set_ac97_info(NULL);
diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
index 2513d8f..b9da4ae 100644
--- a/arch/arm/mach-pxa/z2.c
+++ b/arch/arm/mach-pxa/z2.c
@@ -527,7 +527,7 @@ static int z2_lbs_spi_setup(struct spi_device *spi)
 	mdelay(180);
 
 	spi->bits_per_word = 16;
-	spi->mode = SPI_MODE_2,
+	spi->mode = SPI_MODE_2;
 
 	spi_setup(spi);
 
diff --git a/arch/arm/plat-samsung/s5p-irq-gpioint.c b/arch/arm/plat-samsung/s5p-irq-gpioint.c
index fafdb05..fa3696b 100644
--- a/arch/arm/plat-samsung/s5p-irq-gpioint.c
+++ b/arch/arm/plat-samsung/s5p-irq-gpioint.c
@@ -160,7 +160,7 @@ static __init int s5p_gpioint_add(struct samsung_gpio_chip *chip)
 	ct->chip.irq_ack = irq_gc_ack_set_bit;
 	ct->chip.irq_mask = irq_gc_mask_set_bit;
 	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
-	ct->chip.irq_set_type = s5p_gpioint_set_type,
+	ct->chip.irq_set_type = s5p_gpioint_set_type;
 	ct->regs.ack = PEND_OFFSET + REG_OFFSET(group - bank->start);
 	ct->regs.mask = MASK_OFFSET + REG_OFFSET(group - bank->start);
 	ct->regs.type = CON_OFFSET + REG_OFFSET(group - bank->start);
diff --git a/arch/mips/kernel/cevt-txx9.c b/arch/mips/kernel/cevt-txx9.c
index 2ae0846..adf440f 100644
--- a/arch/mips/kernel/cevt-txx9.c
+++ b/arch/mips/kernel/cevt-txx9.c
@@ -168,7 +168,7 @@ void __init txx9_clockevent_init(unsigned long baseaddr, int irq,
 		clockevent_delta2ns(0xffffffff >> (32 - TXX9_TIMER_BITS), cd);
 	cd->min_delta_ns = clockevent_delta2ns(0xf, cd);
 	cd->irq = irq;
-	cd->cpumask = cpumask_of(0),
+	cd->cpumask = cpumask_of(0);
 	clockevents_register_device(cd);
 	setup_irq(irq, &txx9tmr_irq);
 	printk(KERN_INFO "TXx9: clockevent device at 0x%lx, irq %d\n",
diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 1765bab..6cdf21a 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -1428,8 +1428,8 @@ static int __init vpe_module_init(void)
 	}
 
 	device_initialize(&vpe_device);
-	vpe_device.class	= &vpe_class,
-	vpe_device.parent	= NULL,
+	vpe_device.class	= &vpe_class;
+	vpe_device.parent	= NULL;
 	dev_set_name(&vpe_device, "vpe1");
 	vpe_device.devt = MKDEV(major, minor);
 	err = device_add(&vpe_device);
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 5f90b85..f94d02e 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -540,7 +540,7 @@ static void __init print_out_mtrr_range_state(void)
 
 		size_base = to_size_factor(size_base, &size_factor),
 		start_base = range_state[i].base_pfn << (PAGE_SHIFT - 10);
-		start_base = to_size_factor(start_base, &start_factor),
+		start_base = to_size_factor(start_base, &start_factor);
 		type = range_state[i].type;
 
 		printk(KERN_DEBUG "reg %d, base: %ld%cB, range: %ld%cB, type %s\n",
diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index 30629a3..d55f99d 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -418,12 +418,12 @@ void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 	pc_host->pci_ops.read = bcma_core_pci_hostmode_read_config;
 	pc_host->pci_ops.write = bcma_core_pci_hostmode_write_config;
 
-	pc_host->mem_resource.name = "BCMA PCIcore external memory",
+	pc_host->mem_resource.name = "BCMA PCIcore external memory";
 	pc_host->mem_resource.start = BCMA_SOC_PCI_DMA;
 	pc_host->mem_resource.end = BCMA_SOC_PCI_DMA + BCMA_SOC_PCI_DMA_SZ - 1;
 	pc_host->mem_resource.flags = IORESOURCE_MEM | IORESOURCE_PCI_FIXED;
 
-	pc_host->io_resource.name = "BCMA PCIcore external I/O",
+	pc_host->io_resource.name = "BCMA PCIcore external I/O";
 	pc_host->io_resource.start = 0x100;
 	pc_host->io_resource.end = 0x7FF;
 	pc_host->io_resource.flags = IORESOURCE_IO | IORESOURCE_PCI_FIXED;
diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index 779f0ab..a7d8e32 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -425,7 +425,7 @@ static int agp_amdk7_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 
 	bridge->driver = &amd_irongate_driver;
-	bridge->dev_private_data = &amd_irongate_private,
+	bridge->dev_private_data = &amd_irongate_private;
 	bridge->dev = pdev;
 	bridge->capndx = cap_ptr;
 
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index be42a23..2f1b432 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -375,7 +375,7 @@ static int agp_nvidia_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 
 	bridge->driver = &nvidia_driver;
-	bridge->dev_private_data = &nvidia_private,
+	bridge->dev_private_data = &nvidia_private;
 	bridge->dev = pdev;
 	bridge->capndx = cap_ptr;
 
diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
index 9b163b4..63cd1bf 100644
--- a/drivers/char/agp/sworks-agp.c
+++ b/drivers/char/agp/sworks-agp.c
@@ -511,7 +511,7 @@ static int agp_serverworks_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 
 	bridge->driver = &sworks_driver;
-	bridge->dev_private_data = &serverworks_private,
+	bridge->dev_private_data = &serverworks_private;
 	bridge->dev = pci_dev_get(pdev);
 
 	pci_set_drvdata(pdev, bridge);
diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index 6a86b6f..b8f38dc 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -153,9 +153,9 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 	mxc_rng->dev = &pdev->dev;
 	mxc_rng->rng.name = "mxc-rnga";
 	mxc_rng->rng.init = mxc_rnga_init;
-	mxc_rng->rng.cleanup = mxc_rnga_cleanup,
-	mxc_rng->rng.data_present = mxc_rnga_data_present,
-	mxc_rng->rng.data_read = mxc_rnga_data_read,
+	mxc_rng->rng.cleanup = mxc_rnga_cleanup;
+	mxc_rng->rng.data_present = mxc_rnga_data_present;
+	mxc_rng->rng.data_read = mxc_rnga_data_read;
 
 	mxc_rng->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(mxc_rng->clk)) {
diff --git a/drivers/clocksource/metag_generic.c b/drivers/clocksource/metag_generic.c
index 9e4db41..3eb3a6c 100644
--- a/drivers/clocksource/metag_generic.c
+++ b/drivers/clocksource/metag_generic.c
@@ -124,13 +124,13 @@ static void arch_timer_setup(unsigned int cpu)
 
 	sprintf(name, "META %d", cpu);
 	clk->name = name;
-	clk->features = CLOCK_EVT_FEAT_ONESHOT,
+	clk->features = CLOCK_EVT_FEAT_ONESHOT;
 
-	clk->rating = 200,
-	clk->shift = 12,
-	clk->irq = tbisig_map(TBID_SIGNUM_TRT),
-	clk->set_mode = metag_timer_set_mode,
-	clk->set_next_event = metag_timer_set_next_event,
+	clk->rating = 200;
+	clk->shift = 12;
+	clk->irq = tbisig_map(TBID_SIGNUM_TRT);
+	clk->set_mode = metag_timer_set_mode;
+	clk->set_next_event = metag_timer_set_next_event;
 
 	clk->mult = div_sc(hwtimer_freq, NSEC_PER_SEC, clk->shift);
 	clk->max_delta_ns = clockevent_delta2ns(0x7fffffff, clk);
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 847cab6..8149b7b 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -175,10 +175,10 @@ static int armada_370_xp_timer_setup(struct clock_event_device *evt)
 	evt->name		= "armada_370_xp_per_cpu_tick",
 	evt->features		= CLOCK_EVT_FEAT_ONESHOT |
 				  CLOCK_EVT_FEAT_PERIODIC;
-	evt->shift		= 32,
-	evt->rating		= 300,
-	evt->set_next_event	= armada_370_xp_clkevt_next_event,
-	evt->set_mode		= armada_370_xp_clkevt_mode,
+	evt->shift		= 32;
+	evt->rating		= 300;
+	evt->set_next_event	= armada_370_xp_clkevt_next_event;
+	evt->set_mode		= armada_370_xp_clkevt_mode;
 	evt->irq		= armada_370_xp_clkevt_irq;
 	evt->cpumask		= cpumask_of(cpu);
 
diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 93061a4..c86d8e0 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -366,7 +366,7 @@ static int __init us2e_freq_init(void)
 		driver->target = us2e_freq_target;
 		driver->get = us2e_freq_get;
 		driver->exit = us2e_freq_cpu_exit;
-		driver->owner = THIS_MODULE,
+		driver->owner = THIS_MODULE;
 		strcpy(driver->name, "UltraSPARC-IIe");
 
 		cpufreq_us2e_driver = driver;
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index 880ee29..dd724db 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -227,7 +227,7 @@ static int __init us3_freq_init(void)
 		driver->target = us3_freq_target;
 		driver->get = us3_freq_get;
 		driver->exit = us3_freq_cpu_exit;
-		driver->owner = THIS_MODULE,
+		driver->owner = THIS_MODULE;
 		strcpy(driver->name, "UltraSPARC-III");
 
 		cpufreq_us3_driver = driver;
diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index a33243c..02e3cbc 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -59,7 +59,7 @@ void set_dynamic_sa_command_1(struct dynamic_sa_ctl *sa, u32 cm, u32 hmac_mc,
 	sa->sa_command_1.w = 0;
 	sa->sa_command_1.bf.crypto_mode31 = (cm & 4) >> 2;
 	sa->sa_command_1.bf.crypto_mode9_8 = cm & 3;
-	sa->sa_command_1.bf.feedback_mode = cfb,
+	sa->sa_command_1.bf.feedback_mode = cfb;
 	sa->sa_command_1.bf.sa_rev = 1;
 	sa->sa_command_1.bf.extended_seq_num = esn;
 	sa->sa_command_1.bf.seq_num_mask = sn_mask;
diff --git a/drivers/crypto/dcp.c b/drivers/crypto/dcp.c
index a8a7dd4..712db7e 100644
--- a/drivers/crypto/dcp.c
+++ b/drivers/crypto/dcp.c
@@ -819,9 +819,9 @@ static int dcp_probe(struct platform_device *pdev)
 	dev->watchdog.function = &dcp_watchdog;
 	dev->watchdog.data = (unsigned long)dev;
 
-	dev->dcp_bootstream_misc.minor = MISC_DYNAMIC_MINOR,
-	dev->dcp_bootstream_misc.name = "dcpboot",
-	dev->dcp_bootstream_misc.fops = &dcp_bootstream_fops,
+	dev->dcp_bootstream_misc.minor = MISC_DYNAMIC_MINOR;
+	dev->dcp_bootstream_misc.name = "dcpboot";
+	dev->dcp_bootstream_misc.fops = &dcp_bootstream_fops;
 	ret = misc_register(&dev->dcp_bootstream_misc);
 	if (ret != 0) {
 		dev_err(dev->dev, "Unable to register misc device\n");
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 12fea3e..d3737da 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -825,8 +825,8 @@ static int hifn_register_rng(struct hifn_device *dev)
 						   dev->pk_clk_freq) * 256;
 
 	dev->rng.name		= dev->name;
-	dev->rng.data_present	= hifn_rng_data_present,
-	dev->rng.data_read	= hifn_rng_data_read,
+	dev->rng.data_present	= hifn_rng_data_present;
+	dev->rng.data_read	= hifn_rng_data_read;
 	dev->rng.priv		= (unsigned long)dev;
 
 	return hwrng_register(&dev->rng);
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 661dc3e..67ee672 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -603,10 +603,10 @@ static int talitos_register_rng(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 
-	priv->rng.name		= dev_driver_string(dev),
-	priv->rng.init		= talitos_rng_init,
-	priv->rng.data_present	= talitos_rng_data_present,
-	priv->rng.data_read	= talitos_rng_data_read,
+	priv->rng.name		= dev_driver_string(dev);
+	priv->rng.init		= talitos_rng_init;
+	priv->rng.data_present	= talitos_rng_data_present;
+	priv->rng.data_read	= talitos_rng_data_read;
 	priv->rng.priv		= (unsigned long)dev;
 
 	return hwrng_register(&priv->rng);
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index ef6b7e0..29775a5 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -1066,7 +1066,7 @@ static int ppc4xx_edac_mc_init(struct mem_ctl_info *mci,
 
 	mci->mod_name		= PPC4XX_EDAC_MODULE_NAME;
 	mci->mod_ver		= PPC4XX_EDAC_MODULE_REVISION;
-	mci->ctl_name		= ppc4xx_edac_match->compatible,
+	mci->ctl_name		= ppc4xx_edac_match->compatible;
 	mci->dev_name		= np->full_name;
 
 	/* Initialize callbacks */
diff --git a/drivers/gpio/gpio-mc33880.c b/drivers/gpio/gpio-mc33880.c
index 63a7a1b..27ae383 100644
--- a/drivers/gpio/gpio-mc33880.c
+++ b/drivers/gpio/gpio-mc33880.c
@@ -111,7 +111,7 @@ static int mc33880_probe(struct spi_device *spi)
 
 	mc->spi = spi;
 
-	mc->chip.label = DRIVER_NAME,
+	mc->chip.label = DRIVER_NAME;
 	mc->chip.set = mc33880_set;
 	mc->chip.base = pdata->base;
 	mc->chip.ngpio = PIN_NUMBER;
diff --git a/drivers/gpio/gpio-tz1090.c b/drivers/gpio/gpio-tz1090.c
index 23e0613..5246a60 100644
--- a/drivers/gpio/gpio-tz1090.c
+++ b/drivers/gpio/gpio-tz1090.c
@@ -488,26 +488,26 @@ static int tz1090_gpio_bank_probe(struct tz1090_gpio_bank_info *info)
 	gc->chip_types[0].handler		= handle_level_irq;
 	gc->chip_types[0].regs.ack		= REG_GPIO_IRQ_STS;
 	gc->chip_types[0].regs.mask		= REG_GPIO_IRQ_EN;
-	gc->chip_types[0].chip.irq_startup	= gpio_startup_irq,
-	gc->chip_types[0].chip.irq_ack		= irq_gc_ack_clr_bit,
-	gc->chip_types[0].chip.irq_mask		= irq_gc_mask_clr_bit,
-	gc->chip_types[0].chip.irq_unmask	= irq_gc_mask_set_bit,
-	gc->chip_types[0].chip.irq_set_type	= gpio_set_irq_type,
-	gc->chip_types[0].chip.irq_set_wake	= gpio_set_irq_wake,
-	gc->chip_types[0].chip.flags		= IRQCHIP_MASK_ON_SUSPEND,
+	gc->chip_types[0].chip.irq_startup	= gpio_startup_irq;
+	gc->chip_types[0].chip.irq_ack		= irq_gc_ack_clr_bit;
+	gc->chip_types[0].chip.irq_mask		= irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_unmask	= irq_gc_mask_set_bit;
+	gc->chip_types[0].chip.irq_set_type	= gpio_set_irq_type;
+	gc->chip_types[0].chip.irq_set_wake	= gpio_set_irq_wake;
+	gc->chip_types[0].chip.flags		= IRQCHIP_MASK_ON_SUSPEND;
 
 	/* edge chip type */
 	gc->chip_types[1].type			= IRQ_TYPE_EDGE_BOTH;
 	gc->chip_types[1].handler		= handle_edge_irq;
 	gc->chip_types[1].regs.ack		= REG_GPIO_IRQ_STS;
 	gc->chip_types[1].regs.mask		= REG_GPIO_IRQ_EN;
-	gc->chip_types[1].chip.irq_startup	= gpio_startup_irq,
-	gc->chip_types[1].chip.irq_ack		= irq_gc_ack_clr_bit,
-	gc->chip_types[1].chip.irq_mask		= irq_gc_mask_clr_bit,
-	gc->chip_types[1].chip.irq_unmask	= irq_gc_mask_set_bit,
-	gc->chip_types[1].chip.irq_set_type	= gpio_set_irq_type,
-	gc->chip_types[1].chip.irq_set_wake	= gpio_set_irq_wake,
-	gc->chip_types[1].chip.flags		= IRQCHIP_MASK_ON_SUSPEND,
+	gc->chip_types[1].chip.irq_startup	= gpio_startup_irq;
+	gc->chip_types[1].chip.irq_ack		= irq_gc_ack_clr_bit;
+	gc->chip_types[1].chip.irq_mask		= irq_gc_mask_clr_bit;
+	gc->chip_types[1].chip.irq_unmask	= irq_gc_mask_set_bit;
+	gc->chip_types[1].chip.irq_set_type	= gpio_set_irq_type;
+	gc->chip_types[1].chip.irq_set_wake	= gpio_set_irq_wake;
+	gc->chip_types[1].chip.flags		= IRQCHIP_MASK_ON_SUSPEND;
 
 	/* Setup chained handler for this GPIO bank */
 	irq_set_handler_data(bank->irq, bank);
diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/dport.c b/drivers/gpu/drm/nouveau/core/engine/disp/dport.c
index 31cc8fe..4f58490 100644
--- a/drivers/gpu/drm/nouveau/core/engine/disp/dport.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/dport.c
@@ -252,7 +252,7 @@ dp_link_train_fini(struct dp_state *dp)
 	};
 
 	/* post-train script */
-	init.offset = dp->info.script[1],
+	init.offset = dp->info.script[1];
 	nvbios_exec(&init);
 }
 
diff --git a/drivers/hwmon/pc87360.c b/drivers/hwmon/pc87360.c
index aa615ba..0a3b107 100644
--- a/drivers/hwmon/pc87360.c
+++ b/drivers/hwmon/pc87360.c
@@ -1730,8 +1730,8 @@ static int __init pc87360_device_add(unsigned short address)
 			continue;
 		res[res_count].start = extra_isa[i];
 		res[res_count].end = extra_isa[i] + PC87360_EXTENT - 1;
-		res[res_count].name = "pc87360",
-		res[res_count].flags = IORESOURCE_IO,
+		res[res_count].name = "pc87360";
+		res[res_count].flags = IORESOURCE_IO;
 
 		err = acpi_check_resource_conflict(&res[res_count]);
 		if (err)
diff --git a/drivers/input/misc/ixp4xx-beeper.c b/drivers/input/misc/ixp4xx-beeper.c
index f34beb2..b85b892 100644
--- a/drivers/input/misc/ixp4xx-beeper.c
+++ b/drivers/input/misc/ixp4xx-beeper.c
@@ -98,7 +98,7 @@ static int ixp4xx_spkr_probe(struct platform_device *dev)
 
 	input_set_drvdata(input_dev, (void *) dev->id);
 
-	input_dev->name = "ixp4xx beeper",
+	input_dev->name = "ixp4xx beeper";
 	input_dev->phys = "ixp4xx/gpio";
 	input_dev->id.bustype = BUS_HOST;
 	input_dev->id.vendor  = 0x001f;
diff --git a/drivers/input/serio/parkbd.c b/drivers/input/serio/parkbd.c
index 26b4593..ef8aab3 100644
--- a/drivers/input/serio/parkbd.c
+++ b/drivers/input/serio/parkbd.c
@@ -175,7 +175,7 @@ static struct serio * __init parkbd_allocate_serio(void)
 	serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
 	if (serio) {
 		serio->id.type = parkbd_mode;
-		serio->write = parkbd_write,
+		serio->write = parkbd_write;
 		strlcpy(serio->name, "PARKBD AT/XT keyboard adapter", sizeof(serio->name));
 		snprintf(serio->phys, sizeof(serio->phys), "%s/serio0", parkbd_dev->port->name);
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index df7b0a0..6a3f8b0 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2215,7 +2215,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 			s = PAGE_SIZE >> 9;
 
 		rdev = conf->mirrors[dr].rdev;
-		addr = r10_bio->devs[0].addr + sect,
+		addr = r10_bio->devs[0].addr + sect;
 		ok = sync_page_io(rdev,
 				  addr,
 				  s << 9,
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 66db0df..5f326a4 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -3002,7 +3002,7 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 
 	dev->vfd.fops	= &coda_fops,
 	dev->vfd.ioctl_ops	= &coda_ioctl_ops;
-	dev->vfd.release	= video_device_release_empty,
+	dev->vfd.release	= video_device_release_empty;
 	dev->vfd.lock	= &dev->dev_mutex;
 	dev->vfd.v4l2_dev	= &dev->v4l2_dev;
 	dev->vfd.vfl_dir	= VFL_DIR_M2M;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index a130dcd..c4b9e80 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1159,7 +1159,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	}
 	vfd->fops	= &s5p_mfc_fops,
 	vfd->ioctl_ops	= get_dec_v4l2_ioctl_ops();
-	vfd->release	= video_device_release,
+	vfd->release	= video_device_release;
 	vfd->lock	= &dev->mfc_mutex;
 	vfd->v4l2_dev	= &dev->v4l2_dev;
 	vfd->vfl_dir	= VFL_DIR_M2M;
@@ -1184,7 +1184,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	}
 	vfd->fops	= &s5p_mfc_fops,
 	vfd->ioctl_ops	= get_enc_v4l2_ioctl_ops();
-	vfd->release	= video_device_release,
+	vfd->release	= video_device_release;
 	vfd->lock	= &dev->mfc_mutex;
 	vfd->v4l2_dev	= &dev->v4l2_dev;
 	vfd->vfl_dir	= VFL_DIR_M2M;
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 45a0276..0c2562a 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1566,8 +1566,8 @@ static int mx2_camera_probe(struct platform_device *pdev)
 	 */
 	platform_set_drvdata(pdev, NULL);
 
-	pcdev->soc_host.drv_name	= MX2_CAM_DRV_NAME,
-	pcdev->soc_host.ops		= &mx2_soc_camera_host_ops,
+	pcdev->soc_host.drv_name	= MX2_CAM_DRV_NAME;
+	pcdev->soc_host.ops		= &mx2_soc_camera_host_ops;
 	pcdev->soc_host.priv		= pcdev;
 	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
diff --git a/drivers/media/tuners/mt2060.c b/drivers/media/tuners/mt2060.c
index 13381de..7e0e891 100644
--- a/drivers/media/tuners/mt2060.c
+++ b/drivers/media/tuners/mt2060.c
@@ -184,7 +184,7 @@ static int mt2060_set_params(struct dvb_frontend *fe)
 	f_lo2 = f_lo1 - freq - IF2;
 	// From the Comtech datasheet, the step used is 50kHz. The tuner chip could be more precise
 	f_lo2 = ((f_lo2 + 25) / 50) * 50;
-	priv->frequency =  (f_lo1 - f_lo2 - IF2) * 1000,
+	priv->frequency =  (f_lo1 - f_lo2 - IF2) * 1000;
 
 #ifdef MT2060_SPURCHECK
 	// LO-related spurs detection and correction
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index f615454..9dc40a7 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -264,7 +264,7 @@ static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
 		memset(dev->isoc_ctl.transfer_buffer[i], 0, sb_size);
 
 		pipe = usb_rcvisocpipe(dev->usbdev,
-				       dev->isoc_in_endpointaddr),
+				       dev->isoc_in_endpointaddr);
 
 		usb_fill_int_urb(urb, dev->usbdev, pipe,
 				 dev->isoc_ctl.transfer_buffer[i], sb_size,
diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 2fdb66e..c97d1a7 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -582,9 +582,9 @@ static int em28xx_cvol_new(struct snd_card *card, struct em28xx *dev,
 	struct snd_kcontrol_new tmp;
 
 	memset (&tmp, 0, sizeof(tmp));
-	tmp.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	tmp.private_value = id,
-	tmp.name  = ctl_name,
+	tmp.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+	tmp.private_value = id;
+	tmp.name  = ctl_name;
 
 	/* Add Mute Control */
 	sprintf(ctl_name, "%s Switch", name);
@@ -599,16 +599,16 @@ static int em28xx_cvol_new(struct snd_card *card, struct em28xx *dev,
 		ctl_name, id);
 
 	memset (&tmp, 0, sizeof(tmp));
-	tmp.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	tmp.private_value = id,
-	tmp.name  = ctl_name,
+	tmp.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+	tmp.private_value = id;
+	tmp.name  = ctl_name;
 
 	/* Add Volume Control */
 	sprintf(ctl_name, "%s Volume", name);
 	tmp.get   = em28xx_vol_get;
 	tmp.put   = em28xx_vol_put;
 	tmp.info  = em28xx_vol_info;
-	tmp.tlv.p = em28xx_db_scale,
+	tmp.tlv.p = em28xx_db_scale;
 	kctl = snd_ctl_new1(&tmp, dev);
 	err = snd_ctl_add(card, kctl);
 	if (err < 0)
diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 7ebe9ef..114f128 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -915,7 +915,7 @@ static void device_power_init(struct pm860x_chip *chip,
 	power_devs[0].platform_data = pdata->power;
 	power_devs[0].pdata_size = sizeof(struct pm860x_power_pdata);
 	power_devs[0].num_resources = ARRAY_SIZE(battery_resources);
-	power_devs[0].resources = &battery_resources[0],
+	power_devs[0].resources = &battery_resources[0];
 	ret = mfd_add_devices(chip->dev, 0, &power_devs[0], 1,
 			      &battery_resources[0], chip->irq_base, NULL);
 	if (ret < 0)
@@ -924,7 +924,7 @@ static void device_power_init(struct pm860x_chip *chip,
 	power_devs[1].platform_data = pdata->power;
 	power_devs[1].pdata_size = sizeof(struct pm860x_power_pdata);
 	power_devs[1].num_resources = ARRAY_SIZE(charger_resources);
-	power_devs[1].resources = &charger_resources[0],
+	power_devs[1].resources = &charger_resources[0];
 	ret = mfd_add_devices(chip->dev, 0, &power_devs[1], 1,
 			      &charger_resources[0], chip->irq_base, NULL);
 	if (ret < 0)
@@ -941,7 +941,7 @@ static void device_power_init(struct pm860x_chip *chip,
 		pdata->chg_desc->charger_regulators =
 			&chg_desc_regulator_data[0];
 		pdata->chg_desc->num_charger_regulators	=
-			ARRAY_SIZE(chg_desc_regulator_data),
+			ARRAY_SIZE(chg_desc_regulator_data);
 		power_devs[3].platform_data = pdata->chg_desc;
 		power_devs[3].pdata_size = sizeof(*pdata->chg_desc);
 		ret = mfd_add_devices(chip->dev, 0, &power_devs[3], 1,
@@ -957,7 +957,7 @@ static void device_onkey_init(struct pm860x_chip *chip,
 	int ret;
 
 	onkey_devs[0].num_resources = ARRAY_SIZE(onkey_resources);
-	onkey_devs[0].resources = &onkey_resources[0],
+	onkey_devs[0].resources = &onkey_resources[0];
 	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
 			      ARRAY_SIZE(onkey_devs), &onkey_resources[0],
 			      chip->irq_base, NULL);
@@ -971,7 +971,7 @@ static void device_codec_init(struct pm860x_chip *chip,
 	int ret;
 
 	codec_devs[0].num_resources = ARRAY_SIZE(codec_resources);
-	codec_devs[0].resources = &codec_resources[0],
+	codec_devs[0].resources = &codec_resources[0];
 	ret = mfd_add_devices(chip->dev, 0, &codec_devs[0],
 			      ARRAY_SIZE(codec_devs), &codec_resources[0], 0,
 			      NULL);
diff --git a/drivers/mtd/maps/pci.c b/drivers/mtd/maps/pci.c
index c2604f8..09dab45 100644
--- a/drivers/mtd/maps/pci.c
+++ b/drivers/mtd/maps/pci.c
@@ -94,8 +94,8 @@ intel_iq80310_init(struct pci_dev *dev, struct map_pci_info *map)
 	u32 win_base;
 
 	map->map.bankwidth = 1;
-	map->map.read = mtd_pci_read8,
-	map->map.write = mtd_pci_write8,
+	map->map.read = mtd_pci_read8;
+	map->map.write = mtd_pci_write8;
 
 	map->map.size     = 0x00800000;
 	map->base         = ioremap_nocache(pci_resource_start(dev, 0),
@@ -189,8 +189,8 @@ intel_dc21285_init(struct pci_dev *dev, struct map_pci_info *map)
 		return -ENXIO;
 
 	map->map.bankwidth = 4;
-	map->map.read = mtd_pci_read32,
-	map->map.write = mtd_pci_write32,
+	map->map.read = mtd_pci_read32;
+	map->map.write = mtd_pci_write32;
 	map->map.size     = len;
 	map->base         = ioremap_nocache(base, len);
 
diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
index d801c14..9622f3f 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -1279,7 +1279,7 @@ static void ei_tx_intr(struct net_device *dev)
 			ei_local->txing = 1;
 			NS8390_trigger_send(dev, ei_local->tx2, ei_local->tx_start_page + 6);
 			dev->trans_start = jiffies;
-			ei_local->tx2 = -1,
+			ei_local->tx2 = -1;
 			ei_local->lasttx = 2;
 		}
 		else ei_local->lasttx = 20, ei_local->txing = 0;	
diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/8390/lib8390.c
index b329f5c..fc8d8bc 100644
--- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -594,7 +594,7 @@ static void ei_tx_intr(struct net_device *dev)
 			ei_local->txing = 1;
 			NS8390_trigger_send(dev, ei_local->tx2, ei_local->tx_start_page + 6);
 			dev->trans_start = jiffies;
-			ei_local->tx2 = -1,
+			ei_local->tx2 = -1;
 			ei_local->lasttx = 2;
 		} else
 			ei_local->lasttx = 20, ei_local->txing = 0;
diff --git a/drivers/net/ethernet/arc/emac_mdio.c b/drivers/net/ethernet/arc/emac_mdio.c
index 26ba242..6d418ab 100644
--- a/drivers/net/ethernet/arc/emac_mdio.c
+++ b/drivers/net/ethernet/arc/emac_mdio.c
@@ -120,7 +120,7 @@ int arc_mdio_probe(struct platform_device *pdev, struct arc_emac_priv *priv)
 	priv->bus = bus;
 	bus->priv = priv;
 	bus->parent = priv->dev;
-	bus->name = "Synopsys MII Bus",
+	bus->name = "Synopsys MII Bus";
 	bus->read = &arc_mdio_read;
 	bus->write = &arc_mdio_write;
 
diff --git a/drivers/net/ethernet/freescale/fsl_pq_mdio.c b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
index c93a056..6a1f4ae 100644
--- a/drivers/net/ethernet/freescale/fsl_pq_mdio.c
+++ b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
@@ -374,7 +374,7 @@ static int fsl_pq_mdio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv = new_bus->priv;
-	new_bus->name = "Freescale PowerQUICC MII Bus",
+	new_bus->name = "Freescale PowerQUICC MII Bus";
 	new_bus->read = &fsl_pq_mdio_read;
 	new_bus->write = &fsl_pq_mdio_write;
 	new_bus->reset = &fsl_pq_mdio_reset;
diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 727b546..9241eba 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -1438,7 +1438,7 @@ static int ks8851_probe(struct spi_device *spi)
 
 	/* setup mii state */
 	ks->mii.dev		= ndev;
-	ks->mii.phy_id		= 1,
+	ks->mii.phy_id		= 1;
 	ks->mii.phy_id_mask	= 1;
 	ks->mii.reg_num_mask	= 0xf;
 	ks->mii.mdio_read	= ks8851_phy_read;
diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index 9f3f5db..4902001 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -1587,7 +1587,7 @@ static int ks8851_probe(struct platform_device *pdev)
 
 	/* setup mii state */
 	ks->mii.dev             = netdev;
-	ks->mii.phy_id          = 1,
+	ks->mii.phy_id          = 1;
 	ks->mii.phy_id_mask     = 1;
 	ks->mii.reg_num_mask    = 0xf;
 	ks->mii.mdio_read       = ks_phy_read;
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index b495394..7a31a5b 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -404,7 +404,7 @@ static void efx_ptp_read_timeset(u8 *data, struct efx_ptp_timeset *timeset)
 	timeset->seconds = MCDI_DWORD(data, PTP_OUT_SYNCHRONIZE_SECONDS);
 	timeset->nanoseconds = MCDI_DWORD(data,
 					 PTP_OUT_SYNCHRONIZE_NANOSECONDS);
-	timeset->host_end = MCDI_DWORD(data, PTP_OUT_SYNCHRONIZE_HOSTEND),
+	timeset->host_end = MCDI_DWORD(data, PTP_OUT_SYNCHRONIZE_HOSTEND);
 	timeset->waitns = MCDI_DWORD(data, PTP_OUT_SYNCHRONIZE_WAITNS);
 
 	/* Ignore seconds */
diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index ffa7843..2cc86fb 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -1163,7 +1163,7 @@ static void ioc3_8250_register(struct ioc3_uartregs __iomem *uart)
 
 	lcr = uart->iu_lcr;
 	uart->iu_lcr = lcr | UART_LCR_DLAB;
-	uart->iu_scr = COSMISC_CONSTANT,
+	uart->iu_scr = COSMISC_CONSTANT;
 	uart->iu_lcr = lcr;
 	uart->iu_lcr;
 	serial8250_register_8250_port(&port);
diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index 16ddfc3..2b58e1d 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -343,9 +343,9 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 	}
 
 	data->bus->name		= dev_name(dev);
-	data->bus->read		= davinci_mdio_read,
-	data->bus->write	= davinci_mdio_write,
-	data->bus->reset	= davinci_mdio_reset,
+	data->bus->read		= davinci_mdio_read;
+	data->bus->write	= davinci_mdio_write;
+	data->bus->reset	= davinci_mdio_reset;
 	data->bus->parent	= dev;
 	data->bus->priv		= data;
 
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index b75eb9e..bd78701 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1019,7 +1019,7 @@ static int rhine_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* The chip-specific entries in the device structure. */
 	dev->netdev_ops = &rhine_netdev_ops;
-	dev->ethtool_ops = &netdev_ethtool_ops,
+	dev->ethtool_ops = &netdev_ethtool_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
 
 	netif_napi_add(dev, &rp->napi, rhine_napipoll, 64);
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 510a9b6..201ef17 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -686,7 +686,7 @@ void macvlan_common_setup(struct net_device *dev)
 	dev->priv_flags	       |= IFF_UNICAST_FLT;
 	dev->netdev_ops		= &macvlan_netdev_ops;
 	dev->destructor		= free_netdev;
-	dev->header_ops		= &macvlan_hard_header_ops,
+	dev->header_ops		= &macvlan_hard_header_ops;
 	dev->ethtool_ops	= &macvlan_ethtool_ops;
 }
 EXPORT_SYMBOL_GPL(macvlan_common_setup);
diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index 7d78669..346fc67 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -296,7 +296,7 @@ static const struct net_device_ops usbpn_ops = {
 static void usbpn_setup(struct net_device *dev)
 {
 	dev->features		= 0;
-	dev->netdev_ops		= &usbpn_ops,
+	dev->netdev_ops		= &usbpn_ops;
 	dev->header_ops		= &phonet_header_ops;
 	dev->type		= ARPHRD_PHONET;
 	dev->flags		= IFF_POINTOPOINT | IFF_NOARP;
diff --git a/drivers/net/wireless/cw1200/txrx.c b/drivers/net/wireless/cw1200/txrx.c
index e824d4d..c8023b4 100644
--- a/drivers/net/wireless/cw1200/txrx.c
+++ b/drivers/net/wireless/cw1200/txrx.c
@@ -653,7 +653,7 @@ cw1200_tx_h_rate_policy(struct cw1200_common *priv,
 	wsm->flags |= t->txpriv.rate_id << 4;
 
 	t->rate = cw1200_get_tx_rate(priv,
-		&t->tx_info->control.rates[0]),
+		&t->tx_info->control.rates[0]);
 	wsm->max_tx_rate = t->rate->hw_value;
 	if (t->rate->flags & IEEE80211_TX_RC_MCS) {
 		if (cw1200_ht_greenfield(&priv->ht_info))
diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index 0fad98b..846c97f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -381,7 +381,7 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 		return -ENOMEM;
 	cmd.data[0] = bt_cmd;
 
-	bt_cmd->valid_bit_msk = cpu_to_le16(BT_VALID_REDUCED_TX_POWER),
+	bt_cmd->valid_bit_msk = cpu_to_le16(BT_VALID_REDUCED_TX_POWER);
 	bt_cmd->bt_reduced_tx_power = sta_id;
 
 	if (enable)
diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index daf92ac..daf0231 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -2762,7 +2762,7 @@ static int pn533_probe(struct usb_interface *interface,
 	case PN533_DEVICE_ACR122U:
 		protocols = PN533_NO_TYPE_B_PROTOCOLS;
 		dev->ops = &pn533_acr122_frame_ops;
-		dev->protocol_type = PN533_PROTO_REQ_RESP,
+		dev->protocol_type = PN533_PROTO_REQ_RESP;
 
 		rc = pn533_acr122_poweron_rdr(dev);
 		if (rc < 0) {
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 26bdbda..4d4cfd7 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -764,7 +764,7 @@ static void exynos_pcie_enable_irq_pulse(struct pcie_port *pp)
 
 	/* enable INTX interrupt */
 	val = IRQ_INTA_ASSERT | IRQ_INTB_ASSERT |
-		IRQ_INTC_ASSERT | IRQ_INTD_ASSERT,
+		IRQ_INTC_ASSERT | IRQ_INTD_ASSERT;
 	writel(val, elbi_base + PCIE_IRQ_EN_PULSE);
 	return;
 }
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index f098fda..d4b047c 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -3483,7 +3483,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->ac_chg.psy.num_properties = ARRAY_SIZE(ab8500_charger_ac_props);
 	di->ac_chg.psy.get_property = ab8500_charger_ac_get_property;
 	di->ac_chg.psy.supplied_to = supply_interface;
-	di->ac_chg.psy.num_supplicants = ARRAY_SIZE(supply_interface),
+	di->ac_chg.psy.num_supplicants = ARRAY_SIZE(supply_interface);
 	/* ux500_charger sub-class */
 	di->ac_chg.ops.enable = &ab8500_charger_ac_en;
 	di->ac_chg.ops.check_enable = &ab8500_charger_ac_check_enable;
@@ -3510,7 +3510,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->usb_chg.psy.num_properties = ARRAY_SIZE(ab8500_charger_usb_props);
 	di->usb_chg.psy.get_property = ab8500_charger_usb_get_property;
 	di->usb_chg.psy.supplied_to = supply_interface;
-	di->usb_chg.psy.num_supplicants = ARRAY_SIZE(supply_interface),
+	di->usb_chg.psy.num_supplicants = ARRAY_SIZE(supply_interface);
 	/* ux500_charger sub-class */
 	di->usb_chg.ops.enable = &ab8500_charger_usb_en;
 	di->usb_chg.ops.check_enable = &ab8500_charger_usb_check_enable;
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 7549707..6b334f7 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -866,7 +866,7 @@ static int ab8500_fg_volt_to_capacity(struct ab8500_fg *di, int voltage)
 	const struct abx500_v_to_cap *tbl;
 	int cap = 0;
 
-	tbl = di->bm->bat_type[di->bm->batt_id].v_to_cap_tbl,
+	tbl = di->bm->bat_type[di->bm->batt_id].v_to_cap_tbl;
 	tbl_size = di->bm->bat_type[di->bm->batt_id].n_v_cap_tbl_elements;
 
 	for (i = 0; i < tbl_size; ++i) {
@@ -3128,7 +3128,7 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	di->fg_psy.num_properties = ARRAY_SIZE(ab8500_fg_props);
 	di->fg_psy.get_property = ab8500_fg_get_property;
 	di->fg_psy.supplied_to = supply_interface;
-	di->fg_psy.num_supplicants = ARRAY_SIZE(supply_interface),
+	di->fg_psy.num_supplicants = ARRAY_SIZE(supply_interface);
 	di->fg_psy.external_power_changed = ab8500_fg_external_power_changed;
 
 	di->bat_cap.max_mah_design = MILLI_TO_MICRO *
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 6d27236..fc056d2 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -2081,7 +2081,7 @@ static int abx500_chargalg_probe(struct platform_device *pdev)
 	di->chargalg_psy.num_properties = ARRAY_SIZE(abx500_chargalg_props);
 	di->chargalg_psy.get_property = abx500_chargalg_get_property;
 	di->chargalg_psy.supplied_to = supply_interface;
-	di->chargalg_psy.num_supplicants = ARRAY_SIZE(supply_interface),
+	di->chargalg_psy.num_supplicants = ARRAY_SIZE(supply_interface);
 	di->chargalg_psy.external_power_changed =
 		abx500_chargalg_external_power_changed;
 
diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index e7f6661..b275647 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -76,8 +76,8 @@ int mvme147_detect(struct scsi_host_template *tpnt)
 	called++;
 
 	tpnt->proc_name = "MVME147";
-	tpnt->show_info = wd33c93_show_info,
-	tpnt->write_info = wd33c93_write_info,
+	tpnt->show_info = wd33c93_show_info;
+	tpnt->write_info = wd33c93_write_info;
 
 	instance = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
 	if (!instance)
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 1eb7b02..273dd51 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -2024,7 +2024,7 @@ static void pmcraid_soft_reset(struct pmcraid_cmd *cmd)
 	}
 
 	iowrite32(doorbell, pinstance->int_regs.host_ioa_interrupt_reg);
-	ioread32(pinstance->int_regs.host_ioa_interrupt_reg),
+	ioread32(pinstance->int_regs.host_ioa_interrupt_reg);
 	int_reg = ioread32(pinstance->int_regs.ioa_host_interrupt_reg);
 
 	pmcraid_info("Waiting for IOA to become operational %x:%x\n",
diff --git a/drivers/staging/imx-drm/parallel-display.c b/drivers/staging/imx-drm/parallel-display.c
index cea9f14..d3d9bce 100644
--- a/drivers/staging/imx-drm/parallel-display.c
+++ b/drivers/staging/imx-drm/parallel-display.c
@@ -67,7 +67,7 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 	if (imxpd->mode_valid) {
 		struct drm_display_mode *mode = drm_mode_create(connector->dev);
 		drm_mode_copy(mode, &imxpd->mode);
-		mode->type |= DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED,
+		mode->type |= DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
 		drm_mode_probed_add(connector, mode);
 		num_modes++;
 	}
@@ -76,7 +76,7 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 		struct drm_display_mode *mode = drm_mode_create(connector->dev);
 		of_get_drm_display_mode(np, &imxpd->mode, 0);
 		drm_mode_copy(mode, &imxpd->mode);
-		mode->type |= DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED,
+		mode->type |= DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
 		drm_mode_probed_add(connector, mode);
 		num_modes++;
 	}
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index 12a9ede..2e6456f 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -1319,7 +1319,7 @@ static int mgc_apply_recover_logs(struct obd_device *mgc,
 		pos += sprintf(obdname + pos, "-%s%04x",
 				  is_ost ? "OST" : "MDT", entry->mne_index);
 
-		cname = is_ost ? "osc" : "mdc",
+		cname = is_ost ? "osc" : "mdc";
 		pos += sprintf(obdname + pos, "-%s-%s", cname, inst);
 		lustre_cfg_bufs_reset(&bufs, obdname);
 
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index bbfd288..79f466f 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1965,7 +1965,7 @@ int iscsi_target_register_configfs(void)
 	fabric->tf_ops.tpg_alloc_fabric_acl = &lio_tpg_alloc_fabric_acl;
 	fabric->tf_ops.tpg_release_fabric_acl = &lio_tpg_release_fabric_acl;
 	fabric->tf_ops.tpg_get_inst_index = &lio_tpg_get_inst_index;
-	fabric->tf_ops.check_stop_free = &lio_check_stop_free,
+	fabric->tf_ops.check_stop_free = &lio_check_stop_free;
 	fabric->tf_ops.release_cmd = &lio_release_cmd;
 	fabric->tf_ops.shutdown_session = &lio_tpg_shutdown_session;
 	fabric->tf_ops.close_session = &lio_tpg_close_session;
diff --git a/drivers/tty/hvc/hvsi_lib.c b/drivers/tty/hvc/hvsi_lib.c
index 3396eb9..4ca1e37 100644
--- a/drivers/tty/hvc/hvsi_lib.c
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -302,7 +302,7 @@ int hvsilib_write_mctrl(struct hvsi_priv *pv, int dtr)
 	pr_devel("HVSI@%x: %s DTR...\n", pv->termno,
 		 dtr ? "Setting" : "Clearing");
 
-	ctrl.hdr.type = VS_CONTROL_PACKET_HEADER,
+	ctrl.hdr.type = VS_CONTROL_PACKET_HEADER;
 	ctrl.hdr.len = sizeof(struct hvsi_control);
 	ctrl.verb = VSV_SET_MODEM_CTL;
 	ctrl.mask = HVSI_TSDTR;
diff --git a/drivers/tty/serial/bfin_sport_uart.c b/drivers/tty/serial/bfin_sport_uart.c
index 424ed36..59e9fe0 100644
--- a/drivers/tty/serial/bfin_sport_uart.c
+++ b/drivers/tty/serial/bfin_sport_uart.c
@@ -775,7 +775,7 @@ static int sport_uart_probe(struct platform_device *pdev)
 		}
 
 		spin_lock_init(&sport->port.lock);
-		sport->port.fifosize  = SPORT_TX_FIFO_SIZE,
+		sport->port.fifosize  = SPORT_TX_FIFO_SIZE;
 		sport->port.ops       = &sport_uart_ops;
 		sport->port.line      = pdev->id;
 		sport->port.iotype    = UPIO_MEM;
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index f7672ca..c6385bd 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1202,7 +1202,7 @@ static int cpm_uart_init_port(struct device_node *np,
 	pinfo->port.uartclk = ppc_proc_freq;
 	pinfo->port.mapbase = (unsigned long)mem;
 	pinfo->port.type = PORT_CPM;
-	pinfo->port.ops = &cpm_uart_pops,
+	pinfo->port.ops = &cpm_uart_pops;
 	pinfo->port.iotype = UPIO_MEM;
 	pinfo->port.fifosize = pinfo->tx_nrfifos * pinfo->tx_fifosize;
 	spin_lock_init(&pinfo->port.lock);
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index a5f32c7..2c8cad9 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1969,7 +1969,7 @@ static int serial_imx_probe(struct platform_device *pdev)
 	sport->port.dev = &pdev->dev;
 	sport->port.mapbase = res->start;
 	sport->port.membase = base;
-	sport->port.type = PORT_IMX,
+	sport->port.type = PORT_IMX;
 	sport->port.iotype = UPIO_MEM;
 	sport->port.irq = platform_get_irq(pdev, 0);
 	sport->rxirq = platform_get_irq(pdev, 0);
diff --git a/drivers/tty/serial/lantiq.c b/drivers/tty/serial/lantiq.c
index 15733da..b74e74c 100644
--- a/drivers/tty/serial/lantiq.c
+++ b/drivers/tty/serial/lantiq.c
@@ -709,7 +709,7 @@ lqasc_probe(struct platform_device *pdev)
 	port->flags	= ASYNC_BOOT_AUTOCONF | UPF_IOREMAP;
 	port->ops	= &lqasc_pops;
 	port->fifosize	= 16;
-	port->type	= PORT_LTQ_ASC,
+	port->type	= PORT_LTQ_ASC;
 	port->line	= line;
 	port->dev	= &pdev->dev;
 	/* unused, just to be backward-compatible */
diff --git a/drivers/usb/phy/phy-isp1301-omap.c b/drivers/usb/phy/phy-isp1301-omap.c
index d3a5160..3f42c92 100644
--- a/drivers/usb/phy/phy-isp1301-omap.c
+++ b/drivers/usb/phy/phy-isp1301-omap.c
@@ -1582,13 +1582,13 @@ isp1301_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 
 	isp->phy.dev = &i2c->dev;
 	isp->phy.label = DRIVER_NAME;
-	isp->phy.set_power = isp1301_set_power,
+	isp->phy.set_power = isp1301_set_power;
 
 	isp->phy.otg->phy = &isp->phy;
-	isp->phy.otg->set_host = isp1301_set_host,
-	isp->phy.otg->set_peripheral = isp1301_set_peripheral,
-	isp->phy.otg->start_srp = isp1301_start_srp,
-	isp->phy.otg->start_hnp = isp1301_start_hnp,
+	isp->phy.otg->set_host = isp1301_set_host;
+	isp->phy.otg->set_peripheral = isp1301_set_peripheral;
+	isp->phy.otg->start_srp = isp1301_start_srp;
+	isp->phy.otg->start_hnp = isp1301_start_hnp;
 
 	enable_vbus_draw(isp, 0);
 	power_down(isp);
diff --git a/drivers/video/auo_k190x.c b/drivers/video/auo_k190x.c
index 8d2499d..253cffa 100644
--- a/drivers/video/auo_k190x.c
+++ b/drivers/video/auo_k190x.c
@@ -1090,8 +1090,8 @@ int auok190x_common_probe(struct platform_device *pdev,
 
 	dev_dbg(info->device, "targeting %d frames per second\n", board->fps);
 	info->fbdefio->delay = HZ / board->fps;
-	info->fbdefio->first_io = auok190xfb_dpy_first_io,
-	info->fbdefio->deferred_io = auok190xfb_dpy_deferred_io,
+	info->fbdefio->first_io = auok190xfb_dpy_first_io;
+	info->fbdefio->deferred_io = auok190xfb_dpy_deferred_io;
 	fb_deferred_io_init(info);
 
 	/* color map */
diff --git a/drivers/video/imsttfb.c b/drivers/video/imsttfb.c
index d5220cc..6a17d7d 100644
--- a/drivers/video/imsttfb.c
+++ b/drivers/video/imsttfb.c
@@ -997,7 +997,7 @@ imsttfb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 	bgc |= (bgc << 8);
 	bgc |= (bgc << 16);
 
-	Bpp = info->var.bits_per_pixel >> 3,
+	Bpp = info->var.bits_per_pixel >> 3;
 	line_pitch = info->fix.line_length;
 
 	dy = rect->dy * line_pitch;
diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index 5861ba2..252ac63 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -811,7 +811,7 @@ static int mxsfb_init_fbinfo(struct mxsfb_info *host)
 	strlcpy(fb_info->fix.id, "mxs", sizeof(fb_info->fix.id));
 	fb_info->fix.type = FB_TYPE_PACKED_PIXELS;
 	fb_info->fix.ypanstep = 1;
-	fb_info->fix.visual = FB_VISUAL_TRUECOLOR,
+	fb_info->fix.visual = FB_VISUAL_TRUECOLOR;
 	fb_info->fix.accel = FB_ACCEL_NONE;
 
 	ret = mxsfb_init_fbinfo_dt(host);
diff --git a/drivers/video/pxa3xx-gcu.c b/drivers/video/pxa3xx-gcu.c
index ad382b3..d431510 100644
--- a/drivers/video/pxa3xx-gcu.c
+++ b/drivers/video/pxa3xx-gcu.c
@@ -609,9 +609,9 @@ static int pxa3xx_gcu_probe(struct platform_device *dev)
 	 * container_of(). This isn't really necessary as we have a fixed minor
 	 * number anyway, but this is to avoid statics. */
 
-	priv->misc_dev.minor	= MISCDEV_MINOR,
-	priv->misc_dev.name	= DRV_NAME,
-	priv->misc_dev.fops	= &misc_fops,
+	priv->misc_dev.minor	= MISCDEV_MINOR;
+	priv->misc_dev.name	= DRV_NAME;
+	priv->misc_dev.fops	= &misc_fops;
 
 	/* register misc device */
 	ret = misc_register(&priv->misc_dev);
diff --git a/drivers/video/s3c2410fb.c b/drivers/video/s3c2410fb.c
index 21a32ad..dfd5945 100644
--- a/drivers/video/s3c2410fb.c
+++ b/drivers/video/s3c2410fb.c
@@ -416,7 +416,7 @@ static void s3c2410fb_activate_var(struct fb_info *info)
 	/* set lcd address pointers */
 	s3c2410fb_set_lcdaddr(info);
 
-	fbi->regs.lcdcon1 |= S3C2410_LCDCON1_ENVID,
+	fbi->regs.lcdcon1 |= S3C2410_LCDCON1_ENVID;
 	writel(fbi->regs.lcdcon1, regs + S3C2410_LCDCON1);
 }
 
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 25442b4..177e57b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3090,7 +3090,7 @@ int ceph_encode_inode_release(void **p, struct inode *inode,
 			rel->ino = cpu_to_le64(ceph_ino(inode));
 			rel->cap_id = cpu_to_le64(cap->cap_id);
 			rel->seq = cpu_to_le32(cap->seq);
-			rel->issue_seq = cpu_to_le32(cap->issue_seq),
+			rel->issue_seq = cpu_to_le32(cap->issue_seq);
 			rel->mseq = cpu_to_le32(cap->mseq);
 			rel->caps = cpu_to_le32(cap->issued);
 			rel->wanted = cpu_to_le32(cap->mds_wanted);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c081e34..d534585 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1359,7 +1359,7 @@ retry:
 		offs = le16_to_cpu(entry->e_value_offs);
 		size = le32_to_cpu(entry->e_value_size);
 		entry_size = EXT4_XATTR_LEN(entry->e_name_len);
-		i.name_index = entry->e_name_index,
+		i.name_index = entry->e_name_index;
 		buffer = kmalloc(EXT4_XATTR_SIZE(size), GFP_NOFS);
 		b_entry_name = kmalloc(entry->e_name_len + 1, GFP_NOFS);
 		if (!buffer || !b_entry_name) {
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 7f05cd1..57251d0 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -659,7 +659,7 @@ static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *c
 				(clp->cl_cred.cr_flavor >= RPC_AUTH_GSS_KRB5))
 			return -EINVAL;
 		args.client_name = clp->cl_cred.cr_principal;
-		args.prognumber	= conn->cb_prog,
+		args.prognumber	= conn->cb_prog;
 		args.protocol = XPRT_TRANSPORT_TCP;
 		args.authflavor = clp->cl_cred.cr_flavor;
 		clp->cl_cb_ident = conn->cb_ident;
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index e0d9b3e..a1534a5 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -22,8 +22,8 @@ void omfs_make_empty_table(struct buffer_head *bh, int offset)
 	struct omfs_extent *oe = (struct omfs_extent *) &bh->b_data[offset];
 
 	oe->e_next = ~cpu_to_be64(0ULL);
-	oe->e_extent_count = cpu_to_be32(1),
-	oe->e_fill = cpu_to_be32(0x22),
+	oe->e_extent_count = cpu_to_be32(1);
+	oe->e_fill = cpu_to_be32(0x22);
 	oe->e_entry.e_cluster = ~cpu_to_be64(0ULL);
 	oe->e_entry.e_blocks = ~cpu_to_be64(0ULL);
 }
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 0903960..2248ac8 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -3719,7 +3719,7 @@ xfs_btree_delrec(
 	 * surviving block, and log it.
 	 */
 	xfs_btree_set_numrecs(left, lrecs + rrecs);
-	xfs_btree_get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB),
+	xfs_btree_get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB);
 	xfs_btree_set_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
 	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
 
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index bacc0bc..adc68d9 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -480,7 +480,7 @@ static void reg_vif_setup(struct net_device *dev)
 	dev->type		= ARPHRD_PIMREG;
 	dev->mtu		= ETH_DATA_LEN - sizeof(struct iphdr) - 8;
 	dev->flags		= IFF_NOARP;
-	dev->netdev_ops		= &reg_vif_netdev_ops,
+	dev->netdev_ops		= &reg_vif_netdev_ops;
 	dev->destructor		= free_netdev;
 	dev->features		|= NETIF_F_NETNS_LOCAL;
 }
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 7787537..44cfe65 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -153,7 +153,7 @@ int rds_tcp_listen_init(void)
 	sock->sk->sk_data_ready = rds_tcp_listen_data_ready;
 	write_unlock_bh(&sock->sk->sk_callback_lock);
 
-	sin.sin_family = PF_INET,
+	sin.sin_family = PF_INET;
 	sin.sin_addr.s_addr = (__force u32)htonl(INADDR_ANY);
 	sin.sin_port = (__force u16)htons(RDS_TCP_PORT);
 
diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index fdaa50c..d45b15a 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -112,7 +112,7 @@ int aa_audit_file(struct aa_profile *profile, struct file_perms *perms,
 	struct apparmor_audit_data aad = {0,};
 	sa.type = LSM_AUDIT_DATA_NONE;
 	sa.aad = &aad;
-	aad.op = op,
+	aad.op = op;
 	aad.fs.request = request;
 	aad.name = name;
 	aad.fs.target = target;
diff --git a/security/apparmor/resource.c b/security/apparmor/resource.c
index 748bf0c..a9f7777 100644
--- a/security/apparmor/resource.c
+++ b/security/apparmor/resource.c
@@ -55,7 +55,7 @@ static int audit_resource(struct aa_profile *profile, unsigned int resource,
 
 	sa.type = LSM_AUDIT_DATA_NONE;
 	sa.aad = &aad;
-	aad.op = OP_SETRLIMIT,
+	aad.op = OP_SETRLIMIT;
 	aad.rlim.rlim = resource;
 	aad.rlim.max = value;
 	aad.error = error;
diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 6e9876f..50e2ace 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2275,7 +2275,7 @@ static int dspxfr_one_seg(struct hda_codec *codec,
 	}
 
 	data = fls->data;
-	chip_addx = fls->chip_addr,
+	chip_addx = fls->chip_addr;
 	words_to_write = fls->count;
 
 	if (!words_to_write)
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 4edd2d0..3ce84a4 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1507,8 +1507,8 @@ static int patch_cxt5047(struct hda_codec *codec)
 	spec->num_init_verbs = 1;
 	spec->init_verbs[0] = cxt5047_init_verbs;
 	spec->spdif_route = 0;
-	spec->num_channel_mode = ARRAY_SIZE(cxt5047_modes),
-	spec->channel_mode = cxt5047_modes,
+	spec->num_channel_mode = ARRAY_SIZE(cxt5047_modes);
+	spec->channel_mode = cxt5047_modes;
 
 	codec->patch_ops = conexant_patch_ops;
 
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index cc64d3f..78d4cc5 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -939,7 +939,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map,
 	browser.jumps_width = width_jumps(browser.max_jump_sources);
 	browser.nr_events = nr_pcnt;
 	browser.b.nr_entries = browser.nr_entries;
-	browser.b.entries = &notes->src->source,
+	browser.b.entries = &notes->src->source;
 	browser.b.width += 18; /* Percentage */
 
 	if (annotate_browser__opts.hide_src_code)
diff --git a/tools/perf/ui/tui/util.c b/tools/perf/ui/tui/util.c
index 092902e..4138fa4 100644
--- a/tools/perf/ui/tui/util.c
+++ b/tools/perf/ui/tui/util.c
@@ -176,7 +176,7 @@ int ui__question_window(const char *title, const char *text,
 
 	max_len += 2;
 	nr_lines += 4;
-	y = SLtt_Screen_Rows / 2 - nr_lines / 2,
+	y = SLtt_Screen_Rows / 2 - nr_lines / 2;
 	x = SLtt_Screen_Cols / 2 - max_len / 2;
 
 	SLsmg_set_color(0);
