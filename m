Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbaCEOhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:37:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41519 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbaCEOhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.5.y.z extended stable] Linux 3.5.7.32 stable review
Date: Wed,  5 Mar 2014 14:36:04 +0000
Message-Id: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.5.7.32 stable kernel.

This version contains 62 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.5.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.5.y-review

The review period for version 3.5.7.32 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.5.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 arch/arm/include/asm/cacheflush.h              |   1 +
 arch/arm/mm/proc-v6.S                          |   3 +-
 arch/arm/mm/proc-v7.S                          |   2 +-
 arch/avr32/Makefile                            |   2 +-
 arch/avr32/boards/mimc200/fram.c               |   1 +
 arch/powerpc/kernel/crash_dump.c               |   8 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c   |  22 ++---
 arch/x86/kernel/cpu/perf_event.c               |   3 +
 arch/x86/kernel/pci-dma.c                      |   4 +-
 arch/x86/kvm/mmu.c                             |   3 +
 arch/x86/kvm/vmx.c                             |   2 +-
 arch/x86/kvm/x86.c                             |   2 +-
 drivers/acpi/processor_throttling.c            |  69 +++++++------
 drivers/acpi/video.c                           |   8 +-
 drivers/ata/ahci.c                             |  14 +++
 drivers/ata/libata-pmp.c                       |   7 +-
 drivers/ata/sata_sil.c                         |   1 +
 drivers/cpufreq/powernow-k8.c                  |  10 +-
 drivers/dma/ste_dma40.c                        |   4 +-
 drivers/edac/i7300_edac.c                      |  38 ++++----
 drivers/edac/i7core_edac.c                     |   9 +-
 drivers/gpu/drm/i915/intel_dp.c                |  19 ++--
 drivers/hwmon/max1668.c                        |   2 +-
 drivers/input/mouse/elantech.c                 |  45 ++++++++-
 drivers/md/dm-mpath.c                          |   7 +-
 drivers/net/bonding/bond_3ad.c                 |   6 +-
 drivers/net/bonding/bond_3ad.h                 |   1 +
 drivers/net/ethernet/broadcom/tg3.c            |   4 +-
 drivers/net/ethernet/intel/e100.c              |   2 +-
 drivers/net/usb/asix.c                         | 128 +++++++++++++++++++------
 drivers/net/usb/gl620a.c                       |   4 +
 drivers/net/usb/mcs7830.c                      |   5 +-
 drivers/net/usb/net1080.c                      |   4 +
 drivers/net/usb/qmi_wwan.c                     |   8 +-
 drivers/net/usb/rndis_host.c                   |   4 +
 drivers/net/usb/smsc75xx.c                     |   4 +
 drivers/net/usb/smsc95xx.c                     |   4 +
 drivers/net/usb/usbnet.c                       |  25 ++---
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h |  10 +-
 drivers/net/wireless/rtlwifi/ps.c              |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c    |  18 +++-
 drivers/pci/pci.c                              |  10 ++
 drivers/scsi/qla2xxx/qla_target.c              |   3 +-
 drivers/usb/host/ehci-hcd.c                    |  13 ++-
 drivers/usb/serial/ftdi_sio.c                  |   2 +
 drivers/usb/serial/ftdi_sio_ids.h              |   6 ++
 drivers/usb/serial/option.c                    |   3 +-
 fs/cifs/file.c                                 |  37 ++++++-
 fs/ext4/ext4.h                                 |   2 +
 fs/ext4/resize.c                               |   2 +-
 fs/ext4/super.c                                |  20 ++--
 fs/proc/proc_devtree.c                         |   1 +
 fs/quota/dquot.c                               |  14 ++-
 include/linux/ipc_namespace.h                  |   2 -
 include/linux/skbuff.h                         |  19 ++++
 ipc/mq_sysctl.c                                |  18 ++--
 ipc/mqueue.c                                   |   6 +-
 kernel/cgroup.c                                |   5 +
 kernel/events/core.c                           |  12 +--
 kernel/workqueue.c                             |   7 ++
 net/core/fib_rules.c                           |   7 ++
 net/core/skbuff.c                              |  25 +++++
 net/ipv4/ip_forward.c                          |  68 ++++++++++++-
 net/ipv6/ip6_output.c                          |  13 ++-
 net/sctp/socket.c                              |  41 ++++++--
 net/sunrpc/xprtsock.c                          |   6 +-
 security/selinux/ss/policydb.c                 |   8 +-
 sound/soc/codecs/sta32x.c                      |  74 +++++++-------
 sound/soc/codecs/wm8770.c                      |   4 +-
 sound/soc/codecs/wm8958-dsp2.c                 |   2 +-
 sound/usb/mixer_maps.c                         |   9 ++
 tools/perf/util/parse-events.c                 |   2 +-
 72 files changed, 704 insertions(+), 252 deletions(-)

Aleksander Morgado (1):
      USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8

Andrew Honig (1):
      kvm: x86: fix emulator buffer overflow (CVE-2014-0049)

Arnaldo Carvalho de Melo (1):
      perf tools: Remove extraneous newline when parsing hardware cache events

Bjorn Helgaas (1):
      PCI: Enable INTx if BIOS left them disabled

Chen Gang (1):
      avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use

Clemens Ladisch (1):
      ALSA: usb-audio: work around KEF X300A firmware bug

Daniel Borkmann (1):
      net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode

Dave Jones (1):
      fs/proc/proc_devtree.c: remove empty /proc/device-tree when no openfirmware exists.

Davidlohr Bueso (1):
      ipc,mqueue: remove limits for the amount of system-wide queues

Denis V. Lunev (1):
      ata: enable quirk from jmicron JMB350 for JMB394

Dr. Greg Wettstein (1):
      qla2xxx: Fix kernel panic on selective retransmission request

Emil Goode (3):
      usbnet: remove generic hard_header_len check
      net: asix: handle packets crossing URB boundaries
      net: asix: add missing flag to struct driver_info

Eric Paris (1):
      SELinux: bigendian problems with filename trans rules

Florian Westphal (2):
      net: add and use skb_gso_transport_seglen()
      net: ip, ipv6: handle gso skbs in forwarding path

Guenter Roeck (1):
      hwmon: (max1668) Fix writing the minimum temperature

Hannes Reinecke (1):
      dm mpath: fix stalls when handling invalid ioctls

Hans de Goede (2):
      ACPI / video: Filter the _BCL table for duplicate brightness values
      Input: elantech -  improve clickpad detection

Jan Kara (1):
      quota: Fix race between dqput() and dquot_scan_active()

Jani Nikula (2):
      drm/i915/dp: increase native aux defer retry timeout
      drm/i915/dp: add native aux defer retry limit

Jean Delvare (2):
      i7core_edac: Fix PCI device reference count
      i7300_edac: Fix device reference count

Jeff Layton (1):
      cifs: ensure that uncached writes handle unmapped areas correctly

Jiri Bohac (1):
      bonding: 802.3ad: make aggregator_identifier bond-private

Jiri Olsa (1):
      perf tools: Fix cache event name generation

Joerg Dorchain (1):
      USB: ftdi_sio: add Cressi Leonardo PID

Lai Jiangshan (1):
      workqueue: ensure @task is valid across kthread_stop()

Lan Tianyu (1):
      ACPI / processor: Rework processor throttling with work_on_cpu()

Lars-Peter Clausen (1):
      ASoC: wm8958-dsp: Fix firmware block loading

Laurent Dufour (1):
      powerpc/crashdump : Fix page frame number check in copy_oldmem_page

Levente Kurusa (1):
      ahci: disable NCQ on Samsung pci-e SSDs on macbooks

Linus Walleij (1):
      dma: ste_dma40: don't dereference free:d descriptor

Maciej Żenczykowski (1):
      net: fix 'ip rule' iif/oif device rename

Marcelo Tosatti (2):
      KVM: MMU: handle invalid root_hpa at __direct_map
      KVM: VMX: fix use after free of vmx->loaded_vmcs

Marek Szyprowski (1):
      x86: dma-mapping: fix GFP_ATOMIC macro usage

Michele Baldessari (1):
      e100: Fix "disabling already-disabled device" warning

Nithin Sujir (1):
      tg3: Fix deadlock in tg3_change_mtu()

Olivier Langlois (2):
      rtlwifi: rtl8192ce: Fix too long disable of IRQs
      rtlwifi: Fix incorrect return from rtl_ps_enable_nic()

Paul Gortmaker (1):
      avr32: fix missing module.h causing build failure in mimc200/fram.c

Peter Zijlstra (2):
      perf/x86: Fix event scheduling
      perf: Fix hotplug splat

Srivatsa S. Bhat (1):
      cpufreq: powernow-k8: Initialize per-cpu data-structures properly

Stanislaw Gruszka (2):
      rtl8187: fix regression on MIPS without coherent DMA
      usb: ehci: fix deadlock when threadirqs option is used

Takashi Iwai (3):
      ASoC: sta32x: Fix array access overflow
      ASoC: wm8770: Fix wrong number of enum items
      ASoC: sta32x: Fix wrong enum for limiter2 release rate

Tejun Heo (2):
      sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN
      cgroup: update cgroup_enable_task_cg_lists() to grab siglock

Theodore Ts'o (3):
      ext4: don't try to modify s_flags if the the file system is read-only
      ext4: fix online resize with a non-standard blocks per group setting
      ext4: don't leave i_crtime.tv_sec uninitialized

Tony Breeds (1):
      powerpc/le: Ensure that the 'stop-self' RTAS token is handled correctly

Trond Myklebust (1):
      SUNRPC: Fix races in xs_nospace()

Vinayak Kale (1):
      ARM: 7957/1: add DSB after icache flush in __flush_icache_all()

Will Deacon (1):
      ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling MMU
