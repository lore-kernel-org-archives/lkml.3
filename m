Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab3KHCXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:23:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab3KHCWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:22:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 58/91] drm/radeon/atom: workaround vbios bug in transmitter table on rs780
Date: Thu,  7 Nov 2013 18:15:13 -0800
Message-Id: <1383876946-2396-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c23632d4e57c0dd20bf50eca08fa0eb8ad3ff680 upstream.

Some rs780 asics seem to be affected as well.

See:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=91f3a6aaf280294b07c05dfe606e6c27b7ba3c72

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=60791

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 3b681de..e4f56ac 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1641,7 +1641,7 @@ radeon_atom_encoder_dpms_dig(struct drm_encoder *encoder, int mode)
 			 * does the same thing and more.
 			 */
 			if ((rdev->family != CHIP_RV710) && (rdev->family != CHIP_RV730) &&
-			    (rdev->family != CHIP_RS880))
+			    (rdev->family != CHIP_RS780) && (rdev->family != CHIP_RS880))
 				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
 		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {
-- 
1.8.1.2

