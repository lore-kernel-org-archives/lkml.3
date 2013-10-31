Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3JaJ5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 05:57:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3JaJ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 05:57:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.5.y.z extended stable] Linux 3.5.7.24
Date: Thu, 31 Oct 2013 09:56:59 +0000
Message-Id: <1383213420-8503-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.5.7.24 kernel.

The updated 3.5.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.5.y;a=shortlog

The diff from v3.5.7.23 is posted as a follow-up to this email.

The 3.5.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Makefile                                        |   2 +-
 arch/arm/include/asm/syscall.h                  |   6 +
 arch/arm/mm/init.c                              |   3 +
 arch/ia64/mm/contig.c                           |   2 +
 arch/ia64/mm/discontig.c                        |   2 +
 arch/parisc/kernel/traps.c                      |   6 +-
 arch/parisc/mm/init.c                           |   2 +
 arch/powerpc/kernel/lparcfg.c                   |   1 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S         |   2 +-
 arch/powerpc/lib/checksum_64.S                  |  54 ++++--
 arch/tile/include/asm/percpu.h                  |  34 +++-
 arch/unicore32/mm/init.c                        |   3 +
 drivers/acpi/acpi_ipmi.c                        |  24 +--
 drivers/char/random.c                           |  11 +-
 drivers/connector/cn_proc.c                     |  16 ++
 drivers/connector/connector.c                   |   7 +-
 drivers/gpu/drm/radeon/evergreen.c              |   2 +-
 drivers/hwmon/applesmc.c                        |  13 ++
 drivers/md/dm-snap-persistent.c                 |  18 +-
 drivers/media/video/sh_vou.c                    |   2 +-
 drivers/net/can/dev.c                           |  10 +-
 drivers/net/can/flexcan.c                       |  20 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |   1 +
 drivers/net/ethernet/marvell/mv643xx_eth.c      |   6 +-
 drivers/net/ethernet/ti/davinci_emac.c          |   3 +-
 drivers/net/wan/farsync.c                       |   1 +
 drivers/net/wan/wanxl.c                         |   1 +
 drivers/net/wireless/rt2x00/rt2800lib.c         |   7 +
 drivers/pci/setup-res.c                         |   3 +-
 drivers/usb/core/quirks.c                       |   6 +
 drivers/usb/host/xhci-hub.c                     |  28 ---
 drivers/usb/host/xhci-pci.c                     |  25 +++
 drivers/usb/host/xhci.c                         |  14 +-
 drivers/usb/host/xhci.h                         |   2 +
 drivers/usb/serial/option.c                     | 225 +++++++++++++++++++++++-
 drivers/usb/serial/ti_usb_3410_5052.c           |   1 +
 drivers/usb/storage/scsiglue.c                  |   5 +-
 drivers/usb/storage/unusual_devs.h              |   7 +
 drivers/watchdog/ts72xx_wdt.c                   |   3 +-
 fs/btrfs/relocation.c                           |  14 +-
 fs/buffer.c                                     |  14 +-
 fs/ext4/xattr.c                                 |   2 +
 fs/fuse/dir.c                                   |   7 +-
 fs/fuse/file.c                                  |   8 +-
 fs/fuse/fuse_i.h                                |   9 +
 fs/fuse/inode.c                                 |   4 +-
 fs/nilfs2/page.c                                |   2 +
 fs/nilfs2/segment.c                             |  11 +-
 include/linux/mm.h                              |   3 +-
 include/linux/random.h                          |   1 +
 include/linux/skbuff.h                          |  15 ++
 include/linux/timex.h                           |  14 ++
 include/linux/usb_usual.h                       |   4 +-
 include/net/cipso_ipv4.h                        |   6 +-
 include/net/dst.h                               |  12 ++
 init/main.c                                     |   2 +
 lib/show_mem.c                                  |   3 +
 mm/memcontrol.c                                 |   2 +
 mm/mmap.c                                       |  77 +++++++-
 mm/page-writeback.c                             |  10 +-
 mm/page_alloc.c                                 |   7 +
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
 net/socket.c                                    |  24 ++-
 net/unix/af_unix.c                              |  10 ++
 net/unix/diag.c                                 |   1 +
 sound/pci/hda/patch_realtek.c                   |   1 +
 sound/usb/usx2y/usbusx2yaudio.c                 |  22 +--
 sound/usb/usx2y/usx2yhwdeppcm.c                 |   7 +-
 80 files changed, 740 insertions(+), 178 deletions(-)

AKASHI Takahiro (1):
      ARM: 7851/1: check for number of arguments in syscall_get/set_arguments()

Chen Gang (1):
      powerpc/pseries/lparcfg: Fix possible overflow are more than 1026

Chris Metcalf (1):
      tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT

Cyril Hrubis (1):
      mm/mmap: check for RLIMIT_AS before unmapping

Dan Carpenter (3):
      watchdog: ts72xx_wdt: locking bug in ioctl
      [media] sh_vou: almost forever loop in sh_vou_try_fmt_vid_out()
      net: heap overflow in __audit_sockaddr()

Daniel Borkmann (1):
      net: unix: inherit SOCK_PASS{CRED, SEC} flags from socket to fix race

Daniel Mack (1):
      ALSA: snd-usb-usx2y: remove bogus frame checks

Dave Jones (1):
      ext4: fix memory leak in xattr

David Rientjes (1):
      mm, show_mem: suppress page counts in non-blockable contexts

Diego Elio Pettenò (1):
      USB: serial: ti_usb_3410_5052: add Abbott strip port ID to combined table as well.

Enrico Mioso (1):
      usb: serial: option: blacklist Olivetti Olicard200

Eric Dumazet (5):
      tcp: must unclone packets before mangling them
      tcp: do not forget FIN in tcp_shifted_skb()
      net: do not call sock_put() on TIMEWAIT sockets
      l2tp: must disable bh before calling l2tp_xmit_skb()
      bnx2x: record rx queue for LRO packets

Fan Du (1):
      sctp: Use software crc32 checksum when xfrm transform will happen.

Fangxiaozhi (Franko) (1):
      USB: support new huawei devices in option.c

Fengguang Wu (1):
      writeback: fix negative bdi max pause

Greg Kroah-Hartman (1):
      USB: serial: option: add support for Inovia SEW858 device

Hannes Frederic Sowa (1):
      inet: fix possible memory corruption with UDP_CORK and UFO

Helge Deller (1):
      parisc: fix interruption handler to respect pagefault_disable()

Henrik Rydberg (1):
      hwmon: (applesmc) Always read until end of data

Jiri Benc (1):
      ipv4: fix ineffective source address selection

Johannes Weiner (1):
      fs: buffer: move allocation failure loop into the allocator

Josef Bacik (1):
      Btrfs: change how we queue blocks for backref checking

Linus Torvalds (1):
      mm: do not grow the stack vma just because of an overrun on preceding vma

Luis Henriques (1):
      Linux 3.5.7.24

Lv Zheng (1):
      ACPI / IPMI: Fix atomic context requirement of ipmi_msg_handler()

Marc Kleine-Budde (4):
      can: dev: fix nlmsg size calculation in can_get_size()
      net: vlan: fix nlmsg size calculation in vlan_get_size()
      can: flexcan: fix flexcan_chip_start() on imx6
      can: flexcan: flexcan_chip_start: fix regression, mark one MB for TX and abort pending TX

Marcelo Ricardo Leitner (1):
      ipv6: restrict neighbor entry creation to output flow

Mariusz Ceier (1):
      davinci_emac.c: Fix IFF_ALLMULTI setup

Mathias Krause (3):
      proc connector: fix info leaks
      unix_diag: fix info leak
      connector: use nlmsg_len() to check message length

Maxim Patlasov (1):
      fuse: hotfix truncate_pagecache() issue

Mikulas Patocka (1):
      dm snapshot: fix data corruption

Nikhil P Rao (1):
      PCI: fix truncation of resource size to 32 bits

Oliver Neukum (4):
      xhci: quirk for extra long delay for S4
      USB: quirks.c: add one device that cannot deal with suspension
      USB: quirks: add touchscreen that is dazzeled by remote wakeup
      usb-storage: add quirk for mandatory READ_CAPACITY_16

Paul E. McKenney (1):
      powerpc: Restore registers on error exit from csum_partial_copy_generic()

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Fix typo in saving DSCR

Salva Peiró (2):
      farsync: fix info leak in ioctl
      wanxl: fix info leak in ioctl

Sarah Sharp (1):
      xhci: Don't enable/disable RWE on bus suspend/resume.

Sebastian Hesselbarth (2):
      net: mv643xx_eth: update statistics timer from timer context only
      net: mv643xx_eth: fix orphaned statistics timer crash

Seif Mazareeb (1):
      net: fix cipso packet validation when !NETLABEL

Stanislaw Gruszka (1):
      rt2800: fix wrong TX power compensation

Takashi Iwai (2):
      ALSA: hda - Add fixup for ASUS N56VZ
      xhci: Fix spurious wakeups after S5 on Haswell

Theodore Ts'o (2):
      random: run random_int_secret_init() run after all late_initcalls
      random: allow architectures to optionally define random_get_entropy()

Vlad Yasevich (3):
      bridge: Correctly clamp MAX forward_delay when enabling STP
      net: dst: provide accessor function to dst->xfrm
      sctp: Perform software checksum if packet has to be fragmented.

Vyacheslav Dubeyko (1):
      nilfs2: fix issue with race condition of competition between segments for dirty blocks

wojciech kapuscinski (1):
      drm/radeon: fix hw contexts for SUMO2 asics

