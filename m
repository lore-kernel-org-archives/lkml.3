Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3KAVnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:43:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3KAVnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:43:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/32] 3.4.68-stable review
Date: Fri,  1 Nov 2013 14:43:11 -0700
Message-Id: <20131101214313.735463599@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.68 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Nov  3 21:41:40 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.68-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.68-rc1

Enrico Mioso <mrkiko.rs@gmail.com>
    usb: serial: option: blacklist Olivetti Olicard200

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: serial: option: add support for Inovia SEW858 device

Diego Elio Pettenò <flameeyes@flameeyes.eu>
    USB: serial: ti_usb_3410_5052: add Abbott strip port ID to combined table as well.

Johannes Berg <johannes.berg@intel.com>
    wireless: radiotap: fix parsing buffer overrun

Fengguang Wu <fengguang.wu@intel.com>
    writeback: fix negative bdi max pause

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: fix data corruption

Eric Sandeen <sandeen@redhat.com>
    ext3: return 32/64-bit dir name hash according to usage type

Mariusz Ceier <mceier+kernel@gmail.com>
    davinci_emac.c: Fix IFF_ALLMULTI setup

Hannes Frederic Sowa <hannes@stressinduktion.org>
    inet: fix possible memory corruption with UDP_CORK and UFO

Seif Mazareeb <seif@marvell.com>
    net: fix cipso packet validation when !NETLABEL

Daniel Borkmann <dborkman@redhat.com>
    net: unix: inherit SOCK_PASS{CRED, SEC} flags from socket to fix race

Salva Peiró <speiro@ai2.upv.es>
    wanxl: fix info leak in ioctl

Vlad Yasevich <vyasevich@gmail.com>
    sctp: Perform software checksum if packet has to be fragmented.

Fan Du <fan.du@windriver.com>
    sctp: Use software crc32 checksum when xfrm transform will happen.

Vlad Yasevich <vyasevich@gmail.com>
    net: dst: provide accessor function to dst->xfrm

Eric Dumazet <edumazet@google.com>
    bnx2x: record rx queue for LRO packets

Mathias Krause <minipli@googlemail.com>
    connector: use nlmsg_len() to check message length

Mathias Krause <minipli@googlemail.com>
    unix_diag: fix info leak

Salva Peiró <speiro@ai2.upv.es>
    farsync: fix info leak in ioctl

Eric Dumazet <edumazet@google.com>
    l2tp: must disable bh before calling l2tp_xmit_skb()

Marc Kleine-Budde <mkl@pengutronix.de>
    net: vlan: fix nlmsg size calculation in vlan_get_size()

Vlad Yasevich <vyasevic@redhat.com>
    bridge: Correctly clamp MAX forward_delay when enabling STP

Marcelo Ricardo Leitner <mleitner@redhat.com>
    ipv6: restrict neighbor entry creation to output flow

Marc Kleine-Budde <mkl@pengutronix.de>
    can: dev: fix nlmsg size calculation in can_get_size()

Jiri Benc <jbenc@redhat.com>
    ipv4: fix ineffective source address selection

Mathias Krause <minipli@googlemail.com>
    proc connector: fix info leaks

Dan Carpenter <dan.carpenter@oracle.com>
    net: heap overflow in __audit_sockaddr()

Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    net: mv643xx_eth: fix orphaned statistics timer crash

Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    net: mv643xx_eth: update statistics timer from timer context only

Eric Dumazet <edumazet@google.com>
    net: do not call sock_put() on TIMEWAIT sockets

Eric Dumazet <edumazet@google.com>
    tcp: do not forget FIN in tcp_shifted_skb()

Eric Dumazet <edumazet@google.com>
    tcp: must unclone packets before mangling them


-------------

Diffstat:

 Makefile                                        |   4 +-
 drivers/connector/cn_proc.c                     |  16 +++
 drivers/connector/connector.c                   |   7 +-
 drivers/md/dm-snap-persistent.c                 |  18 ++-
 drivers/net/can/dev.c                           |  10 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |   1 +
 drivers/net/ethernet/marvell/mv643xx_eth.c      |   6 +-
 drivers/net/ethernet/ti/davinci_emac.c          |   3 +-
 drivers/net/wan/farsync.c                       |   1 +
 drivers/net/wan/wanxl.c                         |   1 +
 drivers/usb/serial/option.c                     |   9 +-
 drivers/usb/serial/ti_usb_3410_5052.c           |   1 +
 fs/ext3/dir.c                                   | 167 +++++++++++++++++-------
 fs/ext3/ext3.h                                  |   6 +-
 fs/ext3/hash.c                                  |   4 +-
 include/linux/skbuff.h                          |  15 +++
 include/net/cipso_ipv4.h                        |   6 +-
 include/net/dst.h                               |  12 ++
 mm/page-writeback.c                             |  10 +-
 net/8021q/vlan_netlink.c                        |   2 +-
 net/bridge/br_stp_if.c                          |   2 +-
 net/compat.c                                    |   2 +
 net/ipv4/inet_hashtables.c                      |   2 +-
 net/ipv4/ip_output.c                            |   2 +-
 net/ipv4/route.c                                |   2 +-
 net/ipv4/tcp_input.c                            |   5 +-
 net/ipv4/tcp_output.c                           |   9 +-
 net/ipv6/inet6_hashtables.c                     |   2 +-
 net/ipv6/ip6_output.c                           |   2 +-
 net/ipv6/route.c                                |  11 +-
 net/l2tp/l2tp_ppp.c                             |   4 +
 net/sctp/output.c                               |   3 +-
 net/socket.c                                    |  24 +++-
 net/unix/af_unix.c                              |  10 ++
 net/unix/diag.c                                 |   1 +
 net/wireless/radiotap.c                         |   7 +-
 36 files changed, 288 insertions(+), 99 deletions(-)


