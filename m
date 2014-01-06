Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaAFPti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:49:38 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:50088 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaAFPtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:49:36 -0500
Date: Mon, 6 Jan 2014 21:19:30 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Marek =?utf-8?B?T2zFocOhaw==?= <maraeo@gmail.com>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 41/85] drivers: gpu: Include appropriate header file in
 evergreen_cs.c
Message-ID: <fa5322ae51dc9b67d5f623b7dbe599aa88df483d.1389018325.git.rashika.kheria@gmail.com>
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

Include header file drm/radeon/radeon_asic.h in
drm/radeon/evergreen_cs.c because it uses function declared in the
header file.

This eliminates the following warning in drm/radeon/evergreen_cs.c:
drivers/gpu/drm/radeon/evergreen_cs.c:2561:5: warning: no previous prototype for ‘evergreen_cs_parse’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen_cs.c:2682:5: warning: no previous prototype for ‘evergreen_dma_cs_parse’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen_cs.c:3378:5: warning: no previous prototype for ‘evergreen_ib_parse’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen_cs.c:3423:5: warning: no previous prototype for ‘evergreen_dma_ib_parse’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/evergreen_cs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index eb8ac31..cfecc24 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -30,6 +30,7 @@
 #include "evergreend.h"
 #include "evergreen_reg_safe.h"
 #include "cayman_reg_safe.h"
+#include "radeon_asic.h"
 
 #define MAX(a,b)                   (((a)>(b))?(a):(b))
 #define MIN(a,b)                   (((a)<(b))?(a):(b))
-- 
1.7.9.5

