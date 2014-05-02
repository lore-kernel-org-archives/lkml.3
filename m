Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaEBJth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:49:37 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19751 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaEBJtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:49:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 02 May 2014 02:43:57 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: David Airlie <airlied@linux.ie>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm/ttm: remove declaration of ttm_tt_cache_flush
Date: Fri, 2 May 2014 18:49:22 +0900
Message-ID: <1399024162-6528-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ttm_tt_cache_flush's implementation was removed in 2009 by commit
c9c97b8c, but its declaration has been hiding in ttm_bo_driver.h since
then.

It has been surviving in the dark for too long now ; give it the coup
de grâce.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 include/drm/ttm/ttm_bo_driver.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index a282ecfd1fb2..db313d8510ea 100644
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
1.9.2

