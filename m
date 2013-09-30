Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab3I3KMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:12:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43565 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab3I3KMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jones <davej@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 047/104] 8139cp: Fix skb leak in rx_status_loop failure path.
Date: Mon, 30 Sep 2013 11:10:24 +0100
Message-Id: <1380535881-9239-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

commit d06f5187469eee1b2932c02fd093d113cfc60d5e upstream.

Introduced in cf3c4c03060b688cbc389ebc5065ebcce5653e96
("8139cp: Add dma_mapping_error checking")

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/realtek/8139cp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index bf8eb57..efd3e34 100644
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
1.8.3.2

