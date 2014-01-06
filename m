Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbaAFQ1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:27:25 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38225 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbaAFQ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:27:23 -0500
Date: Mon, 6 Jan 2014 21:57:19 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 65/85] drivers: gpu: Include appropriate header file in
 ni_dpm.c
Message-ID: <00692ccca0b1b0b44157359671b873e79f70d5f1.1389018325.git.rashika.kheria@gmail.com>
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

Include header file drm/radeon/radeon_asic.h in drm/radeon/ni_dpm.c
because it uses function declared in the header file.

This elimiantes the following warnings in drm/radeon/ni_dpm.c:
drivers/gpu/drm/radeon/ni_dpm.c:1073:5: warning: no previous prototype for ‘ni_dpm_force_performance_level’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:3565:6: warning: no previous prototype for ‘ni_dpm_setup_asic’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:3602:5: warning: no previous prototype for ‘ni_dpm_enable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:3735:6: warning: no previous prototype for ‘ni_dpm_disable’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:3797:5: warning: no previous prototype for ‘ni_dpm_pre_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:3810:5: warning: no previous prototype for ‘ni_dpm_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:3889:6: warning: no previous prototype for ‘ni_dpm_post_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:4079:5: warning: no previous prototype for ‘ni_dpm_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:4296:6: warning: no previous prototype for ‘ni_dpm_fini’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:4309:6: warning: no previous prototype for ‘ni_dpm_print_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:4331:6: warning: no previous prototype for ‘ni_dpm_debugfs_print_current_performance_level’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:4351:5: warning: no previous prototype for ‘ni_dpm_get_sclk’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:4362:5: warning: no previous prototype for ‘ni_dpm_get_mclk’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/ni_dpm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/ni_dpm.c b/drivers/gpu/drm/radeon/ni_dpm.c
index 97aa32f..63ad349 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -23,6 +23,7 @@
 
 #include "drmP.h"
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "nid.h"
 #include "r600_dpm.h"
 #include "ni_dpm.h"
-- 
1.7.9.5

