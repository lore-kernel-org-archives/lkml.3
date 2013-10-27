Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3J0DyB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 23:54:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57293 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605Ab3J0Dxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 23:53:52 -0400
Message-ID: <1382845998.21018.129.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.52
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Sun, 27 Oct 2013 03:53:18 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8bssVfrRwq/1lNEDyb63"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); Message bigger than SAmaxbody (256000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8bssVfrRwq/1lNEDyb63
Content-Type: multipart/mixed; boundary="=-YmKthqYRHlCS9M+LqDyW"


--=-YmKthqYRHlCS9M+LqDyW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.52 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.51 is attached to this message.

Ben.

------------

 Makefile                                    |   2 +-
 arch/arm/mach-versatile/pci.c               |   6 +-
 arch/arm/mm/init.c                          |   3 +
 arch/ia64/mm/contig.c                       |   2 +
 arch/ia64/mm/discontig.c                    |   2 +
 arch/m68k/kernel/vmlinux-nommu.lds          |  93 ++++++++++++++
 arch/m68k/kernel/vmlinux.lds.S              |  15 ++-
 arch/m68k/kernel/vmlinux.lds_mm.S           |  10 --
 arch/m68k/kernel/vmlinux.lds_no.S           | 187 ------------------------=
----
 arch/parisc/mm/init.c                       |   2 +
 arch/powerpc/kernel/align.c                 |  10 ++
 arch/powerpc/kernel/iommu.c                 |   2 +-
 arch/powerpc/kernel/lparcfg.c               |   1 +
 arch/powerpc/kernel/sysfs.c                 |  18 ++-
 arch/powerpc/lib/checksum_64.S              |  58 ++++++---
 arch/sparc/kernel/entry.S                   |   2 +-
 arch/sparc/kernel/ktlb.S                    |   3 +-
 arch/sparc/kernel/syscalls.S                |   8 +-
 arch/sparc/kernel/trampoline_64.S           |   2 -
 arch/sparc/lib/ksyms.c                      |   9 --
 arch/unicore32/mm/init.c                    |   3 +
 arch/x86/kernel/reboot.c                    |  16 +++
 arch/x86/platform/efi/efi.c                 |  11 +-
 crypto/api.c                                |   7 +-
 drivers/acpi/acpi_ipmi.c                    |  24 ++--
 drivers/acpi/ec.c                           |   4 +
 drivers/block/cciss.c                       |   1 +
 drivers/block/cpqarray.c                    |   1 +
 drivers/bluetooth/ath3k.c                   |   2 +
 drivers/bluetooth/btusb.c                   |   2 +
 drivers/gpu/drm/drm_edid.c                  |   3 +
 drivers/gpu/drm/i915/intel_dp.c             |  13 +-
 drivers/gpu/drm/i915/intel_opregion.c       |   2 +-
 drivers/gpu/drm/radeon/atombios_encoders.c  |   8 +-
 drivers/gpu/drm/radeon/evergreen.c          |  25 +++-
 drivers/gpu/drm/radeon/evergreend.h         |   4 +
 drivers/gpu/drm/radeon/radeon_atombios.c    |  13 +-
 drivers/gpu/drm/radeon/radeon_connectors.c  |  34 ++++-
 drivers/gpu/drm/radeon/radeon_device.c      |  10 +-
 drivers/gpu/drm/radeon/rs400.c              |   9 +-
 drivers/hid/hid-core.c                      |  84 +++++++++++--
 drivers/hid/hid-ids.h                       |   1 +
 drivers/hid/hid-input.c                     |  11 +-
 drivers/hid/hid-lg2ff.c                     |  19 +--
 drivers/hid/hid-lg3ff.c                     |  29 +----
 drivers/hid/hid-lg4ff.c                     |  20 +--
 drivers/hid/hid-lgff.c                      |  17 +--
 drivers/hid/hid-logitech-dj.c               |   6 +
 drivers/hid/hid-ntrig.c                     |   3 +-
 drivers/hid/hid-picolcd.c                   |   2 +-
 drivers/hid/hid-pl.c                        |  10 +-
 drivers/hid/hid-speedlink.c                 |  11 +-
 drivers/hid/hid-zpff.c                      |  18 +--
 drivers/hid/hidraw.c                        |  51 ++++----
 drivers/hid/usbhid/hid-quirks.c             |   2 +
 drivers/hwmon/applesmc.c                    |  19 ++-
 drivers/iommu/intel-iommu.c                 |  72 ++++++-----
 drivers/md/dm-snap.c                        |   5 +-
 drivers/media/video/hdpvr/hdpvr-core.c      |  22 ++--
 drivers/mmc/host/tmio_mmc_dma.c             |   4 +-
 drivers/net/bonding/bond_main.c             |  13 +-
 drivers/net/can/flexcan.c                   |  20 ++-
 drivers/net/ethernet/freescale/gianfar.c    |  11 +-
 drivers/net/ethernet/freescale/gianfar.h    |  11 +-
 drivers/net/ethernet/realtek/8139cp.c       |  49 +++++++-
 drivers/net/ethernet/sfc/rx.c               |   3 +-
 drivers/net/ethernet/via/via-rhine.c        |   9 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c |   6 +
 drivers/net/macvtap.c                       |  62 +++++----
 drivers/net/ppp/pptp.c                      |   2 +-
 drivers/net/tun.c                           |   6 +-
 drivers/net/usb/cdc_ether.c                 |   5 +
 drivers/net/usb/dm9601.c                    |   2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   4 +
 drivers/net/wireless/ath/ath9k/ath9k.h      |   5 +-
 drivers/net/wireless/ath/ath9k/recv.c       |  17 ++-
 drivers/net/wireless/ath/ath9k/xmit.c       |   1 +
 drivers/net/wireless/p54/p54usb.c           |   1 +
 drivers/net/wireless/rt2x00/rt2800lib.c     |   7 ++
 drivers/net/wireless/rtlwifi/wifi.h         |   2 +-
 drivers/of/base.c                           |   1 +
 drivers/scsi/esp_scsi.c                     |  14 ++-
 drivers/scsi/esp_scsi.h                     |   1 +
 drivers/scsi/scsi_transport_iscsi.c         |   2 +-
 drivers/scsi/sd.c                           |  11 +-
 drivers/staging/comedi/drivers/dt282x.c     |   3 +-
 drivers/staging/comedi/drivers/ni_65xx.c    |  26 ++--
 drivers/staging/vt6656/main_usb.c           |   3 +-
 drivers/staging/zram/zram_drv.c             |   2 -
 drivers/staging/zram/zram_drv.h             |   5 +-
 drivers/tty/serial/pch_uart.c               |   5 +-
 drivers/usb/class/cdc-wdm.c                 |  13 +-
 drivers/usb/core/config.c                   |   3 +-
 drivers/usb/core/devio.c                    |  16 +++
 drivers/usb/core/hub.c                      |   5 +-
 drivers/usb/dwc3/dwc3-pci.c                 |   4 +
 drivers/usb/host/ehci-mxc.c                 |   2 +-
 drivers/usb/host/ehci-pci.c                 |   2 +-
 drivers/usb/host/ohci-pci.c                 |   2 +-
 drivers/usb/host/uhci-pci.c                 |   2 +-
 drivers/usb/host/xhci-pci.c                 |   2 +-
 drivers/usb/host/xhci-ring.c                |   8 +-
 drivers/usb/host/xhci.c                     |  22 ++++
 drivers/usb/serial/mos7720.c                |   6 +-
 drivers/usb/serial/option.c                 |   3 +
 drivers/xen/grant-table.c                   |  13 +-
 fs/debugfs/inode.c                          |  69 ++++------
 fs/ext4/namei.c                             |   3 +-
 fs/fuse/dir.c                               |  13 +-
 fs/fuse/file.c                              |  11 +-
 fs/fuse/fuse_i.h                            |   9 ++
 fs/fuse/inode.c                             |   4 +-
 fs/isofs/inode.c                            |  16 +--
 fs/nilfs2/page.c                            |   2 +
 fs/nilfs2/segment.c                         |  11 +-
 fs/notify/fanotify/fanotify.c               |   6 +
 fs/ocfs2/extent_map.c                       |   1 -
 include/linux/hid.h                         |   8 +-
 include/linux/icmpv6.h                      |   2 +
 include/linux/ipv6.h                        |   1 +
 include/linux/mm.h                          |   3 +-
 include/linux/perf_event.h                  |   2 +-
 include/linux/rculist.h                     |   5 +-
 include/linux/usb/hcd.h                     |   2 +-
 include/net/inetpeer.h                      |   6 +
 include/net/ip.h                            |  12 +-
 include/net/ipip.h                          |   2 +-
 kernel/cgroup.c                             |  11 ++
 kernel/events/core.c                        |  31 +++--
 kernel/sched_fair.c                         |  14 ++-
 lib/show_mem.c                              |   3 +
 mm/huge_memory.c                            |   2 +
 mm/memcontrol.c                             |   8 +-
 mm/page_alloc.c                             |   7 ++
 net/bridge/br_multicast.c                   |   3 +-
 net/bridge/br_stp.c                         |   2 +-
 net/caif/cfctrl.c                           |   3 +-
 net/ceph/osd_client.c                       |   2 +
 net/core/netpoll.c                          |   9 +-
 net/core/sysctl_net_core.c                  |   7 +-
 net/ipv4/fib_trie.c                         |   5 +-
 net/ipv4/igmp.c                             |   8 +-
 net/ipv4/inetpeer.c                         |  92 +++++++++++++-
 net/ipv4/ip_output.c                        |   6 +-
 net/ipv4/ipmr.c                             |   2 +-
 net/ipv4/raw.c                              |   2 +-
 net/ipv4/route.c                            |   1 +
 net/ipv4/tcp_cubic.c                        |  12 +-
 net/ipv4/xfrm4_mode_tunnel.c                |   2 +-
 net/ipv6/addrconf.c                         |  10 +-
 net/ipv6/icmp.c                             |  10 +-
 net/ipv6/ip6_fib.c                          |  16 ++-
 net/ipv6/ip6_output.c                       |  53 ++++----
 net/ipv6/mcast.c                            |   4 +-
 net/ipv6/ndisc.c                            |  16 +--
 net/ipv6/reassembly.c                       |   5 +
 net/netfilter/ipvs/ip_vs_xmit.c             |   2 +-
 net/sched/sch_htb.c                         |   2 +-
 net/sctp/ipv6.c                             |  42 ++-----
 net/sctp/sm_sideeffect.c                    |   3 +-
 net/sctp/socket.c                           |   3 +
 net/tipc/eth_media.c                        |  15 ++-
 scripts/kernel-doc                          |   3 +
 sound/pci/hda/hda_intel.c                   |   1 +
 sound/pci/hda/patch_hdmi.c                  |  11 ++
 sound/soc/codecs/88pm860x-codec.c           |   3 +
 sound/soc/codecs/max98095.c                 |   4 +-
 sound/soc/codecs/wm8960.c                   |   6 +-
 tools/perf/util/map.c                       |   1 +
 169 files changed, 1285 insertions(+), 790 deletions(-)

Alan Stern (4):
      USB: OHCI: Allow runtime PM without system sleep
      USB: fix build error when CONFIG_PM_SLEEP isn't enabled
      sd: Fix potential out-of-bounds access
      USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd

Alex Deucher (8):
      drm/edid: add quirk for Medion MD30217PG
      drm/radeon: update line buffer allocation for dce4.1/5
      drm/radeon: fix LCD record parsing
      drm/radeon: fix resume on some rs4xx boards (v2)
      drm/radeon: fix handling of variable sized arrays for router objects
      drm/radeon/atom: workaround vbios bug in transmitter table on rs880 (=
v2)
      drm/radeon: fix panel scaling with eDP and LVDS bridges
      drm/radeon: disable tests/benchmarks if accel is disabled

Alex Williamson (1):
      intel-iommu: Fix leaks in pagetable freeing

Alexey Khoroshilov (1):
      hdpvr: fix iteration over uninitialized lists in hdpvr_probe()

Anand Avati (1):
      fuse: invalidate inode attributes on xattr modification

Andi Kleen (1):
      perf tools: Handle JITed code in shared memory

Ansis Atteka (1):
      ip: generate unique IP identificator if local fragmentation is allowe=
d

Anssi Hannula (1):
      ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA

Anton Blanchard (1):
      powerpc: Handle unaligned ldbrx/stdbrx

Ben Hutchings (4):
      Revert "zram: use zram->lock to protect zram_free_page() in swap free=
 notify path"
      sfc: Fix efx_rx_buf_offset() for recycled pages
      Revert "sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpret=
er()"
      Linux 3.2.52

Benjamin Tissoires (1):
      HID: validate feature and input report details

Chen Gang (1):
      powerpc/pseries/lparcfg: Fix possible overflow are more than 1026

Chris Healy (1):
      resubmit bridge: fix message_age_timer calculation

Christian Lamparter (1):
      p54usb: add USB ID for Corega WLUSB2GTST USB adapter

Claudiu Manoil (1):
      gianfar: Change default HW Tx queue scheduling mode

Daisuke Nishimura (1):
      sched/fair: Fix small race where child->se.parent,cfs_rq might point =
to invalid ones

Dan Carpenter (7):
      tun: signedness bug in tun_get_user()
      USB: mos7720: use GFP_ATOMIC under spinlock
      staging: comedi: dt282x: dt282x_ai_insn_read() always fails
      ASoC: max98095: a couple array underflows
      ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()
      cpqarray: fix info leak in ida_locked_ioctl()
      cciss: fix info leak in cciss_ioctl32_passthru()

Daniel Borkmann (3):
      net: bridge: convert MLDv2 Query MRC into msecs_to_jiffies for max_de=
lay
      net: sctp: fix smatch warning in sctp_send_asconf_del_ip
      net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit

Daniel Mack (1):
      usb: ehci-mxc: check for pdata before dereferencing

Daniel Santos (1):
      kernel-doc: bugfix - multi-line macros

Dave Jones (1):
      caif: Add missing braces to multiline if in cfctrl_linkup_request

David Cohen (1):
      usb: dwc3: add support for Merrifield

David Rientjes (1):
      mm, show_mem: suppress page counts in non-blockable contexts

David S. Miller (2):
      esp_scsi: Fix tag state corruption when autosensing.
      sparc64: Fix off by one in trampoline TLB mapping installation loop.

Eric Dumazet (4):
      fib_trie: remove potential out of bound access
      tcp: cubic: fix overflow error in bictcp_update()
      tcp: cubic: fix bug in bictcp_acked()
      inetpeer: fix a race in inetpeer_gc_worker()

Fabio Porcedda (1):
      net: usb: cdc_ether: Use wwan interface for Telit modules

Felix Fietkau (3):
      ath9k: always clear ps filter bit on new assoc
      ath9k: fix rx descriptor related race condition
      ath9k: avoid accessing MRC registers on single-chain devices

Florian Wolter (1):
      xhci: Fix race between ep halt and URB cancellation

Grant Likely (1):
      of: Fix missing memory initialization on FDT unflattening

Greg Thelen (1):
      memcg: fix multiple large threshold notifications

Greg Ungerer (3):
      m68k: consolidate the vmlinux.lds linker scripts
      m68k: use non-MMU linker script for ColdFire MMU builds
      m68knommu: clean up linker script

Hannes Frederic Sowa (4):
      ipv6: don't stop backtracking in fib6_lookup_1 if subtree does not ma=
tch
      ipv6: remove max_addresses check from ipv6_create_tempaddr
      ipv6: drop packets with multiple fragmentation headers
      ipv6: udp packets following an UFO enqueued packet need also be handl=
ed by UFO

Hans Verkuil (1):
      hdpvr: register the video node at the end of probe

Hans de Goede (1):
      usb: config->desc.bLength may not exceed amount of data returned by t=
he device

Heikki Krogerus (1):
      usb: dwc3: pci: add support for BayTrail

Henrik Rydberg (2):
      hwmon: (applesmc) Check key count before proceeding
      hwmon: (applesmc) Silence uninitialized warnings

Herbert Xu (1):
      crypto: api - Fix race condition in larval lookup

Ian Abbott (1):
      staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevic=
e

Jan Kara (1):
      isofs: Refuse RW mount of the filesystem instead of making it RO

Jani Nikula (2):
      drm/i915: try not to lose backlight CBLV precision
      drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER

Jason Wang (1):
      macvtap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS

Jie Liu (1):
      ocfs2: fix the end cluster offset of FIEMAP

Jiri Bohac (1):
      ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO

Jiri Kosina (1):
      HID: hidraw: put old deallocation mechanism in place

Johan Hovold (3):
      USB: mos7720: fix big-endian control requests
      serial: pch_uart: fix tty-kref leak in rx-error path
      serial: pch_uart: fix tty-kref leak in dma-rx path

Josh Boyer (1):
      x86, efi: Don't map Boot Services on i386

Julius Werner (1):
      usb: core: don't try to reset_device() a port that got just disconnec=
ted

Kees Cook (9):
      HID: validate HID report id size
      HID: pantherlord: validate output report details
      HID: ntrig: validate feature report details
      HID: picolcd_core: validate output report details
      HID: check for NULL field when setting values
      HID: provide a helper for validating hid reports
      HID: zeroplus: validate output report details
      HID: LG: validate HID output report details
      HID: logitech-dj: validate output report details

Kirill Tkhai (4):
      sparc64: Fix ITLB handler of null page
      sparc64: Remove RWSEM export leftovers
      sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall
      sparc32: Fix exit flag passed from traced sys_sigreturn

Kurt Garloff (1):
      usb/core/devio.c: Don't reject control message to endpoint with wrong=
 direction bit

Lan Tianyu (1):
      ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT

Larry Finger (1):
      rtlwifi: Align private space in rtl_priv struct

Li Zefan (1):
      cgroup: fail if monitored file and event_control are in different cgr=
oup

Libin (1):
      mm/huge_memory.c: fix potential NULL pointer dereference

Lino Sanfilippo (1):
      fanotify: dont merge permission events

Lv Zheng (1):
      ACPI / IPMI: Fix atomic context requirement of ipmi_msg_handler()

Madhavan Srinivasan (1):
      powerpc/sysfs: Disable writing to PURR in guest mode

Malcolm Priestley (1):
      staging: vt6656: [BUG] main_usb.c oops on device_close move flag earl=
ier.

Manoj Chourasia (1):
      HID: hidraw: correctly deallocate memory on device disconnect

Marc Kleine-Budde (2):
      can: flexcan: fix flexcan_chip_start() on imx6
      can: flexcan: flexcan_chip_start: fix regression, mark one MB for TX =
and abort pending TX

Masoud Sharbiani (1):
      x86/reboot: Add quirk to make Dell C6100 use reboot=3Dpci automatical=
ly

Maxim Patlasov (2):
      fuse: postpone end_page_writeback() in fuse_writepage_locked()
      fuse: hotfix truncate_pagecache() issue

Michal Mal=C3=BD (1):
      USB: serial: option: Ignore card reader interface on Huawei E1750

Mike Dyer (1):
      ASoC: wm8960: Fix PLL register writes

Miklos Szeredi (1):
      fuse: readdir: check for slash in names

Mikulas Patocka (1):
      dm-snapshot: fix performance degradation due to small hash size

Neil Horman (2):
      8139cp: Add dma_mapping_error checking
      bonding: Fix broken promiscuity reference counting issue

Nikolay Aleksandrov (1):
      netpoll: fix NULL pointer dereference in netpoll_cleanup

Nishanth Aravamudan (1):
      powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_tab=
le()

Oleg Nesterov (1):
      debugfs: debugfs_remove_recursive() must not rely on list_empty(d_sub=
dirs)

Oliver Neukum (1):
      USB: cdc-wdm: fix race between interrupt handler and tasklet

Paul E. McKenney (2):
      powerpc: Fix parameter clobber in csum_partial_copy_generic()
      powerpc: Restore registers on error exit from csum_partial_copy_gener=
ic()

Peng Chen (1):
      Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.

Peter Korsgaard (1):
      dm9601: fix IFF_ALLMULTI handling

Peter Maydell (1):
      ARM: PCI: versatile: Fix SMAP register offsets

Peter Zijlstra (2):
      perf: Clarify perf_cpu_context::active_pmu usage by renaming it to ::=
unique_pmu
      perf: Fix perf_cgroup_switch for sw-events

Raphael Kubo da Costa (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17cb]

Ricardo Ribalda (1):
      ll_temac: Reset dma descriptors indexes on ndo_open

Roger Luethi (1):
      via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)

Roger Pau Monne (1):
      xen-gnt: prevent adding duplicate gnt callbacks

Roman Gushchin (1):
      net: check net.core.somaxconn sysctl values

Salam Noureddine (2):
      ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put
      ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_pu=
t

Salman Qazi (1):
      perf: Use css_tryget() to avoid propping up css refcount

Sasha Levin (1):
      iscsi: don't hang in endless loop if no targets present

Sergei Shtylyov (1):
      mmc: tmio_mmc_dma: fix PIO fallback on SDHI

Shawn Nematbakhsh (1):
      usb: xhci: Disable runtime PM suspend for quirky controllers

Stanislaw Gruszka (1):
      rt2800: fix wrong TX power compensation

Stefan Kriwanek (1):
      HID: Fix Speedlink VAD Cezanne support for some devices

Steffen Klassert (1):
      inetpeer: Invalidate the inetpeer tree along with the routing cache

Takashi Iwai (1):
      ALSA: hda - Add Toshiba Satellite C870 to MSI blacklist

Tejun Heo (1):
      rculist: list_first_or_null_rcu() should use list_entry_rcu()

Theodore Ts'o (1):
      ext4: avoid hang when mounting non-journal filesystems with orphan li=
st

Thomas Graf (1):
      ipv6: Don't depend on per socket memory for neighbour discovery messa=
ges

Vasily Titskiy (1):
      HID: usbhid: quirk for N-Trig DuoSense Touch Screen

Vyacheslav Dubeyko (1):
      nilfs2: fix issue with race condition of competition between segments=
 for dirty blocks

Ying Xue (1):
      tipc: fix lockdep warning during bearer initialization

majianpeng (1):
      libceph: unregister request in __map_request failed and nofail =3D=3D=
 false

stephen hemminger (1):
      htb: fix sign extension bug


--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-YmKthqYRHlCS9M+LqDyW
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.52.patch"
Content-Disposition: attachment; filename="linux-3.2.52.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUNCmluZGV4IDBmMTE5MzYuLjFkZDJjMDkg
MTAwNjQ0DQotLS0gYS9NYWtlZmlsZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0xLDYgKzEsNiBAQA0K
IFZFUlNJT04gPSAzDQogUEFUQ0hMRVZFTCA9IDINCi1TVUJMRVZFTCA9IDUxDQorU1VCTEVWRUwg
PSA1Mg0KIEVYVFJBVkVSU0lPTiA9DQogTkFNRSA9IFNhYmVyLXRvb3RoZWQgU3F1aXJyZWwNCiAN
CmRpZmYgLS1naXQgYS9hcmNoL2FybS9tYWNoLXZlcnNhdGlsZS9wY2kuYyBiL2FyY2gvYXJtL21h
Y2gtdmVyc2F0aWxlL3BjaS5jDQppbmRleCBjODk4ZGViLi4xODllZDAwIDEwMDY0NA0KLS0tIGEv
YXJjaC9hcm0vbWFjaC12ZXJzYXRpbGUvcGNpLmMNCisrKyBiL2FyY2gvYXJtL21hY2gtdmVyc2F0
aWxlL3BjaS5jDQpAQCAtNDMsOSArNDMsOSBAQA0KICNkZWZpbmUgUENJX0lNQVAwCQlfX0lPX0FE
RFJFU1MoVkVSU0FUSUxFX1BDSV9DT1JFX0JBU0UrMHgwKQ0KICNkZWZpbmUgUENJX0lNQVAxCQlf
X0lPX0FERFJFU1MoVkVSU0FUSUxFX1BDSV9DT1JFX0JBU0UrMHg0KQ0KICNkZWZpbmUgUENJX0lN
QVAyCQlfX0lPX0FERFJFU1MoVkVSU0FUSUxFX1BDSV9DT1JFX0JBU0UrMHg4KQ0KLSNkZWZpbmUg
UENJX1NNQVAwCQlfX0lPX0FERFJFU1MoVkVSU0FUSUxFX1BDSV9DT1JFX0JBU0UrMHgxMCkNCi0j
ZGVmaW5lIFBDSV9TTUFQMQkJX19JT19BRERSRVNTKFZFUlNBVElMRV9QQ0lfQ09SRV9CQVNFKzB4
MTQpDQotI2RlZmluZSBQQ0lfU01BUDIJCV9fSU9fQUREUkVTUyhWRVJTQVRJTEVfUENJX0NPUkVf
QkFTRSsweDE4KQ0KKyNkZWZpbmUgUENJX1NNQVAwCQlfX0lPX0FERFJFU1MoVkVSU0FUSUxFX1BD
SV9DT1JFX0JBU0UrMHgxNCkNCisjZGVmaW5lIFBDSV9TTUFQMQkJX19JT19BRERSRVNTKFZFUlNB
VElMRV9QQ0lfQ09SRV9CQVNFKzB4MTgpDQorI2RlZmluZSBQQ0lfU01BUDIJCV9fSU9fQUREUkVT
UyhWRVJTQVRJTEVfUENJX0NPUkVfQkFTRSsweDFjKQ0KICNkZWZpbmUgUENJX1NFTEZJRAkJX19J
T19BRERSRVNTKFZFUlNBVElMRV9QQ0lfQ09SRV9CQVNFKzB4YykNCiANCiAjZGVmaW5lIERFVklD
RV9JRF9PRkZTRVQJCTB4MDANCmRpZmYgLS1naXQgYS9hcmNoL2FybS9tbS9pbml0LmMgYi9hcmNo
L2FybS9tbS9pbml0LmMNCmluZGV4IGZiZGQxMmUuLmNjM2YzNWQgMTAwNjQ0DQotLS0gYS9hcmNo
L2FybS9tbS9pbml0LmMNCisrKyBiL2FyY2gvYXJtL21tL2luaXQuYw0KQEAgLTk4LDYgKzk4LDkg
QEAgdm9pZCBzaG93X21lbSh1bnNpZ25lZCBpbnQgZmlsdGVyKQ0KIAlwcmludGsoIk1lbS1pbmZv
OlxuIik7DQogCXNob3dfZnJlZV9hcmVhcyhmaWx0ZXIpOw0KIA0KKwlpZiAoZmlsdGVyICYgU0hP
V19NRU1fRklMVEVSX1BBR0VfQ09VTlQpDQorCQlyZXR1cm47DQorDQogCWZvcl9lYWNoX2Jhbmsg
KGksIG1pKSB7DQogCQlzdHJ1Y3QgbWVtYmFuayAqYmFuayA9ICZtaS0+YmFua1tpXTsNCiAJCXVu
c2lnbmVkIGludCBwZm4xLCBwZm4yOw0KZGlmZiAtLWdpdCBhL2FyY2gvaWE2NC9tbS9jb250aWcu
YyBiL2FyY2gvaWE2NC9tbS9jb250aWcuYw0KaW5kZXggZjExNGEzYi4uY2U2ZTdhOCAxMDA2NDQN
Ci0tLSBhL2FyY2gvaWE2NC9tbS9jb250aWcuYw0KKysrIGIvYXJjaC9pYTY0L21tL2NvbnRpZy5j
DQpAQCAtNDYsNiArNDYsOCBAQCB2b2lkIHNob3dfbWVtKHVuc2lnbmVkIGludCBmaWx0ZXIpDQog
CXByaW50ayhLRVJOX0lORk8gIk1lbS1pbmZvOlxuIik7DQogCXNob3dfZnJlZV9hcmVhcyhmaWx0
ZXIpOw0KIAlwcmludGsoS0VSTl9JTkZPICJOb2RlIG1lbW9yeSBpbiBwYWdlczpcbiIpOw0KKwlp
ZiAoZmlsdGVyICYgU0hPV19NRU1fRklMVEVSX1BBR0VfQ09VTlQpDQorCQlyZXR1cm47DQogCWZv
cl9lYWNoX29ubGluZV9wZ2RhdChwZ2RhdCkgew0KIAkJdW5zaWduZWQgbG9uZyBwcmVzZW50Ow0K
IAkJdW5zaWduZWQgbG9uZyBmbGFnczsNCmRpZmYgLS1naXQgYS9hcmNoL2lhNjQvbW0vZGlzY29u
dGlnLmMgYi9hcmNoL2lhNjQvbW0vZGlzY29udGlnLmMNCmluZGV4IGM2NDEzMzMuLjIyMzA4MTcg
MTAwNjQ0DQotLS0gYS9hcmNoL2lhNjQvbW0vZGlzY29udGlnLmMNCisrKyBiL2FyY2gvaWE2NC9t
bS9kaXNjb250aWcuYw0KQEAgLTYyMyw2ICs2MjMsOCBAQCB2b2lkIHNob3dfbWVtKHVuc2lnbmVk
IGludCBmaWx0ZXIpDQogDQogCXByaW50ayhLRVJOX0lORk8gIk1lbS1pbmZvOlxuIik7DQogCXNo
b3dfZnJlZV9hcmVhcyhmaWx0ZXIpOw0KKwlpZiAoZmlsdGVyICYgU0hPV19NRU1fRklMVEVSX1BB
R0VfQ09VTlQpDQorCQlyZXR1cm47DQogCXByaW50ayhLRVJOX0lORk8gIk5vZGUgbWVtb3J5IGlu
IHBhZ2VzOlxuIik7DQogCWZvcl9lYWNoX29ubGluZV9wZ2RhdChwZ2RhdCkgew0KIAkJdW5zaWdu
ZWQgbG9uZyBwcmVzZW50Ow0KZGlmZiAtLWdpdCBhL2FyY2gvbTY4ay9rZXJuZWwvdm1saW51eC1u
b21tdS5sZHMgYi9hcmNoL202OGsva2VybmVsL3ZtbGludXgtbm9tbXUubGRzDQpuZXcgZmlsZSBt
b2RlIDEwMDY0NA0KaW5kZXggMDAwMDAwMC4uNDBlMDJkOQ0KLS0tIC9kZXYvbnVsbA0KKysrIGIv
YXJjaC9tNjhrL2tlcm5lbC92bWxpbnV4LW5vbW11Lmxkcw0KQEAgLTAsMCArMSw5MyBAQA0KKy8q
DQorICoJdm1saW51eC5sZHMuUyAtLSBtYXN0ZXIgbGlua2VyIHNjcmlwdCBmb3IgbTY4a25vbW11
IGFyY2gNCisgKg0KKyAqCShDKSBDb3B5cmlnaHQgMjAwMi0yMDEyLCBHcmVnIFVuZ2VyZXIgPGdl
cmdAc25hcGdlYXIuY29tPg0KKyAqDQorICoJVGhpcyBsaW5rZXIgc2NyaXB0IGlzIGVxdWlwcGVk
IHRvIGJ1aWxkIGVpdGhlciBST00gbG9hZGVkIG9yIFJBTQ0KKyAqCXJ1biBrZXJuZWxzLg0KKyAq
Lw0KKw0KKyNpZiBkZWZpbmVkKENPTkZJR19SQU1LRVJORUwpDQorI2RlZmluZQlLVEVYVF9BRERS
CUNPTkZJR19LRVJORUxCQVNFDQorI2VuZGlmDQorI2lmIGRlZmluZWQoQ09ORklHX1JPTUtFUk5F
TCkNCisjZGVmaW5lCUtURVhUX0FERFIJQ09ORklHX1JPTVNUQVJUDQorI2RlZmluZQlLREFUQV9B
RERSCUNPTkZJR19LRVJORUxCQVNFDQorI2RlZmluZQlMT0FEX09GRlNFVAlLREFUQV9BRERSICsg
KEFERFIoLnRleHQpICsgU0laRU9GKC50ZXh0KSkNCisjZW5kaWYNCisNCisjaW5jbHVkZSA8YXNt
L3BhZ2UuaD4NCisjaW5jbHVkZSA8YXNtL3RocmVhZF9pbmZvLmg+DQorI2luY2x1ZGUgPGFzbS1n
ZW5lcmljL3ZtbGludXgubGRzLmg+DQorDQorT1VUUFVUX0FSQ0gobTY4aykNCitFTlRSWShfc3Rh
cnQpDQorDQoramlmZmllcyA9IGppZmZpZXNfNjQgKyA0Ow0KKw0KK1NFQ1RJT05TIHsNCisNCisj
aWZkZWYgQ09ORklHX1JPTVZFQw0KKwkuID0gQ09ORklHX1JPTVZFQzsNCisJLnJvbXZlYyA6IHsN
CisJCV9fcm9tX3N0YXJ0ID0gLjsNCisJCV9yb212ZWMgPSAuOw0KKwkJKigucm9tdmVjKQ0KKwkJ
KiguZGF0YS4uaW5pdHZlY3QpDQorCX0NCisjZW5kaWYNCisNCisJLiA9IEtURVhUX0FERFI7DQor
DQorCV90ZXh0ID0gLjsNCisJX3N0ZXh0ID0gLjsNCisJLnRleHQgOiB7DQorCQlIRUFEX1RFWFQN
CisJCVRFWFRfVEVYVA0KKwkJU0NIRURfVEVYVA0KKwkJTE9DS19URVhUDQorCQkqKC5maXh1cCkN
CisJCS4gPSBBTElHTigxNik7DQorCX0NCisJX2V0ZXh0ID0gLjsNCisNCisjaWZkZWYgS0RBVEFf
QUREUg0KKwkuID0gS0RBVEFfQUREUjsNCisjZW5kaWYNCisNCisJX3NkYXRhID0gLjsNCisJUk9f
REFUQV9TRUNUSU9OKFBBR0VfU0laRSkNCisJUldfREFUQV9TRUNUSU9OKDE2LCBQQUdFX1NJWkUs
IFRIUkVBRF9TSVpFKQ0KKwlfZWRhdGEgPSAuOw0KKw0KKwlFWENFUFRJT05fVEFCTEUoMTYpDQor
CU5PVEVTDQorDQorCS4gPSBBTElHTihQQUdFX1NJWkUpOw0KKwlfX2luaXRfYmVnaW4gPSAuOw0K
KwlJTklUX1RFWFRfU0VDVElPTihQQUdFX1NJWkUpDQorCUlOSVRfREFUQV9TRUNUSU9OKDE2KQ0K
KwlQRVJDUFVfU0VDVElPTigxNikNCisJLm02OGtfZml4dXAgOiB7DQorCQlfX3N0YXJ0X2ZpeHVw
ID0gLjsNCisJCSooLm02OGtfZml4dXApDQorCQlfX3N0b3BfZml4dXAgPSAuOw0KKwl9DQorCS5p
bml0LmRhdGEgOiB7DQorCQkuID0gQUxJR04oUEFHRV9TSVpFKTsNCisJCV9faW5pdF9lbmQgPSAu
Ow0KKwl9DQorDQorCV9zYnNzID0gLjsNCisJQlNTX1NFQ1RJT04oMCwgMCwgMCkNCisJX2Vic3Mg
PSAuOw0KKw0KKwlfZW5kID0gLjsNCisNCisJU1RBQlNfREVCVUcNCisJLmNvbW1lbnQgMCA6IHsg
KiguY29tbWVudCkgfQ0KKw0KKwkvKiBTZWN0aW9ucyB0byBiZSBkaXNjYXJkZWQgKi8NCisJRElT
Q0FSRFMNCit9DQorDQpkaWZmIC0tZ2l0IGEvYXJjaC9tNjhrL2tlcm5lbC92bWxpbnV4Lmxkcy5T
IGIvYXJjaC9tNjhrL2tlcm5lbC92bWxpbnV4Lmxkcy5TDQppbmRleCAwMzBkYWJmLi42OWVjNzk2
IDEwMDY0NA0KLS0tIGEvYXJjaC9tNjhrL2tlcm5lbC92bWxpbnV4Lmxkcy5TDQorKysgYi9hcmNo
L202OGsva2VybmVsL3ZtbGludXgubGRzLlMNCkBAIC0xLDUgKzEsMTQgQEANCi0jaWZkZWYgQ09O
RklHX01NVQ0KLSNpbmNsdWRlICJ2bWxpbnV4Lmxkc19tbS5TIg0KKyNpZiBkZWZpbmVkKENPTkZJ
R19NTVUpICYmICFkZWZpbmVkKENPTkZJR19DT0xERklSRSkNCitQSERSUw0KK3sNCisgIHRleHQg
UFRfTE9BRCBGSUxFSERSIFBIRFJTIEZMQUdTICg3KTsNCisgIGRhdGEgUFRfTE9BRCBGTEFHUyAo
Nyk7DQorfQ0KKyNpZmRlZiBDT05GSUdfU1VOMw0KKyNpbmNsdWRlICJ2bWxpbnV4LXN1bjMubGRz
Ig0KICNlbHNlDQotI2luY2x1ZGUgInZtbGludXgubGRzX25vLlMiDQorI2luY2x1ZGUgInZtbGlu
dXgtc3RkLmxkcyINCisjZW5kaWYNCisjZWxzZQ0KKyNpbmNsdWRlICJ2bWxpbnV4LW5vbW11Lmxk
cyINCiAjZW5kaWYNCmRpZmYgLS1naXQgYS9hcmNoL202OGsva2VybmVsL3ZtbGludXgubGRzX21t
LlMgYi9hcmNoL202OGsva2VybmVsL3ZtbGludXgubGRzX21tLlMNCmRlbGV0ZWQgZmlsZSBtb2Rl
IDEwMDY0NA0KaW5kZXggOTliYTMxNS4uMDAwMDAwMA0KLS0tIGEvYXJjaC9tNjhrL2tlcm5lbC92
bWxpbnV4Lmxkc19tbS5TDQorKysgL2Rldi9udWxsDQpAQCAtMSwxMCArMCwwIEBADQotUEhEUlMN
Ci17DQotICB0ZXh0IFBUX0xPQUQgRklMRUhEUiBQSERSUyBGTEFHUyAoNyk7DQotICBkYXRhIFBU
X0xPQUQgRkxBR1MgKDcpOw0KLX0NCi0jaWZkZWYgQ09ORklHX1NVTjMNCi0jaW5jbHVkZSAidm1s
aW51eC1zdW4zLmxkcyINCi0jZWxzZQ0KLSNpbmNsdWRlICJ2bWxpbnV4LXN0ZC5sZHMiDQotI2Vu
ZGlmDQpkaWZmIC0tZ2l0IGEvYXJjaC9tNjhrL2tlcm5lbC92bWxpbnV4Lmxkc19uby5TIGIvYXJj
aC9tNjhrL2tlcm5lbC92bWxpbnV4Lmxkc19uby5TDQpkZWxldGVkIGZpbGUgbW9kZSAxMDA2NDQN
CmluZGV4IDRlMjM4OTMuLjAwMDAwMDANCi0tLSBhL2FyY2gvbTY4ay9rZXJuZWwvdm1saW51eC5s
ZHNfbm8uUw0KKysrIC9kZXYvbnVsbA0KQEAgLTEsMTg3ICswLDAgQEANCi0vKg0KLSAqCXZtbGlu
dXgubGRzLlMgLS0gbWFzdGVyIGxpbmtlciBzY3JpcHQgZm9yIG02OGtub21tdSBhcmNoDQotICoN
Ci0gKgkoQykgQ29weXJpZ2h0IDIwMDItMjAwNiwgR3JlZyBVbmdlcmVyIDxnZXJnQHNuYXBnZWFy
LmNvbT4NCi0gKg0KLSAqCVRoaXMgbGlua2VyIHNjcmlwdCBpcyBlcXVpcHBlZCB0byBidWlsZCBl
aXRoZXIgUk9NIGxvYWRlZCBvciBSQU0NCi0gKglydW4ga2VybmVscy4NCi0gKi8NCi0NCi0jaW5j
bHVkZSA8YXNtLWdlbmVyaWMvdm1saW51eC5sZHMuaD4NCi0jaW5jbHVkZSA8YXNtL3BhZ2UuaD4N
Ci0jaW5jbHVkZSA8YXNtL3RocmVhZF9pbmZvLmg+DQotDQotI2lmIGRlZmluZWQoQ09ORklHX1JB
TUtFUk5FTCkNCi0jZGVmaW5lCVJBTV9TVEFSVAlDT05GSUdfS0VSTkVMQkFTRQ0KLSNkZWZpbmUJ
UkFNX0xFTkdUSAkoQ09ORklHX1JBTUJBU0UgKyBDT05GSUdfUkFNU0laRSAtIENPTkZJR19LRVJO
RUxCQVNFKQ0KLSNkZWZpbmUJVEVYVAkJcmFtDQotI2RlZmluZQlEQVRBCQlyYW0NCi0jZGVmaW5l
CUlOSVQJCXJhbQ0KLSNkZWZpbmUJQlNTUwkJcmFtDQotI2VuZGlmDQotI2lmIGRlZmluZWQoQ09O
RklHX1JPTUtFUk5FTCkgfHwgZGVmaW5lZChDT05GSUdfSElNRU1LRVJORUwpDQotI2RlZmluZQlS
QU1fU1RBUlQJQ09ORklHX1JBTUJBU0UNCi0jZGVmaW5lCVJBTV9MRU5HVEgJQ09ORklHX1JBTVNJ
WkUNCi0jZGVmaW5lCVJPTVZFQ19TVEFSVAlDT05GSUdfUk9NVkVDDQotI2RlZmluZQlST01WRUNf
TEVOR1RICUNPTkZJR19ST01WRUNTSVpFDQotI2RlZmluZQlST01fU1RBUlQJQ09ORklHX1JPTVNU
QVJUDQotI2RlZmluZQlST01fTEVOR1RICUNPTkZJR19ST01TSVpFDQotI2RlZmluZQlURVhUCQly
b20NCi0jZGVmaW5lCURBVEEJCXJhbQ0KLSNkZWZpbmUJSU5JVAkJcmFtDQotI2RlZmluZQlCU1NT
CQlyYW0NCi0jZW5kaWYNCi0NCi0jaWZuZGVmIERBVEFfQUREUg0KLSNkZWZpbmUJREFUQV9BRERS
DQotI2VuZGlmDQotDQotDQotT1VUUFVUX0FSQ0gobTY4aykNCi1FTlRSWShfc3RhcnQpDQotDQot
TUVNT1JZIHsNCi0JcmFtCTogT1JJR0lOID0gUkFNX1NUQVJULCBMRU5HVEggPSBSQU1fTEVOR1RI
DQotI2lmZGVmIFJPTV9TVEFSVA0KLQlyb212ZWMJOiBPUklHSU4gPSBST01WRUNfU1RBUlQsIExF
TkdUSCA9IFJPTVZFQ19MRU5HVEgNCi0Jcm9tCTogT1JJR0lOID0gUk9NX1NUQVJULCBMRU5HVEgg
PSBST01fTEVOR1RIDQotI2VuZGlmDQotfQ0KLQ0KLWppZmZpZXMgPSBqaWZmaWVzXzY0ICsgNDsN
Ci0NCi1TRUNUSU9OUyB7DQotDQotI2lmZGVmIFJPTVZFQ19TVEFSVA0KLQkuID0gUk9NVkVDX1NU
QVJUIDsNCi0JLnJvbXZlYyA6IHsNCi0JCV9fcm9tX3N0YXJ0ID0gLiA7DQotCQlfcm9tdmVjID0g
LjsNCi0JCSooLmRhdGEuLmluaXR2ZWN0KQ0KLQl9ID4gcm9tdmVjDQotI2VuZGlmDQotDQotCS50
ZXh0IDogew0KLQkJX3RleHQgPSAuOw0KLQkJX3N0ZXh0ID0gLiA7DQotCQlIRUFEX1RFWFQNCi0J
CVRFWFRfVEVYVA0KLQkJU0NIRURfVEVYVA0KLQkJTE9DS19URVhUDQotCQkqKC50ZXh0Li5sb2Nr
KQ0KLQ0KLQkJLiA9IEFMSUdOKDE2KTsgICAgICAgICAgLyogRXhjZXB0aW9uIHRhYmxlICAgICAg
ICAgICAgICAqLw0KLQkJX19zdGFydF9fX2V4X3RhYmxlID0gLjsNCi0JCSooX19leF90YWJsZSkN
Ci0JCV9fc3RvcF9fX2V4X3RhYmxlID0gLjsNCi0NCi0JCSooLnJvZGF0YSkgKigucm9kYXRhLiop
DQotCQkqKF9fdmVybWFnaWMpCQkvKiBLZXJuZWwgdmVyc2lvbiBtYWdpYyAqLw0KLQkJKigucm9k
YXRhMSkNCi0JCSooLnJvZGF0YS5zdHIxLjEpDQotDQotCQkvKiBLZXJuZWwgc3ltYm9sIHRhYmxl
OiBOb3JtYWwgc3ltYm9scyAqLw0KLQkJLiA9IEFMSUdOKDQpOw0KLQkJX19zdGFydF9fX2tzeW10
YWIgPSAuOw0KLQkJKihTT1JUKF9fX2tzeW10YWIrKikpDQotCQlfX3N0b3BfX19rc3ltdGFiID0g
LjsNCi0NCi0JCS8qIEtlcm5lbCBzeW1ib2wgdGFibGU6IEdQTC1vbmx5IHN5bWJvbHMgKi8NCi0J
CV9fc3RhcnRfX19rc3ltdGFiX2dwbCA9IC47DQotCQkqKFNPUlQoX19fa3N5bXRhYl9ncGwrKikp
DQotCQlfX3N0b3BfX19rc3ltdGFiX2dwbCA9IC47DQotDQotCQkvKiBLZXJuZWwgc3ltYm9sIHRh
YmxlOiBOb3JtYWwgdW51c2VkIHN5bWJvbHMgKi8NCi0JCV9fc3RhcnRfX19rc3ltdGFiX3VudXNl
ZCA9IC47DQotCQkqKFNPUlQoX19fa3N5bXRhYl91bnVzZWQrKikpDQotCQlfX3N0b3BfX19rc3lt
dGFiX3VudXNlZCA9IC47DQotDQotCQkvKiBLZXJuZWwgc3ltYm9sIHRhYmxlOiBHUEwtb25seSB1
bnVzZWQgc3ltYm9scyAqLw0KLQkJX19zdGFydF9fX2tzeW10YWJfdW51c2VkX2dwbCA9IC47DQot
CQkqKFNPUlQoX19fa3N5bXRhYl91bnVzZWRfZ3BsKyopKQ0KLQkJX19zdG9wX19fa3N5bXRhYl91
bnVzZWRfZ3BsID0gLjsNCi0NCi0JCS8qIEtlcm5lbCBzeW1ib2wgdGFibGU6IEdQTC1mdXR1cmUg
c3ltYm9scyAqLw0KLQkJX19zdGFydF9fX2tzeW10YWJfZ3BsX2Z1dHVyZSA9IC47DQotCQkqKFNP
UlQoX19fa3N5bXRhYl9ncGxfZnV0dXJlKyopKQ0KLQkJX19zdG9wX19fa3N5bXRhYl9ncGxfZnV0
dXJlID0gLjsNCi0NCi0JCS8qIEtlcm5lbCBzeW1ib2wgdGFibGU6IE5vcm1hbCBzeW1ib2xzICov
DQotCQlfX3N0YXJ0X19fa2NyY3RhYiA9IC47DQotCQkqKFNPUlQoX19fa2NyY3RhYisqKSkNCi0J
CV9fc3RvcF9fX2tjcmN0YWIgPSAuOw0KLQ0KLQkJLyogS2VybmVsIHN5bWJvbCB0YWJsZTogR1BM
LW9ubHkgc3ltYm9scyAqLw0KLQkJX19zdGFydF9fX2tjcmN0YWJfZ3BsID0gLjsNCi0JCSooU09S
VChfX19rY3JjdGFiX2dwbCsqKSkNCi0JCV9fc3RvcF9fX2tjcmN0YWJfZ3BsID0gLjsNCi0NCi0J
CS8qIEtlcm5lbCBzeW1ib2wgdGFibGU6IE5vcm1hbCB1bnVzZWQgc3ltYm9scyAqLw0KLQkJX19z
dGFydF9fX2tjcmN0YWJfdW51c2VkID0gLjsNCi0JCSooU09SVChfX19rY3JjdGFiX3VudXNlZCsq
KSkNCi0JCV9fc3RvcF9fX2tjcmN0YWJfdW51c2VkID0gLjsNCi0NCi0JCS8qIEtlcm5lbCBzeW1i
b2wgdGFibGU6IEdQTC1vbmx5IHVudXNlZCBzeW1ib2xzICovDQotCQlfX3N0YXJ0X19fa2NyY3Rh
Yl91bnVzZWRfZ3BsID0gLjsNCi0JCSooU09SVChfX19rY3JjdGFiX3VudXNlZF9ncGwrKikpDQot
CQlfX3N0b3BfX19rY3JjdGFiX3VudXNlZF9ncGwgPSAuOw0KLQ0KLQkJLyogS2VybmVsIHN5bWJv
bCB0YWJsZTogR1BMLWZ1dHVyZSBzeW1ib2xzICovDQotCQlfX3N0YXJ0X19fa2NyY3RhYl9ncGxf
ZnV0dXJlID0gLjsNCi0JCSooU09SVChfX19rY3JjdGFiX2dwbF9mdXR1cmUrKikpDQotCQlfX3N0
b3BfX19rY3JjdGFiX2dwbF9mdXR1cmUgPSAuOw0KLQ0KLQkJLyogS2VybmVsIHN5bWJvbCB0YWJs
ZTogc3RyaW5ncyAqLw0KLQkJKihfX2tzeW10YWJfc3RyaW5ncykNCi0NCi0JCS8qIEJ1aWx0LWlu
IG1vZHVsZSBwYXJhbWV0ZXJzICovDQotCQkuID0gQUxJR04oNCkgOw0KLQkJX19zdGFydF9fX3Bh
cmFtID0gLjsNCi0JCSooX19wYXJhbSkNCi0JCV9fc3RvcF9fX3BhcmFtID0gLjsNCi0NCi0JCS8q
IEJ1aWx0LWluIG1vZHVsZSB2ZXJzaW9ucyAqLw0KLQkJLiA9IEFMSUdOKDQpIDsNCi0JCV9fc3Rh
cnRfX19tb2R2ZXIgPSAuOw0KLQkJKihfX21vZHZlcikNCi0JCV9fc3RvcF9fX21vZHZlciA9IC47
DQotDQotCQkuID0gQUxJR04oNCkgOw0KLQkJX2V0ZXh0ID0gLiA7DQotCX0gPiBURVhUDQotDQot
CS5kYXRhIERBVEFfQUREUiA6IHsNCi0JCS4gPSBBTElHTig0KTsNCi0JCV9zZGF0YSA9IC4gOw0K
LQkJREFUQV9EQVRBDQotCQlDQUNIRUxJTkVfQUxJR05FRF9EQVRBKDMyKQ0KLQkJUEFHRV9BTElH
TkVEX0RBVEEoUEFHRV9TSVpFKQ0KLQkJKiguZGF0YS4uc2hhcmVkX2FsaWduZWQpDQotCQlJTklU
X1RBU0tfREFUQShUSFJFQURfU0laRSkNCi0JCV9lZGF0YSA9IC4gOw0KLQl9ID4gREFUQQ0KLQ0K
LQkuaW5pdC50ZXh0IDogew0KLQkJLiA9IEFMSUdOKFBBR0VfU0laRSk7DQotCQlfX2luaXRfYmVn
aW4gPSAuOw0KLQl9ID4gSU5JVA0KLQlJTklUX1RFWFRfU0VDVElPTihQQUdFX1NJWkUpID4gSU5J
VA0KLQlJTklUX0RBVEFfU0VDVElPTigxNikgPiBJTklUDQotCS5pbml0LmRhdGEgOiB7DQotCQku
ID0gQUxJR04oUEFHRV9TSVpFKTsNCi0JCV9faW5pdF9lbmQgPSAuOw0KLQl9ID4gSU5JVA0KLQ0K
LQkuYnNzIDogew0KLQkJLiA9IEFMSUdOKDQpOw0KLQkJX3Nic3MgPSAuIDsNCi0JCSooLmJzcykN
Ci0JCSooQ09NTU9OKQ0KLQkJLiA9IEFMSUdOKDQpIDsNCi0JCV9lYnNzID0gLiA7DQotCSAJX2Vu
ZCA9IC4gOw0KLQl9ID4gQlNTUw0KLQ0KLQlESVNDQVJEUw0KLX0NCi0NCmRpZmYgLS1naXQgYS9h
cmNoL3BhcmlzYy9tbS9pbml0LmMgYi9hcmNoL3BhcmlzYy9tbS9pbml0LmMNCmluZGV4IDgyZjM2
NGUuLjBiNjIxNjIgMTAwNjQ0DQotLS0gYS9hcmNoL3BhcmlzYy9tbS9pbml0LmMNCisrKyBiL2Fy
Y2gvcGFyaXNjL21tL2luaXQuYw0KQEAgLTY4NSw2ICs2ODUsOCBAQCB2b2lkIHNob3dfbWVtKHVu
c2lnbmVkIGludCBmaWx0ZXIpDQogDQogCXByaW50ayhLRVJOX0lORk8gIk1lbS1pbmZvOlxuIik7
DQogCXNob3dfZnJlZV9hcmVhcyhmaWx0ZXIpOw0KKwlpZiAoZmlsdGVyICYgU0hPV19NRU1fRklM
VEVSX1BBR0VfQ09VTlQpDQorCQlyZXR1cm47DQogI2lmbmRlZiBDT05GSUdfRElTQ09OVElHTUVN
DQogCWkgPSBtYXhfbWFwbnI7DQogCXdoaWxlIChpLS0gPiAwKSB7DQpkaWZmIC0tZ2l0IGEvYXJj
aC9wb3dlcnBjL2tlcm5lbC9hbGlnbi5jIGIvYXJjaC9wb3dlcnBjL2tlcm5lbC9hbGlnbi5jDQpp
bmRleCA4MTg0ZWU5Li4zZmNiYWUwIDEwMDY0NA0KLS0tIGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9h
bGlnbi5jDQorKysgYi9hcmNoL3Bvd2VycGMva2VybmVsL2FsaWduLmMNCkBAIC03NjQsNiArNzY0
LDE2IEBAIGludCBmaXhfYWxpZ25tZW50KHN0cnVjdCBwdF9yZWdzICpyZWdzKQ0KIAluYiA9IGFs
aWduaW5mb1tpbnN0cl0ubGVuOw0KIAlmbGFncyA9IGFsaWduaW5mb1tpbnN0cl0uZmxhZ3M7DQog
DQorCS8qIGxkYnJ4L3N0ZGJyeCBvdmVybGFwIGxmcy9zdGZzIGluIHRoZSBEU0lTUiB1bmZvcnR1
bmF0ZWx5ICovDQorCWlmIChJU19YRk9STShpbnN0cnVjdGlvbikgJiYgKChpbnN0cnVjdGlvbiA+
PiAxKSAmIDB4M2ZmKSA9PSA1MzIpIHsNCisJCW5iID0gODsNCisJCWZsYWdzID0gTEQrU1c7DQor
CX0gZWxzZSBpZiAoSVNfWEZPUk0oaW5zdHJ1Y3Rpb24pICYmDQorCQkgICAoKGluc3RydWN0aW9u
ID4+IDEpICYgMHgzZmYpID09IDY2MCkgew0KKwkJbmIgPSA4Ow0KKwkJZmxhZ3MgPSBTVCtTVzsN
CisJfQ0KKw0KIAkvKiBCeXRlc3dhcCBsaXR0bGUgZW5kaWFuIGxvYWRzIGFuZCBzdG9yZXMgKi8N
CiAJc3dpeiA9IDA7DQogCWlmIChyZWdzLT5tc3IgJiBNU1JfTEUpIHsNCmRpZmYgLS1naXQgYS9h
cmNoL3Bvd2VycGMva2VybmVsL2lvbW11LmMgYi9hcmNoL3Bvd2VycGMva2VybmVsL2lvbW11LmMN
CmluZGV4IDBjZmNmOTguLmQwYjIwNWMgMTAwNjQ0DQotLS0gYS9hcmNoL3Bvd2VycGMva2VybmVs
L2lvbW11LmMNCisrKyBiL2FyY2gvcG93ZXJwYy9rZXJuZWwvaW9tbXUuYw0KQEAgLTQ5NSw3ICs0
OTUsNyBAQCBzdHJ1Y3QgaW9tbXVfdGFibGUgKmlvbW11X2luaXRfdGFibGUoc3RydWN0IGlvbW11
X3RhYmxlICp0YmwsIGludCBuaWQpDQogCS8qIG51bWJlciBvZiBieXRlcyBuZWVkZWQgZm9yIHRo
ZSBiaXRtYXAgKi8NCiAJc3ogPSAodGJsLT5pdF9zaXplICsgNykgPj4gMzsNCiANCi0JcGFnZSA9
IGFsbG9jX3BhZ2VzX25vZGUobmlkLCBHRlBfQVRPTUlDLCBnZXRfb3JkZXIoc3opKTsNCisJcGFn
ZSA9IGFsbG9jX3BhZ2VzX25vZGUobmlkLCBHRlBfS0VSTkVMLCBnZXRfb3JkZXIoc3opKTsNCiAJ
aWYgKCFwYWdlKQ0KIAkJcGFuaWMoImlvbW11X2luaXRfdGFibGU6IENhbid0IGFsbG9jYXRlICVs
ZCBieXRlc1xuIiwgc3opOw0KIAl0YmwtPml0X21hcCA9IHBhZ2VfYWRkcmVzcyhwYWdlKTsNCmRp
ZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMva2VybmVsL2xwYXJjZmcuYyBiL2FyY2gvcG93ZXJwYy9r
ZXJuZWwvbHBhcmNmZy5jDQppbmRleCA4MjY2ODFkLi4yNmFmMjRiIDEwMDY0NA0KLS0tIGEvYXJj
aC9wb3dlcnBjL2tlcm5lbC9scGFyY2ZnLmMNCisrKyBiL2FyY2gvcG93ZXJwYy9rZXJuZWwvbHBh
cmNmZy5jDQpAQCAtMzc1LDYgKzM3NSw3IEBAIHN0YXRpYyB2b2lkIHBhcnNlX3N5c3RlbV9wYXJh
bWV0ZXJfc3RyaW5nKHN0cnVjdCBzZXFfZmlsZSAqbSkNCiAJCQkJX19wYShydGFzX2RhdGFfYnVm
KSwNCiAJCQkJUlRBU19EQVRBX0JVRl9TSVpFKTsNCiAJbWVtY3B5KGxvY2FsX2J1ZmZlciwgcnRh
c19kYXRhX2J1ZiwgU1BMUEFSX01BWExFTkdUSCk7DQorCWxvY2FsX2J1ZmZlcltTUExQQVJfTUFY
TEVOR1RIIC0gMV0gPSAnXDAnOw0KIAlzcGluX3VubG9jaygmcnRhc19kYXRhX2J1Zl9sb2NrKTsN
CiANCiAJaWYgKGNhbGxfc3RhdHVzICE9IDApIHsNCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMv
a2VybmVsL3N5c2ZzLmMgYi9hcmNoL3Bvd2VycGMva2VybmVsL3N5c2ZzLmMNCmluZGV4IDU1YmU2
NGQuLmNhNjgzYTEgMTAwNjQ0DQotLS0gYS9hcmNoL3Bvd2VycGMva2VybmVsL3N5c2ZzLmMNCisr
KyBiL2FyY2gvcG93ZXJwYy9rZXJuZWwvc3lzZnMuYw0KQEAgLTE4LDYgKzE4LDcgQEANCiAjaW5j
bHVkZSA8YXNtL21hY2hkZXAuaD4NCiAjaW5jbHVkZSA8YXNtL3NtcC5oPg0KICNpbmNsdWRlIDxh
c20vcG1jLmg+DQorI2luY2x1ZGUgPGFzbS9maXJtd2FyZS5oPg0KIA0KICNpbmNsdWRlICJjYWNo
ZWluZm8uaCINCiANCkBAIC0xNzgsMTQgKzE3OSwyNCBAQCBTWVNGU19QTUNTRVRVUChwdXJyLCBT
UFJOX1BVUlIpOw0KIFNZU0ZTX1BNQ1NFVFVQKHNwdXJyLCBTUFJOX1NQVVJSKTsNCiBTWVNGU19Q
TUNTRVRVUChkc2NyLCBTUFJOX0RTQ1IpOw0KIA0KKy8qDQorICBMZXRzIG9ubHkgZW5hYmxlIHJl
YWQgZm9yIHBoeXAgcmVzb3VyY2VzIGFuZA0KKyAgZW5hYmxlIHdyaXRlIHdoZW4gbmVlZGVkIHdp
dGggYSBzZXBhcmF0ZSBmdW5jdGlvbi4NCisgIExldHMgYmUgY29uc2VydmF0aXZlIGFuZCBkZWZh
dWx0IHRvIHBzZXJpZXMuDQorKi8NCiBzdGF0aWMgU1lTREVWX0FUVFIobW1jcmEsIDA2MDAsIHNo
b3dfbW1jcmEsIHN0b3JlX21tY3JhKTsNCiBzdGF0aWMgU1lTREVWX0FUVFIoc3B1cnIsIDA2MDAs
IHNob3dfc3B1cnIsIE5VTEwpOw0KIHN0YXRpYyBTWVNERVZfQVRUUihkc2NyLCAwNjAwLCBzaG93
X2RzY3IsIHN0b3JlX2RzY3IpOw0KLXN0YXRpYyBTWVNERVZfQVRUUihwdXJyLCAwNjAwLCBzaG93
X3B1cnIsIHN0b3JlX3B1cnIpOw0KK3N0YXRpYyBTWVNERVZfQVRUUihwdXJyLCAwNDAwLCBzaG93
X3B1cnIsIHN0b3JlX3B1cnIpOw0KIA0KIHVuc2lnbmVkIGxvbmcgZHNjcl9kZWZhdWx0ID0gMDsN
CiBFWFBPUlRfU1lNQk9MKGRzY3JfZGVmYXVsdCk7DQogDQorc3RhdGljIHZvaWQgYWRkX3dyaXRl
X3Blcm1pc3Npb25fZGV2X2F0dHIoc3RydWN0IHN5c2Rldl9hdHRyaWJ1dGUgKmF0dHIpDQorew0K
KwlhdHRyLT5hdHRyLm1vZGUgfD0gMDIwMDsNCit9DQorDQogc3RhdGljIHNzaXplX3Qgc2hvd19k
c2NyX2RlZmF1bHQoc3RydWN0IHN5c2Rldl9jbGFzcyAqY2xhc3MsDQogCQlzdHJ1Y3Qgc3lzZGV2
X2NsYXNzX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQ0KIHsNCkBAIC0zOTQsOCArNDA1LDEx
IEBAIHN0YXRpYyB2b2lkIF9fY3B1aW5pdCByZWdpc3Rlcl9jcHVfb25saW5lKHVuc2lnbmVkIGlu
dCBjcHUpDQogCWlmIChjcHVfaGFzX2ZlYXR1cmUoQ1BVX0ZUUl9NTUNSQSkpDQogCQlzeXNkZXZf
Y3JlYXRlX2ZpbGUocywgJmF0dHJfbW1jcmEpOw0KIA0KLQlpZiAoY3B1X2hhc19mZWF0dXJlKENQ
VV9GVFJfUFVSUikpDQorCWlmIChjcHVfaGFzX2ZlYXR1cmUoQ1BVX0ZUUl9QVVJSKSkgew0KKwkJ
aWYgKCFmaXJtd2FyZV9oYXNfZmVhdHVyZShGV19GRUFUVVJFX0xQQVIpKQ0KKwkJCWFkZF93cml0
ZV9wZXJtaXNzaW9uX2Rldl9hdHRyKCZhdHRyX3B1cnIpOw0KIAkJc3lzZGV2X2NyZWF0ZV9maWxl
KHMsICZhdHRyX3B1cnIpOw0KKwl9DQogDQogCWlmIChjcHVfaGFzX2ZlYXR1cmUoQ1BVX0ZUUl9T
UFVSUikpDQogCQlzeXNkZXZfY3JlYXRlX2ZpbGUocywgJmF0dHJfc3B1cnIpOw0KZGlmZiAtLWdp
dCBhL2FyY2gvcG93ZXJwYy9saWIvY2hlY2tzdW1fNjQuUyBiL2FyY2gvcG93ZXJwYy9saWIvY2hl
Y2tzdW1fNjQuUw0KaW5kZXggMTgyNDVhZi4uM2NkYmM2NCAxMDA2NDQNCi0tLSBhL2FyY2gvcG93
ZXJwYy9saWIvY2hlY2tzdW1fNjQuUw0KKysrIGIvYXJjaC9wb3dlcnBjL2xpYi9jaGVja3N1bV82
NC5TDQpAQCAtMjI5LDE5ICsyMjksMzUgQEAgX0dMT0JBTChjc3VtX3BhcnRpYWwpDQogCWJscg0K
IA0KIA0KLQkubWFjcm8gc291cmNlDQorCS5tYWNybyBzcmNucg0KIDEwMDoNCiAJLnNlY3Rpb24g
X19leF90YWJsZSwiYSINCiAJLmFsaWduIDMNCi0JLmxsb25nIDEwMGIsLkxzcmNfZXJyb3INCisJ
Lmxsb25nIDEwMGIsLkxzcmNfZXJyb3JfbnINCiAJLnByZXZpb3VzDQogCS5lbmRtDQogDQotCS5t
YWNybyBkZXN0DQorCS5tYWNybyBzb3VyY2UNCisxNTA6DQorCS5zZWN0aW9uIF9fZXhfdGFibGUs
ImEiDQorCS5hbGlnbiAzDQorCS5sbG9uZyAxNTBiLC5Mc3JjX2Vycm9yDQorCS5wcmV2aW91cw0K
KwkuZW5kbQ0KKw0KKwkubWFjcm8gZHN0bnINCiAyMDA6DQogCS5zZWN0aW9uIF9fZXhfdGFibGUs
ImEiDQogCS5hbGlnbiAzDQotCS5sbG9uZyAyMDBiLC5MZGVzdF9lcnJvcg0KKwkubGxvbmcgMjAw
YiwuTGRlc3RfZXJyb3JfbnINCisJLnByZXZpb3VzDQorCS5lbmRtDQorDQorCS5tYWNybyBkZXN0
DQorMjUwOg0KKwkuc2VjdGlvbiBfX2V4X3RhYmxlLCJhIg0KKwkuYWxpZ24gMw0KKwkubGxvbmcg
MjUwYiwuTGRlc3RfZXJyb3INCiAJLnByZXZpb3VzDQogCS5lbmRtDQogDQpAQCAtMjcyLDE2ICsy
ODgsMTYgQEAgX0dMT0JBTChjc3VtX3BhcnRpYWxfY29weV9nZW5lcmljKQ0KIAlybGRpY2wuIHI2
LHIzLDY0LTEsNjQtMgkJLyogcjYgPSAocjMgJiAweDMpID4+IDEgKi8NCiAJYmVxCS5MY29weV9h
bGlnbmVkDQogDQotCWxpCXI3LDQNCi0Jc3ViCXI2LHI3LHI2DQorCWxpCXI5LDQNCisJc3ViCXI2
LHI5LHI2DQogCW10Y3RyCXI2DQogDQogMToNCi1zb3VyY2U7CWxoeglyNiwwKHIzKQkJLyogYWxp
Z24gdG8gZG91Ymxld29yZCAqLw0KK3NyY25yOwlsaHoJcjYsMChyMykJCS8qIGFsaWduIHRvIGRv
dWJsZXdvcmQgKi8NCiAJc3ViaQlyNSxyNSwyDQogCWFkZGkJcjMscjMsMg0KIAlhZGRlCXIwLHIw
LHI2DQotZGVzdDsJc3RoCXI2LDAocjQpDQorZHN0bnI7CXN0aAlyNiwwKHI0KQ0KIAlhZGRpCXI0
LHI0LDINCiAJYmRuegkxYg0KIA0KQEAgLTM5NSwxMCArNDExLDEwIEBAIGRlc3Q7CXN0ZAlyMTYs
NTYocjQpDQogDQogCW10Y3RyCXI2DQogMzoNCi1zb3VyY2U7CWxkCXI2LDAocjMpDQorc3JjbnI7
CWxkCXI2LDAocjMpDQogCWFkZGkJcjMscjMsOA0KIAlhZGRlCXIwLHIwLHI2DQotZGVzdDsJc3Rk
CXI2LDAocjQpDQorZHN0bnI7CXN0ZAlyNiwwKHI0KQ0KIAlhZGRpCXI0LHI0LDgNCiAJYmRuegkz
Yg0KIA0KQEAgLTQwOCwxMCArNDI0LDEwIEBAIGRlc3Q7CXN0ZAlyNiwwKHI0KQ0KIAlzcmRpLgly
NixyNSwyDQogCWJlcQkuTGNvcHlfdGFpbF9oYWxmd29yZA0KIA0KLXNvdXJjZTsJbHd6CXI2LDAo
cjMpDQorc3JjbnI7CWx3eglyNiwwKHIzKQ0KIAlhZGRpCXIzLHIzLDQNCiAJYWRkZQlyMCxyMCxy
Ng0KLWRlc3Q7CXN0dwlyNiwwKHI0KQ0KK2RzdG5yOwlzdHcJcjYsMChyNCkNCiAJYWRkaQlyNCxy
NCw0DQogCXN1YmkJcjUscjUsNA0KIA0KQEAgLTQxOSwxMCArNDM1LDEwIEBAIGRlc3Q7CXN0dwly
NiwwKHI0KQ0KIAlzcmRpLglyNixyNSwxDQogCWJlcQkuTGNvcHlfdGFpbF9ieXRlDQogDQotc291
cmNlOwlsaHoJcjYsMChyMykNCitzcmNucjsJbGh6CXI2LDAocjMpDQogCWFkZGkJcjMscjMsMg0K
IAlhZGRlCXIwLHIwLHI2DQotZGVzdDsJc3RoCXI2LDAocjQpDQorZHN0bnI7CXN0aAlyNiwwKHI0
KQ0KIAlhZGRpCXI0LHI0LDINCiAJc3ViaQlyNSxyNSwyDQogDQpAQCAtNDMwLDEwICs0NDYsMTAg
QEAgZGVzdDsJc3RoCXI2LDAocjQpDQogCWFuZGkuCXI2LHI1LDENCiAJYmVxCS5MY29weV9maW5p
c2gNCiANCi1zb3VyY2U7CWxieglyNiwwKHIzKQ0KK3NyY25yOwlsYnoJcjYsMChyMykNCiAJc2xk
aQlyOSxyNiw4CQkJLyogUGFkIHRoZSBieXRlIG91dCB0byAxNiBiaXRzICovDQogCWFkZGUJcjAs
cjAscjkNCi1kZXN0OwlzdGIJcjYsMChyNCkNCitkc3RucjsJc3RiCXI2LDAocjQpDQogDQogLkxj
b3B5X2ZpbmlzaDoNCiAJYWRkemUJcjAscjAJCQkvKiBhZGQgaW4gZmluYWwgY2FycnkgKi8NCkBA
IC00NDMsNiArNDU5LDExIEBAIGRlc3Q7CXN0YglyNiwwKHI0KQ0KIAlibHINCiANCiAuTHNyY19l
cnJvcjoNCisJbGQJcjE0LFNUS19SRUcocjE0KShyMSkNCisJbGQJcjE1LFNUS19SRUcocjE1KShy
MSkNCisJbGQJcjE2LFNUS19SRUcocjE2KShyMSkNCisJYWRkaQlyMSxyMSxTVEFDS0ZSQU1FU0la
RQ0KKy5Mc3JjX2Vycm9yX25yOg0KIAljbXBkaQkwLHI3LDANCiAJYmVxbHINCiAJbGkJcjYsLUVG
QVVMVA0KQEAgLTQ1MCw2ICs0NzEsMTEgQEAgZGVzdDsJc3RiCXI2LDAocjQpDQogCWJscg0KIA0K
IC5MZGVzdF9lcnJvcjoNCisJbGQJcjE0LFNUS19SRUcocjE0KShyMSkNCisJbGQJcjE1LFNUS19S
RUcocjE1KShyMSkNCisJbGQJcjE2LFNUS19SRUcocjE2KShyMSkNCisJYWRkaQlyMSxyMSxTVEFD
S0ZSQU1FU0laRQ0KKy5MZGVzdF9lcnJvcl9ucjoNCiAJY21wZGkJMCxyOCwwDQogCWJlcWxyDQog
CWxpCXI2LC1FRkFVTFQNCmRpZmYgLS1naXQgYS9hcmNoL3NwYXJjL2tlcm5lbC9lbnRyeS5TIGIv
YXJjaC9zcGFyYy9rZXJuZWwvZW50cnkuUw0KaW5kZXggZjQ0NWU5OC4uY2ZhYmMzZCAxMDA2NDQN
Ci0tLSBhL2FyY2gvc3BhcmMva2VybmVsL2VudHJ5LlMNCisrKyBiL2FyY2gvc3BhcmMva2VybmVs
L2VudHJ5LlMNCkBAIC0xMTc3LDcgKzExNzcsNyBAQCBzeXNfc2lncmV0dXJuOg0KIAkgbm9wDQog
DQogCWNhbGwJc3lzY2FsbF90cmFjZQ0KLQkgbm9wDQorCSBtb3YJMSwgJW8xDQogDQogMToNCiAJ
LyogV2UgZG9uJ3Qgd2FudCB0byBtdWNrIHdpdGggdXNlciByZWdpc3RlcnMgbGlrZSBhDQpkaWZm
IC0tZ2l0IGEvYXJjaC9zcGFyYy9rZXJuZWwva3RsYi5TIGIvYXJjaC9zcGFyYy9rZXJuZWwva3Rs
Yi5TDQppbmRleCA3OWYzMTAzLi43YzAwNzM1IDEwMDY0NA0KLS0tIGEvYXJjaC9zcGFyYy9rZXJu
ZWwva3RsYi5TDQorKysgYi9hcmNoL3NwYXJjL2tlcm5lbC9rdGxiLlMNCkBAIC0yNSwxMSArMjUs
MTAgQEAga3ZtYXBfaXRsYjoNCiAJICovDQoga3ZtYXBfaXRsYl80djoNCiANCi1rdm1hcF9pdGxi
X25vbmxpbmVhcjoNCiAJLyogQ2F0Y2gga2VybmVsIE5VTEwgcG9pbnRlciBjYWxscy4gICovDQog
CXNldGhpCQklaGkoUEFHRV9TSVpFKSwgJWc1DQogCWNtcAkJJWc0LCAlZzUNCi0JYmxldSxwbgkJ
JXhjYywga3ZtYXBfZHRsYl9sb25ncGF0aA0KKwlibHUscG4JCSV4Y2MsIGt2bWFwX2l0bGJfbG9u
Z3BhdGgNCiAJIG5vcA0KIA0KIAlLRVJOX1RTQl9MT09LVVBfVEwxKCVnNCwgJWc2LCAlZzUsICVn
MSwgJWcyLCAlZzMsIGt2bWFwX2l0bGJfbG9hZCkNCmRpZmYgLS1naXQgYS9hcmNoL3NwYXJjL2tl
cm5lbC9zeXNjYWxscy5TIGIvYXJjaC9zcGFyYy9rZXJuZWwvc3lzY2FsbHMuUw0KaW5kZXggN2Y1
ZjY1ZC4uODE3MTg3ZCAxMDA2NDQNCi0tLSBhL2FyY2gvc3BhcmMva2VybmVsL3N5c2NhbGxzLlMN
CisrKyBiL2FyY2gvc3BhcmMva2VybmVsL3N5c2NhbGxzLlMNCkBAIC0xNDcsNyArMTQ3LDcgQEAg
bGludXhfc3lzY2FsbF90cmFjZTMyOg0KIAlzcmwJJWk0LCAwLCAlbzQNCiAJc3JsCSVpMSwgMCwg
JW8xDQogCXNybAklaTIsIDAsICVvMg0KLQliYSxwdAkleGNjLCAyZg0KKwliYSxwdAkleGNjLCA1
Zg0KIAkgc3JsCSVpMywgMCwgJW8zDQogDQogbGludXhfc3lzY2FsbF90cmFjZToNCkBAIC0xNzcs
MTMgKzE3NywxMyBAQCBsaW51eF9zcGFyY19zeXNjYWxsMzI6DQogCXNybAklaTEsIDAsICVvMQkJ
CQkhIElFVTAJR3JvdXANCiAJbGR4CVslZzYgKyBUSV9GTEFHU10sICVsMAkJISBMb2FkDQogDQot
CXNybAklaTUsIDAsICVvNQkJCQkhIElFVTENCisJc3JsCSVpMywgMCwgJW8zCQkJCSEgSUVVMA0K
IAlzcmwJJWkyLCAwLCAlbzIJCQkJISBJRVUwCUdyb3VwDQogCWFuZGNjCSVsMCwgKF9USUZfU1lT
Q0FMTF9UUkFDRXxfVElGX1NFQ0NPTVB8X1RJRl9TWVNDQUxMX0FVRElUfF9USUZfU1lTQ0FMTF9U
UkFDRVBPSU5UKSwgJWcwDQogCWJuZSxwbgklaWNjLCBsaW51eF9zeXNjYWxsX3RyYWNlMzIJCSEg
Q1RJDQogCSBtb3YJJWkwLCAlbDUJCQkJISBJRVUxDQotCWNhbGwJJWw3CQkJCQkhIENUSQlHcm91
cCBicmsgZm9yY2VkDQotCSBzcmwJJWkzLCAwLCAlbzMJCQkJISBJRVUwDQorNToJY2FsbAklbDcJ
CQkJCSEgQ1RJCUdyb3VwIGJyayBmb3JjZWQNCisJIHNybAklaTUsIDAsICVvNQkJCQkhIElFVTEN
CiAJYmEsYSxwdAkleGNjLCAzZg0KIA0KIAkvKiBMaW51eCBuYXRpdmUgc3lzdGVtIGNhbGxzIGVu
dGVyIGhlcmUuLi4gKi8NCmRpZmYgLS1naXQgYS9hcmNoL3NwYXJjL2tlcm5lbC90cmFtcG9saW5l
XzY0LlMgYi9hcmNoL3NwYXJjL2tlcm5lbC90cmFtcG9saW5lXzY0LlMNCmluZGV4IGRhMWI3ODEu
LjhmYTg0YTMgMTAwNjQ0DQotLS0gYS9hcmNoL3NwYXJjL2tlcm5lbC90cmFtcG9saW5lXzY0LlMN
CisrKyBiL2FyY2gvc3BhcmMva2VybmVsL3RyYW1wb2xpbmVfNjQuUw0KQEAgLTEzMSw3ICsxMzEs
NiBAQCBzdGFydHVwX2NvbnRpbnVlOg0KIAljbHIJCSVsNQ0KIAlzZXRoaQkJJWhpKG51bV9rZXJu
ZWxfaW1hZ2VfbWFwcGluZ3MpLCAlbDYNCiAJbGR1dwkJWyVsNiArICVsbyhudW1fa2VybmVsX2lt
YWdlX21hcHBpbmdzKV0sICVsNg0KLQlhZGQJCSVsNiwgMSwgJWw2DQogDQogCW1vdgkJMTUsICVs
Nw0KIAlCUkFOQ0hfSUZfQU5ZX0NIRUVUQUgoZzEsZzUsMmYpDQpAQCAtMjI0LDcgKzIyMyw2IEBA
IG5pYWdhcmFfbG9ja190bGI6DQogCWNscgkJJWw1DQogCXNldGhpCQklaGkobnVtX2tlcm5lbF9p
bWFnZV9tYXBwaW5ncyksICVsNg0KIAlsZHV3CQlbJWw2ICsgJWxvKG51bV9rZXJuZWxfaW1hZ2Vf
bWFwcGluZ3MpXSwgJWw2DQotCWFkZAkJJWw2LCAxLCAlbDYNCiANCiAxOg0KIAltb3YJCUhWX0ZB
U1RfTU1VX01BUF9QRVJNX0FERFIsICVvNQ0KZGlmZiAtLWdpdCBhL2FyY2gvc3BhcmMvbGliL2tz
eW1zLmMgYi9hcmNoL3NwYXJjL2xpYi9rc3ltcy5jDQppbmRleCAxYjMwYmIzLi5mYmI4MDA1IDEw
MDY0NA0KLS0tIGEvYXJjaC9zcGFyYy9saWIva3N5bXMuYw0KKysrIGIvYXJjaC9zcGFyYy9saWIv
a3N5bXMuYw0KQEAgLTEzMSwxNSArMTMxLDYgQEAgRVhQT1JUX1NZTUJPTChfX19jb3B5X2Zyb21f
dXNlcik7DQogRVhQT1JUX1NZTUJPTChfX19jb3B5X2luX3VzZXIpOw0KIEVYUE9SVF9TWU1CT0wo
X19jbGVhcl91c2VyKTsNCiANCi0vKiBSVyBzZW1hcGhvcmVzICovDQotRVhQT1JUX1NZTUJPTChf
X2Rvd25fcmVhZCk7DQotRVhQT1JUX1NZTUJPTChfX2Rvd25fcmVhZF90cnlsb2NrKTsNCi1FWFBP
UlRfU1lNQk9MKF9fZG93bl93cml0ZSk7DQotRVhQT1JUX1NZTUJPTChfX2Rvd25fd3JpdGVfdHJ5
bG9jayk7DQotRVhQT1JUX1NZTUJPTChfX3VwX3JlYWQpOw0KLUVYUE9SVF9TWU1CT0woX191cF93
cml0ZSk7DQotRVhQT1JUX1NZTUJPTChfX2Rvd25ncmFkZV93cml0ZSk7DQotDQogLyogQXRvbWlj
IGNvdW50ZXIgaW1wbGVtZW50YXRpb24uICovDQogRVhQT1JUX1NZTUJPTChhdG9taWNfYWRkKTsN
CiBFWFBPUlRfU1lNQk9MKGF0b21pY19hZGRfcmV0KTsNCmRpZmYgLS1naXQgYS9hcmNoL3VuaWNv
cmUzMi9tbS9pbml0LmMgYi9hcmNoL3VuaWNvcmUzMi9tbS9pbml0LmMNCmluZGV4IDNiMzc5Y2Qu
LmQxYWY0ZWQgMTAwNjQ0DQotLS0gYS9hcmNoL3VuaWNvcmUzMi9tbS9pbml0LmMNCisrKyBiL2Fy
Y2gvdW5pY29yZTMyL21tL2luaXQuYw0KQEAgLTY1LDYgKzY1LDkgQEAgdm9pZCBzaG93X21lbSh1
bnNpZ25lZCBpbnQgZmlsdGVyKQ0KIAlwcmludGsoS0VSTl9ERUZBVUxUICJNZW0taW5mbzpcbiIp
Ow0KIAlzaG93X2ZyZWVfYXJlYXMoZmlsdGVyKTsNCiANCisJaWYgKGZpbHRlciAmIFNIT1dfTUVN
X0ZJTFRFUl9QQUdFX0NPVU5UKQ0KKwkJcmV0dXJuOw0KKw0KIAlmb3JfZWFjaF9iYW5rKGksIG1p
KSB7DQogCQlzdHJ1Y3QgbWVtYmFuayAqYmFuayA9ICZtaS0+YmFua1tpXTsNCiAJCXVuc2lnbmVk
IGludCBwZm4xLCBwZm4yOw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYyBi
L2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYw0KaW5kZXggNDdmNGU1Zi4uYTRlMWI0YiAxMDA2NDQN
Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYw0KKysrIGIvYXJjaC94ODYva2VybmVsL3Jl
Ym9vdC5jDQpAQCAtNDY4LDYgKzQ2OCwyMiBAQCBzdGF0aWMgc3RydWN0IGRtaV9zeXN0ZW1faWQg
X19pbml0ZGF0YSBwY2lfcmVib290X2RtaV90YWJsZVtdID0gew0KIAkJCURNSV9NQVRDSChETUlf
UFJPRFVDVF9OQU1FLCAiUHJlY2lzaW9uIE02NjAwIiksDQogCQl9LA0KIAl9LA0KKwl7CS8qIEhh
bmRsZSBwcm9ibGVtcyB3aXRoIHJlYm9vdGluZyBvbiB0aGUgRGVsbCBQb3dlckVkZ2UgQzYxMDAu
ICovDQorCQkuY2FsbGJhY2sgPSBzZXRfcGNpX3JlYm9vdCwNCisJCS5pZGVudCA9ICJEZWxsIFBv
d2VyRWRnZSBDNjEwMCIsDQorCQkubWF0Y2hlcyA9IHsNCisJCQlETUlfTUFUQ0goRE1JX1NZU19W
RU5ET1IsICJEZWxsIEluYy4iKSwNCisJCQlETUlfTUFUQ0goRE1JX1BST0RVQ1RfTkFNRSwgIkM2
MTAwIiksDQorCQl9LA0KKwl9LA0KKwl7CS8qIFNvbWUgQzYxMDAgbWFjaGluZXMgd2VyZSBzaGlw
cGVkIHdpdGggdmVuZG9yIGJlaW5nICdEZWxsJy4gKi8NCisJCS5jYWxsYmFjayA9IHNldF9wY2lf
cmVib290LA0KKwkJLmlkZW50ID0gIkRlbGwgUG93ZXJFZGdlIEM2MTAwIiwNCisJCS5tYXRjaGVz
ID0gew0KKwkJCURNSV9NQVRDSChETUlfU1lTX1ZFTkRPUiwgIkRlbGwiKSwNCisJCQlETUlfTUFU
Q0goRE1JX1BST0RVQ1RfTkFNRSwgIkM2MTAwIiksDQorCQl9LA0KKwl9LA0KIAl7IH0NCiB9Ow0K
IA0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L3BsYXRmb3JtL2VmaS9lZmkuYyBiL2FyY2gveDg2L3Bs
YXRmb3JtL2VmaS9lZmkuYw0KaW5kZXggZjk1MzdlMy4uYTE4ZDIwZCAxMDA2NDQNCi0tLSBhL2Fy
Y2gveDg2L3BsYXRmb3JtL2VmaS9lZmkuYw0KKysrIGIvYXJjaC94ODYvcGxhdGZvcm0vZWZpL2Vm
aS5jDQpAQCAtNzAzLDEwICs3MDMsMTMgQEAgdm9pZCBfX2luaXQgZWZpX2VudGVyX3ZpcnR1YWxf
bW9kZSh2b2lkKQ0KIA0KIAlmb3IgKHAgPSBtZW1tYXAubWFwOyBwIDwgbWVtbWFwLm1hcF9lbmQ7
IHAgKz0gbWVtbWFwLmRlc2Nfc2l6ZSkgew0KIAkJbWQgPSBwOw0KLQkJaWYgKCEobWQtPmF0dHJp
YnV0ZSAmIEVGSV9NRU1PUllfUlVOVElNRSkgJiYNCi0JCSAgICBtZC0+dHlwZSAhPSBFRklfQk9P
VF9TRVJWSUNFU19DT0RFICYmDQotCQkgICAgbWQtPnR5cGUgIT0gRUZJX0JPT1RfU0VSVklDRVNf
REFUQSkNCi0JCQljb250aW51ZTsNCisJCWlmICghKG1kLT5hdHRyaWJ1dGUgJiBFRklfTUVNT1JZ
X1JVTlRJTUUpKSB7DQorI2lmZGVmIENPTkZJR19YODZfNjQNCisJCQlpZiAobWQtPnR5cGUgIT0g
RUZJX0JPT1RfU0VSVklDRVNfQ09ERSAmJg0KKwkJCSAgICBtZC0+dHlwZSAhPSBFRklfQk9PVF9T
RVJWSUNFU19EQVRBKQ0KKyNlbmRpZg0KKwkJCQljb250aW51ZTsNCisJCX0NCiANCiAJCXNpemUg
PSBtZC0+bnVtX3BhZ2VzIDw8IEVGSV9QQUdFX1NISUZUOw0KIAkJZW5kID0gbWQtPnBoeXNfYWRk
ciArIHNpemU7DQpkaWZmIC0tZ2l0IGEvY3J5cHRvL2FwaS5jIGIvY3J5cHRvL2FwaS5jDQppbmRl
eCAwMzNhNzE0Li5jZWEzY2Y2IDEwMDY0NA0KLS0tIGEvY3J5cHRvL2FwaS5jDQorKysgYi9jcnlw
dG8vYXBpLmMNCkBAIC0zNCw2ICszNCw4IEBAIEVYUE9SVF9TWU1CT0xfR1BMKGNyeXB0b19hbGdf
c2VtKTsNCiBCTE9DS0lOR19OT1RJRklFUl9IRUFEKGNyeXB0b19jaGFpbik7DQogRVhQT1JUX1NZ
TUJPTF9HUEwoY3J5cHRvX2NoYWluKTsNCiANCitzdGF0aWMgc3RydWN0IGNyeXB0b19hbGcgKmNy
eXB0b19sYXJ2YWxfd2FpdChzdHJ1Y3QgY3J5cHRvX2FsZyAqYWxnKTsNCisNCiBzdGF0aWMgaW5s
aW5lIHN0cnVjdCBjcnlwdG9fYWxnICpjcnlwdG9fYWxnX2dldChzdHJ1Y3QgY3J5cHRvX2FsZyAq
YWxnKQ0KIHsNCiAJYXRvbWljX2luYygmYWxnLT5jcmFfcmVmY250KTsNCkBAIC0xNTAsOCArMTUy
LDExIEBAIHN0YXRpYyBzdHJ1Y3QgY3J5cHRvX2FsZyAqY3J5cHRvX2xhcnZhbF9hZGQoY29uc3Qg
Y2hhciAqbmFtZSwgdTMyIHR5cGUsDQogCX0NCiAJdXBfd3JpdGUoJmNyeXB0b19hbGdfc2VtKTsN
CiANCi0JaWYgKGFsZyAhPSAmbGFydmFsLT5hbGcpDQorCWlmIChhbGcgIT0gJmxhcnZhbC0+YWxn
KSB7DQogCQlrZnJlZShsYXJ2YWwpOw0KKwkJaWYgKGNyeXB0b19pc19sYXJ2YWwoYWxnKSkNCisJ
CQlhbGcgPSBjcnlwdG9fbGFydmFsX3dhaXQoYWxnKTsNCisJfQ0KIA0KIAlyZXR1cm4gYWxnOw0K
IH0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL2FjcGkvYWNwaV9pcG1pLmMgYi9kcml2ZXJzL2FjcGkv
YWNwaV9pcG1pLmMNCmluZGV4IGY0MGFjZWYuLmE2OTc3ZTEgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L2FjcGkvYWNwaV9pcG1pLmMNCisrKyBiL2RyaXZlcnMvYWNwaS9hY3BpX2lwbWkuYw0KQEAgLTM5
LDYgKzM5LDcgQEANCiAjaW5jbHVkZSA8bGludXgvaXBtaS5oPg0KICNpbmNsdWRlIDxsaW51eC9k
ZXZpY2UuaD4NCiAjaW5jbHVkZSA8bGludXgvcG5wLmg+DQorI2luY2x1ZGUgPGxpbnV4L3NwaW5s
b2NrLmg+DQogDQogTU9EVUxFX0FVVEhPUigiWmhhbyBZYWt1aSIpOw0KIE1PRFVMRV9ERVNDUklQ
VElPTigiQUNQSSBJUE1JIE9wcmVnaW9uIGRyaXZlciIpOw0KQEAgLTU3LDcgKzU4LDcgQEAgc3Ry
dWN0IGFjcGlfaXBtaV9kZXZpY2Ugew0KIAlzdHJ1Y3QgbGlzdF9oZWFkIGhlYWQ7DQogCS8qIHRo
ZSBJUE1JIHJlcXVlc3QgbWVzc2FnZSBsaXN0ICovDQogCXN0cnVjdCBsaXN0X2hlYWQgdHhfbXNn
X2xpc3Q7DQotCXN0cnVjdCBtdXRleAl0eF9tc2dfbG9jazsNCisJc3BpbmxvY2tfdAl0eF9tc2df
bG9jazsNCiAJYWNwaV9oYW5kbGUgaGFuZGxlOw0KIAlzdHJ1Y3QgcG5wX2RldiAqcG5wX2RldjsN
CiAJaXBtaV91c2VyX3QJdXNlcl9pbnRlcmZhY2U7DQpAQCAtMTQ3LDYgKzE0OCw3IEBAIHN0YXRp
YyB2b2lkIGFjcGlfZm9ybWF0X2lwbWlfbXNnKHN0cnVjdCBhY3BpX2lwbWlfbXNnICp0eF9tc2cs
DQogCXN0cnVjdCBrZXJuZWxfaXBtaV9tc2cgKm1zZzsNCiAJc3RydWN0IGFjcGlfaXBtaV9idWZm
ZXIgKmJ1ZmZlcjsNCiAJc3RydWN0IGFjcGlfaXBtaV9kZXZpY2UgKmRldmljZTsNCisJdW5zaWdu
ZWQgbG9uZyBmbGFnczsNCiANCiAJbXNnID0gJnR4X21zZy0+dHhfbWVzc2FnZTsNCiAJLyoNCkBA
IC0xNzcsMTAgKzE3OSwxMCBAQCBzdGF0aWMgdm9pZCBhY3BpX2Zvcm1hdF9pcG1pX21zZyhzdHJ1
Y3QgYWNwaV9pcG1pX21zZyAqdHhfbXNnLA0KIA0KIAkvKiBHZXQgdGhlIG1zZ2lkICovDQogCWRl
dmljZSA9IHR4X21zZy0+ZGV2aWNlOw0KLQltdXRleF9sb2NrKCZkZXZpY2UtPnR4X21zZ19sb2Nr
KTsNCisJc3Bpbl9sb2NrX2lycXNhdmUoJmRldmljZS0+dHhfbXNnX2xvY2ssIGZsYWdzKTsNCiAJ
ZGV2aWNlLT5jdXJyX21zZ2lkKys7DQogCXR4X21zZy0+dHhfbXNnaWQgPSBkZXZpY2UtPmN1cnJf
bXNnaWQ7DQotCW11dGV4X3VubG9jaygmZGV2aWNlLT50eF9tc2dfbG9jayk7DQorCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJmRldmljZS0+dHhfbXNnX2xvY2ssIGZsYWdzKTsNCiB9DQogDQogc3Rh
dGljIHZvaWQgYWNwaV9mb3JtYXRfaXBtaV9yZXNwb25zZShzdHJ1Y3QgYWNwaV9pcG1pX21zZyAq
bXNnLA0KQEAgLTI0Miw2ICsyNDQsNyBAQCBzdGF0aWMgdm9pZCBpcG1pX21zZ19oYW5kbGVyKHN0
cnVjdCBpcG1pX3JlY3ZfbXNnICptc2csIHZvaWQgKnVzZXJfbXNnX2RhdGEpDQogCWludCBtc2df
Zm91bmQgPSAwOw0KIAlzdHJ1Y3QgYWNwaV9pcG1pX21zZyAqdHhfbXNnOw0KIAlzdHJ1Y3QgcG5w
X2RldiAqcG5wX2RldiA9IGlwbWlfZGV2aWNlLT5wbnBfZGV2Ow0KKwl1bnNpZ25lZCBsb25nIGZs
YWdzOw0KIA0KIAlpZiAobXNnLT51c2VyICE9IGlwbWlfZGV2aWNlLT51c2VyX2ludGVyZmFjZSkg
ew0KIAkJZGV2X3dhcm4oJnBucF9kZXYtPmRldiwgIlVuZXhwZWN0ZWQgcmVzcG9uc2UgaXMgcmV0
dXJuZWQuICINCkBAIC0yNTAsNyArMjUzLDcgQEAgc3RhdGljIHZvaWQgaXBtaV9tc2dfaGFuZGxl
cihzdHJ1Y3QgaXBtaV9yZWN2X21zZyAqbXNnLCB2b2lkICp1c2VyX21zZ19kYXRhKQ0KIAkJaXBt
aV9mcmVlX3JlY3ZfbXNnKG1zZyk7DQogCQlyZXR1cm47DQogCX0NCi0JbXV0ZXhfbG9jaygmaXBt
aV9kZXZpY2UtPnR4X21zZ19sb2NrKTsNCisJc3Bpbl9sb2NrX2lycXNhdmUoJmlwbWlfZGV2aWNl
LT50eF9tc2dfbG9jaywgZmxhZ3MpOw0KIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KHR4X21zZywgJmlw
bWlfZGV2aWNlLT50eF9tc2dfbGlzdCwgaGVhZCkgew0KIAkJaWYgKG1zZy0+bXNnaWQgPT0gdHhf
bXNnLT50eF9tc2dpZCkgew0KIAkJCW1zZ19mb3VuZCA9IDE7DQpAQCAtMjU4LDcgKzI2MSw3IEBA
IHN0YXRpYyB2b2lkIGlwbWlfbXNnX2hhbmRsZXIoc3RydWN0IGlwbWlfcmVjdl9tc2cgKm1zZywg
dm9pZCAqdXNlcl9tc2dfZGF0YSkNCiAJCX0NCiAJfQ0KIA0KLQltdXRleF91bmxvY2soJmlwbWlf
ZGV2aWNlLT50eF9tc2dfbG9jayk7DQorCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmlwbWlfZGV2
aWNlLT50eF9tc2dfbG9jaywgZmxhZ3MpOw0KIAlpZiAoIW1zZ19mb3VuZCkgew0KIAkJZGV2X3dh
cm4oJnBucF9kZXYtPmRldiwgIlVuZXhwZWN0ZWQgcmVzcG9uc2UgKG1zZyBpZCAlbGQpIGlzICIN
CiAJCQkicmV0dXJuZWQuXG4iLCBtc2ctPm1zZ2lkKTsNCkBAIC0zNzgsNiArMzgxLDcgQEAgYWNw
aV9pcG1pX3NwYWNlX2hhbmRsZXIodTMyIGZ1bmN0aW9uLCBhY3BpX3BoeXNpY2FsX2FkZHJlc3Mg
YWRkcmVzcywNCiAJc3RydWN0IGFjcGlfaXBtaV9kZXZpY2UgKmlwbWlfZGV2aWNlID0gaGFuZGxl
cl9jb250ZXh0Ow0KIAlpbnQgZXJyLCByZW1fdGltZTsNCiAJYWNwaV9zdGF0dXMgc3RhdHVzOw0K
Kwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KIAkvKg0KIAkgKiBJUE1JIG9wcmVnaW9uIG1lc3NhZ2Uu
DQogCSAqIElQTUkgbWVzc2FnZSBpcyBmaXJzdGx5IHdyaXR0ZW4gdG8gdGhlIEJNQyBhbmQgc3lz
dGVtIHNvZnR3YXJlDQpAQCAtMzk1LDkgKzM5OSw5IEBAIGFjcGlfaXBtaV9zcGFjZV9oYW5kbGVy
KHUzMiBmdW5jdGlvbiwgYWNwaV9waHlzaWNhbF9hZGRyZXNzIGFkZHJlc3MsDQogCQlyZXR1cm4g
QUVfTk9fTUVNT1JZOw0KIA0KIAlhY3BpX2Zvcm1hdF9pcG1pX21zZyh0eF9tc2csIGFkZHJlc3Ms
IHZhbHVlKTsNCi0JbXV0ZXhfbG9jaygmaXBtaV9kZXZpY2UtPnR4X21zZ19sb2NrKTsNCisJc3Bp
bl9sb2NrX2lycXNhdmUoJmlwbWlfZGV2aWNlLT50eF9tc2dfbG9jaywgZmxhZ3MpOw0KIAlsaXN0
X2FkZF90YWlsKCZ0eF9tc2ctPmhlYWQsICZpcG1pX2RldmljZS0+dHhfbXNnX2xpc3QpOw0KLQlt
dXRleF91bmxvY2soJmlwbWlfZGV2aWNlLT50eF9tc2dfbG9jayk7DQorCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJmlwbWlfZGV2aWNlLT50eF9tc2dfbG9jaywgZmxhZ3MpOw0KIAllcnIgPSBpcG1p
X3JlcXVlc3Rfc2V0dGltZShpcG1pX2RldmljZS0+dXNlcl9pbnRlcmZhY2UsDQogCQkJCQkmdHhf
bXNnLT5hZGRyLA0KIAkJCQkJdHhfbXNnLT50eF9tc2dpZCwNCkBAIC00MTMsOSArNDE3LDkgQEAg
YWNwaV9pcG1pX3NwYWNlX2hhbmRsZXIodTMyIGZ1bmN0aW9uLCBhY3BpX3BoeXNpY2FsX2FkZHJl
c3MgYWRkcmVzcywNCiAJc3RhdHVzID0gQUVfT0s7DQogDQogZW5kX2xhYmVsOg0KLQltdXRleF9s
b2NrKCZpcG1pX2RldmljZS0+dHhfbXNnX2xvY2spOw0KKwlzcGluX2xvY2tfaXJxc2F2ZSgmaXBt
aV9kZXZpY2UtPnR4X21zZ19sb2NrLCBmbGFncyk7DQogCWxpc3RfZGVsKCZ0eF9tc2ctPmhlYWQp
Ow0KLQltdXRleF91bmxvY2soJmlwbWlfZGV2aWNlLT50eF9tc2dfbG9jayk7DQorCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJmlwbWlfZGV2aWNlLT50eF9tc2dfbG9jaywgZmxhZ3MpOw0KIAlrZnJl
ZSh0eF9tc2cpOw0KIAlyZXR1cm4gc3RhdHVzOw0KIH0NCkBAIC00NTcsNyArNDYxLDcgQEAgc3Rh
dGljIHZvaWQgYWNwaV9hZGRfaXBtaV9kZXZpY2Uoc3RydWN0IGFjcGlfaXBtaV9kZXZpY2UgKmlw
bWlfZGV2aWNlKQ0KIA0KIAlJTklUX0xJU1RfSEVBRCgmaXBtaV9kZXZpY2UtPmhlYWQpOw0KIA0K
LQltdXRleF9pbml0KCZpcG1pX2RldmljZS0+dHhfbXNnX2xvY2spOw0KKwlzcGluX2xvY2tfaW5p
dCgmaXBtaV9kZXZpY2UtPnR4X21zZ19sb2NrKTsNCiAJSU5JVF9MSVNUX0hFQUQoJmlwbWlfZGV2
aWNlLT50eF9tc2dfbGlzdCk7DQogCWlwbWlfaW5zdGFsbF9zcGFjZV9oYW5kbGVyKGlwbWlfZGV2
aWNlKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2FjcGkvZWMuYyBiL2RyaXZlcnMvYWNwaS9l
Yy5jDQppbmRleCA1MWRlMTg2Li44MTc2YjgyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9hY3BpL2Vj
LmMNCisrKyBiL2RyaXZlcnMvYWNwaS9lYy5jDQpAQCAtOTY0LDYgKzk2NCwxMCBAQCBzdGF0aWMg
c3RydWN0IGRtaV9zeXN0ZW1faWQgX19pbml0ZGF0YSBlY19kbWlfdGFibGVbXSA9IHsNCiAJZWNf
ZW5sYXJnZV9zdG9ybV90aHJlc2hvbGQsICJDTEVWTyBoYXJkd2FyZSIsIHsNCiAJRE1JX01BVENI
KERNSV9TWVNfVkVORE9SLCAiQ0xFVk8gQ28uIiksDQogCURNSV9NQVRDSChETUlfUFJPRFVDVF9O
QU1FLCAiTTcyMFQvTTczMFQiKSx9LCBOVUxMfSwNCisJew0KKwllY192YWxpZGF0ZV9lY2R0LCAi
QVNVUyBoYXJkd2FyZSIsIHsNCisJRE1JX01BVENIKERNSV9TWVNfVkVORE9SLCAiQVNVU1RlayBD
b21wdXRlciBJbmMuIiksDQorCURNSV9NQVRDSChETUlfUFJPRFVDVF9OQU1FLCAiTDRSIiksfSwg
TlVMTH0sDQogCXt9LA0KIH07DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9jay9jY2lzcy5j
IGIvZHJpdmVycy9ibG9jay9jY2lzcy5jDQppbmRleCBkMzQ0NmY2Li5kN2FkODY1IDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9ibG9jay9jY2lzcy5jDQorKysgYi9kcml2ZXJzL2Jsb2NrL2NjaXNzLmMN
CkBAIC0xMTg2LDYgKzExODYsNyBAQCBzdGF0aWMgaW50IGNjaXNzX2lvY3RsMzJfcGFzc3RocnUo
c3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgZm1vZGVfdCBtb2RlLA0KIAlpbnQgZXJyOw0KIAl1
MzIgY3A7DQogDQorCW1lbXNldCgmYXJnNjQsIDAsIHNpemVvZihhcmc2NCkpOw0KIAllcnIgPSAw
Ow0KIAllcnIgfD0NCiAJICAgIGNvcHlfZnJvbV91c2VyKCZhcmc2NC5MVU5faW5mbywgJmFyZzMy
LT5MVU5faW5mbywNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Jsb2NrL2NwcWFycmF5LmMgYi9kcml2
ZXJzL2Jsb2NrL2NwcWFycmF5LmMNCmluZGV4IDkxMjViYmUuLjUwNGJjMTYgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL2Jsb2NrL2NwcWFycmF5LmMNCisrKyBiL2RyaXZlcnMvYmxvY2svY3BxYXJyYXku
Yw0KQEAgLTExOTUsNiArMTE5NSw3IEBAIG91dF9wYXNzdGhydToNCiAJCWlkYV9wY2lfaW5mb19z
dHJ1Y3QgcGNpaW5mbzsNCiANCiAJCWlmICghYXJnKSByZXR1cm4gLUVJTlZBTDsNCisJCW1lbXNl
dCgmcGNpaW5mbywgMCwgc2l6ZW9mKHBjaWluZm8pKTsNCiAJCXBjaWluZm8uYnVzID0gaG9zdC0+
cGNpX2Rldi0+YnVzLT5udW1iZXI7DQogCQlwY2lpbmZvLmRldl9mbiA9IGhvc3QtPnBjaV9kZXYt
PmRldmZuOw0KIAkJcGNpaW5mby5ib2FyZF9pZCA9IGhvc3QtPmJvYXJkX2lkOw0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvYmx1ZXRvb3RoL2F0aDNrLmMgYi9kcml2ZXJzL2JsdWV0b290aC9hdGgzay5j
DQppbmRleCBiZGU3MmY3Li4zNTM5ZjliIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ibHVldG9vdGgv
YXRoM2suYw0KKysrIGIvZHJpdmVycy9ibHVldG9vdGgvYXRoM2suYw0KQEAgLTg0LDYgKzg0LDcg
QEAgc3RhdGljIHN0cnVjdCB1c2JfZGV2aWNlX2lkIGF0aDNrX3RhYmxlW10gPSB7DQogCXsgVVNC
X0RFVklDRSgweDA0Q0EsIDB4MzAwOCkgfSwNCiAJeyBVU0JfREVWSUNFKDB4MTNkMywgMHgzMzYy
KSB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgwQ0YzLCAweEUwMDQpIH0sDQorCXsgVVNCX0RFVklDRSgw
eDBDRjMsIDB4RTAwNSkgfSwNCiAJeyBVU0JfREVWSUNFKDB4MDkzMCwgMHgwMjE5KSB9LA0KIAl7
IFVTQl9ERVZJQ0UoMHgwNDg5LCAweGUwNTcpIH0sDQogCXsgVVNCX0RFVklDRSgweDEzZDMsIDB4
MzM5MykgfSwNCkBAIC0xMjUsNiArMTI2LDcgQEAgc3RhdGljIHN0cnVjdCB1c2JfZGV2aWNlX2lk
IGF0aDNrX2JsaXN0X3RibFtdID0gew0KIAl7IFVTQl9ERVZJQ0UoMHgwNGNhLCAweDMwMDgpLCAu
ZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQogCXsgVVNCX0RFVklDRSgweDEzZDMsIDB4
MzM2MiksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiAJeyBVU0JfREVWSUNFKDB4
MGNmMywgMHhlMDA0KSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KKwl7IFVTQl9E
RVZJQ0UoMHgwY2YzLCAweGUwMDUpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQog
CXsgVVNCX0RFVklDRSgweDA5MzAsIDB4MDIxOSksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMw
MTIgfSwNCiAJeyBVU0JfREVWSUNFKDB4MDQ4OSwgMHhlMDU3KSwgLmRyaXZlcl9pbmZvID0gQlRV
U0JfQVRIMzAxMiB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgxM2QzLCAweDMzOTMpLCAuZHJpdmVyX2lu
Zm8gPSBCVFVTQl9BVEgzMDEyIH0sDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibHVldG9vdGgvYnR1
c2IuYyBiL2RyaXZlcnMvYmx1ZXRvb3RoL2J0dXNiLmMNCmluZGV4IDFiZDM5MjQuLmYxOGI1YTIg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL2JsdWV0b290aC9idHVzYi5jDQorKysgYi9kcml2ZXJzL2Js
dWV0b290aC9idHVzYi5jDQpAQCAtMTA4LDYgKzEwOCw3IEBAIHN0YXRpYyBzdHJ1Y3QgdXNiX2Rl
dmljZV9pZCBidHVzYl90YWJsZVtdID0gew0KIA0KIAkvKiBCcm9hZGNvbSBCQ00yMDcwMkEwICov
DQogCXsgVVNCX0RFVklDRSgweDBiMDUsIDB4MTdiNSkgfSwNCisJeyBVU0JfREVWSUNFKDB4MGIw
NSwgMHgxN2NiKSB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgwNGNhLCAweDIwMDMpIH0sDQogCXsgVVNC
X0RFVklDRSgweDA0ODksIDB4ZTA0MikgfSwNCiAJeyBVU0JfREVWSUNFKDB4NDEzYywgMHg4MTk3
KSB9LA0KQEAgLTE1NCw2ICsxNTUsNyBAQCBzdGF0aWMgc3RydWN0IHVzYl9kZXZpY2VfaWQgYmxh
Y2tsaXN0X3RhYmxlW10gPSB7DQogCXsgVVNCX0RFVklDRSgweDA0Y2EsIDB4MzAwOCksIC5kcml2
ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiAJeyBVU0JfREVWSUNFKDB4MTNkMywgMHgzMzYy
KSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgwY2Yz
LCAweGUwMDQpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQorCXsgVVNCX0RFVklD
RSgweDBjZjMsIDB4ZTAwNSksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiAJeyBV
U0JfREVWSUNFKDB4MDkzMCwgMHgwMjE5KSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9
LA0KIAl7IFVTQl9ERVZJQ0UoMHgwNDg5LCAweGUwNTcpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9B
VEgzMDEyIH0sDQogCXsgVVNCX0RFVklDRSgweDEzZDMsIDB4MzM5MyksIC5kcml2ZXJfaW5mbyA9
IEJUVVNCX0FUSDMwMTIgfSwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vZHJtX2VkaWQu
YyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fZWRpZC5jDQppbmRleCA3MjExZjY3Li43MmY0NjBlIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL2RybV9lZGlkLmMNCisrKyBiL2RyaXZlcnMvZ3B1
L2RybS9kcm1fZWRpZC5jDQpAQCAtMTI1LDYgKzEyNSw5IEBAIHN0YXRpYyBzdHJ1Y3QgZWRpZF9x
dWlyayB7DQogDQogCS8qIFZpZXdTb25pYyBWQTIwMjZ3ICovDQogCXsgIlZTQyIsIDUwMjAsIEVE
SURfUVVJUktfRk9SQ0VfUkVEVUNFRF9CTEFOS0lORyB9LA0KKw0KKwkvKiBNZWRpb24gTUQgMzAy
MTcgUEcgKi8NCisJeyAiTUVEIiwgMHg3YjgsIEVESURfUVVJUktfUFJFRkVSX0xBUkdFXzc1IH0s
DQogfTsNCiANCiAvKioqIEREQyBmZXRjaCBhbmQgYmxvY2sgdmFsaWRhdGlvbiAqKiovDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZHAuYyBiL2RyaXZlcnMvZ3B1L2Ry
bS9pOTE1L2ludGVsX2RwLmMNCmluZGV4IGEwN2NjYWIuLjcyMTYzZTggMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9kcC5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkx
NS9pbnRlbF9kcC5jDQpAQCAtNjIxLDcgKzYyMSwxOCBAQCBpbnRlbF9kcF9pMmNfYXV4X2NoKHN0
cnVjdCBpMmNfYWRhcHRlciAqYWRhcHRlciwgaW50IG1vZGUsDQogCQkJRFJNX0RFQlVHX0tNUygi
YXV4X2NoIG5hdGl2ZSBuYWNrXG4iKTsNCiAJCQlyZXR1cm4gLUVSRU1PVEVJTzsNCiAJCWNhc2Ug
QVVYX05BVElWRV9SRVBMWV9ERUZFUjoNCi0JCQl1ZGVsYXkoMTAwKTsNCisJCQkvKg0KKwkJCSAq
IEZvciBub3csIGp1c3QgZ2l2ZSBtb3JlIHNsYWNrIHRvIGJyYW5jaCBkZXZpY2VzLiBXZQ0KKwkJ
CSAqIGNvdWxkIGNoZWNrIHRoZSBEUENEIGZvciBJMkMgYml0IHJhdGUgY2FwYWJpbGl0aWVzLA0K
KwkJCSAqIGFuZCBpZiBhdmFpbGFibGUsIGFkanVzdCB0aGUgaW50ZXJ2YWwuIFdlIGNvdWxkIGFs
c28NCisJCQkgKiBiZSBtb3JlIGNhcmVmdWwgd2l0aCBEUC10by1MZWdhY3kgYWRhcHRlcnMgd2hl
cmUgYQ0KKwkJCSAqIGxvbmcgbGVnYWN5IGNhYmxlIG1heSBmb3JjZSB2ZXJ5IGxvdyBJMkMgYml0
IHJhdGVzLg0KKwkJCSAqLw0KKwkJCWlmIChpbnRlbF9kcC0+ZHBjZFtEUF9ET1dOU1RSRUFNUE9S
VF9QUkVTRU5UXSAmDQorCQkJICAgIERQX0RXTl9TVFJNX1BPUlRfUFJFU0VOVCkNCisJCQkJdXNs
ZWVwX3JhbmdlKDUwMCwgNjAwKTsNCisJCQllbHNlDQorCQkJCXVzbGVlcF9yYW5nZSgzMDAsIDQw
MCk7DQogCQkJY29udGludWU7DQogCQlkZWZhdWx0Og0KIAkJCURSTV9FUlJPUigiYXV4X2NoIGlu
dmFsaWQgbmF0aXZlIHJlcGx5IDB4JTAyeFxuIiwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9k
cm0vaTkxNS9pbnRlbF9vcHJlZ2lvbi5jIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfb3By
ZWdpb24uYw0KaW5kZXggY2ZmYjAwNy4uMzU2YTI1MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1
L2RybS9pOTE1L2ludGVsX29wcmVnaW9uLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2lu
dGVsX29wcmVnaW9uLmMNCkBAIC0xNjEsNyArMTYxLDcgQEAgc3RhdGljIHUzMiBhc2xlX3NldF9i
YWNrbGlnaHQoc3RydWN0IGRybV9kZXZpY2UgKmRldiwgdTMyIGJjbHApDQogDQogCW1heCA9IGlu
dGVsX3BhbmVsX2dldF9tYXhfYmFja2xpZ2h0KGRldik7DQogCWludGVsX3BhbmVsX3NldF9iYWNr
bGlnaHQoZGV2LCBiY2xwICogbWF4IC8gMjU1KTsNCi0JYXNsZS0+Y2JsdiA9IChiY2xwKjB4NjQp
LzB4ZmYgfCBBU0xFX0NCTFZfVkFMSUQ7DQorCWFzbGUtPmNibHYgPSBESVZfUk9VTkRfVVAoYmNs
cCAqIDEwMCwgMjU1KSB8IEFTTEVfQ0JMVl9WQUxJRDsNCiANCiAJcmV0dXJuIDA7DQogfQ0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZW5jb2RlcnMuYyBiL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZW5jb2RlcnMuYw0KaW5kZXggZjBkYzA0Yi4u
MzE3MTI5NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZW5j
b2RlcnMuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19lbmNvZGVycy5j
DQpAQCAtMTM4NSw4ICsxMzg1LDEyIEBAIHJhZGVvbl9hdG9tX2VuY29kZXJfZHBtc19kaWcoc3Ry
dWN0IGRybV9lbmNvZGVyICplbmNvZGVyLCBpbnQgbW9kZSkNCiAJCQlhdG9tYmlvc19kaWdfZW5j
b2Rlcl9zZXR1cChlbmNvZGVyLCBBVE9NX0VOQUJMRSwgMCk7DQogCQkJYXRvbWJpb3NfZGlnX3Ry
YW5zbWl0dGVyX3NldHVwKGVuY29kZXIsIEFUT01fVFJBTlNNSVRURVJfQUNUSU9OX1NFVFVQLCAw
LCAwKTsNCiAJCQlhdG9tYmlvc19kaWdfdHJhbnNtaXR0ZXJfc2V0dXAoZW5jb2RlciwgQVRPTV9U
UkFOU01JVFRFUl9BQ1RJT05fRU5BQkxFLCAwLCAwKTsNCi0JCQkvKiBzb21lIGVhcmx5IGRjZTMu
MiBib2FyZHMgaGF2ZSBhIGJ1ZyBpbiB0aGVpciB0cmFuc21pdHRlciBjb250cm9sIHRhYmxlICov
DQotCQkJaWYgKChyZGV2LT5mYW1pbHkgIT0gQ0hJUF9SVjcxMCkgJiYgKHJkZXYtPmZhbWlseSAh
PSBDSElQX1JWNzMwKSkNCisJCQkvKiBzb21lIGRjZTMueCBib2FyZHMgaGF2ZSBhIGJ1ZyBpbiB0
aGVpciB0cmFuc21pdHRlciBjb250cm9sIHRhYmxlLg0KKwkJCSAqIEFDVElPTl9FTkFCTEVfT1VU
UFVUIGNhbiBwcm9iYWJseSBiZSBkcm9wcGVkIHNpbmNlIEFDVElPTl9FTkFCTEUNCisJCQkgKiBk
b2VzIHRoZSBzYW1lIHRoaW5nIGFuZCBtb3JlLg0KKwkJCSAqLw0KKwkJCWlmICgocmRldi0+ZmFt
aWx5ICE9IENISVBfUlY3MTApICYmIChyZGV2LT5mYW1pbHkgIT0gQ0hJUF9SVjczMCkgJiYNCisJ
CQkgICAgKHJkZXYtPmZhbWlseSAhPSBDSElQX1JTODgwKSkNCiAJCQkJYXRvbWJpb3NfZGlnX3Ry
YW5zbWl0dGVyX3NldHVwKGVuY29kZXIsIEFUT01fVFJBTlNNSVRURVJfQUNUSU9OX0VOQUJMRV9P
VVRQVVQsIDAsIDApOw0KIAkJfQ0KIAkJaWYgKEVOQ09ERVJfTU9ERV9JU19EUChhdG9tYmlvc19n
ZXRfZW5jb2Rlcl9tb2RlKGVuY29kZXIpKSAmJiBjb25uZWN0b3IpIHsNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2dwdS9kcm0vcmFkZW9uL2V2ZXJncmVlbi5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVv
bi9ldmVyZ3JlZW4uYw0KaW5kZXggZjU5NjJhMC4uYTY4MDU3YSAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvZ3B1L2RybS9yYWRlb24vZXZlcmdyZWVuLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRl
b24vZXZlcmdyZWVuLmMNCkBAIC01MDEsNyArNTAxLDggQEAgc3RhdGljIHUzMiBldmVyZ3JlZW5f
bGluZV9idWZmZXJfYWRqdXN0KHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2LA0KIAkJCQkJc3Ry
dWN0IGRybV9kaXNwbGF5X21vZGUgKm1vZGUsDQogCQkJCQlzdHJ1Y3QgZHJtX2Rpc3BsYXlfbW9k
ZSAqb3RoZXJfbW9kZSkNCiB7DQotCXUzMiB0bXA7DQorCXUzMiB0bXAsIGJ1ZmZlcl9hbGxvYywg
aTsNCisJdTMyIHBpcGVfb2Zmc2V0ID0gcmFkZW9uX2NydGMtPmNydGNfaWQgKiAweDIwOw0KIAkv
Kg0KIAkgKiBMaW5lIEJ1ZmZlciBTZXR1cA0KIAkgKiBUaGVyZSBhcmUgMyBsaW5lIGJ1ZmZlcnMs
IGVhY2ggb25lIHNoYXJlZCBieSAyIGRpc3BsYXkgY29udHJvbGxlcnMuDQpAQCAtNTI0LDE4ICs1
MjUsMzQgQEAgc3RhdGljIHUzMiBldmVyZ3JlZW5fbGluZV9idWZmZXJfYWRqdXN0KHN0cnVjdCBy
YWRlb25fZGV2aWNlICpyZGV2LA0KIAkgKiBub24tbGlua2VkIGNydGNzIGZvciBtYXhpbXVtIGxp
bmUgYnVmZmVyIGFsbG9jYXRpb24uDQogCSAqLw0KIAlpZiAocmFkZW9uX2NydGMtPmJhc2UuZW5h
YmxlZCAmJiBtb2RlKSB7DQotCQlpZiAob3RoZXJfbW9kZSkNCisJCWlmIChvdGhlcl9tb2RlKSB7
DQogCQkJdG1wID0gMDsgLyogMS8yICovDQotCQllbHNlDQorCQkJYnVmZmVyX2FsbG9jID0gMTsN
CisJCX0gZWxzZSB7DQogCQkJdG1wID0gMjsgLyogd2hvbGUgKi8NCi0JfSBlbHNlDQorCQkJYnVm
ZmVyX2FsbG9jID0gMjsNCisJCX0NCisJfSBlbHNlIHsNCiAJCXRtcCA9IDA7DQorCQlidWZmZXJf
YWxsb2MgPSAwOw0KKwl9DQogDQogCS8qIHNlY29uZCBjb250cm9sbGVyIG9mIHRoZSBwYWlyIHVz
ZXMgc2Vjb25kIGhhbGYgb2YgdGhlIGxiICovDQogCWlmIChyYWRlb25fY3J0Yy0+Y3J0Y19pZCAl
IDIpDQogCQl0bXAgKz0gNDsNCiAJV1JFRzMyKERDX0xCX01FTU9SWV9TUExJVCArIHJhZGVvbl9j
cnRjLT5jcnRjX29mZnNldCwgdG1wKTsNCiANCisJaWYgKEFTSUNfSVNfRENFNDEocmRldikgfHwg
QVNJQ19JU19EQ0U1KHJkZXYpKSB7DQorCQlXUkVHMzIoUElQRTBfRE1JRl9CVUZGRVJfQ09OVFJP
TCArIHBpcGVfb2Zmc2V0LA0KKwkJICAgICAgIERNSUZfQlVGRkVSU19BTExPQ0FURUQoYnVmZmVy
X2FsbG9jKSk7DQorCQlmb3IgKGkgPSAwOyBpIDwgcmRldi0+dXNlY190aW1lb3V0OyBpKyspIHsN
CisJCQlpZiAoUlJFRzMyKFBJUEUwX0RNSUZfQlVGRkVSX0NPTlRST0wgKyBwaXBlX29mZnNldCkg
Jg0KKwkJCSAgICBETUlGX0JVRkZFUlNfQUxMT0NBVEVEX0NPTVBMRVRFRCkNCisJCQkJYnJlYWs7
DQorCQkJdWRlbGF5KDEpOw0KKwkJfQ0KKwl9DQorDQogCWlmIChyYWRlb25fY3J0Yy0+YmFzZS5l
bmFibGVkICYmIG1vZGUpIHsNCiAJCXN3aXRjaCAodG1wKSB7DQogCQljYXNlIDA6DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW5kLmggYi9kcml2ZXJzL2dwdS9k
cm0vcmFkZW9uL2V2ZXJncmVlbmQuaA0KaW5kZXggZmU0NGE5NS4uNDdmM2JkMiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vZXZlcmdyZWVuZC5oDQorKysgYi9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL2V2ZXJncmVlbmQuaA0KQEAgLTQ1OSw2ICs0NTksMTAgQEANCiAjICAgICAg
IGRlZmluZSBMQVRFTkNZX0xPV19XQVRFUk1BUksoeCkgICAgICAgICAgICAgICAgICAgKCh4KSA8
PCAwKQ0KICMgICAgICAgZGVmaW5lIExBVEVOQ1lfSElHSF9XQVRFUk1BUksoeCkgICAgICAgICAg
ICAgICAgICAoKHgpIDw8IDE2KQ0KIA0KKyNkZWZpbmUJUElQRTBfRE1JRl9CVUZGRVJfQ09OVFJP
TAkJCSAgMHgwY2EwDQorIyAgICAgICBkZWZpbmUgRE1JRl9CVUZGRVJTX0FMTE9DQVRFRCh4KSAg
ICAgICAgICAgICAgICAgICgoeCkgPDwgMCkNCisjICAgICAgIGRlZmluZSBETUlGX0JVRkZFUlNf
QUxMT0NBVEVEX0NPTVBMRVRFRCAgICAgICAgICAgKDEgPDwgNCkNCisNCiAjZGVmaW5lIElIX1JC
X0NOVEwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMHgzZTAwDQogIyAg
ICAgICBkZWZpbmUgSUhfUkJfRU5BQkxFICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICgx
IDw8IDApDQogIyAgICAgICBkZWZpbmUgSUhfSUJfU0laRSh4KSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICgoeCkgPDwgMSkgLyogbG9nMiAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1
L2RybS9yYWRlb24vcmFkZW9uX2F0b21iaW9zLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3Jh
ZGVvbl9hdG9tYmlvcy5jDQppbmRleCAzODNiMzhlLi5jZGE4OWM2YiAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2F0b21iaW9zLmMNCisrKyBiL2RyaXZlcnMvZ3B1
L2RybS9yYWRlb24vcmFkZW9uX2F0b21iaW9zLmMNCkBAIC03MDksMTMgKzcwOSwxNiBAQCBib29s
IHJhZGVvbl9nZXRfYXRvbV9jb25uZWN0b3JfaW5mb19mcm9tX29iamVjdF90YWJsZShzdHJ1Y3Qg
ZHJtX2RldmljZSAqZGV2KQ0KIAkJCQkJCQkJKEFUT01fU1JDX0RTVF9UQUJMRV9GT1JfT05FX09C
SkVDVCAqKQ0KIAkJCQkJCQkJKGN0eC0+YmlvcyArIGRhdGFfb2Zmc2V0ICsNCiAJCQkJCQkJCSBs
ZTE2X3RvX2NwdShyb3V0ZXJfb2JqLT5hc09iamVjdHNba10udXNTcmNEc3RUYWJsZU9mZnNldCkp
Ow0KKwkJCQkJCQl1OCAqbnVtX2RzdF9vYmpzID0gKHU4ICopDQorCQkJCQkJCQkoKHU4ICopcm91
dGVyX3NyY19kc3RfdGFibGUgKyAxICsNCisJCQkJCQkJCSAocm91dGVyX3NyY19kc3RfdGFibGUt
PnVjTnVtYmVyT2ZTcmMgKiAyKSk7DQorCQkJCQkJCXUxNiAqZHN0X29ianMgPSAodTE2ICopKG51
bV9kc3Rfb2JqcyArIDEpOw0KIAkJCQkJCQlpbnQgZW51bV9pZDsNCiANCiAJCQkJCQkJcm91dGVy
LnJvdXRlcl9pZCA9IHJvdXRlcl9vYmpfaWQ7DQotCQkJCQkJCWZvciAoZW51bV9pZCA9IDA7IGVu
dW1faWQgPCByb3V0ZXJfc3JjX2RzdF90YWJsZS0+dWNOdW1iZXJPZkRzdDsNCi0JCQkJCQkJICAg
ICBlbnVtX2lkKyspIHsNCisJCQkJCQkJZm9yIChlbnVtX2lkID0gMDsgZW51bV9pZCA8ICgqbnVt
X2RzdF9vYmpzKTsgZW51bV9pZCsrKSB7DQogCQkJCQkJCQlpZiAobGUxNl90b19jcHUocGF0aC0+
dXNDb25uT2JqZWN0SWQpID09DQotCQkJCQkJCQkgICAgbGUxNl90b19jcHUocm91dGVyX3NyY19k
c3RfdGFibGUtPnVzRHN0T2JqZWN0SURbZW51bV9pZF0pKQ0KKwkJCQkJCQkJICAgIGxlMTZfdG9f
Y3B1KGRzdF9vYmpzW2VudW1faWRdKSkNCiAJCQkJCQkJCQlicmVhazsNCiAJCQkJCQkJfQ0KIA0K
QEAgLTE2MTYsNyArMTYxOSw5IEBAIHN0cnVjdCByYWRlb25fZW5jb2Rlcl9hdG9tX2RpZyAqcmFk
ZW9uX2F0b21iaW9zX2dldF9sdmRzX2luZm8oc3RydWN0DQogCQkJCQkJCQlrZnJlZShlZGlkKTsN
CiAJCQkJCQl9DQogCQkJCQl9DQotCQkJCQlyZWNvcmQgKz0gc2l6ZW9mKEFUT01fRkFLRV9FRElE
X1BBVENIX1JFQ09SRCk7DQorCQkJCQlyZWNvcmQgKz0gZmFrZV9lZGlkX3JlY29yZC0+dWNGYWtl
RURJRExlbmd0aCA/DQorCQkJCQkJZmFrZV9lZGlkX3JlY29yZC0+dWNGYWtlRURJRExlbmd0aCAr
IDIgOg0KKwkJCQkJCXNpemVvZihBVE9NX0ZBS0VfRURJRF9QQVRDSF9SRUNPUkQpOw0KIAkJCQkJ
YnJlYWs7DQogCQkJCWNhc2UgTENEX1BBTkVMX1JFU09MVVRJT05fUkVDT1JEX1RZUEU6DQogCQkJ
CQlwYW5lbF9yZXNfcmVjb3JkID0gKEFUT01fUEFORUxfUkVTT0xVVElPTl9QQVRDSF9SRUNPUkQg
KilyZWNvcmQ7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fY29u
bmVjdG9ycy5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fY29ubmVjdG9ycy5jDQpp
bmRleCA2ZmQ1M2I2Li5iMTAxODQzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVv
bi9yYWRlb25fY29ubmVjdG9ycy5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVv
bl9jb25uZWN0b3JzLmMNCkBAIC0xMzg3LDYgKzEzODcsMjQgQEAgc3RydWN0IGRybV9jb25uZWN0
b3JfZnVuY3MgcmFkZW9uX2RwX2Nvbm5lY3Rvcl9mdW5jcyA9IHsNCiAJLmZvcmNlID0gcmFkZW9u
X2R2aV9mb3JjZSwNCiB9Ow0KIA0KK3N0YXRpYyBjb25zdCBzdHJ1Y3QgZHJtX2Nvbm5lY3Rvcl9m
dW5jcyByYWRlb25fZWRwX2Nvbm5lY3Rvcl9mdW5jcyA9IHsNCisJLmRwbXMgPSBkcm1faGVscGVy
X2Nvbm5lY3Rvcl9kcG1zLA0KKwkuZGV0ZWN0ID0gcmFkZW9uX2RwX2RldGVjdCwNCisJLmZpbGxf
bW9kZXMgPSBkcm1faGVscGVyX3Byb2JlX3NpbmdsZV9jb25uZWN0b3JfbW9kZXMsDQorCS5zZXRf
cHJvcGVydHkgPSByYWRlb25fbHZkc19zZXRfcHJvcGVydHksDQorCS5kZXN0cm95ID0gcmFkZW9u
X2RwX2Nvbm5lY3Rvcl9kZXN0cm95LA0KKwkuZm9yY2UgPSByYWRlb25fZHZpX2ZvcmNlLA0KK307
DQorDQorc3RhdGljIGNvbnN0IHN0cnVjdCBkcm1fY29ubmVjdG9yX2Z1bmNzIHJhZGVvbl9sdmRz
X2JyaWRnZV9jb25uZWN0b3JfZnVuY3MgPSB7DQorCS5kcG1zID0gZHJtX2hlbHBlcl9jb25uZWN0
b3JfZHBtcywNCisJLmRldGVjdCA9IHJhZGVvbl9kcF9kZXRlY3QsDQorCS5maWxsX21vZGVzID0g
ZHJtX2hlbHBlcl9wcm9iZV9zaW5nbGVfY29ubmVjdG9yX21vZGVzLA0KKwkuc2V0X3Byb3BlcnR5
ID0gcmFkZW9uX2x2ZHNfc2V0X3Byb3BlcnR5LA0KKwkuZGVzdHJveSA9IHJhZGVvbl9kcF9jb25u
ZWN0b3JfZGVzdHJveSwNCisJLmZvcmNlID0gcmFkZW9uX2R2aV9mb3JjZSwNCit9Ow0KKw0KIHZv
aWQNCiByYWRlb25fYWRkX2F0b21fY29ubmVjdG9yKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYsDQog
CQkJICB1aW50MzJfdCBjb25uZWN0b3JfaWQsDQpAQCAtMTQ3OCw4ICsxNDk2LDYgQEAgcmFkZW9u
X2FkZF9hdG9tX2Nvbm5lY3RvcihzdHJ1Y3QgZHJtX2RldmljZSAqZGV2LA0KIAkJCWdvdG8gZmFp
bGVkOw0KIAkJcmFkZW9uX2RpZ19jb25uZWN0b3ItPmlncF9sYW5lX2luZm8gPSBpZ3BfbGFuZV9p
bmZvOw0KIAkJcmFkZW9uX2Nvbm5lY3Rvci0+Y29uX3ByaXYgPSByYWRlb25fZGlnX2Nvbm5lY3Rv
cjsNCi0JCWRybV9jb25uZWN0b3JfaW5pdChkZXYsICZyYWRlb25fY29ubmVjdG9yLT5iYXNlLCAm
cmFkZW9uX2RwX2Nvbm5lY3Rvcl9mdW5jcywgY29ubmVjdG9yX3R5cGUpOw0KLQkJZHJtX2Nvbm5l
Y3Rvcl9oZWxwZXJfYWRkKCZyYWRlb25fY29ubmVjdG9yLT5iYXNlLCAmcmFkZW9uX2RwX2Nvbm5l
Y3Rvcl9oZWxwZXJfZnVuY3MpOw0KIAkJaWYgKGkyY19idXMtPnZhbGlkKSB7DQogCQkJLyogYWRk
IERQIGkyYyBidXMgKi8NCiAJCQlpZiAoY29ubmVjdG9yX3R5cGUgPT0gRFJNX01PREVfQ09OTkVD
VE9SX2VEUCkNCkBAIC0xNDk2LDYgKzE1MTIsMTAgQEAgcmFkZW9uX2FkZF9hdG9tX2Nvbm5lY3Rv
cihzdHJ1Y3QgZHJtX2RldmljZSAqZGV2LA0KIAkJY2FzZSBEUk1fTU9ERV9DT05ORUNUT1JfVkdB
Og0KIAkJY2FzZSBEUk1fTU9ERV9DT05ORUNUT1JfRFZJQToNCiAJCWRlZmF1bHQ6DQorCQkJZHJt
X2Nvbm5lY3Rvcl9pbml0KGRldiwgJnJhZGVvbl9jb25uZWN0b3ItPmJhc2UsDQorCQkJCQkgICAm
cmFkZW9uX2RwX2Nvbm5lY3Rvcl9mdW5jcywgY29ubmVjdG9yX3R5cGUpOw0KKwkJCWRybV9jb25u
ZWN0b3JfaGVscGVyX2FkZCgmcmFkZW9uX2Nvbm5lY3Rvci0+YmFzZSwNCisJCQkJCQkgJnJhZGVv
bl9kcF9jb25uZWN0b3JfaGVscGVyX2Z1bmNzKTsNCiAJCQljb25uZWN0b3ItPmludGVybGFjZV9h
bGxvd2VkID0gdHJ1ZTsNCiAJCQljb25uZWN0b3ItPmRvdWJsZXNjYW5fYWxsb3dlZCA9IHRydWU7
DQogCQkJcmFkZW9uX2Nvbm5lY3Rvci0+ZGFjX2xvYWRfZGV0ZWN0ID0gdHJ1ZTsNCkBAIC0xNTA4
LDYgKzE1MjgsMTAgQEAgcmFkZW9uX2FkZF9hdG9tX2Nvbm5lY3RvcihzdHJ1Y3QgZHJtX2Rldmlj
ZSAqZGV2LA0KIAkJY2FzZSBEUk1fTU9ERV9DT05ORUNUT1JfSERNSUE6DQogCQljYXNlIERSTV9N
T0RFX0NPTk5FQ1RPUl9IRE1JQjoNCiAJCWNhc2UgRFJNX01PREVfQ09OTkVDVE9SX0Rpc3BsYXlQ
b3J0Og0KKwkJCWRybV9jb25uZWN0b3JfaW5pdChkZXYsICZyYWRlb25fY29ubmVjdG9yLT5iYXNl
LA0KKwkJCQkJICAgJnJhZGVvbl9kcF9jb25uZWN0b3JfZnVuY3MsIGNvbm5lY3Rvcl90eXBlKTsN
CisJCQlkcm1fY29ubmVjdG9yX2hlbHBlcl9hZGQoJnJhZGVvbl9jb25uZWN0b3ItPmJhc2UsDQor
CQkJCQkJICZyYWRlb25fZHBfY29ubmVjdG9yX2hlbHBlcl9mdW5jcyk7DQogCQkJZHJtX2Nvbm5l
Y3Rvcl9hdHRhY2hfcHJvcGVydHkoJnJhZGVvbl9jb25uZWN0b3ItPmJhc2UsDQogCQkJCQkJICAg
ICAgcmRldi0+bW9kZV9pbmZvLnVuZGVyc2Nhbl9wcm9wZXJ0eSwNCiAJCQkJCQkgICAgICBVTkRF
UlNDQU5fT0ZGKTsNCkBAIC0xNTMyLDYgKzE1NTYsMTAgQEAgcmFkZW9uX2FkZF9hdG9tX2Nvbm5l
Y3RvcihzdHJ1Y3QgZHJtX2RldmljZSAqZGV2LA0KIAkJCWJyZWFrOw0KIAkJY2FzZSBEUk1fTU9E
RV9DT05ORUNUT1JfTFZEUzoNCiAJCWNhc2UgRFJNX01PREVfQ09OTkVDVE9SX2VEUDoNCisJCQlk
cm1fY29ubmVjdG9yX2luaXQoZGV2LCAmcmFkZW9uX2Nvbm5lY3Rvci0+YmFzZSwNCisJCQkJCSAg
ICZyYWRlb25fbHZkc19icmlkZ2VfY29ubmVjdG9yX2Z1bmNzLCBjb25uZWN0b3JfdHlwZSk7DQor
CQkJZHJtX2Nvbm5lY3Rvcl9oZWxwZXJfYWRkKCZyYWRlb25fY29ubmVjdG9yLT5iYXNlLA0KKwkJ
CQkJCSAmcmFkZW9uX2RwX2Nvbm5lY3Rvcl9oZWxwZXJfZnVuY3MpOw0KIAkJCWRybV9jb25uZWN0
b3JfYXR0YWNoX3Byb3BlcnR5KCZyYWRlb25fY29ubmVjdG9yLT5iYXNlLA0KIAkJCQkJCSAgICAg
IGRldi0+bW9kZV9jb25maWcuc2NhbGluZ19tb2RlX3Byb3BlcnR5LA0KIAkJCQkJCSAgICAgIERS
TV9NT0RFX1NDQUxFX0ZVTExTQ1JFRU4pOw0KQEAgLTE2OTUsNyArMTcyMyw3IEBAIHJhZGVvbl9h
ZGRfYXRvbV9jb25uZWN0b3Ioc3RydWN0IGRybV9kZXZpY2UgKmRldiwNCiAJCQkJZ290byBmYWls
ZWQ7DQogCQkJcmFkZW9uX2RpZ19jb25uZWN0b3ItPmlncF9sYW5lX2luZm8gPSBpZ3BfbGFuZV9p
bmZvOw0KIAkJCXJhZGVvbl9jb25uZWN0b3ItPmNvbl9wcml2ID0gcmFkZW9uX2RpZ19jb25uZWN0
b3I7DQotCQkJZHJtX2Nvbm5lY3Rvcl9pbml0KGRldiwgJnJhZGVvbl9jb25uZWN0b3ItPmJhc2Us
ICZyYWRlb25fZHBfY29ubmVjdG9yX2Z1bmNzLCBjb25uZWN0b3JfdHlwZSk7DQorCQkJZHJtX2Nv
bm5lY3Rvcl9pbml0KGRldiwgJnJhZGVvbl9jb25uZWN0b3ItPmJhc2UsICZyYWRlb25fZWRwX2Nv
bm5lY3Rvcl9mdW5jcywgY29ubmVjdG9yX3R5cGUpOw0KIAkJCWRybV9jb25uZWN0b3JfaGVscGVy
X2FkZCgmcmFkZW9uX2Nvbm5lY3Rvci0+YmFzZSwgJnJhZGVvbl9kcF9jb25uZWN0b3JfaGVscGVy
X2Z1bmNzKTsNCiAJCQlpZiAoaTJjX2J1cy0+dmFsaWQpIHsNCiAJCQkJLyogYWRkIERQIGkyYyBi
dXMgKi8NCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kZXZpY2Uu
YyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2RldmljZS5jDQppbmRleCBjZDk0YWJi
Li44Y2RlODRiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fZGV2
aWNlLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2RldmljZS5jDQpAQCAt
ODE4LDEwICs4MTgsMTYgQEAgaW50IHJhZGVvbl9kZXZpY2VfaW5pdChzdHJ1Y3QgcmFkZW9uX2Rl
dmljZSAqcmRldiwNCiAJCQlyZXR1cm4gcjsNCiAJfQ0KIAlpZiAocmFkZW9uX3Rlc3RpbmcpIHsN
Ci0JCXJhZGVvbl90ZXN0X21vdmVzKHJkZXYpOw0KKwkJaWYgKHJkZXYtPmFjY2VsX3dvcmtpbmcp
DQorCQkJcmFkZW9uX3Rlc3RfbW92ZXMocmRldik7DQorCQllbHNlDQorCQkJRFJNX0lORk8oInJh
ZGVvbjogYWNjZWxlcmF0aW9uIGRpc2FibGVkLCBza2lwcGluZyBtb3ZlIHRlc3RzXG4iKTsNCiAJ
fQ0KIAlpZiAocmFkZW9uX2JlbmNobWFya2luZykgew0KLQkJcmFkZW9uX2JlbmNobWFyayhyZGV2
LCByYWRlb25fYmVuY2htYXJraW5nKTsNCisJCWlmIChyZGV2LT5hY2NlbF93b3JraW5nKQ0KKwkJ
CXJhZGVvbl9iZW5jaG1hcmsocmRldiwgcmFkZW9uX2JlbmNobWFya2luZyk7DQorCQllbHNlDQor
CQkJRFJNX0lORk8oInJhZGVvbjogYWNjZWxlcmF0aW9uIGRpc2FibGVkLCBza2lwcGluZyBiZW5j
aG1hcmtzXG4iKTsNCiAJfQ0KIAlyZXR1cm4gMDsNCiB9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9yczQwMC5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yczQwMC5jDQpp
bmRleCA0ZGQ5NTEyLi5jMDg3NDM0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVv
bi9yczQwMC5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JzNDAwLmMNCkBAIC0xNzQs
MTAgKzE3NCwxMyBAQCBpbnQgcnM0MDBfZ2FydF9lbmFibGUoc3RydWN0IHJhZGVvbl9kZXZpY2Ug
KnJkZXYpDQogCS8qIEZJWE1FOiBhY2NvcmRpbmcgdG8gZG9jIHdlIHNob3VsZCBzZXQgSElERV9N
TUNGR19CQVI9MCwNCiAJICogQUdQTU9ERTMwPTAgJiBBR1AzMEVOSEFOQ0VEPTAgaW4gTkJfQ05U
TCAqLw0KIAlpZiAoKHJkZXYtPmZhbWlseSA9PSBDSElQX1JTNjkwKSB8fCAocmRldi0+ZmFtaWx5
ID09IENISVBfUlM3NDApKSB7DQotCQlXUkVHMzJfTUMoUlM0ODBfTUNfTUlTQ19DTlRMLA0KLQkJ
CSAgKFJTNDgwX0dBUlRfSU5ERVhfUkVHX0VOIHwgUlM2OTBfQkxPQ0tfR0ZYX0QzX0VOKSk7DQor
CQl0bXAgPSBSUkVHMzJfTUMoUlM0ODBfTUNfTUlTQ19DTlRMKTsNCisJCXRtcCB8PSBSUzQ4MF9H
QVJUX0lOREVYX1JFR19FTiB8IFJTNjkwX0JMT0NLX0dGWF9EM19FTjsNCisJCVdSRUczMl9NQyhS
UzQ4MF9NQ19NSVNDX0NOVEwsIHRtcCk7DQogCX0gZWxzZSB7DQotCQlXUkVHMzJfTUMoUlM0ODBf
TUNfTUlTQ19DTlRMLCBSUzQ4MF9HQVJUX0lOREVYX1JFR19FTik7DQorCQl0bXAgPSBSUkVHMzJf
TUMoUlM0ODBfTUNfTUlTQ19DTlRMKTsNCisJCXRtcCB8PSBSUzQ4MF9HQVJUX0lOREVYX1JFR19F
TjsNCisJCVdSRUczMl9NQyhSUzQ4MF9NQ19NSVNDX0NOVEwsIHRtcCk7DQogCX0NCiAJLyogRW5h
YmxlIGdhcnQgKi8NCiAJV1JFRzMyX01DKFJTNDgwX0FHUF9BRERSRVNTX1NQQUNFX1NJWkUsIChS
UzQ4MF9HQVJUX0VOIHwgc2l6ZV9yZWcpKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2hpZC9oaWQt
Y29yZS5jIGIvZHJpdmVycy9oaWQvaGlkLWNvcmUuYw0KaW5kZXggNjExYWFmYy4uOWFjNDM4OSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvaGlkL2hpZC1jb3JlLmMNCisrKyBiL2RyaXZlcnMvaGlkL2hp
ZC1jb3JlLmMNCkBAIC01OSw2ICs1OSw4IEBAIHN0cnVjdCBoaWRfcmVwb3J0ICpoaWRfcmVnaXN0
ZXJfcmVwb3J0KHN0cnVjdCBoaWRfZGV2aWNlICpkZXZpY2UsIHVuc2lnbmVkIHR5cGUsDQogCXN0
cnVjdCBoaWRfcmVwb3J0X2VudW0gKnJlcG9ydF9lbnVtID0gZGV2aWNlLT5yZXBvcnRfZW51bSAr
IHR5cGU7DQogCXN0cnVjdCBoaWRfcmVwb3J0ICpyZXBvcnQ7DQogDQorCWlmIChpZCA+PSBISURf
TUFYX0lEUykNCisJCXJldHVybiBOVUxMOw0KIAlpZiAocmVwb3J0X2VudW0tPnJlcG9ydF9pZF9o
YXNoW2lkXSkNCiAJCXJldHVybiByZXBvcnRfZW51bS0+cmVwb3J0X2lkX2hhc2hbaWRdOw0KIA0K
QEAgLTIxNiw5ICsyMTgsOSBAQCBzdGF0aWMgaW50IGhpZF9hZGRfZmllbGQoc3RydWN0IGhpZF9w
YXJzZXIgKnBhcnNlciwgdW5zaWduZWQgcmVwb3J0X3R5cGUsIHVuc2lnbg0KIHsNCiAJc3RydWN0
IGhpZF9yZXBvcnQgKnJlcG9ydDsNCiAJc3RydWN0IGhpZF9maWVsZCAqZmllbGQ7DQotCWludCB1
c2FnZXM7DQorCXVuc2lnbmVkIHVzYWdlczsNCiAJdW5zaWduZWQgb2Zmc2V0Ow0KLQlpbnQgaTsN
CisJdW5zaWduZWQgaTsNCiANCiAJcmVwb3J0ID0gaGlkX3JlZ2lzdGVyX3JlcG9ydChwYXJzZXIt
PmRldmljZSwgcmVwb3J0X3R5cGUsIHBhcnNlci0+Z2xvYmFsLnJlcG9ydF9pZCk7DQogCWlmICgh
cmVwb3J0KSB7DQpAQCAtMjM3LDcgKzIzOSw4IEBAIHN0YXRpYyBpbnQgaGlkX2FkZF9maWVsZChz
dHJ1Y3QgaGlkX3BhcnNlciAqcGFyc2VyLCB1bnNpZ25lZCByZXBvcnRfdHlwZSwgdW5zaWduDQog
CWlmICghcGFyc2VyLT5sb2NhbC51c2FnZV9pbmRleCkgLyogSWdub3JlIHBhZGRpbmcgZmllbGRz
ICovDQogCQlyZXR1cm4gMDsNCiANCi0JdXNhZ2VzID0gbWF4X3QoaW50LCBwYXJzZXItPmxvY2Fs
LnVzYWdlX2luZGV4LCBwYXJzZXItPmdsb2JhbC5yZXBvcnRfY291bnQpOw0KKwl1c2FnZXMgPSBt
YXhfdCh1bnNpZ25lZCwgcGFyc2VyLT5sb2NhbC51c2FnZV9pbmRleCwNCisJCQkJIHBhcnNlci0+
Z2xvYmFsLnJlcG9ydF9jb3VudCk7DQogDQogCWZpZWxkID0gaGlkX3JlZ2lzdGVyX2ZpZWxkKHJl
cG9ydCwgdXNhZ2VzLCBwYXJzZXItPmdsb2JhbC5yZXBvcnRfY291bnQpOw0KIAlpZiAoIWZpZWxk
KQ0KQEAgLTI0OCw3ICsyNTEsNyBAQCBzdGF0aWMgaW50IGhpZF9hZGRfZmllbGQoc3RydWN0IGhp
ZF9wYXJzZXIgKnBhcnNlciwgdW5zaWduZWQgcmVwb3J0X3R5cGUsIHVuc2lnbg0KIAlmaWVsZC0+
YXBwbGljYXRpb24gPSBoaWRfbG9va3VwX2NvbGxlY3Rpb24ocGFyc2VyLCBISURfQ09MTEVDVElP
Tl9BUFBMSUNBVElPTik7DQogDQogCWZvciAoaSA9IDA7IGkgPCB1c2FnZXM7IGkrKykgew0KLQkJ
aW50IGogPSBpOw0KKwkJdW5zaWduZWQgaiA9IGk7DQogCQkvKiBEdXBsaWNhdGUgdGhlIGxhc3Qg
dXNhZ2Ugd2UgcGFyc2VkIGlmIHdlIGhhdmUgZXhjZXNzIHZhbHVlcyAqLw0KIAkJaWYgKGkgPj0g
cGFyc2VyLT5sb2NhbC51c2FnZV9pbmRleCkNCiAJCQlqID0gcGFyc2VyLT5sb2NhbC51c2FnZV9p
bmRleCAtIDE7DQpAQCAtMzgwLDggKzM4MywxMCBAQCBzdGF0aWMgaW50IGhpZF9wYXJzZXJfZ2xv
YmFsKHN0cnVjdCBoaWRfcGFyc2VyICpwYXJzZXIsIHN0cnVjdCBoaWRfaXRlbSAqaXRlbSkNCiAN
CiAJY2FzZSBISURfR0xPQkFMX0lURU1fVEFHX1JFUE9SVF9JRDoNCiAJCXBhcnNlci0+Z2xvYmFs
LnJlcG9ydF9pZCA9IGl0ZW1fdWRhdGEoaXRlbSk7DQotCQlpZiAocGFyc2VyLT5nbG9iYWwucmVw
b3J0X2lkID09IDApIHsNCi0JCQlkYmdfaGlkKCJyZXBvcnRfaWQgMCBpcyBpbnZhbGlkXG4iKTsN
CisJCWlmIChwYXJzZXItPmdsb2JhbC5yZXBvcnRfaWQgPT0gMCB8fA0KKwkJICAgIHBhcnNlci0+
Z2xvYmFsLnJlcG9ydF9pZCA+PSBISURfTUFYX0lEUykgew0KKwkJCWRiZ19oaWQoInJlcG9ydF9p
ZCAldSBpcyBpbnZhbGlkXG4iLA0KKwkJCQlwYXJzZXItPmdsb2JhbC5yZXBvcnRfaWQpOw0KIAkJ
CXJldHVybiAtMTsNCiAJCX0NCiAJCXJldHVybiAwOw0KQEAgLTU1Miw3ICs1NTcsNyBAQCBzdGF0
aWMgdm9pZCBoaWRfZGV2aWNlX3JlbGVhc2Uoc3RydWN0IGRldmljZSAqZGV2KQ0KIAlmb3IgKGkg
PSAwOyBpIDwgSElEX1JFUE9SVF9UWVBFUzsgaSsrKSB7DQogCQlzdHJ1Y3QgaGlkX3JlcG9ydF9l
bnVtICpyZXBvcnRfZW51bSA9IGRldmljZS0+cmVwb3J0X2VudW0gKyBpOw0KIA0KLQkJZm9yIChq
ID0gMDsgaiA8IDI1NjsgaisrKSB7DQorCQlmb3IgKGogPSAwOyBqIDwgSElEX01BWF9JRFM7IGor
Kykgew0KIAkJCXN0cnVjdCBoaWRfcmVwb3J0ICpyZXBvcnQgPSByZXBvcnRfZW51bS0+cmVwb3J0
X2lkX2hhc2hbal07DQogCQkJaWYgKHJlcG9ydCkNCiAJCQkJaGlkX2ZyZWVfcmVwb3J0KHJlcG9y
dCk7DQpAQCAtNzEwLDYgKzcxNSw2NCBAQCBlcnI6DQogfQ0KIEVYUE9SVF9TWU1CT0xfR1BMKGhp
ZF9wYXJzZV9yZXBvcnQpOw0KIA0KK3N0YXRpYyBjb25zdCBjaGFyICogY29uc3QgaGlkX3JlcG9y
dF9uYW1lc1tdID0gew0KKwkiSElEX0lOUFVUX1JFUE9SVCIsDQorCSJISURfT1VUUFVUX1JFUE9S
VCIsDQorCSJISURfRkVBVFVSRV9SRVBPUlQiLA0KK307DQorLyoqDQorICogaGlkX3ZhbGlkYXRl
X3ZhbHVlcyAtIHZhbGlkYXRlIGV4aXN0aW5nIGRldmljZSByZXBvcnQncyB2YWx1ZSBpbmRleGVz
DQorICoNCisgKiBAZGV2aWNlOiBoaWQgZGV2aWNlDQorICogQHR5cGU6IHdoaWNoIHJlcG9ydCB0
eXBlIHRvIGV4YW1pbmUNCisgKiBAaWQ6IHdoaWNoIHJlcG9ydCBJRCB0byBleGFtaW5lICgwIGZv
ciBmaXJzdCkNCisgKiBAZmllbGRfaW5kZXg6IHdoaWNoIHJlcG9ydCBmaWVsZCB0byBleGFtaW5l
DQorICogQHJlcG9ydF9jb3VudHM6IGV4cGVjdGVkIG51bWJlciBvZiB2YWx1ZXMNCisgKg0KKyAq
IFZhbGlkYXRlIHRoZSBudW1iZXIgb2YgdmFsdWVzIGluIGEgZ2l2ZW4gZmllbGQgb2YgYSBnaXZl
biByZXBvcnQsIGFmdGVyDQorICogcGFyc2luZy4NCisgKi8NCitzdHJ1Y3QgaGlkX3JlcG9ydCAq
aGlkX3ZhbGlkYXRlX3ZhbHVlcyhzdHJ1Y3QgaGlkX2RldmljZSAqaGlkLA0KKwkJCQkgICAgICAg
dW5zaWduZWQgaW50IHR5cGUsIHVuc2lnbmVkIGludCBpZCwNCisJCQkJICAgICAgIHVuc2lnbmVk
IGludCBmaWVsZF9pbmRleCwNCisJCQkJICAgICAgIHVuc2lnbmVkIGludCByZXBvcnRfY291bnRz
KQ0KK3sNCisJc3RydWN0IGhpZF9yZXBvcnQgKnJlcG9ydDsNCisNCisJaWYgKHR5cGUgPiBISURf
RkVBVFVSRV9SRVBPUlQpIHsNCisJCWhpZF9lcnIoaGlkLCAiaW52YWxpZCBISUQgcmVwb3J0IHR5
cGUgJXVcbiIsIHR5cGUpOw0KKwkJcmV0dXJuIE5VTEw7DQorCX0NCisNCisJaWYgKGlkID49IEhJ
RF9NQVhfSURTKSB7DQorCQloaWRfZXJyKGhpZCwgImludmFsaWQgSElEIHJlcG9ydCBpZCAldVxu
IiwgaWQpOw0KKwkJcmV0dXJuIE5VTEw7DQorCX0NCisNCisJLyoNCisJICogRXhwbGljaXRseSBu
b3QgdXNpbmcgaGlkX2dldF9yZXBvcnQoKSBoZXJlIHNpbmNlIGl0IGRlcGVuZHMgb24NCisJICog
LT5udW1iZXJlZCBiZWluZyBjaGVja2VkLCB3aGljaCBtYXkgbm90IGFsd2F5cyBiZSB0aGUgY2Fz
ZSB3aGVuDQorCSAqIGRyaXZlcnMgZ28gdG8gYWNjZXNzIHJlcG9ydCB2YWx1ZXMuDQorCSAqLw0K
KwlyZXBvcnQgPSBoaWQtPnJlcG9ydF9lbnVtW3R5cGVdLnJlcG9ydF9pZF9oYXNoW2lkXTsNCisJ
aWYgKCFyZXBvcnQpIHsNCisJCWhpZF9lcnIoaGlkLCAibWlzc2luZyAlcyAldVxuIiwgaGlkX3Jl
cG9ydF9uYW1lc1t0eXBlXSwgaWQpOw0KKwkJcmV0dXJuIE5VTEw7DQorCX0NCisJaWYgKHJlcG9y
dC0+bWF4ZmllbGQgPD0gZmllbGRfaW5kZXgpIHsNCisJCWhpZF9lcnIoaGlkLCAibm90IGVub3Vn
aCBmaWVsZHMgaW4gJXMgJXVcbiIsDQorCQkJaGlkX3JlcG9ydF9uYW1lc1t0eXBlXSwgaWQpOw0K
KwkJcmV0dXJuIE5VTEw7DQorCX0NCisJaWYgKHJlcG9ydC0+ZmllbGRbZmllbGRfaW5kZXhdLT5y
ZXBvcnRfY291bnQgPCByZXBvcnRfY291bnRzKSB7DQorCQloaWRfZXJyKGhpZCwgIm5vdCBlbm91
Z2ggdmFsdWVzIGluICVzICV1IGZpZWxkICV1XG4iLA0KKwkJCWhpZF9yZXBvcnRfbmFtZXNbdHlw
ZV0sIGlkLCBmaWVsZF9pbmRleCk7DQorCQlyZXR1cm4gTlVMTDsNCisJfQ0KKwlyZXR1cm4gcmVw
b3J0Ow0KK30NCitFWFBPUlRfU1lNQk9MX0dQTChoaWRfdmFsaWRhdGVfdmFsdWVzKTsNCisNCiAv
Kg0KICAqIENvbnZlcnQgYSBzaWduZWQgbi1iaXQgaW50ZWdlciB0byBzaWduZWQgMzItYml0IGlu
dGVnZXIuIENvbW1vbg0KICAqIGNhc2VzIGFyZSBkb25lIHRocm91Z2ggdGhlIGNvbXBpbGVyLCB0
aGUgc2NyZXdlZCB0aGluZ3MgaGFzIHRvIGJlDQpAQCAtOTkwLDcgKzEwNTMsMTIgQEAgRVhQT1JU
X1NZTUJPTF9HUEwoaGlkX291dHB1dF9yZXBvcnQpOw0KIA0KIGludCBoaWRfc2V0X2ZpZWxkKHN0
cnVjdCBoaWRfZmllbGQgKmZpZWxkLCB1bnNpZ25lZCBvZmZzZXQsIF9fczMyIHZhbHVlKQ0KIHsN
Ci0JdW5zaWduZWQgc2l6ZSA9IGZpZWxkLT5yZXBvcnRfc2l6ZTsNCisJdW5zaWduZWQgc2l6ZTsN
CisNCisJaWYgKCFmaWVsZCkNCisJCXJldHVybiAtMTsNCisNCisJc2l6ZSA9IGZpZWxkLT5yZXBv
cnRfc2l6ZTsNCiANCiAJaGlkX2R1bXBfaW5wdXQoZmllbGQtPnJlcG9ydC0+ZGV2aWNlLCBmaWVs
ZC0+dXNhZ2UgKyBvZmZzZXQsIHZhbHVlKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2hpZC9o
aWQtaWRzLmggYi9kcml2ZXJzL2hpZC9oaWQtaWRzLmgNCmluZGV4IDA4MDc1ZjIuLmNhMmIzZTYg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL2hpZC9oaWQtaWRzLmgNCisrKyBiL2RyaXZlcnMvaGlkL2hp
ZC1pZHMuaA0KQEAgLTU4MSw2ICs1ODEsNyBAQA0KICNkZWZpbmUgVVNCX0RFVklDRV9JRF9OVFJJ
R19UT1VDSF9TQ1JFRU5fMTYgICAweDAwMTINCiAjZGVmaW5lIFVTQl9ERVZJQ0VfSURfTlRSSUdf
VE9VQ0hfU0NSRUVOXzE3ICAgMHgwMDEzDQogI2RlZmluZSBVU0JfREVWSUNFX0lEX05UUklHX1RP
VUNIX1NDUkVFTl8xOCAgIDB4MDAxNA0KKyNkZWZpbmUgVVNCX0RFVklDRV9JRF9OVFJJR19EVU9T
RU5TRSAweDE1MDANCiANCiAjZGVmaW5lIFVTQl9WRU5ET1JfSURfT05UUkFLCQkweDBhMDcNCiAj
ZGVmaW5lIFVTQl9ERVZJQ0VfSURfT05UUkFLX0FEVTEwMAkweDAwNjQNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2hpZC9oaWQtaW5wdXQuYyBiL2RyaXZlcnMvaGlkL2hpZC1pbnB1dC5jDQppbmRleCBm
MzMzMTM5Li45NWM3OWEzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9oaWQvaGlkLWlucHV0LmMNCisr
KyBiL2RyaXZlcnMvaGlkL2hpZC1pbnB1dC5jDQpAQCAtMjg0LDYgKzI4NCwxMCBAQCBzdGF0aWMg
dm9pZCBoaWRpbnB1dF9jb25maWd1cmVfdXNhZ2Uoc3RydWN0IGhpZF9pbnB1dCAqaGlkaW5wdXQs
IHN0cnVjdCBoaWRfZmllbA0KIAlpZiAoZmllbGQtPmZsYWdzICYgSElEX01BSU5fSVRFTV9DT05T
VEFOVCkNCiAJCWdvdG8gaWdub3JlOw0KIA0KKwkvKiBJZ25vcmUgaWYgcmVwb3J0IGNvdW50IGlz
IG91dCBvZiBib3VuZHMuICovDQorCWlmIChmaWVsZC0+cmVwb3J0X2NvdW50IDwgMSkNCisJCWdv
dG8gaWdub3JlOw0KKw0KIAkvKiBvbmx5IExFRCB1c2FnZXMgYXJlIHN1cHBvcnRlZCBpbiBvdXRw
dXQgZmllbGRzICovDQogCWlmIChmaWVsZC0+cmVwb3J0X3R5cGUgPT0gSElEX09VVFBVVF9SRVBP
UlQgJiYNCiAJCQkodXNhZ2UtPmhpZCAmIEhJRF9VU0FHRV9QQUdFKSAhPSBISURfVVBfTEVEKSB7
DQpAQCAtODg3LDEwICs4OTEsMTUgQEAgc3RhdGljIHZvaWQgcmVwb3J0X2ZlYXR1cmVzKHN0cnVj
dCBoaWRfZGV2aWNlICpoaWQpDQogDQogCXJlcF9lbnVtID0gJmhpZC0+cmVwb3J0X2VudW1bSElE
X0ZFQVRVUkVfUkVQT1JUXTsNCiAJbGlzdF9mb3JfZWFjaF9lbnRyeShyZXAsICZyZXBfZW51bS0+
cmVwb3J0X2xpc3QsIGxpc3QpDQotCQlmb3IgKGkgPSAwOyBpIDwgcmVwLT5tYXhmaWVsZDsgaSsr
KQ0KKwkJZm9yIChpID0gMDsgaSA8IHJlcC0+bWF4ZmllbGQ7IGkrKykgew0KKwkJCS8qIElnbm9y
ZSBpZiByZXBvcnQgY291bnQgaXMgb3V0IG9mIGJvdW5kcy4gKi8NCisJCQlpZiAocmVwLT5maWVs
ZFtpXS0+cmVwb3J0X2NvdW50IDwgMSkNCisJCQkJY29udGludWU7DQorDQogCQkJZm9yIChqID0g
MDsgaiA8IHJlcC0+ZmllbGRbaV0tPm1heHVzYWdlOyBqKyspDQogCQkJCWRydi0+ZmVhdHVyZV9t
YXBwaW5nKGhpZCwgcmVwLT5maWVsZFtpXSwNCiAJCQkJCQkgICAgIHJlcC0+ZmllbGRbaV0tPnVz
YWdlICsgaik7DQorCQl9DQogfQ0KIA0KIC8qDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9oaWQvaGlk
LWxnMmZmLmMgYi9kcml2ZXJzL2hpZC9oaWQtbGcyZmYuYw0KaW5kZXggM2MzMWJjNi4uMTI4ZjAx
MSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaGlkL2hpZC1sZzJmZi5jDQorKysgYi9kcml2ZXJzL2hp
ZC9oaWQtbGcyZmYuYw0KQEAgLTY2LDI2ICs2NiwxMyBAQCBpbnQgbGcyZmZfaW5pdChzdHJ1Y3Qg
aGlkX2RldmljZSAqaGlkKQ0KIAlzdHJ1Y3QgaGlkX3JlcG9ydCAqcmVwb3J0Ow0KIAlzdHJ1Y3Qg
aGlkX2lucHV0ICpoaWRpbnB1dCA9IGxpc3RfZW50cnkoaGlkLT5pbnB1dHMubmV4dCwNCiAJCQkJ
CQlzdHJ1Y3QgaGlkX2lucHV0LCBsaXN0KTsNCi0Jc3RydWN0IGxpc3RfaGVhZCAqcmVwb3J0X2xp
c3QgPQ0KLQkJCSZoaWQtPnJlcG9ydF9lbnVtW0hJRF9PVVRQVVRfUkVQT1JUXS5yZXBvcnRfbGlz
dDsNCiAJc3RydWN0IGlucHV0X2RldiAqZGV2ID0gaGlkaW5wdXQtPmlucHV0Ow0KIAlpbnQgZXJy
b3I7DQogDQotCWlmIChsaXN0X2VtcHR5KHJlcG9ydF9saXN0KSkgew0KLQkJaGlkX2VycihoaWQs
ICJubyBvdXRwdXQgcmVwb3J0IGZvdW5kXG4iKTsNCisJLyogQ2hlY2sgdGhhdCB0aGUgcmVwb3J0
IGxvb2tzIG9rICovDQorCXJlcG9ydCA9IGhpZF92YWxpZGF0ZV92YWx1ZXMoaGlkLCBISURfT1VU
UFVUX1JFUE9SVCwgMCwgMCwgNyk7DQorCWlmICghcmVwb3J0KQ0KIAkJcmV0dXJuIC1FTk9ERVY7
DQotCX0NCi0NCi0JcmVwb3J0ID0gbGlzdF9lbnRyeShyZXBvcnRfbGlzdC0+bmV4dCwgc3RydWN0
IGhpZF9yZXBvcnQsIGxpc3QpOw0KLQ0KLQlpZiAocmVwb3J0LT5tYXhmaWVsZCA8IDEpIHsNCi0J
CWhpZF9lcnIoaGlkLCAib3V0cHV0IHJlcG9ydCBpcyBlbXB0eVxuIik7DQotCQlyZXR1cm4gLUVO
T0RFVjsNCi0JfQ0KLQlpZiAocmVwb3J0LT5maWVsZFswXS0+cmVwb3J0X2NvdW50IDwgNykgew0K
LQkJaGlkX2VycihoaWQsICJub3QgZW5vdWdoIHZhbHVlcyBpbiB0aGUgZmllbGRcbiIpOw0KLQkJ
cmV0dXJuIC1FTk9ERVY7DQotCX0NCiANCiAJbGcyZmYgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3Qg
bGcyZmZfZGV2aWNlKSwgR0ZQX0tFUk5FTCk7DQogCWlmICghbGcyZmYpDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9oaWQvaGlkLWxnM2ZmLmMgYi9kcml2ZXJzL2hpZC9oaWQtbGczZmYuYw0KaW5kZXgg
Zjk4NjQ0Yy4uOTFmOTgxZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaGlkL2hpZC1sZzNmZi5jDQor
KysgYi9kcml2ZXJzL2hpZC9oaWQtbGczZmYuYw0KQEAgLTY4LDEwICs2OCwxMSBAQCBzdGF0aWMg
aW50IGhpZF9sZzNmZl9wbGF5KHN0cnVjdCBpbnB1dF9kZXYgKmRldiwgdm9pZCAqZGF0YSwNCiAJ
aW50IHgsIHk7DQogDQogLyoNCi0gKiBNYXh1c2FnZSBzaG91bGQgYWx3YXlzIGJlIDYzIChtYXhp
bXVtIGZpZWxkcykNCi0gKiBsaWtlbHkgYSBiZXR0ZXIgd2F5IHRvIGVuc3VyZSB0aGlzIGRhdGEg
aXMgY2xlYW4NCisgKiBBdmFpbGFibGUgdmFsdWVzIGluIHRoZSBmaWVsZCBzaG91bGQgYWx3YXlz
IGJlIDYzLCBidXQgd2Ugb25seSB1c2UgdXAgdG8NCisgKiAzNS4gSW5zdGVhZCwgY2xlYXIgdGhl
IGVudGlyZSBhcmVhLCBob3dldmVyIGJpZyBpdCBpcy4NCiAgKi8NCi0JbWVtc2V0KHJlcG9ydC0+
ZmllbGRbMF0tPnZhbHVlLCAwLCBzaXplb2YoX19zMzIpKnJlcG9ydC0+ZmllbGRbMF0tPm1heHVz
YWdlKTsNCisJbWVtc2V0KHJlcG9ydC0+ZmllbGRbMF0tPnZhbHVlLCAwLA0KKwkgICAgICAgc2l6
ZW9mKF9fczMyKSAqIHJlcG9ydC0+ZmllbGRbMF0tPnJlcG9ydF9jb3VudCk7DQogDQogCXN3aXRj
aCAoZWZmZWN0LT50eXBlKSB7DQogCWNhc2UgRkZfQ09OU1RBTlQ6DQpAQCAtMTMxLDMyICsxMzIs
MTQgQEAgc3RhdGljIGNvbnN0IHNpZ25lZCBzaG9ydCBmZjNfam95c3RpY2tfYWNbXSA9IHsNCiBp
bnQgbGczZmZfaW5pdChzdHJ1Y3QgaGlkX2RldmljZSAqaGlkKQ0KIHsNCiAJc3RydWN0IGhpZF9p
bnB1dCAqaGlkaW5wdXQgPSBsaXN0X2VudHJ5KGhpZC0+aW5wdXRzLm5leHQsIHN0cnVjdCBoaWRf
aW5wdXQsIGxpc3QpOw0KLQlzdHJ1Y3QgbGlzdF9oZWFkICpyZXBvcnRfbGlzdCA9ICZoaWQtPnJl
cG9ydF9lbnVtW0hJRF9PVVRQVVRfUkVQT1JUXS5yZXBvcnRfbGlzdDsNCiAJc3RydWN0IGlucHV0
X2RldiAqZGV2ID0gaGlkaW5wdXQtPmlucHV0Ow0KLQlzdHJ1Y3QgaGlkX3JlcG9ydCAqcmVwb3J0
Ow0KLQlzdHJ1Y3QgaGlkX2ZpZWxkICpmaWVsZDsNCiAJY29uc3Qgc2lnbmVkIHNob3J0ICpmZl9i
aXRzID0gZmYzX2pveXN0aWNrX2FjOw0KIAlpbnQgZXJyb3I7DQogCWludCBpOw0KIA0KLQkvKiBG
aW5kIHRoZSByZXBvcnQgdG8gdXNlICovDQotCWlmIChsaXN0X2VtcHR5KHJlcG9ydF9saXN0KSkg
ew0KLQkJaGlkX2VycihoaWQsICJObyBvdXRwdXQgcmVwb3J0IGZvdW5kXG4iKTsNCi0JCXJldHVy
biAtMTsNCi0JfQ0KLQ0KIAkvKiBDaGVjayB0aGF0IHRoZSByZXBvcnQgbG9va3Mgb2sgKi8NCi0J
cmVwb3J0ID0gbGlzdF9lbnRyeShyZXBvcnRfbGlzdC0+bmV4dCwgc3RydWN0IGhpZF9yZXBvcnQs
IGxpc3QpOw0KLQlpZiAoIXJlcG9ydCkgew0KLQkJaGlkX2VycihoaWQsICJOVUxMIG91dHB1dCBy
ZXBvcnRcbiIpOw0KLQkJcmV0dXJuIC0xOw0KLQl9DQotDQotCWZpZWxkID0gcmVwb3J0LT5maWVs
ZFswXTsNCi0JaWYgKCFmaWVsZCkgew0KLQkJaGlkX2VycihoaWQsICJOVUxMIGZpZWxkXG4iKTsN
Ci0JCXJldHVybiAtMTsNCi0JfQ0KKwlpZiAoIWhpZF92YWxpZGF0ZV92YWx1ZXMoaGlkLCBISURf
T1VUUFVUX1JFUE9SVCwgMCwgMCwgMzUpKQ0KKwkJcmV0dXJuIC1FTk9ERVY7DQogDQogCS8qIEFz
c3VtZSBzaW5nbGUgZml4ZWQgZGV2aWNlIEc5NDAgKi8NCiAJZm9yIChpID0gMDsgZmZfYml0c1tp
XSA+PSAwOyBpKyspDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9oaWQvaGlkLWxnNGZmLmMgYi9kcml2
ZXJzL2hpZC9oaWQtbGc0ZmYuYw0KaW5kZXggMTAzZjMwZC4uNWM2YmY0YiAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvaGlkL2hpZC1sZzRmZi5jDQorKysgYi9kcml2ZXJzL2hpZC9oaWQtbGc0ZmYuYw0K
QEAgLTMzOSwzMyArMzM5LDE1IEBAIHN0YXRpYyBzc2l6ZV90IGxnNGZmX3JhbmdlX3N0b3JlKHN0
cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0DQogaW50IGxnNGZm
X2luaXQoc3RydWN0IGhpZF9kZXZpY2UgKmhpZCkNCiB7DQogCXN0cnVjdCBoaWRfaW5wdXQgKmhp
ZGlucHV0ID0gbGlzdF9lbnRyeShoaWQtPmlucHV0cy5uZXh0LCBzdHJ1Y3QgaGlkX2lucHV0LCBs
aXN0KTsNCi0Jc3RydWN0IGxpc3RfaGVhZCAqcmVwb3J0X2xpc3QgPSAmaGlkLT5yZXBvcnRfZW51
bVtISURfT1VUUFVUX1JFUE9SVF0ucmVwb3J0X2xpc3Q7DQogCXN0cnVjdCBpbnB1dF9kZXYgKmRl
diA9IGhpZGlucHV0LT5pbnB1dDsNCi0Jc3RydWN0IGhpZF9yZXBvcnQgKnJlcG9ydDsNCi0Jc3Ry
dWN0IGhpZF9maWVsZCAqZmllbGQ7DQogCXN0cnVjdCBsZzRmZl9kZXZpY2VfZW50cnkgKmVudHJ5
Ow0KIAlzdHJ1Y3QgdXNiX2RldmljZV9kZXNjcmlwdG9yICp1ZGVzYzsNCiAJaW50IGVycm9yLCBp
LCBqOw0KIAlfX3UxNiBiY2REZXZpY2UsIHJldl9tYWosIHJldl9taW47DQogDQotCS8qIEZpbmQg
dGhlIHJlcG9ydCB0byB1c2UgKi8NCi0JaWYgKGxpc3RfZW1wdHkocmVwb3J0X2xpc3QpKSB7DQot
CQloaWRfZXJyKGhpZCwgIk5vIG91dHB1dCByZXBvcnQgZm91bmRcbiIpOw0KLQkJcmV0dXJuIC0x
Ow0KLQl9DQotDQogCS8qIENoZWNrIHRoYXQgdGhlIHJlcG9ydCBsb29rcyBvayAqLw0KLQlyZXBv
cnQgPSBsaXN0X2VudHJ5KHJlcG9ydF9saXN0LT5uZXh0LCBzdHJ1Y3QgaGlkX3JlcG9ydCwgbGlz
dCk7DQotCWlmICghcmVwb3J0KSB7DQotCQloaWRfZXJyKGhpZCwgIk5VTEwgb3V0cHV0IHJlcG9y
dFxuIik7DQorCWlmICghaGlkX3ZhbGlkYXRlX3ZhbHVlcyhoaWQsIEhJRF9PVVRQVVRfUkVQT1JU
LCAwLCAwLCA3KSkNCiAJCXJldHVybiAtMTsNCi0JfQ0KLQ0KLQlmaWVsZCA9IHJlcG9ydC0+Zmll
bGRbMF07DQotCWlmICghZmllbGQpIHsNCi0JCWhpZF9lcnIoaGlkLCAiTlVMTCBmaWVsZFxuIik7
DQotCQlyZXR1cm4gLTE7DQotCX0NCiANCiAJLyogQ2hlY2sgd2hhdCB3aGVlbCBoYXMgYmVlbiBj
b25uZWN0ZWQgKi8NCiAJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUobGc0ZmZfZGV2aWNlcyk7
IGkrKykgew0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaGlkL2hpZC1sZ2ZmLmMgYi9kcml2ZXJzL2hp
ZC9oaWQtbGdmZi5jDQppbmRleCAyN2JjNTRmLi4xZDk3OGRhYSAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvaGlkL2hpZC1sZ2ZmLmMNCisrKyBiL2RyaXZlcnMvaGlkL2hpZC1sZ2ZmLmMNCkBAIC0xMzAs
MjcgKzEzMCwxNCBAQCBzdGF0aWMgdm9pZCBoaWRfbGdmZl9zZXRfYXV0b2NlbnRlcihzdHJ1Y3Qg
aW5wdXRfZGV2ICpkZXYsIHUxNiBtYWduaXR1ZGUpDQogaW50IGxnZmZfaW5pdChzdHJ1Y3QgaGlk
X2RldmljZSogaGlkKQ0KIHsNCiAJc3RydWN0IGhpZF9pbnB1dCAqaGlkaW5wdXQgPSBsaXN0X2Vu
dHJ5KGhpZC0+aW5wdXRzLm5leHQsIHN0cnVjdCBoaWRfaW5wdXQsIGxpc3QpOw0KLQlzdHJ1Y3Qg
bGlzdF9oZWFkICpyZXBvcnRfbGlzdCA9ICZoaWQtPnJlcG9ydF9lbnVtW0hJRF9PVVRQVVRfUkVQ
T1JUXS5yZXBvcnRfbGlzdDsNCiAJc3RydWN0IGlucHV0X2RldiAqZGV2ID0gaGlkaW5wdXQtPmlu
cHV0Ow0KLQlzdHJ1Y3QgaGlkX3JlcG9ydCAqcmVwb3J0Ow0KLQlzdHJ1Y3QgaGlkX2ZpZWxkICpm
aWVsZDsNCiAJY29uc3Qgc2lnbmVkIHNob3J0ICpmZl9iaXRzID0gZmZfam95c3RpY2s7DQogCWlu
dCBlcnJvcjsNCiAJaW50IGk7DQogDQotCS8qIEZpbmQgdGhlIHJlcG9ydCB0byB1c2UgKi8NCi0J
aWYgKGxpc3RfZW1wdHkocmVwb3J0X2xpc3QpKSB7DQotCQloaWRfZXJyKGhpZCwgIk5vIG91dHB1
dCByZXBvcnQgZm91bmRcbiIpOw0KLQkJcmV0dXJuIC0xOw0KLQl9DQotDQogCS8qIENoZWNrIHRo
YXQgdGhlIHJlcG9ydCBsb29rcyBvayAqLw0KLQlyZXBvcnQgPSBsaXN0X2VudHJ5KHJlcG9ydF9s
aXN0LT5uZXh0LCBzdHJ1Y3QgaGlkX3JlcG9ydCwgbGlzdCk7DQotCWZpZWxkID0gcmVwb3J0LT5m
aWVsZFswXTsNCi0JaWYgKCFmaWVsZCkgew0KLQkJaGlkX2VycihoaWQsICJOVUxMIGZpZWxkXG4i
KTsNCi0JCXJldHVybiAtMTsNCi0JfQ0KKwlpZiAoIWhpZF92YWxpZGF0ZV92YWx1ZXMoaGlkLCBI
SURfT1VUUFVUX1JFUE9SVCwgMCwgMCwgNykpDQorCQlyZXR1cm4gLUVOT0RFVjsNCiANCiAJZm9y
IChpID0gMDsgaSA8IEFSUkFZX1NJWkUoZGV2aWNlcyk7IGkrKykgew0KIAkJaWYgKGRldi0+aWQu
dmVuZG9yID09IGRldmljZXNbaV0uaWRWZW5kb3IgJiYNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2hp
ZC9oaWQtbG9naXRlY2gtZGouYyBiL2RyaXZlcnMvaGlkL2hpZC1sb2dpdGVjaC1kai5jDQppbmRl
eCA4ODIxZWNjLi44MjhhMGRkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9oaWQvaGlkLWxvZ2l0ZWNo
LWRqLmMNCisrKyBiL2RyaXZlcnMvaGlkL2hpZC1sb2dpdGVjaC1kai5jDQpAQCAtNzkxLDYgKzc5
MSwxMiBAQCBzdGF0aWMgaW50IGxvZ2lfZGpfcHJvYmUoc3RydWN0IGhpZF9kZXZpY2UgKmhkZXYs
DQogCQlnb3RvIGhpZF9wYXJzZV9mYWlsOw0KIAl9DQogDQorCWlmICghaGlkX3ZhbGlkYXRlX3Zh
bHVlcyhoZGV2LCBISURfT1VUUFVUX1JFUE9SVCwgUkVQT1JUX0lEX0RKX1NIT1JULA0KKwkJCQkg
MCwgREpSRVBPUlRfU0hPUlRfTEVOR1RIIC0gMSkpIHsNCisJCXJldHZhbCA9IC1FTk9ERVY7DQor
CQlnb3RvIGhpZF9wYXJzZV9mYWlsOw0KKwl9DQorDQogCS8qIFN0YXJ0cyB0aGUgdXNiIGRldmlj
ZSBhbmQgY29ubmVjdHMgdG8gdXBwZXIgaW50ZXJmYWNlcyBoaWRkZXYgYW5kDQogCSAqIGhpZHJh
dyAqLw0KIAlyZXR2YWwgPSBoaWRfaHdfc3RhcnQoaGRldiwgSElEX0NPTk5FQ1RfREVGQVVMVCk7
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9oaWQvaGlkLW50cmlnLmMgYi9kcml2ZXJzL2hpZC9oaWQt
bnRyaWcuYw0KaW5kZXggOWZhZTJlYi4uNDhjYmE4NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaGlk
L2hpZC1udHJpZy5jDQorKysgYi9kcml2ZXJzL2hpZC9oaWQtbnRyaWcuYw0KQEAgLTExNSw3ICsx
MTUsOCBAQCBzdGF0aWMgaW5saW5lIGludCBudHJpZ19nZXRfbW9kZShzdHJ1Y3QgaGlkX2Rldmlj
ZSAqaGRldikNCiAJc3RydWN0IGhpZF9yZXBvcnQgKnJlcG9ydCA9IGhkZXYtPnJlcG9ydF9lbnVt
W0hJRF9GRUFUVVJFX1JFUE9SVF0uDQogCQkJCSAgICByZXBvcnRfaWRfaGFzaFsweDBkXTsNCiAN
Ci0JaWYgKCFyZXBvcnQpDQorCWlmICghcmVwb3J0IHx8IHJlcG9ydC0+bWF4ZmllbGQgPCAxIHx8
DQorCSAgICByZXBvcnQtPmZpZWxkWzBdLT5yZXBvcnRfY291bnQgPCAxKQ0KIAkJcmV0dXJuIC1F
SU5WQUw7DQogDQogCXVzYmhpZF9zdWJtaXRfcmVwb3J0KGhkZXYsIHJlcG9ydCwgVVNCX0RJUl9J
Tik7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9oaWQvaGlkLXBpY29sY2QuYyBiL2RyaXZlcnMvaGlk
L2hpZC1waWNvbGNkLmMNCmluZGV4IDAxZTdkMmMuLjFkYWVhY2EgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL2hpZC9oaWQtcGljb2xjZC5jDQorKysgYi9kcml2ZXJzL2hpZC9oaWQtcGljb2xjZC5jDQpA
QCAtMTQyNCw3ICsxNDI0LDcgQEAgc3RhdGljIHNzaXplX3QgcGljb2xjZF9vcGVyYXRpb25fbW9k
ZV9zdG9yZShzdHJ1Y3QgZGV2aWNlICpkZXYsDQogCQlidWYgKz0gMTA7DQogCQljbnQgLT0gMTA7
DQogCX0NCi0JaWYgKCFyZXBvcnQpDQorCWlmICghcmVwb3J0IHx8IHJlcG9ydC0+bWF4ZmllbGQg
IT0gMSkNCiAJCXJldHVybiAtRUlOVkFMOw0KIA0KIAl3aGlsZSAoY250ID4gMCAmJiAoYnVmW2Nu
dC0xXSA9PSAnXG4nIHx8IGJ1ZltjbnQtMV0gPT0gJ1xyJykpDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9oaWQvaGlkLXBsLmMgYi9kcml2ZXJzL2hpZC9oaWQtcGwuYw0KaW5kZXggMDcwZjkzYS4uMTI3
ODZjZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaGlkL2hpZC1wbC5jDQorKysgYi9kcml2ZXJzL2hp
ZC9oaWQtcGwuYw0KQEAgLTEyOSw4ICsxMjksMTQgQEAgc3RhdGljIGludCBwbGZmX2luaXQoc3Ry
dWN0IGhpZF9kZXZpY2UgKmhpZCkNCiAJCQlzdHJvbmcgPSAmcmVwb3J0LT5maWVsZFswXS0+dmFs
dWVbMl07DQogCQkJd2VhayA9ICZyZXBvcnQtPmZpZWxkWzBdLT52YWx1ZVszXTsNCiAJCQlkZWJ1
ZygiZGV0ZWN0ZWQgc2luZ2xlLWZpZWxkIGRldmljZSIpOw0KLQkJfSBlbHNlIGlmIChyZXBvcnQt
Pm1heGZpZWxkID49IDQgJiYgcmVwb3J0LT5maWVsZFswXS0+bWF4dXNhZ2UgPT0gMSAmJg0KLQkJ
CQlyZXBvcnQtPmZpZWxkWzBdLT51c2FnZVswXS5oaWQgPT0gKEhJRF9VUF9MRUQgfCAweDQzKSkg
ew0KKwkJfSBlbHNlIGlmIChyZXBvcnQtPmZpZWxkWzBdLT5tYXh1c2FnZSA9PSAxICYmDQorCQkJ
ICAgcmVwb3J0LT5maWVsZFswXS0+dXNhZ2VbMF0uaGlkID09DQorCQkJCShISURfVVBfTEVEIHwg
MHg0MykgJiYNCisJCQkgICByZXBvcnQtPm1heGZpZWxkID49IDQgJiYNCisJCQkgICByZXBvcnQt
PmZpZWxkWzBdLT5yZXBvcnRfY291bnQgPj0gMSAmJg0KKwkJCSAgIHJlcG9ydC0+ZmllbGRbMV0t
PnJlcG9ydF9jb3VudCA+PSAxICYmDQorCQkJICAgcmVwb3J0LT5maWVsZFsyXS0+cmVwb3J0X2Nv
dW50ID49IDEgJiYNCisJCQkgICByZXBvcnQtPmZpZWxkWzNdLT5yZXBvcnRfY291bnQgPj0gMSkg
ew0KIAkJCXJlcG9ydC0+ZmllbGRbMF0tPnZhbHVlWzBdID0gMHgwMDsNCiAJCQlyZXBvcnQtPmZp
ZWxkWzFdLT52YWx1ZVswXSA9IDB4MDA7DQogCQkJc3Ryb25nID0gJnJlcG9ydC0+ZmllbGRbMl0t
PnZhbHVlWzBdOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaGlkL2hpZC1zcGVlZGxpbmsuYyBiL2Ry
aXZlcnMvaGlkL2hpZC1zcGVlZGxpbmsuYw0KaW5kZXggNjAyMDEzNy4uMmIwM2M5YiAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvaGlkL2hpZC1zcGVlZGxpbmsuYw0KKysrIGIvZHJpdmVycy9oaWQvaGlk
LXNwZWVkbGluay5jDQpAQCAtMyw3ICszLDcgQEANCiAgKiAgRml4ZXMgImp1bXB5IiBjdXJzb3Ig
YW5kIHJlbW92ZXMgbm9uZXhpc3RlbnQga2V5Ym9hcmQgTEVEUyBmcm9tDQogICogIHRoZSBISUQg
ZGVzY3JpcHRvci4NCiAgKg0KLSAqICBDb3B5cmlnaHQgKGMpIDIwMTEgU3RlZmFuIEtyaXdhbmVr
IDxtYWlsQHN0ZWZhbmtyaXdhbmVrLmRlPg0KKyAqICBDb3B5cmlnaHQgKGMpIDIwMTEsIDIwMTMg
U3RlZmFuIEtyaXdhbmVrIDxkZXZAc3RlZmFua3Jpd2FuZWsuZGU+DQogICovDQogDQogLyoNCkBA
IC00OCw4ICs0OCwxMyBAQCBzdGF0aWMgaW50IHNwZWVkbGlua19ldmVudChzdHJ1Y3QgaGlkX2Rl
dmljZSAqaGRldiwgc3RydWN0IGhpZF9maWVsZCAqZmllbGQsDQogCQlzdHJ1Y3QgaGlkX3VzYWdl
ICp1c2FnZSwgX19zMzIgdmFsdWUpDQogew0KIAkvKiBObyBvdGhlciBjb25kaXRpb25zIGR1ZSB0
byB1c2FnZV90YWJsZS4gKi8NCi0JLyogRml4ICJqdW1weSIgY3Vyc29yIChpbnZhbGlkIGV2ZW50
cyBzZW50IGJ5IGRldmljZSkuICovDQotCWlmICh2YWx1ZSA9PSAyNTYpDQorDQorCS8qIFRoaXMg
Zml4ZXMgdGhlICJqdW1weSIgY3Vyc29yIG9jY3VyaW5nIGR1ZSB0byBpbnZhbGlkIGV2ZW50cyBz
ZW50DQorCSAqIGJ5IHRoZSBkZXZpY2UuIFNvbWUgZGV2aWNlcyBvbmx5IHNlbmQgdGhlbSB3aXRo
IHZhbHVlPT0rMjU2LCBvdGhlcnMNCisJICogZG9uJ3QuIEhvd2V2ZXIsIGNhdGNoaW5nIGFicyh2
YWx1ZSk+PTI1NiBpcyByZXN0cmljdGl2ZSBlbm91Z2ggbm90DQorCSAqIHRvIGludGVyZmVyZSB3
aXRoIGRldmljZXMgdGhhdCB3ZXJlIGJ1Zy1mcmVlIChoYXMgYmVlbiB0ZXN0ZWQpLg0KKwkgKi8N
CisJaWYgKGFicyh2YWx1ZSkgPj0gMjU2KQ0KIAkJcmV0dXJuIDE7DQogCS8qIERyb3AgdXNlbGVz
cyBkaXN0YW5jZSAwIGV2ZW50cyAob24gYnV0dG9uIGNsaWNrcyBldGMuKSBhcyB3ZWxsICovDQog
CWlmICh2YWx1ZSA9PSAwKQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaGlkL2hpZC16cGZmLmMgYi9k
cml2ZXJzL2hpZC9oaWQtenBmZi5jDQppbmRleCBmNmJhODFkLi5mMzQ4ZjdmIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9oaWQvaGlkLXpwZmYuYw0KKysrIGIvZHJpdmVycy9oaWQvaGlkLXpwZmYuYw0K
QEAgLTcwLDIxICs3MCwxMyBAQCBzdGF0aWMgaW50IHpwZmZfaW5pdChzdHJ1Y3QgaGlkX2Rldmlj
ZSAqaGlkKQ0KIAlzdHJ1Y3QgaGlkX3JlcG9ydCAqcmVwb3J0Ow0KIAlzdHJ1Y3QgaGlkX2lucHV0
ICpoaWRpbnB1dCA9IGxpc3RfZW50cnkoaGlkLT5pbnB1dHMubmV4dCwNCiAJCQkJCQlzdHJ1Y3Qg
aGlkX2lucHV0LCBsaXN0KTsNCi0Jc3RydWN0IGxpc3RfaGVhZCAqcmVwb3J0X2xpc3QgPQ0KLQkJ
CSZoaWQtPnJlcG9ydF9lbnVtW0hJRF9PVVRQVVRfUkVQT1JUXS5yZXBvcnRfbGlzdDsNCiAJc3Ry
dWN0IGlucHV0X2RldiAqZGV2ID0gaGlkaW5wdXQtPmlucHV0Ow0KLQlpbnQgZXJyb3I7DQorCWlu
dCBpLCBlcnJvcjsNCiANCi0JaWYgKGxpc3RfZW1wdHkocmVwb3J0X2xpc3QpKSB7DQotCQloaWRf
ZXJyKGhpZCwgIm5vIG91dHB1dCByZXBvcnQgZm91bmRcbiIpOw0KLQkJcmV0dXJuIC1FTk9ERVY7
DQotCX0NCi0NCi0JcmVwb3J0ID0gbGlzdF9lbnRyeShyZXBvcnRfbGlzdC0+bmV4dCwgc3RydWN0
IGhpZF9yZXBvcnQsIGxpc3QpOw0KLQ0KLQlpZiAocmVwb3J0LT5tYXhmaWVsZCA8IDQpIHsNCi0J
CWhpZF9lcnIoaGlkLCAibm90IGVub3VnaCBmaWVsZHMgaW4gcmVwb3J0XG4iKTsNCi0JCXJldHVy
biAtRU5PREVWOw0KKwlmb3IgKGkgPSAwOyBpIDwgNDsgaSsrKSB7DQorCQlyZXBvcnQgPSBoaWRf
dmFsaWRhdGVfdmFsdWVzKGhpZCwgSElEX09VVFBVVF9SRVBPUlQsIDAsIGksIDEpOw0KKwkJaWYg
KCFyZXBvcnQpDQorCQkJcmV0dXJuIC1FTk9ERVY7DQogCX0NCiANCiAJenBmZiA9IGt6YWxsb2Mo
c2l6ZW9mKHN0cnVjdCB6cGZmX2RldmljZSksIEdGUF9LRVJORUwpOw0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvaGlkL2hpZHJhdy5jIGIvZHJpdmVycy9oaWQvaGlkcmF3LmMNCmluZGV4IDE3ZDE1YmIu
LjllNTBmNjEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2hpZC9oaWRyYXcuYw0KKysrIGIvZHJpdmVy
cy9oaWQvaGlkcmF3LmMNCkBAIC00Miw3ICs0Miw2IEBAIHN0YXRpYyBzdHJ1Y3QgY2RldiBoaWRy
YXdfY2RldjsNCiBzdGF0aWMgc3RydWN0IGNsYXNzICpoaWRyYXdfY2xhc3M7DQogc3RhdGljIHN0
cnVjdCBoaWRyYXcgKmhpZHJhd190YWJsZVtISURSQVdfTUFYX0RFVklDRVNdOw0KIHN0YXRpYyBE
RUZJTkVfTVVURVgobWlub3JzX2xvY2spOw0KLXN0YXRpYyB2b2lkIGRyb3BfcmVmKHN0cnVjdCBo
aWRyYXcgKmhpZCwgaW50IGV4aXN0c19iaXQpOw0KIA0KIHN0YXRpYyBzc2l6ZV90IGhpZHJhd19y
ZWFkKHN0cnVjdCBmaWxlICpmaWxlLCBjaGFyIF9fdXNlciAqYnVmZmVyLCBzaXplX3QgY291bnQs
IGxvZmZfdCAqcHBvcykNCiB7DQpAQCAtMjk2LDE0ICsyOTUsMzcgQEAgb3V0Og0KIA0KIH0NCiAN
CitzdGF0aWMgdm9pZCBkcm9wX3JlZihzdHJ1Y3QgaGlkcmF3ICpoaWRyYXcsIGludCBleGlzdHNf
Yml0KQ0KK3sNCisJaWYgKGV4aXN0c19iaXQpIHsNCisJCWhpZF9od19jbG9zZShoaWRyYXctPmhp
ZCk7DQorCQloaWRyYXctPmV4aXN0ID0gMDsNCisJCWlmIChoaWRyYXctPm9wZW4pDQorCQkJd2Fr
ZV91cF9pbnRlcnJ1cHRpYmxlKCZoaWRyYXctPndhaXQpOw0KKwl9IGVsc2Ugew0KKwkJLS1oaWRy
YXctPm9wZW47DQorCX0NCisNCisJaWYgKCFoaWRyYXctPm9wZW4gJiYgIWhpZHJhdy0+ZXhpc3Qp
IHsNCisJCWRldmljZV9kZXN0cm95KGhpZHJhd19jbGFzcywgTUtERVYoaGlkcmF3X21ham9yLCBo
aWRyYXctPm1pbm9yKSk7DQorCQloaWRyYXdfdGFibGVbaGlkcmF3LT5taW5vcl0gPSBOVUxMOw0K
KwkJa2ZyZWUoaGlkcmF3KTsNCisJfQ0KK30NCisNCiBzdGF0aWMgaW50IGhpZHJhd19yZWxlYXNl
KHN0cnVjdCBpbm9kZSAqIGlub2RlLCBzdHJ1Y3QgZmlsZSAqIGZpbGUpDQogew0KIAl1bnNpZ25l
ZCBpbnQgbWlub3IgPSBpbWlub3IoaW5vZGUpOw0KIAlzdHJ1Y3QgaGlkcmF3X2xpc3QgKmxpc3Qg
PSBmaWxlLT5wcml2YXRlX2RhdGE7DQogDQotCWRyb3BfcmVmKGhpZHJhd190YWJsZVttaW5vcl0s
IDApOw0KKwltdXRleF9sb2NrKCZtaW5vcnNfbG9jayk7DQorDQogCWxpc3RfZGVsKCZsaXN0LT5u
b2RlKTsNCiAJa2ZyZWUobGlzdCk7DQorDQorCWRyb3BfcmVmKGhpZHJhd190YWJsZVttaW5vcl0s
IDApOw0KKw0KKwltdXRleF91bmxvY2soJm1pbm9yc19sb2NrKTsNCiAJcmV0dXJuIDA7DQogfQ0K
IA0KQEAgLTUwNiw3ICs1MjgsMTIgQEAgRVhQT1JUX1NZTUJPTF9HUEwoaGlkcmF3X2Nvbm5lY3Qp
Ow0KIHZvaWQgaGlkcmF3X2Rpc2Nvbm5lY3Qoc3RydWN0IGhpZF9kZXZpY2UgKmhpZCkNCiB7DQog
CXN0cnVjdCBoaWRyYXcgKmhpZHJhdyA9IGhpZC0+aGlkcmF3Ow0KKw0KKwltdXRleF9sb2NrKCZt
aW5vcnNfbG9jayk7DQorDQogCWRyb3BfcmVmKGhpZHJhdywgMSk7DQorDQorCW11dGV4X3VubG9j
aygmbWlub3JzX2xvY2spOw0KIH0NCiBFWFBPUlRfU1lNQk9MX0dQTChoaWRyYXdfZGlzY29ubmVj
dCk7DQogDQpAQCAtNTU1LDIzICs1ODIsMyBAQCB2b2lkIGhpZHJhd19leGl0KHZvaWQpDQogCXVu
cmVnaXN0ZXJfY2hyZGV2X3JlZ2lvbihkZXZfaWQsIEhJRFJBV19NQVhfREVWSUNFUyk7DQogDQog
fQ0KLQ0KLXN0YXRpYyB2b2lkIGRyb3BfcmVmKHN0cnVjdCBoaWRyYXcgKmhpZHJhdywgaW50IGV4
aXN0c19iaXQpDQotew0KLQltdXRleF9sb2NrKCZtaW5vcnNfbG9jayk7DQotCWlmIChleGlzdHNf
Yml0KSB7DQotCQloaWRfaHdfY2xvc2UoaGlkcmF3LT5oaWQpOw0KLQkJaGlkcmF3LT5leGlzdCA9
IDA7DQotCQlpZiAoaGlkcmF3LT5vcGVuKQ0KLQkJCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmaGlk
cmF3LT53YWl0KTsNCi0JfSBlbHNlIHsNCi0JCS0taGlkcmF3LT5vcGVuOw0KLQl9DQotDQotCWlm
ICghaGlkcmF3LT5vcGVuICYmICFoaWRyYXctPmV4aXN0KSB7DQotCQlkZXZpY2VfZGVzdHJveSho
aWRyYXdfY2xhc3MsIE1LREVWKGhpZHJhd19tYWpvciwgaGlkcmF3LT5taW5vcikpOw0KLQkJaGlk
cmF3X3RhYmxlW2hpZHJhdy0+bWlub3JdID0gTlVMTDsNCi0JCWtmcmVlKGhpZHJhdyk7DQotCX0N
Ci0JbXV0ZXhfdW5sb2NrKCZtaW5vcnNfbG9jayk7DQotfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
aGlkL3VzYmhpZC9oaWQtcXVpcmtzLmMgYi9kcml2ZXJzL2hpZC91c2JoaWQvaGlkLXF1aXJrcy5j
DQppbmRleCA5NmExZTBmLi5mOThmYmFkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9oaWQvdXNiaGlk
L2hpZC1xdWlya3MuYw0KKysrIGIvZHJpdmVycy9oaWQvdXNiaGlkL2hpZC1xdWlya3MuYw0KQEAg
LTk5LDYgKzk5LDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBoaWRfYmxhY2tsaXN0IHsNCiAJeyBV
U0JfVkVORE9SX0lEX0NISUNPTlksIFVTQl9ERVZJQ0VfSURfQ0hJQ09OWV9NVUxUSV9UT1VDSCwg
SElEX1FVSVJLX01VTFRJX0lOUFVUIH0sDQogCXsgVVNCX1ZFTkRPUl9JRF9DSElDT05ZLCBVU0Jf
REVWSUNFX0lEX0NISUNPTllfV0lSRUxFU1MsIEhJRF9RVUlSS19NVUxUSV9JTlBVVCB9LA0KIAl7
IFVTQl9WRU5ET1JfSURfU0lHTUFfTUlDUk8sIFVTQl9ERVZJQ0VfSURfU0lHTUFfTUlDUk9fS0VZ
Qk9BUkQsIEhJRF9RVUlSS19OT19JTklUX1JFUE9SVFMgfSwNCisJeyBVU0JfVkVORE9SX0lEX05U
UklHLCBVU0JfREVWSUNFX0lEX05UUklHX0RVT1NFTlNFLCBISURfUVVJUktfTk9fSU5JVF9SRVBP
UlRTIH0sDQorDQogCXsgMCwgMCB9DQogfTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2h3bW9u
L2FwcGxlc21jLmMgYi9kcml2ZXJzL2h3bW9uL2FwcGxlc21jLmMNCmluZGV4IGQ5OWFhODQuLjMw
Y2FjNTggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2h3bW9uL2FwcGxlc21jLmMNCisrKyBiL2RyaXZl
cnMvaHdtb24vYXBwbGVzbWMuYw0KQEAgLTM0NCw4ICszNDQsMTAgQEAgc3RhdGljIGludCBhcHBs
ZXNtY19nZXRfbG93ZXJfYm91bmQodW5zaWduZWQgaW50ICpsbywgY29uc3QgY2hhciAqa2V5KQ0K
IAl3aGlsZSAoYmVnaW4gIT0gZW5kKSB7DQogCQlpbnQgbWlkZGxlID0gYmVnaW4gKyAoZW5kIC0g
YmVnaW4pIC8gMjsNCiAJCWVudHJ5ID0gYXBwbGVzbWNfZ2V0X2VudHJ5X2J5X2luZGV4KG1pZGRs
ZSk7DQotCQlpZiAoSVNfRVJSKGVudHJ5KSkNCisJCWlmIChJU19FUlIoZW50cnkpKSB7DQorCQkJ
KmxvID0gMDsNCiAJCQlyZXR1cm4gUFRSX0VSUihlbnRyeSk7DQorCQl9DQogCQlpZiAoc3RyY21w
KGVudHJ5LT5rZXksIGtleSkgPCAwKQ0KIAkJCWJlZ2luID0gbWlkZGxlICsgMTsNCiAJCWVsc2UN
CkBAIC0zNjQsOCArMzY2LDEwIEBAIHN0YXRpYyBpbnQgYXBwbGVzbWNfZ2V0X3VwcGVyX2JvdW5k
KHVuc2lnbmVkIGludCAqaGksIGNvbnN0IGNoYXIgKmtleSkNCiAJd2hpbGUgKGJlZ2luICE9IGVu
ZCkgew0KIAkJaW50IG1pZGRsZSA9IGJlZ2luICsgKGVuZCAtIGJlZ2luKSAvIDI7DQogCQllbnRy
eSA9IGFwcGxlc21jX2dldF9lbnRyeV9ieV9pbmRleChtaWRkbGUpOw0KLQkJaWYgKElTX0VSUihl
bnRyeSkpDQorCQlpZiAoSVNfRVJSKGVudHJ5KSkgew0KKwkJCSpoaSA9IHNtY3JlZy5rZXlfY291
bnQ7DQogCQkJcmV0dXJuIFBUUl9FUlIoZW50cnkpOw0KKwkJfQ0KIAkJaWYgKHN0cmNtcChrZXks
IGVudHJ5LT5rZXkpIDwgMCkNCiAJCQllbmQgPSBtaWRkbGU7DQogCQllbHNlDQpAQCAtNDg1LDE2
ICs0ODksMjUgQEAgc3RhdGljIGludCBhcHBsZXNtY19pbml0X3NtY3JlZ190cnkodm9pZCkNCiB7
DQogCXN0cnVjdCBhcHBsZXNtY19yZWdpc3RlcnMgKnMgPSAmc21jcmVnOw0KIAlib29sIGxlZnRf
bGlnaHRfc2Vuc29yLCByaWdodF9saWdodF9zZW5zb3I7DQorCXVuc2lnbmVkIGludCBjb3VudDsN
CiAJdTggdG1wWzFdOw0KIAlpbnQgcmV0Ow0KIA0KIAlpZiAocy0+aW5pdF9jb21wbGV0ZSkNCiAJ
CXJldHVybiAwOw0KIA0KLQlyZXQgPSByZWFkX3JlZ2lzdGVyX2NvdW50KCZzLT5rZXlfY291bnQp
Ow0KKwlyZXQgPSByZWFkX3JlZ2lzdGVyX2NvdW50KCZjb3VudCk7DQogCWlmIChyZXQpDQogCQly
ZXR1cm4gcmV0Ow0KIA0KKwlpZiAocy0+Y2FjaGUgJiYgcy0+a2V5X2NvdW50ICE9IGNvdW50KSB7
DQorCQlwcl93YXJuKCJrZXkgY291bnQgY2hhbmdlZCBmcm9tICVkIHRvICVkXG4iLA0KKwkJCXMt
PmtleV9jb3VudCwgY291bnQpOw0KKwkJa2ZyZWUocy0+Y2FjaGUpOw0KKwkJcy0+Y2FjaGUgPSBO
VUxMOw0KKwl9DQorCXMtPmtleV9jb3VudCA9IGNvdW50Ow0KKw0KIAlpZiAoIXMtPmNhY2hlKQ0K
IAkJcy0+Y2FjaGUgPSBrY2FsbG9jKHMtPmtleV9jb3VudCwgc2l6ZW9mKCpzLT5jYWNoZSksIEdG
UF9LRVJORUwpOw0KIAlpZiAoIXMtPmNhY2hlKQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUv
aW50ZWwtaW9tbXUuYyBiL2RyaXZlcnMvaW9tbXUvaW50ZWwtaW9tbXUuYw0KaW5kZXggZjQ0YTA2
Ny4uYjRhNGFhZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaW9tbXUvaW50ZWwtaW9tbXUuYw0KKysr
IGIvZHJpdmVycy9pb21tdS9pbnRlbC1pb21tdS5jDQpAQCAtODYxLDU2ICs4NjEsNTQgQEAgc3Rh
dGljIGludCBkbWFfcHRlX2NsZWFyX3JhbmdlKHN0cnVjdCBkbWFyX2RvbWFpbiAqZG9tYWluLA0K
IAlyZXR1cm4gb3JkZXI7DQogfQ0KIA0KK3N0YXRpYyB2b2lkIGRtYV9wdGVfZnJlZV9sZXZlbChz
dHJ1Y3QgZG1hcl9kb21haW4gKmRvbWFpbiwgaW50IGxldmVsLA0KKwkJCSAgICAgICBzdHJ1Y3Qg
ZG1hX3B0ZSAqcHRlLCB1bnNpZ25lZCBsb25nIHBmbiwNCisJCQkgICAgICAgdW5zaWduZWQgbG9u
ZyBzdGFydF9wZm4sIHVuc2lnbmVkIGxvbmcgbGFzdF9wZm4pDQorew0KKwlwZm4gPSBtYXgoc3Rh
cnRfcGZuLCBwZm4pOw0KKwlwdGUgPSAmcHRlW3Bmbl9sZXZlbF9vZmZzZXQocGZuLCBsZXZlbCld
Ow0KKw0KKwlkbyB7DQorCQl1bnNpZ25lZCBsb25nIGxldmVsX3BmbjsNCisJCXN0cnVjdCBkbWFf
cHRlICpsZXZlbF9wdGU7DQorDQorCQlpZiAoIWRtYV9wdGVfcHJlc2VudChwdGUpIHx8IGRtYV9w
dGVfc3VwZXJwYWdlKHB0ZSkpDQorCQkJZ290byBuZXh0Ow0KKw0KKwkJbGV2ZWxfcGZuID0gcGZu
ICYgbGV2ZWxfbWFzayhsZXZlbCAtIDEpOw0KKwkJbGV2ZWxfcHRlID0gcGh5c190b192aXJ0KGRt
YV9wdGVfYWRkcihwdGUpKTsNCisNCisJCWlmIChsZXZlbCA+IDIpDQorCQkJZG1hX3B0ZV9mcmVl
X2xldmVsKGRvbWFpbiwgbGV2ZWwgLSAxLCBsZXZlbF9wdGUsDQorCQkJCQkgICBsZXZlbF9wZm4s
IHN0YXJ0X3BmbiwgbGFzdF9wZm4pOw0KKw0KKwkJLyogSWYgcmFuZ2UgY292ZXJzIGVudGlyZSBw
YWdldGFibGUsIGZyZWUgaXQgKi8NCisJCWlmICghKHN0YXJ0X3BmbiA+IGxldmVsX3BmbiB8fA0K
KwkJICAgICAgbGFzdF9wZm4gPCBsZXZlbF9wZm4gKyBsZXZlbF9zaXplKGxldmVsKSkpIHsNCisJ
CQlkbWFfY2xlYXJfcHRlKHB0ZSk7DQorCQkJZG9tYWluX2ZsdXNoX2NhY2hlKGRvbWFpbiwgcHRl
LCBzaXplb2YoKnB0ZSkpOw0KKwkJCWZyZWVfcGd0YWJsZV9wYWdlKGxldmVsX3B0ZSk7DQorCQl9
DQorbmV4dDoNCisJCXBmbiArPSBsZXZlbF9zaXplKGxldmVsKTsNCisJfSB3aGlsZSAoIWZpcnN0
X3B0ZV9pbl9wYWdlKCsrcHRlKSAmJiBwZm4gPD0gbGFzdF9wZm4pOw0KK30NCisNCiAvKiBmcmVl
IHBhZ2UgdGFibGUgcGFnZXMuIGxhc3QgbGV2ZWwgcHRlIHNob3VsZCBhbHJlYWR5IGJlIGNsZWFy
ZWQgKi8NCiBzdGF0aWMgdm9pZCBkbWFfcHRlX2ZyZWVfcGFnZXRhYmxlKHN0cnVjdCBkbWFyX2Rv
bWFpbiAqZG9tYWluLA0KIAkJCQkgICB1bnNpZ25lZCBsb25nIHN0YXJ0X3BmbiwNCiAJCQkJICAg
dW5zaWduZWQgbG9uZyBsYXN0X3BmbikNCiB7DQogCWludCBhZGRyX3dpZHRoID0gYWdhd190b193
aWR0aChkb21haW4tPmFnYXcpIC0gVlREX1BBR0VfU0hJRlQ7DQotCXN0cnVjdCBkbWFfcHRlICpm
aXJzdF9wdGUsICpwdGU7DQotCWludCB0b3RhbCA9IGFnYXdfdG9fbGV2ZWwoZG9tYWluLT5hZ2F3
KTsNCi0JaW50IGxldmVsOw0KLQl1bnNpZ25lZCBsb25nIHRtcDsNCi0JaW50IGxhcmdlX3BhZ2Ug
PSAyOw0KIA0KIAlCVUdfT04oYWRkcl93aWR0aCA8IEJJVFNfUEVSX0xPTkcgJiYgc3RhcnRfcGZu
ID4+IGFkZHJfd2lkdGgpOw0KIAlCVUdfT04oYWRkcl93aWR0aCA8IEJJVFNfUEVSX0xPTkcgJiYg
bGFzdF9wZm4gPj4gYWRkcl93aWR0aCk7DQogCUJVR19PTihzdGFydF9wZm4gPiBsYXN0X3Bmbik7
DQogDQogCS8qIFdlIGRvbid0IG5lZWQgbG9jayBoZXJlOyBub2JvZHkgZWxzZSB0b3VjaGVzIHRo
ZSBpb3ZhIHJhbmdlICovDQotCWxldmVsID0gMjsNCi0Jd2hpbGUgKGxldmVsIDw9IHRvdGFsKSB7
DQotCQl0bXAgPSBhbGlnbl90b19sZXZlbChzdGFydF9wZm4sIGxldmVsKTsNCi0NCi0JCS8qIElm
IHdlIGNhbid0IGV2ZW4gY2xlYXIgb25lIFBURSBhdCB0aGlzIGxldmVsLCB3ZSdyZSBkb25lICov
DQotCQlpZiAodG1wICsgbGV2ZWxfc2l6ZShsZXZlbCkgLSAxID4gbGFzdF9wZm4pDQotCQkJcmV0
dXJuOw0KLQ0KLQkJZG8gew0KLQkJCWxhcmdlX3BhZ2UgPSBsZXZlbDsNCi0JCQlmaXJzdF9wdGUg
PSBwdGUgPSBkbWFfcGZuX2xldmVsX3B0ZShkb21haW4sIHRtcCwgbGV2ZWwsICZsYXJnZV9wYWdl
KTsNCi0JCQlpZiAobGFyZ2VfcGFnZSA+IGxldmVsKQ0KLQkJCQlsZXZlbCA9IGxhcmdlX3BhZ2Ug
KyAxOw0KLQkJCWlmICghcHRlKSB7DQotCQkJCXRtcCA9IGFsaWduX3RvX2xldmVsKHRtcCArIDEs
IGxldmVsICsgMSk7DQotCQkJCWNvbnRpbnVlOw0KLQkJCX0NCi0JCQlkbyB7DQotCQkJCWlmIChk
bWFfcHRlX3ByZXNlbnQocHRlKSkgew0KLQkJCQkJZnJlZV9wZ3RhYmxlX3BhZ2UocGh5c190b192
aXJ0KGRtYV9wdGVfYWRkcihwdGUpKSk7DQotCQkJCQlkbWFfY2xlYXJfcHRlKHB0ZSk7DQotCQkJ
CX0NCi0JCQkJcHRlKys7DQotCQkJCXRtcCArPSBsZXZlbF9zaXplKGxldmVsKTsNCi0JCQl9IHdo
aWxlICghZmlyc3RfcHRlX2luX3BhZ2UocHRlKSAmJg0KLQkJCQkgdG1wICsgbGV2ZWxfc2l6ZShs
ZXZlbCkgLSAxIDw9IGxhc3RfcGZuKTsNCisJZG1hX3B0ZV9mcmVlX2xldmVsKGRvbWFpbiwgYWdh
d190b19sZXZlbChkb21haW4tPmFnYXcpLA0KKwkJCSAgIGRvbWFpbi0+cGdkLCAwLCBzdGFydF9w
Zm4sIGxhc3RfcGZuKTsNCiANCi0JCQlkb21haW5fZmx1c2hfY2FjaGUoZG9tYWluLCBmaXJzdF9w
dGUsDQotCQkJCQkgICAodm9pZCAqKXB0ZSAtICh2b2lkICopZmlyc3RfcHRlKTsNCi0JCQkNCi0J
CX0gd2hpbGUgKHRtcCAmJiB0bXAgKyBsZXZlbF9zaXplKGxldmVsKSAtIDEgPD0gbGFzdF9wZm4p
Ow0KLQkJbGV2ZWwrKzsNCi0JfQ0KIAkvKiBmcmVlIHBnZCAqLw0KIAlpZiAoc3RhcnRfcGZuID09
IDAgJiYgbGFzdF9wZm4gPT0gRE9NQUlOX01BWF9QRk4oZG9tYWluLT5nYXcpKSB7DQogCQlmcmVl
X3BndGFibGVfcGFnZShkb21haW4tPnBnZCk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS1z
bmFwLmMgYi9kcml2ZXJzL21kL2RtLXNuYXAuYw0KaW5kZXggYjRhYWE3Yi4uNWMzMDMxNiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbWQvZG0tc25hcC5jDQorKysgYi9kcml2ZXJzL21kL2RtLXNuYXAu
Yw0KQEAgLTcyMSwxNyArNzIxLDE2IEBAIHN0YXRpYyBpbnQgY2FsY19tYXhfYnVja2V0cyh2b2lk
KQ0KICAqLw0KIHN0YXRpYyBpbnQgaW5pdF9oYXNoX3RhYmxlcyhzdHJ1Y3QgZG1fc25hcHNob3Qg
KnMpDQogew0KLQlzZWN0b3JfdCBoYXNoX3NpemUsIGNvd19kZXZfc2l6ZSwgb3JpZ2luX2Rldl9z
aXplLCBtYXhfYnVja2V0czsNCisJc2VjdG9yX3QgaGFzaF9zaXplLCBjb3dfZGV2X3NpemUsIG1h
eF9idWNrZXRzOw0KIA0KIAkvKg0KIAkgKiBDYWxjdWxhdGUgYmFzZWQgb24gdGhlIHNpemUgb2Yg
dGhlIG9yaWdpbmFsIHZvbHVtZSBvcg0KIAkgKiB0aGUgQ09XIHZvbHVtZS4uLg0KIAkgKi8NCiAJ
Y293X2Rldl9zaXplID0gZ2V0X2Rldl9zaXplKHMtPmNvdy0+YmRldik7DQotCW9yaWdpbl9kZXZf
c2l6ZSA9IGdldF9kZXZfc2l6ZShzLT5vcmlnaW4tPmJkZXYpOw0KIAltYXhfYnVja2V0cyA9IGNh
bGNfbWF4X2J1Y2tldHMoKTsNCiANCi0JaGFzaF9zaXplID0gbWluKG9yaWdpbl9kZXZfc2l6ZSwg
Y293X2Rldl9zaXplKSA+PiBzLT5zdG9yZS0+Y2h1bmtfc2hpZnQ7DQorCWhhc2hfc2l6ZSA9IGNv
d19kZXZfc2l6ZSA+PiBzLT5zdG9yZS0+Y2h1bmtfc2hpZnQ7DQogCWhhc2hfc2l6ZSA9IG1pbiho
YXNoX3NpemUsIG1heF9idWNrZXRzKTsNCiANCiAJaWYgKGhhc2hfc2l6ZSA8IDY0KQ0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vaGRwdnIvaGRwdnItY29yZS5jIGIvZHJpdmVycy9t
ZWRpYS92aWRlby9oZHB2ci9oZHB2ci1jb3JlLmMNCmluZGV4IDQ0MWRhY2YuLjA2MDM1M2UgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL21lZGlhL3ZpZGVvL2hkcHZyL2hkcHZyLWNvcmUuYw0KKysrIGIv
ZHJpdmVycy9tZWRpYS92aWRlby9oZHB2ci9oZHB2ci1jb3JlLmMNCkBAIC0yOTcsNiArMjk3LDEx
IEBAIHN0YXRpYyBpbnQgaGRwdnJfcHJvYmUoc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGVyZmFj
ZSwNCiANCiAJZGV2LT53b3JrcXVldWUgPSAwOw0KIA0KKwkvKiBpbml0IHZpZGVvIHRyYW5zZmVy
IHF1ZXVlcyBmaXJzdCBvZiBhbGwgKi8NCisJLyogdG8gcHJldmVudCBvb3BzIGluIGhkcHZyX2Rl
bGV0ZSgpIG9uIGVycm9yIHBhdGhzICovDQorCUlOSVRfTElTVF9IRUFEKCZkZXYtPmZyZWVfYnVm
Zl9saXN0KTsNCisJSU5JVF9MSVNUX0hFQUQoJmRldi0+cmVjX2J1ZmZfbGlzdCk7DQorDQogCS8q
IHJlZ2lzdGVyIHY0bDJfZGV2aWNlIGVhcmx5IHNvIGl0IGNhbiBiZSB1c2VkIGZvciBwcmludGtz
ICovDQogCWlmICh2NGwyX2RldmljZV9yZWdpc3RlcigmaW50ZXJmYWNlLT5kZXYsICZkZXYtPnY0
bDJfZGV2KSkgew0KIAkJZXJyKCJ2NGwyX2RldmljZV9yZWdpc3RlciBmYWlsZWQiKTsNCkBAIC0z
MTksMTAgKzMyNCw2IEBAIHN0YXRpYyBpbnQgaGRwdnJfcHJvYmUoc3RydWN0IHVzYl9pbnRlcmZh
Y2UgKmludGVyZmFjZSwNCiAJaWYgKCFkZXYtPndvcmtxdWV1ZSkNCiAJCWdvdG8gZXJyb3I7DQog
DQotCS8qIGluaXQgdmlkZW8gdHJhbnNmZXIgcXVldWVzICovDQotCUlOSVRfTElTVF9IRUFEKCZk
ZXYtPmZyZWVfYnVmZl9saXN0KTsNCi0JSU5JVF9MSVNUX0hFQUQoJmRldi0+cmVjX2J1ZmZfbGlz
dCk7DQotDQogCWRldi0+b3B0aW9ucyA9IGhkcHZyX2RlZmF1bHRfb3B0aW9uczsNCiANCiAJaWYg
KGRlZmF1bHRfdmlkZW9faW5wdXQgPCBIRFBWUl9WSURFT19JTlBVVFMpDQpAQCAtMzczLDEyICsz
NzQsNiBAQCBzdGF0aWMgaW50IGhkcHZyX3Byb2JlKHN0cnVjdCB1c2JfaW50ZXJmYWNlICppbnRl
cmZhY2UsDQogCX0NCiAJbXV0ZXhfdW5sb2NrKCZkZXYtPmlvX211dGV4KTsNCiANCi0JaWYgKGhk
cHZyX3JlZ2lzdGVyX3ZpZGVvZGV2KGRldiwgJmludGVyZmFjZS0+ZGV2LA0KLQkJCQkgICAgdmlk
ZW9fbnJbYXRvbWljX2luY19yZXR1cm4oJmRldl9ucildKSkgew0KLQkJdjRsMl9lcnIoJmRldi0+
djRsMl9kZXYsICJyZWdpc3RlcmluZyB2aWRlb2RldiBmYWlsZWRcbiIpOw0KLQkJZ290byBlcnJv
cjsNCi0JfQ0KLQ0KICNpZiBkZWZpbmVkKENPTkZJR19JMkMpIHx8IGRlZmluZWQoQ09ORklHX0ky
Q19NT0RVTEUpDQogCXJldHZhbCA9IGhkcHZyX3JlZ2lzdGVyX2kyY19hZGFwdGVyKGRldik7DQog
CWlmIChyZXR2YWwgPCAwKSB7DQpAQCAtMzk5LDYgKzM5NCwxMyBAQCBzdGF0aWMgaW50IGhkcHZy
X3Byb2JlKHN0cnVjdCB1c2JfaW50ZXJmYWNlICppbnRlcmZhY2UsDQogCX0NCiAjZW5kaWYNCiAN
CisJcmV0dmFsID0gaGRwdnJfcmVnaXN0ZXJfdmlkZW9kZXYoZGV2LCAmaW50ZXJmYWNlLT5kZXYs
DQorCQkJCSAgICB2aWRlb19uclthdG9taWNfaW5jX3JldHVybigmZGV2X25yKV0pOw0KKwlpZiAo
cmV0dmFsIDwgMCkgew0KKwkJdjRsMl9lcnIoJmRldi0+djRsMl9kZXYsICJyZWdpc3RlcmluZyB2
aWRlb2RldiBmYWlsZWRcbiIpOw0KKwkJZ290byByZWdfZmFpbDsNCisJfQ0KKw0KIAkvKiBsZXQg
dGhlIHVzZXIga25vdyB3aGF0IG5vZGUgdGhpcyBkZXZpY2UgaXMgbm93IGF0dGFjaGVkIHRvICov
DQogCXY0bDJfaW5mbygmZGV2LT52NGwyX2RldiwgImRldmljZSBub3cgYXR0YWNoZWQgdG8gJXNc
biIsDQogCQkgIHZpZGVvX2RldmljZV9ub2RlX25hbWUoZGV2LT52aWRlb19kZXYpKTsNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL21tYy9ob3N0L3RtaW9fbW1jX2RtYS5jIGIvZHJpdmVycy9tbWMvaG9z
dC90bWlvX21tY19kbWEuYw0KaW5kZXggODZmMjU5Yy4uYmU5ZTc0ZCAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvbW1jL2hvc3QvdG1pb19tbWNfZG1hLmMNCisrKyBiL2RyaXZlcnMvbW1jL2hvc3QvdG1p
b19tbWNfZG1hLmMNCkBAIC05Miw2ICs5Miw3IEBAIHN0YXRpYyB2b2lkIHRtaW9fbW1jX3N0YXJ0
X2RtYV9yeChzdHJ1Y3QgdG1pb19tbWNfaG9zdCAqaG9zdCkNCiBwaW86DQogCWlmICghZGVzYykg
ew0KIAkJLyogRE1BIGZhaWxlZCwgZmFsbCBiYWNrIHRvIFBJTyAqLw0KKwkJdG1pb19tbWNfZW5h
YmxlX2RtYShob3N0LCBmYWxzZSk7DQogCQlpZiAocmV0ID49IDApDQogCQkJcmV0ID0gLUVJTzsN
CiAJCWhvc3QtPmNoYW5fcnggPSBOVUxMOw0KQEAgLTEwNCw3ICsxMDUsNiBAQCBwaW86DQogCQl9
DQogCQlkZXZfd2FybigmaG9zdC0+cGRldi0+ZGV2LA0KIAkJCSAiRE1BIGZhaWxlZDogJWQsIGZh
bGxpbmcgYmFjayB0byBQSU9cbiIsIHJldCk7DQotCQl0bWlvX21tY19lbmFibGVfZG1hKGhvc3Qs
IGZhbHNlKTsNCiAJfQ0KIA0KIAlkZXZfZGJnKCZob3N0LT5wZGV2LT5kZXYsICIlcygpOiBkZXNj
ICVwLCBjb29raWUgJWQsIHNnWyVkXVxuIiwgX19mdW5jX18sDQpAQCAtMTczLDYgKzE3Myw3IEBA
IHN0YXRpYyB2b2lkIHRtaW9fbW1jX3N0YXJ0X2RtYV90eChzdHJ1Y3QgdG1pb19tbWNfaG9zdCAq
aG9zdCkNCiBwaW86DQogCWlmICghZGVzYykgew0KIAkJLyogRE1BIGZhaWxlZCwgZmFsbCBiYWNr
IHRvIFBJTyAqLw0KKwkJdG1pb19tbWNfZW5hYmxlX2RtYShob3N0LCBmYWxzZSk7DQogCQlpZiAo
cmV0ID49IDApDQogCQkJcmV0ID0gLUVJTzsNCiAJCWhvc3QtPmNoYW5fdHggPSBOVUxMOw0KQEAg
LTE4NSw3ICsxODYsNiBAQCBwaW86DQogCQl9DQogCQlkZXZfd2FybigmaG9zdC0+cGRldi0+ZGV2
LA0KIAkJCSAiRE1BIGZhaWxlZDogJWQsIGZhbGxpbmcgYmFjayB0byBQSU9cbiIsIHJldCk7DQot
CQl0bWlvX21tY19lbmFibGVfZG1hKGhvc3QsIGZhbHNlKTsNCiAJfQ0KIA0KIAlkZXZfZGJnKCZo
b3N0LT5wZGV2LT5kZXYsICIlcygpOiBkZXNjICVwLCBjb29raWUgJWRcbiIsIF9fZnVuY19fLA0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMgYi9kcml2ZXJzL25l
dC9ib25kaW5nL2JvbmRfbWFpbi5jDQppbmRleCBiNDM2Yjg0Li4xYmYzNmFjIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX21haW4uYw0KKysrIGIvZHJpdmVycy9uZXQvYm9u
ZGluZy9ib25kX21haW4uYw0KQEAgLTE5MTEsNiArMTkxMSw3IEBAIGludCBib25kX3JlbGVhc2Uo
c3RydWN0IG5ldF9kZXZpY2UgKmJvbmRfZGV2LCBzdHJ1Y3QgbmV0X2RldmljZSAqc2xhdmVfZGV2
KQ0KIAlzdHJ1Y3QgYm9uZGluZyAqYm9uZCA9IG5ldGRldl9wcml2KGJvbmRfZGV2KTsNCiAJc3Ry
dWN0IHNsYXZlICpzbGF2ZSwgKm9sZGN1cnJlbnQ7DQogCXN0cnVjdCBzb2NrYWRkciBhZGRyOw0K
KwlpbnQgb2xkX2ZsYWdzID0gYm9uZF9kZXYtPmZsYWdzOw0KIAl1MzIgb2xkX2ZlYXR1cmVzID0g
Ym9uZF9kZXYtPmZlYXR1cmVzOw0KIA0KIAkvKiBzbGF2ZSBpcyBub3QgYSBzbGF2ZSBvciBtYXN0
ZXIgaXMgbm90IG1hc3RlciBvZiB0aGlzIHNsYXZlICovDQpAQCAtMjA0MSwxMiArMjA0MiwxOCBA
QCBpbnQgYm9uZF9yZWxlYXNlKHN0cnVjdCBuZXRfZGV2aWNlICpib25kX2Rldiwgc3RydWN0IG5l
dF9kZXZpY2UgKnNsYXZlX2RldikNCiAJICogYWxyZWFkeSB0YWtlbiBjYXJlIG9mIGFib3ZlIHdo
ZW4gd2UgZGV0YWNoZWQgdGhlIHNsYXZlDQogCSAqLw0KIAlpZiAoIVVTRVNfUFJJTUFSWShib25k
LT5wYXJhbXMubW9kZSkpIHsNCi0JCS8qIHVuc2V0IHByb21pc2N1aXR5IGxldmVsIGZyb20gc2xh
dmUgKi8NCi0JCWlmIChib25kX2Rldi0+ZmxhZ3MgJiBJRkZfUFJPTUlTQykNCisJCS8qIHVuc2V0
IHByb21pc2N1aXR5IGxldmVsIGZyb20gc2xhdmUNCisJCSAqIE5PVEU6IFRoZSBORVRERVZfQ0hB
TkdFQUREUiBjYWxsIGFib3ZlIG1heSBjaGFuZ2UgdGhlIHZhbHVlDQorCQkgKiBvZiB0aGUgSUZG
X1BST01JU0MgZmxhZyBpbiB0aGUgYm9uZF9kZXYsIGJ1dCB3ZSBuZWVkIHRoZQ0KKwkJICogdmFs
dWUgb2YgdGhhdCBmbGFnIGJlZm9yZSB0aGF0IGNoYW5nZSwgYXMgdGhhdCB3YXMgdGhlIHZhbHVl
DQorCQkgKiB3aGVuIHRoaXMgc2xhdmUgd2FzIGF0dGFjaGVkLCBzbyB3ZSBjYWNoZSBhdCB0aGUg
c3RhcnQgb2YgdGhlDQorCQkgKiBmdW5jdGlvbiBhbmQgdXNlIGl0IGhlcmUuIFNhbWUgZ29lcyBm
b3IgQUxMTVVMVEkgYmVsb3cNCisJCSAqLw0KKwkJaWYgKG9sZF9mbGFncyAmIElGRl9QUk9NSVND
KQ0KIAkJCWRldl9zZXRfcHJvbWlzY3VpdHkoc2xhdmVfZGV2LCAtMSk7DQogDQogCQkvKiB1bnNl
dCBhbGxtdWx0aSBsZXZlbCBmcm9tIHNsYXZlICovDQotCQlpZiAoYm9uZF9kZXYtPmZsYWdzICYg
SUZGX0FMTE1VTFRJKQ0KKwkJaWYgKG9sZF9mbGFncyAmIElGRl9BTExNVUxUSSkNCiAJCQlkZXZf
c2V0X2FsbG11bHRpKHNsYXZlX2RldiwgLTEpOw0KIA0KIAkJLyogZmx1c2ggbWFzdGVyJ3MgbWNf
bGlzdCBmcm9tIHNsYXZlICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4u
YyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCmluZGV4IGU1OWQwMDYuLmJiODI4YzIgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQorKysgYi9kcml2ZXJzL25ldC9j
YW4vZmxleGNhbi5jDQpAQCAtNjAsNyArNjAsNyBAQA0KICNkZWZpbmUgRkxFWENBTl9NQ1JfQkND
CQkJQklUKDE2KQ0KICNkZWZpbmUgRkxFWENBTl9NQ1JfTFBSSU9fRU4JCUJJVCgxMykNCiAjZGVm
aW5lIEZMRVhDQU5fTUNSX0FFTgkJCUJJVCgxMikNCi0jZGVmaW5lIEZMRVhDQU5fTUNSX01BWE1C
KHgpCQkoKHgpICYgMHhmKQ0KKyNkZWZpbmUgRkxFWENBTl9NQ1JfTUFYTUIoeCkJCSgoeCkgJiAw
eDFmKQ0KICNkZWZpbmUgRkxFWENBTl9NQ1JfSURBTV9BCQkoMCA8PCA4KQ0KICNkZWZpbmUgRkxF
WENBTl9NQ1JfSURBTV9CCQkoMSA8PCA4KQ0KICNkZWZpbmUgRkxFWENBTl9NQ1JfSURBTV9DCQko
MiA8PCA4KQ0KQEAgLTY2Niw3ICs2NjYsNiBAQCBzdGF0aWMgaW50IGZsZXhjYW5fY2hpcF9zdGFy
dChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KIHsNCiAJc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJp
diA9IG5ldGRldl9wcml2KGRldik7DQogCXN0cnVjdCBmbGV4Y2FuX3JlZ3MgX19pb21lbSAqcmVn
cyA9IHByaXYtPmJhc2U7DQotCXVuc2lnbmVkIGludCBpOw0KIAlpbnQgZXJyOw0KIAl1MzIgcmVn
X21jciwgcmVnX2N0cmw7DQogDQpAQCAtNzAwLDkgKzY5OSwxMSBAQCBzdGF0aWMgaW50IGZsZXhj
YW5fY2hpcF9zdGFydChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KIAkgKg0KIAkgKi8NCiAJcmVn
X21jciA9IGZsZXhjYW5fcmVhZCgmcmVncy0+bWNyKTsNCisJcmVnX21jciAmPSB+RkxFWENBTl9N
Q1JfTUFYTUIoMHhmZik7DQogCXJlZ19tY3IgfD0gRkxFWENBTl9NQ1JfRlJaIHwgRkxFWENBTl9N
Q1JfRkVOIHwgRkxFWENBTl9NQ1JfSEFMVCB8DQogCQlGTEVYQ0FOX01DUl9TVVBWIHwgRkxFWENB
Tl9NQ1JfV1JOX0VOIHwNCi0JCUZMRVhDQU5fTUNSX0lEQU1fQzsNCisJCUZMRVhDQU5fTUNSX0lE
QU1fQyB8DQorCQlGTEVYQ0FOX01DUl9NQVhNQihGTEVYQ0FOX1RYX0JVRl9JRCk7DQogCWRldl9k
YmcoZGV2LT5kZXYucGFyZW50LCAiJXM6IHdyaXRpbmcgbWNyPTB4JTA4eCIsIF9fZnVuY19fLCBy
ZWdfbWNyKTsNCiAJZmxleGNhbl93cml0ZShyZWdfbWNyLCAmcmVncy0+bWNyKTsNCiANCkBAIC03
MzIsMTYgKzczMyw5IEBAIHN0YXRpYyBpbnQgZmxleGNhbl9jaGlwX3N0YXJ0KHN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYpDQogCWRldl9kYmcoZGV2LT5kZXYucGFyZW50LCAiJXM6IHdyaXRpbmcgY3Ry
bD0weCUwOHgiLCBfX2Z1bmNfXywgcmVnX2N0cmwpOw0KIAlmbGV4Y2FuX3dyaXRlKHJlZ19jdHJs
LCAmcmVncy0+Y3RybCk7DQogDQotCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHJlZ3MtPmNh
bnR4ZmcpOyBpKyspIHsNCi0JCWZsZXhjYW5fd3JpdGUoMCwgJnJlZ3MtPmNhbnR4ZmdbaV0uY2Fu
X2N0cmwpOw0KLQkJZmxleGNhbl93cml0ZSgwLCAmcmVncy0+Y2FudHhmZ1tpXS5jYW5faWQpOw0K
LQkJZmxleGNhbl93cml0ZSgwLCAmcmVncy0+Y2FudHhmZ1tpXS5kYXRhWzBdKTsNCi0JCWZsZXhj
YW5fd3JpdGUoMCwgJnJlZ3MtPmNhbnR4ZmdbaV0uZGF0YVsxXSk7DQotDQotCQkvKiBwdXQgTUIg
aW50byByeCBxdWV1ZSAqLw0KLQkJZmxleGNhbl93cml0ZShGTEVYQ0FOX01CX0NOVF9DT0RFKDB4
NCksDQotCQkJJnJlZ3MtPmNhbnR4ZmdbaV0uY2FuX2N0cmwpOw0KLQl9DQorCS8qIEFib3J0IGFu
eSBwZW5kaW5nIFRYLCBtYXJrIE1haWxib3ggYXMgSU5BQ1RJVkUgKi8NCisJZmxleGNhbl93cml0
ZShGTEVYQ0FOX01CX0NOVF9DT0RFKDB4NCksDQorCQkgICAgICAmcmVncy0+Y2FudHhmZ1tGTEVY
Q0FOX1RYX0JVRl9JRF0uY2FuX2N0cmwpOw0KIA0KIAkvKiBhY2NlcHRhbmNlIG1hc2svYWNjZXB0
YW5jZSBjb2RlIChhY2NlcHQgZXZlcnl0aGluZykgKi8NCiAJZmxleGNhbl93cml0ZSgweDAsICZy
ZWdzLT5yeGdtYXNrKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2Nh
bGUvZ2lhbmZhci5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuYw0K
aW5kZXggZDA3MjJhNy4uZmI5ZTdkMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ZyZWVzY2FsZS9naWFuZmFyLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9naWFuZmFyLmMNCkBAIC0zOTcsNyArMzk3LDEzIEBAIHN0YXRpYyB2b2lkIGdmYXJfaW5pdF9t
YWMoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpDQogCWlmIChuZGV2LT5mZWF0dXJlcyAmIE5FVElG
X0ZfSVBfQ1NVTSkNCiAJCXRjdHJsIHw9IFRDVFJMX0lOSVRfQ1NVTTsNCiANCi0JdGN0cmwgfD0g
VENUUkxfVFhTQ0hFRF9QUklPOw0KKwlpZiAocHJpdi0+cHJpb19zY2hlZF9lbikNCisJCXRjdHJs
IHw9IFRDVFJMX1RYU0NIRURfUFJJTzsNCisJZWxzZSB7DQorCQl0Y3RybCB8PSBUQ1RSTF9UWFND
SEVEX1dSUlM7DQorCQlnZmFyX3dyaXRlKCZyZWdzLT50cjAzd3QsIERFRkFVTFRfV1JSU19XRUlH
SFQpOw0KKwkJZ2Zhcl93cml0ZSgmcmVncy0+dHI0N3d0LCBERUZBVUxUX1dSUlNfV0VJR0hUKTsN
CisJfQ0KIA0KIAlnZmFyX3dyaXRlKCZyZWdzLT50Y3RybCwgdGN0cmwpOw0KIA0KQEAgLTExNTcs
NiArMTE2Myw5IEBAIHN0YXRpYyBpbnQgZ2Zhcl9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNl
ICpvZmRldikNCiAJcHJpdi0+cnhfZmlsZXJfZW5hYmxlID0gMTsNCiAJLyogRW5hYmxlIG1vc3Qg
bWVzc2FnZXMgYnkgZGVmYXVsdCAqLw0KIAlwcml2LT5tc2dfZW5hYmxlID0gKE5FVElGX01TR19J
RlVQIDw8IDEgKSAtIDE7DQorCS8qIHVzZSBwcml0b3JpdHkgaC93IHR4IHF1ZXVlIHNjaGVkdWxp
bmcgZm9yIHNpbmdsZSBxdWV1ZSBkZXZpY2VzICovDQorCWlmIChwcml2LT5udW1fdHhfcXVldWVz
ID09IDEpDQorCQlwcml2LT5wcmlvX3NjaGVkX2VuID0gMTsNCiANCiAJLyogQ2FycmllciBzdGFy
dHMgZG93biwgcGh5bGliIHdpbGwgYnJpbmcgaXQgdXAgKi8NCiAJbmV0aWZfY2Fycmllcl9vZmYo
ZGV2KTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZ2lhbmZh
ci5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuaA0KaW5kZXggOWFh
NDM3Ny4uYWJlYjc5YSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9naWFuZmFyLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9naWFuZmFy
LmgNCkBAIC0zMDQsOCArMzA0LDE2IEBAIGV4dGVybiBjb25zdCBjaGFyIGdmYXJfZHJpdmVyX3Zl
cnNpb25bXTsNCiAjZGVmaW5lIFRDVFJMX1RGQ1BBVVNFCQkweDAwMDAwMDA4DQogI2RlZmluZSBU
Q1RSTF9UWFNDSEVEX01BU0sJMHgwMDAwMDAwNg0KICNkZWZpbmUgVENUUkxfVFhTQ0hFRF9JTklU
CTB4MDAwMDAwMDANCisvKiBwcmlvcml0eSBzY2hlZHVsaW5nICovDQogI2RlZmluZSBUQ1RSTF9U
WFNDSEVEX1BSSU8JMHgwMDAwMDAwMg0KKy8qIHdlaWdodGVkIHJvdW5kLXJvYmluIHNjaGVkdWxp
bmcgKFdSUlMpICovDQogI2RlZmluZSBUQ1RSTF9UWFNDSEVEX1dSUlMJMHgwMDAwMDAwNA0KKy8q
IGRlZmF1bHQgV1JSUyB3ZWlnaHQgYW5kIHBvbGljeSBzZXR0aW5nLA0KKyAqIHRhaWxvcmVkIHRv
IHRoZSB0cjAzd3QgYW5kIHRyNDd3dCByZWdpc3RlcnM6DQorICogZXF1YWwgd2VpZ2h0IGZvciBh
bGwgVHggUXMsIG1lYXN1cmVkIGluIDY0Ynl0ZSB1bml0cw0KKyAqLw0KKyNkZWZpbmUgREVGQVVM
VF9XUlJTX1dFSUdIVAkweDE4MTgxODE4DQorDQogI2RlZmluZSBUQ1RSTF9JTklUX0NTVU0JCShU
Q1RSTF9UVUNTRU4gfCBUQ1RSTF9JUENTRU4pDQogDQogI2RlZmluZSBJRVZFTlRfSU5JVF9DTEVB
UgkweGZmZmZmZmZmDQpAQCAtMTEwMSw3ICsxMTA5LDggQEAgc3RydWN0IGdmYXJfcHJpdmF0ZSB7
DQogCQlleHRlbmRlZF9oYXNoOjEsDQogCQliZF9zdGFzaF9lbjoxLA0KIAkJcnhfZmlsZXJfZW5h
YmxlOjEsDQotCQl3b2xfZW46MTsgLyogV2FrZS1vbi1MQU4gZW5hYmxlZCAqLw0KKwkJd29sX2Vu
OjEsIC8qIFdha2Utb24tTEFOIGVuYWJsZWQgKi8NCisJCXByaW9fc2NoZWRfZW46MTsgLyogRW5h
YmxlIHByaW9ydHkgYmFzZWQgVHggc2NoZWR1bGluZyBpbiBIdyAqLw0KIAl1bnNpZ25lZCBzaG9y
dCBwYWRkaW5nOw0KIA0KIAkvKiBQSFkgc3R1ZmYgKi8NCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZWFsdGVrLzgxMzljcC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRl
ay84MTM5Y3AuYw0KaW5kZXggOGY0NzkwNy4uNDIzNmI4MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlYWx0ZWsvODEzOWNwLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3JlYWx0ZWsvODEzOWNwLmMNCkBAIC00NzgsNyArNDc4LDcgQEAgcnhfc3RhdHVzX2xvb3A6DQog
DQogCXdoaWxlICgxKSB7DQogCQl1MzIgc3RhdHVzLCBsZW47DQotCQlkbWFfYWRkcl90IG1hcHBp
bmc7DQorCQlkbWFfYWRkcl90IG1hcHBpbmcsIG5ld19tYXBwaW5nOw0KIAkJc3RydWN0IHNrX2J1
ZmYgKnNrYiwgKm5ld19za2I7DQogCQlzdHJ1Y3QgY3BfZGVzYyAqZGVzYzsNCiAJCWNvbnN0IHVu
c2lnbmVkIGJ1ZmxlbiA9IGNwLT5yeF9idWZfc3o7DQpAQCAtNTIwLDYgKzUyMCwxNCBAQCByeF9z
dGF0dXNfbG9vcDoNCiAJCQlnb3RvIHJ4X25leHQ7DQogCQl9DQogDQorCQluZXdfbWFwcGluZyA9
IGRtYV9tYXBfc2luZ2xlKCZjcC0+cGRldi0+ZGV2LCBuZXdfc2tiLT5kYXRhLCBidWZsZW4sDQor
CQkJCQkgUENJX0RNQV9GUk9NREVWSUNFKTsNCisJCWlmIChkbWFfbWFwcGluZ19lcnJvcigmY3At
PnBkZXYtPmRldiwgbmV3X21hcHBpbmcpKSB7DQorCQkJZGV2LT5zdGF0cy5yeF9kcm9wcGVkKys7
DQorCQkJa2ZyZWVfc2tiKG5ld19za2IpOw0KKwkJCWdvdG8gcnhfbmV4dDsNCisJCX0NCisNCiAJ
CWRtYV91bm1hcF9zaW5nbGUoJmNwLT5wZGV2LT5kZXYsIG1hcHBpbmcsDQogCQkJCSBidWZsZW4s
IFBDSV9ETUFfRlJPTURFVklDRSk7DQogDQpAQCAtNTMxLDEyICs1MzksMTEgQEAgcnhfc3RhdHVz
X2xvb3A6DQogDQogCQlza2JfcHV0KHNrYiwgbGVuKTsNCiANCi0JCW1hcHBpbmcgPSBkbWFfbWFw
X3NpbmdsZSgmY3AtPnBkZXYtPmRldiwgbmV3X3NrYi0+ZGF0YSwgYnVmbGVuLA0KLQkJCQkJIFBD
SV9ETUFfRlJPTURFVklDRSk7DQogCQljcC0+cnhfc2tiW3J4X3RhaWxdID0gbmV3X3NrYjsNCiAN
CiAJCWNwX3J4X3NrYihjcCwgc2tiLCBkZXNjKTsNCiAJCXJ4Kys7DQorCQltYXBwaW5nID0gbmV3
X21hcHBpbmc7DQogDQogcnhfbmV4dDoNCiAJCWNwLT5yeF9yaW5nW3J4X3RhaWxdLm9wdHMyID0g
MDsNCkBAIC03MDQsNiArNzExLDIyIEBAIHN0YXRpYyBpbmxpbmUgdTMyIGNwX3R4X3ZsYW5fdGFn
KHN0cnVjdCBza19idWZmICpza2IpDQogCQlUeFZsYW5UYWcgfCBzd2FiMTYodmxhbl90eF90YWdf
Z2V0KHNrYikpIDogMHgwMDsNCiB9DQogDQorc3RhdGljIHZvaWQgdW53aW5kX3R4X2ZyYWdfbWFw
cGluZyhzdHJ1Y3QgY3BfcHJpdmF0ZSAqY3AsIHN0cnVjdCBza19idWZmICpza2IsDQorCQkJCSAg
IGludCBmaXJzdCwgaW50IGVudHJ5X2xhc3QpDQorew0KKwlpbnQgZnJhZywgaW5kZXg7DQorCXN0
cnVjdCBjcF9kZXNjICp0eGQ7DQorCXNrYl9mcmFnX3QgKnRoaXNfZnJhZzsNCisJZm9yIChmcmFn
ID0gMDsgZnJhZytmaXJzdCA8IGVudHJ5X2xhc3Q7IGZyYWcrKykgew0KKwkJaW5kZXggPSBmaXJz
dCtmcmFnOw0KKwkJY3AtPnR4X3NrYltpbmRleF0gPSBOVUxMOw0KKwkJdHhkID0gJmNwLT50eF9y
aW5nW2luZGV4XTsNCisJCXRoaXNfZnJhZyA9ICZza2Jfc2hpbmZvKHNrYiktPmZyYWdzW2ZyYWdd
Ow0KKwkJZG1hX3VubWFwX3NpbmdsZSgmY3AtPnBkZXYtPmRldiwgbGU2NF90b19jcHUodHhkLT5h
ZGRyKSwNCisJCQkJIHNrYl9mcmFnX3NpemUodGhpc19mcmFnKSwgUENJX0RNQV9UT0RFVklDRSk7
DQorCX0NCit9DQorDQogc3RhdGljIG5ldGRldl90eF90IGNwX3N0YXJ0X3htaXQgKHN0cnVjdCBz
a19idWZmICpza2IsDQogCQkJCQlzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KIHsNCkBAIC03Mzcs
NiArNzYwLDkgQEAgc3RhdGljIG5ldGRldl90eF90IGNwX3N0YXJ0X3htaXQgKHN0cnVjdCBza19i
dWZmICpza2IsDQogDQogCQlsZW4gPSBza2ItPmxlbjsNCiAJCW1hcHBpbmcgPSBkbWFfbWFwX3Np
bmdsZSgmY3AtPnBkZXYtPmRldiwgc2tiLT5kYXRhLCBsZW4sIFBDSV9ETUFfVE9ERVZJQ0UpOw0K
KwkJaWYgKGRtYV9tYXBwaW5nX2Vycm9yKCZjcC0+cGRldi0+ZGV2LCBtYXBwaW5nKSkNCisJCQln
b3RvIG91dF9kbWFfZXJyb3I7DQorDQogCQl0eGQtPm9wdHMyID0gb3B0czI7DQogCQl0eGQtPmFk
ZHIgPSBjcHVfdG9fbGU2NChtYXBwaW5nKTsNCiAJCXdtYigpOw0KQEAgLTc3NCw2ICs4MDAsOSBA
QCBzdGF0aWMgbmV0ZGV2X3R4X3QgY3Bfc3RhcnRfeG1pdCAoc3RydWN0IHNrX2J1ZmYgKnNrYiwN
CiAJCWZpcnN0X2xlbiA9IHNrYl9oZWFkbGVuKHNrYik7DQogCQlmaXJzdF9tYXBwaW5nID0gZG1h
X21hcF9zaW5nbGUoJmNwLT5wZGV2LT5kZXYsIHNrYi0+ZGF0YSwNCiAJCQkJCSAgICAgICBmaXJz
dF9sZW4sIFBDSV9ETUFfVE9ERVZJQ0UpOw0KKwkJaWYgKGRtYV9tYXBwaW5nX2Vycm9yKCZjcC0+
cGRldi0+ZGV2LCBmaXJzdF9tYXBwaW5nKSkNCisJCQlnb3RvIG91dF9kbWFfZXJyb3I7DQorDQog
CQljcC0+dHhfc2tiW2VudHJ5XSA9IHNrYjsNCiAJCWVudHJ5ID0gTkVYVF9UWChlbnRyeSk7DQog
DQpAQCAtNzg3LDYgKzgxNiwxMSBAQCBzdGF0aWMgbmV0ZGV2X3R4X3QgY3Bfc3RhcnRfeG1pdCAo
c3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJCQltYXBwaW5nID0gZG1hX21hcF9zaW5nbGUoJmNwLT5w
ZGV2LT5kZXYsDQogCQkJCQkJIHNrYl9mcmFnX2FkZHJlc3ModGhpc19mcmFnKSwNCiAJCQkJCQkg
bGVuLCBQQ0lfRE1BX1RPREVWSUNFKTsNCisJCQlpZiAoZG1hX21hcHBpbmdfZXJyb3IoJmNwLT5w
ZGV2LT5kZXYsIG1hcHBpbmcpKSB7DQorCQkJCXVud2luZF90eF9mcmFnX21hcHBpbmcoY3AsIHNr
YiwgZmlyc3RfZW50cnksIGVudHJ5KTsNCisJCQkJZ290byBvdXRfZG1hX2Vycm9yOw0KKwkJCX0N
CisNCiAJCQllb3IgPSAoZW50cnkgPT0gKENQX1RYX1JJTkdfU0laRSAtIDEpKSA/IFJpbmdFbmQg
OiAwOw0KIA0KIAkJCWN0cmwgPSBlb3IgfCBsZW4gfCBEZXNjT3duOw0KQEAgLTg0NSwxMSArODc5
LDE2IEBAIHN0YXRpYyBuZXRkZXZfdHhfdCBjcF9zdGFydF94bWl0IChzdHJ1Y3Qgc2tfYnVmZiAq
c2tiLA0KIAlpZiAoVFhfQlVGRlNfQVZBSUwoY3ApIDw9IChNQVhfU0tCX0ZSQUdTICsgMSkpDQog
CQluZXRpZl9zdG9wX3F1ZXVlKGRldik7DQogDQorb3V0X3VubG9jazoNCiAJc3Bpbl91bmxvY2tf
aXJxcmVzdG9yZSgmY3AtPmxvY2ssIGludHJfZmxhZ3MpOw0KIA0KIAljcHc4KFR4UG9sbCwgTm9y
bWFsVHhQb2xsKTsNCiANCiAJcmV0dXJuIE5FVERFVl9UWF9PSzsNCitvdXRfZG1hX2Vycm9yOg0K
KwlrZnJlZV9za2Ioc2tiKTsNCisJY3AtPmRldi0+c3RhdHMudHhfZHJvcHBlZCsrOw0KKwlnb3Rv
IG91dF91bmxvY2s7DQogfQ0KIA0KIC8qIFNldCBvciBjbGVhciB0aGUgbXVsdGljYXN0IGZpbHRl
ciBmb3IgdGhpcyBhZGFwdG9yLg0KQEAgLTEwMjMsNiArMTA2MiwxMCBAQCBzdGF0aWMgaW50IGNw
X3JlZmlsbF9yeChzdHJ1Y3QgY3BfcHJpdmF0ZSAqY3ApDQogDQogCQltYXBwaW5nID0gZG1hX21h
cF9zaW5nbGUoJmNwLT5wZGV2LT5kZXYsIHNrYi0+ZGF0YSwNCiAJCQkJCSBjcC0+cnhfYnVmX3N6
LCBQQ0lfRE1BX0ZST01ERVZJQ0UpOw0KKwkJaWYgKGRtYV9tYXBwaW5nX2Vycm9yKCZjcC0+cGRl
di0+ZGV2LCBtYXBwaW5nKSkgew0KKwkJCWtmcmVlX3NrYihza2IpOw0KKwkJCWdvdG8gZXJyX291
dDsNCisJCX0NCiAJCWNwLT5yeF9za2JbaV0gPSBza2I7DQogDQogCQljcC0+cnhfcmluZ1tpXS5v
cHRzMiA9IDA7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL3J4LmMgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvcnguYw0KaW5kZXggOWNlODY2NS4uYzIzMWIzZiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9yeC5jDQorKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9zZmMvcnguYw0KQEAgLTMxMiw4ICszMTIsOSBAQCBzdGF0aWMgdm9pZCBlZnhf
cmVzdXJyZWN0X3J4X2J1ZmZlcihzdHJ1Y3QgZWZ4X3J4X3F1ZXVlICpyeF9xdWV1ZSwNCiANCiAJ
aW5kZXggPSByeF9xdWV1ZS0+YWRkZWRfY291bnQgJiByeF9xdWV1ZS0+cHRyX21hc2s7DQogCW5l
d19idWYgPSBlZnhfcnhfYnVmZmVyKHJ4X3F1ZXVlLCBpbmRleCk7DQotCW5ld19idWYtPmRtYV9h
ZGRyID0gcnhfYnVmLT5kbWFfYWRkciBeIChQQUdFX1NJWkUgPj4gMSk7DQogCW5ld19idWYtPnUu
cGFnZSA9IHJ4X2J1Zi0+dS5wYWdlOw0KKwluZXdfYnVmLT5wYWdlX29mZnNldCA9IHJ4X2J1Zi0+
cGFnZV9vZmZzZXQgXiAoUEFHRV9TSVpFID4+IDEpOw0KKwluZXdfYnVmLT5kbWFfYWRkciA9IHN0
YXRlLT5kbWFfYWRkciArIG5ld19idWYtPnBhZ2Vfb2Zmc2V0Ow0KIAluZXdfYnVmLT5sZW4gPSBy
eF9idWYtPmxlbjsNCiAJbmV3X2J1Zi0+aXNfcGFnZSA9IHRydWU7DQogCSsrcnhfcXVldWUtPmFk
ZGVkX2NvdW50Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3ZpYS92aWEtcmhp
bmUuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3ZpYS92aWEtcmhpbmUuYw0KaW5kZXggZjM0ZGQ5
OS4uZjM3ZTBhZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3ZpYS92aWEtcmhp
bmUuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvdmlhL3ZpYS1yaGluZS5jDQpAQCAtMzIs
NyArMzIsNyBAQA0KICNkZWZpbmUgcHJfZm10KGZtdCkgS0JVSUxEX01PRE5BTUUgIjogIiBmbXQN
CiANCiAjZGVmaW5lIERSVl9OQU1FCSJ2aWEtcmhpbmUiDQotI2RlZmluZSBEUlZfVkVSU0lPTgki
MS41LjAiDQorI2RlZmluZSBEUlZfVkVSU0lPTgkiMS41LjEiDQogI2RlZmluZSBEUlZfUkVMREFU
RQkiMjAxMC0xMC0wOSINCiANCiANCkBAIC0xNTE4LDcgKzE1MTgsMTIgQEAgc3RhdGljIG5ldGRl
dl90eF90IHJoaW5lX3N0YXJ0X3R4KHN0cnVjdCBza19idWZmICpza2IsDQogCQljcHVfdG9fbGUz
MihUWERFU0MgfCAoc2tiLT5sZW4gPj0gRVRIX1pMRU4gPyBza2ItPmxlbiA6IEVUSF9aTEVOKSk7
DQogDQogCWlmICh1bmxpa2VseSh2bGFuX3R4X3RhZ19wcmVzZW50KHNrYikpKSB7DQotCQlycC0+
dHhfcmluZ1tlbnRyeV0udHhfc3RhdHVzID0gY3B1X3RvX2xlMzIoKHZsYW5fdHhfdGFnX2dldChz
a2IpKSA8PCAxNik7DQorCQl1MTYgdmlkX3BjcCA9IHZsYW5fdHhfdGFnX2dldChza2IpOw0KKw0K
KwkJLyogZHJvcCBDRkkvREVJIGJpdCwgcmVnaXN0ZXIgbmVlZHMgVklEIGFuZCBQQ1AgKi8NCisJ
CXZpZF9wY3AgPSAodmlkX3BjcCAmIFZMQU5fVklEX01BU0spIHwNCisJCQkgICgodmlkX3BjcCAm
IFZMQU5fUFJJT19NQVNLKSA+PiAxKTsNCisJCXJwLT50eF9yaW5nW2VudHJ5XS50eF9zdGF0dXMg
PSBjcHVfdG9fbGUzMigodmlkX3BjcCkgPDwgMTYpOw0KIAkJLyogcmVxdWVzdCB0YWdnaW5nICov
DQogCQlycC0+dHhfcmluZ1tlbnRyeV0uZGVzY19sZW5ndGggfD0gY3B1X3RvX2xlMzIoMHgwMjAw
MDApOw0KIAl9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L2xsX3Rl
bWFjX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC9sbF90ZW1hY19tYWluLmMN
CmluZGV4IDI2ODFiNTMuLmUyNjk0NWQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC94aWxpbngvbGxfdGVtYWNfbWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxp
bngvbGxfdGVtYWNfbWFpbi5jDQpAQCAtMzA4LDYgKzMwOCwxMiBAQCBzdGF0aWMgaW50IHRlbWFj
X2RtYV9iZF9pbml0KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KIAkJICAgICAgIGxwLT5yeF9i
ZF9wICsgKHNpemVvZigqbHAtPnJ4X2JkX3YpICogKFJYX0JEX05VTSAtIDEpKSk7DQogCWxwLT5k
bWFfb3V0KGxwLCBUWF9DVVJERVNDX1BUUiwgbHAtPnR4X2JkX3ApOw0KIA0KKwkvKiBJbml0IGRl
c2NyaXB0b3IgaW5kZXhlcyAqLw0KKwlscC0+dHhfYmRfY2kgPSAwOw0KKwlscC0+dHhfYmRfbmV4
dCA9IDA7DQorCWxwLT50eF9iZF90YWlsID0gMDsNCisJbHAtPnJ4X2JkX2NpID0gMDsNCisNCiAJ
cmV0dXJuIDA7DQogDQogb3V0Og0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L21hY3Z0YXAuYyBi
L2RyaXZlcnMvbmV0L21hY3Z0YXAuYw0KaW5kZXggOTZiOWUzYy4uYjBmOTAxNSAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvbmV0L21hY3Z0YXAuYw0KKysrIGIvZHJpdmVycy9uZXQvbWFjdnRhcC5jDQpA
QCAtNjQxLDYgKzY0MSwyOCBAQCBzdGF0aWMgaW50IG1hY3Z0YXBfc2tiX3RvX3ZuZXRfaGRyKGNv
bnN0IHN0cnVjdCBza19idWZmICpza2IsDQogCXJldHVybiAwOw0KIH0NCiANCitzdGF0aWMgdW5z
aWduZWQgbG9uZyBpb3ZfcGFnZXMoY29uc3Qgc3RydWN0IGlvdmVjICppdiwgaW50IG9mZnNldCwN
CisJCQkgICAgICAgdW5zaWduZWQgbG9uZyBucl9zZWdzKQ0KK3sNCisJdW5zaWduZWQgbG9uZyBz
ZWcsIGJhc2U7DQorCWludCBwYWdlcyA9IDAsIGxlbiwgc2l6ZTsNCisNCisJd2hpbGUgKG5yX3Nl
Z3MgJiYgKG9mZnNldCA+PSBpdi0+aW92X2xlbikpIHsNCisJCW9mZnNldCAtPSBpdi0+aW92X2xl
bjsNCisJCSsraXY7DQorCQktLW5yX3NlZ3M7DQorCX0NCisNCisJZm9yIChzZWcgPSAwOyBzZWcg
PCBucl9zZWdzOyBzZWcrKykgew0KKwkJYmFzZSA9ICh1bnNpZ25lZCBsb25nKWl2W3NlZ10uaW92
X2Jhc2UgKyBvZmZzZXQ7DQorCQlsZW4gPSBpdltzZWddLmlvdl9sZW4gLSBvZmZzZXQ7DQorCQlz
aXplID0gKChiYXNlICYgflBBR0VfTUFTSykgKyBsZW4gKyB+UEFHRV9NQVNLKSA+PiBQQUdFX1NI
SUZUOw0KKwkJcGFnZXMgKz0gc2l6ZTsNCisJCW9mZnNldCA9IDA7DQorCX0NCisNCisJcmV0dXJu
IHBhZ2VzOw0KK30NCiANCiAvKiBHZXQgcGFja2V0IGZyb20gdXNlciBzcGFjZSBidWZmZXIgKi8N
CiBzdGF0aWMgc3NpemVfdCBtYWN2dGFwX2dldF91c2VyKHN0cnVjdCBtYWN2dGFwX3F1ZXVlICpx
LCBzdHJ1Y3QgbXNnaGRyICptLA0KQEAgLTY4NywzMSArNzA5LDE1IEBAIHN0YXRpYyBzc2l6ZV90
IG1hY3Z0YXBfZ2V0X3VzZXIoc3RydWN0IG1hY3Z0YXBfcXVldWUgKnEsIHN0cnVjdCBtc2doZHIg
Km0sDQogCWlmICh1bmxpa2VseShjb3VudCA+IFVJT19NQVhJT1YpKQ0KIAkJZ290byBlcnI7DQog
DQotCWlmIChtICYmIG0tPm1zZ19jb250cm9sICYmIHNvY2tfZmxhZygmcS0+c2ssIFNPQ0tfWkVS
T0NPUFkpKQ0KLQkJemVyb2NvcHkgPSB0cnVlOw0KLQ0KLQlpZiAoemVyb2NvcHkpIHsNCi0JCS8q
IFVzZXJzcGFjZSBtYXkgcHJvZHVjZSB2ZWN0b3JzIHdpdGggY291bnQgZ3JlYXRlciB0aGFuDQot
CQkgKiBNQVhfU0tCX0ZSQUdTLCBzbyB3ZSBuZWVkIHRvIGxpbmVhcml6ZSBwYXJ0cyBvZiB0aGUg
c2tiDQotCQkgKiB0byBsZXQgdGhlIHJlc3Qgb2YgZGF0YSB0byBiZSBmaXQgaW4gdGhlIGZyYWdz
Lg0KLQkJICovDQotCQlpZiAoY291bnQgPiBNQVhfU0tCX0ZSQUdTKSB7DQotCQkJY29weWxlbiA9
IGlvdl9sZW5ndGgoaXYsIGNvdW50IC0gTUFYX1NLQl9GUkFHUyk7DQotCQkJaWYgKGNvcHlsZW4g
PCB2bmV0X2hkcl9sZW4pDQotCQkJCWNvcHlsZW4gPSAwOw0KLQkJCWVsc2UNCi0JCQkJY29weWxl
biAtPSB2bmV0X2hkcl9sZW47DQotCQl9DQotCQkvKiBUaGVyZSBhcmUgMjU2IGJ5dGVzIHRvIGJl
IGNvcGllZCBpbiBza2IsIHNvIHRoZXJlIGlzIGVub3VnaA0KLQkJICogcm9vbSBmb3Igc2tiIGV4
cGFuZCBoZWFkIGluIGNhc2UgaXQgaXMgdXNlZC4NCi0JCSAqIFRoZSByZXN0IGJ1ZmZlciBpcyBt
YXBwZWQgZnJvbSB1c2Vyc3BhY2UuDQotCQkgKi8NCi0JCWlmIChjb3B5bGVuIDwgdm5ldF9oZHIu
aGRyX2xlbikNCi0JCQljb3B5bGVuID0gdm5ldF9oZHIuaGRyX2xlbjsNCi0JCWlmICghY29weWxl
bikNCi0JCQljb3B5bGVuID0gR09PRENPUFlfTEVOOw0KKwlpZiAobSAmJiBtLT5tc2dfY29udHJv
bCAmJiBzb2NrX2ZsYWcoJnEtPnNrLCBTT0NLX1pFUk9DT1BZKSkgew0KKwkJY29weWxlbiA9IHZu
ZXRfaGRyLmhkcl9sZW4gPyB2bmV0X2hkci5oZHJfbGVuIDogR09PRENPUFlfTEVOOw0KIAkJbGlu
ZWFyID0gY29weWxlbjsNCi0JfSBlbHNlIHsNCisJCWlmIChpb3ZfcGFnZXMoaXYsIHZuZXRfaGRy
X2xlbiArIGNvcHlsZW4sIGNvdW50KQ0KKwkJICAgIDw9IE1BWF9TS0JfRlJBR1MpDQorCQkJemVy
b2NvcHkgPSB0cnVlOw0KKwl9DQorDQorCWlmICghemVyb2NvcHkpIHsNCiAJCWNvcHlsZW4gPSBs
ZW47DQogCQlsaW5lYXIgPSB2bmV0X2hkci5oZHJfbGVuOw0KIAl9DQpAQCAtNzIzLDkgKzcyOSwx
NSBAQCBzdGF0aWMgc3NpemVfdCBtYWN2dGFwX2dldF91c2VyKHN0cnVjdCBtYWN2dGFwX3F1ZXVl
ICpxLCBzdHJ1Y3QgbXNnaGRyICptLA0KIA0KIAlpZiAoemVyb2NvcHkpDQogCQllcnIgPSB6ZXJv
Y29weV9zZ19mcm9tX2lvdmVjKHNrYiwgaXYsIHZuZXRfaGRyX2xlbiwgY291bnQpOw0KLQllbHNl
DQorCWVsc2Ugew0KIAkJZXJyID0gc2tiX2NvcHlfZGF0YWdyYW1fZnJvbV9pb3ZlYyhza2IsIDAs
IGl2LCB2bmV0X2hkcl9sZW4sDQogCQkJCQkJICAgbGVuKTsNCisJCWlmICghZXJyICYmIG0gJiYg
bS0+bXNnX2NvbnRyb2wpIHsNCisJCQlzdHJ1Y3QgdWJ1Zl9pbmZvICp1YXJnID0gbS0+bXNnX2Nv
bnRyb2w7DQorCQkJdWFyZy0+Y2FsbGJhY2sodWFyZyk7DQorCQl9DQorCX0NCisNCiAJaWYgKGVy
cikNCiAJCWdvdG8gZXJyX2tmcmVlOw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BwcC9w
cHRwLmMgYi9kcml2ZXJzL25ldC9wcHAvcHB0cC5jDQppbmRleCBhZDZhOWQ5Li4yYjM0OWQzIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvcHBwL3BwdHAuYw0KKysrIGIvZHJpdmVycy9uZXQvcHBw
L3BwdHAuYw0KQEAgLTI4MSw3ICsyODEsNyBAQCBzdGF0aWMgaW50IHBwdHBfeG1pdChzdHJ1Y3Qg
cHBwX2NoYW5uZWwgKmNoYW4sIHN0cnVjdCBza19idWZmICpza2IpDQogCW5mX3Jlc2V0KHNrYik7
DQogDQogCXNrYi0+aXBfc3VtbWVkID0gQ0hFQ0tTVU1fTk9ORTsNCi0JaXBfc2VsZWN0X2lkZW50
KGlwaCwgJnJ0LT5kc3QsIE5VTEwpOw0KKwlpcF9zZWxlY3RfaWRlbnQoc2tiLCAmcnQtPmRzdCwg
TlVMTCk7DQogCWlwX3NlbmRfY2hlY2soaXBoKTsNCiANCiAJaXBfbG9jYWxfb3V0KHNrYik7DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdHVuLmMgYi9kcml2ZXJzL25ldC90dW4uYw0KaW5kZXgg
ZjRjNWRlNi4uZWUxYWFiMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3R1bi5jDQorKysgYi9k
cml2ZXJzL25ldC90dW4uYw0KQEAgLTYxNCw4ICs2MTQsOSBAQCBzdGF0aWMgc3NpemVfdCB0dW5f
Z2V0X3VzZXIoc3RydWN0IHR1bl9zdHJ1Y3QgKnR1biwNCiAJaW50IG9mZnNldCA9IDA7DQogDQog
CWlmICghKHR1bi0+ZmxhZ3MgJiBUVU5fTk9fUEkpKSB7DQotCQlpZiAoKGxlbiAtPSBzaXplb2Yo
cGkpKSA+IGNvdW50KQ0KKwkJaWYgKGxlbiA8IHNpemVvZihwaSkpDQogCQkJcmV0dXJuIC1FSU5W
QUw7DQorCQlsZW4gLT0gc2l6ZW9mKHBpKTsNCiANCiAJCWlmIChtZW1jcHlfZnJvbWlvdmVjZW5k
KCh2b2lkICopJnBpLCBpdiwgMCwgc2l6ZW9mKHBpKSkpDQogCQkJcmV0dXJuIC1FRkFVTFQ7DQpA
QCAtNjIzLDggKzYyNCw5IEBAIHN0YXRpYyBzc2l6ZV90IHR1bl9nZXRfdXNlcihzdHJ1Y3QgdHVu
X3N0cnVjdCAqdHVuLA0KIAl9DQogDQogCWlmICh0dW4tPmZsYWdzICYgVFVOX1ZORVRfSERSKSB7
DQotCQlpZiAoKGxlbiAtPSB0dW4tPnZuZXRfaGRyX3N6KSA+IGNvdW50KQ0KKwkJaWYgKGxlbiA8
IHR1bi0+dm5ldF9oZHJfc3opDQogCQkJcmV0dXJuIC1FSU5WQUw7DQorCQlsZW4gLT0gdHVuLT52
bmV0X2hkcl9zejsNCiANCiAJCWlmIChtZW1jcHlfZnJvbWlvdmVjZW5kKCh2b2lkICopJmdzbywg
aXYsIG9mZnNldCwgc2l6ZW9mKGdzbykpKQ0KIAkJCXJldHVybiAtRUZBVUxUOw0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L3VzYi9jZGNfZXRoZXIuYyBiL2RyaXZlcnMvbmV0L3VzYi9jZGNfZXRo
ZXIuYw0KaW5kZXggMmJhNDBjZi4uNDNhYTA2YiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3Vz
Yi9jZGNfZXRoZXIuYw0KKysrIGIvZHJpdmVycy9uZXQvdXNiL2NkY19ldGhlci5jDQpAQCAtNjE1
LDYgKzYxNSwxMSBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQJcHJvZHVjdHMg
W10gPSB7DQogCS5iSW50ZXJmYWNlUHJvdG9jb2wJPSBVU0JfQ0RDX1BST1RPX05PTkUsDQogCS5k
cml2ZXJfaW5mbyA9ICh1bnNpZ25lZCBsb25nKSZ3d2FuX2luZm8sDQogfSwgew0KKwkvKiBUZWxp
dCBtb2R1bGVzICovDQorCVVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKDB4MWJjNywgVVNC
X0NMQVNTX0NPTU0sDQorCQkJVVNCX0NEQ19TVUJDTEFTU19FVEhFUk5FVCwgVVNCX0NEQ19QUk9U
T19OT05FKSwNCisJLmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9uZ190KSAmd3dhbl9pbmZvLA0K
K30sIHsNCiAJVVNCX0lOVEVSRkFDRV9JTkZPKFVTQl9DTEFTU19DT01NLCBVU0JfQ0RDX1NVQkNM
QVNTX0VUSEVSTkVULA0KIAkJCVVTQl9DRENfUFJPVE9fTk9ORSksDQogCS5kcml2ZXJfaW5mbyA9
ICh1bnNpZ25lZCBsb25nKSAmY2RjX2luZm8sDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNi
L2RtOTYwMS5jIGIvZHJpdmVycy9uZXQvdXNiL2RtOTYwMS5jDQppbmRleCBmYmMwZTRkLi4xMzZl
Y2YzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvdXNiL2RtOTYwMS5jDQorKysgYi9kcml2ZXJz
L25ldC91c2IvZG05NjAxLmMNCkBAIC0zODQsNyArMzg0LDcgQEAgc3RhdGljIHZvaWQgZG05NjAx
X3NldF9tdWx0aWNhc3Qoc3RydWN0IG5ldF9kZXZpY2UgKm5ldCkNCiAJCXJ4X2N0bCB8PSAweDAy
Ow0KIAl9IGVsc2UgaWYgKG5ldC0+ZmxhZ3MgJiBJRkZfQUxMTVVMVEkgfHwNCiAJCSAgIG5ldGRl
dl9tY19jb3VudChuZXQpID4gRE1fTUFYX01DQVNUKSB7DQotCQlyeF9jdGwgfD0gMHgwNDsNCisJ
CXJ4X2N0bCB8PSAweDA4Ow0KIAl9IGVsc2UgaWYgKCFuZXRkZXZfbWNfZW1wdHkobmV0KSkgew0K
IAkJc3RydWN0IG5ldGRldl9od19hZGRyICpoYTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9hdGgvYXRoOWsvYXI5MDAzX3BoeS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YXRoL2F0aDlrL2FyOTAwM19waHkuYw0KaW5kZXggNzNiZTdmZi4uZjE0NjgyNCAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDNfcGh5LmMNCisrKyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDNfcGh5LmMNCkBAIC0xMDE2LDYgKzEw
MTYsMTAgQEAgc3RhdGljIGJvb2wgYXI5MDAzX2h3X2FuaV9jb250cm9sKHN0cnVjdCBhdGhfaHcg
KmFoLA0KIAkJICogaXNfb24gPT0gMCBtZWFucyBNUkMgQ0NLIGlzIE9GRiAobW9yZSBub2lzZSBp
bW0pDQogCQkgKi8NCiAJCWJvb2wgaXNfb24gPSBwYXJhbSA/IDEgOiAwOw0KKw0KKwkJaWYgKGFo
LT5jYXBzLnJ4X2NoYWlubWFzayA9PSAxKQ0KKwkJCWJyZWFrOw0KKw0KIAkJUkVHX1JNV19GSUVM
RChhaCwgQVJfUEhZX01SQ19DQ0tfQ1RSTCwNCiAJCQkgICAgICBBUl9QSFlfTVJDX0NDS19FTkFC
TEUsIGlzX29uKTsNCiAJCVJFR19STVdfRklFTEQoYWgsIEFSX1BIWV9NUkNfQ0NLX0NUUkwsDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2F0aDlrLmggYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvYXRoOWsuaA0KaW5kZXggMWMyNjlmNS4uN2M3MGNm
MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hdGg5ay5oDQor
KysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvYXRoOWsuaA0KQEAgLTc3LDEwICs3
Nyw2IEBAIHN0cnVjdCBhdGhfY29uZmlnIHsNCiAJCSAgICAgICBzaXplb2Yoc3RydWN0IGF0aF9i
dWZfc3RhdGUpKTsJCVwNCiAJfSB3aGlsZSAoMCkNCiANCi0jZGVmaW5lIEFUSF9SWEJVRl9SRVNF
VChfYmYpIGRvIHsJCVwNCi0JCShfYmYpLT5iZl9zdGFsZSA9IGZhbHNlOwlcDQotCX0gd2hpbGUg
KDApDQotDQogLyoqDQogICogZW51bSBidWZmZXJfdHlwZSAtIEJ1ZmZlciB0eXBlIGZsYWdzDQog
ICoNCkBAIC0zMDgsNiArMzA0LDcgQEAgc3RydWN0IGF0aF9yeCB7DQogCXN0cnVjdCBhdGhfYnVm
ICpyeF9idWZwdHI7DQogCXN0cnVjdCBhdGhfcnhfZWRtYSByeF9lZG1hW0FUSDlLX1JYX1FVRVVF
X01BWF07DQogDQorCXN0cnVjdCBhdGhfYnVmICpidWZfaG9sZDsNCiAJc3RydWN0IHNrX2J1ZmYg
KmZyYWc7DQogfTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
OWsvcmVjdi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3JlY3YuYw0KaW5kZXgg
ZDE3MWE3Mi4uODMyNmMxNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9h
dGg5ay9yZWN2LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9yZWN2LmMN
CkBAIC03OCw4ICs3OCw2IEBAIHN0YXRpYyB2b2lkIGF0aF9yeF9idWZfbGluayhzdHJ1Y3QgYXRo
X3NvZnRjICpzYywgc3RydWN0IGF0aF9idWYgKmJmKQ0KIAlzdHJ1Y3QgYXRoX2Rlc2MgKmRzOw0K
IAlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KIA0KLQlBVEhfUlhCVUZfUkVTRVQoYmYpOw0KLQ0KIAlk
cyA9IGJmLT5iZl9kZXNjOw0KIAlkcy0+ZHNfbGluayA9IDA7IC8qIGxpbmsgdG8gbnVsbCAqLw0K
IAlkcy0+ZHNfZGF0YSA9IGJmLT5iZl9idWZfYWRkcjsNCkBAIC0xMDYsNiArMTA0LDE0IEBAIHN0
YXRpYyB2b2lkIGF0aF9yeF9idWZfbGluayhzdHJ1Y3QgYXRoX3NvZnRjICpzYywgc3RydWN0IGF0
aF9idWYgKmJmKQ0KIAlzYy0+cngucnhsaW5rID0gJmRzLT5kc19saW5rOw0KIH0NCiANCitzdGF0
aWMgdm9pZCBhdGhfcnhfYnVmX3JlbGluayhzdHJ1Y3QgYXRoX3NvZnRjICpzYywgc3RydWN0IGF0
aF9idWYgKmJmKQ0KK3sNCisJaWYgKHNjLT5yeC5idWZfaG9sZCkNCisJCWF0aF9yeF9idWZfbGlu
ayhzYywgc2MtPnJ4LmJ1Zl9ob2xkKTsNCisNCisJc2MtPnJ4LmJ1Zl9ob2xkID0gYmY7DQorfQ0K
Kw0KIHN0YXRpYyB2b2lkIGF0aF9zZXRkZWZhbnRlbm5hKHN0cnVjdCBhdGhfc29mdGMgKnNjLCB1
MzIgYW50ZW5uYSkNCiB7DQogCS8qIFhYWCBibG9jayBiZWFjb24gaW50ZXJydXB0cyAqLw0KQEAg
LTE1Myw3ICsxNTksNiBAQCBzdGF0aWMgYm9vbCBhdGhfcnhfZWRtYV9idWZfbGluayhzdHJ1Y3Qg
YXRoX3NvZnRjICpzYywNCiANCiAJc2tiID0gYmYtPmJmX21wZHU7DQogDQotCUFUSF9SWEJVRl9S
RVNFVChiZik7DQogCW1lbXNldChza2ItPmRhdGEsIDAsIGFoLT5jYXBzLnJ4X3N0YXR1c19sZW4p
Ow0KIAlkbWFfc3luY19zaW5nbGVfZm9yX2RldmljZShzYy0+ZGV2LCBiZi0+YmZfYnVmX2FkZHIs
DQogCQkJCWFoLT5jYXBzLnJ4X3N0YXR1c19sZW4sIERNQV9UT19ERVZJQ0UpOw0KQEAgLTQ5Miw2
ICs0OTcsNyBAQCBpbnQgYXRoX3N0YXJ0cmVjdihzdHJ1Y3QgYXRoX3NvZnRjICpzYykNCiAJaWYg
KGxpc3RfZW1wdHkoJnNjLT5yeC5yeGJ1ZikpDQogCQlnb3RvIHN0YXJ0X3JlY3Y7DQogDQorCXNj
LT5yeC5idWZfaG9sZCA9IE5VTEw7DQogCXNjLT5yeC5yeGxpbmsgPSBOVUxMOw0KIAlsaXN0X2Zv
cl9lYWNoX2VudHJ5X3NhZmUoYmYsIHRiZiwgJnNjLT5yeC5yeGJ1ZiwgbGlzdCkgew0KIAkJYXRo
X3J4X2J1Zl9saW5rKHNjLCBiZik7DQpAQCAtNzQyLDYgKzc0OCw5IEBAIHN0YXRpYyBzdHJ1Y3Qg
YXRoX2J1ZiAqYXRoX2dldF9uZXh0X3J4X2J1ZihzdHJ1Y3QgYXRoX3NvZnRjICpzYywNCiAJfQ0K
IA0KIAliZiA9IGxpc3RfZmlyc3RfZW50cnkoJnNjLT5yeC5yeGJ1Ziwgc3RydWN0IGF0aF9idWYs
IGxpc3QpOw0KKwlpZiAoYmYgPT0gc2MtPnJ4LmJ1Zl9ob2xkKQ0KKwkJcmV0dXJuIE5VTEw7DQor
DQogCWRzID0gYmYtPmJmX2Rlc2M7DQogDQogCS8qDQpAQCAtMTk3NCw3ICsxOTgzLDcgQEAgcmVx
dWV1ZToNCiAJCWlmIChlZG1hKSB7DQogCQkJYXRoX3J4X2VkbWFfYnVmX2xpbmsoc2MsIHF0eXBl
KTsNCiAJCX0gZWxzZSB7DQotCQkJYXRoX3J4X2J1Zl9saW5rKHNjLCBiZik7DQorCQkJYXRoX3J4
X2J1Zl9yZWxpbmsoc2MsIGJmKTsNCiAJCQlhdGg5a19od19yeGVuYShhaCk7DQogCQl9DQogCX0g
d2hpbGUgKDEpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay94
bWl0LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsveG1pdC5jDQppbmRleCAxOGRh
MTAwLi4xMjZlZDMxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlr
L3htaXQuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3htaXQuYw0KQEAg
LTI0MjMsNiArMjQyMyw3IEBAIHZvaWQgYXRoX3R4X25vZGVfaW5pdChzdHJ1Y3QgYXRoX3NvZnRj
ICpzYywgc3RydWN0IGF0aF9ub2RlICphbikNCiAJZm9yIChhY25vID0gMCwgYWMgPSAmYW4tPmFj
W2Fjbm9dOw0KIAkgICAgIGFjbm8gPCBXTUVfTlVNX0FDOyBhY25vKyssIGFjKyspIHsNCiAJCWFj
LT5zY2hlZCAgICA9IGZhbHNlOw0KKwkJYWMtPmNsZWFyX3BzX2ZpbHRlciA9IHRydWU7DQogCQlh
Yy0+dHhxID0gc2MtPnR4LnR4cV9tYXBbYWNub107DQogCQlJTklUX0xJU1RfSEVBRCgmYWMtPnRp
ZF9xKTsNCiAJfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3A1NC9wNTR1c2Iu
YyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3A1NC9wNTR1c2IuYw0KaW5kZXggNTY0MjE4Yy4uMDc4
NDQ5MyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3A1NC9wNTR1c2IuYw0KKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcDU0L3A1NHVzYi5jDQpAQCAtODMsNiArODMsNyBAQCBz
dGF0aWMgc3RydWN0IHVzYl9kZXZpY2VfaWQgcDU0dV90YWJsZVtdID0gew0KIAl7VVNCX0RFVklD
RSgweDA2YTksIDB4MDAwZSl9LAkvKiBXZXN0ZWxsIDgwMi4xMWcgVVNCIChBOTAtMjExV0ctMDEp
ICovDQogCXtVU0JfREVWSUNFKDB4MDZiOSwgMHgwMTIxKX0sCS8qIFRob21zb24gU3BlZWRUb3Vj
aCAxMjFnICovDQogCXtVU0JfREVWSUNFKDB4MDcwNywgMHhlZTEzKX0sICAgLyogU01DIDI4NjJX
LUcgdmVyc2lvbiAyICovDQorCXtVU0JfREVWSUNFKDB4MDdhYSwgMHgwMDIwKX0sCS8qIENvcmVn
YSBXTFVTQjJHVFNUIFVTQiAqLw0KIAl7VVNCX0RFVklDRSgweDA4MDMsIDB4NDMxMCl9LAkvKiBa
b29tIDQ0MTBhICovDQogCXtVU0JfREVWSUNFKDB4MDgzYSwgMHg0NTIxKX0sICAgLyogU2llbWVu
cyBHaWdhc2V0IFVTQiBBZGFwdGVyIDU0IHZlcnNpb24gMiAqLw0KIAl7VVNCX0RFVklDRSgweDA4
M2EsIDB4NDUzMSl9LAkvKiBULUNvbSBTaW51cyAxNTQgZGF0YSBJSSAqLw0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDI4MDBsaWIuYyBiL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL3J0MngwMC9ydDI4MDBsaWIuYw0KaW5kZXggNjdjYmU1YS4uOGZiOGM5ZSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDI4MDBsaWIuYw0KKysrIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvcnQyeDAwL3J0MjgwMGxpYi5jDQpAQCAtMjA2Nyw2ICsyMDY3LDEz
IEBAIHN0YXRpYyBpbnQgcnQyODAwX2dldF9nYWluX2NhbGlicmF0aW9uX2RlbHRhKHN0cnVjdCBy
dDJ4MDBfZGV2ICpydDJ4MDBkZXYpDQogCWludCBpOw0KIA0KIAkvKg0KKwkgKiBGaXJzdCBjaGVj
ayBpZiB0ZW1wZXJhdHVyZSBjb21wZW5zYXRpb24gaXMgc3VwcG9ydGVkLg0KKwkgKi8NCisJcnQy
eDAwX2VlcHJvbV9yZWFkKHJ0MngwMGRldiwgRUVQUk9NX05JQ19DT05GMSwgJmVlcHJvbSk7DQor
CWlmICghcnQyeDAwX2dldF9maWVsZDE2KGVlcHJvbSwgRUVQUk9NX05JQ19DT05GMV9FWFRFUk5B
TF9UWF9BTEMpKQ0KKwkJcmV0dXJuIDA7DQorDQorCS8qDQogCSAqIFJlYWQgVFNTSSBib3VuZGFy
aWVzIGZvciB0ZW1wZXJhdHVyZSBjb21wZW5zYXRpb24gZnJvbQ0KIAkgKiB0aGUgRUVQUk9NLg0K
IAkgKg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvd2lmaS5oIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS93aWZpLmgNCmluZGV4IGRlYjg3ZTkuLjgyYmFh
YTIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3dpZmkuaA0KKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS93aWZpLmgNCkBAIC0xNjMwLDcgKzE2MzAs
NyBAQCBzdHJ1Y3QgcnRsX3ByaXYgew0KIAkgICB0aGF0IGl0IHBvaW50cyB0byB0aGUgZGF0YSBh
bGxvY2F0ZWQNCiAJICAgYmV5b25kICB0aGlzIHN0cnVjdHVyZSBsaWtlOg0KIAkgICBydGxfcGNp
X3ByaXYgb3IgcnRsX3VzYl9wcml2ICovDQotCXU4IHByaXZbMF07DQorCXU4IHByaXZbMF0gX19h
bGlnbmVkKHNpemVvZih2b2lkICopKTsNCiB9Ow0KIA0KICNkZWZpbmUgcnRsX3ByaXYoaHcpCQko
KChzdHJ1Y3QgcnRsX3ByaXYgKikoaHcpLT5wcml2KSkNCmRpZmYgLS1naXQgYS9kcml2ZXJzL29m
L2Jhc2UuYyBiL2RyaXZlcnMvb2YvYmFzZS5jDQppbmRleCA5YjY1ODhlLi4zNzYzOWE2IDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9vZi9iYXNlLmMNCisrKyBiL2RyaXZlcnMvb2YvYmFzZS5jDQpAQCAt
MTE4OSw2ICsxMTg5LDcgQEAgdm9pZCBvZl9hbGlhc19zY2FuKHZvaWQgKiAoKmR0X2FsbG9jKSh1
NjQgc2l6ZSwgdTY0IGFsaWduKSkNCiAJCWFwID0gZHRfYWxsb2Moc2l6ZW9mKCphcCkgKyBsZW4g
KyAxLCA0KTsNCiAJCWlmICghYXApDQogCQkJY29udGludWU7DQorCQltZW1zZXQoYXAsIDAsIHNp
emVvZigqYXApICsgbGVuICsgMSk7DQogCQlhcC0+YWxpYXMgPSBzdGFydDsNCiAJCW9mX2FsaWFz
X2FkZChhcCwgbnAsIGlkLCBzdGFydCwgbGVuKTsNCiAJfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS9lc3Bfc2NzaS5jIGIvZHJpdmVycy9zY3NpL2VzcF9zY3NpLmMNCmluZGV4IDM5NGVkOWUu
LjRhYTMwZDggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvZXNwX3Njc2kuYw0KKysrIGIvZHJp
dmVycy9zY3NpL2VzcF9zY3NpLmMNCkBAIC01MzAsNyArNTMwLDcgQEAgc3RhdGljIGludCBlc3Bf
bmVlZF90b19uZWdvX3N5bmMoc3RydWN0IGVzcF90YXJnZXRfZGF0YSAqdHApDQogc3RhdGljIGlu
dCBlc3BfYWxsb2NfbHVuX3RhZyhzdHJ1Y3QgZXNwX2NtZF9lbnRyeSAqZW50LA0KIAkJCSAgICAg
c3RydWN0IGVzcF9sdW5fZGF0YSAqbHApDQogew0KLQlpZiAoIWVudC0+dGFnWzBdKSB7DQorCWlm
ICghZW50LT5vcmlnX3RhZ1swXSkgew0KIAkJLyogTm9uLXRhZ2dlZCwgc2xvdCBhbHJlYWR5IHRh
a2VuPyAgKi8NCiAJCWlmIChscC0+bm9uX3RhZ2dlZF9jbWQpDQogCQkJcmV0dXJuIC1FQlVTWTsN
CkBAIC01NjQsOSArNTY0LDkgQEAgc3RhdGljIGludCBlc3BfYWxsb2NfbHVuX3RhZyhzdHJ1Y3Qg
ZXNwX2NtZF9lbnRyeSAqZW50LA0KIAkJCXJldHVybiAtRUJVU1k7DQogCX0NCiANCi0JQlVHX09O
KGxwLT50YWdnZWRfY21kc1tlbnQtPnRhZ1sxXV0pOw0KKwlCVUdfT04obHAtPnRhZ2dlZF9jbWRz
W2VudC0+b3JpZ190YWdbMV1dKTsNCiANCi0JbHAtPnRhZ2dlZF9jbWRzW2VudC0+dGFnWzFdXSA9
IGVudDsNCisJbHAtPnRhZ2dlZF9jbWRzW2VudC0+b3JpZ190YWdbMV1dID0gZW50Ow0KIAlscC0+
bnVtX3RhZ2dlZCsrOw0KIA0KIAlyZXR1cm4gMDsNCkBAIC01NzUsOSArNTc1LDkgQEAgc3RhdGlj
IGludCBlc3BfYWxsb2NfbHVuX3RhZyhzdHJ1Y3QgZXNwX2NtZF9lbnRyeSAqZW50LA0KIHN0YXRp
YyB2b2lkIGVzcF9mcmVlX2x1bl90YWcoc3RydWN0IGVzcF9jbWRfZW50cnkgKmVudCwNCiAJCQkg
ICAgIHN0cnVjdCBlc3BfbHVuX2RhdGEgKmxwKQ0KIHsNCi0JaWYgKGVudC0+dGFnWzBdKSB7DQot
CQlCVUdfT04obHAtPnRhZ2dlZF9jbWRzW2VudC0+dGFnWzFdXSAhPSBlbnQpOw0KLQkJbHAtPnRh
Z2dlZF9jbWRzW2VudC0+dGFnWzFdXSA9IE5VTEw7DQorCWlmIChlbnQtPm9yaWdfdGFnWzBdKSB7
DQorCQlCVUdfT04obHAtPnRhZ2dlZF9jbWRzW2VudC0+b3JpZ190YWdbMV1dICE9IGVudCk7DQor
CQlscC0+dGFnZ2VkX2NtZHNbZW50LT5vcmlnX3RhZ1sxXV0gPSBOVUxMOw0KIAkJbHAtPm51bV90
YWdnZWQtLTsNCiAJfSBlbHNlIHsNCiAJCUJVR19PTihscC0+bm9uX3RhZ2dlZF9jbWQgIT0gZW50
KTsNCkBAIC02NjcsNiArNjY3LDggQEAgc3RhdGljIHN0cnVjdCBlc3BfY21kX2VudHJ5ICpmaW5k
X2FuZF9wcmVwX2lzc3VhYmxlX2NvbW1hbmQoc3RydWN0IGVzcCAqZXNwKQ0KIAkJCWVudC0+dGFn
WzBdID0gMDsNCiAJCQllbnQtPnRhZ1sxXSA9IDA7DQogCQl9DQorCQllbnQtPm9yaWdfdGFnWzBd
ID0gZW50LT50YWdbMF07DQorCQllbnQtPm9yaWdfdGFnWzFdID0gZW50LT50YWdbMV07DQogDQog
CQlpZiAoZXNwX2FsbG9jX2x1bl90YWcoZW50LCBscCkgPCAwKQ0KIAkJCWNvbnRpbnVlOw0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9lc3Bfc2NzaS5oIGIvZHJpdmVycy9zY3NpL2VzcF9zY3Np
LmgNCmluZGV4IDI4ZTIyYWMuLmNkNjg4MDUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvZXNw
X3Njc2kuaA0KKysrIGIvZHJpdmVycy9zY3NpL2VzcF9zY3NpLmgNCkBAIC0yNzEsNiArMjcxLDcg
QEAgc3RydWN0IGVzcF9jbWRfZW50cnkgew0KICNkZWZpbmUgRVNQX0NNRF9GTEFHX0FVVE9TRU5T
RQkweDA0IC8qIERvaW5nIGF1dG9tYXRpYyBSRVFVRVNUX1NFTlNFICovDQogDQogCXU4CQkJdGFn
WzJdOw0KKwl1OAkJCW9yaWdfdGFnWzJdOw0KIA0KIAl1OAkJCXN0YXR1czsNCiAJdTgJCQltZXNz
YWdlOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5jIGIv
ZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmMNCmluZGV4IDk2MDI5ZTYuLmM4NzQ0
NTggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvc2NzaV90cmFuc3BvcnRfaXNjc2kuYw0KKysr
IGIvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmMNCkBAIC0yMTA1LDcgKzIxMDUs
NyBAQCBpc2NzaV9pZl9yeChzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KIAkJCQlicmVhazsNCiAJCQll
cnIgPSBpc2NzaV9pZl9zZW5kX3JlcGx5KGdyb3VwLCBubGgtPm5sbXNnX3NlcSwNCiAJCQkJbmxo
LT5ubG1zZ190eXBlLCAwLCAwLCBldiwgc2l6ZW9mKCpldikpOw0KLQkJfSB3aGlsZSAoZXJyIDwg
MCAmJiBlcnIgIT0gLUVDT05OUkVGVVNFRCk7DQorCQl9IHdoaWxlIChlcnIgPCAwICYmIGVyciAh
PSAtRUNPTk5SRUZVU0VEICYmIGVyciAhPSAtRVNSQ0gpOw0KIAkJc2tiX3B1bGwoc2tiLCBybGVu
KTsNCiAJfQ0KIAltdXRleF91bmxvY2soJnJ4X3F1ZXVlX211dGV4KTsNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3Njc2kvc2QuYyBiL2RyaXZlcnMvc2NzaS9zZC5jDQppbmRleCAxNzYwM2RhLi5mNmQy
YjYyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3NkLmMNCisrKyBiL2RyaXZlcnMvc2NzaS9z
ZC5jDQpAQCAtMjEzNiwxNCArMjEzNiw5IEBAIHNkX3JlYWRfY2FjaGVfdHlwZShzdHJ1Y3Qgc2Nz
aV9kaXNrICpzZGtwLCB1bnNpZ25lZCBjaGFyICpidWZmZXIpDQogCQkJfQ0KIAkJfQ0KIA0KLQkJ
aWYgKG1vZGVwYWdlID09IDB4M0YpIHsNCi0JCQlzZF9wcmludGsoS0VSTl9FUlIsIHNka3AsICJO
byBDYWNoaW5nIG1vZGUgcGFnZSAiDQotCQkJCSAgInByZXNlbnRcbiIpOw0KLQkJCWdvdG8gZGVm
YXVsdHM7DQotCQl9IGVsc2UgaWYgKChidWZmZXJbb2Zmc2V0XSAmIDB4M2YpICE9IG1vZGVwYWdl
KSB7DQotCQkJc2RfcHJpbnRrKEtFUk5fRVJSLCBzZGtwLCAiR290IHdyb25nIHBhZ2VcbiIpOw0K
LQkJCWdvdG8gZGVmYXVsdHM7DQotCQl9DQorCQlzZF9wcmludGsoS0VSTl9FUlIsIHNka3AsICJO
byBDYWNoaW5nIG1vZGUgcGFnZSBmb3VuZFxuIik7DQorCQlnb3RvIGRlZmF1bHRzOw0KKw0KIAlQ
YWdlX2ZvdW5kOg0KIAkJaWYgKG1vZGVwYWdlID09IDgpIHsNCiAJCQlzZGtwLT5XQ0UgPSAoKGJ1
ZmZlcltvZmZzZXQgKyAyXSAmIDB4MDQpICE9IDApOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy9jb21lZGkvZHJpdmVycy9kdDI4MnguYyBiL2RyaXZlcnMvc3RhZ2luZy9jb21lZGkvZHJp
dmVycy9kdDI4MnguYw0KaW5kZXggOTVlYmMyNi4uZTNhZGIzOCAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvc3RhZ2luZy9jb21lZGkvZHJpdmVycy9kdDI4MnguYw0KKysrIGIvZHJpdmVycy9zdGFnaW5n
L2NvbWVkaS9kcml2ZXJzL2R0MjgyeC5jDQpAQCAtNDA3LDggKzQwNyw5IEBAIHN0cnVjdCBkdDI4
MnhfcHJpdmF0ZSB7DQogCQkJfQkJCQkJXA0KIAkJCXVkZWxheSg1KTsJCQkJXA0KIAkJfQkJCQkJ
CVwNCi0JCWlmIChfaSkJCQkJCQlcDQorCQlpZiAoX2kpIHsJCQkJCVwNCiAJCQliCQkJCQlcDQor
CQl9CQkJCQkJXA0KIAl9IHdoaWxlICgwKQ0KIA0KIHN0YXRpYyBpbnQgZHQyODJ4X2F0dGFjaChz
dHJ1Y3QgY29tZWRpX2RldmljZSAqZGV2LA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9j
b21lZGkvZHJpdmVycy9uaV82NXh4LmMgYi9kcml2ZXJzL3N0YWdpbmcvY29tZWRpL2RyaXZlcnMv
bmlfNjV4eC5jDQppbmRleCA0MDNmYzA5Li44YjU2NGFkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9z
dGFnaW5nL2NvbWVkaS9kcml2ZXJzL25pXzY1eHguYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL2Nv
bWVkaS9kcml2ZXJzL25pXzY1eHguYw0KQEAgLTQxMSwyOSArNDExLDI1IEBAIHN0YXRpYyBpbnQg
bmlfNjV4eF9kaW9faW5zbl9iaXRzKHN0cnVjdCBjb21lZGlfZGV2aWNlICpkZXYsDQogCQkJCSBz
dHJ1Y3QgY29tZWRpX3N1YmRldmljZSAqcywNCiAJCQkJIHN0cnVjdCBjb21lZGlfaW5zbiAqaW5z
biwgdW5zaWduZWQgaW50ICpkYXRhKQ0KIHsNCi0JdW5zaWduZWQgYmFzZV9iaXRmaWVsZF9jaGFu
bmVsOw0KLQljb25zdCB1bnNpZ25lZCBtYXhfcG9ydHNfcGVyX2JpdGZpZWxkID0gNTsNCisJaW50
IGJhc2VfYml0ZmllbGRfY2hhbm5lbDsNCiAJdW5zaWduZWQgcmVhZF9iaXRzID0gMDsNCi0JdW5z
aWduZWQgajsNCisJaW50IGxhc3RfcG9ydF9vZmZzZXQgPSBuaV82NXh4X3BvcnRfYnlfY2hhbm5l
bChzLT5uX2NoYW4gLSAxKTsNCisJaW50IHBvcnRfb2Zmc2V0Ow0KKw0KIAlpZiAoaW5zbi0+biAh
PSAyKQ0KIAkJcmV0dXJuIC1FSU5WQUw7DQogCWJhc2VfYml0ZmllbGRfY2hhbm5lbCA9IENSX0NI
QU4oaW5zbi0+Y2hhbnNwZWMpOw0KLQlmb3IgKGogPSAwOyBqIDwgbWF4X3BvcnRzX3Blcl9iaXRm
aWVsZDsgKytqKSB7DQotCQljb25zdCB1bnNpZ25lZCBwb3J0X29mZnNldCA9DQotCQkJbmlfNjV4
eF9wb3J0X2J5X2NoYW5uZWwoYmFzZV9iaXRmaWVsZF9jaGFubmVsKSArIGo7DQotCQljb25zdCB1
bnNpZ25lZCBwb3J0ID0NCi0JCQlzcHJpdmF0ZShzKS0+YmFzZV9wb3J0ICsgcG9ydF9vZmZzZXQ7
DQotCQl1bnNpZ25lZCBiYXNlX3BvcnRfY2hhbm5lbDsNCisJZm9yIChwb3J0X29mZnNldCA9IG5p
XzY1eHhfcG9ydF9ieV9jaGFubmVsKGJhc2VfYml0ZmllbGRfY2hhbm5lbCk7DQorCSAgICAgcG9y
dF9vZmZzZXQgPD0gbGFzdF9wb3J0X29mZnNldDsgcG9ydF9vZmZzZXQrKykgew0KKwkJdW5zaWdu
ZWQgcG9ydCA9IHNwcml2YXRlKHMpLT5iYXNlX3BvcnQgKyBwb3J0X29mZnNldDsNCisJCWludCBi
YXNlX3BvcnRfY2hhbm5lbCA9IHBvcnRfb2Zmc2V0ICogbmlfNjV4eF9jaGFubmVsc19wZXJfcG9y
dDsNCiAJCXVuc2lnbmVkIHBvcnRfbWFzaywgcG9ydF9kYXRhLCBwb3J0X3JlYWRfYml0czsNCi0J
CWludCBiaXRzaGlmdDsNCi0JCWlmIChwb3J0ID49IG5pXzY1eHhfdG90YWxfbnVtX3BvcnRzKGJv
YXJkKGRldikpKQ0KKwkJaW50IGJpdHNoaWZ0ID0gYmFzZV9wb3J0X2NoYW5uZWwgLSBiYXNlX2Jp
dGZpZWxkX2NoYW5uZWw7DQorDQorCQlpZiAoYml0c2hpZnQgPj0gMzIpDQogCQkJYnJlYWs7DQot
CQliYXNlX3BvcnRfY2hhbm5lbCA9IHBvcnRfb2Zmc2V0ICogbmlfNjV4eF9jaGFubmVsc19wZXJf
cG9ydDsNCiAJCXBvcnRfbWFzayA9IGRhdGFbMF07DQogCQlwb3J0X2RhdGEgPSBkYXRhWzFdOw0K
LQkJYml0c2hpZnQgPSBiYXNlX3BvcnRfY2hhbm5lbCAtIGJhc2VfYml0ZmllbGRfY2hhbm5lbDsN
Ci0JCWlmIChiaXRzaGlmdCA+PSAzMiB8fCBiaXRzaGlmdCA8PSAtMzIpDQotCQkJYnJlYWs7DQog
CQlpZiAoYml0c2hpZnQgPiAwKSB7DQogCQkJcG9ydF9tYXNrID4+PSBiaXRzaGlmdDsNCiAJCQlw
b3J0X2RhdGEgPj49IGJpdHNoaWZ0Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy92dDY2
NTYvbWFpbl91c2IuYyBiL2RyaXZlcnMvc3RhZ2luZy92dDY2NTYvbWFpbl91c2IuYw0KaW5kZXgg
NzU0ZDU0ZS4uZjY4MDc2NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy92dDY2NTYvbWFp
bl91c2IuYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3Z0NjY1Ni9tYWluX3VzYi5jDQpAQCAtMTIy
MSw2ICsxMjIxLDggQEAgZGV2aWNlX3JlbGVhc2VfV1BBREVWKHBEZXZpY2UpOw0KICAgICBtZW1z
ZXQocE1nbXQtPmFieUN1cnJCU1NJRCwgMCwgNik7DQogICAgIHBNZ210LT5lQ3VyclN0YXRlID0g
V01BQ19TVEFURV9JRExFOw0KIA0KKwlwRGV2aWNlLT5mbGFncyAmPSB+REVWSUNFX0ZMQUdTX09Q
RU5FRDsNCisNCiAgICAgZGV2aWNlX2ZyZWVfdHhfYnVmcyhwRGV2aWNlKTsNCiAgICAgZGV2aWNl
X2ZyZWVfcnhfYnVmcyhwRGV2aWNlKTsNCiAgICAgZGV2aWNlX2ZyZWVfaW50X2J1ZnMocERldmlj
ZSk7DQpAQCAtMTIzMiw3ICsxMjM0LDYgQEAgZGV2aWNlX3JlbGVhc2VfV1BBREVWKHBEZXZpY2Up
Ow0KICAgICB1c2JfZnJlZV91cmIocERldmljZS0+cEludGVycnVwdFVSQik7DQogDQogICAgIEJT
U3ZDbGVhck5vZGVEQlRhYmxlKHBEZXZpY2UsIDApOw0KLSAgICBwRGV2aWNlLT5mbGFncyAmPSh+
REVWSUNFX0ZMQUdTX09QRU5FRCk7DQogDQogICAgIERCR19QUlQoTVNHX0xFVkVMX0RFQlVHLCBL
RVJOX0lORk8gImRldmljZV9jbG9zZTIgXG4iKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvenJhbS96cmFtX2Rydi5jIGIvZHJpdmVycy9zdGFnaW5nL3pyYW0venJhbV9kcnYuYw0K
aW5kZXggOTI2ZDQ4My4uZDE5N2IzZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy96cmFt
L3pyYW1fZHJ2LmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy96cmFtL3pyYW1fZHJ2LmMNCkBAIC03
MDksOSArNzA5LDcgQEAgc3RhdGljIHZvaWQgenJhbV9zbG90X2ZyZWVfbm90aWZ5KHN0cnVjdCBi
bG9ja19kZXZpY2UgKmJkZXYsDQogCXN0cnVjdCB6cmFtICp6cmFtOw0KIA0KIAl6cmFtID0gYmRl
di0+YmRfZGlzay0+cHJpdmF0ZV9kYXRhOw0KLQlkb3duX3dyaXRlKCZ6cmFtLT5sb2NrKTsNCiAJ
enJhbV9mcmVlX3BhZ2UoenJhbSwgaW5kZXgpOw0KLQl1cF93cml0ZSgmenJhbS0+bG9jayk7DQog
CXpyYW1fc3RhdDY0X2luYyh6cmFtLCAmenJhbS0+c3RhdHMubm90aWZ5X2ZyZWUpOw0KIH0NCiAN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvenJhbS96cmFtX2Rydi5oIGIvZHJpdmVycy9z
dGFnaW5nL3pyYW0venJhbV9kcnYuaA0KaW5kZXggODdmMmZlYy4uZTVjZDI0NiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvc3RhZ2luZy96cmFtL3pyYW1fZHJ2LmgNCisrKyBiL2RyaXZlcnMvc3RhZ2lu
Zy96cmFtL3pyYW1fZHJ2LmgNCkBAIC0xMDcsOSArMTA3LDggQEAgc3RydWN0IHpyYW0gew0KIAl2
b2lkICpjb21wcmVzc19idWZmZXI7DQogCXN0cnVjdCB0YWJsZSAqdGFibGU7DQogCXNwaW5sb2Nr
X3Qgc3RhdDY0X2xvY2s7CS8qIHByb3RlY3QgNjQtYml0IHN0YXRzICovDQotCXN0cnVjdCByd19z
ZW1hcGhvcmUgbG9jazsgLyogcHJvdGVjdCBjb21wcmVzc2lvbiBidWZmZXJzLCB0YWJsZSwNCi0J
CQkJICAgKiAzMmJpdCBzdGF0IGNvdW50ZXJzIGFnYWluc3QgY29uY3VycmVudA0KLQkJCQkgICAq
IG5vdGlmaWNhdGlvbnMsIHJlYWRzIGFuZCB3cml0ZXMgKi8NCisJc3RydWN0IHJ3X3NlbWFwaG9y
ZSBsb2NrOyAvKiBwcm90ZWN0IGNvbXByZXNzaW9uIGJ1ZmZlcnMgYW5kIHRhYmxlDQorCQkJCSAg
ICogYWdhaW5zdCBjb25jdXJyZW50IHJlYWQgYW5kIHdyaXRlcyAqLw0KIAlzdHJ1Y3QgcmVxdWVz
dF9xdWV1ZSAqcXVldWU7DQogCXN0cnVjdCBnZW5kaXNrICpkaXNrOw0KIAlpbnQgaW5pdF9kb25l
Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdHR5L3NlcmlhbC9wY2hfdWFydC5jIGIvZHJpdmVycy90
dHkvc2VyaWFsL3BjaF91YXJ0LmMNCmluZGV4IGMwYjQ4NzIuLmY1NDQwYTcgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3R0eS9zZXJpYWwvcGNoX3VhcnQuYw0KKysrIGIvZHJpdmVycy90dHkvc2VyaWFs
L3BjaF91YXJ0LmMNCkBAIC01NTIsMTEgKzU1MiwxMiBAQCBzdGF0aWMgaW50IGRtYV9wdXNoX3J4
KHN0cnVjdCBlZzIwdF9wb3J0ICpwcml2LCBpbnQgc2l6ZSkNCiAJCWRldl93YXJuKHBvcnQtPmRl
diwgIlJ4IG92ZXJydW46IGRyb3BwaW5nICV1IGJ5dGVzXG4iLA0KIAkJCSBzaXplIC0gcm9vbSk7
DQogCWlmICghcm9vbSkNCi0JCXJldHVybiByb29tOw0KKwkJZ290byBvdXQ7DQogDQogCXR0eV9p
bnNlcnRfZmxpcF9zdHJpbmcodHR5LCBzZ192aXJ0KCZwcml2LT5zZ19yeCksIHNpemUpOw0KIA0K
IAlwb3J0LT5pY291bnQucnggKz0gcm9vbTsNCitvdXQ6DQogCXR0eV9rcmVmX3B1dCh0dHkpOw0K
IA0KIAlyZXR1cm4gcm9vbTsNCkBAIC05NzAsNiArOTcxLDggQEAgc3RhdGljIHZvaWQgcGNoX3Vh
cnRfZXJyX2lyKHN0cnVjdCBlZzIwdF9wb3J0ICpwcml2LCB1bnNpZ25lZCBpbnQgbHNyKQ0KIAlp
ZiAodHR5ID09IE5VTEwpIHsNCiAJCWZvciAoaSA9IDA7IGVycm9yX21zZ1tpXSAhPSBOVUxMOyBp
KyspDQogCQkJZGV2X2VycigmcHJpdi0+cGRldi0+ZGV2LCBlcnJvcl9tc2dbaV0pOw0KKwl9IGVs
c2Ugew0KKwkJdHR5X2tyZWZfcHV0KHR0eSk7DQogCX0NCiB9DQogDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy91c2IvY2xhc3MvY2RjLXdkbS5jIGIvZHJpdmVycy91c2IvY2xhc3MvY2RjLXdkbS5jDQpp
bmRleCBmZThjMDRiLi4wNmRmYjRmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2IvY2xhc3MvY2Rj
LXdkbS5jDQorKysgYi9kcml2ZXJzL3VzYi9jbGFzcy9jZGMtd2RtLmMNCkBAIC0xODcsNiArMTg3
LDcgQEAgc2tpcF9lcnJvcjoNCiBzdGF0aWMgdm9pZCB3ZG1faW50X2NhbGxiYWNrKHN0cnVjdCB1
cmIgKnVyYikNCiB7DQogCWludCBydiA9IDA7DQorCWludCByZXNwb25kaW5nOw0KIAlpbnQgc3Rh
dHVzID0gdXJiLT5zdGF0dXM7DQogCXN0cnVjdCB3ZG1fZGV2aWNlICpkZXNjOw0KIAlzdHJ1Y3Qg
dXNiX2N0cmxyZXF1ZXN0ICpyZXE7DQpAQCAtMjYwLDggKzI2MSw4IEBAIHN0YXRpYyB2b2lkIHdk
bV9pbnRfY2FsbGJhY2soc3RydWN0IHVyYiAqdXJiKQ0KIAlkZXNjLT5yZXNwb25zZS0+dHJhbnNm
ZXJfZmxhZ3MgfD0gVVJCX05PX1RSQU5TRkVSX0RNQV9NQVA7DQogCXNwaW5fbG9jaygmZGVzYy0+
aXVzcGluKTsNCiAJY2xlYXJfYml0KFdETV9SRUFELCAmZGVzYy0+ZmxhZ3MpOw0KLQlzZXRfYml0
KFdETV9SRVNQT05ESU5HLCAmZGVzYy0+ZmxhZ3MpOw0KLQlpZiAoIXRlc3RfYml0KFdETV9ESVND
T05ORUNUSU5HLCAmZGVzYy0+ZmxhZ3MpDQorCXJlc3BvbmRpbmcgPSB0ZXN0X2FuZF9zZXRfYml0
KFdETV9SRVNQT05ESU5HLCAmZGVzYy0+ZmxhZ3MpOw0KKwlpZiAoIXJlc3BvbmRpbmcgJiYgIXRl
c3RfYml0KFdETV9ESVNDT05ORUNUSU5HLCAmZGVzYy0+ZmxhZ3MpDQogCQkmJiAhdGVzdF9iaXQo
V0RNX1NVU1BFTkRJTkcsICZkZXNjLT5mbGFncykpIHsNCiAJCXJ2ID0gdXNiX3N1Ym1pdF91cmIo
ZGVzYy0+cmVzcG9uc2UsIEdGUF9BVE9NSUMpOw0KIAkJZGV2X2RiZygmZGVzYy0+aW50Zi0+ZGV2
LCAiJXM6IHVzYl9zdWJtaXRfdXJiICVkIiwNCkBAIC02NTgsMTYgKzY1OSwyMCBAQCBzdGF0aWMg
dm9pZCB3ZG1fcnh3b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiB7DQogCXN0cnVjdCB3
ZG1fZGV2aWNlICpkZXNjID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCB3ZG1fZGV2aWNlLCBy
eHdvcmspOw0KIAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KLQlpbnQgcnY7DQorCWludCBydiA9IDA7
DQorCWludCByZXNwb25kaW5nOw0KIA0KIAlzcGluX2xvY2tfaXJxc2F2ZSgmZGVzYy0+aXVzcGlu
LCBmbGFncyk7DQogCWlmICh0ZXN0X2JpdChXRE1fRElTQ09OTkVDVElORywgJmRlc2MtPmZsYWdz
KSkgew0KIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZGVzYy0+aXVzcGluLCBmbGFncyk7DQog
CX0gZWxzZSB7DQorCQlyZXNwb25kaW5nID0gdGVzdF9hbmRfc2V0X2JpdChXRE1fUkVTUE9ORElO
RywgJmRlc2MtPmZsYWdzKTsNCiAJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmRlc2MtPml1c3Bp
biwgZmxhZ3MpOw0KLQkJcnYgPSB1c2Jfc3VibWl0X3VyYihkZXNjLT5yZXNwb25zZSwgR0ZQX0tF
Uk5FTCk7DQorCQlpZiAoIXJlc3BvbmRpbmcpDQorCQkJcnYgPSB1c2Jfc3VibWl0X3VyYihkZXNj
LT5yZXNwb25zZSwgR0ZQX0tFUk5FTCk7DQogCQlpZiAocnYgPCAwICYmIHJ2ICE9IC1FUEVSTSkg
ew0KIAkJCXNwaW5fbG9ja19pcnFzYXZlKCZkZXNjLT5pdXNwaW4sIGZsYWdzKTsNCisJCQljbGVh
cl9iaXQoV0RNX1JFU1BPTkRJTkcsICZkZXNjLT5mbGFncyk7DQogCQkJaWYgKCF0ZXN0X2JpdChX
RE1fRElTQ09OTkVDVElORywgJmRlc2MtPmZsYWdzKSkNCiAJCQkJc2NoZWR1bGVfd29yaygmZGVz
Yy0+cnh3b3JrKTsNCiAJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZkZXNjLT5pdXNwaW4sIGZs
YWdzKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9jb3JlL2NvbmZpZy5jIGIvZHJpdmVycy91
c2IvY29yZS9jb25maWcuYw0KaW5kZXggZjRiZGQwYy4uNzg2MDlkMyAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvdXNiL2NvcmUvY29uZmlnLmMNCisrKyBiL2RyaXZlcnMvdXNiL2NvcmUvY29uZmlnLmMN
CkBAIC00MjQsNyArNDI0LDggQEAgc3RhdGljIGludCB1c2JfcGFyc2VfY29uZmlndXJhdGlvbihz
dHJ1Y3QgdXNiX2RldmljZSAqZGV2LCBpbnQgY2ZnaWR4LA0KIA0KIAltZW1jcHkoJmNvbmZpZy0+
ZGVzYywgYnVmZmVyLCBVU0JfRFRfQ09ORklHX1NJWkUpOw0KIAlpZiAoY29uZmlnLT5kZXNjLmJE
ZXNjcmlwdG9yVHlwZSAhPSBVU0JfRFRfQ09ORklHIHx8DQotCSAgICBjb25maWctPmRlc2MuYkxl
bmd0aCA8IFVTQl9EVF9DT05GSUdfU0laRSkgew0KKwkgICAgY29uZmlnLT5kZXNjLmJMZW5ndGgg
PCBVU0JfRFRfQ09ORklHX1NJWkUgfHwNCisJICAgIGNvbmZpZy0+ZGVzYy5iTGVuZ3RoID4gc2l6
ZSkgew0KIAkJZGV2X2VycihkZGV2LCAiaW52YWxpZCBkZXNjcmlwdG9yIGZvciBjb25maWcgaW5k
ZXggJWQ6ICINCiAJCSAgICAidHlwZSA9IDB4JVgsIGxlbmd0aCA9ICVkXG4iLCBjZmdpZHgsDQog
CQkgICAgY29uZmlnLT5kZXNjLmJEZXNjcmlwdG9yVHlwZSwgY29uZmlnLT5kZXNjLmJMZW5ndGgp
Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NvcmUvZGV2aW8uYyBiL2RyaXZlcnMvdXNiL2Nv
cmUvZGV2aW8uYw0KaW5kZXggMjJmNzcwYS4uNDkyNTdiMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
dXNiL2NvcmUvZGV2aW8uYw0KKysrIGIvZHJpdmVycy91c2IvY29yZS9kZXZpby5jDQpAQCAtNjQ2
LDYgKzY0NiwyMiBAQCBzdGF0aWMgaW50IGNoZWNrX2N0cmxyZWNpcChzdHJ1Y3QgZGV2X3N0YXRl
ICpwcywgdW5zaWduZWQgaW50IHJlcXVlc3R0eXBlLA0KIAkJaWYgKChpbmRleCAmIH5VU0JfRElS
X0lOKSA9PSAwKQ0KIAkJCXJldHVybiAwOw0KIAkJcmV0ID0gZmluZGludGZlcChwcy0+ZGV2LCBp
bmRleCk7DQorCQlpZiAocmV0IDwgMCkgew0KKwkJCS8qDQorCQkJICogU29tZSBub3QgZnVsbHkg
Y29tcGxpYW50IFdpbiBhcHBzIHNlZW0gdG8gZ2V0DQorCQkJICogaW5kZXggd3JvbmcgYW5kIGhh
dmUgdGhlIGVuZHBvaW50IG51bWJlciBoZXJlDQorCQkJICogcmF0aGVyIHRoYW4gdGhlIGVuZHBv
aW50IGFkZHJlc3MgKHdpdGggdGhlDQorCQkJICogY29ycmVjdCBkaXJlY3Rpb24pLiBXaW4gZG9l
cyBsZXQgdGhpcyB0aHJvdWdoLA0KKwkJCSAqIHNvIHdlJ2xsIG5vdCByZWplY3QgaXQgaGVyZSBi
dXQgbGVhdmUgaXQgdG8NCisJCQkgKiB0aGUgZGV2aWNlIHRvIG5vdCBicmVhayBLVk0uIEJ1dCB3
ZSB3YXJuLg0KKwkJCSAqLw0KKwkJCXJldCA9IGZpbmRpbnRmZXAocHMtPmRldiwgaW5kZXggXiAw
eDgwKTsNCisJCQlpZiAocmV0ID49IDApDQorCQkJCWRldl9pbmZvKCZwcy0+ZGV2LT5kZXYsDQor
CQkJCQkiJXM6IHByb2Nlc3MgJWkgKCVzKSByZXF1ZXN0aW5nIGVwICUwMnggYnV0IG5lZWRzICUw
MnhcbiIsDQorCQkJCQlfX2Z1bmNfXywgdGFza19waWRfbnIoY3VycmVudCksDQorCQkJCQljdXJy
ZW50LT5jb21tLCBpbmRleCwgaW5kZXggXiAweDgwKTsNCisJCX0NCiAJCWlmIChyZXQgPj0gMCkN
CiAJCQlyZXQgPSBjaGVja2ludGYocHMsIHJldCk7DQogCQlicmVhazsNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3VzYi9jb3JlL2h1Yi5jIGIvZHJpdmVycy91c2IvY29yZS9odWIuYw0KaW5kZXggMjc2
OGE3ZS4uYTVlYTg1ZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2NvcmUvaHViLmMNCisrKyBi
L2RyaXZlcnMvdXNiL2NvcmUvaHViLmMNCkBAIC0zNzQ5LDcgKzM3NDksOCBAQCBzdGF0aWMgdm9p
ZCBodWJfZXZlbnRzKHZvaWQpDQogCQkJCQlodWItPmhkZXYtPmNoaWxkcmVuW2kgLSAxXTsNCiAN
CiAJCQkJZGV2X2RiZyhodWJfZGV2LCAid2FybSByZXNldCBwb3J0ICVkXG4iLCBpKTsNCi0JCQkJ
aWYgKCF1ZGV2KSB7DQorCQkJCWlmICghdWRldiB8fCAhKHBvcnRzdGF0dXMgJg0KKwkJCQkJCVVT
Ql9QT1JUX1NUQVRfQ09OTkVDVElPTikpIHsNCiAJCQkJCXN0YXR1cyA9IGh1Yl9wb3J0X3Jlc2V0
KGh1YiwgaSwNCiAJCQkJCQkJTlVMTCwgSFVCX0JIX1JFU0VUX1RJTUUsDQogCQkJCQkJCXRydWUp
Ow0KQEAgLTM3NTksOCArMzc2MCw4IEBAIHN0YXRpYyB2b2lkIGh1Yl9ldmVudHModm9pZCkNCiAJ
CQkJCXVzYl9sb2NrX2RldmljZSh1ZGV2KTsNCiAJCQkJCXN0YXR1cyA9IHVzYl9yZXNldF9kZXZp
Y2UodWRldik7DQogCQkJCQl1c2JfdW5sb2NrX2RldmljZSh1ZGV2KTsNCisJCQkJCWNvbm5lY3Rf
Y2hhbmdlID0gMDsNCiAJCQkJfQ0KLQkJCQljb25uZWN0X2NoYW5nZSA9IDA7DQogCQkJfQ0KIA0K
IAkJCWlmIChjb25uZWN0X2NoYW5nZSkNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9kd2MzL2R3
YzMtcGNpLmMgYi9kcml2ZXJzL3VzYi9kd2MzL2R3YzMtcGNpLmMNCmluZGV4IGY3N2MwMDAuLjll
ZGM1ODIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2R3YzMtcGNpLmMNCisrKyBiL2Ry
aXZlcnMvdXNiL2R3YzMvZHdjMy1wY2kuYw0KQEAgLTQ1LDYgKzQ1LDggQEANCiAvKiBGSVhNRSBk
ZWZpbmUgdGhlc2UgaW4gPGxpbnV4L3BjaV9pZHMuaD4gKi8NCiAjZGVmaW5lIFBDSV9WRU5ET1Jf
SURfU1lOT1BTWVMJCTB4MTZjMw0KICNkZWZpbmUgUENJX0RFVklDRV9JRF9TWU5PUFNZU19IQVBT
VVNCMwkweGFiY2QNCisjZGVmaW5lIFBDSV9ERVZJQ0VfSURfSU5URUxfQllUCQkweDBmMzcNCisj
ZGVmaW5lIFBDSV9ERVZJQ0VfSURfSU5URUxfTVJGTEQJMHgxMTllDQogDQogI2RlZmluZSBEV0Mz
X1BDSV9ERVZTX1BPU1NJQkxFCTMyDQogDQpAQCAtMTkxLDYgKzE5Myw4IEBAIHN0YXRpYyBERUZJ
TkVfUENJX0RFVklDRV9UQUJMRShkd2MzX3BjaV9pZF90YWJsZSkgPSB7DQogCQlQQ0lfREVWSUNF
KFBDSV9WRU5ET1JfSURfU1lOT1BTWVMsDQogCQkJCVBDSV9ERVZJQ0VfSURfU1lOT1BTWVNfSEFQ
U1VTQjMpLA0KIAl9LA0KKwl7IFBDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9JTlRFTCwgUENJX0RF
VklDRV9JRF9JTlRFTF9CWVQpLCB9LA0KKwl7IFBDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9JTlRF
TCwgUENJX0RFVklDRV9JRF9JTlRFTF9NUkZMRCksIH0sDQogCXsgIH0JLyogVGVybWluYXRpbmcg
RW50cnkgKi8NCiB9Ow0KIE1PRFVMRV9ERVZJQ0VfVEFCTEUocGNpLCBkd2MzX3BjaV9pZF90YWJs
ZSk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvaG9zdC9laGNpLW14Yy5jIGIvZHJpdmVycy91
c2IvaG9zdC9laGNpLW14Yy5jDQppbmRleCA1NTk3OGZjLi4wODc0NDczIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy91c2IvaG9zdC9laGNpLW14Yy5jDQorKysgYi9kcml2ZXJzL3VzYi9ob3N0L2VoY2kt
bXhjLmMNCkBAIC0yOTYsNyArMjk2LDcgQEAgc3RhdGljIGludCBfX2V4aXQgZWhjaV9teGNfZHJ2
X3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KIAlpZiAocGRhdGEgJiYgcGRh
dGEtPmV4aXQpDQogCQlwZGF0YS0+ZXhpdChwZGV2KTsNCiANCi0JaWYgKHBkYXRhLT5vdGcpDQor
CWlmIChwZGF0YSAmJiBwZGF0YS0+b3RnKQ0KIAkJb3RnX3NodXRkb3duKHBkYXRhLT5vdGcpOw0K
IA0KIAl1c2JfcmVtb3ZlX2hjZChoY2QpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3Qv
ZWhjaS1wY2kuYyBiL2RyaXZlcnMvdXNiL2hvc3QvZWhjaS1wY2kuYw0KaW5kZXggYjcxZTIyZS4u
MjljMDQyMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2hvc3QvZWhjaS1wY2kuYw0KKysrIGIv
ZHJpdmVycy91c2IvaG9zdC9laGNpLXBjaS5jDQpAQCAtNTQzLDcgKzU0Myw3IEBAIHN0YXRpYyBz
dHJ1Y3QgcGNpX2RyaXZlciBlaGNpX3BjaV9kcml2ZXIgPSB7DQogCS5yZW1vdmUgPQl1c2JfaGNk
X3BjaV9yZW1vdmUsDQogCS5zaHV0ZG93biA9IAl1c2JfaGNkX3BjaV9zaHV0ZG93biwNCiANCi0j
aWZkZWYgQ09ORklHX1BNX1NMRUVQDQorI2lmZGVmIENPTkZJR19QTQ0KIAkuZHJpdmVyID0Jew0K
IAkJLnBtID0JJnVzYl9oY2RfcGNpX3BtX29wcw0KIAl9LA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dXNiL2hvc3Qvb2hjaS1wY2kuYyBiL2RyaXZlcnMvdXNiL2hvc3Qvb2hjaS1wY2kuYw0KaW5kZXgg
YmMwMWIwNi4uODM5Y2I2NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2hvc3Qvb2hjaS1wY2ku
Yw0KKysrIGIvZHJpdmVycy91c2IvaG9zdC9vaGNpLXBjaS5jDQpAQCAtNDEzLDcgKzQxMyw3IEBA
IHN0YXRpYyBzdHJ1Y3QgcGNpX2RyaXZlciBvaGNpX3BjaV9kcml2ZXIgPSB7DQogCS5yZW1vdmUg
PQl1c2JfaGNkX3BjaV9yZW1vdmUsDQogCS5zaHV0ZG93biA9CXVzYl9oY2RfcGNpX3NodXRkb3du
LA0KIA0KLSNpZmRlZiBDT05GSUdfUE1fU0xFRVANCisjaWZkZWYgQ09ORklHX1BNDQogCS5kcml2
ZXIgPQl7DQogCQkucG0gPQkmdXNiX2hjZF9wY2lfcG1fb3BzDQogCX0sDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy91c2IvaG9zdC91aGNpLXBjaS5jIGIvZHJpdmVycy91c2IvaG9zdC91aGNpLXBjaS5j
DQppbmRleCBjMzAwYmQyZjcuLjBmMjI4YzQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9ob3N0
L3VoY2ktcGNpLmMNCisrKyBiL2RyaXZlcnMvdXNiL2hvc3QvdWhjaS1wY2kuYw0KQEAgLTI5Myw3
ICsyOTMsNyBAQCBzdGF0aWMgc3RydWN0IHBjaV9kcml2ZXIgdWhjaV9wY2lfZHJpdmVyID0gew0K
IAkucmVtb3ZlID0JdXNiX2hjZF9wY2lfcmVtb3ZlLA0KIAkuc2h1dGRvd24gPQl1aGNpX3NodXRk
b3duLA0KIA0KLSNpZmRlZiBDT05GSUdfUE1fU0xFRVANCisjaWZkZWYgQ09ORklHX1BNDQogCS5k
cml2ZXIgPQl7DQogCQkucG0gPQkmdXNiX2hjZF9wY2lfcG1fb3BzDQogCX0sDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy91c2IvaG9zdC94aGNpLXBjaS5jIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLXBj
aS5jDQppbmRleCA3OWQyNzIwLi42MWIwNjY4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2IvaG9z
dC94aGNpLXBjaS5jDQorKysgYi9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktcGNpLmMNCkBAIC0zMzAs
NyArMzMwLDcgQEAgc3RhdGljIHN0cnVjdCBwY2lfZHJpdmVyIHhoY2lfcGNpX2RyaXZlciA9IHsN
CiAJLyogc3VzcGVuZCBhbmQgcmVzdW1lIGltcGxlbWVudGVkIGxhdGVyICovDQogDQogCS5zaHV0
ZG93biA9IAl1c2JfaGNkX3BjaV9zaHV0ZG93biwNCi0jaWZkZWYgQ09ORklHX1BNX1NMRUVQDQor
I2lmZGVmIENPTkZJR19QTQ0KIAkuZHJpdmVyID0gew0KIAkJLnBtID0gJnVzYl9oY2RfcGNpX3Bt
X29wcw0KIAl9LA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1yaW5nLmMgYi9k
cml2ZXJzL3VzYi9ob3N0L3hoY2ktcmluZy5jDQppbmRleCA2MzM0NzZlLi4yYjRmNDJiIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy91c2IvaG9zdC94aGNpLXJpbmcuYw0KKysrIGIvZHJpdmVycy91c2Iv
aG9zdC94aGNpLXJpbmcuYw0KQEAgLTg3OSw4ICs4NzksMTIgQEAgcmVtb3ZlX2ZpbmlzaGVkX3Rk
Og0KIAkJLyogT3RoZXJ3aXNlIHJpbmcgdGhlIGRvb3JiZWxsKHMpIHRvIHJlc3RhcnQgcXVldWVk
IHRyYW5zZmVycyAqLw0KIAkJcmluZ19kb29yYmVsbF9mb3JfYWN0aXZlX3JpbmdzKHhoY2ksIHNs
b3RfaWQsIGVwX2luZGV4KTsNCiAJfQ0KLQllcC0+c3RvcHBlZF90ZCA9IE5VTEw7DQotCWVwLT5z
dG9wcGVkX3RyYiA9IE5VTEw7DQorDQorCS8qIENsZWFyIHN0b3BwZWRfdGQgYW5kIHN0b3BwZWRf
dHJiIGlmIGVuZHBvaW50IGlzIG5vdCBoYWx0ZWQgKi8NCisJaWYgKCEoZXAtPmVwX3N0YXRlICYg
RVBfSEFMVEVEKSkgew0KKwkJZXAtPnN0b3BwZWRfdGQgPSBOVUxMOw0KKwkJZXAtPnN0b3BwZWRf
dHJiID0gTlVMTDsNCisJfQ0KIA0KIAkvKg0KIAkgKiBEcm9wIHRoZSBsb2NrIGFuZCBjb21wbGV0
ZSB0aGUgVVJCcyBpbiB0aGUgY2FuY2VsbGVkIFREIGxpc3QuDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy91c2IvaG9zdC94aGNpLmMgYi9kcml2ZXJzL3VzYi9ob3N0L3hoY2kuYw0KaW5kZXggNmUxYzky
YS4uNjI5YWE3NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS5jDQorKysgYi9k
cml2ZXJzL3VzYi9ob3N0L3hoY2kuYw0KQEAgLTM0ODQsMTAgKzM0ODQsMjEgQEAgdm9pZCB4aGNp
X2ZyZWVfZGV2KHN0cnVjdCB1c2JfaGNkICpoY2QsIHN0cnVjdCB1c2JfZGV2aWNlICp1ZGV2KQ0K
IHsNCiAJc3RydWN0IHhoY2lfaGNkICp4aGNpID0gaGNkX3RvX3hoY2koaGNkKTsNCiAJc3RydWN0
IHhoY2lfdmlydF9kZXZpY2UgKnZpcnRfZGV2Ow0KKwlzdHJ1Y3QgZGV2aWNlICpkZXYgPSBoY2Qt
PnNlbGYuY29udHJvbGxlcjsNCiAJdW5zaWduZWQgbG9uZyBmbGFnczsNCiAJdTMyIHN0YXRlOw0K
IAlpbnQgaSwgcmV0Ow0KIA0KKyNpZm5kZWYgQ09ORklHX1VTQl9ERUZBVUxUX1BFUlNJU1QNCisJ
LyoNCisJICogV2UgY2FsbGVkIHBtX3J1bnRpbWVfZ2V0X25vcmVzdW1lIHdoZW4gdGhlIGRldmlj
ZSB3YXMgYXR0YWNoZWQuDQorCSAqIERlY3JlbWVudCB0aGUgY291bnRlciBoZXJlIHRvIGFsbG93
IGNvbnRyb2xsZXIgdG8gcnVudGltZSBzdXNwZW5kDQorCSAqIGlmIG5vIGRldmljZXMgcmVtYWlu
Lg0KKwkgKi8NCisJaWYgKHhoY2ktPnF1aXJrcyAmIFhIQ0lfUkVTRVRfT05fUkVTVU1FKQ0KKwkJ
cG1fcnVudGltZV9wdXRfbm9pZGxlKGRldik7DQorI2VuZGlmDQorDQogCXJldCA9IHhoY2lfY2hl
Y2tfYXJncyhoY2QsIHVkZXYsIE5VTEwsIDAsIHRydWUsIF9fZnVuY19fKTsNCiAJLyogSWYgdGhl
IGhvc3QgaXMgaGFsdGVkIGR1ZSB0byBkcml2ZXIgdW5sb2FkLCB3ZSBzdGlsbCBuZWVkIHRvIGZy
ZWUgdGhlDQogCSAqIGRldmljZS4NCkBAIC0zNTU5LDYgKzM1NzAsNyBAQCBzdGF0aWMgaW50IHho
Y2lfcmVzZXJ2ZV9ob3N0X2NvbnRyb2xfZXBfcmVzb3VyY2VzKHN0cnVjdCB4aGNpX2hjZCAqeGhj
aSkNCiBpbnQgeGhjaV9hbGxvY19kZXYoc3RydWN0IHVzYl9oY2QgKmhjZCwgc3RydWN0IHVzYl9k
ZXZpY2UgKnVkZXYpDQogew0KIAlzdHJ1Y3QgeGhjaV9oY2QgKnhoY2kgPSBoY2RfdG9feGhjaSho
Y2QpOw0KKwlzdHJ1Y3QgZGV2aWNlICpkZXYgPSBoY2QtPnNlbGYuY29udHJvbGxlcjsNCiAJdW5z
aWduZWQgbG9uZyBmbGFnczsNCiAJaW50IHRpbWVsZWZ0Ow0KIAlpbnQgcmV0Ow0KQEAgLTM2MTEs
NiArMzYyMywxNiBAQCBpbnQgeGhjaV9hbGxvY19kZXYoc3RydWN0IHVzYl9oY2QgKmhjZCwgc3Ry
dWN0IHVzYl9kZXZpY2UgKnVkZXYpDQogCQlnb3RvIGRpc2FibGVfc2xvdDsNCiAJfQ0KIAl1ZGV2
LT5zbG90X2lkID0geGhjaS0+c2xvdF9pZDsNCisNCisjaWZuZGVmIENPTkZJR19VU0JfREVGQVVM
VF9QRVJTSVNUDQorCS8qDQorCSAqIElmIHJlc2V0dGluZyB1cG9uIHJlc3VtZSwgd2UgY2FuJ3Qg
cHV0IHRoZSBjb250cm9sbGVyIGludG8gcnVudGltZQ0KKwkgKiBzdXNwZW5kIGlmIHRoZXJlIGlz
IGEgZGV2aWNlIGF0dGFjaGVkLg0KKwkgKi8NCisJaWYgKHhoY2ktPnF1aXJrcyAmIFhIQ0lfUkVT
RVRfT05fUkVTVU1FKQ0KKwkJcG1fcnVudGltZV9nZXRfbm9yZXN1bWUoZGV2KTsNCisjZW5kaWYN
CisNCiAJLyogSXMgdGhpcyBhIExTIG9yIEZTIGRldmljZSB1bmRlciBhIEhTIGh1Yj8gKi8NCiAJ
LyogSHViIG9yIHBlcmlwaGVyaWFsPyAqLw0KIAlyZXR1cm4gMTsNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3VzYi9zZXJpYWwvbW9zNzcyMC5jIGIvZHJpdmVycy91c2Ivc2VyaWFsL21vczc3MjAuYw0K
aW5kZXggOTI3MGQ1Yy4uOGUwMmZmMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9t
b3M3NzIwLmMNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9tb3M3NzIwLmMNCkBAIC0zODMsNyAr
MzgzLDcgQEAgc3RhdGljIGludCB3cml0ZV9wYXJwb3J0X3JlZ19ub25ibG9jayhzdHJ1Y3QgbW9z
NzcxNV9wYXJwb3J0ICptb3NfcGFycG9ydCwNCiAJCWtmcmVlKHVyYnRyYWNrKTsNCiAJCXJldHVy
biAtRU5PTUVNOw0KIAl9DQotCXVyYnRyYWNrLT5zZXR1cCA9IGttYWxsb2Moc2l6ZW9mKCp1cmJ0
cmFjay0+c2V0dXApLCBHRlBfS0VSTkVMKTsNCisJdXJidHJhY2stPnNldHVwID0ga21hbGxvYyhz
aXplb2YoKnVyYnRyYWNrLT5zZXR1cCksIEdGUF9BVE9NSUMpOw0KIAlpZiAoIXVyYnRyYWNrLT5z
ZXR1cCkgew0KIAkJdXNiX2ZyZWVfdXJiKHVyYnRyYWNrLT51cmIpOw0KIAkJa2ZyZWUodXJidHJh
Y2spOw0KQEAgLTM5MSw4ICszOTEsOCBAQCBzdGF0aWMgaW50IHdyaXRlX3BhcnBvcnRfcmVnX25v
bmJsb2NrKHN0cnVjdCBtb3M3NzE1X3BhcnBvcnQgKm1vc19wYXJwb3J0LA0KIAl9DQogCXVyYnRy
YWNrLT5zZXR1cC0+YlJlcXVlc3RUeXBlID0gKF9fdTgpMHg0MDsNCiAJdXJidHJhY2stPnNldHVw
LT5iUmVxdWVzdCA9IChfX3U4KTB4MGU7DQotCXVyYnRyYWNrLT5zZXR1cC0+d1ZhbHVlID0gZ2V0
X3JlZ192YWx1ZShyZWcsIGR1bW15KTsNCi0JdXJidHJhY2stPnNldHVwLT53SW5kZXggPSBnZXRf
cmVnX2luZGV4KHJlZyk7DQorCXVyYnRyYWNrLT5zZXR1cC0+d1ZhbHVlID0gY3B1X3RvX2xlMTYo
Z2V0X3JlZ192YWx1ZShyZWcsIGR1bW15KSk7DQorCXVyYnRyYWNrLT5zZXR1cC0+d0luZGV4ID0g
Y3B1X3RvX2xlMTYoZ2V0X3JlZ19pbmRleChyZWcpKTsNCiAJdXJidHJhY2stPnNldHVwLT53TGVu
Z3RoID0gMDsNCiAJdXNiX2ZpbGxfY29udHJvbF91cmIodXJidHJhY2stPnVyYiwgdXNiZGV2LA0K
IAkJCSAgICAgdXNiX3NuZGN0cmxwaXBlKHVzYmRldiwgMCksDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy91c2Ivc2VyaWFsL29wdGlvbi5jIGIvZHJpdmVycy91c2Ivc2VyaWFsL29wdGlvbi5jDQppbmRl
eCBjMjEwM2Y0Li41MzZjNGFkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL29wdGlv
bi5jDQorKysgYi9kcml2ZXJzL3VzYi9zZXJpYWwvb3B0aW9uLmMNCkBAIC04MSw2ICs4MSw3IEBA
IHN0YXRpYyB2b2lkIG9wdGlvbl9pbnN0YXRfY2FsbGJhY2soc3RydWN0IHVyYiAqdXJiKTsNCiAN
CiAjZGVmaW5lIEhVQVdFSV9WRU5ET1JfSUQJCQkweDEyRDENCiAjZGVmaW5lIEhVQVdFSV9QUk9E
VUNUX0UxNzMJCQkweDE0MEMNCisjZGVmaW5lIEhVQVdFSV9QUk9EVUNUX0UxNzUwCQkJMHgxNDA2
DQogI2RlZmluZSBIVUFXRUlfUFJPRFVDVF9LNDUwNQkJCTB4MTQ2NA0KICNkZWZpbmUgSFVBV0VJ
X1BST0RVQ1RfSzM3NjUJCQkweDE0NjUNCiAjZGVmaW5lIEhVQVdFSV9QUk9EVUNUX0s0NjA1CQkJ
MHgxNEM2DQpAQCAtNTgxLDYgKzU4Miw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2Rldmlj
ZV9pZCBvcHRpb25faWRzW10gPSB7DQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8o
SFVBV0VJX1ZFTkRPUl9JRCwgMHgxYzIzLCBVU0JfQ0xBU1NfQ09NTSwgMHgwMiwgMHhmZikgfSwN
CiAJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCBIVUFX
RUlfUFJPRFVDVF9FMTczLCAweGZmLCAweGZmLCAweGZmKSwNCiAJCS5kcml2ZXJfaW5mbyA9IChr
ZXJuZWxfdWxvbmdfdCkgJm5ldF9pbnRmMV9ibGFja2xpc3QgfSwNCisJeyBVU0JfREVWSUNFX0FO
RF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCBIVUFXRUlfUFJPRFVDVF9FMTc1MCwg
MHhmZiwgMHhmZiwgMHhmZiksDQorCQkuZHJpdmVyX2luZm8gPSAoa2VybmVsX3Vsb25nX3QpICZu
ZXRfaW50ZjJfYmxhY2tsaXN0IH0sDQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8o
SFVBV0VJX1ZFTkRPUl9JRCwgMHgxNDQxLCBVU0JfQ0xBU1NfQ09NTSwgMHgwMiwgMHhmZikgfSwN
CiAJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweDE0
NDIsIFVTQl9DTEFTU19DT01NLCAweDAyLCAweGZmKSB9LA0KIAl7IFVTQl9ERVZJQ0VfQU5EX0lO
VEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIEhVQVdFSV9QUk9EVUNUX0s0NTA1LCAweGZm
LCAweGZmLCAweGZmKSwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9ncmFudC10YWJsZS5jIGIv
ZHJpdmVycy94ZW4vZ3JhbnQtdGFibGUuYw0KaW5kZXggYmYxYzA5NC4uYjY1N2RlNiAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMveGVuL2dyYW50LXRhYmxlLmMNCisrKyBiL2RyaXZlcnMveGVuL2dyYW50
LXRhYmxlLmMNCkBAIC0zNTUsOSArMzU1LDE4IEBAIHZvaWQgZ250dGFiX3JlcXVlc3RfZnJlZV9j
YWxsYmFjayhzdHJ1Y3QgZ250dGFiX2ZyZWVfY2FsbGJhY2sgKmNhbGxiYWNrLA0KIAkJCQkgIHZv
aWQgKCpmbikodm9pZCAqKSwgdm9pZCAqYXJnLCB1MTYgY291bnQpDQogew0KIAl1bnNpZ25lZCBs
b25nIGZsYWdzOw0KKwlzdHJ1Y3QgZ250dGFiX2ZyZWVfY2FsbGJhY2sgKmNiOw0KKw0KIAlzcGlu
X2xvY2tfaXJxc2F2ZSgmZ250dGFiX2xpc3RfbG9jaywgZmxhZ3MpOw0KLQlpZiAoY2FsbGJhY2st
Pm5leHQpDQotCQlnb3RvIG91dDsNCisNCisJLyogQ2hlY2sgaWYgdGhlIGNhbGxiYWNrIGlzIGFs
cmVhZHkgb24gdGhlIGxpc3QgKi8NCisJY2IgPSBnbnR0YWJfZnJlZV9jYWxsYmFja19saXN0Ow0K
Kwl3aGlsZSAoY2IpIHsNCisJCWlmIChjYiA9PSBjYWxsYmFjaykNCisJCQlnb3RvIG91dDsNCisJ
CWNiID0gY2ItPm5leHQ7DQorCX0NCisNCiAJY2FsbGJhY2stPmZuID0gZm47DQogCWNhbGxiYWNr
LT5hcmcgPSBhcmc7DQogCWNhbGxiYWNrLT5jb3VudCA9IGNvdW50Ow0KZGlmZiAtLWdpdCBhL2Zz
L2RlYnVnZnMvaW5vZGUuYyBiL2ZzL2RlYnVnZnMvaW5vZGUuYw0KaW5kZXggZjNhMjU3ZC4uZmIw
MDFjZCAxMDA2NDQNCi0tLSBhL2ZzL2RlYnVnZnMvaW5vZGUuYw0KKysrIGIvZnMvZGVidWdmcy9p
bm9kZS5jDQpAQCAtMzgwLDggKzM4MCw3IEBAIEVYUE9SVF9TWU1CT0xfR1BMKGRlYnVnZnNfcmVt
b3ZlKTsNCiAgKi8NCiB2b2lkIGRlYnVnZnNfcmVtb3ZlX3JlY3Vyc2l2ZShzdHJ1Y3QgZGVudHJ5
ICpkZW50cnkpDQogew0KLQlzdHJ1Y3QgZGVudHJ5ICpjaGlsZDsNCi0Jc3RydWN0IGRlbnRyeSAq
cGFyZW50Ow0KKwlzdHJ1Y3QgZGVudHJ5ICpjaGlsZCwgKm5leHQsICpwYXJlbnQ7DQogDQogCWlm
ICghZGVudHJ5KQ0KIAkJcmV0dXJuOw0KQEAgLTM5MSw2MSArMzkwLDM3IEBAIHZvaWQgZGVidWdm
c19yZW1vdmVfcmVjdXJzaXZlKHN0cnVjdCBkZW50cnkgKmRlbnRyeSkNCiAJCXJldHVybjsNCiAN
CiAJcGFyZW50ID0gZGVudHJ5Ow0KKyBkb3duOg0KIAltdXRleF9sb2NrKCZwYXJlbnQtPmRfaW5v
ZGUtPmlfbXV0ZXgpOw0KKwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoY2hpbGQsIG5leHQsICZw
YXJlbnQtPmRfc3ViZGlycywgZF91LmRfY2hpbGQpIHsNCisJCWlmICghZGVidWdmc19wb3NpdGl2
ZShjaGlsZCkpDQorCQkJY29udGludWU7DQogDQotCXdoaWxlICgxKSB7DQotCQkvKg0KLQkJICog
V2hlbiBhbGwgZGVudHJpZXMgdW5kZXIgInBhcmVudCIgaGFzIGJlZW4gcmVtb3ZlZCwNCi0JCSAq
IHdhbGsgdXAgdGhlIHRyZWUgdW50aWwgd2UgcmVhY2ggb3VyIHN0YXJ0aW5nIHBvaW50Lg0KLQkJ
ICovDQotCQlpZiAobGlzdF9lbXB0eSgmcGFyZW50LT5kX3N1YmRpcnMpKSB7DQotCQkJbXV0ZXhf
dW5sb2NrKCZwYXJlbnQtPmRfaW5vZGUtPmlfbXV0ZXgpOw0KLQkJCWlmIChwYXJlbnQgPT0gZGVu
dHJ5KQ0KLQkJCQlicmVhazsNCi0JCQlwYXJlbnQgPSBwYXJlbnQtPmRfcGFyZW50Ow0KLQkJCW11
dGV4X2xvY2soJnBhcmVudC0+ZF9pbm9kZS0+aV9tdXRleCk7DQotCQl9DQotCQljaGlsZCA9IGxp
c3RfZW50cnkocGFyZW50LT5kX3N1YmRpcnMubmV4dCwgc3RydWN0IGRlbnRyeSwNCi0JCQkJZF91
LmRfY2hpbGQpOw0KLSBuZXh0X3NpYmxpbmc6DQotDQotCQkvKg0KLQkJICogSWYgImNoaWxkIiBp
c24ndCBlbXB0eSwgd2FsayBkb3duIHRoZSB0cmVlIGFuZA0KLQkJICogcmVtb3ZlIGFsbCBpdHMg
ZGVzY2VuZGFudHMgZmlyc3QuDQotCQkgKi8NCisJCS8qIHBlcmhhcHMgc2ltcGxlX2VtcHR5KGNo
aWxkKSBtYWtlcyBtb3JlIHNlbnNlICovDQogCQlpZiAoIWxpc3RfZW1wdHkoJmNoaWxkLT5kX3N1
YmRpcnMpKSB7DQogCQkJbXV0ZXhfdW5sb2NrKCZwYXJlbnQtPmRfaW5vZGUtPmlfbXV0ZXgpOw0K
IAkJCXBhcmVudCA9IGNoaWxkOw0KLQkJCW11dGV4X2xvY2soJnBhcmVudC0+ZF9pbm9kZS0+aV9t
dXRleCk7DQotCQkJY29udGludWU7DQotCQl9DQotCQlfX2RlYnVnZnNfcmVtb3ZlKGNoaWxkLCBw
YXJlbnQpOw0KLQkJaWYgKHBhcmVudC0+ZF9zdWJkaXJzLm5leHQgPT0gJmNoaWxkLT5kX3UuZF9j
aGlsZCkgew0KLQkJCS8qDQotCQkJICogVHJ5IHRoZSBuZXh0IHNpYmxpbmcuDQotCQkJICovDQot
CQkJaWYgKGNoaWxkLT5kX3UuZF9jaGlsZC5uZXh0ICE9ICZwYXJlbnQtPmRfc3ViZGlycykgew0K
LQkJCQljaGlsZCA9IGxpc3RfZW50cnkoY2hpbGQtPmRfdS5kX2NoaWxkLm5leHQsDQotCQkJCQkJ
ICAgc3RydWN0IGRlbnRyeSwNCi0JCQkJCQkgICBkX3UuZF9jaGlsZCk7DQotCQkJCWdvdG8gbmV4
dF9zaWJsaW5nOw0KLQkJCX0NCi0NCi0JCQkvKg0KLQkJCSAqIEF2b2lkIGluZmluaXRlIGxvb3Ag
aWYgd2UgZmFpbCB0byByZW1vdmUNCi0JCQkgKiBvbmUgZGVudHJ5Lg0KLQkJCSAqLw0KLQkJCW11
dGV4X3VubG9jaygmcGFyZW50LT5kX2lub2RlLT5pX211dGV4KTsNCi0JCQlicmVhazsNCisJCQln
b3RvIGRvd247DQogCQl9DQotCQlzaW1wbGVfcmVsZWFzZV9mcygmZGVidWdmc19tb3VudCwgJmRl
YnVnZnNfbW91bnRfY291bnQpOw0KKyB1cDoNCisJCWlmICghX19kZWJ1Z2ZzX3JlbW92ZShjaGls
ZCwgcGFyZW50KSkNCisJCQlzaW1wbGVfcmVsZWFzZV9mcygmZGVidWdmc19tb3VudCwgJmRlYnVn
ZnNfbW91bnRfY291bnQpOw0KIAl9DQogDQotCXBhcmVudCA9IGRlbnRyeS0+ZF9wYXJlbnQ7DQor
CW11dGV4X3VubG9jaygmcGFyZW50LT5kX2lub2RlLT5pX211dGV4KTsNCisJY2hpbGQgPSBwYXJl
bnQ7DQorCXBhcmVudCA9IHBhcmVudC0+ZF9wYXJlbnQ7DQogCW11dGV4X2xvY2soJnBhcmVudC0+
ZF9pbm9kZS0+aV9tdXRleCk7DQotCV9fZGVidWdmc19yZW1vdmUoZGVudHJ5LCBwYXJlbnQpOw0K
Kw0KKwlpZiAoY2hpbGQgIT0gZGVudHJ5KSB7DQorCQluZXh0ID0gbGlzdF9lbnRyeShjaGlsZC0+
ZF91LmRfY2hpbGQubmV4dCwgc3RydWN0IGRlbnRyeSwNCisJCQkJCWRfdS5kX2NoaWxkKTsNCisJ
CWdvdG8gdXA7DQorCX0NCisNCisJaWYgKCFfX2RlYnVnZnNfcmVtb3ZlKGNoaWxkLCBwYXJlbnQp
KQ0KKwkJc2ltcGxlX3JlbGVhc2VfZnMoJmRlYnVnZnNfbW91bnQsICZkZWJ1Z2ZzX21vdW50X2Nv
dW50KTsNCiAJbXV0ZXhfdW5sb2NrKCZwYXJlbnQtPmRfaW5vZGUtPmlfbXV0ZXgpOw0KLQlzaW1w
bGVfcmVsZWFzZV9mcygmZGVidWdmc19tb3VudCwgJmRlYnVnZnNfbW91bnRfY291bnQpOw0KIH0N
CiBFWFBPUlRfU1lNQk9MX0dQTChkZWJ1Z2ZzX3JlbW92ZV9yZWN1cnNpdmUpOw0KIA0KZGlmZiAt
LWdpdCBhL2ZzL2V4dDQvbmFtZWkuYyBiL2ZzL2V4dDQvbmFtZWkuYw0KaW5kZXggM2NhM2I3Zi4u
MmUwZTM0ZiAxMDA2NDQNCi0tLSBhL2ZzL2V4dDQvbmFtZWkuYw0KKysrIGIvZnMvZXh0NC9uYW1l
aS5jDQpAQCAtMjA1NCw3ICsyMDU0LDggQEAgaW50IGV4dDRfb3JwaGFuX2RlbChoYW5kbGVfdCAq
aGFuZGxlLCBzdHJ1Y3QgaW5vZGUgKmlub2RlKQ0KIAlpbnQgZXJyID0gMDsNCiANCiAJLyogZXh0
NF9oYW5kbGVfdmFsaWQoKSBhc3N1bWVzIGEgdmFsaWQgaGFuZGxlX3QgcG9pbnRlciAqLw0KLQlp
ZiAoaGFuZGxlICYmICFleHQ0X2hhbmRsZV92YWxpZChoYW5kbGUpKQ0KKwlpZiAoaGFuZGxlICYm
ICFleHQ0X2hhbmRsZV92YWxpZChoYW5kbGUpICYmDQorCSAgICAhKEVYVDRfU0IoaW5vZGUtPmlf
c2IpLT5zX21vdW50X3N0YXRlICYgRVhUNF9PUlBIQU5fRlMpKQ0KIAkJcmV0dXJuIDA7DQogDQog
CW11dGV4X2xvY2soJkVYVDRfU0IoaW5vZGUtPmlfc2IpLT5zX29ycGhhbl9sb2NrKTsNCmRpZmYg
LS1naXQgYS9mcy9mdXNlL2Rpci5jIGIvZnMvZnVzZS9kaXIuYw0KaW5kZXggNWVmN2FmYi4uMDZl
MmY3MyAxMDA2NDQNCi0tLSBhL2ZzL2Z1c2UvZGlyLmMNCisrKyBiL2ZzL2Z1c2UvZGlyLmMNCkBA
IC0xMDYzLDYgKzEwNjMsOCBAQCBzdGF0aWMgaW50IHBhcnNlX2RpcmZpbGUoY2hhciAqYnVmLCBz
aXplX3QgbmJ5dGVzLCBzdHJ1Y3QgZmlsZSAqZmlsZSwNCiAJCQlyZXR1cm4gLUVJTzsNCiAJCWlm
IChyZWNsZW4gPiBuYnl0ZXMpDQogCQkJYnJlYWs7DQorCQlpZiAobWVtY2hyKGRpcmVudC0+bmFt
ZSwgJy8nLCBkaXJlbnQtPm5hbWVsZW4pICE9IE5VTEwpDQorCQkJcmV0dXJuIC1FSU87DQogDQog
CQlvdmVyID0gZmlsbGRpcihkc3RidWYsIGRpcmVudC0+bmFtZSwgZGlyZW50LT5uYW1lbGVuLA0K
IAkJCSAgICAgICBmaWxlLT5mX3BvcywgZGlyZW50LT5pbm8sIGRpcmVudC0+dHlwZSk7DQpAQCAt
MTI4Miw2ICsxMjg0LDcgQEAgc3RhdGljIGludCBmdXNlX2RvX3NldGF0dHIoc3RydWN0IGRlbnRy
eSAqZW50cnksIHN0cnVjdCBpYXR0ciAqYXR0ciwNCiB7DQogCXN0cnVjdCBpbm9kZSAqaW5vZGUg
PSBlbnRyeS0+ZF9pbm9kZTsNCiAJc3RydWN0IGZ1c2VfY29ubiAqZmMgPSBnZXRfZnVzZV9jb25u
KGlub2RlKTsNCisJc3RydWN0IGZ1c2VfaW5vZGUgKmZpID0gZ2V0X2Z1c2VfaW5vZGUoaW5vZGUp
Ow0KIAlzdHJ1Y3QgZnVzZV9yZXEgKnJlcTsNCiAJc3RydWN0IGZ1c2Vfc2V0YXR0cl9pbiBpbmFy
ZzsNCiAJc3RydWN0IGZ1c2VfYXR0cl9vdXQgb3V0YXJnOw0KQEAgLTEzMTIsOCArMTMxNSwxMCBA
QCBzdGF0aWMgaW50IGZ1c2VfZG9fc2V0YXR0cihzdHJ1Y3QgZGVudHJ5ICplbnRyeSwgc3RydWN0
IGlhdHRyICphdHRyLA0KIAlpZiAoSVNfRVJSKHJlcSkpDQogCQlyZXR1cm4gUFRSX0VSUihyZXEp
Ow0KIA0KLQlpZiAoaXNfdHJ1bmNhdGUpDQorCWlmIChpc190cnVuY2F0ZSkgew0KIAkJZnVzZV9z
ZXRfbm93cml0ZShpbm9kZSk7DQorCQlzZXRfYml0KEZVU0VfSV9TSVpFX1VOU1RBQkxFLCAmZmkt
PnN0YXRlKTsNCisJfQ0KIA0KIAltZW1zZXQoJmluYXJnLCAwLCBzaXplb2YoaW5hcmcpKTsNCiAJ
bWVtc2V0KCZvdXRhcmcsIDAsIHNpemVvZihvdXRhcmcpKTsNCkBAIC0xMzc1LDEyICsxMzgwLDE0
IEBAIHN0YXRpYyBpbnQgZnVzZV9kb19zZXRhdHRyKHN0cnVjdCBkZW50cnkgKmVudHJ5LCBzdHJ1
Y3QgaWF0dHIgKmF0dHIsDQogCQlpbnZhbGlkYXRlX2lub2RlX3BhZ2VzMihpbm9kZS0+aV9tYXBw
aW5nKTsNCiAJfQ0KIA0KKwljbGVhcl9iaXQoRlVTRV9JX1NJWkVfVU5TVEFCTEUsICZmaS0+c3Rh
dGUpOw0KIAlyZXR1cm4gMDsNCiANCiBlcnJvcjoNCiAJaWYgKGlzX3RydW5jYXRlKQ0KIAkJZnVz
ZV9yZWxlYXNlX25vd3JpdGUoaW5vZGUpOw0KIA0KKwljbGVhcl9iaXQoRlVTRV9JX1NJWkVfVU5T
VEFCTEUsICZmaS0+c3RhdGUpOw0KIAlyZXR1cm4gZXJyOw0KIH0NCiANCkBAIC0xNDM5LDYgKzE0
NDYsOCBAQCBzdGF0aWMgaW50IGZ1c2Vfc2V0eGF0dHIoc3RydWN0IGRlbnRyeSAqZW50cnksIGNv
bnN0IGNoYXIgKm5hbWUsDQogCQlmYy0+bm9fc2V0eGF0dHIgPSAxOw0KIAkJZXJyID0gLUVPUE5P
VFNVUFA7DQogCX0NCisJaWYgKCFlcnIpDQorCQlmdXNlX2ludmFsaWRhdGVfYXR0cihpbm9kZSk7
DQogCXJldHVybiBlcnI7DQogfQ0KIA0KQEAgLTE1NjgsNiArMTU3Nyw4IEBAIHN0YXRpYyBpbnQg
ZnVzZV9yZW1vdmV4YXR0cihzdHJ1Y3QgZGVudHJ5ICplbnRyeSwgY29uc3QgY2hhciAqbmFtZSkN
CiAJCWZjLT5ub19yZW1vdmV4YXR0ciA9IDE7DQogCQllcnIgPSAtRU9QTk9UU1VQUDsNCiAJfQ0K
KwlpZiAoIWVycikNCisJCWZ1c2VfaW52YWxpZGF0ZV9hdHRyKGlub2RlKTsNCiAJcmV0dXJuIGVy
cjsNCiB9DQogDQpkaWZmIC0tZ2l0IGEvZnMvZnVzZS9maWxlLmMgYi9mcy9mdXNlL2ZpbGUuYw0K
aW5kZXggNTI0MjAwNi4uNTEwZDRhYSAxMDA2NDQNCi0tLSBhL2ZzL2Z1c2UvZmlsZS5jDQorKysg
Yi9mcy9mdXNlL2ZpbGUuYw0KQEAgLTUxOSw3ICs1MTksOCBAQCBzdGF0aWMgdm9pZCBmdXNlX3Jl
YWRfdXBkYXRlX3NpemUoc3RydWN0IGlub2RlICppbm9kZSwgbG9mZl90IHNpemUsDQogCXN0cnVj
dCBmdXNlX2lub2RlICpmaSA9IGdldF9mdXNlX2lub2RlKGlub2RlKTsNCiANCiAJc3Bpbl9sb2Nr
KCZmYy0+bG9jayk7DQotCWlmIChhdHRyX3ZlciA9PSBmaS0+YXR0cl92ZXJzaW9uICYmIHNpemUg
PCBpbm9kZS0+aV9zaXplKSB7DQorCWlmIChhdHRyX3ZlciA9PSBmaS0+YXR0cl92ZXJzaW9uICYm
IHNpemUgPCBpbm9kZS0+aV9zaXplICYmDQorCSAgICAhdGVzdF9iaXQoRlVTRV9JX1NJWkVfVU5T
VEFCTEUsICZmaS0+c3RhdGUpKSB7DQogCQlmaS0+YXR0cl92ZXJzaW9uID0gKytmYy0+YXR0cl92
ZXJzaW9uOw0KIAkJaV9zaXplX3dyaXRlKGlub2RlLCBzaXplKTsNCiAJfQ0KQEAgLTg4MSwxMiAr
ODgyLDE2IEBAIHN0YXRpYyBzc2l6ZV90IGZ1c2VfcGVyZm9ybV93cml0ZShzdHJ1Y3QgZmlsZSAq
ZmlsZSwNCiB7DQogCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBtYXBwaW5nLT5ob3N0Ow0KIAlzdHJ1
Y3QgZnVzZV9jb25uICpmYyA9IGdldF9mdXNlX2Nvbm4oaW5vZGUpOw0KKwlzdHJ1Y3QgZnVzZV9p
bm9kZSAqZmkgPSBnZXRfZnVzZV9pbm9kZShpbm9kZSk7DQogCWludCBlcnIgPSAwOw0KIAlzc2l6
ZV90IHJlcyA9IDA7DQogDQogCWlmIChpc19iYWRfaW5vZGUoaW5vZGUpKQ0KIAkJcmV0dXJuIC1F
SU87DQogDQorCWlmIChpbm9kZS0+aV9zaXplIDwgcG9zICsgaW92X2l0ZXJfY291bnQoaWkpKQ0K
KwkJc2V0X2JpdChGVVNFX0lfU0laRV9VTlNUQUJMRSwgJmZpLT5zdGF0ZSk7DQorDQogCWRvIHsN
CiAJCXN0cnVjdCBmdXNlX3JlcSAqcmVxOw0KIAkJc3NpemVfdCBjb3VudDsNCkBAIC05MjEsNiAr
OTI2LDcgQEAgc3RhdGljIHNzaXplX3QgZnVzZV9wZXJmb3JtX3dyaXRlKHN0cnVjdCBmaWxlICpm
aWxlLA0KIAlpZiAocmVzID4gMCkNCiAJCWZ1c2Vfd3JpdGVfdXBkYXRlX3NpemUoaW5vZGUsIHBv
cyk7DQogDQorCWNsZWFyX2JpdChGVVNFX0lfU0laRV9VTlNUQUJMRSwgJmZpLT5zdGF0ZSk7DQog
CWZ1c2VfaW52YWxpZGF0ZV9hdHRyKGlub2RlKTsNCiANCiAJcmV0dXJuIHJlcyA+IDAgPyByZXMg
OiBlcnI7DQpAQCAtMTI1MSw3ICsxMjU3LDYgQEAgc3RhdGljIGludCBmdXNlX3dyaXRlcGFnZV9s
b2NrZWQoc3RydWN0IHBhZ2UgKnBhZ2UpDQogDQogCWluY19iZGlfc3RhdChtYXBwaW5nLT5iYWNr
aW5nX2Rldl9pbmZvLCBCRElfV1JJVEVCQUNLKTsNCiAJaW5jX3pvbmVfcGFnZV9zdGF0ZSh0bXBf
cGFnZSwgTlJfV1JJVEVCQUNLX1RFTVApOw0KLQllbmRfcGFnZV93cml0ZWJhY2socGFnZSk7DQog
DQogCXNwaW5fbG9jaygmZmMtPmxvY2spOw0KIAlsaXN0X2FkZCgmcmVxLT53cml0ZXBhZ2VzX2Vu
dHJ5LCAmZmktPndyaXRlcGFnZXMpOw0KQEAgLTEyNTksNiArMTI2NCw4IEBAIHN0YXRpYyBpbnQg
ZnVzZV93cml0ZXBhZ2VfbG9ja2VkKHN0cnVjdCBwYWdlICpwYWdlKQ0KIAlmdXNlX2ZsdXNoX3dy
aXRlcGFnZXMoaW5vZGUpOw0KIAlzcGluX3VubG9jaygmZmMtPmxvY2spOw0KIA0KKwllbmRfcGFn
ZV93cml0ZWJhY2socGFnZSk7DQorDQogCXJldHVybiAwOw0KIA0KIGVycl9mcmVlOg0KZGlmZiAt
LWdpdCBhL2ZzL2Z1c2UvZnVzZV9pLmggYi9mcy9mdXNlL2Z1c2VfaS5oDQppbmRleCA4OWM0YTU4
Li41MmZmZDI0IDEwMDY0NA0KLS0tIGEvZnMvZnVzZS9mdXNlX2kuaA0KKysrIGIvZnMvZnVzZS9m
dXNlX2kuaA0KQEAgLTEwMyw2ICsxMDMsMTUgQEAgc3RydWN0IGZ1c2VfaW5vZGUgew0KIA0KIAkv
KiogTGlzdCBvZiB3cml0ZXBhZ2UgcmVxdWVzdHN0IChwZW5kaW5nIG9yIHNlbnQpICovDQogCXN0
cnVjdCBsaXN0X2hlYWQgd3JpdGVwYWdlczsNCisNCisJLyoqIE1pc2NlbGxhbmVvdXMgYml0cyBk
ZXNjcmliaW5nIGlub2RlIHN0YXRlICovDQorCXVuc2lnbmVkIGxvbmcgc3RhdGU7DQorfTsNCisN
CisvKiogRlVTRSBpbm9kZSBzdGF0ZSBiaXRzICovDQorZW51bSB7DQorCS8qKiBBbiBvcGVyYXRp
b24gY2hhbmdpbmcgZmlsZSBzaXplIGlzIGluIHByb2dyZXNzICAqLw0KKwlGVVNFX0lfU0laRV9V
TlNUQUJMRSwNCiB9Ow0KIA0KIHN0cnVjdCBmdXNlX2Nvbm47DQpkaWZmIC0tZ2l0IGEvZnMvZnVz
ZS9pbm9kZS5jIGIvZnMvZnVzZS9pbm9kZS5jDQppbmRleCAxZjgyZDk1Li45MTJjMjUwIDEwMDY0
NA0KLS0tIGEvZnMvZnVzZS9pbm9kZS5jDQorKysgYi9mcy9mdXNlL2lub2RlLmMNCkBAIC05Miw2
ICs5Miw3IEBAIHN0YXRpYyBzdHJ1Y3QgaW5vZGUgKmZ1c2VfYWxsb2NfaW5vZGUoc3RydWN0IHN1
cGVyX2Jsb2NrICpzYikNCiAJZmktPmF0dHJfdmVyc2lvbiA9IDA7DQogCWZpLT53cml0ZWN0ciA9
IDA7DQogCWZpLT5vcmlnX2lubyA9IDA7DQorCWZpLT5zdGF0ZSA9IDA7DQogCUlOSVRfTElTVF9I
RUFEKCZmaS0+d3JpdGVfZmlsZXMpOw0KIAlJTklUX0xJU1RfSEVBRCgmZmktPnF1ZXVlZF93cml0
ZXMpOw0KIAlJTklUX0xJU1RfSEVBRCgmZmktPndyaXRlcGFnZXMpOw0KQEAgLTIwMCw3ICsyMDEs
OCBAQCB2b2lkIGZ1c2VfY2hhbmdlX2F0dHJpYnV0ZXMoc3RydWN0IGlub2RlICppbm9kZSwgc3Ry
dWN0IGZ1c2VfYXR0ciAqYXR0ciwNCiAJbG9mZl90IG9sZHNpemU7DQogDQogCXNwaW5fbG9jaygm
ZmMtPmxvY2spOw0KLQlpZiAoYXR0cl92ZXJzaW9uICE9IDAgJiYgZmktPmF0dHJfdmVyc2lvbiA+
IGF0dHJfdmVyc2lvbikgew0KKwlpZiAoKGF0dHJfdmVyc2lvbiAhPSAwICYmIGZpLT5hdHRyX3Zl
cnNpb24gPiBhdHRyX3ZlcnNpb24pIHx8DQorCSAgICB0ZXN0X2JpdChGVVNFX0lfU0laRV9VTlNU
QUJMRSwgJmZpLT5zdGF0ZSkpIHsNCiAJCXNwaW5fdW5sb2NrKCZmYy0+bG9jayk7DQogCQlyZXR1
cm47DQogCX0NCmRpZmYgLS1naXQgYS9mcy9pc29mcy9pbm9kZS5jIGIvZnMvaXNvZnMvaW5vZGUu
Yw0KaW5kZXggZjk1MDA1OS4uYTVmMjVhNyAxMDA2NDQNCi0tLSBhL2ZzL2lzb2ZzL2lub2RlLmMN
CisrKyBiL2ZzL2lzb2ZzL2lub2RlLmMNCkBAIC0xMjAsOCArMTIwLDggQEAgc3RhdGljIHZvaWQg
ZGVzdHJveV9pbm9kZWNhY2hlKHZvaWQpDQogDQogc3RhdGljIGludCBpc29mc19yZW1vdW50KHN0
cnVjdCBzdXBlcl9ibG9jayAqc2IsIGludCAqZmxhZ3MsIGNoYXIgKmRhdGEpDQogew0KLQkvKiB3
ZSBwcm9iYWJseSB3YW50IGEgbG90IG1vcmUgaGVyZSAqLw0KLQkqZmxhZ3MgfD0gTVNfUkRPTkxZ
Ow0KKwlpZiAoISgqZmxhZ3MgJiBNU19SRE9OTFkpKQ0KKwkJcmV0dXJuIC1FUk9GUzsNCiAJcmV0
dXJuIDA7DQogfQ0KIA0KQEAgLTc3MCwxNSArNzcwLDYgQEAgcm9vdF9mb3VuZDoNCiAJICovDQog
CXMtPnNfbWF4Ynl0ZXMgPSAweDgwMDAwMDAwMDAwTEw7DQogDQotCS8qDQotCSAqIFRoZSBDRFJP
TSBpcyByZWFkLW9ubHksIGhhcyBubyBub2RlcyAoZGV2aWNlcykgb24gaXQsIGFuZCBzaW5jZQ0K
LQkgKiBhbGwgb2YgdGhlIGZpbGVzIGFwcGVhciB0byBiZSBvd25lZCBieSByb290LCB3ZSByZWFs
bHkgZG8gbm90IHdhbnQNCi0JICogdG8gYWxsb3cgc3VpZC4gIChzdWlkIG9yIGRldmljZXMgd2ls
bCBub3Qgc2hvdyB1cCB1bmxlc3Mgd2UgaGF2ZQ0KLQkgKiBSb2NrIFJpZGdlIGV4dGVuc2lvbnMp
DQotCSAqLw0KLQ0KLQlzLT5zX2ZsYWdzIHw9IE1TX1JET05MWSAvKiB8IE1TX05PREVWIHwgTVNf
Tk9TVUlEICovOw0KLQ0KIAkvKiBTZXQgdGhpcyBmb3IgcmVmZXJlbmNlLiBJdHMgbm90IGN1cnJl
bnRseSB1c2VkIGV4Y2VwdCBvbiB3cml0ZQ0KIAkgICB3aGljaCB3ZSBkb24ndCBoYXZlIC4uICov
DQogDQpAQCAtMTUzNSw2ICsxNTI2LDkgQEAgc3RydWN0IGlub2RlICppc29mc19pZ2V0KHN0cnVj
dCBzdXBlcl9ibG9jayAqc2IsDQogc3RhdGljIHN0cnVjdCBkZW50cnkgKmlzb2ZzX21vdW50KHN0
cnVjdCBmaWxlX3N5c3RlbV90eXBlICpmc190eXBlLA0KIAlpbnQgZmxhZ3MsIGNvbnN0IGNoYXIg
KmRldl9uYW1lLCB2b2lkICpkYXRhKQ0KIHsNCisJLyogV2UgZG9uJ3Qgc3VwcG9ydCByZWFkLXdy
aXRlIG1vdW50cyAqLw0KKwlpZiAoIShmbGFncyAmIE1TX1JET05MWSkpDQorCQlyZXR1cm4gRVJS
X1BUUigtRUFDQ0VTKTsNCiAJcmV0dXJuIG1vdW50X2JkZXYoZnNfdHlwZSwgZmxhZ3MsIGRldl9u
YW1lLCBkYXRhLCBpc29mc19maWxsX3N1cGVyKTsNCiB9DQogDQpkaWZmIC0tZ2l0IGEvZnMvbmls
ZnMyL3BhZ2UuYyBiL2ZzL25pbGZzMi9wYWdlLmMNCmluZGV4IDY1MjIxYTAuLjE2ZWFjZWMgMTAw
NjQ0DQotLS0gYS9mcy9uaWxmczIvcGFnZS5jDQorKysgYi9mcy9uaWxmczIvcGFnZS5jDQpAQCAt
OTQsNiArOTQsNyBAQCB2b2lkIG5pbGZzX2ZvcmdldF9idWZmZXIoc3RydWN0IGJ1ZmZlcl9oZWFk
ICpiaCkNCiAJY2xlYXJfYnVmZmVyX25pbGZzX3ZvbGF0aWxlKGJoKTsNCiAJY2xlYXJfYnVmZmVy
X25pbGZzX2NoZWNrZWQoYmgpOw0KIAljbGVhcl9idWZmZXJfbmlsZnNfcmVkaXJlY3RlZChiaCk7
DQorCWNsZWFyX2J1ZmZlcl9hc3luY193cml0ZShiaCk7DQogCWNsZWFyX2J1ZmZlcl9kaXJ0eShi
aCk7DQogCWlmIChuaWxmc19wYWdlX2J1ZmZlcnNfY2xlYW4ocGFnZSkpDQogCQlfX25pbGZzX2Ns
ZWFyX3BhZ2VfZGlydHkocGFnZSk7DQpAQCAtMzkwLDYgKzM5MSw3IEBAIHZvaWQgbmlsZnNfY2xl
YXJfZGlydHlfcGFnZXMoc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcpDQogCQkJYmggPSBo
ZWFkID0gcGFnZV9idWZmZXJzKHBhZ2UpOw0KIAkJCWRvIHsNCiAJCQkJbG9ja19idWZmZXIoYmgp
Ow0KKwkJCQljbGVhcl9idWZmZXJfYXN5bmNfd3JpdGUoYmgpOw0KIAkJCQljbGVhcl9idWZmZXJf
ZGlydHkoYmgpOw0KIAkJCQljbGVhcl9idWZmZXJfbmlsZnNfdm9sYXRpbGUoYmgpOw0KIAkJCQlj
bGVhcl9idWZmZXJfbmlsZnNfY2hlY2tlZChiaCk7DQpkaWZmIC0tZ2l0IGEvZnMvbmlsZnMyL3Nl
Z21lbnQuYyBiL2ZzL25pbGZzMi9zZWdtZW50LmMNCmluZGV4IDZmMjRlNjcuLjIzM2QzZWQgMTAw
NjQ0DQotLS0gYS9mcy9uaWxmczIvc2VnbWVudC5jDQorKysgYi9mcy9uaWxmczIvc2VnbWVudC5j
DQpAQCAtNjYyLDcgKzY2Miw3IEBAIHN0YXRpYyBzaXplX3QgbmlsZnNfbG9va3VwX2RpcnR5X2Rh
dGFfYnVmZmVycyhzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KIA0KIAkJYmggPSBoZWFkID0gcGFnZV9i
dWZmZXJzKHBhZ2UpOw0KIAkJZG8gew0KLQkJCWlmICghYnVmZmVyX2RpcnR5KGJoKSkNCisJCQlp
ZiAoIWJ1ZmZlcl9kaXJ0eShiaCkgfHwgYnVmZmVyX2FzeW5jX3dyaXRlKGJoKSkNCiAJCQkJY29u
dGludWU7DQogCQkJZ2V0X2JoKGJoKTsNCiAJCQlsaXN0X2FkZF90YWlsKCZiaC0+Yl9hc3NvY19i
dWZmZXJzLCBsaXN0cCk7DQpAQCAtNjk2LDcgKzY5Niw4IEBAIHN0YXRpYyB2b2lkIG5pbGZzX2xv
b2t1cF9kaXJ0eV9ub2RlX2J1ZmZlcnMoc3RydWN0IGlub2RlICppbm9kZSwNCiAJCWZvciAoaSA9
IDA7IGkgPCBwYWdldmVjX2NvdW50KCZwdmVjKTsgaSsrKSB7DQogCQkJYmggPSBoZWFkID0gcGFn
ZV9idWZmZXJzKHB2ZWMucGFnZXNbaV0pOw0KIAkJCWRvIHsNCi0JCQkJaWYgKGJ1ZmZlcl9kaXJ0
eShiaCkpIHsNCisJCQkJaWYgKGJ1ZmZlcl9kaXJ0eShiaCkgJiYNCisJCQkJCQkhYnVmZmVyX2Fz
eW5jX3dyaXRlKGJoKSkgew0KIAkJCQkJZ2V0X2JoKGJoKTsNCiAJCQkJCWxpc3RfYWRkX3RhaWwo
JmJoLT5iX2Fzc29jX2J1ZmZlcnMsDQogCQkJCQkJICAgICAgbGlzdHApOw0KQEAgLTE1NzYsNiAr
MTU3Nyw3IEBAIHN0YXRpYyB2b2lkIG5pbGZzX3NlZ2N0b3JfcHJlcGFyZV93cml0ZShzdHJ1Y3Qg
bmlsZnNfc2NfaW5mbyAqc2NpKQ0KIA0KIAkJbGlzdF9mb3JfZWFjaF9lbnRyeShiaCwgJnNlZ2J1
Zi0+c2Jfc2Vnc3VtX2J1ZmZlcnMsDQogCQkJCSAgICBiX2Fzc29jX2J1ZmZlcnMpIHsNCisJCQlz
ZXRfYnVmZmVyX2FzeW5jX3dyaXRlKGJoKTsNCiAJCQlpZiAoYmgtPmJfcGFnZSAhPSBiZF9wYWdl
KSB7DQogCQkJCWlmIChiZF9wYWdlKSB7DQogCQkJCQlsb2NrX3BhZ2UoYmRfcGFnZSk7DQpAQCAt
MTU4OSw2ICsxNTkxLDcgQEAgc3RhdGljIHZvaWQgbmlsZnNfc2VnY3Rvcl9wcmVwYXJlX3dyaXRl
KHN0cnVjdCBuaWxmc19zY19pbmZvICpzY2kpDQogDQogCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGJo
LCAmc2VnYnVmLT5zYl9wYXlsb2FkX2J1ZmZlcnMsDQogCQkJCSAgICBiX2Fzc29jX2J1ZmZlcnMp
IHsNCisJCQlzZXRfYnVmZmVyX2FzeW5jX3dyaXRlKGJoKTsNCiAJCQlpZiAoYmggPT0gc2VnYnVm
LT5zYl9zdXBlcl9yb290KSB7DQogCQkJCWlmIChiaC0+Yl9wYWdlICE9IGJkX3BhZ2UpIHsNCiAJ
CQkJCWxvY2tfcGFnZShiZF9wYWdlKTsNCkBAIC0xNjc0LDYgKzE2NzcsNyBAQCBzdGF0aWMgdm9p
ZCBuaWxmc19hYm9ydF9sb2dzKHN0cnVjdCBsaXN0X2hlYWQgKmxvZ3MsIGludCBlcnIpDQogCWxp
c3RfZm9yX2VhY2hfZW50cnkoc2VnYnVmLCBsb2dzLCBzYl9saXN0KSB7DQogCQlsaXN0X2Zvcl9l
YWNoX2VudHJ5KGJoLCAmc2VnYnVmLT5zYl9zZWdzdW1fYnVmZmVycywNCiAJCQkJICAgIGJfYXNz
b2NfYnVmZmVycykgew0KKwkJCWNsZWFyX2J1ZmZlcl9hc3luY193cml0ZShiaCk7DQogCQkJaWYg
KGJoLT5iX3BhZ2UgIT0gYmRfcGFnZSkgew0KIAkJCQlpZiAoYmRfcGFnZSkNCiAJCQkJCWVuZF9w
YWdlX3dyaXRlYmFjayhiZF9wYWdlKTsNCkBAIC0xNjgzLDYgKzE2ODcsNyBAQCBzdGF0aWMgdm9p
ZCBuaWxmc19hYm9ydF9sb2dzKHN0cnVjdCBsaXN0X2hlYWQgKmxvZ3MsIGludCBlcnIpDQogDQog
CQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGJoLCAmc2VnYnVmLT5zYl9wYXlsb2FkX2J1ZmZlcnMsDQog
CQkJCSAgICBiX2Fzc29jX2J1ZmZlcnMpIHsNCisJCQljbGVhcl9idWZmZXJfYXN5bmNfd3JpdGUo
YmgpOw0KIAkJCWlmIChiaCA9PSBzZWdidWYtPnNiX3N1cGVyX3Jvb3QpIHsNCiAJCQkJaWYgKGJo
LT5iX3BhZ2UgIT0gYmRfcGFnZSkgew0KIAkJCQkJZW5kX3BhZ2Vfd3JpdGViYWNrKGJkX3BhZ2Up
Ow0KQEAgLTE3NTIsNiArMTc1Nyw3IEBAIHN0YXRpYyB2b2lkIG5pbGZzX3NlZ2N0b3JfY29tcGxl
dGVfd3JpdGUoc3RydWN0IG5pbGZzX3NjX2luZm8gKnNjaSkNCiAJCQkJICAgIGJfYXNzb2NfYnVm
ZmVycykgew0KIAkJCXNldF9idWZmZXJfdXB0b2RhdGUoYmgpOw0KIAkJCWNsZWFyX2J1ZmZlcl9k
aXJ0eShiaCk7DQorCQkJY2xlYXJfYnVmZmVyX2FzeW5jX3dyaXRlKGJoKTsNCiAJCQlpZiAoYmgt
PmJfcGFnZSAhPSBiZF9wYWdlKSB7DQogCQkJCWlmIChiZF9wYWdlKQ0KIAkJCQkJZW5kX3BhZ2Vf
d3JpdGViYWNrKGJkX3BhZ2UpOw0KQEAgLTE3NzMsNiArMTc3OSw3IEBAIHN0YXRpYyB2b2lkIG5p
bGZzX3NlZ2N0b3JfY29tcGxldGVfd3JpdGUoc3RydWN0IG5pbGZzX3NjX2luZm8gKnNjaSkNCiAJ
CQkJICAgIGJfYXNzb2NfYnVmZmVycykgew0KIAkJCXNldF9idWZmZXJfdXB0b2RhdGUoYmgpOw0K
IAkJCWNsZWFyX2J1ZmZlcl9kaXJ0eShiaCk7DQorCQkJY2xlYXJfYnVmZmVyX2FzeW5jX3dyaXRl
KGJoKTsNCiAJCQljbGVhcl9idWZmZXJfZGVsYXkoYmgpOw0KIAkJCWNsZWFyX2J1ZmZlcl9uaWxm
c192b2xhdGlsZShiaCk7DQogCQkJY2xlYXJfYnVmZmVyX25pbGZzX3JlZGlyZWN0ZWQoYmgpOw0K
ZGlmZiAtLWdpdCBhL2ZzL25vdGlmeS9mYW5vdGlmeS9mYW5vdGlmeS5jIGIvZnMvbm90aWZ5L2Zh
bm90aWZ5L2Zhbm90aWZ5LmMNCmluZGV4IGE1MDYzNjAuLjBjMmY5MTIgMTAwNjQ0DQotLS0gYS9m
cy9ub3RpZnkvZmFub3RpZnkvZmFub3RpZnkuYw0KKysrIGIvZnMvbm90aWZ5L2Zhbm90aWZ5L2Zh
bm90aWZ5LmMNCkBAIC0xOCw2ICsxOCwxMiBAQCBzdGF0aWMgYm9vbCBzaG91bGRfbWVyZ2Uoc3Ry
dWN0IGZzbm90aWZ5X2V2ZW50ICpvbGQsIHN0cnVjdCBmc25vdGlmeV9ldmVudCAqbmV3KQ0KIAkg
ICAgb2xkLT50Z2lkID09IG5ldy0+dGdpZCkgew0KIAkJc3dpdGNoIChvbGQtPmRhdGFfdHlwZSkg
ew0KIAkJY2FzZSAoRlNOT1RJRllfRVZFTlRfUEFUSCk6DQorI2lmZGVmIENPTkZJR19GQU5PVElG
WV9BQ0NFU1NfUEVSTUlTU0lPTlMNCisJCQkvKiBkb250IG1lcmdlIHR3byBwZXJtaXNzaW9uIGV2
ZW50cyAqLw0KKwkJCWlmICgob2xkLT5tYXNrICYgRkFOX0FMTF9QRVJNX0VWRU5UUykgJiYNCisJ
CQkgICAgKG5ldy0+bWFzayAmIEZBTl9BTExfUEVSTV9FVkVOVFMpKQ0KKwkJCQlyZXR1cm4gZmFs
c2U7DQorI2VuZGlmDQogCQkJaWYgKChvbGQtPnBhdGgubW50ID09IG5ldy0+cGF0aC5tbnQpICYm
DQogCQkJICAgIChvbGQtPnBhdGguZGVudHJ5ID09IG5ldy0+cGF0aC5kZW50cnkpKQ0KIAkJCQly
ZXR1cm4gdHJ1ZTsNCmRpZmYgLS1naXQgYS9mcy9vY2ZzMi9leHRlbnRfbWFwLmMgYi9mcy9vY2Zz
Mi9leHRlbnRfbWFwLmMNCmluZGV4IDdlYjFjMGMuLmNmMjI4NDcgMTAwNjQ0DQotLS0gYS9mcy9v
Y2ZzMi9leHRlbnRfbWFwLmMNCisrKyBiL2ZzL29jZnMyL2V4dGVudF9tYXAuYw0KQEAgLTc4Miw3
ICs3ODIsNiBAQCBpbnQgb2NmczJfZmllbWFwKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBm
aWVtYXBfZXh0ZW50X2luZm8gKmZpZWluZm8sDQogCWNwb3MgPSBtYXBfc3RhcnQgPj4gb3NiLT5z
X2NsdXN0ZXJzaXplX2JpdHM7DQogCW1hcHBpbmdfZW5kID0gb2NmczJfY2x1c3RlcnNfZm9yX2J5
dGVzKGlub2RlLT5pX3NiLA0KIAkJCQkJICAgICAgIG1hcF9zdGFydCArIG1hcF9sZW4pOw0KLQlt
YXBwaW5nX2VuZCAtPSBjcG9zOw0KIAlpc19sYXN0ID0gMDsNCiAJd2hpbGUgKGNwb3MgPCBtYXBw
aW5nX2VuZCAmJiAhaXNfbGFzdCkgew0KIAkJdTMyIGZlX2ZsYWdzOw0KZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbGludXgvaGlkLmggYi9pbmNsdWRlL2xpbnV4L2hpZC5oDQppbmRleCAzMzFlMmVmLi4x
OWZlNzE5IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9oaWQuaA0KKysrIGIvaW5jbHVkZS9s
aW51eC9oaWQuaA0KQEAgLTQxNiwxMCArNDE2LDEyIEBAIHN0cnVjdCBoaWRfcmVwb3J0IHsNCiAJ
c3RydWN0IGhpZF9kZXZpY2UgKmRldmljZTsJCQkvKiBhc3NvY2lhdGVkIGRldmljZSAqLw0KIH07
DQogDQorI2RlZmluZSBISURfTUFYX0lEUyAyNTYNCisNCiBzdHJ1Y3QgaGlkX3JlcG9ydF9lbnVt
IHsNCiAJdW5zaWduZWQgbnVtYmVyZWQ7DQogCXN0cnVjdCBsaXN0X2hlYWQgcmVwb3J0X2xpc3Q7
DQotCXN0cnVjdCBoaWRfcmVwb3J0ICpyZXBvcnRfaWRfaGFzaFsyNTZdOw0KKwlzdHJ1Y3QgaGlk
X3JlcG9ydCAqcmVwb3J0X2lkX2hhc2hbSElEX01BWF9JRFNdOw0KIH07DQogDQogI2RlZmluZSBI
SURfUkVQT1JUX1RZUEVTIDMNCkBAIC03MTYsNiArNzE4LDEwIEBAIHZvaWQgaGlkX291dHB1dF9y
ZXBvcnQoc3RydWN0IGhpZF9yZXBvcnQgKnJlcG9ydCwgX191OCAqZGF0YSk7DQogc3RydWN0IGhp
ZF9kZXZpY2UgKmhpZF9hbGxvY2F0ZV9kZXZpY2Uodm9pZCk7DQogc3RydWN0IGhpZF9yZXBvcnQg
KmhpZF9yZWdpc3Rlcl9yZXBvcnQoc3RydWN0IGhpZF9kZXZpY2UgKmRldmljZSwgdW5zaWduZWQg
dHlwZSwgdW5zaWduZWQgaWQpOw0KIGludCBoaWRfcGFyc2VfcmVwb3J0KHN0cnVjdCBoaWRfZGV2
aWNlICpoaWQsIF9fdTggKnN0YXJ0LCB1bnNpZ25lZCBzaXplKTsNCitzdHJ1Y3QgaGlkX3JlcG9y
dCAqaGlkX3ZhbGlkYXRlX3ZhbHVlcyhzdHJ1Y3QgaGlkX2RldmljZSAqaGlkLA0KKwkJCQkgICAg
ICAgdW5zaWduZWQgaW50IHR5cGUsIHVuc2lnbmVkIGludCBpZCwNCisJCQkJICAgICAgIHVuc2ln
bmVkIGludCBmaWVsZF9pbmRleCwNCisJCQkJICAgICAgIHVuc2lnbmVkIGludCByZXBvcnRfY291
bnRzKTsNCiBpbnQgaGlkX2NoZWNrX2tleXNfcHJlc3NlZChzdHJ1Y3QgaGlkX2RldmljZSAqaGlk
KTsNCiBpbnQgaGlkX2Nvbm5lY3Qoc3RydWN0IGhpZF9kZXZpY2UgKmhpZCwgdW5zaWduZWQgaW50
IGNvbm5lY3RfbWFzayk7DQogdm9pZCBoaWRfZGlzY29ubmVjdChzdHJ1Y3QgaGlkX2RldmljZSAq
aGlkKTsNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2ljbXB2Ni5oIGIvaW5jbHVkZS9saW51
eC9pY21wdjYuaA0KaW5kZXggYmE0NWU2Yi4uZjVhMjFkMCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUv
bGludXgvaWNtcHY2LmgNCisrKyBiL2luY2x1ZGUvbGludXgvaWNtcHY2LmgNCkBAIC0xMjMsNiAr
MTIzLDggQEAgc3RhdGljIGlubGluZSBzdHJ1Y3QgaWNtcDZoZHIgKmljbXA2X2hkcihjb25zdCBz
dHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KICNkZWZpbmUgSUNNUFY2X05PVF9ORUlHSEJPVVIJCTINCiAj
ZGVmaW5lIElDTVBWNl9BRERSX1VOUkVBQ0gJCTMNCiAjZGVmaW5lIElDTVBWNl9QT1JUX1VOUkVB
Q0gJCTQNCisjZGVmaW5lIElDTVBWNl9QT0xJQ1lfRkFJTAkJNQ0KKyNkZWZpbmUgSUNNUFY2X1JF
SkVDVF9ST1VURQkJNg0KIA0KIC8qDQogICoJQ29kZXMgZm9yIFRpbWUgRXhjZWVkZWQNCmRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L2lwdjYuaCBiL2luY2x1ZGUvbGludXgvaXB2Ni5oDQppbmRl
eCAwYzk5Nzc2Li44NGIxNDQ3IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9pcHY2LmgNCisr
KyBiL2luY2x1ZGUvbGludXgvaXB2Ni5oDQpAQCAtMjU1LDYgKzI1NSw3IEBAIHN0cnVjdCBpbmV0
Nl9za2JfcGFybSB7DQogI2RlZmluZSBJUDZTS0JfWEZSTV9UUkFOU0ZPUk1FRAkxDQogI2RlZmlu
ZSBJUDZTS0JfRk9SV0FSREVECTINCiAjZGVmaW5lIElQNlNLQl9SRVJPVVRFRAkJNA0KKyNkZWZp
bmUgSVA2U0tCX0ZSQUdNRU5URUQgICAgICAxNg0KIH07DQogDQogI2RlZmluZSBJUDZDQihza2Ip
CSgoc3RydWN0IGluZXQ2X3NrYl9wYXJtKikoKHNrYiktPmNiKSkNCmRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L21tLmggYi9pbmNsdWRlL2xpbnV4L21tLmgNCmluZGV4IGQwNDkzZjYuLjMwNWZk
NzUgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L21tLmgNCisrKyBiL2luY2x1ZGUvbGludXgv
bW0uaA0KQEAgLTg2NSw3ICs4NjUsOCBAQCBleHRlcm4gdm9pZCBwYWdlZmF1bHRfb3V0X29mX21l
bW9yeSh2b2lkKTsNCiAgKiBGbGFncyBwYXNzZWQgdG8gc2hvd19tZW0oKSBhbmQgc2hvd19mcmVl
X2FyZWFzKCkgdG8gc3VwcHJlc3Mgb3V0cHV0IGluDQogICogdmFyaW91cyBjb250ZXh0cy4NCiAg
Ki8NCi0jZGVmaW5lIFNIT1dfTUVNX0ZJTFRFUl9OT0RFUwkoMHgwMDAxdSkJLyogZmlsdGVyIGRp
c2FsbG93ZWQgbm9kZXMgKi8NCisjZGVmaW5lIFNIT1dfTUVNX0ZJTFRFUl9OT0RFUwkJKDB4MDAw
MXUpCS8qIGRpc2FsbG93ZWQgbm9kZXMgKi8NCisjZGVmaW5lIFNIT1dfTUVNX0ZJTFRFUl9QQUdF
X0NPVU5UCSgweDAwMDJ1KQkvKiBwYWdlIHR5cGUgY291bnQgKi8NCiANCiBleHRlcm4gdm9pZCBz
aG93X2ZyZWVfYXJlYXModW5zaWduZWQgaW50IGZsYWdzKTsNCiBleHRlcm4gYm9vbCBza2lwX2Zy
ZWVfYXJlYXNfbm9kZSh1bnNpZ25lZCBpbnQgZmxhZ3MsIGludCBuaWQpOw0KZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbGludXgvcGVyZl9ldmVudC5oIGIvaW5jbHVkZS9saW51eC9wZXJmX2V2ZW50LmgN
CmluZGV4IDNjZmNmZWEuLmVlYjZhMjkgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3BlcmZf
ZXZlbnQuaA0KKysrIGIvaW5jbHVkZS9saW51eC9wZXJmX2V2ZW50LmgNCkBAIC05MjcsNyArOTI3
LDcgQEAgc3RydWN0IHBlcmZfY3B1X2NvbnRleHQgew0KIAlpbnQJCQkJZXhjbHVzaXZlOw0KIAlz
dHJ1Y3QgbGlzdF9oZWFkCQlyb3RhdGlvbl9saXN0Ow0KIAlpbnQJCQkJamlmZmllc19pbnRlcnZh
bDsNCi0Jc3RydWN0IHBtdQkJCSphY3RpdmVfcG11Ow0KKwlzdHJ1Y3QgcG11CQkJKnVuaXF1ZV9w
bXU7DQogCXN0cnVjdCBwZXJmX2Nncm91cAkJKmNncnA7DQogfTsNCiANCmRpZmYgLS1naXQgYS9p
bmNsdWRlL2xpbnV4L3JjdWxpc3QuaCBiL2luY2x1ZGUvbGludXgvcmN1bGlzdC5oDQppbmRleCA2
Zjk1ZTI0Li4zODYzMzUyIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9yY3VsaXN0LmgNCisr
KyBiL2luY2x1ZGUvbGludXgvcmN1bGlzdC5oDQpAQCAtMjU0LDggKzI1NCw5IEBAIHN0YXRpYyBp
bmxpbmUgdm9pZCBsaXN0X3NwbGljZV9pbml0X3JjdShzdHJ1Y3QgbGlzdF9oZWFkICpsaXN0LA0K
ICAqLw0KICNkZWZpbmUgbGlzdF9maXJzdF9vcl9udWxsX3JjdShwdHIsIHR5cGUsIG1lbWJlcikg
XA0KIAkoe3N0cnVjdCBsaXN0X2hlYWQgKl9fcHRyID0gKHB0cik7IFwNCi0JICBzdHJ1Y3QgbGlz
dF9oZWFkIF9fcmN1ICpfX25leHQgPSBsaXN0X25leHRfcmN1KF9fcHRyKTsgXA0KLQkgIGxpa2Vs
eShfX3B0ciAhPSBfX25leHQpID8gY29udGFpbmVyX29mKF9fbmV4dCwgdHlwZSwgbWVtYmVyKSA6
IE5VTEw7IFwNCisJICBzdHJ1Y3QgbGlzdF9oZWFkICpfX25leHQgPSBBQ0NFU1NfT05DRShfX3B0
ci0+bmV4dCk7IFwNCisJICBsaWtlbHkoX19wdHIgIT0gX19uZXh0KSA/IFwNCisJCWxpc3RfZW50
cnlfcmN1KF9fbmV4dCwgdHlwZSwgbWVtYmVyKSA6IE5VTEw7IFwNCiAJfSkNCiANCiAvKioNCmRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3VzYi9oY2QuaCBiL2luY2x1ZGUvbGludXgvdXNiL2hj
ZC5oDQppbmRleCAwMzM1NGQ1Li4wZGFhNDZiIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC91
c2IvaGNkLmgNCisrKyBiL2luY2x1ZGUvbGludXgvdXNiL2hjZC5oDQpAQCAtMzk1LDcgKzM5NSw3
IEBAIGV4dGVybiBpbnQgdXNiX2hjZF9wY2lfcHJvYmUoc3RydWN0IHBjaV9kZXYgKmRldiwNCiBl
eHRlcm4gdm9pZCB1c2JfaGNkX3BjaV9yZW1vdmUoc3RydWN0IHBjaV9kZXYgKmRldik7DQogZXh0
ZXJuIHZvaWQgdXNiX2hjZF9wY2lfc2h1dGRvd24oc3RydWN0IHBjaV9kZXYgKmRldik7DQogDQot
I2lmZGVmIENPTkZJR19QTV9TTEVFUA0KKyNpZmRlZiBDT05GSUdfUE0NCiBleHRlcm4gY29uc3Qg
c3RydWN0IGRldl9wbV9vcHMgdXNiX2hjZF9wY2lfcG1fb3BzOw0KICNlbmRpZg0KICNlbmRpZiAv
KiBDT05GSUdfUENJICovDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvaW5ldHBlZXIuaCBiL2lu
Y2x1ZGUvbmV0L2luZXRwZWVyLmgNCmluZGV4IGU5ZmYzZmMuLjM0YjA2ZGEgMTAwNjQ0DQotLS0g
YS9pbmNsdWRlL25ldC9pbmV0cGVlci5oDQorKysgYi9pbmNsdWRlL25ldC9pbmV0cGVlci5oDQpA
QCAtNDEsNiArNDEsMTAgQEAgc3RydWN0IGluZXRfcGVlciB7DQogCXUzMgkJCXBtdHVfb3JpZzsN
CiAJdTMyCQkJcG10dV9sZWFybmVkOw0KIAlzdHJ1Y3QgaW5ldHBlZXJfYWRkcl9iYXNlIHJlZGly
ZWN0X2xlYXJuZWQ7DQorCXVuaW9uIHsNCisJCXN0cnVjdCBsaXN0X2hlYWQJZ2NfbGlzdDsNCisJ
CXN0cnVjdCByY3VfaGVhZCAgICAgZ2NfcmN1Ow0KKwl9Ow0KIAkvKg0KIAkgKiBPbmNlIGluZXRf
cGVlciBpcyBxdWV1ZWQgZm9yIGRlbGV0aW9uIChyZWZjbnQgPT0gLTEpLCBmb2xsb3dpbmcgZmll
bGRzDQogCSAqIGFyZSBub3QgYXZhaWxhYmxlOiByaWQsIGlwX2lkX2NvdW50LCB0Y3BfdHMsIHRj
cF90c19zdGFtcA0KQEAgLTk2LDYgKzEwMCw4IEBAIHN0YXRpYyBpbmxpbmUgc3RydWN0IGluZXRf
cGVlciAqaW5ldF9nZXRwZWVyX3Y2KGNvbnN0IHN0cnVjdCBpbjZfYWRkciAqdjZkYWRkciwNCiBl
eHRlcm4gdm9pZCBpbmV0X3B1dHBlZXIoc3RydWN0IGluZXRfcGVlciAqcCk7DQogZXh0ZXJuIGJv
b2wgaW5ldF9wZWVyX3hybGltX2FsbG93KHN0cnVjdCBpbmV0X3BlZXIgKnBlZXIsIGludCB0aW1l
b3V0KTsNCiANCitleHRlcm4gdm9pZCBpbmV0cGVlcl9pbnZhbGlkYXRlX3RyZWUoaW50IGZhbWls
eSk7DQorDQogLyoNCiAgKiB0ZW1wb3JhcnkgY2hlY2sgdG8gbWFrZSBzdXJlIHdlIGRvbnQgYWNj
ZXNzIHJpZCwgaXBfaWRfY291bnQsIHRjcF90cywNCiAgKiB0Y3BfdHNfc3RhbXAgaWYgbm8gcmVm
Y291bnQgaXMgdGFrZW4gb24gaW5ldF9wZWVyDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvaXAu
aCBiL2luY2x1ZGUvbmV0L2lwLmgNCmluZGV4IGVjYTBlZjcuLjA2YWVkNzIgMTAwNjQ0DQotLS0g
YS9pbmNsdWRlL25ldC9pcC5oDQorKysgYi9pbmNsdWRlL25ldC9pcC5oDQpAQCAtMjY2LDkgKzI2
NiwxMSBAQCBpbnQgaXBfZG9udF9mcmFnbWVudChzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBkc3Rf
ZW50cnkgKmRzdCkNCiANCiBleHRlcm4gdm9pZCBfX2lwX3NlbGVjdF9pZGVudChzdHJ1Y3QgaXBo
ZHIgKmlwaCwgc3RydWN0IGRzdF9lbnRyeSAqZHN0LCBpbnQgbW9yZSk7DQogDQotc3RhdGljIGlu
bGluZSB2b2lkIGlwX3NlbGVjdF9pZGVudChzdHJ1Y3QgaXBoZHIgKmlwaCwgc3RydWN0IGRzdF9l
bnRyeSAqZHN0LCBzdHJ1Y3Qgc29jayAqc2spDQorc3RhdGljIGlubGluZSB2b2lkIGlwX3NlbGVj
dF9pZGVudChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgZHN0X2VudHJ5ICpkc3QsIHN0cnVj
dCBzb2NrICpzaykNCiB7DQotCWlmIChpcGgtPmZyYWdfb2ZmICYgaHRvbnMoSVBfREYpKSB7DQor
CXN0cnVjdCBpcGhkciAqaXBoID0gaXBfaGRyKHNrYik7DQorDQorCWlmICgoaXBoLT5mcmFnX29m
ZiAmIGh0b25zKElQX0RGKSkgJiYgIXNrYi0+bG9jYWxfZGYpIHsNCiAJCS8qIFRoaXMgaXMgb25s
eSB0byB3b3JrIGFyb3VuZCBidWdneSBXaW5kb3dzOTUvMjAwMA0KIAkJICogVkogY29tcHJlc3Np
b24gaW1wbGVtZW50YXRpb25zLiAgSWYgdGhlIElEIGZpZWxkDQogCQkgKiBkb2VzIG5vdCBjaGFu
Z2UsIHRoZXkgZHJvcCBldmVyeSBvdGhlciBwYWNrZXQgaW4NCkBAIC0yODAsOSArMjgyLDExIEBA
IHN0YXRpYyBpbmxpbmUgdm9pZCBpcF9zZWxlY3RfaWRlbnQoc3RydWN0IGlwaGRyICppcGgsIHN0
cnVjdCBkc3RfZW50cnkgKmRzdCwgc3RyDQogCQlfX2lwX3NlbGVjdF9pZGVudChpcGgsIGRzdCwg
MCk7DQogfQ0KIA0KLXN0YXRpYyBpbmxpbmUgdm9pZCBpcF9zZWxlY3RfaWRlbnRfbW9yZShzdHJ1
Y3QgaXBoZHIgKmlwaCwgc3RydWN0IGRzdF9lbnRyeSAqZHN0LCBzdHJ1Y3Qgc29jayAqc2ssIGlu
dCBtb3JlKQ0KK3N0YXRpYyBpbmxpbmUgdm9pZCBpcF9zZWxlY3RfaWRlbnRfbW9yZShzdHJ1Y3Qg
c2tfYnVmZiAqc2tiLCBzdHJ1Y3QgZHN0X2VudHJ5ICpkc3QsIHN0cnVjdCBzb2NrICpzaywgaW50
IG1vcmUpDQogew0KLQlpZiAoaXBoLT5mcmFnX29mZiAmIGh0b25zKElQX0RGKSkgew0KKwlzdHJ1
Y3QgaXBoZHIgKmlwaCA9IGlwX2hkcihza2IpOw0KKw0KKwlpZiAoKGlwaC0+ZnJhZ19vZmYgJiBo
dG9ucyhJUF9ERikpICYmICFza2ItPmxvY2FsX2RmKSB7DQogCQlpZiAoc2sgJiYgaW5ldF9zayhz
ayktPmluZXRfZGFkZHIpIHsNCiAJCQlpcGgtPmlkID0gaHRvbnMoaW5ldF9zayhzayktPmluZXRf
aWQpOw0KIAkJCWluZXRfc2soc2spLT5pbmV0X2lkICs9IDEgKyBtb3JlOw0KZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbmV0L2lwaXAuaCBiL2luY2x1ZGUvbmV0L2lwaXAuaA0KaW5kZXggYTMyNjU0ZC4u
NGRjY2ZlMyAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbmV0L2lwaXAuaA0KKysrIGIvaW5jbHVkZS9u
ZXQvaXBpcC5oDQpAQCAtNTAsNyArNTAsNyBAQCBzdHJ1Y3QgaXBfdHVubmVsX3BybF9lbnRyeSB7
DQogCWludCBwa3RfbGVuID0gc2tiLT5sZW4gLSBza2JfdHJhbnNwb3J0X29mZnNldChza2IpOwkJ
XA0KIAkJCQkJCQkJCVwNCiAJc2tiLT5pcF9zdW1tZWQgPSBDSEVDS1NVTV9OT05FOwkJCQkJXA0K
LQlpcF9zZWxlY3RfaWRlbnQoaXBoLCAmcnQtPmRzdCwgTlVMTCk7CQkJCVwNCisJaXBfc2VsZWN0
X2lkZW50KHNrYiwgJnJ0LT5kc3QsIE5VTEwpOwkJCQlcDQogCQkJCQkJCQkJXA0KIAllcnIgPSBp
cF9sb2NhbF9vdXQoc2tiKTsJCQkJCVwNCiAJaWYgKGxpa2VseShuZXRfeG1pdF9ldmFsKGVycikg
PT0gMCkpIHsJCQkJXA0KZGlmZiAtLWdpdCBhL2tlcm5lbC9jZ3JvdXAuYyBiL2tlcm5lbC9jZ3Jv
dXAuYw0KaW5kZXggZDJhMDFmZS4uMmExZmZiNyAxMDA2NDQNCi0tLSBhL2tlcm5lbC9jZ3JvdXAu
Yw0KKysrIGIva2VybmVsL2Nncm91cC5jDQpAQCAtMzUwNCw2ICszNTA0LDcgQEAgc3RhdGljIGlu
dCBjZ3JvdXBfd3JpdGVfZXZlbnRfY29udHJvbChzdHJ1Y3QgY2dyb3VwICpjZ3JwLCBzdHJ1Y3Qg
Y2Z0eXBlICpjZnQsDQogCQkJCSAgICAgIGNvbnN0IGNoYXIgKmJ1ZmZlcikNCiB7DQogCXN0cnVj
dCBjZ3JvdXBfZXZlbnQgKmV2ZW50ID0gTlVMTDsNCisJc3RydWN0IGNncm91cCAqY2dycF9jZmls
ZTsNCiAJdW5zaWduZWQgaW50IGVmZCwgY2ZkOw0KIAlzdHJ1Y3QgZmlsZSAqZWZpbGUgPSBOVUxM
Ow0KIAlzdHJ1Y3QgZmlsZSAqY2ZpbGUgPSBOVUxMOw0KQEAgLTM1NTksNiArMzU2MCwxNiBAQCBz
dGF0aWMgaW50IGNncm91cF93cml0ZV9ldmVudF9jb250cm9sKHN0cnVjdCBjZ3JvdXAgKmNncnAs
IHN0cnVjdCBjZnR5cGUgKmNmdCwNCiAJCWdvdG8gZmFpbDsNCiAJfQ0KIA0KKwkvKg0KKwkgKiBU
aGUgZmlsZSB0byBiZSBtb25pdG9yZWQgbXVzdCBiZSBpbiB0aGUgc2FtZSBjZ3JvdXAgYXMNCisJ
ICogY2dyb3VwLmV2ZW50X2NvbnRyb2wgaXMuDQorCSAqLw0KKwljZ3JwX2NmaWxlID0gX19kX2Nn
cnAoY2ZpbGUtPmZfZGVudHJ5LT5kX3BhcmVudCk7DQorCWlmIChjZ3JwX2NmaWxlICE9IGNncnAp
IHsNCisJCXJldCA9IC1FSU5WQUw7DQorCQlnb3RvIGZhaWw7DQorCX0NCisNCiAJaWYgKCFldmVu
dC0+Y2Z0LT5yZWdpc3Rlcl9ldmVudCB8fCAhZXZlbnQtPmNmdC0+dW5yZWdpc3Rlcl9ldmVudCkg
ew0KIAkJcmV0ID0gLUVJTlZBTDsNCiAJCWdvdG8gZmFpbDsNCmRpZmYgLS1naXQgYS9rZXJuZWwv
ZXZlbnRzL2NvcmUuYyBiL2tlcm5lbC9ldmVudHMvY29yZS5jDQppbmRleCA1YmJlNDQzLi44M2Q1
NjIxIDEwMDY0NA0KLS0tIGEva2VybmVsL2V2ZW50cy9jb3JlLmMNCisrKyBiL2tlcm5lbC9ldmVu
dHMvY29yZS5jDQpAQCAtMjQyLDkgKzI0Miw5IEBAIHBlcmZfY2dyb3VwX21hdGNoKHN0cnVjdCBw
ZXJmX2V2ZW50ICpldmVudCkNCiAJcmV0dXJuICFldmVudC0+Y2dycCB8fCBldmVudC0+Y2dycCA9
PSBjcHVjdHgtPmNncnA7DQogfQ0KIA0KLXN0YXRpYyBpbmxpbmUgdm9pZCBwZXJmX2dldF9jZ3Jv
dXAoc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50KQ0KK3N0YXRpYyBpbmxpbmUgYm9vbCBwZXJmX3Ry
eWdldF9jZ3JvdXAoc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50KQ0KIHsNCi0JY3NzX2dldCgmZXZl
bnQtPmNncnAtPmNzcyk7DQorCXJldHVybiBjc3NfdHJ5Z2V0KCZldmVudC0+Y2dycC0+Y3NzKTsN
CiB9DQogDQogc3RhdGljIGlubGluZSB2b2lkIHBlcmZfcHV0X2Nncm91cChzdHJ1Y3QgcGVyZl9l
dmVudCAqZXZlbnQpDQpAQCAtMzYwLDYgKzM2MCw4IEBAIHZvaWQgcGVyZl9jZ3JvdXBfc3dpdGNo
KHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaywgaW50IG1vZGUpDQogDQogCWxpc3RfZm9yX2VhY2hf
ZW50cnlfcmN1KHBtdSwgJnBtdXMsIGVudHJ5KSB7DQogCQljcHVjdHggPSB0aGlzX2NwdV9wdHIo
cG11LT5wbXVfY3B1X2NvbnRleHQpOw0KKwkJaWYgKGNwdWN0eC0+dW5pcXVlX3BtdSAhPSBwbXUp
DQorCQkJY29udGludWU7IC8qIGVuc3VyZSB3ZSBwcm9jZXNzIGVhY2ggY3B1Y3R4IG9uY2UgKi8N
CiANCiAJCS8qDQogCQkgKiBwZXJmX2Nncm91cF9ldmVudHMgc2F5cyBhdCBsZWFzdCBvbmUNCkBA
IC0zODMsOSArMzg1LDEwIEBAIHZvaWQgcGVyZl9jZ3JvdXBfc3dpdGNoKHN0cnVjdCB0YXNrX3N0
cnVjdCAqdGFzaywgaW50IG1vZGUpDQogDQogCQkJaWYgKG1vZGUgJiBQRVJGX0NHUk9VUF9TV0lO
KSB7DQogCQkJCVdBUk5fT05fT05DRShjcHVjdHgtPmNncnApOw0KLQkJCQkvKiBzZXQgY2dycCBi
ZWZvcmUgY3R4c3cgaW4gdG8NCi0JCQkJICogYWxsb3cgZXZlbnRfZmlsdGVyX21hdGNoKCkgdG8g
bm90DQotCQkJCSAqIGhhdmUgdG8gcGFzcyB0YXNrIGFyb3VuZA0KKwkJCQkvKg0KKwkJCQkgKiBz
ZXQgY2dycCBiZWZvcmUgY3R4c3cgaW4gdG8gYWxsb3cNCisJCQkJICogZXZlbnRfZmlsdGVyX21h
dGNoKCkgdG8gbm90IGhhdmUgdG8gcGFzcw0KKwkJCQkgKiB0YXNrIGFyb3VuZA0KIAkJCQkgKi8N
CiAJCQkJY3B1Y3R4LT5jZ3JwID0gcGVyZl9jZ3JvdXBfZnJvbV90YXNrKHRhc2spOw0KIAkJCQlj
cHVfY3R4X3NjaGVkX2luKGNwdWN0eCwgRVZFTlRfQUxMLCB0YXNrKTsNCkBAIC00NzMsNyArNDc2
LDExIEBAIHN0YXRpYyBpbmxpbmUgaW50IHBlcmZfY2dyb3VwX2Nvbm5lY3QoaW50IGZkLCBzdHJ1
Y3QgcGVyZl9ldmVudCAqZXZlbnQsDQogCWV2ZW50LT5jZ3JwID0gY2dycDsNCiANCiAJLyogbXVz
dCBiZSBkb25lIGJlZm9yZSB3ZSBmcHV0KCkgdGhlIGZpbGUgKi8NCi0JcGVyZl9nZXRfY2dyb3Vw
KGV2ZW50KTsNCisJaWYgKCFwZXJmX3RyeWdldF9jZ3JvdXAoZXZlbnQpKSB7DQorCQlldmVudC0+
Y2dycCA9IE5VTEw7DQorCQlyZXQgPSAtRU5PRU5UOw0KKwkJZ290byBvdXQ7DQorCX0NCiANCiAJ
LyoNCiAJICogYWxsIGV2ZW50cyBpbiBhIGdyb3VwIG11c3QgbW9uaXRvcg0KQEAgLTQzNzcsNyAr
NDM4NCw3IEBAIHN0YXRpYyB2b2lkIHBlcmZfZXZlbnRfdGFza19ldmVudChzdHJ1Y3QgcGVyZl90
YXNrX2V2ZW50ICp0YXNrX2V2ZW50KQ0KIAlyY3VfcmVhZF9sb2NrKCk7DQogCWxpc3RfZm9yX2Vh
Y2hfZW50cnlfcmN1KHBtdSwgJnBtdXMsIGVudHJ5KSB7DQogCQljcHVjdHggPSBnZXRfY3B1X3B0
cihwbXUtPnBtdV9jcHVfY29udGV4dCk7DQotCQlpZiAoY3B1Y3R4LT5hY3RpdmVfcG11ICE9IHBt
dSkNCisJCWlmIChjcHVjdHgtPnVuaXF1ZV9wbXUgIT0gcG11KQ0KIAkJCWdvdG8gbmV4dDsNCiAJ
CXBlcmZfZXZlbnRfdGFza19jdHgoJmNwdWN0eC0+Y3R4LCB0YXNrX2V2ZW50KTsNCiANCkBAIC00
NTIzLDcgKzQ1MzAsNyBAQCBzdGF0aWMgdm9pZCBwZXJmX2V2ZW50X2NvbW1fZXZlbnQoc3RydWN0
IHBlcmZfY29tbV9ldmVudCAqY29tbV9ldmVudCkNCiAJcmN1X3JlYWRfbG9jaygpOw0KIAlsaXN0
X2Zvcl9lYWNoX2VudHJ5X3JjdShwbXUsICZwbXVzLCBlbnRyeSkgew0KIAkJY3B1Y3R4ID0gZ2V0
X2NwdV9wdHIocG11LT5wbXVfY3B1X2NvbnRleHQpOw0KLQkJaWYgKGNwdWN0eC0+YWN0aXZlX3Bt
dSAhPSBwbXUpDQorCQlpZiAoY3B1Y3R4LT51bmlxdWVfcG11ICE9IHBtdSkNCiAJCQlnb3RvIG5l
eHQ7DQogCQlwZXJmX2V2ZW50X2NvbW1fY3R4KCZjcHVjdHgtPmN0eCwgY29tbV9ldmVudCk7DQog
DQpAQCAtNDcxOSw3ICs0NzI2LDcgQEAgZ290X25hbWU6DQogCXJjdV9yZWFkX2xvY2soKTsNCiAJ
bGlzdF9mb3JfZWFjaF9lbnRyeV9yY3UocG11LCAmcG11cywgZW50cnkpIHsNCiAJCWNwdWN0eCA9
IGdldF9jcHVfcHRyKHBtdS0+cG11X2NwdV9jb250ZXh0KTsNCi0JCWlmIChjcHVjdHgtPmFjdGl2
ZV9wbXUgIT0gcG11KQ0KKwkJaWYgKGNwdWN0eC0+dW5pcXVlX3BtdSAhPSBwbXUpDQogCQkJZ290
byBuZXh0Ow0KIAkJcGVyZl9ldmVudF9tbWFwX2N0eCgmY3B1Y3R4LT5jdHgsIG1tYXBfZXZlbnQs
DQogCQkJCQl2bWEtPnZtX2ZsYWdzICYgVk1fRVhFQyk7DQpAQCAtNTc0MSw4ICs1NzQ4LDggQEAg
c3RhdGljIHZvaWQgdXBkYXRlX3BtdV9jb250ZXh0KHN0cnVjdCBwbXUgKnBtdSwgc3RydWN0IHBt
dSAqb2xkX3BtdSkNCiANCiAJCWNwdWN0eCA9IHBlcl9jcHVfcHRyKHBtdS0+cG11X2NwdV9jb250
ZXh0LCBjcHUpOw0KIA0KLQkJaWYgKGNwdWN0eC0+YWN0aXZlX3BtdSA9PSBvbGRfcG11KQ0KLQkJ
CWNwdWN0eC0+YWN0aXZlX3BtdSA9IHBtdTsNCisJCWlmIChjcHVjdHgtPnVuaXF1ZV9wbXUgPT0g
b2xkX3BtdSkNCisJCQljcHVjdHgtPnVuaXF1ZV9wbXUgPSBwbXU7DQogCX0NCiB9DQogDQpAQCAt
NTg3Nyw3ICs1ODg0LDcgQEAgc2tpcF90eXBlOg0KIAkJY3B1Y3R4LT5jdHgucG11ID0gcG11Ow0K
IAkJY3B1Y3R4LT5qaWZmaWVzX2ludGVydmFsID0gMTsNCiAJCUlOSVRfTElTVF9IRUFEKCZjcHVj
dHgtPnJvdGF0aW9uX2xpc3QpOw0KLQkJY3B1Y3R4LT5hY3RpdmVfcG11ID0gcG11Ow0KKwkJY3B1
Y3R4LT51bmlxdWVfcG11ID0gcG11Ow0KIAl9DQogDQogZ290X2NwdV9jb250ZXh0Og0KZGlmZiAt
LWdpdCBhL2tlcm5lbC9zY2hlZF9mYWlyLmMgYi9rZXJuZWwvc2NoZWRfZmFpci5jDQppbmRleCA1
OTQ3NGM1Li5jMjYxZGE3IDEwMDY0NA0KLS0tIGEva2VybmVsL3NjaGVkX2ZhaXIuYw0KKysrIGIv
a2VybmVsL3NjaGVkX2ZhaXIuYw0KQEAgLTQ4OTAsMTEgKzQ4OTAsMTUgQEAgc3RhdGljIHZvaWQg
dGFza19mb3JrX2ZhaXIoc3RydWN0IHRhc2tfc3RydWN0ICpwKQ0KIA0KIAl1cGRhdGVfcnFfY2xv
Y2socnEpOw0KIA0KLQlpZiAodW5saWtlbHkodGFza19jcHUocCkgIT0gdGhpc19jcHUpKSB7DQot
CQlyY3VfcmVhZF9sb2NrKCk7DQotCQlfX3NldF90YXNrX2NwdShwLCB0aGlzX2NwdSk7DQotCQly
Y3VfcmVhZF91bmxvY2soKTsNCi0JfQ0KKwkvKg0KKwkgKiBOb3Qgb25seSB0aGUgY3B1IGJ1dCBh
bHNvIHRoZSB0YXNrX2dyb3VwIG9mIHRoZSBwYXJlbnQgbWlnaHQgaGF2ZQ0KKwkgKiBiZWVuIGNo
YW5nZWQgYWZ0ZXIgcGFyZW50LT5zZS5wYXJlbnQsY2ZzX3JxIHdlcmUgY29waWVkIHRvDQorCSAq
IGNoaWxkLT5zZS5wYXJlbnQsY2ZzX3JxLiBTbyBjYWxsIF9fc2V0X3Rhc2tfY3B1KCkgdG8gbWFr
ZSB0aG9zZQ0KKwkgKiBvZiBjaGlsZCBwb2ludCB0byB2YWxpZCBvbmVzLg0KKwkgKi8NCisJcmN1
X3JlYWRfbG9jaygpOw0KKwlfX3NldF90YXNrX2NwdShwLCB0aGlzX2NwdSk7DQorCXJjdV9yZWFk
X3VubG9jaygpOw0KIA0KIAl1cGRhdGVfY3VycihjZnNfcnEpOw0KIA0KZGlmZiAtLWdpdCBhL2xp
Yi9zaG93X21lbS5jIGIvbGliL3Nob3dfbWVtLmMNCmluZGV4IDQ0MDdmOGMuLmI3YzcyMzEgMTAw
NjQ0DQotLS0gYS9saWIvc2hvd19tZW0uYw0KKysrIGIvbGliL3Nob3dfbWVtLmMNCkBAIC0xOCw2
ICsxOCw5IEBAIHZvaWQgc2hvd19tZW0odW5zaWduZWQgaW50IGZpbHRlcikNCiAJcHJpbnRrKCJN
ZW0tSW5mbzpcbiIpOw0KIAlzaG93X2ZyZWVfYXJlYXMoZmlsdGVyKTsNCiANCisJaWYgKGZpbHRl
ciAmIFNIT1dfTUVNX0ZJTFRFUl9QQUdFX0NPVU5UKQ0KKwkJcmV0dXJuOw0KKw0KIAlmb3JfZWFj
aF9vbmxpbmVfcGdkYXQocGdkYXQpIHsNCiAJCXVuc2lnbmVkIGxvbmcgaSwgZmxhZ3M7DQogDQpk
aWZmIC0tZ2l0IGEvbW0vaHVnZV9tZW1vcnkuYyBiL21tL2h1Z2VfbWVtb3J5LmMNCmluZGV4IGQ4
MGFjNGIuLmVkMGVkOGEgMTAwNjQ0DQotLS0gYS9tbS9odWdlX21lbW9yeS5jDQorKysgYi9tbS9o
dWdlX21lbW9yeS5jDQpAQCAtMTg4Miw2ICsxODgyLDggQEAgc3RhdGljIHZvaWQgY29sbGFwc2Vf
aHVnZV9wYWdlKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLA0KIAkJZ290byBvdXQ7DQogDQogCXZtYSA9
IGZpbmRfdm1hKG1tLCBhZGRyZXNzKTsNCisJaWYgKCF2bWEpDQorCQlnb3RvIG91dDsNCiAJaHN0
YXJ0ID0gKHZtYS0+dm1fc3RhcnQgKyB+SFBBR0VfUE1EX01BU0spICYgSFBBR0VfUE1EX01BU0s7
DQogCWhlbmQgPSB2bWEtPnZtX2VuZCAmIEhQQUdFX1BNRF9NQVNLOw0KIAlpZiAoYWRkcmVzcyA8
IGhzdGFydCB8fCBhZGRyZXNzICsgSFBBR0VfUE1EX1NJWkUgPiBoZW5kKQ0KZGlmZiAtLWdpdCBh
L21tL21lbWNvbnRyb2wuYyBiL21tL21lbWNvbnRyb2wuYw0KaW5kZXggZDAyN2EyNC4uMjA0ZGU2
YSAxMDA2NDQNCi0tLSBhL21tL21lbWNvbnRyb2wuYw0KKysrIGIvbW0vbWVtY29udHJvbC5jDQpA
QCAtNDM4NSw3ICs0Mzg1LDEzIEBAIHN0YXRpYyBpbnQgY29tcGFyZV90aHJlc2hvbGRzKGNvbnN0
IHZvaWQgKmEsIGNvbnN0IHZvaWQgKmIpDQogCWNvbnN0IHN0cnVjdCBtZW1fY2dyb3VwX3RocmVz
aG9sZCAqX2EgPSBhOw0KIAljb25zdCBzdHJ1Y3QgbWVtX2Nncm91cF90aHJlc2hvbGQgKl9iID0g
YjsNCiANCi0JcmV0dXJuIF9hLT50aHJlc2hvbGQgLSBfYi0+dGhyZXNob2xkOw0KKwlpZiAoX2Et
PnRocmVzaG9sZCA+IF9iLT50aHJlc2hvbGQpDQorCQlyZXR1cm4gMTsNCisNCisJaWYgKF9hLT50
aHJlc2hvbGQgPCBfYi0+dGhyZXNob2xkKQ0KKwkJcmV0dXJuIC0xOw0KKw0KKwlyZXR1cm4gMDsN
CiB9DQogDQogc3RhdGljIGludCBtZW1fY2dyb3VwX29vbV9ub3RpZnlfY2Ioc3RydWN0IG1lbV9j
Z3JvdXAgKm1lbWNnKQ0KZGlmZiAtLWdpdCBhL21tL3BhZ2VfYWxsb2MuYyBiL21tL3BhZ2VfYWxs
b2MuYw0KaW5kZXggYjVhZmVhMi4uZDg3NjJiMiAxMDA2NDQNCi0tLSBhL21tL3BhZ2VfYWxsb2Mu
Yw0KKysrIGIvbW0vcGFnZV9hbGxvYy5jDQpAQCAtMTc2MCw2ICsxNzYwLDEzIEBAIHZvaWQgd2Fy
bl9hbGxvY19mYWlsZWQoZ2ZwX3QgZ2ZwX21hc2ssIGludCBvcmRlciwgY29uc3QgY2hhciAqZm10
LCAuLi4pDQogCQlyZXR1cm47DQogDQogCS8qDQorCSAqIFdhbGtpbmcgYWxsIG1lbW9yeSB0byBj
b3VudCBwYWdlIHR5cGVzIGlzIHZlcnkgZXhwZW5zaXZlIGFuZCBzaG91bGQNCisJICogYmUgaW5o
aWJpdGVkIGluIG5vbi1ibG9ja2FibGUgY29udGV4dHMuDQorCSAqLw0KKwlpZiAoIShnZnBfbWFz
ayAmIF9fR0ZQX1dBSVQpKQ0KKwkJZmlsdGVyIHw9IFNIT1dfTUVNX0ZJTFRFUl9QQUdFX0NPVU5U
Ow0KKw0KKwkvKg0KIAkgKiBUaGlzIGRvY3VtZW50cyBleGNlcHRpb25zIGdpdmVuIHRvIGFsbG9j
YXRpb25zIGluIGNlcnRhaW4NCiAJICogY29udGV4dHMgdGhhdCBhcmUgYWxsb3dlZCB0byBhbGxv
Y2F0ZSBvdXRzaWRlIGN1cnJlbnQncyBzZXQNCiAJICogb2YgYWxsb3dlZCBub2Rlcy4NCmRpZmYg
LS1naXQgYS9uZXQvYnJpZGdlL2JyX211bHRpY2FzdC5jIGIvbmV0L2JyaWRnZS9icl9tdWx0aWNh
c3QuYw0KaW5kZXggYjgxNTAwYy4uYTA2ZGVjYSAxMDA2NDQNCi0tLSBhL25ldC9icmlkZ2UvYnJf
bXVsdGljYXN0LmMNCisrKyBiL25ldC9icmlkZ2UvYnJfbXVsdGljYXN0LmMNCkBAIC0xMTU1LDcg
KzExNTUsOCBAQCBzdGF0aWMgaW50IGJyX2lwNl9tdWx0aWNhc3RfcXVlcnkoc3RydWN0IG5ldF9i
cmlkZ2UgKmJyLA0KIAkJbWxkMnEgPSAoc3RydWN0IG1sZDJfcXVlcnkgKilpY21wNl9oZHIoc2ti
KTsNCiAJCWlmICghbWxkMnEtPm1sZDJxX25zcmNzKQ0KIAkJCWdyb3VwID0gJm1sZDJxLT5tbGQy
cV9tY2E7DQotCQltYXhfZGVsYXkgPSBtbGQycS0+bWxkMnFfbXJjID8gTUxEVjJfTVJDKG1sZDJx
LT5tbGQycV9tcmMpIDogMTsNCisNCisJCW1heF9kZWxheSA9IG1heChtc2Vjc190b19qaWZmaWVz
KE1MRFYyX01SQyhudG9ocyhtbGQycS0+bWxkMnFfbXJjKSkpLCAxVUwpOw0KIAl9DQogDQogCWlm
ICghZ3JvdXApDQpkaWZmIC0tZ2l0IGEvbmV0L2JyaWRnZS9icl9zdHAuYyBiL25ldC9icmlkZ2Uv
YnJfc3RwLmMNCmluZGV4IGRkMTQ3ZDcuLjhhYzk0NmYgMTAwNjQ0DQotLS0gYS9uZXQvYnJpZGdl
L2JyX3N0cC5jDQorKysgYi9uZXQvYnJpZGdlL2JyX3N0cC5jDQpAQCAtMTg5LDcgKzE4OSw3IEBA
IHN0YXRpYyB2b2lkIGJyX3JlY29yZF9jb25maWdfaW5mb3JtYXRpb24oc3RydWN0IG5ldF9icmlk
Z2VfcG9ydCAqcCwNCiAJcC0+ZGVzaWduYXRlZF9hZ2UgPSBqaWZmaWVzICsgYnBkdS0+bWVzc2Fn
ZV9hZ2U7DQogDQogCW1vZF90aW1lcigmcC0+bWVzc2FnZV9hZ2VfdGltZXIsIGppZmZpZXMNCi0J
CSAgKyAocC0+YnItPm1heF9hZ2UgLSBicGR1LT5tZXNzYWdlX2FnZSkpOw0KKwkJICArIChicGR1
LT5tYXhfYWdlIC0gYnBkdS0+bWVzc2FnZV9hZ2UpKTsNCiB9DQogDQogLyogY2FsbGVkIHVuZGVy
IGJyaWRnZSBsb2NrICovDQpkaWZmIC0tZ2l0IGEvbmV0L2NhaWYvY2ZjdHJsLmMgYi9uZXQvY2Fp
Zi9jZmN0cmwuYw0KaW5kZXggNWNmNTIyMi4uODRlZmJlNCAxMDA2NDQNCi0tLSBhL25ldC9jYWlm
L2NmY3RybC5jDQorKysgYi9uZXQvY2FpZi9jZmN0cmwuYw0KQEAgLTI4OCw5ICsyODgsMTAgQEAg
aW50IGNmY3RybF9saW5rdXBfcmVxdWVzdChzdHJ1Y3QgY2ZsYXllciAqbGF5ZXIsDQogDQogCQlj
b3VudCA9IGNmY3RybF9jYW5jZWxfcmVxKCZjZmN0cmwtPnNlcnYubGF5ZXIsDQogCQkJCQkJdXNl
cl9sYXllcik7DQotCQlpZiAoY291bnQgIT0gMSkNCisJCWlmIChjb3VudCAhPSAxKSB7DQogCQkJ
cHJfZXJyKCJDb3VsZCBub3QgcmVtb3ZlIHJlcXVlc3QgKCVkKSIsIGNvdW50KTsNCiAJCQlyZXR1
cm4gLUVOT0RFVjsNCisJCX0NCiAJfQ0KIAlyZXR1cm4gMDsNCiB9DQpkaWZmIC0tZ2l0IGEvbmV0
L2NlcGgvb3NkX2NsaWVudC5jIGIvbmV0L2NlcGgvb3NkX2NsaWVudC5jDQppbmRleCBmNGYzZjU4
Li5hNzBmNDI2IDEwMDY0NA0KLS0tIGEvbmV0L2NlcGgvb3NkX2NsaWVudC5jDQorKysgYi9uZXQv
Y2VwaC9vc2RfY2xpZW50LmMNCkBAIC0xNzE5LDYgKzE3MTksOCBAQCBpbnQgY2VwaF9vc2RjX3N0
YXJ0X3JlcXVlc3Qoc3RydWN0IGNlcGhfb3NkX2NsaWVudCAqb3NkYywNCiAJCQkJZG91dCgib3Nk
Y19zdGFydF9yZXF1ZXN0IGZhaWxlZCBtYXAsICINCiAJCQkJICAgICAiIHdpbGwgcmV0cnkgJWxs
ZFxuIiwgcmVxLT5yX3RpZCk7DQogCQkJCXJjID0gMDsNCisJCQl9IGVsc2Ugew0KKwkJCQlfX3Vu
cmVnaXN0ZXJfcmVxdWVzdChvc2RjLCByZXEpOw0KIAkJCX0NCiAJCQlnb3RvIG91dF91bmxvY2s7
DQogCQl9DQpkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvbmV0cG9sbC5jIGIvbmV0L2NvcmUvbmV0cG9s
bC5jDQppbmRleCBkYjRiYjdhLi45NjQ5Y2VhIDEwMDY0NA0KLS0tIGEvbmV0L2NvcmUvbmV0cG9s
bC5jDQorKysgYi9uZXQvY29yZS9uZXRwb2xsLmMNCkBAIC05MjMsMTUgKzkyMywxNCBAQCBFWFBP
UlRfU1lNQk9MX0dQTChfX25ldHBvbGxfY2xlYW51cCk7DQogDQogdm9pZCBuZXRwb2xsX2NsZWFu
dXAoc3RydWN0IG5ldHBvbGwgKm5wKQ0KIHsNCi0JaWYgKCFucC0+ZGV2KQ0KLQkJcmV0dXJuOw0K
LQ0KIAlydG5sX2xvY2soKTsNCisJaWYgKCFucC0+ZGV2KQ0KKwkJZ290byBvdXQ7DQogCV9fbmV0
cG9sbF9jbGVhbnVwKG5wKTsNCi0JcnRubF91bmxvY2soKTsNCi0NCiAJZGV2X3B1dChucC0+ZGV2
KTsNCiAJbnAtPmRldiA9IE5VTEw7DQorb3V0Og0KKwlydG5sX3VubG9jaygpOw0KIH0NCiBFWFBP
UlRfU1lNQk9MKG5ldHBvbGxfY2xlYW51cCk7DQogDQpkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvc3lz
Y3RsX25ldF9jb3JlLmMgYi9uZXQvY29yZS9zeXNjdGxfbmV0X2NvcmUuYw0KaW5kZXggNzdhNjVm
MC4uZjBiZGQzNiAxMDA2NDQNCi0tLSBhL25ldC9jb3JlL3N5c2N0bF9uZXRfY29yZS5jDQorKysg
Yi9uZXQvY29yZS9zeXNjdGxfbmV0X2NvcmUuYw0KQEAgLTE5LDYgKzE5LDkgQEANCiAjaW5jbHVk
ZSA8bmV0L3NvY2suaD4NCiAjaW5jbHVkZSA8bmV0L25ldF9yYXRlbGltaXQuaD4NCiANCitzdGF0
aWMgaW50IHplcm8gPSAwOw0KK3N0YXRpYyBpbnQgdXNob3J0X21heCA9IFVTSFJUX01BWDsNCisN
CiAjaWZkZWYgQ09ORklHX1JQUw0KIHN0YXRpYyBpbnQgcnBzX3NvY2tfZmxvd19zeXNjdGwoY3Rs
X3RhYmxlICp0YWJsZSwgaW50IHdyaXRlLA0KIAkJCQl2b2lkIF9fdXNlciAqYnVmZmVyLCBzaXpl
X3QgKmxlbnAsIGxvZmZfdCAqcHBvcykNCkBAIC0xOTIsNyArMTk1LDkgQEAgc3RhdGljIHN0cnVj
dCBjdGxfdGFibGUgbmV0bnNfY29yZV90YWJsZVtdID0gew0KIAkJLmRhdGEJCT0gJmluaXRfbmV0
LmNvcmUuc3lzY3RsX3NvbWF4Y29ubiwNCiAJCS5tYXhsZW4JCT0gc2l6ZW9mKGludCksDQogCQku
bW9kZQkJPSAwNjQ0LA0KLQkJLnByb2NfaGFuZGxlcgk9IHByb2NfZG9pbnR2ZWMNCisJCS5leHRy
YTEJCT0gJnplcm8sDQorCQkuZXh0cmEyCQk9ICZ1c2hvcnRfbWF4LA0KKwkJLnByb2NfaGFuZGxl
cgk9IHByb2NfZG9pbnR2ZWNfbWlubWF4DQogCX0sDQogCXsgfQ0KIH07DQpkaWZmIC0tZ2l0IGEv
bmV0L2lwdjQvZmliX3RyaWUuYyBiL25ldC9pcHY0L2ZpYl90cmllLmMNCmluZGV4IGNkMmQ2Mzku
LmM3YzY3MjQgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC9maWJfdHJpZS5jDQorKysgYi9uZXQvaXB2
NC9maWJfdHJpZS5jDQpAQCAtNzIsNyArNzIsNiBAQA0KICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+
DQogI2luY2x1ZGUgPGxpbnV4L2xpc3QuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KLSNp
bmNsdWRlIDxsaW51eC9wcmVmZXRjaC5oPg0KICNpbmNsdWRlIDxsaW51eC9leHBvcnQuaD4NCiAj
aW5jbHVkZSA8bmV0L25ldF9uYW1lc3BhY2UuaD4NCiAjaW5jbHVkZSA8bmV0L2lwLmg+DQpAQCAt
MTc3MywxMCArMTc3Miw4IEBAIHN0YXRpYyBzdHJ1Y3QgbGVhZiAqbGVhZl93YWxrX3JjdShzdHJ1
Y3QgdG5vZGUgKnAsIHN0cnVjdCBydF90cmllX25vZGUgKmMpDQogCQkJaWYgKCFjKQ0KIAkJCQlj
b250aW51ZTsNCiANCi0JCQlpZiAoSVNfTEVBRihjKSkgew0KLQkJCQlwcmVmZXRjaChyY3VfZGVy
ZWZlcmVuY2VfcnRubChwLT5jaGlsZFtpZHhdKSk7DQorCQkJaWYgKElTX0xFQUYoYykpDQogCQkJ
CXJldHVybiAoc3RydWN0IGxlYWYgKikgYzsNCi0JCQl9DQogDQogCQkJLyogUmVzY2FuIHN0YXJ0
IHNjYW5uaW5nIGluIG5ldyBub2RlICovDQogCQkJcCA9IChzdHJ1Y3QgdG5vZGUgKikgYzsNCmRp
ZmYgLS1naXQgYS9uZXQvaXB2NC9pZ21wLmMgYi9uZXQvaXB2NC9pZ21wLmMNCmluZGV4IGM4OTg5
YTcuLjc1YjA4NjAgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC9pZ21wLmMNCisrKyBiL25ldC9pcHY0
L2lnbXAuYw0KQEAgLTM0Miw3ICszNDIsNyBAQCBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKmlnbXB2
M19uZXdwYWNrKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIGludCBzaXplKQ0KIAlwaXAtPnNhZGRy
ICAgID0gZmw0LnNhZGRyOw0KIAlwaXAtPnByb3RvY29sID0gSVBQUk9UT19JR01QOw0KIAlwaXAt
PnRvdF9sZW4gID0gMDsJLyogZmlsbGVkIGluIGxhdGVyICovDQotCWlwX3NlbGVjdF9pZGVudChw
aXAsICZydC0+ZHN0LCBOVUxMKTsNCisJaXBfc2VsZWN0X2lkZW50KHNrYiwgJnJ0LT5kc3QsIE5V
TEwpOw0KIAkoKHU4KikmcGlwWzFdKVswXSA9IElQT1BUX1JBOw0KIAkoKHU4KikmcGlwWzFdKVsx
XSA9IDQ7DQogCSgodTgqKSZwaXBbMV0pWzJdID0gMDsNCkBAIC02ODMsNyArNjgzLDcgQEAgc3Rh
dGljIGludCBpZ21wX3NlbmRfcmVwb3J0KHN0cnVjdCBpbl9kZXZpY2UgKmluX2Rldiwgc3RydWN0
IGlwX21jX2xpc3QgKnBtYywNCiAJaXBoLT5kYWRkciAgICA9IGRzdDsNCiAJaXBoLT5zYWRkciAg
ICA9IGZsNC5zYWRkcjsNCiAJaXBoLT5wcm90b2NvbCA9IElQUFJPVE9fSUdNUDsNCi0JaXBfc2Vs
ZWN0X2lkZW50KGlwaCwgJnJ0LT5kc3QsIE5VTEwpOw0KKwlpcF9zZWxlY3RfaWRlbnQoc2tiLCAm
cnQtPmRzdCwgTlVMTCk7DQogCSgodTgqKSZpcGhbMV0pWzBdID0gSVBPUFRfUkE7DQogCSgodTgq
KSZpcGhbMV0pWzFdID0gNDsNCiAJKCh1OCopJmlwaFsxXSlbMl0gPSAwOw0KQEAgLTcwNSw3ICs3
MDUsNyBAQCBzdGF0aWMgdm9pZCBpZ21wX2dxX3RpbWVyX2V4cGlyZSh1bnNpZ25lZCBsb25nIGRh
dGEpDQogDQogCWluX2Rldi0+bXJfZ3FfcnVubmluZyA9IDA7DQogCWlnbXB2M19zZW5kX3JlcG9y
dChpbl9kZXYsIE5VTEwpOw0KLQlfX2luX2Rldl9wdXQoaW5fZGV2KTsNCisJaW5fZGV2X3B1dChp
bl9kZXYpOw0KIH0NCiANCiBzdGF0aWMgdm9pZCBpZ21wX2lmY190aW1lcl9leHBpcmUodW5zaWdu
ZWQgbG9uZyBkYXRhKQ0KQEAgLTcxNyw3ICs3MTcsNyBAQCBzdGF0aWMgdm9pZCBpZ21wX2lmY190
aW1lcl9leHBpcmUodW5zaWduZWQgbG9uZyBkYXRhKQ0KIAkJaW5fZGV2LT5tcl9pZmNfY291bnQt
LTsNCiAJCWlnbXBfaWZjX3N0YXJ0X3RpbWVyKGluX2RldiwgSUdNUF9VbnNvbGljaXRlZF9SZXBv
cnRfSW50ZXJ2YWwpOw0KIAl9DQotCV9faW5fZGV2X3B1dChpbl9kZXYpOw0KKwlpbl9kZXZfcHV0
KGluX2Rldik7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIGlnbXBfaWZjX2V2ZW50KHN0cnVjdCBpbl9k
ZXZpY2UgKmluX2RldikNCmRpZmYgLS1naXQgYS9uZXQvaXB2NC9pbmV0cGVlci5jIGIvbmV0L2lw
djQvaW5ldHBlZXIuYw0KaW5kZXggODZmMTNjNjcuLjU4YzRlNjk2IDEwMDY0NA0KLS0tIGEvbmV0
L2lwdjQvaW5ldHBlZXIuYw0KKysrIGIvbmV0L2lwdjQvaW5ldHBlZXIuYw0KQEAgLTE3LDYgKzE3
LDcgQEANCiAjaW5jbHVkZSA8bGludXgva2VybmVsLmg+DQogI2luY2x1ZGUgPGxpbnV4L21tLmg+
DQogI2luY2x1ZGUgPGxpbnV4L25ldC5oPg0KKyNpbmNsdWRlIDxsaW51eC93b3JrcXVldWUuaD4N
CiAjaW5jbHVkZSA8bmV0L2lwLmg+DQogI2luY2x1ZGUgPG5ldC9pbmV0cGVlci5oPg0KICNpbmNs
dWRlIDxuZXQvc2VjdXJlX3NlcS5oPg0KQEAgLTMxLDggKzMyLDggQEANCiAgKiAgQXQgdGhlIG1v
bWVudCBvZiB3cml0aW5nIHRoaXMgbm90ZXMgaWRlbnRpZmllciBvZiBJUCBwYWNrZXRzIGlzIGdl
bmVyYXRlZA0KICAqICB0byBiZSB1bnByZWRpY3RhYmxlIHVzaW5nIHRoaXMgY29kZSBvbmx5IGZv
ciBwYWNrZXRzIHN1YmplY3RlZA0KICAqICAoYWN0dWFsbHkgb3IgcG90ZW50aWFsbHkpIHRvIGRl
ZnJhZ21lbnRhdGlvbi4gIEkuZS4gREYgcGFja2V0cyBsZXNzIHRoYW4NCi0gKiAgUE1UVSBpbiBz
aXplIHVzZXMgYSBjb25zdGFudCBJRCBhbmQgZG8gbm90IHVzZSB0aGlzIGNvZGUgKHNlZQ0KLSAq
ICBpcF9zZWxlY3RfaWRlbnQoKSBpbiBpbmNsdWRlL25ldC9pcC5oKS4NCisgKiAgUE1UVSBpbiBz
aXplIHdoZW4gbG9jYWwgZnJhZ21lbnRhdGlvbiBpcyBkaXNhYmxlZCB1c2UgYSBjb25zdGFudCBJ
RCBhbmQgZG8NCisgKiAgbm90IHVzZSB0aGlzIGNvZGUgKHNlZSBpcF9zZWxlY3RfaWRlbnQoKSBp
biBpbmNsdWRlL25ldC9pcC5oKS4NCiAgKg0KICAqICBSb3V0ZSBjYWNoZSBlbnRyaWVzIGhvbGQg
cmVmZXJlbmNlcyB0byBvdXIgbm9kZXMuDQogICogIE5ldyBjYWNoZSBlbnRyaWVzIGdldCByZWZl
cmVuY2VzIHZpYSBsb29rdXAgYnkgZGVzdGluYXRpb24gSVAgYWRkcmVzcyBpbg0KQEAgLTY2LDYg
KzY3LDExIEBADQogDQogc3RhdGljIHN0cnVjdCBrbWVtX2NhY2hlICpwZWVyX2NhY2hlcCBfX3Jl
YWRfbW9zdGx5Ow0KIA0KK3N0YXRpYyBMSVNUX0hFQUQoZ2NfbGlzdCk7DQorc3RhdGljIGNvbnN0
IGludCBnY19kZWxheSA9IDYwICogSFo7DQorc3RhdGljIHN0cnVjdCBkZWxheWVkX3dvcmsgZ2Nf
d29yazsNCitzdGF0aWMgREVGSU5FX1NQSU5MT0NLKGdjX2xvY2spOw0KKw0KICNkZWZpbmUgbm9k
ZV9oZWlnaHQoeCkgeC0+YXZsX2hlaWdodA0KIA0KICNkZWZpbmUgcGVlcl9hdmxfZW1wdHkgKChz
dHJ1Y3QgaW5ldF9wZWVyICopJnBlZXJfZmFrZV9ub2RlKQ0KQEAgLTEwMiw2ICsxMDgsNTAgQEAg
aW50IGluZXRfcGVlcl90aHJlc2hvbGQgX19yZWFkX21vc3RseSA9IDY1NTM2ICsgMTI4OwkvKiBz
dGFydCB0byB0aHJvdyBlbnRyaWVzIG0NCiBpbnQgaW5ldF9wZWVyX21pbnR0bCBfX3JlYWRfbW9z
dGx5ID0gMTIwICogSFo7CS8qIFRUTCB1bmRlciBoaWdoIGxvYWQ6IDEyMCBzZWMgKi8NCiBpbnQg
aW5ldF9wZWVyX21heHR0bCBfX3JlYWRfbW9zdGx5ID0gMTAgKiA2MCAqIEhaOwkvKiB1c3VhbCB0
aW1lIHRvIGxpdmU6IDEwIG1pbiAqLw0KIA0KK3N0YXRpYyB2b2lkIGluZXRwZWVyX2djX3dvcmtl
cihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQorew0KKwlzdHJ1Y3QgaW5ldF9wZWVyICpwLCAq
bjsNCisJTElTVF9IRUFEKGxpc3QpOw0KKw0KKwlzcGluX2xvY2tfYmgoJmdjX2xvY2spOw0KKwls
aXN0X3JlcGxhY2VfaW5pdCgmZ2NfbGlzdCwgJmxpc3QpOw0KKwlzcGluX3VubG9ja19iaCgmZ2Nf
bG9jayk7DQorDQorCWlmIChsaXN0X2VtcHR5KCZsaXN0KSkNCisJCXJldHVybjsNCisNCisJbGlz
dF9mb3JfZWFjaF9lbnRyeV9zYWZlKHAsIG4sICZsaXN0LCBnY19saXN0KSB7DQorDQorCQlpZihu
ZWVkX3Jlc2NoZWQoKSkNCisJCQljb25kX3Jlc2NoZWQoKTsNCisNCisJCWlmIChwLT5hdmxfbGVm
dCAhPSBwZWVyX2F2bF9lbXB0eSkgew0KKwkJCWxpc3RfYWRkX3RhaWwoJnAtPmF2bF9sZWZ0LT5n
Y19saXN0LCAmbGlzdCk7DQorCQkJcC0+YXZsX2xlZnQgPSBwZWVyX2F2bF9lbXB0eTsNCisJCX0N
CisNCisJCWlmIChwLT5hdmxfcmlnaHQgIT0gcGVlcl9hdmxfZW1wdHkpIHsNCisJCQlsaXN0X2Fk
ZF90YWlsKCZwLT5hdmxfcmlnaHQtPmdjX2xpc3QsICZsaXN0KTsNCisJCQlwLT5hdmxfcmlnaHQg
PSBwZWVyX2F2bF9lbXB0eTsNCisJCX0NCisNCisJCW4gPSBsaXN0X2VudHJ5KHAtPmdjX2xpc3Qu
bmV4dCwgc3RydWN0IGluZXRfcGVlciwgZ2NfbGlzdCk7DQorDQorCQlpZiAoIWF0b21pY19yZWFk
KCZwLT5yZWZjbnQpKSB7DQorCQkJbGlzdF9kZWwoJnAtPmdjX2xpc3QpOw0KKwkJCWttZW1fY2Fj
aGVfZnJlZShwZWVyX2NhY2hlcCwgcCk7DQorCQl9DQorCX0NCisNCisJaWYgKGxpc3RfZW1wdHko
Jmxpc3QpKQ0KKwkJcmV0dXJuOw0KKw0KKwlzcGluX2xvY2tfYmgoJmdjX2xvY2spOw0KKwlsaXN0
X3NwbGljZSgmbGlzdCwgJmdjX2xpc3QpOw0KKwlzcGluX3VubG9ja19iaCgmZ2NfbG9jayk7DQor
DQorCXNjaGVkdWxlX2RlbGF5ZWRfd29yaygmZ2Nfd29yaywgZ2NfZGVsYXkpOw0KK30NCiANCiAv
KiBDYWxsZWQgZnJvbSBpcF9vdXRwdXQuYzppcF9pbml0ICAqLw0KIHZvaWQgX19pbml0IGluZXRf
aW5pdHBlZXJzKHZvaWQpDQpAQCAtMTI2LDYgKzE3Niw3IEBAIHZvaWQgX19pbml0IGluZXRfaW5p
dHBlZXJzKHZvaWQpDQogCQkJMCwgU0xBQl9IV0NBQ0hFX0FMSUdOIHwgU0xBQl9QQU5JQywNCiAJ
CQlOVUxMKTsNCiANCisJSU5JVF9ERUxBWUVEX1dPUktfREVGRVJSQUJMRSgmZ2Nfd29yaywgaW5l
dHBlZXJfZ2Nfd29ya2VyKTsNCiB9DQogDQogc3RhdGljIGludCBhZGRyX2NvbXBhcmUoY29uc3Qg
c3RydWN0IGluZXRwZWVyX2FkZHIgKmEsDQpAQCAtNDQ4LDcgKzQ5OSw3IEBAIHJlbG9va3VwOg0K
IAkJcC0+cG10dV9leHBpcmVzID0gMDsNCiAJCXAtPnBtdHVfb3JpZyA9IDA7DQogCQltZW1zZXQo
JnAtPnJlZGlyZWN0X2xlYXJuZWQsIDAsIHNpemVvZihwLT5yZWRpcmVjdF9sZWFybmVkKSk7DQot
DQorCQlJTklUX0xJU1RfSEVBRCgmcC0+Z2NfbGlzdCk7DQogDQogCQkvKiBMaW5rIHRoZSBub2Rl
LiAqLw0KIAkJbGlua190b19wb29sKHAsIGJhc2UpOw0KQEAgLTUwOCwzICs1NTksMzggQEAgYm9v
bCBpbmV0X3BlZXJfeHJsaW1fYWxsb3coc3RydWN0IGluZXRfcGVlciAqcGVlciwgaW50IHRpbWVv
dXQpDQogCXJldHVybiByYzsNCiB9DQogRVhQT1JUX1NZTUJPTChpbmV0X3BlZXJfeHJsaW1fYWxs
b3cpOw0KKw0KK3N0YXRpYyB2b2lkIGluZXRwZWVyX2ludmFsX3JjdShzdHJ1Y3QgcmN1X2hlYWQg
KmhlYWQpDQorew0KKwlzdHJ1Y3QgaW5ldF9wZWVyICpwID0gY29udGFpbmVyX29mKGhlYWQsIHN0
cnVjdCBpbmV0X3BlZXIsIGdjX3JjdSk7DQorDQorCXNwaW5fbG9ja19iaCgmZ2NfbG9jayk7DQor
CWxpc3RfYWRkX3RhaWwoJnAtPmdjX2xpc3QsICZnY19saXN0KTsNCisJc3Bpbl91bmxvY2tfYmgo
JmdjX2xvY2spOw0KKw0KKwlzY2hlZHVsZV9kZWxheWVkX3dvcmsoJmdjX3dvcmssIGdjX2RlbGF5
KTsNCit9DQorDQordm9pZCBpbmV0cGVlcl9pbnZhbGlkYXRlX3RyZWUoaW50IGZhbWlseSkNCit7
DQorCXN0cnVjdCBpbmV0X3BlZXIgKm9sZCwgKm5ldywgKnByZXY7DQorCXN0cnVjdCBpbmV0X3Bl
ZXJfYmFzZSAqYmFzZSA9IGZhbWlseV90b19iYXNlKGZhbWlseSk7DQorDQorCXdyaXRlX3NlcWxv
Y2tfYmgoJmJhc2UtPmxvY2spOw0KKw0KKwlvbGQgPSBiYXNlLT5yb290Ow0KKwlpZiAob2xkID09
IHBlZXJfYXZsX2VtcHR5X3JjdSkNCisJCWdvdG8gb3V0Ow0KKw0KKwluZXcgPSBwZWVyX2F2bF9l
bXB0eV9yY3U7DQorDQorCXByZXYgPSBjbXB4Y2hnKCZiYXNlLT5yb290LCBvbGQsIG5ldyk7DQor
CWlmIChwcmV2ID09IG9sZCkgew0KKwkJYmFzZS0+dG90YWwgPSAwOw0KKwkJY2FsbF9yY3UoJnBy
ZXYtPmdjX3JjdSwgaW5ldHBlZXJfaW52YWxfcmN1KTsNCisJfQ0KKw0KK291dDoNCisJd3JpdGVf
c2VxdW5sb2NrX2JoKCZiYXNlLT5sb2NrKTsNCit9DQorRVhQT1JUX1NZTUJPTChpbmV0cGVlcl9p
bnZhbGlkYXRlX3RyZWUpOw0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L2lwX291dHB1dC5jIGIvbmV0
L2lwdjQvaXBfb3V0cHV0LmMNCmluZGV4IDBiYzk1ZjMuLmRhZjQwOGUgMTAwNjQ0DQotLS0gYS9u
ZXQvaXB2NC9pcF9vdXRwdXQuYw0KKysrIGIvbmV0L2lwdjQvaXBfb3V0cHV0LmMNCkBAIC0xNjIs
NyArMTYyLDcgQEAgaW50IGlwX2J1aWxkX2FuZF9zZW5kX3BrdChzdHJ1Y3Qgc2tfYnVmZiAqc2ti
LCBzdHJ1Y3Qgc29jayAqc2ssDQogCWlwaC0+ZGFkZHIgICAgPSAob3B0ICYmIG9wdC0+b3B0LnNy
ciA/IG9wdC0+b3B0LmZhZGRyIDogZGFkZHIpOw0KIAlpcGgtPnNhZGRyICAgID0gc2FkZHI7DQog
CWlwaC0+cHJvdG9jb2wgPSBzay0+c2tfcHJvdG9jb2w7DQotCWlwX3NlbGVjdF9pZGVudChpcGgs
ICZydC0+ZHN0LCBzayk7DQorCWlwX3NlbGVjdF9pZGVudChza2IsICZydC0+ZHN0LCBzayk7DQog
DQogCWlmIChvcHQgJiYgb3B0LT5vcHQub3B0bGVuKSB7DQogCQlpcGgtPmlobCArPSBvcHQtPm9w
dC5vcHRsZW4+PjI7DQpAQCAtMzkwLDcgKzM5MCw3IEBAIHBhY2tldF9yb3V0ZWQ6DQogCQlpcF9v
cHRpb25zX2J1aWxkKHNrYiwgJmluZXRfb3B0LT5vcHQsIGluZXQtPmluZXRfZGFkZHIsIHJ0LCAw
KTsNCiAJfQ0KIA0KLQlpcF9zZWxlY3RfaWRlbnRfbW9yZShpcGgsICZydC0+ZHN0LCBzaywNCisJ
aXBfc2VsZWN0X2lkZW50X21vcmUoc2tiLCAmcnQtPmRzdCwgc2ssDQogCQkJICAgICAoc2tiX3No
aW5mbyhza2IpLT5nc29fc2VncyA/OiAxKSAtIDEpOw0KIA0KIAlza2ItPnByaW9yaXR5ID0gc2st
PnNrX3ByaW9yaXR5Ow0KQEAgLTEzMzQsNyArMTMzNCw3IEBAIHN0cnVjdCBza19idWZmICpfX2lw
X21ha2Vfc2tiKHN0cnVjdCBzb2NrICpzaywNCiAJaXBoLT5paGwgPSA1Ow0KIAlpcGgtPnRvcyA9
IGluZXQtPnRvczsNCiAJaXBoLT5mcmFnX29mZiA9IGRmOw0KLQlpcF9zZWxlY3RfaWRlbnQoaXBo
LCAmcnQtPmRzdCwgc2spOw0KKwlpcF9zZWxlY3RfaWRlbnQoc2tiLCAmcnQtPmRzdCwgc2spOw0K
IAlpcGgtPnR0bCA9IHR0bDsNCiAJaXBoLT5wcm90b2NvbCA9IHNrLT5za19wcm90b2NvbDsNCiAJ
aXBoLT5zYWRkciA9IGZsNC0+c2FkZHI7DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvaXBtci5jIGIv
bmV0L2lwdjQvaXBtci5jDQppbmRleCAwMDY0Mzk0Li5iNWU2NGU0IDEwMDY0NA0KLS0tIGEvbmV0
L2lwdjQvaXBtci5jDQorKysgYi9uZXQvaXB2NC9pcG1yLmMNCkBAIC0xNTc2LDcgKzE1NzYsNyBA
QCBzdGF0aWMgdm9pZCBpcF9lbmNhcChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBfX2JlMzIgc2FkZHIs
IF9fYmUzMiBkYWRkcikNCiAJaXBoLT5wcm90b2NvbAk9CUlQUFJPVE9fSVBJUDsNCiAJaXBoLT5p
aGwJPQk1Ow0KIAlpcGgtPnRvdF9sZW4JPQlodG9ucyhza2ItPmxlbik7DQotCWlwX3NlbGVjdF9p
ZGVudChpcGgsIHNrYl9kc3Qoc2tiKSwgTlVMTCk7DQorCWlwX3NlbGVjdF9pZGVudChza2IsIHNr
Yl9kc3Qoc2tiKSwgTlVMTCk7DQogCWlwX3NlbmRfY2hlY2soaXBoKTsNCiANCiAJbWVtc2V0KCYo
SVBDQihza2IpLT5vcHQpLCAwLCBzaXplb2YoSVBDQihza2IpLT5vcHQpKTsNCmRpZmYgLS1naXQg
YS9uZXQvaXB2NC9yYXcuYyBiL25ldC9pcHY0L3Jhdy5jDQppbmRleCBlMWQ0ZjMwLi4yODE1MDE0
IDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQvcmF3LmMNCisrKyBiL25ldC9pcHY0L3Jhdy5jDQpAQCAt
MzgwLDcgKzM4MCw3IEBAIHN0YXRpYyBpbnQgcmF3X3NlbmRfaGRyaW5jKHN0cnVjdCBzb2NrICpz
aywgc3RydWN0IGZsb3dpNCAqZmw0LA0KIAkJaXBoLT5jaGVjayAgID0gMDsNCiAJCWlwaC0+dG90
X2xlbiA9IGh0b25zKGxlbmd0aCk7DQogCQlpZiAoIWlwaC0+aWQpDQotCQkJaXBfc2VsZWN0X2lk
ZW50KGlwaCwgJnJ0LT5kc3QsIE5VTEwpOw0KKwkJCWlwX3NlbGVjdF9pZGVudChza2IsICZydC0+
ZHN0LCBOVUxMKTsNCiANCiAJCWlwaC0+Y2hlY2sgPSBpcF9mYXN0X2NzdW0oKHVuc2lnbmVkIGNo
YXIgKilpcGgsIGlwaC0+aWhsKTsNCiAJfQ0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L3JvdXRlLmMg
Yi9uZXQvaXB2NC9yb3V0ZS5jDQppbmRleCA5NGNkYmM1Li5jNDVhMTU1YTMgMTAwNjQ0DQotLS0g
YS9uZXQvaXB2NC9yb3V0ZS5jDQorKysgYi9uZXQvaXB2NC9yb3V0ZS5jDQpAQCAtOTM5LDYgKzkz
OSw3IEBAIHN0YXRpYyB2b2lkIHJ0X2NhY2hlX2ludmFsaWRhdGUoc3RydWN0IG5ldCAqbmV0KQ0K
IAlnZXRfcmFuZG9tX2J5dGVzKCZzaHVmZmxlLCBzaXplb2Yoc2h1ZmZsZSkpOw0KIAlhdG9taWNf
YWRkKHNodWZmbGUgKyAxVSwgJm5ldC0+aXB2NC5ydF9nZW5pZCk7DQogCXJlZGlyZWN0X2dlbmlk
Kys7DQorCWluZXRwZWVyX2ludmFsaWRhdGVfdHJlZShBRl9JTkVUKTsNCiB9DQogDQogLyoNCmRp
ZmYgLS1naXQgYS9uZXQvaXB2NC90Y3BfY3ViaWMuYyBiL25ldC9pcHY0L3RjcF9jdWJpYy5jDQpp
bmRleCBmMzc2YjA1Li5iNzhlYWMyIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQvdGNwX2N1YmljLmMN
CisrKyBiL25ldC9pcHY0L3RjcF9jdWJpYy5jDQpAQCAtMjA0LDggKzIwNCw4IEBAIHN0YXRpYyB1
MzIgY3ViaWNfcm9vdCh1NjQgYSkNCiAgKi8NCiBzdGF0aWMgaW5saW5lIHZvaWQgYmljdGNwX3Vw
ZGF0ZShzdHJ1Y3QgYmljdGNwICpjYSwgdTMyIGN3bmQpDQogew0KLQl1NjQgb2ZmczsNCi0JdTMy
IGRlbHRhLCB0LCBiaWNfdGFyZ2V0LCBtYXhfY250Ow0KKwl1MzIgZGVsdGEsIGJpY190YXJnZXQs
IG1heF9jbnQ7DQorCXU2NCBvZmZzLCB0Ow0KIA0KIAljYS0+YWNrX2NudCsrOwkvKiBjb3VudCB0
aGUgbnVtYmVyIG9mIEFDS3MgKi8NCiANCkBAIC0yNDgsOSArMjQ4LDExIEBAIHN0YXRpYyBpbmxp
bmUgdm9pZCBiaWN0Y3BfdXBkYXRlKHN0cnVjdCBiaWN0Y3AgKmNhLCB1MzIgY3duZCkNCiAJICog
aWYgdGhlIGN3bmQgPCAxIG1pbGxpb24gcGFja2V0cyAhISENCiAJICovDQogDQorCXQgPSAoczMy
KSh0Y3BfdGltZV9zdGFtcCAtIGNhLT5lcG9jaF9zdGFydCk7DQorCXQgKz0gbXNlY3NfdG9famlm
ZmllcyhjYS0+ZGVsYXlfbWluID4+IDMpOw0KIAkvKiBjaGFuZ2UgdGhlIHVuaXQgZnJvbSBIWiB0
byBiaWN0Y3BfSFogKi8NCi0JdCA9ICgodGNwX3RpbWVfc3RhbXAgKyBtc2Vjc190b19qaWZmaWVz
KGNhLT5kZWxheV9taW4+PjMpDQotCSAgICAgIC0gY2EtPmVwb2NoX3N0YXJ0KSA8PCBCSUNUQ1Bf
SFopIC8gSFo7DQorCXQgPDw9IEJJQ1RDUF9IWjsNCisJZG9fZGl2KHQsIEhaKTsNCiANCiAJaWYg
KHQgPCBjYS0+YmljX0spCQkvKiB0IC0gSyAqLw0KIAkJb2ZmcyA9IGNhLT5iaWNfSyAtIHQ7DQpA
QCAtNDEyLDcgKzQxNCw3IEBAIHN0YXRpYyB2b2lkIGJpY3RjcF9hY2tlZChzdHJ1Y3Qgc29jayAq
c2ssIHUzMiBjbnQsIHMzMiBydHRfdXMpDQogCQlyZXR1cm47DQogDQogCS8qIERpc2NhcmQgZGVs
YXkgc2FtcGxlcyByaWdodCBhZnRlciBmYXN0IHJlY292ZXJ5ICovDQotCWlmICgoczMyKSh0Y3Bf
dGltZV9zdGFtcCAtIGNhLT5lcG9jaF9zdGFydCkgPCBIWikNCisJaWYgKGNhLT5lcG9jaF9zdGFy
dCAmJiAoczMyKSh0Y3BfdGltZV9zdGFtcCAtIGNhLT5lcG9jaF9zdGFydCkgPCBIWikNCiAJCXJl
dHVybjsNCiANCiAJZGVsYXkgPSAocnR0X3VzIDw8IDMpIC8gVVNFQ19QRVJfTVNFQzsNCmRpZmYg
LS1naXQgYS9uZXQvaXB2NC94ZnJtNF9tb2RlX3R1bm5lbC5jIGIvbmV0L2lwdjQveGZybTRfbW9k
ZV90dW5uZWwuYw0KaW5kZXggZWQ0YmYxMS4uOTM4NTUzZSAxMDA2NDQNCi0tLSBhL25ldC9pcHY0
L3hmcm00X21vZGVfdHVubmVsLmMNCisrKyBiL25ldC9pcHY0L3hmcm00X21vZGVfdHVubmVsLmMN
CkBAIC01NCw3ICs1NCw3IEBAIHN0YXRpYyBpbnQgeGZybTRfbW9kZV90dW5uZWxfb3V0cHV0KHN0
cnVjdCB4ZnJtX3N0YXRlICp4LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KIA0KIAl0b3BfaXBoLT5m
cmFnX29mZiA9IChmbGFncyAmIFhGUk1fU1RBVEVfTk9QTVRVRElTQykgPw0KIAkJMCA6IChYRlJN
X01PREVfU0tCX0NCKHNrYiktPmZyYWdfb2ZmICYgaHRvbnMoSVBfREYpKTsNCi0JaXBfc2VsZWN0
X2lkZW50KHRvcF9pcGgsIGRzdC0+Y2hpbGQsIE5VTEwpOw0KKwlpcF9zZWxlY3RfaWRlbnQoc2ti
LCBkc3QtPmNoaWxkLCBOVUxMKTsNCiANCiAJdG9wX2lwaC0+dHRsID0gaXA0X2RzdF9ob3BsaW1p
dChkc3QtPmNoaWxkKTsNCiANCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9hZGRyY29uZi5jIGIvbmV0
L2lwdjYvYWRkcmNvbmYuYw0KaW5kZXggMzE0YmRhMi4uNWQ0MTI5MyAxMDA2NDQNCi0tLSBhL25l
dC9pcHY2L2FkZHJjb25mLmMNCisrKyBiL25ldC9pcHY2L2FkZHJjb25mLmMNCkBAIC05MTMsMTIg
KzkxMywxMCBAQCByZXRyeToNCiAJaWYgKGlmcC0+ZmxhZ3MgJiBJRkFfRl9PUFRJTUlTVElDKQ0K
IAkJYWRkcl9mbGFncyB8PSBJRkFfRl9PUFRJTUlTVElDOw0KIA0KLQlpZnQgPSAhbWF4X2FkZHJl
c3NlcyB8fA0KLQkgICAgICBpcHY2X2NvdW50X2FkZHJlc3NlcyhpZGV2KSA8IG1heF9hZGRyZXNz
ZXMgPw0KLQkJaXB2Nl9hZGRfYWRkcihpZGV2LCAmYWRkciwgdG1wX3BsZW4sDQotCQkJICAgICAg
aXB2Nl9hZGRyX3R5cGUoJmFkZHIpJklQVjZfQUREUl9TQ09QRV9NQVNLLA0KLQkJCSAgICAgIGFk
ZHJfZmxhZ3MpIDogTlVMTDsNCi0JaWYgKCFpZnQgfHwgSVNfRVJSKGlmdCkpIHsNCisJaWZ0ID0g
aXB2Nl9hZGRfYWRkcihpZGV2LCAmYWRkciwgdG1wX3BsZW4sDQorCQkJICAgIGlwdjZfYWRkcl90
eXBlKCZhZGRyKSZJUFY2X0FERFJfU0NPUEVfTUFTSywNCisJCQkgICAgYWRkcl9mbGFncyk7DQor
CWlmIChJU19FUlIoaWZ0KSkgew0KIAkJaW42X2lmYV9wdXQoaWZwKTsNCiAJCWluNl9kZXZfcHV0
KGlkZXYpOw0KIAkJcHJpbnRrKEtFUk5fSU5GTw0KZGlmZiAtLWdpdCBhL25ldC9pcHY2L2ljbXAu
YyBiL25ldC9pcHY2L2ljbXAuYw0KaW5kZXggOTA4NjhmYi4uZDUwNTQ1MyAxMDA2NDQNCi0tLSBh
L25ldC9pcHY2L2ljbXAuYw0KKysrIGIvbmV0L2lwdjYvaWNtcC5jDQpAQCAtOTExLDYgKzkxMSwx
NCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGljbXA2X2VyciB7DQogCQkuZXJyCT0gRUNPTk5SRUZV
U0VELA0KIAkJLmZhdGFsCT0gMSwNCiAJfSwNCisJewkvKiBQT0xJQ1lfRkFJTCAqLw0KKwkJLmVy
cgk9IEVBQ0NFUywNCisJCS5mYXRhbAk9IDEsDQorCX0sDQorCXsJLyogUkVKRUNUX1JPVVRFCSov
DQorCQkuZXJyCT0gRUFDQ0VTLA0KKwkJLmZhdGFsCT0gMSwNCisJfSwNCiB9Ow0KIA0KIGludCBp
Y21wdjZfZXJyX2NvbnZlcnQodTggdHlwZSwgdTggY29kZSwgaW50ICplcnIpDQpAQCAtOTIyLDcg
KzkzMCw3IEBAIGludCBpY21wdjZfZXJyX2NvbnZlcnQodTggdHlwZSwgdTggY29kZSwgaW50ICpl
cnIpDQogCXN3aXRjaCAodHlwZSkgew0KIAljYXNlIElDTVBWNl9ERVNUX1VOUkVBQ0g6DQogCQlm
YXRhbCA9IDE7DQotCQlpZiAoY29kZSA8PSBJQ01QVjZfUE9SVF9VTlJFQUNIKSB7DQorCQlpZiAo
Y29kZSA8IEFSUkFZX1NJWkUodGFiX3VucmVhY2gpKSB7DQogCQkJKmVyciAgPSB0YWJfdW5yZWFj
aFtjb2RlXS5lcnI7DQogCQkJZmF0YWwgPSB0YWJfdW5yZWFjaFtjb2RlXS5mYXRhbDsNCiAJCX0N
CmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9pcDZfZmliLmMgYi9uZXQvaXB2Ni9pcDZfZmliLmMNCmlu
ZGV4IDkzNzE4ZjMuLjQ0MzcyNGYgMTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni9pcDZfZmliLmMNCisr
KyBiL25ldC9pcHY2L2lwNl9maWIuYw0KQEAgLTg2MiwxNCArODYyLDIyIEBAIHN0YXRpYyBzdHJ1
Y3QgZmliNl9ub2RlICogZmliNl9sb29rdXBfMShzdHJ1Y3QgZmliNl9ub2RlICpyb290LA0KIA0K
IAkJCWlmIChpcHY2X3ByZWZpeF9lcXVhbCgma2V5LT5hZGRyLCBhcmdzLT5hZGRyLCBrZXktPnBs
ZW4pKSB7DQogI2lmZGVmIENPTkZJR19JUFY2X1NVQlRSRUVTDQotCQkJCWlmIChmbi0+c3VidHJl
ZSkNCi0JCQkJCWZuID0gZmliNl9sb29rdXBfMShmbi0+c3VidHJlZSwgYXJncyArIDEpOw0KKwkJ
CQlpZiAoZm4tPnN1YnRyZWUpIHsNCisJCQkJCXN0cnVjdCBmaWI2X25vZGUgKnNmbjsNCisJCQkJ
CXNmbiA9IGZpYjZfbG9va3VwXzEoZm4tPnN1YnRyZWUsDQorCQkJCQkJCSAgICBhcmdzICsgMSk7
DQorCQkJCQlpZiAoIXNmbikNCisJCQkJCQlnb3RvIGJhY2t0cmFjazsNCisJCQkJCWZuID0gc2Zu
Ow0KKwkJCQl9DQogI2VuZGlmDQotCQkJCWlmICghZm4gfHwgZm4tPmZuX2ZsYWdzICYgUlROX1JU
SU5GTykNCisJCQkJaWYgKGZuLT5mbl9mbGFncyAmIFJUTl9SVElORk8pDQogCQkJCQlyZXR1cm4g
Zm47DQogCQkJfQ0KIAkJfQ0KLQ0KKyNpZmRlZiBDT05GSUdfSVBWNl9TVUJUUkVFUw0KK2JhY2t0
cmFjazoNCisjZW5kaWYNCiAJCWlmIChmbi0+Zm5fZmxhZ3MgJiBSVE5fUk9PVCkNCiAJCQlicmVh
azsNCiANCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9pcDZfb3V0cHV0LmMgYi9uZXQvaXB2Ni9pcDZf
b3V0cHV0LmMNCmluZGV4IGRiNjAwNDMuLjkxZDA3MTEgMTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni9p
cDZfb3V0cHV0LmMNCisrKyBiL25ldC9pcHY2L2lwNl9vdXRwdXQuYw0KQEAgLTExMjUsNiArMTEy
NSw4IEBAIHN0YXRpYyBpbmxpbmUgaW50IGlwNl91Zm9fYXBwZW5kX2RhdGEoc3RydWN0IHNvY2sg
KnNrLA0KIAkgKiB1ZHAgZGF0YWdyYW0NCiAJICovDQogCWlmICgoc2tiID0gc2tiX3BlZWtfdGFp
bCgmc2stPnNrX3dyaXRlX3F1ZXVlKSkgPT0gTlVMTCkgew0KKwkJc3RydWN0IGZyYWdfaGRyIGZo
ZHI7DQorDQogCQlza2IgPSBzb2NrX2FsbG9jX3NlbmRfc2tiKHNrLA0KIAkJCWhoX2xlbiArIGZy
YWdoZWFkZXJsZW4gKyB0cmFuc2hkcmxlbiArIDIwLA0KIAkJCShmbGFncyAmIE1TR19ET05UV0FJ
VCksICZlcnIpOw0KQEAgLTExNDUsMTIgKzExNDcsNiBAQCBzdGF0aWMgaW5saW5lIGludCBpcDZf
dWZvX2FwcGVuZF9kYXRhKHN0cnVjdCBzb2NrICpzaywNCiANCiAJCXNrYi0+aXBfc3VtbWVkID0g
Q0hFQ0tTVU1fUEFSVElBTDsNCiAJCXNrYi0+Y3N1bSA9IDA7DQotCX0NCi0NCi0JZXJyID0gc2ti
X2FwcGVuZF9kYXRhdG9fZnJhZ3Moc2ssc2tiLCBnZXRmcmFnLCBmcm9tLA0KLQkJCQkgICAgICAo
bGVuZ3RoIC0gdHJhbnNoZHJsZW4pKTsNCi0JaWYgKCFlcnIpIHsNCi0JCXN0cnVjdCBmcmFnX2hk
ciBmaGRyOw0KIA0KIAkJLyogU3BlY2lmeSB0aGUgbGVuZ3RoIG9mIGVhY2ggSVB2NiBkYXRhZ3Jh
bSBmcmFnbWVudC4NCiAJCSAqIEl0IGhhcyB0byBiZSBhIG11bHRpcGxlIG9mIDguDQpAQCAtMTE2
MSwxNSArMTE1NywxMCBAQCBzdGF0aWMgaW5saW5lIGludCBpcDZfdWZvX2FwcGVuZF9kYXRhKHN0
cnVjdCBzb2NrICpzaywNCiAJCWlwdjZfc2VsZWN0X2lkZW50KCZmaGRyLCBydCk7DQogCQlza2Jf
c2hpbmZvKHNrYiktPmlwNl9mcmFnX2lkID0gZmhkci5pZGVudGlmaWNhdGlvbjsNCiAJCV9fc2ti
X3F1ZXVlX3RhaWwoJnNrLT5za193cml0ZV9xdWV1ZSwgc2tiKTsNCi0NCi0JCXJldHVybiAwOw0K
IAl9DQotCS8qIFRoZXJlIGlzIG5vdCBlbm91Z2ggc3VwcG9ydCBkbyBVUEQgTFNPLA0KLQkgKiBz
byBmb2xsb3cgbm9ybWFsIHBhdGgNCi0JICovDQotCWtmcmVlX3NrYihza2IpOw0KIA0KLQlyZXR1
cm4gZXJyOw0KKwlyZXR1cm4gc2tiX2FwcGVuZF9kYXRhdG9fZnJhZ3Moc2ssIHNrYiwgZ2V0ZnJh
ZywgZnJvbSwNCisJCQkJICAgICAgIChsZW5ndGggLSB0cmFuc2hkcmxlbikpOw0KIH0NCiANCiBz
dGF0aWMgaW5saW5lIHN0cnVjdCBpcHY2X29wdF9oZHIgKmlwNl9vcHRfZHVwKHN0cnVjdCBpcHY2
X29wdF9oZHIgKnNyYywNCkBAIC0xMzQyLDI3ICsxMzMzLDI3IEBAIGludCBpcDZfYXBwZW5kX2Rh
dGEoc3RydWN0IHNvY2sgKnNrLCBpbnQgZ2V0ZnJhZyh2b2lkICpmcm9tLCBjaGFyICp0bywNCiAJ
ICogLS15b3NoZnVqaQ0KIAkgKi8NCiANCi0JY29yay0+bGVuZ3RoICs9IGxlbmd0aDsNCi0JaWYg
KGxlbmd0aCA+IG10dSkgew0KLQkJaW50IHByb3RvID0gc2stPnNrX3Byb3RvY29sOw0KLQkJaWYg
KGRvbnRmcmFnICYmIChwcm90byA9PSBJUFBST1RPX1VEUCB8fCBwcm90byA9PSBJUFBST1RPX1JB
Vykpew0KLQkJCWlwdjZfbG9jYWxfcnhwbXR1KHNrLCBmbDYsIG10dS1leHRoZHJsZW4pOw0KLQkJ
CXJldHVybiAtRU1TR1NJWkU7DQotCQl9DQotDQotCQlpZiAocHJvdG8gPT0gSVBQUk9UT19VRFAg
JiYNCi0JCSAgICAocnQtPmRzdC5kZXYtPmZlYXR1cmVzICYgTkVUSUZfRl9VRk8pKSB7DQorCWlm
ICgobGVuZ3RoID4gbXR1KSAmJiBkb250ZnJhZyAmJiAoc2stPnNrX3Byb3RvY29sID09IElQUFJP
VE9fVURQIHx8DQorCQkJCQkgICBzay0+c2tfcHJvdG9jb2wgPT0gSVBQUk9UT19SQVcpKSB7DQor
CQlpcHY2X2xvY2FsX3J4cG10dShzaywgZmw2LCBtdHUtZXh0aGRybGVuKTsNCisJCXJldHVybiAt
RU1TR1NJWkU7DQorCX0NCiANCi0JCQllcnIgPSBpcDZfdWZvX2FwcGVuZF9kYXRhKHNrLCBnZXRm
cmFnLCBmcm9tLCBsZW5ndGgsDQotCQkJCQkJICBoaF9sZW4sIGZyYWdoZWFkZXJsZW4sDQotCQkJ
CQkJICB0cmFuc2hkcmxlbiwgbXR1LCBmbGFncywgcnQpOw0KLQkJCWlmIChlcnIpDQotCQkJCWdv
dG8gZXJyb3I7DQotCQkJcmV0dXJuIDA7DQotCQl9DQorCXNrYiA9IHNrYl9wZWVrX3RhaWwoJnNr
LT5za193cml0ZV9xdWV1ZSk7DQorCWNvcmstPmxlbmd0aCArPSBsZW5ndGg7DQorCWlmICgoKGxl
bmd0aCA+IG10dSkgfHwNCisJICAgICAoc2tiICYmIHNrYl9pc19nc28oc2tiKSkpICYmDQorCSAg
ICAoc2stPnNrX3Byb3RvY29sID09IElQUFJPVE9fVURQKSAmJg0KKwkgICAgKHJ0LT5kc3QuZGV2
LT5mZWF0dXJlcyAmIE5FVElGX0ZfVUZPKSkgew0KKwkJZXJyID0gaXA2X3Vmb19hcHBlbmRfZGF0
YShzaywgZ2V0ZnJhZywgZnJvbSwgbGVuZ3RoLA0KKwkJCQkJICBoaF9sZW4sIGZyYWdoZWFkZXJs
ZW4sDQorCQkJCQkgIHRyYW5zaGRybGVuLCBtdHUsIGZsYWdzLCBydCk7DQorCQlpZiAoZXJyKQ0K
KwkJCWdvdG8gZXJyb3I7DQorCQlyZXR1cm4gMDsNCiAJfQ0KIA0KLQlpZiAoKHNrYiA9IHNrYl9w
ZWVrX3RhaWwoJnNrLT5za193cml0ZV9xdWV1ZSkpID09IE5VTEwpDQorCWlmICghc2tiKQ0KIAkJ
Z290byBhbGxvY19uZXdfc2tiOw0KIA0KIAl3aGlsZSAobGVuZ3RoID4gMCkgew0KZGlmZiAtLWdp
dCBhL25ldC9pcHY2L21jYXN0LmMgYi9uZXQvaXB2Ni9tY2FzdC5jDQppbmRleCBjN2VjNGJiLi5k
MjBhOWJlIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjYvbWNhc3QuYw0KKysrIGIvbmV0L2lwdjYvbWNh
c3QuYw0KQEAgLTIxNTksNyArMjE1OSw3IEBAIHN0YXRpYyB2b2lkIG1sZF9ncV90aW1lcl9leHBp
cmUodW5zaWduZWQgbG9uZyBkYXRhKQ0KIA0KIAlpZGV2LT5tY19ncV9ydW5uaW5nID0gMDsNCiAJ
bWxkX3NlbmRfcmVwb3J0KGlkZXYsIE5VTEwpOw0KLQlfX2luNl9kZXZfcHV0KGlkZXYpOw0KKwlp
bjZfZGV2X3B1dChpZGV2KTsNCiB9DQogDQogc3RhdGljIHZvaWQgbWxkX2lmY190aW1lcl9leHBp
cmUodW5zaWduZWQgbG9uZyBkYXRhKQ0KQEAgLTIxNzIsNyArMjE3Miw3IEBAIHN0YXRpYyB2b2lk
IG1sZF9pZmNfdGltZXJfZXhwaXJlKHVuc2lnbmVkIGxvbmcgZGF0YSkNCiAJCWlmIChpZGV2LT5t
Y19pZmNfY291bnQpDQogCQkJbWxkX2lmY19zdGFydF90aW1lcihpZGV2LCBpZGV2LT5tY19tYXhk
ZWxheSk7DQogCX0NCi0JX19pbjZfZGV2X3B1dChpZGV2KTsNCisJaW42X2Rldl9wdXQoaWRldik7
DQogfQ0KIA0KIHN0YXRpYyB2b2lkIG1sZF9pZmNfZXZlbnQoc3RydWN0IGluZXQ2X2RldiAqaWRl
dikNCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9uZGlzYy5jIGIvbmV0L2lwdjYvbmRpc2MuYw0KaW5k
ZXggOWZmYzM3Zi4uYmM1NTM1OCAxMDA2NDQNCi0tLSBhL25ldC9pcHY2L25kaXNjLmMNCisrKyBi
L25ldC9pcHY2L25kaXNjLmMNCkBAIC00NDcsNyArNDQ3LDYgQEAgc3RydWN0IHNrX2J1ZmYgKm5k
aXNjX2J1aWxkX3NrYihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KIAlzdHJ1Y3Qgc2tfYnVmZiAq
c2tiOw0KIAlzdHJ1Y3QgaWNtcDZoZHIgKmhkcjsNCiAJaW50IGxlbjsNCi0JaW50IGVycjsNCiAJ
dTggKm9wdDsNCiANCiAJaWYgKCFkZXYtPmFkZHJfbGVuKQ0KQEAgLTQ1NywxNCArNDU2LDEyIEBA
IHN0cnVjdCBza19idWZmICpuZGlzY19idWlsZF9za2Ioc3RydWN0IG5ldF9kZXZpY2UgKmRldiwN
CiAJaWYgKGxsaW5mbykNCiAJCWxlbiArPSBuZGlzY19vcHRfYWRkcl9zcGFjZShkZXYpOw0KIA0K
LQlza2IgPSBzb2NrX2FsbG9jX3NlbmRfc2tiKHNrLA0KLQkJCQkgIChNQVhfSEVBREVSICsgc2l6
ZW9mKHN0cnVjdCBpcHY2aGRyKSArDQotCQkJCSAgIGxlbiArIExMX0FMTE9DQVRFRF9TUEFDRShk
ZXYpKSwNCi0JCQkJICAxLCAmZXJyKTsNCisJc2tiID0gYWxsb2Nfc2tiKChNQVhfSEVBREVSICsg
c2l6ZW9mKHN0cnVjdCBpcHY2aGRyKSArDQorCQkJIGxlbiArIExMX0FMTE9DQVRFRF9TUEFDRShk
ZXYpKSwgR0ZQX0FUT01JQyk7DQogCWlmICghc2tiKSB7DQogCQlORF9QUklOVEswKEtFUk5fRVJS
DQotCQkJICAgIklDTVB2NiBORDogJXMoKSBmYWlsZWQgdG8gYWxsb2NhdGUgYW4gc2tiLCBlcnI9
JWQuXG4iLA0KLQkJCSAgIF9fZnVuY19fLCBlcnIpOw0KKwkJCSAgICJJQ01QdjYgTkQ6ICVzKCkg
ZmFpbGVkIHRvIGFsbG9jYXRlIGFuIHNrYi5cbiIsDQorCQkJICAgX19mdW5jX18pOw0KIAkJcmV0
dXJuIE5VTEw7DQogCX0NCiANCkBAIC00OTIsNiArNDg5LDExIEBAIHN0cnVjdCBza19idWZmICpu
ZGlzY19idWlsZF9za2Ioc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCiAJCQkJCSAgIGNzdW1fcGFy
dGlhbChoZHIsDQogCQkJCQkJCWxlbiwgMCkpOw0KIA0KKwkvKiBNYW51YWxseSBhc3NpZ24gc29j
a2V0IG93bmVyc2hpcCBhcyB3ZSBhdm9pZCBjYWxsaW5nDQorCSAqIHNvY2tfYWxsb2Nfc2VuZF9w
c2tiKCkgdG8gYnlwYXNzIHdtZW0gYnVmZmVyIGxpbWl0cw0KKwkgKi8NCisJc2tiX3NldF9vd25l
cl93KHNrYiwgc2spOw0KKw0KIAlyZXR1cm4gc2tiOw0KIH0NCiANCmRpZmYgLS1naXQgYS9uZXQv
aXB2Ni9yZWFzc2VtYmx5LmMgYi9uZXQvaXB2Ni9yZWFzc2VtYmx5LmMNCmluZGV4IDQxMWZlMmMu
LmViYTVkZWIgMTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni9yZWFzc2VtYmx5LmMNCisrKyBiL25ldC9p
cHY2L3JlYXNzZW1ibHkuYw0KQEAgLTUxNyw2ICs1MTcsNyBAQCBzdGF0aWMgaW50IGlwNl9mcmFn
X3JlYXNtKHN0cnVjdCBmcmFnX3F1ZXVlICpmcSwgc3RydWN0IHNrX2J1ZmYgKnByZXYsDQogCWhl
YWQtPnRzdGFtcCA9IGZxLT5xLnN0YW1wOw0KIAlpcHY2X2hkcihoZWFkKS0+cGF5bG9hZF9sZW4g
PSBodG9ucyhwYXlsb2FkX2xlbik7DQogCUlQNkNCKGhlYWQpLT5uaG9mZiA9IG5ob2ZmOw0KKwlJ
UDZDQihoZWFkKS0+ZmxhZ3MgfD0gSVA2U0tCX0ZSQUdNRU5URUQ7DQogDQogCS8qIFllcywgYW5k
IGZvbGQgcmVkdW5kYW50IGNoZWNrc3VtIGJhY2suIDgpICovDQogCWlmIChoZWFkLT5pcF9zdW1t
ZWQgPT0gQ0hFQ0tTVU1fQ09NUExFVEUpDQpAQCAtNTUyLDYgKzU1Myw5IEBAIHN0YXRpYyBpbnQg
aXB2Nl9mcmFnX3JjdihzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KIAljb25zdCBzdHJ1Y3QgaXB2Nmhk
ciAqaGRyID0gaXB2Nl9oZHIoc2tiKTsNCiAJc3RydWN0IG5ldCAqbmV0ID0gZGV2X25ldChza2Jf
ZHN0KHNrYiktPmRldik7DQogDQorCWlmIChJUDZDQihza2IpLT5mbGFncyAmIElQNlNLQl9GUkFH
TUVOVEVEKQ0KKwkJZ290byBmYWlsX2hkcjsNCisNCiAJSVA2X0lOQ19TVEFUU19CSChuZXQsIGlw
Nl9kc3RfaWRldihza2JfZHN0KHNrYikpLCBJUFNUQVRTX01JQl9SRUFTTVJFUURTKTsNCiANCiAJ
LyogSnVtYm8gcGF5bG9hZCBpbmhpYml0cyBmcmFnLiBoZWFkZXIgKi8NCkBAIC01NzIsNiArNTc2
LDcgQEAgc3RhdGljIGludCBpcHY2X2ZyYWdfcmN2KHN0cnVjdCBza19idWZmICpza2IpDQogCQkJ
CSBpcDZfZHN0X2lkZXYoc2tiX2RzdChza2IpKSwgSVBTVEFUU19NSUJfUkVBU01PS1MpOw0KIA0K
IAkJSVA2Q0Ioc2tiKS0+bmhvZmYgPSAodTggKilmaGRyIC0gc2tiX25ldHdvcmtfaGVhZGVyKHNr
Yik7DQorCQlJUDZDQihza2IpLT5mbGFncyB8PSBJUDZTS0JfRlJBR01FTlRFRDsNCiAJCXJldHVy
biAxOw0KIAl9DQogDQpkaWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9pcHZzL2lwX3ZzX3htaXQu
YyBiL25ldC9uZXRmaWx0ZXIvaXB2cy9pcF92c194bWl0LmMNCmluZGV4IGFhMmQ3MjAuLjM4YzA4
MTMgMTAwNjQ0DQotLS0gYS9uZXQvbmV0ZmlsdGVyL2lwdnMvaXBfdnNfeG1pdC5jDQorKysgYi9u
ZXQvbmV0ZmlsdGVyL2lwdnMvaXBfdnNfeG1pdC5jDQpAQCAtODUzLDcgKzg1Myw3IEBAIGlwX3Zz
X3R1bm5lbF94bWl0KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBpcF92c19jb25uICpjcCwN
CiAJaXBoLT5kYWRkcgkJPQljcC0+ZGFkZHIuaXA7DQogCWlwaC0+c2FkZHIJCT0Jc2FkZHI7DQog
CWlwaC0+dHRsCQk9CW9sZF9pcGgtPnR0bDsNCi0JaXBfc2VsZWN0X2lkZW50KGlwaCwgJnJ0LT5k
c3QsIE5VTEwpOw0KKwlpcF9zZWxlY3RfaWRlbnQoc2tiLCAmcnQtPmRzdCwgTlVMTCk7DQogDQog
CS8qIEFub3RoZXIgaGFjazogYXZvaWQgaWNtcF9zZW5kIGluIGlwX2ZyYWdtZW50ICovDQogCXNr
Yi0+bG9jYWxfZGYgPSAxOw0KZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9zY2hfaHRiLmMgYi9uZXQv
c2NoZWQvc2NoX2h0Yi5jDQppbmRleCBmMDhiOTE2Ni4uY2FhNWFmZiAxMDA2NDQNCi0tLSBhL25l
dC9zY2hlZC9zY2hfaHRiLmMNCisrKyBiL25ldC9zY2hlZC9zY2hfaHRiLmMNCkBAIC04Niw3ICs4
Niw3IEBAIHN0cnVjdCBodGJfY2xhc3Mgew0KIAl1bnNpZ25lZCBpbnQgY2hpbGRyZW47DQogCXN0
cnVjdCBodGJfY2xhc3MgKnBhcmVudDsJLyogcGFyZW50IGNsYXNzICovDQogDQotCWludCBwcmlv
OwkJLyogdGhlc2UgdHdvIGFyZSB1c2VkIG9ubHkgYnkgbGVhdmVzLi4uICovDQorCXUzMiBwcmlv
OwkJLyogdGhlc2UgdHdvIGFyZSB1c2VkIG9ubHkgYnkgbGVhdmVzLi4uICovDQogCWludCBxdWFu
dHVtOwkJLyogYnV0IHN0b3JlZCBmb3IgcGFyZW50LXRvLWxlYWYgcmV0dXJuICovDQogDQogCXVu
aW9uIHsNCmRpZmYgLS1naXQgYS9uZXQvc2N0cC9pcHY2LmMgYi9uZXQvc2N0cC9pcHY2LmMNCmlu
ZGV4IDgxMDQyNzguLjBiNmEzOTEgMTAwNjQ0DQotLS0gYS9uZXQvc2N0cC9pcHY2LmMNCisrKyBi
L25ldC9zY3RwL2lwdjYuYw0KQEAgLTIwNSw0NSArMjA1LDI0IEBAIG91dDoNCiAJCWluNl9kZXZf
cHV0KGlkZXYpOw0KIH0NCiANCi0vKiBCYXNlZCBvbiB0Y3BfdjZfeG1pdCgpIGluIHRjcF9pcHY2
LmMuICovDQogc3RhdGljIGludCBzY3RwX3Y2X3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3Ry
dWN0IHNjdHBfdHJhbnNwb3J0ICp0cmFuc3BvcnQpDQogew0KIAlzdHJ1Y3Qgc29jayAqc2sgPSBz
a2ItPnNrOw0KIAlzdHJ1Y3QgaXB2Nl9waW5mbyAqbnAgPSBpbmV0Nl9zayhzayk7DQotCXN0cnVj
dCBmbG93aTYgZmw2Ow0KLQ0KLQltZW1zZXQoJmZsNiwgMCwgc2l6ZW9mKGZsNikpOw0KLQ0KLQlm
bDYuZmxvd2k2X3Byb3RvID0gc2stPnNrX3Byb3RvY29sOw0KLQ0KLQkvKiBGaWxsIGluIHRoZSBk
ZXN0IGFkZHJlc3MgZnJvbSB0aGUgcm91dGUgZW50cnkgcGFzc2VkIHdpdGggdGhlIHNrYg0KLQkg
KiBhbmQgdGhlIHNvdXJjZSBhZGRyZXNzIGZyb20gdGhlIHRyYW5zcG9ydC4NCi0JICovDQotCWlw
djZfYWRkcl9jb3B5KCZmbDYuZGFkZHIsICZ0cmFuc3BvcnQtPmlwYWRkci52Ni5zaW42X2FkZHIp
Ow0KLQlpcHY2X2FkZHJfY29weSgmZmw2LnNhZGRyLCAmdHJhbnNwb3J0LT5zYWRkci52Ni5zaW42
X2FkZHIpOw0KLQ0KLQlmbDYuZmxvd2xhYmVsID0gbnAtPmZsb3dfbGFiZWw7DQotCUlQNl9FQ05f
Zmxvd194bWl0KHNrLCBmbDYuZmxvd2xhYmVsKTsNCi0JaWYgKGlwdjZfYWRkcl90eXBlKCZmbDYu
c2FkZHIpICYgSVBWNl9BRERSX0xJTktMT0NBTCkNCi0JCWZsNi5mbG93aTZfb2lmID0gdHJhbnNw
b3J0LT5zYWRkci52Ni5zaW42X3Njb3BlX2lkOw0KLQllbHNlDQotCQlmbDYuZmxvd2k2X29pZiA9
IHNrLT5za19ib3VuZF9kZXZfaWY7DQotDQotCWlmIChucC0+b3B0ICYmIG5wLT5vcHQtPnNyY3J0
KSB7DQotCQlzdHJ1Y3QgcnQwX2hkciAqcnQwID0gKHN0cnVjdCBydDBfaGRyICopIG5wLT5vcHQt
PnNyY3J0Ow0KLQkJaXB2Nl9hZGRyX2NvcHkoJmZsNi5kYWRkciwgcnQwLT5hZGRyKTsNCi0JfQ0K
KwlzdHJ1Y3QgZmxvd2k2ICpmbDYgPSAmdHJhbnNwb3J0LT5mbC51LmlwNjsNCiANCiAJU0NUUF9E
RUJVR19QUklOVEsoIiVzOiBza2I6JXAsIGxlbjolZCwgc3JjOiVwSTYgZHN0OiVwSTZcbiIsDQog
CQkJICBfX2Z1bmNfXywgc2tiLCBza2ItPmxlbiwNCi0JCQkgICZmbDYuc2FkZHIsICZmbDYuZGFk
ZHIpOw0KKwkJCSAgJmZsNi0+c2FkZHIsICZmbDYtPmRhZGRyKTsNCiANCi0JU0NUUF9JTkNfU1RB
VFMoU0NUUF9NSUJfT1VUU0NUUFBBQ0tTKTsNCisJSVA2X0VDTl9mbG93X3htaXQoc2ssIGZsNi0+
Zmxvd2xhYmVsKTsNCiANCiAJaWYgKCEodHJhbnNwb3J0LT5wYXJhbV9mbGFncyAmIFNQUF9QTVRV
RF9FTkFCTEUpKQ0KIAkJc2tiLT5sb2NhbF9kZiA9IDE7DQogDQotCXJldHVybiBpcDZfeG1pdChz
aywgc2tiLCAmZmw2LCBucC0+b3B0LCBucC0+dGNsYXNzKTsNCisJU0NUUF9JTkNfU1RBVFMoU0NU
UF9NSUJfT1VUU0NUUFBBQ0tTKTsNCisNCisJcmV0dXJuIGlwNl94bWl0KHNrLCBza2IsIGZsNiwg
bnAtPm9wdCwgbnAtPnRjbGFzcyk7DQogfQ0KIA0KIC8qIFJldHVybnMgdGhlIGRzdCBjYWNoZSBl
bnRyeSBmb3IgdGhlIGdpdmVuIHNvdXJjZSBhbmQgZGVzdGluYXRpb24gaXANCkBAIC0yNTYsMTAg
KzIzNSwxMiBAQCBzdGF0aWMgdm9pZCBzY3RwX3Y2X2dldF9kc3Qoc3RydWN0IHNjdHBfdHJhbnNw
b3J0ICp0LCB1bmlvbiBzY3RwX2FkZHIgKnNhZGRyLA0KIAlzdHJ1Y3QgZHN0X2VudHJ5ICpkc3Qg
PSBOVUxMOw0KIAlzdHJ1Y3QgZmxvd2k2ICpmbDYgPSAmZmwtPnUuaXA2Ow0KIAlzdHJ1Y3Qgc2N0
cF9iaW5kX2FkZHIgKmJwOw0KKwlzdHJ1Y3QgaXB2Nl9waW5mbyAqbnAgPSBpbmV0Nl9zayhzayk7
DQogCXN0cnVjdCBzY3RwX3NvY2thZGRyX2VudHJ5ICpsYWRkcjsNCiAJdW5pb24gc2N0cF9hZGRy
ICpiYWRkciA9IE5VTEw7DQogCXVuaW9uIHNjdHBfYWRkciAqZGFkZHIgPSAmdC0+aXBhZGRyOw0K
IAl1bmlvbiBzY3RwX2FkZHIgZHN0X3NhZGRyOw0KKwlzdHJ1Y3QgaW42X2FkZHIgKmZpbmFsX3As
IGZpbmFsOw0KIAlfX3U4IG1hdGNobGVuID0gMDsNCiAJX191OCBibWF0Y2hsZW47DQogCXNjdHBf
c2NvcGVfdCBzY29wZTsNCkBAIC0yODIsNyArMjYzLDggQEAgc3RhdGljIHZvaWQgc2N0cF92Nl9n
ZXRfZHN0KHN0cnVjdCBzY3RwX3RyYW5zcG9ydCAqdCwgdW5pb24gc2N0cF9hZGRyICpzYWRkciwN
CiAJCVNDVFBfREVCVUdfUFJJTlRLKCJTUkM9JXBJNiAtICIsICZmbDYtPnNhZGRyKTsNCiAJfQ0K
IA0KLQlkc3QgPSBpcDZfZHN0X2xvb2t1cF9mbG93KHNrLCBmbDYsIE5VTEwsIGZhbHNlKTsNCisJ
ZmluYWxfcCA9IGZsNl91cGRhdGVfZHN0KGZsNiwgbnAtPm9wdCwgJmZpbmFsKTsNCisJZHN0ID0g
aXA2X2RzdF9sb29rdXBfZmxvdyhzaywgZmw2LCBmaW5hbF9wLCBmYWxzZSk7DQogCWlmICghYXNv
YyB8fCBzYWRkcikNCiAJCWdvdG8gb3V0Ow0KIA0KQEAgLTMzMywxMCArMzE1LDEyIEBAIHN0YXRp
YyB2b2lkIHNjdHBfdjZfZ2V0X2RzdChzdHJ1Y3Qgc2N0cF90cmFuc3BvcnQgKnQsIHVuaW9uIHNj
dHBfYWRkciAqc2FkZHIsDQogCQl9DQogCX0NCiAJcmN1X3JlYWRfdW5sb2NrKCk7DQorDQogCWlm
IChiYWRkcikgew0KIAkJaXB2Nl9hZGRyX2NvcHkoJmZsNi0+c2FkZHIsICZiYWRkci0+djYuc2lu
Nl9hZGRyKTsNCiAJCWZsNi0+Zmw2X3Nwb3J0ID0gYmFkZHItPnY2LnNpbjZfcG9ydDsNCi0JCWRz
dCA9IGlwNl9kc3RfbG9va3VwX2Zsb3coc2ssIGZsNiwgTlVMTCwgZmFsc2UpOw0KKwkJZmluYWxf
cCA9IGZsNl91cGRhdGVfZHN0KGZsNiwgbnAtPm9wdCwgJmZpbmFsKTsNCisJCWRzdCA9IGlwNl9k
c3RfbG9va3VwX2Zsb3coc2ssIGZsNiwgZmluYWxfcCwgZmFsc2UpOw0KIAl9DQogDQogb3V0Og0K
ZGlmZiAtLWdpdCBhL25ldC9zY3RwL3NtX3NpZGVlZmZlY3QuYyBiL25ldC9zY3RwL3NtX3NpZGVl
ZmZlY3QuYw0KaW5kZXggOTAzMmQ1MC4uNzYzODhiMCAxMDA2NDQNCi0tLSBhL25ldC9zY3RwL3Nt
X3NpZGVlZmZlY3QuYw0KKysrIGIvbmV0L3NjdHAvc21fc2lkZWVmZmVjdC5jDQpAQCAtMTYwNCw5
ICsxNjA0LDggQEAgc3RhdGljIGludCBzY3RwX2NtZF9pbnRlcnByZXRlcihzY3RwX2V2ZW50X3Qg
ZXZlbnRfdHlwZSwNCiAJCQkJCWFzb2MtPm91dHF1ZXVlLm91dHN0YW5kaW5nX2J5dGVzOw0KIAkJ
CXNhY2toLm51bV9nYXBfYWNrX2Jsb2NrcyA9IDA7DQogCQkJc2Fja2gubnVtX2R1cF90c25zID0g
MDsNCi0JCQljaHVuay0+c3ViaC5zYWNrX2hkciA9ICZzYWNraDsNCiAJCQlzY3RwX2FkZF9jbWRf
c2YoY29tbWFuZHMsIFNDVFBfQ01EX1BST0NFU1NfU0FDSywNCi0JCQkJCVNDVFBfQ0hVTksoY2h1
bmspKTsNCisJCQkJCVNDVFBfU0FDS0goJnNhY2toKSk7DQogCQkJYnJlYWs7DQogDQogCQljYXNl
IFNDVFBfQ01EX0RJU0NBUkRfUEFDS0VUOg0KZGlmZiAtLWdpdCBhL25ldC9zY3RwL3NvY2tldC5j
IGIvbmV0L3NjdHAvc29ja2V0LmMNCmluZGV4IGJhMDEwOGYuLmM1M2QwMWUgMTAwNjQ0DQotLS0g
YS9uZXQvc2N0cC9zb2NrZXQuYw0KKysrIGIvbmV0L3NjdHAvc29ja2V0LmMNCkBAIC04MTQsNiAr
ODE0LDkgQEAgc3RhdGljIGludCBzY3RwX3NlbmRfYXNjb25mX2RlbF9pcChzdHJ1Y3Qgc29jawkJ
KnNrLA0KIAkJCWdvdG8gc2tpcF9ta2FzY29uZjsNCiAJCX0NCiANCisJCWlmIChsYWRkciA9PSBO
VUxMKQ0KKwkJCXJldHVybiAtRUlOVkFMOw0KKw0KIAkJLyogV2UgZG8gbm90IG5lZWQgUkNVIHBy
b3RlY3Rpb24gdGhyb3VnaG91dCB0aGlzIGxvb3ANCiAJCSAqIGJlY2F1c2UgdGhpcyBpcyBkb25l
IHVuZGVyIGEgc29ja2V0IGxvY2sgZnJvbSB0aGUNCiAJCSAqIHNldHNvY2tvcHQgY2FsbC4NCmRp
ZmYgLS1naXQgYS9uZXQvdGlwYy9ldGhfbWVkaWEuYyBiL25ldC90aXBjL2V0aF9tZWRpYS5jDQpp
bmRleCBlNzI4ZDRjLi5hMjI0YTM4IDEwMDY0NA0KLS0tIGEvbmV0L3RpcGMvZXRoX21lZGlhLmMN
CisrKyBiL25ldC90aXBjL2V0aF9tZWRpYS5jDQpAQCAtNTMsNiArNTMsNyBAQCBzdHJ1Y3QgZXRo
X2JlYXJlciB7DQogCXN0cnVjdCB0aXBjX2JlYXJlciAqYmVhcmVyOw0KIAlzdHJ1Y3QgbmV0X2Rl
dmljZSAqZGV2Ow0KIAlzdHJ1Y3QgcGFja2V0X3R5cGUgdGlwY19wYWNrZXRfdHlwZTsNCisJc3Ry
dWN0IHdvcmtfc3RydWN0IHNldHVwOw0KIH07DQogDQogc3RhdGljIHN0cnVjdCBldGhfYmVhcmVy
IGV0aF9iZWFyZXJzW01BWF9FVEhfQkVBUkVSU107DQpAQCAtMTIxLDYgKzEyMiwxNyBAQCBzdGF0
aWMgaW50IHJlY3ZfbXNnKHN0cnVjdCBza19idWZmICpidWYsIHN0cnVjdCBuZXRfZGV2aWNlICpk
ZXYsDQogfQ0KIA0KIC8qKg0KKyAqIHNldHVwX2JlYXJlciAtIHNldHVwIGFzc29jaWF0aW9uIGJl
dHdlZW4gRXRoZXJuZXQgYmVhcmVyIGFuZCBpbnRlcmZhY2UNCisgKi8NCitzdGF0aWMgdm9pZCBz
ZXR1cF9iZWFyZXIoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KK3sNCisJc3RydWN0IGV0aF9i
ZWFyZXIgKmViX3B0ciA9DQorCQljb250YWluZXJfb2Yod29yaywgc3RydWN0IGV0aF9iZWFyZXIs
IHNldHVwKTsNCisNCisJZGV2X2FkZF9wYWNrKCZlYl9wdHItPnRpcGNfcGFja2V0X3R5cGUpOw0K
K30NCisNCisvKioNCiAgKiBlbmFibGVfYmVhcmVyIC0gYXR0YWNoIFRJUEMgYmVhcmVyIHRvIGFu
IEV0aGVybmV0IGludGVyZmFjZQ0KICAqLw0KIA0KQEAgLTE2NCw3ICsxNzYsOCBAQCBzdGF0aWMg
aW50IGVuYWJsZV9iZWFyZXIoc3RydWN0IHRpcGNfYmVhcmVyICp0Yl9wdHIpDQogCWViX3B0ci0+
dGlwY19wYWNrZXRfdHlwZS5mdW5jID0gcmVjdl9tc2c7DQogCWViX3B0ci0+dGlwY19wYWNrZXRf
dHlwZS5hZl9wYWNrZXRfcHJpdiA9IGViX3B0cjsNCiAJSU5JVF9MSVNUX0hFQUQoJihlYl9wdHIt
PnRpcGNfcGFja2V0X3R5cGUubGlzdCkpOw0KLQlkZXZfYWRkX3BhY2soJmViX3B0ci0+dGlwY19w
YWNrZXRfdHlwZSk7DQorCUlOSVRfV09SSygmZWJfcHRyLT5zZXR1cCwgc2V0dXBfYmVhcmVyKTsN
CisJc2NoZWR1bGVfd29yaygmZWJfcHRyLT5zZXR1cCk7DQogDQogCS8qIEFzc29jaWF0ZSBUSVBD
IGJlYXJlciB3aXRoIEV0aGVybmV0IGJlYXJlciAqLw0KIA0KZGlmZiAtLWdpdCBhL3NjcmlwdHMv
a2VybmVsLWRvYyBiL3NjcmlwdHMva2VybmVsLWRvYw0KaW5kZXggZDc5MzAwMS4uYmEzZDlkZiAx
MDA3NTUNCi0tLSBhL3NjcmlwdHMva2VybmVsLWRvYw0KKysrIGIvc2NyaXB0cy9rZXJuZWwtZG9j
DQpAQCAtMjA0NCw2ICsyMDQ0LDkgQEAgc3ViIHByb2Nlc3NfZmlsZSgkKSB7DQogDQogICAgICRz
ZWN0aW9uX2NvdW50ZXIgPSAwOw0KICAgICB3aGlsZSAoPElOPikgew0KKwl3aGlsZSAocy9cXFxz
KiQvLykgew0KKwkgICAgJF8gLj0gPElOPjsNCisJfQ0KIAlpZiAoJHN0YXRlID09IDApIHsNCiAJ
ICAgIGlmICgvJGRvY19zdGFydC9vKSB7DQogCQkkc3RhdGUgPSAxOwkJIyBuZXh0IGxpbmUgaXMg
YWx3YXlzIHRoZSBmdW5jdGlvbiBuYW1lDQpkaWZmIC0tZ2l0IGEvc291bmQvcGNpL2hkYS9oZGFf
aW50ZWwuYyBiL3NvdW5kL3BjaS9oZGEvaGRhX2ludGVsLmMNCmluZGV4IGExNjZhODUuLjdlYmU0
YjcgMTAwNjQ0DQotLS0gYS9zb3VuZC9wY2kvaGRhL2hkYV9pbnRlbC5jDQorKysgYi9zb3VuZC9w
Y2kvaGRhL2hkYV9pbnRlbC5jDQpAQCAtMjYyMSw2ICsyNjIxLDcgQEAgc3RhdGljIHN0cnVjdCBz
bmRfcGNpX3F1aXJrIG1zaV9ibGFja19saXN0W10gX19kZXZpbml0ZGF0YSA9IHsNCiAJU05EX1BD
SV9RVUlSSygweDEwNDMsIDB4ODFmMiwgIkFTVVMiLCAwKSwgLyogQXRobG9uNjQgWDIgKyBudmlk
aWEgKi8NCiAJU05EX1BDSV9RVUlSSygweDEwNDMsIDB4ODFmNiwgIkFTVVMiLCAwKSwgLyogbnZp
ZGlhICovDQogCVNORF9QQ0lfUVVJUksoMHgxMDQzLCAweDgyMmQsICJBU1VTIiwgMCksIC8qIEF0
aGxvbjY0IFgyICsgbnZpZGlhIE1DUDU1ICovDQorCVNORF9QQ0lfUVVJUksoMHgxMTc5LCAweGZi
NDQsICJUb3NoaWJhIFNhdGVsbGl0ZSBDODcwIiwgMCksIC8qIEFNRCBIdWRzb24gKi8NCiAJU05E
X1BDSV9RVUlSSygweDE4NDksIDB4MDg4OCwgIkFTUm9jayIsIDApLCAvKiBBdGhsb242NCBYMiAr
IG52aWRpYSAqLw0KIAlTTkRfUENJX1FVSVJLKDB4YTBhMCwgMHgwNTc1LCAiQW9wZW4gTVo5MTUt
TSIsIDApLCAvKiBJQ0g2ICovDQogCXt9DQpkaWZmIC0tZ2l0IGEvc291bmQvcGNpL2hkYS9wYXRj
aF9oZG1pLmMgYi9zb3VuZC9wY2kvaGRhL3BhdGNoX2hkbWkuYw0KaW5kZXggNTVkOWIzMC4uMDVm
MDk3YSAxMDA2NDQNCi0tLSBhL3NvdW5kL3BjaS9oZGEvcGF0Y2hfaGRtaS5jDQorKysgYi9zb3Vu
ZC9wY2kvaGRhL3BhdGNoX2hkbWkuYw0KQEAgLTUxMiw2ICs1MTIsMTcgQEAgc3RhdGljIGludCBo
ZG1pX2NoYW5uZWxfYWxsb2NhdGlvbihzdHJ1Y3QgaGRtaV9lbGQgKmVsZCwgaW50IGNoYW5uZWxz
KQ0KIAkJfQ0KIAl9DQogDQorCWlmICghY2EpIHsNCisJCS8qIGlmIHRoZXJlIHdhcyBubyBtYXRj
aCwgc2VsZWN0IHRoZSByZWd1bGFyIEFMU0EgY2hhbm5lbA0KKwkJICogYWxsb2NhdGlvbiB3aXRo
IHRoZSBtYXRjaGluZyBudW1iZXIgb2YgY2hhbm5lbHMgKi8NCisJCWZvciAoaSA9IDA7IGkgPCBB
UlJBWV9TSVpFKGNoYW5uZWxfYWxsb2NhdGlvbnMpOyBpKyspIHsNCisJCQlpZiAoY2hhbm5lbHMg
PT0gY2hhbm5lbF9hbGxvY2F0aW9uc1tpXS5jaGFubmVscykgew0KKwkJCQljYSA9IGNoYW5uZWxf
YWxsb2NhdGlvbnNbaV0uY2FfaW5kZXg7DQorCQkJCWJyZWFrOw0KKwkJCX0NCisJCX0NCisJfQ0K
Kw0KIAlzbmRfcHJpbnRfY2hhbm5lbF9hbGxvY2F0aW9uKGVsZC0+c3BrX2FsbG9jLCBidWYsIHNp
emVvZihidWYpKTsNCiAJc25kX3ByaW50ZGQoIkhETUk6IHNlbGVjdCBDQSAweCV4IGZvciAlZC1j
aGFubmVsIGFsbG9jYXRpb246ICVzXG4iLA0KIAkJICAgIGNhLCBjaGFubmVscywgYnVmKTsNCmRp
ZmYgLS1naXQgYS9zb3VuZC9zb2MvY29kZWNzLzg4cG04NjB4LWNvZGVjLmMgYi9zb3VuZC9zb2Mv
Y29kZWNzLzg4cG04NjB4LWNvZGVjLmMNCmluZGV4IDVjYTEyMmUuLjI5MGY0ZDMgMTAwNjQ0DQot
LS0gYS9zb3VuZC9zb2MvY29kZWNzLzg4cG04NjB4LWNvZGVjLmMNCisrKyBiL3NvdW5kL3NvYy9j
b2RlY3MvODhwbTg2MHgtY29kZWMuYw0KQEAgLTM1MSw2ICszNTEsOSBAQCBzdGF0aWMgaW50IHNu
ZF9zb2NfcHV0X3ZvbHN3XzJyX3N0KHN0cnVjdCBzbmRfa2NvbnRyb2wgKmtjb250cm9sLA0KIAl2
YWwgPSB1Y29udHJvbC0+dmFsdWUuaW50ZWdlci52YWx1ZVswXTsNCiAJdmFsMiA9IHVjb250cm9s
LT52YWx1ZS5pbnRlZ2VyLnZhbHVlWzFdOw0KIA0KKwlpZiAodmFsID49IEFSUkFZX1NJWkUoc3Rf
dGFibGUpIHx8IHZhbDIgPj0gQVJSQVlfU0laRShzdF90YWJsZSkpDQorCQlyZXR1cm4gLUVJTlZB
TDsNCisNCiAJZXJyID0gc25kX3NvY191cGRhdGVfYml0cyhjb2RlYywgcmVnLCAweDNmLCBzdF90
YWJsZVt2YWxdLm0pOw0KIAlpZiAoZXJyIDwgMCkNCiAJCXJldHVybiBlcnI7DQpkaWZmIC0tZ2l0
IGEvc291bmQvc29jL2NvZGVjcy9tYXg5ODA5NS5jIGIvc291bmQvc29jL2NvZGVjcy9tYXg5ODA5
NS5jDQppbmRleCAyNmQ3YjA4Li5hNTJjMTViIDEwMDY0NA0KLS0tIGEvc291bmQvc29jL2NvZGVj
cy9tYXg5ODA5NS5jDQorKysgYi9zb3VuZC9zb2MvY29kZWNzL21heDk4MDk1LmMNCkBAIC0xODYx
LDcgKzE4NjEsNyBAQCBzdGF0aWMgaW50IG1heDk4MDk1X3B1dF9lcV9lbnVtKHN0cnVjdCBzbmRf
a2NvbnRyb2wgKmtjb250cm9sLA0KIAlzdHJ1Y3QgbWF4OTgwOTVfcGRhdGEgKnBkYXRhID0gbWF4
OTgwOTUtPnBkYXRhOw0KIAlpbnQgY2hhbm5lbCA9IG1heDk4MDk1X2dldF9lcV9jaGFubmVsKGtj
b250cm9sLT5pZC5uYW1lKTsNCiAJc3RydWN0IG1heDk4MDk1X2NkYXRhICpjZGF0YTsNCi0JaW50
IHNlbCA9IHVjb250cm9sLT52YWx1ZS5pbnRlZ2VyLnZhbHVlWzBdOw0KKwl1bnNpZ25lZCBpbnQg
c2VsID0gdWNvbnRyb2wtPnZhbHVlLmludGVnZXIudmFsdWVbMF07DQogCXN0cnVjdCBtYXg5ODA5
NV9lcV9jZmcgKmNvZWZfc2V0Ow0KIAlpbnQgZnMsIGJlc3QsIGJlc3RfdmFsLCBpOw0KIAlpbnQg
cmVnbWFzaywgcmVnc2F2ZTsNCkBAIC0yMDE0LDcgKzIwMTQsNyBAQCBzdGF0aWMgaW50IG1heDk4
MDk1X3B1dF9icV9lbnVtKHN0cnVjdCBzbmRfa2NvbnRyb2wgKmtjb250cm9sLA0KIAlzdHJ1Y3Qg
bWF4OTgwOTVfcGRhdGEgKnBkYXRhID0gbWF4OTgwOTUtPnBkYXRhOw0KIAlpbnQgY2hhbm5lbCA9
IG1heDk4MDk1X2dldF9icV9jaGFubmVsKGNvZGVjLCBrY29udHJvbC0+aWQubmFtZSk7DQogCXN0
cnVjdCBtYXg5ODA5NV9jZGF0YSAqY2RhdGE7DQotCWludCBzZWwgPSB1Y29udHJvbC0+dmFsdWUu
aW50ZWdlci52YWx1ZVswXTsNCisJdW5zaWduZWQgaW50IHNlbCA9IHVjb250cm9sLT52YWx1ZS5p
bnRlZ2VyLnZhbHVlWzBdOw0KIAlzdHJ1Y3QgbWF4OTgwOTVfYmlxdWFkX2NmZyAqY29lZl9zZXQ7
DQogCWludCBmcywgYmVzdCwgYmVzdF92YWwsIGk7DQogCWludCByZWdtYXNrLCByZWdzYXZlOw0K
ZGlmZiAtLWdpdCBhL3NvdW5kL3NvYy9jb2RlY3Mvd204OTYwLmMgYi9zb3VuZC9zb2MvY29kZWNz
L3dtODk2MC5jDQppbmRleCAyZGYyNTNjLi5lZjk2Y2E2IDEwMDY0NA0KLS0tIGEvc291bmQvc29j
L2NvZGVjcy93bTg5NjAuYw0KKysrIGIvc291bmQvc29jL2NvZGVjcy93bTg5NjAuYw0KQEAgLTgw
NSw5ICs4MDUsOSBAQCBzdGF0aWMgaW50IHdtODk2MF9zZXRfZGFpX3BsbChzdHJ1Y3Qgc25kX3Nv
Y19kYWkgKmNvZGVjX2RhaSwgaW50IHBsbF9pZCwNCiAJaWYgKHBsbF9kaXYuaykgew0KIAkJcmVn
IHw9IDB4MjA7DQogDQotCQlzbmRfc29jX3dyaXRlKGNvZGVjLCBXTTg5NjBfUExMMiwgKHBsbF9k
aXYuayA+PiAxOCkgJiAweDNmKTsNCi0JCXNuZF9zb2Nfd3JpdGUoY29kZWMsIFdNODk2MF9QTEwz
LCAocGxsX2Rpdi5rID4+IDkpICYgMHgxZmYpOw0KLQkJc25kX3NvY193cml0ZShjb2RlYywgV004
OTYwX1BMTDQsIHBsbF9kaXYuayAmIDB4MWZmKTsNCisJCXNuZF9zb2Nfd3JpdGUoY29kZWMsIFdN
ODk2MF9QTEwyLCAocGxsX2Rpdi5rID4+IDE2KSAmIDB4ZmYpOw0KKwkJc25kX3NvY193cml0ZShj
b2RlYywgV004OTYwX1BMTDMsIChwbGxfZGl2LmsgPj4gOCkgJiAweGZmKTsNCisJCXNuZF9zb2Nf
d3JpdGUoY29kZWMsIFdNODk2MF9QTEw0LCBwbGxfZGl2LmsgJiAweGZmKTsNCiAJfQ0KIAlzbmRf
c29jX3dyaXRlKGNvZGVjLCBXTTg5NjBfUExMMSwgcmVnKTsNCiANCmRpZmYgLS1naXQgYS90b29s
cy9wZXJmL3V0aWwvbWFwLmMgYi90b29scy9wZXJmL3V0aWwvbWFwLmMNCmluZGV4IDQyZGZmYTAu
LmY3YTdiOWQgMTAwNjQ0DQotLS0gYS90b29scy9wZXJmL3V0aWwvbWFwLmMNCisrKyBiL3Rvb2xz
L3BlcmYvdXRpbC9tYXAuYw0KQEAgLTE2LDYgKzE2LDcgQEAgY29uc3QgY2hhciAqbWFwX3R5cGVf
X25hbWVbTUFQX19OUl9UWVBFU10gPSB7DQogc3RhdGljIGlubGluZSBpbnQgaXNfYW5vbl9tZW1v
cnkoY29uc3QgY2hhciAqZmlsZW5hbWUpDQogew0KIAlyZXR1cm4gIXN0cmNtcChmaWxlbmFtZSwg
Ii8vYW5vbiIpIHx8DQorCSAgICAgICAhc3RyY21wKGZpbGVuYW1lLCAiL2Rldi96ZXJvIChkZWxl
dGVkKSIpIHx8DQogCSAgICAgICAhc3RyY21wKGZpbGVuYW1lLCAiL2Fub25faHVnZXBhZ2UgKGRl
bGV0ZWQpIik7DQogfQ0KIA0K


--=-YmKthqYRHlCS9M+LqDyW--

--=-8bssVfrRwq/1lNEDyb63
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUmyOLue/yOyVhhEJAQrvsg//US4KZ5/fpRc1x1aE3jBKEYJjU9sP3utr
M4HBFAWmU9oum98mYwEIfpBIAUKH7Dj6c4wVWTuxcOod1KMyomIODZtar1Y1eMhj
h9rsXroWa/J+EoN56QLfyCdavRZJ6F2tNEsO+dW1iWNp6EUySYX6LYO6B91CLjhj
/4/Q0ZUMXL41mvzrfSmxz3RXk1HdV3ewaSioVbqfoLFwX8ki2l7FYp9VvS6ocauj
hgQLFiNuX0kNVKOg1LYJNBrifUZgws+3JDFhBz1UJ6Gw+tpYYLnY+t2JnPloOzSg
s+iXdguYkCjgMFIOpNHlIJQQiO0OVzyStlxQ4iuD0lgxzYbH7DyXeWjbxDSu3DDx
/AhmS5wtbPSiHGU2v+gZnNJzokvVQzWx+cMu2ed/lvZevy03CO9YBw+CGEF7iB50
/J0V5v9m00Ca+fD8UKvZz/Oc2q9uJm9geZhRJRDDbBuZjGd56wL2oHOozliIjFll
SGoxCEvq0QMVFut2lJgNltqMzQ/b8U4jj2F4MmwNlHmDXhManzQFgKCIxbDlJVxx
7dhH5ymk+akpGd0Q6FmjJvMhPENfYyUcXdVJ6aeCG0cbTifiwLNmZHm0RRAe/ADK
v4qTHm7ZAKsll5sVQC9p5f40tLJP2ZKK7ZNWCcvuMys6hqk1jwmDUVOP93LiNsPB
I36wIvEMTOg=
=W5bP
-----END PGP SIGNATURE-----

--=-8bssVfrRwq/1lNEDyb63--
