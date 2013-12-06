Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab3LFXRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:17:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724Ab3LFXRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:17:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 120/152] drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previous fence
Date: Fri,  6 Dec 2013 15:10:44 -0800
Message-Id: <1386371476-2477-121-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 9360bd1112d8874d21942e2ae74f5416b00a8db6 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 8bf695c..3aa8e2f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -288,7 +288,8 @@ validate_fini_list(struct list_head *list, struct nouveau_fence *fence)
 	list_for_each_safe(entry, tmp, list) {
 		nvbo = list_entry(entry, struct nouveau_bo, entry);
 
-		nouveau_bo_fence(nvbo, fence);
+		if (likely(fence))
+			nouveau_bo_fence(nvbo, fence);
 
 		if (unlikely(nvbo->validate_mapped)) {
 			ttm_bo_kunmap(&nvbo->kmap);
-- 
1.8.3.2

