Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaEODou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 23:44:50 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:65226
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbaEODot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 23:44:49 -0400
X-IronPort-AV: E=Sophos;i="4.97,1056,1389740400"; 
   d="scan'208";a="61911941"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] drivers/net/wan: delete unneeded call to netdev_priv
Date: Thu, 15 May 2014 05:43:18 +0200
Message-Id: <1400125401-15512-1-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/net/wan/sdla.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wan/sdla.c b/drivers/net/wan/sdla.c
index de3bbf4..cdd45fb 100644
--- a/drivers/net/wan/sdla.c
+++ b/drivers/net/wan/sdla.c
@@ -1322,10 +1322,6 @@ NOTE:  This is rather a useless action right now, as the
 
 static int sdla_change_mtu(struct net_device *dev, int new_mtu)
 {
-	struct frad_local *flp;
-
-	flp = netdev_priv(dev);
-
 	if (netif_running(dev))
 		return -EBUSY;
 

