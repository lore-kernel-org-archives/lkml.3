Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaAFPoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:44:25 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:58216 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAFPoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:44:24 -0500
Date: Mon, 6 Jan 2014 21:14:20 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Marek =?utf-8?B?T2zFocOhaw==?= <maraeo@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 37/85] drivers: gpu: Include appropriate header file in
 r600_cs.c
Message-ID: <8c3b2f348a02226a296817cdbe8265d51840a370.1389018325.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file gpu/drm/radeon/radeon_asic.h in
drm/radeon/r600_cs.c because it uses the function declared in the header
file.

This eliminates the following warning in drm/radeon/r600_cs.c:
drivers/gpu/drm/radeon/r600_cs.c:2251:5: warning: no previous prototype for ‘r600_cs_parse’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/r600_cs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index 5dceea6..3b3be00 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -30,6 +30,7 @@
 #include "radeon.h"
 #include "r600d.h"
 #include "r600_reg_safe.h"
+#include "radeon_asic.h"
 
 static int r600_nomm;
 extern void r600_cs_legacy_get_tiling_conf(struct drm_device *dev, u32 *npipes, u32 *nbanks, u32 *group_size);
-- 
1.7.9.5

