Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaLGTbM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 14:31:12 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:3226 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438AbaLGT0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 14:26:47 -0500
X-IronPort-AV: E=Sophos;i="5.07,534,1413237600"; 
   d="scan'208";a="111932933"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Daniel Vetter <daniel.vetter@intel.com>
Cc: kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk, joe@perches.com,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/20] drm/i915: fix misspelling of current function in string
Date: Sun,  7 Dec 2014 20:20:49 +0100
Message-Id: <1417980062-25151-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a misspelled function name by %s and then __func__.

This was done using Coccinelle, including the use of Levenshtein distance,
as proposed by Rasmus Villemoes.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch is difficult to summarize, but is available in the cover
letter of this patch series.

The message is sort of ambiguous, but I assume that it is intended to refer
to the function in which the problem is detected.

 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index d2ba315..fa21d1c 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4335,7 +4335,7 @@ i915_gem_unpin_ioctl(struct drm_device *dev, void *data,
 	}
 
 	if (obj->pin_filp != file) {
-		DRM_DEBUG("Not pinned by caller in i915_gem_pin_ioctl(): %d\n",
+		DRM_DEBUG("Not pinned by caller in %s(): %d\n", __func__,
 			  args->handle);
 		ret = -EINVAL;
 		goto out;

