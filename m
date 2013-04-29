Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612Ab3D2TLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:11:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759912Ab3D2TDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/30] 3.0.76-stable review
Date: Mon, 29 Apr 2013 12:02:24 -0700
Message-Id: <20130429184355.299556377@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.76 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed May  1 18:42:50 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.76-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.76-rc1

Sam Ravnborg <sam@ravnborg.org>
    sparc32: support atomic64_t

Eric Dumazet <edumazet@google.com>
    net: drop dst before queueing fragments

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    netrom: fix invalid use of sizeof in nr_recvmsg()

Mathias Krause <minipli@googlemail.com>
    tipc: fix info leaks via msg_name in recv_msg/recv_stream

Mathias Krause <minipli@googlemail.com>
    rose: fix info leak via msg_name in rose_recvmsg()

Mathias Krause <minipli@googlemail.com>
    netrom: fix info leak via msg_name in nr_recvmsg()

Mathias Krause <minipli@googlemail.com>
    llc: Fix missing msg_namelen update in llc_ui_recvmsg()

Mathias Krause <minipli@googlemail.com>
    iucv: Fix missing msg_namelen update in iucv_sock_recvmsg()

Mathias Krause <minipli@googlemail.com>
    irda: Fix missing msg_namelen update in irda_recvmsg_dgram()

Mathias Krause <minipli@googlemail.com>
    caif: Fix missing msg_namelen update in caif_seqpkt_recvmsg()

Mathias Krause <minipli@googlemail.com>
    Bluetooth: RFCOMM - Fix missing msg_namelen update in rfcomm_sock_recvmsg()

Mathias Krause <minipli@googlemail.com>
    Bluetooth: fix possible info leak in bt_sock_recvmsg()

Mathias Krause <minipli@googlemail.com>
    ax25: fix info leak via msg_name in ax25_recvmsg()

Mathias Krause <minipli@googlemail.com>
    atm: update msg_namelen in vcc_recvmsg()

Linus Torvalds <torvalds@linux-foundation.org>
    net: fix incorrect credentials passing

Eric Dumazet <edumazet@google.com>
    tcp: call tcp_replace_ts_recent() from tcp_ack()

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: sctp_auth_key_put: use kzfree instead of kfree

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    esp4: fix error return code in esp_output()

Dmitry Popov <dp@highloadlab.com>
    tcp: incoming connections might use wrong route under synflood

Michael Riesch <michael.riesch@omicron.at>
    rtnetlink: Call nlmsg_parse() with correct header length

Patrick McHardy <kaber@trash.net>
    netfilter: don't reset nf_trace in nf_reset()

Eric W. Biederman <ebiederm@xmission.com>
    af_unix: If we don't care about credentials coallesce all messages

nikolay@redhat.com <nikolay@redhat.com>
    bonding: IFF_BONDING is not stripped on enslave failure

Hannes Frederic Sowa <hannes@stressinduktion.org>
    atl1e: limit gso segment size to prevent generation of wrong ip length fields

Vlad Yasevich <vyasevic@redhat.com>
    net: count hw_addr syncs so that unsync works properly.

Balakumaran Kannan <kumaran.4353@gmail.com>
    net IPv6 : Fix broken IPv6 routing table after loopback down-up

Vasily Averin <vvs@parallels.com>
    cbq: incorrect processing of high limits

David S. Miller <davem@davemloft.net>
    sparc64: Fix race in TLB batch processing.

Jiri Slaby <jslaby@suse.cz>
    TTY: fix atime/mtime regression

Jiri Slaby <jslaby@suse.cz>
    TTY: do not update atime/mtime on read/write


-------------

Diffstat:

 Makefile                             |   4 +-
 arch/sparc/Kconfig                   |   1 +
 arch/sparc/include/asm/atomic_32.h   |   2 +
 arch/sparc/include/asm/pgtable_64.h  |   1 +
 arch/sparc/include/asm/system_64.h   |   3 +-
 arch/sparc/include/asm/tlbflush_64.h |  37 +++++++++--
 arch/sparc/kernel/smp_64.c           |  41 ++++++++++--
 arch/sparc/mm/tlb.c                  |  39 ++++++++++--
 arch/sparc/mm/tsb.c                  |  57 ++++++++++++-----
 arch/sparc/mm/ultra.S                | 119 ++++++++++++++++++++++++++++-------
 drivers/net/atl1e/atl1e.h            |   2 +-
 drivers/net/atl1e/atl1e_main.c       |   1 +
 drivers/net/bonding/bond_main.c      |   1 +
 drivers/tty/tty_io.c                 |  14 ++++-
 include/linux/netdevice.h            |   2 +-
 include/linux/skbuff.h               |   8 +++
 include/linux/socket.h               |   3 +-
 include/net/scm.h                    |   2 +-
 net/atm/common.c                     |   2 +
 net/ax25/af_ax25.c                   |   1 +
 net/bluetooth/af_bluetooth.c         |   4 +-
 net/bluetooth/rfcomm/sock.c          |   1 +
 net/caif/caif_socket.c               |   2 +
 net/core/dev.c                       |   1 +
 net/core/dev_addr_lists.c            |   6 +-
 net/core/rtnetlink.c                 |   4 +-
 net/core/sock.c                      |  14 +++--
 net/ipv4/esp4.c                      |   6 +-
 net/ipv4/ip_fragment.c               |  15 +++--
 net/ipv4/syncookies.c                |   4 +-
 net/ipv4/tcp_input.c                 |  65 ++++++++++---------
 net/ipv6/addrconf.c                  |  27 ++++++++
 net/ipv6/reassembly.c                |  13 +++-
 net/irda/af_irda.c                   |   2 +
 net/iucv/af_iucv.c                   |   2 +
 net/llc/af_llc.c                     |   2 +
 net/netrom/af_netrom.c               |   1 +
 net/rose/af_rose.c                   |   1 +
 net/sched/sch_cbq.c                  |   5 +-
 net/sctp/auth.c                      |   2 +-
 net/tipc/socket.c                    |   7 +++
 net/unix/af_unix.c                   |   2 +-
 42 files changed, 405 insertions(+), 121 deletions(-)


