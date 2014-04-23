Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaDWC11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:27:27 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:51063
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750860AbaDWC10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:27:26 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] clocksource: fix clocksource_mmio_readX_down
Thread-Topic: [PATCH] clocksource: fix clocksource_mmio_readX_down
Thread-Index: AQHPWiVQpW+42AWBq0+3FzJmFl9tAZsddoYAgAEK5OA=
Date: Wed, 23 Apr 2014 02:27:22 +0000
Message-ID: <2f174001f11b4e1b89558cb170973875@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1397726874-6349-1-git-send-email-Li.Xiubo@freescale.com>
 <535643FA.1080908@linaro.org>
In-Reply-To: <535643FA.1080908@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01901B3451
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(164054003)(51704005)(79102001)(15395725003)(33646001)(92566001)(85852003)(74662001)(74502001)(20776003)(77982001)(31966008)(66066001)(86362001)(50986999)(83072002)(575784001)(81342001)(76176999)(81542001)(99286001)(19580395003)(80976001)(2656002)(87936001)(46102001)(80022001)(74316001)(83322001)(76576001)(4396001)(76482001)(54356999)(99396002)(77096999)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:FCD0FA00.8CE25CEC.45412E03.83EAEC38.201B1;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3N2RWg1014950

> > diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
> > index c0e2512..f17a0d1 100644
> > --- a/drivers/clocksource/mmio.c
> > +++ b/drivers/clocksource/mmio.c
> > @@ -27,7 +27,7 @@ cycle_t clocksource_mmio_readl_up(struct clocksource *c)
> >
> >   cycle_t clocksource_mmio_readl_down(struct clocksource *c)
> >   {
> > -	return ~readl_relaxed(to_mmio_clksrc(c)->reg);
> > +	return ~readl_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
> >   }
> >
> >   cycle_t clocksource_mmio_readw_up(struct clocksource *c)
> > @@ -37,7 +37,7 @@ cycle_t clocksource_mmio_readw_up(struct clocksource *c)
> >
> >   cycle_t clocksource_mmio_readw_down(struct clocksource *c)
> >   {
> > -	return ~(unsigned)readw_relaxed(to_mmio_clksrc(c)->reg);
> > +	return ~(unsigned)readw_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
> >   }
> >
> >   /**
> 
> 
> Hi,
> 
> I realize there is some type confusion here:
> 
> cycle_t -> u64
> readl_relaxed -> u32
> readw_relaxed -> u16
> 
> and clocksource_mmio_readw_down returns a cast to unsigned (u32)
> 
> This patch makes sense but it obfuscate more the types in these
> functions. Worth to clarify the functions first ?
> 

Yes, though the short type could be converted to the longer type automatically,
It's better and worth to clarify it firstly.

I'll fix this, please see the next version.


Thanks,
BRs
Xiubo


> 
> --
>   <http://www.linaro.org/> Linaro.org â”‚ Open source software for ARM SoCs
> 
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
