Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869Ab3DJLjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:39:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36488 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935318Ab3DJLjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:39:46 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "jacmet@sunsite.dk" <jacmet@sunsite.dk>
Subject: RE: [PATCH v4] ARM: davinci: da850: add EHRPWM & ECAP DT node
Thread-Topic: [PATCH v4] ARM: davinci: da850: add EHRPWM & ECAP DT node
Thread-Index: AQHONcGYR36d4hP1o0OOrJAjLrDii5jO90QAgABcczA=
Date: Wed, 10 Apr 2013 11:38:26 +0000
Deferred-Delivery: Wed, 10 Apr 2013 11:38:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EAAB3C1@DBDE01.ent.ti.com>
References: <1365580939-16839-1-git-send-email-avinashphilip@ti.com>
 <51654E7C.5020107@ti.com>
In-Reply-To: <51654E7C.5020107@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3ABdjni011677

On Wed, Apr 10, 2013 at 17:05:24, Nori, Sekhar wrote:
> Avinash,
> 
> On 4/10/2013 1:32 PM, Philip Avinash wrote:
> > Add da850 EHRPWM & ECAP DT node along with pin-mux details for EHRPWM1.
> > Also adds OF_DEV_AUXDATA for EHRPWM & ECAP driver to use EHRPWM & ECAP
> > clock.
> > 
> > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> > ---
> > Changes since v3:
> > 	- add pin mux info for EHRPWM1.
> 
> I think you misunderstood what I asked. Please add pinmux information
> for all the nodes you are adding (ecap0-2 and ehrpwm0). Without pinmux
> setup, these IPs cannot be used anyway. So why leave just the pinmux to
> be added by someone else?

Ok I will add and send updated version.

Thanks
Avinash

> 
> Thanks,
> Sekhar
> 
> > 
> > Changes since v1:
> > 	- Reusing ti,am33xx<ecap/ehrpwm> as compatible field as both IP's are
> > 	  similar with am33xx platform and da850 has no platform specific
> > 	  dependency.
> > 
> >  arch/arm/boot/dts/da850.dtsi     |   42 ++++++++++++++++++++++++++++++++++++++
> >  arch/arm/mach-davinci/da8xx-dt.c |    5 +++++
> >  2 files changed, 47 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
> > index 3ade343..3bff30d 100644
> > --- a/arch/arm/boot/dts/da850.dtsi
> > +++ b/arch/arm/boot/dts/da850.dtsi
> > @@ -71,6 +71,18 @@
> >  					0x28 0x00222222  0x00ffffff
> >  				>;
> >  			};
> > +			ehrpwm1a_pins: pinmux_ehrpwm1a_pins {
> > +				pinctrl-single,bits = <
> > +					/* EPWM1A */
> > +					0x14 0x00000002 0x0000000f
> > +				>;
> > +			};
> > +			ehrpwm1b_pins: pinmux_ehrpwm1b_pins {
> > +				pinctrl-single,bits = <
> > +					/* EPWM1B */
> > +					0x14 0x00000020 0x000000f0
> > +				>;
> > +			};
> >  		};
> >  		serial0: serial@1c42000 {
> >  			compatible = "ns16550a";
> > @@ -122,6 +134,36 @@
> >  			interrupts = <16>;
> >  			status = "disabled";
> >  		};
> > +		ehrpwm0: ehrpwm@01f00000 {
> > +			compatible = "ti,da850-ehrpwm", "ti,am33xx-ehrpwm";
> > +			#pwm-cells = <3>;
> > +			reg = <0x300000 0x2000>;
> > +			status = "disabled";
> > +		};
> > +		ehrpwm1: ehrpwm@01f02000 {
> > +			compatible = "ti,da850-ehrpwm", "ti,am33xx-ehrpwm";
> > +			#pwm-cells = <3>;
> > +			reg = <0x302000 0x2000>;
> > +			status = "disabled";
> > +		};
> > +		ecap0: ecap@01f06000 {
> > +			compatible = "ti,da850-ecap", "ti,am33xx-ecap";
> > +			#pwm-cells = <3>;
> > +			reg = <0x306000 0x80>;
> > +			status = "disabled";
> > +		};
> > +		ecap1: ecap@01f07000 {
> > +			compatible = "ti,da850-ecap", "ti,am33xx-ecap";
> > +			#pwm-cells = <3>;
> > +			reg = <0x307000 0x80>;
> > +			status = "disabled";
> > +		};
> > +		ecap2: ecap@01f08000 {
> > +			compatible = "ti,da850-ecap", "ti,am33xx-ecap";
> > +			#pwm-cells = <3>;
> > +			reg = <0x308000 0x80>;
> > +			status = "disabled";
> > +		};
> >  	};
> >  	nand_cs3@62000000 {
> >  		compatible = "ti,davinci-nand";
> > diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
> > index d83de8f..05bb9a2 100644
> > --- a/arch/arm/mach-davinci/da8xx-dt.c
> > +++ b/arch/arm/mach-davinci/da8xx-dt.c
> > @@ -41,6 +41,11 @@ struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
> >  	OF_DEV_AUXDATA("ti,davinci-i2c", 0x01c22000, "i2c_davinci.1", NULL),
> >  	OF_DEV_AUXDATA("ti,davinci-wdt", 0x01c21000, "watchdog", NULL),
> >  	OF_DEV_AUXDATA("ti,da830-mmc", 0x01c40000, "da830-mmc.0", NULL),
> > +	OF_DEV_AUXDATA("ti,da850-ehrpwm", 0x01f00000, "ehrpwm", NULL),
> > +	OF_DEV_AUXDATA("ti,da850-ehrpwm", 0x01f02000, "ehrpwm", NULL),
> > +	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f06000, "ecap", NULL),
> > +	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f07000, "ecap", NULL),
> > +	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f08000, "ecap", NULL),
> >  	{}
> >  };
> >  
> > 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
