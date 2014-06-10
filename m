Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaFJUCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:02:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35555 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbaFJTxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:53:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 034/160] drm/radeon: disable mclk dpm on R7 260X
Date: Tue, 10 Jun 2014 12:44:34 -0700
Message-Id: <1402429600-20477-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 57700ad1f2f21d5d7ab7ee0e58d11b5954852434 upstream.

Setting higher mclks seems to cause stability issues
on some R7 260X boards.  Disable it for now for stability
until we find a proper fix.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=75992

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 1ed4799..d4ca530 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -5128,6 +5128,10 @@ int ci_dpm_init(struct radeon_device *rdev)
 	pi->mclk_dpm_key_disabled = 0;
 	pi->pcie_dpm_key_disabled = 0;
 
+	/* mclk dpm is unstable on some R7 260X cards */
+	if (rdev->pdev->device == 0x6658)
+		pi->mclk_dpm_key_disabled = 1;
+
 	pi->caps_sclk_ds = true;
 
 	pi->mclk_strobe_mode_threshold = 40000;
-- 
1.9.1

