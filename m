Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3GBLHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:07:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36129 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3GBLHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:07:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [ 3.5.y.z extended stable ] Linux 3.5.7.16 stable review
Date: Tue,  2 Jul 2013 12:06:48 +0100
Message-Id: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.5.7.16 stable kernel.

This version contains 50 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.5.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.5.y-review

The review period for version 3.5.7.16 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.5.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 arch/arm/include/asm/cacheflush.h            |   4 +-
 arch/arm/mm/flush.c                          |  33 ++++
 arch/arm/mm/nommu.c                          |   6 +
 arch/tile/lib/exports.c                      |   2 +
 arch/x86/Kconfig                             |   1 +
 arch/x86/kvm/x86.c                           |   5 +-
 drivers/bluetooth/btmrvl_main.c              |   9 +-
 drivers/clk/clk.c                            |   1 +
 drivers/gpu/drm/radeon/radeon_ring.c         |   7 +
 drivers/input/touchscreen/cyttsp_core.c      |   2 +-
 drivers/net/bonding/bond_alb.c               |   6 +
 drivers/net/bonding/bonding.h                |  13 ++
 drivers/net/ethernet/broadcom/tg3.c          |  38 +++++
 drivers/net/ethernet/freescale/gianfar_ptp.c |   1 +
 drivers/net/ethernet/realtek/8139cp.c        |   1 +
 drivers/net/ethernet/realtek/r8169.c         |  34 +++-
 drivers/net/ethernet/renesas/sh_eth.c        |  15 +-
 drivers/net/team/team.c                      |   2 +-
 drivers/net/team/team_mode_roundrobin.c      |   2 +
 drivers/net/wan/dlci.c                       |  26 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |   2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |   6 +-
 drivers/target/iscsi/iscsi_target_erl0.c     |   4 +-
 drivers/tty/serial/pch_uart.c                |  29 +++-
 drivers/usb/serial/ti_usb_3410_5052.c        |   3 +-
 drivers/usb/serial/ti_usb_3410_5052.h        |   4 +-
 fs/exec.c                                    |  16 +-
 fs/ncpfs/dir.c                               |   9 --
 fs/ubifs/dir.c                               |  54 +++++--
 include/linux/perf_event.h                   |   3 +-
 include/linux/rculist_nulls.h                |   7 +-
 include/linux/socket.h                       |   3 +
 kernel/events/core.c                         | 233 ++++++++++++++++++---------
 kernel/events/hw_breakpoint.c                |   4 +-
 kernel/events/internal.h                     |   4 +
 net/bluetooth/l2cap_core.c                   |   3 +
 net/compat.c                                 |  13 +-
 net/ipv4/ip_gre.c                            |   2 +-
 net/ipv4/ipip.c                              |   2 +-
 net/ipv4/tcp.c                               |   7 +-
 net/ipv4/tcp_input.c                         |  23 +--
 net/ipv4/tcp_output.c                        |  10 +-
 net/ipv6/addrconf.c                          |   4 +-
 net/ipv6/ip6_output.c                        |   2 +-
 net/l2tp/l2tp_ppp.c                          |   6 +-
 net/netlabel/netlabel_domainhash.c           |  69 ++++++++
 net/packet/af_packet.c                       |   5 +-
 net/sctp/outqueue.c                          |   8 +-
 net/sctp/socket.c                            |   6 +
 net/socket.c                                 |  61 ++++---
 sound/usb/card.c                             |  22 ++-
 sound/usb/mixer.c                            |   1 +
 52 files changed, 629 insertions(+), 204 deletions(-)

Anders Hammarquist (1):
      USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable

Anderson Lizardo (1):
      Bluetooth: Fix crash in l2cap_build_cmd() with small MTU

Andy Lutomirski (2):
      net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg
      net: Unbreak compat_sys_{send,recv}msg

Artem Bityutskiy (2):
      UBIFS: prepare to fix a horrid bug
      UBIFS: fix a horrid bug

Chris Metcalf (1):
      tilepro: work around module link error with gcc 4.7

Clemens Ladisch (1):
      ALSA: usb-audio: work around Android accessory firmware bug

Daniel Borkmann (2):
      net: sctp: fix NULL pointer dereference in socket destruction
      packet: packet_getname_spkt: make sure string is always 0-terminated

Daniel Drake (1):
      Bluetooth: btmrvl: fix thread stopping race

Dave Chiluk (1):
      ncpfs: fix rmdir returns Device or resource busy

Eric Dumazet (5):
      tcp: fix tcp_md5_hash_skb_data()
      ipv6: fix possible crashes in ip6_cork_release()
      tcp: xps: fix reordering issues
      ip_tunnel: fix kernel panic with icmp_dest_unreach
      net: force a reload of first item in hlist_nulls_for_each_entry_rcu

Ferruh Yigit (1):
      Input: cyttsp - fix memcpy size param

Gao feng (1):
      ipv6: assign rt6_info to inet6_ifaddr in init_loopback

Gavin Shan (1):
      net/tg3: Avoid delay during MMIO access

Guillaume Nault (2):
      l2tp: Fix PPP header erasure and memory leak
      l2tp: Fix sendmsg() return value

Jerome Glisse (1):
      drm/radeon: update lockup tracking when scheduling in empty ring

Jiri Pirko (2):
      team: check return value of team_get_port_by_index_rcu() for NULL
      team: move add to port list before port enablement

Jörn Engel (1):
      target/iscsi: don't corrupt bh_count in iscsit_stop_time2retain_timer()

Lai Jiangshan (1):
      clk: remove notifier from list before freeing it

Liang Li (1):
      pch_uart: fix a deadlock when pch_uart as console

Nandita Dukkipati (1):
      tcp: bug fix in proportional rate reduction.

Neil Horman (1):
      sctp: fully initialize sctp_outq in sctp_outq_init

Nikolay Martynov (1):
      iwlwifi: dvm: fix chain noise calibration

Oleg Nesterov (1):
      hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

Paul Moore (1):
      netlabel: improve domain mapping validation

Peter Zijlstra (2):
      perf: Fix perf mmap bugs
      perf: Fix mmap() accounting hole

Randy Dunlap (1):
      x86: fix build error and kconfig for ia32_emulation and binfmt

Roland Dreier (1):
      tcm_qla2xxx: Fix residual for underrun commands that fail

Simon Baatz (2):
      ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_page
      ARM: 7772/1: Fix missing flush_kernel_dcache_page() for noMMU

Stefan Bader (1):
      r8169: fix 8168evl frame padding.

Stephane Eranian (1):
      perf: Disable monitoring on setuid processes for regular users

Takashi Iwai (1):
      ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam c310

Wei Yongjun (1):
      gianfar: add missing iounmap() on error in gianfar_ptp_probe()

Yoshihiro Shimoda (1):
      net: sh_eth: fix incorrect RX length error if R8A7740

Zefan Li (2):
      dlci: acquire rtnl_lock before calling __dev_get_by_name()
      dlci: validate the net device in dlci_del()

Zhanghaoyu (A) (1):
      KVM: x86: remove vcpu's CPL check in host-invoked XCR set

françois romieu (1):
      r8169: fix offloaded tx checksum for small packets.

stephen hemminger (1):
      8139cp: reset BQL when ring tx ring cleared

zheng.li (1):
      bonding: rlb mode of bond should not alter ARP originating via bridge
