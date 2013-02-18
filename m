Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3BRU3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 15:29:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab3BRU3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 15:29:43 -0500
From: Andrew Jones <drjones@redhat.com>
To: xen-devel@lists.xensource.com, ian.campbell@citrix.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xen: netback: remove redundant xenvif_put
Date: Mon, 18 Feb 2013 21:29:20 +0100
Message-Id: <1361219360-29176-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netbk_fatal_tx_err() calls xenvif_carrier_off(), which does
a xenvif_put(). As callers of netbk_fatal_tx_err should only
have one reference to the vif at this time, then the xenvif_put
in netbk_fatal_tx_err is one too many.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 drivers/net/xen-netback/netback.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 2b9520c..c23b9ec 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -893,7 +893,6 @@ static void netbk_fatal_tx_err(struct xenvif *vif)
 {
 	netdev_err(vif->dev, "fatal error; disabling device\n");
 	xenvif_carrier_off(vif);
-	xenvif_put(vif);
 }
 
 static int netbk_count_requests(struct xenvif *vif,
-- 
1.8.1.2

