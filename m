Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab3LXMjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 07:39:05 -0500
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:49522 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751017Ab3LXMjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 07:39:03 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3873:4321:4362:5007:7652:10004:10400:10481:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13071:13095:13311:13357:19900:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drop32_6bd0449792527
X-Filterd-Recvd-Size: 1455
Message-ID: <1387888739.2259.7.camel@joe-AO722>
Subject: Re: [PATCH v2 03/20] net: pcnet: slight optimization of addr compare
From: Joe Perches <joe@perches.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: Don Fry <pcnet32@frontier.com>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 24 Dec 2013 04:38:59 -0800
In-Reply-To: <52B96FA7.10201@huawei.com>
References: <52B96FA7.10201@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-24 at 19:27 +0800, Ding Tianhong wrote:
> Use possibly more efficient ether_addr_equal_unaligned
> to instead of memcmp.

Hi again Ding.

> diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
[]
> @@ -1668,7 +1668,7 @@ pcnet32_probe1(unsigned long ioaddr, int shared, struct pci_dev *pdev)
[]
> -	if (memcmp(promaddr, dev->dev_addr, ETH_ALEN) ||
> +	if (!ether_addr_equal(promaddr, dev->dev_addr) ||

Can you please make sure the commit message matches the
code changes?

This uses ether_addr_equal not ether_addr_equal_unaligned.

Thanks for the work.

