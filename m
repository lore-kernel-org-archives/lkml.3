Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbaAFQfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:35:44 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45704 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbaAFQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:35:42 -0500
Date: Mon, 6 Jan 2014 22:05:34 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 71/85] drivers: gpu: Include appropriate header file in
 ci_smc.c
Message-ID: <21be6efd3d663f2dd00bae479200f12d1360b85f.1389018325.git.rashika.kheria@gmail.com>
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

Include header file drm/radeon/ci_dpm.h in drm/radeon/ci_smc.c because
it uses function declared in the header file.

This eliminates the following warnings in drm/radeon/ci_smc.c:
drivers/gpu/drm/radeon/ci_smc.c:46:5: warning: no previous prototype for ‘ci_copy_bytes_to_smc’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_smc.c:113:6: warning: no previous prototype for ‘ci_start_smc’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_smc.c:121:6: warning: no previous prototype for ‘ci_reset_smc’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_smc.c:129:5: warning: no previous prototype for ‘ci_program_jump_on_start’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_smc.c:136:6: warning: no previous prototype for ‘ci_stop_smc_clock’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_smc.c:145:6: warning: no previous prototype for ‘ci_start_smc_clock’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_smc.c:154:6: warning: no previous prototype for ‘ci_is_smc_running’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_smc.c:165:14: warning: no previous prototype for ‘ci_send_msg_to_smc’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_smc.c:186:14: warning: no previous prototype for ‘ci_wait_for_smc_inactive’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_smc.c:204:5: warning: no previous prototype for ‘ci_load_smc_ucode’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_smc.c:251:5: warning: no previous prototype for ‘ci_read_smc_sram_dword’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_smc.c:266:5: warning: no previous prototype for ‘ci_write_smc_sram_dword’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/ci_smc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/ci_smc.c b/drivers/gpu/drm/radeon/ci_smc.c
index 9c745dd..8debc9d 100644
--- a/drivers/gpu/drm/radeon/ci_smc.c
+++ b/drivers/gpu/drm/radeon/ci_smc.c
@@ -28,6 +28,7 @@
 #include "cikd.h"
 #include "ppsmc.h"
 #include "radeon_ucode.h"
+#include "ci_dpm.h"
 
 static int ci_set_smc_sram_address(struct radeon_device *rdev,
 				   u32 smc_address, u32 limit)
-- 
1.7.9.5

