Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbaBUNfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:35:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47090 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395AbaBUMut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 074/121] drm/radeon: fix UVD IRQ support on SI
Date: Fri, 21 Feb 2014 12:48:18 +0000
Message-Id: <1392986945-9693-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit b927e1c20462c1ad9caf4c4fa3a30e838a2d4037 upstream.

Otherwise decoding isn't really useable.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=71448

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/si.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 9e04414..966bacc 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -6292,6 +6292,10 @@ restart_ih:
 				break;
 			}
 			break;
+		case 124: /* UVD */
+			DRM_DEBUG("IH: UVD int: 0x%08x\n", src_data);
+			radeon_fence_process(rdev, R600_RING_TYPE_UVD_INDEX);
+			break;
 		case 146:
 		case 147:
 			addr = RREG32(VM_CONTEXT1_PROTECTION_FAULT_ADDR);
-- 
1.9.0

