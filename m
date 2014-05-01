Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaEAM3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 08:29:49 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46519 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaEAM3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 08:29:46 -0400
MIME-Version: 1.0
In-Reply-To: <1398287792-19831-2-git-send-email-linus.walleij@linaro.org>
References: <1398287792-19831-1-git-send-email-linus.walleij@linaro.org> <1398287792-19831-2-git-send-email-linus.walleij@linaro.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 1 May 2014 20:29:25 +0800
X-Google-Sender-Auth: T_x8gBJG8eeRrE4RIjh4GJ9Kn3Y
Message-ID: <CAGsJ_4wOdD53Fkf+_CtDqSg5Yvz-1kwaWzMJb357uq5BL9_-7Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] RFT: pinctrl: sirf: switch to using allocated state container
To: Linus Walleij <linus.walleij@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Barry Song <Baohua.Song@csr.com>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-24 5:16 GMT+08:00 Linus Walleij <linus.walleij@linaro.org>:
> This rewrites the SIRF pinctrl driver to allocate a state container
> for the GPIO chip, just as is done for the pin controller, and
> use the gpiochip_add_pin_range() to add the range from the gpiochip
> side rather than adding the range from the pinctrl side.
>
> All resulting changes are done in order to pass around a state
> container rather than refer to a static global object.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Linus, thanks! but this breaks prima2 pinctrl subsystem, do you have an idea?
otherwise i will do a debug to find the reason.

[    1.371699] ------------[ cut here ]------------
[    1.376028] WARNING: CPU: 0 PID: 1 at drivers/gpio/gpiolib.c:159
gpio_to_desc+0x38/0x40()
[    1.388395] invalid GPIO -517
[    1.391239] Modules linked in:
[    1.394284] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0 #4
[    1.401153] [<c0015c7c>] (unwind_backtrace) from [<c0011da8>]
(show_stack+0x10/0x14)
[    1.408899] [<c0011da8>] (show_stack) from [<c0378920>]
(dump_stack+0x98/0xd0)
[    1.416105] [<c0378920>] (dump_stack) from [<c0021ee4>]
(warn_slowpath_common+0x6c/0x88)
[    1.424157] [<c0021ee4>] (warn_slowpath_common) from [<c0021f30>]
(warn_slowpath_fmt+0x30/0x40)
[    1.432804] [<c0021f30>] (warn_slowpath_fmt) from [<c01d2b00>]
(gpio_to_desc+0x38/0x40)
[    1.440812] [<c01d2b00>] (gpio_to_desc) from [<c01d4f9c>]
(gpio_request_one+0xc/0xc8)
[    1.448614] [<c01d4f9c>] (gpio_request_one) from [<c01d28b4>]
(devm_gpio_request_one+0x40/0x78)
[    1.457289] [<c01d28b4>] (devm_gpio_request_one) from [<c02b3e54>]
(gpio_extcon_probe+0xa4/0x1d4)
[    1.466138] [<c02b3e54>] (gpio_extcon_probe) from [<c023f8b8>]
(platform_drv_probe+0x18/0x48)
[    1.474637] [<c023f8b8>] (platform_drv_probe) from [<c023e004>]
(driver_probe_device+0x120/0x238)
[    1.483465] [<c023e004>] (driver_probe_device) from [<c023c6d0>]
(bus_for_each_drv+0x58/0x8c)
[    1.491987] [<c023c6d0>] (bus_for_each_drv) from [<c023deb0>]
(device_attach+0x74/0x88)
[    1.499967] [<c023deb0>] (device_attach) from [<c023d55c>]
(bus_probe_device+0x84/0xa8)
[    1.507948] [<c023d55c>] (bus_probe_device) from [<c023bae0>]
(device_add+0x440/0x520)
[    1.515840] [<c023bae0>] (device_add) from [<c023f630>]
(platform_device_add+0xb4/0x214)
[    1.523886] [<c023f630>] (platform_device_add) from [<c023fbd4>]
(platform_device_register_full+0xb8/0xdc)
[    1.533538] [<c023fbd4>] (platform_device_register_full) from
[<c04cad00>] (sirfsoc_init_late+0xec/0xf4)
[    1.542996] [<c04cad00>] (sirfsoc_init_late) from [<c04c649c>]
(init_machine_late+0x20/0x28)
[    1.551412] [<c04c649c>] (init_machine_late) from [<c000895c>]
(do_one_initcall+0xf8/0x144)
[    1.559737] [<c000895c>] (do_one_initcall) from [<c04c4c54>]
(kernel_init_freeable+0x13c/0x1dc)
[    1.568414] [<c04c4c54>] (kernel_init_freeable) from [<c0373a5c>]
(kernel_init+0xc/0xe8)
[    1.576483] [<c0373a5c>] (kernel_init) from [<c000e4f8>]
(ret_from_fork+0x14/0x3c)
[    1.584038] ---[ end trace c66a899979023402 ]---
[    1.588591] gpiod_request: invalid GPIO
[    1.592425] extcon-gpio: probe of extcon-gpio failed with error -22



> ---
>  drivers/pinctrl/sirf/pinctrl-sirf.c | 216 ++++++++++++++++++++----------------
>  1 file changed, 122 insertions(+), 94 deletions(-)
>
> diff --git a/drivers/pinctrl/sirf/pinctrl-sirf.c b/drivers/pinctrl/sirf/pinctrl-sirf.c
> index c03dcc7729eb..0613e0c77e8a 100644
> --- a/drivers/pinctrl/sirf/pinctrl-sirf.c
> +++ b/drivers/pinctrl/sirf/pinctrl-sirf.c
> @@ -42,7 +42,6 @@ struct sirfsoc_gpio_chip {
>         struct sirfsoc_gpio_bank sgpio_bank[SIRFSOC_GPIO_NO_OF_BANKS];
>  };
>
> -static struct sirfsoc_gpio_chip sgpio_chip;
>  static DEFINE_SPINLOCK(sgpio_lock);
>
>  static struct sirfsoc_pin_group *sirfsoc_pin_groups;
> @@ -255,17 +254,6 @@ static struct pinctrl_desc sirfsoc_pinmux_desc = {
>         .owner = THIS_MODULE,
>  };
>
> -/*
> - * Todo: bind irq_chip to every pinctrl_gpio_range
> - */
> -static struct pinctrl_gpio_range sirfsoc_gpio_ranges = {
> -       .name = "sirfsoc-gpio*",
> -       .id = 0,
> -       .base = 0,
> -       .pin_base = 0,
> -       .npins = SIRFSOC_GPIO_BANK_SIZE * SIRFSOC_GPIO_NO_OF_BANKS,
> -};
> -
>  static void __iomem *sirfsoc_rsc_of_iomap(void)
>  {
>         const struct of_device_id rsc_ids[]  = {
> @@ -289,9 +277,6 @@ static int sirfsoc_gpio_of_xlate(struct gpio_chip *gc,
>         if (gpiospec->args[0] > SIRFSOC_GPIO_NO_OF_BANKS * SIRFSOC_GPIO_BANK_SIZE)
>                 return -EINVAL;
>
> -       if (gc != &sgpio_chip.chip.gc)
> -               return -EINVAL;
> -
>         if (flags)
>                 *flags = gpiospec->args[1];
>
> @@ -354,9 +339,6 @@ static int sirfsoc_pinmux_probe(struct platform_device *pdev)
>                 goto out_no_pmx;
>         }
>
> -       sirfsoc_gpio_ranges.gc = &sgpio_chip.chip.gc;
> -       pinctrl_add_gpio_range(spmx->pmx, &sirfsoc_gpio_ranges);
> -
>         dev_info(&pdev->dev, "initialized SIRFSOC pinmux driver\n");
>
>         return 0;
> @@ -441,20 +423,28 @@ static int __init sirfsoc_pinmux_init(void)
>  }
>  arch_initcall(sirfsoc_pinmux_init);
>
> -static inline struct sirfsoc_gpio_bank *sirfsoc_gpio_to_bank(unsigned int gpio)
> +static inline struct sirfsoc_gpio_chip *to_sirfsoc_gpio(struct gpio_chip *gc)
>  {
> -       return &sgpio_chip.sgpio_bank[gpio / SIRFSOC_GPIO_BANK_SIZE];
> +       return container_of(gc, struct sirfsoc_gpio_chip, chip.gc);
>  }
>
> -static inline int sirfsoc_gpio_to_bankoff(unsigned int gpio)
> +static inline struct sirfsoc_gpio_bank *
> +sirfsoc_gpio_to_bank(struct sirfsoc_gpio_chip *sgpio, unsigned int offset)
>  {
> -       return gpio % SIRFSOC_GPIO_BANK_SIZE;
> +       return &sgpio->sgpio_bank[offset / SIRFSOC_GPIO_BANK_SIZE];
> +}
> +
> +static inline int sirfsoc_gpio_to_bankoff(unsigned int offset)
> +{
> +       return offset % SIRFSOC_GPIO_BANK_SIZE;
>  }
>
>  static void sirfsoc_gpio_irq_ack(struct irq_data *d)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(d->hwirq);
> -       int idx = d->hwirq % SIRFSOC_GPIO_BANK_SIZE;
> +       struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +       struct sirfsoc_gpio_chip *sgpio = to_sirfsoc_gpio(gc);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(sgpio, d->hwirq);
> +       int idx = sirfsoc_gpio_to_bankoff(d->hwirq);
>         u32 val, offset;
>         unsigned long flags;
>
> @@ -462,14 +452,16 @@ static void sirfsoc_gpio_irq_ack(struct irq_data *d)
>
>         spin_lock_irqsave(&sgpio_lock, flags);
>
> -       val = readl(sgpio_chip.chip.regs + offset);
> +       val = readl(sgpio->chip.regs + offset);
>
> -       writel(val, sgpio_chip.chip.regs + offset);
> +       writel(val, sgpio->chip.regs + offset);
>
>         spin_unlock_irqrestore(&sgpio_lock, flags);
>  }
>
> -static void __sirfsoc_gpio_irq_mask(struct sirfsoc_gpio_bank *bank, int idx)
> +static void __sirfsoc_gpio_irq_mask(struct sirfsoc_gpio_chip *sgpio,
> +                                   struct sirfsoc_gpio_bank *bank,
> +                                   int idx)
>  {
>         u32 val, offset;
>         unsigned long flags;
> @@ -478,25 +470,29 @@ static void __sirfsoc_gpio_irq_mask(struct sirfsoc_gpio_bank *bank, int idx)
>
>         spin_lock_irqsave(&sgpio_lock, flags);
>
> -       val = readl(sgpio_chip.chip.regs + offset);
> +       val = readl(sgpio->chip.regs + offset);
>         val &= ~SIRFSOC_GPIO_CTL_INTR_EN_MASK;
>         val &= ~SIRFSOC_GPIO_CTL_INTR_STS_MASK;
> -       writel(val, sgpio_chip.chip.regs + offset);
> +       writel(val, sgpio->chip.regs + offset);
>
>         spin_unlock_irqrestore(&sgpio_lock, flags);
>  }
>
>  static void sirfsoc_gpio_irq_mask(struct irq_data *d)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(d->hwirq);
> +       struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +       struct sirfsoc_gpio_chip *sgpio = to_sirfsoc_gpio(gc);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(sgpio, d->hwirq);
>
> -       __sirfsoc_gpio_irq_mask(bank, d->hwirq % SIRFSOC_GPIO_BANK_SIZE);
> +       __sirfsoc_gpio_irq_mask(sgpio, bank, d->hwirq % SIRFSOC_GPIO_BANK_SIZE);
>  }
>
>  static void sirfsoc_gpio_irq_unmask(struct irq_data *d)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(d->hwirq);
> -       int idx = d->hwirq % SIRFSOC_GPIO_BANK_SIZE;
> +       struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +       struct sirfsoc_gpio_chip *sgpio = to_sirfsoc_gpio(gc);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(sgpio, d->hwirq);
> +       int idx = sirfsoc_gpio_to_bankoff(d->hwirq);
>         u32 val, offset;
>         unsigned long flags;
>
> @@ -504,18 +500,20 @@ static void sirfsoc_gpio_irq_unmask(struct irq_data *d)
>
>         spin_lock_irqsave(&sgpio_lock, flags);
>
> -       val = readl(sgpio_chip.chip.regs + offset);
> +       val = readl(sgpio->chip.regs + offset);
>         val &= ~SIRFSOC_GPIO_CTL_INTR_STS_MASK;
>         val |= SIRFSOC_GPIO_CTL_INTR_EN_MASK;
> -       writel(val, sgpio_chip.chip.regs + offset);
> +       writel(val, sgpio->chip.regs + offset);
>
>         spin_unlock_irqrestore(&sgpio_lock, flags);
>  }
>
>  static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(d->hwirq);
> -       int idx = d->hwirq % SIRFSOC_GPIO_BANK_SIZE;
> +       struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +       struct sirfsoc_gpio_chip *sgpio = to_sirfsoc_gpio(gc);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(sgpio, d->hwirq);
> +       int idx = sirfsoc_gpio_to_bankoff(d->hwirq);
>         u32 val, offset;
>         unsigned long flags;
>
> @@ -523,7 +521,7 @@ static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
>
>         spin_lock_irqsave(&sgpio_lock, flags);
>
> -       val = readl(sgpio_chip.chip.regs + offset);
> +       val = readl(sgpio->chip.regs + offset);
>         val &= ~(SIRFSOC_GPIO_CTL_INTR_STS_MASK | SIRFSOC_GPIO_CTL_OUT_EN_MASK);
>
>         switch (type) {
> @@ -551,7 +549,7 @@ static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
>                 break;
>         }
>
> -       writel(val, sgpio_chip.chip.regs + offset);
> +       writel(val, sgpio->chip.regs + offset);
>
>         spin_unlock_irqrestore(&sgpio_lock, flags);
>
> @@ -568,6 +566,8 @@ static struct irq_chip sirfsoc_irq_chip = {
>
>  static void sirfsoc_gpio_handle_irq(unsigned int irq, struct irq_desc *desc)
>  {
> +       struct gpio_chip *gc = irq_desc_get_handler_data(desc);
> +       struct sirfsoc_gpio_chip *sgpio = to_sirfsoc_gpio(gc);
>         struct sirfsoc_gpio_bank *bank;
>         u32 status, ctrl;
>         int idx = 0;
> @@ -575,7 +575,7 @@ static void sirfsoc_gpio_handle_irq(unsigned int irq, struct irq_desc *desc)
>         int i;
>
>         for (i = 0; i < SIRFSOC_GPIO_BANK_SIZE; i++) {
> -               bank = &sgpio_chip.sgpio_bank[i];
> +               bank = &sgpio->sgpio_bank[i];
>                 if (bank->parent_irq == irq)
>                         break;
>         }
> @@ -583,7 +583,7 @@ static void sirfsoc_gpio_handle_irq(unsigned int irq, struct irq_desc *desc)
>
>         chained_irq_enter(chip, desc);
>
> -       status = readl(sgpio_chip.chip.regs + SIRFSOC_GPIO_INT_STATUS(bank->id));
> +       status = readl(sgpio->chip.regs + SIRFSOC_GPIO_INT_STATUS(bank->id));
>         if (!status) {
>                 printk(KERN_WARNING
>                         "%s: gpio id %d status %#x no interrupt is flaged\n",
> @@ -593,7 +593,7 @@ static void sirfsoc_gpio_handle_irq(unsigned int irq, struct irq_desc *desc)
>         }
>
>         while (status) {
> -               ctrl = readl(sgpio_chip.chip.regs + SIRFSOC_GPIO_CTRL(bank->id, idx));
> +               ctrl = readl(sgpio->chip.regs + SIRFSOC_GPIO_CTRL(bank->id, idx));
>
>                 /*
>                  * Here we must check whether the corresponding GPIO's interrupt
> @@ -602,7 +602,7 @@ static void sirfsoc_gpio_handle_irq(unsigned int irq, struct irq_desc *desc)
>                 if ((status & 0x1) && (ctrl & SIRFSOC_GPIO_CTL_INTR_EN_MASK)) {
>                         pr_debug("%s: gpio id %d idx %d happens\n",
>                                 __func__, bank->id, idx);
> -                       generic_handle_irq(irq_find_mapping(sgpio_chip.chip.gc.irqdomain, idx +
> +                       generic_handle_irq(irq_find_mapping(gc->irqdomain, idx +
>                                         bank->id * SIRFSOC_GPIO_BANK_SIZE));
>                 }
>
> @@ -613,18 +613,20 @@ static void sirfsoc_gpio_handle_irq(unsigned int irq, struct irq_desc *desc)
>         chained_irq_exit(chip, desc);
>  }
>
> -static inline void sirfsoc_gpio_set_input(struct sirfsoc_gpio_bank *bank, unsigned ctrl_offset)
> +static inline void sirfsoc_gpio_set_input(struct sirfsoc_gpio_chip *sgpio,
> +                                         unsigned ctrl_offset)
>  {
>         u32 val;
>
> -       val = readl(sgpio_chip.chip.regs + ctrl_offset);
> +       val = readl(sgpio->chip.regs + ctrl_offset);
>         val &= ~SIRFSOC_GPIO_CTL_OUT_EN_MASK;
> -       writel(val, sgpio_chip.chip.regs + ctrl_offset);
> +       writel(val, sgpio->chip.regs + ctrl_offset);
>  }
>
>  static int sirfsoc_gpio_request(struct gpio_chip *chip, unsigned offset)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(offset);
> +       struct sirfsoc_gpio_chip *sgpio = to_sirfsoc_gpio(chip);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(sgpio, offset);
>         unsigned long flags;
>
>         if (pinctrl_request_gpio(chip->base + offset))
> @@ -636,8 +638,8 @@ static int sirfsoc_gpio_request(struct gpio_chip *chip, unsigned offset)
>          * default status:
>          * set direction as input and mask irq
>          */
> -       sirfsoc_gpio_set_input(bank, SIRFSOC_GPIO_CTRL(bank->id, offset));
> -       __sirfsoc_gpio_irq_mask(bank, offset);
> +       sirfsoc_gpio_set_input(sgpio, SIRFSOC_GPIO_CTRL(bank->id, offset));
> +       __sirfsoc_gpio_irq_mask(sgpio, bank, offset);
>
>         spin_unlock_irqrestore(&bank->lock, flags);
>
> @@ -646,13 +648,14 @@ static int sirfsoc_gpio_request(struct gpio_chip *chip, unsigned offset)
>
>  static void sirfsoc_gpio_free(struct gpio_chip *chip, unsigned offset)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(offset);
> +       struct sirfsoc_gpio_chip *sgpio = to_sirfsoc_gpio(chip);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(sgpio, offset);
>         unsigned long flags;
>
>         spin_lock_irqsave(&bank->lock, flags);
>
> -       __sirfsoc_gpio_irq_mask(bank, offset);
> -       sirfsoc_gpio_set_input(bank, SIRFSOC_GPIO_CTRL(bank->id, offset));
> +       __sirfsoc_gpio_irq_mask(sgpio, bank, offset);
> +       sirfsoc_gpio_set_input(sgpio, SIRFSOC_GPIO_CTRL(bank->id, offset));
>
>         spin_unlock_irqrestore(&bank->lock, flags);
>
> @@ -661,7 +664,8 @@ static void sirfsoc_gpio_free(struct gpio_chip *chip, unsigned offset)
>
>  static int sirfsoc_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(gpio);
> +       struct sirfsoc_gpio_chip *sgpio = to_sirfsoc_gpio(chip);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(sgpio, gpio);
>         int idx = sirfsoc_gpio_to_bankoff(gpio);
>         unsigned long flags;
>         unsigned offset;
> @@ -670,22 +674,24 @@ static int sirfsoc_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
>
>         spin_lock_irqsave(&bank->lock, flags);
>
> -       sirfsoc_gpio_set_input(bank, offset);
> +       sirfsoc_gpio_set_input(sgpio, offset);
>
>         spin_unlock_irqrestore(&bank->lock, flags);
>
>         return 0;
>  }
>
> -static inline void sirfsoc_gpio_set_output(struct sirfsoc_gpio_bank *bank, unsigned offset,
> -       int value)
> +static inline void sirfsoc_gpio_set_output(struct sirfsoc_gpio_chip *sgpio,
> +                                          struct sirfsoc_gpio_bank *bank,
> +                                          unsigned offset,
> +                                          int value)
>  {
>         u32 out_ctrl;
>         unsigned long flags;
>
>         spin_lock_irqsave(&bank->lock, flags);
>
> -       out_ctrl = readl(sgpio_chip.chip.regs + offset);
> +       out_ctrl = readl(sgpio->chip.regs + offset);
>         if (value)
>                 out_ctrl |= SIRFSOC_GPIO_CTL_DATAOUT_MASK;
>         else
> @@ -693,14 +699,15 @@ static inline void sirfsoc_gpio_set_output(struct sirfsoc_gpio_bank *bank, unsig
>
>         out_ctrl &= ~SIRFSOC_GPIO_CTL_INTR_EN_MASK;
>         out_ctrl |= SIRFSOC_GPIO_CTL_OUT_EN_MASK;
> -       writel(out_ctrl, sgpio_chip.chip.regs + offset);
> +       writel(out_ctrl, sgpio->chip.regs + offset);
>
>         spin_unlock_irqrestore(&bank->lock, flags);
>  }
>
>  static int sirfsoc_gpio_direction_output(struct gpio_chip *chip, unsigned gpio, int value)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(gpio);
> +       struct sirfsoc_gpio_chip *sgpio = to_sirfsoc_gpio(chip);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(sgpio, gpio);
>         int idx = sirfsoc_gpio_to_bankoff(gpio);
>         u32 offset;
>         unsigned long flags;
> @@ -709,7 +716,7 @@ static int sirfsoc_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
>
>         spin_lock_irqsave(&sgpio_lock, flags);
>
> -       sirfsoc_gpio_set_output(bank, offset, value);
> +       sirfsoc_gpio_set_output(sgpio, bank, offset, value);
>
>         spin_unlock_irqrestore(&sgpio_lock, flags);
>
> @@ -718,13 +725,14 @@ static int sirfsoc_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
>
>  static int sirfsoc_gpio_get_value(struct gpio_chip *chip, unsigned offset)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(offset);
> +       struct sirfsoc_gpio_chip *sgpio = to_sirfsoc_gpio(chip);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(sgpio, offset);
>         u32 val;
>         unsigned long flags;
>
>         spin_lock_irqsave(&bank->lock, flags);
>
> -       val = readl(sgpio_chip.chip.regs + SIRFSOC_GPIO_CTRL(bank->id, offset));
> +       val = readl(sgpio->chip.regs + SIRFSOC_GPIO_CTRL(bank->id, offset));
>
>         spin_unlock_irqrestore(&bank->lock, flags);
>
> @@ -734,23 +742,25 @@ static int sirfsoc_gpio_get_value(struct gpio_chip *chip, unsigned offset)
>  static void sirfsoc_gpio_set_value(struct gpio_chip *chip, unsigned offset,
>         int value)
>  {
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(offset);
> +       struct sirfsoc_gpio_chip *sgpio = to_sirfsoc_gpio(chip);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(sgpio, offset);
>         u32 ctrl;
>         unsigned long flags;
>
>         spin_lock_irqsave(&bank->lock, flags);
>
> -       ctrl = readl(sgpio_chip.chip.regs + SIRFSOC_GPIO_CTRL(bank->id, offset));
> +       ctrl = readl(sgpio->chip.regs + SIRFSOC_GPIO_CTRL(bank->id, offset));
>         if (value)
>                 ctrl |= SIRFSOC_GPIO_CTL_DATAOUT_MASK;
>         else
>                 ctrl &= ~SIRFSOC_GPIO_CTL_DATAOUT_MASK;
> -       writel(ctrl, sgpio_chip.chip.regs + SIRFSOC_GPIO_CTRL(bank->id, offset));
> +       writel(ctrl, sgpio->chip.regs + SIRFSOC_GPIO_CTRL(bank->id, offset));
>
>         spin_unlock_irqrestore(&bank->lock, flags);
>  }
>
> -static void sirfsoc_gpio_set_pullup(const u32 *pullups)
> +static void sirfsoc_gpio_set_pullup(struct sirfsoc_gpio_chip *sgpio,
> +                                   const u32 *pullups)
>  {
>         int i, n;
>         const unsigned long *p = (const unsigned long *)pullups;
> @@ -758,15 +768,16 @@ static void sirfsoc_gpio_set_pullup(const u32 *pullups)
>         for (i = 0; i < SIRFSOC_GPIO_NO_OF_BANKS; i++) {
>                 for_each_set_bit(n, p + i, BITS_PER_LONG) {
>                         u32 offset = SIRFSOC_GPIO_CTRL(i, n);
> -                       u32 val = readl(sgpio_chip.chip.regs + offset);
> +                       u32 val = readl(sgpio->chip.regs + offset);
>                         val |= SIRFSOC_GPIO_CTL_PULL_MASK;
>                         val |= SIRFSOC_GPIO_CTL_PULL_HIGH;
> -                       writel(val, sgpio_chip.chip.regs + offset);
> +                       writel(val, sgpio->chip.regs + offset);
>                 }
>         }
>  }
>
> -static void sirfsoc_gpio_set_pulldown(const u32 *pulldowns)
> +static void sirfsoc_gpio_set_pulldown(struct sirfsoc_gpio_chip *sgpio,
> +                                     const u32 *pulldowns)
>  {
>         int i, n;
>         const unsigned long *p = (const unsigned long *)pulldowns;
> @@ -774,10 +785,10 @@ static void sirfsoc_gpio_set_pulldown(const u32 *pulldowns)
>         for (i = 0; i < SIRFSOC_GPIO_NO_OF_BANKS; i++) {
>                 for_each_set_bit(n, p + i, BITS_PER_LONG) {
>                         u32 offset = SIRFSOC_GPIO_CTRL(i, n);
> -                       u32 val = readl(sgpio_chip.chip.regs + offset);
> +                       u32 val = readl(sgpio->chip.regs + offset);
>                         val |= SIRFSOC_GPIO_CTL_PULL_MASK;
>                         val &= ~SIRFSOC_GPIO_CTL_PULL_HIGH;
> -                       writel(val, sgpio_chip.chip.regs + offset);
> +                       writel(val, sgpio->chip.regs + offset);
>                 }
>         }
>  }
> @@ -785,6 +796,7 @@ static void sirfsoc_gpio_set_pulldown(const u32 *pulldowns)
>  static int sirfsoc_gpio_probe(struct device_node *np)
>  {
>         int i, err = 0;
> +       static struct sirfsoc_gpio_chip *sgpio;
>         struct sirfsoc_gpio_bank *bank;
>         void __iomem *regs;
>         struct platform_device *pdev;
> @@ -796,6 +808,10 @@ static int sirfsoc_gpio_probe(struct device_node *np)
>         if (!pdev)
>                 return -ENODEV;
>
> +       sgpio = devm_kzalloc(&pdev->dev, sizeof(*sgpio), GFP_KERNEL);
> +       if (!sgpio)
> +               return -ENOMEM;
> +
>         regs = of_iomap(np, 0);
>         if (!regs)
>                 return -ENOMEM;
> @@ -803,30 +819,30 @@ static int sirfsoc_gpio_probe(struct device_node *np)
>         if (of_device_is_compatible(np, "sirf,marco-pinctrl"))
>                 is_marco = 1;
>
> -       sgpio_chip.chip.gc.request = sirfsoc_gpio_request;
> -       sgpio_chip.chip.gc.free = sirfsoc_gpio_free;
> -       sgpio_chip.chip.gc.direction_input = sirfsoc_gpio_direction_input;
> -       sgpio_chip.chip.gc.get = sirfsoc_gpio_get_value;
> -       sgpio_chip.chip.gc.direction_output = sirfsoc_gpio_direction_output;
> -       sgpio_chip.chip.gc.set = sirfsoc_gpio_set_value;
> -       sgpio_chip.chip.gc.base = 0;
> -       sgpio_chip.chip.gc.ngpio = SIRFSOC_GPIO_BANK_SIZE * SIRFSOC_GPIO_NO_OF_BANKS;
> -       sgpio_chip.chip.gc.label = kstrdup(np->full_name, GFP_KERNEL);
> -       sgpio_chip.chip.gc.of_node = np;
> -       sgpio_chip.chip.gc.of_xlate = sirfsoc_gpio_of_xlate;
> -       sgpio_chip.chip.gc.of_gpio_n_cells = 2;
> -       sgpio_chip.chip.gc.dev = &pdev->dev;
> -       sgpio_chip.chip.regs = regs;
> -       sgpio_chip.is_marco = is_marco;
> -
> -       err = gpiochip_add(&sgpio_chip.chip.gc);
> +       sgpio->chip.gc.request = sirfsoc_gpio_request;
> +       sgpio->chip.gc.free = sirfsoc_gpio_free;
> +       sgpio->chip.gc.direction_input = sirfsoc_gpio_direction_input;
> +       sgpio->chip.gc.get = sirfsoc_gpio_get_value;
> +       sgpio->chip.gc.direction_output = sirfsoc_gpio_direction_output;
> +       sgpio->chip.gc.set = sirfsoc_gpio_set_value;
> +       sgpio->chip.gc.base = 0;
> +       sgpio->chip.gc.ngpio = SIRFSOC_GPIO_BANK_SIZE * SIRFSOC_GPIO_NO_OF_BANKS;
> +       sgpio->chip.gc.label = kstrdup(np->full_name, GFP_KERNEL);
> +       sgpio->chip.gc.of_node = np;
> +       sgpio->chip.gc.of_xlate = sirfsoc_gpio_of_xlate;
> +       sgpio->chip.gc.of_gpio_n_cells = 2;
> +       sgpio->chip.gc.dev = &pdev->dev;
> +       sgpio->chip.regs = regs;
> +       sgpio->is_marco = is_marco;
> +
> +       err = gpiochip_add(&sgpio->chip.gc);
>         if (err) {
>                 dev_err(&pdev->dev, "%s: error in probe function with status %d\n",
>                         np->full_name, err);
>                 goto out;
>         }
>
> -       err =  gpiochip_irqchip_add(&sgpio_chip.chip.gc,
> +       err =  gpiochip_irqchip_add(&sgpio->chip.gc,
>                 &sirfsoc_irq_chip,
>                 0, handle_level_irq,
>                 IRQ_TYPE_NONE);
> @@ -837,30 +853,42 @@ static int sirfsoc_gpio_probe(struct device_node *np)
>         }
>
>         for (i = 0; i < SIRFSOC_GPIO_NO_OF_BANKS; i++) {
> -               bank = &sgpio_chip.sgpio_bank[i];
> +               bank = &sgpio->sgpio_bank[i];
>                 spin_lock_init(&bank->lock);
>                 bank->parent_irq = platform_get_irq(pdev, i);
>                 if (bank->parent_irq < 0) {
>                         err = bank->parent_irq;
> -                       goto out;
> +                       goto out_banks;
>                 }
>
> -               gpiochip_set_chained_irqchip(&sgpio_chip.chip.gc,
> +               gpiochip_set_chained_irqchip(&sgpio->chip.gc,
>                         &sirfsoc_irq_chip,
>                         bank->parent_irq,
>                         sirfsoc_gpio_handle_irq);
>         }
>
> +       err = gpiochip_add_pin_range(&sgpio->chip.gc, "sirfsoc-gpio*",
> +               0, 0, SIRFSOC_GPIO_BANK_SIZE * SIRFSOC_GPIO_NO_OF_BANKS);
> +       if (err) {
> +               dev_err(&pdev->dev,
> +                       "could not add gpiochip pin range\n");
> +               goto out_no_range;
> +       }
> +
>         if (!of_property_read_u32_array(np, "sirf,pullups", pullups,
>                 SIRFSOC_GPIO_NO_OF_BANKS))
> -               sirfsoc_gpio_set_pullup(pullups);
> +               sirfsoc_gpio_set_pullup(sgpio, pullups);
>
>         if (!of_property_read_u32_array(np, "sirf,pulldowns", pulldowns,
>                 SIRFSOC_GPIO_NO_OF_BANKS))
> -               sirfsoc_gpio_set_pulldown(pulldowns);
> +               sirfsoc_gpio_set_pulldown(sgpio, pulldowns);
>
>         return 0;
>
> +out_no_range:
> +out_banks:
> +       if (gpiochip_remove(&sgpio->chip.gc))
> +               dev_err(&pdev->dev, "could not remove gpio chip\n");
>  out:
>         iounmap(regs);
>         return err;
> --
> 1.9.0
>

-barry
