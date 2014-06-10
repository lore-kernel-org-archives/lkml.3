Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaFJTrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:47:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34972 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaFJTrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:47:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 079/160] drm/radeon: don't allow runpm=1 on systems with out ATPX
Date: Tue, 10 Jun 2014 12:45:19 -0700
Message-Id: <1402429600-20477-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 73acacc7397fe854ed2ab75f1c940fa00faaf15e upstream.

vgaswitcheroo and the ATPX ACPI methods are required to
power down the dGPU.

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=73901

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_kms.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 9b2799c..e0315d2 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -107,11 +107,9 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
 		flags |= RADEON_IS_PCI;
 	}
 
-	if (radeon_runtime_pm == 1)
-		flags |= RADEON_IS_PX;
-	else if ((radeon_runtime_pm == -1) &&
-		 radeon_has_atpx() &&
-		 ((flags & RADEON_IS_IGP) == 0))
+	if ((radeon_runtime_pm != 0) &&
+	    radeon_has_atpx() &&
+	    ((flags & RADEON_IS_IGP) == 0))
 		flags |= RADEON_IS_PX;
 
 	/* radeon_device_init should report only fatal error
-- 
1.9.1

