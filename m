Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaDQHtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:49:36 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:32635
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751088AbaDQHte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:49:34 -0400
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
Thread-Index: AQHPWSBaHNmWFeafwkKQ+QxFukJEhZsT8jYAgAF5iLA=
Date: Thu, 17 Apr 2014 07:49:31 +0000
Message-ID: <6934b6e7d11f4eb6a8ec74542820d718@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
 <1397614787-8300-2-git-send-email-Li.Xiubo@freescale.com>
 <20140416085953.GC11602@dragon>
In-Reply-To: <20140416085953.GC11602@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(979002)(6009001)(428001)(164054003)(199002)(189002)(51704005)(50986999)(46102001)(80976001)(19580395003)(99286001)(54356999)(77096999)(99396002)(76176999)(74316001)(4396001)(19580405001)(66066001)(76482001)(83322001)(74502001)(20776003)(77982001)(33646001)(79102001)(81542001)(2656002)(92566001)(86362001)(80022001)(76576001)(85852003)(74662001)(31966008)(81342001)(87936001)(83072002)(21314002)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB191;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:EC64D85E.BFA25A03.9AEF177B.C4E6F19E.201E5;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Well, from IEEE 1275, there defined a standard 'status' property indicating
The operational status of one device. The 'status' property has four possible
values: 'okay/ok', 'disabled', 'fail' and 'fail-xxx'.

If it is absent, that means the status of the device is unknown or okay.

If discard the status line here in vf610.dtsi, this device will be enabled
as default though 'no pins route out' on the board, and actually there has
pins route out on the board, as timer devices here we just not use it, but
as PWM devices the pins will be used.

How about let the node disabled in vf610.dtsi, and then enable it in vf610-twr.dts
if it will be used in TWR board... ?

Thanks,

BRs
Xiubo
