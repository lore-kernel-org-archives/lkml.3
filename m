Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab3HRUew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:34:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab3HRUet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:34:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/45] 3.10.8-stable review
Date: Sun, 18 Aug 2013 13:35:49 -0700
Message-Id: <20130818203620.996166594@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.8 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Aug 20 20:36:09 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.8-rc1

Li Zefan <lizefan@huawei.com>
    cpuset: fix the return value of cpuset_write_u64()

Jan Kara <jack@suse.cz>
    jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()

Guenter Roeck <linux@roeck-us.net>
    s390: Fix broken build

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k/atari: ARAnyM - Fix NatFeat module support

Andreas Schwab <schwab@linux-m68k.org>
    m68k: Truncate base in do_div()

Will Deacon <will.deacon@arm.com>
    ARM: 7809/1: perf: fix event validation for software group leaders

Linus Torvalds <torvalds@linux-foundation.org>
    Fix TLB gather virtual address range invalidation corner cases

Thomas Pugliese <thomas.pugliese@gmail.com>
    wusbcore: fix kernel panic when disconnecting a wireless USB->serial device

Stephen Boyd <sboyd@codeaurora.org>
    PM / QoS: Fix workqueue deadlock when using pm_qos_update_request_timeout()

Matt Burtch <matt@grid-net.com>
    USB-Serial: Fix error handling of usb_wwan

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: accept very late isochronous URBs

Johan Hovold <jhovold@gmail.com>
    USB: keyspan: fix null-deref at disconnect and release

Johan Hovold <jhovold@gmail.com>
    USB: mos7720: fix broken control requests

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix big-endian probe

Johan Hovold <jhovold@gmail.com>
    USB: ti_usb_3410_5052: fix big-endian firmware handling

Oliver Neukum <oneukum@suse.de>
    usb: add two quirky touchscreen

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix another nl80211_fam.attrbuf race

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add a fixup for Gateway LT27

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add pinfix for LG LW25 laptop

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix missing mute controls for CX5051

Torsten Schenk <torsten.schenk@zoho.com>
    ALSA: 6fire: make buffers DMA-able (midi)

Torsten Schenk <torsten.schenk@zoho.com>
    ALSA: 6fire: make buffers DMA-able (pcm)

Maksim A. Boyko <maksboyko@yandex.ru>
    ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam C525

Stephen Warren <swarren@nvidia.com>
    ASoC: tegra: fix Tegra30 I2S capture parameter setup

Brian Austin <brian.austin@cirrus.com>
    ASoC: cs42l52: Reorder Min/Max and update to SX_TLV for Beep Volume

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: dapm: Fix empty list check in dapm_new_mux()

Johannes Berg <johannes.berg@intel.com>
    cfg80211: fix P2P GO interface teardown

Johannes Berg <johannes.berg@intel.com>
    genetlink: fix family dump race

Stephane Grosjean <s.grosjean@peak-system.com>
    can: pcan_usb: fix wrong memcpy() bytes length

Johannes Berg <johannes.berg@intel.com>
    mac80211: continue using disabled channels while connected

Chris Wright <chrisw@sous-sol.org>
    mac80211: fix infinite loop in ieee80211_determine_chantype

Johannes Berg <johannes.berg@intel.com>
    mac80211: ignore HT primary channel while connected

Stanislaw Gruszka <sgruszka@redhat.com>
    iwl4965: reset firmware after rfkill off

Stanislaw Gruszka <sgruszka@redhat.com>
    iwl4965: set power mode early

Marc Zyngier <marc.zyngier@arm.com>
    ARM: KVM: clear exclusive monitor on all exception returns

Marc Zyngier <marc.zyngier@arm.com>
    ARM: KVM: add missing dsb before invalidating Stage-2 TLBs

Marc Zyngier <marc.zyngier@arm.com>
    ARM: KVM: perform save/restore of PAR

Jianpeng Ma <majianpeng@gmail.com>
    elevator: Fix a race in elevator switching

Peter Zijlstra <peterz@infradead.org>
    sched: Ensure update_cfs_shares() is called for parents of continuously-running tasks

yonghua zheng <younghua.zheng@gmail.com>
    fs/proc/task_mmu.c: fix buffer overflow in add_page_map()

Radu Caragea <sinaelgl@gmail.com>
    x86 get_unmapped_area(): use proper mmap base for bottom-up direction

Michal Simek <michal.simek@xilinx.com>
    microblaze: fix clone syscall

Andrey Vagin <avagin@openvz.org>
    memcg: don't initialize kmem-cache destroying work for root caches

Stephen Boyd <sboyd@codeaurora.org>
    perf/arm: Fix armpmu_map_hw_event()

Vince Weaver <vincent.weaver@maine.edu>
    perf/x86: Fix intel QPI uncore event definitions


-------------

Diffstat:

 Makefile                                      |  4 +--
 arch/Kconfig                                  |  6 ++++
 arch/arm/include/asm/kvm_asm.h                | 22 +++++++-------
 arch/arm/include/asm/tlb.h                    |  7 +++--
 arch/arm/kernel/perf_event.c                  | 10 ++++++-
 arch/arm/kvm/coproc.c                         |  4 +++
 arch/arm/kvm/interrupts.S                     | 16 ++++++++++-
 arch/arm/kvm/interrupts_head.S                | 10 +++++--
 arch/arm64/include/asm/tlb.h                  |  7 +++--
 arch/ia64/include/asm/tlb.h                   |  9 ++++--
 arch/m68k/emu/natfeat.c                       | 23 ++++++++++++---
 arch/m68k/include/asm/div64.h                 |  9 +++---
 arch/microblaze/Kconfig                       |  2 +-
 arch/s390/include/asm/tlb.h                   |  8 ++++--
 arch/sh/include/asm/tlb.h                     |  6 ++--
 arch/um/include/asm/tlb.h                     |  6 ++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  4 +--
 arch/x86/kernel/sys_x86_64.c                  |  2 +-
 arch/x86/mm/mmap.c                            |  2 +-
 block/cfq-iosched.c                           | 17 +++++++++--
 block/deadline-iosched.c                      | 16 +++++++++--
 block/elevator.c                              | 25 ++++------------
 block/noop-iosched.c                          | 17 +++++++++--
 drivers/net/can/usb/peak_usb/pcan_usb.c       |  2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c      | 16 +++++------
 drivers/net/wireless/iwlegacy/common.c        |  1 +
 drivers/usb/core/quirks.c                     |  6 ++++
 drivers/usb/host/ehci-sched.c                 | 13 ++++-----
 drivers/usb/serial/keyspan.c                  |  2 +-
 drivers/usb/serial/mos7720.c                  | 21 +++++++++-----
 drivers/usb/serial/mos7840.c                  |  2 +-
 drivers/usb/serial/ti_usb_3410_5052.c         |  9 +++---
 drivers/usb/serial/usb_wwan.c                 | 20 ++++++-------
 drivers/usb/wusbcore/wa-xfer.c                |  9 ++++--
 fs/exec.c                                     |  4 +--
 fs/ext4/ext4_jbd2.c                           |  8 +++---
 fs/proc/task_mmu.c                            |  8 +++---
 include/asm-generic/tlb.h                     |  2 +-
 include/linux/elevator.h                      |  6 +++-
 include/linux/sched.h                         |  1 +
 include/linux/syscalls.h                      |  5 ++++
 kernel/cpuset.c                               |  6 ++--
 kernel/fork.c                                 |  6 ++++
 kernel/power/qos.c                            | 13 ++++++++-
 kernel/sched/fair.c                           |  1 +
 mm/hugetlb.c                                  |  2 +-
 mm/memcontrol.c                               |  4 +--
 mm/memory.c                                   | 36 +++++++++++++----------
 mm/mmap.c                                     |  4 +--
 net/mac80211/mlme.c                           | 39 +++++++++++++++----------
 net/netlink/genetlink.c                       |  7 +++++
 net/wireless/core.c                           |  1 +
 net/wireless/nl80211.c                        |  6 ++--
 sound/pci/hda/hda_generic.c                   |  6 ++--
 sound/pci/hda/patch_realtek.c                 | 11 +++++++
 sound/soc/codecs/cs42l52.c                    |  2 +-
 sound/soc/soc-dapm.c                          |  7 +++--
 sound/soc/tegra/tegra30_i2s.c                 |  2 +-
 sound/usb/6fire/midi.c                        | 16 ++++++++++-
 sound/usb/6fire/midi.h                        |  6 +---
 sound/usb/6fire/pcm.c                         | 41 ++++++++++++++++++++++++++-
 sound/usb/6fire/pcm.h                         |  2 +-
 sound/usb/mixer.c                             |  1 +
 63 files changed, 406 insertions(+), 180 deletions(-)


