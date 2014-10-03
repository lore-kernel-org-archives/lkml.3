Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbaJDAv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:51:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbaJCVce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.16 018/357] drm/radeon: re-enable dpm by default on cayman
Date: Fri,  3 Oct 2014 14:26:44 -0700
Message-Id: <20141003212934.017126185@linuxfoundation.org>
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

commit 8f500af4efe347d1a8ac674d115220e8caa84559 upstream.

This patch depends on:
b0880e87c1fd038b84498944f52e52c3e86ebe59
(drm/radeon/dpm: fix vddci setup typo on cayman)

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=69723

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1306,7 +1306,6 @@ int radeon_pm_init(struct radeon_device
 	case CHIP_BARTS:
 	case CHIP_TURKS:
 	case CHIP_CAICOS:
-	case CHIP_CAYMAN:
 		/* DPM requires the RLC, RV770+ dGPU requires SMC */
 		if (!rdev->rlc_fw)
 			rdev->pm.pm_method = PM_METHOD_PROFILE;
@@ -1330,6 +1329,7 @@ int radeon_pm_init(struct radeon_device
 	case CHIP_PALM:
 	case CHIP_SUMO:
 	case CHIP_SUMO2:
+	case CHIP_CAYMAN:
 	case CHIP_ARUBA:
 	case CHIP_TAHITI:
 	case CHIP_PITCAIRN:


