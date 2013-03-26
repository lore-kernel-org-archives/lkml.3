Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881Ab3CZPsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:48:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53869 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965125Ab3CZPWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 077/150] drm/radeon: add support for Richland APUs
Date: Tue, 26 Mar 2013 15:19:36 +0000
Message-Id: <1364311249-14454-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e4d170633fde379f39a90f8a5e7eb619b5d1144d upstream.

Richland APUs are a new version of the Trinity APUs
with performance and power management improvements.

Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/ni.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index c3abd25..0aa705e 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -466,13 +466,19 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 		    (rdev->pdev->device == 0x9907) ||
 		    (rdev->pdev->device == 0x9908) ||
 		    (rdev->pdev->device == 0x9909) ||
+		    (rdev->pdev->device == 0x990B) ||
+		    (rdev->pdev->device == 0x990C) ||
+		    (rdev->pdev->device == 0x990F) ||
 		    (rdev->pdev->device == 0x9910) ||
-		    (rdev->pdev->device == 0x9917)) {
+		    (rdev->pdev->device == 0x9917) ||
+		    (rdev->pdev->device == 0x9999)) {
 			rdev->config.cayman.max_simds_per_se = 6;
 			rdev->config.cayman.max_backends_per_se = 2;
 		} else if ((rdev->pdev->device == 0x9903) ||
 			   (rdev->pdev->device == 0x9904) ||
 			   (rdev->pdev->device == 0x990A) ||
+			   (rdev->pdev->device == 0x990D) ||
+			   (rdev->pdev->device == 0x990E) ||
 			   (rdev->pdev->device == 0x9913) ||
 			   (rdev->pdev->device == 0x9918)) {
 			rdev->config.cayman.max_simds_per_se = 4;
@@ -481,6 +487,9 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 			   (rdev->pdev->device == 0x9990) ||
 			   (rdev->pdev->device == 0x9991) ||
 			   (rdev->pdev->device == 0x9994) ||
+			   (rdev->pdev->device == 0x9995) ||
+			   (rdev->pdev->device == 0x9996) ||
+			   (rdev->pdev->device == 0x999A) ||
 			   (rdev->pdev->device == 0x99A0)) {
 			rdev->config.cayman.max_simds_per_se = 3;
 			rdev->config.cayman.max_backends_per_se = 1;
-- 
1.8.1.2

