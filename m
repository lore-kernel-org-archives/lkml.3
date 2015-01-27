Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbbA0MQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:16:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34789 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbbA0MQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:16:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.16.y-ckt stable] Linux 3.16.7-ckt5 stable review
Date: Tue, 27 Jan 2015 12:15:05 +0000
Message-Id: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
X-Extended-Stable: 3.16
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.16.7-ckt5 stable kernel.

This version contains 126 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.16.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.16.y-review

The review period for version 3.16.7-ckt5 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.16.y-ckt extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts       |  2 +
 arch/arm/boot/dts/berlin2q.dtsi                  | 63 ++++++++---------
 arch/arm/boot/dts/dra7-evm.dts                   | 10 +--
 arch/arm/boot/dts/dra7.dtsi                      |  2 +-
 arch/arm/boot/dts/imx25.dtsi                     |  2 +-
 arch/arm/boot/dts/imx51-babbage.dts              | 22 ++----
 arch/arm/boot/dts/s3c6410-mini6410.dts           |  4 --
 arch/arm/boot/dts/s3c64xx.dtsi                   |  1 -
 arch/arm/configs/multi_v7_defconfig              |  1 +
 arch/arm/include/asm/xen/page.h                  |  4 ++
 arch/arm/kernel/setup.c                          |  9 +++
 arch/arm/kernel/smp.c                            | 13 +++-
 arch/arm/mach-imx/clk-imx6q.c                    |  4 +-
 arch/arm/mach-imx/clk-imx6sx.c                   |  3 +
 arch/arm/mach-omap2/common.h                     |  1 +
 arch/arm/mach-omap2/omap-headsmp.S               | 21 ++++++
 arch/arm/mach-omap2/omap-smp.c                   | 13 +++-
 arch/arm/mach-omap2/pm44xx.c                     | 29 +++-----
 arch/arm/mach-omap2/timer.c                      |  8 +--
 arch/arm/mach-shmobile/setup-sh73a0.c            |  3 +
 arch/arm/xen/mm.c                                |  7 ++
 arch/arm64/kernel/efi.c                          |  2 +-
 arch/arm64/kernel/setup.c                        |  1 +
 arch/powerpc/kernel/udbg_16550.c                 |  6 +-
 arch/x86/include/asm/vsyscall.h                  |  2 +-
 arch/x86/include/asm/xen/page.h                  |  7 ++
 arch/x86/kernel/kprobes/core.c                   | 20 ++++--
 arch/x86/vdso/vma.c                              | 45 +++++++-----
 drivers/acpi/acpica/evxfgpe.c                    | 47 +++++++++++++
 drivers/acpi/device_pm.c                         |  2 +-
 drivers/acpi/scan.c                              | 42 ++++++-----
 drivers/clk/at91/clk-slow.c                      | 27 +++++++
 drivers/clk/berlin/bg2q.c                        |  1 -
 drivers/clk/clk.c                                |  5 +-
 drivers/gpu/drm/i915/i915_irq.c                  |  6 +-
 drivers/gpu/drm/i915/i915_reg.h                  | 12 ++--
 drivers/gpu/drm/i915/intel_ringbuffer.c          | 66 +++++++++++-------
 drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c    |  8 ---
 drivers/gpu/drm/radeon/atombios_crtc.c           |  8 +--
 drivers/gpu/drm/radeon/atombios_dp.c             |  4 ++
 drivers/gpu/drm/radeon/dce3_1_afmt.c             |  2 +-
 drivers/gpu/drm/radeon/kv_dpm.c                  | 10 ++-
 drivers/hid/hid-core.c                           |  1 +
 drivers/hid/hid-ids.h                            |  1 +
 drivers/hid/hid-input.c                          |  3 +
 drivers/hid/hid-kye.c                            |  4 ++
 drivers/hid/hid-roccat-pyra.c                    |  8 ++-
 drivers/hid/i2c-hid/i2c-hid.c                    |  5 --
 drivers/hid/usbhid/hid-quirks.c                  |  1 +
 drivers/md/bcache/btree.c                        |  2 +-
 drivers/misc/mei/hw-me.c                         | 12 ++++
 drivers/mmc/host/sdhci-pxav3.c                   | 19 +++--
 drivers/mmc/host/sdhci.c                         |  8 ++-
 drivers/mtd/nand/omap2.c                         |  7 --
 drivers/net/ethernet/atheros/alx/main.c          | 24 ++++---
 drivers/net/ethernet/broadcom/tg3.c              | 34 ++++-----
 drivers/net/ethernet/cisco/enic/enic_main.c      | 12 ++--
 drivers/net/ethernet/ti/cpsw.c                   | 30 ++++----
 drivers/net/ethernet/ti/cpsw_ale.c               | 10 ++-
 drivers/net/ethernet/ti/cpsw_ale.h               |  2 +-
 drivers/net/team/team.c                          | 16 ++++-
 drivers/net/wireless/iwlwifi/mvm/utils.c         |  2 +-
 drivers/net/xen-netback/xenbus.c                 |  1 +
 drivers/net/xen-netfront.c                       | 10 ++-
 drivers/reset/reset-sunxi.c                      |  4 ++
 drivers/rtc/rtc-isl12057.c                       |  4 +-
 drivers/scsi/scsi_error.c                        |  4 +-
 drivers/spi/spi-sh-msiof.c                       |  5 ++
 drivers/target/loopback/tcm_loop.c               | 23 +++---
 drivers/target/target_core_device.c              |  8 +--
 drivers/target/target_core_file.c                | 11 ++-
 drivers/target/target_core_iblock.c              |  2 +-
 drivers/target/target_core_sbc.c                 | 15 ----
 drivers/target/target_core_spc.c                 |  5 +-
 drivers/usb/dwc3/gadget.c                        |  6 +-
 drivers/usb/gadget/atmel_usba_udc.c              | 19 +++--
 drivers/usb/gadget/inode.c                       |  1 +
 drivers/usb/host/ehci-sched.c                    |  8 +--
 drivers/usb/host/pci-quirks.c                    | 18 ++++-
 drivers/usb/host/xhci-pci.c                      |  2 +
 drivers/usb/host/xhci.c                          |  9 +++
 drivers/usb/musb/musb_host.c                     |  1 -
 drivers/usb/serial/console.c                     | 16 +++--
 drivers/usb/serial/cp210x.c                      |  4 +-
 drivers/usb/serial/keyspan.c                     | 20 ++++--
 drivers/usb/serial/option.c                      | 11 ++-
 drivers/usb/serial/qcserial.c                    |  1 -
 drivers/usb/storage/unusual_uas.h                | 28 ++++++++
 drivers/vfio/pci/vfio_pci.c                      |  4 +-
 drivers/vhost/scsi.c                             | 24 ++++++-
 drivers/video/fbdev/core/fb_defio.c              |  5 +-
 drivers/video/logo/logo.c                        | 17 ++++-
 drivers/xen/swiotlb-xen.c                        |  7 +-
 fs/btrfs/delayed-inode.c                         |  8 +++
 fs/lockd/svc.c                                   |  8 +--
 fs/nfs/nfs4client.c                              | 17 +++--
 fs/nilfs2/inode.c                                | 32 ++++++---
 fs/nilfs2/namei.c                                | 15 +++-
 fs/notify/inode_mark.c                           | 17 +++--
 fs/ocfs2/namei.c                                 | 43 +++++++++---
 include/acpi/acpixf.h                            |  4 ++
 include/linux/mm.h                               |  2 +-
 include/linux/rmap.h                             | 10 +++
 include/linux/writeback.h                        |  1 -
 include/uapi/linux/in6.h                         |  3 +-
 include/uapi/linux/libc-compat.h                 |  3 +
 kernel/exit.c                                    | 12 +++-
 kernel/sched/deadline.c                          | 25 ++-----
 mm/memory.c                                      | 31 +++++----
 mm/mmap.c                                        | 13 ++--
 mm/page-writeback.c                              | 43 ++++--------
 mm/rmap.c                                        | 42 ++++++++++-
 mm/vmscan.c                                      | 24 ++++---
 net/batman-adv/fragmentation.c                   |  2 +-
 net/batman-adv/gateway_client.c                  |  2 +-
 net/bridge/br_multicast.c                        |  3 +-
 net/core/dev.c                                   | 89 +++++++++++++++++++++---
 net/core/skbuff.c                                |  1 +
 net/ipv4/ip_gre.c                                |  9 +--
 net/ipv4/tcp_output.c                            |  4 +-
 net/netfilter/ipset/ip_set_core.c                |  6 ++
 net/netfilter/nf_conntrack_proto_generic.c       | 26 ++++++-
 net/netlink/af_netlink.c                         | 54 +++++---------
 net/sunrpc/xdr.c                                 |  6 +-
 scripts/kernel-doc                               |  2 +-
 sound/firewire/fireworks/fireworks_transaction.c |  2 +-
 sound/pci/hda/hda_codec.c                        |  4 +-
 sound/pci/hda/patch_hdmi.c                       |  2 +
 sound/pci/hda/patch_sigmatel.c                   |  4 +-
 sound/soc/dwc/designware_i2s.c                   | 14 ++++
 sound/soc/fsl/eukrea-tlv320.c                    |  2 +-
 tools/perf/util/hist.h                           |  1 +
 tools/perf/util/session.c                        |  6 +-
 133 files changed, 1085 insertions(+), 546 deletions(-)

Aaron Plattner (1):
      ALSA: hda - Add new GPU codec ID 0x10de0072 to snd-hda

Alan Stern (2):
      SCSI: fix regression in scsi_send_eh_cmnd()
      USB: EHCI: fix initialization bug in iso_stream_schedule()

Alex Deucher (4):
      drm/radeon: KV has three PPLLs (v2)
      drm/radeon: fix sad_count check for dce3
      drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw
      drm/radeon: adjust default bapm settings for KV

Alexander Usyskin (1):
      mei: clean reset bit before reset

Alexander Y. Fomichev (2):
      net: prevent of emerging cross-namespace symlinks
      net: fix creation adjacent device symlinks

Amit Virdi (2):
      usb: dwc3: gadget: Fix TRB preparation during SG
      usb: dwc3: gadget: Stop TRB preparation after limit is reached

Andrew Jackson (1):
      ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap

Andy Lutomirski (2):
      x86_64, vdso: Fix the vdso address randomization algorithm
      x86, vdso: Use asm volatile in __getcpu

Anton Blanchard (1):
      powerpc: Fix bad NULL pointer check in udbg_uart_getc_poll()

Antonio Quartulli (1):
      batman-adv: avoid NULL dereferences and fix if check

Ard Biesheuvel (1):
      arm64/efi: add missing call to early_ioremap_reset()

Arnaud Ebalard (1):
      drivers/rtc/rtc-isl12057.c: fix masking of register values

Arseny Solokha (1):
      OHCI: add a quirk for ULi M5237 blocking on reset

Bo Shen (2):
      usb: gadget: udc: atmel: change setting for DMA
      usb: gadget: udc: atmel: fix possible IN hang issue

Boris Brezillon (1):
      clk: at91: keep slow clk enabled to prevent system hang

Chris Mason (1):
      Btrfs: don't delay inode ref updates during log replay

Chris Wilson (1):
      drm/i915: Evict CS TLBs between batches

Dan Carpenter (3):
      HID: roccat: potential out of bounds in pyra_sysfs_write_settings()
      ALSA: hda - using uninitialized data
      netfilter: ipset: small potential read beyond the end of buffer

David Miller (1):
      netlink: Always copy on mmap TX.

David Peterson (1):
      USB: cp210x: add IDs for CEL USB sticks and MeshWorks devices

David Vrabel (2):
      xen-netfront: use correct linear area after linearizing an skb
      Revert "swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single"

Dmitry Voytik (1):
      ARM: imx6q: drop unnecessary semicolon

Eric Dumazet (1):
      alx: fix alx_poll()

Eyal Shapira (1):
      iwlwifi: mvm: fix Rx with both chains

Fabio Estevam (3):
      ARM: dts: imx25: Fix the SPI1 clocks
      ARM: imx6sx: Set PLL2 as parent of QSPI clocks
      ARM: dts: imx51-babbage: Fix ULPI PHY reset modelling

Felipe Balbi (1):
      net: ethernet: cpsw: fix hangs with interrupts

Florian Westphal (1):
      netfilter: conntrack: disable generic tracking for known protocols

Gary Bisson (1):
      ARM: clk-imx6q: fix video divider for rev T0 1.0

Geert Uytterhoeven (1):
      ARM: shmobile: sh73a0 legacy: Set .control_parent for all irqpin instances

Giedrius Statkevičius (1):
      HID: Add a new id 0x501a for Genius MousePen i608X

Govindarajulu Varadarajan (1):
      enic: fix rx skb checksum

Hannes Reinecke (1):
      tcm_loop: Fixup tag handling

Hans de Goede (4):
      xhci: Add broken-streams quirk for Fresco Logic FL1000G xhci controllers
      uas: Add US_FL_NO_ATA_1X for Seagate devices with usb-id 0bc2:a013
      uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS566 with usb-id 0bc2:a013
      uas: Add US_FL_NO_ATA_1X for 2 more Seagate disk enclosures

Herbert Xu (1):
      tcp: Do not apply TSO segment limit to non-TSO packets

Hisashi Nakamura (1):
      spi: sh-msiof: Add runtime PM lock in initializing

Ilia Mirkin (1):
      drm/nv4c/mc: disable msi

J. Bruce Fields (1):
      rpc: fix xdr_truncate_encode to handle buffer ending on page boundary

Jay Vosburgh (1):
      net/core: Handle csum for CHECKSUM_COMPLETE VXLAN forwarding

Jerry Hoemann (1):
      fsnotify: next_i is freed during fsnotify_unmount_inodes.

Jiri Olsa (1):
      perf session: Do not fail on processing out of order event

Jiri Pirko (1):
      team: avoid possible underflow of count_pending value for notify_peers and mcast_rejoin

Jisheng Zhang (4):
      ARM: dts: berlin: fix io clk and add missing core clk for BG2Q sdhci2 host
      ARM: dts: berlin: add broken-cd and set bus width for eMMC in Marvell DMP DT
      ARM: dts: berlin: correct BG2Q's SM GPIO location.
      clk: berlin: bg2q: remove non-exist "smemc" gate clock

Johan Hovold (3):
      USB: keyspan: fix null-deref at probe
      USB: console: fix uninitialised ldisc semaphore
      USB: console: fix potential use after free

Johannes Berg (1):
      scripts/kernel-doc: don't eat struct members with __aligned

Johannes Weiner (1):
      mm: protect set_page_dirty() from ongoing truncation

Karl Relton (1):
      HID: add battery quirk for USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO keyboard

Kent Overstreet (1):
      bcache: Make sure to pass GFP_WAIT to mempool_alloc()

Konstantin Khlebnikov (2):
      mm: prevent endless growth of anon_vma hierarchy
      mm: fix corner case in anon_vma endless growing prevention

Krzysztof Kozlowski (1):
      mmc: sdhci: Fix sleep in atomic after inserting SD card

Lennart Sorensen (2):
      ARM: omap5/dra7xx: Fix frequency typos
      ARM: omap5/dra7xx: Enable booting secondary CPU in HYP mode

Linus Lüssing (1):
      bridge: fix netfilter/NF_BR_LOCAL_OUT for own, locally generated queries

Linus Torvalds (2):
      mm: propagate error from stack expansion even for guard page
      mm: Don't count the stack guard page towards RLIMIT_STACK

Lokesh Vutla (1):
      ARM: dts: DRA7: wdt: Fix compatible property for watchdog node

Luca Abeni (2):
      sched/deadline: Fix migration of SCHED_DEADLINE tasks
      sched/deadline: Avoid double-accounting in case of missed deadlines

Mario Schuknecht (1):
      usb: gadget: gadgetfs: Free memory allocated by memdup_user()

Mathias Nyman (1):
      xhci: Check if slot is already in default state before moving it there

Mika Westerberg (1):
      HID: i2c-hid: Do not free buffers in i2c_hid_stop()

Mugunthan V N (2):
      drivers: net: cpsw: fix multicast flush in dual emac mode
      ARM: dts: dra7-evm: fix qspi device tree partition size

Nicholas Bellinger (2):
      vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion
      target: Drop arbitrary maximum I/O size limit

Nishanth Menon (1):
      ARM: OMAP4: PM: Only do static dependency configuration in omap4_init_static_deps

Oleg Nesterov (1):
      exit: fix race between wait_consider_task() and wait_task_zombie()

Palik, Imre (1):
      xen-netback: fixing the propagation of the transmit shaper timeout

Pavel Machek (1):
      Revert "ARM: 7830/1: delay: don't bother reporting bogomips in /proc/cpuinfo"

Prashant Sreedharan (1):
      tg3: tg3_disable_ints using uninitialized mailbox value to disable interrupts

Preston Fick (1):
      USB: cp210x: fix ID for production CEL MeshConnect USB Stick

Rafael J. Wysocki (3):
      ACPI / PM: Fix PM initialization for devices that are not present
      ACPICA: Add new GPE public interface - acpi_mark_gpe_for_wake.
      ACPI / scan: No implicit wake notification for buttons

Reinhard Speyerer (1):
      USB: qcserial/option: make AT URCs work for Sierra Wireless MC73xx

Roger Quadros (1):
      mtd: nand: omap: Fix NAND enumeration on 3430 LDP

Ryusuke Konishi (1):
      nilfs2: fix the nilfs_iget() vs. nilfs_new_inode() races

Sebastian Andrzej Siewior (1):
      usb: musb: stuff leak of struct usb_hcd

Songjun Wu (1):
      usb: gadget: udc: atmel: fix possible oops when unloading module

Steev Klimaszewski (1):
      Add USB_EHCI_EXYNOS to multi_v7_defconfig

Stefano Stabellini (1):
      xen/arm/arm64: introduce xen_arch_need_swiotlb

Steven Rostedt (Red Hat) (1):
      ftrace/jprobes/x86: Fix conflict between jprobes and function graph tracing

Sven Eckelmann (1):
      batman-adv: Unify fragment size calculation

Takashi Iwai (2):
      ALSA: hda - Fix wrong gpio_dir & gpio_mask hint setups for IDT/STAC codecs
      ASoC: eukrea-tlv320: Fix of_node_put() call with uninitialized object

Takashi Sakamoto (1):
      ALSA: fireworks: fix an endianness bug for transaction length

Thomas Graf (2):
      netlink: Don't reorder loads/stores before marking mmap netlink frame as available
      net: Reset secmark when scrubbing packet

Thomas Petazzoni (1):
      mmc: sdhci-pxav3: do the mbus window configuration after enabling clocks

Timo Teräs (1):
      gre: fix the inner mac header in nbma tunnel xmit path

Tomasz Figa (1):
      ARM: dts: Enable PWM node by default for s3c64xx

Tomeu Vizoso (1):
      clk: Don't try to use a struct clk* after it could have been freed

Tomi Valkeinen (2):
      video/logo: prevent use of logos after they have been freed
      video/fbdev: fix defio's fsync

Toshiaki Makita (1):
      net: Fix stacked vlan offload features computation

Trond Myklebust (2):
      LOCKD: Fix a race when initialising nlmsvc_timeout
      NFSv4.1: Fix client id trunking on Linux

Tyler Baker (1):
      reset: sunxi: fix spinlock initialization

Ville Syrjälä (1):
      drm/i915: Don't call intel_prepare_page_flip() multiple times on gen2-4

Vlastimil Babka (1):
      mm, vmscan: prevent kswapd livelock due to pfmemalloc-throttled process being killed

Wei Yang (1):
      vfio-pci: Fix the check on pci device type in vfio_pci_probe()

Xiang Wang (1):
      mmc: sdhci-pxav3: fix error handling of sdhci_add_host

Xue jiufei (1):
      ocfs2: fix the wrong directory passed to ocfs2_lookup_ino_from_name() when link file

Zoltan Kiss (1):
      xen-netfront: Fix handling packets on compound pages with skb_linearize

stephen hemminger (1):
      in6: fix conflict with glibc
