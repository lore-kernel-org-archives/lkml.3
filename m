Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaC1XAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 19:00:05 -0400
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:50205 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751116AbaC1XAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 19:00:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:3874:4250:4321:4605:5007:7652:10004:10400:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ducks92_5759953a7320e
X-Filterd-Recvd-Size: 1935
Message-ID: <1396047598.31134.37.camel@joe-AO722>
Subject: Re: Staging:et131x: change memcpy()  ether_addr_copy()
From: Joe Perches <joe@perches.com>
To: paulmcquad <paulmcquad@gmail.com>
Cc: gregkh@linuxfoundation.org, gamerh2o@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>
Date: Fri, 28 Mar 2014 15:59:58 -0700
In-Reply-To: <5335F74A.9020507@gmail.com>
References: <5335F74A.9020507@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 22:27 +0000, paulmcquad wrote:
> replace memcpy() with ether_addr_copy()
> make checkpatch.pl clean

broken.

You at least need to change this definition:
drivers/staging/et131x/et131x.c:        static const u8 default_mac[] = { 0x00, 0x05, 0x3d, 0x00, 0x02, 0x00 };
and add __aligned(2) to it to make sure
that the address is appropriately aligned.

> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
[]
> @@ -3770,7 +3770,7 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
[]
>      /* Set the MAC address to a default */
> -    memcpy(adapter->addr, default_mac, ETH_ALEN);
> +    ether_addr_copy(adapter->addr, default_mac, ETH_ALEN);
[]
> @@ -4337,7 +4337,7 @@ static void et131x_multicast(struct net_device *netdev)
>      netdev_for_each_mc_addr(ha, netdev) {
>          if (i == NIC_MAX_MCAST_LIST)
>              break;
> -        memcpy(adapter->multicast_list[i++], ha->addr, ETH_ALEN);
> +    ether_addr_copy(adapter->multicast_list[i++], ha->addr, ETH_ALEN);

bad indentation too


