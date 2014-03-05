Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbaCEOa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:30:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41339 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbaCEO10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:27:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 126/131] drm/radeon: print the supported atpx function mask
Date: Wed,  5 Mar 2014 14:24:10 +0000
Message-Id: <1394029455-23128-127-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9f050c7f9738ffa746c63415136645ad231b1348 upstream.

Print the supported functions mask in addition to
the version.  This is useful in debugging PX
problems since we can see what functions are available.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atpx_handler.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
index d96070b..cbb06d7 100644
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -215,7 +215,8 @@ static int radeon_atpx_verify_interface(struct radeon_atpx *atpx)
 	memcpy(&output, info->buffer.pointer, size);
 
 	/* TODO: check version? */
-	printk("ATPX version %u\n", output.version);
+	printk("ATPX version %u, functions 0x%08x\n",
+	       output.version, output.function_bits);
 
 	radeon_atpx_parse_functions(&atpx->functions, output.function_bits);
 
-- 
1.9.0

