Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3GVBTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:19:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51675 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab3GVBTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:19:30 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 1/3] mfd: add LP3943 MFD driver
Thread-Topic: [PATCH 1/3] mfd: add LP3943 MFD driver
Thread-Index: Ac6BzEn3Qmj4peQLTCahfY4cnCS0AwDdmr2AAEwjZzA=
Date: Mon, 22 Jul 2013 01:19:18 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E8317C@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E815C3@DQHE06.ent.ti.com>
 <CACRpkdYF=ZDqqoU6Kq4cwgaufUjpQmX+dxUexqcvb=KiqDdBoQ@mail.gmail.com>
In-Reply-To: <CACRpkdYF=ZDqqoU6Kq4cwgaufUjpQmX+dxUexqcvb=KiqDdBoQ@mail.gmail.com>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This needs to be reviewed by the devicetree people.
> Please break out the bindings separately and include
> devicetree@vger.kernel.org on that review.

OK, thanks.
 
> > +++ b/Documentation/devicetree/bindings/mfd/lp3943.txt
> > @@ -0,0 +1,23 @@
> > +Bindings for TI/National Semiconductor LP3943 Driver
> > +
> > +Required properties:
> > +  - compatible: "ti,lp3943"
> > +  - reg: 7bit I2C slave address. 0x60 ~ 0x67
> > +
> > +Optional properties:
> > +  - ti,pwm0, ti,pwm1: Output channel definition for PWM port 0 and 1
> > +                      0 = invalid, 1 = LED0, 2 = LED 1, ... 16 =
> > +LED15
> > +
> > +Datasheet
> > +  http://www.ti.com/lit/ds/snvs256b/snvs256b.pdf
> > +
> > +Application note: How to use LP3943 as a GPIO expander and PWM
> > +generator
> > +  http://www.ti.com/lit/an/snva287a/snva287a.pdf
> 
> Do we usually put these things into bindings?

Actually I want to put this information in the driver document, but
I've not found which part is the best place for the MFD documentation.

> > +Example:
> > +
> > +       lp3943@60 {
> > +               compatible = "ti,lp3943";
> > +               reg = <0x60>;
> > +               pwm1 = /bits/ 8 <2>;    /* use LED1 output as PWM #1 */
> > +       };
> 
> OK so there is a way to state which lines are used for PWM.
> 
> I think you should also specify which lines are used for GPIO, and which
> lines are used for LEDs.
>
> And I'd like the masks to be passed to each subdriver, so we can avoid the
> scenario where one and the same line gets used for GPIO, LED and PWM at the
> same time.

Good idea. This is my missing point - I was writing the LP3943 DT is only used for the definition of the platform data.
Thanks.

Regards,
Milo
