Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaIDBt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:49:29 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:25132
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756667AbaIDBt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:49:28 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource read
 API.
Thread-Topic: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource
 read API.
Thread-Index: AQHPwPGfS8nkeT6FCkuUDVIJ9Bh425vvRJOAgAD90OA=
Date: Thu, 4 Sep 2014 01:49:23 +0000
Message-ID: <c5f60fc57cdf4cd3a01b8d3a87a4f3de@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
 <1409031951-39021-3-git-send-email-Li.Xiubo@freescale.com>
 <alpine.DEB.2.10.1409031236450.3333@nanos>
In-Reply-To: <alpine.DEB.2.10.1409031236450.3333@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(24454002)(164054003)(189002)(199003)(86362001)(74316001)(2656002)(105586002)(92566001)(87936001)(77982001)(101416001)(90102001)(64706001)(80022001)(85852003)(66066001)(79102001)(83072002)(20776003)(76482001)(81542001)(107046002)(106116001)(106356001)(4396001)(76576001)(95666004)(81342001)(99286002)(54356999)(85306004)(74662001)(31966008)(74502001)(77096002)(108616004)(46102001)(83322001)(21056001)(76176999)(110136001)(99396002)(50986999)(33646002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB185;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource read
> API.
> 
> On Tue, 26 Aug 2014, Xiubo Li wrote:
> 
> > Since the Flextimer device will be implemented in BE mode on
> > LS1 SoC, and in LE mode on Vybrid, LS2 SoCs, so here we need
> > the endianness judgment before doing the mmio.
> 
> Brilliant. So for every clocksource read you take a conditional.
> 
> > @@ -238,7 +243,7 @@ static int __init ftm_clocksource_init(unsigned long
> freq)
> >  	sched_clock_register(ftm_read_sched_clock, 16, freq / (1 << priv->ps));
> >  	err = clocksource_mmio_init(priv->clksrc_base + FTM_CNT, "fsl-ftm",
> >  				    freq / (1 << priv->ps), 300, 16,
> > -				    clocksource_mmio_readl_up);
> > +				    ftm_clocksource_read_up);
> 
> What's wrong with having endianess aware clocksource_mmio functions
> and make the decision at init time?
> 

Since the FTM will be in BE mode on LS1 platform, but will be in LE mode
On LS2 platform.

And ftm_clocksource_read_up() will adapt to this different.

Thanks,

BRs
Xiubo
