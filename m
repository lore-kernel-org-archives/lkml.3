Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab3L1G7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 01:59:18 -0500
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:59523 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751004Ab3L1G7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 01:59:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:2915:3138:3139:3140:3141:3142:3622:3866:3867:3871:4250:4321:5007:7652:10004:10400:10481:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357:19900,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: maid11_8b0216cb9d628
X-Filterd-Recvd-Size: 1501
Message-ID: <1388213953.24123.2.camel@joe-AO722>
Subject: Re: [PATCH net-next v2 20/20] net: caif: slight optimization of
 addr compare
From: Joe Perches <joe@perches.com>
To: Ding Tianhong <dingtianhong@huawei.com>,
        Sjur =?ISO-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 27 Dec 2013 22:59:13 -0800
In-Reply-To: <52BE6D50.9000308@huawei.com>
References: <52BE6D50.9000308@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-28 at 14:18 +0800, Ding Tianhong wrote:
> Use possibly more efficient ether_addr_equal
> to instead of memcmp.

This may be a distinction without difference, but
is a CAIF seghead also an ethernet address?

> diff --git a/net/caif/cfrfml.c b/net/caif/cfrfml.c
[]
> @@ -79,7 +79,7 @@ static struct cfpkt *rfm_append(struct cfrfml *rfml, char *seghead,
[]
>  	/* Verify correct header */
> -	if (memcmp(seghead, rfml->seghead, 6) != 0)
> +	if (!ether_addr_equal(seghead, rfml->seghead))


