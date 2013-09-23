Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab3IWXAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 19:00:21 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:43156 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3IWXAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 19:00:17 -0400
MIME-Version: 1.0
Date: Mon, 23 Sep 2013 16:00:15 -0700
X-Google-Sender-Auth: XU8g7hnaU9_LCIs69dtzcbh96Wo
Message-ID: <CA+55aFxoF75RJfkp0vnm-b9B0h7PGMitrQiLyTt315tKvG-wTQ@mail.gmail.com>
Subject: Linux 3.12-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I really should have moved my release schedule back to Sunday - it got
messed up by me releasing on Labor Day, and now it's been on Monday
ever since.

But hey, I didn't. So here it is, a full week later, the rc2 release.

Things have been fairly quiet, probably because lots of people were
traveling for LinuxCon and Linux Plumbers conference last week. So
nothing very exciting stands out. It's mainly driver updates/fixes
(gpu drivers stand out, but there's networking too, and smaller stuff
all over). Apart from drivers there's arch updates (tile/arm/mips) and
some filesystem noise (mainly btrfs).

The shortlog is borderline too big to be really readable, but I'm
appending it anyway.

               Linus

---

Aaro Koskinen (6):
      staging: octeon-ethernet: make dropped packets to consume NAPI budget
      staging: octeon-ethernet: remove skb alloc failure warnings
      staging: octeon-ethernet: rgmii: enable interrupts that we can handle
      staging: octeon-ethernet: make dropped packets to consume NAPI budget
      staging: octeon-ethernet: remove skb alloc failure warnings
      staging: octeon-ethernet: rgmii: enable interrupts that we can handle

Al Viro (3):
      autofs4: close the races around autofs4_notify_daemon()
      atomic_open: take care of EEXIST in no-open case with
O_CREAT|O_EXCL in fs/namei.c
      9p: don't forget to destroy inode cache if fscache registration fails

Alan Stern (1):
      usb: gadget: fix a bug and a WARN_ON in dummy-hcd

Alex Deucher (24):
      drm/radeon/cik: properly handle internal cp ints
      drm/radeon/si: properly handle internal cp ints
      drm/radeon/dce6/audio: make sure pin is valid before accessing it
      drm/radeon: add a connector property for audio
      drm/radeon: dpm updates for KV
      drm/radeon: protect concurrent smc register access with a spinlock
      drm/radeon: add spinlocks for indirect register accesss
      drm/radeon/cik: update gpu_init for an additional berlin gpu
      drm/radeon: add some additional berlin pci ids
      drm/radeon: fix typo in PG flags
      drm/radeon/r6xx: add a stubbed out set_uvd_clocks callback
      drm/radeon/dpm: fix fallback for empty UVD clocks
      drm/radeon/atom: workaround vbios bug in transmitter table on rs880 (v2)
      drm/radeon/dpm: handle bapm on trinity
      drm/radeon/dpm: handle bapm on kb/kv
      drm/radeon/dpm: add infrastructure to properly handle bapm
      drm/radeon/dpm: add bapm callback for trinity
      drm/radeon/dpm: add bapm callback for kb/kv
      drm/radeon/dpm/rs780: use drm_mode_vrefresh()
      drm/radeon/dpm/rs780: add some sanity checking to sclk scaling
      drm/radeon/dpm/rs780: don't enable sclk scaling if not required
      drm/radeon/dpm/rs780: fix force_performance state for same sclks
      drm/radeon/dpm: rework auto performance level enable
      drm/radeon: fix panel scaling with eDP and LVDS bridges

Alexey Khoroshilov (3):
      rtl8187: fix use after free on failure path in rtl8187_init_urbs()
      net/irda/mcs7780: fix memory leaks in mcs_net_open()
      usb: gadget: mv_u3d_core: fix violation of locking discipline in
mv_u3d_ep_disable()

Anatol Pomozov (1):
      cfq: explicitly use 64bit divide operation for 64bit arguments

Andrea Adami (1):
      ARM: sa1100: collie.c: fall back to jedec_probe flash detection

Andrew Morton (1):
      drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c: rename PTRS_PER_PAGE

Andrzej Pietrasiewicz (1):
      usb: gadget: cdc2: fix conversion to new interface of f_ecm

Andy Shevchenko (1):
      atm: nicstar: fix regression made by previous patch

Anoop Thomas Mathew (1):
      ARM: OMAP4 SMP: Corrected a typo fucntions to functions

Ansis Atteka (2):
      ip: use ip_hdr() in __ip_make_skb() to retrieve IP header
      ip: generate unique IP identificator if local fragmentation is allowed

Anthoine Bourgeois (1):
      drm/radeon/dpm: implement force performance levels for rs780 (v2)

Antonio Alecrim Jr (2):
      be2net: missing variable initialization
      isdn: hfcpci_softirq: get func return to suppress compiler warning

Antonio Quartulli (1):
      batman-adv: set the TAG flag for the vid passed to BLA

Arend van Spriel (1):
      brcmfmac: fix bus interface selection in Kconfig

Arnaud Patard (1):
      ARM: imx51.dtsi: fix PATA device clock

Aruna Balakrishnaiah (3):
      pstore: Adjust buffer size for compression for smaller registered buffers
      pstore: Use zlib_inflateInit2 instead of zlib_inflateInit
      pstore: Remove the messages related to compression failure

Avinash Kumar (1):
      drivers: net: phy: cicada.c: clears warning Use #include
<linux/io.h> instead of <asm/io.h>

Ben Hutchings (6):
      sfc: Minimal support for 40G link speed
      sfc: Disable PTP on EF10 until we're ready to handle inline RX timestamps
      sfc: Reset derived rx_bad_bytes statistic when EF10 MC is rebooted
      sfc: Clean up validation of datapath capabilities
      sfc: Reinitialise and re-validate datapath caps after MC reboot
      Staging: comedi: Fix dependencies for drivers misclassified as PCI

Ben Skeggs (5):
      drm/nouveau/bios/init: stub opcode 0xaa
      drm/nouveau/kms: enable for non-vga pci classes
      drm/nouveau/bios/init: fix thinko in INIT_CONFIGURE_MEM
      drm/nouveau/ttm: prevent double-free in
nouveau_sgdma_create_ttm() failure path
      drm/ttm: fix the tt_populated check in ttm_tt_destroy()

Benjamin Tissoires (3):
      HID: validate feature and input report details
      HID: multitouch: validate indexes details
      HID: lenovo-tpkbd: fix leak if tpkbd_probe_tp fails

Bjorn Helgaas (1):
      bio-integrity: Fix use of bs->bio_integrity_pool after free

Borislav Petkov (1):
      x86: Remove now-unused save_rest()

Bruce Rogers (1):
      KVM: x86 emulator: emulate RETF imm

Carolyn Wyborny (1):
      igb: Add additional get_phy_id call for i354 devices

Catalin Marinas (2):
      arm64: Make do_bad_area() function static
      arm64: Correctly report LR and SP for compat tasks

Chanho Park (1):
      usb: s3c-hsotg: do not disconnect gadget when receiving ErlySusp intr

Chen Gang (1):
      usb: gadget: add '__ref' for rndis_config_register() and
cdc_config_register()

Chris Healy (1):
      resubmit bridge: fix message_age_timer calculation

Chris Metcalf (8):
      tile: fix typos in comment in arch/tile/kernel/unaligned.c
      tile: use pmd_pfn() instead of casting via pte_t
      tile: remove HUGE_VMAP dead code
      tile: remove stale arch/tile/kernel/futex_64.S
      tile: double default VMALLOC space
      tile: improve gxio iorpc autogenerated code style
      tile: <arch/> header updates from upstream
      tile: remove stray blank space

Chris Wilson (1):
      drm/i915: Track pfit enable state separately from size

Christian König (3):
      drm/radeon: remove stale radeon_fence_retire tracepoint
      drm/radeon: add command submission tracepoint
      drm/radeon: avoid UVD corruptions on AGP cards

Daisuke Nishimura (1):
      sched/fair: Fix small race where child->se.parent,cfs_rq might
point to invalid ones

Damien Lespiau (1):
      drm/radeon: Fix hmdi typo

Dan Carpenter (3):
      drm/radeon: clean up r600_free_extended_power_table()
      drm/radeon: signedness bug in kv_dpm.c
      staging: line6: add bounds check in snd_toneport_source_put()

Daniel Borkmann (2):
      net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit
      net: sctp: rfc4443: do not report ICMP redirects to user space

Daniel Vetter (7):
      drm/i915: fix wait_for_pending_flips vs gpu hang deadlock
      drm/i915/sdvo: Fully translate sync flags in the dtd->mode conversion
      drm/i915/sdvo: Robustify the dtd<->drm_mode conversions
      drm/i915/dvo: set crtc timings again for panel fixed modes
      drm/i915: kill set_need_resched
      drm/udl: rip out set_need_resched
      drm/fb-helper: don't sleep for screen unblank when an oops is in progress

Dave Airlie (2):
      drm/ast: fix the ast open key function
      Revert "drm: mark context support as a legacy subsystem"

Dave Jones (4):
      staging/rtl8188eu: pass channel list by reference instead of
copying struct.
      staging/vt6656: Fix screwed up indentation in swGetOFDMControlRate
      USB: fix typo in usb serial simple driver Kconfig
      USB: Faraday fotg210: fix email addresses

David Cohen (1):
      usb: dwc3: gadget: avoid memory leak when failing to allocate all eps

David Ertman (2):
      e1000e: cleanup boolean comparison to true
      e1000e: fix overrun of PHY RAR array

David Howells (1):
      CacheFiles: Don't try to dump the index key if the cookie has been cleared

David Sterba (2):
      btrfs: add lockdep and tracing annotations for uuid tree
      btrfs: refuse to remount read-write after abort

David Vrabel (1):
      xen-netback: count number required slots for an skb more carefully

Derek Basehore (1):
      iio: isl29018: Fix uninitialized value

Ding Zhi (1):
      ip6_tunnels: raddr and laddr are inverted in nl msg

Duan Jiong (1):
      net:dccp: do not report ICMP redirects to user space

Emil Tantilov (3):
      ixgbe: fix ethtool loopback diagnostic with DCB enabled
      ixgbe: limit setting speed to only one at a time for QSFP modules
      ixgbe: fix ethtool reporting of supported links for SFP modules

Enric Balletbo i Serra (1):
      ARM: dts: igep00x0: Add pinmux configuration for MCBSP2

Eric W. Biederman (1):
      net loopback: Set loopback_dev to NULL when freed

Eugenia Emantayev (1):
      net/mlx4_en: Check device state when setting coalescing

Ezequiel Garcia (1):
      mtd: nand: pxa3xx: Remove unneeded ifdef CONFIG_OF

Fabio Estevam (2):
      ARM: mach-imx: clk-imx51-imx53: Fix 'spdif1_pred' clock registration
      ARM: mach-omap2: gpmc: Fix warning when CONFIG_ARM_LPAE=y

Fabio Porcedda (3):
      net: usb: cdc_ether: Use wwan interface for Telit modules
      net: usb: cdc_ether: fix checkpatch errors and warnings
      net: usb: cdc_ether: use usb.h macros whenever possible

Felipe Balbi (2):
      ARM: dts: OMAP5: fix reg property size
      ARM: dts: OMAP5: fix ocp2scp DTS data

Filipe David Borba Manana (2):
      Btrfs: more efficient inode tree replace operation
      Btrfs: don't leak transaction in btrfs_sync_file()

Frank Holton (1):
      btrfs: Add btrfs: prefix to kernel log output

Frank Schäfer (1):
      USB: pl2303: distinguish between original and cloned HX chips

Fujinaka, Todd (1):
      igb: Read flow control for i350 from correct EEPROM section

Gao feng (1):
      netfilter: nfnetlink_queue: use network skb for sequence adjustment

Geert Uytterhoeven (2):
      staging/lustre: Correct default for LUSTRE_TRANSLATE_ERRNOS
      staging: r8188eu: Fix uninitialized variable change_inx

Gleb Natapov (2):
      KVM: nEPT: reset PDPTR register cache on nested vmentry emulation
      KVM: VMX: set "blocked by NMI" flag if EPT violation happens
during IRET from NMI

Greg Kroah-Hartman (2):
      Revert "staging: zram: Add auto loading of module if user opens
/dev/zram."
      Revert "USB: EHCI: support running URB giveback in tasklet context"

Guangyu Sun (1):
      Btrfs: dir_inode_operations should use btrfs_update_time also

Guenter Roeck (1):
      staging: Disable lustre file system for MIPS, SH, and XTENSA

Gwenhael Goavec-Merou (1):
      ARM: imx27.dtsi: fix CSPI PER clock id

Hauke Mehrtens (2):
      bcma: fix error code handling on 64 Bit systems
      bgmac: allow bigger et_swtype nvram variable

Heikki Krogerus (2):
      usb: dwc3: pci: add support for BayTrail
      usb: dwc3: remove extcon dependency

Herbert Xu (1):
      bridge: Clamp forward_delay when enabling STP

Hong Zhiguo (2):
      bridge: use br_port_get_rtnl within rtnl lock
      bridge: fix NULL pointer deref of br_port_get_rcu

Huang Shijie (1):
      ARM: dts: imx6q: fix the wrong offset of the Pad Mux register

Ilya Dryomov (1):
      Btrfs: do not add replace target to the alloc_list

J. Bruce Fields (1):
      RPCSEC_GSS: fix crash on destroying gss auth

Jacob Keller (1):
      ixgbe: fully disable hardware RSC logic when disabling RSC

Jani Nikula (1):
      drm/i915: do not update cursor in crtc mode set

Jason Liu (1):
      ARM: imx: i.mx6d/q: disable the double linefill feature of PL310

Jason Wang (1):
      tuntap: correctly handle error in tun_set_iff()

Jean Delvare (2):
      drm/radeon: simplify driver data retrieval
      drm/radeon: expose DPM thermal thresholds through sysfs

Jianpeng Ma (1):
      block: trace all devices plug operation

Jingoo Han (1):
      mailbox: remove unnecessary platform_set_drvdata()

Joe Perches (1):
      block: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)

John Stultz (1):
      timekeeping: Fix HRTICK related deadlock from ntp lock changes

Jon Mason (2):
      bnx2x: Use pci_dev pm_cap
      tg3: Use pci_dev pm_cap

Jonathan Cameron (1):
      staging:iio:dummy fix kfifo_buf kconfig dependency issue if
kfifo modular and buffer enabled for built in dummy driver.

Josef Bacik (13):
      Btrfs: fixup error handling in btrfs_reloc_cow
      Btrfs: actually limit the size of delalloc range
      Btrfs: actually log directory we are fsync()'ing
      Btrfs: check roots last log commit when checking if an inode has
been logged
      Btrfs: replay dir_index items before other items
      Btrfs: drop dir i_size when adding new names on replay
      Btrfs: improve replacing nocow extents
      Revert "Btrfs: rework the overcommit logic to be based on the total size"
      Btrfs: fix worst case calculator for space usage
      Btrfs: kill delay_iput arg to the wait_ordered functions
      Btrfs: remove space_info->reservation_progress
      Btrfs: iput inode on allocation failure
      Btrfs: create the uuid tree on remount rw

Joseph Gasparakis (1):
      vxlan: Fix sparse warnings

Josh Boyer (1):
      CacheFiles: Fix memory leak in cachefiles_check_auxdata error paths

Josh Durgin (6):
      libceph: add function to ensure notifies are complete
      rbd: complete notifies before cleaning up osd_client and rbd_dev
      rbd: make rbd_obj_notify_ack() synchronous
      rbd: fix use-after free of rbd_dev->disk
      rbd: ignore unmapped snapshots that no longer exist
      rbd: fix error handling from rbd_snap_name()

Josh Wu (1):
      iio: at91: fix adc_clk overflow

Jozsef Kadlecsik (3):
      netfilter: ipset: Skip really non-first fragments for IPv6 when
getting port/protocol
      netfilter: ipset: Consistent userspace testing with nomatch flag
      netfilter: ipset: Validate the set family and not the set type
family at swapping

Jun'ichi Nomura (1):
      block: Add nr_bios to block_rq_remap tracepoint

Kees Cook (13):
      xen-netback: fix possible format string flaw
      HID: provide a helper for validating hid reports
      HID: zeroplus: validate output report details
      HID: sony: validate HID output report details
      HID: steelseries: validate output report details
      HID: LG: validate HID output report details
      HID: lenovo-tpkbd: validate output report details
      HID: logitech-dj: validate output report details
      isdn: clean up debug format string usage
      staging: xillybus: fix format string usage
      staging: dgap: fix overflows and format strings
      staging: lustre: clean up format string usages
      staging: dgnc: fix potential format string flaw

Koen Kooi (1):
      ARM: dts: am335x-bone*: add DT for BeagleBone Black

Larry Finger (4):
      staging: r8188eu: Fix Smatch off-by-one warning in hal/rtl8188e_hal_init.c
      staging: r8188eu: Fix smatch error in core/rtw_mlme_ext.c
      staging: r8188eu: Fix smatch warning in core/rtw_ieee80211.
      staging: r8188eu: Adjust RX gain

Lars-Peter Clausen (4):
      iio: Stop sampling when the device is removed
      iio: fix: Keep a reference to the IIO device for open file descriptors
      iio: Prevent race between IIO chardev opening and IIO device free
      iio:buffer_cb: Add missing iio_buffer_init()

Leonid Yegoshin (1):
      MIPS: Fix VGA_MAP_MEM macro.

Li Bin (1):
      sched/Documentation: Update sched-design-CFS.txt documentation

Libin (1):
      x86/smpboot: Fix announce_cpu() to printk() the last "OK" properly

Libo Chen (1):
      drivers/atm/he.c: convert to module_pci_driver

Linus Torvalds (1):
      Linux 3.12-rc2

Linus Walleij (3):
      ARM: ux500: disable outer cache debug
      ARM: u300: hide submenus
      ARM: multi_v7: add HREFv60 to multi_v7 defconfig

Lukasz Czerwinski (1):
      iio: iio_device_add_event_sysfs() bugfix

Maciej W. Rozycki (2):
      MIPS: Cleanup CP0 PRId and CP1 FPIR register access masks
      MIPS: 74K/1074K: Correct erratum workaround.

Madhavan Srinivasan (1):
      MIPS: Fix invalid symbolic link file

Manish Chopra (1):
      qlcnic: Fix VF reset recovery

Marek Szyprowski (1):
      usb: s3c-hsotg: fix unregistration function

Mark Fasheh (1):
      btrfs: change extent-same to copy entire argument struct

Markos Chandras (1):
      MIPS: PCI: pci-bcm1480: Include missing vt.h header

Mathias Nyman (1):
      x86/intel/lpss: Add pin control support to Intel low power subsystem

Miao Xie (1):
      Btrfs: allocate the free space by the existed max extent size when ENOSPC

Michael Chan (2):
      bnx2x, cnic, bnx2i, bnx2fc: Fix bnx2i and bnx2fc regressions.
      cnic: Fix crash in cnic_bnx2x_service_kcq()

Michael Opdenacker (13):
      bfin_mac: remove deprecated IRQF_DISABLED
      ehea: remove deprecated IRQF_DISABLED
      ethernet: amd: remove deprecated IRQF_DISABLED
      net: tulip: remove deprecated IRQF_DISABLED
      net: fec: remove deprecated IRQF_DISABLED
      net: hp100: remove deprecated IRQF_DISABLED
      net: lantiq_etop: remove deprecated IRQF_DISABLED
      net: pxa168_eth: remove deprecated IRQF_DISABLED
      net: ks8851-ml: remove deprecated IRQF_DISABLED
      net: natsemi: remove deprecated IRQF_DISABLED
      net: pasemi: remove deprecated IRQF_DISABLED
      net: smsc: remove deprecated IRQF_DISABLED
      net: ps3_gelic: remove deprecated IRQF_DISABLED

Michael S. Tsirkin (3):
      sched: Fix comment for sched_info_depart
      vhost/scsi: use vmalloc for order-10 allocation
      vhost-scsi: whitespace tweak

Michal Kubeček (1):
      netfilter: nf_conntrack: use RCU safe kfree for conntrack extensions

Mike Christie (1):
       call __blk_end_request_allon dying queues

Miklos Szeredi (5):
      vfs: improve i_op->atomic_open() documentation
      cifs: fix filp leak in cifs_atomic_open()
      gfs2: set FILE_CREATED
      nfs: set FILE_CREATED
      vfs: don't set FILE_CREATED before calling ->atomic_open()

Mikulas Patocka (1):
      skge: fix broken driver

Milosz Tanski (1):
      fscache: check consistency does not decrement refcount

Neal Cardwell (1):
      tcp: fix RTO calculated from cached RTT

Neil Horman (1):
      bonding: Make alb learning packet interval configurable

Nikolay Aleksandrov (2):
      netpoll: fix NULL pointer dereference in netpoll_cleanup
      netconsole: fix a deadlock with rtnl and netconsole's mutex

Nithin Sujir (1):
      tg3: Expand led off fix to include 5720

Olaf Hering (1):
      drivers/net/ethernet/ibm/ehea/ehea_main.c: add alias entry for
portN properties

Oleg Nesterov (1):
      tty: disassociate_ctty() sends the extra SIGCONT

Oliver Smith (1):
      netfilter: ipset: Fix serious failure in CIDR tracking

Olof Johansson (1):
      ARM: multi_v7_defconfig: enable ARM_ATAG_DTB_COMPAT

Paolo Bonzini (1):
      KVM: mmu: allow page tables to be in read-only slots

Paul Durrant (1):
      xen-netback: Don't destroy the netdev until the vif is shut down

Peter Meerwald (5):
      staging:iio:hmc5843: Fix measurement conversion
      iio: Fix tmp006 dev-to-indio_dev conversion in suspend/resume
      iio: Fix bma180 dev-to-indio_dev conversion in suspend/resume
      iio: Fix mcp4725 dev-to-indio_dev conversion in suspend/resume
      iio: Fix crash when scan_bytes is computed with active_scan_mask == NULL

Peter Oh (1):
      usb: gadget: f_mass_storage: reset endpoint driver data when disabled

Peter Zijlstra (2):
      perf/x86/intel: Fix Silvermont offcore masks
      sched/debug: Take PID namespace into account

Phil Carmody (1):
      ARM: OMAP2+: mux: fix trivial typo in name

Phil Oester (1):
      netfilter: nf_nat_proto_icmpv6:: fix wrong comparison in icmpv6_manip_pkt

Prarit Bhargava (1):
      drm, ttm Fix uninitialized warning

Qin Chuanyu (1):
      vhost: wake up worker outside spin_lock

Radim Krčmář (1):
      kvm: free resources after canceling async_pf

Rafael J. Wysocki (1):
      PCI / ACPI / PM: Clear pme_poll for devices in D3cold on wakeup

Rafał Miłecki (2):
      bgmac: fix internal switch initialization
      bgmac: implement unaligned addressing for DMA rings that support it

Ralf Baechle (6):
      MIPS: Provide nice way to access boot CPU's data.
      MIPS: Fix accessing to per-cpu data when flushing the cache
      MIPS: Optimize current_cpu_type() for better code.
      MIPS: Reimplement get_cycles().
      MIPS: Add MIPS R5 config5 register.
      MIPS: Disable usermode switching of the FR bit for MIPS R5 CPUs.

Rob Clark (6):
      drm/msm: handle read vs write fences
      drm/msm: hangcheck harder
      drm/msm: fix cmdstream size check
      drm/msm: return -EBUSY if bo still active
      drm/msm: workaround for missing irq
      drm/msm: drop unnecessary set_need_resched()

Robert Nelson (1):
      ARM: dts: omap3-beagle-xm: fix string error in compatible property

Sachin Kamat (8):
      drm/exynos: Remove redundant OF dependency
      drm/exynos: Fix address space warning in exynos_drm_buf.c
      drm/exynos: Fix address space warnings in exynos_drm_fbdev.c
      usb: phy: omap-usb3: Fix return value
      usb: gadget: f_ecm: Staticize ecm_alloc
      usb: gadget: f_eem: Staticize eem_alloc
      usb: host: fsl-mph-dr-of: Staticize local symbols
      staging: iio: ade7854-spi: Fix return value

Shawn Guo (1):
      ARM: imx: initialize clk_init_data.flags for clk-fixup-mux

Solomon Peachy (2):
      cw1200: Don't perform SPI transfers in interrupt context
      cw1200: Prevent a lock-related hang in the cw1200_spi driver

Sonic Zhang (1):
      netpoll: Should handle ETH_P_ARP other than ETH_P_IP in
netpoll_neigh_reply

Sridhar Samudrala (1):
      vxlan: Avoid creating fdb entry with NULL destination

Stanislaw Gruszka (1):
      rt2800: change initialization sequence to fix system freeze

Stefan Behrens (2):
      btrfs: show compiled-in config features at module load time
      Btrfs: add the missing mutex unlock in write_all_supers()

Stephane Eranian (1):
      perf/x86/intel: Mark MEM_LOAD_UOPS_MISS_RETIRED as precise on SNB

Steve Capper (1):
      arm64: Widen hwcap to be 64 bit

Sudeep KarkadaNagesha (4):
      cpufreq: cpufreq-cpu0: assign cpu_dev correctly to cpu0 device
      cpufreq: imx6q-cpufreq: assign cpu_dev correctly to cpu0 device
      ARM: i.MX: change dev_id to cpu0 while registering cpu clock
      ARM: shmobile: change dev_id to cpu0 while registering cpu clock

Takashi Iwai (1):
      drm/i915: Use proper print format for debug prints

Tejun Heo (1):
      blkcg: relocate root_blkg setting and clearing

Tony Lindgren (3):
      ARM: dts: Fix muxing and regulator for wl12xx on the SDIO bus
for pandaboard
      ARM: dts: Fix muxing and regulator for wl12xx on the SDIO bus for blaze
      ARM: OMAP4: Fix clock_get error for GPMC during boot

Ville Syrjälä (1):
      drm/i915: Don't enable the cursor on a disable pipe

Vince Weaver (1):
      perf: Fix UAPI export of PERF_EVENT_IOC_ID

Viresh Kumar (2):
      cpufreq: Clear policy->cpus bits in __cpufreq_remove_dev_finish()
      cpufreq: unlock correct rwsem while updating policy->cpu

Vladimir Murzin (1):
      ARM: OMAP4: cpuidle: fix: call cpu_cluster_pm_exit conditionally

Wei Yang (1):
      cxgb4: remove workqueue when driver registration fails

Wei Yongjun (4):
      drm/msm: fix return value check in ERR_PTR()
      drm/msm: fix potential NULL pointer dereference
      drm/exynos: fix return value check in lowlevel_buffer_allocate()
      ARM: OMAP: fix return value check in omap_device_build_from_dt()

Will Deacon (2):
      arm64: documentation: tighten up tagged pointer documentation
      lockref: use cmpxchg64 explicitly for lockless updates

Wolfgang Grandegger (1):
      MIPS: PCI: Use pci_resource_to_user to map pci memory space properly

Wu Zhangjin (1):
      MIPS: Remove useless comment about kprobe from arch/mips/Makefile

Yijing Wang (1):
      alx: remove redundant D0 power state set

Yinghai Lu (1):
      cpufreq: return EEXIST instead of EBUSY for second registering

chandan (1):
      Btrfs: btrfs_ioctl_default_subvol: Revert back to toplevel
subvolume when arg is 0

françois romieu (1):
      r8169: enforce RX_MULTI_EN for the 8168f.
