Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbaD2H74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:59:56 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42355 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678AbaD2H7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:59:54 -0400
Date: Tue, 29 Apr 2014 08:59:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com
Subject: Re: [PATCH v2 2/2] mfd: max77693: handle IRQs using regmap
Message-ID: <20140429075948.GB29462@lee--X1>
References: <1398750527-20715-1-git-send-email-r.baldyga@samsung.com>
 <1398750527-20715-3-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398750527-20715-3-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch modifies mfd driver to use regmap for handling interrupts.
> It allows to simplify irq handling process. This modifications needed
> to make small changes in function drivers, which use interrupts.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/extcon/extcon-max77693.c     |   3 +-
>  drivers/mfd/Kconfig                  |   1 +
>  drivers/mfd/Makefile                 |   2 +-
>  drivers/mfd/max77693-irq.c           | 346 -----------------------------------
>  drivers/mfd/max77693.c               | 151 ++++++++++++++-
>  include/linux/mfd/max77693-private.h |  47 ++++-
>  6 files changed, 191 insertions(+), 359 deletions(-)
>  delete mode 100644 drivers/mfd/max77693-irq.c

Patch looks _mostly_ okay and the diffstat looks great.

[...]

> +static const struct regmap_irq max77693_led_irqs[] = {
> +	{ .mask = LED_IRQ_FLED2_OPEN, },
> +	{ .mask = LED_IRQ_FLED2_SHORT, },
> +	{ .mask = LED_IRQ_FLED1_OPEN, },
> +	{ .mask = LED_IRQ_FLED1_SHORT, },
> +	{ .mask = LED_IRQ_MAX_FLASH, },
> +};

Tiny-nit: If you can line those '}'s up, that'd be great. :)

Same below. You've already gone to the trouble with the '='s.

/me likes straight lines.

> +static const struct regmap_irq_chip max77693_led_irq_chip = {
> +	.name                   = "max77693-led",
> +	.status_base            = MAX77693_LED_REG_FLASH_INT,
> +	.mask_base              = MAX77693_LED_REG_FLASH_INT_MASK,
> +	.mask_invert            = false,
> +	.num_regs               = 1,
> +	.irqs                   = max77693_led_irqs,
> +	.num_irqs               = ARRAY_SIZE(max77693_led_irqs),
> +};
> +
> +static const struct regmap_irq max77693_topsys_irqs[] = {
> +	{ .mask = TOPSYS_IRQ_T120C_INT, },
> +	{ .mask = TOPSYS_IRQ_T140C_INT, },
> +	{ .mask = TOPSYS_IRQ_LOWSYS_INT, },
> +};

[...]

> +#define LED_IRQ_FLED2_OPEN		(0x1 << 0)
> +#define LED_IRQ_FLED2_SHORT		(0x1 << 1)
> +#define LED_IRQ_FLED1_OPEN		(0x1 << 2)
> +#define LED_IRQ_FLED1_SHORT		(0x1 << 3)
> +#define LED_IRQ_MAX_FLASH		(0x1 << 4)
> +
> +#define TOPSYS_IRQ_T120C_INT		(0x1 << 0)
> +#define TOPSYS_IRQ_T140C_INT		(0x1 << 1)
> +#define TOPSYS_IRQ_LOWSYS_INT		(0x1 << 3)
> +
> +#define CHG_IRQ_BYP_I			(0x1 << 0)
> +#define CHG_IRQ_THM_I			(0x1 << 2)
> +#define CHG_IRQ_BAT_I			(0x1 << 3)
> +#define CHG_IRQ_CHG_I			(0x1 << 4)
> +#define CHG_IRQ_CHGIN_I			(0x1 << 6)
> +
> +#define MUIC_IRQ_INT1_ADC		(0x1 << 0)
> +#define MUIC_IRQ_INT1_ADC_LOW		(0x1 << 1)
> +#define MUIC_IRQ_INT1_ADC_ERR		(0x1 << 2)
> +#define MUIC_IRQ_INT1_ADC1K		(0x1 << 3)
> +
> +#define MUIC_IRQ_INT2_CHGTYP		(0x1 << 0)
> +#define MUIC_IRQ_INT2_CHGDETREUN	(0x1 << 1)
> +#define MUIC_IRQ_INT2_DCDTMR		(0x1 << 2)
> +#define MUIC_IRQ_INT2_DXOVP		(0x1 << 3)
> +#define MUIC_IRQ_INT2_VBVOLT		(0x1 << 4)
> +#define MUIC_IRQ_INT2_VIDRM		(0x1 << 5)
> +
> +#define MUIC_IRQ_INT3_EOC		(0x1 << 0)
> +#define MUIC_IRQ_INT3_CGMBC		(0x1 << 1)
> +#define MUIC_IRQ_INT3_OVP		(0x1 << 2)
> +#define MUIC_IRQ_INT3_MBCCHG_ERR	(0x1 << 3)
> +#define MUIC_IRQ_INT3_CHG_ENABLED	(0x1 << 4)
> +#define MUIC_IRQ_INT3_BAT_DET		(0x1 << 5)

Use BIT() for these.

> +
> +

One more '\n' than you need.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
