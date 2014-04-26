Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaDZJ3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 05:29:55 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:63756 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaDZJ3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 05:29:51 -0400
Message-ID: <535B7C8A.6000003@gmail.com>
Date: Sat, 26 Apr 2014 11:29:46 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        linus.walleij@linaro.org
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] pinctrl: berlin: add the BG2Q pinctrl driver
References: <1398268276-9696-1-git-send-email-antoine.tenart@free-electrons.com> <1398268276-9696-3-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1398268276-9696-3-git-send-email-antoine.tenart@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 05:51 PM, Antoine Ténart wrote:
> Add the pin-controller driver for the Berlin BG2Q SoC, with definition
> of its groups and functions. This uses the core Berlin pinctrl driver.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
[...]
> diff --git a/drivers/pinctrl/berlin/berlin-bg2q.c b/drivers/pinctrl/berlin/berlin-bg2q.c
> new file mode 100644
> index 000000000000..de5a6434be86
> --- /dev/null
> +++ b/drivers/pinctrl/berlin/berlin-bg2q.c
> @@ -0,0 +1,413 @@
> +/*
> + * Marvell Berlin BG2Q pinctrl driver
> + *
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Ténart <antoine.tenart@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +
> +#include "berlin.h"
> +
> +static const struct berlin_desc_group berlin2q_soc_pinctrl_groups[] = {
> +	/* G */
> +	BERLIN_PINCTRL_GROUP("G0", 0x18, 0x3, 0x00,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "nand"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "emmc"),

s/emmc/mmc ?

> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
> +	BERLIN_PINCTRL_GROUP("G1", 0x18, 0x3, 0x03,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "nand"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
> +	BERLIN_PINCTRL_GROUP("G2", 0x18, 0x3, 0x06,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "arc"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "lvds_vsync")),

Shouldn't the above be:

BERLIN_PINCTRL_FUNCTION(0x3, "lvds"))), /* vsync */

> +	BERLIN_PINCTRL_GROUP("G3", 0x18, 0x3, 0x09,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "i2s2"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "lvds_lrid")),

ditto

> +	BERLIN_PINCTRL_GROUP("G4", 0x18, 0x3, 0x0c,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "pll"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "sd0"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "rgmii"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x5, "sata_dbg"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "usb0_dbg"),
> +			BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
> +	BERLIN_PINCTRL_GROUP("G5", 0x18, 0x3, 0x0f,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "sd0"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "rgmii"),
> +			BERLIN_PINCTRL_FUNCTION(0x5, "sata_dbg"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "usb0_dbg"),
> +			BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
> +	BERLIN_PINCTRL_GROUP("G6", 0x18, 0x3, 0x12,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "soc"),

Uhm, any idea what "soc" is for? If not, just leave it.

> +			BERLIN_PINCTRL_FUNCTION(0x1, "tw0"),

s/tw/twsi/ and for the ones below.

> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
> +	BERLIN_PINCTRL_GROUP("G7", 0x18, 0x3, 0x15,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "soc"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "tw1"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "eddc")),
> +	BERLIN_PINCTRL_GROUP("G8", 0x18, 0x3, 0x18,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "spi1"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "gpio")),
> +	BERLIN_PINCTRL_GROUP("G9", 0x18, 0x3, 0x1b,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "spi1"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x5, "sata")),
> +	BERLIN_PINCTRL_GROUP("G10", 0x1c, 0x3, 0x00,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "spi1"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "i2s0"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "pwm"),
> +			BERLIN_PINCTRL_FUNCTION(0x5, "sata")),
> +	BERLIN_PINCTRL_GROUP("G11", 0x1c, 0x3, 0x03,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "soc"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "spi1"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "i2s1"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "pwm"),
> +			BERLIN_PINCTRL_FUNCTION(0x5, "sata")),
> +	BERLIN_PINCTRL_GROUP("G12", 0x1c, 0x3, 0x06,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "agc"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "gpio")),
> +	BERLIN_PINCTRL_GROUP("G13", 0x1c, 0x3, 0x09,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "sts1"),

Any idea what "sts" means, maybe "ts" is for Transport Stream?
No need to change it, I am just curious.

> +			BERLIN_PINCTRL_FUNCTION(0x2, "rgmii"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "usb0_dbg"),
> +			BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
> +	BERLIN_PINCTRL_GROUP("G14", 0x1c, 0x3, 0x0c,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "sts0"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "sts1"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "usb0_dbg"),
> +			BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
> +	BERLIN_PINCTRL_GROUP("G15", 0x1c, 0x3, 0x0f,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "sts0"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "sts1"),
> +			BERLIN_PINCTRL_FUNCTION(0x5, "vdac"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "usb0_dbg"),
> +			BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
> +	BERLIN_PINCTRL_GROUP("G16", 0x1c, 0x3, 0x12,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "sts0"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "sts1"),
> +			BERLIN_PINCTRL_FUNCTION(0x5, "osco"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "usb0_dbg"),
> +			BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
> +	BERLIN_PINCTRL_GROUP("G17", 0x1c, 0x3, 0x15,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "rgmii"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "spdif"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "sts1"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "usb0_dbg"),
> +			BERLIN_PINCTRL_FUNCTION(0x7, "usb1_dbg")),
> +	BERLIN_PINCTRL_GROUP("G18", 0x1c, 0x3, 0x18,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "rgmii"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "i2s2"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "sts1")),
> +	BERLIN_PINCTRL_GROUP("G19", 0x1c, 0x3, 0x1b,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "rgmii"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "i2s3"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "sts1"),
> +			BERLIN_PINCTRL_FUNCTION(0x5, "osco")),
> +	BERLIN_PINCTRL_GROUP("G20", 0x20, 0x3, 0x00,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "demod"),
> +			/*
> +			 * Mode 0x4 mux usb2_dbg *and* usb3_dbg:
> +			 * add two functions so it can be used with other groups
> +			 * within the same subnode in the device tree
> +			 */
> +			BERLIN_PINCTRL_FUNCTION(0x4, "usb2_dbg"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "usb3_dbg")),

Nice, and I like the comment :)

> +	BERLIN_PINCTRL_GROUP("G21", 0x20, 0x3, 0x03,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "sts2"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "demod")),
> +	BERLIN_PINCTRL_GROUP("G22", 0x20, 0x3, 0x06,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
> +	BERLIN_PINCTRL_GROUP("G23", 0x20, 0x3, 0x09,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "avif"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "usb2_dbg")),
> +	BERLIN_PINCTRL_GROUP("G24", 0x20, 0x3, 0x0c,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "demod"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "usb2_dbg")),
> +	BERLIN_PINCTRL_GROUP("G25", 0x20, 0x3, 0x0f,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "vga"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "avif"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "usb2_dbg")),
> +	BERLIN_PINCTRL_GROUP("G26", 0x20, 0x3, 0x12,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "lvds"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
> +	BERLIN_PINCTRL_GROUP("G27", 0x20, 0x3, 0x15,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "agc"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
> +	BERLIN_PINCTRL_GROUP("G28", 0x20, 0x3, 0x18,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "avif"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "usb2_dbg")),
> +	BERLIN_PINCTRL_GROUP("G29", 0x20, 0x3, 0x1b,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "scrd0"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
> +	BERLIN_PINCTRL_GROUP("G30", 0x24, 0x3, 0x00,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "scrd1"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
> +	BERLIN_PINCTRL_GROUP("G31", 0x24, 0x3, 0x03,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "sd1"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
> +	BERLIN_PINCTRL_GROUP("G32", 0x24, 0x3, 0x06,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "cam"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "sd1"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
> +	/* GAV */
> +	BERLIN_PINCTRL_GROUP("GAV0", 0x24, 0x3, 0x09,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "dvio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "lvds")),
> +	BERLIN_PINCTRL_GROUP("GAV1", 0x24, 0x3, 0x0c,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "dvio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "vga")),
> +	BERLIN_PINCTRL_GROUP("GAV2", 0x24, 0x3, 0x0f,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "dvio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "i2s3"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "pdm"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "adac")),
> +	BERLIN_PINCTRL_GROUP("GAV3", 0x24, 0x3, 0x12,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "dvio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "i2s3"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "adac")),
> +	BERLIN_PINCTRL_GROUP("GAV4", 0x24, 0x3, 0x15,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "dvio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "i2s1"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "adac")),
> +	BERLIN_PINCTRL_GROUP("GAV5", 0x24, 0x3, 0x18,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "dvio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "spdif")),
> +	BERLIN_PINCTRL_GROUP("GAV6", 0x24, 0x3, 0x1b,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "dvio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "i2s2")),
> +	BERLIN_PINCTRL_GROUP("GAV7", 0x28, 0x3, 0x00,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "dvio"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "i2s3")),
> +	BERLIN_PINCTRL_GROUP("GAV8", 0x28, 0x3, 0x03,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "dv0"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "pwm")),
> +	BERLIN_PINCTRL_GROUP("GAV9", 0x28, 0x3, 0x06,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "dv0"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "pwm")),
> +	BERLIN_PINCTRL_GROUP("GAV10", 0x28, 0x3, 0x09,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "dv0"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "agc")),
> +	BERLIN_PINCTRL_GROUP("GAV11", 0x28, 0x3, 0x0c,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "dv0"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "fp"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "i2s0"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "avio_pwm"),

Is it the same "pwm" as for GAV8? If so, remove the "avio_"
prefix?

> +			BERLIN_PINCTRL_FUNCTION(0x5, "vclki")),
> +	BERLIN_PINCTRL_GROUP("GAV12", 0x28, 0x3, 0x0f,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "i2s2"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "i2s1")),
> +	BERLIN_PINCTRL_GROUP("GAV13", 0x28, 0x3, 0x12,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "i2s2")),
> +	BERLIN_PINCTRL_GROUP("GAV14", 0x28, 0x3, 0x15,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "i2s2"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "i2s1")),
> +	BERLIN_PINCTRL_GROUP("GAV15", 0x28, 0x3, 0x18,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "i2s1"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "dac_dbg")),
> +	BERLIN_PINCTRL_GROUP("GAV16", 0x28, 0x3, 0x1b,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "i2s0"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "i2s1"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "i2s3"),
> +			BERLIN_PINCTRL_FUNCTION(0x5, "pdm"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "dac_dbg")),
> +	BERLIN_PINCTRL_GROUP("GAV17", 0x2c, 0x3, 0x00,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "i2s0"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "i2s1"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "pwm"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "i2s3"),
> +			BERLIN_PINCTRL_FUNCTION(0x5, "pdm"),
> +			BERLIN_PINCTRL_FUNCTION(0x6, "dac_dbg")),
> +	BERLIN_PINCTRL_GROUP("GAV18", 0x2c, 0x3, 0x03,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "spdif"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "arc")),
> +	BERLIN_PINCTRL_GROUP("GAV19", 0x2c, 0x3, 0x06,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "avio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "spdif"),
> +			BERLIN_PINCTRL_FUNCTION(0x4, "i2s3"),
> +			BERLIN_PINCTRL_FUNCTION(0x5, "pdm")),
> +};
> +
> +static const struct berlin_desc_group berlin2q_sysmgr_pinctrl_groups[] = {
> +	/* GSM */
> +	BERLIN_PINCTRL_GROUP("GSM0", 0x40, 0x2, 0x00,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "spi2"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "eth1")),
> +	BERLIN_PINCTRL_GROUP("GSM1", 0x40, 0x2, 0x02,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "spi2"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "eth1")),
> +	BERLIN_PINCTRL_GROUP("GSM2", 0x40, 0x2, 0x04,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "spi2"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "eddc")),
> +	BERLIN_PINCTRL_GROUP("GSM3", 0x40, 0x2, 0x06,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "spi2"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "eddc")),
> +	BERLIN_PINCTRL_GROUP("GSM4", 0x40, 0x1, 0x08,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "hdmi")),
> +	BERLIN_PINCTRL_GROUP("GSM5", 0x40, 0x1, 0x09,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "hdmi")),
> +	BERLIN_PINCTRL_GROUP("GSM6", 0x40, 0x1, 0x0a,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "hdmi")),
> +	BERLIN_PINCTRL_GROUP("GSM7", 0x40, 0x1, 0x0b,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "hdmi")),
> +	BERLIN_PINCTRL_GROUP("GSM8", 0x40, 0x1, 0x0c,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "hdmi")),
> +	BERLIN_PINCTRL_GROUP("GSM9", 0x40, 0x1, 0x0d,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "hdmi")),
> +	BERLIN_PINCTRL_GROUP("GSM10", 0x40, 0x1, 0x0e,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "led")),
> +	BERLIN_PINCTRL_GROUP("GSM11", 0x40, 0x1, 0x0f,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "led")),
> +	BERLIN_PINCTRL_GROUP("GSM12", 0x40, 0x2, 0x10,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "uart0"), /* RX/TX */
> +			BERLIN_PINCTRL_FUNCTION(0x1, "irda0"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
> +	BERLIN_PINCTRL_GROUP("GSM13", 0x40, 0x2, 0x12,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "uart0"), /* CTS/RDS */

s/RDS/RTS/

> +			BERLIN_PINCTRL_FUNCTION(0x2, "uart1"), /* RX/TX */
> +			BERLIN_PINCTRL_FUNCTION(0x3, "tw2")),
> +	BERLIN_PINCTRL_GROUP("GSM14", 0x40, 0x2, 0x14,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "uart1"), /* RX/TX */
> +			BERLIN_PINCTRL_FUNCTION(0x2, "irda1"),
> +			BERLIN_PINCTRL_FUNCTION(0x3, "tw3")),

s/tw/twsi/

Sebastian

> +	BERLIN_PINCTRL_GROUP("GSM15", 0x40, 0x2, 0x16,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "pwr"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "led"),
> +			BERLIN_PINCTRL_FUNCTION(0x2, "gpio")),
> +	BERLIN_PINCTRL_GROUP("GSM16", 0x40, 0x1, 0x18,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "eddc")),
> +	BERLIN_PINCTRL_GROUP("GSM17", 0x40, 0x1, 0x19,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "eddc")),
> +	BERLIN_PINCTRL_GROUP("GSM18", 0x40, 0x1, 0x1a,
> +			BERLIN_PINCTRL_FUNCTION(0x0, "gpio"),
> +			BERLIN_PINCTRL_FUNCTION(0x1, "eddc")),
> +};
> +
> +static const struct berlin_pinctrl_desc berlin2q_soc_pinctrl_data = {
> +	.groups = berlin2q_soc_pinctrl_groups,
> +	.ngroups = ARRAY_SIZE(berlin2q_soc_pinctrl_groups),
> +};
> +
> +static const struct berlin_pinctrl_desc berlin2q_sysmgr_pinctrl_data = {
> +	.groups = berlin2q_sysmgr_pinctrl_groups,
> +	.ngroups = ARRAY_SIZE(berlin2q_sysmgr_pinctrl_groups),
> +};
> +
> +static const struct of_device_id berlin2q_pinctrl_match[] = {
> +	{
> +		.compatible = "marvell,berlin2q-soc-pinctrl",
> +		.data = &berlin2q_soc_pinctrl_data,
> +	},
> +	{
> +		.compatible = "marvell,berlin2q-sysmgr-pinctrl",
> +		.data = &berlin2q_sysmgr_pinctrl_data,
> +	},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, berlin2q_pinctrl_match);
> +
> +static int berlin2q_pinctrl_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id
> +		*device = of_match_device(berlin2q_pinctrl_match, &pdev->dev);
> +
> +	return berlin_pinctrl_probe(pdev, device->data);
> +}
> +
> +static struct platform_driver berlin2q_pinctrl_driver = {
> +	.probe	= berlin2q_pinctrl_probe,
> +	.driver	= {
> +		.name = "berlin-bg2q-pinctrl",
> +		.owner = THIS_MODULE,
> +		.of_match_table = berlin2q_pinctrl_match,
> +	},
> +};
> +module_platform_driver(berlin2q_pinctrl_driver);
> +
> +MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
> +MODULE_DESCRIPTION("Marvell Berlin BG2Q pinctrl driver");
> +MODULE_LICENSE("GPL");
> 

