Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaKFLwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:52:44 -0500
Received: from antispam.ahnlab.com ([210.121.169.55]:57445 "EHLO
	antispam.ahnlab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaKFLwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:52:41 -0500
X-Original-SENDERIP: 172.16.11.209
X-Original-MAILFROM: suhyun.park@ahnlab.com
From: =?utf-8?B?67CV7IiY7ZiE?= <suhyun.park@ahnlab.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] bridge: missing null bridge device check causing null
 pointer dereference (bugfix)
Thread-Topic: [PATCH] bridge: missing null bridge device check causing null
 pointer dereference (bugfix)
Thread-Index: AQHP+YqrhNePGBbJkEOg7Nz1l90pj5xSlqaAgACjdfD//6digIAAmgCg
Date: Thu, 6 Nov 2014 11:52:33 +0000
Message-ID: <8D1F1238A24CE743B8F3CED0F137C69E408AA143@EXMB02.ahnbang.ahnlab.com>
References: <1415255192-13584-1-git-send-email-suhyun.park@ahnlab.com>
	 <545B1E27.3080302@lab.ntt.co.jp>
	 <8D1F1238A24CE743B8F3CED0F137C69E408AA087@EXMB02.ahnbang.ahnlab.com>
 <1415273711.13896.67.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1415273711.13896.67.camel@edumazet-glaptop2.roam.corp.google.com>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.20.32.26]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA6BqnKx002537

My appologies,

I was working on kernel 3.2.30 when I hit the crash. I only looked at the up-to-date kernel for br_handle_frame function where I still found "p->state" reference.

Please disregard my patch.

Thanks,
Su-Hyun Park

-----Original Message-----
From: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
Sent: Thursday, November 06, 2014 8:35 PM
To: ë°•ìˆ˜í˜„
Cc: Toshiaki Makita; Stephen Hemminger; David S. Miller; bridge@lists.linux-foundation.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bridge: missing null bridge device check causing null pointer dereference (bugfix)

On Thu, 2014-11-06 at 07:58 +0000, ë°•ìˆ˜í˜„ wrote:
> >-----Original Message-----
> >From: Toshiaki Makita [mailto:makita.toshiaki@lab.ntt.co.jp]
> >Sent: Thursday, November 06, 2014 4:07 PM
> >To: ë°•ìˆ˜í˜„; Stephen Hemminger; David S. Miller
> >Cc: bridge@lists.linux-foundation.org; netdev@vger.kernel.org; linux- 
> >kernel@vger.kernel.org
> >Subject: Re: [PATCH] bridge: missing null bridge device check causing 
> >null pointer dereference (bugfix)
> >
> >On 2014/11/06 15:26, Su-Hyun Park wrote:
> >> the bridge device can be null if the bridge is being deleted while 
> >> processing the packet, which causes the null pointer dereference in
> >switch statement.
> >
> >How can this happen??
> >It is guarded by rcu.
> >netdev_rx_handler_unregister() ensures rx_handler_data is non NULL.
> >
> 
> The RCU protect rx_handler_data, not the bridge member port. It can be NULL according to below code.
> 

Where do you find this 'below code' ?

Are you sending a patch for an old linux kernel ?

> static inline struct net_bridge_port *br_port_get_rcu(const struct net_device *dev) {
> 	struct net_bridge_port *port = rcu_dereference(dev->rx_handler_data);
> 	return br_port_exists(dev) ? port : NULL; }

Actual code is :

static inline struct net_bridge_port *br_port_get_rcu(const struct net_device *dev) {
	return rcu_dereference(dev->rx_handler_data);
}


> 
> The crash happens at the below switch statement in br_handle_frame, where p is NULL.
> 
> 	switch (p->state)

Is your tree really including the fix we already did to fix this issue ?

(commit 716ec052d2280d511e10e90ad54a86f5b5d4dcc2 )
bridge: fix NULL pointer deref of br_port_get_rcu




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
