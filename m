Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbaJCVpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:45:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbaJCVpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:45:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 015/238] drm/radeon: re-enable dpm by default on BTC
Date: Fri,  3 Oct 2014 14:28:50 -0700
Message-Id: <20141003212914.151309291@linuxfoundation.org>
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

commit c08abf11900e19b14dd3a0cc3d105bd74519cd18 upstream.

This patch depends on:
e07929810f0a19ddd756558290c7d72827cbfcd9
(drm/radeon/dpm: fix typo in vddci setup for eg/btc)

bugs:
https://bugs.freedesktop.org/show_bug.cgi?id=73053
https://bugzilla.kernel.org/show_bug.cgi?id=68571

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_pm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1276,9 +1276,6 @@ int radeon_pm_init(struct radeon_device
 	case CHIP_RS780:
 	case CHIP_RS880:
 	case CHIP_RV770:
-	case CHIP_BARTS:
-	case CHIP_TURKS:
-	case CHIP_CAICOS:
 		/* DPM requires the RLC, RV770+ dGPU requires SMC */
 		if (!rdev->rlc_fw)
 			rdev->pm.pm_method = PM_METHOD_PROFILE;
@@ -1302,6 +1299,9 @@ int radeon_pm_init(struct radeon_device
 	case CHIP_PALM:
 	case CHIP_SUMO:
 	case CHIP_SUMO2:
+	case CHIP_BARTS:
+	case CHIP_TURKS:
+	case CHIP_CAICOS:
 	case CHIP_CAYMAN:
 	case CHIP_ARUBA:
 	case CHIP_TAHITI:


