Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab3CVIKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:10:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59721 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933218Ab3CVIKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:10:14 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: Peter Korsgaard <jacmet@sunsite.dk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>
Subject: RE: [PATCH v2 3/3] ARM: davinci: da850: add EHRPWM & ECAP DT node
Thread-Topic: [PATCH v2 3/3] ARM: davinci: da850: add EHRPWM & ECAP DT node
Thread-Index: AQHOJWkmF2psSPu0PECGfOAw5AwH1ZivsxHggAEpFACAAHRwIA==
Date: Fri, 22 Mar 2013 08:08:40 +0000
Deferred-Delivery: Fri, 22 Mar 2013 08:08:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA9DE1A@DBDE01.ent.ti.com>
References: <1363761714-15034-1-git-send-email-avinashphilip@ti.com>
 <1363761714-15034-4-git-send-email-avinashphilip@ti.com>
 <51499DB4.9080907@ti.com> <87wqt2qlts.fsf@dell.be.48ers.dk>
 <518397C60809E147AF5323E0420B992E3EA9C651@DBDE01.ent.ti.com>
 <514BF1DC.60003@ti.com>
In-Reply-To: <514BF1DC.60003@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2M8B1EU012029

On Fri, Mar 22, 2013 at 11:23:32, Nori, Sekhar wrote:
> On 3/21/2013 1:31 PM, Philip, Avinash wrote:
> > On Wed, Mar 20, 2013 at 18:17:59, Peter Korsgaard wrote:
> >>>>>>> "Sekhar" == Sekhar Nori <nsekhar@ti.com> writes:
> >>
> >>  Sekhar> On 3/20/2013 12:11 PM, Philip Avinash wrote:
> >>  >> Add da850 EHRPWM & ECAP DT node.
> >>  >> Also adds OF_DEV_AUXDATA for EHRPWM & ECAP driver to use EHRPWM & ECAP
> >>  >> clock.
> >>  >> 
> >>  >> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> >>  >> ---
> >>  >> Changes since v1:
> >>  >> - Reusing ti,am33xx<ecap/ehrpwm> as compatible field as both IP's are
> >>  >> same with am33xx platform and da850 has no platform specific
> >>  >> dependency.
> >>
> >>  Sekhar> Which is fine, but I think the binding documentation still needs to be
> >>  Sekhar> updated to document the ti,da850-ehrpwm binding. Looping Peter (it is
> >>  Sekhar> always a good idea to CC folks who reviewed your patch last time
> >>  Sekhar> around). Also, please Cc the DT folks and devicetree-discuss list too
> >>  Sekhar> for their opinion.
> >>
> >> Yes, thanks for CC'ing me. I also think da850-* should be
> >> documented. See Documentation/devicetree/bindings/gpio/8xxx_gpio.txt for
> >> an similar (old) example.
> > 
> > Peter,
> > 
> > In this binding file also, only initial compatible field is updated. Later on many
> > compatible were added in driver. But not update back to binding doc.
> 
> Probably someone forgot to keep updating the binding doc after a point.
> 
> > 
> > <Documentation/devicetree/bindings/gpio/8xxx_gpio.txt>
> > ---
> > 	followed by "fsl,mpc8349-gpio" for 83xx, "fsl,mpc8572-gpio" for 85xx and
> > 	"fsl,mpc8610-gpio" for 86xx.
> > ---
> > <drivers/gpio/gpio-mpc8xxx.c>
> > ---
> > static struct of_device_id mpc8xxx_gpio_ids[] __initdata = {
> >         { .compatible = "fsl,mpc8349-gpio", },
> >         { .compatible = "fsl,mpc8572-gpio", },
> >         { .compatible = "fsl,mpc8610-gpio", },
> >         { .compatible = "fsl,mpc5121-gpio", .data = mpc512x_irq_set_type, },
> >         { .compatible = "fsl,pq3-gpio",     },
> >         { .compatible = "fsl,qoriq-gpio",   },
> >         {}
> > };
> > ---
> > 
> > Grant/Rob,
> > With respect peters explanation (below), what is your opinion on adding information to 
> > binding doc for da850 support?
> > 
> > Peter --> if the hardware block is identical the dts should simply list:
> > Peter --> compatible = "ti,da850-ecap", "ti,am33xx-ecap"
> > Peter --> And the driver only bind to ti,am33xx-ecap (unless there ever needs to
> > Peter --> be a da850 specific workaround.
> > 
> > Or
> > Should I update both binding doc & the driver to use new compatible option "ti,da830-ecap"
> > (as da830 platform has initial IP support)?
> > Even with this, platforms da830, da850 and am33xx can reuse "ti,da830-ecap" compatible field.
> 
> To me updating the driver to keep adding a .compatible even when not
> using it elsewhere in code is not required. Adding the new binding in
> .dts file is must since you may need to do something specific to da830
> at a later time (and the .dtb should be considered ROM'ed so you wont be
> able to change it then).

Thanks for the explanation.
I will add "ti,da850-ecap" for da850.dtsi along with "ti,am33xx-ecap" as
compatible fields.

> Adding documentation for the binding is also
> required to help anyone wanting to know more about the binding after
> reading the .dts file.

I will adding documentation part for "ti,da850-ecap".

Thanks
Avinash

> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
