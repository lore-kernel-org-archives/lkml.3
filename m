Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaAFQSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:18:33 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:60002 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbaAFQSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:18:32 -0500
Date: Mon, 6 Jan 2014 21:48:27 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 60/85] drivers: gpu: Include appropriate header file in
 sumo_dpm.c
Message-ID: <f44e8b4dea8e51446b540ebb5d7e7aea715d5614.1389018325.git.rashika.kheria@gmail.com>
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

Include header file drm/radeon/radeon_asic.h because it uses the
function declared in the header file.

This eliminates the following warnings in drm/radeon/sumo_dpm.c:
drivers/gpu/drm/radeon/sumo_dpm.c:1202:5: warning: no previous prototype for ‘sumo_dpm_enable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1250:6: warning: no previous prototype for ‘sumo_dpm_disable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1273:5: warning: no previous prototype for ‘sumo_dpm_pre_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1289:5: warning: no previous prototype for ‘sumo_dpm_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1325:6: warning: no previous prototype for ‘sumo_dpm_post_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1345:6: warning: no previous prototype for ‘sumo_dpm_setup_asic’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1357:6: warning: no previous prototype for ‘sumo_dpm_display_configuration_changed’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1731:5: warning: no previous prototype for ‘sumo_dpm_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1781:6: warning: no previous prototype for ‘sumo_dpm_print_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1799:6: warning: no previous prototype for ‘sumo_dpm_debugfs_print_current_performance_level’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1827:6: warning: no previous prototype for ‘sumo_dpm_fini’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1840:5: warning: no previous prototype for ‘sumo_dpm_get_sclk’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1851:5: warning: no previous prototype for ‘sumo_dpm_get_mclk’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1858:5: warning: no previous prototype for ‘sumo_dpm_force_performance_level’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/sumo_dpm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/sumo_dpm.c b/drivers/gpu/drm/radeon/sumo_dpm.c
index eb2e8e6..09cd0cf 100644
--- a/drivers/gpu/drm/radeon/sumo_dpm.c
+++ b/drivers/gpu/drm/radeon/sumo_dpm.c
@@ -23,6 +23,7 @@
 
 #include "drmP.h"
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "sumod.h"
 #include "r600_dpm.h"
 #include "cypress_dpm.h"
-- 
1.7.9.5

