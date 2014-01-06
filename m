Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbaAFPjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:39:39 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48834 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAFPji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:39:38 -0500
Date: Mon, 6 Jan 2014 21:09:33 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 33/85] drivers: gpu: Include appropriate header file in
 radeon_atombios.c
Message-ID: <ae77378d448503c0bf3765d15eeb22d91ee9a848.1389018325.git.rashika.kheria@gmail.com>
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

Include appropriate header file drm/radeon/radeon_asic.h in
drm/radeon/radeon_atombios.c because it uses the functions whose
prototype declarations is present in the header file.

This eliminates the following warnings in drm/radeon/radeon_atombios.c:
drivers/gpu/drm/radeon/radeon_atombios.c:2949:10: warning: no previous prototype for ‘radeon_atom_get_engine_clock’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_atombios.c:2958:10: warning: no previous prototype for ‘radeon_atom_get_memory_clock’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_atombios.c:2967:6: warning: no previous prototype for ‘radeon_atom_set_engine_clock’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_atombios.c:2978:6: warning: no previous prototype for ‘radeon_atom_set_memory_clock’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 39f1fd6..b3bf270 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -29,6 +29,7 @@
 
 #include "atom.h"
 #include "atombios.h"
+#include "radeon_asic.h"
 #include "atom-bits.h"
 
 /* from radeon_encoder.c */
-- 
1.7.9.5

