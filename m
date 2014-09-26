Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbaIZK2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:28:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbaIZJqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 036/142] media: v4l: vsp1: Remove the unneeded vsp1_video_buffer video field
Date: Fri, 26 Sep 2014 11:44:07 +0200
Message-Id: <053d9e01ece5a6c8f342f8c18f19f6560ca90f61.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e51daefc228aa164adcc17fe8fce0f856ad0a1cc upstream.

The field is assigned but never read, remove it.

This fixes a bug caused by the struct vb2_buffer field not being be the
very first field of the vsp1_video_buffer buffer structure as required
by videobuf2.

Reported-by: Takanari Hayama <taki@igel.co.jp>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/platform/vsp1/vsp1_video.c | 2 --
 drivers/media/platform/vsp1/vsp1_video.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 714c53ef6c11..2960ff1637d1 100644
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
index d8612a378345..47b7a8ab5e2f 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -89,7 +89,6 @@ static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
 }
 
 struct vsp1_video_buffer {
-	struct vsp1_video *video;
 	struct vb2_buffer buf;
 	struct list_head queue;
 
-- 
2.1.0

