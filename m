Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaIEF70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 01:59:26 -0400
Received: from mail-bn1bn0109.outbound.protection.outlook.com ([157.56.110.109]:54496
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750736AbaIEF7Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 01:59:25 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 01:59:24 EDT
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource read
 API.
Thread-Topic: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource
 read API.
Thread-Index: AQHPwPGfS8nkeT6FCkuUDVIJ9Bh425vvRJOAgAD90OCAAHITAIAAANvggAACDoCAAADZcIABYelQ
Date: Fri, 5 Sep 2014 05:59:20 +0000
Message-ID: <9f2ed85ee1bf4f6289d450fcdea7ccb6@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
 <1409031951-39021-3-git-send-email-Li.Xiubo@freescale.com>
 <alpine.DEB.2.10.1409031236450.3333@nanos>
 <c5f60fc57cdf4cd3a01b8d3a87a4f3de@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <alpine.DEB.2.10.1409041032200.3333@nanos>
 <69c4ca3ee1324a3894a6d5dc0bde38ed@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <alpine.DEB.2.10.1409041044350.3333@nanos> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0325F6C77B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019016)(6009001)(51704005)(164054003)(189002)(199003)(77982001)(86362001)(74316001)(105586002)(87936001)(101416001)(79102001)(90102001)(2656002)(80022001)(85852003)(66066001)(106356001)(20776003)(4396001)(81542001)(106116001)(107046002)(81342001)(95666004)(76576001)(76482001)(99286002)(54356999)(85306004)(93886004)(74502001)(74662001)(77096002)(108616004)(46102001)(83322001)(64706001)(76176999)(110136001)(50986999)(33646002)(99396002)(21056001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR03MB185;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> Subject: RE: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource read
> API.
> 
> Hi Thomas,
> 
> > > > > Since the FTM will be in BE mode on LS1 platform, but will be in LE
> mode
> > > > > On LS2 platform.
> > > > >
> > > > > And ftm_clocksource_read_up() will adapt to this different.
> > > >
> > > > You are missing the point. Why do you want a conditional in a hot
> > > > path? You know at init time whether the thing is BE or LE, so you can
> > > > have separate functions for BE/LE or whatever and register that with
> > > > clocksource_mmio_init(). i.e.
> 
> For our LS1 and LS2+ platforms, there will be only one Kernel Image and can
> work
> for both of them with different dtbs.
> 

Additional:

The LS1 CPUs and some DEVs are in LE endian mode, while most DEVs are in BE mode.
For LS2, CPUs and all DEVs are in LE endian mode.

So here we used one dt node property to distinguish this in run time.

Thanks,

BRs
Xiubo
