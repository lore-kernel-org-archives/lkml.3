Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaCFPEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:04:36 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47237 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaCFPEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:04:34 -0500
Message-ID: <1394118272.27473.36.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] net: use raw_cpu ops in snmp stats bh
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Mar 2014 07:04:32 -0800
In-Reply-To: <1394117074.27473.29.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1394110536-4532-1-git-send-email-sergey.senozhatsky@gmail.com>
	 <1394117074.27473.29.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 06:44 -0800, Eric Dumazet wrote:

> I think you missed a lot of mails sent by Chrisoph Lameter recently...

s/Chrisoph/Christoph/

Appropriate fix would be the following one, please submit this formally.


Fixes: f19c29e3e391 ("tcp: snmp stats for Fast Open, SYN rtx, and data pkts")

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5286228679bd..df063a32a177 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -87,7 +87,7 @@ static void tcp_event_new_data_sent(struct sock *sk, const struct sk_buff *skb)
 		tcp_rearm_rto(sk);
 	}
 
-	NET_ADD_STATS_BH(sock_net(sk), LINUX_MIB_TCPORIGDATASENT,
+	NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPORIGDATASENT,
 			 tcp_skb_pcount(skb));
 }
 


