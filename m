Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3LQSNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:13:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab3LQSNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:13:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.5.y.z extended stable] Linux 3.5.7.28 stable review
Date: Tue, 17 Dec 2013 18:11:49 +0000
Message-Id: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.5.7.28 stable kernel.

This version contains 103 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.5.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.5.y-review

The review period for version 3.5.7.28 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.5.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 Documentation/i2c/busses/i2c-i801          |   1 +
 arch/arm/kernel/process.c                  |   7 +-
 arch/arm/kernel/stacktrace.c               |   2 +-
 arch/arm/mach-footbridge/common.c          |   5 +-
 arch/arm/mach-footbridge/dc21285.c         |   2 -
 arch/arm/mach-pxa/tosa.c                   | 102 ++++++++++++++---------------
 arch/mips/mm/dma-default.c                 |  16 +++--
 arch/s390/crypto/aes_s390.c                |  51 +++++++++------
 arch/s390/crypto/des_s390.c                |  12 ++--
 arch/s390/crypto/ghash_s390.c              |  21 +++---
 arch/s390/crypto/sha_common.c              |   9 ++-
 arch/um/os-Linux/start_up.c                |   2 +
 arch/x86/kvm/lapic.c                       |  30 +++++----
 arch/x86/kvm/lapic.h                       |   4 +-
 arch/x86/kvm/x86.c                         |  33 +---------
 arch/x86/platform/efi/efi.c                |   7 --
 block/blk-cgroup.h                         |   8 +--
 block/elevator.c                           |  16 ++++-
 crypto/algif_hash.c                        |   5 +-
 crypto/algif_skcipher.c                    |   4 +-
 crypto/authenc.c                           |   7 +-
 crypto/ccm.c                               |   3 +-
 drivers/ata/libata-scsi.c                  |   1 +
 drivers/atm/idt77252.c                     |   2 +-
 drivers/char/i8k.c                         |   7 ++
 drivers/connector/cn_proc.c                |  66 +++++++++++--------
 drivers/cpuidle/cpuidle.c                  |   2 +-
 drivers/firewire/sbp2.c                    |   1 +
 drivers/gpio/gpio-mpc8xxx.c                |   8 ++-
 drivers/gpu/drm/radeon/si.c                |  11 +++-
 drivers/hid/Kconfig                        |   1 +
 drivers/hid/hid-apple.c                    |  22 +++++++
 drivers/hid/hid-core.c                     |   2 +
 drivers/hid/hid-ids.h                      |   7 ++
 drivers/hid/hid-multitouch.c               |   8 +++
 drivers/hid/hid-roccat-kovaplus.c          |   4 ++
 drivers/hid/usbhid/hid-quirks.c            |   3 +
 drivers/hwmon/lm78.c                       |   2 +
 drivers/hwmon/sis5595.c                    |   2 +
 drivers/hwmon/vt8231.c                     |   2 +-
 drivers/hwmon/w83l786ng.c                  |  13 ++--
 drivers/i2c/busses/Kconfig                 |   1 +
 drivers/i2c/busses/i2c-i801.c              |   3 +
 drivers/input/Kconfig                      |   2 +-
 drivers/input/keyboard/Kconfig             |   4 +-
 drivers/input/serio/Kconfig                |   6 +-
 drivers/iommu/intel-iommu.c                |   6 +-
 drivers/isdn/isdnloop/isdnloop.c           |   8 ++-
 drivers/isdn/mISDN/socket.c                |  13 ++--
 drivers/md/dm-bufio.c                      |   5 ++
 drivers/md/dm-crypt.c                      |  37 +++--------
 drivers/md/dm-delay.c                      |  29 ++++----
 drivers/md/dm-flakey.c                     |   5 +-
 drivers/md/dm-ioctl.c                      |  18 +++--
 drivers/md/dm-linear.c                     |   5 +-
 drivers/md/dm-mpath.c                      |   6 +-
 drivers/md/dm-raid.c                       |   6 +-
 drivers/md/dm-raid1.c                      |   6 +-
 drivers/md/dm-snap.c                       |  83 ++++++++++++++++++-----
 drivers/md/dm-stripe.c                     |   5 +-
 drivers/md/dm-table.c                      |   5 ++
 drivers/md/dm-thin.c                       |  74 +++++++++++++--------
 drivers/md/dm-verity.c                     |   6 +-
 drivers/media/video/saa7164/saa7164-core.c |   4 +-
 drivers/misc/enclosure.c                   |   7 ++
 drivers/mmc/card/block.c                   |  47 ++++++++++++-
 drivers/net/bonding/bond_sysfs.c           |  11 +++-
 drivers/net/ethernet/smsc/smc91x.h         |  20 +-----
 drivers/net/ppp/pppoe.c                    |   2 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |  14 +---
 drivers/rtc/rtc-at91rm9200.c               |   2 +
 drivers/scsi/3w-9xxx.c                     |   3 +-
 drivers/scsi/3w-sas.c                      |   3 +-
 drivers/scsi/3w-xxxx.c                     |   3 +-
 drivers/scsi/aacraid/linit.c               |   1 +
 drivers/scsi/arcmsr/arcmsr_hba.c           |   1 +
 drivers/scsi/gdth.c                        |   1 +
 drivers/scsi/hosts.c                       |   1 +
 drivers/scsi/hpsa.c                        |   5 +-
 drivers/scsi/ipr.c                         |   3 +-
 drivers/scsi/ips.c                         |   1 +
 drivers/scsi/libsas/sas_ata.c              |   2 +-
 drivers/scsi/megaraid.c                    |   1 +
 drivers/scsi/megaraid/megaraid_mbox.c      |   1 +
 drivers/scsi/megaraid/megaraid_sas_base.c  |   1 +
 drivers/scsi/pmcraid.c                     |   1 +
 drivers/scsi/storvsc_drv.c                 |   1 +
 drivers/staging/media/lirc/lirc_zilog.c    |  12 +++-
 drivers/usb/class/cdc-acm.c                |   2 +
 drivers/usb/core/hub.c                     |   5 +-
 drivers/usb/dwc3/ep0.c                     |   2 +
 drivers/usb/dwc3/gadget.c                  |   5 +-
 drivers/usb/gadget/composite.c             |   1 +
 drivers/usb/serial/ftdi_sio.c              |  31 +++++++--
 drivers/usb/serial/generic.c               |   9 +--
 drivers/usb/serial/mos7840.c               |  32 ++++-----
 drivers/usb/serial/option.c                |  27 ++++++++
 drivers/usb/serial/pl2303.c                |  31 ++++-----
 drivers/usb/serial/spcp8x5.c               |  30 ++++-----
 drivers/video/kyro/fbdev.c                 |   6 +-
 drivers/xen/grant-table.c                  |   6 +-
 fs/nfs/blocklayout/extents.c               |   2 +-
 fs/nfs/nfs4proc.c                          |  13 ++--
 fs/xfs/xfs_ioctl.c                         |   3 +-
 fs/xfs/xfs_ioctl32.c                       |   3 +-
 include/crypto/scatterwalk.h               |   3 +-
 include/linux/compiler-intel.h             |   2 -
 include/linux/device-mapper.h              |   4 +-
 include/linux/net.h                        |   8 +++
 include/linux/random.h                     |   6 +-
 include/net/ip.h                           |   2 +-
 include/net/ipv6.h                         |   6 +-
 include/scsi/scsi_host.h                   |   6 ++
 include/sound/memalloc.h                   |   2 +-
 kernel/futex.c                             |   2 +-
 kernel/irq/pm.c                            |   2 +-
 kernel/sched/debug.c                       |   8 +++
 kernel/sched/fair.c                        |   2 +
 lib/random32.c                             |  14 ++--
 net/9p/trans_virtio.c                      |   5 ++
 net/appletalk/ddp.c                        |  16 ++---
 net/atm/common.c                           |   2 -
 net/ax25/af_ax25.c                         |   4 +-
 net/bluetooth/af_bluetooth.c               |   4 --
 net/bluetooth/hci_sock.c                   |   2 -
 net/bluetooth/rfcomm/sock.c                |   1 -
 net/bridge/br_if.c                         |   2 +
 net/caif/caif_socket.c                     |   4 --
 net/compat.c                               |   5 +-
 net/core/dev.c                             |   2 +-
 net/core/fib_rules.c                       |   3 +-
 net/core/iovec.c                           |   3 +-
 net/core/pktgen.c                          |   7 ++
 net/ieee802154/6lowpan.c                   |   4 +-
 net/ipv4/datagram.c                        |   2 +-
 net/ipv4/ip_sockglue.c                     |   3 +-
 net/ipv4/ping.c                            |  13 ++--
 net/ipv4/raw.c                             |   6 +-
 net/ipv4/tcp_ipv4.c                        |   2 +-
 net/ipv4/udp.c                             |  14 ++--
 net/ipv6/datagram.c                        |   8 ++-
 net/ipv6/ip6_output.c                      |   4 +-
 net/ipv6/raw.c                             |   8 +--
 net/ipv6/route.c                           |   7 +-
 net/ipv6/udp.c                             |   9 +--
 net/ipx/af_ipx.c                           |   3 +-
 net/irda/af_irda.c                         |   4 --
 net/iucv/af_iucv.c                         |   2 -
 net/key/af_key.c                           |   1 -
 net/l2tp/l2tp_ip.c                         |   4 +-
 net/l2tp/l2tp_ip6.c                        |   2 +-
 net/l2tp/l2tp_ppp.c                        |   2 -
 net/llc/af_llc.c                           |   2 -
 net/mac80211/rx.c                          |   3 +-
 net/netlink/af_netlink.c                   |   2 -
 net/netrom/af_netrom.c                     |   3 +-
 net/nfc/rawsock.c                          |   2 -
 net/packet/af_packet.c                     |  96 +++++++++++++++------------
 net/phonet/datagram.c                      |   9 ++-
 net/rds/recv.c                             |   2 -
 net/rose/af_rose.c                         |   8 ++-
 net/rxrpc/ar-recvmsg.c                     |   9 ++-
 net/socket.c                               |  24 ++++---
 net/tipc/socket.c                          |   6 --
 net/unix/af_unix.c                         |   5 --
 net/x25/af_x25.c                           |   3 +-
 security/selinux/hooks.c                   |  93 +++++++++++++++++++++-----
 sound/pci/hda/patch_realtek.c              |  13 ++++
 sound/soc/codecs/wm8731.c                  |   4 +-
 sound/soc/codecs/wm8990.c                  |   2 +
 virt/kvm/kvm_main.c                        |   3 +
 171 files changed, 1031 insertions(+), 683 deletions(-)

Alan Cox (1):
      drivers/char/i8k.c: add Dell XPLS L421X

Alan Stern (1):
      usb: dwc3: fix implementation of endpoint wedge

Alex Deucher (1):
      drm/radeon: fixup bad vram size on SI

Andreas Henriksson (1):
      net: Fix "ip rule delete table 256"

Andy Adamson (1):
      NFSv4 wait on recovery for async session errors

Andy Honig (3):
      KVM: Improve create VCPU parameter (CVE-2013-4587)
      KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)
      KVM: x86: Convert vapic synchronization to _cached functions (CVE-2013-6368)

Ben Segall (1):
      sched: Avoid throttle_cfs_rq() racing with period_timer stopping

Bo Shen (1):
      ASoC: wm8731: fix dsp mode configuration

Brian Carnes (1):
      hwmon: (w83l786ng) Fix fan speed control mode setting and reporting

Chris Metcalf (1):
      connector: improved unaligned access error fix

Colin Leitner (4):
      USB: spcp8x5: correct handling of CS5 setting
      USB: mos7840: correct handling of CS5 setting
      USB: ftdi_sio: fixed handling of unsupported CSIZE setting
      USB: pl2303: fixed handling of CS5 setting

Dan Carpenter (4):
      isdnloop: use strlcpy() instead of strcpy()
      net: clamp ->msg_namelen instead of returning an error
      hwmon: Prevent some divide by zeros in FAN_TO_REG()
      xfs: underflow bug in xfs_attrlist_by_handle()

Dan Williams (1):
      [SCSI] libsas: fix usage of ata_tf_to_fis

Daniel Borkmann (2):
      random32: fix off-by-one in seeding requirement
      packet: fix use after free race in send path when dev is released

David Cluytens (1):
      USB: cdc-acm: Added support for the Lenovo RD02-D400 USB Modem

Ding Tianhong (1):
      bridge: flush br's address entry in fdb when remove the

Dmitry Eremin-Solenikov (1):
      ARM: pxa: tosa: fix keys mapping

Duan Jiong (1):
      ipv6: use rt6_get_dflt_router to get default router in rt6_route_rcv

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't override mac80211's queue setting

Eric Dumazet (2):
      ipv4: fix possible seqlock deadlock
      inet: fix possible seqlock deadlocks

Fangxiaozhi (Franko) (1):
      USB: option: support new huawei devices

Forest Bond (1):
      HID: hid-multitouch: add support for SiS panels

Gerald Schaefer (1):
      crypto: s390 - Fix aes-xts parameter corruption

Gustavo Zacarias (1):
      USB: serial: option: blacklist interface 1 for Huawei E173s-6

H. Peter Anvin (1):
      x86, build, icc: Remove uninitialized_var() from compiler-intel.h

Hannes Frederic Sowa (6):
      inet: prevent leakage of uninitialized memory to user in recv syscalls
      net: rework recvmsg handler msg_name and msg_namelen logic
      net: add BUG_ON if kernel advertises msg_namelen > sizeof(struct sockaddr_storage)
      inet: fix addr_len/msg->msg_namelen assignment in recv_error and rxpmtu functions
      ipv6: fix leaking uninitialized port number of offender sockaddr
      ipv6: fix possible seqlock deadlock in ip6_finish_output2

Helge Deller (1):
      nfs: fix do_div() warning by instead using sector_div()

Hong Zhiguo (1):
      Update of blkg_stat and blkg_rwstat may happen in bh context.     While u64_stats_fetch_retry is only preempt_disable on 32bit     UP system. This is not enough to avoid preemption by bh and     may read strange 64 bit value.

Horia Geanta (1):
      crypto: ccm - Fix handling of zero plaintext when computing mac

James Bottomley (1):
      [SCSI] enclosure: fix WARN_ON in dual path device removing

Jan Glauber (1):
      s390/crypto: Don't panic after crypto instruction failures

Jean Delvare (1):
      hwmon: (w83l768ng) Fix fan speed control range

Jim Quinlan (1):
      MIPS: DMA: For BMIPS5000 cores flush region just like non-coherent R10000

Johan Hovold (1):
      USB: serial: fix race in generic write

Johannes Berg (1):
      mac80211: don't attempt to reorder multicast frames

Jukka Rissanen (1):
      6lowpan: Uncompression of traffic class field was incorrect

Julian Stecklina (1):
      iommu/vt-d: Fixed interaction of VFIO_IOMMU_MAP_DMA with IOMMU address limits

Julius Werner (1):
      usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED

KOBAYASHI Yoshitake (1):
      mmc: block: fix a bug of error handling in MMC driver

Konrad Rzeszutek Wilk (1):
      cpuidle: Check for dev before deregistering it.

Konstantin Khlebnikov (2):
      ARM: 7912/1: check stack pointer in get_wchan
      ARM: 7913/1: fix framepointer check in unwind_frame

Laxman Dewangan (1):
      irq: Enable all irqs unconditionally in irq_resume

Linus Pizunski (1):
      drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap

Linus Torvalds (1):
      futex: fix handling of read-only-mapped hugepages

Linus Walleij (1):
      net: smc91: fix crash regression on the versatile

Liu Gang (1):
      powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536

Marek Vasut (1):
      HID: add quirk for Freescale i.MX23 ROM recovery

Mark Brown (1):
      ASoC: wm8990: Mark the register map as dirty when powering down

Martin K. Petersen (1):
      [SCSI] Disable WRITE SAME for RAID and virtual host adapter drivers

Matt Wilson (1):
      xen/gnttab: leave lazy MMU mode in the case of a m2p override failure

Matthew Garrett (1):
      x86, efi: Don't use (U)EFI time services on 32 bit

Mauro Carvalho Chehab (1):
      [media] lirc_zilog: Don't use dynamic static allocation

Michael Grzeschik (1):
      usb: gadget: composite: reset delayed_status on reset_config

Michael Marineau (1):
      9p: send uevent after adding/removing mount_tag attribute

Mikulas Patocka (5):
      dm: fix truncated status strings
      dm delay: fix a possible deadlock due to shared workqueue
      dm snapshot: avoid snapshot space leak on crash
      dm table: fail dm_table_create on dm_round_up overflow
      dm bufio: initialize read-only module parameters

Nanno Langstraat (1):
      HID: apple: option to swap the 'Option' ("Alt") and 'Command' ("Flag") keys.

Nikolay Aleksandrov (1):
      bonding: fix two race conditions in bond_store_updelay/downdelay

Paul Moore (2):
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute()

Russell King (1):
      ARM: footbridge: fix VGA initialisation

Sasha Levin (1):
      video: kyro: fix incorrect sizes when copying to userspace

Sergei Trofimovich (1):
      um: add missing declaration of 'getrlimit()' and friends

Seth Heasley (1):
      i2c: i801: SMBus patch for Intel Avoton DeviceIDs

Shawn Landden (1):
      net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Stefan Achatz (1):
      HID: roccat: fix Coverity CID 141438

Stefano Panella (1):
      ALSA: memalloc.h - fix wrong truncation of dma_addr_t

Stephen M. Cameron (2):
      [SCSI] hpsa: do not discard scsi status on aborted commands
      [SCSI] hpsa: return 0 from driver probe function on success, not 1

Takashi Iwai (2):
      ALSA: hda - Fix silent output on ASUS W7J laptop
      ALSA: hda - Another fixup for ASUS laptop with ALC660 codec

Tom Gundersen (2):
      Input: allow deselecting serio drivers even without CONFIG_EXPERT
      Input: mousedev - allow disabling even without CONFIG_EXPERT

Tom Lendacky (3):
      crypto: authenc - Find proper IV address in ablkcipher callback
      crypto: scatterwalk - Set the chain pointer indication bit
      crypto: scatterwalk - Use sg_chain_ptr on chain entries

Tomoki Sekiyama (1):
      elevator: acquire q->sysfs_lock in elevator_change()

Trond Myklebust (1):
      NFSv4: Update list of irrecoverable errors on DELEGRETURN

Veaceslav Falico (2):
      bonding: don't permit to use ARP monitoring in 802.3ad mode
      af_packet: block BH in prb_shutdown_retire_blk_timer()

Vlad Yasevich (1):
      net: core: Always propagate flag changes to interfaces

Wei Yongjun (1):
      [media] saa7164: fix return value check in saa7164_initdev()

Ying Xue (1):
      atm: idt77252: fix dev refcnt leak

fan.du (1):
      {pktgen, xfrm} Update IPv4 header total len and checksum after tranformation
