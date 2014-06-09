Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaFIJFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:05:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58468 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755050AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 043/146] drm/radeon: disable mclk dpm on R7 260X
Date: Mon,  9 Jun 2014 10:49:38 +0200
Message-Id: <efa019ee9d25f383acea1c15e3fa6b0fa314e1ad.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 57700ad1f2f21d5d7ab7ee0e58d11b5954852434 upstream.

Setting higher mclks seems to cause stability issues
on some R7 260X boards.  Disable it for now for stability
until we find a proper fix.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=75992

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 51e947a97edf..79682ff51b63 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -5098,6 +5098,10 @@ int ci_dpm_init(struct radeon_device *rdev)
 	pi->mclk_dpm_key_disabled = 0;
 	pi->pcie_dpm_key_disabled = 0;
 
+	/* mclk dpm is unstable on some R7 260X cards */
+	if (rdev->pdev->device == 0x6658)
+		pi->mclk_dpm_key_disabled = 1;
+
 	pi->caps_sclk_ds = true;
 
 	pi->mclk_strobe_mode_threshold = 40000;
-- 
1.9.3

