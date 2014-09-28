Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaI1Vov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 17:44:51 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:38195 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbaI1Vos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 17:44:48 -0400
MIME-Version: 1.0
Date: Sun, 28 Sep 2014 14:44:47 -0700
X-Google-Sender-Auth: 5igJPBZtjOe03Lkbm8FNTnBXOAM
Message-ID: <CA+55aFz3eu49Puvi8RZsscrpnQTsL6BjUZOg=xb-bOOryRu6Bw@mail.gmail.com>
Subject: Linux 3.17-rc7 - yes, another rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I was really hoping that I could have left rc6 as the last rc and
just releasing 3.17 today, but that was not to be. It's not that
anything particularly scary happened, but quite frankly, things just
didn't calm down as I hoped for.

And while my travel schedule would have made it really nice had I been
able to just do a shorter-than-usual release, "convenience" isn't
really part of the release criteria. Oh well.

This will likely mean that (barring unforseen circumstances) next
weekend sees the 3.17 release, and then due to travel, I probably will
just delay opening the merge window by a week after that.

And I'll be very grumpy if people send me pull requests that I deem
inappropriate at this point. I don't think that much of rc7 ended up
being "spurious", but I do get the feeling that there were people who
had delayed until the last minute that accounts for some of the "not
enough slowdown". If I get that feeling next week, I'll be my usual
impolite self, and probably decide that you missed your chance.

Anyway. Back to rc7. There's stuff all over here. The i2c part of the
patches stands out a bit because of some code movement, but apart from
that the diffstat looks pretty calm.  About 60% drivers, with the rest
being a mix of documentation, arch, filesystem and networking. Nothing
really particularly stands out, but it is just bigger than I was happy
with doing a release without another rc.

              Linus

---

Aaro Koskinen (1):
      drivers: net: ethernet: octeon_mgmt: fix a compiler warning

Aaron Lu (1):
      ACPI / video: disable native backlight for ThinkPad X201s

Adrian Hunter (1):
      gpio: Fix gpio direction flags not getting set

Al Viro (7):
      ufs: deal with nfsd/iget races
      pull rehashing and unlocking the target dentry into
__d_materialise_dentry()
      don't open-code d_rehash() in d_materialise_unique()
      __d_move(): fold manipulations with ->d_child/->d_subdirs
      __d_materialise_dentry(): flip the order of arguments
      kill __d_materialise_dentry()
      fold unlocking the children into dentry_unlock_parents_for_move()

Alex Deucher (4):
      drm/radeon: add a module parameter for backlight control (v2)
      drm/radeon: add a backlight quirk for Amilo Xi 2550
      drm/radeon: add PX quirk for asus K53TK
      drm/radeon/cik: use a separate counter for CP init timeout

Alex Estrin (1):
      IPoIB: Remove unnecessary port query

Alexander Y. Fomichev (1):
      net: fix creation adjacent device symlinks

Alexei Starovoitov (2):
      sparc: bpf_jit: fix support for ldx/stx mem and SKF_AD_VLAN_TAG
      sparc: bpf_jit: fix loads from negative offsets

Andreas Rohner (1):
      nilfs2: fix data loss with mmap()

Ani Sinha (1):
      net:socket: set msg_namelen to 0 if msg_name is passed as NULL
in msghdr struct from userland.

Anish Bhatt (2):
      scsi_netlink : Make SCSI_NETLINK dependent on NET instead of selecting NET
      bnx2i/bnx2fc : fix randconfig error in next-20140909

Anton Altaparmakov (1):
      Fix nasty 32-bit overflow bug in buffer i/o code.

Aravind Gopalakrishnan (2):
      hwmon: (fam15h_power) Make actual power reporting conditional
      hwmon: (fam15h_power) Add support for two more processors

Ard Biesheuvel (2):
      mm: export symbol dependencies of is_zero_pfn()
      KVM: check for !is_zero_pfn() in kvm_is_mmio_pfn()

Arend van Spriel (3):
      brcmfmac: conditionally compile firmware protocol source code
      brcmfmac: obtain ifp through wdev structure
      brcmfmac: handle IF event for P2P_DEVICE interface

Arnd Bergmann (1):
      ARM: pxa: fix section mismatch warning for pxa_timer_nodt_init

Beniamino Galvani (2):
      net: arc_emac: enable tx interrupts
      net: arc_emac: prevent reuse of unreclaimed tx descriptors

Bjorn Helgaas (2):
      Revert "PCI: Don't scan random busses in pci_scan_bridge()"
      Revert "PCI: Make sure bus number resources stay within their
parents bounds"

Bob Moore (1):
      ACPICA: Update to GPIO region handler interface.

Boris BREZILLON (1):
      clk: at91: fix num_parents test in at91sam9260 slow clk implementation

Brad Volkin (1):
      drm/i915: Don't leak command parser tables on suspend/resume

Brian Norris (1):
      of: correct of_console_check()'s return value

Christoffer Dall (1):
      arm/arm64: KVM: Fix unaligned access bug on gicv2 access

Christoph Hellwig (1):
      blk-mq: avoid infinite recursion with the FUA flag

Christophe Ricard (2):
      NFC: st21nfcb: Fix depmod dependency cycle
      NFC: st21nfca: Fix potential depmod dependency cycle

Chuck Ebbert (1):
      sched: Fix end_of_stack() and location of stack canary for
architectures using CONFIG_STACK_GROWSUP

Clemens Ladisch (1):
      ALSA: pcm: fix fifo_size frame calculation

Dan Carpenter (2):
      NFC: microread: Potential overflows in microread_target_discovered()
      r8169: fix an if condition

Daniel Mack (1):
      ALSA: snd-usb-caiaq: Fix LED commands for Kore controller

Dave Young (1):
      x86 early_ioremap: Increase FIX_BTMAPS_SLOTS to 8

David Dueck (1):
      can: at91_can: add missing prepare and unprepare of the clock

David Hildenbrand (1):
      blk-mq: Avoid race condition with uninitialized requests

David Howells (2):
      RxRPC: Fix missing __user annotation
      CacheFiles: Handle rename2

David Jander (3):
      can: flexcan: avoid calling usleep_range from interrupt context
      can: flexcan: correctly initialize mailboxes
      can: flexcan: implement workaround for errata ERR005829

David L Stevens (1):
      sunvnet - add missing rmb() for sunvnet driver

David Rientjes (1):
      mm, slab: initialize object alignment on cache creation

David S. Miller (6):
      scsi: Use 'depends' with LIBFC instead of 'select'.
      pch_gbe: 'select' NET_PTP_CLASSIFY.
      mips: Update some more defconfigs which were missing CONFIG_NET.
      s390: Update defconfigs which were missing CONFIG_NET.
      powerpc: Update defconfigs which were missing CONFIG_NET.
      parisc: Update defconfigs which were missing CONFIG_NET.

Devesh Sharma (2):
      RDMA/ocrdma: Report correct value of max_fast_reg_page_list_len
      RDMA/ocrdma: Do not skip setting deferred_arm

Dmitry Lifshitz (1):
      ARM: dts: cm-t54: fix serial console power supply.

Doug Anderson (1):
      clk: rockchip: Fix the clocks for i2c1 and i2c2

Edward Cree (1):
      sfc: fix addr_list_lock spinlock use before init

Eliad Peller (1):
      iwlwifi: increase DEFAULT_MAX_TX_POWER

Emil Goode (1):
      brcmfmac: Fix off by one bug in brcmf_count_20mhz_channels()

Emmanuel Grumbach (5):
      iwlwifi: mvm: enable scheduled scan on newest firmware
      mac80211: use bss_conf->dtim_period instead of conf.ps_dtim_period
      iwlwifi: mvm: fix endianity issues with Smart Fifo commands
      iwlwiwi: mvm: use bss_conf->dtim_period instead of conf.ps_dtim_period
      iwlwifi: dvm: disable power save by default

Eric Dumazet (4):
      net: fix skb_page_frag_refill() kerneldoc
      net: sched: shrink struct qdisc_skb_cb to 28 bytes
      ipoib: validate struct ipoib_cb size
      ipv4: do not use this_cpu_ptr() in preemptible context

Eyal Shapira (2):
      iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate
      iwlwifi: mvm: fix an overflow in iwl_mvm_get_signal_strength

Fabian Frederick (2):
      lib: rhashtable: remove second linux/log2.h inclusion
      fs/cachefiles: add missing \n to kerror conversions

Fan Du (1):
      i2c: ismt: use correct length when copy buffer

Florian Fainelli (4):
      net: systemport: check harder for out of memory conditions
      net: bcmgenet: check harder for out of memory conditions
      net: bcmgenet: fix TX reclaim accounting for fragments
      net: bcmgenet: call bcmgenet_dma_teardown in bcmgenet_fini_dma

Francesco Ruggeri (1):
      net: allow macvlans to move to net namespace

Frank Schaefer (1):
      [media] em28xx-v4l: get rid of field "users" in struct em28xx_v4l2"

Fu Zhonghui (1):
      ACPI / platform / LPSS: disable async suspend/resume of LPSS devices

Gaurav Minocha (2):
      of: Disabling OF functions that use sysfs if CONFIG_SYSFS disabled
      of: Documentation regarding attaching OF Selftest testdata

Geert Uytterhoeven (1):
      of: Fix memory block alignment in early_init_dt_add_memory_arch()

Hans Verkuil (12):
      [media] videobuf2-dma-sg: fix for wrong GFP mask to
sg_alloc_table_from_pages
      [media] videobuf2-core: add comments before the WARN_ON
      [media] videobuf2-core.h: fix comment
      [media] vb2: fix vb2 state check when start_streaming fails
      [media] DocBook media: fix fieldname in struct v4l2_subdev_selection
      [media] DocBook media: update version number and V4L2 changes
      [media] adv7604: fix inverted condition
      [media] cx24123: fix kernel oops due to missing parent pointer
      [media] cx2341x: fix kernel oops
      [media] vb2: fix VBI/poll regression
      [media] DocBook media: fix the poll() 'no QBUF' documentation
      [media] DocBook media: improve the poll() documentation

Hante Meuleman (1):
      brcmfmac: Fix memory leak and missing assignment.

Hariprasad Shenai (1):
      cxgb4: Don't allocate adapter structure for all PF's

Helge Deller (2):
      parisc: ptrace: use secure_computing_strict()
      parisc: pdc_stable.c: Avoid potential stack overflows

Huacai Chen (1):
      ALSA: hda - Add fixup model name lookup for Lemote A1205

Ivan Vecera (1):
      net/mlx4_en: do not ignore autoneg in mlx4_en_set_pauseparam()

Jack Morgenstein (6):
      IB/mlx4: Fix lockdep splat for the iboe lock
      mlx4: Fix mlx4 reg/unreg mac to work properly with 0-mac addresses
      IB/mlx4: Avoid accessing netdevice when building RoCE qp1 header
      IB/mlx4: Don't update QP1 in native mode
      IB/mlx4: Do not allow APM under RoCE
      IB/mlx4: Fix VF mac handling in RoCE

Jani Nikula (1):
      drm/i915/hdmi: fix hdmi audio state readout

Janusz Użycki (1):
      i2c: mxs: fix error message in pio transfer

Jarkko Nikula (1):
      gpio: Fix potential NULL handler data in chained irqchip handler

Jens Axboe (4):
      blk-mq: request deadline must be visible before marking rq as started
      blk-mq: fix potential oops on out-of-memory in __blk_mq_alloc_rq_maps()
      blk-mq: use blk_mq_start_hw_queues() when running requeue work
      genhd: fix leftover might_sleep() in blk_free_devt()

Johannes Berg (4):
      nl80211: clear skb cb before passing to netlink
      iwlwifi: mvm: BT Coex - remove shadowing variable
      iwlwifi: mvm: correctly handle PM/QoS changes from mac80211
      iwlwifi: mvm: BT Coex - always initialize smps_mode

Johannes Stezenbach (1):
      ath9k_htc: fix random decryption failure

John David Anglin (1):
      parisc: Only use -mfast-indirect-calls option for 32-bit kernel builds

Joseph Qi (2):
      ocfs2: free vol_label in ocfs2_delete_osb()
      ocfs2/dlm: do not get resource spinlock if lockres is new

Kees Cook (1):
      x86/kaslr: Avoid the setup_data area when picking location

Lan Tianyu (1):
      cpufreq: fix cpufreq suspend/resume for intel_pstate

Laurentiu Tudor (1):
      of: make sure of_alias is initialized before accessing it

Linus Torvalds (3):
      Revert "x86/efi: Fixup GOT in all boot code paths"
      fold swapping ->d_name.hash into switch_names()
      Linux 3.17-rc7

Loic Poulain (1):
      net: rfkill: gpio: Fix clock status

Luciano Coelho (1):
      iwlwifi: mvm: set MAC_FILTER_IN_BEACON correctly for STA/P2P client

Marc Kleine-Budde (3):
      can: flexcan: mark TX mailbox as TX_INACTIVE
      can: flexcan: put TX mailbox into TX_INACTIVE mode after tx-complete
      can: flexcan: increase FLEXCAN_MCR_MAXMB() macro to 7 bits

Marcel Holtmann (1):
      net: rfkill: gpio: Enable module auto-loading for ACPI based switches

Marcos Paulo de Souza (1):
      Input: i8042 - fix Asus X450LCP touchpad detection

Mark Einon (1):
      drivers: net: b44: Fix typo in returning multicast stats

Markos Chandras (2):
      Documentation: filter: Add MIPS to architectures with BPF JIT
      MIPS: mcount: Adjust stack pointer for static trace in MIPS32

Markus Niebel (1):
      ARM: DT: imx53: fix lvds channel 1 port

Markus Stockhausen (1):
      IB/mlx4: Disable TSO for Connect-X rev. A0 HCAs

Masanari Iida (1):
      net:bonding: Add missing space in bonding driver parameter description

Matan Barak (6):
      net/mlx4: Correctly configure single ported VFs from the host
      net/mlx4: Use the correct VSD mask in UPDATE_QP
      net/mlx4: Avoid dealing with MAC index in UPDATE_QP wrapper if not needed
      net/mlx4: Set vlan stripping policy by the right command
      mlx4: Correct error flows in rereg_mr
      IB/core: When marshaling uverbs path, clear unused fields

Mathias Krause (1):
      crypto: aesni - disable "by8" AVX CTR optimization

Matt Fleming (3):
      Revert "efi/x86: efistub: Move shared dependencies to <asm/efi.h>"
      x86/efi: Delete misleading efi_printk() error message
      x86/efi: Truncate 64-bit values when calling 32-bit OutputString()

Mauro Carvalho Chehab (1):
      [media] em28xx: fix VBI handling logic

Michal Marek (5):
      mips: Set CONFIG_NET=y in defconfigs
      parisc: Set CONFIG_NET=y in defconfigs
      powerpc: Set CONFIG_NET=y in defconfigs
      sh: Set CONFIG_NET=y in defconfigs
      sparc: Set CONFIG_NET=y in defconfigs

Michel Dänzer (3):
      drm/radeon: Clear RB_OVERFLOW bit earlier
      drm/radeon: Make IH ring overflow debugging output more useful
      drm/radeon: Update IH_RB_RPTR register after each processed interrupt

Mika Westerberg (1):
      ACPI / scan: Correct error return value of create_modalias()

Mike Looijmans (1):
      net/phy: micrel: Disable asymmetric pause for KSZ9031

Mike Marciniszyn (3):
      IB/ipath: Change get_user_pages() usage to always NULL vmas
      IB/qib: Change get_user_pages() usage to always NULL vmas
      IB/qib: Correct reference counting in debugfs qp_stats

Mikhail Efremov (1):
      vfs: Don't exchange "short" filenames unconditionally.

Mikko Perttunen (1):
      i2c: tegra: Move clk_prepare/clk_set_rate to probe

Miklos Szeredi (2):
      shmem: fix nlink for rename overwrite directory
      fuse: honour max_read and max_write in direct_io mode

Milosz Tanski (3):
      FS-Cache: Timeout for releasepage()
      FS-Cache: Reduce cookie ref count if submit fails.
      FS-Cache: refcount becomes corrupt under vma pressure.

Moni Shoua (5):
      IB/mlx4: Avoid null pointer dereference in mlx4_ib_scan_netdevs()
      IB/mlx4: Don't duplicate the default RoCE GID
      IB/mlx4: Reorder steps in RoCE GID table initialization
      IB/mlx4: Get upper dev addresses as RoCE GIDs when port comes up
      IB/mlx4: Avoid executing gid task when device is being removed

Mugunthan V N (2):
      drivers: net: cpsw: dual_emac: fix reducing of rx descriptor during ifdown
      drivers: net: cpsw: dual_emac: in suspend/resume bring down/up
all the netdev

Murali Karicheri (1):
      ARM: keystone: dts: fix bindings for pcie and usb clock nodes

Neil Horman (2):
      3c59x: Add dma error checking and recovery
      3c59x: Fix bad offset spec in skb_frag_dma_map

NeilBrown (9):
      cachefiles: remove two unused pagevecs.
      md/raid1: intialise start_next_window for READ case to avoid hang
      md/raid1:  be more cautious where we read-balance during resync.
      md/raid1: clean up request counts properly in close_sync()
      md/raid1: make sure resync waits for conflicting writes to complete.
      md/raid1: Don't use next_resync to determine how far resync has progressed
      md/raid1: update next_resync under resync_lock.
      md/raid1: count resync requests in nr_pending.
      md/raid1: fix_read_error should act on all non-faulty devices.

Nicolas Dichtel (2):
      genetlink: add function genl_has_listeners()
      macvlan: allow to enqueue broadcast pkt on virtual device

Nikolay Aleksandrov (1):
      bonding: fix div by zero while enslaving and transmitting

Nishanth Menon (3):
      clk: ti: divider: Provide error check for incoming parameters in set_rate
      clk: ti: dra7-atl: Provide error check for incoming parameters in set_rate
      bus: omap_l3_noc: Fix connID for OMAP4

Oliver Hartkopp (1):
      can: peak_pci: add PCI ID definition pcie card variant

Or Gerlitz (2):
      mlx4: Fix wrong endianess access with QP context flags
      IB/iser: Bump version to 1.4.1

Oren Givon (1):
      iwlwifi: add PCI IDs and add then new 3165 series

Pali Rohár (1):
      drivers/rtc/rtc-efi.c: add missing module alias

Paul Burton (1):
      MIPS: Fix MFC1 & MFHC1 emulation for 64-bit MIPS systems

Peter Feiner (2):
      mm: softdirty: addresses before VMAs in PTE holes aren't softdirty
      mm: softdirty: keep bit when zapping file pte

Peter Hüwe (1):
      i2c: acpi: Fix NULL Pointer dereference

Peter Ujfalusi (2):
      dmaengine: omap-dma: Add memory barrier to dma_resume path
      dmaengine: omap-dma: Restore the CLINK_CTRL in resume path

Prarit Bhargava (1):
      cpufreq: release policy->rwsem on error

Rafael J. Wysocki (2):
      ACPI / hotplug: Generate online uevents for ACPI containers
      Revert "PM / Hibernate: Iterate over set bits instead of PFNs in
swsusp_free()"

Randy Dunlap (4):
      scsi: fix build errors, SCSI_FC_ATTRS needs to depend on SCSI && NET
      scsi: use 'depends' instead of 'select' for SCSI_FC_ATTRS
      [media] media/radio: fix radio-miropcm20.c build with io.h header file
      MAINTAINERS: new Documentation maintainer

Rickard Strandqvist (1):
      parisc: pdc_stable.c: Cleaning up unnecessary use of memset in
conjunction with strncpy

Roger Quadros (2):
      ARM: dts: dra7-evm: Fix NAND GPMC timings
      can: c_can_platform: fix parameters of c_can_hw_raminit_ti()

Roi Dayan (1):
      IB/iser: Fix RX/TX CQ resource leak on error flow

Sabrina Dubroca (1):
      ipv6: clean up anycast when an interface is destroyed

Sagi Grimberg (1):
      IB/iser: Allow bind only when connection state is UP

Sam Bobroff (1):
      KVM: correct null pid check in kvm_vcpu_yield_to()

Samuel Gauthier (1):
      openvswitch: restore OVS_FLOW_CMD_NEW notifications

Sergei Shtylyov (1):
      i2c: rcar: fix RCAR_IRQ_ACK_{RECV|SEND}

Shawn Bohrer (1):
      IB: ib_umem_release() should decrement mm->pinned_vm from ib_umem_get

Shawn Guo (1):
      ARM: imx: fix .is_enabled() of shared gate clock

Srinivas Kandagatla (2):
      drivers/soc: qcom: do not disable the iface clock in probe
      of/fdt: fix memory range check

Srinivas Pandruvada (1):
      gpio / ACPI: Use pin index and bit length

Steffen Klassert (2):
      xfrm: Generate blackhole routes only from route lookup functions
      xfrm: Generate queueing routes only from route lookup functions

Stephen Boyd (1):
      clk: qcom: Fix sdc 144kHz frequency entry

Sujith Manoharan (1):
      Revert "ath9k: Calculate sleep duration"

Tadeusz Struk (1):
      crypto: qat - Enable all 32 IRQs

Tejun Heo (2):
      workqueue: apply __WQ_ORDERED to create_singlethread_workqueue()
      blk-mq, percpu_ref: implement a kludge for SCSI blk-mq stall during probe

Tero Kristo (1):
      clk: prevent erronous parsing of children during rate change

Tobias Klauser (1):
      dm9000: Return an ERR_PTR() in all error conditions of dm9000_parse_dt()

Tom Lendacky (1):
      crypto: ccp - Check for CCP before registering crypto algs

Tony Lindgren (2):
      ARM: OMAP: Fix Kconfig warning for omap1
      ARM: OMAP3: Fix I/O chain clock line assertion timed out error

Tony Luck (1):
      [IA64] refresh arch/ia64/configs/* using "make savedefconfig"

Uwe Kleine-König (1):
      clk/efm32gg: fix dt init prototype

Vlad Yasevich (4):
      bridge: Check if vlan filtering is enabled only once.
      bridge: Allow clearing of pvid and untagged bitmap
      bridge: Fix br_should_learn to check vlan_enabled
      tg3: Work around HW/FW limitations with vlan encapsulated frames

Vladimir Zapolskiy (1):
      genalloc: fix device node resource counter

Wanpeng Li (1):
      sched: Fix unreleased llc_shared_mask bit during CPU hotplug

Wojciech Dubowik (1):
      ath9k: Fix NULL pointer dereference on early irq

Wolfram Sang (1):
      i2c: move acpi code back into the core

Yinghai Lu (1):
      PCI: pciehp: Fix pcie_wait_cmd() timeout

Zefan Li (4):
      cgroup: fix unbalanced locking
      sched: fix confusing PFA_NO_NEW_PRIVS constant
      sched: add macros to define bitops for task atomic flags
      cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should be atomic flags

Zhaowei Yuan (1):
      [media] vb2: fix plane index sanity check in vb2_plane_cookie()

addy ke (1):
      i2c: rk3x: fix divisor calculation for SCL frequency

devesh.sharma@emulex.com (2):
      RDMA/ocrdma: Resolve L2 address when creating user AH
      RDMA/ocrdma: Use right macro in query AH

hayeswang (4):
      r8169: fix the default setting of rx vlan
      r8169: fix setting rx vlan
      r8169: adjust __rtl8169_set_features
      r8152: disable ALDPS

sundarjdev (1):
      hwmon: (tmp103) Fix resource leak bug in tmp103 temperature sensor driver
