Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3C2B4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 21:56:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27624 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3C2B4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 21:56:47 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=6HR0ASlh-fi2o8upvRQA:9 a=QEXdDO2ut3YA:10 a=3vnF5rOFQgpqEbH5:21 a=STjqbcA2gLJLrqx9:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1364522205.10629.6.camel@gandalf.local.home>
Subject: Linux 3.6.11.1
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Date: Thu, 28 Mar 2013 21:56:45 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm announcing the release of the 3.6.11.1 kernel.

The updated 3.6.11.y git tree can be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git v3.6-stable

The patch can be downloaded at:
	https://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.1.xz

thanks,

-- Steve

 MAINTAINERS                                        |    6 +-
 Makefile                                           |    2 +-
 arch/sparc/Kconfig                                 |    1 +
 arch/sparc/include/asm/hugetlb.h                   |   10 +-
 arch/sparc/mm/tsb.c                                |    2 +-
 drivers/atm/iphase.h                               |  146 ++++++++++----------
 drivers/block/sunvdc.c                             |    2 +-
 drivers/isdn/gigaset/capi.c                        |    2 +
 drivers/net/ethernet/broadcom/tg3.c                |   62 ++++++---
 drivers/net/ethernet/calxeda/xgmac.c               |    4 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   13 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   11 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_init.c   |    2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    2 +
 drivers/net/ethernet/realtek/r8169.c               |    7 -
 drivers/net/ethernet/via/via-rhine.c               |    8 +-
 drivers/net/loopback.c                             |    5 +
 drivers/net/macvlan.c                              |    6 +-
 drivers/net/ppp/ppp_generic.c                      |    8 ++
 drivers/net/team/team.c                            |    2 +
 drivers/net/tun.c                                  |    2 +
 drivers/net/xen-netback/common.h                   |    3 +
 drivers/net/xen-netback/interface.c                |   26 ++--
 drivers/net/xen-netback/netback.c                  |  123 ++++++++++-------
 fs/splice.c                                        |    4 +-
 include/linux/if_vlan.h                            |    6 +-
 include/net/dst.h                                  |    8 +-
 include/net/icmp.h                                 |    1 +
 include/net/inet6_hashtables.h                     |    8 +-
 include/net/inet_connection_sock.h                 |    1 +
 include/net/inet_sock.h                            |    1 +
 include/net/ip.h                                   |    2 +
 include/net/ip6_fib.h                              |   39 ++----
 include/net/ipv6.h                                 |   12 ++
 include/net/ndisc.h                                |    7 +
 include/net/sock.h                                 |    2 +-
 net/batman-adv/bat_iv_ogm.c                        |    2 +-
 net/bridge/br_netfilter.c                          |    3 +
 net/bridge/br_stp_bpdu.c                           |    2 +
 net/core/datagram.c                                |    2 +-
 net/core/dev.c                                     |    1 +
 net/core/dst.c                                     |    1 +
 net/core/pktgen.c                                  |    9 +-
 net/core/rtnetlink.c                               |    1 +
 net/core/skbuff.c                                  |   44 ++----
 net/core/sock_diag.c                               |    3 +
 net/dcb/dcbnl.c                                    |    8 ++
 net/dccp/ipv4.c                                    |    4 +-
 net/dccp/ipv6.c                                    |    3 +-
 net/ieee802154/6lowpan.h                           |    2 +-
 net/ipv4/af_inet.c                                 |   11 +-
 net/ipv4/datagram.c                                |   25 ++++
 net/ipv4/icmp.c                                    |   23 +++
 net/ipv4/inet_connection_sock.c                    |   16 +++
 net/ipv4/ip_gre.c                                  |    6 +-
 net/ipv4/ip_sockglue.c                             |    2 +-
 net/ipv4/ping.c                                    |    5 +-
 net/ipv4/raw.c                                     |    1 +
 net/ipv4/route.c                                   |   54 +++++++-
 net/ipv4/tcp.c                                     |   27 ++--
 net/ipv4/tcp_cong.c                                |   14 +-
 net/ipv4/tcp_input.c                               |   72 ++++++----
 net/ipv4/tcp_ipv4.c                                |   15 +-
 net/ipv4/tcp_output.c                              |   18 ++-
 net/ipv4/udp.c                                     |    1 +
 net/ipv6/addrconf.c                                |    2 +-
 net/ipv6/icmp.c                                    |   12 ++
 net/ipv6/ip6_input.c                               |    3 +-
 net/ipv6/ip6_output.c                              |    4 +-
 net/ipv6/ndisc.c                                   |   17 +++
 net/ipv6/route.c                                   |   13 +-
 net/ipv6/tcp_ipv6.c                                |    3 +-
 net/ipv6/xfrm6_policy.c                            |    2 +
 net/l2tp/l2tp_ppp.c                                |    1 +
 net/mac802154/wpan.c                               |    2 +-
 net/netlabel/netlabel_unlabeled.c                  |   27 ++--
 net/packet/af_packet.c                             |   10 +-
 net/rds/message.c                                  |    3 +
 net/sched/sch_htb.c                                |    2 +-
 net/sctp/endpointola.c                             |    5 +
 net/sctp/outqueue.c                                |   12 +-
 net/sctp/probe.c                                   |    3 +-
 net/sctp/socket.c                                  |    2 +-
 84 files changed, 667 insertions(+), 379 deletions(-)
---------------------------
Akinobu Mita (1):
      batman-adv: fix random jitter calculation

Alexander Aring (1):
      mac802154: fix NOHZ local_softirq_pending 08 warning

Christoph Paasch (1):
      inet: Fix kmemleak in tcp_v4/6_syn_recv_sock and dccp_v4/6_request_recv_sock

Cong Wang (4):
      net: prevent setting ttl=0 via IP_TTL
      pktgen: correctly handle failures when adding a device
      vlan: adjust vlan_set_encap_proto() for its callers
      rds: limit the size allocated by rds_message_alloc()

Cristian Bercaru (1):
      bridging: fix rx_handlers return code

Daniel Borkmann (3):
      net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
      net: sctp: sctp_endpoint_free: zero out secret key data
      sctp: jsctp_sf_eat_sack: fix jprobes function signature mismatch

Dave Kleikamp (1):
      sparc: huge_ptep_set_* functions need to call set_huge_pte_at()

David S. Miller (4):
      via-rhine: Fix bugs in NAPI support.
      sunvdc: Fix off-by-one in generic_request().
      sparc64: Add missing HAVE_ARCH_TRANSPARENT_HUGEPAGE.
      sparc64: Fix gfp_flags setting in tsb_grow().

David Vrabel (2):
      xen-netback: correctly return errors from netbk_count_requests()
      xen-netback: cancel the credit timer when taking the vif down

Duan Jiong (1):
      ipv6: Change skb->data before using icmpv6_notify() to propagate redirect

Eric Dumazet (17):
      tcp: fix MSG_SENDPAGE_NOTLAST logic
      tcp: tcp_replace_ts_recent() should not be called from tcp_validate_incoming()
      tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation
      netxen: fix off by one bug in netxen_release_tx_buffer()
      net: loopback: fix a dst refcounting issue
      tcp: frto should not set snd_cwnd to 0
      net: fix infinite loop in __skb_recv_datagram()
      ipv6: use a stronger hash for tcp
      tun: add a missing nf_reset() in tun_net_xmit()
      macvlan: fix macvlan_get_size()
      tcp: fix incorrect LOCKDROPPEDICMPS counter
      tcp: fix an infinite loop in tcp_slow_start()
      tcp: splice: fix an infinite loop in tcp_read_sock()
      tcp: fix splice() and tcp collapsing interaction
      net: splice: avoid high order page splitting
      net: splice: fix __splice_segment()
      ppp: set qdisc_tx_busylock to avoid LOCKDEP splat

Guillaume Nault (1):
      l2tp: Restore socket refcount when sendmsg succeeds

Hannes Frederic Sowa (1):
      ipv6: stop multicast forwarding to process interface scoped addresses

Heiko Carstens (1):
      atm/iphase: rename fregt_t -> ffreg_t

Ian Campbell (3):
      xen/netback: shutdown the ring if it contains garbage.
      xen/netback: free already allocated memory on failure in xen_netbk_get_requests
      netback: correct netbk_tx_err to handle wrap around.

Ilpo Järvinen (1):
      tcp: fix for zero packets_in_flight was too broad

Kleber Sacilotto de Souza (1):
      mlx4_en: fix allocation of CPU affinity reverse-map

Li Wei (2):
      ipv4: fix a bug in ping_err().
      ipv4: fix error handling in icmp_protocol.

Lorenzo Colitti (1):
      net: ipv6: Don't purge default router if accept_ra=2

Marcelo Ricardo Leitner (1):
      ipv6: do not create neighbor entries for local delivery

Mathias Krause (3):
      sock_diag: Fix out-of-bounds access to sock_diag_handlers[]
      rtnl: fix info leak on RTM_GETLINK request for VF devices
      dcbnl: fix various netlink info leaks

Matthew Daley (1):
      xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.

Neal Cardwell (1):
      tcp: fix double-counted receiver RTT when leaving receiver fast path

Neil Horman (1):
      sctp: refactor sctp_outq_teardown to insure proper re-initalization

Nithin Nayak Sujir (2):
      tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mode
      tg3: Fix crc errors on jumbo frame receive

Or Gerlitz (1):
      net/mlx4_core: Set number of msix vectors under SRIOV mode to firmware defaults

Paul Moore (2):
      netlabel: fix build problems when CONFIG_IPV6=n
      netlabel: correctly list all the static label mappings

Phil Sutter (1):
      packet: fix leakage of tx_ring memory

Pravin B Shelar (1):
      IP_GRE: Fix kernel panic in IP_GRE with GRE csum.

Rob Herring (1):
      net: calxedaxgmac: throw away overrun frames

Romain KUNTZ (2):
      ipv6: fix header length calculation in ip6_append_data()
      xfrm: release neighbor upon dst destruction

Romain Kuntz (1):
      ipv6: fix the noflags test in addrconf_get_prefix_route

Sarveshwar Bandi (1):
      bridge: Pull ip header into skb->data before looking into ip header.

Stefan Hasko (1):
      net: sched: integer overflow fix

Steffen Klassert (6):
      ipv4: Remove output route check in ipv4_mtu
      ipv4: Don't update the pmtu on mtu locked routes
      ipv6: Add an error handler for icmp6
      ipv4: Invalidate the socket cached route on pmtu events if possible
      ipv4: Add a socket release callback for datagram sockets
      ipv4: Fix route refcount on pmtu discovery

Stephen Hemminger (2):
      MAINTAINERS: Stephen Hemminger email change
      bridge: set priority of STP packets

Steven Rostedt (Red Hat) (1):
      Linux 3.6.11.1

Tilman Schmidt (1):
      isdn/gigaset: fix zero size border case in debug dump

Timo Teräs (1):
      r8169: remove the obsolete and incorrect AMD workaround

Vlad Yasevich (2):
      macvlan: Set IFF_UNICAST_FLT flag to prevent unnecessary promisc mode.
      team: unsyc the devices addresses when port is removed

Willy Tarreau (1):
      tcp: don't abort splice() after small transfers

YOSHIFUJI Hideaki / 吉藤英明 (2):
      6lowpan: Fix endianness issue in is_addr_link_local().
      ipv6: fix race condition regarding dst->expires and dst->from.

Yan Burman (1):
      net/mlx4_en: Fix bridged vSwitch configuration for non SRIOV mode

Ying Xue (1):
      net: fix a compile error when SOCK_REFCNT_DEBUG is enabled

Yuchung Cheng (2):
      tcp: detect SYN/data drop when F-RTO is disabled
      tcp: fix SYN-data space mis-accounting

----


