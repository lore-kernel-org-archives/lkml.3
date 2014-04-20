Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaDTTqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 15:46:12 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:64653 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaDTTqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 15:46:03 -0400
MIME-Version: 1.0
Date: Sun, 20 Apr 2014 12:46:01 -0700
X-Google-Sender-Auth: 9Lo8jiwUdfeYVBnjUppcs8vbhMc
Message-ID: <CA+55aFypdm-s_fXU__WsOV0eG5XrMsFHNezjt9b0N3=Rx-6V2Q@mail.gmail.com>
Subject: Linux 3.15-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"And on the seventh day the rc release rose again, in accordance with
the Scriptures laid down at the kernel summit of the year 2004"

It's been a week, so here's another rc. And while -rc1 was one of the
biggest rc's in memory, rc2 looks fairly normal. We had a few niggling
issues fixed, but it really wasn't anything horribly worse than usual.
It might be a *bit* bigger than most -rc2's, but let's wait to see
after rc3 whether things are actually busier than usual. Quite often
rc2 is calmer than rc3, with it taking a week for some issues to show
up.

As to what happened during last week: the *bulk* of the rc2 patch is
actually the removal of the rtl8187se staging driver, since there's a
proper non-staging one. That's literally just over half of the actual
patch. But even if you ignore just that bulk removal, other driver
changes account for about two thirds of the rest (gpu, networking,
fbdev file renames, ipmi, infiniband, pincontrol... you name it). The
drm stuff is probably most noticeable.

Outside of drivers, we've got the usual arch updates (mostly x86 and
s390, some parisc) and some Documentation updates. Various networking
fixes and filesystem updates (cifs, sysfs, xfs). And some tooling
stuff.

Please test,

                  Linus

---

Aaron Sanders (1):
      USB: pl2303: add ids for Hewlett-Packard HP POS pole displays

Aaron Sierra (1):
      vme_tsi148: Utilize to_pci_dev() macro

Adrian Hunter (1):
      perf tools: Fix double free in perf test 21 (code-reading.c)

Adrien BAK (1):
      perf tools: Improve error reporting

Alan Stern (1):
      USB: fix crash during hotplug of PCI USB controller card

Alex Deucher (13):
      drm/radeon/dp: handle zero sized i2c over aux transactions (v2)
      drm/dp/i2c: send bare addresses to properly reset i2c connections (v4)
      drm/dp/i2c: Update comments about common i2c over dp assumptions (v3)
      drm/radeon/dp: switch to the common i2c over aux code
      drm/radeon: fix audio pin counts for DCE6+ (v2)
      drm/radeon: disable mclk dpm on R7 260X
      drm/radeon: fix runpm handling on APUs (v4)
      drm/radeon: update CI DPM powertune settings
      drm/radeon: add support for newer mc ucode on SI (v2)
      drm/radeon: add support for newer mc ucode on CI (v2)
      drm/radeon: re-enable mclk dpm on R7 260X asics
      drm/radeon/si: make sure mc ucode is loaded before checking the size
      drm/radeon/ci: make sure mc ucode is loaded before checking the size

Alexander Aring (2):
      at86rf230: remove check if AVDD settled
      at86rf230: fix __at86rf230_read_subreg function

Alexander Gordeev (3):
      IB/qib: Use pci_enable_msix_range() instead of pci_enable_msix()
      IB/mthca: Use pci_enable_msix_exact() instead of pci_enable_msix()
      qlcnic: Fix MSI-X initialization code

Alexander Shiyan (4):
      video: imxfb: Select LCD_CLASS_DEVICE unconditionally
      of: Add vendor prefix for Digi International Inc.
      Revert "serial: clps711x: Give a chance to perform useful tasks
during wait loop"
      of: add empty of_find_node_by_path() for !OF

Alexander Usyskin (1):
      mei: ignore client writing state during cb completion

Alexander Yarygin (1):
      perf kvm: Fix 'Min time' counting in report command

Alexey Khoroshilov (1):
      USB: cdc-acm: fix double usb_autopm_put_interface() in acm_port_activate()

Amir Vadai (1):
      net/mlx4_core: Defer VF initialization till PF is fully initialized

Amitkumar Karwar (2):
      mwifiex: process event before command response
      mwifiex: fix hung task on command timeout

Andi Kleen (1):
      perf stat: Initialize statistics correctly

Andrew Lunn (3):
      DT: bindings: add missing Marvell Kirkwood SoC documentation
      DT: Vendor: Add prefixes used by Kirkwood devices
      DT: I2C: Add trivial bindings used by kirkwood boards

Andrew Morton (1):
      kernel/watchdog.c:touch_softlockup_watchdog(): use raw_cpu_write()

Andrey Vagin (2):
      netfilter: nf_conntrack: flush net_gre->keymap_list only from gre helper
      netfilter: nf_conntrack: initialize net.ct.generation

Antonio Borneo (1):
      x86/platform: Fix "make O=dir kvmconfig"

Archit Taneja (4):
      drm/omap: gem sync: wait on correct events
      drm/omap: Fix crash when using LCD3 overlay manager
      drm/omap: Use old_fb to synchronize between successive page flips
      drm/omap: protect omap_crtc's event with event_lock spinlock

Arnaldo Carvalho de Melo (2):
      perf callchains: Disable unwind libraries when libelf isn't found
      MAINTAINERS: Change e-mail to kernel.org one

Arnd Bergmann (1):
      staging: gs_fpgaboot: remove __TIMESTAMP__ macro

Beniamino Galvani (1):
      pinctrl: rockchip: fix offset of mux registers for rk3188

Benjamin Tissoires (1):
      HID: core: do not scan constant input report

Bin Wang (1):
      iommu/arm-smmu: fix panic in arm_smmu_alloc_init_pte

Bjorn Andersson (1):
      pinctrl: msm: Correct interrupt code for TLMM v2

Bodo Stroesser (1):
      ipmi: Fix a race restarting the timer

Boris Ostrovsky (1):
      x86/xen: Fix 32-bit PV guests's usage of kernel_stack

Brian Foster (1):
      xfs: fix tmpfile/selinux deadlock and initialize security

Brian Norris (1):
      stable_kernel_rules: spelling/word usage

Chen Tingjie (1):
      tty: fix memleak in alloc_pid

Chris Mason (1):
      mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll

Chris Wilson (1):
      drm/i915: Always use kref tracking for all contexts.

Christian Engelmayer (2):
      rsi: Fix a potential memory leak in rsi_set_channel()
      rsi: Fix a potential memory leak in rsi_send_auto_rate_request()

Christian König (2):
      drm/radeon: apply more strict limits for PLL params v2
      drm/radeon: improve PLL params if we don't match exactly v2

Christoph Jaeger (2):
      drivers: mcb: fix memory leak in chameleon_parse_cells() error path
      drm/radeon: fix VCE fence command

Christoph Lameter (2):
      parisc: Replace __get_cpu_var uses for address calculation
      vmscan: reclaim_clean_pages_from_list() must use mod_zone_page_state()

Chun-Yeow Yeoh (1):
      mac80211: update last_tx_rate only for data frame

Cody P Schafer (1):
      perf tools: Instead of redirecting flex output, use -o

Colin Ian King (1):
      GenWQE: Ensure rc is not returning an uninitialized value

Cong Wang (2):
      ipv4, fib: pass LOOPBACK_IFINDEX instead of 0 to flowi4_iif
      ipv4, route: pass 0 instead of LOOPBACK_IFINDEX to fib_validate_source()

Corey Minyard (4):
      ipmi: Reset the KCS timeout when starting error recovery
      ipmi: Turn off default probing of interfaces
      ipmi: Turn off all activity on an idle ipmi interface
      ipmi: boolify some things

Cyril Roelandt (1):
      fs: cifs: remove unused variable.

Daeseok Youn (4):
      xen: fix memory leak in __xen_pcibk_add_pci_dev()
      staging: vme: fix memory leak in vme_user_probe()
      staging: speakup: fix misuse of kstrtol() in handle_goto()
      uwb: adds missing error handling

Dan Carpenter (5):
      xen-pciback: silence an unwanted debug printk
      dmaengine: sirf: off by one in of_dma_sirfsoc_xlate()
      staging: unisys: use after free in error messages
      Staging: unisys: use after free in list_for_each()
      isdn: icn: buffer overflow in icn_command()

Daniel Borkmann (3):
      seccomp: fix populating a0-a5 syscall args in 32-bit x86 BPF
      net: filter: seccomp: fix wrong decoding of BPF_S_ANC_SECCOMP_LD_W
      Revert "net: sctp: Fix a_rwnd/rwnd management to reflect real
state of the receiver's buffer"

Daniel J Blueman (1):
      bnx2: Don't build unused suspend/resume functions not enabled

Daniel Thompson (1):
      serial: st-asc: Fix SysRq char handling

Daniel Vetter (4):
      drm/mm: Don't WARN if drm_mm_reserve_node
      drm/i915: Disable self-refresh for untiled fbs on i915gm
      drm/plane-helper: Don't fake-implement primary plane disabling
      drm: Split out drm_probe_helper.c from drm_crtc_helper.c

Daniele Palmas (1):
      usb: option driver, add support for Telit UE910v2

Dave Airlie (1):
      drm/ast: fix value check in cbr_scan2

Dave Chinner (8):
      xfs: kill buffers over failed write ranges properly
      xfs: write failure beyond EOF truncates too much data
      xfs: xfs_vm_write_end truncates too much on failure
      xfs: zeroing space needs to punch delalloc blocks
      xfs: don't map ranges that span EOF for direct IO
      xfs: collapse range is delalloc challenged
      xfs: unmount does not wait for shutdown during unmount
      xfs: wrong error sign conversion during failed DIO writes

David Fries (2):
      w1: fix netlink refcnt leak on error path
      w1: avoid recursive device_add

David Woodhouse (1):
      iommu/vt-d: Fix get_domain_for_dev() handling of upstream PCIe bridges

Davidlohr Bueso (1):
      mm: fix CONFIG_DEBUG_VM_RB description

Derya (1):
      Revert "HID: microsoft: Add ID's for Surface Type/Touch Cover 2"

Dinh Nguyen (1):
      dt-bindings: add vendor-prefix for Newhaven Display

Duan Jiong (2):
      s390/sclp: replace PTR_RET with PTR_ERR_OR_ZERO
      s390/sclp_cmd: replace PTR_RET with PTR_ERR_OR_ZERO

Edward Cree (1):
      sfc:On MCDI timeout, issue an FLR (and mark MCDI to fail-fast)

Eli Cohen (1):
      IB/mlx5: Add block multicast loopback support

Eliad Peller (1):
      wl18xx: align event mailbox with current fw

Emmanuel Grumbach (4):
      iwlwifi: mvm: BT Coex - send the new LUT upon antenna coupling change
      iwlwifi: 7000: bump API to 9
      iwlwifi: add MODULE_FIRMWARE for 7265
      iwlwifi: mvm: BT Coex - fix Look Up Table

Eric Dumazet (4):
      ipv6: Limit mtu to 65575 bytes
      ipv4: add a sock pointer to ip_queue_xmit()
      ipv4: add a sock pointer to dst->output() path.
      coredump: fix va_list corruption

Eric Sandeen (1):
      xfs: fix buffer use after free on IO error

Eyal Shapira (7):
      iwlwifi: mvm: rs: fix mimo delimiter in LQ cmd
      iwlwifi: mvm: rs: use correct max expected throughput figures
      iwlwifi: mvm: rs: fix and cleanup rs_get_rate_action
      iwlwifi: mvm: rs: reinit rs if no tx for a long time
      iwlwifi: mvm: rs: fallback to legacy Tx columns
      iwlwifi: mvm: avoid searching unnecessary columns
      iwlwifi: mvm: rs: clear per rate stats when aggregation changes

Felix Fietkau (2):
      mac80211: suppress BSS info change notifications for AP_VLAN
      mac80211: exclude AP_VLAN interfaces from tx power calculation

Feng Wu (5):
      KVM: Remove SMAP bit from CR4_RESERVED_BITS
      KVM: Add SMAP support when setting CR4
      KVM: Disable SMAP for guests in EPT realmode and EPT unpaging mode
      KVM: expose SMAP feature to guest
      KVM: Rename variable smep to cr4_smep

Frank Haverkamp (4):
      GenWQE: Enable access to VPD flash area
      GenWQE: Add wmb before DDCB is started
      GenWQE: Fix multithreading problems
      GenWQE: Increase driver version number

Frank Praznik (1):
      HID: sony: Fix cancel_work_sync mismerge

Frank Rowand (1):
      drivers/base/dd.c incorrect pr_debug() parameters

Frederic Danis (1):
      cw1200: Fix cw1200_debug_link_id

Geert Uytterhoeven (5):
      rsi: Add missing initialization of ii
      staging: r8723au: Add missing initialization of change_inx in
sort algorithm
      misc: Grammar s/addition/additional/
      Documentation: Update stable address in Chinese and Japanese translations
      serial_core: Fix pm imbalance on unbind

Gerd Hoffmann (3):
      drm: cirrus: add power management support
      drm: bochs: add power management support
      drm: bochs: drop unused struct fields

Grazvydas Ignotas (1):
      drm/omap: fix plane rotation

Greg Kroah-Hartman (2):
      staging: delete rtl8187se wireless driver
      Revert "serial: 8250, disable "too much work" messages"

Guennadi Liakhovetski (2):
      serial: pl011: change Rx burst size to half of trigger level
      serial: amba-pl011: fix regression, causing an Oops on rmmod

Guenter Roeck (4):
      of: Clean up of_update_property
      net: mdio-gpio: Use devm_ functions where possible
      net: mdio-gpio: Add support for active low gpio pins
      net: mdio-gpio: Add support for separate MDI and MDO gpio pins

Hariprasad Shenai (1):
      RDMA/cxgb4: Use pr_warn_ratelimited

Heiko Carstens (7):
      s390/smp: fix smp_stop_cpu() for !CONFIG_SMP
      s390/mm: print control registers and page table walk on crash
      s390: show_registers() should not map user space addresses to
kernel symbols
      s390: wire up sys_renameat2
      s390: add 31 bit warning message
      s390/uaccess: fix possible register corruption in strnlen_user_srst()
      s390/compat: fix typo

Heiko Stübner (2):
      pinctrl: rockchip: add return value to rockchip_set_mux
      pinctrl: rockchip: handle first half of rk3188-bank0 correctly

Helge Deller (2):
      parisc: change value of SHMLBA from 0x00400000 to PAGE_SIZE
      parisc: fix epoll_pwait syscall on compat kernel

Hui Wang (1):
      ALSA: hda - add headset mic detect quirk for a Dell laptop

Ian Abbott (1):
      staging: comedi: fix circular locking dependency in comedi_mmap()

Ido Yariv (1):
      mac80211: Disable SMPS for the monitor interface

Ingo Molnar (2):
      x86: Remove the PCI reboot method from the default chain
      x86/mce: Fix CMCI preemption bugs

Ivan Vecera (1):
      tg3: update rx_jumbo_pending ring param only when jumbo frames are enabled

Jan Glauber (1):
      net: use SYSCALL_DEFINEx for sys_recv

Jani Nikula (3):
      drm/i915: support address only i2c-over-aux transactions
      drm/i915: check VBT for supported backlight type
      drm/i915: do not setup backlight if not available according to VBT

Javier Martinez Canillas (1):
      of: add vendor prefix for ISEE 2007 S.L.

Jean Delvare (5):
      net: cadence: Add architecture dependencies
      platform: Fix timberdale dependencies
      serial: timberdale: Depend on X86_32
      Documentation/serial: Delete obsolete driver documentation
      tty: Fix help text of SYNCLINK_CS

Jeff Layton (1):
      cifs: fix error handling cifs_user_readv

Jes Sorensen (1):
      staging: rtl8723au: Fix buffer overflow in rtw_get_wfd_ie()

Jiang Liu (2):
      iommu/vt-d: fix memory leakage caused by commit ea8ea46
      iommu/vt-d: fix bug in matching PCI devices with DRHD/RMRR descriptors

Jiri Slaby (2):
      serial: 8250, disable "too much work" messages
      Char: ipmi_bt_sm, fix infinite loop

Jitendra Kalsaria (2):
      qlcnic: Fix PVID configuration on eSwitch port.
      qlcnic: Fix QLogic application/driver interface for virtual NIC
configuration

Joe Schultz (2):
      vme_tsi148: Fix typo in tsi148_slave_get()
      vme_tsi148: Fix PCI address mapping assumption

Johan Hovold (2):
      Revert "USB: serial: add usbid for dell wwan card to sierra.c"
      USB: usb_wwan: fix handling of missing bulk endpoints

Johannes Berg (2):
      mac80211: fix software remain-on-channel implementation
      iwlwifi: mvm: delay enabling smart FIFO until after beacon RX

Jon Ringle (1):
      video: da8xx-fb: Fix casting of info->pseudo_palette

Julian Anastasov (1):
      ipv4: return valid RTA_IIF on ip route get

Jyri Sarha (2):
      OMAPDSS: Take pixelclock unit change into account in hdmi_compute_acr()
      OMAPDSS: Change struct reg_field to dispc_reg_field

K. Y. Srinivasan (2):
      Tools: hv: Handle the case when the target file exists correctly
      Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 hosts

Kailang Yang (2):
      ALSA: hda/realtek - Add support of ALC288 codec
      ALSA: hda/realtek - Add headset Mic support for Dell machine

Kalesh AP (1):
      be2net: Fix invocation of be_close() after be_clear()

Kees Cook (2):
      seccomp: fix memory leak on filter attach
      mips: export flush_icache_range

Kirill A. Shutemov (1):
      thp: close race between split and zap huge pages

Kirill Tkhai (1):
      sched: Check for stop task appearance when balancing happens

Konrad Rzeszutek Wilk (3):
      xen/spinlock: Don't enable them unconditionally.
      xen/xenbus: Avoid synchronous wait on XenBus stalling shutdown/restart.
      xen/manage: Poweroff forcefully if user-space is not yet up.

Larry Finger (3):
      staging: r8188eu: Calling rtw_get_stainfo() with a NULL sta_addr
will return NULL
      staging: r8712u: Fix case where ethtype was never obtained and
always be checked against 0
      staging: r8188eu: Fix case where ethtype was never obtained and
always be checked against 0

Laurent Pinchart (3):
      iommu/arm-smmu: Return 0 on unmap failure
      USB: ohci-jz4740: Fix uninitialized variable warning
      USB: ohci-jz4740: FEAT_POWER is a port feature, not a hub feature

Lauri Kasanen (1):
      drm/radeon: Improve vramlimit module param documentation

Li, Zhen-Hua (2):
      ALSA: es18xx driver should use udelay error
      driver/net: cosa driver uses udelay incorrectly

Lin Yongting (1):
      Chinese: add translation of io_ordering.txt

Linus Torvalds (1):
      Linux 3.15-rc2

Linus Walleij (2):
      pinctrl: nomadik: delete stray debug print
      irqchip: vic: Properly chain the cascaded IRQs

Lucas Stach (3):
      PCI: designware: Use new OF interrupt mapping when possible
      PCI: rcar: Use new OF interrupt mapping when possible
      PCI: tegra: Use new OF interrupt mapping when possible

Luciano Coelho (1):
      wlcore: ignore dummy packet events in PLT mode

Manish Chopra (1):
      qlcnic: Do not disable SR-IOV when VFs are assigned to VMs

Marcelo Tosatti (1):
      KVM: x86: remove WARN_ON from get_kernel_ns()

Martin Schwidefsky (1):
      s390: fix control register update

Masahiro Yamada (1):
      x86/build: Supress "Nothing to be done for ..." messages

Masami Hiramatsu (2):
      perf probe: Fix to handle errors in line_range searching
      kprobes/x86: Fix page-fault handling logic

Mathias Krause (1):
      filter: prevent nla extensions to peek beyond the end of the message

Matt Porter (1):
      hwrng: bcm2835 - fix oops when rng h/w is accessed during registration

Mel Gorman (1):
      mm: use paravirt friendly ops for NUMA hinting ptes

Michael Opdenacker (1):
      cif: fix dead code

Michael Ulbricht (1):
      USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver

Michal Kazior (1):
      mac80211: fix radar_enabled propagation

Michele Baldessari (1):
      USB: serial: ftdi_sio: add id for Brainboxes serial cards

Mike Galbraith (1):
      sched/numa: Fix task_numa_free() lockdep splat

Mike Qiu (2):
      powerpc/PCI: Fix NULL dereference in sys_pciconfig_iobase() list traversal
      powerpc/mm: fix ".__node_distance" undefined

Miklos Szeredi (1):
      i386: Wire up the renameat2() syscall

Mikulas Patocka (1):
      user namespace: fix incorrect memory barriers

Mizuma, Masayoshi (1):
      mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()

Mohit Kumar (2):
      PCI: designware: Fix comment for setting number of lanes
      PCI: designware: Fix iATU programming for cfg1, io and mem viewport

Namhyung Kim (5):
      perf top: Fix documentation of invalid -s option
      tools lib traceevent: Print event name when show warning if possible
      tools lib traceevent: Do not call warning() directly
      perf probe: Fix --line option behavior
      perf probe: Use dwarf_getcfi_elf() instead of dwarf_getcfi()

Nicolas Dichtel (4):
      ip6_gre: don't allow to remove the fb_tunnel_dev
      ip_tunnel: use the right netns in ioctl handler
      sit: use the right netns in ioctl handler
      ip6_tunnel: use the right netns in ioctl handler

Oliver Neukum (3):
      uas: fix GFP_NOIO under spinlock
      uas: fix error handling during scsi_scan()
      uas: fix deadlocky memory allocations

Oren Givon (1):
      iwlwifi: add new 7265 HW IDs

Paolo Bonzini (2):
      KVM: ioapic: fix assignment of ioapic->rtc_status.pending_eoi
(CVE-2014-0155)
      KVM: ioapic: try to recover if pending_eoi goes out of range

Patrick McHardy (1):
      netfilter: nf_tables: fix nft_cmp_fast failure on big endian for size < 4

Paul Bolle (1):
      staging: fpgaboot: clean up Makefile

Peter Chen (1):
      usb: usb-common: fix typo for usb_state_string

Peter Foley (1):
      init/Kconfig: move the trusted keyring config option to general setup

Peter Oberparleiter (1):
      s390/sclp_vt220: Fix kernel panic due to early terminal input

Peter Zijlstra (2):
      locking/mutex: Fix debug_mutexes
      wait: explain the shadowing and type inconsistencies

Quentin Casasnovas (1):
      drm/radeon: memory leak on bo reservation failure. v2

Ramkumar Ramachandra (4):
      perf tools: Pick up libdw without explicit LIBDW_DIR
      perf bench: Update manpage to mention numa and futex
      perf bench: Fix segfault at the end of an 'all' execution
      perf bench: Set more defaults in the 'numa' suite

Randy Dunlap (1):
      mm: fix new kernel-doc warning in filemap.c

Richard Weinberger (1):
      staging/rtl8821ae: Fix OOM handling in _rtl_init_deferred_work()

Sachin Prabhu (1):
      cifs: Wait for writebacks to complete before attempting write.

Sanjay Singh Rawat (1):
      serial: omap: free the wakeup settings in remove

Sasha Levin (2):
      tools/liblockdep: Ignore asmlinkage and visible
      tools/liblockdep: Add proper versioning to the shared obj

Sekhar Nori (1):
      dma: edma: fix incorrect SG list handling

Sergei Antonov (1):
      drm/nouveau/bios: fix a bit shift error introduced by 457e77b

Seth Bollinger (1):
      serial_core: Fix conditional start_tx on ring buffer not empty

Shahed Shaikh (1):
      qlcnic: Fix max ring count calculation

Shaohua Li (1):
      raid5: fix a race of stripe count check

Sherman Yin (3):
      pinctrl: Rename Broadcom Capri pinctrl driver
      Update bcm_defconfig with new pinctrl CONFIG
      pinctrl: fix typo in bindings documentation

Shuah Khan (2):
      staging/usbip: userspace - fix usbipd SIGSEGV from
refresh_exported_devices()
      staging/usbip: fix store_attach() sscanf return value check

Stefan Wahren (1):
      of: add vendor prefix for I2SE GmbH

Steffen Trumtrar (1):
      DT: add vendor prefix for EBV Elektronik

Stephen Chandler Paul (1):
      HID: sensor-hub: add sensor hub quirk for ThinkPad Helix

Stephen Warren (2):
      gpu: host1x: handle the correct # of syncpt regs
      USB: EHCI: tegra: set txfill_tuning

Steve French (1):
      Return correct error on query of xattr on file with empty xattrs

Steve Wise (11):
      RDMA/cxgb4: Use the BAR2/WC path for kernel QPs and T5 devices
      RDMA/cxgb4: Endpoint timeout fixes
      RDMA/cxgb4: rmb() after reading valid gen bit
      RDMA/cxgb4: SQ flush fix
      RDMA/cxgb4: Max fastreg depth depends on DSGL support
      RDMA/cxgb4: Initialize reserved fields in a FW work request
      RDMA/cxgb4: Add missing debug stats
      RDMA/cxgb4: Use uninitialized_var()
      RDMA/cxgb4: Fix over-dereference when terminating
      cxgb4: Save the correct mac addr for hw-loopback connections in the L2T
      cxgb4: use the correct max size for firmware flash

Steven Miao (1):
      video: bf54x-lq043fb: fix build error

Steven Rostedt (Red Hat) (1):
      tracing: Do not try to recreated toplevel set_ftrace_* files

Subhajit Paul (1):
      drm/omap: Fix memory leak in omap_gem_op_async

Sucheta Chakraborty (2):
      qlcnic: Fix panic due to uninitialzed delayed_work struct in use.
      qlcnic: Fix to send INIT_NIC_FUNC as first mailbox.

Takashi Iwai (2):
      ttyprintk: Fix wrong tty_unregister_driver() call in the error path
      ttyprintk: Allow built as a module

Tang Chen (1):
      Documentation/vm/numa_memory_policy.txt: fix wrong document in
numa_memory_policy.txt

Tejun Heo (2):
      kernfs: protect lazy kernfs_iattrs allocation with mutex
      sysfs, driver-core: remove unused {sysfs|device}_schedule_callback_owner()

Thierry Reding (2):
      drm/tegra: dp: Support address-only I2C-over-AUX transactions
      drm/tegra: Remove gratuitous pad field

Thomas Bächler (1):
      fs: Don't return 0 from get_anon_bdev

Thomas Petazzoni (3):
      Revert "net: mvneta: fix usage as a module on RGMII configurations"
      net: phy: add minimal support for QSGMII PHY
      net: mvneta: properly configure the MAC <-> PHY connection in
all situations

Tomas Winkler (1):
      mei: me: do not load the driver if the FW doesn't support MEI interface

Tomi Valkeinen (16):
      drm/omap: fix output enable/disable sequence
      drm/omap: fix uninit order in pdev_remove()
      drm/omap: fix DMM driver (un)registration
      drm/omap: fix race issue when unloading omapdrm
      drm/omap: fix missing disable for unused encoder
      drm/omap: fix enabling/disabling of video pipeline
      drm/omap: fix missing unref to fb's buf object
      OMAPDSS: fix rounding when calculating fclk rate
      OMAPDSS: fix shared irq handlers
      drm/omap: print warning when rotating non-TILER fb
      drm/omap: remove extra plane->destroy from crtc destroy
      drm/omap: remove warn from debugfs
      drm/omap: fix the handling of fb ref counts
      video: move fbdev to drivers/video/fbdev
      fbdev: move fbdev core files to separate directory
      video: Kconfig: move drm and fb into separate menus

Tony Lindgren (1):
      serial: omap: Fix missing pm_runtime_resume handling by simplifying code

Tony Luck (1):
      [IA64] Change default PSR.ac from '1' to '0' (Fix erratum #237)

Tristan Bruns (1):
      USB: cp210x: Add 8281 (Nanotec Plug & Drive)

Tuomas Tynkkynen (1):
      staging: goldfish: Call free_irq in error path

Uwe Kleine-König (1):
      serial: efm32: use $vendor,$device scheme for compatible string

Vasundhara Volam (1):
      be2net: Fix to reap TX compls till HW doesn't respond for some time

Venkatesh Srinivas (1):
      perf/x86/intel: Use rdmsrl_safe() when initializing RAPL PMU

Ville Syrjälä (1):
      x86/gpu: Fix sign extension issue in Intel graphics stolen memory quirks

Vince Weaver (1):
      perf/x86: Enable DRAM RAPL support on Intel Haswell

Vincent Stehlé (1):
      topology: Fix compilation warning when not in SMP

Vineet Gupta (1):
      ARC: Delete stale barrier.h

Viresh Kumar (4):
      tick-common: Fix wrong check in tick_check_replacement()
      tick-sched: Don't call update_wall_time() when delta is lesser
than tick_period
      tick-sched: Check tick_nohz_enabled in tick_nohz_switch_to_nohz()
      Shiraz has moved

Vivek Gautam (2):
      usb: ehci-exynos: Return immediately from suspend if ehci_suspend fails
      usb: ehci-platform: Return immediately from suspend if ehci_suspend fails

Vlad Yasevich (2):
      net: Start with correct mac_len in skb_network_protocol
      net: sctp: cache auth_enable per endpoint

Vladimir Nikulichev (1):
      perf tools: Adjust symbols in VDSO

Wang, Xiaoming (1):
      net: ipv4: current group_info should be put after using.

Wei Yang (1):
      net/mlx4_core: Preserve pci_dev_data after __mlx4_remove_one()

Wilfried Klaebe (1):
      staging: rtl8188eu: remove spaces, correct counts to unbreak P2P ioctls

Xiubo Li (1):
      of: Fix the section mismatch warnings.

Yuan Yao (1):
      dma: fix eDMA driver as a subsys_initcall

dingtianhong (1):
      vlan: Fix lockdep warning when vlan dev handle notification

zhangwei(Jovi) (1):
      tracing/uprobes: Fix uprobe_cpu_buffer memory leak
