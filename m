Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab3BSSt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:49:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54124 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab3BSStx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:49:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: =?UTF-8?q?=5B=203=2E5=2Ey=2Ez=20extended=20stable=20=5D=20Linux=203=2E5=2E7=2E6=20stable=20review?=
Date: Tue, 19 Feb 2013 15:48:23 -0300
Message-Id: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the review cycle for the 3.5.7.6 stable release. This new
release contains 81 patches, which are posted as a response to this
message. They are also available at the following repository:

git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y-review

If there are any problems, or if anything is missing, please answer to
this or to any of the followup patches. Note that any answer should be
made at maximum in 3 days, after that the final release of 3.5.7.6 will be
made.

For more information about the 3.5.y.z extended stable tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Included below are the diffstat and shortlog for this release.

-Herton

-- 
 MAINTAINERS                                        |    6 +-
 arch/s390/kernel/time.c                            |    3 +
 arch/x86/ia32/ia32entry.S                          |    4 +-
 arch/x86/include/asm/pgtable.h                     |    5 +
 arch/x86/kernel/apic/x2apic_phys.c                 |   21 +-
 arch/x86/mm/fault.c                                |    8 +-
 arch/x86/mm/init_64.c                              |    3 +
 arch/x86/platform/efi/efi.c                        |    2 +-
 drivers/atm/iphase.h                               |  146 ++++-----
 drivers/char/virtio_console.c                      |    3 +-
 drivers/gpu/drm/radeon/evergreen.c                 |   27 +-
 drivers/gpu/drm/radeon/r600.c                      |    7 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |    8 +
 drivers/gpu/drm/radeon/radeon_display.c            |    4 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |    3 +
 drivers/gpu/drm/radeon/reg_srcs/cayman             |    1 +
 drivers/hid/hid-ids.h                              |    3 +
 drivers/hid/usbhid/hid-quirks.c                    |    1 +
 drivers/isdn/gigaset/capi.c                        |    2 +
 drivers/net/can/c_can/c_can.c                      |    6 +-
 drivers/net/ethernet/broadcom/tg3.c                |   62 ++--
 drivers/net/ethernet/calxeda/xgmac.c               |    4 +
 drivers/net/ethernet/emulex/benet/be.h             |    5 +
 drivers/net/ethernet/emulex/benet/be_main.c        |   56 +++-
 drivers/net/ethernet/intel/e1000e/defines.h        |    9 +
 drivers/net/ethernet/intel/e1000e/e1000.h          |    2 +
 drivers/net/ethernet/intel/e1000e/ethtool.c        |    2 +
 drivers/net/ethernet/intel/e1000e/hw.h             |    1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   11 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |   46 +++
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   13 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   11 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_init.c   |    2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    2 +
 drivers/net/ethernet/realtek/r8169.c               |    7 -
 drivers/net/ethernet/via/via-rhine.c               |    8 +-
 drivers/net/loopback.c                             |    5 +
 drivers/net/macvlan.c                              |    5 +-
 drivers/net/wireless/mwifiex/scan.c                |    9 +-
 drivers/net/wireless/rtlwifi/base.c                |    7 +-
 drivers/net/wireless/rtlwifi/usb.c                 |    4 +-
 drivers/net/xen-netback/common.h                   |    3 +
 drivers/net/xen-netback/interface.c                |   23 +-
 drivers/net/xen-netback/netback.c                  |  115 ++++---
 drivers/pci/remove.c                               |    2 +
 drivers/regulator/max8998.c                        |    2 +-
 drivers/rtc/rtc-isl1208.c                          |    3 +
 drivers/rtc/rtc-pl031.c                            |   10 +-
 drivers/target/target_core_device.c                |    8 +-
 drivers/usb/core/hub.c                             |   82 +++--
 drivers/usb/host/ehci-hub.c                        |    6 +-
 drivers/usb/host/ehci-sched.c                      |    2 +-
 drivers/usb/host/pci-quirks.c                      |    1 +
 drivers/usb/host/xhci-ring.c                       |   13 +-
 drivers/usb/serial/ftdi_sio.c                      |    2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    9 +-
 drivers/usb/serial/option.c                        |   13 +
 drivers/usb/serial/qcserial.c                      |    1 +
 drivers/usb/storage/initializers.c                 |   76 ++++-
 drivers/usb/storage/initializers.h                 |    4 +-
 drivers/usb/storage/unusual_devs.h                 |  329 +-------------------
 drivers/usb/storage/usb.c                          |   12 +
 drivers/usb/storage/usual-tables.c                 |   15 +
 fs/nilfs2/ioctl.c                                  |    5 +-
 include/linux/usb/ch9.h                            |    6 +
 kernel/resource.c                                  |   50 ++-
 kernel/sched/rt.c                                  |    2 +-
 lib/digsig.c                                       |    2 +
 mm/hugetlb.c                                       |    1 +
 mm/migrate.c                                       |    4 +-
 mm/mlock.c                                         |    6 +-
 mm/page_alloc.c                                    |   15 +-
 net/bluetooth/smp.c                                |   13 +
 net/bridge/br_netfilter.c                          |    3 +
 net/core/pktgen.c                                  |    9 +-
 net/ipv4/ip_sockglue.c                             |    2 +-
 net/ipv4/tcp_input.c                               |    5 +
 net/ipv6/addrconf.c                                |    2 +-
 net/ipv6/ip6_output.c                              |    4 +-
 net/ipv6/route.c                                   |    3 +-
 net/packet/af_packet.c                             |   10 +-
 net/sctp/endpointola.c                             |    5 +
 net/sctp/outqueue.c                                |   12 +-
 net/sctp/socket.c                                  |    2 +-
 84 files changed, 786 insertions(+), 640 deletions(-)

Alan Stern (3):
      USB: XHCI: fix memory leak of URB-private data
      USB: EHCI: fix timer bug affecting port resume
      USB: EHCI: fix bug in scheduling periodic split transfers

Alex Deucher (5):
      drm/radeon: add WAIT_UNTIL to the non-VM safe regs list for cayman/TN
      drm/radeon: add quirk for RV100 board
      drm/radeon: fix backend map setup on 1 RB sumo boards
      drm/radeon/evergreen+: wait for the MC to settle after MC blackout
      drm/radeon: prevent crash in the ring space allocation

Alexander Stein (1):
      can: c_can: Set reserved bit in IFx_MASK2 to 1 on write

Bing Zhao (1):
      mwifiex: fix incomplete scan in case of IE parsing error

Bjørn Mork (1):
      USB: option: add Changhong CH690

Bruce Allan (1):
      e1000e: enable ECC on I217/I218 to catch packet buffer memory errors

Christopher Staite (1):
      drm/radeon: fix MC blackout on evergreen+

Cong Wang (2):
      net: prevent setting ttl=0 via IP_TTL
      pktgen: correctly handle failures when adding a device

Daniel Borkmann (2):
      net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
      net: sctp: sctp_endpoint_free: zero out secret key data

Daniele Palmas (2):
      USB: qcserial: add Telit Gobi QDL device
      USB: option: add support for Telit LE920

David Moore (1):
      usb: Prevent dead ports when xhci is not enabled

David S. Miller (1):
      via-rhine: Fix bugs in NAPI support.

Eric Dumazet (4):
      macvlan: fix macvlan_get_size()
      netxen: fix off by one bug in netxen_release_tx_buffer()
      net: loopback: fix a dst refcounting issue
      tcp: frto should not set snd_cwnd to 0

Gerald Schaefer (1):
      mm: don't overwrite mm->def_flags in do_mlockall()

Haojian Zhuang (1):
      drivers/rtc/rtc-pl031.c: fix the missing operation on enable

Heiko Carstens (2):
      atm/iphase: rename fregt_t -> ffreg_t
      s390/timer: avoid overflow when programming clock comparator

Herton Ronaldo Krzesinski (1):
      Revert "USB: Handle warm reset failure on empty port."

Ian Campbell (3):
      xen/netback: shutdown the ring if it contains garbage.
      xen/netback: free already allocated memory on failure in xen_netbk_get_requests
      netback: correct netbk_tx_err to handle wrap around.

Ilpo Järvinen (1):
      tcp: fix for zero packets_in_flight was too broad

Jan Beulich (1):
      x86-64: Replace left over sti/cli in ia32 audit exit code

Jan Luebbe (1):
      drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq handler

Johan Hedberg (1):
      Bluetooth: Fix handling of unexpected SMP PDUs

Kees Cook (1):
      x86: Do not leak kernel page mapping locations

Lan Tianyu (1):
      usb: Using correct way to clear usb3.0 device's remote wakeup feature.

Larry Finger (2):
      rtlwifi: Fix the usage of the wrong variable in usb.c
      rtlwifi: Fix scheduling while atomic bug

Linus Torvalds (1):
      mm: fix pageblock bitmap allocation

Linus Walleij (1):
      drivers/rtc/rtc-pl031.c: restore ST variant functionality

Marcelo Ricardo Leitner (1):
      ipv6: do not create neighbor entries for local delivery

Marek Szyprowski (1):
      regulator: max8998: fix incorrect min_uV value for ldo10

Matthew Daley (1):
      xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.

Mel Gorman (1):
      x86/mm: Check if PUD is large when validating a kernel address

Mikko Tiihonen (1):
      drm/radeon: protect against div by 0 in backend setup

Neil Horman (1):
      sctp: refactor sctp_outq_teardown to insure proper re-initalization

Nicholas Bellinger (1):
      target: Fix divide by zero bug in fabric_max_sectors for unconfigured devices

Nicholas Santos (1):
      HID: usbhid: quirk for Formosa IR receiver

Nickolai Zeldovich (1):
      drivers: xhci: fix incorrect bit test

Nithin Nayak Sujir (2):
      tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mode
      tg3: Fix crc errors on jumbo frame receive

Or Gerlitz (1):
      net/mlx4_core: Set number of msix vectors under SRIOV mode to firmware defaults

Petr Kubánek (1):
      USB: ftdi_sio: add Zolix FTDI PID

Phil Sutter (1):
      packet: fix leakage of tx_ring memory

Rafael J. Wysocki (1):
      PCI/PM: Clean up PME state when removing a device

Rob Herring (1):
      net: calxedaxgmac: throw away overrun frames

Romain KUNTZ (1):
      ipv6: fix header length calculation in ip6_append_data()

Romain Kuntz (1):
      ipv6: fix the noflags test in addrconf_get_prefix_route

Sarah Sharp (2):
      xhci: Fix isoc TD encoding.
      xhci: Fix TD size for isochronous URBs.

Sarveshwar Bandi (1):
      bridge: Pull ip header into skb->data before looking into ip header.

Satoru Takeuchi (1):
      efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" boot parameter

Shawn Bohrer (1):
      sched/rt: Use root_domain of rt_rq not current processor

Sjur Brændeland (1):
      virtio_console: Don't access uninitialized data.

Somnath Kotur (1):
      be2net: Fix to trim skb for padded vlan packets to workaround an ASIC Bug

Stephen Hemminger (1):
      MAINTAINERS: Stephen Hemminger email change

Stoney Wang (1):
      x86/apic: Work around boot failure on HP ProLiant DL980 G7 Server systems

Sven Killig (1):
      USB: ftdi_sio: add PID/VID entries for ELV WS 300 PC II

T Makphaibulchoke (1):
      kernel/resource.c: fix stack overflow in __reserve_region_with_split()

Tilman Schmidt (1):
      isdn/gigaset: fix zero size border case in debug dump

Timo Teräs (1):
      r8169: remove the obsolete and incorrect AMD workaround

Tony Lu (1):
      mm/hugetlb: set PTE as huge in hugetlb_change_protection and remove_migration_pte

Vyacheslav Dubeyko (1):
      nilfs2: fix fix very long mount time issue

YOSHIFUJI Hideaki (1):
      digsig: Fix memory leakage in digsig_verify_rsa()

Yan Burman (1):
      net/mlx4_en: Fix bridged vSwitch configuration for non SRIOV mode

fangxiaozhi (2):
      USB: storage: Define a new macro for USB storage match rules
      USB: storage: optimize to match the Huawei USB storage devices and support new switch command

liu chuansheng (1):
      drm/radeon: Calling object_unrefer() when creating fb failure
