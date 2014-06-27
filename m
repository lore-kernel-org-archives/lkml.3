Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaF0S2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:28:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41917 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaF0S2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:28:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.25
Date: Fri, 27 Jun 2014 11:28:02 -0700
Message-Id: <1403893683-23342-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.25 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.24 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                                      |   2 +-
 arch/arm/boot/dts/imx53.dtsi                  |   2 +-
 arch/arm/include/asm/uaccess.h                |   3 +-
 arch/arm/mach-imx/devices/platform-ipu-core.c |   2 +-
 arch/arm/mach-omap2/cclock3xxx_data.c         |   3 +-
 arch/powerpc/Makefile                         |   4 +-
 arch/powerpc/include/asm/ppc_asm.h            |   7 +-
 arch/x86/include/asm/hugetlb.h                |   1 +
 arch/x86/kernel/ldt.c                         |   4 +-
 arch/x86/vdso/vdso32-setup.c                  |   8 +
 drivers/acpi/blacklist.c                      |  13 ++
 drivers/crypto/caam/error.c                   |  10 +-
 drivers/dma/mv_xor.c                          |   8 +-
 drivers/gpu/drm/radeon/radeon_bios.c          |  14 ++
 drivers/gpu/drm/radeon/radeon_kms.c           |  57 +++---
 drivers/gpu/drm/radeon/radeon_object.c        |  38 ++--
 drivers/hwmon/emc1403.c                       |   4 +-
 drivers/i2c/busses/i2c-designware-core.c      |   3 +
 drivers/i2c/busses/i2c-rcar.c                 |   9 +-
 drivers/i2c/busses/i2c-s3c2410.c              |   2 +-
 drivers/input/mouse/synaptics.c               |  10 +-
 drivers/iommu/amd_iommu.c                     |   2 +-
 drivers/md/dm-crypt.c                         |  61 ++-----
 drivers/md/md.c                               |   7 +-
 drivers/media/i2c/ov7670.c                    |   2 +-
 drivers/media/media-device.c                  |   1 +
 drivers/media/tuners/fc2580.c                 |   6 +-
 drivers/media/tuners/fc2580_priv.h            |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  12 +-
 drivers/net/can/sja1000/peak_pci.c            |  14 +-
 drivers/net/ethernet/ti/cpsw.c                |   4 +
 drivers/pci/hotplug/shpchp_ctrl.c             |   4 +-
 drivers/staging/speakup/main.c                |   1 +
 drivers/staging/speakup/selection.c           |  38 +++-
 drivers/staging/speakup/speakup.h             |   1 +
 drivers/target/target_core_configfs.c         |   5 +
 drivers/usb/core/driver.c                     |   9 +-
 drivers/usb/core/hub.c                        |  15 +-
 drivers/usb/host/xhci-mem.c                   |  20 +--
 drivers/usb/serial/ftdi_sio.c                 |   2 +
 drivers/usb/serial/ftdi_sio_ids.h             |   5 +
 drivers/usb/serial/io_ti.c                    |   2 +-
 drivers/usb/serial/io_usbvend.h               |   2 +-
 drivers/usb/serial/option.c                   |   2 +
 fs/nfsd/nfs4acl.c                             |  17 +-
 fs/nfsd/nfs4state.c                           |  16 +-
 include/linux/interrupt.h                     |   5 +
 kernel/events/core.c                          |  16 +-
 kernel/futex.c                                | 239 ++++++++++++++++++++------
 kernel/hrtimer.c                              |   8 +-
 kernel/sched/core.c                           |   5 +-
 kernel/sched/cpupri.c                         |   3 +-
 kernel/sched/cputime.c                        |  32 ++--
 mm/memory-failure.c                           |  17 +-
 mm/mremap.c                                   |   9 +-
 mm/percpu.c                                   |   2 +-
 mm/rmap.c                                     |   3 +-
 net/ceph/messenger.c                          |  20 ++-
 sound/pci/hda/hda_intel.c                     |   3 +
 sound/pci/hda/patch_realtek.c                 |  10 +-
 sound/soc/codecs/wm8962.c                     |  15 +-
 sound/soc/codecs/wm8962.h                     |   4 +
 62 files changed, 581 insertions(+), 263 deletions(-)

Alan Stern (1):
      USB: Avoid runtime suspend loops for HCDs that can't handle suspend/resume

Alex Deucher (1):
      drm/radeon: handle non-VGA class pci devices with ATRM

Alex Williamson (1):
      iommu/amd: Fix interrupt remapping for aliased devices

Alexej Starschenko (1):
      USB: serial: option: add support for Novatel E371 PCIe card

Andrey Ryabinin (2):
      ARM: 8051/1: put_user: fix possible data corruption in put_user
      mm: rmap: fix use-after-free in __put_anon_vma

Anthony Iliopoulos (1):
      x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

Antti Palosaari (1):
      [media] fc2580: fix tuning failure on 32-bit arch

Arnd Bergmann (1):
      genirq: Provide irq_force_affinity fallback for non-SMP

Ben Hutchings (1):
      Staging: speakup: Move pasting into a work item

Charles Keepax (1):
      ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile

Chen Yucong (1):
      hwpoison, hugetlb: lock_page/unlock_page does not match for handling a free hugepage

Christian König (1):
      drm/radeon: also try GART for CPU accessed buffers

Chunwei Chen (1):
      libceph: fix corruption when using page_count 0 page in rbd

Du, Wenkai (1):
      i2c: designware: Mask all interrupts during i2c controller enable

Emil Goode (1):
      ARM: imx: fix error handling in ipu device registration

Ezequiel Garcia (1):
      dma: mv_xor: Flush descriptors before activating a channel

George McCollister (1):
      USB: ftdi_sio: add NovaTech OrionLXm product ID

Guennadi Liakhovetski (2):
      [media] V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
      [media] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode

Guenter Roeck (1):
      powerpc: Fix 64 bit builds with binutils 2.24

Hans de Goede (3):
      ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015PX
      Input: synaptics - add min/max quirk for the ThinkPad W540
      Input: synaptics - T540p - unify with other LEN0034 models

Horia Geanta (1):
      crypto: caam - add allocation failure handling in SPRINTFCAT macro

J. Bruce Fields (2):
      nfsd4: remove lockowner when removing lock stateid
      nfsd4: warn on finding lockowner without stateid's

Jianyu Zhan (1):
      percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()

Jiri Olsa (1):
      perf: Prevent false warning in perf_swevent_add

Johan Hovold (2):
      net: cpsw: fix null dereference at probe
      USB: io_ti: fix firmware download on big-endian machines (part 2)

Josef Gajdusek (2):
      hwmon: (emc1403) fix inverted store_hyst()
      hwmon: (emc1403) Support full range of known chip revision numbers

Jérôme Glisse (1):
      drm/radeon: avoid segfault on device open when accel is not working.

Kamal Mostafa (1):
      Linux 3.8.13.25

Kinglong Mee (1):
      NFSD: Call ->set_acl with a NULL ACL structure if no entries

Kirill A. Shutemov (1):
      mm, thp: close race between mremap() and split_huge_page()

Laurent Pinchart (1):
      ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms

Linus Torvalds (1):
      x86-64, modify_ldt: Make support for 16-bit segments a runtime option

Marcel Apfelbaum (1):
      PCI: shpchp: Check bridge's secondary (not primary) bus speed

Mathias Nyman (1):
      xhci: delete endpoints from bandwidth list before freeing whole device

Mikulas Patocka (1):
      dm crypt: fix cpu hotplug crash by removing per-cpu structure

Naoya Horiguchi (1):
      mm/memory-failure.c: fix memory leak by race between poison and unpoison

NeilBrown (2):
      md: avoid possible spinning md thread at shutdown.
      md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".

Nicholas Bellinger (1):
      target: Fix alua_access_state attribute OOPs for un-configured devices

Olof Johansson (1):
      i2c: s3c2410: resume race fix

Peter Zijlstra (2):
      perf: Limit perf_event_attr::sample_period to 63 bits
      sched/deadline: Change sched_getparam() behaviour vs SCHED_DEADLINE

Ronan Marquet (1):
      ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop

Salva Peiró (1):
      [media] media-device: fix infoleak in ioctl media_enum_entities()

Sascha Hauer (1):
      ARM: dts: i.MX53: Fix ipu register space size

Stephane Grosjean (1):
      can: peak_pci: prevent use after free at netdev removal

Steven Rostedt (Red Hat) (1):
      sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check

Takashi Iwai (2):
      ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets
      ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup

Thomas Gleixner (7):
      sched: Sanitize irq accounting madness
      futex: Add another early deadlock detection check
      futex: Prevent attaching to kernel threads
      futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr == uaddr2 in futex_requeue(..., requeue_pi=1)
      futex: Validate atomic acquisition in futex_lock_pi_atomic()
      futex: Always cleanup owner tid in unlock_pi
      futex: Make lookup_pi_state more robust

Trond Myklebust (1):
      NFSd: call rpc_destroy_wait_queue() from free_client()

Viresh Kumar (1):
      hrtimer: Set expiry time before switch_hrtimer_base()

Wolfram Sang (1):
      i2c: rcar: bail out on zero length transfers

