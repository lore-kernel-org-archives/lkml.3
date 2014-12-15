Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaLOO1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:27:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38134 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaLOO1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.16.y-ckt stable] Linux 3.16.7-ckt3 stable review
Date: Mon, 15 Dec 2014 14:24:14 +0000
Message-Id: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
X-Extended-Stable: 3.16
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.16.7-ckt3 stable kernel.

This version contains 168 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.16.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.16.y-review

The review period for version 3.16.7-ckt3 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.16.y-ckt extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 .../bindings/interrupt-controller/interrupts.txt   |   4 -
 arch/arm/Kconfig.debug                             |   2 +-
 arch/arm/include/asm/pgtable-3level-hwdef.h        |   3 +-
 arch/arm/include/asm/pgtable-3level.h              |  49 ++++++----
 arch/arm/include/asm/pgtable.h                     |  18 ++--
 arch/arm/include/asm/thread_info.h                 |  11 ---
 arch/arm/kernel/traps.c                            |  31 +-----
 arch/arm/mach-mvebu/coherency.c                    |   2 +
 arch/arm/mach-pxa/include/mach/addr-map.h          |   5 +
 arch/arm/mm/dump.c                                 |   4 +-
 arch/arm/mm/proc-v7-3level.S                       |   9 +-
 arch/arm/mm/proc-v7.S                              |   2 -
 arch/arm/mm/proc-xscale.S                          |   4 +-
 arch/arm64/crypto/Makefile                         |   2 +-
 arch/mips/include/asm/mipsregs.h                   |   2 +
 arch/mips/include/asm/r4kcache.h                   |   4 +
 arch/mips/include/asm/uaccess.h                    |   7 +-
 arch/mips/kernel/cpu-probe.c                       |  33 ++++++-
 arch/mips/kernel/signal.c                          |   8 +-
 arch/mips/lib/memcpy.S                             |   1 +
 arch/mips/loongson/common/Makefile                 |   3 +-
 arch/mips/net/bpf_jit.c                            |   4 +-
 arch/mips/oprofile/backtrace.c                     |   2 +-
 arch/mips/sgi-ip27/ip27-memory.c                   |   1 +
 arch/powerpc/kernel/vdso32/getcpu.S                |   4 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   5 +-
 arch/powerpc/platforms/powernv/pci.c               |   3 +-
 arch/powerpc/platforms/pseries/msi.c               |   2 +-
 arch/powerpc/xmon/xmon.c                           |   6 +-
 arch/sparc/include/uapi/asm/swab.h                 |  12 +--
 arch/x86/boot/compressed/Makefile                  |   2 +-
 arch/x86/include/asm/cpufeature.h                  |   1 +
 arch/x86/include/asm/kvm_para.h                    |  10 +-
 arch/x86/include/asm/page_32_types.h               |   1 -
 arch/x86/include/asm/page_64_types.h               |  11 +--
 arch/x86/include/asm/thread_info.h                 |   2 +-
 arch/x86/include/asm/traps.h                       |   1 +
 arch/x86/kernel/cpu/amd.c                          |   7 ++
 arch/x86/kernel/cpu/common.c                       |   2 +
 arch/x86/kernel/dumpstack_64.c                     |   1 -
 arch/x86/kernel/entry_64.S                         |  81 +++++-----------
 arch/x86/kernel/traps.c                            |  74 ++++++++++----
 arch/x86/mm/init_64.c                              |  11 ++-
 arch/x86/tools/calc_run_size.pl                    |  11 ++-
 drivers/acpi/device_pm.c                           |   2 +-
 drivers/ata/ahci.c                                 |   4 +
 drivers/ata/sata_fsl.c                             |   2 +-
 drivers/bluetooth/ath3k.c                          |  33 ++++---
 drivers/bluetooth/btmrvl_main.c                    |   5 +
 drivers/bluetooth/btusb.c                          |  27 +++++-
 drivers/clk/clk-divider.c                          |  18 ++--
 drivers/clocksource/sun4i_timer.c                  |  12 +--
 drivers/gpu/drm/i915/i915_dma.c                    |  22 +++--
 drivers/gpu/drm/i915/intel_display.c               |   6 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |  22 ++---
 drivers/gpu/drm/i915/intel_pm.c                    |   5 -
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |   1 -
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   2 +-
 drivers/gpu/drm/radeon/r600_dpm.c                  |   2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |  13 ++-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   9 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |  10 ++
 drivers/gpu/drm/radeon/radeon_kms.c                |   2 +
 drivers/hid/usbhid/hid-core.c                      |   6 +-
 drivers/i2c/busses/i2c-cadence.c                   |  11 +++
 drivers/i2c/busses/i2c-davinci.c                   |   8 +-
 drivers/i2c/busses/i2c-omap.c                      |  10 +-
 drivers/iio/adc/men_z188_adc.c                     |   1 +
 drivers/infiniband/ulp/isert/ib_isert.c            |  44 ++++++---
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   8 ++
 drivers/input/evdev.c                              |   2 +-
 drivers/input/joystick/xpad.c                      |  51 +++++++++-
 drivers/input/mouse/synaptics.c                    |   4 +
 drivers/input/serio/serio.c                        |   4 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   2 +-
 drivers/media/usb/s2255/s2255drv.c                 |   2 +-
 drivers/net/bonding/bond_main.c                    |   4 +-
 drivers/net/bonding/bond_netlink.c                 |   7 +-
 drivers/net/can/dev.c                              |   2 +-
 drivers/net/can/usb/esd_usb2.c                     |   1 +
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   6 +-
 drivers/net/ethernet/broadcom/tg3.c                |   3 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  12 ++-
 drivers/net/ethernet/marvell/mvneta.c              |   5 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |  28 ++++--
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   2 +-
 drivers/net/ieee802154/fakehard.c                  |  13 ++-
 drivers/net/macvtap.c                              |   3 +
 drivers/net/ppp/pptp.c                             |   4 +-
 drivers/net/tun.c                                  |   6 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/vxlan.c                                |  10 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  13 +++
 drivers/net/wireless/ath/ath9k/hw.c                |  13 ---
 drivers/net/wireless/rt2x00/rt2x00queue.c          |  50 +++-------
 drivers/net/xen-netfront.c                         |   5 -
 drivers/of/address.c                               |  19 +++-
 drivers/of/fdt.c                                   |   4 +-
 drivers/pci/hotplug/pciehp_core.c                  |   7 ++
 drivers/pci/msi.c                                  |  26 +++++
 drivers/pci/probe.c                                |  28 +++---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |   7 ++
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/spi/spi-dw.c                               |   6 +-
 drivers/spi/spi-sirf.c                             |   4 +-
 drivers/spi/spi.c                                  |   6 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   1 +
 drivers/target/target_core_transport.c             |   2 +-
 drivers/usb/core/quirks.c                          |   6 ++
 drivers/usb/host/xhci-hub.c                        |   5 +-
 drivers/usb/host/xhci-pci.c                        |   2 +-
 drivers/usb/host/xhci-plat.c                       |  10 +-
 drivers/usb/host/xhci-ring.c                       |  43 +++------
 drivers/usb/host/xhci.c                            | 107 +++++++++++----------
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/ftdi_sio.c                      |  33 +++++++
 drivers/usb/serial/ftdi_sio_ids.h                  |  39 +++++++-
 drivers/usb/serial/keyspan.c                       |  97 +++++++++++--------
 drivers/usb/serial/ssu100.c                        |  11 +--
 drivers/usb/storage/unusual_uas.h                  |   7 ++
 drivers/vhost/scsi.c                               |  24 +++++
 fs/aio.c                                           |  21 ++--
 fs/btrfs/compression.c                             |  33 ++++++-
 fs/btrfs/compression.h                             |   4 +-
 fs/btrfs/ctree.c                                   |  14 +--
 fs/btrfs/locking.c                                 |  24 ++++-
 fs/btrfs/locking.h                                 |   2 +
 fs/btrfs/lzo.c                                     |  15 +++
 fs/btrfs/zlib.c                                    |  20 +++-
 fs/dcache.c                                        |  32 +++---
 fs/nfs/pagelist.c                                  |   2 +-
 fs/nfsd/nfs4callback.c                             |   8 +-
 fs/nfsd/nfsd.h                                     |   9 +-
 include/linux/bitops.h                             |   7 +-
 include/linux/clk-provider.h                       |   1 -
 include/linux/iio/events.h                         |   2 +-
 include/linux/inetdevice.h                         |   2 +-
 include/linux/pci.h                                |   1 +
 include/net/ipv6.h                                 |   2 +
 include/sound/soc-dpcm.h                           |   2 +
 kernel/events/uprobes.c                            |   1 -
 mm/frontswap.c                                     |   4 +-
 mm/memory.c                                        |  26 ++---
 mm/mmap.c                                          |  10 +-
 mm/rmap.c                                          |   6 +-
 mm/slab.c                                          |   2 +-
 mm/vmpressure.c                                    |   8 +-
 net/core/rtnetlink.c                               |   1 +
 net/ipv4/fib_rules.c                               |   4 +
 net/ipv4/gre_offload.c                             |   3 +
 net/ipv4/ip_vti.c                                  |   1 +
 net/ipv4/ping.c                                    |   2 +
 net/ipv6/ip6_gre.c                                 |   4 +-
 net/ipv6/ip6_vti.c                                 |  11 +++
 net/ipv6/output_core.c                             |  34 +++++++
 net/ipx/af_ipx.c                                   |   6 +-
 net/mac80211/aes_ccm.c                             |   3 +
 net/sctp/output.c                                  |   4 +-
 net/sunrpc/svcsock.c                               |  27 +++---
 sound/pci/hda/hda_intel.c                          |  32 +++++-
 sound/pci/hda/hda_priv.h                           |   1 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/codecs/cs42l51-i2c.c                     |   1 +
 sound/soc/codecs/cs42l51.c                         |   4 +-
 sound/soc/codecs/cs42l51.h                         |   1 +
 sound/soc/codecs/sgtl5000.c                        |   3 +-
 sound/soc/codecs/sgtl5000.h                        |   2 +-
 sound/soc/codecs/wm_adsp.c                         |   1 +
 sound/soc/samsung/snow.c                           |   1 +
 sound/soc/sh/fsi.c                                 |   3 +-
 sound/soc/sh/rcar/core.c                           |   3 +-
 sound/soc/soc-pcm.c                                |  72 +++++++++++---
 sound/usb/quirks.c                                 |  14 +++
 175 files changed, 1314 insertions(+), 680 deletions(-)

Aaro Koskinen (2):
      MIPS: oprofile: Fix backtrace on 64-bit kernel
      MIPS: Loongson: Make platform serial setup always built-in.

Alex Deucher (2):
      drm/radeon: fix endian swapping in vbios fetch for tdp table
      drm/radeon: report disconnected for LVDS/eDP with PX if ddc fails

Alexander Kochetkov (2):
      i2c: omap: fix NACK and Arbitration Lost irq handling
      i2c: omap: fix i207 errata handling

Alexey Khoroshilov (2):
      ieee802154: fix error handling in ieee802154fake_probe()
      can: esd_usb2: fix memory leak on disconnect

Anantha Krishnan (1):
      Bluetooth: Add support for Acer [13D3:3432]

Anatol Pomozov (1):
      Bluetooth: Fix crash in the Marvell driver initialization codepath

Andreas Färber (1):
      ASoC: samsung: Add MODULE_DEVICE_TABLE for Snow

Andreas Noever (1):
      PCI: pciehp: Prevent NULL dereference during probe

Andreas Schwab (1):
      arm64/crypto: fix makefile rule for aes-glue-%.o

Andrew Morton (2):
      mm/vmpressure.c: fix race in vmpressure_work_fn()
      drivers/input/evdev.c: don't kfree() a vmalloc address

Andy Lutomirski (5):
      x86_64, traps: Stop using IST for #SS
      uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME
      x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
      x86_64, traps: Rework bad_iret
      x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync_regs

Anton Blanchard (1):
      powerpc: 32 bit getcpu VDSO function uses 64 bit instructions

Axel Lin (1):
      iio: adc: men_z188_adc: Add terminating entry for men_z188_ids

Bart Van Assche (1):
      srp-target: Retry when QP creation fails with ENOMEM

Ben Hutchings (1):
      drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets

Ben Sagal (1):
      Input: synaptics - adjust min/max on Thinkpad E540

Benjamin Herrenschmidt (6):
      of/base: Fix PowerPC address parsing hack
      PCI/MSI: Add device flag indicating that 64-bit MSIs don't work
      gpu/radeon: Set flag to indicate broken 64-bit MSI
      sound/radeon: Move 64-bit MSI quirk from arch to driver
      powerpc/pseries: Honor the generic "no_64bit_msi" flag
      powerpc/powernv: Honor the generic "no_64bit_msi" flag

Benjamin Valentin (1):
      Input: xpad - sync device IDs with xboxdrv

Bjorn Helgaas (1):
      of/irq: Drop obsolete 'interrupts' vs 'interrupts-extended' text

Charles Keepax (2):
      ASoC: wm_adsp: Avoid attempt to free buffers that might still be in use
      spi: Fix mapping from vmalloc-ed buffer to scatter list

Chris Clayton (1):
      x86: Use $(OBJDUMP) instead of plain objdump

Chris Mason (2):
      btrfs: fix lockups from btrfs_clear_path_blocking
      btrfs: zero out left over bytes after processing compression streams

Chris Moore (1):
      IB/isert: Adjust CQ size to HW limits

Chris Wilson (1):
      drm/i915: Handle failure to kick out a conflicting fb driver

Christian König (1):
      drm/radeon: sync all BOs involved in a CS v2

Christian Sünkenberg (1):
      scsi: add Intel Multi-Flex to scsi scan blacklist

Christoph Hellwig (1):
      nfsd: correctly define v4.2 support attributes

Cristina Ciocan (1):
      iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask

Daniel Borkmann (2):
      ixgbe: fix use after free adapter->state test in ixgbe_remove/ixgbe_probe
      net: sctp: use MAX_HEADER for headroom reserve in output path

Daniel Forrest (1):
      mm: fix anon_vma_clone() error treatment

Daniel Vetter (4):
      drm/i915: drop WaSetupGtModeTdRowDispatch:snb
      drm/i915: Kick fbdev before vgacon
      drm/i915: More cautious with pch fifo underruns
      drm/i915: Unlock panel even when LVDS is disabled

Dave Airlie (1):
      nouveau: move the hotplug ignore to correct place.

Dave Hansen (1):
      x86: Require exact match for 'noxsave' command line option

David Jeffery (1):
      nfs: Don't busy-wait on SIGKILL in __nfs_iocounter_wait

David S. Miller (1):
      sparc64: Fix constraints on swab helpers.

Denis Kirjanov (1):
      mips: bpf: Fix broken BPF_MOD

Devin Ryles (2):
      ALSA: hda_intel: Add DeviceIDs for Sunrise Point-LP
      AHCI: Add DeviceIDs for Sunrise Point-LP SATA controller

Dmitry Eremin-Solenikov (1):
      ARM: 8216/1: xscale: correct auxiliary register in suspend/resume

Dmitry Torokhov (1):
      sata_fsl: fix error handling of irq_of_parse_and_map

Eric Dumazet (1):
      net: mvneta: fix race condition in mvneta_tx()

Fabio Estevam (1):
      ASoC: sgtl5000: Fix SMALL_POP bit definition

Frank Razenberg (1):
      Input: xpad - add VID/PID for Razer Sabertooth

Gavin Shan (1):
      powerpc/powernv: Replace OPAL_DEASSERT_RESET with EEH_RESET_DEACTIVATE

Greg Kroah-Hartman (1):
      Input: xpad - use proper endpoint type

Grygorii Strashko (1):
      i2c: davinci: generate STP always when NACK is received

Gu Zheng (1):
      aio: fix uncorrent dirty pages accouting when truncating AIO ring buffer

Hans de Goede (2):
      USB: uas: Add no-uas quirk for Hitachi usb-3 enclosures 4971:1012
      usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000

Hugh Dickins (1):
      mm: fix swapoff hang after page migration and fork

Ian Campbell (1):
      of/fdt: memblock_reserve /memreserve/ regions in the case of partial overlap

Ilia Mirkin (1):
      drm/nouveau/gf116: remove copy1 engine

Jack Morgenstein (1):
      net/mlx4_core: Limit count field to 24 bits in qp_alloc_res

James Cowgill (1):
      MIPS: IP27: Fix __node_distances undefined error

James Hogan (1):
      clk-divider: Fix READ_ONLY when divider > 1

James Ralston (1):
      ALSA: hda_intel: Add Device IDs for Intel Sunrise Point PCH

Jane Zhou (1):
      net/ping: handle protocol mismatching scenario

Jiri Bohac (1):
      ipx: fix locking regression in ipx_sendmsg and ipx_recvmsg

Johan Hovold (3):
      USB: keyspan: fix tty line-status reporting
      USB: keyspan: fix overrun-error reporting
      USB: ssu100: fix overrun-error reporting

Joonyoung Shim (1):
      USB: add reset resume quirk for usb3503

Jurgen Kramer (1):
      ALSA: usb-audio: Add ctrl message delay quirk for Marantz/Denon devices

Kailang Yang (1):
      ALSA: hda/realtek - Add headset Mic support for new Dell machine

Kees Cook (2):
      x86, mm: Set NX across entire PMD at boot
      x86, kaslr: Handle Gold linker for finding bss/brk

Kevin Cernekee (1):
      of: Fix crash if an earlycon driver is not found

Kuninori Morimoto (2):
      ASoC: fsi: remove unsupported PAUSE flag
      ASoC: rsnd: remove unsupported PAUSE flag

Larry Finger (1):
      staging: r8188eu: Add new device ID for DLink GO-USB-N150

Laurent Dufour (1):
      powerpc/pseries: Fix endiannes issue in RTAS call from xmon

Linus Torvalds (1):
      fold swapping ->d_name.hash into switch_names()

Lu Baolu (2):
      Revert "xhci: clear root port wake on bits if controller isn't wake-up capable"
      usb: xhci: rework root port wake bits if controller isn't allowed to wakeup

Marc Zyngier (1):
      net: sun4i-emac: fix memory leak on bad packet

Marcel Holtmann (5):
      Bluetooth: Add support for Intel bootloader devices
      Bluetooth: Handle Intel USB bootloader with buggy interrupt
      Bluetooth: Ignore isochronous endpoints for Intel USB bootloader
      Bluetooth: Fix endian and alignment issue with ath3k version handling
      Bluetooth: Add support for Broadcom device of Asus Z97-DELUXE motherboard

Marcelo Leitner (1):
      Fix race condition between vxlan_sock_add and vxlan_sock_release

Mark Rustad (1):
      ixgbe: Fix possible null-dereference in error path

Markos Chandras (4):
      MIPS: asm: uaccess: Add v1 register to clobber list on EVA
      MIPS: lib: memcpy: Restore NOP on delay slot before returning to caller
      MIPS: r4kcache: Add EVA case for protected_writeback_dcache_line
      MIPS: cpu-probe: Set the FTLB probability bit on supported cores

Martin Hauke (1):
      qmi_wwan: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Mathias Krause (1):
      pptp: fix stack info leak in pptp_getname()

Mathias Nyman (2):
      USB: xhci: don't start a halted endpoint before its new dequeue is set
      USB: xhci: Reset a halted endpoint immediately when we encounter a stall.

Maurizio Lombardi (1):
      bnx2fc: do not add shared skbs to the fcoe_rx_list

Maxime COQUELIN (1):
      bitops: Fix shift overflow in GENMASK macros

Maxime Ripard (1):
      clockevent: sun4i: Fix race condition in the probe code

Miaoqing Pan (1):
      ath9k: Fix RTC_DERIVED_CLK usage

Mikhail Efremov (1):
      vfs: Don't exchange "short" filenames unconditionally.

Nicholas Bellinger (1):
      vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDPOINT

Nicolas Dichtel (1):
      rtnetlink: release net refcnt on error in do_setlink()

Nikolay Aleksandrov (1):
      bonding: fix curr_active_slave/carrier with loadbalance arp monitoring

Or Gerlitz (3):
      net/mlx4_en: Add VXLAN ndo calls to the PF net device ops too
      net/mlx4_en: Advertize encapsulation offloads features only when VXLAN tunnel is set
      ib_isert: Add max_send_sge=2 minimum for control PDU responses

Panu Matilainen (1):
      ipv4: Fix incorrect error code when adding an unreachable route

Paolo Bonzini (1):
      x86: kvm: use alternatives for VMCALL vs. VMMCALL if kernel text is read-only

Paul Burton (1):
      MIPS: fix EVA & non-SMP non-FPU FP context signal handling

Paul Mackerras (1):
      slab: fix nodeid bounds check for non-contiguous node IDs

Petr Mladek (1):
      drm/radeon: kernel panic in drm_calc_vbltimestamp_from_scanoutpos with 3.18.0-rc6

Preston Fick (1):
      USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick

Qipan Li (1):
      spi: sirf: fix word width configuration

Rafael J. Wysocki (1):
      ACPI / PM: Ignore wakeup setting if the ACPI companion can't wake up

Reyad Attiyat (1):
      HID: usbhid: Use flag HID_DISCONNECTED when a usb device is removed

Richard Leitner (1):
      Input: serio - avoid negative serio device numbers

Robert Jarzmik (1):
      ARM: pxa: fix hang on startup with DEBUG_LL

Roland Dreier (1):
      target: Don't call TFO->write_pending if data_length == 0

Ronald Wahl (1):
      mac80211: Fix regression that triggers a kernel BUG with CCMP

Sagi Grimberg (1):
      iser-target: Handle DEVICE_REMOVAL event on network portal listener correctly

Sakari Ailus (1):
      [media] smiapp: Only some selection targets are settable

Seth Forshee (1):
      xen-netfront: Remove BUGs on paged skb data which crosses a page boundary

Stanislaw Gruszka (1):
      rt2x00: do not align payload on modern H/W

Steven Capper (2):
      ARM: 8108/1: mm: Introduce {pte,pmd}_isset and {pte,pmd}_isclear
      ARM: 8109/1: mm: Modify pte_write and pmd_write logic for LPAE

Takashi Iwai (2):
      ASoC: dpcm: Fix race between FE/BE updates and trigger
      ALSA: hda - Limit 40bit DMA for AMD HDMI controllers

Tejun Heo (1):
      ahci: disable MSI on SAMSUNG 0xa800 SSD

Thadeu Lima de Souza Cascardo (1):
      tg3: fix ring init when there are more TX than RX channels

Thomas Graf (1):
      bond: Check length of IFLA_BOND_ARP_IP_TARGET attributes

Thomas Körper (1):
      can: dev: avoid calling kfree_skb() from interrupt context

Thomas Petazzoni (3):
      ASoC: cs42l51: re-hook of_match_table pointer
      ARM: mvebu: add missing of_node_put() call in coherency.c
      ARM: 8222/1: mvebu: enable strex backoff delay

Thor Thayer (1):
      spi: dw: Fix dynamic speed change.

Todd Fujinaka (1):
      igb: bring link up when PHY is powered up

Tom Herbert (1):
      gre: Set inner mac header in gro complete

Tommi Rantala (1):
      Input: xpad - add USB ID for Thrustmaster Ferrari 458 Racing Wheel

Trond Myklebust (2):
      SUNRPC: Fix locking around callback channel reply receive
      nfsd: Fix slot wake up race in the nfsv4.1 callback code

Troy Clark (1):
      usb: serial: ftdi_sio: add PIDs for Matrix Orbital products

Ville Syrjälä (1):
      drm/i915: Ignore SURFLIVE and flip counter when the GPU gets reset

Vincent BENAYOUN (1):
      inetdevice: fixed signed integer overflow

Vincent Zwanenburg (1):
      Add a new PID/VID 0227/0930 for AR3012.

Vishnu Motghare (1):
      i2c: cadence: Set the hardware time-out register to maximum value

Vlad Yasevich (1):
      ixgbe: Correctly disable VLAN filter in promiscuous mode

Vladimir Murzin (1):
      ARM: 8226/1: cacheflush: get rid of restarting block

Weijie Yang (1):
      mm: frontswap: invalidate expired data on a dup-store failure

Yinghai Lu (1):
      PCI: Support 64-bit bridge windows if we have 64-bit dma_addr_t

Yuri Chislov (1):
      ipv6: gre: fix wrong skb->protocol in WCCP

lucien (1):
      ip_tunnel: the lack of vti_link_ops' dellink() cause kernel panic

sensoray-dev (1):
      [media] s2255drv: fix payload size for JPG, MJPEG

willy tarreau (1):
      net: mvneta: fix Tx interrupt delay
