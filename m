Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab3BQXK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:10:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45596 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601Ab3BQWzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:00 -0500
Message-Id: <20130217225001.814892455@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:02 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Julien Cristau <jcristau@debian.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 01/66] drm/i915: Fix misplaced intel_mark_page_flip_active()
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

In commit 28c4566d30b8, backport of commit e7d841ca03b7 ('drm/i915:
Close race between processing unpin task and queueing the flip') I
somehow added two calls to intel_mark_page_flip_active() from
intel_gen4_queue_flip() and none from intel_gen6_queue_flip().  There
should of course be one from each.

Reported-by: Julien Cristau <jcristau@debian.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7156,8 +7156,6 @@ static int intel_gen4_queue_flip(struct
 	OUT_RING(pf | pipesrc);
 
 	intel_mark_page_flip_active(intel_crtc);
-
-	intel_mark_page_flip_active(intel_crtc);
 	ADVANCE_LP_RING();
 	return 0;
 
@@ -7193,6 +7191,8 @@ static int intel_gen6_queue_flip(struct
 	pf = I915_READ(PF_CTL(intel_crtc->pipe)) & PF_ENABLE;
 	pipesrc = I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
 	OUT_RING(pf | pipesrc);
+
+	intel_mark_page_flip_active(intel_crtc);
 	ADVANCE_LP_RING();
 	return 0;
 


