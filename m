Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab3DADmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 23:42:43 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47436 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3DADmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 23:42:40 -0400
MIME-Version: 1.0
Date: Sun, 31 Mar 2013 20:42:39 -0700
X-Google-Sender-Auth: 7KLGZOlmCLZAVb0JggICxyF6yR8
Message-ID: <CA+55aFyUk2Xexvk_0szYdz2TPHt_i9oDu9yTto_MASrz8XzxnA@mail.gmail.com>
Subject: Linux 3.9-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc.

I'm like the US postal office - "Neither snow nor rain nor heat nor
gloom of night"  will keep me from doing weekly -rc releases. A little
holiday like Easter? Bah, humbug. It might delay the release email a
few hours because a man gotta stuff himself with odd seasonal desserts
(and the Finnish Easter desserts are odder than most), but it won't
stop the inevitable progress towards a final 3.9 release.

So there it is. A shiny new release candidate, just waiting for testing.

Nothing really peculiar stands out. Exynos DRM updates, IBM RamSan
driver updates are a bit larger, l2tp update... The rest is pretty
much small patches spread out all over. Mostly drivers (block, net,
media, tty, usb), networking, and some filesystem updates (btrfs,
nfs). Some arch updates (x86, arc).

Things seem to be calming down a bit, and everything seems largely on
track for a 3.9 release in a few weeks.

                          Linus

---

Aaro Koskinen (1):
      omapfb: fix broken build on OMAP1

Al Viro (4):
      Don't bother with redoing rw_verify_area() from default_file_splice_from()
      Nest rename_lock inside vfsmount_lock
      vt: synchronize_rcu() under spinlock is not nice...
      vfs/splice: Fix missed checks in new __kernel_write() helper

Alex Elder (1):
      rbd: don't zero-fill non-image object requests

Alex Williamson (2):
      igb: Fix null pointer dereference
      igb: SR-IOV init reordering

Alexandru Gheorghiu (1):
      drm/exynos: Replaced kzalloc & memcpy with kmemdup

Alice Ferrazzi (1):
      Block: blk-flush: Fixed indent code style

Amitkumar Karwar (1):
      mwifiex: fix race when queuing commands

Andrey Vagin (1):
      net: fix *_DIAG_MAX constants

Andrzej Hajda (1):
      [media] m5mols: Fix bug in stream on handler

Andy King (1):
      VMCI: Fix process-to-process DRGAMs.

Andy Shevchenko (1):
      dw_dmac: adjust slave_id accordingly to request line base

Archit Taneja (1):
      omapdss: features: fix supported outputs for OMAP4

Arnd Bergmann (3):
      iommu: OMAP: build only on OMAP2+
      [media] ir: IR_RX51 only works on OMAP2
      dmaengine: dw_dma: fix endianess for DT xlate function

Arun Kumar K (2):
      [media] s5p-mfc: Fix frame skip bug
      [media] s5p-mfc: Fix encoder control 15 issue

Axel Lin (1):
      pinctrl: abx500: Fix checking if pin use AlternateFunction register

Ben Hutchings (2):
      efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
      ARM64: early_printk: Fix check for CONFIG_ARM64_64K_PAGES

Benjamin Tissoires (1):
      HID: multitouch: fix touchpad buttons

Bing Zhao (2):
      mwifiex: skip pending commands after function shutdown
      mwifiex: cancel cmd timer and free curr_cmd in shutdown process

CQ Tang (1):
      x86-64: Fix the failure case in copy_user_handle_tail()

Chanwoo Choi (3):
      extcon: max8997: Check the pointer of platform data to protect
null pointer error
      extcon: max77693: Fix bug of wrong pointer when platform data is not used
      extcon: max77693: Initialize register of MUIC device to bring up
it without platform data

Chen Gang (2):
      xen/xen-blkback: preq.dev is used without initialized
      powerpc: make additional room in exception vector area

Chen Gong (1):
      ACPI / APEI: fix error status check condition for CPER

Chris Mason (1):
      Btrfs: fix race between mmap writes and compression

Cong Wang (1):
      8021q: fix a potential use-after-free

Dan Carpenter (1):
      IB/ipath: Silence a static checker warning

Daniel Borkmann (1):
      flow_keys: include thoff into flow_keys for later usage

Daniel Vetter (2):
      Revert "drm/i915: set TRANSCODER_EDP even earlier"
      Revert "drm/i915: write backlight harder"

David Vrabel (2):
      xen/blkback: correctly respond to unknown, non-native requests
      xen/events: avoid race with raising an event in unmask_evtchn()

Dirk Brandewie (2):
      cpufreq / intel_pstate: Add function to check that all MSRs are valid
      cpufreq / intel_pstate: Fix calculation of current frequency

Eric Dumazet (2):
      tcp: preserve ACK clocking in TSO
      net: remove a WARN_ON() in net_enable_timestamp()

Eric W. Biederman (8):
      scm: Require CAP_SYS_ADMIN over the current pidns to spoof pids.
      pid: Handle the exit of a multi-threaded init.
      yama:  Better permission check for ptraceme
      userns:  Don't allow creation if the user is chrooted
      vfs: Add a mount flag to lock read only bind mounts
      vfs: Carefully propogate mounts across user namespaces
      ipc: Restrict mounting the mqueue filesystem
      userns: Restrict when proc and sysfs can be mounted

Fabio Estevam (2):
      net: fec: Define indexes as 'unsigned int'
      fec: Fix the build as module

Fabio Valentini (1):
      ACPI / PM: fix suspend and resume on Sony Vaio VGN-FW21M

Felix Fietkau (2):
      ath9k_hw: revert chainmask to user configuration after calibration
      ath9k: limit tx path hang check to normal data queues

Fenghua Yu (1):
      x86-32, microcode_intel_early: Fix crash with CONFIG_DEBUG_VIRTUAL

Florian Westphal (1):
      netfilter: ip6t_NPT: restrict to mangle table

Gao feng (1):
      netfilter: nf_conntrack: register pernet subsystem before
register L4 proto

Grazvydas Ignotas (1):
      OMAPDSS: tpo-td043 panel: fix data passing between SPI/DSS parts

H. Peter Anvin (1):
      x86, microcode_intel_early: Mark apply_microcode_early() as cpuinit

Hadar Hen Zion (4):
      net/mlx4_core: Fix wrong order of flow steering resources removal
      net/mlx4_en: Remove ethtool flow steering rules before releasing QPs
      net/mlx4_core: Always use 64 bit resource ID when doing lookup
      net/mlx4_core: Disallow releasing VF QPs which have steering rules

Hans de Goede (1):
      [media] [REGRESSION] bt8xx: Fix too large height in cropcap

Haojian Zhuang (1):
      gpio: fix wrong checking condition for gpio range

Hong Zhiguo (1):
      ipv6: fix bad free of addrconf_init_net

Hong zhi guo (1):
      bridge: fix crash when set mac address of br interface

Horia Geanta (2):
      Revert "crypto: talitos - add IPsec ESN support"
      Revert "crypto: caam - add IPsec ESN support"

Ian Abbott (1):
      staging: comedi: s626: fix continuous acquisition

Inki Dae (1):
      drm/exynos: Add a new function to get gem buffer size

Jan Beulich (2):
      xen-blkback: fix dispatch_rw_block_io() error path
      xen-pciback: notify hypervisor about devices intended to be
assigned to guests

Jan Schmidt (2):
      Btrfs: fix locking on ROOT_REPLACE operations in tree mod log
      Btrfs: fix EIO from btrfs send in is_extent_unchanged for punched holes

Jeff Layton (2):
      nfsd: only unhash DRC entries that are in the hashtable
      nfsd: fix startup order in nfsd_reply_cache_init

Jens Axboe (1):
      rsxx: fix missing unlock on error return in rsxx_eeh_remap_dmas()

Jiri Benc (1):
      igb: fix PHC stopping on max freq

Jiri Kosina (1):
      HID: usbhid: fix build problem

Jiri Slaby (2):
      TTY: 8250, revert module name change
      TTY: 8250, deprecated 8250_core.* options

Joerg Roedel (1):
      iommu/amd: Make sure dma_ops are set for hotplug devices

John Linn (1):
      Xilinx: ARM: UART: clear pending irqs before enabling irqs

Josef Bacik (6):
      Btrfs: handle a bogus chunk tree nicely
      Btrfs: fix space leak when we fail to reserve metadata space
      Btrfs: fix space accounting for unlink and rename
      Btrfs: hold the ordered operations mutex when waiting on ordered extents
      Btrfs: limit the global reserve to 512mb
      Btrfs: don't drop path when printing out tree errors in scrub

Josh Boyer (2):
      HID: usbhid: quirk for Realtek Multi-card reader
      HID: usbhid: quirk for MSI GX680R led panel

Julian Anastasov (3):
      ipvs: fix sctp chunk length order
      ipvs: add backup_only flag to avoid loops
      ipvs: remove extra rcu lock

Jussi Kivilinna (1):
      rtlwifi: usb: add missing freeing of skbuff

Kees Cook (1):
      net/irda: add missing error path release_sock call

Kent Overstreet (1):
      nfsd: fix bad offset use

Kevin Hilman (1):
      MAINTAINERS: update email address for Kevin Hilman

Konrad Rzeszutek Wilk (4):
      xen/acpi-processor: Don't dereference struct acpi_processor on all CPUs.
      intel-pstate: Use #defines instead of hard-coded values.
      xen/acpi-stub: Disable it b/c the acpi_processor_add is no longer called.
      xen/mmu: Move the setting of pvops.write_cr3 to later phase in bootup.

Konstantin Holoborodko (1):
      usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD

Kumar Amit Mehta (1):
      bnx2x: fix assignment of signed expression to unsigned variable

Lan Tianyu (2):
      usb: add find_raw_port_number callback to struct hc_driver()
      usb/acpi: binding xhci root hub usb port with ACPI

Laurent Pinchart (1):
      pinctrl: Print the correct information in debugfs pinconf-state file

Laxman Dewangan (1):
      ARM: tegra: fix register address of slink controller

Leela Krishna Amudala (1):
      drm/exynos: fimd: calculate the correct address offset

Len Brown (1):
      ia64 idle: delete stale (*idle)() function pointer

Linus Torvalds (1):
      Linux 3.9-rc5

Lior Levy (1):
      igb: fix i350 anti spoofing config

Liu Bo (1):
      Btrfs: update to use fs_state bit

Lothar Waßmann (1):
      net: ethernet: cpsw: fix erroneous condition in error check

Marek Vasut (1):
      ARM: video: mxs: Fix mxsfb misconfiguring VDCTRL0

Mark Rutland (1):
      clockevents: Don't allow dummy broadcast timers

Martin Fuzzey (1):
      ipconfig: Fix newline handling in log message.

Masatake YAMATO (2):
      genetlink: trigger BUG_ON if a group name is too long
      thermal: shorten too long mcast group name

Matt Fleming (2):
      efivars: explicitly calculate length of VariableName
      efivars: Handle duplicate names from get_next_variable()

Mauro Carvalho Chehab (1):
      [media] fix compilation with both V4L2 and I2C as 'm'

Miao Xie (2):
      Btrfs: fix wrong reservation of csums
      Btrfs: fix wrong return value of btrfs_lookup_csum()

Michel Lespinasse (1):
      Revert "mm: introduce VM_POPULATE flag to better deal with racy
userspace programs"

Mihnea Dobrescu-Balaur (1):
      xen-blkfront: replace kmalloc and then memcpy with kmemdup

Mike Marciniszyn (1):
      IPoIB: Fix send lockup due to missed TX completion

Ming Lei (5):
      Bluetooth: Add support for Dell[QCA 0cf3:0036]
      Bluetooth: Add support for Dell[QCA 0cf3:817a]
      sysfs: fix race between readdir and lseek
      sysfs: handle failure path correctly for readdir()
      USB: serial: fix hang when opening port

Moshe Lazer (1):
      net/mlx4_core: Fix wrong mask applied on EQ numbers in the wrapper

Nicholas Bellinger (2):
      tcm_vhost: Avoid VIRTIO_RING_F_EVENT_IDX feature bit
      target: Fix RESERVATION_CONFLICT status regression for
iscsi-target special case

Nikola Pajkovsky (1):
      amd_iommu_init: remove __init from amd_iommu_erratum_746_workaround

Pablo Neira Ayuso (1):
      netfilter: nfnetlink_queue: fix incorrect initialization of copy
range field

Paul Bolle (2):
      staging: zcache: fix typo "64_BIT"
      netfilter: remove unused "config IP_NF_QUEUE"

Paul Moore (1):
      unix: fix a race condition in unix_release()

Paul Walmsley (1):
      Revert "lockdep: check that no locks held at freeze time"

Paulo Zanoni (1):
      drm/i915: don't disable the power well yet

Pawel Wieczorkiewicz (1):
      tty: atmel_serial_probe(): index of atmel_ports[] fix

Peter Chen (1):
      usb: xhci: fix build warning

Philip J Kelleher (8):
      block: IBM RamSan 70/80 trivial changes.
      block: IBM RamSan 70/80 fixes inconsistent locking.
      block: IBM RamSan 70/80 branding changes.
      block: IBM RamSan 70/80 error message bug fix.
      Adding in EEH support to the IBM FlashSystem 70/80 device driver
      block: removes dynamic allocation on stack
      rsxx: enable error return of rsxx_eeh_save_issued_dmas()
      rsxx: remove unused variable

Phillip Susi (1):
      loop: cleanup partitions when detaching loop device

Pierrick Hascoet (1):
      arc: fix dma_address assignment during dma_map_sg()

Pravin B Shelar (1):
      ipv4: Fix ip-header identification for gso packets.

Rafael J. Wysocki (1):
      PNP: List Rafael Wysocki as a maintainer

Richard Genoud (1):
      pinmux: forbid mux_usecount to be set at UINT_MAX

Roger Pau Monne (5):
      xen-blkback: fix foreach_grant_safe to handle empty lists
      xen-blkfront: switch from llist to list
      xen-blkback: don't store dev_bus_addr
      xen-blkfront: pre-allocate pages for requests
      xen-blkfront: remove frame list from blk_shadow

Roland Stigge (1):
      usb: Fix compile error by selecting USB_OTG_UTILS

Sachin Kamat (2):
      pinctrl: generic: Fix compilation error
      drm/exynos: Make mixer_check_timing static

Sarah Sharp (1):
      xhci: Don't warn on empty ring for suspended devices.

Sergei Shtylyov (2):
      sh_eth: fix bitbang memory leak
      sh_eth: check TSU registers ioremap() error

Seth Forshee (2):
      efivars: Allow disabling use as a pstore backend
      efivars: Add module parameter to disable use as a pstore backend

Shaik Ameer Basha (4):
      [media] fimc-lite: Initialize 'step' field in fimc_lite_ctrl structure
      [media] fimc-lite: Fix the variable type to avoid possible crash
      [media] exynos-gsc: send valid m2m ctx to gsc_m2m_job_finish
      [media] s5p-fimc: send valid m2m ctx to fimc_m2m_job_finish

Shawn Guo (1):
      ARM: imx: add dependency check for DEBUG_IMX_UART_PORT

Simon Guinot (1):
      pinctrl: mvebu: fix checking for SoC specific controls

Soeren Moch (1):
      USB: EHCI: fix bug in iTD/siTD DMA pool allocation

Stanislaw Gruszka (1):
      iwl3945: fix length of dma buffers

Stephen Hemminger (1):
      igb: make sensor info static

Stuart Yoder (1):
      powerpc: define the conditions where the ePAPR idle hcall can be supported

Sylwester Nawrocki (1):
      [media] s5p-fimc: Do not attempt to disable not enabled media pipeline

Tom Parkin (12):
      udp: add encap_destroy callback
      l2tp: add udp encap socket destroy handler
      l2tp: export l2tp_tunnel_closeall
      l2tp: close sessions in ip socket destroy callback
      l2tp: close sessions before initiating tunnel delete
      l2tp: take a reference for kernel sockets in l2tp_tunnel_sock_lookup
      l2tp: don't BUG_ON sk_socket being NULL
      l2tp: add session reorder queue purge function to core
      l2tp: purge session reorder queue on delete
      l2tp: push all ppp pseudowire shutdown through .release handler
      l2tp: avoid deadlock in l2tp stats update
      l2tp: unhash l2tp sessions on delete, not on free

Tomas Winkler (2):
      mei: add mei_stop function to stop mei device
      mei: ME hardware reset needs to be synchronized

Trond Myklebust (5):
      NFSv4: Fix the string length returned by the idmapper
      NFSv4.1: Fix a race in pNFS layoutcommit
      NFSv4.1: Always clear the NFS_INO_LAYOUTCOMMIT in layoutreturn
      NFSv4.1: Add a helper pnfs_commit_and_return_layout
      SUNRPC: Add barriers to ensure read ordering in
rpc_wake_up_task_queue_locked

Tsutomu Itoh (1):
      Btrfs: fix memory leak in btrfs_create_tree()

Veaceslav Falico (2):
      pch_gbe: fix ip_summed checksum reporting on rx
      bonding: remove already created master sysfs link on failure

Vikas Sajjan (1):
      drm/exynos: modify the compatible string for exynos fimd

Vineet Gupta (6):
      ARC: MAINTAINERS update for ARC
      ARC: make allyesconfig build breakages
      ARC: ABIv3: Print the correct ABI ver
      ARC: ABIv3: fork/vfork wrappers not needed in "no-legacy-syscall" ABI
      ARC: Remove SET_PERSONALITY (tracks cross-arch change)
      ARC: Fix the typo in event identifier flags used by ptrace

Vinicius Costa Gomes (1):
      Bluetooth: Fix not closing SCO sockets in the BT_CONNECT2 state

Vinit Agnihotri (1):
      IB/qib: change QLogic to Intel

Viresh Kumar (1):
      cpufreq: acpi-cpufreq: Don't set policy->related_cpus from .init()

Vivek Gautam (1):
      usb: xhci: Fix TRB transfer length macro used for Event TRB.

Wang Shilong (2):
      Btrfs: fix missing qgroup reservation before fallocating
      Btrfs: fix double free in the btrfs_qgroup_account_ref()

Wang YanQing (1):
      serial: 8250_pci: Add WCH CH352 quirk to avoid Xscale detection

Wei Yongjun (8):
      lpc_eth: fix error return code in lpc_eth_drv_probe()
      lantiq_etop: use free_netdev(netdev) instead of kfree()
      mtip32xx: fix error return code in mtip_pci_probe()
      loop: fix error return code in loop_add()
      cciss: fix invalid use of sizeof in cciss_find_cfgtables()
      RDMA/cxgb4: Fix error return code in create_qp()
      x86, io_apic: remove duplicated include from irq_remapping.c
      mg_disk: fix error return code in mg_probe()

Yinghai Lu (1):
      PCI / ACPI: hold acpi_scan_lock during root bus hotplug

YoungJun Cho (6):
      drm/exynos: Fix error routine to getting dma addr.
      drm/exynos: clear node object type at gem unmap
      drm/exynos: Fix G2D core malfunctioning issue
      drm/exynos: Clean up some G2D codes for readability
      drm/exynos: Deal with g2d buffer info more efficiently
      drm/exynos: Check g2d cmd list for g2d restrictions

Yuchung Cheng (1):
      tcp: undo spurious timeout after SACK reneging

Zoltan Kiss (1):
      xen/blkback: Change statistics counter types to unsigned

dingtianhong (1):
      af_unix: dont send SCM_CREDENTIAL when dest socket is NULL

fanchaoting (1):
      pnfs-block: removing DM device maybe cause oops when call dev_remove

viresh kumar (1):
      cpufreq: stats: do cpufreq_cpu_put() corresponding to cpufreq_cpu_get()

xunleer (1):
      ixgbevf: don't release the soft entries
