Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030697Ab3DSOkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:40:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11887 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030552Ab3DSOk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:40:29 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=CxJuTY6TAAAA:8 a=20KFwNOVAAAA:8 a=YhJ3FK0oAO7F0ZE8RtMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=0mwfenpuG16q0Lcx:21 a=F-k9gHh1ydH4HHtP:21 a=2D9D9bTZ3X8zABNt:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366382427.9609.116.camel@gandalf.local.home>
Subject: Linux 3.6.11.2
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Date: Fri, 19 Apr 2013 10:40:27 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late post. I wanted to send this from the Collab Summit,
but my connection home was unstable.

I'm announcing the release of the 3.6.11.2 kernel.

The updated 3.6.11.y git tree can be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git v3.6-stable

The patch can be downloaded at:
	https://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.2.xz

thanks,

-- Steve

 Makefile                                           |    2 +-
 arch/arm/boot/dts/kirkwood-goflexnet.dts           |    1 +
 arch/arm/mach-cns3xxx/core.c                       |   16 +-
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h       |   16 +-
 arch/arm/mm/dma-mapping.c                          |    5 +-
 arch/tile/kernel/setup.c                           |   25 ++-
 arch/x86/lib/usercopy_64.c                         |    4 +-
 drivers/acpi/glue.c                                |   35 ++--
 drivers/block/aoe/aoecmd.c                         |    3 +-
 drivers/block/loop.c                               |    9 +-
 drivers/block/xen-blkback/blkback.c                |   38 +++-
 drivers/block/xen-blkback/common.h                 |   25 +++
 drivers/bluetooth/ath3k.c                          |    4 +
 drivers/bluetooth/btusb.c                          |    2 +
 drivers/char/virtio_console.c                      |   22 +-
 drivers/gpu/drm/drm_edid.c                         |    3 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |    2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   11 +-
 drivers/gpu/drm/i915/intel_display.c               |   11 +-
 drivers/gpu/drm/i915/intel_dp.c                    |   14 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   10 +-
 drivers/gpu/drm/radeon/ni.c                        |   11 +-
 drivers/gpu/drm/radeon/radeon_benchmark.c          |   16 +-
 drivers/hid/hid-ids.h                              |    6 +
 drivers/hid/usbhid/hid-quirks.c                    |    2 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |    8 +-
 drivers/iommu/amd_iommu.c                          |   22 +-
 drivers/md/dm-bufio.c                              |    2 +
 drivers/md/dm-verity.c                             |   39 +++-
 drivers/net/bonding/bond_main.c                    |   97 +++------
 drivers/net/bonding/bond_sysfs.c                   |  121 ++++++-----
 drivers/net/can/sja1000/plx_pci.c                  |    4 +-
 drivers/net/can/sja1000/sja1000.c                  |    6 +-
 drivers/net/can/sja1000/sja1000.h                  |    2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e.h         |    1 -
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   19 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h  |    3 +-
 drivers/net/ethernet/broadcom/tg3.c                |   15 +-
 drivers/net/ethernet/davicom/dm9000.c              |  214 ++++++++++----------
 drivers/net/ethernet/davicom/dm9000.h              |   11 +-
 drivers/net/ethernet/marvell/sky2.c                |    2 +-
 drivers/net/ethernet/marvell/sky2.h                |    2 +-
 drivers/net/ethernet/micrel/ks8851.c               |    2 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    4 +-
 drivers/net/ethernet/sfc/bitfield.h                |   22 +-
 drivers/net/ethernet/sfc/efx.c                     |   20 +-
 drivers/net/ethernet/sfc/efx.h                     |   13 ++
 drivers/net/ethernet/sfc/falcon.c                  |    2 +
 drivers/net/ethernet/sfc/mcdi.c                    |   42 ++--
 drivers/net/ethernet/sfc/mcdi.h                    |    6 +-
 drivers/net/ethernet/sfc/net_driver.h              |    7 +-
 drivers/net/ethernet/sfc/nic.c                     |   62 +++++-
 drivers/net/ethernet/sfc/nic.h                     |    2 +
 drivers/net/ethernet/sfc/rx.c                      |   25 ++-
 drivers/net/ethernet/sfc/selftest.c                |    2 +-
 drivers/net/ethernet/sfc/siena.c                   |   17 +-
 drivers/net/ethernet/sfc/siena_sriov.c             |   13 +-
 drivers/net/ethernet/ti/cpsw.c                     |    2 +-
 drivers/net/ethernet/ti/davinci_emac.c             |    2 +-
 drivers/net/netconsole.c                           |   15 +-
 drivers/net/ppp/ppp_generic.c                      |    8 -
 drivers/net/usb/smsc75xx.c                         |   12 +-
 drivers/net/wireless/ath/ath9k/link.c              |   29 +--
 drivers/net/wireless/b43/dma.c                     |   65 ++++--
 drivers/net/wireless/b43/phy_n.c                   |    8 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c             |    9 +
 drivers/net/wireless/iwlwifi/dvm/ucode.c           |    4 +-
 drivers/net/wireless/mwifiex/join.c                |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |   89 ++++----
 drivers/net/wireless/rtlwifi/usb.c                 |    1 +
 drivers/staging/comedi/drivers/s626.c              |    2 +-
 drivers/target/iscsi/iscsi_target_auth.c           |    5 +-
 drivers/target/target_core_file.h                  |    2 +-
 drivers/tty/serial/atmel_serial.c                  |   11 +-
 drivers/tty/serial/sunsu.c                         |   21 +-
 drivers/tty/vt/vc_screen.c                         |    6 +-
 drivers/usb/class/cdc-acm.c                        |    3 +-
 drivers/usb/core/hcd-pci.c                         |   23 ++-
 drivers/usb/gadget/g_ffs.c                         |    4 +-
 drivers/usb/gadget/udc-core.c                      |    2 +-
 drivers/usb/host/ehci-sched.c                      |    2 +
 drivers/usb/host/ehci-timer.c                      |    2 +-
 drivers/usb/host/xhci-ring.c                       |   24 +--
 drivers/usb/host/xhci.c                            |    3 +-
 drivers/usb/host/xhci.h                            |    8 +-
 drivers/usb/serial/ark3116.c                       |   10 +-
 drivers/usb/serial/ch341.c                         |   11 +-
 drivers/usb/serial/cypress_m8.c                    |   14 +-
 drivers/usb/serial/f81232.c                        |    9 +-
 drivers/usb/serial/ftdi_sio.c                      |   20 +-
 drivers/usb/serial/ftdi_sio_ids.h                  |    7 +
 drivers/usb/serial/garmin_gps.c                    |    7 +-
 drivers/usb/serial/io_edgeport.c                   |   12 +-
 drivers/usb/serial/io_ti.c                         |   13 +-
 drivers/usb/serial/mct_u232.c                      |   13 +-
 drivers/usb/serial/mos7840.c                       |   16 +-
 drivers/usb/serial/oti6858.c                       |   10 +-
 drivers/usb/serial/pl2303.c                        |   11 +-
 drivers/usb/serial/quatech2.c                      |   12 +-
 drivers/usb/serial/spcp8x5.c                       |    9 +-
 drivers/usb/serial/ssu100.c                        |   12 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   10 +-
 drivers/usb/serial/usb-serial.c                    |    4 +-
 drivers/usb/storage/unusual_devs.h                 |    7 +
 drivers/vhost/net.c                                |    3 +-
 fs/block_dev.c                                     |    1 +
 fs/btrfs/extent-tree.c                             |   49 ++++-
 fs/btrfs/extent_io.c                               |   33 +++
 fs/btrfs/extent_io.h                               |    2 +
 fs/btrfs/inode.c                                   |   14 ++
 fs/btrfs/scrub.c                                   |    3 +-
 fs/btrfs/tree-log.c                                |    5 +-
 fs/cifs/asn1.c                                     |   53 +----
 fs/dcache.c                                        |   16 +-
 fs/ext4/ext4.h                                     |    6 +-
 fs/ext4/extents.c                                  |    6 +-
 fs/ext4/ialloc.c                                   |    4 +-
 fs/ext4/inode.c                                    |    3 +-
 fs/ext4/mballoc.c                                  |   12 +-
 fs/ext4/super.c                                    |    4 +-
 fs/jbd2/transaction.c                              |   15 +-
 fs/namespace.c                                     |   25 +++
 fs/nfs/blocklayout/blocklayoutdm.c                 |    4 +-
 fs/nfs/idmap.c                                     |   13 +-
 fs/nfs/nfs4proc.c                                  |   14 --
 fs/nfs/pnfs.c                                      |   54 ++++-
 fs/nfsd/nfs4xdr.c                                  |    2 +-
 fs/proc/generic.c                                  |   21 +-
 fs/proc/inode.c                                    |   11 +-
 fs/sysfs/dir.c                                     |   17 +-
 fs/udf/udf_sb.h                                    |    2 +-
 include/drm/drm_pciids.h                           |   13 +-
 include/linux/fs_struct.h                          |    2 +
 include/linux/netdevice.h                          |    2 +
 include/linux/skbuff.h                             |   13 +-
 include/linux/thermal.h                            |    2 +-
 include/linux/usb/serial.h                         |    2 +
 include/net/inet_frag.h                            |    9 +
 include/net/ip_fib.h                               |   12 +-
 include/xen/interface/io/blkif.h                   |   10 +
 ipc/mqueue.c                                       |    3 +-
 kernel/time/tick-broadcast.c                       |    3 +-
 kernel/trace/ftrace.c                              |    4 +-
 kernel/trace/trace.c                               |   61 ++++--
 kernel/trace/trace.h                               |    6 +
 kernel/trace/trace_irqsoff.c                       |   19 +-
 kernel/trace/trace_sched_wakeup.c                  |   18 +-
 kernel/user_namespace.c                            |    9 +
 mm/hugetlb.c                                       |    8 +-
 net/8021q/vlan.c                                   |   14 +-
 net/batman-adv/bat_iv_ogm.c                        |    6 +-
 net/core/dev.c                                     |    7 +-
 net/core/rtnetlink.c                               |    2 +-
 net/ipv4/inet_fragment.c                           |   20 +-
 net/ipv4/ip_fragment.c                             |   11 +-
 net/ipv4/ip_gre.c                                  |    6 +-
 net/ipv4/ip_options.c                              |    5 +-
 net/ipv4/tcp.c                                     |    2 +-
 net/ipv4/tcp_input.c                               |    7 +-
 net/ipv4/tcp_ipv4.c                                |   14 +-
 net/ipv4/tcp_output.c                              |    8 +-
 net/ipv6/addrconf.c                                |   26 +--
 net/ipv6/ip6_input.c                               |   21 ++
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   12 +-
 net/ipv6/reassembly.c                              |    8 +-
 net/ipv6/tcp_ipv6.c                                |    7 +
 net/irda/af_irda.c                                 |    6 +-
 net/l2tp/l2tp_eth.c                                |    3 +-
 net/mac80211/sta_info.c                            |   12 +-
 net/netlink/genetlink.c                            |    1 +
 net/sched/sch_fq_codel.c                           |    2 +-
 net/sched/sch_generic.c                            |    9 +-
 net/sctp/associola.c                               |    2 +-
 net/sctp/sm_statefuns.c                            |    2 +-
 net/sunrpc/sched.c                                 |    9 +-
 net/unix/af_unix.c                                 |    7 +-
 sound/pci/hda/hda_codec.c                          |    2 +-
 sound/pci/hda/patch_conexant.c                     |    8 +-
 sound/usb/mixer.c                                  |   16 +-
 180 files changed, 1542 insertions(+), 978 deletions(-)
---------------------------
Al Viro (3):
      saner proc_get_inode() calling conventions
      vt: synchronize_rcu() under spinlock is not nice...
      Nest rename_lock inside vfsmount_lock

Alan Stern (2):
      USB: EHCI: fix regression in QH unlinking
      usb: gadget: udc-core: fix a regression during gadget driver unbinding

Alex Deucher (3):
      drm/radeon: add Richland pci ids
      drm/radeon: add support for Richland APUs
      drm/radeon/benchmark: make sure bo blit copy exists before using it

Amit Shah (2):
      virtio: console: rename cvq_lock to c_ivq_lock
      virtio: console: add locking around c_ovq operations

Anatol Pomozov (1):
      loop: prevent bdev freeing while device in use

Andrzej Pietrasiewicz (1):
      usb: gadget: ffs: fix enable multiple instances

Andy Grover (1):
      target/iscsi: Fix mutual CHAP auth on big-endian arches

Ben Hutchings (14):
      sfc: Properly sync RX DMA buffer when it is not the last in the page
      sfc: Fix efx_rx_buf_offset() in the presence of swiotlb
      sfc: Correct efx_rx_buffer::page_offset when EFX_PAGE_IP_ALIGN != 0
      sfc: Detach net device when stopping queues for reconfiguration
      sfc: Only use TX push if a single descriptor is to be written
      sfc: Disable soft interrupt handling during efx_device_detach_sync()
      sfc: Really disable flow control while flushing
      sfc: Convert firmware subtypes to native byte order in efx_mcdi_get_board_cfg()
      sfc: Add parentheses around use of bitfield macro arguments
      sfc: Fix MCDI structure field lookup
      sfc: Avoid generating over-length MC_CMD_FLUSH_RX_QUEUES request
      sfc: Correctly initialise reset_method in siena_test_chip()
      sfc: Fix timekeeping in efx_mcdi_poll()
      sfc: Reset driver's MAC stats after MC reboot seen

Bing Zhao (1):
      mwifiex: fix potential out-of-boundary access to ibss rate table

CQ Tang (1):
      x86-64: Fix the failure case in copy_user_handle_tail()

Chris Mason (1):
      Btrfs: fix race between mmap writes and compression

Chris Metcalf (1):
      tile: expect new initramfs name from hypervisor file system

Cong Wang (1):
      8021q: fix a potential use-after-free

Daniel Mack (2):
      ALSA: snd-usb: mixer: propagate errors up the call chain
      ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()

Daniel Pieczko (2):
      sfc: lock TX queues when calling netif_device_detach()
      sfc: Work-around flush timeout when flushes have completed

David Vrabel (1):
      xen/blkback: correctly respond to unknown, non-native requests

David Ward (1):
      net/ipv4: Ensure that location of timestamp option is stored

Denis V. Lunev (1):
      ipv4: fix definition of FIB_TABLE_HASHSZ

Dmitry Artamonow (1):
      usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player

Dmitry Torokhov (1):
      USB: xhci - fix bit definitions for IMAN register

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't send HCMD in restart flow

Eric Dumazet (7):
      net: qdisc busylock needs lockdep annotations
      tcp: fix skb_availroom()
      tcp: dont handle MTU reduction on LISTEN socket
      net: remove a WARN_ON() in net_enable_timestamp()
      tcp: preserve ACK clocking in TSO
      aoe: reserve enough headroom on skbs
      net: add a synchronize_net() in netdev_rx_handler_unregister()

Eric Hutter (1):
      ARM: kirkwood: Fix chip-delay for GoFlex Net

Eric W. Biederman (1):
      userns: Don't allow creation if the user is chrooted

Felix Fietkau (1):
      ath9k: limit tx path hang check to normal data queues

Hannes Frederic Sowa (4):
      inet: limit length of fragment queue hash table bucket lists
      atl1e: drop pci-msi support because of packet corruption
      ipv6: don't accept multicast traffic with scope 0
      ipv6: don't accept node local multicast traffic from the wire

Hannes Reinecke (1):
      USB: xhci: correctly enable interrupts

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
      jbd2: fix use after free in jbd2_journal_dirty_metadata()
      udf: Fix bitmap overflow on large filesystems with small block size

Jeff Layton (1):
      cifs: ignore everything in SPNEGO blob after mechTypes

Jiri Kosina (1):
      HID: usbhid: fix build problem

Joerg Roedel (1):
      iommu/amd: Make sure dma_ops are set for hotplug devices

Johan Hovold (21):
      USB: cdc-acm: fix device unregistration
      USB: serial: fix interface refcounting
      USB: garmin_gps: fix memory leak on disconnect
      USB: io_ti: fix get_icount for two port adapters
      USB: serial: add modem-status-change wait queue
      USB: quatech2: fix use-after-free in TIOCMIWAIT
      USB: mos7840: fix broken TIOCMIWAIT
      USB: io_ti: fix use-after-free in TIOCMIWAIT
      USB: oti6858: fix use-after-free in TIOCMIWAIT
      USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
      USB: pl2303: fix use-after-free in TIOCMIWAIT
      USB: mos7840: fix use-after-free in TIOCMIWAIT
      USB: spcp8x5: fix use-after-free in TIOCMIWAIT
      USB: ssu100: fix use-after-free in TIOCMIWAIT
      USB: ch341: fix use-after-free in TIOCMIWAIT
      USB: io_edgeport: fix use-after-free in TIOCMIWAIT
      USB: f81232: fix use-after-free in TIOCMIWAIT
      USB: ark3116: fix use-after-free in TIOCMIWAIT
      USB: mct_u232: fix use-after-free in TIOCMIWAIT
      USB: cypress_m8: fix use-after-free in TIOCMIWAIT
      USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT

Johannes Berg (1):
      mac80211: always synchronize_net() during station removal

Josef Bacik (4):
      Btrfs: use set_nlink if our i_nlink is 0
      Btrfs: limit the global reserve to 512mb
      Btrfs: don't drop path when printing out tree errors in scrub
      Btrfs: fix space leak when we fail to reserve metadata space

Joseph CHANG (1):
      DM9000B: driver initialization upgrade

Josh Boyer (2):
      HID: usbhid: quirk for Realtek Multi-card reader
      HID: usbhid: quirk for MSI GX680R led panel

Julia Lemire (1):
      drm/mgag200: Bug fix: Modified pll algorithm for EH project

Jussi Kivilinna (1):
      rtlwifi: usb: add missing freeing of skbuff

Kees Cook (4):
      drm/i915: restrict kernel address leak in debugfs
      drm/i915: bounds check execbuffer relocation count
      tg3: fix length overflow in VPD firmware parsing
      net/irda: add missing error path release_sock call

Konstantin Holoborodko (1):
      usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD

Larry Finger (2):
      rtlwifi: rtl8192cu: Fix schedule while atomic bug splat
      rtlwifi: rtl8192cu: Fix problem that prevents reassociation

Linus Torvalds (1):
      vfs,proc: guarantee unique inodes in /proc

Luis R. Rodriguez (1):
      ath9k: avoid queueing hw check work when suspended

Mac Lin (1):
      ARM: cns3xxx: fix mapping of private memory region

Maciej Żenczykowski (1):
      bnx2x: fix occasional statistics off-by-4GB error

Marc Kleine-Budde (1):
      can: sja1000: fix define conflict on SH

Marek Lindner (1):
      batman-adv: verify tt len does not exceed packet len

Marek Szyprowski (1):
      ARM: DMA-mapping: add missing GFP_DMA flag for atomic buffer allocation

Mark Rutland (1):
      clockevents: Don't allow dummy broadcast timers

Masatake YAMATO (2):
      thermal: shorten too long mcast group name
      genetlink: trigger BUG_ON if a group name is too long

Max.Nekludov@us.elster.com (1):
      ks8851: Fix interpretation of rxlen field.

Michael S. Tsirkin (1):
      vhost/net: fix heads usage of ubuf_info

Michal Schmidt (1):
      bnx2x: add missing napi deletion in error path

Mike Marciniszyn (1):
      IPoIB: Fix send lockup due to missed TX completion

Mikulas Patocka (1):
      dm verity: avoid deadlock

Ming Lei (5):
      Bluetooth: Add support for Dell[QCA 0cf3:0036]
      Bluetooth: Add support for Dell[QCA 0cf3:817a]
      sysfs: fix race between readdir and lseek
      sysfs: handle failure path correctly for readdir()
      USB: serial: fix hang when opening port

Mirko Lindner (2):
      sky2: Receive Overflows not counted
      sky2: Threshold for Pause Packet is set wrong

Mugunthan V N (2):
      drivers: net: ethernet: davinci_emac: use netif_wake_queue() while restarting tx queue
      drivers: net: ethernet: cpsw: use netif_wake_queue() while restarting tx queue

Nicholas Bellinger (1):
      target/file: Bump FD_MAX_SECTORS to 2048 to handle 1M sized I/Os

Nithin Sujir (1):
      tg3: 5715 does not link up when autoneg off

Paul Moore (1):
      unix: fix a race condition in unix_release()

Pavel Emelyanov (1):
      skb: Propagate pfmemalloc on skb from head page only

Pawel Wieczorkiewicz (1):
      tty: atmel_serial_probe(): index of atmel_ports[] fix

Rafael J. Wysocki (1):
      ACPI: Rework acpi_get_child() to be more efficient

Rafał Miłecki (2):
      b43: N-PHY: increase initial value of "mind" in RSSI calibration
      b43: N-PHY: use more bits for offset in RSSI calibration

Soeren Moch (1):
      USB: EHCI: fix bug in iTD/siTD DMA pool allocation

Steve Glendinning (1):
      smsc75xx: fix jumbo frame support

Steven Rostedt (Red Hat) (8):
      IP_GRE: Revert "IP_GRE: Fix kernel panic in IP_GRE with GRE csum"
      ppp: Revert backport of "ppp: set qdisc_tx_busylock to avoid LOCKDEP splat"
      tracing: Fix race in snapshot swapping
      tracing: Fix free of probe entry by calling call_rcu_sched()
      tracing: Protect tracer flags with trace_types_lock
      tracing: Keep overwrite in sync between regular and snapshot buffers
      tracing: Prevent buffer overwrite disabled for latency tracers
      Linux 3.6.11.2

Takashi Iwai (4):
      ALSA: hda/cirrus - Fix the digital beep registration
      ALSA: hda - Fix typo in checking IEC958 emphasis bit
      Revert "drm/i915: try to train DP even harder"
      drm/i915: Use the fixed pixel clock for eDP in intel_dp_set_m_n()

Theodore Ts'o (2):
      ext4: use atomic64_t for the per-flexbg free_clusters count
      ext4: fix data=journal fast mount/umount hang

Tkhai Kirill (1):
      sunsu: Fix panic in case of nonexistent port at "console=ttySY" cmdline option

Torsten Duwe (2):
      KMS: fix EDID detailed timing vsync parsing
      KMS: fix EDID detailed timing frame rate

Trond Myklebust (4):
      SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queue_locked
      NFSv4: Fix the string length returned by the idmapper
      NFSv4.1: Fix a race in pNFS layoutcommit
      NFSv4.1: Always clear the NFS_INO_LAYOUTCOMMIT in layoutreturn

Veaceslav Falico (5):
      netconsole: don't call __netpoll_cleanup() while atomic
      bonding: don't call update_speed_duplex() under spinlocks
      bonding: remove already created master sysfs link on failure
      pch_gbe: fix ip_summed checksum reporting on rx
      bonding: get netdev_rx_handler_unregister out of locks

Vijay Subramanian (1):
      net: fq_codel: Fix off-by-one error

Ville Syrjälä (1):
      drm/i915: Don't clobber crtc->fb when queue_flip fails

Vivek Gautam (1):
      usb: xhci: Fix TRB transfer length macro used for Event TRB.

Vlad Yasevich (2):
      sctp: Use correct sideffect command in duplicate cookie handling
      rtnetlink: Mask the rta_type when range checking

Vladimir Davydov (1):
      mqueue: sys_mq_open: do not call mnt_drop_write() if read-only

Wanpeng Li (1):
      mm/hugetlb: fix total hugetlbfs pages count when using memory overcommit accouting

Xufeng Zhang (1):
      sctp: don't break the loop while meeting the active_path so as to find the matched transport

Yuchung Cheng (1):
      tcp: undo spurious timeout after SACK reneging

Zheng Liu (1):
      ext4: fix the wrong number of the allocated blocks in ext4_split_extent()

fanchaoting (1):
      pnfs-block: removing DM device maybe cause oops when call dev_remove

nikolay@redhat.com (2):
      bonding: fix miimon and arp_interval delayed work race conditions
      bonding: fix disabling of arp_interval and miimon

----


