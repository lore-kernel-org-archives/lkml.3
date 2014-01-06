Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaAFP37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:29:59 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49339 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaAFP36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:29:58 -0500
Date: Mon, 6 Jan 2014 20:59:53 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, Alex Ivanov <gnidorah@p0n4ik.tk>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 29/85] drivers: gpu: Include appropriate header file in
 radeon_ring.c
Message-ID: <8d93c99c56055c0336a4284d1e02479d5c25f3e4.1389018325.git.rashika.kheria@gmail.com>
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

Include appropriate header file drivers/gpu/drm/radeon/radeon_asic.h to
file drm/radeon/radeon_ring.c because functions
radeon_ring_generic_set_wptr(), radeon_ring_generic_get_rptr() and
radeon_ring_generic_get_wptr() have their prototype declarations in the
header file.

This eliminates the following warnings in drm/radeon/radeon_ring.c:
drivers/gpu/drm/radeon/radeon_ring.c:335:5: warning: no previous prototype for ‘radeon_ring_generic_get_rptr’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_ring.c:348:5: warning: no previous prototype for ‘radeon_ring_generic_get_wptr’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_ring.c:358:6: warning: no previous prototype for ‘radeon_ring_generic_set_wptr’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_ring.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 9214403..90bc2b1 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -33,6 +33,7 @@
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "atom.h"
+#include "radeon_asic.h"
 
 /*
  * IB
-- 
1.7.9.5

