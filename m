Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaFLA6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:58:41 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56098 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaFLA6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:58:36 -0400
Date: Thu, 12 Jun 2014 01:58:32 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm merge tree
Message-ID: <alpine.DEB.2.00.1406120157510.2473@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-784526306-1402534712=:2473"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-784526306-1402534712=:2473
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

This is the main drm merge window pull request, changes all over the place, mostly normal levels of churn.

Highlights:
drm: 

more cleanups, fix race on connector/encoder naming, docs updates, object locking rework in prep for atomic modeset

i915:

mipi DSI support, valleyview power fixes, cursor size fixes, execlist refactoring,
vblank improvements, userptr support, OOM handling improvements

radeon:

GPUVM tuning and large page size support, gart fixes, deep color HDMI support, HDMI audio cleanups

nouveau:

displayport rework should fix lots of issues,
initial gk20a support,
gk110b support,
gk208 fixes

exynos:

probe order fixes, HDMI changes, IPP consolidation,
msm:

debugfs updates, misc fixes

ast:

ast2400 support, sync with UMS driver

tegra:

cleanups, hdmi + hw cursor for Tegra 124.

panel:

fixes existing panels add some new ones.

ipuv3:

moved from staging to drivers/gpu

The following changes since commit 9e9a928eed8796a0a1aaed7e0b676db86ba84594:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2014-06-04 07:48:01 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to bc1dfff04a5d4064ba0db1fab13f84ab4f333d2b:

  Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next (2014-06-11 16:28:10 +1000)

----------------------------------------------------------------

Akash Goel (3):
      drm/i915: Enabling the TLB invalidate bit in GFX Mode register
      drm/i915/vlv:Implement the WA 'WaDisable_RenderCache_OperationalFlush'
      drm/i915/vlv: Modifying WA 'WaDisableL3Bank2xClockGate for vlv

Akshu Agrawal (1):
      drm/exynos: fimd: clear channel before enabling iommu

Alex Deucher (13):
      drm/radeon: add a i2c bus mutex
      vgaswitcheroo: switch the mux to the igp on power down when runpm is enabled
      drm/radeon: fix typo in radeon_connector_is_dp12_capable()
      drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices
      drm/radeon/atom: fix dithering on certain panels
      drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi
      drm/radeon: use hw cts/n values for deep color
      drm/radeon: fix pll setup for hdmi deep color (v7)
      drm/radeon: Setup HDMI_CONTROL for hdmi deep color gcp's (v2)
      drm/radeon: add missing vce init case for hawaii
      drm/radeon: add query for number of active CUs
      Revert "drm/radeon: use variable UVD clocks"
      drm/radeon/dpm: powertune updates for SI

Alexandre Courbot (10):
      drm/ttm: fix kerneldoc of ttm_bo_create
      drm/nouveau/bar: only ioremap BAR3 if it exists
      drm/nvc0/bar: support chips without BAR3
      drm/nouveau/ibus: add GK20A support
      drm/nouveau/fb: add GK20A support
      drm/nouveau/fifo: add GK20A support
      drm/nouveau/graph: enable when using external fw
      drm/nouveau/graph: pad firmware code at load time
      drm/nouveau/graph: add GK20A support
      drm/nouveau/device: support for probing GK20A

Andrew Bresticker (1):
      drm/exynos: dp: support hotplug detection via GPIO

Andrzej Hajda (15):
      drm: make mode_valid callback optional
      drm/exynos: separate dpi from fimd
      drm/exynos/ipp: fix get_property IOCTL
      drm/exynos/ipp: correct ipp_id field initialization
      drm/exynos/ipp: simplify property list allocation
      drm/exynos/fimc: simplify pre-scaler ratio calculation
      drm/exynos/fimc: simplify irq masking function
      drm/exynos/fimc: replace hw access macros with functions
      drm/exynos/fimc: replace mutex by spinlock
      drm/exynos/fimc: simplify and rename fimc_dst_get_buf_seq
      drm/exynos: remove redundant mutex_unlock
      drm/exynos: add fimd dependency to fimd related encoders
      drm/exynos: ipp: remove description of non-existing field
      drm/exynos/fimd: allow multiplatform configuration
      drm/panel: ld9040: add power control sequence

Ben Skeggs (48):
      drm/nouveau/core: punt all object state change messages to trace level
      drm/gk104/gpio: fix incorrect interrupt register usage
      drm/nouveau/disp/dp: support aux read interval during link training
      drm/nouveau/disp/dp: support training pattern 3
      drm/nv50-/kms: wait for enough ring space in crtc_prepare()
      drm/nouveau/core: allow event source to handle multiple event types per index
      drm/nouveau/disp/dp: support postcursor in link training
      drm/nouveau/disp/dp: support training to highest rate, rather than a target
      drm/nouveau/gpio: use indirect pointer to base class definition
      drm/nouveau/gpio: split g92 class from nv50
      drm/nouveau/gpio: split "toggled" interrupt into "went high" / "went low"
      drm/nouveau/gpio: move on-reset intr disable-and-ack to common code
      drm/nouveau/gpio: use base constructor for all implementations
      drm/nouveau/gpio: send separate event types for high/low transitions
      drm/nv50-/mc: also pass PMGR interrupts onto I2C subdev
      drm/nouveau/i2c: properly hand aux reply back to caller, and only retry on defer
      drm/nouveau/i2c: remove unnecessary i2c_set_adapdata()
      drm/nouveau/i2c: start hiding subdev-internal interfaces
      drm/nouveau/i2c: add interfaces to support handling aux channel interrupts
      drm/g94/i2c: add aux channel interrupt driver
      drm/gk104/i2c: add aux channel interrupt driver
      drm/nouveau/i2c: balance port acquire/release
      drm/nouveau/i2c: introduce locking at a per-port level
      drm/nouveau/i2c/anx9805: add debugging to aux transactions
      drm/nouveau/disp: nothing to see here
      drm/nouveau/bios: extend connector table parsing
      drm/nouveau/disp: add internal representaion of output paths and connectors
      drm/nouveau: use connector events for HPD instead of GPIO watching
      drm/nouveau/disp/dp: create subclass for dp outputs
      drm/nouveau/disp/dp: maintain receiver caps in response to hpd signal
      drm/nv50/disp: start removing direct vbios parsing from supervisor
      drm/gf119/disp: start removing direct vbios parsing from supervisor
      drm/nouveau/disp/dp: make use of existing output data for link training
      drm/nv50/disp: train PIOR-attached DP from second supervisor
      drm/nouveau/disp/dp: split link config/power into two steps
      drm/g94-/disp: bash and wait for something after changing lane power regs
      drm/nouveau/disp/dp: maintain link in response to hpd signal
      drm/g94-/disp: add method to power-off dp lanes
      drm/nouveau: register a drm_dp_aux channel for each dp connector
      drm/nouveau/dp: fix support for dpms
      drm/nouveau/bios/dp: parse lane postcursor data
      drm/g94-/disp/dp: take max pullup value across all lanes
      drm/nouveau/disp/dp: make use of postcursor when its available
      drm/gf119-/disp: fix debug output on update failure
      drm/nv50-: prepare for attaching a SOR to multiple heads
      drm/nv50-: trigger update after all connectors disabled
      drm/nouveau/dp: probe dpcd to determine connectedness
      drm/nouveau/disp/dp: fix tmds passthrough on dp connector

Ben Widawsky (22):
      drm/i915: Split out GTT specific header file
      drm/i915: Allow full PPGTT with param override
      drm/i915/bdw: Set initial rps freq to RP1
      drm/i915/bdw: Extract rp_state_caps logic
      drm/i915/bdw: RPS frequency bits are the same as HSW
      drm/i915/bdw: Expand FADD to 64bit
      drm/i915: Invariably invalidate before ctx switch
      drm/i915: Unref context on failed eb_create
      drm/i915: Dump the whole context object.
      drm/i915/bdw: Add 42ms delay for IPS disable
      drm/i915/bdw: Add WT caching ability
      drm/i915/bdw: enable eDRAM.
      drm/i915/bdw: Disable idle DOP clock gating
      drm/i915: Move semaphore specific ring members to struct
      drm/i915: Virtualize the ringbuffer signal func
      drm/i915: Move ring_begin to signal()
      drm/i915: Support 64b execbuf
      drm/i915: Support 64b relocations
      drm/i915: Use topdown allocation for PPGTT PDEs on gen6/7
      drm/i915: Make aliasing a 2nd class VM
      drm/i915/bdw: Implement a basic PM interrupt handler
      drm/i915/bdw: Only use 2g GGTT for 32b platforms

Benoit Taine (1):
      drm/edid: Use kmemdup instead of kmalloc + memcpy

Brad Volkin (16):
      drm/i915: Initial command parser table definitions
      drm/i915: Reject privileged commands
      drm/i915: Allow some privileged commands from master
      drm/i915: Add register whitelists for mesa
      drm/i915: Add register whitelist for DRM master
      drm/i915: Enable register whitelist checks
      drm/i915: Reject commands that explicitly generate interrupts
      drm/i915: Enable PPGTT command parser checks
      drm/i915: Reject commands that would store to global HWS page
      drm/i915: Add a CMD_PARSER_VERSION getparam
      drm/i915: Enable command parsing by default
      drm/i915: BUG_ON() when cmd/reg tables are not sorted
      drm/i915: Refactor cmd parser checks into a function
      drm/i915: Track OACONTROL register enable/disable during parsing
      drm/i915: Add more registers to the whitelist for mesa
      drm/i915: Use hash tables for the command parser

Chon Ming Lee (8):
      drm/i915/chv: Add DPIO offset for Cherryview. v3
      drm/i915/chv: Update Cherryview DPLL changes to support Port D. v2
      drm/i915/chv: Add vlv_pipe_to_channel
      drm/i915/chv: Trigger phy common lane reset
      drm/i915/chv: find the best divisor for the target clock v4
      drm/i915/chv: Add update and enable pll for Cherryview
      drm/i915/chv: Add phy supports for Cherryview
      drm/i915/chv: Pipe select change for DP and HDMI

Chris Wilson (29):
      drm/i915: Rename GFX_TLB_INVALIDATE_ALWAYS
      drm/i915: Add PM interrupt details and RPS thresholds to debugfs
      drm/i915: Move all ring resets before setting the HWS page
      drm/i915: dma_buf_vunmap is presumed not to fail, don't let it
      drm/i915: Replace hardcoded cacheline size with macro
      drm/i915: Preserve ring buffers objects across resume
      drm/i915: Allow the module to load even if we fail to setup rings
      drm/i915: Mark device as wedged if we fail to resume
      drm/i915: Include a little more information about why ring init fails
      drm/i915: Validate BDB section before reading
      drm/i915: Validate VBT header before trusting it
      lib: Export interval_tree
      drm/i915: Do not call retire_requests from wait_for_rendering
      drm/i915: Avoid NULL ctx->obj dereference in debugfs/i915_context_info
      drm/i915: Improve fallback ring waiting
      drm/i915: Flush request queue when waiting for ring space
      drm/i915: Use the connector name in fbdev debug messages
      drm/i915: Introduce mapping of user pages into video memory (userptr) ioctl
      drm/i915: Only unpin the default ctx object if it exists
      drm/i915: Retire requests before creating a new one
      drm/i915: Translate ENOSPC from shmem_get_page() to ENOMEM
      drm/i915: Include bound and active pages in the count of shrinkable objects
      drm/i915: Refactor common lock handling between shrinker count/scan
      drm/i915: Invalidate our pages under memory pressure
      drm/i915: Implement an oom-notifier for last resort shrinking
      drm/i915: Only discard backing storage on releasing the last ref
      drm/i915: Hold CRTC lock whilst freezing the planes
      drm/i915: Silence the WARN if the user tries to GTT mmap an incoherent object
      drm/i915: Always apply cursor width changes

Christian Engelmayer (1):
      drm: qxl: Remove unused device pointer

Christian König (19):
      drm/radeon: add large PTE support for NI, SI and CIK v5
      drm/radeon: add proper support for RADEON_VM_BLOCK_SIZE v2
      drm/radeon: remove (pre|post)_page_flip callbacks
      drm/radeon: remove drm_vblank_get|put from pflip handling
      drm/radeon: split page flip and pending callback
      drm/radeon: separate vblank and pflip crtc handling
      drm/radeon: rework page flip handling v3
      drm/radeon: add define for flags used in R600+ GTT
      drm/radeon: optimize SI VM handling
      drm/radeon: optimize CIK VM handling v2
      drm/radeon: rework page flip handling v4
      drm/radeon: use lower_32_bits where appropriate
      drm/radeon: stop poisoning the GART TLB
      drm/radeon: remove range check from *_gart_set_page
      drm/radeon: use the SDMA on for buffer moves on CIK again
      drm/radeon: rename alt_domain to allowed_domains
      drm/radeon: make VM size a module parameter (v2)
      drm/radeon: make vm_block_size a module parameter
      drm/radeon: add debugfs file to trigger GPU reset

Christoph Jaeger (1):
      drm/i915: drop __FUNCTION__ as argument to DRM_DEBUG_KMS

Damien Lespiau (22):
      drm/i915: Don't store the max cursor width/height in the crtc
      drm/i915: Hide vlv_force_wake_{get, put}() in intel_uncore.c
      drm/i915: Hide the per forcewake-engine register ranges
      drm/i915: Use a macro to express the range of valid gens for reg_read
      drm/i915: Protect the argument expansion in LRI and SRM macros
      drm/i915/bdw: Provide a gen8 version of SRM
      drm/i915/bdw: Use the GEN8 SRM when qeueing a flip
      drm/i915: Rename GEN8_PIPE_FLIP_DONE to PRIMARY_FLIP_DONE
      drm/i915: Remove misleading debug message
      drm/i915: Remove spurious semicolons
      drm/i915/chv: Implement stolen memory size detection
      x86/gpu: Implement stolen memory size early quirk for CHV
      drm/i915: Don't cast void* pointers
      drm/i915: Use ilk_wm_max_level() in latency debugfs files
      drm/i915: Introduce a for_each_intel_crtc() macro
      drm/i915: Use for_each_intel_crtc() when iterating through intel_crtcs
      drm/i915: Introduce a for_each_crtc() macro
      drm/i915: Use for_each_crtc() when iterating through the CRTCs
      drm/doc: Fix nouveau typo
      drm/doc: Add the "type" plane property to the list of properties
      drm: Remove spurious ';'
      drm: Remove DRM_ARRAY_SIZE() for ARRAY_SIZE()

Dan Carpenter (1):
      drm/panel: s6e8aa0: silence array overflow warning

Daniel Kurtz (3):
      drm/exynos/fbdev: don't set fix.smem/mmio_{start,len}
      drm/exynos/fbdev: don't set mode_config.fb_base
      drm/exynos: hdmi: remove unnecessary memset

Daniel Thompson (1):
      drm: Add 800x600 (SVGA) screen resolution to the built-in EDIDs

Daniel Vetter (116):
      drm/i915: Add FIXME for bdw semaphore detection in hancheck
      drm/i915: make semaphore signaller detection more robust
      drm/i915: Deprecate UMS harder
      drm/i915: Add debug module option for VTd validation
      drm/i915: dmesg output for VT-d testing
      Merge remote-tracking branch 'airlied/drm-next' into HEAD
      Revert "drm/i915: fix infinite loop at gen6_update_ring_freq"
      drm/i915: Don't set the 8to6 dither flag when not scaling
      drm/i915: Don't vblank wait on ilk-ivb after pipe enable
      drm/i915: Remove vblank wait from haswell_write_eld
      drm/plane_helper: don't disable plane in destroy function
      drm/crtc-helper: gc usless connector loop in disable_unused_functions
      drm/irq: simplify irq checks in drm_wait_vblank
      drm/pci: fold in irq_by_busid support
      drm/irq: drm_control is a legacy ioctl, so pci devices only
      drm/irq: remove cargo-culted locking from irq_install/uninstall
      drm: remove drm_dev_to_irq from drivers
      drm: kill drm_bus->bus_type
      drm/mgag200: Remove unecessary NULL check in bo_unref
      drm/mgag200: Remove unecessary NULL check in gem_free
      drm/cirrus: Remove unnecessary NULL check in bo_unref
      drm/cirrus: Remove unecessary NULL check in gem_free
      drm/ast: Remove unnecessary NULL check in bo_unref
      drm/ast: Remove unecessary NULL check in gem_free
      drm/via: Remove unecessary NULL check
      drm/udl: Initialize ret in udl_driver_load
      drm/bochs: Remove unnecessary NULL check in bo_unref
      drm/bochs: Remove unecessary NULL check in gem_free
      drm/i2c/tda998x: Fix signed overflow issue
      drm: Fix error handling in drm_master_create
      drm: Rip out totally bogus vga_switcheroo->can_switch locking
      drm: rename dev->count_lock to dev->buf_lock
      drm/irq: track the irq installed in drm_irq_install in dev->irq
      drm/irq: Look up the pci irq directly in the drm_control ioctl
      drm: pass the irq explicitly to drm_irq_install
      drm: remove bus->get_irq implementations
      drm: inline drm_pci_set_unique
      drm: rip out dev->devname
      drm: remove drm_bus->get_name
      drm: Remove dev->kdriver
      drm/<drivers>: don't set driver->dev_priv_size to 0
      drm: Simplify fb refcounting rules around ->update_plane
      drm: Handle ->disable_plane failures correctly
      drm/i915: Catch abuse of I915_EXEC_GEN7_SOL_RESET
      drm/i915: Catch abuse of I915_EXEC_CONSTANTS_*
      drm/i915: Catch dirt in unused execbuffer fields
      drm/i915: Integrate cmd parser kerneldoc
      drm/i915: Make encoder->mode_set callbacks optional
      drm/i915/dvo: Remove ->mode_set callback
      drm/i915/tv: extract set_tv_mode_timings
      drm/i915/tv: extract set_color_conversion
      drm/i915/tv: De-magic device check
      drm/i915/tv: Rip out pipe-disabling nonsense from ->mode_set
      drm/i915/tv: Remove ->mode_set callback
      drm/i915/crt: Remove ->mode_set callback
      drm/i915/sdvo: Remove ->mode_set callback
      drm/i915: Drop unecessary casts in i915_irq.c
      drm/i915: WARN_ON fence pin leaks
      drm/i915: Work-around garbage DR4 from UXA
      drm/i915: use dev_priv directly in i915_driver_unload
      drm/i915: Don't drop pinned fences
      drm/i915: Only do gtt cleanup in vma_unbind for the global vma
      drm/i915/hdmi: Enable hdmi mode on g4x, too
      drm/i915: Track hdmi mode in the pipe config
      drm/i915/sdvo: Use pipe_config->limited_color_range consistently
      drm/i915: state readout and cross checking for limited_color_range
      drm/i915/sdvo: use config->has_hdmi_sink
      drm/i915: Simplify audio handling on DDI ports
      drm/i915: Track has_audio in the pipe config
      drm/i915/dp: Move port A pll setup to g4x_pre_enable_dp
      drm/i915/dp: Remove ->mode_set callback
      drm/i915/hdmi: Remove redundant IS_VLV checks
      drm/i915/hdmi: Remove ->mode_set callback
      drm/i915/lvds: Remove ->mode_set callback
      drm/i915/ddi: Remove ->mode_set callback
      drm/i915/dsi: Remove ->mode_set callback
      drm/i915: Stop calling encoder->mode_set
      drm/i915: Make ->update_primary_plane infallible
      drm/i915: More cargo-culted locking for intel_update_fbc
      drm/i915: Sprinkle intel_edp_psr_update over crtc_enable/disable
      drm/i915: Inline set_base into crtc_mode_set
      drm/i915: Move fb pinning into __intel_set_mode
      drm/i915: Don't die in wait_for_pending_flips
      drm/i915: Shovel hw setup code out of i9xx_crtc_mode_set
      drm/i915: Move lowfreq_avail around a bit in ilk/hsw_crtc_mode_set
      drm/i915: Shovel hw setup code out of ilk_crtc_mode_set
      drm/i915: Shovel hw setup code out of hsw_crtc_mode_set
      drm/i915: Extract i9xx_set_pll_dividers
      drm/i915: Extract vlv_prepare_pll
      drm/i915: Only update shared dpll state when needed
      drm/i915: Extract intel_prepare_shared_dpll
      drm/i915: s/ironlake_/intel_ for the enable_share_dpll function
      drm/i915: Drop now misleading DDI comment from dp_link_down
      drm/i915: Remove drm_vblank_pre/post_modeset calls
      drm/doc: Discourage usage of MODESET_CTL ioctl
      drm/irq: kerneldoc polish
      drm/irq: Add kms-native crtc interface functions
      drm/i915: Use new kms-native vblank functions
      drm/i915: rip our vblank reset hacks for runtime PM
      drm/i915: Accurately initialize fifo underrun state on gmch platforms
      Merge branch 'topic/drm-vblank-rework' into drm-intel-next-queued
      drm/irq: Coding style fix
      drm/i915: move bsd dispatch index somewhere better
      MAINTAINERS: Shovel drivers/gpu/vga/* to Dave
      drm/dp-helper: Deprecate old i2c-over-dp_aux heleprs
      drm: Split connection_mutex out of mode_config.mutex (v3)
      drm: Move plane helpers into drm_kms_helper.ko
      drm/i915: Add fifo underrun reporting state to debugfs
      drm/i915: Fix up fifo underrun tracking, take N
      drm/i915: Disable gpu reset on i965g/gm
      drm/i915: Inline ilk/gen8_irq_reset
      drm/i915: Improve irq handling after gpu resets
      drm/i915: Extract gen8_gt_irq_reset
      drm/i915: Nuke pipe A quirk on i830M
      drm: Fix getconnector connection_mutex locking
      drm: Fix getconnector connection_mutex locking

Dave Airlie (30):
      Merge tag 'drm-intel-next-2014-04-16' of git://anongit.freedesktop.org/drm-intel into drm-next
      drm: try harder to avoid regression when merging mode bits
      Merge branch 'drm-coverity-fixes' of git://people.freedesktop.org/~danvet/drm into drm-next
      Merge branch 'drm-init-cleanup' of git://people.freedesktop.org/~danvet/drm into drm-next
      drm: fix memory leak around mode_group (v2)
      Merge tag 'topic/core-stuff-2014-05-05' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'drm-intel-next-2014-05-06' of git://anongit.freedesktop.org/drm-intel into drm-next
      drm/ast: add widescreen + rb modes from X.org driver (v2)
      drm/ast: add AST 2400 support.
      drm/ast: resync the dram post code with upstream
      drm/ast: rename the mindwm/moutdwm and deinline them
      drm/ast: initial DP501 support (v0.2)
      Merge branch 'ast-updates' of ssh://people.freedesktop.org/~/linux into drm-next
      drm/dp_helper: add defines for DP 1.2 and MST support. (v2)
      drm: add DP MST encoder type
      Merge tag 'drm-intel-next-2014-05-23' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge branch 'drm-next-3.16' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Revert "drm/radeon: rework page flip handling v3"
      Merge branch 'msm-next' of git://people.freedesktop.org/~robclark/linux into drm-next
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge tag 'topic/core-stuff-2014-06-02' of git://anongit.freedesktop.org/drm-intel into drm-next
      drm/dp: add a hw mutex around the transfer functions. (v2)
      Merge commit '9e9a928eed8796a0a1aaed7e0b676db86ba84594' into drm-next
      Merge tag 'drm-intel-fixes-2014-06-06' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'drm/tegra/for-3.16-rc1' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge tag 'drm/panel/for-3.16-rc1' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge branch 'drm-next-3.16' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'topic/ipu-destaging' of git://git.pengutronix.de/git/pza/linux into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next

David Herrmann (2):
      drm/gem: replace misleading comment
      drm/armada: use shmem helpers if possible

David Mansfield (1):
      drm/qxl: use surface_id 0 for primary surface on all monitors

Deepak S (2):
      drm/i915: Match debugfs interface name to new RPS naming
      drm/i915: Enable PM Interrupts target via Display Interface.

Egbert Eich (1):
      drm/i915/SDVO: For sysfs link put directory and target in correct order

Ilia Mirkin (3):
      drm/nouveau/fb: default NvMemExec to on, turning it off is used for debugging only
      drm/nouveau/clk: allow end-user reclocking for nv40, nvaa, and nve0 clock types
      drm/gk208/gr: add missing registers to grctx init

Ilija Hadzic (1):
      drm: remove unused argument from drm_open_helper

Imre Deak (39):
      drm/i915: vlv: cache current CD clock rate
      drm/i915: vlv: get power domain for eDP vdd
      drm/i915: vlv: clean up GTLC wake control/status register macros
      drm/i915: vlv: clear master interrupt flag when disabling interrupts
      drm/i915: vlv: add RC6 residency counters
      drm/i915: fix the RC6 status debug print
      drm/i915: remove the i915_dpio debugfs entry
      drm/i915: get a runtime PM ref for debugfs entries where needed
      drm/i915: move getting struct_mutex lower in the callstack during GPU reset
      drm/i915: get a runtime PM ref for the deferred GT powersave enabling
      drm/i915: get a runtime PM ref for the deferred GPU reset work
      drm/i915: gen2: move error capture of IER to its correct place
      drm/i915: add missing error capturing of the PIPESTAT reg
      drm/i915: vlv: check port power domain instead of only D0 for eDP VDD on
      drm/i915: fix unbalanced GT powersave enable / disable calls
      drm/i915: sanitize enable_rc6 option
      drm/i915: disable runtime PM if RC6 is disabled
      drm/i915: make runtime PM interrupt enable/disable platform independent
      drm/i915: factor out gen6_update_ring_freq
      drm/i915: make runtime PM swizzling/ring_freq init platform independent
      drm/i915: reinit GT power save during resume
      drm/i915: vlv: setup RPS min/max frequencies once during init time
      drm/i915: vlv: factor out vlv_force_gfx_clock and check for pending force-off
      drm/i915: vlv: increase timeout when forcing on the GFX clock
      drm/i915: remove extraneous VGA power domain put calls
      drm/i915: bdw: fix RC6 enabled status reporting and disable runtime PM
      drm/i915: vlv: init only needed state during early power well enabling
      drm/i915: add various missing GTI/Gunit register definitions
      drm/i915: propagate the error code from runtime PM callbacks
      drm/i915: vlv: add runtime PM support
      drm/i915: vlv: enable runtime PM
      drm/i915: rename IOSF sideband opcodes according to the spec
      drm/i915: vlv/chv: fix DSI sideband register accessing
      drm/i915: add missing unregister_oom_notifier to the error/unload path
      drm/i915: remove user GTT mappings early during runtime suspend
      drm/i915: fix possible RPM ref leaking during RPS disabling
      drm/i915: disable GT power saving early during system suspend
      drm/i915: dsi: fix pipe-off timeout due to port vs. pipe disable ordering
      drm/i915: fix display power sw state reporting

Inki Dae (8):
      drm/exynos: modify goto labels to meaningful names
      drm/exynos: add component framework support
      drm/exynos: dpi: fix hotplug fail issue
      drm/exynos: fix comment to exynos_drm_device_subdrv_prove call
      drm/exynos: remove unnecessary runtime pm interfaces
      drm/exynos: dsi: remove unnecessary pm interfaces
      drm/exynos: hdmi: consider legacy dt binding
      drm/exynos: consider deferred probe case

Jan Moskyto Matejka (1):
      Revert "drm/i915: fix build warning on 32-bit (v2)"

Jani Nikula (14):
      drm/i915: drop the typedef for drm_i915_private_t
      drm/i915: fix command parser debug print format mismatches
      drm/i915: shuffle panel code
      drm: store connector name in connector struct (v2)
      drm: store encoder name in encoder struct
      staging: imx-drm-core: replace drm_get_connector_name() with direct name field use
      drm/i915: replace drm_get_connector_name() with direct name field use
      drm/nouveau: replace drm_get_connector_name() with direct name field use
      drm/radeon: replace drm_get_connector_name() with direct name field use
      drm: replace drm_get_connector_name() with direct name field use
      drm/i915: replace drm_get_encoder_name() with direct name field use
      drm: replace drm_get_encoder_name() with direct name field use
      drm: drop drm_get_connector_name() and drm_get_encoder_name()
      drm/i915: tell the user if both KMS and UMS are disabled

Jean Delvare (3):
      drm/rcar-du: Add run-time dependencies
      drm/shmobile: Add run-time dependencies
      drm/exynos: Fix PTN3460 dependency

Jesse Barnes (14):
      drm/i915: warn when a vblank wait times out
      drm/i915/vlv: write the port field in the per-pipe DIP control reg
      drm/i915/vlv: disable AVI infoframe emission when writing infoframes
      drm/i915: enable HDMI mode on VLV when an HDMI sink is detected
      drm/i915: move infoframe setting to after pll enable v3
      drm/i915: remove unexplained vblank wait in the DP off code
      drm/i915: drop encoder hot_plug calls at resume
      drm/i915/vlv: assert and de-assert sideband reset at boot and resume v3
      drm/i915/vlv: drop power well enable in uncore_sanitize
      drm/i915/vlv: move CRI refclk enable into __vlv_set_power_well
      drm/i915/vlv: re-order power wells so DPIO common comes after TX
      drm/i915/vlv: move DPIO common reset de-assert into __vlv_set_power_well
      drm/i915/vlv: add pll assertion when disabling DPIO common well
      drm/i915: use VBT to determine whether to enumerate the VGA port

Jingoo Han (6):
      drm/exynos: fb: make local symbol static
      drm/exynos: hdmi: make local symbols static
      drm/exynos: dp: remove unnecessary OOM messages
      drm/exynos: rotator: add missing braces
      drm/exynos: dp: Use DPCD defines of drm_dp_helper.h
      drm/exynos: remove unnecessary exynos_hdmi.h file

John Rowley (2):
      drm/nvf1/device: add support for 0xf1 (gk110b)
      drm/nvf0/device: enable video decoding engines on gk110/gk208

Joonyoung Shim (1):
      drm/exynos: remove DRIVER_HAVE_IRQ feature

Kenneth Graunke (1):
      drm/i915: Add OACONTROL to the command parser register whitelist.

Mario Kleiner (8):
      drm/radeon: Limit hdmi deep color bit depth to 12 bpc.
      drm/edid: Parse and handle HDMI deep color modes.
      drm/edid: Add quirk for Sony PVM-2541A to get 12 bpc hdmi deep color.
      drm/edid: Store all supported hdmi deep color modes in drm_display_info
      drm/radeon: hdmi deep color modes must obey clock limit of sink.
      drm/nouveau/disp/nv04-nv40: abort scanoutpos query on vga analog.
      drm/nv50-/mc: fix kms pageflip events by reordering irq handling order.
      drm/nouveau/kms/nv04-nv40: fix pageflip events via special case.

Martin Peres (3):
      drm/nouveau/therm/fan/tach: default to 2 pulses per revolution
      drm/nouveau/i2c: bump the i2c delay for the adt7473
      drm/nouveau/bios: fix a potential NULL deref in the PROM shadowing function

Masanari Iida (1):
      Documentation: fix typos in drm docbook

Matt Roper (3):
      drm/plane-helper: Fix primary plane scaling check
      drm: Check CRTC compatibility in setplane
      drm/plane-helper: Add drm_plane_helper_check_update() (v3)

Michel Dänzer (1):
      drm/radeon: Move fb update from radeon_flip_work_func to radeon_crtc_page_flip

Michele CURTI (2):
      drm/radeon: use NULL instead of zero in object functions
      drm/radeon: use NULL instead of zero in clearstate headers

Mika Kuoppala (8):
      drm/i915: add flags to i915_ring_stop
      drm/i915: add render state initialization
      drm/i915: add null render states for gen6, gen7 and gen8
      drm/i915: Bail out early on gen6_signal if no semaphores
      drm/i915: Fix rc6 options debug info
      drm/i915: Enable rc6 with bdw
      drm/i915: Be careful with non-disp bit in PMINTRMSK
      drm/i915: Add null state batch to active list

Oscar Mateo (8):
      drm/i915: Ringbuffer signal func for the second BSD ring
      drm/i915: Gracefully handle obj not bound to GGTT in is_pin_display
      drm/i915: s/intel_ring_buffer/intel_engine_cs
      drm/i915: Split the ringbuffers from the rings (1/3)
      drm/i915: Split the ringbuffers from the rings (2/3)
      drm/i915: Split the ringbuffers from the rings (3/3)
      drm/i915: s/i915_hw_context/intel_context
      drm/i915: Kill private_default_ctx off

Paul Taysom (1):
      drm/exynos: check for null pointers in error handling

Paulo Zanoni (29):
      drm/i915: add GEN5_IRQ_INIT macro
      drm/i915: also use GEN5_IRQ_INIT with south display interrupts
      drm/i915: use GEN8_IRQ_INIT on GEN5
      drm/i915: add GEN5_IRQ_FINI
      drm/i915: don't forget to uninstall the PM IRQs
      drm/i915: properly clear IIR at irq_uninstall on Gen5+
      drm/i915: add GEN5_IRQ_INIT
      drm/i915: check if IIR is still zero at postinstall on Gen5+
      drm/i915: fix SERR_INT init/reset code
      drm/i915: fix GEN7_ERR_INT init/reset code
      drm/i915: fix open coded gen5_gt_irq_preinstall
      drm/i915: extract ibx_irq_uninstall
      drm/i915: call ibx_irq_uninstall from gen8_irq_uninstall
      drm/i915: enable SDEIER later
      drm/i915: remove ibx_irq_uninstall
      drm/i915: add missing intel_hpd_irq_uninstall
      drm/i915: add ironlake_irq_reset
      drm/i915: add gen8_irq_reset
      drm/i915: only enable HWSTAM interrupts on postinstall on ILK+
      drm/i915: kill dev_priv->pm.regsave
      drm/i915: add gen-specific runtime suspend/resume functions
      drm/i915: add SNB runtime PM support
      drm/i915: remove HAS_PC8 check
      drm/i915: BDW needs D_COMP writes through MCHBAR
      drm/i915: add BDW runtime PM support
      drm/i915: only check for irqs_disabled when disabling LCPLL
      drm/i915: fix infinite loop at gen6_update_ring_freq
      drm/i915: don't read HSW_AUD_PIN_ELD_CP_VLD when the power well is off
      drm/i915: grab the audio power domain when enabling audio on HSW+

Peter Hurley (1):
      drm: Use correct spinlock flavor in drm_vblank_get()

Philipp Zabel (6):
      gpu: ipu-v3: Move i.MX IPUv3 core driver out of staging
      gpu: ipu-v3: Add SMFC code
      gpu: ipu-v3: Add ipu_idmac_get_current_buffer function
      gpu: ipu-v3: Add CSI and SMFC module enable wrappers
      gpu: ipu-v3: Register the CSI modules
      drm/panel: Add support for EDT ETM0700G0DH6 and ET070080DH6 panels

Pradeep Bhat (3):
      drm/i915: Adding VBT fields to support eDP DRRS feature
      drm/i915: Parse EDID probed modes for DRRS support
      drm/i915: Add support for DRRS to switch RR

Rafael Barbalho (4):
      drm/i915: Fix framecount offset
      drm/i915/chv: Flush caches when programming page tables
      drm/i915/chv: Implement WaDisableSamplerPowerBypass for CHV
      drm/i915/chv: Add CHV display support

Rafa³ Mi³ecki (4):
      drm/radeon/hdmi: use separated file for DCE 3.1/3.2 code
      drm/radeon/hdmi: DCE3: clean ACR control
      drm/radeon/hdmi: DCE2: update setmode
      drm/radeon/hdmi: DCE2: simplify audio workaround

Rahul Sharma (8):
      drm/exynos: replace hdmi reset with hdmi disable
      drm/exynos: remove unnecessary read for phy configuration values
      drm/exynos: add support for apb mapped phys in hdmi driver
      drm/exynos: enable support for exynos5420 hdmi device
      drm/exynos: allocate non-contigous buffers when iommu is enabled
      drm/exynos: use regmap interface to set hdmiphy control bit in pmu
      drm/exynos: use 4WORD dma burst length for small fbs
      drm/exynos: remove hardware overlays disable from fimd probe

Rob Clark (16):
      drm: fix typo
      drm/msm/mdp5: fix crash in error/unload paths
      drm/msm/hdmi: use gpio and HPD polling
      drm/msm: update for ARCH_MSM -> ARCH_QCOM
      drm/msm: add rd logging debugfs
      drm/msm: add perf logging debugfs
      drm/msm: remove redundant private plane cleanup
      drm/msm/mdp5: fix error return value
      drm/msm: use correct gfp flag for vram allocation
      drm: helpers to find mode objects
      drm: add extended property types
      drm: add object property type
      drm: add signed-range property type
      drm: spiff out FB refcnting traces
      drm: convert crtc and connection_mutex to ww_mutex (v5)
      drm: add drm_fb_helper_restore_fbdev_mode_unlocked()

Robin Schroer (1):
      drivers/gpu/drm/i915/intel_display: coding style fixes

Rodrigo Vivi (1):
      drm/i915: BDW: Adding missing cursor offsets.

Ross Zwisler (1):
      drm: Missed clflushopt in drm_clflush_virt_range

Sachin Kamat (5):
      drm/exynos: Staticize exynos_dpi_of_find_panel_node
      drm/exynos: Remove duplicate inclusion of i2c.h
      drm/exynos: Staticize local symbols in exynos_hdmi.c
      drm/exynos: Fix checkpatch warning in exynos_dp_reg.c
      drm/exynos: Use PTR_ERR_OR_ZERO in exynos_dp_core.c

Sagar Kamble (1):
      Documentation: drm: describing drm properties exposed by various drivers

Sean Paul (3):
      drm/exynos: Don't reset hdmiphy on hdmi off
      drm/exynos: Debounce HDMI hotplug interrupts
      drm/exynos: Read hpd gpio in is_connected callback

Seung-Woo Kim (1):
      drm/exynos: hdmi: remove unnecessary dedicated i2c drivers

Shashank Sharma (1):
      drm/i915: Add MIPI mmio reg base

Shirish S (3):
      drm/exynos: update phy settings for RB resolutions
      drm/exynos: restore core HDMI settings
      drm/exynos: add hdmiphy power on/off sequence

Shobhit Kumar (14):
      drm/i915: Program Rcomp and band gap reset everytime we resume from power gate
      drm/i915: Enable MIPI port before the plane and pipe enable
      drm/i915: Disable DPOunit clock gating
      drm/i915: Parameterize the Clockstop and escape_clk_div
      drm/i915: Panel commands can be sent only when clock is in LP11
      drm/i915: Send DPI command explicitely in LP mode
      drm/i915: Enable RANDOM resolution support for MIPI panels
      drm/i915: Add parsing support for new MIPI blocks in VBT
      drm/i915: Code cleanup patch to fix checkpatch errors
      drm/i915: Correct MIPI operation mode as per expected values from VBT
      drm/i915: MIPI init count programming as generic parameter
      drm/i915: MIPI PPS delays added
      drm/i915: Add support for Generic MIPI panel driver
      drm/i915: Detect if MIPI panel based on VBT and initialize only if present

Stefan Agner (1):
      drm/panel: add support for EDT ET057090DHU panel

Stéphane Marchesin (4):
      drm/tegra: sor - Remove pixel clock rounding
      drm/tegra: sor - Fix copy/paste error
      drm/tegra: sor - Change power down ordering
      drm/panel: simple - Add AUO B133XTN01 panel support

Takashi Iwai (3):
      drm/exynos: Fix double locks at PM resume
      drm/ast: Fix double lock at PM resume
      drm/exynos: Fix double locks at PM resume

Thierry Reding (57):
      drm: Try to acquire modeset lock on panic or sysrq
      drm/edid: Drop revision argument for drm_mode_std()
      drm/edid: Cleanup kerneldoc
      drm/fb: Fix typos
      drm: Fixup flip-work kerneldoc
      drm/dp: Fix typo in comment
      drm: Fix indentation of closing brace
      drm: Make drm_crtc_helper_disable() return void
      drm/dp: Add missing kernel-doc
      drm/plane: Fix sparse warnings
      drm/plane: Fix a couple of checkpatch warnings
      drm/dsi: Support device shutdown
      drm/panel: simple - Disable panel on shutdown
      drm/tegra: Cleanup header file
      drm/tegra: dc - Add YUYV support
      drm/tegra: sor - Add CRC debugfs support
      drm/tegra: dc - Rename INVERT_V to V_DIRECTION
      drm/tegra: dc - Reshuffle code to get rid of prototypes
      drm/tegra: dc - Do not touch power control register
      drm/tegra: dc - Use proper H/V ref-to-sync values
      drm/tegra: hdmi - Add connector supply support
      drm/tegra: hdmi - Remove duplicate code
      drm/tegra: hdmi - Reverse regulator enable ordering
      drm/tegra: hdmi - Clean up clock usage
      drm/tegra: hdmi - Use proper power-up sequence
      drm/tegra: hdmi - Disable LVDS mode
      drm/tegra: hdmi - Fix disable sequence
      drm/tegra: dsi - Use internal pixel format
      drm/tegra: dsi - Remove unneeded code
      drm/tegra: dsi - Implement VDD supply support
      drm/tegra: dsi - Initialize proper packet sequences
      drm/tegra: dsi - Add enable guard
      drm/tegra: dsi - Fix typo when disabling controller
      drm/tegra: dsi - Reset controller on driver unload
      drm/tegra: dc - Move around shift clock programming
      drm/tegra: dc - Compute shift clock divider in output drivers
      drm/tegra: dsi - Do not needlessly recompute pclk
      drm/tegra: sor - Protect CRC debugfs against enable state
      drm/tegra: hdmi - Add Tegra124 support
      drm/tegra: gem - Make tegra_bo_import() static
      gpu: host1x: Rename internal functions for clarity
      drm: Introduce drm_dev_set_unique()
      drm: Add device registration documentation
      drm: Document how to register devices without struct drm_bus
      drm/tegra: Remove host1x drm_bus implementation
      drm/tegra: Add hardware cursor support
      drm/tegra: dp - Implement hotplug detection in work queue
      drm/tegra: dp - Mark the connector as hotplug capable
      drm/tegra: sor - Recursively remove debugfs tree
      drm/tegra: sor - Make debugfs setup consistent
      drm/tegra: sor - Don't hardcode link parameters
      drm/tegra: sor - Do not hardcode number of blank symbols
      drm/tegra: sor - Do not hardcode link speed
      drm/tegra: sor - Do not program interlaced mode registers
      drm/tegra: sor - Power on only the necessary lanes
      drm/tegra: sor - Enable only the necessary number of lanes
      drm/tegra: sor - Remove obsolete comment

Vandana Kannan (1):
      drm/edid: Fill PAR in AVI infoframe based on CEA mode list

Ville Syrjälä (102):
      drm/i915: Kill crtc->plane checks from the primary plane update hooks
      drm/i915: Split dp post_disable hooks
      drm/i915: Refactor gmch hpd irq handling
      drm: Make drm_clflush_virt_range() void*
      drm/i915: Implement WaProgramMiArbOnOffAroundMiSetContext:bdw
      drm/i915: Fix debugfs PDP register dump
      drm/i915: Move DP M/N setup from update_pll to mode_set for gmch platforms
      drm/i915: Warn when DPIO read returns 0xffffffff
      drm/i915: Provide a bit more info when pipestat bits are wrong
      drm/i915: Make contexts non-snooped on non-LLC platforms
      drm/i915: Don't read sprite LP2+ registers on ILK/SNB
      drm/i915: Add some more tracked state to intel_pipe_wm
      drm/i915: Skip watermark merging for inactive pipes
      drm/i916: Refactor WM register maximums
      drm/i915/chv: IS_BROADWELL() should not be true for Cherryview
      drm/i915/chv: Add IS_CHERRYVIEW() macro
      drm/i915: Disable/enable planes as the first/last thing during modeset on ILK+
      drm/i915: Fix deadlock during driver init on ILK
      drm/i915: Fix assert_plane warning during FDI link train
      drm/i915: Fix scanout position for real
      drm/i915: Add intel_get_crtc_scanline()
      drm/i915: Make primary_enabled match the actual hardware state
      drm/i915: Make sprite updates atomic
      drm/i915: Perform primary enable/disable atomically with sprite updates
      drm/i915: Add pipe update trace points
      drm/i915: Make sure computed watermarks never overflow the registers
      drm/i915: Merge LP1+ watermarks in safer way
      drm/i915: Remove useless checks from primary enable/disable
      drm/i915/chv: PPAT setup for Cherryview
      drm/i915/chv: Enable aliasing PPGTT for CHV
      drm/i915/chv: Add PIPESTAT register bits for Cherryview
      drm/i915/chv: Add DPFLIPSTAT register bits for Cherryview
      drm/i915/chv: Add display interrupt registers bits for Cherryview
      drm/i915/chv: Add DPINVGTT registers defines for Cherryview
      drm/i915: Convert gmch platforms over to ilk_crtc_{enable, disable}_planes()
      drm/i915/chv: Preliminary interrupt support for Cherryview
      drm/i915/chv: Add Cherryview interrupt registers into debugfs
      drm/i915/chv: Initial clock gating support for Cherryview
      srm/i915/chv: Add Cherryview PCI IDs
      drm/i915/chv: Add DDL register defines for Cherryview
      drm/i915/chv: Add DPLL state readout support
      drm/i915/chv: CHV doesn't have CRT output
      x86/gpu: Sprinkle const, __init and __initconst to stolen memory quirks
      drm/i915: Disable/enable planes as the first/last thing during modeset on gmch platforms
      drm/i915: Kill vblank waits after pipe enable on gmch platforms
      drm/i915: Convert uncleared FIFO underrun message to errors
      drm/i915: Drop bogus comments about display reset
      drm/i915: Fix ILK reset wait
      drm/i915: Fix ILK GPU reset domain bits
      drm/i915/chv: Implement WaDisablePartialInstShootdown:chv
      drm/i915/chv: Implement WaDisableThreadStallDopClockGating:chv
      drm/i915/chv: Implement WaVSRefCountFullforceMissDisable:chv and WaDSRefCountFullforceMissDisable:chv
      drm/i915/chv: Implement WaDisableSemaphoreAndSyncFlipWait:chv
      drm/i915/chv: Implement WaDisableCSUnitClockGating:chv
      drm/i915/chv: Implement WaDisableSDEUnitClockGating:chv
      drm/i915/chv: Add some workaround notes
      drm/i915/chv: Clarify VLV/CHV PIPESTAT bits a bit more
      drrm/i915/chv: Use valleyview_pipestat_irq_handler() for CHV
      drm/i915/chv: Make CHV irq handler loop until all interrupts are consumed
      drm/i915/chv: Configure crtc_mask correctly for CHV
      drm/i915/chv: Fix gmbus for port D
      drm/i915/chv: Add cursor pipe offsets
      drm/i915/chv: Bump num_pipes to 3
      drm/i915/chv: Fix PORT_TO_PIPE for CHV
      drm/i915/chv: Register port D encoders and connectors
      drm/i915/chv: Fix CHV PLL state tracking
      drm/i915/chv: Move data lane deassert to encoder pre_enable
      drm/i915/chv: Turn off dclkp after the PLL has been disabled
      drm/i915/chv: Reset data lanes in encoder .post_disable() hook
      drm/i915/chv: Set soft reset override bit for data lane resets
      drm/i915/chv: Don't use PCS group access reads
      drm/i915/chv: Don't do group access reads from TX lanes either
      drm/i915/chv: Use RMW to toggle swing calc init
      drm/i915/chv: Add a bunch of pre production workarounds
      drm/i915: Drop /** */ comments from i915_reg.h
      drm/i915: Kill RMW from ILK reset code
      drm/i915: Clear GDSR after reset on ILK
      drm: Make the vblank disable timer per-crtc
      drm: Make blocking vblank wait return when the vblank interrupts get disabled
      drm: Add drm_vblank_on()
      drm/i915: Fix mmio vs. CS flip race on ILK+
      drm/i915: Wait for vblank in hsw_enable_ips()
      drm/i915: Drop the excessive vblank waits from modeset codepaths
      drm/i915: Move buffer pinning and ring selection to intel_crtc_page_flip()
      drm/i915: Re-enable vblank irqs for already active pipes
      drm/i915: Add a brief description of the VLV display PHY internals
      drm/i915: Provide DPIO diagrams as docboox tables
      drm/i915: Check for FIFO underuns when disabling reporting on gmch platforms
      drm/i915: Check for FIFO underruns at the end of modeset on gmch
      drm/i915: Simplify the uncleared FIFO underrun detection
      drm/i915: Shuffle fifo underrun disable/enable points for gmch platforms
      drm/i915: Wait for pending page flips before enabling/disabling the primary plane
      drm/i915: Add a small adjustment to the pixel counter on interlaced modes
      drm/i915: Improve gen3/4 frame counter
      drm/i915: Draw a picture about video timings
      drm/i915: Fix gen2 and hsw+ scanline counter
      drm/i915: Implement WaVcpClkGateDisableForMediaReset:ctg, elk
      drm/i915: Set AGPBUSY# bit in init_clock_gating
      drm/i915: Flip the sense of AGPBUSY_DIS bit
      drm/i915: Enable interrupt-based AGPBUSY# enable on 85x
      drm/i915: Move the C3 LP write bit setup to gen3_init_clock_gating() for KMS
      drm/i915: Don't WARN about ring idle bit on gen2

Vincent Stehlé (1):
      imx-drm: imx-tve: remove unused variable

YoungJun Cho (8):
      drm/exynos: ipp: remove usless list_empty() functions
      drm/exynos: ipp: remove duplicated setting
      drm/exynos: ipp: rename cmd_lock to lock
      drm/exynos: ipp: add cmd_lock for cmd_list
      drm/exynos: ipp: add ipp_remove_id()
      drm/exynos: ipp: rearrange c_node->mem_lock using routines
      drm/exynos: ipp: rearrange c_node->event_lock using routine
      drm/exynos: ipp: update comment for struct drm_ipp_buf_info

Zhao Yakui (6):
      drm/i915: Split the BDW device definition to prepare for dual BSD rings on BDW GT3
      drm/i915: Update the restrict check to filter out wrong Ring ID passed by user-space
      drm/i915:Initialize the second BSD ring on BDW GT3 machine
      drm/i915:Handle the irq interrupt for the second BSD ring
      drm/i915:Add the VCS2 switch in Intel_ring_setup_status_page
      drm/i915: Use the coarse ping-pong mechanism based on drm fd to dispatch the BSD command on BDW GT3

Zhenyu Wang (1):
      drm/i915: Allow i915_pc8_status debug info on BDW

Émeric MASCHINO (1):
      radeon: Remove useless quirk for zx1/FireGL X1 combo introduced with fdo #7770

 Documentation/DocBook/drm.tmpl                     | 1027 ++++++++++-
 Documentation/EDID/1024x768.S                      |    2 +-
 Documentation/EDID/1280x1024.S                     |    2 +-
 Documentation/EDID/1600x1200.S                     |    2 +-
 Documentation/EDID/1680x1050.S                     |    2 +-
 Documentation/EDID/1920x1080.S                     |    2 +-
 Documentation/EDID/800x600.S                       |   41 +
 Documentation/EDID/HOWTO.txt                       |    2 +-
 Documentation/EDID/edid.S                          |   17 +-
 .../bindings/gpu/nvidia,tegra20-host1x.txt         |    2 +
 .../devicetree/bindings/panel/auo,b133xtn01.txt    |    7 +
 .../devicetree/bindings/panel/edt,et057090dhu.txt  |    7 +
 .../devicetree/bindings/panel/edt,et070080dh6.txt  |   10 +
 .../devicetree/bindings/panel/edt,etm0700g0dh6.txt |   10 +
 .../devicetree/bindings/video/exynos_dp.txt        |    4 +
 .../devicetree/bindings/video/exynos_hdmi.txt      |    3 +
 MAINTAINERS                                        |    1 +
 arch/x86/kernel/early-quirks.c                     |   46 +-
 drivers/gpu/Makefile                               |    1 +
 drivers/gpu/drm/Kconfig                            |    4 +-
 drivers/gpu/drm/Makefile                           |    5 +-
 drivers/gpu/drm/armada/armada_drv.c                |    4 +-
 drivers/gpu/drm/armada/armada_fbdev.c              |    4 +-
 drivers/gpu/drm/armada/armada_gem.c                |    4 +-
 drivers/gpu/drm/ast/Makefile                       |    4 +-
 drivers/gpu/drm/ast/ast_dp501.c                    |  410 +++++
 drivers/gpu/drm/ast/ast_drv.c                      |    3 -
 drivers/gpu/drm/ast/ast_drv.h                      |   24 +
 drivers/gpu/drm/ast/ast_main.c                     |   97 +-
 drivers/gpu/drm/ast/ast_mode.c                     |  100 +-
 drivers/gpu/drm/ast/ast_post.c                     |  902 ++++------
 drivers/gpu/drm/ast/ast_tables.h                   |   67 +-
 drivers/gpu/drm/bochs/bochs_mm.c                   |    6 +-
 drivers/gpu/drm/bridge/ptn3460.c                   |    7 -
 drivers/gpu/drm/cirrus/cirrus_main.c               |    6 +-
 drivers/gpu/drm/cirrus/cirrus_mode.c               |    8 -
 drivers/gpu/drm/drm_bufs.c                         |   34 +-
 drivers/gpu/drm/drm_cache.c                        |    6 +-
 drivers/gpu/drm/drm_crtc.c                         |  421 +++--
 drivers/gpu/drm/drm_crtc_helper.c                  |   27 +-
 drivers/gpu/drm/drm_dp_helper.c                    |   25 +-
 drivers/gpu/drm/drm_edid.c                         |  293 ++-
 drivers/gpu/drm/drm_edid_load.c                    |   23 +-
 drivers/gpu/drm/drm_fb_cma_helper.c                |    9 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   77 +-
 drivers/gpu/drm/drm_fops.c                         |    9 +-
 drivers/gpu/drm/drm_gem.c                          |   19 +-
 drivers/gpu/drm/drm_info.c                         |    6 +-
 drivers/gpu/drm/drm_ioctl.c                        |   37 +-
 drivers/gpu/drm/drm_irq.c                          |  461 +++--
 drivers/gpu/drm/drm_mipi_dsi.c                     |   10 +
 drivers/gpu/drm/drm_modes.c                        |    9 +-
 drivers/gpu/drm/drm_modeset_lock.c                 |  247 +++
 drivers/gpu/drm/drm_pci.c                          |  159 +-
 drivers/gpu/drm/drm_plane_helper.c                 |  154 +-
 drivers/gpu/drm/drm_platform.c                     |   40 +-
 drivers/gpu/drm/drm_probe_helper.c                 |   76 +-
 drivers/gpu/drm/drm_stub.c                         |   61 +-
 drivers/gpu/drm/drm_sysfs.c                        |    6 +-
 drivers/gpu/drm/drm_usb.c                          |   34 +-
 drivers/gpu/drm/exynos/Kconfig                     |    8 +-
 drivers/gpu/drm/exynos/exynos_ddc.c                |   63 -
 drivers/gpu/drm/exynos/exynos_dp_core.c            |  211 ++-
 drivers/gpu/drm/exynos/exynos_dp_core.h            |   60 +-
 drivers/gpu/drm/exynos/exynos_dp_reg.c             |   46 +-
 drivers/gpu/drm/exynos/exynos_drm_core.c           |  216 +--
 drivers/gpu/drm/exynos/exynos_drm_crtc.c           |   17 +
 drivers/gpu/drm/exynos/exynos_drm_crtc.h           |    4 +
 drivers/gpu/drm/exynos/exynos_drm_dpi.c            |   74 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |  446 +++--
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |   87 +-
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            |  114 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |   14 +-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |  427 ++---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  211 ++-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |   22 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |   10 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c            |  258 +--
 drivers/gpu/drm/exynos/exynos_drm_ipp.h            |   12 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |   11 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |  108 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  652 +++++--
 drivers/gpu/drm/exynos/exynos_hdmi.h               |   23 -
 drivers/gpu/drm/exynos/exynos_hdmiphy.c            |   65 -
 drivers/gpu/drm/exynos/exynos_mixer.c              |   67 +-
 drivers/gpu/drm/exynos/regs-hdmi.h                 |   16 +
 drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c      |    2 +-
 drivers/gpu/drm/gma500/psb_drv.c                   |    8 +-
 drivers/gpu/drm/i2c/tda998x_drv.c                  |    6 +-
 drivers/gpu/drm/i810/i810_dma.c                    |    2 +-
 drivers/gpu/drm/i915/Kconfig                       |    3 +-
 drivers/gpu/drm/i915/Makefile                      |    8 +
 drivers/gpu/drm/i915/dvo_ch7xxx.c                  |    2 +-
 drivers/gpu/drm/i915/dvo_ivch.c                    |    2 +-
 drivers/gpu/drm/i915/dvo_ns2501.c                  |   24 +-
 drivers/gpu/drm/i915/dvo_sil164.c                  |    2 +-
 drivers/gpu/drm/i915/dvo_tfp410.c                  |    2 +-
 drivers/gpu/drm/i915/i915_cmd_parser.c             |  758 +++++++-
 drivers/gpu/drm/i915/i915_debugfs.c                |  269 +--
 drivers/gpu/drm/i915/i915_dma.c                    |   74 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  626 ++++++-
 drivers/gpu/drm/i915/i915_drv.h                    |  479 +++--
 drivers/gpu/drm/i915/i915_gem.c                    |  559 ++++--
 drivers/gpu/drm/i915/i915_gem_context.c            |   95 +-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c             |   14 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  136 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  212 ++-
 drivers/gpu/drm/i915/i915_gem_gtt.h                |  284 +++
 drivers/gpu/drm/i915/i915_gem_render_state.c       |  198 ++
 drivers/gpu/drm/i915/i915_gem_userptr.c            |  711 ++++++++
 drivers/gpu/drm/i915/i915_gpu_error.c              |   55 +-
 drivers/gpu/drm/i915/i915_ioc32.c                  |    2 +-
 drivers/gpu/drm/i915/i915_irq.c                    | 1146 +++++++-----
 drivers/gpu/drm/i915/i915_params.c                 |    8 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  780 ++++++--
 drivers/gpu/drm/i915/i915_suspend.c                |    2 -
 drivers/gpu/drm/i915/i915_sysfs.c                  |    6 +-
 drivers/gpu/drm/i915/i915_trace.h                  |  101 +-
 drivers/gpu/drm/i915/intel_bios.c                  |  331 +++-
 drivers/gpu/drm/i915/intel_bios.h                  |   64 +
 drivers/gpu/drm/i915/intel_crt.c                   |   83 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |   97 +-
 drivers/gpu/drm/i915/intel_display.c               | 1894 ++++++++++++--------
 drivers/gpu/drm/i915/intel_dp.c                    |  581 +++++-
 drivers/gpu/drm/i915/intel_drv.h                   |   96 +-
 drivers/gpu/drm/i915/intel_dsi.c                   |  190 +-
 drivers/gpu/drm/i915/intel_dsi.h                   |   19 +-
 drivers/gpu/drm/i915/intel_dsi_cmd.c               |    4 +-
 drivers/gpu/drm/i915/intel_dsi_cmd.h               |    5 +-
 drivers/gpu/drm/i915/intel_dsi_panel_vbt.c         |  589 ++++++
 drivers/gpu/drm/i915/intel_dvo.c                   |    6 +-
 drivers/gpu/drm/i915/intel_fbdev.c                 |   40 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |  260 ++-
 drivers/gpu/drm/i915/intel_lvds.c                  |   23 +-
 drivers/gpu/drm/i915/intel_opregion.c              |    4 +-
 drivers/gpu/drm/i915/intel_overlay.c               |   16 +-
 drivers/gpu/drm/i915/intel_panel.c                 |  168 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  770 +++++---
 drivers/gpu/drm/i915/intel_renderstate.h           |   48 +
 drivers/gpu/drm/i915/intel_renderstate_gen6.c      |  289 +++
 drivers/gpu/drm/i915/intel_renderstate_gen7.c      |  253 +++
 drivers/gpu/drm/i915/intel_renderstate_gen8.c      |  479 +++++
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  820 +++++----
 drivers/gpu/drm/i915/intel_ringbuffer.h            |  168 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   45 +-
 drivers/gpu/drm/i915/intel_sideband.c              |   59 +-
 drivers/gpu/drm/i915/intel_sprite.c                |  239 ++-
 drivers/gpu/drm/i915/intel_tv.c                    |  221 ++-
 drivers/gpu/drm/i915/intel_uncore.c                |  108 +-
 drivers/gpu/drm/mga/mga_ioc32.c                    |    2 +-
 drivers/gpu/drm/mga/mga_state.c                    |    4 +-
 drivers/gpu/drm/mgag200/mgag200_main.c             |    6 +-
 drivers/gpu/drm/msm/Kconfig                        |    2 +-
 drivers/gpu/drm/msm/Makefile                       |    2 +
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |   20 +-
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c          |   52 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c           |    2 -
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c           |    2 -
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c            |   22 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c          |    5 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   56 +-
 drivers/gpu/drm/msm/msm_drv.h                      |   17 +-
 drivers/gpu/drm/msm/msm_gem.h                      |    1 +
 drivers/gpu/drm/msm/msm_gem_submit.c               |    1 +
 drivers/gpu/drm/msm/msm_gpu.c                      |  107 ++
 drivers/gpu/drm/msm/msm_gpu.h                      |   31 +
 drivers/gpu/drm/msm/msm_perf.c                     |  275 +++
 drivers/gpu/drm/msm/msm_rd.c                       |  337 ++++
 drivers/gpu/drm/nouveau/Makefile                   |   14 +
 drivers/gpu/drm/nouveau/core/core/event.c          |   83 +-
 drivers/gpu/drm/nouveau/core/core/object.c         |   10 +-
 drivers/gpu/drm/nouveau/core/engine/device/gm100.c |    4 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv04.c  |    4 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv10.c  |   32 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv20.c  |   16 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv30.c  |   20 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv40.c  |   64 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv50.c  |   56 +-
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |   36 +-
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |   74 +-
 drivers/gpu/drm/nouveau/core/engine/disp/base.c    |  124 +-
 drivers/gpu/drm/nouveau/core/engine/disp/conn.c    |  172 ++
 drivers/gpu/drm/nouveau/core/engine/disp/conn.h    |   59 +
 drivers/gpu/drm/nouveau/core/engine/disp/dport.c   |  292 +--
 drivers/gpu/drm/nouveau/core/engine/disp/dport.h   |   45 +-
 drivers/gpu/drm/nouveau/core/engine/disp/gm107.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv04.c    |   16 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |  286 +--
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.h    |   14 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv84.c    |    2 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv94.c    |   11 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nva0.c    |    2 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nva3.c    |    4 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c    |  206 ++-
 drivers/gpu/drm/nouveau/core/engine/disp/nve0.c    |    2 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nvf0.c    |    2 +-
 drivers/gpu/drm/nouveau/core/engine/disp/outp.c    |  137 ++
 drivers/gpu/drm/nouveau/core/engine/disp/outp.h    |   59 +
 drivers/gpu/drm/nouveau/core/engine/disp/outpdp.c  |  276 +++
 drivers/gpu/drm/nouveau/core/engine/disp/outpdp.h  |   65 +
 .../gpu/drm/nouveau/core/engine/disp/piornv50.c    |  122 +-
 drivers/gpu/drm/nouveau/core/engine/disp/priv.h    |   32 +
 drivers/gpu/drm/nouveau/core/engine/disp/sornv50.c |   28 +
 drivers/gpu/drm/nouveau/core/engine/disp/sornv94.c |   85 +-
 drivers/gpu/drm/nouveau/core/engine/disp/sornvd0.c |   72 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/base.c    |    6 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c   |   35 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nv04.c    |    2 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv84.c    |    4 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c    |    6 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |    6 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h    |    1 +
 .../gpu/drm/nouveau/core/engine/graph/ctxgk20a.c   |   53 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnv108.c   |    2 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc0.h    |    9 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnve4.c    |   14 +-
 .../gpu/drm/nouveau/core/engine/graph/ctxnvf0.c    |    2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c  |   47 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv50.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |   14 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |    2 +
 drivers/gpu/drm/nouveau/core/engine/graph/nve4.c   |    4 +-
 .../gpu/drm/nouveau/core/engine/software/nv50.c    |    4 +-
 .../gpu/drm/nouveau/core/engine/software/nv50.h    |    2 +-
 .../gpu/drm/nouveau/core/engine/software/nvc0.c    |    2 +-
 drivers/gpu/drm/nouveau/core/include/core/class.h  |    4 +
 drivers/gpu/drm/nouveau/core/include/core/event.h  |   29 +-
 drivers/gpu/drm/nouveau/core/include/engine/disp.h |   30 +-
 drivers/gpu/drm/nouveau/core/include/engine/fifo.h |    1 +
 .../gpu/drm/nouveau/core/include/engine/graph.h    |    1 +
 .../drm/nouveau/core/include/subdev/bios/conn.h    |   22 +-
 .../gpu/drm/nouveau/core/include/subdev/bios/dp.h  |    9 +-
 .../gpu/drm/nouveau/core/include/subdev/clock.h    |    8 +-
 drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |    1 +
 drivers/gpu/drm/nouveau/core/include/subdev/gpio.h |   34 +-
 drivers/gpu/drm/nouveau/core/include/subdev/i2c.h  |   83 +-
 drivers/gpu/drm/nouveau/core/include/subdev/ibus.h |    1 +
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |    6 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     |  114 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c    |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/conn.c    |   62 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/dp.c      |   23 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/base.c   |    7 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c   |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nv40.c   |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c   |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c   |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c   |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nve0.c   |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c     |   56 +
 drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |    1 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c  |  152 ++
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv50.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnve0.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/base.c    |  130 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv10.c    |  115 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv50.c    |  152 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv92.c    |   74 +
 drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c    |   56 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c    |  137 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/priv.h    |   62 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/anx9805.c  |   27 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c      |   36 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c     |  212 ++-
 drivers/gpu/drm/nouveau/core/subdev/i2c/bit.c      |    8 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv04.c     |   33 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv4e.c     |   33 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv50.c     |   30 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv50.h     |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv94.c     |  108 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nvd0.c     |   38 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nve0.c     |   72 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/pad.c      |   84 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/pad.h      |   58 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/padnv04.c  |   35 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/padnv94.c  |   86 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/port.h     |   15 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/priv.h     |   85 +
 drivers/gpu/drm/nouveau/core/subdev/ibus/gk20a.c   |  103 ++
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c      |    5 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c      |    5 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c      |    5 +-
 drivers/gpu/drm/nouveau/core/subdev/mxm/nv50.c     |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/ic.c     |    6 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nva3.c   |    2 +-
 drivers/gpu/drm/nouveau/dispnv04/dac.c             |    2 +-
 drivers/gpu/drm/nouveau/dispnv04/dfp.c             |    2 +-
 drivers/gpu/drm/nouveau/dispnv04/disp.c            |    2 +-
 drivers/gpu/drm/nouveau/dispnv04/tvnv04.c          |    3 +-
 drivers/gpu/drm/nouveau/dispnv04/tvnv17.c          |    3 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |  212 ++-
 drivers/gpu/drm/nouveau/nouveau_connector.h        |   10 +-
 drivers/gpu/drm/nouveau/nouveau_crtc.h             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |   18 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c               |   14 +-
 drivers/gpu/drm/nouveau/nouveau_encoder.h          |    5 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |    4 +-
 drivers/gpu/drm/nouveau/nouveau_ioc32.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_vga.c              |   11 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |  107 +-
 drivers/gpu/drm/omapdrm/omap_crtc.c                |   10 +-
 drivers/gpu/drm/omapdrm/omap_drv.c                 |    4 +-
 drivers/gpu/drm/omapdrm/omap_fb.c                  |    1 +
 drivers/gpu/drm/panel/panel-ld9040.c               |    3 +
 drivers/gpu/drm/panel/panel-s6e8aa0.c              |    1 +
 drivers/gpu/drm/panel/panel-simple.c               |   99 +
 drivers/gpu/drm/qxl/qxl_display.c                  |    6 +-
 drivers/gpu/drm/qxl/qxl_drv.c                      |    1 -
 drivers/gpu/drm/qxl/qxl_ioctl.c                    |    2 +-
 drivers/gpu/drm/qxl/qxl_irq.c                      |    2 +-
 drivers/gpu/drm/qxl/qxl_ttm.c                      |    6 -
 drivers/gpu/drm/r128/r128_ioc32.c                  |    2 +-
 drivers/gpu/drm/r128/r128_state.c                  |    4 +-
 drivers/gpu/drm/radeon/Makefile                    |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |   92 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |   40 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |    5 +-
 drivers/gpu/drm/radeon/atombios_i2c.c              |   17 +-
 drivers/gpu/drm/radeon/cik.c                       |   33 +-
 drivers/gpu/drm/radeon/cik_sdma.c                  |   43 +-
 drivers/gpu/drm/radeon/cikd.h                      |    1 +
 drivers/gpu/drm/radeon/clearstate_cayman.h         |    8 +-
 drivers/gpu/drm/radeon/clearstate_ci.h             |    4 +-
 drivers/gpu/drm/radeon/clearstate_si.h             |    4 +-
 drivers/gpu/drm/radeon/dce3_1_afmt.c               |  244 +++
 drivers/gpu/drm/radeon/evergreen.c                 |   72 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |   48 +-
 drivers/gpu/drm/radeon/evergreend.h                |    3 +-
 drivers/gpu/drm/radeon/ni.c                        |   17 +-
 drivers/gpu/drm/radeon/nid.h                       |    1 +
 drivers/gpu/drm/radeon/r100.c                      |   63 +-
 drivers/gpu/drm/radeon/r300.c                      |    7 +-
 drivers/gpu/drm/radeon/r600.c                      |   15 +-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |  341 ++--
 drivers/gpu/drm/radeon/r600d.h                     |   17 +
 drivers/gpu/drm/radeon/radeon.h                    |   55 +-
 drivers/gpu/drm/radeon/radeon_agp.c                |    3 -
 drivers/gpu/drm/radeon/radeon_asic.c               |   72 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   40 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |    2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |   78 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |    8 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   55 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  282 +--
 drivers/gpu/drm/radeon/radeon_drv.c                |   12 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |   22 +-
 drivers/gpu/drm/radeon/radeon_i2c.c                |   11 +-
 drivers/gpu/drm/radeon/radeon_ioc32.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |    2 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   18 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |    7 +-
 drivers/gpu/drm/radeon/radeon_object.c             |   11 +-
 drivers/gpu/drm/radeon/radeon_object.h             |    2 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |    3 +
 drivers/gpu/drm/radeon/radeon_state.c              |    4 +-
 drivers/gpu/drm/radeon/radeon_uvd.c                |    3 +-
 drivers/gpu/drm/radeon/radeon_vce.c                |    1 +
 drivers/gpu/drm/radeon/radeon_vm.c                 |  123 +-
 drivers/gpu/drm/radeon/rs400.c                     |    7 +-
 drivers/gpu/drm/radeon/rs600.c                     |   44 +-
 drivers/gpu/drm/radeon/rv770.c                     |   13 +-
 drivers/gpu/drm/radeon/si.c                        |   33 +-
 drivers/gpu/drm/radeon/si_dma.c                    |   24 +-
 drivers/gpu/drm/radeon/si_dpm.c                    |   13 +-
 drivers/gpu/drm/radeon/sid.h                       |    1 +
 drivers/gpu/drm/radeon/uvd_v2_2.c                  |    2 +-
 drivers/gpu/drm/rcar-du/Kconfig                    |    2 +
 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c          |    7 -
 drivers/gpu/drm/rcar-du/rcar_du_vgacon.c           |    7 -
 drivers/gpu/drm/savage/savage_bci.c                |    2 +-
 drivers/gpu/drm/shmobile/Kconfig                   |    3 +-
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c          |    7 -
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |    2 +-
 drivers/gpu/drm/sis/sis_mm.c                       |    2 +-
 drivers/gpu/drm/tegra/Makefile                     |    1 -
 drivers/gpu/drm/tegra/bus.c                        |   75 -
 drivers/gpu/drm/tegra/dc.c                         |  673 ++++---
 drivers/gpu/drm/tegra/dc.h                         |   33 +-
 drivers/gpu/drm/tegra/dpaux.c                      |   35 +-
 drivers/gpu/drm/tegra/drm.c                        |   36 +-
 drivers/gpu/drm/tegra/drm.h                        |   58 +-
 drivers/gpu/drm/tegra/dsi.c                        |  250 +--
 drivers/gpu/drm/tegra/dsi.h                        |   10 +
 drivers/gpu/drm/tegra/fb.c                         |    7 +-
 drivers/gpu/drm/tegra/gem.c                        |    3 +-
 drivers/gpu/drm/tegra/gr2d.c                       |    8 +-
 drivers/gpu/drm/tegra/gr3d.c                       |    8 +-
 drivers/gpu/drm/tegra/hdmi.c                       |  202 ++-
 drivers/gpu/drm/tegra/hdmi.h                       |    5 +
 drivers/gpu/drm/tegra/rgb.c                        |   31 +-
 drivers/gpu/drm/tegra/sor.c                        |  478 ++++-
 drivers/gpu/drm/tegra/sor.h                        |    4 +
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |    2 +-
 drivers/gpu/drm/udl/udl_main.c                     |    1 +
 drivers/gpu/drm/via/via_dma.c                      |    2 +-
 drivers/gpu/drm/via/via_mm.c                       |    2 +-
 drivers/gpu/drm/vmwgfx/Kconfig                     |    7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   10 +-
 drivers/gpu/host1x/bus.c                           |   12 +-
 drivers/gpu/ipu-v3/Kconfig                         |    7 +
 drivers/{staging/imx-drm => gpu}/ipu-v3/Makefile   |    4 +-
 .../{staging/imx-drm => gpu}/ipu-v3/ipu-common.c   |   82 +-
 drivers/{staging/imx-drm => gpu}/ipu-v3/ipu-dc.c   |    3 +-
 drivers/{staging/imx-drm => gpu}/ipu-v3/ipu-di.c   |    2 +-
 drivers/{staging/imx-drm => gpu}/ipu-v3/ipu-dmfc.c |    2 +-
 drivers/{staging/imx-drm => gpu}/ipu-v3/ipu-dp.c   |    2 +-
 drivers/{staging/imx-drm => gpu}/ipu-v3/ipu-prv.h  |    8 +-
 drivers/gpu/ipu-v3/ipu-smfc.c                      |   97 +
 drivers/gpu/vga/vga_switcheroo.c                   |    3 +-
 drivers/staging/imx-drm/Kconfig                    |   11 +-
 drivers/staging/imx-drm/Makefile                   |    1 -
 drivers/staging/imx-drm/imx-drm-core.c             |    9 +-
 drivers/staging/imx-drm/imx-drm.h                  |    2 -
 drivers/staging/imx-drm/imx-hdmi.c                 |    3 +-
 drivers/staging/imx-drm/imx-ldb.c                  |    1 -
 drivers/staging/imx-drm/imx-tve.c                  |    7 +-
 drivers/staging/imx-drm/ipuv3-crtc.c               |    2 +-
 drivers/staging/imx-drm/ipuv3-plane.c              |    2 +-
 drivers/staging/imx-drm/parallel-display.c         |    1 -
 drivers/video/Kconfig                              |    1 +
 include/drm/drmP.h                                 |   54 +-
 include/drm/drm_crtc.h                             |   92 +-
 include/drm/drm_crtc_helper.h                      |    6 +-
 include/drm/drm_dp_helper.h                        |   88 +-
 include/drm/drm_edid.h                             |    5 +
 include/drm/drm_fb_helper.h                        |    2 +-
 include/drm/drm_flip_work.h                        |    1 +
 include/drm/drm_mipi_dsi.h                         |    2 +
 include/drm/drm_modes.h                            |    2 +-
 include/drm/drm_modeset_lock.h                     |  126 ++
 include/drm/drm_plane_helper.h                     |   24 +-
 include/drm/i915_pciids.h                          |   28 +-
 include/drm/ttm/ttm_bo_api.h                       |    5 +-
 include/uapi/drm/drm_mode.h                        |   16 +
 include/uapi/drm/i915_drm.h                        |   17 +
 include/uapi/drm/radeon_drm.h                      |    2 +-
 .../imx-drm/ipu-v3 => include/video}/imx-ipu-v3.h  |   16 +
 lib/Kconfig                                        |   14 +
 lib/Kconfig.debug                                  |    1 +
 lib/Makefile                                       |    3 +-
 lib/interval_tree.c                                |    6 +
 ...erval_tree_test_main.c => interval_tree_test.c} |    0
 447 files changed, 24815 insertions(+), 9570 deletions(-)
 create mode 100644 Documentation/EDID/800x600.S
 create mode 100644 Documentation/devicetree/bindings/panel/auo,b133xtn01.txt
 create mode 100644 Documentation/devicetree/bindings/panel/edt,et057090dhu.txt
 create mode 100644 Documentation/devicetree/bindings/panel/edt,et070080dh6.txt
 create mode 100644 Documentation/devicetree/bindings/panel/edt,etm0700g0dh6.txt
 create mode 100644 drivers/gpu/drm/ast/ast_dp501.c
 create mode 100644 drivers/gpu/drm/drm_modeset_lock.c
 delete mode 100644 drivers/gpu/drm/exynos/exynos_ddc.c
 delete mode 100644 drivers/gpu/drm/exynos/exynos_hdmi.h
 delete mode 100644 drivers/gpu/drm/exynos/exynos_hdmiphy.c
 create mode 100644 drivers/gpu/drm/i915/i915_gem_gtt.h
 create mode 100644 drivers/gpu/drm/i915/i915_gem_render_state.c
 create mode 100644 drivers/gpu/drm/i915/i915_gem_userptr.c
 create mode 100644 drivers/gpu/drm/i915/intel_dsi_panel_vbt.c
 create mode 100644 drivers/gpu/drm/i915/intel_renderstate.h
 create mode 100644 drivers/gpu/drm/i915/intel_renderstate_gen6.c
 create mode 100644 drivers/gpu/drm/i915/intel_renderstate_gen7.c
 create mode 100644 drivers/gpu/drm/i915/intel_renderstate_gen8.c
 create mode 100644 drivers/gpu/drm/msm/msm_perf.c
 create mode 100644 drivers/gpu/drm/msm/msm_rd.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/conn.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/conn.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/outp.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/outp.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/outpdp.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/outpdp.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxgk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/gpio/nv92.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/nve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/pad.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/pad.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/padnv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/padnv94.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/port.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/priv.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ibus/gk20a.c
 create mode 100644 drivers/gpu/drm/radeon/dce3_1_afmt.c
 delete mode 100644 drivers/gpu/drm/tegra/bus.c
 create mode 100644 drivers/gpu/ipu-v3/Kconfig
 rename drivers/{staging/imx-drm => gpu}/ipu-v3/Makefile (51%)
 rename drivers/{staging/imx-drm => gpu}/ipu-v3/ipu-common.c (94%)
 rename drivers/{staging/imx-drm => gpu}/ipu-v3/ipu-dc.c (99%)
 rename drivers/{staging/imx-drm => gpu}/ipu-v3/ipu-di.c (99%)
 rename drivers/{staging/imx-drm => gpu}/ipu-v3/ipu-dmfc.c (99%)
 rename drivers/{staging/imx-drm => gpu}/ipu-v3/ipu-dp.c (99%)
 rename drivers/{staging/imx-drm => gpu}/ipu-v3/ipu-prv.h (96%)
 create mode 100644 drivers/gpu/ipu-v3/ipu-smfc.c
 create mode 100644 include/drm/drm_modeset_lock.h
 rename {drivers/staging/imx-drm/ipu-v3 => include/video}/imx-ipu-v3.h (95%)
 rename lib/{interval_tree_test_main.c => interval_tree_test.c} (100%)
--29444707-784526306-1402534712=:2473--
