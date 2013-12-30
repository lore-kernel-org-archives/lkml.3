Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab3L3GFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 01:05:32 -0500
Received: from smtprelay0252.hostedemail.com ([216.40.44.252]:55096 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751311Ab3L3GF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 01:05:29 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2692:2828:3138:3139:3140:3141:3142:3350:3622:3865:3868:3871:3873:3874:4250:4321:5007:7652:10004:10400:10481:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13076:13311:13357:19900,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sound45_4caaccbc68529
X-Filterd-Recvd-Size: 1770
Message-ID: <1388383526.26796.21.camel@joe-AO722>
Subject: Re: [PATCH net-next v2 11/20] net: packetengines: slight
 optimization of addr
From: Joe Perches <joe@perches.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: Ding Tianhong <dthxman@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 29 Dec 2013 22:05:26 -0800
In-Reply-To: <52C0DCF7.6040402@huawei.com>
References: <52BE6D0D.9050301@huawei.com>
	 <52BED8ED.2040908@cogentembedded.com> <52BEEBD5.1040301@gmail.com>
	 <1388251380.24123.15.camel@joe-AO722> <52C0DCF7.6040402@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-30 at 10:39 +0800, Ding Tianhong wrote:
> I don't understand packetengine NIC anymore, But I think the change is clearly,
> as your said, the broadcast check is enough here, did you mean that?
> 
> 	!is_broadcast_ether_addr((u8 *)(le32_to_cpu(yp->rx_ring_dma) +
> 						    entry * sizeof(struct yellowfin_desc)))

Not quite.  I meant this could be:

		u8 *addr = (u8 *)(unsigned long)le32_to_cpu(yp->rx_ring_dma) +
							    entry * sizeof(struct yellowfin_desc);

		if (!ether_addr_equal(addr, dev->dev_addr) &&
		    !is_broadcast_ether_addr(addr)) {
			etc...

but again, I think thus hardly matters and could just as well
be left alone.


