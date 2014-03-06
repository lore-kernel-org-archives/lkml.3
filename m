Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaCFDSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 22:18:36 -0500
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:34695
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752185AbaCFDSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 22:18:35 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>, Stefan Agner <stefan@agner.ch>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] clocksource: vf_pit_timer: use complement for
 sched_clock reading
Thread-Topic: [PATCH] clocksource: vf_pit_timer: use complement for
 sched_clock reading
Thread-Index: AQHPON3HUpK7HJWWQ0yawbcrDHe6WprTYsKA
Date: Thu, 6 Mar 2014 03:18:14 +0000
Message-ID: <a821b61811ff4861b577ee17ff9f0448@BL2PR03MB467.namprd03.prod.outlook.com>
References: <d25af915993aec1b486be653eb86f748ddef54fe.1394057313.git.stefan@agner.ch>
 <20140306014530.GA11366@S2101-09.ap.freescale.net>
In-Reply-To: <20140306014530.GA11366@S2101-09.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(199002)(189002)(377454003)(24454002)(51704005)(77982001)(74876001)(63696002)(54356001)(76576001)(93516002)(56816005)(76482001)(33646001)(53806001)(79102001)(74706001)(46102001)(66066001)(65816001)(59766001)(69226001)(95666003)(86362001)(90146001)(76786001)(51856001)(54316002)(81342001)(81542001)(94946001)(19580395003)(4396001)(87266001)(2656002)(83322001)(19580405001)(74366001)(47976001)(95416001)(49866001)(47736001)(85306002)(83072002)(81686001)(74316001)(85852003)(74502001)(94316002)(80976001)(81816001)(50986001)(93136001)(76796001)(47446002)(80022001)(31966008)(87936001)(92566001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB403;H:BL2PR03MB467.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:7AED5140.AEF3AEEA.E2F93FA3.88D6BA3B.20290;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s263JHDG022339



> -----Original Message-----
> From: Shawn Guo [mailto:shawn.guo@linaro.org]
> Sent: Thursday, March 06, 2014 9:46 AM
> To: Stefan Agner
> Cc: daniel.lezcano@linaro.org; tglx@linutronix.de; linux@arm.linux.org.uk;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Lu
> Jingchang-B35083
> Subject: Re: [PATCH] clocksource: vf_pit_timer: use complement for
> sched_clock reading
> 
> On Wed, Mar 05, 2014 at 11:11:08PM +0100, Stefan Agner wrote:
> > Vybrids PIT register is monitonic decreasing. However, sched_clock
> > reading needs to be monitonic increasing. Use bitwise not to get the
> > complement of the clock register. This fixes the clock going backward.
> > Also, the clock now starts at 0 since we load the register with the
> > maximum value at start.
> >
> > Signed-off-by: Stefan Agner <stefan@agner.ch>
> 
> Looks correct to me, so
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> 
> But I also copied the driver author Jingchang to see if he has any
> comment.
> 
> Shawn
> 
The fix is correct, thanks.

Best Regards,
Jingchang

> > ---
> >  drivers/clocksource/vf_pit_timer.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/clocksource/vf_pit_timer.c
> > b/drivers/clocksource/vf_pit_timer.c
> > index 02821b0..a918bc4 100644
> > --- a/drivers/clocksource/vf_pit_timer.c
> > +++ b/drivers/clocksource/vf_pit_timer.c
> > @@ -54,7 +54,7 @@ static inline void pit_irq_acknowledge(void)
> >
> >  static u64 pit_read_sched_clock(void)  {
> > -	return __raw_readl(clksrc_base + PITCVAL);
> > +	return ~__raw_readl(clksrc_base + PITCVAL);
> >  }
> >
> >  static int __init pit_clocksource_init(unsigned long rate)
> > --
> > 1.9.0
> >

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
