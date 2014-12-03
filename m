Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaLCDJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 22:09:18 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:40744 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaLCDJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 22:09:16 -0500
Date: Wed, 3 Dec 2014 12:09:05 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, jg1.han@samsung.com, cooloney@gmail.com,
        broonie@kernel.org, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        treding@nvidia.com, florian.vaussard@epfl.ch, trivial@kernel.org,
        linux@roeck-us.net, andrew@lunn.ch, jic23@kernel.org
Subject: Re: [PATCH v9 3/8] devicetree: mfd: Add new SKY81452 mfd binding
Message-ID: <20141203030905.GA4352@jack-ThinkPad-T520>
References: <1417507529-13654-1-git-send-email-jack.yoo@skyworksinc.com>
 <1417507529-13654-4-git-send-email-jack.yoo@skyworksinc.com>
 <20141202140727.GD22522@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141202140727.GD22522@x1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 02:07:27PM +0000, Lee Jones wrote:
> This requires a DT Ack.

I think I need to double-check the recipients.
Thank you for the comment.

> 
> > From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> > 
> > Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> > ---
> > Changes v9:
> > Nothing
> > 
> > Changes v8:
> > Made up the example for backlight DT
> > 
> > Changes v7:
> > Nothing
> > 
> > Changes v6:
> > Nothing
> > 
> > Changes v5:
> > Changed DT for regulator : 'lout' node should be defined under 'regulator'
> > Removed compatible string from sky81452-regulator driver
> > 
> > Changes v4:
> > Nothing
> > 
> > Changes v3:
> > Nothing
> > 
> > Changes v2:
> > Added reg attribute for I2C slave address
> > 
> >  Documentation/devicetree/bindings/mfd/sky81452.txt | 36 ++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/sky81452.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/sky81452.txt b/Documentation/devicetree/bindings/mfd/sky81452.txt
> > new file mode 100644
> > index 0000000..ab71473
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/sky81452.txt
> > @@ -0,0 +1,36 @@
> > +SKY81452 bindings
> > +
> > +Required properties:
> > +- compatible	: Must be "skyworks,sky81452"
> > +- reg		: I2C slave address
> > +
> > +Required child nodes:
> > +- backlight	: container node for backlight following the binding
> > +		in video/backlight/sky81452-backlight.txt
> > +- regulator	: container node for regulators following the binding
> > +		in regulator/sky81452-regulator.txt
> > +
> > +Example:
> > +
> > +	sky81452@2c {
> > +		compatible = "skyworks,sky81452";
> > +		reg = <0x2c>;
> > +
> > +		backlight {
> > +			compatible = "skyworks,sky81452-backlight";
> > +			name = "pwm-backlight";
> > +			skyworks,en-channels = <0x3f>;
> > +			skyworks,ignore-pwm;
> > +			skyworks,phase-shift;
> > +			skyworks,ovp-level = <20>;
> > +			skyworks,current-limit = <2300>;
> > +		};
> > +
> > +		regulator {
> > +			lout {
> > +				regulator-name = "sky81452-lout";
> > +				regulator-min-microvolt = <4500000>;
> > +				regulator-max-microvolt = <8000000>;
> > +			};
> > +		};
> > +	};
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
