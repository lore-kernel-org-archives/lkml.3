Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab3KIGvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:51:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab3KIGvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 69/74] drm/radeon/atom: workaround vbios bug in transmitter table on rs780
Date: Fri,  8 Nov 2013 22:52:14 -0800
Message-Id: <20131109065118.311726184@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c23632d4e57c0dd20bf50eca08fa0eb8ad3ff680 upstream.

Some rs780 asics seem to be affected as well.

See:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=91f3a6aaf280294b07c05dfe606e6c27b7ba3c72

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=60791

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_encoders.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1641,7 +1641,7 @@ radeon_atom_encoder_dpms_dig(struct drm_
 			 * does the same thing and more.
 			 */
 			if ((rdev->family != CHIP_RV710) && (rdev->family != CHIP_RV730) &&
-			    (rdev->family != CHIP_RS880))
+			    (rdev->family != CHIP_RS780) && (rdev->family != CHIP_RS880))
 				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
 		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {


