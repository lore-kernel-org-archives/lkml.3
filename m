Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124Ab3HIP6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:58:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:52598 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934068Ab3HIP6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:58:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,846,1367996400"; 
   d="scan'208";a="384496515"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, airlied@linux.ie,
        alexander.deucher@amd.com
Subject: [PATCH] radeon: Use Linux division macro in si_calculate_leakage_for_v_and_t_formula
Date: Fri,  9 Aug 2013 08:58:27 -0700
Message-Id: <1376063907-7770-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This fixes my 32bit build which failed with:

drivers/built-in.o: In function
`si_calculate_leakage_for_v_and_t_formula':
/home/ak/lsrc/git/linux-2.6/drivers/gpu/drm/radeon/si_dpm.c:1770:
undefined reference to `__divdi3'

Cc: airlied@linux.ie
Cc: alexander.deucher@amd.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/gpu/drm/radeon/si_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index 7ad22e8..4182557 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -1767,7 +1767,7 @@ static void si_calculate_leakage_for_v_and_t_formula(const struct ni_leakage_coe
 	s64 temperature, t_slope, t_intercept, av, bv, t_ref;
 	s64 tmp;
 
-	i_leakage = drm_int2fixp(ileakage) / 100;
+	i_leakage = div64_s64(drm_int2fixp(ileakage), 100);
 	vddc = div64_s64(drm_int2fixp(v), 1000);
 	temperature = div64_s64(drm_int2fixp(t), 1000);
 
-- 
1.8.3.1

