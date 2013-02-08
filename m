Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945990Ab3BHBAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:00:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422729Ab3BHA6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 02/16] drm/radeon: add quirk for RV100 board
Date: Thu,  7 Feb 2013 16:58:01 -0800
Message-Id: <20130208004627.517621977@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.112511141@linuxfoundation.org>
References: <20130208004627.112511141@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9200ee4941a6e5d1ec5df88982243686882dff3f upstream.

vbios says external TMDS while the board is actually
internal TMDS.

fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=60037

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_combios.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -2338,6 +2338,14 @@ bool radeon_get_legacy_connector_info_fr
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


