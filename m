Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3BCPHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:07:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34478 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754740Ab3BCO5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:35 -0500
Message-Id: <20130203144652.273531129@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [ 093/128] drm/i915: dump UTS_RELEASE into the error_state
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 4518f611ba21ba165ea3714055938a8984a44ff9 upstream.

Useful for statistics or on overflowing bug reports to keep things all
lined up.

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_debugfs.c |    2 ++
 1 file changed, 2 insertions(+)

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
@@ -755,6 +756,7 @@ static int i915_error_state(struct seq_f
 
 	seq_printf(m, "Time: %ld s %ld us\n", error->time.tv_sec,
 		   error->time.tv_usec);
+	seq_printf(m, "Kernel: " UTS_RELEASE);
 	seq_printf(m, "PCI ID: 0x%04x\n", dev->pci_device);
 	seq_printf(m, "EIR: 0x%08x\n", error->eir);
 	seq_printf(m, "PGTBL_ER: 0x%08x\n", error->pgtbl_er);


