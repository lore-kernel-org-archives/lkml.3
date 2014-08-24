Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaHXGiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 02:38:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38530 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbaHXGiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 02:38:54 -0400
Date: Sun, 24 Aug 2014 07:38:50 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm intel and radeon fixes
Message-ID: <alpine.DEB.2.00.1408240730570.1562@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1706360869-1408862330=:1562"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1706360869-1408862330=:1562
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

post KS/LC git requests from i915 and radeon stacked up, they are all 
fixes along with some new pci ids for radeon, and one maintainers file 
entry.

i915: display fixes and irq fixes
radeon: pci ids, and misc gpuvm, dpm and hdp cache 

Dave.

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to a284e9d14e35b776807c3a40dd1ff1e05429d4a4:

  MAINTAINERS: Add entry for Renesas DRM drivers (2014-08-24 16:37:47 +1000)

----------------------------------------------------------------
Alex Deucher (12):
      drm/radeon: add bapm module parameter
      drm/radeon: use pfp for all vm_flush related updates
      drm/radeon/dpm: select the appropriate vce power state for KV/KB/ML
      drm/radeon: fix pm handling in radeon_gpu_reset
      drm/radeon: fix display handling in radeon_gpu_reset
      drm/radeon: re-enable selective GPUVM flushing
      drm/radeon: fix active cu count for SI and CIK
      drm/radeon: fix active_cu mask on SI and CIK after re-init (v3)
      Revert "drm/radeon: Use write-combined CPU mappings of ring buffers with PCIe"
      drm/radeon: add new KV pci id
      drm/radeon: add new bonaire pci ids
      drm/radeon: add additional SI pci ids

Andreas Ruprecht (1):
      drm/radeon: Remove duplicate include from Makefile

Christian König (2):
      drm/radeon: properly document reloc priority mask
      drm/radeon: Sync ME and PFP after CP semaphore waits v4

Dan Carpenter (1):
      drm/radeon: add a check for allocation failure (v2)

Dave Airlie (4):
      Merge branch 'drm-fixes-3.17' of git://people.freedesktop.org/~agd5f/linux
      Merge branch 'drm-fixes-3.17' of git://people.freedesktop.org/~agd5f/linux
      Merge tag 'drm-intel-fixes-2014-08-21' of git://anongit.freedesktop.org/drm-intel
      Merge branch 'drm-fixes-3.17' of git://people.freedesktop.org/~agd5f/linux into drm-next

Imre Deak (5):
      drm/i915: take display port power domain in DP HPD handler
      drm/i915: fix HPD IRQ reenable work cancelation
      drm/i915: cancel hotplug and dig_port work during suspend and unload
      drm/i915: make sure VDD is turned off during system suspend
      drm/i915: don't try to retrain a DP link on an inactive CRTC

Laurent Pinchart (1):
      MAINTAINERS: Add entry for Renesas DRM drivers

Michel Dänzer (2):
      drm/radeon: Always flush VM again on < CIK
      drm/radeon: Only flush HDP cache for indirect buffers from userspace

Oleg Chernovskiy (1):
      drm/radeon: Add missing lines to ci_set_thermal_temperature_range

Pali Rohár (1):
      drm/radeon: Add ability to get and change dpm state when radeon PX card is turned off

Ville Syrjälä (3):
      drm/i915: Fix locking for intel_enable_pipe_a()
      drm/i915: Skip load detect when intel_crtc->new_enable==true
      drm/i915: Don't try to enable cursor from setplane when crtc is disabled

 MAINTAINERS                               | 11 ++++++++
 drivers/gpu/drm/i915/i915_drv.c           | 33 ++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_drv.h           |  3 ++-
 drivers/gpu/drm/i915/i915_irq.c           | 33 +++++++++---------------
 drivers/gpu/drm/i915/intel_crt.c          |  7 ++++-
 drivers/gpu/drm/i915/intel_display.c      | 39 +++++++++++-----------------
 drivers/gpu/drm/i915/intel_dp.c           | 33 ++++++++++++++++++++----
 drivers/gpu/drm/i915/intel_drv.h          |  9 +++++--
 drivers/gpu/drm/i915/intel_tv.c           |  7 ++++-
 drivers/gpu/drm/radeon/Makefile           |  2 +-
 drivers/gpu/drm/radeon/ci_dpm.c           |  3 +++
 drivers/gpu/drm/radeon/cik.c              | 43 +++++++++++++++++++++----------
 drivers/gpu/drm/radeon/cik_sdma.c         |  6 ++---
 drivers/gpu/drm/radeon/evergreen.c        |  4 +--
 drivers/gpu/drm/radeon/evergreen_dma.c    |  2 +-
 drivers/gpu/drm/radeon/kv_dpm.c           | 11 +++++---
 drivers/gpu/drm/radeon/ni.c               |  4 +--
 drivers/gpu/drm/radeon/r100.c             |  8 +++---
 drivers/gpu/drm/radeon/r200.c             |  2 +-
 drivers/gpu/drm/radeon/r300.c             |  2 +-
 drivers/gpu/drm/radeon/r420.c             |  4 +--
 drivers/gpu/drm/radeon/r600.c             | 26 ++++++++++++++++---
 drivers/gpu/drm/radeon/r600_dma.c         |  6 ++---
 drivers/gpu/drm/radeon/r600d.h            |  1 +
 drivers/gpu/drm/radeon/radeon.h           |  9 ++++---
 drivers/gpu/drm/radeon/radeon_cs.c        |  9 ++++---
 drivers/gpu/drm/radeon/radeon_device.c    | 34 ++++++++++++++++++++++--
 drivers/gpu/drm/radeon/radeon_drv.c       |  4 +++
 drivers/gpu/drm/radeon/radeon_ib.c        |  5 ++--
 drivers/gpu/drm/radeon/radeon_pm.c        | 16 +++++-------
 drivers/gpu/drm/radeon/radeon_ring.c      | 20 +++++++-------
 drivers/gpu/drm/radeon/radeon_semaphore.c |  2 +-
 drivers/gpu/drm/radeon/radeon_test.c      | 18 ++++++-------
 drivers/gpu/drm/radeon/radeon_uvd.c       |  2 +-
 drivers/gpu/drm/radeon/radeon_vce.c       |  6 ++---
 drivers/gpu/drm/radeon/radeon_vm.c        | 10 ++++---
 drivers/gpu/drm/radeon/rv515.c            |  2 +-
 drivers/gpu/drm/radeon/rv770_dma.c        |  2 +-
 drivers/gpu/drm/radeon/si.c               | 19 +++++++-------
 drivers/gpu/drm/radeon/si_dma.c           |  2 +-
 drivers/gpu/drm/radeon/trinity_dpm.c      | 24 ++++++++++-------
 drivers/gpu/drm/radeon/uvd_v1_0.c         |  4 +--
 include/drm/drm_pciids.h                  |  7 +++++
 include/uapi/drm/radeon_drm.h             |  1 +
 44 files changed, 328 insertions(+), 167 deletions(-)
--29444707-1706360869-1408862330=:1562--
