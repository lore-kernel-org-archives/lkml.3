Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaAUV2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:28:49 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50839 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaAUVZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        <dri-devel@lists.freedesktop.org>, <intel-gfx@lists.freedesktop.org>
Subject: [PATCH 71/73] drivers/gpu: delete non-required instances of <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:14 -0500
Message-ID: <1390339396-3479-72-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/ast/ast_fb.c             | 1 -
 drivers/gpu/drm/drm_dp_helper.c          | 1 -
 drivers/gpu/drm/gma500/accel_2d.c        | 1 -
 drivers/gpu/drm/gma500/framebuffer.c     | 1 -
 drivers/gpu/drm/i915/intel_fbdev.c       | 1 -
 drivers/gpu/drm/nouveau/nouveau_fbcon.c  | 1 -
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c | 1 -
 7 files changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_fb.c b/drivers/gpu/drm/ast/ast_fb.c
index 7b33e14..e4a35c1 100644
--- a/drivers/gpu/drm/ast/ast_fb.c
+++ b/drivers/gpu/drm/ast/ast_fb.c
@@ -34,7 +34,6 @@
 #include <linux/sysrq.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 
 
 #include <drm/drmP.h>
diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index 9e978aa..d96e445 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -23,7 +23,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/i2c.h>
diff --git a/drivers/gpu/drm/gma500/accel_2d.c b/drivers/gpu/drm/gma500/accel_2d.c
index de6f62a..426e8dd 100644
--- a/drivers/gpu/drm/gma500/accel_2d.c
+++ b/drivers/gpu/drm/gma500/accel_2d.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/console.h>
 
 #include <drm/drmP.h>
diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index 94b3fec..6a3aa1b 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/console.h>
 
 #include <drm/drmP.h>
diff --git a/drivers/gpu/drm/i915/intel_fbdev.c b/drivers/gpu/drm/i915/intel_fbdev.c
index 39eac99..de80c29 100644
--- a/drivers/gpu/drm/i915/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/intel_fbdev.c
@@ -33,7 +33,6 @@
 #include <linux/sysrq.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/vga_switcheroo.h>
 
 #include <drm/drmP.h>
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 7903e0e..3da3999 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -33,7 +33,6 @@
 #include <linux/sysrq.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/screen_info.h>
 #include <linux/vga_switcheroo.h>
 #include <linux/console.h>
diff --git a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
index 701c4c1..d7f1c85 100644
--- a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
+++ b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
@@ -15,7 +15,6 @@
  * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/platform_device.h> /* platform_device() */
 #include <linux/errno.h>
-- 
1.8.4.1

