Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3DHEdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:33:18 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:43847 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3DHEdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:33:16 -0400
MIME-Version: 1.0
Date: Sun, 7 Apr 2013 21:33:14 -0700
X-Google-Sender-Auth: k03h-j49u5V9kdcmIvMv71wgZCI
Message-ID: <CA+55aFxf+CqwUME4oT6fCEUeycEQShm1zRfxxsj+yV2-wtY93w@mail.gmail.com>
Subject: Linux 3.9-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Things seem to be on track, and it's been a mostly boring week. Lots
of small fixes, a few reverts. Networking, some small arch fixes (arm,
mips, s390, alpha, tile, x86), drivers, minor filesystem updates
(gfs2, ext4, tiny reiserfs xattr fix). Nothing really exciting stands
out, I think the appended ShortLog gives a good overview for people
who want to wallow in the details..

Things seem to be on track, which means that unless something comes
up, rc7 will probably be the last rc as usual,

                Linus


---

Aaro Koskinen (1):
      ARM: OMAP1: fix USB host on 1710

Adam Jackson (1):
      drm/i915: Be sure to turn hsync/vsync back on at crt enable (v2)

Akinobu Mita (1):
      GFS2: use memchr_inv

Alex Shi (1):
      cpuidle / ACPI: recover percpu ACPI processor cstate

Alexander Clouter (2):
      arm: orion5x: fix orion5x.dtsi gpio parameters
      arm: orion5x: correct IRQ used in dtsi for mv_cesa

Alexey Klimov (2):
      HID: fix Masterkit MA901 hid quirks
      media: radio-ma901: return ENODEV in probe if usb_device doesn't match

Amit Shah (2):
      virtio: console: rename cvq_lock to c_ivq_lock
      virtio: console: add locking around c_ovq operations

Anatol Pomozov (1):
      loop: prevent bdev freeing while device in use

Anatolij Gustschin (1):
      spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts

Andrew Honig (1):
      KVM: Allow cross page reads and writes from cached translations.

Artem Bityutskiy (1):
      UBIFS: make space fixup work in the remount case

Avinash Patil (1):
      mwifiex: reset skb->data after processing PCIe sleep confirm cmd respose

Axel Lin (1):
      ASoC: si476x: Add missing break for SNDRV_PCM_FORMAT_S8 switch case

Balakumaran Kannan (1):
      net IPv6 : Fix broken IPv6 routing table after loopback down-up

Ben Greear (1):
      mac80211: Don't restart sta-timer if not associated.

Ben Hutchings (1):
      MIPS: Add dependencies for HAVE_ARCH_TRANSPARENT_HUGEPAGE

Benjamin Tissoires (1):
      HID: magicmouse: fix race between input_register() and probe()

Bjorn Helgaas (1):
      Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"

Bob Peterson (1):
      GFS2: Issue discards in 512b sectors

Borislav Petkov (1):
      cpufreq: Correct header guards typo

Bryan Freed (1):
      spi: Unlock a spinlock before calling into the controller driver.

Catalin Marinas (1):
      ARM: 7684/1: errata: Workaround for Cortex-A15 erratum 798181
(TLBI/DSB operations)

Chris Metcalf (1):
      tile: expect new initramfs name from hypervisor file system

Christoph Paasch (3):
      e1000: ethtool: Add missing dma_mapping_error-call in
e1000_setup_desc_rings
      ixgb: Add missing dma_mapping_error-call in ixgb_alloc_rx_buffers
      e1000e: Add missing dma_mapping_error-call in e1000_alloc_jumbo_rx_buffers

Colin Ian King (1):
      iwlegacy: 4965-rs: avoid null pointer dereference error

Dan Williams (1):
      libertas: drop maintainership

Daniel Vetter (2):
      drm/i915: duct-tape locking when eDP init fails
      drm: don't unlock in the addfb error paths

Darrick J. Wong (1):
      dm cache: fix writes to cache device in writethrough mode

David Daney (2):
      MIPS: Fix logic errors in bitops.c
      MIPS: Unbreak function tracer for 64-bit kernel.

David Henningsson (1):
      ALSA: hda - fix typo in proc output

David Howells (1):
      Fix breakage in MIPS siginfo handling

David Teigland (1):
      GFS2: use kmalloc for lvb bitmap

Deng-Cheng Zhu (1):
      MIPS: Fix ISA level which causes secondary cache init bypassing and more

Dimitris Papastamos (1):
      regmap: Initialize `map->debugfs' before regcache

Dmitry Kravkov (1):
      line up comment for ndo_bridge_getlink

Emmanuel Grumbach (3):
      iwlwifi: fix length check in multi-TB HCMD
      iwlwifi: set rfkill in internal state of the transport
      iwlwifi: dvm: don't send HCMD in restart flow

Eric Dumazet (2):
      aoe: reserve enough headroom on skbs
      net: add a synchronize_net() in netdev_rx_handler_unregister()

Eric Hutter (1):
      ARM: kirkwood: Fix chip-delay for GoFlex Net

Eric W. Biederman (2):
      Revert "af_unix: dont send SCM_CREDENTIAL when dest socket is NULL"
      af_unix: If we don't care about credentials coallesce all messages

EunBong Song (1):
      MIPS: Fix build error cavium-octeon without CONFIG_SMP

Florian Fainelli (1):
      MIPS: Fix code generation for non-DSP capable CPUs

Frank Li (1):
      enet: fec: fix fail resume from suspend state

Gabor Juhos (1):
      MIPS: Use CONFIG_CPU_MIPSR2 in csum_partial.S

Gabriel Fernandez (1):
      gpio: stmpe: pass DT node to irqdomain

Gao feng (1):
      netfilter: reset nf_trace in nf_reset

Girish K S (1):
      spi/s3c64xx: modified error interrupt handling and init

Grazvydas Ignotas (1):
      ARM: OMAP3: hwmod data: keep MIDLEMODE in force-standby for musb

Gregory CLEMENT (1):
      arm: mvebu: Use local interrupt only for the timer 0

H Hartley Sweeten (1):
      ARM: ep93xx: Fix wait for UART FIFO to be empty

Hannes Frederic Sowa (3):
      ipv6: don't accept node local multicast traffic from the wire
      atl1e: drop pci-msi support because of packet corruption
      atl1e: limit gso segment size to prevent generation of wrong ip
length fields

Heiko Carstens (4):
      drivers/Kconfig: add several missing GENERIC_HARDIRQS dependencies
      s390/uaccess: fix clear_user_pt()
      s390/uaccess: fix page table walk
      s390/mm: provide emtpy check_pgt_cache() function

Iestyn C. Elfick (1):
      b43: A fix for DMA transmission sequence errors

Ilija Hadzic (1):
      drm: correctly restore mappings if drm_open fails

J. Bruce Fields (1):
      nfsd4: reject "negative" acl lengths

Jakub Kicinski (1):
      ixgbe: fix registration order of driver and DCA nofitication

Jan Beulich (1):
      x86: Fix rebuild with EFI_STUB enabled

Jan Kara (1):
      reiserfs: Fix warning and inode leak when deleting inode with xattrs

Jan Stancek (1):
      mm: prevent mmap_cache race in find_vma()

Jay Estabrook (1):
      alpha: Add irongate_io to PCI bus resources

Jean Delvare (1):
      gpio-ich: Fix value returned by ichx_gpio_request

Jingoo Han (1):
      fbmon: use VESA_DMT_VSYNC_HIGH to fix typo

Jiri Pirko (1):
      net: ipv4: notify when address lifetime changes

Jiri Slaby (1):
      ALSA: hda/generic - fix uninitialized variable

Joe Perches (1):
      ASoC:: max98090: Remove executable bit

Johan Hovold (1):
      Revert "drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR"

Johannes Berg (9):
      mac80211: always synchronize_net() during station removal
      cfg80211: fix potential BSS memory leak and update
      mac80211: fix crash with P2P Device returning action frames
      cfg80211: fix wdev tracing crash
      mac80211: fix virtual monitor interface locking
      cfg80211: always check for scan end on P2P device
      mac80211: fix remain-on-channel cancel crash
      mac80211: fix idle handling sequence
      iwlwifi: dvm: fix the passive-no-RX workaround

John Crispin (1):
      MIPS: Fix inconsistent formatting inside /proc/cpuinfo

John W. Linville (1):
      Revert "brcmsmac: support 4313iPA"

Jon Hunter (1):
      ARM: OMAP4: clock data: lock USB DPLL on boot

Jonas Gorski (3):
      spi/bcm63xx: don't disable non enabled clocks in probe error path
      MIPS: BCM63XX: Make nvram checksum failure non fatal
      Revert "MIPS: BCM63XX: Call board_register_device from device_initcall()"

Joseph CHANG (1):
      DM9000B: driver initialization upgrade

Kees Cook (1):
      tg3: fix length overflow in VPD firmware parsing

Kevin Cernekee (1):
      spi/bcm63xx: Remove unused variable

Konstantin Khlebnikov (1):
      PCI: Don't try to disable Bus Master on disconnected PCI devices

Kuninori Morimoto (1):
      fbdev: sh_mobile_lcdc: fixup B side hsync adjust settings

Lars-Peter Clausen (3):
      regmap: cache Fix regcache-rbtree sync
      ASoC: spear_pcm: Update to new pcm_new() API
      ASoC: dma-sh7760: Fix compile error

Lauri Kasanen (1):
      drm/i915: Fix build failure

Laxman Dewangan (1):
      spi: slink-tegra20: move runtime pm calls to transfer_one_message

Lee Jones (3):
      ARM: ux500: Apply the TCPM and TCDM locations and sizes to dbx5x0 DT
      ARM: ux500: Stop passing ios_handler() as an MMCI power
controlling call-back
      ARM: ux500: Enable the clock controlling Ethernet on Snowball

Li RongQing (1):
      net: fix the use of this_cpu_ptr

Linus Torvalds (1):
      Linux 3.9-rc6

Luis R. Rodriguez (1):
      ath9k: avoid queueing hw check work when suspended

Maarten Lankhorst (2):
      drm/nouveau: fix handling empty channel list in ioctl's
      drm/nouveau: fix NULL ptr dereference from nv50_disp_intr()

Mac Lin (1):
      ARM: cns3xxx: fix mapping of private memory region

Manish Chopra (1):
      MAINTAINERS: Update netxen_nic maintainers list

Marc Kleine-Budde (2):
      can: sja1000: fix define conflict on SH
      can: sja1000: limit PEAK PCAN-PC Card to HAS_IOPORT

Marc Zyngier (2):
      ARM: KVM: vgic: force EOIed LRs to the empty state
      ARM: KVM: vgic: take distributor lock on sync_hwstate path

Mark Brown (2):
      ASoC: dapm: Fix handling of loops
      regmap: async: Add missing return

Markus Pargmann (1):
      ASoC: pcm030 audio fabric: remove __init from probe

Martin Schwidefsky (1):
      s390/3270: fix minor_start issue

Mathias Krause (1):
      xfrm: Fix esn sequence number diff calculation in xfrm_replay_notify_esn()

Matthew Garrett (3):
      PCI: Add PCI ROM helper for platform-provided ROM images
      nouveau: Attempt to use platform-provided ROM image
      radeon: Attempt to use platform-provided ROM image

Matthias Schiffer (1):
      netfilter: ip6t_NPT: Fix translation for non-multiple of 32 prefix lengths

Max.Nekludov@us.elster.com (1):
      ks8851: Fix interpretation of rxlen field.

Mengdong Lin (2):
      ALSA: hda - bug fix on return value when getting HDMI ELD info
      ALSA: hda - bug fix on HDMI ELD debug message

Mike Marciniszyn (1):
      firmware,IB/qib: revert firmware file move

Mike Snitzer (1):
      dm cache: reduce bio front_pad size in writeback mode

Mirko Lindner (2):
      sky2: Receive Overflows not counted
      sky2: Threshold for Pause Packet is set wrong

Mugunthan V N (2):
      drivers: net: ethernet: cpsw: use netif_wake_queue() while
restarting tx queue
      drivers: net: ethernet: davinci_emac: use netif_wake_queue()
while restarting tx queue

Nicolas Dichtel (1):
      af_key: initialize satype in key_notify_policy_flush()

Pablo Neira Ayuso (1):
      netfilter: nfnetlink_acct: return -EINVAL if object name is empty

Paolo Pisati (1):
      cpufreq: check OF node /cpus presence before dereferencing it

Patrick McHardy (1):
      netfilter: don't reset nf_trace in nf_reset()

Paul Bolle (4):
      MIPS: Get rid of CONFIG_CPU_HAS_LLSC again
      ARM: 7690/1: mm: fix CONFIG_LPAE typos
      MIPS: Alchemy: Fix typo "CONFIG_DEBUG_PCI"
      MIPS: Kconfig: Rename SNIPROM too

Paul Moore (1):
      x86: remove the x32 syscall bitmask from syscall_get_nr()

Paul Walmsley (1):
      ARM: OMAP4: PM: fix PM regression introduced by recent clock cleanup

Peter Ujfalusi (1):
      ASoC: dapm: Fix pointer dereference in is_connected_output_ep()

Rabin Vincent (1):
      ARM: 7689/1: add unwind annotations to ftrace asm

Rafael J. Wysocki (6):
      USB / PM: Don't try to hide PM QoS flags from usb_port_device_release()
      PM / QoS: Avoid possible deadlock related to sysfs access
      ACPI / SPI: Use parent's ACPI_HANDLE() in acpi_register_spi_devices()
      ACPI / I2C: Use parent's ACPI_HANDLE() in acpi_i2c_register_devices()
      PCI/ACPI: Always resume devices on ACPI wakeup notifications
      PCI/PM: Disable runtime PM of PCIe ports

Rafał Miłecki (2):
      b43: N-PHY: increase initial value of "mind" in RSSI calibration
      b43: N-PHY: use more bits for offset in RSSI calibration

Rainer Koenig (1):
      ALSA: hda - Enabling Realtek ALC 671 codec

Rajagopal Venkat (1):
      PM / devfreq: Fix compiler warnings for CONFIG_PM_DEVFREQ unset

Rajendra Nayak (1):
      ARM: OMAP: clocks: Delay clk inits atleast until slab is initialized

Ralf Baechle (3):
      MIPS: compat: Return same error ENOSYS as native for invalid operation.
      MIPS: SEAD3: Enable LL/SC.
      MIPS: Delete definition of SA_RESTORER.

Reilly Grant (1):
      VSOCK: Handle changes to the VMCI context ID.

Rob Herring (3):
      net: calxedaxgmac: fix rx ring handling when OOM
      net: calxedaxgmac: Wake-on-LAN fixes
      ARM: 7682/1: cache-l2x0: fix masking of RTL revision numbering
and set_debug init

Robert Love (5):
      bnx2fc: Make the fcoe_cltr the SCSI host parent
      fcoe: Fix deadlock between create and destroy paths
      libfc, fcoe, bnx2fc: Always use fcoe_disc_init for discovery
layer initialization
      libfc, fcoe, bnx2fc: Split fc_disc_init into fc_disc_{init, config}
      libfcoe: Fix fcoe_sysfs VN2VN mode

Russell King (1):
      ARM: iWMMXt: always enable iWMMXt support with PJ4 CPUs

Ryan Press (1):
      arm: mvebu: Fix pinctrl for Armada 370 Mirabox SDIO port.

Samuel Ortiz (3):
      NFC: llcp: Detach socket from process context only when
releasing the socket
      NFC: llcp: Keep the connected socket parent pointer alive
      NFC: microread: Fix build failure due to a new MEI bus API

Santosh Shilimkar (1):
      ARM: 7681/1: hw_breakpoint: use warn_once to avoid spam from
reset_ctrl_regs()

Sascha Hauer (1):
      ASoC: imx-ssi: Fix occasional AC97 reset failure

Satoru Takeuchi (1):
      hw_random: free rng_buffer at module exit

Sebastian Hesselbarth (1):
      ARM: Kirkwood: fix unused mvsdio gpio pins

Sebastian Ott (1):
      s390/scm_block: fix printk format string

Sergei Shtylyov (3):
      sh_eth: fix handling of no LINK signal
      sh_eth: workaround for spurious ECI interrupt
      sh_eth: make 'link' field of 'struct sh_eth_private' *int*

Sergey Popovich (1):
      sch: add missing u64 in psched_ratecfg_precompute()

Shawn Guo (1):
      ARM: imx: fix sync issue between imx_cpu_die and imx_cpu_kill

Shmulik Ladkani (1):
      net: core: Remove redundant call to 'nf_reset' in 'dev_forward_skb'

Silviu-Mihai Popescu (1):
      ASoC: core: fix invalid free of devm_ allocated data

Sjur BrÃ¦ndeland (1):
      Revert "virtio_console: Initialize guest_connected=true for rproc_serial"

Sricharan R (1):
      ARM: 7677/1: LPAE: Fix mapping in alloc_init_section for
unaligned addresses

Stanislav Kinsbursky (1):
      ipc: set msg back to -EAGAIN if copy wasn't performed

Steffen Klassert (1):
      xfrm: Fix replay notification for esn.

Stepan Moskovchenko (1):
      ARM: 7678/1: Work around faulty ISAR0 register in some Krait CPUs

Stephen Boyd (3):
      ARM: 7679/1: Clear IDIVT hwcap if CONFIG_ARM_THUMB=n
      ARM: 7680/1: Detect support for SDIV/UDIV from ISAR0 register
      ARM: msm: Stop counting before reprogramming clockevent

Stephen Warren (1):
      regmap: don't corrupt work buffer in _regmap_raw_write()

Steve Glendinning (1):
      smsc75xx: fix jumbo frame support

Steven Whitehouse (1):
      GFS2: Fix unlock of fcntl locks during withdrawn state

Stone Piao (1):
      mwifiex: limit channel number not to overflow memory

Takashi Iwai (1):
      Revert "ALSA: hda - Allow power_save_controller option override DCAPS"

Thierry Escande (1):
      NFC: llcp: Remove possible double call to kfree_skb

Thierry Reding (1):
      clk: tegra: Allow PLLE training to succeed

Tony Luck (1):
      ACPI / BGRT: Don't let users configure BGRT on non X86 systems

Torstein Hegge (1):
      ALSA: usb: Work around CM6631 sample rate change bug

Vasily Averin (1):
      cbq: incorrect processing of high limits

Veaceslav Falico (2):
      bonding: get netdev_rx_handler_unregister out of locks
      bonding: remove sysfs before removing devices

Vijay Subramanian (1):
      net: fq_codel: Fix off-by-one error

Vlad Yasevich (1):
      net: count hw_addr syncs so that unsync works properly.

Vladimir Kondratiev (1):
      cfg80211: fix inconsistency in trace for rdev_set_mac_acl

Wang YanQing (1):
      video:uvesafb: Fix dereference NULL pointer code path

Wei Yongjun (7):
      ASoC: wm_adsp: fix possible memory leak in wm_adsp_load_coeff()
      ASoC: core: fix possible memory leak in snd_soc_bytes_put()
      s390/scm_blk: fix error return code in scm_blk_init()
      netfilter: nfnetlink_queue: fix error return code in
nfnetlink_queue_init()
      netfilter: nf_conntrack: fix error return code
      rtnetlink: fix error return code in rtnl_link_fill()
      GFS2: return error if malloc failed in gfs2_rs_alloc()

Will Deacon (4):
      ARM: 7685/1: delay: use private ticks_per_jiffy field for
timer-based delay ops
      alpha: makefile: don't enforce small data model for kernel builds
      alpha: irq: run all handlers with interrupts disabled
      alpha: irq: remove deprecated use of IRQF_DISABLED

Yan Burman (1):
      net/mlx4_en: Fix setting initial MAC address

Yinghai Lu (2):
      EISA/PCI: Fix bus res reference
      EISA/PCI: Init EISA early, before PNP

Yoichi Yuasa (1):
      MIPS: VR4133: Fix probe for LL/SC.

Zheng Liu (1):
      ext4: fix big-endian bugs which could cause fs corruptions

hayeswang (1):
      r8169: fix auto speed down issue

nikolay@redhat.com (1):
      bonding: fix disabling of arp_interval and miimon
