Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbaJIVii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:38:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59186 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344AbaJIVIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 038/163] drm/radeon: add connector quirk for fujitsu board
Date: Thu,  9 Oct 2014 14:01:03 -0700
Message-Id: <1412888588-26755-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1952f24d0fa6292d65f886887af87ba8ac79b3ba upstream.

Vbios connector table lists non-existent VGA port.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=83184

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 4af5a78..9e53064 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -464,6 +464,13 @@ static bool radeon_atom_apply_quirks(struct drm_device *dev,
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

