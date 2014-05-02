Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaEBPrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:47:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44396 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbaEBPrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:47:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 115/151] drm/qxl: unset a pointer in sync_obj_unref
Date: Fri,  2 May 2014 08:38:23 -0700
Message-Id: <1399045139-4531-116-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit 41ccec352f3c823931a7d9d2a9c7880c14d7415a upstream.

This fixes a BUG_ON(bo->sync_obj != NULL); in ttm_bo_release_list.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/qxl/qxl_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/qxl/qxl_ttm.c b/drivers/gpu/drm/qxl/qxl_ttm.c
index c7e7e65..c82c1d6a9 100644
--- a/drivers/gpu/drm/qxl/qxl_ttm.c
+++ b/drivers/gpu/drm/qxl/qxl_ttm.c
@@ -433,6 +433,7 @@ static int qxl_sync_obj_flush(void *sync_obj)
 
 static void qxl_sync_obj_unref(void **sync_obj)
 {
+	*sync_obj = NULL;
 }
 
 static void *qxl_sync_obj_ref(void *sync_obj)
-- 
1.9.1

