Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaA1I7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:59:38 -0500
Received: from smtprelay0051.hostedemail.com ([216.40.44.51]:48671 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754653AbaA1I7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:59:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2729:2828:3138:3139:3140:3141:3142:3151:3352:3622:3867:3871:4225:4321:5007:6119:7576:7652:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13019:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coal96_536708074120e
X-Filterd-Recvd-Size: 2119
Message-ID: <1390899572.20150.97.camel@joe-AO722>
Subject: Re: [PATCH] USB2NET : SR9800 : One chip USB2.0 USB2NET SR9800
 Device Driver Support
From: Joe Perches <joe@perches.com>
To: liujunliang_ljl@163.com
Cc: davem@davemloft.net, horms@verge.net.au, romieu@fr.zoreil.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sunhecheng@vip.126.com
Date: Tue, 28 Jan 2014 00:59:32 -0800
In-Reply-To: <1390898200-9925-1-git-send-email-liujunliang_ljl@163.com>
References: <1390898200-9925-1-git-send-email-liujunliang_ljl@163.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 16:36 +0800, liujunliang_ljl@163.com wrote:
> From: Liu Junliang <liujunliang_ljl@163.com>

trivial comments...

> diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c

[]

> +static int sr_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
> +{
[]
> +		if (size != ((~header >> 16) & 0x07ff)) {
> +			netdev_err(dev->net,
> +				   "sr_rx_fixup() Bad Header Length\n");

printks with embedded functions names are
generally better using "%s: ", __func__

			netdev_err(dev->net, "%s: Bad header length\n",
				   __func__);

[]

> +			netdev_err(dev->net,
> +				   "sr_rx_fixup() Bad RX Length %d\n", size);

etc.

> +	if (skb->len != offset) {
> +		netdev_err(dev->net, "sr_rx_fixup() Bad SKB Length %d\n",
> +			   skb->len);

etc.

[]

> +static inline int sr9800_set_default_mode(struct usbnet *dev)
> +{

rather a big function to inline

[]

> +	if (ret < 0) {
> +		netdev_dbg(dev->net, "Write IPG,IPG1,IPG2 failed: %d", ret);

missing newline terminations

> +	netdev_dbg(dev->net, "RX_CTL is 0x%04x after all initializations",
> +		   rx_ctl);

etc...



