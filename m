Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967642Ab3HIHjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 03:39:41 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:61524 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967262Ab3HIHji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 03:39:38 -0400
MIME-Version: 1.0
In-Reply-To: <1375990372-19033-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1375990372-19033-1-git-send-email-Julia.Lawall@lip6.fr> <1375990372-19033-2-git-send-email-Julia.Lawall@lip6.fr>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 9 Aug 2013 09:39:17 +0200
Message-ID: <CACQ1gAg__bY9pCnGnkf2QGHkBvssXXdS3bMJiuOJfh9e082jhA@mail.gmail.com>
Subject: Re: [PATCH] trivial: convert comma to semicolon
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/8 Julia Lawall <Julia.Lawall@lip6.fr>:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Replace a comma between expression statements by a semicolon.
>
> The rule is quite conservative in that it only finds cases where this
> pattern appears after a statement that ends with a semicolon, to ensure
> that the expression statements do not form an if branch or loop body that
> would require adding braces.  This leads to some false negatives, some of
> which are apparent in the context code of the patch.  To have a patch that
> is entirely machine generated, these false negatives are left untouched,
> but could be fixed by other rules.
>
> The patched kernel has been compiled, and there is no change in the object
> code for the files that it was possible to compile.
>
> A simplified version of the semantic patch that performs this
> transformation is as follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r@
> expression e1,e2,e;
> type T;
> identifier i;
> @@
>
> (
> T i = ...;
> |
>  e;
> )
>  e1
> -,
> +;
>  e2;
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> Tested-by: Peter Senna Tschudin <peter.senna@gmail.com>
>
> ---
> diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
> index f2360a7..c41b5ec 100644
> --- a/arch/alpha/kernel/process.c
> +++ b/arch/alpha/kernel/process.c
> @@ -246,7 +246,7 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
>                 childstack->r26 = (unsigned long) ret_from_kernel_thread;
>                 childstack->r9 = usp;   /* function */
>                 childstack->r10 = arg;
> -               childregs->hae = alpha_mv.hae_cache,
> +               childregs->hae = alpha_mv.hae_cache;
>                 childti->pcb.usp = 0;
>                 return 0;
>         }
> diff --git a/arch/arm/mach-davinci/pm.c b/arch/arm/mach-davinci/pm.c
> index a508fe5..03e2269 100644
> --- a/arch/arm/mach-davinci/pm.c
> +++ b/arch/arm/mach-davinci/pm.c
> @@ -58,7 +58,7 @@ static void davinci_pm_suspend(void)
>
>         /* Configure sleep count in deep sleep register */
>         val = __raw_readl(pdata->deepsleep_reg);
> -       val &= ~DEEPSLEEP_SLEEPCOUNT_MASK,
> +       val &= ~DEEPSLEEP_SLEEPCOUNT_MASK;
>         val |= pdata->sleepcount;
>         __raw_writel(val, pdata->deepsleep_reg);
>
> diff --git a/arch/arm/mach-pxa/eseries.c b/arch/arm/mach-pxa/eseries.c
> index 8280ebc..1da3f9a 100644
> --- a/arch/arm/mach-pxa/eseries.c
> +++ b/arch/arm/mach-pxa/eseries.c
> @@ -550,7 +550,7 @@ static void __init e740_init(void)
>         pxa_set_stuart_info(NULL);
>         eseries_register_clks();
>         clk_add_alias("CLK_CK48M", e740_t7l66xb_device.name,
> -                       "UDCCLK", &pxa25x_device_udc.dev),
> +                       "UDCCLK", &pxa25x_device_udc.dev);
>         eseries_get_tmio_gpios();
>         platform_add_devices(ARRAY_AND_SIZE(e740_devices));
>         pxa_set_ac97_info(NULL);
> @@ -749,7 +749,7 @@ static void __init e750_init(void)
>         pxa_set_btuart_info(NULL);
>         pxa_set_stuart_info(NULL);
>         clk_add_alias("CLK_CK3P6MI", e750_tc6393xb_device.name,
> -                       "GPIO11_CLK", NULL),
> +                       "GPIO11_CLK", NULL);
>         eseries_get_tmio_gpios();
>         platform_add_devices(ARRAY_AND_SIZE(e750_devices));
>         pxa_set_ac97_info(NULL);
> @@ -962,7 +962,7 @@ static void __init e800_init(void)
>         pxa_set_btuart_info(NULL);
>         pxa_set_stuart_info(NULL);
>         clk_add_alias("CLK_CK3P6MI", e800_tc6393xb_device.name,
> -                       "GPIO11_CLK", NULL),
> +                       "GPIO11_CLK", NULL);
>         eseries_get_tmio_gpios();
>         platform_add_devices(ARRAY_AND_SIZE(e800_devices));
>         pxa_set_ac97_info(NULL);
> diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
> index 2513d8f..b9da4ae 100644
> --- a/arch/arm/mach-pxa/z2.c
> +++ b/arch/arm/mach-pxa/z2.c
> @@ -527,7 +527,7 @@ static int z2_lbs_spi_setup(struct spi_device *spi)
>         mdelay(180);
>
>         spi->bits_per_word = 16;
> -       spi->mode = SPI_MODE_2,
> +       spi->mode = SPI_MODE_2;
>
>         spi_setup(spi);
>
> diff --git a/arch/arm/plat-samsung/s5p-irq-gpioint.c b/arch/arm/plat-samsung/s5p-irq-gpioint.c
> index fafdb05..fa3696b 100644
> --- a/arch/arm/plat-samsung/s5p-irq-gpioint.c
> +++ b/arch/arm/plat-samsung/s5p-irq-gpioint.c
> @@ -160,7 +160,7 @@ static __init int s5p_gpioint_add(struct samsung_gpio_chip *chip)
>         ct->chip.irq_ack = irq_gc_ack_set_bit;
>         ct->chip.irq_mask = irq_gc_mask_set_bit;
>         ct->chip.irq_unmask = irq_gc_mask_clr_bit;
> -       ct->chip.irq_set_type = s5p_gpioint_set_type,
> +       ct->chip.irq_set_type = s5p_gpioint_set_type;
>         ct->regs.ack = PEND_OFFSET + REG_OFFSET(group - bank->start);
>         ct->regs.mask = MASK_OFFSET + REG_OFFSET(group - bank->start);
>         ct->regs.type = CON_OFFSET + REG_OFFSET(group - bank->start);
> diff --git a/arch/mips/kernel/cevt-txx9.c b/arch/mips/kernel/cevt-txx9.c
> index 2ae0846..adf440f 100644
> --- a/arch/mips/kernel/cevt-txx9.c
> +++ b/arch/mips/kernel/cevt-txx9.c
> @@ -168,7 +168,7 @@ void __init txx9_clockevent_init(unsigned long baseaddr, int irq,
>                 clockevent_delta2ns(0xffffffff >> (32 - TXX9_TIMER_BITS), cd);
>         cd->min_delta_ns = clockevent_delta2ns(0xf, cd);
>         cd->irq = irq;
> -       cd->cpumask = cpumask_of(0),
> +       cd->cpumask = cpumask_of(0);
>         clockevents_register_device(cd);
>         setup_irq(irq, &txx9tmr_irq);
>         printk(KERN_INFO "TXx9: clockevent device at 0x%lx, irq %d\n",
> diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
> index 1765bab..6cdf21a 100644
> --- a/arch/mips/kernel/vpe.c
> +++ b/arch/mips/kernel/vpe.c
> @@ -1428,8 +1428,8 @@ static int __init vpe_module_init(void)
>         }
>
>         device_initialize(&vpe_device);
> -       vpe_device.class        = &vpe_class,
> -       vpe_device.parent       = NULL,
> +       vpe_device.class        = &vpe_class;
> +       vpe_device.parent       = NULL;
>         dev_set_name(&vpe_device, "vpe1");
>         vpe_device.devt = MKDEV(major, minor);
>         err = device_add(&vpe_device);
> diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
> index 5f90b85..f94d02e 100644
> --- a/arch/x86/kernel/cpu/mtrr/cleanup.c
> +++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
> @@ -540,7 +540,7 @@ static void __init print_out_mtrr_range_state(void)
>
>                 size_base = to_size_factor(size_base, &size_factor),
>                 start_base = range_state[i].base_pfn << (PAGE_SHIFT - 10);
> -               start_base = to_size_factor(start_base, &start_factor),
> +               start_base = to_size_factor(start_base, &start_factor);
>                 type = range_state[i].type;
>
>                 printk(KERN_DEBUG "reg %d, base: %ld%cB, range: %ld%cB, type %s\n",
> diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
> index 30629a3..d55f99d 100644
> --- a/drivers/bcma/driver_pci_host.c
> +++ b/drivers/bcma/driver_pci_host.c
> @@ -418,12 +418,12 @@ void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
>         pc_host->pci_ops.read = bcma_core_pci_hostmode_read_config;
>         pc_host->pci_ops.write = bcma_core_pci_hostmode_write_config;
>
> -       pc_host->mem_resource.name = "BCMA PCIcore external memory",
> +       pc_host->mem_resource.name = "BCMA PCIcore external memory";
>         pc_host->mem_resource.start = BCMA_SOC_PCI_DMA;
>         pc_host->mem_resource.end = BCMA_SOC_PCI_DMA + BCMA_SOC_PCI_DMA_SZ - 1;
>         pc_host->mem_resource.flags = IORESOURCE_MEM | IORESOURCE_PCI_FIXED;
>
> -       pc_host->io_resource.name = "BCMA PCIcore external I/O",
> +       pc_host->io_resource.name = "BCMA PCIcore external I/O";
>         pc_host->io_resource.start = 0x100;
>         pc_host->io_resource.end = 0x7FF;
>         pc_host->io_resource.flags = IORESOURCE_IO | IORESOURCE_PCI_FIXED;
> diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
> index 779f0ab..a7d8e32 100644
> --- a/drivers/char/agp/amd-k7-agp.c
> +++ b/drivers/char/agp/amd-k7-agp.c
> @@ -425,7 +425,7 @@ static int agp_amdk7_probe(struct pci_dev *pdev,
>                 return -ENOMEM;
>
>         bridge->driver = &amd_irongate_driver;
> -       bridge->dev_private_data = &amd_irongate_private,
> +       bridge->dev_private_data = &amd_irongate_private;
>         bridge->dev = pdev;
>         bridge->capndx = cap_ptr;
>
> diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
> index be42a23..2f1b432 100644
> --- a/drivers/char/agp/nvidia-agp.c
> +++ b/drivers/char/agp/nvidia-agp.c
> @@ -375,7 +375,7 @@ static int agp_nvidia_probe(struct pci_dev *pdev,
>                 return -ENOMEM;
>
>         bridge->driver = &nvidia_driver;
> -       bridge->dev_private_data = &nvidia_private,
> +       bridge->dev_private_data = &nvidia_private;
>         bridge->dev = pdev;
>         bridge->capndx = cap_ptr;
>
> diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
> index 9b163b4..63cd1bf 100644
> --- a/drivers/char/agp/sworks-agp.c
> +++ b/drivers/char/agp/sworks-agp.c
> @@ -511,7 +511,7 @@ static int agp_serverworks_probe(struct pci_dev *pdev,
>                 return -ENOMEM;
>
>         bridge->driver = &sworks_driver;
> -       bridge->dev_private_data = &serverworks_private,
> +       bridge->dev_private_data = &serverworks_private;
>         bridge->dev = pci_dev_get(pdev);
>
>         pci_set_drvdata(pdev, bridge);
> diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
> index 6a86b6f..b8f38dc 100644
> --- a/drivers/char/hw_random/mxc-rnga.c
> +++ b/drivers/char/hw_random/mxc-rnga.c
> @@ -153,9 +153,9 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
>         mxc_rng->dev = &pdev->dev;
>         mxc_rng->rng.name = "mxc-rnga";
>         mxc_rng->rng.init = mxc_rnga_init;
> -       mxc_rng->rng.cleanup = mxc_rnga_cleanup,
> -       mxc_rng->rng.data_present = mxc_rnga_data_present,
> -       mxc_rng->rng.data_read = mxc_rnga_data_read,
> +       mxc_rng->rng.cleanup = mxc_rnga_cleanup;
> +       mxc_rng->rng.data_present = mxc_rnga_data_present;
> +       mxc_rng->rng.data_read = mxc_rnga_data_read;
>
>         mxc_rng->clk = devm_clk_get(&pdev->dev, NULL);
>         if (IS_ERR(mxc_rng->clk)) {
> diff --git a/drivers/clocksource/metag_generic.c b/drivers/clocksource/metag_generic.c
> index 9e4db41..3eb3a6c 100644
> --- a/drivers/clocksource/metag_generic.c
> +++ b/drivers/clocksource/metag_generic.c
> @@ -124,13 +124,13 @@ static void arch_timer_setup(unsigned int cpu)
>
>         sprintf(name, "META %d", cpu);
>         clk->name = name;
> -       clk->features = CLOCK_EVT_FEAT_ONESHOT,
> +       clk->features = CLOCK_EVT_FEAT_ONESHOT;
>
> -       clk->rating = 200,
> -       clk->shift = 12,
> -       clk->irq = tbisig_map(TBID_SIGNUM_TRT),
> -       clk->set_mode = metag_timer_set_mode,
> -       clk->set_next_event = metag_timer_set_next_event,
> +       clk->rating = 200;
> +       clk->shift = 12;
> +       clk->irq = tbisig_map(TBID_SIGNUM_TRT);
> +       clk->set_mode = metag_timer_set_mode;
> +       clk->set_next_event = metag_timer_set_next_event;
>
>         clk->mult = div_sc(hwtimer_freq, NSEC_PER_SEC, clk->shift);
>         clk->max_delta_ns = clockevent_delta2ns(0x7fffffff, clk);
> diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
> index 847cab6..8149b7b 100644
> --- a/drivers/clocksource/time-armada-370-xp.c
> +++ b/drivers/clocksource/time-armada-370-xp.c
> @@ -175,10 +175,10 @@ static int armada_370_xp_timer_setup(struct clock_event_device *evt)
>         evt->name               = "armada_370_xp_per_cpu_tick",
There's one missed just here !                                  ^

>         evt->features           = CLOCK_EVT_FEAT_ONESHOT |
>                                   CLOCK_EVT_FEAT_PERIODIC;
> -       evt->shift              = 32,
> -       evt->rating             = 300,
> -       evt->set_next_event     = armada_370_xp_clkevt_next_event,
> -       evt->set_mode           = armada_370_xp_clkevt_mode,
> +       evt->shift              = 32;
> +       evt->rating             = 300;
> +       evt->set_next_event     = armada_370_xp_clkevt_next_event;
> +       evt->set_mode           = armada_370_xp_clkevt_mode;
>         evt->irq                = armada_370_xp_clkevt_irq;
>         evt->cpumask            = cpumask_of(cpu);
>
[snip]

The rest looks good to me !

Reviewed-by: Richard Genoud <richard.genoud@gmail.com>
