Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbaIDIx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:53:59 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:25982
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756263AbaIDIx5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:53:57 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource read
 API.
Thread-Topic: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource
 read API.
Thread-Index: AQHPwPGfS8nkeT6FCkuUDVIJ9Bh425vvRJOAgAD90OCAAHITAIAAANvggAACDoCAAADZcA==
Date: Thu, 4 Sep 2014 08:53:35 +0000
Message-ID: <711bc48a692a420589ff4b5ad48d6b4c@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
 <1409031951-39021-3-git-send-email-Li.Xiubo@freescale.com>
 <alpine.DEB.2.10.1409031236450.3333@nanos>
 <c5f60fc57cdf4cd3a01b8d3a87a4f3de@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <alpine.DEB.2.10.1409041032200.3333@nanos>
 <69c4ca3ee1324a3894a6d5dc0bde38ed@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <alpine.DEB.2.10.1409041044350.3333@nanos>
In-Reply-To: <alpine.DEB.2.10.1409041044350.3333@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(199003)(164054003)(189002)(86362001)(20776003)(99286002)(95666004)(2656002)(93886004)(101416001)(80022001)(87936001)(76482001)(92566001)(79102001)(66066001)(64706001)(21056001)(85852003)(81542001)(83072002)(76176999)(85306004)(76576001)(74316001)(108616004)(77982001)(74662001)(46102001)(83322001)(81342001)(54356999)(4396001)(31966008)(99396002)(107046002)(90102001)(106116001)(106356001)(105586002)(74502001)(77096002)(50986999)(33646002)(110136001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB179;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> > > > Since the FTM will be in BE mode on LS1 platform, but will be in LE mode
> > > > On LS2 platform.
> > > >
> > > > And ftm_clocksource_read_up() will adapt to this different.
> > >
> > > You are missing the point. Why do you want a conditional in a hot
> > > path? You know at init time whether the thing is BE or LE, so you can
> > > have separate functions for BE/LE or whatever and register that with
> > > clocksource_mmio_init(). i.e.

For our LS1 and LS2+ platforms, there will be only one Kernel Image and can work
for both of them with different dtbs.

Thanks,

BRs
Xiubo
