Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbaDCBYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 21:24:49 -0400
Received: from ozlabs.org ([203.10.76.45]:45627 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933675AbaDCBYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 21:24:47 -0400
Date: Thu, 3 Apr 2014 12:24:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Roper <matthew.d.roper@intel.com>,
        Rob Clark <robdclark@gmail.com>
Subject: linux-next: build failure after merge of the drm-intel tree
Message-Id: <20140403122435.4b64cda2d046e52c9e6dae57@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Apr_2014_12_24_35_+1100_QCYr4MKpqN.FNi=C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Apr_2014_12_24_35_+1100_QCYr4MKpqN.FNi=C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the drm-intel tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/gpu/drm/i915/intel_display.c: In function 'intel_alloc_plane_obj':
drivers/gpu/drm/i915/intel_display.c:2089:27: error: 'struct drm_crtc' has =
no member named 'fb'
   obj->stride =3D crtc->base.fb->pitches[0];
                           ^
drivers/gpu/drm/i915/intel_display.c:2092:36: error: 'struct drm_crtc' has =
no member named 'fb'
  mode_cmd.pixel_format =3D crtc->base.fb->pixel_format;
                                    ^
drivers/gpu/drm/i915/intel_display.c:2093:29: error: 'struct drm_crtc' has =
no member named 'fb'
  mode_cmd.width =3D crtc->base.fb->width;
                             ^
drivers/gpu/drm/i915/intel_display.c:2094:30: error: 'struct drm_crtc' has =
no member named 'fb'
  mode_cmd.height =3D crtc->base.fb->height;
                              ^
drivers/gpu/drm/i915/intel_display.c:2095:34: error: 'struct drm_crtc' has =
no member named 'fb'
  mode_cmd.pitches[0] =3D crtc->base.fb->pitches[0];
                                  ^
In file included from arch/x86/include/asm/percpu.h:44:0,
                 from arch/x86/include/asm/preempt.h:5,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/gpu/drm/i915/intel_display.c:28:
drivers/gpu/drm/i915/intel_display.c:2099:65: error: 'struct drm_crtc' has =
no member named 'fb'
  if (intel_framebuffer_init(dev, to_intel_framebuffer(crtc->base.fb),
                                                                 ^
include/linux/kernel.h:833:49: note: in definition of macro 'container_of'
  const typeof( ((type *)0)->member ) *__mptr =3D (ptr); \
                                                 ^
drivers/gpu/drm/i915/intel_display.c:2099:34: note: in expansion of macro '=
to_intel_framebuffer'
  if (intel_framebuffer_init(dev, to_intel_framebuffer(crtc->base.fb),
                                  ^
drivers/gpu/drm/i915/intel_display.c: In function 'intel_find_plane_obj':
drivers/gpu/drm/i915/intel_display.c:2124:23: error: 'struct drm_crtc' has =
no member named 'fb'
  if (!intel_crtc->base.fb)
                       ^
drivers/gpu/drm/i915/intel_display.c:2130:24: error: 'struct drm_crtc' has =
no member named 'fb'
  kfree(intel_crtc->base.fb);
                        ^
drivers/gpu/drm/i915/intel_display.c:2131:18: error: 'struct drm_crtc' has =
no member named 'fb'
  intel_crtc->base.fb =3D NULL;
                  ^
drivers/gpu/drm/i915/intel_display.c:2143:23: error: 'struct drm_crtc' has =
no member named 'fb'
   if (!i->active || !c->fb)
                       ^
In file included from arch/x86/include/asm/percpu.h:44:0,
                 from arch/x86/include/asm/preempt.h:5,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/gpu/drm/i915/intel_display.c:28:
drivers/gpu/drm/i915/intel_display.c:2146:30: error: 'struct drm_crtc' has =
no member named 'fb'
   fb =3D to_intel_framebuffer(c->fb);
                              ^
include/linux/kernel.h:833:49: note: in definition of macro 'container_of'
  const typeof( ((type *)0)->member ) *__mptr =3D (ptr); \
                                                 ^
drivers/gpu/drm/i915/intel_display.c:2146:8: note: in expansion of macro 't=
o_intel_framebuffer'
   fb =3D to_intel_framebuffer(c->fb);
        ^
drivers/gpu/drm/i915/intel_display.c:2148:31: error: 'struct drm_crtc' has =
no member named 'fb'
    drm_framebuffer_reference(c->fb);
                               ^
drivers/gpu/drm/i915/intel_display.c:2149:20: error: 'struct drm_crtc' has =
no member named 'fb'
    intel_crtc->base.fb =3D c->fb;
                    ^
drivers/gpu/drm/i915/intel_display.c:2149:27: error: 'struct drm_crtc' has =
no member named 'fb'
    intel_crtc->base.fb =3D c->fb;
                           ^
drivers/gpu/drm/i915/intel_display.c: In function 'i9xx_get_plane_config':
drivers/gpu/drm/i915/intel_display.c:5745:12: error: 'struct drm_crtc' has =
no member named 'fb'
  crtc->base.fb =3D kzalloc(sizeof(struct intel_framebuffer), GFP_KERNEL);
            ^
drivers/gpu/drm/i915/intel_display.c:5746:17: error: 'struct drm_crtc' has =
no member named 'fb'
  if (!crtc->base.fb) {
                 ^
drivers/gpu/drm/i915/intel_display.c:5759:12: error: 'struct drm_crtc' has =
no member named 'fb'
  crtc->base.fb->pixel_format =3D fourcc;
            ^
drivers/gpu/drm/i915/intel_display.c:5760:12: error: 'struct drm_crtc' has =
no member named 'fb'
  crtc->base.fb->bits_per_pixel =3D
            ^
drivers/gpu/drm/i915/intel_display.c:5775:12: error: 'struct drm_crtc' has =
no member named 'fb'
  crtc->base.fb->width =3D ((val >> 16) & 0xfff) + 1;
            ^
drivers/gpu/drm/i915/intel_display.c:5776:12: error: 'struct drm_crtc' has =
no member named 'fb'
  crtc->base.fb->height =3D ((val >> 0) & 0xfff) + 1;
            ^
drivers/gpu/drm/i915/intel_display.c:5779:12: error: 'struct drm_crtc' has =
no member named 'fb'
  crtc->base.fb->pitches[0] =3D val & 0xffffff80;
            ^
drivers/gpu/drm/i915/intel_display.c:5781:53: error: 'struct drm_crtc' has =
no member named 'fb'
  aligned_height =3D intel_align_height(dev, crtc->base.fb->height,
                                                     ^
In file included from include/linux/cache.h:4:0,
                 from include/linux/time.h:4,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/gpu/drm/i915/intel_display.c:28:
drivers/gpu/drm/i915/intel_display.c:5784:39: error: 'struct drm_crtc' has =
no member named 'fb'
  plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
                                       ^
include/uapi/linux/kernel.h:10:41: note: in definition of macro '__ALIGN_KE=
RNEL_MASK'
 #define __ALIGN_KERNEL_MASK(x, mask) (((x) + (mask)) & ~(mask))
                                         ^
include/linux/kernel.h:49:22: note: in expansion of macro '__ALIGN_KERNEL'
 #define ALIGN(x, a)  __ALIGN_KERNEL((x), (a))
                      ^
drivers/gpu/drm/i915/intel_display.c:5784:23: note: in expansion of macro '=
ALIGN'
  plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
                       ^
drivers/gpu/drm/i915/intel_display.c:5784:39: error: 'struct drm_crtc' has =
no member named 'fb'
  plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
                                       ^
include/uapi/linux/kernel.h:10:47: note: in definition of macro '__ALIGN_KE=
RNEL_MASK'
 #define __ALIGN_KERNEL_MASK(x, mask) (((x) + (mask)) & ~(mask))
                                               ^
include/linux/kernel.h:49:22: note: in expansion of macro '__ALIGN_KERNEL'
 #define ALIGN(x, a)  __ALIGN_KERNEL((x), (a))
                      ^
drivers/gpu/drm/i915/intel_display.c:5784:23: note: in expansion of macro '=
ALIGN'
  plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
                       ^
drivers/gpu/drm/i915/intel_display.c:5784:39: error: 'struct drm_crtc' has =
no member named 'fb'
  plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
                                       ^
include/uapi/linux/kernel.h:10:58: note: in definition of macro '__ALIGN_KE=
RNEL_MASK'
 #define __ALIGN_KERNEL_MASK(x, mask) (((x) + (mask)) & ~(mask))
                                                          ^
include/linux/kernel.h:49:22: note: in expansion of macro '__ALIGN_KERNEL'
 #define ALIGN(x, a)  __ALIGN_KERNEL((x), (a))
                      ^
drivers/gpu/drm/i915/intel_display.c:5784:23: note: in expansion of macro '=
ALIGN'
  plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
                       ^
In file included from drivers/gpu/drm/i915/intel_display.c:35:0:
drivers/gpu/drm/i915/intel_display.c:5788:32: error: 'struct drm_crtc' has =
no member named 'fb'
         pipe, plane, crtc->base.fb->width,
                                ^
include/drm/drmP.h:222:41: note: in definition of macro 'DRM_DEBUG_KMS'
    drm_ut_debug_printk(__func__, fmt, ##args); \
                                         ^
drivers/gpu/drm/i915/intel_display.c:5789:19: error: 'struct drm_crtc' has =
no member named 'fb'
         crtc->base.fb->height,
                   ^
include/drm/drmP.h:222:41: note: in definition of macro 'DRM_DEBUG_KMS'
    drm_ut_debug_printk(__func__, fmt, ##args); \
                                         ^
drivers/gpu/drm/i915/intel_display.c:5790:19: error: 'struct drm_crtc' has =
no member named 'fb'
         crtc->base.fb->bits_per_pixel, base,
                   ^
include/drm/drmP.h:222:41: note: in definition of macro 'DRM_DEBUG_KMS'
    drm_ut_debug_printk(__func__, fmt, ##args); \
                                         ^
drivers/gpu/drm/i915/intel_display.c:5791:19: error: 'struct drm_crtc' has =
no member named 'fb'
         crtc->base.fb->pitches[0],
                   ^
include/drm/drmP.h:222:41: note: in definition of macro 'DRM_DEBUG_KMS'
    drm_ut_debug_printk(__func__, fmt, ##args); \
                                         ^
drivers/gpu/drm/i915/intel_display.c: In function 'ironlake_get_plane_confi=
g':
drivers/gpu/drm/i915/intel_display.c:6753:12: error: 'struct drm_crtc' has =
no member named 'fb'
  crtc->base.fb =3D kzalloc(sizeof(struct intel_framebuffer), GFP_KERNEL);
            ^
drivers/gpu/drm/i915/intel_display.c:6754:17: error: 'struct drm_crtc' has =
no member named 'fb'
  if (!crtc->base.fb) {
                 ^
drivers/gpu/drm/i915/intel_display.c:6767:12: error: 'struct drm_crtc' has =
no member named 'fb'
  crtc->base.fb->pixel_format =3D fourcc;
            ^
drivers/gpu/drm/i915/intel_display.c:6768:12: error: 'struct drm_crtc' has =
no member named 'fb'
  crtc->base.fb->bits_per_pixel =3D
            ^
drivers/gpu/drm/i915/intel_display.c:6783:12: error: 'struct drm_crtc' has =
no member named 'fb'
  crtc->base.fb->width =3D ((val >> 16) & 0xfff) + 1;
            ^
drivers/gpu/drm/i915/intel_display.c:6784:12: error: 'struct drm_crtc' has =
no member named 'fb'
  crtc->base.fb->height =3D ((val >> 0) & 0xfff) + 1;
            ^
drivers/gpu/drm/i915/intel_display.c:6787:12: error: 'struct drm_crtc' has =
no member named 'fb'
  crtc->base.fb->pitches[0] =3D val & 0xffffff80;
            ^
drivers/gpu/drm/i915/intel_display.c:6789:53: error: 'struct drm_crtc' has =
no member named 'fb'
  aligned_height =3D intel_align_height(dev, crtc->base.fb->height,
                                                     ^
In file included from include/linux/cache.h:4:0,
                 from include/linux/time.h:4,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/gpu/drm/i915/intel_display.c:28:
drivers/gpu/drm/i915/intel_display.c:6792:39: error: 'struct drm_crtc' has =
no member named 'fb'
  plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
                                       ^
include/uapi/linux/kernel.h:10:41: note: in definition of macro '__ALIGN_KE=
RNEL_MASK'
 #define __ALIGN_KERNEL_MASK(x, mask) (((x) + (mask)) & ~(mask))
                                         ^
include/linux/kernel.h:49:22: note: in expansion of macro '__ALIGN_KERNEL'
 #define ALIGN(x, a)  __ALIGN_KERNEL((x), (a))
                      ^
drivers/gpu/drm/i915/intel_display.c:6792:23: note: in expansion of macro '=
ALIGN'
  plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
                       ^
drivers/gpu/drm/i915/intel_display.c:6792:39: error: 'struct drm_crtc' has =
no member named 'fb'
  plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
                                       ^
include/uapi/linux/kernel.h:10:47: note: in definition of macro '__ALIGN_KE=
RNEL_MASK'
 #define __ALIGN_KERNEL_MASK(x, mask) (((x) + (mask)) & ~(mask))
                                               ^
include/linux/kernel.h:49:22: note: in expansion of macro '__ALIGN_KERNEL'
 #define ALIGN(x, a)  __ALIGN_KERNEL((x), (a))
                      ^
drivers/gpu/drm/i915/intel_display.c:6792:23: note: in expansion of macro '=
ALIGN'
  plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
                       ^
drivers/gpu/drm/i915/intel_display.c:6792:39: error: 'struct drm_crtc' has =
no member named 'fb'
  plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
                                       ^
include/uapi/linux/kernel.h:10:58: note: in definition of macro '__ALIGN_KE=
RNEL_MASK'
 #define __ALIGN_KERNEL_MASK(x, mask) (((x) + (mask)) & ~(mask))
                                                          ^
include/linux/kernel.h:49:22: note: in expansion of macro '__ALIGN_KERNEL'
 #define ALIGN(x, a)  __ALIGN_KERNEL((x), (a))
                      ^
drivers/gpu/drm/i915/intel_display.c:6792:23: note: in expansion of macro '=
ALIGN'
  plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
                       ^
In file included from drivers/gpu/drm/i915/intel_display.c:35:0:
drivers/gpu/drm/i915/intel_display.c:6796:32: error: 'struct drm_crtc' has =
no member named 'fb'
         pipe, plane, crtc->base.fb->width,
                                ^
include/drm/drmP.h:222:41: note: in definition of macro 'DRM_DEBUG_KMS'
    drm_ut_debug_printk(__func__, fmt, ##args); \
                                         ^
drivers/gpu/drm/i915/intel_display.c:6797:19: error: 'struct drm_crtc' has =
no member named 'fb'
         crtc->base.fb->height,
                   ^
include/drm/drmP.h:222:41: note: in definition of macro 'DRM_DEBUG_KMS'
    drm_ut_debug_printk(__func__, fmt, ##args); \
                                         ^
drivers/gpu/drm/i915/intel_display.c:6798:19: error: 'struct drm_crtc' has =
no member named 'fb'
         crtc->base.fb->bits_per_pixel, base,
                   ^
include/drm/drmP.h:222:41: note: in definition of macro 'DRM_DEBUG_KMS'
    drm_ut_debug_printk(__func__, fmt, ##args); \
                                         ^
drivers/gpu/drm/i915/intel_display.c:6799:19: error: 'struct drm_crtc' has =
no member named 'fb'
         crtc->base.fb->pitches[0],
                   ^
include/drm/drmP.h:222:41: note: in definition of macro 'DRM_DEBUG_KMS'
    drm_ut_debug_printk(__func__, fmt, ##args); \
                                         ^
drivers/gpu/drm/i915/intel_display.c: In function 'intel_modeset_gem_init':
drivers/gpu/drm/i915/intel_display.c:11783:9: error: 'struct drm_crtc' has =
no member named 'fb'
   if (!c->fb)
         ^
In file included from arch/x86/include/asm/percpu.h:44:0,
                 from arch/x86/include/asm/preempt.h:5,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/gpu/drm/i915/intel_display.c:28:
drivers/gpu/drm/i915/intel_display.c:11786:30: error: 'struct drm_crtc' has=
 no member named 'fb'
   fb =3D to_intel_framebuffer(c->fb);
                              ^
include/linux/kernel.h:833:49: note: in definition of macro 'container_of'
  const typeof( ((type *)0)->member ) *__mptr =3D (ptr); \
                                                 ^
drivers/gpu/drm/i915/intel_display.c:11786:8: note: in expansion of macro '=
to_intel_framebuffer'
   fb =3D to_intel_framebuffer(c->fb);
        ^
drivers/gpu/drm/i915/intel_display.c:11790:33: error: 'struct drm_crtc' has=
 no member named 'fb'
    drm_framebuffer_unreference(c->fb);
                                 ^
drivers/gpu/drm/i915/intel_display.c:11791:5: error: 'struct drm_crtc' has =
no member named 'fb'
    c->fb =3D NULL;
     ^
drivers/gpu/drm/i915/intel_fbdev.c: In function 'intel_fbdev_init_bios':
drivers/gpu/drm/i915/intel_fbdev.c:484:35: error: 'struct drm_crtc' has no =
member named 'fb'
   if (!intel_crtc->active || !crtc->fb) {
                                   ^
In file included from arch/x86/include/asm/percpu.h:44:0,
                 from arch/x86/include/asm/preempt.h:5,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/gpu/drm/i915/intel_fbdev.c:27:
drivers/gpu/drm/i915/intel_fbdev.c:494:34: error: 'struct drm_crtc' has no =
member named 'fb'
    fb =3D to_intel_framebuffer(crtc->fb);
                                  ^
include/linux/kernel.h:833:49: note: in definition of macro 'container_of'
  const typeof( ((type *)0)->member ) *__mptr =3D (ptr); \
                                                 ^
drivers/gpu/drm/i915/intel_fbdev.c:494:9: note: in expansion of macro 'to_i=
ntel_framebuffer'
    fb =3D to_intel_framebuffer(crtc->fb);
         ^
In file included from arch/x86/include/asm/bug.h:38:0,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from arch/x86/include/asm/preempt.h:6,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/gpu/drm/i915/intel_fbdev.c:27:
drivers/gpu/drm/i915/intel_fbdev.c:563:13: error: 'struct drm_crtc' has no =
member named 'fb'
   WARN(!crtc->fb,
             ^
include/asm-generic/bug.h:95:25: note: in definition of macro 'WARN'
  int __ret_warn_on =3D !!(condition);    \
                         ^

Caused by commit f4510a2752b7 ("drm: Replace crtc fb with primary plane
fb (v3)") from the drm tree interacting with various commits in the
drm-intel tree.

I applied this merge fix patch:

=46rom 8b74d715803f3c8e0e76b907d8877e1355d29a31 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 3 Apr 2014 12:18:47 +1100
Subject: [PATCH] drm: fix for "Replace crtc fb with primary plane fb"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpu/drm/i915/intel_display.c | 90 ++++++++++++++++++--------------=
----
 drivers/gpu/drm/i915/intel_fbdev.c   |  6 +--
 2 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 9eb4dda2d81d..dae976f51d83 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -741,7 +741,7 @@ bool intel_crtc_active(struct drm_crtc *crtc)
 	 * We can ditch the adjusted_mode.crtc_clock check as soon
 	 * as Haswell has gained clock readout/fastboot support.
 	 *
-	 * We can ditch the crtc->fb check as soon as we can
+	 * We can ditch the crtc->primary->fb check as soon as we can
 	 * properly reconstruct framebuffers.
 	 */
 	return intel_crtc->active && crtc->primary->fb &&
@@ -2086,17 +2086,17 @@ static bool intel_alloc_plane_obj(struct intel_crtc=
 *crtc,
=20
 	if (plane_config->tiled) {
 		obj->tiling_mode =3D I915_TILING_X;
-		obj->stride =3D crtc->base.fb->pitches[0];
+		obj->stride =3D crtc->base.primary->fb->pitches[0];
 	}
=20
-	mode_cmd.pixel_format =3D crtc->base.fb->pixel_format;
-	mode_cmd.width =3D crtc->base.fb->width;
-	mode_cmd.height =3D crtc->base.fb->height;
-	mode_cmd.pitches[0] =3D crtc->base.fb->pitches[0];
+	mode_cmd.pixel_format =3D crtc->base.primary->fb->pixel_format;
+	mode_cmd.width =3D crtc->base.primary->fb->width;
+	mode_cmd.height =3D crtc->base.primary->fb->height;
+	mode_cmd.pitches[0] =3D crtc->base.primary->fb->pitches[0];
=20
 	mutex_lock(&dev->struct_mutex);
=20
-	if (intel_framebuffer_init(dev, to_intel_framebuffer(crtc->base.fb),
+	if (intel_framebuffer_init(dev, to_intel_framebuffer(crtc->base.primary->=
fb),
 				   &mode_cmd, obj)) {
 		DRM_DEBUG_KMS("intel fb init failed\n");
 		goto out_unref_obj;
@@ -2121,14 +2121,14 @@ static void intel_find_plane_obj(struct intel_crtc =
*intel_crtc,
 	struct intel_crtc *i;
 	struct intel_framebuffer *fb;
=20
-	if (!intel_crtc->base.fb)
+	if (!intel_crtc->base.primary->fb)
 		return;
=20
 	if (intel_alloc_plane_obj(intel_crtc, plane_config))
 		return;
=20
-	kfree(intel_crtc->base.fb);
-	intel_crtc->base.fb =3D NULL;
+	kfree(intel_crtc->base.primary->fb);
+	intel_crtc->base.primary->fb =3D NULL;
=20
 	/*
 	 * Failed to alloc the obj, check to see if we should share
@@ -2140,13 +2140,13 @@ static void intel_find_plane_obj(struct intel_crtc =
*intel_crtc,
 		if (c =3D=3D &intel_crtc->base)
 			continue;
=20
-		if (!i->active || !c->fb)
+		if (!i->active || !c->primary->fb)
 			continue;
=20
-		fb =3D to_intel_framebuffer(c->fb);
+		fb =3D to_intel_framebuffer(c->primary->fb);
 		if (i915_gem_obj_ggtt_offset(fb->obj) =3D=3D plane_config->base) {
-			drm_framebuffer_reference(c->fb);
-			intel_crtc->base.fb =3D c->fb;
+			drm_framebuffer_reference(c->primary->fb);
+			intel_crtc->base.primary->fb =3D c->primary->fb;
 			break;
 		}
 	}
@@ -2396,7 +2396,7 @@ void intel_display_handle_reset(struct drm_device *de=
v)
 		/*
 		 * FIXME: Once we have proper support for primary planes (and
 		 * disabling them without disabling the entire crtc) allow again
-		 * a NULL crtc->fb.
+		 * a NULL crtc->primary->fb.
 		 */
 		if (intel_crtc->active && crtc->primary->fb)
 			dev_priv->display.update_primary_plane(crtc,
@@ -5742,8 +5742,8 @@ static void i9xx_get_plane_config(struct intel_crtc *=
crtc,
 	int fourcc, pixel_format;
 	int aligned_height;
=20
-	crtc->base.fb =3D kzalloc(sizeof(struct intel_framebuffer), GFP_KERNEL);
-	if (!crtc->base.fb) {
+	crtc->base.primary->fb =3D kzalloc(sizeof(struct intel_framebuffer), GFP_=
KERNEL);
+	if (!crtc->base.primary->fb) {
 		DRM_DEBUG_KMS("failed to alloc fb\n");
 		return;
 	}
@@ -5756,8 +5756,8 @@ static void i9xx_get_plane_config(struct intel_crtc *=
crtc,
=20
 	pixel_format =3D val & DISPPLANE_PIXFORMAT_MASK;
 	fourcc =3D intel_format_to_fourcc(pixel_format);
-	crtc->base.fb->pixel_format =3D fourcc;
-	crtc->base.fb->bits_per_pixel =3D
+	crtc->base.primary->fb->pixel_format =3D fourcc;
+	crtc->base.primary->fb->bits_per_pixel =3D
 		drm_format_plane_cpp(fourcc, 0) * 8;
=20
 	if (INTEL_INFO(dev)->gen >=3D 4) {
@@ -5772,23 +5772,23 @@ static void i9xx_get_plane_config(struct intel_crtc=
 *crtc,
 	plane_config->base =3D base;
=20
 	val =3D I915_READ(PIPESRC(pipe));
-	crtc->base.fb->width =3D ((val >> 16) & 0xfff) + 1;
-	crtc->base.fb->height =3D ((val >> 0) & 0xfff) + 1;
+	crtc->base.primary->fb->width =3D ((val >> 16) & 0xfff) + 1;
+	crtc->base.primary->fb->height =3D ((val >> 0) & 0xfff) + 1;
=20
 	val =3D I915_READ(DSPSTRIDE(pipe));
-	crtc->base.fb->pitches[0] =3D val & 0xffffff80;
+	crtc->base.primary->fb->pitches[0] =3D val & 0xffffff80;
=20
-	aligned_height =3D intel_align_height(dev, crtc->base.fb->height,
+	aligned_height =3D intel_align_height(dev, crtc->base.primary->fb->height,
 					    plane_config->tiled);
=20
-	plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
+	plane_config->size =3D ALIGN(crtc->base.primary->fb->pitches[0] *
 				   aligned_height, PAGE_SIZE);
=20
 	DRM_DEBUG_KMS("pipe/plane %d/%d with fb: size=3D%dx%d@%d, offset=3D%x, pi=
tch %d, size 0x%x\n",
-		      pipe, plane, crtc->base.fb->width,
-		      crtc->base.fb->height,
-		      crtc->base.fb->bits_per_pixel, base,
-		      crtc->base.fb->pitches[0],
+		      pipe, plane, crtc->base.primary->fb->width,
+		      crtc->base.primary->fb->height,
+		      crtc->base.primary->fb->bits_per_pixel, base,
+		      crtc->base.primary->fb->pitches[0],
 		      plane_config->size);
=20
 }
@@ -6750,8 +6750,8 @@ static void ironlake_get_plane_config(struct intel_cr=
tc *crtc,
 	int fourcc, pixel_format;
 	int aligned_height;
=20
-	crtc->base.fb =3D kzalloc(sizeof(struct intel_framebuffer), GFP_KERNEL);
-	if (!crtc->base.fb) {
+	crtc->base.primary->fb =3D kzalloc(sizeof(struct intel_framebuffer), GFP_=
KERNEL);
+	if (!crtc->base.primary->fb) {
 		DRM_DEBUG_KMS("failed to alloc fb\n");
 		return;
 	}
@@ -6764,8 +6764,8 @@ static void ironlake_get_plane_config(struct intel_cr=
tc *crtc,
=20
 	pixel_format =3D val & DISPPLANE_PIXFORMAT_MASK;
 	fourcc =3D intel_format_to_fourcc(pixel_format);
-	crtc->base.fb->pixel_format =3D fourcc;
-	crtc->base.fb->bits_per_pixel =3D
+	crtc->base.primary->fb->pixel_format =3D fourcc;
+	crtc->base.primary->fb->bits_per_pixel =3D
 		drm_format_plane_cpp(fourcc, 0) * 8;
=20
 	base =3D I915_READ(DSPSURF(plane)) & 0xfffff000;
@@ -6780,23 +6780,23 @@ static void ironlake_get_plane_config(struct intel_=
crtc *crtc,
 	plane_config->base =3D base;
=20
 	val =3D I915_READ(PIPESRC(pipe));
-	crtc->base.fb->width =3D ((val >> 16) & 0xfff) + 1;
-	crtc->base.fb->height =3D ((val >> 0) & 0xfff) + 1;
+	crtc->base.primary->fb->width =3D ((val >> 16) & 0xfff) + 1;
+	crtc->base.primary->fb->height =3D ((val >> 0) & 0xfff) + 1;
=20
 	val =3D I915_READ(DSPSTRIDE(pipe));
-	crtc->base.fb->pitches[0] =3D val & 0xffffff80;
+	crtc->base.primary->fb->pitches[0] =3D val & 0xffffff80;
=20
-	aligned_height =3D intel_align_height(dev, crtc->base.fb->height,
+	aligned_height =3D intel_align_height(dev, crtc->base.primary->fb->height,
 					    plane_config->tiled);
=20
-	plane_config->size =3D ALIGN(crtc->base.fb->pitches[0] *
+	plane_config->size =3D ALIGN(crtc->base.primary->fb->pitches[0] *
 				   aligned_height, PAGE_SIZE);
=20
 	DRM_DEBUG_KMS("pipe/plane %d/%d with fb: size=3D%dx%d@%d, offset=3D%x, pi=
tch %d, size 0x%x\n",
-		      pipe, plane, crtc->base.fb->width,
-		      crtc->base.fb->height,
-		      crtc->base.fb->bits_per_pixel, base,
-		      crtc->base.fb->pitches[0],
+		      pipe, plane, crtc->base.primary->fb->width,
+		      crtc->base.primary->fb->height,
+		      crtc->base.primary->fb->bits_per_pixel, base,
+		      crtc->base.primary->fb->pitches[0],
 		      plane_config->size);
 }
=20
@@ -11780,15 +11780,15 @@ void intel_modeset_gem_init(struct drm_device *de=
v)
 	 */
 	mutex_lock(&dev->struct_mutex);
 	list_for_each_entry(c, &dev->mode_config.crtc_list, head) {
-		if (!c->fb)
+		if (!c->primary->fb)
 			continue;
=20
-		fb =3D to_intel_framebuffer(c->fb);
+		fb =3D to_intel_framebuffer(c->primary->fb);
 		if (intel_pin_and_fence_fb_obj(dev, fb->obj, NULL)) {
 			DRM_ERROR("failed to pin boot fb on pipe %d\n",
 				  to_intel_crtc(c)->pipe);
-			drm_framebuffer_unreference(c->fb);
-			c->fb =3D NULL;
+			drm_framebuffer_unreference(c->primary->fb);
+			c->primary->fb =3D NULL;
 		}
 	}
 	mutex_unlock(&dev->struct_mutex);
diff --git a/drivers/gpu/drm/i915/intel_fbdev.c b/drivers/gpu/drm/i915/inte=
l_fbdev.c
index d6d78c86c232..2b1d42dbfe13 100644
--- a/drivers/gpu/drm/i915/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/intel_fbdev.c
@@ -481,7 +481,7 @@ static bool intel_fbdev_init_bios(struct drm_device *de=
v,
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		intel_crtc =3D to_intel_crtc(crtc);
=20
-		if (!intel_crtc->active || !crtc->fb) {
+		if (!intel_crtc->active || !crtc->primary->fb) {
 			DRM_DEBUG_KMS("pipe %c not active or no fb, skipping\n",
 				      pipe_name(intel_crtc->pipe));
 			continue;
@@ -491,7 +491,7 @@ static bool intel_fbdev_init_bios(struct drm_device *de=
v,
 			DRM_DEBUG_KMS("found possible fb from plane %c\n",
 				      pipe_name(intel_crtc->pipe));
 			plane_config =3D &intel_crtc->plane_config;
-			fb =3D to_intel_framebuffer(crtc->fb);
+			fb =3D to_intel_framebuffer(crtc->primary->fb);
 			max_size =3D plane_config->size;
 		}
 	}
@@ -560,7 +560,7 @@ static bool intel_fbdev_init_bios(struct drm_device *de=
v,
 		if (!intel_crtc->active)
 			continue;
=20
-		WARN(!crtc->fb,
+		WARN(!crtc->primary->fb,
 		     "re-used BIOS config but lost an fb on crtc %d\n",
 		     crtc->base.id);
 	}
--=20
1.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__3_Apr_2014_12_24_35_+1100_QCYr4MKpqN.FNi=C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTPLhbAAoJEMDTa8Ir7ZwVjZ4P/iKjNBW3NACijdBp8B8kngZD
QzeQ4HJvjrd482JUkHXM1sbor747z2GMZdSIWJpHUBd8Q7UcOoEMyg1dUzcxbq6p
XMrBOriqcJ0TpSXPPpNPhQkkhFj31IgCTPUDlSKrGs7Ey/fuxTA85AI1ibdn/FpT
6fzFaR/84+pCgSO/WUixz9JPrmj2Se9DqoVT1sVFfJif2IZPQI0JhKM9kaKODRoi
HNWSg2qdgb8EydmrnwZFTZqD2BaEvy6GzByBEhfSatFiryxl09gKgJGo8VGL83TR
d6qpHNYY5aZo0ZXVouUyCiVDbR5gfGPhrHxsYKvPLoGFR2wclSTi2bYmsqDQc3o9
h6K0ejFLL9BIjS2BiUYwSItttuihIHnwZTBQve7Hj38b7XcmVggfrnYuWBvBdFdd
KOTB9/fuIYtdz6nsrEpJPUaYpZexgE6GZ3siNR2JiCexVnNZ24Fdr447QoqM54uO
lFcTEaChwUB7QCP9YQirk9bbYjATMv128MkajIlGqnQeAWZcm5Z4RkNm78tMZQQD
fxUeu7l5crrSPlmdt6QzLOD3gSX20p8vbgDgIQUgTyksHuMPOZADFQZ9Gu8TGOIX
obGPxymcTy+AG7OXpTG3WI2foAK0uC3F3uEdFQLarh/3VaQ+Z3n6+Q5Gx2JG+9Xq
p1U98/lGSy+jx93914Rc
=LEc8
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Apr_2014_12_24_35_+1100_QCYr4MKpqN.FNi=C--
