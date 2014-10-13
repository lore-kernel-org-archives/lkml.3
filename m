Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaJMCZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:25:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbaJMCZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:25:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/16] 3.10.58-stable review
Date: Mon, 13 Oct 2014 04:23:57 +0200
Message-Id: <20141013022341.386913672@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.58 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Oct 15 02:23:28 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.58-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.58-rc1

Andreas Bomholtz <andreas@seluxit.com>
    USB: cp210x: add support for Seluxit USB dongle

Joe Savage <joe.savage@goketra.com>
    USB: serial: cp210x: added Ketra N1 wireless interface support

Lu Baolu <baolu.lu@linux.intel.com>
    USB: Add device quirk for ASUS T100 Base Station keyboard

Gao feng <gaofeng@cn.fujitsu.com>
    ipv6: reallocate addrconf router for ipv6 address when lo device up

Per Hurtig <per.hurtig@kau.se>
    tcp: fixing TLP's FIN recovery

Vlad Yasevich <vyasevich@gmail.com>
    sctp: handle association restarts when the socket is closed.

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip6_gre: fix flowi6_proto value in xmit path

KY Srinivasan <kys@microsoft.com>
    hyperv: Fix a bug in netvsc_start_xmit()

Vlad Yasevich <vyasevich@gmail.com>
    tg3: Allow for recieve of full-size 8021AD frames

Vlad Yasevich <vyasevich@gmail.com>
    tg3: Work around HW/FW limitations with vlan encapsulated frames

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: fix race while getting PMTU on PPP pseudo-wire

Jiri Benc <jbenc@redhat.com>
    openvswitch: fix panic with multiple vlan headers

Eric Dumazet <edumazet@google.com>
    packet: handle too big packets for PACKET_V3

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_release_cb() to dispatch via address family for mtu_reduced()

Shmulik Ladkani <shmulik.ladkani@gmail.com>
    sit: Fix ipip6_tunnel_lookup device matching criteria

Stanislaw Gruszka <sgruszka@redhat.com>
    myri10ge: check for DMA mapping errors


-------------

Diffstat:

 Makefile                                         |  4 +-
 drivers/net/ethernet/broadcom/tg3.c              | 23 ++++++-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 88 ++++++++++++++++--------
 drivers/net/hyperv/netvsc_drv.c                  |  3 +-
 drivers/usb/core/hub.c                           |  6 +-
 drivers/usb/core/quirks.c                        |  4 ++
 drivers/usb/serial/cp210x.c                      |  2 +
 include/linux/usb/quirks.h                       |  3 +
 include/net/inet_connection_sock.h               |  1 +
 include/net/sctp/command.h                       |  2 +-
 include/net/sock.h                               |  1 -
 include/net/tcp.h                                |  1 +
 net/ipv4/tcp_ipv4.c                              |  5 +-
 net/ipv4/tcp_output.c                            |  6 +-
 net/ipv6/addrconf.c                              | 14 +++-
 net/ipv6/ip6_gre.c                               |  4 +-
 net/ipv6/sit.c                                   |  6 +-
 net/ipv6/tcp_ipv6.c                              |  3 +-
 net/l2tp/l2tp_ppp.c                              |  3 +-
 net/openvswitch/actions.c                        |  5 ++
 net/packet/af_packet.c                           | 17 +++++
 net/packet/internal.h                            |  1 +
 net/sctp/sm_statefuns.c                          | 19 ++++-
 23 files changed, 163 insertions(+), 58 deletions(-)


