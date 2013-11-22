Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3KVGIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 01:08:40 -0500
Received: from gir.skynet.ie ([193.1.99.77]:38048 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab3KVGIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 01:08:38 -0500
Date: Fri, 22 Nov 2013 06:08:35 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1311220604020.16837@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1564203473-1385100515=:16837"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1564203473-1385100515=:16837
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

was going to leave this until post -rc1 but sysfs fixes broke hotplug in 
userspace, so I had to fix it harder, otherwise a set of pulls from intel, 
radeon and vmware, 

the vmware/ttm changes are bit larger but since its early and they are 
unlikely to break anything else I put them in, it lets vmware work with 
dri3.

Dave.


The following changes since commit 527d1511310a89650000081869260394e20c7013:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2013-11-20 15:13:47 -0800)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 760c960bd6880cf22a57c0af9ff60c96250aad39:

  drm/sysfs: fix hotplug regression since lifetime changes (2013-11-21 21:10:00 +1000)

----------------------------------------------------------------
Alex Deucher (4):
      drm/radeon: cypress_dpm: Fix unused variable warning when CONFIG_ACPI=n
      drm/radeon/vm: don't attempt to update ptes if ib allocation fails
      drm/radeon: adjust TN dpm parameters for stability (v2)
      drm/radeon: enable DPM by default in TN asics

Andrew Lewycky (1):
      drm/radeon: use a single doorbell for cik kms compute

Chris Wilson (2):
      drm/i915: Hold pc8 lock around toggling pc8.gpu_idle
      drm/i915: Do not enable package C8 on unsupported hardware

Christian König (3):
      drm/radeon: add semaphore trace point
      drm/radeon: allow semaphore emission to fail
      drm/radeon: disable CIK CP semaphores for now

Daniel Vetter (7):
      drm/i915: flush cursors harder
      Partially revert "drm/i915: tune the RC6 threshold for stability"
      drm/i915: restore the early forcewake cleanup
      drm/i915/tv: add ->get_config callback
      drm/i915: encoder->get_config is no longer optional
      drm/i915: Replicate BIOS eDP bpp clamping hack for hsw
      drm/i915: Fix gen3 self-refresh watermarks

Dave Airlie (4):
      Merge branch 'drm-next-3.13' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'drm-intel-fixes-2013-11-20' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'vmwgfx-fixes-3.13' of git://people.freedesktop.org/~thomash/linux into drm-fixes
      Merge branch 'ttm-fixes-3.13' of git://people.freedesktop.org/~thomash/linux into drm-fixes

David Herrmann (1):
      drm/sysfs: fix hotplug regression since lifetime changes

Duncan Laurie (1):
      i915: Use 120MHz LVDS SSC clock for gen5/gen6/gen7

Fabio Estevam (1):
      drm: radeon: ni_dpm: Fix unused variable warning when CONFIG_ACPI=n

Inki Dae (1):
      drm/exynos: g2d: fix memory leak to userptr

Jani Nikula (1):
      drm/i915/dp: set sink to power down mode on dp disable

Jerome Glisse (2):
      radeon/i2c: do not count reg index in number of i2c byte we are writing.
      radeon: workaround pinning failure on low ram gpu

Jesse Barnes (1):
      x86/early quirk: use gen6 stolen detection for VLV

Michel Dänzer (2):
      drm/radeon/cik: Return backend map information to userspace
      drm/radeon/cik: Add macrotile mode array query

Samuel Li (1):
      drm/radeon: hook up backlight functions for CI and KV family.

Thomas Hellstrom (8):
      drm/ttm: Allow execbuf util reserves without ticket
      drm/vmwgfx: Fix false lockdep warning
      drm/ttm: Add a minimal prime implementation for ttm base objects
      drm/vmwgfx: Hook up the prime ioctls
      drm/vmwgfx: Make surfaces prime-aware
      drm/vmwgfx: Make vmwgfx dma buffers prime aware
      drm/ttm: Don't move non-existing data
      drm/ttm: Remove set_need_resched from the ttm fault handler

 arch/x86/kernel/early-quirks.c              |   4 +-
 drivers/gpu/drm/drm_sysfs.c                 |  40 ++++-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c     |   2 +
 drivers/gpu/drm/i915/i915_drv.h             |   1 +
 drivers/gpu/drm/i915/intel_bios.c           |   7 +-
 drivers/gpu/drm/i915/intel_ddi.c            |  20 +++
 drivers/gpu/drm/i915/intel_display.c        |  33 +++-
 drivers/gpu/drm/i915/intel_dp.c             |   2 +-
 drivers/gpu/drm/i915/intel_pm.c             |   4 +-
 drivers/gpu/drm/i915/intel_tv.c             |   8 +
 drivers/gpu/drm/i915/intel_uncore.c         |  26 +--
 drivers/gpu/drm/radeon/atombios_i2c.c       |   6 +-
 drivers/gpu/drm/radeon/cik.c                |  57 ++++---
 drivers/gpu/drm/radeon/cik_sdma.c           |  13 +-
 drivers/gpu/drm/radeon/cypress_dpm.c        |   2 +
 drivers/gpu/drm/radeon/evergreen_dma.c      |   9 +-
 drivers/gpu/drm/radeon/ni_dpm.c             |   2 +-
 drivers/gpu/drm/radeon/r100.c               |   3 +-
 drivers/gpu/drm/radeon/r600.c               |  13 +-
 drivers/gpu/drm/radeon/r600_dma.c           |  13 +-
 drivers/gpu/drm/radeon/radeon.h             |  38 +++--
 drivers/gpu/drm/radeon/radeon_asic.c        |   4 +
 drivers/gpu/drm/radeon/radeon_asic.h        |  18 +-
 drivers/gpu/drm/radeon/radeon_cs.c          |   9 +-
 drivers/gpu/drm/radeon/radeon_device.c      |  47 +++--
 drivers/gpu/drm/radeon/radeon_drv.c         |   3 +-
 drivers/gpu/drm/radeon/radeon_fence.c       |  30 ++++
 drivers/gpu/drm/radeon/radeon_gart.c        |   6 +-
 drivers/gpu/drm/radeon/radeon_kms.c         |  11 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |  28 +++
 drivers/gpu/drm/radeon/radeon_pm.c          |   2 +-
 drivers/gpu/drm/radeon/radeon_ring.c        |  46 ++---
 drivers/gpu/drm/radeon/radeon_semaphore.c   | 129 ++++++++++----
 drivers/gpu/drm/radeon/radeon_trace.h       |  36 ++++
 drivers/gpu/drm/radeon/rv770_dma.c          |   9 +-
 drivers/gpu/drm/radeon/si_dma.c             |   9 +-
 drivers/gpu/drm/radeon/trinity_dpm.c        |   6 +-
 drivers/gpu/drm/radeon/uvd_v1_0.c           |   4 +-
 drivers/gpu/drm/radeon/uvd_v3_1.c           |   4 +-
 drivers/gpu/drm/ttm/ttm_bo.c                |  35 +++-
 drivers/gpu/drm/ttm/ttm_bo_util.c           |   7 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c             |  26 ++-
 drivers/gpu/drm/ttm/ttm_execbuf_util.c      |  32 ++--
 drivers/gpu/drm/ttm/ttm_object.c            | 254 +++++++++++++++++++++++++++-
 drivers/gpu/drm/vmwgfx/Makefile             |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c         |   7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h         |  14 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_prime.c       | 137 +++++++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c    |  63 +++----
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c     |  30 ++--
 include/drm/ttm/ttm_bo_api.h                |   4 +-
 include/drm/ttm/ttm_execbuf_util.h          |   3 +-
 include/drm/ttm/ttm_object.h                |  61 ++++++-
 include/uapi/drm/radeon_drm.h               |   2 +
 54 files changed, 1057 insertions(+), 324 deletions(-)
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
--29444707-1564203473-1385100515=:16837--
