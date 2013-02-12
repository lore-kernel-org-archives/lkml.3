Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab3BLELr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:11:47 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:32987 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab3BLELo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:11:44 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Cyril Roelandt <tipecaml@gmail.com>, airlied@linux.ie,
        alexander.deucher@amd.com, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, mattst88@gmail.com,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/5] radeon: Remove redundant NULL check before radeon_i2c_destroy().
Date: Tue, 12 Feb 2013 05:01:49 +0100
Message-Id: <1360641713-24895-2-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360641713-24895-1-git-send-email-tipecaml@gmail.com>
References: <1360641713-24895-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radeon_i2c_destroy on a NULL pointer is a no-op.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/gpu/drm/radeon/radeon_i2c.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
index fc60b74..850df44 100644
--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -1032,10 +1032,8 @@ void radeon_i2c_fini(struct radeon_device *rdev)
 	int i;
 
 	for (i = 0; i < RADEON_MAX_I2C_BUS; i++) {
-		if (rdev->i2c_bus[i]) {
-			radeon_i2c_destroy(rdev->i2c_bus[i]);
-			rdev->i2c_bus[i] = NULL;
-		}
+		radeon_i2c_destroy(rdev->i2c_bus[i]);
+		rdev->i2c_bus[i] = NULL;
 	}
 }
 
-- 
1.7.10.4

