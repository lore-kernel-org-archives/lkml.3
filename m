Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaAGXsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:48:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43910 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaAGXsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:48:00 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.15
Date: Tue,  7 Jan 2014 15:47:53 -0800
Message-Id: <1389138474-27141-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.15 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.14 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Documentation/networking/ip-sysctl.txt       |  3 -
 Makefile                                     |  2 +-
 arch/arm/boot/dts/armada-370-xp.dtsi         |  2 +-
 arch/arm/include/asm/pgtable.h               |  2 +-
 arch/arm/mach-footbridge/common.c            |  3 +
 arch/arm/mach-footbridge/dc21285.c           |  2 -
 arch/arm/mach-footbridge/ebsa285.c           | 22 ++++---
 arch/arm/mm/mmap.c                           |  2 +-
 arch/arm/mm/pgd.c                            |  3 +-
 arch/arm/plat-omap/include/plat/dmtimer.h    |  5 +-
 arch/powerpc/kernel/signal_32.c              | 16 ++---
 arch/powerpc/kernel/signal_64.c              |  6 ++
 arch/s390/crypto/aes_s390.c                  | 50 +++++++++------
 arch/x86/Makefile                            |  8 ++-
 block/blk-cgroup.h                           |  8 +--
 crypto/algif_hash.c                          |  5 +-
 crypto/algif_skcipher.c                      |  4 +-
 crypto/authenc.c                             |  7 +-
 crypto/ccm.c                                 |  3 +-
 drivers/ata/ahci.c                           |  2 +
 drivers/ata/ahci_platform.c                  |  1 +
 drivers/ata/libata-scsi.c                    |  1 +
 drivers/atm/idt77252.c                       |  2 +-
 drivers/connector/cn_proc.c                  | 66 +++++++++++--------
 drivers/cpuidle/cpuidle.c                    |  6 +-
 drivers/firewire/sbp2.c                      |  1 +
 drivers/firmware/efivars.c                   | 16 +++--
 drivers/gpio/gpio-mpc8xxx.c                  |  8 ++-
 drivers/gpio/gpio-mvebu.c                    |  2 +-
 drivers/isdn/isdnloop/isdnloop.c             |  8 ++-
 drivers/isdn/mISDN/socket.c                  | 13 ++--
 drivers/media/dvb-frontends/cxd2820r_core.c  |  4 +-
 drivers/misc/enclosure.c                     |  7 ++
 drivers/net/bonding/bond_sysfs.c             | 11 +++-
 drivers/net/can/c_can/c_can.c                | 21 ++++--
 drivers/net/can/flexcan.c                    |  2 +-
 drivers/net/can/sja1000/sja1000.c            | 15 +++--
 drivers/net/ethernet/realtek/8139cp.c        |  5 +-
 drivers/net/ethernet/realtek/r8169.c         |  5 ++
 drivers/net/ethernet/smsc/smc91x.h           | 20 +-----
 drivers/net/macvtap.c                        |  8 ++-
 drivers/net/ppp/pppoe.c                      |  2 -
 drivers/net/tun.c                            | 10 ++-
 drivers/net/usb/usbnet.c                     |  3 -
 drivers/net/xen-netback/interface.c          | 10 +--
 drivers/scsi/3w-9xxx.c                       |  3 +-
 drivers/scsi/3w-sas.c                        |  3 +-
 drivers/scsi/3w-xxxx.c                       |  3 +-
 drivers/scsi/aacraid/linit.c                 |  1 +
 drivers/scsi/arcmsr/arcmsr_hba.c             |  1 +
 drivers/scsi/bfa/bfa_fcs.h                   |  1 +
 drivers/scsi/bfa/bfa_fcs_lport.c             | 14 +++-
 drivers/scsi/bfa/bfad_attr.c                 |  7 +-
 drivers/scsi/gdth.c                          |  1 +
 drivers/scsi/hosts.c                         |  1 +
 drivers/scsi/hpsa.c                          |  5 +-
 drivers/scsi/ipr.c                           |  3 +-
 drivers/scsi/ips.c                           |  1 +
 drivers/scsi/libsas/sas_ata.c                |  2 +-
 drivers/scsi/megaraid.c                      |  1 +
 drivers/scsi/megaraid/megaraid_mbox.c        |  1 +
 drivers/scsi/megaraid/megaraid_sas_base.c    |  1 +
 drivers/scsi/pmcraid.c                       |  1 +
 drivers/scsi/sd.c                            |  6 ++
 drivers/scsi/storvsc_drv.c                   |  1 +
 drivers/staging/comedi/drivers/amplc_pc263.c |  3 +
 drivers/staging/comedi/drivers/pcmuio.c      | 11 ++--
 drivers/staging/comedi/drivers/ssv_dnp.c     |  6 +-
 drivers/staging/tidspbridge/Kconfig          |  2 +-
 drivers/staging/vt6656/baseband.c            | 11 ++++
 drivers/staging/vt6656/rndis.h               |  1 +
 drivers/staging/zsmalloc/zsmalloc-main.c     | 17 +++--
 drivers/xen/grant-table.c                    |  6 +-
 fs/nfs/nfs4proc.c                            | 13 ++--
 fs/xfs/xfs_ioctl.c                           |  6 ++
 include/crypto/scatterwalk.h                 |  3 +-
 include/linux/net.h                          |  8 +++
 include/linux/random.h                       |  6 +-
 include/net/ip.h                             |  2 +-
 include/net/ipv6.h                           |  6 +-
 include/scsi/scsi_host.h                     |  6 ++
 include/trace/ftrace.h                       |  5 +-
 kernel/cpuset.c                              |  8 ++-
 kernel/irq/pm.c                              |  2 +-
 kernel/sched/debug.c                         | 10 +++
 kernel/sched/fair.c                          |  2 +
 kernel/time/timekeeping.c                    |  2 +-
 lib/random32.c                               | 14 ++--
 mm/rmap.c                                    |  4 ++
 net/appletalk/ddp.c                          | 16 ++---
 net/atm/common.c                             |  2 -
 net/ax25/af_ax25.c                           |  4 +-
 net/bluetooth/af_bluetooth.c                 |  4 --
 net/bluetooth/hci_sock.c                     |  2 -
 net/bluetooth/rfcomm/sock.c                  |  1 -
 net/bluetooth/sco.c                          |  1 -
 net/bridge/br_if.c                           |  2 +
 net/caif/caif_socket.c                       |  4 --
 net/compat.c                                 |  5 +-
 net/core/dev.c                               |  2 +-
 net/core/fib_rules.c                         |  3 +-
 net/core/iovec.c                             |  3 +-
 net/core/pktgen.c                            |  7 ++
 net/ieee802154/6lowpan.c                     |  4 +-
 net/ipv4/datagram.c                          |  2 +-
 net/ipv4/ip_sockglue.c                       |  3 +-
 net/ipv4/ip_vti.c                            |  1 +
 net/ipv4/ping.c                              | 13 ++--
 net/ipv4/raw.c                               |  6 +-
 net/ipv4/route.c                             |  8 ++-
 net/ipv4/tcp.c                               |  6 --
 net/ipv4/tcp_ipv4.c                          |  2 +-
 net/ipv4/tcp_metrics.c                       |  5 +-
 net/ipv4/tcp_output.c                        |  7 +-
 net/ipv4/udp.c                               | 14 ++--
 net/ipv6/datagram.c                          |  8 ++-
 net/ipv6/ip6_output.c                        |  7 +-
 net/ipv6/ip6_tunnel.c                        |  2 -
 net/ipv6/raw.c                               |  8 +--
 net/ipv6/route.c                             |  7 +-
 net/ipv6/udp.c                               |  9 +--
 net/ipx/af_ipx.c                             |  3 +-
 net/irda/af_irda.c                           |  4 --
 net/iucv/af_iucv.c                           |  2 -
 net/key/af_key.c                             |  1 -
 net/l2tp/l2tp_ip.c                           |  4 +-
 net/l2tp/l2tp_ip6.c                          |  2 +-
 net/l2tp/l2tp_ppp.c                          |  2 -
 net/llc/af_llc.c                             |  2 -
 net/netlink/af_netlink.c                     |  2 -
 net/netrom/af_netrom.c                       |  3 +-
 net/nfc/llcp/sock.c                          |  2 -
 net/nfc/rawsock.c                            |  2 -
 net/packet/af_packet.c                       | 95 ++++++++++++++++------------
 net/packet/internal.h                        |  1 +
 net/phonet/datagram.c                        |  9 ++-
 net/rds/recv.c                               |  2 -
 net/rose/af_rose.c                           |  8 ++-
 net/rxrpc/ar-recvmsg.c                       |  9 ++-
 net/socket.c                                 | 24 ++++---
 net/tipc/socket.c                            |  6 --
 net/unix/af_unix.c                           |  5 --
 net/x25/af_x25.c                             |  3 +-
 sound/pci/hda/patch_realtek.c                | 24 +++++++
 sound/soc/codecs/wm8731.c                    |  4 +-
 sound/soc/codecs/wm8990.c                    |  2 +
 146 files changed, 597 insertions(+), 405 deletions(-)

Alexei Starovoitov (1):
      ipv4: fix race in concurrent ip_route_input_slow()

Andreas Henriksson (1):
      net: Fix "ip rule delete table 256"

Andrey Vagin (1):
      tcp: don't update snd_nxt, when a socket is switched from repair mode

Andy Adamson (1):
      NFSv4 wait on recovery for async session errors

Ben Segall (1):
      sched: Avoid throttle_cfs_rq() racing with period_timer stopping

Bo Shen (1):
      ASoC: wm8731: fix dsp mode configuration

Chris Metcalf (1):
      connector: improved unaligned access error fix

Dan Carpenter (3):
      isdnloop: use strlcpy() instead of strcpy()
      net: clamp ->msg_namelen instead of returning an error
      gpio: mvebu: make mvchip->irqbase signed for error handling

Dan Williams (1):
      [SCSI] libsas: fix usage of ata_tf_to_fis

Daniel Borkmann (2):
      random32: fix off-by-one in seeding requirement
      packet: fix use after free race in send path when dev is released

David Chang (1):
      r8169: check ALDPS bit and disable it if enabled for the 8168g

Ding Tianhong (1):
      bridge: flush br's address entry in fdb when remove the bridge dev

Duan Jiong (1):
      ipv6: use rt6_get_dflt_router to get default router in rt6_route_rcv

Dwight Engen (1):
      xfs: add capability check to free eofblocks ioctl

Eric Dumazet (4):
      tcp: tsq: restore minimal amount of queueing
      net-tcp: fix panic in tcp_fastopen_cache_set()
      ipv4: fix possible seqlock deadlock
      inet: fix possible seqlock deadlocks

Felix Fietkau (1):
      usbnet: fix status interrupt urb handling

Gerald Schaefer (1):
      crypto: s390 - Fix aes-xts parameter corruption

Girish K S (1):
      ahci: sata: add support for exynos5440 sata

Greg Kroah-Hartman (1):
      Staging: tidspbridge: disable driver

Gregory CLEMENT (1):
      ARM: mvebu: use the virtual CPU registers to access coherency registers

H. Peter Anvin (1):
      x86-64, build: Always pass in -mno-sse

Hannes Frederic Sowa (6):
      inet: prevent leakage of uninitialized memory to user in recv syscalls
      net: rework recvmsg handler msg_name and msg_namelen logic
      net: add BUG_ON if kernel advertises msg_namelen > sizeof(struct sockaddr_storage)
      inet: fix addr_len/msg->msg_namelen assignment in recv_error and rxpmtu functions
      ipv6: fix leaking uninitialized port number of offender sockaddr
      ipv6: fix possible seqlock deadlock in ip6_finish_output2

Hans Verkuil (1):
      [media] cxd2820r_core: fix sparse warnings

Herbert Xu (1):
      crypto: s390 - Fix aes-cbc IV corruption

Hong Zhiguo (1):
      Update of blkg_stat and blkg_rwstat may happen in bh context.     While u64_stats_fetch_retry is only preempt_disable on 32bit     UP system. This is not enough to avoid preemption by bh and     may read strange 64 bit value.

Horia Geanta (1):
      crypto: ccm - Fix handling of zero plaintext when computing mac

Ian Abbott (3):
      staging: comedi: ssv_dnp: use comedi_dio_update_state()
      staging: comedi: amplc_pc263: correct insn_bits result
      staging: comedi: pcmuio: fix possible NULL deref on detach

James Bottomley (1):
      [SCSI] enclosure: fix WARN_ON in dual path device removing

Jason Wang (2):
      tuntap: limit head length of skb allocated
      macvtap: limit head length of skb allocated

Jianguo Wu (1):
      mm/hugetlb: check for pte NULL pointer in __page_check_address()

Jiri Pirko (1):
      ip6_output: fragment outgoing reassembled skb properly

Joel Fernandes (1):
      ARM: OMAP2+: Disable POSTED mode for errata i103 and i767

Jukka Rissanen (1):
      6lowpan: Uncompression of traffic class field was incorrect

Kailang Yang (2):
      ALSA: hda/realtek - Add support of ALC231 codec
      ALSA: hda/realtek - Set pcbeep amp for ALC668

Kamal Mostafa (1):
      Linux 3.8.13.15

Konrad Rzeszutek Wilk (1):
      cpuidle: Check for dev before deregistering it.

Laxman Dewangan (1):
      irq: Enable all irqs unconditionally in irq_resume

Linus Walleij (1):
      net: smc91: fix crash regression on the versatile

Liu Gang (1):
      powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536

Madper Xie (1):
      efi-pstore: Make efi-pstore return a unique id

Malcolm Priestley (1):
      staging: vt6656: [BUG] Fix for TX USB resets from vendors driver.

Marc Kleine-Budde (2):
      can: c_can: don't call pm_runtime_get_sync() from interrupt context
      can: flexcan: use correct clock as base for bit rate calculation

Mark Brown (1):
      ASoC: wm8990: Mark the register map as dirty when powering down

Martin K. Petersen (1):
      [SCSI] Disable WRITE SAME for RAID and virtual host adapter drivers

Martin Schwidefsky (1):
      time: Fix 1ns/tick drift w/ GENERIC_TIME_VSYSCALL_OLD

Matt Wilson (1):
      xen/gnttab: leave lazy MMU mode in the case of a m2p override failure

Michael Neuling (1):
      powerpc/signals: Improved mark VSX not saved with small contexts fix

Nicolas Dichtel (1):
      ip6tnl: fix use after free of fb_tnl_dev

Nikolay Aleksandrov (1):
      bonding: fix two race conditions in bond_store_updelay/downdelay

Olav Haugan (1):
      staging: zsmalloc: Ensure handle is never 0 on success

Oliver Hartkopp (1):
      can: sja1000: fix {pre,post}_irq() handling and IRQ handler return value

Peter Zijlstra (1):
      cpuset: Fix memory allocator deadlock

Russell King (3):
      ARM: fix booting low-vectors machines
      ARM: footbridge: fix VGA initialisation
      ARM: footbridge: fix EBSA285 LEDs

Samir Benmendil (1):
      ahci: add Marvell 9230 to the AHCI PCI device list

Shawn Landden (1):
      net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Stephen M. Cameron (2):
      [SCSI] hpsa: do not discard scsi status on aborted commands
      [SCSI] hpsa: return 0 from driver probe function on success, not 1

Steven Rostedt (Red Hat) (1):
      tracing: Allow events to have NULL strings

Takashi Iwai (3):
      ALSA: hda - Initialize missing bass speaker pin for ASUS AIO ET2700
      ALSA: hda - Fix silent output on ASUS W7J laptop
      ALSA: hda - Another fixup for ASUS laptop with ALC660 codec

Tom Lendacky (3):
      crypto: authenc - Find proper IV address in ablkcipher callback
      crypto: scatterwalk - Set the chain pointer indication bit
      crypto: scatterwalk - Use sg_chain_ptr on chain entries

Trond Myklebust (1):
      NFSv4: Update list of irrecoverable errors on DELEGRETURN

Veaceslav Falico (2):
      bonding: don't permit to use ARP monitoring in 802.3ad mode
      af_packet: block BH in prb_shutdown_retire_blk_timer()

Vijaya Mohan Guvva (1):
      [SCSI] bfa: Fix crash when symb name set for offline vport

Vlad Yasevich (1):
      net: core: Always propagate flag changes to interfaces

Wei Liu (1):
      xen-netback: fix refcnt unbalance for 3.11 and earlier versions

Yang Yingliang (1):
      net: 8139cp: fix a BUG_ON triggered by wrong bytes_compl

Ying Xue (1):
      atm: idt77252: fix dev refcnt leak

fan.du (2):
      xfrm: Release dst if this dst is improper for vti tunnel
      {pktgen, xfrm} Update IPv4 header total len and checksum after tranformation

