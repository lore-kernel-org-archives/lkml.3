Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab3J2S1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:27:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59223 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3J2SFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 10/81] drm/radeon: fix typo in CP DMA register headers
Date: Tue, 29 Oct 2013 11:03:31 -0700
Message-Id: <1383069882-11437-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit aa3e146d04b6ae37939daeebaec060562b3db559 upstream.

Wrong bit offset for SRC endian swapping.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/evergreend.h | 4 ++--
 drivers/gpu/drm/radeon/r600d.h      | 2 +-
 drivers/gpu/drm/radeon/sid.h        | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreend.h b/drivers/gpu/drm/radeon/evergreend.h
index f410b4d..3f40313 100644
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -1050,7 +1050,7 @@
  * 6. COMMAND [29:22] | BYTE_COUNT [20:0]
  */
 #              define PACKET3_CP_DMA_DST_SEL(x)    ((x) << 20)
-                /* 0 - SRC_ADDR
+                /* 0 - DST_ADDR
 		 * 1 - GDS
 		 */
 #              define PACKET3_CP_DMA_ENGINE(x)     ((x) << 27)
@@ -1065,7 +1065,7 @@
 #              define PACKET3_CP_DMA_CP_SYNC       (1 << 31)
 /* COMMAND */
 #              define PACKET3_CP_DMA_DIS_WC        (1 << 21)
-#              define PACKET3_CP_DMA_CMD_SRC_SWAP(x) ((x) << 23)
+#              define PACKET3_CP_DMA_CMD_SRC_SWAP(x) ((x) << 22)
                 /* 0 - none
 		 * 1 - 8 in 16
 		 * 2 - 8 in 32
diff --git a/drivers/gpu/drm/radeon/r600d.h b/drivers/gpu/drm/radeon/r600d.h
index 4a53402..8a8308b 100644
--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -1196,7 +1196,7 @@
  */
 #              define PACKET3_CP_DMA_CP_SYNC       (1 << 31)
 /* COMMAND */
-#              define PACKET3_CP_DMA_CMD_SRC_SWAP(x) ((x) << 23)
+#              define PACKET3_CP_DMA_CMD_SRC_SWAP(x) ((x) << 22)
                 /* 0 - none
 		 * 1 - 8 in 16
 		 * 2 - 8 in 32
diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 30c5dbc..4767968 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -881,7 +881,7 @@
  * 6. COMMAND [30:21] | BYTE_COUNT [20:0]
  */
 #              define PACKET3_CP_DMA_DST_SEL(x)    ((x) << 20)
-                /* 0 - SRC_ADDR
+                /* 0 - DST_ADDR
 		 * 1 - GDS
 		 */
 #              define PACKET3_CP_DMA_ENGINE(x)     ((x) << 27)
@@ -896,7 +896,7 @@
 #              define PACKET3_CP_DMA_CP_SYNC       (1 << 31)
 /* COMMAND */
 #              define PACKET3_CP_DMA_DIS_WC        (1 << 21)
-#              define PACKET3_CP_DMA_CMD_SRC_SWAP(x) ((x) << 23)
+#              define PACKET3_CP_DMA_CMD_SRC_SWAP(x) ((x) << 22)
                 /* 0 - none
 		 * 1 - 8 in 16
 		 * 2 - 8 in 32
-- 
1.8.1.2

