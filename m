Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbaFQTeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:34:36 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:53145 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756291AbaFQTef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:34:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQJAPOXoFNbsl1t/2dsb2JhbABagw2rKgUBAQEBAQEFAZkmgQ4XdYRgI4EaN4hGAcs+F4VjiRMdhC0EmkOLMIgogX6BRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Ariel Elior <ariele@broadcom.com>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1] drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c: remove null test before kfree
Date: Tue, 17 Jun 2014 21:32:53 +0200
Message-Id: <1403033573-7754-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Ariel Elior <ariele@broadcom.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index eda8583..c9988e3 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -597,8 +597,7 @@ int bnx2x_vf_mcast(struct bnx2x *bp, struct bnx2x_virtf *vf,
 	rc = bnx2x_config_mcast(bp, &mcast, BNX2X_MCAST_CMD_DEL);
 	if (rc) {
 		BNX2X_ERR("Failed to remove multicasts\n");
-		if (mc)
-			kfree(mc);
+		kfree(mc);
 		return rc;
 	}
 
-- 
1.8.4.5

