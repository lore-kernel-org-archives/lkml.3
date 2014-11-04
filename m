Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaKDTd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:33:57 -0500
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:52365 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751223AbaKDTd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:33:56 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3872:4321:5007:6261:10004:10400:10848:11026:11658:11914:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: suit84_5c2ad63268626
X-Filterd-Recvd-Size: 1641
Message-ID: <1415129631.23168.3.camel@perches.com>
Subject: Re: [PATCH 1/1 net-next] esp4: remove assignment in if condition
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Date: Tue, 04 Nov 2014 11:33:51 -0800
In-Reply-To: <1415129311-12480-1-git-send-email-fabf@skynet.be>
References: <1415129311-12480-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 20:28 +0100, Fabian Frederick wrote:

trivia:

> diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
[]
> @@ -392,8 +392,11 @@ static int esp_input(struct xfrm_state *x, struct sk_buff *skb)
>  	if (elen <= 0)
>  		goto out;
>  
> -	if ((err = skb_cow_data(skb, 0, &trailer)) < 0)
> +	err = skb_cow_data(skb, 0, &trailer);
> +
> +	if (err < 0)
>  		goto out;

Generally it's better/more common to use

	foo = bar();
	if (!foo)
		[error_handler...]
	
without the blank line between the set
and the test.

