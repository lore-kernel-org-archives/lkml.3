Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3LXQfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 11:35:54 -0500
Received: from smtprelay0106.hostedemail.com ([216.40.44.106]:36755 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751992Ab3LXQfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 11:35:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3872:4321:4605:5007:7652:10004:10400:10481:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:19900,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chin99_8a4e03fd7273f
X-Filterd-Recvd-Size: 1704
Message-ID: <1387902949.2259.51.camel@joe-AO722>
Subject: Re: [PATCH v2 06/20] ppp: slight optimization of addr compare
From: Joe Perches <joe@perches.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        Michal Ostrowski <mostrows@earthlink.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 24 Dec 2013 08:35:49 -0800
In-Reply-To: <52B9B559.2060400@cogentembedded.com>
References: <52B96FCD.50901@huawei.com>
	 <52B9B559.2060400@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-24 at 20:24 +0400, Sergei Shtylyov wrote:
> On 24-12-2013 15:28, Ding Tianhong wrote:
[]
> > diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
[]
> > @@ -131,12 +131,13 @@ static inline struct pppoe_net *pppoe_pernet(struct net *net)
> >
> >   static inline int cmp_2_addr(struct pppoe_addr *a, struct pppoe_addr *b)
> >   {
> > -	return a->sid == b->sid && !memcmp(a->remote, b->remote, ETH_ALEN);
> > +	return a->sid == b->sid && ether_addr_equal(a->remote,
> > +							      b->remote);
> 
>     If it really doesn't fit insto single line, the continuation line should 
> start right under 'a->remote'.

Better still might be

	return a->sid == b->sid &&
	       ether_addr_equal(a->remote, b->remote);


