Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaHGW2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:28:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34764 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375AbaHGW1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:27:13 -0400
Date: Thu, 7 Aug 2014 23:27:09 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm merge window pull
Message-ID: <alpine.DEB.2.00.1408072323240.15178@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-387882669-1407450429=:15178"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-387882669-1407450429=:15178
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

like all good pull reqs this ends with a revert, so it must mean we 
tested it,

This pull is missing nouveau, Ben has been stuck trying to track down a 
very longstanding bug that revealed itself due to some other changes, I've 
asked him to send you a direct pull request for nouveau once he cleans 
things up. I'm away until Monday so don't want to delay things, you can 
make a decision on that when he sends it, I have my phone so I can ack 
things just not really merge much.

It has one trivial conflict with your tree in armada_drv.c, and also the 
pull request contains some component changes that are already in your 
tree, the base tree from Russell went via Greg's tree already, but some 
stuff still shows up in here that doesn't when I merge my tree into yours.

otherwise all pretty standard graphics fare, one new driver and changes 
all over the place.

New drivers: sti kms driver for STMicroelectronics chipsets stih416 and 
stih407.

core:
	lots of cleanups to the drm core
	DP MST helper code merged
	universal cursor planes.
	render nodes enabled by default

panel:
	better panel interfaces
	new panel support
	non-continuous cock advertising ability

ttm:
	shrinker fixes

i915: 
	hopefully ditched UMS support
	runtime pm fixes
	psr tracking and locking - now enabled by default
	userptr fixes
	backlight brightness fixes
	MST support merged 
	runtime PM for dpms
	primary planes locking fixes
	gen8 hw semaphore support
	fbc fixes
	runtime PM on SOix sleep state hw.
	mmio base page flipping
	lots of vlv/chv fixes.
	universal cursor planes
	
radeon:
	Hawaii fixes
	display scalar support for non-fixed mode displays
	new firmware format support
	dpm on more asics by default
	GPUVM improvements
	uncached and wc GTT buffers
	BOs > visible VRAM

exynos:
	i80 interface support
	module auto-loading
	ipp driver consolidated.

armada:
	irq handling in crtc layer only
	crtc renumbering
	add component support
	DT interaction changes.

tegra:
	load as module fixes
	eDP bpp and sync polarity fixed
	DSI non-continuous clock mode support
	better support for importing buffers from nouveau

msm:
	mdp5/adq8084 v1.3 hw enablement
	devicetree clk changse
	ifc6410 board working

tda998x:
	component support
	DT documentation update

vmwgfx:
	fix compat shader namespace

The following changes since commit 19583ca584d6f574384e17fe7613dfaeadcdc4a6:

  Linux 3.16 (2014-08-03 15:25:02 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to 7963e9db1b1f842fdc53309baa8714d38e9f5681:

  Revert "drm: drop redundant drm_file->is_master" (2014-08-08 07:30:53 +1000)

----------------------------------------------------------------
Ajay Kumar (15):
      drm/panel: add .prepare() and .unprepare() functions
      drm/panel: Provide convenience wrapper for .get_modes()
      drm/panel: ld9040: Add dummy prepare and unprepare routines
      drm/panel: s6e8aa0: Add dummy prepare and unprepare routines
      drm/panel: simple: Add dummy prepare and unprepare routines
      drm/exynos: dpi: Add support for panel prepare and unprepare routines
      drm/exynos: dsi: Add support for panel prepare and unprepare routines
      drm/tegra: Add support for panel prepare and unprepare routines
      drm/panel: ld9040: Add proper definition for prepare and unprepare
      drm/panel: s6e8aa0: Add proper definition for prepare and unprepare
      drm/panel: simple: Add proper definition for prepare and unprepare
      drm/panel: simple: Support delays in panel functions
      drm/panel: simple: Add AUO B133HTN01 panel support
      drm/exynos: Move DP setup into commit()
      drm/exynos: dp: Modify driver to support drm_panel

Akash Goel (1):
      drm/i915: Added write-enable pte bit supportt

Alban Bedel (1):
      drm/panel: simple: add support for InnoLux N156BGE-L21 panel

Alban Browaeys (1):
      drm/exynos: g2d: add exynos4212 as a compatible device.

Alex Deucher (25):
      drm/radeon/dpm: add support for SVI2 voltage for SI
      drm/radeon: disable gfx cgcg on cik
      drm/radeon: add new firmware header definitions (v3)
      drm/radeon/si: Add support for new ucode format (v3)
      drm/radeon/cik: Add support for new ucode format (v5)
      drm/radeon: enable display scaling on all connectors (v2)
      drm/radeon: consolidate vga and dvi get_modes functions (v2)
      drm/radeon: restructure edid fetching
      drm/radeon: use a fetch function to get the edid
      drm/radeon: track pinned memory (v2)
      drm/radeon: use vram/gart pinned size in radeon_gem_info_ioctl
      drm/radeon: use vram/gart pinned size in radeon_do_test_moves
      drm/radeon: remove visible vram size limit on bo allocation (v4)
      drm/radeon: add a PX quirk list
      drm/radeon: make radeon_connector_encoder_is_hbr2 static
      drm/radeon: load the lm63 driver for an lm64 thermal chip.
      drm/radeon: fix reversed logic in evergreen_mc_resume
      drm/radeon/atom: add new voltage fetch function for hawaii
      drm/radeon/dpm: handle voltage info fetching on hawaii
      drm/radeon: re-enable dpm by default on cayman
      drm/radeon: re-enable dpm by default on BTC
      drm/radeon: use an intervall tree to manage the VMA v2
      drm/radeon: use packet2 for nop on hawaii with old firmware
      drm/radeon: tweak ACCEL_WORKING2 query for hawaii
      drm/radeon: use packet3 for nop on hawaii with new firmware

Alex Williamson (1):
      vgaarb: We can own non-decoded resources

Alexandre Courbot (5):
      drm/ttm: remove declaration of ttm_tt_cache_flush
      drm/dsi: Flag for non-continuous clock behavior
      drm/panel: Set non-continuous clock flag on supporting panels
      drm/tegra: dsi - Handle non-continuous clock flag
      drm/panel: simple: Use devm_gpiod_get_optional()

Andreas Boll (1):
      drm/radeon: tweak ACCEL_WORKING2 query for the new firmware for hawaii

Andrzej Hajda (12):
      drm/exynos/ipp: remove type casting
      drm/exynos/ipp: remove unused field from exynos_drm_ipp_private
      drm/exynos/ipp: remove struct exynos_drm_ipp_private
      drm/exynos/ipp: correct address type
      drm/exynos/ipp: remove temporary variable
      drm/exynos/ipp: remove incorrect checks of list_first_entry result
      drm/exynos/ipp: simplify memory check function
      drm/exynos/ipp: remove useless registration checks
      drm/exynos/ipp: simplify ipp_find_obj
      drm/exynos/ipp: remove redundant messages
      drm/exynos/ipp: simplify ipp_create_id
      drm/exynos/ipp: simplify ipp_find_driver

Armin Reese (1):
      drm/i915: Do not unmap object unless no other VMAs reference it

Beeresh Gopal (2):
      drm/msm/hdmi: enable lpm-mux if it is present
      drm/msm/hdmi: fix HDMI_MUX_EN gpio request typo

Ben Widawsky (13):
      drm/i915: Move compressed_fb to static allocation
      drm/i915: Extract CFB threshold calculation
      drm/i915: Try harder to get FBC
      drm/i915: gen specific ring init
      drm/i915: Make semaphore updates more precise
      drm/i915/bdw: implement semaphore signal
      drm/i915/bdw: implement semaphore wait
      drm/i915: Extract semaphore error collection
      drm/i915/bdw: collect semaphore error state
      drm/i915: semaphore debugfs
      drm/i915/bdw: poll semaphores
      drm/i915/error: Check the potential ctx obj's vm
      drm/i915: Reorder ctx unref on ppgtt cleanup

Benjamin Gaignard (11):
      drm: sti: add bindings for DRM driver
      drm: sti: add VTG driver
      drm: sti: add VTAC drivers
      drm: sti: add HDMI driver
      drm: sti: add HDA driver
      drm: sti: add TVOut driver
      drm: sti: add GDP layer
      drm: sti: add VID layer
      drm: sti: add Mixer
      drm: sti: add Compositor
      drm: sti: Add DRM driver itself

Boris BREZILLON (1):
      drm/panel: add support for Foxlink FL500WVR00-A0T panel

Borun Fu (1):
      drm/i915: Power gating display wells during i915_pm_suspend

Brad Volkin (1):
      drm/i915: Add some L3 registers to the parser whitelist

Chris Wilson (21):
      drm/i915: Check for a NULL shared dpll before dereferencing
      drm/i915: Use the .release hook to drop the stolen drm_mm tracking
      drm/i915: Prefault the entire object on first page fault
      drm: Avoid NULL deference when disabling a plane from userspace
      drm/i915: Simplify i915_gem_release_all_mmaps()
      drm/i915: Simplify processing of the golden render context state
      drm/i915: Show cursor size in debugfs/i915_display_info
      drm/i915: Restrict GPU boost to the RCS engine
      drm/i915: Disable RCS flips on Ivybridge
      drm/i915: Use mmio flips to change tiling mode on Baytrail
      drm/i915: HWS must be in the mappable region for g33
      drm/i915: Move RPS evaluation interval counters to i915->rps
      drm/i915: Make the RPS interrupt generation mask handle the vlv wa
      drm/i915: fix build without fbdev.
      drm/i915: Handle failure to kick out a conflicting fb driver
      drm/i915: Abandon oom quickly if killed by a signal
      drm/i915: Initialise userptr mmu_notifier serial to 1
      drm/i915: Allow overlapping userptr objects
      drm/i915/userptr: Keep spin_lock/unlock in the same block
      drm/i915: only hook up hpd pulse for DP outputs
      drm: Unlink dead file_priv from list of active files first

Christian König (16):
      drm/ttm: fix handling of TTM_PL_FLAG_TOPDOWN v2
      drm/radeon: remove discardable flag from radeon_gem_object_create
      drm/radeon: fix R600_PTE_GART handling
      drm/radeon: add trace_radeon_vm_flush
      drm/radeon: set VM base addr using the PFP v2
      drm/radeon: separate ring and IB handling
      drm/radeon: invalidate moved BOs in the VM (v2)
      drm/radeon: remove radeon_bo_clear_va
      drm/radeon: try to enable VM flushing once more
      drm/radeon: adjust default radeon_vm_block_size v2
      drm/radeon: remove taking mclk_lock from radeon_bo_unref
      drm/radeon: add radeon_bo_ref function
      drm/radeon: take a BO reference on VM cleanup
      drm/radeon: add VM GART copy optimization to NI as well
      drm/radeon: split PT setup in more functions
      drm/radeon: update IB size estimation for VM

Christoph Jaeger (1):
      drm/i915: Fix memory leak in intel_dsi_init() error path

Daisy Sun (1):
      drm/i915: Broaden FBC resolution limit to 4096*4096

Damien Lespiau (9):
      drm/i915: Make intel_dsi_init() return void
      drm/i915: Use %c in a format string for the pipe name
      drm: Driver-specific ioctls range from 0x40 to 0x9f
      drm/i915: Don't cast a pointer to void* unnecessarily
      drm/dp-mst-helper: Avoid reading uninitialized value
      drm/dp-mst-helper: Don't use uninitialized fields of the sideband message header
      drm/i915: PM irq enabling is generic on gen8, too
      drm/i915: Also give the sprite width for WM computation
      drm/i915: Make the WRPLL names const

Dan Carpenter (1):
      drm/tegra: sor - missing unlock on error

Daniel Vetter (58):
      drm/i915: Fix context locking in debugfs
      drm/i915: Drop locking around fbdev-fb in debugfs
      drm/i915: runtime PM support for DPMS
      drm/i915: Add #defines for short/long pulse on gmch platforms
      Merge commit 'e81a0e771c10de86fdb52c6baf534ff5fdeec72c' into topic/soix
      drm/i915: Unifiy GT powersave suspend logic
      drm/i915: Only wait one vblank when disabling crc if the pipe is on
      drm/i915: Update DRIVER_DATE to 20140606
      drm/i915: Fix comment about our plane remapping on gen2/3
      drm/i915: Add missing statics to recent psr functions
      drm/i915: Grab dev->struct_mutex in i915_gem_pageflip_info
      drm/i915: Don't BUG_ON in i915_gem_obj_offset
      Merge branch 'topic/soix' into drm-intel-next-queued
      drm: Don't export internal module variables
      drm/i915: Drop unecessary complexity from psr_inactivate
      drm/i915: Ditch intel_edp_psr_update
      drm/i915: Drop schedule_back from psr_exit
      drm/i915: Introduce accurate frontbuffer tracking
      drm/i915: Print obj->frontbuffer_bits in debugfs output
      drm/i915: Properly track domain of the fbcon fb
      drm/i915: Use new frontbuffer bits to increase pll clock
      drm/i915: Track frontbuffer invalidation/flushing
      drm/i915: Update DRIVER_DATE to 20140620
      Merge patches merged by Jani while I was on vacation.
      Merge tag 'v3.16-rc4' into drm-intel-next-queued
      drm/i915: Support pf CRC source on haswell transcoder edp
      drm/fb-helper: Fix hpd vs. initial config races
      drm/i915: Check hw state in assert_can_disable_lcpll
      drm/i915: Remove spll_refcount for hsw
      drm/i915: Clean up WRPLL/SPLL #defines
      drm/i915: Move the SPLL enabling into hsw_crt_pre_enable
      drm/i915: Move SPLL disabling into hsw_crt_post_disable
      drm/i915: Add a debugfs file for the shared dpll state
      drm/i915: Move ddi_pll_sel into the pipe config
      drm/i915: State readout and cross-checking for ddi_pll_sel
      drm/i915: Precompute static ddi_pll_sel values in encoders
      drm/i915: Basic shared dpll support for WRPLLs
      drm/i915: Document that the pll->mode_set hook is optional
      drm/i915: State readout support for WRPLLs
      drm/i915: ->disable hook for WRPLLs
      drm/i915: ->enable hook for WRPLLs
      drm/i915: Switch to common shared dpll framework for WRPLLs
      drm/i915: Only touch WRPLL hw state in enable/disable hooks
      drm/i915: ddi: enable runtime pm during dpms
      drm/i915: Run psr_setup unconditionally
      drm/i915: Add a FIXME about drrs/psr interactions
      drm/i915: Track the psr dp connector in dev_priv->psr.enabled
      drm/i915: Don't try to disable psr harder from the work item
      drm/i915: Lock down psr sw/hw state tracking
      drm/i915: More checks for psr.enabled
      drm/i915: Add locking to psr code
      drm/i915: Fix up PSR frontbuffer tracking
      drm/i915: Improve PSR debugfs output
      drm/i915: Remove redundant HAS_PSR checks
      drm/i915: Use genX_ prefix for gt irq enable/disable functions
      drm/i915: Ditch UMS config option
      Merge remote-tracking branch 'airlied/drm-next' into drm-intel-next
      drm: Fix race when checking for fb in the generic kms obj lookup

Dave Airlie (43):
      drm/i915: rework digital port IRQ handling (v2)
      Merge tag 'vmwgfx-next-2014-07-04' of git://people.freedesktop.org/~thomash/linux into drm-next
      Merge tag 'topic/core-stuff-2014-06-30' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge branch 'drm-next' of git://people.freedesktop.org/~dvdhrm/linux into drm-next
      drm/crtc: add interface to reinitialise the legacy mode group
      drm/fb_helper: allow adding/removing connectors later
      drm: add a path blob property
      drm/helper: add Displayport multi-stream helper (v0.6)
      Merge tag 'drm-intel-next-2014-06-20' of git://anongit.freedesktop.org/drm-intel into drm-next
      drm/tilcdc: oops a Module.symvers snuck in
      drm/mst: fix build with debugfs off.
      Merge tag 'drm-intel-next-2014-07-11' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'topic/core-stuff-2014-07-18' of git://anongit.freedesktop.org/drm-intel into drm-next
      drm/i915: fix psr match conditions screw ups.
      drm/i915: add some registers need for displayport MST support.
      i915: split some DP modesetting code into a separate function
      drm/i915: check connector->encoder before using it.
      drm/i915: split conversion function out into separate function
      drm/i915: add DP 1.2 MST support (v0.7)
      drm/i915: mst topology dumper in debugfs (v0.2)
      Merge branch 'drm-i915-mst-support-next' of git://people.freedesktop.org/~airlied/linux into drm-next
      drm/ttm: use gfp_t instead of int for flags.
      drm/ttm: make device_released static
      Merge branch 'drm-armada-devel' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into drm-next
      Merge branch 'component-for-drm' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into drm-next
      drm/i915: don't suspend gt until after we disable irqs and display (v2)
      drm/i915: fix initial fbdev setup warnings
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      drm: close race in connector registration (v2)
      Merge tag 'drm-intel-next-2014-07-25-merged' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'v3.16' into drm-next
      Merge branch 'msm-next' of git://people.freedesktop.org/~robclark/linux into drm-next
      Merge branch 'tda998x-devel' of git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-next
      Merge branch 'drm_kms_for_next-v8' of git://git.linaro.org/people/benjamin.gaignard/kernel into drm-next
      drm/sti: fix warning in build.
      drm/tda998x: update for new drm connector APIs.
      Merge branch 'drm-next-3.17' of git://people.freedesktop.org/~agd5f/linux into drm-next
      drm/i915: lock around link status and link training.
      Merge branch 'drm-next' of git://people.freedesktop.org/~dvdhrm/linux into drm-next
      drm: move drm_stub.c to drm_drv.c
      Merge tag 'drm/panel/for-3.17-rc1' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge tag 'drm/tegra/for-3.17-rc1' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Revert "drm: drop redundant drm_file->is_master"

David Herrmann (16):
      drm/i915: use shmem helpers if possible
      drm/i915: use shmem helpers if possible
      drm/omap: use __GFP_DMA32 for shmem-backed gem
      drm/gem: remove misleading gfp parameter to get_pages()
      drm: enable render-nodes by default
      drm: remove unused "struct drm_freelist"
      drm: drop unused "struct drm_queue"
      drm: drop i386 verification
      drm: extract legacy ctxbitmap flushing
      drm: drop redundant drm_file->is_master
      drm: don't de-authenticate clients on master-close
      drm: move module initialization to drm_stub.c
      drm: merge drm_drv.c into drm_ioctl.c
      drm: make minor->index available early
      drm: make sysfs device always available for minors
      drm: mark drm_context support as legacy

Deepak S (14):
      drm/i915/chv: Enable Render Standby (RC6) for Cherryview
      drm/i915/chv: Added CHV specific register read and write and Streamline CHV forcewake stuff
      drm/i915/chv: Enable RPS (Turbo) for Cherryview
      drm/i915/chv: Freq(opcode) request for CHV.
      drm/i915/vlv: WA for Turbo and RC6 to work together.
      drm/i915: Read guaranteed freq for valleyview
      drm/i915: Add RP0/RP1/RPn render P state thresholds in VLV sysfs
      drm/i915: populate mem_freq/cz_clock for chv
      drm/i915: CHV GPU frequency to opcode functions
      drm/i915/chv: Add basic PM interrupt support for CHV
      drm/i915: Add RP1 render P state thresholds in CHV
      drm/i915: Force GPU Freq to lowest while suspending.
      drm/i915/chv: Drop WaGsvBringDownFreqInRc6
      drm/i915: Fix printing proper min/min/rpe values in debugfs

Egbert Eich (1):
      DRM/i915: Remove magic to prevent blank screen on gen4 chipsets

Fabian Frederick (5):
      drm/i915: replace ALIGN(PAGE_SIZE) by PAGE_ALIGN
      drm/bochs: replace ALIGN(PAGE_SIZE) by PAGE_ALIGN
      drm/omap: remove null test before kfree
      drivers/gpu/drm/drm_buffer.c: remove unnecessary null test before kfree
      drm/radeon: remove null test before kfree

Fabien DESSENNE (1):
      drm/crtc-helper: use drm_framebuffer flags

Fengguang Wu (1):
      drm/i915: byt_gpu_freq() can be static

Guido Martínez (8):
      drm/tilcdc: panel: fix dangling sysfs connector node
      drm/tilcdc: slave: fix dangling sysfs connector node
      drm/tilcdc: tfp410: fix dangling sysfs connector node
      drm/tilcdc: panel: fix leak when unloading the module
      drm/tilcdc: fix release order on exit
      drm/tilcdc: fix double kfree
      drm/tilcdc: remove submodule destroy calls
      drm/tilcdc: replace late_initcall with module_init

Hai Li (1):
      drm/msm: Implement msm drm fb_mmap callback function

Imre Deak (8):
      drm/i915: fix possible refcount leak when resetting forcewake
      drm/i915: preserve user forcewake over system suspend/resume
      drm/i915: gmch: factor out intel_set_memory_cxsr
      drm/i915: gmch: set SR WMs to valid values before enabling them
      drm/i915: gmch: fix stuck primary plane due to memory self-refresh mode
      drm/i915: make system freeze support depend on CONFIG_ACPI_SLEEP
      drm/i915: ddi: move pch setup after encoder->pre_enable
      drm/i915: ddi: move pch cleanup before encoder->post_disable

Jani Nikula (2):
      drm/i915: extract backlight minimum brightness from VBT
      drm/i915: respect the VBT minimum backlight brightness

Jean-Francois Moine (2):
      drm/i2c: tda998x: fix lack of required reg in DT documentation
      drm/i2c: tda998x: Remove useless test

Jesse Barnes (12):
      drm/i915: enable PPGTT on VLV
      drm/i915: leave rc6 enabled at suspend time v4
      drm/i915: send proper opregion notifications on suspend/resume
      drm/i915/vlv: disable PPGTT on early revs v3
      drm/i915: use runtime irq suspend/resume in freeze/thaw
      drm/i915: don't take runtime PM reference around freeze/thaw
      drm/i915: correct BLC vs PWM enable/disable ordering
      drm/i915: don't warn if IRQs are disabled when shutting down display IRQs
      drm/i915: add helper for checking whether IRQs are enabled
      drm/i915: set pm._irqs_disabled at IRQ init time
      drm/i915: clear pm._irqs_disabled field after installing IRQs
      drm/i915: mark IRQs as disabled on unload

Jingoo Han (1):
      drm/exynos: dp: Use correct module license

John Harrison (1):
      drm/i915: Corrected 'file_priv' to 'file' in 'i915_driver_preclose()'

Joonyoung Shim (1):
      drm/exynos: control blending of mixer graphic layer 0

Konrad Zapalowicz (1):
      drivers/i915: Fix unnoticed failure of init_ring_common()

Kristen Carlson Accardi (2):
      drm/i915: disable power wells on suspend
      drm/i915: make sure PC8 is enabled on suspend and disabled on resume v4

Krzysztof Kozlowski (1):
      drm/exynos: Fix NULL pointer exception when suspending without components

Laurent Pinchart (1):
      drm/rcar-du: Fix maximum frame buffer pitch computation

Lauri Kasanen (1):
      drm/radeon: Inline r100_mm_rreg, -wreg, v3

Liu Ying (2):
      drm/fb-helper: Redundant info->fix.type_aux setting in drm_fb_helper_fill_fix()
      drm/fb-helper: Remove unnecessary list empty check in drm_fb_helper_debug_enter()

Lucas Stach (1):
      drm/ttm: recognize ARM arch in ioprot handler

Marek Szyprowski (2):
      drm/exynos: hdmi: make 'hdmi-en' regulator optional and keep it enabled
      drm/exynos: hdmi: enable exynos 4210 and 4x12 soc support

Mario Kleiner (2):
      drm/radeon: Use pflip irqs for pageflip completion if possible. (v2)
      drm/radeon: Prevent hdmi deep color if max_tmds_clock is undefined.

Martin Kepplinger (1):
      ttm: use NULL instead of 0 for ttm_bo_reserve()'s pointer arg.

Mathias Krause (1):
      agp: remove read/write stubs

Matt Roper (17):
      drm/i915: don't force full modeset if primary plane is disabled (v2)
      drm/i915: Intel-specific primary plane handling (v8)
      drm/i915: Drop unused lut tables from intel_plane
      drm: Refactor framebuffer creation to allow internal use (v2)
      drm: Refactor setplane to allow internal use (v3)
      drm: Support legacy cursor ioctls via universal planes when possible (v4)
      drm: Allow drivers to register cursor planes with crtc
      drm/i915: Add intel_crtc_cursor_set_obj() to set cursor buffer (v2)
      drm/i915: Switch to unified plane cursor handling (v4)
      drm/i915: Handle disabled primary plane in debugfs i915_display_info (v2)
      drm/i915: Don't try to look up object for non-existent fb
      drm: Remove command line guard for universal planes
      drm/i915: Introduce intel_fb_obj() macro
      drm/i915: Make use of intel_fb_obj() (v2)
      drm/i915: Add missing locking to primary plane handlers
      drm/i915: Add a couple WARN()'s to catch missing locks
      drm/plane-helper: Use proper plane init function

Michel Dänzer (10):
      drm/radeon: Demote 'BO allocation size too large' message to debug only
      drm/radeon: Remove radeon_gart_restore()
      drm/radeon: Pass GART page flags to radeon_gart_set_page() explicitly
      drm/radeon: Allow write-combined CPU mappings of BOs in GTT (v2)
      drm/radeon: Use write-combined CPU mappings of ring buffers with PCIe
      drm/radeon: Use write-combined CPU mappings of IBs on >= CIK
      drm/radeon/cik: Read back SDMA WPTR register after writing it
      drm/radeon: s/ioctl_wait_idle/mmio_hpd_flush/
      drm/radeon: Always flush the HDP cache before submitting a CS to the GPU
      drm/radeon: Only flush HDP cache from idle ioctl if BO is in VRAM

Michel Thierry (1):
      drm/i915/bdw: 3D_CHICKEN3 has write mask bits

Mika Kuoppala (5):
      drm/i915: remove i915_delayedfreq_table debugfs entry
      drm/i915: remove i915_inttoext_table debugfs entry
      drm/i915: remove i915_gfxec debugfs entry
      drm/i915: remove i915_rstdby_delays debugfs entry
      drm/i915/chv: calculate rc6 residency correctly

Oscar Mateo (14):
      drm/i915/bdw: Do not write the Semaphore Sync Registers in GEN8+
      drm/i915: Ack interrupts before handling them (GEN5 - GEN7)
      drm/i915/vlv: Ack interrupts before handling them (VLV)
      drm/i915/bdw: Ack interrupts before handling them (GEN8)
      drm/i915/chv: Ack interrupts before handling them (CHV)
      drm/i915: Remove ctx->last_ring
      drm/i915: Extract context backing object allocation
      drm/i915: Emphasize that ctx->obj & ctx->is_initialized refer to the legacy rcs ctx
      drm/i915: Emphasize that ctx->id is merely a user handle
      drm/i915: Add kerneldoc comments to the intel_context struct
      drm/i915: Extract ringbuffer destroy & generalize alloc to take a ringbuf
      drm/i915: Generalize ring_space to take a ringbuf
      drm/i915: Generalize intel_ring_get_tail to take a ringbuf
      drm/i915: Extract the actual workload submission mechanism from execbuffer

Paulo Zanoni (19):
      drm/i915: update BDW DDI buffer translations
      drm/i915: update intel_dp_voltage_max comment
      drm/i915: flush delayed_resume_work when suspending
      drm/i915: fix hsw_write_dcomp() error message
      drm/i915: fix D_COMP usage on BDW
      drm/i915: get/put runtime PM at i915_semaphore_status
      drm/i915: BDW also has special-purpose DP DDI clocks
      drm/i915: add POWER_DOMAIN_PLLS
      drm/i915: don't skip shared DPLL assertion on LPT
      drm/i915: check the power domains in ironlake_get_pipe_config()
      drm/i915: check the power domains in intel_lvds_get_hw_state()
      drm/i915: don't read LVDS regs at compute_config time
      drm/i915: remove useless runtime PM get calls
      drm/i915: don't write powered down IRQ registers on Gen 8
      drm/i915: HSW_BLC_PWM2_CTL doesn't exist on BDW
      drm/i915: extract and improve gen8_irq_power_well_post_enable
      drm/i915: reorganize the unclaimed register detection code
      drm/i915: BDW can also detect unclaimed registers
      drm/i915: remove plane/cursor/pipe assertions from intel_crtc_disable

Rob Clark (20):
      drm: fix uninitialized acquire_ctx fields (v2)
      drm/ast: use helpers
      drm/bochs: use helpers
      drm/cirrus: use helpers
      drm/exynos: use helpers
      drm/mgag200: use helpers
      drm/udl: use helpers
      drm/vmwgfx: use helpers
      drm/nouveau: use helpers
      drm/i915: use helpers
      drm/radeon: use helpers
      drm/msm: fix double struct_mutex acquire
      drm/msm: DT support for 8960/8064 (v3)
      drm/msm: update generated headers
      drm/msm: hdmi phy 8960 phy pll
      drm/msm/mdp4: add mdp axi clk
      drm/msm: fix BUG_ON() in error cleanup path
      drm/msm: no mmu is only error if not using vram carveout
      drm/msm: use upstream iommu
      drm/msm: fix potential deadlock in gpu init

Robert Beckett (1):
      drm/i915: Simplify intel_gpu_reset

Robin Schroer (1):
      drivers/gpu/drm/i915/dma: style fixes

Rodrigo Vivi (18):
      drm/i915: move psr_setup_done to psr struct
      drm/i915: Fix VLV CRC reading.
      drm/i915: Use HAS_PSR to avoid unecessary interactions.
      drm/i915: Don't let update_psr function actually enable PSR.
      drm/i915: Do not try to enable PSR when Panel doesn't suport it.
      drm/i915: BDW PSR: Add single frame update support.
      drm/i915: BDW PSR: Remove limitations that aren't valid for BDW.
      drm/i915: BDW PSR: Remove DDIA limitation for Broadwell.
      drm/i915: PSR HSW: update after enabling sprite.
      drm/i915: Force PSR exit by inactivating it.
      drm/i915: Improve PSR debugfs status.
      drm/i915: Don't pretend ips is always enabled on BDW.
      drm/i915: Fix VCS2's ring name.
      drm/i915: Updating comments.
      drm/i915: Implement MI decode for gen8
      drm/i915: Enable semaphores on BDW
      drm/i915: Enable PSR by default.
      drm/i915: Fix possible overflow when recording semaphore states.

Russell King (21):
      drm/armada: move IRQ handling into CRTC
      drm/armada: use number of CRTCs registered
      drm/armada: move variant initialisation to CRTC init
      drm/armada: make variant a CRTC thing
      drm: msm: update to use component match support
      drm: add of_graph endpoint helper to find possible CRTCs
      Merge branches 'drm-devel' and 'component-for-driver' into armada-drm
      drm/armada: convert to componentized support
      drm/armada: update Armada 510 (Dove) to use "ext_ref_clk1" as the clock
      dt-bindings: add Marvell Dove LCD controller documentation
      drm/armada: permit CRTCs to be registered as separate devices
      drm/armada: register crtc with port
      drm/panel: consolidate unnecessary explicit dependencies
      drm/panel: make DRM_PANEL_LD9040 depend on SPI
      drm: rcar-du: fix warnings
      drm: shmobile: fix warnings
      drm: cirrus: fix warnings
      drm: bochs: fix warnings
      drm: omapdrm: fix compiler errors
      drm/i2c: tda998x: allow re-use of tda998x support code
      drm/i2c: tda998x: add component support

Sachin Kamat (4):
      drm/tilcdc: Fix build breakage
      drm: gem_cma: Use ERR_CAST helper
      drm/exynos: Remove unused variable from exynos_hdmi.c
      drm/exynos: Remove unused variable in exynos_drm_gem.c

Sagar Kamble (2):
      Documentation: drm: Removing placeholders for generic drm properties description
      Documentation: drm: describing rotation property

Sean Paul (1):
      drm: Check for connection_mutex in drm_select_eld

Seung-Woo Kim (1):
      drm/exynos: hdmi: add null check for hdmiphy_port

Shashank Sharma (2):
      drm/i915: Change Mipi register definitions
      drm/i915: Use transcoder as index to MIPI regs

Shobhit Kumar (1):
      drm/i915: Fix checkpatch errors

Sjoerd Simons (3):
      Subject: Revert "drm/exynos: fix module build error"
      Subject: Revert "drm/exynos: remove MODULE_DEVICE_TABLE definitions"
      drm/exynos: Add MODULE_DEVICE_TABLE entries for various components

Sonika Jindal (8):
      drm/i915: Adding HAS_GMCH_DISPLAY macro
      drm/i915: Allowing changing of wm latencies for valid platforms
      drm/i915: Returning the right VGA control reg for platforms
      drm/i915: Writing proper check for reading of pipe status reg
      drm/i915: Avoid incorrect returning for some platforms
      drm/i915: Setting legacy palette correctly for different platforms
      drm/i915: Returning from increase/decrease of pllclock when invalid
      drm/i915: Replace HAS_PCH_SPLIT which incorrectly lets some platforms in

Sourab Gupta (1):
      drm/i915: Replaced Blitter ring based flips with MMIO flips

Stefan Brüns (2):
      drm/radeon: Use correct value for unknown audio/video latency
      drm/radeon/audio: break out of loops once we match connector

Stephane Viau (2):
      drm/msm: activate iommu support
      drm/msm/mdp5: add support for MDP5 v1.3

Stephen Warren (1):
      drm/tegra: add MODULE_DEVICE_TABLEs

Stéphane Marchesin (4):
      drm/udl: add vblank support
      drm/udl: Implement page_flip ioctl
      drm/panel: simple: Add bits-per-color support
      drm/tegra: sor - Use bits-per-color from panel

Tetsuo Handa (5):
      drm/ttm: Fix possible division by 0 in ttm_dma_pool_shrink_scan().
      drm/ttm: Choose a pool to shrink correctly in ttm_dma_pool_shrink_scan().
      drm/ttm: Use mutex_trylock() to avoid deadlock inside shrinker functions.
      drm/ttm: Fix possible stack overflow by recursive shrinker calls.
      drm/ttm: Pass GFP flags in order to avoid deadlock.

Thierry Reding (23):
      drm: Constify struct drm_fb_helper_funcs
      drm: Introduce drm_fb_helper_prepare()
      drm/tegra: Implement race-free hotplug detection
      drm: Fix function names in kerneldoc
      drm: Add missing __user annotation
      drm/ttm: Fix a few sparse warnings
      drm/dp: Staticize a couple of DP utility functions
      drm/dsi: Make mipi_dsi_dcs_write() return ssize_t
      drm/dsi: Use peripheral's channel for DCS commands
      drm/panel: s6e8aa0: Use static inline for upcasting
      Merge branch 'drm/dsi/for-next' into drm/tegra/for-next
      drm/tegra: Implement more tiling modes
      drm/tegra: Add SET/GET_TILING IOCTLs
      drm/tegra: Add SET/GET_FLAGS IOCTLs
      drm/tegra: Allow non-authenticated processes to create buffer objects
      drm/tegra: Make job submission 64-bit safe
      drm/tegra: sor - Configure proper sync polarities
      drm/tegra: Properly align stride for framebuffers
      drm/tegra: dc - Reset controller on driver remove
      drm/panel: simple: Add Innolux N116BGE panel support
      drm/panel: simple: Remove simple-panel compatible
      drm/panel: ld9040: Replace upcasting macro by function
      drm/dsi: Replace upcasting macro by function

Thomas Hellstrom (1):
      drm/vmwgfx: Fix compat shader namespace

Thomas Wood (3):
      drm: add register and unregister functions for connectors
      drm/debugfs: add a "force" file per connector
      drm/debugfs: add an "edid_override" file per connector

Tobias Jakobi (2):
      drm/exynos: g2d: make ioctls more robust
      drm/exynos: g2d: let exynos_g2d_get_ver_ioctl fail

Tom O'Rourke (3):
      drm/i915/bdw: Add Broadwell support for debugfs rps freq info
      drm/i915/chv: Fix "drm/i915/chv: Add a bunch of pre production workarounds"
      drm/i915/bdw: Use timeout mode for RC6 on bdw

Vandana Kannan (4):
      drm/crtc: Add property for aspect ratio
      drm/edid: Check for user aspect ratio input
      drm/i915: Add aspect ratio property for HDMI
      Documentation/drm: Describing aspect ratio property

Ville Syrjälä (34):
      drm/i915: Keep vblank interrupts enabled while enabling/disabling planes
      drm/i915/chv: CHV doesn't need WaRsForcewakeWaitTC0
      drm/i915/chv: Skip gen6_gt_check_fifodbg() on CHV
      drm/i915/chv: Try to program the PHY used clock channel overrides
      drm/i915/chv: Force clock buffer enables
      drm/i915/chv: Force PHY clock buffers off after PLL disable
      drm/i915: Don't use pipe_offset stuff for DPLL registers
      drm/i915/chv: Handle video DIP registers on CHV
      drm/i915: Use named initializers for gmch wm params
      drm/i915: Don't get hw state from DVO chip unless DVO is enabled
      drm/i915: Add locking around framebuffer_references--
      drm/i915: Print PCI revision in i915_dump_device_info()
      drm/i915: Fix __user sparse warning
      drm/i915: Don't prefault the entire obj if the vma is smaller
      drm/i915: Change vlv cdclk to use kHz units
      drm/i915: Give names to the CCK_DISPLAY_CLOCK_CONTROL bits
      drm/i915: Move vlv cdclk code to .get_display_clock_speed()
      drm/i915: Handle 320 vs. 333 MHz cdclk on vlv
      drm/i915: Use 200MHz cdclk on vlv when all pipes are off
      drm/i915: Wait for cdclk change to occure when going for 400MHz
      drm/i915: Warn if there's a cdclk change in progess
      drm/i915: Kill duplicated cdclk readout code from i2c
      drm/i915: Pull the cmnlane tricks into its own power well ops
      drm/i915: Move VLV cmnlane workaround to intel_power_domains_init_hw()
      drm/i915: Unpin last_context at reset
      drm/i915: Don't disable PPGTT for CHV based in PCI rev
      drm/i915: Use the cached min/min/rpe values in the vlv debugfs code
      drm/i915: Call encoder->post_disable() in intel_sanitize_encoder()
      drm: Move DRM_ROTATE bits out of omapdrm into drm_crtc.h
      drm: Add support_bits parameter to drm_property_create_bitmask()
      drm: Add drm_mode_create_rotation_property()
      drm/omap: Switch omapdrm over to drm_mode_create_rotation_property()
      drm: Add drm_rect rotation functions
      drm: Add drm_rotation_simplify()

YoungJun Cho (12):
      drm/exynos: dsi: move the EoT packets configuration point
      drm/exynos: use wait_event_timeout() for safety usage
      ARM: dts: samsung-fimd: add LCD I80 interface specific properties
      drm/exynos: add TE handler to support LCD I80 interface
      drm/exynos: dsi: add TE interrupt handler to support LCD I80 interface
      drm/exynos: fimd: support LCD I80 interface
      ARM: dts: exynos_dsim: add exynos5410 compatible to DT bindings
      drm/exynos: dsi: add driver data to support Exynos5410/5420/5440 SoCs
      ARM: dts: exynos4: add system register property
      ARM: dts: exynos5: add system register property
      ARM: dts: exynos5420: add mipi-phy node
      ARM: dts: exynos5420: add dsi node

 Documentation/DocBook/drm.tmpl                     |   89 +-
 .../bindings/drm/armada/marvell,dove-lcd.txt       |   30 +
 .../devicetree/bindings/drm/i2c/tda998x.txt        |    2 +
 Documentation/devicetree/bindings/drm/msm/gpu.txt  |   52 +
 Documentation/devicetree/bindings/drm/msm/hdmi.txt |   46 +
 Documentation/devicetree/bindings/drm/msm/mdp.txt  |   48 +
 .../devicetree/bindings/gpu/st,stih4xx.txt         |  189 ++
 .../devicetree/bindings/panel/auo,b133htn01.txt    |    7 +
 .../bindings/panel/foxlink,fl500wvr00-a0t.txt      |    7 +
 .../devicetree/bindings/panel/innolux,n116bge.txt  |    7 +
 .../bindings/panel/innolux,n156bge-l21.txt         |    7 +
 .../devicetree/bindings/video/exynos_dsim.txt      |    4 +-
 .../devicetree/bindings/video/exynos_mixer.txt     |    5 +-
 .../devicetree/bindings/video/samsung-fimd.txt     |   28 +
 arch/arm/boot/dts/exynos4.dtsi                     |    1 +
 arch/arm/boot/dts/exynos5.dtsi                     |    1 +
 arch/arm/boot/dts/exynos5420.dtsi                  |   20 +
 drivers/base/component.c                           |  192 +-
 drivers/char/agp/frontend.c                        |   15 -
 drivers/gpu/drm/Kconfig                            |    3 +
 drivers/gpu/drm/Makefile                           |    8 +-
 drivers/gpu/drm/armada/armada_510.c                |   23 +-
 drivers/gpu/drm/armada/armada_crtc.c               |  187 +-
 drivers/gpu/drm/armada/armada_crtc.h               |   11 +-
 drivers/gpu/drm/armada/armada_drm.h                |   13 +-
 drivers/gpu/drm/armada/armada_drv.c                |  245 +-
 drivers/gpu/drm/armada/armada_fbdev.c              |    4 +-
 drivers/gpu/drm/armada/armada_output.c             |    4 +-
 drivers/gpu/drm/ast/ast_drv.h                      |    2 +-
 drivers/gpu/drm/ast/ast_fb.c                       |    6 +-
 drivers/gpu/drm/ast/ast_mode.c                     |   16 +-
 drivers/gpu/drm/bochs/bochs_drv.c                  |    2 +
 drivers/gpu/drm/bochs/bochs_fbdev.c                |    7 +-
 drivers/gpu/drm/bochs/bochs_kms.c                  |   17 +-
 drivers/gpu/drm/bochs/bochs_mm.c                   |    2 +-
 drivers/gpu/drm/bridge/ptn3460.c                   |    2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c                |    2 +
 drivers/gpu/drm/cirrus/cirrus_drv.h                |    2 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c              |    6 +-
 drivers/gpu/drm/cirrus/cirrus_mode.c               |   14 +-
 drivers/gpu/drm/drm_buffer.c                       |    6 +-
 drivers/gpu/drm/drm_bufs.c                         |   17 +-
 drivers/gpu/drm/drm_context.c                      |  102 +-
 drivers/gpu/drm/drm_crtc.c                         |  604 ++++-
 drivers/gpu/drm/drm_crtc_helper.c                  |    1 +
 drivers/gpu/drm/drm_debugfs.c                      |  182 ++
 drivers/gpu/drm/drm_dp_mst_topology.c              | 2715 ++++++++++++++++++++
 drivers/gpu/drm/drm_drv.c                          | 1190 ++++++---
 drivers/gpu/drm/drm_edid.c                         |   11 +-
 drivers/gpu/drm/drm_fb_cma_helper.c                |    5 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  115 +-
 drivers/gpu/drm/drm_fops.c                         |   85 +-
 drivers/gpu/drm/drm_gem.c                          |   29 +-
 drivers/gpu/drm/drm_gem_cma_helper.c               |    2 +-
 drivers/gpu/drm/drm_info.c                         |    2 +-
 drivers/gpu/drm/drm_ioctl.c                        |  372 ++-
 drivers/gpu/drm/drm_legacy.h                       |   51 +
 drivers/gpu/drm/drm_lock.c                         |    1 +
 drivers/gpu/drm/drm_mipi_dsi.c                     |   14 +-
 drivers/gpu/drm/drm_of.c                           |   67 +
 drivers/gpu/drm/drm_plane_helper.c                 |    7 +-
 drivers/gpu/drm/drm_probe_helper.c                 |    9 +-
 drivers/gpu/drm/drm_rect.c                         |  140 +
 drivers/gpu/drm/drm_stub.c                         |  805 ------
 drivers/gpu/drm/drm_sysfs.c                        |   92 +-
 drivers/gpu/drm/exynos/Kconfig                     |    2 +
 drivers/gpu/drm/exynos/exynos_dp_core.c            |  117 +-
 drivers/gpu/drm/exynos/exynos_dp_core.h            |    3 +-
 drivers/gpu/drm/exynos/exynos_drm_connector.c      |   21 +-
 drivers/gpu/drm/exynos/exynos_drm_crtc.c           |   15 +-
 drivers/gpu/drm/exynos/exynos_drm_crtc.h           |    7 +
 drivers/gpu/drm/exynos/exynos_drm_dpi.c            |   12 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |    8 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |   12 +-
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            |  285 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |    5 +-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |    1 +
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  277 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   29 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |    3 -
 drivers/gpu/drm/exynos/exynos_drm_ipp.c            |  259 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.h            |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |    1 +
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |    2 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   38 +-
 drivers/gpu/drm/exynos/exynos_mixer.c              |   57 +-
 drivers/gpu/drm/gma500/cdv_intel_crt.c             |    4 +-
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |    4 +-
 drivers/gpu/drm/gma500/cdv_intel_hdmi.c            |    4 +-
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |    4 +-
 drivers/gpu/drm/gma500/framebuffer.c               |    5 +-
 drivers/gpu/drm/gma500/gtt.c                       |    2 +-
 drivers/gpu/drm/gma500/mdfld_dsi_output.c          |    4 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |    2 +-
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |    2 +-
 drivers/gpu/drm/gma500/psb_intel_lvds.c            |    4 +-
 drivers/gpu/drm/gma500/psb_intel_sdvo.c            |    4 +-
 drivers/gpu/drm/i2c/tda998x_drv.c                  |  390 ++-
 drivers/gpu/drm/i915/Kconfig                       |   12 -
 drivers/gpu/drm/i915/Makefile                      |    1 +
 drivers/gpu/drm/i915/i915_cmd_parser.c             |    3 +
 drivers/gpu/drm/i915/i915_debugfs.c                |  425 +--
 drivers/gpu/drm/i915/i915_dma.c                    |   73 +-
 drivers/gpu/drm/i915/i915_drv.c                    |   74 +-
 drivers/gpu/drm/i915/i915_drv.h                    |  189 +-
 drivers/gpu/drm/i915/i915_gem.c                    |   93 +-
 drivers/gpu/drm/i915/i915_gem_context.c            |  149 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  308 ++-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |   55 +-
 drivers/gpu/drm/i915/i915_gem_gtt.h                |    5 +-
 drivers/gpu/drm/i915/i915_gem_render_state.c       |  161 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c             |  104 +-
 drivers/gpu/drm/i915/i915_gem_userptr.c            |  149 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |   89 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  624 +++--
 drivers/gpu/drm/i915/i915_params.c                 |   15 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  500 ++--
 drivers/gpu/drm/i915/i915_sysfs.c                  |   57 +-
 drivers/gpu/drm/i915/intel_bios.c                  |    3 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   38 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |  474 ++--
 drivers/gpu/drm/i915/intel_display.c               | 1465 ++++++++---
 drivers/gpu/drm/i915/intel_dp.c                    |  678 +++--
 drivers/gpu/drm/i915/intel_dp_mst.c                |  548 ++++
 drivers/gpu/drm/i915/intel_drv.h                   |  154 +-
 drivers/gpu/drm/i915/intel_dsi.c                   |   28 +-
 drivers/gpu/drm/i915/intel_dsi_panel_vbt.c         |    8 +-
 drivers/gpu/drm/i915/intel_dvo.c                   |   10 +-
 drivers/gpu/drm/i915/intel_fbdev.c                 |   37 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |  102 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |   54 -
 drivers/gpu/drm/i915/intel_lvds.c                  |   20 +-
 drivers/gpu/drm/i915/intel_opregion.c              |    3 +-
 drivers/gpu/drm/i915/intel_overlay.c               |   22 +-
 drivers/gpu/drm/i915/intel_panel.c                 |  160 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  897 +++++--
 drivers/gpu/drm/i915/intel_renderstate.h           |    2 -
 drivers/gpu/drm/i915/intel_renderstate_gen6.c      |    1 +
 drivers/gpu/drm/i915/intel_renderstate_gen7.c      |    1 +
 drivers/gpu/drm/i915/intel_renderstate_gen8.c      |    1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  444 ++--
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   90 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   10 +-
 drivers/gpu/drm/i915/intel_sprite.c                |   36 +-
 drivers/gpu/drm/i915/intel_tv.c                    |    2 +-
 drivers/gpu/drm/i915/intel_uncore.c                |  212 +-
 drivers/gpu/drm/mgag200/mgag200_drv.h              |    2 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c               |    5 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   16 +-
 drivers/gpu/drm/msm/Kconfig                        |    1 -
 drivers/gpu/drm/msm/adreno/a2xx.xml.h              |   58 +-
 drivers/gpu/drm/msm/adreno/a3xx.xml.h              |  296 ++-
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |    7 +-
 drivers/gpu/drm/msm/adreno/a3xx_gpu.h              |    5 +
 drivers/gpu/drm/msm/adreno/adreno_common.xml.h     |   56 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   14 +-
 drivers/gpu/drm/msm/adreno/adreno_pm4.xml.h        |  239 +-
 drivers/gpu/drm/msm/dsi/dsi.xml.h                  |    4 +-
 drivers/gpu/drm/msm/dsi/mmss_cc.xml.h              |    4 +-
 drivers/gpu/drm/msm/dsi/sfpb.xml.h                 |    4 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   69 +-
 drivers/gpu/drm/msm/hdmi/hdmi.h                    |    1 +
 drivers/gpu/drm/msm/hdmi/hdmi.xml.h                |  109 +-
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c          |   27 +-
 drivers/gpu/drm/msm/hdmi/hdmi_phy_8960.c           |  377 ++-
 drivers/gpu/drm/msm/hdmi/qfprom.xml.h              |    4 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4.xml.h            |    4 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c            |   25 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.h            |    1 +
 drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h            |  431 ++--
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c            |  159 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h            |   25 +
 drivers/gpu/drm/msm/mdp/mdp_common.xml.h           |    4 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   91 +-
 drivers/gpu/drm/msm/msm_fbdev.c                    |   49 +-
 drivers/gpu/drm/msm/msm_gem.c                      |   17 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   12 +-
 drivers/gpu/drm/msm/msm_iommu.c                    |   31 +-
 drivers/gpu/drm/msm/msm_mmu.h                      |    8 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |    6 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   20 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |    5 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |    4 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |    3 +
 drivers/gpu/drm/omapdrm/omap_connector.c           |    4 +-
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c           |    6 +-
 drivers/gpu/drm/omapdrm/omap_drv.h                 |    7 -
 drivers/gpu/drm/omapdrm/omap_fbdev.c               |    4 +-
 drivers/gpu/drm/omapdrm/omap_gem.c                 |   33 +-
 drivers/gpu/drm/omapdrm/omap_plane.c               |   21 +-
 drivers/gpu/drm/panel/Kconfig                      |    7 +-
 drivers/gpu/drm/panel/panel-ld9040.c               |   21 +-
 drivers/gpu/drm/panel/panel-s6e8aa0.c              |   29 +-
 drivers/gpu/drm/panel/panel-simple.c               |  203 +-
 drivers/gpu/drm/qxl/qxl_display.c                  |    4 +-
 drivers/gpu/drm/qxl/qxl_fb.c                       |    7 +-
 drivers/gpu/drm/qxl/qxl_object.h                   |    4 +-
 drivers/gpu/drm/radeon/Makefile                    |    2 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   16 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |   13 +-
 drivers/gpu/drm/radeon/ci_smc.c                    |   39 +-
 drivers/gpu/drm/radeon/cik.c                       |  722 ++++--
 drivers/gpu/drm/radeon/cik_sdma.c                  |  247 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                 |   16 +-
 drivers/gpu/drm/radeon/evergreen.c                 |   18 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |    4 +-
 drivers/gpu/drm/radeon/ni.c                        |    1 -
 drivers/gpu/drm/radeon/ni_dma.c                    |  178 +-
 drivers/gpu/drm/radeon/r100.c                      |   62 +-
 drivers/gpu/drm/radeon/r300.c                      |   13 +-
 drivers/gpu/drm/radeon/r600.c                      |   24 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |    6 +-
 drivers/gpu/drm/radeon/radeon.h                    |  127 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |   79 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   77 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |   83 +-
 drivers/gpu/drm/radeon/radeon_benchmark.c          |    4 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |  388 ++-
 drivers/gpu/drm/radeon/radeon_cs.c                 |    3 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   87 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   72 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   14 +-
 drivers/gpu/drm/radeon/radeon_encoders.c           |    4 +-
 drivers/gpu/drm/radeon/radeon_fb.c                 |    9 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |   38 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |   58 +-
 drivers/gpu/drm/radeon/radeon_ib.c                 |  319 +++
 drivers/gpu/drm/radeon/radeon_kms.c                |   13 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |    4 +-
 drivers/gpu/drm/radeon/radeon_object.c             |   63 +-
 drivers/gpu/drm/radeon/radeon_object.h             |    6 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |   16 +-
 drivers/gpu/drm/radeon/radeon_prime.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |  287 +--
 drivers/gpu/drm/radeon/radeon_sa.c                 |    4 +-
 drivers/gpu/drm/radeon/radeon_test.c               |   12 +-
 drivers/gpu/drm/radeon/radeon_trace.h              |   22 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   10 +-
 drivers/gpu/drm/radeon/radeon_ucode.c              |  167 ++
 drivers/gpu/drm/radeon/radeon_ucode.h              |   71 +
 drivers/gpu/drm/radeon/radeon_uvd.c                |    6 +-
 drivers/gpu/drm/radeon/radeon_vce.c                |    2 +-
 drivers/gpu/drm/radeon/radeon_vm.c                 |  278 +-
 drivers/gpu/drm/radeon/rs400.c                     |   14 +-
 drivers/gpu/drm/radeon/rs600.c                     |   17 +-
 drivers/gpu/drm/radeon/rv770.c                     |    1 -
 drivers/gpu/drm/radeon/si.c                        |  460 +++-
 drivers/gpu/drm/radeon/si_dma.c                    |  172 +-
 drivers/gpu/drm/radeon/si_dpm.c                    |  152 +-
 drivers/gpu/drm/radeon/si_dpm.h                    |    5 +
 drivers/gpu/drm/radeon/si_smc.c                    |   62 +-
 drivers/gpu/drm/radeon/sislands_smc.h              |    3 +
 drivers/gpu/drm/rcar-du/rcar_du_drv.c              |    2 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.c              |   13 +-
 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c          |    4 +-
 drivers/gpu/drm/rcar-du/rcar_du_vgacon.c           |    4 +-
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c          |    6 +-
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |    2 +-
 drivers/gpu/drm/sti/Kconfig                        |   14 +
 drivers/gpu/drm/sti/Makefile                       |   21 +
 drivers/gpu/drm/sti/NOTES                          |   58 +
 drivers/gpu/drm/sti/sti_compositor.c               |  281 ++
 drivers/gpu/drm/sti/sti_compositor.h               |   90 +
 drivers/gpu/drm/sti/sti_drm_crtc.c                 |  421 +++
 drivers/gpu/drm/sti/sti_drm_crtc.h                 |   22 +
 drivers/gpu/drm/sti/sti_drm_drv.c                  |  241 ++
 drivers/gpu/drm/sti/sti_drm_drv.h                  |   29 +
 drivers/gpu/drm/sti/sti_drm_plane.c                |  195 ++
 drivers/gpu/drm/sti/sti_drm_plane.h                |   18 +
 drivers/gpu/drm/sti/sti_gdp.c                      |  549 ++++
 drivers/gpu/drm/sti/sti_gdp.h                      |   16 +
 drivers/gpu/drm/sti/sti_hda.c                      |  794 ++++++
 drivers/gpu/drm/sti/sti_hdmi.c                     |  810 ++++++
 drivers/gpu/drm/sti/sti_hdmi.h                     |   88 +
 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c         |  336 +++
 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.h         |   14 +
 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c         |  211 ++
 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.h         |   14 +
 drivers/gpu/drm/sti/sti_layer.c                    |  197 ++
 drivers/gpu/drm/sti/sti_layer.h                    |  123 +
 drivers/gpu/drm/sti/sti_mixer.c                    |  249 ++
 drivers/gpu/drm/sti/sti_mixer.h                    |   54 +
 drivers/gpu/drm/sti/sti_tvout.c                    |  648 +++++
 drivers/gpu/drm/sti/sti_vid.c                      |  138 +
 drivers/gpu/drm/sti/sti_vid.h                      |   12 +
 drivers/gpu/drm/sti/sti_vtac.c                     |  215 ++
 drivers/gpu/drm/sti/sti_vtg.c                      |  366 +++
 drivers/gpu/drm/sti/sti_vtg.h                      |   28 +
 drivers/gpu/drm/tegra/dc.c                         |  123 +-
 drivers/gpu/drm/tegra/dc.h                         |    5 +
 drivers/gpu/drm/tegra/dpaux.c                      |    1 +
 drivers/gpu/drm/tegra/drm.c                        |  216 +-
 drivers/gpu/drm/tegra/drm.h                        |   11 +-
 drivers/gpu/drm/tegra/dsi.c                        |    4 +-
 drivers/gpu/drm/tegra/fb.c                         |   66 +-
 drivers/gpu/drm/tegra/gem.c                        |    5 +-
 drivers/gpu/drm/tegra/gem.h                        |   16 +-
 drivers/gpu/drm/tegra/gr2d.c                       |    1 +
 drivers/gpu/drm/tegra/gr3d.c                       |    1 +
 drivers/gpu/drm/tegra/hdmi.c                       |    1 +
 drivers/gpu/drm/tegra/output.c                     |    6 +-
 drivers/gpu/drm/tegra/sor.c                        |   21 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |   15 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.h                |    1 -
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |   41 +-
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              |   29 +-
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c             |   37 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   20 +-
 drivers/gpu/drm/ttm/ttm_bo_manager.c               |    3 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    2 +-
 drivers/gpu/drm/ttm/ttm_module.c                   |    2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c               |   31 +-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |   34 +-
 drivers/gpu/drm/udl/udl_connector.c                |   13 +-
 drivers/gpu/drm/udl/udl_fb.c                       |    5 +-
 drivers/gpu/drm/udl/udl_gem.c                      |    8 +-
 drivers/gpu/drm/udl/udl_main.c                     |   15 +
 drivers/gpu/drm/udl/udl_modeset.c                  |   21 +
 drivers/gpu/drm/vmwgfx/Makefile                    |    3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c         |  341 +++
 drivers/gpu/drm/vmwgfx/vmwgfx_context.c            |   38 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c             |    6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |    9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   74 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  227 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c      |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   12 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c               |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |  396 +--
 drivers/gpu/host1x/job.c                           |   22 +-
 drivers/gpu/vga/vgaarb.c                           |   40 +-
 drivers/staging/imx-drm/imx-drm-core.c             |    6 +-
 include/drm/drmP.h                                 |   89 +-
 include/drm/drm_crtc.h                             |   36 +-
 include/drm/drm_dp_mst_helper.h                    |  509 ++++
 include/drm/drm_fb_helper.h                        |    8 +-
 include/drm/drm_mipi_dsi.h                         |   21 +-
 include/drm/drm_of.h                               |   18 +
 include/drm/drm_panel.h                            |   58 +
 include/drm/drm_rect.h                             |    6 +
 include/drm/ttm/ttm_bo_driver.h                    |   14 +-
 include/linux/component.h                          |    7 +
 include/linux/host1x.h                             |   15 +-
 include/uapi/drm/drm.h                             |    2 +-
 include/uapi/drm/drm_mode.h                        |    5 +
 include/uapi/drm/radeon_drm.h                      |    4 +-
 include/uapi/drm/tegra_drm.h                       |   46 +
 include/video/samsung_fimd.h                       |    3 +-
 350 files changed, 26798 insertions(+), 7499 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/drm/armada/marvell,dove-lcd.txt
 create mode 100644 Documentation/devicetree/bindings/drm/msm/gpu.txt
 create mode 100644 Documentation/devicetree/bindings/drm/msm/hdmi.txt
 create mode 100644 Documentation/devicetree/bindings/drm/msm/mdp.txt
 create mode 100644 Documentation/devicetree/bindings/gpu/st,stih4xx.txt
 create mode 100644 Documentation/devicetree/bindings/panel/auo,b133htn01.txt
 create mode 100644 Documentation/devicetree/bindings/panel/foxlink,fl500wvr00-a0t.txt
 create mode 100644 Documentation/devicetree/bindings/panel/innolux,n116bge.txt
 create mode 100644 Documentation/devicetree/bindings/panel/innolux,n156bge-l21.txt
 create mode 100644 drivers/gpu/drm/drm_dp_mst_topology.c
 create mode 100644 drivers/gpu/drm/drm_legacy.h
 create mode 100644 drivers/gpu/drm/drm_of.c
 delete mode 100644 drivers/gpu/drm/drm_stub.c
 create mode 100644 drivers/gpu/drm/i915/intel_dp_mst.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_ib.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_ucode.c
 create mode 100644 drivers/gpu/drm/sti/Kconfig
 create mode 100644 drivers/gpu/drm/sti/Makefile
 create mode 100644 drivers/gpu/drm/sti/NOTES
 create mode 100644 drivers/gpu/drm/sti/sti_compositor.c
 create mode 100644 drivers/gpu/drm/sti/sti_compositor.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.h
 create mode 100644 drivers/gpu/drm/sti/sti_gdp.c
 create mode 100644 drivers/gpu/drm/sti/sti_gdp.h
 create mode 100644 drivers/gpu/drm/sti/sti_hda.c
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi.c
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi.h
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.h
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.h
 create mode 100644 drivers/gpu/drm/sti/sti_layer.c
 create mode 100644 drivers/gpu/drm/sti/sti_layer.h
 create mode 100644 drivers/gpu/drm/sti/sti_mixer.c
 create mode 100644 drivers/gpu/drm/sti/sti_mixer.h
 create mode 100644 drivers/gpu/drm/sti/sti_tvout.c
 create mode 100644 drivers/gpu/drm/sti/sti_vid.c
 create mode 100644 drivers/gpu/drm/sti/sti_vid.h
 create mode 100644 drivers/gpu/drm/sti/sti_vtac.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtg.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtg.h
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
 create mode 100644 include/drm/drm_dp_mst_helper.h
 create mode 100644 include/drm/drm_of.h
--29444707-387882669-1407450429=:15178--
