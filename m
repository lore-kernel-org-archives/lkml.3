Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3E0ADn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 20:03:43 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:59011 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab3E0ADj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 20:03:39 -0400
MIME-Version: 1.0
Date: Sun, 26 May 2013 17:03:38 -0700
X-Google-Sender-Auth: WQHVO1dHOWC2sPFTHqFMe26JuY0
Message-ID: <CA+55aFzs5QQtRta=1goyxm9zWE6Ln5VcsU+VQ=srDa1upFeHyw@mail.gmail.com>
Subject: Linux 3.10-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another rc.

A *big* one.

I'm not thrilled about it, and -rc3 is much bigger than -rc2 was,
although there isn't anything particularly scary that stands out. Just
a lot of small details. A number of people apparently missed rc2, and
then made rc3.

Oh, well.

I can pretty much guarantee that -rc4 is going to be smaller, because
(a) I'm going to be grumpy if people try to push as much to rc4 as
happened to rc3, and (b) I'm going to be traveling for most of next
week (and part of the week after). I'll have internet, but I really
really hope and expect that things should be calmer coming up. Right?
RIGHT GUYS?

Anyway, it's mostly fairly small changes, and mostly to drivers.
Network, staging, usb, video, drm.. There's some arch updates too:
arm, mips and powerpc. And random stuff all over.

Go at it,

                    Linus

---

Alan Stern (6):
      USB: xHCI: override bogus bulk wMaxPacketSize values
      USB: fix Kconfig logic for USB_UHCI_HCD
      USB: UHCI: fix for suspend of virtual HP controller
      USB: fix latency in uhci-hcd and ohci-hcd
      USB: OHCI: fix logic for scheduling isochronous URBs
      USB: remove remaining instances of USB_SUSPEND

Albert Pool (1):
      rtlwifi: rtl8192cu: Add new USB ID

Alex Deucher (10):
      drm/radeon/dce2: use 10khz units for audio dto calculation
      drm/radeon: add chip family for Hainan
      drm/radeon: fill in GPU init for Hainan (v2)
      drm/radeon: don't touch DCE or VGA regs on Hainan (v3)
      drm/radeon: fill in ucode loading support for Hainan
      drm/radeon: radeon-asic updates for Hainan
      drm/radeon: track which asics have UVD
      drm/radeon: sun/hainan chips do not have UVD (v2)
      drm/radeon: add golden register settings for Hainan (v2)
      drm/radeon: add Hainan pci ids

Alexander Bondar (1):
      iwlwifi: mvm: Prevent setting assoc flag in MAC_CONTEXT_CMD

Alexander Shiyan (1):
      s390: remove non existent reference to GENERIC_KERNEL_THREAD

Alexander Sverdlin (1):
      i2c: suppress lockdep warning on delete_device

Alexandre Bounine (4):
      rapidio: make enumeration/discovery configurable
      rapidio: add enumeration/discovery start from user space
      rapidio: documentation update for enumeration changes
      rapidio/tsi721: fix bug in MSI interrupt handling

Alexandre Courbot (1):
      ARM: tegra: defconfig fixes

Andrew Lunn (2):
      ARM: Orion: Remove redundant init_dma_coherent_pool_size()
      mv643xx_eth: fix NAPI weight being > 64

Andrew Morton (1):
      revert "selftest: add simple test for soft-dirty bit"

Andy Adamson (1):
      NFSv4.1 Fix a pNFS session draining deadlock

Andy Shevchenko (1):
      dma: acpi-dma: parse CSRT to extract additional resources

Aneesh Kumar K.V (1):
      mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

Ard Biesheuvel (1):
      ARM: 7723/1: crypto: sha1-armv4-large.S: fix SP handling

Arend van Spriel (1):
      brcmfmac: announce P2P_DEVICE support in wiphy structure

Arnd Bergmann (4):
      staging/drm: imx: add missing dependencies
      staging/solo6x10: depend on CONFIG_FONTS
      mfd: ab8500: Debugfs code depends on gpadc
      USB: EHCI: remove bogus #error

Aron Xu (1):
      MIPS: N64: Wire getdents64(2)

Axel Lin (5):
      wm831x_backup: Fix wrong kfree call for devdata->backup.name
      pm2301_charger: Fix module alias prefix
      gpio: mcp23s08: Fix build error when CONFIG_SPI_MASTER=y && CONFIG_I2C=m
      gpio: Don't override the error code in probe error handling
      iio: dac: Fix build error when CONFIG_SPI_MASTER=y && CONFIG_I2C=m

Bastian Triller (1):
      ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist

Ben Hutchings (7):
      sfc: Delete EFX_PAGE_IP_ALIGN, equivalent to NET_IP_ALIGN
      sfc: Reduce RX scatter buffer size, and reduce alignment if appropriate
      perf: net_dropmonitor: Fix trace parameter order
      perf: net_dropmonitor: Fix symbol-relative addresses
      perf: net_dropmonitor: Do not assume ordering of dictionaries
      perf: net_dropmonitor: Use bisection in symbol lookup
      perf: net_dropmonitor: Remove progress indicator

Ben Skeggs (9):
      drm/nouveau/bios: fix thinko in ZM_MASK_ADD opcode
      drm/nvc0/ce: disable ce1 on a number of chipsets
      drm/nvc0/ltcg: fix handling of disabled partitions
      drm/nve0/ltcg: poke the partition count into yet another register
      drm/nve0/fifo: prevent races between clients updating playlists
      drm/nvc0/fifo: prevent races between clients updating playlists
      drm/nvc0/fifo: prevent CHAN_TABLE_ERROR:CHANNEL_PENDING on fifo fini
      drm/nv50/fifo: prevent races between clients updating playlists
      drm/nouveau: ensure channels are stopped before saving fences for suspend

Benjamin Herrenschmidt (5):
      powerpc: Fix TLB cleanup at boot on POWER8
      powerpc/pci: Fix bogus message at boot about empty memory resources
      powerpc/powernv: Fix condition for when to invalidate the TCE cache
      powerpc: Make radeon 32-bit MSI quirk work on powernv
      powerpc/powernv: Build a zImage.epapr

Benjamin LaHaise (1):
      aio: fix kioctx not being freed after cancellation at exit time

Bjorn Helgaas (1):
      Revert "x86/pci/mrst: Use configuration mechanism 1 for 00:00.0,
00:02.0, 00:03.0"

Bob Peterson (2):
      GFS2: two minor quota fixups
      GFS2: Use single-block reservations for directories

Boris BREZILLON (1):
      ARM: at91/dt: fix macb pinctrl_macb_rmii_mii_alt definition

Borislav Petkov (1):
      amd64_edac: Fix bogus sysfs file permissions

Brian Behlendorf (1):
      drivers/block/brd.c: fix brd_lookup_page() race

Brian King (1):
      powerpc/pseries: Make 32-bit MSI quirk work on systems lacking
firmware support

Chen Gang (1):
      net: irda: using kzalloc() instead of kmalloc() to avoid strncpy() issue.

Christian Borntraeger (4):
      s390: disable pfmf for clear page instruction
      s390: fix gmap_ipte_notifier vs. software dirty pages
      s390/xpram: mark xpram as non-rotational
      s390/pgtable: fix ipte notify bit

Christian Gmeiner (1):
      drivers/leds/leds-ot200.c: fix error caused by shifted mask

Christian Ruppert (1):
      ARC: [TB10x] Remove redundant abilis,simple-pinctrl mechanism

Chuck Lever (1):
      NFS: Fix SETCLIENTID fallback if GSS is not available

Cliff Wickman (1):
      mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas

Dan Carpenter (3):
      ipg: fix an unsigned widening cast of '~' truncation issue
      USB: cxacru: potential underflow in cxacru_cm_get_array()
      isdn/kcapi: fix a small underflow

Dan Magenheimer (1):
      staging: ramster: add how-to document

Dan Williams (1):
      USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card

Darrick J. Wong (1):
      ttyprintk: Fix NULL pointer deref by setting tty_port ops after
initializing port

Dave Airlie (1):
      drm/nouveau: fix build with nv50->nvc0

Dave Chinner (7):
      xfs: fix sub-page blocksize data integrity writes
      xfs: fix rounding in xfs_free_file_space
      xfs: Don't reference the EFI after it is freed
      xfs: fix missing KM_NOFS tags to keep lockdep happy
      xfs: xfs_da3_node_read_verify() doesn't handle XFS_ATTR3_LEAF_MAGIC
      xfs: xfs_attr_shortform_allfit() does not handle attr3 format.
      xfs: remote attribute lookups require the value length

David Cohen (1):
      gpio-langwell: fix irq conflicts when DT is not used

David Rientjes (2):
      mfd: tps65912: Select MFD_CORE
      usb, chipidea: fix link error when USB_EHCI_HCD is a module

David S. Miller (1):
      net: Revert unused variable changes.

Denis CIOCCA (1):
      iio:common:st: added disable function after read info raw data

Denis Efremov (2):
      staging: nvec: remove inline marking of EXPORT_SYMBOL functions
      iwlegacy: remove inline marking of EXPORT_SYMBOL functions

Dirk Behme (1):
      ARM i.MX6: correct MLB clock configuration

Dirk Brandewie (1):
      cpufreq / intel_pstate: Add additional supported CPU ID

Emilio López (4):
      ARM: ux500: select REGULATOR
      net: ethernet: apple: drop unused variable
      net: ethernet: korina: drop unused variable
      net: ethernet: sun: drop unused variable

Emmanuel Grumbach (2):
      iwlwifi: mvm: tell firmware to let multicast frames in
      iwlwifi: mvm: fix aggregation drain flow

Eric Dumazet (7):
      tcp: fix tcp_md5_hash_skb_data()
      net/802/mrp: fix lockdep splat
      tcp: gso: do not generate out of order packets
      bonding: allow TSO being set on bonding master
      ipv6: fix possible crashes in ip6_cork_release()
      ip_gre: fix a possible crash in ipgre_err()
      tcp: xps: fix reordering issues

Ezequiel Garcia (3):
      ARM: mvebu: Add a ranges entry to translate devbus childs
      ARM: mvebu: Fix ranges entry on XP GP board
      serial: 8250_dw: Add valid clk pointer check

Fabio Baltieri (5):
      mfd: abx500-core: Fix sparse warning
      mfd: ab8500-sysctrl: Fix sparse warning
      mfd: ab8500-sysctrl: Set sysctrl_dev during probe
      mfd: ab8500-sysctrl: Always enable pm_power_off handler
      mfd: ab8500-sysctrl: Let sysctrl driver work without pdata

Fabio Estevam (3):
      fec: Fix inconsistent lock state
      fec: Invert the order of function calls in fec_restart()
      staging: imx-drm: imx-tve: Check the return value of 'regulator_enable()'

Felix Fietkau (4):
      mac80211: fix spurious RCU warning and update documentation
      ath9k: fix aggregation stop/flush handling
      ath9k: fix rate handling/reporting
      ath9k: fix draining aggregation tid buffers

Florian Fainelli (1):
      broadcom: add include guards to include/linux/brcmphy.h

Geert Uytterhoeven (7):
      mfd: si476x: Do not use binary constants
      mfd: cros_ec_spi: Use %z to format pointer differences
      mfd: si476x: Use get_unaligned_be16() for unaligned be16 loads
      staging: zcache: Fix incorrect module_param_array types
      net/wireless: ATH9K should depend on HAS_DMA
      uio: UIO_DMEM_GENIRQ should depend on HAS_DMA
      fbdev: FB_GOLDFISH should depend on HAS_DMA

Gernot Vormayr (1):
      drivers/block/xsysace.c: fix id with missing port-number

Gomella, Andrew (NIH/NHLBI) [F] (1):
      USB: ftdi_sio: Add support for Newport CONEX motor drivers

Greg Kroah-Hartman (1):
      driver core: export subsys_virtual_register

Gregory CLEMENT (3):
      ARM: mvebu: select ARCH_REQUIRE_GPIOLIB for mvebu platform
      ARM: plat-orion: Fix num_resources and id for ge10 and ge11
      ARM: dts: mvebu: Fix wrong the address reg value for the L2-cache node

H Hartley Sweeten (1):
      staging: comedi: ni_labpc: fix build when VIRT_TO_BUS is not defined

Haiyang Zhang (1):
      MAINTAINERS: update Hyper-V file list

Hans Schillstrom (1):
      netfilter: log: netns NULL ptr bug when calling from conntrack

Hans-Christian Egtvedt (2):
      avr32: move NODES_SHIFT into Kconfig and delete numnodes.h
      avr32: fix relocation check for signed 18-bit offset

Hans-Christoph Schemmel (1):
      qmi_wwan: Added support for Cinterion's PLxx WWAN Interface

Heikki Krogerus (1):
      serial: 8250_dw: add ACPI ID for Intel BayTrail

Heiko Abraham (1):
      Input: egalax_ts - ABS_MT_POSITION_Y not reported well

Heiko Carstens (2):
      s390/disassembler: prevent endless loop in print_fn_code()
      s390/ftrace: fix mcount adjustment

Helge Deller (6):
      MPILIB: disable usage of floating point registers on parisc
      parisc: add rp5470 entry to machine database
      parisc: use PAGE_SHIFT instead of hardcoded value 12 in pacache.S
      parisc: add additional parisc git tree to MAINTAINERS file
      parisc: show number of FPE and unaligned access handler calls in
/proc/interrupts
      parisc: fix irq stack on UP and SMP

Hema Prathaban (1):
      staging: vt6656: use free_netdev instead of kfree

Ian Abbott (4):
      staging: comedi: allow buffer resize if previous resize failed
      staging: comedi: work without HAS_DMA
      staging: comedi: ni_mio_common: only do counter commands for ni_pcimio
      staging: comedi: complain if dma buffer allocation not supported

Ilan Peer (2):
      nl80211: Add wdev identifier to some nl80211 notifications
      iwlwifi: mvm: Always use SCAN_TYPE_FORCED

Imre Deak (1):
      wait: fix false timeouts when using wait_event_timeout()

Jarod Wilson (1):
      drivers/char/random.c: fix priming of last_data

Jason Wang (1):
      virtio_net: enable napi for all possible queues during open

Jean Delvare (2):
      staging: Swap zram and zsmalloc in Kconfig
      i2c: i801: Document feature bits in modinfo

Jean-Christophe PLAGNIOL-VILLARD (3):
      ARM: at91/trivial: fix model name for SAM9X25-EK
      ARM: at91: rm9200 fix time support
      ARM: at91: at91sam9n12: move external irq declatation to DT

Jeff Layton (1):
      cifs: only set ops for inodes in I_NEW state

Jeff Mahoney (1):
      hfs: avoid crash in hfs_bnode_create

Jeff Moyer (1):
      aio: fix io_getevents documentation

Jiang Liu (1):
      avr32: fix building warnings caused by redefinitions of HZ

Jingoo Han (1):
      usb: gadget: s3c-hsotg: pass 'struct usb_request *' to
usb_gadget_unmap_request()

Jiri Kosina (1):
      random: fix accounting race condition with lockless irq
entropy_count update

Jiri Slaby (1):
      TTY: rocket, fix more no-PCI warnings

Johan Hovold (7):
      USB: serial: add wait_until_sent operation
      USB: serial: add generic wait_until_sent implementation
      USB: ftdi_sio: clean up get_modem_status
      USB: ftdi_sio: fix chars_in_buffer overhead
      USB: io_ti: fix chars_in_buffer overhead
      USB: ti_usb_3410_5052: fix chars_in_buffer overhead
      USB: serial: clean up chars_in_buffer

Johannes Berg (9):
      cfg80211: fix wiphy_register error path
      cfg80211: fix WoWLAN wakeup tracing
      mac80211: fix IEEE80211_SDATA_DISCONNECT_RESUME
      mac80211: fix HT beacon-based channel switch handling
      mac80211: use just spin_lock() in ieee80211_get_tkip_p2k()
      mac80211: fix AP-mode frame matching
      cfg80211: fix interface down/disconnect state handling
      mac80211: report deauth to cfg80211 for local state change
      cfg80211: fix sending WoWLAN TCP wakeup settings

Johannes Weiner (1):
      mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in uncharge

John David Anglin (1):
      parisc: make interrupt and interruption stack allocation reentrant

Jon Hunter (1):
      gpio/omap: ensure gpio context is initialised

Jonathan Corbet (1):
      dummy-irq: require the user to specify an IRQ number

Josef Ahmad (1):
      i2c: designware: fix RX FIFO overrun

Joseph Qi (2):
      ocfs2: unlock rw lock if inode lock failed
      ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in
ocfs2_fiemap()

Josh Wu (1):
      ARM: at91/sama5: fix incorrect PMC pcr div definition

K. Y. Srinivasan (1):
      Drivers: hv: Fix a bug in get_vp_index()

Kent Yoder (1):
      drivers/crypto/nx: Fixes for multiple races and issues

Kyle McMartin (1):
      score: remove redundant kcore_list entries

Larry Finger (1):
      rtlwifi: rtl8188ee: Fix warning when building on big-endian systems

Lars-Peter Clausen (2):
      tty: nwpserial: Pass correct pointer to free_irq()
      drivers/rtc/rtc-pl031.c: pass correct pointer to free_irq()

Lee Jones (9):
      ARM: ux500: Remove duplicated assignment of ab8500_platdata
      ARM: ux500: Fix incorrect DEBUG UART virtual addresses
      ARM: ux500: Provide device enumeration number suffix for SMSC911x
      staging: ste_rmi4: Suppress 'ignoring return value of
‘regulator_enable()' warning
      mfd: ab8500-gpadc: Suppress 'ignoring regulator_enable() return
value' warning
      mfd: ab8500-core: Use the correct driver name when enabling gpio/pinctrl
      mfd: db8500-prcmu: Supply the pdata_size attribute for db8500-thermal
      mfd: ab8500-core: Pass GPADC compatible string to MFD core
      serial: pl011: protect attribute read from NULL platform data struct

Leonid Yegoshin (1):
      mm compaction: fix of improper cache flush in migration code

Libo Chen (3):
      usb: ehci-s5p: fix memleak when fallback to pdata
      usb: isp1760-if: fix memleak when platform_get_resource fail
      usb: ohci: fix goto wrong tag in err case

Linus Lüssing (1):
      batman-adv: Fix rcu_barrier() miss due to double call_rcu() in TT code

Linus Torvalds (1):
      Linux 3.10-rc3

Linus Walleij (2):
      mfd: ab8500: Pass AB8500 IRQ to debugfs code by resource
      ARM: nomadik: fix IRQ assignment for SMC ethernet

Lucas Stach (2):
      clk: tegra: remove USB from clk init table
      clk: tegra: add ac97 controller clock

Ludovic Desroches (1):
      ARM: at91: dts: request only spi cs-gpios used on sama5d3x cpu module

Malcolm Priestley (1):
      staging: vt6656: [bug] Fix missing spin lock in iwctl_siwpower.

Manfred Spraul (1):
      ipc/sem.c: Fix missing wakeups in do_smart_update_queue()

Marc Dietrich (3):
      staging: nvec: add missing module aliases
      staging: nvec: implement unregistering of notifiers
      staging: nvec: cleanup childs on remove

Marek Vasut (1):
      staging: video: imx: Select VIDEOMODE_HELPERS for parallel display

Martin Hundebøll (1):
      batman-adv: Avoid double freeing of bat_counters

Martin Michlmayr (1):
      Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x

Martin Schwidefsky (1):
      s390/smp: fix cpu re-scan vs. cpu state

Masami Hiramatsu (2):
      tracing: Return -EBUSY when event_enable_func() fails to get module
      kprobes/mips: Fix to check double free of insn slot

Matthijs Kooijman (1):
      staging: dwc2: Fix dma-enabled platform devices using a default dma_mask

Matwey V. Kornilov (2):
      tty: mxser: fix usage of opmode_ioaddr
      tty: mxser: Fix build warning introduced by dfc7b837c7f9 (Re:
linux-next: build warning after merge of the tty.current tree)

Maxime Ripard (3):
      ARM: sunxi: Fix Mini X-plus device tree build
      ARM: sunxi: select ARCH_REQUIRE_GPIOLIB
      gpio: mxs: Use set and clear capabilities of the gpio controller

Michael Chan (1):
      tg3: Fix data corruption on 5725 with TSO

Michael Ellerman (1):
      powerpc: Context switch more PMU related SPRs

Michael Grzeschik (1):
      usb: otg: mxs-phy: add missing type to usb_phy

Michael S. Tsirkin (1):
      virtio_console: fix uapi header

Michał Mirosław (1):
      staging/iio/mxs-lradc: fix preenable for multiple buffers

Mika Westerberg (2):
      i2c: designware: always clear interrupts before enabling them
      i2c: designware: add Intel BayTrail ACPI ID

Nandita Dukkipati (1):
      tcp: bug fix in proportional rate reduction.

Naveen Krishna Chatradhi (1):
      iio: exynos_adc: fix wrong structure extration in suspend and resume

Nicolas Ferre (2):
      ARM: at91/trivial: typo in GEM compatible string
      net/macb: fix ISR clear-on-write behavior only for some SoC

Niels Ole Salscheider (2):
      drm/radeon: Remove superfluous variable
      drm/radeon: Fix VRAM size calculation for VRAM >= 4GB

Nithin Sujir (3):
      tg3: Skip powering down function 0 on certain serdes devices
      tg3: Ensure boot code has completed initialization before
accessing hardware
      tg3: Update version to 3.132

OGAWA Hirofumi (1):
      fat: fix possible overflow for fat_clusters

Oliver Neukum (1):
      USB: reset resume quirk needed by a hub

Pablo Neira Ayuso (3):
      netfilter: nf_{log,queue}: fix compilation without CONFIG_PROC_FS
      netfilter: update MAINTAINERS file
      netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond packet boundary

Paolo Bonzini (1):
      KVM: take over co-maintainership from Marcelo, fix MAINTAINERS entry

Paul Bolle (1):
      usb: phy: remove CONFIG_USB_OTG_UTILS once more

Paul Moore (1):
      netlabel: improve domain mapping validation

Paul Walmsley (1):
      ARM: OMAP2+: Add missing CONFIG_ARCH_MULTI_V6=y to omap2plus_defconfig

Paul Zimmerman (1):
      staging: dwc2: remove compile warning for USB_DWC2_TRACK_MISSED_SOFS

Peter Huewe (1):
      parisc/superio: Use module_pci_driver to register driver

Peter Hurley (1):
      tty/vt: Fix vc_deallocate() lock order

Peter Oberparleiter (1):
      s390/cio: add channel ID sysfs attribute

Petko Manolov (1):
      drivers: net: usb: rtl8150: concurrent URB bugfix

Philipp Zabel (1):
      ARM i.MX6q: Fix periph_clk2_sel and periph2_clk2_sel clocks

Ping Cheng (3):
      Input: wacom - add three new display tablets
      Input: wacom - add a few new styli for Cintiq series
      Input: wacom - add an eraser to DTH2242/DTK2241

Rafael J. Wysocki (2):
      ACPI / LPSS: register clock device for Lynxpoint DMA properly
      ACPI / PM: Allow device power states to be used for CONFIG_PM unset

Rafał Bilski (1):
      cpufreq / e_powersaver: Fix linker error when ACPI processor is a module

Rafał Miłecki (1):
      bcma: add more core IDs

Rajendra Nayak (2):
      ARM: OMAP2+: hwmod: Fix sidle programming in _enable_sysc()/_idle_sysc()
      ARM: OMAP2+: hwmod: Add a new flag to handle SIDLE in SWSUP only in active

Ralf Baechle (13):
      MIPS: Rewrite pfn_valid to work in modules, too.
      Add include dependencies to <linux/printk.h>.
      MIPS: clock.h: Remove declaration of cpu_wait.
      MIPS: Consolidate idle loop / WAIT instruction support in a single file.
      MIPS: Idle: cleaup SMTC idle hook as per Linux coding style.
      MIPS: Idle: Consistently reformat inline assembler.
      MIPS: Idle: Make call of function pointer readable.
      MIPS: Idle: Re-enable irqs at the end of r3081, au1k and
loongson2 cpu_wait.
      MIPS: Idle: Don't call local_irq_disable() in cpu_wait() implementations.
      MIPS: Idle: Consolidate all declarations in <asm/idle.h>.
      MIPS: Idle: Do address fiddlery in helper functions.
      MIPS: Idle: Break r4k_wait into two functions and fix it.
      mm: Fix virt_to_page() warning

Randy Dunlap (7):
      lp8788-charger: Fix kconfig dependency
      staging: sep: fix driver build and kconfig
      lib: make iovec obj instead of lib
      GFS2: fix DLM depends to fix build errors
      linux/kernel.h: fix kernel-doc warning
      auditfilter.c: fix kernel-doc warnings
      mm/memory_hotplug.c: fix printk format warnings

Robert Jarzmik (1):
      usb: phy: Fix NULL pointer exception during usb_get_phy

Robert P. J. Day (2):
      Correct typo "supperspeed" to "superspeed".
      Add a couple kernel-doc lines to prevent warnings.

Russell King (2):
      NET: mv643xx_eth: avoid lockdep dump on interface down
      i2c: mv64xxx: work around signals causing I2C transactions to be aborted

Rusty Russell (1):
      Hoist memcpy_fromiovec/memcpy_toiovec into lib/

Ryusuke Konishi (1):
      nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary

Sachin Kamat (12):
      usb: gadget: atmel_usba_udc: Remove redundant platform_set_drvdata()
      usb: gadget: bcm63xx_udc: Remove redundant platform_set_drvdata()
      usb: gadget: dummy_hcd: Remove redundant platform_set_drvdata()
      usb: gadget: f_uac2: Remove redundant platform_set_drvdata()
      usb: gadget: imx_udc: Remove redundant platform_set_drvdata()
      usb: gadget: pxa25x_udc: Remove redundant platform_set_drvdata()
      usb: gadget: s3c2410_udc: Remove redundant platform_set_drvdata()
      usb: phy: ab8500-usb: Remove redundant platform_set_drvdata()
      usb: phy: gpio-vbus-usb: Remove redundant platform_set_drvdata()
      usb: phy: mv-usb: Remove redundant platform_set_drvdata()
      usb: phy: mxs-usb: Remove redundant platform_set_drvdata()
      usb: phy: nop: Remove redundant platform_set_drvdata()

Samuel Ortiz (1):
      mei: bus: Reset event_cb when disabling a device

Sanjay Lal (2):
      KVM/MIPS32: Move include/asm/kvm.h => include/uapi/asm/kvm.h
since it is a user visible API.
      KVM/MIPS32: Wrap calls to gfn_to_pfn() with srcu_read_lock/unlock()

Santosh Shilimkar (4):
      ARM: OMAP2+: hwmod-data: UART IP needs software control to
manage sidle modes
      ARM: OMAP2+: serial: Remove the un-used slave idle hooks
      SERIAL: OMAP: Remove the slave idle handling from the driver
      ARM: OMAP2+: hwmod: Remove sysc slave idle and auto idle apis

Sarveshwar Bandi (1):
      be2net: Avoid double insertion of vlan tags.

Sasha Levin (1):
      mac80211_hwsim: correctly register the platform driver

Schemmel Hans-Christoph (1):
      USB: Blacklisted Cinterion's PLxx WWAN Interface

Sebastian Hesselbarth (1):
      ARM: plat-orion: add missing ehci include to common.h

Shahed Shaikh (1):
      qlcnic: Fix updating netdev->features

Shawn Guo (3):
      ARM: imx: replicate the diagnostic register of boot cpu into
secondary cores
      ARM: imx: fix typo in gpu3d_shader_sels
      net: fec: use a more proper compatible string for MVF type device

Simon Horman (1):
      ARM: shmobile: marzen: Use error values in usb_power_*

Sony Chacko (2):
      qlcnic: Return proper error codes from probe failure paths
      qlcnic: remove netdev->trans_start updates within the driver

Sridhar Samudrala (1):
      vxlan: Update vxlan fdb 'used' field after each usage

Srinivas Kandagatla (1):
      ARM: vt8500: Add missing NULL terminator in dt_compat

Stephen Boyd (1):
      ARM: smp: Drop RCU_NONIDLE usage in cpu_die()

Stephen Warren (2):
      USB: set device dma_mask without reference to global data
      drivers/video: implement a simple framebuffer driver

Steven Capper (1):
      ARM: 7727/1: remove the .vm_mm value from gate_vma

Steven Whitehouse (1):
      GFS2: Fix typo in gfs2_log_end_write loop

Sujith Manoharan (2):
      ath9k: Fix crash on module unload
      ath9k_hw: Enable manual peak calibration for AR9485

Teppo Kotilainen (1):
      usb: option: Add Telewell TW-LTE 4G

Thomas Petazzoni (2):
      ARM: mvebu: do not duplicate the mpic alias
      arm: mvebu: fix the 'ranges' property to handle PCIe

Timo Teräs (2):
      leds: leds-gpio: reserve gpio before using it
      xfrm: properly handle invalid states as an error

Tomas Winkler (1):
      mei: fix out of array access to me clients array

Tomasz Figa (1):
      drivers/rtc/rtc-max8998.c: check for pdata presence before dereferencing

Tony Lindgren (1):
      ARM: dts: Fix musb interrupt for device tree booting

Trond Myklebust (4):
      SUNRPC: Fix a bug in gss_create_upcall
      SUNRPC: Faster detection if gssd is actually running
      SUNRPC: Convert auth_gss pipe detection to work in namespaces
      SUNRPC: Prevent an rpc_task wakeup race

Ulf Hansson (1):
      mfd: db8500-prcmu: Update stored DSI PLL divider value

Vaibhav Hiremath (1):
      ARM: AM33XX: Add missing .clkdm_name to clkdiv32k_ick clock

Vineet Gupta (5):
      ARC: [mm] Prevent stray dcache lines after__sync_icache_dcach()
      ARC: copy_(to|from)_user() to honor usermode-access permissions
      ARC: Brown paper bag bug in macro for checking cache color
      ARC: Use enough bits for determining page's cache color
      ARC: lazy dcache flush broke gdb in non-aliasing configs

Viresh Kumar (3):
      cpufreq: Drop rwsem lock around CPUFREQ_GOV_POLICY_EXIT
      cpufreq: arm_big_little_dt: Register driver only if DT has valid data
      cpufreq: arm_big_little_dt: Instantiate as platform_driver

Vivek Gautam (1):
      usb: dwc3: Fix compilation break when building with USB_DWC3_DUAL_ROLE=y

Wang YanQing (1):
      TTY: Fix tty miss restart after we turn off flow-control

Wei WANG (1):
      USB: usb-stor: realtek_cr: Fix compile error

Wei Yang (1):
      be2net: bug fix on returning an invalid nic descriptor

Wei Yongjun (16):
      usb: gadget: zero: fix error return code in zero_bind()
      usb: musb: omap2430: add missing platform_device_put() on error
in omap2430_probe()
      usb: musb: dsps: fix error return code in dsps_create_musb_pdev()
      usb: gadget: s3c2410_udc: fix error return code in s3c2410_udc_probe()
      usb: gadget: r8a66597-udc: fix error return code in r8a66597_probe()
      usb: gadget: m66592-udc: fix error return code in m66592_probe()
      usb: gadget: fusb300_udc: fix error return code in fusb300_probe()
      usb: gadget: dummy_hcd: fix error return code in init()
      usb: gadget: fix error return code in configfs_composite_bind()
      ARM: OMAP: fix error return code in omap1_system_dma_init()
      gianfar: add missing iounmap() on error in gianfar_ptp_probe()
      serial: samsung: add missing platform_driver_unregister() when module exit
      tty: serial: mpc5xxx: fix error handing in mpc52xx_uart_init()
      serial: mcf: missing uart_unregister_driver() on error in mcf_init()
      TTY: ehv_bytechan: add missing platform_driver_unregister() when
module exit
      staging:iio:light:tsl2x7x: fix the error handling in tsl2x7x_probe()

Will Deacon (1):
      ARM: 7729/1: vfp: ensure VFP_arch is non-zero when VFP is not supported

Wolfram Sang (2):
      usb: gadget: don't check resource with devm_ioremap_resource
      usb: phy: don't check resource with devm_ioremap_resource

Xiao Guangrong (1):
      mm: mmu_notifier: re-fix freed page still mapped in secondary MMU

Xiong Zhou (2):
      bq27x00: Fix I2C dependency in KConfig
      staging: android: logger: use kuid_t instead of uid_t

Yinghai Lu (1):
      PCI: acpiphp: Re-enumerate devices when host bridge receives Bus Check

Yuval Mintz (1):
      bnx2x: Fix GSO for 57710/57711 chips

dyoung@redhat.com (1):
      driver core: print sysfs attribute name when warning about bogus
permissions

françois romieu (1):
      r8169: fix offloaded tx checksum for small packets.

jean-philippe francois (1):
      ARM: OMAP: fix __init section mismatch for _enable_preprogram

nikolay@redhat.com (4):
      bonding: fix set mode race conditions
      bonding: replace %x with %pI4 for IPv4 addresses
      bonding: arp_ip_count and arp_targets can be wrong
      bonding: fix multiple 3ad mode sysfs race conditions

salina@us.ibm.com (1):
      Char: lp, protect LPGETSTATUS with port_mutex

stephen hemminger (1):
      8139cp: reset BQL when ring tx ring cleared

wang, biao (1):
      klist: del waiter from klist_remove_waiters before wakeup waitting process
