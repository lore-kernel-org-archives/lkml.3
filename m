Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935467Ab3DJMJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:09:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33964 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934753Ab3DJMJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:09:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [3.5.y.z extended stable] Linux 3.5.7.10
Date: Wed, 10 Apr 2013 13:09:26 +0100
Message-Id: <1365595767-7352-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 3.5.7.10 tree of stable patches.

This tree picks up the latest 3.5 stable release upstream, and add patches
on top that were later marked for stable but can't be added to 3.5, as
it is not anymore an stable series maintained upstream.

The tree is maintained by the Ubuntu Kernel Team, with the intention
to continue to provide support for the 3.5 series. Anyone is welcomed
on using it or contributing to this effort.

For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

The updated 3.5.y tree can be found at: 

  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y

The diffstat and shortlog with changes since previous v3.5.7.9 release are
shown below.

-Luis

-- 
 Makefile                                           |   2 +-
 arch/arm/mach-cns3xxx/core.c                       |  16 +-
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h       |  16 +-
 arch/tile/kernel/setup.c                           |  25 ++-
 drivers/base/regmap/regcache-rbtree.c              |   2 +-
 drivers/block/aoe/aoecmd.c                         |   3 +-
 drivers/block/loop.c                               |   9 +-
 drivers/block/xen-blkback/blkback.c                |  38 +++-
 drivers/block/xen-blkback/common.h                 |  25 +++
 drivers/bluetooth/ath3k.c                          |   4 +
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/char/virtio_console.c                      |  21 +-
 drivers/gpu/drm/i915/intel_opregion.c              |  23 ++-
 drivers/hid/hid-ids.h                              |   6 +
 drivers/hid/usbhid/hid-quirks.c                    |   2 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   8 +-
 drivers/iommu/amd_iommu.c                          |  22 +--
 drivers/net/bonding/bond_main.c                    |  91 +++------
 drivers/net/bonding/bond_sysfs.c                   | 121 ++++++------
 drivers/net/can/sja1000/plx_pci.c                  |   4 +-
 drivers/net/can/sja1000/sja1000.c                  |   6 +-
 drivers/net/can/sja1000/sja1000.h                  |   2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e.h         |   1 -
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |  19 +-
 drivers/net/ethernet/broadcom/tg3.c                |   7 +-
 drivers/net/ethernet/davicom/dm9000.c              | 214 +++++++++++----------
 drivers/net/ethernet/davicom/dm9000.h              |  11 +-
 drivers/net/ethernet/marvell/sky2.c                |   2 +-
 drivers/net/ethernet/marvell/sky2.h                |   2 +-
 drivers/net/ethernet/micrel/ks8851.c               |   2 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |   4 +-
 drivers/net/ethernet/ti/cpsw.c                     |   2 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   2 +-
 drivers/net/usb/smsc75xx.c                         |  12 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |   4 +
 drivers/net/wireless/ath/ath9k/xmit.c              |  26 +--
 drivers/net/wireless/b43/dma.c                     |  65 +++++--
 drivers/net/wireless/b43/phy_n.c                   |   8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c         |   9 +
 drivers/net/wireless/iwlwifi/iwl-ucode.c           |   4 +-
 drivers/net/wireless/rtlwifi/usb.c                 |   1 +
 drivers/staging/comedi/drivers/s626.c              |   2 +-
 drivers/thermal/thermal_sys.c                      |   1 +
 drivers/tty/serial/atmel_serial.c                  |  11 +-
 drivers/tty/vt/vc_screen.c                         |   6 +-
 drivers/usb/host/xhci-ring.c                       |  24 +--
 drivers/usb/host/xhci.h                            |   4 +
 drivers/usb/serial/ark3116.c                       |  10 +-
 drivers/usb/serial/ch341.c                         |  11 +-
 drivers/usb/serial/cypress_m8.c                    |  14 +-
 drivers/usb/serial/f81232.c                        |   9 +-
 drivers/usb/serial/ftdi_sio.c                      |  20 +-
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 drivers/usb/serial/io_edgeport.c                   |  12 +-
 drivers/usb/serial/io_ti.c                         |  12 +-
 drivers/usb/serial/mct_u232.c                      |  14 +-
 drivers/usb/serial/mos7840.c                       |  16 +-
 drivers/usb/serial/oti6858.c                       |  10 +-
 drivers/usb/serial/pl2303.c                        |  11 +-
 drivers/usb/serial/quatech2.c                      |  12 +-
 drivers/usb/serial/spcp8x5.c                       |   9 +-
 drivers/usb/serial/ssu100.c                        |  12 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |  10 +-
 drivers/usb/serial/usb-serial.c                    |   1 +
 fs/block_dev.c                                     |   1 +
 fs/btrfs/extent-tree.c                             |  49 ++++-
 fs/btrfs/extent_io.c                               |  33 ++++
 fs/btrfs/extent_io.h                               |   2 +
 fs/btrfs/inode.c                                   |  14 ++
 fs/btrfs/scrub.c                                   |   3 +-
 fs/btrfs/tree-log.c                                |   5 +-
 fs/dcache.c                                        |  16 +-
 fs/nfs/blocklayout/blocklayoutdm.c                 |   4 +-
 fs/nfs/idmap.c                                     |  13 +-
 fs/nfs/nfs4proc.c                                  |  14 --
 fs/nfs/pnfs.c                                      |  19 +-
 fs/nfsd/nfs4xdr.c                                  |   2 +-
 fs/reiserfs/xattr.c                                |   4 +-
 fs/sysfs/dir.c                                     |  17 +-
 fs/ubifs/super.c                                   |  12 +-
 fs/udf/udf_sb.h                                    |   2 +-
 include/linux/thermal.h                            |   2 +-
 include/linux/unix_diag.h                          |   4 +-
 include/linux/usb/serial.h                         |   2 +
 include/xen/interface/io/blkif.h                   |  10 +
 kernel/time/tick-broadcast.c                       |   3 +-
 kernel/time/tick-sched.c                           |   5 +
 kernel/trace/trace.c                               |  50 +++--
 kernel/trace/trace.h                               |   7 +
 kernel/trace/trace_irqsoff.c                       |  19 +-
 kernel/trace/trace_sched_wakeup.c                  |  18 +-
 mm/mmap.c                                          |   2 +-
 mm/nommu.c                                         |   2 +-
 net/8021q/vlan.c                                   |  14 +-
 net/bluetooth/sco.c                                |   1 +
 net/core/dev.c                                     |   7 +-
 net/ipv4/tcp_input.c                               |   7 +-
 net/ipv4/tcp_output.c                              |   7 +-
 net/ipv6/addrconf.c                                |  26 +--
 net/ipv6/ip6_input.c                               |  21 ++
 net/irda/af_irda.c                                 |   6 +-
 net/mac80211/sta_info.c                            |  12 +-
 net/netlink/genetlink.c                            |   1 +
 net/sunrpc/sched.c                                 |   9 +-
 net/unix/af_unix.c                                 |   7 +-
 105 files changed, 946 insertions(+), 587 deletions(-)

Al Viro (2):
      Nest rename_lock inside vfsmount_lock
      vt: synchronize_rcu() under spinlock is not nice...

Amit Shah (2):
      virtio: console: rename cvq_lock to c_ivq_lock
      virtio: console: add locking around c_ovq operations

Anatol Pomozov (1):
      loop: prevent bdev freeing while device in use

Andrey Vagin (1):
      net: fix *_DIAG_MAX constants

Artem Bityutskiy (1):
      UBIFS: make space fixup work in the remount case

Chris Mason (1):
      Btrfs: fix race between mmap writes and compression

Chris Metcalf (1):
      tile: expect new initramfs name from hypervisor file system

Cong Wang (1):
      8021q: fix a potential use-after-free

David Vrabel (1):
      xen/blkback: correctly respond to unknown, non-native requests

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't send HCMD in restart flow

Eric Dumazet (4):
      net: remove a WARN_ON() in net_enable_timestamp()
      tcp: preserve ACK clocking in TSO
      aoe: reserve enough headroom on skbs
      net: add a synchronize_net() in netdev_rx_handler_unregister()

Felix Fietkau (2):
      ath9k_hw: revert chainmask to user configuration after calibration
      ath9k: limit tx path hang check to normal data queues

Frederic Weisbecker (1):
      nohz: Make tick_nohz_irq_exit() irq safe

Hannes Frederic Sowa (3):
      atl1e: drop pci-msi support because of packet corruption
      ipv6: don't accept multicast traffic with scope 0
      ipv6: don't accept node local multicast traffic from the wire

Hong Zhiguo (1):
      ipv6: fix bad free of addrconf_init_net

Ian Abbott (1):
      staging: comedi: s626: fix continuous acquisition

Iestyn C. Elfick (1):
      b43: A fix for DMA transmission sequence errors

J. Bruce Fields (1):
      nfsd4: reject "negative" acl lengths

Jan Beulich (1):
      xen-blkback: fix dispatch_rw_block_io() error path

Jan Kara (2):
      udf: Fix bitmap overflow on large filesystems with small block size
      reiserfs: Fix warning and inode leak when deleting inode with xattrs

Jan Stancek (1):
      mm: prevent mmap_cache race in find_vma()

Jiri Kosina (1):
      HID: usbhid: fix build problem

Joerg Roedel (1):
      iommu/amd: Make sure dma_ops are set for hotplug devices

Johan Hovold (17):
      USB: serial: add modem-status-change wait queue
      USB: ark3116: fix use-after-free in TIOCMIWAIT
      USB: ch341: fix use-after-free in TIOCMIWAIT
      USB: cypress_m8: fix use-after-free in TIOCMIWAIT
      USB: f81232: fix use-after-free in TIOCMIWAIT
      USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
      USB: io_edgeport: fix use-after-free in TIOCMIWAIT
      USB: io_ti: fix use-after-free in TIOCMIWAIT
      USB: mct_u232: fix use-after-free in TIOCMIWAIT
      USB: mos7840: fix broken TIOCMIWAIT
      USB: mos7840: fix use-after-free in TIOCMIWAIT
      USB: oti6858: fix use-after-free in TIOCMIWAIT
      USB: pl2303: fix use-after-free in TIOCMIWAIT
      USB: quatech2: fix use-after-free in TIOCMIWAIT
      USB: spcp8x5: fix use-after-free in TIOCMIWAIT
      USB: ssu100: fix use-after-free in TIOCMIWAIT
      USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT

Johannes Berg (1):
      mac80211: always synchronize_net() during station removal

Josef Bacik (4):
      Btrfs: fix space leak when we fail to reserve metadata space
      Btrfs: limit the global reserve to 512mb
      Btrfs: don't drop path when printing out tree errors in scrub
      Btrfs: use set_nlink if our i_nlink is 0

Joseph CHANG (1):
      DM9000B: driver initialization upgrade

Josh Boyer (2):
      HID: usbhid: quirk for Realtek Multi-card reader
      HID: usbhid: quirk for MSI GX680R led panel

Jussi Kivilinna (1):
      rtlwifi: usb: add missing freeing of skbuff

Kees Cook (2):
      net/irda: add missing error path release_sock call
      tg3: fix length overflow in VPD firmware parsing

Konstantin Holoborodko (1):
      usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD

Lars-Peter Clausen (1):
      regmap: cache Fix regcache-rbtree sync

Lekensteyn (1):
      i915: initialize CADL in opregion

Lingzhu Xiang (2):
      tracing: Protect tracer flags with trace_types_lock
      tracing: Prevent buffer overwrite disabled for latency tracers

Luis Henriques (1):
      Linux 3.5.7.10

Mac Lin (1):
      ARM: cns3xxx: fix mapping of private memory region

Marc Kleine-Budde (1):
      can: sja1000: fix define conflict on SH

Mark Rutland (1):
      clockevents: Don't allow dummy broadcast timers

Masatake YAMATO (2):
      thermal: shorten too long mcast group name
      genetlink: trigger BUG_ON if a group name is too long

Max.Nekludov@us.elster.com (1):
      ks8851: Fix interpretation of rxlen field.

Mike Marciniszyn (1):
      IPoIB: Fix send lockup due to missed TX completion

Ming Lei (5):
      Bluetooth: Add support for Dell[QCA 0cf3:0036]
      Bluetooth: Add support for Dell[QCA 0cf3:817a]
      sysfs: handle failure path correctly for readdir()
      USB: serial: fix hang when opening port
      sysfs: fix race between readdir and lseek

Mirko Lindner (2):
      sky2: Receive Overflows not counted
      sky2: Threshold for Pause Packet is set wrong

Mugunthan V N (2):
      drivers: net: ethernet: davinci_emac: use netif_wake_queue() while restarting tx queue
      drivers: net: ethernet: cpsw: use netif_wake_queue() while restarting tx queue

Paul Moore (1):
      unix: fix a race condition in unix_release()

Pawel Wieczorkiewicz (1):
      tty: atmel_serial_probe(): index of atmel_ports[] fix

Rafał Miłecki (2):
      b43: N-PHY: increase initial value of "mind" in RSSI calibration
      b43: N-PHY: use more bits for offset in RSSI calibration

Richard Guy Briggs (1):
      thermal: return an error on failure to register thermal class

Steve Glendinning (1):
      smsc75xx: fix jumbo frame support

Trond Myklebust (3):
      NFSv4: Fix the string length returned by the idmapper
      NFSv4.1: Fix a race in pNFS layoutcommit
      SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queue_locked

Veaceslav Falico (3):
      bonding: remove already created master sysfs link on failure
      pch_gbe: fix ip_summed checksum reporting on rx
      bonding: get netdev_rx_handler_unregister out of locks

Vinicius Costa Gomes (1):
      Bluetooth: Fix not closing SCO sockets in the BT_CONNECT2 state

Vivek Gautam (1):
      usb: xhci: Fix TRB transfer length macro used for Event TRB.

Yuchung Cheng (1):
      tcp: undo spurious timeout after SACK reneging

fanchaoting (1):
      pnfs-block: removing DM device maybe cause oops when call dev_remove

nikolay@redhat.com (2):
      bonding: fix miimon and arp_interval delayed work race conditions
      bonding: fix disabling of arp_interval and miimon

