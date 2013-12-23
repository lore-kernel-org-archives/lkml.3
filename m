Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab3LWI71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:59:27 -0500
Received: from smtprelay0066.hostedemail.com ([216.40.44.66]:38040 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751190Ab3LWI70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:59:26 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 48,2.914,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:418:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:4321:5007:7652:10004:10400:10481:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:19900,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brake01_17d8921e7dd29
X-Filterd-Recvd-Size: 1763
Message-ID: <1387789163.22671.62.camel@joe-AO722>
Subject: Re: [PATCH 09/21] batman-adv: slight optimization of addr compare
From: Joe Perches <joe@perches.com>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        "David S. Miller" <davem@davemloft.net>,
        b.a.t.m.a.n@lists.open-mesh.org, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 Dec 2013 00:59:23 -0800
In-Reply-To: <52B7F853.8050806@meshcoding.com>
References: <52B7C5C5.2050304@huawei.com> <52B7F853.8050806@meshcoding.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 09:46 +0100, Antonio Quartulli wrote:
> On 23/12/13 06:10, Ding Tianhong wrote:
> 
> [...]
> 
> > --- a/net/batman-adv/originator.c
> > +++ b/net/batman-adv/originator.c
> > @@ -41,7 +41,7 @@ int batadv_compare_orig(const struct hlist_node *node, const void *data2)
> >  	const void *data1 = container_of(node, struct batadv_orig_node,
> >  					 hash_entry);
> >  
> > -	return (memcmp(data1, data2, ETH_ALEN) == 0 ? 1 : 0);
> > +	return ether_addr_equal_unaligned(data1, data2) ? 1 : 0;
> 
> ether_addr_equal_unaligned() returns a bool value which is implicitly
> converted to 1 or 0: there is no need for the ternary if anymore.

Should these use batadv_compare_eth?


