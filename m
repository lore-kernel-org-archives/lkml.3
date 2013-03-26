Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab3CZRxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:53:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30914 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab3CZRgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:16 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=tRuT-7b7cUYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Pdy-OG1zu8cA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173608.441405020@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Paul Moore <pmoore@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 53/86] netlabel: correctly list all the static label mappings
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0053-netlabel-correctly-list-all-the-static-label-mapping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

[ Upstream commit 0c1233aba1e948c37f6dc7620cb7c253fcd71ce9 ]

When we have a large number of static label mappings that spill across
the netlink message boundary we fail to properly save our state in the
netlink_callback struct which causes us to repeat the same listings.
This patch fixes this problem by saving the state correctly between
calls to the NetLabel static label netlink "dumpit" routines.

Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/netlabel/netlabel_unlabeled.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index c39d63c..7fe20d0 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1248,10 +1248,10 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 
 unlabel_staticlist_return:
 	rcu_read_unlock();
-	cb->args[0] = skip_bkt;
-	cb->args[1] = skip_chain;
-	cb->args[2] = skip_addr4;
-	cb->args[3] = skip_addr6;
+	cb->args[0] = iter_bkt;
+	cb->args[1] = iter_chain;
+	cb->args[2] = iter_addr4;
+	cb->args[3] = iter_addr6;
 	return skb->len;
 }
 
@@ -1315,8 +1315,8 @@ static int netlbl_unlabel_staticlistdef(struct sk_buff *skb,
 
 unlabel_staticlistdef_return:
 	rcu_read_unlock();
-	cb->args[0] = skip_addr4;
-	cb->args[1] = skip_addr6;
+	cb->args[0] = iter_addr4;
+	cb->args[1] = iter_addr6;
 	return skb->len;
 }
 
-- 
1.7.10.4


