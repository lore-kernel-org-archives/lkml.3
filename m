Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaDALSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:18:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42558 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaDALSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 095/144] drm/radeon/cik: properly set sdma ring status on disable
Date: Tue,  1 Apr 2014 12:14:59 +0100
Message-Id: <1396350948-29910-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7b1bbe883b3ed962ca2be4daf321f318f5091340 upstream.

When we disable the rings, set the status properly.  If
not other code pathes may try and use the rings which are
not functional at this point.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.11:
  - cik_sdma_gfx_stop() is defined in file cik.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 8748a86..405bf0c 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -3349,6 +3349,8 @@ static void cik_sdma_gfx_stop(struct radeon_device *rdev)
 		WREG32(SDMA0_GFX_RB_CNTL + reg_offset, rb_cntl);
 		WREG32(SDMA0_GFX_IB_CNTL + reg_offset, 0);
 	}
+	rdev->ring[R600_RING_TYPE_DMA_INDEX].ready = false;
+	rdev->ring[CAYMAN_RING_TYPE_DMA1_INDEX].ready = false;
 }
 
 /**
-- 
1.9.1

