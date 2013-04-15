Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125Ab3DOCZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:25:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934052Ab3DOCZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:25:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Widawsky <ben@bwidawsk.net>, Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 05/17] drm/i915: Use the correct size of the GTT for placing the per-process entries
Date: Sun, 14 Apr 2013 19:25:15 -0700
Message-Id: <20130415022353.020994010@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415022352.616689034@linuxfoundation.org>
References: <20130415022352.616689034@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 9a0f938bde74bf9e50bd75c8de9e38c1787398cd upstream.

The current layout is to place the per-process tables at the end of the
GTT. However, this is currently using a hardcoded maximum size for the GTT
and not taking in account limitations imposed by the BIOS. Use the value
for the total number of entries allocated in the table as provided by
the configuration registers.

Reported-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Matthew Garret <mjg@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_gtt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -72,7 +72,7 @@ int i915_gem_init_aliasing_ppgtt(struct
 	/* ppgtt PDEs reside in the global gtt pagetable, which has 512*1024
 	 * entries. For aliasing ppgtt support we just steal them at the end for
 	 * now. */
-	first_pd_entry_in_global_pt = 512*1024 - I915_PPGTT_PD_ENTRIES;
+	first_pd_entry_in_global_pt = dev_priv->mm.gtt->gtt_total_entries - I915_PPGTT_PD_ENTRIES;
 
 	ppgtt = kzalloc(sizeof(*ppgtt), GFP_KERNEL);
 	if (!ppgtt)


