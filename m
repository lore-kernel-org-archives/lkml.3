Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3GDAQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 20:16:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46949 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab3GDAQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 20:16:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.4
Date: Wed,  3 Jul 2013 17:15:56 -0700
Message-Id: <1372896957-4387-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.4 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.3 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                                      |   2 +-
 arch/arm/Kconfig                              |  10 +
 arch/arm/include/asm/cacheflush.h             |   4 +-
 arch/arm/mach-kirkwood/ts219-setup.c          |   2 +-
 arch/arm/mm/cache-v7.S                        |   8 +
 arch/arm/mm/flush.c                           |  33 +++
 arch/arm/mm/nommu.c                           |   6 +
 arch/arm/mm/proc-v7.S                         |   4 +-
 arch/arm/plat-orion/common.c                  |  12 +-
 arch/arm64/kernel/perf_event.c                |   1 +
 arch/powerpc/include/asm/exception-64s.h      |   2 +-
 arch/powerpc/kernel/exceptions-64s.S          |   2 +-
 arch/powerpc/kernel/irq.c                     |   2 +-
 arch/powerpc/kernel/process.c                 |   4 +-
 arch/powerpc/kernel/traps.c                   |  10 +
 arch/s390/kernel/ipl.c                        |   8 +-
 arch/tile/lib/exports.c                       |   2 +
 arch/x86/Kconfig                              |   1 +
 arch/x86/kernel/kvmclock.c                    |   1 +
 arch/x86/kvm/x86.c                            |  23 +-
 drivers/ata/libata-acpi.c                     |  36 ++-
 drivers/ata/libata-core.c                     |   2 +
 drivers/ata/libata.h                          |   2 +
 drivers/bluetooth/ath3k.c                     |   4 +
 drivers/bluetooth/btusb.c                     |   2 +
 drivers/clk/clk.c                             |   1 +
 drivers/gpu/drm/gma500/framebuffer.c          |   4 +-
 drivers/gpu/drm/radeon/radeon_gart.c          |   6 +-
 drivers/gpu/drm/radeon/radeon_ring.c          |   7 +
 drivers/input/touchscreen/cyttsp_core.c       |   2 +-
 drivers/iommu/amd_iommu.c                     |   3 +
 drivers/net/ethernet/broadcom/tg3.c           |  42 +++-
 drivers/net/ethernet/freescale/gianfar_ptp.c  |   1 +
 drivers/net/ethernet/realtek/8139cp.c         |   1 +
 drivers/net/ethernet/realtek/r8169.c          |  68 ++++--
 drivers/net/ethernet/renesas/sh_eth.c         |  15 +-
 drivers/net/phy/phy.c                         |   2 +-
 drivers/net/team/team.c                       |   2 +-
 drivers/net/team/team_mode_roundrobin.c       |   2 +
 drivers/net/tun.c                             |   6 +
 drivers/net/usb/qmi_wwan.c                    | 101 +++++++++
 drivers/net/vxlan.c                           |  17 +-
 drivers/net/wan/dlci.c                        |  26 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c       |   2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c       |   1 +
 drivers/net/wireless/rt2x00/rt2800lib.c       |  29 ++-
 drivers/net/xen-netback/netback.c             | 311 +++++++++++++++++++++-----
 drivers/net/xen-netfront.c                    |  17 +-
 drivers/regulator/core.c                      |  10 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c            |   6 +-
 drivers/staging/iio/light/tsl2x7x_core.c      |   9 +-
 drivers/target/iscsi/iscsi_target_erl0.c      |   4 +-
 drivers/usb/dwc3/gadget.c                     |   1 +
 drivers/usb/serial/f81232.c                   |   8 +-
 drivers/usb/serial/pl2303.c                   |  10 +-
 drivers/usb/serial/spcp8x5.c                  |  10 +-
 drivers/usb/serial/ti_usb_3410_5052.c         |   3 +-
 drivers/usb/serial/ti_usb_3410_5052.h         |   4 +-
 drivers/vhost/net.c                           |   3 +-
 drivers/xen/events.c                          |  19 +-
 fs/ceph/mds_client.c                          |  25 ++-
 fs/jfs/inode.c                                |   2 +-
 fs/jfs/jfs_logmgr.c                           |   3 +-
 fs/ncpfs/dir.c                                |   9 -
 fs/nfsd/nfs4proc.c                            |  15 +-
 fs/reiserfs/dir.c                             |   2 +
 fs/reiserfs/inode.c                           |   9 +-
 fs/reiserfs/xattr.c                           |  14 +-
 fs/reiserfs/xattr_acl.c                       |   3 +
 include/linux/ceph/auth.h                     |  18 ++
 include/linux/rculist_nulls.h                 |   7 +-
 include/linux/socket.h                        |   3 +
 include/xen/interface/io/netif.h              |  19 ++
 kernel/Makefile                               |   2 +-
 kernel/events/core.c                          |   1 +
 kernel/events/hw_breakpoint.c                 |   6 +-
 lib/idr.c                                     |  36 +--
 lib/klist.c                                   |   2 +-
 net/bluetooth/l2cap_core.c                    |   5 +-
 net/ceph/auth.c                               | 117 ++++++++--
 net/ceph/auth_x.c                             |  24 +-
 net/ceph/auth_x.h                             |   1 +
 net/ceph/messenger.c                          |   3 +-
 net/ceph/mon_client.c                         |   7 +-
 net/ceph/osd_client.c                         |  27 +--
 net/compat.c                                  |  13 +-
 net/core/sock.c                               |   6 +-
 net/ipv4/ip_gre.c                             |   2 +-
 net/ipv4/ipip.c                               |   2 +-
 net/ipv4/route.c                              |   7 +-
 net/ipv4/tcp.c                                |   7 +-
 net/ipv4/tcp_input.c                          |  23 +-
 net/ipv4/tcp_output.c                         |  10 +-
 net/ipv6/addrconf.c                           |   4 +-
 net/ipv6/ip6_output.c                         |   2 +-
 net/l2tp/l2tp_ppp.c                           |   6 +-
 net/netlabel/netlabel_domainhash.c            |  69 ++++++
 net/netrom/af_netrom.c                        |   2 +-
 net/packet/af_packet.c                        |   5 +-
 net/sctp/outqueue.c                           |   8 +-
 net/sctp/socket.c                             |   6 +
 net/socket.c                                  |  61 +++--
 sound/usb/card.c                              |  22 +-
 sound/usb/mixer.c                             |   1 +
 105 files changed, 1221 insertions(+), 333 deletions(-)

Aaron Lu (1):
      libata-acpi: add back ACPI based hotplug functionality

Anders Hammarquist (1):
      USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable

Anderson Lizardo (1):
      Bluetooth: Fix crash in l2cap_build_cmd() with small MTU

Andrzej Hajda (1):
      regulator: fixed regulator_bulk_enable unwinding code

Andy Lutomirski (1):
      net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg

Benjamin Herrenschmidt (1):
      powerpc: Fix missing/delayed calls to irq_work

Bjørn Mork (3):
      net: qmi_wwan: fixup missing ethernet header (firmware bug workaround)
      net: qmi_wwan: fixup destination address (firmware bug workaround)
      net: qmi_wwan: prevent duplicate mac address on link (firmware bug workaround)

Chris Metcalf (1):
      tilepro: work around module link error with gcc 4.7

Clemens Ladisch (1):
      ALSA: usb-audio: work around Android accessory firmware bug

Daniel Borkmann (2):
      net: sctp: fix NULL pointer dereference in socket destruction
      packet: packet_getname_spkt: make sure string is always 0-terminated

Dave Chiluk (1):
      ncpfs: fix rmdir returns Device or resource busy

Dave Kleikamp (1):
      jfs: fix a couple races

David Cohen (1):
      MODSIGN: do not send garbage to stderr when enabling modules signature

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

Giuseppe CAVALLARO (1):
      net: phy: fix a bug when verify the EEE support

Gregory CLEMENT (2):
      ARM: plat-orion: Fix num_resources and id for ge10 and ge11
      ARM: 7754/1: Fix the CPU ID and the mask associated to the PJ4B

Guillaume Nault (2):
      l2tp: Fix PPP header erasure and memory leak
      l2tp: Fix sendmsg() return value

Igor Mammedov (1):
      x86: kvmclock: zero initialize pvclock shared memory area

J. Bruce Fields (1):
      nfsd4: don't allow owner override on 4.1 CLAIM_FH opens

Jaganath Kanakkassery (1):
      Bluetooth: Fix invalid length check in l2cap_information_rsp()

Jason Wang (3):
      tuntap: forbid changing mq flag for persistent device
      vhost_net: clear msg.control for non-zerocopy case during tx
      tuntap: set SOCK_ZEROCOPY flag during open

Jed Davis (1):
      perf: arm64: Record the user-mode PC in the call chain.

Jeff Mahoney (3):
      reiserfs: fix deadlock with nfs racing on create/lookup
      reiserfs: fix problems with chowning setuid file w/ xattrs
      reiserfs: fix spurious multiple-fill in reiserfs_readdir_dentry

Jerome Glisse (2):
      drm/radeon: do not try to uselessly update virtual memory pagetable
      drm/radeon: update lockup tracking when scheduling in empty ring

Jiri Pirko (2):
      team: check return value of team_get_port_by_index_rcu() for NULL
      team: move add to port list before port enablement

Johan Hovold (3):
      USB: f81232: fix device initialisation at open
      USB: spcp8x5: fix device initialisation at open
      USB: pl2303: fix device initialisation at open

Jon Medhurst (1):
      ARM: 7752/1: errata: LoUIS bit field in CLIDR register is incorrect

Josh Boyer (1):
      Bluetooth: Add support for atheros 04ca:3004 device to ath3k

Jörn Engel (1):
      target/iscsi: don't corrupt bh_count in iscsit_stop_time2retain_timer()

Kamal Mostafa (1):
      Linux 3.8.13.4

Keir Fraser (1):
      xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.

Lai Jiangshan (1):
      clk: remove notifier from list before freeing it

Marcelo Tosatti (1):
      KVM: x86: fix deadlock in clock-in-progress request handling

Martin Michlmayr (1):
      Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x

Michael Ellerman (1):
      powerpc: Fix stack overflow crash in resume_kernel when ftracing

Michael Holzheu (1):
      s390/ipl: Fix FCP WWPN and LUN format strings for read

Michal Kubecek (1):
      ipv4: fix redirect handling for TCP packets

Nandita Dukkipati (1):
      tcp: bug fix in proportional rate reduction.

Neil Horman (1):
      sctp: fully initialize sctp_outq in sctp_outq_init

Nikolay Martynov (1):
      iwlwifi: dvm: fix chain noise calibration

Nithin Sujir (2):
      tg3: Skip powering down function 0 on certain serdes devices
      tg3: Wait for boot code to finish after power on

Oleg Nesterov (2):
      hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
      hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

Patrik Jakobsson (1):
      drm/gma500: Increase max resolution for mode setting

Paul Mackerras (1):
      powerpc: Fix emulation of illegal instructions on PowerNV platform

Paul Moore (1):
      netlabel: improve domain mapping validation

Pratyush Anand (1):
      usb: dwc3: gadget: req->queued must be forced to false in cleanup

Randy Dunlap (1):
      x86: fix build error and kconfig for ia32_emulation and binfmt

Roland Dreier (1):
      tcm_qla2xxx: Fix residual for underrun commands that fail

Sage Weil (5):
      libceph: clear messenger auth_retry flag when we authenticate
      libceph: fix authorizer invalidation
      libceph: add update_authorizer auth method
      libceph: wrap auth ops in wrapper functions
      libceph: wrap auth methods in a mutex

Shuduo Sang (1):
      iwlwifi: add new pci id for 6x35 series

Simon Baatz (2):
      ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_page
      ARM: 7772/1: Fix missing flush_kernel_dcache_page() for noMMU

Sridhar Samudrala (1):
      vxlan: Update vxlan fdb 'used' field after each usage

Stanislaw Gruszka (1):
      rt2800: fix RT5390 & RT3290 TX power settings regression

Sujith Manoharan (1):
      ath9k_htc: Handle IDLE state transition properly

Sunguk Lee (1):
      Bluetooth: Device 0cf3:3008 should map AR 3012

Suravee Suthikulpanit (1):
      iommu/amd: Re-enable IOMMU event log interrupt after handling.

Takashi Iwai (1):
      ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam c310

Tejun Heo (1):
      idr: fix top layer handling

Wei Liu (7):
      xen-netback: remove skb in xen_netbk_alloc_page
      xen-netback: coalesce slots in TX path and fix regressions
      xen-netback: don't disconnect frontend when seeing oversize packet
      xen-netback: remove redundent parameter in netbk_count_requests
      xen-netback: avoid allocating variable size array on stack
      xen-netback: better names for thresholds
      xen-netfront: reduce gso_max_size to account for max TCP header

Wei Yongjun (4):
      perf: Fix error return code
      netrom: fix invalid use of sizeof in nr_recvmsg()
      staging:iio:light:tsl2x7x: fix the error handling in tsl2x7x_probe()
      gianfar: add missing iounmap() on error in gianfar_ptp_probe()

Yoshihiro Shimoda (1):
      net: sh_eth: fix incorrect RX length error if R8A7740

Zefan Li (2):
      dlci: acquire rtnl_lock before calling __dev_get_by_name()
      dlci: validate the net device in dlci_del()

Zhanghaoyu (A) (1):
      KVM: x86: remove vcpu's CPL check in host-invoked XCR set

françois romieu (2):
      r8169: honor jumbo settings when chipset is requested to start.
      r8169: fix offloaded tx checksum for small packets.

stephen hemminger (2):
      xen-netback: fix sparse warning
      8139cp: reset BQL when ring tx ring cleared

wang, biao (1):
      klist: del waiter from klist_remove_waiters before wakeup waitting process

