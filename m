Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbaEIUfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:35:37 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:56568 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377AbaEIUfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:35:34 -0400
MIME-Version: 1.0
Date: Fri, 9 May 2014 13:35:33 -0700
X-Google-Sender-Auth: hPHNc6NYz0RRMPl3KXSVKRjeqx8
Message-ID: <CA+55aFwiDKrrFrTvkEzvZLy8Yp6cLhNhk313fv5-dtspnfZxhQ@mail.gmail.com>
Subject: Linux 3.15-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I'm aware that this is two days early. The normal schedule has
been for me to do Sunday releases, but this time around I have a
combination of travel (which would have pushed the release to Saturday
morning from the airport as is oft my wont when traveling) and the
fact that rc5 has actually already grown to be larger than rc3 or rc4
were.

So instead of pushing it to the last minute before I board a plane and
am off-line for a week, I decided that there is absolutely zero reason
for that kind of just-under-the-wire release timing. I'd rather do a
leisurely release on a Friday afternoon than a hurried one tomorrow
morning before then disappearing for a week.

Anyway, enough explaining. rc5 is out there, and while I'd have been
happier if it had been as small as rc4 was, it seems to all be solid
fixes (famous last words). The interesting dcache list corruption I
mentioned as being pending for rc4 is in, and it would be lovely if
you have any VFS layer stress-testing that interacts with memory
pressure, but the race was tiny to begin with, and the fix actually
cleaned things up a lot and removed more lines than it added, so I
feel good about it.

Apart from that one interesting really core change (where "really
core" is defined as "an area I personally care about and muck around
with", and not meant to be a value statement in any other way ;), it
all looks boringly familiar: 55% drivers, 20% architecture updates,
and 25% misc (filesystems, core networking, VM, etc).

And while rc5 may be bigger than rc3/4 were, it's not like it is
worrying. This merge window was bigger than most, and the fact that
rc5 is then slightly bigger than most isn't something that worries me
overmuch. And since rc4 was smaller than usual, it all evens out.

But I really *will* be entirely unreachable all next week, so get your
testing in, because the -git tree will be very quiet.

                 Linus

---

Al Viro (9):
      fix races between __d_instantiate() and checks of dentry flags
      fold d_kill() and d_free()
      fold try_prune_one_dentry()
      new helper: dentry_free()
      expand the call of dentry_lru_del() in dentry_kill()
      dentry_kill(): don't try to remove from shrink list
      don't remove from shrink list in select_collect()
      more graceful recovery in umount_collect()
      nick kvfree() from apparmor

Alan Stern (1):
      USB: OHCI: fix problem with global suspend on ATI controllers

Alex Deucher (2):
      drm/radeon/dp: check for errors in dpcd reads
      drm/radeon: dpm updates for KV/KB

Alexander Stein (1):
      can: slcan: Fix spinlock variant

Alexei Starovoitov (1):
      net: filter: initialize A and X registers

Amos Kong (1):
      virtio_net: zero is an invald queue_pairs number

Andi Kleen (3):
      asmlinkage: Revert "lto: Make asmlinkage __visible"
      asmlinkage, x86: Add explicit __visible to arch/x86/*
      asmlinkage: Add explicit __visible to drivers/*, lib/*, kernel/*

Andres Freund (2):
      x86: Fix typo preventing msr_set/clear_bit from having an effect
      x86: Fix typo in MSR_IA32_MISC_ENABLE_LIMIT_CPUID macro

Andrew Lutomirski (1):
      net: Fix ns_capable check in sock_diag_put_filterinfo

Andy King (1):
      vsock: Make transport the proto owner

Anssi Hannula (1):
      ALSA: hda - hdmi: Set converter channel count even without sink

Artem Bityutskiy (1):
      UBIFS: fix remount error path

Atilla Filiz (1):
      iio:imu:mpu6050: Fixed segfault in Invensens MPU driver due to
null dereference

Balakumaran Kannan (1):
      net phy: Check for aneg completion before setting state to PHY_RUNNING

Ben Hutchings (2):
      net: Update my email address
      rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init()

Ben Skeggs (2):
      drm/nouveau/bios: fix shadowing from PROM on big-endian systems
      drm/gm107/gr: bump attrib cb size quite a bit

Benjamin Tissoires (1):
      HID: core: fix computation of the report size

Bjørn Mork (9):
      net: qmi_wwan: add Sierra Wireless EM7355
      net: qmi_wwan: add Sierra Wireless MC73xx
      net: qmi_wwan: add Sierra Wireless MC7305/MC7355
      net: qmi_wwan: add Olivetti Olicard 500
      net: qmi_wwan: add Alcatel L800MA
      net: qmi_wwan: add a number of CMOTech devices
      net: qmi_wwan: add a number of Dell devices
      usb: qcserial: add a number of Dell devices
      net: cdc_ncm: fix buffer overflow

Boris Ostrovsky (1):
      x86, vdso, time: Cast tv_nsec to u64 for proper shifting in
update_vsyscall()

Brendan Hickey (1):
      bpf_dbg: fix wrong register usage

Brian Foster (1):
      xfs: initialize default acls for ->tmpfile()

Byungho An (5):
      net: sxgbe: rearrange dma descriptor
      net: sxgbe: Added phy_found error path
      net: sxgbe: sw reset moved to probe function
      net: sxgbe: Added rxqueue enable function
      net: sxgbe: Added set function for interrupt on complete

Chris Cui (1):
      drivers/rtc/rtc-pcf8523.c: fix month definition

Christian Gmeiner (1):
      x86/reboot: Add reboot quirk for Certec BPC600

Christian König (5):
      drm/radeon/uvd: use lower clocks on old UVD to boot v2
      drm/radeon: use pflip irq on R600+ v2
      drm/radeon: avoid high jitter with small frac divs
      drm/radeon: check that we have a clock before PLL setup
      drm/radeon: lower the ref * post PLL maximum

Christoph Hellwig (2):
      fix quoting of Ted's name in MAINTAINERS
      posix_acl: handle NULL ACL in posix_acl_equiv_mode

Christoph Lameter (1):
      slub: use sysfs'es release mechanism for kmem_cache

Claudiu Manoil (2):
      gianfar: Check if phydev present on ethtool -A
      gianfar: Avoid unnecessary reg accesses in adjust_link()

Clemens Ladisch (1):
      ALSA: usb-audio: work around corrupted TEAC UD-H01 feedback data

Colin Ian King (1):
      rtlwifi: rtl8188ee: initialize packet_beacon

Dan Carpenter (2):
      agp: info leak in agpioc_info_wrap()
      agp: info leak in agpioc_info_wrap()

Daniel Vetter (1):
      drm/i915: Sanitize the enable_ppgtt module option once

Daniele Forsi (2):
      usb: storage: shuttle_usbat: fix discs being detected twice
      USB: Nokia 5300 should be treated as unusual dev

Dave Chinner (2):
      xfs: fully support v5 format filesystems
      xfs: remote attribute overwrite causes transaction overrun

Dave Young (1):
      x86/efi: earlyprintk=efi,keep fix

David Ertman (4):
      e1000e: Workaround for dropped packets in Gig/100 speeds on 82579
      e1000e: Expand workaround for 10Mb HD throughput bug
      e1000e: Fix issue with link flap on 82579
      e1000e: Restrict MDIO Slow Mode workaround to relevant parts

David Gibson (2):
      rtnetlink: Warn when interface's information won't fit in our packet
      rtnetlink: Only supply IFLA_VF_PORTS information when
RTEXT_FILTER_VF is set

David Miller (1):
      slab: Fix off by one in object max number tests.

David S. Miller (14):
      netfilter: Fix warning in nfnetlink_receive().
      sparc64: Fix argument sign extension for compat_sys_futex().
      sparc64: Normalize NMI watchdog logging and behavior.
      sparc64: Fix executable bit testing in set_pmd_at() paths.
      sparc64: Fix huge PMD invalidation.
      sparc64: Fix bugs in get_user_pages_fast() wrt. THP.
      sparc64: Fix hex values in comment above pte_modify().
      sparc64: Don't use _PAGE_PRESENT in pte_modify() mask.
      sparc64: Handle 32-bit tasks properly in compute_effective_address().
      sparc64: Fix top-level fault handling bugs.
      sparc64: Fix range check in kern_addr_valid().
      sparc64: Use 'ILOG2_4MB' instead of constant '22'.
      sparc64: Add basic validations to {pud,pmd}_bad().
      sparc64: Give more detailed information in {pgd,pmd}_ERROR() and
kill pte_ERROR().

Doug Anderson (1):
      iio: adc: Nothing in ADC should be a bool CONFIG

Dr. H. Nikolaus Schaller (2):
      Input: bma150 - extend chip detection for bma180
      Input: tca8418 - fix loading this driver as a module from a device tree

Egbert Eich (1):
      drm/i915: Break encoder->crtc link separately in intel_sanitize_crtc()

Eric Dumazet (1):
      tcp: increment retransmit counters in tlp and fast open

Eric W. Biederman (5):
      netlink: Rename netlink_capable netlink_allowed
      net: Move the permission check in sock_diag_put_filterinfo to
packet_diag_dump
      net: Add variants of capable for use on on sockets
      net: Add variants of capable for use on netlink messages
      net: Use netlink_ns_capable to verify the permisions of netlink messages

Eyal Perry (1):
      net/mlx4_core: Don't issue PCIe speed/width checks for VFs

Ezequiel Garcia (1):
      net: mvmdio: Check for a valid interrupt instead of an error

Fabian Frederick (2):
      fuse: add __exit to fuse_ctl_cleanup
      fs/affs/super.c: bugfix / double free

Felix Fietkau (2):
      ath9k_hw: do not lower ANI setting below default on AR913x
      ath9k: remove tid->paused flag

Feng Tang (2):
      x86/hpet: Make boot_hpet_disable extern
      x86/intel: Add quirk to disable HPET for the Baytrail platform

Florian Fainelli (1):
      MAINTAINERS: SXGBE authors update

Francois Romieu (1):
      i40e: remove open-coded skb_cow_head

Geert Uytterhoeven (2):
      xtensa: Export __invalidate_icache_range
      Altera TSE: ALTERA_TSE should depend on HAS_DMA

George Spelvin (1):
      x86-64, build: Fix stack protector Makefile breakage with 32-bit userland

Gertjan van Wingerde (1):
      rt2x00: Remove myself as maintainer.

H. Peter Anvin (1):
      x86, build: Don't get confused by local symbols

Hans de Goede (4):
      Input: synaptics - add min/max quirk for ThinkPad Edge E431
      brcmfmac: Fix brcmf_chip_ai_coredisable not applying reset bits
to BCMA_IOCTL
      HID: add NO_INIT_REPORTS quirk for Synaptics Touch Pad V 103S
      Input: elantech - fix touchpad initialization on Gigabyte U2442

Hariprasad Shenai (1):
      cxgb4: Update Kconfig to include Chelsio T5 adapter

Heiko Stübner (2):
      arc_emac: fix probe error path
      arc_emac: add clock handling

Hiroaki SHIMODA (1):
      e1000e: Enclose e1000e_pm_thaw() with CONFIG_PM_SLEEP

Hubert Chaumette (1):
      net/phy: micrel: fix bugged test on device tree loading for ksz9021

Hui Wang (1):
      ALSA: hda - add headset mic detect quirk for a Dell laptop

Ian Kent (1):
      autofs: fix lockref lookup

Ilia Mirkin (1):
      drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi

Ilya Dryomov (1):
      libceph: fix non-default values check in apply_primary_affinity()

Jack Morgenstein (1):
      net/mlx4_core: Adjust port number in qp_attach wrapper when detaching

Jacob Keller (1):
      i40e: fix Timesync Tx interrupt handler code

Jakub Kicinski (2):
      ixgbe: clean up Rx time stamping code
      e1000e/igb/ixgbe/i40e: fix message terminations

Jean Delvare (1):
      net: cadence: Fix architecture dependencies

Jean-Jacques Hiblot (1):
      usb: gadget: at91-udc: fix irq and iomem resource retrieval

Jesse Brandeburg (1):
      i40e: fix TCP flag replication for hardware offload

Jimmy Li (1):
      staging:iio:ad2s1200 fix missing parenthesis in a for statment.

Jiri Pirko (1):
      team: forbid incorrect fall-through in notifier

Johan Hedberg (2):
      Bluetooth: Fix triggering BR/EDR L2CAP Connect too early
      Bluetooth: Fix redundant encryption request for reauthentication

Johannes Weiner (2):
      mm: filemap: update find_get_pages_tag() to deal with shadow entries
      revert "mm: vmscan: do not swap anon pages just because free+file is low"

John Fastabend (1):
      net: sched: lock imbalance in hhf qdisc

Joonsoo Kim (1):
      slab: fix the type of the index on freelist index accessor

Julia Lawall (1):
      hisax/icc: add missing semicolon after label

Julian Anastasov (1):
      net: ipv6: more places need LOOPBACK_IFINDEX for flowi6_iif

KY Srinivasan (1):
      hyperv: Properly handle checksum offload

Karl Heiss (1):
      net: sctp: Don't transition to PF state when transport has
exhausted 'Path.Max.Retrans'.

Kees Cook (1):
      UBI: avoid workqueue format string leak

Kirill Tkhai (1):
      sparc64: Make itc_sync_lock raw

Kumar Sundararajan (1):
      ipv6: fib: fix fib dump restart

Larry Finger (1):
      rtlwifi: rtl8192se: Fix regression due to commit 1bf4bbb

Leo Liu (2):
      drm/radeon: check buffer relocation offset
      drm/radeon: add Mullins VCE support

Li Jun (1):
      usb: phy: fsm: update OTG HNP state transition

Linus Torvalds (1):
      Linux 3.15-rc5

Liu Yu (1):
      tcp_cubic: fix the range of delayed_ack

Maarten Lankhorst (2):
      drm/nouveau: fix another lock unbalance in nouveau_crtc_page_flip
      drm/radeon: drm/radeon: add missing radeon_semaphore_free to error path

Marcel Holtmann (1):
      Revert "Bluetooth: Enable autosuspend for Intel Bluetooth device"

Masanari Iida (1):
      net: bonding: Fix format string mismatch in bond_sysfs.c

Matan Barak (1):
      net/mlx4_core: Fix slave id computation for single port VF

Mathieu Desnoyers (1):
      tracepoint: Fix use of tracepoint funcs after rcu free

Matthew Daley (2):
      floppy: ignore kernel-only members in FDRAWCMD ioctl input
      floppy: don't write kernel-only members to FDRAWCMD ioctl output

Max Filippov (13):
      xtensa: export __{invalidate,flush}_dcache_range
      xtensa: enable sorting extable at build time
      xtensa: split bootparam and kernel meminfo
      xtensa: keep sysmem banks ordered in add_sysmem_bank
      xtensa: keep sysmem banks ordered in mem_reserve
      xtensa: handle memmap kernel option
      xtensa: dump sysmem from the bootmem_init
      xtensa: optimize local_flush_tlb_kernel_range
      xtensa: add HIGHMEM support
      xtensa: xtfpga: introduce SoC I/O bus
      xtensa: add support for KC705
      xtensa: xt2000: drop redundant sysmem initialization
      xtensa: ISS: don't depend on CONFIG_TTY

Max Schwarz (1):
      arc_emac: write initial MAC address from devicetree to hw

Maxim Patlasov (6):
      fuse: do not use uninitialized i_mode
      fuse: update mtime on truncate(2)
      fuse: update mtime on open(O_TRUNC) in atomic_o_trunc mode
      fuse: allow ctime flushing to userspace
      fuse: trust kernel i_ctime only
      fuse: clear FUSE_I_CTIME_DIRTY flag on setattr

Michael Welling (1):
      tty: serial: 8250_core.c Bug fix for Exar chips.

Michel Dänzer (1):
      drm/radeon: Fix num_banks calculation for SI

Micky Ching (1):
      mmc: rtsx: Revert "mmc: rtsx: add support for pre_req and post_req"

Miklos Szeredi (10):
      fuse: check fallocate mode
      fuse: fix mtime update error in fsync
      fuse: fuse: fallocate: use file_update_time()
      fuse: clean up fsync
      fuse: add .write_inode
      fuse: fuse: add time_gran to INIT_OUT
      fuse: remove .update_time
      fuse: clear MS_I_VERSION
      fuse: add renameat2 support
      dcache: don't need rcu in shrink_dentry_list()

Mohammed Habibulla (1):
      Bluetooth: Add support for Lite-on [04ca:3007]

Murali Karicheri (1):
      mtd: davinci-nand: disable subpage write for keystone-nand

Narender Kumar (1):
      bnx2x: Fix failure to configure VF multicast filters

Naveen Krishna Ch (1):
      iio: exynos_adc: use indio_dev->dev structure to handle child nodes

Nicolas Dichtel (1):
      vxlan: ensure to advertise the right fdb remote

Nikita Yushchenko (1):
      fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6

Nishanth Aravamudan (1):
      hugetlb: ensure hugepage access is denied if hugepages are not supported

Oliver Hartkopp (3):
      can: sja1000_isa: add locking for indirect register access mode
      can: fix return value from can_get_bittiming()
      slip: fix spinlock variant

Or Gerlitz (1):
      net/mlx4_core: Load the Eth driver first

Paulo Zanoni (1):
      drm/i915: don't try DP_LINK_BW_5_4 on HSW ULX

Peter Chen (1):
      usb: phy: fsm: change "|" to "||" for condition
OTG_STATE_A_WAIT_BCON at statemachine

Peter F. Patel-Schneider (1):
      HID: sensor-hub: Add in quirk for sensor hub in Lenovo Ideapad Yogas

Peter Hurley (3):
      n_tty: Fix n_tty_write crash when echoing in raw mode
      Revert "tty: Fix race condition between
__tty_buffer_request_room and flush_to_ldisc"
      tty: Fix lockless tty buffer race

Rajesh Borundia (1):
      qlcnic: Fix memory leak.

Rajkumar Manoharan (1):
      ath9k: fix race in setting ATH_OP_INVALID

Rik van Riel (1):
      mm/page-writeback.c: fix divide by zero in pos_ratio_polynom

Roland Dreier (1):
      cxgb4: Decode PCIe Gen3 link speed

Romain Izard (1):
      trace: module: Maintain a valid user count

Samuel Li (6):
      drm/radeon: add Mullins chip family
      drm/radeon: update cik init for Mullins.
      drm/radeon: add Mullins UVD support.
      drm/radeon: add Mullins dpm support.
      drm/radeon: modesetting updates for Mullins.
      drm/radeon: add pci ids for Mullins

Sander Eikelenboom (1):
      ALSA: usb-audio: Prevent printk ratelimiting from spamming
kernel log while DEBUG not defined

Seth Jennings (1):
      MAINTAINERS: zswap/zbud: change maintainer email address

Sheng-Liang Song (1):
      Input: atkbd - fix keyboard not working on some LG laptops

Sony Chacko (1):
      qlcnic: Reset firmware API lock at driver load time

Soren Brinkmann (5):
      net: macb: Pass same size to DMA_UNMAP as used for DMA_MAP
      net: macb: Clear interrupt flags
      net: macb: Re-enable RX interrupt only when RX is done
      net: macb: Remove 'unlikely' optimization
      net: macb: Fix race between HW and driver

Stanislaw Gruszka (1):
      rt2x00: fix beaconing on USB

Takashi Iwai (2):
      ALSA: usb-audio: Save mixer status only once at suspend
      ALSA: usb-audio: Fix deadlocks at resuming

Tanya Brokhman (2):
      UBI: fix error path in __wl_get_peb
      UBI: fix ubi free PEBs count calculation

Thomas Gleixner (21):
      can: c_can_pci: Set the type of the IP core
      can: c_can: Fix startup logic
      can: c_can: Make bus off interrupt disable logic work
      can: c_can: Do not access skb after net_receive_skb()
      can: c_can: Handle state change correctly
      can: c_can: Fix berr reporting
      can: c_can: Always update error stats
      can: c_can: Simplify buffer reenabling
      can: c_can: Avoid status register update for D_CAN
      can: c_can: Get rid of pointless interrupts
      can: c_can: Disable rx split as workaround
      can: c_can: Work around C_CAN RX wreckage
      can: c_can: Cleanup irq enable/disable
      can: c_can: Cleanup c_can_read_msg_object()
      can: c_can: Cleanup setup of receive buffers
      can: c_can: Cleanup c_can_inval_msg_object()
      can: c_can: Cleanup c_can_msg_obj_put/get()
      can: c_can: Cleanup c_can_write_msg_object()
      can: c_can: Use proper u32 variables in c_can_write_msg_object()
      can: c_can: Remove tx locking
      can: c_can: Speed up tx buffer invalidation

Tim Harvey (2):
      ath9k: fix possible hang on flush
      ath9k: add a recv budget

Tobias Klauser (2):
      Altera TSE: Fix DMA secriptor length initialization
      Altera TSE: Add missing include to silence sparse warnings

Todd Fujinaka (1):
      igb: fix stats for i210 rx_fifo_errors

Tomas Sokorai (1):
      HID: multitouch: add support of EliteGroup 05D8 panels

Tomoki Sekiyama (1):
      drivers/tty/hvc: don't free hvc_console_setup after init

Toshiaki Makita (1):
      bridge: Handle IFLA_ADDRESS correctly when creating bridge device

Victor A. Santos (1):
      USB: Nokia 305 should be treated as unusual dev

Vince Bridgers (4):
      Altera TSE: Work around unaligned DMA receive packet issue with
Altera SGDMA
      Altera TSE: Set the Pause Quanta value to the IEEE default value
      Altera TSE: Fix Panic in probe routine when phy probe fails
      Altera TSE: Change driver name used by Ethtool

Vlad Yasevich (3):
      e1000e: Correctly include VLAN_HLEN when changing interface MTU
      mactap: Fix checksum errors for non-gso packets in bridge mode
      Revert "macvlan : fix checksums error when we are in bridge mode"

Vladimir Davydov (1):
      slub: fix memcg_propagate_slab_attrs

Vlastimil Babka (1):
      mm/compaction: make isolate_freepages start at pageblock boundary

Will Woods (1):
      fanotify: fix -EOVERFLOW with large files on 64-bit

Wolfgang Grandegger (1):
      can: c_can_pci: enable PCI bus master only for MSI

Wolfram Sang (1):
      can: c_can: use proper type for 'instance'

Xufeng Zhang (1):
      sctp: reset flowi4_oif parameter on route lookup

Yan, Zheng (5):
      ceph: check directory's completeness before emitting directory entry
      ceph: use fpos_cmp() to compare dentry positions
      ceph: clear directory's completeness when creating file
      ceph: avoid releasing caps that are being used
      ceph: reserve caps for file layout/lock MDS requests

Ying Cai (1):
      ip_tunnel: Set network header properly for IP_ECN_decapsulate()

Yuval Mintz (2):
      bnx2x: Memory leak during VF removal
      bnx2x: Fix vlan credit issues for VFs

Zi Shen Lim (2):
      smc91x: fix compile error when SMC_DEBUG >= 2
      smc91x: improve definition of debug macros
