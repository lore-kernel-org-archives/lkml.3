Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaJGNrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:47:11 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.105]:48829 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbaJGNrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:47:07 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-10.tower-194.messagelabs.com!1412689622!20651418!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Jonathan Cameron <jic23@kernel.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH 2/8] mfd: da9150: Add DT binding documentation for core
Thread-Topic: [PATCH 2/8] mfd: da9150: Add DT binding documentation for core
Thread-Index: AQHP1xyeOL0m8+7e7EKjsGF+z4OCFpwUvs8AgA/9KXA=
Date: Tue, 7 Oct 2014 13:47:01 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB518CFE@SW-EX-MBX01.diasemi.com>
References: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com>
 <b71815ff49a1cabe2c7907a96cc1be34f924648e.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
 <5426932E.7060609@kernel.org>
In-Reply-To: <5426932E.7060609@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s97DlFxW016860

On September 27, 2014 11:37, Jonathan Cameron wrote:

> On 23/09/14 11:53, Adam Thomson wrote:
> > Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> Obviously this really wants a review from one of the device tree guys, but I
> have a few
> bits based on what Mark has recently said in other reviews ;)
> > ---
> >  Documentation/devicetree/bindings/mfd/da9150.txt | 41
> ++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/da9150.txt
> >
> > diff --git a/Documentation/devicetree/bindings/mfd/da9150.txt
> b/Documentation/devicetree/bindings/mfd/da9150.txt
> > new file mode 100644
> > index 0000000..d7de150
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/da9150.txt
> > @@ -0,0 +1,41 @@
> > +Dialog Semiconductor DA9150 Combined Charger/Fuel-Gauge MFD bindings
> > +
> > +DA9150 consists of a group of sub-devices (I2C Only):
> What does I2C only add to the description?

Nothing really. Will remove.

> > +
> > +Device			 Description
> > +------			 -----------
> > +da9150-gpadc		: IIO - GPADC
> Given usual aversion to anything driver specific in the device tree description
> you probably
> just want to describe what they do rather than what subsystem provides the driver.

Ok, can update accordingly.

> 
> > +da9150-charger		: Power Supply (Charger)
> > +
> > +======
> > +
> > +Required properties:
> > +- compatible : Should be "dlg,da9150"
> > +- reg: Specifies the I2C slave address
> > +- interrupt-parent: Specifies the phandle of the interrupt controller to which
> > +  the IRQs from da9150 are delivered to.
> > +- interrupts: IRQ line info for da9150 chip.
> Cross refer to the standard interrupts doc for these...
> 

Ok, can do that.

> > +- interrupt-controller: da9150 has internal IRQs (own IRQ domain).
> > +
> > +Sub-devices:
> > +- da9150-gpadc: See Documentation/devicetree/bindings/iio/adc/da9150-
> gpadc.txt
> > +- da9150-charger: See Documentation/devicetree/bindings/power/da9150-
> charger.txt
> > +
> > +
> > +Example:
> > +
> > +	charger_fg: da9150@58 {
> > +		compatible = "dlg,da9150";
> > +		reg = <0x58>;
> > +		interrupt-parent = <&gpio6>;
> > +		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
> > +		interrupt-controller;
> > +
> > +		gpadc: da9150-gpadc {
> > +			...
> > +		};
> > +
> > +		da9150-charger {
> > +			...
> > +		};
> > +	};
> > --
> > 1.9.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
