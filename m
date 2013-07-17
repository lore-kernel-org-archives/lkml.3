Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044Ab3GQXNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:13:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56640 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964941Ab3GQWzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 094/145] drm/radeon: add backlight quirk for hybrid mac
Date: Wed, 17 Jul 2013 15:47:06 -0700
Message-Id: <1374101277-7915-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 80101790670385a85aca35ecae4b89e3f2fceecc upstream.

Mac laptops with multiple GPUs apparently use the gmux
driver for backlight control.  Don't register a radeon
backlight interface.  We may need to add other pci ids
for other hybrid mac laptops.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=65377

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 6cf2b52..8efd7e2 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -186,6 +186,13 @@ void radeon_atom_backlight_init(struct radeon_encoder *radeon_encoder,
 	u8 backlight_level;
 	char bl_name[16];
 
+	/* Mac laptops with multiple GPUs use the gmux driver for backlight
+	 * so don't register a backlight device
+	 */
+	if ((rdev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE) &&
+	    (rdev->pdev->device == 0x6741))
+		return;
+
 	if (!radeon_encoder->enc_priv)
 		return;
 
-- 
1.8.1.2

