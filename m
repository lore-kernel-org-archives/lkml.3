Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3BHURR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:17:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36797 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab3BHURO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:17:14 -0500
Date: Fri, 08 Feb 2013 15:17:13 -0500 (EST)
Message-Id: <20130208.151713.1708597749091717933.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r18KHHHS005784


1) Revert iwlwifi reclaimed packet tracking, it causes problems for a bunch
   of folks.  From Emmanuel Grumbach.

2) Work limiting code in brcmsmac wifi driver can clear tx status without
   processing the event.  From Arend van Spriel.

3) rtlwifi USB driver processes wrong SKB, fix from Larry Finger.

4) l2tp tunnel delete can race with close, fix from Tom Parkin.

5) pktgen_add_device() failures are not checked at all, fix from
   Cong Wang.

6) Fix unintentional removal of carrier off from tun_detach(), otherwise
   we confuse userspace, from Michael S. Tsirkin.

7) Don't leak socket reference counts and ubufs in vhost-net driver, from
   Jason Wang.

8) vmxnet3 driver gets it's initial carrier state wrong, fix from
   Neil Horman.

9) Protect against USB networking devices which spam the host with 0
   length frames, from Bj√∏rn Mork.

10) Prevent neighbour overflows in ipv6 for locally destined routes,
    from Marcelo Ricardo.  This is the best short-term fix for this,
    a longer term fix has been implemented in net-next.

11) L2TP uses ipv4 datagram routines in it's ipv6 code, whoops.  This
    mistake is largely because the ipv6 functions don't even have some
    kind of prefix in their names to suggest they are ipv6 specific.
    From Tom Parkin.

12) Check SYN packet drops properly in tcp_rcv_fastopen_synack(), from
    Yuchung Cheng.

13) Fix races and TX skb freeing bugs in via-rhine's NAPI support, from
    Francois Romieu and your's truly.

14) Fix infinite loops and divides by zero in TCP congestion window
    handling, from Eric Dumazet, Neal Cardwell, and Ilpo J√§rvinen.

15) AF_PACKET tx ring handling can leak kernel memory to userspace,
    fix from Phil Sutter.

16) Fix error handling in ipv6 GRE tunnel transmit, from Tommi Rantala.

17) Protect XEN netback driver against hostile frontend putting garbage
    into the rings, don't leak pages in TX GOP checking, and add proper
    resource releasing in error path of xen_netbk_get_requests().  From
    Ian Campbell.

18) SCTP authentication keys should be cleared out and released with
    kzfree(), from Daniel Borkmann.

19) L2TP is a bit too clever trying to maintain skb->truesize, and ends
    up corrupting socket memory accounting to the point where packet
    sending is halted indefinitely.  Just remove the adjustments
    entirely, they aren't really needed.  From Eric Dumazet.

20) ATM Iphase driver uses a data type with the same name as the S390
    headers, rename to fix the build.  From Heiko Carstens.

21) Fix a typo in copying the inner network header offset from one SKB
    to another, from Pravin B Shelar.

Please pull, thanks a lot!

The following changes since commit fc16e884a2320198b8cb7bc2fdcf6b4485e79709:

  Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2013-01-28 16:23:07 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to a1c83b054ebe1264ed9ae9d5c286f9eae68e60ea:

  Merge branch 'sctp_keys' (2013-02-08 14:55:08 -0500)

----------------------------------------------------------------

Alexander Stein (1):
      can: c_can: Set reserved bit in IFx_MASK2 to 1 on write

Andre Guedes (1):
      Bluetooth: Fix hci_conn timeout routine

Arend van Spriel (2):
      brcmsmac: fix tx status processing
      brcmsmac: rework of mac80211 .flush() callback operation

Bing Zhao (1):
      mwifiex: fix incomplete scan in case of IE parsing error

Bj√∏rn Mork (4):
      net: usbnet: prevent buggy devices from killing us
      net: usbnet: fix tx_dropped statistics
      net: cdc_ncm: add another Huawei vendor specific device
      net: qmi_wwan: add more Huawei devices, including E320

Bruce Allan (1):
      e1000e: enable ECC on I217/I218 to catch packet buffer memory errors

Cong Wang (1):
      pktgen: correctly handle failures when adding a device

Dan Carpenter (1):
      cfg80211: off by one in ieee80211_bss()

Daniel Borkmann (3):
      net: sctp: sctp_auth_key_put: use kzfree instead of kfree
      net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
      net: sctp: sctp_endpoint_free: zero out secret key data

Daniele Palmas (1):
      NET: qmi_wwan: add Telit LE920 support

David S. Miller (7):
      Merge branch 'wireless'
      via-rhine: Fix bugs in NAPI support.
      Merge branch 'fixes-for-3.8' of git://gitorious.org/linux-can/linux-can
      Merge branch 'wireless'
      Merge branch 'netback'
      Merge branch 'fixes' of git://git.kernel.org/.../jesse/openvswitch into openvswitch
      Merge branch 'sctp_keys'

Emmanuel Grumbach (1):
      Revert "iwlwifi: fix the reclaimed packet tracking upon flush queue"

Eric Dumazet (3):
      tcp: fix an infinite loop in tcp_slow_start()
      tcp: frto should not set snd_cwnd to 0
      l2tp: dont play with skb->truesize

Hauke Mehrtens (2):
      bcma: unregister gpios before unloading bcma
      ssb: unregister gpios before unloading ssb

Heiko Carstens (1):
      atm/iphase: rename fregt_t -> ffreg_t

Ian Campbell (3):
      xen/netback: shutdown the ring if it contains garbage.
      xen/netback: free already allocated memory on failure in xen_netbk_get_requests
      netback: correct netbk_tx_err to handle wrap around.

Ilpo J√§rvinen (1):
      tcp: fix for zero packets_in_flight was too broad

Jason Wang (3):
      vhost_net: correct error handling in vhost_net_set_backend()
      vhost_net: handle polling errors when setting backend
      tuntap: allow polling/writing/reading when detached

Jesse Gross (1):
      openvswitch: Move LRO check from transmit to receive.

Johan Hedberg (1):
      Bluetooth: Fix handling of unexpected SMP PDUs

Johannes Naab (1):
      netem: fix delay calculation in rate extension

John W. Linville (5):
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Larry Finger (2):
      rtlwifi: Fix the usage of the wrong variable in usb.c
      rtlwifi: Fix scheduling while atomic bug

Lucas Stach (1):
      net: usb: fix regression from FLAG_NOARP code

Marcelo Ricardo Leitner (1):
      ipv6: do not create neighbor entries for local delivery

Matthew Daley (1):
      xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.

Michael S. Tsirkin (1):
      tun: fix carrier on/off status

Milos Vyletel (1):
      bonding: unset primary slave via sysfs

Neil Horman (1):
      vmxnet3: set carrier state properly on probe

Nivedita Singhvi (1):
      tcp: Increment LISTENOVERFLOW and LISTENDROPS in tcp_v4_conn_request()

Phil Sutter (1):
      packet: fix leakage of tx_ring memory

Pravin B Shelar (1):
      net: Fix inner_network_header assignment in skb-copy.

Rafa≈Ç Mi≈Çecki (1):
      bcma: fix NAND flash validation

Sarveshwar Bandi (1):
      be2net: Updating Module Author string and log message string to "Emulex Corporation"

Tom Parkin (4):
      l2tp: prevent l2tp_tunnel_delete racing with userspace close
      ipv6: rename datagram_send_ctl and datagram_recv_ctl
      ipv6: export ip6_datagram_recv_ctl
      l2tp: correctly handle ancillary data in the ip6 recv path

Tommi Rantala (1):
      ipv6/ip6_gre: fix error case handling in ip6gre_tunnel_xmit()

Vijay Subramanian (2):
      tcp: Update MIB counters for drops
      tcp: ipv6: Update MIB counters for drops

YOSHIFUJI Hideaki / ÂêâËó§Ëã±Êòé (1):
      ipv6 addrconf: Fix interface identifiers of 802.15.4 devices.

Yuchung Cheng (1):
      tcp: detect SYN/data drop when F-RTO is disabled

 drivers/atm/iphase.h                                  | 146 ++++++++++++++++++++++++-------------------------
 drivers/bcma/bcma_private.h                           |   5 ++
 drivers/bcma/driver_chipcommon_nflash.c               |   2 +-
 drivers/bcma/driver_gpio.c                            |   5 ++
 drivers/bcma/main.c                                   |   7 +++
 drivers/net/bonding/bond_sysfs.c                      |   1 +
 drivers/net/can/c_can/c_can.c                         |   6 +-
 drivers/net/ethernet/emulex/benet/be.h                |   8 +--
 drivers/net/ethernet/emulex/benet/be_main.c           |   2 +-
 drivers/net/ethernet/intel/e1000e/defines.h           |   9 +++
 drivers/net/ethernet/intel/e1000e/e1000.h             |   2 +
 drivers/net/ethernet/intel/e1000e/ethtool.c           |   2 +
 drivers/net/ethernet/intel/e1000e/hw.h                |   1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c           |  11 ++++
 drivers/net/ethernet/intel/e1000e/netdev.c            |  46 ++++++++++++++++
 drivers/net/ethernet/via/via-rhine.c                  |   8 +--
 drivers/net/tun.c                                     |  38 ++++++++-----
 drivers/net/usb/cdc_ncm.c                             |   3 +
 drivers/net/usb/qmi_wwan.c                            |  13 +++++
 drivers/net/usb/usbnet.c                              |  35 ++++++++++--
 drivers/net/vmxnet3/vmxnet3_drv.c                     |   7 +--
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |  35 +++++++-----
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h |   3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |  40 ++++----------
 drivers/net/wireless/brcm80211/brcmsmac/pub.h         |   3 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c                 |  24 +++-----
 drivers/net/wireless/mwifiex/scan.c                   |   9 +--
 drivers/net/wireless/rtlwifi/base.c                   |   7 ++-
 drivers/net/wireless/rtlwifi/usb.c                    |   4 +-
 drivers/net/xen-netback/common.h                      |   3 +
 drivers/net/xen-netback/interface.c                   |  23 +++++---
 drivers/net/xen-netback/netback.c                     | 115 +++++++++++++++++++++++---------------
 drivers/ssb/driver_gpio.c                             |  12 ++++
 drivers/ssb/main.c                                    |   9 +++
 drivers/ssb/ssb_private.h                             |   5 ++
 drivers/vhost/net.c                                   |  41 +++++++++-----
 drivers/vhost/vhost.c                                 |  18 +++++-
 drivers/vhost/vhost.h                                 |   2 +-
 include/linux/usb/usbnet.h                            |   4 +-
 include/net/transp_v6.h                               |  22 ++++----
 net/bluetooth/hci_conn.c                              |   6 +-
 net/bluetooth/smp.c                                   |  13 +++++
 net/core/pktgen.c                                     |   9 ++-
 net/core/skbuff.c                                     |   2 +-
 net/ipv4/tcp_cong.c                                   |  14 +++--
 net/ipv4/tcp_input.c                                  |   8 ++-
 net/ipv4/tcp_ipv4.c                                   |   6 +-
 net/ipv6/addrconf.c                                   |   1 +
 net/ipv6/datagram.c                                   |  16 +++---
 net/ipv6/ip6_flowlabel.c                              |   4 +-
 net/ipv6/ip6_gre.c                                    |   2 +-
 net/ipv6/ipv6_sockglue.c                              |   6 +-
 net/ipv6/raw.c                                        |   6 +-
 net/ipv6/route.c                                      |   2 +-
 net/ipv6/tcp_ipv6.c                                   |   6 +-
 net/ipv6/udp.c                                        |   6 +-
 net/l2tp/l2tp_core.c                                  |  82 +++++++++++++++++++++------
 net/l2tp/l2tp_core.h                                  |   5 +-
 net/l2tp/l2tp_ip6.c                                   |  10 ++--
 net/l2tp/l2tp_ppp.c                                   |   6 --
 net/openvswitch/vport-netdev.c                        |  16 +++---
 net/packet/af_packet.c                                |  10 ++--
 net/sched/sch_netem.c                                 |  12 ++--
 net/sctp/auth.c                                       |   2 +-
 net/sctp/endpointola.c                                |   5 ++
 net/sctp/socket.c                                     |   2 +-
 net/sunrpc/svcsock.c                                  |   2 +-
 net/wireless/scan.c                                   |   2 +-
 68 files changed, 649 insertions(+), 348 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
