Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaDALQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:16:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42100 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaDALQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 009/144] mwifiex: add NULL check for PCIe Rx skb
Date: Tue,  1 Apr 2014 12:13:33 +0100
Message-Id: <1396350948-29910-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit bb8e6a1ee881d131e404f0f1f5e8dc9281002771 upstream.

We may get a NULL pointer here if skb allocation for Rx packet
was failed earlier.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 20c9c4c..1662b99 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1195,6 +1195,12 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		rd_index = card->rxbd_rdptr & reg->rx_mask;
 		skb_data = card->rx_buf_list[rd_index];
 
+		/* If skb allocation was failed earlier for Rx packet,
+		 * rx_buf_list[rd_index] would have been left with a NULL.
+		 */
+		if (!skb_data)
+			return -ENOMEM;
+
 		MWIFIEX_SKB_PACB(skb_data, &buf_pa);
 		pci_unmap_single(card->dev, buf_pa, MWIFIEX_RX_DATA_BUF_SIZE,
 				 PCI_DMA_FROMDEVICE);
-- 
1.9.1

