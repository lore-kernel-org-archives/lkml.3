Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbaAFQ3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:29:34 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39690 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaAFQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:29:32 -0500
Date: Mon, 6 Jan 2014 21:59:27 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 66/85] drivers: gpu: Move prototype declarations to header
 file ni_dpm.h
Message-ID: <bcee335453b754ab22869ae13c0024c9a20ba31b.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declarations of functions ni_get_pi() and ni_get_ps() to
header file drm/radeon/ni_dpm.h because it is used by more than one
file.

This eliminates the following warnings in drm/radeon/ni_dpm.c:
drivers/gpu/drm/radeon/ni_dpm.c:723:23: warning: no previous prototype for ‘ni_get_pi’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ni_dpm.c:730:15: warning: no previous prototype for ‘ni_get_ps’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/ni_dpm.h |    2 ++
 drivers/gpu/drm/radeon/si_dpm.c |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni_dpm.h b/drivers/gpu/drm/radeon/ni_dpm.h
index 6bbee91..876aaf2 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.h
+++ b/drivers/gpu/drm/radeon/ni_dpm.h
@@ -231,6 +231,8 @@ struct ni_power_info {
 #define NISLANDS_DPM2_SQ_RAMP_STI_SIZE                  0x1E
 #define NISLANDS_DPM2_SQ_RAMP_LTI_RATIO                 0xF
 
+struct ni_power_info *ni_get_pi(struct radeon_device *rdev);
+struct ni_ps *ni_get_ps(struct radeon_ps *rps);
 int ni_copy_and_switch_arb_sets(struct radeon_device *rdev,
 				u32 arb_freq_src, u32 arb_freq_dest);
 void ni_update_current_ps(struct radeon_device *rdev,
diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index 8732005..8ce849e 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -1734,9 +1734,6 @@ static const struct si_powertune_data powertune_data_hainan =
 	true
 };
 
-struct ni_power_info *ni_get_pi(struct radeon_device *rdev);
-struct ni_ps *ni_get_ps(struct radeon_ps *rps);
-
 static int si_populate_voltage_value(struct radeon_device *rdev,
 				     const struct atom_voltage_table *table,
 				     u16 value, SISLANDS_SMC_VOLTAGE_VALUE *voltage);
-- 
1.7.9.5

