Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3BQWy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:54:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45585 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305Ab3BQWy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:54:56 -0500
Message-Id: <20130217225002.629212055@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:09 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 08/66] drm/radeon: add quirk for RV100 board
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9200ee4941a6e5d1ec5df88982243686882dff3f upstream.

vbios says external TMDS while the board is actually
internal TMDS.

fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=60037

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_combios.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index 33a56a0..3e403bd 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -2470,6 +2470,14 @@ bool radeon_get_legacy_connector_info_from_bios(struct drm_device *dev)
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


