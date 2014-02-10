Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaBJT4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:56:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35057 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaBJTq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:57 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 036/124] drm/radeon: warn users when hw_i2c is enabled (v2)
Date: Mon, 10 Feb 2014 11:39:36 -0800
Message-Id: <1392061264-28124-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d195178297de9a91246519dbfa98952b70f9a9b6 upstream.

The hw i2c engines are disabled by default as the
current implementation is still experimental.  Print
a warning when users enable it so that it's obvious
when the option is enabled.

v2: check for non-0 rather than 1

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
index fc60b74..e24ca6a 100644
--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -1020,6 +1020,9 @@ void radeon_i2c_destroy(struct radeon_i2c_chan *i2c)
 /* Add the default buses */
 void radeon_i2c_init(struct radeon_device *rdev)
 {
+	if (radeon_hw_i2c)
+		DRM_INFO("hw_i2c forced on, you may experience display detection problems!\n");
+
 	if (rdev->is_atom_bios)
 		radeon_atombios_i2c_init(rdev);
 	else
-- 
1.8.3.2

