Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3LLO3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:29:41 -0500
Received: from multi.imgtec.com ([194.200.65.239]:8477 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab3LLO3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:29:38 -0500
From: Qais Yousef <Qais.Yousef@imgtec.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Yang Yingliang <yangyingliang@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: RE: [PATCH] net/sched/sch_tbf.c: fix linking error
Thread-Topic: [PATCH] net/sched/sch_tbf.c: fix linking error
Thread-Index: AQHO9zck2dE04dBQo0atJfoWgkVHfZpQm5SAgAAC88A=
Date: Thu, 12 Dec 2013 14:29:35 +0000
Message-ID: <392C4BDEFF12D14FA57A3F30B283D7D13C8A24@LEMAIL01.le.imgtec.org>
References: <1386851936-1582-1-git-send-email-qais.yousef@imgtec.com>
 <1386857899.19078.49.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1386857899.19078.49.camel@edumazet-glaptop2.roam.corp.google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.154.35]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-SEF-Processed: 7_3_0_01192__2013_12_12_14_29_37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBCETl9S001354

> -----Original Message-----
> From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
> Sent: 12 December 2013 14:18
> To: Qais Yousef
> Cc: Yang Yingliang; Eric Dumazet; Jamal Hadi Salim; David S. Miller;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> next@vger.kernel.org
> Subject: Re: [PATCH] net/sched/sch_tbf.c: fix linking error
> 
> On Thu, 2013-12-12 at 12:38 +0000, Qais Yousef wrote:
> > ERROR: "__udivdi3" [net/sched/sch_tbf.ko] undefined!
> >
> > introduced by: cc106e441a63 (net: sched: tbf: fix the calculation of
> > max_size)
> >
> > which adds a 64 by 32 bit division without using do_div().
> > Fix it by using do_div(len/ 53) instead of len/53.
> >
> > Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: netdev@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-next@vger.kernel.org
> > ---
> > We caught this error on linux-next today. This is my quick attemp of a fix.
> > If it's not appropriate or doesn't make sense my apologies and feel
> > free to resend a better fix :)
> >
> >  net/sched/sch_tbf.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c index
> > a44928c..771cbec 100644
> > --- a/net/sched/sch_tbf.c
> > +++ b/net/sched/sch_tbf.c
> > @@ -131,8 +131,10 @@ static u64 psched_ns_t2l(const struct
> > psched_ratecfg *r,
> >
> >  	do_div(len, NSEC_PER_SEC);
> >
> > -	if (unlikely(r->linklayer == TC_LINKLAYER_ATM))
> > -		len = (len / 53) * 48;
> > +	if (unlikely(r->linklayer == TC_LINKLAYER_ATM)) {
> > +		do_div(len, 53);
> > +		len *= 48;
> > +	}
> >
> >  	if (len > r->overhead)
> >  		len -= r->overhead;
> 
> This looks like this was already fixed yesterday in David net tree :
> 
> http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=d55d282e6
> af88120ad90e93a88f70e3116dc0e3d
> 

Ah, ok. Thanks for checking this and sorry about the noise.

Qais

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
