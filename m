Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaIKCck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 22:32:40 -0400
Received: from mail-bn1on0117.outbound.protection.outlook.com ([157.56.110.117]:37529
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752653AbaIKCcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 22:32:39 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] clocksource: Add BE/LE APIs support for clocksource
 counter reading.
Thread-Topic: [PATCH] clocksource: Add BE/LE APIs support for clocksource
 counter reading.
Thread-Index: AQHPzNie08S/y2/oUkWUrtlv0NcLvJv6018AgABbseA=
Date: Thu, 11 Sep 2014 02:32:35 +0000
Message-ID: <07a36481c1d64505a5c8957021d400e0@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1410340819-35110-1-git-send-email-Li.Xiubo@freescale.com>
 <alpine.DEB.2.10.1409102212530.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409102212530.4178@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(24454002)(164054003)(199003)(189002)(85306004)(66066001)(21056001)(80022001)(76482001)(4396001)(77982001)(79102001)(46102001)(20776003)(64706001)(2656002)(92566001)(19580395003)(83322001)(19580405001)(101416001)(85852003)(83072002)(87936001)(99396002)(81342001)(81542001)(76176999)(54356999)(50986999)(97736003)(86362001)(95666004)(99286002)(76576001)(31966008)(74662001)(74502001)(77096002)(105586002)(106116001)(108616004)(33646002)(106356001)(107046002)(90102001)(74316001)(110136001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0616;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Cc: daniel.lezcano@linaro.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] clocksource: Add BE/LE APIs support for clocksource
> counter reading.
> 
> On Wed, 10 Sep 2014, Xiubo Li wrote:
> 
> So you add BE/LE APIs according to the subject line, but you fail
> again to tell WHY. If that would be the only issue ....
> 
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  drivers/clocksource/mmio.c | 44
> ++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> >
> > diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
> > index 1593ade..ddc5214 100644
> > --- a/drivers/clocksource/mmio.c
> > +++ b/drivers/clocksource/mmio.c
> 
> So you think that adding this to mmio.c is the solution to the
> problem?
> 

It's just one solution of this, and will be a little faster than the old one
When reading the counter value.


> Ever heard about function prototypes, header files and such?
> 

Yes, this will be fixed later if this is acceptable.

> > @@ -20,21 +20,65 @@ static inline struct clocksource_mmio
> *to_mmio_clksrc(struct clocksource *c)
> >  	return container_of(c, struct clocksource_mmio, clksrc);
> >  }
> >
> > +cycle_t clocksource_mmio_readl_up_be(struct clocksource *c)
> > +{
> > +	return (cycle_t)be32_to_cpu(readl_relaxed(to_mmio_clksrc(c)->reg));
> > +}
> > +
> > +cycle_t clocksource_mmio_readl_up_le(struct clocksource *c)
> > +{
> > +	return (cycle_t)le32_to_cpu(readl_relaxed(to_mmio_clksrc(c)->reg));
> > +}
> > +
> >  cycle_t clocksource_mmio_readl_up(struct clocksource *c)
> >  {
> >  	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
> >  }
> 
> So now we have three global functions which provide access to the mmio
> clocksource. And one of them is always redundant for a given compile
> time endianess. You can't be serious about this...
> 
 
Yes, any good suggestion about this ?

I found whatever the method it is about the endianness will always be many
Different voices from different people and found it hard to taste all of them. 

So firstly I just using the driver's local APIs.

Thanks,

BRs
Xiubo
