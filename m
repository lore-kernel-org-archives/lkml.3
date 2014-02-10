Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaBJTqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:46:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34898 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbaBJTp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:45:58 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 100/124] drm/radeon/DCE4+: clear bios scratch dpms bit (v2)
Date: Mon, 10 Feb 2014 11:40:40 -0800
Message-Id: <1392061264-28124-101-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6802d4bad83f50081b2788698570218aaff8d10e upstream.

The BlankCrtc table in some DCE8 boards has some
logic shortcuts for the vbios when this bit is set.
Clear it for driver use.

v2: fix typo

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=73420

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 6048f2b..9e134ea 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2821,6 +2821,10 @@ void radeon_atom_initialize_bios_scratch_regs(struct drm_device *dev)
 	/* tell the bios not to handle mode switching */
 	bios_6_scratch |= ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH;
 
+	/* clear the vbios dpms state */
+	if (ASIC_IS_DCE4(rdev))
+		bios_2_scratch &= ~ATOM_S2_DEVICE_DPMS_STATE;
+
 	if (rdev->family >= CHIP_R600) {
 		WREG32(R600_BIOS_2_SCRATCH, bios_2_scratch);
 		WREG32(R600_BIOS_6_SCRATCH, bios_6_scratch);
-- 
1.8.3.2

