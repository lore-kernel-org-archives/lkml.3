Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaJQTkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 15:40:53 -0400
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:35930 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753538AbaJQTkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 15:40:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3871:3873:3874:4321:5007:6261:10011:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12679:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: mice47_7baf3b8912b50
X-Filterd-Recvd-Size: 1581
Message-ID: <1413574848.14629.6.camel@perches.com>
Subject: Re: [PATCH] staging: octeon: Replace memcpy with ETH_ALEN
From: Joe Perches <joe@perches.com>
To: Balavasu <kp.balavasu@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 17 Oct 2014 12:40:48 -0700
In-Reply-To: <20141017184705.GA17944@vasu-Inspiron-3542>
References: <20141017184705.GA17944@vasu-Inspiron-3542>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-18 at 00:17 +0530, Balavasu wrote:
> This patch fixes the checkpatch.pl issue
> WARNING: memcpy(dev->dev_addr, mac, ETH_ALEN);

That is not the actual warning.

This is the warning:

Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)

How have you made sure that mac can not have odd alignment?

Make sure your commit message shows how you know
that mac is appropriately aligned.

> diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
[]
> @@ -452,7 +452,7 @@ int cvm_oct_common_init(struct net_device *dev)
>  		mac = of_get_mac_address(priv->of_node);
>  
>  	if (mac)
> -		memcpy(dev->dev_addr, mac, ETH_ALEN);
> +		ether_addr_copy(dev->dev_addr, mac);
>  	else
>  		eth_hw_addr_random(dev);
>  


