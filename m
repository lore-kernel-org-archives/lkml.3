Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423173AbaDKQmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:42:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422824AbaDKQJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li RongQing <roy.qing.li@gmail.com>, WANG Cong <amwang@redhat.com>
Subject: [PATCH 3.13 39/65] netpoll: fix the skb check in pkt_is_ns
Date: Fri, 11 Apr 2014 09:11:11 -0700
Message-Id: <20140411161003.107768654@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Not applicable upstream commit, the code here has been removed
  upstream. ]

Neighbor Solicitation is ipv6 protocol, so we should check
skb->protocol with ETH_P_IPV6

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Cc: WANG Cong <amwang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -742,7 +742,7 @@ static bool pkt_is_ns(struct sk_buff *sk
 	struct nd_msg *msg;
 	struct ipv6hdr *hdr;
 
-	if (skb->protocol != htons(ETH_P_ARP))
+	if (skb->protocol != htons(ETH_P_IPV6))
 		return false;
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr) + sizeof(struct nd_msg)))
 		return false;


