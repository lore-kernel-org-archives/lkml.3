Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbaJCVqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:46:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270AbaJCVp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:45:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 014/238] drm/radeon: re-enable dpm by default on cayman
Date: Fri,  3 Oct 2014 14:28:49 -0700
Message-Id: <20141003212914.121008586@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1279,7 +1279,6 @@ int radeon_pm_init(struct radeon_device
 	case CHIP_BARTS:
 	case CHIP_TURKS:
 	case CHIP_CAICOS:
-	case CHIP_CAYMAN:
 		/* DPM requires the RLC, RV770+ dGPU requires SMC */
 		if (!rdev->rlc_fw)
 			rdev->pm.pm_method = PM_METHOD_PROFILE;
@@ -1303,6 +1302,7 @@ int radeon_pm_init(struct radeon_device
 	case CHIP_PALM:
 	case CHIP_SUMO:
 	case CHIP_SUMO2:
+	case CHIP_CAYMAN:
 	case CHIP_ARUBA:
 	case CHIP_TAHITI:
 	case CHIP_PITCAIRN:


