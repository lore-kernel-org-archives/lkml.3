Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaH3Mjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 08:39:39 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58031 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaH3Mjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 08:39:36 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Hartmut Knaack <knaack.h@gmx.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        =?utf-8?B?ZWRkaWUo6JSh5p6rKQ==?= <cf@rock-chips.com>,
        huangtao@rock-chips.com
Subject: Re: [PATCH v6 2/2] dt-bindings: document Rockchip saradc
Date: Sat, 30 Aug 2014 14:41:33 +0200
Message-ID: <1737237.SiLPTrUivB@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <53E38A18.5090203@kernel.org>
References: <1984475.34C1XMW1q3@diego> <8132020.MqcOnlblHg@diego> <53E38A18.5090203@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 7. August 2014, 15:15:52 schrieb Jonathan Cameron:
> On 23/07/14 22:24, Heiko Stübner wrote:
> > This add the necessary binding documentation for the saradc found in all
> > recent processors from Rockchip.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> Applied to the togreg branch of iio.git.
> I have exercised a small amount of discretion wrt to the standard 3 weeks
> as there really is very little different in here from previous versions
> and no one has raised any comments on them.

Did the binding patch make it into any tree? Because when I grep for saradc in 
either linux-next or the iio tree I only get patch 1/2 (the driver itself) but 
the binding document is somehow missing.


Thanks
Heiko


> 
> It's nearly 3 weeks anyway!
> 
> J
> 
> > ---
> > changes since v5:
> > - remove clock-frquency property as described in patch 1/2
> > 
> >  .../bindings/iio/adc/rockchip-saradc.txt           | 24
> >  ++++++++++++++++++++++ 1 file changed, 24 insertions(+)
> >  create mode 100644
> >  Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt> 
> > diff --git a/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt
> > b/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt new file
> > mode 100644
> > index 0000000..5d3ec1d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt
> > @@ -0,0 +1,24 @@
> > +Rockchip Successive Approximation Register (SAR) A/D Converter bindings
> > +
> > +Required properties:
> > +- compatible: Should be "rockchip,saradc"
> > +- reg: physical base address of the controller and length of memory
> > mapped
> > +       region.
> > +- interrupts: The interrupt number to the cpu. The interrupt specifier
> > format +              depends on the interrupt controller.
> > +- clocks: Must contain an entry for each entry in clock-names.
> > +- clock-names: Shall be "saradc" for the converter-clock, and "apb_pclk"
> > for +               the peripheral clock.
> > +- vref-supply: The regulator supply ADC reference voltage.
> > +- #io-channel-cells: Should be 1, see ../iio-bindings.txt
> > +
> > +Example:
> > +	saradc: saradc@2006c000 {
> > +		compatible = "rockchip,saradc";
> > +		reg = <0x2006c000 0x100>;
> > +		interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
> > +		clocks = <&cru SCLK_SARADC>, <&cru PCLK_SARADC>;
> > +		clock-names = "saradc", "apb_pclk";
> > +		#io-channel-cells = <1>;
> > +		vref-supply = <&vcc18>;
> > +	};

