Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaDPGIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:08:50 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:5445
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754447AbaDPGIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:08:48 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer
 Module timer node.
Thread-Topic: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer
 Module timer node.
Thread-Index: AQHPWSBaHNmWFeafwkKQ+QxFukJEhZsTnrKAgAAinaA=
Date: Wed, 16 Apr 2014 06:08:45 +0000
Message-ID: <42acfcd1b83143d38bda219a7854838d@DM2PR03MB509.namprd03.prod.outlook.com>
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
 <1397614787-8300-2-git-send-email-Li.Xiubo@freescale.com>
 <a7aeb70fae2c480198b413f581f76846@BN1PR03MB188.namprd03.prod.outlook.com>
In-Reply-To: <a7aeb70fae2c480198b413f581f76846@BN1PR03MB188.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(189002)(199002)(164054003)(80022001)(66066001)(20776003)(76576001)(99396002)(46102001)(81542001)(77096999)(54356999)(50986999)(99286001)(86362001)(2201001)(77982001)(92566001)(76176999)(79102001)(31966008)(81342001)(33646001)(74316001)(76482001)(4396001)(74662001)(80976001)(2656002)(74502001)(87936001)(83322001)(85852003)(19580395003)(19580405001)(83072002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB479;H:DM2PR03MB509.namprd03.prod.outlook.com;FPR:E8597776.B8A086DB.AEEC2CC6.D4EEF59E.2015E;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > --- a/arch/arm/boot/dts/vf610.dtsi
> > +++ b/arch/arm/boot/dts/vf610.dtsi
> > @@ -153,6 +153,19 @@
> >  				clock-names = "pit";
> >  			};
> >
> > +			ftm0: ftm@40038000 {
> > +				compatible = "fsl,vf610-ftm-timer";
> > +				reg = <0x40038000 0x2000>;
> > +				interrupts = <0 42 IRQ_TYPE_LEVEL_HIGH>;
> > +				clock-names = "ftm0", "ftm1",
> > +					"ftm0_counter_en", "ftm1_counter_en";
> > +				clocks = <&clks VF610_CLK_FTM0>,
> > +					<&clks VF610_CLK_FTM1>,
> > +					<&clks VF610_CLK_FTM0_EXT_FIX_EN>,
> > +					<&clks VF610_CLK_FTM1_EXT_FIX_EN>;
> > +				status = "disabled";
> > +			};
> > +
> 
> They need to be separated. ftm0, ftm1.
> 

Well, if so the driver will adjust much more to and I do think one dts
Node is okey.

The dts patches of this series are just for testing and reference for
The timer driver on Vybrid-twr.

Thanks,

BRs
Xiubo

> >  			wdog@4003e000 {
> >  				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
> >  				reg = <0x4003e000 0x1000>;
> > --
> > 1.8.4
> >

