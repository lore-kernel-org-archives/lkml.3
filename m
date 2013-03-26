Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3CZRjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:39:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14679 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3CZRge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:34 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=NgB44fdfOmIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=XVnt0ABApGQA:10 a=mK_AVkanAAAA:8 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=9xyTavCNlvEA:10 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173609.502355290@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 60/86] mac802154: fix NOHZ local_softirq_pending 08 warning
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0060-mac802154-fix-NOHZ-local_softirq_pending-08-warning.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alexander Aring <alex.aring@googlemail.com>

[ Upstream commit 386de15c3f62bf100b4e162c0a859785d2d58661 ]

When using nanosleep() in an userspace application we get a
ratelimit warning

NOHZ: local_softirq_pending 08

for 10 times.

This patch replaces netif_rx() with netif_rx_ni() which has
to be used from process/softirq context.
The process/softirq context will be called from fakelb driver.

See linux-kernel commit 481a819 for similar fix.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/mac802154/wpan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/wpan.c b/net/mac802154/wpan.c
index f30f6d4..c5e24c8 100644
--- a/net/mac802154/wpan.c
+++ b/net/mac802154/wpan.c
@@ -387,7 +387,7 @@ void mac802154_wpan_setup(struct net_device *dev)
 
 static int mac802154_process_data(struct net_device *dev, struct sk_buff *skb)
 {
-	return netif_rx(skb);
+	return netif_rx_ni(skb);
 }
 
 static int
-- 
1.7.10.4


