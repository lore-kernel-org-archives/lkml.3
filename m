Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab3KYN1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:27:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57007 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab3KYNHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 15/78] drm/radeon/atom: workaround vbios bug in transmitter table on rs780
Date: Mon, 25 Nov 2013 13:06:02 +0000
Message-Id: <1385384825-21681-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c23632d4e57c0dd20bf50eca08fa0eb8ad3ff680 upstream.

Some rs780 asics seem to be affected as well.

See:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=91f3a6aaf280294b07c05dfe606e6c27b7ba3c72

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=60791

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 64bc2bd..3c4138f 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1430,7 +1430,7 @@ radeon_atom_encoder_dpms_dig(struct drm_encoder *encoder, int mode)
 			 * does the same thing and more.
 			 */
 			if ((rdev->family != CHIP_RV710) && (rdev->family != CHIP_RV730) &&
-			    (rdev->family != CHIP_RS880))
+			    (rdev->family != CHIP_RS780) && (rdev->family != CHIP_RS880))
 				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
 		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {
-- 
1.8.3.2

