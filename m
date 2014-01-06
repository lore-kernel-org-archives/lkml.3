Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaAFQXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:23:39 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39883 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbaAFQXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:23:36 -0500
Date: Mon, 6 Jan 2014 21:53:31 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 63/85] drivers: gpu: Include appropriate header file in
 trinity_dpm.c
Message-ID: <286e8c91eae97ea9ad522957d06954b2519ff394.1389018325.git.rashika.kheria@gmail.com>
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

Include header file drm/radeon/radeon_asic.h in drm/radeon/trinity_dpm.c
because it uses function declared in the header file.

This eliminates the following warnings in drm/radeon/trinity_dpm.c:
drivers/gpu/drm/radeon/trinity_dpm.c:1071:6: warning: no previous prototype for ‘trinity_dpm_enable_bapm’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1082:5: warning: no previous prototype for ‘trinity_dpm_enable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1124:6: warning: no previous prototype for ‘trinity_dpm_disable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1174:5: warning: no previous prototype for ‘trinity_dpm_force_performance_level’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1205:5: warning: no previous prototype for ‘trinity_dpm_pre_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1220:5: warning: no previous prototype for ‘trinity_dpm_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1245:6: warning: no previous prototype for ‘trinity_dpm_post_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1253:6: warning: no previous prototype for ‘trinity_dpm_setup_asic’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1572:6: warning: no previous prototype for ‘trinity_dpm_display_configuration_changed’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1858:5: warning: no previous prototype for ‘trinity_dpm_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1899:6: warning: no previous prototype for ‘trinity_dpm_print_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1917:6: warning: no previous prototype for ‘trinity_dpm_debugfs_print_current_performance_level’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1938:6: warning: no previous prototype for ‘trinity_dpm_fini’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1951:5: warning: no previous prototype for ‘trinity_dpm_get_sclk’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1962:5: warning: no previous prototype for ‘trinity_dpm_get_mclk’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/trinity_dpm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/trinity_dpm.c b/drivers/gpu/drm/radeon/trinity_dpm.c
index 83778b6..2aacc13 100644
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -23,6 +23,7 @@
 
 #include "drmP.h"
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "trinityd.h"
 #include "r600_dpm.h"
 #include "trinity_dpm.h"
-- 
1.7.9.5

