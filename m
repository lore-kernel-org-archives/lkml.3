Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaIOBwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 21:52:10 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:42185 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaIOBwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 21:52:06 -0400
MIME-Version: 1.0
Date: Sun, 14 Sep 2014 18:52:04 -0700
X-Google-Sender-Auth: wkNS31lBqEIwTUty6wz3FyCk9G0
Message-ID: <CA+55aFy=m7Wmo5DjzL15Vvf4WOaC8UFj7NjUX2pfBYBA=sEQKw@mail.gmail.com>
Subject: Linux 3.17-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I should probably have delayed this until Wednesday for sentimental
reasons: that will be 23 years since I uploaded the 0.01 source tree.
But I'm not an overly sentimental person, so screw that. I'm doing my
normal Sunday release.

And as I mentioned in the rc4 notes, the previous rc was pretty small,
possibly because neither Greg nor Davem had sent in any updates that
week. Guess what? David's networking updates came in an hour after I
did rc4, and sure enough Greg came in this week too, so - surprise
surprise - rc5 isn't as small as rc4 was.

Oh well. It was too good to last.

I also got a report of an *old* performance regression in the dentry
cache (since 3.10 - positively ancient), and that in turn made me look
around some more, and there were a few other special cases that could
cause us to not do as well as we should. I fixed some of it, and Al
fixed the rest. So hopefully we not only fixed the reported
regression, but are actually doing better than we used to.

Anyway, the size of rc5 means that I'm certainly not cutting the
release early, which means that I will have to think about exactly
what I will do about the next merge window. Because it looks like it
might end up conflicting with my travel around LinuxCon EU. I haven't
quite decided what I'll do - I might release 3.17 normally, but then
just not open the merge window due to travel. Or, if there are more
issues than I think there will be, maybe I'll delay the 3.17 release.

We'll see.

Regardless - the rc5 changes is about half drivers (networking, gpu,
usb, input, ata..) with the rest being mostly a mix of filesystem
updates (the aforementioned performance thing in the core vfs layer,
but also some NFS export issues found by Al and misc other stuff),
architecture updates (arm, parisc, s390) and core networking. And a
smattering of other. Shortlog appended.

In other words, things look fairly normal, even if I'd have been
happier with rc5 being smaller. But with the bump from networking and
drivers, I'm not going to claim that this was either unexpected or
particularly scary. I'm hoping we're done now, and that rc6 and rc7
will be noticeably calmer.

Knock wood.

                      Linus

---

Al Cooper (1):
      usb: xhci: Fix OOPS in xhci error handling code

Al Viro (8):
      udf: merge the pieces inserting a new non-directory object into directory
      udf: fix the udf_iget() vs. udf_new_inode() races
      udf: saner calling conventions for udf_new_inode()
      [fix] lustre: d_make_root() does iput() on dentry allocation failure
      move the call of __d_drop(anon) into __d_materialise_unique(dentry, anon)
      fix bogus read_seqretry() checks introduced in b37199e
      don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()
      be careful with nd->inode in path_init() and follow_dotdot_rcu()

Alan Cox (1):
      serial: 8250_dw: Add ACPI ID for Intel Braswell

Alan Stern (2):
      USB: document the 'u' flag for usb-storage quirks parameter
      Block: fix unbalanced bypass-disable in blk_register_queue

Alban Crequy (1):
      cgroup: reject cgroup names with '\n'

Alex Deucher (3):
      drm/radeon: only use me/pfp sync on evergreen+
      drm/radeon: add connector quirk for fujitsu board
      drm/radeon/dpm: set the thermal type properly for special configs

Alexander Aring (2):
      ieee802154: 6lowpan_rtnl: fix correct errno value
      ieee802154: 6lowpan: ensure of sending 1280 packets

Alexander Y. Fomichev (1):
      net: prevent of emerging cross-namespace symlinks

Alexey Khoroshilov (1):
      at76c50x-usb: fix use after free on failure path in at76_probe()

Anand Moon (1):
      cpufreq / OPP: Fix the order of arguments for kcalloc()

Andrew Hunter (1):
      jiffies: Fix timeval conversion to jiffies

Andrey Vagin (2):
      fsnotify/fdinfo: use named constants instead of hardcoded values
      fs/notify: don't show f_handle if exportfs_encode_inode_fh failed

Andy King (1):
      VMXNET3: Check for map error in vmxnet3_set_mc

Andy Shevchenko (1):
      drm/radeon: reduce memory footprint for debugging

Anish Bhatt (1):
      cnic : Cleanup CONFIG_IPV6 & VLAN check

Anssi Hannula (1):
      dm cache: fix race causing dirty blocks to be marked as clean

Anton Blanchard (1):
      powerpc/perf: Fix ABIv2 kernel backtraces

Bartlomiej Zolnierkiewicz (2):
      net: sh_eth: fix driver dependencies
      net: calxedaxgmac: fix driver dependencies

Bin Liu (1):
      usb: musb: cppi41: fix not transmitting zero length packet issue

Bjørn Mork (4):
      USB: sierra: avoid CDC class functions on "68A3" devices
      USB: sierra: add 1199:68AA device ID
      Revert "ACPI / battery: Fix warning message in acpi_battery_get_state()"
      Revert "ACPI / battery: fix wrong value of capacity_now reported
when fully charged"

Bob Copeland (1):
      mac80211: mesh_plink: handle confirm frames with new plid

Chen Gang (3):
      drivers/net/fddi/skfp/h/skfbi.h: Remove useless PCI_BASE_2ND macros
      arch/microblaze/include/asm/entry.h: Include "linux/linkage.h"
to avoid compiling issue
      arch/microblaze/include/asm/uaccess.h: Use pr_devel() instead of
pr_debug()

Chris Mason (2):
      Btrfs: fix autodefrag with compression
      Btrfs: use insert_inode_locked4 for inode creation

Chris Wilson (2):
      drm/i915: Prevent recursive deadlock on releasing a busy userptr
      drm/i915: Evict CS TLBs between batches

Christian König (1):
      drm/radeon: fix semaphore value init

Chuansheng Liu (1):
      ata: Disabling the async PM for JMicron chip 363/361

Cong Wang (1):
      nfs: fix kernel warning when removing proc entry

Cyril Bur (1):
      powerpc: Make CONFIG_FHANDLE=y for all 64 bit powerpc defconfigs

Dan Carpenter (3):
      irqchip: crossbar: Off by one bugs in init
      parisc: sys_hpux: NUL terminator is one past the end
      Btrfs: kfree()ing ERR_PTRs

Daniel Borkmann (2):
      netfilter: x_tables: allow to use default cgroup match
      net: sctp: fix ABI mismatch through sctp_assoc_to_state helper

Daniel Hellstrom (1):
      greth: moved TX ring cleaning to NAPI rx poll func

Daniel Vetter (2):
      drm/i915: Fix EIO/wedged handling in gem fault handler
      drm/i915: Fix irq enable tracking in driver load

Dave Jiang (1):
      ntb: Add alignment check to meet hardware requirement

David Drysdale (1):
      shm: add memfd.h to UAPI export list

David Howells (1):
      KEYS: Fix termination condition in assoc array garbage collection

David S. Miller (1):
      mvneta: Add missing if_vlan.h include.

David Vrabel (3):
      xen/balloon: cancel ballooning if adding new memory failed
      xen/gntalloc: fix oops after runnning out of grant refs
      xen/gntalloc: safely delete grefs in add_grefs() undo path

Denton Gentry (1):
      mac80211: fix start_seq_num in Rx reorder offload

Dmitry Torokhov (1):
      Input: synaptics - add support for ForcePads

Eliad Peller (1):
      regulatory: add NUL to alpha2

Emmanuel Grumbach (2):
      Revert "iwlwifi: dvm: don't enable CTS to self"
      iwlwifi: bump firmware API version to 10 for 7000 and 8000

Eric Dumazet (1):
      net: attempt a single high order allocation

Eugene Crosser (1):
      qeth: don't query for info if hardware not ready.

Felipe Balbi (5):
      usb: dwc3: core: fix order of PM runtime calls
      usb: dwc3: core: fix ordering for PHY suspend
      usb: dwc3: omap: fix ordering for runtime pm calls
      usb: dwc3: fix TRB completion when multiple TRBs are started
      usb: host: xhci: fix compliance mode workaround

Felix Fietkau (2):
      mac80211: ignore AP_VLAN in ieee80211_recalc_chanctx_chantype
      mac80211: fix smps mode check for AP_VLAN

Filipe Manana (3):
      Btrfs: fix corruption after write/fsync failure + fsync + log recovery
      Btrfs: fix crash while doing a ranged fsync
      Btrfs: fix fsync data loss after a ranged fsync

Fu Zhonghui (1):
      ACPI / LPSS: complete PM entries for LPSS power domain

Geert Uytterhoeven (1):
      drivers: net: NET_XGENE should depend on HAS_DMA

Gerhard Stenzel (1):
      vxlan: fix incorrect initializer in union vxlan_addr

Giuseppe CAVALLARO (11):
      stmmac: fix rx checksum programming
      stmmac: set ptp_clock to NULL while unregister
      phy: fix EEE checks inside the phy_init_eee.
      stmmac: prevent false carrier sense detection
      stmmac: fix tipo on mmc crc error
      stmmac: ptp: fix the reference clock
      stmmac: fix dma api misuse
      stmmac: never check EEE in case of a switch is attached
      stmmac: fix PLS bit setting when EEE is active
      stmmac: fix the rx csum feature
      stmmac: only remove RXCSUM feature if no rx coe is available

Guillaume Nault (1):
      l2tp: fix race while getting PMTU on PPP pseudo-wire

Guy Martin (1):
      parisc: Implement new LWS CAS supporting 64 bit operations.

Hans Wennborg (2):
      parisc: dino: fix %d confusingly prefixed with 0x in format string
      iommu/arm-smmu: fix decimal printf format specifiers prefixed with 0x

Hans de Goede (5):
      Input: elantech - fix detection of touchpad on ASUS s301l
      Input: add INPUT_PROP_POINTING_STICK property
      Input: add missing POINTER / DIRECT properties to a bunch of drivers
      uas: Disable uas on ASM1051 devices
      uas: Add missing le16_to_cpu calls to asm1051 / asm1053 usb-id check

Hariprasad Shenai (6):
      cxgb4: Fix for handling 1Gb/s SFP+ Transceiver Modules
      cxgb4: Fixed the code to use correct length for part number
      cxgb4: Fix T5 adapter accessing T4 adapter registers
      cxgb4: Detect and display firmware reported errors
      cxgb4: Avoid dumping Write-only registers in register dump
      cxgb4: Issue mbox commands on correct mbox

Hauke Mehrtens (1):
      bcma: add PCI ID for spromless BCM43217

Helge Deller (1):
      parisc: Wire up seccomp, getrandom and memfd_create syscalls

Himangi Saraogi (1):
      rtlwifi: btcoexist: adjust double test

Honggang Li (1):
      percpu: free percpu allocation info for uniprocessor system

Ilya Dryomov (3):
      rbd: avoid format-security warning inside alloc_workqueue()
      libceph: add process_one_ticket() helper
      libceph: do not hard code max auth ticket len

Ivan T. Ivanov (2):
      usb: chipidea: msm: Use USB PHY API to control PHY state
      usb: chipidea: msm: Initialize PHY on reset event

Ivan Vecera (1):
      tg3: prevent ifup/ifdown during PCI error recovery

J. Bruce Fields (2):
      nfsd4: fix rd_dircount enforcement
      lockd: fix rpcbind crash on lockd startup failure

James Ralston (2):
      ahci: Add Device IDs for Intel 9 Series PCH
      ata_piix: Add Device IDs for Intel 9 Series PCH

Jan Kara (6):
      udf: Avoid dir link count to go negative
      udf: Fold udf_fill_inode() into __udf_read_inode()
      udf: Avoid infinite loop when processing indirect ICBs
      udf: Make udf_read_inode() and udf_iget() return error
      udf: Properly detect stale inodes
      udf: Set i_generation field

Jean-Michel Hautbois (1):
      Lattice ECP3 FPGA: Check firmware pointer

Jeff Layton (1):
      nfs: revert "nfs4: queue free_lock_state job submission to nfsiod"

Jens Axboe (1):
      blk-mq: scale depth and rq map appropriate if low on memory

Joe Lawrence (1):
      usb: hub: take hub->hdev reference when processing from eventlist

Joe Perches (1):
      checkpatch: allow commit descriptions on separate line from commit id

Joerg Roedel (2):
      iommu/core: Make iommu_group_get_for_dev() more robust
      iommu/vt-d: Check return value of acpi_bus_get_device()

Johan Hedberg (1):
      Bluetooth: Fix hci_conn reference counting for auto-connections

Johan Hovold (3):
      USB: zte_ev: fix removed PIDs
      USB: ftdi_sio: add support for NOVITUS Bono E thermal printer
      USB: zte_ev: fix removed PIDs

Johannes Berg (2):
      Revert "mac80211: disable uAPSD if all ACs are under ACM"
      mac80211: fix agg_status debugfs file alignment

John Sung (1):
      Input: serport - add compat handling for SPIOCSTYPE ioctl

Jon Mason (2):
      NTB: correct the spread of queues over mw's
      MAINTAINERS: update NTB info

Jonas Jensen (4):
      net: moxa: clear DESC1 on ndo_start_xmit()
      net: moxa: replace build_skb() with netdev_alloc_skb_ip_align() / memcpy()
      net: moxa: synchronize DMA memory
      net: moxa: continue loop on skb allocation failure

Julian Anastasov (2):
      ipvs: properly declare tunnel encapsulation
      ipvs: fix ipv6 hook registration for local replies

Kamil Debski (3):
      MAINTAINERS: add entry for the Samsung USB2 PHY driver
      usb: dwc2/gadget: fix phy disable sequence
      usb: dwc2/gadget: fix phy initialization sequence

Keith Busch (1):
      block: Fix dev_t minor allocation lifetime

Klaus Goger (1):
      Input: cap1106 - fix register definition

Kuninori Morimoto (1):
      dt/bindings: rcar-audmapp: tidyup dmas explanation

Larry Finger (1):
      rtlwifi: rtl8192cu: Add new ID

Lars-Peter Clausen (2):
      tty: xuartps: Fix tx_emtpy() callback
      dmaengine: jz4740: Fix non-cyclic descriptor completion

Lee Jones (1):
      phy: miphy365x: Select GENERIC_PHY instead of depending on it

Lee, Chun-Yi (1):
      ACPI / RTC: Fix CMOS RTC opregion handler accesses to wrong addresses

Lendacky, Thomas (7):
      amd-xgbe: Check for Tx hardware queue flushing support
      amd-xgbe: Reported fifo size from hardware is not correct
      amd-xgbe: Fix the xpcs mmd debugfs support
      amd-xgbe: Use the Tx queue count for Tx flow control support
      amd-xgbe: Fix initialization of the wrong spin lock
      amd-xgbe: Treat certain counter registers as 64 bit
      amd-xgbe: Enable interrupts for all management counters

Li RongQing (2):
      openvswitch: fix a memory leak
      openvswitch: distinguish between the dropped and consumed skb

Li Zefan (2):
      cgroup: delay the clearing of cgrp->kn->priv
      cgroup: check cgroup liveliness before unbreaking kernfs

Li Zhong (1):
      powerpc: use machine_subsys_initcall() for opal_hmi_handler_init()

Linus Torvalds (5):
      Make ARCH_HAS_FAST_MULTIPLIER a real config variable
      Make hash_64() use a 64-bit multiply when appropriate
      vfs: fix bad hashing of dentries
      vfs: avoid non-forwarding large load after small store in path lookup
      Linux 3.17-rc5

Lothar Waßmann (1):
      Input: matrix_keypad - use request_any_context_irq()

Maarten Lankhorst (1):
      android: fix reference leak in sync_fence_create

Maks Naumov (1):
      ath9k: fix wrong string size for strncmp in write_file_spec_scan_ctl()

Manish Chopra (1):
      bnx2x: Configure device endianity on driver load and reset
endianity on removal.

Marcel Holtmann (1):
      iwlwifi: Remove module build requirement for Intel Wireless WiFi

Marek Szyprowski (3):
      usb: dwc2/gadget: break infinite loop in endpoint disable code
      usb: dwc2/gadget: do not call disconnect method in pullup
      usb: dwc2/gadget: delay enabling irq once hardware is configured properly

Mark (1):
      storage: Add single-LUN quirk for Jaz USB Adapter

Mark Brown (2):
      irqchip: gic-v3: Only define gic_peek_irq() when building SMP
      irqchip: gic-v3: Tag all low level accessors __maybe_unused

Mark Charlebois (1):
      drm/msm: Change nested function to static function

Martin Schwidefsky (1):
      s390/vdso: remove NULL pointer check from clock_gettime

Martin Townsend (3):
      mac802154: fixed potential skb leak with mac802154_parse_frame_start
      ieee802154: mac802154: handle the reserved dest mode by dropping
the packet
      ieee802154: 6lowpan: ensure MTU of 1280 for 6lowpan

Masanari Iida (2):
      net: treewide: Fix typo found in DocBook/networking.xml
      Input: wm971x - fix typo in module parameter description

Mathias Nyman (3):
      pinctrl: baytrail: resolve unbalanced IRQ wake disable warning
      xhci: Fix null pointer dereference if xhci initialization fails
      xhci: fix oops when xhci resumes from hibernate with hw lpm
capable devices

Michael Holzheu (1):
      s390/ipl: Add missing SCSI loadparm attributes to /sys/firmware

Michal Kubeček (1):
      net: fix checksum features handling in netif_skb_features()

Michal Simek (3):
      microblaze: Add mm/Kconfig to advance menu
      microblaze: Rename Advance setup to Kernel features
      microblaze: Fix number of syscalls

Mika Westerberg (1):
      net: rfkill: gpio: Add more Broadcom bluetooth ACPI IDs

Mikko Perttunen (1):
      ata: ahci_tegra: Read calibration fuse

Ming Lei (1):
      blk-merge: fix blk_recount_segments

Mitchel Humpherys (1):
      iommu/arm-smmu: avoid calling request_irq in atomic context

Murali Karicheri (1):
      ahci: add pcid for Marvel 0x9182 controller

Namjae Jeon (6):
      cifs: fix a possible null pointer deref in decode_ascii_ssetup
      cifs: fix memory leak when password is supplied multiple times
      cifs: fix a possible use of uninit variable in SMB2_sess_setup
      cifs: remove unneeded check of null checking in if condition
      cifs: Allow directIO read/write during cache=strict
      cifs: No need to send SIGKILL to demux_thread during umount

Naveen Krishna Chatradhi (1):
      irqchip: exynos-combiner: Fix compilation error on ARM64

Neil Horman (1):
      3c59x: avoid panic in boomerang_start_xmit when finding page address:

Nick Dyer (1):
      Input: atmel_mxt_ts - downgrade warning about empty interrupts

Nicolas Dichtel (2):
      ipv6: fix a refcnt leak with peer addr
      ipv6: use addrconf_get_prefix_route() to remove peer addr

Nicolas Iooss (1):
      eventpoll: fix uninitialized variable in epoll_ctl

Olav Haugan (2):
      iommu/arm-smmu: fix programming of SMMU_CBn_TCR for stage 1
      iommu/arm-smmu: Do not access non-existing S2CR registers

Or Gerlitz (2):
      net/mlx4: Move the tunnel steering helper function to mlx4_core
      mlx4: Set user-space raw Ethernet QPs to properly handle VXLAN traffic

Pablo Neira (1):
      netfilter: fix missing dependencies in NETFILTER_XT_TARGET_LOG

Pablo Neira Ayuso (4):
      netfilter: move NAT Kconfig switches out of the iptables scope
      netfilter: nf_tables: nat expression must select CONFIG_NF_NAT
      netfilter: NETFILTER_XT_TARGET_LOG selects NF_LOG_*
      netfilter: add explicit Kconfig for NETFILTER_XT_NAT

Patrick Palka (1):
      kernel/printk/printk.c: fix faulty logic in the case of recursive printk

Pavel Shilovsky (3):
      CIFS: Fix directory rename error
      CIFS: Fix wrong restart readdir for SMB1
      CIFS: Fix wrong filename length for SMB2

Pawel Moll (1):
      video: ARM CLCD: Fix color model capabilities for DT platforms

Peter Chen (2):
      usb: phy: mxs: add imx6sx support
      doc: dt: mxs-phy: add compatible string for imx6sx-usbphy

Peter Oberparleiter (1):
      s390/dasd: Make module parameter visible in sysfs

Piotr Król (1):
      usb: usbip: fix usbip.h path in userspace tool

Pranith Kumar (1):
      powerpc: Wire up sys_seccomp(), sys_getrandom() and sys_memfd_create()

Rasmus Villemoes (2):
      usb: gadget: fusb300_udc.h: Fix typo in include guard
      kcmp: fix standard comparison bug

Ricardo Ribalda Delgado (1):
      usb: gadget: net2280: Fix invalid handling of Reset irq

Richard Genoud (1):
      tty/serial: at91: BUG: disable interrupts when !UART_ENABLE_MS()

Richard Larocque (3):
      alarmtimer: Return relative times in timer_gettime
      alarmtimer: Do not signal SIGEV_NONE timers
      alarmtimer: Lock k_itimer during timer callback

Rob Clark (2):
      drm/msm/hdmi: fix build break on non-CCF platforms
      drm/msm: don't crash if no msm.vram param

Robert Baldyga (2):
      usb: gadget: f_fs: fix the redundant ep files problem
      usb: dwc2/gadget: avoid disabling ep0

Robert Elliott (2):
      blk-mq: pass along blk_mq_alloc_tag_set return values
      blk-mq: cleanup after blk_mq_init_rq_map failures

Roland Stigge (1):
      net: lpc_eth: Fix crash on ip link up

Ross Lagerwall (1):
      xen/manage: Always freeze/thaw processes when suspend/resuming

Russell King (2):
      imx-drm: ipuv3-plane: fix ipu_plane_dpms()
      imx-drm: imx-ldb: fix NULL pointer in imx_ldb_unbind()

Sabrina Dubroca (1):
      ipv6: fix rtnl locking in setsockopt for anycast and multicast

Sage Weil (1):
      libceph: gracefully handle large reply messages from the mon

Sasha Levin (1):
      mm/mmap.c: use pr_emerg when printing BUG related information

Sjoerd Simons (1):
      phy: exynos5-usbdrd: Add MODULE_DEVICE_TABLE entry

Stas Sergeev (1):
      sh: get_user_pages_fast() must flush cache

Stefan Bader (1):
      x86/xen: don't copy bogus duplicate entries into kernel page tables

Stefano Stabellini (3):
      xen/arm: introduce XENFEAT_grant_map_identity
      xen/arm: reimplement xen_dma_unmap_page & friends
      xen/arm: remove mach_to_phys rbtree

Stephen Warren (1):
      Input: atmel_mxt_ts - fix double free of input device

Steve French (2):
      Trivial whitespace fix
      Clarify Kconfig help text for CIFS and SMB2/SMB3

Sudeep Holla (1):
      arm64: use irq_set_affinity with force=false when migrating irqs

Suman Tripathi (2):
      ahci_xgene: Skip the PHY and clock initialization if already
configured by the firmware.
      ahci_xgene: Fix the link down in first attempt for the APM
X-Gene SoC AHCI SATA host controller driver.

Taylor Braun-Jones (1):
      USB: ftdi_sio: Add support for GE Healthcare Nemo Tracker device

Tejun Heo (2):
      percpu: fix pcpu_alloc_pages() failure path
      percpu: perform tlb flush after pcpu_map_pages() failure

Theodore Ts'o (1):
      ext4: avoid trying to kfree an ERR_PTR pointer

Thierry Reding (1):
      usb: phy: tegra: Avoid use of sizeof(void)

Thomas Falcon (1):
      powerpc/pseries: Fix endian issues in memory hotplug

Thomas Gleixner (1):
      futex: Unlock hb->lock in futex_wait_requeue_pi() error path

Thomas Pugliese (1):
      uwb: init beacon cache entry before registering uwb device

Tomasz Figa (1):
      MAINTAINERS: Tomasz has moved

Tomi Valkeinen (1):
      video: fix composite video connector compatible string

Tony Lindgren (2):
      usb: phy: twl4030-usb: Fix regressions to runtime PM on omaps
      usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down

Varun Sethi (1):
      iommu/fsl: Fix warning resulting from adding PCI device twice

Ville Syrjälä (1):
      drm/i915: Wait for vblank before enabling the TV encoder

Vivek Goyal (1):
      cgroup: Display legacy cgroup files on default hierarchy

Vlad Yasevich (8):
      e1000e: Fix TSO with non-accelerated vlans
      e1000: Fix TSO for non-accelerated vlan traffic
      bna: Support TSO and partial checksum with non-accelerated vlans.
      ehea: Fix TSO and hw checksums with non-accelerated vlan packets.
      i40e: Fix TSO and hw checksums for non-accelerated vlan packets.
      i40evf: Fix TSO and hw checksums for non-accelerated vlan packets.
      mvneta: Fix TSO and checksum for non-acceleration vlan traffic
      qlge: Fix TSO for non-accelerated vlan traffic

Vladimir Murzin (1):
      iommu/arm-smmu: remove pgtable_page_{c,d}tor()

WANG Cong (1):
      ipv6: restore the behavior of ipv6_sock_ac_drop()

Wei Liu (1):
      xen-netback: move netif_napi_add before binding interrupt

Wei Yongjun (1):
      rbd: fix error return code in rbd_dev_device_setup()

Weston Andros Adamson (1):
      pnfs: fix filelayout_retry_commit when idx > 0

Will Deacon (5):
      iommu/arm-smmu: fix s2cr and smr teardown on device detach from domain
      iommu/arm-smmu: fix corner cases in address size calculations
      irqchip: gic: Make gic_default_routable_irq_domain_ops static
      irqchip: gic-v3: Declare rdist as __percpu pointer to __iomem pointer
      arm64: flush TLS registers during exec

Willem de Bruijn (1):
      net-timestamp: only report sw timestamp if reporting bit is set

Xishi Qiu (1):
      mem-hotplug: let memblock skip the hotpluggable memory regions
in __next_mem_range()

Y.C. Chen (2):
      drm/ast: open key before detect chips
      drm/ast: AST2000 cannot be detected correctly

Yaniv Rosner (1):
      bnx2x: Fix link problems for 1G SFP RJ45 module

Yoshihiro Shimoda (4):
      usb: renesas_usbhs: fix the behavior of some usbhs_pkt_handle
      usb: renesas_usbhs: protect mod->irq_{bemp,brdy}sts by spin lock
      usb: renesas_usbhs: fix the condition of is_done in usbhsf_dma_push_done
      usb: renesas_usbhs: fix the usb_pkt_pop()

Zhouyi Zhou (1):
      netfilter: HAVE_JUMP_LABEL instead of CONFIG_JUMP_LABEL

Zhuang Jin Can (1):
      usb: dwc3: gadget: Fix desc NULL pointer in dwc3_gadget_ep_queue()

nandini sharma (2):
      stmmac: fix the EEE LPI Macro definitions.
      stmmac: fix LPI TW timer value to 20.5us.

Álvaro Fernández Rojas (1):
      ssb: add PCI ID 0x4351
