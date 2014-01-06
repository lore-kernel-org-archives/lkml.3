Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaAFQax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:30:53 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:39925 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaAFQaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:30:52 -0500
Date: Mon, 6 Jan 2014 22:00:45 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 67/85] drivers: gpu: Include appropriate header file in
 si_smc.c and remove prototype declaration from header file sislands_smc.h
Message-ID: <f125a7ba483d4377f225da83c8f80b1ef8af8cbb.1389018325.git.rashika.kheria@gmail.com>
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

Include header file gpu/drm/radeon/sislands_smc.h in drm/radeon/si_smc.c
because it uses function declared in the header file.

Remove prototype declaration of function si_set_smc_sram_address() from
drm/radeon/sislands_smc.h because the function is used only in one file
where it is declared static already.

This eliminates the following warnings in drm/radeon/si_smc.c:
drivers/gpu/drm/radeon/si_smc.c:46:5: warning: no previous prototype for ‘si_copy_bytes_to_smc’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_smc.c:112:6: warning: no previous prototype for ‘si_start_smc’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_smc.c:121:6: warning: no previous prototype for ‘si_reset_smc’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_smc.c:135:5: warning: no previous prototype for ‘si_program_jump_on_start’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_smc.c:142:6: warning: no previous prototype for ‘si_stop_smc_clock’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_smc.c:151:6: warning: no previous prototype for ‘si_start_smc_clock’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_smc.c:160:6: warning: no previous prototype for ‘si_is_smc_running’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_smc.c:171:14: warning: no previous prototype for ‘si_send_msg_to_smc’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_smc.c:192:14: warning: no previous prototype for ‘si_wait_for_smc_inactive’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_smc.c:210:5: warning: no previous prototype for ‘si_load_smc_ucode’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_smc.c:269:5: warning: no previous prototype for ‘si_read_smc_sram_dword’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_smc.c:284:5: warning: no previous prototype for ‘si_write_smc_sram_dword’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/si_smc.c       |    1 +
 drivers/gpu/drm/radeon/sislands_smc.h |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/si_smc.c b/drivers/gpu/drm/radeon/si_smc.c
index d422a1c..e80efcf 100644
--- a/drivers/gpu/drm/radeon/si_smc.c
+++ b/drivers/gpu/drm/radeon/si_smc.c
@@ -28,6 +28,7 @@
 #include "sid.h"
 #include "ppsmc.h"
 #include "radeon_ucode.h"
+#include "sislands_smc.h"
 
 static int si_set_smc_sram_address(struct radeon_device *rdev,
 				   u32 smc_address, u32 limit)
diff --git a/drivers/gpu/drm/radeon/sislands_smc.h b/drivers/gpu/drm/radeon/sislands_smc.h
index 5578e98..10e945a 100644
--- a/drivers/gpu/drm/radeon/sislands_smc.h
+++ b/drivers/gpu/drm/radeon/sislands_smc.h
@@ -374,8 +374,6 @@ typedef struct Smc_SIslands_DTE_Configuration Smc_SIslands_DTE_Configuration;
 
 #pragma pack(pop)
 
-int si_set_smc_sram_address(struct radeon_device *rdev,
-			    u32 smc_address, u32 limit);
 int si_copy_bytes_to_smc(struct radeon_device *rdev,
 			 u32 smc_start_address,
 			 const u8 *src, u32 byte_count, u32 limit);
-- 
1.7.9.5

