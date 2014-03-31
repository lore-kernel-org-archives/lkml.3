Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaCaPnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:43:51 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63361 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaCaPnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:43:49 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: netdev@vger.kernel.org, pablo@netfilter.org, kaber@trash.net,
        kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/5] netfilter: Fix format string mismatch in mangle_content_len()
Date: Tue,  1 Apr 2014 00:43:36 +0900
Message-Id: <1396280619-31152-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.1.352.gd393d14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix format string mismatch in mangle_connect_len()

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 net/netfilter/nf_nat_sip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index b4d691d..5f98845 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -434,7 +434,7 @@ static int mangle_content_len(struct sk_buff *skb, unsigned int protoff,
 			      &matchoff, &matchlen) <= 0)
 		return 0;
 
-	buflen = sprintf(buffer, "%u", c_len);
+	buflen = sprintf(buffer, "%d", c_len);
 	return mangle_packet(skb, protoff, dataoff, dptr, datalen,
 			     matchoff, matchlen, buffer, buflen);
 }
-- 
1.9.1.352.gd393d14

