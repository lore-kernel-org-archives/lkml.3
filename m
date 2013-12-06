Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161336Ab3LFWDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:03:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758832Ab3LFVyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:54:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/32] 3.4.73-stable review
Date: Fri,  6 Dec 2013 13:52:10 -0800
Message-Id: <20131206214956.830407026@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.73 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Dec  8 21:49:13 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.73-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.73-rc1

Mikulas Patocka <mpatocka@redhat.com>
    blk-core: Fix memory corruption if blkcg_init_queue fails

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix truncated status strings

Tomoki Sekiyama <tomoki.sekiyama@hds.com>
    elevator: acquire q->sysfs_lock in elevator_change()

Julian Stecklina <jsteckli@os.inf.tu-dresden.de>
    iommu/vt-d: Fixed interaction of VFIO_IOMMU_MAP_DMA with IOMMU address limits

Sasha Levin <sasha.levin@oracle.com>
    video: kyro: fix incorrect sizes when copying to userspace

Stanislav Kinsbursky <skinsbursky@parallels.com>
    nfsd: use "init_net" for portmapper

KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
    mmc: block: fix a bug of error handling in MMC driver

Kees Cook <keescook@chromium.org>
    HID: picolcd_core: validate output report details

fan.du <fan.du@windriver.com>
    {pktgen, xfrm} Update IPv4 header total len and checksum after tranformation

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: fix possible seqlock deadlock in ip6_finish_output2

Eric Dumazet <edumazet@google.com>
    inet: fix possible seqlock deadlocks

Shawn Landden <shawn@churchofgit.com>
    net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Veaceslav Falico <vfalico@redhat.com>
    af_packet: block BH in prb_shutdown_retire_blk_timer()

Daniel Borkmann <dborkman@redhat.com>
    packet: fix use after free race in send path when dev is released

Ding Tianhong <dingtianhong@huawei.com>
    bridge: flush br's address entry in fdb when remove the bridge dev

Vlad Yasevich <vyasevic@redhat.com>
    net: core: Always propagate flag changes to interfaces

Ying Xue <ying.xue@windriver.com>
    atm: idt77252: fix dev refcnt leak

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: fix leaking uninitialized port number of offender sockaddr

Dan Carpenter <dan.carpenter@oracle.com>
    net: clamp ->msg_namelen instead of returning an error

Hannes Frederic Sowa <hannes@stressinduktion.org>
    inet: fix addr_len/msg->msg_namelen assignment in recv_error and rxpmtu functions

Hannes Frederic Sowa <hannes@stressinduktion.org>
    net: add BUG_ON if kernel advertises msg_namelen > sizeof(struct sockaddr_storage)

Hannes Frederic Sowa <hannes@stressinduktion.org>
    net: rework recvmsg handler msg_name and msg_namelen logic

Hannes Frederic Sowa <hannes@stressinduktion.org>
    inet: prevent leakage of uninitialized memory to user in recv syscalls

Eric Dumazet <edumazet@google.com>
    ipv4: fix possible seqlock deadlock

Chris Metcalf <cmetcalf@tilera.com>
    connector: improved unaligned access error fix

Dan Carpenter <dan.carpenter@oracle.com>
    isdnloop: use strlcpy() instead of strcpy()

Nikolay Aleksandrov <nikolay@redhat.com>
    bonding: fix two race conditions in bond_store_updelay/downdelay

Jukka Rissanen <jukka.rissanen@linux.intel.com>
    6lowpan: Uncompression of traffic class field was incorrect

Veaceslav Falico <vfalico@redhat.com>
    bonding: don't permit to use ARP monitoring in 802.3ad mode

Daniel Borkmann <dborkman@redhat.com>
    random32: fix off-by-one in seeding requirement

Duan Jiong <duanj.fnst@cn.fujitsu.com>
    ipv6: use rt6_get_dflt_router to get default router in rt6_route_rcv

Andreas Henriksson <andreas@fatal.se>
    net: Fix "ip rule delete table 256"


-------------

Diffstat:

 Makefile                         |  4 +-
 block/blk-core.c                 |  4 +-
 block/elevator.c                 | 16 ++++++-
 crypto/algif_hash.c              |  5 ++-
 crypto/algif_skcipher.c          |  4 +-
 drivers/atm/idt77252.c           |  2 +-
 drivers/connector/cn_proc.c      | 66 ++++++++++++++++-----------
 drivers/hid/hid-picolcd.c        |  2 +-
 drivers/iommu/intel-iommu.c      |  6 ++-
 drivers/isdn/isdnloop/isdnloop.c |  8 ++--
 drivers/isdn/mISDN/socket.c      | 13 ++----
 drivers/md/dm-crypt.c            | 37 ++++------------
 drivers/md/dm-delay.c            |  6 +--
 drivers/md/dm-flakey.c           |  5 +--
 drivers/md/dm-ioctl.c            | 18 +++++---
 drivers/md/dm-linear.c           |  5 +--
 drivers/md/dm-mpath.c            |  6 +--
 drivers/md/dm-raid.c             |  6 +--
 drivers/md/dm-raid1.c            |  6 +--
 drivers/md/dm-snap.c             | 12 ++---
 drivers/md/dm-stripe.c           |  5 +--
 drivers/md/dm-thin.c             | 74 +++++++++++++++++++------------
 drivers/md/dm-verity.c           |  6 +--
 drivers/mmc/card/block.c         | 47 ++++++++++++++++++--
 drivers/net/bonding/bond_sysfs.c | 11 ++++-
 drivers/net/ppp/pppoe.c          |  2 -
 drivers/video/kyro/fbdev.c       |  6 +--
 fs/nfsd/nfssvc.c                 |  3 +-
 include/linux/device-mapper.h    |  4 +-
 include/linux/net.h              |  8 ++++
 include/linux/random.h           |  6 +--
 include/net/ip.h                 |  2 +-
 include/net/ipv6.h               |  6 ++-
 lib/random32.c                   | 14 +++---
 net/appletalk/ddp.c              | 16 +++----
 net/atm/common.c                 |  2 -
 net/ax25/af_ax25.c               |  4 +-
 net/bluetooth/af_bluetooth.c     |  4 --
 net/bluetooth/hci_sock.c         |  2 -
 net/bluetooth/rfcomm/sock.c      |  1 -
 net/bridge/br_if.c               |  2 +
 net/caif/caif_socket.c           |  4 --
 net/compat.c                     |  5 ++-
 net/core/dev.c                   |  2 +-
 net/core/fib_rules.c             |  3 +-
 net/core/iovec.c                 |  3 +-
 net/core/pktgen.c                |  7 +++
 net/ieee802154/6lowpan.c         |  4 +-
 net/ipv4/datagram.c              |  2 +-
 net/ipv4/ip_sockglue.c           |  3 +-
 net/ipv4/ping.c                  | 13 +++---
 net/ipv4/raw.c                   |  6 +--
 net/ipv4/tcp_ipv4.c              |  2 +-
 net/ipv4/udp.c                   | 14 +++---
 net/ipv6/datagram.c              |  8 +++-
 net/ipv6/ip6_output.c            |  4 +-
 net/ipv6/raw.c                   |  8 ++--
 net/ipv6/route.c                 |  7 ++-
 net/ipv6/udp.c                   |  9 ++--
 net/ipx/af_ipx.c                 |  3 +-
 net/irda/af_irda.c               |  4 --
 net/iucv/af_iucv.c               |  2 -
 net/key/af_key.c                 |  1 -
 net/l2tp/l2tp_ip.c               |  4 +-
 net/l2tp/l2tp_ppp.c              |  2 -
 net/llc/af_llc.c                 |  2 -
 net/netlink/af_netlink.c         |  2 -
 net/netrom/af_netrom.c           |  3 +-
 net/nfc/rawsock.c                |  2 -
 net/packet/af_packet.c           | 96 ++++++++++++++++++++++------------------
 net/phonet/datagram.c            |  9 ++--
 net/rds/recv.c                   |  2 -
 net/rose/af_rose.c               |  8 ++--
 net/rxrpc/ar-recvmsg.c           |  9 ++--
 net/socket.c                     | 24 +++++-----
 net/tipc/socket.c                |  6 ---
 net/unix/af_unix.c               |  5 ---
 net/x25/af_x25.c                 |  3 +-
 78 files changed, 399 insertions(+), 348 deletions(-)


