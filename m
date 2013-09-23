Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3IWIFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:05:39 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:46914 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3IWIFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:05:37 -0400
Date: Mon, 23 Sep 2013 09:05:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH v3] mfd: add STw481x driver
Message-ID: <20130923080532.GD2185@lee--X1>
References: <1379879358-7297-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379879358-7297-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This adds a driver for the STw481x PMICs found in the Nomadik
> family of platforms. This one uses pure device tree probing.
> Print some of the OTP registers on boot and register a regulator
> MFD child.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Instead of using "dummy" as the unused device ID, use "stw481x".
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

Nit:

> +static const struct i2c_device_id stw481x_id[] = {
> +	{ "stw481x", 0 },
> +	{ }

Where we have '{ }'.

> +};
> +
> +static const struct of_device_id stw481x_match[] = {
> +	{ .compatible = "st,stw4810", },
> +	{ .compatible = "st,stw4811", },
> +	{},

And just down here the same function is provided with '{},'.

I'm happy to change it myself, rather that asking you to resubmit.

Which to you prefer?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
