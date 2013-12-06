Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162427Ab3LFNn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:43:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44209 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161564Ab3LFNCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 138/272] drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previous fence
Date: Fri,  6 Dec 2013 12:57:07 +0000
Message-Id: <1386334761-25517-139-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 9360bd1112d8874d21942e2ae74f5416b00a8db6 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 830cb7b..5a69853 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -317,7 +317,8 @@ validate_fini_list(struct list_head *list, struct nouveau_fence *fence,
 	list_for_each_safe(entry, tmp, list) {
 		nvbo = list_entry(entry, struct nouveau_bo, entry);
 
-		nouveau_bo_fence(nvbo, fence);
+		if (likely(fence))
+			nouveau_bo_fence(nvbo, fence);
 
 		if (unlikely(nvbo->validate_mapped)) {
 			ttm_bo_kunmap(&nvbo->kmap);
-- 
1.8.3.2

