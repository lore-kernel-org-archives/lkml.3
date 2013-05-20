Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3ETLMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:12:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56147 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab3ETKxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 051/115] drm/radeon: use frac fb div on RS780/RS880
Date: Mon, 20 May 2013 11:50:51 +0100
Message-Id: <1369047116-9378-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 411678288d61ba17afe1f8afed92200be6bbc65d upstream.

Monitors seem to prefer it.  Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=37696

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.5:
  - adjust context
  - use pll->flags instead of radeon_crtc->pll_flags ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 08b71a3..c4e646f 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -573,6 +573,9 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
 		/* use frac fb div on APUs */
 		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE61(rdev))
 			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
+		/* use frac fb div on RS780/RS880 */
+		if ((rdev->family == CHIP_RS780) || (rdev->family == CHIP_RS880))
+			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 		if (ASIC_IS_DCE32(rdev) && mode->clock > 165000)
 			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 	} else {
-- 
1.8.1.2

