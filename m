Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbaEPNmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:42:18 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47996 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375AbaEPNmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:42:14 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 38/49] media: davinci: vpif_capture: drop unnecessary field memory
Date: Fri, 16 May 2014 19:03:44 +0530
Message-Id: <1400247235-31434-41-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |    5 -----
 drivers/media/platform/davinci/vpif_capture.h |    5 -----
 2 files changed, 10 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 41cd3ff..6b66f55 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -608,11 +608,6 @@ static void vpif_config_format(struct channel_obj *ch)
 	vpif_dbg(2, debug, "vpif_config_format\n");
 
 	common->fmt.fmt.pix.field = V4L2_FIELD_ANY;
-	if (config_params.numbuffers[ch->channel_id] == 0)
-		common->memory = V4L2_MEMORY_USERPTR;
-	else
-		common->memory = V4L2_MEMORY_MMAP;
-
 	common->fmt.fmt.pix.sizeimage
 	    = config_params.channel_bufsize[ch->channel_id];
 
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index f600819..9b7dd06 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -63,11 +63,6 @@ struct common_obj {
 	struct vpif_cap_buffer *cur_frm;
 	/* Pointer pointing to current v4l2_buffer */
 	struct vpif_cap_buffer *next_frm;
-	/*
-	 * This field keeps track of type of buffer exchange mechanism
-	 * user has selected
-	 */
-	enum v4l2_memory memory;
 	/* Used to store pixel format */
 	struct v4l2_format fmt;
 	/* Buffer queue used in video-buf */
-- 
1.7.9.5

