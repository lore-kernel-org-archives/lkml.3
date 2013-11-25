Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab3KYOGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:06:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58939 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232Ab3KYNxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:46 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.569359192@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 76/87] drm/radeon/atom: workaround vbios bug in
 transmitter table on rs780
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c23632d4e57c0dd20bf50eca08fa0eb8ad3ff680 upstream.

Some rs780 asics seem to be affected as well.

See:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=91f3a6aaf280294b07c05dfe606e6c27b7ba3c72

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=60791

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1390,7 +1390,7 @@ radeon_atom_encoder_dpms_dig(struct drm_
 			 * does the same thing and more.
 			 */
 			if ((rdev->family != CHIP_RV710) && (rdev->family != CHIP_RV730) &&
-			    (rdev->family != CHIP_RS880))
+			    (rdev->family != CHIP_RS780) && (rdev->family != CHIP_RS880))
 				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
 		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {

