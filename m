Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbaGCJUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:20:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbaGCJUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:20:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.11.y.z extended stable] Linux 3.11.10.13 stable review
Date: Thu,  3 Jul 2014 10:17:23 +0100
Message-Id: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.11.10.13 stable kernel.

This version contains 198 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.11.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.11.y-review

The review period for version 3.11.10.13 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.11.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 Documentation/ABI/testing/ima_policy               |   2 +-
 Documentation/vm/hwpoison.txt                      |   5 +
 arch/arm/kernel/stacktrace.c                       |  18 ++-
 arch/arm/mach-at91/sysirq_mask.c                   |  22 +--
 arch/arm/mach-omap1/board-h2.c                     |   2 +-
 arch/arm/mach-omap1/board-h3.c                     |   2 +-
 arch/arm/mach-omap1/board-innovator.c              |   2 +-
 arch/arm/mach-omap1/board-osk.c                    |   2 +-
 arch/arm/mm/proc-v7-3level.S                       |  18 ++-
 arch/arm64/include/asm/dma-mapping.h               |   2 -
 arch/arm64/kernel/ptrace.c                         |   4 +
 arch/ia64/hp/common/sba_iommu.c                    |  66 ++++----
 arch/mips/kvm/kvm_mips.c                           |   2 +-
 arch/powerpc/include/asm/switch_to.h               |   8 +-
 arch/powerpc/include/asm/systbl.h                  |   2 +-
 arch/powerpc/include/uapi/asm/cputable.h           |   1 +
 arch/powerpc/kernel/cputable.c                     |   3 +-
 arch/powerpc/kernel/entry_64.S                     |   6 -
 arch/powerpc/kernel/legacy_serial.c                |  17 ++-
 arch/powerpc/kernel/process.c                      |   8 +-
 arch/powerpc/kernel/setup-common.c                 |  16 +-
 arch/powerpc/mm/hash_utils_64.c                    |  31 ++--
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   1 +
 arch/s390/include/asm/lowcore.h                    |  11 +-
 arch/sparc/net/bpf_jit_comp.c                      |   8 +-
 arch/x86/kernel/entry_32.S                         |  15 +-
 arch/x86/kvm/lapic.c                               |  62 +++++---
 arch/x86/syscalls/syscall_64.tbl                   |   6 +-
 crypto/crypto_user.c                               |   2 +-
 drivers/acpi/acpica/utstring.c                     |   2 +-
 drivers/acpi/bus.c                                 |   7 +
 drivers/ata/ahci.c                                 |   4 +
 drivers/base/power/opp.c                           |   4 +-
 drivers/block/mtip32xx/mtip32xx.c                  | 123 +++++++++++----
 drivers/bluetooth/hci_ldisc.c                      |  24 ++-
 drivers/bluetooth/hci_uart.h                       |   1 +
 drivers/char/applicom.c                            |   1 -
 drivers/connector/cn_proc.c                        |   2 +-
 drivers/extcon/extcon-max77693.c                   |   4 +-
 drivers/extcon/extcon-max8997.c                    |   2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |  48 +++---
 drivers/gpu/drm/radeon/atombios_dp.c               |  17 ++-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   5 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |   2 +-
 drivers/hid/hid-core.c                             |  12 +-
 drivers/hv/hv_balloon.c                            |  29 +++-
 drivers/hwmon/ina2xx.c                             |   7 +-
 drivers/iio/adc/at91_adc.c                         |  16 +-
 drivers/iio/adc/max1363.c                          |  16 +-
 drivers/iio/magnetometer/ak8975.c                  |   9 +-
 drivers/infiniband/core/user_mad.c                 |  75 +++++----
 drivers/infiniband/hw/cxgb4/cq.c                   |   3 +-
 drivers/infiniband/hw/cxgb4/user.h                 |   1 +
 drivers/infiniband/hw/ipath/ipath_diag.c           |   4 +
 drivers/infiniband/hw/mlx5/cq.c                    |  13 +-
 drivers/infiniband/hw/mlx5/srq.c                   |  14 +-
 drivers/infiniband/hw/mlx5/user.h                  |   2 +
 drivers/infiniband/hw/qib/qib_mad.c                |   2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  61 ++++----
 drivers/infiniband/ulp/isert/ib_isert.h            |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   6 +
 drivers/input/mouse/elantech.c                     |  27 +++-
 drivers/md/dm-thin.c                               |   3 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |   6 +
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |   6 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |  15 ++
 drivers/media/usb/dvb-usb/dib0700_devices.c        |  12 +-
 drivers/media/usb/stk1160/stk1160-core.c           |  10 +-
 drivers/media/usb/stk1160/stk1160.h                |   1 -
 drivers/media/usb/uvc/uvc_video.c                  |  15 +-
 drivers/mfd/twl4030-madc.c                         |   1 +
 drivers/misc/mei/hw-me.c                           |  16 +-
 drivers/mtd/nand/fsl_elbc_nand.c                   |  14 ++
 drivers/mtd/nand/omap2.c                           |   2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          | 170 ++++++++++++---------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   1 +
 drivers/net/macvlan.c                              |   1 -
 drivers/net/team/team.c                            |   7 +-
 drivers/net/usb/qmi_wwan.c                         |   7 +-
 drivers/net/vxlan.c                                |   4 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  26 ++--
 drivers/pci/quirks.c                               |   1 +
 drivers/rtc/rtc-at91rm9200.c                       |  16 +-
 drivers/scsi/scsi_netlink.c                        |   2 +-
 drivers/staging/iio/light/tsl2x7x_core.c           |   8 +-
 drivers/staging/tidspbridge/core/dsp-clock.c       |   4 +-
 drivers/target/iscsi/iscsi_target.c                |  17 ++-
 drivers/target/iscsi/iscsi_target_auth.c           |  10 ++
 drivers/target/target_core_rd.c                    |   2 +-
 drivers/target/target_core_sbc.c                   |   4 +-
 drivers/target/target_core_spc.c                   |   9 +-
 drivers/target/target_core_transport.c             |  29 +++-
 drivers/tty/serial/8250/8250_dw.c                  |  73 +++++++--
 drivers/usb/class/cdc-acm.c                        | 104 ++++++++-----
 drivers/usb/class/cdc-acm.h                        |   2 +-
 drivers/usb/dwc3/gadget.c                          |   4 +
 drivers/usb/gadget/inode.c                         |   2 +-
 drivers/usb/host/pci-quirks.c                      |  19 ++-
 drivers/usb/misc/usbtest.c                         |  40 ++++-
 drivers/usb/phy/phy-isp1301-omap.c                 |   2 +-
 drivers/usb/serial/bus.c                           |  14 +-
 drivers/usb/serial/option.c                        |  11 +-
 drivers/usb/serial/qcserial.c                      |  21 +++
 drivers/usb/serial/sierra.c                        |  55 +++++--
 drivers/usb/serial/usb_wwan.c                      | 125 ++++++++-------
 drivers/video/matrox/matroxfb_base.h               |   2 +-
 drivers/watchdog/ath79_wdt.c                       |  10 ++
 drivers/watchdog/kempld_wdt.c                      |   2 +-
 drivers/watchdog/sp805_wdt.c                       |   4 +-
 fs/aio.c                                           |   6 +-
 fs/btrfs/extent_io.c                               |   1 +
 fs/ext4/ext4.h                                     |   3 +-
 fs/ext4/inode.c                                    |   6 +-
 fs/ext4/mballoc.c                                  |   2 +-
 fs/ext4/page-io.c                                  |  32 ++--
 fs/nfs/inode.c                                     |  26 ++--
 fs/nfs/nfs4filelayout.c                            |   2 +-
 fs/nfs/super.c                                     |   1 +
 fs/nfsd/nfs4state.c                                |   2 +-
 fs/nfsd/nfs4xdr.c                                  |   4 +-
 fs/nfsd/nfscache.c                                 |  53 ++-----
 fs/reiserfs/inode.c                                |   8 +-
 fs/ubifs/file.c                                    |   3 +-
 fs/ubifs/shrinker.c                                |   1 -
 include/linux/if_team.h                            |   1 +
 include/linux/init_task.h                          |   2 +
 include/linux/irqdesc.h                            |   4 +
 include/linux/mmzone.h                             |   6 +-
 include/linux/netlink.h                            |  14 +-
 include/linux/page-flags.h                         |  12 +-
 include/linux/pageblock-flags.h                    |  37 ++++-
 include/linux/ptrace.h                             |  32 ++++
 include/linux/sched.h                              |  12 ++
 include/linux/sock_diag.h                          |   2 +-
 include/net/inetpeer.h                             |   9 +-
 include/net/sock.h                                 |   5 +
 include/sound/core.h                               |   2 +
 include/target/iscsi/iscsi_transport.h             |   3 +-
 include/target/target_core_backend.h               |   1 +
 include/uapi/sound/compress_offload.h              |   2 +-
 kernel/audit.c                                     |   4 +-
 kernel/exit.c                                      |   1 +
 kernel/fork.c                                      |  17 ++-
 kernel/irq/manage.c                                |   4 +-
 kernel/irq/spurious.c                              | 106 ++++++++++++-
 kernel/rtmutex-debug.h                             |   5 +
 kernel/rtmutex.c                                   |  33 +++-
 kernel/rtmutex.h                                   |   5 +
 kernel/time/tick-sched.c                           |   4 +-
 lib/idr.c                                          |   8 +-
 lib/lzo/lzo1x_decompress_safe.c                    |  62 +++++---
 lib/nlattr.c                                       |   4 +-
 mm/memory-failure.c                                |  73 ++++++---
 mm/page-writeback.c                                |  11 +-
 mm/page_alloc.c                                    |  52 ++++---
 mm/rmap.c                                          |   8 +-
 mm/vmscan.c                                        |  46 +++++-
 net/bluetooth/l2cap_sock.c                         |   5 +-
 net/can/gw.c                                       |   4 +-
 net/core/dev.c                                     |   5 +-
 net/core/rtnetlink.c                               |  43 ++++--
 net/core/sock.c                                    |  49 ++++++
 net/core/sock_diag.c                               |   4 +-
 net/dcb/dcbnl.c                                    |   2 +-
 net/decnet/dn_dev.c                                |   4 +-
 net/decnet/dn_fib.c                                |   4 +-
 net/decnet/netfilter/dn_rtmsg.c                    |   2 +-
 net/ipv4/datagram.c                                |  20 ++-
 net/ipv4/ipip.c                                    |   5 +-
 net/ipv4/netfilter/ipt_ULOG.c                      |   7 +-
 net/ipv4/tcp_input.c                               |  11 +-
 net/ipv6/ip6_tunnel.c                              |   1 +
 net/ipv6/output_core.c                             |  11 +-
 net/ipv6/sit.c                                     |   5 +-
 net/mac80211/debugfs_netdev.c                      |   6 +-
 net/mac80211/iface.c                               |   1 -
 net/mac80211/sta_info.c                            |   1 +
 net/netfilter/ipvs/ip_vs_core.c                    |  15 +-
 net/netfilter/nfnetlink.c                          |   2 +-
 net/netlink/af_netlink.c                           |  80 +++++++++-
 net/netlink/genetlink.c                            |   2 +-
 net/packet/diag.c                                  |   7 +-
 net/phonet/pn_netlink.c                            |   8 +-
 net/sched/act_api.c                                |   2 +-
 net/sched/cls_api.c                                |   2 +-
 net/sched/sch_api.c                                |   6 +-
 net/sctp/associola.c                               |   2 +-
 net/sunrpc/svc_xprt.c                              |   2 +
 net/tipc/netlink.c                                 |   2 +-
 net/xfrm/xfrm_user.c                               |   2 +-
 security/integrity/evm/evm_main.c                  |  12 +-
 security/integrity/ima/ima_api.c                   |   9 +-
 security/integrity/ima/ima_crypto.c                |  32 +++-
 security/integrity/ima/ima_main.c                  |   5 +-
 security/integrity/ima/ima_policy.c                |   6 +-
 security/integrity/integrity.h                     |   1 +
 sound/core/control.c                               |  78 ++++++----
 sound/core/init.c                                  |   1 +
 sound/pci/hda/patch_realtek.c                      |  24 +++
 sound/soc/codecs/max98090.c                        |   3 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/powerpc/Makefile           |  39 +++++
 tools/testing/selftests/powerpc/tm/Makefile        |  15 ++
 .../testing/selftests/powerpc/tm/tm-resched-dscr.c |  90 +++++++++++
 204 files changed, 2280 insertions(+), 893 deletions(-)

Alan Stern (2):
      USB: EHCI: avoid BIOS handover on the HASEE E200
      USB: usbtest: add a timeout for scatter-gather tests

Aleksander Morgado (2):
      usb: qcserial: add Netgear AirCard 341U
      usb: qcserial: add additional Sierra Wireless QMI devices

Alessandro Miceli (2):
      [media] rtl28xxu: add [1b80:d39d] Sveon STV20
      [media] rtl28xxu: add [1b80:d3af] Sveon STV27

Alex Deucher (4):
      drm/radeon: fix typo in radeon_connector_is_dp12_capable()
      drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices
      drm/radeon/atom: fix dithering on certain panels
      drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi

Alexei Starovoitov (2):
      net: filter: fix typo in sparc BPF JIT
      net: filter: fix sparc32 typo

Andreas Schrägle (1):
      ahci: add PCI ID for Marvell 88SE91A0 SATA Controller

Andy Lutomirski (1):
      x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

Anton Blanchard (2):
      powerpc: 64bit sendfile is capped at 2GB
      powerpc: Make logical to real cpu mapping code endian safe

Antti Palosaari (1):
      [media] rtl28xxu: add 15f4:0131 Astrometa DVB-T2

Arik Nemtsov (1):
      mac80211: don't check netdev state for debugfs read/write

Asai Thambi S P (3):
      mtip32xx: Increase timeout for STANDBY IMMEDIATE command
      mtip32xx: Remove dfs_parent after pci unregister
      mtip32xx: Fix ERO and NoSnoop values in PCIe upstream on AMD systems

Bart Van Assche (3):
      IB/srp: Fix a sporadic crash triggered by cable pulling
      IB/umad: Fix error handling
      IB/umad: Fix use-after-free on close

Benjamin Herrenschmidt (2):
      powerpc/serial: Use saner flags when creating legacy ports
      powerpc: Add AT_HWCAP2 to indicate V.CRYPTO category support

Benjamin LaHaise (2):
      aio: fix aio request leak when events are reaped by userspace
      aio: fix kernel memory disclosure in io_getevents() introduced in v3.10

Bjørn Mork (1):
      net: qmi_wwan: add Olivetti Olicard modems

Boris BREZILLON (2):
      rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
      ARM: at91: fix at91_sysirq_mask_rtc for sam9x5 SoCs

Brian Healy (1):
      [media] rtl28xxu: add 1b80:d395 Peak DVB-T USB

Chander Kashyap (1):
      PM / OPP: fix incorrect OPP count handling in of_init_opp_table

Chris Mason (1):
      Btrfs: fix double free in find_lock_delalloc_range

Christian Borntraeger (1):
      s390/lowcore: reserve 96 bytes for IRB in lowcore

Christoph Hellwig (1):
      nfsd: getattr for FATTR4_WORD0_FILES_AVAIL needs the statfs buffer

Cong Wang (1):
      vxlan: use dev->needed_headroom instead of dev->hard_header_len

Dan Carpenter (3):
      RDMA/cxgb4: Fix four byte info leak in c4iw_create_cq()
      iio: adc: at91: signedness bug in at91_adc_get_trigger_value_by_name()
      applicom: dereferencing NULL on error path

David Binderman (1):
      ACPICA: utstring: Check array index bound before use.

David Henningsson (1):
      ALSA: hda - Add quirk for external mic on Lifebook U904

Dennis Dalessandro (1):
      IB/ipath: Translate legacy diagpkt into newer extended diagpkt

Dmitry Kasatkin (1):
      ima: introduce ima_kernel_read()

Dmitry Popov (1):
      ipip, sit: fix ipv4_{update_pmtu,redirect} calls

Emmanuel Grumbach (1):
      iwlwifi: pcie: try to get ownership several times

Eric Dumazet (3):
      net: fix inet_getid() and ipv6_select_ident() bugs
      net: force a list_del() in unregister_netdevice_many()
      ipv4: fix a race in ip4_datagram_release_cb()

Eric W. Biederman (6):
      netlink: Rename netlink_capable netlink_allowed
      net: Move the permission check in sock_diag_put_filterinfo to packet_diag_dump
      net: Add variants of capable for use on on sockets
      net: Add variants of capable for use on netlink messages
      net: Use netlink_ns_capable to verify the permisions of netlink messages
      netlink: Only check file credentials for implicit destinations

Ezequiel Garcia (1):
      [media] media: stk1160: Avoid stack-allocated buffer for control URBs

Fabio Baltieri (1):
      hwmon: (ina2xx) Cast to s16 on shunt and current regs

Felipe Balbi (2):
      usb: dwc3: gadget: clear stall when disabling endpoint
      bluetooth: hci_ldisc: fix deadlock condition

Felix Fietkau (1):
      mac80211: fix a memory leak on sta rate selection table

Gabor Juhos (1):
      watchdog: ath79_wdt: avoid spurious restarts on AR934x

Gavin Shan (1):
      powerpc/pseries: Fix overwritten PE state

Greg Kroah-Hartman (1):
      lzo: properly check for overruns

H. Peter Anvin (1):
      x86-32, espfix: Remove filter for espfix32 due to race

Hans de Goede (2):
      Input: elantech - deal with clickpads reporting right button events
      Input: elantech - don't set bit 1 of reg_10 when the no_hw_res quirk is set

Huang Rui (1):
      usb: usbtest: fix unlink write error with pattern 1

Hugh Dickins (1):
      mm: fix sleeping function warning from __put_anon_vma

J. Bruce Fields (1):
      nfsd4: fix FREE_STATEID lockowner leak

James Hogan (2):
      MIPS: KVM: Allocate at least 16KB for exception handlers
      serial: 8250_dw: Fix LCR workaround regression

Jan Kara (1):
      ext4: fix zeroing of page during writeback

Jan Vcelak (1):
      [media] rtl28xxu: add USB ID for Genius TVGo DVB-T03

Jeff Layton (2):
      nfsd: don't try to reuse an expired DRC entry off the list
      nfsd: don't halt scanning the DRC LRU list when there's an RC_INPROG entry

Jeff Mahoney (1):
      reiserfs: call truncate_setsize under tailpack mutex

Jiang Liu (1):
      sba_iommu: fix section mismatch

Jianguo Wu (1):
      ARM: 8037/1: mm: support big-endian page tables

Jiri Pirko (1):
      team: fix mtu setting

Johan Hovold (19):
      USB: sierra: fix AA deadlock in open error path
      USB: sierra: fix use after free at suspend/resume
      USB: sierra: fix urb and memory leak in resume error path
      USB: sierra: fix urb and memory leak on disconnect
      USB: sierra: fix remote wakeup
      USB: option: fix runtime PM handling
      USB: usb_wwan: fix write and suspend race
      USB: usb_wwan: fix potential NULL-deref at resume
      USB: usb_wwan: fix potential blocked I/O after resume
      USB: cdc-acm: fix write and suspend race
      USB: cdc-acm: fix write and resume race
      USB: cdc-acm: fix broken runtime suspend
      USB: cdc-acm: fix runtime PM for control messages
      USB: cdc-acm: fix shutdown and suspend race
      USB: cdc-acm: fix potential urb leak and PM imbalance in write
      USB: cdc-acm: fix I/O after failed open
      USB: cdc-acm: fix runtime PM imbalance at shutdown
      USB: usb_wwan: fix urb leak at shutdown
      USB: serial: fix potential runtime pm imbalance at device remove

Johannes Weiner (1):
      mm: vmscan: clear kswapd's special reclaim powers before exiting

Jonathan Cameron (1):
      iio:adc:max1363 incorrect resolutions for max11604, max11605, max11610 and max11611.

Jukka Taimisto (1):
      Bluetooth: Fix L2CAP deadlock

Jérôme Carretero (1):
      ahci: Add Device ID for HighPoint RocketRaid 642L

K. Y. Srinivasan (1):
      Drivers: hv: balloon: Ensure pressure reports are posted regularly

Kailang Yang (2):
      ALSA: hda/realtek - Add support of ALC891 codec
      ALSA: hda/realtek - Add more entry for enable HP mute led

Kees Cook (1):
      HID: core: fix validation of report id 0

Krzysztof Kozlowski (2):
      extcon: max77693: Fix two NULL pointer exceptions on missing pdata
      extcon: max8997: Fix NULL pointer exception on missing pdata

Lai Jiangshan (1):
      idr: fix overflow bug during maximum ID calculation at maximum height

Lars-Peter Clausen (5):
      ALSA: control: Protect user controls against concurrent access
      ALSA: control: Fix replacing user controls
      ALSA: control: Don't access controls outside of protected regions
      ALSA: control: Handle numid overflow
      ALSA: control: Make sure that id->index does not overflow

Liam Girdwood (1):
      ASoC: max98090: Fix reset at resume time

Lukas Czerner (1):
      dm thin: update discard_granularity to reflect the thin-pool blocksize

Lv Zheng (1):
      ACPI: Fix conflict between customized DSDT and DSDT local copy

Mario Schuknecht (1):
      staging: iio: tsl2x7x_core: fix proximity treshold

Mateusz Guzik (1):
      NFS: populate ->net in mount data when remounting

Mathias Krause (1):
      netfilter: ipt_ULOG: fix info leaks

Matthew Dempsky (1):
      ptrace: fix fork event messages across pid namespaces

Maurizio Lombardi (1):
      ext4: fix wrong assert in ext4_mb_normalize_request()

Mel Gorman (2):
      mm: vmscan: do not throttle based on pfmemalloc reserves if node has no ZONE_NORMAL
      mm: page_alloc: use word-based accesses for get/set pageblock bitmaps

Michael Ellerman (3):
      powerpc/mm: Check paca psize is up to date for huge mappings
      selftests: Add infrastructure for powerpc selftests
      powerpc/perf: Ensure all EBB register state is cleared on fork()

Michael Krufky (1):
      [media] dib0700: add support for PCTV 2002e & PCTV 2002e SE

Michael Neuling (1):
      powerpc: Don't setup CPUs with bad status

Michal Schmidt (2):
      netlink: rate-limit leftover bytes warning and print process name
      rtnetlink: fix userspace API breakage for iproute2 < v3.9.0

Mike Frysinger (1):
      x86, x32: Use compat shims for io_{setup,submit}

Mike Marciniszyn (1):
      IB/qib: Fix port in pkey change event

Mikulas Patocka (1):
      matroxfb: perform a dummy read of M_STATUS

Mimi Zohar (2):
      ima: audit log files opened with O_DIRECT flag
      evm: prohibit userspace writing 'security.evm' HMAC value

Namjae Jeon (1):
      ext4: fix data integrity sync in ordered mode

Naoya Horiguchi (1):
      mm/memory-failure.c: support use of a dedicated thread to handle SIGBUS(BUS_MCEERR_AO)

Nicholas Bellinger (5):
      iscsi-target: Reject mutual authentication with reflected CHAP_C
      target: Set CMD_T_ACTIVE bit for Task Management Requests
      target: Use complete_all for se_cmd->t_transport_stop_comp
      iscsi-target: Fix ABORT_TASK + connection reset iscsi_queue_req memory leak
      target: Explicitly clear ramdisk_mcp backend pages

Oleg Nesterov (1):
      introduce for_each_thread() to replace the buggy while_each_thread()

Olivier Langlois (1):
      [media] uvcvideo: Fix clock param realtime setting

Paolo Bonzini (1):
      KVM: lapic: sync highest ISR to hardware apic on EOI

Paul Bolle (3):
      staging: tidspbridge: check for CONFIG_SND_OMAP_SOC_MCBSP
      usb: gadget: rename CONFIG_USB_GADGET_PXA25X
      ARM: OMAP: replace checks for CONFIG_USB_GADGET_OMAP

Paul Kocialkowski (1):
      twl4030-madc: Request processed values in twl4030_get_madc_conversion

Pekon Gupta (1):
      mtd: eLBC NAND: fix subpage write support

Peter Christensen (1):
      ipvs: Fix panic due to non-linear skb

Peter Meerwald (1):
      iio: Fix endianness issue in ak8975_read_axis()

Rafael J. Wysocki (1):
      ACPI / ia64 / sba_iommu: Restore the working initialization ordering

Robert Backhaus (1):
      [media] Add USB IDs for Winfast DTV Dongle Mini-D

Roger Quadros (1):
      usb: usbtest: Add timetout to simple_io()

Roland Dreier (1):
      target: Report correct response length for some commands

Russell King (1):
      ARM: stacktrace: avoid listing stacktrace functions in stacktrace

Sagi Grimberg (5):
      Target/iser: Bail from accept_np if np_thread is trying to close
      Target/iser: Fix hangs in connection teardown
      Target/iser: Improve cm events handling
      Target/iser: Wait for proper cleanup before unloading
      Target/iscsi: Fix sendtargets response pdu for iser transport

Sam bobroff (1):
      powerpc: Correct DSCR during TM context switch

Scott Wood (1):
      powerpc: Don't skip ePAPR spin-table CPUs

Suravee Suthikulpanit (1):
      arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro

Takashi Iwai (1):
      [media] ivtv: Fix Oops when no firmware is loaded

Thomas Gleixner (3):
      genirq: Sanitize spurious interrupt detection of threaded irqs
      nohz: Fix another inconsistency between CONFIG_NO_HZ=n and nohz=off
      rtmutex: Handle deadlock detection smarter

Thomas Jarosch (1):
      PCI: Add new ID for Intel GPU "spurious interrupt" quirk

Till Dörges (1):
      [media] rtl28xxu: add ID [0ccd:00b4] TerraTec NOXON DAB Stick (rev 3)

Tim Kryger (2):
      serial: 8250_dw: Report CTS asserted for auto flow
      serial: 8250_dw: Improve unwritable LCR workaround

Tom Gundersen (1):
      net: tunnels - enable module autoloading

Tomas Winkler (2):
      mei: me: drop harmful wait optimization
      mei: me: read H_CSR after asserting reset

Tony Luck (2):
      mm/memory-failure.c-failure: send right signal code to correct thread
      mm/memory-failure.c: don't let collect_procs() skip over processes for MF_ACTION_REQUIRED

Trond Myklebust (3):
      NFS: Don't declare inode uptodate unless all attributes were checked
      SUNRPC: Fix a module reference leak in svc_handle_xprt
      pNFS: Handle allocation errors correctly in filelayout_alloc_layout_hdr()

Viresh Kumar (1):
      watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()

Wang, Xiaoming (1):
      ALSA: compress: Cancel the optimization of compiler and fix the size of struct for all platform.

Wei Yang (2):
      net/mlx4_core: pass pci_device_id.driver_data to __mlx4_init_one during reset
      net/mlx4_core: Preserve pci_dev_data after __mlx4_remove_one()

Will Deacon (1):
      arm64: ptrace: change fs when passing kernel pointer to regset code

Xufeng Zhang (1):
      sctp: Fix sk_ack_backlog wrap-around problem

Yann Droneaud (3):
      IB/mlx5: add missing padding at end of struct mlx5_ib_create_cq
      IB/mlx5: add missing padding at end of struct mlx5_ib_create_srq
      RDMA/cxgb4: Add missing padding at end of struct c4iw_create_cq_resp

Yuchung Cheng (1):
      tcp: fix cwnd undo on DSACK in F-RTO

gundberg (1):
      watchdog: kempld-wdt: Use the correct value when configuring the prescaler with the watchdog

hujianyang (2):
      UBIFS: fix an mmap and fsync race condition
      UBIFS: Remove incorrect assertion in shrink_tnc()

pekon gupta (1):
      mtd: nand: omap: fix BCHx ecc.correct to return detected bit-flips in erased-page

xiao jin (2):
      USB: usb_wwan: fix urb leak in write error path
      USB: usb_wwan: fix race between write and resume
