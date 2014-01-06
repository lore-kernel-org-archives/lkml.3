Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaAFPY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:24:26 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58371 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbaAFPYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:24:25 -0500
Date: Mon, 6 Jan 2014 20:54:20 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 24/85] drivers: gpu: Move prototype declarations to header
 file from radeon_object.c
Message-ID: <83d0363df60cabec764a7d7aae78107887f3759f.1389018325.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declarations of functions from drm/radeon/radeon_object.c
to header file drm/radeon/radeon.h because they are used by more than
one file.

This eliminates the following warning in drm/radeon/radeon_ttm.c:
drivers/gpu/drm/radeon/radeon_ttm.c:691:5: warning: no previous prototype for ‘radeon_ttm_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_ttm.c:750:6: warning: no previous prototype for ‘radeon_ttm_fini’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon.h        |    3 +++
 drivers/gpu/drm/radeon/radeon_object.c |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index b1f990d..e874392 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -2246,6 +2246,9 @@ void r100_io_wreg(struct radeon_device *rdev, u32 reg, u32 v);
 u32 cik_mm_rdoorbell(struct radeon_device *rdev, u32 index);
 void cik_mm_wdoorbell(struct radeon_device *rdev, u32 index, u32 v);
 
+int radeon_ttm_init(struct radeon_device *rdev);
+void radeon_ttm_fini(struct radeon_device *rdev);
+
 /*
  * Cast helper
  */
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index c0fa4aa..2543430 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -37,8 +37,6 @@
 #include "radeon_trace.h"
 
 
-int radeon_ttm_init(struct radeon_device *rdev);
-void radeon_ttm_fini(struct radeon_device *rdev);
 static void radeon_bo_clear_surface_reg(struct radeon_bo *bo);
 
 /*
-- 
1.7.9.5

