Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3JJPmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:42:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52506 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3JJPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [ 3.8.y.z extended stable ] Linux 3.8.13.11 stable review
Date: Thu, 10 Oct 2013 08:40:48 -0700
Message-Id: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.8.13.11 stable kernel.

This version contains 104 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.8.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.8.y-review

The review period for version 3.8.13.11 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.8.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 arch/arm/crypto/aes-armv4.S                |   6 +-
 arch/powerpc/kernel/iommu.c                |   2 +-
 arch/powerpc/kernel/sysfs.c                |  18 +++-
 arch/powerpc/kernel/vio.c                  |  12 ++-
 arch/powerpc/lib/checksum_64.S             |  58 ++++++++---
 arch/x86/kernel/reboot.c                   |  16 +++
 arch/x86/platform/efi/efi.c                |  11 +-
 block/cfq-iosched.c                        |   2 +-
 drivers/base/core.c                        |  14 +--
 drivers/block/cciss.c                      |   1 +
 drivers/block/cpqarray.c                   |   1 +
 drivers/bluetooth/ath3k.c                  |   2 +
 drivers/bluetooth/btusb.c                  |   2 +
 drivers/gpio/gpio-omap.c                   | 157 +++++++++++++++++++----------
 drivers/gpu/drm/ast/ast_drv.h              |   2 +-
 drivers/gpu/drm/i915/intel_display.c       |  15 +--
 drivers/gpu/drm/i915/intel_dp.c            |  13 ++-
 drivers/gpu/drm/radeon/atombios_encoders.c |   8 +-
 drivers/gpu/drm/radeon/r100.c              |   8 +-
 drivers/gpu/drm/radeon/radeon_connectors.c |  34 ++++++-
 drivers/gpu/drm/radeon/radeon_device.c     |  15 ++-
 drivers/gpu/drm/radeon/radeon_kms.c        |   3 +
 drivers/gpu/drm/radeon/radeon_ring.c       |   8 +-
 drivers/gpu/drm/radeon/si.c                | 106 ++++++++++---------
 drivers/gpu/drm/ttm/ttm_tt.c               |   2 +-
 drivers/hid/hid-core.c                     |  74 ++++++++++++--
 drivers/hid/hid-input.c                    |  11 +-
 drivers/hid/hid-lenovo-tpkbd.c             |  25 +++--
 drivers/hid/hid-lg2ff.c                    |  19 +---
 drivers/hid/hid-lg3ff.c                    |  29 ++----
 drivers/hid/hid-lg4ff.c                    |  20 +---
 drivers/hid/hid-lgff.c                     |  17 +---
 drivers/hid/hid-logitech-dj.c              |  10 +-
 drivers/hid/hid-multitouch.c               |  26 ++---
 drivers/hid/hid-zpff.c                     |  18 +---
 drivers/hwmon/applesmc.c                   |  11 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c      |  14 ++-
 drivers/md/dm-snap-persistent.c            |   2 +-
 drivers/md/dm-snap.c                       |   5 +-
 drivers/net/bonding/bond_main.c            |   8 +-
 drivers/net/ethernet/broadcom/tg3.c        |  19 +++-
 drivers/net/ethernet/realtek/8139cp.c      |   1 +
 drivers/net/ethernet/sfc/rx.c              |   3 +-
 drivers/net/macvlan.c                      |   4 +
 drivers/net/tun.c                          |   6 +-
 drivers/net/usb/cdc_ether.c                |   5 +
 drivers/net/usb/cdc_mbim.c                 |   4 +
 drivers/net/wireless/mwifiex/11n_aggr.c    |   3 +-
 drivers/net/wireless/mwifiex/11n_aggr.h    |   2 +-
 drivers/net/wireless/mwifiex/usb.c         |   7 --
 drivers/net/wireless/mwifiex/wmm.c         |   3 +-
 drivers/net/wireless/p54/p54usb.c          |   1 +
 drivers/net/wireless/rtlwifi/wifi.h        |   2 +-
 drivers/pci/pci-acpi.c                     |   6 +-
 drivers/staging/vt6656/iwctl.c             |   3 +
 drivers/staging/vt6656/main_usb.c          |   3 +-
 drivers/tty/hvc/hvc_xen.c                  |   1 +
 drivers/tty/serial/pch_uart.c              |   3 +-
 drivers/usb/core/devio.c                   |  16 +++
 drivers/usb/dwc3/dwc3-pci.c                |   4 +
 drivers/usb/gadget/dummy_hcd.c             |   7 +-
 drivers/usb/gadget/f_fs.c                  |  60 +++++------
 drivers/usb/host/ehci-fsl.c                |  12 +--
 drivers/usb/host/ehci-pci.c                |   2 +-
 drivers/usb/host/ohci-hcd.c                |  22 ++--
 drivers/usb/host/ohci-q.c                  |  24 ++++-
 drivers/usb/host/uhci-pci.c                |   2 +-
 drivers/usb/host/uhci-q.c                  |  12 ++-
 drivers/usb/host/xhci-hub.c                |   2 +-
 drivers/usb/host/xhci-pci.c                |   2 +-
 drivers/usb/host/xhci-ring.c               |  16 +++
 drivers/usb/host/xhci.c                    |  25 +----
 drivers/usb/host/xhci.h                    |   1 +
 drivers/usb/serial/option.c                |   3 +
 drivers/vhost/net.c                        |   9 +-
 fs/binfmt_elf.c                            |  30 +++---
 fs/cifs/dir.c                              |   1 +
 fs/nilfs2/page.c                           |   2 +
 fs/nilfs2/segment.c                        |  11 +-
 include/linux/balloon_compaction.h         |  25 +++++
 include/linux/hid.h                        |   4 +
 include/linux/ipv6.h                       |   4 +-
 include/net/bluetooth/hci.h                |   1 +
 include/uapi/drm/radeon_drm.h              |   3 +
 include/uapi/linux/icmpv6.h                |   2 +
 include/uapi/linux/ipv6.h                  |   2 +
 kernel/sched/fair.c                        |  14 ++-
 mm/migrate.c                               |   2 +-
 mm/vmscan.c                                |   4 +-
 net/bluetooth/hci_core.c                   |  15 ++-
 net/bluetooth/hci_event.c                  |   6 +-
 net/bridge/br_multicast.c                  |   5 +-
 net/core/neighbour.c                       |  10 +-
 net/core/sysctl_net_core.c                 |  20 +++-
 net/ipv4/fib_trie.c                        |   5 +-
 net/ipv4/raw.c                             |   3 +-
 net/ipv4/sysctl_net_ipv4.c                 |  11 +-
 net/ipv4/tcp.c                             |   7 ++
 net/ipv4/tcp_cubic.c                       |  12 ++-
 net/ipv4/tcp_output.c                      |   6 +-
 net/ipv6/addrconf.c                        |  10 +-
 net/ipv6/exthdrs.c                         |   3 +-
 net/ipv6/icmp.c                            |  10 +-
 net/ipv6/ip6_fib.c                         |  16 ++-
 net/ipv6/ip6_input.c                       |   5 +-
 net/ipv6/reassembly.c                      |   5 +
 net/ipv6/tcp_ipv6.c                        |   2 +-
 net/sched/sch_htb.c                        |   2 +-
 net/sysctl_net.c                           |   4 +-
 net/tipc/socket.c                          |   4 +-
 security/smack/smackfs.c                   |   2 +-
 sound/core/compress_offload.c              |   3 +-
 sound/soc/codecs/88pm860x-codec.c          |   3 +
 sound/soc/codecs/ab8500-codec.c            |   7 +-
 sound/soc/codecs/max98095.c                |   4 +-
 115 files changed, 895 insertions(+), 490 deletions(-)

Al Viro (1):
      USB: Fix breakage in ffs_fs_mount()

Alan Stern (4):
      usb: gadget: fix a bug and a WARN_ON in dummy-hcd
      USB: UHCI: accept very late isochronous URBs
      USB: OHCI: accept very late isochronous URBs
      USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd

Alex Deucher (3):
      drm/radeon/atom: workaround vbios bug in transmitter table on rs880 (v2)
      drm/radeon: fix panel scaling with eDP and LVDS bridges
      drm/radeon: disable tests/benchmarks if accel is disabled

Alex Ivanov (1):
      drm/radeon: Make r100_cp_ring_info() and radeon_ring_gfx() safe (v2)

Amitkumar Karwar (1):
      mwifiex: fix hang issue for USB chipsets

Anatol Pomozov (1):
      cfq: explicitly use 64bit divide operation for 64bit arguments

Andre Guedes (2):
      Bluetooth: Fix security level for peripheral role
      Bluetooth: Fix encryption key size for peripheral role

Andrew Vagin (1):
      tcp: initialize rcv_tstamp for restored sockets

Andrey Vagin (1):
      tcp: set timestamps for restored skb-s

Ard Biesheuvel (1):
      ARM: 7837/3: fix Thumb-2 bug in AES assembler code

Ben Hutchings (1):
      sfc: Fix efx_rx_buf_offset() for recycled pages

Ben Skeggs (1):
      drm/ttm: fix the tt_populated check in ttm_tt_destroy()

Benjamin Tissoires (3):
      HID: validate feature and input report details
      HID: multitouch: validate indexes details
      HID: lenovo-tpkbd: fix leak if tpkbd_probe_tp fails

Benson Leung (1):
      driver core : Fix use after free of dev->parent in device_shutdown

Bing Zhao (1):
      mwifiex: fix NULL pointer dereference in usb suspend handler

Chris Clark (1):
      ipv4: sendto/hdrincl: don't use destination address found in header

Christian Lamparter (1):
      p54usb: add USB ID for Corega WLUSB2GTST USB adapter

Daisuke Nishimura (1):
      sched/fair: Fix small race where child->se.parent,cfs_rq might point to invalid ones

Dan Aloni (1):
      fs/binfmt_elf.c: prevent a coredump with a large vm_map_count from Oopsing

Dan Carpenter (6):
      tun: signedness bug in tun_get_user()
      cpqarray: fix info leak in ida_locked_ioctl()
      cciss: fix info leak in cciss_ioctl32_passthru()
      ASoC: max98095: a couple array underflows
      ASoC: ab8500-codec: info leak in anc_status_control_put()
      ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()

Daniel Borkmann (2):
      net: bridge: convert MLDv2 Query MRC into msecs_to_jiffies for max_delay
      net: ipv6: tcp: fix potential use after free in tcp_v6_do_rcv

Dave Airlie (1):
      drm/ast: fix the ast open key function

Dave Jones (1):
      8139cp: Fix skb leak in rx_status_loop failure path.

David Cohen (1):
      usb: dwc3: add support for Merrifield

David Vrabel (1):
      xen/hvc: allow xenboot console to be used again

Eric Dumazet (3):
      fib_trie: remove potential out of bound access
      tcp: cubic: fix overflow error in bictcp_update()
      tcp: cubic: fix bug in bictcp_acked()

Eric W. Biederman (1):
      net: Update the sysctl permissions handler to test effective uid/gid

Erik Hugne (1):
      tipc: set sk_err correctly when connection fails

Fabio Porcedda (1):
      net: usb: cdc_ether: Use wwan interface for Telit modules

Hannes Frederic Sowa (3):
      ipv6: don't stop backtracking in fib6_lookup_1 if subtree does not match
      ipv6: remove max_addresses check from ipv6_create_tempaddr
      ipv6: drop packets with multiple fragmentation headers

Heikki Krogerus (1):
      usb: dwc3: pci: add support for BayTrail

Henrik Rydberg (1):
      hwmon: (applesmc) Check key count before proceeding

Jack Wang (1):
      ib_srpt: always set response for task management

Jani Nikula (2):
      drm/i915: do not update cursor in crtc mode set
      drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER

Jason Wang (1):
      vhost_net: poll vhost queue after marking DMA is done

Javier Martinez Canillas (2):
      gpio/omap: maintain GPIO and IRQ usage separately
      gpio/omap: auto-setup a GPIO when used as an IRQ

Jiri Bohac (1):
      ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO

Johan Hedberg (1):
      Bluetooth: Introduce a new HCI_RFKILLED flag

Johan Hovold (1):
      serial: pch_uart: fix tty-kref leak in dma-rx path

Josh Boyer (1):
      x86, efi: Don't map Boot Services on i386

Kees Cook (5):
      HID: provide a helper for validating hid reports
      HID: zeroplus: validate output report details
      HID: LG: validate HID output report details
      HID: lenovo-tpkbd: validate output report details
      HID: logitech-dj: validate output report details

Kurt Garloff (1):
      usb/core/devio.c: Don't reject control message to endpoint with wrong direction bit

Larry Finger (1):
      rtlwifi: Align private space in rtl_priv struct

Liam Girdwood (1):
      ALSA: compress: Fix compress device unregister.

Linus Lüssing (1):
      bridge: don't try to update timers in case of broken MLD queries

Madhavan Srinivasan (1):
      powerpc/sysfs: Disable writing to PURR in guest mode

Malcolm Priestley (2):
      staging: vt6656: [BUG] main_usb.c oops on device_close move flag earlier.
      staging: vt6656: [BUG] iwctl_siwencodeext return if device not open

Masoud Sharbiani (1):
      x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically

Mathias Nyman (2):
      xhci: Fix oops happening after address device timeout
      xhci: Ensure a command structure points to the correct trb on the command ring

Michael S. Tsirkin (1):
      macvlan: validate flags

Michal Malý (1):
      USB: serial: option: Ignore card reader interface on Huawei E1750

Miklos Szeredi (1):
      cifs: fix filp leak in cifs_atomic_open()

Mikulas Patocka (2):
      dm snapshot: workaround for a false positive lockdep warning
      dm-snapshot: fix performance degradation due to small hash size

Nicholas Bellinger (1):
      ib_srpt: Destroy cm_id before destroying QP.

Nishanth Aravamudan (1):
      powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_table()

Nithin Sujir (2):
      tg3: Don't turn off led on 5719 serdes port 0
      tg3: Expand led off fix to include 5720

Passion,Zhao (1):
      Smack: Fix the bug smackcipso can't set CIPSO correctly

Paul E. McKenney (2):
      powerpc: Fix parameter clobber in csum_partial_copy_generic()
      powerpc: Restore registers on error exit from csum_partial_copy_generic()

Peng Chen (1):
      Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.

Phil Oester (1):
      tcp: tcp_make_synack() should use sock_wmalloc

Prarit Bhargava (1):
      powerpc/vio: Fix modalias_show return values

Rafael Aquini (1):
      mm: avoid reinserting isolated balloon pages into LRU lists

Rafael J. Wysocki (1):
      PCI / ACPI / PM: Clear pme_poll for devices in D3cold on wakeup

Ramneek Mehresh (1):
      fsl/usb: Resolve PHY_CLK_VLD instability issue for ULPI phy

Raphael Kubo da Costa (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17cb]

Rob Gardner (1):
      net: usb: Add HP hs2434 device to ZLP exception table

Roman Gushchin (1):
      net: check net.core.somaxconn sysctl values

Tom Stellard (1):
      drm/radeon/si: Add support for CP DMA to CS checker for compute v2

Veaceslav Falico (2):
      neighbour: populate neigh_parms on alloc before calling ndo_neigh_setup
      bonding: modify only neigh_parms owned by us

Ville Syrjälä (1):
      drm/i915: Don't enable the cursor on a disable pipe

Vyacheslav Dubeyko (1):
      nilfs2: fix issue with race condition of competition between segments for dirty blocks

YOSHIFUJI Hideaki / 吉藤英明 (1):
      ipv6: Store Router Alert option in IP6CB directly.

bingtian.ly@taobao.com (1):
      net: avoid to hang up on sending due to sysctl configuration overflow.

stephen hemminger (1):
      htb: fix sign extension bug
