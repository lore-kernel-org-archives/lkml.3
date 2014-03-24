Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaCXCz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 22:55:28 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:49851
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750993AbaCXCz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 22:55:26 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Shawn Guo <Shawn.Guo@freescale.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] ARM: dts: vf610: Add Freescale FTM PWM node.
Thread-Topic: [PATCH 1/3] ARM: dts: vf610: Add Freescale FTM PWM node.
Thread-Index: AQHPRAETHfNYzSfrwEmv9d8e2sGEcprvjicAgAACblA=
Date: Mon, 24 Mar 2014 02:55:23 +0000
Message-ID: <2ba17bb357784b5990bedc1cfd0d6512@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395292325-8497-2-git-send-email-Li.Xiubo@freescale.com>
 <20140324023900.GA4002@dragon>
In-Reply-To: <20140324023900.GA4002@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01604FB62B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(199002)(189002)(51704005)(24454002)(83322001)(19580395003)(81686001)(31966008)(15975445006)(81816001)(2656002)(65816001)(76796001)(74316001)(74366001)(74876001)(76786001)(98676001)(93136001)(20776003)(19580405001)(94316002)(80022001)(86362001)(93516002)(87936001)(54316002)(66066001)(53806001)(54356001)(97336001)(94946001)(76482001)(47446002)(59766001)(87266001)(69226001)(90146001)(56816005)(83072002)(63696002)(74662001)(74502001)(47976001)(49866001)(47736001)(81342001)(95666003)(4396001)(33646001)(56776001)(79102001)(95416001)(92566001)(51856001)(46102001)(80976001)(85306002)(81542001)(97186001)(50986001)(85852003)(74706001)(76576001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB347;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:F865EB56.18308E90.F8CC41B7.96A616DA.2024C;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH 1/3] ARM: dts: vf610: Add Freescale FTM PWM node.
> 
> On Thu, Mar 20, 2014 at 01:12:03PM +0800, Xiubo Li wrote:
> > This adds devicetree node for VF610, and there are 8 channels
> > supported.
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Reviewed-by: Yuan Yao <yao.yuan@freescale.com>
> 
> Please copy list linux-arm-kernel instead of linux-kernel on arch/arm/
> changes, and also be noted that my email and git addresses just got
> updated [1].
> 

Okey.

> > ---
> >  arch/arm/boot/dts/vf610.dtsi | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> > index acf544e..ccc6d35 100644
> > --- a/arch/arm/boot/dts/vf610.dtsi
> > +++ b/arch/arm/boot/dts/vf610.dtsi
> > @@ -192,6 +192,19 @@
> >  				status = "disabled";
> >  			};
> >
> > +			pwm0: pwm@40038000 {
> 
> The node should be sorted in unit-address.  So shouldn't it be put right
> after pit node?
> 

Yes, I will fix it.

Thanks,

BRs,
Xiubo


> Shawn
> 
> [1]
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f1c
> 12837220c54c8d7138a4ee4a08c1ec67b68a2
> 
> > +				compatible = "fsl,vf610-ftm-pwm";
> > +				#pwm-cells = <3>;
> > +				reg = <0x40038000 0x1000>;
> > +				clock-names = "ftm_sys", "ftm_ext",
> > +					      "ftm_fix", "ftm_cnt_clk_en";
> > +				clocks = <&clks VF610_CLK_FTM0>,
> > +					<&clks VF610_CLK_FTM0_EXT_SEL>,
> > +					<&clks VF610_CLK_FTM0_FIX_SEL>,
> > +					<&clks VF610_CLK_FTM0_EXT_FIX_EN>;
> > +				status = "disabled";
> > +			};
> > +
> >  			wdog@4003e000 {
> >  				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
> >  				reg = <0x4003e000 0x1000>;
> > --
> > 1.8.4
> >
> >

