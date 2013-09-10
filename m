Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab3IJGHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:07:44 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42106 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab3IJGHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:07:43 -0400
Date: Tue, 10 Sep 2013 07:07:36 +0100 (IST)
From: Dave Airlie <airlied@skynet.ie>
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm intel fixes and one nouveau regression
Message-ID: <alpine.DEB.2.00.1309100704520.11862@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1826349070-1378793256=:11862"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1826349070-1378793256=:11862
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Daniel had some fixes queued up, that were delayed, the stolen memory ones 
and vga arbiter ones are quite useful, along with his usual bunch of 
stuff, nothing for HSW outputs yet,

the one nouveau fix is for a regression I caused with the poweroff stuff.

Dave.

The following changes since commit 86a7e1224a68511d3a1ae0b7e11581b9d37723ae:

  Merge branch 'exynos-drm-next' of git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos into drm-next (2013-09-05 17:48:04 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 01172772c7c973debf5b4881fcb9463891ea97ec:

  drm/nouveau: fix oops on runtime suspend/resume (2013-09-10 12:38:53 +1000)

----------------------------------------------------------------
Alex Williamson (3):
      vgaarb: Don't disable resources that are not owned
      vgaarb: Fix VGA decodes changes
      i915: Update VGA arbiter support for newer devices

Chris Wilson (9):
      drm/i915: Adjust available RPS information through sysfs for vlv
      drm/i915: Apply the force-detect VGA w/a to Valleyview
      drm/i915: Report requested frequency alongside current frequency in debugfs
      drm/i915: Embed the ring->private within the struct intel_ring_buffer
      drm/i915: Use RCS flips on Ivybridge+
      drm/i915: Pin pages whilst mapping the dma-buf
      drm/i915: Hold an object reference whilst we shrink it
      drm/i915: Skip stolen region initialisation if none is reserved
      drm/i915: Confine page flips to BCS on Valleyview

Damien Lespiau (1):
      drm/i915: Don't call sg_free_table() if sg_alloc_table() fails

Daniel Vetter (6):
      drm/i915: tune down hangcheck noise
      drm/i915: fix up the relocate_entry refactoring
      drm/i915: fix hpd work vs. flush_work in the pageflip code deadlock
      drm/i915: handle sdvo input pixel multiplier correctly again
      drm/i915: fix i9xx_crtc_clock_get for multiplied pixels
      drm/i915: fix gpu hang vs. flip stall deadlocks

Dave Airlie (2):
      Merge tag 'drm-intel-fixes-2013-09-06' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      drm/nouveau: fix oops on runtime suspend/resume

Imre Deak (1):
      drm/i915: fix lvds/dp panel fitter setting

Jani Nikula (1):
      drm/i915: try not to lose backlight CBLV precision

Jesse Barnes (2):
      drm/i915: split PCI IDs out into i915_drm.h v4
      x86: add early quirk for reserving Intel graphics stolen memory v5

Joe Perches (1):
      i915_gem: Convert kmem_cache_alloc(...GFP_ZERO) to kmem_cache_zalloc

Mika Kuoppala (2):
      drm/i915: Don't mask EI UP interrupt on IVB|SNB
      drm/i915: sanitize forcewake registers on reset

Paulo Zanoni (1):
      drm/i915: enable trickle feed on Haswell

Ville Syrjälä (2):
      drm/i915: Fix pipe config warnings when dealing with LVDS fixed mode
      drm/i915: Delay disabling of VGA memory until vgacon->fbcon handoff is done

 arch/x86/kernel/early-quirks.c             | 154 +++++++++++++++++++++
 drivers/gpu/drm/i915/i915_debugfs.c        |  11 +-
 drivers/gpu/drm/i915/i915_dma.c            |  15 +-
 drivers/gpu/drm/i915/i915_drv.c            | 164 +++++-----------------
 drivers/gpu/drm/i915/i915_drv.h            |   7 +
 drivers/gpu/drm/i915/i915_gem.c            |  48 +++++--
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |  41 +++---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   3 +
 drivers/gpu/drm/i915/i915_gem_stolen.c     |   3 +
 drivers/gpu/drm/i915/i915_gpu_error.c      |   2 +-
 drivers/gpu/drm/i915/i915_irq.c            |  23 +++-
 drivers/gpu/drm/i915/i915_reg.h            |  34 +++--
 drivers/gpu/drm/i915/i915_sysfs.c          |  36 ++++-
 drivers/gpu/drm/i915/intel_crt.c           |   2 +-
 drivers/gpu/drm/i915/intel_display.c       |  83 ++++++++++--
 drivers/gpu/drm/i915/intel_drv.h           |   3 +-
 drivers/gpu/drm/i915/intel_lvds.c          |   8 +-
 drivers/gpu/drm/i915/intel_opregion.c      |   2 +-
 drivers/gpu/drm/i915/intel_panel.c         |  14 +-
 drivers/gpu/drm/i915/intel_pm.c            |  14 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c    |  99 ++++----------
 drivers/gpu/drm/i915/intel_ringbuffer.h    |   6 +-
 drivers/gpu/drm/i915/intel_sdvo.c          |  17 +--
 drivers/gpu/drm/i915/intel_sprite.c        |   7 +-
 drivers/gpu/drm/i915/intel_uncore.c        |   9 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c      |   9 +-
 drivers/gpu/vga/vgaarb.c                   |  51 +++----
 include/drm/i915_drm.h                     |  34 +++++
 include/drm/i915_pciids.h                  | 211 +++++++++++++++++++++++++++++
 include/linux/vgaarb.h                     |   7 +
 30 files changed, 780 insertions(+), 337 deletions(-)
 create mode 100644 include/drm/i915_pciids.h
--29444707-1826349070-1378793256=:11862--
