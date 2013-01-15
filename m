Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3AOEnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:43:11 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56446 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3AOEnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:43:09 -0500
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harvey Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 1/1] net: ipv4: refine the logic for determining daddr in ip_queue_xmit.
Date: Tue, 15 Jan 2013 12:47:35 +0800
Message-Id: <1358225255-30973-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The destination address daddr is faddr if source route option is set, otherwise it is inet_daddr. So use if-else to assign the value.

Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>
---
 net/ipv4/ip_output.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 3e98ed2..22b738c 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -349,10 +349,10 @@ int ip_queue_xmit(struct sk_buff *skb, struct flowi *fl)
 		__be32 daddr;
 
 		/* Use correct destination address if we have options. */
-		daddr = inet->inet_daddr;
 		if (inet_opt && inet_opt->opt.srr)
 			daddr = inet_opt->opt.faddr;
-
+		else
+			daddr = inet->inet_daddr;
 		/* If this fails, retransmit mechanism of transport layer will
 		 * keep trying until route appears or the connection times
 		 * itself out.
-- 
1.7.1

