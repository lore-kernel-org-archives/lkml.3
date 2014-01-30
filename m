Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaA3CuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 21:50:05 -0500
Received: from gir.skynet.ie ([193.1.99.77]:54997 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaA3CuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 21:50:00 -0500
Date: Thu, 30 Jan 2014 02:49:57 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm next tree
Message-ID: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1942971507-1391050197=:13810"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1942971507-1391050197=:13810
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Been a bit busy, first week of kids school, and waiting on other trees to go in before I could send this, so its a bit later than I'd normally like.

For some reason the request-pull and the merge into your tree look different,
since some of the changes in this have already gone in via the arm-soc tree
and dma stuff, all for tegra. Hopefully nobody rebased when they shouldn't.

Highlights:
core: timestamp fixes, lots of misc cleanups
new drivers: bochs virtual vga
vmwgfx: major overhaul for their nextgen virt gpu.
i915: runtime D3 on HSW, watermark fixes, power well work, fbc fixes, bdw is no longer prelim.
nouveau: gk110/208 acceleration, more pm groundwork, old overlay support
radeon: dpm rework and clockgating for CIK, pci config reset, big endian fixes
tegra: panel support and DSI support, build as module, prime.
armada, omap, gma500, rcar, exynos, mgag200, cirrus, ast: fixes
msm: hdmi support for mdp5

Dave.

The following changes since commit d8ec26d7f8287f5788a494f56e8814210f0e64be:

  Linux 3.13 (2014-01-19 18:40:07 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to ef64cf9d06049e4e9df661f3be60b217e476bee1:

  Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next (2014-01-30 10:46:06 +1000)

----------------------------------------------------------------

Akash Goel (1):
      drm/i915: Fix the offset issue for the stolen GEM objects

Alex Deucher (59):
      drm/radeon/dpm: remove unnecessary checks in dpm_init
      drm/radeon/si: drop cg_update from dpm code
      drm/radeon/cik: drop cg_update from dpm code
      drm/radeon: re-order firmware loading in preparation for dpm rework
      drm/radeon/dpm: add a late enable callback
      drm/radeon/dpm: add late_enable for rs780/rs880/rv6xx
      drm/radeon/dpm: add late_enable for rv7xx-NI
      drm/radeon/dpm: add late_enable for sumo
      drm/radeon/dpm: add late_enable for trinity
      drm/radeon/dpm: add late_enable for SI
      drm/radeon/dpm: add late_enable for CI
      drm/radeon/dpm: add late_enable for KB/KV
      drm/radeon/dpm: switch on new late_enable callback
      drm/radeon/pm: move pm handling into the asic specific code
      drm/radeon: enable gfx cgcg on CIK dGPUs
      drm/radeon: enable gfx cgcg on CIK APUs
      drm/radeon: enable dpm by default on CI dGPUs
      drm/radeon: enable dpm by default on CI APUs
      drm/radeon: remove generic rptr/wptr functions (v2)
      drm/radeon: fix pptable.h portability
      drm/radeon: warn users when hw_i2c is enabled (v2)
      drm/radeon/dpm: make some functions static for CI
      drm/radeon/dpm: make some functions static for sumo
      drm/radeon/dpm: make some functions static for TN
      drm/radeon: move com/atombios scratch reg functions to radeon_mode.h
      drm/radeon: add hard_reset module parameter
      drm/radeon: add pci config hard reset
      drm/radeon: implement pci config reset for r6xx/7xx (v3)
      drm/radeon: implement pci config reset for evergreen/cayman (v2)
      drm/radeon: implement pci config reset for SI (v2)
      drm/radeon: implement pci config reset for CIK (v3)
      Revert "drm/radeon: disable CIK CP semaphores for now"
      drm/radeon: consolidate cp hdp flushing code for CIK
      drm/radeon: consolidate sdma hdp flushing code for CIK
      drm/radeon/cik: use POLL_REG_MEM special op for sDMA HDP flush
      drm/radeon/cik: use WAIT_REG_MEM special op for CP HDP flush
      drm/radeon: disable dpm on BTC
      drm/radeon/cik: use hw defaults for TC_CFG registers
      drm/radeon: disable ss on DP for DCE3.x
      drm/radeon/dp: bump i2c-over-aux retries to 7
      drm/radeon/dp: use usleep_range rather than udelay
      drm/radeon/dp: sleep after powering up the display
      drm/radeon: add query to fetch the max engine clock (v2)
      drm/radeon: handle ss percentage divider properly
      drm/radeon: bail early from enable ss in certain cases
      drm/radeon: write gfx pg bases even when gfx pg is disabled
      drm/radeon: fix endian handling in radeon_atom_init_mc_reg_table
      drm/radeon/dpm: disable mclk switching on desktop RV770
      drm/radeon: fix surface sync in fence on cayman (v2)
      drm/radeon: set the full cache bit for fences on r7xx+
      drm/radeon: fix minor typos in si_dpm.c
      drm/radeon: add UVD support for OLAND
      drm/radeon/runpm: don't runtime suspend non-PX cards
      drm/radeon: skip async dma init on r6xx
      drm/radeon: clean up active vram sizing
      drm/radeon: fix DAC interrupt handling on DCE5+
      drm/radeon: set si_notify_smc_display_change properly
      drm/radeon/DCE4+: clear bios scratch dpms bit (v2)
      drm/radeon/dce8: workaround for atom BlankCrtc table

Andrzej Hajda (1):
      drm: Add MIPI DSI bus support

Archit Taneja (5):
      drm/omap: fix: Defer probe if an omapdss device requests for it at connect
      drm/omap: fix: disconnect devices when omapdrm module is removed
      drm/omap: fix: disable encoder before destroying it
      drm/omap: fix: change dev_unload order
      drm/omap: Enable DT support for DMM

Ben Skeggs (59):
      drm/nouveau/vm: reduce number of entry-points to vm_map()
      drm/nouveau/ttm: tidy up creation of temporary buffer move vmas
      drm/nouveau/ttm: explicity sync with kernel channel before moving buffer
      drm/nouveau/ttm: explicitly wait for bo idle before memcpy buffer move
      drm/nouveau/gem: remove (now) unneeded pre-validate fence sync
      drm/nvc0-/gr: bring in some macros to abstract falcon isa differences
      drm/nvf0/gr: remove a copy+pasto in ctx reglist
      drm/nv108/fifo: initial support
      drm/nv108/ce: enable copy engines
      drm/nv108/gr: initial support (need external fuc)
      drm/nvc0-/gr: fiddle some magic around strand init
      drm/nvc0-/gr: handle fwmthd interrupts in ucode
      drm/nv108/gr: enable acceleration with our chsw ucode
      drm/nvf0/gr: enable acceleration with our chsw ucode
      drm/nve0/fifo: s/playlist/runlist/
      drm/nve0/fifo: s/subfifo/PBDMA/
      drm/nve0/fifo: populate PBDMA status bitfield with more definitions
      drm/nve0/fifo: document more intr status bits
      drm/nve0/fifo: update human-readable mmu fault descriptions
      drm/nve0/fifo: keep mmu fault interrupts enabled at all times
      drm/nve0/fifo: recover from mmu faults on bar1/bar3
      drm/nve0/fb/gddr5: fix behaviour of lp3 setting
      drm/nve0/fb/gddr5: fix an assumption of sane memory controller layout
      drm/nouveau/bios: make common code to handle ramcfg strap etc
      drm/nve0/fb: typo in register name
      drm/nve0/fb/gddr5: not all memory partitions are created equal
      drm/nve0/fb/gddr5: punt all 10f910/914 accesses through ram_train
      drm/nve0/fb/gddr5: switch off some other random bit at some point
      drm/nve0/fb/gddr5: fix calculation of RDQS setting
      drm/nouveau/fb/gddr5: modify mr8 with high bits of CL/WR
      drm/nve0/fb/gddr5: note another semi-unknown
      drm/nouveau/bios: timing 2.0 entries can have subentries
      drm/nve0/fb/gddr5: fixup delays a bit
      drm/nve0/fb/gddr5: somewhat better attempt at 100770/10f604/610/614
      drm/nve0/fb: note the memory voltage toggle, not using it yet
      drm/nve0/fb/gddr5: found LP3 setting
      drm/nve0/fb/gddr5: parse bios data into struct rather than using directly
      drm/nouveau/clk: allow fb to signal it needs to do a multi-stage reclock
      drm/nve0/fb: multi-stage reclock is required for certain transitions
      drm/nve0/fb: it's now safe to obey the memory voltage setting properly
      drm/nve0/fb/gddr5: 10f698/69c
      drm/nouveau/fb/gddr5: make sure we update mr7 when we're supposed to
      drm/nve0/clk: report ddr memory frequency
      drm/nve0/fb/gddr5: more 10f200 stuff
      drm/nvc0-/fb: hook up skeleton interrupt handler
      drm/nve0/fb/gddr5: yet another random 10f200 bit
      drm/nve0/fb/gddr5: merge a fix from ddr3 for one of the timing settings
      drm/nve0/fb: turn off some bits in 10f584 at init
      drm/nouveau/pwr: have rd/wr32 routines clobber data instead of addr
      drm/nouveau/pwr: implement a simple i2c stack
      drm/nouveau/instmem: tidy up the subdev class definition
      drm/nouveau/instmem: tidy up the object class definition
      drm/nouveau/bar: tidy up the subdev and object class definitions
      drm/nouveau/devinit: tidy up the subdev class definition
      drm/nouveau: create base display from common code
      drm/nouveau: call drm_vblank_cleanup() earlier
      drm/nv50: fill in crtc mode struct members from crtc_mode_fixup
      drm/nouveau/disp: add a method to fetch info needed by drm vblank timestamping
      drm/nouveau: implement hooks for needed for drm vblank timestamping support

Ben Widawsky (17):
      drm/i915: Require HW contexts (when possible)
      drm/i915: Fix BDW PPGTT error path
      drm/i915: Add a few missed bits to the mm
      drm/i915: Disallow dynamic ppgtt param modification
      drm/i915: Demote drop_caches_set print
      drm/i915: Removed unused vm args
      drm/i915: Remove defunct ctx switch comments
      drm/i915: Missed dropped VMA conversion
      drm/i915: Move the gtt mm takedown to cleanup
      drm/i915/bdw: Force all Data Cache Data Port access to be Non-Coherent
      drm/i915/bdw: Implement ff workarounds
      drm/i915: Reorder/respace MI instruction definition
      drm/i915: Don't emit mbox updates without semaphores
      drm/i915: Clarify relocation errnos
      drm/i915: Fix disabled semaphores
      drm/i915: Make semaphore modparam RO
      drm/i915/ppgtt: Defer request freeing on reset

Borislav Petkov (2):
      i915, debugfs: Fix uninitialized warning
      i915, fbdev: Fix Kconfig typo

Chon Ming Lee (4):
      drm/i915/vlv: Workaround a punit issue in DDR data rate for 1333.
      drm/i915/vlv: For i915_cur_delayinfo, the max frequency reporting wrong value.
      drm/i915/vlv: Rename VLV DPIO register to be more structure to match configdb document.
      drm/i915/vlv: Make the vlv_dpio_read/vlv_dpio_write more PHY centric

Chris Wilson (18):
      drm/i915: Initialise min/max frequencies before updating RPS registers
      drm/i915: Hold pc8 lock around toggling pc8.gpu_idle
      drm/i915: Drop forcewake w/a for missed interrupts/seqno on Sandybridge
      drm/i915: Do not attempt to re-enable an unconnected primary plane
      drm/i915: Add a timing breadcrumb to panel waits
      drm/i915: Fix ordering of unbind vs unpin pages
      drm/i915: Do hw quiescing first during unload
      video/fb: Propagate error code from failing to unregister conflicting fb
      drm/i915: Mention when we enable the Ironlake iommu workarounds
      drm/i915: Avoid dereference past end of page array in gen6_ppgtt_insert_entries()
      drm/i915: Avoid dereference past end of page array in gen8_ppgtt_insert_entries()
      drm/i915: Flush outstanding requests before allocating new seqno
      drm/i915: Only WARN about a stuck hotplug irq ONCE
      drm/i915: Only complain about a rogue hotplug IRQ after disabling
      drm/i915: Include more information in disabled hotplug interrupt warning
      drm/i915: Wait for completion of pending flips when starved of fences
      drm/i915: Repeat evictions whilst pageflip completions are outstanding
      drm/i915: Decouple GPU error reporting from ring initialisation

Christian König (10):
      drm/radeon: improve ring debugfs a bit
      drm/radeon: report the real offset in radeon_sa_bo_dump_debug_info
      drm/radeon: update fence values in before reporting them
      drm/radeon: cleanup radeon_ttm debugfs handling
      drm/radeon: add VRAM debugfs access v3
      drm/radeon: add GART debugfs access v3
      drm/radeon: don't power gate paused UVD streams
      drm/radeon: fix VMID use tracking
      drm/radeon: add missing trace point
      drm/radeon: add ring to fence trace functions

Damien Lespiau (6):
      drm/i915: Return a drm_mode_status enum in the mode_valid vfuncs
      drm/i915: Fix copy/paste DP vs eDP error in comment
      drm/i915: Remove if 0'ed static arrays
      drm/i915: Use IS_VALLEYVIEW() to test the is_valleyview flag
      drm/i915: Introduce new intel_output_name()
      drm: Make the connector mode_valid() vfunc return a drm_mode_status enum

Dan Carpenter (2):
      drm: use memdup_user() as a cleanup
      drm/tegra: Fix small leak on error in tegra_fb_alloc()

Daniel Vetter (59):
      drm/i915/ns2501: Rip out the reenable hack
      drm/i915: tune reset dmesg output a bit
      drm/i915: Make AGP=n work even on gen3
      drm/i915: Kill legeacy AGP for gen3 kms
      drm/i915: Deprecated UMS support
      drm/i915: Use for_each_pipe in intel_display_crc_init
      drm/i915: Reject opening of pipe crc files for invalid pipes
      Merge branch 'bdw-fixes' into backlight-rework
      Merge branch 'backlight-rework' into drm-intel-next-queued
      drm/i915: dp aux irq support for g4x/vlv
      drm/i915: remove intel_uncore_clear_errors
      drm/i915: Fix module unloading with DRM_I915_UMS=n
      drm/i915: drop the right force-wake engine in the vlv mmio funcs
      drm/i915: make sparse happy for the new vlv mmio read function
      drm/i915/sdvo: Fix up debug output to not split lines
      drm/i915/lvds: don't restore hw state in the lid notifier for pch platforms
      Merge tag 'v3.13-rc3' into drm-intel-next-queued
      drm/i915: Use symbolic names for booleans in i915_semaphore_is_enabled
      drm/i915: kick firmware fbs even when i915 fbdev is disabled
      drm: Don't split up debug output
      drm/rcar: call drm_put_dev directly in the ->remove hook
      drm/exynos: call drm_put_dev directly from ->remove
      drm/imx: directly call drm_put_dev in ->remove
      drm/tilcdc: call drm_put_dev directly from ->remove
      drm/omap: call drm_put_dev directly in ->remove
      drm/shmob: call drm_put_dev directly from ->remove hook
      drm/armada: directly call drm_put_dev in ->remove
      drm/msm: call drm_put_dev directly in ->remove
      drm: rip out drm_platform_exit
      drm: restrict the device list for shadow attached drivers
      drm/bufs: remove handling of _DRM_GEM mappings
      drm: kill DRIVER_REQUIRE_AGP
      drm: ->agp_init can't fail
      drm: rip out drm_core_has_AGP
      drm: remove agp_init() bus callback
      drm: inline drm_agp_destroy
      drm: kill the ->agp_destroy callback
      drm: remove global_mutex locking around agp_init
      drm: rip out DRM_AGP_MEM and DRM_AGP_KERN
      drm: Kill DRM_HZ
      drm: Kill DRM_IRQ_ARGS
      drm: Kill DRM_WAKUP and DRM_INIT_WAITQUEUE
      drm: Kill DRM_COPY_(TO|FROM)_USER
      drm: Kill DRM_*MEMORYBARRIER
      drm: Kill DRM_SUSER
      drm/gma500: Remove dead code
      drm: rip out dev->ioctl_count tracking
      drm: Kill file_priv->ioctl_count tracking
      drm: remove dev->vma_count
      drm/i915: grab a pages pin count for preallocate stolen
      drm/i915: Drop I915_ prefix from HAS_FBC
      drm/i915: i830M has watermarks like i855
      drm/i915: s/hotplugt_status_gen4/hotplug_status_g4x/
      drm: store the gem vma offset manager in a typed pointer
      drm/gma500: Remove unused function declaration
      Merge commit origin/master into drm-intel-next
      drm/gem: Always initialize the gem object in object_init
      drm/i915: Tune down reset_stat output from ERROR to debug
      Revert "drm/i915: Mask reserved bits in display/sprite address registers"

Dave Airlie (27):
      Merge tag 'drm-intel-next-2013-11-29' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      drm/agpsupport: use kzalloc instead of kmalloc/memset
      Merge branch 'drm/next/du' of git://linuxtv.org/pinchartl/fbdev into drm-next
      Merge tag 'drm/for-3.14-rc1' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge tag 'drm-intel-next-2013-12-13' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'msm-next' of git://people.freedesktop.org/~robclark/linux into drm-next
      Merge branch 'drm-next-3.14-wip' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge tag 'ttm-next-2014-01-13' of git://people.freedesktop.org/~thomash/linux into drm-next
      Merge tag 'vmwgfx-next-2014-01-13' of git://people.freedesktop.org/~thomash/linux into drm-next
      drm/mgag200: fix oops in cursor code.
      Merge tag 'vmwgfx-next-2014-01-17' of git://people.freedesktop.org/~thomash/linux into drm-next
      Merge branch 'drm-intel-next' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-next-3.14' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'vmwgfx-next' of git://people.freedesktop.org/~thomash/linux into drm-next
      Merge branch 'topic/core-stuff' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-vbl-timestamp' of git://gitorious.org/vsyrjala/linux into drm-next
      drm/mgag200: on cards with < 2MB VRAM default to 16-bit
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'gma500-next' of git://github.com/patjak/drm-gma500 into drm-next
      Merge tag 'omapdrm-3.14' of git://git.kernel.org/.../tomba/linux into drm-next
      Merge branch 'drm-armada-fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-next
      Merge tag 'drm-intel-fixes-2014-01-28' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      drm: ast,cirrus,mgag200: use drm_can_sleep
      Merge tag 'drm/for-3.14-rc1-20140123' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge branch 'drm-next-3.14' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next

Deepak S (6):
      drm/i915: Add power well arguments to force wake routines.
      drm/i915/vlv: Valleyview support for forcewake Individual power wells.
      drm/i915: Enabling DebugFS for valleyview forcewake counts
      drm/i915/vlv: Update Wait for FIFO and wait for 20 free entries. v3
      drm/i915: Remove duplicate intel_uncore_forcewake_reset.
      drm/i915/vlv: Add drpc debugfs support for valleyview

Geert Uytterhoeven (2):
      drm/edid: Make edid_load() return a void *
      drm/i915: Spelling s/auxilliary/auxiliary/

Gerd Hoffmann (1):
      drm/bochs: new driver

Ilia Mirkin (10):
      drm/nv10/plane: add YUYV support
      drm/nv04/plane: add support for nv04/nv05 video overlay
      drm/nouveau/falcon: use vmalloc to create firwmare copies
      drm/nouveau/device: provide a way for devinit to mark engines as disabled
      drm/nv50-/devinit: prevent use of engines marked as disabled by hw/vbios
      drm/nouveau/devinit: lock/unlock crtc regs for all devices, not just pre-nv50
      drm/nv50/gr: add more trap names to print on error
      drm/nv50/gr: update list of mp errors, make it a bitfield
      drm/nv50/gr: print mpc trap name when it's not an mp trap
      drm/nouveau: resume display if any later suspend bits fail

Imre Deak (16):
      drm/i915: add audio power domain
      drm/i915: support for multiple power wells
      drm/i915: add always-on power wells instead of special casing them
      drm/i915: use IS_HASWELL/BROADWELL instead of HAS_POWER_WELL
      drm/i915: don't do BDW/HSW specific powerdomains init on other platforms
      drm/i915: add a default always-on power well
      drm/i915: add a debugfs entry for power domain info
      drm/i915: add intel_display_power_enabled_sw() for use in atomic ctx
      drm/i915: simplify platform specific code in hsw_write_wm_values
      drm/i915: remove unused WM defines
      drm/i915: s/haswell_update_wm/ilk_update_wm/
      drm/i915: vlv: make CRI clock enabling explicit during resume
      drm/i915: vlv: W/a for hotplug/manual VGA detection
      drm/i915: g4x/vlv: fix dp aux interrupt mask
      drm/i915: don't disable the DP port if the link is lost
      drm/i915: don't disable DP port after a failed link training

Inki Dae (1):
      drm/exynos: use a new anon file for exynos gem mmaper

Jakob Bornecrantz (1):
      drm/vmwgfx: Invalidate surface on non-readback unbind

Jani Nikula (19):
      drm/i915: clean up backlight conditional build
      drm/i915: make backlight info per-connector
      drm/i915: make asle notifications update backlight on all connectors
      drm/i915: handle backlight through chip specific functions
      drm/i915: fix gen2-gen3 backlight set
      drm/i915: vlv does not have pipe field in backlight registers
      drm/i915: move backlight level setting in enable/disable to hooks
      drm/i915: use the initialized backlight max value instead of reading it
      drm/i915: debug print on backlight register
      drm/i915: gather backlight information at setup
      drm/i915: do full backlight setup at enable time
      drm/i915: remove QUIRK_NO_PCH_PWM_ENABLE
      drm/i915: nuke get max backlight functions
      drm/i915: do not save/restore backlight registers in KMS
      drm/i915: use __packed instead of __attribute__((packed))
      drm/i915: parse backlight modulation frequency from the BIOS VBT
      drm/i915: only build i915_debugfs.c when CONFIG_DEBUG_FS is enabled
      drm/i915: remove duplicate MODULE_LICENSE definition
      drm/i915: add braces around KHz/MHz macro parameters

Jeff Mahoney (1):
      drm/nouveau: make vga_switcheroo code depend on VGA_SWITCHEROO

Jesse Barnes (18):
      drm/i915: add bunit read/write routines
      drm/i915: move VLV DDR freq fetch into init_clock_gating
      drm/i915/vlv: modeset_global_* for VLV v7
      drm/i915/vlv: split CCK and DDR freq usage
      drm/i915/vlv: fixup DDR freq detection per Punit spec
      drm/i915: drop duplicate ggtt vma list add in setup_global_gtt
      drm/i915: split fb allocation and initialization v2
      drm/i915: protect HSW power well check with IS_HASWELL in redisable_vga
      drm/i915/vlv: use a lower RC6 timeout on VLV
      drm/i915/vlv: use parallel context restore when coming out of RC6
      drm/i915: drop DRM_ERROR in intel_fbdev init
      drm/i915/vlv: add early DPIO init v3
      drm/i915/vlv: split DPIO init and reset
      drm/i915: check modeset state after a pipe_set_base if using fastboot
      drm/i915: fix fastboot pfit disable hack to update pipe w/h
      drm/i915: use crtc_htotal when calculating ilk watermarks
      drm/i915/bdw: don't try to check IPS state on BDW v2
      drm/i915/bdw: remove preliminary_hw_support flag from BDW

Kenneth Graunke (1):
      drm/i915: Allow reading the TIMESTAMP register on Gen8.

Kristen Carlson Accardi (1):
      i915: send D1 opregion notification

Kristian Hogsberg (1):
      drm: Don't reference objects in the flink name idr

Laurent Pinchart (6):
      drm/rcar-du: Don't cast crtc to rcrtc twice in the same function
      drm/rcar-du: Update plane pitch in .mode_set_base() operation
      drm/rcar-du: Split features and quirks
      drm/rcar-du: Add LVDS_LANES quirk
      drm/rcar-du: Add support for the r8a7791 DU
      drm: shmob_drm: Check clk_prepare_enable() return value

Maarten Lankhorst (4):
      drm/nouveau: fix m2mf copy to tiled gart
      drm/nv50-: map TTM_PL_SYSTEM through a BAR for CPU access
      drm/nouveau: hold mutex while syncing to kernel channel
      drm/nouveau: fix lock unbalance in nouveau_crtc_page_flip

Marc Dietrich (1):
      drm/panel: Add support for Samsung LTN101NT05 panel

Marek Ol¨ák (1):
      drm/radeon: skip colorbuffer checking if COLOR_INFO.FORMAT is set to INVALID

Martin Koegler (1):
      drm/cirrus: Fix cirrus drm driver for fbdev + qemu

Michel Dänzer (1):
      radeon/pm: Guard access to rdev->pm.power_state array

Mika Kuoppala (6):
      drm/i915: add i915_reset_count
      drm/i915: add i915_get_reset_stats_ioctl
      drm/i915: check i915_get_reset_stats_ioctl args
      drm/i915: check context reset stats before relocations
      drm/i915: Fix timeout with missed interrupts in __wait_seqno
      drm/i915: dont call irq_put when irq test is on

Patrik Jakobsson (1):
      drm/gma500: Lock struct_mutex around cursor updates

Paul Walmsley (1):
      gpu: host1x: clk_round_rate() can return a zero upon error

Paulo Zanoni (27):
      drm/i915: reuse WRPLL when possible
      drm/i915: change CRTC assertion on LCPLL disable
      drm/i915: WARN if !HAS_PC8 when enabling/disabling PC8
      drm/i915: get a PC8 reference when enabling the power well
      drm/i915: add initial Runtime PM functions
      drm/i915: do adapter power state notification at runtime PM
      drm/i915: add runtime put/get calls at the basic places
      drm/i915: add some runtime PM get/put calls
      drm/i915: get a runtime PM reference when the panel VDD is on
      drm/i915: do not assert DE_PCH_EVENT_IVB enabled
      drm/i915: disable interrupts when enabling PC8
      drm/i915: add runtime PM support on Haswell
      drm/i915: don't enable VDD just to enable the panel
      drm/i915: don't touch the VDD when disabling the panel
      drm/i915: fix VDD override off wait
      drm/i915: remove i915_disable_vga_mem declaration
      drm/i915: extract hsw_power_well_post_{enable, disable}
      drm/i915: touch VGA MSR after we enable the power well
      drm/i915: split intel_ddi_pll_mode_set in 2 pieces
      drm/i915: cancel the hangcheck before runtime suspend
      drm/i915: release the GTT mmaps when going into D3
      drm/i915: add runtime PM support on Haswell
      drm: do not steal the display if we have a master
      drm/i915: avoid unclaimed registers when capturing the error state
      drm/i915: fix wrong PLL debug messages.
      drm/i915: don't set modes for 2 connectors on the same encoder
      drm/i915: only apply GAMMA_MODE IPS WA on HSW

Randy Dunlap (1):
      gpu: fix qxl missing crc32_le

Rashika (15):
      drivers: gpu: Include appropriate header file in drm_usb.c
      drivers: gpu: Mark function as static and remove unused function in ast_main.c
      drivers: gpu: Mark functions as static in ast_mode.c
      drivers: gpu: Mark functions as static in ast_ttm.c
      drivers: gpu: Mark function as static in cirrus_main.c
      drivers: gpu: Mark functions as static in cirrus_mode.c
      drivers: gpu: Mark functions as static and remove unused function in cirrus_ttm.c
      drivers: gpu: Mark function as static in mgag200_main.c
      drivers: gpu: Mark functions as static in mgag200_mode.c
      drivers: gpu: Mark functions as static in mgag200_ttm.c
      drivers: gpu: Include appropriate header file in mga_ioc32.c
      drivers: gpu: Mark function as static in qxl_kms.c
      drivers: gpu: Mark function as static in sis_drv.c
      drivers: gpu: Mark function as static in via_drv.c
      drivers: gpu: Include appropriate header file in r128_ioc32.c

Rashika Kheria (18):
      drivers: gpu: Mark function as static in cdv_intel_dp.c
      drivers: gpu: Mark function as static in radeon_object.c
      drivers: gpu: Mark functions as static in radeon_device.c
      drivers: gpu: Mark function as static in radeon_kms.c
      drivers: gpu: Mark function as static in radeon_gem.c
      drivers: gpu: Mark function as static in r600_hdmi.c
      drivers: gpu: Add static keyword to the definition of KMS_INVALID_IOCTL in radeon_kms.c
      drivers: gpu: Include appropriate header file in si_smc.c and remove prototype declaration from header file sislands_smc.h
      drivers: gpu: Move prototype declaration to header file radeon_mode.h from atombios_i2c.c
      drivers: gpu: Include appropriate header file in ci_smc.c
      drivers: gpu: Move prototype declaration to header file radeon_mode.h
      drivers: gpu: Move prototype declarations to header file radeon_mode.h from radeon_atombios.c and radeon_combios.c
      drivers: gpu: Mark function as static in ttm_bo.c
      drivers: gpu: Mark function as static in ttm_bo_util.c
      drivers: gpu: Remove unused function in ttm_lock.c
      drivers: gpu: Mark functions as static in vmwgfx_kms.c
      drivers: gpu: Mark functions as static in vmwgfx_buffer.c
      drivers: gpu: Mark functions as static in vmwgfx_fence.c

Rob Clark (14):
      drm: add DRM_ERROR_RATELIMITED
      drm/msm: COMPILE_TEST support
      drm/msm: add missing MODULE_FIRMWARE()s
      drm/msm: fix bus scaling
      drm/msm: add support for non-IOMMU systems
      drm/msm: add support for msm8060ab/bstem
      drm/msm: move mdp4 -> mdp/mdp4
      drm/msm: resync generated headers
      drm/msm: mdp4_format -> mdp_format
      drm/msm: split out msm_kms.h
      drm/msm: move irq utils to mdp_kms
      drm/msm: add hdmi support for apq8x74/mdp5
      drm/msm: add mdp5/apq8x74
      drm/msm: add a330/apq8x74

Russell King (2):
      drm: provide a helper for the encoder possible_crtcs mask
      DRM: armada: fix missing DRM_KMS_FB_HELPER select

Seung-Woo Kim (1):
      drm/exynos: fix build error caused by removed drm core macros

Shobhit Kumar (7):
      drm/i915: Add more dev ops for MIPI sub encoder
      drm/i915: Use FLISDSI interface for band gap reset
      drm/i915: Compute dsi_clk from pixel clock
      drm/i915: Try harder to get best m, n, p values with minimal error
      drm/i915: Reorganize the DSI enable/disable sequence
      drm/i915: Remove redundant DSI PLL enabling
      drm/i915: Parametrize the dphy and other spec specific parameters

Stanislaw Gruszka (1):
      i915: remove pm_qos request on error

Stephen Warren (3):
      drm/tegra: fix compile w/ CONFIG_DYNAMIC_DEBUG
      drm/panel: Add support for Chunghwa CLAA101WA01A panel
      drm/panel: update EDID BLOB in panel_simple_get_modes()

Takashi Iwai (1):
      drm/cirrus: correct register values for 16bpp

Tetsuo Handa (1):
      drm/i915: Fix refcount leak and possible NULL pointerdereference.

Thierry Reding (39):
      Merge tag 'tegra-for-3.14-dmas-resets-rework' into drm/for-next
      Merge tag 'tegra-for-3.14-powergate' into drm/for-next
      of: Add MIPI DSI bus device tree bindings
      of: Add simple panel device tree binding
      drm: Add panel support
      drm/panel: Add simple panel support
      drm/panel: Add support for Panasonic VVX10F004B0
      drm/tegra: Implement panel support
      gpu: host1x: Update host1x device tree example
      gpu: host1x: Add MIPI pad calibration DT bindings
      drm: Implement dummies for debugfs helpers
      drm/dp: Use AUX constants from specification
      gpu: host1x: Add MIPI pad calibration support
      gpu: host1x: Export public API
      gpu: host1x: Use the correct HW headers for host1x02
      gpu: host1x: Fix more sparse warnings
      gpu: host1x: Increase compile test coverage
      gpu: host1x: Fix build warnings
      gpu: host1x: Add Tegra124 support
      drm/tegra: Allow the driver to be built as a module
      drm/tegra: Increase compile test coverage
      drm/tegra: Remove spurious blank line
      drm/tegra: Do not export tegra_bo_ops
      drm/tegra: Fix HDMI audio frequency typo
      drm/tegra: Track HDMI enable state
      drm/tegra: Disable outputs for power-saving
      drm/tegra: Add DSI support
      drm/tegra: Sort reverse-dependencies alphabetically
      drm/tegra: Make legacy fbdev support optional
      drm/tegra: Add Tegra124 DC support
      drm/tegra: Relocate some output-specific code
      drm/tegra: Add PRIME support
      drm: Move drm_encoder_crtc_ok() to core
      drm/i915: Use drm_encoder_crtc_ok()
      drm/tegra: Fix possible CRTC mask for RGB outputs
      drm/tegra: Clarify how panel modes override others
      drm/tegra: Use proper data type
      gpu: host1x: Remove unnecessary include
      drm/tegra: Obtain head number from DT

Thomas Hellstrom (36):
      drm/ttm: Use VM_PFNMAP for shared bo maps
      drm/ttm: Refuse to fault (prime-) imported pages
      drm/ttm: Correctly set page mapping and -index members
      drm/ttm: ttm object security fixes for render nodes
      drm/vmwgfx: Fix the driver for large dma addresses
      drm/vmwgfx: Update the svga3d register header file for new device version
      drm/vmwgfx: Update the driver user-space interface for guest-backed objects
      drm/vmwgfx: Replace vram_size with prim_bb_mem for calculation of max resolution
      drm/vmwgfx: Update the svga register definition
      drm/vmwgfx: Adapt capability reporting to new hardware version
      drm/vmwgfx: Add MOB management
      drm/vmwgfx: Hook up MOBs to TTM as a separate memory type
      drm/vmwgfx: Read bounding box memory from the appropriate register
      drm/vmwgfx: Add the possibility to validate a buffer as a MOB
      drm/vmwgfx: Hook up guest-backed queries
      drm/vmwgfx: Detach backing store from its resources when it is evicted
      drm/vmwgfx: Hook up guest-backed contexts
      drm/vmwgfx: Hook up guest-backed surfaces
      drm/vmwgfx: Add guest-backed shaders
      drm/vmwgfx: Validate guest-backed shader const commands
      drm/vmwgfx: Add new unused (by user-space) commands to the verifier
      drm/vmwgfx: Enable 3D for new hardware version
      drm/vmwgfx: Fix up the vmwgfx_drv.h header for new files
      drm/vmwgfx: Extend the command verifier to handle guest-backed on / off
      drm/vmwgfx: Implement a buffer object synccpu ioctl.
      drm/vmwgfx: Add a parameter to get max MOB memory size
      drm/vmwgfx: Block the BIND_SHADERCONSTS command
      drm/vmwgfx: Track context bindings and scrub them upon exiting execbuf
      drm/vmwgfx: Persistent tracking of context bindings
      drm/vmwgfx: Ditch the vmw_dummy_query_bo_prepare function
      drm/vmwgfx: Use the linux DMA api also for MOBs
      drm/vmwgfx: Update otable definitions
      drm/vmwgfx: Fix surface framebuffer check for guest-backed surfaces
      drm/vmwgfx: Implement 64-bit Otable- and MOB binding v2
      drm/vmwgfx: Silence the device command verifier
      drm/vmwgfx: Fix recently introduced sparse / smatch warnings and errors

Thomas Wood (2):
      drm/edid: split VIC display mode lookup into a separate function
      drm/edid: parse the list of additional 3D modes

Todd Previte (2):
      drm/dp: Clarify automated test constant and add constant for FAUX test pattern
      drm/i915: VLV2 - Fix hotplug detect bits

Tomi Valkeinen (1):
      drm/omap: fix (un)registering irqs inside an irq handler

Vandana Kannan (2):
      drm/i915: Make downclock deduction common for all panels
      drm/edid: Populate picture aspect ratio for CEA modes

Ville Syrjälä (75):
      drm/i915: Sanitize prepare_pipes after valleyview_modeset_global_pipes()
      drm/i915: Improve vlv_gpu_freq() and vlv_freq_opcode()
      drm/i915: Pass dev_priv to vlv_gpu_freq() and vlv_freq_opcode()
      drm/i915: Fix gen3/4 vblank counter wraparound
      drm/i915: Use frame counter for intel_wait_for_vblank() on CTG
      drm/i915: Kill vlv_update_rps_cur_delay()
      drm/i915: Use clamp_t() when limiting cur_delay
      drm/i915: Make AGP support optional
      drm/i915: Limit FBC flush to post batch flush
      drm/i915: Emit SRM after the MSG_FBC_REND_STATE LRI
      drm/i915: Set has_fbc=true for all SNB+, except VLV
      drm/i915: Use plane_name() in gen7_enable_fbc()
      drm/i915: Enable pipe gamma for sprites
      drm/i915: Don't set the fence number in DPFC_CTL on SNB
      drm/i915: Report all GTFIFODBG errors
      drm/i915: Fix GT wake FIFO free entries for VLV
      drm/i915: Fix port name in vlv_wait_port_ready() timeout warning
      drm/i915: Avoid div-by-zero in clock calculation funcs
      drm/i915: Add REG_WRITE_FOOTER
      drm/i915: Fix bogus FBC1 defines
      drm/i915: Fix FBC1 plane checks for gen2
      drm/i915: Reorganize FBC function pointer initializaition
      drm/i915: Swap primary planes on gen2 for FBC
      drm/i915: Don't cast away const from infoframe buffer
      drm/i915: Move VLV PHY CRI clock enable into intel_init_dpio()
      drm/i915: Use 32bit read for BB_ADDR
      drm/i915: Record BB_ADDR for every ring
      drm/i915: Extract p2 divider correctly for gen2 LVDS dual channel
      drm/i915: Change N divider minimum from 3 to 2 for gen2
      drm/i915: Increase gen2 vco frequency limit to 1512 MHz
      drm/i915: Fix 66 MHz LVDS SSC freq for gen2
      drm/i915: Decrease gen2 vco frequency minimum to 908 MHz
      drm/i915: Gen2 FBC1 CFB pitch wants 32B units
      drm/i915: FBC_CONTROL2 is gen4 only
      drm/i915: Enable FBC for all mobile gen2 and gen3 platforms
      drm/i915: Rework the FBC interval/stall stuff a bit
      drm/i915: Clear out old GT FIFO errors in intel_uncore_early_sanitize()
      drm/i915/bdw: Don't use forcewake needlessly
      drm/i915: Add IVB DDB partitioning control
      drm/i915: Add ILK/SNB/IVB WM latency field support
      drm/i915: Avoid computing invalid WM levels when sprites/scaling is enabled
      drm/i915: Fix LP1 sprite watermarks for ILK/SNB
      drm/i915: Fix LP1+ watermark disabling ILK
      drm/i915: Don't merge LP1+ watermarks on ILK/SNB/IVB when multiple pipes are enabled
      drm/i915: Disable FBC WM on ILK, and disable LP2+ when FBC is enabled
      drm/i915: Linetime watermarks are a HSW feature
      drm/i915: Disable LP1+ watermarks safely in init
      drm/i915: Move ILK/SNB/IVB over to the HSW WM code
      drm/i915: Try to fix the messy IVB sprite scaling workaround
      drm/i915: Don't disable primary when color keying is used
      drm/i915: Avoid underruns when disabling sprites
      Revert "drm/i915/sprite: Always enable the scaler on IronLake"
      drm: Push dirtyfb ioctl kms locking down to drivers
      drm/i915: Fix watermark code for BDW
      drm/i915: Enable watermarks for BDW
      drm/i915: Simplify watermark/init_clock_gating setup
      drm/i915: Don't swap planes on 830M
      drm/i915: No panel fitter on 830M or non-mobile gen2/3 platforms
      drm/i915: 830M doesn't have an LVDS port
      drm/i915: Fix 915GM self-refresh enable/disable
      drm: Pass the display mode to drm_calc_timestamping_constants()
      drm: Pass the display mode to drm_calc_vbltimestamp_from_scanoutpos()
      drm/i915: Kill hwmode save/restore
      drm/i915: Call drm_calc_timestamping_constants() earlier
      drm: Improve drm_calc_timestamping_constants() documentation
      drm: Simplify the math in drm_calc_timestamping_constants()
      drm/radeon: Populate crtc_clock in radeon_atom_get_tv_timings()
      drm: Use crtc_clock in drm_calc_timestamping_constants()
      drm: Change {pixel,line,frame}dur_ns from s64 to int
      drm/i915: Fix scanoutpos calculations for interlaced modes
      drm: Fix vblank timestamping constants for interlaced modes
      drm: Pass 'flags' from the caller to .get_scanout_position()
      drm/radeon: Move the early vblank IRQ fixup to radeon_get_crtc_scanoutpos()
      drm/i915: Add a kludge for DSL incrementing too late and ISR not working
      drm/i915: Eliminate lots of WARNs when there's no backlight present

Wei Yongjun (4):
      drm/rcar-du: fix return value check in rcar_du_lvdsenc_get_resources()
      drm/i915: fix return value check of debugfs_create_file()
      drm/rcar-du: Fix return value check in rcar_du_lvdsenc_get_resources()
      drm/tegra: Fix return value check

Wolfram Sang (1):
      drm/tegra: Don't check resource with devm_ioremap_resource()

Zack Rusin (1):
      drm/vmwgfx: Make sure that the multisampling is off

 .../bindings/arm/tegra/nvidia,tegra20-pmc.txt      |    1 +
 .../bindings/clock/nvidia,tegra114-car.txt         |    4 +
 .../bindings/clock/nvidia,tegra124-car.txt         |   63 +
 .../bindings/clock/nvidia,tegra20-car.txt          |    4 +
 .../bindings/clock/nvidia,tegra30-car.txt          |    4 +
 .../devicetree/bindings/dma/tegra20-apbdma.txt     |   14 +
 .../bindings/gpu/nvidia,tegra20-host1x.txt         |  137 ++
 .../devicetree/bindings/i2c/nvidia,tegra20-i2c.txt |   27 +-
 .../bindings/input/nvidia,tegra20-kbc.txt          |    9 +
 .../devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt  |   98 ++
 .../bindings/mipi/nvidia,tegra114-mipi.txt         |   41 +
 .../bindings/mmc/nvidia,tegra20-sdhci.txt          |    9 +
 .../devicetree/bindings/nvec/nvidia,nvec.txt       |   12 +
 .../devicetree/bindings/panel/auo,b101aw03.txt     |    7 +
 .../bindings/panel/chunghwa,claa101wa01a.txt       |    7 +
 .../bindings/panel/chunghwa,claa101wb03.txt        |    7 +
 .../bindings/panel/panasonic,vvx10f004b00.txt      |    7 +
 .../bindings/panel/samsung,ltn101nt05.txt          |    7 +
 .../devicetree/bindings/panel/simple-panel.txt     |   21 +
 .../bindings/pci/nvidia,tegra20-pcie.txt           |   26 +-
 .../devicetree/bindings/pwm/nvidia,tegra20-pwm.txt |    9 +
 .../devicetree/bindings/rtc/nvidia,tegra20-rtc.txt |    3 +
 .../bindings/serial/nvidia,tegra20-hsuart.txt      |   19 +-
 .../bindings/sound/nvidia,tegra-audio-alc5632.txt  |    7 +-
 .../bindings/sound/nvidia,tegra-audio-rt5640.txt   |    7 +-
 .../bindings/sound/nvidia,tegra-audio-wm8753.txt   |    7 +-
 .../bindings/sound/nvidia,tegra-audio-wm8903.txt   |    7 +-
 .../bindings/sound/nvidia,tegra-audio-wm9712.txt   |    7 +-
 .../bindings/sound/nvidia,tegra20-ac97.txt         |   20 +-
 .../bindings/sound/nvidia,tegra20-i2s.txt          |   19 +-
 .../bindings/sound/nvidia,tegra30-ahub.txt         |   63 +-
 .../bindings/sound/nvidia,tegra30-i2s.txt          |   11 +-
 .../bindings/spi/nvidia,tegra114-spi.txt           |   24 +-
 .../bindings/spi/nvidia,tegra20-sflash.txt         |   20 +-
 .../bindings/spi/nvidia,tegra20-slink.txt          |   20 +-
 .../bindings/timer/nvidia,tegra20-timer.txt        |    3 +
 .../bindings/timer/nvidia,tegra30-timer.txt        |    3 +
 .../bindings/usb/nvidia,tegra20-ehci.txt           |    7 +-
 arch/arm/boot/dts/tegra114.dtsi                    |  157 +-
 arch/arm/boot/dts/tegra20-paz00.dts                |    2 +
 arch/arm/boot/dts/tegra20.dtsi                     |  136 +-
 arch/arm/boot/dts/tegra30.dtsi                     |  175 +-
 arch/arm/mach-tegra/Kconfig                        |    2 +
 arch/arm/mach-tegra/powergate.c                    |  203 ++-
 drivers/char/Makefile                              |    2 +-
 drivers/char/agp/Kconfig                           |    5 +
 drivers/char/agp/Makefile                          |    2 +-
 drivers/char/agp/intel-agp.c                       |    5 -
 drivers/char/agp/intel-gtt.c                       |   18 +
 drivers/clk/tegra/Makefile                         |    7 +-
 drivers/clk/tegra/clk-id.h                         |  235 +++
 drivers/clk/tegra/clk-periph-gate.c                |   30 +-
 drivers/clk/tegra/clk-periph.c                     |   72 +-
 drivers/clk/tegra/clk-pll.c                        |  407 +++--
 drivers/clk/tegra/clk-tegra-audio.c                |  215 +++
 drivers/clk/tegra/clk-tegra-fixed.c                |  111 ++
 drivers/clk/tegra/clk-tegra-periph.c               |  674 ++++++++
 drivers/clk/tegra/clk-tegra-pmc.c                  |  132 ++
 drivers/clk/tegra/clk-tegra-super-gen4.c           |  149 ++
 drivers/clk/tegra/clk-tegra114.c                   | 1688 +++++---------------
 drivers/clk/tegra/clk-tegra124.c                   | 1424 +++++++++++++++++
 drivers/clk/tegra/clk-tegra20.c                    |  817 ++++------
 drivers/clk/tegra/clk-tegra30.c                    | 1504 ++++++-----------
 drivers/clk/tegra/clk.c                            |  214 +++
 drivers/clk/tegra/clk.h                            |  116 +-
 drivers/dma/dmaengine.c                            |   63 +-
 drivers/dma/mmp_pdma.c                             |   30 +-
 drivers/dma/of-dma.c                               |   15 +-
 drivers/dma/tegra20-apb-dma.c                      |   52 +-
 drivers/gpu/drm/Kconfig                            |    8 +
 drivers/gpu/drm/Makefile                           |    4 +
 drivers/gpu/drm/armada/Kconfig                     |    1 +
 drivers/gpu/drm/armada/armada_drv.c                |    3 +-
 drivers/gpu/drm/ast/ast_fb.c                       |    2 +-
 drivers/gpu/drm/ast/ast_main.c                     |   49 +-
 drivers/gpu/drm/ast/ast_mode.c                     |   20 +-
 drivers/gpu/drm/ast/ast_ttm.c                      |    6 +-
 drivers/gpu/drm/bochs/Kconfig                      |   11 +
 drivers/gpu/drm/bochs/Makefile                     |    4 +
 drivers/gpu/drm/bochs/bochs.h                      |  164 ++
 drivers/gpu/drm/bochs/bochs_drv.c                  |  178 +++
 drivers/gpu/drm/bochs/bochs_fbdev.c                |  215 +++
 drivers/gpu/drm/bochs/bochs_hw.c                   |  177 ++
 drivers/gpu/drm/bochs/bochs_kms.c                  |  294 ++++
 drivers/gpu/drm/bochs/bochs_mm.c                   |  546 +++++++
 drivers/gpu/drm/cirrus/cirrus_drv.h                |    2 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c              |    5 +-
 drivers/gpu/drm/cirrus/cirrus_main.c               |    2 +-
 drivers/gpu/drm/cirrus/cirrus_mode.c               |   12 +-
 drivers/gpu/drm/cirrus/cirrus_ttm.c                |   26 +-
 drivers/gpu/drm/drm_agpsupport.c                   |   35 +-
 drivers/gpu/drm/drm_buffer.c                       |    2 +-
 drivers/gpu/drm/drm_bufs.c                         |   10 +-
 drivers/gpu/drm/drm_crtc.c                         |   25 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |   31 +-
 drivers/gpu/drm/drm_drv.c                          |    4 -
 drivers/gpu/drm/drm_edid.c                         |  289 ++--
 drivers/gpu/drm/drm_edid_load.c                    |    4 +-
 drivers/gpu/drm/drm_fb_helper.c                    |    6 +
 drivers/gpu/drm/drm_fops.c                         |   11 +-
 drivers/gpu/drm/drm_gem.c                          |   45 +-
 drivers/gpu/drm/drm_info.c                         |   16 +-
 drivers/gpu/drm/drm_irq.c                          |  119 +-
 drivers/gpu/drm/drm_memory.c                       |   15 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |  315 ++++
 drivers/gpu/drm/drm_panel.c                        |  100 ++
 drivers/gpu/drm/drm_pci.c                          |   38 +-
 drivers/gpu/drm/drm_platform.c                     |   12 -
 drivers/gpu/drm/drm_stub.c                         |   31 +-
 drivers/gpu/drm/drm_usb.c                          |    2 +-
 drivers/gpu/drm/drm_vm.c                           |   10 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |   25 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |    1 +
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |    6 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |   74 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.h            |    3 +
 drivers/gpu/drm/exynos/exynos_mixer.c              |    6 +-
 drivers/gpu/drm/gma500/accel_2d.c                  |    2 +-
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |   39 +-
 drivers/gpu/drm/gma500/gma_display.c               |   12 +-
 drivers/gpu/drm/gma500/psb_drv.h                   |    8 +-
 drivers/gpu/drm/gma500/psb_intel_drv.h             |    5 -
 drivers/gpu/drm/gma500/psb_irq.c                   |   19 +-
 drivers/gpu/drm/gma500/psb_irq.h                   |    2 +-
 drivers/gpu/drm/i810/i810_dma.c                    |    4 +
 drivers/gpu/drm/i810/i810_drv.c                    |    2 +-
 drivers/gpu/drm/i915/Kconfig                       |   32 +-
 drivers/gpu/drm/i915/Makefile                      |    3 +-
 drivers/gpu/drm/i915/dvo_ns2501.c                  |   73 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |  288 +++-
 drivers/gpu/drm/i915/i915_dma.c                    |   53 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  106 +-
 drivers/gpu/drm/i915/i915_drv.h                    |  164 +-
 drivers/gpu/drm/i915/i915_gem.c                    |  123 +-
 drivers/gpu/drm/i915/i915_gem_context.c            |   45 +-
 drivers/gpu/drm/i915/i915_gem_evict.c              |   27 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   69 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |   54 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c             |    3 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |   34 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  161 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  335 ++--
 drivers/gpu/drm/i915/i915_suspend.c                |   49 +-
 drivers/gpu/drm/i915/i915_sysfs.c                  |   49 +-
 drivers/gpu/drm/i915/i915_ums.c                    |   27 +
 drivers/gpu/drm/i915/intel_bios.c                  |   37 +-
 drivers/gpu/drm/i915/intel_bios.h                  |   64 +-
 drivers/gpu/drm/i915/intel_crt.c                   |    5 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |  148 +-
 drivers/gpu/drm/i915/intel_display.c               |  592 +++++--
 drivers/gpu/drm/i915/intel_dp.c                    |  164 +-
 drivers/gpu/drm/i915/intel_drv.h                   |   47 +-
 drivers/gpu/drm/i915/intel_dsi.c                   |  193 ++-
 drivers/gpu/drm/i915/intel_dsi.h                   |   21 +
 drivers/gpu/drm/i915/intel_dsi_pll.c               |  119 +-
 drivers/gpu/drm/i915/intel_dvo.c                   |    5 +-
 drivers/gpu/drm/i915/intel_fbdev.c                 |   65 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |   87 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |   15 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   90 +-
 drivers/gpu/drm/i915/intel_opregion.c              |   47 +-
 drivers/gpu/drm/i915/intel_overlay.c               |    2 +-
 drivers/gpu/drm/i915/intel_panel.c                 |  958 +++++++----
 drivers/gpu/drm/i915/intel_pm.c                    | 1671 +++++++------------
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   54 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   62 +-
 drivers/gpu/drm/i915/intel_sdvo_regs.h             |   40 +-
 drivers/gpu/drm/i915/intel_sideband.c              |   43 +-
 drivers/gpu/drm/i915/intel_sprite.c                |   86 +-
 drivers/gpu/drm/i915/intel_uncore.c                |  319 +++-
 drivers/gpu/drm/mga/mga_dma.c                      |    4 +-
 drivers/gpu/drm/mga/mga_drv.h                      |    4 +-
 drivers/gpu/drm/mga/mga_ioc32.c                    |    1 +
 drivers/gpu/drm/mga/mga_irq.c                      |    8 +-
 drivers/gpu/drm/mga/mga_state.c                    |    2 +-
 drivers/gpu/drm/mgag200/mgag200_cursor.c           |    8 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c               |    9 +-
 drivers/gpu/drm/mgag200/mgag200_main.c             |    7 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |    6 +-
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |    6 +-
 drivers/gpu/drm/msm/Kconfig                        |    3 +-
 drivers/gpu/drm/msm/Makefile                       |   21 +-
 drivers/gpu/drm/msm/NOTES                          |   20 +-
 drivers/gpu/drm/msm/adreno/a2xx.xml.h              |  125 +-
 drivers/gpu/drm/msm/adreno/a3xx.xml.h              |  116 +-
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |  190 ++-
 drivers/gpu/drm/msm/adreno/a3xx_gpu.h              |    4 +
 drivers/gpu/drm/msm/adreno/adreno_common.xml.h     |  171 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   25 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.h            |    9 +
 drivers/gpu/drm/msm/adreno/adreno_pm4.xml.h        |   30 +-
 drivers/gpu/drm/msm/dsi/dsi.xml.h                  |    8 +-
 drivers/gpu/drm/msm/dsi/mmss_cc.xml.h              |    8 +-
 drivers/gpu/drm/msm/dsi/sfpb.xml.h                 |    8 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |  201 ++-
 drivers/gpu/drm/msm/hdmi/hdmi.h                    |   38 +-
 drivers/gpu/drm/msm/hdmi/hdmi.xml.h                |   83 +-
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c             |   71 +
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c          |  139 +-
 drivers/gpu/drm/msm/hdmi/hdmi_phy_8x74.c           |  157 ++
 drivers/gpu/drm/msm/hdmi/qfprom.xml.h              |    8 +-
 drivers/gpu/drm/msm/{ => mdp}/mdp4/mdp4.xml.h      |   88 +-
 drivers/gpu/drm/msm/{ => mdp}/mdp4/mdp4_crtc.c     |   26 +-
 .../gpu/drm/msm/{ => mdp}/mdp4/mdp4_dtv_encoder.c  |    6 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_irq.c            |   93 ++
 drivers/gpu/drm/msm/{ => mdp}/mdp4/mdp4_kms.c      |   61 +-
 drivers/gpu/drm/msm/{ => mdp}/mdp4/mdp4_kms.h      |   56 +-
 drivers/gpu/drm/msm/{ => mdp}/mdp4/mdp4_plane.c    |    6 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h            | 1036 ++++++++++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c           |  569 +++++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c        |  258 +++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_irq.c            |  111 ++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c            |  350 ++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h            |  213 +++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c          |  389 +++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c            |  173 ++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.h            |   41 +
 drivers/gpu/drm/msm/mdp/mdp_common.xml.h           |   78 +
 .../msm/{mdp4/mdp4_format.c => mdp/mdp_format.c}   |   13 +-
 drivers/gpu/drm/msm/mdp/mdp_kms.c                  |  144 ++
 drivers/gpu/drm/msm/mdp/mdp_kms.h                  |   97 ++
 drivers/gpu/drm/msm/mdp4/mdp4_irq.c                |  203 ---
 drivers/gpu/drm/msm/msm_drv.c                      |  132 +-
 drivers/gpu/drm/msm/msm_drv.h                      |   64 +-
 drivers/gpu/drm/msm/msm_fb.c                       |    1 +
 drivers/gpu/drm/msm/msm_gem.c                      |  170 +-
 drivers/gpu/drm/msm/msm_gem.h                      |    5 +
 drivers/gpu/drm/msm/msm_gpu.c                      |   39 +-
 drivers/gpu/drm/msm/msm_gpu.h                      |    6 +-
 drivers/gpu/drm/msm/msm_iommu.c                    |  148 ++
 drivers/gpu/drm/msm/msm_kms.h                      |   68 +
 drivers/gpu/drm/msm/msm_mmu.h                      |   47 +
 drivers/gpu/drm/nouveau/Makefile                   |    7 +
 drivers/gpu/drm/nouveau/core/core/engine.c         |   23 +-
 drivers/gpu/drm/nouveau/core/engine/copy/nvc0.c    |    6 -
 drivers/gpu/drm/nouveau/core/engine/copy/nve0.c    |    6 -
 drivers/gpu/drm/nouveau/core/engine/device/nv04.c  |    8 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv10.c  |   32 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv20.c  |   16 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv30.c  |   20 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv40.c  |   64 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv50.c  |   56 +-
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |   36 +-
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |   28 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv04.c    |   38 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |   30 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.h    |    7 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv84.c    |    1 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv94.c    |    1 +
 drivers/gpu/drm/nouveau/core/engine/disp/nva3.c    |    3 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c    |   50 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nve0.c    |    5 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nvf0.c    |    5 +-
 drivers/gpu/drm/nouveau/core/engine/disp/vga.c     |    9 +-
 drivers/gpu/drm/nouveau/core/engine/falcon.c       |   20 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv108.c   |   37 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c    |    1 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |  414 +++--
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h    |   17 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnv108.c   | 1408 ++++++++++++++++
 .../gpu/drm/nouveau/core/engine/graph/ctxnvf0.c    |    7 +-
 .../gpu/drm/nouveau/core/engine/graph/fuc/com.fuc  |  138 +-
 .../gpu/drm/nouveau/core/engine/graph/fuc/gpc.fuc  |  137 +-
 .../nouveau/core/engine/graph/fuc/gpcnv108.fuc5    |   42 +
 .../nouveau/core/engine/graph/fuc/gpcnv108.fuc5.h  |  473 ++++++
 .../nouveau/core/engine/graph/fuc/gpcnvc0.fuc.h    |  704 ++++----
 .../nouveau/core/engine/graph/fuc/gpcnvd7.fuc.h    |  766 +++++----
 .../nouveau/core/engine/graph/fuc/gpcnve0.fuc.h    |  766 +++++----
 .../nouveau/core/engine/graph/fuc/gpcnvf0.fuc.h    |  766 +++++----
 .../gpu/drm/nouveau/core/engine/graph/fuc/hub.fuc  |  382 ++---
 .../nouveau/core/engine/graph/fuc/hubnv108.fuc5    |   40 +
 .../nouveau/core/engine/graph/fuc/hubnv108.fuc5.h  |  916 +++++++++++
 .../nouveau/core/engine/graph/fuc/hubnvc0.fuc.h    | 1238 +++++++-------
 .../nouveau/core/engine/graph/fuc/hubnvd7.fuc.h    | 1238 +++++++-------
 .../nouveau/core/engine/graph/fuc/hubnve0.fuc.h    | 1202 +++++++-------
 .../nouveau/core/engine/graph/fuc/hubnvf0.fuc.h    | 1202 +++++++-------
 .../drm/nouveau/core/engine/graph/fuc/macros.fuc   |  141 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv108.c  |  236 +++
 drivers/gpu/drm/nouveau/core/engine/graph/nv50.c   |  166 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |    3 +
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |   10 +
 drivers/gpu/drm/nouveau/core/engine/graph/nvf0.c   |   10 +-
 drivers/gpu/drm/nouveau/core/include/core/class.h  |   22 +
 drivers/gpu/drm/nouveau/core/include/core/device.h |    4 +-
 drivers/gpu/drm/nouveau/core/include/engine/fifo.h |    1 +
 .../gpu/drm/nouveau/core/include/engine/graph.h    |    1 +
 drivers/gpu/drm/nouveau/core/include/subdev/bar.h  |   23 +-
 .../drm/nouveau/core/include/subdev/bios/ramcfg.h  |   66 +
 .../drm/nouveau/core/include/subdev/bios/rammap.h  |   26 +-
 .../drm/nouveau/core/include/subdev/bios/timing.h  |   12 +-
 .../gpu/drm/nouveau/core/include/subdev/devinit.h  |   39 +-
 drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |   13 +
 .../gpu/drm/nouveau/core/include/subdev/instmem.h  |   34 +-
 drivers/gpu/drm/nouveau/core/include/subdev/vm.h   |    4 -
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |    6 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c     |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     |    3 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/priv.h     |   26 +
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |   48 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/ramcfg.c  |   67 +
 drivers/gpu/drm/nouveau/core/subdev/bios/rammap.c  |  107 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/timing.c  |   70 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/base.c   |    9 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nve0.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/base.c |   34 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c |   36 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.h |   23 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv05.c |   41 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c |   41 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv1a.c |   37 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv20.c |   41 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv50.c |   32 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv50.h |   18 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv84.c |   63 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv98.c |   62 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nva3.c |   50 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nvaf.c |   63 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nvc0.c |   44 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/priv.h |   38 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/gddr5.c     |   72 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |   16 +
 drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv50.c   |   18 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c   |   22 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c   |   24 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnve0.c   |  614 ++++---
 drivers/gpu/drm/nouveau/core/subdev/instmem/base.c |  135 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv04.c |  140 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv04.h |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c |   44 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv50.c |  117 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/priv.h |   56 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c      |    2 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/i2c_.fuc   |  393 +++++
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/kernel.fuc |   32 +-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/macros.fuc |   53 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nv108.fuc  |    3 +
 .../drm/nouveau/core/subdev/pwr/fuc/nv108.fuc.h    |  467 +++++-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nva3.fuc   |    3 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nva3.fuc.h |  484 +++++-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvc0.fuc   |    3 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvc0.fuc.h |  484 +++++-
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvd0.fuc   |    3 +
 .../gpu/drm/nouveau/core/subdev/pwr/fuc/nvd0.fuc.h |  533 ++++--
 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/os.h   |   19 +
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c      |   22 +-
 drivers/gpu/drm/nouveau/dispnv04/disp.c            |    5 -
 drivers/gpu/drm/nouveau/dispnv04/disp.h            |    1 -
 drivers/gpu/drm/nouveau/dispnv04/overlay.c         |  183 ++-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |    6 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  197 +--
 drivers/gpu/drm/nouveau/nouveau_display.c          |  133 +-
 drivers/gpu/drm/nouveau/nouveau_display.h          |    5 +
 drivers/gpu/drm/nouveau/nouveau_dma.c              |    2 +-
 drivers/gpu/drm/nouveau/nouveau_dma.h              |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   16 +-
 drivers/gpu/drm/nouveau/nouveau_drm.h              |    1 +
 drivers/gpu/drm/nouveau/nouveau_fence.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   10 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |   17 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |    1 +
 drivers/gpu/drm/nouveau/nv50_display.c             |   23 +-
 drivers/gpu/drm/omapdrm/omap_crtc.c                |   11 +-
 drivers/gpu/drm/omapdrm/omap_debugfs.c             |    2 +-
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c           |    9 +
 drivers/gpu/drm/omapdrm/omap_drv.c                 |   86 +-
 drivers/gpu/drm/omapdrm/omap_drv.h                 |    5 +-
 drivers/gpu/drm/omapdrm/omap_encoder.c             |    3 +
 drivers/gpu/drm/omapdrm/omap_fb.c                  |    4 +
 drivers/gpu/drm/omapdrm/omap_irq.c                 |   26 +-
 drivers/gpu/drm/panel/Kconfig                      |   19 +
 drivers/gpu/drm/panel/Makefile                     |    1 +
 drivers/gpu/drm/panel/panel-simple.c               |  548 +++++++
 drivers/gpu/drm/qxl/qxl_display.c                  |    9 +-
 drivers/gpu/drm/qxl/qxl_drv.h                      |    2 +-
 drivers/gpu/drm/qxl/qxl_ioctl.c                    |    4 +-
 drivers/gpu/drm/qxl/qxl_irq.c                      |    2 +-
 drivers/gpu/drm/qxl/qxl_kms.c                      |    2 +-
 drivers/gpu/drm/r128/r128_cce.c                    |    4 +-
 drivers/gpu/drm/r128/r128_drv.h                    |    4 +-
 drivers/gpu/drm/r128/r128_ioc32.c                  |    1 +
 drivers/gpu/drm/r128/r128_irq.c                    |    2 +-
 drivers/gpu/drm/r128/r128_state.c                  |   66 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |   52 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |   54 +-
 drivers/gpu/drm/radeon/atombios_i2c.c              |    2 -
 drivers/gpu/drm/radeon/btc_dpm.c                   |   20 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |   70 +-
 drivers/gpu/drm/radeon/ci_smc.c                    |    1 +
 drivers/gpu/drm/radeon/cik.c                       |  369 ++++-
 drivers/gpu/drm/radeon/cik_sdma.c                  |  120 +-
 drivers/gpu/drm/radeon/cikd.h                      |   11 +
 drivers/gpu/drm/radeon/cypress_dpm.c               |   15 -
 drivers/gpu/drm/radeon/evergreen.c                 |   99 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |    5 +-
 drivers/gpu/drm/radeon/evergreen_reg.h             |    1 +
 drivers/gpu/drm/radeon/evergreend.h                |    4 +
 drivers/gpu/drm/radeon/kv_dpm.c                    |   48 +-
 drivers/gpu/drm/radeon/ni.c                        |  141 +-
 drivers/gpu/drm/radeon/ni_dma.c                    |   77 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |   21 +-
 drivers/gpu/drm/radeon/nid.h                       |    1 +
 drivers/gpu/drm/radeon/pptable.h                   |    4 +-
 drivers/gpu/drm/radeon/r100.c                      |   38 +-
 drivers/gpu/drm/radeon/r300.c                      |    7 +
 drivers/gpu/drm/radeon/r300_cmdbuf.c               |    8 +-
 drivers/gpu/drm/radeon/r420.c                      |    7 +
 drivers/gpu/drm/radeon/r520.c                      |    5 +
 drivers/gpu/drm/radeon/r600.c                      |  166 +-
 drivers/gpu/drm/radeon/r600_cp.c                   |    4 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |    7 +-
 drivers/gpu/drm/radeon/r600_dma.c                  |   19 +-
 drivers/gpu/drm/radeon/r600_dpm.c                  |   20 +-
 drivers/gpu/drm/radeon/r600_dpm.h                  |    2 -
 drivers/gpu/drm/radeon/r600_hdmi.c                 |    2 +-
 drivers/gpu/drm/radeon/r600d.h                     |    8 +
 drivers/gpu/drm/radeon/radeon.h                    |   19 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |   85 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   64 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |   46 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |   16 -
 drivers/gpu/drm/radeon/radeon_connectors.c         |    9 -
 drivers/gpu/drm/radeon/radeon_cp.c                 |    6 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   12 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   23 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   46 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   13 +-
 drivers/gpu/drm/radeon/radeon_drv.h                |    2 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |    8 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |    9 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |    2 +-
 drivers/gpu/drm/radeon/radeon_i2c.c                |    3 +
 drivers/gpu/drm/radeon/radeon_irq.c                |   10 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |    4 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   24 +-
 drivers/gpu/drm/radeon/radeon_mem.c                |    2 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |   36 +
 drivers/gpu/drm/radeon/radeon_object.c             |    2 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |  158 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |   94 +-
 drivers/gpu/drm/radeon/radeon_sa.c                 |    6 +-
 drivers/gpu/drm/radeon/radeon_state.c              |   18 +-
 drivers/gpu/drm/radeon/radeon_trace.h              |   21 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |  197 ++-
 drivers/gpu/drm/radeon/radeon_uvd.c                |    3 +
 drivers/gpu/drm/radeon/rs400.c                     |    7 +
 drivers/gpu/drm/radeon/rs600.c                     |    7 +
 drivers/gpu/drm/radeon/rs690.c                     |    7 +
 drivers/gpu/drm/radeon/rs780_dpm.c                 |    8 -
 drivers/gpu/drm/radeon/rv515.c                     |    7 +
 drivers/gpu/drm/radeon/rv6xx_dpm.c                 |   10 -
 drivers/gpu/drm/radeon/rv770.c                     |   58 +-
 drivers/gpu/drm/radeon/rv770_dpm.c                 |   35 +-
 drivers/gpu/drm/radeon/rv770_dpm.h                 |    4 -
 drivers/gpu/drm/radeon/rv770d.h                    |    7 +
 drivers/gpu/drm/radeon/si.c                        |  163 +-
 drivers/gpu/drm/radeon/si_dpm.c                    |   69 +-
 drivers/gpu/drm/radeon/si_smc.c                    |    1 +
 drivers/gpu/drm/radeon/sid.h                       |    9 +-
 drivers/gpu/drm/radeon/sislands_smc.h              |    2 -
 drivers/gpu/drm/radeon/sumo_dpm.c                  |   21 +-
 drivers/gpu/drm/radeon/sumo_smc.c                  |    1 -
 drivers/gpu/drm/radeon/trinity_dpm.c               |   21 +-
 drivers/gpu/drm/radeon/trinity_smc.c               |    3 -
 drivers/gpu/drm/radeon/uvd_v2_2.c                  |    1 +
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |    3 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.c              |   28 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.h              |   14 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.c              |    4 +-
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c          |   28 +-
 drivers/gpu/drm/rcar-du/rcar_du_plane.c            |   21 +-
 drivers/gpu/drm/savage/savage_bci.c                |   10 +-
 drivers/gpu/drm/savage/savage_state.c              |    8 +-
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c          |   18 +-
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |    4 +-
 drivers/gpu/drm/sis/sis_drv.c                      |    2 +-
 drivers/gpu/drm/sis/sis_mm.c                       |    2 +-
 drivers/gpu/drm/tegra/Kconfig                      |   25 +-
 drivers/gpu/drm/tegra/Makefile                     |    2 +
 drivers/gpu/drm/tegra/bus.c                        |    1 -
 drivers/gpu/drm/tegra/dc.c                         |  117 +-
 drivers/gpu/drm/tegra/dc.h                         |    9 +
 drivers/gpu/drm/tegra/drm.c                        |   21 +-
 drivers/gpu/drm/tegra/drm.h                        |   15 +
 drivers/gpu/drm/tegra/dsi.c                        |  971 +++++++++++
 drivers/gpu/drm/tegra/dsi.h                        |  134 ++
 drivers/gpu/drm/tegra/fb.c                         |   45 +-
 drivers/gpu/drm/tegra/gem.c                        |  183 ++-
 drivers/gpu/drm/tegra/gem.h                        |    9 +-
 drivers/gpu/drm/tegra/gr3d.c                       |   22 +-
 drivers/gpu/drm/tegra/hdmi.c                       |   78 +-
 drivers/gpu/drm/tegra/mipi-phy.c                   |  138 ++
 drivers/gpu/drm/tegra/mipi-phy.h                   |   65 +
 drivers/gpu/drm/tegra/output.c                     |   51 +-
 drivers/gpu/drm/tegra/rgb.c                        |   47 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |    6 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |    2 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    6 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |   32 +-
 drivers/gpu/drm/ttm/ttm_lock.c                     |    8 -
 drivers/gpu/drm/ttm/ttm_object.c                   |   90 +-
 drivers/gpu/drm/ttm/ttm_tt.c                       |   27 +-
 drivers/gpu/drm/udl/udl_fb.c                       |   12 +-
 drivers/gpu/drm/via/via_dma.c                      |   12 +-
 drivers/gpu/drm/via/via_dmablit.c                  |   20 +-
 drivers/gpu/drm/via/via_drv.c                      |    2 +-
 drivers/gpu/drm/via/via_drv.h                      |    2 +-
 drivers/gpu/drm/via/via_irq.c                      |   10 +-
 drivers/gpu/drm/via/via_video.c                    |    8 +-
 drivers/gpu/drm/vmwgfx/Makefile                    |    2 +-
 drivers/gpu/drm/vmwgfx/svga3d_reg.h                |  718 ++++++++-
 drivers/gpu/drm/vmwgfx/svga_reg.h                  |   10 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c             |  182 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_context.c            |  531 ++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c             |    8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |  211 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |  213 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  872 +++++++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |    9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c               |  107 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c                |  160 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c      |   15 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c              |   39 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c                |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   38 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c                |  652 ++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |  195 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |  441 +++++
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |  471 +++++-
 drivers/gpu/host1x/Kconfig                         |    2 +-
 drivers/gpu/host1x/Makefile                        |    4 +-
 drivers/gpu/host1x/bus.c                           |    2 +
 drivers/gpu/host1x/channel.c                       |    5 +
 drivers/gpu/host1x/debug.c                         |   13 +-
 drivers/gpu/host1x/dev.c                           |   28 +-
 drivers/gpu/host1x/dev.h                           |    2 +
 drivers/gpu/host1x/hw/host1x02.c                   |    4 +-
 drivers/gpu/host1x/hw/host1x02_hardware.h          |  142 ++
 drivers/gpu/host1x/hw/host1x04.c                   |   42 +
 drivers/gpu/host1x/hw/host1x04.h                   |   26 +
 drivers/gpu/host1x/hw/host1x04_hardware.h          |  142 ++
 drivers/gpu/host1x/hw/hw_host1x02_uclass.h         |    6 +
 drivers/gpu/host1x/hw/hw_host1x04_channel.h        |  121 ++
 drivers/gpu/host1x/hw/hw_host1x04_sync.h           |  243 +++
 drivers/gpu/host1x/hw/hw_host1x04_uclass.h         |  181 +++
 drivers/gpu/host1x/hw/intr_hw.c                    |    1 -
 drivers/gpu/host1x/job.c                           |    6 +
 drivers/gpu/host1x/mipi.c                          |  275 ++++
 drivers/gpu/host1x/syncpt.c                        |    9 +
 drivers/i2c/busses/i2c-tegra.c                     |   13 +-
 drivers/input/keyboard/tegra-kbc.c                 |   13 +-
 drivers/pci/host/pci-tegra.c                       |   53 +-
 drivers/spi/Kconfig                                |    3 +
 drivers/spi/spi-tegra114.c                         |   66 +-
 drivers/spi/spi-tegra20-sflash.c                   |   18 +-
 drivers/spi/spi-tegra20-slink.c                    |   66 +-
 drivers/staging/imx-drm/imx-drm-core.c             |    3 +-
 drivers/staging/nvec/nvec.c                        |   11 +-
 drivers/staging/nvec/nvec.h                        |    5 +-
 drivers/tty/serial/serial-tegra.c                  |   38 +-
 drivers/usb/host/ehci-tegra.c                      |   14 +-
 drivers/video/fbmem.c                              |   31 +-
 drivers/video/omap2/dss/dispc.c                    |    1 -
 include/drm/drmP.h                                 |   81 +-
 include/drm/drm_agpsupport.h                       |   33 +-
 include/drm/drm_crtc.h                             |   30 +-
 include/drm/drm_crtc_helper.h                      |    4 +-
 include/drm/drm_dp_helper.h                        |   35 +-
 include/drm/drm_mipi_dsi.h                         |  158 ++
 include/drm/drm_os_linux.h                         |   37 -
 include/drm/drm_panel.h                            |   82 +
 include/drm/ttm/ttm_bo_driver.h                    |    9 +
 include/drm/ttm/ttm_object.h                       |   18 +-
 include/dt-bindings/clock/tegra114-car.h           |    8 +-
 include/dt-bindings/clock/tegra124-car.h           |  341 ++++
 include/dt-bindings/clock/tegra20-car.h            |    2 +-
 include/dt-bindings/clock/tegra30-car.h            |   12 +-
 include/linux/clk/tegra.h                          |    7 -
 include/linux/dmaengine.h                          |    9 +
 include/linux/fb.h                                 |    4 +-
 include/linux/host1x.h                             |    6 +
 include/linux/tegra-powergate.h                    |   55 +-
 include/sound/dmaengine_pcm.h                      |   10 +
 include/uapi/drm/drm.h                             |    1 -
 include/uapi/drm/i915_drm.h                        |   21 +-
 include/uapi/drm/radeon_drm.h                      |    2 +
 include/uapi/drm/vmwgfx_drm.h                      |  260 +++
 sound/soc/soc-devres.c                             |   41 +
 sound/soc/soc-generic-dmaengine-pcm.c              |   56 +-
 sound/soc/tegra/Kconfig                            |    2 +
 sound/soc/tegra/tegra20_ac97.c                     |   11 -
 sound/soc/tegra/tegra20_i2s.c                      |   20 +-
 sound/soc/tegra/tegra30_ahub.c                     |  138 +-
 sound/soc/tegra/tegra30_ahub.h                     |   11 +-
 sound/soc/tegra/tegra30_i2s.c                      |   97 +-
 sound/soc/tegra/tegra30_i2s.h                      |    3 +
 sound/soc/tegra/tegra_pcm.c                        |   17 +-
 sound/soc/tegra/tegra_pcm.h                        |    5 +
 599 files changed, 42355 insertions(+), 15446 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
 create mode 100644 Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt
 create mode 100644 Documentation/devicetree/bindings/mipi/nvidia,tegra114-mipi.txt
 create mode 100644 Documentation/devicetree/bindings/panel/auo,b101aw03.txt
 create mode 100644 Documentation/devicetree/bindings/panel/chunghwa,claa101wa01a.txt
 create mode 100644 Documentation/devicetree/bindings/panel/chunghwa,claa101wb03.txt
 create mode 100644 Documentation/devicetree/bindings/panel/panasonic,vvx10f004b00.txt
 create mode 100644 Documentation/devicetree/bindings/panel/samsung,ltn101nt05.txt
 create mode 100644 Documentation/devicetree/bindings/panel/simple-panel.txt
 create mode 100644 drivers/clk/tegra/clk-id.h
 create mode 100644 drivers/clk/tegra/clk-tegra-audio.c
 create mode 100644 drivers/clk/tegra/clk-tegra-fixed.c
 create mode 100644 drivers/clk/tegra/clk-tegra-periph.c
 create mode 100644 drivers/clk/tegra/clk-tegra-pmc.c
 create mode 100644 drivers/clk/tegra/clk-tegra-super-gen4.c
 create mode 100644 drivers/clk/tegra/clk-tegra124.c
 create mode 100644 drivers/gpu/drm/bochs/Kconfig
 create mode 100644 drivers/gpu/drm/bochs/Makefile
 create mode 100644 drivers/gpu/drm/bochs/bochs.h
 create mode 100644 drivers/gpu/drm/bochs/bochs_drv.c
 create mode 100644 drivers/gpu/drm/bochs/bochs_fbdev.c
 create mode 100644 drivers/gpu/drm/bochs/bochs_hw.c
 create mode 100644 drivers/gpu/drm/bochs/bochs_kms.c
 create mode 100644 drivers/gpu/drm/bochs/bochs_mm.c
 create mode 100644 drivers/gpu/drm/drm_mipi_dsi.c
 create mode 100644 drivers/gpu/drm/drm_panel.c
 create mode 100644 drivers/gpu/drm/msm/hdmi/hdmi_phy_8x74.c
 rename drivers/gpu/drm/msm/{ => mdp}/mdp4/mdp4.xml.h (94%)
 rename drivers/gpu/drm/msm/{ => mdp}/mdp4/mdp4_crtc.c (96%)
 rename drivers/gpu/drm/msm/{ => mdp}/mdp4/mdp4_dtv_encoder.c (98%)
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp4/mdp4_irq.c
 rename drivers/gpu/drm/msm/{ => mdp}/mdp4/mdp4_kms.c (89%)
 rename drivers/gpu/drm/msm/{ => mdp}/mdp4/mdp4_kms.h (79%)
 rename drivers/gpu/drm/msm/{ => mdp}/mdp4/mdp4_plane.c (98%)
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_irq.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.h
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp_common.xml.h
 rename drivers/gpu/drm/msm/{mdp4/mdp4_format.c => mdp/mdp_format.c} (85%)
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp_kms.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp_kms.h
 delete mode 100644 drivers/gpu/drm/msm/mdp4/mdp4_irq.c
 create mode 100644 drivers/gpu/drm/msm/msm_iommu.c
 create mode 100644 drivers/gpu/drm/msm/msm_kms.h
 create mode 100644 drivers/gpu/drm/msm/msm_mmu.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nv108.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxnv108.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/gpcnv108.fuc5
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/gpcnv108.fuc5.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/hubnv108.fuc5
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/hubnv108.fuc5.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv108.c
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/ramcfg.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bar/priv.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/ramcfg.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/nv50.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/nv84.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/nv98.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/nvaf.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/instmem/priv.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/pwr/fuc/i2c_.fuc
 create mode 100644 drivers/gpu/drm/panel/Kconfig
 create mode 100644 drivers/gpu/drm/panel/Makefile
 create mode 100644 drivers/gpu/drm/panel/panel-simple.c
 create mode 100644 drivers/gpu/drm/tegra/dsi.c
 create mode 100644 drivers/gpu/drm/tegra/dsi.h
 create mode 100644 drivers/gpu/drm/tegra/mipi-phy.c
 create mode 100644 drivers/gpu/drm/tegra/mipi-phy.h
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
 create mode 100644 drivers/gpu/host1x/hw/host1x02_hardware.h
 create mode 100644 drivers/gpu/host1x/hw/host1x04.c
 create mode 100644 drivers/gpu/host1x/hw/host1x04.h
 create mode 100644 drivers/gpu/host1x/hw/host1x04_hardware.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x04_channel.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x04_sync.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x04_uclass.h
 create mode 100644 drivers/gpu/host1x/mipi.c
 create mode 100644 include/drm/drm_mipi_dsi.h
 create mode 100644 include/drm/drm_panel.h
 create mode 100644 include/dt-bindings/clock/tegra124-car.h
--29444707-1942971507-1391050197=:13810--
