Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3J2VYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:24:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41926 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3J2VYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:24:21 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: thomas.petazzoni@free-electrons.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] mvneta: remove double validation of mac address
Date: Tue, 29 Oct 2013 22:25:06 +0100
Message-Id: <1383081906-12342-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mac address validity is already checked in of_get_mac_address().
No need to do it twice.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e35bac7..7d99e695 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2811,7 +2811,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	}
 
 	dt_mac_addr = of_get_mac_address(dn);
-	if (dt_mac_addr && is_valid_ether_addr(dt_mac_addr)) {
+	if (dt_mac_addr) {
 		mac_from = "device tree";
 		memcpy(dev->dev_addr, dt_mac_addr, ETH_ALEN);
 	} else {
-- 
1.8.4.rc3

