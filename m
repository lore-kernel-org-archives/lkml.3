Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaBRIVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 03:21:35 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:44000 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaBRIVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 03:21:33 -0500
Date: Tue, 18 Feb 2014 08:21:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Milo Kim <milo.kim@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 01/10] mfd: Add TI LMU driver
Message-ID: <20140218082127.GD20218@lee--X1>
References: <1392359450-6890-1-git-send-email-milo.kim@ti.com>
 <20140217095734.GD17875@lee--X1>
 <53030F9C.8000605@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53030F9C.8000605@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>+static const struct resource lm3633_effect_resources[] = {
> >>+	{
> >>+		.name  = LM3633_EFFECT_BL0_RAMPUP,
> >>+		.flags = IORESOURCE_REG,
> >>+		.start = LM3633_EFFECT_REGISTER(BL0_RAMPUP),
> >>+	},

<snip>

> >>+	{
> >>+		.name  = LM3633_EFFECT_PTN_HIGHBRT,
> >>+		.flags = IORESOURCE_REG,
> >>+		.start = LM3633_EFFECT_REGISTER(HIGHBRT),
> >>+	},
> >>+};
> >
> >Can you define a MACRO to do all of these as one liners?
> 
> Yes, resource definitions will be replaced by simple macro,
> LMU_EFFECT_RESOURCE().
> 
> For example,
> 
> #define LMU_EFFECT_RESOURCE(chip, effect)               \
> {                                                       \
>         .name  = chip##_EFFECT_##effect,                \
>         .flags = IORESOURCE_REG,                        \
>         .start = LMU_EFFECT_REGISTER(chip, effect),     \
> }
> 
> static const struct resource lm3633_effect_resources[] = {
>         LMU_EFFECT_RESOURCE(LM3633, BL0_RAMPUP),

<snip>

>         LMU_EFFECT_RESOURCE(LM3633, PTN_HIGHBRT),
> };
> 
> and so on.

Yes, this is what I had in mind.

> >>+	pdata->en_gpio = of_get_named_gpio(node, "ti,enable-gpio", 0);
> >
> >There is a global DT property for this already.
> 
> I've not found it yet, but I agree it looks like general property.
> So I'll replace "ti,enable-gpio" with "ti,lmu-en-gpio".

Just re-use "gpio-enable". No need for it to be vendor specific.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
