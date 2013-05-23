Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab3EWJlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:41:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53232 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab3EWJlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:41:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [3.5.y.z extended stable] Linux 3.5.7.13
Date: Thu, 23 May 2013 10:41:47 +0100
Message-Id: <1369302108-4302-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 3.5.7.13 tree of stable patches.

This tree picks up the latest 3.5 stable release upstream, and add patches
on top that were later marked for stable but can't be added to 3.5, as
it is not anymore an stable series maintained upstream.

The tree is maintained by the Ubuntu Kernel Team, with the intention
to continue to provide support for the 3.5 series. Anyone is welcomed
on using it or contributing to this effort.

For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

The updated 3.5.y tree can be found at: 

  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y

The diffstat and shortlog with changes since previous v3.5.7.12 release are
shown below.

-Luis

-- 
 Makefile                                     |   2 +-
 arch/arm/configs/at91sam9g45_defconfig       |   1 -
 arch/arm/include/asm/cmpxchg.h               |   8 +-
 arch/arm/include/asm/hardware/iop3xx.h       |   2 +-
 arch/arm/mach-at91/setup.c                   |   2 +-
 arch/arm/mach-exynos/include/mach/regs-pmu.h |   1 +
 arch/arm/mach-exynos/pmu.c                   |   5 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |   4 +-
 arch/arm/mach-u300/include/mach/u300-regs.h  |   2 +-
 arch/avr32/configs/favr-32_defconfig         |   1 -
 arch/avr32/configs/merisc_defconfig          |   1 -
 arch/powerpc/include/asm/ppc-opcode.h        |   4 +
 arch/powerpc/include/asm/rtas.h              |   2 +
 arch/powerpc/kernel/head_64.S                |   1 +
 arch/powerpc/kernel/rtas.c                   | 113 +++++++++++++++++++++++++++
 arch/powerpc/kernel/traps.c                  |  10 ++-
 arch/powerpc/mm/numa.c                       |   2 +-
 arch/powerpc/platforms/cell/spufs/inode.c    |   1 +
 arch/powerpc/platforms/pseries/suspend.c     |  22 ++++++
 arch/s390/include/asm/pgtable.h              |   4 +
 arch/tile/Kconfig                            |  14 +++-
 arch/tile/include/hv/hypervisor.h            |  27 ++++++-
 arch/tile/kernel/head_32.S                   |   2 +-
 arch/tile/kernel/head_64.S                   |  12 ++-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c   |  27 +++++--
 arch/x86/kernel/irq.c                        |   4 -
 arch/x86/kvm/vmx.c                           |   6 ++
 arch/x86/mm/init.c                           |   5 ++
 arch/x86/xen/enlighten.c                     |  15 ++++
 drivers/acpi/acpica/exfldio.c                |  14 +++-
 drivers/acpi/ec.c                            |   4 +-
 drivers/block/drbd/drbd_receiver.c           |   1 -
 drivers/char/ipmi/ipmi_bt_sm.c               |   4 +-
 drivers/char/ipmi/ipmi_devintf.c             |  14 +++-
 drivers/cpufreq/exynos-cpufreq.c             |   4 +-
 drivers/cpufreq/longhaul.c                   |  10 ++-
 drivers/dma/pch_dma.c                        |   2 +-
 drivers/gpu/drm/ast/ast_drv.h                |   2 +
 drivers/gpu/drm/ast/ast_fb.c                 |  43 +++++++++-
 drivers/gpu/drm/ast/ast_ttm.c                |   2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.h          |   2 +
 drivers/gpu/drm/cirrus/cirrus_fbdev.c        |  38 ++++++++-
 drivers/gpu/drm/cirrus/cirrus_ttm.c          |   2 +-
 drivers/gpu/drm/drm_gem.c                    |   4 +-
 drivers/gpu/drm/drm_prime.c                  |  76 +++++++++---------
 drivers/gpu/drm/gma500/psb_irq.c             |   2 +-
 drivers/gpu/drm/i915/i915_drv.h              |   1 +
 drivers/gpu/drm/i915/i915_gem.c              |  28 +++++--
 drivers/gpu/drm/i915/i915_gem_stolen.c       |  81 +++++++++----------
 drivers/gpu/drm/i915/intel_display.c         |   3 +
 drivers/gpu/drm/i915/intel_dp.c              |   5 --
 drivers/gpu/drm/i915/intel_dvo.c             |  13 ++-
 drivers/gpu/drm/i915/intel_lvds.c            |  10 ++-
 drivers/gpu/drm/i915/intel_panel.c           |   7 +-
 drivers/gpu/drm/mgag200/mgag200_drv.h        |   2 +
 drivers/gpu/drm/mgag200/mgag200_fb.c         |  43 +++++++++-
 drivers/gpu/drm/mgag200/mgag200_mode.c       |  69 ++++++++++------
 drivers/gpu/drm/mgag200/mgag200_ttm.c        |   4 +-
 drivers/gpu/drm/radeon/atom.c                |   6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c       |   3 +
 drivers/gpu/drm/radeon/evergreen.c           |  67 +++++++++++++++-
 drivers/gpu/drm/radeon/evergreen_reg.h       |   2 +
 drivers/gpu/drm/radeon/ni.c                  |   8 +-
 drivers/gpu/drm/radeon/nid.h                 |   4 +
 drivers/gpu/drm/radeon/r300_cmdbuf.c         |   2 +-
 drivers/gpu/drm/radeon/r600_hdmi.c           |   4 +-
 drivers/gpu/drm/radeon/radeon_atombios.c     |  21 +++--
 drivers/gpu/drm/radeon/radeon_kms.c          |   4 +
 drivers/gpu/drm/radeon/radeon_pm.c           |   6 +-
 drivers/gpu/drm/radeon/si.c                  |   3 +-
 drivers/gpu/drm/radeon/sid.h                 |   2 +
 drivers/i2c/busses/i2c-xiic.c                |   6 +-
 drivers/md/dm-snap.c                         |   1 +
 drivers/md/dm-thin.c                         |   2 +-
 drivers/mfd/adp5520.c                        |   8 +-
 drivers/mmc/core/mmc.c                       |   2 +-
 drivers/mmc/host/Kconfig                     |  10 ---
 drivers/mmc/host/atmel-mci.c                 |  16 ++--
 drivers/net/ethernet/3com/3c509.c            |   2 +
 drivers/net/ethernet/3com/3c59x.c            |  27 ++++---
 drivers/net/ethernet/ibm/ibmveth.c           |  23 +++---
 drivers/net/ethernet/realtek/r8169.c         |  41 ++++++----
 drivers/net/ethernet/sfc/mcdi.c              |   2 +-
 drivers/net/ethernet/tile/tilegx.c           |   2 +-
 drivers/net/macvlan.c                        |   7 +-
 drivers/net/usb/cdc_ether.c                  |   7 ++
 drivers/net/usb/qmi_wwan.c                   | 108 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c        |   6 +-
 drivers/net/wireless/b43/dma.c               |  19 +++++
 drivers/net/wireless/b43/dma.h               |   4 +-
 drivers/net/wireless/b43/main.c              |  43 +++++-----
 drivers/net/wireless/iwlwifi/iwl-pci.c       |   1 +
 drivers/net/wireless/mwifiex/cmdevt.c        |   1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  21 ++---
 drivers/platform/x86/hp_accel.c              |   3 +-
 drivers/rtc/rtc-pcf2123.c                    |   1 +
 drivers/scsi/sd.c                            |  20 +++++
 drivers/scsi/sd.h                            |   1 +
 drivers/target/iscsi/iscsi_target_erl1.c     |   7 +-
 drivers/usb/host/xhci-ring.c                 |  23 ++++--
 drivers/video/console/fbcon.c                |   2 +
 drivers/watchdog/watchdog_dev.c              |   3 +-
 fs/autofs4/expire.c                          |   9 ---
 fs/ext4/mballoc.c                            |   6 +-
 fs/ext4/resize.c                             |   4 +
 fs/hugetlbfs/inode.c                         |  20 ++---
 fs/nfsd/nfs4proc.c                           |  23 ++++--
 fs/nfsd/nfs4state.c                          |   8 +-
 fs/nfsd/nfs4xdr.c                            |  19 ++---
 include/drm/drmP.h                           |   5 +-
 include/drm/drm_pciids.h                     |   5 ++
 include/linux/audit.h                        |   2 +-
 include/linux/hugetlb.h                      |   9 +--
 include/linux/if_cablemodem.h                |  12 +--
 include/net/sock.h                           |  12 +++
 include/net/tcp.h                            |   1 +
 ipc/shm.c                                    |   4 +-
 kernel/audit_tree.c                          |   2 +-
 kernel/kmod.c                                |   5 ++
 kernel/time/tick-sched.c                     |   2 +-
 kernel/timer.c                               |   2 +-
 kernel/trace/trace_events_filter.c           |   4 +
 mm/mmap.c                                    |   6 +-
 net/8021q/vlan_dev.c                         |   2 +-
 net/bridge/br_stp_timer.c                    |   2 +-
 net/core/dev.c                               |   2 +-
 net/core/ethtool.c                           |   2 +-
 net/core/sock.c                              |  12 ---
 net/ipv6/tcp_ipv6.c                          |  12 +++
 net/ipv6/udp.c                               |  13 ++-
 net/ipv6/udp_impl.h                          |   2 +
 net/ipv6/udplite.c                           |   2 +-
 net/ipv6/xfrm6_policy.c                      |   4 +-
 net/packet/af_packet.c                       |  54 ++++++-------
 net/sched/act_ipt.c                          |  33 +++++++-
 sound/pci/hda/hda_codec.c                    |   3 +
 sound/soc/codecs/max98088.c                  |   2 +-
 sound/soc/codecs/wm8994.c                    |   1 +
 sound/usb/card.c                             |   4 +-
 sound/usb/card.h                             |   1 +
 sound/usb/midi.c                             |  13 +--
 sound/usb/pcm.c                              |   2 +-
 sound/usb/quirks.c                           |   1 +
 sound/usb/stream.c                           |   9 +++
 144 files changed, 1217 insertions(+), 460 deletions(-)

Aaro Koskinen (2):
      ARM: 7692/1: iop3xx: move IOP3XX_PERIPHERAL_VIRT_BASE
      ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI devices

Alex Deucher (14):
      drm/radeon: don't use get_engine_clock() on APUs
      drm/radeon/dce6: add missing display reg for tiling setup
      drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS
      drm/radeon: cleanup properly if mmio mapping fails
      drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
      drm/radeon: fix typo in si_select_se_sh()
      drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
      drm/radeon: fix possible segfault when parsing pm tables
      drm/radeon: add some new SI PCI ids
      drm/radeon: add new richland pci ids
      drm/radeon: fix handling of v6 power tables
      drm/radeon: properly lock disp in mc_stop/resume for evergreen+
      drm/radeon: disable the crtcs in mc_stop (evergreen+) (v2)
      drm/radeon: use frac fb div on RS780/RS880

Anisse Astier (1):
      drm/gma500: fix backlight hotkeys behaviour on netbooks

Anton Blanchard (2):
      powerpc: Emulate non privileged DSCR read and write
      audit: Syscall rules are not applied to existing processes on non-x86

Ben Hutchings (1):
      sfc: Fix naming of MTD partitions for FPGA bitfiles

Benjamin Herrenschmidt (1):
      net/eth/ibmveth: Fixup retrieval of MAC address

Benjamin LaHaise (1):
      ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex

Bing Zhao (1):
      mwifiex: clear is_suspended flag when interrupt is received early

Bjørn Mork (4):
      net: qmi_wwan: fixup missing ethernet header (firmware bug workaround)
      net: qmi_wwan: fixup destination address (firmware bug workaround)
      net: qmi_wwan: prevent duplicate mac address on link (firmware bug workaround)
      net: vlan,ethtool: netdev_features_t is more than 32 bit

Bob Moore (1):
      ACPICA: Fix possible buffer overflow during a field unit read operation

Bryan Schumaker (1):
      nfsd: Decode and send 64bit time values

Calvin Owens (1):
      ALSA: usb: Add quirk for 192KHz recording on E-Mu devices

Chen Gang (2):
      kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()
      drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory overflow

Chris Metcalf (1):
      tile: support new Tilera hypervisor

Chris Wilson (2):
      drm/i915: Workaround incoherence between fences and LLC across multiple CPUs
      drm/i915: Fix detection of base of stolen memory

Christian Lamparter (1):
      drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900

Christopher Harvey (2):
      drm/mgag200: Fix writes into MGA1064_PIX_CLK_CTL register
      drm/mgag200: Fix framebuffer base address programming

Clemens Ladisch (1):
      ALSA: usb-audio: disable autopm for MIDI devices

Cong Wang (1):
      xfrm6: release dev before returning error

Dan Carpenter (1):
      ASoC: wm8994: missing break in wm8994_aif3_hw_params()

Dan Williams (1):
      qmi_wwan/cdc_ether: add device IDs for Dell 5804 (Novatel E371) WWAN card

Daniel Borkmann (1):
      packet: tpacket_v3: do not trigger bug() on wrong header status

Daniel Drake (1):
      mwifiex: fix setting of multicast filter

Daniel Mack (1):
      ALSA: snd-usb: try harder to find USB_DT_CS_ENDPOINT

Dave Airlie (4):
      drm/prime: keep a reference from the handle to exported dma-buf (v6)
      drm/mgag200: deal with bo reserve fail in dirty update path
      drm/ast: deal with bo reserve fail in dirty update path
      drm/cirrus: deal with bo reserve fail in dirty update path

David Jeffery (1):
      autofs - remove autofs dentry mount check

David Müller (ELSOFT AG) (1):
      drm/i915: Fall back to bit banging mode for DVO transmitter detection

Dylan Reid (1):
      ASoC: max98088: Fix logging of hardware revision.

Eric Dumazet (2):
      tcp: force a dst refcount when prequeue packet
      ipv6: do not clear pinet6 field

Felix Fietkau (1):
      ath9k: fix key allocation error handling for powersave keys

Gleb Natapov (1):
      KVM: VMX: fix halt emulation while emulating invalid guest sate

Guenter Roeck (1):
      watchdog: Fix race condition in registration code

Inderpal Singh (1):
      ARM: EXYNOS5: Fix kernel dump in AFTR idle mode

J. Bruce Fields (2):
      nfsd4: don't close read-write opens too soon
      nfsd4: don't allow owner override on 4.1 CLAIM_FH opens

Jaccon Bastiaansen (1):
      ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldn't clear upper 32 bits of the old/new value

Jamal Hadi Salim (1):
      net_sched: act_ipt forward compat with xtables

James Bottomley (1):
      sd: fix array cache flushing bug causing performance problems

Jani Nikula (1):
      drm/i915: ensure single initialization and cleanup of backlight device

Jerry Hoemann (1):
      x86/mm: account for PGDIR_SIZE alignment

Jianguo Wu (1):
      hugetlbfs: fix mmap failure in unaligned size request

Jiri Pirko (1):
      macvlan: fix passthru mode race between dev removal and rx path

Johan Hovold (1):
      mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload

Jonghwan Choi (1):
      cpufreq: exynos: Get booting freq value in exynos_cpufreq_init

Josh Boyer (1):
      if_cablemodem.h: Add parenthesis around ioctl macros

Kees Cook (1):
      drm/radeon: check incoming cliprects pointer

Konrad Rzeszutek Wilk (1):
      xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.

Lachlan McIlroy (1):
      ext4: limit group search loop for non-extent files

Lan Tianyu (1):
      ACPI / EC: Restart transaction even when the IBF flag set

Lars-Peter Clausen (1):
      mfd: adp5520: Restore mode bits on resume

Li Fei (1):
      x86: Eliminate irq_mis_count counted in arch_irq_stat

Linus Torvalds (1):
      s390: move dummy io_remap_pfn_range() to asm/pgtable.h

Linus Walleij (1):
      ARM: u300: fix ages old copy/paste bug

Luis Henriques (1):
      Linux 3.5.7.13

Matthew Whitehead (1):
      3c509.c: call SET_NETDEV_DEV for all device types (ISA/ISAPnP/EISA)

Maxime Ripard (1):
      ARM: at91: Fix typo in restart code panic message

Michael Ellerman (1):
      powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()

Michael Neuling (1):
      powerpc: Add isync to copy_and_flush

Mika Kuoppala (1):
      fbcon: when font is freed, clear also vc_font.data

Mike Snitzer (1):
      dm thin: do not set discard_zeroes_data

Oleg Nesterov (1):
      usermodehelper: check subprocess_info->path != NULL

Patrick McHardy (1):
      net: use netdev_features_t in skb_needs_linearize()

Peter Zijlstra (2):
      perf/x86/intel/lbr: Fix LBR filter
      perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL

Philip Rakity (1):
      mmc: core: Fix bit width test failing on old eMMC cards

Philipp Reisner (1):
      drbd: fix for deadlock when using automatic split-brain-recovery

Rafał Bilski (1):
      cpufreq / Longhaul: Disable driver by default

Robert Jennings (1):
      powerpc: Bring all threads online prior to migration/hibernation

Sarah Sharp (1):
      xhci: Don't warn on empty ring for suspended devices.

Sergei Shtylyov (2):
      3c59x: fix freeing nonexistent resource on driver unload
      3c59x: fix PCI resource management

Shlomo Pongratz (1):
      iscsi-target: Fix processing of OOO commands

Shuah Khan (1):
      hp_accel: Ignore the error from lis3lv02d_poweron() at resume

Shuduo Sang (1):
      iwlwifi: add new pci id for 6x35 series

Steven A. Falco (1):
      i2c: xiic: must always write 16-bit words to TX_FIFO

Steven Rostedt (Red Hat) (1):
      tracing: Fix leaks of filter preds

Takashi Iwai (1):
      ALSA: usb-audio: Fix autopm error during probing

Terry Barnaby (1):
      mmc: atmel-mci: pio hang on block errors

Theodore Ts'o (1):
      ext4: add check for inodes_count overflow in new resize ioctl

Thomas Gleixner (1):
      tick: Cleanup NOHZ per cpu data on cpu down

Thommy Jakobsson (1):
      B43: Handle DMA RX descriptor underrun

Tirupathi Reddy (1):
      timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

Tomoya MORINAGA (1):
      pch_dma: Use GFP_ATOMIC because called from interrupt context

Vaidyanathan Srinivasan (1):
      powerpc: fix numa distance for form0 device tree

Wang YanQing (1):
      ALSA: HDA: Fix Oops caused by dereference NULL pointer

Wei Yongjun (2):
      dm snapshot: fix error return code in snapshot_ctr
      drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()

fanchaoting (1):
      nfsd: don't run get_file if nfs4_preprocess_stateid_op return error

françois romieu (2):
      r8169: fix vlan tag read ordering.
      r8169: honor jumbo settings when chipset is requested to start.

stephen hemminger (1):
      bridge: fix race with topology change timer

