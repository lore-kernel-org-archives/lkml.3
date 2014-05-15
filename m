Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbaEODpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 23:45:51 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:65226
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbaEODou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 23:44:50 -0400
X-IronPort-AV: E=Sophos;i="4.97,1056,1389740400"; 
   d="scan'208";a="61911942"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] net/ariadne: delete unneeded call to netdev_priv
Date: Thu, 15 May 2014 05:43:19 +0200
Message-Id: <1400125401-15512-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Netdev_priv is an accessor function, and has no purpose if its result is
not used.

A simplified version of the semantic match that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@ local idexpression x; @@
-x = netdev_priv(...);
... when != x
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/ethernet/amd/ariadne.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/ariadne.c b/drivers/net/ethernet/amd/ariadne.c
index b08101b..968b7bf 100644
--- a/drivers/net/ethernet/amd/ariadne.c
+++ b/drivers/net/ethernet/amd/ariadne.c
@@ -718,7 +718,6 @@ static int ariadne_init_one(struct zorro_dev *z,
 	unsigned long mem_start = board + ARIADNE_RAM;
 	struct resource *r1, *r2;
 	struct net_device *dev;
-	struct ariadne_private *priv;
 	u32 serial;
 	int err;
 
@@ -738,8 +737,6 @@ static int ariadne_init_one(struct zorro_dev *z,
 		return -ENOMEM;
 	}
 
-	priv = netdev_priv(dev);
-
 	r1->name = dev->name;
 	r2->name = dev->name;
 

