Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaJFOaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:30:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56246 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752541AbaJFOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:30:11 -0400
Date: Mon, 6 Oct 2014 16:30:08 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, jonsmirl@gmail.com,
        Simon <longsleep@gmail.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 1/2] pwm: Add Allwinner SoC support
Message-ID: <20141006143008.GC15599@piout.net>
References: <1410983638-24915-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1410983638-24915-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20141006132404.GC26921@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006132404.GC26921@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 at 15:24:05 +0200, Thierry Reding wrote :
> On Wed, Sep 17, 2014 at 09:53:57PM +0200, Alexandre Belloni wrote:
> [...]
> > diff --git a/drivers/pwm/pwm-sunxi.c b/drivers/pwm/pwm-sunxi.c
> > new file mode 100644
> > index 000000000000..643f84ea013e
> > --- /dev/null
> > +++ b/drivers/pwm/pwm-sunxi.c
> > @@ -0,0 +1,371 @@
> > +/*
> > + * Driver for Allwinner Pulse Width Modulation Controller
> > + *
> > + * Copyright (C) 2014 Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> This is somewhat weird. So you are the copyright holder, not your
> employer? The email address is somewhat misleading.
> 

It has been done on my free, unpaid time so yes...

Anyway, even my employer could not actually claim to hold copyright on
what I'm writing as this right is not transferable in France.

> > +#define BIT_CH(bit, chan)	(bit << (chan * PWMCH_OFFSET))
> 
> bit and chan could use additional parentheses here for extra safety.
> 

OK

> > +static const u32 prescaler_table[] = {
> > +	120,
> > +	180,
> > +	240,
> > +	360,
> > +	480,
> > +	0,
> > +	0,
> > +	0,
> > +	12000,
> > +	24000,
> > +	36000,
> > +	48000,
> > +	72000,
> > +	0,
> > +	0,
> > +	0, /* Actually 1 but tested separately */
> > +};
> 
> Did I already mention that this was really weird?
> 

I'm not sure what you want to do here then. This is simply coming from
the datasheet. The last one (0xF) being a bypass is actually only existing on 

> > +static inline u32 sunxi_pwm_readl(struct sunxi_pwm_chip *chip,
> > +				  unsigned long offset)
> > +{
> > +	return readl(chip->base + offset);
> > +}
> > +
> > +
> 
> There's a gratuitous blank line here.
> 
> > +static int sunxi_pwm_probe(struct platform_device *pdev)
> > +{
> [...]
> > +
> > +	ret = pwmchip_add(&pwm->chip);
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "failed to add PWM chip %d\n", ret);
> 
> "chip: %d" to make it clear that it's not some kind of chip ID.
> 
> > +		goto error;
> > +	}
> > +
> > +	ret = clk_prepare_enable(pwm->clk);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "failed to enable PWM clock\n");
> > +		goto error;
> 
> Don't you want to remove the stale PWM chip here? Why not do this at the
> very end, after everything's been set up properly?

Yeah, as this is not critical, I will simply exit without an error in
that case and I'll move that block after platform_set_drvdata().

> 
> > +MODULE_ALIAS("platform:sunxi-pwm");
> > +MODULE_AUTHOR("Alexandre Belloni <alexandre.belloni@free-electrons.com>");
> > +MODULE_DESCRIPTION("Allwinner PWM driver");
> 
> Perhaps "Allwinner sunxi PWM driver"? Presumably Allwinner could at some
> point release a different family of SoCs.
> 

Ok


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
