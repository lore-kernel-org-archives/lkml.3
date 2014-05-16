Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbaEPNg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:36:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54341 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaEPNg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:36:26 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 02/49] media: davinci: vpif_display: drop buf_init() callback
Date: Fri, 16 May 2014 19:03:07 +0530
Message-Id: <1400247235-31434-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops the buf_init() callback as init
of buf list is not required.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index dbd4f0f..e2102ea 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -205,16 +205,6 @@ static void vpif_wait_finish(struct vb2_queue *vq)
 	mutex_lock(&common->lock);
 }
 
-static int vpif_buffer_init(struct vb2_buffer *vb)
-{
-	struct vpif_disp_buffer *buf = container_of(vb,
-					struct vpif_disp_buffer, vb);
-
-	INIT_LIST_HEAD(&buf->list);
-
-	return 0;
-}
-
 static u8 channel_first_int[VPIF_NUMOBJECTS][2] = { {1, 1} };
 
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
@@ -351,7 +341,6 @@ static struct vb2_ops video_qops = {
 	.queue_setup		= vpif_buffer_queue_setup,
 	.wait_prepare		= vpif_wait_prepare,
 	.wait_finish		= vpif_wait_finish,
-	.buf_init		= vpif_buffer_init,
 	.buf_prepare		= vpif_buffer_prepare,
 	.start_streaming	= vpif_start_streaming,
 	.stop_streaming		= vpif_stop_streaming,
-- 
1.7.9.5

