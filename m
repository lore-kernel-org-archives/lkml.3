Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664AbaEFBvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:51:53 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:50196 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507AbaEFBvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:51:51 -0400
MIME-Version: 1.0
In-Reply-To: <5367BB2D.4080907@candelatech.com>
References: <1399015092-28643-1-git-send-email-zhouzhouyi@gmail.com>
	<20140502151921.014fbeec@redhat.com>
	<5363A4E0.2000403@intel.com>
	<20140505171252.49773a5a@redhat.com>
	<5367BB2D.4080907@candelatech.com>
Date: Tue, 6 May 2014 09:51:50 +0800
Message-ID: <CAABZP2wXOweBKG6aENBPNHCs5sJZgzDZ7-L-xv2eL8cABGS26g@mail.gmail.com>
Subject: Re: [PATCH] netdev: pktgen xmit packet through vlan interface
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        David Miller <davem@davemloft.net>, steffen.klassert@secunet.com,
        fan.du@windriver.com, dborkman@redhat.com,
        Mathias Krause <minipli@googlemail.com>, tgraf@suug.ch,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You could just force pktgen to not support multi-skb on vlan interfaces?
>
> I thought we went through this a year or two ago and came up with
> something like a 'pktgen-challenged' network interface flag?

Ah yes,  IFF_TX_SKB_SHARING does the job, very sorry for missing that,
 as matter of fact, I have
tailed pktgen model for my personal use.

By the way, would skb_clone save the CPU cycles for
memset(skb_put(skb, datalen), 0, datalen) thing ? especially for
Jesper's qdisc test scenery.





>
> Thanks,
> Ben
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
