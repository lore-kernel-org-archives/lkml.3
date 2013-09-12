Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3ILS2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:28:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3ILR7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/46] 3.10.12-stable review
Date: Thu, 12 Sep 2013 10:58:11 -0700
Message-Id: <20130912175721.001906199@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.12 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Sep 14 17:56:26 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.12-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.12-rc1

Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
    ARM: at91: dt: sam9260: add i2c gpio pinctrl

Bing Zhao <bzhao@marvell.com>
    mwifiex: do not create AP and P2P interfaces upon driver loading

Sangjung Woo <sangjung.woo@samsung.com>
    drivers/rtc/rtc-max77686.c: Fix wrong register

John Haxby <john.haxby@oracle.com>
    crypto: xor - Check for osxsave as well as avx in crypto/xor

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    net: mvneta: properly disable HW PHY polling and ensure adjust_link() works

Daniel Borkmann <dborkman@redhat.com>
    net: ipv6: tcp: fix potential use after free in tcp_v6_do_rcv

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: fix null pointer dereference in __ip6addrlbl_add

Jason Wang <jasowang@redhat.com>
    vhost_net: poll vhost queue after marking DMA is done

Nithin Sujir <nsujir@broadcom.com>
    tg3: Don't turn off led on 5719 serdes port 0

Jiri Bohac <jbohac@suse.cz>
    ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO

Daniel Borkmann <dborkman@redhat.com>
    net: bridge: convert MLDv2 Query MRC into msecs_to_jiffies for max_delay

Eric Dumazet <edumazet@google.com>
    net: revert 8728c544a9c ("net: dev_pick_tx() fix")

Erik Hugne <erik.hugne@ericsson.com>
    tipc: set sk_err correctly when connection fails

Phil Oester <kernel@linuxace.com>
    tcp: tcp_make_synack() should use sock_wmalloc

Thomas Graf <tgraf@suug.ch>
    ipv6: Don't depend on per socket memory for neighbour discovery messages

Chris Clark <chris.clark@alcatel-lucent.com>
    ipv4: sendto/hdrincl: don't use destination address found in header

Andrew Vagin <avagin@openvz.org>
    tcp: don't apply tsoffset if rcv_tsecr is zero

Andrew Vagin <avagin@openvz.org>
    tcp: initialize rcv_tstamp for restored sockets

Rob Gardner <robmatic@gmail.com>
    net: usb: Add HP hs2434 device to ZLP exception table

Sathya Perla <sathya.perla@emulex.com>
    be2net: fix disabling TX in be_close()

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Fix lookup of default RX MAC filters when steered using ethtool

Jesper Dangaard Brouer <brouer@redhat.com>
    net_sched: restore "linklayer atm" handling

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
    bridge: Use the correct bit length for bitmap functions in the VLAN code

Willem de Bruijn <willemb@google.com>
    packet: restore packet statistics tp_packets to include drops

Andrey Vagin <avagin@openvz.org>
    tcp: set timestamps for restored skb-s

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: drop packets with multiple fragmentation headers

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: remove max_addresses check from ipv6_create_tempaddr

Dan Carpenter <dan.carpenter@oracle.com>
    tun: signedness bug in tun_get_user()

Asbjoern Sloth Toennesen <ast@fiberby.net>
    rtnetlink: rtnl_bridge_getlink: Call nlmsg_find_attr() with ifinfomsg header

Pravin B Shelar <pshelar@nicira.com>
    ip_tunnel: Do not use inner ip-header-id for tunnel ip-header-id.

Pravin B Shelar <pshelar@nicira.com>
    genl: Hold reference on correct module while netlink-dump.

Pravin B Shelar <pshelar@nicira.com>
    genl: Fix genl dumpit() locking.

Sridhar Samudrala <sri@us.ibm.com>
    rtnetlink: Fix inverted check in ndo_dflt_fdb_del()

Dave Jones <davej@redhat.com>
    8139cp: Fix skb leak in rx_status_loop failure path.

Timo Teräs <timo.teras@iki.fi>
    ip_gre: fix ipgre_header to return correct offset MIME-Version: 1.0

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: don't stop backtracking in fib6_lookup_1 if subtree does not match

Eric Dumazet <edumazet@google.com>
    tcp: cubic: fix bug in bictcp_acked()

Eric Dumazet <edumazet@google.com>
    tcp: cubic: fix overflow error in bictcp_update()

Linus Lüssing <linus.luessing@web.de>
    bridge: don't try to update timers in case of broken MLD queries

Eric Dumazet <edumazet@google.com>
    fib_trie: remove potential out of bound access

Veaceslav Falico <vfalico@redhat.com>
    bonding: modify only neigh_parms owned by us

Veaceslav Falico <vfalico@redhat.com>
    neighbour: populate neigh_parms on alloc before calling ndo_neigh_setup

Michael S. Tsirkin <mst@redhat.com>
    macvlan: validate flags

Roman Gushchin <klamm@yandex-team.ru>
    net: check net.core.somaxconn sysctl values

Daniel Borkmann <dborkman@redhat.com>
    net: rtm_to_ifaddr: free ifa if ifa_cacheinfo processing fails

stephen hemminger <stephen@networkplumber.org>
    htb: fix sign extension bug


-------------

Diffstat:

 Makefile                                    |  4 +-
 arch/arm/boot/dts/at91sam9260.dtsi          | 10 +++++
 arch/x86/include/asm/xor_avx.h              |  4 +-
 drivers/net/bonding/bond_main.c             |  8 +++-
 drivers/net/ethernet/broadcom/tg3.c         | 18 +++++++-
 drivers/net/ethernet/emulex/benet/be_main.c |  2 +-
 drivers/net/ethernet/marvell/mvneta.c       | 13 +++++-
 drivers/net/ethernet/realtek/8139cp.c       |  1 +
 drivers/net/ethernet/sfc/filter.c           |  2 +-
 drivers/net/macvlan.c                       |  4 ++
 drivers/net/tun.c                           |  6 ++-
 drivers/net/usb/cdc_mbim.c                  |  4 ++
 drivers/net/vxlan.c                         |  2 +-
 drivers/net/wireless/mwifiex/main.c         | 14 ------
 drivers/rtc/rtc-max77686.c                  |  4 +-
 drivers/vhost/net.c                         |  9 ++--
 include/linux/ipv6.h                        |  1 +
 include/net/genetlink.h                     | 20 ++++++++-
 include/net/ip_tunnels.h                    | 14 ------
 include/net/sch_generic.h                   |  9 +++-
 include/uapi/linux/icmpv6.h                 |  2 +
 include/uapi/linux/pkt_sched.h              | 10 ++++-
 net/bridge/br_fdb.c                         | 10 ++---
 net/bridge/br_multicast.c                   |  5 ++-
 net/bridge/br_netlink.c                     |  4 +-
 net/bridge/br_vlan.c                        |  4 +-
 net/core/flow_dissector.c                   | 11 ++---
 net/core/neighbour.c                        | 10 +++--
 net/core/rtnetlink.c                        |  4 +-
 net/core/sysctl_net_core.c                  |  6 ++-
 net/ipv4/devinet.c                          |  4 +-
 net/ipv4/fib_trie.c                         |  5 +--
 net/ipv4/ip_gre.c                           |  2 +-
 net/ipv4/ip_tunnel.c                        |  2 +-
 net/ipv4/raw.c                              |  3 +-
 net/ipv4/tcp.c                              |  7 +++
 net/ipv4/tcp_cubic.c                        | 12 +++---
 net/ipv4/tcp_input.c                        |  9 ++--
 net/ipv4/tcp_output.c                       |  4 +-
 net/ipv6/addrconf.c                         | 10 ++---
 net/ipv6/addrlabel.c                        | 48 ++++++++++-----------
 net/ipv6/icmp.c                             | 10 ++++-
 net/ipv6/ip6_fib.c                          | 16 +++++--
 net/ipv6/ndisc.c                            | 14 +++---
 net/ipv6/reassembly.c                       |  5 +++
 net/ipv6/tcp_ipv6.c                         |  2 +-
 net/netlink/genetlink.c                     | 67 +++++++++++++++++++++++------
 net/packet/af_packet.c                      |  2 +
 net/sched/sch_api.c                         | 41 ++++++++++++++++++
 net/sched/sch_generic.c                     |  1 +
 net/sched/sch_htb.c                         | 15 ++++++-
 net/tipc/socket.c                           |  4 +-
 52 files changed, 346 insertions(+), 152 deletions(-)


