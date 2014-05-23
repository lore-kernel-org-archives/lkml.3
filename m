Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaEWD63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 23:58:29 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8842 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaEWD61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 23:58:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 22 May 2014 20:53:31 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Dave Airlie <airlied@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH RESEND] drm/ttm: remove declaration of ttm_tt_cache_flush
Date: Fri, 23 May 2014 12:58:07 +0900
Message-ID: <1400817487-27179-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400817487-27179-1-git-send-email-acourbot@nvidia.com>
References: <1400817487-27179-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ttm_tt_cache_flush's implementation was removed in 2009 by commit
c9c97b8c, but its declaration has been hiding in ttm_bo_driver.h since
then.

It has been surviving in the dark for too long now ; give it the mercy
blow.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
---
 include/drm/ttm/ttm_bo_driver.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index a5183da3ef92..e3f8c99a8a9d 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -653,18 +653,6 @@ extern void ttm_tt_unbind(struct ttm_tt *ttm);
 extern int ttm_tt_swapin(struct ttm_tt *ttm);
 
 /**
- * ttm_tt_cache_flush:
- *
- * @pages: An array of pointers to struct page:s to flush.
- * @num_pages: Number of pages to flush.
- *
- * Flush the data of the indicated pages from the cpu caches.
- * This is used when changing caching attributes of the pages from
- * cache-coherent.
- */
-extern void ttm_tt_cache_flush(struct page *pages[], unsigned long num_pages);
-
-/**
  * ttm_tt_set_placement_caching:
  *
  * @ttm A struct ttm_tt the backing pages of which will change caching policy.
-- 
1.9.2

