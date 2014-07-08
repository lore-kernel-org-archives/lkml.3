Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbaGHTi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:38:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755182AbaGHTeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:34:14 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.968689236@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 017/125] drm/i915: s/DRM_ERROR/DRM_DEBUG in
 i915_gem_execbuffer.c
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit ff240199b6a3b0bec5ae9b6d26403dad38e8cb19 upstream.

These are all user-trigerable, so tune down their loudness a notch.
For some of these we have i-g-t tests (because they prevent
newly-discovered bugs), without this patches running the test suite
leaves behind a dirty dmesg.

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 50 +++++++++++++++---------------
 1 file changed, 25 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -287,14 +287,14 @@ i915_gem_execbuffer_relocate_entry(struc
 	 * exec_object list, so it should have a GTT space bound by now.
 	 */
 	if (unlikely(target_offset == 0)) {
-		DRM_ERROR("No GTT space found for object %d\n",
+		DRM_DEBUG("No GTT space found for object %d\n",
 			  reloc->target_handle);
 		return ret;
 	}
 
 	/* Validate that the target is in a valid r/w GPU domain */
 	if (unlikely(reloc->write_domain & (reloc->write_domain - 1))) {
-		DRM_ERROR("reloc with multiple write domains: "
+		DRM_DEBUG("reloc with multiple write domains: "
 			  "obj %p target %d offset %d "
 			  "read %08x write %08x",
 			  obj, reloc->target_handle,
@@ -304,7 +304,7 @@ i915_gem_execbuffer_relocate_entry(struc
 		return ret;
 	}
 	if (unlikely((reloc->write_domain | reloc->read_domains) & I915_GEM_DOMAIN_CPU)) {
-		DRM_ERROR("reloc with read/write CPU domains: "
+		DRM_DEBUG("reloc with read/write CPU domains: "
 			  "obj %p target %d offset %d "
 			  "read %08x write %08x",
 			  obj, reloc->target_handle,
@@ -315,7 +315,7 @@ i915_gem_execbuffer_relocate_entry(struc
 	}
 	if (unlikely(reloc->write_domain && target_obj->pending_write_domain &&
 		     reloc->write_domain != target_obj->pending_write_domain)) {
-		DRM_ERROR("Write domain conflict: "
+		DRM_DEBUG("Write domain conflict: "
 			  "obj %p target %d offset %d "
 			  "new %08x old %08x\n",
 			  obj, reloc->target_handle,
@@ -336,7 +336,7 @@ i915_gem_execbuffer_relocate_entry(struc
 
 	/* Check that the relocation address is valid... */
 	if (unlikely(reloc->offset > obj->base.size - 4)) {
-		DRM_ERROR("Relocation beyond object bounds: "
+		DRM_DEBUG("Relocation beyond object bounds: "
 			  "obj %p target %d offset %d size %d.\n",
 			  obj, reloc->target_handle,
 			  (int) reloc->offset,
@@ -344,7 +344,7 @@ i915_gem_execbuffer_relocate_entry(struc
 		return ret;
 	}
 	if (unlikely(reloc->offset & 3)) {
-		DRM_ERROR("Relocation not 4-byte aligned: "
+		DRM_DEBUG("Relocation not 4-byte aligned: "
 			  "obj %p target %d offset %d.\n",
 			  obj, reloc->target_handle,
 			  (int) reloc->offset);
@@ -704,7 +704,7 @@ i915_gem_execbuffer_relocate_slow(struct
 		obj = to_intel_bo(drm_gem_object_lookup(dev, file,
 							exec[i].handle));
 		if (&obj->base == NULL) {
-			DRM_ERROR("Invalid object handle %d at index %d\n",
+			DRM_DEBUG("Invalid object handle %d at index %d\n",
 				   exec[i].handle, i);
 			ret = -ENOENT;
 			goto err;
@@ -1015,7 +1015,7 @@ i915_gem_do_execbuffer(struct drm_device
 	int ret, mode, i;
 
 	if (!i915_gem_check_execbuffer(args)) {
-		DRM_ERROR("execbuf with invalid offset/length\n");
+		DRM_DEBUG("execbuf with invalid offset/length\n");
 		return -EINVAL;
 	}
 
@@ -1030,20 +1030,20 @@ i915_gem_do_execbuffer(struct drm_device
 		break;
 	case I915_EXEC_BSD:
 		if (!HAS_BSD(dev)) {
-			DRM_ERROR("execbuf with invalid ring (BSD)\n");
+			DRM_DEBUG("execbuf with invalid ring (BSD)\n");
 			return -EINVAL;
 		}
 		ring = &dev_priv->ring[VCS];
 		break;
 	case I915_EXEC_BLT:
 		if (!HAS_BLT(dev)) {
-			DRM_ERROR("execbuf with invalid ring (BLT)\n");
+			DRM_DEBUG("execbuf with invalid ring (BLT)\n");
 			return -EINVAL;
 		}
 		ring = &dev_priv->ring[BCS];
 		break;
 	default:
-		DRM_ERROR("execbuf with unknown ring: %d\n",
+		DRM_DEBUG("execbuf with unknown ring: %d\n",
 			  (int)(args->flags & I915_EXEC_RING_MASK));
 		return -EINVAL;
 	}
@@ -1069,18 +1069,18 @@ i915_gem_do_execbuffer(struct drm_device
 		}
 		break;
 	default:
-		DRM_ERROR("execbuf with unknown constants: %d\n", mode);
+		DRM_DEBUG("execbuf with unknown constants: %d\n", mode);
 		return -EINVAL;
 	}
 
 	if (args->buffer_count < 1) {
-		DRM_ERROR("execbuf with %d buffers\n", args->buffer_count);
+		DRM_DEBUG("execbuf with %d buffers\n", args->buffer_count);
 		return -EINVAL;
 	}
 
 	if (args->num_cliprects != 0) {
 		if (ring != &dev_priv->ring[RCS]) {
-			DRM_ERROR("clip rectangles are only valid with the render ring\n");
+			DRM_DEBUG("clip rectangles are only valid with the render ring\n");
 			return -EINVAL;
 		}
 
@@ -1130,7 +1130,7 @@ i915_gem_do_execbuffer(struct drm_device
 		obj = to_intel_bo(drm_gem_object_lookup(dev, file,
 							exec[i].handle));
 		if (&obj->base == NULL) {
-			DRM_ERROR("Invalid object handle %d at index %d\n",
+			DRM_DEBUG("Invalid object handle %d at index %d\n",
 				   exec[i].handle, i);
 			/* prevent error path from reading uninitialized data */
 			ret = -ENOENT;
@@ -1138,7 +1138,7 @@ i915_gem_do_execbuffer(struct drm_device
 		}
 
 		if (!list_empty(&obj->exec_list)) {
-			DRM_ERROR("Object %p [handle %d, index %d] appears more than once in object list\n",
+			DRM_DEBUG("Object %p [handle %d, index %d] appears more than once in object list\n",
 				   obj, exec[i].handle, i);
 			ret = -EINVAL;
 			goto err;
@@ -1176,7 +1176,7 @@ i915_gem_do_execbuffer(struct drm_device
 
 	/* Set the pending read domains for the batch buffer to COMMAND */
 	if (batch_obj->base.pending_write_domain) {
-		DRM_ERROR("Attempting to use self-modifying batch buffer\n");
+		DRM_DEBUG("Attempting to use self-modifying batch buffer\n");
 		ret = -EINVAL;
 		goto err;
 	}
@@ -1275,7 +1275,7 @@ i915_gem_execbuffer(struct drm_device *d
 	int ret, i;
 
 	if (args->buffer_count < 1) {
-		DRM_ERROR("execbuf with %d buffers\n", args->buffer_count);
+		DRM_DEBUG("execbuf with %d buffers\n", args->buffer_count);
 		return -EINVAL;
 	}
 
@@ -1283,7 +1283,7 @@ i915_gem_execbuffer(struct drm_device *d
 	exec_list = drm_malloc_ab(sizeof(*exec_list), args->buffer_count);
 	exec2_list = drm_malloc_ab(sizeof(*exec2_list), args->buffer_count);
 	if (exec_list == NULL || exec2_list == NULL) {
-		DRM_ERROR("Failed to allocate exec list for %d buffers\n",
+		DRM_DEBUG("Failed to allocate exec list for %d buffers\n",
 			  args->buffer_count);
 		drm_free_large(exec_list);
 		drm_free_large(exec2_list);
@@ -1294,7 +1294,7 @@ i915_gem_execbuffer(struct drm_device *d
 			     (uintptr_t) args->buffers_ptr,
 			     sizeof(*exec_list) * args->buffer_count);
 	if (ret != 0) {
-		DRM_ERROR("copy %d exec entries failed %d\n",
+		DRM_DEBUG("copy %d exec entries failed %d\n",
 			  args->buffer_count, ret);
 		drm_free_large(exec_list);
 		drm_free_large(exec2_list);
@@ -1335,7 +1335,7 @@ i915_gem_execbuffer(struct drm_device *d
 				   sizeof(*exec_list) * args->buffer_count);
 		if (ret) {
 			ret = -EFAULT;
-			DRM_ERROR("failed to copy %d exec entries "
+			DRM_DEBUG("failed to copy %d exec entries "
 				  "back to user (%d)\n",
 				  args->buffer_count, ret);
 		}
@@ -1356,7 +1356,7 @@ i915_gem_execbuffer2(struct drm_device *
 
 	if (args->buffer_count < 1 ||
 	    args->buffer_count > UINT_MAX / sizeof(*exec2_list)) {
-		DRM_ERROR("execbuf2 with %d buffers\n", args->buffer_count);
+		DRM_DEBUG("execbuf2 with %d buffers\n", args->buffer_count);
 		return -EINVAL;
 	}
 
@@ -1366,7 +1366,7 @@ i915_gem_execbuffer2(struct drm_device *
 		exec2_list = drm_malloc_ab(sizeof(*exec2_list),
 					   args->buffer_count);
 	if (exec2_list == NULL) {
-		DRM_ERROR("Failed to allocate exec list for %d buffers\n",
+		DRM_DEBUG("Failed to allocate exec list for %d buffers\n",
 			  args->buffer_count);
 		return -ENOMEM;
 	}
@@ -1375,7 +1375,7 @@ i915_gem_execbuffer2(struct drm_device *
 			     (uintptr_t) args->buffers_ptr,
 			     sizeof(*exec2_list) * args->buffer_count);
 	if (ret != 0) {
-		DRM_ERROR("copy %d exec entries failed %d\n",
+		DRM_DEBUG("copy %d exec entries failed %d\n",
 			  args->buffer_count, ret);
 		drm_free_large(exec2_list);
 		return -EFAULT;
@@ -1390,7 +1390,7 @@ i915_gem_execbuffer2(struct drm_device *
 				   sizeof(*exec2_list) * args->buffer_count);
 		if (ret) {
 			ret = -EFAULT;
-			DRM_ERROR("failed to copy %d exec entries "
+			DRM_DEBUG("failed to copy %d exec entries "
 				  "back to user (%d)\n",
 				  args->buffer_count, ret);
 		}

