Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3BAUpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:45:41 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:26647 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3BAUpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:45:39 -0500
Message-ID: <201302012045.r11KjctX014737@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 1 Feb 2013 13:44:33 -0500
Subject: [PATCH] drm: fix compile failure by including <linux/swiotlb.h>
To: <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Christian Konig <deathsimple@vodafone.de>,
        <dri-devel@lists.freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On tile architecture (with "make allyesconfig") including
<linux/swiotlb.h> is required to call swiotlb_nr_tbl().

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    1 +
 drivers/gpu/drm/radeon/radeon_ttm.c  |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 69d7b1d..1699a90 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -28,6 +28,7 @@
  */
 
 #include <core/engine.h>
+#include <linux/swiotlb.h>
 
 #include <subdev/fb.h>
 #include <subdev/vm.h>
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 1d8ff2f..93f760e 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -38,6 +38,7 @@
 #include <drm/radeon_drm.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/swiotlb.h>
 #include "radeon_reg.h"
 #include "radeon.h"
 
-- 
1.7.10.3

