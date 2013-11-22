Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3KVQll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:41:41 -0500
Received: from blu0-omc1-s31.blu0.hotmail.com ([65.55.116.42]:26719 "EHLO
	blu0-omc1-s31.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755526Ab3KVQlj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:41:39 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Nov 2013 11:41:39 EST
X-TMN: [kRNp0XFnhdmB7iPSnkXUT98U3oVAfhbx]
X-Originating-Email: [aschwal@hotmail.com]
Message-ID: <BLU0-SMTP55275B8B1932509DE4677AACE00@phx.gbl>
Date: Fri, 22 Nov 2013 11:35:26 -0500
From: Arthur Schwalbenberg <aschwal@hotmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Arthur Schwalbenberg <arthurs578@gmail.com>
Subject: Patch
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 22 Nov 2013 16:35:28.0456 (UTC) FILETIME=[DA5BDC80:01CEE7A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 From 340fa01dfe8f699e27ece111996ea088bca6b5c4 Mon Sep 17 00:00:00 2001
From: Arthur Schwalbenberg <aschwal@hotmail.com>
Date: Thu, 21 Nov 2013 19:42:44 -0500
Subject: [PATCH] Staging: Fixed compilar warnings and coding style
issues in i915_debugfs.c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is a patch fixing both a compilar warning:
‘val’ may be used uninitialized in this function
and various coding style issues which include line length
warnings and a few errors as defined by 'checkpatch.pl' tool

Signed-off-by: Arthur Schwalbenberg <aschwal@hotmail.com>
---
drivers/gpu/drm/i915/i915_debugfs.c | 75 ++++++++++++++++++++---------------
1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c 
b/drivers/gpu/drm/i915/i915_debugfs.c
index 6ed45a9..01135d4 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -1,5 +1,5 @@
/*
- * Copyright © 2008 Intel Corporation
+ * Copyright © 2008 Intel Corporation
*
* Permission is hereby granted, free of charge, to any person obtaining a
* copy of this software and associated documentation files (the "Software"),
@@ -87,8 +87,8 @@ static int i915_capabilities(struct seq_file *m, void 
*data)

seq_printf(m, "gen: %d\n", info->gen);
seq_printf(m, "pch: %d\n", INTEL_PCH_TYPE(dev));
-#define PRINT_FLAG(x) seq_printf(m, #x ": %s\n", yesno(info->x))
-#define SEP_SEMICOLON ;
+#define PRINT_FLAG(x) seq_printf(m, #x ": %s\n", yesno(info->x));
+#define SEP_SEMICOLON
DEV_INFO_FOR_EACH_FLAG(PRINT_FLAG, SEP_SEMICOLON);
#undef PRINT_FLAG
#undef SEP_SEMICOLON
@@ -144,7 +144,7 @@ describe_obj(struct seq_file *m, struct 
drm_i915_gem_object *obj)
if (obj->pin_count)
seq_printf(m, " (pinned x %d)", obj->pin_count);
if (obj->pin_display)
- seq_printf(m, " (display)");
+ seq_puts(m, " (display)");
if (obj->fence_reg != I915_FENCE_REG_NONE)
seq_printf(m, " (fence: %d)", obj->fence_reg);
list_for_each_entry(vma, &obj->vma_list, vma_link) {
@@ -210,9 +210,9 @@ static int i915_gem_object_list_info(struct seq_file 
*m, void *data)

total_obj_size = total_gtt_size = count = 0;
list_for_each_entry(vma, head, mm_list) {
- seq_printf(m, " ");
+ seq_puts(m, " ");
describe_obj(m, vma->obj);
- seq_printf(m, "\n");
+ seq_puts(m, "\n");
total_obj_size += vma->obj->base.size;
total_gtt_size += vma->node.size;
count++;
@@ -333,7 +333,7 @@ static int per_file_stats(int id, void *ptr, void *data)
} \
} while (0)

-static int i915_gem_object_info(struct seq_file *m, void* data)
+static int i915_gem_object_info(struct seq_file *m, void *data)
{
struct drm_info_node *node = (struct drm_info_node *) m->private;
struct drm_device *dev = node->minor->dev;
@@ -460,6 +460,7 @@ static int i915_gem_gtt_info(struct seq_file *m, 
void *data)

static int i915_gem_pageflip_info(struct seq_file *m, void *data)
{
+ struct drm_i915_gem_object *obj = NULL;
struct drm_info_node *node = (struct drm_info_node *) m->private;
struct drm_device *dev = node->minor->dev;
unsigned long flags;
@@ -487,19 +488,22 @@ static int i915_gem_pageflip_info(struct seq_file 
*m, void *data)
seq_puts(m, "Stall check enabled, ");
else
seq_puts(m, "Stall check waiting for page flip ioctl, ");
- seq_printf(m, "%d prepares\n", atomic_read(&work->pending));
+
+ seq_printf(m, "%d prepares\n",
+ atomic_read(&work->pending));

if (work->old_fb_obj) {
- struct drm_i915_gem_object *obj = work->old_fb_obj;
+ obj = work->old_fb_obj;
if (obj)
seq_printf(m, "Old framebuffer gtt_offset 0x%08lx\n",
- i915_gem_obj_ggtt_offset(obj));
+ i915_gem_obj_ggtt_offset(obj));
}
if (work->pending_flip_obj) {
- struct drm_i915_gem_object *obj = work->pending_flip_obj;
+ obj = work->pending_flip_obj;
if (obj)
- seq_printf(m, "New framebuffer gtt_offset 0x%08lx\n",
- i915_gem_obj_ggtt_offset(obj));
+ seq_printf(m,
+ "New framebuffer gtt_offset 0x%08lx\n",
+ i915_gem_obj_ggtt_offset(obj));
}
}
spin_unlock_irqrestore(&dev->event_lock, flags);
@@ -530,9 +534,8 @@ static int i915_gem_request_info(struct seq_file *m, 
void *data)
list_for_each_entry(gem_request,
&ring->request_list,
list) {
- seq_printf(m, " %d @ %d\n",
- gem_request->seqno,
- (int) (jiffies - gem_request->emitted_jiffies));
+ seq_printf(m, " %d @ %d\n", gem_request->seqno,
+ (int) (jiffies - gem_request->emitted_jiffies));
}
count++;
}
@@ -909,7 +912,9 @@ static int i915_rstdby_delays(struct seq_file *m, 
void *unused)

mutex_unlock(&dev->struct_mutex);

- seq_printf(m, "w/ctx: %d, w/o ctx: %d\n", (crstanddelay >> 8) & 0x3f, 
(crstanddelay & 0x3f));
+ seq_printf(m, "w/ctx: %d, w/o ctx: %d\n",
+ (crstanddelay >> 8) & 0x3f,
+ (crstanddelay & 0x3f));

return 0;
}
@@ -929,10 +934,11 @@ static int i915_cur_delayinfo(struct seq_file *m, 
void *unused)

seq_printf(m, "Requested P-state: %d\n", (rgvswctl >> 8) & 0xf);
seq_printf(m, "Requested VID: %d\n", rgvswctl & 0x3f);
- seq_printf(m, "Current VID: %d\n", (rgvstat & MEMSTAT_VID_MASK) >>
- MEMSTAT_VID_SHIFT);
+ seq_printf(m, "Current VID: %d\n", (rgvstat & MEMSTAT_VID_MASK)
+ >> MEMSTAT_VID_SHIFT);
seq_printf(m, "Current P-state: %d\n",
- (rgvstat & MEMSTAT_PSTATE_MASK) >> MEMSTAT_PSTATE_SHIFT);
+ (rgvstat & MEMSTAT_PSTATE_MASK) >>
+ MEMSTAT_PSTATE_SHIFT);
} else if ((IS_GEN6(dev) || IS_GEN7(dev)) && !IS_VALLEYVIEW(dev)) {
u32 gt_perf_status = I915_READ(GEN6_GT_PERF_STATUS);
u32 rp_state_limits = I915_READ(GEN6_RP_STATE_LIMITS);
@@ -1173,13 +1179,13 @@ static int gen6_drpc_info(struct seq_file *m)
spin_unlock_irq(&dev_priv->uncore.lock);

if (forcewake_count) {
- seq_puts(m, "RC information inaccurate because somebody "
- "holds a forcewake reference \n");
+ seq_puts(m, "RC information inaccurate because somebody holds a 
forcewake reference\n");
} else {
/* NB: we cannot use forcewake, else we read the wrong values */
while (count++ < 50 && (I915_READ_NOTRACE(FORCEWAKE_ACK) & 1))
udelay(10);
- seq_printf(m, "RC information accurate: %s\n", yesno(count < 51));
+ seq_printf(m, "RC information accurate: %s\n",
+ yesno(count < 51));
}

gt_core_status = readl(dev_priv->regs + GEN6_GT_CORE_STATUS);
@@ -1549,7 +1555,8 @@ static int i915_context_status(struct seq_file *m, 
void *unused)
describe_ctx(m, ctx);
for_each_ring(ring, dev_priv, i)
if (ring->default_context == ctx)
- seq_printf(m, "(default context %s) ", ring->name);
+ seq_printf(m, "(default context %s) ",
+ ring->name);

describe_obj(m, ctx->obj);
seq_putc(m, '\n');
@@ -1683,10 +1690,15 @@ static void gen6_ppgtt_info(struct seq_file *m, 
struct drm_device *dev)
for_each_ring(ring, dev_priv, i) {
seq_printf(m, "%s\n", ring->name);
if (INTEL_INFO(dev)->gen == 7)
- seq_printf(m, "GFX_MODE: 0x%08x\n", I915_READ(RING_MODE_GEN7(ring)));
- seq_printf(m, "PP_DIR_BASE: 0x%08x\n", I915_READ(RING_PP_DIR_BASE(ring)));
- seq_printf(m, "PP_DIR_BASE_READ: 0x%08x\n", 
I915_READ(RING_PP_DIR_BASE_READ(ring)));
- seq_printf(m, "PP_DIR_DCLV: 0x%08x\n", I915_READ(RING_PP_DIR_DCLV(ring)));
+ seq_printf(m, "GFX_MODE: 0x%08x\n",
+ I915_READ(RING_MODE_GEN7(ring)));
+
+ seq_printf(m, "PP_DIR_BASE: 0x%08x\n",
+ I915_READ(RING_PP_DIR_BASE(ring)));
+ seq_printf(m, "PP_DIR_BASE_READ: 0x%08x\n",
+ I915_READ(RING_PP_DIR_BASE_READ(ring)));
+ seq_printf(m, "PP_DIR_DCLV: 0x%08x\n",
+ I915_READ(RING_PP_DIR_DCLV(ring)));
}
if (dev_priv->mm.aliasing_ppgtt) {
struct i915_hw_ppgtt *ppgtt = dev_priv->mm.aliasing_ppgtt;
@@ -2347,7 +2359,7 @@ static int pipe_crc_set_source(struct drm_device 
*dev, enum pipe pipe,
{
struct drm_i915_private *dev_priv = dev->dev_private;
struct intel_pipe_crc *pipe_crc = &dev_priv->pipe_crc[pipe];
- u32 val;
+ u32 val = 0;
int ret;

if (pipe_crc->source == source)
@@ -2362,7 +2374,7 @@ static int pipe_crc_set_source(struct drm_device 
*dev, enum pipe pipe,
else if (INTEL_INFO(dev)->gen < 5)
ret = i9xx_pipe_crc_ctl_reg(dev, pipe, &source, &val);
else if (IS_VALLEYVIEW(dev))
- ret = vlv_pipe_crc_ctl_reg(dev,pipe, &source, &val);
+ ret = vlv_pipe_crc_ctl_reg(dev, pipe, &source, &val);
else if (IS_GEN5(dev) || IS_GEN6(dev))
ret = ilk_pipe_crc_ctl_reg(&source, &val);
else
@@ -3046,7 +3058,8 @@ static const struct drm_info_list 
i915_debugfs_list[] = {
{"i915_gem_gtt", i915_gem_gtt_info, 0},
{"i915_gem_pinned", i915_gem_gtt_info, 0, (void *) PINNED_LIST},
{"i915_gem_active", i915_gem_object_list_info, 0, (void *) ACTIVE_LIST},
- {"i915_gem_inactive", i915_gem_object_list_info, 0, (void *) 
INACTIVE_LIST},
+ {"i915_gem_inactive", i915_gem_object_list_info, 0,
+ (void *) INACTIVE_LIST},
{"i915_gem_stolen", i915_gem_stolen_list_info },
{"i915_gem_pageflip", i915_gem_pageflip_info, 0},
{"i915_gem_request", i915_gem_request_info, 0},
-- 
1.7.9.5

