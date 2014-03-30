Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaCaAK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:10:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970AbaC3Xme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:34 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Christian =?UTF-8?Q?K=C3=B6nig?=" <christian.koenig@amd.com>,
        "Alex Deucher" <alexander.deucher@amd.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.603349164@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 023/200] drm/radeon: warn users when hw_i2c is enabled
 (v2)
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_i2c.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -998,6 +998,9 @@ void radeon_i2c_destroy(struct radeon_i2
 /* Add the default buses */
 void radeon_i2c_init(struct radeon_device *rdev)
 {
+	if (radeon_hw_i2c)
+		DRM_INFO("hw_i2c forced on, you may experience display detection problems!\n");
+
 	if (rdev->is_atom_bios)
 		radeon_atombios_i2c_init(rdev);
 	else

