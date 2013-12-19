Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab3LSMWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:22:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45101 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3LSL6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 140/208] drm/radeon: fix typo in fetching mpll params
Date: Thu, 19 Dec 2013 11:53:58 +0000
Message-Id: <1387454106-19326-141-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 180f805f4f03b2894701f9831b4e96a308330b22 upstream.

Copy-paste typo.  Value should be 0-2, not 0-1.

Noticed-by: Sylvain BERTRAND <sylware@legeek.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 11dc5c8..2ab4b35 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2879,7 +2879,7 @@ int radeon_atom_get_memory_pll_dividers(struct radeon_device *rdev,
 			mpll_param->dll_speed = args.ucDllSpeed;
 			mpll_param->bwcntl = args.ucBWCntl;
 			mpll_param->vco_mode =
-				(args.ucPllCntlFlag & MPLL_CNTL_FLAG_VCO_MODE_MASK) ? 1 : 0;
+				(args.ucPllCntlFlag & MPLL_CNTL_FLAG_VCO_MODE_MASK);
 			mpll_param->yclk_sel =
 				(args.ucPllCntlFlag & MPLL_CNTL_FLAG_BYPASS_DQ_PLL) ? 1 : 0;
 			mpll_param->qdr =
-- 
1.8.3.2

