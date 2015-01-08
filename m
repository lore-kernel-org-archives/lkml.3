Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbbAHW5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:57:46 -0500
Received: from gir.skynet.ie ([193.1.99.77]:51898 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbbAHW5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:57:45 -0500
Date: Thu, 8 Jan 2015 22:57:42 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1501082253180.30157@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1064008075-1420757862=:30157"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1064008075-1420757862=:30157
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

I'm briefly working between holidays and LCA, so this is close to a couple 
of weeks of fixes,

two sets of amdkfd fixes, this is a new feature this kernel, and this pull 
fixes a few issues since it got merged, ordering when built-in to kernel 
and also the iommu vs gpu ordering patch, it also reworks the ioctl before 
the initial release.

otherwise:
radeon: some misc fixes all over, hdmi, 4k, dpm
nouveau: mcp77 init fixes, oops fix, bug on fix, msi fix
i915: power fixes, revert VGACNTR patch

probably be quiteer next week since I'll be at LCA anyways.

Dave.

The following changes since commit d753856c9f9ae33a980192aa7b81d8b97d79dec2:

  Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2015-01-02 13:24:41 -0800)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 79305ec6e60d320832505e95c1a028d309fcd2b6:

  Merge tag 'amdkfd-fixes-2015-01-06' of git://people.freedesktop.org/~gabbayo/linux into drm-fixes (2015-01-08 10:36:37 +1000)

----------------------------------------------------------------

Alex Deucher (4):
      drm/radeon: KV has three PPLLs (v2)
      drm/radeon: fix sad_count check for dce3
      drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw
      drm/radeon: adjust default bapm settings for KV

Alexandre Courbot (1):
      drm/nouveau: fix missing return statement in nouveau_ttm_tt_unpopulate

Alexey Khoroshilov (1):
      drm/radeon: do not leave queue acquired if timeout happens in kgd_hqd_destroy()

Ben Goz (5):
      amdkfd: Fixing topology bug in building sysfs nodes
      drm/amd: Fixing typos in kfd<->kgd interface
      drm/amdkfd: Load mqd to hqd in non-HWS mode
      drm/radeon: Assign VMID to PASID for IH in non-HWS mode
      drm/amdkfd: unmap VMID<-->PASID when relesing VMID (non-HWS)

Ben Skeggs (4):
      drm/nouveau/bios: fix oops on pre-nv50 chipsets
      drm/nouveau: wake up the card if necessary during gem callbacks
      drm/nouveau/fb/ram/mcp77: subclass nouveau_ram
      drm/nouveau/fb/ram/mcp77: use carveout reg to determine size

Bruno Prémont (1):
      drm/nouveau/nouveau: Do not BUG_ON(!spin_is_locked()) on UP

Dan Carpenter (1):
      drm/radeon: integer underflow in radeon_cp_dispatch_texture()

Dave Airlie (5):
      Merge tag 'drm-intel-next-fixes-2014-12-30' of git://anongit.freedesktop.org/drm-intel into linus
      Merge tag 'amdkfd-fixes-2014-12-30' of git://people.freedesktop.org/~gabbayo/linux into linus
      Merge branch 'linux-3.19' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge branch 'drm-fixes-3.19' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'amdkfd-fixes-2015-01-06' of git://people.freedesktop.org/~gabbayo/linux into drm-fixes

Ilia Mirkin (1):
      drm/nv4c/mc: disable msi

Imre Deak (1):
      drm/i915: add missing rpm ref to i915_gem_pwrite_ioctl

Oded Gabbay (8):
      amdkfd: Fix accounting of device queues
      amdkfd: Remove duplicate include
      drivers: Move iommu/ before gpu/ in Makefile
      drm: Put amdkfd before radeon in drm Makefile
      drm/radeon: Init amdkfd only if it was compiled
      drm/amdkfd: Do copy_to/from_user in general kfd_ioctl()
      drm/amdkfd: reformat IOCTL definitions to drm-style
      drm/amdkfd: rewrite kfd_ioctl() according to drm_ioctl()

Pierre Moreau (1):
      drm/nouveau/fb/ram/mcp77: enable NISO poller

Sasha Levin (1):
      amdkfd: actually allocate longs for the pasid bitmask

Sven Köhler (1):
      drm/nouveau/device: Add support for GK208B, resolves bug 86935

Ville Syrjälä (3):
      drm/i915: Kill check_power_well() calls
      drm/i915: Don't call intel_prepare_page_flip() multiple times on gen2-4
      Revert "drm/i915: Preserve VGACNTR bits from the BIOS"

 drivers/Makefile                                   |   6 +-
 drivers/gpu/drm/Makefile                           |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           | 316 +++++++++++----------
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  28 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c       |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_pasid.c             |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  18 ++
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |   2 +-
 drivers/gpu/drm/amd/include/kgd_kfd_interface.h    |   2 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   2 -
 drivers/gpu/drm/i915/i915_gem.c                    |   8 +-
 drivers/gpu/drm/i915/i915_irq.c                    |   6 +-
 drivers/gpu/drm/i915/intel_display.c               |   8 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c            |  27 --
 drivers/gpu/drm/nouveau/core/core/event.c          |   4 +-
 drivers/gpu/drm/nouveau/core/core/notify.c         |   2 +-
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |  33 +++
 .../gpu/drm/nouveau/core/subdev/bios/shadowramin.c |   6 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvaa.c   |  65 ++++-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c      |   8 -
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   4 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |  35 ++-
 drivers/gpu/drm/radeon/atombios_crtc.c             |   8 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |   4 +
 drivers/gpu/drm/radeon/cikd.h                      |   2 +
 drivers/gpu/drm/radeon/dce3_1_afmt.c               |   2 +-
 drivers/gpu/drm/radeon/kv_dpm.c                    |  10 +-
 drivers/gpu/drm/radeon/radeon_kfd.c                |  23 +-
 drivers/gpu/drm/radeon/radeon_state.c              |   2 +-
 include/uapi/linux/kfd_ioctl.h                     |  37 ++-
 30 files changed, 413 insertions(+), 261 deletions(-)
--29444707-1064008075-1420757862=:30157--
