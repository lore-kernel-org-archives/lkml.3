Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854Ab3LIJZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:25:48 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:42315 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760715Ab3LIJZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:25:46 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v2] dma: fix vchan_cookie_complete() debug print
Date: Mon,  9 Dec 2013 10:25:23 +0100
Message-Id: <1386581123-4706-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1386344529-25617-1-git-send-email-jonas.jensen@gmail.com>
References: <1386344529-25617-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vchan_cookie_complete() is supposed to print the cookie value
but it's always zero because:

dma_cookie_complete() is called prior to dev_vdbg()

Move the call, place it after dev_vdbg().

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Changes since v1:
    
    1. remove local dma_cookie_t
    2. call dma_cookie_complete() after dev_vdbg()
    
    Applies to next-20131209

 drivers/dma/virt-dma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/virt-dma.h b/drivers/dma/virt-dma.h
index 85c19d6..7d6f611 100644
--- a/drivers/dma/virt-dma.h
+++ b/drivers/dma/virt-dma.h
@@ -85,9 +85,9 @@ static inline void vchan_cookie_complete(struct virt_dma_desc *vd)
 {
 	struct virt_dma_chan *vc = to_virt_chan(vd->tx.chan);
 
-	dma_cookie_complete(&vd->tx);
 	dev_vdbg(vc->chan.device->dev, "txd %p[%x]: marked complete\n",
 		vd, vd->tx.cookie);
+	dma_cookie_complete(&vd->tx);
 	list_add_tail(&vd->node, &vc->desc_completed);
 
 	tasklet_schedule(&vc->task);
-- 
1.8.2.1

