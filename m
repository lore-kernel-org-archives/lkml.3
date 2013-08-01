Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab3HAPZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:25:52 -0400
Received: from mail.tpi.com ([74.45.170.26]:2583 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700Ab3HAPZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:25:51 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.11-rc3+] radeon: si_dpm: Fix 32 bit __divdi3 modpost failure
Date: Thu,  1 Aug 2013 09:25:31 -0600
Message-Id: <1375370731-64547-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "__divdi3" [drivers/gpu/drm/radeon/radeon.ko] undefined!
make[3]: *** [__modpost] Error 1

gcc version 4.8.1

Cc: David Airlie <airlied@linux.ie>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/gpu/drm/radeon/si_dpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index 7ad22e87..4182557 100644
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
1.7.9.5

