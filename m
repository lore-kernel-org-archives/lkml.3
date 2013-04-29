Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab3D2TCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:02:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab3D2TC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/42] 3.8.11-stable review
Date: Mon, 29 Apr 2013 12:01:42 -0700
Message-Id: <20130429184752.435249613@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.8.11 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed May  1 18:47:07 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.11-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.8.11-rc1

Aaro Koskinen <aaro.koskinen@iki.fi>
    ARM: 7692/1: iop3xx: move IOP3XX_PERIPHERAL_VIRT_BASE

Stephen Boyd <sboyd@codeaurora.org>
    ARM: 7699/1: sched_clock: Add more notrace to prevent recursion

Steven Rostedt <srostedt@redhat.com>
    tracing: Fix selftest function recursion accounting

Eric Dumazet <edumazet@google.com>
    net: drop dst before queueing fragments

Linus Torvalds <torvalds@linux-foundation.org>
    net: fix incorrect credentials passing

Ben Greear <greearb@candelatech.com>
    net: rate-limit warn-bad-offload splats.

Eric Dumazet <edumazet@google.com>
    tcp: call tcp_replace_ts_recent() from tcp_ack()

Bjørn Mork <bjorn@mork.no>
    net: cdc_mbim: remove bogus sizeof()

Willy Tarreau <w@1wt.eu>
    net: mvneta: fix improper tx queue usage in mvneta_tx()

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    esp4: fix error return code in esp_output()

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    net: mvmdio: add select PHYLIB

Thomas Graf <tgraf@suug.ch>
    tcp: Reallocate headroom if it would overflow csum_start

Dmitry Popov <dp@highloadlab.com>
    tcp: incoming connections might use wrong route under synflood

Michael Riesch <michael.riesch@omicron.at>
    rtnetlink: Call nlmsg_parse() with correct header length

Christoph Paasch <christoph.paasch@uclouvain.be>
    ipv6/tcp: Stop processing ICMPv6 redirect messages

Patrick McHardy <kaber@trash.net>
    netfilter: don't reset nf_trace in nf_reset()

Eric W. Biederman <ebiederm@xmission.com>
    af_unix: If we don't care about credentials coallesce all messages

Eric Dumazet <edumazet@google.com>
    bonding: fix l23 and l34 load balancing in forwarding path

nikolay@redhat.com <nikolay@redhat.com>
    bonding: IFF_BONDING is not stripped on enslave failure

nikolay@redhat.com <nikolay@redhat.com>
    bonding: fix bonding_masters race condition in bond unloading

Hannes Frederic Sowa <hannes@stressinduktion.org>
    atl1e: limit gso segment size to prevent generation of wrong ip length fields

Vlad Yasevich <vyasevic@redhat.com>
    net: count hw_addr syncs so that unsync works properly.

Balakumaran Kannan <kumaran.4353@gmail.com>
    net IPv6 : Fix broken IPv6 routing table after loopback down-up

Vasily Averin <vvs@parallels.com>
    cbq: incorrect processing of high limits

Mathias Krause <minipli@googlemail.com>
    tipc: fix info leaks via msg_name in recv_msg/recv_stream

Mathias Krause <minipli@googlemail.com>
    rose: fix info leak via msg_name in rose_recvmsg()

Mathias Krause <minipli@googlemail.com>
    NFC: llcp: fix info leaks via msg_name in llcp_sock_recvmsg()

Mathias Krause <minipli@googlemail.com>
    netrom: fix info leak via msg_name in nr_recvmsg()

Mathias Krause <minipli@googlemail.com>
    llc: Fix missing msg_namelen update in llc_ui_recvmsg()

Mathias Krause <minipli@googlemail.com>
    l2tp: fix info leak in l2tp_ip6_recvmsg()

Mathias Krause <minipli@googlemail.com>
    iucv: Fix missing msg_namelen update in iucv_sock_recvmsg()

Mathias Krause <minipli@googlemail.com>
    irda: Fix missing msg_namelen update in irda_recvmsg_dgram()

Mathias Krause <minipli@googlemail.com>
    caif: Fix missing msg_namelen update in caif_seqpkt_recvmsg()

Mathias Krause <minipli@googlemail.com>
    Bluetooth: SCO - Fix missing msg_namelen update in sco_sock_recvmsg()

Mathias Krause <minipli@googlemail.com>
    Bluetooth: RFCOMM - Fix missing msg_namelen update in rfcomm_sock_recvmsg()

Mathias Krause <minipli@googlemail.com>
    Bluetooth: fix possible info leak in bt_sock_recvmsg()

Mathias Krause <minipli@googlemail.com>
    ax25: fix info leak via msg_name in ax25_recvmsg()

Mathias Krause <minipli@googlemail.com>
    atm: update msg_namelen in vcc_recvmsg()

David S. Miller <davem@davemloft.net>
    sparc64: Fix race in TLB batch processing.

Jiri Slaby <jslaby@suse.cz>
    TTY: fix atime/mtime regression

Jiri Slaby <jslaby@suse.cz>
    TTY: do not update atime/mtime on read/write

Zhao Hongjiang <zhaohongjiang@huawei.com>
    aio: fix possible invalid memory access when DEBUG is enabled


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/arm/include/asm/hardware/iop3xx.h          |   2 +-
 arch/arm/kernel/sched_clock.c                   |   4 +-
 arch/sparc/include/asm/pgtable_64.h             |   1 +
 arch/sparc/include/asm/switch_to_64.h           |   3 +-
 arch/sparc/include/asm/tlbflush_64.h            |  37 ++++++--
 arch/sparc/kernel/smp_64.c                      |  41 +++++++-
 arch/sparc/mm/tlb.c                             |  39 +++++++-
 arch/sparc/mm/tsb.c                             |  57 +++++++++---
 arch/sparc/mm/ultra.S                           | 119 +++++++++++++++++++-----
 drivers/net/bonding/bond_main.c                 |  65 ++++++++-----
 drivers/net/ethernet/atheros/atl1e/atl1e.h      |   2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |   1 +
 drivers/net/ethernet/marvell/Kconfig            |   2 +-
 drivers/net/ethernet/marvell/mvneta.c           |   9 +-
 drivers/net/usb/cdc_mbim.c                      |   2 +-
 drivers/tty/tty_io.c                            |  14 ++-
 fs/aio.c                                        |   2 +-
 include/linux/netdevice.h                       |   2 +-
 include/linux/skbuff.h                          |   7 ++
 include/net/scm.h                               |   4 +-
 kernel/trace/trace_selftest.c                   |  16 +---
 net/atm/common.c                                |   2 +
 net/ax25/af_ax25.c                              |   1 +
 net/bluetooth/af_bluetooth.c                    |   4 +-
 net/bluetooth/rfcomm/sock.c                     |   1 +
 net/bluetooth/sco.c                             |   1 +
 net/caif/caif_socket.c                          |   2 +
 net/core/dev.c                                  |   4 +
 net/core/dev_addr_lists.c                       |   6 +-
 net/core/rtnetlink.c                            |   4 +-
 net/ipv4/esp4.c                                 |   6 +-
 net/ipv4/ip_fragment.c                          |  15 ++-
 net/ipv4/syncookies.c                           |   4 +-
 net/ipv4/tcp_input.c                            |  64 ++++++-------
 net/ipv4/tcp_output.c                           |   8 +-
 net/ipv6/addrconf.c                             |  27 ++++++
 net/ipv6/reassembly.c                           |  13 ++-
 net/ipv6/tcp_ipv6.c                             |   1 +
 net/irda/af_irda.c                              |   2 +
 net/iucv/af_iucv.c                              |   2 +
 net/l2tp/l2tp_ip6.c                             |   1 +
 net/llc/af_llc.c                                |   2 +
 net/netrom/af_netrom.c                          |   1 +
 net/nfc/llcp/sock.c                             |   3 +
 net/rose/af_rose.c                              |   1 +
 net/sched/sch_cbq.c                             |   5 +-
 net/tipc/socket.c                               |   7 ++
 net/unix/af_unix.c                              |   2 +-
 49 files changed, 455 insertions(+), 167 deletions(-)


