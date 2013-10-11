Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab3JKTlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:41:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab3JKTlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sonic Zhang <sonic.zhang@analog.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 017/135] netpoll: Should handle ETH_P_ARP other than ETH_P_IP in netpoll_neigh_reply
Date: Fri, 11 Oct 2013 12:38:18 -0700
Message-Id: <20131011193947.105848297@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonic Zhang <sonic.zhang@analog.com>

[ Upstream commit b0dd663b60944a3ce86430fa35549fb37968bda0 ]

The received ARP request type in the Ethernet packet head is ETH_P_ARP other than ETH_P_IP.

[ Bug introduced by commit b7394d2429c198b1da3d46ac39192e891029ec0f
  ("netpoll: prepare for ipv6") ]

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -550,7 +550,7 @@ static void netpoll_neigh_reply(struct s
 		return;
 
 	proto = ntohs(eth_hdr(skb)->h_proto);
-	if (proto == ETH_P_IP) {
+	if (proto == ETH_P_ARP) {
 		struct arphdr *arp;
 		unsigned char *arp_ptr;
 		/* No arp on this interface */


