Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3FFF0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 01:26:44 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44648 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab3FFF0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 01:26:43 -0400
Date: Thu, 6 Jun 2013 06:26:53 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes (try again)
Message-ID: <alpine.DEB.2.00.1306060625560.27833@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-880840395-1370496413=:27833"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-880840395-1370496413=:27833
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi,

this time after I appended the right file.

regression fixers for the big 3:
nouveau: hdmi audio, dac load detect, s/r regressions fixed
radeon: long standing system hang fixed, hdmi audio and rs780 fast fb
fixes
intel: one old regression, a WARN removal, and a stop X dying fix

otherwise one mgag200 fix, a couple of arm build fixes, and a core use
after free fix.

Dave.

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 0e32fde96bb9c1fa8fa477e52c1d6ae2f4995cea:

  Merge branch 'drm-nouveau-fixes-3.10' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes (2013-06-05 14:35:08 +1000)

----------------------------------------------------------------

Adis Hamziæ (1):
      radeon: Fix system hang issue when using KMS with older cards

Alex Deucher (1):
      drm/radeon: don't allow audio on DCE6

Alexander Stein (1):
      drm/nv84/disp: Fix HDMI audio regression

Arnd Bergmann (2):
      drm/tilcd: select BACKLIGHT_LCD_SUPPORT
      drm/nouveau: use mdelay instead of large udelay constants

Ben Mesman (1):
      drm/i915: no lvds quirk for hp t5740

Ben Skeggs (3):
      drm/nv50-nv84/fifo: fix resume regression introduced by playlist race fix
      drm/nv50/disp: force dac power state during load detect
      drm/nv50/kms: use dac loadval from vbios, where it's available

Christopher Harvey (1):
      drm/mgag200: Add missing write to index before accessing data register

Daniel Vetter (2):
      drm/i915: Fix spurious -EIO/SIGBUS on wedged gpus
      drm/i915: Quirk the pipe A quirk in the modeset state checker

Dave Airlie (3):
      Merge branch 'drm-fixes-3.10' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'drm-intel-fixes-2013-06-04' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'drm-nouveau-fixes-3.10' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

Egbert Eich (1):
      drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC.

Huacai Chen (1):
      drm: fix a use-after-free when GPU acceleration disabled

Samuel Li (1):
      drm/radeon: Use direct mapping for fast fb access on RS780/RS880 (v2)

 drivers/gpu/drm/drm_irq.c                          |  6 ++-
 drivers/gpu/drm/i915/i915_gem.c                    |  7 +--
 drivers/gpu/drm/i915/intel_display.c               |  5 ++
 drivers/gpu/drm/i915/intel_lvds.c                  |  4 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |  2 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |  9 ++--
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |  7 ++-
 .../gpu/drm/nouveau/core/engine/disp/hdminv84.c    |  4 ++
 drivers/gpu/drm/nouveau/core/engine/fifo/nv50.c    | 14 ++++--
 drivers/gpu/drm/nouveau/core/include/core/class.h  |  2 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |  4 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         | 11 +++--
 drivers/gpu/drm/radeon/evergreen.c                 | 10 ++--
 drivers/gpu/drm/radeon/ni.c                        | 10 ++--
 drivers/gpu/drm/radeon/r100.c                      |  9 ++--
 drivers/gpu/drm/radeon/r300.c                      |  9 ++--
 drivers/gpu/drm/radeon/r420.c                      | 10 ++--
 drivers/gpu/drm/radeon/r520.c                      |  9 ++--
 drivers/gpu/drm/radeon/r600.c                      | 53 ++++++++++++++++++++--
 drivers/gpu/drm/radeon/r600d.h                     |  8 ++++
 drivers/gpu/drm/radeon/radeon_asic.c               |  4 ++
 drivers/gpu/drm/radeon/radeon_asic.h               |  2 +
 drivers/gpu/drm/radeon/rs400.c                     |  9 ++--
 drivers/gpu/drm/radeon/rs600.c                     |  9 ++--
 drivers/gpu/drm/radeon/rs690.c                     |  9 ++--
 drivers/gpu/drm/radeon/rv515.c                     |  9 ++--
 drivers/gpu/drm/radeon/rv770.c                     | 10 ++--
 drivers/gpu/drm/radeon/si.c                        | 10 ++--
 drivers/gpu/drm/tilcdc/Kconfig                     |  1 +
 29 files changed, 188 insertions(+), 68 deletions(-)
--29444707-880840395-1370496413=:27833--
