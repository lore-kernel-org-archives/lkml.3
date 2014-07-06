Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaGFTvp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 15:51:45 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:55994 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaGFTvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 15:51:42 -0400
MIME-Version: 1.0
Date: Sun, 6 Jul 2014 12:51:41 -0700
X-Google-Sender-Auth: Ph4qSGnzJ61BLoHsIQpYJdOT9Xo
Message-ID: <CA+55aFwCXmBdW7v5FxnxPtQHxOR0=ktKu=i2Y+7Jw7axv9_MGQ@mail.gmail.com>
Subject: Linux 3.16-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Things have calmed down nicely, and everything seems pretty normal.
Maybe some of the calm has been due to people starting to take off for
summer and (in the US) the 4th of July week, but whatever the reason,
both the diffstat and the logs look nice and fairly small.

Most of the changes are in drivers (gpu, usb, scsi, sound),
filesystems (btrfs, ext4) and arch updates (mostly arm). With a
smattering of misc random stuff. But it's all pretty small.

Go out and test it,

             Linus

---

Adam Thomson (1):
      iio: of_iio_channel_get_by_name() returns non-null pointers for error legs

Alan Stern (1):
      usb-storage/SCSI: Add broken_fua blacklist flag

Alex Deucher (8):
      drm/radeon: adjust default dispclk on DCE6 (v2)
      drm/radeon: only apply bapm changes for AC power on ARUBA
      drm/radeon: enable bapm by default on KV/KB
      drm/radeon: enable bapm by default on desktop TN/RL boards
      drm/radeon: add a module parameter to control deep color support
      drm/radeon/dpm: fix typo in vddci setup for eg/btc
      drm/radeon/dpm: fix vddci setup typo on cayman
      drm/radeon/cik: fix typo in EOP packet

Anand Jain (7):
      btrfs: rename add_device_membership to btrfs_kobj_add_device
      btrfs: dev delete should remove sysfs entry
      btrfs: dev add should add its sysfs entry
      btrfs: dev replace should replace the sysfs entry
      btrfs: create sprout should rename fsid on the sysfs as well
      btrfs: fix null pointer dereference in clone_fs_devices when name is null
      btrfs: fix null pointer dereference in btrfs_show_devname when
name is null

Andreas Larsson (1):
      usb: gadget: gr_udc: Fix check for invalid number of microframes

Andrew Morton (1):
      kernel/printk/printk.c: revert "printk: enable interrupts before
calling console_trylock_for_printk()"

Andrzej Pietrasiewicz (2):
      usb: gadget: OS descriptors configfs cleanup
      usb: gadget: OS descriptors: provide interface directory names

Avi Kivity (1):
      nfs: fix nfs4d readlink truncated packet

Bjørn Mork (1):
      usb: option: add/modify Olivetti Olicard modems

Brian King (2):
      ibmvscsi: Abort init sequence during error recovery
      ibmvscsi: Add memory barriers for send / receive

Brian Norris (1):
      ARM: OMAP2+: drop unused function

Chen Yucong (2):
      mm:vmscan: update the trace-vmscan-postprocess.pl for event
vmscan/mm_vmscan_lru_isolate
      hwpoison: fix the handling path of the victimized page frame
that belong to non-LRU

Christian König (1):
      drm/radeon: page table BOs are kernel allocations

Dan Carpenter (2):
      usb: gadget: f_rndis: fix an error code on allocation failure
      staging: iio/ad7291: fix error code in ad7291_probe()

Dave Airlie (1):
      drm: fix permissions on drm_drv.c

Dave Gerlach (1):
      ARM: OMAP2+: hwmod: Change hardreset soc_ops for AM43XX

David Henningsson (1):
      ALSA: hda - Add another headset pin quirk for some Dell machines

David R. Piegdon (1):
      ARM: OMAP2+: Fix parser-bug in platform muxing code

David Sterba (2):
      btrfs: remove stale comment from btrfs_flush_all_pending_stuffs
      btrfs: use E2BIG instead of EIO if compression does not help

Deepak S (1):
      drm/i915: Drop early VLV WA to fix Voltage not getting dropped to Vmin

Deng-Cheng Zhu (1):
      MIPS: KVM: Fix memory leak on VCPU

Emil Goode (1):
      video: vt8500lcdfb: Remove kfree call since devm_kzalloc() is used

Eric Sandeen (1):
      btrfs: fix nossd and ssd_spread mount option regression

Ezequiel Garcia (1):
      usb: musb: Fix panic upon musb_am335x module removal

Felipe Balbi (1):
      Revert "tools: ffs-test: convert to new descriptor format fixing
compilation error"

Filipe Manana (4):
      Btrfs: assert send doesn't attempt to start transactions
      Btrfs: atomically set inode->i_flags in btrfs_update_iflags
      Btrfs: fix use-after-free when cloning a trailing file hole
      Btrfs: fix crash when starting transaction

Florian Fainelli (1):
      irqchip: brcmstb-l2: Level-2 interrupts are edge sensitive

George Cherian (4):
      ARM: dts: am43x-epos-evm: Add Missing cpsw-phy-sel for am43x-epos-evm
      usb: dwc3: dwc3-omap: Fix the crash on module removal
      usb: dwc3: dwc3-omap: Disable/Enable only wrapper interrupts in
prepare/complete
      usb: musb: core: Handle Babble condition only in HOST mode

Greg Kroah-Hartman (1):
      lz4: add overrun checks to lz4_uncompress_unknownoutputsize()

Guido Martínez (1):
      drm/i2c: tda998x: move drm_i2c_encoder_destroy call

Hannes Reinecke (1):
      scsi_error: set DID_TIME_OUT correctly

Heiko Carstens (3):
      KVM: s390: add sie.h uapi header file to Kbuild and remove
header dependency
      /proc/stat: convert to single_open_size()
      fs/seq_file: fallback to vmalloc allocation

Hugh Dickins (1):
      shmem: fix init_page_accessed use to stop !PageLRU bug

Ian Kent (1):
      autofs4: fix false positive compile error

J. Bruce Fields (1):
      nfsd: fix rare symlink decoding bug

Jan Kara (3):
      ext4: Fix buffer double free in ext4_alloc_branch()
      ext4: Fix block zeroing when punching holes in indirect block files
      ext4: Fix hole punching for files with indirect blocks

Jan Kiszka (1):
      KVM: SVM: Fix CPL export via SS.DPL

Jani Nikula (1):
      drm/i915: provide interface for audio driver to query cdclk

Jeff Westfahl (1):
      usb: gadget: u_ether: synchronize with transmit when stopping queue

Jesse Barnes (1):
      drm/i915: only apply crt_present check on VLV

Johan Hovold (3):
      MAINTAINERS: drop two usb-serial subdriver entries
      USB: ftdi_sio: fix null deref at port probe
      MAINTAINERS: update e-mail address

Joonsoo Kim (1):
      slub: fix off by one in number of slab tests

Josef Bacik (2):
      btrfs: only unlock block in verify_parent_transid if we locked it
      Btrfs: fix btrfs_print_leaf for skinny metadata

Keith Busch (1):
      genirq: Fix memory leak when calling irq_free_hwirqs()

Keshava Munegowda (1):
      ARM: OMAP5: hwmod: Add ocp2scp3 and sata hwmods

Kuninori Morimoto (1):
      usb: renesas: gadget: fixup: complete STATUS stage after receiving

Laura Abbott (1):
      of: Check for phys_addr_t overflows in early_init_dt_add_memory_arch

Linus Torvalds (1):
      Linux 3.16-rc4

Linus Walleij (1):
      usb: musb: ux500: don't propagate the OF node

Liu Bo (2):
      Btrfs: fix crash when mounting raid5 btrfs with missing disks
      Btrfs: fix race of using total_bytes_pinned

Lothar Waßmann (1):
      usb: musb: dsps: fix the base address for accessing the mode register

Lu Baolu (1):
      xhci: clear root port wake on bits if controller isn't wake-up capable

Marc Zyngier (1):
      arm64: fix el2_setup check of CurrentEL

Marcus Nutzinger (1):
      usb: gadget: gadgetfs: correct dev state

Martin K. Petersen (1):
      [SCSI] use the scsi data buffer length to extract transfer size

Mathias Nyman (2):
      xhci: Use correct SLOT ID when handling a reset device command
      xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Maurizio Lombardi (2):
      pm8001: Fix potential null pointer dereference and memory leak.
      bnx2fc: do not scan uninitialized lists in case of error.

Maxime Ripard (1):
      ARM: sunxi: Reintroduce the restart code for A10/A20 SoCs

Mengdong Lin (1):
      ALSA: hda - restore BCLK M/N value as per CDCLK for HSW/BDW
display HDA controller

Michael Welling (1):
      drivers:video:fbdev atmel_lcdfb.c power GPIO registration bug

Michal Marek (1):
      kbuild: Print the name of the build directory

Michal Nazarewicz (5):
      tools: ffs-test: convert to new descriptor format fixing compilation error
      usb: gadget: f_fs: fix NULL pointer dereference when there are no strings
      usb: gadget: f_fs: resurect usb_functionfs_descs_head structure
      tools: ffs-test: fix header values endianess
      mm: page_alloc: fix CMA area initialisation when pageblock > MAX_ORDER

Michel Dänzer (1):
      drm/radeon: Track the status of a page flip more explicitly

Minchan Kim (1):
      zram: revalidate disk after capacity change

Nadav Amit (1):
      KVM: x86: Increase the number of fixed MTRR regs to 10

Namjae Jeon (2):
      ext4: decrement free clusters/inodes counters when block group
declared bad
      msync: fix incorrect fstart calculation

Neil Horman (2):
      fc: ensure scan_work isn't active when freeing fc_rport
      bnx2fc: Improve stats update mechanism

NeilBrown (2):
      md: make sure GET_ARRAY_INFO ioctl reports correct "clean" status
      md: flush writes before starting a recovery.

Nishanth Menon (2):
      ARM: DRA722: add detection of SoC information
      ARM: dts: omap5: Update CPU OPP table as per final production Manual

Oleg Nesterov (4):
      tracing/uprobes: Revert "Support mix of ftrace and perf"
      uprobes: Change unregister/apply to WARN() if uprobe/consumer is gone
      tracing/uprobes: Kill the bogus UPROBE_HANDLER_REMOVE code in
uprobe_dispatcher()
      tracing/uprobes: Fix the usage of uprobe_buffer_enable() in
probe_event_enable()

Oliver Neukum (1):
      USB: option: add device ID for SpeedUp SU9800 usb 3g modem

Olof Johansson (1):
      ARM: bcm: Fix bcm and multi_v7 defconfigs

Paolo Bonzini (3):
      KVM: x86: preserve the high 32-bits of the PAT register
      virtio-scsi: avoid cancelling uninitialized work items
      virtio-scsi: fix various bad behavior on aborted requests

Peter Chen (1):
      usb: chipidea: udc: delete td from req's td list at ep_dequeue

Peter Meerwald (1):
      iio:adc:ad799x: Fix reading and writing of event values, apply shift

Peter Ujfalusi (1):
      ARM: DTS: dra7/dra7xx-clocks: ATL related changes

Quinn Tran (1):
      qla2xxx: Fix sparse warning in qla_target.c.

Reddy, Sreekanth (1):
      MAINTAINERS: Update LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
maintainers Email IDs

Russell King (2):
      drm/i2c: tda998x: faster polling for edid
      drm/i2c: tda998x: add some basic mode validation

Sachin Kamat (1):
      video: omapdss: Fix potential null pointer dereference

Santosh Shilimkar (1):
      MAINTAINERS: Add few more Keystone drivers

Scott Jiang (1):
      fb: adv7393: add missing semicolon

Sergey Senozhatsky (1):
      btrfs compression: reuse recently used workspace

Shawn Guo (1):
      MAINTAINERS: merge MXS entry into IMX one

Shuah Khan (3):
      tools: cpu-hotplug fix unexpected operator error
      tools: memory-hotplug fix unexpected operator error
      tools/testing/selftests/ipc/msgque.c: improve error handling
when not running as root

Sourav Poddar (1):
      ARM: dts: dra7-evm: remove interrupt binding

Srinivas Kandagatla (2):
      usb: phy: msm: Do not do runtime pm if the phy is not idle
      usb: Kconfig: make EHCI_MSM selectable for QCOM SOCs

Stefan Brüns (2):
      drm/radeon: Use only one line for whole DPCD debug output
      drm/radeon: use RADEON_MAX_CRTCS, RADEON_MAX_AFMT_BLOCKS (v2)

Steve Capper (2):
      arm64: mm: Fix horrendous config typo
      arm64: mm: Make icache synchronisation logic huge page aware

Steven Rostedt (Red Hat) (1):
      tracing: Remove ftrace_stop/start() from reading the trace file

Suman Anna (1):
      staging: tidspbridge: fix an erroneous removal of parentheses

T Makphaibulchoke (1):
      fs/mbcache: replace __builtin_log2() with ilog2()

Takashi Iwai (1):
      ALSA: hda - Add a fixup for Thinkpad T540p

Tejun Heo (2):
      kernfs: kernfs_notify() must be useable from non-sleepable contexts
      ptrace,x86: force IRET path after a ptrace_stop()

Thomas Gleixner (2):
      irqchip: spear_shirq: Fix interrupt offset
      usb: musb: Ensure that cppi41 timer gets armed on premature DMA TX irq

Thomas Hellstrom (1):
      drm/vmwgfx: Fix incorrect write to read-only register v2:

Thomas Petazzoni (4):
      irqchip: armada-370-xp: Mask all interrupts during initialization.
      ARM: mvebu: move Armada 375 external abort logic as a quirk
      ARM: mvebu: update L2/PCIe deadlock workaround after L2CC cleanup
      ARM: mvebu: fix cpuidle implementation to work on big-endian systems

Tomas Henzl (2):
      be2iscsi: add an missing goto in error path
      be2iscsi: remove potential junk pointer free

Tony Lindgren (1):
      ARM: dts: Enable twl4030 off-idle configuration for selected omaps

Ulrich Obergfell (1):
      scsi_error: fix invalid setting of host byte

Ville Syrjälä (1):
      drm/i915: Wait for vblank after enabling the primary plane on BDW

Wang Shilong (1):
      Btrfs: fix race between balance recovery and root deletion

Wang, Yu (1):
      xhci: Fix runtime suspended xhci from blocking system suspend.

Xiaoming Gao (1):
      kvm: fix wrong address when writing Hyper-V tsc page

Zhuang Jin Can (1):
      usb: dwc3: gadget: check link trb after free_slot is increased
