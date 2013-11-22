Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab3KVO5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:57:47 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:40017 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab3KVO5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:57:45 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH 4/5] net: MOXA ART: generate random address
Date: Fri, 22 Nov 2013 15:57:21 +0100
Message-Id: <1385132242-3204-4-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1385132242-3204-1-git-send-email-jonas.jensen@gmail.com>
References: <1385132242-3204-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address register is zero:ed on boot, fill it with a randomly generated
address on probe.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20131122

 drivers/net/ethernet/moxa/moxart_ether.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 08c3905..c02075a 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -700,6 +700,12 @@ static int moxart_mac_probe(struct platform_device *pdev)
 		goto init_fail;
 	}
 
+	if (!is_valid_ether_addr(ndev->dev_addr)) {
+		eth_hw_addr_random(ndev);
+		netdev_info(ndev, "generated random MAC address %pM\n",
+			    ndev->dev_addr);
+	}
+
 	netdev_dbg(ndev, "%s: IRQ=%d address=%pM\n",
 		   __func__, ndev->irq, ndev->dev_addr);
 
-- 
1.8.2.1

