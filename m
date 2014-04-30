Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbaD3LLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:11:33 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:50921 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427AbaD3LLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:11:31 -0400
X-AuditID: cbfec373-b7f236d000004b34-09-5360da62b1fa
Date: Wed, 30 Apr 2014 04:11:27 -0700
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?0JDQu9C10LrRgdCw0L3QtNGAINCR0LXRgNGB0LXQvdC10LI=?= 
	<bay@hackerdom.ru>
Cc: linux-sunxi@googlegroups.com, maxime.ripard@free-electrons.com,
        grant.likely@linaro.org, robh+dt@kernel.org, sean@mess.org,
        james.hogan@imgtec.com, david@hardeman.nu, srinivas.kandagatla@st.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 02/03] ARM: sunxi: Add driver for sunxi IR controller
Message-id: <20140430041127.450b913f.m.chehab@samsung.com>
In-reply-to: <3881d16f-578a-417b-8a55-ea9bad5af206@googlegroups.com>
References: <d641a69a-01b4-443d-b121-48d13f46ee03@googlegroups.com>
 <3881d16f-578a-417b-8a55-ea9bad5af206@googlegroups.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t/hYN2kWwnBBjd3y1vcvidgcfHIOnaL
	+UfOsVoc+LOD0eLdvBfMFpseX2O1uLxrDptFz4atrBa/Hx1jt9i6aS+zReveI+wWC59+Z7GY
	8qyX1YHX48mmi4weeyaeZPM4snsuo8eJ+13MHj07zzB6bFrVyeZx59oeNo/NS+o9lryx9nj6
	Yy+zx+dNcgHcUVw2Kak5mWWpRfp2CVwZ7+4cZyp4HVfRc8avgfGidxcjJ4eEgInE5lOPWCFs
	MYkL99azgdhCAksYJZovuHYxcgHZzUwSH2f2gBWxCKhK/L6zmh3EZhMwknjV2AIWFxEIlZh4
	5yI7SAOzwCkmiXULbrKAJIQFfCRaj91lArF5BawkJm3eBdbMKeAi8WjBFaBtHEAbaiVOtZpB
	HOEk8er1ZKhyQYkfk++BjWEWUJeYNG8RM4StLfHk3QXWCYwCs5CUzUJSNgtJ2QJG5lWMoqXF
	yQXFSem5RnrFibnFpXnpesn5uZsYIVFVvIPxxQarQ4wCHIxKPLwCW+ODhVgTy4orcw8xSnAw
	K4nwzjmaECzEm5JYWZValB9fVJqTWnyIkYmDU6qBscyWaeZSRYO0I/x7WY7+ZUhdU3Q9n0dG
	b276B+Vlx3RksosW/2wSZKlcnTCtbp3fxe3X7DNPnei1Ln9+wivjs/z0M1Yue0u8rrZ38Kxe
	5c6gHf1eYQtngnv63Hj+HwKShRsn3MxsNbg2t+birJeaZzk5kn4o9AdNeyKe1H2GTdxfIWbV
	lU3KSizFGYmGWsxFxYkAozLsv4gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 30 Apr 2014 03:58:18 -0700 (PDT)
Александр Берсенев <bay@hackerdom.ru> escreveu:

> [PATCH v4 02/03] ARM: sunxi: Add driver for sunxi IR controller
> 
> This patch adds driver for sunxi IR controller.
> It is based on Alexsey Shestacov's work based on the original driver 
> supplied by Allwinner.
> 
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
> Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 8fbd377..9427fad 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -343,4 +343,14 @@ config RC_ST
>  
>   If you're not sure, select N here.
>  
> +config IR_SUNXI
> +    tristate "SUNXI IR remote control"
> +    depends on RC_CORE
> +    depends on ARCH_SUNXI
> +    ---help---
> +      Say Y if you want to use sunXi internal IR Controller
> +
> +      To compile this driver as a module, choose M here: the module will
> +      be called sunxi-ir.
> +
>  endif #RC_DEVICES
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index f8b54ff..93cdbe9 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -32,4 +32,5 @@ obj-$(CONFIG_IR_GPIO_CIR) += gpio-ir-recv.o
>  obj-$(CONFIG_IR_IGUANA) += iguanair.o
>  obj-$(CONFIG_IR_TTUSBIR) += ttusbir.o
>  obj-$(CONFIG_RC_ST) += st_rc.o
> +obj-$(CONFIG_IR_SUNXI) += sunxi-ir.o
>  obj-$(CONFIG_IR_IMG) += img-ir/
> diff --git a/drivers/media/rc/sunxi-ir.c b/drivers/media/rc/sunxi-ir.c
> new file mode 100644
> index 0000000..f051d94
> --- /dev/null
> +++ b/drivers/media/rc/sunxi-ir.c
> @@ -0,0 +1,303 @@
> +/*
> + * Driver for Allwinner sunXi IR controller
> + *
> + * Copyright (C) 2014 Alexsey Shestacov <wingrime@linux-sunxi.org>
> + * Copyright (C) 2014 Alexander Bersenev <bay@hackerdom.ru>
> + *
> + * Based on sun5i-ir.c:
> + * Copyright (C) 2007-2012 Daniel Wang
> + * Allwinner Technology Co., Ltd. <www.allwinnertech.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of_platform.h>
> +#include <media/rc-core.h>
> +
> +#define SUNXI_IR_DEV "sunxi-ir"
> +
> +/* Registers */
> +/* IR Control */
> +#define SUNXI_IR_CTL_REG      0x00
> +/* Rx Config */
> +#define SUNXI_IR_RXCTL_REG    0x10
> +/* Rx Data */
> +#define SUNXI_IR_RXFIFO_REG   0x20
> +/* Rx Interrupt Enable */
> +#define SUNXI_IR_RXINT_REG    0x2C
> +/* Rx Interrupt Status */
> +#define SUNXI_IR_RXSTA_REG    0x30
> +/* IR Sample Config */
> +#define SUNXI_IR_CIR_REG      0x34
> +
> +/* Bit Definition of IR_RXINTS_REG Register */
> +#define SUNXI_IR_RXINTS_RXOF  BIT(0) /* Rx FIFO Overflow */
> +#define SUNXI_IR_RXINTS_RXPE  BIT(1) /* Rx Packet End */
> +#define SUNXI_IR_RXINTS_RXDA  BIT(4) /* Rx FIFO Data Available */
> +/* Hardware supported fifo size */
> +#define SUNXI_IR_FIFO_SIZE    16
> +/* How much messages in fifo triggers IRQ */
> +#define SUNXI_IR_FIFO_TRIG    8
> +/* Required frequency for IR0 or IR1 clock in CIR mode */
> +#define SUNXI_IR_BASE_CLK     8000000
> +/* Frequency after IR internal divider  */
> +#define SUNXI_IR_CLK          (SUNXI_IR_BASE_CLK / 64)
> +/* Sample period in ns */
> +#define SUNXI_IR_SAMPLE       (1000000000ul / SUNXI_IR_CLK)
> +/* Filter threshold in samples  */
> +#define SUNXI_IR_RXFILT       1
> +/* Idle Threshold in samples */
> +#define SUNXI_IR_RXIDLE       20
> +/* Time after which device stops sending data in ms */
> +#define SUNXI_IR_TIMEOUT      120
> +
> +struct sunxi_ir {
> + spinlock_t      ir_lock;
> + struct rc_dev   *rc;
> + void __iomem    *base;
> + int             irq;
> + struct clk      *clk;
> + struct clk      *apb_clk;
> + const char      *map_name;
> +};

Still badly indented. Maybe your emailer is mangling whitespaces.

The best is to use git send-email to send the patches.

Also, please c/c linux-media ML for the entire patch series, as, in general,
we generally merge all patches via one tree (typically, the tree to where the
real driver will be merged - in this case, the media tree), after getting
the needed acks from DT and arm subarch maintainers (when applicable).

I'll do a better review after the whitespace fixups.

Regards,
Mauro

> +
> +static irqreturn_t sunxi_ir_irq(int irqno, void *dev_id)
> +{
> + unsigned long status;
> + unsigned char dt;
> + unsigned int cnt, rc;
> + struct sunxi_ir *ir = dev_id;
> + DEFINE_IR_RAW_EVENT(rawir);
> +
> + spin_lock_irq(&ir->ir_lock);
> +
> + status = readl(ir->base + SUNXI_IR_RXSTA_REG);
> +
> + /* clean all pending statuses */
> + writel(status | 0xff, ir->base + SUNXI_IR_RXSTA_REG);
> +
> + if (status & SUNXI_IR_RXINTS_RXDA) {
> + /* How much messages in fifo */
> + rc  = (status >> 8) & 0x3f;
> + /* Sanity check */
> + rc = rc > SUNXI_IR_FIFO_SIZE ? SUNXI_IR_FIFO_SIZE : rc;
> + /* if we have data */
> + for (cnt = 0; cnt < rc; cnt++) {
> + /* for each bit in fifo */
> + dt = readb(ir->base + SUNXI_IR_RXFIFO_REG);
> + rawir.pulse = (dt & 0x80) != 0;
> + rawir.duration = (dt & 0x7f) * SUNXI_IR_SAMPLE;
> + ir_raw_event_store_with_filter(ir->rc, &rawir);
> + }
> + }
> +
> + if (status & SUNXI_IR_RXINTS_RXOF)
> + ir_raw_event_reset(ir->rc);
> + else if (status & SUNXI_IR_RXINTS_RXPE) {
> + ir_raw_event_set_idle(ir->rc, true);
> + ir_raw_event_handle(ir->rc);
> + }
> +
> + spin_unlock_irq(&ir->ir_lock);
> +
> + return IRQ_HANDLED;
> +}
> +
> +
> +static int sunxi_ir_probe(struct platform_device *pdev)
> +{
> + int ret = 0;
> + unsigned long tmp = 0;
> +
> + struct device *dev = &pdev->dev;
> + struct device_node *dn = dev->of_node;
> + struct resource *res;
> + struct sunxi_ir *ir;
> +
> + ir = devm_kzalloc(dev, sizeof(struct sunxi_ir), GFP_KERNEL);
> + if (!ir)
> + return -ENOMEM;
> +
> + /* Clock */
> + ir->apb_clk = devm_clk_get(dev, "apb");
> + if (IS_ERR(ir->apb_clk)) {
> + dev_err(dev, "failed to get a apb clock.\n");
> + return -EINVAL;
> + }
> + ir->clk = devm_clk_get(dev, "ir");
> + if (IS_ERR(ir->clk)) {
> + dev_err(dev, "failed to get a ir clock.\n");
> + return -EINVAL;
> + }
> +
> + ret = clk_set_rate(ir->clk, SUNXI_IR_BASE_CLK);
> + if (ret) {
> + dev_err(dev, "set ir base clock failed!\n");
> + return -EINVAL;
> + }
> +
> + if (clk_prepare_enable(ir->apb_clk)) {
> + dev_err(dev, "try to enable apb_ir_clk failed\n");
> + return -EINVAL;
> + }
> +
> + if (clk_prepare_enable(ir->clk)) {
> + dev_err(dev, "try to enable ir_clk failed\n");
> + ret = -EINVAL;
> + goto exit_clkdisable_apb_clk;
> + }
> +
> + /* IO */
> + res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> + ir->base = devm_ioremap_resource(dev, res);
> + if (IS_ERR(ir->base)) {
> + dev_err(dev, "failed to map registers\n");
> + ret = -ENOMEM;
> + goto exit_clkdisable_clk;
> + }
> +
> + /* IRQ */
> + ir->irq = platform_get_irq(pdev, 0);
> + if (ir->irq < 0) {
> + dev_err(dev, "no irq resource\n");
> + ret = -EINVAL;
> + goto exit_clkdisable_clk;
> + }
> +
> + ret = devm_request_irq(dev, ir->irq, sunxi_ir_irq, 0, SUNXI_IR_DEV, ir);
> + if (ret) {
> + dev_err(dev, "failed request irq\n");
> + ret = -EINVAL;
> + goto exit_clkdisable_clk;
> + }
> +
> + ir->rc = rc_allocate_device();
> +
> + if (!ir->rc) {
> + dev_err(dev, "failed to allocate device\n");
> + ret = -ENOMEM;
> + goto exit_clkdisable_clk;
> + }
> +
> + ir->rc->priv = ir;
> + ir->rc->input_name = SUNXI_IR_DEV;
> + ir->rc->input_phys = "sunxi-ir/input0";
> + ir->rc->input_id.bustype = BUS_HOST;
> + ir->rc->input_id.vendor = 0x0001;
> + ir->rc->input_id.product = 0x0001;
> + ir->rc->input_id.version = 0x0100;
> + ir->map_name = of_get_property(dn, "linux,rc-map-name", NULL);
> + ir->rc->map_name = ir->map_name ?: RC_MAP_EMPTY;
> + ir->rc->dev.parent = dev;
> + ir->rc->driver_type = RC_DRIVER_IR_RAW;
> + rc_set_allowed_protocols(ir->rc, RC_BIT_ALL);
> + ir->rc->rx_resolution = SUNXI_IR_SAMPLE;
> + ir->rc->timeout = MS_TO_NS(SUNXI_IR_TIMEOUT);
> + ir->rc->driver_name = SUNXI_IR_DEV;
> +
> + ret = rc_register_device(ir->rc);
> + if (ret) {
> + dev_err(dev, "failed to register rc device\n");
> + ret = -EINVAL;
> + goto exit_free_dev;
> + }
> +
> + platform_set_drvdata(pdev, ir);
> +
> + /* Enable CIR Mode */
> + writel(0x3 << 4, ir->base+SUNXI_IR_CTL_REG);
> +
> + /* Config IR Sample Register */
> + /* Fsample = clk */
> + tmp = 0;
> + /* Set Filter Threshold */
> + tmp |= (SUNXI_IR_RXFILT & 0x3f) << 2;
> + /* Set Idle Threshold */
> + tmp |= (SUNXI_IR_RXIDLE & 0xff) << 8;
> + writel(tmp, ir->base + SUNXI_IR_CIR_REG);
> +
> + /* Invert Input Signal */
> + writel(0x1 << 2, ir->base + SUNXI_IR_RXCTL_REG);
> +
> + /* Clear All Rx Interrupt Status */
> + writel(0xff, ir->base + SUNXI_IR_RXSTA_REG);
> +
> + /* Enable IRQ on data, overflow, packed end */
> + tmp = (0x1 << 4) | 0x3;
> +
> + /* Rx FIFO Threshold */
> + tmp |= (SUNXI_IR_FIFO_TRIG - 1) << 8;
> +
> + writel(tmp, ir->base + SUNXI_IR_RXINT_REG);
> +
> + /* Enable IR Module */
> + tmp = readl(ir->base + SUNXI_IR_CTL_REG);
> +
> + writel(tmp | 0x3, ir->base + SUNXI_IR_CTL_REG);
> +
> + dev_info(dev, "initialized sunXi IR driver\n");
> + return 0;
> +
> +exit_free_dev:
> + rc_free_device(ir->rc);
> +exit_clkdisable_clk:
> + clk_disable_unprepare(ir->clk);
> +exit_clkdisable_apb_clk:
> + clk_disable_unprepare(ir->apb_clk);
> +
> + return ret;
> +}
> +
> +static int sunxi_ir_remove(struct platform_device *pdev)
> +{
> + unsigned long flags;
> + struct sunxi_ir *ir = platform_get_drvdata(pdev);
> +
> + clk_disable_unprepare(ir->clk);
> + clk_disable_unprepare(ir->apb_clk);
> +
> + spin_lock_irqsave(&ir->ir_lock, flags);
> + /* disable IR IRQ */
> + writel(0, ir->base + SUNXI_IR_RXINT_REG);
> + /* clear All Rx Interrupt Status */
> + writel(0xff, ir->base + SUNXI_IR_RXSTA_REG);
> + /* disable IR */
> + writel(0, ir->base + SUNXI_IR_CTL_REG);
> + spin_unlock_irqrestore(&ir->ir_lock, flags);
> +
> + rc_unregister_device(ir->rc);
> + return 0;
> +}
> +
> +static const struct of_device_id sunxi_ir_match[] = {
> + { .compatible = "allwinner,sun7i-a20-ir", },
> + {},
> +};
> +
> +static struct platform_driver sunxi_ir_driver = {
> + .probe          = sunxi_ir_probe,
> + .remove         = sunxi_ir_remove,
> + .driver = {
> + .name = SUNXI_IR_DEV,
> + .owner = THIS_MODULE,
> + .of_match_table = sunxi_ir_match,
> + },
> +};
> +
> +module_platform_driver(sunxi_ir_driver);
> +
> +MODULE_DESCRIPTION("Allwinner sunXi IR controller driver");
> +MODULE_AUTHOR("Alexsey Shestacov <wingrime@linux-sunxi.org>");
> +MODULE_LICENSE("GPL");
> 
> 
> среда, 30 апреля 2014 г., 16:51:12 UTC+6 пользователь Александр Берсенев 
> написал:
> >
> > This patch introduces Consumer IR(CIR) support for sunxi boards.
> >
> > This is based on Alexsey Shestacov's work based on the original driver 
> > supplied by Allwinner.
> >


-- 

Cheers,
Mauro
