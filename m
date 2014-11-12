Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaKLNoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:44:20 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65451 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaKLNoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:44:17 -0500
Date: Wed, 12 Nov 2014 13:44:12 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH 03/13] ARM: STi: DT: STiH416: Add DT nodes for the ehci
 and ohci usb controllers.
Message-ID: <20141112134412.GA20187@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
 <1415361475-6218-4-git-send-email-peter.griffin@linaro.org>
 <2945908.5UNg8NaKcc@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2945908.5UNg8NaKcc@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for reviewing.

On Fri, 07 Nov 2014, Arnd Bergmann wrote:

> > +               ehci0: usb@0xfe1ffe00 {
> 
> Please drop the '0x' from the unit address in all instances.

Ok, fixed in v2

> 
> > +                       compatible = "st,st-ehci-300x";
> > +                       reg = <0xfe1ffe00 0x100>;
> > +                       interrupts = <GIC_SPI 148 IRQ_TYPE_NONE>;
> > +                       pinctrl-names = "default";
> > +                       pinctrl-0 = <&pinctrl_usb0>;
> > +                       clocks = <&clk_s_a1_ls 0>,
> > +                                <&clockgen_b0 0>;
> > +                       clock-names = "ic", "clk48";
> > +
> > +                       phys = <&usb2_phy>;
> > +                       phy-names = "usb";
> > +                       status = "okay";
> 
> No need to list 'status="okay"', it's the default. It might
> make sense to change this to 'status="disabled"' though, if the ports
> might be unused on some boards.

ok, removed in v2

> 
> >                 mmc0: sdhci@fe81e000 {
> >                         bus-width = <8>;
> >                 };
> > +
> > +               usb0: usb@fe100000 {
> > +                       status = "okay";
> > +               };
> > +
> > +               usb1: usb@fe200000 {
> > +                       status = "okay";
> > +               };
> > +
> > +               usb2: usb@fe300000 {
> > +                       status = "okay";
> > +               };
> 
> I don't understand this part: why do you add extra nodes here that only
> contain a status property?

Good spot, this is a bit of legacy code which I should have removed before submitting.
It's removed in v2.

regards,

Peter.
