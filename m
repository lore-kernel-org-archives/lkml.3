Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaDHA6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 20:58:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54393 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaDHA6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 20:58:41 -0400
Date: Tue, 8 Apr 2014 01:58:38 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm merge for v3.15-rc1
Message-ID: <alpine.DEB.2.00.1404080157570.1523@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1725652128-1396918718=:1523"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1725652128-1396918718=:1523
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Merge window tree for drm,

Highlights:
drm: generic display port aux features, primary plane support, drm master management fixes, logging cleanups, enforced locking checks (instead of docs), documentation improvements, minor number handling cleanup, pseudofs for shared inodes.

ttm: add ability to allocate from both ends

i915: broadwell features, power domain and runtime pm, per-process address space infrastructure (not enabled)

msm: power management, hdmi audio support

nouveau: ongoing GPU fault recovery, initial maxwell support, random fixes

exynos: refactored driver to clean up a lot of abstraction, DP support moved into drm, LVDS bridge support added,
parallel panel support,

gma500: SGX MMU support, SGX irq handling, asle irq work fixes,

radeon: video engine bringup, ring handling fixes, use dp aux helpers,

vmwgfx: add rendernode support

This has some small merge conflicts, all the staging ones are choose what is in your tree, the kconfig one is drop the stanza and the mmu.c one is trivial,

Dave.

The following changes since commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14 (2014-03-30 20:40:15 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to c39b06951f1dc2e384650288676c5b7dcc0ec92c:

  DRM: armada: fix corruption while loading cursors (2014-04-08 10:51:03 +1000)

----------------------------------------------------------------
Akash Goel (1):
      drm/i915: Remove the enabling of VS_TIMER_DISPATCH bit in MI MODE reg

Alex Deucher (23):
      drm/radeon: add callback for setting vce clocks
      drm/radeon/dpm: move platform caps fetching to a separate function
      drm/radeon/dpm: fill in some initial vce infrastructure
      drm/radeon/dpm: fetch vce states from the vbios
      drm/radeon: fill in set_vce_clocks for CIK asics
      drm/radeon: add vce dpm support for CI
      drm/radeon: enable vce dpm on CI
      drm/radeon: add vce dpm support for KV/KB
      drm/radeon/dpm: enable dynamic vce state switching v2
      drm/radeon/dpm: properly enable/disable vce when vce pg is enabled
      drm/radeon: add support for vce 2.0 clock gating
      drm/radeon/cik: enable/disable vce cg when encoding v2
      drm/radeon: use variable UVD clocks
      drm/radeon/dp: use i2c_get_adapdata rather than casting
      drm/radeon/dp: move sink power control to a separate function
      drm/radeon/atom: rework encoder enable/disable sequence
      drm/radeon: clarify special handling in i2c over aux
      drm/dp: make aux retries less chatty
      drm/radeon: use the new drm helpers for dp aux
      drm/radeon: use drm_dp_dpcd_read_link_status()
      drm/radeon: call drm_edid_to_eld when we update the edid
      drm/radeon: fix endian swap on hawaii clear state buffer setup
      drm/radeon: fix typo in spectre_golden_registers

Alexandre Courbot (8):
      drm/nouveau: handle -EACCES runtime PM return code
      drm/nve0/fifo: allocate usermem as needed
      support for platform devices
      drm/nouveau: fix missing newline
      drm/panel: use gpiod interface for enable GPIO
      drm/panel: remove redundant regulator_disable()
      drm/panel: add support for LG LH500WX1-SD03 panel
      drm/panel: add support for LG LD070WX3-SL01 panel

Andrzej Hajda (22):
      drm/exynos: delay fbdev initialization until an output is connected
      drm/exynos: init kms poll after creation of connectors
      drm/exynos: correct timing porch conversion
      exynos/fimd: add parallel output related bindings
      drm/exynos: restore parallel output interface support
      ARM: dts: exynos4210-universal: add exynos/fimd node
      drm/exynos: fimd: remove unused variable
      drm/mipi_dsi: add flags to DSI messages
      drm/mipi_dsi: create dsi devices only for nodes with reg property
      drm/exynos: disallow fbdev initialization if no device is connected
      exynos/dsim: add DT bindings
      drm/exynos: add DSIM driver
      panel/s6e8aa0: add DT bindings
      panel/ld9040: add DT bindings
      drm/panel: add ld9040 driver
      ARM: dts: exynos4210-universal_c210: add proper panel node
      drm/panel: add S6E8AA0 driver
      ARM: dts: exynos4: add MIPI DSI Master node
      ARM: dts: exynos4210-trats: add panel node
      ARM: dts: exynos4412-trats2: add panel node
      ARM: dts: exynos4210-trats: enable exynos/fimd node
      ARM: dts: exynos4412-trats2: enable exynos/fimd node

Antti Koskipaa (1):
      drm/i915: Reorganize display pipe register accesses

Arnd Bergmann (1):
      drm/bridge: PTN3460 needs DRM_KMS_HELPER

Arthur Borsboom (3):
      drm/gma500: Code cleanup - removal of centralized exiting of function
      drm/gma500: Code cleanup - style fixes
      drm/gma500: Code cleanup - inline documentation

Ben Skeggs (68):
      drm/nouveau/core: extend width of engine mask for namedb
      drm/nv50/disp: preparation for storing static class data
      drm/nv50/disp: decode the known error codes to human readable form
      drm/nv50-/disp: add method descriptions for debugging
      drm/nv50-/disp: allow dumping core channel state at first supervisor intr
      drm/nv50-/disp: dump channel state when update method fails
      drm/nvd0/disp: add debugging to show which supervisor actions are taken
      drm/nvc0/fifo: rename a couple of units
      drm/nvc0/fifo: mask unhandled intr bits when seen, rather than all intrs
      drm/nvc0/fifo: engine intr
      drm/nvc0/fifo: runlist intr
      drm/nvc0/fifo: ack pb intr individually after handling each unit
      drm/nvc0/fifo: single printk for mmu fault data
      drm/nvc0/fifo: sched intr
      drm/nvc0/fifo: allow channels to be marked as unrunnable
      drm/nvc0/fifo: use runlist event instead of polling
      drm/nvc0/fifo: use subdev identifiers for bar/ifb fault recovery cases
      drm/nvc0/fifo: attempt to recover engines from mmu faults
      drm/nvc0/fifo: attempt to recover from engine ctxsw timeouts
      drm/nve0/fifo: mask unhandled intr bits when seen, rather than all intrs
      drm/nve0/fifo: engine intr
      drm/nve0/fifo: runlist intr
      drm/nve0/fifo: ack pb intr individually after handling each unit
      drm/nve0/fifo: single printk for mmu fault data
      drm/nve0/fifo: single printk for sched error data
      drm/nve0/fifo: allow channels to be marked as unrunnable
      drm/nve0/fifo: use runlist event instead of polling
      drm/nve0/fifo: allow copy engine channel to be looked up by instance
      drm/nve0/fifo: attempt to recover engines from mmu faults
      drm/nve0/fifo: attempt to recover from engine ctxsw timeouts
      drm/nve0/fifo: bind intr
      drm/gm107/devinit: initial implementation
      drm/gm100/bios: hw disable register has moved
      drm/gk20a/timer: initial implementation
      drm/gm107/fb: initial implementation
      drm/nouveau/bios: add HDMI-C (mini) connector type
      drm/gm107/ltcg: initial implementation
      drm/gm107/disp: initial implementation
      drm/gm100/device: recognise GM107
      drm/nouveau: support modesetting on GM107
      drm/nouveau/bios: add more checks to PRAMIN image fetching
      drm/nvc0-/graph: fix gpccs fuc stack setup
      drm/gf104/gr: rename gf104 (nvc4), it came before gf106 (nvc3)
      drm/gf108/gr: minor adjustment to some random initval
      drm/gk208/gr: minor adjustment to some random initval
      drm/gf110/gr: fixup gpc/tpc initvals lists
      drm/gf119/gr: fix bug in some random initval
      drm/gk104/gr: minor adjustment to some random initval
      drm/gk110/gr: minor adjustment to some random initval
      drm/gf100-/gr: tidy reg/ctx initval lists, mostly by giving them names
      drm/gf100-/gr: split gpc state into its subunits
      drm/gf100-/gf: split tpc state into its subunits
      drm/gf100-/gr: split ppc state into its subunits
      drm/nouveau: fix fbcon not being accelerated after suspend
      drm/nv50/bar: fix plymouth issues on certain efi macbooks
      drm/nouveau/bios: parsing of some random table needed to bring up gr
      drm/gf100-/gf: fix a stupid typo, waiting on wrong signal for mmctx
      drm/gm107/gr: initial support
      drm/gk104/gr: therm magic needed on some kepler boards
      drm/nv50/gpio: exclude sense value from mask when changing registers
      drm/nv50/gpio: fixup reset for gpios >= 16
      drm/nouveau/bios: have strap reads show on devinit spam debug level
      drm/nouveau/devinit: add interface to check if a mmio access by scripts is ok
      drm/nva3/devinit: restrict script access to some PFB regs
      drm/nva3/fbram: restrict training pattern setup to GT218
      drm/nouveau/disp: limit dp capabilities as per dcb
      drm/nouveau: recognise higher link rate for available dp bw calculations
      drm/nouveau/therm: check for sensor presence with requested mode, not current

Ben Widawsky (81):
      drm/i915: Provide PDP updates via MMIO
      drm/i915: Don't unconditionally try to deref aliasing ppgtt
      drm/i915: Allow ggtt lookups to not WARN
      drm/i915: Takedown drm_mm on failed gtt setup
      drm/i915: Handle inactivating objects for all VMAs
      drm/i915: Add vm to error BO capture
      drm/i915: Don't use gtt mapping for !gtt error objects
      drm/i915: Identify active VM for batchbuffer capture
      drm/i915: Make pin count per VMA
      drm/i915: Create bind/unbind abstraction for VMAs
      drm/i915: Remove vm arg from relocate entry
      drm/i915: Add a context open function
      drm/i915: relax context alignment
      drm/i915: Simplify ring handling in execbuf
      drm/i915: Permit contexts on all rings
      drm/i915: Track which ring a context ran on
      drm/i915: Better reset handling for contexts
      drm/i915: Split context enabling from init
      drm/i915: Generalize default context setup
      drm/i915: PPGTT vfuncs should take a ppgtt argument
      drm/i915: Use drm_mm for PPGTT PDEs
      drm/i915: One hopeful eviction on PPGTT alloc
      drm/i915: Use platform specific ppgtt enable
      drm/i915: Extract mm switching to function
      drm/i915: Use LRI for switching PP_DIR_BASE
      drm/i915: Flush TLBs after !RCS PP_DIR_BASE
      drm/i915: Generalize PPGTT init
      drm/i915: Reorganize intel_enable_ppgtt
      drm/i915: Add VM to context
      drm/i915: Write PDEs at init instead of enable
      drm/i915: Restore PDEs for all VMs
      drm/i915: Do aliasing PPGTT init with contexts
      drm/i915: Create a per file_priv default context
      drm/i915: Piggy back hangstats off of contexts
      drm/i915: Get context early in execbuf
      drm/i915: Defer request freeing
      drm/i915: Clean up VMAs before freeing
      drm/i915: Do not allow buffers at offset 0
      drm/i915: Use multiple VMs -- the point of no return
      drm/i915: Remove extraneous mm_switch in ppgtt enable
      drm/i915: Add PPGTT dumper
      drm/i915: Dump all ppgtt
      drm/i915/ppgtt: Fix ioctl errno for "no such context"
      drm/i915/bdw: Return -ENONENT on default ctx destroy
      drm/i915: set ctx->initialized only after RCS
      drm/i915: Remove incorrect comment about struct mutex
      drm/i915: Create a USES_PPGTT macro
      drm/i915: Extract register state error capture
      drm/i915: Logically reorder error register capture
      drm/i915: Reorder struct members
      drm/i915: Move per ring error state to ring_error
      drm/i915: Add some more registers to error state
      drm/i915: Capture PPGTT info on error capture
      drm/i915: Generate a hang error code
      drm/i915: Clarify RC6 enabling
      drm/i915: Stop pretending VLV has rc6+
      drm/i915: Just print rc6 facts
      drm/i915/bdw: Use centralized rc6 info print
      drm/i915/bdw: Split up PPGTT cleanup
      drm/i915: Move ppgtt_release out of the header
      drm/i915/bdw: Free PPGTT struct
      drm/i915/bdw: Reorganize PPGTT init
      drm/i915/bdw: Split ppgtt initialization up
      drm/i915: Make clear/insert vfuncs args absolute
      drm/i915/bdw: Reorganize PT allocations
      Revert "drm/i915/bdw: Limit GTT to 2GB"
      drm/i915: Update i915_gem_gtt.c copyright
      drm/i915: Split GEN6 PPGTT cleanup
      drm/i915: Split GEN6 PPGTT initialization up
      drm/i915/bdw: Kill ppgtt->num_pt_pages
      drm/i915/bdw: Add FBC support
      drm/i915/bdw: Use scratch page table for GEN8 PPGTT
      drm/i915: Correct PPGTT total size
      drm/i915: Actually capture PP_DIR_BASE on error
      drm/i915/bdw: Restore PPAT on thaw
      drm/i915: Reorganize the overclock code
      drm/i915: Fix coding style for RPS
      drm/i915: Store the HW min frequency as min_freq
      drm/i915: Rename and comment all the RPS *stuff*
      drm/i915: Remove extraneous MMIO for RPS
      drm/i915: remove rps local variables

Brad Volkin (2):
      drm/i915: Refactor shmem pread setup
      drm/i915: Implement command buffer parsing logic

Bryan Wu (1):
      gpu: host1x: export host1x_syncpt_incr_max() function

Chia-I Wu (2):
      drm/i915: enable HiZ Raw Stall Optimization on HSW
      drm/i915: enable HiZ Raw Stall Optimization on IVB

Chris Wilson (42):
      drm/i915: Free requests after object release when retiring requests
      drm/i915: Place the Global GTT VM first in the list of VM
      drm/i915: Always pin the default context
      drm/i915: Include HW status page in error capture
      drm/i915: VM eviction only targets address space not physical pages
      drm/i915: Only print information for filing bug reports once
      drm/i915: Don't access snooped pages through the GTT (even for error capture)
      drm/i915: Convert EFAULT into a silent SIGBUS
      drm/i915: Treat using a purged buffer as a source of EFAULT
      drm/i915: Prevent recursion by retiring requests when the ring is full
      drm/i915: Downgrade *ERROR* message for invalid user input
      drm/i915: Propagate PCI read/write errors during vga_set_state()
      drm/i915: Short-circuit no-op vga_set_state()
      drm/i915: Flush GPU rendering with a lockless wait during a pagefault
      drm/i915: Revert workaround for disabling L3 cache aging on IVB
      Revert "drm/i915: enable HiZ Raw Stall Optimization on IVB"
      drm/i915: Reject changes of fb base when we have a flip pending
      drm/i915: Accurately track when we mark the hardware as idle/busy
      drm/i915: Convert the forcewake worker into a timer func
      drm/i915: Perform pageflip using mmio if the GPU is terminally wedged
      drm/i915: Reset vma->mm_list after unbinding
      drm/i915: Rely on accurate request tracking for finding hung batches
      drm/i915: Record pid/comm of hanging task
      drm/i915: Process page flags once rather than per pwrite/pread
      drm/i915: Do not force non-caching copies for pwrite along shmem path
      drm/i915: Prevent use-after-free of inherited framebuffer
      drm/i915: Avoid requesting a zero-sized stolen object
      drm/i915: Show cursor status in debugfs/i915_display_info
      drm/i915: Reset forcewake before suspend
      drm/i915: Consolidate forcewake resetting to a single function
      drm/i915: Per-process stats work better when evaluated per-process
      drm/i915: Print how many objects are shared in per-process stats
      drm/i915: Fix unsafe loop iteration over vma whilst unbinding them
      drm/i915: Include a note about the dangers of I915_READ64/I915_WRITE64
      drm/i915: Compute WM for current cursor size
      drm/i915: Recompute WM when the cursor size changes
      drm/i915: Broadwell expands ACTHD to 64bit
      drm/i915: Split 64bit hexadecimal addresses to make them easier to read
      Revert "drm/i915: Disable/Enable PM Intrrupts based on the current freq."
      drm/i915: Refactor gen6_set_rps
      drm/i915: Mask PM/RPS interrupt generation based on activity
      drm/i915: Fix the computation of required fb size for pipe

Christian König (19):
      drm/radeon: fix CP semaphores on CIK
      drm/radeon: initial VCE support v4
      drm/radeon: add VCE ring query
      drm/radeon: add VCE version parsing and checking
      drm/radeon: drop drivers copy of the rptr
      drm/radeon: drop radeon_ring_force_activity
      drm/radeon: cleanup false positive lockup handling
      drm/radeon: improve ring lockup detection code v2
      drm/radeon: cleanup the fence ring locking code
      drm/radeon: fix missing bo reservation
      drm/radeon: fix VCE suspend/resume
      drm/radeon: separate gart and vm functions
      drm/radeon: further cleanup vm flushing & fencing
      drm/radeon: use normal BOs for the page tables v4
      drm/radeon: remove global vm lock
      drm/radeon: drop non blocking allocations from sub allocator
      drm/radeon: remove struct radeon_bo_list
      drm/radeon: clear needs_reset flag if IB test fails
      drm/radeon: rework finding display PLL numbers v2

Christopher Friedt (1):
      drm/vmwgfx: correct fb_fix_screeninfo.line_length

Damien Lespiau (29):
      drm/i915: Don't use i915_preliminary_hw_support to mean pre-production
      drm/i915: Turn get_aux_clock_divider() into per-platform vfuncs
      drm/i915: Factor out a function returning the AUX_CTL value to start a send
      drm/i915: Reorder the AUX_CTL bits in descending order
      drm/i915: Introduce a get_aux_send_ctl() vfunc
      drm/i915: Constify the drm_i915_private pointer a bit more
      drm/i915: Always use INTEL_INFO() to access the device_info structure
      drm/i915: Make the intel_device_info structure kept in dev_priv writable
      drm/i915: Move num_plane to the intel_device_info structure
      drm/i915: Consolidate FUSE_STRAP in one set of defines
      drm/i915: Use I915_MAX_PIPES in the pipe/plane_to_crtc_mapping definitions
      drm/i915: Reorder i915_params fields to not create holes
      drm/i915: Disable display when fused off
      drm/i915: Provide a command line option to disable display
      drm/i915/lvds: Remove dead code from failing case
      drm/i915: Use a pipe variable to cycle through the pipes
      drm/i915: Don't declare unnecessary shadowing variable
      drm/i915: Replace a few for_each_pipe(i) by for_each_pipe(pipe)
      drm/i915: Add a for_each_sprite() macro
      drm/i915: Make num_sprites a per-pipe value
      drm/i915: Make i915_gem_retire_requests_ring() static
      drm/i915: Remove unused to_gem_object() macro
      drm/i915: Fix i915_switch_context() argument name in kerneldoc
      drm/i915/bdw: The TLB invalidation mechanism has been removed from INSTPM
      drm: Check if the allocation has succeeded before dereferencing newmode
      drm/i915: Remove spurious '()' in WARN macros
      drm/i915: Rename intel_setup_wm_latency() to ilk_setup_wm_latency()
      drm/i915: Use the correct format string modifier for ptrdiff_t
      drm/i915/bdw: Implement Wa4x4STCOptimizationDisable:bdw

Dan Carpenter (1):
      drm/nouveau/hwmon: remove some redundant checks

Daniel Drake (1):
      drm/edid: request HDMI underscan by default

Daniel Kurtz (2):
      drm/exynos: Fix (more) freeing issues in exynos_drm_drv.c
      drm/exynos: hdmi: remove the i2c drivers and use

Daniel Vetter (95):
      Merge commit drm-intel-fixes into topic/ppgtt
      drm/i915: Reject the pin ioctl on gen6+
      drm/i915: Drop I915_PARAM_HAS_FULL_PPGTT again
      drm/i915: Reject non-default contexts on non-render again
      Revert "drm/i915: Do not allow buffers at offset 0"
      drm/i915: Reject NEEDS_GTT relocations with full ppgtt
      drm/i915: Don't check for NEEDS_GTT when deciding the address space
      drm/i915: fix ppgtt dump code for DEBUG_FS=n
      drm/i915: Only restore backlight combination mode reg for ums
      drm/i915: drop ironlake_ prefix from edp panel/backlight functions
      drm/i915: Shuffle modeset reset handling around
      Merge branch 'topic/ppgtt' into drm-intel-next-queued
      drm/i915: GEN7_MSG_CONTROL is ivb-only
      drm/i915: Kerneldoc for i915_gem_evict.c
      Merge remote-tracking branch 'airlied/drm-next' into drm-intel-next-queued
      drm/i915: Use normal fb deref for the fbcon framebuffer
      drm/i915: Fix error path leak in fbdev fb allocation
      drm/i915: Pass explicit mode into mode_from_pipe_config v3
      drm/i915: Some polish for the new pipestat_irq_handler
      drm/i915: kill intel_crtc_update_sarea_pos
      drm/i915: protect ringbuffer sarea update behind !MODESET
      drm/i915: delay master/sarea deref for legacy ioctls
      drm/i915: Consolidate binding parameters into flags
      drm/i915: split PIN_GLOBAL out from PIN_MAPPABLE
      drm/i915: Handle set_cache_level errors in the pipe control scratch setup
      drm/i915: Don't set PIN_MAPPABLE for legacy ringbuffers
      drm/i915: Don't pin the status page as mappable
      drm/i915: Handle set_cache_level errors in the status page setup
      drm/i915: Don't allocate context pages as mappable
      drm/i915: Allow blocking in the PDE alloc when running low on gtt space
      drm/i915: Simplify i915_gem_object_ggtt_unpin
      drm/i915: Directly return the vma from bind_to_vm
      drm/i915: Only bind each object rather than for every execbuffer
      drm/i915: fix NULL deref in the load detect code
      drm/i915: tune down user-triggerable dmesg noise in the cursor/overlay code
      drm/i915: sprinkle static
      drm/i915: s/any_enabled/!fallback/ in fbdev_initial_config
      drm/i915: ignore bios output config if not all outputs are on
      drm/i915: reverse dp link param selection, prefer fast over wide again
      drm/i915: Disable full ppgtt by default
      drm/i915: Go OCD on the Makefile
      drm/i915: move dev_priv->suspend around
      Merge tag 'v3.14-rc6' into drm-intel-next-queued
      drm/doc: Clarify the dumb object interfaces
      drm/doc: Fix up kerneldoc in drm_edid.c
      drm/doc: Clean up and integrate kerneldoc for drm_gem.c
      drm/doc: Remove <term> from rendernode docs
      drm/doc: Reorganize driver documentation
      drm/doc: Move the vma offset manager to the right spot
      drm/doc: Remove the "command submissin and fencing" section
      drm/doc: No more drm perf counters
      drm/doc: Document drm_helper_resume_force_mode
      drm/doc: Hide legacy horrors better
      drm/docs: Include hdmi infoframe helper reference
      drm/doc: Clarify PRIME documentation
      drm/doc: Add PRIME function references
      drm/doc: Update copyright
      drm/mm: Remove MM_UNUSED_TARGET
      drm/doc: Overview documentation for drm_mm.c
      drm/doc: Add function reference documentation for drm_mm.c
      drm/kms: rip out drm_mode_connector_detach_encoder
      drm/doc: Integrate drm_modes.c kerneldoc
      drm/doc: Repleace LOCKING kerneldoc sections in drm_modes.c
      drm: move drm_mode related functions into drm_modes.c
      drm: extract drm_modes.h for drm_crtc.h functions
      drm/modes: remove drm_mode_height/width
      drm/modes: drop return value from drm_display_mode_from_videomode
      drm/modes: drop maxPitch from drm_mode_validate_size
      drm: polish function kerneldoc for drm_modes.[hc]
      drm: remove drm_display_mode->private_size
      drm/doc: Fix misplaced </para>
      drm: remove return value from drm_helper_mode_fill_fb_struct
      drm/crtc-helper: remove LOCKING from kerneldoc
      drm: drop error code for drm_helper_resume_force_mode
      drm: kerneldoc polish for drm_crtc_helper.c
      drm: kerneldoc polish for drm_crtc.c
      drm/i915: Remove erronous WARN in the vlv pipe crc code
      drm/imx: remove drm_mode_connector_detach_encoder harder
      drm: Fix use-after-free in the shadow-attache exit code
      Merge remote-tracking branch 'airlied/drm-next' into drm-intel-next
      drm/i915: Fix up the forcewake timer initialization
      drm/i915: catch forcewake reference underruns
      Merge branch 'topic/dp-aux-rework' into drm-intel-next-queued
      drm/crtc-helper: fix locking for drm_helper_disable_unused_functions
      drm/fb-helper: improve drm_fb_helper_initial_config locking
      drm/i915: add locking to fixed panel edid probing
      drm/gma500: add locking to fixed panel edid probing
      drm/i915: add locking to fixed panel edid probing
      drm/i915: fix up semaphore_waits_for
      drm/i915: Fix initial pipe underrun state tracking
      drm/i915: Undo gtt scratch pte unmapping again
      Merge tag 'v3.14' into drm-intel-next-queued
      drm/i915: restrict vt-d stolen memory workaround to pre-gen8
      drm/crtc-helpers: fix dpms on logic
      drm/crtc-helper: don't disable disconnected outputs

Dave Airlie (36):
      Merge tag 'drm/dp-aux-for-3.15-rc1' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge tag 'drm-intel-next-2014-02-07' of ssh://git.freedesktop.org/git/drm-intel into drm-next
      Merge branch 'tda998x-devel' of git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-next
      Merge branch 'drm-next-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-next
      Merge tag 'drm-intel-next-2014-02-14' of ssh://git.freedesktop.org/git/drm-intel into drm-next
      Merge branch 'drm-next-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-next
      Merge branch 'drm-fixes' of git://people.freedesktop.org/~dvdhrm/linux into drm-next
      Merge branch 'drm-minor' of git://people.freedesktop.org/~dvdhrm/linux into drm-next
      Merge branch 'drm-intel-next' of git://git.freedesktop.org/git/drm-intel into drm-next
      Merge branch 'drm-docs' of ssh://people.freedesktop.org/~danvet/drm into drm-next
      Merge tag 'v3.14-rc7' into drm-next
      Merge branch 'drm-next' of git://people.freedesktop.org/~dvdhrm/linux into drm-next
      Merge branch 'topic/core-stuff' of git://git.freedesktop.org/git/drm-intel into drm-next
      drm/radeon/kms: merge conflicted badly
      Merge branch 'gma500-next' of git://github.com/patjak/drm-gma500 into drm-next
      drm/helper: lock all around force mode restore
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      drm/bridge/ptn3460: fix modular build
      Merge branch 'drm-next-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      drm/i915: fix build warning on 32-bit (v2)
      Merge tag 'vmwgfx-next-2014-03-28' of git://people.freedesktop.org/~thomash/linux into drm-next
      drm/nouveau: don't suspend/resume display on runtime s/r
      Merge branch 'primary-plane' of git://people.freedesktop.org/~robclark/linux into drm-next
      Merge tag 'drm-intel-next-2014-03-21' of git://anongit.freedesktop.org/drm-intel into drm-next
      drm/radeon: fix runtime suspend breaking secondary GPUs
      drm/radeon: fix resuming mode in pm runtime resume path
      Merge branch 'drm-next-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-next
      Merge branch 'msm-next' of git://people.freedesktop.org/~robclark/linux into drm-next
      drm/dp_helper: don't return EPROTO for defers (v2)
      Merge tag 'ttm-next-2014-04-04' of git://people.freedesktop.org/~thomash/linux into drm-next
      Merge tag 'vmwgfx-next-2014-04-04' of git://people.freedesktop.org/~thomash/linux into drm-next
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge tag 'drm/panel/for-3.15-rc1' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge tag 'drm/tegra/for-3.15-rc1' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge tag 'drm-intel-fixes-2014-04-04' of git://anongit.freedesktop.org/drm-intel into drm-next

David Herrmann (26):
      drm/udl: fix error-path when damage-req fails
      drm/udl: fix Bpp calculation in dumb_create()
      drm/gem: fix indentation
      drm/gem: free vma-node during object-cleanup
      drm/crtc: add sanity checks to create_dumb()
      drm/gem: dont init "ret" in drm_gem_mmap()
      drm: add pseudo filesystem for shared inodes
      drm: use anon-inode instead of relying on cdevs
      drm: init TTM dev_mapping in ttm_bo_device_init()
      drm: group dev-lifetime related members
      drm: skip redundant minor-lookup in open path
      drm: remove unused DRM_MINOR_UNASSIGNED
      drm: turn DRM_MINOR_* into enum
      drm: provide device-refcount
      drm: add minor-lookup/release helpers
      drm: allocate minors early
      drm: move drm_put_minor() to drm_minor_free()
      drm: rename drm_unplug/get_minor() to drm_minor_register/unregister()
      drm: remove unneeded #ifdef CONFIG_DEBUGFS
      drm: remove redundant minor->device field
      drm: coding-style fixes in minor handling
      drm: inline drm_minor_get_id()
      drm: make minors independent of global lock
      Merge branch 'drm-anon' into drm-next
      Merge branch 'drm-minor' into drm-next
      drm/gma500: remove stub .open/postclose

Deepak S (4):
      drm/i915: Disable/Enable PM Intrrupts based on the current freq.
      drm/i915/vlv: WA to fix Voltage not getting dropped to Vmin when Gfx is power gated.
      drm/i915: Track the enabled PM interrupts in dev_priv.
      Revert "drm/i915/vlv: fixup DDR freq detection per Punit spec"

Giacomo Comes (1):
      Skip intel_crt_init for Dell XPS 8700

Ilia Mirkin (8):
      drm/nv50/graph: update status enum names
      drm/nouveau: replace ffsll with __ffs64
      drm/nouveau/abi16: fix handles past the 32nd one
      drm/nouveau: make hdmi device finding failure prints debug level
      drm/nouveau: use nv_debug for NV_DEBUG, make DRM a separate subflag
      drm/nv50/gr: decode texture trap status code
      drm/nouveau/bios: fix INDEX_ADDRESS_LATCHED trace printout
      drm/nouveau/disp/dp: allow 540MHz data rate

Imre Deak (40):
      drm/i915: clean up HPD IRQ debug printing
      drm/i915: fix wait_remaining_ms_from_jiffies
      drm/i915: fix initial timestamps for PP sequencing logic
      drm/i915: vlv: don't unmask IIR[DISPLAY_PIPE_A/B_VBLANK] interrupt
      drm/i915: factor out valleyview_pipestat_irq_handler
      drm/i915: vlv: s/spin_lock_irqsave/spin_lock/ in irq handler
      drm/i915: unify FLIP_DONE macro names
      drm/i915: pass status instead of enable flags to i915_enable_pipestat
      drm/i915: vlv: fix mapping of pipestat enable to status bits
      drm/i915: vlv: handle only enabled pipestat interrupt events
      drm/i915: unbind fbs from crtcs during driver unload
      drm/i915: add unregister callback to connector
      drm/i915: dp: fix order of dp aux i2c device cleanup
      drm/i915: sdvo: fix error path in sdvo_connector_init
      drm/i915: sdvo: add i2c sysfs symlink to the connector's directory
      drm/i915: use drm_i915_private everywhere in the power domain api
      drm/i915: switch order of power domain init wrt. irq install
      drm/i915: use power domain api to check vga power state
      drm/i915: move hsw power domain comment to its right place
      drm/i915: fold in __intel_power_well_get/put functions
      drm/i915: move modeset_update_power_wells earlier
      drm/i915: move power domain macros to intel_pm.c
      drm/i915: add init power domain to always-on power wells
      drm/i915: split power well 'set' handler to separate enable/disable/sync_hw
      drm/i915: add noop power well handlers instead of NULL checking them
      drm/i915: add port power domains
      drm/i915: get port power domain in connector detect handlers
      drm/i915: check port power domain when reading the encoder hw state
      drm/i915: check pipe power domain when reading its hw state
      drm/i915: vlv: keep first level vblank IRQs masked
      drm/i915: sanitize PUNIT register macro definitions
      drm/i915: factor out reset_vblank_counter
      drm/i915: sanity check power well sw state against hw state
      drm/i915: vlv: factor out valleyview_display_irq_install
      drm/i915: factor out intel_set_cpu_fifo_underrun_reporting_nolock
      drm/i915: power domains: add vlv power wells
      drm/i915: fix typo in display IRQ mask when disabling IRQs
      drm/i915: vlv: reserve the GT power context only once during driver init
      drm/i915: move power domain init earlier during system resume
      drm/i915: vlv: fix RPS interrupt mask setting

Inki Dae (5):
      drm/exynos: hdmi: consider APB PHY
      drm/exynos: hdmi: use i2c_adapter instead of i2c_client
      drm/exynos: fix unnecessary resource cleanup
      drm/exynos: remove MODULE_DEVICE_TABLE definitions
      drm/bridge: export ptn3460_init function

Jani Nikula (22):
      drm/i915: drop the i915.fbpercrtc module parameter
      drm/i915: quirk invert brightness for Acer Aspire 5336
      drm/i915: move module parameters into a struct, in a new file
      drm/i915: drop i915_ prefix from enable_rc6, enable_fbc, enable_ppgtt parameters
      drm/i915: don't flood the logs about bdw semaphores
      drm/dp: let drivers specify the name of the I2C-over-AUX adapter
      drm/i915/dp: split edp_panel_vdd_on() for reuse
      drm/i915/dp: move edp vdd enable/disable at a lower level in i2c-over-aux
      drm/i915/dp: use the new drm helpers for dp aux
      drm/i915/dp: move dp aux ch register init to aux init
      drm/i915/dp: use the new drm helpers for dp i2c-over-aux
      drm/i915: finish off reverting eDP VDD changes
      drm/i915/sdvo: fix questionable return value check
      drm/i915/tv: fix gen4 composite s-video tv-out
      drm/i915/debugfs: prefer struct drm_i915_private to drm_i915_private_t
      drm/i915/dma: prefer struct drm_i915_private to drm_i915_private_t
      drm/i915/gem: prefer struct drm_i915_private to drm_i915_private_t
      drm/i915/irq: prefer struct drm_i915_private to drm_i915_private_t
      drm/i915/display: prefer struct drm_i915_private to drm_i915_private_t
      drm/i915/ringbuffer: prefer struct drm_i915_private to drm_i915_private_t
      drm/i915/overlay: prefer struct drm_i915_private to drm_i915_private_t
      drm/i915: prefer struct drm_i915_private to drm_i915_private_t

Jean-Francois Moine (17):
      drm/i2c: tda998x: use HDMI constants
      drm/i2c: tda998x: add the active aspect in HDMI AVI frame
      drm/i2c: tda998x: use ALSA IEC958 definitions and update audio frequency
      drm/i2c: tda998x: simplify the i2c read/write functions
      drm/i2c: tda998x: check more I/O errors
      drm/i2c: tda998x: code cleanup
      drm/i2c: tda998x: change probe message origin
      drm/i2c: tda998x: don't freeze the system at audio startup time
      drm/i2c: tda998x: don't read write-only registers
      drm/i2c: tda998x: add DT support
      drm/i2c: tda998x: add DT documentation
      drm/i2c: tda998x: always enable EDID read IRQ
      drm/i2c: tda998x: use irq for connection status and EDID read
      drm/i2c: tda998x: make the audio code more readable
      drm/i2c: tda998x: remove the unused variable ca_i2s
      drm/i2c: tda998x: code optimization
      drm/i2c: tda998x: adjust the audio clock divider for S/PDIF

Jeff McGee (2):
      drm/i915: Restore rps/rc6 on reset
      drm/i915: Update rps interrupt limits

Jesse Barnes (21):
      drm/i915: clock readout support for DDI v3
      drm/i915: always check clocks when comparing pipe configs
      drm/i915: fix WRPLL clock calculation
      drm/i915: alloc intel_fb in the intel_fbdev struct
      drm/i915: split aligned height calculation out v2
      drm: expose subpixel order name routine v3
      drm/i915: add a display info file to debugfs v2
      drm/i915: read out hw state earlier v2
      drm: export cmdline and preferred mode functions from fb helper
      drm/i915: allow re-use BIOS connector config for initial fbdev config v3
      drm/i915: don't preserve inherited configs with nothing on v2
      drm/i915: honor forced connector modes v2
      drm/i915: re-add locking around hw state readout
      drm/i915: print connector mode list in display_info
      drm/i915: add plane_config fetching infrastructure v2
      drm/i915: get_plane_config for i9xx v13
      drm/i915: get_plane_config support for ILK+ v3
      drm/i915: Wrap the preallocated BIOS framebuffer and preserve for KMS fbcon v12
      drm/i915: remove early fb allocation dependency on CONFIG_FB v2
      drm/i915/vlv: no MCHBAR on VLV
      drm/i915/vlv: use W_SYNC_SHIFT for interlaced modes on VLV

Jingoo Han (1):
      drm/nouveau/hwmon: replace strict_strtol() with kstrtol()

Joonyoung Shim (1):
      drm/cma: remove to make sg_table when gem cma is created

Kenneth Graunke (2):
      drm/i915: Add a partial instruction shootdown workaround on Broadwell.
      drm/i915: Add thread stall DOP clock gating workaround on Broadwell.

Laurent Pinchart (4):
      drm/omap: Don't dereference list head when the connectors list is empty
      drm/rcar-du: Handle encoder initialization failures
      drm/cma: Use dma_mmap_writecombine() to mmap buffer
      drm: gem-cma: Fix warnings due to improper printk formats

Lauri Kasanen (2):
      drm: Add support for two-ended allocation, v3
      drm/radeon: Use two-ended allocation by size, v2

Lespiau, Damien (12):
      drm: Refresh the explanation of debug categories
      drm: Remove the unused (and unusable) DRM_LOG_MODE()
      drm/exynos: Replace DRM_LOG_KMS() by DRM_DEBUG_KMS()
      drm/gma500: Replace DRM_LOG_KMS() by DRM_DEBUG_KMS()
      drm/i915: Replace DRM_LOG_KMS() by DRM_DEBUG_KMS()
      staging: imx-drm: Replace DRM_LOG_KMS() by DRM_DEBUG_KMS()
      drm: Remove the now unused DRM_LOG* macros
      drm: Pull the test on drm_debug in the logging macros
      drm: drm_ut_debug_printk() isn't called with NULL anywmore
      drm: Remove the prefix argument of drm_ut_debug_printk()
      drm: Remove the ', ' after the function name in debug logs
      drm: Specify a bit more the DRM_CAP_CURSOR_{WIDTH, HEIGHT} caps

Maarten Lankhorst (1):
      drm/qxl: unset a pointer in sync_obj_unref

Marek Ol¨ák (7):
      drm/radeon: add a way to get and set initial buffer domains v2
      drm/radeon: track memory statistics about VRAM and GTT usage and buffer moves v2
      drm/radeon: deduplicate code in radeon_gem_busy_ioctl
      drm/radeon: add buffers to the LRU list from smallest to largest
      drm/radeon: validate relocations in the order determined by userspace v3
      drm/radeon: limit how much memory TTM can move per IB according to VRAM usage
      drm/radeon: set PIPE_CONFIG for 1D and linear tiling modes on CIK

Mario Kleiner (1):
      drm/nouveau: fix small thinko in vblank timestamping.

Martin Peres (4):
      drm/nouveau/pm/fan: drop the fan lock in fan_update() before rescheduling
      drm/nvd7/therm: handle another kind of PWM fans
      drm/nouveau/therm: let the vbios decide on the automatic fan management mode
      drm/nouveau/bios: fetch the vbios from PROM using only aligned 32-bit accesses

Matt Roper (14):
      drm/i915: Rename similar plane functions to avoid confusion
      drm: Add support for multiple plane types (v2)
      drm/exynos: Restrict plane loops to only operate on overlay planes (v2)
      drm/i915: Restrict plane loops to only operate on overlay planes (v2)
      drm/shmobile: Restrict plane loops to only operate on legacy planes
      drm: Make drm_crtc_check_viewport non-static
      drm: Add primary plane helpers (v3)
      drm: Add drm_universal_plane_init()
      drm: Add drm_crtc_init_with_planes() (v2)
      drm/msm: Switch to universal plane API's
      drm: Replace crtc fb with primary plane fb (v3)
      drm: Remove unused drm_crtc->fb
      drm: Allow userspace to ask for universal plane list (v2)
      drm/doc: Update plane documentation and add plane helper library

Michel Dänzer (1):
      drm/mm: Fix search for smallest hole satisfying constraints

Mika Kuoppala (15):
      drm/i915: Use i915_hw_context to set reset stats
      drm/i915: Tune down debug output when context is banned
      drm/i915: Use hangcheck score to find guilty context
      drm/i915: Get rid of acthd based guilty batch search
      drm/i915: check for oom when allocating private_default_ctx
      drm/i915: release mutex in i915_gem_init()'s error path
      drm/i915: Fix forcewake counts for gen8
      drm/i915: Add error code into error state
      drm/i915: Add reason for capture in error state
      drm/i915: Add reset count to error state
      drm/i915: Add suspend count to error state
      drm/i915: Do forcewake reset on gen8
      drm/i915: Don't access fifodbg registers on gen8
      drm/i915: No need to put forcewake after a reset
      drm/i915: Switch to fake context on older gens

Naresh Kumar Kachhi (3):
      drm/i915: disable rings before HW status page setup
      drm/i915: wait for rings to become idle once disabled
      drm/i915: warn if ring is active before sync flush

Patrik Jakobsson (13):
      drm/i915: Don't just say it, actually force edp vdd
      drm/gma500: Make SGX MMU driver actually do something
      drm/gma500: Add support for SGX interrupts
      drm/gma500: Give MMU code it's own header file
      drm/gma500: Add first piece of blitter code
      drm/gma500: Hook up the MMU
      drm/gma500: Always trap MMU page faults
      drm/gma500: Remove unused ioctls
      drm/gma500: Add backing type and base align to psb_gem_create()
      drm/gma500: Move asle interrupt work into a work task
      drm/gma500: Unify _get_core_freq for cdv and psb
      drm/gma500: Unify encoder mode fixup
      drm/gma500/cdv: Cedarview display cleanups

Paulo Zanoni (48):
      drm/i915: init the DP panel power seq variables earlier
      drm/i915: save some time when waiting the eDP timings
      drm/i915: remove a column of zeros from the eDP wait definitions
      drm/i915: don't wait for power cycle when waiting for power off
      drm/i915: set the backlight panel delays registers to 1
      drm/i915: add wait_for_vblank argument to intel_enable_pipe
      drm/i915: don't wait for vblank after enabling pipe on HSW
      drm/i915: remove the vblank_wait hack from HSW+
      drm/i915: pass intel_crtc as argument for intel_enable_pipe
      drm/i915: remove pch_port argument form intel_enable_pipe
      drm/i915: remove "dsi" argument form intel_enable_pipe
      drm/i915: remove wait_for_vblank argument form intel_enable_pipe
      drm/i915: WARN in case we're enabling the pipe and it's enabled
      drm/i915: don't reference null pointer at i915_sink_crc
      drm/i915: rename modeset_update_power_wells
      drm/i915: get/put runtime PM without holding rps.hw_lock
      drm/i915: put runtime PM only at the end of intel_mark_idle
      drm/i915: put runtime PM only when we actually release force_wake
      drm/i915: get runtime PM while trying to detect CRT
      drm/i915: get/put runtime PM in more places at i915_debugfs.c
      drm/i915: kill dev_priv->pc8.gpu_idle
      drm/i915: call assert_device_not_suspended at gen6_force_wake_work
      drm/i915: assert force wake is disabled when we runtime suspend
      drm/i915: assert we're not runtime suspended when accessing registers
      drm/i915: properly disable the VDD when disabling the panel
      drm/i915: extract __hsw_do_{en, dis}able_package_c8
      drm/i915: make PC8 be part of runtime PM suspend/resume
      drm/i915: get/put runtime PM when we get/put a power domain
      drm/i915: remove dev_priv->pc8.requirements_met
      drm/i915: get runtime PM references when the GPU is idle/busy
      drm/i915: kill pc8.disable_count
      drm/i915: remove an indirection level on PC8 functions
      drm/i915: don't get/put PC8 reference on freeze/thaw
      drm/i915: make intel_aux_display_runtime_get get runtime PM, not PC8
      drm/i915: don't get/put PC8 when getting/putting power wells
      drm/i915: remove dev_priv->pc8.enabled
      drm/i915: move pc8.irqs_disabled to pm.irqs_disabled
      drm/i915: kill struct i915_package_c8
      drm/i915: rename __hsw_do_{en, dis}able_pc8
      drm/i915: update the PC8 and runtime PM documentation
      drm/i915: init pm.suspended earlier
      drm/i915: don't schedule force_wake_timer at gen6_read
      drm/i915: get runtime PM at i915_reg_read_ioctl
      drm/i915: don't read pp_ctrl_reg if we're suspended
      drm/i915: get runtime PM at i915_display_info
      drm/i915: don't read cursor registers on powered down pipes
      drm/i915: fix WARNs when reading DDI state while suspended
      drm/i915: don't get/put runtime PM at the debugfs forcewake file

Rob Clark (9):
      drm/msm: hdmi audio support
      drm/msm: add hang_debug module param
      drm/msm: spin helper
      drm/msm: crank down gpu when inactive
      drm/msm: add chip-id param
      drm/msm: use componentised device support
      drm/msm: validate flags, etc
      drm/msm/mdp: add timeout for irq wait
      drm: Add plane type property (v2)

Rodrigo Vivi (2):
      drm: dp helper: Add DP test sink CRC definition.
      drm/i915: debugfs: Add support for probing DP sink CRC.

Russell King (3):
      drm/i2c: tda998x: clean up error chip version checking
      drm/i2c: tda998x: always use the same device for all kernel messages
      DRM: armada: fix corruption while loading cursors

Sagar Kamble (1):
      drm/i915: Enabling 128x128 and 256x256 ARGB Cursor Support

Sean Paul (30):
      drm/exynos: Merge overlay_ops into manager_ops
      drm/exynos: Add an initialize function to manager and display
      drm/exynos: Use manager_op initialize in fimd
      drm/exynos: hdmi: Implement initialize op for hdmi
      drm/exynos: Pass exynos_drm_manager in manager ops instead of dev
      drm/exynos: Remove apply manager callback
      drm/exynos: Remove dpms link between encoder/connector
      drm/exynos: Rename display_op power_on to dpms
      drm/exynos: Don't keep dpms state in encoder
      drm/exynos: Use unsigned long for possible_crtcs
      drm/exynos: Split manager/display/subdrv
      drm/exynos: Remove exynos_drm_hdmi shim
      drm/exynos: Use drm_mode_copy to copy modes
      drm/exynos: Disable unused crtc planes from crtc
      drm/exynos: Add mode_set manager operation
      drm/exynos: Implement mode_fixup manager operation
      drm/exynos: Use mode_set to configure fimd
      drm/exynos: Remove unused/useless fimd_context members
      drm/exynos: Move dp driver from video/ to drm/
      drm/exynos: Move display implementation into dp
      drm/exynos: Implement dpms display callback in DP
      drm/exynos: Clean up FIMD power on/off routines
      drm/exynos: Consolidate suspend/resume in drm_drv
      drm/exynos: Add create_connector callback
      drm/exynos: Implement drm_connector in hdmi directly
      drm/exynos: Implement drm_connector directly in dp driver
      drm/exynos: Implement drm_connector directly in vidi driver
      drm/bridge: Add PTN3460 bridge driver
      drm/exynos: Implement lvds bridge discovery to DP driver
      drm/exynos: Remove the exynos_drm_connector shim

Shawn Guo (1):
      drm/cma: include <drm/drmP.h> as needed

Shirish S (2):
      drm/exynos: add phy settings for RB resolutions
      drm/exynos: set the active aspect ratio as per mode

Shobhit Kumar (1):
      drm/i915: Update VBT data structures to have MIPI block enhancements

Sinclair Yeh (1):
      drm/i915: Revert workaround for disabling L3 cache aging on BYT

Stephane Marchesin (1):
      drm/exynos: Remove useless slab.h include

Steven Rostedt (1):
      drm/i915: Do not dereference pointers from ring buffer in evict event

Takashi Iwai (1):
      drm: Prefer noninterlace cmdline mode unless explicitly specified

Thierry Reding (15):
      drm/dp: Add AUX channel infrastructure
      drm/dp: Add drm_dp_dpcd_read_link_status()
      drm/dp: Add DisplayPort link helpers
      drm/dp: Allow registering AUX channels as I2C busses
      drm/i915: Remove dead code
      drm/gma500: Remove dead code
      MAINTAINERS: Add entry for DRM panel drivers
      drm/panel: Add LG 12.9" LCD panel
      drm/panel: simple: Allow GPIO accesses to sleep
      drm/panel: simple: Allow DSI panels to provide mode flags
      drm/tegra: prime: Add vmap support
      drm/tegra: Add eDP support
      drm/tegra: Relicense public header under MIT
      drm/tegra: Relicense under GPL v2
      drm/tegra: Use standard GPL v2 license text

Thomas Hellstrom (19):
      drm: Have the crtc code only reference master from legacy nodes v2
      drm: Break out ioctl permission check to a separate function v2
      drm: Make control nodes master-less v3
      drm: Improve on minor type helpers v3
      drm: Remove the minor master list
      drm: Protect the master management with a drm_device::master_mutex v3
      drm: Add a function to get the ioctl flags
      drm/vmwgfx: Use a per-device semaphore for reservation protection
      drm/vmwgfx: Reinstate and tighten security around legacy master model
      drm/vmwgfx: Drop authentication requirement on UNREF ioctls
      drm/vmwgfx: Allow prime fds in the surface reference ioctls
      drm/vmwgfx: Tighten security around surface sharing v2
      drm/ttm: Add a ttm_ref_object_exists function
      drm/vmwgfx: Tighten the security around buffer maps
      drm/vmwgfx: Enable render nodes
      drm/vmwgfx: Bump driver minor and date
      drm/vmwgfx: Fix query buffer locking order violation
      drm/vmwgfx: Remove authorization requirements around some more ioctls
      drm/ttm: Hide the implementation details of reservation

Todd Previte (1):
      drm/i915: Enable 5.4Ghz (HBR2) link rate for Displayport 1.2-capable devices

Vandana Kannan (1):
      drm/i915: Initialize downclock mode in panel init

Ville Syrjälä (82):
      drm/i915: Pre-compute pipe enabled state
      drm/i915: Prepare to track new pipe config per pipe
      drm/i915: Use new_config and new_enabled to simplify the VLV cdclk code
      drm/i915: Don't oops if the initial modeset fails
      drm/i915: Set crtc->new_config to NULL for pipes that are about to be disabled
      drm/i915: Add intel_hpd_irq_uninstall()
      drm/i915: Make irq_received bool
      drm/i915: Kill dev_priv->irq_received
      drm/i915: Fix new_config and new_enabled for load detect
      drm/i915: Shuffle sprite register writes into a tighter group
      drm/i915: Limit FIFO underrun reports on GMCH platforms
      drm/i915: Make underruns DRM_ERROR
      drm/i915: Don't write IVB_FBC_RT_BASE
      drm/i915: Don't set persistent FBC mode on ILK/SNB
      drm/i915: Don't set DPFC_HT_MODIFY bit on CTG/ILK/SNB
      drm/i915: Improve FBC plane defines a bit
      drm/i915: Use 1/2 compression ratio limit for 16bpp on FBC2
      drm/i915: Actually write the correct bits to DPFC_CONTROL on CTG
      drm/i915: Kill most of the FBC register save/restore
      drm/i915: Don't preserve DPFC_CONTROL bits ILK/SNB
      drm/i915: Fix FBC1 enable message
      drm/i915: Fix FBC_FENCE_OFF
      drm/i915: We implement WaDisableL3Bank2xClockGate:vlv
      drm/i915: We implement WaEnableVGAAccessThroughIOPort:ctg, elk, ilk, snb, ivb, vlv, hsw
      drm/i915: WaPsdDispatchEnable seems to be another name for WaDisablePSDDualDispatchEnable
      drm/i915: We implement WaDisableL3CacheAging:vlv
      drm/i915: WaApplyL3ControlAndL3ChickenMode isn't applicable for VLV
      drm/i915: We implement WaDisableRCCUnitClockGating:snb
      drm/i915: We implement WaMiSetContext_Hang
      drm/i915: Implement WaIncreaseL3CreditsForVLVB0:vlv
      drm/i915: WaDisableVDSUnitClockGating isn't applicable to SNB
      drm/i915: WaDisableRCCUnitClockGating isn't applicable to IVB
      drm/i915: WaDisableRCCUnitClockGating isn't applicaple to VLV
      drm/i915: WaDisableRHWOOptimizationForRenderHang isn't applicable to HSW
      drm/i915: WaDisableRHWOOptimizationForRenderHang isn't applicable to VLV
      drm/i915: Drop bogus comment about RCPB unit clock gating on IVB
      drm/i915: Drop WaDisableRCZUnitClockGating:hsw
      drm/i915: Drop WaApplyL3ControlAndL3ChickenMode:hsw
      drm/i915: Drop WaDisableRCPBUnitClockGating:vlv
      drm/i915: Add debugfs hooks for messign with watermark latencies
      drm/i915: Drop WaDisableVDSUtnitClockGating:vlv
      drm/i915: Drop WaDisableTDLUnitClockGating:vlv
      drm/i915: gen7_setup_fixed_func_scheduler() actually implements WaVSThreadDispatchOverride
      drm/i915: Don't apply WaVSThreadDispatchOverride on HSW
      drm/i915: VLV wants WaVSThreadDispatchOverride too
      drm/i915: Clarify WaDisable4x2SubspanOptimization situation for VLV
      Revert "drm/i915: set conservative clock gating values on VLV v2"
      drm/i915: Fix IVB GT2 WaDisableDopClockGating and WaDisablePSDDualDispatchEnable
      drm/i915: Drop WaDisablePSDDualDispatchEnable:ivb for IVB GT2
      drm/i915: Disable SF pipelined attribute fetch for SNB
      drm/i915: Convert DIP port switch cases to a simple macro
      drm/i915: Fix SNB GT_MODE register setup
      drm/i915: Assume we implement WaStripsFansDisableFastClipPerformanceFix:snb
      drm/i915: There's no need to mask all 3D_CHICKEN bits on SNB
      drm/i915: Change IVB WIZ hashing mode to 16x4
      drm/i915: Change HSW WIZ hashing mode to 16x4
      drm/i915: Change BDW WIZ hashing mode to 16x4
      drm/i915: Add a comment about WIZ hashing vs. thread counts
      drm/i915: Don't ban default context when stop_rings!=0
      drm/i915: Fix VLV forcewake after reset
      drm/i915: Drop the forcewake count inc/dec around register read on VLV
      drm/i915: Streamline VLV forcewake handling
      drm/i915: Fix DDI port_clock for VGA output
      drm/i915: Use DIV_ROUND_UP() when calculating number of required FDI lanes
      drm/i915: Disable semaphore wait event idle message on BDW
      drm/i915: Implement WaDisableSDEUnitClockGating:bdw
      drm/i915: We implement WaDisableAsyncFlipPerfMode:bdw
      drm/i915: Don't clobber CHICKEN_PIPESL_1 on BDW
      drm/i915: Use RMW to update chicken bits in gen7_enable_fbc()
      drm/i915: Unify CHICKEN_PIPESL_1 register definitions
      drm/i915: Avoid div by zero when pixel clock is large
      drm/i915: Make encoder cloning more flexible
      drm/i915: Don't use HDMI 12bpc when cloning with other encoder types
      drm/i915: Allow HDMI+VGA cloning
      drm/i915: Allow HDMI+HDMI cloning on g4x
      drm/i915: Reduce the time we hold struct mutex in intel_pipe_set_base()
      drm/i915: Drop WARN_ON(flags) from ppgtt_bind_vma()
      drm/i915: Unbind all vmas whose new cache_level doesn't agree with the neighbours
      drm/fb-helper: Use drm_fb_helper_restore_fbdev_mode() in drm_fb_helper_set_par()
      drm/i915: Program VSYNCSHIFT in a more consistent manner
      drm/i915: Fix the interlace mode selection for gmch platforms
      drm/i915: Make sure vsyncshift is positive

Xiubo Li (1):
      drm/fb-helper: Do the 'max_conn_count' zero check

 Documentation/DocBook/drm.tmpl                     |  550 ++++---
 .../devicetree/bindings/drm/bridge/ptn3460.txt     |   27 +
 .../devicetree/bindings/drm/i2c/tda998x.txt        |   27 +
 .../bindings/gpu/nvidia,tegra20-host1x.txt         |   42 +
 .../devicetree/bindings/panel/lg,ld070wx3-sl01.txt |    7 +
 .../devicetree/bindings/panel/lg,lh500wx1-sd03.txt |    7 +
 .../devicetree/bindings/panel/lg,lp129qe.txt       |    7 +
 .../devicetree/bindings/panel/samsung,ld9040.txt   |   66 +
 .../devicetree/bindings/panel/samsung,s6e8aa0.txt  |   56 +
 .../devicetree/bindings/video/exynos_dp.txt        |   17 +
 .../devicetree/bindings/video/exynos_dsim.txt      |   80 +
 .../devicetree/bindings/video/exynos_hdmi.txt      |    5 +
 .../devicetree/bindings/video/samsung-fimd.txt     |   17 +
 MAINTAINERS                                        |   16 +-
 arch/arm/boot/dts/exynos4.dtsi                     |   14 +
 arch/arm/boot/dts/exynos4210-trats.dts             |   61 +
 arch/arm/boot/dts/exynos4210-universal_c210.dts    |   64 +
 arch/arm/boot/dts/exynos4412-trats2.dts            |   70 +
 drivers/gpu/drm/Kconfig                            |    2 +
 drivers/gpu/drm/Makefile                           |    4 +-
 drivers/gpu/drm/armada/armada_crtc.c               |   24 +-
 drivers/gpu/drm/ast/ast_mode.c                     |   12 +-
 drivers/gpu/drm/ast/ast_ttm.c                      |    5 +-
 drivers/gpu/drm/bochs/bochs_kms.c                  |    4 +-
 drivers/gpu/drm/bochs/bochs_mm.c                   |    6 +-
 drivers/gpu/drm/bridge/Kconfig                     |    5 +
 drivers/gpu/drm/bridge/Makefile                    |    3 +
 drivers/gpu/drm/bridge/ptn3460.c                   |  350 +++++
 drivers/gpu/drm/cirrus/cirrus_mode.c               |   10 +-
 drivers/gpu/drm/cirrus/cirrus_ttm.c                |    5 +-
 drivers/gpu/drm/drm_crtc.c                         |  936 +++++++++---
 drivers/gpu/drm/drm_crtc_helper.c                  |  245 ++-
 drivers/gpu/drm/drm_crtc_internal.h                |   38 +
 drivers/gpu/drm/drm_dp_helper.c                    |  396 +++++
 drivers/gpu/drm/drm_drv.c                          |  136 +-
 drivers/gpu/drm/drm_edid.c                         |   34 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   45 +-
 drivers/gpu/drm/drm_fops.c                         |  121 +-
 drivers/gpu/drm/drm_gem.c                          |   71 +-
 drivers/gpu/drm/drm_gem_cma_helper.c               |   38 +-
 drivers/gpu/drm/drm_ioctl.c                        |    7 +
 drivers/gpu/drm/drm_mipi_dsi.c                     |    6 +-
 drivers/gpu/drm/drm_mm.c                           |  285 +++-
 drivers/gpu/drm/drm_modes.c                        |  346 +++--
 drivers/gpu/drm/drm_pci.c                          |    2 +-
 drivers/gpu/drm/drm_plane_helper.c                 |  333 ++++
 drivers/gpu/drm/drm_platform.c                     |    2 +-
 drivers/gpu/drm/drm_prime.c                        |  110 +-
 drivers/gpu/drm/drm_stub.c                         |  503 +++++--
 drivers/gpu/drm/drm_usb.c                          |    2 +-
 drivers/gpu/drm/exynos/Kconfig                     |   24 +
 drivers/gpu/drm/exynos/Makefile                    |    9 +-
 drivers/{video => gpu/drm}/exynos/exynos_dp_core.c |  304 +++-
 drivers/{video => gpu/drm}/exynos/exynos_dp_core.h |    9 +
 drivers/{video => gpu/drm}/exynos/exynos_dp_reg.c  |    0
 drivers/{video => gpu/drm}/exynos/exynos_dp_reg.h  |    0
 drivers/gpu/drm/exynos/exynos_drm_connector.c      |   92 +-
 drivers/gpu/drm/exynos/exynos_drm_connector.h      |    4 -
 drivers/gpu/drm/exynos/exynos_drm_core.c           |  193 ++-
 drivers/gpu/drm/exynos/exynos_drm_crtc.c           |  159 +-
 drivers/gpu/drm/exynos/exynos_drm_crtc.h           |   20 +-
 drivers/gpu/drm/exynos/exynos_drm_dpi.c            |  339 +++++
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |  197 ++-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |  163 +-
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            | 1524 +++++++++++++++++++
 drivers/gpu/drm/exynos/exynos_drm_encoder.c        |  359 +----
 drivers/gpu/drm/exynos/exynos_drm_encoder.h        |   18 +-
 drivers/gpu/drm/exynos/exynos_drm_fb.c             |    7 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |   23 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  700 ++++-----
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c           |  439 ------
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h           |   67 -
 drivers/gpu/drm/exynos/exynos_drm_plane.c          |   19 +-
 drivers/gpu/drm/exynos/exynos_drm_plane.h          |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |  441 +++---
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  472 +++---
 drivers/gpu/drm/exynos/exynos_mixer.c              |  573 ++++---
 drivers/gpu/drm/exynos/exynos_mixer.h              |   20 +
 drivers/gpu/drm/gma500/Makefile                    |    2 +
 drivers/gpu/drm/gma500/blitter.c                   |   51 +
 drivers/gpu/drm/gma500/blitter.h                   |   22 +
 drivers/gpu/drm/gma500/cdv_device.c                |   40 +-
 drivers/gpu/drm/gma500/cdv_intel_crt.c             |    9 +-
 drivers/gpu/drm/gma500/cdv_intel_display.c         |   73 +-
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |    2 +-
 drivers/gpu/drm/gma500/cdv_intel_hdmi.c            |   11 +-
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |    5 +-
 drivers/gpu/drm/gma500/framebuffer.c               |    2 +-
 drivers/gpu/drm/gma500/gem.c                       |   56 +-
 drivers/gpu/drm/gma500/gem.h                       |   21 +
 drivers/gpu/drm/gma500/gma_device.c                |   56 +
 drivers/gpu/drm/gma500/gma_device.h                |   21 +
 drivers/gpu/drm/gma500/gma_display.c               |   23 +-
 drivers/gpu/drm/gma500/gma_display.h               |    3 +
 drivers/gpu/drm/gma500/gtt.c                       |   45 +-
 drivers/gpu/drm/gma500/gtt.h                       |    3 +-
 drivers/gpu/drm/gma500/mdfld_dsi_output.c          |    2 +-
 drivers/gpu/drm/gma500/mdfld_intel_display.c       |   16 +-
 drivers/gpu/drm/gma500/mmu.c                       |  297 ++--
 drivers/gpu/drm/gma500/mmu.h                       |   93 ++
 drivers/gpu/drm/gma500/oaktrail_crtc.c             |   12 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |    9 +-
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |    5 +
 drivers/gpu/drm/gma500/opregion.c                  |   25 +-
 drivers/gpu/drm/gma500/psb_device.c                |   42 +-
 drivers/gpu/drm/gma500/psb_drv.c                   |  404 ++---
 drivers/gpu/drm/gma500/psb_drv.h                   |  203 +--
 drivers/gpu/drm/gma500/psb_intel_display.c         |   32 +-
 drivers/gpu/drm/gma500/psb_intel_drv.h             |    2 -
 drivers/gpu/drm/gma500/psb_intel_lvds.c            |    5 +-
 drivers/gpu/drm/gma500/psb_intel_sdvo.c            |   22 +-
 drivers/gpu/drm/gma500/psb_irq.c                   |   81 +-
 drivers/gpu/drm/i2c/tda998x_drv.c                  |  602 +++++---
 drivers/gpu/drm/i915/Makefile                      |   80 +-
 drivers/gpu/drm/i915/dvo_ch7xxx.c                  |    4 +-
 drivers/gpu/drm/i915/dvo_ivch.c                    |   30 +-
 drivers/gpu/drm/i915/dvo_ns2501.c                  |   10 +-
 drivers/gpu/drm/i915/dvo_sil164.c                  |   10 +-
 drivers/gpu/drm/i915/dvo_tfp410.c                  |   24 +-
 drivers/gpu/drm/i915/i915_cmd_parser.c             |  485 ++++++
 drivers/gpu/drm/i915/i915_debugfs.c                |  716 ++++++++-
 drivers/gpu/drm/i915/i915_dma.c                    |  162 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  299 ++--
 drivers/gpu/drm/i915/i915_drv.h                    |  729 ++++++---
 drivers/gpu/drm/i915/i915_gem.c                    |  697 ++++-----
 drivers/gpu/drm/i915/i915_gem_context.c            |  483 ++++--
 drivers/gpu/drm/i915/i915_gem_debug.c              |    2 +-
 drivers/gpu/drm/i915/i915_gem_evict.c              |   63 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  198 +--
 drivers/gpu/drm/i915/i915_gem_gtt.c                | 1256 ++++++++++++----
 drivers/gpu/drm/i915/i915_gem_stolen.c             |    2 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c             |    8 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |  616 +++++---
 drivers/gpu/drm/i915/i915_irq.c                    |  836 +++++++----
 drivers/gpu/drm/i915/i915_params.c                 |  154 ++
 drivers/gpu/drm/i915/i915_reg.h                    |  560 ++++---
 drivers/gpu/drm/i915/i915_suspend.c                |   40 +-
 drivers/gpu/drm/i915/i915_sysfs.c                  |   71 +-
 drivers/gpu/drm/i915/i915_trace.h                  |   24 +-
 drivers/gpu/drm/i915/i915_ums.c                    |    8 +
 drivers/gpu/drm/i915/intel_bios.c                  |    8 +-
 drivers/gpu/drm/i915/intel_bios.h                  |  174 ++-
 drivers/gpu/drm/i915/intel_crt.c                   |   70 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |  117 +-
 drivers/gpu/drm/i915/intel_display.c               | 1583 +++++++++++++-------
 drivers/gpu/drm/i915/intel_dp.c                    |  912 +++++------
 drivers/gpu/drm/i915/intel_drv.h                   |  106 +-
 drivers/gpu/drm/i915/intel_dsi.c                   |   23 +-
 drivers/gpu/drm/i915/intel_dvo.c                   |    6 +-
 drivers/gpu/drm/i915/intel_fbdev.c                 |  371 ++++-
 drivers/gpu/drm/i915/intel_hdmi.c                  |  108 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   24 +-
 drivers/gpu/drm/i915/intel_overlay.c               |   40 +-
 drivers/gpu/drm/i915/intel_panel.c                 |   21 +-
 drivers/gpu/drm/i915/intel_pm.c                    | 1202 ++++++++++-----
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  152 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   42 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   78 +-
 drivers/gpu/drm/i915/intel_sprite.c                |   18 +-
 drivers/gpu/drm/i915/intel_tv.c                    |   21 +-
 drivers/gpu/drm/i915/intel_uncore.c                |  281 ++--
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   26 +-
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |    5 +-
 drivers/gpu/drm/msm/Makefile                       |    1 +
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |  105 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   65 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.h            |   16 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   50 +-
 drivers/gpu/drm/msm/hdmi/hdmi.h                    |   25 +
 drivers/gpu/drm/msm/hdmi/hdmi_audio.c              |  273 ++++
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c             |   26 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c           |   33 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c          |    8 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c           |   27 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c          |    8 +-
 drivers/gpu/drm/msm/mdp/mdp_kms.c                  |    3 +-
 drivers/gpu/drm/msm/msm_drv.c                      |  139 +-
 drivers/gpu/drm/msm/msm_drv.h                      |    4 +
 drivers/gpu/drm/msm/msm_gem_submit.c               |   15 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   85 +-
 drivers/gpu/drm/msm/msm_gpu.h                      |   16 +-
 drivers/gpu/drm/nouveau/Makefile                   |   16 +-
 drivers/gpu/drm/nouveau/core/core/namedb.c         |    2 +-
 drivers/gpu/drm/nouveau/core/core/parent.c         |    2 +-
 drivers/gpu/drm/nouveau/core/engine/device/base.c  |   85 +-
 drivers/gpu/drm/nouveau/core/engine/device/gm100.c |  106 ++
 drivers/gpu/drm/nouveau/core/engine/device/nv04.c  |    4 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv10.c  |   16 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv20.c  |    8 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv30.c  |   10 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv40.c  |   32 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv50.c  |   28 +-
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |   44 +-
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |   20 +-
 drivers/gpu/drm/nouveau/core/engine/disp/dport.c   |   10 +-
 drivers/gpu/drm/nouveau/core/engine/disp/gm107.c   |  101 ++
 drivers/gpu/drm/nouveau/core/engine/disp/nv04.c    |   12 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |  370 ++++-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.h    |   54 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv84.c    |  191 ++-
 drivers/gpu/drm/nouveau/core/engine/disp/nv94.c    |   50 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nva0.c    |   67 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nva3.c    |   22 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c    |  361 ++++-
 drivers/gpu/drm/nouveau/core/engine/disp/nve0.c    |  187 ++-
 drivers/gpu/drm/nouveau/core/engine/disp/nvf0.c    |   22 +-
 drivers/gpu/drm/nouveau/core/engine/disp/priv.h    |   10 +
 drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.c  |    3 +
 drivers/gpu/drm/nouveau/core/engine/falcon.c       |    6 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/base.c    |    2 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c    |  509 +++++--
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |  507 +++++--
 .../gpu/drm/nouveau/core/engine/graph/ctxgm107.c   |  989 ++++++++++++
 .../gpu/drm/nouveau/core/engine/graph/ctxnv108.c   | 1041 ++-----------
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc0.c    |  308 ++--
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc0.h    |  170 +++
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc1.c    |  270 ++--
 .../core/engine/graph/{ctxnvc3.c => ctxnvc4.c}     |   78 +-
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc8.c    |  144 +-
 .../gpu/drm/nouveau/core/engine/graph/ctxnvd7.c    |  216 ++-
 .../gpu/drm/nouveau/core/engine/graph/ctxnvd9.c    |  278 ++--
 .../gpu/drm/nouveau/core/engine/graph/ctxnve4.c    |  285 ++--
 .../gpu/drm/nouveau/core/engine/graph/ctxnvf0.c    |  782 ++++++++--
 .../gpu/drm/nouveau/core/engine/graph/fuc/com.fuc  |    2 +-
 .../gpu/drm/nouveau/core/engine/graph/fuc/gpc.fuc  |    7 +-
 .../nouveau/core/engine/graph/fuc/gpcgm107.fuc5    |   42 +
 .../nouveau/core/engine/graph/fuc/gpcgm107.fuc5.h  |  473 ++++++
 .../nouveau/core/engine/graph/fuc/gpcnv108.fuc5.h  |  354 ++---
 .../nouveau/core/engine/graph/fuc/gpcnvc0.fuc.h    |  336 ++---
 .../nouveau/core/engine/graph/fuc/gpcnvd7.fuc.h    |  396 ++---
 .../nouveau/core/engine/graph/fuc/gpcnve0.fuc.h    |  396 ++---
 .../nouveau/core/engine/graph/fuc/gpcnvf0.fuc.h    |  396 ++---
 .../nouveau/core/engine/graph/fuc/hubgm107.fuc5    |   40 +
 .../nouveau/core/engine/graph/fuc/hubgm107.fuc5.h  |  916 +++++++++++
 .../nouveau/core/engine/graph/fuc/hubnv108.fuc5.h  |    2 +-
 .../nouveau/core/engine/graph/fuc/hubnvc0.fuc.h    |    2 +-
 .../nouveau/core/engine/graph/fuc/hubnvd7.fuc.h    |    2 +-
 .../nouveau/core/engine/graph/fuc/hubnve0.fuc.h    |    2 +-
 .../nouveau/core/engine/graph/fuc/hubnvf0.fuc.h    |    2 +-
 .../drm/nouveau/core/engine/graph/fuc/macros.fuc   |    1 +
 drivers/gpu/drm/nouveau/core/engine/graph/gm107.c  |  465 ++++++
 drivers/gpu/drm/nouveau/core/engine/graph/nv108.c  |  133 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv20.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv40.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv50.c   |   45 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |  312 ++--
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |  214 +--
 drivers/gpu/drm/nouveau/core/engine/graph/nvc1.c   |  115 +-
 .../nouveau/core/engine/graph/{nvc3.c => nvc4.c}   |   86 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc8.c   |  104 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvd7.c   |  175 +--
 drivers/gpu/drm/nouveau/core/engine/graph/nvd9.c   |  154 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nve4.c   |  192 +--
 drivers/gpu/drm/nouveau/core/engine/graph/nvf0.c   |  136 +-
 drivers/gpu/drm/nouveau/core/engine/xtensa.c       |    2 +-
 drivers/gpu/drm/nouveau/core/include/core/class.h  |   12 +
 drivers/gpu/drm/nouveau/core/include/core/device.h |   31 +
 drivers/gpu/drm/nouveau/core/include/core/namedb.h |    2 +-
 .../gpu/drm/nouveau/core/include/engine/device.h   |   18 +-
 drivers/gpu/drm/nouveau/core/include/engine/disp.h |   19 +-
 .../gpu/drm/nouveau/core/include/engine/graph.h    |    3 +-
 .../drm/nouveau/core/include/subdev/bios/P0260.h   |   23 +
 .../drm/nouveau/core/include/subdev/bios/conn.h    |    1 +
 .../drm/nouveau/core/include/subdev/bios/ramcfg.h  |    2 +-
 .../drm/nouveau/core/include/subdev/bios/therm.h   |    7 +
 .../gpu/drm/nouveau/core/include/subdev/devinit.h  |    2 +
 drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |    1 +
 drivers/gpu/drm/nouveau/core/include/subdev/ltcg.h |    3 +-
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h   |    1 +
 .../gpu/drm/nouveau/core/include/subdev/therm.h    |    2 +-
 .../gpu/drm/nouveau/core/include/subdev/timer.h    |    1 +
 drivers/gpu/drm/nouveau/core/os.h                  |   12 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c     |    8 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     |   15 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/P0260.c   |  109 ++
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c    |   55 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c     |   29 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |   18 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/ramcfg.c  |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/therm.c   |   11 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/base.c |    1 +
 .../gpu/drm/nouveau/core/subdev/devinit/fbmem.h    |    8 +-
 .../gpu/drm/nouveau/core/subdev/devinit/gm107.c    |   56 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv05.c |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv20.c |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv50.h |    3 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nva3.c |   50 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nvc0.c |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/priv.h |    1 +
 drivers/gpu/drm/nouveau/core/subdev/fb/gm107.c     |   38 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c      |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.h      |    8 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |    1 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramgm107.c  |   56 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv50.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c   |   34 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c   |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnve0.c   |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv50.c    |    7 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c     |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c |    7 +-
 .../nouveau/core/subdev/ltcg/{nvc0.c => gf100.c}   |  109 +-
 drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.h   |   21 +
 drivers/gpu/drm/nouveau/core/subdev/ltcg/gm107.c   |  142 ++
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c      |   55 +-
 drivers/gpu/drm/nouveau/core/subdev/mxm/base.c     |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/base.c   |   14 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c    |   25 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/fanpwm.c |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nv50.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nvd0.c   |   40 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/priv.h   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/timer/gk20a.c  |   57 +
 drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c   |   83 +-
 drivers/gpu/drm/nouveau/core/subdev/timer/nv04.h   |   27 +
 drivers/gpu/drm/nouveau/core/subdev/timer/priv.h   |    6 +
 drivers/gpu/drm/nouveau/dispnv04/crtc.c            |   22 +-
 drivers/gpu/drm/nouveau/dispnv04/dfp.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |   22 +-
 drivers/gpu/drm/nouveau/nouveau_agp.c              |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |    9 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   22 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |    5 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |   14 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   88 +-
 drivers/gpu/drm/nouveau/nouveau_drm.h              |    5 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |    4 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |    2 -
 drivers/gpu/drm/nouveau/nouveau_hwmon.c            |   17 +-
 drivers/gpu/drm/nouveau/nouveau_sysfs.c            |    8 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |   35 +-
 drivers/gpu/drm/nouveau/nouveau_vga.c              |    5 +
 drivers/gpu/drm/nouveau/nv50_display.c             |   17 +-
 drivers/gpu/drm/omapdrm/omap_crtc.c                |   13 +-
 drivers/gpu/drm/omapdrm/omap_fb.c                  |    5 +-
 drivers/gpu/drm/omapdrm/omap_gem.c                 |   34 +-
 drivers/gpu/drm/panel/Kconfig                      |   14 +
 drivers/gpu/drm/panel/Makefile                     |    2 +
 drivers/gpu/drm/panel/panel-ld9040.c               |  376 +++++
 drivers/gpu/drm/panel/panel-s6e8aa0.c              | 1069 +++++++++++++
 drivers/gpu/drm/panel/panel-simple.c               |  157 +-
 drivers/gpu/drm/qxl/qxl_display.c                  |   10 +-
 drivers/gpu/drm/qxl/qxl_object.c                   |    2 -
 drivers/gpu/drm/qxl/qxl_release.c                  |    2 +-
 drivers/gpu/drm/qxl/qxl_ttm.c                      |    7 +-
 drivers/gpu/drm/radeon/Makefile                    |    8 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |   20 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |  268 ++--
 drivers/gpu/drm/radeon/atombios_encoders.c         |   82 +-
 drivers/gpu/drm/radeon/btc_dpm.c                   |    4 +
 drivers/gpu/drm/radeon/ci_dpm.c                    |   67 +-
 drivers/gpu/drm/radeon/cik.c                       |  142 +-
 drivers/gpu/drm/radeon/cik_sdma.c                  |    6 +-
 drivers/gpu/drm/radeon/cikd.h                      |   49 +
 drivers/gpu/drm/radeon/cypress_dpm.c               |    4 +
 drivers/gpu/drm/radeon/evergreen.c                 |    6 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |  210 +--
 drivers/gpu/drm/radeon/evergreen_dma.c             |    4 +-
 drivers/gpu/drm/radeon/kv_dpm.c                    |   64 +-
 drivers/gpu/drm/radeon/ni.c                        |    8 +-
 drivers/gpu/drm/radeon/ni_dma.c                    |    6 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |    7 +-
 drivers/gpu/drm/radeon/r100.c                      |   49 +-
 drivers/gpu/drm/radeon/r200.c                      |   20 +-
 drivers/gpu/drm/radeon/r300.c                      |   32 +-
 drivers/gpu/drm/radeon/r600.c                      |    6 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |  110 +-
 drivers/gpu/drm/radeon/r600_dma.c                  |    6 +-
 drivers/gpu/drm/radeon/r600_dpm.c                  |   48 +-
 drivers/gpu/drm/radeon/r600_dpm.h                  |    2 +
 drivers/gpu/drm/radeon/radeon.h                    |  158 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |   19 +
 drivers/gpu/drm/radeon/radeon_asic.h               |   14 +
 drivers/gpu/drm/radeon/radeon_connectors.c         |   19 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |  163 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   20 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  248 +--
 drivers/gpu/drm/radeon/radeon_drv.c                |    4 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |   59 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |  958 ------------
 drivers/gpu/drm/radeon/radeon_gem.c                |   49 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   30 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |   16 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |    4 +
 drivers/gpu/drm/radeon/radeon_object.c             |  149 +-
 drivers/gpu/drm/radeon/radeon_object.h             |    9 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |   32 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |  119 +-
 drivers/gpu/drm/radeon/radeon_sa.c                 |    7 +-
 drivers/gpu/drm/radeon/radeon_semaphore.c          |   14 +-
 drivers/gpu/drm/radeon/radeon_test.c               |   39 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   13 +-
 drivers/gpu/drm/radeon/radeon_uvd.c                |    5 +-
 drivers/gpu/drm/radeon/radeon_vce.c                |  699 +++++++++
 drivers/gpu/drm/radeon/radeon_vm.c                 |  966 ++++++++++++
 drivers/gpu/drm/radeon/rs780_dpm.c                 |    7 +-
 drivers/gpu/drm/radeon/rv6xx_dpm.c                 |    7 +-
 drivers/gpu/drm/radeon/rv770_dpm.c                 |    7 +-
 drivers/gpu/drm/radeon/si.c                        |   10 +-
 drivers/gpu/drm/radeon/si_dma.c                    |    4 +-
 drivers/gpu/drm/radeon/si_dpm.c                    |    7 +-
 drivers/gpu/drm/radeon/sid.h                       |   47 +
 drivers/gpu/drm/radeon/sumo_dpm.c                  |    7 +-
 drivers/gpu/drm/radeon/trinity_dpm.c               |    7 +-
 drivers/gpu/drm/radeon/uvd_v1_0.c                  |    2 +-
 drivers/gpu/drm/radeon/vce_v1_0.c                  |  187 +++
 drivers/gpu/drm/radeon/vce_v2_0.c                  |  181 +++
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |   10 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.c              |    5 +-
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c          |   16 +-
 drivers/gpu/drm/tegra/Makefile                     |    2 +
 drivers/gpu/drm/tegra/bus.c                        |    2 +-
 drivers/gpu/drm/tegra/dc.c                         |   16 +-
 drivers/gpu/drm/tegra/dc.h                         |    1 +
 drivers/gpu/drm/tegra/dpaux.c                      |  544 +++++++
 drivers/gpu/drm/tegra/dpaux.h                      |   73 +
 drivers/gpu/drm/tegra/drm.c                        |   19 +-
 drivers/gpu/drm/tegra/drm.h                        |   20 +
 drivers/gpu/drm/tegra/dsi.c                        |   20 +-
 drivers/gpu/drm/tegra/dsi.h                        |   20 +-
 drivers/gpu/drm/tegra/gem.c                        |   25 +-
 drivers/gpu/drm/tegra/gem.h                        |   14 +-
 drivers/gpu/drm/tegra/gr2d.c                       |   14 +-
 drivers/gpu/drm/tegra/mipi-phy.c                   |   20 +-
 drivers/gpu/drm/tegra/mipi-phy.h                   |   20 +-
 drivers/gpu/drm/tegra/output.c                     |    8 +
 drivers/gpu/drm/tegra/sor.c                        | 1092 ++++++++++++++
 drivers/gpu/drm/tegra/sor.h                        |  278 ++++
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c               |    8 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   29 +-
 drivers/gpu/drm/ttm/ttm_bo_manager.c               |   11 +-
 drivers/gpu/drm/ttm/ttm_execbuf_util.c             |    8 +-
 drivers/gpu/drm/ttm/ttm_object.c                   |   46 +
 drivers/gpu/drm/udl/udl_fb.c                       |    2 +-
 drivers/gpu/drm/udl/udl_gem.c                      |    2 +-
 drivers/gpu/drm/udl/udl_modeset.c                  |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_context.c            |    7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c             |   15 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |  148 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |    9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |    5 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |   14 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c              |   10 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   29 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |    8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   24 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c               |    8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |    5 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |  143 +-
 drivers/gpu/host1x/syncpt.c                        |    1 +
 drivers/staging/imx-drm/imx-hdmi.c                 |    1 -
 drivers/staging/imx-drm/imx-ldb.c                  |    2 -
 drivers/staging/imx-drm/imx-tve.c                  |    2 -
 drivers/staging/imx-drm/ipuv3-crtc.c               |    6 +-
 drivers/staging/imx-drm/ipuv3-plane.c              |    2 +-
 drivers/staging/imx-drm/parallel-display.c         |    2 -
 drivers/video/exynos/Kconfig                       |    7 -
 drivers/video/exynos/Makefile                      |    1 -
 fs/dcache.c                                        |    1 +
 include/drm/bridge/ptn3460.h                       |   37 +
 include/drm/drmP.h                                 |  243 ++-
 include/drm/drm_crtc.h                             |  225 +--
 include/drm/drm_crtc_helper.h                      |    6 +-
 include/drm/drm_dp_helper.h                        |  125 ++
 include/drm/drm_fb_helper.h                        |    6 +
 include/drm/drm_gem_cma_helper.h                   |    2 +
 include/drm/drm_mipi_dsi.h                         |    6 +
 include/drm/drm_mm.h                               |  182 ++-
 include/drm/drm_modes.h                            |  237 +++
 include/drm/drm_plane_helper.h                     |   49 +
 include/drm/drm_vma_manager.h                      |    6 +-
 include/drm/gma_drm.h                              |   70 +-
 include/drm/ttm/ttm_bo_driver.h                    |   49 +-
 include/drm/ttm/ttm_object.h                       |    4 +
 include/drm/ttm/ttm_placement.h                    |    3 +
 include/linux/hdmi.h                               |   12 +
 include/linux/host1x.h                             |    1 +
 include/uapi/drm/drm.h                             |   17 +
 include/uapi/drm/msm_drm.h                         |   12 +
 include/uapi/drm/radeon_drm.h                      |   20 +
 include/uapi/drm/tegra_drm.h                       |   24 +-
 include/uapi/drm/vmwgfx_drm.h                      |   12 +-
 487 files changed, 37464 insertions(+), 15923 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/drm/bridge/ptn3460.txt
 create mode 100644 Documentation/devicetree/bindings/drm/i2c/tda998x.txt
 create mode 100644 Documentation/devicetree/bindings/panel/lg,ld070wx3-sl01.txt
 create mode 100644 Documentation/devicetree/bindings/panel/lg,lh500wx1-sd03.txt
 create mode 100644 Documentation/devicetree/bindings/panel/lg,lp129qe.txt
 create mode 100644 Documentation/devicetree/bindings/panel/samsung,ld9040.txt
 create mode 100644 Documentation/devicetree/bindings/panel/samsung,s6e8aa0.txt
 create mode 100644 Documentation/devicetree/bindings/video/exynos_dsim.txt
 create mode 100644 drivers/gpu/drm/bridge/Kconfig
 create mode 100644 drivers/gpu/drm/bridge/Makefile
 create mode 100644 drivers/gpu/drm/bridge/ptn3460.c
 create mode 100644 drivers/gpu/drm/drm_crtc_internal.h
 create mode 100644 drivers/gpu/drm/drm_plane_helper.c
 rename drivers/{video => gpu/drm}/exynos/exynos_dp_core.c (83%)
 rename drivers/{video => gpu/drm}/exynos/exynos_dp_core.h (97%)
 rename drivers/{video => gpu/drm}/exynos/exynos_dp_reg.c (100%)
 rename drivers/{video => gpu/drm}/exynos/exynos_dp_reg.h (100%)
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_dpi.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_dsi.c
 delete mode 100644 drivers/gpu/drm/exynos/exynos_drm_hdmi.c
 delete mode 100644 drivers/gpu/drm/exynos/exynos_drm_hdmi.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_mixer.h
 create mode 100644 drivers/gpu/drm/gma500/blitter.c
 create mode 100644 drivers/gpu/drm/gma500/blitter.h
 create mode 100644 drivers/gpu/drm/gma500/gem.h
 create mode 100644 drivers/gpu/drm/gma500/gma_device.c
 create mode 100644 drivers/gpu/drm/gma500/gma_device.h
 create mode 100644 drivers/gpu/drm/gma500/mmu.h
 create mode 100644 drivers/gpu/drm/i915/i915_cmd_parser.c
 create mode 100644 drivers/gpu/drm/i915/i915_params.c
 create mode 100644 drivers/gpu/drm/msm/hdmi/hdmi_audio.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/device/gm100.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/gm107.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/priv.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxgm107.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc0.h
 rename drivers/gpu/drm/nouveau/core/engine/graph/{ctxnvc3.c => ctxnvc4.c} (65%)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/gpcgm107.fuc5
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/gpcgm107.fuc5.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/hubgm107.fuc5
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/hubgm107.fuc5.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/gm107.c
 rename drivers/gpu/drm/nouveau/core/engine/graph/{nvc3.c => nvc4.c} (66%)
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/P0260.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/P0260.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/gm107.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/gm107.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramgm107.c
 rename drivers/gpu/drm/nouveau/core/subdev/ltcg/{nvc0.c => gf100.c} (66%)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ltcg/gm107.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/timer/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/timer/nv04.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/timer/priv.h
 create mode 100644 drivers/gpu/drm/panel/panel-ld9040.c
 create mode 100644 drivers/gpu/drm/panel/panel-s6e8aa0.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_vce.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_vm.c
 create mode 100644 drivers/gpu/drm/radeon/vce_v1_0.c
 create mode 100644 drivers/gpu/drm/radeon/vce_v2_0.c
 create mode 100644 drivers/gpu/drm/tegra/dpaux.c
 create mode 100644 drivers/gpu/drm/tegra/dpaux.h
 create mode 100644 drivers/gpu/drm/tegra/sor.c
 create mode 100644 drivers/gpu/drm/tegra/sor.h
 create mode 100644 include/drm/bridge/ptn3460.h
 create mode 100644 include/drm/drm_modes.h
 create mode 100644 include/drm/drm_plane_helper.h
--29444707-1725652128-1396918718=:1523--
