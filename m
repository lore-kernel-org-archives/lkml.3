Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaBLNqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:46:35 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44620 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBLNqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:46:33 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@linux.ie
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] drm/ttm: Fix memory leak in ttm_agp_backend.c
Date: Wed, 12 Feb 2014 22:46:25 +0900
Message-Id: <1392212785-23150-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a memory leak found by cppcheck.
[drivers/gpu/drm/ttm/ttm_agp_backend.c:129]:
(error) Memory leak: agp_be

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/gpu/drm/ttm/ttm_agp_backend.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/ttm/ttm_agp_backend.c b/drivers/gpu/drm/ttm/ttm_agp_backend.c
index 3302f99..764be36 100644
--- a/drivers/gpu/drm/ttm/ttm_agp_backend.c
+++ b/drivers/gpu/drm/ttm/ttm_agp_backend.c
@@ -126,6 +126,7 @@ struct ttm_tt *ttm_agp_tt_create(struct ttm_bo_device *bdev,
 	agp_be->ttm.func = &ttm_agp_func;
 
 	if (ttm_tt_init(&agp_be->ttm, bdev, size, page_flags, dummy_read_page)) {
+		kfree(agp_be);
 		return NULL;
 	}
 
-- 
1.9.rc1

