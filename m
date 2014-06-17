Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaFQGjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 02:39:44 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5072 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaFQGjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 02:39:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 16 Jun 2014 23:30:27 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>
CC: David Herrmann <dh.herrmann@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH RESEND RESEND] drm/ttm: remove declaration of ttm_tt_cache_flush
Date: Tue, 17 Jun 2014 15:39:18 +0900
Message-ID: <1402987158-21919-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
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
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
---
 include/drm/ttm/ttm_bo_driver.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 52fb709568fc..1cf69cbb1789 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -654,18 +654,6 @@ extern void ttm_tt_unbind(struct ttm_tt *ttm);
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
2.0.0

