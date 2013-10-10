Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab3JJQKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:10:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52586 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab3JJPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jones <davej@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 012/104] 8139cp: Fix skb leak in rx_status_loop failure path.
Date: Thu, 10 Oct 2013 08:41:00 -0700
Message-Id: <1381419752-29733-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

[ Upstream commit d06f5187469eee1b2932c02fd093d113cfc60d5e ]

Introduced in cf3c4c03060b688cbc389ebc5065ebcce5653e96
("8139cp: Add dma_mapping_error checking")

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/realtek/8139cp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 9af14e0..35014cf 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -524,6 +524,7 @@ rx_status_loop:
 					 PCI_DMA_FROMDEVICE);
 		if (dma_mapping_error(&cp->pdev->dev, new_mapping)) {
 			dev->stats.rx_dropped++;
+			kfree_skb(new_skb);
 			goto rx_next;
 		}
 
-- 
1.8.1.2

