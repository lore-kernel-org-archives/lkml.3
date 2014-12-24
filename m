Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaLXDSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 22:18:39 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49386 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaLXDSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 22:18:37 -0500
Date: Wed, 24 Dec 2014 03:18:34 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1412240317120.8488@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Linus,

Xmas fixes pull:

core: one atomic fix, revert the WARN_ON dumb buffers patch.
agp: fixup Dave J.
nouveau: fix 3.18 regression for old userspace
tegra fixes: vblank and iommu fixes
amdkfd: fix bugs shown by testing with userspace, init apertures once
msm:  hdmi fixes and cleanup
i915: misc fixes

There is also a link ordering fix that I've asked to be cc'ed to you,
putting iommu before gpu, it fixes an issue with amdkfd when things are 
all in the kernel, but I didn't like sending it via my tree without 
discussion.

I'll probably be a bit on/off for a few weeks with pulls now, due to
holidays and LCA, so don't be surprised if stuff gets a bit backed up,
and things end up a bit large due to lag.

Dave.

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to da6b51d007da17fd394405055e2f0109ec5f05f4:

  Revert "drm/gem: Warn on illegal use of the dumb buffer interface v2" (2014-12-24 13:13:22 +1000)

----------------------------------------------------------------
Alexey Skidanov (1):
      amdkfd: init aperture once per process

Chris Wilson (3):
      drm/i915: Invalidate media caches on gen7
      drm/i915: Force the CS stall for invalidate flushes
      drm/i915: Disable PSMI sleep messages on all rings around context switches

Dave Airlie (7):
      nouveau: bring back legacy mmap handler
      Merge branch 'msm-fixes-3.19' of git://people.freedesktop.org/~robclark/linux into drm-fixes
      Merge tag 'topic/atomic-fixes-2014-12-17' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge tag 'drm-intel-next-fixes-2014-12-17' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge tag 'drm/tegra/for-3.19-rc1-fixes' of git://people.freedesktop.org/~tagr/linux into drm-fixes
      Merge tag 'amdkfd-fixes-2014-12-23' of git://people.freedesktop.org/~gabbayo/linux into drm-fixes
      Revert "drm/gem: Warn on illegal use of the dumb buffer interface v2"

Dave Jones (1):
      agp: Fix up email address & attributions in AGP MODULE_AUTHOR tags

Imre Deak (3):
      drm/i915: vlv: fix IRQ masking when uninstalling interrupts
      drm/i915: move RPS PM_IER enabling to gen6_enable_rps_interrupts
      drm/i915: sanitize RPS resetting during GPU reset

Jilai Wang (2):
      drm/msm/hdmi: enable regulators before clocks to avoid warnings
      drm/msm/hdmi: rework HDMI IRQ handler

Markus Elfring (2):
      drm/msm: Deletion of unnecessary checks before two function calls
      drm/msm: Deletion of unnecessary checks before the function call "release_firmware"

Oded Gabbay (3):
      drm/amd: Add get_fw_version to kfd-->kgd interface
      drm/radeon: Add implementation of get_fw_version
      amdkfd: Display MEC fw version in topology node

Rob Clark (3):
      drm/atomic: fix potential null ptr on plane enable
      drm/msm: block incoming update on pending updates
      drm/msm/mdp5: update irqs on crtc<->encoder link change

Sean Paul (1):
      drm/tegra: dc: Select root window for event dispatch

Thierry Reding (7):
      drm/irq: Add drm_crtc_send_vblank_event()
      drm/irq: Add drm_crtc_handle_vblank()
      drm/irq: Add drm_crtc_vblank_count()
      drm/tegra: dc: Consistently use the same pipe
      drm/tegra: dc: Fix a potential race on page-flip completion
      drm/tegra: gem: Flush buffer objects upon allocation
      drm/tegra: gem: Use the proper size for GEM objects

 drivers/char/agp/ali-agp.c                      |  2 +-
 drivers/char/agp/amd64-agp.c                    |  2 +-
 drivers/char/agp/ati-agp.c                      |  2 +-
 drivers/char/agp/backend.c                      |  2 +-
 drivers/char/agp/intel-agp.c                    |  2 +-
 drivers/char/agp/intel-gtt.c                    |  2 +-
 drivers/char/agp/nvidia-agp.c                   |  2 +-
 drivers/char/agp/via-agp.c                      |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c        |  4 --
 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c    |  6 +--
 drivers/gpu/drm/amd/amdkfd/kfd_process.c        |  9 ++++
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c       |  8 ++-
 drivers/gpu/drm/amd/include/kgd_kfd_interface.h | 15 ++++++
 drivers/gpu/drm/drm_atomic_helper.c             |  2 +-
 drivers/gpu/drm/drm_irq.c                       | 60 +++++++++++++++++++++
 drivers/gpu/drm/i915/i915_drv.c                 |  6 ++-
 drivers/gpu/drm/i915/i915_drv.h                 |  5 +-
 drivers/gpu/drm/i915/i915_gem.c                 | 28 ++--------
 drivers/gpu/drm/i915/i915_gem_context.c         | 48 ++++++++++++++---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c      |  3 --
 drivers/gpu/drm/i915/i915_irq.c                 | 18 +++++--
 drivers/gpu/drm/i915/i915_reg.h                 |  3 ++
 drivers/gpu/drm/i915/intel_pm.c                 | 28 ++++++----
 drivers/gpu/drm/i915/intel_ringbuffer.c         |  3 ++
 drivers/gpu/drm/msm/adreno/adreno_gpu.c         |  6 +--
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c       | 53 ++++++++-----------
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c        | 11 +---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c        | 12 +----
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c         | 12 +----
 drivers/gpu/drm/msm/mdp/mdp_kms.c               |  9 ++--
 drivers/gpu/drm/msm/mdp/mdp_kms.h               |  2 +-
 drivers/gpu/drm/msm/msm_atomic.c                | 69 ++++++++++++++++++++++++-
 drivers/gpu/drm/msm/msm_drv.c                   |  1 +
 drivers/gpu/drm/msm/msm_drv.h                   |  4 ++
 drivers/gpu/drm/msm/msm_fbdev.c                 |  3 +-
 drivers/gpu/drm/msm/msm_gem.c                   |  3 +-
 drivers/gpu/drm/nouveau/nouveau_display.c       |  9 ----
 drivers/gpu/drm/nouveau/nouveau_gem.c           |  3 --
 drivers/gpu/drm/nouveau/nouveau_ttm.c           |  3 +-
 drivers/gpu/drm/radeon/radeon_gem.c             | 26 ++--------
 drivers/gpu/drm/radeon/radeon_kfd.c             | 53 +++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_object.c          |  3 --
 drivers/gpu/drm/tegra/dc.c                      | 48 ++++++++++++-----
 drivers/gpu/drm/tegra/drm.c                     | 16 +++---
 drivers/gpu/drm/tegra/gem.c                     | 52 ++++++++++++++-----
 include/drm/drmP.h                              |  4 ++
 include/drm/drm_gem.h                           |  7 ---
 47 files changed, 450 insertions(+), 221 deletions(-)
