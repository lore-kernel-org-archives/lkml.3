Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaI3COc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:14:32 -0400
Received: from [65.55.169.122] ([65.55.169.122]:1736 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751165AbaI3COb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:14:31 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] clocksource: Add BE APIs support for clocksource
 counter reading.
Thread-Topic: [PATCH v2] clocksource: Add BE APIs support for clocksource
 counter reading.
Thread-Index: AQHP2VI//rRu6j6sqUq5UgI9DpBFeJwTanQAgAJn5mCAAudTgIAAOzFQ
Date: Tue, 30 Sep 2014 02:12:37 +0000
Message-ID: <386a54119f8949c7a21e713d1cc2b99b@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1411712529-35293-1-git-send-email-Li.Xiubo@freescale.com>
 <alpine.DEB.2.11.1409261521340.4567@nanos>
 <f22d0c6ab97f4f45ac66f646626b8c37@BN1PR0301MB0609.namprd03.prod.outlook.com>
 <alpine.DEB.2.02.1409300027150.22082@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1409300027150.22082@ionos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0616;
x-forefront-prvs: 0350D7A55D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(199003)(164054003)(189002)(110136001)(85852003)(92566001)(80022003)(4396001)(76576001)(86362001)(101416001)(46102003)(10300001)(99396003)(87936001)(76482002)(2656002)(33646002)(120916001)(105586002)(106116001)(20776003)(19580395003)(19580405001)(97736003)(99286002)(93886004)(85306004)(95666004)(21056001)(31966008)(108616004)(77096002)(107046002)(66066001)(76176999)(54356999)(106356001)(64706001)(74316001)(50986999)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0616;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Subject: RE: [PATCH v2] clocksource: Add BE APIs support for clocksource
> counter reading.
> 
> On Sun, 28 Sep 2014, Li.Xiubo@freescale.com wrote:
> > > Subject: Re: [PATCH v2] clocksource: Add BE APIs support for clocksource
> > > counter reading.
> > >
> > > On Fri, 26 Sep 2014, Xiubo Li wrote:
> > > > For now I just added  _be() support using ioread{16,32}be.
> > > > And i have a check of the clocksource drivers, didn't find anyone
> > > > using LE mode on one BE SoC, so _le() APIs is not needed.
> > >
> > > Nonsense. The existing clocksource_mmio accessor function are
> > > providing LE access independent of the CPU endianess. So we don't need
> > > an _le() API simply because we have it already.
> > >
> > > >  cycle_t clocksource_mmio_readl_up(struct clocksource *c)
> > > >  {
> > > > -	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
> > > > +	return (cycle_t)ioread32(to_mmio_clksrc(c)->reg);
> > >
> > > And how exactly is this change related to adding BE support?
> > >
> >
> > Actually not very much, since the _be() APIs are using ioread{16,32}be(),
> > so I think using ioread{16,32}() will be less odd to having two different
> > accessors here.
> >
> > Wouldn't this be more unified somehow ?
> 
> Changing existing code wants to be a separate patch with a proper
> changelog and a proper argument WHY it needs to be changed in the
> first place.
> 
> So please provide that separate patch first with a VERY REASONABLE
> explanation in the changelog WHY the existing readl_relaxed() should
> be replaced by ioread32().
> 

Okay, I will follow your advice.

Thanks,

BRs
Xiubo




> Thanks,
> 
> 	tglx
