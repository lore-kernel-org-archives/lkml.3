Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaG3Kv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:51:27 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:40901 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaG3KvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:51:24 -0400
Date: Wed, 30 Jul 2014 14:51:19 +0400
From: Dmitry Popov <ixaphire@qrator.net>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: <rdunlap@infradead.org>, <davem@davemloft.net>, <minipli@googlemail.com>,
        <brouer@redhat.com>, <steffen.klassert@secunet.com>,
        <fan.du@windriver.com>, <dborkman@redhat.com>,
        <fengguang.wu@intel.com>, <tgraf@suug.ch>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH net-next] pktgen: add ttl option for pktgen
Message-Id: <20140730145119.c2c31dabf1a4f7012522fa95@qrator.net>
In-Reply-To: <1406708486-23427-1-git-send-email-zhouzhouyi@gmail.com>
References: <1406708486-23427-1-git-send-email-zhouzhouyi@gmail.com>
X-Mailer: Sylpheed 3.4.2 (GTK+ 2.24.24; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2014 16:21:26 +0800
Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:

> I think it is useful to add ttl option for pktgen, for example
> if a some ISP want to test its network quality, it could set 
> ttl so that the tested links get the packet while end users won't
> get it. 

It seems you're missing 

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2799,7 +2799,7 @@ static struct sk_buff *fill_packet_ipv4(struct net_device *odev,

    iph->ihl = 5;
    iph->version = 4;
-   iph->ttl = 32;
+   iph->ttl = pkt_dev->ttl;
    iph->tos = pkt_dev->tos;
    iph->protocol = IPPROTO_UDP;    /* UDP */
    iph->saddr = pkt_dev->cur_saddr;
