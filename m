Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbaFSBDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:03:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43493 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756604AbaFSBDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:03:37 -0400
Date: Thu, 19 Jun 2014 02:03:34 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1406190146530.16998@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1475751128-1403139814=:16998"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1475751128-1403139814=:16998
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

this looks bigger than it is, as one of the nouveau firmware fixes 
"drm/gf100-/gr: report class data to host on fwmthd failure" regenerates a 
bunch of the firmware files after changing the assembly by a few lines,
without that, its more of a
" 36 files changed, 370 insertions(+), 129 deletions(-)"

It contains some vt.c fixes acked by Greg, for rare hard hangs on i915 
loading, that also fixes hangs on reload and spurious register write 
errors,
drm core: one fix for uninit memory,
nouveau: displayport rework caused a few regressions, Ben has been fixing
them as the appear, along with some other fixes
radeon: pageflipping regression fix, deep color fix, mode validation fixes
i915: fbc disable, vga console kick off, backlight fix, div 0 fix.

Dave.

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 884d6147ba19640a40fb45efe64360cdf92cac27:

  Merge tag 'drm-intel-fixes-2014-06-17' of git://anongit.freedesktop.org/drm-intel into drm-next (2014-06-19 10:54:35 +1000)

----------------------------------------------------------------

Alex Deucher (2):
      drm/radeon: update mode_valid testing for DP
      drm/radeon: improve dvi_mode_valid

Ben Skeggs (8):
      drm/gk104/clk: only touch divider for mode we'll be using
      drm/gk104/ibus: increase various random timeouts
      drm/gf100-/gr: report class data to host on fwmthd failure
      drm/gk104/fb/ram: fixups from an earlier search+replace
      drm/nouveau/disp/dp: don't touch link config after success
      drm/nv50/disp: fix a potential oops in supervisor handling
      drm/nouveau/pwr: fix typo in fifo wrap handling
      drm/gf117/i2c: no aux channels on this chipset

Chris Wilson (3):
      drm/i915: Disable FBC by default also on Haswell and later
      drm/i95: Initialize active ring->pid to -1
      drm/i915: Reorder semaphore deadlock check

Daniel Vetter (5):
      vt: Fix replacement console check when unbinding
      vt: Fix up unregistration of vt drivers
      vt: Don't ignore unbind errors in vt_unbind
      drm/i915: Fixup global gtt cleanup
      drm/i915: Kick out vga console

Dave Airlie (5):
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-next-3.16' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-fixes-3.16' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge tag 'drm-intel-fixes-2014-06-17' of git://anongit.freedesktop.org/drm-intel into drm-next

Fredrik Höglund (1):
      drm/radeon: use pixel formats instead of depth/bpp

Imre Deak (1):
      drm/i915: fix possible refcount leak when resetting forcewake

Jani Nikula (2):
      drm/i915: set backlight duty cycle after backlight enable for gen4
      Merge remote-tracking branch 'drm-intel/topic/kicking-dogs-and-vgacon' into drm-intel-fixes

Maarten Lankhorst (1):
      drm/nouveau/disp: fix oops in destructor with headless cards

Mario Kleiner (3):
      drm/radeon: Bypass hw lut's for > 8 bpc framebuffer scanout.
      drm/nouveau/kms: reference vblank for crtc during pageflip.
      drm/radeon: Use dce5/6 hdmi deep color clock setup also on dce8+

Martin Peres (1):
      drm/nouveau/doc: update the thermal documentation

Michel Dänzer (2):
      Revert "drm/radeon: remove drm_vblank_get|put from pflip handling"
      drm/radeon: Fix radeon_irq_kms_pflip_irq_get/put() imbalance

Pierre Moreau (2):
      drm/nv50/gr: fix overlap while zeroing zcull regions
      drm/nv50/gr: remove an unneeded write while initialising PGRAPH

Rob Clark (1):
      drm: fix uninitialized acquire_ctx fields (v2)

Tom O'Rourke (1):
      drm/i915/bdw: remove erroneous chv specific workarounds from bdw code

Ville Syrjälä (1):
      drm/i915: Avoid div-by-zero when pixel_multiplier is zero

 Documentation/thermal/nouveau_thermal              |   7 +-
 drivers/gpu/drm/drm_modeset_lock.c                 |   1 +
 drivers/gpu/drm/i915/i915_dma.c                    |  47 ++-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |   9 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |   3 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  18 +-
 drivers/gpu/drm/i915/intel_panel.c                 |   5 +-
 drivers/gpu/drm/i915/intel_pm.c                    |   9 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   2 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   4 +-
 drivers/gpu/drm/i915/intel_uncore.c                |   3 +-
 drivers/gpu/drm/nouveau/Makefile                   |   1 +
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |   2 +-
 drivers/gpu/drm/nouveau/core/engine/disp/base.c    |   6 +-
 drivers/gpu/drm/nouveau/core/engine/disp/dport.c   |   7 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |   2 +-
 .../gpu/drm/nouveau/core/engine/graph/fuc/gpc.fuc  |   2 +-
 .../gpu/drm/nouveau/core/engine/graph/fuc/hub.fuc  |  18 +-
 .../nouveau/core/engine/graph/fuc/hubgm107.fuc5.h  | 460 ++++++++++-----------
 .../nouveau/core/engine/graph/fuc/hubnv108.fuc5.h  | 460 ++++++++++-----------
 .../nouveau/core/engine/graph/fuc/hubnvc0.fuc.h    | 188 ++++++---
 .../nouveau/core/engine/graph/fuc/hubnvd7.fuc.h    | 188 ++++++---
 .../nouveau/core/engine/graph/fuc/hubnve0.fuc.h    | 170 +++++---
 .../nouveau/core/engine/graph/fuc/hubnvf0.fuc.h    | 170 +++++---
 .../drm/nouveau/core/engine/graph/fuc/macros.fuc   |   6 +
 drivers/gpu/drm/nouveau/core/engine/graph/fuc/os.h |   1 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv50.c   |   9 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |  41 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |   2 +
 drivers/gpu/drm/nouveau/core/include/subdev/i2c.h  |   1 +
 drivers/gpu/drm/nouveau/core/subdev/clock/nve0.c   |   8 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnve0.c   |  76 ++--
 drivers/gpu/drm/nouveau/core/subdev/i2c/gf117.c    |  39 ++
 drivers/gpu/drm/nouveau/core/subdev/ibus/nve0.c    |  19 +-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/host.fuc   |   2 +-
 .../drm/nouveau/core/subdev/pwr/fuc/nv108.fuc.h    |   2 +-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nva3.fuc.h |   2 +-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvc0.fuc.h |   2 +-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvd0.fuc.h |   2 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |   7 +
 drivers/gpu/drm/radeon/atombios_crtc.c             | 118 +++++-
 drivers/gpu/drm/radeon/evergreen_reg.h             |   2 +
 drivers/gpu/drm/radeon/r500_reg.h                  |   1 +
 drivers/gpu/drm/radeon/radeon_connectors.c         |  35 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  22 +-
 drivers/tty/vt/vt.c                                |  24 +-
 drivers/video/console/dummycon.c                   |   1 +
 drivers/video/console/vgacon.c                     |   1 +
 48 files changed, 1373 insertions(+), 832 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/gf117.c
--29444707-1475751128-1403139814=:16998--
