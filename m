Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3JFVWD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 17:22:03 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:39862 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab3JFVV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 17:21:58 -0400
MIME-Version: 1.0
Date: Sun, 6 Oct 2013 14:21:57 -0700
X-Google-Sender-Auth: vWcnmOFURaIjcz2YKc5UGr3mS5s
Message-ID: <CA+55aFzxjBV5fXZs9Bb=_z+qBixOwU1K2y=Dk1D-CfPcvmSmYA@mail.gmail.com>
Subject: Linux 3.12-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. rc4 has more new commits than rc3, which doesn't make me feel all
warm and fuzzy, but nothing major really stands out. More filesystem
upfates than normal at this stage, perhaps, but I suspect that is just
happenstance. We have cifs, xfs, btrfs, fuse and nilfs2 fixes here.

There's the usual driver updates too (mainly net and target this time
around), along with some generic networking changes too. And some arch
updates (arm, power, s+core, avr32).

But nothing scary, so go out and test.

                 Linus

---

AKASHI Takahiro (1):
      arm64: avoid multiple evaluation of ptr in get_user/put_user()

Aida Mynzhasova (2):
      powerpc/83xx: gianfar_ptp: select 1588 clock source through dts file
      powerpc/83xx: gianfar_ptp: select 1588 clock source through dts file

Ajit Khaparde (7):
      be2net: Fix to prevent Tx stall on SH-R when packet size < 32
      be2net: Fix the size of be_nic_res_desc structure
      be2net: Fix VLAN promiscuous mode programming
      be2net: Fix number of VLANs supported in UMC mode for BE3-R.
      be2net: Fix to allow VLAN configuration on VF interfaces.
      be2net: Fix to configure VLAN priority for a VF interface.
      be2net: Fix to display the VLAN priority for a VF

Al Viro (3):
      ocfs2: needs ->d_lock to poke in ->d_parent->d_inode from ->d_revalidate()
      afs: dget_parent() can't return a negative dentry
      fs/super.c: fix lru_list leak for real

Aleksander Morgado (1):
      net: qmi_wwan: fix Cinterion PLXX product ID

Alexey Khoroshilov (2):
      can: pcan_usb_core: fix memory leak on failure paths in peak_usb_start()
      p54usb: fix leak at failure path in p54u_load_firmware()

Amitkumar Karwar (1):
      mwifiex: fix hang issue for USB chipsets

Andre Guedes (2):
      Bluetooth: Fix security level for peripheral role
      Bluetooth: Fix encryption key size for peripheral role

Andre Naujoks (3):
      slip/slcan: added locking in wakeup function
      lib: introduce upper case hex ascii helpers
      slcan: rewrite of slc_bump and slc_encaps

Andrew Lunn (1):
      ARM: Kirkwood: Add missing DT reg property to cpu@0

Andrew Morton (1):
      include/asm-generic/vtime.h: avoid zero-length file

Anna Schumaker (1):
      NFS: Give "flavor" an initial value to fix a compile warning

Arend van Spriel (3):
      brcmfmac: obtain platform data upon module initialization
      bcma: make bcma_core_pci_{up,down}() callable from atomic context
      brcmsmac: call bcma_core_pci_power_save() from non-atomic context

Ariel Elior (3):
      bnx2x: Fix support for VFs on some PFs
      bnx2x: add missing VF resource allocation during init
      bnx2x: handle known but unsupported VF messages

Arnaud Ebalard (3):
      ARM: mvebu: fix ReadyNAS 102 Power button GPIO to make it active high
      ARM: mvebu: Add DT entry for ReadyNAS 102 to use gpio-poweroff driver
      ARM: mvebu: add missing DT Mbus ranges and relocate PCIe DT
nodes for RN102

Axel Lin (2):
      regulator: palmas: Remove wrong comment for the equation
calculating num_voltages
      regulator: wm831x-ldo: Fix max_uV for gp_ldo and aldo linear
range settings

Barry Song (4):
      ARM: dts: makefile: build atlas6-evb.dtb for ARCH_ATLAS6
      ARM: dts: sirf: fix the ranges of peri-iobrg of prima2
      MAINTAINERS: ARM: SIRF: add missed drivers into maintain list
      MAINTAINERS: ARM: SIRF: use kernel.org mail box

Bartlomiej Zolnierkiewicz (2):
      MIPS: Alchemy: MTX-1: fix incorrect placement of __initdata tag
      ethernet: moxa: fix incorrect placement of __initdata tag

Benjamin LaHaise (1):
      aio: fix use-after-free in aio_migratepage

Bin Liu (2):
      usb: musb: fix otg default state
      usb: musb: gadget: fix otg active status flag

Bing Zhao (2):
      mwifiex: fix PCIe hs_cfg cancel cmd timeout
      mwifiex: fix NULL pointer dereference in usb suspend handler

Bjorn Helgaas (1):
      Revert "x86/PCI: MMCONFIG: Check earlier for MMCONFIG region at
address zero"

Brian Norris (1):
      ARM: davinci: dm365 evm: fix unused variable warning

Catalin\(ux\) M. BOIE (1):
      IPv6 NAT: Do not drop DNATed 6to4/6rd packets

Christian Lamparter (1):
      p54usb: add USB ID for Corega WLUSB2GTST USB adapter

Christian Ruppert (1):
      ARC: Fix signal frame management for SA_SIGINFO

Dan Aloni (1):
      fs/binfmt_elf.c: prevent a coredump with a large vm_map_count from Oopsing

Dan Carpenter (6):
      ASoC: max98095: a couple array underflows
      ASoC: ab8500-codec: info leak in anc_status_control_put()
      ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()
      iommu/arm-smmu: fix a signedness bug
      iommu/arm-smmu: fix iommu_present() test in init
      pinctrl: remove an unnecessary cast

Daniel Pieczko (2):
      sfc: Wait for MC reboot to complete before scheduling driver reset
      sfc: Increase MCDI status timeout to 250ms

Darrick J. Wong (2):
      mm/bounce.c: fix a regression where MS_SNAP_STABLE (stable pages
snapshotting) was ignored
      btrfs: Fix crash due to not allocating integrity data for a bioset

Dave Chinner (2):
      xfs: lockdep needs to know about 3 dquot-deep nesting
      xfs: dirent dtype presence is dependent on directory magic numbers

David Cohen (1):
      usb: chipidea: add Intel Clovertrail pci id

David Herrmann (1):
      x86/simplefb: Mark framebuffer mem-resources as IORESOURCE_BUSY
to avoid bootup warning

David Howells (1):
      CIFS: FS-Cache: Uncache unread pages in cifs_readpages() before
freeing them

David Miller (1):
      mm: Fix generic hugetlb pte check return type.

David Rientjes (1):
      mm/compaction.c: periodically schedule when freeing pages

David S. Miller (2):
      sparc64: Fix buggy strlcpy() conversion in ldom_reboot().
      Revert "powerpc/83xx: gianfar_ptp: select 1588 clock source
through dts file"

David Vrabel (1):
      xen/hvc: allow xenboot console to be used again

Davidlohr Bueso (1):
      ipc,msg: prevent race with rmid in msgsnd,msgrcv

Denis CIOCCA (1):
      iio:magnetometer: Bugfix magnetometer default output registers

Duan Jiong (2):
      net: udp: do not report ICMP redirects to user space
      net: raw: do not report ICMP redirects to user space

Eilon Greenstein (1):
      bnx2x: Prevent mistaken hangup between driver & FW

Eric Dumazet (5):
      net: net_secret should not depend on TCP
      net: flow_dissector: fix thoff for IPPROTO_AH
      pkt_sched: fq: qdisc dismantle fixes
      tcp: TSQ can use a dynamic limit
      pkt_sched: fq: rate limiting improvements

Eric W. Biederman (2):
      net: Delay default_device_exit_batch until no devices are unregistering v2
      net: Update the sysctl permissions handler to test effective uid/gid

Ezequiel Garcia (2):
      ARM: mvebu: Add the reference 25 MHz fixed-clock to Armada XP
      ARM: mvebu: Add clock properties to Armada XP timer node

Felipe Pena (1):
      arch/parisc/mm/fault.c: fix uninitialized variable usage

Felix Fietkau (4):
      ath9k: fix stale flag handling on buffer clone
      ath9k: do not link bf_next across multiple A-MPDUs
      ath9k: don't use BAW tracking on PS responses for non-AMPDU packets
      ath9k: add txq locking for ath_tx_aggr_start

Frederic Weisbecker (1):
      irq: Force hardirq exit's softirq processing on its own stack

Gabor Juhos (2):
      avr32: fix clockevents kernel warning
      avr32: cast syscall_return to silence compiler warning

Geert Uytterhoeven (1):
      regulator: da9063: Fix PTR_ERR/ERR_PTR mismatch

Gianluca Anzolin (1):
      Bluetooth: don't release the port in rfcomm_dev_state_change()

Gleb Natapov (2):
      KVM: VMX: do not check bit 12 of EPT violation exit
qualification when undefined
      Fix NULL dereference in gfn_to_hva_prot()

Guennadi Liakhovetski (1):
      ARM: shmobile: update SDHI DT compatibility string to the
<unit>-<soc> format

Hannes Frederic Sowa (2):
      ipv6: udp packets following an UFO enqueued packet need also be
handled by UFO
      ipv6: gre: correct calculation of max_headroom

Ian Abbott (1):
      staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice

Ilya Dryomov (2):
      Btrfs: eliminate races in worker stopping code
      Btrfs: fix a use-after-free bug in btrfs_dev_replace_finishing

Jack Wang (1):
      ib_srpt: always set response for task management

Jason Gunthorpe (1):
      bus: mvebu-mbus: Fix optional pcie-mem/io-aperture properties

Javier Martinez Canillas (2):
      gpio/omap: maintain GPIO and IRQ usage separately
      gpio/omap: auto-setup a GPIO when used as an IRQ

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: sam9g45: shutdown ddr1 too when rebooting

Jeff Layton (1):
      cifs: stop trying to use virtual circuits

Jesse Brandeburg (5):
      i40e: use common failure flow
      i40e: small clean ups from review
      i40e: convert ret to aq_ret
      i40e: better return values
      i40e: clean up coccicheck reported errors

Jiang Liu (1):
      arm64: fix possible invalid FPSIMD initialization state

Jim McDonough (1):
      [CIFS] Provide sane values for nlink

Jiri Prchal (1):
      ARM: at91: serial: fix wrong pinctrl_usart2_rts

Jisheng Zhang (2):
      ARM: mvebu: add missing of_node_put() to fix reference leak
      bus: mvebu: add missing of_node_put() to fix reference leak

Joel Fernandes (1):
      ARM: edma: Fix clearing of unused list for DT DMA resources

Joerg Roedel (1):
      ARM: mach-integrator: Add stub for pci_v3_early_init() for !CONFIG_PCI

Johan Hedberg (2):
      Bluetooth: Introduce a new HCI_RFKILLED flag
      Bluetooth: Fix rfkill functionality during the HCI setup stage

Johan Hovold (2):
      usb: gadget: pxa25x_udc: fix deferred probe from __init
      usb: phy: gpio-vbus: fix deferred probe from __init

John Johansen (1):
      apparmor: fix suspicious RCU usage warning in policy.c/policy.h

Joonyoung Shim (1):
      revert "mm/memory-hotplug: fix lowmem count overflow when offline pages"

Josef Bacik (1):
      Btrfs: fix transid verify errors when recovering log tree

Josh Boyer (2):
      edma: Update author email address
      dma/Kconfig: Make TI_EDMA select TI_PRIV_EDMA

Julian Anastasov (4):
      ipvs: make the service replacement more robust
      ipvs: do not use dest after ip_vs_dest_put in LBLC
      ipvs: do not use dest after ip_vs_dest_put in LBLCR
      ipvs: stats should not depend on CPU 0

Kees Cook (1):
      sparc: fix ldom_reboot buffer overflow harder

Ken O'Brien (1):
      Bluetooth: btusb: Add support for Belkin F8065bf

Kuninori Morimoto (1):
      ARM: shmobile: armadillo: fixup ether pinctrl naming

Larry Finger (1):
      rtlwifi: Align private space in rtl_priv struct

Lars-Peter Clausen (1):
      iio: Remove debugfs entries in iio_device_unregister()

Laurent Pinchart (2):
      gpio: rcar: Remove #gpio-range-cells DT property usage
      ARM: shmobile: Remove #gpio-ranges-cells DT property

Laxman Dewangan (4):
      regulator: palmas: fix the n_voltages for smps to 122
      regulator: palmas: configure enable time for LDOs
      regulator: wm8350: correct the max_uV of LDO
      pinctrl: palmas: do not abort pin configuration for BIAS_DEFAULT

Lennox Wu (4):
      Score: The commit is for compiling successfully.     The
modifications include:     1. Kconfig of Score: we don't support
ioremap     2. Missed headfile including     3. There are some errors
in other people's commit not checked by us, we fix it now     3.1
arch/score/kernel/entry.S: wrong instructions     3.2
arch/score/kernel/process.c : just some typos
      Score: Implement the function csum_ipv6_magic
      Score: Modify the Makefile of Score, remove -mlong-calls for compiling
      Score: Update the information of Score maintaners

Li, Zhen-Hua (1):
      x86/iommu: correct ICS register offset

Liam Girdwood (1):
      ASoC: core: Only add platform DAI widgets once.

Linus Torvalds (4):
      selinux: remove 'flags' parameter from inode_has_perm
      selinux: avc_has_perm_flags has no more users
      selinux: remove 'flags' parameter from avc_audit()
      Linux 3.12-rc4

Liu Bo (1):
      Btrfs: fix crash of compressed writes

Lorenzo Pieralisi (1):
      ARM: vexpress: tc2: fix hotplug/idle/kexec race on cluster power down

Lubomir Rintel (1):
      sysv: Add forgotten superblock lock init for v7 fs

Madhavan Srinivasan (1):
      powerpc/sysfs: Disable writing to PURR in guest mode

Manfred Spraul (4):
      ipc/sem.c: fix race in sem_lock()
      ipc/sem.c: optimize sem_lock()
      ipc/sem.c: synchronize the proc interface
      ipc/sem.c: update sem_otime for all operations

Manish Chopra (1):
      qlcnic: Fix SR-IOV configuration

Marc Kleine-Budde (1):
      can: flexcan: fix flexcan_chip_start() on imx6

Mateusz Krawczuk (1):
      pinctrl: Correct number of pins for s5pv210

Matthew Leach (1):
      arm64: use correct register width when retrieving ASID

Maxim Patlasov (2):
      fuse: wait for writeback in fuse_file_fallocate()
      fuse: fix fallocate vs. ftruncate race

Michael Ellerman (1):
      powerpc/perf: Fix handling of FAB events

Michael Grzeschik (3):
      dmaengine: imx-dma: fix slow path issue in prep_dma_cyclic
      dmaengine: imx-dma: fix lockdep issue between irqhandler and tasklet
      dmaengine: imx-dma: fix callback path in tasklet

Michael Neuling (2):
      powerpc/tm: Turn interrupts hard off in tm_reclaim()
      powerpc/tm: Switch out userspace PPR and DSCR sooner

Michael Opdenacker (2):
      ARM: at91: remove IRQF_DISABLED
      sparc: remove deprecated IRQF_DISABLED

Michal Malý (1):
      USB: serial: option: Ignore card reader interface on Huawei E1750

Miklos Szeredi (3):
      fuse: don't check_submounts_and_drop() in RCU walk
      fuse: readdirplus: fix RCU walk
      fuse: no RCU mode in fuse_access()

Mikulas Patocka (1):
      skge: fix invalid value passed to pci_unmap_sigle

Ming Lei (1):
      USBNET: fix handling padding packet

Mischa Jonker (1):
      ARC: Handle zero-overhead-loop in unaligned access handler

Nathan Fontenot (1):
      powerpc: Fix memory hotplug with sparse vmemmap

Neil Horman (1):
      bonding: Fix broken promiscuity reference counting issue

Nicholas Bellinger (10):
      target: Fix xop->dbl assignment in target_xcopy_parse_segdesc_02
      ib_srpt: Destroy cm_id before destroying QP.
      vhost/scsi: Use GFP_ATOMIC with percpu_ida_alloc for obtaining tag
      target: Fall back to vzalloc upon ->sess_cmd_map kzalloc failure
      target: Reset data_length for COMPARE_AND_WRITE to NoLB * block_size
      target: Fix recursive COMPARE_AND_WRITE callback failure
      target: Fail on non zero scsi_status in compare_and_write_callback
      iscsi-target: Only perform wait_for_tasks when performing shutdown
      iscsi-target: Perform release of acknowledged tags from RX context
      iscsi-target; Allow an extra tag_num / 2 number of percpu_ida tags

Nicolas Dichtel (3):
      skbuff: size of hole is wrong in a comment
      sit: allow to use rtnl ops on fb tunnel
      ip6tnl: allow to use rtnl ops on fb tunnel

Nicolas Ferre (1):
      ARM: at91: at91sam9x5: set default mmc[01] pinctrl-names

Nishanth Aravamudan (1):
      powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_table()

Nishanth Menon (1):
      regulator: ti-abb: Fix bias voltage glitch in transition to bypass mode

Noel Burton-Krahn (1):
      mrp: add periodictimer to allow retries when packets get lost

Oleg Nesterov (1):
      pidns: fix free_pid() to handle the first fork failure

Olof Johansson (2):
      ARM: kvm: rename cpu_reset to avoid name clash
      ARM: multi_v7_defconfig: add SDHCI for i.MX

Ondrej Zary (1):
      ALSA: ac97: Add ID for TI TLV320AIC27 codec

Patrick McHardy (1):
      netfilter: synproxy: fix BUG_ON triggered by corrupt TCP packets

Paul Durrant (1):
      xen-netback: Handle backend state transitions in a more robust way

Paul E. McKenney (2):
      powerpc: Fix parameter clobber in csum_partial_copy_generic()
      powerpc: Restore registers on error exit from csum_partial_copy_generic()

Paul Gortmaker (1):
      block: change config option name for cmdline partition parsing

Paul Marks (1):
      ipv6: Fix preferred_lft not updating in some cases

Peng Chen (1):
      Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.

Peter Hurley (1):
      tty: Fix pty master read() after slave closes

Peter Korsgaard (1):
      dm9601: fix IFF_ALLMULTI handling

Philipp Zabel (3):
      ASoC: imx-sgtl5000: do not use devres on a foreign device
      ASoC: imx-sgtl5000: Fix uninitialized pointer use in error path
      cpufreq: cpufreq-cpu0: NULL is a valid regulator, part 2

Prarit Bhargava (1):
      powerpc/vio: Fix modalias_show return values

Pravin B Shelar (2):
      vxlan: Use RCU apis to access sk_user_data.
      ip_tunnel: Do not use stale inner_iph pointer.

Qipan Li (1):
      ARM: dts: sirf: fix fifosize, clks, dma channels for UART

Quentin Armitage (1):
      ARM: kirkwood: Fix address of second XOR engine

Rafael Aquini (1):
      mm: avoid reinserting isolated balloon pages into LRU lists

Rafael J. Wysocki (2):
      PM / hibernate: Fix user space driven resume regression
      ACPI: Use EXPORT_SYMBOL() for acpi_bus_get_device()

Ramkumar Ramachandra (2):
      arm64: include EXT4 in defconfig
      arm64: include VIRTIO_{MMIO,BLK} in defconfig

Randy Dunlap (1):
      regulator: fix fatal kernel-doc error

Raphael Kubo da Costa (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17cb]

Renwei Wu (1):
      ARM: dts: sirf: fix interrupt and dma prop of VIP for prima2 and atlas6

Ricardo Ribalda (1):
      ll_temac: Reset dma descriptors indexes on ndo_open

Robert Baldyga (2):
      usb: gadget: f_fs: fix error handling
      usb: gadget: s3c-hsotg: fix can_write limit for non-periodic endpoints

Roger Luethi (1):
      via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)

Sachin Kamat (2):
      iio: amplifiers: ad8366: Remove regulator_put
      cpufreq: SPEAr: Fix incorrect variable type

Salam Noureddine (2):
      ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put
      ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put

Sebastian Andrzej Siewior (1):
      usb: musb: dsps: do not bind to "musb-hdrc"

Sekhar Nori (1):
      ARM: davinci: fix build breakage with DEBUG_LL

Sergei Shtylyov (1):
      ARM: shmobile: Lager: add Micrel KSZ8041 PHY fixup

Simon Kirby (1):
      ipvs: fix overflow on dest weight multiply

Solomon Peachy (2):
      Revert "cw1200: Don't perform SPI transfers in interrupt context"
      cw1200: Use a threaded oneshot irq handler for cw1200_spi

Srinivas Pandruvada (1):
      intel_pstate: fix no_turbo

Steffen Klassert (4):
      ip_tunnel: Fix a memory corruption in ip_tunnel_xmit
      ip_tunnel: Add fallback tunnels to the hash lists
      ip_tunnel_core: Change __skb_push back to skb_push
      ip_tunnel: Remove double unregister of the fallback device

Stephen Boyd (1):
      arm64: Remove duplicate DEBUG_STACK_USAGE config

Stephen Warren (1):
      MAINTAINERS: add overall IOMMU section

Steve French (2):
      [CIFS] Remove ext2 flags that have been moved to fs.h
      [CIFS] update cifs.ko version

Steven Rostedt (1):
      avr32: use Kbuild infrastructure to handle the asm-generic headers

Sucheta Chakraborty (1):
      qlcnic: Fix register device in FAILED state for 82xx.

Sujith Manoharan (1):
      ath9k: Fix regression in LNA diversity

Syam Sidhardhan (1):
      Bluetooth: Fix ACL alive for long in case of non pariable devices

Takashi Iwai (1):
      ALSA: hda - Fix GPIO for Acer Aspire 3830TG

Tetsuo Handa (1):
      kernel/kmod.c: check for NULL in call_usermodehelper_exec()

Thierry Reding (2):
      pinctrl: tegra114: Remove MODULE_ALIAS
      xfs: Use kmem_free() instead of free()

Thomas Petazzoni (1):
      sparc: fix MSI build failure on Sparc32

Todd Fujinaka (1):
      igb: Fix ethtool loopback test for 82580 copper

Tom Gundersen (1):
      x86/simplefb: Fix overflow causing bogus fall-back

Trond Myklebust (3):
      NFSv4: Honour the 'opened' parameter in the atomic_open()
filesystem method
      NFSv4.1: nfs4_fl_prepare_ds - fix bugs when the connect attempt fails
      NFSv4.1: Ensure memory ordering between nfs4_ds_connect and
nfs4_fl_prepare_ds

Tyler Hicks (1):
      apparmor: Use shash crypto API interface for profile hashes

Uwe Kleine-König (1):
      ARC: Use clockevents_config_and_register over clockevents_register_device

Valentin Ilie (1):
      ASoC: blackfin: Add missing break statement to bf6xx

Vincent Stehlé (1):
      pinctrl: fix pinconf_dbg_config_write return type

Vineet Gupta (2):
      ARC: Fix 32-bit wrap around in access_ok()
      ARC: Workaround spinlock livelock in SMP SystemC simulation

Vlastimil Babka (1):
      mm/mlock.c: prevent walking off the end of a pagetable in no-pmd
configuration

Vyacheslav Dubeyko (1):
      nilfs2: fix issue with race condition of competition between
segments for dirty blocks

Wanpeng Li (4):
      mm/hwpoison: fix traversal of hugetlbfs pages to avoid printk flood
      mm/hwpoison: fix test for a transparent huge page
      mm/hwpoison: fix false report on 2nd attempt at page recovery
      mm/hwpoison: fix the lack of one reference count against poisoned page

Wei Liu (1):
      MAINTAINERS: add myself as maintainer of xen-netback

Weiping Pan (1):
      Documentation/kernel-parameters.txt: replace kernelcore with Movable

Weston Andros Adamson (1):
      NFSv4.1: try SECINFO_NO_NAME flavs until one works

Will Deacon (1):
      iommu/arm-smmu: don't enable SMMU device until probing has completed

Yaniv Rosner (5):
      bnx2x: Generalize KR work-around
      bnx2x: KR2 disablement fix
      bnx2x: 57840 non-external loopback test fail on 1G
      bnx2x: Specific Active-DAC is not detected on 57810
      bnx2x: Fix 848xx duplex settings

Yoichi Yuasa (1):
      MIPS: Fix forgotten preempt_enable() when CPU has inclusive pcaches

Yuval Mintz (2):
      bnx2x: prevent masking error from cnic
      bnx2x: prevent masked MCP parities from appearing

josselin.costanzi@mobile-devices.fr (1):
      net/lapb: re-send packets on timeout

malahal@us.ibm.com (1):
      qlge: call ql_core_dump() only if dump memory was allocated.

tinguely@sgi.com (1):
      xfs: fix memory leak in xlog_recover_add_to_trans
