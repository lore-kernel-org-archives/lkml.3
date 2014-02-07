Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbaBGLv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:51:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42287 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaBGLvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Akash Goel <akash.goel@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 182/233] drm/i915: Fix the offset issue for the stolen GEM objects
Date: Fri,  7 Feb 2014 11:46:41 +0000
Message-Id: <1391773652-25214-183-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akash Goel <akash.goel@intel.com>

commit ec14ba47791965d2c08e0a681ff44eacbf3c4553 upstream.

The 'offset' field of the 'scatterlist' structure was wrongly
programmed with the offset value from the base of stolen area,
whereas this field indicates the offset from where the interested
data starts within the first PAGE pointed to by 'scattterlist'
structure. As a result when a new GEM object allocated from stolen
area is mapped to GTT, it could lead to an overwrite of GTT entries
as the page count calculation will go wrong, refer the function
'sg_page_count'.

v2: Modified the commit message. (Chris)

Signed-off-by: Akash Goel <akash.goel@intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=71908
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=69104
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_stolen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index 982d473..4047e3b 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -234,7 +234,7 @@ i915_pages_create_for_stolen(struct drm_device *dev,
 	}
 
 	sg = st->sgl;
-	sg->offset = offset;
+	sg->offset = 0;
 	sg->length = size;
 
 	sg_dma_address(sg) = (dma_addr_t)dev_priv->mm.stolen_base + offset;
-- 
1.8.3.2

