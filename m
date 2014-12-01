Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaLABNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 20:13:50 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:56010 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaLABNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 20:13:47 -0500
MIME-Version: 1.0
Date: Sun, 30 Nov 2014 17:13:43 -0800
X-Google-Sender-Auth: 3uSS-D3YJ4IQD1cEXIxDiCWlyz0
Message-ID: <CA+55aFwLviRW2nJPXoLu1CG-2sVZ5XDNtp0GQVNB6Uobq+hdUQ@mail.gmail.com>
Subject: Linux 3.18-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Things are calming down nicely, and everything looks pretty normal.
In fact, if it wasn't for the pending issues with odd watchdog (and
possibly rcu) lockups I'd be pretty happy. As it is, that isn't a
regression from 3.17, but is still very disturbing.

At the same time, with the holidays coming up, and the problem _not_
being a regression, I suspect that what will happen is that I'll
release 3.18 on time in a week, because delaying it will either mess
up the merge window and the holiday season, or I'd have to delay it a
*lot*.

We'll see. Maybe DaveJ will be able to bisect it a bit now that the
false lead of "3.17 was ok" has been shown to be wrong (right now it
looks like the problem seems to have crept in between 3.16 and 3.17).

Annoying, because as mentioned, other than that we seem to be doing
well. The rc7 patch looks very normal, with two thirds being drivers
(spread all over: usb, networking, staging, thermal, gpu, sound..) and
half of the remaining being arch updates (mostly mips, arm, powerpc).
The remaining is mainly networking and some filesystem fixes (nfsd and
btrfs).

               Linus

----
Aaro Koskinen (1):
      MIPS: Loongson: Make platform serial setup always built-in.

Akinobu Mita (3):
      ufs: fix reference counting of W-LUs
      ufs: ensure clk gating work is finished before module unloading
      ufs: fix NULL dereference when no regulators are defined

Alex Deucher (1):
      drm/radeon: report disconnected for LVDS/eDP with PX if ddc fails

Alexander Duyck (3):
      ipv6: Do not treat a GSO_TCPV4 request from UDP tunnel over IPv6
as invalid
      ip6_udp_tunnel: Fix checksum calculation
      vxlan: Fix boolean flip in VXLAN_F_UDP_ZERO_CSUM6_[TX|RX]

Alexey Khoroshilov (1):
      xen-netback: do not report success if backend_create_xenvif() fails

Andrew Lutomirski (1):
      net-timestamp: Fix a documentation typo

Anton Blanchard (1):
      powerpc: 32 bit getcpu VDSO function uses 64 bit instructions

Ard Biesheuvel (2):
      arm/arm64: kvm: drop inappropriate use of kvm_is_mmio_pfn()
      kvm: fix kvm_is_mmio_pfn() and rename to kvm_is_reserved_pfn()

Arnaud Ebalard (1):
      hwmon: (g762) fix call to devm_hwmon_device_register_with_groups()

Axel Lin (1):
      iio: adc: men_z188_adc: Add terminating entry for men_z188_ids

Ben Sagal (1):
      Input: synaptics - adjust min/max on Thinkpad E540

Benjamin Herrenschmidt (6):
      PCI/MSI: Add device flag indicating that 64-bit MSIs don't work
      gpu/radeon: Set flag to indicate broken 64-bit MSI
      sound/radeon: Move 64-bit MSI quirk from arch to driver
      powerpc/powernv: Honor the generic "no_64bit_msi" flag
      powerpc/pseries: Honor the generic "no_64bit_msi" flag
      powerpc/pci: Remove unused force_32bit_msi quirk

Boris Brezillon (3):
      irqchip: atmel-aic: Fix irqdomain initialization
      clk: at91: usb: fix at91rm9200 round and set rate
      clk: at91: usb: fix at91sam9x5 recalc, round and set rate

Carolyn Wyborny (1):
      igb: Fixes needed for surprise removal support

Charles Keepax (1):
      spi: Fix mapping from vmalloc-ed buffer to scatter list

Chris Mason (1):
      btrfs: zero out left over bytes after processing compression streams

Christian Sünkenberg (1):
      scsi: add Intel Multi-Flex to scsi scan blacklist

Christoffer Dall (2):
      arm64: KVM: Handle traps of ICC_SRE_EL1 as RAZ/WI
      arm/arm64: KVM: vgic: Fix error code in kvm_vgic_create()

Christoph Hellwig (1):
      nfsd: correctly define v4.2 support attributes

Cristina Ciocan (1):
      iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask

Daniel Baluta (1):
      iio: accel: kxcjk-1013: Fix kxcjk10013_set_range

Daniel Borkmann (1):
      ixgbe: fix use after free adapter->state test in ixgbe_remove/ixgbe_probe

David S. Miller (1):
      sparc: Add NOP dma_cache_sync() implementation.

Dmitry Eremin-Solenikov (1):
      ARM: 8216/1: xscale: correct auxiliary register in suspend/resume

Dmitry Torokhov (3):
      Input: elantech - trust firmware about trackpoint presence
      irqchip: bcm7120-l2: Fix error handling of irq_of_parse_and_map
      irqchip: brcmstb-l2: Fix error handling of irq_of_parse_and_map

Dolev Raviv (4):
      scsi: ufs: fix static checker errors in ufshcd_system_suspend
      scsi: ufs: fix static checker warning in ufshcd_populate_vreg
      scsi: ufs: fix static checker warning in __ufshcd_setup_clocks
      scsi: ufs: fix static checker warning in ufshcd_parse_clock_info

Eric Dumazet (1):
      tcp: fix possible NULL dereference in tcp_vX_send_reset()

Felipe Balbi (1):
      usb: dwc3: ep0: fix for dead code

Florian Fainelli (4):
      MIPS: Netlogic: handle modular USB case
      MIPS: Netlogic: handle modular AHCI builds
      net: dsa: bcm_sf2: fix unmapping registers in case of errors
      net: dsa: bcm_sf2: reset switch prior to initialization

Gavin Shan (2):
      powerpc/eeh: Fix PE state format
      powerpc/powernv: Replace OPAL_DEASSERT_RESET with EEH_RESET_DEACTIVATE

Georgi Djakov (1):
      clk: qcom: Fix duplicate rbcpr clock name

Greg Kroah-Hartman (2):
      Input: xpad - use proper endpoint type
      Revert "serial: of-serial: add PM suspend/resume support"

Gu Zheng (1):
      aio: fix uncorrent dirty pages accouting when truncating AIO ring buffer

Hans de Goede (2):
      USB: uas: Add no-uas quirk for Hitachi usb-3 enclosures 4971:1012
      usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000

Huacai Chen (2):
      MIPS: Fix a copy & paste error in unistd.h
      stmmac: platform: fix default values of the filter bins setting

Hui Wang (1):
      ALSA: hda - One more HP machine needs to change mute led quirk

Jack Morgenstein (1):
      net/mlx4_core: Limit count field to 24 bits in qp_alloc_res

James Hogan (1):
      clk-divider: Fix READ_ONLY when divider > 1

Jane Zhou (1):
      net/ping: handle protocol mismatching scenario

Javier Martinez Canillas (1):
      ARM: exynos_defconfig: Enable max77802 rtc and clock drivers

Johan Hovold (3):
      USB: keyspan: fix tty line-status reporting
      USB: keyspan: fix overrun-error reporting
      USB: ssu100: fix overrun-error reporting

Julia Lawall (1):
      solos-pci: fix error return code

Jussi Laako (1):
      ALSA: pcm: Add big-endian DSD sample formats and fix XMOS DSD
sample format

Kevin Cernekee (1):
      MIPS: BMIPS: Fix ".previous without corresponding .section" warnings

Larry Finger (4):
      rtlwifi: rtl8821ae: Fix 5G detection problem
      rtlwifi: Change order in device startup
      staging: r8188eu: Fix scheduling while atomic error introduced
in commit fadbe0cd
      staging: r8188eu: Add new device ID for DLink GO-USB-N150

Laurent Dufour (1):
      powerpc/pseries: Fix endiannes issue in RTAS call from xmon

Lee Jones (1):
      thermal: sti: Ignore suspend/resume functions when !PM_SLEEP

Leonid Yegoshin (1):
      MIPS: tlbex: Fix potential HTW race on TLBL/M/S handlers

Linus Torvalds (1):
      Linux 3.18-rc7

Lu Baolu (2):
      Revert "xhci: clear root port wake on bits if controller isn't
wake-up capable"
      usb: xhci: rework root port wake bits if controller isn't
allowed to wakeup

Luciano Coelho (1):
      iwlwifi: mvm: check TLV flag before trying to use hotspot
firmware commands

Mahesh Salgaonkar (1):
      powerpc/powernv: Fix the hmi event version check.

Marc Zyngier (1):
      ARM: tegra: irq: fix buggy usage of irq_data irq field

Mark Rutland (1):
      arm64: KVM: fix unmapping with 48-bit VAs

Markos Chandras (4):
      MIPS: r4kcache: Add EVA case for protected_writeback_dcache_line
      MIPS: cpu-probe: Set the FTLB probability bit on supported cores
      MIPS: kernel: cps-vec: Set ISA level to mips32r2 for the MIPS MT ASE
      MIPS: Kconfig: Don't allow both microMIPS and SmartMIPS to be selected.

Markus Elfring (1):
      thermal: Exynos: Deletion of unnecessary checks before two function calls

Masanari Iida (1):
      MIPS: rtlx: Remove KERN_DEBUG from pr_debug() arguments in rtlx.c

Mathias Nyman (2):
      USB: xhci: don't start a halted endpoint before its new dequeue is set
      USB: xhci: Reset a halted endpoint immediately when we encounter a stall.

Maurizio Lombardi (1):
      bnx2fc: do not add shared skbs to the fcoe_rx_list

Michael S. Tsirkin (1):
      af_packet: fix sparse warning

Pablo Neira (1):
      Revert "netfilter: conntrack: fix race in __nf_conntrack_confirm
against get_next_corpse"

Paul Burton (1):
      MIPS: fix EVA & non-SMP non-FPU FP context signal handling

Preston Fick (1):
      USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick

Qipan Li (1):
      spi: sirf: fix word width configuration

Rafał Miłecki (1):
      MIPS: Fix info about plat_setup in arch_mem_init comment

Ralf Baechle (2):
      MIPS: SEAD3: Fix LED device registration.
      MIPS: uaccess.h: Fix strnlen_user comment.

Robert Jarzmik (1):
      clk: pxa: fix pxa27x CCCR bit usage

Sjoerd Simons (1):
      ARM: dts: Explicitly set dr_mode on exynos5250-snow

Srinivas Pandruvada (8):
      iio: gyro: bmg160: Error handling when mode set fails
      iio: gyro: bmg160: Don't let interrupt mode to be open drain
      iio: gyro: bmg160: Send x, y and z motion separately
      iio: gyro: bmg160: Fix iio_event_spec direction
      iio: accel: bmc150: Error handling when mode set fails
      iio: accel: bmc150: Send x, y and z motion separately
      iio: accel: bmc150: Fix iio_event_spec direction
      iio: accel: bmc150: set low default thresholds

Steven J. Hill (1):
      MIPS: Fix address type used for early memory detection.

Takashi Iwai (2):
      ALSA: usb-audio: Use snd_usb_ctl_msg() for Native Instruments quirk
      ALSA: hda - Limit 40bit DMA for AMD HDMI controllers

Thadeu Lima de Souza Cascardo (1):
      tg3: fix ring init when there are more TX than RX channels

Thomas Graf (5):
      bridge: Validate IFLA_BRIDGE_FLAGS attribute length
      net: Validate IFLA_BRIDGE_MODE attribute length
      net: Check for presence of IFLA_AF_SPEC
      bridge: Add missing policy entry for IFLA_BRPORT_FAST_LEAVE
      bridge: Sanitize IFLA_EXT_MASK for AF_BRIDGE:RTM_GETLINK

Thomas Petazzoni (2):
      ARM: mvebu: add missing of_node_put() call in coherency.c
      ARM: 8222/1: mvebu: enable strex backoff delay

Thor Thayer (1):
      spi: dw: Fix dynamic speed change.

Trond Myklebust (2):
      SUNRPC: Fix locking around callback channel reply receive
      nfsd: Fix slot wake up race in the nfsv4.1 callback code

Troy Clark (1):
      usb: serial: ftdi_sio: add PIDs for Matrix Orbital products

Ville Syrjälä (2):
      drm/i915: Ignore SURFLIVE and flip counter when the GPU gets reset
      drm/i915: Cancel vdd off work before suspend

Vlad Yasevich (1):
      ixgbe: Correctly disable VLAN filter in promiscuous mode

Vladimir Murzin (1):
      ARM: 8226/1: cacheflush: get rid of restarting block

Willem de Bruijn (1):
      net-timestamp: make tcp_recvmsg call ipv6_recv_error for AF_INET6 socks

Yadwinder Singh Brar (1):
      thermal: cpu_cooling: Update always cpufreq policy with thermal
constraints

Yaniv Gardi (1):
      ufs: fix power info after link start-up

Yuri Chislov (1):
      ipv6: gre: fix wrong skb->protocol in WCCP

lucien (1):
      ip_tunnel: the lack of vti_link_ops' dellink() cause kernel panic
