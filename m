Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505AbaE2F3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:29:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbaE2EfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.14 058/140] drm/qxl: unset a pointer in sync_obj_unref
Date: Wed, 28 May 2014 21:33:17 -0700
Message-Id: <20140529043056.935879074@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit 41ccec352f3c823931a7d9d2a9c7880c14d7415a upstream.

This fixes a BUG_ON(bo->sync_obj != NULL); in ttm_bo_release_list.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/qxl/qxl_ttm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/qxl/qxl_ttm.c
+++ b/drivers/gpu/drm/qxl/qxl_ttm.c
@@ -433,6 +433,7 @@ static int qxl_sync_obj_flush(void *sync
 
 static void qxl_sync_obj_unref(void **sync_obj)
 {
+	*sync_obj = NULL;
 }
 
 static void *qxl_sync_obj_ref(void *sync_obj)


