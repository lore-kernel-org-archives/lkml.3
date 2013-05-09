Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab3EIXF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:05:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3EIW0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 45/73] drm/radeon: use frac fb div on RS780/RS880
Date: Thu,  9 May 2013 15:25:35 -0700
Message-Id: <20130509222531.014174867@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 411678288d61ba17afe1f8afed92200be6bbc65d upstream.

Monitors seem to prefer it.  Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=37696

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -557,6 +557,9 @@ static u32 atombios_adjust_pll(struct dr
 		/* use frac fb div on APUs */
 		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE61(rdev))
 			radeon_crtc->pll_flags |= RADEON_PLL_USE_FRAC_FB_DIV;
+		/* use frac fb div on RS780/RS880 */
+		if ((rdev->family == CHIP_RS780) || (rdev->family == CHIP_RS880))
+			radeon_crtc->pll_flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 		if (ASIC_IS_DCE32(rdev) && mode->clock > 165000)
 			radeon_crtc->pll_flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 	} else {


