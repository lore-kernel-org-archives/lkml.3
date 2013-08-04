Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3HDVJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 17:09:16 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:60063 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3HDVJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 17:09:13 -0400
MIME-Version: 1.0
Date: Sun, 4 Aug 2013 14:09:12 -0700
X-Google-Sender-Auth: 9cYvwGH9gdf4D-1onZrvuSnTtvg
Message-ID: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
Subject: Linux 3.11-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's that time of the week again..

 "You apply 339 patches, what do you get
  Another week older and deeper in debt
  Saint Peter don't you call me 'cause I can't go
  I owe my soul to the company store"

I had hoped things would start calming down, but rc4 is pretty much
exactly the same size as rc3 was. That said, the patches seem a bit
more spread out, and less interesting - which is a good thing. Boring
is good. Let's keep it that way, and try to make for fewer patches for
-rc5, ok? Because we are past half-way now, and I really want to see
just fixes.

We've got some arch updates (arm, parisc), but most of this is drivers
(mostly networking, usb and some drm updates). There's also some core
networking changes. And the printk code movement looks big if you
don't do git renames (ie like the patches I upload).

                  Linus

---

Aaro Koskinen (1):
      powerpc/windfarm: Fix noisy slots-fan on Xserve (rm31)

AceLan Kao (2):
      Bluetooth: Add support for Atheros [0cf3:3121]
      Bluetooth: Add support for Atheros [0cf3:e003]

Adam Lee (1):
      Bluetooth: fix wrong use of PTR_ERR() in btusb

Alex Deucher (15):
      drm/radeon: fix audio dto programming on DCE4+
      drm/radeon/dpm: fix display gap programming on SI
      drm/radeon/dpm: fix si_calculate_memory_refresh_rate()
      drm/radeon/dpm: fix powertune handling for pci id 0x6835
      drm/radeon: properly handle cg on asics without UVD
      drm/radeon/atom: fix fb when fetching engine params
      drm/radeon/dpm: fix forcing performance state to low on cayman
      drm/radeon/si: disable cgcg and pg for now
      drm/radeon/dpm: disable cac setup on SI
      drm/radeon/dpm: fix and enable reclocking on SI
      drm/radeon/atom: initialize more atom interpretor elements to 0
      drm: fix 64 bit drm fixed point helpers
      drm/radeon/dpm: fix calculations in
si_calculate_leakage_for_v_and_t_formula
      drm/radeon/dpm: re-enable cac control on SI
      drm/radeon: fix 64 bit divide in SI spm code

Alex Ivanov (1):
      parisc: agp/parisc-agp: allow binding of user memory to the AGP GART

Alex Williamson (3):
      vfio: Don't overreact to DEL_DEVICE
      vfio: Ignore sprurious notifies
      vfio-pci: Avoid deadlock on remove

Alexander Bondar (1):
      iwlwifi: mvm: Fix VIF specific debugfs directory creation

Alexey Khoroshilov (2):
      ath9k_htc: fix data race between request_firmware_nowait()
callback and suspend()
      can: usb_8dev: fix urb leak on failure path in usb_8dev_start()

Andi Shyti (1):
      mlx5_core: Variable may be used uninitialized

Andrew Morton (1):
      arch/x86/platform/ce4100/ce4100.c: include reboot.h

Andrzej Pietrasiewicz (4):
      usb: gadget: ether: put_usb_function on unbind
      usb: gadget: free opts struct on error recovery
      usb: gadget: multi: fix error return code in cdc_do_config()
      usb: gadget: f_phonet: remove unused preprocessor conditional

Arend van Spriel (3):
      brcmfmac: decrement pending 8021x count upon tx failure
      brcmfmac: bail out of brcmf_txflowblock_if() for non-netdev interface
      brcmfmac: inform cfg80211 about disconnect when device is unplugged

Arik Nemtsov (1):
      regulatory: use correct regulatory initiator on wiphy register

Arnaud Patard (2):
      mvneta: Fix hang when loading the mvneta driver
      mvneta: Try to fix mvneta when compiled as module

Arnd Bergmann (1):
      ssb: fix alignment of struct bcma_device_id

Aurelien Chartier (1):
      xenbus: frontend resume cleanup

Avinash Patil (2):
      mwifiex: check for bss_role instead of bss_mode for STA operations
      mwifiex: fix wrong data rates in P2P client

Axel Lin (1):
      serial: arc_uart: Fix module alias

Ben Hutchings (2):
      sfc: Enable RX scatter for flows steered by RFS
      dmi_scan: add comments on dmi_present() and the loop in dmi_scan_machine()

Ben Skeggs (1):
      drm/nouveau/vm: make vm refcount into a kref

Ben Widawsky (1):
      drm/i915: fix missed hunk after GT access breakage

Benjamin Tissoires (1):
      HID: sony: fix HID mapping for PS3 sixaxis controller

Bjorn Helgaas (2):
      PCI: hotplug: Convert to be builtin only, not modular
      PCI: pciehp: Convert pciehp to be builtin only, not modular

Bob Copeland (1):
      ath5k: fix extra set bit in multicast mask

Catalin Marinas (1):
      ARM: 7790/1: Fix deferred mm switch on VIVT processors

Chun-Yeow Yeoh (2):
      nl80211: fix the setting of RSSI threshold value for mesh
      mac80211: prevent the buffering or frame transmission to
non-assoc mesh STA

Clemens Ladisch (1):
      firewire: fix libdc1394/FlyCap2 iso event regression

Colin Cross (1):
      freezer: set PF_SUSPEND_TASK flag on tasks that call freeze_processes

Cong Wang (2):
      net: fix a compile error when CONFIG_NET_LL_RX_POLL is not set
      net: rename CONFIG_NET_LL_RX_POLL to CONFIG_NET_RX_BUSY_POLL

Dan Carpenter (12):
      arcnet: cleanup sizeof parameter
      mlx5: use after free in mlx5_cmd_comp_handler()
      fbdev/atyfb: fix recent breakage in correct_chipset()
      RDMA/cxgb4: Fix stack info leak in c4iw_create_qp()
      RDMA/ocrdma: Fix several stack info leaks
      RDMA/nes: Fix info leaks in nes_create_qp() and nes_create_cq()
      RDMA/cxgb3: Fix stack info leak in iwch_create_cq()
      af_key: more info leaks in pfkey messages
      IB/mlx5: Fix stack info leak in mlx5_ib_alloc_ucontext()
      mlx5_core: Fix use after free in mlx5_cmd_comp_handler()
      rapidio: fix use after free in rio_unregister_scan()
      net_sched: info leak in atm_tc_dump_class()

Daniel Borkmann (1):
      net: rtm_to_ifaddr: free ifa if ifa_cacheinfo processing fails

Daniel Drake (1):
      mwifiex: fix IRQ enable/disable

Dave Kleikamp (1):
      mm: sched: numa: fix NUMA balancing when !SCHED_DEBUG

David S. Miller (2):
      Revert "atl1c: Fix misuse of netdev_alloc_skb in refilling rx ring"
      net_sched: Fix stack info leak in cbq_dump_wrr().

David Spinadel (3):
      iwlwifi: mvm: fix bug in scan ssid
      iwlwifi: mvm: remove extra SSID from probe request
      iwlwifi: mvm: set SSID bits for passive channels

David Vrabel (1):
      xen/evtchn: avoid a deadlock when unbinding an event channel

Denis Kirjanov (1):
      sis900: Fix the tx queue timeout issue

Dimitris Papastamos (1):
      ASoC: wm0010: Fix resource leak

Egbert Eich (4):
      drm/mgag200: Fix logic in mgag200_bo_pin() (v2)
      drm/mgag200: Add an crtc_disable callback to the crtc helper funcs
      drm/mgag200: Add sysfs support for connectors
      drm/mgag200: Fix LUT programming for 16bpp

Eli Cohen (1):
      mlx5_core: Implement new initialization sequence

Emil Tantilov (1):
      igb: fix vlan filtering in promisc mode when not in VT mode

Emil Velikov (2):
      drm/nv50/gpio: post-nv92 cards have 32 interrupt lines
      drm/nv50-/disp: remove dcb_outp_match call, and related variables

Emilio López (1):
      net: sun4i: fix timeout check

Emmanuel Grumbach (6):
      iwlwifi: mvm: unregister leds when registration failed
      iwlwifi: mvm: fix L2P BA ressources leak
      iwlwifi: mvm: track the number of Rx BA sessions
      iwlwifi: add DELL SKU for 5150 HMC
      iwlwifi: pcie: reset the NIC before the bring up
      iwlwifi: pcie: clear RFKILL interrupt in AMPG

Erez Shitrit (1):
      IPoIB: Fix pkey change flow for virtualization environments

Eric Dumazet (4):
      netfilter: xt_socket: fix broken v0 support
      bridge: do not call setup_timer() multiple times
      usbnet: do not pretend to support SG/TSO
      atl1c: Fix misuse of netdev_alloc_skb in refilling rx ring

Fabio Estevam (3):
      fec: Add MODULE_ALIAS
      ARM: 7789/1: Do not run dummy_flush_tlb_a15_erratum() on non-Cortex-A15
      usb: chipidea: cast PORTSC_PTS and DEVLC_PTS macros

Felipe Balbi (1):
      net: ethernet: cpsw: drop IRQF_DISABLED

Felix Fietkau (3):
      mac80211/minstrel_ht: fix cck rate sampling
      mac80211/minstrel: fix NULL pointer dereference issue
      ath9k: fix tx pending frames accounting for dropped packets

Flavio Leitner (1):
      veth: add vlan features

Florian Fainelli (3):
      net: fix comment above build_skb()
      MIPS: BMIPS: do not change interrupt routing depending on boot CPU
      MIPS: BMIPS: fix slave CPU booting when physical CPU is not 0

Francesco Fusco (2):
      neigh: prevent overflowing params in /proc/sys/net/ipv4/neigh/
      sysctl: range checking in do_proc_dointvec_ms_jiffies_conv

Frank Li (1):
      net: fec: workaround stop tx during errata ERR006358

Frederic Danis (1):
      NFC: Fix NCI over SPI build

Gavin Shan (2):
      net/tg3: Fix kernel crash
      net/tg3: Fix warning from pci_disable_device()

Geert Uytterhoeven (2):
      rt2x00: RT2X00 should depend on HAS_DMA
      ath10k: ATH10K should depend on HAS_DMA

Gianluca Anzolin (1):
      tty_port: Fix refcounting leak in tty_port_tty_hangup()

Greg Kroah-Hartman (1):
      USB: serial: add driver for Suunto ANT+ USB device

Grygorii Strashko (1):
      drivers/rtc/rtc-twl.c: fix: rtcX/wakealarm attribute isn't created

Gu Zheng (1):
      ocfs2/refcounttree: add the missing NULL check of the return
value of find_or_create_page()

Gustavo Padovan (1):
      Bluetooth: Fix race between hci_register_dev() and hci_dev_open()

Hannes Frederic Sowa (1):
      ipv6: take rtnl_lock and mark mrt6 table as freed on namespace cleanup

Heesub Shin (1):
      mm: zbud: fix condition check on allocation size

Helge Deller (1):
      parisc: add defconfig for c8000 machine

Himanshu Madhani (3):
      qlcnic: Fix ethtool display for 83xx adapter.
      qlcnic: Free up memory in error path.
      qlcnic: Fix for flash update failure on 83xx adapter

Hugh Dickins (1):
      tmpfs: fix SEEK_DATA/SEEK_HOLE regression

Ilan Peer (1):
      iwlwifi: mvm: Disable managed PS when GO is added

Ilia Mirkin (6):
      drm/nouveau/core: xtensa firmware size needs to be 0x40000 no matter what
      drm/nv50/mc: include vp in the fb error reporting mask
      drm/nv31/mpeg: fix mpeg engine initialization
      drm/nva3-/disp: fix hda eld writing, needs to be padded
      drm/nv40/mpeg: write magic value to channel object to make it work
      drm/nv31/mpeg: don't recognize nv3x cards as having nv44 graph class

Inki Dae (2):
      drm/exynos: fix module build error
      drm/exynos: consider common clock framework to g2d driver.

J. Bruce Fields (4):
      svcrpc: fix gss_rpc_upcall create error
      svcrpc: fix gss-proxy xdr decoding oops
      svcrpc: fix kfree oops in gss-proxy code
      svcrpc: set cr_gss_mech from gss-proxy as well as legacy upcall

Jack Morgenstein (3):
      IB/mlx4: Use default pkey when creating tunnel QPs
      IB/core: Create QP1 using the pkey index which contains the default pkey
      net/mlx4_core: VFs must ignore the enable_64b_cqe_eqe module param

Jacob Keller (1):
      ixgbe: Fix Tx Hang issue with lldpad on 82598EB

Jaganath Kanakkassery (1):
      Bluetooth: Fix invalid length check in l2cap_information_rsp()

Jerry Snitselaar (1):
      fib_trie: potential out of bounds access in trie_show_stats()

Jiri Benc (1):
      ipv6: prevent race between address creation and removal

Jiri Pirko (1):
      ipv6: move peer_addr init into ipv6_add_addr()

Jiri Slaby (1):
      net: pch_gbe depends on x86

Jitendra Kalsaria (2):
      qlcnic: Fix releasing of Tx frag which was never mapped.
      qlcnic: Fix initialization of work function.

Joe Perches (7):
      MAINTAINERS: dynamic debug: Jason's not there...
      printk: move to separate directory for easier modification
      printk: add console_cmdline.h
      printk: move braille console support into separate braille.[ch] files
      printk: use pointer for console_cmdline indexing
      printk: rename struct log to struct printk_log
      ndisc: Add missing inline to ndisc_addr_option_pad

Johan Hedberg (2):
      Bluetooth: Fix HCI init for BlueFRITZ! devices
      Bluetooth: Fix calling request callback more than once

Johan Hovold (4):
      USB: mos7840: fix race in register handling
      USB: mos7840: fix device-type detection
      USB: mos7840: fix race in led handling
      USB: mos7840: fix pointer casts

Johannes Berg (8):
      cfg80211: fix bugs in new SME implementation
      regulatory: add missing rtnl locking
      mac80211: fix ethtool stats for non-station interfaces
      mac80211: fix duplicate retransmission detection
      iwlwifi: dvm: don't send BT_CONFIG on devices w/o Bluetooth
      iwlwifi: mvm: refuse connection to APs with BI < 16
      iwlwifi: mvm: use only a single GTK in D3
      iwlwifi: mvm: fix flushing not started aggregation sessions

John David Anglin (2):
      parisc: Fix cache routines to ignore vma's with an invalid pfn
      parisc: Remove arch/parisc/kernel/sys32.h header

Julien Grall (2):
      xen/arm64: Don't compile cpu hotplug
      xen/arm: enable PV control for ARM

Kalle Valo (2):
      MAINTAINERS: add ath10k
      MAINTAINERS: update ath6kl git location

Kirill A. Shutemov (1):
      thp, mm: avoid PageUnevictable on active/inactive lru lists

Kishon Vijay Abraham I (1):
      usb: musb: fix resource passed from glue layer to musb

Lan Tianyu (1):
      ACPI / battery: Fix parsing _BIX return value

Larry Finger (3):
      rtlwifi: Initialize power-setting callback for USB devices
      rtlwifi: Fix build errors for unusual cases
      ath: wil6210: Fix build error

Lars-Peter Clausen (3):
      ASoC: dapm: Fix return value of snd_soc_dapm_put_{volsw,enum_virt}()
      dma: pl330: Fix cyclic transfers
      ASoC: bf5xx-ac97: Fix compile error with SND_BF5XX_HAVE_COLD_RESET

Lekensteyn (2):
      r8169: fix lockdep warning when removing interface
      r8169: remove "PHY reset until link up" log spam

Linus Lüssing (1):
      bridge: disable snooping if there is no querier

Linus Torvalds (1):
      Linux 3.11-rc4

Linus Walleij (3):
      Revert "gpio/omap: fix build error when OF_GPIO is not defined."
      Revert "gpio/omap: auto request GPIO as input if used as IRQ via DT"
      Revert "gpio/omap: don't create an IRQ mapping for every GPIO on DT"

Luciano Coelho (1):
      MAINTAINERS: change email of TI WiLink drivers' maintainer

Luis Henriques (1):
      vga16fb: Remove unused variable

Maarten Lankhorst (3):
      drm/nouveau: fix null pointer dereference in poll_changed
      drm/nouveau: fix size check for cards without vm
      drm/nouveau: fix semaphore dmabuf obj

Maciej W. Rozycki (1):
      MIPS: uapi/asm/siginfo.h: Fix GCC 4.1.2 compilation

Manish Chopra (4):
      qlcnic: Fix panic while setting VF's MAC address
      qlcnic: Fix guest VLAN
      qlcnic: Fix setting Guest VLAN
      qlcnic: Fix diagnostic interrupt test for 83xx adapters.

Mark Brown (1):
      ASoC: bfin-ac97: Fix prototype error following AC'97 refactoring

Mark Rutland (2):
      ARM: 7786/1: hyp: fix macro parameterisation
      ARM: 7787/1: virt: ensure visibility of __boot_cpu_mode

Markos Chandras (2):
      MIPS: Set default CPU type for BCM47XX platforms
      MIPS: powertv: Fix arguments for free_reserved_area()

Markus Trippelsdorf (1):
      .gitignore: ignore *.lz4 files

Maxime Ripard (2):
      drivers: net: allwinner: Fix Kconfig indentation
      drivers: net: sun4i-emac: select MDIO_SUN4I

Maximilian Schneider (1):
      net: can: esd_usb2: check index of array before accessing

Michael Ellerman (2):
      powerpc: Rename PMU interrupts from CNT to PMI
      powerpc/perf: Export PERF_EVENT_CONFIG_EBB_SHIFT to userspace

Michael S. Tsirkin (2):
      macvlan: better mode validation
      macvlan: handle set_promiscuity failures

Michal Hocko (3):
      vmpressure: change vmpressure::sr_lock to spinlock
      vmpressure: do not check for pending work to prevent from new work
      vmpressure: make sure there are no events queued after memcg is offlined

Michal Kazior (1):
      nl80211: fix mgmt tx status and testmode reporting for netns

Michal Kubeček (2):
      ipv6: prevent fib6_run_gc() contention
      ipv6: update ip6_rt_last_gc every time GC is run

Michal Simek (1):
      video: xilinxfb: Fix compilation warning

Michal Tesar (1):
      sysctl net: Keep tcp_syn_retries inside the boundary

Mike Marciniszyn (1):
      IB/qib: Add err_decode() call for ring dump

Mugunthan V N (1):
      net: ethernet: davinci_emac: drop IRQF_DISABLED

Naoya Horiguchi (1):
      mm/swap.c: clear PageActive before adding pages onto unevictable list

Neil Horman (2):
      atl1c: Fix misuse of netdev_alloc_skb in refilling rx ring
      8139cp: Add dma_mapping_error checking

NeilBrown (1):
      NFSD/sunrpc: avoid deadlock on TCP connection due to memory pressure.

Nestor Lopez Casado (2):
      HID: Revert "Revert "HID: Fix logitech-dj: missing Unifying device issue""
      HID: hid-logitech-dj: querying_devices was never set

Oleg Nesterov (1):
      mm: mempolicy: fix mbind_range() && vma_adjust() interaction

Oleksij Rempel (2):
      ath9k_htc: do some initial hardware configuration
      ath9k_htc: reboot firmware if it was loaded

Or Gerlitz (2):
      IPoIB: Make sure child devices use valid/proper pkeys
      net/mlx4_core: Don't give VFs MAC addresses which are derived
from the PF MAC

Pablo Neira (1):
      genetlink: fix usage of NLM_F_EXCL or NLM_F_REPLACE

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: fix incorrect NAT expectation dumping

Paul Bolle (1):
      RDMA/cma: Fix gcc warning

Paul Moore (1):
      netlabel: use domain based selectors when address based
selectors are not available

Paul Walmsley (1):
      ARM: 7801/1: v6: prevent gcc 4.5 from reordering extended CP15
reads above is_smp() test

Peter Chen (1):
      usb: chipidea: fix the build error with randconfig

Pratik Pujar (3):
      qlcnic: Set __QLCNIC_DEV_UP in adapter state before enabling interrupts
      qlcnic: Fix operation type and command type.
      qlcnic: Removed adapter series name from warning messages.

Rafael J. Wysocki (3):
      Revert "cpuidle: Quickly notice prediction failure in general case"
      Revert "cpuidle: Quickly notice prediction failure for repeat mode"
      cpufreq: Fix cpufreq driver module refcount balance after suspend/resume

Rajesh Borundia (2):
      qlcnic: Fix link speed display for 82xx adapter
      qlcnic: Fix link speed and duplex display for 83xx adapter

Ralf Baechle (1):
      ASoC: au1x: Fix build

Rick Farina (Zero_Chaos) (1):
      USB: serial: ftdi_sio: add more RT Systems ftdi devices

Robert Jennings (1):
      powerpc: VPHN topology change updates all siblings

Roland Dreier (2):
      RDMA/ocrdma: Remove unused include
      Revert "RDMA/nes: Fix compilation error when nes_debug is enabled"

Roman Gushchin (1):
      net: check net.core.somaxconn sysctl values

Rong Wang (1):
      usb: gadget: udc-core: fix the typo of udc state attribute

Roy Spliet (1):
      drm/nvc0/fb: take lock in nvc0_ram_put()

Russell King (14):
      ARM: document DEBUG_UNCOMPRESS Kconfig option
      ARM: 7785/1: mm: restrict early_alloc to section-aligned memory
      ARM: Fix sorting of machine- initializers
      ARM: poison the vectors page
      ARM: poison memory between kuser helpers
      ARM: move vector stubs
      ARM: use linker magic for vectors and vector stubs
      ARM: update FIQ support for relocation of vectors
      ARM: allow kuser helpers to be removed from the vector page
      ARM: move signal handlers into a vdso-like page
      ARM: make vectors page inaccessible from userspace
      ARM: Add .text annotations where required after __CPUINIT removal
      ARM: fix a cockup in 48be69a02 (ARM: move signal handlers into a
vdso-like page)
      ARM: fix nommu builds with 48be69a02 (ARM: move signal handlers
into a vdso-like page)

Sachin Kamat (1):
      drm/exynos: Remove module.h header inclusion

Samuel Ortiz (1):
      NFC: netlink: Rename CMD_FW_UPLOAD to CMD_FW_DOWNLOAD

Sean Hefty (2):
      RDMA/cma: Fix accessing invalid private data for UD
      RDMA/cma: Only call cma_save_ib_info() for CM REQs

Shahed Shaikh (5):
      qlcnic: Fix invalid register offset calculation
      qlcnic: Fix dump template version mask
      qlcnic: Fix MAC address filter issue on 82xx adapter
      qlcnic: Fix ingress MAC learning
      qlcnic: Fix external loopback test.

Solomon Peachy (1):
      cw1200: Fix OOPS in monitor mode

Stanislaw Gruszka (4):
      mac80211: fix monitor interface suspend crash regression
      Bluetooth: ath3k: don't use stack memory for DMA
      genetlink: release cb_lock before requesting additional module
      rt2x00: fix stop queue

Stefano Stabellini (2):
      xen/arm,arm64: update xen_restart after ff701306cd49 and 7b6d864b48d9
      xen/tmem: do not allow XEN_TMEM on ARM64

Stephen Boyd (2):
      gpio_msm: Fix build error due to missing err.h
      ARM: 7803/1: Fix deadlock scenario with smp_send_stop()

Steven J. Hill (1):
      MIPS: Fix multiple definitions of UNCAC_BASE.

Stone Piao (1):
      mwifiex: fix command 0x2c timeout during p2p_find or p2p_connect

Sucheta Chakraborty (2):
      qlcnic: Fix NULL pointer dereference in VF probe path.
      qlcnic: Fix multicast packet handling for PF and VF.

Sujith Manoharan (2):
      ath9k_hw: Fix multicast search for AR9002 family
      Bluetooth: ath3k: Add support for ID 0x13d3/0x3402

Takashi Iwai (2):
      drm/mgag200: Fix framebuffer pitch calculation
      ALSA: hda - Fix missing fixup for Mac Mini with STAC9221

Tetsuyuki Kobayashi (1):
      ARM: 7788/1: elf: fix lpae hwcap feature reporting in proc/cpuinfo

Thomas Bogendoerfer (1):
      parisc: Fix interrupt routing for C8000 serial ports

Thomas Loo (1):
      Bluetooth: ath3k: Add support for Fujitsu Lifebook UH5x2 [04c5:1330]

Thomas Petazzoni (1):
      PCI: mvebu: Disable prefetchable memory support in PCI-to-PCI bridge

Tomasz Moń (1):
      mwifiex: Add missing endian conversion.

Tomi Valkeinen (1):
      fbdev/sgivwfb: fix compilation error in sgivwfb_mmap()

Tony Luck (1):
      x86/mce: Fix mce regression from recent cleanup

Uwe Kleine-König (4):
      serial/mxs-auart: fix race condition in interrupt handler
      serial/mxs-auart: increase time to wait for transmitter to become idle
      net/fec: Don't let ndo_start_xmit return NETDEV_TX_BUSY without link
      ARM: 7800/1: ARMv7-M: Fix name of NVIC handler function

Vineet Gupta (1):
      ARC: SMP build breakage

Vinod Koul (1):
      ALSA: compress: fix the return value for SNDRV_COMPRESS_VERSION

Vivien Didelot (1):
      hwmon: (max6697) fix MAX6581 ideality

Wei Yongjun (6):
      pch_dma: fix error return code in pch_dma_probe()
      video: nuc900fb: fix to pass correct device identity to request_irq()
      video: sh7760fb: fix to pass correct device identity to free_irq()
      drm/exynos: exynos_drm_ipp: fix return value check
      mlx5: fix error return code in mlx5_alloc_uuars()
      IB/mlx5: Fix error return code in init_one()

Will Deacon (2):
      ARM: 7784/1: mm: ensure SMP alternates assemble to exactly 4
bytes with Thumb-2
      ARM: 7791/1: a.out: remove partial a.out support

Ying Xue (1):
      tipc: fix oops when creating server socket fails

Yinghai Lu (2):
      PCI: pciehp: Fix null pointer deref when hot-removing SR-IOV device
      PCI: Retry allocation of only the resource type that failed

Yonghua Zheng (1):
      HID: hidraw: fix improper mutex release

hayeswang (5):
      net/usb/r815x: replace USB buffer from stack to DMA-able
      net/usb/r815x: avoid to call mdio functions for runtime-suspended device
      net/usb/r815x: change the return value for bind functions
      net/usb/r8152: make sure the USB buffer is DMA-able
      net/usb/r8152: adjust relative ocp function

stephen hemminger (3):
      vxlan: unregister on namespace exit
      vxlan: fix igmp races
      htb: fix sign extension bug
