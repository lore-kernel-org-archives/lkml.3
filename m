Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3LOUqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 15:46:10 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:40751 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3LOUqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 15:46:05 -0500
MIME-Version: 1.0
Date: Sun, 15 Dec 2013 12:46:04 -0800
X-Google-Sender-Auth: 3202h9n3Tq1m5jDMq2HdVxQoGzU
Message-ID: <CA+55aFxtMV5c01ZA36M1sKM+M9pVQraP96GsM8fy5g9FnZSJ3Q@mail.gmail.com>
Subject: Linux 3.13-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I delayed this a couple of days to get back to my normal Sunday
release schedule, but I'm not entirely happy with the result. Things
aren't calming down the way they should be, and -rc4 is bigger than
previous rc's. And I don't think I can just blame the two extra days.

Anyway, what that means from a practical standpoint is that I'm going
to be *very* grumpy at anybody who sends me unnecessary crap. If it's
not  regression or marked for stable, then just don't send it to me.
Because you *will* be called names if you can't follow those simple
rules. Comprende?

Anyway, the bulk of changes for rc4 is drivers (notably networking and
gpu, but there's usb, input and media driver updates too). Aside from
that, there are the usual arch updates (mainly ARM) and the slightly
less usual selinux updates.  And generic networking, with some random
stuff thrown in for good measure. The shortlog isn't very short, but
it's appended for your reading pleasure.

We're obviously heading for the holiday season, and I'm really hoping
that will help calm things down too for the rest of the release
candidates...

                  Linus

---

Aaro Koskinen (1):
      usb: phy-generic: fix nop xceiv probe

Alan Cox (2):
      sc1200_wdt: Fix oops
      drivers/char/i8k.c: add Dell XPLS L421X

Alan Stern (1):
      usb: dwc3: fix implementation of endpoint wedge

Alex Deucher (6):
      drm/radeon: fix typo in fetching mpll params
      drm/radeon: program DCE2 audio dto just like DCE3
      drm/radeon/dpm: simplify state adjust logic for NI
      drm/radeon: fixup bad vram size on SI
      drm/radeon: fix null pointer dereference in dce6+ audio code
      drm/radeon/atom: fix bus probes when hw_i2c is set (v2)

Alexander Bondar (1):
      iwlwifi: pcie: stop sending commands to dead firmware

Alexander Duyck (1):
      PCI: Avoid unnecessary CPU switch when calling driver .probe() method

Alexandre Demers (1):
      drm/radeon: Fix a typo in Cayman and Evergreen registers

Alexandre Rames (1):
      sfc: Stop/re-start PTP when stopping/starting the datapath.

Alexey Khoroshilov (1):
      [media] dvb_demux: fix deadlock in dmx_section_feed_release_filter()

Anatolij Gustschin (1):
      powerpc/52xx: Re-enable bestcomm driver in defconfigs

Andrew Liu (1):
      Input: keyboard - "keycode & KEY_MAX" changes some keycode values

Andrew Rybchenko (1):
      sfc: RX buffer allocation takes prefix size into account in IP
header alignment

Andrey Vagin (2):
      virtio-net: determine type of bufs correctly
      virtio: delete napi structures from netdev before releasing memory

Andrzej Pietrasiewicz (1):
      usb: gadget: f_mass_storage: fix mass storage dependency

Andy Honig (3):
      KVM: Improve create VCPU parameter (CVE-2013-4587)
      KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)
      KVM: x86: Convert vapic synchronization to _cached functions
(CVE-2013-6368)

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix IEC958 ctl indexes for some simple HDMI devices

Antti Palosaari (4):
      [media] af9035: add [0413:6a05] Leadtek WinFast DTV Dongle Dual
      [media] af9035: fix broken I2C and USB I/O
      [media] af9033: fix broken I2C
      [media] rtl2830: add parent for I2C adapter

Apelete Seketeli (1):
      usb: fix musb gadget to enable OTG mode conditionally

Arend van Spriel (1):
      brcmfmac: fix uninitialized warning

Aristeu Rozanski (1):
      sb_edac: Shut up compiler warning when EDAC_DEBUG is enabled

Ashutosh Dixit (4):
      misc: mic: Bug fix for sysfs poll usage.
      misc: mic: Fix user space namespace pollution from mic_common.h.
      misc: mic: Fix endianness issues.
      misc: mic: Suppress memory space sparse warnings

Axel Lin (2):
      regulator: pfuze100: Fix address of FABID
      include/linux/kernel.h: make might_fault() a nop for !MMU

Ben Hutchings (4):
      HID: kye: Fix missing break in kye_report_fixup()
      sfc: Add length checks to efx_xmit_with_hwtstamp() and efx_ptp_is_ptp_tx()
      sfc: Rate-limit log message for PTP packets without a matching
timestamp event
      sfc: Maintain current frequency adjustment when applying a time offset

Ben Skeggs (3):
      drm/nv04-nv30/clk: provide an empty domain list
      drm/nouveau: unreference fence after syncing
      drm/nouveau/sw: fix oops if gpu has its display block disabled

Bjorn Helgaas (2):
      Revert "workqueue: allow work_on_cpu() to be called recursively"
      MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI host maintainers

Bob Copeland (1):
      Revert "mac80211: allow disable power save in mesh"

Borislav Petkov (1):
      brcmsmac: Fix build dep on LEDS_CLASS

Brian Carnes (1):
      hwmon: (w83l786ng) Fix fan speed control mode setting and reporting

Carolyn Wyborny (1):
      igb: Fix for issue where values could be too high for udelay function.

Catalin Marinas (1):
      arm64: Fix memory shareability attribute for ioremap_wc/cache

Cedric Le Goater (2):
      offb: Little endian fixes
      offb: Add palette hack for little endian

Changli Gao (1):
      net: drop_monitor: fix the value of maxattr

Charles Keepax (1):
      extcon: arizona: Get pdata from arizona structure not device

Chris Wilson (3):
      drm/i915: Prefer setting PTE cache age to 3
      drm/i915: Pin relocations for the duration of constructing the execbuffer
      drm/i915: Pin pages whilst allocating for dma-buf vmap()

Christian Engelmayer (1):
      Input: usbtouchscreen - separate report and transmit buffer size handling

Christian König (2):
      drm/radeon: add VMID allocation trace point
      drm/radeon: add radeon_vm_bo_update trace point

Chun-Yeow Yeoh (1):
      mac80211: fix the mesh channel switch support

Colin Leitner (4):
      USB: spcp8x5: correct handling of CS5 setting
      USB: mos7840: correct handling of CS5 setting
      USB: ftdi_sio: fixed handling of unsupported CSIZE setting
      USB: pl2303: fixed handling of CS5 setting

Courtney Cavin (1):
      regmap: make sure we unlock on failure in regmap_bulk_write

Dan Carpenter (7):
      [media] cx231xx: use after free on error path in probe
      drm/tegra: return -EFAULT if copy_from_user() fails
      drm/nv50/disp: min/max are reversed in nv50_crtc_gamma_set()
      [media] af9035: unlock on error in af9035_i2c_master_xfer()
      xfs: underflow bug in xfs_attrlist_by_handle()
      hwmon: Prevent some divide by zeros in FAN_TO_REG()
      Btrfs: fix access_ok() check in btrfs_ioctl_send()

Dan Williams (1):
      dma: fix build breakage in s3c24xx-dma

Daniel Borkmann (1):
      packet: fix send path when running with proto == 0

Daniel Mack (1):
      usb: ohci-pxa27x: include linux/dma-mapping.h

Dave Airlie (1):
      drm/radeon: fix VGT_GS_INSTANCE_CNT register

Dave Chinner (1):
      xfs: growfs overruns AGFL buffer on V4 filesystems

Dave Jones (1):
      netfilter: ipset: fix incorret comparison in hash_netnet4_data_equal()

David Cluytens (1):
      USB: cdc-acm: Added support for the Lenovo RD02-D400 USB Modem

David Henningsson (1):
      ALSA: hda - Remove quirk for Dell Vostro 131

David Howells (4):
      KEYS: Pre-clear struct key on allocation
      KEYS: Fix the keyring hash function
      KEYS: Fix multiple key add into associative array
      KEYS: Fix searching of nested keyrings

David Laight (1):
      usb: xhci: Link TRB must not occur within a USB payload burst

David S. Miller (3):
      Revert "net: Handle CHECKSUM_COMPLETE more adequately in
pskb_trim_rcsum()."
      net: Revert macvtap/tun truncation signalling changes.
      Revert "8390 : Replace ei_debug with msg_enable/NETIF_MSG_* feature"

David Sterba (1):
      btrfs: call mnt_drop_write after interrupted subvol deletion

Dmitry Eremin-Solenikov (1):
      ARM: pxa: tosa: fix keys mapping

Dmitry Torokhov (2):
      Input: sur40 - suppress false uninitialized variable warning
      Input: serio - fix sysfs layout

Duan Jiong (1):
      ipv6: judge the accept_ra_defrtr before calling rt6_route_rcv

Eliad Peller (1):
      mac80211: fix connection polling

Elie De Brauwer (1):
      i2c: mux: Inherit retry count and timeout from parent for muxed bus

Emmanuel Grumbach (5):
      iwlwifi: pcie: fix interrupt coalescing for 7260 / 3160
      iwlwifi: mvm: BT Coex - don't enable MULTI_PRIO_LUT
      iwlwifi: mvm: BT Coex fix another NULL pointer dereference
      iwlwifi: mvm: don't WARN about unsuccessful time event
      iwlwifi: bump required firmware API version for 3160/7260

Eric Dumazet (4):
      net: do not pretend FRAGLIST support
      udp: ipv4: fix an use after free in __udp4_lib_rcv()
      udp: ipv4: fix potential use after free in udp_v4_early_demux()
      udp: ipv4: must add synchronization in udp_sk_rx_dst_set()

Eric Paris (1):
      security: shmem: implement kernel private shmem inodes

Eric W. Biederman (1):
      tcp_memcontrol: Cleanup/fix cg_proto->memory_pressure handling.

Eunbong Song (1):
      avr32: Kill CONFIG_MTD_PARTITIONS

Evgeny Plehov (1):
      [media] cxd2820r_c: fix if_ctl calculation

Ezequiel Garcia (3):
      net: mvneta: Fix incorrect DMA unmapping size
      Partially revert "mtd: nand: pxa3xx: Introduce
'marvell,armada370-nand' compatible string"
      mtd: nand: pxa3xx: Use info->use_dma to release DMA resources

Fabio Estevam (1):
      i2c: imx: Check the return value from clk_prepare_enable()

Fan Du (1):
      vxlan: release rt when found circular route

Fangxiaozhi (Franko) (1):
      USB: option: support new huawei devices

Felipe Balbi (4):
      usb: phy: generic: fix how we find out about our resources
      usb: gadget: storage: fix sparse warning
      usb: gadget: ffs: fix sparse warning
      usb: gadget: tcm_usb_gadget: mark bot_cleanup_old_alt static

Felipe Pena (1):
      [media] technisat-usb2: fix typo in variable name

Felix Fietkau (3):
      mac80211: fix crash when using AP VLAN interfaces
      cfg80211: ignore supported rates for nonexistant bands on scan
      ath9k: fix duration calculation for non-aggregated packets

Fengguang Wu (1):
      usb: gadget: zero: module parameters can be static

Filipe David Borba Manana (1):
      Btrfs: don't miss skinny extent items on delayed ref head contention

Florent Fourcot (1):
      ipv6: do not erase dst address with flow label destination

François-Xavier Le Bail (1):
      ipv6: fix third arg of anycast_dst_alloc(), must be bool.

Geert Uytterhoeven (3):
      mfd: ti-ssp: Fix build
      [media] radio-shark: Mark shark_resume_leds() inline to kill
compiler warning
      drivers/rtc/rtc-s5m.c: fix info->rtc assignment

Georg Kaindl (1):
      [media] usbtv: Add support for PAL video source

George Cherian (1):
      usb: gadget: f_mass_storage: call try_to_freeze only when its safe

Gerhard Sittig (2):
      regmap: trivial comment fix (copy'n'paste error)
      powerpc/512x: dts: remove misplaced IRQ spec from 'soc' node

Geyslan G. Bem (2):
      selinux: fix possible memory leak
      [media] videobuf2-dma-sg: fix possible memory leak

Gleb Natapov (1):
      KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376)

Greg Kroah-Hartman (1):
      USB: switch maintainership of chipidea to Peter

Guenter Roeck (3):
      drm/radeon/dpm: Convert to use devm_hwmon_register_with_groups
      watchdog: Drop unnecessary include of miscdevice.h
      hwmon: (lm90) Unregister hwmon device if interrupt setup fails

Gustavo Zacarias (1):
      USB: serial: option: blacklist interface 1 for Huawei E173s-6

H. Peter Anvin (2):
      x86, build: Pass in additional -mno-mmx, -mno-sse options
      x86, build, icc: Remove uninitialized_var() from compiler-intel.h

Hannes Frederic Sowa (2):
      net: clear local_df when passing skb between namespaces
      ipv6: don't count addrconf generated routes against gc limit

Hans Verkuil (4):
      [media] bttv: don't setup the controls if there are no video devices
      [media] tef6862/radio-tea5764: actually assign clamp result
      [media] wm8775: fix broken audio routing
      [media] vb2: regression fix: always set length field.

Hans de Goede (2):
      [media] gspca_sunplus: Add new usb-id for 06d6:0041
      [media] radio-shark2: Mark shark_resume_leds() inline to kill
compiler warning

Hariprasad Shenai (3):
      cxgb4: Much cleaner implementation of is_t4()/is_t5()
      cxgb4vf: added much cleaner implementation of is_t4()
      cxgb4: Add new scheme to update T4/T5 firmware

Heikki Krogerus (1):
      usb: phy: generic: fix a compiler warning

Heiko Carstens (2):
      s390/smp,sclp: fix size of sclp_cpu_info structure
      s390/vdso: fix access-list entry initialization

Hendrik Brueckner (2):
      s390/sclp: replace uninitialized early_event_mask_sccb variable
with sccb_early
      KEYS: correct alignment of system_certificate_list content in
assembly file

Hong H. Pham (1):
      powerpc: Fix PTE page address mismatch in pgtable ctor/dtor

Huang Rui (1):
      usb: tools: fix a regression issue that gcc can't link to pthread

Hui Wang (3):
      ALSA: hda - A Dell headset detection quirk
      ALSA: hda - Another Dell headset detection quirk
      ALSA: hda - One more Dell headset detection quirk

Ilia Mirkin (4):
      drm/nv10/plane: fix format computation
      drm/nv10/plane: add downscaling restrictions
      drm/nv10/plane: some chipsets don't support NV12
      powerpc/44x: Fix ocm_block allocation

Inki Dae (1):
      drm/exynos: release unhandled page flip events at postclose.

Ivan Vecera (1):
      forcedeth: run loopback test only on chipsets that support it

Ivaylo Dimitrov (1):
      Staging: TIDSPBRIDGE: Use vm_iomap_memory for mmap-ing instead
of remap_pfn_range

Jamal Hadi Salim (5):
      net_sched: Fail if missing mandatory action operation methods
      net_sched: Default action lookup method for actions
      net_sched: Use default action lookup functions
      net_sched: Provide default walker function for actions
      net_sched: Use default action walker methods

James Ralston (1):
      mfd: lpc_ich: Fix Wildcat Point info name field

Jan Beulich (1):
      procfs: also fix proc_reg_get_unmapped_area() for !MMU case

Jani Nikula (1):
      drm/i915/ddi: set sink to power down mode on dp disable

Janusz Dziedzic (1):
      mac80211: DFS setup chandef for radar_event correctly

Jason Gunthorpe (1):
      PCI: mvebu: Return 'unsupported' for Interrupt Line and Interrupt Pin

Jason Wang (4):
      tun: unbreak truncated packet signalling
      macvtap: signal truncated packets
      tun: unbreak truncated packet signalling
      macvtap: signal truncated packets

Javier Lopez (1):
      mac80211: fix for mesh beacon update on powersave

Jean Delvare (1):
      hwmon: (w83l768ng) Fix fan speed control range

Jeff Kirsher (1):
      MAINTAINERS: Update Intel Wired Ethernet LAN Maintainers

Jeff Layton (1):
      nfsd: when reusing an existing repcache entry, unhash it first

Jesse Barnes (2):
      drm/i915: take mode config lock around crtc disable at suspend
      drm/i915: use crtc_htotal in watermark calculations to match fastboot v2

Jesse Brandeburg (1):
      i40e: fix null dereference

Jie Liu (1):
      xfs: don't perform discard if the given range length is less
than block size

Jiri Pirko (1):
      br: fix use of ->rx_handler_data in code executed on non-rx_handler path

Jisheng Zhang (1):
      usb: phy: phy-mxs-usb: set the correct platform drvdata

Jitendra Kalsaria (3):
      qlge: Fix ethtool statistics
      qlge: Allow enable/disable rx/tx vlan acceleration independently
      qlge: Update version to 1.00.00.34

Joe Thornber (7):
      dm thin: switch to read only mode if a mapping insert fails
      dm thin: always fallback the pool mode if commit fails
      dm thin: re-establish read-only state when switching to fail mode
      dm thin: allow pool in read-only mode to transition to read-write mode
      dm cache policy mq: fix promotions to occur as expected
      dm space map: disallow decrementing a reference count below zero
      dm array: fix a reference counting bug in shadow_ablock

Johan Hovold (2):
      USB: serial: fix race in generic write
      USB: serial: fix write memory-allocation flag

Johannes Berg (7):
      mac80211: fix scheduled scan rtnl deadlock
      nl80211: check nla_put_* return values
      nl80211: fix error path in nl80211_get_key()
      nl80211: check nla_nest_start() return value
      cfg80211: disable 5/10 MHz support for all drivers
      mac80211: don't attempt to reorder multicast frames
      iwlwifi: mvm: check sta_id/drain values in debugfs

Johannes Weiner (3):
      mm: memcg: do not declare OOM from __GFP_NOFAIL allocations
      mm: memcg: fix race condition between memcg teardown and swapin
      mm: memcg: do not allow task about to OOM kill to bypass the limit

Jon Medhurst (1):
      ARM: 7917/1: cacheflush: correctly limit range of memory region
being flushed

Jon Paul Maloy (1):
      tipc: correct the order of stopping services at rmmod

Jonathan McCrohan (1):
      [media] media_tree: Fix spelling errors

José Miguel Gonçalves (1):
      hwmon: HIH-6130: Support I2C bus drivers without I2C_FUNC_SMBUS_QUICK

Jouni Malinen (2):
      mac80211_hwsim: Fix radiotap header for ACK frames
      mac80211_hwsim: Fix bcn_en_iter to use atomic iteration

Julius Werner (1):
      usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED

Kamala R (1):
      IPv6: Fixed support for blackhole and prohibit routes

Karl Beldan (3):
      mac80211: minstrel_ht: fix rates selection
      mac80211: use capped prob when computing throughputs
      mac80211: set hw initial idle state

Khalid Aziz (1):
      PCI: Disable Bus Master only on kexec reboot

Kirill A. Shutemov (1):
      thp: move preallocated PTE page table on move_huge_pmd()

Konstantin Khlebnikov (2):
      ARM: 7912/1: check stack pointer in get_wchan
      ARM: 7913/1: fix framepointer check in unwind_frame

Krzysztof Kozlowski (4):
      rtc: s5m: fix unsuccesful IRQ request during probe
      rtc: s5m: limit endless loop waiting for register update
      rtc: s5m: enable IRQ wake during suspend
      mfd/rtc: s5m: fix register updating by adding regmap for RTC

Kuninori Morimoto (3):
      rcar-hpbdma: add max transfer size
      rcar-hpbdma: fixup channel busy check for double plane
      rcar-hpbdma: initialise plane information when halted

Lad, Prabhakar (2):
      gpio: davinci: fix check for unbanked gpio
      ARM: davinci: fix number of resources passed to davinci_gpio_register()

Laurence Evans (1):
      sfc: PTP: Moderate log message on event queue overflow

Laurent Pinchart (1):
      [media] v4l: omap3isp: Don't check for missing get_fmt op on remote subdev

Libin Yang (2):
      [media] marvell-ccic: drop resource free in driver remove
      [media] media: marvell-ccic: use devm to release clk

Linus Pizunski (1):
      drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap

Linus Torvalds (4):
      futex: fix handling of read-only-mapped hugepages
      futex: move user address verification up to common code
      Revert "selinux: consider filesystem subtype in policies"
      Linux 3.13-rc4

Linus Walleij (1):
      usb: gadget: fix pxa25x compilation problems

Lorenzo Pieralisi (1):
      arm64: kernel: add code to set cpu boot mode to secondary_entry shim

Luciano Coelho (2):
      iwlwifi: mvm: set seqno also when no keys are set
      iwlwifi: mvm: use a cast to calculate the last seqno from the next one

Maarten Lankhorst (1):
      drm/nouveau/kms: send timestamp data for correct head in flip
completion events

Mahesh Salgaonkar (1):
      powerpc: Fix up the kdump base cap to 128M

Mark Brown (2):
      regulator: core: Replace checks of have_full_constraints with a function
      regulator: core: Check for DT every time we check full constraints

Mark Rutland (1):
      arm64: ensure completion of TLB invalidatation

Martin Schwidefsky (2):
      s390/vdso: ectg gettime support for CLOCK_THREAD_CPUTIME_ID
      s390/time,vdso: fix clock_gettime for CLOCK_MONOTONIC

Matias Bjorling (1):
      null_blk: mem garbage on NUMA systems during init

Matt Walker (1):
      Input: elantech - add support for newer (August 2013) devices

Matthew Garrett (1):
      x86, efi: Don't use (U)EFI time services on 32 bit

Matthew Whitehead (1):
      8390 : Replace ei_debug with msg_enable/NETIF_MSG_* feature

Matthias Brugger (2):
      avr32: pm: Fix section mismatch
      cpufreq_ at32ap-cpufreq.c: Fix section mismatch

Maxime Ripard (3):
      net: allwinner: emac: Add missing free_irq
      ARM: sun7i: dt: Fix interrupt trigger types
      ARM: sun6i: dt: Fix interrupt trigger types

Miao Xie (1):
      Btrfs: don't clear the default compression type

Michael Dalton (1):
      virtio-net: free bufs correctly on invalid packet length

Michael Ellerman (1):
      powerpc: Fix build break with PPC_EARLY_DEBUG_BOOTX=y

Michael Grzeschik (1):
      usb: gadget: composite: reset delayed_status on reset_config

Michael Hennerich (1):
      Input: adxl34x - Fix bug in definition of ADXL346_2D_ORIENT

Michael Krufky (1):
      [media] dvb_demux: clean up whitespace in comments from previous
patch (trivial)

Michael Opdenacker (1):
      avr32: remove deprecated IRQF_DISABLED

Michal Kalderon (1):
      bnx2x: avoid null pointer dereference when enabling SR-IOV

Michal Marek (2):
      PCI: Omit PCI ID macro strings to shorten quirk names
      mfd: Make MFD_AS3722 depend on I2C=y

Michal Nazarewicz (3):
      usb: phy: remove dead code
      net: wireless: ath9k: avoid possible NULL pointer dereference
      net: wireless: wcn36xx: fix potential NULL pointer dereference

Mike Snitzer (3):
      dm space map metadata: return on failure in sm_metadata_new_block
      dm thin: switch to read-only mode if metadata space is exhausted
      dm cache: update Documentation for invalidate_cblocks's range syntax

Mikulas Patocka (6):
      dm delay: fix a possible deadlock due to shared workqueue
      ALSA: usb-audio: fix uninitialized variable compile warning
      dm snapshot: avoid snapshot space leak on crash
      dm table: fail dm_table_create on dm_round_up overflow
      dm bufio: initialize read-only module parameters
      dm stats: initialize read-only module parameter

Mugunthan V N (2):
      drivers: net: cpsw: fix dt probe for one port ethernet
      drivers: net: cpsw: fix for cpsw crash when build as modules

Naoya Horiguchi (1):
      include/linux/hugetlb.h: make isolate_huge_page() an inline

Nat Gurumoorthy (1):
      tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0

Neil Horman (1):
      sctp: properly latch and use autoclose value from sock to association

Nikolay Aleksandrov (1):
      bonding: fix packets_per_slave showing

Nishanth Menon (3):
      ARM: OMAP2+: Fix the machine entry for am3517
      ARM: OMAP2+: hwmod: Fix usage of invalid iclk / oclk when clock
node is not present
      ARM: OMAP2+: omap_device: add fail hook for runtime_pm when bad
data is detected

Oleksij Rempel (1):
      ALSA: hda - fix mic issues on Acer Aspire E-572

Olof Johansson (2):
      gpu: host1x: Silence a few warnings with LPAE=y
      powerpc/pasemi: Turn on devtmpfs in defconfig

Ondrej Zary (1):
      [media] gspca-stk1135: Add delay after configuring clock

Oren Givon (1):
      iwlwifi: add new HW - 7265 series

Pablo Neira Ayuso (1):
      netfilter: nf_tables: fix missing rules flushing per table

Pali Rohár (1):
      Input: add key code for ambient light sensor button

Paul Durrant (6):
      xen-netback: clear vif->task on disconnect
      xen-netback: fix fragment detection in checksum setup
      xen-netback: make sure skb linear area covers checksum field
      xen-netback: napi: fix abuse of budget
      xen-netback: napi: don't prematurely request a tx event
      xen-netback: fix gso_prefix check

Paul Moore (4):
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute()
      selinux: look for IPsec labels on both inbound and outbound packets
      selinux: process labeled IPsec TCP SYN-ACK packets properly in
selinux_ip_postroute()

Paul Walmsley (1):
      avr32: favr-32: clk_round_rate() can return a zero upon error

Paulo Zanoni (1):
      drm/i915: use the correct force_wake function at the PC8 code

Peter Hurley (1):
      n_tty: Fix missing newline echo

Peter Ujfalusi (1):
      ARM: davinci: Fix McASP mem resource names

Philipp Zabel (1):
      [media] videobuf2: Add support for file access mode flags for
DMABUF exporting

Philippe De Muyter (1):
      net:fec: remove duplicate lines in comment about errata ERR006358

Ping Cheng (1):
      Input: add SW_MUTE_DEVICE switch definition

Pratyush Anand (1):
      usb: gadget: mass storage: fix return of delayed status

Rafael J. Wysocki (4):
      PCI: Move device_del() from pci_stop_dev() to pci_destroy_dev()
      PCI / tg3: Give up chip reset and carrier loss handling if PCI
device is not present
      Revert "cpufreq: suspend governors on system suspend/hibernate"
      Revert "cpufreq: fix garbage kobjects on errors during suspend/resume"

Ricardo Ribalda (2):
      [media] em28xx-video: Swap release order to avoid lock nesting
      [media] ths7303: Declare as static a private function

Rob Clark (1):
      udl: fix issue with imported prime buffers

Rob Herring (2):
      ARM: highbank: handle soft poweroff and reset key events
      arm64: make default NR_CPUS 8

Robert Baldyga (2):
      usb: gadget: s3c-hsotg: fix spinlock locking
      usb: gadget: s3c-hsotg: fix disconnect handling

Robert Stonehouse (2):
      sfc: Refactor efx_mcdi_poll() by introducing efx_mcdi_poll_once()
      sfc: Poll for MCDI completion once before timeout occurs

Roger Quadros (3):
      ARM: OMAP4+: hwmod data: Don't prevent RESET of USB Host module
      ARM: OMAP2+: hwmod: Fix SOFTRESET logic
      ARM: OMAP3: hwmod data: Don't prevent RESET of USB Host module

Roy Spliet (2):
      drm/nouveau/fifo: Hook up pause and resume for NV50 and NV84+
      drm/nouveau/clk: Add support for NVAA/NVAC

Russell King (2):
      ARM: another fix for the DMA mapping checks
      ARM: fix asm/memory.h build error

Russell King - ARM Linux (2):
      Fix build failure for gp2ap020a00f.c
      Fix pl08x warnings

Rusty Russell (1):
      Ignore generated file kernel/x509_certificate_list

Sachin Kamat (3):
      dmaengine: s3c24xx-dma: use DMA_COMPLETE for dma completion status
      drm/exynos: Fix trivial typo in exynos_drm_fimd.c
      [media] mt9p031: Include linux/of.h header

Santosh Shilimkar (2):
      ARM: 7908/1: mm: Fix the arm_dma_limit calculation
      ARM: 7909/1: mm: Call setup_dma_zone() post early_paging_init()

Sasha Levin (1):
      net: unix: allow set_peek_off to fail

Sebastian Andrzej Siewior (3):
      usb: musb: musb_cppi41: factor most of cppi41_dma_callback()
into cppi41_trans_done()
      usb: musb: musb_cppi41: handle pre-mature TX complete interrupt
      usb: musb: only cancel work if it is initialized

Sebastian Reichel (1):
      MAINTAINERS: add HSI subsystem

Sebastian Siewior (2):
      net: fec_main: dma_map() only the length of the skb
      net: make neigh_priv_len in struct net_device 16bit instead of 8bit

Sergei Ianovich (1):
      ARM: pxa: prevent PXA270 occasional reboot freezes

Sergei Shtylyov (1):
      micrel: add support for KSZ8041RNLI

Sergey Popovich (1):
      netfilter: xt_hashlimit: fix proc entry leak in netns destroy path

Sergey Senozhatsky (1):
      radeon_pm: fix oops in hwmon_attributes_visible() and
radeon_hwmon_show_temp_thresh()

Shawn Guo (1):
      MAINTAINERS: merge IMX6 entry into IMX

Simon Wunderlich (3):
      cfg80211: fix ibss wext chandef creation
      cfg80211: disable CSA for all drivers
      mac80211: check csa wiphy flag in ibss before switching

Somnath Kotur (2):
      be2net: Fix Lancer error recovery to distinguish FW download
      be2net: Free/delete pmacs (in be_clear()) only if they exist

Srikanth Thokala (2):
      net: emaclite: Remove unnecessary code that enables/disables
interrupts on PONG buffers
      net: emaclite: add barriers to support Xilinx Zynq platform

Srinivas Pandruvada (3):
      HID: hid-sensor-hub: Add logical min and max
      iio: hid-sensors: Fix power and report state
      HID: hid-sensor-hub: fix duplicate sysfs entry error

Stefan Tomanek (1):
      inet: fix NULL pointer Oops in fib(6)_rule_suppress

Stefan Weinhuber (1):
      s390/dasd: fix memory leak caused by dangling references to request_queue

Stefano Panella (1):
      ALSA: memalloc.h - fix wrong truncation of dma_addr_t

Stephen Warren (2):
      regmap: use IS_ERR() to check clk_get() results
      ARM: tegra: add missing break to fuse initialization code

Steve Capper (1):
      arm64: mm: Fix PMD_SECT_PROT_NONE definition

Sudeep Dutt (2):
      misc: mic: Change mic_notify(...) to return true.
      misc: mic: Minor bug fix in 'retry' loops.

Sujith Manoharan (2):
      ath9k: Fix QuickDrop usage
      ath9k: Fix XLNA bias strength

Takashi Iwai (3):
      ALSA: compress: Fix 64bit ABI incompatibility
      ALSA: hda - Mute all aamix inputs as default
      ALSA: hda - Add static DAC/pin mapping for AD1986A codec

Thadeu Lima de Souza Cascardo (1):
      powernv: Fix VFIO support with PHB3

Thierry Reding (6):
      drm/tegra: Make CRTC upcasting safer
      drm/tegra: Tightly bind RGB output to DC
      drm/tegra: Fix address space mismatches
      drm/tegra: Make tegra_drm_driver static
      drm/tegra: Force cast to __iomem to make sparse happy
      gpu: host1x: Fix a few sparse warnings

Thomas Hellstrom (4):
      drm/vmwgfx: Correctly set the enabled state on crtcs
      drm/vmwgfx: Fix up and comment the dumb buffer implementation
      drm/vmwgfx: Fix dma buffer memory size accounting
      drm/vmwgfx: Add our connectors to sysfs

Thomas Pugliese (3):
      usb: wusbcore: send keepalives to unauthenticated devices
      usb: wusbcore: do device lookup while holding the hc mutex
      usb: wusbcore: fix deadlock in wusbhc_gtk_rekey

Thomas Wood (2):
      drm/edid: fix length check when adding extra 3D modes
      drm: fix the addition of the side-by-side (half) flag for extra 3D modes

Tim Harvey (1):
      regulator: pfuze100: allow misprogrammed ID

Tom Lendacky (1):
      crypto: scatterwalk - Use sg_chain_ptr on chain entries

Tomas Winkler (1):
      mei: add 9 series PCH mei device ids

Tony Lindgren (5):
      net: davinci_emac: Fix platform data handling and make usable for am3517
      ARM: OMAP2+: Fix overwriting hwmod data with data from device tree
      ARM: dts: Fix missing entries for am3517
      ARM: dts: Fix booting for secure omaps
      net: smc91x: Fix device tree based configuration so it's usable

Ujjal Roy (1):
      mwifiex: fix memory leak issue for ibss join

Valentine Barshak (1):
      usb: phy: phy-rcar-gen2-usb: fix phy initialization

Venkat Venkatsubra (1):
      rds: prevent BUG_ON triggered on congestion update to loopback

Ville Syrjälä (5):
      drm/i915: Check VBT for eDP ports on VLV
      drm/i915: Simplify DP vs. eDP detection
      drm/i915: Fix pipe CSC post offset calculation
      drm/i915: Make the DERRMR SRM target global GTT
      drm/i915: MI_PREDICATE_RESULT_2 is HSW only

Vince Hsu (1):
      regulator: as3722: set the correct current limit

Vincent Pelletier (1):
      dm cache: actually resize cache

Vineet Gupta (3):
      ARC: extable: Enable sorting at build time
      ARC: Add guard macro to uapi/asm/unistd.h
      ARC: [perf] Fix a few thinkos

Wang Shilong (3):
      Btrfs: fix an oops when doing balance relocation
      Btrfs: skip building backref tree for uuid and quota tree when
doing balance relocation
      Btrfs: make sure we cleanup all reloc roots if error happens

Wang, Xiaoming (1):
      extcon: remove freed groups caused the panic or warning in unregister flow

Wei Yang (1):
      net/mlx4_core: destroy workqueue when driver fails to register

Wei Yongjun (5):
      usb: phy: phy-generic: fix return value check in usb_nop_xceiv_register()
      dma: mmp_pdma: add missing platform_set_drvdata() in mmp_pdma_probe()
      [media] v4l: vsp1: Fix error return code in vsp1_video_init()
      [media] saa7164: fix return value check in saa7164_initdev()
      iommu/arm-smmu: fix error return code in arm_smmu_device_dt_probe()

Will Deacon (4):
      iommu/arm-smmu: use mutex instead of spinlock for locking page tables
      iommu/arm-smmu: remove potential NULL dereference on mapping path
      dcache: allow word-at-a-time name hashing with big-endian CPUs
      word-at-a-time: provide generic big-endian zero_bytemask implementation

Xose Vazquez Perez (1):
      s390: increase CONFIG_NR_CPUS limit

Yang Yingliang (3):
      net: sched: tbf: fix the calculation of max_size
      net: sched: htb: fix the calculation of quantum
      sch_tbf: use do_div() for 64-bit divide

Ying Xue (1):
      tipc: protect handler_enabled variable with qitem_lock spin lock

Yunkang Tang (1):
      Input: ALPS - add support for DualPoint device on Dell XT2 model

Zhi Yong Wu (2):
      macvtap: update file current position
      tun: update file current position

cpw (1):
      x86/UV: Fix NULL pointer dereference in uv_flush_tlb_others() if
the 'nobau' boot option is used

dingtianhong (1):
      bonding: add arp_ip_target checks when install the module

wangweidong (4):
      sctp: disable max_burst when the max_burst is 0
      sctp: check the rto_min and rto_max in setsockopt
      sctp: add check rto_min and rto_max in sysctl
      sctp: fix up a spacing
