Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaDSHTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 03:19:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33628 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbaDSHTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 03:19:43 -0400
Date: Sat, 19 Apr 2014 08:19:40 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1093132627-1397891980=:7507"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1093132627-1397891980=:7507
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Unfortunately this contains no easter eggs, its a bit larger than I'd 
like, but I included a patch that just moves code from one file to another 
and I'd like to avoid merge conflicts with that later, so it makes it seem 
worse than it is,

Otherwise,
radeon fixes to use new microcode to stabilise some cards, use some common 
displayport code, some runtime pm fixes, pll regression fixes,
i915 fix for some context oopses, a warn in a used path, backlight fixes,
nouveau: regression fix,
omap: a bunch of fixes,

Dave.0

The following changes since commit 55101e2d6ce1c780f6ee8fee5f37306971aac6cd:

  Merge git://git.kernel.org/pub/scm/virt/kvm/kvm (2014-04-14 16:21:28 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to a42892ed10585c5511e8a3e53f0350b4e2242050:

  Merge branch 'drm-next-3.15-wip' of git://people.freedesktop.org/~deathsimple/linux into drm-next (2014-04-19 11:16:02 +1000)

----------------------------------------------------------------

Alex Deucher (13):
      drm/radeon/dp: handle zero sized i2c over aux transactions (v2)
      drm/dp/i2c: send bare addresses to properly reset i2c connections (v4)
      drm/dp/i2c: Update comments about common i2c over dp assumptions (v3)
      drm/radeon/dp: switch to the common i2c over aux code
      drm/radeon: fix audio pin counts for DCE6+ (v2)
      drm/radeon: disable mclk dpm on R7 260X
      drm/radeon: fix runpm handling on APUs (v4)
      drm/radeon: update CI DPM powertune settings
      drm/radeon: add support for newer mc ucode on SI (v2)
      drm/radeon: add support for newer mc ucode on CI (v2)
      drm/radeon: re-enable mclk dpm on R7 260X asics
      drm/radeon/si: make sure mc ucode is loaded before checking the size
      drm/radeon/ci: make sure mc ucode is loaded before checking the size

Archit Taneja (4):
      drm/omap: gem sync: wait on correct events
      drm/omap: Fix crash when using LCD3 overlay manager
      drm/omap: Use old_fb to synchronize between successive page flips
      drm/omap: protect omap_crtc's event with event_lock spinlock

Chris Wilson (1):
      drm/i915: Always use kref tracking for all contexts.

Christian König (2):
      drm/radeon: apply more strict limits for PLL params v2
      drm/radeon: improve PLL params if we don't match exactly v2

Christoph Jaeger (1):
      drm/radeon: fix VCE fence command

Daniel Vetter (4):
      drm/mm: Don't WARN if drm_mm_reserve_node
      drm/i915: Disable self-refresh for untiled fbs on i915gm
      drm/plane-helper: Don't fake-implement primary plane disabling
      drm: Split out drm_probe_helper.c from drm_crtc_helper.c

Dave Airlie (6):
      Merge tag 'drm-intel-fixes-2014-04-11' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'drm/tegra/for-3.15-rc2' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-next
      Merge tag 'omapdrm-fixes-3.15' of git://git.kernel.org/.../tomba/linux into drm-next
      drm/ast: fix value check in cbr_scan2
      Merge branch 'drm-next-3.15-wip' of git://people.freedesktop.org/~deathsimple/linux into drm-next

Gerd Hoffmann (3):
      drm: cirrus: add power management support
      drm: bochs: add power management support
      drm: bochs: drop unused struct fields

Grazvydas Ignotas (1):
      drm/omap: fix plane rotation

Jani Nikula (3):
      drm/i915: support address only i2c-over-aux transactions
      drm/i915: check VBT for supported backlight type
      drm/i915: do not setup backlight if not available according to VBT

Lauri Kasanen (1):
      drm/radeon: Improve vramlimit module param documentation

Quentin Casasnovas (1):
      drm/radeon: memory leak on bo reservation failure. v2

Sergei Antonov (1):
      drm/nouveau/bios: fix a bit shift error introduced by 457e77b

Stephen Warren (1):
      gpu: host1x: handle the correct # of syncpt regs

Subhajit Paul (1):
      drm/omap: Fix memory leak in omap_gem_op_async

Thierry Reding (2):
      drm/tegra: dp: Support address-only I2C-over-AUX transactions
      drm/tegra: Remove gratuitous pad field

Tomi Valkeinen (11):
      drm/omap: fix output enable/disable sequence
      drm/omap: fix uninit order in pdev_remove()
      drm/omap: fix DMM driver (un)registration
      drm/omap: fix race issue when unloading omapdrm
      drm/omap: fix missing disable for unused encoder
      drm/omap: fix enabling/disabling of video pipeline
      drm/omap: fix missing unref to fb's buf object
      drm/omap: print warning when rotating non-TILER fb
      drm/omap: remove extra plane->destroy from crtc destroy
      drm/omap: remove warn from debugfs
      drm/omap: fix the handling of fb ref counts

 Documentation/DocBook/drm.tmpl                  |   5 +
 drivers/gpu/drm/Makefile                        |   2 +-
 drivers/gpu/drm/ast/ast_post.c                  |   2 +-
 drivers/gpu/drm/bochs/bochs.h                   |   3 +-
 drivers/gpu/drm/bochs/bochs_drv.c               |  44 +++
 drivers/gpu/drm/bochs/bochs_fbdev.c             |   1 -
 drivers/gpu/drm/cirrus/cirrus_drv.c             |  42 +++
 drivers/gpu/drm/cirrus/cirrus_mode.c            |   3 +
 drivers/gpu/drm/drm_crtc_helper.c               | 370 --------------------
 drivers/gpu/drm/drm_dp_helper.c                 |  55 +--
 drivers/gpu/drm/drm_mm.c                        |   2 -
 drivers/gpu/drm/drm_plane_helper.c              |  33 +-
 drivers/gpu/drm/drm_probe_helper.c              | 426 ++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_drv.h                 |   9 +-
 drivers/gpu/drm/i915/i915_gem.c                 |   2 +-
 drivers/gpu/drm/i915/i915_gem_context.c         | 218 +++++-------
 drivers/gpu/drm/i915/i915_gem_execbuffer.c      |   2 +-
 drivers/gpu/drm/i915/intel_bios.c               |  10 +
 drivers/gpu/drm/i915/intel_bios.h               |   3 +
 drivers/gpu/drm/i915/intel_dp.c                 |   7 +-
 drivers/gpu/drm/i915/intel_panel.c              |   5 +
 drivers/gpu/drm/i915/intel_pm.c                 |  10 +
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c |   2 +-
 drivers/gpu/drm/omapdrm/omap_crtc.c             | 100 ++++--
 drivers/gpu/drm/omapdrm/omap_drv.c              |  32 +-
 drivers/gpu/drm/omapdrm/omap_drv.h              |   1 +
 drivers/gpu/drm/omapdrm/omap_fb.c               |  14 +
 drivers/gpu/drm/omapdrm/omap_fbdev.c            |   3 +
 drivers/gpu/drm/omapdrm/omap_gem.c              |   9 +-
 drivers/gpu/drm/omapdrm/omap_plane.c            |  16 +-
 drivers/gpu/drm/radeon/atombios_dp.c            | 140 ++------
 drivers/gpu/drm/radeon/ci_dpm.c                 |  33 +-
 drivers/gpu/drm/radeon/cik.c                    |  28 +-
 drivers/gpu/drm/radeon/dce6_afmt.c              |  14 +-
 drivers/gpu/drm/radeon/radeon.h                 |   6 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c    |   2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c      |  44 +--
 drivers/gpu/drm/radeon/radeon_device.c          |  19 +-
 drivers/gpu/drm/radeon/radeon_display.c         |  27 +-
 drivers/gpu/drm/radeon/radeon_drv.c             |  26 +-
 drivers/gpu/drm/radeon/radeon_family.h          |   1 +
 drivers/gpu/drm/radeon/radeon_i2c.c             |  60 +---
 drivers/gpu/drm/radeon/radeon_kms.c             |  23 +-
 drivers/gpu/drm/radeon/radeon_mode.h            |  12 +-
 drivers/gpu/drm/radeon/radeon_ucode.h           |   7 +-
 drivers/gpu/drm/radeon/radeon_vce.c             |   2 +-
 drivers/gpu/drm/radeon/si.c                     |  37 +-
 drivers/gpu/drm/tegra/dpaux.c                   |  44 ++-
 drivers/gpu/drm/tegra/dpaux.h                   |   1 +
 drivers/gpu/host1x/hw/intr_hw.c                 |   4 +-
 include/drm/drm_crtc_helper.h                   |   6 +-
 include/drm/drm_dp_helper.h                     |   4 +
 include/uapi/drm/tegra_drm.h                    |   1 -
 53 files changed, 1058 insertions(+), 914 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_probe_helper.c
--29444707-1093132627-1397891980=:7507--
