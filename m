Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaAFQTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:19:43 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:34454 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaAFQTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:19:41 -0500
Date: Mon, 6 Jan 2014 21:49:32 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 61/85] drivers: gpu: Move prototype declaration to header
 file sumo_dpm.h
Message-ID: <b9d926e86e76ec2a35404a793a56537d5f26febe.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declaration of function sumo_get_pi() to header file
drm/radeon/sumo_dpm.h because it is used by more than one file.

This eliminates the following warning in drm/radeon/sumo_dpm.c:
drivers/gpu/drm/radeon/sumo_dpm.c:81:25: warning: no previous prototype for ‘sumo_get_pi’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/sumo_dpm.h |    2 ++
 drivers/gpu/drm/radeon/sumo_smc.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/sumo_dpm.h b/drivers/gpu/drm/radeon/sumo_dpm.h
index db1ea32..ad8640a 100644
--- a/drivers/gpu/drm/radeon/sumo_dpm.h
+++ b/drivers/gpu/drm/radeon/sumo_dpm.h
@@ -188,6 +188,8 @@ struct sumo_power_info {
 #define SUMO_GFXPOWERGATINGT_DFLT  100
 
 /* sumo_dpm.c */
+struct sumo_power_info *sumo_get_pi(struct radeon_device *rdev);
+
 void sumo_gfx_clockgating_initialize(struct radeon_device *rdev);
 void sumo_program_vc(struct radeon_device *rdev, u32 vrc);
 void sumo_clear_vc(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/sumo_smc.c b/drivers/gpu/drm/radeon/sumo_smc.c
index fb081d2..05ed103 100644
--- a/drivers/gpu/drm/radeon/sumo_smc.c
+++ b/drivers/gpu/drm/radeon/sumo_smc.c
@@ -31,8 +31,6 @@
 #define SUMO_SMU_SERVICE_ROUTINE_ALTVDDNB_NOTIFY  27
 #define SUMO_SMU_SERVICE_ROUTINE_GFX_SRV_ID_20  20
 
-struct sumo_power_info *sumo_get_pi(struct radeon_device *rdev);
-
 static void sumo_send_msg_to_smu(struct radeon_device *rdev, u32 id)
 {
 	u32 gfx_int_req;
-- 
1.7.9.5

