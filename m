Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbbAYTP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:15:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbbAYSJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 18/98] drm/radeon: fix typo in CI dpm disable
Date: Sun, 25 Jan 2015 10:06:36 -0800
Message-Id: <20150125180713.670031563@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 129acb7c0b682512e89c4f65c33593d50f2f49a9 upstream.

Need to disable DS, not enable it when disabling dpm.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ci_dpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -4733,7 +4733,7 @@ void ci_dpm_disable(struct radeon_device
 	ci_enable_spread_spectrum(rdev, false);
 	ci_enable_auto_throttle_source(rdev, RADEON_DPM_AUTO_THROTTLE_SRC_THERMAL, false);
 	ci_stop_dpm(rdev);
-	ci_enable_ds_master_switch(rdev, true);
+	ci_enable_ds_master_switch(rdev, false);
 	ci_enable_ulv(rdev, false);
 	ci_clear_vc(rdev);
 	ci_reset_to_default(rdev);


