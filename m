Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaBJFrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 00:47:08 -0500
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:58981 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750797AbaBJFrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 00:47:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3151:3622:3867:3868:4321:5007:7652:10004:10400:10848:11658:11914:12043:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boot30_2065931207254
X-Filterd-Recvd-Size: 1547
Message-ID: <1392011221.3178.18.camel@joe-AO722>
Subject: Re: [PATCH] USB2NET : SR9800 : One chip USB2.0 USB2NET SR9800
 Device Driver Support
From: Joe Perches <joe@perches.com>
To: liujunliang_ljl@163.com
Cc: davem@davemloft.net, horms@verge.net.au, romieu@fr.zoreil.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sunhecheng@vip.126.com
Date: Sun, 09 Feb 2014 21:47:01 -0800
In-Reply-To: <1392010419-5217-1-git-send-email-liujunliang_ljl@163.com>
References: <1392010419-5217-1-git-send-email-liujunliang_ljl@163.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 13:33 +0800, liujunliang_ljl@163.com wrote:
> diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
[]
> +	netdev_dbg(dev->net, "mac addr : 0x%x:0x%x:0x%x:0x%x:0x%x:0x%x\n",
> +		   dev->net->dev_addr[0], dev->net->dev_addr[1],
> +		   dev->net->dev_addr[2], dev->net->dev_addr[3],
> +		   dev->net->dev_addr[4], dev->net->dev_addr[5]);

mac addresses are assumed to be hex and don't need 0x prefixes.
Also, there's a kernel vsprintf extension "%pM" for mac addresses.

	netdev_dbg(dev->net, "mac addr: %pM\n", dev->net->dev_addr);


