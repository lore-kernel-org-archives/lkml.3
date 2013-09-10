Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab3IJIKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:10:20 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:53601
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960Ab3IJIKP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:10:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551biz1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Guo Shawn-R65073 <r65073@freescale.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCHv3 2/4] ARM: dts: Add Freescale FTM PWM node for VF610.
Thread-Topic: [PATCHv3 2/4] ARM: dts: Add Freescale FTM PWM node for VF610.
Thread-Index: AQHOqtji3XZhuhXC70+q8ifjcSgf05m+i6cAgAAT1YA=
Date: Tue, 10 Sep 2013 08:10:09 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F828136F5@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1378454907-22728-1-git-send-email-Li.Xiubo@freescale.com>
 <1378454907-22728-3-git-send-email-Li.Xiubo@freescale.com>
 <20130910064044.GZ30088@pengutronix.de>
In-Reply-To: <20130910064044.GZ30088@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.56]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/arch/arm/boot/dts/vf610.dtsi
> > b/arch/arm/boot/dts/vf610.dtsi index 67d929c..44787b5 100644
> > --- a/arch/arm/boot/dts/vf610.dtsi
> > +++ b/arch/arm/boot/dts/vf610.dtsi
> > @@ -140,6 +140,37 @@
> >  				clock-names = "pit";
> >  			};
> >
> > +			pwm0: pwm@40038000 {
> > +				compatible = "fsl,vf610-ftm-pwm";
> > +				#pwm-cells = <3>;
> > +				reg = <0x40038000 0x1000>;
> > +				clock-names = "ftm0", "ftm0_fix_sel",
> "ftm0_ext_sel";
> > +				clocks = <&clks VF610_CLK_FTM0>,
> > +					<&clks VF610_CLK_FTM0_FIX_SEL>,
> > +					<&clks VF610_CLK_FTM0_EXT_SEL>;
> > +				pinctrl-names = "ch0-active", "ch0-idle", "ch1-
> active", "ch1-idle",
> > +						"ch2-active", "ch2-idle", "ch3-
> active", "ch3-idle",
> > +						"ch4-active", "ch4-idle", "ch5-
> active", "ch5-idle",
> > +						"ch6-active", "ch6-idle", "ch7-
> active", "ch7-idle";
> > +				pinctrl-0 = <&pinctrl_pwm0_ch0_active>;
> > +				pinctrl-1 = <&pinctrl_pwm0_ch0_idle>;
> > +				pinctrl-2 = <&pinctrl_pwm0_ch1_active>;
> > +				pinctrl-3 = <&pinctrl_pwm0_ch1_idle>;
> > +				pinctrl-4 = <&pinctrl_pwm0_ch2_active>;
> > +				pinctrl-5 = <&pinctrl_pwm0_ch2_idle>;
> > +				pinctrl-6 = <&pinctrl_pwm0_ch3_active>;
> > +				pinctrl-7 = <&pinctrl_pwm0_ch3_idle>;
> > +				pinctrl-8 = <&pinctrl_pwm0_ch4_active>;
> > +				pinctrl-9 = <&pinctrl_pwm0_ch4_idle>;
> > +				pinctrl-10 = <&pinctrl_pwm0_ch5_active>;
> > +				pinctrl-11 = <&pinctrl_pwm0_ch5_idle>;
> > +				pinctrl-12 = <&pinctrl_pwm0_ch6_active>;
> > +				pinctrl-13 = <&pinctrl_pwm0_ch6_idle>;
> > +				pinctrl-14 = <&pinctrl_pwm0_ch7_active>;
> > +				pinctrl-15 = <&pinctrl_pwm0_ch7_idle>;
> > +				status = "disabled";
> > +			};
> 
> This is a SoC file, but the pinmux is board specific. The pinmux settings
> probably shouldn't be here.
> 
Yes, agreed.

I will revise it soon.

--
Xiubo

