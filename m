Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaAFQhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:37:55 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46317 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaAFQhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:37:53 -0500
Date: Mon, 6 Jan 2014 22:07:48 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Anssi Hannula <anssi.hannula@iki.fi>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 73/85] drivers: gpu: Include appropriate header file in
 dce6_afmt.c
Message-ID: <e46dec2195a3404ed73a240f598dd2180dd0ed34.1389018325.git.rashika.kheria@gmail.com>
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

Include header file drm/radeon/radeon_asic.h in drm/radeon/dce6_afmt.c
because it uses function declared in the header file.

This eliminates the folllowing warning in drm/radeon/dce6_afmt.c:
drivers/gpu/drm/radeon/dce6_afmt.c:301:5: warning: no previous prototype for ‘dce6_audio_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/dce6_afmt.c:330:6: warning: no previous prototype for ‘dce6_audio_fini’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/dce6_afmt.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/dce6_afmt.c b/drivers/gpu/drm/radeon/dce6_afmt.c
index de86493..2229258 100644
--- a/drivers/gpu/drm/radeon/dce6_afmt.c
+++ b/drivers/gpu/drm/radeon/dce6_afmt.c
@@ -23,6 +23,7 @@
 #include <linux/hdmi.h>
 #include <drm/drmP.h>
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "sid.h"
 
 static u32 dce6_endpoint_rreg(struct radeon_device *rdev,
-- 
1.7.9.5

