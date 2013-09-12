Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3ILP5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:57:24 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:55729 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3ILP5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:57:22 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Peter Zijlstra <peterz@infradead.org>, Dave Airlie <airlied@linux.ie>
Subject: [PATCH 2/2] drm/udl: rip out set_need_resched
Date: Thu, 12 Sep 2013 17:57:29 +0200
Message-Id: <1379001449-17380-2-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379001449-17380-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1379001449-17380-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This very much looks like copypasta from drm/i915's fault handler.
It was used there to duct-tape over issues around gpu reset handling.

Since that can't ever happen for udl and there's seemingly no other
reason for this just drop it.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/udl/udl_gem.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/udl/udl_gem.c b/drivers/gpu/drm/udl/udl_gem.c
index 8dbe9d0..8bf6461 100644
--- a/drivers/gpu/drm/udl/udl_gem.c
+++ b/drivers/gpu/drm/udl/udl_gem.c
@@ -97,7 +97,6 @@ int udl_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	ret = vm_insert_page(vma, (unsigned long)vmf->virtual_address, page);
 	switch (ret) {
 	case -EAGAIN:
-		set_need_resched();
 	case 0:
 	case -ERESTARTSYS:
 		return VM_FAULT_NOPAGE;
-- 
1.8.4.rc3

