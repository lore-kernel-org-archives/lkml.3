Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3HVOTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:19:09 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62195 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab3HVOTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:19:07 -0400
Date: Thu, 22 Aug 2013 15:19:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 09/33] ARM: ux500: Supply the I2C clocks lookup to the
 DBX500 DT
Message-ID: <20130822141900.GB17154@lee--X1>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-10-git-send-email-lee.jones@linaro.org>
 <CACRpkdbE86HgPr+7LZD9BFU_OsDFFFWTaFHW_i2fNXivKZ-3Dw@mail.gmail.com>
 <20130820093034.GL31036@pengutronix.de>
 <20130822133730.GB23152@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130822133730.GB23152@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Mark Rutland wrote:

> On Tue, Aug 20, 2013 at 10:30:34AM +0100, Sascha Hauer wrote:
> > On Tue, Aug 20, 2013 at 11:11:19AM +0200, Linus Walleij wrote:
> > > On Thu, Jun 6, 2013 at 2:16 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > > 
> > > > +++ b/arch/arm/boot/dts/dbx5x0.dtsi
> > > > @@ -572,6 +572,8 @@
> > > >                         v-i2c-supply = <&db8500_vape_reg>;
> > > >
> > > >                         clock-frequency = <400000>;
> > > > +                       clocks = <&prcc_kclk 3 3>, <&prcc_pclk 3 3>;
> > > > +                       clock-names = "nmk-i2c.0", "apb_pclk";
> > 
> > Why do most clocks in this series have the instance number in the clock
> > names? This looks very wrong to me.
> 
> +1. The clock names should be the input names to the unit, they
> shouldn't vary per instance.

So I just had a quick look, and it looks like they each have their own
clock:

	clk = clk_reg_prcc_kclk("p1_i2c1_kclk", "i2cclk",
			clkrst1_base, BIT(2), CLK_SET_RATE_GATE);
	clk = clk_reg_prcc_kclk("p1_i2c2_kclk", "i2cclk",
			clkrst1_base, BIT(6), CLK_SET_RATE_GATE);
	clk = clk_reg_prcc_kclk("p2_i2c3_kclk", "i2cclk",
			clkrst2_base, BIT(0), CLK_SET_RATE_GATE);
	clk_register_clkdev(clk, NULL, "nmk-i2c.3");
        
        /* etc */

When using the names in Device Tree it doesn't actually matter what
you call the first clock. You can call it "fred" if you wanted and it
would still work, but in light of the naming conventions above and the
fact that each clock can all be controlled independently, do we still
want to use the name of the parent clock i.e. i2cclk?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
