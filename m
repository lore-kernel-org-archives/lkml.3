Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaAFP1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:27:49 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63369 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaAFP1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:27:47 -0500
Date: Mon, 6 Jan 2014 20:57:43 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 27/85] drivers: gpu: Include appropriate header file in
 radeon_clocks.c
Message-ID: <bbbe505f9e36771986d514eb331dd08390318301.1389018325.git.rashika.kheria@gmail.com>
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

Include appropriate header file drivers/gpu/drm/radeon/radeon_asic.h in
file drm/radeon/radeon_clocks.c because functions
radeon_legacy_get_engine_clock(), radeon_legacy_get_memory_clock() and
radeon_legacy_set_engine_clock() have their prototype declarations in
the header file.

This eliminates the following warnings in drm/radeon/radeon_clocks.c:
drivers/gpu/drm/radeon/radeon_clocks.c:35:10: warning: no previous prototype for ‘radeon_legacy_get_engine_clock’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_clocks.c:65:10: warning: no previous prototype for ‘radeon_legacy_get_memory_clock’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_clocks.c:385:6: warning: no previous prototype for ‘radeon_legacy_set_engine_clock’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_clocks.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_clocks.c b/drivers/gpu/drm/radeon/radeon_clocks.c
index 38e396d..08f615f 100644
--- a/drivers/gpu/drm/radeon/radeon_clocks.c
+++ b/drivers/gpu/drm/radeon/radeon_clocks.c
@@ -30,6 +30,7 @@
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "atom.h"
+#include "radeon_asic.h"
 
 /* 10 khz */
 uint32_t radeon_legacy_get_engine_clock(struct radeon_device *rdev)
-- 
1.7.9.5

