Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaELBo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:44:29 -0400
Received: from 1wt.eu ([62.212.114.60]:34794 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639AbaELBo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:44:26 -0400
Message-Id: <20140512003203.045770545@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 058/143] arcnet: cleanup sizeof parameter
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 087d273caf4f7d3f2159256f255f1f432bc84a5b ]

This patch doesn't change the compiled code because ARC_HDR_SIZE is 4
and sizeof(int) is 4, but the intent was to use the header size and not
the sizeof the header size.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/arcnet/arcnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index 75a5725..e29940d 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -1008,7 +1008,7 @@ static void arcnet_rx(struct net_device *dev, int bufnum)
 
 	soft = &pkt.soft.rfc1201;
 
-	lp->hw.copy_from_card(dev, bufnum, 0, &pkt, sizeof(ARC_HDR_SIZE));
+	lp->hw.copy_from_card(dev, bufnum, 0, &pkt, ARC_HDR_SIZE);
 	if (pkt.hard.offset[0]) {
 		ofs = pkt.hard.offset[0];
 		length = 256 - ofs;
-- 
1.7.12.2.21.g234cd45.dirty



