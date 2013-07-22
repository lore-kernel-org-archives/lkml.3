Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3GVHsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 03:48:33 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40388 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab3GVHsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 03:48:31 -0400
Date: Mon, 22 Jul 2013 08:48:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH 1/3] mfd: add LP3943 MFD driver
Message-ID: <20130722074824.GD4681@laptop>
References: <A874F61F95741C4A9BA573A70FE3998F82E815C3@DQHE06.ent.ti.com>
 <20130717112033.GB3336@laptop>
 <A874F61F95741C4A9BA573A70FE3998F82E83161@DQHE06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E83161@DQHE06.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +int lp3943_read_byte(struct lp3943 *l, u8 reg, u8 *read)
> > 
> > Not sure I like 'l' as a variable name. The function is small enough
> > to get away with it in this context, but it would probably be better
> > if it were renamed to something more meaningful.
> 
> LP3943 consists of two devices - GPIO and PWM drivers.
> So each private data was defined as 
> 
> struct lp3943 *l;			/* MFD device */
> struct lp3943_gpio *lg;		/* GPIO driver */
> struct lp3943_pwm *lp;		/* PWM driver */
> 
> As you pointed, the 'l' may look like a list of something.
> I'll rename them as below.
> 
> struct lp3943 *lp3943;
> struct lp3943_gpio *lp3943_gpio;
> struct lp3943_pwm *lp3943_pwm;

Much better thanks.

> > > +static const struct i2c_device_id lp3943_ids[] = {
> > > +	{"lp3943", 0},
> > 
> > Lack of consistency ...
> 
> I don't know exactly what it means. Do you mean the name of I2C device?

No, I was referencing the spaces (or lack of) on the inside of the
curly brackets.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
