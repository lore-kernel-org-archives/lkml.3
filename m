Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997Ab3CZNOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:14:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:34842 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933869Ab3CZNO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:14:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,911,1355126400"; 
   d="scan'208";a="276111357"
From: Imre Deak <imre.deak@intel.com>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 2/2] Revert "drm/i915: set dummy page for stolen objects"
Date: Tue, 26 Mar 2013 15:14:19 +0200
Message-Id: <1364303659-1951-3-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364303659-1951-1-git-send-email-imre.deak@intel.com>
References: <1364303659-1951-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since for_each_sg_page supports already memory w/o backing pages we can
revert the corresponding workaround.

This reverts commit 5bd4687e57bbacec20930f580d025aee9fa1f4d8.
---
 drivers/gpu/drm/i915/i915_gem_stolen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index efaaba5..69d97cb 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -222,8 +222,8 @@ i915_pages_create_for_stolen(struct drm_device *dev,
 	}
 
 	sg = st->sgl;
-	/* we set the dummy page here only to make for_each_sg_page work */
-	sg_set_page(sg, dev_priv->gtt.scratch_page, size, offset);
+	sg->offset = offset;
+	sg->length = size;
 
 	sg_dma_address(sg) = (dma_addr_t)dev_priv->mm.stolen_base + offset;
 	sg_dma_len(sg) = size;
-- 
1.7.10.4

