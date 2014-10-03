Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbaJDAzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:55:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaJCVcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andreas Boll <andreas.boll.dev@gmail.com>
Subject: [PATCH 3.16 023/357] drm/radeon: tweak ACCEL_WORKING2 query for hawaii
Date: Fri,  3 Oct 2014 14:26:49 -0700
Message-Id: <20141003212934.161071981@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3c64bd26f7e9bd589ebe0d1ebec69ef2f784c12d upstream.

Return 2 so we can be sure the kernel has the necessary
changes for acceleration to work.

Note: This patch depends on these two commits:
 - drm/radeon: fix cut and paste issue for hawaii.
 - drm/radeon: use packet2 for nop on hawaii with old firmware

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Andreas Boll <andreas.boll.dev@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_kms.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -254,7 +254,14 @@ static int radeon_info_ioctl(struct drm_
 		}
 		break;
 	case RADEON_INFO_ACCEL_WORKING2:
-		*value = rdev->accel_working;
+		if (rdev->family == CHIP_HAWAII) {
+			if (rdev->accel_working)
+				*value = 2;
+			else
+				*value = 0;
+		} else {
+			*value = rdev->accel_working;
+		}
 		break;
 	case RADEON_INFO_TILING_CONFIG:
 		if (rdev->family >= CHIP_BONAIRE)


