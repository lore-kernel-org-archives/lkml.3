Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab3BLUf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:35:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3BLUfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/61] 3.7.8-stable review
Date: Tue, 12 Feb 2013 12:34:20 -0800
Message-Id: <20130212203417.890993903@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.7.8 release.
There are 61 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb 14 20:31:32 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.7.8-rc1

Marcin Slusarz <marcin.slusarz@gmail.com>
    drm/nouveau: add lockdep annotations

Eric Dumazet <edumazet@google.com>
    net: splice: fix __splice_segment()

Eric Dumazet <edumazet@google.com>
    net: splice: avoid high order page splitting

Eric Dumazet <edumazet@google.com>
    tcp: fix splice() and tcp collapsing interaction

Eric Dumazet <edumazet@google.com>
    tcp: splice: fix an infinite loop in tcp_read_sock()

Willy Tarreau <w@1wt.eu>
    tcp: don't abort splice() after small transfers

Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
    tcp: fix for zero packets_in_flight was too broad

Eric Dumazet <edumazet@google.com>
    tcp: frto should not set snd_cwnd to 0

Eric Dumazet <edumazet@google.com>
    tcp: fix an infinite loop in tcp_slow_start()

Yuchung Cheng <ycheng@google.com>
    tcp: detect SYN/data drop when F-RTO is disabled

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: sctp_endpoint_free: zero out secret key data

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree

Neil Horman <nhorman@tuxdriver.com>
    sctp: refactor sctp_outq_teardown to insure proper re-initalization

Steffen Klassert <steffen.klassert@secunet.com>
    ipv4: Fix route refcount on pmtu discovery

Steffen Klassert <steffen.klassert@secunet.com>
    ipv4: Add a socket release callback for datagram sockets

Steffen Klassert <steffen.klassert@secunet.com>
    ipv4: Invalidate the socket cached route on pmtu events if possible

Steffen Klassert <steffen.klassert@secunet.com>
    ipv6: Add an error handler for icmp6

Steffen Klassert <steffen.klassert@secunet.com>
    ipv4: Don't update the pmtu on mtu locked routes

Steffen Klassert <steffen.klassert@secunet.com>
    ipv4: Remove output route check in ipv4_mtu

Ian Campbell <Ian.Campbell@citrix.com>
    netback: correct netbk_tx_err to handle wrap around.

Ian Campbell <Ian.Campbell@citrix.com>
    xen/netback: free already allocated memory on failure in xen_netbk_get_requests

Matthew Daley <mattjd@gmail.com>
    xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.

Ian Campbell <Ian.Campbell@citrix.com>
    xen/netback: shutdown the ring if it contains garbage.

Heiko Carstens <heiko.carstens@de.ibm.com>
    atm/iphase: rename fregt_t -> ffreg_t

Tommi Rantala <tt.rantala@gmail.com>
    ipv6/ip6_gre: fix error case handling in ip6gre_tunnel_xmit()

Phil Sutter <phil.sutter@viprinet.com>
    packet: fix leakage of tx_ring memory

David S. Miller <davem@davemloft.net>
    via-rhine: Fix bugs in NAPI support.

Marcelo Ricardo Leitner <mleitner@redhat.com>
    ipv6: do not create neighbor entries for local delivery

Cong Wang <amwang@redhat.com>
    pktgen: correctly handle failures when adding a device

Pravin B Shelar <pshelar@nicira.com>
    IP_GRE: Fix kernel panic in IP_GRE with GRE csum.

Eric Dumazet <edumazet@google.com>
    net: loopback: fix a dst refcounting issue

Timo Teräs <timo.teras@iki.fi>
    r8169: remove the obsolete and incorrect AMD workaround

Eric Dumazet <edumazet@google.com>
    netxen: fix off by one bug in netxen_release_tx_buffer()

Tilman Schmidt <tilman@imap.cc>
    isdn/gigaset: fix zero size border case in debug dump

Eric Dumazet <edumazet@google.com>
    tcp: fix incorrect LOCKDROPPEDICMPS counter

Or Gerlitz <ogerlitz@mellanox.com>
    net/mlx4_core: Set number of msix vectors under SRIOV mode to firmware defaults

Yan Burman <yanb@mellanox.com>
    net/mlx4_en: Fix bridged vSwitch configuration for non SRIOV mode

Rob Herring <rob.herring@calxeda.com>
    net: calxedaxgmac: throw away overrun frames

Eric Dumazet <edumazet@google.com>
    macvlan: fix macvlan_get_size()

Romain KUNTZ <r.kuntz@ipflavors.com>
    ipv6: fix header length calculation in ip6_append_data()

Stephen Hemminger <stephen.hemminger@vyatta.com>
    MAINTAINERS: Stephen Hemminger email change

Eric Dumazet <edumazet@google.com>
    tcp: fix a panic on UP machines in reqsk_fastopen_remove

Stanislaw Gruszka <sgruszka@redhat.com>
    net, wireless: overwrite default_ethtool_ops

Romain Kuntz <r.kuntz@ipflavors.com>
    ipv6: fix the noflags test in addrconf_get_prefix_route

Cong Wang <xiyou.wangcong@gmail.com>
    net: prevent setting ttl=0 via IP_TTL

Mike Snitzer <snitzer@redhat.com>
    dm thin: fix queue limits stacking

Linus Walleij <linus.walleij@linaro.org>
    mfd: db8500-prcmu: Fix irqdomain usage

Felix Fietkau <nbd@openwrt.org>
    ath9k_hw: fix calibration issues on chainmask that don't include chain 0

Mauro Carvalho Chehab <mchehab@redhat.com>
    media: pwc-if: must check vb2_queue_init() success

Bruce Allan <bruce.w.allan@intel.com>
    e1000e: enable ECC on I217/I218 to catch packet buffer memory errors

Bing Zhao <bzhao@marvell.com>
    mwifiex: fix incomplete scan in case of IE parsing error

Alexander Stein <alexander.stein@systec-electronic.com>
    can: c_can: Set reserved bit in IFx_MASK2 to 1 on write

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    Revert "iwlwifi: fix the reclaimed packet tracking upon flush queue"

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix handling of unexpected SMP PDUs

Sjur Brændeland <sjur.brandeland@stericsson.com>
    virtio_console: Don't access uninitialized data.

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/qib: Fix for broken sparse warning fix

Alim Akhtar <alim.akhtar@samsung.com>
    regulator: s2mps11: fix incorrect register for buck10

Stephen Warren <swarren@nvidia.com>
    regulator: clear state each invocation of of_regulator_match

Marek Szyprowski <m.szyprowski@samsung.com>
    regulator: max8998: fix incorrect min_uV value for ldo10

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Fix scheduling while atomic bug

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Fix the usage of the wrong variable in usb.c


-------------

Diffstat:

 MAINTAINERS                                        |   6 +-
 Makefile                                           |   4 +-
 drivers/atm/iphase.h                               | 146 ++++++++++-----------
 drivers/char/virtio_console.c                      |   3 +-
 drivers/gpu/drm/nouveau/core/core/subdev.c         |   2 +-
 drivers/gpu/drm/nouveau/core/include/core/object.h |   7 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   3 +
 drivers/infiniband/hw/qib/qib_qp.c                 |  11 +-
 drivers/isdn/gigaset/capi.c                        |   2 +
 drivers/md/dm-thin.c                               |  13 +-
 drivers/media/usb/pwc/pwc-if.c                     |   6 +-
 drivers/mfd/db8500-prcmu.c                         |   6 +-
 drivers/net/can/c_can/c_can.c                      |   6 +-
 drivers/net/ethernet/calxeda/xgmac.c               |   4 +
 drivers/net/ethernet/intel/e1000e/defines.h        |   9 ++
 drivers/net/ethernet/intel/e1000e/e1000.h          |   2 +
 drivers/net/ethernet/intel/e1000e/ethtool.c        |   2 +
 drivers/net/ethernet/intel/e1000e/hw.h             |   1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  11 ++
 drivers/net/ethernet/intel/e1000e/netdev.c         |  46 +++++++
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |  13 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |  11 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_init.c   |   2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |   2 +
 drivers/net/ethernet/realtek/r8169.c               |   7 -
 drivers/net/ethernet/via/via-rhine.c               |   8 +-
 drivers/net/loopback.c                             |   5 +
 drivers/net/macvlan.c                              |   5 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |   2 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   2 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   1 +
 drivers/net/wireless/iwlwifi/dvm/tx.c              |  24 +---
 drivers/net/wireless/mwifiex/scan.c                |   9 +-
 drivers/net/wireless/rtlwifi/base.c                |   7 +-
 drivers/net/wireless/rtlwifi/usb.c                 |   4 +-
 drivers/net/xen-netback/common.h                   |   3 +
 drivers/net/xen-netback/interface.c                |  23 ++--
 drivers/net/xen-netback/netback.c                  | 115 +++++++++-------
 drivers/regulator/max8998.c                        |   2 +-
 drivers/regulator/of_regulator.c                   |   6 +
 drivers/regulator/s2mps11.c                        |   4 +-
 include/linux/netdevice.h                          |   3 +
 include/net/ip.h                                   |   2 +
 net/bluetooth/smp.c                                |  13 ++
 net/core/dev.c                                     |   8 ++
 net/core/pktgen.c                                  |   9 +-
 net/core/request_sock.c                            |   2 -
 net/core/skbuff.c                                  |  44 ++-----
 net/ipv4/datagram.c                                |  25 ++++
 net/ipv4/ip_gre.c                                  |   6 +-
 net/ipv4/ip_sockglue.c                             |   2 +-
 net/ipv4/ping.c                                    |   1 +
 net/ipv4/raw.c                                     |   1 +
 net/ipv4/route.c                                   |  54 +++++++-
 net/ipv4/tcp.c                                     |  27 ++--
 net/ipv4/tcp_cong.c                                |  14 +-
 net/ipv4/tcp_input.c                               |   8 +-
 net/ipv4/tcp_ipv4.c                                |   9 +-
 net/ipv4/udp.c                                     |   1 +
 net/ipv6/addrconf.c                                |   2 +-
 net/ipv6/icmp.c                                    |  12 ++
 net/ipv6/ip6_gre.c                                 |   2 +-
 net/ipv6/ip6_output.c                              |   4 +-
 net/ipv6/route.c                                   |   2 +-
 net/packet/af_packet.c                             |  10 +-
 net/sctp/endpointola.c                             |   5 +
 net/sctp/outqueue.c                                |  12 +-
 net/sctp/socket.c                                  |   2 +-
 net/wireless/core.c                                |   3 +-
 69 files changed, 537 insertions(+), 291 deletions(-)


