Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaFEEdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:33:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaFEEWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 177/214] drm/radeon: use frac fb div on RS780/RS880
Date: Wed,  4 Jun 2014 21:19:00 -0700
Message-Id: <20140605041703.281660369@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 411678288d61ba17afe1f8afed92200be6bbc65d upstream.

Monitors seem to prefer it.  Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=37696

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Add to pll->flags, not radeon_crtc->pll_flags]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -573,6 +573,9 @@ static u32 atombios_adjust_pll(struct dr
 		/* use frac fb div on APUs */
 		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE61(rdev))
 			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
+		/* use frac fb div on RS780/RS880 */
+		if ((rdev->family == CHIP_RS780) || (rdev->family == CHIP_RS880))
+			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 		if (ASIC_IS_DCE32(rdev) && mode->clock > 165000)
 			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 	} else {


