Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3LPNfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:35:09 -0500
Received: from multi.imgtec.com ([194.200.65.239]:32845 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab3LPNfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:35:07 -0500
From: Qais Yousef <Qais.Yousef@imgtec.com>
To: Yang Yingliang <yangyingliang@huawei.com>
CC: Eric Dumazet <edumazet@google.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: RE: [PATCH] net/sched/sch_tbf.c: fix linking error
Thread-Topic: [PATCH] net/sched/sch_tbf.c: fix linking error
Thread-Index: AQHO+mKET3d6+tCAN0Cy0Rcg6kuBEZpW0iYA
Date: Mon, 16 Dec 2013 13:34:57 +0000
Message-ID: <392C4BDEFF12D14FA57A3F30B283D7D13C994E@LEMAIL01.le.imgtec.org>
References: <1386851356-1395-1-git-send-email-qais.yousef@imgtec.com>
In-Reply-To: <1386851356-1395-1-git-send-email-qais.yousef@imgtec.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.154.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-SEF-Processed: 7_3_0_01192__2013_12_16_13_34_59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the noise. I'm not sure how this got sent out again. I definitely didn't type any git send-email commands at all today :-/

Qais

> -----Original Message-----
> From: Qais Yousef [mailto:qais.yousef@imgtec.com]
> Sent: 12 December 2013 12:29
> To: Yang Yingliang
> Cc: Qais Yousef; Eric Dumazet; Jamal Hadi Salim; David S. Miller;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> next@vger.kernel.org
> Subject: [PATCH] net/sched/sch_tbf.c: fix linking error
> 
> ERROR: "__udivdi3" [net/sched/sch_tbf.ko] undefined!
> 
> introduced by: cc106e441a63 (net: sched: tbf: fix the calculation of max_size)
> 
> which adds a 64 by 32 bit division without using do_div().
> Fix it by using do_div(len/ 53) instead of len/53.
> 
> Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-next@vger.kernel.org
> ---
> We caught this error on linux-next today. This is my quick attemp of a fix.
> If it's not appropriate or doesn't make sense my apologies and feel free to resend
> a better fix :)
> 
>  net/sched/sch_tbf.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c index a44928c..771cbec
> 100644
> --- a/net/sched/sch_tbf.c
> +++ b/net/sched/sch_tbf.c
> @@ -131,8 +131,10 @@ static u64 psched_ns_t2l(const struct psched_ratecfg *r,
> 
>  	do_div(len, NSEC_PER_SEC);
> 
> -	if (unlikely(r->linklayer == TC_LINKLAYER_ATM))
> -		len = (len / 53) * 48;
> +	if (unlikely(r->linklayer == TC_LINKLAYER_ATM)) {
> +		do_div(len, 53);
> +		len *= 48;
> +	}
> 
>  	if (len > r->overhead)
>  		len -= r->overhead;
> --
> 1.7.1


