Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbaEPNlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:41:16 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49601 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566AbaEPNlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:41:13 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 27/49] media: davinci: vpif_capture: drop buf_init() callback
Date: Fri, 16 May 2014 19:03:32 +0530
Message-Id: <1400247235-31434-29-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_capture.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index b035c88..484d858 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -242,15 +242,6 @@ static void vpif_wait_finish(struct vb2_queue *vq)
 	mutex_lock(&common->lock);
 }
 
-static int vpif_buffer_init(struct vb2_buffer *vb)
-{
-	struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
-
-	INIT_LIST_HEAD(&buf->list);
-
-	return 0;
-}
-
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vpif_capture_config *vpif_config_data =
@@ -385,7 +376,6 @@ static struct vb2_ops video_qops = {
 	.queue_setup		= vpif_buffer_queue_setup,
 	.wait_prepare		= vpif_wait_prepare,
 	.wait_finish		= vpif_wait_finish,
-	.buf_init		= vpif_buffer_init,
 	.buf_prepare		= vpif_buffer_prepare,
 	.start_streaming	= vpif_start_streaming,
 	.stop_streaming		= vpif_stop_streaming,
-- 
1.7.9.5

