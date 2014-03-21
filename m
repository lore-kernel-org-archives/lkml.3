Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966483AbaCUAnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:43:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965829AbaCUAIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 23/85] mwifiex: add NULL check for PCIe Rx skb
Date: Thu, 20 Mar 2014 17:09:26 -0700
Message-Id: <20140321000601.915342969@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit bb8e6a1ee881d131e404f0f1f5e8dc9281002771 upstream.

We may get a NULL pointer here if skb allocation for Rx packet
was failed earlier.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/pcie.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1195,6 +1195,12 @@ static int mwifiex_pcie_process_recv_dat
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


