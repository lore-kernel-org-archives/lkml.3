Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab3IHDTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55964 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941Ab3IHDSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:34 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dan Carpenter" <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.140874885@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [008/121] arcnet: cleanup sizeof parameter
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 087d273caf4f7d3f2159256f255f1f432bc84a5b ]

This patch doesn't change the compiled code because ARC_HDR_SIZE is 4
and sizeof(int) is 4, but the intent was to use the header size and not
the sizeof the header size.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/arcnet/arcnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index a746ba2..a956053 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -1007,7 +1007,7 @@ static void arcnet_rx(struct net_device *dev, int bufnum)
 
 	soft = &pkt.soft.rfc1201;
 
-	lp->hw.copy_from_card(dev, bufnum, 0, &pkt, sizeof(ARC_HDR_SIZE));
+	lp->hw.copy_from_card(dev, bufnum, 0, &pkt, ARC_HDR_SIZE);
 	if (pkt.hard.offset[0]) {
 		ofs = pkt.hard.offset[0];
 		length = 256 - ofs;

