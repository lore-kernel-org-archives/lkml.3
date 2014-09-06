Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaIFP2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 11:28:48 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:49697 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaIFP1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 11:27:43 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/5] media: davinci: vpif_capture: drop setting of vb2 buffer state to ACTIVE
Date: Sat,  6 Sep 2014 16:26:48 +0100
Message-Id: <1410017211-15438-3-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_capture.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index cf15bb1..881efcd 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -213,8 +213,6 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* Remove buffer from the buffer queue */
 	list_del(&common->cur_frm->list);
 	spin_unlock_irqrestore(&common->irqlock, flags);
-	/* Mark state of the current frame to active */
-	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
 
 	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
 
@@ -350,7 +348,6 @@ static void vpif_schedule_next_buffer(struct common_obj *common)
 	/* Remove that buffer from the buffer queue */
 	list_del(&common->next_frm->list);
 	spin_unlock(&common->irqlock);
-	common->next_frm->vb.state = VB2_BUF_STATE_ACTIVE;
 	addr = vb2_dma_contig_plane_dma_addr(&common->next_frm->vb, 0);
 
 	/* Set top and bottom field addresses in VPIF registers */
-- 
1.9.1

