Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab3G3PZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:25:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55326 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab3G3PSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xiong Zhang <xiong.y.zhang@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 04/75] drm/i915: Correct obj->mm_list link to dev_priv->dev_priv->mm.inactive_list
Date: Tue, 30 Jul 2013 08:16:33 -0700
Message-Id: <1375197464-27962-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiong Zhang <xiong.y.zhang@intel.com>

commit 067556084a0e412013af6b0250a3143ae5afde6d upstream.

obj->mm_list link to dev_priv->mm.inactive_list/active_list
obj->global_list link to dev_priv->mm.unbound_list/bound_list

This regression has been introduced in

commit 93927ca52a55c23e0a6a305e7e9082e8411ac9fa
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Jan 10 18:03:00 2013 +0100

    drm/i915: Revert shrinker changes from "Track unbound pages"

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
[danvet: Add regression notice.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 80bc298..0e01617 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4429,7 +4429,7 @@ i915_gem_inactive_shrink(struct shrinker *shrinker, struct shrink_control *sc)
 	list_for_each_entry(obj, &dev_priv->mm.unbound_list, gtt_list)
 		if (obj->pages_pin_count == 0)
 			cnt += obj->base.size >> PAGE_SHIFT;
-	list_for_each_entry(obj, &dev_priv->mm.inactive_list, gtt_list)
+	list_for_each_entry(obj, &dev_priv->mm.inactive_list, mm_list)
 		if (obj->pin_count == 0 && obj->pages_pin_count == 0)
 			cnt += obj->base.size >> PAGE_SHIFT;
 
-- 
1.8.1.2

