Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaFFNId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:08:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36224 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaFFNIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:08:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.11.y.z extended stable] Linux 3.11.10.11
Date: Fri,  6 Jun 2014 14:08:24 +0100
Message-Id: <1402060105-3024-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.11.10.11 kernel.

The updated 3.11.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.11.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.11.y;a=shortlog

The diff from v3.11.10.10 is posted as a follow-up to this email.

The 3.11.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Documentation/input/elantech.txt                 |   5 +-
 Makefile                                         |   2 +-
 arch/arm/boot/dts/armada-xp-db.dts               |   2 +-
 arch/arm/boot/dts/armada-xp-gp.dts               |   2 +-
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |   2 +-
 arch/arm/boot/dts/imx53.dtsi                     |   2 +-
 arch/arm/kernel/crash_dump.c                     |   2 +-
 arch/arm/kernel/perf_event.c                     |  11 +-
 arch/arm64/mm/hugetlbpage.c                      |   4 +
 arch/metag/include/asm/barrier.h                 |   3 +
 arch/metag/include/asm/processor.h               |   2 +
 arch/mips/lantiq/dts/easy50712.dts               |   1 +
 arch/mips/ralink/dts/mt7620a_eval.dts            |   1 +
 arch/mips/ralink/dts/rt2880_eval.dts             |   1 +
 arch/mips/ralink/dts/rt3052_eval.dts             |   1 +
 arch/mips/ralink/dts/rt3883_eval.dts             |   1 +
 arch/parisc/include/asm/processor.h              |   2 +
 arch/powerpc/include/asm/reg.h                   |   1 +
 arch/powerpc/kernel/process.c                    |  34 ++++-
 arch/powerpc/kernel/signal_32.c                  |   2 +
 arch/powerpc/kernel/signal_64.c                  |   2 +
 arch/powerpc/kernel/tm.S                         |   2 +-
 arch/powerpc/lib/crtsavres.S                     | 186 +++++++++++++++++++++++
 arch/powerpc/platforms/powernv/eeh-ioda.c        |   3 +-
 arch/x86/boot/compressed/eboot.c                 |   5 +-
 arch/x86/boot/compressed/head_32.S               |  14 +-
 arch/x86/boot/compressed/head_64.S               |   9 +-
 arch/x86/include/asm/hugetlb.h                   |   1 +
 arch/x86/kernel/ldt.c                            |   4 +-
 arch/x86/vdso/vdso32-setup.c                     |   8 +
 drivers/acpi/acpi_processor.c                    |   1 -
 drivers/acpi/blacklist.c                         |  13 ++
 drivers/acpi/ec.c                                |  77 +++++++++-
 drivers/ata/libata-core.c                        |   9 ++
 drivers/block/rbd.c                              |   2 +-
 drivers/bluetooth/ath3k.c                        |   2 +
 drivers/bluetooth/btusb.c                        |   1 +
 drivers/bus/mvebu-mbus.c                         |   6 -
 drivers/clk/tegra/clk-pll.c                      |   2 +-
 drivers/crypto/caam/error.c                      |  10 +-
 drivers/gpio/gpio-mcp23s08.c                     |  34 +++--
 drivers/gpu/drm/cirrus/cirrus_drv.c              |  42 +++++
 drivers/gpu/drm/cirrus/cirrus_mode.c             |   3 +
 drivers/gpu/drm/i915/intel_display.c             |  26 ++--
 drivers/gpu/drm/i915/intel_panel.c               |   8 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c           |   3 -
 drivers/gpu/drm/nouveau/nouveau_display.c        |   2 +-
 drivers/gpu/drm/radeon/cik.c                     |  76 +++++++++
 drivers/gpu/drm/radeon/cikd.h                    |   9 ++
 drivers/gpu/drm/radeon/evergreen.c               |  28 +++-
 drivers/gpu/drm/radeon/r600.c                    |  13 +-
 drivers/gpu/drm/radeon/radeon.h                  |   6 +
 drivers/gpu/drm/radeon/radeon_display.c          |   4 +
 drivers/gpu/drm/radeon/radeon_uvd.c              |   4 +
 drivers/gpu/drm/radeon/si.c                      |  28 +++-
 drivers/hid/hid-ids.h                            |   3 +
 drivers/hid/usbhid/hid-quirks.c                  |   3 +
 drivers/hwmon/emc1403.c                          |   4 +-
 drivers/i2c/busses/i2c-rcar.c                    |   9 +-
 drivers/i2c/busses/i2c-s3c2410.c                 |   2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c       |   7 +-
 drivers/infiniband/ulp/isert/ib_isert.c          |  27 +---
 drivers/infiniband/ulp/isert/ib_isert.h          |   2 +-
 drivers/input/keyboard/atkbd.c                   |  29 +++-
 drivers/input/mouse/elantech.c                   |  26 +++-
 drivers/input/mouse/elantech.h                   |   1 +
 drivers/input/mouse/synaptics.c                  |   8 +
 drivers/iommu/amd_iommu.c                        |   2 +-
 drivers/md/dm-crypt.c                            |  61 ++------
 drivers/md/md.c                                  |   3 +-
 drivers/media/i2c/ov7670.c                       |   2 +-
 drivers/media/media-device.c                     |   1 +
 drivers/media/tuners/fc2580.c                    |   6 +-
 drivers/media/tuners/fc2580_priv.h               |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |  12 +-
 drivers/memory/mvebu-devbus.c                    |  15 +-
 drivers/mtd/nand/nuc900_nand.c                   |   2 +-
 drivers/mtd/sm_ftl.c                             |  11 +-
 drivers/net/bonding/bond_main.c                  |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c   |   3 -
 drivers/net/ethernet/broadcom/tg3.c              |   4 +-
 drivers/net/macvlan.c                            |   9 +-
 drivers/net/usb/cdc_mbim.c                       |  39 +++--
 drivers/net/usb/qmi_wwan.c                       |  34 ++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c          |  22 +--
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c     |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c      |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c     |   6 +
 drivers/pci/host/pci-mvebu.c                     |   4 +-
 drivers/pci/hotplug/shpchp_ctrl.c                |   4 +-
 drivers/target/iscsi/iscsi_target.c              |   4 +-
 drivers/target/target_core_device.c              |   8 +-
 drivers/tty/hvc/hvc_console.c                    |   2 +-
 drivers/tty/serial/8250/8250_core.c              |   2 +-
 drivers/usb/gadget/at91_udc.c                    |  10 --
 drivers/usb/host/ehci-fsl.c                      |   3 +-
 drivers/usb/host/ohci-hub.c                      |  18 +++
 drivers/usb/host/ohci-pci.c                      |   1 +
 drivers/usb/host/ohci.h                          |   2 +
 drivers/usb/serial/qcserial.c                    |  15 ++
 drivers/usb/storage/shuttle_usbat.c              |   2 +-
 drivers/usb/storage/unusual_devs.h               |  14 ++
 fs/exec.c                                        |   6 +-
 fs/nfsd/nfs4acl.c                                |  17 ++-
 fs/nfsd/nfs4state.c                              |  25 +--
 fs/posix_acl.c                                   |   6 +
 include/linux/list.h                             |  16 ++
 include/linux/sock_diag.h                        |   2 +-
 include/net/ip6_route.h                          |   5 +
 include/net/sctp/structs.h                       |   4 +-
 include/trace/events/module.h                    |   2 +-
 kernel/events/core.c                             |   3 -
 kernel/hrtimer.c                                 |   8 +-
 kernel/tracepoint.c                              |   6 +
 kernel/workqueue.c                               |  36 ++++-
 mm/compaction.c                                  |  22 +--
 mm/mremap.c                                      |   9 +-
 mm/percpu.c                                      |   2 +-
 net/8021q/vlan_dev.c                             |  46 +++++-
 net/bluetooth/hci_conn.c                         |   9 +-
 net/bluetooth/hci_event.c                        |   6 +
 net/bridge/br_input.c                            |   2 +-
 net/bridge/br_netlink.c                          |  15 ++
 net/bridge/br_vlan.c                             |   7 +-
 net/ceph/messenger.c                             |  20 ++-
 net/core/dev.c                                   |   2 +
 net/core/filter.c                                |   6 +-
 net/core/rtnetlink.c                             |  33 ++--
 net/core/skbuff.c                                |  12 +-
 net/core/sock_diag.c                             |   4 +-
 net/ipv4/fib_semantics.c                         |   2 +-
 net/ipv4/ip_forward.c                            |   4 +-
 net/ipv4/ip_gre.c                                |   2 +-
 net/ipv4/ping.c                                  |  15 +-
 net/ipv4/route.c                                 |   4 +-
 net/ipv4/tcp_cubic.c                             |   2 +-
 net/ipv6/ip6_fib.c                               |   3 +-
 net/ipv6/ip6_gre.c                               |  10 ++
 net/ipv6/ip6_output.c                            |   6 +-
 net/ipv6/ip6_tunnel.c                            |   2 +-
 net/ipv6/netfilter.c                             |   6 +-
 net/ipv6/route.c                                 |   5 +-
 net/l2tp/l2tp_ppp.c                              |   4 +-
 net/packet/diag.c                                |   2 +-
 net/sctp/auth.c                                  |  17 +--
 net/sctp/endpointola.c                           |   3 +-
 net/sctp/protocol.c                              |   7 +-
 net/sctp/sm_make_chunk.c                         |  32 ++--
 net/sctp/sm_statefuns.c                          |   6 +-
 net/sctp/socket.c                                |  96 ++++++++----
 net/sctp/sysctl.c                                |  38 ++++-
 scripts/mod/modpost.c                            |   8 +-
 sound/soc/codecs/wm8962.c                        |  15 +-
 sound/soc/codecs/wm8962.h                        |   4 +
 sound/usb/card.h                                 |   1 +
 sound/usb/endpoint.c                             |  15 +-
 156 files changed, 1383 insertions(+), 429 deletions(-)

Aaron Lu (1):
      drm/i915: restore backlight precision when converting from ACPI

AceLan Kao (2):
      HID: usbhid: quirk for Synaptics HD touchscreen
      HID: usbhid: quirk for Synaptics Quad HD touchscreen

Alan Stern (1):
      USB: OHCI: fix problem with global suspend on ATI controllers

Aleksander Morgado (2):
      net: qmi_wwan: fix Cinterion PLXX product ID
      net: qmi_wwan: add support for Cinterion PXS8 and PHS8

Alex Williamson (1):
      iommu/amd: Fix interrupt remapping for aliased devices

Andreas Schwab (1):
      powerpc: Add vr save/restore functions

Andrew Lutomirski (1):
      net: Fix ns_capable check in sock_diag_put_filterinfo

Andy Grover (1):
      target: Don't allow setting WC emulation if device doesn't support

Anthony Iliopoulos (1):
      x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

Antti Palosaari (1):
      [media] fc2580: fix tuning failure on 32-bit arch

Atilla Filiz (1):
      iio:imu:mpu6050: Fixed segfault in Invensens MPU driver due to null dereference

Ben Hutchings (1):
      rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init()

Bjørn Mork (9):
      usb: qcserial: add a number of Dell devices
      net: cdc_mbim: handle unaccelerated VLAN tagged frames
      net: qmi_wwan: add Sierra Wireless EM7355
      net: qmi_wwan: add Sierra Wireless MC73xx
      net: qmi_wwan: add Sierra Wireless MC7305/MC7355
      net: qmi_wwan: add Olivetti Olicard 500
      net: qmi_wwan: add Alcatel L800MA
      net: qmi_wwan: add a number of CMOTech devices
      net: qmi_wwan: add a number of Dell devices

Charles Keepax (1):
      ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile

Christian König (1):
      drm/radeon: use pflip irq on R600+ v2

Christoph Hellwig (1):
      posix_acl: handle NULL ACL in posix_acl_equiv_mode

Chunwei Chen (1):
      libceph: fix corruption when using page_count 0 page in rbd

Clemens Ladisch (1):
      ALSA: usb-audio: work around corrupted TEAC UD-H01 feedback data

Colin Ian King (1):
      rtlwifi: rtl8188ee: initialize packet_beacon

Daeseok Youn (1):
      workqueue: fix bugs in wq_update_unbound_numa() failure path

Dan Carpenter (2):
      mtd: nuc900_nand: NULL dereference in nuc900_nand_enable()
      mtd: sm_ftl: heap corruption in sm_create_sysfs_attributes()

Daniel Borkmann (2):
      net: sctp: wake up all assocs if sndbuf policy is per socket
      net: sctp: test if association is dead in sctp_wake_up_waiters

Daniele Forsi (2):
      usb: storage: shuttle_usbat: fix discs being detected twice
      USB: Nokia 5300 should be treated as unusual dev

David Gibson (2):
      rtnetlink: Warn when interface's information won't fit in our packet
      rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF is set

Dmitry Petukhov (1):
      l2tp: take PMTU from tunnel UDP socket

Egbert Eich (1):
      drm/i915: Break encoder->crtc link separately in intel_sanitize_crtc()

Enrico Mioso (1):
      net: qmi_wwan: Olivetti Olicard 200 support

Eric Dumazet (2):
      ipv6: Limit mtu to 65575 bytes
      net-gro: reset skb->truesize in napi_reuse_skb()

Fabio Porcedda (1):
      net: qmi_wwan: add Telit LE920 newer firmware support

Florian Westphal (3):
      net: core: don't account for udp header size when computing seglen
      net: ipv4: ip_forward: fix inverted local_df test
      net: ipv6: send pkttoobig immediately if orig frag size > mtu

Gary Servin (1):
      gpio: mcp23s08: trivial: fixed coding style issues

Gavin Shan (1):
      powerpc/powernv: Reset root port in firmware

Gerd Hoffmann (1):
      drm: cirrus: add power management support

Guennadi Liakhovetski (2):
      [media] V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
      [media] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode

Hans de Goede (4):
      Input: synaptics - add min/max quirk for ThinkPad Edge E431
      HID: add NO_INIT_REPORTS quirk for Synaptics Touch Pad V 103S
      Input: elantech - fix touchpad initialization on Gigabyte U2442
      ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015PX

Horia Geanta (1):
      crypto: caam - add allocation failure handling in SPRINTFCAT macro

Igor Mammedov (1):
      ACPI / processor: do not mark present at boot but not onlined CPU as onlined

Ilia Mirkin (1):
      drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi

Ilya Dryomov (1):
      rbd: fix error paths in rbd_img_request_fill()

Ivan Vecera (1):
      tg3: update rx_jumbo_pending ring param only when jumbo frames are enabled

James Hogan (1):
      metag: Reduce maximum stack size to 256MB

Jean-Jacques Hiblot (1):
      usb: gadget: at91-udc: fix irq and iomem resource retrieval

Jianyu Zhan (1):
      percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()

Johan Hedberg (2):
      Bluetooth: Fix triggering BR/EDR L2CAP Connect too early
      Bluetooth: Fix redundant encryption request for reauthentication

Josef Gajdusek (2):
      hwmon: (emc1403) fix inverted store_hyst()
      hwmon: (emc1403) Support full range of known chip revision numbers

Julian Anastasov (1):
      ipv4: return valid RTA_IIF on ip route get

Kieran Clancy (2):
      ACPI / EC: Clear stale EC events on Samsung systems
      ACPI / EC: Process rather than discard events in acpi_ec_clear

Kinglong Mee (1):
      NFSD: Call ->set_acl with a NULL ACL structure if no entries

Kirill A. Shutemov (1):
      mm, thp: close race between mremap() and split_huge_page()

Kumar Sundararajan (1):
      ipv6: fib: fix fib dump restart

Lai Jiangshan (2):
      workqueue: make rescuer_thread() empty wq->maydays list before exiting
      workqueue: fix a possible race condition between rescuer and pwq-release

Larry Finger (1):
      rtlwifi: rtl8192se: Fix regression due to commit 1bf4bbb

Leif Lindholm (1):
      mips: dts: Fix missing device_type="memory" property in memory nodes

Leo Liu (1):
      drm/radeon: check buffer relocation offset

Levente Kurusa (1):
      libata: clean up ZPODD when a port is detached

Li RongQing (1):
      ipv4: initialise the itag variable in __mkroute_input

Linus Torvalds (1):
      x86-64, modify_ldt: Make support for 16-bit segments a runtime option

Liu Hua (1):
      ARM: 8012/1: kdump: Avoid overflow when converting pfn to physaddr

Liu Yu (1):
      tcp_cubic: fix the range of delayed_ack

Luis Henriques (1):
      Linux 3.11.10.11

Maarten Lankhorst (1):
      drm/nouveau: fix another lock unbalance in nouveau_crtc_page_flip

Marcel Apfelbaum (1):
      PCI: shpchp: Check bridge's secondary (not primary) bus speed

Mark Salter (1):
      arm64: fix pud_huge() for 2-level pagetables

Mathias Krause (1):
      filter: prevent nla extensions to peek beyond the end of the message

Matt Fleming (1):
      x86/efi: Correct EFI boot stub use of code32_start

Michael Neuling (1):
      powerpc/tm: Disable IRQ in tm_recheckpoint

Michael Welling (2):
      tty: serial: 8250_core.c Bug fix for Exar chips.
      gpio: mcp23s08: Bug fix of SPI device tree registration.

Mikulas Patocka (2):
      dm crypt: fix cpu hotplug crash by removing per-cpu structure
      metag: fix memory barriers

Mohammed Habibulla (1):
      Bluetooth: Add support for Lite-on [04ca:3007]

NeilBrown (1):
      md: avoid possible spinning md thread at shutdown.

Nicholas Bellinger (1):
      iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out

Nicolas Dichtel (2):
      gre: don't allow to add the same tunnel twice
      ip6_gre: don't allow to remove the fb_tunnel_dev

Nikita Yushchenko (1):
      fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6

Oleg Nesterov (1):
      list: introduce list_next_entry() and list_prev_entry()

Olof Johansson (1):
      i2c: s3c2410: resume race fix

Peter Christensen (1):
      macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.

Raymond Wanyoike (1):
      net: qmi_wwan: add ZTE MF667

Romain Izard (1):
      trace: module: Maintain a valid user count

Sagi Grimberg (2):
      Target/iser: Fix wrong connection requests list addition
      Target/iser: Fix iscsit_accept_np and rdma_cm racy flow

Salva Peiró (1):
      [media] media-device: fix infoleak in ioctl media_enum_entities()

Sascha Hauer (1):
      ARM: dts: i.MX53: Fix ipu register space size

Sergey Popovich (2):
      ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation
      netfilter: Fix potential use after free in ip6_route_me_harder()

Sheng-Liang Song (1):
      Input: atkbd - fix keyboard not working on some LG laptops

Stanislaw Gruszka (1):
      rt2x00: fix beaconing on USB

Steven Rostedt (Red Hat) (1):
      tracepoint: Do not waste memory on mods with no tracepoints

Susant Sahani (1):
      ip6_tunnel: fix potential NULL pointer dereference

Thomas Petazzoni (5):
      memory: mvebu-devbus: fix the conversion of the bus width
      bus: mvebu-mbus: allow several windows with the same target/attribute
      ARM: mvebu: fix NOR bus-width in Armada XP GP Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP DB Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP OpenBlocks AX3 Device Tree

Thomas Richter (1):
      bonding: Remove debug_fs files when module init fails

Tomoki Sekiyama (1):
      drivers/tty/hvc: don't free hvc_console_setup after init

Toshiaki Makita (2):
      bridge: Fix double free and memory leak around br_allowed_ingress
      bridge: Handle IFLA_ADDRESS correctly when creating bridge device

Trond Myklebust (2):
      NFSd: Move default initialisers from create_client() to alloc_client()
      NFSd: call rpc_destroy_wait_queue() from free_client()

Tuomas Tynkkynen (1):
      clk: tegra: Fix wrong value written to PLLE_AUX

Victor A. Santos (1):
      USB: Nokia 305 should be treated as unusual dev

Viresh Kumar (1):
      hrtimer: Set expiry time before switch_hrtimer_base()

Vlad Yasevich (2):
      net: sctp: cache auth_enable per endpoint
      Revert "macvlan : fix checksums error when we are in bridge mode"

Vlastimil Babka (1):
      mm/compaction: make isolate_freepages start at pageblock boundary

Wang, Xiaoming (1):
      net: ipv4: current group_info should be put after using.

Will Deacon (1):
      ARM: perf: hook up perf_sample_event_took around pmu irq handling

Willy Tarreau (1):
      PCI: mvebu: fix off-by-one in the computed size of the mbus windows

Wolfram Sang (1):
      i2c: rcar: bail out on zero length transfers

Xufeng Zhang (1):
      sctp: reset flowi4_oif parameter on route lookup

dingtianhong (1):
      vlan: Fix lockdep warning when vlan dev handle notification

