Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbaDQIe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:34:56 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:44467
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751113AbaDQIew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:34:52 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Shawn Guo <Shawn.Guo@freescale.com>
CC: Shawn Guo <shawn.guo@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
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
Thread-Index: AQHPWSBaHNmWFeafwkKQ+QxFukJEhZsT8jYAgAF5iLCAAA5fAIAAArsg
Date: Thu, 17 Apr 2014 08:34:48 +0000
Message-ID: <4d7a62616f2a4b21af2d20b45deef0b6@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
 <1397614787-8300-2-git-send-email-Li.Xiubo@freescale.com>
 <20140416085953.GC11602@dragon>
 <6934b6e7d11f4eb6a8ec74542820d718@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140417082228.GA22160@dragon>
In-Reply-To: <20140417082228.GA22160@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(24454002)(51704005)(46102001)(4396001)(76576001)(74502001)(99396002)(99286001)(74662001)(87936001)(31966008)(76176999)(50986999)(54356999)(2656002)(77096999)(81542001)(85852003)(76482001)(77982001)(81342001)(79102001)(83072002)(86362001)(92566001)(19580405001)(83322001)(19580395003)(33646001)(66066001)(80022001)(74316001)(20776003)(80976001)(21314002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB377;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:EC44D05E.BFA25AC1.B2FF557B.44D6E1DE.202CE;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
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
> On Thu, Apr 17, 2014 at 07:49:31AM +0000, Li.Xiubo@freescale.com wrote:
> > > > +			ftm0: ftm@40038000 {
> > > > +				compatible = "fsl,vf610-ftm-timer";
> > > > +				reg = <0x40038000 0x2000>;
> > > > +				interrupts = <0 42 IRQ_TYPE_LEVEL_HIGH>;
> > > > +				clock-names = "ftm0", "ftm1",
> > > > +					"ftm0_counter_en", "ftm1_counter_en";
> > > > +				clocks = <&clks VF610_CLK_FTM0>,
> > > > +					<&clks VF610_CLK_FTM1>,
> > > > +					<&clks VF610_CLK_FTM0_EXT_FIX_EN>,
> > > > +					<&clks VF610_CLK_FTM1_EXT_FIX_EN>;
> > > > +				status = "disabled";
> > >
> > > For such completely internal block which has no pins route out on board,
> > > we should probably just not have this "disabled" status line.
> > >
> >
> > Well, from IEEE 1275, there defined a standard 'status' property indicating
> > The operational status of one device. The 'status' property has four
> possible
> > values: 'okay/ok', 'disabled', 'fail' and 'fail-xxx'.
> >
> > If it is absent, that means the status of the device is unknown or okay.
> 
> Yes, missing 'disabled' status equals to a 'okay' status from Linux
> implementation.  Then, the device is always available in device tree,
> and Linux Kconfig option will control whether the driver for the device
> is enabled.
> 
> >
> > If discard the status line here in vf610.dtsi, this device will be enabled
> > as default though 'no pins route out' on the board, and actually there has
> > pins route out on the board, as timer devices here we just not use it, but
> > as PWM devices the pins will be used.
> >
> > How about let the node disabled in vf610.dtsi, and then enable it in vf610-
> twr.dts
> > if it will be used in TWR board... ?
> 
> Okay.  If there is some use cases that have board level configuration
> like pin out, I'm fine with your existing code.
> 

@Shawn,

I'll send the v2 patch series of this.

Thanks very much for your comments.

BRs
Xiubo



> Shawn

