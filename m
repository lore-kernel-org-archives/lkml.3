Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaEURjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:39:54 -0400
Received: from mout.gmx.net ([212.227.17.22]:64464 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaEURjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:39:51 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: alexander.deucher@amd.com
Cc: christian.koenig@amd.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] radeon: Use time_before()
Date: Wed, 21 May 2014 19:39:37 +0200
Message-Id: <1400693977-21033-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:htf19H13FQhwZyXDqkzZa8eOYOLmHJvCQjrY487i/PrHBVzStPz
 zLSXhaXbJj936mrLKEbGquyVauDOf371fsa7+qFhvnYRocJAJpZVuEm9GNNNa8WeN5kSGo5
 bgKZSws33F1be+QDKxN4+dq2i4lpECIvYhu7X3vjqR5Y6n4EgI+A0DchTzgPy3TPMF8clTW
 mhHHOTWRXU6N7z8mG46gg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_before() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/gpu/drm/radeon/radeon_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index f30b842..b08db66 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1592,7 +1592,7 @@ static void radeon_dynpm_idle_work_handler(struct work_struct *work)
 		 * to false since we want to wait for vbl to avoid flicker.
 		 */
 		if (rdev->pm.dynpm_planned_action != DYNPM_ACTION_NONE &&
-		    jiffies > rdev->pm.dynpm_action_timeout) {
+		    time_before(rdev->pm.dynpm_action_timeout, jiffies)) {
 			radeon_pm_get_dynpm_state(rdev);
 			radeon_pm_set_clocks(rdev);
 		}
-- 
1.7.10.4

