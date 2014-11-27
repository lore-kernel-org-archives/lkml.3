Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaK0Iq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:41448 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666AbaK0Iqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:54 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 23/91] drm/radeon: add connector quirk for fujitsu board
Date: Thu, 27 Nov 2014 16:42:06 +0800
Message-Id: <1417077794-9299-23-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 1952f24d0fa6292d65f886887af87ba8ac79b3ba upstream.

Vbios connector table lists non-existent VGA port.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=83184

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 6d0c32b..1ce6743 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -463,6 +463,13 @@ static bool radeon_atom_apply_quirks(struct drm_device *dev,
 		}
 	}
 
+	/* Fujitsu D3003-S2 board lists DVI-I as DVI-I and VGA */
+	if ((dev->pdev->device == 0x9805) &&
+	    (dev->pdev->subsystem_vendor == 0x1734) &&
+	    (dev->pdev->subsystem_device == 0x11bd)) {
+		if (*connector_type == DRM_MODE_CONNECTOR_VGA)
+			return false;
+	}
 
 	return true;
 }
-- 
1.9.1

