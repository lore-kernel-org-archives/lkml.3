Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030356Ab3HICEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:04:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030218Ab3HIB7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 087/102] arcnet: cleanup sizeof parameter
Date: Thu,  8 Aug 2013 18:58:03 -0700
Message-Id: <20130809015030.816426767@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 087d273caf4f7d3f2159256f255f1f432bc84a5b ]

This patch doesn't change the compiled code because ARC_HDR_SIZE is 4
and sizeof(int) is 4, but the intent was to use the header size and not
the sizeof the header size.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/arcnet/arcnet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -1007,7 +1007,7 @@ static void arcnet_rx(struct net_device
 
 	soft = &pkt.soft.rfc1201;
 
-	lp->hw.copy_from_card(dev, bufnum, 0, &pkt, sizeof(ARC_HDR_SIZE));
+	lp->hw.copy_from_card(dev, bufnum, 0, &pkt, ARC_HDR_SIZE);
 	if (pkt.hard.offset[0]) {
 		ofs = pkt.hard.offset[0];
 		length = 256 - ofs;


