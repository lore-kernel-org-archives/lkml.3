Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3CXAls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 20:41:48 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:56321 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3CXAlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 20:41:46 -0400
MIME-Version: 1.0
Date: Sat, 23 Mar 2013 17:41:45 -0700
X-Google-Sender-Auth: _h9RlhGFf4LKFGjpYPL1f2zqEa8
Message-ID: <CA+55aFwJ9bKT8eWafOzSUCkJ2db-+bpxq6ZOmQcOaLpSZ9UqvQ@mail.gmail.com>
Subject: Linux 3.9-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc. And things haven't calmed down, meaning
that the nice small and calm -rc2 was definitely the outlier so far.
But I'm optimistic, dammit, and I'm going to keep hoping that things
will change, and the upcoming week will be boring and devoid of any
real work what-so-ever.

It had better be, because it's spring break and the kids are around.

Anyway.

While it hasn't been as calm as I'd like things to be, it's not like
things have been hugely exciting either.  Most of this really is
pretty trivial. It's all over, with the bulk in drivers (drm, md, net,
mtd, usb, sound), but also some arch updates (powerpc, arm, sparc,
x86) and filesystem work (cifs, ext4).

Go out and test,

                  Linus

---
Aaron Lu (1):
      [libata] Avoid specialized TLA's in ZPODD's Kconfig

Alan Stern (4):
      USB: EHCI: fix regression during bus resume
      usb: gadget: udc-core: fix a regression during gadget driver unbinding
      USB: gadget: net2280: remove leftover driver->unbind call in error pathway
      USB: EHCI: fix regression in QH unlinking

Alex Deucher (6):
      drm/radeon: fix S/R on VM systems (cayman/TN/SI)
      drm/radeon: fix backend map setup on 1 RB trinity boards
      drm/radeon/benchmark: make sure bo blit copy exists before using it
      drm/radeon/benchmark: allow same domains for dma copy
      drm/radeon: add support for Richland APUs
      drm/radeon: add Richland pci ids

Alexander Duyck (2):
      dma-debug: fix locking bug in check_unmap()
      dma-debug: update DMA debug API to better handle multiple
mappings of a buffer

Alexey Khoroshilov (1):
      usb: cdc-acm: fix error handling in acm_probe()

Allen Pais (1):
      sparc64: correctly recognize SPARC64-X chips

Ananth N Mavinakayanahalli (1):
      perf probe: Fix segfault

Andreas Schwab (1):
      arm64: fix padding computation in struct ucontext

Andrew Brownfield (1):
      ata_piix: Add MODULE_PARM_DESC to prefer_ms_hyperv

Andrzej Pietrasiewicz (1):
      usb: gadget: ffs: fix enable multiple instances

Andy Grover (1):
      target/iscsi: Fix mutual CHAP auth on big-endian arches

Andy Honig (3):
      KVM: x86: fix for buffer overflow in handling of
MSR_KVM_SYSTEM_TIME (CVE-2013-1796)
      KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use gfn_to_hva_cache
functions (CVE-2013-1797)
      KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)

Aneesh Kumar K.V (3):
      powerpc: Make VSID_BITS* dependency explicit
      powerpc: Update kernel VSID range
      powerpc: Rename USER_ESID_BITS* to ESID_BITS*

Anton Blanchard (1):
      powerpc: Fix -mcmodel=medium breakage in prom_init.c

Arnd Bergmann (7):
      clk: vt8500: Fix "fix device clock divisor calculations"
      [media] s5p-fimc: fix s5pv210 build
      input/joystick: use get_cycles on ARM
      vfio: include <linux/slab.h> for kmalloc
      isdn: hisax: netjet requires VIRT_TO_BUS
      ethernet/tulip: DE4x5 needs VIRT_TO_BUS
      ARM: fix CONFIG_VIRT_TO_BUS handling

Ashish Jangam (1):
      drivers/rtc/rtc-da9052.c: fix for rtc device registration

Asias He (3):
      tcm_vhost: Add missed lock in vhost_scsi_clear_endpoint()
      tcm_vhost: Flush vhost_work in vhost_scsi_flush()
      target/pscsi: Reject cross page boundary case in pscsi_map_sg

Ben Collins (1):
      sgy-cts1000: Remove __dev* attributes

Ben Hutchings (1):
      sfc: Only use TX push if a single descriptor is to be written

Ben Skeggs (2):
      drm/nouveau/core: fix return value of nouveau_object_del()
      drm/nv50/kms: prevent lockdep false-positive in page flipping path

Benjamin Herrenschmidt (2):
      powerpc: Fix STAB initialization
      powerpc: Fix cputable entry for 970MP rev 1.0

Bing Zhao (1):
      mwifiex: fix potential out-of-boundary access to ibss rate table

Bjørn Mork (2):
      net: qmi_wwan: set correct altsetting for Gobi 1K devices
      net: cdc_ncm, cdc_mbim: allow user to prefer NCM for backwards
compatibility

Bo Shen (1):
      usb: gadget: u_serial: fix typo which cause build warning

Brian Foster (1):
      xfs: fix potential infinite loop in xfs_iomap_prealloc_size()

Brian Norris (1):
      mtd: nand: reintroduce NAND_NO_READRDY as NAND_NEED_READRDY

Catalin Marinas (2):
      arm64: Removed unused variable in compat_setup_rt_frame()
      arm64: Fix build error with !SMP

Chen Gang (1):
      ARM:net: an issue for k which is u32, never < 0

Cong Wang (2):
      openvswitch: fix the calculation of checksum for vlan header
      openvswitch: remove some useless comments

Dan Carpenter (1):
      selinux: use GFP_ATOMIC under spin_lock

Daniel Hellstrom (1):
      sparc,leon: fix GRPCI2 device0 PCI config space access

Daniel Mack (3):
      net: ethernet: cpsw: fix usage of cpdma_check_free_tx_desc()
      ALSA: snd-usb: mixer: propagate errors up the call chain
      ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()

Daniel Vetter (1):
      MAINTAINERS: intel-gfx is no longer subscribers-only

Dave Chinner (1):
      xfs: ensure we capture IO errors correctly

David Ward (1):
      net/ipv4: Ensure that location of timestamp option is stored

Denis V. Lunev (1):
      ipv4: fix definition of FIB_TABLE_HASHSZ

Devendra Naga (2):
      thermal: rcar_thermal: propagate return value of
thermal_zone_device_register
      thermal: exynos_thermal: return a proper error code while
thermal_zone_device_register fail.

Dmitry Artamonow (1):
      usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player

Dmitry Monakhov (6):
      ext4: ext4_split_extent should take care of extent zeroout
      ext4: disable merging of uninitialized extents
      ext4: add warning to ext4_convert_unwritten_extents_endio
      ext4: invalidate extent status tree during extent migration
      ext4: add self-testing infrastructure to do a sanity check
      ext4: fix memory leakage in mext_check_coverage

Dmitry Torokhov (1):
      USB: xhci - fix bit definitions for IMAN register

Eric Dumazet (2):
      tcp: fix skb_availroom()
      tcp: dont handle MTU reduction on LISTEN socket

Fabio Estevam (1):
      usb: ulpi: Define a *otg_ulpi_create no-op

Felipe Balbi (1):
      usb: gadget: net22xx: fix ->disconnect reporting

Frank Blaschka (1):
      qeth: Fix scatter-gather regression

Frederic Weisbecker (1):
      printk: Provide a wake_up_klogd() off-case

Georg Hofmann (1):
      net: fec: fix missing napi_disable call

Guenter Roeck (1):
      i2c: Fix my e-mail address in drivers and documentation

H Hartley Sweeten (1):
      drivers/video/ep93xx-fb.c: include <linux/io.h> for devm_ioremap()

Hannes Frederic Sowa (1):
      inet: limit length of fragment queue hash table bucket lists

Hannes Reinecke (2):
      USB: xhci: correctly enable interrupts
      target_core_sbc: use noop for SYNCHRONIZE_CACHE

Haojian Zhuang (1):
      ARM: mmp: add platform_device head file in gplugd

Heiko Carstens (3):
      s390/mm: fix vmemmap size calculation
      s390/mm: fix flush_tlb_kernel_range()
      drivers/i2c: remove !S390 dependency, add missing
GENERIC_HARDIRQS dependencies

Heinz Mauelshagen (2):
      dm cache: detect cache_create failure
      dm cache: avoid calling policy destructor twice on error

Hiroshi Doyu (1):
      ARM: 7675/1: amba: tegra-ahb: Fix build error w/ PM_SLEEP w/o PM_RUNTIME

Jack Mitchell (1):
      libtraceevent: Remove hard coded include to /usr/local/include in Makefile

James Hogan (1):
      irq_work.h: fix warning when CONFIG_IRQ_WORK=n

James Ralston (1):
      ahci: Add Device IDs for Intel Wellsburg PCH

Jan Kara (3):
      ext4: remove unnecessary wait for extent conversion in ext4_fallocate()
      ext4: fix WARN_ON from ext4_releasepage()
      jbd2: fix use after free in jbd2_journal_dirty_metadata()

Jean Delvare (3):
      MAINTAINERS: Remove Mark M. Hoffman
      hwmon: (lm75.h) Update header inclusion
      hwmon: (lm75) Fix tcn75 prefix

Jeff Layton (1):
      cifs: ignore everything in SPNEGO blob after mechTypes

Jianguo Wu (1):
      mm/hotplug: only free wait_table if it's allocated by vmalloc

Jingoo Han (1):
      pata_samsung_cf: use module_platform_driver_probe()

Jiri Kosina (1):
      drm/i915: stop using GMBUS IRQs on Gen4 chips

Jiri Olsa (1):
      perf record: Fix -C option

Joe Thornber (5):
      dm thin: fix discard corruption
      dm thin: fix non power of two discard granularity calc
      dm cache: avoid 64 bit division on 32 bit
      dm cache: metadata clear dirty bits on clean shutdown
      dm cache: fix race in writethrough implementation

Johan Hovold (23):
      atmel_lcdfb: fix 16-bpp modes on older SOCs
      ARM: at91: fix LCD-wiring mode
      USB: cdc-acm: fix device unregistration
      USB: garmin_gps: fix memory leak on disconnect
      USB: io_ti: fix get_icount for two port adapters
      USB: serial: fix interface refcounting
      USB: serial: add modem-status-change wait queue
      USB: ark3116: fix use-after-free in TIOCMIWAIT
      USB: ch341: fix use-after-free in TIOCMIWAIT
      USB: cypress_m8: fix use-after-free in TIOCMIWAIT
      USB: f81232: fix use-after-free in TIOCMIWAIT
      USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
      USB: io_edgeport: fix use-after-free in TIOCMIWAIT
      USB: io_ti: fix use-after-free in TIOCMIWAIT
      USB: mct_u232: fix use-after-free in TIOCMIWAIT
      USB: mos7840: fix broken TIOCMIWAIT
      USB: mos7840: fix use-after-free in TIOCMIWAIT
      USB: oti6858: fix use-after-free in TIOCMIWAIT
      USB: pl2303: fix use-after-free in TIOCMIWAIT
      USB: quatech2: fix use-after-free in TIOCMIWAIT
      USB: spcp8x5: fix use-after-free in TIOCMIWAIT
      USB: ssu100: fix use-after-free in TIOCMIWAIT
      USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT

John Crispin (1):
      rt2x00: fix rt2x00 to work with the new ralink SoC config symbols

Jonathan Brassow (2):
      MD RAID5: Avoid accessing gendisk or queue structs when not available
      MD: Prevent sysfs operations on uninitialized kobjects

Josh Boyer (1):
      Bluetooth: Add support for atheros 04ca:3004 device to ath3k

Julia Lemire (1):
      drm/mgag200: Bug fix: Modified pll algorithm for EH project

Kees Cook (2):
      drm/i915: restrict kernel address leak in debugfs
      drm/i915: bounds check execbuffer relocation count

Keith Busch (7):
      NVMe: Free cmdid on nvme_submit_bio error
      NVMe: End queued bio requests when freeing queue
      NVMe: Set result from user admin command
      NVMe: Add result to nvme_get_features
      NVMe: Define SMART log
      NVMe: Initialize iod nents to 0
      NVMe: Add namespaces with no LBA range feature

Kevin Hilman (1):
      KVM: allow host header to be included even for !CONFIG_KVM

Kishon Vijay Abraham I (1):
      usb: musb: gadget: do *unmap_dma_buffer* only for valid DMA addr

Lai Jiangshan (1):
      workqueue: fix possible pool stall bug in wq_unbind_fn()

Larry Finger (2):
      rtlwifi: rtl8192cu: Fix schedule while atomic bug splat
      rtlwifi: rtl8192cu: Fix problem that prevents reassociation

Laxman Dewangan (1):
      i2c: tegra: check the clk_prepare_enable() return value

Li RongQing (1):
      net/core: move vlan_depth out of while loop in skb_network_protocol()

Linus Torvalds (2):
      vfs,proc: guarantee unique inodes in /proc
      Linux 3.9-rc4

Lucas Stach (1):
      net: fec: restart the FEC when PHY speed changes

Ludovic Desroches (3):
      ARM: at91: add gpio suspend/resume support when using pinctrl
      ARM: at91: fix infinite loop in at91_irq_suspend/resume
      MAINTAINERS: add maintainer entry for atmel i2c driver

Lukas Czerner (5):
      ext4: remove unused variable in ext4_free_blocks()
      ext4: do not use yield()
      ext4: update reserved space after the 'correction'
      ext4: reserve metadata block for every delayed write
      ext4: use s_extent_max_zeroout_kb value as number of kb

Maciej Żenczykowski (1):
      bnx2x: fix occasional statistics off-by-4GB error

Marcelo Tosatti (2):
      KVM: x86: fix deadlock in clock-in-progress request handling
      Revert "KVM: allow host header to be included even for !CONFIG_KVM"

Marcin Slusarz (1):
      perf tools: check if -DFORTIFY_SOURCE=2 is allowed

Marek Lindner (1):
      batman-adv: verify tt len does not exceed packet len

Mark Tinguely (1):
      xfs: fix xfs_iomap_eof_prealloc_initial_size type

Martin Peres (11):
      drm/nv40/therm: improve selection between the old and the new style
      drm/nv40/therm: increase the sensor's settling delay to 20ms
      drm/nouveau/therm: do not make assumptions on temperature
      drm/nouveau/therm: remove some confusion introduced by therm_mode
      drm/nouveau/therm-ic: the temperature is off by sensor_constant,
warn the user
      drm/nv40/therm: disable temperature reading if the bios misses
some parameters
      drm/nv40/therm: reserve negative temperatures for errors
      drm/nouveau/therm: disable auto fan management if temperature is
not available
      drm/nouveau/therm: disable temperature management if the sensor
isn't readable
      drm/nouveau/therm: display the availability of the internal sensor
      drm/nouveau/hwmon: do not expose a buggy temperature if it is unavailable

Martin Schwidefsky (1):
      s390: critical section cleanup vs. machine checks

Masami Hiramatsu (2):
      kprobes: Make hash_64() as always inlined
      kprobes/x86: Check Interrupt Flag modifier when registering probe

Masanari Iida (1):
      ALSA: documentation: Fix typo in Documentation/sound

Mateusz Guzik (1):
      cifs: delay super block destruction until all cifsFileInfo
objects are gone

Matt Porter (1):
      ARM: davinci: edma: fix dmaengine induced null pointer
dereference on da830

Matthew Garrett (1):
      PCI: Use ROM images from firmware only if no other ROM source available

Matthew Wilcox (1):
      MAINTAINERS: Add entry for the NVMe driver

Mauro Carvalho Chehab (2):
      amd64_edac: Correct DIMM sizes
      EDAC: Merge mci.mem_is_per_rank with mci.csbased

Michael Ellerman (2):
      perf annotate: Fix build with NO_NEWT=1
      perf report: Fix build with NO_NEWT=1

Michael Holzheu (1):
      s390/kdump: Do not add standby memory for kdump

Michael Neuling (1):
      powerpc/ptrace: Fix brk.len used uninitialised

Michael S. Tsirkin (1):
      vhost/net: fix heads usage of ubuf_info

Michal Schmidt (1):
      bnx2x: add missing napi deletion in error path

Mike Snitzer (2):
      dm cache: policy change version from string to integer set
      dm cache: policy ignore hints if generated by different version

Mikhail Kshevetskiy (1):
      usb: musb: da8xx: Fix build breakage due to typo

Mikulas Patocka (1):
      dm verity: avoid deadlock

Mugunthan V N (1):
      drivers: net: ethernet: ti: davinci_emac: fix usage of
cpdma_check_free_tx_desc()

Namhyung Kim (2):
      perf: Reset hwc->last_period on sw clock events
      perf: Generate EXIT event only once per task context

NeilBrown (2):
      md/raid5: schedule_construction should abort if nothing to do.
      md/raid5: ensure sync and DISCARD don't happen at the same time.

Nicholas Bellinger (1):
      target/file: Bump FD_MAX_SECTORS to 2048 to handle 1M sized I/Os

Nicolas Ferre (1):
      drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR

Nicolas Pitre (1):
      ARM: 7670/1: fix the memset fix

Nithin Sujir (1):
      tg3: 5715 does not link up when autoneg off

Oleg Nesterov (1):
      poweroff: change orderly_poweroff() to use schedule_work()

Padmavathi Venna (1):
      ARM: EXYNOS: Add #dma-cells for generic dma binding support for PL330

Paul Bolle (7):
      powerpc: Remove last traces of POWER4_ONLY
      arm64: Do not select GENERIC_HARDIRQS_NO_DEPRECATED
      arm64: Kconfig.debug: Remove unused CONFIG_DEBUG_ERRORS
      sparc: delete "if !ULTRA_HAS_POPULATION_COUNT"
      sparc: remove unused "config BITS"
      md: remove CONFIG_MULTICORE_RAID456 entirely
      usb: gadget: net2272: finally convert "CONFIG_USB_GADGET_NET2272_DMA"

Pavel Emelyanov (1):
      skb: Propagate pfmemalloc on skb from head page only

Rafał Miłecki (2):
      Revert "mtd: bcm47xxpart: improve probing of nvram partition"
      mtd: bcm47xxpart: look for NVRAM at the end of device

Rich Lane (4):
      openvswitch: Fix ovs_vport_cmd_del return value on success
      openvswitch: Fix ovs_vport_cmd_new return value on success
      openvswitch: Call genlmsg_end in queue_userspace_packet
      openvswitch: Fix parsing invalid LLC/SNAP ethertypes

Richard Genoud (2):
      ARM: at91: dt: at91sam9x5: correct NAND pins comments
      ARM: at91: dt: at91sam9x5: complete NAND pinctrl

Robert de Vries (1):
      smsc75xx: configuration help incorrectly mentions smsc95xx

Russ Anderson (1):
      mm: zone_end_pfn is too small

Sachin Kamat (3):
      Thermal: dove: Convert to devm_ioremap_resource()
      Thermal: rcar: Convert to devm_ioremap_resource()
      Thermal: kirkwood: Convert to devm_ioremap_resource()

Sachin Prabhu (1):
      cifs: map NT_STATUS_SHARING_VIOLATION to EBUSY instead of ETXTBSY

Samuel Ortiz (4):
      NFC: llcp: Decrease socket ack log when accepting a connection
      NFC: llcp: Clean local timers and works when removing a device
      NFC: llcp: Clean raw sockets from nfc_llcp_socket_release
      NFC: llcp: Report error to pending sockets when a device is removed

Sander Eikelenboom (1):
      libata-acpi.c: fix copy and paste mistake in
ata_acpi_register_power_resource

Santosh Rastapur (1):
      cxgb4: Allow for backward compatibility with new VPD scheme.

Santosh Shilimkar (1):
      ARM: 7674/1: smp: Avoid dummy clockevent being preferred over
real hardware clock-event

Sascha Hauer (2):
      ARM: i.MX25: Fix DT compilation
      ARM: i.MX35: enable MAX clock

Sebastian Ott (4):
      s390/scm_blk: fix request number accounting
      s390/scm_drv: extend notify callback
      s390/scm_blk: suspend writes
      s390/scm: process availability

Seth Heasley (1):
      i2c: iSMT: add Intel Avoton DeviceIDs

Simon Horman (1):
      ARM: shmobile: marzen: Include mmc/host.h

Stefan Raspl (2):
      qeth: delay feature trace
      qeth: Fix invalid router settings handling

Stephane Eranian (1):
      perf/x86: Add SNB/SNB-EP scheduling constraints for cycle_activity event

Stephen Boyd (1):
      ARM: Scorpion is a v7 architecture, not v6

Stephen Hemminger (1):
      EDAC: Make sysfs functions static

Stephen Rothwell (1):
      powerpc: Make sure that we alays include CONFIG_BINFMT_ELF

Steven Rostedt (Red Hat) (5):
      tracing: Fix race in snapshot swapping
      tracing: Fix free of probe entry by calling call_rcu_sched()
      tracing: Protect tracer flags with trace_types_lock
      tracing: Keep overwrite in sync between regular and snapshot buffers
      tracing: Prevent buffer overwrite disabled for latency tracers

Sukadev Bhattiprolu (1):
      perf/POWER7: Create a sysfs format entry for Power7 events

Sunguk Lee (1):
      Bluetooth: Device 0cf3:3008 should map AR 3012

Syam Sidhardhan (1):
      sata_fsl: Remove redundant NULL check before kfree

Sylwester Nawrocki (1):
      ARM: S5PV210: Fix PL330 DMA controller clkdev entries

Takahisa Tanaka (2):
      watchdog: sp5100_tco: Remove code that may cause a boot failure
      watchdog: sp5100_tco: Set the AcpiMmioSel bitmask value to 1 instead of 2

Takashi Iwai (8):
      Revert "drm/i915: try to train DP even harder"
      ALSA: hda - Fix missing beep detach in patch_conexant.c
      ALSA: hda/cirrus - Fix the digital beep registration
      drm/i915: Use the fixed pixel clock for eDP in intel_dp_set_m_n()
      ALSA: hda - Fix yet missing GPIO/EAPD setup in cirrus driver
      ALSA: hda - Fix typo in checking IEC958 emphasis bit
      ALSA: hda - Fix abuse of snd_hda_lock_devices() for DSP loader
      ALSA: hda - Fix DAC assignment for independent HP

Theodore Ts'o (3):
      ext4: use atomic64_t for the per-flexbg free_clusters count
      ext4: fix ext4_evict_inode() racing against workqueue processing code
      ext4: fix data=journal fast mount/umount hang

Timo Teräs (1):
      Revert "ip_gre: make ipgre_tunnel_xmit() not parse network
header as IP unconditionally"

Tkhai Kirill (1):
      sunsu: Fix panic in case of nonexistent port at "console=ttySY"
cmdline option

Torstein Hegge (1):
      ALSA: usb: Parse UAC2 extension unit like for UAC1

Torsten Duwe (2):
      KMS: fix EDID detailed timing vsync parsing
      KMS: fix EDID detailed timing frame rate

Truls Bengtsson (1):
      usb: gadget: f_rndis: Avoid to use ERROR macro if cdev can be null

Veaceslav Falico (2):
      netconsole: don't call __netpoll_cleanup() while atomic
      bonding: don't call update_speed_duplex() under spinlocks

Vinson Lee (1):
      perf tools: Fix LIBNUMA build with glibc 2.12 and older.

Vlad Yasevich (3):
      sctp: Use correct sideffect command in duplicate cookie handling
      rtnetlink: Mask the rta_type when range checking
      bridge: Add support for setting BR_ROOT_BLOCK flag.

Vladimir Davydov (1):
      mqueue: sys_mq_open: do not call mnt_drop_write() if read-only

Wanpeng Li (1):
      mm/hugetlb: fix total hugetlbfs pages count when using memory
overcommit accouting

Wei Yongjun (2):
      thermal: rcar: fix missing unlock on error in rcar_thermal_update_temp()
      target: fix possible memory leak in core_tpg_register()

Xufeng Zhang (1):
      sctp: don't break the loop while meeting the active_path so as
to find the matched transport

Zheng Liu (4):
      ext4: avoid a potential overflow in ext4_es_can_be_merged()
      ext4: fix wrong m_len value after unwritten extent conversion
      ext4: update extent status tree after an extent is zeroed out
      ext4: fix the wrong number of the allocated blocks in ext4_split_extent()

Zhouyi Zhou (1):
      Fix dst_neigh_lookup/dst_neigh_lookup_skb return value handling bug

stephen hemminger (1):
      bridge: reserve space for IFLA_BRPORT_FAST_LEAVE
