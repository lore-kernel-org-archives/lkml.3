Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab3ERDRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:17:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628Ab3ERDAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:12 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jbgDHDAJ6iYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=I9mfkFfkhkMA:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021701.643460691@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:18:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [ 125/136 ] drm/radeon: cleanup properly if mmio mapping fails
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0125-drm-radeon-cleanup-properly-if-mmio-mapping-fails.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 0cd9cb76ae26a19df21abc6f94f5fff141e689c7 ]

If we fail to map the mmio BAR, skip driver tear down
that requires mmio.

Should fix:
https://bugzilla.kernel.org/show_bug.cgi?id=56541

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/radeon_kms.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 414b4ac..e32f4c2 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -51,8 +51,12 @@ int radeon_driver_unload_kms(struct drm_device *dev)
 
 	if (rdev == NULL)
 		return 0;
+	if (rdev->rmmio == NULL)
+		goto done_free;
 	radeon_modeset_fini(rdev);
 	radeon_device_fini(rdev);
+
+done_free:
 	kfree(rdev);
 	dev->dev_private = NULL;
 	return 0;
-- 
1.7.10.4


