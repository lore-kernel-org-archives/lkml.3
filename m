Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab3LLQ4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:56:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24814 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3LLQyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:54:44 -0500
From: vegard.nossum@oracle.com
To: linux-kernel@vger.kernel.org
Cc: Vegard Nossum <vegard.nossum@oracle.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/9] net: Known exploit detection for CVE-2012-2136
Date: Thu, 12 Dec 2013 17:52:27 +0100
Message-Id: <1386867152-24072-4-git-send-email-vegard.nossum@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

See cc9b17ad29ecaa20bfe426a8d4dbfb94b13ff1cc.

Cc: Jason Wang <jasowang@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 net/core/sock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 0b39e7a..c16246f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -117,6 +117,7 @@
 #include <linux/static_key.h>
 #include <linux/memcontrol.h>
 #include <linux/prefetch.h>
+#include <linux/exploit.h>
 
 #include <asm/uaccess.h>
 
@@ -1753,8 +1754,10 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 	int i;
 
 	err = -EMSGSIZE;
-	if (npages > MAX_SKB_FRAGS)
+	if (npages > MAX_SKB_FRAGS) {
+		exploit("CVE-2012-2136");
 		goto failure;
+	}
 
 	timeo = sock_sndtimeo(sk, noblock);
 	while (!skb) {
-- 
1.7.10.4

