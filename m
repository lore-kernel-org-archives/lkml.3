Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaINQlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:41:31 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:63043 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbaINQl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:41:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhATANrEFVRbsGnM/2dsb2JhbABggw2zSAEBAQEBAQUBbwGddgQCAYEEF3iEBAEFViMQUTkeGYhCAakNjwMYhXyIbWQHFoQ1BZ0IjDCJD4IbgUU7L4EGgUQBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, Fabian Frederick <fabf@skynet.be>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 6/9 linux-next] drm/qxl: use container_of to resolve qxl_fbdev from drm_fb_helper
Date: Sun, 14 Sep 2014 18:40:19 +0200
Message-Id: <1410712823-29137-7-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410712823-29137-1-git-send-email-fabf@skynet.be>
References: <1410712823-29137-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
Compiled but untested.

 drivers/gpu/drm/qxl/qxl_fb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/qxl/qxl_fb.c b/drivers/gpu/drm/qxl/qxl_fb.c
index df56788..3d7c1d0 100644
--- a/drivers/gpu/drm/qxl/qxl_fb.c
+++ b/drivers/gpu/drm/qxl/qxl_fb.c
@@ -625,7 +625,8 @@ static int qxl_fb_find_or_create_single(
 		struct drm_fb_helper *helper,
 		struct drm_fb_helper_surface_size *sizes)
 {
-	struct qxl_fbdev *qfbdev = (struct qxl_fbdev *)helper;
+	struct qxl_fbdev *qfbdev =
+		container_of(helper, struct qxl_fbdev, helper);
 	int new_fb = 0;
 	int ret;
 
-- 
1.9.1

