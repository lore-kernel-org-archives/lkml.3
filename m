Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3GAKZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:25:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44065 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3GAKZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:25:26 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-f1-51d159138afc
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        naveenkrishna.ch@gmail.com, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, wsa@the-dreams.de,
        linux-kernel@vger.kernel.org, taeggyun.ko@samsung.com, balbi@ti.com,
        thomas.abraham@linaro.org
Subject: Re: [PATCH v10] i2c: exynos5: add High Speed I2C controller driver
Date: Mon, 01 Jul 2013 12:25:19 +0200
Message-id: <3925484.kHD24rQYyy@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.3 (Linux/3.8.8-gentoo; KDE/4.10.3; x86_64; ; )
In-reply-to: <1371638905-30633-1-git-send-email-ch.naveen@samsung.com>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
 <1371638905-30633-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t/xq7rCkRcDDRpPsFscvF9vcff5YUaL
	A7Mfslq8OrORzaJ3wVU2i02Pr7FadPz9wmhxedccNosZ5/cxWSza9p/Z4sl/IPfYjCWMFitP
	zGJ24PXYOesuu8eda3vYPDYvqfc4P2Mho0ffllWMHj9f6nicPPWExeP4je1MHp83yQVwRnHZ
	pKTmZJalFunbJXBlTNv3l73gTDNTxcmvC1gaGJecYexi5OSQEDCR2NG6hQnCFpO4cG89Wxcj
	F4eQwFJGidYfb5khnC4miW9f1jKDVLEJqEl8bnjEBmKLAHUff3WGHaSIWeAKk0TP4S1gCWEB
	b4mjc76ygtgsAqoSrY2TwVbwCmhK/FpwEizOL6Au8W7bU7C4qICrxPvVh1lAbE4BN4k3/2+x
	Q2xuZJTY3N3BBtEsKPFj8j2wImYBeYl9+6eyQthaEut3HmeawCg4C0nZLCRls5CULWBkXsUo
	mlqaXFCclJ5rqFecmFtcmpeul5yfu4kREmVfdjAuPmZ1iFGAg1GJh3fB9AuBQqyJZcWVuYcY
	JTiYlUR4b3pfDBTiTUmsrEotyo8vKs1JLT7EyMTBKdXA2Jb/S4jvneektX+TRLeEXUpQ3/Ho
	2J19ZlbvW0I9W7Yxf1i32VlXvrvLZHKK7P7MTf8eLj0r8OTz5bXr6spOH5yt0SZ0MTV0aUBE
	9d66Y+nBZ185Pvw0x6XB++nyvqLNxrXqrlt3c0ZFzXxw6qTM77kfP1+8GD95U5j2WyWfylOG
	N3iWKt0vblZiKc5INNRiLipOBACHovMWkAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

Looks mostly good, but see some comments inline.

On Wednesday 19 of June 2013 16:18:25 Naveen Krishna Chatradhi wrote:
> Adds support for High Speed I2C driver found in Exynos5 and
> later SoCs from Samsung.
> 
> Driver only supports Device Tree method.
> 
> Changes since v1:
> 1. Added FIFO functionality
> 2. Added High speed mode functionality
> 3. Remove SMBUS_QUICK
> 4. Remove the debugfs functionality
> 5. Use devm_* functions where ever possible
> 6. Driver is free from GPIO configs
> 7. Use OF data string "clock-frequency" to get the bus operating
> frequencies 8. Split the clock divisor calculation function
> 9. Add resets for the failed transacton cases
> 10. Removed retries as core does retries if -EAGAIN is returned
> 11. Removed mode from device tree info (use speed to distinguish
>     the mode of operation)
> 12. Use wait_for_completion_timeout as the interruptible case is not
> tested well 13. few other bug fixes and cosmetic changes
> 
> Signed-off-by: Taekgyun Ko <taeggyun.ko@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Simon Glass <sjg@google.com>
> Tested-by: Andrew Bresticker <abrestic@google.com>
> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> Signed-off-by: Andrew Bresticker <abrestic@google.com>
> ---
> 
> Changes since v9:
> Fixed below comments given by Wolfram, Thanks for the reivew.
> 1. Removed retries as core does retries if -EAGAIN is returned
> 2. Removed mode from device tree info (use speed to distinguish
>    the mode of operation)
> 3. Use module_platform_driver macro instead of init and exit
> 4. Use wait_for_completion_timeout as the interruptible case is not
> tested well
> 
>  .../devicetree/bindings/i2c/i2c-exynos5.txt        |   44 +
>  drivers/i2c/busses/Kconfig                         |    7 +
>  drivers/i2c/busses/Makefile                        |    1 +
>  drivers/i2c/busses/i2c-exynos5.c                   |  861
> ++++++++++++++++++++ 4 files changed, 913 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
> create mode 100644 drivers/i2c/busses/i2c-exynos5.c
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
> b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt new file mode
> 100644
> index 0000000..805e018
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
> @@ -0,0 +1,44 @@
> +* Samsung's High Speed I2C controller
> +
> +The Samsung's High Speed I2C controller is used to interface with I2C
> devices +at various speeds ranging from 100khz to 3.4Mhz.
> +
> +Required properties:
> +  - compatible: value should be.
> +      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.

IMHO this compatible value is too wide. You might end up with new Exynos 5 
SoC that has a high speed I2C controller as well, but slightly different, 
requiring some extra quirks.  Now exynos5 in compatible would suggest that 
it covers all Exynos 5 SoCs, but such SoC would require new one.

Basically, my suggestion is to use a compatible value with name of first SoC 
in which given IP appeared, as it is already done in most bindings.

> +  - reg: physical base address of the controller and length of memory
> mapped +    region.
> +  - interrupts: interrupt number to the cpu.
> +  - #address-cells: always 1 (for i2c addresses)
> +  - #size-cells: always 0
> +
> +  - Pinctrl:
> +    - pinctrl-0: Pin control group to be used for this controller.
> +    - pinctrl-names: Should contain only one value - "default".
> +
> +Optional properties:
> +  - clock-frequency: Desired operating frequency in Hz of the bus.
> +    -> If not specified, the default value is 100khz in fast-speed mode
> and +       1Mhz in high-speed mode.
> +    -> If specified, The bus operates in high-speed mode only if the
> +       clock-frequency is >= 1Mhz.
> +
> +Example:
> +
> +hsi2c@12ca0000 {
> +	compatible = "samsung,exynos5-hsi2c";
> +	reg = <0x12ca0000 0x100>;
> +	interrupts = <56>;
> +	clock-frequency = <100000>;
> +
> +	pinctrl-0 = <&i2c4_bus>;
> +	pinctrl-names = "default";
> +
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	s2mps11_pmic@66 {
> +		compatible = "samsung,s2mps11-pmic";
> +		reg = <0x66>;
> +	};
> +};
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 96c6d82..fecbe66 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -434,6 +434,13 @@ config I2C_EG20T
>  	  ML7213/ML7223/ML7831 is companion chip for Intel Atom E6xx series.
>  	  ML7213/ML7223/ML7831 is completely compatible for Intel EG20T PCH.
> 
> +config I2C_EXYNOS5
> +	tristate "Exynos5 high-speed I2C driver"
> +	depends on ARCH_EXYNOS5 && OF
> +	help
> +	  Say Y here to include support for high-speed I2C controller in the
> +	  Exynos5 based Samsung SoCs.
> +
>  config I2C_GPIO
>  	tristate "GPIO-based bitbanging I2C"
>  	depends on GPIOLIB
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 385f99d..af6fa37 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -42,6 +42,7 @@ i2c-designware-platform-objs :=
> i2c-designware-platdrv.o obj-$(CONFIG_I2C_DESIGNWARE_PCI)	+=
> i2c-designware-pci.o
>  i2c-designware-pci-objs := i2c-designware-pcidrv.o
>  obj-$(CONFIG_I2C_EG20T)		+= i2c-eg20t.o
> +obj-$(CONFIG_I2C_EXYNOS5)	+= i2c-exynos5.o
>  obj-$(CONFIG_I2C_GPIO)		+= i2c-gpio.o
>  obj-$(CONFIG_I2C_HIGHLANDER)	+= i2c-highlander.o
>  obj-$(CONFIG_I2C_IBM_IIC)	+= i2c-ibm_iic.o
> diff --git a/drivers/i2c/busses/i2c-exynos5.c
> b/drivers/i2c/busses/i2c-exynos5.c new file mode 100644
> index 0000000..696d16f
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-exynos5.c
> @@ -0,0 +1,861 @@
> +/**
> + * i2c-exynos5.c - Samsung Exynos5 I2C Controller Driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/time.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/clk.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_i2c.h>
> +
> +/*
> + * HSI2C controller from Samsung supports 2 modes of operation
> + * 1. Auto mode: Where in master automatically controls the whole
> transaction + * 2. Manual mode: Software controls the transaction by
> issuing commands + *    START, READ, WRITE, STOP, RESTART in
> I2C_MANUAL_CMD register. + *
> + * Operation mode can be selected by setting AUTO_MODE bit in I2C_CONF
> register + *

I think a comment about mode used in this driver would be good.

> + * Special bits are available for both modes of operation to set
> commands + * and for checking transfer status
> + */
> +
> +/* Register Map */
> +#define HSI2C_CTL		0x00
> +#define HSI2C_FIFO_CTL		0x04
> +#define HSI2C_TRAILIG_CTL	0x08
> +#define HSI2C_CLK_CTL		0x0C
> +#define HSI2C_CLK_SLOT		0x10
> +#define HSI2C_INT_ENABLE	0x20
> +#define HSI2C_INT_STATUS	0x24
> +#define HSI2C_ERR_STATUS	0x2C
> +#define HSI2C_FIFO_STATUS	0x30
> +#define HSI2C_TX_DATA		0x34
> +#define HSI2C_RX_DATA		0x38
> +#define HSI2C_CONF		0x40
> +#define HSI2C_AUTO_CONF		0x44
> +#define HSI2C_TIMEOUT		0x48
> +#define HSI2C_MANUAL_CMD	0x4C
> +#define HSI2C_TRANS_STATUS	0x50
> +#define HSI2C_TIMING_HS1	0x54
> +#define HSI2C_TIMING_HS2	0x58
> +#define HSI2C_TIMING_HS3	0x5C
> +#define HSI2C_TIMING_FS1	0x60
> +#define HSI2C_TIMING_FS2	0x64
> +#define HSI2C_TIMING_FS3	0x68
> +#define HSI2C_TIMING_SLA	0x6C
> +#define HSI2C_ADDR		0x70

nit: AFAIK lower case characters are preferred in hexadecimal numbers in 
kernel coding style.

> +/* I2C_CTL Register bits */
> +#define HSI2C_FUNC_MODE_I2C			(1u << 0)
> +#define HSI2C_MASTER				(1u << 3)
> +#define HSI2C_RXCHON				(1u << 6)
> +#define HSI2C_TXCHON				(1u << 7)
> +#define HSI2C_SW_RST				(1u << 31)
> +
> +/* I2C_FIFO_CTL Register bits */
> +#define HSI2C_RXFIFO_EN				(1u << 0)
> +#define HSI2C_TXFIFO_EN				(1u << 1)
> +#define HSI2C_FIFO_MAX				(0x40)

nit: You don't need parentheses in case of simple numbers.

> +#define HSI2C_RXFIFO_TRIGGER_LEVEL(x)		((x) << 4)
> +#define HSI2C_TXFIFO_TRIGGER_LEVEL(x)		((x) << 16)
> +/* I2C_TRAILING_CTL Register bits */
> +#define HSI2C_TRAILING_COUNT			(0xf)
> +
> +/* I2C_INT_EN Register bits */
> +#define HSI2C_INT_TX_ALMOSTEMPTY_EN		(1u << 0)
> +#define HSI2C_INT_RX_ALMOSTFULL_EN		(1u << 1)
> +#define HSI2C_INT_TRAILING_EN			(1u << 6)
> +#define HSI2C_INT_I2C_EN			(1u << 9)
> +
> +/* I2C_INT_STAT Register bits */
> +#define HSI2C_INT_TX_ALMOSTEMPTY		(1u << 0)
> +#define HSI2C_INT_RX_ALMOSTFULL			(1u << 1)
> +#define HSI2C_INT_TX_UNDERRUN			(1u << 2)
> +#define HSI2C_INT_TX_OVERRUN			(1u << 3)
> +#define HSI2C_INT_RX_UNDERRUN			(1u << 4)
> +#define HSI2C_INT_RX_OVERRUN			(1u << 5)
> +#define HSI2C_INT_TRAILING			(1u << 6)
> +#define HSI2C_INT_I2C				(1u << 9)
> +#define HSI2C_RX_INT				(HSI2C_INT_RX_ALMOSTFULL | \
> +						 HSI2C_INT_RX_UNDERRUN | \
> +						 HSI2C_INT_RX_OVERRUN | \
> +						 HSI2C_INT_TRAILING)
> +
> +/* I2C_FIFO_STAT Register bits */
> +#define HSI2C_RX_FIFO_EMPTY			(1u << 24)
> +#define HSI2C_RX_FIFO_FULL			(1u << 23)
> +#define HSI2C_RX_FIFO_LVL(x)			((x >> 16) & 0x7f)
> +#define HSI2C_TX_FIFO_EMPTY			(1u << 8)
> +#define HSI2C_TX_FIFO_FULL			(1u << 7)
> +#define HSI2C_TX_FIFO_LVL(x)			((x >> 0) & 0x7f)
> +#define HSI2C_FIFO_EMPTY			(HSI2C_RX_FIFO_EMPTY |	\
> +						HSI2C_TX_FIFO_EMPTY)
> +
> +/* I2C_CONF Register bits */
> +#define HSI2C_AUTO_MODE				(1u << 31)
> +#define HSI2C_10BIT_ADDR_MODE			(1u << 30)
> +#define HSI2C_HS_MODE				(1u << 29)
> +
> +/* I2C_AUTO_CONF Register bits */
> +#define HSI2C_READ_WRITE			(1u << 16)
> +#define HSI2C_STOP_AFTER_TRANS			(1u << 17)
> +#define HSI2C_MASTER_RUN			(1u << 31)
> +
> +/* I2C_TIMEOUT Register bits */
> +#define HSI2C_TIMEOUT_EN			(1u << 31)
> +
> +/* I2C_TRANS_STATUS register bits */
> +#define HSI2C_MASTER_BUSY			(1u << 17)
> +#define HSI2C_SLAVE_BUSY			(1u << 16)
> +#define HSI2C_TIMEOUT_AUTO			(1u << 4)
> +#define HSI2C_NO_DEV				(1u << 3)
> +#define HSI2C_NO_DEV_ACK			(1u << 2)
> +#define HSI2C_TRANS_ABORT			(1u << 1)
> +#define HSI2C_TRANS_DONE			(1u << 0)
> +
> +/* I2C_ADDR register bits */
> +#define HSI2C_SLV_ADDR_SLV(x)			((x & 0x3ff) << 0)
> +#define HSI2C_SLV_ADDR_MAS(x)			((x & 0x3ff) << 10)
> +#define HSI2C_MASTER_ID(x)			((x & 0xff) << 24)
> +#define MASTER_ID(x)				((x & 0x7) + 0x08)
> +
> +/*
> + * Controller operating frequency, timing values for operation
> + * are calculated against this frequency
> + */
> +#define HSI2C_HS_TX_CLOCK	1000000
> +#define HSI2C_FS_TX_CLOCK	100000
> +#define HSI2C_HIGH_SPD		1
> +#define HSI2C_FAST_SPD		0
> +
> +#define EXYNOS5_I2C_TIMEOUT (msecs_to_jiffies(1000))
> +
> +/* timeout for pm runtime autosuspend */
> +#define EXYNOS5_I2C_PM_TIMEOUT		1000	/* ms */

1 second seems a lot, but I guess such block don't use too much power.

> +struct exynos5_i2c {
> +	struct i2c_adapter	adap;
> +	unsigned int		suspended:1;
> +
> +	struct i2c_msg		*msg;
> +	struct completion	msg_complete;
> +	unsigned int		msg_ptr;
> +	unsigned int		msg_len;
> +
> +	unsigned int		irq;
> +
> +	void __iomem		*regs;
> +	struct clk		*clk;
> +	struct device		*dev;
> +	int			state;
> +
> +	/*
> +	 * Since the TRANS_DONE bit is cleared on read, and we may read it
> +	 * either during an IRQ or after a transaction, keep track of its
> +	 * state here.
> +	 */
> +	int			trans_done;
> +
> +	/* Controller operating frequency */
> +	unsigned int		fs_clock;
> +	unsigned int		hs_clock;
> +
> +	/*
> +	 * HSI2C Controller can operate in
> +	 * 1. High speed upto 3.4Mbps
> +	 * 2. Fast speed upto 1Mbps
> +	 */
> +	int			speed_mode;
> +	int			bus_id;
> +};
> +
> +static const struct of_device_id exynos5_i2c_match[] = {
> +	{ .compatible = "samsung,exynos5-hsi2c" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
> +
> +static void exynos5_i2c_clr_pend_irq(struct exynos5_i2c *i2c)
> +{
> +	writel(readl(i2c->regs + HSI2C_INT_STATUS),
> +				i2c->regs + HSI2C_INT_STATUS);
> +}
> +
> +/*
> + * exynos5_i2c_set_timing: updates the registers with appropriate
> + * timing values calculated
> + *
> + * Returns 0 on success, -EINVAL if the cycle length cannot
> + * be calculated.
> + */
> +static int exynos5_i2c_set_timing(struct exynos5_i2c *i2c, int mode)
> +{
> +	u32 i2c_timing_s1;
> +	u32 i2c_timing_s2;
> +	u32 i2c_timing_s3;
> +	u32 i2c_timing_sla;
> +	unsigned int t_start_su, t_start_hd;
> +	unsigned int t_stop_su;
> +	unsigned int t_data_su, t_data_hd;
> +	unsigned int t_scl_l, t_scl_h;
> +	unsigned int t_sr_release;
> +	unsigned int t_ftl_cycle;
> +	unsigned int clkin = clk_get_rate(i2c->clk);
> +	unsigned int div, utemp0 = 0, utemp1 = 0, clk_cycle;
> +	unsigned int op_clk = (mode == HSI2C_HIGH_SPD) ?
> +				i2c->hs_clock : i2c->fs_clock;
> +
> +	/*
> +	 * FPCLK / FI2C =
> +	 * (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2) + 8 + 2 * FLT_CYCLE
> +	 * utemp0 = (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2)
> +	 * utemp1 = (TSCLK_L + TSCLK_H + 2)
> +	 */
> +	t_ftl_cycle = (readl(i2c->regs + HSI2C_CONF) >> 16) & 0x7;
> +	utemp0 = (clkin / op_clk) - 8 - 2 * t_ftl_cycle;
> +
> +	/* CLK_DIV max is 256 */
> +	for (div = 0; div < 256; div++) {
> +		utemp1 = utemp0 / (div + 1);
> +
> +		/*
> +		 * SCL_L and SCL_H each has max value of 255
> +		 * Hence, For the clk_cycle to the have right value
> +		 * utemp1 has to be less then 512 and more than 4.
> +		 */
> +		if ((utemp1 < 512) && (utemp1 > 4)) {
> +			clk_cycle = utemp1 - 2;
> +			break;
> +		} else if (div == 255) {
> +			dev_warn(i2c->dev, "Failed to calculate divisor");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	t_scl_l = clk_cycle / 2;
> +	t_scl_h = clk_cycle / 2;
> +	t_start_su = t_scl_l;
> +	t_start_hd = t_scl_l;
> +	t_stop_su = t_scl_l;
> +	t_data_su = t_scl_l / 2;
> +	t_data_hd = t_scl_l / 2;
> +	t_sr_release = clk_cycle;
> +
> +	i2c_timing_s1 = t_start_su << 24 | t_start_hd << 16 | t_stop_su << 8;
> +	i2c_timing_s2 = t_data_su << 24 | t_scl_l << 8 | t_scl_h << 0;
> +	i2c_timing_s3 = div << 16 | t_sr_release << 0;
> +	i2c_timing_sla = t_data_hd << 0;
> +
> +	dev_dbg(i2c->dev, "tSTART_SU: %X, tSTART_HD: %X, tSTOP_SU: %X\n",
> +		t_start_su, t_start_hd, t_stop_su);
> +	dev_dbg(i2c->dev, "tDATA_SU: %X, tSCL_L: %X, tSCL_H: %X\n",
> +		t_data_su, t_scl_l, t_scl_h);
> +	dev_dbg(i2c->dev, "nClkDiv: %X, tSR_RELEASE: %X\n",
> +		div, t_sr_release);
> +	dev_dbg(i2c->dev, "tDATA_HD: %X\n", t_data_hd);
> +
> +	if (mode == HSI2C_HIGH_SPD) {
> +		writel(i2c_timing_s1, i2c->regs + HSI2C_TIMING_HS1);
> +		writel(i2c_timing_s2, i2c->regs + HSI2C_TIMING_HS2);
> +		writel(i2c_timing_s3, i2c->regs + HSI2C_TIMING_HS3);
> +	} else {
> +		writel(i2c_timing_s1, i2c->regs + HSI2C_TIMING_FS1);
> +		writel(i2c_timing_s2, i2c->regs + HSI2C_TIMING_FS2);
> +		writel(i2c_timing_s3, i2c->regs + HSI2C_TIMING_FS3);
> +	}
> +	writel(i2c_timing_sla, i2c->regs + HSI2C_TIMING_SLA);
> +
> +	return 0;
> +}
> +
> +static int exynos5_hsi2c_clock_setup(struct exynos5_i2c *i2c)
> +{
> +	/*
> +	 * Configure the Fast speed timing values
> +	 * Even the High Speed mode initially starts with Fast mode
> +	 */
> +	if (exynos5_i2c_set_timing(i2c, HSI2C_FAST_SPD)) {
> +		dev_err(i2c->dev, "HSI2C FS Clock set up failed\n");
> +		return -EINVAL;
> +	}
> +
> +	/* configure the High speed timing values */
> +	if (i2c->speed_mode == HSI2C_HIGH_SPD) {
> +		if (exynos5_i2c_set_timing(i2c, HSI2C_HIGH_SPD)) {
> +			dev_err(i2c->dev, "HSI2C HS Clock set up failed\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * exynos5_i2c_init: configures the controller for I2C functionality
> + * Programs I2C controller for Master mode operation
> + */
> +static void exynos5_i2c_init(struct exynos5_i2c *i2c)
> +{
> +	u32 i2c_conf = readl(i2c->regs + HSI2C_CONF);
> +
> +	writel((HSI2C_FUNC_MODE_I2C | HSI2C_MASTER),
> +					i2c->regs + HSI2C_CTL);
> +	writel(HSI2C_TRAILING_COUNT, i2c->regs + HSI2C_TRAILIG_CTL);
> +
> +	if (i2c->speed_mode == HSI2C_HIGH_SPD) {
> +		writel(HSI2C_MASTER_ID(MASTER_ID(i2c->bus_id)),
> +					i2c->regs + HSI2C_ADDR);
> +		i2c_conf |= HSI2C_HS_MODE;
> +	}
> +
> +	writel(i2c_conf | HSI2C_AUTO_MODE, i2c->regs + HSI2C_CONF);
> +}
> +
> +static void exynos5_i2c_reset(struct exynos5_i2c *i2c)
> +{
> +	u32 i2c_ctl;
> +
> +	/* Set and clear the bit for reset */
> +	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
> +	i2c_ctl |= HSI2C_SW_RST;
> +	writel(i2c_ctl, i2c->regs + HSI2C_CTL);
> +
> +	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
> +	i2c_ctl &= ~HSI2C_SW_RST;
> +	writel(i2c_ctl, i2c->regs + HSI2C_CTL);
> +
> +	/* We don't expect calculations to fail during the run */
> +	exynos5_hsi2c_clock_setup(i2c);
> +	/* Initialize the configure registers */
> +	exynos5_i2c_init(i2c);
> +}
> +
> +/*
> + * exynos5_i2c_irq: top level IRQ servicing routine
> + *
> + * INT_STATUS registers gives the interrupt details. Further,
> + * FIFO_STATUS or TRANS_STATUS registers are to be check for detailed
> + * state of the bus.
> + */
> +static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
> +{
> +	struct exynos5_i2c *i2c = dev_id;
> +	u32 fifo_level, int_status, fifo_status, trans_status;
> +	unsigned char byte;
> +	int len = 0;
> +
> +	i2c->state = -EINVAL;
> +
> +	int_status = readl(i2c->regs + HSI2C_INT_STATUS);
> +	fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
> +
> +	if (int_status & HSI2C_INT_I2C) {
> +		trans_status = readl(i2c->regs + HSI2C_TRANS_STATUS);
> +		if (trans_status & HSI2C_NO_DEV_ACK) {
> +			dev_dbg(i2c->dev, "No ACK from device\n");
> +			i2c->state = -ENXIO;
> +		} else if (trans_status & HSI2C_NO_DEV) {
> +			dev_dbg(i2c->dev, "No device\n");
> +			i2c->state = -ENXIO;
> +		} else if (trans_status & HSI2C_TRANS_ABORT) {
> +			dev_dbg(i2c->dev, "Deal with arbitration lose\n");
> +			i2c->state = -EAGAIN;
> +		} else if (trans_status & HSI2C_TIMEOUT_AUTO) {
> +			dev_dbg(i2c->dev, "Accessing device timed out\n");
> +			i2c->state = -EAGAIN;
> +		} else if (trans_status & HSI2C_TRANS_DONE) {
> +			i2c->trans_done = 1;
> +			i2c->state = 0;
> +		}
> +	}
> +	/* TX_ALMOSTEMPTY can happen along with HSI2C_INT_I2C */

The comment says that both can happen, while your code assumes they are 
exlusive.

> +	else if (int_status &
> +			(HSI2C_INT_TX_UNDERRUN | HSI2C_INT_TX_ALMOSTEMPTY)) {
> +		fifo_level = HSI2C_TX_FIFO_LVL(fifo_status);
> +
> +		/* To support probing the devices for detection */
> +		if (i2c->msg->len == 0) {
> +			i2c->state = -ENXIO;
> +			goto stop;
> +		}
> +
> +		len = HSI2C_FIFO_MAX - fifo_level;
> +		if (len > i2c->msg->len)
> +			len = i2c->msg->len;
> +
> +		i2c->msg_len += len;
> +		while (len > 0) {
> +			byte = i2c->msg->buf[i2c->msg_ptr++];
> +			writel(byte, i2c->regs + HSI2C_TX_DATA);
> +			len--;
> +		}
> +		i2c->state = 0;
> +		goto stop;
> +	}
> +	/* If TX FIFO is full (give chance to clear) */
> +	else if (int_status & HSI2C_INT_TX_OVERRUN)

Is this even possible? The only reason for TX overrun I can see would be 
the driver trying to put data in FIFO when it doesn't have enough space, 
which shouldn't happen.

> +		i2c->state = 0;
> +
> +	if (int_status & (HSI2C_INT_RX_OVERRUN | HSI2C_INT_TRAILING |
> +		HSI2C_INT_RX_UNDERRUN | HSI2C_INT_RX_ALMOSTFULL)) {
> +		fifo_level = HSI2C_RX_FIFO_LVL(fifo_status);
> +
> +		if (fifo_level >= i2c->msg->len)
> +			len = i2c->msg->len;
> +		else
> +			len = fifo_level;
> +
> +		i2c->msg_len += len;
> +		while (len > 0) {
> +			byte = (unsigned char)
> +				readl(i2c->regs + HSI2C_RX_DATA);
> +			i2c->msg->buf[i2c->msg_ptr++] = byte;
> +			len--;
> +		}
> +		i2c->state = 0;
> +	}
> +
> +
> + stop:
> +	if ((i2c->msg_len == i2c->msg->len) || (i2c->state < 0)) {
> +		writel(0, i2c->regs + HSI2C_INT_ENABLE);
> +		complete(&i2c->msg_complete);
> +	}
> +
> +	exynos5_i2c_clr_pend_irq(i2c);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * exynos5_i2c_wait_bus_idle
> + *
> + * Wait for the transaction to complete (indicated by the TRANS_DONE bit
> + * being set), and, if this is the last message in a transfer, wait for
> the + * MASTER_BUSY bit to be cleared.
> + *
> + * Returns -EBUSY if the bus cannot be brought to idle
> + */
> +static int exynos5_i2c_wait_bus_idle(struct exynos5_i2c *i2c, int stop)
> +{
> +	unsigned long stop_time;
> +	u32 trans_status;
> +
> +	/* wait for 100 milli seconds for the bus to be idle */
> +	stop_time = jiffies + msecs_to_jiffies(100) + 1;
> +	do {
> +		trans_status = readl(i2c->regs + HSI2C_TRANS_STATUS);
> +		if (trans_status & HSI2C_TRANS_DONE)
> +			i2c->trans_done = 1;
> +		/*
> +		 * Only wait for MASTER_BUSY to be cleared if this is the last
> +		 * message.
> +		 */
> +		if ((!stop || !(trans_status & HSI2C_MASTER_BUSY)) &&
> +		    i2c->trans_done)
> +			return 0;
> +
> +		usleep_range(50, 200);
> +	} while (time_before(jiffies, stop_time));
> +
> +	return -EBUSY;
> +}
> +
> +/*
> + * exynos5_i2c_message_start: Configures the bus and starts the xfer
> + * i2c: struct exynos5_i2c pointer for the current bus
> + * stop: Enables stop after transfer if set. Set for last transfer of
> + *       in the list of messages.
> + *
> + * Configures the bus for read/write function
> + * Sets chip address to talk to, message length to be sent.
> + * Enables appropriate interrupts and sends start xfer command.
> + */
> +static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
> +{
> +	u32 i2c_ctl;
> +	u32 int_en = HSI2C_INT_I2C_EN;
> +	u32 i2c_auto_conf = 0;
> +	u32 fifo_ctl;
> +	u32 i2c_timeout;
> +
> +	/*
> +	 * When the message length is > FIFO depth, set the FIFO trigger
> +	 * at FIFO_MAX - 4. Just for ease of handling.
> +	 */
> +	unsigned short len = (i2c->msg->len > HSI2C_FIFO_MAX) ?
> +					(HSI2C_FIFO_MAX - 4) : i2c->msg->len;
> +
> +	/* Clear to enable Timeout */
> +	i2c_timeout = readl(i2c->regs + HSI2C_TIMEOUT);
> +	i2c_timeout &= ~HSI2C_TIMEOUT_EN;
> +	writel(i2c_timeout, i2c->regs + HSI2C_TIMEOUT);
> +
> +	fifo_ctl = HSI2C_RXFIFO_EN | HSI2C_TXFIFO_EN;
> +	writel(fifo_ctl, i2c->regs + HSI2C_FIFO_CTL);
> +
> +	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
> +	i2c_ctl &= ~(HSI2C_TXCHON | HSI2C_RXCHON);
> +	if (i2c->msg->flags & I2C_M_RD) {
> +		i2c_ctl |= HSI2C_RXCHON;
> +
> +		i2c_auto_conf |= HSI2C_READ_WRITE;
> +
> +		fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(len);
> +		int_en |= (HSI2C_INT_RX_ALMOSTFULL_EN |
> +			HSI2C_INT_TRAILING_EN);
> +	} else {
> +		i2c_ctl |= HSI2C_TXCHON;
> +
> +		fifo_ctl |= HSI2C_TXFIFO_TRIGGER_LEVEL(len);
> +		int_en |= HSI2C_INT_TX_ALMOSTEMPTY_EN;
> +	}
> +
> +	if (stop == 1)
> +		i2c_auto_conf |= HSI2C_STOP_AFTER_TRANS;
> +
> +	writel(HSI2C_SLV_ADDR_MAS(i2c->msg->addr), i2c->regs + HSI2C_ADDR);
> +
> +	writel(fifo_ctl, i2c->regs + HSI2C_FIFO_CTL);
> +	writel(i2c_ctl, i2c->regs + HSI2C_CTL);
> +
> +	/* In auto mode the length of xfer cannot be 0 */
> +	if (i2c->msg->len == 0)
> +		i2c_auto_conf |= 0x1;
> +	else
> +		i2c_auto_conf |= i2c->msg->len;
> +
> +	writel(i2c_auto_conf, i2c->regs + HSI2C_AUTO_CONF);
> +
> +	/* Start data transfer in Master mode */
> +	i2c_auto_conf = readl(i2c->regs + HSI2C_AUTO_CONF);
> +	i2c_auto_conf |= HSI2C_MASTER_RUN;
> +	writel(i2c_auto_conf, i2c->regs + HSI2C_AUTO_CONF);
> +
> +	writel(int_en, i2c->regs + HSI2C_INT_ENABLE);
> +}
> +
> +static int exynos5_i2c_xfer_msg(struct exynos5_i2c *i2c,
> +			      struct i2c_msg *msgs, int stop)
> +{
> +	unsigned long timeout;
> +	int ret;
> +
> +	i2c->msg = msgs;
> +	i2c->msg_ptr = 0;
> +	i2c->msg_len = 0;
> +	i2c->trans_done = 0;
> +
> +	INIT_COMPLETION(i2c->msg_complete);
> +
> +	exynos5_i2c_message_start(i2c, stop);
> +
> +	timeout = wait_for_completion_timeout
> +		(&i2c->msg_complete, EXYNOS5_I2C_TIMEOUT);
> +	if (timeout == 0) {
> +		exynos5_i2c_reset(i2c);
> +		dev_warn(i2c->dev, "%s timeout\n",
> +			 (msgs->flags & I2C_M_RD) ? "rx" : "tx");
> +		return timeout;
> +	}
> +
> +	ret = i2c->state;
> +
> +	if (ret == -EAGAIN) {
> +		exynos5_i2c_reset(i2c);
> +		return ret;
> +	}
> +
> +	/*
> +	 * If this is the last message to be transfered (stop == 1)
> +	 * Then check if the bus can be brought back to idle.
> +	 *
> +	 * Return -EBUSY if the bus still busy.
> +	 */
> +	if (exynos5_i2c_wait_bus_idle(i2c, stop))
> +		return -EBUSY;
> +
> +	/* Return the state as in interrupt routine */
> +	return ret;
> +}
> +
> +static int exynos5_i2c_xfer(struct i2c_adapter *adap,
> +			struct i2c_msg *msgs, int num)
> +{
> +	struct exynos5_i2c *i2c = (struct exynos5_i2c *)adap->algo_data;
> +	struct i2c_msg *msgs_ptr = msgs;
> +	int i = 0;
> +	int ret = 0, ret_pm;
> +	int stop = 0;
> +
> +	if (i2c->suspended) {
> +		dev_err(i2c->dev, "HS-I2C is not initialzed.\n");
> +		return -EIO;
> +	}
> +
> +	ret_pm = pm_runtime_get_sync(i2c->dev);
> +	if (IS_ERR_VALUE(ret_pm)) {

This looks wrong to me.

#define MAX_ERRNO       4095
#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)

This makes it:

if (unlikely((ret_pm) >= 0xFFFFF001)

which is obviously impossible for a signed value, such as ret_pm, which can 
be at most 0x7FFFFFFF.

Just check for ret_pm < 0 here and in other occurencies of IS_ERR_VALUE() 
in this driver.

> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	clk_prepare_enable(i2c->clk);

Shouldn't this (and any other clock gating/ungating) be inside a runtime PM 
callback? (Also this driver enables runtime PM, but lacks any callbacks. Is 
it really correct?)

> +
> +	for (i = 0; i < num; i++) {
> +		stop = (i == num - 1);
> +
> +		ret = exynos5_i2c_xfer_msg(i2c, msgs_ptr, stop);
> +		msgs_ptr++;
> +
> +		if (ret < 0)
> +			goto out;
> +	}
> +
> +	if (i == num) {
> +		ret = num;
> +	} else {
> +		/* Only one message, cannot access the device */
> +		if (i == 1)
> +			ret = -EREMOTEIO;
> +		else
> +			ret = i;
> +
> +		dev_warn(i2c->dev, "xfer message failed\n");
> +	}
> +
> + out:
> +	clk_disable_unprepare(i2c->clk);
> +	pm_runtime_mark_last_busy(i2c->dev);
> +	pm_runtime_put_autosuspend(i2c->dev);
> +	return ret;
> +}
> +
> +static u32 exynos5_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C | (I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK);
> +}
> +
> +static const struct i2c_algorithm exynos5_i2c_algorithm = {
> +	.master_xfer		= exynos5_i2c_xfer,
> +	.functionality		= exynos5_i2c_func,
> +};
> +
> +static int exynos5_i2c_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct exynos5_i2c *i2c;
> +	struct resource *mem;
> +	unsigned int op_clock;
> +	int ret;
> +
> +	if (!np) {
> +		dev_err(&pdev->dev, "no device node\n");
> +		return -ENOENT;
> +	}
> +
> +	i2c = devm_kzalloc(&pdev->dev, sizeof(struct exynos5_i2c), GFP_KERNEL);
> +	if (!i2c) {
> +		dev_err(&pdev->dev, "no memory for state\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (of_property_read_u32(np, "clock-frequency", &op_clock)) {
> +		i2c->speed_mode = HSI2C_FAST_SPD;
> +		i2c->fs_clock = HSI2C_FS_TX_CLOCK;
> +	}
> +
> +	if (op_clock >= HSI2C_HS_TX_CLOCK) {
> +		i2c->speed_mode = HSI2C_HIGH_SPD;
> +		i2c->fs_clock = HSI2C_FS_TX_CLOCK;
> +		i2c->hs_clock = op_clock;
> +	} else {
> +		i2c->speed_mode = HSI2C_FAST_SPD;
> +		i2c->fs_clock = op_clock;
> +	}
> +
> +	strlcpy(i2c->adap.name, "exynos5-i2c", sizeof(i2c->adap.name));
> +	i2c->adap.owner   = THIS_MODULE;
> +	i2c->adap.algo    = &exynos5_i2c_algorithm;
> +	i2c->adap.retries = 2;
> +
> +	i2c->dev = &pdev->dev;
> +	i2c->clk = devm_clk_get(&pdev->dev, "hsi2c");
> +	if (IS_ERR(i2c->clk)) {
> +		dev_err(&pdev->dev, "cannot get clock\n");
> +		return -ENOENT;
> +	}
> +
> +	clk_prepare_enable(i2c->clk);
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	i2c->regs = devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(i2c->regs)) {
> +		ret = PTR_ERR(i2c->regs);
> +		goto err_clk;
> +	}
> +
> +	i2c->adap.dev.of_node = np;
> +	i2c->adap.algo_data = i2c;
> +	i2c->adap.dev.parent = &pdev->dev;
> +
> +	/* Clear pending interrupts from u-boot or misc causes */
> +	exynos5_i2c_clr_pend_irq(i2c);
> +
> +	init_completion(&i2c->msg_complete);
> +
> +	i2c->irq = ret = irq_of_parse_and_map(np, 0);
> +	if (ret <= 0) {
> +		dev_err(&pdev->dev, "cannot find HS-I2C IRQ\n");
> +		ret = -EINVAL;
> +		goto err_clk;
> +	}

Please use platform_get_irq(pdev, 0) here. Don't waste the effort that is 
put into creating all those resources by of_platform_populate() early in 
boot process.

> +
> +	ret = devm_request_irq(&pdev->dev, i2c->irq, exynos5_i2c_irq,
> +				0, dev_name(&pdev->dev), i2c);
> +
> +	if (ret != 0) {
> +		dev_err(&pdev->dev, "cannot request HS-I2C IRQ %d\n", i2c->irq);
> +		goto err_clk;
> +	}
> +
> +	/*
> +	 * TODO: Use private lock to avoid race conditions as
> +	 * mentioned in pm_runtime.txt
> +	 */
> +	pm_runtime_enable(i2c->dev);
> +	pm_runtime_set_autosuspend_delay(i2c->dev, EXYNOS5_I2C_PM_TIMEOUT);
> +	pm_runtime_use_autosuspend(i2c->dev);
> +
> +	ret = pm_runtime_get_sync(i2c->dev);
> +	if (IS_ERR_VALUE(ret))
> +		goto err_clk;
> +
> +	ret = exynos5_hsi2c_clock_setup(i2c);
> +	if (ret)
> +		goto err_pm;
> +
> +	i2c->bus_id = of_alias_get_id(i2c->adap.dev.of_node, "hsi2c");

AFAIK it's responsibility of i2c core to handle this.

> +
> +	exynos5_i2c_init(i2c);
> +
> +	ret = i2c_add_adapter(&i2c->adap);

You can call i2c_add_numbered_adapter() here to make i2c core assign a 
number to your adapter, either automatically or using device tree alias.

Best regards,
Tomasz

> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add bus to i2c core\n");
> +		goto err_pm;
> +	}
> +
> +	of_i2c_register_devices(&i2c->adap);
> +	platform_set_drvdata(pdev, i2c);
> +
> +	clk_disable_unprepare(i2c->clk);
> +	pm_runtime_mark_last_busy(i2c->dev);
> +	pm_runtime_put_autosuspend(i2c->dev);
> +
> +	return 0;
> +
> + err_pm:
> +	pm_runtime_put(i2c->dev);
> +	pm_runtime_disable(&pdev->dev);
> + err_clk:
> +	clk_disable_unprepare(i2c->clk);
> +	return ret;
> +}
> +
> +static int exynos5_i2c_remove(struct platform_device *pdev)
> +{
> +	struct exynos5_i2c *i2c = platform_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = pm_runtime_get_sync(&pdev->dev);
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	i2c_del_adapter(&i2c->adap);
> +
> +	pm_runtime_put(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
> +
> +	clk_disable_unprepare(i2c->clk);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int exynos5_i2c_suspend_noirq(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct exynos5_i2c *i2c = platform_get_drvdata(pdev);
> +
> +	i2c->suspended = 1;
> +
> +	return 0;
> +}
> +
> +static int exynos5_i2c_resume_noirq(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct exynos5_i2c *i2c = platform_get_drvdata(pdev);
> +	int ret = 0;
> +
> +	clk_prepare_enable(i2c->clk);
> +
> +	ret = exynos5_hsi2c_clock_setup(i2c);
> +	if (ret) {
> +		clk_disable_unprepare(i2c->clk);
> +		return ret;
> +	}
> +
> +	exynos5_i2c_init(i2c);
> +	clk_disable_unprepare(i2c->clk);
> +	i2c->suspended = 0;
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops exynos5_i2c_dev_pm_ops = {
> +	.suspend_noirq = exynos5_i2c_suspend_noirq,
> +	.resume_noirq	= exynos5_i2c_resume_noirq,
> +};
> +
> +#define EXYNOS5_DEV_PM_OPS (&exynos5_i2c_dev_pm_ops)
> +#else
> +#define EXYNOS5_DEV_PM_OPS NULL
> +#endif
> +
> +static struct platform_driver exynos5_i2c_driver = {
> +	.probe		= exynos5_i2c_probe,
> +	.remove		= exynos5_i2c_remove,
> +	.driver		= {
> +		.owner	= THIS_MODULE,
> +		.name	= "exynos5-hsi2c",
> +		.pm	= EXYNOS5_DEV_PM_OPS,
> +		.of_match_table = exynos5_i2c_match,
> +	},
> +};
> +
> +module_platform_driver(exynos5_i2c_driver);
> +
> +MODULE_DESCRIPTION("Exynos5 HS-I2C Bus driver");
> +MODULE_AUTHOR("Naveen Krishna Chatradhi, <ch.naveen@samsung.com>");
> +MODULE_AUTHOR("Taekgyun Ko, <taeggyun.ko@samsung.com>");
> +MODULE_LICENSE("GPL v2");
