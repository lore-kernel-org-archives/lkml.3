Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab3GFGzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 02:55:43 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:65389 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3GFGzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 02:55:42 -0400
MIME-Version: 1.0
In-Reply-To: <1373089340-20118-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1373089340-20118-1-git-send-email-michael.opdenacker@free-electrons.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 6 Jul 2013 14:55:21 +0800
Message-ID: <CAMPhdO_=PETk6cd8zJUnt=i5V=65ESr83QeY80Rb4P=1+5NLtw@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: remove IRQF_DISABLED
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 6, 2013 at 1:42 PM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> This flag is a NOOP since 2.6.35 and can be removed.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Indeed. Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  arch/arm/mach-pxa/am200epd.c         | 3 +--
>  arch/arm/mach-pxa/am300epd.c         | 3 +--
>  arch/arm/mach-pxa/em-x270.c          | 3 +--
>  arch/arm/mach-pxa/magician.c         | 2 +-
>  arch/arm/mach-pxa/mainstone.c        | 2 +-
>  arch/arm/mach-pxa/pcm990-baseboard.c | 2 +-
>  arch/arm/mach-pxa/sharpsl_pm.c       | 8 ++++----
>  arch/arm/mach-pxa/time.c             | 2 +-
>  arch/arm/mach-pxa/trizeps4.c         | 3 +--
>  arch/arm/plat-pxa/dma.c              | 2 +-
>  10 files changed, 13 insertions(+), 17 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/am200epd.c b/arch/arm/mach-pxa/am200epd.c
> index ffa6d81..12fb0f4 100644
> --- a/arch/arm/mach-pxa/am200epd.c
> +++ b/arch/arm/mach-pxa/am200epd.c
> @@ -293,8 +293,7 @@ static int am200_setup_irq(struct fb_info *info)
>         int ret;
>
>         ret = request_irq(PXA_GPIO_TO_IRQ(RDY_GPIO_PIN), am200_handle_irq,
> -                               IRQF_DISABLED|IRQF_TRIGGER_FALLING,
> -                               "AM200", info->par);
> +                               IRQF_TRIGGER_FALLING, "AM200", info->par);
>         if (ret)
>                 dev_err(&am200_device->dev, "request_irq failed: %d\n", ret);
>
> diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
> index 3dfec1e..c9f309a 100644
> --- a/arch/arm/mach-pxa/am300epd.c
> +++ b/arch/arm/mach-pxa/am300epd.c
> @@ -241,8 +241,7 @@ static int am300_setup_irq(struct fb_info *info)
>         struct broadsheetfb_par *par = info->par;
>
>         ret = request_irq(PXA_GPIO_TO_IRQ(RDY_GPIO_PIN), am300_handle_irq,
> -                               IRQF_DISABLED|IRQF_TRIGGER_RISING,
> -                               "AM300", par);
> +                               IRQF_TRIGGER_RISING, "AM300", par);
>         if (ret)
>                 dev_err(&am300_device->dev, "request_irq failed: %d\n", ret);
>
> diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
> index f6726bb..86936d9 100644
> --- a/arch/arm/mach-pxa/em-x270.c
> +++ b/arch/arm/mach-pxa/em-x270.c
> @@ -556,8 +556,7 @@ static int em_x270_mci_init(struct device *dev,
>         }
>
>         err = request_irq(gpio_to_irq(mmc_cd), em_x270_detect_int,
> -                             IRQF_DISABLED | IRQF_TRIGGER_RISING |
> -                             IRQF_TRIGGER_FALLING,
> +                             IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>                               "MMC card detect", data);
>         if (err) {
>                 dev_err(dev, "can't request MMC card detect IRQ: %d\n", err);
> diff --git a/arch/arm/mach-pxa/magician.c b/arch/arm/mach-pxa/magician.c
> index f44532f..38f544d 100644
> --- a/arch/arm/mach-pxa/magician.c
> +++ b/arch/arm/mach-pxa/magician.c
> @@ -633,7 +633,7 @@ static struct platform_device bq24022 = {
>  static int magician_mci_init(struct device *dev,
>                                 irq_handler_t detect_irq, void *data)
>  {
> -       return request_irq(IRQ_MAGICIAN_SD, detect_irq, IRQF_DISABLED,
> +       return request_irq(IRQ_MAGICIAN_SD, detect_irq, 0,
>                            "mmc card detect", data);
>  }
>
> diff --git a/arch/arm/mach-pxa/mainstone.c b/arch/arm/mach-pxa/mainstone.c
> index d2c6523..1184efa 100644
> --- a/arch/arm/mach-pxa/mainstone.c
> +++ b/arch/arm/mach-pxa/mainstone.c
> @@ -400,7 +400,7 @@ static int mainstone_mci_init(struct device *dev, irq_handler_t mstone_detect_in
>          */
>         MST_MSCWR1 &= ~MST_MSCWR1_MS_SEL;
>
> -       err = request_irq(MAINSTONE_MMC_IRQ, mstone_detect_int, IRQF_DISABLED,
> +       err = request_irq(MAINSTONE_MMC_IRQ, mstone_detect_int, 0,
>                              "MMC card detect", data);
>         if (err)
>                 printk(KERN_ERR "mainstone_mci_init: MMC/SD: can't request MMC card detect IRQ\n");
> diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
> index fb7f1d1..33f058f 100644
> --- a/arch/arm/mach-pxa/pcm990-baseboard.c
> +++ b/arch/arm/mach-pxa/pcm990-baseboard.c
> @@ -326,7 +326,7 @@ static int pcm990_mci_init(struct device *dev, irq_handler_t mci_detect_int,
>  {
>         int err;
>
> -       err = request_irq(PCM027_MMCDET_IRQ, mci_detect_int, IRQF_DISABLED,
> +       err = request_irq(PCM027_MMCDET_IRQ, mci_detect_int,
>                              "MMC card detect", data);
>         if (err)
>                 printk(KERN_ERR "pcm990_mci_init: MMC/SD: can't request MMC "
> diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
> index 0a36d35..051a655 100644
> --- a/arch/arm/mach-pxa/sharpsl_pm.c
> +++ b/arch/arm/mach-pxa/sharpsl_pm.c
> @@ -860,18 +860,18 @@ static int sharpsl_pm_probe(struct platform_device *pdev)
>
>         /* Register interrupt handlers */
>         irq = gpio_to_irq(sharpsl_pm.machinfo->gpio_acin);
> -       if (request_irq(irq, sharpsl_ac_isr, IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, "AC Input Detect", sharpsl_ac_isr)) {
> +       if (request_irq(irq, sharpsl_ac_isr, IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, "AC Input Detect", sharpsl_ac_isr)) {
>                 dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", irq);
>         }
>
>         irq = gpio_to_irq(sharpsl_pm.machinfo->gpio_batlock);
> -       if (request_irq(irq, sharpsl_fatal_isr, IRQF_DISABLED | IRQF_TRIGGER_FALLING, "Battery Cover", sharpsl_fatal_isr)) {
> +       if (request_irq(irq, sharpsl_fatal_isr, IRQF_TRIGGER_FALLING, "Battery Cover", sharpsl_fatal_isr)) {
>                 dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", irq);
>         }
>
>         if (sharpsl_pm.machinfo->gpio_fatal) {
>                 irq = gpio_to_irq(sharpsl_pm.machinfo->gpio_fatal);
> -               if (request_irq(irq, sharpsl_fatal_isr, IRQF_DISABLED | IRQF_TRIGGER_FALLING, "Fatal Battery", sharpsl_fatal_isr)) {
> +               if (request_irq(irq, sharpsl_fatal_isr, IRQF_TRIGGER_FALLING, "Fatal Battery", sharpsl_fatal_isr)) {
>                         dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", irq);
>                 }
>         }
> @@ -879,7 +879,7 @@ static int sharpsl_pm_probe(struct platform_device *pdev)
>         if (sharpsl_pm.machinfo->batfull_irq) {
>                 /* Register interrupt handler. */
>                 irq = gpio_to_irq(sharpsl_pm.machinfo->gpio_batfull);
> -               if (request_irq(irq, sharpsl_chrg_full_isr, IRQF_DISABLED | IRQF_TRIGGER_RISING, "CO", sharpsl_chrg_full_isr)) {
> +               if (request_irq(irq, sharpsl_chrg_full_isr, IRQF_TRIGGER_RISING, "CO", sharpsl_chrg_full_isr)) {
>                         dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", irq);
>                 }
>         }
> diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
> index 8f1ee92..e48fc61 100644
> --- a/arch/arm/mach-pxa/time.c
> +++ b/arch/arm/mach-pxa/time.c
> @@ -137,7 +137,7 @@ static struct clock_event_device ckevt_pxa_osmr0 = {
>
>  static struct irqaction pxa_ost0_irq = {
>         .name           = "ost0",
> -       .flags          = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
> +       .flags          = IRQF_TIMER | IRQF_IRQPOLL,
>         .handler        = pxa_ost0_interrupt,
>         .dev_id         = &ckevt_pxa_osmr0,
>  };
> diff --git a/arch/arm/mach-pxa/trizeps4.c b/arch/arm/mach-pxa/trizeps4.c
> index c580434..872dcb2 100644
> --- a/arch/arm/mach-pxa/trizeps4.c
> +++ b/arch/arm/mach-pxa/trizeps4.c
> @@ -332,8 +332,7 @@ static int trizeps4_mci_init(struct device *dev, irq_handler_t mci_detect_int,
>         int err;
>
>         err = request_irq(TRIZEPS4_MMC_IRQ, mci_detect_int,
> -                         IRQF_DISABLED | IRQF_TRIGGER_RISING,
> -                         "MMC card detect", data);
> +                         IRQF_TRIGGER_RISING, "MMC card detect", data);
>         if (err) {
>                 printk(KERN_ERR "trizeps4_mci_init: MMC/SD: can't request"
>                                                 "MMC card detect IRQ\n");
> diff --git a/arch/arm/plat-pxa/dma.c b/arch/arm/plat-pxa/dma.c
> index 79ef102..054fc5a 100644
> --- a/arch/arm/plat-pxa/dma.c
> +++ b/arch/arm/plat-pxa/dma.c
> @@ -377,7 +377,7 @@ int __init pxa_init_dma(int irq, int num_ch)
>                 spin_lock_init(&dma_channels[i].lock);
>         }
>
> -       ret = request_irq(irq, dma_irq_handler, IRQF_DISABLED, "DMA", NULL);
> +       ret = request_irq(irq, dma_irq_handler, 0, "DMA", NULL);
>         if (ret) {
>                 printk (KERN_CRIT "Wow!  Can't register IRQ for DMA\n");
>                 kfree(dma_channels);
> --
> 1.8.1.2
>
