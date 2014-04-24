Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaDXIy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:54:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaDXIyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:54:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 114/182] drm/qxl: unset a pointer in sync_obj_unref
Date: Thu, 24 Apr 2014 09:50:39 +0100
Message-Id: <1398329507-5911-115-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit 41ccec352f3c823931a7d9d2a9c7880c14d7415a upstream.

This fixes a BUG_ON(bo->sync_obj != NULL); in ttm_bo_release_list.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/qxl/qxl_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/qxl/qxl_ttm.c b/drivers/gpu/drm/qxl/qxl_ttm.c
index 1dfd84c..ab69791 100644
--- a/drivers/gpu/drm/qxl/qxl_ttm.c
+++ b/drivers/gpu/drm/qxl/qxl_ttm.c
@@ -431,6 +431,7 @@ static int qxl_sync_obj_flush(void *sync_obj)
 
 static void qxl_sync_obj_unref(void **sync_obj)
 {
+	*sync_obj = NULL;
 }
 
 static void *qxl_sync_obj_ref(void *sync_obj)
-- 
1.9.1

