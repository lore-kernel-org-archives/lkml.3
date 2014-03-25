Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaCYRSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:18:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55695 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaCYRSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:18:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 76/81] drm/radeon: print the supported atpx function mask
Date: Tue, 25 Mar 2014 10:16:29 -0700
Message-Id: <1395767794-5012-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9f050c7f9738ffa746c63415136645ad231b1348 upstream.

Print the supported functions mask in addition to
the version.  This is useful in debugging PX
problems since we can see what functions are available.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.3.2

