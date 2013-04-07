Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483Ab3DGWuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 18:50:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55052 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934466Ab3DGWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 18:50:42 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 7 Apr 2013 15:50:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Lars-Peter Clausen <lars@metafoo.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [v5] clk: add si5351 i2c common clock driver
Message-ID: <20130407225046.GA16326@roeck-us.net>
References: <1365139415-17815-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365139415-17815-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 05:23:35AM -0000, Sebastian Hesselbarth wrote:
> This patch adds a common clock driver for Silicon Labs Si5351a/b/c
> i2c programmable clock generators. Currently, the driver supports
> DT kernels only and VXCO feature of si5351b is not implemented. DT
> bindings selectively allow to overwrite stored Si5351 configuration
> which is very helpful for clock generators with empty eeprom
> configuration. Corresponding device tree binding documentation is
> also added.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Tested-by: Daniel Mack <zonque@gmail.com>
>
[ ... ]

> +static inline void _si5351_msynth_set_pll_master(
> +	struct si5351_driver_data *drvdata, unsigned char num, int is_master)
> +{
> +	unsigned long flags;
> +
> +	if (num > 8 ||
> +	    (drvdata->variant == SI5351_VARIANT_A3 && num > 3))
> +		return;
> +
> +	flags = __clk_get_flags(drvdata->msynth[num].hw.clk);
> +	if (is_master)
> +		flags |= CLK_SET_RATE_PARENT;
> +	else
> +		flags &= ~CLK_SET_RATE_PARENT;
> +	__clk_set_flags(drvdata->msynth[num].hw.clk, flags);
> +}
> +
Unless I am missing something, neither __clk_get_flags() nor the new
__clk_set_flags is exported.

Did you try to build and load the driver as module ?

Thanks,
Guenter
