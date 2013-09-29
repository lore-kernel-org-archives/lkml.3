Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab3I2DCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 23:02:33 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55654 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3I2DCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 23:02:31 -0400
MIME-Version: 1.0
Date: Sun, 29 Sep 2013 13:02:29 +1000
Message-ID: <CAPM=9txEQqvqHtbXD0Z9Df8GFiU3+AQzdd7ArnOcJLwK5=yFYg@mail.gmail.com>
Subject: [git pull] drm fixes
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

nothing too major, radeon still has some dpm changes for off by default.

radeon, intel, msm:
radeon a few more dpm fixes (still off by default), uvd fixes,
i915 runtime warn backtrace and regression fix
msm: iommu changes fallout,

Dave.

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 665441791f553221901f679cb47236798f9a649c:

  Merge branch 'msm-fixes-3.12-rc2' of
git://people.freedesktop.org/~robclark/linux into drm-fixes
(2013-09-29 10:06:28 +1000)

----------------------------------------------------------------

Alex Deucher (13):
      drm/radeon: avoid UVD corruption on AGP cards using GPU gart
      drm/radeon: additional gcc fixes for radeon_atombios.c
      drm/radeon: fix missed variable sized access
      drm/radeon/dpm: fetch the max clk from voltage dep tables helper
      drm/radeon/dpm/btc: filter clocks based on voltage/clk dep tables
      drm/radeon/dpm/ni: filter clocks based on voltage/clk dep tables
      drm/radeon/dpm/si: filter clocks based on voltage/clk dep tables
      drm/radeon/dpm/ci: filter clocks based on voltage/clk dep tables
      drm/radeon: don't set default clocks for SI when DPM is disabled
      drm/radeon: disable tests/benchmarks if accel is disabled
      drm/radeon: add missing hdmi callbacks for rv6xx
      drm/radeon/cik: fix overflow in vram fetch
      drm/radeon: fix hdmi audio on DCE3.0/3.1 asics

Alex Ivanov (1):
      drm/radeon: Make r100_cp_ring_info() and radeon_ring_gfx() safe (v2)

Chris Wilson (1):
      drm/i915: Use a temporary va_list for two-pass string handling

Christian König (1):
      drm/radeon/uvd: lower msg&fb buffer requirements on UVD3

Daniel Vetter (3):
      drm/i915/tv: clear adjusted_mode.flags
      drm/i915: preserve pipe A quirk in i9xx_set_pipeconf
      drm/i915: Fix up usage of SHRINK_STOP

Dave Airlie (3):
      Merge tag 'drm-intel-fixes-2013-09-26' of
git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.12' of
git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'msm-fixes-3.12-rc2' of
git://people.freedesktop.org/~robclark/linux into drm-fixes

Jani Nikula (1):
      drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER

Joerg Roedel (1):
      drm/msm: Remove iommu include from mdp4_kms.c

Michel Dänzer (3):
      drm/radeon/cik: Fix printing of client name on VM protection fault
      drm/radeon/cik: Fix encoding of number of banks in tiling
configuration info
      drm/radeon/cik: Add tiling mode index for 1D tiled depth/stencil surfaces

Rob Clark (2):
      drm/msm: deal with mach/iommu.h removal
      drm/msm: use drm_gem_dumb_destroy helper

Thomas Meyer (1):
      drm/msm: Odd PTR_ERR usage

 drivers/gpu/drm/i915/i915_gem.c          |  8 ++--
 drivers/gpu/drm/i915/i915_gpu_error.c    |  6 ++-
 drivers/gpu/drm/i915/intel_display.c     |  4 ++
 drivers/gpu/drm/i915/intel_dp.c          | 13 ++++++-
 drivers/gpu/drm/i915/intel_tv.c          |  8 ++++
 drivers/gpu/drm/msm/mdp4/mdp4_kms.c      |  2 -
 drivers/gpu/drm/msm/msm_drv.c            |  8 ++--
 drivers/gpu/drm/msm/msm_gem.c            |  7 ----
 drivers/gpu/drm/radeon/btc_dpm.c         | 51 ++++++++++++++++++++++++
 drivers/gpu/drm/radeon/btc_dpm.h         |  2 +
 drivers/gpu/drm/radeon/ci_dpm.c          | 26 +++++++++++++
 drivers/gpu/drm/radeon/cik.c             | 17 ++++----
 drivers/gpu/drm/radeon/ni_dpm.c          | 24 ++++++++++++
 drivers/gpu/drm/radeon/r100.c            |  8 ++--
 drivers/gpu/drm/radeon/r600_dpm.c        |  2 +-
 drivers/gpu/drm/radeon/r600_hdmi.c       | 20 +++++++---
 drivers/gpu/drm/radeon/radeon_asic.c     |  2 +
 drivers/gpu/drm/radeon/radeon_atombios.c | 66 +++++++++++++++++++++-----------
 drivers/gpu/drm/radeon/radeon_cs.c       |  5 ++-
 drivers/gpu/drm/radeon/radeon_device.c   | 15 ++++++--
 drivers/gpu/drm/radeon/radeon_pm.c       |  8 ++--
 drivers/gpu/drm/radeon/radeon_ring.c     |  8 ++--
 drivers/gpu/drm/radeon/radeon_uvd.c      |  3 +-
 drivers/gpu/drm/radeon/si_dpm.c          | 24 ++++++++++++
 drivers/gpu/drm/radeon/uvd_v1_0.c        |  4 +-
 include/uapi/drm/radeon_drm.h            |  2 +
 26 files changed, 266 insertions(+), 77 deletions(-)
