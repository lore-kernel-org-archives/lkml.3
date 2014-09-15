Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbaIOWdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:33:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51231 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291AbaIOWTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 051/187] [media] v4l: vsp1: Remove the unneeded vsp1_video_buffer video field
Date: Mon, 15 Sep 2014 15:07:41 -0700
Message-Id: <1410818997-9432-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit e51daefc228aa164adcc17fe8fce0f856ad0a1cc upstream.

The field is assigned but never read, remove it.

This fixes a bug caused by the struct vb2_buffer field not being be the
very first field of the vsp1_video_buffer buffer structure as required
by videobuf2.

Reported-by: Takanari Hayama <taki@igel.co.jp>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 2 --
 drivers/media/platform/vsp1/vsp1_video.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 4b0ac07..daa992c 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -622,8 +622,6 @@ static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 	if (vb->num_planes < format->num_planes)
 		return -EINVAL;
 
-	buf->video = video;
-
 	for (i = 0; i < vb->num_planes; ++i) {
 		buf->addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
 		buf->length[i] = vb2_plane_size(vb, i);
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index d8612a3..47b7a8a 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -89,7 +89,6 @@ static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
 }
 
 struct vsp1_video_buffer {
-	struct vsp1_video *video;
 	struct vb2_buffer buf;
 	struct list_head queue;
 
-- 
1.9.1

