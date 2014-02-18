Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaBRXRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:17:07 -0500
Received: from gir.skynet.ie ([193.1.99.77]:51937 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbaBRXRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:17:00 -0500
Date: Tue, 18 Feb 2014 23:16:57 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1402182315000.10262@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1050780251-1392765417=:10262"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1050780251-1392765417=:10262
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Lots of little small things, nothing too major, nouveau regression fixes,
vmware fixes for the new hw support, memory leaks in error path fixes.

Dave.

The following changes since commit 60f76eab19e3903e810bdc3ec846c158efcd2e21:

  Merge tag 'dma-buf-for-3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/sumits/dma-buf (2014-02-17 12:42:45 -0800)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 75936c65dda54a08d9124f24f8725f86a4adc286:

  Merge tag 'ttm-fixes-3.14-2014-02-18' of git://people.freedesktop.org/~thomash/linux into drm-fixes (2014-02-19 08:21:26 +1000)

----------------------------------------------------------------

Alex Deucher (7):
      drm/radeon: unify bpc handling
      drm: add DRM_CAPs for cursor size
      drm/radeon: fill in DRM_CAPs for cursor size
      drm/radeon/dpm: reduce r7xx vblank mclk threshold to 200
      drm/radeon: fix display tiling setup on SI
      drm/radeon/si: fix typo in dpm sq ramping setup
      drm/radeon/ni: fix typo in dpm sq ramping setup

Alexandre Courbot (2):
      drm/nouveau: fix ENG_RUNLIST register address
      drm/ttm: declare 'struct device' in ttm_page_alloc.h

Charmaine Lee (1):
      drm/vmwgfx: Get maximum mob size from register SVGA_REG_MOB_MAX_SIZE

Christian König (1):
      drm/radeon: fix CP semaphores on CIK

Dan Carpenter (2):
      drm/vmwgfx: unlock on error path in vmw_execbuf_process()
      drm/radeon: delete a stray tab

Dave Airlie (6):
      Merge branch 'tda998x-fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-fixes
      Merge tag 'drm-intel-fixes-2014-02-14' of ssh://git.freedesktop.org/git/drm-intel into drm-fixes
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge branch 'drm-fixes-3.14' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'vmwgfx-fixes-3.14-2014-02-18' of git://people.freedesktop.org/~thomash/linux into drm-fixes
      Merge tag 'ttm-fixes-3.14-2014-02-18' of git://people.freedesktop.org/~thomash/linux into drm-fixes

Dave Jones (1):
      drm/i2c: tda998x: Fix memory leak in tda998x_encoder_init error path.

Emil Velikov (1):
      drm/nouveau/fb: use correct ram oclass for nv1a hardware

Ilia Mirkin (7):
      drm/nouveau: set irq_enabled manually
      drm/nv4c/mc: nv4x igp's have a different msi rearm register
      drm/nv4c/vga: decode register is in a different place on nv4x igp's
      drm/nv4c/bios: disallow retrieving from prom on nv4x igp's
      drm/nv50/gr: add missing nv_error parameter priv
      drm/nv50/disp: use correct register to determine DP display bpp
      drm/nouveau: fix TTM_PL_TT memtype on pre-nv50

Jani Nikula (2):
      drm/i915/dp: increase native aux defer retry timeout
      drm/i915/dp: add native aux defer retry limit

Masanari Iida (1):
      drm/ttm: Fix memory leak in ttm_agp_backend.c

Thomas Hellstrom (4):
      drm/vmwgfx: Fix a couple of sparse warnings and errors
      drm/vmwgfx: Remove stray const
      drm/vmwgfx: Fix possible integer overflow
      drm/vmwgfx: Fix command defines and checks

Ville Syrjälä (2):
      drm/i915: Add intel_ring_cachline_align()
      drm/i915: Prevent MI_DISPLAY_FLIP straddling two cachelines on IVB

 drivers/gpu/drm/drm_ioctl.c                       |  12 +++
 drivers/gpu/drm/i2c/tda998x_drv.c                 |   4 +-
 drivers/gpu/drm/i915/intel_display.c              |  14 +++
 drivers/gpu/drm/i915/intel_dp.c                   |  19 ++--
 drivers/gpu/drm/i915/intel_ringbuffer.c           |  21 ++++
 drivers/gpu/drm/i915/intel_ringbuffer.h           |   1 +
 drivers/gpu/drm/nouveau/Makefile                  |   1 +
 drivers/gpu/drm/nouveau/core/engine/device/nv40.c |  10 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c   |   2 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c   |   2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv50.c  |   2 +-
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h  |   1 +
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c   |   4 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv1a.c     |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.h     |   1 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv44.c     |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c     |  45 ++++++++
 drivers/gpu/drm/nouveau/nouveau_bo.c              |   2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c             |   3 +
 drivers/gpu/drm/nouveau/nouveau_vga.c             |   4 +-
 drivers/gpu/drm/radeon/atombios_crtc.c            |  15 +--
 drivers/gpu/drm/radeon/atombios_encoders.c        |   7 +-
 drivers/gpu/drm/radeon/evergreen.c                |   2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                   |   2 +-
 drivers/gpu/drm/radeon/radeon.h                   |   4 +-
 drivers/gpu/drm/radeon/radeon_display.c           |   2 +
 drivers/gpu/drm/radeon/radeon_ring.c              |   2 +-
 drivers/gpu/drm/radeon/radeon_semaphore.c         |  19 +++-
 drivers/gpu/drm/radeon/rv770_dpm.c                |   9 +-
 drivers/gpu/drm/radeon/si_dpm.c                   |   2 +-
 drivers/gpu/drm/ttm/ttm_agp_backend.c             |   1 +
 drivers/gpu/drm/vmwgfx/svga3d_reg.h               | 122 +++++++++++++---------
 drivers/gpu/drm/vmwgfx/svga3d_surfacedefs.h       |  11 +-
 drivers/gpu/drm/vmwgfx/svga_reg.h                 |   9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_context.c           |   9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c               |   3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h               |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c           |   9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c             |   3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c            |  16 +--
 include/drm/drm_crtc.h                            |   3 +
 include/drm/ttm/ttm_page_alloc.h                  |   2 +
 include/uapi/drm/drm.h                            |   2 +
 include/uapi/drm/vmwgfx_drm.h                     |   1 +
 44 files changed, 292 insertions(+), 116 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c
--29444707-1050780251-1392765417=:10262--
