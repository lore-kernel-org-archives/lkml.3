Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaKCNOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:14:23 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:62310 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaKCNOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:14:19 -0500
X-AuditID: cbfec372-b7f666d000001846-3d-54577faa80ce
Date: Mon, 03 Nov 2014 11:14:10 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Carlo Caione <carlo@caione.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH 1/3] media: rc: add driver for Amlogic Meson IR remote
 receiver
Message-id: <20141103111410.6b1147a0.m.chehab@samsung.com>
In-reply-to: <1413144115-23188-2-git-send-email-b.galvani@gmail.com>
References: <1413144115-23188-1-git-send-email-b.galvani@gmail.com>
 <1413144115-23188-2-git-send-email-b.galvani@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/hQN1V9eEhBvsncVoc3d3LavFgzXpm
	i/lHzrFa9L9ZyGpx7tVKRoujD16xW2x6fI3V4vKuOWwWPRu2slosvX6RyWLC9LUsFq17j7Bb
	rP72icmB1+PImtWMHmvmrWH06DrZx+Rxua+XyWPnrLvsHiuXf2Hz2LSqk81j85J6j8+b5AI4
	o7hsUlJzMstSi/TtErgyfky8w14w0aeif+05xgbGo7ZdjJwcEgImEjMWNbFA2GISF+6tZ+ti
	5OIQEljCKHHtzG8WCKeBSWJ23ydWkCoWAVWJl01/2EFsNgEjiVeNLUBxDg4RAW2JzqesIPXM
	AmuZJY6eamUDiQsLhEos2JcGUs4rYCWxY+JCZhCbU8BFYs71S2wgtpBArcT57/eYQMolBJwl
	5n/OhigXlPgx+R7YbcwCWhKbtzWxQtjyEpvXvGWewCgwC0nZLCRls5CULWBkXsUoWlqcXFCc
	lJ5rqFecmFtcmpeul5yfu4kREkVFOxifbbA6xCjAwajEw1u5LyxEiDWxrLgy9xCjBAezkgjv
	v5TwECHelMTKqtSi/Pii0pzU4kOMTBycUg2MSy45LlufyN014c/MBGdRnu7StYmNDS9Djr/g
	VFPqrumwEThx5fz2h9UXfrR/fvppxlT7Pc3znPN+Ld/FcF/8frXBtK3hTBvTl7QkL5q8bwn3
	ktK+txuP/FaapjE5oej6Tau0SYytJVfNGGacsDPgMWJg7M9bmH5e9vOFisZdiTq1gopH0gv0
	lViKMxINtZiLihMBAEGTf4ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 12 Oct 2014 22:01:53 +0200
Beniamino Galvani <b.galvani@gmail.com> escreveu:

> Amlogic Meson SoCs include a infrared remote control receiver that can
> operate in two modes: in "NEC" mode the hardware can decode frames
> using the NEC IR protocol, while in "general" mode the receiver simply
> reports the duration of pulses and spaces for software decoding.
> 
> This is a driver for the IR receiver that uses software decoding of
> received frames.

There are a few checkpatch warnings there:

WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#71: 
new file mode 100644

WARNING: Missing a blank line after declarations
#151: FILE: drivers/media/rc/meson-ir.c:76:
+	u32 duration;
+	DEFINE_IR_RAW_EVENT(rawir);

WARNING: DT compatible string "amlogic,meson6-ir" appears un-documented -- check ./Documentation/devicetree/bindings/
#272: FILE: drivers/media/rc/meson-ir.c:197:
+	{ .compatible = "amlogic,meson6-ir" },

total: 0 errors, 3 warnings, 238 lines checked

patches/lmml_26418_1_3_media_rc_add_driver_for_amlogic_meson_ir_remote_receiver.patch has style problems, please review.

I'm seeing that the DT patches are there, after this one. The best
would be to add them before in the series.

Please add also an entry at the MAINTAINERS file.


> 
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---
>  drivers/media/rc/Kconfig    |  11 +++
>  drivers/media/rc/Makefile   |   1 +
>  drivers/media/rc/meson-ir.c | 214 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 226 insertions(+)
>  create mode 100644 drivers/media/rc/meson-ir.c
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 8ce0810..2d742e2 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -223,6 +223,17 @@ config IR_FINTEK
>  	   To compile this driver as a module, choose M here: the
>  	   module will be called fintek-cir.
>  
> +config IR_MESON
> +	tristate "Amlogic Meson IR remote receiver"
> +	depends on RC_CORE
> +	depends on ARCH_MESON

Please add COMPILE_TEST too, as we want to be able to compile it on
x86 and other archs, in order to check if the driver builds fine and
to enable the static analyzers to look into this code.

> +	---help---
> +	   Say Y if you want to use the IR remote receiver available
> +	   on Amlogic Meson SoCs.
> +
> +	   To compile this driver as a module, choose M here: the
> +	   module will be called meson-ir.
> +
>  config IR_NUVOTON
>  	tristate "Nuvoton w836x7hg Consumer Infrared Transceiver"
>  	depends on PNP
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index 0989f94..06859bf 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -22,6 +22,7 @@ obj-$(CONFIG_IR_IMON) += imon.o
>  obj-$(CONFIG_IR_ITE_CIR) += ite-cir.o
>  obj-$(CONFIG_IR_MCEUSB) += mceusb.o
>  obj-$(CONFIG_IR_FINTEK) += fintek-cir.o
> +obj-$(CONFIG_IR_MESON) += meson-ir.o
>  obj-$(CONFIG_IR_NUVOTON) += nuvoton-cir.o
>  obj-$(CONFIG_IR_ENE) += ene_ir.o
>  obj-$(CONFIG_IR_REDRAT3) += redrat3.o
> diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
> new file mode 100644
> index 0000000..0900ece
> --- /dev/null
> +++ b/drivers/media/rc/meson-ir.c
> @@ -0,0 +1,214 @@
> +/*
> + * Driver for Amlogic Meson IR remote receiver
> + *
> + * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program. If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of_platform.h>
> +#include <linux/spinlock.h>
> +
> +#include <media/rc-core.h>
> +
> +#define DRIVER_NAME		"meson-ir"
> +
> +#define IR_DEC_LDR_ACTIVE	0x00
> +#define IR_DEC_LDR_IDLE		0x04
> +#define IR_DEC_LDR_REPEAT	0x08
> +#define IR_DEC_BIT_0		0x0c
> +#define IR_DEC_REG0		0x10
> +#define IR_DEC_FRAME		0x14
> +#define IR_DEC_STATUS		0x18
> +#define IR_DEC_REG1		0x1c
> +
> +#define REG0_RATE_MASK		(BIT(11) - 1)
> +
> +#define REG1_MODE_MASK		(BIT(7) | BIT(8))
> +#define REG1_MODE_NEC		(0 << 7)
> +#define REG1_MODE_GENERAL	(2 << 7)
> +
> +#define REG1_TIME_IV_SHIFT	16
> +#define REG1_TIME_IV_MASK	((BIT(13) - 1) << REG1_TIME_IV_SHIFT)
> +
> +#define REG1_IRQSEL_MASK	(BIT(2) | BIT(3))
> +#define REG1_IRQSEL_NEC_MODE	(0 << 2)
> +#define REG1_IRQSEL_RISE_FALL	(1 << 2)
> +#define REG1_IRQSEL_FALL	(2 << 2)
> +#define REG1_IRQSEL_RISE	(3 << 2)
> +
> +#define REG1_RESET		BIT(0)
> +#define REG1_ENABLE		BIT(15)
> +
> +#define STATUS_IR_DEC_IN	BIT(8)
> +
> +#define MESON_TRATE		10	/* us */
> +
> +struct meson_ir {
> +	void __iomem	*reg;
> +	struct rc_dev	*rc;
> +	int		irq;
> +	spinlock_t	lock;
> +};
> +
> +static void meson_ir_set_mask(struct meson_ir *ir, unsigned int reg,
> +			      u32 mask, u32 value)
> +{
> +	u32 data;
> +
> +	data = readl(ir->reg + reg);
> +	data &= ~mask;
> +	data |= (value & mask);
> +	writel(data, ir->reg + reg);
> +}
> +
> +static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
> +{
> +	struct meson_ir *ir = dev_id;
> +	u32 duration;
> +	DEFINE_IR_RAW_EVENT(rawir);
> +
> +	spin_lock(&ir->lock);
> +
> +	duration = readl(ir->reg + IR_DEC_REG1);
> +	duration = (duration & REG1_TIME_IV_MASK) >> REG1_TIME_IV_SHIFT;
> +	rawir.duration = US_TO_NS(duration * MESON_TRATE);
> +
> +	rawir.pulse = !!(readl(ir->reg + IR_DEC_STATUS) & STATUS_IR_DEC_IN);
> +
> +	ir_raw_event_store_with_filter(ir->rc, &rawir);
> +	ir_raw_event_handle(ir->rc);
> +
> +	spin_unlock(&ir->lock);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int meson_ir_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *node = dev->of_node;
> +	struct resource *res;
> +	const char *map_name;
> +	struct meson_ir *ir;
> +	int ret;
> +
> +	ir = devm_kzalloc(dev, sizeof(struct meson_ir), GFP_KERNEL);
> +	if (!ir)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	ir->reg = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(ir->reg)) {
> +		dev_err(dev, "failed to map registers\n");
> +		return PTR_ERR(ir->reg);
> +	}
> +
> +	ir->irq = platform_get_irq(pdev, 0);
> +	if (ir->irq < 0) {
> +		dev_err(dev, "no irq resource\n");
> +		return ir->irq;
> +	}
> +
> +	ir->rc = rc_allocate_device();
> +	if (!ir->rc) {
> +		dev_err(dev, "failed to allocate rc device\n");
> +		return -ENOMEM;
> +	}
> +
> +	ir->rc->priv = ir;
> +	ir->rc->input_name = DRIVER_NAME;
> +	ir->rc->input_phys = DRIVER_NAME "/input0";
> +	ir->rc->input_id.bustype = BUS_HOST;

> +	ir->rc->input_id.vendor = 0x0001;
> +	ir->rc->input_id.product = 0x0001;
> +	ir->rc->input_id.version = 0x0100;

I don't like very much the idea of filling it like that. From where those
numbers came? Could you add a define for them somewhere?

> +	map_name = of_get_property(node, "linux,rc-map-name", NULL);
> +	ir->rc->map_name = map_name ? map_name : RC_MAP_EMPTY;
> +	ir->rc->dev.parent = dev;
> +	ir->rc->driver_type = RC_DRIVER_IR_RAW;
> +	ir->rc->allowed_protocols = RC_BIT_ALL;
> +	ir->rc->rx_resolution = US_TO_NS(MESON_TRATE);
> +	ir->rc->timeout = MS_TO_NS(200);
> +	ir->rc->driver_name = DRIVER_NAME;
> +
> +	spin_lock_init(&ir->lock);
> +	platform_set_drvdata(pdev, ir);
> +
> +	ret = rc_register_device(ir->rc);
> +	if (ret) {
> +		dev_err(dev, "failed to register rc device\n");
> +		goto out_free;
> +	}
> +
> +	ret = devm_request_irq(dev, ir->irq, meson_ir_irq, 0, "ir-meson", ir);
> +	if (ret) {
> +		dev_err(dev, "failed to request irq\n");
> +		goto out_unreg;
> +	}
> +
> +	/* Reset the decoder */
> +	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_RESET, REG1_RESET);
> +	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_RESET, 0);
> +	/* Set general operation mode */
> +	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_MODE_MASK, REG1_MODE_GENERAL);
> +	/* Set rate */
> +	meson_ir_set_mask(ir, IR_DEC_REG0, REG0_RATE_MASK, MESON_TRATE - 1);
> +	/* IRQ on rising and falling edges */
> +	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_IRQSEL_MASK,
> +			  REG1_IRQSEL_RISE_FALL);
> +	/* Enable the decoder */
> +	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_ENABLE, REG1_ENABLE);
> +
> +	dev_info(dev, "receiver initialized\n");
> +
> +	return 0;
> +out_unreg:
> +	rc_unregister_device(ir->rc);
> +out_free:
> +	rc_free_device(ir->rc);
> +
> +	return ret;
> +}
> +
> +static int meson_ir_remove(struct platform_device *pdev)
> +{
> +	struct meson_ir *ir = platform_get_drvdata(pdev);
> +	unsigned long flags;
> +
> +	/* Disable the decoder */
> +	spin_lock_irqsave(&ir->lock, flags);
> +	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_ENABLE, 0);
> +	spin_unlock_irqrestore(&ir->lock, flags);
> +
> +	rc_unregister_device(ir->rc);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id meson_ir_match[] = {
> +	{ .compatible = "amlogic,meson6-ir" },
> +	{ },
> +};
> +
> +static struct platform_driver meson_ir_driver = {
> +	.probe		= meson_ir_probe,
> +	.remove		= meson_ir_remove,
> +	.driver = {
> +		.name		= DRIVER_NAME,
> +		.of_match_table	= meson_ir_match,
> +	},
> +};
> +
> +module_platform_driver(meson_ir_driver);
> +
> +MODULE_DESCRIPTION("Amlogic Meson IR remote receiver driver");
> +MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
> +MODULE_LICENSE("GPL v2");
