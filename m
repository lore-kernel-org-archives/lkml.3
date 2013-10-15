Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486Ab3JOR3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:29:55 -0400
Received: from smtprelay0072.hostedemail.com ([216.40.44.72]:44631 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933262Ab3JOR3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:29:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3866:3867:3872:4250:4321:5007:6119:7652:8660:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13148:13230:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: eyes11_1be354db6492c
X-Filterd-Recvd-Size: 1517
Message-ID: <1381858190.22110.25.camel@joe-AO722>
Subject: Re: [PATCH] X.25: Fix address field length calculation
From: Joe Perches <joe@perches.com>
To: "Kelleter," =?ISO-8859-1?Q?G=FCnther?= <GKelleter@datus.com>
Cc: "andrew.hendry@gmail.com" <andrew.hendry@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Oct 2013 10:29:50 -0700
In-Reply-To: <525D5131.9070007@datus.com>
References: <525D5131.9070007@datus.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 14:29 +0000, Kelleter, Günther wrote:
> Addresses are BCD encoded, not ASCII. x25_addr_ntoa got it right.
[]
> Wrong length calculation leads to rejection of CALL ACCEPT packets.
[]
> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
[]
> @@ -98,7 +98,7 @@ int x25_parse_address_block(struct sk_buff *skb,
>  	}
>   	len = *skb->data;
> -	needed = 1 + (len >> 4) + (len & 0x0f);
> +	needed = 1 + ((len >> 4) + (len & 0x0f) + 1) / 2;

This calculation looks odd.
Perhaps use bcd.h instead?


