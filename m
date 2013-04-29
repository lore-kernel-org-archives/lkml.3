Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729Ab3D2UMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:12:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:57862 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759634Ab3D2UMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:12:03 -0400
Date: Mon, 29 Apr 2013 22:12:02 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org
Subject: [ANNOUNCE] 3.8.10-rt6
Message-ID: <20130429201202.GB7979@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.8.10-rt6 release.

changes since v3.8.10-rt5:
- the i915 compiles again after I broke it in the last release. A patch
  was sent by Carsten Emde.

Known issues:

    - SLxB is broken on PowerPC.
    - suspend / resume seems to program program the timer wrong and wait
      ages until it continues.

The delta patch against v3.8.10-rt5 is appended below and can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.10-rt5-rt6.patch.xz

The RT patch against 3.8.9 can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.10-rt6.patch.xz

The split quilt queue is available at:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.8.10-rt6.tar.xz

Sebastian

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 81125de..eabd3dd 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -814,6 +814,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 	struct intel_ring_buffer *ring;
 	u32 ctx_id = i915_execbuffer2_get_context_id(*args);
 	u32 exec_start, exec_len;
+	u32 seqno;
 	u32 mask;
 	u32 flags;
 	int ret, mode, i;
@@ -1068,7 +1069,8 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 			goto err;
 	}
 
-	trace_i915_gem_ring_dispatch(ring, intel_ring_get_seqno(ring), flags);
+	seqno = intel_ring_get_seqno(ring);
+	trace_i915_gem_ring_dispatch(ring, seqno, flags);
 	i915_trace_irq_get(ring, seqno);
 
 	i915_gem_execbuffer_move_to_active(&objects, ring);
diff --git a/localversion-rt b/localversion-rt
index 0efe7ba..8fc605d 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt5
+-rt6
