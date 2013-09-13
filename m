Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab3IMEKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 00:10:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42906 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751173Ab3IMEKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 00:10:15 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] net: ks8851-ml: remove deprecated IRQF_DISABLED
Date: Fri, 13 Sep 2013 06:10:10 +0200
Message-Id: <1379045410-6687-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from
drivers/net/ethernet/micrel/ks8851_mll.c

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/net/ethernet/micrel/ks8851_mll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index 0fba153..075f4e2 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -915,7 +915,7 @@ static int ks_net_open(struct net_device *netdev)
 	struct ks_net *ks = netdev_priv(netdev);
 	int err;
 
-#define	KS_INT_FLAGS	(IRQF_DISABLED|IRQF_TRIGGER_LOW)
+#define	KS_INT_FLAGS	IRQF_TRIGGER_LOW
 	/* lock the card, even if we may not actually do anything
 	 * else at the moment.
 	 */
-- 
1.8.1.2

