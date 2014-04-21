Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaDUKY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:24:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55084 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaDUKYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:24:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.11.y.z extended stable] Linux 3.11.10.8
Date: Mon, 21 Apr 2014 11:24:25 +0100
Message-Id: <1398075866-24444-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.11.10.8 kernel.

The updated 3.11.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.11.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.11.y;a=shortlog

The diff from v3.11.10.7 is posted as a follow-up to this email.

The 3.11.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Makefile                                    |   2 +-
 arch/m68k/Kconfig                           |   1 +
 arch/s390/Kconfig                           |   1 +
 arch/sparc/Kconfig                          |   2 +-
 arch/sparc/include/asm/uaccess_64.h         |   4 +-
 arch/sparc/kernel/pci.c                     |   4 +-
 arch/sparc/kernel/process_64.c              |   4 +-
 arch/sparc/kernel/syscalls.S                |   4 +-
 arch/x86/crypto/ghash-clmulni-intel_asm.S   |  29 ------
 arch/x86/crypto/ghash-clmulni-intel_glue.c  |  14 ++-
 drivers/cpufreq/cpufreq_governor.c          |   3 +
 drivers/cpufreq/powernow-k6.c               | 147 +++++++++++++++++++++++-----
 drivers/cpuidle/driver.c                    |   3 +-
 drivers/input/mouse/cypress_ps2.c           |   1 -
 drivers/isdn/isdnloop/isdnloop.c            |  23 +++--
 drivers/net/ethernet/broadcom/tg3.c         |   5 +-
 drivers/net/usb/usbnet.c                    |  33 ++++---
 drivers/net/vxlan.c                         |   3 +
 drivers/net/xen-netback/netback.c           |   4 +-
 drivers/vhost/net.c                         |  20 +++-
 include/linux/futex.h                       |   4 +
 include/linux/usb/usbnet.h                  |   2 +-
 include/net/netfilter/nf_conntrack_extend.h |   4 +-
 include/net/sock.h                          |   5 +
 init/Kconfig                                |   7 ++
 kernel/futex.c                              |  14 ++-
 lib/nlattr.c                                |  10 +-
 net/8021q/vlan.c                            |   4 +-
 net/8021q/vlan_dev.c                        |   6 +-
 net/bridge/br_multicast.c                   |   6 ++
 net/bridge/netfilter/ebtables.c             |   5 +-
 net/core/netpoll.c                          |   2 +-
 net/core/rtnetlink.c                        |  10 +-
 net/core/sock.c                             |   5 +-
 net/ipv4/inet_fragment.c                    |   5 +-
 net/ipv4/ipmr.c                             |  13 ++-
 net/ipv4/netfilter/arp_tables.c             |   6 +-
 net/ipv4/netfilter/ip_tables.c              |   6 +-
 net/ipv4/tcp_output.c                       |  11 +++
 net/ipv6/addrconf.c                         |   5 +-
 net/ipv6/exthdrs_offload.c                  |   4 +-
 net/ipv6/icmp.c                             |   2 +-
 net/ipv6/ip6_output.c                       |  18 ++--
 net/ipv6/ip6mr.c                            |  13 ++-
 net/ipv6/mcast.c                            |  11 ++-
 net/ipv6/netfilter/ip6_tables.c             |   6 +-
 net/ipv6/ping.c                             |   4 +-
 net/ipv6/route.c                            |   2 +-
 net/netfilter/nf_conntrack_proto_dccp.c     |   6 +-
 net/rds/iw.c                                |   3 +-
 net/sctp/sm_make_chunk.c                    |   4 +-
 net/sctp/sm_statefuns.c                     |   5 -
 net/socket.c                                |   4 +
 net/unix/af_unix.c                          |  17 +++-
 security/selinux/hooks.c                    |  36 +++++--
 55 files changed, 391 insertions(+), 181 deletions(-)

Andrey Vagin (1):
      netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len

Anton Nayshtut (1):
      ipv6: Fix exthdrs offload registration.

Ard Biesheuvel (1):
      crypto: ghash-clmulni-intel - use C implementation for setkey()

Dan Carpenter (1):
      isdnloop: several buffer overflows

Daniel Borkmann (2):
      netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages
      net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk

Daniel Fu (1):
      cpuidle: Check the result of cpuidle_get_driver() against NULL

Dave Kleikamp (2):
      Revert "sparc64: Fix __copy_{to,from}_user_inatomic defines."
      sparc64: don't treat 64-bit syscall return codes as 32-bit

David S. Miller (1):
      sparc64: Make sure %pil interrupts are enabled during hypervisor yield.

David Stevens (1):
      vxlan: fix potential NULL dereference in arp_reduce()

Eric Dumazet (2):
      net: unix: non blocking recvmsg() should not return -EINTR
      tcp: tcp_release_cb() should release socket ownership

Finn Thain (1):
      m68k: Skip futex_atomic_cmpxchg_inatomic() test

Florian Westphal (1):
      inet: frag: make sure forced eviction removes all frags

Hannes Frederic Sowa (1):
      ipv6: some ipv6 statistic counters failed to disable bh

Hans de Goede (1):
      Input: cypress_ps2 - don't report as a button pads

Heiko Carstens (1):
      futex: Allow architectures to skip futex_atomic_cmpxchg_inatomic() test

Heiner Kallweit (1):
      ipv6: Avoid unnecessary temporary addresses being generated

Li RongQing (1):
      netpoll: fix the skb check in pkt_is_ns

Linus Lüssing (1):
      bridge: multicast: add sanity check for query source addresses

Luis Henriques (1):
      Linux 3.11.10.8

Matthew Leach (1):
      net: socket: error on a negative msg_namelen

Michael S. Tsirkin (2):
      vhost: fix total length when packets are too short
      vhost: validate vhost_get_vq_desc return value

Mikulas Patocka (3):
      powernow-k6: disable cache when changing frequency
      powernow-k6: correctly initialize default parameters
      powernow-k6: reorder frequencies

Nicolas Dichtel (3):
      rtnetlink: fix fdb notification flags
      ipmr: fix mfc notification flags
      ip6mr: fix mfc notification flags

Nikolay Aleksandrov (1):
      net: fix for a race condition in the inet frag code

Oliver Neukum (1):
      usbnet: include wait queue head in device structure

Pablo Neira (1):
      netlink: don't compare the nul-termination in nla_strcmp

Paul Durrant (1):
      xen-netback: remove pointless clause from if statement

Paul Gortmaker (1):
      sparc32: fix build failure for arch_jump_label_transform

Paul Moore (1):
      selinux: correctly label /proc inodes in use before the policy is loaded

Peter Boström (1):
      vlan: Set correct source MAC address with TX VLAN offload enabled

Sabrina Dubroca (1):
      ipv6: don't set DST_NOCOUNT for remotely added routes

Sasha Levin (1):
      rds: prevent dereference of a NULL device in rds_iw_laddr_check

Stephen Boyd (1):
      cpufreq: Fix timer/workqueue corruption due to double queueing

Thomas Graf (1):
      netfilter: Can't fail and free after table replacement

Vlad Yasevich (2):
      tg3: Do not include vlan acceleration features in vlan_features
      vlan: Set hard_header_len according to available acceleration

YOSHIFUJI Hideaki / 吉藤英明 (1):
      isdnloop: Validate NUL-terminated strings from user.

lucien (1):
      ipv6: ip6_append_data_mtu do not handle the mtu of the second fragment properly

oftedal (1):
      sparc: PCI: Fix incorrect address calculation of PCI Bridge windows on Simba-bridges

