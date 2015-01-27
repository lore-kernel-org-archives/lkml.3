Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbbA0CG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 21:06:26 -0500
Received: from gir.skynet.ie ([193.1.99.77]:46720 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbbA0CGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 21:06:25 -0500
Date: Tue, 27 Jan 2015 02:06:20 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1501270205210.966@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1806753020-1422324380=:966"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1806753020-1422324380=:966
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

This feels larger than I'd like but its for three reasons.

a) amdkfd finalising the API more, this is a new feature introduced last 
merge window, and I'd prefer to make the tweaks
to the API before it first gets into a stable release.

b) radeon regression required splitting an internal API to fix properly,
so it just changed a few more lines

c) vmwgfx fix changes a lock from a mutex->spin lock, this is fallout
from the new sleep checking.

Otherwise there is just some tda998x fixes.

Dave.

The following changes since commit 26bc420b59a38e4e6685a73345a0def461136dce:

  Linux 3.19-rc6 (2015-01-25 20:04:41 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 5159571ceb44eba9bf9f9a34ec625386d421de9c:

  Merge branch 'drm-fixes-3.19' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2015-01-27 09:56:13 +1000)

----------------------------------------------------------------

Andrew Jackson (1):
      drm/i2c: tda998x: set the CEC I2C address based on the slave I2C address

Ben Goz (1):
      drm/amdkfd: PQM handle queue creation fault

Dave Airlie (5):
      Merge branch 'vmwgfx-fixes-3.19' of git://people.freedesktop.org/~thomash/linux into drm-fixes
      Merge branch 'drm-tda998x-fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into drm-fixes
      Merge tag 'v3.19-rc6' into drm-fixes
      Merge tag 'drm-amdkfd-fixes-2015-01-26' of git://people.freedesktop.org/~gabbayo/linux into drm-fixes
      Merge branch 'drm-fixes-3.19' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Jean-Francois Moine (2):
      drm: tda998x: Protect the page register
      drm: tda998x: Fix EDID read timeout on HDMI connect

Michel Dänzer (3):
      drm/radeon: Split off gart_get_page_entry ASIC hook from set_page_entry
      drm/radeon: Restore GART table contents after pinning it in VRAM v3
      drm/radeon: Remove rdev->gart.pages_addr array

Oded Gabbay (4):
      drm/amdkfd: Allow user to limit only queues per device
      drm/radeon: Don't increment pipe_id in kgd_init_pipeline
      drm/amdkfd: Fix bug in pipelines initialization
      drm/amdkfd: Fix bug in call to init_pipelines()

Thomas Hellstrom (1):
      drm/vmwgfx: Replace the hw mutex with a hw spinlock

 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  6 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  | 78 +++++++++++++++++++++-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |  1 +
 drivers/gpu/drm/amd/amdkfd/kfd_module.c            | 27 +++-----
 drivers/gpu/drm/amd/amdkfd/kfd_pasid.c             |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              | 17 +++--
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 12 ++--
 drivers/gpu/drm/i2c/tda998x_drv.c                  | 52 ++++++++++++---
 drivers/gpu/drm/radeon/cik_sdma.c                  |  1 -
 drivers/gpu/drm/radeon/ni_dma.c                    |  1 -
 drivers/gpu/drm/radeon/r100.c                      | 10 ++-
 drivers/gpu/drm/radeon/r300.c                      | 16 +++--
 drivers/gpu/drm/radeon/radeon.h                    |  9 ++-
 drivers/gpu/drm/radeon/radeon_asic.c               | 24 +++++++
 drivers/gpu/drm/radeon/radeon_asic.h               | 12 ++--
 drivers/gpu/drm/radeon/radeon_device.c             |  2 +
 drivers/gpu/drm/radeon/radeon_gart.c               | 54 +++++++++------
 drivers/gpu/drm/radeon/radeon_kfd.c                |  2 +-
 drivers/gpu/drm/radeon/radeon_vm.c                 |  6 +-
 drivers/gpu/drm/radeon/rs400.c                     | 14 ++--
 drivers/gpu/drm/radeon/rs600.c                     | 14 ++--
 drivers/gpu/drm/radeon/si_dma.c                    |  1 -
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                | 28 ++------
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                | 25 +++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              | 18 +----
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c               | 36 +++++-----
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c              |  8 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c                | 25 +++----
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  2 -
 29 files changed, 315 insertions(+), 188 deletions(-)
--29444707-1806753020-1422324380=:966--
