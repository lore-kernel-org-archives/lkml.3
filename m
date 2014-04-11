Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423269AbaDKRBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:01:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550AbaDKQIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.13 00/65] 3.13.10-stable review
Date: Fri, 11 Apr 2014 09:10:32 -0700
Message-Id: <20140411160957.714773410@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------------------
NOTE

This is probably going to be the last 3.13.y kernel release.  There
_might_ be one more after this, but given my travel schedule for the
next few weeks, don't count on it.  Please move to the 3.14 kernel tree
as soon as possible.

------------------------

This is the start of the stable review cycle for the 3.13.10 release.
There are 65 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Apr 13 16:09:42 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.10-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.13.10-rc1

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: ghash-clmulni-intel - use C implementation for setkey()

Finn Thain <fthain@telegraphics.com.au>
    m68k: Skip futex_atomic_cmpxchg_inatomic() test

Heiko Carstens <heiko.carstens@de.ibm.com>
    futex: Allow architectures to skip futex_atomic_cmpxchg_inatomic() test

Vineet Gupta <vgupta@synopsys.com>
    ARC: [nsimosci] Unbork console

Mischa Jonker <mjonker@synopsys.com>
    ARC: [nsimosci] Change .dts to use generic 8250 UART

Mikulas Patocka <mpatocka@redhat.com>
    powernow-k6: reorder frequencies

Mikulas Patocka <mpatocka@redhat.com>
    powernow-k6: correctly initialize default parameters

Mikulas Patocka <mpatocka@redhat.com>
    powernow-k6: disable cache when changing frequency

Sasha Levin <sasha.levin@oracle.com>
    rds: prevent dereference of a NULL device in rds_iw_laddr_check

Dan Carpenter <dan.carpenter@oracle.com>
    isdnloop: several buffer overflows

YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    isdnloop: Validate NUL-terminated strings from user.

Mike Rapoport <mike.rapoport@ravellosystems.com>
    net: vxlan: fix crash when interface is created with no group

Daniel Pieczko <dpieczko@solarflare.com>
    Call efx_set_channels() before efx->type->dimension_resources()

Wei Liu <wei.liu2@citrix.com>
    xen-netback: disable rogue vif in kthread context

Pablo Neira <pablo@netfilter.org>
    netlink: don't compare the nul-termination in nla_strcmp

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: some ipv6 statistic counters failed to disable bh

Paul Durrant <Paul.Durrant@citrix.com>
    xen-netback: remove pointless clause from if statement

Eric Dumazet <edumazet@google.com>
    tcp: fix get_timewait4_sock() delay computation on 64bit

Michael S. Tsirkin <mst@redhat.com>
    vhost: validate vhost_get_vq_desc return value

Michael S. Tsirkin <mst@redhat.com>
    vhost: fix total length when packets are too short

Vlad Yasevich <vyasevic@redhat.com>
    vlan: Set hard_header_len according to available acceleration

Oliver Neukum <oneukum@suse.de>
    usbnet: include wait queue head in device structure

Jason Wang <jasowang@redhat.com>
    virtio-net: correct error handling of virtqueue_kick()

Vlad Yasevich <vyasevic@redhat.com>
    tg3: Do not include vlan acceleration features in vlan_features

Pravin B Shelar <pshelar@nicira.com>
    ip_tunnel: Fix dst ref-count.

Erik Hugne <erik.hugne@ericsson.com>
    tipc: fix spinlock recursion bug for failed subscriptions

Li RongQing <roy.qing.li@gmail.com>
    netpoll: fix the skb check in pkt_is_ns

Nishanth Menon <nm@ti.com>
    net: micrel : ks8851-ml: add vdd-supply support

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip6mr: fix mfc notification flags

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipmr: fix mfc notification flags

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    rtnetlink: fix fdb notification flags

Eric Dumazet <edumazet@google.com>
    tcp: syncookies: do not use getnstimeofday()

David Stevens <dlstevens@us.ibm.com>
    vxlan: fix nonfunctional neigh_reduce()

David Stevens <dlstevens@us.ibm.com>
    vxlan: fix potential NULL dereference in arp_reduce()

Bjørn Mork <bjorn@mork.no>
    net: cdc_ncm: fix control message ordering

lucien <lucien.xin@gmail.com>
    ipv6: ip6_append_data_mtu do not handle the mtu of the second fragment properly

Heiner Kallweit <heiner.kallweit@web.de>
    ipv6: Avoid unnecessary temporary addresses being generated

Stefan Wahren <stefan.wahren@i2se.com>
    eth: fec: Fix lost promiscuous mode after reconnecting cable

dingtianhong <dingtianhong@huawei.com>
    bonding: set correct vlan id for alb xmit path

Matthew Leach <matthew.leach@arm.com>
    net: socket: error on a negative msg_namelen

Linus Lüssing <linus.luessing@web.de>
    bridge: multicast: enable snooping on general queries only

Linus Lüssing <linus.luessing@web.de>
    bridge: multicast: add sanity check for general query destination

Eric Dumazet <eric.dumazet@gmail.com>
    tcp: tcp_release_cb() should release socket ownership

Michael S. Tsirkin <mst@redhat.com>
    skbuff: skb_segment: orphan frags before copying

Michael S. Tsirkin <mst@redhat.com>
    skbuff: skb_segment: s/fskb/list_skb/

Michael S. Tsirkin <mst@redhat.com>
    skbuff: skb_segment: s/skb/head_skb/

Michael S. Tsirkin <mst@redhat.com>
    skbuff: skb_segment: s/skb_frag/frag/

Michael S. Tsirkin <mst@redhat.com>
    skbuff: skb_segment: s/frag/nskb_frag/

Peter Boström <peter.bostrom@netrounds.com>
    vlan: Set correct source MAC address with TX VLAN offload enabled

Annie Li <annie.li@oracle.com>
    Xen-netback: Fix issue caused by using gso_type wrongly

Eric Dumazet <edumazet@google.com>
    pkt_sched: fq: do not hold qdisc lock while allocating memory

Michael Chan <mchan@broadcom.com>
    bnx2: Fix shutdown sequence

Sabrina Dubroca <sd@queasysnail.net>
    ipv6: don't set DST_NOCOUNT for remotely added routes

Anton Nayshtut <anton@swortex.com>
    ipv6: Fix exthdrs offload registration.

Eric Dumazet <edumazet@google.com>
    net: unix: non blocking recvmsg() should not return -EINTR

Florian Westphal <fw@strlen.de>
    inet: frag: make sure forced eviction removes all frags

Erik Hugne <erik.hugne@ericsson.com>
    tipc: don't log disabled tasklet handler errors

Erik Hugne <erik.hugne@ericsson.com>
    tipc: fix memory leak during module removal

Erik Hugne <erik.hugne@ericsson.com>
    tipc: drop subscriber connection id invalidation

Ying Xue <ying.xue@windriver.com>
    tipc: fix connection refcount leak

Ying Xue <ying.xue@windriver.com>
    tipc: allow connection shutdown callback to be invoked in advance

Linus Lüssing <linus.luessing@web.de>
    bridge: multicast: add sanity check for query source addresses

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk

Nikolay Aleksandrov <nikolay@redhat.com>
    net: fix for a race condition in the inet frag code

Paul Moore <pmoore@redhat.com>
    selinux: correctly label /proc inodes in use before the policy is loaded


-------------

Diffstat:

 .../devicetree/bindings/net/micrel-ks8851.txt      |   1 +
 Makefile                                           |   4 +-
 arch/arc/boot/dts/nsimosci.dts                     |  12 +-
 arch/arc/configs/nsimosci_defconfig                |   1 +
 arch/m68k/Kconfig                                  |   1 +
 arch/s390/Kconfig                                  |   1 +
 arch/x86/crypto/ghash-clmulni-intel_asm.S          |  29 ----
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |  14 +-
 drivers/cpufreq/powernow-k6.c                      | 147 +++++++++++++++++----
 drivers/isdn/isdnloop/isdnloop.c                   |  23 ++--
 drivers/net/bonding/bond_alb.c                     |   2 +-
 drivers/net/ethernet/broadcom/bnx2.c               |  37 +++++-
 drivers/net/ethernet/broadcom/bnx2.h               |   5 +
 drivers/net/ethernet/broadcom/tg3.c                |   5 +-
 drivers/net/ethernet/freescale/fec_main.c          |  14 +-
 drivers/net/ethernet/micrel/ks8851.c               |  30 ++++-
 drivers/net/ethernet/sfc/ef10.c                    |   7 +
 drivers/net/ethernet/sfc/efx.c                     |   3 +-
 drivers/net/usb/cdc_ncm.c                          |  48 ++++---
 drivers/net/usb/usbnet.c                           |  33 +++--
 drivers/net/virtio_net.c                           |   6 +-
 drivers/net/vxlan.c                                | 136 ++++++++++++++++---
 drivers/net/xen-netback/common.h                   |   5 +
 drivers/net/xen-netback/interface.c                |  11 ++
 drivers/net/xen-netback/netback.c                  |  54 ++++----
 drivers/vhost/net.c                                |  20 ++-
 include/linux/futex.h                              |   4 +
 include/linux/usb/cdc_ncm.h                        |   1 +
 include/linux/usb/usbnet.h                         |   2 +-
 include/net/sock.h                                 |   5 +
 include/net/tcp.h                                  |  11 +-
 init/Kconfig                                       |   7 +
 kernel/futex.c                                     |  14 +-
 lib/nlattr.c                                       |  10 +-
 net/8021q/vlan.c                                   |   4 +-
 net/8021q/vlan_dev.c                               |   6 +-
 net/bridge/br_multicast.c                          |  33 ++++-
 net/core/netpoll.c                                 |   2 +-
 net/core/rtnetlink.c                               |  10 +-
 net/core/skbuff.c                                  | 105 ++++++++-------
 net/core/sock.c                                    |   5 +-
 net/ipv4/gre_demux.c                               |   8 ++
 net/ipv4/inet_fragment.c                           |   5 +-
 net/ipv4/ip_tunnel.c                               |   3 -
 net/ipv4/ip_tunnel_core.c                          |   1 +
 net/ipv4/ipmr.c                                    |  13 +-
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv4/tcp_output.c                              |  11 ++
 net/ipv6/addrconf.c                                |   5 +-
 net/ipv6/exthdrs_offload.c                         |   4 +-
 net/ipv6/icmp.c                                    |   2 +-
 net/ipv6/ip6_output.c                              |  18 ++-
 net/ipv6/ip6mr.c                                   |  13 +-
 net/ipv6/mcast.c                                   |  11 +-
 net/ipv6/ping.c                                    |   4 +-
 net/ipv6/route.c                                   |   2 +-
 net/rds/iw.c                                       |   3 +-
 net/sched/sch_fq.c                                 |  28 ++--
 net/sctp/sm_make_chunk.c                           |   4 +-
 net/sctp/sm_statefuns.c                            |   5 -
 net/socket.c                                       |   4 +
 net/tipc/config.c                                  |   9 +-
 net/tipc/handler.c                                 |   1 -
 net/tipc/name_table.c                              |  37 +++++-
 net/tipc/server.c                                  |  14 +-
 net/tipc/subscr.c                                  |  48 +++----
 net/unix/af_unix.c                                 |  17 ++-
 security/selinux/hooks.c                           |  36 +++--
 68 files changed, 815 insertions(+), 361 deletions(-)


