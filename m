Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaFEEfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:35:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaFEEVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 168/214] drm/i915: dump UTS_RELEASE into the error_state
Date: Wed,  4 Jun 2014 21:18:51 -0700
Message-Id: <20140605041702.117498872@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 4518f611ba21ba165ea3714055938a8984a44ff9 upstream.

Useful for statistics or on overflowing bug reports to keep things all
lined up.

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -750,6 +751,7 @@ static int i915_error_state(struct seq_f
 
 	seq_printf(m, "Time: %ld s %ld us\n", error->time.tv_sec,
 		   error->time.tv_usec);
+	seq_printf(m, "Kernel: " UTS_RELEASE);
 	seq_printf(m, "PCI ID: 0x%04x\n", dev->pci_device);
 	seq_printf(m, "EIR: 0x%08x\n", error->eir);
 	seq_printf(m, "PGTBL_ER: 0x%08x\n", error->pgtbl_er);


