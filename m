Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbaEPNjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:39:37 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:60762 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483AbaEPNjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:39:35 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 14/49] media: davinci: vpif_display: drop unnecessary field memory
Date: Fri, 16 May 2014 19:03:19 +0530
Message-Id: <1400247235-31434-16-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |    5 -----
 drivers/media/platform/davinci/vpif_display.h |    3 ---
 2 files changed, 8 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index bfe1e50..ab097ce 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -572,11 +572,6 @@ static void vpif_config_format(struct channel_obj *ch)
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	common->fmt.fmt.pix.field = V4L2_FIELD_ANY;
-	if (config_params.numbuffers[ch->channel_id] == 0)
-		common->memory = V4L2_MEMORY_USERPTR;
-	else
-		common->memory = V4L2_MEMORY_MMAP;
-
 	common->fmt.fmt.pix.sizeimage =
 			config_params.channel_bufsize[ch->channel_id];
 	common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index b22bb33..06b8d24 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -72,9 +72,6 @@ struct common_obj {
 						 * vb2_buffer */
 	struct vpif_disp_buffer *next_frm;	/* Pointer pointing to next
 						 * vb2_buffer */
-	enum v4l2_memory memory;		/* This field keeps track of
-						 * type of buffer exchange
-						 * method user has selected */
 	struct v4l2_format fmt;			/* Used to store the format */
 	struct vb2_queue buffer_queue;		/* Buffer queue used in
 						 * video-buf */
-- 
1.7.9.5

