Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3EYLJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 07:09:40 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57486 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3EYLJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 07:09:37 -0400
From: Daniel Tang <dt.tangr@gmail.com>
To: linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>
Cc: Daniel Tang <dt.tangr@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [RFC PATCHv4 5/6] input: TI-Nspire keypad support
Date: Sat, 25 May 2013 21:08:06 +1000
Message-Id: <1369480087-24786-6-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the built-in keypad on TI-Nspires.

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 .../devicetree/bindings/input/ti,nspire-keypad.txt |  60 ++++
 drivers/input/keyboard/Kconfig                     |  10 +
 drivers/input/keyboard/Makefile                    |   1 +
 drivers/input/keyboard/nspire-keypad.c             | 315 +++++++++++++++++++++
 4 files changed, 386 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/ti,nspire-keypad.txt
 create mode 100644 drivers/input/keyboard/nspire-keypad.c

diff --git a/Documentation/devicetree/bindings/input/ti,nspire-keypad.txt b/Documentation/devicetree/bindings/input/ti,nspire-keypad.txt
new file mode 100644
index 0000000..f5b91c6b
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/ti,nspire-keypad.txt
@@ -0,0 +1,60 @@
+TI-NSPIRE Keypad
+
+Required properties:
+- compatible: Compatible property value should be "ti,nspire-keypad".
+
+- reg: Physical base address of the peripheral and length of memory mapped
+  region.
+
+- interrupts: The interrupt number for the peripheral.
+
+- scan-interval: How often to scan in us. Based on a APB speed of 33MHz, the
+	maximum delay time is ...us
+
+- row-delay: How long to wait before scanning each row.
+
+- clocks: The clock this peripheral is attached to.
+
+- keymap: The keymap to use
+	(see Documentation/devicetree/bindings/input/matrix-keymap.txt)
+
+Optional properties:
+- active-low: Specify that the keypad is active low (i.e. logical low signifies
+	a key press).
+
+Example:
+
+input {
+	compatible = "ti,nspire-keypad";
+	reg = <0x900E0000 0x1000>;
+	interrupts = <16>;
+
+	scan-interval = <1000>;
+	row-delay = <200>;
+
+	clocks = <&apb_pclk>;
+
+	keymap = <
+	0x0000001c 	0x0001001c 	0x00040039
+	0x0005002c 	0x00060015 	0x0007000b
+	0x0008000f 	0x0100002d 	0x01010011
+	0x0102002f 	0x01030004 	0x01040016
+	0x01050014 	0x0106001f 	0x01070002
+	0x010a006a 	0x02000013 	0x02010010
+	0x02020019 	0x02030007 	0x02040018
+	0x02050031 	0x02060032 	0x02070005
+	0x02080028 	0x0209006c 	0x03000026
+	0x03010025 	0x03020024 	0x0303000a
+	0x03040017 	0x03050023 	0x03060022
+	0x03070008 	0x03080035 	0x03090069
+	0x04000021 	0x04010012 	0x04020020
+	0x0404002e 	0x04050030 	0x0406001e
+	0x0407000d 	0x04080037 	0x04090067
+	0x05010038 	0x0502000c 	0x0503001b
+	0x05040034 	0x0505001a 	0x05060006
+	0x05080027 	0x0509000e 	0x050a006f
+	0x0600002b 	0x0602004e 	0x06030068
+	0x06040003 	0x0605006d 	0x06060009
+	0x06070001 	0x0609000f 	0x0708002a
+	0x0709001d 	0x070a0033 	>;
+};
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 62a2c0e..bdbda87 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -418,6 +418,16 @@ config KEYBOARD_NOMADIK
 	  To compile this driver as a module, choose M here: the
 	  module will be called nmk-ske-keypad.

+config KEYBOARD_NSPIRE
+	tristate "TI-NSPIRE builtin keyboard"
+	depends on ARCH_NSPIRE
+	select INPUT_MATRIXKMAP
+	help
+	  Say Y here if you want to use the builtin keypad on the TI-NSPIRE.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called nspire-keypad.
+
 config KEYBOARD_TEGRA
 	tristate "NVIDIA Tegra internal matrix keyboard controller support"
 	depends on ARCH_TEGRA && OF
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 0c43e8c..a699b61 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_KEYBOARD_MCS)		+= mcs_touchkey.o
 obj-$(CONFIG_KEYBOARD_MPR121)		+= mpr121_touchkey.o
 obj-$(CONFIG_KEYBOARD_NEWTON)		+= newtonkbd.o
 obj-$(CONFIG_KEYBOARD_NOMADIK)		+= nomadik-ske-keypad.o
+obj-$(CONFIG_KEYBOARD_NSPIRE)		+= nspire-keypad.o
 obj-$(CONFIG_KEYBOARD_OMAP)		+= omap-keypad.o
 obj-$(CONFIG_KEYBOARD_OMAP4)		+= omap4-keypad.o
 obj-$(CONFIG_KEYBOARD_OPENCORES)	+= opencores-kbd.o
diff --git a/drivers/input/keyboard/nspire-keypad.c b/drivers/input/keyboard/nspire-keypad.c
new file mode 100644
index 0000000..b922390
--- /dev/null
+++ b/drivers/input/keyboard/nspire-keypad.c
@@ -0,0 +1,315 @@
+/*
+ *  linux/drivers/input/keyboard/nspire-keypad.c
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/input/matrix_keypad.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/of.h>
+
+#define KEYPAD_SCAN_MODE	0x00
+#define KEYPAD_CNTL		0x04
+#define KEYPAD_INT		0x08
+#define KEYPAD_INTMSK		0x0C
+
+#define KEYPAD_DATA		0x10
+#define KEYPAD_GPIO		0x30
+
+#define KEYPAD_UNKNOWN_INT	0x40
+#define KEYPAD_UNKNOWN_INT_STS	0x44
+
+#define KEYPAD_BITMASK_COLS	11
+#define KEYPAD_BITMASK_ROWS	8
+
+struct nspire_keypad {
+	spinlock_t lock;
+
+	void __iomem *reg_base;
+	int irq;
+	u32 int_mask;
+
+	struct input_dev *input;
+	struct clk *clk;
+
+	struct matrix_keymap_data *keymap;
+	int row_shift;
+
+	/* Maximum delay estimated assuming 33MHz APB */
+	u32 scan_interval;	/* In microseconds (~2000us max) */
+	u32 row_delay;		/* In microseconds (~500us max) */
+
+	bool active_low;
+};
+
+static inline void nspire_report_state(struct nspire_keypad *keypad,
+		int row, int col, unsigned int state)
+{
+	int code = MATRIX_SCAN_CODE(row, col, keypad->row_shift);
+	unsigned short *keymap = keypad->input->keycode;
+
+	state = keypad->active_low ? !state : !!state;
+	input_report_key(keypad->input, keymap[code], state);
+}
+
+static irqreturn_t nspire_keypad_irq(int irq, void *dev_id)
+{
+	struct nspire_keypad *keypad = dev_id;
+	u32 int_sts;
+	u16 state[8];
+	int row, col;
+
+	int_sts = readl(keypad->reg_base + KEYPAD_INT) & keypad->int_mask;
+
+	if (!int_sts)
+		return IRQ_NONE;
+
+	spin_lock(&keypad->lock);
+
+	memcpy_fromio(state, keypad->reg_base + KEYPAD_DATA, sizeof(state));
+
+	for (row = 0; row < KEYPAD_BITMASK_ROWS; row++) {
+		u16 bits = state[row];
+		for (col = 0; col < KEYPAD_BITMASK_COLS; col++)
+			nspire_report_state(keypad, row, col, bits & (1<<col));
+	}
+	input_sync(keypad->input);
+	writel(0x3, keypad->reg_base + KEYPAD_INT);
+
+	spin_unlock(&keypad->lock);
+
+	return IRQ_HANDLED;
+}
+
+static int nspire_keypad_chip_init(struct nspire_keypad *keypad)
+{
+	unsigned long val = 0, cycles_per_us, delay_cycles, row_delay_cycles;
+
+	cycles_per_us = (clk_get_rate(keypad->clk) / 1000000);
+	if (cycles_per_us == 0)
+		cycles_per_us = 1;
+
+	delay_cycles = cycles_per_us * keypad->scan_interval;
+	WARN_ON(delay_cycles >= (1<<16)); /* Overflow */
+	delay_cycles &= 0xffff;
+
+	row_delay_cycles = cycles_per_us * keypad->row_delay;
+	WARN_ON(row_delay_cycles >= (1<<14)); /* Overflow */
+	row_delay_cycles &= 0x3fff;
+
+
+	val |= (3<<0); /* Set scan mode to 3 (continuous scan) */
+	val |= (row_delay_cycles<<2); /* Delay between scanning each row */
+	val |= (delay_cycles<<16); /* Delay between scans */
+	writel(val, keypad->reg_base + KEYPAD_SCAN_MODE);
+
+	val = (KEYPAD_BITMASK_ROWS & 0xff) | (KEYPAD_BITMASK_COLS & 0xff)<<8;
+	writel(val, keypad->reg_base + KEYPAD_CNTL);
+
+	/* Enable interrupts */
+	keypad->int_mask = (1<<1);
+	writel(keypad->int_mask, keypad->reg_base + 0xc);
+
+	/* Disable GPIO interrupts to prevent hanging on touchpad */
+	/* Possibly used to detect touchpad events */
+	writel(0, keypad->reg_base + KEYPAD_UNKNOWN_INT);
+	/* Acknowledge existing interrupts */
+	writel(~0, keypad->reg_base + KEYPAD_UNKNOWN_INT_STS);
+
+	return 0;
+}
+
+static int nspire_keypad_probe(struct platform_device *pdev)
+{
+	const struct device_node *of_node = pdev->dev.of_node;
+	struct nspire_keypad *keypad;
+	struct input_dev *input;
+	struct resource *res;
+	struct clk *clk;
+	int irq, error;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "failed to get keypad irq\n");
+		return -EINVAL;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "missing platform resources\n");
+		return -EINVAL;
+	}
+
+	clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "unable to get clock\n");
+		return -EINVAL;
+	}
+
+	clk_prepare(clk);
+	error = clk_enable(clk);
+	if (error)
+		goto err_put_clk;
+
+	keypad = kzalloc(sizeof(struct nspire_keypad), GFP_KERNEL);
+	input = input_allocate_device();
+	if (!keypad || !input) {
+		dev_err(&pdev->dev, "failed to allocate keypad memory\n");
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	error = of_property_read_u32(of_node, "scan-interval",
+			&keypad->scan_interval);
+	if (error) {
+		dev_err(&pdev->dev, "failed to get scan-interval\n");
+		goto err_free_mem;
+	}
+
+	error = of_property_read_u32(of_node, "row-delay",
+			&keypad->row_delay);
+	if (error) {
+		dev_err(&pdev->dev, "failed to get row-delay\n");
+		goto err_free_mem;
+	}
+
+	keypad->active_low = of_property_read_bool(of_node,
+			"active-low");
+
+	keypad->keymap = NULL;
+
+	keypad->row_shift = get_count_order(KEYPAD_BITMASK_COLS);
+	keypad->irq = irq;
+	keypad->clk = clk;
+	keypad->input = input;
+	spin_lock_init(&keypad->lock);
+
+	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
+		dev_err(&pdev->dev, "failed to request I/O memory\n");
+		error = -EBUSY;
+		goto err_free_mem;
+	}
+
+	keypad->reg_base = ioremap(res->start, resource_size(res));
+	if (!keypad->reg_base) {
+		dev_err(&pdev->dev, "failed to remap I/O memory\n");
+		error = -ENXIO;
+		goto err_free_mem_region;
+	}
+
+	input->id.bustype = BUS_HOST;
+	input->name = "nspire-keypad";
+	input->dev.parent = &pdev->dev;
+
+	set_bit(EV_KEY, input->evbit);
+	set_bit(EV_REP, input->evbit);
+
+	error = matrix_keypad_build_keymap(keypad->keymap, "keymap",
+			KEYPAD_BITMASK_ROWS, KEYPAD_BITMASK_COLS, NULL, input);
+	if (error) {
+		dev_err(&pdev->dev, "building keymap failed\n");
+		goto err_iounmap;
+	}
+
+	error = nspire_keypad_chip_init(keypad);
+	if (error) {
+		dev_err(&pdev->dev, "unable to init keypad hardware\n");
+		goto err_iounmap;
+	}
+
+	error = request_irq(keypad->irq, nspire_keypad_irq, 0,
+			"nspire_keypad", keypad);
+	if (error) {
+		dev_err(&pdev->dev, "allocate irq %d failed\n", keypad->irq);
+		goto err_iounmap;
+	}
+
+	error = input_register_device(input);
+	if (error) {
+		dev_err(&pdev->dev,
+				"unable to register input device: %d\n", error);
+		goto err_free_irq;
+	}
+
+	platform_set_drvdata(pdev, keypad);
+
+	dev_info(&pdev->dev, "TI-NSPIRE keypad at %#08x ("
+			"scan_interval=%uus,row_delay=%uus"
+			"%s)\n", res->start,
+			keypad->row_delay,
+			keypad->scan_interval,
+			keypad->active_low ? ",active_low" : "");
+
+	return 0;
+
+err_free_irq:
+	free_irq(keypad->irq, keypad);
+err_iounmap:
+	iounmap(keypad->reg_base);
+err_free_mem_region:
+	release_mem_region(res->start, resource_size(res));
+err_free_mem:
+	input_free_device(input);
+	kfree(keypad);
+
+	clk_disable(clk);
+err_put_clk:
+	clk_unprepare(clk);
+	clk_put(clk);
+	return error;
+}
+
+static int nspire_keypad_remove(struct platform_device *pdev)
+{
+	struct nspire_keypad *keypad = platform_get_drvdata(pdev);
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	free_irq(keypad->irq, keypad);
+
+	input_unregister_device(keypad->input);
+
+	iounmap(keypad->reg_base);
+	release_mem_region(res->start, resource_size(res));
+	kfree(keypad);
+
+	clk_disable(keypad->clk);
+	clk_unprepare(keypad->clk);
+	clk_put(keypad->clk);
+
+	return 0;
+}
+#ifdef CONFIG_OF
+static const struct of_device_id nspire_keypad_dt_match[] = {
+	{ .compatible = "ti,nspire-keypad" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, nspire_keypad_dt_match);
+#endif
+
+static struct platform_driver nspire_keypad_driver = {
+	.driver = {
+		.name = "nspire-keypad",
+		.owner  = THIS_MODULE,
+		.of_match_table = of_match_ptr(nspire_keypad_dt_match),
+	},
+	.remove = nspire_keypad_remove,
+	.probe = nspire_keypad_probe,
+};
+
+module_platform_driver(nspire_keypad_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("TI-NSPIRE Keypad Driver");
--
1.8.1.3

