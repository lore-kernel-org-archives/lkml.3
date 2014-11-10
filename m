Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaKJRZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:25:55 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61918 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbaKJRZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:25:52 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/2] media: vivid: use vb2_start_streaming_called() helper
Date: Mon, 10 Nov 2014 16:55:53 +0000
Message-Id: <1415638554-13362-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support for using vb2_start_streaming_called()
for vivid driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/vivid/vivid-ctrls.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index d5cbf00..c04d4a9 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -792,15 +792,15 @@ static int vivid_streaming_s_ctrl(struct v4l2_ctrl *ctrl)
 		dev->start_streaming_error = true;
 		break;
 	case VIVID_CID_QUEUE_ERROR:
-		if (dev->vb_vid_cap_q.start_streaming_called)
+		if (vb2_start_streaming_called(&dev->vb_vid_cap_q))
 			vb2_queue_error(&dev->vb_vid_cap_q);
-		if (dev->vb_vbi_cap_q.start_streaming_called)
+		if (vb2_start_streaming_called(&dev->vb_vbi_cap_q))
 			vb2_queue_error(&dev->vb_vbi_cap_q);
-		if (dev->vb_vid_out_q.start_streaming_called)
+		if (vb2_start_streaming_called(&dev->vb_vid_out_q))
 			vb2_queue_error(&dev->vb_vid_out_q);
-		if (dev->vb_vbi_out_q.start_streaming_called)
+		if (vb2_start_streaming_called(&dev->vb_vbi_out_q))
 			vb2_queue_error(&dev->vb_vbi_out_q);
-		if (dev->vb_sdr_cap_q.start_streaming_called)
+		if (vb2_start_streaming_called(&dev->vb_sdr_cap_q))
 			vb2_queue_error(&dev->vb_sdr_cap_q);
 		break;
 	case VIVID_CID_SEQ_WRAP:
-- 
1.9.1

