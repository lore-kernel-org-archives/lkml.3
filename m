Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3LVVfJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 16:35:09 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:58087 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3LVVfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 16:35:05 -0500
MIME-Version: 1.0
Date: Sun, 22 Dec 2013 13:35:03 -0800
X-Google-Sender-Auth: M7DHiUyr7b--59KmhhQpGnHEIqw
Message-ID: <CA+55aFwnPnnx3E4HoLoGiomxDzs9Oz6HM4y2fAkXxU2AJFD90g@mail.gmail.com>
Subject: Linux 3.13-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ho ho ho,
 Christmas is almost upon us, and -rc5 is the last rc before most of
us gorge ourselves into insensibility. Or cry into our lonely beers.
Or go out for Chinese food. Or whatever you happen to do.

Things seem to be slowly calming down, and I expect that the next week
is going to be calmer yet, for all the obvious reasons. This might
also be a good time to say that even _if_ things continue to calm
down, I think we'll be going to at least -rc8 regardless, since LCA is
fairly early this year, and I won't be opening the merge window for
3.14 until after I'm back from those travels.

Anyway, about rc5: about 40% drivers (gpu, networking, sound,
misc-you-name-it), 15% architecture updates (mainly powerpc this
time), 10% filesystems (ceph/cifs), 10% documentation, and the rest
"misc", including some core kernel (scheduler) and mm (numa) fixes.

Nothing really exciting stands out. The bugs I was involved with were
all sufficiently subtle and unusual that I didn't feel like they
raised any red flags at this point, which is just how I want it. It's
the "how did that ever even pass cursory testing" bugs that make me
upset, and if those existed, people were appropriately ashamed and
quiet about them ;)

So despite me planning on dragging out the rc's a bit, there doesn't
actually look to be any real technical reason for doing that, at least
so far. It all looks good, so please jump in and help test,

              Linus

---
Alex Deucher (4):
      drm/radeon: Fix sideport problems on certain RS690 boards
      drm/radeon/cik: plug in missing blit callback
      drm/radeon: add missing display tiling setup for oland
      Revert "drm/radeon: Implement radeon_pci_shutdown"

Alexander Graf (4):
      KVM: PPC: Book3S: PR: Don't clobber our exit handler id
      KVM: PPC: Book3S: PR: Export kvmppc_copy_to|from_svcpu
      KVM: PPC: Book3S: PR: Make svcpu -> vcpu store preempt savvy
      KVM: PPC: Book3S: PR: Enable interrupts earlier

Alexander Shishkin (1):
      perf: Disable all pmus on unthrottling and rescheduling

Alexey Khoroshilov (1):
      can: ems_usb: fix urb leaks on failure paths

Andy Grover (1):
      target: Remove extra percpu_ref_init

Aneesh Kumar K.V (1):
      powerpc: book3s: kvm: Don't abuse host r2 in exit path

Anton Blanchard (8):
      powerpc: Fix endian issue in setup-common.c
      powerpc: Fix topology core_id endian issue on LE builds
      powerpc/pseries: Fix endian issues in /proc/ppc64/lparcfg
      powerpc/pseries: Fix endian issues in nvram code
      powerpc/pseries: Fix PCIE link speed endian issue
      powerpc/pseries: Fix endian issues in MSI code
      powerpc: Fix endian issues in crash dump code
      powerpc/powernv: Fix endian issue in opal_xscom_read

Axel Lin (1):
      clocksource: time-efm32: Select CLKSRC_MMIO

Ben Widawsky (7):
      drm/i915/bdw: Add BDW to ULT macro
      drm/i915/bdw: GEN8 backlight support
      drm/i915/bdw: Do gen6 style reset for gen8
      drm/i915/bdw: Free correct number of ppgtt pages
      drm/i915/bdw: Add comment about gen8 HWS PGA
      drm/i915/bdw: Limit GTT to 2GB
      drm/i915/bdw: PIPE_[BC] I[ME]R moved to powerwell

Benjamin Herrenschmidt (1):
      powerpc/powernv: Fix OPAL LPC access in Little Endian

Benjamin LaHaise (2):
      aio: fix kioctx leak introduced by "aio: Fix a trinity splat"
      aio/migratepages: make aio migrate pages sane

Beomho Seo (1):
      iio: cm36651: Changed return value of read function

Bjørn Mork (1):
      usb: cdc-wdm: manage_power should always set needs_remote_wakeup

Bo Shen (3):
      ASoC: atmel_ssc_dai: add dai trigger ops
      ASoC: sam9x5_wm8731: change to work in DSP A mode
      ASoC: wm8904: fix DSP mode B configuration

Bob Gilligan (1):
      neigh: Netlink notification for administrative NUD state change

Boris BREZILLON (1):
      usb: ohci-at91: fix irq and iomem resource retrieval

Charles Keepax (2):
      ASoC: wm5110: Correct HPOUT3 DAPM route typo
      ASoC: wm_adsp: Add small delay while polling DSP RAM start

Chris Ruehl (1):
      usb: phy-tegra-usb.c: wrong pointer check for remap UTMI

Chris Wilson (3):
      drm/i915: Do not clobber config status after a forced restore of hw state
      drm/i915: Hold mutex across i915_gem_release
      drm/i915: Repeat eviction search after idling the GPU

Christian König (1):
      drm/radeon: fix typo in cik_copy_dma

Christoph Hellwig (1):
      xfs: remove xfsbdstrat error

Dan Carpenter (2):
      usb: phy: twl6030-usb: signedness bug in twl6030_readb()
      drivers: phy: tweaks to phy_create()

Dan Williams (7):
      dma: fix build warnings in ppc4xx
      dma: fix fsldma build warnings
      dmatest: fix build warning on mips
      dma: fix build warnings in txx9
      dmaengine: fix enable for high order unmap pools
      dmaengine: fix sleep in atomic
      net_dma: mark broken

Daniel Vetter (3):
      drm/i915: fix pm init ordering
      drm/i915: Fix use-after-free in do_switch
      drm/i915: don't update the dri1 breadcrumb with modesetting

Dave Chinner (3):
      xfs: align initial file allocations correctly
      xfs: swalloc doesn't align allocations properly
      xfs: abort metadata writeback on permanent errors

David Henningsson (1):
      ALSA: hda - Add enable_msi=0 workaround for four HP machines

David Howells (1):
      X.509: Fix certificate gathering

Davidlohr Bueso (1):
      MAINTAINERS: add Davidlohr as GPT maintainer

Dinh Nguyen (2):
      clocksource: dw_apb_timer_of: Fix read_sched_clock
      clocksource: dw_apb_timer_of: Fix support for dts binding
"snps,dw-apb-timer"

Dmitry Kunilov (1):
      usb: serial: zte_ev: move support for ZTE AC2726 from zte_ev
back to option

Eric Dumazet (1):
      udp: ipv4: do not use sk_dst_lock from softirq context

Eric Leblond (1):
      netfilter: nft_reject: fix endianness in dump function

Eric Seppanen (1):
      iscsi-target: return -EINVAL on oversized configfs parameter

Eric Trudeau (1):
      XEN: Grant table address, xen_hvm_resume_frames, is a phys_addr not a pfn

Ezequiel Garcia (2):
      clocksource: armada-370-xp: Register sched_clock after the counter reset
      dma: mv_xor: Use dmaengine_unmap_data for the self-tests

Fabio Estevam (1):
      usb: chipidea: host: Only disable the vbus regulator if it is not NULL

Felipe Balbi (1):
      usb: phy: fix driver dependencies

Geert Uytterhoeven (1):
      sh: always link in helper functions extracted from libgcc

H Hartley Sweeten (1):
      staging: comedi: drivers: fix return value of comedi_load_firmware()

Hannes Frederic Sowa (1):
      ipv4: improve documentation of ip_no_pmtu_disc

Himanshu Madhani (4):
      qlcnic: Fix usage of netif_tx_{wake, stop} api during link change.
      qlcnic: Fix diagnostic test for all adapters.
      qlcnic: Fix TSS/RSS ring validation logic.
      qlcnic: Fix TSS/RSS validation for 83xx/84xx series adapter.

Hui Wang (2):
      ALSA: hda - Add Dell headset detection quirk for three laptop models
      ALSA: hda - Add Dell headset detection quirk for one more laptop model

Ian Abbott (1):
      staging: comedi: 8255_pci: fix for newer PCI-DIO48H

Ian Campbell (2):
      xen: privcmd: do not return pages which we have failed to unmap
      arm: xen: foreign mapping PTEs are special.

Ilia Mirkin (2):
      drm: don't double-free on driver load error
      drm/nouveau: only runtime suspend by default in optimus configuration

Jakob Bornecrantz (1):
      drm/vmwgfx: Add max surface memory param

James Hogan (1):
      serial: 8250_dw: Fix LCR workaround regression

James Solner (1):
      Add Documentation/module-signing.txt file

Jan Beulich (1):
      fix build with make 3.80

Jason Cooper (1):
      dma: mv_xor: remove mv_desc_get_dest_addr()

Jason Wang (1):
      netvsc: don't flush peers notifying work during setting mtu

Jean-Francois Moine (1):
      ASoC: kirkwood: Fix the CPU DAI rates

Jianguo Wu (2):
      mm/memory-failure.c: recheck PageHuge() after hugetlb page
migrate successfully
      mm/hugetlb: check for pte NULL pointer in __page_check_address()

Jie Liu (3):
      xfs: fix false assertion at xfs_qm_vop_create_dqattach
      xfs: fix assertion failure at xfs_setattr_nonsize
      xfs: fix infinite loop by detaching the group/project hints from
user dquot

Johannes Weiner (2):
      mm: page_alloc: exclude unreclaimable allocations from zone
fairness policy
      mm: page_alloc: revert NUMA aspect of fair allocation policy

Jonathan Cameron (3):
      staging:iio:mag:hmc5843 fix incorrect endianness of channel as a
result of missuse of the IIO_ST macro.
      iio:imu:adis16400 fix pressure channel scan type
      iio:adc:ad7887 Fix channel reported endianness from cpu to big endian

JongHo Kim (1):
      ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function

Joonsoo Kim (2):
      mm/mempolicy: correct putback method for isolate pages if failed
      mm/compaction: respect ignore_skip_hint in update_pageblock_skip

Josh Boyer (1):
      cpupower: Fix segfault due to incorrect getopt_long arugments

Julien Grall (1):
      xen/block: Correctly define structures in public headers on
ARM32 and ARM64

Kirill A. Shutemov (2):
      mm: Fix NULL pointer dereference in madvise(MADV_WILLNEED) support
      mm: do not allocate page->ptl dynamically, if spinlock_t fits to long

Kirill Tkhai (2):
      KEYS: Remove files generated when SYSTEM_TRUSTED_KEYRING=y
      sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities

Kishon Vijay Abraham I (3):
      usb: dwc3: invoke phy_resume after phy_init
      usb: dwc3: power off usb phy in error path
      phy: kconfig: add depends on "USB_PHY" to OMAP_USB2 and TWL4030_USB

Krzysztof Kozlowski (1):
      mfd: s2mps11: Fix build after regmap field rename in sec-core.c

Laurent Pinchart (2):
      irqchip: renesas-intc-irqpin: Fix register bitfield shift calculation
      sh-pfc: Fix PINMUX_GPIO macro

Li Wang (1):
      ceph: Avoid data inconsistency due to d-cache aliasing in readpage()

Linus Torvalds (3):
      Don't set the INITRD_COMPRESS environment variable automatically
      aio: clean up and fix aio_setup_ring page mapping
      Linux 3.13-rc5

Linus Walleij (1):
      MAINTAINERS: update GPIO maintainers entry

Magnus Damm (1):
      ARM: shmobile: r8a7790: Fix GPIO resources in DTS

Manish Chopra (2):
      qlcnic: Fix memory allocation
      qlcnic: Allow firmware dump collection when auto firmware
recovery is disabled

Manish chopra (2):
      qlcnic: Fix mailbox processing during diagnostic test
      qlcnic: Dump mailbox registers when mailbox command times out.

Marc Kleine-Budde (1):
      can: peak_usb: fix mem leak in pcan_usb_pro_init()

Marc Zyngier (1):
      clocksource: sunxi: Stop timer from ticking before enabling interrupts

Maria Dimakopoulou (1):
      perf/x86: Fix constraint table end marker bug

Mark Tinguely (1):
      xfs: fix memory leak in xfs_dir2_node_removename

Martin Andersson (1):
      drm/radeon/dpm: Fix hwmon crash

Mel Gorman (14):
      sched: Assign correct scheduling domain to 'sd_llc'
      mm: numa: serialise parallel get_user_page against THP migration
      mm: numa: call MMU notifiers on THP migration
      mm: clear pmd_numa before invalidating
      mm: numa: do not clear PMD during PTE update scan
      mm: numa: do not clear PTE for pte_numa update
      mm: numa: ensure anon_vma is locked to prevent parallel THP splits
      mm: numa: avoid unnecessary work on the failure path
      sched: numa: skip inaccessible VMAs
      mm: numa: clear numa hinting information on mprotect
      mm: numa: avoid unnecessary disruption of NUMA hinting during migration
      mm: numa: guarantee that tlb_flush_pending updates are visible
before page table updates
      mm: numa: defer TLB flush for THP migration as long as possible
      Revert "mm: page_alloc: exclude unreclaimable allocations from
zone fairness policy"

Miao Xie (1):
      ftrace: Initialize the ftrace profiler for each possible cpu

Mika Westerberg (1):
      serial: 8250_dw: add new ACPI IDs

Namjae Jeon (1):
      MAINTAINERS: fix incorrect mail address of XFS maintainer

Nicholas Bellinger (5):
      iscsi-target: Fix-up all zero data-length CDBs with R/W_BIT set
      iscsi-target: Fix incorrect np->np_thread NULL assignment
      iser-target: Move INIT_WORK setup into isert_create_device_ib_res
      target/file: Update hw_max_sectors based on current block_size
      qla2xxx: Fix scsi_host leak on qlt_lport_register callback failure

Nicolin Chen (3):
      ASoC: soc-pcm: Use valid condition for
snd_soc_dai_digital_mute() in hw_free()
      ASoC: wm8962: Enable SYSCLK provisonally before fetching
generated DSPCLK_DIV
      ASoC: fsl: imx-wm8962: Don't update bias_level in machine driver

Olof Johansson (2):
      dmaengine: at_hdmac: remove unused function
      mm: fix build of split ptlock code

Patrick McHardy (1):
      netfilter: SYNPROXY target: restrict to INPUT/FORWARD

Paul Mackerras (5):
      KVM: PPC: Book3S HV: Fix physical address calculations
      KVM: PPC: Book3S HV: Refine barriers in guest entry/exit
      KVM: PPC: Book3S HV: Make tbacct_lock irq-safe
      KVM: PPC: Book3S HV: Take SRCU read lock around kvm_read_guest() call
      KVM: PPC: Book3S HV: Don't drop low-order page address bits

Peter Chen (1):
      usb: chipidea: fix nobody cared IRQ when booting with host role

Peter Hurley (2):
      tty: Fix hang at ldsem_down_read()
      n_tty: Fix apparent order of echoed output

Peter Zijlstra (4):
      sched: Initialize power_orig for overlapping groups
      sched: Remove PREEMPT_NEED_RESCHED from generic code
      math64: Add mul_u64_u32_shr()
      sched/fair: Rework sched_fair time accounting

Rafał Miłecki (1):
      drm/edid: add quirk for BPC in Samsung NP700G7A-S01PL notebook

Rik van Riel (1):
      mm: fix TLB flush race between migration, and change_protection_range

Roger Quadros (1):
      gpio: twl4030: Fix regression for twl gpio LED output

Roland Dreier (1):
      target: Remove write-only stats fields and lock from struct se_node_acl

Russell King (12):
      DRM: Armada: implement lastclose() for fbhelper
      DRM: Armada: destroy framebuffer after helper
      DRM: Armada: fix printing of phys_addr_t/dma_addr_t
      DRM: Armada: prime refcounting bug fix
      dmaengine: mv_xor: fix oops when channels fail to initialise
      imx-drm: imx-drm-core: fix error cleanup path for imx_drm_add_crtc()
      imx-drm: imx-drm-core: fix DRM cleanup paths
      imx-drm: ipu-v3: fix potential CRTC device registration race
      imx-drm: imx-tve: don't call sleeping functions beneath
enable_lock spinlock
      imx-drm: imx-drm-core: use defined constant for number of CRTCs.
      imx-drm: imx-drm-core: make imx_drm_crtc_register() safer
      imx-drm: imx-drm-core: improve safety of imx_drm_add_crtc()

Sachin Kamat (1):
      drivers: phy: Fix memory leak

Santosh Shilimkar (2):
      MAINTAINERS: Add keystone git tree information
      MAINTAINERS: Add keystone clock drivers

Sasha Levin (1):
      net: unix: allow bind to fail on mutex lock

Scott Wood (1):
      powerpc/kvm/booke: Fix build break due to stack frame size warning

Shivaram Upadhyayula (1):
      qla2xxx: Fix schedule_delayed_work() for target timeout calculations

Sima Baymani (1):
      mm: add missing dependency in Kconfig

Simon Horman (1):
      ARM: shmobile: lager: phy fixup needs CONFIG_PHYLIB

Soren Brinkmann (1):
      tty: xuartps: Properly guard sysrq specific code

Stefan Richter (1):
      firewire: sbp2: bring back WRITE SAME support

Stefano Stabellini (2):
      xen/arm64: do not call the swiotlb functions twice
      xen/balloon: Seperate the auto-translate logic properly (v2)

Steffen Klassert (1):
      MAINTAINERS: Update the IPsec maintainer entry

Stephen Boyd (1):
      gpio: msm: Fix irq mask/unmask by writing bits instead of numbers

Stephen Warren (2):
      ASoC: tegra: fix uninitialized variables in set_fmt
      ASoC: don't leak on error in snd_dmaengine_pcm_register

Takashi Iwai (1):
      xhci: Limit the spurious wakeup fix only to HP machines

Tejun Heo (1):
      sysfs: give different locking key to regular and bin files

Thierry Reding (1):
      clocksource: clksrc-of: Do not drop unheld reference on device node

Thomas Hellstrom (1):
      drm/ttm: Fix accesses through vmas with only partial coverage

Tomasz Figa (1):
      ARM: s3c64xx: dt: Fix boot failure due to double clock initialization

Tomi Valkeinen (1):
      Revert "ARM: OMAP2+: Remove legacy mux code for display.c"

Tony Luck (1):
      pstore: Don't allow high traffic options on fragile devices

Ulrich Weigand (1):
      powerpc: PTRACE_PEEKUSR always returns FPR0

Valentine Barshak (1):
      gpio: rcar: Fix level interrupt handling

Ville Syrjälä (2):
      drm/i915: Take modeset locks around intel_modeset_setup_hw_state()
      drm/i915: Skip clock checks on BDW

Vince Weaver (1):
      perf: Document the new transaction sample type

Vineet Gupta (1):
      ARC: Allow conditional multiple inclusion of uapi/asm/unistd.h

Vivek Goyal (1):
      kexec: migrate to reboot cpu

Wanpeng Li (1):
      mm/mempolicy: fix !vma in new_vma_page()

Wei Yongjun (2):
      iser-target: fix error return code in isert_create_device_ib_res()
      xen-netback: fix fragments error handling in checksum_setup_ip()

Will Deacon (2):
      dma: pl330: ensure DMA descriptors are zero-initialised
      arm64: ptrace: avoid using HW_BREAKPOINT_EMPTY for disabled events

Xiao Guangrong (1):
      KEYS: fix uninitialized persistent_keyring_register_sem

Yan, Zheng (1):
      ceph: initialize inode before instantiating dentry

pingfan liu (1):
      powerpc: kvm: fix rare but potential deadlock scene

wangweidong (1):
      sctp: loading sctp when load sctp_probe
