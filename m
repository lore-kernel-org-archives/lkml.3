Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab3BSSu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:50:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54191 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372Ab3BSSuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:51 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 14/81] drm/radeon: add quirk for RV100 board
Date: Tue, 19 Feb 2013 15:48:37 -0300
Message-Id: <1361299784-8830-15-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9200ee4941a6e5d1ec5df88982243686882dff3f upstream.

vbios says external TMDS while the board is actually
internal TMDS.

fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=60037

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_combios.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index 558e5c0..7139341 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -2455,6 +2455,14 @@ bool radeon_get_legacy_connector_info_from_bios(struct drm_device *dev)
 								   1),
 								  ATOM_DEVICE_CRT1_SUPPORT);
 				}
+				/* RV100 board with external TDMS bit mis-set.
+				 * Actually uses internal TMDS, clear the bit.
+				 */
+				if (dev->pdev->device == 0x5159 &&
+				    dev->pdev->subsystem_vendor == 0x1014 &&
+				    dev->pdev->subsystem_device == 0x029A) {
+					tmp &= ~(1 << 4);
+				}
 				if ((tmp >> 4) & 0x1) {
 					devices |= ATOM_DEVICE_DFP2_SUPPORT;
 					radeon_add_legacy_encoder(dev,
-- 
1.7.9.5

