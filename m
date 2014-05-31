Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbaEaXJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 19:09:14 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:37303 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbaEaXJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 19:09:13 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: radeon: r600_cp.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 01:10:05 +0200
Message-Id: <1401577805-4609-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/r600_cp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/r600_cp.c b/drivers/gpu/drm/radeon/r600_cp.c
index 8c9b7e2..0770ad6 100644
--- a/drivers/gpu/drm/radeon/r600_cp.c
+++ b/drivers/gpu/drm/radeon/r600_cp.c
@@ -2615,7 +2615,7 @@ int r600_cs_legacy_ioctl(struct drm_device *dev, void *data, struct drm_file *fp
 	struct drm_radeon_cs *cs = data;
 	struct drm_buf *buf;
 	unsigned family;
-	int l, r = 0;
+	int l = 0, r = 0;
 	u32 *ib, cs_id = 0;
 
 	if (dev_priv == NULL) {
-- 
1.7.10.4

