Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890Ab3DKU2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:28:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32712 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759724Ab3DKU0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:19 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ZtpnZwiyDtEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1uPl0gmC-PsA:10 a=zd2uoN0lAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=wu_e27o_rKQA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202554.698935270@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 052/171 ] drm/radeon: add support for Richland APUs
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0052-drm-radeon-add-support-for-Richland-APUs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit e4d170633fde379f39a90f8a5e7eb619b5d1144d ]

Richland APUs are a new version of the Trinity APUs
with performance and power management improvements.

Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/ni.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 853800e..eecf30f 100644
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
1.7.10.4


