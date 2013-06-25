Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3FYSft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:35:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3FYSfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:35:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/27] 3.4.51-stable review
Date: Tue, 25 Jun 2013 11:35:19 -0700
Message-Id: <20130625183517.651770593@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.51 release.
There are 27 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 27 18:33:29 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.51-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.51-rc1

Zhao Hongjiang <zhaohongjiang@huawei.com>
    inotify: invalid mask should return a error number but not set it

Joern Engel <joern@logfs.org>
    target/iscsi: don't corrupt bh_count in iscsit_stop_time2retain_timer()

Anders Hammarquist <iko@iko.pp.se>
    USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable

Ferruh Yigit <fery@cypress.com>
    Input: cyttsp - fix memcpy size param

Zheng Li <zheng.x.li@oracle.com>
    bonding: rlb mode of bond should not alter ARP originating via bridge

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: Fix sendmsg() return value

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: Fix PPP header erasure and memory leak

Daniel Borkmann <dborkman@redhat.com>
    packet: packet_getname_spkt: make sure string is always 0-terminated

Jiri Pirko <jiri@resnulli.us>
    team: check return value of team_get_port_by_index_rcu() for NULL

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix NULL pointer dereference in socket destruction

Gao feng <gaofeng@cn.fujitsu.com>
    ipv6: assign rt6_info to inet6_ifaddr in init_loopback

Eric Dumazet <eric.dumazet@gmail.com>
    net: force a reload of first item in hlist_nulls_for_each_entry_rcu

Andy Lutomirski <luto@amacapital.net>
    net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg

Eric Dumazet <edumazet@google.com>
    ip_tunnel: fix kernel panic with icmp_dest_unreach

Eric Dumazet <edumazet@google.com>
    tcp: xps: fix reordering issues

Nandita Dukkipati <nanditad@google.com>
    tcp: bug fix in proportional rate reduction.

stephen hemminger <stephen@networkplumber.org>
    8139cp: reset BQL when ring tx ring cleared

Francois Romieu <romieu@fr.zoreil.com>
    r8169: fix offloaded tx checksum for small packets.

Paul Moore <pmoore@redhat.com>
    netlabel: improve domain mapping validation

Eric Dumazet <edumazet@google.com>
    ipv6: fix possible crashes in ip6_cork_release()

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    gianfar: add missing iounmap() on error in gianfar_ptp_probe()

Eric Dumazet <edumazet@google.com>
    tcp: fix tcp_md5_hash_skb_data()

Zhanghaoyu (A) <haoyu.zhang@huawei.com>
    KVM: x86: remove vcpu's CPL check in host-invoked XCR set

Chris Metcalf <cmetcalf@tilera.com>
    tilepro: work around module link error with gcc 4.7

Lai Jiangshan <laijs@cn.fujitsu.com>
    clk: remove notifier from list before freeing it

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: work around Android accessory firmware bug

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam c310


-------------

Diffstat:

 Makefile                                     |  4 +-
 arch/tile/lib/exports.c                      |  2 +
 arch/x86/kvm/x86.c                           |  5 +-
 drivers/clk/clk.c                            |  1 +
 drivers/input/touchscreen/cyttsp_core.c      |  2 +-
 drivers/net/bonding/bond_alb.c               |  6 +++
 drivers/net/bonding/bonding.h                | 13 ++++++
 drivers/net/ethernet/freescale/gianfar_ptp.c |  1 +
 drivers/net/ethernet/realtek/8139cp.c        |  1 +
 drivers/net/ethernet/realtek/r8169.c         | 41 +++++++++++------
 drivers/net/team/team_mode_roundrobin.c      |  2 +
 drivers/target/iscsi/iscsi_target_erl0.c     |  4 +-
 drivers/usb/serial/ti_usb_3410_5052.c        |  3 +-
 drivers/usb/serial/ti_usb_3410_5052.h        |  4 +-
 fs/notify/inotify/inotify_user.c             |  6 ++-
 include/linux/etherdevice.h                  | 33 +++++++++++++
 include/linux/rculist_nulls.h                |  7 ++-
 include/linux/socket.h                       |  3 ++
 net/compat.c                                 | 13 +++++-
 net/ipv4/ip_gre.c                            |  2 +-
 net/ipv4/ipip.c                              |  2 +-
 net/ipv4/tcp.c                               |  7 ++-
 net/ipv4/tcp_input.c                         | 23 ++++++----
 net/ipv4/tcp_output.c                        | 10 ++--
 net/ipv6/addrconf.c                          |  4 +-
 net/ipv6/ip6_output.c                        |  2 +-
 net/l2tp/l2tp_ppp.c                          |  6 +--
 net/netlabel/netlabel_domainhash.c           | 69 ++++++++++++++++++++++++++++
 net/packet/af_packet.c                       |  5 +-
 net/sctp/socket.c                            |  6 +++
 net/socket.c                                 | 67 ++++++++++++++++++---------
 sound/usb/card.c                             | 22 ++++++++-
 sound/usb/mixer.c                            |  1 +
 33 files changed, 298 insertions(+), 79 deletions(-)


