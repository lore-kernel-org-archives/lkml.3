Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaGJWHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:07:36 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48567 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaGJVz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:26 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 41/83] hsa/radeon: Alternating the source of max clock
Date: Fri, 11 Jul 2014 00:53:57 +0300
Message-Id: <1405029279-6894-13-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>

Changing the source of the max engine clock value.

Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon_kfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index 8b6d497..a28cf6b 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -316,5 +316,5 @@ static uint32_t get_max_engine_clock_in_mhz(struct kgd_dev *kgd)
 	struct radeon_device *rdev = (struct radeon_device *)kgd;
 
 	/* The sclk is in quantas of 10kHz */
-	return rdev->pm.power_state->clock_info->sclk / 100;
+	return rdev->pm.dpm.dyn_state.max_clock_voltage_on_ac.sclk / 100;
 }
-- 
1.9.1

