Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaJNBwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:52:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59638 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbaJNBwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:52:38 -0400
Date: Tue, 14 Oct 2014 02:52:35 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm tree for 3.18-rc1
Message-ID: <alpine.DEB.2.00.1410140251370.28670@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-2032093349-1413251555=:28670"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-2032093349-1413251555=:28670
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

This is the main git pull for the drm, I pretty much froze major pulls at 
-rc5/6 time, and haven't had much fallout, so will probably continue doing 
that.

Lots of changes all over, big internal header cleanup to make it clear drm
features are legacy things and what are things that modern KMS drivers should
be using. Also big move to use the new generic fences in all the TTM drivers.

core:
	atomic prep work,
	vblank rework changes, allows immediate vblank disables
	major header reworking and cleanups to better delinate legacy
	interfaces from what KMS drivers should be using.
	cursor planes locking fixes

ttm:
	move to generic fences (affects all TTM drivers)
	ppc64 caching fixes
radeon: 
	userptr support,
	uvd for old asics,
	reset rework for fence changes
	better buffer placement changes,
	dpm feature enablement
	hdmi audio support fixes
intel:
	Cherryview work,
	180 degree rotation,
	skylake prep work,
	execlist command submission
	full ppgtt prep work
	cursor improvements
	edid caching,
	vdd handling improvements
	
nouveau:
	fence reworking
	kepler memory clock work
	gt21x clock work
	fan control improvements
	hdmi infoframe fixes
	DP audio
ast:
	ppc64 fixes
	caching fix

rcar: rcar-du DT support
ipuv3: prep work for capture support
msm: LVDS support for mdp4, new panel, gpu refactoring
exynos: exynos3250 SoC support, drop bad mmap interface,
	mipi dsi changes, and component match support.

Dave.

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to dfda0df3426483cf5fc7441f23f318edbabecb03:

  drm/mst: rework payload table allocation to conform better. (2014-10-13 14:40:53 +1000)

----------------------------------------------------------------
Alex Deucher (18):
      drm/radeon: add set_uvd_clocks callback for r6xx v4
      drm/radeon: 760G/780V/880V don't have UVD
      drm/radeon: add RADEON_GEM_NO_CPU_ACCESS BO creation flag (v4)
      drm/radeon: fix register name to match internal name
      drm/radeon: consolidate duplicate encode is digital function
      drm/radeon: consolidate r600_audio.c into r600_hdmi.c
      drm/radeon: split audio enable between eg and r600 (v2)
      drm/radeon: disable audio when we disable hdmi (v2)
      drm/radeon/dpm: drop clk/voltage dependency filters for NI
      drm/radeon/dpm: drop clk/voltage dependency filters for SI
      drm/radeon/dpm: drop clk/voltage dependency filters for CI
      drm/radeon/dpm: drop clk/voltage dependency filters for BTC
      drm/radeon: drop btc_get_max_clock_from_voltage_dependency_table
      drm/radeon: remove unecessary includes
      drm/radeon/si: print full CS when we hit a packet 0
      drm/radeon/cik: write gfx ucode version to ucode addr reg
      drm/radeon/ci: add uvd/vce info to dpm debugfs output
      drm/radeon/kv: add uvd/vce info to dpm debugfs output

Andreas Pokorny (2):
      drm/qxl: simple crtc page flipping emulated using buffer copy
      drm/qxl: enables gem prime helpers for qxl using dummy driver callbacks

Andrzej Hajda (27):
      drm/exynos/ipp: remove fake pm callbacks
      drm/exynos/ipp: cancel works before command node clean
      drm/exynos/ipp: move file reference from memory to command node
      drm/exynos/ipp: remove only related commands on file close
      drm/exynos/ipp: remove unused field in command node
      drm/exynos/ipp: free partially allocated resources on error
      drm/exynos/ipp: move nodes cleaning to separate function
      drm/exynos/ipp: clean memory nodes on command node cleaning
      drm/exynos/ipp: replace work_struct casting with better constructs
      drm/exynos/ipp: stop hardware before freeing memory
      drm/exynos/ipp: remove events during command cleaning
      drm/exynos/fimc: avoid clearing overflow bits
      drm/exynos/fimc: do not enable fimc twice
      drm/exynos/fimc: simplify buffer queuing
      drm/exynos/fimc: fix source buffer registers
      drm/exynos/ipp: remove file argument from node related functions
      drm/exynos/ipp: add file checks for ioctls
      drm/exynos/ipp: traverse ipp drivers list safely
      drm/exynos: fix drm driver de-initialization order
      drm/exynos/fbdev: fix fbdev gem object cleanup
      drm/exynos/fb: free exynos framebuffer on error
      drm/exynos/dsi: unregister connector on removal
      drm/exynos/dpi: unregister connector and panel on removal
      drm/exynos/dp: unregister connector on removal
      drm/exynos/hdmi: unregister connector on removal
      drm/exynos: switch to universal plane API
      drm/core: use helper to check driver features

Andy Shevchenko (1):
      drm: i915: reduce memory footprint when debugging

Arun Siluvery (2):
      drm/i915/bdw: Apply workarounds in render ring init function
      drm/i915/bdw: Export workaround data to debugfs

Axel Lin (2):
      gpu: ipu-v3: Select GENERIC_IRQ_CHIP to fix build error
      gpu: ipu-v3: Return proper error on ipu_add_client_devices error path

Ben Skeggs (35):
      drm/nouveau/bar: ioremap only the areas that we're actually using
      drm/nouveau/core: pass related object into notify constructor
      drm/nv50-/disp: add support for completion events
      drm/nouveau/ltc: drop workaround for an interrupt storm that no longer happens
      drm/gf100/ltc: translate interrupt status into more meaningful names
      drm/nouveau/core/mm: make it clearer what (type == 0) means
      drm/nouveau/core/mm: modify test for if building a mm with holes in it
      drm/nouveau/core/mm: dump mm when trying to tear one down that still has allocations
      drm/nouveau/core/mm: fill in holes with "allocated" nodes
      drm/nouveau/core/mm: allow allocation to be confined to a specific slice of heap
      drm/nouveau/ltc: allocate tagram from memory that spans all partitions
      drm/nouveau/pwr: wait for scrubbers to finish before uploading new ucode
      drm/gk104/fb/ram: skip table entry for mode we're already in
      drm/gk104/fb/ram: more random magic in fb init
      drm/gk104/fb/ram: fix register for second set of training data
      drm/nouveau/bios: add support for parsing table at BIT 'M' v2 + 0x05
      drm/nouveau/bios: add support for parsing table at BIT 'M' v2 + 0x09
      drm/gk104/fb/ram: make use of training data provided by vbios
      drm/nouveau/bios: memset dcb struct to zero before parsing
      drm/nouveau/bios: parse freq ranges and timing id into ramcfg struct
      drm/gk104-/fb/ram: use parsed timing data in mr routines
      drm/gk104-/fb/ram: parse ramcfg data for all frequencies up-front
      drm/gk104-/fb/ram: perform certain steps only when bios data differs
      drm/nouveau/bios: parse another large chunk of random memory config data
      drm/gk104/fb/ram: twiddle some more bits when reclocking
      drm/gk104-/fb/ram: move fb enable/disable to same place as nvidia
      drm/nouveau/pwr/memx: rename fb off/on to block/unblock
      drm/nouveau/pwr/memx: fix command ordering around block/unblock
      drm/gf100-/pwr/memx: block host and fifo around reclock
      drm/nouveau/bios: parse older ramcfg/timing data like we do newer ones
      drm/gk104-/disp: infoframe registers moved yet again on kepler
      drm/gt214-/kms: perform hda codec setup on displayport too
      drm/g94-/disp: calculate some dp audio constants
      drm/gt214-/kms: fix hda eld regression
      drm/gt214-/disp: enable dp audio

Ben Widawsky (3):
      drm/i915/bdw: Implement context switching (somewhat)
      drm/i915/bdw: Print context state in debugfs
      drm/i915: Don't save/restore RS when not used

Benjamin Herrenschmidt (8):
      drm/ast: Try to use MMIO registers when PIO isn't supported
      drm/ast: POST chip at probe time if VGA not enabled
      drm/ast: Properly initialize P2A base before using it in ast_init_3rdtx()
      drm/ast: Don't assume DVO enabled means SIL164 on uninitialized chips
      drm/ast: Cleanup analog init code path
      drm: powerpc can use a simpler drm_io_prot()
      drm/ttm: Clean usage of ttm_io_prot() with TTM_PL_FLAG_CACHED
      drm/ast: Fix HW cursor image

Chris Wilson (36):
      drm: Perform cmdline mode parsing during connector initialisation
      drm/i915: Only perform set-to-gtt domain for objects bound to the global gtt
      drm/i915: Force CPU relocations if not GTT mapped
      drm/i915: Remove fenced_gpu_access and pending_fenced_gpu_access
      drm/i915: Copy PCI device id into the device info block
      drm/i915: Double check ring is idle before declaring the GPU wedged
      drm/i915: Agnostic INTEL_INFO
      drm/i915: Pre-validate the NEED_GTTS flag for execbuffer
      drm/i915: Remove redundant list_empty(eb->vmas) tests in execbuffer
      drm/i915: Simplify relocate_entry_gtt() and make 64-bit safe
      drm/i915: Replace __I915__ with typesafe variant
      drm/i915: Localise the fbdev console lock frobbing
      drm/i915: Print captured bo for all VM in error state
      drm/i915: Do not access stolen memory directly by the CPU, even for error capture
      drm/i915: Remove num_pages parameter to i915_error_object_create()
      drm/i915: Suppress a WARN on reading an object back for a GPU hang
      drm/i915: honour forced connector modes
      drm/i915: Make wait-for-pending-flips more defensive
      drm/i915: Differentiate between LLC or snooped for the user
      drm/i915/dp: Refactor common eDP lid detection
      drm/i915/dp: Cache EDID for a detection cycle
      drm/i915/hdmi: Cache EDID for a detection cycle
      drm/i915: Rename global latency_ns variable
      drm/i915: Remove shadowed local variable 'i' from i915_interrupt_info
      drm/i915: Fix unsafe vma iteration in i915_drop_caches
      drm/i915: Reset the HEAD pointer for the ring after writing START
      drm/i915: Check for a stalled page flip after each vblank
      drm/i915: Decouple the stuck pageflip on modeset
      drm: Include task->name and master status in debugfs clients info
      drm/i915/hdmi, dp: Do not dereference the encoder in the connector destroy
      drm/i915: Objects on the unbound list may still have an active reference
      drm/i915: Drop any active reference before unbinding
      drm/i915: Wrap -EIO send-vblank event for failed pageflip in spinlock
      drm/i915: HSW always use GGTT selector for secure batches
      drm/i915: Match GTT space sanity checker with implementation
      drm/i915: Do not store the error pointer for a failed userptr registration

Christian König (24):
      drm/radeon: add userptr support v8
      drm/radeon: add userptr flag to limit it to anonymous memory v2
      drm/radeon: add userptr flag to directly validate the BO to GTT
      drm/radeon: add userptr flag to register MMU notifier v3
      drm/radeon: allow userptr write access under certain conditions
      drm/ttm: move fpfn and lpfn into each placement v2
      drm/radeon: move the IB test after the AGP fallback
      drm/radeon: force UVD buffers into VRAM on RS[78]80 v2
      drm/radeon: properly init UVD MC bits on R600
      drm/radeon: add UVD support for older asics v4
      drm/radeon: implement UVD hw workarounds for R6xx v3
      drm/radeon: enable RB_ARB before resetting the VCPU
      drm/radeon: add UVD fw names for older asic
      drm/radeon: wake up all fences on manual reset
      drm/radeon: force fence completion only on problematic rings (v2)
      drm/radeon: handle lockup in delayed work, v5
      drm/radeon: drop RADEON_FENCE_SIGNALED_SEQ v2
      drm/radeon: drop doing resets in a work item
      drm/radeon: allow UVD to use a second 256MB segment
      drm/radeon: preallocate mem for UVD create/destroy msg
      drm/ttm: allow fence to be added as shared
      drm/radeon: add the infrastructure for concurrent buffer access
      drm/radeon: allow concurrent buffer reads
      drm/radeon: fix AGP userptr handling

Clint Taylor (4):
      drm/edid: Reduce horizontal timings for pixel replicated modes
      drm/i915/hdmi: Enable pipe pixel replication for SD interlaced modes
      drm/i915: Enable pixel replicated modes on BDW and HSW.
      drm/edid: Add missing interlaced flag to 576i@100 modes.

Daisy Sun (1):
      drm/i915/bdw: BDW Software Turbo

Damien Lespiau (34):
      drm/i915: Specify when the PLL hw state fields are valid
      drm/i915: Add a space to the shared DPLL debug message
      drm/i915: Extract the HSW DDI selection code into its own function
      drm/i915: Extract the HSW/BDW shared dpll init code
      drm/i915: Restrict hsw_dp_set_ddi_pll_sel() to HSW/BDW
      drm/i915: Fix stale comment for intel_ddi_pll_select()
      drm/i915: Split the BDW/HSW specific shared pll selection
      drm/i915: Make intel_ddi_calculate_wrpll() HSW/BDW specific
      drm/i915: Split the CDCLK retrieval per-platform
      drm/i915: Gather the HDMI level shifter logic into one place
      drm/i915/bdw: Provide the BDW specific HDMI buffer translation table
      drm/i915/bdw: Remove the HDMI/DVI entry from the DP/eDP/FDI tables
      drm/i915: Remove now useless comments about the translation values
      drm/i915: Demote the DRRS messages to debug messages
      drm/i915: Introduce a for_each_intel_encoder() macro
      drm/i915: Fix erroneous conversion to u8
      drm/i915: Fix wrong number of HDMI translation entries
      drm/i915: Make intel_disable_shared_dpll() static
      drm/i915: Remove set but unused 'gt_perf_status'
      drm: Don't return 0 for a value used as a denominator
      drm: Use the type of the array element when reallocating
      drm/i915/bdw: Disable execlists by default
      drm/i915: Use dev_priv as first argument of for_each_pipe()
      drm/i915: Print the pipe on which the vblank wait times out
      drm/i915: Don't use a define when it's clearer to just put the value
      drm/i915: Add "Intel Corporation" as module author
      drm/i915/bdw: Let the memory controller do all the swizzling
      drm/i915: Rename intel_wa_registers with a i915_ prefix
      drm/i915: Don't overrun the intel_wa_regs array
      drm/i915: Don't silently discard workarounds
      drm/i915: Remove unneeded brackets
      drm/i915: Don't restrict i915_wa_registers to BDW
      drm/i915: Rewrite ABS_DIFF() in a safer manner
      drm/i915: Introduce a for_each_plane() macro

Daniel Kurtz (1):
      drm/exynos/fbdev: set smem_len for fbdev

Daniel Vetter (69):
      drm: Don't grab an fb reference for the idr
      video/fbdev: Always built-in video= cmdline parsing
      drm/i915: Make ddi_clock_gate() HSW/BDW specific
      drm/i915: Align intel_dsi*.c files a bit
      drm/i915: No busy-loop wait_for in the ring init code
      drm: Add drm_plane/connector_index
      drm: Move modeset_lock_all helpers to drm_modeset_lock.[hc]
      drm: Handle legacy per-crtc locking with full acquire ctx
      drm: Move ->old_fb from crtc to plane
      drm: trylock modest locking for fbdev panics
      drm/i915: Update DRIVER_DATE to 20140808
      drm/i915: Fix secure dispatch with full ppgtt
      drm: Add a plane->reset hook
      drm/irq: Implement a generic vblank_wait function
      drm/i915: WARN if module opt sanitization goes out of order
      drm/i915/bdw: Add a context and an engine pointers to the ringbuffer
      drm/i915: Some cleanups for the ppgtt lifetime handling
      drm/i915: Track file_priv, not ctx in the ppgtt structure
      drm/i915: Only refcount ppgtt if it actually is one
      drm/i915: Add proper prefix to obj_to_ggtt
      drm/i915: Allow i915_gem_setup_global_gtt to fail
      drm/i915: Fix up checks for aliasing ppgtt
      drm/i915: Rework ppgtt init to no require an aliasing ppgtt
      drm/i915: Initialize the aliasing ppgtt as part of global gtt
      drm/i915: Only track real ppgtt for a context
      drm/i915: Drop create_vm argument to i915_gem_create_context
      drm/i915: Extract common cleanup into i915_ppgtt_release
      drm/i915: Extract commmon global gtt cleanup code
      drm/i915: Cleanup aliasging ppgtt alongside the global gtt
      drm: Docbook fixes
      drm/i915: Track cursor changes as frontbuffer tracking flushes
      drm/i915: Update DRIVER_DATE to 20140822
      MAINTAINERS: Update Daniel Vetter's email address
      drm/i915: Update DRIVER_DATE to 20140905
      drm: Really never disable vblank irqs for offdelay==0
      drm: Only update final vblank count when precise ts is available
      drm: Simplify return value of drm_get_last_vbltimestamp
      drm: Clarify vblank ts/scanoutpos sampling #defines
      Merge remote-tracking branch 'airlied/drm-next' into topic/vblank-rework
      drm: Move dma functions into drm_legacy.h
      drm: Move sg functions into drm_legacy.h
      drm: Move drm_legacy_vma_flush into drm_legacy.h
      drm: Create drm legacy driver header
      drm: Move __drm_pci_free to drm_legacy.h
      drm: Drop drm_sysfs_class from drmP.h
      drm: Move vblank related module options into drm_irq.c
      drm: Move piles of functions from drmP.h to drm_internal.h
      drm: unexport drm_global_mutex
      drm: Purge ioctl forward declarations from drmP.h
      drm: Move drm_memory.c map support declarations to <drm/drm_legacy.h>
      drm: Move legacy buffer structures to <drm/drm_legacy.h>
      drm: Move LOCK_TEST_WITH_RETURN to <drm/drm_legacy.h>
      drm: Move drm_class to drm_internal.h
      drm: Move DRM_MAGIC_HASH_ORDER into drm_drv.c
      drm: Drop modeset locking from crtc init function
      drm/i915: Don't reinit hpd interrupts after gpu reset
      drm/i915: Extend BIOS stolen mem handling to all platform
      drm/<ttm-based-drivers>: Don't call drm_mmap
      drm/gem: Don't call drm_mmap from drm_gem_mmap
      drm: move drm_mmap to <drm/drm_legacy.h>
      drm: Move drm_vm_open_locked into drm_internal.h
      drm: Move leftover ioctl declarations to drm_internal.h
      drm: Move internal debugfs functions to drm_internal.h
      drm: Extract <drm/drm_gem.h>
      drm/doc: Fixup drm_irq kerneldoc includes.
      drm: Fixup locking for universal cursor planes
      drm: Improve debug output for drm_wait_one_vblank
      drm: Drop grab fpriv->fbs_lock in drm_fb_release
      Revert "drm/i915/bdw: BDW Software Turbo"

Dave Airlie (31):
      Merge tag 'topic/core-stuff-2014-08-15' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'drm-intel-next-2014-08-08' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge branch 'drm-next-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'ttm_pfn' of git://people.freedesktop.org/~deathsimple/linux into drm-next
      Merge branch 'drm-next-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-next-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge tag 'drm-intel-next-2014-09-01' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge branch 'for-airlied-next' of git://people.freedesktop.org/~mlankhorst/linux into drm-next
      Merge tag 'ipu-3.18' of git://git.pengutronix.de/git/pza/linux into drm-next
      Merge branch 'drm-next-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'msm-next' of git://people.freedesktop.org/~robclark/linux into drm-next
      Merge branch 'drm-next-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-next
      drm: split ati_pcigart.h out of drmP.h
      drm/ast: switch to using CACHED by default for sysram
      Merge tag 'topic/vblank-rework-2014-09-12' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'topic/drm-header-rework-2014-09-12' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'topic/core-stuff-2014-09-15' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge branch 'linux-3.18' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      drm: backmerge tag 'v3.17-rc5' into drm-next
      Merge branch 'drm-next-ast-fixes' of ssh://people.freedesktop.org/~/linux into drm-next
      Merge tag 'drm-intel-next-2014-09-05' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge branch 'drm/next/du' of git://linuxtv.org/pinchartl/fbdev into drm-next
      Merge branch 'drm-next-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge tag 'topic/core-stuff-2014-09-29' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge branch 'for-airlied-next' of git://people.freedesktop.org/~mlankhorst/linux into drm-next
      Merge branch 'drm-next-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge tag 'drm-intel-next-fixes-2014-10-03' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'topic/core-stuff-2014-10-03' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'ipu-fixes-3.18' of git://git.pengutronix.de/git/pza/linux into drm-next
      drm/mst: rework payload table allocation to conform better.

David Herrmann (20):
      drm/radeon: move drm_buffer to drm/radeon/
      drm: mark drm_buf and drm_map as legacy
      drm: move "struct drm_vma_entry" to drm_vm.c
      drm: move "struct drm_magic_entry" to drm_auth.c
      drm: drop unused "struct drm_waitlist"
      drm: move AGP definitions harder
      drm: replace weird conditional includes
      drm: drop __KERNEL__ protection in drmP.h
      drm: merge drm_memory.h into drm_memory.c
      drm: move __OS_HAS_AGP into drm_agpsupport.h
      drm: order includes alphabetically in drmP.h
      drm: drop DRM_DEBUG_CODE
      drm: inline "struct drm_sigdata"
      drm: move remaining includes in drmP.h to the top
      drm: simplify drm_*_set_unique()
      drm: drop unused drm_master->unique_size
      drm: add driver->set_busid() callback
      drm: Goody bye, drm_bus!
      drm: merge drm_usb into udl
      drm: move drm-lock API to drm_legacy.h

Deepak S (3):
      drm/i915: Bring UP Power Wells before disabling RC6.
      drm/i915: Fix to Enable GT/PM Interrupts
      drm/i915: add cherryview specfic forcewake in execlists_elsp_write

Derek Foreman (1):
      drm/i915: init sprites with univeral plane init function

Emil Velikov (1):
      drm/nouveau/gpio: rename g92 class to g94

Ezequiel Garcia (8):
      drm/tilcdc: Fix the error path in tilcdc_load()
      drm/tilcdc: panel: Add missing of_node_put
      drm/tilcdc: panel: Remove unused variable
      drm/tilcdc: panel: Spurious whitespace removal
      drm/tilcdc: panel: Use devm_kzalloc to simplify the error path
      drm/tilcdc: panel: Fix backlight devicetree support
      drm/tilcdc: panel: Set return value explicitly
      drm/tilcdc: panel: Add support for enable GPIO

Fabian Frederick (9):
      drm/cirrus: use container_of to resolve cirrus_fbdev from drm_fb_helper
      drm/mgag200: use container_of to resolve mga_fbdev from drm_fb_helper
      drm/radeon: use container_of to resolve radeon_fbdev from drm_fb_helper
      drm/nouveau: use container_of to resolve nouveau_fbdev from drm_fb_helper
      drm/nouveau: use container_of to resolve nouveau_plane from drm_plane
      drm/qxl: use container_of to resolve qxl_fbdev from drm_fb_helper
      drm/gma500: use container_of to resolve psb_fbdev from drm_fb_helper
      drm/ast: use container_of to resolve ast_fbdev from drm_fb_helper
      drm/udl: use container_of to resolve udl_fbdev from drm_fb_helper

Fabio Estevam (2):
      gpu: ipu-v3: ipu-smfc: Do not leave DEBUG defined
      gpu: ipu-v3: Kconfig: Remove SOC_IMX6SL from IMX_IPUV3_CORE Kconfig

Gajanan Bhat (4):
      drm/i915: Update DDL only for current CRTC
      drm/i915: Generalize drain latency computation
      drm/i915: Round-up clock and limit drain latency
      drm/i915: Add sprite watermark programming for VLV and CHV

Gustavo Padovan (1):
      drm/i915: trivial: remove unneed set to NULL

Imre Deak (1):
      drm/i915: fix suspend/resume for GENs w/o runtime PM support

Inki Dae (10):
      drm/mipi-dsi: consider low power transmission
      drm/exynos: mipi-dsi: consider non-continuous clock mode
      drm/exynos: mipi-dsi: add Exynos3 SoC support
      drm/exynos: fimd: add Exynos3 SoC support
      ARM: dts: add fimd device node to exynos3250.dsti
      ARM: dts: add mipi_phy device node to exynos3250.dtsi
      ARM: dts: add mipi dsi device node to exynos3250.dtsi
      drm/exynos: update to use component match support
      drm/exynos: remove DRM_EXYNOS_GEM_MAP_OFFSET ioctl
      drm/exynos: use drm generic mmap interface

Jani Nikula (12):
      drm/i915/dp: split up panel power control from backlight pwm control
      drm/i915: add some framework for backlight bl_power support
      drm/i915/dp: make backlight bl_power control power sequencer backlight
      drm/i915: switch off backlight for backlight class 0 brightness
      drm/i915: don't check for i830 in vlv specific code
      drm/i915: fix panel unlock register mask
      drm/i915: improve assert_panel_unlocked
      drm/i915/dp: debug log whether backlight is being enabled or disabled
      drm/i915/ddi: use struct for ddi buf translation tables
      drm/i915: debug sink dpms aux errors also on enable
      drm/i915/dp: add missing \n in the TPS3 debug message
      drm/i915/edp: use lane count and link rate from DPCD for eDP

Jesse Barnes (2):
      drm/i915: clean up PPGTT checking logic
      drm/i915: make fbdev initialization asynchronous v2

Joe Perches (1):
      drm: change drm_err return type to void

Joonyoung Shim (1):
      drm/exynos: factor out initial setting of each driver

Josh Boyer (1):
      drm/vmwgfx: Fix drm.h include

Julia Lawall (1):
      drm: use c99 initializers in structures

Kees Cook (1):
      drm/ttm: make sure format string cannot leak in

Laurent Pinchart (11):
      drm/gem: Fix kerneldoc typo
      drm/rcar-du: Update copyright notice
      drm/shmob: Update copyright notice
      devicetree: Add vendor prefix "mitsubishi" to vendor-prefixes.txt
      devicetree: Add vendor prefix "thine" to vendor-prefixes.txt
      video: Add DT binding documentation for VGA connector
      video: Add ADV7123 DT bindings documentation
      video: Add THC63LVDM83D DT bindings documentation
      video: Add DT bindings for the R-Car Display Unit
      drm/rcar-du: Use struct videomode in platform data
      drm/rcar-du: Add OF support

Maarten Lankhorst (33):
      drm/radeon: take exclusive_lock in read mode during ring tests, v5
      drm/radeon: add timeout argument to radeon_fence_wait_seq v2
      drm/nouveau: add reservation to nouveau_gem_ioctl_cpu_prep
      drm/nouveau: require reservations for nouveau_fence_sync and nouveau_bo_fence
      drm/ttm: call ttm_bo_wait while inside a reservation
      drm/ttm: kill fence_lock
      drm/ttm: add interruptible parameter to ttm_eu_reserve_buffers
      drm/ttm: kill off some members to ttm_validate_buffer
      drm/radeon: use common fence implementation for fences, v4
      drm/vmwgfx: get rid of different types of fence_flags entirely
      drm/vmwgfx: rework to new fence interface, v2
      drm/nouveau: rework to new fence interface
      drm/qxl: rework to new fence interface
      drm/ttm: flip the switch, and convert to dma_fence
      drm/nouveau: use rcu in nouveau_gem_ioctl_cpu_prep
      drm/radeon: use rcu waits in some ioctls
      drm/vmwgfx: use rcu in vmw_user_dmabuf_synccpu_grab
      drm/ttm: use rcu in core ttm
      drm/nouveau: Keep only a single list for validation.
      drm/nouveau: use shared fences for readable objects
      drm/qxl: Remove release_lock stupidity
      drm/qxl: fix gaping memory hole
      drm/qxl: Fix crash in eviction from qxl_release_fence_buffer_objects
      drm/nouveau: nv84+: fix fence context seqno's
      drm/nouveau: bump driver patchlevel to 1.2.1
      drm/nouveau: specify if interruptible wait is desired in nouveau_fence_sync
      drm/nouveau: assign fence_chan->name correctly
      drm: Pass dma-buf as argument to gem_prime_import_sg_table
      drm/ttm: add reservation_object as argument to ttm_bo_init
      drm/nouveau: export reservation_object from dmabuf to ttm
      drm/radeon: cope with foreign fences inside display
      drm/radeon: cope with foreign fences inside the reservation object
      drm/radeon: export reservation_object from dmabuf to ttm

Marek Szyprowski (1):
      drm/exynos: fimd: fix window clear code

Mario Kleiner (3):
      drm: Remove drm_vblank_cleanup from drm_vblank_init error path.
      drm: Use vblank_disable_and_save in drm_vblank_cleanup()
      drm: Don't update vblank timestamp when the counter didn't change

Martin Peres (12):
      drm/nouveau/bios/fan: add support for maxwell's fan management table v2
      drm/nouveau/therm/fan: do not use the pwm mode when the vbios tells us to use toggle
      drm/gm107/therm: add PWM fan support v2
      drm/nouveau/ppwr: enable ppwr on gm107
      drm/nouveau/pwr: fix the timers implementation with concurent processes
      drm/nouveau/pwr: add some arith functions (mul32_32_64, subu64 and addu64)
      drm/nouveau/pwr: add helpers for delay-to-ticks and ticks-to-delay
      drm/nouveau/pwr/fuc: add ld/st macros
      drm/nouveau/pwr/fuc: make $r1-$r10 registers callee-saved in kernel.fuc
      drm/nouveau/subdev: add a pfuse subdev v2
      drm/nouveau/therm: make sure the temperature settings are sane on nv84+
      drm/nouveau/therm/nv84+: do not expose non-calibrated internal temp sensor

McAulay, Alistair (1):
      drm/i915: Rework GPU reset sequence to match driver load & thaw

Michel Dänzer (2):
      drm/radeon: Add RADEON_GEM_CPU_ACCESS BO creation flag
      drm/radeon: Clean up assignment of TTM placement lpfn member for pinning

Michel Thierry (4):
      drm/i915: vma/ppgtt lifetime rules
      drm/i915/bdw: Two-stage execlist submit process
      drm/i915: Handle i915_ppgtt_put correctly
      drm/i915: fix another use-after-free in i915_gem_evict_everything

Michele Curti (2):
      drm/radeon/atombios: declare connector convert tables as static
      drm/radeon/combios: declare legacy_connector_convert as static

Mika Kuoppala (1):
      drm/i915/bdw: Cleanup pre prod workarounds

Oscar Mateo (35):
      drm/i915/bdw: New source and header file for LRs, LRCs and Execlists
      drm/i915/bdw: Macro for LRCs and module option for Execlists
      drm/i915/bdw: Initialization for Logical Ring Contexts
      drm/i915/bdw: Introduce one context backing object per engine
      drm/i915/bdw: A bit more advanced LR context alloc/free
      drm/i915/bdw: Allocate ringbuffers for Logical Ring Contexts
      drm/i915/bdw: Populate LR contexts (somewhat)
      drm/i915/bdw: Deferred creation of user-created LRCs
      drm/i915: Abstract the legacy workload submission mechanism away
      drm/i915/bdw: Skeleton for the new logical rings submission path
      drm/i915/bdw: Generic logical ring init and cleanup
      drm/i915/bdw: GEN-specific logical ring init
      drm/i915/bdw: GEN-specific logical ring set/get seqno
      drm/i915/bdw: New logical ring submission mechanism
      drm/i915/bdw: GEN-specific logical ring emit request
      drm/i915/bdw: GEN-specific logical ring emit flush
      drm/i915/bdw: Ring idle and stop with logical rings
      drm/i915/bdw: Interrupts with logical rings
      drm/i915/bdw: GEN-specific logical ring emit batchbuffer start
      drm/i915/bdw: Workload submission mechanism for Execlists
      drm/i915/bdw: Always use MMIO flips with Execlists
      drm/i915: Add temporary ring->ctx backpointer
      drm/i915/bdw: Emission of requests with logical rings
      drm/i915/bdw: Write the tail pointer, LRC style
      drm/i915/bdw: Avoid non-lite-restore preemptions
      drm/i915/bdw: Help out the ctx switch interrupt handler
      drm/i915/bdw: Don't write PDP in the legacy way when using LRCs
      drm/i915/bdw: Make sure gpu reset still works with Execlists
      drm/i915/bdw: Disable semaphores for Execlists
      drm/i915/bdw: Display execlists info in debugfs
      drm/i915/bdw: Display context backing obj & ringbuffer info in debugfs
      drm/i915/bdw: Document Logical Rings, LR contexts and Execlists
      drm/i915/bdw: Enable Logical Ring Contexts (hence, Execlists)
      drm/i915/bdw: Make sure error capture keeps working with Execlists
      drm/i915/bdw: Render state init for Execlists

Paulo Zanoni (8):
      d rm/i915: freeze display before the interrupts and GT
      drm/i915: remove duplicate register defines
      drm/i915: fix i915_interrupt_info on BDW
      drm/i915: fix i915_frequency_info on BDW
      drm/i915: call lpt_init_clock_gating on BDW too
      drm/i915: rename gen8_init_clock_gating to broadwell_init_clock_gating
      drm/i915: send PCI_D3hot adapter opregion message on BDW RPM suspend
      drm/i915: change CHV write_eld/global_resources function pointers

Pierre Moreau (2):
      drm/nouveau: Display Nouveau boot options at launch
      drm/nouveau: Fix duplicate definition of NV04_PFB_BOOT_0_*

Rafael Barbalho (1):
      drm/i915: Fix read back of plane stride register

Randy Dunlap (1):
      drm: fix drm_modeset_lock.h kernel-doc notation

Rob Clark (9):
      drm: idiot-proof vblank
      drm/msm: update generated headers
      drm/msm/mdp4: fix blend setup with multiple crtcs
      drm/msm/mdp4: add LVDS panel support
      drm/panel/simple: add optronics B101XTN01.0 (v3)
      drm/msm/adreno: split adreno device out into it's own file
      drm/msm/adreno: move decision about what gpu to to load
      drm/msm/adreno: bit of init refactoring
      drm/msm/adreno: push dump/show stuff to base class

Rodrigo Vivi (3):
      drm/i915: Introduce FBC False Color for debug purposes.
      drm/i915: FBC flush nuke for BDW
      drm/i915: Use EIO instead of EAGAIN for sink CRC error.

Roy Spliet (18):
      drm/nva3/clk: Parse clock control registers more accurately
      drm/nva3/clk: Set PLL refclk
      drm/nva3/clk: HOST clock
      drm/nva3/clk: Abort when PLL doesn't lock
      drm/nva3/clk: For PLL clocks always make sure the PLL is not in use
      drm/nva3/clk: Set intermediate core clock on reclocking
      drm/nva3/pwr/memx: Implement "wait for VBLANK"
      drm/nouveau/pwr/memx: Make FB disable and enable explicit
      drm/nouveau/pwr/memx: Return debugging information
      drm/nva3/pwr/memx: Match blob's fb access behaviour
      drm/nouveau/fb/sddr3: Expand MR generation
      drm/nouveau/fb/sddr2: Generate MR values
      drm/nva3/clk: Pause the GPU before reclocking
      drm/nouveau/bios: Add rammap support for version 1.0
      drm/nv50/kms: Set VBLANK time in modeset script
      drm/nv50/fb/ram: Store the number of partitions in the designated fields
      drm/nouveau/fb/ram: Support strided regs
      drm/nva3/fb/ram: Per-partition regs

Sagar Kamble (2):
      drm/i915: Created common handler for platform specific suspend/resume
      drm/i915: Sharing platform specific sequence between runtime and system suspend/ resume paths

Shobhit Kumar (1):
      drm/i915: Add support for Video Burst Mode for MIPI DSI

Sonika Jindal (13):
      drm: Add rotation_property to mode_config
      drm: Resetting rotation property
      drm/i915: Continuation of future readiness series
      drm/i915: Updating plane parameters for primary plane in setplane
      drm/i915: Add 180 degree primary plane rotation support
      drm/i915: Rename defines for selection of ddi buffer translation slot
      drm: Renaming DP training vswing pre emph defines
      drm/exynos: Renaming DP training vswing pre emph defines
      drm/gma500: Renaming DP training vswing pre emph defines
      drm/radeon: Renaming DP training vswing pre emph defines
      drm/tegra: Renaming DP training vswing pre emph defines
      drm/i915: Renaming DP training vswing pre emph defines
      drm: Remove old defines for vswing and pre-emph values

Steve Longerbeam (24):
      gpu: ipu-v3: Add functions to set CSI/IC source muxes
      gpu: ipu-v3: Rename and add IDMAC channels
      gpu: ipu-v3: Add Camera Sensor Interface unit
      gpu: ipu-v3: Add Image Converter unit
      gpu: ipu-v3: smfc: Move enable/disable to ipu-smfc.c
      gpu: ipu-v3: smfc: Convert to per-channel
      gpu: ipu-v3: smfc: Add ipu_smfc_set_watermark()
      gpu: ipu-v3: Add ipu_mbus_code_to_colorspace()
      gpu: ipu-v3: Add rotation mode conversion utilities
      gpu: ipu-v3: Add helper function checking if pixfmt is planar
      gpu: ipu-v3: Move IDMAC channel names to imx-ipu-v3.h
      gpu: ipu-v3: Add ipu_idmac_buffer_is_ready()
      gpu: ipu-v3: Add ipu_idmac_clear_buffer()
      gpu: ipu-v3: Add __ipu_idmac_reset_current_buffer()
      gpu: ipu-v3: Add ipu_stride_to_bytes()
      gpu: ipu-v3: Add ipu_idmac_enable_watermark()
      gpu: ipu-v3: Add ipu_idmac_lock_enable()
      gpu: ipu-cpmem: Add ipu_cpmem_set_block_mode()
      gpu: ipu-cpmem: Add ipu_cpmem_set_axi_id()
      gpu: ipu-cpmem: Add ipu_cpmem_set_rotation()
      gpu: ipu-cpmem: Add second buffer support to ipu_cpmem_set_image()
      gpu: ipu-v3: Add more planar formats support
      gpu: ipu-cpmem: Add ipu_cpmem_dump()
      gpu: ipu-v3: Add ipu_dump()

Thomas Daniel (4):
      drm/i915/bdw: Handle context switch events
      drm/i915/bdw: Populate lrc with aliasing ppgtt if required
      drm/i915/bdw: Do not initialize PPGTT in the legacy way for execlists
      drm/i915/bdw: Don't execute context reset and switch with Execlists

Thomas Wood (1):
      drm: fix plane rotation when restoring fbdev configuration

Tvrtko Ursulin (1):
      drm/i915: Do not leak pages when freeing userptr objects

Vandana Kannan (2):
      drm/i915: Set M2_N2 registers during mode set
      drm/i915: State readout and cross-checking for dp_m2_n2

Vedang Patel (1):
      drm/i915/bdw: Add BDW support in the i915 debugfs entry

Ville Syrjälä (94):
      drm: Warn when leaking flip events on close
      drm: Always reject drm_vblank_get() after drm_vblank_off()
      drm/i915: Warn if drm_vblank_get() still works after drm_vblank_off()
      drm: Don't clear vblank timestamps when vblank interrupt is disabled
      drm: Move drm_update_vblank_count()
      drm: Have the vblank counter account for the time between vblank irq disable and drm_vblank_off()
      drm: Avoid random vblank counter jumps if the hardware counter has been reset
      drm: Reduce the amount of dev->vblank[crtc] in the code
      drm: Fix deadlock between event_lock and vbl_lock/vblank_time_lock
      drm: Fix race between drm_vblank_off() and drm_queue_vblank_event()
      drm: Disable vblank interrupt immediately when drm_vblank_offdelay<0
      drm: Add dev->vblank_disable_immediate flag
      drm/i915: Opt out of vblank disable timer on >gen2
      drm: Kick start vblank interrupts at drm_vblank_on()
      drm/i915: Update scanline_offset only for active crtcs
      drm: Fix confusing debug message in drm_update_vblank_count()
      drm: Store the vblank timestamp when adjusting the counter during disable
      drm: Add drm_crtc_vblank_waitqueue()
      drm/i915: Kill intel_crtc->vbl_wait
      drm/i915: Add chv_power_wells[]
      drm/i915: Add chv cmnlane power wells
      drm/i915: Kill intel_reset_dpio()
      drm/i915: Add disp2d power well for chv
      drm/i915: Add per-pipe power wells for chv
      drm/i915: Add chv port B and C TX wells
      drm/i915: Add chv port D TX wells
      drm/i915: Split a few long debug prints
      drm/i915: Add DP training pattern 3 for CHV
      drm/i915: Add cdclk change support for chv
      drm/i915: Disable cdclk changes for chv until Punit is ready
      drm/i915: Leave DPLL ref clocks on
      drm/i915: Split chv_update_pll() apart
      drm/i915: Call intel_{dp, hdmi}_prepare for chv
      drm/i915: Clarify CHV swing margin/deemph bits
      drm/i915: Add 180 degree sprite rotation support
      drm/i915: Make intel_plane_restore() return an error
      drm/i915: Add rotation property for sprites
      drm/i915: Fill out the FWx watermark register defines
      drm/i915: Parametrize VLV_DDL registers
      drm/i915: Add cherryview_update_wm()
      drm/i915: Hack to tie both common lanes together on chv
      drm/i915: Polish the chv cmnlane resrt macros
      drm/i915: Free pending page flip events at .preclose()
      drm/i915: Eliminate rmw from .update_primary_plane()
      drm/i915: Call .update_primary_plane in intel_{enable, disable}_primary_hw_plane()
      drm/i915: Make hpd debug messages less cryptic
      drm/i915: Don't try to enable cursor from setplane when crtc is disabled
      drm/i915: Move CURSIZE setup to i845_update_cursor()
      drm/i915: Unify ivb_update_cursor() and i9xx_update_cursor()
      drm/i915: Add support for variable cursor size on 845/865
      drm/i915: Parametrize PANEL_PORT_SELECT_VLV
      drm/i915: Use intel_edp_panel_vdd_on() in intel_dp_probe_mst()
      drm/i915: Rename edp vdd funcs for consistency
      drm/i915: Add a note explaining vdd on/off handling in intel_dp_aux_ch()
      drm/i915: Replace big nested if block with early return
      drm/i915: Warn about want_panel_vdd in edp_panel_vdd_off_sync()
      drm/i915: Flatten intel_edp_panel_vdd_on()
      drm/i915: Don't dereference fb when disabling primary plane
      drm/i915: s, fb->bits_per_pixel/8, pixel_size, in primary plane code
      drm/i915: Populate mem_freq in init_gt_powerwave()
      drm/i915: Warn about odd rps values on CHV
      drm/i915: Init some CHV workarounds via LRIs in ring->init_context()
      drm/i915: Fix gen2 planes B and C max watermark value
      drm/i915: Disable trickle feed for gen2/3
      drm/i915: Idle unused rings on gen2/3 during init/resume
      drm/i915: Pass intel_crtc to intel_disable_pipe() and intel_wait_for_pipe_off()
      drm/i915: Disable double wide even when leaving the pipe on
      drm/i915: ns2501 is on DVOB
      drm/i915: Enable DVO between mode_set and dpms hooks
      drm/i915: Don't call DVO mode_set hook on DPMS changes
      drm/i915: Kill useless ns2501_dump_regs
      drm/i915: Rewrite ns2501 driver a bit
      drm/i915: Init important ns2501 registers
      drm/i915: Check pixel clock in ns2501 mode_valid hook
      Revert "drm/i915: Nuke pipe A quirk on i830M"
      drm/i915: Add pipe B force quirk for 830M
      drm/i915: Preserve VGACNTR bits from the BIOS
      drm/i915: Don't use WaGsvRC0ResidenncyMethod on chv
      drm/i915: Don't call intel_plane_restore() when the prop value didn't change
      drm/i915: Don't call gen8_fbc_sw_flush() on chv
      drm/i915: Use IS_BROADWELL() instead of IS_GEN8() in forcewake code
      drm/i915: Use HAS_GMCH_DISPLAY un underrun reporting code
      drm/i915: Check of !HAS_PCH_SPLIT() in PCH transcoder funcs
      drm/i915: Fix edp vdd locking
      drm/i915: Track which port is using which pipe's power sequencer
      drm/i915: Reset power sequencer pipe tracking when disp2d is off
      drm/i915: Be more careful when picking the initial power sequencer pipe
      drm/i915: Turn on panel power before doing aux transfers
      drm/i915: Enable DP port earlier
      drm/i915: Move DP port disable to post_disable for pch platforms
      drm/i915: Add comments explaining the vdd on/off functions
      drm/i915: Fix DVO 2x clock enable on 830M
      drm/i915: Limit the watermark to at least 8 entries on gen2/3
      drm/i915: Don't spam dmesg with rps messages on vlv/chv

Y.C. Chen (1):
      drm/ast: Add reduced blanking modes for wide screen mode

YoungJun Cho (1):
      drm/exynos: dsi: fix exynos_dsi_set_pll() wrong return value

 Documentation/DocBook/drm.tmpl                     |   16 +-
 .../devicetree/bindings/drm/tilcdc/panel.txt       |    7 +
 .../devicetree/bindings/panel/auo,b101xtn01.txt    |    7 +
 .../devicetree/bindings/vendor-prefixes.txt        |    2 +
 .../devicetree/bindings/video/adi,adv7123.txt      |   50 +
 .../devicetree/bindings/video/exynos_dsim.txt      |    1 +
 .../devicetree/bindings/video/renesas,du.txt       |   84 +
 .../devicetree/bindings/video/samsung-fimd.txt     |    1 +
 .../devicetree/bindings/video/thine,thc63lvdm83d   |   50 +
 .../devicetree/bindings/video/vga-connector.txt    |   36 +
 MAINTAINERS                                        |    2 +-
 arch/arm/boot/dts/exynos3250.dtsi                  |   33 +
 arch/arm/mach-shmobile/board-koelsch-reference.c   |   19 +-
 arch/arm/mach-shmobile/board-koelsch.c             |   19 +-
 arch/arm/mach-shmobile/board-lager-reference.c     |   19 +-
 arch/arm/mach-shmobile/board-lager.c               |   19 +-
 arch/arm/mach-shmobile/board-marzen.c              |   19 +-
 drivers/gpu/drm/Kconfig                            |    8 +-
 drivers/gpu/drm/Makefile                           |    5 +-
 drivers/gpu/drm/armada/armada_drv.c                |    1 +
 drivers/gpu/drm/armada/armada_gem.h                |    2 +
 drivers/gpu/drm/ast/ast_dp501.c                    |   38 +-
 drivers/gpu/drm/ast/ast_drv.c                      |    1 +
 drivers/gpu/drm/ast/ast_drv.h                      |   12 +-
 drivers/gpu/drm/ast/ast_fb.c                       |    3 +-
 drivers/gpu/drm/ast/ast_main.c                     |   79 +-
 drivers/gpu/drm/ast/ast_mode.c                     |   46 +-
 drivers/gpu/drm/ast/ast_post.c                     |   23 +-
 drivers/gpu/drm/ast/ast_tables.h                   |   38 +-
 drivers/gpu/drm/ast/ast_ttm.c                      |   24 +-
 drivers/gpu/drm/ati_pcigart.c                      |    2 +
 drivers/gpu/drm/bochs/bochs.h                      |    4 +-
 drivers/gpu/drm/bochs/bochs_drv.c                  |    1 +
 drivers/gpu/drm/bochs/bochs_mm.c                   |   24 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c                |    1 +
 drivers/gpu/drm/cirrus/cirrus_drv.h                |    4 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c              |    3 +-
 drivers/gpu/drm/cirrus/cirrus_ttm.c                |   21 +-
 drivers/gpu/drm/drm_agpsupport.c                   |    1 +
 drivers/gpu/drm/drm_auth.c                         |    7 +
 drivers/gpu/drm/drm_bufs.c                         |   94 +-
 drivers/gpu/drm/drm_crtc.c                         |  394 +++--
 drivers/gpu/drm/drm_debugfs.c                      |    3 +-
 drivers/gpu/drm/drm_dma.c                          |   11 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   80 +-
 drivers/gpu/drm/drm_drv.c                          |   40 +-
 drivers/gpu/drm/drm_edid.c                         |  123 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   85 +-
 drivers/gpu/drm/drm_fops.c                         |   30 +-
 drivers/gpu/drm/drm_gem.c                          |   12 +-
 drivers/gpu/drm/drm_gem_cma_helper.c               |    7 +-
 drivers/gpu/drm/drm_info.c                         |   89 +-
 drivers/gpu/drm/drm_internal.h                     |  132 ++
 drivers/gpu/drm/drm_ioctl.c                        |  254 +--
 drivers/gpu/drm/drm_irq.c                          |  463 +++--
 drivers/gpu/drm/drm_legacy.h                       |   62 +
 drivers/gpu/drm/drm_lock.c                         |   36 +-
 drivers/gpu/drm/drm_memory.c                       |   24 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |    6 +
 drivers/gpu/drm/drm_modes.c                        |    1 +
 drivers/gpu/drm/drm_modeset_lock.c                 |  213 ++-
 drivers/gpu/drm/drm_pci.c                          |   46 +-
 drivers/gpu/drm/drm_platform.c                     |   38 +-
 drivers/gpu/drm/drm_prime.c                        |    5 +-
 drivers/gpu/drm/drm_probe_helper.c                 |   17 +
 drivers/gpu/drm/drm_scatter.c                      |    9 +-
 drivers/gpu/drm/drm_sysfs.c                        |    1 +
 drivers/gpu/drm/drm_usb.c                          |   88 -
 drivers/gpu/drm/drm_vm.c                           |   89 +-
 drivers/gpu/drm/exynos/exynos_dp_core.c            |    8 +-
 drivers/gpu/drm/exynos/exynos_drm_crtc.c           |   62 +-
 drivers/gpu/drm/exynos/exynos_drm_dpi.c            |    6 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |  104 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |    1 -
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            |   40 +-
 drivers/gpu/drm/exynos/exynos_drm_fb.c             |    1 +
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |   90 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |   55 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |  106 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.h            |   16 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |    3 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c            |  453 ++---
 drivers/gpu/drm/exynos/exynos_drm_ipp.h            |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_plane.c          |   19 +-
 drivers/gpu/drm/exynos/exynos_drm_plane.h          |    3 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |    3 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   19 -
 drivers/gpu/drm/exynos/exynos_hdmi.c               |    4 +-
 drivers/gpu/drm/exynos/exynos_mixer.c              |    3 -
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |    4 +-
 drivers/gpu/drm/gma500/framebuffer.c               |    3 +-
 drivers/gpu/drm/gma500/gtt.h                       |    1 +
 drivers/gpu/drm/gma500/intel_bios.c                |   16 +-
 drivers/gpu/drm/gma500/psb_drv.c                   |    1 +
 drivers/gpu/drm/i810/i810_dma.c                    |   16 +-
 drivers/gpu/drm/i810/i810_drv.c                    |    3 +-
 drivers/gpu/drm/i810/i810_drv.h                    |    2 +
 drivers/gpu/drm/i915/Makefile                      |    1 +
 drivers/gpu/drm/i915/dvo_ns2501.c                  |  560 ++++---
 drivers/gpu/drm/i915/i915_cmd_parser.c             |    4 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |  370 +++-
 drivers/gpu/drm/i915/i915_dma.c                    |   31 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  194 ++-
 drivers/gpu/drm/i915/i915_drv.h                    |  222 ++-
 drivers/gpu/drm/i915/i915_gem.c                    |  370 ++--
 drivers/gpu/drm/i915/i915_gem_context.c            |  216 +--
 drivers/gpu/drm/i915/i915_gem_evict.c              |    4 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  227 +--
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  291 ++--
 drivers/gpu/drm/i915/i915_gem_gtt.h                |   32 +-
 drivers/gpu/drm/i915/i915_gem_render_state.c       |   40 +-
 drivers/gpu/drm/i915/i915_gem_render_state.h       |   47 +
 drivers/gpu/drm/i915/i915_gem_stolen.c             |   13 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c             |   11 +-
 drivers/gpu/drm/i915/i915_gem_userptr.c            |   31 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |  196 ++-
 drivers/gpu/drm/i915/i915_irq.c                    |  241 ++-
 drivers/gpu/drm/i915/i915_params.c                 |    6 +
 drivers/gpu/drm/i915/i915_reg.h                    |  283 +++-
 drivers/gpu/drm/i915/i915_sysfs.c                  |    2 +-
 drivers/gpu/drm/i915/intel_bios.c                  |   29 +-
 drivers/gpu/drm/i915/intel_bios.h                  |    3 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |  344 ++--
 drivers/gpu/drm/i915/intel_display.c               | 1312 ++++++++++-----
 drivers/gpu/drm/i915/intel_dp.c                    | 1257 +++++++++-----
 drivers/gpu/drm/i915/intel_drv.h                   |   38 +-
 drivers/gpu/drm/i915/intel_dsi.c                   |   40 +-
 drivers/gpu/drm/i915/intel_dsi.h                   |    2 +
 drivers/gpu/drm/i915/intel_dsi_cmd.c               |    2 +-
 drivers/gpu/drm/i915/intel_dsi_panel_vbt.c         |   38 +-
 drivers/gpu/drm/i915/intel_dsi_pll.c               |   17 +-
 drivers/gpu/drm/i915/intel_dvo.c                   |   11 +-
 drivers/gpu/drm/i915/intel_fbdev.c                 |   83 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |  168 +-
 drivers/gpu/drm/i915/intel_lrc.c                   | 1766 ++++++++++++++++++++
 drivers/gpu/drm/i915/intel_lrc.h                   |  114 ++
 drivers/gpu/drm/i915/intel_lvds.c                  |    3 +-
 drivers/gpu/drm/i915/intel_panel.c                 |   29 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  818 ++++++---
 drivers/gpu/drm/i915/intel_renderstate.h           |    8 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  256 ++-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   46 +-
 drivers/gpu/drm/i915/intel_sprite.c                |  109 +-
 drivers/gpu/drm/i915/intel_uncore.c                |    6 +-
 drivers/gpu/drm/mga/mga_dma.c                      |   77 +-
 drivers/gpu/drm/mga/mga_drv.c                      |    3 +-
 drivers/gpu/drm/mga/mga_drv.h                      |    2 +
 drivers/gpu/drm/mgag200/mgag200_drv.c              |    1 +
 drivers/gpu/drm/mgag200/mgag200_drv.h              |    6 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c               |    3 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   21 +-
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |   24 +-
 drivers/gpu/drm/msm/Kconfig                        |    1 +
 drivers/gpu/drm/msm/Makefile                       |    4 +
 drivers/gpu/drm/msm/adreno/a2xx.xml.h              |    6 +-
 drivers/gpu/drm/msm/adreno/a3xx.xml.h              |   12 +-
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |  214 +--
 drivers/gpu/drm/msm/adreno/adreno_common.xml.h     |    6 +-
 drivers/gpu/drm/msm/adreno/adreno_device.c         |  285 ++++
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |  151 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.h            |   17 +-
 drivers/gpu/drm/msm/adreno/adreno_pm4.xml.h        |   10 +-
 drivers/gpu/drm/msm/dsi/dsi.xml.h                  |   10 +-
 drivers/gpu/drm/msm/dsi/mmss_cc.xml.h              |   18 +-
 drivers/gpu/drm/msm/dsi/sfpb.xml.h                 |   10 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |    4 +-
 drivers/gpu/drm/msm/hdmi/hdmi.xml.h                |   10 +-
 drivers/gpu/drm/msm/hdmi/qfprom.xml.h              |   10 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4.xml.h            |  107 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c           |   21 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_dtv_encoder.c    |    2 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c            |   89 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.h            |   63 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_lcdc_encoder.c   |  506 ++++++
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c |  151 ++
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_pll.c       |  172 ++
 drivers/gpu/drm/msm/msm_drv.c                      |   38 +-
 drivers/gpu/drm/msm/msm_drv.h                      |    3 +-
 drivers/gpu/drm/msm/msm_gem_prime.c                |    5 +-
 drivers/gpu/drm/msm/msm_gpu.h                      |    6 +-
 drivers/gpu/drm/nouveau/Makefile                   |   12 +-
 drivers/gpu/drm/nouveau/core/core/client.c         |    7 +-
 drivers/gpu/drm/nouveau/core/core/event.c          |    2 +-
 drivers/gpu/drm/nouveau/core/core/gpuobj.c         |    2 +-
 drivers/gpu/drm/nouveau/core/core/ioctl.c          |    3 +-
 drivers/gpu/drm/nouveau/core/core/mm.c             |   97 +-
 drivers/gpu/drm/nouveau/core/core/notify.c         |    7 +-
 drivers/gpu/drm/nouveau/core/engine/device/base.c  |    3 +-
 drivers/gpu/drm/nouveau/core/engine/device/gm100.c |    9 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv50.c  |   37 +-
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |   24 +-
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |    8 +
 drivers/gpu/drm/nouveau/core/engine/disp/base.c    |    6 +-
 drivers/gpu/drm/nouveau/core/engine/disp/conn.c    |    4 +-
 drivers/gpu/drm/nouveau/core/engine/disp/gm107.c   |    6 +-
 drivers/gpu/drm/nouveau/core/engine/disp/hdanva3.c |   15 +-
 drivers/gpu/drm/nouveau/core/engine/disp/hdanvd0.c |   20 +-
 .../gpu/drm/nouveau/core/engine/disp/hdminvd0.c    |    3 -
 .../gpu/drm/nouveau/core/engine/disp/hdminve0.c    |   83 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |  129 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.h    |   10 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv84.c    |    4 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv94.c    |    4 +
 drivers/gpu/drm/nouveau/core/engine/disp/nva0.c    |    4 +
 drivers/gpu/drm/nouveau/core/engine/disp/nva3.c    |    4 +
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c    |   80 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nve0.c    |    6 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nvf0.c    |    6 +-
 drivers/gpu/drm/nouveau/core/engine/disp/outpdp.c  |    4 +-
 drivers/gpu/drm/nouveau/core/engine/disp/priv.h    |    3 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/base.c    |    6 +-
 .../gpu/drm/nouveau/core/engine/software/nv50.c    |    3 +-
 drivers/gpu/drm/nouveau/core/include/core/client.h |    2 +-
 drivers/gpu/drm/nouveau/core/include/core/device.h |    1 +
 drivers/gpu/drm/nouveau/core/include/core/event.h  |    3 +-
 drivers/gpu/drm/nouveau/core/include/core/mm.h     |   12 +-
 drivers/gpu/drm/nouveau/core/include/core/notify.h |    5 +-
 drivers/gpu/drm/nouveau/core/include/engine/fifo.h |    3 +-
 drivers/gpu/drm/nouveau/core/include/subdev/bar.h  |    1 -
 .../drm/nouveau/core/include/subdev/bios/M0205.h   |   32 +
 .../drm/nouveau/core/include/subdev/bios/M0209.h   |   30 +
 .../gpu/drm/nouveau/core/include/subdev/bios/fan.h |    8 +
 .../drm/nouveau/core/include/subdev/bios/ramcfg.h  |  160 +-
 .../drm/nouveau/core/include/subdev/bios/rammap.h  |    5 +-
 .../drm/nouveau/core/include/subdev/bios/therm.h   |   10 +-
 .../gpu/drm/nouveau/core/include/subdev/clock.h    |    1 +
 drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |    7 +-
 .../drm/nouveau/core/include/subdev/fb/regsnv04.h  |   21 +
 drivers/gpu/drm/nouveau/core/include/subdev/fuse.h |   30 +
 drivers/gpu/drm/nouveau/core/include/subdev/gpio.h |    2 +-
 drivers/gpu/drm/nouveau/core/include/subdev/pwr.h  |    3 +
 .../gpu/drm/nouveau/core/include/subdev/therm.h    |    1 +
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |   38 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/M0205.c   |  136 ++
 drivers/gpu/drm/nouveau/core/subdev/bios/M0209.c   |  137 ++
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c     |    1 +
 drivers/gpu/drm/nouveau/core/subdev/bios/fan.c     |   93 ++
 drivers/gpu/drm/nouveau/core/subdev/bios/rammap.c  |   74 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/timing.c  |    8 +
 drivers/gpu/drm/nouveau/core/subdev/clock/base.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c   |  303 +++-
 drivers/gpu/drm/nouveau/core/subdev/clock/nva3.h   |   10 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c   |   37 +-
 .../gpu/drm/nouveau/core/subdev/devinit/fbmem.h    |   18 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/gddr5.c     |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv20.c      |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv25.c      |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv30.c      |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv35.c      |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv36.c      |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv40.c      |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |    1 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramfuc.h    |   82 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv04.c   |   17 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv50.c   |   24 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c   |   96 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c   |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnve0.c   |  490 ++++--
 drivers/gpu/drm/nouveau/core/subdev/fb/sddr2.c     |   94 ++
 drivers/gpu/drm/nouveau/core/subdev/fb/sddr3.c     |   47 +-
 drivers/gpu/drm/nouveau/core/subdev/fuse/base.c    |   54 +
 drivers/gpu/drm/nouveau/core/subdev/fuse/g80.c     |   81 +
 drivers/gpu/drm/nouveau/core/subdev/fuse/gf100.c   |   83 +
 drivers/gpu/drm/nouveau/core/subdev/fuse/gm107.c   |   66 +
 drivers/gpu/drm/nouveau/core/subdev/fuse/priv.h    |    9 +
 drivers/gpu/drm/nouveau/core/subdev/gpio/base.c    |    3 +-
 .../nouveau/core/subdev/gpio/{nv92.c => nv94.c}    |   12 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c    |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/priv.h    |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c     |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv04.c |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/ltc/base.c     |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/ltc/gf100.c    |   39 +-
 drivers/gpu/drm/nouveau/core/subdev/ltc/gm107.c    |    5 -
 drivers/gpu/drm/nouveau/core/subdev/ltc/priv.h     |    2 +
 drivers/gpu/drm/nouveau/core/subdev/pwr/base.c     |    2 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/arith.fuc  |   94 ++
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/kernel.fuc |  122 +-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/macros.fuc |   20 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/memx.fuc   |  133 +-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nv108.fuc  |    4 +
 .../drm/nouveau/core/subdev/pwr/fuc/nv108.fuc.h    |  903 ++++++----
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nva3.fuc   |    4 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nva3.fuc.h | 1270 +++++++-------
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvc0.fuc   |    4 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvc0.fuc.h | 1300 +++++++-------
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvd0.fuc   |    4 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvd0.fuc.h |  869 ++++++----
 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/os.h   |   11 +-
 drivers/gpu/drm/nouveau/core/subdev/pwr/memx.c     |   58 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c    |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/fanpwm.c |    8 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/gm107.c  |   93 ++
 drivers/gpu/drm/nouveau/core/subdev/therm/nv84.c   |   38 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nva3.c   |    2 +
 drivers/gpu/drm/nouveau/core/subdev/therm/nvd0.c   |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/priv.h   |    3 +
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c      |    2 +-
 drivers/gpu/drm/nouveau/dispnv04/crtc.c            |    2 +-
 drivers/gpu/drm/nouveau/dispnv04/overlay.c         |   15 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  120 +-
 drivers/gpu/drm/nouveau/nouveau_bo.h               |    9 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |    4 +-
 drivers/gpu/drm/nouveau/nouveau_chan.h             |    2 +
 drivers/gpu/drm/nouveau/nouveau_connector.c        |    6 +-
 drivers/gpu/drm/nouveau/nouveau_connector.h        |    4 +
 drivers/gpu/drm/nouveau/nouveau_display.c          |   29 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   39 +-
 drivers/gpu/drm/nouveau/nouveau_drm.h              |    4 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |    5 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.h            |    3 +
 drivers/gpu/drm/nouveau/nouveau_fence.c            |  551 ++++--
 drivers/gpu/drm/nouveau/nouveau_fence.h            |   29 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |  180 +-
 drivers/gpu/drm/nouveau/nouveau_gem.h              |    2 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   10 +-
 drivers/gpu/drm/nouveau/nouveau_sysfs.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_sysfs.h            |    2 +
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |   11 +-
 drivers/gpu/drm/nouveau/nv04_fence.c               |    8 +-
 drivers/gpu/drm/nouveau/nv10_fence.c               |    8 +-
 drivers/gpu/drm/nouveau/nv17_fence.c               |    6 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |   46 +-
 drivers/gpu/drm/nouveau/nv50_fence.c               |    6 +-
 drivers/gpu/drm/nouveau/nv84_fence.c               |   31 +-
 drivers/gpu/drm/nouveau/nvif/class.h               |    9 +
 drivers/gpu/drm/omapdrm/omap_drv.c                 |    1 +
 drivers/gpu/drm/omapdrm/omap_drv.h                 |    1 +
 drivers/gpu/drm/panel/panel-simple.c               |   27 +
 drivers/gpu/drm/qxl/Makefile                       |    2 +-
 drivers/gpu/drm/qxl/qxl_cmd.c                      |    7 -
 drivers/gpu/drm/qxl/qxl_debugfs.c                  |   14 +-
 drivers/gpu/drm/qxl/qxl_display.c                  |   49 +
 drivers/gpu/drm/qxl/qxl_drv.c                      |   33 +-
 drivers/gpu/drm/qxl/qxl_drv.h                      |   36 +-
 drivers/gpu/drm/qxl/qxl_fb.c                       |    3 +-
 drivers/gpu/drm/qxl/qxl_fence.c                    |   91 -
 drivers/gpu/drm/qxl/qxl_kms.c                      |   17 +-
 drivers/gpu/drm/qxl/qxl_object.c                   |   21 +-
 drivers/gpu/drm/qxl/qxl_object.h                   |    6 +-
 drivers/gpu/drm/qxl/qxl_prime.c                    |   72 +
 drivers/gpu/drm/qxl/qxl_release.c                  |  174 +-
 drivers/gpu/drm/qxl/qxl_ttm.c                      |  103 +-
 drivers/gpu/drm/r128/r128_cce.c                    |   24 +-
 drivers/gpu/drm/r128/r128_drv.c                    |    3 +-
 drivers/gpu/drm/r128/r128_drv.h                    |    3 +
 drivers/gpu/drm/radeon/Makefile                    |    6 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |    4 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   23 -
 drivers/gpu/drm/radeon/btc_dpm.c                   |   51 -
 drivers/gpu/drm/radeon/btc_dpm.h                   |    2 -
 drivers/gpu/drm/radeon/ci_dpm.c                    |   30 +-
 drivers/gpu/drm/radeon/cik.c                       |   52 +-
 drivers/gpu/drm/radeon/cik_sdma.c                  |   25 +-
 drivers/gpu/drm/radeon/dce3_1_afmt.c               |    4 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                 |    6 +-
 drivers/gpu/drm/{ => radeon}/drm_buffer.c          |    6 +-
 .../drm => drivers/gpu/drm/radeon}/drm_buffer.h    |    0
 drivers/gpu/drm/radeon/evergreen.c                 |    7 +-
 drivers/gpu/drm/radeon/evergreen_dma.c             |   24 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |   49 +-
 drivers/gpu/drm/radeon/kv_dpm.c                    |    2 +
 drivers/gpu/drm/radeon/ni_dpm.c                    |   24 -
 drivers/gpu/drm/radeon/r100.c                      |   21 +-
 drivers/gpu/drm/radeon/r200.c                      |   21 +-
 drivers/gpu/drm/radeon/r300_cmdbuf.c               |    2 +-
 drivers/gpu/drm/radeon/r600.c                      |  159 +-
 drivers/gpu/drm/radeon/r600_audio.c                |  207 ---
 drivers/gpu/drm/radeon/r600_cp.c                   |   26 +-
 drivers/gpu/drm/radeon/r600_dma.c                  |   25 +-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |  172 +-
 drivers/gpu/drm/radeon/r600d.h                     |   58 +-
 drivers/gpu/drm/radeon/radeon.h                    |  125 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |   25 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   78 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |    6 +-
 drivers/gpu/drm/radeon/radeon_benchmark.c          |   34 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |    2 +-
 drivers/gpu/drm/radeon/radeon_cp.c                 |   46 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   77 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   63 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   35 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   13 +-
 drivers/gpu/drm/radeon/radeon_drv.h                |    2 +
 drivers/gpu/drm/radeon/radeon_encoders.c           |   21 +
 drivers/gpu/drm/radeon/radeon_fb.c                 |    3 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |  479 ++++--
 drivers/gpu/drm/radeon/radeon_gart.c               |    2 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |  121 +-
 drivers/gpu/drm/radeon/radeon_ib.c                 |    3 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |   33 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |    1 +
 drivers/gpu/drm/radeon/radeon_mn.c                 |  274 +++
 drivers/gpu/drm/radeon/radeon_mode.h               |    1 +
 drivers/gpu/drm/radeon/radeon_object.c             |  104 +-
 drivers/gpu/drm/radeon/radeon_object.h             |    1 +
 drivers/gpu/drm/radeon/radeon_pm.c                 |    2 +-
 drivers/gpu/drm/radeon/radeon_prime.c              |   20 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |   23 +-
 drivers/gpu/drm/radeon/radeon_sa.c                 |    2 +-
 drivers/gpu/drm/radeon/radeon_semaphore.c          |   53 +-
 drivers/gpu/drm/radeon/radeon_state.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_test.c               |   29 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |  237 ++-
 drivers/gpu/drm/radeon/radeon_uvd.c                |  159 +-
 drivers/gpu/drm/radeon/radeon_vce.c                |    3 +-
 drivers/gpu/drm/radeon/radeon_vm.c                 |   24 +-
 drivers/gpu/drm/radeon/rv770.c                     |    1 -
 drivers/gpu/drm/radeon/rv770_dma.c                 |   25 +-
 drivers/gpu/drm/radeon/si.c                        |    8 +-
 drivers/gpu/drm/radeon/si_dma.c                    |   25 +-
 drivers/gpu/drm/radeon/si_dpm.c                    |   24 -
 drivers/gpu/drm/radeon/sid.h                       |    2 +-
 drivers/gpu/drm/radeon/uvd_v1_0.c                  |  107 +-
 drivers/gpu/drm/radeon/uvd_v2_2.c                  |    4 +
 drivers/gpu/drm/rcar-du/Kconfig                    |    1 +
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |    2 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h             |    2 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.c              |  173 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.h              |    4 +-
 drivers/gpu/drm/rcar-du/rcar_du_encoder.c          |   13 +-
 drivers/gpu/drm/rcar-du/rcar_du_encoder.h          |    5 +-
 drivers/gpu/drm/rcar-du/rcar_du_group.c            |    2 +-
 drivers/gpu/drm/rcar-du/rcar_du_group.h            |    2 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.c              |  233 ++-
 drivers/gpu/drm/rcar-du/rcar_du_kms.h              |    2 +-
 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c          |   45 +-
 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.h          |    5 +-
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c          |    2 +-
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.h          |    2 +-
 drivers/gpu/drm/rcar-du/rcar_du_plane.c            |    2 +-
 drivers/gpu/drm/rcar-du/rcar_du_plane.h            |    2 +-
 drivers/gpu/drm/rcar-du/rcar_du_vgacon.c           |    2 +-
 drivers/gpu/drm/rcar-du/rcar_du_vgacon.h           |    2 +-
 drivers/gpu/drm/savage/savage_bci.c                |   39 +-
 drivers/gpu/drm/savage/savage_drv.c                |    3 +-
 drivers/gpu/drm/savage/savage_drv.h                |    2 +
 drivers/gpu/drm/shmobile/shmob_drm_backlight.c     |    2 +-
 drivers/gpu/drm/shmobile/shmob_drm_backlight.h     |    2 +-
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c          |    2 +-
 drivers/gpu/drm/shmobile/shmob_drm_crtc.h          |    2 +-
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |    3 +-
 drivers/gpu/drm/shmobile/shmob_drm_drv.h           |    2 +-
 drivers/gpu/drm/shmobile/shmob_drm_kms.c           |    2 +-
 drivers/gpu/drm/shmobile/shmob_drm_kms.h           |    2 +-
 drivers/gpu/drm/shmobile/shmob_drm_plane.c         |    2 +-
 drivers/gpu/drm/shmobile/shmob_drm_plane.h         |    2 +-
 drivers/gpu/drm/shmobile/shmob_drm_regs.h          |    2 +-
 drivers/gpu/drm/sis/sis_drv.c                      |    3 +-
 drivers/gpu/drm/sis/sis_drv.h                      |    2 +
 drivers/gpu/drm/sis/sis_mm.c                       |    6 +-
 drivers/gpu/drm/sti/sti_vtac.c                     |   12 +-
 drivers/gpu/drm/tdfx/tdfx_drv.c                    |    4 +-
 drivers/gpu/drm/tegra/dpaux.c                      |    4 +-
 drivers/gpu/drm/tegra/gem.h                        |    1 +
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |   61 +-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |   74 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |  304 ++--
 drivers/gpu/drm/ttm/ttm_bo_manager.c               |    9 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |   48 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |    8 +-
 drivers/gpu/drm/ttm/ttm_execbuf_util.c             |  160 +-
 drivers/gpu/drm/ttm/ttm_memory.c                   |    3 +-
 drivers/gpu/drm/udl/Kconfig                        |    3 +-
 drivers/gpu/drm/udl/udl_connector.c                |    4 +-
 drivers/gpu/drm/udl/udl_drv.c                      |  102 +-
 drivers/gpu/drm/udl/udl_drv.h                      |    2 +
 drivers/gpu/drm/udl/udl_fb.c                       |    3 +-
 drivers/gpu/drm/udl/udl_main.c                     |    8 +-
 drivers/gpu/drm/via/via_dma.c                      |    4 +-
 drivers/gpu/drm/via/via_drv.c                      |    3 +-
 drivers/gpu/drm/via/via_drv.h                      |    2 +
 drivers/gpu/drm/via/via_map.c                      |    6 +-
 drivers/gpu/drm/via/via_mm.c                       |    6 +-
 drivers/gpu/drm/via/via_verifier.c                 |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c             |  183 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c             |   22 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   27 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |   10 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |  346 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.h              |   35 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c               |   11 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c      |    3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   50 +-
 drivers/gpu/ipu-v3/Kconfig                         |    3 +-
 drivers/gpu/ipu-v3/Makefile                        |    3 +-
 drivers/gpu/ipu-v3/ipu-common.c                    |  920 +++++-----
 drivers/gpu/ipu-v3/ipu-cpmem.c                     |  764 +++++++++
 drivers/gpu/ipu-v3/ipu-csi.c                       |  741 ++++++++
 drivers/gpu/ipu-v3/ipu-ic.c                        |  778 +++++++++
 drivers/gpu/ipu-v3/ipu-prv.h                       |   44 +-
 drivers/gpu/ipu-v3/ipu-smfc.c                      |  157 +-
 drivers/staging/imx-drm/imx-drm-core.c             |    1 +
 drivers/staging/imx-drm/ipuv3-plane.c              |   16 +-
 drivers/video/fbdev/Kconfig                        |    4 +
 drivers/video/fbdev/core/Makefile                  |    1 +
 drivers/video/fbdev/core/fb_cmdline.c              |  110 ++
 drivers/video/fbdev/core/fbmem.c                   |   92 -
 drivers/video/fbdev/core/modedb.c                  |    3 -
 include/drm/ati_pcigart.h                          |   30 +
 include/drm/drmP.h                                 |  721 +-------
 include/drm/drm_agpsupport.h                       |   26 +-
 include/drm/drm_crtc.h                             |   30 +-
 include/drm/drm_dp_helper.h                        |   16 +-
 include/drm/drm_dp_mst_helper.h                    |    2 +
 include/drm/drm_fb_helper.h                        |    1 -
 include/drm/drm_gem.h                              |  183 ++
 include/drm/drm_gem_cma_helper.h                   |    4 +-
 include/drm/drm_legacy.h                           |  203 +++
 include/drm/drm_memory.h                           |   59 -
 include/drm/drm_mipi_dsi.h                         |    2 +
 include/drm/drm_modeset_lock.h                     |   20 +-
 include/drm/drm_usb.h                              |   15 -
 include/drm/ttm/ttm_bo_api.h                       |   49 +-
 include/drm/ttm/ttm_bo_driver.h                    |   32 +-
 include/drm/ttm/ttm_execbuf_util.h                 |   24 +-
 include/linux/platform_data/rcar-du.h              |    4 +-
 include/uapi/drm/exynos_drm.h                      |   40 -
 include/uapi/drm/radeon_drm.h                      |   23 +
 include/uapi/drm/vmwgfx_drm.h                      |    2 +-
 include/video/imx-ipu-v3.h                         |  326 ++--
 525 files changed, 25210 insertions(+), 11678 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/panel/auo,b101xtn01.txt
 create mode 100644 Documentation/devicetree/bindings/video/adi,adv7123.txt
 create mode 100644 Documentation/devicetree/bindings/video/renesas,du.txt
 create mode 100644 Documentation/devicetree/bindings/video/thine,thc63lvdm83d
 create mode 100644 Documentation/devicetree/bindings/video/vga-connector.txt
 create mode 100644 drivers/gpu/drm/drm_internal.h
 delete mode 100644 drivers/gpu/drm/drm_usb.c
 create mode 100644 drivers/gpu/drm/i915/i915_gem_render_state.h
 create mode 100644 drivers/gpu/drm/i915/intel_lrc.c
 create mode 100644 drivers/gpu/drm/i915/intel_lrc.h
 create mode 100644 drivers/gpu/drm/msm/adreno/adreno_device.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp4/mdp4_lcdc_encoder.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_pll.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/hdminve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/M0205.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/M0209.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/fan.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/fb/regsnv04.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/fuse.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/M0205.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/M0209.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/fan.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/sddr2.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fuse/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fuse/g80.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fuse/gf100.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fuse/gm107.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fuse/priv.h
 rename drivers/gpu/drm/nouveau/core/subdev/gpio/{nv92.c => nv94.c} (88%)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/arith.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/gm107.c
 delete mode 100644 drivers/gpu/drm/qxl/qxl_fence.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_prime.c
 rename drivers/gpu/drm/{ => radeon}/drm_buffer.c (96%)
 rename {include/drm => drivers/gpu/drm/radeon}/drm_buffer.h (100%)
 delete mode 100644 drivers/gpu/drm/radeon/r600_audio.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_mn.c
 create mode 100644 drivers/gpu/ipu-v3/ipu-cpmem.c
 create mode 100644 drivers/gpu/ipu-v3/ipu-csi.c
 create mode 100644 drivers/gpu/ipu-v3/ipu-ic.c
 create mode 100644 drivers/video/fbdev/core/fb_cmdline.c
 create mode 100644 include/drm/ati_pcigart.h
 create mode 100644 include/drm/drm_gem.h
 create mode 100644 include/drm/drm_legacy.h
 delete mode 100644 include/drm/drm_memory.h
 delete mode 100644 include/drm/drm_usb.h
--29444707-2032093349-1413251555=:28670--
