Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3LLQyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:54:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45672 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3LLQys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:54:48 -0500
From: vegard.nossum@oracle.com
To: linux-kernel@vger.kernel.org
Cc: Vegard Nossum <vegard.nossum@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 7/9] drm/i915: Known exploit detection for CVE-2013-0913
Date: Thu, 12 Dec 2013 17:52:30 +0100
Message-Id: <1386867152-24072-7-git-send-email-vegard.nossum@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

See 3118a4f652c7b12c752f3222af0447008f9b2368.

Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index bf34577..48490c1 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -32,6 +32,7 @@
 #include "i915_trace.h"
 #include "intel_drv.h"
 #include <linux/dma_remapping.h>
+#include <linux/exploit.h>
 
 struct eb_objects {
 	struct list_head objects;
@@ -785,8 +786,10 @@ validate_exec_list(struct drm_i915_gem_exec_object2 *exec,
 		 * the worst case where we need to allocate the entire
 		 * relocation tree as a single array.
 		 */
-		if (exec[i].relocation_count > relocs_max - relocs_total)
+		if (exec[i].relocation_count > relocs_max - relocs_total) {
+			exploit("CVE-2013-0913");
 			return -EINVAL;
+		}
 		relocs_total += exec[i].relocation_count;
 
 		length = exec[i].relocation_count *
-- 
1.7.10.4

