Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaFZJAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:00:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58595 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbaFZI7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:59:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.11.y.z extended stable] Linux 3.11.10.12
Date: Thu, 26 Jun 2014 09:59:46 +0100
Message-Id: <1403773187-30694-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.11.10.12 kernel.

The updated 3.11.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.11.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.11.y;a=shortlog

The diff from v3.11.10.11 is posted as a follow-up to this email.

The 3.11.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Makefile                                        |   2 +-
 arch/arm/include/asm/uaccess.h                  |   3 +-
 arch/arm/kernel/entry-header.S                  |   4 +
 arch/arm/mach-imx/devices/platform-ipu-core.c   |   2 +-
 arch/arm/mach-omap2/cclock3xxx_data.c           |   3 +-
 arch/arm/mach-omap2/cpuidle44xx.c               |  25 ++-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c      |   2 +-
 arch/mips/include/asm/thread_info.h             |   2 +-
 arch/powerpc/Makefile                           |   4 +-
 arch/powerpc/include/asm/ppc_asm.h              |   7 +-
 arch/powerpc/kernel/machine_kexec_64.c          |   2 +-
 arch/s390/crypto/aes_s390.c                     |   3 +
 arch/s390/crypto/des_s390.c                     |   3 +
 arch/s390/net/bpf_jit_comp.c                    |   2 +-
 drivers/clk/versatile/clk-vexpress-osc.c        |   2 +-
 drivers/cpufreq/cpufreq-cpu0.c                  |  16 +-
 drivers/cpufreq/cpufreq_governor.c              |   6 +
 drivers/dma/dw/core.c                           |  20 +-
 drivers/dma/mv_xor.c                            |   8 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c      |  54 +++---
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c |  19 +-
 drivers/gpu/drm/radeon/radeon_bios.c            |  14 ++
 drivers/gpu/drm/radeon/radeon_cs.c              |   6 +
 drivers/gpu/drm/radeon/radeon_kms.c             |  57 +++---
 drivers/gpu/drm/radeon/radeon_object.c          |  38 ++--
 drivers/gpu/drm/radeon/sid.h                    |   4 +-
 drivers/hwmon/Kconfig                           |   2 +-
 drivers/hwmon/ntc_thermistor.c                  |  15 +-
 drivers/i2c/busses/i2c-designware-core.c        |   3 +
 drivers/infiniband/ulp/isert/ib_isert.c         |  10 +
 drivers/input/mouse/synaptics.c                 |  10 +-
 drivers/leds/leds-pwm.c                         |  23 ++-
 drivers/md/dm-cache-target.c                    |   2 +
 drivers/md/md.c                                 |   5 +-
 drivers/net/can/led.c                           |   3 +
 drivers/net/can/sja1000/peak_pci.c              |  14 +-
 drivers/net/ethernet/ti/cpsw.c                  |   4 +
 drivers/scsi/megaraid/megaraid_sas.h            |   1 -
 drivers/scsi/megaraid/megaraid_sas_base.c       |   5 +-
 drivers/scsi/scsi_scan.c                        | 112 +++++++----
 drivers/scsi/scsi_sysfs.c                       |  20 +-
 drivers/staging/comedi/drivers/ni_daq_700.c     |   2 +
 drivers/staging/speakup/main.c                  |   1 +
 drivers/staging/speakup/selection.c             |  38 +++-
 drivers/staging/speakup/speakup.h               |   1 +
 drivers/target/iscsi/iscsi_target.c             |   1 +
 drivers/target/iscsi/iscsi_target_core.h        |   1 +
 drivers/target/iscsi/iscsi_target_login.c       |  58 +++---
 drivers/target/iscsi/iscsi_target_tpg.c         |   9 +-
 drivers/target/target_core_alua.c               |   9 +
 drivers/target/target_core_configfs.c           |   5 +
 drivers/usb/core/driver.c                       |   9 +-
 drivers/usb/core/hub.c                          |  15 +-
 drivers/usb/host/xhci-mem.c                     |  20 +-
 drivers/usb/serial/ftdi_sio.c                   |   2 +
 drivers/usb/serial/ftdi_sio_ids.h               |   5 +
 drivers/usb/serial/io_ti.c                      |   2 +-
 drivers/usb/serial/io_usbvend.h                 |   2 +-
 drivers/usb/serial/option.c                     |   2 +
 fs/attr.c                                       |   8 +-
 fs/inode.c                                      |  10 +-
 fs/namei.c                                      |  11 +-
 fs/nfsd/nfs4state.c                             |  15 +-
 include/linux/capability.h                      |   2 +-
 include/linux/interrupt.h                       |   5 +
 include/linux/kvm_host.h                        |   1 -
 include/linux/percpu-refcount.h                 |   6 +-
 include/scsi/scsi_device.h                      |   3 +-
 include/uapi/linux/usb/Kbuild                   |   1 +
 include/uapi/linux/usb/cdc-wdm.h                |   2 +
 kernel/audit.c                                  |   4 +-
 kernel/auditsc.c                                |  27 ++-
 kernel/capability.c                             |  18 +-
 kernel/events/core.c                            |  63 ++++---
 kernel/futex.c                                  | 239 ++++++++++++++++++------
 kernel/kexec.c                                  |   8 +
 kernel/rtmutex.c                                |  32 +++-
 kernel/sched/cpupri.c                           |   3 +-
 kernel/sched/cputime.c                          |  32 ++--
 mm/compaction.c                                 |  35 ++--
 mm/memory-failure.c                             |  17 +-
 mm/page-writeback.c                             |   4 +-
 mm/rmap.c                                       |   3 +-
 net/core/skbuff.c                               |   3 +
 net/ipv4/netfilter/nf_defrag_ipv4.c             |   5 +-
 net/iucv/af_iucv.c                              |   2 +-
 net/mac80211/ieee80211_i.h                      |   1 +
 net/mac80211/mlme.c                             |  20 +-
 net/mac80211/offchannel.c                       |  27 ++-
 net/wireless/sme.c                              |   2 +-
 sound/pci/hda/hda_intel.c                       |   3 +
 sound/pci/hda/patch_analog.c                    |   1 +
 sound/pci/hda/patch_realtek.c                   |  10 +-
 virt/kvm/async_pf.c                             |  14 +-
 95 files changed, 929 insertions(+), 429 deletions(-)

Alan Stern (1):
      USB: Avoid runtime suspend loops for HCDs that can't handle suspend/resume

Alex Deucher (2):
      drm/radeon: handle non-VGA class pci devices with ATRM
      drm/radeon: fix register typo on si

Alexej Starschenko (1):
      USB: serial: option: add support for Novatel E371 PCIe card

Andrey Ryabinin (2):
      ARM: 8051/1: put_user: fix possible data corruption in put_user
      mm: rmap: fix use-after-free in __put_anon_vma

Andy Lutomirski (2):
      fs,userns: Change inode_capable to capable_wrt_inode_uidgid
      auditsc: audit_krule mask accesses need bounds checking

Andy Shevchenko (2):
      dma: dw: allow shared interrupts
      dmaengine: dw: went back to plain {request,free}_irq() calls

Arnd Bergmann (1):
      genirq: Provide irq_force_affinity fallback for non-SMP

Ben Collins (1):
      [SCSI] megaraid: Use resource_size_t for PCI resources, not long

Ben Hutchings (1):
      Staging: speakup: Move pasting into a work item

Ben Skeggs (1):
      drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup

Bibek Basu (1):
      cpufreq: remove race while accessing cur_policy

Bjørn Mork (1):
      usb: cdc-wdm: export cdc-wdm uapi header

Chen Yucong (1):
      hwpoison, hugetlb: lock_page/unlock_page does not match for handling a free hugepage

Chris Wilson (1):
      drm/i915: Only copy back the modified fields to userspace from execbuffer

Christian König (1):
      drm/radeon: also try GART for CPU accessed buffers

Dan Carpenter (1):
      clk: vexpress: NULL dereference on error path

Du, Wenkai (1):
      i2c: designware: Mask all interrupts during i2c controller enable

Eliad Peller (1):
      cfg80211: free sme on connection failures

Emil Goode (1):
      ARM: imx: fix error handling in ipu device registration

Emmanuel Grumbach (1):
      mac80211: fix suspend vs. association race

Ezequiel Garcia (1):
      dma: mv_xor: Flush descriptors before activating a channel

Florian Westphal (1):
      netfilter: ipv4: defrag: set local_df flag on defragmented skb

George McCollister (1):
      USB: ftdi_sio: add NovaTech OrionLXm product ID

Greg Kroah-Hartman (1):
      USB: cdc-wdm: properly include types.h

Guenter Roeck (1):
      powerpc: Fix 64 bit builds with binutils 2.24

Hans de Goede (2):
      Input: synaptics - add min/max quirk for the ThinkPad W540
      Input: synaptics - T540p - unify with other LEN0034 models

Harald Freudenberger (1):
      crypto: s390 - fix aes,des ctr mode concurrency finding.

Heiko Carstens (1):
      net: filter: s390: fix JIT address randomization

Heinz Mauelshagen (1):
      dm cache: always split discards on cache block boundaries

Ian Abbott (1):
      staging: comedi: ni_daq_700: add mux settling delay

J. Bruce Fields (2):
      nfsd4: remove lockowner when removing lock stateid
      nfsd4: warn on finding lockowner without stateid's

James Bottomley (2):
      [SCSI] fix our current target reap infrastructure
      [SCSI] dual scan thread bug fix

Jean Delvare (2):
      hwmon: (ntc_thermistor) Fix dependencies
      hwmon: (ntc_thermistor) Fix OF device ID mapping

Jiri Olsa (1):
      perf: Prevent false warning in perf_swevent_add

Johan Hovold (2):
      net: cpsw: fix null dereference at probe
      USB: io_ti: fix firmware download on big-endian machines (part 2)

Johannes Berg (1):
      mac80211: fix on-channel remain-on-channel

Jérôme Glisse (1):
      drm/radeon: avoid segfault on device open when accel is not working.

Laurent Pinchart (1):
      ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms

Lucas Stach (1):
      cpufreq: cpu0: drop wrong devm usage

Luis Henriques (1):
      Linux 3.11.10.12

Marek Olšák (1):
      drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission

Markos Chandras (1):
      MIPS: asm: thread_info: Add _TIF_SECCOMP flag

Martin Peres (1):
      drm/nouveau/pm/fan: drop the fan lock in fan_update() before rescheduling

Mathias Nyman (1):
      xhci: delete endpoints from bandwidth list before freeing whole device

Michael S. Tsirkin (1):
      skbuff: skb_segment: orphan frags before copying

Naoya Horiguchi (1):
      mm/memory-failure.c: fix memory leak by race between poison and unpoison

NeilBrown (2):
      md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".
      md: always set MD_RECOVERY_INTR when interrupting a reshape thread.

Nicholas Bellinger (4):
      iser-target: Add missing target_put_sess_cmd for ImmedateData failure
      target: Fix alua_access_state attribute OOPs for un-configured devices
      iser-target: Fix multi network portal shutdown regression
      target: Allow READ_CAPACITY opcode in ALUA Standby access state

Oleg Nesterov (1):
      KVM: async_pf: mm->mm_users can not pin apf->mm

Oliver Hartkopp (1):
      can: only rename enabled led triggers when changing the netdev name

Peter Ujfalusi (1):
      ARM: omap5: hwmod_data: Correct IDLEMODE for McPDM

Peter Zijlstra (2):
      perf: Limit perf_event_attr::sample_period to 63 bits
      perf: Fix race in removing an event

Rabin Vincent (1):
      ARM: 8064/1: fix v7-M signal return

Radim Krčmář (2):
      kvm: free resources after canceling async_pf
      kvm: remove .done from struct kvm_async_pf

Richard Guy Briggs (1):
      audit: restore order of tty and ses fields in log output

Rik van Riel (1):
      mm/page-writeback.c: fix divide by zero in pos_ratio_polynom

Roland Dreier (1):
      iscsi-target: Fix wrong buffer / buffer overrun in iscsi_change_param_value()

Ronan Marquet (1):
      ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop

Russell King (1):
      leds: leds-pwm: properly clean up after probe failure

Sagi Grimberg (1):
      Target/iscsi,iser: Avoid accepting transport connections during stop stage

Santosh Shilimkar (1):
      ARM: OMAP4: Fix the boot regression with CPU_IDLE enabled

Sebastian Ott (1):
      percpu-refcount: fix usage of this_cpu_ops

Srivatsa S. Bhat (1):
      powerpc, kexec: Fix "Processor X is stuck" issue during kexec from ST mode

Stephane Grosjean (1):
      can: peak_pci: prevent use after free at netdev removal

Steven Rostedt (Red Hat) (1):
      sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check

Takashi Iwai (3):
      ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets
      ALSA: hda/analog - Fix silent output on ASUS A8JN
      ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup

Thomas Gleixner (8):
      sched: Sanitize irq accounting madness
      futex: Add another early deadlock detection check
      futex: Prevent attaching to kernel threads
      rtmutex: Fix deadlock detector for real
      futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr == uaddr2 in futex_requeue(..., requeue_pi=1)
      futex: Validate atomic acquisition in futex_lock_pi_atomic()
      futex: Always cleanup owner tid in unlock_pi
      futex: Make lookup_pi_state more robust

Ursula Braun (1):
      af_iucv: wrong mapping of sent and confirmed skbs

Vlastimil Babka (2):
      mm: compaction: reset cached scanner pfn's before reading them
      mm: compaction: detect when scanners meet in isolate_freepages

