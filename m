Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaAFQdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:33:13 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:34310 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaAFQdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:33:12 -0500
Date: Mon, 6 Jan 2014 22:03:03 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 69/85] drivers: gpu: Move prototype declarations to header
 file si_dpm.h
Message-ID: <6e70b39b20fe5bb12e96306368b3f8eeacda08b8.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declarations of functions
si_get_ddr3_mclk_frequency_ratio(), si_get_mclk_frequency_ratio()
and si_trim_voltage_table_to_fit_state_table() to header file
drm/radeon/si_dpm.h because they are used by more than one file.

This eliminates the following warnings from drm/radeon/si_dpm.c:
drivers/gpu/drm/radeon/si_dpm.c:3698:4: warning: no previous prototype for ‘si_get_ddr3_mclk_frequency_ratio’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_dpm.c:3711:4: warning: no previous prototype for ‘si_get_mclk_frequency_ratio’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si_dpm.c:3793:6: warning: no previous prototype for ‘si_trim_voltage_table_to_fit_state_table’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/ci_dpm.c |    6 +-----
 drivers/gpu/drm/radeon/si_dpm.h |    7 +++++++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 899c843..7b3c412 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -27,6 +27,7 @@
 #include "cikd.h"
 #include "r600_dpm.h"
 #include "ci_dpm.h"
+#include "si_dpm.h"
 #include "atom.h"
 #include <linux/seq_file.h>
 
@@ -165,11 +166,6 @@ extern void btc_get_max_clock_from_voltage_dependency_table(struct radeon_clock_
 							    u32 *max_clock);
 extern int ni_copy_and_switch_arb_sets(struct radeon_device *rdev,
 				       u32 arb_freq_src, u32 arb_freq_dest);
-extern u8 si_get_ddr3_mclk_frequency_ratio(u32 memory_clock);
-extern u8 si_get_mclk_frequency_ratio(u32 memory_clock, bool strobe_mode);
-extern void si_trim_voltage_table_to_fit_state_table(struct radeon_device *rdev,
-						     u32 max_voltage_steps,
-						     struct atom_voltage_table *voltage_table);
 
 static int ci_get_std_voltage_value_sidd(struct radeon_device *rdev,
 					 struct atom_voltage_table_entry *voltage_table,
diff --git a/drivers/gpu/drm/radeon/si_dpm.h b/drivers/gpu/drm/radeon/si_dpm.h
index 4ce5032..7c65e55 100644
--- a/drivers/gpu/drm/radeon/si_dpm.h
+++ b/drivers/gpu/drm/radeon/si_dpm.h
@@ -194,6 +194,13 @@ struct si_power_info {
 	PP_SIslands_PAPMParameters papm_parm;
 };
 
+u8 si_get_ddr3_mclk_frequency_ratio(u32 memory_clock);
+u8 si_get_mclk_frequency_ratio(u32 memory_clock, bool strobe_mode);
+void si_trim_voltage_table_to_fit_state_table(struct radeon_device *rdev,
+		u32 max_voltage_steps,
+		struct atom_voltage_table *voltage_table);
+
+
 #define SISLANDS_INITIAL_STATE_ARB_INDEX    0
 #define SISLANDS_ACPI_STATE_ARB_INDEX       1
 #define SISLANDS_ULV_STATE_ARB_INDEX        2
-- 
1.7.9.5

