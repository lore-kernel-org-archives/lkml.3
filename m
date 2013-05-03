Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762304Ab3ECB0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 21:26:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58404 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759570Ab3ECB0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 21:26:02 -0400
Date: Fri, 3 May 2013 02:25:57 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm for 3.10-rc1
Message-ID: <alpine.DEB.2.00.1305030224580.12778@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1664111703-1367544357=:12778"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1664111703-1367544357=:12778
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

this is the main drm pull request for 3.10.

Wierd bits:
OMAP drm changes required OMAP dss changes, in drivers/video, so I took them in here.
one more fbcon fix for font handover
VT switch avoidance in pm code
scatterlist helpers for gpu drivers - have acks from akpm

Highlights:
qxl kms driver - driver for the spice qxl virtual GPU

Nouveau:
fermi/kepler VRAM compression
GK110/nvf0 modesetting support.

Tegra:
host1x core merged with 2D engine support

i915:
vt switchless resume
more valleyview support
vblank fixes
modesetting pipe config rework

radeon:
UVD engine support
SI chip tiling support
GPU registers initialisation from golden values.

exynos:
device tree changes
fimc block support

Otherwise:
bunches of fixes all over the place.

Dave.

The following changes since commit b6a9b7f6b1f21735a7456d534dc0e68e61359d2c:

  mm: prevent mmap_cache race in find_vma() (2013-04-04 11:46:28 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-next

for you to fetch changes up to 307b9c022720f9de90d58e51743e01e9a42aec59:

  qxl: update to new idr interfaces. (2013-05-03 10:37:20 +1000)

----------------------------------------------------------------
Alex Deucher (42):
      drm/radeon: don't use get_engine_clock() on APUs
      drm/radeon: use frac fb div on RS780/RS880
      drm/radeon: fix typo in rv515_mc_resume()
      drm/radeon: clean up vram/gtt location handling
      drm/radeon/dce6: add missing display reg for tiling setup
      drm/radeon: add pm callback for setting uvd clocks
      drm/radeon: add set_uvd_clocks callback for ON/LN/TN (v4)
      drm/radeon: add set_uvd_clocks callback for evergreen
      drm/radeon: remove unused blit remnants from si.c
      drm/radeon/kms: replace *REG32_PCIE_P with *REG32_PCIE_PORT
      drm/radeon: update r600 set/get pcie lane config
      drm/radeon: add pcie set/get lanes callbacks for newer asics
      drm/radeon: handle broken disabled rb mask gracefully
      drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS
      drm/radeon: cleanup properly if mmio mapping fails
      drm/radeon: re-enable PTE/PDE packet for set_page on cayman/TN
      drm/radeon: update wait_for_vblank for r1xx-r4xx
      drm/radeon: update wait_for_vblank for r5xx-r7xx
      drm/radeon: update wait_for_vblank for evergreen+
      drm/radeon: properly lock disp in mc_stop/resume for r5xx-r7xx
      drm/radeon: properly lock disp in mc_stop/resume for evergreen+
      drm/radeon: disable the crtcs in mc_stop (r5xx-r7xx) (v2)
      drm/radeon: disable the crtcs in mc_stop (evergreen+) (v2)
      drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
      drm/radeon: disable audio format interrupts on Evergreen
      drm/radeon: clean up audio supported check
      drm/radeon: clean up audio dto programming
      drm/radeon: switch audio handling to use callbacks
      drm/radeon: fix typo in si_select_se_sh()
      drm/radeon: add helper function to support golden registers
      drm/radeon/7xx: add support for golden register init
      drm/radeon/evergreen: add support for golden register init
      drm/radeon/cayman,TN: add support for golden register init (v2)
      drm/radeon/si: add support for golden register init
      drm/radeon: fix up audio dto programming for DCE2
      drm/radeon: fix endian bugs in radeon_atom_get_clock_dividers() (v3)
      drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
      drm/radeon: fix possible segfault when parsing pm tables
      drm/radeon: add some new SI PCI ids
      drm/radeon: add new richland pci ids
      drm/radeon: clarify family checks in pm table parsing
      drm/radeon: fix handling of v6 power tables

Alexandru Gheorghiu (2):
      drivers: gpu: drm: gma500: Replaced calls kzalloc & memcpy with kmemdup
      drivers: video: omap2: dss: Use PTR_RET function

Alon Levy (1):
      include/drm/drm_fb_helper.h: remove left over function declaration

Anisse Astier (1):
      drm/gma500: fix backlight hotkeys behaviour on netbooks

Archit Taneja (30):
      OMAPDSS: panels: keep platform data of all panels in a single header
      OMAPDSS: NEC-nl8048hl11: remove platform backlight support
      OMAPDSS: Generic DPI Panel: use devm_kzalloc for allocating driver data
      OMAPDSS: lb035q02: use devm_kzalloc for allocating driver data
      OMAPDSS: picodlp: use devm_kzalloc for allocating driver data
      OMAPDSS: panel acx565akm: remove omap_dss_device maximum backlight level usage
      OMAPDSS: lb035q02: handle gpios in panel driver
      OMAPDSS: lb035q02 panel: remove platform_enable/disable callbacks
      OMAPDSS: generic dpi panel: remove uses of platform_enable/disable ops
      OMAPDSS: sharp-ls panel: remove platform_enable/disable callbacks
      OMAPDSS: acx565akm panel: handle gpios in panel driver
      OMAPDSS: nec-nl8048 panel: handle gpios in panel driver
      OMAPDSS: nec-nl8048 panel: remove platform_enable/disable callbacks
      OMAPDSS: tpo-td043 panel: handle gpios in panel driver
      OMAPDSS: tpo-td043: remove platform_enable/disable callbacks
      OMAPDSS: picodlp panel: handle gpio data in panel driver
      OMAPDSS: picodlp panel: remove platform_enable/disable callbacks
      OMAPDSS: n8x0 panel: handle gpio data in panel driver
      OMAPDSS: n8x0 panel: remove use of platform_enable/disable
      OMAPDSS: VENC: remove platform_enable/disable calls
      omapdss: DISPC: add max pixel clock limits for LCD and TV managers
      omapdss: Features: Fix some parameter ranges
      OMAPDSS: DISPC: Configure doublestride for NV12 when using 2D Tiler buffers
      OMAPDSS: DISPC: Revert to older DISPC Smart Standby mechanism for OMAP5
      omapdss: use devm_clk_get()
      drm/omap: fix modeset_init if a panel doesn't satisfy omapdrm requirements
      drm/omap: Make fixed resolution panels work
      drm/omap: Take a fb reference in omap_plane_update()
      drm/omap: Fix and improve crtc and overlay manager correlation
      drm: cleanup: use drm_framebuffer_reference instead of a kref_get

Arnd Bergmann (2):
      drm/tilcdc: use only a single module device table
      drm: export drm_vm_open_locked

Arto Merilainen (2):
      gpu: host1x: drm: Rename host1x to host1x_drm
      gpu: host1x: drm: Add memory manager and fb

Ben Skeggs (31):
      drm/nouveau/disp: fix uninitialised eq_done in error path
      drm/nvc0/fb: ignore readback page alloc failure to support userspace
      drm/nve0/grctx: initial attempt at unhardcoding yet more magic
      drm/nouveau/ttm: allow tiled memtype on system memory buffer objects
      drm/nve0: magic up some support for GF117
      drm/nouveau/bios: suppress some parser errors when dry-running scripts
      drm/nouveau/bios: add missing newline on IO*_OR opcode debugging
      drm/nv04/disp: hide all the cruft away in its own little hole
      drm/nouveau/mc: handle irq-related setup ourselves
      drm/nouveau/therm: send some messages to debug level
      drm/nv50/disp: inform core when we're not creating a new context
      drm/nouveau/core: rebase object ref/use counts after ctor/init/fini events
      drm/nouveau/i2c: remove parent deref hack
      drm/nv04-nv40/instmem: remove parent deref hack
      drm/nv50-/bar: use self as parent for subobjects
      drm/nv04-nv40/vm: use self as parent for subobjects
      drm/nv04-nv40/instmem: use self as parent for subobjects
      drm/nvc0-/gr: use self as parent for subobjects
      drm/nv20-nv30/gr: use parent as self for subobjects
      drm/nv50-/fifo: use parent as self for subobjects
      drm/nv50-/disp: use self as parent for subobjects
      drm/nouveau/device: convert to engine, rather than subdev
      drm/nouveau/device: have engine object initialised before creation
      drm/nouveau/device: enable proper constructor/destructor
      drm/nouveau/device: tweak the device/subdev relationship a little
      drm/nouveau/timer: allow alarms to be cancelled
      drm/nouveau/core: allow non-maskable events
      drm/nouveau/fifo: implement channel creation event generation
      drm/nvf0/disp: expose display class 2.2
      drm/nouveau: force noaccel when no PFIFO support present
      drm/nve0: recognise nvf0 as a kepler board (GK110)

Ben Widawsky (31):
      drm/i915: Created a sized object error dump
      drm/i915: exclude CCID for platforms without it
      drm/i915: Capture current context on error
      drm/i915: Remove unused file arg from execbuf
      drm/i915: Remove unneeded dev argument
      drm/i915: Move num_pipes to intel info
      drm/i915: Introduce GEN7_FEATURES for device info
      drm/i915: Correct sandybrige overclocking
      drm/i915: Implement WaSwitchSolVfFArbitrationPriority
      drm/i915: Don't overclock on Haswell
      drm/i915: Support PCH no display
      drm/i915: PCH_NOP
      drm/i915: Don't touch South Display when PCH_NOP
      drm/i915: Don't wait for PCH on reset
      drm/i915: Set PCH_NOP
      drm/i915: Add a pipeless ivybridge configuration
      drm/i915: generalize pte vs. register BAR allocation
      drm/i915: Call out GEN6 PTE specificity
      drm/i915: Map registers before GTT init
      drm/i915: random checkpatch fixes
      drm/i915/ppgtt: Set scratch page "globally"
      drm/i915: Conditionally carve out GGTT PDE
      drm/i915: Rework PPGTT init code
      drm/i915: Abstract PPGTT enabling
      drm/i915: NULL aliasing_ppgtt on cleanup
      drm/i915: Allow PPGTT enable to fail
      drm/i915: Better overclock support
      drm/i915: Don't default to overclock max
      drm/i915: Remove stale code
      drm/i915: VLV doesn't have LLC
      Revert "drm/i915: Don't overclock on Haswell"

Carsten Emde (1):
      drm: Add 1600x1200 (UXGA) screen resolution to the built-in EDIDs

Chen Gang (1):
      drivers/gpu/drm/tilcdc: Makefile, only -Werror when no -W* in EXTRA_CFLAGS

Chris Wilson (9):
      drm/i915: Resurrect ring kicking for semaphores, selectively
      drm/i915: Always call fence-lost prior to removing the fence
      drm/i915: Introduce i915_gem_object_create_stolen_for_preallocated
      drm/i915: Apply alignment restrictions on scanout surfaces for VT-d
      drm/i915: Skip modifying PCH DREF if not changing clock sources
      drm: Perform ioctl command validation on the stored kernel values
      drm/i915: Workaround incoherence between fences and LLC across multiple CPUs
      drm/i915: Use MLC (l3$) for context objects
      drm/i915: Scale ring, rather than ia, frequency on Haswell

Christian König (19):
      drm/radeon: UVD doesn't needs VM on SI v2
      drm/radeon: rework fallback handling v2
      drm/radeon: UVD bringup v8
      drm/radeon: add radeon_atom_get_clock_dividers helper
      drm/radeon: add set_uvd_clocks callback for SI
      drm/radeon: add set_uvd_clocks callback for r7xx v3
      drm/radeon: init UVD clocks to sane defaults
      drm/radeon: add UVD tiling addr config v2
      drm/radeon: add ring working query
      drm/radeon: cleanup UVD address checks
      drm/radeon: fix alignment of UVD fence
      drm/radeon: put UVD PLLs in bypass mode
      drm/radeon: raise UVD clocks only on demand
      drm/radeon: raise UVD clocks on init v3
      drm/radeon: disable UVD advanced semaphore mode
      drm/radeon: allocate SA bo in the requested domain
      drm/radeon: fix scratch reg handling for UVD fence
      drm/radeon: fix UPLL_REF_DIV_MASK definition
      drm/radeon: consolidate UVD clock programming

Christian Lamparter (1):
      drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900

Christoph Bumiller (5):
      drm/nvc0-/ltcg: implement VRAM compression
      drm/nvc0-: support NOUVEAU_GETPARAM_GRAPH_UNITS
      drm/nvc0/gr: add software methods to control some MP regs
      drm/nouveau/drm: bump the driver version to 1.1.1 to report new features
      drm/nve0/gr: add handling for a bunch of PGRAPH traps

Christopher Harvey (5):
      drm: Misc comment cleanup
      drm/mgag200: Convert to managed device resources where possible
      drm/mgag200: Remove pointless call to drm_fb_get_bpp_depth
      drm/mgag200: Pass driver specific mga_device in driver functions
      drm/mgag200: Remove extra variable assigns

Damien Lespiau (6):
      drm/i915: Remove platforms in the preliminary_hw_support description
      drm/i915: Error out if we are trying to use VGA with SPLL already in use
      drm/i915: Cleanup if the EDP transcoder has a bobug input value
      drm/i915: Rename intel_ddi_enable_pipe_func() to transcoder_func()
      drm/i915: Use BUG() in a case of a programming error
      drm/i915: Warn if a pipe is enabled with a bogus port

Daniel Vetter (48):
      drm/i915: gen2 has no tv out support
      Merge tag 'v3.9-rc3' into drm-intel-next-queued
      style nit: Align function parameter continuation properly.
      drm/i915: fixup pd vs pt confusion in gen6 ppgtt code
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
      drm/i915: fix lost FP_CB_TUNE setting for pch plls
      drm/i915: fix FP CB tuning limits for lvds
      drm/i915: set CB tuning also for the reduce clock
      drm/i915: tune down Y tiling scanout warning
      drm/i915: update FDI mPHY setup code
      drm/i915: don't check inconsistent modeset state when force-restoring
      drm/i915: Fixup Oops in the pipe config computation
      drm/i915: Fixup pfit disabling for gen2/3
      drm/i915: move cpu_transcoder to the pipe configuration
      drm/i915: fix bpc vs. bpp confusion in intel_crtc_compute_config
      drm/i915: avoid full modeset when changing the color range properties

Dave Airlie (30):
      Merge tag 'drm-intel-next-2013-03-23' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      ttm: export functions to allow qxl do its own iomapping
      drm: add new QXL driver. (v1.4)
      Merge tag 'drm-intel-next-2013-04-06' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge tag 'omapdss-for-3.10' of git://gitorious.org/linux-omap-dss2/linux into drm-next
      drm/qxl: make lots of things static.
      drm/qxl: fix smatch warnings
      Merge branch 'drm-next-3.10' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'gma500-next' of git://github.com/patjak/drm-gma500 into drm-next
      drm/qxl: fix build with debugfs turned off.
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge tag 'drm/tegra/for-3.10' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge branch 'drm-next-3.10-2' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'gma500-fixes' of git://github.com/patjak/drm-gma500 into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      drm/prime: keep a reference from the handle to exported dma-buf (v6)
      udl: bind the framebuffer to the correct device.
      drm/i915: fix dmabuf vmap support
      drm/mgag200: deal with bo reserve fail in dirty update path
      drm/ast: deal with bo reserve fail in dirty update path
      drm/cirrus: deal with bo reserve fail in dirty update path
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      drm/nouveau: fix build with nv50->nvc0
      Merge branch 'drm-next-3.10-2' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge tag 'omapdss-for-3.10-fixes' of git://gitorious.org/linux-omap-dss2/linux into drm-next
      Merge branch 'server-fixes' into drm-next
      qxl: update to new idr interfaces.

David Müller (ELSOFT AG) (1):
      drm/i915: Fall back to bit banging mode for DVO transmitter detection

David Rientjes (1):
      drivers, drm: fix qxl build error when debugfs is disabled

Egbert Eich (11):
      DRM/i915: Remove valleyview_hpd_irq_setup.
      DRM/I915: Add enum hpd_pin to intel_encoder.
      DRM/i915: Convert HPD interrupts to make use of HPD pin assignment in encoders (v2)
      DRM/i915: Remove i965_hpd_irq_setup.
      DRM/i915: Get rid if the 'hotplug_supported_mask' in struct drm_i915_private.
      drm/i915: Fix SDVO connector and encoder get_hw_state functions
      drm/i915: Add HPD IRQ storm detection (v5)
      drm/i915: (re)init HPD interrupt storm statistics
      drm/i915: Mask out the HPD irq bits before setting them individually.
      drm/i915: Disable HPD interrupt on pin when irq storm is detected (v3)
      drm/i915: Add Reenable Timer to turn Hotplug Detection back on (v4)

Florian Scholz (1):
      drm/nouveau/drm: adding support for backlight control of GT525M (NVC0)

Imre Deak (9):
      drm: handle compact dma scatter lists in drm_clflush_sg()
      drm/i915: set dummy page for stolen objects
      drm/i915: handle walking compact dma scatter lists
      drm/i915: create compact dma scatter lists for gem objects
      drm/i915: use for_each_sg_page for setting up the gtt ptes
      lib/scatterlist: sg_page_iter: support sg lists w/o backing pages
      Revert "drm/i915: set dummy page for stolen objects"
      drm: prime: fix refcounting on the dmabuf import error path
      drm/prime: warn for non-empty handle lookup list during drm file release

Inki Dae (2):
      Revert "drm/exynos: prepare FIMD clocks"
      drm/exynos: do not use generic flags to dumb

Jani Nikula (7):
      drm/i915: add \n to the end of sysfs attributes
      drm/i915: reduce power in the ilk rc6 enable error message
      drm/i915: keep backlight_level and backlight device brightness in sync
      drm/i915: return actual brightness to .get_brightness callback
      drm/i915: group backlight related stuff into a struct
      drm/i915: use lower aux clock divider on non-ULT HSW
      drm/i915: ensure single initialization and cleanup of backlight device

Jerome Glisse (3):
      drm/radeon: add si tile mode array query v3
      drm/radeon: Always flush the VM
      radeon: add bo tracking debugfs

Jesse Barnes (32):
      PM: make VT switching to the suspend console optional v3
      fb: add support for drivers not needing VT switch at suspend/resume time
      drm/i915: don't restore LVDS enable state blindly v2
      drm/i915: remove disabled memset of framebuffer from intel_fb
      drm/i915: don't init LVDS on VLV
      drm/i915: VLV has force wake
      drm/i915/dp: don't use ILK paths on VLV
      drm/i915: use gen6 stolen check on VLV
      drm/i915/dp: add pre-PCH eDP checking to DP detect for VLV
      drm/i915: allow force wake at init time on VLV v2
      drm/i915: don't use plane pipe select on VLV
      drm/i915: add media well to VLV force wake routines v2
      drm/i915: use VLV DIP routines on VLV v2
      drm/i915: add more VLV IDs
      drm/i915: fix WaDisablePSDDualDispatchEnable on VLV v2
      drm/i915: set conservative clock gating values on VLV v2
      drm/i915: DSPFW and BLC regs are in the display offset range
      drm/i915: VLV doesn't have HDMI on port C
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

Kees Cook (2):
      drm/i915: use simple attribute in debugfs routines
      drm/i915: clarify reasoning for the access_ok call

Kero van Gelder (1):
      gma500: Make VGA and HDMI connector hotpluggable

Lars-Peter Clausen (1):
      OMAPDSS: nec-nl8048 panel: Use dev_pm_ops

Laurent Pinchart (4):
      drm: Destroy property blobs at mode config cleanup time
      drm: Don't allow page flip to change pixel format
      drm: Perform a full mode set when the pixel format changed
      drm/shmobile: Fix race condition between page flip request and handler

Libin (1):
      drm: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT

Marcin Slusarz (1):
      drm/nouveau/drm: fix crash in vram manager debug callback

Martin Peres (2):
      drm/nouveau/therm: split the nv50 and nv84 code
      drm/nv50/therm: implement temperature reading

Mihnea Dobrescu-Balaur (1):
      gpu: don't cast kzalloc() return value

Mika Kuoppala (4):
      drm/i915: remove obsolete obj assignment in page flip
      drm/i915: Return stored value from max freq sysfs entry
      drm/i915: shorten debugfs output simple attributes
      fbcon: when font is freed, clear also vc_font.data

Patrik Jakobsson (13):
      drm/gma500: Remove unused i8xx clock limits
      drm/gma500: Calculate clock in one function instead of three identical
      drm/gma500: Type clock limits directly into array and remove defines
      drm/gma500: Remove unnecessary function exposure
      drm/gma500: Clean up various defines
      drm/gma500: Change fb name so pm-utils doesn't apply quirks
      drm/gma500: Add support for rebuilding the gtt
      drm/gma500: Activate the gtt rebuild on suspend/resume
      drm/gma500: Add hooks for hibernation
      drm/gma500: Fix hibernation problems on sdvo encoders
      drm/gma500: Check connector status before restoring sdvo
      drm/gma500: Add debugging info to psb_gtt_restore()
      drm/gma500: Increase max resolution for mode setting

Paul Sokolovsky (1):
      drm.h: Fix DRM compilation with bare-metal toolchain.

Paulo Zanoni (30):
      drm/i915: use HAS_DDI on intel_hdmi.c and intel_display.c
      drm/i915: wait_event_timeout's timeout is in jiffies
      drm/i915: add aux_ch_ctl_reg to struct intel_dp
      drm/i915: rename sdvox_reg to hdmi_reg on HDMI context
      drm/i915: create functions for the "unclaimed register" checks
      drm/i915: use FPGA_DBG for the "unclaimed register" checks
      drm/i915: clear the FPGA_DBG_RM_NOCLAIM bit at driver init
      drm/i915: clarify confusion between SDVO and HDMI registers
      drm/i915: unify the definitions of the HDMI/SDVO register
      drm/i915: remove duplicated SDVO/HDMI bit definitions
      drm/i915: rename some HDMI bit definitions
      drm/i915: disable sound first on intel_disable_ddi
      drm/i915: capture the correct cursor registers on IVB
      drm/i915: there's no DSPSIZE register on gen4+
      drm/i915: there's no DSPADDR register on Haswell
      drm/i915: add HAS_POWER_WELL
      drm/i915: reorganize intel_lvds_supported
      drm/i915: don't save/restore PCH_LVDS on LPT
      drm/i915: add missing space in error message
      drm/i915: fix DSPADDR Gen check
      drm/i915: there's no DSPPOS register on gen4+
      drm/i915: there's no PIPESTAT on HAS_PCH_SPLIT platforms
      drm/i915: remove "inline" keyword from ironlake_disable_display_irq
      drm/i915: add intel_using_power_well
      drm/i915: don't touch the PF regs if the power well is down
      drm/i915: remove comment about IVB link training from intel_pm.c
      drm/i915: don't intel_crt_init on any ULT machines
      drm/i915: WARN when LPT-LP is not paired with ULT CPU
      drm/i915: set CPT FDI RX polarity bits based on VBT
      drm/i915: preserve the PBC bits of TRANS_CHICKEN2

Rafa³ Mi³ecki (6):
      drm/radeon: add helpers for masking and setting bits in regs
      drm/radeon/evergreen: setup HDMI before enabling it
      drm/radeon/evergreen: reorder HDMI setup
      drm/radeon/evergreen: write default channel numbers
      drm: add drm_edid_to_eld helper extracting SADs from EDID (v2)
      drm/radeon/evergreen: set SAD registers

Rahul Sharma (3):
      drm: modify pages_to_sg prime helper to create optimized SG table
      drm/exynos: hdmi: using drm_display_mode timings for exynos4
      drm/exynos: hdmi: move mode_fixup to drm common hdmi

Rodrigo Vivi (2):
      drm/i915: Use cpu_transcoder for HSW_TVIDEO_DIP_* instead of pipe
      drm/i915: HSW PM Frequency bits fix

Roy Spliet (1):
      drm/nvc0-/ltcg: Fix build on 32-bit platforms (v2)

Sachin Kamat (12):
      OMAPDSS: DSI: Use devm_clk_get()
      drm/exynos: hdmi: Fix incorrect usage of IS_ERR_OR_NULL
      drm/exynos: mixer: Fix incorrect usage of IS_ERR_OR_NULL
      drm/exynos: drm_rotator: Fix incorrect usage of IS_ERR_OR_NULL
      drm/exynos: drm_connector: Fix error check condition
      Revert "of/exynos_g2d: Add Bindings for exynos G2D driver"
      drm/tilcdc: Fix an incorrect condition
      drm/tilcdc: Remove unnecessary braces
      drm/tilcdc: Remove space before tab
      drm/tilcdc: Fix checkpatch error in tilcdc_panel.c
      drm/exynos: Select VIDEOMODE_HELPERS for FIMD
      drm/exynos: Remove unnecessary braces in exynos_hdmi.c

Samuel Li (1):
      drm/radeon: Use direct mapping for fast fb access on RS690

Sean Paul (1):
      drm/exynos: Don't blend mixer layer 0

Seung-Woo Kim (3):
      drm/exynos: fix wrong return check for platform_device_register_simple
      exynos/drm: hdmi: cleanup for hdmi common device registration
      drm/exynos: added ipp device registration to drm driver

Stephen Warren (1):
      drm/tegra: don't depend on OF

Syam Sidhardhan (1):
      gma500: medfield: Fix possible NULL pointer dereference

Sylwester Nawrocki (3):
      drm/exynos: remove redundant devm_kfree()
      drm/exynos: rework fimc clocks handling
      drm/exynos: add device tree support for fimc ipp driver

Terje Bergstrom (7):
      gpu: host1x: Add host1x driver
      gpu: host1x: Add syncpoint wait and interrupts
      gpu: host1x: Add channel support
      gpu: host1x: Add debug support
      drm/tegra: Move drm to live under host1x
      gpu: host1x: Remove second host1x driver
      drm/tegra: Add gr2d device

Thierry Reding (2):
      video: hdmi: Relicense under MIT
      drm/tegra: Support the XBGR8888 pixelformat

Tomi Valkeinen (55):
      OMAPDSS: add fields to panels' platform data
      OMAPDSS: DSI: remove DSI & DISPC clk divisors from dssdev
      OMAPDSS: HDMI: remove HDMI clk divisors from dssdev
      OMAPDSS: DPI: remove omap_dss_device uses
      OMAPDSS: DSI: remove omap_dss_device uses
      OMAPDSS: Taal: remove multi-panel support
      OMAPDSS: APPLY: remove dssdev from dss_mgr_wait_for_vsync
      OMAPDSS: add missing export for omap_dss_get_output()
      OMAPDSS: HDMI: init output earlier
      OMAPDSS: add output->name
      OMAPDSS: add output->dispc_channel
      OMAPDSS: DSI: delay dispc initialization
      OMAPDSS: DSI: fix DSI channel source initialization
      OMAPDSS: Taal: remove rotate & mirror support
      OMAPDSS: DPI: fix dpi_get_dsidev() for omap5
      OMAPDSS: DISPC: store core clk rate
      OMAPDSS: DSI: fix wrong unsigned long long use
      OMAPDSS: DSI: simplify dsi configuration
      OMAPDSS: DSI: get line buffer size at probe
      OMAPDSS: DSI: add enum omap_dss_dsi_trans_mode
      OMAPDSS: DSI remove unneeded clk source setup code
      OMAPDSS: DISPC: add new clock calculation code
      OMAPDSS: DSS: add new clock calculation code
      OMAPDSS: DSI: add new clock calculation code
      OMAPDSS: SDI: use new clock calculation code
      OMAPDSS: DPI: use new clock calculation code
      OMAPDSS: DSI: use new clock calculation code
      OMAPDSS: remove unused old clock calculation code
      OMAPDSS: remove dsi videomode from dssdev
      OMAPDSS: acx565akm: remove platform backlight calls
      OMAPDSS: ls037v7dw01: remove platform backlight calls
      OMAPDSS: n8x0: remove platform backlight calls
      OMAPDSS: generic dpi panel: handle gpios in panel driver
      OMAPDSS: LS037V7DW01: handle gpios in panel driver
      OMAPDSS: fix dss_fck clock rate rounding
      OMAPDSS: DPI: widen the pck search when using dss fck
      drm/omap: add statics to a few structs
      OMAPDSS: Merge omapdss topic branches
      OMAPDSS: DPI: fix compilation if DSI not compiled in
      OMAPDSS: Makefile: move omapfb after panels
      OMAPFB: use module_platform_driver()
      OMAPFB: defer probe if no displays
      OMAPDSS: DPI: use platform_driver_register()
      OMAPDSS: SDI: use platform_driver_register()
      OMAPDSS: DSI: use platform_driver_register()
      OMAPDSS: RFBI: use platform_driver_register()
      OMAPDSS: HDMI: use platform_driver_register()
      OMAPDSS: VENC: use platform_driver_register()
      OMAPDSS: DPI: Add error handling for dpi_probe_pdata
      OMAPDSS: SDI: Add error handling for sdi_probe_pdata
      OMAPDSS: DSI: Add error handling for dsi_probe_pdata
      OMAPDSS: RFBI: Add error handling for rfbi_probe_pdata
      OMAPDSS: HDMI: Add error handling for hdmi_probe_pdata
      OMAPDSS: VENC: Add error handling for venc_probe_pdata
      OMAPDSS: TFP410: return EPROBE_DEFER if the i2c adapter not found

Vikas Sajjan (5):
      drm/exynos: Add display-timing node parsing using video helper function
      drm/exynos: enable OF_VIDEOMODE and FB_MODE_HELPERS for exynos drm fimd
      drm/exynos: change the method for getting the interrupt
      drm/exynos: prepare FIMD clocks
      drm/exynos: enable FIMD clocks

Ville Syrjälä (32):
      drm/i915: Really wait for pending flips when panning
      drm/i915: Finish page flips and update primary planes after a GPU reset
      drm/i915: Eliminate race from gen2/3 page flip interrupt handling
      drm/i915: Fix races in gen4 page flip interrupt handling
      drm/i915: Refactor gen2 to gen4 vblank interrupt handling
      drm/i915: Kill pipestat[] cache
      drm/i915: Add to_user_ptr()
      drm/i915: Document the find_pll() function
      drm/i915: Remove a stale and misplaced comment
      drm/i915: Kill a few pointless comments
      drm/i915: Use FORCEWAKE_KERNEL instead of hardcoded number in MT forcewake ACK
      drm/i915: Use '1' instead of FORCEWAKE_KERNEL for ST force wake
      drm/i915: Single thread force wake isn't used on HSW anymore
      drm/i915: Kill a strange comment about DPMS functions
      drm/i915: Set the VIC in AVI infoframe for SDVO
      drm/i915: Wait for vblank between disabling a sprite and unpinning the fb
      drm/i915: Set PIPECONF color range bit on Valleyview
      drm/i915: Don't use the HDMI port color range bit on Valleyview
      drm/i915: Add ECOBITS_SNB_BIT
      drm/i915: Set GAC_ECO_BITS register on Gen7+
      drm/i915: Configure GAM_ECOCHK appropriatly for Gen7
      drm/i915: Reject fence stride=0 on gen4+
      drm/i915: Increase max fence pitch limit to 256KB on IVB+
      drm/i915: IVB/HSW have 32 fence register
      drm/i915: Make data/link N value power of two
      drm: Remove explicit vrefresh initialization from DRM_MODE()
      drm: Add drm_mode_equal_no_clocks()
      drm/edid: Populate vrefresh for CEA modes
      drm/edid: Check both 60Hz and 59.94Hz when looking for a CEA mode
      drm: Make drm_ioctls const
      drm: Silence some sparse warnings
      drm: Kill user_modes list and the associated ioctls

Wang YanQing (1):
      gma500: remove unused drm_psb_no_fb

Xiong Zhou (1):
      gma500:fix build failure for 3.9-rc5

Zhang, Xiong Y (1):
      drm/i915: correct the calculation of first_pd_entry_in_global_pt

 Documentation/EDID/1600x1200.S                     |   44 +
 Documentation/EDID/HOWTO.txt                       |   12 +-
 .../devicetree/bindings/drm/exynos/g2d.txt         |   22 -
 arch/arm/mach-omap2/board-2430sdp.c                |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c                |    2 +-
 arch/arm/mach-omap2/board-am3517evm.c              |    3 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |    3 +-
 arch/arm/mach-omap2/board-devkit8000.c             |    3 +-
 arch/arm/mach-omap2/board-h4.c                     |    2 +-
 arch/arm/mach-omap2/board-igep0020.c               |    2 +-
 arch/arm/mach-omap2/board-ldp.c                    |    2 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c               |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |    3 +-
 arch/arm/mach-omap2/board-overo.c                  |    3 +-
 arch/arm/mach-omap2/dss-common.c                   |    4 +-
 drivers/gpu/Makefile                               |    1 +
 drivers/gpu/drm/Kconfig                            |    4 +-
 drivers/gpu/drm/Makefile                           |    2 +-
 drivers/gpu/drm/ast/ast_drv.h                      |    2 +
 drivers/gpu/drm/ast/ast_fb.c                       |   43 +-
 drivers/gpu/drm/ast/ast_ttm.c                      |    2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.h                |    2 +
 drivers/gpu/drm/cirrus/cirrus_fbdev.c              |   38 +-
 drivers/gpu/drm/cirrus/cirrus_ttm.c                |    2 +-
 drivers/gpu/drm/drm_cache.c                        |    7 +-
 drivers/gpu/drm/drm_crtc.c                         |  411 ++----
 drivers/gpu/drm/drm_crtc_helper.c                  |    3 +
 drivers/gpu/drm/drm_drv.c                          |    9 +-
 drivers/gpu/drm/drm_edid.c                         |  279 +++-
 drivers/gpu/drm/drm_edid_load.c                    |   21 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   23 +-
 drivers/gpu/drm/drm_gem.c                          |    4 +-
 drivers/gpu/drm/drm_modes.c                        |   22 +-
 drivers/gpu/drm/drm_pci.c                          |   10 +-
 drivers/gpu/drm/drm_prime.c                        |   99 +-
 drivers/gpu/drm/drm_vm.c                           |    1 +
 drivers/gpu/drm/exynos/Kconfig                     |    6 +-
 drivers/gpu/drm/exynos/exynos_drm_connector.c      |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c         |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |    9 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |   12 +-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |  273 ++--
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |   39 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |    3 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c           |   54 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h           |    3 -
 drivers/gpu/drm/exynos/exynos_drm_ipp.c            |   27 +
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |    2 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  712 ++++-----
 drivers/gpu/drm/exynos/exynos_mixer.c              |   22 +-
 drivers/gpu/drm/exynos/regs-fimc.h                 |    7 +-
 drivers/gpu/drm/gma500/Kconfig                     |   13 +-
 drivers/gpu/drm/gma500/cdv_intel_crt.c             |    1 +
 drivers/gpu/drm/gma500/cdv_intel_hdmi.c            |    1 +
 drivers/gpu/drm/gma500/framebuffer.c               |    6 +-
 drivers/gpu/drm/gma500/gtt.c                       |   52 +-
 drivers/gpu/drm/gma500/gtt.h                       |    2 +-
 drivers/gpu/drm/gma500/intel_bios.c                |    3 +-
 drivers/gpu/drm/gma500/intel_bios.h                |    6 +-
 drivers/gpu/drm/gma500/mdfld_dsi_output.c          |    7 +-
 drivers/gpu/drm/gma500/power.c                     |   17 +
 drivers/gpu/drm/gma500/power.h                     |    3 +
 drivers/gpu/drm/gma500/psb_drv.c                   |    3 +
 drivers/gpu/drm/gma500/psb_drv.h                   |    1 -
 drivers/gpu/drm/gma500/psb_intel_display.c         |  154 +-
 drivers/gpu/drm/gma500/psb_intel_display.h         |    3 -
 drivers/gpu/drm/gma500/psb_intel_drv.h             |    8 -
 drivers/gpu/drm/gma500/psb_intel_reg.h             |    1 -
 drivers/gpu/drm/gma500/psb_intel_sdvo.c            |   33 +
 drivers/gpu/drm/gma500/psb_irq.c                   |    2 +-
 drivers/gpu/drm/gma500/psb_irq.h                   |    6 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |  433 ++----
 drivers/gpu/drm/i915/i915_dma.c                    |   90 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  206 ++-
 drivers/gpu/drm/i915/i915_drv.h                    |   94 +-
 drivers/gpu/drm/i915/i915_gem.c                    |  135 +-
 drivers/gpu/drm/i915/i915_gem_context.c            |    7 +
 drivers/gpu/drm/i915/i915_gem_dmabuf.c             |   18 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   36 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  262 ++--
 drivers/gpu/drm/i915/i915_gem_stolen.c             |   65 +
 drivers/gpu/drm/i915/i915_gem_tiling.c             |   33 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  659 ++++++---
 drivers/gpu/drm/i915/i915_reg.h                    |  293 +++-
 drivers/gpu/drm/i915/i915_suspend.c                |   15 +-
 drivers/gpu/drm/i915/i915_sysfs.c                  |   27 +-
 drivers/gpu/drm/i915/intel_bios.c                  |    9 +-
 drivers/gpu/drm/i915/intel_bios.h                  |    4 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   22 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |   70 +-
 drivers/gpu/drm/i915/intel_display.c               | 1543 +++++++++++---------
 drivers/gpu/drm/i915/intel_dp.c                    |  526 ++++---
 drivers/gpu/drm/i915/intel_drv.h                   |  155 +-
 drivers/gpu/drm/i915/intel_dvo.c                   |   13 +-
 drivers/gpu/drm/i915/intel_fb.c                    |    8 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |  166 ++-
 drivers/gpu/drm/i915/intel_i2c.c                   |    4 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   49 +-
 drivers/gpu/drm/i915/intel_panel.c                 |   49 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  245 +++-
 drivers/gpu/drm/i915/intel_sdvo.c                  |  133 +-
 drivers/gpu/drm/i915/intel_sprite.c                |  243 ++-
 drivers/gpu/drm/i915/intel_tv.c                    |   16 +-
 drivers/gpu/drm/mgag200/mgag200_drv.h              |    8 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c               |   55 +-
 drivers/gpu/drm/mgag200/mgag200_main.c             |   31 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |    7 +-
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |    4 +-
 drivers/gpu/drm/nouveau/Makefile                   |   26 +-
 drivers/gpu/drm/nouveau/core/core/client.c         |    7 +-
 drivers/gpu/drm/nouveau/core/core/engine.c         |    4 +-
 drivers/gpu/drm/nouveau/core/core/event.c          |   12 +-
 drivers/gpu/drm/nouveau/core/core/object.c         |   19 +-
 drivers/gpu/drm/nouveau/core/core/parent.c         |    8 +-
 .../nouveau/core/{subdev => engine}/device/base.c  |  186 +--
 .../nouveau/core/{subdev => engine}/device/nv04.c  |    2 +-
 .../nouveau/core/{subdev => engine}/device/nv10.c  |    2 +-
 .../nouveau/core/{subdev => engine}/device/nv20.c  |    2 +-
 .../nouveau/core/{subdev => engine}/device/nv30.c  |    2 +-
 .../nouveau/core/{subdev => engine}/device/nv40.c  |    2 +-
 .../nouveau/core/{subdev => engine}/device/nv50.c  |   20 +-
 .../nouveau/core/{subdev => engine}/device/nvc0.c  |   30 +-
 .../nouveau/core/{subdev => engine}/device/nve0.c  |   36 +-
 drivers/gpu/drm/nouveau/core/engine/disp/dport.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |    5 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c    |    3 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nvf0.c    |   89 ++
 drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.c  |    3 +
 drivers/gpu/drm/nouveau/core/engine/fifo/base.c    |    7 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nv50.c    |   18 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv84.c    |   22 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c    |    9 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |    7 +-
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc0.c    |   51 +-
 .../gpu/drm/nouveau/core/engine/graph/ctxnve0.c    |   13 +-
 .../drm/nouveau/core/engine/graph/fuc/gpcnvc0.fuc  |    5 +
 .../drm/nouveau/core/engine/graph/fuc/hubnvc0.fuc  |    3 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv20.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv25.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv2a.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv30.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv34.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv35.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv40.c   |   10 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv50.c   |   10 +
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |   31 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |    3 +
 drivers/gpu/drm/nouveau/core/engine/graph/nve0.c   |  230 ++-
 .../gpu/drm/nouveau/core/engine/software/nvc0.c    |   29 +
 drivers/gpu/drm/nouveau/core/include/core/class.h  |   12 +
 drivers/gpu/drm/nouveau/core/include/core/device.h |    6 +-
 drivers/gpu/drm/nouveau/core/include/core/parent.h |    4 +-
 .../core/include/{subdev => engine}/device.h       |    1 -
 drivers/gpu/drm/nouveau/core/include/engine/disp.h |    1 +
 drivers/gpu/drm/nouveau/core/include/engine/fifo.h |    3 +-
 .../gpu/drm/nouveau/core/include/engine/graph.h    |    4 +
 drivers/gpu/drm/nouveau/core/include/subdev/ltcg.h |    7 +
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h   |   30 +-
 .../gpu/drm/nouveau/core/include/subdev/therm.h    |    1 +
 drivers/gpu/drm/nouveau/core/os.h                  |    1 +
 drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c     |   22 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     |   14 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |   56 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |   72 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c     |    6 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv04.c |   20 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv04.h |    1 -
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c |   12 +-
 drivers/gpu/drm/nouveau/core/subdev/ltcg/nvc0.c    |  129 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c      |   60 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.c      |    1 -
 drivers/gpu/drm/nouveau/core/subdev/mc/nv44.c      |    1 -
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c      |    1 -
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c      |    1 -
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c      |    1 -
 drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nv50.c   |  175 +--
 drivers/gpu/drm/nouveau/core/subdev/therm/nv84.c   |  221 +++
 drivers/gpu/drm/nouveau/core/subdev/therm/nva3.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nvd0.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/priv.h   |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/temp.c   |   14 +-
 drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c   |   13 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/nv04.c      |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/nv41.c      |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/nv44.c      |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/nvc0.c      |   58 +-
 drivers/gpu/drm/nouveau/dispnv04/Makefile          |   10 +
 .../drm/nouveau/{nouveau_calc.c => dispnv04/arb.c} |    2 +-
 .../drm/nouveau/{nv04_crtc.c => dispnv04/crtc.c}   |    5 +-
 .../nouveau/{nv04_cursor.c => dispnv04/cursor.c}   |    3 +-
 .../gpu/drm/nouveau/{nv04_dac.c => dispnv04/dac.c} |    2 +-
 .../gpu/drm/nouveau/{nv04_dfp.c => dispnv04/dfp.c} |    2 +-
 .../nouveau/{nv04_display.c => dispnv04/disp.c}    |    2 +-
 .../nouveau/{nv04_display.h => dispnv04/disp.h}    |    0
 .../drm/nouveau/{nouveau_hw.c => dispnv04/hw.c}    |    2 +-
 .../drm/nouveau/{nouveau_hw.h => dispnv04/hw.h}    |    3 +-
 drivers/gpu/drm/nouveau/{ => dispnv04}/nvreg.h     |    0
 .../{nv17_tv_modes.c => dispnv04/tvmodesnv17.c}    |    4 +-
 .../drm/nouveau/{nv04_tv.c => dispnv04/tvnv04.c}   |    2 +-
 .../drm/nouveau/{nv17_tv.c => dispnv04/tvnv17.c}   |    4 +-
 .../drm/nouveau/{nv17_tv.h => dispnv04/tvnv17.h}   |    0
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |   12 +-
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |    3 +
 drivers/gpu/drm/nouveau/nouveau_bios.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.h             |    2 -
 drivers/gpu/drm/nouveau/nouveau_connector.c        |    2 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   26 +-
 drivers/gpu/drm/nouveau/nouveau_drm.h              |   13 +-
 drivers/gpu/drm/nouveau/nouveau_encoder.h          |    2 +-
 drivers/gpu/drm/nouveau/nouveau_irq.c              |   76 -
 drivers/gpu/drm/nouveau/nouveau_irq.h              |   11 -
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |   25 +-
 drivers/gpu/drm/nouveau/nv04_pm.c                  |    2 +-
 drivers/gpu/drm/nouveau/nv40_pm.c                  |    2 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |    1 +
 drivers/gpu/drm/nouveau/nv50_pm.c                  |    2 +-
 drivers/gpu/drm/omapdrm/omap_connector.c           |   27 +-
 drivers/gpu/drm/omapdrm/omap_crtc.c                |   21 +-
 drivers/gpu/drm/omapdrm/omap_drv.c                 |  165 ++-
 drivers/gpu/drm/omapdrm/omap_drv.h                 |   38 +-
 drivers/gpu/drm/omapdrm/omap_encoder.c             |   24 +-
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c          |    3 +-
 drivers/gpu/drm/omapdrm/omap_irq.c                 |   17 +-
 drivers/gpu/drm/omapdrm/omap_plane.c               |    6 +
 drivers/gpu/drm/qxl/Kconfig                        |   10 +
 drivers/gpu/drm/qxl/Makefile                       |    9 +
 drivers/gpu/drm/qxl/qxl_cmd.c                      |  685 +++++++++
 drivers/gpu/drm/qxl/qxl_debugfs.c                  |  141 ++
 drivers/gpu/drm/qxl/qxl_dev.h                      |  879 +++++++++++
 drivers/gpu/drm/qxl/qxl_display.c                  |  982 +++++++++++++
 drivers/gpu/drm/qxl/qxl_draw.c                     |  390 +++++
 drivers/gpu/drm/qxl/qxl_drv.c                      |  145 ++
 drivers/gpu/drm/qxl/qxl_drv.h                      |  566 +++++++
 drivers/gpu/drm/qxl/qxl_dumb.c                     |   93 ++
 drivers/gpu/drm/qxl/qxl_fb.c                       |  567 +++++++
 drivers/gpu/drm/qxl/qxl_fence.c                    |   97 ++
 drivers/gpu/drm/qxl/qxl_gem.c                      |  149 ++
 drivers/gpu/drm/qxl/qxl_image.c                    |  176 +++
 drivers/gpu/drm/qxl/qxl_ioctl.c                    |  411 ++++++
 drivers/gpu/drm/qxl/qxl_irq.c                      |   97 ++
 drivers/gpu/drm/qxl/qxl_kms.c                      |  302 ++++
 drivers/gpu/drm/qxl/qxl_object.c                   |  365 +++++
 drivers/gpu/drm/qxl/qxl_object.h                   |  112 ++
 drivers/gpu/drm/qxl/qxl_release.c                  |  304 ++++
 drivers/gpu/drm/qxl/qxl_ttm.c                      |  581 ++++++++
 drivers/gpu/drm/radeon/Makefile                    |    2 +-
 drivers/gpu/drm/radeon/atom.c                      |    6 +-
 drivers/gpu/drm/radeon/atombios.h                  |    2 +
 drivers/gpu/drm/radeon/atombios_crtc.c             |    3 +
 drivers/gpu/drm/radeon/atombios_encoders.c         |   17 +-
 drivers/gpu/drm/radeon/evergreen.c                 | 1187 ++++++++++++++-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |  169 ++-
 drivers/gpu/drm/radeon/evergreen_reg.h             |    2 +
 drivers/gpu/drm/radeon/evergreend.h                |   48 +
 drivers/gpu/drm/radeon/ni.c                        |  414 +++++-
 drivers/gpu/drm/radeon/nid.h                       |   21 +
 drivers/gpu/drm/radeon/r100.c                      |   77 +-
 drivers/gpu/drm/radeon/r500_reg.h                  |    2 +
 drivers/gpu/drm/radeon/r600.c                      |  404 ++++-
 drivers/gpu/drm/radeon/r600_audio.c                |   64 +-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |  150 +-
 drivers/gpu/drm/radeon/r600d.h                     |   72 +-
 drivers/gpu/drm/radeon/radeon.h                    |   94 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |  100 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   28 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |  132 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   83 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   56 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |    9 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |   20 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |   50 +
 drivers/gpu/drm/radeon/radeon_kms.c                |  187 ++-
 drivers/gpu/drm/radeon/radeon_mode.h               |   23 +
 drivers/gpu/drm/radeon/radeon_object.c             |   16 +-
 drivers/gpu/drm/radeon/radeon_object.h             |    2 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |    6 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |   27 +-
 drivers/gpu/drm/radeon/radeon_sa.c                 |    2 +-
 drivers/gpu/drm/radeon/radeon_test.c               |   72 +-
 drivers/gpu/drm/radeon/radeon_uvd.c                |  831 +++++++++++
 drivers/gpu/drm/radeon/rs600.c                     |   52 +-
 drivers/gpu/drm/radeon/rs690.c                     |   23 +
 drivers/gpu/drm/radeon/rs690d.h                    |    3 +
 drivers/gpu/drm/radeon/rv515.c                     |   56 +-
 drivers/gpu/drm/radeon/rv770.c                     |  909 +++++++++++-
 drivers/gpu/drm/radeon/rv770d.h                    |   43 +
 drivers/gpu/drm/radeon/si.c                        |  979 ++++++++++++-
 drivers/gpu/drm/radeon/sid.h                       |   40 +
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c          |    2 +-
 drivers/gpu/drm/tegra/Makefile                     |    7 -
 drivers/gpu/drm/tegra/drm.c                        |  217 ---
 drivers/gpu/drm/tegra/fb.c                         |   52 -
 drivers/gpu/drm/tegra/host1x.c                     |  327 -----
 drivers/gpu/drm/tilcdc/Makefile                    |    5 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |    9 +-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |    3 +-
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              |    1 -
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c             |    1 -
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |   13 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |    4 +-
 drivers/gpu/drm/udl/udl_fb.c                       |    2 +-
 drivers/gpu/drm/udl/udl_gem.c                      |    4 +
 drivers/gpu/host1x/Kconfig                         |   24 +
 drivers/gpu/host1x/Makefile                        |   20 +
 drivers/gpu/host1x/cdma.c                          |  491 +++++++
 drivers/gpu/host1x/cdma.h                          |  100 ++
 drivers/gpu/host1x/channel.c                       |  126 ++
 drivers/gpu/host1x/channel.h                       |   52 +
 drivers/gpu/host1x/debug.c                         |  210 +++
 drivers/gpu/host1x/debug.h                         |   51 +
 drivers/gpu/host1x/dev.c                           |  246 ++++
 drivers/gpu/host1x/dev.h                           |  308 ++++
 drivers/gpu/{drm/tegra => host1x/drm}/Kconfig      |   20 +-
 drivers/gpu/{drm/tegra => host1x/drm}/dc.c         |   31 +-
 drivers/gpu/{drm/tegra => host1x/drm}/dc.h         |    0
 drivers/gpu/host1x/drm/drm.c                       |  640 ++++++++
 drivers/gpu/{drm/tegra => host1x/drm}/drm.h        |   68 +-
 drivers/gpu/host1x/drm/fb.c                        |  374 +++++
 drivers/gpu/host1x/drm/gem.c                       |  270 ++++
 drivers/gpu/host1x/drm/gem.h                       |   59 +
 drivers/gpu/host1x/drm/gr2d.c                      |  339 +++++
 drivers/gpu/{drm/tegra => host1x/drm}/hdmi.c       |    5 +-
 drivers/gpu/{drm/tegra => host1x/drm}/hdmi.h       |    0
 drivers/gpu/{drm/tegra => host1x/drm}/output.c     |    0
 drivers/gpu/{drm/tegra => host1x/drm}/rgb.c        |    0
 drivers/gpu/host1x/host1x.h                        |   30 +
 drivers/gpu/host1x/host1x_bo.h                     |   87 ++
 drivers/gpu/host1x/host1x_client.h                 |   35 +
 drivers/gpu/host1x/hw/Makefile                     |    6 +
 drivers/gpu/host1x/hw/cdma_hw.c                    |  326 +++++
 drivers/gpu/host1x/hw/channel_hw.c                 |  168 +++
 drivers/gpu/host1x/hw/debug_hw.c                   |  322 ++++
 drivers/gpu/host1x/hw/host1x01.c                   |   42 +
 drivers/gpu/host1x/hw/host1x01.h                   |   25 +
 drivers/gpu/host1x/hw/host1x01_hardware.h          |  143 ++
 drivers/gpu/host1x/hw/hw_host1x01_channel.h        |  120 ++
 drivers/gpu/host1x/hw/hw_host1x01_sync.h           |  243 +++
 drivers/gpu/host1x/hw/hw_host1x01_uclass.h         |  174 +++
 drivers/gpu/host1x/hw/intr_hw.c                    |  143 ++
 drivers/gpu/host1x/hw/syncpt_hw.c                  |  114 ++
 drivers/gpu/host1x/intr.c                          |  354 +++++
 drivers/gpu/host1x/intr.h                          |  102 ++
 drivers/gpu/host1x/job.c                           |  603 ++++++++
 drivers/gpu/host1x/job.h                           |  162 ++
 drivers/gpu/host1x/syncpt.c                        |  387 +++++
 drivers/gpu/host1x/syncpt.h                        |  165 +++
 drivers/video/Kconfig                              |    2 +
 drivers/video/console/fbcon.c                      |    2 +
 drivers/video/fbmem.c                              |    7 +
 drivers/video/hdmi.c                               |   21 +-
 drivers/video/omap2/Makefile                       |    2 +-
 drivers/video/omap2/displays/panel-acx565akm.c     |   59 +-
 drivers/video/omap2/displays/panel-generic-dpi.c   |   39 +-
 .../omap2/displays/panel-lgphilips-lb035q02.c      |   58 +-
 drivers/video/omap2/displays/panel-n8x0.c          |   95 +-
 .../omap2/displays/panel-nec-nl8048hl11-01b.c      |  135 +-
 drivers/video/omap2/displays/panel-picodlp.c       |   49 +-
 .../video/omap2/displays/panel-sharp-ls037v7dw01.c |  126 +-
 drivers/video/omap2/displays/panel-taal.c          |  300 +---
 drivers/video/omap2/displays/panel-tfp410.c        |    4 +-
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |   45 +-
 drivers/video/omap2/dss/apply.c                    |   15 +-
 drivers/video/omap2/dss/core.c                     |    5 +-
 drivers/video/omap2/dss/dispc.c                    |  176 ++-
 drivers/video/omap2/dss/dispc.h                    |    1 +
 drivers/video/omap2/dss/dpi.c                      |  351 +++--
 drivers/video/omap2/dss/dsi.c                      | 1256 +++++++++-------
 drivers/video/omap2/dss/dss.c                      |  181 +--
 drivers/video/omap2/dss/dss.h                      |   59 +-
 drivers/video/omap2/dss/dss_features.c             |    8 +-
 drivers/video/omap2/dss/hdmi.c                     |   68 +-
 drivers/video/omap2/dss/output.c                   |    1 +
 drivers/video/omap2/dss/rfbi.c                     |   34 +-
 drivers/video/omap2/dss/sdi.c                      |  103 +-
 drivers/video/omap2/dss/venc.c                     |   56 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |   32 +-
 include/drm/drmP.h                                 |    5 +-
 include/drm/drm_crtc.h                             |   23 +-
 include/drm/drm_edid.h                             |    9 +
 include/drm/drm_fb_helper.h                        |   10 +-
 include/drm/drm_pciids.h                           |    5 +
 include/drm/ttm/ttm_bo_driver.h                    |    4 +
 include/linux/fb.h                                 |    2 +
 include/linux/pm.h                                 |   13 +
 include/linux/scatterlist.h                        |   28 +-
 include/trace/events/host1x.h                      |  253 ++++
 include/uapi/drm/Kbuild                            |    2 +
 include/uapi/drm/drm.h                             |    6 +-
 include/uapi/drm/drm_mode.h                        |    6 +-
 include/uapi/drm/qxl_drm.h                         |  152 ++
 include/uapi/drm/radeon_drm.h                      |   26 +
 include/uapi/drm/tegra_drm.h                       |  136 ++
 include/video/omap-panel-data.h                    |  150 ++
 include/video/omap-panel-generic-dpi.h             |   37 -
 include/video/omap-panel-n8x0.h                    |   15 -
 include/video/omap-panel-nokia-dsi.h               |   32 -
 include/video/omap-panel-picodlp.h                 |   23 -
 include/video/omap-panel-tfp410.h                  |   35 -
 include/video/omapdss.h                            |   86 +-
 kernel/power/console.c                             |  116 ++
 lib/scatterlist.c                                  |    4 +-
 404 files changed, 29278 insertions(+), 7300 deletions(-)
 create mode 100644 Documentation/EDID/1600x1200.S
 delete mode 100644 Documentation/devicetree/bindings/drm/exynos/g2d.txt
 rename drivers/gpu/drm/nouveau/core/{subdev => engine}/device/base.c (89%)
 rename drivers/gpu/drm/nouveau/core/{subdev => engine}/device/nv04.c (99%)
 rename drivers/gpu/drm/nouveau/core/{subdev => engine}/device/nv10.c (99%)
 rename drivers/gpu/drm/nouveau/core/{subdev => engine}/device/nv20.c (99%)
 rename drivers/gpu/drm/nouveau/core/{subdev => engine}/device/nv30.c (99%)
 rename drivers/gpu/drm/nouveau/core/{subdev => engine}/device/nv40.c (99%)
 rename drivers/gpu/drm/nouveau/core/{subdev => engine}/device/nv50.c (97%)
 rename drivers/gpu/drm/nouveau/core/{subdev => engine}/device/nvc0.c (90%)
 rename drivers/gpu/drm/nouveau/core/{subdev => engine}/device/nve0.c (79%)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/nvf0.c
 rename drivers/gpu/drm/nouveau/core/include/{subdev => engine}/device.h (93%)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/nv84.c
 create mode 100644 drivers/gpu/drm/nouveau/dispnv04/Makefile
 rename drivers/gpu/drm/nouveau/{nouveau_calc.c => dispnv04/arb.c} (99%)
 rename drivers/gpu/drm/nouveau/{nv04_crtc.c => dispnv04/crtc.c} (99%)
 rename drivers/gpu/drm/nouveau/{nv04_cursor.c => dispnv04/cursor.c} (98%)
 rename drivers/gpu/drm/nouveau/{nv04_dac.c => dispnv04/dac.c} (99%)
 rename drivers/gpu/drm/nouveau/{nv04_dfp.c => dispnv04/dfp.c} (99%)
 rename drivers/gpu/drm/nouveau/{nv04_display.c => dispnv04/disp.c} (99%)
 rename drivers/gpu/drm/nouveau/{nv04_display.h => dispnv04/disp.h} (100%)
 rename drivers/gpu/drm/nouveau/{nouveau_hw.c => dispnv04/hw.c} (99%)
 rename drivers/gpu/drm/nouveau/{nouveau_hw.h => dispnv04/hw.h} (99%)
 rename drivers/gpu/drm/nouveau/{ => dispnv04}/nvreg.h (100%)
 rename drivers/gpu/drm/nouveau/{nv17_tv_modes.c => dispnv04/tvmodesnv17.c} (99%)
 rename drivers/gpu/drm/nouveau/{nv04_tv.c => dispnv04/tvnv04.c} (99%)
 rename drivers/gpu/drm/nouveau/{nv17_tv.c => dispnv04/tvnv17.c} (99%)
 rename drivers/gpu/drm/nouveau/{nv17_tv.h => dispnv04/tvnv17.h} (100%)
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_irq.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_irq.h
 create mode 100644 drivers/gpu/drm/qxl/Kconfig
 create mode 100644 drivers/gpu/drm/qxl/Makefile
 create mode 100644 drivers/gpu/drm/qxl/qxl_cmd.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_debugfs.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_dev.h
 create mode 100644 drivers/gpu/drm/qxl/qxl_display.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_draw.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_drv.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_drv.h
 create mode 100644 drivers/gpu/drm/qxl/qxl_dumb.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_fb.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_fence.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_gem.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_image.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_ioctl.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_irq.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_kms.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_object.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_object.h
 create mode 100644 drivers/gpu/drm/qxl/qxl_release.c
 create mode 100644 drivers/gpu/drm/qxl/qxl_ttm.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_uvd.c
 delete mode 100644 drivers/gpu/drm/tegra/Makefile
 delete mode 100644 drivers/gpu/drm/tegra/drm.c
 delete mode 100644 drivers/gpu/drm/tegra/fb.c
 delete mode 100644 drivers/gpu/drm/tegra/host1x.c
 create mode 100644 drivers/gpu/host1x/Kconfig
 create mode 100644 drivers/gpu/host1x/Makefile
 create mode 100644 drivers/gpu/host1x/cdma.c
 create mode 100644 drivers/gpu/host1x/cdma.h
 create mode 100644 drivers/gpu/host1x/channel.c
 create mode 100644 drivers/gpu/host1x/channel.h
 create mode 100644 drivers/gpu/host1x/debug.c
 create mode 100644 drivers/gpu/host1x/debug.h
 create mode 100644 drivers/gpu/host1x/dev.c
 create mode 100644 drivers/gpu/host1x/dev.h
 rename drivers/gpu/{drm/tegra => host1x/drm}/Kconfig (53%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/dc.c (97%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/dc.h (100%)
 create mode 100644 drivers/gpu/host1x/drm/drm.c
 rename drivers/gpu/{drm/tegra => host1x/drm}/drm.h (77%)
 create mode 100644 drivers/gpu/host1x/drm/fb.c
 create mode 100644 drivers/gpu/host1x/drm/gem.c
 create mode 100644 drivers/gpu/host1x/drm/gem.h
 create mode 100644 drivers/gpu/host1x/drm/gr2d.c
 rename drivers/gpu/{drm/tegra => host1x/drm}/hdmi.c (99%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/hdmi.h (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/output.c (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/rgb.c (100%)
 create mode 100644 drivers/gpu/host1x/host1x.h
 create mode 100644 drivers/gpu/host1x/host1x_bo.h
 create mode 100644 drivers/gpu/host1x/host1x_client.h
 create mode 100644 drivers/gpu/host1x/hw/Makefile
 create mode 100644 drivers/gpu/host1x/hw/cdma_hw.c
 create mode 100644 drivers/gpu/host1x/hw/channel_hw.c
 create mode 100644 drivers/gpu/host1x/hw/debug_hw.c
 create mode 100644 drivers/gpu/host1x/hw/host1x01.c
 create mode 100644 drivers/gpu/host1x/hw/host1x01.h
 create mode 100644 drivers/gpu/host1x/hw/host1x01_hardware.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_channel.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_sync.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_uclass.h
 create mode 100644 drivers/gpu/host1x/hw/intr_hw.c
 create mode 100644 drivers/gpu/host1x/hw/syncpt_hw.c
 create mode 100644 drivers/gpu/host1x/intr.c
 create mode 100644 drivers/gpu/host1x/intr.h
 create mode 100644 drivers/gpu/host1x/job.c
 create mode 100644 drivers/gpu/host1x/job.h
 create mode 100644 drivers/gpu/host1x/syncpt.c
 create mode 100644 drivers/gpu/host1x/syncpt.h
 create mode 100644 include/trace/events/host1x.h
 create mode 100644 include/uapi/drm/qxl_drm.h
 create mode 100644 include/uapi/drm/tegra_drm.h
 create mode 100644 include/video/omap-panel-data.h
 delete mode 100644 include/video/omap-panel-generic-dpi.h
 delete mode 100644 include/video/omap-panel-n8x0.h
 delete mode 100644 include/video/omap-panel-nokia-dsi.h
 delete mode 100644 include/video/omap-panel-picodlp.h
 delete mode 100644 include/video/omap-panel-tfp410.h
--29444707-1664111703-1367544357=:12778--
