Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934935AbaGXXxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:53:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33570 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934753AbaGXXxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:53:51 -0400
Date: Fri, 25 Jul 2014 00:53:48 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes (make Linus grumpy)
Message-ID: <alpine.DEB.2.00.1407250045580.2015@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-440006584-1406246028=:2015"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-440006584-1406246028=:2015
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

This is radeon and intel fixes, and is a small bit larger than I'm 
guessing you'd like it to be,

i915: fixes 32-bit highmem i915 blank screen, semaphore hang and runtime 
pm fix
radeon: gpuvm stability fix for hangs since 3.15, and hang/reboot 
regression on TN/RL devices,

The only slightly controversial one is the change to use GB forthe 
vm_size, which I'm letting through as its a new interface we defined in
this merge window, and I'd prefer to have the released kernel have the 
final interface rather than changing it later.

but push back if you really don't like anything!

Dave.

The following changes since commit 67dd8f35c2d8ed80f26c9654b474cffc11c6674d:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2014-07-21 11:44:34 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 1b2c4869d8247f9e202fa8a73777c34adc62d409:

  drm/radeon: fix cut and paste issue for hawaii. (2014-07-25 09:17:35 +1000)

----------------------------------------------------------------
Alex Deucher (1):
      drm/radeon/TN: only enable bapm on MSI systems

Chris Wilson (2):
      drm/i915: Reorder the semaphore deadlock check, again
      drm/i915: Simplify i915_gem_release_all_mmaps()

Christian König (5):
      drm/radeon: let's use GB for vm_size (v2)
      drm/radeon: fix handling of radeon_vm_bo_rmv v3
      drm/radeon: fix VM IB handling
      drm/radeon: fix error handling in radeon_vm_bo_set_addr
      drm/radeon: fix irq ring buffer overflow handling

Dave Airlie (3):
      Merge branch 'drm-fixes-3.16' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'drm-intel-fixes-2014-07-24' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.16' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Hugh Dickins (1):
      drm/i915: fix freeze with blank screen booting highmem

Jerome Glisse (1):
      drm/radeon: fix cut and paste issue for hawaii.

 drivers/gpu/drm/i915/i915_gem.c              | 25 +++-----
 drivers/gpu/drm/i915/i915_gem_render_state.c |  4 +-
 drivers/gpu/drm/i915/i915_irq.c              | 11 ++--
 drivers/gpu/drm/radeon/cik.c                 |  2 +
 drivers/gpu/drm/radeon/evergreen.c           |  1 +
 drivers/gpu/drm/radeon/r600.c                |  1 +
 drivers/gpu/drm/radeon/radeon.h              | 15 +++--
 drivers/gpu/drm/radeon/radeon_cs.c           | 20 ++++++-
 drivers/gpu/drm/radeon/radeon_device.c       | 22 +++----
 drivers/gpu/drm/radeon/radeon_drv.c          |  4 +-
 drivers/gpu/drm/radeon/radeon_kms.c          | 26 ++++-----
 drivers/gpu/drm/radeon/radeon_vm.c           | 87 ++++++++++++++++++++--------
 drivers/gpu/drm/radeon/si.c                  |  1 +
 drivers/gpu/drm/radeon/trinity_dpm.c         | 15 ++---
 14 files changed, 146 insertions(+), 88 deletions(-)
--29444707-440006584-1406246028=:2015--
