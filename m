Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbaCQLsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:48:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57413 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932514AbaCQLsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:48:43 -0400
Date: Mon, 17 Mar 2014 12:48:41 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com,
        b.brezillon@overkiz.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com, devicetree@vger.kernel.org,
        thomas.petazzoni@free-electrons.com
Subject: Re: [PATCH v5 4/9] at91: dt: Add at91sam9261 dt SoC support
Message-ID: <20140317114840.GD12021@piout.net>
References: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
 <1393841162-25339-5-git-send-email-jjhiblot@traphandler.com>
 <20140317114018.GE9558@ns203013.ovh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317114018.GE9558@ns203013.ovh.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Christophe,

I think you are a bit late and the series got taken by Nicolas. Anyway, most of
your comments have been taken care of.

On 17/03/2014 at 12:40:18 +0100, Jean-Christophe PLAGNIOL-VILLARD wrote :
> On 11:05 Mon 03 Mar     , Jean-Jacques Hiblot wrote:
> > +		usb0: ohci@00500000 {
> > +			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
> > +			reg = <0x00500000 0x100000>;
> > +			interrupts = <20 IRQ_TYPE_LEVEL_HIGH 2>;
> 
> for 5th time NACK
> 
> stop using interrupts une interrupts-extended

As there is only one interrupt controller, I don't see why we would
absolutely need to specify the interrupt controller here.

> > +			clocks = <&usb>, <&ohci_clk>, <&hclk0>, <&uhpck>;
> > +			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
> > +			status = "disabled";
> > +		};
> > diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
> > index 6276b4c..5c90581 100644
> > --- a/arch/arm/mach-at91/at91sam9261.c
> > +++ b/arch/arm/mach-at91/at91sam9261.c
> > @@ -189,6 +189,23 @@ static struct clk_lookup periph_clocks_lookups[] = {
> >  	CLKDEV_CON_ID("pioA", &pioA_clk),
> >  	CLKDEV_CON_ID("pioB", &pioB_clk),
> >  	CLKDEV_CON_ID("pioC", &pioC_clk),
> > +	/* more lookup table for DT entries */
> > +	CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
> > +	CLKDEV_CON_DEV_ID("usart", "fffb0000.serial", &usart0_clk),
> > +	CLKDEV_CON_DEV_ID("usart", "ffffb400.serial", &usart1_clk),
> > +	CLKDEV_CON_DEV_ID("usart", "fff94000.serial", &usart2_clk),
> > +	CLKDEV_CON_DEV_ID("t0_clk", "fffa0000.timer", &tc0_clk),
> > +	CLKDEV_CON_DEV_ID("t1_clk", "fffa0000.timer", &tc1_clk),
> > +	CLKDEV_CON_DEV_ID("t2_clk", "fffa0000.timer", &tc2_clk),
> > +	CLKDEV_CON_DEV_ID("hclk", "500000.ohci", &hck0),
> > +	CLKDEV_CON_DEV_ID("hclk", "600000.fb", &hck1),
> > +	CLKDEV_CON_DEV_ID("spi_clk", "fffc8000.spi", &spi0_clk),
> > +	CLKDEV_CON_DEV_ID("spi_clk", "fffcc000.spi", &spi1_clk),
> > +	CLKDEV_CON_DEV_ID("mci_clk", "fffa8000.mmc", &mmc_clk),
> > +	CLKDEV_CON_DEV_ID(NULL, "fffac000.i2c", &twi_clk),
> > +	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioA_clk),
> > +	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioB_clk),
> > +	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioC_clk),
> 
> do we really need this?

Yes, until all the SoCs are switch to the CCF, we may build kernel
supporting multiple sam9 SoCs without CCF.

Best regards,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
