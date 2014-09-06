Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaIFP2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 11:28:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52185 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaIFP1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 11:27:43 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/5] media: davinci: vpif_display: drop setting of vb2 buffer state to ACTIVE
Date: Sat,  6 Sep 2014 16:26:47 +0100
Message-Id: <1410017211-15438-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410017211-15438-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1410017211-15438-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch drops setting of vb2 buffer state to VB2_BUF_STATE_ACTIVE,
as any buffer queued to the driver is marked ACTIVE by the vb2 core.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 2ce3ddf..76f829d 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -196,8 +196,6 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	list_del(&common->cur_frm->list);
 	spin_unlock_irqrestore(&common->irqlock, flags);
-	/* Mark state of the current frame to active */
-	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
 
 	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
 	common->set_addr((addr + common->ytop_off),
@@ -306,8 +304,6 @@ static void process_progressive_mode(struct common_obj *common)
 	/* Remove that buffer from the buffer queue */
 	list_del(&common->next_frm->list);
 	spin_unlock(&common->irqlock);
-	/* Mark status of the buffer as active */
-	common->next_frm->vb.state = VB2_BUF_STATE_ACTIVE;
 
 	/* Set top and bottom field addrs in VPIF registers */
 	addr = vb2_dma_contig_plane_dma_addr(&common->next_frm->vb, 0);
-- 
1.9.1

