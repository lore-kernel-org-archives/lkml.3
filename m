Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3A2HVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:21:52 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33763 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3A2HVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:21:47 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r0T7Lbut004026
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 3/6] MFD:rtsx: Declare that the DMA address limitation is 32bit explicitly
Date: Tue, 29 Jan 2013 15:21:34 +0800
Message-ID: <dd36f54a34a3fa4667da6a58b72669bdfa97cf5c.1359443488.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1359443487.git.wei_wang@realsil.com.cn>
References: <cover.1359443487.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Realtek PCIe card reader only supports 32bit DMA.
This declaration can improve the readability

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rtsx_pcr.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index c021ce3..b2cfd2e 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1029,6 +1029,10 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 		pci_name(pcidev), (int)pcidev->vendor, (int)pcidev->device,
 		(int)pcidev->revision);
 
+	ret = pci_set_dma_mask(pcidev, DMA_BIT_MASK(32));
+	if (ret < 0)
+		return ret;
+
 	ret = pci_enable_device(pcidev);
 	if (ret)
 		return ret;
-- 
1.7.9.5

