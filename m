Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaAMM1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:27:38 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:56679 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaAMM1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:27:36 -0500
Date: Mon, 13 Jan 2014 13:26:25 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH 2/2] pwm: imx: support polarity inversion
Message-ID: <20140113132625.4409abfc@ipc1.ka-ro>
In-Reply-To: <11504930.fjG2AZiQ4e@wuerfel>
References: <1389608988-10981-1-git-send-email-LW@KARO-electronics.de>
	<1389608988-10981-3-git-send-email-LW@KARO-electronics.de>
	<11504930.fjG2AZiQ4e@wuerfel>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Arnd Bergmann wrote:
> On Monday 13 January 2014 11:29:48 Lothar Waßmann wrote:
> 
> > diff --git a/arch/arm/boot/dts/imx50.dtsi b/arch/arm/boot/dts/imx50.dtsi
> > index 01c0499..e3647a8 100644
> > --- a/arch/arm/boot/dts/imx50.dtsi
> > +++ b/arch/arm/boot/dts/imx50.dtsi
> > @@ -273,7 +273,7 @@
> >  			};
> >  
> >  			pwm1: pwm@53fb4000 {
> > -				#pwm-cells = <2>;
> > +				#pwm-cells = <3>;
> >  				compatible = "fsl,imx50-pwm", "fsl,imx27-pwm";
> >  				reg = <0x53fb4000 0x4000>;
> >  				clocks = <&clks IMX5_CLK_PWM1_IPG_GATE>,
> ...
> > @@ -271,6 +293,13 @@ static int imx_pwm_probe(struct platform_device *pdev)
> >  		return PTR_ERR(imx->mmio_base);
> >  
> >  	data = of_id->data;
> > +	if (data->output_polarity) {
> > +		dev_info(&pdev->dev, "PWM supports inversion\n");
> > +		imx_pwm_ops.set_polarity = imx_pwm_set_polarity;
> > +		imx->chip.of_xlate = of_pwm_xlate_with_flags;
> > +		imx->chip.of_pwm_n_cells = 3;
> > +	}
> > +
> >  	imx->config = data->config;
> >  	imx->set_enable = data->set_enable;
> 
> This looks like you are breaking compatibility with the binding,
> which requires #pwm-cells to be <2>. You can extend the binding
> to allow both <2> and <3>, but then you have to not only document
> that change in the binding, but also ensure that the pwm driver
> is able to use either variant.
> 
Good point. I'll try to change the driver to cope with either binding,
so the changes to the dts files of the current users will not be
necessary.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
