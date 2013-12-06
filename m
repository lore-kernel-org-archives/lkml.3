Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278Ab3LFXsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:48:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48421 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161369Ab3LFXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 044/152] drm/radeon: don't share PPLLs on DCE4.1
Date: Fri,  6 Dec 2013 15:09:28 -0800
Message-Id: <1386371476-2477-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 70471860ff9f335c60c004d42ebd48945bfa5403 upstream.

Sharing PPLLs seems to cause problems on some boards.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=45334

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 6d6fdb3..ef32bf6 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1683,7 +1683,7 @@ static int radeon_atom_pick_pll(struct drm_crtc *crtc)
 				if (pll != ATOM_PPLL_INVALID)
 					return pll;
 			}
-		} else {
+		} else if (!ASIC_IS_DCE41(rdev)) { /* Don't share PLLs on DCE4.1 chips */
 			/* use the same PPLL for all monitors with the same clock */
 			pll = radeon_get_shared_nondp_ppll(crtc);
 			if (pll != ATOM_PPLL_INVALID)
-- 
1.8.3.2

