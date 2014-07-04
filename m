Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbaGDThQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:37:16 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:48385 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644AbaGDThO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:37:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvMMAD4Bt1NbsGwr/2dsb2JhbABagw6scAUBAQEBAQEFAW4BkiiHP4ELF3WECwIkLyOBCRE3iEYBtU6VCxeFcIkyHYQtBZgKgmyUDINFOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Alex Deucher <alexander.deucher@amd.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 1/1] drm/radeon: remove null test before kfree
Date: Fri,  4 Jul 2014 21:37:09 +0200
Message-Id: <1404502629-32229-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/gpu/drm/radeon/radeon_pm.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index e447e39..a06afee 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1400,9 +1400,7 @@ static void radeon_pm_fini_old(struct radeon_device *rdev)
 	}
 
 	radeon_hwmon_fini(rdev);
-
-	if (rdev->pm.power_state)
-		kfree(rdev->pm.power_state);
+	kfree(rdev->pm.power_state);
 }
 
 static void radeon_pm_fini_dpm(struct radeon_device *rdev)
@@ -1421,9 +1419,7 @@ static void radeon_pm_fini_dpm(struct radeon_device *rdev)
 	radeon_dpm_fini(rdev);
 
 	radeon_hwmon_fini(rdev);
-
-	if (rdev->pm.power_state)
-		kfree(rdev->pm.power_state);
+	kfree(rdev->pm.power_state);
 }
 
 void radeon_pm_fini(struct radeon_device *rdev)
-- 
1.9.1

