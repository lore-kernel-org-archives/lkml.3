Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3IYOtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:49:51 -0400
Received: from 8bytes.org ([85.214.48.195]:47667 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab3IYOtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:49:49 -0400
From: Joerg Roedel <joro@8bytes.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 2/3] Fix compile error in drivers/gpu/drm/msm/msm_drv.c
Date: Wed, 25 Sep 2013 16:49:41 +0200
Message-Id: <1380120582-9068-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380120582-9068-1-git-send-email-joro@8bytes.org>
References: <1380120582-9068-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Sep 25 16:49:47 2013
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5242f80b20861957919264
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The include file has been moved but this file was not
updated, so compile breaks.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/gpu/drm/msm/Makefile  |    3 ---
 drivers/gpu/drm/msm/msm_drv.c |    5 ++++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/Makefile b/drivers/gpu/drm/msm/Makefile
index e179148..fc7ed9e 100644
--- a/drivers/gpu/drm/msm/Makefile
+++ b/drivers/gpu/drm/msm/Makefile
@@ -1,7 +1,4 @@
 ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/msm
-ifeq (, $(findstring -W,$(EXTRA_CFLAGS)))
-	ccflags-y += -Werror
-endif
 
 msm-y := \
 	adreno/adreno_gpu.o \
diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 008d772..08acebb 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -18,7 +18,10 @@
 #include "msm_drv.h"
 #include "msm_gpu.h"
 
-#include <mach/iommu.h>
+#ifndef I_AM_NOT_TOO_LAZY_TO_FIX_DRIVERS_WHEN_I_MOVE_INCLUDE_FILES
+#warning "Help! I use non-public subsystem headers. Please fix me!"
+#include <../../../iommu/msm_iommu.h>
+#endif
 
 static void msm_fb_output_poll_changed(struct drm_device *dev)
 {
-- 
1.7.9.5


