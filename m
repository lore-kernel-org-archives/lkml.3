Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3LFPmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:42:32 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:56018 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3LFPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:42:31 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] dma: fix vchan_cookie_complete() debug print
Date: Fri,  6 Dec 2013 16:42:09 +0100
Message-Id: <1386344529-25617-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vd->tx.cookie is set zero on dma_cookie_complete(),
save to local before printing it.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    dev_vdbg() could also be moved to happen earlier, what do you prefer?
    
    Applies to next-20131206

 drivers/dma/virt-dma.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/virt-dma.h b/drivers/dma/virt-dma.h
index 85c19d6..181b9526 100644
--- a/drivers/dma/virt-dma.h
+++ b/drivers/dma/virt-dma.h
@@ -84,10 +84,12 @@ static inline bool vchan_issue_pending(struct virt_dma_chan *vc)
 static inline void vchan_cookie_complete(struct virt_dma_desc *vd)
 {
 	struct virt_dma_chan *vc = to_virt_chan(vd->tx.chan);
+	dma_cookie_t cookie;
 
+	cookie = vd->tx.cookie;
 	dma_cookie_complete(&vd->tx);
 	dev_vdbg(vc->chan.device->dev, "txd %p[%x]: marked complete\n",
-		vd, vd->tx.cookie);
+		 vd, cookie);
 	list_add_tail(&vd->node, &vc->desc_completed);
 
 	tasklet_schedule(&vc->task);
-- 
1.8.2.1

