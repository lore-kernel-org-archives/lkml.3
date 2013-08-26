Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3HZWtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:49:13 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:53962 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3HZWpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:45:53 -0400
From: Rob Herring <robherring2@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andreas Herrmann <andreas.herrmann@calxeda.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 02/11] net: calxedaxgmac: read correct field in xgmac_desc_get_buf_len
Date: Mon, 26 Aug 2013 17:45:17 -0500
Message-Id: <1377557126-10716-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377557126-10716-1-git-send-email-robherring2@gmail.com>
References: <1377557126-10716-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

xgmac_desc_get_buf_len appears to have a copy/paste error. flags is the
wrong field to read. We should be reading buf_size field. cpu_to_le32
should also be le32_to_cpu. This never really mattered as this function
is only used for DMA mapping calls which happen to be nops with coherent
DMA.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/net/ethernet/calxeda/xgmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 71f6720..d41af68 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -421,7 +421,7 @@ static inline void desc_set_buf_len(struct xgmac_dma_desc *p, u32 buf_sz)
 
 static inline int desc_get_buf_len(struct xgmac_dma_desc *p)
 {
-	u32 len = cpu_to_le32(p->flags);
+	u32 len = le32_to_cpu(p->buf_size);
 	return (len & DESC_BUFFER1_SZ_MASK) +
 		((len & DESC_BUFFER2_SZ_MASK) >> DESC_BUFFER2_SZ_OFFSET);
 }
-- 
1.8.1.2

