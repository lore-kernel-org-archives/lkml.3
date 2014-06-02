Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaFBO7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:59:44 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44794 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaFBO7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:59:43 -0400
Date: Mon, 2 Jun 2014 16:59:39 +0200
From: Robin Schroer <sulamiification@gmail.com>
To: daniel.vetter@ffwll.ch
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/gpu/drm/i915/dma: style fixes
Message-ID: <20140602145939.GA16534@shodan.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed several double space pointer notations, and added one newline

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 drivers/gpu/drm/i915/i915_dma.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index b9159ad..f3ae664 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -136,7 +136,7 @@ static void i915_free_hws(struct drm_device *dev)
 	I915_WRITE(HWS_PGA, 0x1ffff000);
 }
 
-void i915_kernel_lost_context(struct drm_device * dev)
+void i915_kernel_lost_context(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_i915_master_private *master_priv;
@@ -164,7 +164,7 @@ void i915_kernel_lost_context(struct drm_device * dev)
 		master_priv->sarea_priv->perf_boxes |= I915_BOX_RING_EMPTY;
 }
 
-static int i915_dma_cleanup(struct drm_device * dev)
+static int i915_dma_cleanup(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int i;
@@ -188,7 +188,7 @@ static int i915_dma_cleanup(struct drm_device * dev)
 	return 0;
 }
 
-static int i915_initialize(struct drm_device * dev, drm_i915_init_t * init)
+static int i915_initialize(struct drm_device *dev, drm_i915_init_t *init)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
@@ -233,7 +233,7 @@ static int i915_initialize(struct drm_device * dev, drm_i915_init_t * init)
 	return 0;
 }
 
-static int i915_dma_resume(struct drm_device * dev)
+static int i915_dma_resume(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_engine_cs *ring = LP_RING(dev_priv);
@@ -357,7 +357,7 @@ static int validate_cmd(int cmd)
 	return 0;
 }
 
-static int i915_emit_cmds(struct drm_device * dev, int *buffer, int dwords)
+static int i915_emit_cmds(struct drm_device *dev, int *buffer, int dwords)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int i, ret;
@@ -367,6 +367,7 @@ static int i915_emit_cmds(struct drm_device * dev, int *buffer, int dwords)
 
 	for (i = 0; i < dwords;) {
 		int sz = validate_cmd(buffer[i]);
+
 		if (sz == 0 || i + sz > dwords)
 			return -EINVAL;
 		i += sz;
@@ -451,7 +452,7 @@ static void i915_emit_breadcrumb(struct drm_device *dev)
 	}
 }
 
-static int i915_dispatch_cmdbuffer(struct drm_device * dev,
+static int i915_dispatch_cmdbuffer(struct drm_device *dev,
 				   drm_i915_cmdbuffer_t *cmd,
 				   struct drm_clip_rect *cliprects,
 				   void *cmdbuf)
@@ -485,8 +486,8 @@ static int i915_dispatch_cmdbuffer(struct drm_device * dev,
 	return 0;
 }
 
-static int i915_dispatch_batchbuffer(struct drm_device * dev,
-				     drm_i915_batchbuffer_t * batch,
+static int i915_dispatch_batchbuffer(struct drm_device *dev,
+				     drm_i915_batchbuffer_t *batch,
 				     struct drm_clip_rect *cliprects)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -547,7 +548,7 @@ static int i915_dispatch_batchbuffer(struct drm_device * dev,
 	return 0;
 }
 
-static int i915_dispatch_flip(struct drm_device * dev)
+static int i915_dispatch_flip(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_i915_master_private *master_priv =
@@ -753,7 +754,7 @@ fail_batch_free:
 	return ret;
 }
 
-static int i915_emit_irq(struct drm_device * dev)
+static int i915_emit_irq(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
@@ -779,7 +780,7 @@ static int i915_emit_irq(struct drm_device * dev)
 	return dev_priv->dri1.counter;
 }
 
-static int i915_wait_irq(struct drm_device * dev, int irq_nr)
+static int i915_wait_irq(struct drm_device *dev, int irq_nr)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
@@ -1264,6 +1265,7 @@ static void i915_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 	pm_message_t pmm = { .event = PM_EVENT_SUSPEND };
+
 	if (state == VGA_SWITCHEROO_ON) {
 		pr_info("switched on\n");
 		dev->switch_power_state = DRM_SWITCH_POWER_CHANGING;
@@ -1895,7 +1897,7 @@ int i915_driver_open(struct drm_device *dev, struct drm_file *file)
  * and DMA structures, since the kernel won't be using them, and clea
  * up any GEM state.
  */
-void i915_driver_lastclose(struct drm_device * dev)
+void i915_driver_lastclose(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
@@ -1916,7 +1918,7 @@ void i915_driver_lastclose(struct drm_device * dev)
 	i915_dma_cleanup(dev);
 }
 
-void i915_driver_preclose(struct drm_device * dev, struct drm_file *file_priv)
+void i915_driver_preclose(struct drm_device *dev, struct drm_file *file_priv)
 {
 	mutex_lock(&dev->struct_mutex);
 	i915_gem_context_close(dev, file_priv);
@@ -1993,7 +1995,7 @@ int i915_max_ioctl = DRM_ARRAY_SIZE(i915_ioctls);
  * manage the gtt, we need to claim that all intel devices are agp.  For
  * otherwise the drm core refuses to initialize the agp support code.
  */
-int i915_driver_device_is_agp(struct drm_device * dev)
+int i915_driver_device_is_agp(struct drm_device *dev)
 {
 	return 1;
 }
-- 
1.9.3


-- 

Robin Schroer

