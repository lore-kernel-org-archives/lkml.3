Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbaEPNjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:39:55 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:57306 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492AbaEPNjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:39:52 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 15/49] media: davinci: vpif_display: drop numbuffers field from common_obj
Date: Fri, 16 May 2014 19:03:20 +0530
Message-Id: <1400247235-31434-17-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops numbuffers member from struct common_obj
as this was not required.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |    8 --------
 drivers/media/platform/davinci/vpif_display.h |    1 -
 2 files changed, 9 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index ab097ce..5ea2db8 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1221,13 +1221,11 @@ static int vpif_probe_complete(void)
 		/* Initialize field of the channel objects */
 		atomic_set(&ch->usrs, 0);
 		for (k = 0; k < VPIF_NUMOBJECTS; k++) {
-			ch->common[k].numbuffers = 0;
 			common = &ch->common[k];
 			common->io_usrs = 0;
 			common->started = 0;
 			spin_lock_init(&common->irqlock);
 			mutex_init(&common->lock);
-			common->numbuffers = 0;
 			common->set_addr = NULL;
 			common->ytop_off = 0;
 			common->ybtm_off = 0;
@@ -1236,17 +1234,11 @@ static int vpif_probe_complete(void)
 			common->cur_frm = NULL;
 			common->next_frm = NULL;
 			memset(&common->fmt, 0, sizeof(common->fmt));
-			common->numbuffers = config_params.numbuffers[k];
 		}
 		ch->initialized = 0;
 		if (vpif_obj.config->subdev_count)
 			ch->sd = vpif_obj.sd[0];
 		ch->channel_id = j;
-		if (j < 2)
-			ch->common[VPIF_VIDEO_INDEX].numbuffers =
-			    config_params.numbuffers[ch->channel_id];
-		else
-			ch->common[VPIF_VIDEO_INDEX].numbuffers = 0;
 
 		memset(&ch->vpifparams, 0, sizeof(ch->vpifparams));
 
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 06b8d24..e21a343 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -67,7 +67,6 @@ struct vpif_disp_buffer {
 };
 
 struct common_obj {
-	u32 numbuffers;				/* number of buffers */
 	struct vpif_disp_buffer *cur_frm;	/* Pointer pointing to current
 						 * vb2_buffer */
 	struct vpif_disp_buffer *next_frm;	/* Pointer pointing to next
-- 
1.7.9.5

