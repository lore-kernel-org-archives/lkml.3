Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaKXAIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 19:08:25 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:65295 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaKXAIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 19:08:23 -0500
MIME-Version: 1.0
Date: Sun, 23 Nov 2014 16:08:21 -0800
X-Google-Sender-Auth: TZUfL0-OZL6IRg3XewLJziEK_Cw
Message-ID: <CA+55aFx7PYp=a2FnpnvYy1jDHsvLsJDpO88KycPgEa3gmJwG7A@mail.gmail.com>
Subject: Linux 3.18-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steady progress towards final release, although we still have a big
unknown worry in a regression that Dave Jones reported and that we
haven't solved yet. In the process of chasing that one down, there's
been a fair amount of looking at various low-level details, and that
found some dubious issues, but no smoking gun yet. But that explains
some of the patches in rc6..

The good news is that things are generally calming down, and most of
the changes are smallish regression fixes here, with a smattering of
stable patches. About half drivers (networking, sound, pci,
infiniband, etc), with architecture updates (x86, mips, arm), and
networking code being about half of the rest. And the last quarter is
"misc": filesystem fixes, documentation, scheduler..

Really not a whole lot of code changed, and if it wasn't for the
pending trouble from DaveJ, I'd probably be perfectly happy. Let's see
how that all unfolds, but in the meantime, the more testing this can
get, the better.

So go out and give it a good shake-down,

                     Linus

---

Aaro Koskinen (1):
      MIPS: oprofile: Fix backtrace on 64-bit kernel

Alex Deucher (2):
      drm/radeon: disable native backlight control on pre-r6xx asics (v2)
      drm/radeon: fix endian swapping in vbios fetch for tdp table

Alexandre Courbot (2):
      ARM: tegra: Remove eMMC vmmc property for roth/tn7
      ARM: tegra: roth: Fix SD card VDD_IO regulator

Alexey Khoroshilov (2):
      ieee802154: fix error handling in ieee802154fake_probe()
      can: esd_usb2: fix memory leak on disconnect

Andi Kleen (2):
      perf/x86/intel/uncore: Fix IRP uncore register offsets on Haswell EP
      perf/x86/intel/uncore: Fix boot crash on SBOX PMU on Haswell-EP

Andreas Färber (1):
      ASoC: samsung: Add MODULE_DEVICE_TABLE for Snow

Andrey Ryabinin (1):
      sched/numa: Fix out of bounds read in sched_init_numa()

Andy Lutomirski (5):
      x86, syscall: Fix _TIF_NOHZ handling in syscall_trace_enter_phase1
      x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
      x86_64, traps: Stop using IST for #SS
      x86_64, traps: Rework bad_iret
      uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME

Anish Bhatt (3):
      dcbnl : Disable software interrupts before taking dcb_lock
      cxgb4i : Don't block unload/cxgb4 unload when remote closes TCP connection
      cxgb4 : Fix DCB priority groups being returned in wrong order

Antony Pavlov (1):
      devicetree: vendor-prefixes.txt: fix whitespace

Arend van Spriel (1):
      brcmfmac: fix conversion of channel width 20MHZ_NOHT

Arnd Bergmann (1):
      isofs: avoid unused function warning

Axel Lin (1):
      ASoC: es8328-i2c: Fix i2c_device_id name field in es8328_id

Bard Liao (2):
      ASoC: rt5670: correct the incorrect default values
      ASoC: rt5670: change dapm routes of PLL connection

Bart Van Assche (1):
      srp-target: Retry when QP creation fails with ENOMEM

Ben Greear (1):
      ath9k: fix regression in bssidmask calculation

Benjamin Herrenschmidt (1):
      of/base: Fix PowerPC address parsing hack

Bjorn Helgaas (1):
      of/irq: Drop obsolete 'interrupts' vs 'interrupts-extended' text

Borislav Petkov (1):
      x86, microcode: Update BSPs microcode on resume

Calvin Owens (2):
      ipvs: Keep skb->sk when allocating headroom on tunnel xmit
      tcp: Restore RFC5961-compliant behavior for SYN packets

Charles Keepax (1):
      ASoC: wm_adsp: Avoid attempt to free buffers that might still be in use

Chen-Yu Tsai (1):
      ARM: dts: sun6i: Re-parent ahb1_mux to pll6 as required by dma controller

Chris Mason (1):
      btrfs: fix lockups from btrfs_clear_path_blocking

Chris Moore (1):
      IB/isert: Adjust CQ size to HW limits

Dan Carpenter (1):
      netfilter: ipset: small potential read beyond the end of buffer

Daniel Borkmann (2):
      netfilter: nft_masq: fix uninitialized range in nft_masq_{ipv4, ipv6}_eval
      ipv6: mld: fix add_grhead skb_over_panic for devs with large MTUs

Daniel Vetter (2):
      drm/i915: drop WaSetupGtModeTdRowDispatch:snb
      drm/i915: Kick fbdev before vgacon

Daniele Di Proietto (1):
      openvswitch: Fix NDP flow mask validation

Dave Hansen (1):
      x86: Require exact match for 'noxsave' command line option

David Cohen (1):
      can: m_can: add CONFIG_HAS_IOMEM dependence

Dmitry Torokhov (1):
      brcmfmac: fix error handling of irq_of_parse_and_map

Dong Aisheng (8):
      can: dev: add can_is_canfd_skb() API
      can: m_can: add .ndo_change_mtu function
      can: m_can: add missing message RAM initialization
      can: m_can: fix possible sleep in napi poll
      can: m_can: fix not set can_dlc for remote frame
      can: m_can: add missing delay after setting CCCR_INIT bit
      can: m_can: fix incorrect error messages
      can: m_can: update to support CAN FD features

Duan Jiong (1):
      ipv6: delete protocol and unregister rtnetlink when cleanup

Duc Dang (1):
      PCI: xgene: Assign resources to bus before adding new devices

Dylan Reid (1):
      ASoC: max98090: Correct pclk divisor settings

Emmanuel Grumbach (1):
      iwlwifi: mvm: abort scan upon RFKILL

Eric Dumazet (1):
      net: Revert "net: avoid one atomic operation in skb_clone()"

Fabio Estevam (1):
      ASoC: sgtl5000: Fix SMALL_POP bit definition

Fang, Yang A (1):
      ASoC: rt5645: Mark RT5645_TDM_CTRL_3 as readable

Felix Fietkau (1):
      mac80211: minstrel_ht: fix a crash in rate sorting

Geert Uytterhoeven (5):
      ARM: shmobile: r8a7740 legacy: Add missing INTCA clock for irqpin module
      ARM: shmobile: r8a7740 legacy: Correct IIC0 parent clock
      ARM: shmobile: r8a7740 dtsi: Correct IIC0 parent clock
      ARM: shmobile: kzm9g legacy: Set i2c clks_per_count to 2
      of: Spelling s/stucture/structure/

Grant Likely (2):
      of/selftest: Fix off-by-one error in removal path
      of/selftest: Fix testing when /aliases is missing

Hannes Frederic Sowa (1):
      reciprocal_div: objects with exported symbols should be obj-y
rather than lib-y

Hauke Mehrtens (1):
      b43: fix NULL pointer dereference in b43_phy_copy()

Huacai Chen (2):
      MIPS: Loongson: Fix the write-combine CCA value setting
      MIPS: Loongson: Set Loongson-3's ISA level to MIPS64R1

Hui Wang (2):
      ALSA: hda - move DELL_WMI_MIC_MUTE_LED to the tail in the quirk chain
      ALSA: hda - fix the mic mute led problem for Latitude E5550

James Cowgill (2):
      MIPS: Loongson3: Fix __node_distances undefined error
      MIPS: IP27: Fix __node_distances undefined error

Jarno Rajahalme (1):
      openvswitch: Validate IPv6 flow key and mask values.

Jason Wang (1):
      virtio-net: validate features during probe

Jesse Gross (1):
      openvswitch: Fix checksum calculation when modifying ICMPv6 packets.

Jianqun (1):
      ASoC: rockchip-i2s: fix infinite loop in rockchip_snd_rxctrl

Jiri Bohac (1):
      ipx: fix locking regression in ipx_sendmsg and ipx_recvmsg

Joe Stringer (6):
      net: Add vxlan_gso_check() helper
      be2net: Implement ndo_gso_check()
      net/mlx4_en: Implement ndo_gso_check()
      qlcnic: Implement ndo_gso_check()
      vxlan: Inline vxlan_gso_check().
      openvswitch: Don't validate IPv6 label masks.

Johan Rastén (1):
      ALSA: usb-audio: Set the Control Selector to SU_SELECTOR_CONTROL for UAC2

Johannes Berg (1):
      brcmfmac: don't include linux/unaligned/access_ok.h

John Ogness (1):
      drivers: net: cpsw: Fix TX_IN_SEL offset

Jon Medhurst (2):
      dmaengine: pl330: Align DMA memcpy operations to MFIFO width
      dmaengine: pl330: Limit MFIFO usage for memcpy to avoid exhausting entries

Jurgen Kramer (1):
      ALSA: usb-audio: Add ctrl message delay quirk for Marantz/Denon devices

Kees Cook (2):
      x86, mm: Set NX across entire PMD at boot
      x86, kaslr: Handle Gold linker for finding bss/brk

Kevin Cernekee (1):
      of: Fix crash if an earlycon driver is not found

Kevin Hao (1):
      powerpc/fsl_msi: mark the msi cascade handler IRQF_NO_THREAD

Kirill Tkhai (1):
      sched: Remove lockdep check in sched_move_task()

Kuninori Morimoto (2):
      ASoC: fsi: remove unsupported PAUSE flag
      ASoC: rsnd: remove unsupported PAUSE flag

Larry Finger (3):
      rtlwifi: Fix setting of tx descriptor for new trx flow
      rtlwifi: Fix errors in descriptor manipulation
      rtlwifi: rtl8192se: Fix connection problems

Lars-Peter Clausen (1):
      ASoC: Fix snd_soc_find_dai() matching component by name

Liad Kaufman (1):
      iwlwifi: pcie: fix prph dump length

Linus Lüssing (1):
      bridge: fix netfilter/NF_BR_LOCAL_OUT for own, locally generated queries

Linus Torvalds (1):
      Linux 3.18-rc6

Liviu Dudau (1):
      dmaengine: Fix allocation size for PL330 data buffer depth.

Lucas Stach (2):
      ARM: tegra: Add serial port labels to Tegra124 DT
      PCI: Add missing DT binding for "linux,pci-domain" property

Maciej W. Rozycki (2):
      MIPS: jump_label.c: Correct the span of the J instruction
      MIPS: jump_label.c: Handle the microMIPS J instruction encoding

Marc Kleine-Budde (3):
      can: xilinx_can: add .ndo_change_mtu function
      can: rcar_can: add .ndo_change_mtu function
      can: gs_usb: add .ndo_change_mtu function

Mark Rutland (1):
      perf: Fix corruption of sibling list with hotplug

Markos Chandras (3):
      MIPS: asm: uaccess: Add v1 register to clobber list on EVA
      MIPS: tlb-r4k: Add missing HTW stop/start sequences
      MIPS: lib: memcpy: Restore NOP on delay slot before returning to caller

Martin Hauke (1):
      qmi_wwan: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Mathias Krause (1):
      pptp: fix stack info leak in pptp_getname()

Mathy Vanhoef (1):
      brcmfmac: kill URB when request timed out

Maxime COQUELIN (1):
      bitops: Fix shift overflow in GENMASK macros

Maxime Ripard (2):
      dmaengine: sun6i: Fix memcpy operation
      clockevent: sun4i: Fix race condition in the probe code

Miaoqing Pan (1):
      ath9k: Fix RTC_DERIVED_CLK usage

Miklos Szeredi (8):
      ovl: rename filesystem type to "overlay"
      ovl: fix remove/copy-up race
      ovl: fix race in private xattr checks
      ovl: allow filenames with comma
      ovl: use lockless_dereference() for upperdentry
      ovl: pass dentry into ovl_dir_read_merged()
      ovl: update MAINTAINERS
      ovl: ovl_dir_fsync() cleanup

Nicholas Bellinger (1):
      vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDPOINT

Nicolin Chen (1):
      ASoC: fsl_asrc: Add reg_defaults for regmap to fix kernel dump

Nikolay Aleksandrov (1):
      bonding: fix curr_active_slave/carrier with loadbalance arp monitoring

Olof Johansson (1):
      ARM: dts: tegra: move serial aliases to per-board

Or Gerlitz (2):
      ib_isert: Add max_send_sge=2 minimum for control PDU responses
      net/mlx4_en: Add VXLAN ndo calls to the PF net device ops too

Pablo Neira Ayuso (5):
      netfilter: nft_compat: use current net namespace
      netfilter: nft_compat: relax chain type validation
      netfilter: nft_compat: use the match->table to validate dependencies
      netfilter: nf_tables: restore synchronous object release from commit/abort
      netfilter: nfnetlink: fix insufficient validation in nfnetlink_bind

Panu Matilainen (1):
      ipv4: Fix incorrect error code when adding an unreachable route

Peter Zijlstra (2):
      sched/numa: Avoid selecting oneself as swap target
      sched/cputime: Fix cpu_timer_sample_group() double accounting

Peter Zijlstra (Intel) (1):
      perf/x86: Fix embarrasing typo

Philipp Zabel (1):
      of: Add vendor prefix for Chips&Media, Inc.

Pravin B Shelar (2):
      openvswitch: Fix memory leak.
      openvswitch: Convert dp rcu read operation to locked operations

Rafael J. Wysocki (1):
      ACPI / PM: Ignore wakeup setting if the ACPI companion can't wake up

Ralf Baechle (1):
      MIPS: Zero variable read by get_user / __get_user in case of an error.

Robert Jarzmik (1):
      devicetree: bindings: add sandisk to the vendor prefixes

Roland Dreier (1):
      target: Don't call TFO->write_pending if data_length == 0

Roman Fietze (1):
      can: dev: fix typo CIA -> CiA, CAN in Automation

Ronald Wahl (1):
      mac80211: Fix regression that triggers a kernel BUG with CCMP

Sagi Grimberg (1):
      iser-target: Handle DEVICE_REMOVAL event on network portal
listener correctly

Shinobu Uehara (2):
      ARM: shmobile: r8a7790: Fix SD3CKCR address
      ARM: shmobile: r8a7790: Fix SD3CKCR address to device tree

Soren Brinkmann (1):
      documentation: pinctrl bindings: Fix trivial typo 'abitrary'

Stanislaw Gruszka (2):
      rt2x00: do not align payload on modern H/W
      sched/cputime: Fix clock_nanosleep()/clock_gettime() inconsistency

Steven Allen (2):
      iscsi-target: return the correct port in SendTargets
      target: return CONFLICT only when SA key unmatched

Sudip Mukherjee (2):
      can: remove unused variable
      can: xilinx_can: fix comparison of unsigned variable

Takashi Iwai (1):
      ASoC: dpcm: Fix race between FE/BE updates and trigger

Tejun Heo (1):
      percpu-ref: fix DEAD flag contamination of percpu pointer

Thomas Gleixner (1):
      sched: Provide update_curr callbacks for stop/idle scheduling classes

Thomas Körper (1):
      can: dev: avoid calling kfree_skb() from interrupt context

Thomas Petazzoni (1):
      ASoC: cs42l51: re-hook of_match_table pointer

Tyler Baker (1):
      ARM: multi_v7_defconfig: fix failure setting CPU voltage by
enabling dependent I2C controller

Vincent BENAYOUN (1):
      inetdevice: fixed signed integer overflow

Yan, Zheng (1):
      vfs: fix reference leak in d_prune_aliases()

Yinghai Lu (2):
      PCI: Apply _HPX Link Control settings to all devices with a link
      PCI: Support 64-bit bridge windows if we have 64-bit dma_addr_t

bill bonaparte (1):
      netfilter: conntrack: fix race in __nf_conntrack_confirm against
get_next_corpse

bpqw (1):
      devicetree: bindings: Add vendor prefix for Micron Technology, Inc.
