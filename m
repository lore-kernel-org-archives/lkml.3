Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaDPJkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:40:16 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:9156
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753422AbaDPJkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:40:14 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer
 Module timer node.
Thread-Topic: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer
 Module timer node.
Thread-Index: AQHPWSBaHNmWFeafwkKQ+QxFukJEhZsT8jYAgAALAOA=
Date: Wed, 16 Apr 2014 09:39:52 +0000
Message-ID: <59652f870f1a43cb9bc69401f0e21391@DM2PR03MB509.namprd03.prod.outlook.com>
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
 <1397614787-8300-2-git-send-email-Li.Xiubo@freescale.com>
 <20140416085953.GC11602@dragon>
In-Reply-To: <20140416085953.GC11602@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(164054003)(24454002)(51704005)(81342001)(66066001)(99396002)(76482001)(79102001)(33646001)(99286001)(20776003)(81542001)(54356999)(80022001)(74316001)(74662001)(76176999)(4396001)(76576001)(83322001)(77096999)(85852003)(87936001)(80976001)(83072002)(50986999)(2656002)(74502001)(31966008)(19580405001)(77982001)(46102001)(92566001)(86362001)(19580395003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB477;H:DM2PR03MB509.namprd03.prod.outlook.com;FPR:EC6DDB76.3BB08E15.B26F6B76.9DE616DE.201D5;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer Module
> timer node.
> 
> On Wed, Apr 16, 2014 at 10:19:45AM +0800, Xiubo Li wrote:
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> > Cc: Jingchang Lu <b35083@freescale.com>
> > ---
> >  arch/arm/boot/dts/vf610.dtsi | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> > index 107e2c0..c3a276f 100644
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
> 
> For such completely internal block which has no pins route out on board,
> we should probably just not have this "disabled" status line.
>

Yes, I'll fix it.

Thanks,

BRs
Xiubo

 
> Shawn
> 
> > +			};
> > +
> >  			wdog@4003e000 {
> >  				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
> >  				reg = <0x4003e000 0x1000>;
> > --
> > 1.8.4
> >
> >

