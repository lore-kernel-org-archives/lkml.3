Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab3ILRcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:32:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab3ILR0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:26:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/19] 3.0.96-stable review
Date: Thu, 12 Sep 2013 10:26:09 -0700
Message-Id: <20130912172524.135620246@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.96 release.
There are 19 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Sep 14 17:24:38 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.96-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.96-rc1

Dominik Dingel <dingel@linux.vnet.ibm.com>
    KVM: s390: move kvm_guest_enter,exit closer to sie

Geert Uytterhoeven <geert@linux-m68k.org>
    m32r: make memset() global for CONFIG_KERNEL_BZIP2=y

Geert Uytterhoeven <geert@linux-m68k.org>
    m32r: add memcpy() for CONFIG_KERNEL_GZIP=y

Geert Uytterhoeven <geert@linux-m68k.org>
    m32r: consistently use "suffix-$(...)"

Paul Gortmaker <paul.gortmaker@windriver.com>
    pci: frv architecture needs generic setup-bus infrastructure

Cong Wang <xiyou.wangcong@gmail.com>
    PARISC: include <linux/prefetch.h> in drivers/parisc/iommu-helpers.h

Ying Xue <ying.xue@windriver.com>
    tipc: fix lockdep warning during bearer initialization

Jiri Bohac <jbohac@suse.cz>
    ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO

Daniel Borkmann <dborkman@redhat.com>
    net: bridge: convert MLDv2 Query MRC into msecs_to_jiffies for max_delay

Thomas Graf <tgraf@suug.ch>
    ipv6: Don't depend on per socket memory for neighbour discovery messages

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: drop packets with multiple fragmentation headers

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: remove max_addresses check from ipv6_create_tempaddr

Dan Carpenter <dan.carpenter@oracle.com>
    tun: signedness bug in tun_get_user()

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: don't stop backtracking in fib6_lookup_1 if subtree does not match

Eric Dumazet <edumazet@google.com>
    tcp: cubic: fix bug in bictcp_acked()

Eric Dumazet <edumazet@google.com>
    tcp: cubic: fix overflow error in bictcp_update()

Eric Dumazet <edumazet@google.com>
    fib_trie: remove potential out of bound access

Roman Gushchin <klamm@yandex-team.ru>
    net: check net.core.somaxconn sysctl values

stephen hemminger <stephen@networkplumber.org>
    htb: fix sign extension bug


-------------

Diffstat:

 Makefile                           |  4 ++--
 arch/m32r/boot/compressed/Makefile |  6 +++---
 arch/m32r/boot/compressed/misc.c   | 12 +++++++++++-
 arch/s390/kvm/kvm-s390.c           | 17 +++++++++++------
 drivers/net/tun.c                  |  6 ++++--
 drivers/parisc/iommu-helpers.h     |  2 ++
 drivers/pci/Makefile               |  1 +
 include/linux/icmpv6.h             |  2 ++
 include/linux/ipv6.h               |  1 +
 net/bridge/br_multicast.c          |  3 ++-
 net/core/sysctl_net_core.c         |  7 ++++++-
 net/ipv4/fib_trie.c                |  5 +----
 net/ipv4/tcp_cubic.c               | 12 +++++++-----
 net/ipv6/addrconf.c                | 10 ++++------
 net/ipv6/icmp.c                    | 10 +++++++++-
 net/ipv6/ip6_fib.c                 | 16 ++++++++++++----
 net/ipv6/ndisc.c                   | 16 +++++++++-------
 net/ipv6/reassembly.c              |  5 +++++
 net/sched/sch_htb.c                |  2 +-
 net/tipc/eth_media.c               | 15 ++++++++++++++-
 20 files changed, 107 insertions(+), 45 deletions(-)


