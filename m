Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3KAPlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:41:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50290 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3KAPk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:40:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.12
Date: Fri,  1 Nov 2013 08:40:50 -0700
Message-Id: <1383320451-25465-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.12 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.11 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Documentation/networking/ipvs-sysctl.txt    |   7 +
 Makefile                                    |   2 +-
 arch/arm/include/asm/jump_label.h           |   2 +-
 arch/arm/include/asm/syscall.h              |   6 +
 arch/mips/include/asm/jump_label.h          |   2 +-
 arch/parisc/kernel/traps.c                  |   6 +-
 arch/powerpc/include/asm/jump_label.h       |   2 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S     |   2 +-
 arch/s390/include/asm/jump_label.h          |   2 +-
 arch/sparc/include/asm/jump_label.h         |   2 +-
 arch/sparc/kernel/entry.S                   |   2 +-
 arch/sparc/kernel/ktlb.S                    |   3 +-
 arch/sparc/kernel/syscalls.S                |   8 +-
 arch/sparc/kernel/trampoline_64.S           |   2 -
 arch/sparc/lib/ksyms.c                      |   9 --
 arch/tile/include/asm/percpu.h              |  34 ++++-
 arch/x86/include/asm/cpufeature.h           |   2 +-
 arch/x86/include/asm/jump_label.h           |   2 +-
 drivers/block/xen-blkfront.c                |  36 +++--
 drivers/char/random.c                       |  11 +-
 drivers/gpu/drm/i915/i915_reg.h             |   6 +
 drivers/gpu/drm/i915/intel_display.c        |   8 +-
 drivers/gpu/drm/i915/intel_pm.c             |   5 +
 drivers/gpu/drm/radeon/evergreen.c          |   2 +-
 drivers/gpu/drm/radeon/evergreend.h         |   4 +-
 drivers/gpu/drm/radeon/r600d.h              |   2 +-
 drivers/gpu/drm/radeon/radeon_test.c        |   4 +-
 drivers/gpu/drm/radeon/sid.h                |   4 +-
 drivers/hwmon/applesmc.c                    |  13 ++
 drivers/i2c/busses/i2c-omap.c               |   3 +
 drivers/md/dm-snap-persistent.c             |  18 ++-
 drivers/net/bonding/bond_main.c             |  13 +-
 drivers/net/can/flexcan.c                   |  20 +--
 drivers/net/ethernet/realtek/r8169.c        |   1 +
 drivers/net/ethernet/via/via-rhine.c        |   9 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c |   6 +
 drivers/net/ppp/pptp.c                      |   2 +-
 drivers/net/tun.c                           |  11 +-
 drivers/net/usb/dm9601.c                    |   2 +-
 drivers/net/xen-netback/netback.c           |  94 ++++++++----
 drivers/scsi/esp_scsi.c                     |  14 +-
 drivers/scsi/esp_scsi.h                     |   1 +
 drivers/tty/serial/vt8500_serial.c          |   9 +-
 drivers/usb/core/quirks.c                   |   6 +
 drivers/usb/host/xhci-pci.c                 |  24 +++
 drivers/usb/host/xhci.c                     |  14 +-
 drivers/usb/host/xhci.h                     |   2 +
 drivers/usb/serial/option.c                 | 225 +++++++++++++++++++++++++++-
 drivers/usb/serial/ti_usb_3410_5052.c       |   1 +
 drivers/usb/storage/scsiglue.c              |   5 +-
 drivers/usb/storage/unusual_devs.h          |   7 +
 fs/btrfs/inode.c                            |   2 +-
 fs/cifs/cifsfs.c                            |   6 +-
 fs/ext4/xattr.c                             |   2 +
 fs/statfs.c                                 |   2 +-
 include/linux/compiler-gcc.h                |   3 +
 include/linux/compiler-gcc4.h               |  33 +++-
 include/linux/random.h                      |   1 +
 include/linux/timex.h                       |  14 ++
 include/linux/usb_usual.h                   |   4 +-
 include/net/ip.h                            |  12 +-
 include/net/ip_vs.h                         |  12 ++
 include/net/ipip.h                          |   3 +-
 init/main.c                                 |   2 +
 mm/huge_memory.c                            |  10 +-
 mm/page-writeback.c                         |  10 +-
 net/bridge/br_netlink.c                     |   2 +-
 net/bridge/br_private.h                     |   8 +-
 net/bridge/br_stp.c                         |  23 ++-
 net/bridge/br_stp_if.c                      |  12 +-
 net/caif/cfctrl.c                           |   3 +-
 net/core/flow_dissector.c                   |   4 +-
 net/core/netpoll.c                          |   9 +-
 net/dccp/ipv6.c                             |   1 +
 net/ipv4/igmp.c                             |   8 +-
 net/ipv4/inetpeer.c                         |   4 +-
 net/ipv4/ip_output.c                        |   8 +-
 net/ipv4/ipmr.c                             |   2 +-
 net/ipv4/raw.c                              |   2 +-
 net/ipv4/tcp.c                              |   3 +-
 net/ipv4/xfrm4_mode_tunnel.c                |   2 +-
 net/ipv6/exthdrs.c                          |   6 -
 net/ipv6/ip6_fib.c                          |   2 +-
 net/ipv6/ip6_gre.c                          |   4 +-
 net/ipv6/ip6_output.c                       |  53 +++----
 net/ipv6/ip6_tunnel.c                       |   5 +-
 net/ipv6/mcast.c                            |   4 +-
 net/ipv6/sit.c                              |   1 +
 net/netfilter/ipvs/ip_vs_core.c             |  12 +-
 net/netfilter/ipvs/ip_vs_ctl.c              |   7 +
 net/netfilter/ipvs/ip_vs_xmit.c             |   2 +-
 net/sched/sch_htb.c                         |   2 +-
 net/sctp/input.c                            |   3 +-
 net/sctp/ipv6.c                             |  44 ++----
 net/sctp/socket.c                           |   3 +
 sound/pci/hda/patch_hdmi.c                  |  18 +--
 sound/pci/hda/patch_realtek.c               |  10 ++
 sound/usb/usx2y/us122l.c                    |   4 +-
 sound/usb/usx2y/usbusx2yaudio.c             |  22 +--
 sound/usb/usx2y/usx2yhwdeppcm.c             |   7 +-
 100 files changed, 769 insertions(+), 324 deletions(-)

AKASHI Takahiro (1):
      ARM: 7851/1: check for number of arguments in syscall_get/set_arguments()

Alex Deucher (1):
      drm/radeon: fix typo in CP DMA register headers

Ansis Atteka (2):
      ip: use ip_hdr() in __ip_make_skb() to retrieve IP header
      ip: generate unique IP identificator if local fragmentation is allowed

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix channel map switch not taking effect

Chris Healy (1):
      resubmit bridge: fix message_age_timer calculation

Chris Metcalf (1):
      tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT

Chris Wilson (1):
      drm/i915: Only apply DPMS to the encoder if enabled

Dan Carpenter (1):
      drm/radeon: forever loop on error in radeon_do_test_moves()

Daniel Borkmann (4):
      net: fib: fib6_add: fix potential NULL pointer dereference
      net: sctp: fix smatch warning in sctp_send_asconf_del_ip
      net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit
      net: sctp: rfc4443: do not report ICMP redirects to user space

Daniel Mack (1):
      ALSA: snd-usb-usx2y: remove bogus frame checks

Daniel Santos (2):
      compiler-gcc4.h: Reorder macros based upon gcc ver
      compiler-gcc.h: Add gcc-recommended GCC_VERSION macro

Dave Jones (3):
      ext4: fix memory leak in xattr
      caif: Add missing braces to multiline if in cfctrl_linkup_request
      tcp: Add missing braces to do_tcp_setsockopt

David Henningsson (1):
      ALSA: hda - Fix microphone for Sony VAIO Pro 13 (Haswell model)

David S. Miller (2):
      esp_scsi: Fix tag state corruption when autosensing.
      sparc64: Fix off by one in trampoline TLB mapping installation loop.

David Vrabel (1):
      xen-netback: count number required slots for an skb more carefully

Diego Elio Pettenò (1):
      USB: serial: ti_usb_3410_5052: add Abbott strip port ID to combined table as well.

Ding Zhi (1):
      ip6_tunnels: raddr and laddr are inverted in nl msg

Duan Jiong (1):
      net:dccp: do not report ICMP redirects to user space

Enrico Mioso (1):
      usb: serial: option: blacklist Olivetti Olicard200

Eric Dumazet (1):
      net: flow_dissector: fix thoff for IPPROTO_AH

Fangxiaozhi (Franko) (1):
      USB: support new huawei devices in option.c

Fengguang Wu (1):
      writeback: fix negative bdi max pause

Francisco Jerez (1):
      drm/i915/hsw: Disable L3 caching of atomic memory operations.

Greg Kroah-Hartman (1):
      USB: serial: option: add support for Inovia SEW858 device

Hannes Frederic Sowa (2):
      ipv6: udp packets following an UFO enqueued packet need also be handled by UFO
      ipv6: gre: correct calculation of max_headroom

Helge Deller (1):
      parisc: fix interruption handler to respect pagefault_disable()

Henrik Rydberg (1):
      hwmon: (applesmc) Always read until end of data

Herbert Xu (1):
      bridge: Clamp forward_delay when enabling STP

Hong Zhiguo (2):
      bridge: use br_port_get_rtnl within rtnl lock
      bridge: fix NULL pointer deref of br_port_get_rcu

Hugh Dickins (1):
      mm: fix BUG in __split_huge_page_pmd

Ingo Molnar (1):
      compiler/gcc4: Add quirk for 'asm goto' miscompilation bug

Jan Klos (1):
      cifs: Fix inability to write files >2GB to SMB2/3 shares

Jason Wang (1):
      tuntap: correctly handle error in tun_set_iff()

Jiri Pirko (1):
      ipv6/exthdrs: accept tlv which includes only padding

Josef Bacik (1):
      Btrfs: use right root when checking for hash collision

Julian Anastasov (1):
      ipvs: add backup_only flag to avoid loops

Kamal Mostafa (1):
      Linux 3.8.13.12

Kirill Tkhai (4):
      sparc64: Fix ITLB handler of null page
      sparc64: Remove RWSEM export leftovers
      sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall
      sparc32: Fix exit flag passed from traced sys_sigreturn

Linus Torvalds (1):
      vfs: allow O_PATH file descriptors for fstatfs()

Marc Kleine-Budde (2):
      can: flexcan: fix flexcan_chip_start() on imx6
      can: flexcan: flexcan_chip_start: fix regression, mark one MB for TX and abort pending TX

Mikulas Patocka (1):
      dm snapshot: fix data corruption

Neil Horman (1):
      bonding: Fix broken promiscuity reference counting issue

Nicolas Dichtel (2):
      sit: allow to use rtnl ops on fb tunnel
      ip6tnl: allow to use rtnl ops on fb tunnel

Nikolay Aleksandrov (1):
      netpoll: fix NULL pointer dereference in netpoll_cleanup

Oliver Neukum (4):
      xhci: quirk for extra long delay for S4
      USB: quirks.c: add one device that cannot deal with suspension
      USB: quirks: add touchscreen that is dazzeled by remote wakeup
      usb-storage: add quirk for mandatory READ_CAPACITY_16

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Fix typo in saving DSCR

Peter Korsgaard (1):
      dm9601: fix IFF_ALLMULTI handling

Ricardo Ribalda (1):
      ll_temac: Reset dma descriptors indexes on ndo_open

Roel Kluin (1):
      serial: vt8500: add missing braces

Roger Luethi (1):
      via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)

Roger Pau Monne (1):
      xen-blkfront: use a different scatterlist for each request

Salam Noureddine (2):
      ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put
      ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put

Takashi Iwai (3):
      ALSA: hda - Add fixup for ASUS N56VZ
      xhci: Fix spurious wakeups after S5 on Haswell
      ALSA: us122l: Fix pcm_usb_stream mmapping regression

Taras Kondratiuk (1):
      i2c: omap: Clear ARDY bit twice

Theodore Ts'o (2):
      random: run random_int_secret_init() run after all late_initcalls
      random: allow architectures to optionally define random_get_entropy()

Tony Prisk (1):
      serial: vt8500: Fix range-checking on vt8500_uart_ports

Vimalkumar (1):
      net_sched: htb: fix a typo in htb_change_class()

françois romieu (1):
      r8169: enforce RX_MULTI_EN for the 8168f.

wojciech kapuscinski (1):
      drm/radeon: fix hw contexts for SUMO2 asics

