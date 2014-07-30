Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaG3M5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:57:11 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:49341 "EHLO cstnet.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754355AbaG3M5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:57:08 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jul 2014 08:57:07 EDT
Date: Wed, 30 Jul 2014 20:49:21 +0800 (GMT+08:00)
From: "Zhouyi Zhou" <yizhouzhou@ict.ac.cn>
To: "Dmitry Popov" <ixaphire@qrator.net>
Cc: "Zhouyi Zhou" <zhouzhouyi@gmail.com>, rdunlap@infradead.org,
        davem@davemloft.net, minipli@googlemail.com, brouer@redhat.com,
        steffen.klassert@secunet.com, fan.du@windriver.com,
        dborkman@redhat.com, fengguang.wu@intel.com, tgraf@suug.ch,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <151385e.14b46.14787515b85.Coremail.yizhouzhou@ict.ac.cn>
In-Reply-To: <20140730145119.c2c31dabf1a4f7012522fa95@qrator.net>
References: <1406708486-23427-1-git-send-email-zhouzhouyi@gmail.com>
 <20140730145119.c2c31dabf1a4f7012522fa95@qrator.net>
Subject: Re: Re: [PATCH net-next] pktgen: add ttl option for pktgen
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [106.38.204.57]
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT2.1.10 dev build
 20131120(24194.5778.5783) Copyright (c) 2002-2014 www.mailtech.cn cstnet
X-SendMailWithSms: false
X-CM-CTRLDATA: rq2nw2Zvb3Rlcl90eHQ9MTMwNjo2
X-CM-TRANSID: SwCowJCLjuvS6dhT76YHAA--.36674W
X-CM-SenderInfo: x1l2x05x2k03g6lf3hldfou0/
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW5Jw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reviewing.
I did miss it.
> -----Original Messages-----
> From: "Dmitry Popov" <ixaphire@qrator.net>
> Sent Time: Wednesday, July 30, 2014
> To: "Zhouyi Zhou" <zhouzhouyi@gmail.com>
> Cc: rdunlap@infradead.org, davem@davemloft.net, minipli@googlemail.com, brouer@redhat.com, steffen.klassert@secunet.com, fan.du@windriver.com, dborkman@redhat.com, fengguang.wu@intel.com, tgraf@suug.ch, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, "Zhouyi Zhou" <yizhouzhou@ict.ac.cn>
> Subject: Re: [PATCH net-next] pktgen: add ttl option for pktgen
> 
> On Wed, 30 Jul 2014 16:21:26 +0800
> Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
> 
> > I think it is useful to add ttl option for pktgen, for example
> > if a some ISP want to test its network quality, it could set 
> > ttl so that the tested links get the packet while end users won't
> > get it. 
> 
> It seems you're missing 
> 
> --- a/net/core/pktgen.c
> +++ b/net/core/pktgen.c
> @@ -2799,7 +2799,7 @@ static struct sk_buff *fill_packet_ipv4(struct net_device *odev,
> 
>     iph->ihl = 5;
>     iph->version = 4;
> -   iph->ttl = 32;
> +   iph->ttl = pkt_dev->ttl;
>     iph->tos = pkt_dev->tos;
>     iph->protocol = IPPROTO_UDP;    /* UDP */
>     iph->saddr = pkt_dev->cur_saddr;




