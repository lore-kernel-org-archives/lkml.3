Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956Ab3DOJk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 05:40:27 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33174 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934577Ab3DOJkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 05:40:25 -0400
Date: Mon, 15 Apr 2013 11:43:25 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [pull] drm-intel-next
Message-ID: <20130415094325.GC27612@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20130415075629.GA27612@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130415075629.GA27612@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 09:56:29AM +0200, Daniel Vetter wrote:
> Hi Dave,
> 
> Since I expect Linus to open the merge window in about a week I guess this
> is the last i915 feature pull for 3.10. Highlights:
> Updated testing tree for -next. Highlights:
> - Corner case fixes discovered with static analyzers (Damien).
> - More fixes to combat unclaimed register errors on Haswell (Paulo).
> - Some small fixes to the gpu turbo code (Rodrigo+Ben), Ben has more
>   fixes for overclocking support pending.
> - More prep work for fastboot from Chris.
> - VT-switchless suspend/resume from Jesse.
> - The prep work of Egbert Eich's hpd irq storm handling. Hopefully we can
>   squeeze in the actual storm handling code for 3.10 ...
> - More convenience helpers for Imre's sg iterator. Core parts acked by
>   Andrew Morton.
> - A bit of backlight code cleanup from Jani.
> - Fixed ilk gpu reset (Jesse).
> - Reduced color range handling fixes for VLV (Ville).
> 
> The big item here is though the introduction of pipe_config to properly
> pre-compute the desired modeset state before touching the hw. Together
> with some very basic support to read out the current config from the hw
> and compare the state with the sw tracking. This is all prep work for more
> reliable fastboot, atomic modesets and other cool features. Stuff
> converted to the new world includes:
> - Most simple pipe attributes (reduce color range, pixel multiplier).
> - Pipe bpp/dither handling.
> - Some convenience flags like ->has_pch_encoder to simplify the code flow.
> - (Almost) DP clock handling, had to be reverted since part of a prep
>   patch was lost in rebasing ...
> Expect a lot of patches for this throughout 3.11, there's tons of work
> till we have all state properly tracked for fastbooting to woExpect a lot
> of patches for this throughout 3.11, there's tons of work till we have all
> state properly tracked for fastbooting to work.
> 
> For 3.10 I have a bunch of fixes queued up and I plan to send them all out
> at the end of this week. I need to shuffle patches in my -next queue a bit
> so that we don't but feature-y stuff in there, too. The main thing I'd
> like to sneak in is Egbert's hpd irq storm handling, which should be
> pretty low-risk since all the infrastructure work has landed already. I
> also have the oops fix pending, but that only mustered review before the
> w/e and giving how hairy that part of our modeset code is, I want to give
> it some more testing before forwarding.
> 
> Note: annarchy.fd.o seems to run out of disk space, so couldn't push the
> usual for-airlied branch. Tag should work though.
> 
> Note 2: I've had to do a backmerge since conflicts grew too ugly, but the
> upstream -rc I've backmerged is already in your drm-next.

Jani pointed out that the pull request below doesn't match my changelog
overview above. And indeed, since git.fd.o refused to cooperate my script
lost track of things. Bad me for not properly checking things. The below
pull should actually match what I want ...

Cheers, Daniel


The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel tags/drm-intel-next-2013-04-06

for you to fetch changes up to bae3699182027525d92b97d904578a533264b242:

  drm/i915: info level for simulated gpu hang dmesg notice (2013-04-06 16:07:21 +0200)

----------------------------------------------------------------
Ben Widawsky (1):
      drm/i915: Don't overclock on Haswell

Chris Wilson (4):
      drm/i915: Always call fence-lost prior to removing the fence
      drm/i915: Introduce i915_gem_object_create_stolen_for_preallocated
      drm/i915: Apply alignment restrictions on scanout surfaces for VT-d
      drm/i915: Skip modifying PCH DREF if not changing clock sources

Christian Lamparter (1):
      drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900

Damien Lespiau (5):
      drm/i915: Error out if we are trying to use VGA with SPLL already in use
      drm/i915: Cleanup if the EDP transcoder has a bobug input value
      drm/i915: Rename intel_ddi_enable_pipe_func() to transcoder_func()
      drm/i915: Use BUG() in a case of a programming error
      drm/i915: Warn if a pipe is enabled with a bogus port

Daniel Vetter (33):
      drm/i915: implement ibx_hpd_irq_setup
      drm/i915: clear crt hotplug compare voltage field before setting
      drm/i915: wire up SDVO hpd support on cpt/ppt
      drm/i915: introduce struct intel_crtc_config
      drm/i915: compute pipe_config earlier
      drm/i915: add pipe_config->timings_set
      drm/i915: add pipe_config->pixel_multiplier
      drm/i915: drop helper vtable for sdvo encoder
      drm/i915: add pipe_config->has_pch_encoder
      drm/i915: add pipe_config->limited_color_range
      drm/i915: introduce pipe_config->dither|pipe_bpp
      drm/i915: precompute pipe bpp before touching the hw
      drm/i915: convert DP autodither code to new infrastructure
      drm/i915: clean up plane bpp confusion
      drm/i915: clean up pipe bpp confusion
      drm/i915: fold wait_for_atomic_us into wait_for_atomic
      drm/i915: fix up _wait_for macro
      drm/i915: check fb->pixel_format instead of bits_per_pixel
      drm/i915: fixup fb bpp computation in pipe_config_set_bpp
      drm/i915: Fix sdvo connector get_hw_state function
      Merge tag 'v3.9-rc5' into drm-intel-next-queued
      drm/i915: clear up the fdi/dp set_m_n confusion
      drm/i915: move dp_m_n computation to dp_encoder->compute_config
      drm/i915: track dp target_clock in pipe_config
      drm/i915: remove leaky eDP functions
      drm/i915: rip out superflous is_dp&is_cpu_edp tracking
      drm/i915: add hw state readout/checking for pipe_config
      drm/i915: hw readout support for ->has_pch_encoders
      drm/i915: create pipe_config->dpll for clock state
      drm/i915: extract i9xx_set_pipeconf
      Revert "drm/i915: fix DP get_hw_state return value"
      drm/i915: revert eDP bpp clamping code changes
      drm/i915: info level for simulated gpu hang dmesg notice

Egbert Eich (5):
      DRM/i915: Remove valleyview_hpd_irq_setup.
      DRM/I915: Add enum hpd_pin to intel_encoder.
      DRM/i915: Convert HPD interrupts to make use of HPD pin assignment in encoders (v2)
      DRM/i915: Remove i965_hpd_irq_setup.
      DRM/i915: Get rid if the 'hotplug_supported_mask' in struct drm_i915_private.

Imre Deak (2):
      lib/scatterlist: sg_page_iter: support sg lists w/o backing pages
      Revert "drm/i915: set dummy page for stolen objects"

Jani Nikula (3):
      drm/i915: keep backlight_level and backlight device brightness in sync
      drm/i915: return actual brightness to .get_brightness callback
      drm/i915: group backlight related stuff into a struct

Jesse Barnes (14):
      drm: add initial_config function to fb helper
      drm/i915: add sprite restore function v3
      drm/i915: restore cursor and sprite state when forcing a config restore v2
      drm/i915: enable VT switchless resume v3
      drm/i915: emit a hotplug event on resume
      drm/i915: fix ILK GPU reset for render
      drm/i915: fix DP get_hw_state return value
      drm/i915: fix DDI get_hw_state return value
      drm/i915: sprite support for ValleyView v4
      drm/i915: add sprite assertion function for VLV
      drm/i915/dp: fix up VLV DP handling v2
      drm/i915: panel power sequencing for VLV eDP v2
      drm/i915: add Punit read/write routines for VLV v2
      drm/i915: drop DPFLIPSTAT enables on VLV v3

Paulo Zanoni (4):
      drm/i915: fix DSPADDR Gen check
      drm/i915: there's no DSPPOS register on gen4+
      drm/i915: there's no PIPESTAT on HAS_PCH_SPLIT platforms
      drm/i915: remove "inline" keyword from ironlake_disable_display_irq

Rodrigo Vivi (1):
      drm/i915: HSW PM Frequency bits fix

Ville Syrjälä (3):
      drm/i915: Wait for vblank between disabling a sprite and unpinning the fb
      drm/i915: Set PIPECONF color range bit on Valleyview
      drm/i915: Don't use the HDMI port color range bit on Valleyview

 drivers/gpu/drm/drm_cache.c                |    7 +-
 drivers/gpu/drm/drm_fb_helper.c            |   23 +-
 drivers/gpu/drm/drm_prime.c                |    8 +-
 drivers/gpu/drm/i915/i915_debugfs.c        |  423 +++------
 drivers/gpu/drm/i915/i915_dma.c            |   29 +-
 drivers/gpu/drm/i915/i915_drv.c            |  170 ++--
 drivers/gpu/drm/i915/i915_drv.h            |   72 +-
 drivers/gpu/drm/i915/i915_gem.c            |   89 +-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |   13 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   36 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c        |   77 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c     |   65 ++
 drivers/gpu/drm/i915/i915_gem_tiling.c     |   18 +-
 drivers/gpu/drm/i915/i915_irq.c            |  457 ++++++----
 drivers/gpu/drm/i915/i915_reg.h            |  260 ++++--
 drivers/gpu/drm/i915/i915_suspend.c        |   15 +-
 drivers/gpu/drm/i915/i915_sysfs.c          |   16 +-
 drivers/gpu/drm/i915/intel_crt.c           |   16 +-
 drivers/gpu/drm/i915/intel_ddi.c           |   62 +-
 drivers/gpu/drm/i915/intel_display.c       | 1355 ++++++++++++++++------------
 drivers/gpu/drm/i915/intel_dp.c            |  504 +++++------
 drivers/gpu/drm/i915/intel_drv.h           |  145 +--
 drivers/gpu/drm/i915/intel_fb.c            |    5 +-
 drivers/gpu/drm/i915/intel_hdmi.c          |  157 ++--
 drivers/gpu/drm/i915/intel_lvds.c          |   48 +-
 drivers/gpu/drm/i915/intel_panel.c         |   44 +-
 drivers/gpu/drm/i915/intel_pm.c            |  164 +++-
 drivers/gpu/drm/i915/intel_sdvo.c          |  119 +--
 drivers/gpu/drm/i915/intel_sprite.c        |  243 ++++-
 drivers/gpu/drm/i915/intel_tv.c            |   14 +-
 drivers/video/fbmem.c                      |    7 +
 include/drm/drm_fb_helper.h                |    4 +
 include/linux/fb.h                         |    2 +
 include/linux/pm.h                         |   13 +
 include/linux/scatterlist.h                |   28 +-
 kernel/power/console.c                     |  116 +++
 lib/scatterlist.c                          |    4 +-
 37 files changed, 2853 insertions(+), 1975 deletions(-)
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
