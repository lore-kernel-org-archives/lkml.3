Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3CZRj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:39:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30328 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3CZRge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:34 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=VYTfRPD44rIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=fplUzVOZNGgA:10 a=1XWaLZrsAAAA:8 a=QyXUC8HyAAAA:8 a=J1Y8HTJGAAAA:8 a=ayC55rCoAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=UTB_XpHje0EA:10 a=dGJ0OcVc7YAA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173609.800328331@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 62/86] macvlan: fix macvlan_get_size()
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0062-macvlan-fix-macvlan_get_size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ee19a438d8f4f7ff5a9469a2f30bba7bb15f00ec ]

commit df8ef8f3aaa (macvlan: add FDB bridge ops and macvlan flags)
forgot to update macvlan_get_size() after the addition of
IFLA_MACVLAN_FLAGS

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/macvlan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index ea2c5d4..666fc20 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -823,7 +823,10 @@ static int macvlan_changelink(struct net_device *dev,
 
 static size_t macvlan_get_size(const struct net_device *dev)
 {
-	return nla_total_size(4);
+	return (0
+		+ nla_total_size(4) /* IFLA_MACVLAN_MODE */
+		+ nla_total_size(2) /* IFLA_MACVLAN_FLAGS */
+		);
 }
 
 static int macvlan_fill_info(struct sk_buff *skb,
-- 
1.7.10.4


