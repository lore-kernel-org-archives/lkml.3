Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3J2V1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:27:12 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61783 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3J2V1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:27:10 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: davem@davemloft.net
Cc: jiri@resnulli.us, david.daney@cavium.com, wfp5p@virginia.edu,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH 1/2] octeon_mgmt: remove double validation of mac address
Date: Tue, 29 Oct 2013 22:27:33 +0100
Message-Id: <1383082053-12405-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mac address validity is already checked in of_get_mac_address().
No need to do it twice.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/net/ethernet/octeon/octeon_mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/octeon/octeon_mgmt.c b/drivers/net/ethernet/octeon/octeon_mgmt.c
index 622aa75..1b326cbc 100644
--- a/drivers/net/ethernet/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/octeon/octeon_mgmt.c
@@ -1545,7 +1545,7 @@ static int octeon_mgmt_probe(struct platform_device *pdev)
 
 	mac = of_get_mac_address(pdev->dev.of_node);
 
-	if (mac && is_valid_ether_addr(mac))
+	if (mac)
 		memcpy(netdev->dev_addr, mac, ETH_ALEN);
 	else
 		eth_hw_addr_random(netdev);
-- 
1.8.4.rc3

