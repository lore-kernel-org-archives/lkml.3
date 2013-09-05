Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965255Ab3IEKlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:41:25 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52470 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935606Ab3IEKlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:41:08 -0400
Date: Thu, 5 Sep 2013 11:41:04 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm tree for 3.12-rc1
Message-ID: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1633344914-1378377664=:25450"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1633344914-1378377664=:25450
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


Hi Linus,

this is the main drm pull request, I have some overlap with sound and 
arm-soc, the sound patch is acked and may conflict based on -next reports 
but should be a trivial fixup, which I'll leave to you!

Highlights:
new drivers: MSM driver from Rob Clark

non-drm: switcheroo and hdmi audio driver support for secondary GPU poweroff, so drivers can use
         runtime PM to poweroff the GPUs. This can save 5 or 6W on some optimus laptops.

drm core: combined GEM and TTM VMA manager,
      per-filp mmap permission tracking  
      initial rendernode support (via a runtime enable for now, until we get api stable),
      remove old proc support,
      lots of cleanups of legacy code
      hdmi vendor infoframes and 4k modes
      lots of gem/prime locking and races fixes
      async pageflip scaffolding
      drm bridge objects

i915: Haswell PC8+ support and eLLC support, HDMI 4K support, initial per-process VMA pieces,
      watermark reworks, convert to generic hdmi infoframes, encoder reworking, fastboot support,

radeon: CIK PM support, remove 3d blit code in favour of DMA engines, Berlin GPU support, HDMI
        audio fixes

nouveau: secondary GPU power down support for optimus laptops, lots of fixes, use MSI, VP3 engine
         support

exynos: runtime pm support for g2d, DT support, remove non-DT,

tda998x i2c driver: lots of fixes for sync issues, 

gma500: lots of cleanups,

rcar: add LVDS support, fbdev emulation,

tegra: just minor fixes

Dave.

The following changes since commit 6e4dcff3adbf25acb87e74500a58e3c07bdec40f:

  drm/vmwgfx: Split GMR2_REMAP commands if they are to large (2013-08-30 09:03:39 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to 86a7e1224a68511d3a1ae0b7e11581b9d37723ae:

  Merge branch 'exynos-drm-next' of git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos into drm-next (2013-09-05 17:48:04 +1000)

----------------------------------------------------------------

Alex Deucher (104):
      drm/edid: add quirk for Medion MD30217PG
      drm/radeon: switch r6xx+ to using CP DMA for the blit copy callback
      drm/radeon/kms: remove r6xx+ blit copy routines
      drm/radeon: add UVD->DPM helper function (v5)
      drm/radeon/dpm: use multiple UVD power states (v3)
      drm/radeon/dpm: rework thermal state handling
      drm/radeon: default to 1024M gart size on rv770+
      drm/radeon/dpm: use performance state if no UVD state
      drm/radeon/kms: fix up dce8 display watermark calc for dpm
      drm/radeon/cik: implement some more atom helpers for DPM
      drm/radeon: switch CIK to use radeon_ucode.h
      drm/radeon/cik: add support for pcie gen1/2/3 switching
      drm/radeon: add support for ASPM on CIK asics
      drm/radeon/cik: restructure rlc setup
      drm/radeon: clean up sumo_rlc_init() for code sharing
      drm/radeon: convert SI,CIK to use sumo_rlc functions
      drm/radeon: implement clock and power gating for CIK (v3)
      drm/radeon: add indirect accessors for dift registers on CIK
      drm/radeon/sumo add helper to go from vid7 to vid2
      drm/radeon: switch to pptable.h
      drm/radeon: add structs to store uvd clock voltage deps
      drm/radeon/cik: add rlc helpers for DPM
      drm/radeon: add support for thermal controller on KB/KV
      drm/radeon: add CI to r600_is_internal_thermal_sensor()
      drm/radeon: add KB/KV to r600_is_internal_thermal_sensor
      drm/radeon: add get_temperature() callbacks for CIK (v2)
      drm/radeon: adjust si_dpm function for code sharing
      drm/radeon/dpm: update cac leakage table parsing for CI
      drm/radeon/dpm: add support for parsing the atom powertune table
      drm/radeon/dpm: grab mvdd_dependency_on_mclk info from vbios
      drm/radeon: add structs to store vce clock voltage deps
      drm/radeon: add clock voltage dep tables for acp, samu
      drm/radeon: parse the vce clock voltage deps table
      drm/radeon: parse the uvd clock voltage deps table
      drm/radeon/dpm: clean up the extended table error pathes
      drm/radeon: parse the samu clock voltage deps table
      drm/radeon: parse the acp clock voltage deps table
      drm/radeon: add r600_get_pcie_lane_support helper
      drm/radeon/dpm: add vce clocks to radeon_ps
      drm/radeon/dpm: add a helper to encode pcie lane setting
      drm/radeon/dpm: add helper to fetch the vrefresh of the current mode
      drm/radeon/kms: add dpm support for KB/KV
      drm/radeon: add dpm support for CI dGPUs (v2)
      drm/radeon/dpm: add debugfs support for CI
      drm/radeon/dpm: implement force performance level for CI
      drm/radeon/dpm: implement vblank_too_short callback for CI
      drm/radeon/dpm: add debugfs support for KB/KV
      drm/radeon/dpm: implement force performance level for KB/KV
      drm/radeon/dpm: add new callback for powergating UVD (v4)
      drm/radeon: restructure UVD code to handle UVD PG (v2)
      drm/radeon/dpm: implement UVD powergating for KB/KV
      drm/radeon/dpm: implement UVD powergating for CI
      drm/radeon/dpm: add reclocking quirk for ASUS K70AF
      drm/radeon/dpm: adjust the vblank time checks for eg, ni, si
      drm/radeon: fix endian bugs in hw i2c atom routines
      drm/edid: add a helper function to extract the speaker allocation data block (v3)
      drm/radeon: add audio support for DCE6/8 GPUs (v12)
      drm/radeon: set speaker allocation for DCE4/5 (v2)
      drm/radeon: set speaker allocation for DCE3.2
      drm/radeon: add cg and pg flags
      drm/radeon: use new cg/pg flags for SI
      drm/radeon/si: restructure cg code (v3)
      drm/radeon: fixes for gfx clockgating on SI
      drm/radeon: handle cg in SI dpm code
      drm/radeon: enable mgcg on SI
      drm/radeon/si: properly set up the clearstate buffer for pg (v2)
      drm/radeon/si: enable DMA pg by default
      drm/radeon: restructure cg/pg on cik (v2)
      drm/radeon: fixes for gfx clockgating on CIK
      drm/radeon/cik: properly set up the clearstate buffer for pg (v2)
      drm/radeon: handle cg in CI dpm code
      drm/radeon: handle cg in KB/KV dpm code
      drm/radeon: enable mgcg on CIK
      drm/radeon: update line buffer allocation for dce4.1/5
      drm/radeon: update line buffer allocation for dce6
      drm/radeon: update line buffer allocation for dce8
      drm/radeon: check firmware overrides for mclk/sclk ss
      drm/radeon: fix LCD record parsing
      drm/radeon: atombios hw i2c fixes
      drm/radeon: disable the GRPH block when we disable the crtc
      drm/radeon: enable uvd dpm on CI
      drm/radeon/dpm: track uvd gated state for ci
      drm/radeon/dpm: ungate blocks in dpm disable for kb/kv
      drm/radeon: fill in gpu_init for berlin GPU cores
      drm/radeon: add berlin pci ids
      drm/radeon: fix resume on some rs4xx boards (v2)
      drm/radeon: fix handling of variable sized arrays for router objects
      drm/radeon/audio: set up the sads on DCE3.2 asics
      drm/radeon: split out radeon_uvd_resume from uvd_v4_2_resume
      drm/radeon: check the return value of uvd_v1_0_start in uvd_v1_0_init
      drm/radeon/dpm: only need to reprogram uvd if uvd pg is enabled
      drm/radeon: fix init ordering for r600+
      drm/radeon: gcc fixes for radeon_atombios.c
      drm/radeon: gcc fixes for rv6xx dpm
      drm/radeonn: gcc fixes for rv7xx/eg/btc dpm
      drm/radeon: gcc fixes for sumo dpm
      drm/radeon: gcc fixes for trinity dpm
      drm/radeon: gcc fixes for ni dpm
      drm/radeon: gcc fixes for si dpm
      drm/radeon: gcc fixes for ci dpm
      drm/radeon: gcc fixes for kb/kv dpm
      drm/radeon: gcc fixes for extended dpm tables
      drm/radeon/dpm: make sure dc performance level limits are valid (BTC-SI) (v2)
      drm/radeon/dpm: make sure dc performance level limits are valid (CI)

Andrzej Hajda (3):
      drm/exynos: fimd: replace struct fb_videomode with videomode
      drm/exynos: fimd: get signal polarities from device tree
      drm/exynos: fimd: move platform data parsing to separate function

Andy Shevchenko (1):
      drm: don't push static constants on stack for %*ph

Ben Skeggs (1):
      drm/nv50-/kms: assume analog display connected if load on any pin

Ben Widawsky (58):
      drm/i915: Remove extra error state NULL
      drm/i915: Extract error buffer capture
      drm/i915: make PDE|PTE platform specific
      drm/i915: Really share scratch page
      drm/i915: Combine scratch members into a struct
      drm/i915: Drop dev from pte_encode
      drm/i915: Use gtt shortform where possible
      drm/i915: Move fbc members out of line
      drm/i915: Move gtt_mtrr to i915_gtt
      drm: pre allocate node for create_block
      drm: Change create block to reserve node
      drm/i915: Getter/setter for object attributes
      drm/i915: Kill obj->gtt_offset
      drm/i915: Embed drm_mm_node in i915 gem obj
      drm/i915/hsw: Set correct Haswell PTE encodings.
      drm/i915: Define some of the eLLC magic
      drm/i915: store eLLC size
      drm/i915: Use eLLC/LLC by default when available
      drm/i915: debugfs entries for [e]LLC
      drm/i915: Move gtt and ppgtt under address space umbrella
      drm/i915: Put the mm in the parent address space
      drm/i915: Create a global list of vms
      drm/i915: Move active/inactive lists to new mm
      drm/i915: Free stolen node on failed preallocation
      drm/i915: Create VMAs
      drm/i915: Make i915 events part of uapi
      drm/i915/hsw: Change default LLC age to 3
      drm/i915: Create an init vm
      drm/i915: Rework drop caches for checkpatch
      drm/i915: Make proper functions for VMs
      drm/i915: Use bound list for inactive shrink
      drm/i915: Add VM to pin
      drm/i915: Use ggtt_vm to save some typing
      drm/i915: Update describe_obj
      drm/i915: thread address space through execbuf
      drm/i915: make caching operate on all address spaces
      drm/i915: BUG_ON put_pages later
      drm/i915: make reset&hangcheck code VM aware
      drm/i915: eliminate dead domain clearing on reset
      drm/i915: Improve VMA comments
      drm/i915: Rework __i915_gem_shrink
      drm/i915: plumb VM into bind/unbind code
      drm/i915: Use new bind/unbind in eviction code
      drm/i915: turn bound_ggtt checks to bound_any
      drm/i915: Fix up map and fenceable for VMA
      drm/i915: mm_list is per VMA
      drm/i915: Update error capture for VMs
      drm/i915: Add vma to list at creation
      drm/i915: WARN_ON failed map_and_fenceable
      drm/i915: Initialize seqno for VECS too
      drm/i915: Get VECS semaphore info on error
      drm/i915: Remove node only when allocated
      drm/i915: cleanup map&fence in bind
      drm: WARN when removing unallocated node
      drm/i915: s/obj->exec_list/obj->obj_exec_link in debugfs
      drm/i915: Switch eviction code to use vmas
      drm/i915: prepare bind_to_vm for preallocated vma
      drm/i915/vma: Correct use after free in eviction

Chanho Park (1):
      drm/exynos: add device tree support for rotator

Chris Wilson (30):
      drm/i915: Verify that our stolen memory doesn't conflict
      drm/i915: Fix retrieval of hangcheck stats
      drm/i915: Replace open-coding of DEFAULT_CONTEXT_ID
      drm/i915: Add some debug breadcrumbs to connector detection
      drm/i915: Use Graphics Base of Stolen Memory on all gen3+
      drm/i915: Colocate all GT access routines in the same file
      drm/i915: Use a private interface for register access within GT
      drm/i915: Use the common register access functions for NOTRACE variants
      drm/i915: Squash gen lookup through multiple indirections inside GT access
      drm/i915: Convert the register access tracepoint to be conditional
      drm/i915: Retry DP aux_ch communications with a different clock after failure
      drm/i915: Replace open-coded offset_in_page()
      drm/i915: Do not dereference NULL crtc or fb until after checking
      drm/i915: Squelch repeated reasoning for why FBC cannot be activated
      drm/i915: Use the same pte_encoding for ppgtt as for gtt
      drm/i915: Tidy the macro casting by using an inline function
      drm/i915: Acquire dpio_lock for VLV sideband programming in DP/HDMI
      drm/i915: Rename I915_CACHE_MLC_LLC to L3_LLC for Ivybridge
      drm/i915: Export intel_framebuffer_fini
      drm: Apply kref_put_mutex() optimisations to drm_gem_object_unreference_unlocked()
      drm/i915: List objects allocated from stolen memory in debugfs
      drm/i915: Update rules for reading cache lines through the LLC
      drm/i915: Track when an object is pinned for use by the display engine
      drm/i915: Update rules for writing through the LLC with the cpu
      drm/i915: Allow the GPU to cache stolen memory
      drm/i915: Only do a chipset flush after a clflush
      drm/i915: Use Write-Through cacheing for the display plane on Iris
      drm/i915: Allow the user to set bo into the DISPLAY cache domain
      drm/i915: Print the changes required for modeset
      drm/i915: Drop the overzealous warning from i915_gem_set_cache_level

Christian König (7):
      drm/radeon: rework ring function handling
      drm/radeon: rework UVD writeback & [rw]ptr handling
      drm/radeon: remove special handling for the DMA ring
      drm/radeon: separate UVD code v3
      drm/radeon: separate DMA code
      drm/radeon: enable UVD interrupts on CIK
      drm/radeon: support render nodes

Damien Lespiau (37):
      drm/i915: Make intel_enable_fbc() static
      drm/i915: Fix reason for per-chip disabling of FBC
      drm/i915: Use seq_puts/seq_putc when possible
      drm/i915: Fix a few style issues found by checkpatch.pl
      drm/i915: Fix a couple of "should it be static?" sparse warnings
      drm/i915: Bail out once we've found the context object
      drm/i915: Use for_each_pipe() when possible
      drm/i915: Don't attempt to read an unitialized stack value
      drm/i915: We implement WaFbcWaitForVBlankBeforeEnable for ilk and snb
      drm/i915: We implement WaFbcAsynchFlipDisableFbcQueue on ilk and snb
      drm/i915: We implement WaFbcDisableDpfcClockGating on ilk
      drm/i915: We implement WaMPhyProgramming on Haswell
      drm/i915: Don't try to calculate RC6 residency on GEN4 and before
      video/hdmi: Replace the payload length by their defines
      video/hdmi: Introduce a generic hdmi_infoframe union
      video/hdmi: Add a macro to return the size of a full infoframe
      video/hmdi: Clear the whole incoming buffer, not just the infoframe size
      drm: Don't generate invalid AVI infoframes for CEA modes
      drm/i915/hdmi: Change the write_infoframe vfunc to take a buffer and a type
      drm/i915/hdmi: Port the infoframe code to the common hdmi helpers
      drm/i915/sdvo: Port the infoframe code to the shared infrastructure
      drm/i915: Remove the now obsolete infoframe definitions
      drm: Handle the DBLCLK flag in the common infoframe helper
      drm: Set aspect ratio fields in the AVI infoframe even for non CEA modes
      drm/i915/hmdi: Rename set_infoframe() to write_infoframe()
      drm/i915: Remove stale prototypes
      drm/i915: Remove i915_gem_object_check_coherency()
      drm/i915: Fix #endif comment
      drm/i915: Make i915_hangcheck_elapsed() static
      drm/i915: Make intel_encoder_dpms() static
      drm/i915: Remove intel_modeset_disable()
      drm/i915: Make intel_set_mode() static
      drm/i915: Remove DSPARB_HWCONTROL()
      drm/i915: Remove HAS_PIPE_CONTROL()
      drm: Remove IS_IRONLAKE_D()
      drm/i915: Remove I915_READ_{NOPID, SYNC_0, SYNC_1})()
      drm: Remove the dithering_mode_property field

Dan Carpenter (8):
      drm/i915: checking for NULL instead of IS_ERR()
      drm/i915: use after free on error path
      drm/i915: unbreak i915_gem_object_ggtt_unbind()
      drm/i915: fix a limit check in hsw_compute_wm_results()
      gpu: host1x: fix an integer overflow check
      gpu: host1x: returning success instead of -ENOMEM
      drm/prime: double lock typo
      drm/omap: tiler: clear buffer properly

Daniel Vetter (122):
      drm/i915: consolidate pch pll enable sequence
      drm/i915: use sw tracked state to select shared dplls
      drm/i915: duplicate intel_enable_pll into i9xx and vlv versions
      drm/i915: asserts for lvds pre_enable
      drm/i915: move encoder pre enable hooks togther on ilk+
      drm/i915: hw state readout for i9xx dplls
      drm/i915: move i9xx dpll enabling into crtc enable function
      drm/i915: s/pre_pll/pre/ on the lvds port enable function
      drm/i915: pixel multiplier readout support for pch ports
      drm/i915: explicitly cast pipe -> cpu_transcoder
      drm/i915: Explicitly cast pipe -> intel_dpll_id
      drm/i915: less magic for stolen preallocated objects w/o gtt offset
      drm/i915: assert_spin_locked for pipestat interrupt enable/disable
      drm/i915: fix dvo DPLL regression
      drm/i915: dvo needs a P2 divisor of 4
      drm/i915: convert debugfs creation/destruction to table
      drm/i915: clean up media reset on gm45
      drm/i915: WARN if the bios reserved range is bigger than stolen size
      drm/i915: don't frob mm.suspended when not using ums
      drm/i915: extract ibx_display_interrupt_update
      drm/i915: improve SERR_INT clearing for fifo underrun reporting
      drm/i915: improve GEN7_ERR_INT clearing for fifo underrun reporting
      drm/i915: kill lpt pch transcoder->crtc mapping code for fifo underruns
      drm/i915: irq handlers don't need interrupt-safe spinlocks
      drm/i915: streamline hsw_pm_irq_handler
      drm/i915: queue work outside spinlock in hsw_pm_irq_handler
      drm/i915: kill dev_priv->rps.lock
      drm/i915: unify ring irq refcounts (again)
      drm/i915: don't enable PM_VEBOX_CS_ERROR_INTERRUPT
      drm/i915: clean up vlv ->pre_pll_enable and pll enable sequence
      drm/i915: Fix up cpt pixel multiplier enable sequence
      drm/i915: clear DPLL reg when disabling i9xx dplls
      drm/i915: unify PM interrupt preinstall sequence
      drm/i915: unify GT/PM irq postinstall code
      drm/i915: extract rps interrupt enable/disable helpers
      drm/i915: simplify rps interrupt enabling/disabling sequence
      drm: remove drm_modctx ioctl and use drm_noop instead
      drm: kill dev->context_wait
      drm: remove dev->last_switch
      drm: kill dev->interrupt_flag and dev->dma_flag
      drm: kill dev->ctx_start and dev->lck_start
      drm/radoen: kill radeon_dma_ioctl_kms
      drm: kill dev->buf_readers and dev->buf_writers
      drm/nouveau: drop DRIVER_PCI_DMA and DRIVER_SG
      drm/radeon: remove DRIVER_HAS_DMA/SG/PCI_DMA from the kms driver
      drm: fold in drm_sg_alloc into the ioctl
      drm: rip out dev->last_checked
      drm/gem: remove drm_gem_object_handle_unreference
      drm: move drm_getsarea into drm_bufs.c
      drm/bufs: s/drm_order/order_base_2/
      drm/r128: s/drm_order/order_base_2/
      drm/radeon: s/drm_order/order_base_2/
      drm: remove drm_order
      drm/i915: fix up error cleanup in i915_gem_object_bind_to_gtt
      drm/i915: disable stolen mem for OVERLAY_NEEDS_PHYSICAL
      drm/i915: fix reference counting in i915_gem_create
      Merge commit 'Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux'
      drm/i915: fix the racy object accounting
      drm/i915: fix pnv display core clock readout out
      drm/i915/dvo: use intel_encoder to the upcast macro
      drm/i915/dvo: switch ->mode_fixup to ->compute_config
      drm/i915: rip out legacy encoder->mode_fixup logic
      drm/i915/dvo: use native encoder ->mode_set callback
      drm/i915/sdvo: use intel_encoder for upcast helper
      drm/i915/tv: Use native encoder->mode_set callback
      drm/i915/crt: use native encoder->mode_set callback
      drm/i915/hdmi: use native encoder mode_set callback
      drm/i915/dp: use native encoder ->mode_set callback
      drm/i915/lvds: use the native encoder ->mode_set callback
      drm/i915/ddi: use the native encoder ->mode_set callback
      drm/i915: rip out legacy encoder->mode_set callback
      drm/i915: clean up crtc timings computation
      drm/gem: create drm_gem_dumb_destroy
      drm/omap: kill firstopen callback
      drm/radeon: kill firstopen callback for kms driver
      drm: kill dev->driver->set_version
      drm: hide legacy sg cleanup better from common code
      drm: disallow legacy sg ioctls for modesetting drivers
      drm: mark dma setup/teardown as legacy systems
      drm: disallow legacy dma ioctls for modesetting drivers
      drm: mark context support as a legacy subsystem
      drm/vmwgfx: remove redundant clearing of driver->dma_quiescent
      drm: remove FASYNC support
      drm: rip out DRIVER_FB_DMA and related code
      drm: rip out a few unused DRIVER flags
      drm: remove a bunch of unused #defines from drmP.h
      drm/memory: don't export agp helpers
      drm: hollow-out GET_CLIENT ioctl
      drm: no-op out GET_STATS ioctl
      drm: use common drm_gem_dmabuf_release in i915/exynos drivers
      drm/prime: remove cargo-cult locking from map_sg helper
      drm/prime: add a bit of documentation about gem_obj->import_attach
      drm/gem: move drm_gem_object_handle_unreference_unlocked into drm_gem.c
      drm/gem: remove bogus NULL check from drm_gem_object_handle_unreference_unlocked
      drm/gem: WARN about unbalanced handle refcounts
      drm: rip out drm_core_has_MTRR checks
      drm/docs: rip out removed driver flags documentation
      drm: remove the dma_ioctl special-case
      drm: fix locking in gem debugfs/procfs file
      drm/imx: kill firstopen callback
      drm/vmwgfx: remove ->firstopen callback
      drm: don't call ->firstopen for KMS drivers
      drm: remove procfs code, take 2
      drm: move dev data clearing from drm_setup to lastclose
      drm/gem: fix up flink name create race
      drm/prime: fix error path in drm_gem_prime_fd_to_handle
      drm/gem: make drm_gem_object_handle_unreference_unlocked static
      drm/prime: use proper pointer in drm_gem_prime_handle_to_fd
      drm/prime: shrink critical section protected by prime lock
      drm/prime: clarify logic a bit in drm_gem_prime_fd_to_handle
      drm/gem: switch dev->object_name_lock to a mutex
      drm/gem: completely close gem_open vs. gem_close races
      drm/prime: proper locking+refcounting for obj->dma_buf link
      drm/prime: Simplify drm_gem_remove_prime_handles
      drm/prime: make drm_prime_lookup_buf_handle static
      drm/prime: Always add exported buffers to the handle cache
      drm/i915: reserve I915_CACHING_DISPLAY and document cache modes
      drm/i915: clarify error paths in create_stolen_for_preallocated
      drm/i915: use vma->node directly and rewrap map&fence in bind
      drm/i915: unpin backing storage in dmabuf_unmap
      drm/i915: explicit store base gem object in dma_buf->priv
      drm/i915: Use POSTING_READ in lcpll code

Darren Etheridge (1):
      drm/tilcdc fixup mode to workaround sync for tda998x

Dave Airlie (18):
      Merge tag 'drm-intel-next-2013-07-12' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge tag 'drm-intel-next-2013-07-26-fixed' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm/next/du' of git://linuxtv.org/pinchartl/fbdev into drm-rcar-stable
      Merge remote-tracking branch 'pfdo/drm-rcar-for-v3.12' into drm-next
      Merge tag 'drm-intel-next-2013-08-09' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'gma500-next' of git://github.com/patjak/drm-gma500 into drm-next
      Merge branch 'drm-next' of git://people.freedesktop.org/~robclark/linux into drm-next
      gpu/vga_switcheroo: add driver control power feature. (v3)
      snd/hda: add runtime suspend/resume on optimus support (v4)
      drm: allow open of dynamic off devices.
      nouveau: add runtime PM support (v0.9)
      Merge tag 'drm-intel-next-2013-08-23' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-next-3.12' of git://people.freedesktop.org/~agd5f/linux into drm-next
      drm/tegra: fix up page flip flags.
      drm/nouveau: fix up 32-bit ioctls and device wake up.
      Merge tag 'drm/for-3.12-rc1' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next

David Herrmann (27):
      drm/gem: simplify object initialization
      drm/pci: remove useles #if 1
      drm: add unified vma offset manager
      drm/gem: convert to new unified vma manager
      drm/ttm: convert to unified vma offset manager
      drm/vma: provide drm_vma_node_unmap() helper
      drm/gem: fix mmap vma size calculations
      drm/mm: include required headers in drm_mm.h
      drm/mm: add "best_match" flag to drm_mm_insert_node()
      drm/agp: move AGP cleanup paths to drm_agpsupport.c
      drm/ttm: replace drm_mm_pre_get() by direct alloc
      drm/i915: pre-alloc instead of drm_mm search/get_block
      drm/mm: remove unused API
      drm/ttm: inline drm_bo_setup_vm()
      drm: provide agp dummies for CONFIG_AGP=n
      drm/ast: remove unused driver_private access
      drm/mgag200: remove unused driver_private access
      drm/cirrus: remove unused driver_private access
      drm/qxl: remove unused object_pin/unpin() helpers
      drm/radeon: remove stale gem->driver_private access
      drm/host1x: stop casting VMA offsets to 32bit
      drm/vma: add access management helpers
      drm/gem: implement vma access management
      drm: verify vma access in TTM+GEM drivers
      drm: implement experimental render nodes
      drm: fix DRM_IOCTL_MODE_GETFB handle-leak
      drm/tda998x: BUG() on invalid audio format

Egbert Eich (1):
      drm/i915: Add messages useful for HPD storm detection debugging (v2)

Emil Velikov (3):
      drm/nv50-/disp: use the number of dac, sor, pior rather than hardcoded values
      drm/nouveau/therm: Set the correct pwm_mode upon resume
      drm/nv50/disp: prevent false output detection on the original nv50

Geert Uytterhoeven (1):
      drm: DRM should depend on HAS_DMA

Guillaume Clement (1):
      i915: Fix SDVO potentially turning off randomly

Ilia Mirkin (5):
      drm: use ida to allocate connector ids
      drm/nouveau/core: get rid of math.h, replace log2i with order_base_2
      drm/nouveau/vdec: implement support for VP3 engines
      drm/nouveau: remove duplicate copy of nv44_graph_class
      drm/nouveau/i2c: pass the function pointers in at creation time

Imre Deak (3):
      drm/i915: restore debug message lost in merge resolution
      drm/i915: dvo_ch7xxx: fix vsync polarity setting
      drm/i915: make user mode sync polarity setting explicit

Inki Dae (4):
      drm/exynos: explicit store base gem object in dma_buf->priv
      drm/exynos: add runtime pm interfaces to g2d driver
      drm/exynos: fix fimd pixel format setting
      drm/exynos: check a pixel format to a particular window layer

Jani Nikula (6):
      drm/i915: rearrange vlv dp enable and pre_enable callbacks
      drm/i915: rearrange vlv hdmi enable and pre_enable callbacks
      drm/i915: move encoder->enable callback later in VLV crtc enable
      drm/i915: remove unused leftover variable irq_received
      drm/i915: give more distinctive names to ring hangcheck action enums
      drm/i915: drop unnecessary local variable to suppress build warning

Jesse Barnes (12):
      drm/i915: add fastboot param for fast & loose mode setting
      drm/i915: get mode clock when reading the pipe config v9
      drm/i915: copy fetched mode state into crtc at setup_hw time v5
      drm/i915: turn off panel fitting at flip time if needed v2
      drm/i915: flip on a no fb -> fb transition if crtc is active v3
      drm/i915: fixup messages in pipe_config_compare
      drm/i915: split encoder get_config calls from crtc get_clock calls
      drm/i915: enable IPS for bpp <= 24
      drm/i915: expose HDMI connectors on port C on BYT
      drm/i915: make IVB FDI training match spec v3
      drm/i915: Expose energy counter on SNB+ through debugfs
      drm/i915: drop WaMbcDriverBootEnable workaround

Josh Triplett (1):
      i915: Add a Kconfig option to turn on i915.preliminary_hw_support by default

Keith Packard (3):
      drm: Pass page flip ioctl flags to driver
      drm: Add DRM_MODE_PAGE_FLIP_ASYNC flag definition
      drm: Advertise async page flip ability through GETCAP ioctl

Kristian Høgsberg (2):
      drm: fix minor number range calculation
      drm/i915: Support render nodes

Laurent Pinchart (23):
      drm/rcar-du: Add missing alpha plane register definitions
      drm/rcar-du: Use devm_ioremap_resource()
      drm/rcar-du: Add platform module device table
      drm/rcar-du: Support per-CRTC clock and IRQ
      drm/rcar-du: Clarify comment regarding plane Y source coordinate
      drm/rcar-du: Split LVDS encoder and connector
      drm/rcar-du: Split VGA encoder and connector
      drm/rcar-du: Merge LVDS and VGA encoder code
      drm/rcar-du: Rename platform data fields to match what they describe
      drm/rcar-du: Create rcar_du_planes structure
      drm/rcar-du: Rename rcar_du_plane_(init|register) to rcar_du_planes_*
      drm/rcar-du: Introduce CRTCs groups
      drm/rcar-du: Use dynamic number of CRTCs instead of CRTCs array size
      drm/rcar-du: Remove register definitions for the second channel
      drm/rcar-du: Move output routing configuration to group
      drm/rcar-du: Add support for the R8A7790 DU
      drm/rcar-du: Fix buffer pitch alignment for R8A7790 DU
      drm/rcar-du: Add support for multiple groups
      drm/rcar-du: Add support for DEFR8 register
      drm/rcar-du: Rework output routing support
      drm/rcar-du: Configure RGB output routing to DPAD0
      drm/rcar-du: Add internal LVDS encoder support
      drm/rcar-du: Add FBDEV emulation support

Lespiau, Damien (22):
      drm: Remove stale prototypes
      drm: Remove drm_mode_create_dithering_property()
      drm: Remove drm_mode_list_concat()
      drm: Make drm_mode_remove() static
      drm: Remove 2 unused defines
      drm: Make drm_fb_cma_describe() static
      drm: Remove unused PCI ids
      drm: Make drm_get_platform_dev() static
      drm: Don't export drm_find_cea_extension() any more
      drm/edid: Fix add_cea_modes() style issues
      drm/edid: Parse the HDMI CEA block and look for 4k modes
      drm: Add support for alternate clocks of 4k modes
      video/hdmi: Don't let the user of this API create invalid infoframes
      video/hdmi: Derive the bar data valid bit from the bar data fields
      video/hdmi: Introduce helpers for the HDMI vendor specific infoframe
      gpu: host1x: Port the HDMI vendor infoframe code the common helpers
      drm/edid: Move HDMI_IDENTIFIER to hdmi.h
      video/hdmi: Hook the HDMI vendor infoframe with the generic _pack()
      video/hdmi: Use hdmi_vendor_infoframe for the HDMI specific infoframe
      drm: Add a helper to forge HDMI vendor infoframes
      drm/i915/hdmi: Write HDMI vendor specific infoframes
      video/hdmi: Rename HDMI_IDENTIFIER to HDMI_IEEE_OUI

Lucas Stach (1):
      drm/nouveau: use MSI interrupts

Maarten Lankhorst (4):
      drm/i915: remove unused members from drm_i915_private
      drm/ttm: kill unused functions
      drm/nouveau: require contiguous bo for framebuffer
      drm/nouveau: fix command submission to use vmalloc for big allocations

Mark Brown (1):
      drm/exynos: Add missing includes

Martin Peres (6):
      drm/nouveau: Support render nodes
      drm/nouveau/fan: restore pwm value on resume when in manual/auto mode
      drm/nouveau/timer: restore the time on resume
      drm/nouveau/timer: add a way to cancel alarms
      drm/nouveau/therm: survive to suspend/resume cycles
      drm/nouveau/bios/therm: handle vbioses with duplicate entries (mostly nva5)

Mika Kuoppala (6):
      drm/i915: export error state to string conversion
      drm/i915: export error state ref handling
      drm/i915: introduce i915_error_state_buf_init
      drm/i915: add error_state sysfs entry
      drm/i915: move error state to own compilation unit
      drm/i915: introduce i915_queue_hangcheck

Mikko Perttunen (1):
      drm/tegra: hdmi: Make sure clock is enabled before dumping registers

Patrik Jakobsson (35):
      drm/gma500: Add generic code for clock calculation
      drm/gma500/cdv: Make use of the generic clock code
      drm/gma500: Make use of gma_pipe_has_type()
      drm/gma500/psb: Make use of generic clock code
      drm/gma500: Remove the unused psb_intel_display.h
      drm/gma500: Add generic pipe/crtc functions
      drm/gma500/cdv: Use identical generic crtc funcs
      drm/gma500: Make all chips use gma_wait_for_vblank
      drm/gma500/psb: Use identical generic crtc funcs
      drm/gma500/cdv: Convert to gma_pipe_set_base()
      drm/gma500: Add IS_CDV() macro
      drm/gma500/cdv: Convert to gma_crtc_dpms()
      drm/gma500/cdv: Convert to generic gamma funcs
      drm/gma500/psb: Convert to gma_pipe_set_base()
      drm/gma500: Convert to generic gamma funcs
      drm/gma500/psb: Convert to gma_crtc_dpms()
      drm/gma500/oak: Use identical generic crtc funcs
      drm/gma500/mdfld: Use identical generic crtc funcs
      drm/gma500/psb: Convert to generic crtc->destroy
      drm/gma500: Add generic cursor functions
      drm/gma500/cdv: Convert to generic cursor funcs
      drm/gma500/psb: Convert to generic cursor funcs
      drm/gma500: Add generic encoder functions
      drm/gma500: Convert to generic encoder funcs
      drm/gma500: Add generic crtc save/restore funcs
      drm/gma500/psb: Convert to generic save/restore
      drm/gma500/cdv: Convert to generic save/restore
      drm/gma500: Add generic set_config() function
      drm/gma500/psb: Convert to generic set_config()
      drm/gma500/cdv: Convert to generic set_config()
      drm/gma500: Rename psb_intel_crtc to gma_crtc
      drm/gma500: Rename psb_intel_connector to gma_connector
      drm/gma500: Rename psb_intel_encoder to gma_encoder
      drm/gma500/cdv: Add and hook up chip op for watermarks
      drm/gma500/cdv: Add and hook up chip op for disabling sr

Paulo Zanoni (39):
      drm/i915: invert the verbosity of intel_enable_fbc
      drm/i915: remove SDV support from lpt_pch_init_refclk
      drm/i915: extract FDI mPHY functions from lpt_init_pch_refclk
      drm/i915: extract lpt_enable_clkout_dp from lpt_init_pch_refclk
      drm/i915: kill ivybridge_irq_preinstall
      drm/i915: extract ilk_display_irq_handler
      drm/i915: extract ivb_display_irq_handler
      drm/i915: don't read or write GEN6_PMIIR on Gen 5
      drm/i915: reorganize ironlake_irq_handler
      drm/i915: POSTING_READ(DEIER) on ivybridge_irq_handler
      drm/i915: add ILK/SNB support to ivybridge_irq_handler
      drm/i915: kill Ivybridge vblank irq vfuncs
      drm/i915: kill ivybridge_irq_postinstall
      drm/i915: invert {ilk, snb}_gt_irq_handler check
      drm/i915: extend lpt_enable_clkout_dp
      drm/i915: disable CLKOUT_DP when it's not needed
      drm/i915: add functions to disable and restore LCPLL
      drm/i915: silence useless messages about DDI buffer translation
      drm/i915: remove use_fdi_mode argument from intel_prepare_ddi_buffers
      drm/i915: remove set but unused variables
      drm/i915: print a message when we detect an early Haswell SDV
      drm/i915: check the power well when redisabling VGA
      drm/i915: clarify Haswell power well bit names
      drm/i915: enable the power well before module unload
      drm/i915: add the FCLK case to intel_ddi_get_cdclk_freq
      drm/i915: wrap GTIMR changes
      drm/i915: wrap GEN6_PMIMR changes
      drm/i915: don't update GEN6_PMIMR when it's not needed
      drm/i915: add dev_priv->pm_irq_mask
      drm/i915: don't disable/reenable IVB error interrupts when not needed
      drm/i915: don't queue PM events we won't process
      drm/i915: fix how we mask PMIMR when adding work to the queue
      drm/i915: merge HSW and SNB PM irq handlers
      drm/i915: grab force_wake when restoring LCPLL
      drm/i915: fix SDEIMR assertion when disabling LCPLL
      drm/i915: allow package C8+ states on Haswell (disabled)
      drm/i915: add i915_pc8_status debugfs file
      drm/i915: add i915.pc8_timeout function
      drm/i915: enable Package C8+ by default

Peter Wu (1):
      i915: fix ACPI _DSM warning

Rafael Barbalho (1):
      drm/i915: Cleaning up the relocate entry function

Rafał Miłecki (2):
      drm/radeon: use loop for initializing AFMT blocks
      drm/radeon: set speakers allocation earlier

Rob Clark (15):
      drm: const'ify ioctls table (v2)
      drm: add flip-work helper
      drm/tilcdc: use flip-work helper
      drm/omap: use flip-work helper
      drm/gem: add drm_gem_create_mmap_offset_size()
      drm/gem: add shmem get/put page helpers
      drm/gma500: use gem get/put page helpers
      drm/udl: use gem get/put page helpers
      drm/omap: kill omap_gem_helpers.c
      drm/msm: add register definitions
      drm/msm: basic KMS driver for snapdragon
      drm/msm: add register definitions for gpu
      drm/msm: add a3xx gpu support
      drm/msm: add basic hangcheck/recovery mechanism
      drm/msm: convert to drm_bridge

Rodrigo Vivi (7):
      drm/i915: split aux_clock_divider logic in a separated function for reuse.
      drm/i915: Enable/Disable PSR
      drm/i915: Added debugfs support for PSR Status
      drm/i915: Match all PSR mode entry conditions before enabling it.
      drm/intel: add enable_psr module option and disable psr by default
      drm/i915: add update function to disable/enable-back PSR
      drm/i915: Hook PSR functionality

Russell King (5):
      drm/i2c: tda998x: fix EDID reading on TDA19988 devices
      drm/i2c: tda998x: ensure VIP output mux is properly set
      drm/i2c: tda998x: fix npix/nline programming
      drm/i2c: tda998x: prepare for video input configuration
      drm/i2c: tda998x: add video and audio input configuration

Sachin Kamat (11):
      drm/exynos: Remove redundant NULL check in exynos_drm_buf
      drm/exynos: Add missing of.h header include
      drm/exynos: Remove redundant error messages
      drm/exynos: Add NULL pointer check
      drm/exynos: Make Exynos DRM drivers depend on OF
      drm/exynos: Remove non-DT support in exynos_ddc
      drm/exynos: Remove non-DT support in exynos_hdmiphy
      drm/exynos: Remove non-DT support in exynos_drm_g2d
      drm/exynos: Remove non-DT support in exynos_hdmi
      drm/exynos: Remove non-DT support in exynos_drm_fimd
      drm/exynos: Fix build error with exynos_drm_connector.c

Sean Paul (1):
      drm: Add drm_bridge

Sebastian Hesselbarth (2):
      drm/i2c: tda998x: fix sync generation and calculation
      drm/i2c: tda998x: prepare for broken sync workaround

Sergey Senozhatsky (1):
      radeon kms: fix uninitialised hotplug work usage in r100_irq_process()

Shobhit Kumar (2):
      drm: Added SDP and VSC structures for handling PSR for eDP
      drm/i915: Read the EDP DPCD and PSR Capability

Stephen Rothwell (1):
      drm/radeon: protect ACPI calls with CONFIG_ACPI

Stéphane Marchesin (3):
      drm/i915: Remove useless define
      drm: Remove drm_mode_validate_clocks
      drm/i915: tune the RC6 threshold for stability

Thierry Reding (4):
      drm/prime: Remove PRIME handles only if supported
      gpu: host1x: Check for valid host1x pointer
      gpu: host1x: Sort drivers by probe order
      drm/tegra: Parse device tree earlier

Tom Stellard (1):
      drm/radeon/si: Add support for CP DMA to CS checker for compute v2

Vikas Sajjan (2):
      drm/exynos: Add fallback option to get non physically contiguous memory for fb
      drm/exynos: Consider fallback option to allocation fail

Ville Syrjälä (37):
      drm/i915: Mask out hardware status bits from VLV DPLL register
      drm/i915: Use wait_for() to wait for Punit to change GPU freq on VLV
      drm/i915: Fix VLV DP RBR/HDMI/DAC PLL LPF coefficients
      drm/i915: Add scaled paramater to update_sprite_watermarks()
      drm/i915: Pass the actual sprite width to watermarks functions
      drm/i915: Calculate the sprite WM based on the source width instead of the destination width
      drm/i915: Rename hsw_wm_get_pixel_rate to ilk_pipe_pixel_rate
      drm/i915: Rename most wm compute functions to ilk_ prefix
      drm/i915: Don't pass "mem_value" to ilk_compute_fbc_wm
      drm/i915: Change the watermark latency type to uint16_t
      drm/i915: Split out reading of HSW watermark latency values
      drm/i915: Don't multiply the watermark latency values too early
      drm/i915: Add SNB/IVB support to intel_read_wm_latency
      drm/i915: Add ILK support to intel_read_wm_latency
      drm/i915: Store the watermark latency values in dev_priv
      drm/i915: Use the stored cursor and plane latencies properly
      drm/i915: Print the watermark latencies during init
      drm/i915: Disable specific watermark levels when latency is zero
      drm/i915: Use the watermark latency values from dev_priv for ILK/SNB/IVB too
      drm/i915: Add comments about units of latency values
      drm/i915: Use 'enabled' instead of 'enable' consistently in sprite WM code
      drm/i915: Split watermark level computation from the code
      drm/i915: Kill fbc_enable from hsw_lp_wm_results
      drm/i915: Rename hsw_data_buf_partitioning to intel_ddb_partitioning
      drm/i915: Silence a sparse warning
      drm/i915: Pull watermark level validity check out
      drm/i915: Rename hsw_lp_wm_result to intel_wm_level
      drm/i915: Calculate max watermark levels for ILK+
      drm/i915: Pull some watermarks state into a separate structure
      drm/i915: Split plane watermark parameters into a separate struct
      drm/i915: Pass crtc to our update/disable_plane hooks
      drm/i915: Don't try to disable plane if it's already disabled
      drm/i915: Pass plane and crtc to intel_update_sprite_watermarks
      drm/i915: Always call intel_update_sprite_watermarks() when disabling a plane
      drm/i915: Fix FB WM for HSW
      drm/i915: Fix context size calculation on SNB/IVB/VLV
      drm/i915: Print seqnos as unsigned in debugfs

Vinit Azad (1):
      drm/i915: Only unmask required PM interrupts

Wei Yongjun (1):
      drm/vmwgfx: fix error return code in vmw_driver_load()

Xiong Zhang (1):
      drm/i915: add prefault_disable module option

 Documentation/DocBook/drm.tmpl                     |  138 +-
 .../devicetree/bindings/gpu/samsung-rotator.txt    |   27 +
 drivers/gpu/drm/Kconfig                            |   15 +-
 drivers/gpu/drm/Makefile                           |    5 +-
 drivers/gpu/drm/ast/ast_drv.c                      |    5 +-
 drivers/gpu/drm/ast/ast_drv.h                      |    3 -
 drivers/gpu/drm/ast/ast_main.c                     |    9 +-
 drivers/gpu/drm/ast/ast_ttm.c                      |    5 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c                |    5 +-
 drivers/gpu/drm/cirrus/cirrus_drv.h                |    3 -
 drivers/gpu/drm/cirrus/cirrus_main.c               |    9 +-
 drivers/gpu/drm/cirrus/cirrus_ttm.c                |    5 +-
 drivers/gpu/drm/drm_agpsupport.c                   |   51 +
 drivers/gpu/drm/drm_bufs.c                         |  236 +-
 drivers/gpu/drm/drm_context.c                      |   81 +-
 drivers/gpu/drm/drm_crtc.c                         |  173 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |   89 +-
 drivers/gpu/drm/drm_dma.c                          |   17 +-
 drivers/gpu/drm/drm_drv.c                          |  106 +-
 drivers/gpu/drm/drm_edid.c                         |  306 +-
 drivers/gpu/drm/drm_fb_cma_helper.c                |    5 +-
 drivers/gpu/drm/drm_flip_work.c                    |  124 +
 drivers/gpu/drm/drm_fops.c                         |   98 +-
 drivers/gpu/drm/drm_gem.c                          |  440 +-
 drivers/gpu/drm/drm_gem_cma_helper.c               |   26 +-
 drivers/gpu/drm/drm_info.c                         |    6 +-
 drivers/gpu/drm/drm_ioctl.c                        |   62 +-
 drivers/gpu/drm/drm_memory.c                       |    2 -
 drivers/gpu/drm/drm_mm.c                           |  229 +-
 drivers/gpu/drm/drm_modes.c                        |   58 -
 drivers/gpu/drm/drm_pci.c                          |   35 +-
 drivers/gpu/drm/drm_platform.c                     |   16 +-
 drivers/gpu/drm/drm_prime.c                        |  190 +-
 drivers/gpu/drm/drm_proc.c                         |  209 -
 drivers/gpu/drm/drm_scatter.c                      |   29 +-
 drivers/gpu/drm/drm_stub.c                         |   73 +-
 drivers/gpu/drm/drm_usb.c                          |    9 +
 drivers/gpu/drm/drm_vm.c                           |    3 +-
 drivers/gpu/drm/drm_vma_manager.c                  |  436 ++
 drivers/gpu/drm/exynos/Kconfig                     |    6 +-
 drivers/gpu/drm/exynos/exynos_ddc.c                |   13 +-
 drivers/gpu/drm/exynos/exynos_drm_buf.c            |    9 +-
 drivers/gpu/drm/exynos/exynos_drm_connector.c      |   38 +-
 drivers/gpu/drm/exynos/exynos_drm_crtc.c           |   10 +-
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c         |   37 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |   10 +-
 drivers/gpu/drm/exynos/exynos_drm_encoder.c        |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_fb.c             |    8 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |   20 +-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |    6 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  263 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   60 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |   53 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.h            |    9 -
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |    5 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c           |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_iommu.c          |    9 +
 drivers/gpu/drm/exynos/exynos_drm_ipp.c            |   22 +-
 drivers/gpu/drm/exynos/exynos_drm_plane.c          |    5 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |  117 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |    1 +
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   87 +-
 drivers/gpu/drm/exynos/exynos_hdmiphy.c            |   12 +-
 drivers/gpu/drm/exynos/exynos_mixer.c              |    9 +-
 drivers/gpu/drm/gma500/Makefile                    |    1 +
 drivers/gpu/drm/gma500/cdv_device.c                |    3 +
 drivers/gpu/drm/gma500/cdv_device.h                |   12 +-
 drivers/gpu/drm/gma500/cdv_intel_crt.c             |   57 +-
 drivers/gpu/drm/gma500/cdv_intel_display.c         |  920 +---
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |  154 +-
 drivers/gpu/drm/gma500/cdv_intel_hdmi.c            |   89 +-
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |   71 +-
 drivers/gpu/drm/gma500/framebuffer.c               |   31 +-
 drivers/gpu/drm/gma500/framebuffer.h               |    2 +-
 drivers/gpu/drm/gma500/gem.c                       |   39 +-
 drivers/gpu/drm/gma500/gma_display.c               |  776 +++
 drivers/gpu/drm/gma500/gma_display.h               |  103 +
 drivers/gpu/drm/gma500/gtt.c                       |   38 +-
 drivers/gpu/drm/gma500/mdfld_dsi_output.c          |   15 +-
 drivers/gpu/drm/gma500/mdfld_dsi_output.h          |   16 +-
 drivers/gpu/drm/gma500/mdfld_intel_display.c       |   65 +-
 drivers/gpu/drm/gma500/oaktrail_crtc.c             |   63 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |   43 +-
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |   48 +-
 drivers/gpu/drm/gma500/psb_device.c                |    3 +-
 .../gma500/{psb_intel_display.h => psb_device.h}   |   13 +-
 drivers/gpu/drm/gma500/psb_drv.c                   |   21 +-
 drivers/gpu/drm/gma500/psb_drv.h                   |    7 +-
 drivers/gpu/drm/gma500/psb_intel_display.c         |  944 +---
 drivers/gpu/drm/gma500/psb_intel_drv.h             |   44 +-
 drivers/gpu/drm/gma500/psb_intel_lvds.c            |   75 +-
 drivers/gpu/drm/gma500/psb_intel_sdvo.c            |   53 +-
 drivers/gpu/drm/i2c/tda998x_drv.c                  |  485 +-
 drivers/gpu/drm/i810/i810_dma.c                    |    3 +-
 drivers/gpu/drm/i810/i810_drv.c                    |    3 +-
 drivers/gpu/drm/i810/i810_drv.h                    |    2 +-
 drivers/gpu/drm/i915/Makefile                      |    2 +
 drivers/gpu/drm/i915/dvo_ch7xxx.c                  |    2 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |  986 ++--
 drivers/gpu/drm/i915/i915_dma.c                    |  141 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  322 +-
 drivers/gpu/drm/i915/i915_drv.h                    |  602 ++-
 drivers/gpu/drm/i915/i915_gem.c                    |  759 ++-
 drivers/gpu/drm/i915/i915_gem_context.c            |   34 +-
 drivers/gpu/drm/i915/i915_gem_debug.c              |   73 +-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c             |   41 +-
 drivers/gpu/drm/i915/i915_gem_evict.c              |   93 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  191 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  313 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c             |  208 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c             |   19 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              | 1019 ++++
 drivers/gpu/drm/i915/i915_irq.c                    | 1595 +++---
 drivers/gpu/drm/i915/i915_reg.h                    |  150 +-
 drivers/gpu/drm/i915/i915_sysfs.c                  |   71 +
 drivers/gpu/drm/i915/i915_trace.h                  |   45 +-
 drivers/gpu/drm/i915/intel_acpi.c                  |   14 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   38 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |   78 +-
 drivers/gpu/drm/i915/intel_display.c               | 1503 ++++--
 drivers/gpu/drm/i915/intel_dp.c                    |  518 +-
 drivers/gpu/drm/i915/intel_drv.h                   |  148 +-
 drivers/gpu/drm/i915/intel_dvo.c                   |   61 +-
 drivers/gpu/drm/i915/intel_fb.c                    |   23 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |  286 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |    2 +
 drivers/gpu/drm/i915/intel_lvds.c                  |   40 +-
 drivers/gpu/drm/i915/intel_overlay.c               |   24 +-
 drivers/gpu/drm/i915/intel_panel.c                 |    3 -
 drivers/gpu/drm/i915/intel_pm.c                    | 1155 ++---
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   79 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   16 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   94 +-
 drivers/gpu/drm/i915/intel_sprite.c                |   59 +-
 drivers/gpu/drm/i915/intel_tv.c                    |   31 +-
 drivers/gpu/drm/i915/intel_uncore.c                |  595 +++
 drivers/gpu/drm/mga/mga_drv.c                      |    3 +-
 drivers/gpu/drm/mga/mga_drv.h                      |    2 +-
 drivers/gpu/drm/mga/mga_state.c                    |    2 +-
 drivers/gpu/drm/mgag200/mgag200_drv.c              |    5 +-
 drivers/gpu/drm/mgag200/mgag200_drv.h              |    3 -
 drivers/gpu/drm/mgag200/mgag200_main.c             |    9 +-
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |    5 +-
 drivers/gpu/drm/msm/Kconfig                        |   34 +
 drivers/gpu/drm/msm/Makefile                       |   30 +
 drivers/gpu/drm/msm/NOTES                          |   69 +
 drivers/gpu/drm/msm/adreno/a2xx.xml.h              | 1438 ++++++
 drivers/gpu/drm/msm/adreno/a3xx.xml.h              | 2193 ++++++++
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |  502 ++
 drivers/gpu/drm/msm/adreno/a3xx_gpu.h              |   30 +
 drivers/gpu/drm/msm/adreno/adreno_common.xml.h     |  432 ++
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |  370 ++
 drivers/gpu/drm/msm/adreno/adreno_gpu.h            |  141 +
 drivers/gpu/drm/msm/adreno/adreno_pm4.xml.h        |  254 +
 drivers/gpu/drm/msm/dsi/dsi.xml.h                  |  502 ++
 drivers/gpu/drm/msm/dsi/mmss_cc.xml.h              |  114 +
 drivers/gpu/drm/msm/dsi/sfpb.xml.h                 |   48 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |  272 +
 drivers/gpu/drm/msm/hdmi/hdmi.h                    |  131 +
 drivers/gpu/drm/msm/hdmi/hdmi.xml.h                |  508 ++
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c             |  167 +
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c          |  367 ++
 drivers/gpu/drm/msm/hdmi/hdmi_i2c.c                |  281 ++
 drivers/gpu/drm/msm/hdmi/hdmi_phy_8960.c           |  141 +
 drivers/gpu/drm/msm/hdmi/hdmi_phy_8x60.c           |  214 +
 drivers/gpu/drm/msm/hdmi/qfprom.xml.h              |   50 +
 drivers/gpu/drm/msm/mdp4/mdp4.xml.h                | 1061 ++++
 drivers/gpu/drm/msm/mdp4/mdp4_crtc.c               |  685 +++
 drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c        |  305 ++
 drivers/gpu/drm/msm/mdp4/mdp4_format.c             |   56 +
 drivers/gpu/drm/msm/mdp4/mdp4_irq.c                |  203 +
 drivers/gpu/drm/msm/mdp4/mdp4_kms.c                |  365 ++
 drivers/gpu/drm/msm/mdp4/mdp4_kms.h                |  194 +
 drivers/gpu/drm/msm/mdp4/mdp4_plane.c              |  243 +
 drivers/gpu/drm/msm/msm_drv.c                      |  776 +++
 drivers/gpu/drm/msm/msm_drv.h                      |  213 +
 drivers/gpu/drm/msm/msm_fb.c                       |  202 +
 drivers/gpu/drm/msm/msm_fbdev.c                    |  258 +
 drivers/gpu/drm/msm/msm_gem.c                      |  597 +++
 drivers/gpu/drm/msm/msm_gem.h                      |   99 +
 drivers/gpu/drm/msm/msm_gem_submit.c               |  412 ++
 drivers/gpu/drm/msm/msm_gpu.c                      |  463 ++
 drivers/gpu/drm/msm/msm_gpu.h                      |  124 +
 drivers/gpu/drm/msm/msm_ringbuffer.c               |   61 +
 drivers/gpu/drm/msm/msm_ringbuffer.h               |   43 +
 drivers/gpu/drm/nouveau/core/core/printk.c         |   19 +
 drivers/gpu/drm/nouveau/core/core/ramht.c          |    3 +-
 drivers/gpu/drm/nouveau/core/engine/bsp/nv98.c     |   52 +-
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |   15 +-
 drivers/gpu/drm/nouveau/core/engine/disp/dport.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |   34 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv50.c    |    3 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv84.c    |    5 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c    |    3 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |    3 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv40.h   |    3 +
 drivers/gpu/drm/nouveau/core/engine/ppp/nv98.c     |   52 +-
 drivers/gpu/drm/nouveau/core/engine/vp/nv98.c      |   47 +-
 drivers/gpu/drm/nouveau/core/include/core/math.h   |   16 -
 drivers/gpu/drm/nouveau/core/include/core/printk.h |   13 +
 drivers/gpu/drm/nouveau/core/include/subdev/i2c.h  |    8 +-
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h   |    1 +
 .../gpu/drm/nouveau/core/include/subdev/timer.h    |    2 +
 drivers/gpu/drm/nouveau/core/os.h                  |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/therm.c   |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/anx9805.c  |   10 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c     |    2 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv04.c     |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv4e.c     |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv50.c     |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv94.c     |    8 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nvd0.c     |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c |   10 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c      |   28 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c      |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/base.c   |   19 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c    |   20 +
 drivers/gpu/drm/nouveau/core/subdev/therm/priv.h   |    4 +
 drivers/gpu/drm/nouveau/core/subdev/therm/temp.c   |   21 +
 drivers/gpu/drm/nouveau/core/subdev/timer/base.c   |    7 +
 drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c   |   35 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/nv50.c      |    1 +
 drivers/gpu/drm/nouveau/dispnv04/crtc.c            |   49 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |   42 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |    4 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   27 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |   29 +-
 drivers/gpu/drm/nouveau/nouveau_display.h          |    7 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  284 +-
 drivers/gpu/drm/nouveau/nouveau_drm.h              |    9 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   29 +-
 drivers/gpu/drm/nouveau/nouveau_ioc32.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_ioctl.h            |    1 +
 drivers/gpu/drm/nouveau/nouveau_vga.c              |   14 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |    4 +-
 drivers/gpu/drm/omapdrm/Makefile                   |    3 -
 drivers/gpu/drm/omapdrm/omap_crtc.c                |    3 +-
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c           |    2 +-
 drivers/gpu/drm/omapdrm/omap_drv.c                 |   12 +-
 drivers/gpu/drm/omapdrm/omap_drv.h                 |    7 +-
 drivers/gpu/drm/omapdrm/omap_fb.c                  |   74 +-
 drivers/gpu/drm/omapdrm/omap_gem.c                 |   52 +-
 drivers/gpu/drm/omapdrm/omap_gem_helpers.c         |  169 -
 drivers/gpu/drm/omapdrm/omap_plane.c               |   51 +-
 drivers/gpu/drm/qxl/qxl_drv.c                      |    3 +-
 drivers/gpu/drm/qxl/qxl_drv.h                      |    8 +-
 drivers/gpu/drm/qxl/qxl_dumb.c                     |    7 -
 drivers/gpu/drm/qxl/qxl_gem.c                      |   26 -
 drivers/gpu/drm/qxl/qxl_ioctl.c                    |    2 +-
 drivers/gpu/drm/qxl/qxl_object.c                   |    1 -
 drivers/gpu/drm/qxl/qxl_object.h                   |    2 +-
 drivers/gpu/drm/qxl/qxl_release.c                  |    2 +-
 drivers/gpu/drm/qxl/qxl_ttm.c                      |    4 +-
 drivers/gpu/drm/r128/r128_cce.c                    |    2 +-
 drivers/gpu/drm/r128/r128_drv.c                    |    3 +-
 drivers/gpu/drm/r128/r128_drv.h                    |    2 +-
 drivers/gpu/drm/r128/r128_state.c                  |    2 +-
 drivers/gpu/drm/radeon/Makefile                    |   24 +-
 drivers/gpu/drm/radeon/atombios.h                  |  615 +--
 drivers/gpu/drm/radeon/atombios_crtc.c             |    6 +
 drivers/gpu/drm/radeon/atombios_dp.c               |    8 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   11 +-
 drivers/gpu/drm/radeon/atombios_i2c.c              |   16 +-
 drivers/gpu/drm/radeon/btc_dpm.c                   |    6 +
 drivers/gpu/drm/radeon/cayman_blit_shaders.c       |   54 -
 drivers/gpu/drm/radeon/ci_dpm.c                    | 5243 ++++++++++++++++++++
 drivers/gpu/drm/radeon/ci_dpm.h                    |  332 ++
 drivers/gpu/drm/radeon/ci_smc.c                    |  262 +
 drivers/gpu/drm/radeon/cik.c                       | 4395 ++++++++++------
 drivers/gpu/drm/radeon/cik_reg.h                   |    3 +
 drivers/gpu/drm/radeon/cik_sdma.c                  |  785 +++
 drivers/gpu/drm/radeon/cikd.h                      |  594 ++-
 drivers/gpu/drm/radeon/clearstate_cayman.h         |    2 +-
 drivers/gpu/drm/radeon/clearstate_ci.h             |  944 ++++
 drivers/gpu/drm/radeon/clearstate_evergreen.h      |    2 +-
 drivers/gpu/drm/radeon/cypress_dpm.c               |    3 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                 |  278 ++
 drivers/gpu/drm/radeon/evergreen.c                 |  536 +-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c        |  729 ---
 drivers/gpu/drm/radeon/evergreen_blit_shaders.c    |   54 -
 drivers/gpu/drm/radeon/evergreen_dma.c             |  190 +
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |  100 +-
 drivers/gpu/drm/radeon/evergreend.h                |   11 +
 drivers/gpu/drm/radeon/kv_dpm.c                    | 2645 ++++++++++
 drivers/gpu/drm/radeon/kv_dpm.h                    |  199 +
 drivers/gpu/drm/radeon/kv_smc.c                    |  207 +
 drivers/gpu/drm/radeon/ni.c                        |  373 +-
 drivers/gpu/drm/radeon/ni_dma.c                    |  338 ++
 drivers/gpu/drm/radeon/ni_dpm.c                    |   14 +-
 drivers/gpu/drm/radeon/ppsmc.h                     |   57 +
 drivers/gpu/drm/radeon/pptable.h                   |  682 +++
 drivers/gpu/drm/radeon/r100.c                      |    4 +-
 drivers/gpu/drm/radeon/r600.c                      |  811 +--
 drivers/gpu/drm/radeon/r600_audio.c                |   60 +-
 drivers/gpu/drm/radeon/r600_blit.c                 |   31 +
 drivers/gpu/drm/radeon/r600_blit_kms.c             |  785 ---
 drivers/gpu/drm/radeon/r600_blit_shaders.h         |    1 -
 drivers/gpu/drm/radeon/r600_cp.c                   |    6 +-
 drivers/gpu/drm/radeon/r600_dma.c                  |  497 ++
 drivers/gpu/drm/radeon/r600_dpm.c                  |  300 +-
 drivers/gpu/drm/radeon/r600_dpm.h                  |    6 +
 drivers/gpu/drm/radeon/r600_hdmi.c                 |  113 +-
 drivers/gpu/drm/radeon/r600d.h                     |   36 +
 drivers/gpu/drm/radeon/radeon.h                    |  275 +-
 drivers/gpu/drm/radeon/radeon_asic.c               | 1262 ++---
 drivers/gpu/drm/radeon/radeon_asic.h               |  119 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |  186 +-
 drivers/gpu/drm/radeon/radeon_blit_common.h        |   44 -
 drivers/gpu/drm/radeon/radeon_cp.c                 |    6 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   13 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   24 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   67 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   26 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |    7 -
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |   10 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   50 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |    3 +-
 drivers/gpu/drm/radeon/radeon_object.c             |    1 -
 drivers/gpu/drm/radeon/radeon_object.h             |    5 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |   88 +-
 drivers/gpu/drm/radeon/radeon_prime.c              |    1 -
 drivers/gpu/drm/radeon/radeon_ring.c               |   13 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |    4 +-
 drivers/gpu/drm/radeon/radeon_ucode.h              |   17 +
 drivers/gpu/drm/radeon/radeon_uvd.c                |   58 +-
 drivers/gpu/drm/radeon/rs400.c                     |    9 +-
 drivers/gpu/drm/radeon/rv6xx_dpm.c                 |    5 +-
 drivers/gpu/drm/radeon/rv770.c                     |  204 +-
 drivers/gpu/drm/radeon/rv770_dma.c                 |  101 +
 drivers/gpu/drm/radeon/rv770_dpm.c                 |   15 +-
 drivers/gpu/drm/radeon/rv770d.h                    |   16 +
 drivers/gpu/drm/radeon/si.c                        |  844 ++--
 drivers/gpu/drm/radeon/si_dma.c                    |  235 +
 drivers/gpu/drm/radeon/si_dpm.c                    |   80 +-
 drivers/gpu/drm/radeon/sid.h                       |   71 +
 drivers/gpu/drm/radeon/smu7.h                      |  170 +
 drivers/gpu/drm/radeon/smu7_discrete.h             |  486 ++
 drivers/gpu/drm/radeon/smu7_fusion.h               |  300 ++
 drivers/gpu/drm/radeon/sumo_dpm.c                  |   22 +-
 drivers/gpu/drm/radeon/sumo_dpm.h                  |    3 +
 drivers/gpu/drm/radeon/trinity_dpm.c               |    7 +-
 drivers/gpu/drm/radeon/uvd_v1_0.c                  |  436 ++
 drivers/gpu/drm/radeon/uvd_v2_2.c                  |  165 +
 drivers/gpu/drm/radeon/uvd_v3_1.c                  |   55 +
 drivers/gpu/drm/radeon/uvd_v4_2.c                  |   68 +
 drivers/gpu/drm/rcar-du/Kconfig                    |    7 +
 drivers/gpu/drm/rcar-du/Makefile                   |   10 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |  258 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h             |   13 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.c              |  176 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.h              |   63 +-
 drivers/gpu/drm/rcar-du/rcar_du_encoder.c          |  202 +
 drivers/gpu/drm/rcar-du/rcar_du_encoder.h          |   49 +
 drivers/gpu/drm/rcar-du/rcar_du_group.c            |  187 +
 drivers/gpu/drm/rcar-du/rcar_du_group.h            |   50 +
 drivers/gpu/drm/rcar-du/rcar_du_kms.c              |  165 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.h              |   29 +-
 .../rcar-du/{rcar_du_lvds.c => rcar_du_lvdscon.c}  |  101 +-
 .../rcar-du/{rcar_du_lvds.h => rcar_du_lvdscon.h}  |   17 +-
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c          |  196 +
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.h          |   46 +
 drivers/gpu/drm/rcar-du/rcar_du_plane.c            |  170 +-
 drivers/gpu/drm/rcar-du/rcar_du_plane.h            |   26 +-
 drivers/gpu/drm/rcar-du/rcar_du_regs.h             |   94 +-
 .../rcar-du/{rcar_du_vga.c => rcar_du_vgacon.c}    |   65 +-
 .../rcar-du/{rcar_du_vga.h => rcar_du_vgacon.h}    |   15 +-
 drivers/gpu/drm/rcar-du/rcar_lvds_regs.h           |   69 +
 drivers/gpu/drm/savage/savage_bci.c                |    2 +-
 drivers/gpu/drm/savage/savage_drv.c                |    3 +-
 drivers/gpu/drm/savage/savage_drv.h                |    2 +-
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c          |    3 +-
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |    3 +-
 drivers/gpu/drm/sis/sis_drv.c                      |    3 +-
 drivers/gpu/drm/sis/sis_drv.h                      |    2 +-
 drivers/gpu/drm/sis/sis_mm.c                       |    8 +-
 drivers/gpu/drm/tdfx/tdfx_drv.c                    |    2 -
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c               |   43 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |    3 +-
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              |   27 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |  102 +-
 drivers/gpu/drm/ttm/ttm_bo_manager.c               |   41 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    3 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |  231 +-
 drivers/gpu/drm/udl/udl_drv.c                      |    3 +-
 drivers/gpu/drm/udl/udl_drv.h                      |    2 -
 drivers/gpu/drm/udl/udl_gem.c                      |   63 +-
 drivers/gpu/drm/udl/udl_main.c                     |    4 +-
 drivers/gpu/drm/via/via_dma.c                      |    2 +-
 drivers/gpu/drm/via/via_drv.c                      |    3 +-
 drivers/gpu/drm/via/via_drv.h                      |    2 +-
 drivers/gpu/drm/via/via_mm.c                       |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   28 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |    1 -
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |    3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h                |    3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |    4 +-
 drivers/gpu/host1x/dev.c                           |    2 +-
 drivers/gpu/host1x/dev.h                           |    2 +-
 drivers/gpu/host1x/drm/dc.c                        |    2 +-
 drivers/gpu/host1x/drm/drm.c                       |    7 +-
 drivers/gpu/host1x/drm/gem.c                       |   16 +-
 drivers/gpu/host1x/drm/gem.h                       |    3 -
 drivers/gpu/host1x/drm/hdmi.c                      |   27 +-
 drivers/gpu/host1x/drm/rgb.c                       |   14 +-
 drivers/gpu/host1x/job.c                           |   15 +-
 drivers/gpu/vga/vga_switcheroo.c                   |  147 +-
 drivers/staging/imx-drm/imx-drm-core.c             |   25 +-
 drivers/staging/imx-drm/ipuv3-crtc.c               |    3 +-
 drivers/video/hdmi.c                               |  141 +-
 include/drm/drmP.h                                 |  254 +-
 include/drm/drm_agpsupport.h                       |  194 +
 include/drm/drm_crtc.h                             |   85 +-
 include/drm/drm_dp_helper.h                        |   31 +-
 include/drm/drm_edid.h                             |    5 +
 include/drm/drm_fb_cma_helper.h                    |    1 -
 include/drm/drm_flip_work.h                        |   76 +
 include/drm/drm_gem_cma_helper.h                   |    8 -
 include/drm/drm_mm.h                               |  142 +-
 include/drm/drm_pciids.h                           |   48 +-
 include/drm/drm_vma_manager.h                      |  257 +
 include/drm/exynos_drm.h                           |    3 +-
 include/drm/i2c/tda998x.h                          |   30 +
 include/drm/ttm/ttm_bo_api.h                       |   15 +-
 include/drm/ttm/ttm_bo_driver.h                    |   10 +-
 include/linux/hdmi.h                               |   53 +-
 include/linux/platform_data/rcar-du.h              |   34 +-
 include/linux/vga_switcheroo.h                     |   13 +-
 include/uapi/drm/Kbuild                            |    1 +
 include/uapi/drm/drm.h                             |    3 +-
 include/uapi/drm/drm_mode.h                        |   16 +-
 include/uapi/drm/i915_drm.h                        |   49 +
 include/uapi/drm/msm_drm.h                         |  207 +
 include/uapi/drm/radeon_drm.h                      |    2 +
 sound/pci/hda/hda_intel.c                          |   36 +-
 435 files changed, 50563 insertions(+), 17837 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpu/samsung-rotator.txt
 create mode 100644 drivers/gpu/drm/drm_flip_work.c
 delete mode 100644 drivers/gpu/drm/drm_proc.c
 create mode 100644 drivers/gpu/drm/drm_vma_manager.c
 create mode 100644 drivers/gpu/drm/gma500/gma_display.c
 create mode 100644 drivers/gpu/drm/gma500/gma_display.h
 rename drivers/gpu/drm/gma500/{psb_intel_display.h => psb_device.h} (76%)
 create mode 100644 drivers/gpu/drm/i915/i915_gpu_error.c
 create mode 100644 drivers/gpu/drm/i915/intel_uncore.c
 create mode 100644 drivers/gpu/drm/msm/Kconfig
 create mode 100644 drivers/gpu/drm/msm/Makefile
 create mode 100644 drivers/gpu/drm/msm/NOTES
 create mode 100644 drivers/gpu/drm/msm/adreno/a2xx.xml.h
 create mode 100644 drivers/gpu/drm/msm/adreno/a3xx.xml.h
 create mode 100644 drivers/gpu/drm/msm/adreno/a3xx_gpu.c
 create mode 100644 drivers/gpu/drm/msm/adreno/a3xx_gpu.h
 create mode 100644 drivers/gpu/drm/msm/adreno/adreno_common.xml.h
 create mode 100644 drivers/gpu/drm/msm/adreno/adreno_gpu.c
 create mode 100644 drivers/gpu/drm/msm/adreno/adreno_gpu.h
 create mode 100644 drivers/gpu/drm/msm/adreno/adreno_pm4.xml.h
 create mode 100644 drivers/gpu/drm/msm/dsi/dsi.xml.h
 create mode 100644 drivers/gpu/drm/msm/dsi/mmss_cc.xml.h
 create mode 100644 drivers/gpu/drm/msm/dsi/sfpb.xml.h
 create mode 100644 drivers/gpu/drm/msm/hdmi/hdmi.c
 create mode 100644 drivers/gpu/drm/msm/hdmi/hdmi.h
 create mode 100644 drivers/gpu/drm/msm/hdmi/hdmi.xml.h
 create mode 100644 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
 create mode 100644 drivers/gpu/drm/msm/hdmi/hdmi_connector.c
 create mode 100644 drivers/gpu/drm/msm/hdmi/hdmi_i2c.c
 create mode 100644 drivers/gpu/drm/msm/hdmi/hdmi_phy_8960.c
 create mode 100644 drivers/gpu/drm/msm/hdmi/hdmi_phy_8x60.c
 create mode 100644 drivers/gpu/drm/msm/hdmi/qfprom.xml.h
 create mode 100644 drivers/gpu/drm/msm/mdp4/mdp4.xml.h
 create mode 100644 drivers/gpu/drm/msm/mdp4/mdp4_crtc.c
 create mode 100644 drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c
 create mode 100644 drivers/gpu/drm/msm/mdp4/mdp4_format.c
 create mode 100644 drivers/gpu/drm/msm/mdp4/mdp4_irq.c
 create mode 100644 drivers/gpu/drm/msm/mdp4/mdp4_kms.c
 create mode 100644 drivers/gpu/drm/msm/mdp4/mdp4_kms.h
 create mode 100644 drivers/gpu/drm/msm/mdp4/mdp4_plane.c
 create mode 100644 drivers/gpu/drm/msm/msm_drv.c
 create mode 100644 drivers/gpu/drm/msm/msm_drv.h
 create mode 100644 drivers/gpu/drm/msm/msm_fb.c
 create mode 100644 drivers/gpu/drm/msm/msm_fbdev.c
 create mode 100644 drivers/gpu/drm/msm/msm_gem.c
 create mode 100644 drivers/gpu/drm/msm/msm_gem.h
 create mode 100644 drivers/gpu/drm/msm/msm_gem_submit.c
 create mode 100644 drivers/gpu/drm/msm/msm_gpu.c
 create mode 100644 drivers/gpu/drm/msm/msm_gpu.h
 create mode 100644 drivers/gpu/drm/msm/msm_ringbuffer.c
 create mode 100644 drivers/gpu/drm/msm/msm_ringbuffer.h
 delete mode 100644 drivers/gpu/drm/nouveau/core/include/core/math.h
 delete mode 100644 drivers/gpu/drm/omapdrm/omap_gem_helpers.c
 create mode 100644 drivers/gpu/drm/radeon/ci_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/ci_dpm.h
 create mode 100644 drivers/gpu/drm/radeon/ci_smc.c
 create mode 100644 drivers/gpu/drm/radeon/cik_sdma.c
 create mode 100644 drivers/gpu/drm/radeon/clearstate_ci.h
 create mode 100644 drivers/gpu/drm/radeon/dce6_afmt.c
 delete mode 100644 drivers/gpu/drm/radeon/evergreen_blit_kms.c
 create mode 100644 drivers/gpu/drm/radeon/evergreen_dma.c
 create mode 100644 drivers/gpu/drm/radeon/kv_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/kv_dpm.h
 create mode 100644 drivers/gpu/drm/radeon/kv_smc.c
 create mode 100644 drivers/gpu/drm/radeon/ni_dma.c
 create mode 100644 drivers/gpu/drm/radeon/pptable.h
 delete mode 100644 drivers/gpu/drm/radeon/r600_blit_kms.c
 create mode 100644 drivers/gpu/drm/radeon/r600_dma.c
 delete mode 100644 drivers/gpu/drm/radeon/radeon_blit_common.h
 create mode 100644 drivers/gpu/drm/radeon/rv770_dma.c
 create mode 100644 drivers/gpu/drm/radeon/si_dma.c
 create mode 100644 drivers/gpu/drm/radeon/smu7.h
 create mode 100644 drivers/gpu/drm/radeon/smu7_discrete.h
 create mode 100644 drivers/gpu/drm/radeon/smu7_fusion.h
 create mode 100644 drivers/gpu/drm/radeon/uvd_v1_0.c
 create mode 100644 drivers/gpu/drm/radeon/uvd_v2_2.c
 create mode 100644 drivers/gpu/drm/radeon/uvd_v3_1.c
 create mode 100644 drivers/gpu/drm/radeon/uvd_v4_2.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_encoder.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_encoder.h
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_group.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_group.h
 rename drivers/gpu/drm/rcar-du/{rcar_du_lvds.c => rcar_du_lvdscon.c} (57%)
 rename drivers/gpu/drm/rcar-du/{rcar_du_lvds.h => rcar_du_lvdscon.h} (53%)
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.h
 rename drivers/gpu/drm/rcar-du/{rcar_du_vga.c => rcar_du_vgacon.c} (59%)
 rename drivers/gpu/drm/rcar-du/{rcar_du_vga.h => rcar_du_vgacon.h} (56%)
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_lvds_regs.h
 create mode 100644 include/drm/drm_agpsupport.h
 create mode 100644 include/drm/drm_flip_work.h
 create mode 100644 include/drm/drm_vma_manager.h
 create mode 100644 include/drm/i2c/tda998x.h
 create mode 100644 include/uapi/drm/msm_drm.h
--29444707-1633344914-1378377664=:25450--
