Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaAFPwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:52:37 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47519 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaAFPwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:52:35 -0500
Date: Mon, 6 Jan 2014 21:22:30 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 43/85] drivers: gpu: Move prototype declarations to header
 file radeon_asic.h from evergreen.c and ni_dma.c
Message-ID: <85a7133c5c5dc8be2aac2b9116a9f51f8cf3b5e8.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declarations of function cayman_cp_int_cntl_setup(),
cayman_vm_decode_fault() and cayman_gpu_check_soft_reset() to header
file drm/radeon/radeon_asic.h because they are used by more than one
file.

This eliminates the following warnings in drm/radeon/ni.c:
drivers/gpu/drm/radeon/ni.c:1304:6: warning: no previous prototype for ‘cayman_cp_int_cntl_setup’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni.c:1599:5: warning: no previous prototype for ‘cayman_gpu_check_soft_reset’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni.c:2246:6: warning: no previous prototype for ‘cayman_vm_decode_fault’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/evergreen.c   |    4 ----
 drivers/gpu/drm/radeon/ni_dma.c      |    2 --
 drivers/gpu/drm/radeon/radeon_asic.h |    5 +++++
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 9702e55..f4806ed 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -136,10 +136,6 @@ static void evergreen_gpu_init(struct radeon_device *rdev);
 void evergreen_fini(struct radeon_device *rdev);
 void evergreen_pcie_gen2_enable(struct radeon_device *rdev);
 void evergreen_program_aspm(struct radeon_device *rdev);
-extern void cayman_cp_int_cntl_setup(struct radeon_device *rdev,
-				     int ring, u32 cp_int_cntl);
-extern void cayman_vm_decode_fault(struct radeon_device *rdev,
-				   u32 status, u32 addr);
 void cik_init_cp_pg_table(struct radeon_device *rdev);
 
 extern u32 si_get_csb_size(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/ni_dma.c b/drivers/gpu/drm/radeon/ni_dma.c
index bdeb65e..2897cf1 100644
--- a/drivers/gpu/drm/radeon/ni_dma.c
+++ b/drivers/gpu/drm/radeon/ni_dma.c
@@ -27,8 +27,6 @@
 #include "radeon_trace.h"
 #include "nid.h"
 
-u32 cayman_gpu_check_soft_reset(struct radeon_device *rdev);
-
 /*
  * DMA
  * Starting with R600, the GPU has an asynchronous
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 5e1f169..732fb6c 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -577,6 +577,11 @@ int evergreen_rlc_resume(struct radeon_device *rdev);
 /*
  * cayman
  */
+void cayman_cp_int_cntl_setup(struct radeon_device *rdev,
+			      int ring, u32 cp_int_cntl);
+void cayman_vm_decode_fault(struct radeon_device *rdev,
+			    u32 status, u32 addr);
+u32 cayman_gpu_check_soft_reset(struct radeon_device *rdev);
 void cayman_fence_ring_emit(struct radeon_device *rdev,
 			    struct radeon_fence *fence);
 void cayman_pcie_gart_tlb_flush(struct radeon_device *rdev);
-- 
1.7.9.5

