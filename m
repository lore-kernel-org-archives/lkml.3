Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3ILRpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:45:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab3ILRpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:45:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 09/23] 8139cp: Fix skb leak in rx_status_loop failure path.
Date: Thu, 12 Sep 2013 10:45:05 -0700
Message-Id: <20130912174452.766395545@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912174451.748805761@linuxfoundation.org>
References: <20130912174451.748805761@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

[ Upstream commit d06f5187469eee1b2932c02fd093d113cfc60d5e ]

Introduced in cf3c4c03060b688cbc389ebc5065ebcce5653e96
("8139cp: Add dma_mapping_error checking")

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/8139cp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -524,6 +524,7 @@ rx_status_loop:
 					 PCI_DMA_FROMDEVICE);
 		if (dma_mapping_error(&cp->pdev->dev, new_mapping)) {
 			dev->stats.rx_dropped++;
+			kfree_skb(new_skb);
 			goto rx_next;
 		}
 


