Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaBIJpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 04:45:22 -0500
Received: from gnurou.org ([207.192.72.5]:35673 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaBIJpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 04:45:17 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm/ttm: declare 'struct device' in ttm_page_alloc.h
Date: Sun,  9 Feb 2014 18:43:18 +0900
Message-Id: <1391938998-4848-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare 'struct device' explicitly in ttm_page_alloc.h as this file
does not include any file declaring it. This removes the following
warning:

	warning: 'struct device' declared inside parameter list

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
This warning was visible when compiling Nouveau on -next today.

 include/drm/ttm/ttm_page_alloc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index d1f61bf..49a8284 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -29,6 +29,8 @@
 #include <drm/ttm/ttm_bo_driver.h>
 #include <drm/ttm/ttm_memory.h>
 
+struct device;
+
 /**
  * Initialize pool allocator.
  */
-- 
1.8.5.4

