Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbaHHOey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:34:54 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36272 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbaHHOer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:34:47 -0400
Date: Fri, 8 Aug 2014 16:34:51 +0200
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] drm-intel-fixes
Message-ID: <20140808143418.GA25720@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

So I heard that proper pull requests have a revert on top ;-) So here we
go with my usual mid-merge-window pile of fixes.

Big fix is the duct-tape for ring init on g4x platforms, we seem to have
found the magic again to make those machines as happy as before (not
perfect though unfortunately, but that was never the case).

Otherwise fixes all over:
- tune down some overzealous debug output
- VDD power sequencing fix after resume
- bunch of dsi fixes for baytrail among them hw state checker de-noising
- bunch of error state capture fixes for bdw
- misc tiny fixes/workarounds for various platforms

Last minute rebase was to kick out two patches that shouldn't have been in
here - they're for the state checker, so 0 functional code affected.

Jani's back from vacation, so he'll take over -fixes from here.

Cc'ing Linus since you're travelling in case you want him to pick this up
directly.

Cheers, Daniel


The following changes since commit a91576d7916f6cce76d30303e60e1ac47cf4a76d:

  drm/ttm: Pass GFP flags in order to avoid deadlock. (2014-08-05 10:54:19 +1000)

are available in the git repository at:

  git://anongit.freedesktop.org/drm-intel tags/drm-intel-fixes-2014-08-08

for you to fetch changes up to be71eabebaf9f142612d34d42292b454e984dcb5:

  Revert "drm/i915: Enable semaphores on BDW" (2014-08-08 16:22:19 +0200)

----------------------------------------------------------------
Daniel Vetter (4):
      drm/i915: Update DRIVER_DATE to 20140725
      drm/i915: Don't require dev->struct_mutex in psr_match_conditions
      drm/i915: Tune done rc6 enabling output
      drm/i915: Tune down MCH_SSKPD values warning

Deepak S (1):
      drm/i915: Bring GPU Freq to min while suspending.

Imre Deak (2):
      drm/i915: factor out intel_edp_panel_vdd_sanitize
      drm/i915: fix VDD state tracking after system resume

Jiri Kosina (1):
      drm/i915: read HEAD register back in init_ring_common() to enforce ordering

Kenneth Graunke (2):
      drm/i915: Refactor Broadwell PIPE_CONTROL emission into a helper.
      drm/i915: Add the WaCsStallBeforeStateCacheInvalidate:bdw workaround.

Mika Kuoppala (1):
      drm/i915: Don't accumulate hangcheck score on forward progress

Pavel Machek (1):
      drm/i915: work around warning in i915_gem_gtt

Rafael Barbalho (1):
      drm/i915: Fix crash when failing to parse MIPI VBT

Rodrigo Vivi (4):
      drm/i915: Fix error state collecting
      drm/i915: Collect gtier properly on HSW.
      drm/i915: Fix DEIER and GTIER collecting for BDW.
      Revert "drm/i915: Enable semaphores on BDW"

Shobhit Kumar (2):
      drm/i915: wait for all DSI FIFOs to be empty
      drm/i915: Add correct hw/sw config check for DSI encoder

Ville Syrjälä (1):
      drm/i915: Fix threshold for choosing 32 vs. 64 precisions for VLV DDL values

Zhenyu Wang (1):
      drm/i915: Fix drain latency precision multipler for VLV

 drivers/gpu/drm/i915/i915_drv.c         |  4 ++
 drivers/gpu/drm/i915/i915_drv.h         |  3 +-
 drivers/gpu/drm/i915/i915_gem.c         |  2 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c     | 11 +++--
 drivers/gpu/drm/i915/i915_gpu_error.c   | 35 +++++++++-----
 drivers/gpu/drm/i915/i915_irq.c         | 15 ++++--
 drivers/gpu/drm/i915/i915_reg.h         | 50 ++++++++++----------
 drivers/gpu/drm/i915/intel_bios.c       |  2 +-
 drivers/gpu/drm/i915/intel_display.c    |  4 ++
 drivers/gpu/drm/i915/intel_dp.c         | 67 +++++++++++++++++++--------
 drivers/gpu/drm/i915/intel_drv.h        |  1 +
 drivers/gpu/drm/i915/intel_dsi.c        | 29 +++++++++++-
 drivers/gpu/drm/i915/intel_dsi.h        |  1 +
 drivers/gpu/drm/i915/intel_dsi_cmd.c    | 16 +++++++
 drivers/gpu/drm/i915/intel_dsi_cmd.h    |  1 +
 drivers/gpu/drm/i915/intel_dsi_pll.c    | 81 +++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_pm.c         | 41 ++++++++---------
 drivers/gpu/drm/i915/intel_ringbuffer.c | 47 +++++++++++++------
 drivers/gpu/drm/i915/intel_ringbuffer.h |  2 +
 19 files changed, 310 insertions(+), 102 deletions(-)

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
