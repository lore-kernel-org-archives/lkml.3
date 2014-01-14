Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaANA0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:26:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaANA0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:26:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/27] 3.4.77-stable review
Date: Mon, 13 Jan 2014 16:26:14 -0800
Message-Id: <20140114002623.356220317@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.77 release.
There are 27 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jan 16 00:26:11 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.77-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.77-rc1

Paul Turner <pjt@google.com>
    sched: Guarantee new group-entities always have weight

Ben Segall <bsegall@google.com>
    sched: Fix hrtimer_cancel()/rq->lock deadlock

Ben Segall <bsegall@google.com>
    sched: Fix cfs_bandwidth misuse of hrtimer_expires_remaining

Ben Segall <bsegall@google.com>
    sched: Fix race on toggling cfs_bandwidth_used

Linus Torvalds <torvalds@linux-foundation.org>
    x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    ARM: shmobile: mackerel: Fix coherent DMA mask

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: fix "bad mode in ... handler" message for undefined instructions

Curt Brune <curt@cumulusnetworks.com>
    bridge: use spin_lock_bh() in br_multicast_set_hash_max

Daniel Borkmann <dborkman@redhat.com>
    net: llc: fix use after free in llc_ui_recvmsg

David S. Miller <davem@davemloft.net>
    vlan: Fix header ops passthru when doing TX VLAN offload.

Florian Westphal <fw@strlen.de>
    net: rose: restore old recvmsg behavior

Sasha Levin <sasha.levin@oracle.com>
    rds: prevent dereference of a NULL device

Salva Peiró <speiro@ai2.upv.es>
    hamradio/yam: fix info leak in ioctl

Wenliang Fan <fanwlexca@gmail.com>
    drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()

Daniel Borkmann <dborkman@redhat.com>
    net: inet_diag: zero out uninitialized idiag_{src,dst} fields

Sasha Levin <sasha.levin@oracle.com>
    net: unix: allow bind to fail on mutex lock

Jason Wang <jasowang@redhat.com>
    netvsc: don't flush peers notifying work during setting mtu

Nat Gurumoorthy <natg@google.com>
    tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0

Sasha Levin <sasha.levin@oracle.com>
    net: unix: allow set_peek_off to fail

Changli Gao <xiaosuo@gmail.com>
    net: drop_monitor: fix the value of maxattr

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: don't count addrconf generated routes against gc limit

Jason Wang <jasowang@redhat.com>
    macvtap: signal truncated packets

Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    tun: update file current position

Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    macvtap: update file current position

Vlad Yasevich <vyasevic@redhat.com>
    macvtap: Do not double-count received packets

Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
    rds: prevent BUG_ON triggered on congestion update to loopback

Eric Dumazet <edumazet@google.com>
    net: do not pretend FRAGLIST support


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/arm/kernel/traps.c                           |  8 +++-
 arch/arm/mach-shmobile/board-mackerel.c           |  4 +-
 arch/x86/include/asm/fpu-internal.h               | 13 +++---
 drivers/net/ethernet/broadcom/tg3.c               |  3 ++
 drivers/net/ethernet/calxeda/xgmac.c              |  2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c         |  2 +-
 drivers/net/ethernet/tehuti/tehuti.c              |  1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c       |  2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |  2 +-
 drivers/net/hamradio/hdlcdrv.c                    |  2 +
 drivers/net/hamradio/yam.c                        |  1 +
 drivers/net/hyperv/netvsc_drv.c                   |  1 -
 drivers/net/macvtap.c                             | 20 ++++------
 drivers/net/tun.c                                 |  2 +
 include/linux/net.h                               |  2 +-
 include/linux/netdevice.h                         |  9 +++++
 kernel/sched/core.c                               |  9 ++++-
 kernel/sched/fair.c                               | 48 ++++++++++++++++-------
 kernel/sched/sched.h                              |  3 +-
 net/8021q/vlan_dev.c                              | 19 ++++++++-
 net/bridge/br_multicast.c                         |  4 +-
 net/core/drop_monitor.c                           |  1 -
 net/core/sock.c                                   |  2 +-
 net/ipv4/inet_diag.c                              | 16 ++++++++
 net/ipv6/route.c                                  |  8 +---
 net/llc/af_llc.c                                  |  5 ++-
 net/rds/ib.c                                      |  3 +-
 net/rds/ib_send.c                                 |  5 +--
 net/rose/af_rose.c                                | 16 ++------
 net/unix/af_unix.c                                | 16 ++++++--
 31 files changed, 153 insertions(+), 80 deletions(-)


