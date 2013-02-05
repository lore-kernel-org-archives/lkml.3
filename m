Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab3BEWKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:10:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618Ab3BEWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 51/93] drm/i915: dump UTS_RELEASE into the error_state
Date: Tue,  5 Feb 2013 20:06:40 -0200
Message-Id: <1360102042-10732-52-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 4518f611ba21ba165ea3714055938a8984a44ff9 upstream.

Useful for statistics or on overflowing bug reports to keep things all
lined up.

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ herton: adjusted context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_debugfs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index e4e6ba7..ca472ca 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -30,6 +30,7 @@
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <generated/utsrelease.h>
 #include "drmP.h"
 #include "drm.h"
 #include "intel_drv.h"
@@ -709,6 +710,7 @@ static int i915_error_state(struct seq_file *m, void *unused)
 
 	seq_printf(m, "Time: %ld s %ld us\n", error->time.tv_sec,
 		   error->time.tv_usec);
+	seq_printf(m, "Kernel: " UTS_RELEASE);
 	seq_printf(m, "PCI ID: 0x%04x\n", dev->pci_device);
 	seq_printf(m, "EIR: 0x%08x\n", error->eir);
 	seq_printf(m, "IER: 0x%08x\n", error->ier);
-- 
1.7.9.5

