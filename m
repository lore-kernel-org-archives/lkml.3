Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbbAXPxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 10:53:53 -0500
Received: from gn237.zone.eu ([217.146.67.237]:53329 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbbAXPxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 10:53:50 -0500
Message-ID: <1422114821.3851.25.camel@plaes.org>
Subject: Re: [PATCH] ARM: dts: sun4i: Add initial dts for Gemei G9 tablet
From: Priit Laes <plaes@plaes.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 24 Jan 2015 17:53:41 +0200
In-Reply-To: <20150124143945.GD8470@lukather>
References: <1422045409-1251-1-git-send-email-plaes@plaes.org>
	 <20150123212203.GB8470@lukather> <1422050375.1799.9.camel@plaes.org>
	 <20150124143945.GD8470@lukather>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.9 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2015-01-24 at 15:39 +0100, Maxime Ripard wrote:
> Hi,
> 
> On Fri, Jan 23, 2015 at 11:59:35PM +0200, Priit Laes wrote:
> > 
> > On Fri, 2015-01-23 at 22:22 +0100, Maxime Ripard wrote:
> > > On Fri, Jan 23, 2015 at 10:36:49PM +0200, Priit Laes wrote:
> > > > Gemei G9 is an A10 based tablet, with 1G RAM, 16G NAND, 
> > > > 1024x768 IPS LCD display, stereo speakers, 1.3MP front camera 
> > > > and 5 MP
> > > > rear camera, 8000mAh battery, GT901 2+1 touchscreen, Bosch 
> > > > BMA250 accelerometer and RTL8188CUS USB wifi. It also has 
> > > > MicroSD slot, miniHDMI, 1 x MicroUSB OTG port and 1 x MicroUSB 
> > > > host port and 3.5mm headphone jack.
> > > > More details are available at: http://linux-sunxi.org/Gemei_G9
> > > > 
> > [..]
> > > > 
> > > > +/ {
> > > > +    model = "Gemei G9 Tablet";
> > > > +    compatible = "gemei,g9", "allwinner,sun4i-a10";
> > > > +};
> > > > +
> > > > +/*
> > > > + * http://linux-sunxi.org/Gemei_G9
> > > 
> > > Please don't put URL in the DT. This is very likely to change in 
> > > the future, and won't be valid anymore.
> > 
> > OK! The URL in commit message is ok to stay?
> 
> Yeah, I'm not that fond of it, but it's not that important either.
> 
> > > > +&i2c1 {
> > > > +    pinctrl-names = "default";
> > > > +    pinctrl-0 = <&i2c1_pins_a>;
> > > > +    status = "okay";
> > > > +
> > > > +    /* Accelerometer */
> > > > +    bma250@18 {
> > > > +        compatible = "bosch,bma250";
> > > > +        reg = <0x18>;
> > > 
> > > Is there a driver for this? It looks weird that it doesn't need 
> > > more properties than that.
> > 
> > Yes, it's supported by drivers/iio/accel/bma180.c though I have to 
> > admit that this name is a bit misleading. (bosch-bma.c would
> > better, I guess).
> > 
> > And I was a bit surprised that it worked out of the box too, but 
> > the device was present under /sys and I was able to read x, y, z 
> > and temperature values.
> 
> Cool :)
> 
> There's no interrupt wired to it then?

Well, FEX file contained this:

[gsensor_para]
gsensor_used = 1
gsensor_name = "bma250"
gsensor_twi_addr = 0x18
gsensor_twi_id = 1
gsensor_int1 = port:PH00<6><1><default><default>
gsensor_int2 = port:PI10<6><1><default><default>

And according to the datasheet, this chip (bma250) has two interrupt 
pins.

Now, the bma180/250 driver works without IRQ-s, but it currently only 
supports single interrupt pin. Therefore I should at least add a 
comment about these pins and revisit this issue later.

/* TODO: check whether following interrupt pins are connected:
 *   - int1 - PH00
 *   - int2 - PI10
 */


Päikest,
Priit Laes :)



