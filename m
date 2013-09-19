Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3ISCHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 22:07:23 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:55267 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3ISCHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 22:07:21 -0400
MIME-Version: 1.0
Date: Thu, 19 Sep 2013 12:07:20 +1000
Message-ID: <CAPM=9twv-bb3MtnWNTT5+i5HfHQS+cbJG16xsaoL-XV_Qpf9Cw@mail.gmail.com>
Subject: [git pull] drm radeon/nouveau/core fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

mostly radeon fixes, with some nouveau bios parser, ttm fix and a fix
for AST driver.

Dave.

The following changes since commit 01172772c7c973debf5b4881fcb9463891ea97ec:

  drm/nouveau: fix oops on runtime suspend/resume (2013-09-10 12:38:53 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 928c2f0c006bf7f381f58af2b2786d2a858ae311:

  drm/fb-helper: don't sleep for screen unblank when an oops is in
progress (2013-09-19 11:54:34 +1000)

----------------------------------------------------------------
Alex Deucher (24):
      drm/radeon/cik: properly handle internal cp ints
      drm/radeon/si: properly handle internal cp ints
      drm/radeon/dce6/audio: make sure pin is valid before accessing it
      drm/radeon: add a connector property for audio
      drm/radeon: dpm updates for KV
      drm/radeon: protect concurrent smc register access with a spinlock
      drm/radeon: add spinlocks for indirect register accesss
      drm/radeon/cik: update gpu_init for an additional berlin gpu
      drm/radeon: add some additional berlin pci ids
      drm/radeon: fix typo in PG flags
      drm/radeon/r6xx: add a stubbed out set_uvd_clocks callback
      drm/radeon/dpm: fix fallback for empty UVD clocks
      drm/radeon/atom: workaround vbios bug in transmitter table on rs880 (v2)
      drm/radeon/dpm: handle bapm on trinity
      drm/radeon/dpm: handle bapm on kb/kv
      drm/radeon/dpm: add infrastructure to properly handle bapm
      drm/radeon/dpm: add bapm callback for trinity
      drm/radeon/dpm: add bapm callback for kb/kv
      drm/radeon/dpm/rs780: use drm_mode_vrefresh()
      drm/radeon/dpm/rs780: add some sanity checking to sclk scaling
      drm/radeon/dpm/rs780: don't enable sclk scaling if not required
      drm/radeon/dpm/rs780: fix force_performance state for same sclks
      drm/radeon/dpm: rework auto performance level enable
      drm/radeon: fix panel scaling with eDP and LVDS bridges

Anthoine Bourgeois (1):
      drm/radeon/dpm: implement force performance levels for rs780 (v2)

Ben Skeggs (5):
      drm/nouveau/bios/init: stub opcode 0xaa
      drm/nouveau/kms: enable for non-vga pci classes
      drm/nouveau/bios/init: fix thinko in INIT_CONFIGURE_MEM
      drm/nouveau/ttm: prevent double-free in
nouveau_sgdma_create_ttm() failure path
      drm/ttm: fix the tt_populated check in ttm_tt_destroy()

Christian König (3):
      drm/radeon: remove stale radeon_fence_retire tracepoint
      drm/radeon: add command submission tracepoint
      drm/radeon: avoid UVD corruptions on AGP cards

Damien Lespiau (1):
      drm/radeon: Fix hmdi typo

Dan Carpenter (2):
      drm/radeon: clean up r600_free_extended_power_table()
      drm/radeon: signedness bug in kv_dpm.c

Daniel Vetter (2):
      drm/udl: rip out set_need_resched
      drm/fb-helper: don't sleep for screen unblank when an oops is in progress

Dave Airlie (4):
      drm/ast: fix the ast open key function
      Merge branch 'drm-fixes-3.12' of
git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'drm-fixes-3.12' of
git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'drm-nouveau-next' of
git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

Jean Delvare (2):
      drm/radeon: simplify driver data retrieval
      drm/radeon: expose DPM thermal thresholds through sysfs

Prarit Bhargava (1):
      drm, ttm Fix uninitialized warning

 drivers/gpu/drm/ast/ast_drv.h                   |   2 +-
 drivers/gpu/drm/drm_fb_helper.c                 |   8 ++
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c |  21 ++-
 drivers/gpu/drm/nouveau/nouveau_display.c       |  35 +++--
 drivers/gpu/drm/nouveau/nouveau_fbcon.c         |   3 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c         |   4 +-
 drivers/gpu/drm/radeon/atombios_encoders.c      |  23 ++--
 drivers/gpu/drm/radeon/btc_dpm.c                |   6 -
 drivers/gpu/drm/radeon/ci_dpm.c                 |   6 -
 drivers/gpu/drm/radeon/ci_smc.c                 |  39 ++++--
 drivers/gpu/drm/radeon/cik.c                    |  36 +++++-
 drivers/gpu/drm/radeon/cypress_dpm.c            |   6 -
 drivers/gpu/drm/radeon/dce6_afmt.c              |  12 +-
 drivers/gpu/drm/radeon/kv_dpm.c                 | 164 +++++++++++++++++++-----
 drivers/gpu/drm/radeon/kv_dpm.h                 |   1 +
 drivers/gpu/drm/radeon/kv_smc.c                 |   8 ++
 drivers/gpu/drm/radeon/ni_dpm.c                 |   6 -
 drivers/gpu/drm/radeon/ppsmc.h                  |   2 +
 drivers/gpu/drm/radeon/r100.c                   |   7 +
 drivers/gpu/drm/radeon/r420.c                   |   7 +
 drivers/gpu/drm/radeon/r600.c                   |  19 +++
 drivers/gpu/drm/radeon/r600_dpm.c               |  38 ++----
 drivers/gpu/drm/radeon/r600d.h                  |   2 +-
 drivers/gpu/drm/radeon/radeon.h                 |  82 +++++++++++-
 drivers/gpu/drm/radeon/radeon_asic.c            |  11 +-
 drivers/gpu/drm/radeon/radeon_asic.h            |   5 +
 drivers/gpu/drm/radeon/radeon_connectors.c      |  69 +++++++++-
 drivers/gpu/drm/radeon/radeon_cs.c              |  11 +-
 drivers/gpu/drm/radeon/radeon_device.c          |  11 ++
 drivers/gpu/drm/radeon/radeon_display.c         |  12 ++
 drivers/gpu/drm/radeon/radeon_drv.c             |   2 +-
 drivers/gpu/drm/radeon/radeon_mode.h            |   9 ++
 drivers/gpu/drm/radeon/radeon_pm.c              |  81 +++++++++---
 drivers/gpu/drm/radeon/radeon_trace.h           |  27 +++-
 drivers/gpu/drm/radeon/rs400.c                  |   7 +
 drivers/gpu/drm/radeon/rs600.c                  |  12 +-
 drivers/gpu/drm/radeon/rs690.c                  |   7 +
 drivers/gpu/drm/radeon/rs780_dpm.c              | 112 +++++++++++++---
 drivers/gpu/drm/radeon/rv515.c                  |   8 ++
 drivers/gpu/drm/radeon/rv6xx_dpm.c              |   2 -
 drivers/gpu/drm/radeon/rv770_dpm.c              |  16 +--
 drivers/gpu/drm/radeon/rv770_smc.c              |  44 ++++---
 drivers/gpu/drm/radeon/rv770_smc.h              |   2 -
 drivers/gpu/drm/radeon/rv770d.h                 |   2 +-
 drivers/gpu/drm/radeon/si.c                     |  21 ++-
 drivers/gpu/drm/radeon/si_dpm.c                 |   6 -
 drivers/gpu/drm/radeon/si_smc.c                 |  43 ++++---
 drivers/gpu/drm/radeon/sumo_dpm.c               |   2 -
 drivers/gpu/drm/radeon/trinity_dpm.c            |  17 ++-
 drivers/gpu/drm/radeon/trinity_dpm.h            |   2 +
 drivers/gpu/drm/radeon/trinity_smc.c            |   8 ++
 drivers/gpu/drm/ttm/ttm_object.c                |   2 +-
 drivers/gpu/drm/ttm/ttm_tt.c                    |   2 +-
 drivers/gpu/drm/udl/udl_gem.c                   |   1 -
 include/drm/drm_pciids.h                        |   3 +
 55 files changed, 835 insertions(+), 259 deletions(-)
