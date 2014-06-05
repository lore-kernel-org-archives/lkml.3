Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaFEEfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:35:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaFEEVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 160/214] drm/radeon/dce32+: use fractional fb dividers for high clocks
Date: Wed,  4 Jun 2014 21:18:43 -0700
Message-Id: <20140605041701.160045283@linuxfoundation.org>
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

commit a02dc74b317d78298cb0587b9b1f6f741fd5c139 upstream.

Fixes flickering with some high res montiors.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: use pll->flags instead of radeon_crtc->pll_flags]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -573,6 +573,8 @@ static u32 atombios_adjust_pll(struct dr
 		/* use frac fb div on APUs */
 		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE61(rdev))
 			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
+		if (ASIC_IS_DCE32(rdev) && mode->clock > 165000)
+			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 	} else {
 		pll->flags |= RADEON_PLL_LEGACY;
 


