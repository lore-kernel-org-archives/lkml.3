Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbaBUNel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:34:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47094 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404AbaBUMuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 075/121] drm/radeon: fix UVD IRQ support on 7xx
Date: Fri, 21 Feb 2014 12:48:19 +0000
Message-Id: <1392986945-9693-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 858a41c853cef2cb01de34dae334c19c1c15b237 upstream.

Otherwise decoding isn't really useable.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/r600.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 30320a5..093afb9 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -4626,6 +4626,10 @@ restart_ih:
 				break;
 			}
 			break;
+		case 124: /* UVD */
+			DRM_DEBUG("IH: UVD int: 0x%08x\n", src_data);
+			radeon_fence_process(rdev, R600_RING_TYPE_UVD_INDEX);
+			break;
 		case 176: /* CP_INT in ring buffer */
 		case 177: /* CP_INT in IB1 */
 		case 178: /* CP_INT in IB2 */
-- 
1.9.0

