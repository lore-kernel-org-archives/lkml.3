Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaLOHRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:17:41 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34123 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaLOHRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:17:38 -0500
Date: Mon, 15 Dec 2014 07:17:31 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm for 3.19-rc1
Message-ID: <alpine.DEB.2.00.1412150715300.27943@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-2071675850-1418627851=:27943"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-2071675850-1418627851=:27943
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

This is the main drm pull, as explained this was queued behind arm soc and iommu, the diffstat seems confused which worries me always, but I've git pull'ed
this tree into yours and gotten a minor conflict in mm/hugetlb.c, which is easily solved. The -mm changes from the AMD HSA driver merge, all should be signed
off properly.

The rockchip iommu and some shmobile commits are in the stat below, but really shouldn't be, and I've pull the trees that I was told were stable, so hopefully its just git and not rebases.

more info below,

Dave.

highlights:
AMD KFD driver merge - this is the AMD HSA interface for exposing a lowlevel
interface for GPGPU use. They have an open source userspace built on top of
this interface, and the code looks as good as it was going to get out of tree.

Initial atomic work, the need for an atomic modesetting interface to allow
userspace to try and send a complete set of modesetting state to the driver
has arisen, and been suffering from neglect this past year. No more, the
start of the common code and changes for msm driver to use it are in this
tree. Ongoing work to get the userspace ioctl finished and the code clean
will probably wait until next kernel.

DisplayID 1.3 and tiled monitor exposed to userspace. Tiled monitor property
is now exposed for userspace to make use of.

Rockchip drm driver merged.

imx gpu driver moved out of staging

Other stuff:
core:
	panel - MIPI DSI + new panels.
	expose suggested x/y properties for virtual GPUs
i915:
	Initial Skylake (SKL) support
	gen3/4 reset work
	start of dri1/ums removal
	infoframe tracking
	fixes for lots of things.
nouveau:
	tegra k1 voltage support
	GM204 modesetting support
	GT21x memory reclocking work
radeon:
	CI dpm fixes
	GPUVM improvements
	Initial DPM fan control
rcar-du:
	HDMI support added
	removed some support for old boards
	slave encoder driver for Analog Devices adv7511
exynos:
	Exynos4415 SoC support
msm:
	a4xx gpu support
	atomic helper conversion
tegra:
	iommu support
	universal plane support
	ganged-mode DSI support
sti:	
	HDMI i2c improvements
vmwgfx:
	some late fixes.
qxl:
	use suggested x/y properties

The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d71d:

  Linux 3.18 (2014-12-07 14:21:05 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to 4e0cd68115620bc3236ff4e58e4c073948629b41:

  drm: sti: fix module compilation issue (2014-12-15 17:07:57 +1000)

----------------------------------------------------------------
Ajay Kumar (1):
      drm/panel: simple: Add AUO B116XW03 panel support

Akash Goel (1):
      drm/i915/skl: Update in Gen9 multi-engine forcewake range

Alex Deucher (33):
      drm/radeon/dpm: grab fan info from vbios
      drm/radeon: rework SI dpm thermal setup
      drm/radeon: rework CI dpm thermal setup
      drm/radeon: fix typo in CI dpm disable
      drm/radeon: export radeon_atombios_lookup_gpio
      drm/radeon: store the gpio shift as well
      drm/radeon/ci: handle gpio controlled dpm features properly
      drm/radeon: fix for memory training on bonaire 0x6649
      drm/radeon: switch force state commands for CI
      drm/radeon: fix dram timing for certain hawaii boards
      drm/radeon: improve mclk param calcuations for ci dpm
      drm/radeon: fix activity settings for sclk and mclk for CI
      drm/radeon: fix sclk DS enablement
      drm/radeon: fix mclk vddc configuration for cards for hawaii
      drm/radeon: workaround a hw bug in bonaire pcie dpm
      drm/radeon: fix default dpm state setup
      drm/radeon: set bootup pcie level to max for ci dpm
      drm/radeon: fix dpm mc init for certain hawaii boards
      drm/radeon: powertune fixes for hawaii
      drm/radeon: set power control in ci dpm enable
      drm/radeon: work around a hw bug in MGCG on CIK
      drm/radeon/dpm: add smc fan control for SI (v2)
      drm/radeon/dpm: add smc fan control for CI (v2)
      drm/radeon/dpm: add thermal dpm support for CI
      drm/radeon: fix PCC debugging message for CI DPM
      drm/radeon/ci: apply disp voltage changes before clk changes
      drm/radeon/ci: use different smc command for pcie dpm
      drm/radeon/ci: force pcie level before sclk and mclk
      drm/radeon/ci: disable needless sclk changes
      drm/radeon: fix typo in new fan control registers for SI/CI
      drm/radeon: fix copy paste typos in fan control for si/ci
      drm/radeon: check the right ring in radeon_evict_flags()
      drm/radeon: enable smc fan control on CI

Alexandre Courbot (9):
      drm/panel: ld9040: Update calls to gpiod_get*()
      drm/panel: s6e8aa0: Update calls to gpiod_get*()
      drm/panel: simple: Update calls to gpiod_get*()
      drm/nouveau: warn when moving a pinned object
      drm/nouveau: introduce nv_device_is_cpu_coherent()
      drm/nouveau: implement explicitly coherent BOs
      drm/nouveau: allocate GPFIFOs and fences coherently
      drm/nouveau: synchronize BOs when required
      drm/gk20a/clk: fix max VCO value

Alexey Khoroshilov (1):
      drm/i915: avoid deadlock on failure paths in __intel_framebuffer_create()

Alexey Skidanov (2):
      amdkfd: Implement the Get Process Aperture IOCTL
      amdkfd: Instead of using get function, use container_of

Ander Conselvan de Oliveira (19):
      drm/i915: Replace some loop through encoders with intel_pipe_has_type()
      drm/i915: Make *_find_best_dpll() take an intel_crtc insted of drm_crtc
      drm/i915: Make *_crtc_mode_set() take an intel_crtc insted of drm_crtc
      drm/i915: Make intel_pipe_has_type() and some callers take intel_crtc
      drm/i915: Make *_crtc_mode_set work on new_config
      drm/i915: Convert shared dpll reference count to a crtc mask
      drm/i915: Move dpll crtc_mask and hw_state fields into separate struct
      drm/i915: Add infrastructure for choosing DPLLs before disabling crtcs
      drm/i915: Covert HSW+ to choose DPLLS before disabling CRTCs
      drm/i915: Covert ILK-IVB to choose DPLLS before disabling CRTCs
      drm/i915: Covert remaining platforms to choose DPLLS before disabling CRTCs
      drm/i915: Remove crtc_mode_set() hook
      drm/i915: Don't store current shared DPLL in the new pipe_config
      drm/i915: Add kerneldoc for intel_pipe_update_{start, end}
      drm/i915: Remove modeset lock check from intel_pipe_update_start()
      drm/i915: Use vblank evade mechanism in mmio_flip
      drm/i915: Make __wait_seqno non-static and rename to __i915_wait_seqno
      drm/i915: Make mmio flip wait for seqno in the work function
      drm/i915: Plug memory leak in intel_shared_dpll_start_config()

Andrew Lewycky (2):
      amdkfd: Add interrupt handling module
      amdkfd: Implement the Set Memory Policy IOCTL

Andrzej Hajda (19):
      drm/exynos: remove ifdeferry from initialization code
      drm/exynos: dsi: remove global variable exynos_dsi_display
      drm/exynos: dsi: simplify device pointer evaluation
      drm/exynos: dsi: remove redundant encoder field
      drm/exynos: dsi: stop using display->ctx pointer
      drm/exynos/mixer: embed manager into private context
      drm/exynos/mixer: stop using manager->ctx pointer
      drm/exynos/vidi: embed manager into private context
      drm/exynos/vidi: stop using manager->ctx pointer
      drm/exynos/fimd: embed manager into private context
      drm/exynos/fimd: stop using manager->ctx pointer
      drm/exynos/hdmi: embed display into private context
      drm/exynos/hdmi: stop using display->ctx pointer
      drm/exynos/vidi: embed display into private context
      drm/exynos/vidi: stop using display->ctx pointer
      drm/exynos/dp: embed display into private context
      drm/exynos/dp: stop using display->ctx pointer
      drm/exynos/dpi: embed display into private context
      drm/exynos/dpi: stop using display->ctx pointer

Aravind Ganesan (2):
      drm/msm: Handle register offset differences between a3xx and a4xx
      drm/msm: a4xx support for msm-drm

Armin Reese (2):
      drm/i915 Update Gen8 golden context batch buffer
      drm/i915 Add golden context support for Gen9

Arun Siluvery (4):
      drm/i915: Emit even number of dwords when emitting LRIs
      drm/i915/chv: Remove pre-production workarounds
      drm/i915/chv: Combine GEN8_ROW_CHICKEN w/a
      drm/i915/chv: Add new workarounds for chv

Ben Goz (7):
      amdkfd: Add queue module
      amdkfd: Add mqd_manager module
      amdkfd: Add kernel queue module
      amdkfd: Add module parameter of scheduling policy
      amdkfd: Add packet manager module
      amdkfd: Add process queue manager module
      amdkfd: Add device queue manager module

Ben Skeggs (54):
      drm/nouveau: a, somehow, missed hunk of "fix regression on agp boards"
      drm/nouveau/bios: fix thinko when parsing extdev table
      drm/nouveau/bios: split out shadow methods
      drm/nouveau/bios: add pci data structure parsing
      drm/nouveau/bios: use size/type from pci data structure
      drm/nouveau/bios: fetch images beyond the first one in the rom
      drm/nouveau/bios: add NPDE parsing
      drm/nouveau/bios: use NPDE to locate images beyond those defined by PCIR
      drm/nouveau/bios: recognise nv-specific rom/pcir signatures
      drm/nouveau/bios: add parsing of pmu image tables
      drm/nouveau/devinit: allow impl to select its own cold-boot method
      drm/gm204/devinit: initial implementation
      drm/nouveau/bios: log if auxch accesses fail, also return 0x00 from rd when it does
      drm/nv50-/i2c: kill some unused struct members
      drm/nouveau/bios: store aux addr independently of i2c
      drm/nouveau/i2c: segregate aux channel adapter indices from bit-banged i2c
      drm/gm204/i2c: add pad driver
      drm/gm204/i2c: add aux channel driver
      drm/nouveau/bios: add support for dcb 4.1
      drm/nouveau/bios: add support for ccb 4.1
      drm/nouveau/i2c: add support for DCB_I2C_PMGR port type
      drm/nouveau/bios: add support for dp 4.1
      drm/nouveau/bios: add support for udisp 2.2
      drm/nouveau/bios: support for opcodes 0x47/0x48
      drm/gf110-/disp: magic that might help some tmds issues
      drm/gm204/disp: initial support
      drm/gm204/disp: some magic that fixes bringup of uninitialised outputs
      drm/nouveau/device: recognise GM204
      drm/nouveau: add support for gm204
      drm/nouveau/bios: add some more signatures as seen on my gtx660
      drm/nouveau/bios: stop after NV+NPDS+ISBN image
      drm/gk104-/fifo: handle copy engine class errors
      drm/nouveau: move the (far too many...) different s/r paths to the same place
      drm/nouveau/core: remove some dead code that got forgotten
      drm/nv50-/disp: rename class members to match nvidia channel names
      drm/nouveau/disp: clear notify intr status when enabling, to prevent races
      drm/nouveau: fix pin refcnt leak in failure path
      drm/nv50/kms: remove a couple of cursor-related stub functions
      drm/nv50/kms: use sclass() instead of trial-and-error
      drm/nv50-/kms: add some evo tracing ability for debugging
      drm/nouveau: we need pin_refcnt for nouveau_bo_placement_set()
      drm/nouveau/core: add some forgotten subdevs to disable mask
      drm/nouveau/device: store revision
      drm/nouveau/lib: add null backend
      drm/nouveau/core: allow vbios parsing without knowing chipset type
      drm/nouveau/bios: add parsing of BIT M(v2) +0x03 table
      drm/nouveau/fb: make use of M0203 routines for ram type determination
      drm/nouveau/bios: translate ramcfg strap through M0203
      drm/nouveau/devinit: bump priv ring timeouts before executing scripts
      drm/gf100-/gr: return non-fatal error code when fw not present
      drm/nouveau: teach nouveau_bo_pin() how to force a contig vram allocation
      drm/nouveau/kms: when pinning display-related buffers, force contig vram
      drm/nv50/kms: directly use cursor image from userspace buffer
      drm/nv50/kms: drop requirement that framebuffer bos be contig up-front

Benjamin Gaignard (13):
      drm: sti: allow to change hdmi ddc i2c adapter
      drm: sti: remove gpio for HDMI hot plug detection
      drm: sti: clear all mixer control
      drm: sti: simplify gdp code
      drm: sti: remove event lock while disabling vblank
      drm: sti: fix hdmi avi infoframe
      drm: sti: use drm_crtc_vblank_{on/off} instead of drm_vblank_{on/off}
      drm: sti: prepare sti_tvout to support auxiliary crtc
      drm: sti: fix delay in VTG programming
      drm: sti: enable auxiliary CRTC
      drm: sti: add cursor plane
      drm: sti: add HQVDP plane
      drm: sti: correctly cleanup CRTC and planes

Bob Paauwe (1):
      drm/i915: Use correct pipe config to update pll dividers. V2

Boris BREZILLON (3):
      drm: rework flip-work helpers to avoid calling func when the FIFO is full
      drm: flip-work: change drm_flip_work_init prototype
      drm: omapdrm: remove unused variable

Brad Volkin (3):
      drm/i915: Re-enable the command parser when using PPGTT
      drm/i915: Log a message when rejecting LRM to OACONTROL
      drm/i915: Abort command parsing for chained batches

Chris Wilson (16):
      drm/i915: Remove dead code, i915_gem_verify_gtt
      drm/i915: Inline feature detection into sanitize_enable_ppgtt
      drm/i915: Remove the duplicated logic between the two shrink phases
      drm: Implement O_NONBLOCK support on /dev/dri/cardN
      drm/i915: Report the current number of bytes freed during oom
      drm/i915: Suppress no action noise from oom shrinker
      drm/i915: Convert a couple more INTEL_INFO-esque macros to be pointer agnostic
      drm/i915: Only mark as map-and-fenceable when bound into the GGTT
      drm/i915: Request PIN_GLOBAL when pinning a vma for GTT relocations
      drm/i915: Report the actual swizzling back to userspace
      drm/i915: Make the physical object coherent with GTT
      drm/dp/mst: Handle invalid link bandwidth from DPCD gracefully
      drm/i915: Don't continually defer the hangcheck
      drm/i915: Remove DRI1 ring accessors and API
      drm/i915: Only call mod_timer() if not already pending
      drm/i915: Only warn the first time we attempt to mmio whilst suspended

Christian König (20):
      drm/radeon: rework vm_flush parameters
      drm/radeon: stop re-reserving the BO in radeon_vm_bo_set_addr
      drm/radeon: remove unnecessary VM syncs
      drm/radeon: split semaphore and sync object handling v2
      drm/radeon: fence PT updates manually v2
      drm/radeon: track VM update fences separately
      drm/radeon: use one VMID for each ring
      drm/radeon: fence BO_VAs manually
      drm/radeon: sync PD updates as shared
      drm/radeon: sync PT updates as shared v2
      drm/radeon: update the VM after setting BO address v4
      drm/radeon: sync all BOs involved in a CS
      drm/radeon drop gobj from radeon_cs_reloc
      drm/radeon: drop the handle from radeon_cs_reloc
      drm/radeon: rename radeon_cs_reloc to radeon_bo_list
      drm/radeon: fence PT updates as shared
      drm/radeon: add spinlock for BO_VA status protection (v2)
      drm/ttm: optionally move duplicates to a separate list
      drm/radeon: remove duplicates check
      drm/radeon: use pointers instead of indexes for CS chunks

Chuck Ebbert (2):
      drm/crtc: Fix two typos
      drm/crtc: Remove duplicated ioctl code

Clint Taylor (1):
      drm/i915/chv: Enable AVI, SPD and HDMI infoframes for CHV.

Daisy Sun (1):
      drm/i915/skl: SKL FBC enablement

Damien Lespiau (76):
      drm/i915/skl: Add the Skylake PCI ids
      drm/i915/skl: Add an IS_GEN9() define
      drm/i915/skl: Fence registers on SKL are the same as SNB
      drm/i915/skl: Provide a placeholder for init_clock_gating()
      drm/i915/skl: Skylake shares the interrupt logic with Broadwell
      drm/i915/skl: Framebuffers need to be aligned to 256KB on Skylake
      drm/i915/skl: Implement the new update_plane() for primary planes
      drm/i915/skl: Don't create a VGA connector on Skylake
      drm/i915/skl: Don't try to read out the PCH transcoder state if not present
      drm/i915/skl: Program the DDI buffer translation tables
      drm/i915/skl: Add support for DP voltage swings and pre-emphasis
      drm/i915/skl: Skylake moves AUX_CTL from PCH to CPU
      drm/i915/skl: Add the additional graphics stolen sizes
      drm/i915/skl: gen9 uses the same bind_vma() vfuncs as gen6+
      drm/i915/skl: Implement the get_aux_clock_divider() DP vfunc
      drm/i915/skl: Provide a get_aux_send_ctl() vfunc for skylake
      drm/i915/skl: Initialize PPGTT like gen8
      drm/i915/skl: Allow the reg_read ioctl to return RCS_TIMESTAMP
      drm/i915/skl: report the same INSTDONE registers as gen8
      drm/i915/skl: Report the PDP regs as in gen8
      drm/i915/skl: SKL shares the same underrun interrupt as BDW
      drm/i915/skl: Adjust the display engine interrupts
      drm/i915/skl: Implement WaDisableSDEUnitClockGating:skl
      drm/i915/skl: Implement Wa4x4STCOptimizationDisable:skl
      drm/i915/skl: Implement WaDisableDgMirrorFixInHalfSliceChicken5:skl
      drm/i915/skl: Skylake has 2 "sprite" planes per pipe
      drm/i915/skl: Implement drm_plane vfuncs
      drm/i915/skl: Adjust assert_sprites_disabled()
      drm/i915/skl: Introduce a I915_MAX_PLANES macro
      drm/i915/skl: Introduce intel_num_planes()
      drm/i915/skl: Move gen9 pm initialization into its own branch
      drm/i915: Use IS_HSW_ULT() in a HSW specific code path
      drm/i915: Use IS_HSW_ULT() in HAS_IPS()
      drm/i915: Spell out IS_HSW/BDW_ULT() in intel_crt_present()
      drm/i915: Use IS_HSW_ULT() in HSW CDCLK clock read-out
      drm/i915/skl: Don't check for ULT/ULX when detecting the PCH
      drm/i915: Remove IS_ULT()
      drm: Add a note to drm_property_create() about property lifetime
      drm/i915: Don't destroy DRM properties in the driver
      drm/gma500: Don't destroy DRM properties in the driver
      drm/i915: Remove unnecessary test on the gen in intel_do_mmio_flip()
      drm/i915: Make intel_pipe_has_type() take an output type enum
      drm/i915: Remove unused WATCH_GTT define
      drm/i915: Removed orphaned prototype intel_dp_handle_hpd_irq()
      drm/i915: Remove orphaned prototype gen6_set_pm_mask()
      drm/i915/skl: Add DDB allocation management structures
      drm/i915/skl: Allocate DDB portions for display planes
      drm/i915/skl: Program the DDB allocation
      drm/i915/skl: Store the new WM state at the very end of the update
      drm/i915/skl: Read back the DDB allocation hw state
      drm/i915/skl: Augment the latency debugfs files for SKL
      drm/i915/skl: Add a debugfs file to dump the DDB allocation
      drm/i915/skl: Check the DDB state at modeset
      drm/i915/skl: Make 'end' of the DDB allocation entry exclusive
      drm/i915/skl: Use a more descriptive parameter name in skl_compute_plane_wm()
      drm/i915/skl: Make res_blocks/lines intermediate values 32 bits
      drm/i915/skl: Reduce the number of holes in struct skl_wm_level
      drm/i915/skl: Move all the WM compute functions in one place
      drm/i915/skl: Rework when the transition WMs are computed
      drm/i915/skl: Correctly align skl_compute_plane_wm() arguments
      drm/i915/skl: Reduce the indentation level in skl_write_wm_values()
      drm/i915/skl: Stage the pipe DDB allocation
      drm/i915/skl: Flush the WM configuration
      drm/i915/skl: Log the order in which we flush the pipes in the WM code
      drm/i915/skl: Provide skl-specific pll hw state cross-checking
      drm/i915/skl: Implement queue_flip
      drm/i915: Clear PCODE_DATA1 on SNB+
      drm/i915: Let's hope future platforms will use the same WM code as SKL
      drm/i915/skl: Fix big integer constant sparse warning
      drm/i915/skl: Don't allow disabling ppgtt and execlists on gen9+
      drm/i915/skl: Remove spurious warn in get_ddi_pll()
      drm/i915/skl: Set the eDP link rate on DPLL0
      drm/i915/skl: Use the pipe config DPLL tracking to query the link clock
      drm/i915/bdw: Fix the write setting up the WIZ hashing mode
      drm/i915: Invert the mask and val arguments in wa_add() and WA_REG()
      drm/i915: Remove '& 0xffff' from the mask given to WA_REG()

Dan Carpenter (3):
      amdkfd: fix some error handling in ioctl
      amdkfd: fix an error handling bug in pqm_create_queue()
      amdkfd: delete some dead code

Daniel Kurtz (1):
      drm/panel: simple: Update Innolux N116BGE timings

Daniel Thompson (2):
      drm/msm: Allow exported dma-bufs to be mapped
      drm/msm: Fix fbdev for 16- and 24-bit modes.

Daniel Vetter (107):
      drm/i915: WARN if interrupts aren't on in en/disable_pipestat
      drm/i915: Restore resume irq ordering comment
      drm/i915: Drop get/put_pages for scratch page
      agp/intel-gtt: Remove get/put_pages
      drm/i915: Fix irq checks in ring->irq_get/put functions
      drm/i915: Convert backlight_lock to a mutex
      drm/i915: Use generic vblank wait
      drm/i915: static inline for intel_wait_for_vblank
      drm/i915: Clarify event_lock locking, process context
      drm/i915: Clarify event_lock locking, irq&mixed context
      drm/i915: Clarify gpu_error.lock locking
      drm/i915: Clarify irq_lock locking, intel_tv_detect
      drm/i915: Clarify irq_lock locking, work functions
      drm/i915: Clarify irq_lock locking, interrupt install/uninstall
      drm/i915: Clarify irq_lock locking, irq handlers
      drm/i915: Clarify irq_lock locking, special cases
      drm/i915: Clarify uncore.lock locking
      drm/i915: Clarify mmio_flip_lock locking
      drm/i915: Update DRIVER_DATE to 20140919
      drm/i915: DocBook integration for frontbuffer tracking
      Merge branch 'topic/skl-stage1' into drm-intel-next-queued
      drm/i915: Tighting frontbuffer tracking around flips
      drm/i915: spelling fixes for frontbuffer tracking kerneldoc
      drm/i915: Remove intel_modeset_suspend_hw
      drm/i915: Extract intel_runtime_pm.c
      drm/i915: Bikeshed rpm functions name a bit.
      drm/i915: Move intel_display_set_init_power to intel_runtime_pm.c
      drm/i915: Call runtime_pm_disable directly
      drm/i915: Kerneldoc for intel_runtime_pm.c
      drm/i915: Reinstate error level message for non-simulated gpu hangs
      drm/i915: Constify send buffer for intel_dp_aux_ch
      drm/i915: s/pm._irqs_disabled/pm.irqs_enabled/
      drm/i915: Use dev_priv instead of dev in irq setup functions
      drm/i915: kerneldoc for interrupt enable/disable functions
      drm/i915: Update DRIVER_DATE to 20141003
      Merge branch 'drm-intel-next-fixes' into drm-intel-next
      drm/dp-helper: Move the legacy helpers to gma500
      Revert "drm/i915: Enable full PPGTT on gen7"
      drm/i915: Extract intel_fifo_underrun.c
      drm/i915: Use dev_priv in public intel_fifo_underrun.c functions
      drm/i915: Add wrappers to handle fifo underrun interrupts
      drm/i915: Filter gmch fifo underruns in the shared handler
      drm/i915: kerneldoc for intel_fifo_underrun.c
      drm/i915: Document that mmap forwarding is discouraged
      drm/i915: Fold in intel_mst_port_dp_detect
      drm/i915: Correctly reject invalid flags for wait_ioctl
      drm/i915: Update DRIVER_DATE to 20141024
      drm: Move drm_crtc_init from drm_crtc.h to drm_plane_helper.h
      drm: Pull drm_crtc.h into the kerneldoc template
      drm: fixup kerneldoc in drm_crtc.h
      drm/modeset_lock: document trylock_only in kerneldoc
      drm: Add atomic driver interface definitions for objects
      drm: Global atomic state handling
      drm: Add atomic/plane helpers
      drm/plane-helper: transitional atomic plane helpers
      drm/crtc-helper: Transitional functions using atomic plane helpers
      drm: Atomic crtc/connector updates using crtc/plane helper interfaces
      drm/atomic-helper: implementatations for legacy interfaces
      drm/atomic: Integrate fence support
      drm/atomic-helpers: document how to implement async commit
      drm/atomic-helper: implement ->page_flip
      drm/atomic-helpers: functions for state duplicate/destroy/reset
      drm: Docbook integration and over sections for all the new helpers
      drm/atomic: Refcounting for plane_state->fb
      drm/i915: Check pipe_config.has_dp_encoder instead of encoder types
      drm/i915: Move pll state commit into intel_modeset_update_state
      drm/i915/dp: Don't stop the link when retraining
      drm/i915: Update DRIVER_DATE to 20141107
      Merge remote-tracking branch 'airlied/drm-next' into HEAD
      drm: Per-plane locking
      drm: More specific locking for get* ioctls
      drm/i915: Delete outdated comment in byt_pte_encode
      drm: Simplify return value handling in drm_crtc.c
      drm/i915: Drop return value from lrc_setup_hardware_status_page
      drm/i915: Don't print header in error state for non-existing CS
      drm/i915: Tune down sink crc timeout dmesg output
      Merge tag 'drm-intel-fixes-2014-11-19' into drm-intel-next-queued
      drm/i915: Replace dri1 functions with drm_noop
      drm/i915: Drop checks for initialization
      drm/i915: No-Op enter/leave vt gem ioctl
      drm/atomic: Ensure that drm_connector_index is stable
      drm/atomic: Only destroy connector states with connection mutex held
      drm/atomic: Don't overrun the connector array when hotplugging
      drm/crtc: Polish kerneldoc
      drm: s/enum_blob_list/enum_list/ in drm_property
      drm/atomic_helper: Make it clear that commit_planes gets the old state
      drm/i915: Ditch dev_priv->ums.mm_suspend
      drm/i915: Sanitize ->lastclose
      drm/i915: Can i915_gem_init_ioctl
      drm/i915: Pin tiled objects for L-shaped configs
      drm/i915: Dump hdmi pipe_config state
      drm/i915: Use ggtt error obj capture helper for gen8 semaphores
      drm/i915: Don't rely upon encoder->type for infoframe hw state readout
      drm/atomic: Add missing ERR_PTR casting
      drm/i915: Update DRIVER_DATE to 20141121
      drm: Document that drm_dev_alloc doesn't need a parent
      drm/atomic-helper: Skip vblank waits for unchanged fbs
      drm/atomic: Drop per-plane locking TODO
      drm: Handle atomic state properly in kms getfoo ioctl
      drm/i915: Disallow pin ioctl completely for kms drivers
      drm/i915: Stop gathering error states for CS error interrupts
      drm/i915: Handle runtime pm in the CRC setup code
      drm/i915: Tune down spurious CRC interrupt warning
      drm/i915: compute wait_ioctl timeout correctly
      drm/i915: Handle inaccurate time conversion issues
      drm/dp-mst: Remove branches before dropping the reference
      drm/i915: Don't complain about stolen conflicts on gen3

Daniele Ceraolo Spurio (1):
      drm/i915: Add tracepoints to track a vm during its lifetime

Dave Airlie (48):
      Merge tag 'drm-intel-next-2014-10-03-no-ppgtt' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'drm-intel-next-2014-10-24' of git://anongit.freedesktop.org/drm-intel into drm-next
      drm: drop README.drm, ancient scrolls
      Merge tag 'topic/core-stuff-2014-11-05' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'topic/atomic-helpers-2014-11-09' of git://anongit.freedesktop.org/drm-intel into drm-next
      drm/mode: document path property and function to set it. (v1.1)
      Merge tag 'v3.18-rc4' into drm-next
      drm/radeon/si/ci: make u8 static arrays constant
      Merge branch 'drm-next-3.19' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge tag 'drm-intel-next-2014-11-07-fixups' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'drm/panel/for-3.19-rc1' of git://people.freedesktop.org/~tagr/linux into drm-next
      Merge tag 'drm/fixes/for-3.19-rc1' of git://people.freedesktop.org/~tagr/linux into drm-next
      Merge tag 'drm/tegra/for-3.19-rc1' of git://people.freedesktop.org/~tagr/linux into drm-next
      drm: add properties for suggested x/y offset for connectors. (v2)
      drm/qxl: use suggested x/y offset properties to pass guest prefs
      Merge tag 'drm/gem-cma/for-3.19-rc1' of git://people.freedesktop.org/~tagr/linux into drm-next
      drm/qxl: drop unused mode private pointer
      Merge branch 'msm-next' of git://people.freedesktop.org/~robclark/linux into drm-next
      Merge branch 'amdkfd-v6' of git://people.freedesktop.org/~gabbayo/linux into drm-next
      Merge branch 'drm-next-3.19' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'msm-next' of git://people.freedesktop.org/~robclark/linux into drm-next
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge branch 'amdkfd-next-3.19' of git://people.freedesktop.org/~gabbayo/linux into drm-next
      Merge branch 'drm/du/adv7511' of git://linuxtv.org/pinchartl/fbdev into drm-next
      Merge tag 'topic/core-stuff-2014-11-28' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'v3.18-rc7' into drm-next
      Merge branch 'linux-3.19' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge tag 'drm-intel-next-2014-11-21-fixed' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge branch 'vmwgfx-next' of git://people.freedesktop.org/~thomash/linux into drm-next
      Merge branch 'drm-next-3.19-wip' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'amdkfd-next-3.19' of git://people.freedesktop.org/~gabbayo/linux into drm-next
      Merge tag 'drm-intel-next-fixes-2014-12-04' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'v3.18' into drm-next
      Merge branch 'amdkfd-next-3.19' of git://people.freedesktop.org/~gabbayo/linux into drm-next
      Merge branch 'drm_iommu_v15' of https://github.com/markyzq/kernel-drm-rockchip into drm-next
      drm/i915: resume MST after reading back hw state
      drm/dp: retry AUX transactions 32 times (v1.1)
      drm/fb_helper: move deferred fb checking into restore mode (v2)
      drm/displayid: add displayid defines and edid extension (v2)
      drm: add tile_group support. (v3)
      drm/mst: cached EDID for logical ports (v2)
      drm/connector: store tile information from displayid (v3)
      drm/tile: expose the tile property to userspace (v3)
      drm/fb: add support for tiled monitor configurations. (v2)
      Merge branch 'drm-mst-next' of ssh://people.freedesktop.org/~/linux into drm-next
      Merge tag 'topic/core-stuff-2014-12-10' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge tag 'drm-intel-next-fixes-2014-12-11' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge branch 'drm-sti-next-2014-12-11' of http://git.linaro.org/people/benjamin.gaignard/kernel into drm-next

Dave Gordon (1):
      drm/i915: Remove redundant return value and WARN_ON

Deepak S (1):
      drm/i915/vlv: Remove check for Old Ack during forcewake

Egbert Eich (1):
      drm/i915/eDP: When enabling panel VDD cancel pending disable worker

Evgeny Pinchuk (2):
      amdkfd: Add topology module to amdkfd
      amdkfd: Implement the Get Clock Counters IOCTL

Fabian Frederick (1):
      drm: remove unnecessary sizeof(u8)

Gerd Hoffmann (4):
      bochs: little cleanup
      bochs: add endian switching support
      bochs: fix bochsdrmfb mmap
      bochs: add page_flip

Gustavo Padovan (31):
      drm/i915: create struct intel_plane_state
      drm/i915: split intel_update_plane into check() and commit()
      drm/i915: split intel_cursor_plane_update() into check() and commit()
      drm/i915: split intel_primary_plane_setplane() into check() and commit()
      drm/i915: remove !enabled handling from commit primary plane step
      drm/i915: pin sprite fb only if it changed
      drm/i915: create intel_update_pipe_size()
      drm/i915: Fix regression in the sprite plane update split
      drm/i915: Merge of visible and !visible paths for primary planes
      drm/i915: remove leftover from pre-universal planes days
      drm/i915: move check of intel_crtc_cursor_set_obj() out
      drm/i915: Fix not checking cursor and object sizes
      drm/i915: only flip frontbuffer if crtc is active
      drm: make sure visible is set to false if fb is null
      drm/i915: remove unneeded visible check
      drm/i915: create a prepare step for primary planes updates
      drm/i915: create a prepare phase for sprite plane updates
      drm/i915: use intel_fb_obj() macros to assign gem objects
      drm/exynos: remove uneeded declaration of struct dma_iommu_mapping
      drm/exynos: remove extra declaration of struct exynos_drm_manager
      drm/exynos: remove extra declaration of struct exynos_overlay
      drm/exynos: Replace repeated declaration by include <drm/drmP.h>
      drm/exynos: Replace repeated declarations by #include "exynos_drm_drv.h"
      drm/exynos: remove unused wait_for macro
      drm/exynos: Save up space using bool var as bitfields
      drm/exynos: update documentation to reflect code changes
      drm/exynos: remove leftover hdmi function declarations
      Revert "drm/exynos: fix null pointer dereference issue"
      drm/exynos: move Exynos platform drivers registration to init
      drm/exynos: Fix exynos_dpi_remove() parameter
      drm/exynos: avoid leak if exynos_dpi_probe() fails

Haixia Shi (4):
      drm/udl: add cache flags definitions for udl_gem_object
      drm/udl: add support to export a handle to a FD on UDL.
      drm/udl: handle page mapping in dmabuf export.
      drm/udl: properly check for error pointers

Imre Deak (32):
      drm/i915: vlv: fix display IRQ enable/disable
      drm/i915/skl: don't set the AsyncFlip performance mode for Gen9+
      drm/i915: remove dead code from legacy suspend handler
      drm/i915: vlv: fix gunit HW state corruption during S4 suspend
      drm/i915: factor out i915_drm_suspend_late
      drm/i915: unify legacy S3 suspend and S4 freeze handlers
      drm/i915: propagate error from legacy resume handler
      drm/i915: vlv: fix switcheroo/legacy suspend/resume
      drm/i915: fix S4 suspend while switcheroo state is off
      drm/i915: remove unused restore_gtt_mappings optimization during suspend
      drm/i915: check for GT faults in all resume handlers and driver load time
      drm/i915: enable output polling during S4 thaw
      drm/i915: disable/re-enable PCI device around S4 freeze/thaw
      drm/i915: unify S3 and S4 suspend/resume handlers
      drm/i915: sanitize suspend/resume helper function names
      drm/i915: add poweroff_late handler
      drm/i915: unify switcheroo and legacy suspend/resume handlers
      drm/i915: add comments on what stage a given PM handler is called
      drm/i915: unify gen6/gen8 pm irq helpers
      drm/i915: unify gen6/gen8 rps irq handler
      drm/i915: unify gen6/gen8 rps irq enable/disable
      drm/i915: move rps irq enable/disable to i915_irq.c
      drm/i915: WARN if we receive any gen9 rps interrupts
      drm/i915: WARN if we receive any rps interrupts on gen>9
      drm/i915: move rps irq disable one level up
      drm/i915: sanitize rps irq enabling
      drm/i915: sanitize rps irq disabling
      drm/i915: disable rps irqs earlier during suspend/unload
      drm/i915: vlv: fix cdclk setting during modeset while suspended
      drm/i915: vlv: increase timeout when setting idle GPU freq
      drm/i915: remove the IRQs enabled WARN from intel_disable_gt_powersave
      drm/i915: mask RPS IRQs properly when disabling RPS

Inki Dae (8):
      drm/exynos: resolve infinite loop issue on multi-platform
      drm/exynos: resolve infinite loop issue on non multi-platform
      drm/exynos: g2d: fix null pointer dereference
      drm/exynos: fix possible infinite loop issue
      drm/exynos: fix null pointer dereference issue
      drm/exynos: clean up machine compatible string check
      drm/exynos: fix exynos_drm_component_del
      drm/exynos: vidi: add component support

Jan Safrata (1):
      drm/gma500: add support for atom e6xx lpc lvds i2c

Jani Nikula (30):
      drm/i915/bios: add missing __packed to structs used for reading vbt
      drm/i915: remove redundant #ifdef CONFIG_COMPAT
      drm/i915: spt does not have pch backlight override bit
      drm/i915: add new intel audio file to group DP/HDMI audio
      drm/i915/audio: constify hdmi audio clock struct
      drm/i915/audio: beat some sense into the variable types and names
      drm/i915: pass intel_encoder to intel_write_eld
      drm/i915/audio: pass intel_encoder on to platform specific ELD functions
      drm/i915/audio: set ELD Conn_Type at one place
      drm/i915/ddi: write ELD where it's supposed to be done
      drm/i915: introduce intel_audio_codec_{enable, disable}
      drm/i915/audio: remove misleading checks for !eld[0]
      drm/edid: add #defines and helpers for ELD
      drm/i915: clean up and clarify audio related register defines
      drm/i915: rewrite hsw/bdw audio codec enable/disable sequences
      drm/i915/audio: rewrite vlv/chv and gen 5-7 audio codec enable sequence
      drm/i915/audio: add vlv/chv/gen5-7 audio codec disable sequence
      drm/i915: enable audio codec after port
      drm/i915/audio: add audio codec disable on g4x
      drm/i915/audio: add audio codec enable debug log for g4x
      drm/i915: make pipe/port based audio valid accessors easier to use
      drm/i915/audio: add DOC comment describing HDA over HDMI/DP
      drm/edid: fix Baseline_ELD_Len field in drm_edid_to_eld()
      drm/i915/vlv: don't save panel power sequencer registers on suspend
      drm/i915: restore RSTDBYCTL only on non-KMS paths
      drm/i915: remove the unnecessary block around display.hpd_irq_setup
      drm/i915: don't save/restore panel fitter registers
      drm/i915: don't save/restore backlight hist ctl registers
      drm/i915: unify remaining register save/restore code a bit
      drm/i915/audio: fix monitor presence indication after disable

Jasper St. Pierre (1):
      drm/atomic_helper: Cope with plane->crtc == NULL in disable helper

Jay Cornwall (1):
      amdkfd: Fix memory leak on process deregistration

Jesse Barnes (14):
      drm/i915: preserve swizzle settings if necessary v4
      drm/i915: factor out compute_config from __intel_set_mode v3
      drm/i915: use compute_config in set_config v4
      drm/i915/hdmi: fetch infoframe status in get_config v2
      drm/i915: check for audio and infoframe changes across mode sets v2
      drm/i915: update pipe size at set_config time
      drm/i915: preserve SSC if previously set v3
      drm/i915/skl: fetch, enable/disable pfit as needed v2
      drm/i915/skl: AUX irqs have moved
      drm/i915/ddi: add break in DDI mode select switch
      drm/i915/ddi: set has_infoframe flag on DDI too v2
      drm/i915/g4x: fix g4x infoframe readout
      drm/i915: don't always do full mode sets when infoframes are enabled
      drm/i915: save/restore GMBUS freq across suspend/resume on gen4

Joe Perches (1):
      drm: drm_err: Remove unnecessary __func__ argument

Joerg Roedel (4):
      mmu_notifier: add mmu_notifier_invalidate_range()
      mmu_notifier: call mmu_notifier_invalidate_range() from VMM
      mmu_notifier: add the callback for mmu_notifier_invalidate_range()
      iommu/amd: use new invalidate_range mmu-notifier

John Harrison (2):
      drm/i915: Fix null pointer dereference in ring cleanup code
      drm/i915: Remove redundant parameter to i915_gem_object_wait_rendering__tail()

Joonyoung Shim (3):
      drm/exynos: add has_vtsel flag
      drm/exynos: move triggering checking
      drm/exynos: use irq_flags instead of triggering

Julia Lawall (2):
      drm/exynos/ipp: fix error return code
      drm: rcar-du: fix error return code

Krzysztof Kozlowski (1):
      drm/exynos: Fix DSI resuming fail because power domain being off

Lars-Peter Clausen (2):
      drm: Decouple EDID parsing from I2C adapter
      drm: Add adv7511 encoder driver

Laurent Pinchart (11):
      Merge tag 'tags/renesas-dt-du-for-v3.19' into drm/next/adv7511-base
      drm: rcar-du: Remove platform data support
      drm: rcar-du: Pass the encoder DT node to rcar_du_encoder_init()
      drm: rcar-du: Replace direct DRM encoder access with cast macro
      drm: rcar-du: Replace drm_encoder with drm_slave_encoder
      drm: rcar-du: Add HDMI encoder and connector support
      video: Add ADV751[13] DT bindings documentation
      ARM: shmobile: lager: Remove DU platform device
      ARM: shmobile: marzen: Remove DU platform device
      drm: rcar-du: Fix NULL encoder pointer dereference
      drm/doc: Document drm_add_modes_noedid() usage

Lucas Stach (3):
      drm/panel: simple: Add support for Innolux G121I1-L01
      of: Add vendor prefix for Hitachi Ltd. Corporation
      drm/panel: simple: Add support for Hitachi TX23D38VM0CAA

Mark Yao (3):
      drm: rockchip: Add basic drm driver
      dt-bindings: video: Add for rockchip display subsytem
      dt-bindings: video: Add documentation for rockchip vop

Markus Elfring (4):
      drm/edid: Deletion of an unnecessary check before the function call "release_firmware"
      drm/tilcdc: Deletion of an unnecessary check before the function call "drm_fbdev_cma_hotplug_event"
      drm/udl: Deletion of an unnecessary check before the function call "vunmap"
      drm/vmwgfx: Deletion of an unnecessary check before the function call "vfree"

Martin Peres (2):
      drm: fix a word repetition in a comment
      drm: fix a typo in a comment

Masanari Iida (2):
      gpu:drm: Fix typo in Documentation/DocBook/drm.xml
      gpu: drm: Fix warning caused by a parameter description in drm_crtc.c

Matt Roper (2):
      drm/i915: Propagate invalid setcrtc cloning errors back to userspace
      drm/i915: Don't store panning coordinates as 16.16 fixed point

Michael H. Nguyen (1):
      drm/i915/skl: Add Gen9 LRC size

Michel Dänzer (10):
      drm/radeon: Try placing NO_CPU_ACCESS BOs outside of CPU accessible VRAM
      drm/radeon: Try evicting from CPU accessible to inaccessible VRAM first
      drm/radeon: Set TTM_PL_FLAG_TOPDOWN also for RADEON_GEM_CPU_ACCESS BOs
      drm/ttm: Add DRM_MM_SEARCH_BELOW for TTM_PL_FLAG_TOPDOWN
      drm/ttm: Use only DRM_MM_SEARCH_BELOW for TTM_PL_FLAG_TOPDOWN
      drm/radeon: Use cursor_set2 hook for enabling / disabling the HW cursor
      drm/radeon: Move radeon_cursor_move(_locked) to replace forward declaration
      drm/radeon: Re-show the cursor after a modeset
      drm/radeon: Move hotspot handling out of radeon_set_cursor
      drm/radeon: Hide cursor on CRTCs used by fbdev (v2)

Michel Thierry (3):
      drm/i915: Enable full PPGTT on gen7
      drm/i915: add runtime PM get/put call in i915_execlists
      drm/i915: Initialize workarounds in logical ring mode too

Mika Kuoppala (6):
      drm/i915: Build workaround list in ring initialization
      drm/i915: Check workaround status on dfs read time
      drm/i915: Redefine WARN_ON to include the condition
      Revert "drm/i915/vlv: Remove check for Old Ack during forcewake"
      drm/i915: Add gen to the gpu hang ecode
      drm/i915: Wait thread status on gen8+ fw sequence

Neil Roberts (1):
      drm/i915: Add the predicate source registers to the register whitelist

Oded Gabbay (26):
      iommu/amd: fix accounting of device_state
      drm/radeon: reduce number of free VMIDs and pipes in KV
      drm/radeon/cik: Don't touch int of pipes 1-7
      drm/radeon: Report doorbell configuration to amdkfd
      drm/radeon: adding synchronization for GRBM GFX
      drm/radeon: Add radeon <--> amdkfd interface
      Update MAINTAINERS and CREDITS files with amdkfd info
      amdkfd: Add IOCTL set definitions of amdkfd
      amdkfd: Add amdkfd skeleton driver
      amdkfd: Add basic modules to amdkfd
      amdkfd: Add binding/unbinding calls to amd_iommu driver
      amdkfd: Implement the create/destroy/update queue IOCTLs
      amdkfd: Implement the Get Version IOCTL
      amdkfd: Fix sparse warnings in kfd_chardev.c
      amdkfd: Fix sparse warnings in kfd_topology.c
      amdkfd: Fix sparse warnings in kfd_flat_memory.c
      amdkfd: is_occupied() can be static
      amdkfd: fence_wait_timeout() can be static
      amdkfd: add __iomem attribute to doorbell_ptr
      amdkfd: use schedule() in sync_with_hw
      amdkfd: Clear ctx cb before suspend
      amdkfd: explicitely include io.h in kfd_doorbell.c
      amdkfd: Remove DRM_AMDGPU dependency from Kconfig
      amdkfd: Fix memory leak of mqds on dqm fini
      amdkfd: Set *buffer_ptr to NULL in case of error
      amdkfd: Disable support for 32-bit user processes

Oscar Mateo (1):
      drm/i915/bdw: Pin the context backing objects to GGTT on-demand

Paulo Zanoni (11):
      drm/i915: extract intel_init_fbc()
      drm/i915: add SW tracking to FBC enabling
      drm/i915: call drm_vblank_cleanup() earlier at unload
      drm/i915: disable IPS while getting the pipe CRCs.
      drm/i915: only run hsw_power_well_post_enable when really needed
      drm/i915: transform INTEL_OUTPUT_* into an enum
      drm/i915: kill intel_resume_prepare()
      drm/i915: run hsw_disable_pc8() later on resume
      drm/i915: fix "Unexpected fault" error message line break
      drm/i915: fix RPS on runtime suspend
      drm/i915: use the correct obj when preparing the sprite plane

Peter Hurley (2):
      drm: Fix DRM_FORCE_ON_DIGITAL use
      drm: Remove compiler BUG_ON() test

Philipp Zabel (4):
      of: Add vendor prefix for HannStar Display Corporation
      drm/panel: simple: Add HannStar HSD070PWW1 7.0" WXGA TFT LCD panel
      drm: imx: Move imx-drm driver out of staging
      MAINTAINERS: add maintainer for i.MX DRM driver

Pradeep Bhat (5):
      drm/i915/skl: Read the Memory Latency Values for WM computation
      drm/i915/skl: Register definitions and macros for SKL Watermark regs
      drm/i915/skl: Definition of SKL WM param structs for pipe/plane
      drm/i915/skl: SKL Watermark Computation
      drm/i915/skl: Read the pipe WM HW state

Rickard Strandqvist (1):
      gpu: drm: drm_dp_mst_topology.c: Fix improper use of strncat

Rob Clark (37):
      drm: export atomic wait_for_vblanks helper (v2)
      drm/atomic: rip out unnecessary locking checks
      drm/msm: select REGULATOR
      drm/msm/adreno: slight init order cleanup
      drm/msm: update generated headers
      drm/msm/hdmi: refactor bind/init
      drm/msm/mdp4: drop private primary ptr
      drm/msm/mdp5: drop private primary ptr
      drm/msm/mdp4: don't care about fb in crtc
      drm/msm/mdp4: drop attached planes table
      drm/msm/mdp5: drop attached planes table
      drm/msm: small fence cleanup
      drm/msm: remove unused compile-test stub
      drm/msm: fb prepare/cleanup
      drm/msm: bit of fb error checking
      drm/msm: atomic core bits
      drm/msm/hdmi: atomic
      drm/msm/mdp4: atomic
      drm/msm: small mmap offset cleanups
      drm/irq: BUG_ON() -> WARN_ON()
      drm/msm/mdp5: use irqdomains
      drm/msm/hdmi: remove useless kref
      drm/msm/mdp5: set rate before enabling clk
      drm/msm/mdp5: don't use void * for opaque types
      drm/msm/mdp5: remove global mdp5_ctl_mgr
      drm/msm: atomic fixes
      drm/msm/mdp5: atomic
      drm/msm/mdp5: dpms(OFF) cleanups
      drm/msm/mdp4: fix mixer setup for multi-crtc + planes
      drm/atomic: check mode_changed *after* atomic_check
      drm/atomic: shutdown *current* encoder
      drm/atomic: track bitmask of planes attached to crtc
      drm/atomic: add plane iterator macros
      drm/msm: switch to atomic-helpers iterator macros
      drm: fix indentation
      drm: use mode_object_find helpers
      drm/atomic: clear plane's CRTC and FB when shutting down

Robert Beckett (1):
      drm/i915/skl: i915_swizzle_info gen9 fix

Rodrigo Vivi (20):
      drm/i915: Only flush fbc on sw when fbc is enabled.
      drm/i915: Avoid reading fbc registers in vain when fbc was never enabled.
      drm/i915: PSR: organize setup function.
      drm/i915: PSR: Organize PSR enable function
      drm/i915: Avoid re-configure panel on every PSR re-enable.
      drm/i915: Minimize the huge amount of unecessary fbc sw cache clean.
      drm/i915: Make sure PSR is ready for been re-enabled.
      drm/i915: Broadwell DDI Buffer translation changed to give better margin.
      drm/i915: Broadwell DDI Buffer translation - more tuning
      drm/i915: Fix Sink CRC
      drm/i915: Add IS_BDW_GT3 macro.
      drm/i915/bdw: WaDisableFenceDestinationToSLM
      drm/i915: preserve other DP_TEST_SINK bits.
      drm/i915: make sink_crc return -EIO on aux read/write failure
      drm/i915: Do not export RC6p and RC6pp if they don't exist
      drm/i915/bdw: Remove BDW preproduction W/As until C stepping.
      drm/i915/chv: Use 16 and 32 for low and high drain latency precision.
      drm/i915: Make dp aux pack/unpack public outside intel_dp.c
      drm/i915: Introduce intel_psr.c
      drm/i915: Add PSR docbook

Roy Spliet (9):
      drm/nouveau/bios/ramcfg: 10_02_40 -> DLLoff
      drm/nouveau/fb/gddr3: Generate MR values
      drm/nouveau/fb/ramnva3: Link training for DDR3
      drm/nouveau/fb/ramnva3: Ressurect timing calculation code
      drm/nouveau/fb/ramnva3: Reclocking script for DDR3
      drm/nouveau/fb/ramnva3: Reclocking script for DDR2
      drm/nouveau/fb/ramnva3: Reclocking script for GDDR3
      drm/nva3/clock: Allow user reclocking
      drm/nouveau/pwr/fuc: Fix thinko in nouveau_memx_wait()

Sasha Levin (2):
      amdkfd: use sizeof(long) granularity for the pasid bitmask
      amdkfd: use atomic allocations within srcu callbacks

Satheeshakrishna M (14):
      drm/i915/skl: Add an IS_SKYLAKE macro
      drm/i915/skl: SKL pipe misc programming
      drm/i915/skl: vfuncs for skl eld and global resource
      drm/i915/skl: SKL backlight enabling
      drm/i915/skl: Restore pipe B/C interrupts
      drm/i915/skl: Sunrise Point PCH detection
      drm/i915/skl: Register definitions for SKL Clocks
      drm/i915/skl: Structure/enum definitions for SKL clocks
      drm/i915/skl: CD clock back calculation for SKL
      drm/i915/skl: Determine enabled PLL and its linkrate/pixel clock
      drm/i915/skl: Query DPLL attached to port on SKL
      drm/i915/skl: Define shared DPLLs for Skylake
      drm/i915/skl: Adjust the port PLL selection code
      drm/i915/skl: Implementation of SKL DPLL programming

Sean Paul (6):
      gpu: host1x: mipi: Preserve the contents of MIPI_CAL_CTRL
      gpu: host1x: mipi: Calibrate clock lanes
      gpu: host1x: mipi: Set MIPI_CAL_BIAS_PAD_CFG1 register
      drm/tegra: DPMS off/on in encoder prepare/commit
      drm/tegra: dsi: Set up PHY_TIMING & BTA_TIMING registers earlier
      drm/Documentation: Fix rowspan value in drm-kms-properties

Sonika Jindal (2):
      drm/i915/skl: Add 180 degree HW rotation support
      drm/i915: Update plane parameters for cursor plane (v2)

Stefan Brüns (3):
      drm/edid: move drm_edid_is_zero to top, make edid argument const
      drm/edid: shorten log output in case of all zeroes edid block
      drm/edid: new drm_edid_block_checksum helper function V3

Stephane Viau (4):
      drm/msm/mdp5: get the core clock rate from MDP5 config
      drm/msm/mdp5: make SMP module dynamically configurable
      drm/msm/mdp5: introduce mdp5_cfg module
      drm/msm: add multiple CRTC and overlay support

Takashi Iwai (1):
      drm: Fix memory leak at error path of drm_read()

Tetsuo Handa (1):
      drm/ttm: Avoid memory allocation from shrinker functions.

Thierry Reding (82):
      drm/panel: simple: Add missing .bpc fields
      drm/panel: ld9040: Fix build warnings on 64-bit
      drm/panel: s6e8aa0: Fix build warnings on 64-bit
      drm: Use size_t for blob property sizes
      drm: Use const data when creating blob properties
      drm/gem: Fix typo in kerneldoc
      drm/prime: Use unsigned type for number of pages
      drm: Implement drm_get_pci_dev() dummy for !PCI
      drm: Make drm_mode_create_tv_properties() signature consistent
      drm/gma500: mdfld: Reuse video/mipi_display.h
      video/hdmi: Relicense header under MIT license
      drm/gem: Fix a few kerneldoc typos
      drm/doc: mm: Fix indentation
      drm/doc: Add GEM/CMA helpers to kerneldoc
      drm/cma: Introduce drm_gem_cma_dumb_create_internal()
      drm/omap: gem: dumb: pitch is an output
      drm/rcar: gem: dumb: pitch is an output
      drm: Sanitize DRM_IOCTL_MODE_CREATE_DUMB input
      drm/cma: Remove call to drm_gem_free_mmap_offset()
      drm/dsi: Introduce packet format helpers
      drm/dsi: Add message to packet translator
      drm/dsi: Add DSI transfer helper
      drm/dsi: Make mipi_dsi_dcs_{read,write}() symmetrical
      drm/dsi: Constify mipi_dsi_msg
      drm/panel: s6e8aa0: Use standard MIPI DSI function
      drm/dsi: Implement generic read and write commands
      drm/dsi: Add to DocBook documentation
      drm/dsi: Implement DCS nop command
      drm/dsi: Implement DCS soft_reset command
      drm/dsi: Implement DCS get_power_mode command
      drm/dsi: Implement DCS {get,set}_pixel_format commands
      drm/dsi: Implement DCS set_{column,page}_address commands
      drm/dsi: Resolve MIPI DSI device from phandle
      drm/dsi: Do not require .owner field to be set
      drm/panel: Add Sharp LQ101R1SX01 support
      Merge branch 'drm/panel/for-next' into drm/tegra/for-next
      drm/tegra: Depend on COMMON_CLK
      gpu: host1x: Use struct host1x_bo pointers in traces
      gpu: host1x: Make mapped field of push buffers void *
      gpu: host1x: Fix typo in comment
      gpu: host1x: Print address/offset pairs consistently
      gpu: host1x: Make gather offsets unsigned
      gpu: host1x: mipi: Registers are 32 bits wide
      drm/tegra: dc: Add powergate support
      drm/tegra: Do not enable output on .mode_set()
      drm/tegra: dsi: Make FIFO depths host parameters
      drm/tegra: dsi: Do not manage clock on enable/disable
      drm/tegra: dsi: Leave parent clock alone
      drm/tegra: dsi: Mark connector hotpluggable
      drm/tegra: dsi: Properly cleanup on probe failure
      drm/tegra: dsi: Refactor in preparation for command mode
      drm/tegra: dsi: Add command mode support
      drm/tegra: dsi: Split out tegra_dsi_set_timeout()
      drm/tegra: dsi: Add ganged mode support
      drm/tegra: dsi: Implement host transfers
      drm/tegra: dsi: Replace 1000000000UL by NSEC_PER_SEC
      drm/tegra: dsi: Replace 1000000 by USEC_PER_SEC
      drm/tegra: gem: Extract tegra_bo_alloc_object()
      drm/tegra: gem: Cleanup tegra_bo_create_with_handle()
      drm/tegra: gem: Remove redundant drm_gem_free_mmap_offset()
      drm/tegra: gem: Use dma_mmap_writecombine()
      drm/tegra: Fix error handling cleanup
      drm/tegra: Add IOMMU support
      drm/tegra: dc: Factor out DC, window and cursor commit
      drm/tegra: dc: Registers are 32 bits wide
      drm/tegra: dc: Universal plane support
      drm/tegra: Enable the hotplug interrupt only when necessary
      drm/tegra: gem: dumb: pitch and size are outputs
      drm/tegra: fb: Do not destroy framebuffer
      drm/tegra: gem: Use more consistent data types
      drm/tegra: Plug memory leak
      drm/tegra: Detach panel when a connector is removed
      drm/tegra: fb: Properly release GEM objects on failure
      drm/tegra: fb: Add error codes to error messages
      drm/tegra: gem: Check before freeing CMA memory
      drm/plane: Pass old state to ->atomic_update()
      drm/plane: Add missing kerneldoc
      drm: Make drm_atomic_helper.h standalone includible
      drm: Make drm_atomic.h standalone includible
      drm: Free atomic state during cleanup
      drm/edid: Restore kerneldoc consistency
      drm: Zero out DRM object memory upon cleanup

Thomas Daniel (5):
      drm/i915/bdw: Setup global hardware status page in execlists mode
      drm/i915/bdw: Clean up execlist queue items in retire_work
      drm/i915/bdw: Pin the ringbuffer backing object to GGTT on-demand
      drm/i915: Don't pin LRC in GGTT when dumping in debugfs
      drm/i915: Fix context object leak for legacy contexts

Thomas Hellstrom (5):
      drm/gem: Warn on illegal use of the dumb buffer interface v2
      drm/vmwgfx: Fix error printout on signals pending
      drm/vmwgfx: Don't use memory accounting for kernel-side fence objects
      drm/vmwgfx: Fix fence event code
      drm/vmwgfx: (Re)bind shaders to MOBs with the correct offset

Todd Previte (1):
      drm/dp: Add counters in the drm_dp_aux struct for I2C NACKs and DEFERs

Tom O'Rourke (5):
      drm/i915: Extend pcode mailbox interface
      drm/i915: Use efficient frequency for HSW/BDW
      drm/i915: Keep min freq above floor on HSW/BDW
      drm/i915: change initial rps frequency for gen8
      drm/i915: Update ring freq for full gpu freq range

Tvrtko Ursulin (3):
      drm/i915: Move flags describing VMA mappings into the VMA
      drm/i915: Make intel_pin_and_fence_fb_obj take plane and framebuffer
      drm/i915/skl: Use correct use counters for force wakes

Vandana Kannan (3):
      drm/i915/gen9: Add 2us read latency to WM level
      drm/i915/gen9: Disable WM if corresponding latency is 0
      drm/i915/skl: Apply eDP WA only for gen < 9

Ville Syrjälä (76):
      drm/i915: Move the cursor_base setup to i{845, 9xx}_update_cursor()
      drm/i915: Only set CURSOR_PIPE_CSC_ENABLE when cursor is enabled
      drm/i915: Move vblank enable earlier and disable later
      drm/i915: De-magic the PSR AUX message
      drm/i915: Make sure hardware uses the correct swing margin/deemph bits on chv
      drm/i915: Clear TX FIFO reset master override bits on chv
      drm/i915: Add missing '\n' to cdclk debug message
      drm/i915: Don't claim that we're resetting PCH ADPA register
      drm/i915: Fix chv PCS DW11 register defines
      drm/i915: Add rotation support for cursor plane (v5)
      drm/i915: Warn if trying to register eDP on port != B/C on vlv/chv
      drm/i915: Remove high level intel_edp_vdd_{on, off}() from hpd/detect
      drm/i915: Store power sequencer delays in intel_dp
      drm/i915: Don't initialize power seqeuencer delays more than once
      drm/i915: Split power sequencer panel on/off functions to locked and unlocked variants
      drm/i915: Hold the pps mutex across the whole panel power enable sequence
      drm/i915: Wait for PHY port ready before link training on VLV/CHV
      drm/i915: Fix eDP link training when switching pipes on VLV/CHV
      drm/i915: Kick the power sequencer before AUX transactions
      drm/i915: Don't kick the power seqeuncer just to check if we have vdd/panel power
      drm/i915: Clear PPS port select when giving up the power sequencer
      drm/i915: Warn if stealing non pipe A/B power sequencer
      drm/i915: Steal power sequencer in vlv_power_sequencer_pipe()
      drm/i915: Improve VDD/PPS debugs
      drm/i915: Warn if panel power is already on when enabling it
      drm/i915: Warn if stealing power sequencer from an active eDP port
      drm/i915: Make sure DPLL is enabled when kicking the power sequencer on VLV/CHV
      drm/i915: Do vlv cmnlane toggle w/a in more cases
      drm/i915: Initialize new chv primary plane and pipe blender registers
      drm/i915: Add support for CHV pipe B sprite CSC
      drm/i915: Enable pipe-a power well on chv
      drm/i915: Initialize PPS timestamps on vlv/chv
      drm/i915: Read out the power sequencer port assignment on resume on vlv/chv
      drm/i915: Apply some ocd for IMR vs. IER order during irq enable
      drm/i915: Use DPINVGTT_STATUS_MASK
      drm/i915: Use gen8_gt_irq_reset() in cherryview_irq_uninstall()
      drm/i915: Drop the extra GEN8_PCU_IIR posting read from cherryview_irq_preinstall()
      drm/i915: Use a consistent order between IIR, IER, IMR writes on vlv/chv
      drm/i915: Use GEN5_IRQ_RESET() on vlv/chv
      drm/i915: Call gen5_gt_irq_reset() from valleyview_irq_uninstall()
      drm/i915: Make valleyview_display_irqs_(un)install() work for chv
      drm/i915: Refactor vlv_display_irq_reset()
      drm/i914: Refactor vlv_display_irq_postinstall()
      drm/i915: Drop useless VLV_IIR writes from vlv_display_irq_postinstall()
      drm/i915: Kill leftover GTIIR writes from valleyview_irq_preinstall()
      drm/i915: Move the .global_resources() hook call into modeset_update_crtc_power_domains()
      drm/i915: Cache HPLL frequency on VLV/CHV
      drm/i915: Warn if trying to poke a VLV backlight on invalid pipe
      drm/i915: Skip .get_backlight() when backlight isn't enabled
      drm/i915: Don't deref NULL crtc in intel_get_pipe_from_connector()
      drm/i915: Pass the current pipe from eDP init to backlight setup
      drm/i915: Register the backlight device after the modeset init
      drm/i915: Remove most INVALID_PIPE checks from the backlight code
      drm/i915: Read the CCK fuse register from CCK
      drm/i915: Refactor vlv_display_irq_uninstall()
      drm/i915: Use vlv display irq setup code for chv
      drm/i915: Fix comments about CHV snoop behaviour
      drm/i915: Reinit display irqs and hpd from chv pipe-a power well
      drm/i915: Silence valleyview_set_rps()
      drm/i915: Add a name for the Punit GPLLENABLE bit
      drm/i915: Warn if GPLL isn't used on vlv/chv
      drm/i915: Improve PCBR debug information
      drm/i915: Refactor vlv/chv GPU frequency divider setup
      drm/i915: Add missing newline to 'DDR speed' debug messages
      drm/i915: Change CHV SKU400 GPU freq divider to 10
      drm/i915: Drop the HSW special case from __gen6_gt_wait_for_thread_c0()
      drm/i915: Drop WaRsForcewakeWaitTC0:vlv
      drm/i915: Read power well status before other registers for drpc info
      drm/i915: Don't clobber crtc->new_config when nothing changes
      drm/i915: Fix gen4 GPU reset
      drm/i915: Restore the display config after a GPU reset on gen4
      drm/i915: Implement GPU reset for 915/945
      drm/i915: Implement GPU reset for g33
      drm/i915: Grab modeset locks for GPU rest on pre-ctg
      drm/i915: Disable crtcs gracefully before GPU reset on gen3/4
      drm/i915: Reject modeset when the same digital port is used more than once

Vince Hsu (4):
      soc/tegra: fuse: export tegra_sku_info
      drm/nouveau/volt: allow non-bios voltage scaling
      drm/nouveau/platform: add GPU speedo information to nouveau platform
      drm/nouveau/volt: add support for GK20A

Vivek Gautam (1):
      drm/exynos: dp: Remove support for unused dptx-phy

YoungJun Cho (14):
      drm/dsi: Add mipi_dsi_set_maximum_return_packet_size() helper
      drm/dsi: Implement some standard DCS commands
      drm/exynos: dsi: support Exynos4415 SoC
      drm/exynos: fimd: support Exynos4415 SoC
      drm/exynos: fimd: remove unnecessary waiting vblank routine
      drm/exynos: fimd: move handle vblank position in TE handler
      drm/exynos: dsi: move DSIM_STATE_ENABLED set position
      drm/exynos: fimd: move shadow unprotection position
      drm/exynos: fimd: add fimd_enable_video_output() to cleanup
      drm/exynos: fimd: add fimd_enable_shadow_channel_path() to cleanup
      drm/exynos: fimd: modify I80 i/f irq relevant routine
      drm/exynos: fimd: add triggering unset routine in fimd_trigger()
      drm/exynos: dsi: move TE irq handler registration position
      drm/exynos: dsi: set TE GPIO IRQ status as IRQ_NOAUTOEN

Yu Zhang (1):
      drm/i915: use macros to assign mmio access functions

Zach Reizner (2):
      drm/cirrus: fix leaky driver load error handling
      drm/cirrus: allow 32bpp framebuffers for cirrus drm

Zhe Wang (4):
      drm/i915/skl: Gen9 Forcewake
      drm/i915/skl: Enable Gen9 RC6
      drm/i915/skl: Gen9 multi-engine forcewake
      drm/i915: Gen9 shadowed registers

benjamin.gaignard@linaro.org (1):
      drm: sti: fix module compilation issue

kbuild test robot (2):
      amdkfd: test_kq() can be static
      amdkfd: pqm_get_kernel_queue() can be static

 CREDITS                                            |    7 +
 Documentation/DocBook/drm.tmpl                     |  434 +-
 .../{staging/imx-drm => drm/imx}/fsl-imx-drm.txt   |    0
 .../bindings/{staging/imx-drm => drm/imx}/hdmi.txt |    0
 .../bindings/{staging/imx-drm => drm/imx}/ldb.txt  |    0
 .../bindings/gpu/nvidia,tegra20-host1x.txt         |    2 +
 .../devicetree/bindings/gpu/st,stih4xx.txt         |   29 +-
 .../devicetree/bindings/iommu/rockchip,iommu.txt   |   26 +
 .../devicetree/bindings/panel/auo,b116xw03.txt     |    7 +
 .../bindings/panel/hannstar,hsd070pww1.txt         |    7 +
 .../bindings/panel/hit,tx23d38vm0caa.txt           |    7 +
 .../bindings/panel/innolux,g121i1-l01.txt          |    7 +
 .../bindings/panel/sharp,lq101r1sx01.txt           |   49 +
 .../devicetree/bindings/vendor-prefixes.txt        |    2 +
 .../devicetree/bindings/video/adi,adv7511.txt      |   88 +
 .../devicetree/bindings/video/exynos_dsim.txt      |    1 +
 .../devicetree/bindings/video/rockchip-drm.txt     |   19 +
 .../devicetree/bindings/video/rockchip-vop.txt     |   58 +
 .../devicetree/bindings/video/samsung-fimd.txt     |    1 +
 MAINTAINERS                                        |   17 +
 arch/arm/boot/dts/r8a7779-marzen.dts               |   83 +
 arch/arm/boot/dts/r8a7779.dtsi                     |   24 +
 arch/arm/boot/dts/r8a7790-lager.dts                |   53 +-
 arch/arm/boot/dts/r8a7790.dtsi                     |   90 +
 arch/arm/boot/dts/r8a7791-koelsch.dts              |   16 +-
 arch/arm/boot/dts/r8a7791.dtsi                     |   69 +
 arch/arm/boot/dts/r8a77xx-aa104xd12-panel.dtsi     |   41 +
 arch/arm/mach-shmobile/board-ape6evm-reference.c   |    4 -
 arch/arm/mach-shmobile/board-ape6evm.c             |    4 -
 arch/arm/mach-shmobile/board-armadillo800eva.c     |    5 -
 arch/arm/mach-shmobile/board-bockw-reference.c     |    4 -
 arch/arm/mach-shmobile/board-bockw.c               |    4 -
 arch/arm/mach-shmobile/board-koelsch-reference.c   |   77 -
 arch/arm/mach-shmobile/board-koelsch.c             |    4 -
 arch/arm/mach-shmobile/board-kzm9g-reference.c     |    4 -
 arch/arm/mach-shmobile/board-kzm9g.c               |    4 -
 arch/arm/mach-shmobile/board-lager-reference.c     |   84 -
 arch/arm/mach-shmobile/board-lager.c               |   62 -
 arch/arm/mach-shmobile/board-mackerel.c            |    4 -
 arch/arm/mach-shmobile/board-marzen-reference.c    |    4 -
 arch/arm/mach-shmobile/board-marzen.c              |   62 -
 arch/arm/mach-shmobile/clock-r8a73a4.c             |    4 -
 arch/arm/mach-shmobile/clock-r8a7740.c             |    4 -
 arch/arm/mach-shmobile/clock-r8a7778.c             |    4 -
 arch/arm/mach-shmobile/clock-r8a7779.c             |    4 -
 arch/arm/mach-shmobile/clock-r8a7790.c             |    4 -
 arch/arm/mach-shmobile/clock-r8a7791.c             |    4 -
 arch/arm/mach-shmobile/clock-sh7372.c              |    4 -
 arch/arm/mach-shmobile/clock-sh73a0.c              |    4 -
 arch/arm/mach-shmobile/clock.c                     |    4 -
 arch/arm/mach-shmobile/console.c                   |    4 -
 arch/arm/mach-shmobile/headsmp-scu.S               |    5 -
 arch/arm/mach-shmobile/intc-sh7372.c               |    4 -
 arch/arm/mach-shmobile/intc-sh73a0.c               |    4 -
 arch/arm/mach-shmobile/r8a7740.h                   |    4 -
 arch/arm/mach-shmobile/r8a7778.h                   |    4 -
 arch/arm/mach-shmobile/setup-emev2.c               |    4 -
 arch/arm/mach-shmobile/setup-r7s72100.c            |    4 -
 arch/arm/mach-shmobile/setup-r8a73a4.c             |    4 -
 arch/arm/mach-shmobile/setup-r8a7740.c             |    4 -
 arch/arm/mach-shmobile/setup-r8a7778.c             |    4 -
 arch/arm/mach-shmobile/setup-r8a7779.c             |    4 -
 arch/arm/mach-shmobile/setup-r8a7790.c             |    4 -
 arch/arm/mach-shmobile/setup-r8a7791.c             |    4 -
 arch/arm/mach-shmobile/setup-rcar-gen2.c           |    4 -
 arch/arm/mach-shmobile/setup-sh7372.c              |    4 -
 arch/arm/mach-shmobile/setup-sh73a0.c              |    4 -
 arch/arm/mach-shmobile/sleep-sh7372.S              |    5 -
 arch/arm/mach-shmobile/smp-emev2.c                 |    4 -
 arch/arm/mach-shmobile/smp-r8a7779.c               |    4 -
 arch/arm/mach-shmobile/smp-sh73a0.c                |    4 -
 arch/arm/mach-shmobile/timer.c                     |    5 -
 arch/x86/kernel/early-quirks.c                     |   23 +
 drivers/char/agp/intel-gtt.c                       |    4 -
 drivers/gpu/drm/Kconfig                            |    6 +
 drivers/gpu/drm/Makefile                           |    7 +-
 drivers/gpu/drm/README.drm                         |   43 -
 drivers/gpu/drm/amd/amdkfd/Kconfig                 |    9 +
 drivers/gpu/drm/amd/amdkfd/Makefile                |   14 +
 drivers/gpu/drm/amd/amdkfd/cik_regs.h              |  221 +
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  595 ++
 drivers/gpu/drm/amd/amdkfd/kfd_crat.h              |  294 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  308 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  | 1062 +++
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |  146 +
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c          |  256 +
 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c       |  356 +
 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c         |  176 +
 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c      |  353 +
 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.h      |   69 +
 drivers/gpu/drm/amd/amdkfd/kfd_module.c            |  159 +
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c       |  346 +
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h       |   91 +
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager.c    |  565 ++
 drivers/gpu/drm/amd/amdkfd/kfd_pasid.c             |   96 +
 drivers/gpu/drm/amd/amdkfd/kfd_pm4_headers.h       |  405 ++
 drivers/gpu/drm/amd/amdkfd/kfd_pm4_opcodes.h       |  107 +
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  600 ++
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  410 ++
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  343 +
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |   85 +
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          | 1235 ++++
 drivers/gpu/drm/amd/amdkfd/kfd_topology.h          |  168 +
 drivers/gpu/drm/amd/include/kgd_kfd_interface.h    |  185 +
 drivers/gpu/drm/armada/armada_crtc.c               |    1 +
 drivers/gpu/drm/ast/ast_mode.c                     |    1 +
 drivers/gpu/drm/bochs/bochs_fbdev.c                |   18 +-
 drivers/gpu/drm/bochs/bochs_hw.c                   |   23 +-
 drivers/gpu/drm/bochs/bochs_kms.c                  |   22 +
 drivers/gpu/drm/cirrus/cirrus_drv.h                |    3 +
 drivers/gpu/drm/cirrus/cirrus_fbdev.c              |    5 +-
 drivers/gpu/drm/cirrus/cirrus_main.c               |   40 +-
 drivers/gpu/drm/cirrus/cirrus_mode.c               |    1 +
 drivers/gpu/drm/drm_atomic.c                       |  657 ++
 drivers/gpu/drm/drm_atomic_helper.c                | 1966 ++++++
 drivers/gpu/drm/drm_crtc.c                         |  581 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |  132 +
 drivers/gpu/drm/drm_dp_helper.c                    |  201 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   68 +-
 drivers/gpu/drm/drm_drv.c                          |    7 +-
 drivers/gpu/drm/drm_edid.c                         |  231 +-
 drivers/gpu/drm/drm_edid_load.c                    |    3 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  135 +-
 drivers/gpu/drm/drm_flip_work.c                    |  105 +-
 drivers/gpu/drm/drm_fops.c                         |   13 +-
 drivers/gpu/drm/drm_gem.c                          |   13 +-
 drivers/gpu/drm/drm_gem_cma_helper.c               |  259 +-
 drivers/gpu/drm/drm_irq.c                          |    9 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |  660 +-
 drivers/gpu/drm/drm_modes.c                        |    2 +-
 drivers/gpu/drm/drm_modeset_lock.c                 |   43 +-
 drivers/gpu/drm/drm_plane_helper.c                 |  203 +-
 drivers/gpu/drm/drm_prime.c                        |    6 +-
 drivers/gpu/drm/drm_probe_helper.c                 |    3 +-
 drivers/gpu/drm/exynos/exynos_dp_core.c            |  132 +-
 drivers/gpu/drm/exynos/exynos_dp_core.h            |    5 +-
 drivers/gpu/drm/exynos/exynos_drm_crtc.h           |    5 +-
 drivers/gpu/drm/exynos/exynos_drm_dpi.c            |   42 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |  252 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |   83 +-
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            |  129 +-
 drivers/gpu/drm/exynos/exynos_drm_encoder.h        |    2 -
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  266 +-
 drivers/gpu/drm/exynos/exynos_drm_iommu.h          |    1 -
 drivers/gpu/drm/exynos/exynos_drm_ipp.c            |    3 +
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |  150 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   65 +-
 drivers/gpu/drm/exynos/exynos_mixer.c              |  126 +-
 drivers/gpu/drm/gma500/Makefile                    |    1 +
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |  195 +
 drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c      |   75 +-
 drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.h      |   12 -
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |   31 +-
 drivers/gpu/drm/gma500/oaktrail_lvds_i2c.c         |  170 +
 drivers/gpu/drm/gma500/psb_drv.c                   |   20 +
 drivers/gpu/drm/gma500/psb_drv.h                   |    3 +
 drivers/gpu/drm/gma500/psb_intel_display.c         |    1 +
 drivers/gpu/drm/gma500/psb_intel_drv.h             |    1 +
 drivers/gpu/drm/gma500/psb_intel_sdvo.c            |   49 -
 drivers/gpu/drm/i2c/Kconfig                        |    6 +
 drivers/gpu/drm/i2c/Makefile                       |    2 +
 drivers/gpu/drm/i2c/adv7511.c                      | 1010 +++
 drivers/gpu/drm/i2c/adv7511.h                      |  289 +
 drivers/gpu/drm/i915/Makefile                      |   13 +-
 drivers/gpu/drm/i915/i915_cmd_parser.c             |   39 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |  270 +-
 drivers/gpu/drm/i915/i915_dma.c                    | 1070 +--
 drivers/gpu/drm/i915/i915_drv.c                    |  359 +-
 drivers/gpu/drm/i915/i915_drv.h                    |  311 +-
 drivers/gpu/drm/i915/i915_gem.c                    |  645 +-
 drivers/gpu/drm/i915/i915_gem_context.c            |   18 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   87 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |   96 +-
 drivers/gpu/drm/i915/i915_gem_gtt.h                |   10 +-
 drivers/gpu/drm/i915/i915_gem_render_state.c       |    2 +
 drivers/gpu/drm/i915/i915_gem_stolen.c             |    8 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c             |   60 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |   43 +-
 drivers/gpu/drm/i915/i915_ioc32.c                  |    2 -
 drivers/gpu/drm/i915/i915_irq.c                    | 1000 ++-
 drivers/gpu/drm/i915/i915_reg.h                    |  643 +-
 drivers/gpu/drm/i915/i915_suspend.c                |   57 +-
 drivers/gpu/drm/i915/i915_sysfs.c                  |   22 +-
 drivers/gpu/drm/i915/i915_trace.h                  |  104 +
 drivers/gpu/drm/i915/i915_ums.c                    |   14 +
 drivers/gpu/drm/i915/intel_audio.c                 |  463 ++
 drivers/gpu/drm/i915/intel_bios.h                  |   10 +-
 drivers/gpu/drm/i915/intel_crt.c                   |    4 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |  719 +-
 drivers/gpu/drm/i915/intel_display.c               | 2885 ++++----
 drivers/gpu/drm/i915/intel_dp.c                    |  985 ++-
 drivers/gpu/drm/i915/intel_dp_mst.c                |   16 +-
 drivers/gpu/drm/i915/intel_drv.h                   |  212 +-
 drivers/gpu/drm/i915/intel_dsi.c                   |    2 +-
 drivers/gpu/drm/i915/intel_fbdev.c                 |   44 +-
 drivers/gpu/drm/i915/intel_fifo_underrun.c         |  381 ++
 drivers/gpu/drm/i915/intel_frontbuffer.c           |  279 +
 drivers/gpu/drm/i915/intel_hdmi.c                  |  120 +-
 drivers/gpu/drm/i915/intel_lrc.c                   |  338 +-
 drivers/gpu/drm/i915/intel_lrc.h                   |    6 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |    4 +-
 drivers/gpu/drm/i915/intel_panel.c                 |  136 +-
 drivers/gpu/drm/i915/intel_pm.c                    | 6911 ++++++++++----------
 drivers/gpu/drm/i915/intel_psr.c                   |  481 ++
 drivers/gpu/drm/i915/intel_renderstate.h           |    1 +
 drivers/gpu/drm/i915/intel_renderstate_gen8.c      |  802 ++-
 drivers/gpu/drm/i915/intel_renderstate_gen9.c      |  974 +++
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  419 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   12 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c            | 1406 ++++
 drivers/gpu/drm/i915/intel_sdvo.c                  |   47 -
 drivers/gpu/drm/i915/intel_sprite.c                |  605 +-
 drivers/gpu/drm/i915/intel_tv.c                    |    9 +-
 drivers/gpu/drm/i915/intel_uncore.c                |  495 +-
 drivers/{staging/imx-drm => gpu/drm/imx}/Kconfig   |    0
 drivers/{staging/imx-drm => gpu/drm/imx}/Makefile  |    0
 .../imx-drm => gpu/drm/imx}/imx-drm-core.c         |    1 +
 drivers/{staging/imx-drm => gpu/drm/imx}/imx-drm.h |    0
 .../{staging/imx-drm => gpu/drm/imx}/imx-hdmi.c    |    0
 .../{staging/imx-drm => gpu/drm/imx}/imx-hdmi.h    |    0
 drivers/{staging/imx-drm => gpu/drm/imx}/imx-ldb.c |    0
 drivers/{staging/imx-drm => gpu/drm/imx}/imx-tve.c |    0
 .../{staging/imx-drm => gpu/drm/imx}/ipuv3-crtc.c  |    0
 .../{staging/imx-drm => gpu/drm/imx}/ipuv3-plane.c |    0
 .../{staging/imx-drm => gpu/drm/imx}/ipuv3-plane.h |    0
 .../imx-drm => gpu/drm/imx}/parallel-display.c     |    0
 drivers/gpu/drm/mgag200/mgag200_mode.c             |    1 +
 drivers/gpu/drm/msm/Kconfig                        |    1 +
 drivers/gpu/drm/msm/Makefile                       |    4 +
 drivers/gpu/drm/msm/adreno/a2xx.xml.h              |   26 +-
 drivers/gpu/drm/msm/adreno/a3xx.xml.h              |  247 +-
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |   91 +
 drivers/gpu/drm/msm/adreno/a4xx.xml.h              | 2144 ++++++
 drivers/gpu/drm/msm/adreno/a4xx_gpu.c              |  604 ++
 drivers/gpu/drm/msm/adreno/a4xx_gpu.h              |   34 +
 drivers/gpu/drm/msm/adreno/adreno_common.xml.h     |   17 +-
 drivers/gpu/drm/msm/adreno/adreno_device.c         |   13 +
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   31 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.h            |  126 +
 drivers/gpu/drm/msm/adreno/adreno_pm4.xml.h        |   75 +-
 drivers/gpu/drm/msm/dsi/dsi.xml.h                  |    8 +-
 drivers/gpu/drm/msm/dsi/mmss_cc.xml.h              |    8 +-
 drivers/gpu/drm/msm/dsi/sfpb.xml.h                 |    8 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |  144 +-
 drivers/gpu/drm/msm/hdmi/hdmi.h                    |   17 -
 drivers/gpu/drm/msm/hdmi/hdmi.xml.h                |    8 +-
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c             |    3 +-
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c          |    7 +-
 drivers/gpu/drm/msm/hdmi/hdmi_phy_8960.c           |    2 +-
 drivers/gpu/drm/msm/hdmi/qfprom.xml.h              |    8 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4.xml.h            |    8 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c           |  348 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c            |   17 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.h            |   17 -
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c |    3 +
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c          |  121 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h            |   10 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c            |  207 +
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h            |   91 +
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c           |  466 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c            |  322 +
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h            |  122 +
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c        |   24 +
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_irq.c            |   93 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c            |  273 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h            |  131 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c          |  328 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c            |  241 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.h            |   23 +-
 drivers/gpu/drm/msm/msm_atomic.c                   |  163 +
 drivers/gpu/drm/msm/msm_drv.c                      |   25 +
 drivers/gpu/drm/msm/msm_drv.h                      |   35 +-
 drivers/gpu/drm/msm/msm_fb.c                       |   45 +-
 drivers/gpu/drm/msm/msm_fbdev.c                    |    3 -
 drivers/gpu/drm/msm/msm_gem.c                      |   40 +-
 drivers/gpu/drm/msm/msm_gem.h                      |   13 +
 drivers/gpu/drm/msm/msm_gem_prime.c                |   13 +
 drivers/gpu/drm/nouveau/Makefile                   |   18 +
 drivers/gpu/drm/nouveau/core/core/handle.c         |  113 -
 drivers/gpu/drm/nouveau/core/engine/device/base.c  |   14 +-
 drivers/gpu/drm/nouveau/core/engine/device/gm100.c |   43 +
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |    1 +
 drivers/gpu/drm/nouveau/core/engine/disp/dport.c   |    9 +-
 drivers/gpu/drm/nouveau/core/engine/disp/gm107.c   |   16 +-
 drivers/gpu/drm/nouveau/core/engine/disp/gm204.c   |  114 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |   94 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.h    |   63 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv84.c    |   40 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv94.c    |   30 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nva0.c    |   16 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nva3.c    |   16 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c    |   99 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nve0.c    |   30 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nvf0.c    |   16 +-
 drivers/gpu/drm/nouveau/core/engine/disp/outp.c    |    5 +-
 .../gpu/drm/nouveau/core/engine/disp/sorgm204.c    |  144 +
 drivers/gpu/drm/nouveau/core/engine/disp/sornvd0.c |    2 +-
 drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.c  |    1 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |   48 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |    2 +-
 drivers/gpu/drm/nouveau/core/include/core/device.h |    9 +-
 drivers/gpu/drm/nouveau/core/include/core/handle.h |    5 -
 drivers/gpu/drm/nouveau/core/include/core/object.h |   17 -
 drivers/gpu/drm/nouveau/core/include/engine/disp.h |    1 +
 .../drm/nouveau/core/include/subdev/bios/M0203.h   |   31 +
 .../gpu/drm/nouveau/core/include/subdev/bios/i2c.h |   14 +-
 .../drm/nouveau/core/include/subdev/bios/image.h   |   13 +
 .../drm/nouveau/core/include/subdev/bios/npde.h    |   12 +
 .../drm/nouveau/core/include/subdev/bios/pcir.h    |   18 +
 .../gpu/drm/nouveau/core/include/subdev/bios/pmu.h |   37 +
 .../drm/nouveau/core/include/subdev/bios/ramcfg.h  |   23 +-
 .../gpu/drm/nouveau/core/include/subdev/devinit.h  |    1 +
 drivers/gpu/drm/nouveau/core/include/subdev/i2c.h  |    3 +
 drivers/gpu/drm/nouveau/core/include/subdev/pwr.h  |    2 +
 drivers/gpu/drm/nouveau/core/include/subdev/volt.h |    1 +
 drivers/gpu/drm/nouveau/core/os.h                  |    1 +
 drivers/gpu/drm/nouveau/core/subdev/bios/M0203.c   |  129 +
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c    |  369 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c     |   27 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/disp.c    |    1 +
 drivers/gpu/drm/nouveau/core/subdev/bios/dp.c      |   10 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/extdev.c  |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c     |   45 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/image.c   |   78 +
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |   56 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/npde.c    |   59 +
 drivers/gpu/drm/nouveau/core/subdev/bios/pcir.c    |   69 +
 drivers/gpu/drm/nouveau/core/subdev/bios/pmu.c     |  135 +
 drivers/gpu/drm/nouveau/core/subdev/bios/priv.h    |   25 +
 drivers/gpu/drm/nouveau/core/subdev/bios/ramcfg.c  |   13 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/rammap.c  |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/shadow.c  |  270 +
 .../gpu/drm/nouveau/core/subdev/bios/shadowacpi.c  |  111 +
 .../gpu/drm/nouveau/core/subdev/bios/shadowof.c    |   71 +
 .../gpu/drm/nouveau/core/subdev/bios/shadowpci.c   |  108 +
 .../gpu/drm/nouveau/core/subdev/bios/shadowramin.c |  112 +
 .../gpu/drm/nouveau/core/subdev/bios/shadowrom.c   |   69 +
 drivers/gpu/drm/nouveau/core/subdev/bios/timing.c  |   42 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/gk20a.c  |   17 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/base.c |    4 +-
 .../gpu/drm/nouveau/core/subdev/devinit/gm107.c    |    3 +-
 .../gpu/drm/nouveau/core/subdev/devinit/gm204.c    |  173 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c |    1 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv05.c |    1 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c |    1 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv1a.c |    1 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv20.c |    1 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv50.c |   10 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv50.h |    2 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv84.c |    1 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv98.c |    1 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nva3.c |    1 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nvaf.c |    1 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nvc0.c |    1 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/priv.h |    2 +
 drivers/gpu/drm/nouveau/core/subdev/fb/base.c      |   37 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/gddr3.c     |  117 +
 drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |    1 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramfuc.h    |   16 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c   |  813 ++-
 drivers/gpu/drm/nouveau/core/subdev/fb/sddr2.c     |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/sddr3.c     |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv50.c    |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c     |   97 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/gm204.c    |  221 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv50.h     |    6 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv94.c     |   13 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nvd0.c     |    6 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nve0.c     |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/padgm204.c |   86 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/priv.h     |    4 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/memx.fuc   |  111 +
 .../drm/nouveau/core/subdev/pwr/fuc/nv108.fuc.h    |  738 ++-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nva3.fuc.h |  863 ++-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvc0.fuc.h |  828 ++-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvd0.fuc.h |  754 ++-
 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/os.h   |    5 +
 drivers/gpu/drm/nouveau/core/subdev/pwr/memx.c     |   37 +-
 drivers/gpu/drm/nouveau/core/subdev/volt/base.c    |   67 +-
 drivers/gpu/drm/nouveau/core/subdev/volt/gk20a.c   |  199 +
 drivers/gpu/drm/nouveau/dispnv04/crtc.c            |    5 +-
 drivers/gpu/drm/nouveau/dispnv04/overlay.c         |    4 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |   26 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  196 +-
 drivers/gpu/drm/nouveau/nouveau_bo.h               |    5 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   11 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |   30 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  248 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   36 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   15 +
 drivers/gpu/drm/nouveau/nouveau_platform.c         |    2 +
 drivers/gpu/drm/nouveau/nouveau_platform.h         |    2 +
 drivers/gpu/drm/nouveau/nouveau_prime.c            |    2 +-
 drivers/gpu/drm/nouveau/nv17_fence.c               |    2 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |  134 +-
 drivers/gpu/drm/nouveau/nv50_fence.c               |    2 +-
 drivers/gpu/drm/nouveau/nv84_fence.c               |    8 +-
 drivers/gpu/drm/nouveau/nvif/class.h               |    3 +
 drivers/gpu/drm/nouveau/nvif/client.c              |    1 +
 drivers/gpu/drm/nouveau/nvif/driver.h              |    1 +
 drivers/gpu/drm/omapdrm/omap_crtc.c                |    1 +
 drivers/gpu/drm/omapdrm/omap_gem.c                 |    3 +-
 drivers/gpu/drm/omapdrm/omap_plane.c               |   15 +-
 drivers/gpu/drm/panel/Kconfig                      |   13 +
 drivers/gpu/drm/panel/Makefile                     |    1 +
 drivers/gpu/drm/panel/panel-ld9040.c               |   13 +-
 drivers/gpu/drm/panel/panel-s6e8aa0.c              |   30 +-
 drivers/gpu/drm/panel/panel-sharp-lq101r1sx01.c    |  464 ++
 drivers/gpu/drm/panel/panel-simple.c               |  133 +-
 drivers/gpu/drm/qxl/qxl_display.c                  |   36 +-
 drivers/gpu/drm/qxl/qxl_release.c                  |    3 +-
 drivers/gpu/drm/r128/r128_state.c                  |    4 +-
 drivers/gpu/drm/radeon/Makefile                    |    4 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |    1 +
 drivers/gpu/drm/radeon/ci_dpm.c                    |  752 ++-
 drivers/gpu/drm/radeon/ci_dpm.h                    |    8 +
 drivers/gpu/drm/radeon/ci_smc.c                    |    2 +-
 drivers/gpu/drm/radeon/cik.c                       |  214 +-
 drivers/gpu/drm/radeon/cik_reg.h                   |  136 +
 drivers/gpu/drm/radeon/cik_sdma.c                  |   42 +-
 drivers/gpu/drm/radeon/cikd.h                      |   93 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   14 +-
 drivers/gpu/drm/radeon/evergreen_dma.c             |   18 +-
 drivers/gpu/drm/radeon/ni.c                        |   20 +-
 drivers/gpu/drm/radeon/ni_dma.c                    |   17 +-
 drivers/gpu/drm/radeon/ppsmc.h                     |   18 +-
 drivers/gpu/drm/radeon/pptable.h                   |    8 +
 drivers/gpu/drm/radeon/r100.c                      |   10 +-
 drivers/gpu/drm/radeon/r200.c                      |    2 +-
 drivers/gpu/drm/radeon/r300.c                      |    6 +-
 drivers/gpu/drm/radeon/r600.c                      |   18 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |   26 +-
 drivers/gpu/drm/radeon/r600_dma.c                  |   18 +-
 drivers/gpu/drm/radeon/r600_dpm.c                  |    9 +
 drivers/gpu/drm/radeon/r600_dpm.h                  |    3 +
 drivers/gpu/drm/radeon/radeon.h                    |  162 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   18 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |   21 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |  121 +-
 drivers/gpu/drm/radeon/radeon_cursor.c             |  268 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   32 +
 drivers/gpu/drm/radeon/radeon_display.c            |    3 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |    5 +
 drivers/gpu/drm/radeon/radeon_fb.c                 |   32 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |    1 +
 drivers/gpu/drm/radeon/radeon_gem.c                |   92 +-
 drivers/gpu/drm/radeon/radeon_ib.c                 |   16 +-
 drivers/gpu/drm/radeon/radeon_kfd.c                |  563 ++
 drivers/gpu/drm/radeon/radeon_kfd.h                |   47 +
 drivers/gpu/drm/radeon/radeon_kms.c                |    9 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |    1 +
 drivers/gpu/drm/radeon/radeon_mode.h               |   20 +-
 drivers/gpu/drm/radeon/radeon_object.c             |   83 +-
 drivers/gpu/drm/radeon/radeon_object.h             |    2 +
 drivers/gpu/drm/radeon/radeon_semaphore.c          |  154 +-
 drivers/gpu/drm/radeon/radeon_sync.c               |  220 +
 drivers/gpu/drm/radeon/radeon_trace.h              |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   27 +-
 drivers/gpu/drm/radeon/radeon_uvd.c                |   14 +-
 drivers/gpu/drm/radeon/radeon_vce.c                |    8 +-
 drivers/gpu/drm/radeon/radeon_vm.c                 |  236 +-
 drivers/gpu/drm/radeon/rv770_dma.c                 |   18 +-
 drivers/gpu/drm/radeon/si.c                        |   24 +-
 drivers/gpu/drm/radeon/si_dma.c                    |   37 +-
 drivers/gpu/drm/radeon/si_dpm.c                    |  381 +-
 drivers/gpu/drm/radeon/si_dpm.h                    |    5 +
 drivers/gpu/drm/radeon/si_smc.c                    |    2 +-
 drivers/gpu/drm/radeon/sid.h                       |   40 +-
 drivers/gpu/drm/radeon/sislands_smc.h              |   25 +
 drivers/gpu/drm/radeon/smu7_discrete.h             |   30 +-
 drivers/gpu/drm/rcar-du/Kconfig                    |   11 +-
 drivers/gpu/drm/rcar-du/Makefile                   |    2 +
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |    3 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h             |   10 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.c              |    4 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.h              |    2 -
 drivers/gpu/drm/rcar-du/rcar_du_encoder.c          |   45 +-
 drivers/gpu/drm/rcar-du/rcar_du_encoder.h          |   23 +-
 drivers/gpu/drm/rcar-du/rcar_du_hdmicon.c          |  121 +
 drivers/gpu/drm/rcar-du/rcar_du_hdmicon.h          |   31 +
 drivers/gpu/drm/rcar-du/rcar_du_hdmienc.c          |  151 +
 drivers/gpu/drm/rcar-du/rcar_du_hdmienc.h          |   35 +
 drivers/gpu/drm/rcar-du/rcar_du_kms.c              |   57 +-
 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c          |   31 +-
 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.h          |    2 -
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.h          |    1 -
 drivers/gpu/drm/rcar-du/rcar_du_vgacon.c           |    5 +-
 drivers/gpu/drm/rockchip/Kconfig                   |   17 +
 drivers/gpu/drm/rockchip/Makefile                  |    8 +
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |  551 ++
 drivers/gpu/drm/rockchip/rockchip_drm_drv.h        |   68 +
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |  201 +
 drivers/gpu/drm/rockchip/rockchip_drm_fb.h         |   28 +
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c      |  210 +
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h      |   21 +
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |  294 +
 drivers/gpu/drm/rockchip/rockchip_drm_gem.h        |   54 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        | 1455 +++++
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |  201 +
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c          |    1 +
 drivers/gpu/drm/sti/Kconfig                        |    1 +
 drivers/gpu/drm/sti/Makefile                       |    4 +-
 drivers/gpu/drm/sti/sti_compositor.c               |   20 +-
 drivers/gpu/drm/sti/sti_compositor.h               |    2 -
 drivers/gpu/drm/sti/sti_cursor.c                   |  242 +
 drivers/gpu/drm/sti/sti_cursor.h                   |   12 +
 drivers/gpu/drm/sti/sti_drm_crtc.c                 |   24 +-
 drivers/gpu/drm/sti/sti_drm_drv.c                  |    6 +-
 drivers/gpu/drm/sti/sti_drm_plane.c                |    4 +-
 drivers/gpu/drm/sti/sti_gdp.c                      |   62 +-
 drivers/gpu/drm/sti/sti_hdmi.c                     |   84 +-
 drivers/gpu/drm/sti/sti_hdmi.h                     |    6 +-
 drivers/gpu/drm/sti/sti_hqvdp.c                    | 1073 +++
 drivers/gpu/drm/sti/sti_hqvdp.h                    |   12 +
 drivers/gpu/drm/sti/sti_hqvdp_lut.h                |  373 ++
 drivers/gpu/drm/sti/sti_layer.c                    |   18 +-
 drivers/gpu/drm/sti/sti_layer.h                    |   12 +-
 drivers/gpu/drm/sti/sti_mixer.c                    |   17 +
 drivers/gpu/drm/sti/sti_mixer.h                    |    3 +
 drivers/gpu/drm/sti/sti_tvout.c                    |  104 +-
 drivers/gpu/drm/sti/sti_vtg.c                      |   31 +-
 drivers/gpu/drm/tegra/Kconfig                      |    1 +
 drivers/gpu/drm/tegra/dc.c                         |  596 +-
 drivers/gpu/drm/tegra/drm.c                        |   46 +-
 drivers/gpu/drm/tegra/drm.h                        |   18 +-
 drivers/gpu/drm/tegra/dsi.c                        |  811 ++-
 drivers/gpu/drm/tegra/dsi.h                        |   14 +-
 drivers/gpu/drm/tegra/fb.c                         |   52 +-
 drivers/gpu/drm/tegra/gem.c                        |  366 +-
 drivers/gpu/drm/tegra/gem.h                        |   14 +-
 drivers/gpu/drm/tegra/output.c                     |   35 +-
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c               |    7 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |    3 +-
 drivers/gpu/drm/ttm/ttm_bo_manager.c               |    8 +-
 drivers/gpu/drm/ttm/ttm_execbuf_util.c             |   10 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c               |   26 +-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |   25 +-
 drivers/gpu/drm/udl/Makefile                       |    2 +-
 drivers/gpu/drm/udl/udl_dmabuf.c                   |  276 +
 drivers/gpu/drm/udl/udl_drv.c                      |    2 +
 drivers/gpu/drm/udl/udl_drv.h                      |    8 +
 drivers/gpu/drm/udl/udl_gem.c                      |   97 +-
 drivers/gpu/drm/udl/udl_modeset.c                  |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   11 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |    6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |   39 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c               |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |    2 +-
 drivers/gpu/host1x/cdma.c                          |    2 +-
 drivers/gpu/host1x/cdma.h                          |    2 +-
 drivers/gpu/host1x/hw/cdma_hw.c                    |   10 +-
 drivers/gpu/host1x/hw/channel_hw.c                 |   12 +-
 drivers/gpu/host1x/hw/debug_hw.c                   |    4 +-
 drivers/gpu/host1x/job.h                           |    2 +-
 drivers/gpu/host1x/mipi.c                          |  148 +-
 drivers/iommu/Kconfig                              |   12 +
 drivers/iommu/Makefile                             |    1 +
 drivers/iommu/amd_iommu_v2.c                       |   69 +-
 drivers/iommu/rockchip-iommu.c                     | 1038 +++
 drivers/soc/tegra/fuse/fuse-tegra.c                |    1 +
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/imx-drm/TODO                       |   17 -
 include/drm/drmP.h                                 |   27 +-
 include/drm/drm_atomic.h                           |   69 +
 include/drm/drm_atomic_helper.h                    |  126 +
 include/drm/drm_crtc.h                             |  327 +-
 include/drm/drm_crtc_helper.h                      |   13 +
 include/drm/drm_displayid.h                        |   76 +
 include/drm/drm_dp_helper.h                        |   26 +-
 include/drm/drm_dp_mst_helper.h                    |    8 +-
 include/drm/drm_edid.h                             |  109 +
 include/drm/drm_fb_helper.h                        |    6 +
 include/drm/drm_flip_work.h                        |   33 +-
 include/drm/drm_gem.h                              |    7 +
 include/drm/drm_gem_cma_helper.h                   |   30 +-
 include/drm/drm_mipi_dsi.h                         |   94 +-
 include/drm/drm_modeset_lock.h                     |    5 +-
 include/drm/drm_plane_helper.h                     |   44 +
 include/drm/i915_pciids.h                          |   17 +
 include/drm/ttm/ttm_execbuf_util.h                 |    9 +-
 include/linux/hdmi.h                               |   21 +-
 include/linux/mmu_notifier.h                       |   88 +-
 include/linux/platform_data/rcar-du.h              |   74 -
 include/trace/events/host1x.h                      |   27 +-
 include/uapi/drm/drm_mode.h                        |    2 +
 include/uapi/drm/i915_drm.h                        |    7 +
 include/uapi/linux/kfd_ioctl.h                     |  154 +
 kernel/events/uprobes.c                            |    2 +-
 kernel/time/time.c                                 |    1 +
 mm/fremap.c                                        |    2 +-
 mm/huge_memory.c                                   |    9 +-
 mm/hugetlb.c                                       |    7 +-
 mm/ksm.c                                           |    4 +-
 mm/memory.c                                        |    3 +-
 mm/migrate.c                                       |    3 +-
 mm/mmu_notifier.c                                  |   25 +
 mm/rmap.c                                          |    2 +-
 603 files changed, 57040 insertions(+), 17075 deletions(-)
 rename Documentation/devicetree/bindings/{staging/imx-drm => drm/imx}/fsl-imx-drm.txt (100%)
 rename Documentation/devicetree/bindings/{staging/imx-drm => drm/imx}/hdmi.txt (100%)
 rename Documentation/devicetree/bindings/{staging/imx-drm => drm/imx}/ldb.txt (100%)
 create mode 100644 Documentation/devicetree/bindings/iommu/rockchip,iommu.txt
 create mode 100644 Documentation/devicetree/bindings/panel/auo,b116xw03.txt
 create mode 100644 Documentation/devicetree/bindings/panel/hannstar,hsd070pww1.txt
 create mode 100644 Documentation/devicetree/bindings/panel/hit,tx23d38vm0caa.txt
 create mode 100644 Documentation/devicetree/bindings/panel/innolux,g121i1-l01.txt
 create mode 100644 Documentation/devicetree/bindings/panel/sharp,lq101r1sx01.txt
 create mode 100644 Documentation/devicetree/bindings/video/adi,adv7511.txt
 create mode 100644 Documentation/devicetree/bindings/video/rockchip-drm.txt
 create mode 100644 Documentation/devicetree/bindings/video/rockchip-vop.txt
 create mode 100644 arch/arm/boot/dts/r8a77xx-aa104xd12-panel.dtsi
 delete mode 100644 drivers/gpu/drm/README.drm
 create mode 100644 drivers/gpu/drm/amd/amdkfd/Kconfig
 create mode 100644 drivers/gpu/drm/amd/amdkfd/Makefile
 create mode 100644 drivers/gpu/drm/amd/amdkfd/cik_regs.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_crat.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_device.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_module.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_pm4_headers.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_pm4_opcodes.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_priv.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_process.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_queue.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_topology.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_topology.h
 create mode 100644 drivers/gpu/drm/amd/include/kgd_kfd_interface.h
 create mode 100644 drivers/gpu/drm/drm_atomic.c
 create mode 100644 drivers/gpu/drm/drm_atomic_helper.c
 create mode 100644 drivers/gpu/drm/gma500/oaktrail_lvds_i2c.c
 create mode 100644 drivers/gpu/drm/i2c/adv7511.c
 create mode 100644 drivers/gpu/drm/i2c/adv7511.h
 create mode 100644 drivers/gpu/drm/i915/intel_audio.c
 create mode 100644 drivers/gpu/drm/i915/intel_fifo_underrun.c
 create mode 100644 drivers/gpu/drm/i915/intel_frontbuffer.c
 create mode 100644 drivers/gpu/drm/i915/intel_psr.c
 create mode 100644 drivers/gpu/drm/i915/intel_renderstate_gen9.c
 create mode 100644 drivers/gpu/drm/i915/intel_runtime_pm.c
 rename drivers/{staging/imx-drm => gpu/drm/imx}/Kconfig (100%)
 rename drivers/{staging/imx-drm => gpu/drm/imx}/Makefile (100%)
 rename drivers/{staging/imx-drm => gpu/drm/imx}/imx-drm-core.c (99%)
 rename drivers/{staging/imx-drm => gpu/drm/imx}/imx-drm.h (100%)
 rename drivers/{staging/imx-drm => gpu/drm/imx}/imx-hdmi.c (100%)
 rename drivers/{staging/imx-drm => gpu/drm/imx}/imx-hdmi.h (100%)
 rename drivers/{staging/imx-drm => gpu/drm/imx}/imx-ldb.c (100%)
 rename drivers/{staging/imx-drm => gpu/drm/imx}/imx-tve.c (100%)
 rename drivers/{staging/imx-drm => gpu/drm/imx}/ipuv3-crtc.c (100%)
 rename drivers/{staging/imx-drm => gpu/drm/imx}/ipuv3-plane.c (100%)
 rename drivers/{staging/imx-drm => gpu/drm/imx}/ipuv3-plane.h (100%)
 rename drivers/{staging/imx-drm => gpu/drm/imx}/parallel-display.c (100%)
 create mode 100644 drivers/gpu/drm/msm/adreno/a4xx.xml.h
 create mode 100644 drivers/gpu/drm/msm/adreno/a4xx_gpu.c
 create mode 100644 drivers/gpu/drm/msm/adreno/a4xx_gpu.h
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_ctl.h
 create mode 100644 drivers/gpu/drm/msm/msm_atomic.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/gm204.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/sorgm204.c
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/M0203.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/image.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/npde.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/pcir.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/pmu.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/M0203.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/image.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/npde.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/pcir.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/pmu.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/priv.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/shadow.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/shadowacpi.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/shadowof.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/shadowpci.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/shadowramin.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/shadowrom.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/gm204.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/gddr3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/gm204.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/padgm204.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/volt/gk20a.c
 create mode 100644 drivers/gpu/drm/panel/panel-sharp-lq101r1sx01.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_sync.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_hdmicon.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_hdmicon.h
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_hdmienc.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_hdmienc.h
 create mode 100644 drivers/gpu/drm/rockchip/Kconfig
 create mode 100644 drivers/gpu/drm/rockchip/Makefile
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.h
 create mode 100644 drivers/gpu/drm/sti/sti_cursor.c
 create mode 100644 drivers/gpu/drm/sti/sti_cursor.h
 create mode 100644 drivers/gpu/drm/sti/sti_hqvdp.c
 create mode 100644 drivers/gpu/drm/sti/sti_hqvdp.h
 create mode 100644 drivers/gpu/drm/sti/sti_hqvdp_lut.h
 create mode 100644 drivers/gpu/drm/udl/udl_dmabuf.c
 create mode 100644 drivers/iommu/rockchip-iommu.c
 delete mode 100644 drivers/staging/imx-drm/TODO
 create mode 100644 include/drm/drm_atomic.h
 create mode 100644 include/drm/drm_atomic_helper.h
 create mode 100644 include/drm/drm_displayid.h
 delete mode 100644 include/linux/platform_data/rcar-du.h
 create mode 100644 include/uapi/linux/kfd_ioctl.h
--29444707-2071675850-1418627851=:27943--
