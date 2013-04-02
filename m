Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286Ab3DBJbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:31:25 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:48420 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760950Ab3DBJbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:31:18 -0400
Date: Tue, 2 Apr 2013 11:34:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] drm-intel-next
Message-ID: <20130402093412.GQ2228@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

So I've figured we should get drm-next for 3.10 started ;-)

Highlights:
- Imre's for_each_sg_pages rework (now also with the stolen mem backed
  case fixed with a hack) plus the drm prime sg list coalescing patch from
  Rahul Sharma. I have some follow-up cleanups pending, already acked by
  Andrew Morton.
- Some prep-work for the crazy no-pch/display-less platform by Ben.
- Some vlv patches, by far not all (Jesse et al).
- Clean up the HDMI/SDVO #define confusion (Paulo)
- gen2-4 vblank fixes from Ville.
- Unclaimed register warning fixes for hsw (Paulo). More still to come ...
- Complete pageflips which have been stuck in a gpu hang, should prevent
  stuck gl compositors (Ville).
- pm patches for vt-switchless resume (Jesse). Note that the i915 enabling
  is not (yet) included, that took a bit longer to settle. PM patches are
  acked by Rafael Wysocki.
- Minor fixlets all over from various people.

All together it's been pretty quiet thus far.

Cheers, Daniel


The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel tags/drm-intel-next-2013-03-23

for you to fetch changes up to e3dff585508636c8d2915cc1595e04f16ccd66ba:

  drm/i915: Implement WaSwitchSolVfFArbitrationPriority (2013-03-23 12:18:06 +0100)

----------------------------------------------------------------
Ben Widawsky (9):
      drm/i915: Created a sized object error dump
      drm/i915: exclude CCID for platforms without it
      drm/i915: Capture current context on error
      drm/i915: Remove unused file arg from execbuf
      drm/i915: Remove unneeded dev argument
      drm/i915: Move num_pipes to intel info
      drm/i915: Introduce GEN7_FEATURES for device info
      drm/i915: Correct sandybrige overclocking
      drm/i915: Implement WaSwitchSolVfFArbitrationPriority

Chris Wilson (1):
      drm/i915: Resurrect ring kicking for semaphores, selectively

Damien Lespiau (1):
      drm/i915: Remove platforms in the preliminary_hw_support description

Daniel Vetter (4):
      drm/i915: gen2 has no tv out support
      Merge tag 'v3.9-rc3' into drm-intel-next-queued
      style nit: Align function parameter continuation properly.
      drm/i915: fixup pd vs pt confusion in gen6 ppgtt code

Imre Deak (5):
      drm: handle compact dma scatter lists in drm_clflush_sg()
      drm/i915: set dummy page for stolen objects
      drm/i915: handle walking compact dma scatter lists
      drm/i915: create compact dma scatter lists for gem objects
      drm/i915: use for_each_sg_page for setting up the gtt ptes

Jani Nikula (2):
      drm/i915: add \n to the end of sysfs attributes
      drm/i915: reduce power in the ilk rc6 enable error message

Jesse Barnes (18):
      PM: make VT switching to the suspend console optional v3
      fb: add support for drivers not needing VT switch at suspend/resume time
      drm/i915: don't restore LVDS enable state blindly v2
      drm/i915: remove disabled memset of framebuffer from intel_fb
      drm/i915: don't init LVDS on VLV
      drm/i915: VLV has force wake
      drm/i915/dp: don't use ILK paths on VLV
      drm/i915: use gen6 stolen check on VLV
      drm/i915/dp: add pre-PCH eDP checking to DP detect for VLV
      drm/i915: allow force wake at init time on VLV v2
      drm/i915: don't use plane pipe select on VLV
      drm/i915: add media well to VLV force wake routines v2
      drm/i915: use VLV DIP routines on VLV v2
      drm/i915: add more VLV IDs
      drm/i915: fix WaDisablePSDDualDispatchEnable on VLV v2
      drm/i915: set conservative clock gating values on VLV v2
      drm/i915: DSPFW and BLC regs are in the display offset range
      drm/i915: VLV doesn't have HDMI on port C

Kees Cook (2):
      drm/i915: use simple attribute in debugfs routines
      drm/i915: clarify reasoning for the access_ok call

Mihnea Dobrescu-Balaur (1):
      gpu: don't cast kzalloc() return value

Mika Kuoppala (1):
      drm/i915: remove obsolete obj assignment in page flip

Paulo Zanoni (19):
      drm/i915: use HAS_DDI on intel_hdmi.c and intel_display.c
      drm/i915: wait_event_timeout's timeout is in jiffies
      drm/i915: add aux_ch_ctl_reg to struct intel_dp
      drm/i915: rename sdvox_reg to hdmi_reg on HDMI context
      drm/i915: create functions for the "unclaimed register" checks
      drm/i915: use FPGA_DBG for the "unclaimed register" checks
      drm/i915: clear the FPGA_DBG_RM_NOCLAIM bit at driver init
      drm/i915: clarify confusion between SDVO and HDMI registers
      drm/i915: unify the definitions of the HDMI/SDVO register
      drm/i915: remove duplicated SDVO/HDMI bit definitions
      drm/i915: rename some HDMI bit definitions
      drm/i915: disable sound first on intel_disable_ddi
      drm/i915: capture the correct cursor registers on IVB
      drm/i915: there's no DSPSIZE register on gen4+
      drm/i915: there's no DSPADDR register on Haswell
      drm/i915: add HAS_POWER_WELL
      drm/i915: reorganize intel_lvds_supported
      drm/i915: don't save/restore PCH_LVDS on LPT
      drm/i915: add missing space in error message

Rahul Sharma (1):
      drm: modify pages_to_sg prime helper to create optimized SG table

Rodrigo Vivi (1):
      drm/i915: Use cpu_transcoder for HSW_TVIDEO_DIP_* instead of pipe

Ville Syrjälä (15):
      drm/i915: Really wait for pending flips when panning
      drm/i915: Finish page flips and update primary planes after a GPU reset
      drm/i915: Eliminate race from gen2/3 page flip interrupt handling
      drm/i915: Fix races in gen4 page flip interrupt handling
      drm/i915: Refactor gen2 to gen4 vblank interrupt handling
      drm/i915: Kill pipestat[] cache
      drm/i915: Add to_user_ptr()
      drm/i915: Document the find_pll() function
      drm/i915: Remove a stale and misplaced comment
      drm/i915: Kill a few pointless comments
      drm/i915: Use FORCEWAKE_KERNEL instead of hardcoded number in MT forcewake ACK
      drm/i915: Use '1' instead of FORCEWAKE_KERNEL for ST force wake
      drm/i915: Single thread force wake isn't used on HSW anymore
      drm/i915: Kill a strange comment about DPMS functions
      drm/i915: Set the VIC in AVI infoframe for SDVO

 drivers/gpu/drm/drm_cache.c                |    7 +-
 drivers/gpu/drm/drm_prime.c                |    8 +-
 drivers/gpu/drm/i915/i915_debugfs.c        |  423 ++++++++--------------------
 drivers/gpu/drm/i915/i915_dma.c            |   27 +-
 drivers/gpu/drm/i915/i915_drv.c            |  132 ++++-----
 drivers/gpu/drm/i915/i915_drv.h            |   30 +-
 drivers/gpu/drm/i915/i915_gem.c            |   78 ++---
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |   13 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   36 +--
 drivers/gpu/drm/i915/i915_gem_gtt.c        |   79 ++----
 drivers/gpu/drm/i915/i915_gem_stolen.c     |    4 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c     |   18 +-
 drivers/gpu/drm/i915/i915_irq.c            |  249 +++++++++++-----
 drivers/gpu/drm/i915/i915_reg.h            |  142 +++++-----
 drivers/gpu/drm/i915/i915_suspend.c        |   15 +-
 drivers/gpu/drm/i915/i915_sysfs.c          |   16 +-
 drivers/gpu/drm/i915/intel_ddi.c           |   12 +-
 drivers/gpu/drm/i915/intel_display.c       |  194 ++++++++-----
 drivers/gpu/drm/i915/intel_dp.c            |   88 +++---
 drivers/gpu/drm/i915/intel_drv.h           |    7 +-
 drivers/gpu/drm/i915/intel_fb.c            |    4 +-
 drivers/gpu/drm/i915/intel_hdmi.c          |  114 ++++----
 drivers/gpu/drm/i915/intel_lvds.c          |    7 +-
 drivers/gpu/drm/i915/intel_panel.c         |    2 +-
 drivers/gpu/drm/i915/intel_pm.c            |   65 +++--
 drivers/gpu/drm/i915/intel_sdvo.c          |   50 ++--
 drivers/video/fbmem.c                      |    7 +
 include/linux/fb.h                         |    2 +
 include/linux/pm.h                         |   13 +
 kernel/power/console.c                     |  116 ++++++++
 30 files changed, 1037 insertions(+), 921 deletions(-)

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
