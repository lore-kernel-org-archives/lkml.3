Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbaDKQH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:07:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbaDKQH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:07:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/41] 3.10.37-stable review
Date: Fri, 11 Apr 2014 09:09:31 -0700
Message-Id: <20140411160932.865173041@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.37 release.
There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Apr 13 16:09:00 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.37-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.37-rc1

Stephen Boyd <sboyd@codeaurora.org>
    cpufreq: Fix timer/workqueue corruption due to double queueing

Xiaoguang Chen <chenxg@marvell.com>
    cpufreq: Fix governor start/stop race condition

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

Sasha Levin <sasha.levin@oracle.com>
    rds: prevent dereference of a NULL device in rds_iw_laddr_check

Dan Carpenter <dan.carpenter@oracle.com>
    isdnloop: several buffer overflows

YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    isdnloop: Validate NUL-terminated strings from user.

Pablo Neira <pablo@netfilter.org>
    netlink: don't compare the nul-termination in nla_strcmp

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: some ipv6 statistic counters failed to disable bh

Paul Durrant <Paul.Durrant@citrix.com>
    xen-netback: remove pointless clause from if statement

Michael S. Tsirkin <mst@redhat.com>
    vhost: validate vhost_get_vq_desc return value

Michael S. Tsirkin <mst@redhat.com>
    vhost: fix total length when packets are too short

Vlad Yasevich <vyasevic@redhat.com>
    vlan: Set hard_header_len according to available acceleration

Oliver Neukum <oneukum@suse.de>
    usbnet: include wait queue head in device structure

Vlad Yasevich <vyasevic@redhat.com>
    tg3: Do not include vlan acceleration features in vlan_features

Li RongQing <roy.qing.li@gmail.com>
    netpoll: fix the skb check in pkt_is_ns

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip6mr: fix mfc notification flags

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipmr: fix mfc notification flags

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    rtnetlink: fix fdb notification flags

David Stevens <dlstevens@us.ibm.com>
    vxlan: fix potential NULL dereference in arp_reduce()

lucien <lucien.xin@gmail.com>
    ipv6: ip6_append_data_mtu do not handle the mtu of the second fragment properly

Heiner Kallweit <heiner.kallweit@web.de>
    ipv6: Avoid unnecessary temporary addresses being generated

Matthew Leach <matthew.leach@arm.com>
    net: socket: error on a negative msg_namelen

Eric Dumazet <eric.dumazet@gmail.com>
    tcp: tcp_release_cb() should release socket ownership

Peter Boström <peter.bostrom@netrounds.com>
    vlan: Set correct source MAC address with TX VLAN offload enabled

Sabrina Dubroca <sd@queasysnail.net>
    ipv6: don't set DST_NOCOUNT for remotely added routes

Anton Nayshtut <anton@swortex.com>
    ipv6: Fix exthdrs offload registration.

Eric Dumazet <edumazet@google.com>
    net: unix: non blocking recvmsg() should not return -EINTR

Florian Westphal <fw@strlen.de>
    inet: frag: make sure forced eviction removes all frags

Linus Lüssing <linus.luessing@web.de>
    bridge: multicast: add sanity check for query source addresses

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk

Nikolay Aleksandrov <nikolay@redhat.com>
    net: fix for a race condition in the inet frag code

Daniel Fu <danifu@nvidia.com>
    cpuidle: Check the result of cpuidle_get_driver() against NULL

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    kbuild: fix make headers_install when path is too long

Mikulas Patocka <mpatocka@redhat.com>
    powernow-k6: reorder frequencies

Mikulas Patocka <mpatocka@redhat.com>
    powernow-k6: correctly initialize default parameters

Mikulas Patocka <mpatocka@redhat.com>
    powernow-k6: disable cache when changing frequency

Paul Moore <pmoore@redhat.com>
    selinux: correctly label /proc inodes in use before the policy is loaded


-------------

Diffstat:

 Makefile                                   |   4 +-
 arch/arc/boot/dts/nsimosci.dts             |  12 ++-
 arch/arc/configs/nsimosci_defconfig        |   1 +
 arch/m68k/Kconfig                          |   1 +
 arch/s390/Kconfig                          |   1 +
 arch/x86/crypto/ghash-clmulni-intel_asm.S  |  29 ------
 arch/x86/crypto/ghash-clmulni-intel_glue.c |  14 ++-
 drivers/cpufreq/cpufreq.c                  |  24 +++++
 drivers/cpufreq/cpufreq_governor.c         |   3 +
 drivers/cpufreq/powernow-k6.c              | 147 +++++++++++++++++++++++------
 drivers/cpuidle/driver.c                   |   3 +-
 drivers/isdn/isdnloop/isdnloop.c           |  23 +++--
 drivers/net/ethernet/broadcom/tg3.c        |   5 +-
 drivers/net/usb/usbnet.c                   |  33 ++++---
 drivers/net/vxlan.c                        |   3 +
 drivers/net/xen-netback/netback.c          |   4 +-
 drivers/vhost/net.c                        |  20 +++-
 include/linux/cpufreq.h                    |   1 +
 include/linux/futex.h                      |   4 +
 include/linux/usb/usbnet.h                 |   2 +-
 include/net/sock.h                         |   5 +
 init/Kconfig                               |   7 ++
 kernel/futex.c                             |  14 ++-
 lib/nlattr.c                               |  10 +-
 net/8021q/vlan.c                           |   4 +-
 net/8021q/vlan_dev.c                       |   6 +-
 net/bridge/br_multicast.c                  |   6 ++
 net/core/netpoll.c                         |   2 +-
 net/core/rtnetlink.c                       |  10 +-
 net/core/sock.c                            |   5 +-
 net/ipv4/inet_fragment.c                   |   5 +-
 net/ipv4/ipmr.c                            |  13 ++-
 net/ipv4/tcp_output.c                      |  11 +++
 net/ipv6/addrconf.c                        |   5 +-
 net/ipv6/exthdrs_offload.c                 |   4 +-
 net/ipv6/icmp.c                            |   2 +-
 net/ipv6/ip6_output.c                      |  18 ++--
 net/ipv6/ip6mr.c                           |  13 ++-
 net/ipv6/mcast.c                           |  11 ++-
 net/ipv6/route.c                           |   2 +-
 net/rds/iw.c                               |   3 +-
 net/sctp/sm_make_chunk.c                   |   4 +-
 net/sctp/sm_statefuns.c                    |   5 -
 net/socket.c                               |   4 +
 net/unix/af_unix.c                         |  17 +++-
 scripts/Makefile.headersinst               |  20 ++--
 scripts/headers_install.sh                 |   7 +-
 security/selinux/hooks.c                   |  36 +++++--
 48 files changed, 413 insertions(+), 170 deletions(-)


