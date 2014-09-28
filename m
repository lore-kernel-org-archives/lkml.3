Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaI1Cj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 22:39:58 -0400
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:60859
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751531AbaI1Cj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 22:39:57 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] clocksource: Add BE APIs support for clocksource
 counter reading.
Thread-Topic: [PATCH v2] clocksource: Add BE APIs support for clocksource
 counter reading.
Thread-Index: AQHP2VI//rRu6j6sqUq5UgI9DpBFeJwTanQAgAJn5mA=
Date: Sun, 28 Sep 2014 02:39:54 +0000
Message-ID: <f22d0c6ab97f4f45ac66f646626b8c37@BN1PR0301MB0609.namprd03.prod.outlook.com>
References: <1411712529-35293-1-git-send-email-Li.Xiubo@freescale.com>
 <alpine.DEB.2.11.1409261521340.4567@nanos>
In-Reply-To: <alpine.DEB.2.11.1409261521340.4567@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0612;
x-forefront-prvs: 03484C0ABF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(164054003)(199003)(189002)(51704005)(85306004)(76576001)(81342003)(74662003)(81542003)(74502003)(83322001)(79102003)(108616004)(92566001)(80022003)(46102003)(77982003)(21056001)(74316001)(86362001)(54356999)(85852003)(50986999)(76176999)(83072002)(31966008)(2656002)(87936001)(77096002)(99396003)(99286002)(95666004)(76482002)(66066001)(97736003)(120916001)(101416001)(4396001)(33646002)(107046002)(20776003)(110136001)(90102001)(10300001)(106356001)(64706001)(105586002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0612;H:BN1PR0301MB0609.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Subject: Re: [PATCH v2] clocksource: Add BE APIs support for clocksource
> counter reading.
> 
> On Fri, 26 Sep 2014, Xiubo Li wrote:
> > For now I just added  _be() support using ioread{16,32}be.
> > And i have a check of the clocksource drivers, didn't find anyone
> > using LE mode on one BE SoC, so _le() APIs is not needed.
> 
> Nonsense. The existing clocksource_mmio accessor function are
> providing LE access independent of the CPU endianess. So we don't need
> an _le() API simply because we have it already.
> 
> >  cycle_t clocksource_mmio_readl_up(struct clocksource *c)
> >  {
> > -	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
> > +	return (cycle_t)ioread32(to_mmio_clksrc(c)->reg);
> 
> And how exactly is this change related to adding BE support?
> 

Actually not very much, since the _be() APIs are using ioread{16,32}be(),
so I think using ioread{16,32}() will be less odd to having two different
accessors here.

Wouldn't this be more unified somehow ?  

Thanks very much,

BRs
Xiubo

> Thanks,
> 
> 	tglx
