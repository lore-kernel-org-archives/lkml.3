Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaIOVTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:19:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbaIOT0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takanari Hayama <taki@igel.co.jp>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.16 008/158] media: v4l: vsp1: Remove the unneeded vsp1_video_buffer video field
Date: Mon, 15 Sep 2014 12:24:07 -0700
Message-Id: <20140915192543.128404989@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/vsp1/vsp1_video.c |    2 --
 drivers/media/platform/vsp1/vsp1_video.h |    1 -
 2 files changed, 3 deletions(-)

--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -654,8 +654,6 @@ static int vsp1_video_buffer_prepare(str
 	if (vb->num_planes < format->num_planes)
 		return -EINVAL;
 
-	buf->video = video;
-
 	for (i = 0; i < vb->num_planes; ++i) {
 		buf->addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
 		buf->length[i] = vb2_plane_size(vb, i);
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -90,7 +90,6 @@ static inline struct vsp1_pipeline *to_v
 }
 
 struct vsp1_video_buffer {
-	struct vsp1_video *video;
 	struct vb2_buffer buf;
 	struct list_head queue;
 


