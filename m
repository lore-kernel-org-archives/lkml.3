Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab3JHKg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:36:27 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37339 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab3JHKgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:36:22 -0400
From: Majunath Goudar <csmanjuvijay@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nataraja.km@lge.com, Majunath Goudar <csmanjuvijay@gmail.com>,
        Jeyaraman R <jeyaraman.rangasamy@lge.com>,
        David Airlie <airlied@linux.ie>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] DRM: TTM: Fix memory leak issue in ttm_agp_tt_create().
Date: Tue,  8 Oct 2013 16:06:04 +0530
Message-Id: <1381228565-20846-1-git-send-email-csmanjuvijay@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds kfree() in ttm_agp_tt_create() to avoide the
memory leak, without this there is a chance of memory leak in
ttm_tt_init() fail case.

Signed-off-by: Jeyaraman R <jeyaraman.rangasamy@lge.com>
Signed-off-by: Manjunath Goudar <csmanjuvijay@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpu/drm/ttm/ttm_agp_backend.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/ttm/ttm_agp_backend.c b/drivers/gpu/drm/ttm/ttm_agp_backend.c
index 3302f99..764be36 100644
--- a/drivers/gpu/drm/ttm/ttm_agp_backend.c
+++ b/drivers/gpu/drm/ttm/ttm_agp_backend.c
@@ -126,6 +126,7 @@ struct ttm_tt *ttm_agp_tt_create(struct ttm_bo_device *bdev,
 	agp_be->ttm.func = &ttm_agp_func;
 
 	if (ttm_tt_init(&agp_be->ttm, bdev, size, page_flags, dummy_read_page)) {
+		kfree(agp_be);
 		return NULL;
 	}
 
-- 
1.7.9.5

