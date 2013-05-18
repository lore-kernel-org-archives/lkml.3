Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab3ERDPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:15:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514Ab3ERDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:14 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=T-D9Bi_8fWQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=79GgubLCDQgA:10 a=zd2uoN0lAAAA:8 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021700.407962268@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [ 117/136 ] drm/radeon: use frac fb div on RS780/RS880
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0117-drm-radeon-use-frac-fb-div-on-RS780-RS880.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 411678288d61ba17afe1f8afed92200be6bbc65d ]

Monitors seem to prefer it.  Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=37696

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/atombios_crtc.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 2817101..3a3d3f8 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -569,6 +569,9 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
 		/* use frac fb div on APUs */
 		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE61(rdev))
 			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
+		/* use frac fb div on RS780/RS880 */
+		if ((rdev->family == CHIP_RS780) || (rdev->family == CHIP_RS880))
+			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 	} else {
 		pll->flags |= RADEON_PLL_LEGACY;
 
-- 
1.7.10.4


