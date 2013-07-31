Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab3GaAZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:25:27 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36101 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758625Ab3GaAZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:25:24 -0400
Date: Wed, 31 Jul 2013 01:25:21 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1307310119420.15659@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

radeon, nouveau, exynos, intel, mgag200:

not all strictly regressions but there was probably only one patch I'd 
have really left out and it didn't seem worth respinning exynos to avoid 
it, the line change count is quite low.

radeon: regressions + more dynamic powermanagement fixes, since DPM is a 
new feature, and off by default I'd prefer to keep merging fixes since it 
has a large userbase already and I'd like to keep them on mainline
nouveau: is mostly regression fixes
i915: is a regression fix since Daniel is on holidays I've merged it.
mgag200: I've picked a bunch of targetted fixes from a big bunch of distro
patches,
exynos: build fixes mostly, one regression fix

I expect things will slow right down now, I may send on the intel early 
quirk from Jesse separatly, since I think the x86 maintainers acked it.

Dave.

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to e1b4d3036c07ff137955fb1c0197ab62534f46ec:

  drm/i915: fix missed hunk after GT access breakage (2013-07-31 09:54:09 +1000)

----------------------------------------------------------------
Alex Deucher (14):
      drm/radeon: fix audio dto programming on DCE4+
      drm/radeon/dpm: fix display gap programming on SI
      drm/radeon/dpm: fix si_calculate_memory_refresh_rate()
      drm/radeon/dpm: fix powertune handling for pci id 0x6835
      drm/radeon: properly handle cg on asics without UVD
      drm/radeon/atom: fix fb when fetching engine params
      drm/radeon/dpm: fix forcing performance state to low on cayman
      drm/radeon/si: disable cgcg and pg for now
      drm/radeon/dpm: disable cac setup on SI
      drm/radeon/dpm: fix and enable reclocking on SI
      drm/radeon/atom: initialize more atom interpretor elements to 0
      drm: fix 64 bit drm fixed point helpers
      drm/radeon/dpm: fix calculations in si_calculate_leakage_for_v_and_t_formula
      drm/radeon/dpm: re-enable cac control on SI

Ben Skeggs (1):
      drm/nouveau/vm: make vm refcount into a kref

Ben Widawsky (1):
      drm/i915: fix missed hunk after GT access breakage

Dave Airlie (4):
      Merge branch 'drm-fixes-3.11' of git://people.freedesktop.org/~agd5f/linux
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6
      Merge branch 'drm-fixes-3.11' of git://people.freedesktop.org/~agd5f/linux

Egbert Eich (4):
      drm/mgag200: Fix logic in mgag200_bo_pin() (v2)
      drm/mgag200: Add an crtc_disable callback to the crtc helper funcs
      drm/mgag200: Add sysfs support for connectors
      drm/mgag200: Fix LUT programming for 16bpp

Emil Velikov (2):
      drm/nv50/gpio: post-nv92 cards have 32 interrupt lines
      drm/nv50-/disp: remove dcb_outp_match call, and related variables

Ilia Mirkin (6):
      drm/nouveau/core: xtensa firmware size needs to be 0x40000 no matter what
      drm/nv50/mc: include vp in the fb error reporting mask
      drm/nv31/mpeg: fix mpeg engine initialization
      drm/nva3-/disp: fix hda eld writing, needs to be padded
      drm/nv40/mpeg: write magic value to channel object to make it work
      drm/nv31/mpeg: don't recognize nv3x cards as having nv44 graph class

Inki Dae (2):
      drm/exynos: fix module build error
      drm/exynos: consider common clock framework to g2d driver.

Maarten Lankhorst (3):
      drm/nouveau: fix null pointer dereference in poll_changed
      drm/nouveau: fix size check for cards without vm
      drm/nouveau: fix semaphore dmabuf obj

Roy Spliet (1):
      drm/nvc0/fb: take lock in nvc0_ram_put()

Sachin Kamat (1):
      drm/exynos: Remove module.h header inclusion

Takashi Iwai (1):
      drm/mgag200: Fix framebuffer pitch calculation

Wei Yongjun (1):
      drm/exynos: exynos_drm_ipp: fix return value check

 drivers/gpu/drm/exynos/exynos_ddc.c                |  1 -
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |  1 -
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  3 --
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            | 19 ++++++---
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |  1 -
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c           |  1 -
 drivers/gpu/drm/exynos/exynos_drm_ipp.c            | 13 +++---
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |  1 -
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |  1 -
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  1 -
 drivers/gpu/drm/exynos/exynos_hdmiphy.c            |  1 -
 drivers/gpu/drm/exynos/exynos_mixer.c              |  1 -
 drivers/gpu/drm/i915/i915_dma.c                    |  1 +
 drivers/gpu/drm/i915/i915_drv.h                    |  1 +
 drivers/gpu/drm/i915/intel_pm.c                    |  6 +++
 drivers/gpu/drm/mgag200/mgag200_mode.c             | 46 +++++++++++++++++++++-
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |  1 +
 drivers/gpu/drm/nouveau/core/engine/disp/hdanva3.c |  2 +
 drivers/gpu/drm/nouveau/core/engine/disp/hdanvd0.c |  2 +
 drivers/gpu/drm/nouveau/core/engine/disp/sornv50.c |  8 ----
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv31.c    |  9 +++--
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv40.c    |  1 +
 drivers/gpu/drm/nouveau/core/engine/xtensa.c       |  8 +++-
 drivers/gpu/drm/nouveau/core/include/subdev/vm.h   |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv50.c   | 22 +++++++----
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c   | 14 +++++--
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv50.c    | 10 ++---
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c      |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c      | 27 +++++--------
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  7 +++-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |  3 +-
 drivers/gpu/drm/nouveau/nv17_fence.c               |  2 +-
 drivers/gpu/drm/nouveau/nv50_fence.c               | 14 ++++---
 drivers/gpu/drm/radeon/atom.c                      |  5 +++
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |  2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |  7 +---
 drivers/gpu/drm/radeon/radeon_atombios.c           |  2 +-
 drivers/gpu/drm/radeon/si.c                        | 14 +++----
 drivers/gpu/drm/radeon/si_dpm.c                    | 39 +++++++++---------
 include/drm/drm_fixed.h                            | 14 +++----
 41 files changed, 192 insertions(+), 125 deletions(-)
