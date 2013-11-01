Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab3KAWoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:44:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3KAWEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/54] 3.10.18-stable review
Date: Fri,  1 Nov 2013 15:03:28 -0700
Message-Id: <20131101220211.311926234@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.18 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Nov  3 22:00:53 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.18-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.18-rc1

Enrico Mioso <mrkiko.rs@gmail.com>
    usb: serial: option: blacklist Olivetti Olicard200

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: serial: option: add support for Inovia SEW858 device

Diego Elio Pettenò <flameeyes@flameeyes.eu>
    USB: serial: ti_usb_3410_5052: add Abbott strip port ID to combined table as well.

Roel Kluin <roel.kluin@gmail.com>
    serial: vt8500: add missing braces

Johannes Berg <johannes.berg@intel.com>
    wireless: radiotap: fix parsing buffer overrun

Fengguang Wu <fengguang.wu@intel.com>
    writeback: fix negative bdi max pause

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Fix inverted internal mic not indicated on some machines

Takashi Iwai <tiwai@suse.de>
    ALSA: us122l: Fix pcm_usb_stream mmapping regression

Hugh Dickins <hughd@google.com>
    mm: fix BUG in __split_huge_page_pmd

James Ralston <james.d.ralston@intel.com>
    i2c: ismt: initialize DMA buffer

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: fix data corruption

Mika Westerberg <mika.westerberg@linux.intel.com>
    gpio/lynxpoint: check if the interrupt is enabled in IRQ handler

Linus Walleij <linus.walleij@linaro.org>
    ARM: integrator: deactivate timer0 on the Integrator/CP

AKASHI Takahiro <takahiro.akashi@linaro.org>
    ARM: 7851/1: check for number of arguments in syscall_get/set_arguments()

Mariusz Ceier <mceier+kernel@gmail.com>
    davinci_emac.c: Fix IFF_ALLMULTI setup

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: probe routes asynchronous in rt6_probe

Julian Anastasov <ja@ssi.bg>
    netfilter: nf_conntrack: fix rt6i_gateway checks for H.323 helper

Julian Anastasov <ja@ssi.bg>
    ipv6: fill rt6i_gateway with nexthop address

Julian Anastasov <ja@ssi.bg>
    ipv6: always prefer rt6i_gateway if present

Hannes Frederic Sowa <hannes@stressinduktion.org>
    inet: fix possible memory corruption with UDP_CORK and UFO

Seif Mazareeb <seif@marvell.com>
    net: fix cipso packet validation when !NETLABEL

Daniel Borkmann <dborkman@redhat.com>
    net: unix: inherit SOCK_PASS{CRED, SEC} flags from socket to fix race

Vasundhara Volam <vasundhara.volam@emulex.com>
    be2net: pass if_id for v1 and V2 versions of TX_CREATE cmd

Salva Peiró <speiro@ai2.upv.es>
    wanxl: fix info leak in ioctl

Vlad Yasevich <vyasevich@gmail.com>
    sctp: Perform software checksum if packet has to be fragmented.

Fan Du <fan.du@windriver.com>
    sctp: Use software crc32 checksum when xfrm transform will happen.

Vlad Yasevich <vyasevich@gmail.com>
    net: dst: provide accessor function to dst->xfrm

Vlad Yasevich <vyasevic@redhat.com>
    bridge: Correctly clamp MAX forward_delay when enabling STP

Jason Wang <jasowang@redhat.com>
    virtio-net: refill only when device is up during setting queues

Jason Wang <jasowang@redhat.com>
    virtio-net: fix the race between channels setting and refill

Jason Wang <jasowang@redhat.com>
    virtio-net: don't respond to cpu hotplug notifier if we're not ready

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

Christophe Gouault <christophe.gouault@6wind.com>
    vti: get rid of nf mark rule in prerouting

Marc Kleine-Budde <mkl@pengutronix.de>
    net: vlan: fix nlmsg size calculation in vlan_get_size()

Paul Durrant <paul.durrant@citrix.com>
    xen-netback: Don't destroy the netdev until the vif is shut down

Fabio Estevam <fabio.estevam@freescale.com>
    net: secure_seq: Fix warning when CONFIG_IPV6 and CONFIG_INET are not selected

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

David S. Miller <davem@davemloft.net>
    l2tp: Fix build warning with ipv6 disabled.

François CACHEREUL <f.cachereul@alphalink.fr>
    l2tp: fix kernel panic when using IPv4-mapped IPv6 addresses

Eric Dumazet <edumazet@google.com>
    net: do not call sock_put() on TIMEWAIT sockets

Yuchung Cheng <ycheng@google.com>
    tcp: fix incorrect ca_state in tail loss probe

Eric Dumazet <edumazet@google.com>
    tcp: do not forget FIN in tcp_shifted_skb()

Eric Dumazet <edumazet@google.com>
    tcp: must unclone packets before mangling them

Eric Dumazet <edumazet@google.com>
    tcp: TSQ can use a dynamic limit

Eric Dumazet <edumazet@google.com>
    tcp: TSO packets automatic sizing


-------------

Diffstat:

 Documentation/networking/ip-sysctl.txt          |  9 +++++
 Makefile                                        |  4 +--
 arch/arm/boot/dts/integratorcp.dts              |  9 +++--
 arch/arm/include/asm/syscall.h                  |  6 ++++
 drivers/connector/cn_proc.c                     | 18 ++++++++++
 drivers/connector/connector.c                   |  7 ++--
 drivers/gpio/gpio-lynxpoint.c                   |  5 +--
 drivers/i2c/busses/i2c-ismt.c                   |  3 ++
 drivers/md/dm-snap-persistent.c                 | 18 ++++++----
 drivers/net/can/dev.c                           | 10 +++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |  1 +
 drivers/net/ethernet/emulex/benet/be_cmds.c     |  3 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c      |  6 ++--
 drivers/net/ethernet/ti/davinci_emac.c          |  3 +-
 drivers/net/virtio_net.c                        | 17 ++++++---
 drivers/net/wan/farsync.c                       |  1 +
 drivers/net/wan/wanxl.c                         |  1 +
 drivers/net/xen-netback/common.h                |  1 +
 drivers/net/xen-netback/interface.c             | 12 +++++--
 drivers/net/xen-netback/xenbus.c                | 17 ++++++---
 drivers/tty/serial/vt8500_serial.c              |  5 +--
 drivers/usb/serial/option.c                     |  9 ++++-
 drivers/usb/serial/ti_usb_3410_5052.c           |  1 +
 include/linux/skbuff.h                          |  5 +++
 include/net/cipso_ipv4.h                        |  6 ++--
 include/net/dst.h                               | 12 +++++++
 include/net/ip6_route.h                         |  6 ++--
 include/net/sock.h                              |  2 ++
 include/net/tcp.h                               |  1 +
 mm/huge_memory.c                                | 10 +++++-
 mm/page-writeback.c                             | 10 +++---
 net/8021q/vlan_netlink.c                        |  2 +-
 net/bridge/br_stp_if.c                          |  2 +-
 net/compat.c                                    |  2 ++
 net/core/secure_seq.c                           |  2 ++
 net/core/sock.c                                 |  1 +
 net/ipv4/inet_hashtables.c                      |  2 +-
 net/ipv4/ip_output.c                            |  2 +-
 net/ipv4/ip_vti.c                               | 14 ++++++--
 net/ipv4/route.c                                |  2 +-
 net/ipv4/sysctl_net_ipv4.c                      | 10 ++++++
 net/ipv4/tcp.c                                  | 28 ++++++++++++---
 net/ipv4/tcp_input.c                            | 41 ++++++++++++++++++++--
 net/ipv4/tcp_output.c                           | 28 +++++++++------
 net/ipv6/inet6_hashtables.c                     |  2 +-
 net/ipv6/ip6_output.c                           |  6 ++--
 net/ipv6/route.c                                | 46 ++++++++++++++++++++-----
 net/l2tp/l2tp_core.c                            | 36 +++++++++++++++----
 net/l2tp/l2tp_core.h                            |  3 ++
 net/l2tp/l2tp_ppp.c                             |  4 +++
 net/netfilter/nf_conntrack_h323_main.c          |  4 +--
 net/sctp/output.c                               |  3 +-
 net/socket.c                                    | 24 ++++++++++---
 net/unix/af_unix.c                              | 10 ++++++
 net/unix/diag.c                                 |  1 +
 net/wireless/radiotap.c                         |  7 +++-
 sound/pci/hda/hda_generic.c                     |  2 +-
 sound/usb/usx2y/us122l.c                        |  4 ++-
 58 files changed, 394 insertions(+), 112 deletions(-)


