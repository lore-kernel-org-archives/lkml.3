Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaGKBeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 21:34:08 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37622 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaGKBeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 21:34:06 -0400
Date: Fri, 11 Jul 2014 02:34:02 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm driver fixes
Message-ID: <alpine.DEB.2.00.1407110229460.21365@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-23196957-1405042442=:21365"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-23196957-1405042442=:21365
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Nothing too scary, we have one outstanding i915 regression but Daniel has 
promised the fix as soon as he's finished testing it a bit.

Fixes for the main x86 drivers:
radeon: dpm fixes, displayport regression fix
i915: quirks for backlight regression, edp reboot fix, valleyview black 
screen fixes
nouveau: display port regression fixes, fix for memory reclocking.

Dave.

The following changes since commit 4f440cd534359f689cb577c68f8491d1eddf0b76:

  Merge tag 'pci-v3.16-fixes-1' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci (2014-07-09 16:18:18 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to bf38b025d3f58f4c1273714ff1be5bfbf99574a4:

  Merge branch 'drm-fixes-3.16' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2014-07-11 11:24:13 +1000)

----------------------------------------------------------------

Alex Deucher (3):
      drm/radeon/dp: return -EIO for flags not zero case
      drm/radeon: fix typo in golden register setup on evergreen
      drm/radeon: fix typo in ci_stop_dpm()

Alexandre Demers (1):
      drm/radeon/dpm: Reenabling SS on Cayman

Ben Skeggs (6):
      drm/gk104/ram: bash mpll bit 31 on
      drm/nv50-/kms: pass a non-zero value for head to sor dpms methods
      drm/nouveau/kms: restore fbcon after display has been resumed
      drm/nouveau/dp: fix required link bandwidth calculations
      drm/nouveau/dp: workaround broken display
      drm/nouveau/ram: fix test for gpio presence

Christian König (1):
      drm/radeon: only print meaningful VM faults

Clint Taylor (1):
      drm/i915/vlv: T12 eDP panel timing enforcement during reboot

Daniel Vetter (1):
      drm/i915: Only unbind vgacon, not other console drivers

Dave Airlie (3):
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge tag 'drm-intel-fixes-2014-07-09' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.16' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Scot Doyle (3):
      drm/i915: quirk asserts controllable backlight presence, overriding VBT
      drm/i915: Acer C720 and C720P have controllable backlights
      drm/i915: Toshiba CB35 has a controllable backlight

Shobhit Kumar (2):
      drm/i915/vlv: DPI FIFO empty check is not needed
      drm/i915/vlv: Update the DSI ULPS entry/exit sequence

Stéphane Marchesin (1):
      drm/nouveau/fb: Prevent inlining of ramfuc_reg

Ville Syrjälä (1):
      drm/i915: Don't clobber the GTT when it's within stolen memory

 drivers/gpu/drm/i915/i915_dma.c                    |  5 ++-
 drivers/gpu/drm/i915/i915_drv.h                    |  1 +
 drivers/gpu/drm/i915/i915_gem_stolen.c             | 44 ++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_reg.h                    |  3 ++
 drivers/gpu/drm/i915/intel_display.c               | 14 +++++++
 drivers/gpu/drm/i915/intel_dp.c                    | 42 +++++++++++++++++++++
 drivers/gpu/drm/i915/intel_drv.h                   |  2 +
 drivers/gpu/drm/i915/intel_dsi.c                   | 29 +++++++-------
 drivers/gpu/drm/i915/intel_dsi_cmd.c               |  6 ---
 drivers/gpu/drm/i915/intel_panel.c                 |  8 +++-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |  6 +--
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c    |  6 +--
 drivers/gpu/drm/nouveau/core/engine/disp/outpdp.c  |  8 ++--
 drivers/gpu/drm/nouveau/core/engine/disp/sornv50.c |  1 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramfuc.h    |  4 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnve0.c   |  1 +
 drivers/gpu/drm/nouveau/nouveau_drm.c              | 17 +++++----
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            | 13 ++-----
 drivers/gpu/drm/nouveau/nouveau_fbcon.h            |  1 -
 drivers/gpu/drm/nouveau/nv50_display.c             |  3 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |  2 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |  2 +-
 drivers/gpu/drm/radeon/cik.c                       |  6 ++-
 drivers/gpu/drm/radeon/evergreen.c                 | 14 ++++---
 drivers/gpu/drm/radeon/rv770_dpm.c                 |  6 ---
 drivers/gpu/drm/radeon/si.c                        |  6 ++-
 26 files changed, 177 insertions(+), 73 deletions(-)
--29444707-23196957-1405042442=:21365--
