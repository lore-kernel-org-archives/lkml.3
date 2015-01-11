Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbbAKU7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 15:59:25 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:37152 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbbAKU7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 15:59:23 -0500
MIME-Version: 1.0
Date: Sun, 11 Jan 2015 12:59:22 -0800
X-Google-Sender-Auth: Cn5-m2XEWNrkAYRYNNfjIp-chAU
Message-ID: <CA+55aFxd6H=7cEruFoMCFZiDO47HhP395bSkjzjsKBwKTg5htw@mail.gmail.com>
Subject: Linux 3.19-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc.

Things have remained reasonably calm, although we also had a few
last-minute MM regressions. Happily, most of them got fixed really
quickly, with one remaining arm64 issue still pending.

So go forth and test some more. I'll be traveling for the next two
weeks due to LCA, but I should have internet, and if things continue
to be reasonably calm I don't think that my travel should be all that
noticeable.  Finally the timing worked out, unlike several releases
last year.

Anyway, the appended shortlog gives the details, but apart from the
kgdb patches showing up as some uncommon work under kernel/debug/,
things look fairly normal: mostly driver updates (gpu, pinctrl, hid,
networking), architecture updates (mainly x86 this time, some minor
arm[64] stuff), and some tooling fixes (mainly perf).

              Linus

---

Aaron Plattner (1):
      ALSA: hda - Add new GPU codec ID 0x10de0072 to snd-hda

Alex Deucher (4):
      drm/radeon: KV has three PPLLs (v2)
      drm/radeon: fix sad_count check for dce3
      drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw
      drm/radeon: adjust default bapm settings for KV

Alex Thorlton (1):
      sched: Fix KMALLOC_MAX_SIZE overflow during cpumask allocation

Alexandre Courbot (1):
      drm/nouveau: fix missing return statement in nouveau_ttm_tt_unpopulate

Alexey Khoroshilov (1):
      drm/radeon: do not leave queue acquired if timeout happens in
kgd_hqd_destroy()

Andi Kleen (1):
      perf/x86/uncore/hsw-ep: Handle systems with only two SBOXes

Andy Lutomirski (4):
      x86_64, vdso: Fix the vdso address randomization algorithm
      x86, vdso: Use asm volatile in __getcpu
      perf: Move task_pt_regs sampling into arch code
      perf/x86_64: Improve user regs sampling

Andy Shevchenko (1):
      qla3xxx: don't allow never end busy loop

Anton Vorontsov (6):
      kdb: Remove currently unused kdbtab_t->cmd_flags
      kdb: Rename kdb_repeat_t to kdb_cmdflags_t, cmd_repeat to cmd_flags
      kdb: Rename kdb_register_repeat() to kdb_register_flags()
      kdb: Use KDB_REPEAT_* values as flags
      kdb: Remove KDB_REPEAT_NONE flag
      kdb: Add enable mask for groups of commands

Ard Biesheuvel (1):
      arm64/efi: add missing call to early_ioremap_reset()

Ben Goz (5):
      amdkfd: Fixing topology bug in building sysfs nodes
      drm/amd: Fixing typos in kfd<->kgd interface
      drm/amdkfd: Load mqd to hqd in non-HWS mode
      drm/radeon: Assign VMID to PASID for IH in non-HWS mode
      drm/amdkfd: unmap VMID<-->PASID when relesing VMID (non-HWS)

Ben Pfaff (1):
      openvswitch: Consistently include VLAN header in flow and port stats.

Ben Skeggs (4):
      drm/nouveau/bios: fix oops on pre-nv50 chipsets
      drm/nouveau: wake up the card if necessary during gem callbacks
      drm/nouveau/fb/ram/mcp77: subclass nouveau_ram
      drm/nouveau/fb/ram/mcp77: use carveout reg to determine size

Benjamin Tissoires (1):
      HID: logitech-hidpp: prefix the name with "Logitech"

Bjørn Mork (1):
      x86/build: Clean auto-generated processor feature files

Bruno Prémont (2):
      drm/nouveau/nouveau: Do not BUG_ON(!spin_is_locked()) on UP
      qla2xxx: fix busy wait regression

Chris Mason (2):
      Btrfs: add more maintainers
      Btrfs: don't delay inode ref updates during log replay

Chris Wilson (1):
      mutex: Always clear owner field upon mutex_unlock()

Corey Minyard (1):
      ipmi: Fix compile warning with tv_usec

Dan Carpenter (3):
      Btrfs, scrub: uninitialized variable in scrub_extent_for_parity()
      drm/radeon: integer underflow in radeon_cp_dispatch_texture()
      HID: roccat: potential out of bounds in pyra_sysfs_write_settings()

Daniel Mack (1):
      ALSA: snd-usb-caiaq: fix stream count check

Daniel Nicoletti (1):
      HID: Allow HID_BATTERY_STRENGTH to be enabled

Daniel Thompson (3):
      kdb: Categorize kdb commands (similar to SysRq categorization)
      kdb: Allow access to sensitive commands to be restricted by default
      kgdb: timeout if secondary CPUs ignore the roundup

David Drysdale (1):
      vfs: renumber FMODE_NONOTIFY and add to uniqueness check

Doug Anderson (2):
      pinctrl: rockchip: Handle wakeup pins
      pinctrl: rockchip: Fix enable/disable/mask/unmask

Fabian Frederick (1):
      kernel/debug/debug_core.c: Logging clean-up

Felipe Balbi (1):
      net: ethernet: cpsw: fix hangs with interrupts

Filipe Manana (1):
      Btrfs: correctly get tree level in tree_backref_for_extent

Francesco VIRLINZI (1):
      pinctrl: st: avoid multiple mutex lock

Giedrius Statkevičius (1):
      HID: Add a new id 0x501a for Genius MousePen i608X

Govindarajulu Varadarajan (1):
      enic: free all rq buffs when allocation fails

Grygorii Strashko (1):
      ARM: 8253/1: mm: use phys_addr_t type in map_lowmem() for kernel
mem region

Hanjun Guo (2):
      ACPI / processor: Convert apic_id to phys_id to make it arch agnostic
      ACPI / processor: Rename acpi_(un)map_lsapic() to acpi_(un)map_cpu()

Hans de Goede (1):
      ACPI / video: Add disable_native_backlight quirk for Dell XPS15 L521X

Henrik Rydberg (1):
      MAINTAINERS: update rydberg's addresses

Herbert Xu (1):
      tcp: Do not apply TSO segment limit to non-TSO packets

Ilia Mirkin (1):
      drm/nv4c/mc: disable msi

Ilya Dryomov (2):
      ceph: use %zu for len in ceph_fill_inline_data()
      libceph: fix sparse endianness warnings

Imre Deak (1):
      drm/i915: add missing rpm ref to i915_gem_pwrite_ioctl

J. Bruce Fields (1):
      rpc: fix xdr_truncate_encode to handle buffer ending on page boundary

Jack Morgenstein (1):
      net/mlx4_core: Fix error flow in mlx4_init_hca()

Jakub Wilk (1):
      ext4: remove spurious KERN_INFO from ext4_warning call

Jan Beulich (1):
      x86: Fix step size adjustment during initial memory mapping

Jeff Layton (1):
      nfsd: fix fi_delegees leak when fi_had_conflict returns true

Joe Perches (1):
      i40e: Fix possible memory leak in i40e_dbg_dump_desc

Joerg Roedel (2):
      iommu/vt-d: Fix dmar_domain leak in iommu_attach_device
      iommu/vt-d: Remove dead code in device_notifier

Johannes Berg (1):
      Revert "mac80211: Fix accounting of the tailroom-needed counter"

Johannes Weiner (2):
      mm: protect set_page_dirty() from ongoing truncation
      mm: memcontrol: switch soft limit default back to infinity

John W. Linville (1):
      e100: fix typo in MDI/MDI-X eeprom check in e100_phy_init

Joonsoo Kim (1):
      mm/debug_pagealloc: remove obsolete Kconfig options

Josef Bacik (1):
      Btrfs: abort transaction if we don't find the block group

Joseph Qi (1):
      ocfs2: remove bogus check in dlm_process_recovery_data

Julia Lawall (4):
      net: Xilinx: fix error return code
      myri10ge: fix error return code
      net: sun4i-emac: fix error return code
      net: axienet: fix error return code

Karl Relton (1):
      HID: add battery quirk for
USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO keyboard

Kirill Smelkov (1):
      tools/liblockdep: Fix debug_check thinko in mutex destroy

Konstantin Khlebnikov (2):
      mm: prevent endless growth of anon_vma hierarchy
      mm: fix corner case in anon_vma endless growing prevention

Kostya Belezko (1):
      Altera TSE: Add missing phydev

Kristian Evensen (1):
      qmi_wwan: Set random MAC on devices with buggy fw

Laurent Pinchart (1):
      iommu/ipmmu-vmsa: Change IOMMU_EXEC to IOMMU_NOEXEC

Linus Lüssing (4):
      batman-adv: fix delayed foreign originator recognition
      batman-adv: fix counter for multicast supporting nodes
      batman-adv: fix multicast counter when purging originators
      batman-adv: fix potential TT client + orig-node memory leak

Linus Torvalds (3):
      mm: propagate error from stack expansion even for guard page
      mm: Don't count the stack guard page towards RLIMIT_STACK
      linux 3.19-rc4

Luca Abeni (2):
      sched/deadline: Fix migration of SCHED_DEADLINE tasks
      sched/deadline: Avoid double-accounting in case of missed deadlines

Maor Gottlieb (1):
      net/mlx4_core: Correcly update the mtt's offset in the MR re-reg flow

Mark Rutland (3):
      arm64: Correct __NR_compat_syscalls for bpf
      arm64: sanity checks: add missing AArch32 registers
      ARM: 8249/1: mm: dump: don't skip regions

Martin Hundebøll (1):
      batman-adv: fix lock class for decoding hash in network-coding.c

Masami Hiramatsu (1):
      perf probe: Fix to fall back to find probe point in symbols

Mathias Krause (1):
      crypto: aesni - fix "by8" variant for 128 bit keys

Michael S. Tsirkin (4):
      virtio: make del_vqs idempotent
      virtio_pci: device-specific release callback
      virtio_pci: document why we defer kfree
      vhost/net: length miscalculation

Michal Marek (2):
      kbuild: Fix removal of the debian/ directory
      Makefile: include arch/*/include/generated/uapi before .../generated

Mika Westerberg (1):
      HID: i2c-hid: Do not free buffers in i2c_hid_stop()

Namhyung Kim (8):
      perf report: Show progress bar for output resorting
      perf ui/tui: Print backtrace symbols when segfault occurs
      perf callchain: Append callchains only when requested
      perf probe: Fix crash in dwarf_getcfi_elf
      perf diff: Fix to sort by baseline field by default
      perf hists: Fix children sort key behavior
      perf callchain: Free callchains when hist entries are deleted
      perf hists browser: Fix segfault when showing callchain

Oded Gabbay (8):
      amdkfd: Fix accounting of device queues
      amdkfd: Remove duplicate include
      drivers: Move iommu/ before gpu/ in Makefile
      drm: Put amdkfd before radeon in drm Makefile
      drm/radeon: Init amdkfd only if it was compiled
      drm/amdkfd: Do copy_to/from_user in general kfd_ioctl()
      drm/amdkfd: reformat IOCTL definitions to drm-style
      drm/amdkfd: rewrite kfd_ioctl() according to drm_ioctl()

Oleg Nesterov (2):
      exit: fix race between wait_consider_task() and wait_task_zombie()
      arch/blackfin/mach-bf533/boards/stamp.c: add linux/delay.h

Palik, Imre (1):
      xen-netback: fixing the propagation of the transmit shaper timeout

Patrice CHOTARD (1):
      pinctrl: st: Add irq_disable hook to st_gpio_irqchip

Paul Walmsley (4):
      arm64: fix missing asm/pgtable-hwdef.h include in asm/processor.h
      arm64: fix missing linux/bug.h include in asm/arch_timer.h
      arm64: fix missing asm/alternative.h include in kernel/module.c
      arm64: fix missing asm/io.h include in kernel/smp_spin_table.c

Peter Wu (3):
      HID: logitech-dj: check report length
      HID: logitech-hidpp: check WTP report length
      HID: logitech-hidpp: avoid unintended fall-through

Peter Zijlstra (2):
      x86: Fix off-by-one in instruction decoder
      sched, fanotify: Deal with nested sleeps

Pierre Moreau (1):
      drm/nouveau/fb/ram/mcp77: enable NISO poller

Pranith Kumar (1):
      assoc_array: Include rcupdate.h for call_rcu() definition

Rafael J. Wysocki (1):
      ACPI / PM: Fix PM initialization for devices that are not present

Russell King (1):
      ARM: wire up execveat syscall

Sasha Levin (3):
      amdkfd: actually allocate longs for the pasid bitmask
      KEYS: close race between key lookup and freeing
      virtio_pci: defer kfree until release callback

Simon Wunderlich (1):
      batman-adv: fix and simplify condition when bonding should be used

Sven Köhler (1):
      drm/nouveau/device: Add support for GK208B, resolves bug 86935

Sylvain BERTRAND (1):
      x86: Fix mkcapflags.sh bash-ism

Taesoo Kim (1):
      perf list: Fix --raw-dump option

Takashi Iwai (1):
      ALSA: hda - Fix wrong gpio_dir & gpio_mask hint setups for IDT/STAC codecs

Takashi Sakamoto (1):
      ALSA: fireworks: fix an endianness bug for transaction length

Tetsuo Handa (1):
      sched/fair: Fix RCU stall upon -ENOMEM in sched_create_group()

Theodore Ts'o (2):
      ext4: prevent online resize with backup superblock
      Revert "ext4: fix suboptimal seek_{data,hole} extents traversial"

Tobias Klauser (1):
      arm64: Remove unused prepare_to_copy()

Todd Fujinaka (1):
      igb: Remove unneeded FIXME

Victor Kamensky (1):
      ARM: 8275/1: mm: fix PMD_SECT_RDONLY undeclared compile error

Ville Syrjälä (3):
      drm/i915: Kill check_power_well() calls
      drm/i915: Don't call intel_prepare_page_flip() multiple times on gen2-4
      Revert "drm/i915: Preserve VGACNTR bits from the BIOS"

Vinson Lee (1):
      crypto: sha-mb - Add avx2_supported check.

Vladimir Davydov (1):
      memcg: fix destination cgroup leak on task charges migration

Vlastimil Babka (1):
      mm, vmscan: prevent kswapd livelock due to pfmemalloc-throttled
process being killed

Wang Shilong (1):
      Btrfs: call inode_dec_link_count() on mkdir error path

Wei Yang (1):
      vfio-pci: Fix the check on pci device type in vfio_pci_probe()

Wolfram Sang (1):
      iommu/rockchip: Drop owner assignment from platform_drivers

Xue jiufei (1):
      ocfs2: fix the wrong directory passed to
ocfs2_lookup_ino_from_name() when link file

Yongjian Xu (1):
      qlcnic: Fix return value in qlcnic_probe()

Yuyang Du (1):
      sched: Fix odd values in effective_load() calculations

hayeswang (1):
      r8152: support ndo_features_check
