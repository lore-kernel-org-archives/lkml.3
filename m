Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3IPJUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:20:08 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55715 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab3IPJUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:20:06 -0400
Date: Mon, 16 Sep 2013 10:19:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH 1/4 v2] mfd: add STw481x driver
Message-ID: <20130916091956.GF3999@lee--X1>
References: <1379094851-26385-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379094851-26385-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Sep 2013, Linus Walleij wrote:

> This adds a driver for the STw481x PMICs found in the Nomadik
> family of platforms. This one uses pure device tree probing.
> Print some of the OTP registers on boot and register a regulator
> MFD child.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Hi Sam/Lee, I'm seeking an ACK for this driver to take it through
> the ARM SoC tree with the enablement patches.

Sorry, not just yet. I need to straighten out one last thing.

> ChangeLog v1->v2:
> - Fix remnant checkpatch errors.
> - #define some more registers to make things clear.
> - Document the power control register access function.
> - Don't free devm_*-allocated devices.
> - Use module_i2c_driver() macro.
> ---
>  drivers/mfd/Kconfig         |  10 ++
>  drivers/mfd/Makefile        |   1 +
>  drivers/mfd/stw481x.c       | 250 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/stw481x.h |  56 ++++++++++
>  4 files changed, 317 insertions(+)
>  create mode 100644 drivers/mfd/stw481x.c
>  create mode 100644 include/linux/mfd/stw481x.h
> 

> +/*
> + * This ID table is completely unused, as this is a pure
> + * device-tree probed driver, but it has to be here due to
> + * the structure of the I2C core.
> + */

>From what I can gather, the code doesn't agree with you.

> +static const struct i2c_device_id dummy_id[] = {
> +	{ "dummy", 0 },
> +	{ }
> +};

Can't you just NULL .id_table?

Here's the code which would use it:
> /* match on an id table if there is one */
> if (driver->id_table)
>         return i2c_match_id(driver->id_table, client) != NULL;

Matching for "dummy" will just waste cycles.

> +static struct i2c_driver stw481x_driver = {
> +	.driver = {
> +		.name	= "stw481x",
> +		.of_match_table = stw481x_match,
> +	},
> +	.probe		= stw481x_probe,
> +	.remove		= stw481x_remove,
> +	.id_table	= dummy_id,
> +};
> +
> +module_i2c_driver(stw481x_driver);
> +
> +MODULE_AUTHOR("Linus Walleij");
> +MODULE_DESCRIPTION("STw481x PMIC driver");
> +MODULE_LICENSE("GPL v2");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
