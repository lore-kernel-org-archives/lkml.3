Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaAFQkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:40:09 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:55067 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaAFQkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:40:07 -0500
Date: Mon, 6 Jan 2014 22:10:01 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 75/85] drivers: gpu: Move prototype declaration to header
 file radeon_asic.h from cik.c
Message-ID: <52ed4e77abebcc7b9f81ce1a5b81c18940ca1069.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declaration of functions cik_sdma_resume(),
cik_sdma_enable() and cik_sdma_fini() to header file
drm/radeon/radeon_asic.h because they are used by more than one file.

This eliminates the following warnings in drm/radeon/cik_sdma.c:
drivers/gpu/drm/radeon/cik_sdma.c:194:6: warning: no previous prototype for ‘cik_sdma_enable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/cik_sdma.c:360:5: warning: no previous prototype for ‘cik_sdma_resume’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/cik_sdma.c:396:6: warning: no previous prototype for ‘cik_sdma_fini’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/cik.c         |    3 ---
 drivers/gpu/drm/radeon/radeon_asic.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 76902ca..fd9029c 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -62,9 +62,6 @@ MODULE_FIRMWARE("radeon/KABINI_mec.bin");
 MODULE_FIRMWARE("radeon/KABINI_rlc.bin");
 MODULE_FIRMWARE("radeon/KABINI_sdma.bin");
 
-extern int cik_sdma_resume(struct radeon_device *rdev);
-extern void cik_sdma_enable(struct radeon_device *rdev, bool enable);
-extern void cik_sdma_fini(struct radeon_device *rdev);
 static void cik_rlc_stop(struct radeon_device *rdev);
 static void cik_pcie_gen3_enable(struct radeon_device *rdev);
 static void cik_program_aspm(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 1d631cd..7091d09 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -712,6 +712,9 @@ void dce8_bandwidth_update(struct radeon_device *rdev);
 /*
  * cik
  */
+int cik_sdma_resume(struct radeon_device *rdev);
+void cik_sdma_enable(struct radeon_device *rdev, bool enable);
+void cik_sdma_fini(struct radeon_device *rdev);
 u32 cik_gpu_check_soft_reset(struct radeon_device *rdev);
 void cik_enter_rlc_safe_mode(struct radeon_device *rdev);
 void cik_exit_rlc_safe_mode(struct radeon_device *rdev);
-- 
1.7.9.5

