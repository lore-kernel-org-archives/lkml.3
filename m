Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbbARJRZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 04:17:25 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53375 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbbARJRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 04:17:13 -0500
MIME-Version: 1.0
Date: Sun, 18 Jan 2015 21:17:12 +1200
X-Google-Sender-Auth: GIBcGQL7FS5EcwW3qNifki5H-Ao
Message-ID: <CA+55aFxNk9OCXz7nvKXpRBc0Z85NLXPNkRm1yJf4-KAGB4pHRA@mail.gmail.com>
Subject: Linux 3.19-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc.

Fairly normal release, although I'd wish that by rc5 we'd have calmed
down even further.  But no, with some of the driver tree merges in
particular, this is actually larger than rc4 was.

That said, it's not like there is anything particularly scary in here.

The arm64 vm bug that I mentioned as pending in the rc4 notes got
fixed within a day of that previous rc release, and the rest looks
pretty standard. Mostly drivers (networking, usb, scsi target, block
layer, mmc,  tty etc), but also arch updates (arm, x86, s390 and some
tiny powerpc fixes), some filesystem updates (fuse and nfs), tracing
fixes, and some perf tooling fixes.

Shortlog with the details appended.

Go forth and test.

                Linus

---

Abhilash Kesavan (2):
      drivers: bus: check cci device tree node status
      ARM: dts: disable CCI on exynos5420 based arndale-octa

Adrian Hunter (6):
      mmc: sdhci: Tuning should not change max_blk_count
      mmc: sdhci: Add out_unlock to sdhci_execute_tuning
      mmc: sdhci: Simplify use of tuning timer
      mmc: sdhci: Disable re-tuning for HS400
      mmc: sdhci-acpi: Add ACPI HID INT344D
      mmc: sdhci-pci: Add support for Intel SPT

Alan Stern (2):
      USB: EHCI: fix initialization bug in iso_stream_schedule()
      USB: EHCI: adjust error return code

Alexander Stein (1):
      ARM: at91/dt: sam9263: Add missing clocks to lcdc node

Alexander Usyskin (1):
      mei: clean reset bit before reset

Alexandre Belloni (1):
      net/at91_ether: prepare and unprepare clock

Alexey Brodkin (1):
      perf tools: Fix statfs.f_type data type mismatch build error with uclibc

Alexey Khoroshilov (1):
      usb/kaweth: use GFP_ATOMIC under spin_lock in usb_start_wait_urb()

Amit Virdi (2):
      usb: dwc3: gadget: Fix TRB preparation during SG
      usb: dwc3: gadget: Stop TRB preparation after limit is reached

Andreas Faerber (1):
      ARM: exynos_defconfig: Enable LM90 driver

Andrey Skvortsov (1):
      selftests/vm: fix link error for transhuge-stress test

Andy Grover (1):
      iscsi-target: Fix typos in enum cmd_flags_table

Andy Shevchenko (1):
      dmaengine: dw: balance PM runtime calls

Ani Sinha (1):
      update ip-sysctl.txt documentation (v2)

Anjali Singhai (2):
      i40e: Fix Rx checksum error counter
      i40e: Fix bug with TCP over IPv6 over VXLAN

Anson Huang (1):
      Thermal: imx: add clk disable/enable for suspend/resume

Anton Blanchard (1):
      powernv: Fix OPAL tracepoint code

Arik Nemtsov (1):
      iwlwifi: pcie: correctly define 7265-D cfg

Arnaldo Carvalho de Melo (1):
      tools: Remove bitops/hweight usage of bits in tools/perf

Arnd Bergmann (2):
      usb: phy: mv-usb: fix usb_phy build errors
      bridge: only provide proxy ARP when CONFIG_INET is enabled

Arseny Solokha (1):
      OHCI: add a quirk for ULi M5237 blocking on reset

Axel Lin (2):
      gpio: dln2: Fix gpio output value in dln2_gpio_direction_output()
      gpio: grgpio: Avoid potential NULL pointer dereference

B Viswanath (1):
      net: Corrected the comment describing the ndo operations to
reflect the actual prototype for couple of operations

Benjamin Poirier (1):
      netdevice: Add missing parentheses in macro

Bo Shen (4):
      usb: gadget: udc: atmel: change setting for DMA
      usb: gadget: udc: atmel: fix possible IN hang issue
      ARM: at91/dt: sama5d4: fix the timer reg length
      ARM: at91: sama5d3: dt: correct the sound route

Boris Brezillon (1):
      clk: at91: keep slow clk enabled to prevent system hang

Boris Ostrovsky (2):
      x86/xen: Remove unnecessary BUG_ON(preemptible()) in xen_setup_timer()
      x86/xen: Free bootmem in free_p2m_page() during early boot

Catalin Marinas (1):
      arm64: partially revert "ARM: 8167/1: extend the reserved memory
for initrd to be page aligned"

Chanwoo Choi (1):
      serial: samsung: Add the support for Exynos5433 SoC

Chen Gang (1):
      s390/timex: fix get_tod_clock_ext() inline assembly

Christian Borntraeger (3):
      s390/vtime: Get rid of redundant WARN_ON
      s390/kernel: use stnsm 255 instead of stosm 0
      kernel: Change ASSIGN_ONCE(val, x) to WRITE_ONCE(x, val)

Christoph Hellwig (1):
      scsi: ->queue_rq can't sleep

Christoph Jaeger (1):
      packet: bail out of packet_snd() if L2 header creation fails

Chuck Lever (1):
      NFS: Ignore transport protocol when detecting server trunking

Colin Ian King (1):
      fbdev/broadsheetfb: fix memory leak

Dan Carpenter (3):
      ipvs: uninitialized data with IP_VS_IPV6
      phy: miphy28lp: unlock on error in miphy28lp_init()
      usb: gadget: gadgetfs: fix an oops in ep_write()

Darrick J. Wong (1):
      uas: disable UAS on Apricorn SATA dongles

David Drysdale (1):
      selftests/exec: allow shell return code of 126

David Peterson (1):
      USB: cp210x: add IDs for CEL USB sticks and MeshWorks devices

David Spinadel (2):
      iwlwifi: mvm: add a flag to enable match found notification
      iwlwifi: mvm: scan dwell time corrections

David Vrabel (3):
      x86/xen: don't count how many PFNs are identity mapped
      x86/xen: add extra memory for remapped frames during setup
      xen-netfront: use different locks for Rx and Tx stats

Doug Anderson (1):
      ARM: dts: rockchip: bump sd card pin drive strength up on rk3288-evb

Eddie Kovsky (1):
      staging: vt6655: fix sparse warning: argument type

Eduardo Valentin (1):
      MAINTAINERS: update ti-soc-thermal status

Emmanuel Grumbach (2):
      iwlwifi: 7000: fix reported firmware name for 7265D
      iwlwifi: bump firmware API for mvm devices to 12

Eric Dumazet (2):
      net: dnet: fix dnet_poll()
      alx: fix alx_poll()

Eyal Shapira (2):
      iwlwifi: mvm: fix Rx with both chains
      iwlwifi: mvm: fix out of bounds access to tid_to_mac80211_ac

Fabien Proriol (1):
      iio: iio: Fix iio_channel_read return if channel havn't info

Fabio Estevam (3):
      ARM: dts: imx25: Fix the SPI1 clocks
      ARM: imx6sx: Set PLL2 as parent of QSPI clocks
      ARM: dts: imx51-babbage: Fix ULPI PHY reset modelling

Felipe Balbi (2):
      usb: musb: debugfs: cope with blackfin's oddities
      usb: musb: blackfin: fix build break

Gary Bisson (1):
      ARM: clk-imx6q: fix video divider for rev T0 1.0

Geert Uytterhoeven (5):
      ARM: shmobile: r8a7740: Instantiate GIC from C board code in legacy builds
      thermal: of: Remove bogus type qualifier for of_thermal_get_trip_points()
      ARM: shmobile: sh73a0 legacy: Set .control_parent for all irqpin instances
      m68k: Wire up execveat
      thermal: rcar: Spelling/grammar: s/drier use .../driver uses ...s/

Giel van Schijndel (1):
      isdn: fix NUL (\0 or \x00) specification in string

Hans de Goede (7):
      phy-sun4i-usb: Change disconnect threshold value for sun6i
      xhci: Add broken-streams quirk for Fresco Logic FL1000G xhci controllers
      uas: Add US_FL_NO_ATA_1X for Seagate devices with usb-id 0bc2:a013
      uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS566 with usb-id 0bc2:a013
      uas: Do not blacklist ASM1153 disk enclosures
      uas: Add US_FL_NO_ATA_1X for 2 more Seagate disk enclosures
      simplefb: Fix build failure on Sparc

Harald Freudenberger (1):
      s390/zcrypt: kernel oops at insmod of the z90crypt device driver

Hariprasad Shenai (2):
      cxgb4vf: Initialize mdio_addr before using it
      cxgb4vf: Fix queue allocation for 40G adapter

Heikki Krogerus (1):
      usb: dwc3: pci: add support for Intel Sunrise Point PCH

Heiko Carstens (1):
      s390: wire up execveat syscall

Heiko Stuebner (2):
      clk: rockchip: fix rk3066 pll lock bit location
      clk: rockchip: fix rk3288 cpuclk core dividers

Heiko Stübner (2):
      ARM: rockchip: disable jtag/sdmmc autoswitching on rk3288
      clk: rockchip: fix deadlock possibility in cpuclk

Hubert Feurstein (1):
      net: fec: fix NULL pointer dereference in fec_enet_timeout_work

Ian Munsie (1):
      cxl: Fix issues when unmapping contexts

James Bottomley (1):
      serial: fix parisc boot hang

Jan Beulich (1):
      x86/xen: properly retrieve NMI reason

Jan Willeke (1):
      s390/uprobes: fix user space PER events

Javi Merino (1):
      Documentation: thermal: document of_cpufreq_cooling_register()

Javier Martinez Canillas (1):
      ARM: exynos_defconfig: Enable options for display panel support

Jean-Francois Remy (1):
      neighbour: fix base_reachable_time(_ms) not effective immediatly
when changed

Jens Axboe (3):
      block: wake up waiters when a queue is marked dying
      blk-mq: get rid of ->cmd_size in the hardware queue
      blk-mq: Add helper to abort requeued requests

Jeremiah Mahler (2):
      usb: serial: silence all non-critical read errors
      usb: serial: handle -ENODEV quietly in generic_submit_read_urb

Jesse Brandeburg (1):
      i40e: fix un-necessary Tx hangs

Jiri Pirko (1):
      team: avoid possible underflow of count_pending value for
notify_peers and mcast_rejoin

Jisheng Zhang (4):
      ARM: dts: berlin: fix io clk and add missing core clk for BG2Q sdhci2 host
      ARM: dts: berlin: add broken-cd and set bus width for eMMC in
Marvell DMP DT
      ARM: dts: berlin: correct BG2Q's SM GPIO location.
      clk: berlin: bg2q: remove non-exist "smemc" gate clock

Johan Hovold (3):
      USB: keyspan: fix null-deref at probe
      USB: console: fix uninitialised ldisc semaphore
      USB: console: fix potential use after free

Johannes Thumshirn (1):
      mcb: mcb-pci: Only remap the 1st 0x200 bytes of BAR 0

John W. Linville (1):
      usb: gadget: udc: avoid dereference before NULL check in ep_queue

Jon Paul Maloy (1):
      tipc: fix bug in broadcast retransmit code

Juergen Gross (4):
      xen: correct error for building p2m list on 32 bits
      xen: correct race in alloc_p2m_pmd()
      xen: use correct type for physical addresses
      xen: check for zero sized area when invalidating memory

Julia Lawall (1):
      usb: gadget: fix misspelling of current function in string

Julien CHAUVEAU (1):
      clk: rockchip: add CLK_IGNORE_UNUSED flag to fix rk3066/rk3188 USB Host

Kan Liang (1):
      perf/x86/intel: Fix bug for "cycles:p" and "cycles:pp" on SLM

Keith Busch (14):
      blk-mq: Exit queue on alloc failure
      blk-mq: Export freeze/unfreeze functions
      NVMe: Fix double free irq
      blk-mq: Wake tasks entering queue on dying
      blk-mq: Export if requests were started
      blk-mq: Let drivers cancel requeue_work
      blk-mq: Allow requests to never expire
      blk-mq: End unstarted requests on a dying queue
      NVMe: Start all requests
      NVMe: Reference count admin queue usage
      NVMe: Admin queue removal handling
      NVMe: Command abort handling fixes
      NVMe: Start and stop h/w queues on reset
      NVMe: Fix locking on abort handling

Kevin Hao (1):
      Revert "clk: ppc-corenet: Fix Section mismatch warning"

Krzysztof Kozlowski (1):
      mmc: sdhci: Fix sleep in atomic after inserting SD card

Larry Finger (1):
      rtlwifi: Fix error when accessing unmapped memory in skb

Lars-Peter Clausen (1):
      iio: ad799x: Fix ad7991/ad7995/ad7999 config setup

Lee Duncan (1):
      target: Allow Write Exclusive non-reservation holders to READ

Lennart Sorensen (3):
      ARM: omap5/dra7xx: Fix frequency typos
      ARM: dra7xx: Fix counter frequency drift for AM572x errata i856
      ARM: omap5/dra7xx: Enable booting secondary CPU in HYP mode

Linus Torvalds (1):
      Linux 3.19-rc5

Linus Walleij (1):
      ARM: nomadik: fix up leftover device tree pins

Louis Langholtz (1):
      kernel: avoid overflow in cmp_range

Malcolm Priestley (2):
      staging: vt6655: vnt_tx_packet Fix corrupted tx packets.
      staging: vt6655: Fix loss of distant/weak access points on channel change.

Marc Zyngier (2):
      arm64: KVM: Fix TLB invalidation by IPA/VMID
      arm64: KVM: Fix HCR setting for 32bit guests

Mario Schuknecht (1):
      usb: gadget: gadgetfs: Free memory allocated by memdup_user()

Martin Schwidefsky (1):
      s390/mm: avoid using pmd_to_page for !USE_SPLIT_PMD_PTLOCKS

Mathias Nyman (1):
      xhci: Check if slot is already in default state before moving it there

Maxime Ripard (1):
      usb: phy: Fix deferred probing

Michael Ellerman (1):
      powerpc: Work around gcc bug in current_thread_info()

Michael Holzheu (2):
      s390/bpf: Fix ALU_NEG (A = -A)
      s390/bpf: Fix JMP_JGE_X (A > X) and JMP_JGT_X (A >= X)

Mike Krinkin (1):
      staging: vt6655: fix sparse warnings: incorrect argument type

Miklos Szeredi (2):
      fuse: fix LOOKUP vs INIT compat handling
      fuse: add memory barrier to INIT

Ming Lei (1):
      block: fix checking return value of blk_mq_init_queue

Mugunthan V N (2):
      ARM: dts: dra7-evm: fix qspi device tree partition size
      drivers: net: cpsw: fix multicast flush in dual emac mode

Namhyung Kim (4):
      perf probe: Propagate error code when write(2) failed
      perf tools: Fix building error in x86_64 when dwarf unwind is on
      perf machine: Fix __machine__findnew_thread() error path
      perf tools: Fix segfault for symbol annotation on TUI

NeilBrown (1):
      locks: fix NULL-deref in generic_delete_lease

Nicholas Bellinger (4):
      vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion
      Documentation/target: Update fabric_ops to latest code
      target: Drop arbitrary maximum I/O size limit
      target: Drop left-over fabric_max_sectors attribute

Nilesh Javali (1):
      MAINTAINERS: Update maintainer list for qla4xxx

Nishanth Menon (2):
      MAINTAINERS: Add linux-omap to list of reviewers for TI Thermal
      ARM: omap2plus_defconfig: use CONFIG_CPUFREQ_DT

Nobuhiro Iwamatsu (2):
      sh-eth: Set fdr_value of R-Car SoCs
      sh_eth: Fix access to TRSCER register

Octavian Purdila (2):
      gpio: dln2: fix issue when an IRQ is unmasked then enabled
      gpio: dln2: use bus_sync_unlock instead of scheduling work

Pablo Neira Ayuso (4):
      netfilter: conntrack: fix race between confirmation and flush
      netfilter: nfnetlink: validate nfnetlink header from batch
      netfilter: nfnetlink: relax strict multicast group check from netlink_bind
      netfilter: nf_tables: fix flush ruleset chain dependencies

Peter Chen (2):
      usb: gadget: f_uac1: access freed memory at f_audio_free_inst
      Revert "usb: chipidea: remove duplicate dev_set_drvdata for host_start"

Peter Hurley (2):
      tty: Prevent hw state corruption in exclusive mode reopen
      Revert "tty: Fix pty master poll() after slave closes v2"

Philipp Zabel (1):
      ARM: dts: imx6qdl: Fix CODA960 interrupt order

Prashant Sreedharan (3):
      tg3: tg3_timer() should grab tp->lock before checking for tp->irq_sync
      tg3: tg3_reset_task() needs to use rtnl_lock to synchronize
      tg3: Release tp->lock before invoking synchronize_irq()

Preston Fick (1):
      USB: cp210x: fix ID for production CEL MeshConnect USB Stick

Rasmus Villemoes (2):
      usb: musb: Fix a few off-by-one lengths
      kernfs: Fix kernfs_name_compare

Reinhard Speyerer (1):
      USB: qcserial/option: make AT URCs work for Sierra Wireless MC73xx

Robert Baldyga (1):
      usb: dwc2: gadget: kill requests with 'force' in s3c_hsotg_udc_stop()

Romain Perier (1):
      clk: rockchip: Fix clock gate for rk3188 hclk_emem_peri

Sagi Grimberg (1):
      MAINTAINERS: Add entry for iSER target driver

Sebastian Andrzej Siewior (1):
      usb: musb: stuff leak of struct usb_hcd

Sergej Pupykin (1):
      tty: Add support for the WCH384 4S multi-IO card

Simon Guinot (1):
      leds: netxbig: fix oops at probe time

Songjun Wu (1):
      usb: gadget: udc: atmel: fix possible oops when unloading module

Stanimir Varbanov (1):
      clk: fix possible null pointer dereference

Stefan Agner (1):
      net: fec: fix MDIO bus assignement for dual fec SoC's

Stephane Eranian (1):
      perf/rapl: Fix sysfs_show() initialization for RAPL PMU

Steven Rostedt (Red Hat) (5):
      ftrace: Fix updating of filters for shared global_ops filters
      ftrace: Check both notrace and filter for old hash
      ftrace/jprobes/x86: Fix conflict between jprobes and function
graph tracing
      tracing: Remove extra call to init_ftrace_syscalls()
      tracing: Fix enabling of syscall events on the command line

Sukadev Bhattiprolu (1):
      perf tools powerpc: Use dwfl_report_elf() instead of offline.

Thierry Reding (1):
      usb: phy: Restore deferred probing path

Thomas Falcon (1):
      MAINTAINERS: add me as ibmveth maintainer

Thomas Graf (1):
      openvswitch: packet messages need their own probe attribtue

Thomas Petazzoni (1):
      mmc: sdhci-pxav3: do the mbus window configuration after enabling clocks

Tim Kryger (1):
      mmc: sdhci: Set SDHCI_POWER_ON with external vmmc

Tomas Winkler (1):
      mei: add ABI documentation for fw_status exported through sysfs

Tony Lindgren (3):
      usb: musb: Fix randconfig build issues for Kconfig options
      ARM: OMAP2+: Fix n900 board name for legacy user space
      ARM: dts: Revert disabling of smc91x for n900

Trond Myklebust (5):
      LOCKD: Fix a race when initialising nlmsvc_timeout
      NFSv4.1: Fix client id trunking on Linux
      NFSv4: Cache the NFSv4/v4.1 client owner_id in the struct nfs_client
      NFSv4/v4.1: Verify the client owner id during trunking detection
      NFSv4: Remove incorrect check in can_open_delegated()

Tyler Baker (1):
      reset: sunxi: fix spinlock initialization

Vasu Dev (1):
      i40e: adds FCoE configure option

Vignesh R (1):
      phy: phy-ti-pipe3: fix inconsistent enumeration of PCIe gen2 cards

Vince Hsu (1):
      usb: host: ehci-tegra: request deferred probe when failing to get phy

Vineet Gupta (2):
      perf tools: Elide strlcpy warning with uclibc
      perf tools: Avoid build splat for syscall numbers with uclibc

Vinod Koul (1):
      MAINTAINERS: dmaengine: fix the header file for dmaengine

Vitaly Kuznetsov (1):
      x86/xen: avoid freeing static 'name' when kasprintf() fails

Vivek Gautam (1):
      arm: dts: Use pmu_system_controller phandle for dp phy

Wang Nan (1):
      perf test: Fix dwarf unwind using libunwind.

Wenyou Yang (1):
      ARM: at91: board-dt-sama5: add phy_fixup to override NAND_Tree

Will Deacon (2):
      arm64: compat: wire up compat_sys_execveat
      mm: mmu_gather: use tlb->end != 0 only for TLB invalidation

Xiubo Li (1):
      ARM: ls1021a: dtsi: add 'big-endian' property for scfg node

Yoshihiro Shimoda (2):
      thermal: rcar: fix ENR register value
      thermal: rcar: change type of ctemp in rcar_thermal_update_temp()

Zhang Rui (3):
      ACPI/int340x_thermal: enumerate INT340X devices even if they're
not in _ART/_TRT
      ACPI/int340x_thermal: enumerate INT3401 for Intel SoC DTS thermal driver
      int340x_thermal/processor_thermal_device: return failure when

dann frazier (1):
      tools: testing: selftests: mq_perf_tests: Fix infinite loop on ARM

leroy christophe (1):
      netfilter: nf_tables: fix port natting in little endian archs
