Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaKFWkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:40:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58615 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKFWkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:40:04 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 144/162] drm/radeon/dpm: disable ulv support on SI
Date: Thu,  6 Nov 2014 14:36:48 -0800
Message-Id: <1415313426-9622-145-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6fa455935ab956248b165f150ec6ae9106210077 upstream.

Causes problems on some boards.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=82889

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/si_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index 0d50df3..b044e19 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -6224,7 +6224,7 @@ static void si_parse_pplib_clock_info(struct radeon_device *rdev,
 	if ((rps->class2 & ATOM_PPLIB_CLASSIFICATION2_ULV) &&
 	    index == 0) {
 		/* XXX disable for A0 tahiti */
-		si_pi->ulv.supported = true;
+		si_pi->ulv.supported = false;
 		si_pi->ulv.pl = *pl;
 		si_pi->ulv.one_pcie_lane_in_ulv = false;
 		si_pi->ulv.volt_change_delay = SISLANDS_ULVVOLTAGECHANGEDELAY_DFLT;
-- 
1.9.1

