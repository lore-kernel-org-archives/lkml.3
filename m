Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbbA2JG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:06:29 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44865 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760231AbbA2JGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:06:21 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 074/176] drm/radeon: work around a hw bug in MGCG on CIK
Date: Wed, 28 Jan 2015 15:28:24 +0100
Message-Id: <5d531ee5e76b84da1c114dddd9077d1e3a2d1ff7.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4bb62c95a7e781a238b2ab374f34b1bf91e01ddc upstream.

Always need to set bit 0 of RLC_CGTT_MGCG_OVERRIDE
to avoid unreliable doorbell updates in some cases.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/cik.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 0fc5fd6b3b41..cdc7f408bd18 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -5167,6 +5167,7 @@ static void cik_enable_mgcg(struct radeon_device *rdev, bool enable)
 		}
 
 		orig = data = RREG32(RLC_CGTT_MGCG_OVERRIDE);
+		data |= 0x00000001;
 		data &= 0xfffffffd;
 		if (orig != data)
 			WREG32(RLC_CGTT_MGCG_OVERRIDE, data);
@@ -5198,7 +5199,7 @@ static void cik_enable_mgcg(struct radeon_device *rdev, bool enable)
 		}
 	} else {
 		orig = data = RREG32(RLC_CGTT_MGCG_OVERRIDE);
-		data |= 0x00000002;
+		data |= 0x00000003;
 		if (orig != data)
 			WREG32(RLC_CGTT_MGCG_OVERRIDE, data);
 
-- 
2.2.2

