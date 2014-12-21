Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaLURj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 12:39:57 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:51376 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaLURj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 12:39:56 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: radeon: radeon_device.c:  Remove unused function
Date: Sun, 21 Dec 2014 18:42:42 +0100
Message-Id: <1419183762-10640-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function radeon_doorbell_free() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/radeon.h        |    1 -
 drivers/gpu/drm/radeon/radeon_device.c |   14 --------------
 2 files changed, 15 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index a9717b3..93e7cfc 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -700,7 +700,6 @@ struct radeon_doorbell {
 };
 
 int radeon_doorbell_get(struct radeon_device *rdev, u32 *page);
-void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell);
 
 /*
  * IRQS.
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index ea26769..16a9999 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -363,20 +363,6 @@ int radeon_doorbell_get(struct radeon_device *rdev, u32 *doorbell)
 	}
 }
 
-/**
- * radeon_doorbell_free - Free a doorbell entry
- *
- * @rdev: radeon_device pointer
- * @doorbell: doorbell index
- *
- * Free a doorbell allocated for use by the driver (all asics)
- */
-void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell)
-{
-	if (doorbell < rdev->doorbell.num_doorbells)
-		__clear_bit(doorbell, rdev->doorbell.used);
-}
-
 /*
  * radeon_wb_*()
  * Writeback is the the method by which the the GPU updates special pages
-- 
1.7.10.4

