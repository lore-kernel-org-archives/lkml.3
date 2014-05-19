Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbaESJMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:12:37 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:37540
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750890AbaESJMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:12:35 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 1/2] clocksource: fix type confusion for
 clocksource_mmio_readX_Y
Thread-Topic: [PATCHv2 1/2] clocksource: fix type confusion for
 clocksource_mmio_readX_Y
Thread-Index: AQHPXp+EEHZ9UXv4rUWfmoNIjU+5FJtHV7sggABvF4CAAACUwA==
Date: Mon, 19 May 2014 09:12:14 +0000
Message-ID: <2d73fa0de73443608ee272bc7685108d@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1398219120-23029-1-git-send-email-Li.Xiubo@freescale.com>
 <7dd1dc731dd24e15a170ef95aeee2a2e@BY2PR03MB505.namprd03.prod.outlook.com>
 <5379CA47.4020900@linaro.org>
In-Reply-To: <5379CA47.4020900@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(479174003)(377454003)(189002)(199002)(164054003)(51704005)(13464003)(24454002)(77096999)(575784001)(101416001)(86362001)(50986999)(74316001)(54356999)(15395725003)(81542001)(33646001)(76176999)(19580395003)(76576001)(4396001)(99396002)(77982001)(99286001)(2201001)(92566001)(21056001)(74502001)(83072002)(76482001)(79102001)(74662001)(31966008)(81342001)(20776003)(2656002)(87936001)(66066001)(80022001)(64706001)(83322001)(46102001)(19580405001)(85852003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4J9ChdQ001891

> Subject: Re: [PATCHv2 1/2] clocksource: fix type confusion for
> clocksource_mmio_readX_Y
> 
> On 05/19/2014 04:35 AM, Li.Xiubo@freescale.com wrote:
> > Hi,
> >
> > I'd like to know the status about this patch series...
> > :£©
> 
> I think the patches are ok. I have them in my queue for 3.16.
> 

That's nice.

Thanks,

BRs
Xiubo

> >> -----Original Message-----
> >> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> >> Sent: Wednesday, April 23, 2014 10:12 AM
> >> To: daniel.lezcano@linaro.org; tglx@linutronix.de; linux-
> >> kernel@vger.kernel.org
> >> Cc: Xiubo Li-B47053
> >> Subject: [PATCHv2 1/2] clocksource: fix type confusion for
> >> clocksource_mmio_readX_Y
> >>
> >> The types' definations are:
> >>     o  cycle_t       -> u64
> >>     o  readl_relaxed -> u32
> >>     o  readw_relaxed -> u16
> >>
> >> So let clocksource_mmio_readX_Ys return a cast to cycle_t, though
> >> this maybe look reduntant sometimes, it make sense and they will be
> >> more readable and less confusion...
> >>
> >> This patch clarifies the functions type and fix it.
> >>
> >> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> >> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> >> ---
> >>   drivers/clocksource/mmio.c | 8 ++++----
> >>   1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
> >> index c0e2512..19a6b3f 100644
> >> --- a/drivers/clocksource/mmio.c
> >> +++ b/drivers/clocksource/mmio.c
> >> @@ -22,22 +22,22 @@ static inline struct clocksource_mmio
> >> *to_mmio_clksrc(struct clocksource *c)
> >>
> >>   cycle_t clocksource_mmio_readl_up(struct clocksource *c)
> >>   {
> >> -	return readl_relaxed(to_mmio_clksrc(c)->reg);
> >> +	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
> >>   }
> >>
> >>   cycle_t clocksource_mmio_readl_down(struct clocksource *c)
> >>   {
> >> -	return ~readl_relaxed(to_mmio_clksrc(c)->reg);
> >> +	return ~(cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
> >>   }
> >>
> >>   cycle_t clocksource_mmio_readw_up(struct clocksource *c)
> >>   {
> >> -	return readw_relaxed(to_mmio_clksrc(c)->reg);
> >> +	return (cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
> >>   }
> >>
> >>   cycle_t clocksource_mmio_readw_down(struct clocksource *c)
> >>   {
> >> -	return ~(unsigned)readw_relaxed(to_mmio_clksrc(c)->reg);
> >> +	return ~(cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
> >>   }
> >>
> >>   /**
> >> --
> >> 1.8.4
> >
> 
> 
> --
>  <http://www.linaro.org/> Linaro.org ©¦ Open source software for ARM SoCs
> 
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
