Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608AbaHHVFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:05:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41338 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094AbaHHUxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 093/259] drm/radeon/dp: return -EIO for flags not zero case
Date: Fri,  8 Aug 2014 13:38:36 -0700
Message-Id: <1407530482-4483-94-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f6be5e64500abbba44e191e1ca0f3366c7d0291b upstream.

If there are error flags in the aux transaction return
-EIO rather than -EBUSY.  -EIO restarts the whole transaction
while -EBUSY jus retries.  Fixes problematic aux transfers.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=80684

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ kamal: backport to 3.13-stable (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index a1a0350..514a623 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -123,7 +123,7 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 	/* flags not zero */
 	if (args.v1.ucReplyStatus == 2) {
 		DRM_DEBUG_KMS("dp_aux_ch flags not zero\n");
-		return -EBUSY;
+		return -EIO;
 	}
 
 	/* error */
-- 
1.9.1

