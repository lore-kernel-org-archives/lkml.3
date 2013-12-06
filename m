Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161674Ab3LFWpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:45:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab3LFVwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.12 00/83] 3.12.4-stable review
Date: Fri,  6 Dec 2013 13:50:50 -0800
Message-Id: <20131206214640.002320724@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.4 release.
There are 83 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Dec  8 21:44:41 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.12.4-rc1

Pierre Ossman <pierre@ossman.eu>
    drm/radeon/audio: correct ACR table

Pierre Ossman <pierre@ossman.eu>
    drm/radeon/audio: improve ACR calculation

Gu Zheng <guz.fnst@cn.fujitsu.com>
    aio: clean up aio ring in the fail path

Sasha Levin <sasha.levin@oracle.com>
    aio: nullify aio->ring_pages after freeing it

Sasha Levin <sasha.levin@oracle.com>
    aio: prevent double free in ioctx_alloc

Dan Carpenter <dan.carpenter@oracle.com>
    aio: checking for NULL instead of IS_ERR

Benjamin LaHaise <bcrl@kvack.org>
    rework aio migrate pages to use aio fs

Al Viro <viro@zeniv.linux.org.uk>
    take anon inode allocation to libfs.c

Kent Overstreet <kmo@daterainc.com>
    aio: Fix a trinity splat

Miroslav Lichvar <mlichvar@redhat.com>
    ntp: Make periodic RTC update more reliable

Tomoki Sekiyama <tomoki.sekiyama@hds.com>
    elevator: acquire q->sysfs_lock in elevator_change()

Tomoki Sekiyama <tomoki.sekiyama@hds.com>
    elevator: Fix a race in elevator switching and md device initialization

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2800: add support for radio chip RF3070

Neil Horman <nhorman@tuxdriver.com>
    iommu: Remove stack trace from broken irq remapping warning

Julian Stecklina <jsteckli@os.inf.tu-dresden.de>
    iommu/vt-d: Fixed interaction of VFIO_IOMMU_MAP_DMA with IOMMU address limits

Oliver Neukum <oneukum@suse.de>
    HID: hid-elo: some systems cannot stomach work around

Simon Wood <simon@mungewell.org>
    HID: lg: fix Report Descriptor for Logitech MOMO Force (Black)

Sasha Levin <sasha.levin@oracle.com>
    video: kyro: fix incorrect sizes when copying to userspace

Thomas Pugliese <thomas.pugliese@gmail.com>
    usb: wusbcore: change WA_SEGS_MAX to a legal value

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    usb: musb: davinci: fix resources passed to MUSB driver for DM6467

majianpeng <majianpeng@gmail.com>
    md/raid5: Use conf->device_lock protect changing of multi-thread resources.

Mel Gorman <mgorman@suse.de>
    mm: numa: return the number of base pages altered by protection changes

Dwight Engen <dwight.engen@oracle.com>
    xfs: add capability check to free eofblocks ioctl

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix null pointer dereference when decoding sessions

fan.du <fan.du@windriver.com>
    {pktgen, xfrm} Update IPv4 header total len and checksum after tranformation

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: fix possible seqlock deadlock in ip6_finish_output2

Eric Dumazet <edumazet@google.com>
    inet: fix possible seqlock deadlocks

Jiri Pirko <jiri@resnulli.us>
    team: fix master carrier set when user linkup is enabled

Shawn Landden <shawn@churchofgit.com>
    net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Linus Walleij <linus.walleij@linaro.org>
    net: smc91: fix crash regression on the versatile

Yang Yingliang <yangyingliang@huawei.com>
    net: 8139cp: fix a BUG_ON triggered by wrong bytes_compl

David Chang <dchang@suse.com>
    r8169: check ALDPS bit and disable it if enabled for the 8168g

Francois Romieu <romieu@fr.zoreil.com>
    via-velocity: fix netif_receive_skb use in irq disabled section.

Andy Whitcroft <apw@canonical.com>
    xen-netback: include definition of csum_ipv6_magic

Eric Dumazet <edumazet@google.com>
    sch_tbf: handle too small burst

Herbert Xu <herbert@gondor.apana.org.au>
    gro: Clean up tcpX_gro_receive checksum verification

Herbert Xu <herbert@gondor.apana.org.au>
    gro: Only verify TCP checksums for candidates

Herbert Xu <herbert@gondor.apana.org.au>
    gso: handle new frag_list of frags GRO packets

Veaceslav Falico <vfalico@redhat.com>
    af_packet: block BH in prb_shutdown_retire_blk_timer()

Daniel Borkmann <dborkman@redhat.com>
    packet: fix use after free race in send path when dev is released

Ding Tianhong <dingtianhong@huawei.com>
    bridge: flush br's address entry in fdb when remove the bridge dev

Vlad Yasevich <vyasevic@redhat.com>
    net: core: Always propagate flag changes to interfaces

Alexei Starovoitov <ast@plumgrid.com>
    ipv4: fix race in concurrent ip_route_input_slow()

Andrey Vagin <avagin@openvz.org>
    tcp: don't update snd_nxt, when a socket is switched from repair mode

Ying Xue <ying.xue@windriver.com>
    atm: idt77252: fix dev refcnt leak

fan.du <fan.du@windriver.com>
    xfrm: Release dst if this dst is improper for vti tunnel

Jiri Pirko <jiri@resnulli.us>
    netfilter: push reasm skb through instead of original frag skbs

Jiri Pirko <jiri@resnulli.us>
    ip6_output: fragment outgoing reassembled skb properly

Vlad Yasevich <vyasevich@gmail.com>
    ipv6: Fix inet6_init() cleanup order

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
    ping: prevent NULL pointer dereference on write to msg_name

Hannes Frederic Sowa <hannes@stressinduktion.org>
    inet: prevent leakage of uninitialized memory to user in recv syscalls

Eric Dumazet <edumazet@google.com>
    pkt_sched: fq: fix pacing for small frames

Eric Dumazet <edumazet@google.com>
    pkt_sched: fq: warn users using defrate

Eric Dumazet <edumazet@google.com>
    ipv4: fix possible seqlock deadlock

Chris Metcalf <cmetcalf@tilera.com>
    connector: improved unaligned access error fix

Maciej Żenczykowski <maze@google.com>
    pkt_sched: fq: change classification of control packets

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip6tnl: fix use after free of fb_tnl_dev

Dan Carpenter <dan.carpenter@oracle.com>
    isdnloop: use strlcpy() instead of strcpy()

Willem de Bruijn <willemb@google.com>
    sit: fix use after free of fb_tunnel_dev

Eric Dumazet <edumazet@google.com>
    net-tcp: fix panic in tcp_fastopen_cache_set()

Nikolay Aleksandrov <nikolay@redhat.com>
    bonding: fix two race conditions in bond_store_updelay/downdelay

Eric Dumazet <edumazet@google.com>
    tcp: tsq: restore minimal amount of queueing

Jason Wang <jasowang@redhat.com>
    macvtap: limit head length of skb allocated

Jason Wang <jasowang@redhat.com>
    tuntap: limit head length of skb allocated

Jukka Rissanen <jukka.rissanen@linux.intel.com>
    6lowpan: Uncompression of traffic class field was incorrect

Alexei Starovoitov <ast@plumgrid.com>
    core/dev: do not ignore dmac in dev_forward_skb()

Felix Fietkau <nbd@openwrt.org>
    usbnet: fix status interrupt urb handling

Veaceslav Falico <vfalico@redhat.com>
    bonding: don't permit to use ARP monitoring in 802.3ad mode

Daniel Borkmann <dborkman@redhat.com>
    random32: fix off-by-one in seeding requirement

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: protect for_each_sk_fl_rcu in mem_check with rcu_read_lock_bh

Duan Jiong <duanj.fnst@cn.fujitsu.com>
    ipv6: use rt6_get_dflt_router to get default router in rt6_route_rcv

Andreas Henriksson <andreas@fatal.se>
    net: Fix "ip rule delete table 256"

Amir Vadai <amirv@mellanox.com>
    net/mlx4_en: Fixed crash when port type is changed

Andrey Vagin <avagin@openvz.org>
    net: x86: bpf: don't forget to free sk_filter (v2)

Veaceslav Falico <vfalico@redhat.com>
    bonding: RCUify bond_set_rx_mode()

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: fix headroom calculation in udp6_ufo_fragment

Dan Carpenter <dan.carpenter@oracle.com>
    net: mv643xx_eth: potential NULL dereference in probe()

Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    net: mv643xx_eth: Add missing phy_addr_set in DT mode


-------------

Diffstat:

 Documentation/networking/ip-sysctl.txt         |   3 -
 Makefile                                       |   4 +-
 arch/x86/net/bpf_jit_comp.c                    |   2 +
 block/blk-core.c                               |  10 +-
 block/elevator.c                               |  22 ++-
 crypto/algif_hash.c                            |   5 +-
 crypto/algif_skcipher.c                        |   4 +-
 drivers/atm/idt77252.c                         |   2 +-
 drivers/connector/cn_proc.c                    |  72 +++++----
 drivers/gpu/drm/radeon/r600_hdmi.c             |  74 ++++++---
 drivers/hid/hid-elo.c                          |  35 ++++-
 drivers/hid/hid-lg.c                           |  58 +++++++
 drivers/iommu/intel-iommu.c                    |   6 +-
 drivers/iommu/intel_irq_remapping.c            |  13 +-
 drivers/isdn/isdnloop/isdnloop.c               |   8 +-
 drivers/isdn/mISDN/socket.c                    |  13 +-
 drivers/md/raid5.c                             |  63 +++++---
 drivers/net/bonding/bond_main.c                |   8 +-
 drivers/net/bonding/bond_sysfs.c               |  11 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c     |   2 +
 drivers/net/ethernet/mellanox/mlx4/en_main.c   |   8 +-
 drivers/net/ethernet/realtek/8139cp.c          |   5 +-
 drivers/net/ethernet/realtek/r8169.c           |   5 +
 drivers/net/ethernet/smsc/smc91x.h             |  22 +--
 drivers/net/ethernet/via/via-velocity.c        |  11 +-
 drivers/net/macvtap.c                          |   8 +-
 drivers/net/ppp/pppoe.c                        |   2 -
 drivers/net/team/team.c                        |   4 +
 drivers/net/tun.c                              |  10 +-
 drivers/net/usb/usbnet.c                       |   3 -
 drivers/net/wireless/rt2x00/rt2800.h           |   2 +
 drivers/net/wireless/rt2x00/rt2800lib.c        |   8 +-
 drivers/net/xen-netback/netback.c              |   1 +
 drivers/usb/musb/davinci.c                     |  11 +-
 drivers/usb/wusbcore/wa-xfer.c                 |   5 +-
 drivers/video/kyro/fbdev.c                     |   6 +-
 fs/aio.c                                       | 201 ++++++++++++++-----------
 fs/anon_inodes.c                               |  50 +-----
 fs/libfs.c                                     |  43 ++++++
 fs/xfs/xfs_ioctl.c                             |   6 +
 include/linux/fs.h                             |   1 +
 include/linux/net.h                            |   8 +
 include/linux/random.h                         |   6 +-
 include/linux/skbuff.h                         |  32 ----
 include/linux/vm_event_item.h                  |   1 +
 include/net/ip.h                               |   2 +-
 include/net/ip_vs.h                            |  32 +---
 include/net/ipv6.h                             |   6 +-
 include/net/netfilter/ipv6/nf_defrag_ipv6.h    |   5 +-
 include/net/ping.h                             |   3 +-
 include/uapi/linux/pkt_sched.h                 |   7 +-
 kernel/time/ntp.c                              |   3 +-
 lib/random32.c                                 |  14 +-
 mm/mprotect.c                                  |   7 +-
 mm/vmstat.c                                    |   1 +
 net/appletalk/ddp.c                            |  16 +-
 net/atm/common.c                               |   2 -
 net/ax25/af_ax25.c                             |   4 +-
 net/bluetooth/af_bluetooth.c                   |   4 -
 net/bluetooth/hci_sock.c                       |   2 -
 net/bluetooth/rfcomm/sock.c                    |   1 -
 net/bluetooth/sco.c                            |   1 -
 net/bridge/br_if.c                             |   2 +
 net/caif/caif_socket.c                         |   4 -
 net/compat.c                                   |   5 +-
 net/core/dev.c                                 |   8 +-
 net/core/fib_rules.c                           |   3 +-
 net/core/iovec.c                               |   3 +-
 net/core/pktgen.c                              |   7 +
 net/core/skbuff.c                              |  78 ++++++----
 net/ieee802154/6lowpan.c                       |   4 +-
 net/ieee802154/dgram.c                         |   3 +-
 net/ipv4/datagram.c                            |   2 +-
 net/ipv4/ip_sockglue.c                         |   3 +-
 net/ipv4/ip_tunnel.c                           |   4 +-
 net/ipv4/ip_vti.c                              |   1 +
 net/ipv4/ping.c                                |  56 +++----
 net/ipv4/raw.c                                 |   6 +-
 net/ipv4/route.c                               |   8 +-
 net/ipv4/tcp.c                                 |   6 -
 net/ipv4/tcp_ipv4.c                            |   2 +-
 net/ipv4/tcp_metrics.c                         |   5 +-
 net/ipv4/tcp_offload.c                         |  31 ++--
 net/ipv4/tcp_output.c                          |   7 +-
 net/ipv4/udp.c                                 |  14 +-
 net/ipv4/xfrm4_policy.c                        |   6 +-
 net/ipv6/af_inet6.c                            |   4 +-
 net/ipv6/datagram.c                            |   8 +-
 net/ipv6/ip6_flowlabel.c                       |   2 +
 net/ipv6/ip6_output.c                          |   7 +-
 net/ipv6/ip6_tunnel.c                          |  18 ++-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |  54 +------
 net/ipv6/netfilter/nf_conntrack_reasm.c        |  19 +--
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |   7 +-
 net/ipv6/ping.c                                |   3 +-
 net/ipv6/raw.c                                 |   8 +-
 net/ipv6/route.c                               |   7 +-
 net/ipv6/sit.c                                 |  18 ++-
 net/ipv6/tcpv6_offload.c                       |  32 ++--
 net/ipv6/udp.c                                 |   9 +-
 net/ipv6/udp_offload.c                         |   2 +-
 net/ipv6/xfrm6_policy.c                        |   6 +-
 net/ipx/af_ipx.c                               |   3 +-
 net/irda/af_irda.c                             |   4 -
 net/iucv/af_iucv.c                             |   2 -
 net/key/af_key.c                               |   1 -
 net/l2tp/l2tp_ip.c                             |   4 +-
 net/l2tp/l2tp_ip6.c                            |   2 +-
 net/l2tp/l2tp_ppp.c                            |   2 -
 net/llc/af_llc.c                               |   2 -
 net/netfilter/ipvs/ip_vs_core.c                |  55 +------
 net/netfilter/ipvs/ip_vs_pe_sip.c              |   8 +-
 net/netlink/af_netlink.c                       |   2 -
 net/netrom/af_netrom.c                         |   3 +-
 net/nfc/llcp_sock.c                            |   2 -
 net/nfc/rawsock.c                              |   2 -
 net/packet/af_packet.c                         |  95 ++++++------
 net/packet/internal.h                          |   1 +
 net/phonet/datagram.c                          |   9 +-
 net/rds/recv.c                                 |   2 -
 net/rose/af_rose.c                             |   8 +-
 net/rxrpc/ar-recvmsg.c                         |   9 +-
 net/sched/sch_fq.c                             |  40 ++---
 net/sched/sch_tbf.c                            |  32 +++-
 net/socket.c                                   |  24 +--
 net/tipc/socket.c                              |   6 -
 net/unix/af_unix.c                             |   5 -
 net/vmw_vsock/af_vsock.c                       |   2 -
 net/vmw_vsock/vmci_transport.c                 |   2 -
 net/x25/af_x25.c                               |   3 +-
 130 files changed, 950 insertions(+), 836 deletions(-)


