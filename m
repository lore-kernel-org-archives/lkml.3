Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3BEKqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:46:53 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:57297 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3BEKqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:46:49 -0500
Date: Tue, 5 Feb 2013 11:49:00 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [pull] drm-intel-next for 3.9
Message-ID: <20130205104900.GD5813@phenom.ffwll.local>
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

Probably the last feature pull for 3.9, there's some fixes outstanding
thought that I'd like to sneak in. And maybe 3.8 takes a bit longer ...
Anyway, highlights of this pull:
- Kill the horrible IS_DISPLAYREG hack to handle the mmio offset movements
  on vlv, big thanks to Ville.
- Dynamic power well support for Haswell, shaves away a bit when only
  using the eDP port on pipe A (Paulo). Plus unclaimed register fixes
  uncovered by this.
- Clarifications of the gpu hang/reset state transitions, hopefully fixing
  a few spurious -EIO deaths in userspace.
- Haswell ELD fixes.
- Some more (pp)gtt cleanups from Ben.
- A few smaller things all over.

Plus all the stuff from the previous rather small pull request:
- Broadcast RBG improvements and reduced color range fixes from Ville.
- Ben is on a "kill legacy gtt code for good" spree, first pile of patches
  included.
- No-relocs and bo lut improvements for faster execbuf from Chris.
- Some refactorings from Imre.

QA filed tons of bugs this cycle, all due to us finally enabling all the
really anal timestamp and vblank counter checks in kms_flip, now that the
locking is fixed and EDID reads don't cause stalls any more. In short, our
vblank code seems to be ridiculously racy and broken :( Otoh that's not
really news.

Cheers, Daniel


The following changes since commit b5cc6c0387b2f8d269c1df1e68c97c958dd22fed:

  Merge tag 'drm-intel-next-2012-12-21' of git://people.freedesktop.org/~danvet/drm-intel into drm-next (2013-01-17 20:34:08 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~danvet/drm-intel tags/drm-intel-next-2013-02-01

for you to fetch changes up to 7d37beaaf3dbc6ff16f4d32a4dd6f8c557c6ab50:

  GPU/i915: Fix acpi_bus_get_device() check in drivers/gpu/drm/i915/intel_opregion.c (2013-02-01 11:01:50 +0100)

----------------------------------------------------------------
Ben Widawsky (16):
      drm/i915: Kill gtt_end
      drm/i915: Mappable_end can't ever be > end
      drm/i915: Remove gtt_mappable_total
      drm/i915: Create a gtt structure
      drm/i915: Remove use on gma_bus_addr on gen6+
      drm/i915: Remove use of gtt_mappable_entries
      drm/i915: Cut out the infamous ILK w/a from AGP layer
      drm/i915: Remove scratch page from shared
      drm/i915: Needs_dmar, not
      agp/intel: Add gma_bus_addr
      drm/i915: Implement WaVSRefCountFullforceMissDisable
      drm/i915: Error state should print /sys/kernel/debug
      drm/i915: Add probe and remove to the gtt ops
      drm/i915: remove intel_gtt structure
      drm/i915: Reclaim GTT space for failed PPGTT
      drm/i915: Fix CAGF for HSW

Changlong Xie (1):
      drm/i915: gen6_gmch_remove can be static

Chris Wilson (9):
      drm/i915: Add a debug interface to forcibly evict and shrink our object caches
      drm/i915: Bail if we attempt to allocate pages for a purged object
      drm/i915: Mark a temporary allocation for copy-from-user as such
      drm/i915: Take the handle idr spinlock once for looking up the exec objects
      drm/i915: Move the execbuffer objects list from the stack into the tracker
      drm/i915: Use the reloc.handle as an index into the execbuffer array
      drm/i915: Only insert the mb() before updating the fence parameter
      drm/i915: Only apply the mb() when flushing the GTT domain during a finish
      drm/i915: Only run idle processing from i915_gem_retire_requests_worker

Daniel Vetter (21):
      drm/i915: wake up all pageflip waiters
      drm/i915: Allow userspace to hint that the relocations were known
      drm/i915: move dev_priv->mm out of line
      drm/i915: extract hangcheck/reset/error_state state into substruct
      drm/i915: move wedged to the other gpu error handling stuff
      drm/i915: fix reset handling in the throttle ioctl
      drm/i915: clear up wedged transitions
      drm/i915: create a race-free reset detection
      drm/i915: clarify concurrent hang detect/gpu reset consistency
      drm/i915: fixup sbi_read/write locking
      drm/i915: move modeset checks out of save/restore_modeset_reg
      drm/i915: extract ums suspend/resume into i915_ums.c
      drm/i915: dont save/restore VGA state for kms
      drm/i915: move DP save/restore into i915_ums.c
      drm/i915: vfuncs for gtt_clear_range/insert_entries
      drm/i915: vfuncs for ppgtt
      drm/i915: pte_encode is gen6+
      drm/i915: extract hw ppgtt setup/cleanup code
      drm/i915: kill cargo-culted locking from power well code
      drm/i915: don't run hsw power well code on !hsw
      drm/i915: dynamic Haswell display power well support

Egbert Eich (1):
      drm/i915: Remove pch_rq_mask from struct drm_i915_private.

Imre Deak (3):
      drm/i915: merge get_gtt_alignment/get_unfenced_gtt_alignment()
      drm/i915: merge {i965, sandybridge}_write_fence_reg()
      drm/i915: use gtt_get_size() instead of open coding it

Jani Nikula (3):
      drm/i915: add quirk to invert brightness on eMachines G725
      drm/i915: add quirk to invert brightness on eMachines e725
      drm/i915: add quirk to invert brightness on Packard Bell NCL20

Mika Kuoppala (1):
      drm/i915: use gem_set_seqno() on hardware init

Paulo Zanoni (7):
      drm/i915: don't save/restore DSPARB on gen5+
      drm/i915: fix intel_init_power_wells
      drm/i915: only disable enabled planes on intel_fb_restore_mode
      drm/i915: set TRANSCODER_EDP even earlier
      drm/i915: turn on the power well before suspending
      drm/i915: don't send DP "idle" pattern before "normal" on HSW PORT_A
      drm/i915: check the power down well on assert_pipe()

Ville Syrjälä (37):
      drm/i915: Fix SPRITE0_FLIP_DONE_INT_EN_VLV and SPRITE0_FLIPDONE_INT_STATUS_VLV
      drm/i915: Fix RGB color range property for PCH platforms
      drm/i915: Add "Automatic" mode for the "Broadcast RGB" property
      drm/edid: Add drm_rgb_quant_range_selectable()
      drm/i915: Provide the quantization range in the AVI infoframe
      drm/i915: Convert intel_hdmi to enum port
      drm/i915: Convert intel_dp to enum port
      drm/i915: Add display_display_mmio_offset to intel_device_info
      drm/i915: AUD_VID_DID needs an offset on VLV
      drm/i915: Per-pipe PP registers are for VLV only
      drm/i915: VLV_VIDEO_DIP_CTL is for VLV only
      drm/i915: PIPE M/N registers need an offset on VLV
      drm/i915: Primary plane registers need an offset on VLV
      drm/i915: Pipe registers need an offset on VLV
      drm/i915: Cursor registers need an offset on VLV
      drm/i915: VLV_DDL is VLV only and needs an offset
      drm/i915: DSPFW registers need an offset on VLV
      drm/i915: DPFLIPSTAT and DPINVGTT registers are VLV only and need an offset
      drm/i915: Panel fitter registers need an offset on VLV
      drm/i915: PORT_HOTPLUG registers need an offset on VLV
      drm/i915: Pipe timing registers need an offset on VLV
      drm/i915: Pipe palette registers need an offset on VLV
      drm/i915: FB_BLC_SELF_VLV is VLV only and needs an offset
      drm/i915: Make VLV_GUNIT_CLOCK_GATE register value more readable
      drm/i915: Spell out VLV_DISPLAY_BASE for interrupt registers
      drm/i915: DPIO registers are VLV only and need an offset
      drm/i915: GPIO/GMBUS registers need an offset on VLV
      drm/i915: Set display_mmio_offset for VLV
      drm/i915: PLL registers need an offset on VLV
      drm/i915: Always use adpa_reg
      drm/i915: VLV doesn't have SDVO
      drm/i915: Pass VLV_DISPLAY_BASE + reg to intel_{hdmi, dp}_init on VLV
      drm/i915: Include display_mmio_offset in sequencer index/data registers
      drm/i915: SWF screatch registers need an offset on VLV
      drm/i915: Introduce i915_vgacntrl_reg()
      drm/i915: Kill IS_DISPLAYREG()
      drm/i915: Set the SR01 "screen off" bit in i915_redisable_vga() too

Wang Xingchao (1):
      drm/i915: HDMI/DP - ELD info refresh support for Haswell

Yasuaki Ishimatsu (1):
      GPU/i915: Fix acpi_bus_get_device() check in drivers/gpu/drm/i915/intel_opregion.c

 drivers/char/agp/intel-gtt.c               |   87 ++--
 drivers/gpu/drm/drm_edid.c                 |   33 ++
 drivers/gpu/drm/i915/Makefile              |    1 +
 drivers/gpu/drm/i915/i915_debugfs.c        |  131 +++++-
 drivers/gpu/drm/i915/i915_dma.c            |   43 +-
 drivers/gpu/drm/i915/i915_drv.c            |  116 +-----
 drivers/gpu/drm/i915/i915_drv.h            |  381 +++++++++++-------
 drivers/gpu/drm/i915/i915_gem.c            |  285 +++++++-------
 drivers/gpu/drm/i915/i915_gem_evict.c      |    2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |  280 +++++++------
 drivers/gpu/drm/i915/i915_gem_gtt.c        |  590 +++++++++++++++-------------
 drivers/gpu/drm/i915/i915_gem_stolen.c     |    8 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c     |   21 +-
 drivers/gpu/drm/i915/i915_irq.c            |  130 ++++--
 drivers/gpu/drm/i915/i915_reg.h            |  286 +++++++-------
 drivers/gpu/drm/i915/i915_suspend.c        |  540 ++-----------------------
 drivers/gpu/drm/i915/i915_ums.c            |  503 ++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_crt.c           |   29 +-
 drivers/gpu/drm/i915/intel_ddi.c           |   29 +-
 drivers/gpu/drm/i915/intel_display.c       |  144 ++++---
 drivers/gpu/drm/i915/intel_dp.c            |   64 ++-
 drivers/gpu/drm/i915/intel_drv.h           |   18 +-
 drivers/gpu/drm/i915/intel_fb.c            |    8 +-
 drivers/gpu/drm/i915/intel_hdmi.c          |   72 +++-
 drivers/gpu/drm/i915/intel_i2c.c           |    2 +
 drivers/gpu/drm/i915/intel_modes.c         |    5 +-
 drivers/gpu/drm/i915/intel_opregion.c      |    2 +-
 drivers/gpu/drm/i915/intel_overlay.c       |    4 +-
 drivers/gpu/drm/i915/intel_pm.c            |   62 ++-
 drivers/gpu/drm/i915/intel_ringbuffer.c    |   12 +-
 drivers/gpu/drm/i915/intel_sdvo.c          |   59 ++-
 include/drm/drm_crtc.h                     |    1 +
 include/drm/intel-gtt.h                    |   19 +-
 include/uapi/drm/i915_drm.h                |   20 +
 34 files changed, 2255 insertions(+), 1732 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/i915_ums.c

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
