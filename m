Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935492Ab3JPSSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:18:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761383Ab3JPRpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 28/69] drm/radeon: fix typo in CP DMA register headers
Date: Wed, 16 Oct 2013 10:44:37 -0700
Message-Id: <20131016174316.337807833@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit aa3e146d04b6ae37939daeebaec060562b3db559 upstream.

Wrong bit offset for SRC endian swapping.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreend.h |    4 ++--
 drivers/gpu/drm/radeon/r600d.h      |    2 +-
 drivers/gpu/drm/radeon/sid.h        |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -1104,7 +1104,7 @@
  * 6. COMMAND [29:22] | BYTE_COUNT [20:0]
  */
 #              define PACKET3_CP_DMA_DST_SEL(x)    ((x) << 20)
-                /* 0 - SRC_ADDR
+                /* 0 - DST_ADDR
 		 * 1 - GDS
 		 */
 #              define PACKET3_CP_DMA_ENGINE(x)     ((x) << 27)
@@ -1119,7 +1119,7 @@
 #              define PACKET3_CP_DMA_CP_SYNC       (1 << 31)
 /* COMMAND */
 #              define PACKET3_CP_DMA_DIS_WC        (1 << 21)
-#              define PACKET3_CP_DMA_CMD_SRC_SWAP(x) ((x) << 23)
+#              define PACKET3_CP_DMA_CMD_SRC_SWAP(x) ((x) << 22)
                 /* 0 - none
 		 * 1 - 8 in 16
 		 * 2 - 8 in 32
--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -1259,7 +1259,7 @@
  */
 #              define PACKET3_CP_DMA_CP_SYNC       (1 << 31)
 /* COMMAND */
-#              define PACKET3_CP_DMA_CMD_SRC_SWAP(x) ((x) << 23)
+#              define PACKET3_CP_DMA_CMD_SRC_SWAP(x) ((x) << 22)
                 /* 0 - none
 		 * 1 - 8 in 16
 		 * 2 - 8 in 32
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -928,7 +928,7 @@
  * 6. COMMAND [30:21] | BYTE_COUNT [20:0]
  */
 #              define PACKET3_CP_DMA_DST_SEL(x)    ((x) << 20)
-                /* 0 - SRC_ADDR
+                /* 0 - DST_ADDR
 		 * 1 - GDS
 		 */
 #              define PACKET3_CP_DMA_ENGINE(x)     ((x) << 27)
@@ -943,7 +943,7 @@
 #              define PACKET3_CP_DMA_CP_SYNC       (1 << 31)
 /* COMMAND */
 #              define PACKET3_CP_DMA_DIS_WC        (1 << 21)
-#              define PACKET3_CP_DMA_CMD_SRC_SWAP(x) ((x) << 23)
+#              define PACKET3_CP_DMA_CMD_SRC_SWAP(x) ((x) << 22)
                 /* 0 - none
 		 * 1 - 8 in 16
 		 * 2 - 8 in 32


