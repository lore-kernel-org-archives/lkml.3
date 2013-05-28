Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab3E1U5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:57:25 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:45542 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab3E1U5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:57:23 -0400
Date: Tue, 28 May 2013 22:56:48 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] drm-intel-next for 3.11
Message-ID: <20130528205648.GF15743@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux phenom 3.9.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

So I've figured it's time to upon up drm-next with a nice pile of intel
patches. And there seems to be some other stuff pending on dri-devel
already, too ;-)

Highlights (copy-pasted from my testing cycle mails):
- fbc support for Haswell (Rodrigo)
- streamlined workaround comments, including an igt tool to grep for
  them (Damien)
- sdvo and TV out cleanups, including a fixup for sdvo multifunction devices
- refactor our eDP mess a bit (Imre)
- don't register the hdmi connector on haswell when desktop eDP is present
- vlv support is no longer preliminary!
- more vlv fixes from Jesse for stolen and dpll handling
- more flexible power well checking infrastructure from Paulo
- a few gtt patches from Ben
- a bit of OCD cleanups for transcoder #defines and an assorted pile
  of smaller things.
- fixes for the gmch modeset sequence
- a bit of OCD around plane/pipe usage (Ville)
- vlv turbo support (Jesse)
- tons of vlv modeset fixes (Jesse et al.)
- vlv pte write fixes (Kenneth Graunke)
- hpd filtering to avoid costly probes on unaffected outputs (Egbert Eich)
- intel dev_info cleanups and refactorings (Damien)
- vlv rc6 support (Jesse)
- random pile of fixes around non-24bpp modes handling
- asle/opregion cleanups and locking fixes (Jani)
- dp dpll refactoring
- improvements for reduced_clock computation on g4x/ilk+
- pfit state refactored to use pipe_config (Jesse)
- lots more computed modeset state moved to pipe_config, including readout
  and cross-check support
- fdi auto-dithering for ivb B/C links, using the neat pipe_config
  improvements
- drm_rect helpers plus sprite clipping fixes (Ville)
- hw context refcounting (Mika + Ben)

Note that the merge with Linus' tree was a bit messy so I've also pushed
out a 2nd tag drm-intel-next-2013-05-20-merged which has the backmerge
which is already in my queue. Pull request for the merged tree below. Just
drop the -merged suffix if you want to have some fun ;-)

Cheers, Daniel


The following changes since commit c7788792a5e7b0d5d7f96d0766b4cb6112d47d75:

  Linux 3.10-rc2 (2013-05-20 14:37:38 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel tags/drm-intel-next-2013-05-20-merged

for you to fetch changes up to e1b73cba13a0cc68dd4f746eced15bd6bb24cda4:

  Merge tag 'v3.10-rc2' into drm-intel-next-queued (2013-05-21 09:52:16 +0200)

----------------------------------------------------------------

Ben Widawsky (3):
      drm/i915: Assert mutex_is_locked on context lookup
      drm/i915: BUG_ON bad PPGTT offset
      drm/i915: Extract PDE writes

Chris Wilson (2):
      drm/i915: Only print the info message about incresing stolen size for FBC once
      drm/i915: put context upon switching

Damien Lespiau (12):
      drm/i915: Remove mention of Haswell in DDI code
      drm/i915: Turn DEV_INFO_FLAGS into a foreach style macro
      drm/i915: Replace the line of %s by a DEV_INFO_FOR_EACH_FLAG() invocation
      drm/i915: Use DEV_INFO_FOR_EACH_FLAG() to declare flags as well
      drm/i915: Turn HAS_DDI() into a device_info flag
      drm/i915: Introduce HAS_FPGA_DBG_UNCLAIMED()
      drm/i915: Turn HAS_FPGA_DBG_UNCLAIMED into a device_info flag
      drm/i915: Ivybridge is the odd one when it comes to pipe scalers
      drm/i915: Add platform information to implemented workarounds
      drm/i915: Add references to some workaround we implement
      drm/i915: Compute WR PLL dividers dynamically
      drm/i915: Add missing platform tags to FBC workaround comments

Daniel Vetter (56):
      drm/i915: don't enable the plane too early in i9xx_crtc_mode_set
      drm/i915: drop redundant vblank waits
      drm/i915: add pipe asserts for the crtc enable sequence
      drm/i915: add i9xx pfit pipe asserts
      drm/i915: move debug output back to the right place
      drm/i915: fix VLV limits
      drm/i915: magic VLV PLL registers in the dpio sideband
      drm/i915: disable interrupts earlier in the driver unload code
      drm/i915: Disable high-bpc on pre-1.4 EDID screens
      drm/i915: Fixup non-24bpp support for VGA screens on Haswell
      drm/i915: consolidate pch pll computations a bit
      drm/i915: shovel compute clock into crtc->config.dpll on ilk
      drm/i915: move dp clock computations to encoder->compute_config
      drm/i915: use pipe_config for lvds dithering
      drm/i915: don't force matching p1 for g4x/ilk+ reduced pll settings
      drm/i915: remove redundant has_pch_encoder check
      drm/i915: simplify config->pixel_multiplier handling
      drm/i915: put the right cpu_transcoder into pipe_config for hw state readout
      drm/i915: force bpp for eDP panels
      drm/i915: drop adjusted_mode from *_set_pipeconf functions
      drm/i915: implement high-bpc + pipeconf-dither support for g4x/vlv
      drm/i915: allow high-bpc modes on DP
      drm/i915: move intel_crtc->fdi_lanes to pipe_config
      drm/i915: hw state readout support for pipe_config->fdi_lanes
      drm/i915: split up fdi_set_m_n into computation and hw setup
      drm/i915: compute fdi lane config earlier
      drm/i915: Split up ironlake_check_fdi_lanes
      drm/i915: move fdi lane configuration checks ahead
      drm/i915: don't count cpu ports for fdi B/C lane sharing
      drm/i915: fixup 12bpc hdmi dotclock handling
      drm/i915: implement fdi auto-dithering
      drm/i915: stop for_each_intel_crtc_masked macro from leaking
      drm/i915: introduce macros to check pipe config properties
      drm/i915: hw state readout support for fdi m/n
      drm/i915: hw state readout support for pipe timings
      drm/i915: move lvds_border_bits to pipe_config
      drm/i915: rip out indirection for pfit pipe_config assignment
      drm/i915: move border color writes to pfit_enable
      drm/i915: simplify DP/DDI port width macros
      drm/i915: don't setup hdmi for port D edp in ddi_init
      drm/i915: fix up adjusted_mode tracking for interlaced modes
      drm/i915: s/TRANSCONF/PCH_TRANSCONF/
      drm/i915: PCH_ prefix for transcoder timings
      drm/i915: make set_m_n functions static
      drm/i915: Apply OCD to data/link m/n register #defines
      drm/i915: make intel_cpt_verify_modeset static
      drm/i915: move sdvo TV clock computation to intel_sdvo.c
      drm/i915: drop TVclock special casing on ilk+
      drm/i915: rip out TV-out lore ...
      drm/i915: rip out now unused is_foo tracking from crtc code
      drm/i915: make SDVO TV-out work for multifunction devices
      drm/i915: rip out an unused lvds_reg variable
      drm/i915: panel fitter hw state readout&check support
      drm/i915: Use pipe_config state to disable ilk+ pfit
      drm/i915: Use pipe config state to control gmch pfit enable/disable
      Merge tag 'v3.10-rc2' into drm-intel-next-queued

Egbert Eich (2):
      drm/i915: Add bit field to record which pins have received HPD events (v3)
      drm/i915: Only reprobe display on encoder which has received an HPD event (v2)

Imre Deak (8):
      drm/i915: HSW: allow PCH clock gating for suspend
      drm/i915: use enc_to_intel_dp() instead of opencoding the same
      drm/i915: hsw: replace !is_pch_edp() with port==PORT_A
      drm/i915: ilk-ivb: replace !is_pch_edp() with port==PORT_A
      drm/i915: stop using is_pch_edp() in intel_dp_init_connector()
      drm/i915: stop using is_pch_edp() in is_cpu_edp()
      drm/i915: remove is_pch_edp() helpers and state variable
      drm/i915: print DP init debug messages from a single place

Jan-Simon Möller (1):
      drm/i915: Fix declaration of intel_gmbus_{is_forced_bit/is_port_falid}

Jani Nikula (12):
      drm/i915: keep max backlight internal to intel_panel.c
      drm/i915: protect backlight registers and data with a spinlock
      drm/i915: don't pretend we support ASLE ALS, PFIT, or PFMB
      drm/i915/opregion: don't pretend we did something when we didn't
      drm/i915: drop code duplication in favor of asle interrupt handler
      drm/i915: hsw backlight registers need transcoder instead of pipe
      drm/i915: cleanup opregion technology enabled indicator defines
      drm/i915: manage opregion asle driver readiness properly
      drm/i915: untie opregion init and asle irq/pipestat enable
      drm/i915: cleanup redundant checks from intel_enable_asle
      drm/i915: cleanup opregion asle pipestat enable
      drm/i915: fix hotplug event bit tracking

Jesse Barnes (21):
      drm/i915: VLV GPU frequency to opcode functions
      drm/i915: turbo & RC6 support for VLV v7
      drm/i915: drop init_dpio, shouldn't be needed
      drm/i915: update VLV PLL and DPIO code v11
      drm/i915: use vlv_dport_to_channel in vlv_signal_levels
      drm/i915: fix locking around punit access in cur_delayinfo for VLV
      drm/i915: make sure GPU freq drops to minimum after entering RC6 v4
      drm/i915: cancel RPS work before disabling RPS
      drm/i915: create spearate VLV disable_rps function
      drm/i915: factor out GMCH panel fitting code and use for eDP v3
      drm/i915: move PCH pfit controls into pipe_config
      drm/i915: warn about invalid pfit modes
      drm/i915: remove VLV MSI IRQ hack
      drm/i915: fix Haswell pfit power well check v2
      drm/i915: read current freq from Punit on VLV
      drm/i915: go back to switch for VLV mem freq detection v2
      drm/i915: fix panel fitting on LVDS on ILK+ v2
      drm/i915: set proper DPIO post divider for VGA on VLV v4
      drm/i915: BIOS and power context stolen mem handling for VLV v7
      drm/i915: allow stolen, pre-allocated objects to avoid GTT allocation v2
      drm/i915: VLV support is no longer preliminary

Kenneth Graunke (3):
      drm/i915: Add PTE encoding function to the gtt/ppgtt vtables.
      drm/i915: Fix page table entries for Bay Trail.
      drm/i915: Split out Haswell code from gen6_pte_encode.

Mika Kuoppala (3):
      drm/i915: reference count for i915_hw_contexts
      drm/i915: unreference default context on module unload
      drm/i915: add context into request struct

Pallavi G (1):
      drm/i915/dp: program VSwing and Preemphasis control settings on VLV v2

Paulo Zanoni (10):
      drm/i915: report Gen5+ CPU and PCH FIFO underruns
      drm/i915: print Gen5+ CPU/PCH poison interrupts
      drm/i915: check the power well inside haswell_get_pipe_config
      drm/i915: use cpu_transcoder for TRANS_DDI_FUNC_CTL
      drm/i915: add intel_display_power_enabled
      drm/i915: add power well and cpu transcoder info to the error state
      drm/i915: clear FPGA_DBG_RM_NOCLAIM when capturing error state
      drm/i915: check the power well on i915_pipe_enabled
      drm/i915: only disable DDI sound if intel_crtc->eld_vld
      drm/i915: implement WADPOClockGatingDisable for LPT

Rodrigo Vivi (7):
      drm/i915: Organize VBT stuff inside drm_i915_private
      drm/i915: Add support for FBC on Ivybridge.
      drm/i915: IVB FBC WaFbcAsynchFlipDisableFbcQueue
      drm/i915: IVB FBC WaFbcDisableDpfcClockGating
      drm/i915: Enable FBC at Haswell.
      drm/i915: HSW FBC WaFbcAsynchFlipDisableFbcQueue
      drm/i915: HSW FBC WaFbcDisableDpfcClockGating

Ville Syrjälä (14):
      drm/i915: Use pipe_name() and port_name() where appropriate
      drm/i915: Use port_name() in PCH port audio power change message
      drm/i915: Print plane, pipe, port names as alphabetical insted of decimal
      drm/i915: Use alphabetical names for transcoders too
      drm/i915: Use alphabetical names for sprites
      drm/i915: Move the CSC_MODE bits next to the register
      drm/i915: Make struct dpll == intel_clock_t
      drm: Add struct drm_rect and assorted utility functions
      drm: Add drm_rect_calc_{hscale, vscale}() utility functions
      drm: Add drm_rect_debug_print()
      drm: Add drm_rect_equals()
      drm/i915: Implement proper clipping for video sprites
      drm/i915: Relax the sprite scaling limits checks
      drm/i915: Re-enable FBC WM if the watermark is good on gen6+

braggle@free.fr (1):
      drm/i915: add support for dvo Chrontel 7010B

 Documentation/DocBook/drm.tmpl          |    2 +
 drivers/gpu/drm/Makefile                |    3 +-
 drivers/gpu/drm/drm_rect.c              |  295 ++++++
 drivers/gpu/drm/i915/dvo_ch7xxx.c       |   28 +-
 drivers/gpu/drm/i915/i915_debugfs.c     |   70 +-
 drivers/gpu/drm/i915/i915_dma.c         |   27 +-
 drivers/gpu/drm/i915/i915_drv.c         |   24 +-
 drivers/gpu/drm/i915/i915_drv.h         |  214 +++--
 drivers/gpu/drm/i915/i915_gem.c         |   24 +-
 drivers/gpu/drm/i915/i915_gem_context.c |   74 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c     |  110 ++-
 drivers/gpu/drm/i915/i915_gem_stolen.c  |   18 +-
 drivers/gpu/drm/i915/i915_irq.c         |  441 ++++++++-
 drivers/gpu/drm/i915/i915_reg.h         |  366 +++++--
 drivers/gpu/drm/i915/i915_suspend.c     |   10 +
 drivers/gpu/drm/i915/i915_sysfs.c       |   74 +-
 drivers/gpu/drm/i915/i915_ums.c         |   88 +-
 drivers/gpu/drm/i915/intel_bios.c       |  100 +-
 drivers/gpu/drm/i915/intel_crt.c        |    8 +-
 drivers/gpu/drm/i915/intel_ddi.c        |  710 +++++---------
 drivers/gpu/drm/i915/intel_display.c    | 1594 ++++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_dp.c         |  352 +++++--
 drivers/gpu/drm/i915/intel_drv.h        |  117 ++-
 drivers/gpu/drm/i915/intel_dvo.c        |    7 +
 drivers/gpu/drm/i915/intel_hdmi.c       |  139 ++-
 drivers/gpu/drm/i915/intel_lvds.c       |  248 +----
 drivers/gpu/drm/i915/intel_opregion.c   |  102 +-
 drivers/gpu/drm/i915/intel_panel.c      |  296 +++++-
 drivers/gpu/drm/i915/intel_pm.c         |  591 ++++++++++--
 drivers/gpu/drm/i915/intel_ringbuffer.c |    2 +
 drivers/gpu/drm/i915/intel_ringbuffer.h |    2 +-
 drivers/gpu/drm/i915/intel_sdvo.c       |   44 +-
 drivers/gpu/drm/i915/intel_sprite.c     |  213 ++++-
 drivers/gpu/drm/i915/intel_tv.c         |    8 +-
 include/drm/drm_rect.h                  |  160 ++++
 35 files changed, 4400 insertions(+), 2161 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_rect.c
 create mode 100644 include/drm/drm_rect.h
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
