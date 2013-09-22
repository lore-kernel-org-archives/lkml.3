Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3IVWiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:38:09 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:45549 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3IVWiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:38:08 -0400
MIME-Version: 1.0
Date: Mon, 23 Sep 2013 08:38:06 +1000
Message-ID: <CAPM=9twXzs1KJ_YC_K2s3=gE8EV238S0=QUvv_rERJcSxp2MAA@mail.gmail.com>
Subject: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

some small fixes for msm and exynos,
a regression revert affecting nouveau users with old userspace,
intel pageflip deadlock and gpu hang fixes, hsw modesetting hangs,

Dave.

The following changes since commit 928c2f0c006bf7f381f58af2b2786d2a858ae311:

  drm/fb-helper: don't sleep for screen unblank when an oops is in
progress (2013-09-19 11:54:34 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 6ddf2ed6e00396883b3123032ccb4416205aac7c:

  Merge branch 'msm-fixes-3.12' of
git://people.freedesktop.org/~robclark/linux into drm-fixes
(2013-09-20 09:06:48 +1000)

----------------------------------------------------------------

Chris Wilson (1):
      drm/i915: Track pfit enable state separately from size

Daniel Vetter (5):
      drm/i915: fix wait_for_pending_flips vs gpu hang deadlock
      drm/i915/sdvo: Fully translate sync flags in the dtd->mode conversion
      drm/i915/sdvo: Robustify the dtd<->drm_mode conversions
      drm/i915/dvo: set crtc timings again for panel fixed modes
      drm/i915: kill set_need_resched

Dave Airlie (4):
      Revert "drm: mark context support as a legacy subsystem"
      Merge tag 'drm-intel-fixes-2013-09-19' of
git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'exynos-drm-fixes' of
git://git.kernel.org/.../daeinki/drm-exynos into drm-fixes
      Merge branch 'msm-fixes-3.12' of
git://people.freedesktop.org/~robclark/linux into drm-fixes

Jani Nikula (1):
      drm/i915: do not update cursor in crtc mode set

Rob Clark (6):
      drm/msm: handle read vs write fences
      drm/msm: hangcheck harder
      drm/msm: fix cmdstream size check
      drm/msm: return -EBUSY if bo still active
      drm/msm: workaround for missing irq
      drm/msm: drop unnecessary set_need_resched()

Sachin Kamat (3):
      drm/exynos: Remove redundant OF dependency
      drm/exynos: Fix address space warning in exynos_drm_buf.c
      drm/exynos: Fix address space warnings in exynos_drm_fbdev.c

Takashi Iwai (1):
      drm/i915: Use proper print format for debug prints

Ville Syrjälä (1):
      drm/i915: Don't enable the cursor on a disable pipe

Wei Yongjun (3):
      drm/msm: fix return value check in ERR_PTR()
      drm/msm: fix potential NULL pointer dereference
      drm/exynos: fix return value check in lowlevel_buffer_allocate()

 drivers/gpu/drm/drm_context.c             | 73 ++++---------------------------
 drivers/gpu/drm/drm_fops.c                | 21 ++++++++-
 drivers/gpu/drm/drm_stub.c                | 10 ++++-
 drivers/gpu/drm/exynos/Kconfig            |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_buf.c   |  7 +--
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c |  5 ++-
 drivers/gpu/drm/i915/i915_gem.c           | 11 ++---
 drivers/gpu/drm/i915/i915_irq.c           | 68 ++++++++++++++++++++++------
 drivers/gpu/drm/i915/intel_ddi.c          |  2 +-
 drivers/gpu/drm/i915/intel_display.c      | 42 +++++++++---------
 drivers/gpu/drm/i915/intel_drv.h          |  1 +
 drivers/gpu/drm/i915/intel_dvo.c          |  2 +
 drivers/gpu/drm/i915/intel_panel.c        |  1 +
 drivers/gpu/drm/i915/intel_pm.c           |  6 +--
 drivers/gpu/drm/i915/intel_sdvo.c         | 63 ++++++++++++++------------
 drivers/gpu/drm/msm/adreno/adreno_gpu.c   | 10 ++++-
 drivers/gpu/drm/msm/msm_drv.c             | 50 ++++++++++++++-------
 drivers/gpu/drm/msm/msm_drv.h             |  8 +++-
 drivers/gpu/drm/msm/msm_gem.c             | 34 +++++++++-----
 drivers/gpu/drm/msm/msm_gem.h             |  2 +-
 drivers/gpu/drm/msm/msm_gem_submit.c      | 24 +++++-----
 drivers/gpu/drm/msm/msm_gpu.c             | 24 ++++++++--
 include/drm/drmP.h                        |  7 ++-
 23 files changed, 276 insertions(+), 197 deletions(-)
