Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab3FICFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 22:05:21 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:57949 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3FICFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 22:05:17 -0400
MIME-Version: 1.0
Date: Sat, 8 Jun 2013 19:05:16 -0700
X-Google-Sender-Auth: oH-8Zwq4T-GnH6io_RJ6PPQ3EQY
Message-ID: <CA+55aFzJpBiHKYz7YHOepom6==s=_FhPBft3xRfuF3fDRzMOoA@mail.gmail.com>
Subject: Linux 3.10-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it's that time again - another week or so has passed, and a new
release candidate is made in order to encourage and remind people to
try things out.

I wish I could say that things are calming down, but I'd be lying. rc5
is noticeably bigger than rc4, both in number of commits and in files
changed (although rc4 actually had more lines changed, so there's
that).

Guys, guys, guys. I'm going to have to start cursing again unless you
stop sending me non-critical stuff. So the next pull request I get
that has "cleanups" or just pointless churn, I'm going to call you
guys out on, and try to come up with new ways to insult you, your
mother, and your deceased pet hamster.

So don't do it. Send me just fixes to serious problems. Ok?

Anyway, the rc5 changes are pretty much all over: pretty much exactly
half are drivers (networking, usb, gpu, mmc, sound..), with the other
half being various other subsystems. Some arch updates: MIPS, arm,
smattering of ia64, microblaze, s390 and some x86. And networking
(non-driver), xfs, fuse, gfs2, jfs..

So there's more than I'd like, but at least none of it looks particularly scary.

Go out and test. And again - please don't make me curse you and your pets.

              Linus

---
Aaron Lu (1):
      ACPI / scan: do not match drivers against objects having scan handlers

Adis Hamzić (1):
      radeon: Fix system hang issue when using KMS with older cards

Adrian Hunter (3):
      mmc: sdhci-acpi: fix initial runtime pm status
      mmc: sdhci-acpi: add more device ids
      mmc: sdhci-pci: add more device ids

Alan Stern (2):
      USB: revert periodic scheduling bugfix
      USB: EHCI: fix regression related to qh_refresh()

Alex Deucher (1):
      drm/radeon: don't allow audio on DCE6

Alex Hung (1):
      ACPI / video: ignore BIOS initial backlight value for HP m4

Alexander Stein (1):
      drm/nv84/disp: Fix HDMI audio regression

Alexey Kardashevskiy (1):
      vfio: fix crash on rmmod

Andre Przywara (1):
      ARM: KVM: prevent NULL pointer dereferences with KVM VCPU ioctl

Andrew Lunn (1):
      ARM: Kirkwood: TS219: Fix crash by double PCIe instantiation

Andy Lutomirski (2):
      net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg
      net: Unbreak compat_sys_{send,recv}msg

Andy Shevchenko (1):
      dmatest: do not allow to interrupt ongoing tests

Anson Huang (1):
      ARM: imx: clk-imx6q: AXI clock select index is incorrect

Arend van Spriel (3):
      brcmfmac: add additional parameter to brcmf_free_vif()
      brcmfmac: free net device when registration fails
      brcmfmac: use struct net_device::destructor to remove interfaces

Arnd Bergmann (3):
      drm/tilcd: select BACKLIGHT_LCD_SUPPORT
      drm/nouveau: use mdelay instead of large udelay constants
      irqdomain: export irq_domain_add_simple

Ash Willis (1):
      ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6

Ben Mesman (1):
      drm/i915: no lvds quirk for hp t5740

Ben Skeggs (3):
      drm/nv50-nv84/fifo: fix resume regression introduced by playlist race fix
      drm/nv50/disp: force dac power state during load detect
      drm/nv50/kms: use dac loadval from vbios, where it's available

Bjørn Mork (1):
      USB: option: blacklist network interface on Huawei E1820

Bob Liu (1):
      drivers: staging: zcache: fix compile error

Bob Peterson (4):
      GFS2: Set log descriptor type for jdata blocks
      GFS2: Increase i_writecount during gfs2_setattr_size
      GFS2: Fall back to vmalloc if kmalloc fails for dir hash tables
      GFS2: Don't cache iopen glocks

Brian Foster (4):
      fuse: allocate for_background dio requests based on io->async state
      fuse: truncate pagecache range on hole punch
      fuse: update inode size and invalidate attributes on fallocate
      fuse: return -EIOCBQUEUED from fuse_direct_IO() for all async requests

Chander Kashyap (1):
      serial: samsung: enable clock before clearing pending interrupts
during init

Charles Keepax (1):
      regulator: core: Correct spelling mistake in comment

Chen Gang (3):
      netfilter: ipt_ULOG: fix non-null terminated string in the nf_log path
      arch: s390: appldata: using strncpy() and strnlen() instead of sprintf()
      kernel/irq/irqdomain.c: before use 'irq_data', need check it
whether valid.

Chew, Chiau Ee (1):
      ata_piix: add PCI IDs for Intel BayTail

Christian Borntraeger (2):
      s390/pgtable: Fix check for pgste/storage key handling
      s390/pgtable: Fix gmap notifier address

Christopher Harvey (1):
      drm/mgag200: Add missing write to index before accessing data register

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland/Cakewalk UM-3G support

Clement Chauplannaz (1):
      scripts/config: fix assignment of parameters for short version
of --*-after options

Dan Carpenter (3):
      atmel: printing bogus information
      staging: alarm-dev: information leak in alarm_ioctl()
      staging: alarm-dev: information leak in alarm_compat_ioctl()

Dan Williams (1):
      USB: option,zte_ev: move most ZTE CDMA devices to zte_ev

Daniel Vetter (2):
      drm/i915: Fix spurious -EIO/SIGBUS on wedged gpus
      drm/i915: Quirk the pipe A quirk in the modeset state checker

Dave Chinner (6):
      xfs: rework dquot CRCs
      xfs: fix remote attribute invalidation for a leaf
      xfs: fix log recovery transaction item reordering
      xfs: inode unlinked list needs to recalculate the inode CRC
      xfs: disable noattr2/attr2 mount options for CRC enabled filesystems
      xfs: increase number of ACL entries for V5 superblocks

David Daney (9):
      MIPS: Remove duplicate definition of check_for_high_segbits.
      MIPS: Quit exposing Kconfig symbols in uapi headers.
      mips/kvm: Fix ABI for use of FPU.
      mips/kvm: Fix ABI for use of 64-bit registers.
      mips/kvm: Fix name of gpr field in struct kvm_regs.
      mips/kvm: Use ARRAY_SIZE() instead of hardcoded constants in
kvm_arch_vcpu_ioctl_{s,g}et_regs
      mips/kvm: Fix ABI by moving manipulation of CP0 registers to
KVM_{G,S}ET_ONE_REG
      mips/kvm: Use ENOIOCTLCMD to indicate unimplemented ioctls.
      MIPS: OCTEON: Improve _machine_halt implementation.

David Henningsson (1):
      ALSA: hda - Add headset quirk for two Dell machines

Dirk Gouders (2):
      mconf: handle keys in empty dialogs
      kconfig/menu.c: fix multiple references to expressions in menu_add_prop()

Dmitry Kravkov (1):
      bnx2x: fix TCP offload for tunneling ipv4 over ipv6

Doug Anderson (1):
      ARM: exynos: add debug_ll_io_init() call in exynos_init_io()

Dustin Kirkland (1):
      Update eCryptFS maintainers

Ebben Aries (1):
      ALSA: hda - add dock support for Thinkpad T431s

Egbert Eich (1):
      drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC.

Emmanuel Grumbach (1):
      iwlwifi: dvm: fix zero LQ CMD sending avoidance

Eric Dumazet (4):
      ip_tunnel: fix kernel panic with icmp_dest_unreach
      net: force a reload of first item in hlist_nulls_for_each_entry_rcu
      net_sched: restore "overhead xxx" handling
      net_sched: htb: do not mix 1ns and 64ns time units

Eric Miao (1):
      Input: synaptics - fix sync lost after resume on some laptops

Federico Manzan (1):
      usbfs: Increase arbitrary limit for USB 3 isopkt length

Federico Vaga (1):
      net/core/sock.c: add missing VSOCK string in af_family_*_key_strings

Felix Fietkau (5):
      ath9k: prevent aggregation session deadlocks
      cfg80211: fix reporting 64-bit station info tx bytes
      ath9k_hw: fix spur mitigation issues on AR934x
      ath9k_hw: fix host interface reset on AR934x
      ath9k_hw: improve performance for AR934x v1.3+

Finn Thain (1):
      m68k/mac: Fix unexpected interrupt with CONFIG_EARLY_PRINTK

Florian Westphal (1):
      netfilter: add nf_ipv6_ops hook to fix xt_addrtype with IPv6

Gabor Juhos (1):
      ath9k: use correct OTP register offsets for AR9550

Gao feng (1):
      ipv6: assign rt6_info to inet6_ifaddr in init_loopback

Geert Uytterhoeven (1):
      ntp: Remove unused variable flags in __hardpps

George Cherian (1):
      usb: dwc3: gadget: free trb pool only from epnum 2

George Spelvin (1):
      ahci: add an observed PCI ID for Marvell 88se9172 SATA controller

Giuseppe CAVALLARO (1):
      net: phy: fix a bug when verify the EEE support

Gleb Natapov (1):
      KVM: Fix race in apic->pending_events processing

Grant Likely (1):
      irqchip: Return -EPERM for reserved IRQs

Greg Ungerer (1):
      m68k: only use local gpio_request_one if not using GPIOLIB

Grzegorz Lyczba (1):
      ipvs: Fix reuse connection if real server is dead

Gu Zheng (1):
      fs/jfs: Add check if journaling to disk has been disabled in lbmRead()

Guennadi Liakhovetski (1):
      cpufreq: cpufreq-cpu0: use the exact frequency for clk_set_rate()

Haiyang Zhang (1):
      hyperv: Fix vlan_proto setting in netvsc_recv_callback()

Hante Meuleman (4):
      brcmfmac: Turn off ARP offloading when configured for AP.
      brcmfmac: Fix p2p setup when connected to ap on 5G.
      brcmfmac: Add multi channel support for P2P.
      brcmfmac: Disable powersave mode for P2P link.

Heiko Carstens (1):
      s390/smp: lost IPIs on cpu hotplug

Helmut Schaa (1):
      mac80211: Allow single vif mac address change with addr_mask

Huacai Chen (1):
      drm: fix a use-after-free when GPU acceleration disabled

Jack Morgenstein (1):
      net/mlx4_core: Return -EPROBE_DEFER when a VF is probed before
PF is sufficiently initialized

Jan Beulich (1):
      ipvs: ip_vs_sh: fix build

Jason Wang (1):
      tuntap: forbid changing mq flag for persistent device

Jay Vosburgh (4):
      net/core: __hw_addr_create_ex does not initialize sync_cnt
      net/core: __hw_addr_unsync_one "from" address not marked synced
      net/core: __hw_addr_sync_one / _multiple broken
      net/core: dev_mc_sync_multiple calls wrong helper

Jeff Layton (1):
      cifs: fix off-by-one bug in build_unc_path_to_root

Jeff Liu (1):
      cgroup: warn about mismatching options of a new mount of an
existing hierarchy

Jens Renner \(EFE\) (1):
      net: ethernet: xilinx_emaclite: set protocol selector bits when
writing ANAR

Jiada Wang (1):
      ARM i.MX6q: fix for ldb_di_sels

Jiri Pirko (2):
      list: introduce list_first_entry_or_null
      team: fix port list dump for big number of ports

Joe Perches (1):
      inkern: iio_device_put after incorrect return/goto

Johan Hovold (14):
      USB: serial: fix Treo/Kyocera interrrupt-in urb context
      USB: visor: fix initialisation of Treo/Kyocera devices
      USB: mos7720: fix DMA to stack
      USB: mos7840: fix DMA to stack
      USB: ark3116: fix control-message timeout
      USB: iuu_phoenix: fix bulk-message timeout
      USB: mos7720: fix message timeouts
      USB: zte_ev: fix control-message timeouts
      USB: zte_ev: fix broken open
      USB: keyspan: fix bogus array index
      USB: keyspan: remove unused endpoint-array access
      USB: mos7720: fix hardware flow control
      USB: serial: fix TIOCMIWAIT return value
      USB: whiteheat: fix broken port configuration

Johannes Berg (4):
      cfg80211: check wdev->netdev in connection work
      mac80211: fix queue handling crash
      mac80211: assign AP_VLAN hw queues correctly
      mac80211: close AP_VLAN interfaces before unregistering all

John Crispin (1):
      MIPS: ralink: add missing SZ_1M multiplier

Jonas Andersson (1):
      ARM: dts: imx: fix clocks for cspi

Jonas Peterson (1):
      net: can: kvaser_usb: fix reception on "USBcan Pro" and "USBcan
R" type hardware.

Jonathan Cameron (1):
      iio:callback buffer: free the scan_mask

Jongsung Kim (1):
      ARM: bcm2835: override the HW UART periphid

Kishon Vijay Abraham I (1):
      regulator: palmas: Fix "enable_reg" to point to the correct reg for SMPS10

Kyle McMartin (1):
      Revert "serial: 8250: Make SERIAL_8250_RUNTIME_UARTS work correctly"

Laurent Pinchart (1):
      sh-pfc: r8a7779: Don't group USB OVC and PENC pins

Lee Jones (2):
      ARM: ux500: Only configure wake-up reasons on ux500 based platforms
      ARM: ux500: Provide supplies for AUX1, AUX2 and AUX3

Li Zefan (1):
      cgroup: initialize xattr before calling d_instantiate()

Linus Torvalds (1):
      Linux 3.10-rc5

Linus Walleij (1):
      irqdomain: document the simple domain first_irq

Lucas Stach (3):
      mmc: sdhci-esdhc-imx: fix multiblock reads on i.MX53
      serial/imx: disable hardware flow control at startup
      net: fec: add fallback to random MAC address

Ludovic Desroches (1):
      mmc: atmel-mci: convert to dma_request_slave_channel_compat()

Maciej W. Rozycki (1):
      MIPS: Trap exception handling fixes

Marc Kleine-Budde (1):
      net: can: peak_usb: Do not do dma on the stack

Marc Zyngier (1):
      ARM: KVM: be more thorough when invalidating TLBs

Markus Pargmann (1):
      ARM: mxs: icoll: Fix interrupts gpio bank 0

Martin Fuzzey (1):
      mmc: sdhci-esdhc-imx: Fix SDIO interrupts

Matt Fleming (1):
      x86/PCI: Map PCI setup data with ioremap() so it can be in highmem

Matt Porter (1):
      mmc: omap_hsmmc: convert to dma_request_slave_channel_compat

Matthijs Kooijman (1):
      kbuild: Don't assume dts files live in arch/*/boot/dts

Maxim Patlasov (1):
      fuse: fix alignment in short read optimization for async_dio

Michael Hennerich (2):
      iio: frequency: ad4350: Fix bug / typo in mask
      iio:inkern: Fix typo/bug in convert raw to processed.

Michael Holzheu (1):
      kernel: Fix s390 absolute memory access for /dev/mem

Michael Wang (1):
      cpufreq: protect 'policy->cpus' from offlining during __gov_queue_work()

Michal Kubecek (1):
      ipv4: fix redirect handling for TCP packets

Michal Kubeček (1):
      netfilter: xt_LOG: fix mark logging for IPv6 packets

Michal Simek (2):
      microblaze: Fix sparse warnings
      microblaze: Use static inline functions in cacheflush.h

Mike Marciniszyn (1):
      IB/qib: Fix lockdep splat in qib_alloc_lkey()

Miklos Szeredi (1):
      fuse: fix readdirplus Oops in fuse_dentry_revalidate

Mikulas Patocka (1):
      hpfs: fix warnings when the filesystem fills up

Nadav Haklai (1):
      ARM: mvebu: Fix bug in coherency fabric low level init function

Nicolas Dichtel (1):
      snmp6: remove IPSTATS_MIB_CSUMERRORS

Nithin Sujir (1):
      tg3: Add read dma workaround for 5720

Olivier Sobrie (1):
      net: can: esd_usb2: Do not do dma on the stack

Or Gerlitz (4):
      net/mlx4_en: Handle unassigned VF MAC address correctly
      net/mlx4_core: Keep VF assigned MAC in the PF admin table
      IB/iser: Add Mellanox copyright
      MAINTAINERS: Add entry for iSCSI Extensions for RDMA (iSER) initiator

Pablo Neira (1):
      net: fix sk_buff head without data area

Paolo Bonzini (2):
      KVM: Emulate multibyte NOP
      KVM: fix sil/dil/bpl/spl in the mod/rm fields

Paul Bolle (1):
      NFC: Remove commented out LLCP related Makefile line

Paul Moore (2):
      xfrm: force a garbage collection after deleting a policy
      selinux: fix the labeled xfrm/IPsec reference count handling

Paul Taysom (1):
      ecryptfs: fixed msync to flush data

Paul Zimmerman (1):
      staging: dwc2: fix value of dma_mask

Pavel Tikhomirov (1):
      posix-timers: Show clock ID in proc file

Peter Chen (2):
      usb: dwc3: pci: PHY should be deleted later than dwc3 core
      usb: dwc3: exynos: PHY should be deleted later than dwc3 core

Peter Zijlstra (1):
      arch, mm: Remove tlb_fast_mode()

Ping Cheng (1):
      Input: wacom - fix a typo for Cintiq 22HDT

Pravin B Shelar (1):
      udp6: Fix udp fragmentation for tunnel traffic.

Rabin Vincent (1):
      dmaengine: ste_dma40: fix pm runtime ref counting

Rafael J. Wysocki (2):
      ACPI / PM: Do not execute _PS0 for devices without _PSC during
initialization
      Revert "ACPI / scan: do not match drivers against objects having
scan handlers"

Ralf Baechle (1):
      MIPS: Compat: Fix cputime_to_timeval() arguments in compat binfmt_elf.

Richard Weinberger (1):
      USB: serial: Add Option GTM681W to qcserial device table.

Robert Butora (1):
      USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device

Robert P. J. Day (1):
      regulator: Fix kernel-doc generation warnings.

Roi Dayan (1):
      IB/iser: Fix device removal flow

Ross Lagerwall (1):
      acpi-cpufreq: set current frequency based on target P-State

Sachin Kamat (2):
      regulator: dbx500: Make local symbol static
      regulator: palmas: Fix incorrect condition

Sagi Grimberg (1):
      net/mlx4_en: Fix adaptive moderation cq update

Samuel Li (1):
      drm/radeon: Use direct mapping for fast fb access on RS780/RS880 (v2)

Samuel Ortiz (3):
      NFC: mei_phy depends on INTEL_MEI
      NFC: mei_phy: Register event callback when enabling the device
      NFC: mei: Do not disable MEI devices from their remove routine

Santosh Shilimkar (1):
      mmc: omap_hsmmc: Skip platform_get_resource_byname() for dt case

Sarah Sharp (1):
      xhci: Disable D3cold for buggy TI redrivers.

Sebastian Ott (1):
      s390/dma: do not call debug_dma after free

Sergei Shtylyov (2):
      sata_rcar: clear STOP bit in bmdma_start() method
      sata_rcar: fix interrupt handling

Sergio Aguirre (1):
      xhci-mem: init list heads at the beginning of init

Simon Horman (1):
      ARM: shmobile: sh73a0: Update CMT clockevent rating to 80

Somnath Kotur (2):
      be2net: Mark checksum fail for IP fragmented packets
      be2net: Fix crash on 2nd invocation of PCI AER/EEH error_detected hook

Stanislaw Gruszka (1):
      mac80211: fix direct probe auth

Stefan Weinhuber (1):
      s390/dasd: fix handling of gone paths

Steven Rostedt (4):
      rcu: Add _notrace variation of rcu_dereference_raw() and
hlist_for_each_entry_rcu()
      ftrace: Use the rcu _notrace variants for rcu_dereference_raw()
and friends
      tracing: Fix bad parameter passed in branch selftest
      tracing: Use current_uid() for critical time tracing

Takashi Iwai (7):
      ALSA: hda/via - Disable broken dynamic power control
      ALSA: hda - Allow setting automute/automic hooks after parsing
      ALSA: hda - Add keep_eapd_on flag to generic parser
      ALSA: hda/via - Fix wrongly cleared pins after suspend on VT1802
      ALSA: hda/via - Clean up duplicated codes
      ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to
audio iface
      ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270

Tejun Heo (2):
      libata: update "Maintained by:" tags
      cgroup: fix a subtle bug in descendant pre-order walk

Thomas Gleixner (1):
      tick: Cure broadcast false positive pending bit warning

Tony Camuso (1):
      xhci - correct comp_mode_recovery_timer on return from hibernate

Tony Lindgren (1):
      mmc: omap_hsmmc: Fix the DT pbias workaround for MMC controllers 2 to 5

Tushar Behera (1):
      ARM: EXYNOS: uncompress - print debug messages if DEBUG_LL is defined

Tyler Hicks (1):
      eCryptfs: Check return of filemap_write_and_wait during fsync

Vahram Martirosyan (1):
      jfs: Several bugs in jfs_freeze() and jfs_unfreeze()

Vincent Pelletier (1):
      libata: make ata_exec_internal_sg honor DMADIR

Virupax Sadashivpetimath (1):
      usb: musb: make use_sg flag URB specific

Vladimir Murzin (1):
      xhci: fix list access before init

Wei Yongjun (4):
      qlge: add missing free_netdev() on error in qlge_probe()
      ptp_pch: fix error handling in pch_probe()
      ALSA: sis7019: fix error return code in sis_chip_create()
      ACPI / APEI: fix error return code in ghes_probe()

Yoichi Yuasa (1):
      MIPS: rtlx: Fix implicit declaration of function set_vi_handler()

Yuval Mintz (1):
      bnx2x: Fix bridged GSO for 57710/57711 chips

Zoran Markovic (1):
      timekeeping: Correct run-time detection of persistent_clock.

lan,Tianyu (1):
      x86 / platform / hp_wmi: Fix bluetooth_rfkill misuse in
hp_wmi_rfkill_setup()
