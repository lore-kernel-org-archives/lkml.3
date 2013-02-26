Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320Ab3BZAFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 19:05:38 -0500
Received: from gir.skynet.ie ([193.1.99.77]:33271 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758303Ab3BZAFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:05:33 -0500
Date: Tue, 26 Feb 2013 00:05:30 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm merge for 3.9-rc1
Message-ID: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1876484047-1361837130=:24684"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1876484047-1361837130=:24684
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

This is the main drm pull for the 3.9-rc1 merge, and my chance to have my 
email published verbatim as an article by the worst news site ever.

So up front, this has a massive merge conflict in 
drivers/gpu/drm/radeon/evergreen_cs.c I've fixed it up in drm-next-merged 
in the same tree, I fixed up some small ordering issues in my merge as 
well, however they aren't important if you want the fun of doing a major 
conflict resolution.

Highlights:
TI LCD controller KMS driver
TI OMAP KMS driver merged from staging
drop gma500 stub driver
the fbcon locking fixes
the vgacon dirty like zebra fix.
open firmware videomode and hdmi common code helpers
major locking rework for kms object handling - pageflip/cursor won't block on polling anymore!
fbcon helper and prime helper cleanups

i915: all over the map, haswell power well enhancements, valleyview macro horrors cleaned up, killing lots of legacy GTT
code,
radeon: CS ioctl unification, deprecated UMS support, gpu reset rework, VM fixes
nouveau: reworked thermal code, external dp/tmds encoder support (anx9805), fences sleep instead of polling, 
exynos: all over the driver fixes.

Dave.

The following changes since commit 1589a3e7777631ff56dd58cd7dcdf275185e62b5:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2013-02-06 08:36:12 +1100)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux.git drm-next

for you to fetch changes up to 28ee46184fc64591e286fa0355845e09c39e2a84:

  Merge branch 'drm/hdmi-for-3.9' of git://anongit.freedesktop.org/tegra/linux into drm-next (2013-02-24 12:39:42 +1000)

----------------------------------------------------------------

Aaron Plattner (3):
      drm: add prime helpers
      drm/nouveau: use prime helpers
      drm/radeon: use prime helpers

Ajay Kumar (1):
      drm/exynos: Add device tree based discovery support for G2D

Alan Cox (1):
      fb: rework locking to fix lock ordering on takeover

Alex Deucher (29):
      drm/radeon: add additional reset flags
      drm/radeon: add a bios scratch asic hung helper
      drm/radeon: rework GPU reset on r6xx/r7xx
      drm/radeon: rework GPU reset on evergreen
      drm/radeon: rework GPU reset on cayman/TN
      drm/radeon: rework GPU reset on cayman/TN
      drm/radeon: use status regs to determine what to reset (6xx/7xx)
      drm/radeon: use status regs to determine what to reset (evergreen)
      drm/radeon: use status regs to determine what to reset (cayman)
      drm/radeon: use status regs to determine what to reset (si)
      drm/radeon: halt engines before disabling MC (6xx/7xx)
      drm/radeon: halt engines before disabling MC (evergreen)
      drm/radeon: halt engines before disabling MC (cayman/TN)
      drm/radeon: halt engines before disabling MC (si)
      drm/radeon: use the reset mask to determine if rings are hung
      drm/radeon: don't reset the MC on IGPs/APUs
      drm/radeon: use IBs for VM page table updates v2
      drm/radeon: switch back to using the DMA ring for VM PT updates
      drm/radeon: add Oland chip family
      drm/radeon: fill in gpu init for Oland
      drm/radeon: add ucode loading support for Oland
      drm/radeon: radeon-asic updates for Oland
      drm/radeon: add Oland pci ids
      drm/radeon/dce6: fix display powergating
      drm/radeon: fix multi-head power profile stability on BTC+ asics
      drm/radeon: remove overzealous warning in hdmi handling
      drm/radeon: add a asic callback to get the xclk
      drm/radeon: switch get_gpu_clock() to a callback (v2)
      drm/radeon: properly validate the atpx interface

Andy Gross (2):
      drm/omap: Add PM capabilities
      drm/omap: Add OMAP5 support

Ben Hutchings (1):
      nouveau: ACPI support depends on X86 and X86_PLATFORM_DEVICES

Ben Skeggs (55):
      nvd0/therm: implement more appropriate pwm fan control functions
      drm/nouveau/therm: fix various style issues, make more consistent
      drm/nouveau/therm: collect fan tach info in common fan constructor
      drm/nva3/therm: add support for hardware fan tachometer
      drm/nvd0/therm: add support for hardware fan tachometer
      drm/nouveau/therm: add interfaces to allow forcing off pwm fan control
      drm/nouveau/therm: cleanly separate pwm control logic from therm
      drm/nvc0/bus: report useful data on mmio fault
      drm/nouveau/therm: better transitions and debug logging
      drm/nouveau/hwmon: s/fan0/fan1/
      drm/nouveau/hwmon: create hwmon attributes under hwmon device in sysfs
      drm/nouveau: remove legacy vbios type detection
      drm/nouveau: remove some more unnecessary legacy bios code
      drm/nouveau/bios: add support for parsing xpio table data
      drm/nouveau/bios: rename DCB_GPIO_PWM_FAN to DCB_GPIO_FAN
      drm/nouveau/therm: don't try pwm/toggle control if GPIO_FAN is input
      drm/nv50/disp: fix missing sor modectrl sync flags
      drm/nouveau/fifo/nvc0: improve interrupt handler somewhat
      drm/nouveau/core: basic event interface between core and drm
      drm/nouveau/disp/nv04: implement a base display object class
      drm/nouveau/disp: port vblank handling to event interface
      drm/nouveau/fifo/nvc0-: use interrupt 31 as an event trigger
      drm/nouveau/fifo/nv84: support user event trigger
      drm/nouveau/fifo/nvc0: bash some magic reg to make uevent interrupt work
      drm/nouveau/fence/nv84-: put processes to sleep while waiting on fences
      drm/nouveau/drm: store full dcb gpio function data in connector
      drm/nouveau/gpio: pass number of on-die gpio lines to base
      drm/nouveau/gpio: use event interfaces for interrupt signalling
      drm/nouveau/gpio/nve0: interrupt regs moved on kepler apparently
      drm/nv84/fence: access fences with full virtual address, not offset
      drm/nv84-/fence: abstract class emit/sync functions to virt+sequence
      drm/nv17/fence: split from nv10 code
      drm/nouveau/fence: make internal hooks part of the context
      drm/nv84-/fence: prepare for emit/sync support of sysram sequences
      drm/nv50/graph: avoid touching 400724, it doesn't exist
      drm/nouveau/i2c: handle i2c/aux mux outside of port lookup function
      drm/nouveau: store i2c port pointer directly in nouveau_encoder
      drm/nouveau/bios: parse external transmitter type if off-chip
      drm/nouveau/i2c: fix a bit of a thinko in nv_wri2cr helper functions
      drm/nouveau/i2c: aux channels not necessarily on nvio
      drm/nouveau/i2c: extend type to 16-bits, add lookup-by-type function
      drm/nouveau/bios: store a type/mask hash in parsed dcb data
      drm/nv50/devinit: reverse the logic for running encoder init scripts
      drm/nv50-/disp: 0x0000 is a valid udisp config value
      drm/nouveau/i2c: create proper chipset-specific class implementations
      drm/nv50-/disp: handle supervisor tasks from workqueue
      drm/nv50-/disp: move DP link training to core and train from supervisor
      drm/nv50-/kms: remove unnecessary wait-for-completion points
      drm/nv50-/disp: initial work towards supporting external encoders
      drm/nv50-/disp: initial supervisor support for off-chip encoders
      drm/nv50: initial kms support for off-chip TMDS/DP encoders
      drm/nouveau/i2c: add support for ddc/aux, and dp link training on anx9805
      drm/nv50/disp: handle multiple actions from one set of supervisor intrs
      drm/nvd0/disp: handle multiple actions from one set of supervisor intrs
      drm/nv50-/kms: remove UPDATE methods after each encoder disconnect

Ben Widawsky (28):
      drm/i915: BUG() if fences are used on unsupported platform
      drm/i915: Bug on unsupported swizzled platforms
      drm/i915: Missed conversion to gtt_pte_t
      drm/i915: Move even more gtt code to i915_gem_gtt
      drm/i915: Move GSM mapping into dev_priv
      drm/i915: Make GSM void
      drm/i915: Kill gtt_end
      drm/i915: Mappable_end can't ever be > end
      drm/i915: Remove gtt_mappable_total
      drm/i915: Create a gtt structure
      drm/i915: Remove use on gma_bus_addr on gen6+
      drm/i915: Remove use of gtt_mappable_entries
      drm/i915: Cut out the infamous ILK w/a from AGP layer
      drm/i915: Remove scratch page from shared
      drm/i915: Needs_dmar, not
      agp/intel: Add gma_bus_addr
      drm/i915: Implement WaVSRefCountFullforceMissDisable
      drm/i915: Error state should print /sys/kernel/debug
      drm/i915: Add probe and remove to the gtt ops
      drm/i915: remove intel_gtt structure
      drm/i915: Reclaim GTT space for failed PPGTT
      drm/i915: Fix CAGF for HSW
      drm/i915: Fix RC6VIDS encode/decode
      drm/i915: Clarify HW context size logic
      drm/i915: Fix gen2 mappable calculations
      drm/i915: Extract ring init from hw_init
      drm/i915/ctx: Remove bad invariant
      drm/i915: Print the hw context status is debugfs

Bjorn Helgaas (4):
      drm/pci: Use the standard #defines for PCIe Link Capability bits
      drm/pci: Set all supported speeds in speed cap mask for pre-3.0 devices
      drm/pci: Use PCI Express Capability accessors
      drm/pci: define drm_pcie_get_speed_cap_mask() only when CONFIG_PCI=y

Borislav Petkov (1):
      x86/intel/cacheinfo: Shut up annoying warning

Carsten Emde (1):
      drm: Load EDID: Explain better how to write your own EDID firmware

Changlong Xie (1):
      drm/i915: gen6_gmch_remove can be static

Chris Metcalf (1):
      drm: fix compile failure by including <linux/swiotlb.h>

Chris Wilson (32):
      drm/i915/debugfs: Prune a couple of superfluous leading zeros from bo domains
      drm: Introduce drm_mm_create_block()
      drm: Introduce an iterator over holes in the drm_mm range manager
      drm/i915: Fix detection of base of stolen memory
      drm/i915: Avoid clearing preallocated regions from the GTT
      drm/i915: Delay allocation of stolen space for FBC
      drm/i915: Allow objects to be created with no backing pages, but stolen space
      drm/i915: Support readback of stolen objects upon error
      drm/i915: Introduce i915_gem_object_create_stolen()
      drm/i915: Allocate fbcon from stolen memory
      drm/i915: Allocate ringbuffers from stolen memory
      drm/i915: Allocate overlay registers from stolen memory
      drm/i915: Use a slab for object allocation
      drm/i915: Tighten the checks for invalid relocation domains
      drm/i915: Remove check for conflicting relocation write-domains
      drm/i915: Reduce memory pressure during shrinker by preallocating swizzle pages
      drm/i915: Open-code i915_gpu_idle() for handling seqno wrapping
      drm/i915: Access to snooped system memory through the GTT is incoherent
      drm/i915: Clear the stolen fb before enabling
      drm/i915: Return the real error code from intel_set_mode()
      drm/i915: Add a debug interface to forcibly evict and shrink our object caches
      drm/i915: Bail if we attempt to allocate pages for a purged object
      drm/i915: Mark a temporary allocation for copy-from-user as such
      drm/i915: Take the handle idr spinlock once for looking up the exec objects
      drm/i915: Move the execbuffer objects list from the stack into the tracker
      drm/i915: Use the reloc.handle as an index into the execbuffer array
      drm/i915: Only insert the mb() before updating the fence parameter
      drm/i915: Only apply the mb() when flushing the GTT domain during a finish
      drm/i915: Only run idle processing from i915_gem_retire_requests_worker
      drm/udl: Inline memcmp() for RLE compression of xfer
      drm/i915: Disable WC PTE updates to w/a buggy IOMMU on ILK
      drm/i915: Handle untiled planes when computing their offsets

Christian König (1):
      drm/radeon: Deprecate UMS support v2

Cong Ding (2):
      staging: omapdrm/omap_gem_dmabuf.c: fix memory leakage
      drm/nouveau: remove unnecessary null pointer check from nouveau_fence_new

Damien Lespiau (10):
      drm/i915: Fix dieing -> dying typo
      drm/i915: Cleanup SHOTPLUG_CTL status bits definitions
      drm/i915/hdmi: Read the HPD status before trying to read the EDID
      drm/i915/dp: Read the HPD status before trying to read the DPCD
      drm/i915/dp: Log the DPCD only if we have successfully retrieved one
      drm/i915: Implement ibx_digital_port_connected() for IBX
      drm/i915: Remove stale comment about intel_dp_detect()
      drm/i915: Fix a typo in a intel_modeset_stage_output_state() comment
      drm/i915: Preserve the FDI line reversal override bit on CPT
      drm/i915: Preserve the DDI link reversal configuration

Dan Carpenter (1):
      drm/nouveau/disp: sizeof() wrong pointer

Daniel Kurtz (1):
      drm: make frame duration time calculation more precise

Daniel Vetter (121):
      drm/i915: remove duplicate register #defines
      drm/i915: add encoder->pre_pll_enable callback
      drm/i915: replace ad-hoc dual-link lvds checks
      drm/i915: move is_dual_link_lvds to intel_lvds.c
      drm/i915: track is_dual_link in intel_lvds
      drm/i915: add intel_lvds->reg
      drm/i915: move intel_update_lvds to intel_lvds->pre_pll_enable
      drm/i915: enable intel_lvds->pre_pll_enable for ilk+, too
      drm/i915: simplify shmem pwrite/pread slowpath handling
      drm/i915: optimize the shmem_pwrite slowpath handling
      drm/i915: optimize ilk/snb irq handler
      drm/i915: fixup sparse warnings
      drm/i915: haswell has the same irq handlers as ivb
      drm/i915: don't handle PIPE_LEGACY_BLC_EVENT_STATUS on vlv
      drm/i915: setup the hangcheck timer early
      drm/i915: reorder setup sequence to have irqs for output setup
      drm/i915: extract gmbus_wait_hw_status
      drm/i915: wire up gmbus irq handler
      drm/i915: use the gmbus irq for waits
      drm/i915: use gmbus irq to wait for gmbus idle
      drm/i915: wire up do aux channel done interrupt
      drm/i915: irq-drive the dp aux communication
      drm/i915: use _NOTRACE for gmbus/dp aux wait loops
      drm/i915: rip out pre-DDI stuff from haswell_crtc_mode_set
      drm/i915: move set_pll_edp to intel_dp.c
      drm/i915: rip out pre-production ilk cpu edp w/a
      drm/i915: use wait_for_vblank instead of msleep(17)
      drm/i915: WARN on !crtc in intel_dp_link_down
      drm/i915: drop unnecessary clearing of pch dp transcoder timings
      drm/i915: extract common link_m_n helpers
      drm/i915: Fixup hpd irq register setup ordering
      drm/i915: rework locking for intel_dpio|sbi_read|write
      drm/i915: clean up PIPECONF bpc #defines
      drm/i915: fixup overlay stolen memory leak
      drm/i915: wake up all pageflip waiters
      drm/i915: Allow userspace to hint that the relocations were known
      drm/i915: move dev_priv->mm out of line
      drm/i915: extract hangcheck/reset/error_state state into substruct
      drm/i915: move wedged to the other gpu error handling stuff
      drm/i915: fix reset handling in the throttle ioctl
      drm/i915: clear up wedged transitions
      drm: review locking rules in drm_crtc.c
      drm/doc: integrate drm_crtc.c kerneldoc
      drm/<drivers>: reorder framebuffer init sequence
      drm/vmwgfx: reorder framebuffer init sequence
      drm/gma500: move fbcon restore to lastclose
      drm/nouveau: protect evo_wait/evo_kick sections with a channel mutex
      drm/nouveau: try to protect nbo->pin_refcount
      drm/<drivers>: Unified handling of unimplemented fb->create_handle
      drm: encapsulate crtc->set_config calls
      drm: add drm_modeset_lock|unlock_all
      drm/i915: use drm_modeset_lock_all
      drm/gma500: use drm_modeset_lock_all
      drm/ast: use drm_modeset_lock_all
      drm/shmobile: use drm_modeset_lock_all
      drm/vmwgfx: use drm_modeset_lock_all
      omapdrm: use modeset_lock_all
      drm: add per-crtc locks
      drm: only take the crtc lock for ->cursor_set
      drm: only take the crtc lock for ->cursor_move
      drm: revamp locking around fb creation/destruction
      drm: create drm_framebuffer_lookup
      drm: revamp framebuffer cleanup interfaces
      drm: reference framebuffers which are on the idr
      drm: nest modeset locks within fpriv->fbs_lock
      drm: push modeset_lock_all into ->fb_create driver callbacks
      drm: don't take modeset locks in getfb ioctl
      drm: fb refcounting for dirtyfb_ioctl
      drm: refcounting for sprite framebuffers
      drm: refcounting for crtc framebuffers
      drm/i915: dump refcount into framebuffer debugfs file
      drm/vmwgfx: add proper framebuffer refcounting
      drm: optimize drm_framebuffer_remove
      drm: only grab the crtc lock for pageflips
      drm: don't hold crtc mutexes for connector ->detect callbacks
      drm/doc: updates for new framebuffer lifetime rules
      drm/fb_helper: check whether fbcon is bound
      drm/i915: create a race-free reset detection
      drm/i915: clarify concurrent hang detect/gpu reset consistency
      drm/i915: fixup sbi_read/write locking
      drm/i915: fixup per-crtc locking in intel_release_load_detect_pipe
      drm/i915: move modeset checks out of save/restore_modeset_reg
      drm/i915: extract ums suspend/resume into i915_ums.c
      drm/i915: dont save/restore VGA state for kms
      drm/i915: move DP save/restore into i915_ums.c
      drm/i915: vfuncs for gtt_clear_range/insert_entries
      drm/i915: vfuncs for ppgtt
      drm/i915: pte_encode is gen6+
      drm/i915: extract hw ppgtt setup/cleanup code
      drm/i915: kill cargo-culted locking from power well code
      drm/i915: don't run hsw power well code on !hsw
      drm/i915: dynamic Haswell display power well support
      Revert "drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S"
      drm: review locking for drm_fb_helper_restore_fbdev_mode
      drm/fb-helper: kill drm_fb_helper_restore
      drm/fb-helper: unexport drm_fb_helper_panic
      drm/fb-helper: unexport drm_fb_helper_single_fb_probe
      drm/tegra: don't set up initial fbcon config twice
      drm/fb-helper: don't disable everything in initial_config
      drm/i915: rip out helper->disable noop functions
      drm/fb-helper: fixup set_config semantics
      drm/fb-helper: directly call set_par from the hotplug handler
      drm/fb-helper: streamline drm_fb_helper_single_fb_probe
      drm/<drivers>: simplify ->fb_probe callback
      drm/fb-helper: improve kerneldoc
      drm/fb-helper: don't sleep for screen unblank when an oopps is in progress
      drm/fb-helper: remove unused members of struct drm_fb_helper
      drm/i915: write backlight harder
      drm/i915: unify HDMI/DP hpd definitions
      omapdrm: only take crtc->mutex in crtc callbacks
      omapdrm: simplify locking in the fb debugfs file
      drm/cma-helper: fixup compilation
      drm: Don't set the plane->fb to NULL on successfull set_plane
      drm/cma-helper: fixup compilation
      drm: Don't set the plane->fb to NULL on successfull set_plane
      drm/i915: detect wrong MCH watermark values
      drm/i915: remove bogus mutex_unlock from error-path
      drm/i915: Use HAS_L3_GPU_CACHE in i915_gem_l3_remap
      drm/i915: inverted brightness quirk for Acer Aspire 4736Z
      intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets
      drm/i915: Revert hdmi HDP pin checks

Dave Airlie (27):
      Merge tag 'drm-intel-next-2012-12-21' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-kms-locking' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      vgacon/vt: clear buffer attributes when we load a 512 character font (v2)
      fbcon: don't lose the console font across generic->chip driver switch
      drm/usb: bind driver to correct device
      drm/udl: make usage as a console safer
      Merge tag 'drm-intel-next-2013-02-01' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      drm/udl: disable fb_defio by default
      fbcon: fix locking harder
      Revert "Revert "console: implement lockdep support for console_lock""
      Merge branch 'fbcon-locking-fixes' of ssh://people.freedesktop.org/~airlied/linux into drm-next
      Merge branch 'console-fixes' into drm-next
      Merge branch 'udl-fixes' into drm-next
      Merge tag 'of_videomode_helper' of git://git.pengutronix.de/git/str/linux into drm-next
      Merge branch 'drm-next-3.9' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'for-airlied' of git://people.freedesktop.org/~mlankhorst/linux into drm-next
      Merge branch 'drm-fb-helper' of git://people.freedesktop.org/~danvet/drm into drm-next
      Merge branch 'omapdrm-next' of git://people.freedesktop.org/~robclark/linux into drm-next
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-next-3.9' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'tilcdc-next' of git://people.freedesktop.org/~robclark/linux into drm-next
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge branch 'drm/tegra-for-3.9' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm/hdmi-for-3.9' of git://anongit.freedesktop.org/tegra/linux into drm-next

Dexuan Cui (1):
      drm/i915: Remove duplicate and unused register #defines in i915_reg.h

Egbert Eich (1):
      drm/i915: Remove pch_rq_mask from struct drm_i915_private.

Emil Velikov (1):
      drm/nouveau: set legacy bios data before parsing the structure

H. Peter Anvin (1):
      x86, doc: Boot protocol 2.12 is in 3.8

Ilija Hadzic (12):
      drm/radeon: remove unecessary assignment
      drm/radeon: remove unused prototype from radeon_cs
      drm/radeon: fix formatting
      drm/radeon: implement common cs packet parse function
      drm/radeon: use common cs packet parse function
      drm/radeon: factor out cs_next_is_pkt3_nop function
      drm/radeon: refactor vline packet parsing function
      drm/radeon: add a check to wait_reg_mem command
      drm/radeon: rename r100_cs_dump_packet to radeon_cs_dump_packet
      drm/radeon: pull out common next_reloc function
      drm/radeon: use common next_reloc function
      drm/radeon: consolidate redundant macros and constants

Imre Deak (4):
      drm/i915: merge get_gtt_alignment/get_unfenced_gtt_alignment()
      drm/i915: merge {i965, sandybridge}_write_fence_reg()
      drm/i915: use gtt_get_size() instead of open coding it
      drm/i915: don't clflush gem objects in stolen memory

Inki Dae (2):
      drm/exynos: fix iommu address allocation order
      drm/exynos: consider exception case to fb handle creation

Jan Beulich (1):
      x86-64: Replace left over sti/cli in ia32 audit exit code

Jani Nikula (4):
      drm/i915: add quirk to invert brightness on eMachines G725
      drm/i915: add quirk to invert brightness on eMachines e725
      drm/i915: add quirk to invert brightness on Packard Bell NCL20
      drm/i915: add missing \n to UTS_RELEASE in the error_state

Jerome Glisse (1):
      radeon/kms: cleanup async dma packet checking

Lee, Chun-Yi (1):
      gpu: remove gma500 stub driver

Luis R. Rodriguez (1):
      i915: convert struct spinlock to spinlock_t

Maarten Lankhorst (9):
      drm/vmwgfx: always use ttm_bo_is_reserved
      drm/nouveau: increase reservation sequence every retry
      drm/ttm: remove lru_lock around ttm_bo_reserve
      drm/ttm: cleanup ttm_eu_reserve_buffers handling
      drm/ttm: add ttm_bo_reserve_slowpath
      drm/ttm: use ttm_bo_reserve_slowpath_nolru in ttm_eu_reserve_buffers, v2
      drm/nouveau: use ttm_bo_reserve_slowpath in validate_init, v2
      drm/ttm: unexport ttm_bo_wait_unreserved
      drm: shut up invalid edid messages

Marcin Slusarz (20):
      drm/nouveau: split fifo interrupt handler
      drm/nouveau: use pr_cont
      drm/nouveau: prepare for reporting channel owner
      drm/nouveau: report channel owner in error messages
      drm/nouveau: share fence structures between nv10+ and nv50 implementations
      drm/nouveau: mark nv_printk_ as printf-like function
      drm/nouveau/bios: tiny debugging messages fixes
      drm/nouveau: quiet static-related sparse noise
      drm/nouveau/fan: fix selection of fan speed when fan->get returns an error
      drm/nvc0/graph: remove redundant null checks
      drm/nouveau: use drm_property_create_range helper
      drm/nouveau: use kmemdup for edid allocation/copying
      drm/nouveau: handle backlight_device_register failure
      drm/nouveau/therm: always initialize alarm_program_lock
      drm/nouveau: report channel owner in ioctl error paths
      drm/nouveau/therm: turn on fan only when threshold hit in positive direction
      drm/nv40/therm: reset temperature sensor on init
      drm/nouveau/therm: use workqueue to shutdown the machine
      drm/nouveau/therm: reduce stack usage of nouveau_therm_ic_ctor
      drm/nouveau: restore debugfs/vbios.rom support

Martin Peres (11):
      drm/nouveau/fan: add toggle fan support
      drm/nouveau/bios: parse fan bump/slow periods, and trip points
      drm/nouveau/fan: obey fan bump/slow periods as defined by vbios
      drm/nouveau/therm: implement automatic fan management
      drm/nouveau/pbus: add a PBUS subdev that hands IRQs to the right subdevs
      drm/nv41/bus: report useful data on mmio fault
      drm/nouveau/therm: implement support for temperature alarms
      drm/nouveau/hwmon: add missing alarm thresholds
      drm/nouveau/doc: document the sysfs thermal management interface
      drm/nouveau/therm: force a minimum hysteresis on temperature alarm thresholds
      drm/nouveau/fan: handle the cases where we are outside of the linear zone

Mika Kuoppala (14):
      drm/i915: Add debugfs entry to read/write next_seqno
      drm/i915: Fix debugfs seqno info print to use uint
      drm/i915: Split intel_ring_begin
      drm/i915: Add intel_ring_handle_seqno wrap
      drm/i915: Don't emit semaphore wait if wrap happened
      drm/i915: Set initial seqno value close to wrap boundary
      drm/i915: Introduce ring set_seqno
      drm/i915: Initialize hardware semaphore state on ring init
      drm/i915: Always clear semaphore mboxes on seqno wrap
      drm/i915: Introduce i915_gem_set_seqno()
      drm/i915: Make next_seqno debugs entry to use i915_gem_set_seqno
      drm/i915: use gem_set_seqno() on hardware init
      drm/i915: disable shared panel fitter for pipe
      drm/i915: clean up panel fitter handling in lvds

Patrik Jakobsson (3):
      drm/i915: Set i9xx lvds clock limits according to specifications
      drm/i915: Set i9xx sdvo clock limits according to specifications
      gma500: Fix n, m1 and m2 clock limits for sdvo and lvds

Paulo Zanoni (18):
      drm/i915: intel_prepare_ddi_buffers should be static
      drm/i915: remove Haswell code from ironlake_fdi_pll_enable
      drm/i915: add HAS_DDI check
      drm/i915: invert the log inside intel_prepare_ddi
      drm/i915: kill intel_dp_link_clock()
      drm/i915: be less verbose when handling gmbus/aux irqs
      drm/i915: check for the PCH when setting pch_transcoder
      drm/i915: remove leftover display.update_wm assignment
      drm/i915: add intel_dp_set_signal_levels
      drm/i915: don't save/restore DSPARB on gen5+
      drm/i915: fix intel_init_power_wells
      drm/i915: only disable enabled planes on intel_fb_restore_mode
      drm/i915: set TRANSCODER_EDP even earlier
      drm/i915: turn on the power well before suspending
      drm/i915: don't send DP "idle" pattern before "normal" on HSW PORT_A
      drm/i915: check the power down well on assert_pipe()
      drm/i915: add ibx_irq_postinstall
      drm: don't add inferred modes for monitors that don't support them

Peter Huewe (1):
      staging/omapdrm: Use kmemdup rather than duplicating its implementation

Rahul Sharma (3):
      drm/exynos: add display-mode-check operation to exynos_mixer_ops struct
      drm/exynos: implement display-mode-check callback in mixer driver
      drm/exynos: mixer: set correct mode for range of resolutions

Rob Clark (11):
      drm/i2c: give i2c it's own Kconfig
      drm/omap: move out of staging
      drm/omap: remove fbdev debug enter/leave hooks
      drm: small fix in drm_send_vblank_event()
      drm/cma: add debugfs helpers
      drm: i2c encoder helper wrappers
      drm/nouveau: use i2c encoder helper wrappers
      drm/tilcdc: add TI LCD Controller DRM driver (v4)
      drm/i2c: nxp-tda998x (v3)
      drm/tilcdc: add encoder slave (v2)
      drm/tilcdc: add support for LCD panels (v5)

Sachin Kamat (2):
      drm/i915: Remove duplicate inclusion of drm/drm_edid.h
      drm/exynos: Add missing braces around sizeof

Sean Paul (1):
      drm/exynos: hdmi: support extra resolutions using drm_display_mode timings

Stefan de Konink (1):
      drm/nouveau: Fix DPMS 1 on G4 Snowball, from snow white to coal black.

Steffen Trumtrar (7):
      viafb: rename display_timing to via_display_timing
      video: add display_timing and videomode
      video: add of helper for display timings/videomode
      fbmon: add videomode helpers
      fbmon: add of_videomode helpers
      drm_modes: add videomode helpers
      drm_modes: add of_videomode helpers

Takashi Iwai (1):
      fb: Yet another band-aid for fixing lockdep mess

Thierry Reding (18):
      drm: Allow vblank support without DRIVER_HAVE_IRQ
      drm: Remove duplicate drm_mode_cea_vic()
      drm: Move mode tables to drm_edid.c
      drm: Add some missing forward declarations
      video: Add generic HDMI infoframe helpers
      drm: Add HDMI infoframe helpers
      drm: Add EDID helper documentation
      drm/tegra: Use generic HDMI infoframe helpers
      drm/radeon: Use generic HDMI infoframe helpers
      drm: Add consistency check for page-flipping
      drm/tegra: Remove bogus tegra_framebuffer structure
      drm/tegra: Add plane support
      drm/tegra: Implement .mode_set_base()
      drm/tegra: Implement VBLANK support
      drm/tegra: Implement page-flipping support
      drm/tegra: Split DC_CMD_STATE_CONTROL register write
      drm/tegra: Fix color expansion
      drm/tegra: Add list of framebuffers to debugfs

Tim Gardner (2):
      i915: intel_set_mode: Reduce stack allocation from 500 bytes to 2 pointers
      drm/radeon: Avoid NULL pointer dereference from atom_index_iio() allocation failure

Tomas Janousek (1):
      drm/i915: don't prevent CPU idle states

Ville Syrjälä (46):
      drm/i915: Kill i915_gem_execbuffer_wait_for_flips()
      drm/i915: Fix SPRITE0_FLIP_DONE_INT_EN_VLV and SPRITE0_FLIPDONE_INT_STATUS_VLV
      drm/i915: Fix RGB color range property for PCH platforms
      drm/i915: Add "Automatic" mode for the "Broadcast RGB" property
      drm/edid: Add drm_rgb_quant_range_selectable()
      drm/i915: Provide the quantization range in the AVI infoframe
      drm/i915: Convert intel_hdmi to enum port
      drm/i915: Convert intel_dp to enum port
      drm/i915: Add display_display_mmio_offset to intel_device_info
      drm/i915: AUD_VID_DID needs an offset on VLV
      drm/i915: Per-pipe PP registers are for VLV only
      drm/i915: VLV_VIDEO_DIP_CTL is for VLV only
      drm/i915: PIPE M/N registers need an offset on VLV
      drm/i915: Primary plane registers need an offset on VLV
      drm/i915: Pipe registers need an offset on VLV
      drm/i915: Cursor registers need an offset on VLV
      drm/i915: VLV_DDL is VLV only and needs an offset
      drm/i915: DSPFW registers need an offset on VLV
      drm/i915: DPFLIPSTAT and DPINVGTT registers are VLV only and need an offset
      drm/i915: Panel fitter registers need an offset on VLV
      drm/i915: PORT_HOTPLUG registers need an offset on VLV
      drm/i915: Pipe timing registers need an offset on VLV
      drm/i915: Pipe palette registers need an offset on VLV
      drm/i915: FB_BLC_SELF_VLV is VLV only and needs an offset
      drm/i915: Make VLV_GUNIT_CLOCK_GATE register value more readable
      drm/i915: Spell out VLV_DISPLAY_BASE for interrupt registers
      drm/i915: DPIO registers are VLV only and need an offset
      drm/i915: GPIO/GMBUS registers need an offset on VLV
      drm/i915: Set display_mmio_offset for VLV
      drm/i915: PLL registers need an offset on VLV
      drm/i915: Always use adpa_reg
      drm/i915: VLV doesn't have SDVO
      drm/i915: Pass VLV_DISPLAY_BASE + reg to intel_{hdmi, dp}_init on VLV
      drm/i915: Include display_mmio_offset in sequencer index/data registers
      drm/i915: SWF screatch registers need an offset on VLV
      drm/i915: Introduce i915_vgacntrl_reg()
      drm/i915: Kill IS_DISPLAYREG()
      drm/i915: Set the SR01 "screen off" bit in i915_redisable_vga() too
      drm/i915: Fix sprite_scaling_enabled for multiple sprites
      drm/i915: Print the pipe control page GTT address
      drm/i915: Kill obj->pending_flip
      drm/i915: Don't wait for page flips if there was GPU reset
      drm: Fill depth/bits_per_pixel for C8 format
      drm: Use C8 instead of RGB332 when determining the format from depth/bpp
      drm/i915: Fix PIPE_CONTROL DW/QW write through global GTT on IVB+
      drm/i915: Implement pipe CSC based limited range RGB output

Wang Xingchao (1):
      drm/i915: HDMI/DP - ELD info refresh support for Haswell

Yasuaki Ishimatsu (1):
      GPU/i915: Fix acpi_bus_get_device() check in drivers/gpu/drm/i915/intel_opregion.c

YoungJun Cho (2):
      drm/exynos: fix wrong pointer access at vm close.
      drm/exynos: release resources properly when fb creation is failed.

Zhang Rui (1):
      i915: ignore lid open event when resuming

 Documentation/DocBook/drm.tmpl                     |   78 +-
 Documentation/EDID/HOWTO.txt                       |   27 +-
 .../devicetree/bindings/drm/tilcdc/panel.txt       |   59 +
 .../devicetree/bindings/drm/tilcdc/slave.txt       |   18 +
 .../devicetree/bindings/drm/tilcdc/tfp410.txt      |   21 +
 .../devicetree/bindings/drm/tilcdc/tilcdc.txt      |   21 +
 .../devicetree/bindings/video/display-timing.txt   |  109 ++
 Documentation/thermal/nouveau_thermal              |   81 ++
 drivers/char/agp/intel-gtt.c                       |  128 ++-
 drivers/gpu/Makefile                               |    2 +-
 drivers/gpu/drm/Kconfig                            |    8 +
 drivers/gpu/drm/Makefile                           |    2 +
 drivers/gpu/drm/ast/ast_drv.c                      |    4 +-
 drivers/gpu/drm/ast/ast_drv.h                      |    2 +
 drivers/gpu/drm/ast/ast_fb.c                       |   27 +-
 drivers/gpu/drm/ast/ast_main.c                     |   12 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c              |   27 +-
 drivers/gpu/drm/cirrus/cirrus_main.c               |   12 +-
 drivers/gpu/drm/drm_crtc.c                         |  816 ++++++++------
 drivers/gpu/drm/drm_edid.c                         |  843 +++++++++++++-
 drivers/gpu/drm/drm_edid_modes.h                   |  774 -------------
 drivers/gpu/drm/drm_encoder_slave.c                |   63 ++
 drivers/gpu/drm/drm_fb_cma_helper.c                |   95 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  310 ++++--
 drivers/gpu/drm/drm_fops.c                         |    1 +
 drivers/gpu/drm/drm_gem_cma_helper.c               |   21 +
 drivers/gpu/drm/drm_irq.c                          |   12 +-
 drivers/gpu/drm/drm_mm.c                           |   96 +-
 drivers/gpu/drm/drm_modes.c                        |   70 ++
 drivers/gpu/drm/drm_pci.c                          |   81 +-
 drivers/gpu/drm/drm_prime.c                        |  186 +++-
 drivers/gpu/drm/drm_usb.c                          |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_fb.c             |   55 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |   39 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   12 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |   33 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c           |   12 +
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h           |    5 +-
 drivers/gpu/drm/exynos/exynos_drm_iommu.h          |    2 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               | 1035 +++++++-----------
 drivers/gpu/drm/exynos/exynos_mixer.c              |   34 +-
 drivers/gpu/drm/gma500/framebuffer.c               |   43 +-
 drivers/gpu/drm/gma500/psb_device.c                |    8 +-
 drivers/gpu/drm/gma500/psb_drv.c                   |   14 +-
 drivers/gpu/drm/gma500/psb_intel_display.c         |   12 +-
 drivers/gpu/drm/i2c/Kconfig                        |   28 +
 drivers/gpu/drm/i2c/Makefile                       |    3 +
 drivers/gpu/drm/i2c/ch7006_drv.c                   |    2 +-
 drivers/gpu/drm/i2c/tda998x_drv.c                  |  906 +++++++++++++++
 drivers/gpu/drm/i915/Makefile                      |    1 +
 drivers/gpu/drm/i915/i915_debugfs.c                |  254 ++++-
 drivers/gpu/drm/i915/i915_dma.c                    |   94 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  131 +--
 drivers/gpu/drm/i915/i915_drv.h                    |  475 +++++---
 drivers/gpu/drm/i915/i915_gem.c                    |  516 ++++-----
 drivers/gpu/drm/i915/i915_gem_context.c            |   12 +-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c             |    5 +-
 drivers/gpu/drm/i915/i915_gem_evict.c              |    2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  333 +++---
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  645 ++++++-----
 drivers/gpu/drm/i915/i915_gem_stolen.c             |  305 ++++--
 drivers/gpu/drm/i915/i915_gem_tiling.c             |   33 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  370 ++++---
 drivers/gpu/drm/i915/i915_reg.h                    |  436 ++++----
 drivers/gpu/drm/i915/i915_suspend.c                |  540 +--------
 drivers/gpu/drm/i915/i915_ums.c                    |  503 +++++++++
 drivers/gpu/drm/i915/intel_crt.c                   |   46 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |   79 +-
 drivers/gpu/drm/i915/intel_display.c               |  975 +++++++----------
 drivers/gpu/drm/i915/intel_dp.c                    |  374 ++++---
 drivers/gpu/drm/i915/intel_drv.h                   |   41 +-
 drivers/gpu/drm/i915/intel_dvo.c                   |    1 -
 drivers/gpu/drm/i915/intel_fb.c                    |   55 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |  108 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |  103 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |  250 ++++-
 drivers/gpu/drm/i915/intel_modes.c                 |    6 +-
 drivers/gpu/drm/i915/intel_opregion.c              |    2 +-
 drivers/gpu/drm/i915/intel_overlay.c               |   24 +-
 drivers/gpu/drm/i915/intel_panel.c                 |   13 +-
 drivers/gpu/drm/i915/intel_pm.c                    |   95 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  113 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   11 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   67 +-
 drivers/gpu/drm/i915/intel_sprite.c                |   46 +-
 drivers/gpu/drm/i915/intel_tv.c                    |    4 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c               |   28 +-
 drivers/gpu/drm/mgag200/mgag200_main.c             |   16 +-
 drivers/gpu/drm/nouveau/Kconfig                    |   28 +-
 drivers/gpu/drm/nouveau/Makefile                   |   29 +-
 drivers/gpu/drm/nouveau/core/core/client.c         |   10 +
 drivers/gpu/drm/nouveau/core/core/enum.c           |   11 +-
 drivers/gpu/drm/nouveau/core/core/event.c          |  106 ++
 drivers/gpu/drm/nouveau/core/engine/copy/nva3.c    |    6 +-
 drivers/gpu/drm/nouveau/core/engine/crypt/nv84.c   |    8 +-
 drivers/gpu/drm/nouveau/core/engine/crypt/nv98.c   |    6 +-
 drivers/gpu/drm/nouveau/core/engine/disp/base.c    |   52 +
 drivers/gpu/drm/nouveau/core/engine/disp/dport.c   |  346 ++++++
 drivers/gpu/drm/nouveau/core/engine/disp/dport.h   |   78 ++
 drivers/gpu/drm/nouveau/core/engine/disp/nv04.c    |   33 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |  371 ++++---
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.h    |   37 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv84.c    |   12 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv94.c    |   24 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nva0.c    |    9 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nva3.c    |   24 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c    |  309 +++---
 drivers/gpu/drm/nouveau/core/engine/disp/nve0.c    |   17 +-
 .../gpu/drm/nouveau/core/engine/disp/piornv50.c    |  140 +++
 drivers/gpu/drm/nouveau/core/engine/disp/sornv50.c |   25 -
 drivers/gpu/drm/nouveau/core/engine/disp/sornv94.c |  153 +--
 drivers/gpu/drm/nouveau/core/engine/disp/sornvd0.c |   90 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/base.c    |   21 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nv04.c    |  187 ++--
 drivers/gpu/drm/nouveau/core/engine/fifo/nv50.c    |    5 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv84.c    |   22 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c    |  109 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |   64 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv04.c   |   16 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv10.c   |   16 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv20.c   |   15 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv40.c   |   16 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv50.c   |   53 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |   33 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nve0.c   |   44 +-
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv31.c    |    7 +-
 .../gpu/drm/nouveau/core/engine/software/nv50.c    |   40 +-
 .../gpu/drm/nouveau/core/engine/software/nvc0.c    |   29 +-
 drivers/gpu/drm/nouveau/core/include/core/class.h  |   44 +-
 drivers/gpu/drm/nouveau/core/include/core/client.h |    3 +-
 drivers/gpu/drm/nouveau/core/include/core/device.h |    1 +
 drivers/gpu/drm/nouveau/core/include/core/enum.h   |    3 +-
 drivers/gpu/drm/nouveau/core/include/core/event.h  |   36 +
 drivers/gpu/drm/nouveau/core/include/core/object.h |   12 +-
 drivers/gpu/drm/nouveau/core/include/core/printk.h |    3 +-
 drivers/gpu/drm/nouveau/core/include/engine/disp.h |   27 +-
 drivers/gpu/drm/nouveau/core/include/engine/fifo.h |    4 +
 .../gpu/drm/nouveau/core/include/engine/software.h |    4 +-
 .../gpu/drm/nouveau/core/include/subdev/bios/dcb.h |    3 +
 .../drm/nouveau/core/include/subdev/bios/gpio.h    |   11 +-
 .../gpu/drm/nouveau/core/include/subdev/bios/i2c.h |    2 +-
 .../drm/nouveau/core/include/subdev/bios/therm.h   |   16 +
 .../drm/nouveau/core/include/subdev/bios/xpio.h    |   19 +
 drivers/gpu/drm/nouveau/core/include/subdev/bus.h  |   41 +
 drivers/gpu/drm/nouveau/core/include/subdev/gpio.h |   39 +-
 drivers/gpu/drm/nouveau/core/include/subdev/i2c.h  |  127 ++-
 .../gpu/drm/nouveau/core/include/subdev/therm.h    |   37 +-
 .../gpu/drm/nouveau/core/include/subdev/timer.h    |    8 +
 drivers/gpu/drm/nouveau/core/os.h                  |    1 +
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c    |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c     |   32 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/extdev.c  |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/gpio.c    |   11 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c     |   15 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |   15 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/therm.c   |   28 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/xpio.c    |   76 ++
 drivers/gpu/drm/nouveau/core/subdev/bus/nv04.c     |   95 ++
 drivers/gpu/drm/nouveau/core/subdev/bus/nv31.c     |  112 ++
 drivers/gpu/drm/nouveau/core/subdev/bus/nv50.c     |  105 ++
 drivers/gpu/drm/nouveau/core/subdev/bus/nvc0.c     |  101 ++
 drivers/gpu/drm/nouveau/core/subdev/device/base.c  |    5 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nv04.c  |    7 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nv10.c  |   25 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nv20.c  |   13 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nv30.c  |   16 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nv40.c  |   50 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nv50.c  |   51 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c  |   43 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nve0.c  |   22 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv50.c |   14 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c      |   64 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/base.c    |  140 +--
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv10.c    |   40 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv50.c    |   45 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c    |   14 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c    |  131 +++
 drivers/gpu/drm/nouveau/core/subdev/gpio/priv.h    |   17 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/anx9805.c  |  279 +++++
 drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c      |  154 +--
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c     |  481 ++++----
 drivers/gpu/drm/nouveau/core/subdev/i2c/bit.c      |   18 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv04.c     |  143 +++
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv4e.c     |  135 +++
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv50.c     |  149 +++
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv50.h     |   32 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/nv94.c     |  285 +++++
 drivers/gpu/drm/nouveau/core/subdev/i2c/nvd0.c     |  124 +++
 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.c      |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c      |    1 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c      |    2 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c      |    2 +
 drivers/gpu/drm/nouveau/core/subdev/mxm/mxms.c     |    8 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/base.c   |  218 +++-
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c    |  244 +++--
 drivers/gpu/drm/nouveau/core/subdev/therm/fannil.c |   54 +
 drivers/gpu/drm/nouveau/core/subdev/therm/fanpwm.c |  107 ++
 drivers/gpu/drm/nouveau/core/subdev/therm/fantog.c |  115 ++
 drivers/gpu/drm/nouveau/core/subdev/therm/ic.c     |   54 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c   |   82 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nv50.c   |  199 +++-
 drivers/gpu/drm/nouveau/core/subdev/therm/nva3.c   |   99 ++
 drivers/gpu/drm/nouveau/core/subdev/therm/nvd0.c   |  153 +++
 drivers/gpu/drm/nouveau/core/subdev/therm/priv.h   |  103 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/temp.c   |  162 +++
 drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c   |    2 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.h             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |    2 +
 drivers/gpu/drm/nouveau/nouveau_bios.c             |  130 +--
 drivers/gpu/drm/nouveau/nouveau_bios.h             |   12 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   25 +-
 drivers/gpu/drm/nouveau/nouveau_bo.h               |    3 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |    5 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   96 +-
 drivers/gpu/drm/nouveau/nouveau_connector.h        |   10 +-
 drivers/gpu/drm/nouveau/nouveau_debugfs.c          |   64 ++
 drivers/gpu/drm/nouveau/nouveau_debugfs.h          |   22 +
 drivers/gpu/drm/nouveau/nouveau_display.c          |   95 +-
 drivers/gpu/drm/nouveau/nouveau_display.h          |    3 -
 drivers/gpu/drm/nouveau/nouveau_dma.h              |    2 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c               |  297 +----
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   60 +-
 drivers/gpu/drm/nouveau/nouveau_drm.h              |    2 +
 drivers/gpu/drm/nouveau/nouveau_encoder.h          |    9 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   26 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |  103 +-
 drivers/gpu/drm/nouveau/nouveau_fence.h            |   42 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |  103 +-
 drivers/gpu/drm/nouveau/nouveau_gem.h              |   10 +-
 drivers/gpu/drm/nouveau/nouveau_pm.c               |  233 +++-
 drivers/gpu/drm/nouveau/nouveau_prime.c            |  173 +--
 drivers/gpu/drm/nouveau/nv04_dfp.c                 |    4 +-
 drivers/gpu/drm/nouveau/nv04_display.c             |   18 +-
 drivers/gpu/drm/nouveau/nv04_display.h             |    1 +
 drivers/gpu/drm/nouveau/nv04_fence.c               |    6 +-
 drivers/gpu/drm/nouveau/nv04_tv.c                  |   39 +-
 drivers/gpu/drm/nouveau/nv10_fence.c               |  118 +-
 drivers/gpu/drm/nouveau/nv10_fence.h               |   19 +
 drivers/gpu/drm/nouveau/nv17_fence.c               |  149 +++
 drivers/gpu/drm/nouveau/nv17_tv.c                  |    2 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |  307 +++++-
 drivers/gpu/drm/nouveau/nv50_fence.c               |   36 +-
 drivers/gpu/drm/nouveau/nv84_fence.c               |  214 +++-
 drivers/gpu/drm/nouveau/nvc0_fence.c               |  186 +---
 drivers/{staging => gpu/drm}/omapdrm/Kconfig       |    0
 drivers/{staging => gpu/drm}/omapdrm/Makefile      |    0
 drivers/gpu/drm/omapdrm/TODO                       |   23 +
 .../{staging => gpu/drm}/omapdrm/omap_connector.c  |    2 +-
 drivers/{staging => gpu/drm}/omapdrm/omap_crtc.c   |   14 +-
 .../{staging => gpu/drm}/omapdrm/omap_debugfs.c    |   18 +-
 .../{staging => gpu/drm}/omapdrm/omap_dmm_priv.h   |    5 +
 .../{staging => gpu/drm}/omapdrm/omap_dmm_tiler.c  |  159 ++-
 .../{staging => gpu/drm}/omapdrm/omap_dmm_tiler.h  |    0
 drivers/{staging => gpu/drm}/omapdrm/omap_drv.c    |   20 +-
 drivers/{staging => gpu/drm}/omapdrm/omap_drv.h    |    8 +-
 .../{staging => gpu/drm}/omapdrm/omap_encoder.c    |    2 +-
 drivers/{staging => gpu/drm}/omapdrm/omap_fb.c     |   18 +-
 drivers/{staging => gpu/drm}/omapdrm/omap_fbdev.c  |   34 +-
 drivers/{staging => gpu/drm}/omapdrm/omap_gem.c    |   34 +-
 .../{staging => gpu/drm}/omapdrm/omap_gem_dmabuf.c |    8 +-
 .../drm}/omapdrm/omap_gem_helpers.c                |    2 +-
 drivers/{staging => gpu/drm}/omapdrm/omap_irq.c    |    2 +-
 drivers/{staging => gpu/drm}/omapdrm/omap_plane.c  |    2 +-
 drivers/{staging => gpu/drm}/omapdrm/tcm-sita.c    |    0
 drivers/{staging => gpu/drm}/omapdrm/tcm-sita.h    |    0
 drivers/{staging => gpu/drm}/omapdrm/tcm.h         |    2 +
 drivers/gpu/drm/radeon/Kconfig                     |   33 +-
 drivers/gpu/drm/radeon/Makefile                    |   10 +-
 drivers/gpu/drm/radeon/atom.c                      |    9 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |    6 +-
 drivers/gpu/drm/radeon/evergreen.c                 |  366 +++++--
 drivers/gpu/drm/radeon/evergreen_cs.c              | 1149 ++++++++------------
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |   85 +-
 drivers/gpu/drm/radeon/evergreen_reg.h             |    1 +
 drivers/gpu/drm/radeon/evergreend.h                |   54 +-
 drivers/gpu/drm/radeon/ni.c                        |  339 ++++--
 drivers/gpu/drm/radeon/nid.h                       |   27 +-
 drivers/gpu/drm/radeon/r100.c                      |  224 +---
 drivers/gpu/drm/radeon/r100_track.h                |    4 -
 drivers/gpu/drm/radeon/r100d.h                     |   11 -
 drivers/gpu/drm/radeon/r200.c                      |   26 +-
 drivers/gpu/drm/radeon/r300.c                      |   42 +-
 drivers/gpu/drm/radeon/r300_cmdbuf.c               |    2 +
 drivers/gpu/drm/radeon/r300d.h                     |   11 -
 drivers/gpu/drm/radeon/r500_reg.h                  |    1 +
 drivers/gpu/drm/radeon/r600.c                      |  401 ++++---
 drivers/gpu/drm/radeon/r600_blit.c                 |   33 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c             |   31 +
 drivers/gpu/drm/radeon/r600_cp.c                   |    2 +
 drivers/gpu/drm/radeon/r600_cs.c                   |  332 ++----
 drivers/gpu/drm/radeon/r600_hdmi.c                 |  135 +--
 drivers/gpu/drm/radeon/r600d.h                     |   17 +-
 drivers/gpu/drm/radeon/radeon.h                    |   38 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |   70 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   24 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c       |   73 +-
 drivers/gpu/drm/radeon/radeon_cp.c                 |    2 +
 drivers/gpu/drm/radeon/radeon_cs.c                 |  176 ++-
 drivers/gpu/drm/radeon/radeon_cursor.c             |    8 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   10 +-
 drivers/gpu/drm/radeon/radeon_display.c            |    2 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   91 +-
 drivers/gpu/drm/radeon/radeon_drv.h                |   16 +-
 drivers/gpu/drm/radeon/radeon_family.h             |    1 +
 drivers/gpu/drm/radeon/radeon_fb.c                 |   27 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |   60 +-
 drivers/gpu/drm/radeon/radeon_irq.c                |    2 +
 drivers/gpu/drm/radeon/radeon_kms.c                |   11 +-
 drivers/gpu/drm/radeon/radeon_mem.c                |    2 +
 drivers/gpu/drm/radeon/radeon_pm.c                 |    2 +-
 drivers/gpu/drm/radeon/radeon_prime.c              |  170 +--
 drivers/gpu/drm/radeon/radeon_reg.h                |   15 +
 drivers/gpu/drm/radeon/radeon_ring.c               |   19 +
 drivers/gpu/drm/radeon/radeon_state.c              |    2 +
 drivers/gpu/drm/radeon/radeon_ttm.c                |    1 +
 drivers/gpu/drm/radeon/rv515d.h                    |   11 -
 drivers/gpu/drm/radeon/rv770.c                     |   25 +
 drivers/gpu/drm/radeon/rv770d.h                    |    4 +
 drivers/gpu/drm/radeon/si.c                        |  509 ++++++---
 drivers/gpu/drm/radeon/sid.h                       |   30 +-
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |    4 +-
 drivers/gpu/drm/tegra/Kconfig                      |    1 +
 drivers/gpu/drm/tegra/dc.c                         |  585 ++++++++--
 drivers/gpu/drm/tegra/dc.h                         |   14 +-
 drivers/gpu/drm/tegra/drm.c                        |  103 ++
 drivers/gpu/drm/tegra/drm.h                        |   43 +-
 drivers/gpu/drm/tegra/fb.c                         |    4 -
 drivers/gpu/drm/tegra/hdmi.c                       |  226 ++--
 drivers/gpu/drm/tegra/hdmi.h                       |  189 ----
 drivers/gpu/drm/tilcdc/Kconfig                     |   13 +
 drivers/gpu/drm/tilcdc/Makefile                    |   10 +
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c               |  602 ++++++++++
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |  611 +++++++++++
 drivers/gpu/drm/tilcdc/tilcdc_drv.h                |  150 +++
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |  436 ++++++++
 drivers/gpu/drm/tilcdc/tilcdc_panel.h              |   26 +
 drivers/gpu/drm/tilcdc/tilcdc_regs.h               |  154 +++
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              |  376 +++++++
 drivers/gpu/drm/tilcdc/tilcdc_slave.h              |   26 +
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c             |  419 +++++++
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.h             |   26 +
 drivers/gpu/drm/ttm/ttm_bo.c                       |  103 +-
 drivers/gpu/drm/ttm/ttm_execbuf_util.c             |   78 +-
 drivers/gpu/drm/udl/udl_drv.h                      |    2 +
 drivers/gpu/drm/udl/udl_fb.c                       |   78 +-
 drivers/gpu/drm/udl/udl_transfer.c                 |   46 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c              |   38 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   87 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |    4 +-
 drivers/gpu/stub/Kconfig                           |   18 -
 drivers/gpu/stub/Makefile                          |    1 -
 drivers/gpu/stub/poulsbo.c                         |   64 --
 drivers/gpu/vga/vga_switcheroo.c                   |    3 +
 drivers/iommu/intel-iommu.c                        |    8 +-
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/omapdrm/TODO                       |   32 -
 drivers/tty/vt/vt.c                                |  136 ++-
 drivers/video/Kconfig                              |   26 +-
 drivers/video/Makefile                             |    5 +
 drivers/video/console/fbcon.c                      |   58 +-
 drivers/video/console/vgacon.c                     |   22 +-
 drivers/video/display_timing.c                     |   24 +
 drivers/video/fbmem.c                              |   11 +-
 drivers/video/fbmon.c                              |   94 ++
 drivers/video/fbsysfs.c                            |    3 +
 drivers/video/hdmi.c                               |  308 ++++++
 drivers/video/of_display_timing.c                  |  239 ++++
 drivers/video/of_videomode.c                       |   54 +
 drivers/video/via/hw.c                             |    6 +-
 drivers/video/via/hw.h                             |    2 +-
 drivers/video/via/lcd.c                            |    2 +-
 drivers/video/via/share.h                          |    2 +-
 drivers/video/via/via_modesetting.c                |    8 +-
 drivers/video/via/via_modesetting.h                |    6 +-
 drivers/video/videomode.c                          |   39 +
 include/drm/drmP.h                                 |   34 +
 include/drm/drm_crtc.h                             |   38 +-
 include/drm/drm_edid.h                             |    6 +
 include/drm/drm_encoder_slave.h                    |   20 +
 include/drm/drm_fb_cma_helper.h                    |    5 +
 include/drm/drm_fb_helper.h                        |   18 +-
 include/drm/drm_gem_cma_helper.h                   |    4 +
 include/drm/drm_mm.h                               |   40 +
 include/drm/drm_pciids.h                           |   13 +
 include/drm/intel-gtt.h                            |   22 +-
 include/drm/ttm/ttm_bo_driver.h                    |   61 +-
 include/linux/console.h                            |    2 +
 include/linux/fb.h                                 |    8 +
 include/linux/hdmi.h                               |  231 ++++
 include/linux/vt_kern.h                            |    3 +
 include/uapi/drm/i915_drm.h                        |   20 +
 .../omapdrm => include/uapi/drm}/omap_drm.h        |    2 +-
 include/video/display_timing.h                     |  124 +++
 include/video/of_display_timing.h                  |   20 +
 include/video/of_videomode.h                       |   18 +
 include/video/videomode.h                          |   48 +
 kernel/printk.c                                    |    9 +
 399 files changed, 23655 insertions(+), 11557 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/drm/tilcdc/panel.txt
 create mode 100644 Documentation/devicetree/bindings/drm/tilcdc/slave.txt
 create mode 100644 Documentation/devicetree/bindings/drm/tilcdc/tfp410.txt
 create mode 100644 Documentation/devicetree/bindings/drm/tilcdc/tilcdc.txt
 create mode 100644 Documentation/devicetree/bindings/video/display-timing.txt
 create mode 100644 Documentation/thermal/nouveau_thermal
 delete mode 100644 drivers/gpu/drm/drm_edid_modes.h
 create mode 100644 drivers/gpu/drm/i2c/Kconfig
 create mode 100644 drivers/gpu/drm/i2c/tda998x_drv.c
 create mode 100644 drivers/gpu/drm/i915/i915_ums.c
 create mode 100644 drivers/gpu/drm/nouveau/core/core/event.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/dport.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/dport.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/piornv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/event.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/xpio.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bus.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/xpio.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bus/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bus/nv31.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bus/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bus/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/gpio/priv.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/anx9805.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/nv4e.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/nv50.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/nv94.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/nvd0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/fannil.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/fanpwm.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/fantog.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/nva3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/nvd0.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_debugfs.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_debugfs.h
 create mode 100644 drivers/gpu/drm/nouveau/nv10_fence.h
 create mode 100644 drivers/gpu/drm/nouveau/nv17_fence.c
 rename drivers/{staging => gpu/drm}/omapdrm/Kconfig (100%)
 rename drivers/{staging => gpu/drm}/omapdrm/Makefile (100%)
 create mode 100644 drivers/gpu/drm/omapdrm/TODO
 rename drivers/{staging => gpu/drm}/omapdrm/omap_connector.c (99%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_crtc.c (98%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_debugfs.c (90%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_dmm_priv.h (96%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_dmm_tiler.c (86%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_dmm_tiler.h (100%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_drv.c (97%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_drv.h (98%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_encoder.c (99%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_fb.c (99%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_fbdev.c (95%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_gem.c (97%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_gem_dmabuf.c (98%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_gem_helpers.c (98%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_irq.c (99%)
 rename drivers/{staging => gpu/drm}/omapdrm/omap_plane.c (99%)
 rename drivers/{staging => gpu/drm}/omapdrm/tcm-sita.c (100%)
 rename drivers/{staging => gpu/drm}/omapdrm/tcm-sita.h (100%)
 rename drivers/{staging => gpu/drm}/omapdrm/tcm.h (99%)
 create mode 100644 drivers/gpu/drm/tilcdc/Kconfig
 create mode 100644 drivers/gpu/drm/tilcdc/Makefile
 create mode 100644 drivers/gpu/drm/tilcdc/tilcdc_crtc.c
 create mode 100644 drivers/gpu/drm/tilcdc/tilcdc_drv.c
 create mode 100644 drivers/gpu/drm/tilcdc/tilcdc_drv.h
 create mode 100644 drivers/gpu/drm/tilcdc/tilcdc_panel.c
 create mode 100644 drivers/gpu/drm/tilcdc/tilcdc_panel.h
 create mode 100644 drivers/gpu/drm/tilcdc/tilcdc_regs.h
 create mode 100644 drivers/gpu/drm/tilcdc/tilcdc_slave.c
 create mode 100644 drivers/gpu/drm/tilcdc/tilcdc_slave.h
 create mode 100644 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
 create mode 100644 drivers/gpu/drm/tilcdc/tilcdc_tfp410.h
 delete mode 100644 drivers/gpu/stub/Kconfig
 delete mode 100644 drivers/gpu/stub/Makefile
 delete mode 100644 drivers/gpu/stub/poulsbo.c
 delete mode 100644 drivers/staging/omapdrm/TODO
 create mode 100644 drivers/video/display_timing.c
 create mode 100644 drivers/video/hdmi.c
 create mode 100644 drivers/video/of_display_timing.c
 create mode 100644 drivers/video/of_videomode.c
 create mode 100644 drivers/video/videomode.c
 create mode 100644 include/linux/hdmi.h
 rename {drivers/staging/omapdrm => include/uapi/drm}/omap_drm.h (99%)
 create mode 100644 include/video/display_timing.h
 create mode 100644 include/video/of_display_timing.h
 create mode 100644 include/video/of_videomode.h
 create mode 100644 include/video/videomode.h
--29444707-1876484047-1361837130=:24684--
