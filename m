Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbaJIVJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:09:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59297 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517AbaJIVIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhaowei Yuan <zhaowei.yuan@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 127/163] [media] vb2: fix plane index sanity check in vb2_plane_cookie()
Date: Thu,  9 Oct 2014 14:02:32 -0700
Message-Id: <1412888588-26755-128-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaowei Yuan <zhaowei.yuan@samsung.com>

commit a9ae4692eda4b99f85757b15d60971ff78a0a0e2 upstream.

It's also invalid when plane_no is equal to vb->num_planes

Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 0edc165..7db9b5b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -885,7 +885,7 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 
-	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
+	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
 		return NULL;
 
 	return call_memop(q, cookie, vb->planes[plane_no].mem_priv);
-- 
1.9.1

