Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaELBlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:41:23 -0400
Received: from 1wt.eu ([62.212.114.60]:34273 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbaELBlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:04 -0400
Message-Id: <20140512003200.615882631@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 000/143] 2.6.32.62-longterm review
Message-ID: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.62 release.
All patches will be posted as a response to this one. If anyone has any
issue with these being applied, please let me know. If anyone is a
maintainer of the proper subsystem, and wants to add a Signed-off-by: line
to the patch, please respond with it.

Responses should be made before Friday 16th 8PM UTC. Anything received
after that time might be too late. If someone wants a bit more time for
a deeper review, please let me know.

The whole patch series can be found in one patch at :
     kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.62-rc1.gz

The shortlog and diffstat are appended below.

----------

Andreas Henriksson (1):
      net: Fix "ip rule delete table 256"

Andy Honig (2):
      KVM: Improve create VCPU parameter (CVE-2013-4587)
      KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)

Ben Greear (1):
      Fix lockup related to stop_machine being stuck in __do_softirq.

Changli Gao (2):
      net: Swap ver and type in pppoe_hdr
      net: drop_monitor: fix the value of maxattr

Chris Healy (1):
      resubmit bridge: fix message_age_timer calculation

Dan Carpenter (13):
      cciss: fix info leak in cciss_ioctl32_passthru()
      cpqarray: fix info leak in ida_locked_ioctl()
      net: heap overflow in __audit_sockaddr()
      arcnet: cleanup sizeof parameter
      af_key: more info leaks in pfkey messages
      net_sched: info leak in atm_tc_dump_class()
      isdnloop: use strlcpy() instead of strcpy()
      net: clamp ->msg_namelen instead of returning an error
      isdnloop: several buffer overflows
      libertas: potential oops in debugfs
      uml: check length in exitcode_proc_write()
      xfs: underflow bug in xfs_attrlist_by_handle()
      aacraid: missing capable() check in compat ioctl

Daniel Borkmann (8):
      net: sctp: fix NULL pointer dereference in socket destruction
      packet: packet_getname_spkt: make sure string is always 0-terminated
      random32: fix off-by-one in seeding requirement
      net: llc: fix use after free in llc_ui_recvmsg
      net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode
      net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH capable
      net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk
      netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages

Dave Kleikamp (1):
      sunvnet: vnet_port_remove must call unregister_netdev

David S. Miller (1):
      net_sched: Fix stack info leak in cbq_dump_wrr().

Ding Tianhong (1):
      bridge: flush br's address entry in fdb when remove the bridge dev

Duan Jiong (1):
      ipv6: use rt6_get_dflt_router to get default router in rt6_route_rcv

Eric Dumazet (12):
      ipv6: ip6_sk_dst_check() must not assume ipv6 dst
      ipv6: tcp: fix panic in SYN processing
      tcp: must unclone packets before mangling them
      net: do not call sock_put() on TIMEWAIT sockets
      tcp: fix tcp_md5_hash_skb_data()
      ipv6: fix possible crashes in ip6_cork_release()
      ip_tunnel: fix kernel panic with icmp_dest_unreach
      neighbour: fix a race in neigh_destroy()
      vlan: fix a race in egress prio management
      tcp: cubic: fix bug in bictcp_acked()
      ipv4: fix possible seqlock deadlock
      inet: fix possible seqlock deadlocks

Fan Du (1):
      sctp: Use software crc32 checksum when xfrm transform will happen.

Florian Westphal (1):
      net: rose: restore old recvmsg behavior

Hannes Frederic Sowa (12):
      ipv6: don't stop backtracking in fib6_lookup_1 if subtree does not match
      ipv6: remove max_addresses check from ipv6_create_tempaddr
      ipv6: drop packets with multiple fragmentation headers
      inet: prevent leakage of uninitialized memory to user in recv syscalls
      net: rework recvmsg handler msg_name and msg_namelen logic
      net: add BUG_ON if kernel advertises msg_namelen > sizeof(struct sockaddr_storage)
      inet: fix addr_len/msg->msg_namelen assignment in recv_error and rxpmtu functions
      ipv6: fix leaking uninitialized port number of offender sockaddr
      ipv6: fix possible seqlock deadlock in ip6_finish_output2
      ipv6: udp packets following an UFO enqueued packet need also be handled by UFO
      inet: fix possible memory corruption with UDP_CORK and UFO
      ipv6: call udp_push_pending_frames when uncorking a socket with AF_INET pending data

Ian Abbott (1):
      staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice

Jason Wang (1):
      virtio-net: alloc big buffers also when guest can receive UFO

Jiri Bohac (2):
      ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO
      bonding: 802.3ad: make aggregator_identifier bond-private

Jitendra Bhivare (1):
      intel-iommu: Flush unmaps at domain_exit

Jonathan Salwan (1):
      drivers/cdrom/cdrom.c: use kzalloc() for failing hardware

Julian Anastasov (1):
      ipvs: fix CHECKSUM_PARTIAL for TCP, UDP

Kees Cook (9):
      block: do not pass disk names as format strings
      b43: stop format string leaking into error msgs
      HID: validate HID report id size
      HID: zeroplus: validate output report details
      HID: pantherlord: validate output report details
      HID: LG: validate HID output report details
      HID: check for NULL field when setting values
      HID: provide a helper for validating hid reports
      exec/ptrace: fix get_dumpable() incorrect tests

Krzysztof Helt (1):
      [CPUFREQ] powernow-k6: set transition latency value so ondemand governor can be used

Linus Torvalds (3):
      vm: add vm_iomap_memory() helper function
      Fix a few incorrectly checked [io_]remap_pfn_range() calls
      x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround

Liu Yu (1):
      tcp_cubic: fix the range of delayed_ack

Maciej Zenczykowski (1):
      net: fix 'ip rule' iif/oif device rename

Mahesh Rajashekhara (1):
      aacraid: prevent invalid pointer dereference

Marc Kleine-Budde (2):
      can: dev: fix nlmsg size calculation in can_get_size()
      net: vlan: fix nlmsg size calculation in vlan_get_size()

Mariusz Ceier (1):
      davinci_emac.c: Fix IFF_ALLMULTI setup

Martin Schwidefsky (1):
      s390: fix kernel crash due to linkage stack instructions

Mathias Krause (3):
      af_key: fix info leaks in notify messages
      proc connector: fix info leaks
      connector: use nlmsg_len() to check message length

Matthew Daley (2):
      floppy: ignore kernel-only members in FDRAWCMD ioctl input
      floppy: don't write kernel-only members to FDRAWCMD ioctl output

Matthew Leach (1):
      net: socket: error on a negative msg_namelen

Max Matveev (1):
      sctp: deal with multiple COOKIE_ECHO chunks

Michael Chan (1):
      tg3: Don't check undefined error bits in RXBD

Michal Tesar (1):
      sysctl net: Keep tcp_syn_retries inside the boundary

Mikulas Patocka (4):
      powernow-k6: disable cache when changing frequency
      powernow-k6: correctly initialize default parameters
      powernow-k6: reorder frequencies
      dm snapshot: fix data corruption

Neal Cardwell (2):
      inet_diag: fix inet_diag_dump_icsk() timewait socket state logic
      tcp: fix tcp_trim_head() to adjust segment count with skb MSS

Neil Horman (3):
      bonding: Fix broken promiscuity reference counting issue
      sctp: fully initialize sctp_outq in sctp_outq_init
      crypto: ansi_cprng - Fix off by one error in non-block size request

Nicolas Dichtel (2):
      af_key: initialize satype in key_notify_policy_flush()
      sctp: unbalanced rcu lock in ip_queue_xmit()

Nikola Pajkovsky (1):
      crypto: api - Fix race condition in larval lookup

Nikolay Aleksandrov (1):
      bonding: fix two race conditions in bond_store_updelay/downdelay

Nithin Sujir (1):
      tg3: Fix deadlock in tg3_change_mtu()

Pablo Neira (1):
      netlink: don't compare the nul-termination in nla_strcmp

Peter Hurley (1):
      n_tty: Fix n_tty_write crash when echoing in raw mode

Peter Korsgaard (1):
      dm9601: fix IFF_ALLMULTI handling

Ricardo Ribalda (1):
      ll_temac: Reset dma descriptors indexes on ndo_open

Roman Gushchin (1):
      net: check net.core.somaxconn sysctl values

Salam Noureddine (2):
      ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put
      ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put

Salva Peiró (3):
      farsync: fix info leak in ioctl
      wanxl: fix info leak in ioctl
      hamradio/yam: fix info leak in ioctl

Sasha Levin (3):
      net: unix: allow bind to fail on mutex lock
      rds: prevent dereference of a NULL device
      rds: prevent dereference of a NULL device in rds_iw_laddr_check

Stephen Smalley (1):
      SELinux: Fix kernel BUG on empty security contexts.

Tetsuo Handa (1):
      kernel/kmod.c: check for NULL in call_usermodehelper_exec()

Thomas Bork (1):
      scsi: fix missing include linux/types.h in scsi_netlink.h

Thomas Graf (1):
      ipv6: Don't depend on per socket memory for neighbour discovery messages

Ursula Braun (1):
      qeth: avoid buffer overflow in snmp ioctl

Vlad Yasevich (4):
      sctp: Use correct sideffect command in duplicate cookie handling
      net: dst: provide accessor function to dst->xfrm
      sctp: Perform software checksum if packet has to be fragmented.
      net: core: Always propagate flag changes to interfaces

Wenliang Fan (1):
      drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()

Willy Tarreau (2):
      Revert "x86, ptrace: fix build breakage with gcc 4.7"
      x86, ptrace: fix build breakage with gcc 4.7 (second try)

YOSHIFUJI Hideaki (1):
      isdnloop: Validate NUL-terminated strings from user.

Ying Xue (2):
      tipc: fix lockdep warning during bearer initialization
      atm: idt77252: fix dev refcnt leak

Zhu Yanjun (1):
      gianfar: disable TX vlan based on kernel 2.6.x

dingtianhong (3):
      ifb: fix rcu_sched self-detected stalls
      dummy: fix oops when loading the dummy failed
      ifb: fix oops when loading the ifb failed

fan.du (1):
      {pktgen, xfrm} Update IPv4 header total len and checksum after tranformation

stephen hemminger (2):
      htb: fix sign extension bug
      tcp_cubic: limit delayed_ack ratio to prevent divide error

------------

 arch/ia64/include/asm/processor.h         |   2 +-
 arch/s390/kernel/head64.S                 |   7 +-
 arch/um/kernel/exitcode.c                 |   4 +-
 arch/x86/include/asm/i387.h               |  13 +--
 arch/x86/include/asm/ptrace.h             |   4 -
 arch/x86/kernel/cpu/cpufreq/powernow-k6.c | 147 ++++++++++++++++++++++++------
 arch/x86/kvm/lapic.c                      |   3 +-
 crypto/ansi_cprng.c                       |   4 +-
 crypto/api.c                              |   7 +-
 drivers/atm/idt77252.c                    |   1 +
 drivers/block/cciss.c                     |   1 +
 drivers/block/cpqarray.c                  |   1 +
 drivers/block/floppy.c                    |  12 ++-
 drivers/block/nbd.c                       |   4 +-
 drivers/cdrom/cdrom.c                     |   2 +-
 drivers/char/n_tty.c                      |   2 +
 drivers/connector/cn_proc.c               |  16 ++++
 drivers/connector/connector.c             |   7 +-
 drivers/hid/hid-core.c                    |  75 ++++++++++++++-
 drivers/hid/hid-lg2ff.c                   |  19 +---
 drivers/hid/hid-lgff.c                    |  17 +---
 drivers/hid/hid-pl.c                      |  10 +-
 drivers/hid/hid-zpff.c                    |  18 +---
 drivers/isdn/isdnloop/isdnloop.c          |  31 ++++---
 drivers/isdn/mISDN/socket.c               |  13 +--
 drivers/md/dm-snap-persistent.c           |  18 ++--
 drivers/net/arcnet/arcnet.c               |   2 +-
 drivers/net/bonding/bond_3ad.c            |   6 +-
 drivers/net/bonding/bond_3ad.h            |   1 +
 drivers/net/bonding/bond_main.c           |  13 ++-
 drivers/net/bonding/bond_sysfs.c          |   6 ++
 drivers/net/can/dev.c                     |   8 +-
 drivers/net/davinci_emac.c                |   2 +-
 drivers/net/dummy.c                       |   4 +
 drivers/net/gianfar.c                     |   8 +-
 drivers/net/hamradio/hdlcdrv.c            |   2 +
 drivers/net/hamradio/yam.c                |   1 +
 drivers/net/ifb.c                         |   9 +-
 drivers/net/ll_temac_main.c               |   6 ++
 drivers/net/sunvnet.c                     |   2 +
 drivers/net/tg3.c                         |   7 +-
 drivers/net/tg3.h                         |   6 +-
 drivers/net/usb/dm9601.c                  |   2 +-
 drivers/net/virtio_net.c                  |   3 +-
 drivers/net/wan/farsync.c                 |   1 +
 drivers/net/wan/wanxl.c                   |   1 +
 drivers/net/wireless/b43/main.c           |   2 +-
 drivers/net/wireless/libertas/debugfs.c   |   6 +-
 drivers/pci/intel-iommu.c                 |   4 +
 drivers/s390/net/qeth_core_main.c         |   6 +-
 drivers/scsi/aacraid/commctrl.c           |   3 +-
 drivers/scsi/aacraid/linit.c              |   2 +
 drivers/staging/comedi/drivers/ni_65xx.c  |  25 +++--
 drivers/uio/uio.c                         |  16 +++-
 drivers/video/au1100fb.c                  |  26 +-----
 drivers/video/au1200fb.c                  |  26 +-----
 fs/exec.c                                 |   6 ++
 fs/partitions/check.c                     |   2 +-
 fs/xfs/linux-2.6/xfs_ioctl.c              |   3 +-
 fs/xfs/linux-2.6/xfs_ioctl32.c            |   4 +-
 include/linux/binfmts.h                   |   3 -
 include/linux/hid.h                       |   8 +-
 include/linux/icmpv6.h                    |   2 +
 include/linux/if_pppox.h                  |   4 +-
 include/linux/ipv6.h                      |   1 +
 include/linux/mm.h                        |   2 +
 include/linux/net.h                       |   8 ++
 include/linux/sched.h                     |   4 +
 include/linux/skbuff.h                    |  10 ++
 include/net/dst.h                         |  11 +++
 include/net/ip.h                          |   2 +-
 include/net/ipv6.h                        |   3 +-
 include/net/sctp/command.h                |   1 +
 include/net/udp.h                         |   1 +
 include/scsi/scsi_netlink.h               |   2 +-
 kernel/kmod.c                             |   4 +
 kernel/ptrace.c                           |   2 +-
 kernel/softirq.c                          |  13 ++-
 lib/nlattr.c                              |  10 +-
 lib/random32.c                            |  14 +--
 mm/memory.c                               |  47 ++++++++++
 net/8021q/vlan_dev.c                      |   7 ++
 net/8021q/vlan_netlink.c                  |   2 +-
 net/appletalk/ddp.c                       |  16 ++--
 net/atm/common.c                          |   2 -
 net/ax25/af_ax25.c                        |   4 +-
 net/bluetooth/af_bluetooth.c              |   2 -
 net/bluetooth/hci_sock.c                  |   2 -
 net/bluetooth/rfcomm/sock.c               |   3 -
 net/bridge/br_if.c                        |   2 +
 net/bridge/br_stp.c                       |   2 +-
 net/compat.c                              |   5 +-
 net/core/dev.c                            |   2 +-
 net/core/drop_monitor.c                   |   1 -
 net/core/fib_rules.c                      |  10 +-
 net/core/iovec.c                          |   3 +-
 net/core/neighbour.c                      |  12 ++-
 net/core/pktgen.c                         |   7 ++
 net/core/sysctl_net_core.c                |   7 +-
 net/ipv4/datagram.c                       |   2 +-
 net/ipv4/igmp.c                           |   4 +-
 net/ipv4/inet_diag.c                      |   4 +-
 net/ipv4/inet_hashtables.c                |   2 +-
 net/ipv4/ip_output.c                      |   4 +-
 net/ipv4/ip_sockglue.c                    |   3 +-
 net/ipv4/ipip.c                           |   2 +-
 net/ipv4/raw.c                            |   6 +-
 net/ipv4/sysctl_net_ipv4.c                |   6 +-
 net/ipv4/tcp.c                            |   6 +-
 net/ipv4/tcp_cubic.c                      |  11 ++-
 net/ipv4/tcp_ipv4.c                       |   2 +-
 net/ipv4/tcp_output.c                     |  15 +--
 net/ipv4/udp.c                            |  14 +--
 net/ipv6/addrconf.c                       |  10 +-
 net/ipv6/datagram.c                       |   4 +-
 net/ipv6/icmp.c                           |  10 +-
 net/ipv6/inet6_connection_sock.c          |   2 +-
 net/ipv6/inet6_hashtables.c               |   2 +-
 net/ipv6/ip6_fib.c                        |  16 +++-
 net/ipv6/ip6_output.c                     |  45 +++++----
 net/ipv6/mcast.c                          |   4 +-
 net/ipv6/ndisc.c                          |  16 ++--
 net/ipv6/raw.c                            |   6 +-
 net/ipv6/reassembly.c                     |   5 +
 net/ipv6/route.c                          |   7 +-
 net/ipv6/udp.c                            |  14 +--
 net/ipx/af_ipx.c                          |   3 +-
 net/irda/af_irda.c                        |   4 -
 net/iucv/af_iucv.c                        |   2 -
 net/key/af_key.c                          |   8 +-
 net/llc/af_llc.c                          |   7 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c      |  10 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c      |  10 +-
 net/netfilter/nf_conntrack_proto_dccp.c   |   6 +-
 net/netlink/af_netlink.c                  |   2 -
 net/netrom/af_netrom.c                    |   3 +-
 net/packet/af_packet.c                    |  38 ++++----
 net/phonet/datagram.c                     |   9 +-
 net/rds/ib.c                              |   3 +-
 net/rds/iw.c                              |   3 +-
 net/rds/recv.c                            |   2 -
 net/rose/af_rose.c                        |  24 ++---
 net/rxrpc/ar-recvmsg.c                    |   8 +-
 net/sched/sch_atm.c                       |   1 +
 net/sched/sch_cbq.c                       |   1 +
 net/sched/sch_htb.c                       |   2 +-
 net/sctp/output.c                         |   3 +-
 net/sctp/outqueue.c                       |   8 +-
 net/sctp/sm_make_chunk.c                  |   4 +-
 net/sctp/sm_sideeffect.c                  |   5 +
 net/sctp/sm_statefuns.c                   |  19 +++-
 net/sctp/socket.c                         |  47 ++++++++--
 net/socket.c                              |  40 ++++++--
 net/tipc/eth_media.c                      |  15 ++-
 net/tipc/socket.c                         |   6 --
 net/unix/af_unix.c                        |  13 ++-
 net/x25/af_x25.c                          |   3 +-
 security/selinux/ss/services.c            |   4 +
 virt/kvm/kvm_main.c                       |   3 +
 159 files changed, 937 insertions(+), 501 deletions(-)


