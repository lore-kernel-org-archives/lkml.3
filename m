Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaKBX2C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 18:28:02 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:51008 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaKBX16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 18:27:58 -0500
MIME-Version: 1.0
Date: Sun, 2 Nov 2014 15:27:55 -0800
X-Google-Sender-Auth: Ochlsw5RrjV2Vpf05zmRTkiFDHs
Message-ID: <CA+55aFyFU48eNptryNMxa+H9q+jqQXm00k18pzp2VjNey5gh-A@mail.gmail.com>
Subject: Linux 3.18-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another rc, and things aren't really shrinking the way I
would hope for...

While the patch itself is much smaller than rc2 was (no new filesystem
this rc!), there are actually more commits and more files affected.
It's all over, too.

That said, I don't think there is anything particularly horrible in
here. Lots and lots of small stuff, with drivers accounting for the
bulk of it (both in commits and in lines), but networking and core
kernel showing up too. Nothing particularly stands out.

Shortlog appended for details, please go forth and test.

                  Linus

---

Addy Ke (3):
      spi/rockchip: fix bug that case spi can't go as fast as slave request
      spi/rockchip: fix bug that cause spi transfer timed out in DMA duplex mode
      spi/rockchip: spi controller must be disabled in tx callback too

Adel Gadllah (2):
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 009b
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 016f

Al Viro (3):
      overlayfs: barriers for opening upper-layer directory
      isofs_cmp(): we'll never see a dentry for . or ..
      isofs: don't bother with ->d_op for normal case

Alan Cox (1):
      usb: dwc3: pci: Add PCI ID for Intel Braswell

Alex Deucher (3):
      drm/radeon/dpm: disable ulv support on SI
      drm/radeon: dpm fixes for asrock systems
      drm/radeon: remove invalid pci id

Alex Gartrell (1):
      ipvs: Avoid null-pointer deref in debug code

Alexander Graf (1):
      Documentation: Restrict TSC test code to x86

Alexandre Belloni (1):
      drivers: video: fbdev: atmel_lcdfb.c: remove unnecessary header

Alexandre Courbot (1):
      Input: soc_button_array - update calls to gpiod_get*()

Alexei Starovoitov (2):
      bpf: fix bug in eBPF verifier
      bpf: split eBPF out of NET

Andrew Lunn (2):
      net: dsa: Error out on tagging protocol mismatches
      dsa: mv88e6171: Fix tagging protocol/Kconfig

Andriy Skulysh (1):
      sh: fix sh770x SCIF memory regions

Andrzej Hajda (6):
      drm/exynos: init vblank with real number of crtcs
      drm/exynos: remove explicit encoder/connector de-initialization
      drm/exynos: propagate plane initialization errors
      drm/exynos: init kms poll at the end of initialization
      drm/exynos: enable vblank after DPMS on
      drm/exynos: correct connector->dpms field before resuming

Andy Lutomirski (3):
      x86, apic: Handle a bad TSC more gracefully
      perf: Fix typos in sample code in the perf_event.h header
      x86_64, entry: Fix out of bounds read on sysenter

Andy Shevchenko (1):
      stmmac: pci: set default of the filter bins

Aneesh Kumar K.V (2):
      powerpc/mm: Fix build error with hugetlfs disabled
      powerpc/mm: Remove redundant #if case

Anish Bhatt (4):
      cxgb4 : Improve handling of DCB negotiation or loss thereof
      cxgb4 : Handle dcb enable correctly
      libcxgbi : support ipv6 address host_param
      cxgb4 : Fix missing initialization of win0_lock

Arturo Borrero (1):
      netfilter: nft_compat: fix wrong target lookup in nft_target_select_ops()

Ben Hutchings (5):
      mtd: spi-nor: make spi_nor_scan() take a chip type name, not spi_device_id
      mtd: m25p80,spi-nor: Fix module aliases for m25p80
      drivers/net: Disable UFO through virtio
      drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets
      drivers/net: macvtap and tun depend on INET

Brian Silverman (1):
      futex: Fix a race condition between REQUEUE_PI and task death

Charles Manning (1):
      usb: dwc2: Bits in bitfield should add up to 32

Chen Gang (1):
      drivers/staging/comedi/Kconfig: Let COMEDI_II_PCI20KC depend on HAS_IOMEM

Chen Hanxiao (1):
      sched: Update comments for CLONE_NEWNS

Chris Zhong (1):
      regulator: rk808: Fix min_uV for DCDC1 & DCDC2

Christian Vogel (1):
      ALSA: bebob: Uninitialized id returned by saffirepro_both_clk_src_get

Christoph Hellwig (2):
      Revert "block: all blk-mq requests are tagged"
      scsi: set REQ_QUEUE for the blk-mq case

Cyril Brulebois (1):
      wireless: rt2x00: add new rt2800usb device

Dan Carpenter (9):
      [media] hackrf: harmless off by one in debug code
      netfilter: ipset: off by one in ip_set_nfnl_get_byindex()
      [media] em28xx-input: NULL dereference on error
      [media] xc5000: use after free in release()
      [media] usbvision-video: two use after frees
      i40e: _MASK vs _SHIFT typo in i40e_handle_mdd_event()
      Documentation/SubmittingPatches: Reported-by tags and permission
      drm/radeon: remove some buggy dead code
      ath9k: fix some debugfs output

Dan Streetman (1):
      MAINTAINERS: nx-842 driver maintainer change

Dan Williams (1):
      USB: option: add Haier CE81B CDMA modem

Daniel Glöckner (1):
      ASoC: s6000: remove driver

Daniel Mack (1):
      ASoC: fsl: use strncpy() to prevent copying of over-long names

Daniel Thompson (1):
      staging: android: logger: Fix log corruption regression

Daniele Palmas (1):
      usb: option: add support for Telit LE910

Darrick J. Wong (3):
      ext4: enable journal checksum when metadata checksum feature enabled
      ext4: disallow changing journal_csum option during remount
      ext4: remove extent status procfs files if journal load fails

Dave Jones (1):
      x86: Don't enable F00F workaround on Intel Quark processors

David Cohen (1):
      usb: ffs: fix regression when quirk_ep_out_aligned_size flag is set

David Jeffery (1):
      Return short read or 0 at end of a raw device, not EIO

David Rientjes (1):
      mm, thp: fix collapsing of hugepages on madvise

David S. Miller (1):
      sparc: Hook up bpf system call.

David Sterba (1):
      btrfs: use macro accessors in superblock validation checks

David Vrabel (3):
      xen-netback: make feature-rx-notify mandatory
      xen-netback: fix unlimited guest Rx internal queue and carrier flapping
      xen-netback: reintroduce guest Rx stall detection

Davidlohr Bueso (1):
      futex: Mention key referencing differences between shared and
private futexes

Dexuan Cui (1):
      x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE

Dmitry Eremin-Solenikov (2):
      Input: wm97xx - adapt parameters to tosa touchscreen.
      mtd: cfi_cmdset_0001.c: fix resume for LH28F640BF chips

Dmitry Kasatkin (2):
      ima: check xattr value length and type in the ima_inode_setxattr()
      evm: check xattr value length and type in evm_inode_setxattr()

Dmitry Monakhov (1):
      ext4: prevent bugon on race between write/fcntl

Dmitry Torokhov (6):
      Input: opencores-kbd - fix error handling
      Input: ims-pcu - fix dead code in ims_pcu_ofn_reg_addr_store()
      Input: vsxxxaa - fix code dropping bytes from queue
      Input: psmouse - remove unneeded check in psmouse_reconnect()
      Input: max77693-haptic - fix potential overflow
      Revert "Input: i8042 - disable active multiplexing by default"

Don Brace (1):
      MAINTAINERS: change hpsa and cciss maintainer

Dwight Engen (1):
      sunvdc: don't call VD_OP_GET_VTOC

Eli Cohen (2):
      net/mlx5_core: Call synchronize_irq() before freeing EQ buffer
      net/mlx4_core: Call synchronize_irq() before freeing EQ buffer

Emil Tantilov (1):
      ixgbe: fix race when setting advertised speed

Emmanuel Grumbach (6):
      iwlwifi: configure the LTR
      iwlwifi: mvm: BT Coex - update the MPLUT Boost register value
      iwlwifi: mvm: BT coex - fix BT prio for probe requests
      iwlwifi: dvm: drop non VO frames when flushing
      Revert "iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate"
      iwlwifi: pcie: fix polling in various places

Eric Dumazet (4):
      tcp: md5: do not use alloc_percpu()
      macvlan: fix a race on port dismantle and possible skb leaks
      net: napi_reuse_skb() should check pfmemalloc
      net: skb_fclone_busy() needs to detect orphaned skb

Eric Paris (1):
      i386/audit: stop scribbling on the stack frame

Eric Rannaud (1):
      fs: allow open(dir, O_TMPFILE|..., 0) with mode 0

Fabian Frederick (2):
      net: rfkill: kernel-doc warning fixes
      [media] tw68: remove deprecated IRQF_DISABLED

Fabio Estevam (4):
      iio: adc: mxs-lradc: Disable the clock on probe failure
      ASoC: sgtl500: Document the required supplies
      ARM: 8182/1: l2c: Make l2x0_cache_size_of_parse() return 'int'
      ARM: 8183/1: l2c: Improve l2c310_of_parse() error message

Fancy Fang (1):
      [media] videobuf-dma-contig: set vm_pgoff to be zero to pass the
sanity check in vm_iomap_memory()

Felipe Balbi (22):
      usb: dwc3: trace: don't dereference pointers
      usb: dwc3: ep0: hold our lock in dwc3_gadget_ep0_set_halt
      usb: dwc3: gadget: move isoc endpoint check to unlocked set_halt
      usb: dwc3: gadget: hold the lock through set_wedge()'s life
      usb: dwc3: gadget: fix set_halt() bug with pending transfers
      usb: gadget: function: uvc: conditionally dequeue
      usb: gadget: function: uvc: make sure to balance ep enable/disable
      usb: gadget: function: uvc: return correct alt-setting
      usb: gadget: function: acm: make f_acm pass USB20CV Chapter9
      usb: gadget: function: uvc: manage our video control endpoint
      usb: gadget: function: uvc: disable endpoints on ->disable()
      usb: gadget: function: uac2: add wMaxPacketSize to ep desc
      usb: gadget: function: uac2: prevent double ep disable
      usb: gadget: function: uac2: add a release method
      usb: gadget: function: f_obex: fix Interface Descriptor Test
      usb: dwc3: ep0: return early on NULL requests
      OMAPFB: add missing MODULE_ALIAS()
      OMAPFB: remove __exit annotation
      usb: dwc3: ep0: fix Data Phase for transfer sizes aligned to
wMaxPacketSize
      usb: gadget: composite: enable BESL support
      usb: gadget: loopback: don't queue requests to bogus endpoints
      usb: gadget: udc: core: fix kernel oops with soft-connect

Felix Fietkau (2):
      ath: use CTL region from cfg80211 if unset in EEPROM
      ath9k_common: always update value in ath9k_cmn_update_txpow

Filipe Manana (2):
      Btrfs: fix invalid leaf slot access in btrfs_lookup_extent()
      Btrfs: fix race that makes btrfs_lookup_extent_info miss skinny
extent items

Florian Fainelli (2):
      net: systemport: enable RX interrupts after NAPI
      net: systemport: reset UniMAC coming out of a suspend cycle

Florian Westphal (5):
      net: gso: use feature flag argument in all protocol gso handlers
      net: make skb_gso_segment error handling more robust
      net: core: handle encapsulation offloads when computing segment lengths
      netfilter: nf_log: account for size of NLMSG_DONE attribute
      netfilter: nfnetlink_log: fix maximum packet length logged to userspace

Francesco Ruggeri (1):
      e1000: unset IFF_UNICAST_FLT on WMware 82545EM

Frans Klaver (2):
      usb: serial: ftdi_sio: add Awinda Station and Dongle products
      mtd: omap: fix mtd devices not showing up

Geert Uytterhoeven (3):
      usb: gadget: udc: USB_GADGET_XILINX should depend on HAS_DMA
      drivers: net: xgene: Rewrite buggy loop in xgene_enet_ecc_init()
      cpufreq: cpufreq-dt: Restore default cpumask_setall(policy->cpus)

Govindarajulu Varadarajan (2):
      enic: fix possible deadlock in enic_stop/ enic_rfs_flw_tbl_free
      enic: Do not call napi_disable when preemption is disabled.

Greg Kroah-Hartman (1):
      PCI: Rename sysfs 'enabled' file back to 'enable'

Greg Ungerer (1):
      spi: orion: fix potential NULL pointer de-reference

Guenter Roeck (2):
      regulator: Include err.h from consumer.h to fix build failure
      net: ethtool: Return -EOPNOTSUPP if user space tries to read
EEPROM with lengh 0

Haim Dreyfuss (1):
      iwlwifi: mvm: Add tx power condition to bss_info_changed_ap_ibss

Haiyang Zhang (1):
      hyperv: Fix the total_data_buflen in send path

Hans Verkuil (5):
      [media] vivid: fix Kconfig FB dependency
      [media] em28xx: fix uninitialized variable warning
      [media] vivid: fix buffer overrun
      [media] wl128x: fix fmdbg compiler warning
      [media] tw68: remove bogus I2C_ALGOBIT dependency

Hans de Goede (1):
      Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544

Hariprasad Shenai (1):
      cxgb4vf: Replace repetitive pci device ID's with right ones

Hauke Mehrtens (1):
      bcma: fix build when CONFIG_OF_ADDRESS is not set

Herbert Xu (1):
      bridge: Do not compile options in br_parse_ip_options

Houcheng Lin (1):
      netfilter: nf_log: release skbuff on nlmsg put failure

Ian Abbott (4):
      staging: comedi: (regression) channel list must be set for
COMEDI_CMD ioctl
      staging: comedi: widen subdevice number argument in ioctl handlers
      staging: comedi: Kconfig: fix config COMEDI_ADDI_APCI_3120 dependants
      staging: comedi: fix memory leak / bad pointer freeing for chanlist

Ian Morgan (1):
      ax88179_178a: fix bonding failure

Ian Munsie (4):
      cxl: Disable secondary hash in segment table
      cxl: Refactor cxl_load_segment() and find_free_sste()
      powerpc/mm: Use appropriate ESID mask in copro_calculate_slb()
      cxl: Fix PSL error due to duplicate segment table entries

Imre Deak (2):
      PM / Sleep: fix async suspend_late/freeze_late error handling
      PM / Sleep: fix recovery during resuming from hibernation

Ingo Molnar (2):
      x86/smpboot: Move data structure to its primary usage scope
      perf/x86/intel: Revert incomplete and undocumented Broadwell
client support

Inki Dae (1):
      drm/exynos: vidi: fix build warning

J. Bruce Fields (2):
      nfsd4: fix response size estimation for OP_SEQUENCE
      nfsd4: fix crash on unknown operation number

Jacek Anaszewski (1):
      [media] s5p-jpeg: Avoid -Wuninitialized warning in s5p_jpeg_parse_hdr

Jack Pham (1):
      usb: dwc3: gadget: Properly initialize LINK TRB

Jan Kara (10):
      ext3: Don't check quota format when there are no quota files
      quota: Properly return errors from dquot_writeback_dquots()
      null_blk: Cleanup error recovery in null_add_dev()
      scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
      lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()
      ext4: fix overflow when updating superblock backups after resize
      ext4: fix oops when loading block bitmap failed
      ext4: bail out from make_indexed_dir() on first error
      ext4: bail early when clearing inode journal flag fails
      ext4: make ext4_ext_convert_to_initialized() return proper
number of blocks

Jan Kiszka (1):
      KVM: nVMX: Disable preemption while reading from shadow VMCS

Jani Nikula (1):
      drm/i915/dp: only use training pattern 3 on platforms that support it

Jason Baron (4):
      i3200_edac: Report CE events properly
      i82860_edac: Report CE events properly
      cpc925_edac: Report UE events properly
      e7xxx_edac: Report CE events properly

Jason Gerecke (1):
      HID: input: Fix TransducerSerialNumber implementation

Javier Martinez Canillas (1):
      Documentation: dt-bindings: Explain order in patch series

Jeff Mahoney (1):
      vdso: don't require 64-bit math in standalone test

Jeremy Kerr (1):
      powernv: Use _GLOBAL_TOC for opal wrappers

Jerry Hoemann (1):
      fsnotify: next_i is freed during fsnotify_unmount_inodes.

Jes Sorensen (1):
      staging: rtl8723au: Fix alignment of mac_addr for ether_addr_copy() usage

Jiang Liu (3):
      x86: ACPI: Do not translate GSI number if IOAPIC is disabled
      x86, intel-mid: Create IRQs for APB timers and RTC timers
      ACPI, irq, x86: Return IRQ instead of GSI in mp_register_gsi()

Jim Davis (1):
      Documentation: remove outdated references to the linux-next wiki

Jiri Olsa (7):
      perf tools: Fix report -F abort for data without branch info
      perf tools: Fix report -F in_tx for data without branch info
      perf tools: Fix report -F mispredict for data without branch info
      perf tools: Fix report -F symbol_to for data without branch info
      perf tools: Fix report -F symbol_from for data without branch info
      perf tools: Fix report -F dso_to for data without branch info
      perf tools: Fix report -F dso_from for data without branch info

Joe Perches (1):
      ALSA: ad1889: Fix probable mask then right shift defects

Johannes Weiner (3):
      mm: page-writeback: inline account_page_dirtied() into single caller
      mm: memcontrol: fix missed end-writeback page accounting
      mm: rmap: split out page_remove_file_rmap()

Jon Cooper (1):
      sfc: remove incorrect EFX_BUG_ON_PARANOID check

Joonsoo Kim (1):
      mm/compaction.c: avoid premature range skip in isolate_migratepages_range

Josef Bacik (1):
      Btrfs: properly clean up btrfs_end_io_wq_cache

Junwei Zhang (1):
      ixgbe: need not repeat init skb with NULL

Juri Lelli (2):
      sched/deadline: Don't replenish from a !SCHED_DEADLINE entity
      sched/deadline: Fix races between rt_mutex_setprio() and dl_task_timer()

Kailang Yang (3):
      ALSA: hda/realtek - Update restore default value for ALC282
      ALSA: hda/realtek - Update restore default value for ALC283
      ALSA: hda/realtek - New SSID for Headset quirk

Kamal Mostafa (1):
      Revert duplicate "PCI: pciehp: Prevent NULL dereference during probe"

Kan Liang (1):
      perf diff: Add missing hists__init() call at tool start

Karl Beldan (3):
      mac80211: fix typo in starting baserate for rts_cts_rate_idx
      mac80211: minstrels: fix buffer overflow in HT debugfs rc_stats
      net: tso: fix unaligned access to crafted TCP header in helper API

Karsten Wiese (3):
      rtl8192cu: Fix for rtlwifi's bluetooth coexist functionality
      rtl8192cu: Call ieee80211_register_hw from rtl_usb_probe
      rtl8192cu: Prevent Ooops under rtl92c_set_fw_rsvdpagepkt

Kees Cook (3):
      [media] af9035: make sure loading modules is const
      [media] anysee: make sure loading modules is const
      rtlwifi: prevent format string usage from leaking

Kirill Smelkov (1):
      Docs: Document that the sticky bit is understood by hugetlbfs

Kirill Tkhai (4):
      sched: Fix race between task_group and sched_task_group
      sched/numa: Fix unsafe get_task_struct() in task_numa_assign()
      sched/fair: Fix division by zero sysctl_numa_balancing_scan_size
      sched/dl: Fix preemption checks

Konstantin Khlebnikov (1):
      mm/balloon_compaction: fix deflation when compaction is disabled

LEROY Christophe (1):
      net: fs_enet: set back promiscuity mode after restart

Larry Finger (8):
      rtlwifi: rtl8192ee: Prevent log spamming for switch statements
      rtlwifi: rtl8821ae: Fix possible array overrun
      rtlwifi: Add check for get_btc_status callback
      rtlwifi: rtl8192ce: rtl8192de: rtl8192se: Fix handling for
missing get_btc_status
      rtlwifi: rtl8192se: Fix duplicate calls to ieee80211_register_hw()
      rtlwifi: rtl8192se: Add missing section to read descriptor setting
      rtlwifi: rtl8192ce: Add missing section to read descriptor setting
      rtlwifi: rtl8192se: Fix firmware loading

Lars-Peter Clausen (3):
      staging:iio:ad5933: Fix NULL pointer deref when enabling buffer
      staging:iio:ad5933: Drop "raw" from channel names
      ASoC: adau1761: Fix input PGA volume

Laura Abbott (1):
      ARM: 8181/1: Drop extra return statement

Laurent Pinchart (1):
      [media] v4l: uvcvideo: Fix buffer completion size check

Lendacky, Thomas (2):
      amd-xgbe: Properly handle feature changes via ethtool
      amd-xgbe: Fix napi Rx budget accounting

Lennart Sorensen (2):
      drivers: net: cpsw: Fix broken loop condition in switch mode
      drivers: net: cpsw: Support ALLMULTI and fix IFF_PROMISC in switch mode

Li RongQing (1):
      xfrm6: fix a potential use after free in xfrm6_policy.c

Liad Kaufman (2):
      mac80211: fix warning on htmldocs for last_tdls_pkt_time
      iwlwifi: 8000: fix string given to MODULE_FIRMWARE

Liam Girdwood (1):
      ASoC: Intel: HSW/BDW only support S16 and S24 formats.

Linus Torvalds (2):
      irda: stop calling sk_prot->disconnect() on connection failure
      Linux 3.18-rc3

Linus Walleij (1):
      Input: stmpe-keypad - fix valid key line bitmask

Lubomir Rintel (2):
      [media] saa7146: Create a device name before it's used
      ipv6: notify userspace when we added or changed an ipv6 token

Lucas Stach (1):
      cpufreq: cpufreq-dt: disable unsupported OPPs

Luciano Coelho (2):
      mac80211: return the vif's chandef in ieee80211_cfg_get_channel()
      nl80211: sanity check the channel switch counter value

Lv Zheng (2):
      Revert "ACPI / EC: Add support to disallow QR_EC to be issued
before completing previous QR_EC"
      ACPI / EC: Fix regression due to conflicting firmware behavior
between Samsung and Acer.

Maarten ter Huurne (1):
      fbcon: Fix option parsing control flow in fb_console_setup

Maciej W. Rozycki (2):
      doc: kernel-parameters.txt: Add ide-generic.probe-mask
      x86/irq: Fix XT-PIC-XT-PIC in /proc/interrupts

Marc Yang (1):
      mwifiex: restart rxreorder timer correctly

Marc Zyngier (1):
      ARM/ARM64: arch-timer: fix arch_timer_probed logic

Marcelo Leitner (1):
      netfilter: nf_conntrack: allow server to become a client in TW handling

Marek Belisko (1):
      omap: dss: connector-analog-tv: Add missing module device table

Marek Szyprowski (4):
      usb: dwc2: gadget: fix gadget unregistration in udc_stop() function
      usb: dwc2: gadget: disable phy before turning off power regulators
      drivers: of: add return value to of_reserved_mem_device_init()
      drivers/rtc/rtc-s3c.c: fix initialization failure without rtc source clock

Mark Rustad (1):
      video/console: Resolve several shadow warnings

Martin K. Petersen (1):
      block: Fix merge logic when CONFIG_BLK_DEV_INTEGRITY is not defined

Martin Schwidefsky (1):
      kernel/kmod: fix use-after-free of the sub_info structure

Masami Hiramatsu (1):
      perf probe: Trivial typo fix for --demangle

Masanari Iida (2):
      Documentation: Add default kmemleak off case in kernel-parameters.txt
      Documentation: Add CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF case

Mathias Krause (1):
      posix-timers: Fix stack info leak in timer_create()

Matti Gottlieb (1):
      iwlwifi: mvm: ROC - bug fixes around time events and locking

Mauro Carvalho Chehab (1):
      Revert "[media] v4l2-dv-timings: fix a sparse warning"

Michael Ellerman (1):
      Revert "powerpc/powernv: Fix endian bug in LPC bus debugfs accessors"

Michal Simek (3):
      microblaze: Fix missing NR_CPUS in menuconfig
      microblaze: Fix IO space breakage after of_pci_range_to_resource() change
      microblaze: Wire up bpf syscall

Michel Dänzer (1):
      drm/radeon: Use drm_malloc_ab instead of kmalloc_array

Mika Westerberg (1):
      ACPI: Use ACPI companion to match only the first physical device

Miklos Szeredi (3):
      ovl: fix check for cursor
      overlayfs: fix lockdep misannotation
      ovl: initialize ->is_cursor

Mikulas Patocka (1):
      mm/slab_common: don't check for duplicate cache names

Ming Lei (1):
      blk-merge: recaculate segment if it isn't less than max segments

Mugunthan V N (1):
      drivers: net:cpsw: fix probe_dt when only slave 1 is pinned out

Nadav Amit (1):
      KVM: x86: Fix far-jump to non-canonical check

Namhyung Kim (1):
      perf callchain: Use global caching provided by libunwind

Nathaniel Ting (1):
      USB: serial: cp210x: add Silicon Labs 358x VID and PID

Nicolas Cavallari (1):
      ipv4: Do not cache routing failures due to disabled forwarding.

Nikolay Aleksandrov (2):
      inet: frags: fix a race between inet_evict_bucket and inet_frag_kill
      inet: frags: remove the WARN_ON from inet_evict_bucket

Nishanth Aravamudan (2):
      powerpc/numa: use cached value of update->cpu in update_cpu_topology
      powerpc/numa: ensure per-cpu NUMA mappings are correct on topology update

Oleg Nesterov (1):
      sched: stop the unbound recursion in preempt_schedule_context()

Olivier Blin (3):
      usbnet: add a callback for set_rx_mode
      cdc-ether: extract usbnet_cdc_update_filter function
      cdc-ether: handle promiscuous mode with a set_rx_mode callback

Olivier Gay (1):
      HID: add keyboard input assist hid usages

Olli Salonen (1):
      [media] cx23885: initialize config structs for T9580

Or Gerlitz (2):
      net/mlx4_en: Don't attempt to TX offload the outer UDP checksum for VXLAN
      mlx4: Avoid leaking steering rules on flow creation error flow

Pablo Neira Ayuso (12):
      netfilter: missing module license in the nf_reject_ipvX modules
      netfilter: nf_tables: restrict nat/masq expressions to nat chain type
      netfilter: nft_compat: fix hook validation for non-base chains
      netfilter: nft_compat: validate chain type in match/target
      netfilter: nft_nat: insufficient attribute validation
      netfilter: nft_nat: NFTA_NAT_REG_ADDR_MAX depends on NFTA_NAT_REG_ADDR_MIN
      netfilter: nft_nat: dump attributes if they are set
      netfilter: nf_tables_bridge: update hook_mask to allow {pre,post}routing
      netfilter: nf_reject_ipv4: split nf_send_reset() in smaller functions
      netfilter: nf_reject_ipv6: split nf_send_reset6() in smaller functions
      netfilter: nft_reject_bridge: don't use IP stack to reject traffic
      netfilter: nft_reject_bridge: restrict reject to prerouting and input

Paolo Bonzini (3):
      KVM: emulator: fix error code for __linearize
      KVM: emulator: fix execution close to the segment limit
      KVM: vmx: defer load of APIC access page address during reset

Paul E. McKenney (3):
      rcu: More on deadlock between CPU hotplug and expedited grace periods
      rcu: Make rcu_barrier() understand about missing rcuo kthreads
      rcu: Provide counterpart to rcu_dereference() for non-RCU situations

Pavel Machek (1):
      drivers/rtc/rtc-bq32k.c: fix register value

Pavitrakumar Managutte (2):
      usb: gadget: function: Remove redundant usb_free_all_descriptors
      usb: gadget: function: Fixed the return value on error path

Perry Hung (1):
      usb: serial: ftdi_sio: add "bricked" FTDI device PID

Peter Foley (1):
      Documentation: fix vdso_standalone_test_x86 on 32-bit

Peter Hurley (1):
      USB: kobil_sct: Remove unused transfer buffer allocs

Peter Zijlstra (2):
      perf: Fix and clean up initialization of pmu::event_idx
      perf/x86: Fix compile warnings for intel_uncore

Peter Zijlstra (Intel) (1):
      perf: Fix bogus kernel printk

Philipp Zabel (1):
      net: fec: ptp: fix NULL pointer dereference if ptp_clock is not set

Pranith Kumar (1):
      powerpc: Wire up sys_bpf() syscall

Pravin B Shelar (2):
      mpls: Fix mpls_gso handler.
      mpls: Allow mpls_gso to be built as module

Rabin Vincent (1):
      tracing/syscalls: Ignore numbers outside NR_syscalls' range

Rafał Miłecki (2):
      mtd: m25p80: get rid of spi_get_device_id
      bcma: add another PCI ID of device with BCM43228

Randy Dunlap (1):
      skbuff.h: fix kernel-doc warning for headers_end

Ray Jui (2):
      spi: spidev: Use separate TX and RX bounce buffers
      spi: pl022: Fix incorrect dma_unmap_sg

Richard Cochran (1):
      ptp: restore the makefile for building the test program.

Richard Weinberger (1):
      ocfs2: fix d_splice_alias() return code checking

Richard Zhu (1):
      PCI: imx6: Wait for clocks to stabilize after ref_en

Rickard Strandqvist (1):
      brcmfmac: dhd_sdio.c: Cleaning up missing null-terminate in
conjunction with strncpy

Riku Voipio (1):
      gcov: add ARM64 to GCOV_PROFILE_ALL

Rob Clark (1):
      drm/vmwgfx: fix lock breakage

Robert Baldyga (1):
      usb: gadget: f_fs: remove redundant ffs_data_get()

Robert Elliott (2):
      fs: merge I/O error prints into one line
      fs: clarify rate limit suppressed buffer I/O errors

Robin van der Gracht (1):
      iio: st_sensors: Fix buffer copy

Roger Quadros (1):
      Revert "usb: dwc3: dwc3-omap: Disable/Enable only wrapper
interrupts in prepare/complete"

Roman Gushchin (1):
      igb: don't reuse pages with pfmemalloc flag

Russell King (6):
      drm/armada: add IRQ support back
      drm/armada: fix page_flip refcounting leak
      drm/armada: convert to use vblank_on/off calls
      ARM: Blacklist GCC 4.8.0 to GCC 4.8.2 - PR58854
      ARM: fix some printk formats
      ARM: enable bpf syscall

Sabrina Dubroca (2):
      net: sched: initialize bstats syncp
      netfilter: nf_tables: check for NULL in nf_tables_newchain pcpu
stats allocation

Santosh Y (1):
      MAINTAINERS: ufs - remove self

Sasha Levin (1):
      fs, jbd: use a more generic hash function

Sathya Perla (1):
      net: fix saving TX flow hash in sock for outgoing connections

Sebastian Andrzej Siewior (2):
      usb: musb: dsps: start OTG timer on resume again
      usb: musb: musb_dsps: fix NULL pointer in suspend

Sinclair Yeh (1):
      drm/vmwgfx: Filter out modes those cannot be supported by the
current VRAM size.

Stanimir Varbanov (1):
      drivers/rtc/rtc-pm8xxx.c: rework to support pm8941 rtc

Steven Noonan (1):
      compiler/gcc4+: Remove inaccurate comment about 'asm goto' miscompiles

Steven Rostedt (Red Hat) (2):
      ftrace: Set ops->old_hash on modifying what an ops hooks to
      ftrace: Fix checking of trampoline ftrace_ops in finding trampoline

Sudip Mukherjee (2):
      usb: dwc2: gadget: sparse warning of context imbalance
      block: fix wrong error return in elevator_init()

Sujith Manoharan (1):
      ath9k: Enable HW queue control only for MCC

Sylwester Nawrocki (1):
      [media] Remove references to non-existent PLAT_S5P symbol

Takashi Iwai (3):
      DocBook: Reduce noise from make cleandocs
      ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat mode
      ALSA: hda - Add workaround for CMI8888 snoop behavior

Takashi Sakamoto (1):
      ALSA: bebob: fix wrong decoding of clock information for
Terratec PHASE 88 Rack FW

Tej Parkash (1):
      cnic: Update the rcu_access_pointer() usages

Theodore Ts'o (1):
      jbd2: use a better hash function for the revoke table

Thierry Reding (2):
      [media] s5p-jpeg: Only build suspend/resume for PM
      [media] s5p-fimc: Only build suspend/resume for PM

Thomas Gleixner (2):
      usb: musb: cppi41: restart hrtimer only if not yet done
      clockevents: Prevent shift out of bounds

Thomas Graf (1):
      netlink: Re-add locking to netlink_lookup() and seq walker

Thomas Hellstrom (1):
      drm/vmwgfx: Fix hash key computation

Thomas Petazzoni (1):
      ARM: 8180/1: mm: implement no-highmem fast path in kmap_atomic_pfn()

Thor Thayer (1):
      spi: dw: Initialize of_node to discover DT node children

Tobias Klauser (2):
      Input: altera_ps2 - write to correct register when disabling interrupts
      Input: altera_ps2 - use correct type for irq return value

Tom Herbert (1):
      gre: Use inner mac length when computing tunnel length

Tomi Valkeinen (9):
      OMAPDSS: set suppress_bind_attrs
      OMAPDSS: apply: wait pending updates on manager disable
      OMAPFB: fix overlay disable when freeing resources.
      OMAPFB: fix releasing overlays
      OMAPDSS: HDMI: fix PLL GO bit handling
      OMAPDSS: HDMI: fix regsd write
      OMAPDSS: DISPC: fix mflag offset
      OMAPDSS: fix dispc register dump for preload & mflag
      OMAPDSS: DSI: Fix PLL_SELFEQDCO field width

Tony Battersby (2):
      lib/scatterlist: fix memory leak with scsi-mq
      lib/scatterlist: fix memory leak with scsi-mq

Tony Lindgren (1):
      net: smc91x: Fix gpios for device tree based booting

Torsten Fleischer (1):
      usb: chipidea: Fix oops when removing the ci_hdrc module

Ville Syrjälä (3):
      drm/i915: Do a dummy DPCD read before the actual read
      drm/i915: Ignore long hpds on eDP ports
      drm/i915: Fix GMBUSFREQ on vlv/chv

Vince Bridgers (1):
      net: phy: Add SGMII Configuration for Marvell 88E1145 Initialization

Vincent Palatin (1):
      [media] v4l: DocBook: fix media build error

WANG Chao (1):
      Documentation/ABI/testing/sysfs-ibft: fix a typo

WANG Cong (1):
      sch_pie: schedule the timer after all init succeed

Wang Nan (2):
      perf tools: Make CPUINFO_PROC an array to support different
kernel versions
      cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.

Weijie Yang (2):
      x86, cma: Reserve DMA contiguous area after initmem_init()
      zram: avoid NULL pointer access in concurrent situation

Wilfried Klaebe (1):
      radeon: clean up coding style differences in radeon_get_bios()

Will Deacon (1):
      zap_pte_range: update addr when forcing flush after TLB batching faiure

Yasuaki Ishimatsu (2):
      sched/fair: Care divide error in update_task_scan_period()
      memory-hotplug: clear pgdat which is allocated by bootmem in
try_offline_node()

Ying Xue (2):
      tipc: fix a potential deadlock
      tipc: fix lockdep warning when intra-node messages are delivered

Yu Zhao (1):
      mm: free compound page with correct order

hayeswang (4):
      r8152: clear SELECTIVE_SUSPEND when autoresuming
      r8152: reset tp->speed before autoresuming in open function
      r8152: check WORK_ENABLE in suspend function
      r8152: stop submitting intr for -EPROTO

jens stein (1):
      drm/i915: Ignore VBT backlight check on Macbook 2, 1
