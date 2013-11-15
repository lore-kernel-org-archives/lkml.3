Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3KODJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 22:09:33 -0500
Received: from gir.skynet.ie ([193.1.99.77]:54834 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab3KODJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 22:09:22 -0500
Date: Fri, 15 Nov 2013 03:09:16 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm pull for 3.13-rc1
Message-ID: <alpine.DEB.2.00.1311150308440.2218@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1428777967-1384484956=:2218"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1428777967-1384484956=:2218
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

This is a combo of -next and some -fixes that came in in the intervening time,

Highlights:
new drivers: ARM Armada driver for Marvell Armada 510 SOCs

Intel: Broadwell initial support under a default off switch,
       Stereo/3D HDMI mode support
       Valleyview improvements
       Displayport improvements
       Haswell fixes
       initial mipi dsi panel support
       CRC support for debugging
       build with CONFIG_FB=n

Radeon: enable DPM on a number of GPUs by default
        secondary GPU powerdown support
        enable HDMI audio by default
        Hawaii support

nouveau: dynamic pm code infrastructure reworked, does nothing major yet
         GK208 modesetting support
         MSI fixes, on by default again
         PMPEG improvements
         pageflipping fixes

GMA500: minnowboard SDVO support

vmware: misc fixes

msm: prime, plane and rendernodes support

tegra: rearchitected to put the drm driver into the drm subsystem.
       HDMI and gr2d support for tegra 114 SoC

qxl: oops fix, and multi-head fixes

drm core: sysfs lifetime fixes
          client capability ioctl
          further cleanups to device midlayer
          more vblank timestamp fixes

The following changes since commit 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52:

  Linux 3.12 (2013-11-03 15:41:51 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to 0846c728e20a0cd1e43fb75a3015f3b176a26466:

  Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next (2013-11-15 12:24:40 +1000)

----------------------------------------------------------------

Alex Deucher (43):
      drm/edid: catch kmalloc failure in drm_edid_to_speaker_allocation
      drm/radeon: Add support for programming the FMT blocks
      drm/radeon: add a connector property for dither
      drm/radeon: enable hdmi audio by default
      drm/radeon: plug in blit copy routine for SI
      drm/radeon: implement blit copy callback for CIK
      drm/radeon/si: tell dpm there is a display connected
      drm/radeon/atom: don't call [EN|DIS]ABLE_OUTPUT on DCE3.x
      drm/radeon/atom: don't call [EN|DIS]ABLE_OUTPUT on DCE4.x
      drm/radeon/audio: break out of loops once we match connector
      drm/radeon/audio: write audio/video latency info for DCE4/5
      drm/radeon/audio: write audio/video latency info for DCE6/8
      drm/radeon/dpm: only print dpm debugging messages when radeon_dpm=1
      drm/radeon: enable DPM by default on SUMO/PALM APUs
      drm/radeon: enable DPM by default on SI asics
      drm/radeon: enable DPM by default on BTC asics
      drm/radeon: enable DPM by default on evergreen asics
      drm/radeon: enable DPM by default on r7xx asics
      drm/radeon: disable force performance state when thermal state is active
      drm/radeon/dpm: retain user selected performance level across state changes
      drm/radeon: fix endian handling in rlc buffer setup
      drm/radeon/si: fix define for MC_SEQ_TRAIN_WAKEUP_CNTL
      drm/radeon/dpm: fix typo in setting smc flag
      drm/radeon: don't share PPLLs on DCE4.1
      drm/radeon: use HDP_MEM_COHERENCY_FLUSH_CNTL for sdma as well
      drm/radeon: fix-up some float to fixed conversion thinkos
      drm/radeon: add Hawaii chip family
      drm/radeon: update cik_gpu_init() for hawaii
      drm/radeon: minor updates to cik.c for hawaii
      drm/radeon: update cik_tiling_mode_table_init() for hawaii
      drm/radeon: add golden register settings for hawaii
      drm/radeon: update rb setup for hawaii
      drm/radeon: update firmware loading for hawaii
      drm/radeon/cik: add hawaii UVD support
      drm/radeon: add hawaii dpm support
      drm/radeon: update cik_get_csb_buffer for hawaii
      drm/radeon: atombios.h updates for hawaii
      drm/radeon: modesetting updates for hawaii
      drm/radeon: fill in radeon_asic_init for hawaii
      drm/radeon: add pci ids for hawaii
      drm/radeon: fix mismerge of drm-next with 3.12
      Revert "drm/radeon/audio: don't set speaker allocation on DCE4+"
      drm/edid: compare actual vrefresh for all modes for quirks

Anssi Hannula (1):
      drm/radeon/audio: fix missing multichannel PCM SAD in some cases

Art Runyan (1):
      drm/i915/bdw: Add BDW DDI buffer translation values

Artem Bityutskiy (1):
      drm/i915: preserve dispaly init order on ByT

Arto Merilainen (4):
      gpu: host1x: Add 'flags' field to syncpt request
      gpu: host1x: Add syncpoint base support
      drm/tegra: Deliver syncpoint base to user space
      drm/tegra: Reserve base for gr2d

Ben Hutchings (2):
      drm: Do not include page offset in argument to virt_to_page()
      drm: Pass pointers to virt_to_page()

Ben Skeggs (66):
      drm/nv50-/sw: share engine/channel struct definitions between implementations
      drm/nv50-/sw: make vblank tracking data private to the implementations
      drm/nouveau/sw: prepare for the sharing of constructors between implementations
      drm/nv50-/sw: share engine/channel constructor between implementations
      drm/nouveau/core: convert event handler apis to split create/enable semantics
      drm/nouveau/core: split lock into list+exec and enable refcount locks
      drm/nouveau/therm: kill some over-zealous debugging
      drm/nouveau/vic: rename PUNK1C1 to PVIC
      drm/nv31/mpeg: remove need for separate refcnt on engine use
      drm/nouveau/bios/init: return failure condition on invalid opcodes
      drm/nouveau/device: use an additional bit from NV_PMC_BOOT_0 to identify chipset
      drm/nouveau/mc: msi rearm write via subdev, not device
      drm/nouveau/mc: have single entry and exit points to the interrupt handler
      drm/nouveau/mc: bracket interrupt handler with NV_PMC_INTR_EN disable/re-enable
      drm/nouveau/mc: fetch NV_PMC_INTR again after re-arming MSI
      drm/nouveau/mc: store static data in nouveau_mc class definition
      drm/nvc0,nvc4/mc: handle 0xc0's "special" msi rearm
      drm/nv50-nv86,nv92/mc: rearm msi via pci config space, rather than mmio mirror
      drm/nvaa/mc: blacklist msi to off by default
      drm/nouveau/fb: make external class definitions pointers
      drm/nv50-nvaf/fb: split the class definitions up a bit
      drm/nouveau/fb: remove ram oclass argument from base fb constructor
      drm/nouveau/fb: merge more bits and pieces into oclass definitions
      drm/nv50-nvaf/fb: split fbram oclass in preparation for reclocking
      drm/nva0/clk: fix accidental limiting of pll coefficients
      drm/nvd9-/disp: disable display underflow reporting at init
      drm/nouveau/disp: log if DP link training fails
      drm/nv94-nvc0/disp: reorder writes to lane current control regs
      drm/nvd0-/disp: reorder writes to lane current control regs
      drm/nouveau/fbcon: bracket entrypoints with a per-device enabled check
      drm/nouveau/bios: some older boards have shorter displayport tables
      drm/nouveau/disp: semi-complete link training sequence even if display disappears
      drm/nouveau/mc: fix (incorrect) reporting of unknown pending intr bits
      drm/nvc0-/gr: fix a number of missing explicit array terminators...
      drm/nouveau/device: recognise GK208
      drm/nouveau/fifo: make external class definitions into pointers
      drm/nouveau/core: make all info-level messages silent for runtime pm
      drm/nouveau/drm/pm: remove everything except the hwmon interfaces to THERM
      drm/nouveau/gpio: return different error code for not found vs invalid
      drm/nouveau/pwr: assign a subdev id for upcoming implementation
      drm/nouveau/therm: add hook for clk to suggest fanspeed to therm
      drm/nouveau/therm: if no bios trip/linear info, default to perf-suggested speed
      drm/nvc0/therm: allow fan control if we've killed the vbios ppwr ucode
      drm/nouveau/therm: no toggle fan control either if we can't guarantee no pwm connected
      drm/nouveau/therm: automatic mode by default
      drm/nouveau/therm: update target fanspeed outside of therm lock
      drm/nouveau/pwr: initial implementation
      drm/nouveau/bus: make external class definitions pointers
      drm/nouveau/bus: add interfaces/helpers for sequencer
      drm/nouveau/perfmon: initial infrastructure to expose performance counters
      drm/nouveau/bios: parsing for various tables required for power management
      drm/nouveau/volt: implement voltage control in core
      drm/nouveau/clk: implement power state and engine clock control in core
      drm/nouveau/device: initial control object class, with pstate control methods
      drm/nouveau: implement a simple sysfs interface to new pm code
      drm/nouveau/fb: implement various bits of work towards memory reclocking
      drm/nvc8/mc: msi rearm is via the nvc0 method
      drm/nouveau: allow nouveau_fence_ref() to be a noop
      drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previous fence
      drm/nouveau: there is no need to reserve/fence the new fb when flipping
      drm/nouveau: always queue flips relative to kernel channel activity
      drm/nv10-: we no longer need to create nvsw object on user channels
      drm/nvc0-: remove nasty fifo swmthd hack for flip completion method
      drm/nv11-: synchronise flips to vblank, unless async flip requested
      drm/nv40/therm: fix slowing down fan when pstate undefined
      drm/nouveau/pwr: fix missing mutex unlock in a failure path

Ben Widawsky (81):
      drm/i915: Convert execbuf code to use vmas
      drm/i915: Restore the preliminary HW check.
      drm/i915: Synchronize pread/pwrite with wait_rendering
      drm/i915: Extract vm specific part of eviction
      drm/i915: evict VM instead of everything
      drm/i915: Remove extra "ring"
      drm/i915: Round l3 parity reads down
      drm/i915: Fix l3 parity user buffer offset
      drm/i915: Fix HSW parity test
      drm/i915: Add second slice l3 remapping
      drm/i915: Make l3 remapping use the ring
      drm/i915: Keep a list of all contexts
      drm/i915: Do remaps for all contexts
      drm/i915: s/HAS_L3_GPU_CACHE/HAS_L3_DPF
      drm/i915: Calculate PSR register offsets from base + gen
      drm/i915: trace vm eviction instead of everything
      drm/i915: Provide a cheap ggtt vma lookup
      drm/i915: Convert active API to VMA
      drm/i915: Clean up the ring scaling calculations
      drm/i915: Use the real cpu max frequency for ring scaling
      drm/i915: Prevent using uninitialized MMIO funcs
      drm/i915: Move edram detection early_sanitize
      drm/i915: Create MMIO virtual functions
      drm/i915: Extract common MMIO lines
      drm/i915: Create GEN specific read MMIO
      drm/i915: Create GEN specific write MMIO
      drm/i915: Remove gen specific checks in MMIO
      drm/i915: Do PCH and uncore init earlier
      drm/i915: Do a fuller init after reset
      drm/i915: cleanup context fini
      drm/i915: Replace has_bsd/blt/vebox with a mask
      drm/i915: Print RC6 info less often
      drm/i915: Convert straggling MCHBAR registers
      drm/i915: Remove WaFbcDisableDpfcClockGating on IVB
      drm/i915: Remove WaFbcDisableDpfcClockGating on HSW
      drm/i915/bdw: IS_GEN8 definition
      drm/i915/bdw: Handle forcewake for writes on gen8
      drm/i915/bdw: Initialize BDW forcewake vfuncs
      drm/i915/bdw: Add device IDs
      drm/i915/bdw: Fences on gen8 look just like gen7
      drm/i915/bdw: Swizzling support
      drm/i915/bdw: HW context support
      drm/i915/bdw: Clock gating init
      drm/i915/bdw: display stuff
      drm/i915/bdw: support GMS and GGMS changes
      drm/i915/bdw: Implement interrupt changes
      drm/i915/bdw: Add interrupt info to debugfs
      drm/i915/bdw: Support 64b relocations
      drm/i915/bdw: dispatch updates (64b related)
      drm/i915/bdw: Update MI_FLUSH_DW
      drm/i915/bdw: debugfs updates
      drm/i915/bdw: Update relevant error state
      drm/i915/bdw: Make gen8_gmch_probe
      drm/i915/bdw: Create gen8_gtt_pte_t
      drm/i915/bdw: Add GTT functions
      drm/i915/bdw: Support BDW caching
      drm/i915/bdw: PPGTT init & cleanup
      drm/i915/bdw: Initialize the PDEs
      drm/i915/bdw: Implement PPGTT clear range
      drm/i915/bdw: Implement PPGTT insert
      drm/i915/bdw: Implement PPGTT enable
      drm/i915/bdw: unleash PPGTT
      drm/i915/bdw: Render ring flushing
      drm/i915/bdw: ppgtt info in debugfs
      drm/i915/bdw: BSD init for gen8 also
      drm/i915/bdw: Implement WaSwitchSolVfFArbitrationPriority
      drm/i915/bdw: Use The GT mailbox for IPS enable/disable
      drm/i915/bdw: Support eDP PSR
      drm/i915/bdw: Use HSW formula for ring freq scaling
      drm/i915/bdw: Don't wait for c0 threads on forcewake
      drm/i915/bdw: Create a separate BDW rps enable
      drm/i915/bdw: Disable semaphores
      drm/i915/bdw: Implement edp PSR workarounds
      drm/i915/bdw: BWGTLB clock gate disable
      ddrm/i915/bdw: Disable centroid pixel perf optimization
      drm/i915/bdw: Sampler power bypass disable
      drm/i915/bdw: Limit SDE poly depth FIFO to 2
      drm/i915/bdw: conservative SBE VUE cache mode
      drm/i915/bdw: WaSingleSubspanDispatchOnAALinesAndPoints
      drm/i915/bdw: Change dp aux timeout to 600us on DDIA
      drm/i915/bdw: Add BDW PCH check first

Chon Ming Lee (8):
      drm/i915: Modify DP set clock to accomodate more eDP timings v2
      drm/i915: Move Valleyview DP DPLL divisor calc to intel_dp_set_clock v2
      drm/i915: Add additional pipe parameter for vlv_dpio_read and vlv_dpio_write. v2
      drm/i915: Fix VLV eDP timing v2
      drm/i915: Program GMBUS Frequency based on the CDCLK for VLV.
      drm/i915/vlv: Turn off power gate for BIOS-less system.
      drm/i915: Move some hdmi enable function name to vlv specific.
      drm/i915/vlv: Fix typo in the DPIO register define.

Chris Wilson (31):
      drm/i915: Don't destroy the vma placeholder during execbuffer reservation
      drm/i915: Always prefer CPU relocations with LLC
      drm/i915: Do not add an interrupt for a context switch
      drm/i915: Rearrange the comments in i915_add_request()
      drm/i915: Rename ring->outstanding_lazy_request
      drm/i915; Preallocate the lazy request
      drm/i915: Write RING_TAIL once per-request
      drm/i915: Remove the double-list iteration from bound_any()
      drm/i915: Do not unlock upon error in i915_gem_idle()
      drm/i915: Delay the release of the forcewake by a jiffie
      drm/i915: Add some debug spam for intialising SDVO
      drm/i915: Move the conditional seqno query into the tracepoint
      drm/i915: Show WT caching in debugfs
      drm/i915: Add a tracepoint for using a semaphore
      drm/i915/vlv: fix up broken precision in vlv_crtc_clock_get
      drm/i915: Add some missing steps to i915_driver_load error path
      drm/i915: Fix __wait_seqno to use true infinite timeouts
      drm/i915: Boost RPS frequency for CPU stalls
      drm/i915: Tweak RPS thresholds to more aggressively downclock
      drm: Try loading builtin EDIDs first
      drm/i915: Call io_schedule() whilst whilsting for the GPU
      drm/i915: Fix type mismatch and accounting in i915_gem_shrink
      drm/i915: Undo the PIPEA quirk for i845
      drm/i915: Capture the initial error-state when kicking stuck rings
      drm/i915: Avoid tweaking RPS before it is enabled
      drm/i915: Add breadcrumbs for why the backlight is being set
      drm/i915: Disable all GEM timers and work on unload
      drm/i915: Whitespace alignment fix for block header in display error state
      drm/i915: Capture batchbuffer state upon GPU hang
      drm: Do not drop root privileges for a fancier younger process
      drm: Compact booleans within struct drm_file

Christian König (8):
      drm/radeon: activate UVD clocks before sending the destroy msg
      drm/radeon: fix UVD destroy IB size
      drm/radeon: rework and fix reset detection v2
      drm/radeon: add vm_set_page tracepoint
      drm/radeon: drop CP page table updates & cleanup v2
      drm/radeon: initially clear page tables
      drm/radeon: clear the page directory using the DMA
      drm/radeon: fix radeon_fence_wait_empty_locked

Damien Lespiau (49):
      drm/i915: It's its!
      drm/i915: Remove unused mode_fixup() vfunc of struct intel_dvo_dev_ops
      drm: Move the GET_CAP macros next to the corresponding ioctl structure
      drm: Add a SET_CLIENT_CAP ioctl
      drm: Add HDMI stereo 3D flags to struct drm_mode_modeinfo
      drm: Add a STEREO_3D capability to the SET_CLIENT_CAP ioctl
      drm/edid: Expose mandatory stereo modes for HDMI sinks
      drm: Extract add_hdmi_mode() out of do_hdmi_vsdb_modes()
      drm: Reject modes with more than 1 stereo flags set
      drm: Set the relevant infoframe field when scanning out a 3D mode
      drm: Make drm_match_cea_mode() return the underlying 2D VIC for 3d modes
      drm: Carry over the stereo flags when adding the alternate mode
      drm: Make exposing stereo modes a per-connector opt-in
      drm: Remove clock_index from struct drm_display_mode
      drm: Remove synth_clock from struct drm_display_mode
      drm: Introduce a crtc_clock for struct drm_display_mode
      drm: Implement timings adjustments for frame packing
      drm: Factor out common CRTC viewport checking code
      drm: Check the fb size against the adjusted v/hdisplay for stereo modes
      drm/i915: Use crtc_clock in intel_dump_crtc_timings()
      drm/i915: Use crtc_clock with the adjusted mode
      drm/i915: Ask the DRM core do make stereo timings adjustements
      drm/i915: Prefer crtc_{h|v}display for pipe src dimensions
      drm/i915: Allow stereo modes on HDMI
      drm: Code stereo layouts as an enum rather than a bit field
      drm: Revert "drm: Reject modes with more than 1 stereo flags set"
      drm: Reject stereo modes with an unknown layout
      drm/i915: Make intel_resume_power_well() static
      drm/i915: Add a more detailed comment about the set_base() fastboot hack
      drm/i915: Use adjusted_mode in the fastboot hack to disable pfit
      drm/i915: Remove yet another unused define
      drm/i915: Keep the CRC values into a circular buffer
      drm/i915: Sample the frame counter instead of a timestamp for CRCs
      drm/i915: Make switching to the same CRC source a no-op
      drm/i915: Enforce going back to none before changing CRC source
      drm/i915: Empty the circular buffer when asked for a new source
      drm/i915: Dynamically allocate the CRC circular buffer
      drm/i915: Generalize the CRC command format for future work
      drm/i915: Rename i915_pipe_crc_ctl to i915_display_crc_ctl
      drm/i915: Warn if we receive an interrupt after freeing the buffer
      drm/i915: Add log messages when CRCs collection is started/stopped
      drm/i915: Move drm_add_fake_info_node() higher in the file
      drm/i915: Implement blocking read for pipe CRC files
      drm/i915: Only one open() allowed on pipe CRC result files
      drm/i915: Enable pipe CRCs
      drm/i915: Use pipe_name() instead of the pipe number
      drm/i915: Use a spin lock to protect the pipe crc struct
      drm/i915/bdw: Broadwell has 3 pipes
      drm/i915/bdw: Broadwell has a max port clock of 300Mhz on HDMI

Dan Carpenter (5):
      drm/i915: cleanup a min_t() cast
      drm/i915: precendence bug in GT_PARITY_ERROR()
      drm/radeon/dpm: cleanup a type issue with rv6xx_clocks_per_unit()
      drm/nouveau: off by one in nouveau_drm_vblank_enable()
      drm/nvc0-/gr: shift wrapping bug in nvc0_grctx_generate_r406800

Daniel Vetter (68):
      drm/i915: inline vma_create into lookup_or_create_vma
      drm/i915: More vma fixups around unbind/destroy
      drm/i915/dsi: s/size_t/int/
      drm/i915: Fix list corruption in vma_unbind
      drm/i915: re-layout intel_panel.c to obey 80 char limit
      drm/i915: garbage-collect vlv refclk function
      drm/i915: dump crtc timings from the pipe config
      Merge tag 'v3.12-rc2' into drm-intel-next
      drm/i915: use pointer = k[cmz...]alloc(sizeof(*pointer), ...) pattern
      drm/i915: Use kcalloc more
      drm/i915: Ditch INTELFB_CONN_LIMIT
      drm/i915: Use unsigned for overflow checks in execbuf
      drm/i915: Rip out SUPPORTS_EDP
      Merge remote-tracking branch 'airlied/drm-next' into drm-intel-next
      drm/i915: check that the i965g/gm 4G limit is really obeyed
      drm/i915: rip out gen2 reset code
      drm/i915: Keep intel_drv.h tidy
      drm/i915: Educate users in dmesg about reporting gpu hangs
      drm: Add separate Kconfig option for fbdev helpers
      drm/i915: Kconfig option to disable the legacy fbdev support
      drm/i915: rename intel_fb.c to intel_fbdev.c
      drm/i915: Add a control file for pipe CRCs
      drm/i915: static inline for dummy crc functions
      drm/i915: constify harder
      drm/i915: grab dev->struct_mutex around framebuffer_init
      drm/i915: prevent tiling changes on framebuffer backing storage
      drm/i915: Use unsigned long for obj->user_pin_count
      drm/i915: check gem bo size when creating framebuffers
      cpufreq: Add dummy cpufreq_cpu_get/put for CONFIG_CPU_FREQ=n
      drm/i915: don't Oops in debugfs for I915_FBDEV=n
      drm/i915: extract display_pipe_crc_update
      drm/i915: add CRC #defines for ilk/snb
      drm/i915: wire up CRC interrupt for ilk/snb
      drm/i915: use ->get_vblank_counter for the crc frame counter
      drm/i915: wait one vblank when disabling CRCs
      drm/i915: fix CRC debugfs setup
      drm/i915: crc support for hsw
      drm/i915: remove dead code in ironlake_crtc_mode_set
      drm/i915: Adjust CRC capture for pre-gen5/vlv
      drm/i915: CRC source selection #defines for gmch/vlv chips
      drm/i915: Wire up CRC interrupts for pre-gen5/vlv
      drm/i915: Enable CRC interrupts on pre-gen5/vlv
      drm/i915: Fix PIPE_CRC_CTL for vlv
      drm/i915: Add new CRC sources
      drm/i915: Wire up CRC support for gen3/4
      drm/i915: Wire up gen2 CRC support
      drm/i915: Wire up CRC for vlv
      drm/i915: bikeshed the pipe CRC irq functions a bit
      drm/i915: Move the pipe CRC stuff to other pipe data
      drm/i915: handle faked missed interrupts as simulated hangs, too
      drm/i915: use enum pipe consistently in i915_irq.c
      drm/i915: refactor ilk display interrupt handling
      drm/i916: add "auto" pipe CRC source
      drm/i915: scramble reset support for DP port CRC on g4x
      drm/i915: scramble reset support for DP port CRC on vlv
      drm/i915: Enable DP port CRC for the "auto" source on g4x/vlv
      Merge tag 'v3.12' into drm-intel-next
      drm/i915/dvo: call ->mode_set callback only when the port is running
      drm/i915/bdw: Disable PPGTT for now
      drm/i915/bdw: Take render error interrupt out of the mask
      drm/i915: Optimize pipe irq handling on bdw
      drm/i915: Fix up the bdw pipe interrupt enable lists
      drm/i915: Wire up port A aux channel
      drm/i915: Wire up PCH interrupts for bdw
      drm/i915: Wire up pipe CRC support for bdw
      drm/i915: Optimize gen8_enable|disable_vblank functions
      drm/i915: Wire up cpu fifo underrun reporting support for bdw
      drm/i915: Mask the vblank interrupt on bdw by default

Dave Airlie (30):
      Merge tag 'drm-intel-next-2013-09-21-merged' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-intel-next' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      drm/i915: abstract the conversion of device->minor out to a macro
      drm/sysfs: sort out minor and connector device object lifetimes.
      Merge branch 'drm-tda998x-3.12' of git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-next
      Merge branch 'drm-tda998x-3.12-fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-next
      Merge tag 'drm-intel-next-2013-10-18' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      drm/radeon: convert to pmops
      drm/radeon: add runtime PM support (v2)
      qxl: avoid an oops in the deferred io code.
      Merge tag 'drm/for-3.13-rc1' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge branch 'drm-next-3.13' of git://people.freedesktop.org/~agd5f/linux into drm-next
      nouveau: drop interrupt busy setting.
      qxl: add a connector property to denote hotplug should rescan modes.
      Merge branch 'vmwgfx-next-3.13' of git://people.freedesktop.org/~thomash/linux into drm-next
      Merge branch 'ttm-next-3.13' of git://people.freedesktop.org/~thomash/linux into drm-next
      drm/mgag200: drop pointless info print.
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      drm/vmwgfx: fix warning if config intel iommu is off.
      Merge tag 'drm-intel-fixes-2013-11-07' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      drm/nouveau: fix 32-bit build
      Merge branch 'msm-next' of git://people.freedesktop.org/~robclark/linux into drm-next
      Merge branch 'drm-next-3.13' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge tag 'bdw-stage1-2013-11-08-v2' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'gma500-next' of git://github.com/patjak/drm-gma500 into drm-next
      Merge branch 'vmwgfx-next-3.13' of git://people.freedesktop.org/~thomash/linux into drm-next
      Merge branch 'ttm-next-3.13' of git://people.freedesktop.org/~thomash/linux into drm-next
      Merge tag 'drm-intel-fixes-2013-11-12' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-next-3.13' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next

Dave Jones (1):
      drm/nouveau: remove pointless assignment

David Herrmann (13):
      drm/nouveau: embed gem object in nouveau_bo
      drm: kill ->gem_init_object() and friends
      drm: add drm_dev_alloc() helper
      drm: merge device setup into drm_dev_register()
      drm: move drm_lastclose() to drm_fops.c
      drm: introduce drm_dev_free() to fix error paths
      drm: move device unregistration into drm_dev_unregister()
      drm: call drm_unplug_minor() from drm_put_minor()
      drm: simplify drm_put_minor()
      drm: make drm_get_minor() static
      drm: cleanup debugfs in drm_unplug_minor()
      drm: remove minor-id during unplug
      drm: delay minor destruction to drm_dev_free()

Duan Jiong (1):
      DRM: Armada: convert to use simple_open()

Emil Velikov (1):
      drm/nouveau: consider CLASS_DISPLAY_3D devices while detecting dsm/optimus

Erik Faye-Lund (1):
      gpu: host1x: check relocs after all gathers are consumed

Gerd Hoffmann (4):
      drm: add drm_set_preferred_mode
      drm/cirrus: use drm_set_preferred_mode
      drm/qxl: support 64bit surface bar
      drm/qxl: add some surface memory logging

Ilia Mirkin (11):
      drm/nouveau: remove prototype for non-existent nouveau_connector_bpp
      drm/nouveau: fix backlight mask on ppc powerbook
      drm/nv10: introduce a new NV_11 card type
      drm/nv10: fix chipset checks, mostly for the benefit of nv1a
      drm/nv10/kms: add plane support for nv10-nv40
      drm/nv31/mpeg: no need to set compat mode differently for nv44 gr
      drm/nv44/mpeg: create a copy of the nv31/nv40 impls
      drm/nv40/mpeg: use the nv31-provided classes
      drm/nv31/mpeg: store chan singleton in engine, use it for dispatch
      drm/nv31/mpeg: split the nv31 and nv40 dma setting implementations
      drm/nouveau/agp: add a quirk list to limit agp modes

Ilija Hadzic (8):
      drm: remove redundant if statement
      drm: eliminate old_fb from drm_crtc_helper_set_config
      drm: restore crtc origin if mode_set_base fails
      drm: fix error recovery path in drm_crtc_helper_set_mode
      drm: do not set crtc enabled field twice
      drm: eliminate bit-copy restoration of crtc
      drm/radeon/kms: unpin fb in atombios crtc disable
      drm/radeon/kms: add crtc_disable function for legacy crtc

Imre Deak (11):
      drm/i915: vlv: fix VGA hotplug after modeset
      drm/i915: make the intel_display_power_domain enum compact
      drm/i915: factor out is_always_on_domain
      drm/i915: change power_well->lock to be mutex
      drm/i915: factor out modeset_update_power_wells
      drm/i915: enable only the needed power domains during modeset
      drm/i915: prepare for multiple power wells
      drm/i915: use power get/put instead of set for power on after init
      drm/i915: remove device field from struct power_well
      drm/i915: rename i915_init_power_well to init_power_domains_init
      drm/i915: add back checking for i915_disable_power_well

Jakob Bornecrantz (1):
      drm/ttm: Handle in-memory region copies

Jani Nikula (48):
      drm/i915: add more VLV IOSF sideband ports accessors
      drm/i915: add VLV pipeconf bit definition for DSI PLL lock
      drm/i915: add MIPI DSI register definitions
      drm/i915: add MIPI DSI output type and subtypes
      drm/i915: add structs for MIPI DSI output
      drm/i915: add MIPI DSI command sending routines
      drm/i915: add basic MIPI DSI output support
      drm/i915: fix PLL assertions for DSI PLL
      drm/i915: don't enable DPLL for DSI
      drm/i915: initialize DSI output on VLV
      drm/i915: add plumbing for SWSCI
      drm/i915: expose intel_ddi_get_encoder_port()
      drm/i915: add opregion function to notify bios of encoder enable/disable
      drm/i915: add opregion function to notify bios of adapter power state
      drm/i915: do display power state notification on crtc enable/disable
      drm/i915: name intel dp hooks per platform
      drm/i915: move backlight enable later in vlv enable sequence
      drm/i915: clean up power sequencing register port select definitions
      drm/i915: add support for per-pipe power sequencing on vlv
      drm/i915: add asserts for cursor disabled
      drm/i915: only report hpd connector status change when it actually changed
      drm/i915: register backlight device also when backlight class is a module
      drm/i915: assume all GM45 Acer laptops use inverted backlight PWM
      drm/dp: add defines for downstream port types
      drm/i915/dp: downstream port capabilities are not present in DPCD 1.0
      drm/edid: add drm_edid_duplicate
      drm/exynos: use drm_edid_duplicate
      drm/dp: constify DP DPCD helpers
      drm/i915/dp: read DPCD PSR capability only on eDP
      drm/i915: clean up and simplify i9xx_crtc_mode_set wrt PLL handling
      drm/i915: backlight combination mode bit is gen4 only
      drm/i915/dp: retry i2c-over-aux seven times on AUX DEFER
      drm/i915/dp: do not write DP_TRAINING_PATTERN_SET all the time
      drm/i915: fix typo s/PatherPoint/PantherPoint/
      drm/i915/dp: use drm_edid_duplicate
      drm/dp: add helper for checking DP_ENHANCED_FRAME_CAP in DPCD
      drm/radeon/dp: use drm_dp_enhanced_frame_cap()
      drm/i915/dp: get rid of intel_dp->link_configuration
      drm/i915/dp: use sizeof for memset instead of magic value
      drm/i915/dp: promote clock recovery failures to DRM_ERROR
      drm/i915/dp: update training set in a burst write with training pattern set
      drm/i915: tell the user KMS is required for gen6+
      drm/i915/dp: constify link_status
      drm/i915: pass mode to ELD write vfuncs
      drm/i915: set HDMI pixel clock in audio configuration
      drm/i915/dp: don't mention eDP bpp clamping if it doesn't affect bpp
      drm/i915: move opregion asle request handling to a work queue
      drm/i915/opregion: fix build error on CONFIG_ACPI=n

Jesse Barnes (15):
      drm/i915/vlv: re-enable hotplug detect based probing on VLV/BYT
      drm/i915/vlv: honor i915_enable_rc6 boot param on VLV
      drm/i915/vlv: disable rc6p and rc6pp residency reporting on BYT
      drm/i915/vlv: add VLV specific clock_get function v3
      drm/i915/vlv: hack to init backlight regs if BIOS fails to do so v2
      drm/i915/vlv: use lower precision RC6 counter
      drm/i915/vlv: use correct units for rc6 residency v2
      drm/i915/vlv: reduce GT FIFO error info to a debug message
      i915/vlv: untangle integrated clock source handling v4
      drm/i915/vlv: reset DPIO on load and resume v2
      drm/i915: don't save/restore CACHE_MODE_0 on gen7+
      drm/i915/vlv: add doc names to sideband file
      drm/i915/vlv: use PIPE_START_VBLANK interrupts on VLV
      drm/i915: make backlight functions take a connector
      drm/i915/vlv: use per-pipe backlight controls v2

Laurent Pinchart (2):
      drm: shmobile: Add dependency on BACKLIGHT_CLASS_DEVICE
      drm: shmob_drm: Convert to clk_prepare/unprepare

Lespiau, Damien (10):
      drm: Remove unused variable in drm_global_item_ref()
      drm: Remove unused variable in drm_prime_sg_to_page_addr_arrays()
      drm: Remove unused variable in drm_fb_helper_pan_display()
      drm: Remove unused variable in drm_pick_crtcs()
      drm: Remove unused variables in drm_fb_helper_hotplug_event()
      drm: Fix comment referring to the long gone ->probe() connector vfunc
      drm: Constify struct drm_info_list * arguments
      drm: Remove drm_debugfs_node and drm_debugfs_list
      drm: Make drm_debugfs_list const
      drm/i915: Make the debugfs structures const

Maarten Lankhorst (2):
      drm/radeon: fixup locking inversion between, mmap_sem and reservations
      drm/nouveau: do not map evicted vram buffers in nouveau_bo_vma_add

Marc-André Lureau (7):
      drm: fix a small spelling
      drm: return if changed in drm_helper_hpd_irq_event()
      drm/qxl: notify that the monitor config changed
      drm: copy mode type in drm_mode_connector_list_update()
      drm/qxl: prefer the monitor config resolution
      drm/qxl: remove unnecessary check
      drm/qxl: fix disabling extra monitors from client

Marek Ol¨ák (1):
      drm/radeon: don't use PACKET2 on CIK

Mario Kleiner (4):
      drm: Remove preempt_disable() from vblank timestamping code.
      drm: Push latency sensitive bits of vblank scanoutpos timestamping into kms drivers.
      drm/radeon: Push get_scanout_position() timestamping into kms driver.
      drm/intel: Push get_scanout_position() timestamping into kms driver.

Markus Trippelsdorf (1):
      drm/radeon: Implement radeon_pci_shutdown

Martin Peres (2):
      drm/nouveau/therm: ack any pending IRQ at init
      drm/nouveau/i2c: use a custom bitbanging delay for the adt7473

Mengdong Lin (1):
      drm/i915/vlv: enable HDA display audio for Valleyview2

Mika Kuoppala (2):
      drm/i915: ban badly behaving contexts
      drm/i915: include hangcheck action and score in error_state

Mikko Perttunen (3):
      drm/tegra: Add Tegra114 HDMI support
      drm/tegra: hdmi: Detect DVI-only displays
      drm/tegra: hdmi: Enable VDD earlier for hotplug/DDC

Patrik Jakobsson (12):
      drm/gma500: Add Minnowboard to the IS_MRST() macro
      drm/gma500: Add chip specific sdvo masks
      drm/gma500: Add support for aux pci vdc device
      drm/gma500: Add aux device support for gmbus
      drm/gma500/mrst: Add SDVO clock calculation
      drm/gma500/mrst: Add aux register writes when programming pipe
      drm/gma500/mrst: Properly route oaktrail hdmi hooks
      drm/gma500/mrst: Add aux register writes to SDVO
      drm/gma500/mrst: Replace WMs and chickenbits with values from EMGD
      drm/gma500/mrst: Setup GMBUS for oaktrail/mrst
      drm/gma500/mrst: Don't blindly guess a mode for LVDS
      drm/gma500/mrst: Add SDVO to output init

Paulo Zanoni (40):
      drm/i915: move more code to __i915_drm_thaw
      drm/i915: don't save/restore LBB on Gen5+
      drm/i915: clear opregon->lid_state after we unmap it
      drm/i915: WARN is the DP aux read or write is too big
      drm/i915: check for more ASLC interrupts
      drm/i915: write D_COMP using the mailbox
      drm/i915: don't disable ERR_INT on the IRQ handler
      drm/i915: POSTING_READ IPS_CTL before waiting for the vblank
      drm/i915: VBT's child_device_config changes over time
      drm/i915: use the HDMI DDI buffer translations from VBT
      drm/i915: check the DDC and AUX bits of the VBT on DDI machines
      drm/i915: add some assertions about VBT DDI port types
      drm/i915: don't init DP or HDMI when not supported by DDI port
      drm/i915: reorganize intel_drv.h
      drm/i915: make intel_pipe_has_type static
      drm/i915: make intel_crtc_load_lut static
      drm/i915: make intel_crtc_fb_gamma_{set, get} static
      drm/i915: make hsw_{disable, restore}_lcpll static
      drm/i915: remove "extern" keywords from intel_drv.h functions
      drm/i915: destroy connector sysfs files earlier
      drm/i915: implement the Haswell mode set sequence workaround
      drm/i915: wait for IPS_ENABLE when enabling IPS
      drm/i915: don't leak dp_connector at intel_ddi_init
      drm/i915: increase the SWSCI DSLP default timeout to 50ms
      drm/i915: fix open-coded DIV_ROUND_UP
      drm/i915: turn the eDP VDD on for any i2c transactions
      drm/i915: reduce eDP VDD message verbose
      drm/i915: use the correct register when turning VDD off
      drm/i915: avoid unclaimed registers when capturing the error state
      drm/i915/bdw: add IS_BROADWELL macro
      drm/i915/bdw: add Broadwell sprite/plane/cursor checks
      drm/i915/bdw: Broadwell also has the "power down well"
      drm/i915/bdw: pretend we have LPT LP on Broadwell
      drm/i915/bdw: on Broadwell, the panel fitter is on the pipe
      drm/i915/bdw: Broadwell has PIPEMISC
      drm/i915/bdw: get the correct LCPLL frequency on Broadwell
      drm/i915/bdw: add BDW DDI buf translations for eDP
      drm/i915/bdw: add support for BDW DP voltage swings and pre-emphasis
      drm/i915/bdw: BDW also has only 2 FDI lanes
      drm/i915/bdw: check DPD on port D when setting the DDI buffers

Peter Hurley (3):
      drm/nouveau/core: Add priv field for event handlers
      drm/nouveau/core: Move event index check from critical section
      drm/nouveau/core: Allow asymmetric nouveau_event_get/_put

Pierre Ossman (2):
      drm/radeon/audio: correct ACR table
      drm/radeon/audio: improve ACR calculation

Rob Clark (7):
      drm/msm: prime support
      drm/msm: support render nodes
      drm/msm: resync generated headers
      drm/msm: add plane support
      drm/msm: rework inactive-work
      drm/msm: EBUSY status handling in msm_gem_fault()
      drm/msm/mdp4: page_flip cleanups/fixes

Rodrigo Vivi (2):
      drm/i915: Report enabled slices on Haswell GT3
      drm/i915: Simplify PSR debugfs

Russell King (6):
      DRM: Armada: Add Armada DRM driver
      DRM: Armada: Add support for ARGB 32x64 or 64x32 hardware cursors
      drm/i2c: tda998x: set VIF for full range, underscanned display
      Merge branches 'drm-3.12' and 'tda998x-3.12' into drm-tda998x-3.12
      DRM: Armada: add support for drm tda19988 driver
      DRM: Armada: depend on ARM

Shobhit Kumar (3):
      drm: add MIPI DSI encoder and connector types
      drm/i915: Band Gap WA
      drm/i915: Parse the MIPI related VBT Block and store relevant info

Shuang He (1):
      drm/i915: Expose latest 200 CRC value for pipe through debugfs

Thierry Reding (36):
      drm/sysfs: Do not drop device reference twice
      drm: Track the proper DPMS mode of connectors
      drm: Fix typo in debug message
      gpu: host1x: Remove unused Makefile
      drm/tegra: Remove unused fields
      drm/tegra: Cleanup tegra_dc structure
      drm/tegra: Rename host1x_drm structure to tegra_drm
      drm/tegra: Rename host1x_drm_file to tegra_drm_file
      drm/tegra: Rename host1x_drm_context to tegra_drm_context
      gpu: host1x: Cleanup includes
      gpu: host1x: Do not discard .remove()
      gpu: host1x: Fix alignment of function arguments
      gpu: host1x: firewall: Rename cmdbuf_id -> cmdbuf
      gpu: host1x: firewall: Refactor register check
      drm/tegra: gr2d: Miscellaneous cleanups
      drm/tegra: Rename gr2d to tegra-gr2d
      drm/tegra: gem: Miscellaneous cleanups
      gpu: host1x: Make host1x header file public
      drm/tegra: Introduce tegra_drm_client structure
      gpu: host1x: Expose syncpt and channel functionality
      drm/tegra: Move subdevice infrastructure to host1x
      gpu: host1x: Use relative include paths
      drm/tegra: Move driver to DRM tree
      drm/tegra: Properly cleanup and zero out resources
      drm/tegra: Allocate resources at probe time
      gpu: host1x: Add support for Tegra114
      drm/tegra: hdmi: Rename tegra{2,3} to tegra{20,30}
      drm/tegra: hdmi: Parameterize based on compatible property
      drm/tegra: hdmi: Fix build warnings
      drm/tegra: Start connectors with correct DPMS mode
      drm/tegra: Use symbolic names for gr2d registers
      drm/tegra: Introduce tegra_drm_submit()
      drm/tegra: Add 3D support
      drm/tegra: Add support for tiled buffer objects
      drm/tegra: Support bottom-up buffer objects
      drm/tegra: Reserve syncpoint base for gr3d

Thomas Hellstrom (9):
      drm/ttm: Enable the dma page pool also for intel IOMMUs
      drm/vmwgfx: Use the linux DMA api to get valid device addresses of pages
      drm/ttm: Allow vm fault retries
      drm/ttm: Make NO_EVICT bos available to shrinkers pending destruction
      drm/ttm: Fix ttm_bo_move_memcpy
      drm/ttm: Fix memory type compatibility check
      drm/vmwgfx: Resource evict fixes
      drm/vmwgfx: Fix a couple of compile / sparse warnings and errors
      drm/ttm: Fix vma page_prot bit manipulation

Thomas Wood (1):
      drm: add support for additional stereo 3D modes

Tom O'Rourke (1):
      drm/i915: Finish enabling rps before use by sysfs or debugfs

Ville Syrjälä (138):
      drm/i915: Kill IRONLAKE_FDI_FREQ check
      drm/i915: Pass crtc to intel_update_watermarks()
      drm/i915: Call intel_update_watermarks() in specific place during modeset
      drm/i915: Constify some watermark data
      drm/i915: Use ilk_compute_wm_level to compute WM_PIPE values
      drm/i915: Refactor max WM level
      drm/i915: Fix HSW sync flags to use pipe config adjusted_mode
      drm/i915: Don't factor in pixel multplier when deriving dotclock from link clock and M/N values
      drm/i915: Make adjusted_mode.clock non-pixel multiplied
      drm/i915: Add support for pipe_bpp readout
      drm/i915: Add state readout and checking for has_dp_encoder and dp_m_n
      drm/i915: Make intel_fuzzy_clock_check() take in arbitrary clocks
      drm/i915: Add intel_dotclock_calculate()
      drm/i915: Make i9xx_crtc_clock_get() use dpll_hw_state
      drm/i915: Make i9xx_crtc_clock_get() work for PCH DPLLs
      drm/i915: Fix port_clock and adjusted_mode.clock readout all over
      drm/i915: Add PIPE_CONF_CHECK_CLOCK_FUZZY()
      drm/i915: Add fuzzy clock check for port_clock
      drm/i915: Grab the pixel clock from adjusted_mode not requested_mode
      drm/i915: Use adjusted_mode->clock in lpt_program_iclkip
      drm/i915: Use adjusted_mode in HDMI 12bpc clock check
      drm/i915: Use adjusted_mode in intel_update_fbc()
      drm/i915: Use adjusted_mode appropriately when computing watermarks
      drm/i915: Check the clock from adjusted mode in intel_crtc_active()
      drm/i915: Use adjusted_mode when checking conditions for PSR
      drm/i915: Make intel_crtc_active() available outside intel_pm.c
      drm/i915: Use pipe config in sprite code
      drm/i915: Use adjusted_mode in DSI PLL calculations
      drm/i915: Add explicit pipe src size to pipe config
      drm/i915: Document the inteded use of requested_mode
      drm/i915: Fix cursor visibility check with negative coordinates
      drm/i915: Fix cursor visibility checks also for the right/bottom screen edges
      drm/i915: Move double wide mode handling into pipe_config
      drm/i915: Add double_wide readout and checking
      drm/i915: Check pixel clock limits on pre-gen4
      drm/i915: pipe_src_w must be even in LVDS dual channel, DVO ganged, and double wide mode
      drm/i915: Fix up pipe vs. double wide confusion
      drm/i915: Convert overlay double wide check over to pipe config
      drm/i915: Change i915_request power well handling
      drm/i915: Add intel_display_power_{get, put} to request power for specific domains
      drm/i915: Refactor power well refcount inc/dec operations
      drm/i915: Add POWER_DOMAIN_VGA
      drm/i915: Pull intel_init_power_well() out of intel_modeset_init_hw()
      drm/i915: Fix unclaimed register access due to delayed VGA memory disable
      drm/i915: Redisable VGA before the modeset on resume
      drm/i915: Move power well init earlier during driver load
      drm/i915: Move power well resume earlier
      drm/i915: Call intel_uncore_early_sanitize() during resume
      drm/i915: Drop explicit plane restoration during resume
      drm/i915: Fix intel_crtc_mode_get() mode clock
      drm/i915: Add HSW CRT output readout support
      drm/i915: Eliminate one indent leel from vlv_find_best_dpll
      drm/i915: Use DIV_ROUND_CLOSEST()
      drm/i915: Disable/enable planes as the first/last thing during modeset on HSW
      drm/i915: Don't populate pipe_src_{w,h} multiple times
      drm: Make vblank_disable_allowed bool
      drm: Make vblank_inmodeset unsigned
      drm: Make vblank_enabled bool
      drm: Collect per-crtc vblank stuff to a struct
      drm: Make irq_enabled bool
      drm: Kill unused stuff from struct drm_device
      drm: Kill ctx_count from struct drm_device
      drm: Remove pci_vendor and pci_device from struct drm_device
      drm: Kill drm perf counter leftovers
      drm/i915: Make vlv_find_best_dpll() ppm calculation safe
      drm/i915: Don't underflow bestppm
      drm/i915: Rewrite vlv_find_best_dpll()
      drm/i915: De-magic the VLV p2 divider step size
      drm/i915: Make sure we respect n.max on VLV
      drm/i915: Clarify VLV PLL p1 limits
      drm/i915: Allow p1 divider 2 on VLV
      drm/i915: Respect p2 divider minimum limit on VLV
      drm/i915: Remove the unused p and m limits for VLV
      drm/i915: Remove unused dot_limit from VLV PLL limits
      drm/i915: intel_limits_vlv_dac and intel_limits_vlv_hdmi are the same
      drm/i915: Don't lie about findind suitable PLL settings on VLV
      drm/i915: Use intel_PLL_is_valid() in vlv_find_best_dpll()
      drm/i915: Fix VGA_DISP_DISABLE check
      drm/i915: Set primary_disabled in intel_{enable, disable}_plane
      drm/i915: Allow sprites to be configured on a disabled pipe
      drm/i915: Reduce the time we hold struct mutex in sprite update_plane code
      drm/i915: Kill a goto from sprite disable code
      drm/i915: Do a bit of cleanup in the sprite code
      drm/i915: Save user requested plane coordinates only on success
      drm/i915: Do the fbc vs. primary plane enable/disable in the right order
      drm/i915: Enable/disable IPS when primary is enabled/disabled
      drm/i915: Rename intel_flush_display_plane to intel_flush_primary_plane
      drm/i915: Rename intel_{enable, disable}_plane to intel_{enable, disable}_primary_plane
      drm/i915: WARN if primary plane state doesn't match expectations
      drm/i915: Flush primary plane changes in sprite code
      drm/i915: Populate primary_disabled in intel_modeset_readout_hw_state()
      drm/i915: Rename primary_disabled to primary_enabled
      drm/i915: Fix pipe off timeout handling for pre-gen4
      drm/i915: Fix VLV frame counter registers
      drm/i915: Fix pre-CTG vblank counter
      drm/i915: Use DIV_ROUND_CLOSEST() to calculate dot/vco
      drm/i915: Use vlv_clock() in vlv_crtc_clock_get()
      drm/i915: Skip register reads in i915_get_crtc_scanoutpos()
      drm/i915: Fix scanoutpos calculations
      drm/i915: Improve the accuracy of get_scanout_pos on CTG+
      drm/i915: Fix gen2 scanout position readout
      drm/i915: Don't pretend that gen2 has a hardware frame counter
      drm/i915: Add intel_pipe_wm and prepare for watermark pre-compute
      drm/i915: Don't re-compute pipe watermarks except for the affected pipe
      drm/i915: Move LP1+ watermark merging out from hsw_compute_wm_results()
      drm/i915: Use intel_pipe_wm in hsw_find_best_results
      drm/i915: Move some computations out from hsw_compute_wm_parameters()
      drm/i915: Check 5/6 DDB split only when sprites are enabled
      drm/i915: Refactor wm_lp to level calculation
      drm/i915: Kill fbc_wm_enabled from intel_wm_config
      drm/i915: Store current watermark state in dev_priv->wm
      drm/i915: Improve watermark dirtyness checks
      drm/i915: Init HSW watermark tracking in intel_modeset_setup_hw_state()
      drm/i915: Remove a somewhat silly debug print from watermark code
      drm/i915: Adjust watermark register masks
      drm/i915: Rename ilk_wm_max to ilk_compute_wm_maximums
      drm/i915: Rename ilk_check_wm to ilk_validate_wm_level
      drm/i915: Check 5/6 DDB split only when sprites are enabled
      drm/i915: Clamp cursor coordinates to int16_t range
      drm/i915: Give names to the VBT child device type bits
      drm/i915: Make intel_dp_is_edp() less specific
      drm: Consistently return -ENOENT when a mode object can't be found
      drm: Return -ENOENT when a framebuffer can't be found
      drm/gma500: Return -ENOENT when a mode object can't be found
      drm/i915: Return -ENOENT when a mode object can't be found
      drm/radeon: Return -ENOENT when a mode object can't be found
      drm/vmwgfx: Return -ENOENT when a mode object can't be found
      drm/vmwgfx: Return -ENOENT when a framebuffer can't be found
      drm/edid: Fix the 1792x1344-75 EST III mode
      drm/edid: Don't skip every eighth EST III mode
      drm/edid: Yank a helpful comment about EST modes from xf86EdidModes.c
      drm: Pretty print pixel format in drm_fb_get_bpp_depth() and format_check()
      drm/sysfs: Remove stale comments about calling drm_sysfs_connector_add() multiple times
      drm/i915/bdw: Don't muck with gtt_size on Gen8 when PPGTT setup fails
      drm/i915/bdw: Use pipe CSC on Broadwell
      drm/i915/bdw: Add Broadwell display FIFO limits
      drm/i915/bdw: Enable trickle feed on Broadwell
      drm/i915: Use hsw_crt_get_config on BDW

Wei Yongjun (2):
      gpu: host1x: Disable clock on probe failure
      drm/tegra: Disable clock on probe failure

YoungJun Cho (1):
      drm: delete unconsumed pending event list in drm_events_release

ymohanma (1):
      drm/i915: add VLV DSI PLL Calculations

 MAINTAINERS                                        |    2 +
 arch/x86/kernel/early-quirks.c                     |   12 +
 drivers/gpu/drm/Kconfig                            |   73 +-
 drivers/gpu/drm/Makefile                           |    5 +-
 drivers/gpu/drm/armada/Kconfig                     |   24 +
 drivers/gpu/drm/armada/Makefile                    |    7 +
 drivers/gpu/drm/armada/armada_510.c                |   87 +
 drivers/gpu/drm/armada/armada_crtc.c               | 1098 +++++++++++++
 drivers/gpu/drm/armada/armada_crtc.h               |   83 +
 drivers/gpu/drm/armada/armada_debugfs.c            |  177 ++
 drivers/gpu/drm/armada/armada_drm.h                |  113 ++
 drivers/gpu/drm/armada/armada_drv.c                |  421 +++++
 drivers/gpu/drm/armada/armada_fb.c                 |  170 ++
 drivers/gpu/drm/armada/armada_fb.h                 |   24 +
 drivers/gpu/drm/armada/armada_fbdev.c              |  202 +++
 drivers/gpu/drm/armada/armada_gem.c                |  611 +++++++
 drivers/gpu/drm/armada/armada_gem.h                |   52 +
 drivers/gpu/drm/armada/armada_hw.h                 |  318 ++++
 drivers/gpu/drm/armada/armada_ioctlP.h             |   18 +
 drivers/gpu/drm/armada/armada_output.c             |  158 ++
 drivers/gpu/drm/armada/armada_output.h             |   39 +
 drivers/gpu/drm/armada/armada_overlay.c            |  477 ++++++
 drivers/gpu/drm/armada/armada_slave.c              |  139 ++
 drivers/gpu/drm/armada/armada_slave.h              |   26 +
 drivers/gpu/drm/ast/Kconfig                        |    1 +
 drivers/gpu/drm/ast/ast_drv.c                      |    1 -
 drivers/gpu/drm/ast/ast_drv.h                      |    1 -
 drivers/gpu/drm/ast/ast_main.c                     |    6 -
 drivers/gpu/drm/cirrus/Kconfig                     |    1 +
 drivers/gpu/drm/cirrus/cirrus_drv.c                |    1 -
 drivers/gpu/drm/cirrus/cirrus_drv.h                |    1 -
 drivers/gpu/drm/cirrus/cirrus_main.c               |    6 -
 drivers/gpu/drm/cirrus/cirrus_mode.c               |   11 +-
 drivers/gpu/drm/drm_context.c                      |    2 -
 drivers/gpu/drm/drm_crtc.c                         |  153 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |   96 +-
 drivers/gpu/drm/drm_debugfs.c                      |    6 +-
 drivers/gpu/drm/drm_dp_helper.c                    |   16 +-
 drivers/gpu/drm/drm_drv.c                          |   74 +-
 drivers/gpu/drm/drm_edid.c                         |  314 +++-
 drivers/gpu/drm/drm_edid_load.c                    |  108 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   17 +-
 drivers/gpu/drm/drm_fops.c                         |   77 +-
 drivers/gpu/drm/drm_gem.c                          |   29 -
 drivers/gpu/drm/drm_global.c                       |    2 -
 drivers/gpu/drm/drm_info.c                         |    6 +-
 drivers/gpu/drm/drm_ioctl.c                        |   21 +
 drivers/gpu/drm/drm_irq.c                          |  177 +-
 drivers/gpu/drm/drm_lock.c                         |    3 -
 drivers/gpu/drm/drm_modes.c                        |   43 +-
 drivers/gpu/drm/drm_pci.c                          |   69 +-
 drivers/gpu/drm/drm_platform.c                     |   59 +-
 drivers/gpu/drm/drm_prime.c                        |    3 +-
 drivers/gpu/drm/drm_stub.c                         |  362 +++--
 drivers/gpu/drm/drm_sysfs.c                        |   96 +-
 drivers/gpu/drm/drm_usb.c                          |   57 +-
 drivers/gpu/drm/drm_vm.c                           |    2 +-
 drivers/gpu/drm/exynos/Kconfig                     |    1 +
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |    1 -
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |    8 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |    5 -
 drivers/gpu/drm/exynos/exynos_drm_gem.h            |    3 -
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   16 +-
 drivers/gpu/drm/gma500/Kconfig                     |    1 +
 drivers/gpu/drm/gma500/cdv_device.c                |    1 +
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |    2 +-
 drivers/gpu/drm/gma500/framebuffer.c               |    2 +-
 drivers/gpu/drm/gma500/gem.c                       |    5 -
 drivers/gpu/drm/gma500/intel_gmbus.c               |   90 +-
 drivers/gpu/drm/gma500/oaktrail_crtc.c             |  433 +++--
 drivers/gpu/drm/gma500/oaktrail_device.c           |    6 +
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |   30 +-
 drivers/gpu/drm/gma500/psb_device.c                |    1 +
 drivers/gpu/drm/gma500/psb_drv.c                   |   39 +-
 drivers/gpu/drm/gma500/psb_drv.h                   |   58 +-
 drivers/gpu/drm/gma500/psb_intel_display.c         |    2 +-
 drivers/gpu/drm/gma500/psb_intel_sdvo.c            |   59 +-
 drivers/gpu/drm/gma500/psb_irq.c                   |   22 +-
 drivers/gpu/drm/i2c/tda998x_drv.c                  |    3 +
 drivers/gpu/drm/i810/i810_dma.c                    |   11 -
 drivers/gpu/drm/i915/Kconfig                       |   67 +
 drivers/gpu/drm/i915/Makefile                      |    6 +-
 drivers/gpu/drm/i915/dvo.h                         |   11 -
 drivers/gpu/drm/i915/i915_debugfs.c                | 1417 ++++++++++++----
 drivers/gpu/drm/i915/i915_dma.c                    |  118 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  187 ++-
 drivers/gpu/drm/i915/i915_drv.h                    |  437 +++--
 drivers/gpu/drm/i915/i915_gem.c                    |  558 ++++---
 drivers/gpu/drm/i915/i915_gem_context.c            |   64 +-
 drivers/gpu/drm/i915/i915_gem_evict.c              |   50 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  401 +++--
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  508 +++++-
 drivers/gpu/drm/i915/i915_gem_stolen.c             |    2 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c             |    8 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |   46 +-
 drivers/gpu/drm/i915/i915_irq.c                    | 1043 +++++++++---
 drivers/gpu/drm/i915/i915_reg.h                    |  827 +++++++++-
 drivers/gpu/drm/i915/i915_suspend.c                |   44 +-
 drivers/gpu/drm/i915/i915_sysfs.c                  |  152 +-
 drivers/gpu/drm/i915/i915_trace.h                  |   62 +-
 drivers/gpu/drm/i915/intel_bios.c                  |  195 ++-
 drivers/gpu/drm/i915/intel_bios.h                  |  121 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   29 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |  251 ++-
 drivers/gpu/drm/i915/intel_display.c               | 1701 +++++++++++++-------
 drivers/gpu/drm/i915/intel_dp.c                    |  745 ++++++---
 drivers/gpu/drm/i915/intel_drv.h                   |  565 ++++---
 drivers/gpu/drm/i915/intel_dsi.c                   |  620 +++++++
 drivers/gpu/drm/i915/intel_dsi.h                   |  102 ++
 drivers/gpu/drm/i915/intel_dsi_cmd.c               |  427 +++++
 drivers/gpu/drm/i915/intel_dsi_cmd.h               |  109 ++
 drivers/gpu/drm/i915/intel_dsi_pll.c               |  317 ++++
 drivers/gpu/drm/i915/intel_dvo.c                   |   28 +-
 drivers/gpu/drm/i915/{intel_fb.c => intel_fbdev.c} |   33 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |   83 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |   64 +
 drivers/gpu/drm/i915/intel_lvds.c                  |   25 +-
 drivers/gpu/drm/i915/intel_opregion.c              |  494 +++++-
 drivers/gpu/drm/i915/intel_overlay.c               |    9 +-
 drivers/gpu/drm/i915/intel_panel.c                 |  346 ++--
 drivers/gpu/drm/i915/intel_pm.c                    | 1334 ++++++++++-----
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  275 +++-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   15 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   52 +-
 drivers/gpu/drm/i915/intel_sideband.c              |   79 +-
 drivers/gpu/drm/i915/intel_sprite.c                |  203 ++-
 drivers/gpu/drm/i915/intel_tv.c                    |   21 +-
 drivers/gpu/drm/i915/intel_uncore.c                |  433 +++--
 drivers/gpu/drm/mga/mga_dma.c                      |    5 -
 drivers/gpu/drm/mga/mga_irq.c                      |    2 +-
 drivers/gpu/drm/mgag200/Kconfig                    |    1 +
 drivers/gpu/drm/mgag200/mgag200_drv.c              |    1 -
 drivers/gpu/drm/mgag200/mgag200_drv.h              |    1 -
 drivers/gpu/drm/mgag200/mgag200_main.c             |    6 -
 drivers/gpu/drm/mgag200/mgag200_mode.c             |    2 -
 drivers/gpu/drm/msm/Kconfig                        |    1 +
 drivers/gpu/drm/msm/Makefile                       |    1 +
 drivers/gpu/drm/msm/adreno/a2xx.xml.h              |   42 +-
 drivers/gpu/drm/msm/adreno/a3xx.xml.h              |   46 +-
 drivers/gpu/drm/msm/adreno/adreno_common.xml.h     |   10 +-
 drivers/gpu/drm/msm/adreno/adreno_pm4.xml.h        |   10 +-
 drivers/gpu/drm/msm/dsi/dsi.xml.h                  |    6 +-
 drivers/gpu/drm/msm/dsi/mmss_cc.xml.h              |    6 +-
 drivers/gpu/drm/msm/dsi/sfpb.xml.h                 |    6 +-
 drivers/gpu/drm/msm/hdmi/hdmi.xml.h                |    6 +-
 drivers/gpu/drm/msm/hdmi/qfprom.xml.h              |    6 +-
 drivers/gpu/drm/msm/mdp4/mdp4.xml.h                |  126 +-
 drivers/gpu/drm/msm/mdp4/mdp4_crtc.c               |  208 ++-
 drivers/gpu/drm/msm/mdp4/mdp4_format.c             |   16 +
 drivers/gpu/drm/msm/mdp4/mdp4_kms.c                |   19 +-
 drivers/gpu/drm/msm/mdp4/mdp4_kms.h                |   58 +-
 drivers/gpu/drm/msm/mdp4/mdp4_plane.c              |   30 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   60 +-
 drivers/gpu/drm/msm/msm_drv.h                      |   37 +-
 drivers/gpu/drm/msm/msm_gem.c                      |  160 +-
 drivers/gpu/drm/msm/msm_gem.h                      |    3 -
 drivers/gpu/drm/msm/msm_gem_prime.c                |   56 +
 drivers/gpu/drm/msm/msm_gpu.c                      |    4 +-
 drivers/gpu/drm/nouveau/Kconfig                    |    1 +
 drivers/gpu/drm/nouveau/Makefile                   |   48 +-
 drivers/gpu/drm/nouveau/core/core/event.c          |  119 +-
 drivers/gpu/drm/nouveau/core/core/option.c         |   11 +-
 drivers/gpu/drm/nouveau/core/core/printk.c         |   45 +-
 drivers/gpu/drm/nouveau/core/engine/device/base.c  |   56 +-
 drivers/gpu/drm/nouveau/core/engine/device/ctrl.c  |  144 ++
 drivers/gpu/drm/nouveau/core/engine/device/nv04.c  |   20 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv10.c  |   76 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv20.c  |   40 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv30.c  |   50 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv40.c  |  218 +--
 drivers/gpu/drm/nouveau/core/engine/device/nv50.c  |  195 ++-
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |  118 +-
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |   99 +-
 drivers/gpu/drm/nouveau/core/engine/device/priv.h  |    8 +
 drivers/gpu/drm/nouveau/core/engine/disp/dport.c   |   52 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv04.c    |    9 +
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c    |    9 +
 drivers/gpu/drm/nouveau/core/engine/disp/sornv94.c |   12 +-
 drivers/gpu/drm/nouveau/core/engine/disp/sornvd0.c |   12 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv04.c    |    4 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv10.c    |    4 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv17.c    |    4 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv40.c    |    4 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv50.c    |    4 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv84.c    |   10 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c    |   11 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |   11 +-
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc0.c    |    2 +-
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc1.c    |    4 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnvd7.c    |    1 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnvd9.c    |    1 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv10.c   |   14 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv31.c    |   68 +-
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv31.h    |   15 +
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv40.c    |  103 +-
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv44.c    |  194 +++
 drivers/gpu/drm/nouveau/core/engine/perfmon/base.c |  449 ++++++
 .../gpu/drm/nouveau/core/engine/perfmon/daemon.c   |  109 ++
 drivers/gpu/drm/nouveau/core/engine/perfmon/nv40.c |  143 ++
 drivers/gpu/drm/nouveau/core/engine/perfmon/nv40.h |   26 +
 drivers/gpu/drm/nouveau/core/engine/perfmon/nv50.c |   70 +
 drivers/gpu/drm/nouveau/core/engine/perfmon/nv84.c |   78 +
 drivers/gpu/drm/nouveau/core/engine/perfmon/nva3.c |   96 ++
 drivers/gpu/drm/nouveau/core/engine/perfmon/nvc0.c |  173 ++
 drivers/gpu/drm/nouveau/core/engine/perfmon/nvc0.h |   17 +
 drivers/gpu/drm/nouveau/core/engine/perfmon/nve0.c |  162 ++
 drivers/gpu/drm/nouveau/core/engine/perfmon/nvf0.c |   71 +
 drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h |   91 ++
 .../gpu/drm/nouveau/core/engine/software/nv04.c    |    4 +-
 .../gpu/drm/nouveau/core/engine/software/nv10.c    |    4 +-
 .../gpu/drm/nouveau/core/engine/software/nv50.c    |   96 +-
 .../gpu/drm/nouveau/core/engine/software/nv50.h    |   47 +
 .../gpu/drm/nouveau/core/engine/software/nvc0.c    |  130 +-
 drivers/gpu/drm/nouveau/core/include/core/class.h  |   73 +-
 drivers/gpu/drm/nouveau/core/include/core/debug.h  |    9 +-
 drivers/gpu/drm/nouveau/core/include/core/device.h |    7 +-
 drivers/gpu/drm/nouveau/core/include/core/event.h  |   22 +-
 drivers/gpu/drm/nouveau/core/include/core/option.h |    9 +
 drivers/gpu/drm/nouveau/core/include/core/printk.h |   30 +-
 drivers/gpu/drm/nouveau/core/include/engine/fifo.h |   16 +-
 drivers/gpu/drm/nouveau/core/include/engine/mpeg.h |    5 +-
 .../gpu/drm/nouveau/core/include/engine/perfmon.h  |   39 +
 .../gpu/drm/nouveau/core/include/engine/software.h |   17 +-
 .../drm/nouveau/core/include/subdev/bios/boost.h   |   29 +
 .../drm/nouveau/core/include/subdev/bios/cstep.h   |   28 +
 .../drm/nouveau/core/include/subdev/bios/gpio.h    |   10 +-
 .../drm/nouveau/core/include/subdev/bios/perf.h    |   33 +
 .../drm/nouveau/core/include/subdev/bios/rammap.h  |   11 +
 .../drm/nouveau/core/include/subdev/bios/timing.h  |    8 +
 .../drm/nouveau/core/include/subdev/bios/vmap.h    |   25 +
 .../drm/nouveau/core/include/subdev/bios/volt.h    |   27 +
 drivers/gpu/drm/nouveau/core/include/subdev/bus.h  |   20 +-
 .../gpu/drm/nouveau/core/include/subdev/clock.h    |  111 +-
 drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |   50 +-
 drivers/gpu/drm/nouveau/core/include/subdev/i2c.h  |    7 +-
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h   |   29 +-
 drivers/gpu/drm/nouveau/core/include/subdev/pwr.h  |   80 +
 .../gpu/drm/nouveau/core/include/subdev/therm.h    |    2 +
 drivers/gpu/drm/nouveau/core/include/subdev/volt.h |   60 +
 drivers/gpu/drm/nouveau/core/subdev/bios/boost.c   |  127 ++
 drivers/gpu/drm/nouveau/core/subdev/bios/cstep.c   |  123 ++
 drivers/gpu/drm/nouveau/core/subdev/bios/dp.c      |   10 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/perf.c    |  140 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/pll.c     |    1 +
 drivers/gpu/drm/nouveau/core/subdev/bios/rammap.c  |   88 +
 drivers/gpu/drm/nouveau/core/subdev/bios/timing.c  |   73 +
 drivers/gpu/drm/nouveau/core/subdev/bios/vmap.c    |  112 ++
 drivers/gpu/drm/nouveau/core/subdev/bios/volt.c    |  137 ++
 drivers/gpu/drm/nouveau/core/subdev/bus/hwsq.c     |  145 ++
 drivers/gpu/drm/nouveau/core/subdev/bus/hwsq.h     |  113 ++
 drivers/gpu/drm/nouveau/core/subdev/bus/nv04.c     |   44 +-
 drivers/gpu/drm/nouveau/core/subdev/bus/nv04.h     |   23 +
 drivers/gpu/drm/nouveau/core/subdev/bus/nv31.c     |   38 +-
 drivers/gpu/drm/nouveau/core/subdev/bus/nv50.c     |   60 +-
 drivers/gpu/drm/nouveau/core/subdev/bus/nv94.c     |   59 +
 drivers/gpu/drm/nouveau/core/subdev/bus/nvc0.c     |   38 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/base.c   |  494 ++++++
 drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nv40.c   |  183 ++-
 drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c   |  520 +++++-
 drivers/gpu/drm/nouveau/core/subdev/clock/nv50.h   |   31 +
 drivers/gpu/drm/nouveau/core/subdev/clock/nv84.c   |   48 +
 drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c   |  271 +++-
 drivers/gpu/drm/nouveau/core/subdev/clock/nva3.h   |   14 +
 drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c   |  404 ++++-
 drivers/gpu/drm/nouveau/core/subdev/clock/nve0.c   |  497 ++++++
 .../gpu/drm/nouveau/core/subdev/clock/pllnv04.c    |   37 +-
 .../gpu/drm/nouveau/core/subdev/clock/pllnva3.c    |    1 +
 drivers/gpu/drm/nouveau/core/subdev/clock/seq.h    |   17 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c |   10 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/base.c      |   15 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/gddr5.c     |   96 ++
 drivers/gpu/drm/nouveau/core/subdev/fb/nv04.c      |   29 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv04.h      |   55 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv10.c      |   45 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv1a.c      |   45 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv20.c      |   47 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv25.c      |   47 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv30.c      |   53 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv35.c      |   47 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv36.c      |   47 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv40.c      |   50 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv40.h      |   17 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv41.c      |   50 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv44.c      |   48 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv46.c      |   46 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv47.c      |   48 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv49.c      |   48 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv4e.c      |   45 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c      |   51 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.h      |   33 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv84.c      |   39 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nva3.c      |   39 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nvaa.c      |   39 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nvaf.c      |   39 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |   33 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.h      |   29 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nve0.c      |   38 +
 drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |   53 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramfuc.h    |  118 ++
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv40.c   |  168 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv41.c   |   19 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv44.c   |   15 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv49.c   |   19 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv50.c   |  344 +++-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c   |  447 +++++
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvaa.c   |   66 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c   |  567 ++++++-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnve0.c   | 1264 +++++++++++++++
 drivers/gpu/drm/nouveau/core/subdev/fb/ramseq.h    |   18 +
 drivers/gpu/drm/nouveau/core/subdev/fb/sddr3.c     |   99 ++
 drivers/gpu/drm/nouveau/core/subdev/gpio/base.c    |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c     |   27 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c      |   89 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.c      |   44 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.h      |   21 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv40.c      |   45 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv44.c      |   38 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c      |   41 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv94.c      |   38 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c      |   37 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c      |   40 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc3.c      |   38 +
 drivers/gpu/drm/nouveau/core/subdev/pwr/base.c     |  247 +++
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/host.fuc   |  151 ++
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/idle.fuc   |   84 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/kernel.fuc |  452 ++++++
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/macros.fuc |  199 +++
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/memx.fuc   |  219 +++
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nv108.fuc  |   63 +
 .../drm/nouveau/core/subdev/pwr/fuc/nv108.fuc.h    | 1165 ++++++++++++++
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nva3.fuc   |   63 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nva3.fuc.h | 1229 ++++++++++++++
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvc0.fuc   |   63 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvc0.fuc.h | 1229 ++++++++++++++
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvd0.fuc   |   63 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvd0.fuc.h | 1229 ++++++++++++++
 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/os.h   |   27 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/perf.fuc   |   57 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/test.fuc   |   64 +
 drivers/gpu/drm/nouveau/core/subdev/pwr/memx.c     |  121 ++
 drivers/gpu/drm/nouveau/core/subdev/pwr/nv108.c    |   62 +
 drivers/gpu/drm/nouveau/core/subdev/pwr/nva3.c     |   71 +
 drivers/gpu/drm/nouveau/core/subdev/pwr/nvc0.c     |   62 +
 drivers/gpu/drm/nouveau/core/subdev/pwr/nvd0.c     |   62 +
 drivers/gpu/drm/nouveau/core/subdev/therm/base.c   |   55 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c    |    3 +
 drivers/gpu/drm/nouveau/core/subdev/therm/fantog.c |    7 +
 drivers/gpu/drm/nouveau/core/subdev/therm/ic.c     |   54 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nv84.c   |   17 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nva3.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nvd0.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/priv.h   |    2 +
 drivers/gpu/drm/nouveau/core/subdev/therm/temp.c   |    2 -
 drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c   |   10 +-
 drivers/gpu/drm/nouveau/core/subdev/volt/base.c    |  198 +++
 drivers/gpu/drm/nouveau/core/subdev/volt/gpio.c    |   96 ++
 drivers/gpu/drm/nouveau/core/subdev/volt/nv40.c    |   56 +
 drivers/gpu/drm/nouveau/dispnv04/Makefile          |    1 +
 drivers/gpu/drm/nouveau/dispnv04/arb.c             |    8 +-
 drivers/gpu/drm/nouveau/dispnv04/crtc.c            |    2 -
 drivers/gpu/drm/nouveau/dispnv04/dfp.c             |   22 +-
 drivers/gpu/drm/nouveau/dispnv04/disp.c            |    2 +
 drivers/gpu/drm/nouveau/dispnv04/disp.h            |    9 +-
 drivers/gpu/drm/nouveau/dispnv04/hw.c              |   16 +-
 drivers/gpu/drm/nouveau/dispnv04/overlay.c         |  320 ++++
 drivers/gpu/drm/nouveau/dispnv04/tvnv04.c          |   22 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |   11 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |   10 +
 drivers/gpu/drm/nouveau/nouveau_agp.c              |   44 +-
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |    4 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |    4 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   25 +-
 drivers/gpu/drm/nouveau/nouveau_bo.h               |    5 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   11 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   21 +-
 drivers/gpu/drm/nouveau/nouveau_connector.h        |    5 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |  185 ++-
 drivers/gpu/drm/nouveau/nouveau_display.h          |    4 +
 drivers/gpu/drm/nouveau/nouveau_dma.h              |    7 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  121 +-
 drivers/gpu/drm/nouveau/nouveau_drm.h              |   15 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   45 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   30 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   51 +-
 drivers/gpu/drm/nouveau/nouveau_gem.h              |    3 +-
 .../drm/nouveau/{nouveau_pm.c => nouveau_hwmon.c}  |  560 +------
 drivers/gpu/drm/nouveau/nouveau_hwmon.h            |   43 +
 drivers/gpu/drm/nouveau/nouveau_hwsq.h             |  115 --
 drivers/gpu/drm/nouveau/nouveau_mem.c              |  647 --------
 drivers/gpu/drm/nouveau/nouveau_perf.c             |  416 -----
 drivers/gpu/drm/nouveau/nouveau_pm.h               |  283 ----
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   10 +-
 drivers/gpu/drm/nouveau/nouveau_sysfs.c            |  162 ++
 drivers/gpu/drm/nouveau/nouveau_sysfs.h            |   19 +
 drivers/gpu/drm/nouveau/nouveau_volt.c             |  250 ---
 drivers/gpu/drm/nouveau/nv04_fbcon.c               |    6 +
 drivers/gpu/drm/nouveau/nv04_pm.c                  |  146 --
 drivers/gpu/drm/nouveau/nv40_pm.c                  |  353 ----
 drivers/gpu/drm/nouveau/nv50_pm.c                  |  855 ----------
 drivers/gpu/drm/nouveau/nva3_pm.c                  |  624 -------
 drivers/gpu/drm/nouveau/nvc0_pm.c                  |  599 -------
 drivers/gpu/drm/omapdrm/Kconfig                    |    1 +
 drivers/gpu/drm/omapdrm/omap_drv.c                 |    1 -
 drivers/gpu/drm/omapdrm/omap_drv.h                 |    1 -
 drivers/gpu/drm/omapdrm/omap_gem.c                 |    5 -
 drivers/gpu/drm/omapdrm/omap_irq.c                 |   17 +-
 drivers/gpu/drm/qxl/Kconfig                        |    1 +
 drivers/gpu/drm/qxl/qxl_display.c                  |   51 +-
 drivers/gpu/drm/qxl/qxl_drv.c                      |    1 -
 drivers/gpu/drm/qxl/qxl_drv.h                      |    3 +-
 drivers/gpu/drm/qxl/qxl_fb.c                       |    2 +-
 drivers/gpu/drm/qxl/qxl_gem.c                      |    6 -
 drivers/gpu/drm/qxl/qxl_kms.c                      |   42 +-
 drivers/gpu/drm/qxl/qxl_ttm.c                      |    2 +
 drivers/gpu/drm/radeon/atombios.h                  |  127 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |   21 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |    3 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   26 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |   58 +-
 drivers/gpu/drm/radeon/ci_smc.c                    |    4 +
 drivers/gpu/drm/radeon/cik.c                       |  757 +++++++--
 drivers/gpu/drm/radeon/cik_sdma.c                  |   62 +-
 drivers/gpu/drm/radeon/cikd.h                      |  103 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                 |   66 +-
 drivers/gpu/drm/radeon/evergreen.c                 |   80 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |   71 +-
 drivers/gpu/drm/radeon/evergreend.h                |   70 +
 drivers/gpu/drm/radeon/ni.c                        |   76 -
 drivers/gpu/drm/radeon/ni_dma.c                    |   19 +-
 drivers/gpu/drm/radeon/r100.c                      |    2 +-
 drivers/gpu/drm/radeon/r600.c                      |   53 +
 drivers/gpu/drm/radeon/r600_cs.c                   |   18 +-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |  102 +-
 drivers/gpu/drm/radeon/r600d.h                     |   28 +
 drivers/gpu/drm/radeon/radeon.h                    |   33 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |   74 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   35 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c       |    4 +
 drivers/gpu/drm/radeon/radeon_bios.c               |    6 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |  116 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |  298 ++--
 drivers/gpu/drm/radeon/radeon_device.c             |   78 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   83 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |  173 +-
 drivers/gpu/drm/radeon/radeon_drv.h                |    3 +
 drivers/gpu/drm/radeon/radeon_family.h             |    1 +
 drivers/gpu/drm/radeon/radeon_fence.c              |  350 ++--
 drivers/gpu/drm/radeon/radeon_gart.c               |   73 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |    7 -
 drivers/gpu/drm/radeon/radeon_ioc32.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |    8 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   28 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |   21 +
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |    2 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |   17 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |   65 +-
 drivers/gpu/drm/radeon/radeon_trace.h              |   24 +
 drivers/gpu/drm/radeon/radeon_ucode.h              |    4 +
 drivers/gpu/drm/radeon/radeon_uvd.c                |    5 +-
 drivers/gpu/drm/radeon/rs600.c                     |   64 +
 drivers/gpu/drm/radeon/rs690.c                     |   16 +-
 drivers/gpu/drm/radeon/rv515.c                     |    8 -
 drivers/gpu/drm/radeon/rv6xx_dpm.c                 |    6 +-
 drivers/gpu/drm/radeon/si.c                        |   99 +-
 drivers/gpu/drm/radeon/si_dma.c                    |   22 +-
 drivers/gpu/drm/radeon/si_dpm.c                    |    9 +-
 drivers/gpu/drm/radeon/sid.h                       |   47 +-
 drivers/gpu/drm/rcar-du/Kconfig                    |    1 +
 drivers/gpu/drm/shmobile/Kconfig                   |    2 +
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c          |    4 +-
 drivers/gpu/{host1x/drm => drm/tegra}/Kconfig      |   13 +-
 drivers/gpu/drm/tegra/Makefile                     |   15 +
 drivers/gpu/drm/tegra/bus.c                        |   76 +
 drivers/gpu/{host1x/drm => drm/tegra}/dc.c         |  108 +-
 drivers/gpu/{host1x/drm => drm/tegra}/dc.h         |    5 +
 drivers/gpu/drm/tegra/drm.c                        |  714 ++++++++
 drivers/gpu/{host1x/drm => drm/tegra}/drm.h        |  101 +-
 drivers/gpu/{host1x/drm => drm/tegra}/fb.c         |   38 +-
 drivers/gpu/{host1x/drm => drm/tegra}/gem.c        |   44 +-
 drivers/gpu/{host1x/drm => drm/tegra}/gem.h        |   16 +-
 drivers/gpu/drm/tegra/gr2d.c                       |  227 +++
 drivers/gpu/drm/tegra/gr2d.h                       |   28 +
 drivers/gpu/drm/tegra/gr3d.c                       |  338 ++++
 drivers/gpu/drm/tegra/gr3d.h                       |   27 +
 drivers/gpu/{host1x/drm => drm/tegra}/hdmi.c       |  257 ++-
 drivers/gpu/{host1x/drm => drm/tegra}/hdmi.h       |  152 +-
 drivers/gpu/{host1x/drm => drm/tegra}/output.c     |   64 +-
 drivers/gpu/{host1x/drm => drm/tegra}/rgb.c        |   19 +-
 drivers/gpu/drm/tilcdc/Kconfig                     |    1 +
 drivers/gpu/drm/ttm/Makefile                       |    6 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   46 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |   30 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |   92 +-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |    3 +
 drivers/gpu/drm/udl/Kconfig                        |    1 +
 drivers/gpu/drm/udl/udl_drv.c                      |    1 -
 drivers/gpu/drm/udl/udl_drv.h                      |    1 -
 drivers/gpu/drm/udl/udl_gem.c                      |    7 -
 drivers/gpu/drm/via/via_mm.c                       |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c             |  379 ++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   94 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   98 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c                |  153 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c              |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   42 +-
 drivers/gpu/host1x/Kconfig                         |    2 -
 drivers/gpu/host1x/Makefile                        |   13 +-
 drivers/gpu/host1x/bus.c                           |  550 +++++++
 drivers/gpu/host1x/{host1x_client.h => bus.h}      |   24 +-
 drivers/gpu/host1x/cdma.c                          |    2 +-
 drivers/gpu/host1x/channel.h                       |    6 -
 drivers/gpu/host1x/dev.c                           |   82 +-
 drivers/gpu/host1x/dev.h                           |   11 +-
 drivers/gpu/host1x/drm/drm.c                       |  647 --------
 drivers/gpu/host1x/drm/gr2d.c                      |  343 ----
 drivers/gpu/host1x/host1x.h                        |   30 -
 drivers/gpu/host1x/host1x_bo.h                     |   87 -
 drivers/gpu/host1x/hw/Makefile                     |    6 -
 drivers/gpu/host1x/hw/cdma_hw.c                    |    8 +-
 drivers/gpu/host1x/hw/channel_hw.c                 |   32 +-
 drivers/gpu/host1x/hw/debug_hw.c                   |   16 +-
 drivers/gpu/host1x/hw/host1x01.c                   |   16 +-
 drivers/gpu/host1x/hw/host1x02.c                   |   42 +
 drivers/gpu/host1x/hw/host1x02.h                   |   26 +
 drivers/gpu/host1x/hw/hw_host1x01_uclass.h         |    6 +
 drivers/gpu/host1x/hw/hw_host1x02_channel.h        |  121 ++
 drivers/gpu/host1x/hw/hw_host1x02_sync.h           |  243 +++
 drivers/gpu/host1x/hw/hw_host1x02_uclass.h         |  175 ++
 drivers/gpu/host1x/hw/intr_hw.c                    |    4 +-
 drivers/gpu/host1x/hw/syncpt_hw.c                  |    4 +-
 drivers/gpu/host1x/job.c                           |   73 +-
 drivers/gpu/host1x/job.h                           |  108 --
 drivers/gpu/host1x/syncpt.c                        |   92 +-
 drivers/gpu/host1x/syncpt.h                        |   46 +-
 drivers/staging/imx-drm/Kconfig                    |    1 +
 drivers/staging/imx-drm/imx-drm-core.c             |    8 +-
 drivers/video/Kconfig                              |    4 +-
 include/drm/drmP.h                                 |  111 +-
 include/drm/drm_crtc.h                             |   39 +-
 include/drm/drm_crtc_helper.h                      |    2 +-
 include/drm/drm_dp_helper.h                        |   31 +-
 include/drm/drm_pciids.h                           |   12 +
 include/drm/i915_drm.h                             |    4 +
 include/drm/i915_pciids.h                          |   25 +
 include/drm/ttm/ttm_page_alloc.h                   |   11 +-
 include/linux/cpufreq.h                            |    8 +
 include/linux/host1x.h                             |  284 ++++
 include/uapi/drm/armada_drm.h                      |   45 +
 include/uapi/drm/drm.h                             |   37 +-
 include/uapi/drm/drm_mode.h                        |   45 +-
 include/uapi/drm/i915_drm.h                        |    8 +-
 include/uapi/drm/tegra_drm.h                       |   29 +-
 557 files changed, 44648 insertions(+), 14957 deletions(-)
 create mode 100644 drivers/gpu/drm/armada/Kconfig
 create mode 100644 drivers/gpu/drm/armada/Makefile
 create mode 100644 drivers/gpu/drm/armada/armada_510.c
 create mode 100644 drivers/gpu/drm/armada/armada_crtc.c
 create mode 100644 drivers/gpu/drm/armada/armada_crtc.h
 create mode 100644 drivers/gpu/drm/armada/armada_debugfs.c
 create mode 100644 drivers/gpu/drm/armada/armada_drm.h
 create mode 100644 drivers/gpu/drm/armada/armada_drv.c
 create mode 100644 drivers/gpu/drm/armada/armada_fb.c
 create mode 100644 drivers/gpu/drm/armada/armada_fb.h
 create mode 100644 drivers/gpu/drm/armada/armada_fbdev.c
 create mode 100644 drivers/gpu/drm/armada/armada_gem.c
 create mode 100644 drivers/gpu/drm/armada/armada_gem.h
 create mode 100644 drivers/gpu/drm/armada/armada_hw.h
 create mode 100644 drivers/gpu/drm/armada/armada_ioctlP.h
 create mode 100644 drivers/gpu/drm/armada/armada_output.c
 create mode 100644 drivers/gpu/drm/armada/armada_output.h
 create mode 100644 drivers/gpu/drm/armada/armada_overlay.c
 create mode 100644 drivers/gpu/drm/armada/armada_slave.c
 create mode 100644 drivers/gpu/drm/armada/armada_slave.h
 create mode 100644 drivers/gpu/drm/i915/Kconfig
 create mode 100644 drivers/gpu/drm/i915/intel_dsi.c
 create mode 100644 drivers/gpu/drm/i915/intel_dsi.h
 create mode 100644 drivers/gpu/drm/i915/intel_dsi_cmd.c
 create mode 100644 drivers/gpu/drm/i915/intel_dsi_cmd.h
 create mode 100644 drivers/gpu/drm/i915/intel_dsi_pll.c
 rename drivers/gpu/drm/i915/{intel_fb.c => intel_fbdev.c} (89%)
 create mode 100644 drivers/gpu/drm/msm/msm_gem_prime.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/device/ctrl.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/device/priv.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/mpeg/nv31.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/mpeg/nv44.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/perfmon/daemon.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/perfmon/nv40.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/perfmon/nv40.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/perfmon/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/perfmon/nv84.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/perfmon/nva3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/perfmon/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/perfmon/nvc0.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/perfmon/nve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/perfmon/nvf0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/software/nv50.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/perfmon.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/boost.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/cstep.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/rammap.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/timing.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/vmap.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/volt.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/pwr.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/volt.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/boost.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/cstep.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/rammap.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/timing.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/vmap.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/volt.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bus/hwsq.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bus/hwsq.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bus/nv04.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bus/nv94.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/nv50.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/nv84.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/nva3.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/nve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/seq.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/gddr5.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv04.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv40.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv84.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nva3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nvaa.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nvaf.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramfuc.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvaa.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramseq.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/sddr3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mc/nv40.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mc/nv94.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mc/nvc3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/host.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/idle.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/kernel.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/macros.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/memx.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/nv108.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/nv108.fuc.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/nva3.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/nva3.fuc.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/nvc0.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/nvc0.fuc.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/nvd0.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/nvd0.fuc.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/os.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/perf.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/test.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/memx.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/nv108.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/nva3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/nvd0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/volt/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/volt/gpio.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/volt/nv40.c
 create mode 100644 drivers/gpu/drm/nouveau/dispnv04/overlay.c
 rename drivers/gpu/drm/nouveau/{nouveau_pm.c => nouveau_hwmon.c} (57%)
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_hwmon.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_hwsq.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_mem.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_perf.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_pm.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_sysfs.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_sysfs.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_volt.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv04_pm.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv40_pm.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_pm.c
 delete mode 100644 drivers/gpu/drm/nouveau/nva3_pm.c
 delete mode 100644 drivers/gpu/drm/nouveau/nvc0_pm.c
 rename drivers/gpu/{host1x/drm => drm/tegra}/Kconfig (87%)
 create mode 100644 drivers/gpu/drm/tegra/Makefile
 create mode 100644 drivers/gpu/drm/tegra/bus.c
 rename drivers/gpu/{host1x/drm => drm/tegra}/dc.c (93%)
 rename drivers/gpu/{host1x/drm => drm/tegra}/dc.h (98%)
 create mode 100644 drivers/gpu/drm/tegra/drm.c
 rename drivers/gpu/{host1x/drm => drm/tegra}/drm.h (72%)
 rename drivers/gpu/{host1x/drm => drm/tegra}/fb.c (92%)
 rename drivers/gpu/{host1x/drm => drm/tegra}/gem.c (86%)
 rename drivers/gpu/{host1x/drm => drm/tegra}/gem.h (84%)
 create mode 100644 drivers/gpu/drm/tegra/gr2d.c
 create mode 100644 drivers/gpu/drm/tegra/gr2d.h
 create mode 100644 drivers/gpu/drm/tegra/gr3d.c
 create mode 100644 drivers/gpu/drm/tegra/gr3d.h
 rename drivers/gpu/{host1x/drm => drm/tegra}/hdmi.c (83%)
 rename drivers/gpu/{host1x/drm => drm/tegra}/hdmi.h (72%)
 rename drivers/gpu/{host1x/drm => drm/tegra}/output.c (91%)
 rename drivers/gpu/{host1x/drm => drm/tegra}/rgb.c (96%)
 create mode 100644 drivers/gpu/host1x/bus.c
 rename drivers/gpu/host1x/{host1x_client.h => bus.h} (60%)
 delete mode 100644 drivers/gpu/host1x/drm/drm.c
 delete mode 100644 drivers/gpu/host1x/drm/gr2d.c
 delete mode 100644 drivers/gpu/host1x/host1x.h
 delete mode 100644 drivers/gpu/host1x/host1x_bo.h
 delete mode 100644 drivers/gpu/host1x/hw/Makefile
 create mode 100644 drivers/gpu/host1x/hw/host1x02.c
 create mode 100644 drivers/gpu/host1x/hw/host1x02.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x02_channel.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x02_sync.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x02_uclass.h
 create mode 100644 include/linux/host1x.h
 create mode 100644 include/uapi/drm/armada_drm.h
--29444707-1428777967-1384484956=:2218--
