Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3HSQPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:15:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10195 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3HSQPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:15:13 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=VwQbUJbxAAAA:8 a=1P2AnF-KnnpuLIWaZakA:9 a=QEXdDO2ut3YA:10 a=BwVWlvn-F6uszH5D:21 a=rdugDy5YhHa8rm_v:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 19 Aug 2013 12:15:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>
Subject: Linux 3.6.11.7
Message-ID: <20130819121512.691d1bde@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm announcing the release of the 3.6.11.7 kernel.

The updated 3.6.11.y git tree can be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git v3.6-stable

The patch can be downloaded at:
	https://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.7.xz

thanks,

-- Steve

 MAINTAINERS                                   |    1 +
 Makefile                                      |    2 +-
 arch/arm/include/asm/cacheflush.h             |    4 +-
 arch/arm/mm/flush.c                           |   33 ++++
 arch/arm/mm/nommu.c                           |    6 +
 arch/tile/lib/exports.c                       |    2 +
 arch/x86/Kconfig                              |    1 +
 arch/x86/include/asm/irq_remapping.h          |    2 +
 arch/x86/kernel/early-quirks.c                |   20 +++
 arch/x86/kvm/x86.c                            |    5 +-
 arch/x86/xen/time.c                           |   17 +-
 block/genhd.c                                 |    2 +-
 crypto/algapi.c                               |    3 +-
 crypto/algboss.c                              |   15 +-
 crypto/api.c                                  |    6 -
 crypto/internal.h                             |    6 +
 drivers/acpi/acpica/hwxfsleep.c               |    8 +-
 drivers/ata/libahci.c                         |    3 +-
 drivers/ata/libata-acpi.c                     |   35 +++-
 drivers/ata/libata-core.c                     |    2 +
 drivers/ata/libata.h                          |    2 +
 drivers/block/nbd.c                           |    9 +-
 drivers/cdrom/cdrom.c                         |    2 +-
 drivers/clk/clk.c                             |    1 +
 drivers/dma/pl330.c                           |    4 +-
 drivers/gpu/drm/radeon/radeon_ring.c          |   10 ++
 drivers/hv/ring_buffer.c                      |    2 +-
 drivers/hv/vmbus_drv.c                        |    2 +-
 drivers/input/touchscreen/cyttsp_core.c       |    2 +-
 drivers/iommu/intel_irq_remapping.c           |   10 ++
 drivers/iommu/irq_remapping.c                 |    6 +
 drivers/iommu/irq_remapping.h                 |    1 +
 drivers/net/ethernet/freescale/gianfar_ptp.c  |    1 +
 drivers/net/ethernet/realtek/8139cp.c         |    1 +
 drivers/net/ethernet/renesas/sh_eth.c         |   15 +-
 drivers/net/phy/phy.c                         |    2 +-
 drivers/net/team/team.c                       |    2 +-
 drivers/net/team/team_mode_roundrobin.c       |    2 +
 drivers/net/wan/dlci.c                        |   26 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c   |    2 +-
 drivers/pci/probe.c                           |    8 +-
 drivers/pcmcia/at91_cf.c                      |    4 +-
 drivers/power/charger-manager.c               |    2 +-
 drivers/rtc/rtc-rv3029c2.c                    |    2 +-
 drivers/scsi/osd/osd_uld.c                    |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c            |    6 +-
 drivers/scsi/sd.c                             |    2 +-
 drivers/target/iscsi/iscsi_target_erl0.c      |    4 +-
 drivers/usb/gadget/f_mass_storage.c           |    2 +
 drivers/usb/host/xhci-mem.c                   |    4 +
 drivers/usb/host/xhci-plat.c                  |    1 +
 drivers/usb/serial/ti_usb_3410_5052.c         |    3 +-
 drivers/usb/serial/ti_usb_3410_5052.h         |    4 +-
 fs/cifs/cifs_unicode.h                        |    8 +-
 fs/cifs/cifsencrypt.c                         |    6 +-
 fs/cifs/inode.c                               |    5 +
 fs/exec.c                                     |   16 +-
 fs/ext3/namei.c                               |    7 +-
 fs/ext4/extents.c                             |    4 +-
 fs/ext4/inode.c                               |    4 +-
 fs/ext4/mballoc.c                             |   11 +-
 fs/ext4/namei.c                               |    7 +-
 fs/hpfs/map.c                                 |    3 +-
 fs/hpfs/super.c                               |    8 +-
 fs/jbd2/journal.c                             |    3 +-
 fs/jbd2/transaction.c                         |    2 +-
 fs/nfsd/nfs4xdr.c                             |    2 +-
 fs/ocfs2/xattr.c                              |   10 ++
 fs/ubifs/dir.c                                |   54 ++++--
 include/linux/hugetlb.h                       |   16 ++
 include/linux/nbd.h                           |    1 +
 include/linux/perf_event.h                    |    3 +-
 include/linux/rculist_nulls.h                 |    7 +-
 include/linux/socket.h                        |    3 +
 kernel/cgroup.c                               |   25 ++-
 kernel/events/core.c                          |  233 +++++++++++++++++--------
 kernel/events/hw_breakpoint.c                 |    4 +-
 kernel/events/internal.h                      |    4 +
 kernel/futex.c                                |    3 +-
 kernel/irq/manage.c                           |    6 +-
 kernel/timer.c                                |    8 +-
 mm/hugetlb.c                                  |   17 ++
 mm/page_alloc.c                               |    4 +
 net/bluetooth/l2cap_core.c                    |    3 +
 net/ceph/auth_none.c                          |    6 +
 net/compat.c                                  |   13 +-
 net/core/sock.c                               |    6 +-
 net/ipv4/ip_gre.c                             |    2 +-
 net/ipv4/ipip.c                               |    2 +-
 net/ipv4/route.c                              |    7 +-
 net/ipv4/tcp.c                                |    7 +-
 net/ipv4/tcp_input.c                          |   23 +--
 net/ipv4/tcp_output.c                         |   10 +-
 net/ipv6/addrconf.c                           |    4 +-
 net/ipv6/ip6_output.c                         |    2 +-
 net/l2tp/l2tp_ppp.c                           |    6 +-
 net/netlabel/netlabel_domainhash.c            |   69 ++++++++
 net/packet/af_packet.c                        |    5 +-
 net/sctp/outqueue.c                           |    6 +-
 net/sctp/socket.c                             |    6 +
 net/socket.c                                  |   61 +++++--
 sound/usb/card.c                              |   22 ++-
 sound/usb/mixer.c                             |    1 +
 105 files changed, 791 insertions(+), 277 deletions(-)
---------------------------
Aaron Lu (1):
      libata-acpi: add back ACPI based hotplug functionality

Al Viro (1):
      ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()

Alex Deucher (1):
      drm/radeon: prevent crash in the ring space allocation

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

Axel Lin (1):
      drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq

Bart Van Assche (1):
      timer: Fix jiffies wrap behavior of round_jiffies_common()

Bartlomiej Zolnierkiewicz (1):
      drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()

Ben Hutchings (2):
      sd: Fix parsing of 'temporary ' cache mode prefix
      genirq: Fix can_request_irq() for IRQs without an action

Chris Metcalf (1):
      tilepro: work around module link error with gcc 4.7

Clemens Ladisch (1):
      ALSA: usb-audio: work around Android accessory firmware bug

Daniel Borkmann (2):
      net: sctp: fix NULL pointer dereference in socket destruction
      packet: packet_getname_spkt: make sure string is always 0-terminated

Eric Dumazet (5):
      tcp: fix tcp_md5_hash_skb_data()
      ipv6: fix possible crashes in ip6_cork_release()
      tcp: xps: fix reordering issues
      ip_tunnel: fix kernel panic with icmp_dest_unreach
      net: force a reload of first item in hlist_nulls_for_each_entry_rcu

Federico Vaga (1):
      net/core/sock.c: add missing VSOCK string in af_family_*_key_strings

Ferruh Yigit (1):
      Input: cyttsp - fix memcpy size param

Gao feng (1):
      ipv6: assign rt6_info to inet6_ifaddr in init_loopback

George Cherian (1):
      usb: host: xhci-plat: release mem region while removing module

Giuseppe CAVALLARO (1):
      net: phy: fix a bug when verify the EEE support

Greg Kroah-Hartman (1):
      MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information

Guillaume Nault (2):
      l2tp: Fix PPP header erasure and memory leak
      l2tp: Fix sendmsg() return value

Herbert Xu (1):
      crypto: algboss - Hold ref count on larval

J. Bruce Fields (1):
      nfsd4: fix decoding of compounds across page boundaries

Jan Kara (2):
      ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
      ext4: fix overflow when counting used blocks on 32-bit architectures

Jason Wang (1):
      drivers: hv: switch to use mb() instead of smp_mb()

Jerome Glisse (1):
      drm/radeon: update lockup tracking when scheduling in empty ring

Jiang Liu (1):
      PCI: Fix refcount issue in pci_create_root_bus() error recovery path

Jiri Pirko (2):
      team: check return value of team_get_port_by_index_rcu() for NULL
      team: move add to port list before port enablement

Joachim Eastwood (1):
      pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status

Jonathan Salwan (1):
      drivers/cdrom/cdrom.c: use kzalloc() for failing hardware

Junxiao Bi (1):
      ocfs2: xattr: fix inlined xattr reflink

Jörn Engel (1):
      target/iscsi: don't corrupt bh_count in iscsit_stop_time2retain_timer()

Kees Cook (3):
      charger-manager: Ensure event is not used as format string
      block: do not pass disk names as format strings
      crypto: sanitize argument for format string

Lai Jiangshan (1):
      clk: remove notifier from list before freeing it

Larry Finger (1):
      rtlwifi: rtl8192cu: Fix duplicate if test

Laszlo Ersek (1):
      xen/time: remove blocked time accounting from xen "clockchip"

Li Zefan (1):
      cgroup: fix umount vs cgroup_event_remove() race

Lv Zheng (1):
      ACPICA: Do not use extended sleep registers unless HW-reduced bit is set

Mathias Nyman (1):
      xhci: check for failed dma pool allocation

Michal Kubecek (1):
      ipv4: fix redirect handling for TCP packets

Mikulas Patocka (1):
      hpfs: better test for errors

Nandita Dukkipati (1):
      tcp: bug fix in proportional rate reduction.

Neil Horman (2):
      sctp: fully initialize sctp_outq in sctp_outq_init
      iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets

Nikolay Martynov (1):
      iwlwifi: dvm: fix chain noise calibration

Oleg Nesterov (1):
      hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

Paul Clements (1):
      nbd: correct disconnect behavior

Paul Moore (1):
      netlabel: improve domain mapping validation

Peter Zijlstra (2):
      perf: Fix perf mmap bugs
      perf: Fix mmap() accounting hole

Randy Dunlap (1):
      x86: fix build error and kconfig for ia32_emulation and binfmt

Roland Dreier (1):
      tcm_qla2xxx: Fix residual for underrun commands that fail

Shane Huang (1):
      ahci: remove pmp link online check in FBS EH

Simon Baatz (2):
      ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_page
      ARM: 7772/1: Fix missing flush_kernel_dcache_page() for noMMU

Stephane Eranian (1):
      perf: Disable monitoring on setuid processes for regular users

Steve French (2):
      use sensible file nlink values if unprovided
      Handle big endianness in NTLM (ntlmv2) authentication

Steven Rostedt (Red Hat) (1):
      Linux 3.6.11.7

Sujith Manoharan (1):
      ath9k_htc: Handle IDLE state transition properly

Takashi Iwai (1):
      ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam c310

Theodore Ts'o (3):
      jbd2: move superblock checksum calculation to jbd2_write_superblock()
      jbd2: fix theoretical race in jbd2__journal_restart
      ext4: don't allow ext4_free_blocks() to fail due to ENOMEM

Tyler Hicks (1):
      libceph: Fix NULL pointer dereference in auth client code

UCHINO Satoshi (1):
      usb: gadget: f_mass_storage: add missing memory barrier for thread_wakeup_needed

Wanpeng Li (1):
      mm/memory-hotplug: fix lowmem count overflow when offline pages

Wei Yongjun (1):
      gianfar: add missing iounmap() on error in gianfar_ptp_probe()

Yoshihiro Shimoda (1):
      net: sh_eth: fix incorrect RX length error if R8A7740

Zefan Li (2):
      dlci: acquire rtnl_lock before calling __dev_get_by_name()
      dlci: validate the net device in dlci_del()

Zhang Yi (1):
      futex: Take hugepages into account when generating futex_key

Zhanghaoyu (A) (1):
      KVM: x86: remove vcpu's CPL check in host-invoked XCR set

stephen hemminger (1):
      8139cp: reset BQL when ring tx ring cleared

----
