Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3GIBve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:51:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51489 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab3GIBv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:51:26 -0400
Date: Tue, 9 Jul 2013 02:51:38 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm for 3.11 merge window
Message-ID: <alpine.DEB.2.00.1307090250530.10519@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-554755630-1373334698=:10519"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-554755630-1373334698=:10519
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Okay this is the big one, I was stalled on the fbdev pull req as I stupidly let fbdev guys merge
a patch I required to fix a warning with some patches I had, they ended up merging the patch from
the wrong place, but the warning should be fixed. In future I'll just take the patch myself!

Outside drm:
there are some snd changes for the HDMI audio interactions on haswell, they've been acked for
inclusion via my tree.
This relies on the wound/wait tree from Ingo which is already merged.

Major changes:
AMD finally released the dynamic power management code for all their GPUs from r600->present day,
this is great, off by default for now but also a huge amount of code, in fact it is most of this pull
request. Since it landed there has been a lot of community testing and Alex has sent a lot of fixes
for any bugs found so far. I suspect radeon might now be the biggest kernel driver ever :-P
p.s. radeon.dpm=1 to enable dynamic powermanagement for anyone.

New drivers:
Renesas r-car display unit.

Other highlights:
core: GEM CMA prime support, use new w/w mutexs for TTM reservations, cursor hotspot, doc updates
dvo chips: chrontel 7010B support
i915: Haswell (fbc, ips, vecs, watermarks, audio powerwell), Valleyview (enabled by default, rc6),
lots of pll reworking, 30bpp support (this time for sure)
nouveau: async buffer object deletion, context/register init updates, kernel vp2 engine support,
GF117 support, GK110 accel support (with external nvidia ucode), context cleanups.
exynos: memory leak fixes, Add S3C64XX SoC series support, device tree updates, common clock framework
support,
qxl: cursor hotspot support, multi-monitor support, suspend/resume support,
mgag200: hw cursor support, g200 mode limiting
shmobile: prime support
tegra: fixes mostly

I've been banging on this quite a lot due to the size of it, and it seems to okay on everything
I've tested it on.

Dave.


The following changes since commit 166989e366ffa66108b2f37b870e66b85b2185ad:

  locking-selftests: Handle unexpected failures more strictly (2013-06-26 12:10:59 +0200)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to 774d8e34e46506222bb5e2888e3ef42b2775715f:

  Merge branch 'drm-next-3.11' of git://people.freedesktop.org/~agd5f/linux into drm-next (2013-07-09 10:49:39 +1000)

----------------------------------------------------------------

Al Viro (1):
      drm_vm: drop explicit VM_IO setting

Alex Deucher (203):
      drm/radeon: fix UVD on big endian
      drm/radeon: fix AVI infoframe generation
      drm/radeon: add backlight quirk for hybrid mac
      drm/radeon: add a reset work handler
      drm/radeon: add CIK chip families
      drm/radeon: add DCE8 macro for CIK
      drm/radeon: adapt to PCI BAR changes on CIK
      drm/radeon: add gpu init support for CIK (v9)
      drm/radeon: Add support for CIK GPU reset (v2)
      drm/radeon: add support for MC/VM setup on CIK (v6)
      drm/radeon/cik: stop page faults from hanging the system (v2)
      drm/radeon: add initial ucode loading for CIK (v5)
      drm/radeon: add support mc ucode loading on CIK (v2)
      drm/radeon: Add CP init for CIK (v7)
      drm/radeon: add IB and fence dispatch functions for CIK gfx (v7)
      drm/radeon: add ring and IB tests for CIK (v3)
      drm/radeon: implement async vm_flush for the CP (v7)
      drm/radeon: Add support for RLC init on CIK (v4)
      drm/radeon: add support for interrupts on CIK (v5)
      drm/radeon/cik: log and handle VM page fault interrupts
      drm/radeon/cik: add support for sDMA dma engines (v8)
      drm/radeon: implement async vm_flush for the sDMA (v6)
      drm/radeon/cik: add support for doing async VM pt updates (v5)
      drm/radeon/cik: fill in startup/shutdown callbacks (v5)
      drm/radeon: upstream ObjectID.h updates (v2)
      drm/radeon: upstream atombios.h updates (v2)
      drm/radeon: atombios power table updates (v2)
      drm/radeon: handle the integrated thermal controller on CI
      drm/radeon: update power state parsing for CI
      drm/radeon/dce8: add support for display watermark setup
      drm/radeon/cik: add hw cursor support (v2)
      drm/radeon/dce8: properly handle interlaced timing
      drm/radeon/dce8: crtc_set_base updates
      drm/radeon/atom: add DCE8 encoder support
      drm/radeon/atom: add support for new DVO tables
      drm/radeon: update DISPCLK programming for DCE8
      drm/radeon: add support pll selection for DCE8 (v4)
      drm/radeon: Handle PPLL0 powerdown on DCE8
      drm/radeon: use frac fb div on DCE8
      drm/radeon: add SS override support for KB/KV
      drm/radeon: Update radeon_info_ioctl for CIK (v2)
      drm/radeon: add get_gpu_clock_counter() callback for cik
      drm/radeon: update CIK soft reset
      drm/radeon: add indirect register accessors for SMC registers
      drm/radeon: add get_xclk() callback for CIK
      drm/radeon/cik: add pcie_port indirect register accessors
      drm/radeon: update radeon_atom_get_clock_dividers() for SI
      drm/radeon: update radeon_atom_get_clock_dividers for CIK
      drm/radeon/cik: add srbm_select function
      drm/radeon: use callbacks for ring pointer handling (v3)
      drm/radeon: implement simple doorbell page allocator
      drm/radeon/cik: Add support for compute queues (v4)
      drm/radeon/cik: switch to type3 nop packet for compute rings (v2)
      drm/radeon: fix up ring functions for compute rings
      drm/radeon/cik: add support for compute interrupts
      drm/radeon/cik: add support for golden register init
      drm/radeon: add radeon_asic struct for CIK (v12)
      drm/radeon: add cik tile mode array query
      drm/radeon: add current Bonaire PCI ids
      drm/radeon: add current KB pci ids
      drm/radeon/kms: add accessors for RCU indirect space
      drm/radeon/evergreen: add indirect register accessors for CG registers
      drm/radeon: make get_temperature functions a callback
      drm/radeon: add support for thermal sensor on tn
      drm/radeon/kms: move ucode defines to a separate header
      drm/radeon: properly set up the RLC on ON/LN/TN (v3)
      drm/radeon/kms: add atom helper functions for dpm (v3)
      drm/radeon/kms: add new asic struct for rv6xx (v4)
      drm/radeon/kms: add common dpm infrastructure
      drm/radeon/kms: fix up rs780/rs880 display watermark calc for dpm
      drm/radeon/kms: fix up 6xx/7xx display watermark calc for dpm
      drm/radeon/kms: fix up dce4/5 display watermark calc for dpm
      drm/radeon/kms: fix up dce6 display watermark calc for dpm
      drm/radeon/kms: add common r600 dpm functions
      drm/radeon/kms: add dpm support for rs780/rs880
      drm/radeon/kms: add dpm support for rv6xx (v3)
      drm/radeon/kms: add dpm support for rv7xx (v4)
      drm/radeon/kms: add dpm support for evergreen (v4)
      drm/radeon/kms: add dpm support for btc (v3)
      drm/radeon/kms: add dpm support for sumo asics (v2)
      drm/radeon/kms: add dpm support for trinity asics
      drm/radeon/dpm: let atom control display phy powergating
      drm/radeon: add dpm UVD handling for r7xx asics
      drm/radeon: add dpm UVD handling for evergreen/btc asics
      drm/radeon: add dpm UVD handling for sumo asics
      drm/radeon: add dpm UVD handling for TN asics (v2)
      drm/radeon/kms: enable UVD as needed (v9)
      drm/radeon/dpm: add helpers for extended power tables (v2)
      drm/radeon/dpm: track whether we are on AC or battery
      drm/radeon/dpm: fixup dynamic state adjust for sumo
      drm/radeon/dpm: fixup dynamic state adjust for TN
      drm/radeon/dpm: fixup dynamic state adjust for btc (v2)
      drm/radeon/kms: add dpm support for cayman (v5)
      drm/radeon/dpm/rs780: restructure code
      drm/radeon/dpm/rv6xx: restructure code
      drm/radeon/dpm/rv7xx: restructure code
      drm/radeon/dpm/evergreen: restructure code
      drm/radeon/dpm/btc: restructure code
      drm/radeon/dpm/cayman: restructure code
      drm/radeon/dpm/sumo: restructure code
      drm/radeon/dpm/tn: restructure code
      drm/radeon/dpm: add new pre/post_set_power_state callbacks
      drm/radeon/dpm: add pre/post_set_power_state callbacks (6xx-eg)
      drm/radeon/dpm: add pre/post_set_power_state callback (sumo)
      drm/radeon/dpm: add pre/post_set_power_state callback (TN)
      drm/radeon/dpm: add pre/post_set_power_state callback (BTC)
      drm/radeon/dpm: add pre/post_set_power_state callback (cayman)
      drm/radeon/dpm: remove broken dyn state remnants
      drm/radeon: add missing UVD clock set in cayman dpm code
      drm/radeon/dpm: remove local sumo_get_xclk()
      drm/radeon: implement apci perf request
      drm/radeon/atom: add helper to calcuate mpll params
      drm/radeon: update radeon_atom_is_voltage_gpio() for SI
      drm/radeon: update radeon_atom_get_voltage_table() for SI
      drm/radeon: implement pcie gen2/3 support for SI
      drm/radeon: add accessors of pif_phy indirect register space
      drm/radeon: add support for ASPM on evergreen asics
      drm/radeon: add support for ASPM on SI asics (v2)
      drm/radeon: enable additional power gating features on trinity
      drm/radeon: update rlc programming sequence on SI
      drm/radeon: add atom get leakage vddc function
      drm/radeon: add indirect accessors for UVD CTX registers
      drm/radeon: initialize save/restore buffer for pg on verde
      drm/radeon: add clearstate init for verde power gating
      drm/radeon: implement clock and power gating for SI
      drm/radeon/dpm: add an enum for pcie gen selection
      drm/radeon/dpm: pull in phase shedding limits from atom
      drm/radeon/dpm: endian fixes for extended power tables
      drm/radeon/dpm: pull in ppm info from atom
      drm/radeon/dpm: save some display parameters for DPM
      drm/radeon: minor sid.h cleanup
      drm: add some additional fixed point helpers (v3)
      drm/radeon/dpm/cayman: use new fixed point functions (v2)
      drm/radeon: fix some memory leaks in extended table parsing
      drm/radeon/dpm: validate voltages against dispclk requirements
      drm/radeon: update radeon_atombios_get_default_voltages for mvdd
      drm/radeon/dpm: add pcie gen helper function
      drm/radeon: fix typo in atom voltage table handling (6xx-ni)
      drm/radeon: fix typo in atom voltage table handling (si+)
      drm/radeon/atom: fix voltage table parsing
      drm/radeon/dpm/ni: properly catch errors in dpm setup
      drm/radeon/dpm/btc: properly catch errors in dpm setup
      drm/radeon/dpm/evergreen: properly catch errors in dpm setup
      drm/radeon/dpm/sumo: properly catch errors in dpm setup
      drm/radeon/dpm/trinity: properly catch errors in dpm setup
      drm/radeon/dpm/r7xx: properly catch errors in dpm setup
      drm/radeon/dpm/r6xx: properly catch errors in dpm setup
      drm/radeon/dpm/rs780: properly catch errors in dpm setup
      drm/radeon: add SI to r600_is_internal_thermal_sensor()
      drm/radeon: switch SI to use radeon_ucode.h
      drm/radeon/kms: add dpm support for SI (v7)
      drm/radeon/dpm: add dpm_enable failure output (7xx-ni)
      drm/radeon/dpm: add dpm_enable failure output (si)
      drm/radeon/dpm: add dpm_set_power_state failure output (7xx-ni)
      add dpm_set_power_state failure output (7xx-ni)
      drm/radeon/dpm: add dpm_set_power_state failure output (si)
      drm/radeon/dpm: fix typo in setting uvd clock
      drm/radeon/si: fix typo in function name
      drm/radeon: fix typo in cik_select_se_sh()
      drm/radeon: fix typo in ni_print_power_state
      drm/radeon/dpm: add support for setting UVD clock on rs780
      drm/radeon/dpm: add support for setting UVD clock on rv6xx
      drm/radeon/dpm: fix UVD clock setting on cayman
      drm/radeon/dpm: fix UVD clock setting on SI
      drm/radeon: fix endian issues in atombios dpm code
      drm/radeon/NI: fix TDP adjustment in set_power_state
      drm/radeon/SI: fix TDP adjustment in set_power_state
      drm/radeon: remove sumo dpm/uvd bringup leftovers
      drm/radeon/atom: fix endian bug in radeon_atom_init_mc_reg_table()
      drm/radeon: fix typo in radeon_atom_init_mc_reg_table()
      drm/radeon/dpm: re-enable state transitions for BTC
      drm/radeon/dpm: re-enable state transitions for Cayman
      drm/radeon/dpm: add infrastructure to support debugfs info
      drm/radeon/dpm: add debugfs support for rv6xx
      drm/radeon/dpm: add debugfs support for 7xx/evergreen/btc
      drm/radeon/dpm: add debugfs support for ON/LN
      drm/radeon/dpm: add debugfs support for TN
      drm/radeon/dpm: add debugfs support for cayman
      drm/radeon/dpm: add debugfs support for SI
      drm/radeon/dpm: clarify debugfs warning
      drm/radeon: fix endian bug in radeon_atom_get_mclk_range_table()
      drm/radeon/aruba: disable additional rlc features
      drm/radeon/sumo: disable PG when changing UVD clocks
      drm/radeon/tn: disable PG when changing UVD clocks
      drm/radeon/sumo: implement support for disable_gfx_power_gating_in_uvd flag
      drm/radeon: set default clocks for SI when DPM is disabled
      drm/radeon: add support for 3d perf states on older asics
      drm/radeon: fix surface setup on r1xx
      drm/radeon/dpm: add infrastructure to force performance levels
      drm/radeon/dpm: implement force performance levels for 7xx/eg/btc
      drm/radeon/dpm: implement force performance level for cayman
      drm/radeon/dpm: implement force performance level for SI
      drm/radeon/dpm: implement force performance level for ON/LN
      drm/radeon/dpm: implement force performance level for TN
      drm/radeon/dpm: fix display_gap programming on rv7xx
      drm/radeon: remove stray line in old pm code
      drm/radeon/dpm: add helper to calculate vblank time
      drm/radeon/dpm: add checks against vblank time
      drm/radeon/dpm: implement vblank_too_short callback for 7xx
      drm/radeon/dpm: implement vblank_too_short callback for evergreen
      drm/radeon/dpm: implement vblank_too_short callback for btc
      drm/radeon/dpm: implement vblank_too_short callback for cayman
      drm/radeon/dpm: implement vblank_too_short callback for si

Andy Lutomirski (9):
      Add arch_phys_wc_{add, del} to manipulate WC MTRRs if needed
      drm (ast, cirrus, mgag200, nouveau, savage, vmwgfx): Remove drm_mtrr_{add, del}
      drm: Update drm_addmap and drm_mmap to use PAT WC instead of MTRRs
      drm, agpgart: Use pgprot_writecombine for AGP maps and make the MTRR optional
      i915: Use arch_phys_wc_{add,del}
      radeon: Switch to arch_phys_wc_add and add a missing ..._del
      uvesafb: Clean up MTRR code
      drm: Remove mtrr_add and mtrr_del fallback hack for non-MTRR systems
      drm: Don't leak phys_wc "handles" to userspace

Arto Merilainen (5):
      gpu: host1x: Check reloc table before usage
      gpu: host1x: Copy gathers before verification
      gpu: host1x: Fix memory access in syncpt request
      gpu: host1x: Fix client_managed type
      gpu: host1x: Rework CPU syncpoint increment

Ben Skeggs (56):
      drm/nouveau: pull in latest ucode builds from external tree
      drm/nve0/ce: create engine object for ce2
      drm/nve0/fifo: copy engine context stored in ramfc, not externally
      drm/nve0/ce: link ce2 to its engine, rather than from graphics
      drm/nve0/ce: stub interrupt handler
      drm/nouveau: pass generic subdev to calculation routines
      drm/nouveau/devinit: move simple pll setting routines to devinit
      drm/nouveau/clk: change init ordering, no longer needed by devinit
      drm/nouveau/fb: initialise vram controller as pfb sub-object
      drm/nva3/clk: minor improvements to fractional N calculation
      drm/nve0/fifo: create our playlists up-front, at startup
      drm/nve0/gr: s/tp/tpc/
      drm/nve0/gr: attempt to resume after sm traps
      drm/nvc0/gr: port mp trap handling from calim's kepler code
      drm/nv50/vm: handle bar tlb flushes internally
      drm/nv50/vm: remove explicit vm knowledge from engines
      drm/nv50-/vm: take mutex rather than irqsave spinlock
      drm/nvc0/vm: handle bar tlb flushes internally
      drm/nouveau/vm: take subdev mutex, not the mm, protects against race with vm/nvc0
      drm/nouveau/core: remove nouveau_mm.mutex, no more users
      drm/nouveau/vm: make each vma take a reference on its parent vm
      drm/nouveau: delay busy bo vma removal until fence signals
      drm/nve6/gr: update initial register/context values
      drm/nve7/gr: update initial register/context values
      drm/nvf0/gr: initial register/context setup
      drm/nvc0-/gr: bump maximum gpc/tpc limits
      drm/nve4/gr: update initial register/context values
      drm/nvd9/gr: update initial register/context values
      drm/nvc0/gr: update initial register/context values
      drm/nvc3/gr: update initial register/context values
      drm/nvc1/gr: update initial register/context values
      drm/nvc4/gr: update initial register/context values
      drm/nvc8/gr: update initial register/context values
      drm/nvc0/gr: cleanup register lists, and add nvce/nvcf to switches
      drm/nouveau/kms: don't fail if there's no dcb table entries
      drm/nouveau/core: move falcon class to engine/
      drm/gr/nvc0-: merge nvc0/nve0 ucode, and use cpp instead of m4
      drm/nvc0-/gr: make register lists from initvals functions
      drm/nvc0-/gr: pull out a group of separately context-switched gpc regs
      drm/nve0-/gr: some new gpc registers can have multiple copies
      drm/nvc0-/gr: tpc regs a subset of gpc, add separate list for gpc/unk regs
      drm/nvc0-/gr: generate cs register lists from grctx data
      drm/nvf0/fifo: enable support
      drm/nvf0/ce: enable support
      drm/nvf0/gr: magic sequence that makes PGRAPH come out of hiding
      drm/nvf0/gr: enable support, if external cs ucode is available
      drm/nvc0/devinit: minor typo
      drm/nvf0/gr: fix ddx shaders locking up on me
      drm/nvc0-/gr: extend one of the magic calculations for >4 GPCs
      drm/nvf0/gr: build cs ucode for GK110
      drm/nvc0-/gr: remove hardcoding of UNK count/mask in GPCCS ucode
      drm/nvf0-/gr: ctxsw scratch reg count got bumped to 16
      drm/nvd7/devinit: use fermi class, not tesla
      drm/nvc0-/gr: factor out yet more unknown magic into versioned functions
      drm/nvc0-/gr: remove some more of the hardcoded register writes
      drm/nouveau: fix minor thinko causing bo moves to not be async on kepler

Ben Widawsky (30):
      drm/i915: Assert mutex_is_locked on context lookup
      drm/i915: BUG_ON bad PPGTT offset
      drm/i915: Extract PDE writes
      drm/i915: Fix error state memory leaks
      drm/i915: pre-fixes for checkpatch
      drm/i915: use mappable size for fb kickout
      drm/i915: use drm_mm_takedown
      drm/i915: context debug messages
      drm/i915: Call context fini at cleanup
      drm/i915: Comments for semaphore clarification
      drm/i915: Semaphore MBOX update generalization
      drm/i915: Introduce VECS: the 4th ring
      drm/i915: Add VECS semaphore bits
      drm/i915: Rename ring flush functions
      drm/i915: Vebox ringbuffer init
      drm/i915: Create a more generic pm handler for hsw+
      drm/i915: Create an ivybridge_irq_preinstall
      drm/i915: Add PM regs to pre/post install
      drm/i915: make PM interrupt writes non-destructive
      drm/i915: Convert irq_refounct to struct
      drm/i915: consolidate interrupt naming scheme
      drm/i915: vebox interrupt get/put
      drm/i915: Enable vebox interrupts
      drm/i915: Demote unknown param to DRM_DEBUG
      drm/i915: Make stolen use pin pages
      drm/i915: Unpin stolen pages
      drm/i915: unpin pages at unbind
      drm/i915: Rename the gtt_list to global_list
      drm/i915: Remove extra "ring" from error message
      drm/i915: Fix context sizes on HSW

Benjamin Gaignard (1):
      drm: drm_stub: Fixing return value if driver master_set call failed

Benoit Parrot (1):
      gpu:drm:tilcdc: get preferred_bpp value from DT

Chris Wilson (17):
      drm/i915: Only print the info message about incresing stolen size for FBC once
      drm/i915: put context upon switching
      drm/i915: Be more informative when reporting "too large for aperture" error
      drm/i915: Workaround incoherence with fence updates on Valleyview
      drm/i915: Avoid promoting a simulated hang to 'wedged'
      drm/i915: Track clients and print their object usage in debugfs
      drm/i915: Track when we dirty the scanout with render commands
      drm/i915: Remove dead code from SDVO initialisation
      drm/i915: Initialize ring->hangcheck upon ring init
      drm/i915: Only slightly increment hangcheck score if we succesfully kick a ring
      drm/i915: Don't count semaphore waits towards a stuck ring
      drm/i915: Eliminate the addr/seqno from the hangcheck warning
      drm/i915: WARN if the fence pin_count is invalid
      drm/i915: Detect invalid scanout pitches
      drm/i915: Only clear write-domains after a successful wait-seqno
      drm/i915: Refactor the wait_rendering completion into a common routine
      drm/i915: Break up the large vsnprintf() in print_error_buffers()

Christian König (1):
      drm/radeon: add UVD support for CIK (v3)

Christopher Harvey (2):
      drm/mgag200: Hardware cursor support
      drm/mgag200: Don't do full cleanup if mgag200_device_init fails

Damien Lespiau (16):
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
      drm/i915: Use FBINFO_STATE defines instead of 0 and 1
      drm/i915: Fix old reference to i830_sdvo_get_capabilities()
      drm/i915: Initialize active_outputs to never read unitialized values
      drm/i915: Introduce an HAS_IPS() macro

Dan Carpenter (1):
      drm/i915: remove a superflous semi-colon

Daniel Vetter (126):
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
      drm/i915: fixup i915_pipe_enabled check in i915_irq.c
      drm/i915: hw state readout&check support for cpu_transcoder
      drm/i915: add basic pipe config dump support
      drm/i915: drop a few really redundant WARNs in hsw mode_set
      drm/i915: fix pch_nop support
      drm/i915: fix up the edp power well check
      drm/i915: optimize vblank waits in set_base_atomic
      drm/i915: refactor sink bpp clamping
      drm/i915: fix EDID/sink-based bpp clamping
      drm/i915: split out intel_pnv_find_best_PLL
      drm/i915: move find_pll callback to dev_priv->display
      drm/i915: fold in IS_PNV checks from the split up find_dpll functions
      drm/i915: clear up the fdi dotclock semantics for M/N computation
      drm/i915: refactor cpu eDP PLL handling a bit
      drm/i915: store adjusted dotclock in adjusted_mode->clock
      drm/i915: Drop some no longer required mode/adjusted_mode parameters
      drm/i915: check for strange pfit pipe assignemnt on ivb/hsw
      drm/i915: consolidate and tighten encoder cloning checks
      drm/i915: set default value for config->pixel_multiplier
      drm/i915: hw state readout support for pixel_multiplier
      drm/i915: pipe config quirk infrastructure plus sdvo mode.flags fix
      drm/i915: enable 30bpp for DP outputs
      drm/i915: fix up pch pll handling in ->mode_set
      drm/i915: conditionally disable pch resources in ilk_crtc_disable
      drm/i915: lock down pch pll accouting some more
      drm/i915: s/pch_pll/shared_dpll/
      drm/i915: switch crtc->shared_dpll from a pointer to an enum
      drm/i915: move shared_dpll into the pipe config
      drm/i915: refactor PCH_DPLL_SEL #defines
      drm/i915: hw state readout for shared pch plls
      drm/i915: consolidate ->num_shared_dplls assignement
      drm/i915: metadata for shared dplls
      drm/i915: scrap register address storage
      drm/i915: enable/disable hooks for shared dplls
      drm/i915: drop crtc checking from assert_shared_dpll
      drm/i915: disable sdvo pixel multiplier cross-check for HAS_PCH_SPLIT
      drm/i915: pnv dpll doesn't use m1!
      drm/i915: display pll hw state readout and checking
      drm/i915: extract readout_hw_state from setup_hw_state
      drm/i915: split up intel_modeset_check_state
      drm/i915: WARN on lack of shared dpll
      drm/i915: hw state readout and cross-checking for shared dplls
      drm/i915: fix up pch pll enabling for pixel multipliers
      drm/i915: set up PIPECONF explicitly on ilk-ivb
      drm/i915: set up PIPECONF explicitly for i9xx/vlv platforms
      drm/i915: explicitly set up PIPECONF (and gamma table) on haswell
      drm/i915: stop killing pfit on i9xx
      drm/i915: simplify the reduced clock handling for pch plls
      drm/i915: Kill useless "Enable panel fitter" comments
      drm/crtc-helpers: Enforce sane set_config api
      drm/crtc-helper: no need to check for fb->depth/bpp
      drm/crtc-helper: explicit DPMS on after modeset
      drm: check that ->set_config properly updates the fb
      drm: fix fb leak in setcrtc
      drm: kms_helper: don't lose hotplug event
      drm/i915: tune down DIDL warning about too many outputs
      drm/i915: Fix up sdvo hpd pins for i965g/gm
      drm/i915: don't scream into dmesg when a modeset fails
      drm/i915: fix locking around ironlake_enable|disable_display_irq
      drm/i915: close tiny race in the ilk pcu even interrupt setup
      drm/i915: s/hotplug_irq_storm_detect/intel_hpd_irq_handler/
      drm/i915: fold the hpd_irq_setup call into intel_hpd_irq_handler
      drm/i915: fold the queue_work into intel_hpd_irq_handler
      drm/i915: fold the no-irq check into intel_hpd_irq_handler
      drm/i915: fix hpd interrupt register locking
      drm/i915: Don't try to tear down the stolen drm_mm if it's not there
      drm/prime: fix up handle_to_fd ioctl return value
      drm/mm: fix debug table BUG
      drm/mm: WARN for unclean mm takedown
      drm/mm: kill color_search_free/get_block

Darren Etheridge (6):
      drm/tilcdc: support pixel widths greater than 1024
      drm/tilcdc: adding some more devicetree config
      drm/tilcdc: fixing off by one errors found on analyzer
      drm/tilcdc: adding more guards to prevent selection of invalid modes
      drm/tilcdc: whitespace fixes and tidyup
      drm/tilcdc fixing i2c/slave initialization race

Dave Airlie (33):
      Merge tag 'drm-intel-next-2013-05-20-merged' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm/next' of git://linuxtv.org/pinchartl/fbdev into drm-next
      Merge tag 'drm-intel-next-2013-06-01' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      vgacon: fix missing include.
      Merge branch 'drm/shmob' of git://linuxtv.org/pinchartl/fbdev into drm-next
      Merge tag 'v3.10-rc7' into drm-next
      Merge branch 'core/mutexes' of git://git.kernel.org/.../tip/tip into drm-next
      drm: add hotspot support for cursors.
      drm/qxl: add support for cursor hotspot.
      Merge branch 'drm/for-next' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge tag 'drm-intel-next-2013-06-18' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-next-3.11' of git://people.freedesktop.org/~agd5f/linux into drm-next
      drm/omap: drop the !FB_OMAP2 dep
      Revert "drm: kms_helper: don't lose hotplug event"
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-next-3.11' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-next-3.11' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge tag 'drm-intel-fixes-2013-07-03' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      drm/qxl: make dynamic resizing work properly.
      drm/qxl: add support for > 1 output
      drm/qxl: set time on drawables from userspace
      qxl: split monitors_config object creation out.
      qxl: prepare memslot code for suspend/resume
      qxl: add ring prep code for s/r
      qxl: add fb and ttm entry points for use by suspend/resume.
      qxl: add suspend/resume/hibernate support.
      qxl: use drm helper hotplug support
      Merge branch 'qxl-next' of git://people.freedesktop.org/~airlied/linux into drm-next
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-next-3.11' of git://people.freedesktop.org/~agd5f/linux into drm-next

David Herrmann (1):
      drm: make drm_mm_init() return void

Egbert Eich (3):
      drm/i915: Add bit field to record which pins have received HPD events (v3)
      drm/i915: Only reprobe display on encoder which has received an HPD event (v2)
      drm/edid: Don't print messages regarding stereo or csync by default

Emil Goode (1):
      drm/tegra: Include header drm/drm.h

Emil Velikov (1):
      drm/nv50-/disp: Use output specific mask in interrupt

Ilia Mirkin (5):
      drm/nouveau/vdec: fork vp3 implementations from vp2
      drm/nouveau/core: xtensa engine base class implementation
      drm/nouveau/vp/nv84: initial vp2 engine implementation
      drm/nouveau/bsp/nv84: initial vp2 engine implementation
      drm/nva3/disp: Fix HDMI audio regression

Imre Deak (13):
      drm/i915: HSW: allow PCH clock gating for suspend
      drm/i915: use enc_to_intel_dp() instead of opencoding the same
      drm/i915: hsw: replace !is_pch_edp() with port==PORT_A
      drm/i915: ilk-ivb: replace !is_pch_edp() with port==PORT_A
      drm/i915: stop using is_pch_edp() in intel_dp_init_connector()
      drm/i915: stop using is_pch_edp() in is_cpu_edp()
      drm/i915: remove is_pch_edp() helpers and state variable
      drm/i915: print DP init debug messages from a single place
      drm/i915: release scratch page at module unload
      drm/i915: stop using is_cpu_edp() in intel_disable/post_disable_dp
      drm/i915: merge VLV eDP and DP AUX clock divider calculation
      drm/i915: replace is_cpu_edp() with a check for port A
      drm/i915: remove unused is_cpu_edp()

Inki Dae (3):
      drm/exynos: fix WINDOWS_NR checking to vidi driver
      drm/exynos: do not use mode_set_base function directly
      drm/exynos: make sure to handle an error case to vm_mmap call

Jan-Simon Möller (1):
      drm/i915: Fix declaration of intel_gmbus_{is_forced_bit/is_port_falid}

Jani Nikula (20):
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
      drm/i915: group sideband register accessors to a new file
      drm/i915: refactor VLV IOSF sideband accessors to use one helper
      drm/i915: drop redundant warnings on not holding dpio_lock
      drm/i915: rename VLV IOSF sideband functions logically
      drm/i915: change VLV IOSF sideband accessors to not return error code
      drm/i915: document why dvo/sdvo/crt need a special dpms function
      drm/i915: distinguish between error messages in DIDL initialization
      drm/i915: fix build warning on format specifier mismatch

Jesse Barnes (22):
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
      drm/i915: add encoder get_config function v5

Joonyoung Shim (5):
      drm/prime: support to cache mapping
      drm/prime: fix sgt NULL checking
      drm: add mmap function to prime helpers
      drm/cma: add low-level hook functions to use prime helpers
      drm/cma: remove GEM CMA specific dma_buf functionality

Julia Lemire (1):
      drm/mgag200: Added resolution and bandwidth limits for various G200e products.

Kenneth Graunke (3):
      drm/i915: Add PTE encoding function to the gtt/ppgtt vtables.
      drm/i915: Fix page table entries for Bay Trail.
      drm/i915: Split out Haswell code from gen6_pte_encode.

Konrad Rzeszutek Wilk (1):
      drm/i915: make compact dma scatter lists creation work with SWIOTLB backend.

Krzysztof Kozlowski (2):
      drm/exynos: fix checks for valid mixer window
      drm/exynos: fix tests for valid FIMD window number

Laurent Pinchart (17):
      drm/gem: Split drm_gem_mmap() into object search and object mapping
      drm/omap: Use drm_gem_mmap_obj() to implement dma-buf mmap
      drm: GEM CMA: Split object creation into object alloc and DMA memory alloc
      drm: GEM CMA: Split object mapping into GEM mapping and CMA mapping
      drm: GEM CMA: Add DRM PRIME support
      drm/shmobile: Drop usage of removed drm_plane enabled field
      drm/shmobile: Minor typo fix in debug message
      drm/shmobile: Use devm_* managed functions
      drm/shmobile: Add DRM PRIME support
      drm/shmobile: Enable compilation on all ARM platforms
      drm/tegra: Remove DRIVER_BUS_PLATFORM from driver_features
      drm: Renesas R-Car Display Unit DRM driver
      drm: Improve manual IRQ installation documentation
      drm/doc: Remove outdated note about i915 driver not behaving properly
      drm/doc: Document the KMS property API
      drm/rcar-du: Don't ignore rcar_du_crtc_create() return value
      drm/rcar-du: Fix buffer pitch alignment

Maarten Lankhorst (29):
      drm: add unpin function to prime helpers
      drm: move pinning/unpinning to buffer attach
      drm/radeon: implement unpin function, v2
      drm/nouveau: implement prime helper unpin function
      drm/nouveau: unpin notify object in chan_fini
      drm/nouveau: fixup fbcon failure paths
      drm/nouveau: complain loudly if buffer is pinned during destruction
      drm/nouveau: always select ACPI_VIDEO if ACPI is enabled.
      drm/cirrus: do not attempt to acquire a reservation while in an interrupt handler
      drm/mgag200: do not attempt to acquire a reservation while in an interrupt handler
      drm/ast: do not attempt to acquire a reservation while in an interrupt handler
      reservation: cross-device reservation support, v4
      drm/ttm: make ttm reservation calls behave like reservation calls
      drm/nouveau: make flipping lockdep safe
      drm/ttm: convert to the reservation api
      drm/ast: inline reservations
      drm/cirrus: inline reservations
      drm/mgag200: inline reservations
      drm/radeon: inline reservations
      drm/ttm: inline ttm_bo_reserve and related calls
      drm/ttm: get rid of ttm_bo_is_reserved usage
      drm/radeon: get rid of ttm_bo_is_reserved usage
      drm/vmwgfx: get rid of ttm_bo_is_reserved usage
      drm/ttm: get rid of ttm_bo_is_reserved
      drm/nouveau/vm: perform a bar flush when flushing vm
      drm/nouveau: remove limit on gart
      drm/nvd0-/disp: handle case where display engine is missing/disabled
      drm/nvd7/gr: initial support
      drm/nvc0/gr: fix gpc firmware regression

Marcelo Tosatti (1):
      vgacon.c: add cond reschedule points in vgacon_do_font_op

Marcin Slusarz (1):
      drm/nouveau: use vmalloc for pgt allocation

Mika Kuoppala (16):
      drm/i915: reference count for i915_hw_contexts
      drm/i915: unreference default context on module unload
      drm/i915: add context into request struct
      drm/i915: avoid big kmallocs on reading error state
      drm/i915: pass seqno to i915_hangcheck_ring_idle
      drm/i915: track ring progression using seqnos
      drm/i915: introduce i915_hangcheck_ring_hung
      drm/i915: release cursor when crtc is destroyed
      drm/i915: detect hang using per ring hangcheck_score
      drm/i915: remove i915_hangcheck_hung
      drm/i915: add struct i915_ctx_hang_stats
      drm/i915: add i915_gem_context_get_hang_stats()
      drm/i915: change i915_add_request to macro
      drm/i915: add batch bo to i915_add_request()
      drm/i915: store ring hangcheck action
      drm/i915: find guilty batch buffer on ring resets

Mike Lothian (1):
      drm/radeon/dpm: fix compilation with certain versions of gcc

Pallavi G (1):
      drm/i915/dp: program VSwing and Preemphasis control settings on VLV v2

Pantelis Antoniou (1):
      drm/tilcdc: Clear bits of register we're going to set.

Paul Bolle (1):
      drm/omap: change "!CONFIG_FB_OMAP2" to "!FB_OMAP2"

Paulo Zanoni (35):
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
      drm/i915: ILK, SNB and IVB don't have linetime watermarks
      drm/i915: remove intel_update_linetime_watermarks
      drm/i915: use the mode->htotal to calculate linetime watermarks
      drm/i915: fix haswell linetime watermarks calculation
      drm/i915: make intel_ddi_get_cdclk_freq return values in KHz
      drm/i915: set the IPS linetime watermark
      drm/i915: MCH_SSKPD is a 64 bit register on Haswell
      drm/i915: set FORCE_ARB_IDLE_PLANES workaround
      drm/i915: add "enable" argument to intel_update_sprite_watermarks
      drm/i915: add haswell_update_sprite_wm
      drm/i915: properly set HSW WM_PIPE registers
      drm/i915: properly set HSW WM_LP watermarks
      drm/i915: add support for 5/6 data buffer partitioning on Haswell
      drm/i915: implement IPS feature
      drm/i915: add enable_ips module option
      drm/i915: add i915_ips_status debugfs entry
      drm/i915: add ibx_irq_preinstall
      drm/i915: update FBC maximum fb sizes
      drm/i915: don't check encoder at DP connector destroy()
      drm/i915: extract intel_edp_init_connector
      drm/i915: propagate errors from intel_dp_init_connector
      drm/i915: fix the "ghost eDP" connector unwind path
      drm/i915: fix the "ghost eDP" encoder unwind path
      drm/i915: check the return value of intel_dp_i2c_init
      drm/i915: rename intel_dp_destroy to intel_dp_connector_destroy

Rahul Sharma (7):
      drm/exynos: hdmi: use drm_display_mode to check the supported modes
      drm/exynos: add mout_hdmi clock in hdmi driver to change parent
      drm/exynos: use of_get_named_gpio to get hdmi hpd gpio
      drm/exynos: fix interlace resolutions for exynos5420
      drm/exynos: add new compatible strings for hdmi subsystem
      drm/exynos: add support for exynos5420 mixer
      ARM: dts: change compatible strings for EXYNOS5250 hdmi subsystem

Rodrigo Vivi (8):
      drm/i915: Organize VBT stuff inside drm_i915_private
      drm/i915: Add support for FBC on Ivybridge.
      drm/i915: IVB FBC WaFbcAsynchFlipDisableFbcQueue
      drm/i915: IVB FBC WaFbcDisableDpfcClockGating
      drm/i915: Enable FBC at Haswell.
      drm/i915: HSW FBC WaFbcAsynchFlipDisableFbcQueue
      drm/i915: HSW FBC WaFbcDisableDpfcClockGating
      drm/i915: WA: FBC Render Nuke.

Rui Guo (1):
      drm/i915: Fix PCH detect with multiple ISA bridges in VM

Sachin Kamat (3):
      drm/exynos: Remove redundant use of of_match_ptr macro
      drm/exynos: exynos_drm_ipp: Remove redundant break statement
      of/documentation: Update hpd gpio property for exynos_hdmi

Sean Paul (1):
      drm/exynos: Prepare/Unprepare HDMI subsystem clocks

Seung-Woo Kim (6):
      drm/prime: reorder drm_prime_add_buf_handle and remove prototype
      drm/exynos: remove ignoring return value warning in hdmi
      drm: add assertion for checking null edid to drm_edid_block_valid
      drm: fix error routines in drm_open_helper
      drm: fix print format of sequence in trace point
      drm/exynos: remove duplicated error routine and unnecessary assign

Shuah Khan (1):
      drm: Convert drm class driver from legacy pm ops to dev_pm_ops

Steffen Trumtrar (4):
      video: display_timing: make parameter const
      video: display_timing: add doubleclk flag
      video: of: display_timing: add doubleclk flag
      drm_modes: videomode: add doubleclk flag

Takashi Iwai (1):
      ALSA: hda - Move azx_first_init() into azx_probe_continue()

Terje Bergstrom (2):
      gpu: host1x: Check INCR opcode correctly
      gpu: host1x: Don't reset firewall between gathers

Thierry Reding (5):
      drm/tegra: Don't disable unused planes
      drm/tegra: Explicitly set irq_enabled
      drm/tegra: Honor pixel-format changes
      MAINTAINERS: Update Tegra DRM entry
      drm/tegra: Fix return value

Thomas Meyer (4):
      drm/i915: Cocci spatch "memdup.spatch"
      drm: Cocci spatch "memdup.spatch"
      drm/prime: Cocci spatch "err_cast.spatch"
      drm/cma: Cocci spatch "ptr_ret.spatch"

Tomasz Figa (4):
      drm/exynos: fimd: Hold pointer to driver data in context struct
      drm/exynos: fimd: Add support for FIMD versions without SHADOWCON register
      drm/exynos: fimd: Add support for FIMD variants with clock selection
      drm/exynos: fimd: Add support for S3C64xx SoCs

Ville Syrjälä (64):
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
      drm/i915: Fix WARN_ON() on UP machines
      drm: Fix drm_rect documentation
      drm/i915: Use container_of() in the fbdev code
      drm/i915: s/drm_i915_private_t/struct drm_i915_private/
      drm/i915: VLV doesn't have the ILK+ style LP watermark registers
      drm/i915: Fix DSPCLK_GATE_D for VLV
      Revert "drm/i915: Include display_mmio_offset in sequencer index/data registers"
      drm/i915: Always load the display palette before enabling the pipe
      drm/i915: Always enable the cursor right after the primary plane
      drm/i915: Enable the overlay right after primary and cursor planes
      drm/i915: Follow the same sequence when disabling planes
      drm/i915: Drop overlay DPMS call from valleyview_crtc_enable
      drm/i915: Disable/restore all sprite planes around modeset
      drm/i915: Improve assert_planes_disabled()
      drm/i915: Spruce up assert_sprites_disabled()
      drm/i915: Assert dpll running in intel_crtc_load_lut() on pre-PCH platforms
      drm/i915: Disable primary plane trickle feed for g4x
      drm/i915: Disable trickle feed via MI_ARB_STATE for the gen4
      drm/i915: Disable trickle feed in ironlake_init_clock_gating()
      drm/i915: Refactor ctg+ trickle feed disable
      drm/i915: Make g4x_fixup_plane() operational again
      drm: Print pretty names for pixel formats
      drm/i915: Print pretty names for pixel formats
      drm: Constify the pretty-print functions
      drm: Preserve the list head in drm_mode_copy
      drm: Add probed modes in probe order
      drm: Sort connector modes based on vrefresh
      drm: Improve drm_crtc documentation
      drm/vmwgfx: Don't access file_priv in cursor_set when handle==0
      drm/edid: Add both 60Hz and 59.94Hz CEA modes to connector's mode list
      drm/i915: Try harder to disable trickle feed on VLV
      drm: Add drm_plane_force_disable()
      drm/fb-helper: Disable cursors and planes when restoring fbdev mode
      drm: Add kernel-doc for plane functions
      drm/i915: Drop bogus fbdev sprite disable code
      drm: Remove some unused stuff from drm_plane
      drm/fb-helper: Don't clobber the display palette when fbdev isn't bound
      drm/fb-helper: Make load_lut and gamma_set/gamma_get hooks optional
      drm: Drop all the stub gamma_get, gamma_set, load_lut functions from drivers
      drm/i915: Remove duplicated WaForceL3Serialization:vlv
      drm/i915: Clean up VLV rps code a bit
      drm/i915: Don't wait for Punit after each freq change on VLV
      drm/i915: Make the rps new_delay comparison more readable
      drm/i915: GEN6_RP_INTERRUPT_LIMITS doesn't seem to exist on VLV
      drm/i915: Don't increase the GPU frequency from the delayed VLV rps timer
      drm/i915: Jump to at least RPe on VLV when increasing the GPU frequency
      drm/i915: Fix VLV PLL LPF coefficients for DAC
      drm/i915: s/LFP/LPF in DPIO PLL register names
      Revert "drm/i915: Don't use the HDMI port color range bit on Valleyview"
      drm/i915: Fix VLV sprite register offsets

Wang Xingchao (3):
      ALSA: hda - Fix runtime PM check
      ALSA: hda - Add power-welll support for haswell HDA
      i915/drm: Add private api for power well usage

Wei Yongjun (3):
      drm/tegra: fix missing unlock on error
      drm/tegra: fix error return code in gr2d_submit()
      drm/i915: fix error return code in init_pipe_control()

Xiang, Haihao (4):
      drm/i915: add HAS_VEBOX
      drm/i915: add VEBOX into debugfs
      drm/i915: add I915_EXEC_VEBOX to i915_gem_do_execbuffer()
      drm/i915: add I915_PARAM_HAS_VEBOX to i915_getparam

Xiong Zhang (1):
      drm/i915: correct intel_dp_get_config() function for DevCPT

Yijing Wang (1):
      char/agp: replace numeric with standard PM state macros

YoungJun Cho (14):
      drm/gem: add mutex lock when using drm_gem_mmap_obj
      drm/gem: fix not to assign error value to gem name
      drm/prime: fix to check return of dma_map_sg in prime helper
      drm/prime: replace NULL with error value in drm_prime_pages_to_sg
      drm/prime: fix to put an exported dma_buf for adding handle failure
      drm/prime: add return check for dma_buf_fd
      drm/exynos: Remove tracking log functions
      drm/exynos: Clean up logs for DRM_ERROR / DRM_DEBUG_KMS
      drm/exynos: fix not to remain exynos_gem_obj as a leak
      drm/exynos: remove dead code in vidi_power_on
      drm/exynos: initialize the buf_num in vp_video_buffer
      drm/exynos: add error check routine in exynos_drm_open
      drm/exynos: use drm_calloc_large when allocates pointer array
      drm/exynos: fix pages allocation size in lowlevel_buffer_allocate

braggle@free.fr (1):
      drm/i915: add support for dvo Chrontel 7010B

 Documentation/DocBook/device-drivers.tmpl          |    2 +
 Documentation/DocBook/drm.tmpl                     |  271 +-
 .../devicetree/bindings/drm/tilcdc/tilcdc.txt      |    8 +
 .../devicetree/bindings/video/display-timing.txt   |    1 +
 .../devicetree/bindings/video/exynos_hdmi.txt      |   13 +-
 .../devicetree/bindings/video/exynos_hdmiddc.txt   |    7 +-
 .../devicetree/bindings/video/exynos_hdmiphy.txt   |    7 +-
 .../devicetree/bindings/video/exynos_mixer.txt     |    9 +-
 Documentation/fb/uvesafb.txt                       |   16 +-
 MAINTAINERS                                        |    8 +-
 arch/arm/boot/dts/cros5250-common.dtsi             |    4 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    4 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |    4 +-
 arch/x86/include/asm/io.h                          |    7 +
 arch/x86/include/asm/mtrr.h                        |   10 +-
 arch/x86/kernel/cpu/mtrr/main.c                    |   71 +
 drivers/base/Makefile                              |    2 +-
 drivers/base/reservation.c                         |   39 +
 drivers/char/agp/ati-agp.c                         |    4 +-
 drivers/char/agp/frontend.c                        |    8 +-
 drivers/char/agp/nvidia-agp.c                      |    6 +-
 drivers/gpu/drm/Kconfig                            |    3 +
 drivers/gpu/drm/Makefile                           |    4 +-
 drivers/gpu/drm/ast/ast_drv.h                      |   20 +-
 drivers/gpu/drm/ast/ast_fb.c                       |    5 +-
 drivers/gpu/drm/ast/ast_ttm.c                      |   31 +-
 drivers/gpu/drm/cirrus/cirrus_drv.h                |   21 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c              |    5 +-
 drivers/gpu/drm/cirrus/cirrus_ttm.c                |   33 +-
 drivers/gpu/drm/drm_bufs.c                         |   26 +-
 drivers/gpu/drm/drm_crtc.c                         |  191 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |   45 +-
 drivers/gpu/drm/drm_drv.c                          |    1 +
 drivers/gpu/drm/drm_edid.c                         |  115 +-
 drivers/gpu/drm/drm_edid_load.c                    |    3 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   43 +-
 drivers/gpu/drm/drm_fops.c                         |   25 +-
 drivers/gpu/drm/drm_gem.c                          |  113 +-
 drivers/gpu/drm/drm_gem_cma_helper.c               |  205 +-
 drivers/gpu/drm/drm_ioctl.c                        |   15 +-
 drivers/gpu/drm/drm_mm.c                           |   45 +-
 drivers/gpu/drm/drm_modes.c                        |   14 +-
 drivers/gpu/drm/drm_pci.c                          |    8 +-
 drivers/gpu/drm/drm_prime.c                        |  188 +-
 drivers/gpu/drm/drm_rect.c                         |  295 +
 drivers/gpu/drm/drm_stub.c                         |   14 +-
 drivers/gpu/drm/drm_sysfs.c                        |   33 +-
 drivers/gpu/drm/drm_trace.h                        |    6 +-
 drivers/gpu/drm/drm_vm.c                           |   25 +-
 drivers/gpu/drm/exynos/exynos_ddc.c                |    2 +
 drivers/gpu/drm/exynos/exynos_drm_buf.c            |   20 +-
 drivers/gpu/drm/exynos/exynos_drm_connector.c      |   51 +-
 drivers/gpu/drm/exynos/exynos_drm_core.c           |   12 -
 drivers/gpu/drm/exynos/exynos_drm_crtc.c           |   39 +-
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c         |    6 -
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |   29 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_encoder.c        |   28 +-
 drivers/gpu/drm/exynos/exynos_drm_fb.c             |   10 -
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |    8 -
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |  129 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  146 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   18 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |   38 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |  102 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c           |   63 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h           |    6 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c            |  202 +-
 drivers/gpu/drm/exynos/exynos_drm_plane.c          |   16 -
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |   53 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   53 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  131 +-
 drivers/gpu/drm/exynos/exynos_hdmiphy.c            |    4 +
 drivers/gpu/drm/exynos/exynos_mixer.c              |  124 +-
 drivers/gpu/drm/exynos/regs-mixer.h                |    7 +
 drivers/gpu/drm/i915/Makefile                      |    1 +
 drivers/gpu/drm/i915/dvo_ch7xxx.c                  |   28 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |  473 +-
 drivers/gpu/drm/i915/i915_dma.c                    |   90 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  116 +-
 drivers/gpu/drm/i915/i915_drv.h                    |  359 +-
 drivers/gpu/drm/i915/i915_gem.c                    |  308 +-
 drivers/gpu/drm/i915/i915_gem_context.c            |  118 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   18 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  114 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c             |   31 +-
 drivers/gpu/drm/i915/i915_irq.c                    | 1034 ++-
 drivers/gpu/drm/i915/i915_reg.h                    |  708 +-
 drivers/gpu/drm/i915/i915_suspend.c                |   10 +
 drivers/gpu/drm/i915/i915_sysfs.c                  |   74 +-
 drivers/gpu/drm/i915/i915_ums.c                    |   90 +-
 drivers/gpu/drm/i915/intel_bios.c                  |  100 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   35 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |  754 +--
 drivers/gpu/drm/i915/intel_display.c               | 3162 +++++----
 drivers/gpu/drm/i915/intel_dp.c                    |  670 +-
 drivers/gpu/drm/i915/intel_drv.h                   |  186 +-
 drivers/gpu/drm/i915/intel_dvo.c                   |   31 +
 drivers/gpu/drm/i915/intel_fb.c                    |   28 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |  158 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |  297 +-
 drivers/gpu/drm/i915/intel_opregion.c              |  110 +-
 drivers/gpu/drm/i915/intel_overlay.c               |   17 +-
 drivers/gpu/drm/i915/intel_panel.c                 |  296 +-
 drivers/gpu/drm/i915/intel_pm.c                    | 1387 +++-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  236 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   31 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |  168 +-
 drivers/gpu/drm/i915/intel_sideband.c              |  177 +
 drivers/gpu/drm/i915/intel_sprite.c                |  229 +-
 drivers/gpu/drm/i915/intel_tv.c                    |   11 +-
 drivers/gpu/drm/mgag200/Makefile                   |    2 +-
 drivers/gpu/drm/mgag200/mgag200_cursor.c           |  275 +
 drivers/gpu/drm/mgag200/mgag200_drv.h              |   44 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c               |    5 +-
 drivers/gpu/drm/mgag200/mgag200_main.c             |   25 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   72 +-
 drivers/gpu/drm/mgag200/mgag200_reg.h              |    6 +-
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |   32 +-
 drivers/gpu/drm/nouveau/Kconfig                    |    7 +
 drivers/gpu/drm/nouveau/Makefile                   |   34 +-
 drivers/gpu/drm/nouveau/core/core/mm.c             |    1 -
 drivers/gpu/drm/nouveau/core/engine/bsp/nv84.c     |   27 +-
 drivers/gpu/drm/nouveau/core/engine/bsp/nv98.c     |   93 +
 drivers/gpu/drm/nouveau/core/engine/bsp/nvc0.c     |    3 +-
 drivers/gpu/drm/nouveau/core/engine/bsp/nve0.c     |    3 +-
 .../drm/nouveau/core/engine/copy/fuc/nva3.fuc.h    |    4 +-
 .../drm/nouveau/core/engine/copy/fuc/nvc0.fuc.h    |    4 +-
 drivers/gpu/drm/nouveau/core/engine/copy/nva3.c    |   21 +-
 drivers/gpu/drm/nouveau/core/engine/copy/nvc0.c    |   10 +-
 drivers/gpu/drm/nouveau/core/engine/copy/nve0.c    |   47 +
 .../drm/nouveau/core/engine/crypt/fuc/nv98.fuc.h   |    4 +-
 drivers/gpu/drm/nouveau/core/engine/crypt/nv84.c   |    8 -
 drivers/gpu/drm/nouveau/core/engine/crypt/nv98.c   |   10 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv50.c  |   36 +-
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |   36 +-
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |   23 +-
 .../gpu/drm/nouveau/core/engine/disp/hdminva3.c    |    4 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |   12 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c    |   14 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nve0.c    |    3 +
 drivers/gpu/drm/nouveau/core/engine/disp/nvf0.c    |    3 +
 .../gpu/drm/nouveau/core/{core => engine}/falcon.c |    3 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv40.c    |    2 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv84.c    |    4 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |   57 +-
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc0.c    | 4073 ++++--------
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc1.c    |  823 +++
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc3.c    |   99 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc8.c    |  370 ++
 .../gpu/drm/nouveau/core/engine/graph/ctxnvd7.c    |  290 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnvd9.c    |  515 ++
 .../gpu/drm/nouveau/core/engine/graph/ctxnve0.c    | 2793 --------
 .../gpu/drm/nouveau/core/engine/graph/ctxnve4.c    | 1018 +++
 .../gpu/drm/nouveau/core/engine/graph/ctxnvf0.c    |  328 +
 .../core/engine/graph/fuc/{nvc0.fuc => com.fuc}    |   69 +-
 .../gpu/drm/nouveau/core/engine/graph/fuc/gpc.fuc  |  404 ++
 .../drm/nouveau/core/engine/graph/fuc/gpcnvc0.fuc  |  530 +-
 .../nouveau/core/engine/graph/fuc/gpcnvc0.fuc.h    |  664 +-
 .../drm/nouveau/core/engine/graph/fuc/gpcnvd7.fuc  |   42 +
 .../nouveau/core/engine/graph/fuc/gpcnvd7.fuc.h    |  475 ++
 .../drm/nouveau/core/engine/graph/fuc/gpcnve0.fuc  |  442 +-
 .../nouveau/core/engine/graph/fuc/gpcnve0.fuc.h    |  576 +-
 .../drm/nouveau/core/engine/graph/fuc/gpcnvf0.fuc  |   42 +
 .../nouveau/core/engine/graph/fuc/gpcnvf0.fuc.h    |  475 ++
 .../gpu/drm/nouveau/core/engine/graph/fuc/hub.fuc  |  724 ++
 .../drm/nouveau/core/engine/graph/fuc/hubnvc0.fuc  |  855 +--
 .../nouveau/core/engine/graph/fuc/hubnvc0.fuc.h    | 1173 ++--
 .../drm/nouveau/core/engine/graph/fuc/hubnvd7.fuc  |   40 +
 .../nouveau/core/engine/graph/fuc/hubnvd7.fuc.h    |  921 +++
 .../drm/nouveau/core/engine/graph/fuc/hubnve0.fuc  |  779 +--
 .../nouveau/core/engine/graph/fuc/hubnve0.fuc.h    | 1124 ++--
 .../drm/nouveau/core/engine/graph/fuc/hubnvf0.fuc  |   40 +
 .../nouveau/core/engine/graph/fuc/hubnvf0.fuc.h    |  918 +++
 .../drm/nouveau/core/engine/graph/fuc/macros.fuc   |   89 +
 .../gpu/drm/nouveau/core/engine/graph/fuc/nve0.fuc |  400 --
 drivers/gpu/drm/nouveau/core/engine/graph/fuc/os.h |    7 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv50.c   |   18 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   | 1158 ++--
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |  225 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc1.c   |  144 +
 drivers/gpu/drm/nouveau/core/engine/graph/nvc3.c   |  110 +
 drivers/gpu/drm/nouveau/core/engine/graph/nvc8.c   |  141 +
 drivers/gpu/drm/nouveau/core/engine/graph/nvd7.c   |  167 +
 drivers/gpu/drm/nouveau/core/engine/graph/nvd9.c   |  165 +
 drivers/gpu/drm/nouveau/core/engine/graph/nve0.c   |  807 ---
 drivers/gpu/drm/nouveau/core/engine/graph/nve4.c   |  354 +
 drivers/gpu/drm/nouveau/core/engine/graph/nvf0.c   |  248 +
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv50.c    |    8 -
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv84.c    |    1 -
 drivers/gpu/drm/nouveau/core/engine/ppp/nvc0.c     |    3 +-
 drivers/gpu/drm/nouveau/core/engine/vp/nv84.c      |   27 +-
 drivers/gpu/drm/nouveau/core/engine/vp/nv98.c      |   93 +
 drivers/gpu/drm/nouveau/core/engine/vp/nvc0.c      |    3 +-
 drivers/gpu/drm/nouveau/core/engine/vp/nve0.c      |    3 +-
 drivers/gpu/drm/nouveau/core/engine/xtensa.c       |  170 +
 drivers/gpu/drm/nouveau/core/include/core/device.h |    5 +-
 drivers/gpu/drm/nouveau/core/include/core/mm.h     |    2 -
 drivers/gpu/drm/nouveau/core/include/engine/bsp.h  |    1 +
 drivers/gpu/drm/nouveau/core/include/engine/copy.h |    1 +
 .../nouveau/core/include/{core => engine}/falcon.h |    0
 .../gpu/drm/nouveau/core/include/engine/graph.h    |   10 +-
 drivers/gpu/drm/nouveau/core/include/engine/mpeg.h |    1 -
 drivers/gpu/drm/nouveau/core/include/engine/vp.h   |    1 +
 .../gpu/drm/nouveau/core/include/engine/xtensa.h   |   38 +
 .../gpu/drm/nouveau/core/include/subdev/clock.h    |    2 -
 .../gpu/drm/nouveau/core/include/subdev/devinit.h  |   21 +-
 drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |   95 +-
 drivers/gpu/drm/nouveau/core/include/subdev/vm.h   |    5 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c     |   13 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     |   10 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c    |    6 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |    7 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c   |  274 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nv40.c   |    1 -
 drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c   |   45 -
 drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c   |   37 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c   |   36 -
 drivers/gpu/drm/nouveau/core/subdev/clock/pll.h    |    4 +-
 .../gpu/drm/nouveau/core/subdev/clock/pllnv04.c    |   17 +-
 .../gpu/drm/nouveau/core/subdev/clock/pllnva3.c    |   18 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/base.c |   23 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c |  329 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv05.c |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv1a.c |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv20.c |    5 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv50.c |   78 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nva3.c |   87 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nvc0.c |   90 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/priv.h |   25 +
 drivers/gpu/drm/nouveau/core/subdev/fb/base.c      |  125 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv04.c      |   54 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv10.c      |   20 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv1a.c      |   32 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv20.c      |   26 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv25.c      |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv30.c      |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv35.c      |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv36.c      |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv40.c      |   25 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv41.c      |   23 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv44.c      |   22 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv46.c      |    7 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv47.c      |    7 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv49.c      |   25 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv4e.c      |   15 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c      |  199 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |  143 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |   87 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv04.c   |   95 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv10.c   |   61 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv1a.c   |   71 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv20.c   |   63 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv40.c   |   65 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv41.c   |   64 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv44.c   |   62 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv49.c   |   64 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv4e.c   |   55 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv50.c   |  232 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c   |  186 +
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv50.c |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/ltcg/nvc0.c    |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c      |    1 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c      |    1 +
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c      |   44 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/nv50.c      |   56 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/nvc0.c      |   57 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |    1 +
 drivers/gpu/drm/nouveau/nouveau_bios.c             |   10 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   12 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |    4 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |  116 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |    1 +
 drivers/gpu/drm/nouveau/nouveau_drm.h              |    1 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   27 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   73 +-
 drivers/gpu/drm/nouveau/nouveau_fence.h            |    2 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   84 +-
 drivers/gpu/drm/nouveau/nouveau_gem.h              |    1 +
 drivers/gpu/drm/nouveau/nouveau_mem.c              |   14 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c            |    9 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |   28 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |   18 +-
 drivers/gpu/drm/nouveau/nv50_pm.c                  |    4 +-
 drivers/gpu/drm/nouveau/nva3_pm.c                  |    4 +-
 drivers/gpu/drm/nouveau/nvc0_pm.c                  |    8 +-
 drivers/gpu/drm/omapdrm/Kconfig                    |    2 +-
 drivers/gpu/drm/omapdrm/omap_crtc.c                |    5 -
 drivers/gpu/drm/omapdrm/omap_fbdev.c               |   14 -
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c          |   35 +-
 drivers/gpu/drm/qxl/qxl_cmd.c                      |   17 +-
 drivers/gpu/drm/qxl/qxl_display.c                  |  252 +-
 drivers/gpu/drm/qxl/qxl_drv.c                      |  138 +-
 drivers/gpu/drm/qxl/qxl_drv.h                      |   18 +-
 drivers/gpu/drm/qxl/qxl_fb.c                       |   16 +-
 drivers/gpu/drm/qxl/qxl_ioctl.c                    |    6 +
 drivers/gpu/drm/qxl/qxl_kms.c                      |   24 +-
 drivers/gpu/drm/qxl/qxl_object.c                   |   10 +
 drivers/gpu/drm/qxl/qxl_object.h                   |    5 -
 drivers/gpu/drm/radeon/Makefile                    |    5 +-
 drivers/gpu/drm/radeon/ObjectID.h                  |   40 +
 drivers/gpu/drm/radeon/atombios.h                  |  547 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |   91 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   51 +-
 drivers/gpu/drm/radeon/btc_dpm.c                   | 2751 ++++++++
 drivers/gpu/drm/radeon/btc_dpm.h                   |   57 +
 drivers/gpu/drm/radeon/btcd.h                      |  181 +
 drivers/gpu/drm/radeon/cik.c                       | 6987 ++++++++++++++++++++
 drivers/gpu/drm/radeon/cik_blit_shaders.c          |  246 +
 drivers/gpu/drm/radeon/cik_blit_shaders.h          |   32 +
 drivers/gpu/drm/radeon/cik_reg.h                   |  147 +
 drivers/gpu/drm/radeon/cikd.h                      | 1297 ++++
 drivers/gpu/drm/radeon/clearstate_cayman.h         | 1081 +++
 drivers/gpu/drm/radeon/clearstate_defs.h           |   44 +
 drivers/gpu/drm/radeon/clearstate_evergreen.h      | 1080 +++
 drivers/gpu/drm/radeon/clearstate_si.h             |  941 +++
 drivers/gpu/drm/radeon/cypress_dpm.c               | 2189 ++++++
 drivers/gpu/drm/radeon/cypress_dpm.h               |  160 +
 drivers/gpu/drm/radeon/evergreen.c                 |  650 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |   11 +-
 drivers/gpu/drm/radeon/evergreen_reg.h             |   12 +
 drivers/gpu/drm/radeon/evergreen_smc.h             |   67 +
 drivers/gpu/drm/radeon/evergreend.h                |  389 +-
 drivers/gpu/drm/radeon/ni.c                        |  198 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    | 4370 ++++++++++++
 drivers/gpu/drm/radeon/ni_dpm.h                    |  250 +
 drivers/gpu/drm/radeon/nid.h                       |  565 ++
 drivers/gpu/drm/radeon/nislands_smc.h              |  329 +
 drivers/gpu/drm/radeon/ppsmc.h                     |  116 +
 drivers/gpu/drm/radeon/r100.c                      |   11 +-
 drivers/gpu/drm/radeon/r600.c                      |  147 +-
 drivers/gpu/drm/radeon/r600_dpm.c                  | 1048 +++
 drivers/gpu/drm/radeon/r600_dpm.h                  |  227 +
 drivers/gpu/drm/radeon/r600_hdmi.c                 |   11 +-
 drivers/gpu/drm/radeon/r600_reg.h                  |    6 +
 drivers/gpu/drm/radeon/r600d.h                     |  232 +-
 drivers/gpu/drm/radeon/radeon.h                    |  535 +-
 drivers/gpu/drm/radeon/radeon_acpi.c               |  145 +
 drivers/gpu/drm/radeon/radeon_asic.c               |  718 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |  204 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |  885 ++-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   19 +-
 drivers/gpu/drm/radeon/radeon_cursor.c             |   10 +-
 drivers/gpu/drm/radeon/radeon_device.c             |  106 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   21 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |    9 +-
 drivers/gpu/drm/radeon/radeon_family.h             |    3 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |   20 +
 drivers/gpu/drm/radeon/radeon_kms.c                |   41 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |   94 +
 drivers/gpu/drm/radeon/radeon_object.c             |   41 +-
 drivers/gpu/drm/radeon/radeon_object.h             |   30 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |  721 +-
 drivers/gpu/drm/radeon/radeon_prime.c              |   18 +-
 drivers/gpu/drm/radeon/radeon_reg.h                |    1 +
 drivers/gpu/drm/radeon/radeon_ring.c               |   51 +-
 drivers/gpu/drm/radeon/radeon_test.c               |   75 +-
 drivers/gpu/drm/radeon/radeon_ucode.h              |  129 +
 drivers/gpu/drm/radeon/radeon_uvd.c                |   59 +-
 drivers/gpu/drm/radeon/rs690.c                     |  291 +-
 drivers/gpu/drm/radeon/rs780_dpm.c                 |  963 +++
 drivers/gpu/drm/radeon/rs780_dpm.h                 |  109 +
 drivers/gpu/drm/radeon/rs780d.h                    |  168 +
 drivers/gpu/drm/radeon/rv515.c                     |  224 +-
 drivers/gpu/drm/radeon/rv6xx_dpm.c                 | 2085 ++++++
 drivers/gpu/drm/radeon/rv6xx_dpm.h                 |   95 +
 drivers/gpu/drm/radeon/rv6xxd.h                    |  246 +
 drivers/gpu/drm/radeon/rv730_dpm.c                 |  508 ++
 drivers/gpu/drm/radeon/rv730d.h                    |  165 +
 drivers/gpu/drm/radeon/rv740_dpm.c                 |  416 ++
 drivers/gpu/drm/radeon/rv740d.h                    |  117 +
 drivers/gpu/drm/radeon/rv770_dpm.c                 | 2521 +++++++
 drivers/gpu/drm/radeon/rv770_dpm.h                 |  289 +
 drivers/gpu/drm/radeon/rv770_smc.c                 |  621 ++
 drivers/gpu/drm/radeon/rv770_smc.h                 |  209 +
 drivers/gpu/drm/radeon/rv770d.h                    |  283 +-
 drivers/gpu/drm/radeon/si.c                        | 1337 +++-
 drivers/gpu/drm/radeon/si_dpm.c                    | 6432 ++++++++++++++++++
 drivers/gpu/drm/radeon/si_dpm.h                    |  227 +
 drivers/gpu/drm/radeon/si_smc.c                    |  284 +
 drivers/gpu/drm/radeon/sid.h                       |  603 +-
 drivers/gpu/drm/radeon/sislands_smc.h              |  397 ++
 drivers/gpu/drm/radeon/sumo_dpm.c                  | 1876 ++++++
 drivers/gpu/drm/radeon/sumo_dpm.h                  |  220 +
 drivers/gpu/drm/radeon/sumo_smc.c                  |  222 +
 drivers/gpu/drm/radeon/sumod.h                     |  372 ++
 drivers/gpu/drm/radeon/trinity_dpm.c               | 1949 ++++++
 drivers/gpu/drm/radeon/trinity_dpm.h               |  132 +
 drivers/gpu/drm/radeon/trinity_smc.c               |  122 +
 drivers/gpu/drm/radeon/trinityd.h                  |  228 +
 drivers/gpu/drm/rcar-du/Kconfig                    |    9 +
 drivers/gpu/drm/rcar-du/Makefile                   |    8 +
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |  595 ++
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h             |   50 +
 drivers/gpu/drm/rcar-du/rcar_du_drv.c              |  325 +
 drivers/gpu/drm/rcar-du/rcar_du_drv.h              |   66 +
 drivers/gpu/drm/rcar-du/rcar_du_kms.c              |  265 +
 drivers/gpu/drm/rcar-du/rcar_du_kms.h              |   62 +
 drivers/gpu/drm/rcar-du/rcar_du_lvds.c             |  216 +
 drivers/gpu/drm/rcar-du/rcar_du_lvds.h             |   24 +
 drivers/gpu/drm/rcar-du/rcar_du_plane.c            |  507 ++
 drivers/gpu/drm/rcar-du/rcar_du_plane.h            |   67 +
 drivers/gpu/drm/rcar-du/rcar_du_regs.h             |  445 ++
 drivers/gpu/drm/rcar-du/rcar_du_vga.c              |  149 +
 drivers/gpu/drm/rcar-du/rcar_du_vga.h              |   24 +
 drivers/gpu/drm/savage/savage_bci.c                |   43 +-
 drivers/gpu/drm/savage/savage_drv.h                |    5 +-
 drivers/gpu/drm/shmobile/Kconfig                   |    2 +-
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |   35 +-
 drivers/gpu/drm/shmobile/shmob_drm_kms.c           |    2 +-
 drivers/gpu/drm/shmobile/shmob_drm_plane.c         |    9 +-
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c               |  122 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |   37 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.h                |   25 +-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |    2 +
 drivers/gpu/drm/tilcdc/tilcdc_regs.h               |    1 +
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              |   51 +-
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c             |    2 +
 drivers/gpu/drm/ttm/ttm_bo.c                       |  239 +-
 drivers/gpu/drm/ttm/ttm_bo_manager.c               |    8 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    6 +-
 drivers/gpu/drm/ttm/ttm_execbuf_util.c             |   86 +-
 drivers/gpu/drm/udl/udl_fb.c                       |   15 -
 drivers/gpu/drm/udl/udl_modeset.c                  |    5 -
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c             |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   10 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   14 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |    3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   27 +-
 drivers/gpu/host1x/dev.h                           |    8 +-
 drivers/gpu/host1x/drm/dc.c                        |    5 +
 drivers/gpu/host1x/drm/drm.c                       |   14 +-
 drivers/gpu/host1x/drm/gr2d.c                      |   12 +-
 drivers/gpu/host1x/hw/cdma_hw.c                    |    2 +-
 drivers/gpu/host1x/hw/syncpt_hw.c                  |   12 +-
 drivers/gpu/host1x/job.c                           |  135 +-
 drivers/gpu/host1x/syncpt.c                        |   26 +-
 drivers/gpu/host1x/syncpt.h                        |   13 +-
 drivers/staging/imx-drm/ipuv3-crtc.c               |    5 -
 drivers/video/console/vgacon.c                     |   17 +-
 drivers/video/of_display_timing.c                  |    7 +-
 drivers/video/uvesafb.c                            |   70 +-
 include/drm/drmP.h                                 |   40 +-
 include/drm/drm_crtc.h                             |   37 +-
 include/drm/drm_fixed.h                            |   94 +
 include/drm/drm_gem_cma_helper.h                   |   12 +
 include/drm/drm_mm.h                               |   38 +-
 include/drm/drm_os_linux.h                         |   16 -
 include/drm/drm_pciids.h                           |   24 +
 include/drm/drm_rect.h                             |  167 +
 include/drm/i915_powerwell.h                       |   36 +
 include/drm/ttm/ttm_bo_api.h                       |   37 +-
 include/drm/ttm/ttm_bo_driver.h                    |  169 +-
 include/drm/ttm/ttm_execbuf_util.h                 |   12 +-
 include/linux/io.h                                 |   25 +
 include/linux/platform_data/rcar-du.h              |   54 +
 include/linux/reservation.h                        |   62 +
 include/uapi/drm/drm.h                             |    1 +
 include/uapi/drm/drm_mode.h                        |   13 +
 include/uapi/drm/i915_drm.h                        |    3 +-
 include/uapi/drm/tegra_drm.h                       |    2 +
 include/video/display_timing.h                     |    1 +
 include/video/uvesafb.h                            |    1 +
 sound/pci/hda/Kconfig                              |   10 +
 sound/pci/hda/Makefile                             |    2 +
 sound/pci/hda/hda_i915.c                           |   75 +
 sound/pci/hda/hda_i915.h                           |   35 +
 sound/pci/hda/hda_intel.c                          |   87 +-
 469 files changed, 83886 insertions(+), 20419 deletions(-)
 create mode 100644 drivers/base/reservation.c
 create mode 100644 drivers/gpu/drm/drm_rect.c
 create mode 100644 drivers/gpu/drm/i915/intel_sideband.c
 create mode 100644 drivers/gpu/drm/mgag200/mgag200_cursor.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/bsp/nv98.c
 rename drivers/gpu/drm/nouveau/core/{core => engine}/falcon.c (99%)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc1.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc8.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd7.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd9.c
 delete mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxnve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxnve4.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvf0.c
 rename drivers/gpu/drm/nouveau/core/engine/graph/fuc/{nvc0.fuc => com.fuc} (88%)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/gpc.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/gpcnvd7.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/gpcnvd7.fuc.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/gpcnvf0.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/gpcnvf0.fuc.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/hub.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/hubnvd7.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/hubnvd7.fuc.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/hubnvf0.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/hubnvf0.fuc.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/macros.fuc
 delete mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/nve0.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/os.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nvc1.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nvc3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nvc8.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nvd7.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nvd9.c
 delete mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nve4.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nvf0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/vp/nv98.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/xtensa.c
 rename drivers/gpu/drm/nouveau/core/include/{core => engine}/falcon.h (100%)
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/xtensa.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/nva3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/priv.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/priv.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv10.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv1a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv20.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv40.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv41.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv44.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv49.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv4e.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c
 create mode 100644 drivers/gpu/drm/radeon/btc_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/btc_dpm.h
 create mode 100644 drivers/gpu/drm/radeon/btcd.h
 create mode 100644 drivers/gpu/drm/radeon/cik.c
 create mode 100644 drivers/gpu/drm/radeon/cik_blit_shaders.c
 create mode 100644 drivers/gpu/drm/radeon/cik_blit_shaders.h
 create mode 100644 drivers/gpu/drm/radeon/cik_reg.h
 create mode 100644 drivers/gpu/drm/radeon/cikd.h
 create mode 100644 drivers/gpu/drm/radeon/clearstate_cayman.h
 create mode 100644 drivers/gpu/drm/radeon/clearstate_defs.h
 create mode 100644 drivers/gpu/drm/radeon/clearstate_evergreen.h
 create mode 100644 drivers/gpu/drm/radeon/clearstate_si.h
 create mode 100644 drivers/gpu/drm/radeon/cypress_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/cypress_dpm.h
 create mode 100644 drivers/gpu/drm/radeon/evergreen_smc.h
 create mode 100644 drivers/gpu/drm/radeon/ni_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/ni_dpm.h
 create mode 100644 drivers/gpu/drm/radeon/nislands_smc.h
 create mode 100644 drivers/gpu/drm/radeon/ppsmc.h
 create mode 100644 drivers/gpu/drm/radeon/r600_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/r600_dpm.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_ucode.h
 create mode 100644 drivers/gpu/drm/radeon/rs780_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/rs780_dpm.h
 create mode 100644 drivers/gpu/drm/radeon/rs780d.h
 create mode 100644 drivers/gpu/drm/radeon/rv6xx_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/rv6xx_dpm.h
 create mode 100644 drivers/gpu/drm/radeon/rv6xxd.h
 create mode 100644 drivers/gpu/drm/radeon/rv730_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/rv730d.h
 create mode 100644 drivers/gpu/drm/radeon/rv740_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/rv740d.h
 create mode 100644 drivers/gpu/drm/radeon/rv770_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/rv770_dpm.h
 create mode 100644 drivers/gpu/drm/radeon/rv770_smc.c
 create mode 100644 drivers/gpu/drm/radeon/rv770_smc.h
 create mode 100644 drivers/gpu/drm/radeon/si_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/si_dpm.h
 create mode 100644 drivers/gpu/drm/radeon/si_smc.c
 create mode 100644 drivers/gpu/drm/radeon/sislands_smc.h
 create mode 100644 drivers/gpu/drm/radeon/sumo_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/sumo_dpm.h
 create mode 100644 drivers/gpu/drm/radeon/sumo_smc.c
 create mode 100644 drivers/gpu/drm/radeon/sumod.h
 create mode 100644 drivers/gpu/drm/radeon/trinity_dpm.c
 create mode 100644 drivers/gpu/drm/radeon/trinity_dpm.h
 create mode 100644 drivers/gpu/drm/radeon/trinity_smc.c
 create mode 100644 drivers/gpu/drm/radeon/trinityd.h
 create mode 100644 drivers/gpu/drm/rcar-du/Kconfig
 create mode 100644 drivers/gpu/drm/rcar-du/Makefile
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_crtc.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_crtc.h
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_drv.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_drv.h
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_kms.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_kms.h
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_lvds.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_lvds.h
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_plane.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_plane.h
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_regs.h
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_vga.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_vga.h
 create mode 100644 include/drm/drm_rect.h
 create mode 100644 include/drm/i915_powerwell.h
 create mode 100644 include/linux/platform_data/rcar-du.h
 create mode 100644 include/linux/reservation.h
 create mode 100644 sound/pci/hda/hda_i915.c
 create mode 100644 sound/pci/hda/hda_i915.h
--29444707-554755630-1373334698=:10519--
