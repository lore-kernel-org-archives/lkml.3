Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab3DBWOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:14:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933603Ab3DBWOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/68] 3.4.39-stable review
Date: Tue,  2 Apr 2013 15:12:49 -0700
Message-Id: <20130402221329.915209206@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.39 release.
There are 68 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Apr  4 22:12:59 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.39-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.39-rc1

Steve Glendinning <steve.glendinning@shawell.net>
    smsc75xx: fix jumbo frame support

Veaceslav Falico <vfalico@redhat.com>
    pch_gbe: fix ip_summed checksum reporting on rx

Eric Dumazet <edumazet@google.com>
    net: add a synchronize_net() in netdev_rx_handler_unregister()

Max.Nekludov@us.elster.com <Max.Nekludov@us.elster.com>
    ks8851: Fix interpretation of rxlen field.

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: don't accept node local multicast traffic from the wire

Hong Zhiguo <honkiko@gmail.com>
    ipv6: fix bad free of addrconf_init_net

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: don't accept multicast traffic with scope 0

Joseph CHANG <josright123@gmail.com>
    DM9000B: driver initialization upgrade

Hannes Frederic Sowa <hannes@stressinduktion.org>
    atl1e: drop pci-msi support because of packet corruption

Eric Dumazet <edumazet@google.com>
    aoe: reserve enough headroom on skbs

Andrey Vagin <avagin@openvz.org>
    net: fix *_DIAG_MAX constants

Mugunthan V N <mugunthanvnm@ti.com>
    drivers: net: ethernet: cpsw: use netif_wake_queue() while restarting tx queue

Mugunthan V N <mugunthanvnm@ti.com>
    drivers: net: ethernet: davinci_emac: use netif_wake_queue() while restarting tx queue

nikolay@redhat.com <nikolay@redhat.com>
    bonding: fix disabling of arp_interval and miimon

nikolay@redhat.com <nikolay@redhat.com>
    bonding: fix miimon and arp_interval delayed work race conditions

Veaceslav Falico <vfalico@redhat.com>
    bonding: remove already created master sysfs link on failure

dingtianhong <dingtianhong@huawei.com>
    af_unix: dont send SCM_CREDENTIAL when dest socket is NULL

Paul Moore <pmoore@redhat.com>
    unix: fix a race condition in unix_release()

Masatake YAMATO <yamato@redhat.com>
    thermal: shorten too long mcast group name

Cong Wang <amwang@redhat.com>
    8021q: fix a potential use-after-free

Yuchung Cheng <ycheng@google.com>
    tcp: undo spurious timeout after SACK reneging

Eric Dumazet <edumazet@google.com>
    tcp: preserve ACK clocking in TSO

Mirko Lindner <mlindner@marvell.com>
    sky2: Threshold for Pause Packet is set wrong

Mirko Lindner <mlindner@marvell.com>
    sky2: Receive Overflows not counted

Eric Dumazet <edumazet@google.com>
    net: remove a WARN_ON() in net_enable_timestamp()

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Prevent buffer overwrite disabled for latency tracers

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Protect tracer flags with trace_types_lock

Theodore Ts'o <tytso@mit.edu>
    ext4: use atomic64_t for the per-flexbg free_clusters count

Lukas Czerner <lczerner@redhat.com>
    ext4: convert number of blocks to clusters properly

Matt Fleming <matt.fleming@intel.com>
    efivars: Handle duplicate names from get_next_variable()

Matt Fleming <matt.fleming@intel.com>
    efivars: explicitly calculate length of VariableName

Josef Bacik <jbacik@fusionio.com>
    Btrfs: fix space leak when we fail to reserve metadata space

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Don't clobber crtc->fb when queue_flip fails

J. Bruce Fields <bfields@redhat.com>
    nfsd4: reject "negative" acl lengths

Mac Lin <mkl0301@gmail.com>
    ARM: cns3xxx: fix mapping of private memory region

Anatol Pomozov <anatol.pomozov@gmail.com>
    loop: prevent bdev freeing while device in use

Alan Stern <stern@rowland.harvard.edu>
    usb: gadget: udc-core: fix a regression during gadget driver unbinding

Josef Bacik <jbacik@fusionio.com>
    Btrfs: don't drop path when printing out tree errors in scrub

Josef Bacik <jbacik@fusionio.com>
    Btrfs: limit the global reserve to 512mb

Chris Mason <chris.mason@fusionio.com>
    Btrfs: fix race between mmap writes and compression

Vivek Gautam <gautam.vivek@samsung.com>
    usb: xhci: Fix TRB transfer length macro used for Event TRB.

Kees Cook <keescook@chromium.org>
    net/irda: add missing error path release_sock call

fanchaoting <fanchaoting@cn.fujitsu.com>
    pnfs-block: removing DM device maybe cause oops when call dev_remove

Bing Zhao <bzhao@marvell.com>
    mwifiex: cancel cmd timer and free curr_cmd in shutdown process

Al Viro <viro@zeniv.linux.org.uk>
    vt: synchronize_rcu() under spinlock is not nice...

Konstantin Holoborodko <klh.kernel@gmail.com>
    usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD

Pawel Wieczorkiewicz <wpawel@gmail.com>
    tty: atmel_serial_probe(): index of atmel_ports[] fix

Jan Beulich <JBeulich@suse.com>
    xen-blkback: fix dispatch_rw_block_io() error path

David Vrabel <david.vrabel@citrix.com>
    xen/blkback: correctly respond to unknown, non-native requests

Joerg Roedel <joro@8bytes.org>
    iommu/amd: Make sure dma_ops are set for hotplug devices

Kees Cook <keescook@chromium.org>
    tg3: fix length overflow in VPD firmware parsing

Rafał Miłecki <zajec5@gmail.com>
    b43: N-PHY: use more bits for offset in RSSI calibration

Iestyn C. Elfick <isedev@gmail.com>
    b43: A fix for DMA transmission sequence errors

Rafał Miłecki <zajec5@gmail.com>
    b43: N-PHY: increase initial value of "mind" in RSSI calibration

Jussi Kivilinna <jussi.kivilinna@iki.fi>
    rtlwifi: usb: add missing freeing of skbuff

Josh Boyer <jwboyer@redhat.com>
    HID: usbhid: quirk for Realtek Multi-card reader

Felix Fietkau <nbd@openwrt.org>
    ath9k_hw: revert chainmask to user configuration after calibration

Marc Kleine-Budde <mkl@pengutronix.de>
    can: sja1000: fix define conflict on SH

Ming Lei <ming.lei@canonical.com>
    sysfs: handle failure path correctly for readdir()

Ming Lei <ming.lei@canonical.com>
    sysfs: fix race between readdir and lseek

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: s626: fix continuous acquisition

Ming Lei <ming.lei@canonical.com>
    Bluetooth: Add support for Dell[QCA 0cf3:817a]

Ming Lei <ming.lei@canonical.com>
    Bluetooth: Add support for Dell[QCA 0cf3:0036]

Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
    Bluetooth: Fix not closing SCO sockets in the BT_CONNECT2 state

Chris Metcalf <cmetcalf@tilera.com>
    tile: expect new initramfs name from hypervisor file system

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queue_locked

Andrew Morton <akpm@linux-foundation.org>
    kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER

Ben Hutchings <ben@decadent.org.uk>
    signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_restorer


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/include/asm/signal.h                      |   1 +
 arch/arm/mach-cns3xxx/core.c                       |  16 +-
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h       |  16 +-
 arch/avr32/include/asm/signal.h                    |   1 +
 arch/cris/include/asm/signal.h                     |   1 +
 arch/h8300/include/asm/signal.h                    |   1 +
 arch/m32r/include/asm/signal.h                     |   1 +
 arch/m68k/include/asm/signal.h                     |   1 +
 arch/mn10300/include/asm/signal.h                  |   1 +
 arch/powerpc/include/asm/signal.h                  |   1 +
 arch/s390/include/asm/signal.h                     |   1 +
 arch/sparc/include/asm/signal.h                    |   1 +
 arch/tile/kernel/setup.c                           |  25 ++-
 arch/x86/include/asm/signal.h                      |   2 +
 arch/xtensa/include/asm/signal.h                   |   1 +
 drivers/block/aoe/aoecmd.c                         |   3 +-
 drivers/block/loop.c                               |   9 +-
 drivers/block/xen-blkback/blkback.c                |  38 +++-
 drivers/block/xen-blkback/common.h                 |  25 +++
 drivers/bluetooth/ath3k.c                          |   4 +
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/firmware/efivars.c                         |  93 ++++++++-
 drivers/gpu/drm/i915/intel_display.c               |  11 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/usbhid/hid-quirks.c                    |   1 +
 drivers/iommu/amd_iommu.c                          |  22 +--
 drivers/net/bonding/bond_main.c                    |  88 +++------
 drivers/net/bonding/bond_sysfs.c                   | 121 ++++++------
 drivers/net/can/sja1000/plx_pci.c                  |   4 +-
 drivers/net/can/sja1000/sja1000.c                  |   6 +-
 drivers/net/can/sja1000/sja1000.h                  |   2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e.h         |   1 -
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |  22 +--
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
 drivers/net/wireless/b43/dma.c                     |  65 +++++--
 drivers/net/wireless/b43/phy_n.c                   |   8 +-
 drivers/net/wireless/mwifiex/init.c                |   8 +
 drivers/net/wireless/rtlwifi/usb.c                 |   1 +
 drivers/staging/comedi/drivers/s626.c              |   2 +-
 drivers/tty/serial/atmel_serial.c                  |  11 +-
 drivers/tty/vt/vc_screen.c                         |   6 +-
 drivers/usb/gadget/udc-core.c                      |   2 +-
 drivers/usb/host/xhci-ring.c                       |  24 +--
 drivers/usb/host/xhci.h                            |   4 +
 drivers/usb/serial/ftdi_sio.c                      |   1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 fs/block_dev.c                                     |   1 +
 fs/btrfs/extent-tree.c                             |  49 ++++-
 fs/btrfs/extent_io.c                               |  33 ++++
 fs/btrfs/extent_io.h                               |   2 +
 fs/btrfs/inode.c                                   |  14 ++
 fs/btrfs/scrub.c                                   |   3 +-
 fs/ext4/balloc.c                                   |   2 +-
 fs/ext4/ext4.h                                     |   6 +-
 fs/ext4/ialloc.c                                   |   4 +-
 fs/ext4/mballoc.c                                  |  18 +-
 fs/ext4/resize.c                                   |   8 +-
 fs/ext4/super.c                                    |   4 +-
 fs/nfs/blocklayout/blocklayoutdm.c                 |   4 +-
 fs/nfsd/nfs4xdr.c                                  |   2 +-
 fs/sysfs/dir.c                                     |  17 +-
 include/asm-generic/signal.h                       |   4 +
 include/linux/thermal.h                            |   2 +-
 include/linux/unix_diag.h                          |   4 +-
 include/xen/interface/io/blkif.h                   |  10 +
 kernel/signal.c                                    |   2 +-
 kernel/trace/trace.c                               |  50 +++--
 kernel/trace/trace.h                               |   7 +
 kernel/trace/trace_irqsoff.c                       |  19 +-
 kernel/trace/trace_sched_wakeup.c                  |  18 +-
 net/8021q/vlan.c                                   |  14 +-
 net/bluetooth/sco.c                                |   1 +
 net/core/dev.c                                     |   7 +-
 net/ipv4/tcp_input.c                               |   7 +-
 net/ipv4/tcp_output.c                              |   7 +-
 net/ipv6/addrconf.c                                |  26 +--
 net/ipv6/ip6_input.c                               |  21 ++
 net/irda/af_irda.c                                 |   6 +-
 net/netlink/genetlink.c                            |   1 +
 net/sunrpc/sched.c                                 |   9 +-
 net/unix/af_unix.c                                 |  11 +-
 92 files changed, 847 insertions(+), 476 deletions(-)


