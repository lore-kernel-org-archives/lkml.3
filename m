Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934990AbaE2OOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:14:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59374 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933233AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 054/103] drm/qxl: unset a pointer in sync_obj_unref
Date: Thu, 29 May 2014 15:48:39 +0200
Message-Id: <657ac32e6a1cf38f6f2380cb075ab6fd56498c0f.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 41ccec352f3c823931a7d9d2a9c7880c14d7415a upstream.

This fixes a BUG_ON(bo->sync_obj != NULL); in ttm_bo_release_list.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/qxl/qxl_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/qxl/qxl_ttm.c b/drivers/gpu/drm/qxl/qxl_ttm.c
index 037786d7c1dc..ed90fbe63686 100644
--- a/drivers/gpu/drm/qxl/qxl_ttm.c
+++ b/drivers/gpu/drm/qxl/qxl_ttm.c
@@ -433,6 +433,7 @@ static int qxl_sync_obj_flush(void *sync_obj)
 
 static void qxl_sync_obj_unref(void **sync_obj)
 {
+	*sync_obj = NULL;
 }
 
 static void *qxl_sync_obj_ref(void *sync_obj)
-- 
1.9.3

