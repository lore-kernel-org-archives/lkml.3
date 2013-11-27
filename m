Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639Ab3K0BzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:55:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab3K0A5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/80] 3.10.21-stable review
Date: Tue, 26 Nov 2013 16:56:29 -0800
Message-Id: <20131127005640.934155527@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.21 release.
There are 80 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Nov 29 00:56:25 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.21-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.21-rc1

Rob Pearce <rob@flitspace.org.uk>
    drm/i915: No LVDS hardware on Intel D410PT and D425KT

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: quirk away phantom LVDS on Intel's D510MO mainboard

Jani Nikula <jani.nikula@intel.com>
    dmi: add support for exact DMI matches in addition to substring matching

Mauro Carvalho Chehab <m.chehab@samsung.com>
    cris: media platform drivers: fix build

Junxiao Bi <junxiao.bi@oracle.com>
    configfs: fix race between dentry put and lookup

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/vtime: correct idle time calculation

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2800usb: slow down TX status polling

Julius Werner <jwerner@chromium.org>
    usb: hub: Clear Port Reset Change during init/resume

Tomas Winkler <tomas.winkler@intel.com>
    mei: nfc: fix memory leak in error path

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Fix a data corruption issue when retransmitting RPC calls

Christoph Lameter <cl@linux.com>
    slub: Handle NULL parameter in kmem_cache_flags

Michael Neuling <mikey@neuling.org>
    powerpc/signals: Mark VSX not saved with small contexts

Anton Blanchard <anton@samba.org>
    powerpc: ppc64 address space capped at 32TB, mmap randomisation disabled

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/powernv: Add PE to its own PELTV

Prarit Bhargava <prarit@redhat.com>
    powerpc/vio: use strcpy in modalias_show

Anatolij Gustschin <agust@denx.de>
    powerpc/52xx: fix build breakage for MPC5200 LPBFIFO module

Mike Snitzer <snitzer@redhat.com>
    block: properly stack underlying max_segment_size to DM device

Mikulas Patocka <mpatocka@redhat.com>
    block: fix a probe argument to blk_register_region

Jeff Moyer <jmoyer@redhat.com>
    block: fix race between request completion and timeout handling

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Fix max6696 alarm handling

Christoffer Dall <christoffer.dall@linaro.org>
    arm/arm64: KVM: Fix hyp mappings of vmalloc regions

Greg Edwards <gedwards@ddn.com>
    KVM: IOMMU: hva align mapping page size

Kevin Hao <haokexin@gmail.com>
    ftrace/x86: skip over the breakpoint for ftrace caller

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix emulation of "movzbl %bpl, %eax"

Thomas Renninger <trenn@suse.de>
    x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error

Christoph Hellwig <hch@infradead.org>
    nfsd: make sure to balance get/put_write_access

Christoph Hellwig <hch@infradead.org>
    nfsd: split up nfsd_setattr

J. Bruce Fields <bfields@redhat.com>
    nfsd: return better errors to exportfs

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Fix state reference counting in _nfs4_opendata_reclaim_to_nfs4_state

Weston Andros Adamson <dros@netapp.com>
    NFSv4: don't reprocess cached open CLAIM_PREVIOUS

Weston Andros Adamson <dros@netapp.com>
    NFSv4: don't fail on missing fattr in open recover

Weston Andros Adamson <dros@netapp.com>
    NFSv4: fix NULL dereference in open recover

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Fix a use-after-free situation in _nfs4_proc_getlk()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Provide missing pin configs for VAIO with ALC260

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Add headset quirk for Dell Inspiron 3135

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix the headphone jack detection on Sony VAIO TX

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix unbalanced runtime PM notification at resume

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Don't clear the power state at snd_hda_codec_reset()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Don't turn off EAPD for headphone on Lenovo N100

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Check keep_eapd_on before inv_eapd

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Fix Line Out automute on Realtek multifunction jacks

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add pincfg fixup for ASUS W5A

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add support for CX20952

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Make sure mute LEDs stay on during runtime suspend (Realtek)

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Enable SPDIF for Acer TravelMate 6293

Kailang Yang <kailang@realtek.com>
    ALSA: hda - Add support of ALC255 codecs

Takashi Iwai <tiwai@suse.de>
    ALSA: msnd: Avoid duplicated driver name

Vinod Koul <vinod.koul@intel.com>
    ALSA: compress: fix drain calls blocking other compress functions (v6)

Vinod Koul <vinod.koul@intel.com>
    ALSA: compress: fix drain calls blocking other compress functions

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Fix probe of multiple cards

Kees Cook <keescook@chromium.org>
    exec/ptrace: fix get_dumpable() incorrect tests

Mimi Zohar <zohar@linux.vnet.ibm.com>
    Revert "ima: policy for RAMFS"

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2x00: fix HT TX descriptor settings regression

Gabor Juhos <juhosg@openwrt.org>
    rt2x00: rt2800lib: fix VGC adjustment for RT5592

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2x00: check if device is still available on rt2x00mac_flush()

Felix Fietkau <nbd@openwrt.org>
    rt2x00: fix a crash bug in the HT descriptor handling fix

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / hotplug: Do not execute "insert in progress" _OST

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / hotplug: Fix handle_root_bridge_removal()

Aaron Lu <aaron.lu@intel.com>
    ACPI / video: Quirk initial backlight level 0

Puneet Kumar <puneetster@chromium.org>
    ACPI / EC: Ensure lock is acquired before accessing ec struct members

Steven Rostedt <rostedt@goodmis.org>
    perf/ftrace: Fix paranoid level for enabling function tracer

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Support PCIe Capability Slot registers only for ports with slots

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Remove PCIe Capability version checks

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Allow PCIe Capability link-related register access for switches

Peter Zijlstra <peterz@infradead.org>
    sched, idle: Fix the idle polling state logic

Andy Adamson <andros@netapp.com>
    SUNRPC: don't map EKEYEXPIRED to EACCES in call_refreshresult

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nva3-/disp: fix hda eld writing, needs to be padded

Emil Velikov <emil.l.velikov@gmail.com>
    drm/nv50-/disp: remove dcb_outp_match call, and related variables

Greg Thelen <gthelen@google.com>
    ipc,shm: fix shm_file deletion races

Jesper Nilsson <jesper.nilsson@axis.com>
    ipc,shm: correct error return value in shmctl (SHM_UNLOCK)

Markus Pargmann <mpa@pengutronix.de>
    can: c_can: Fix RX message handling, handle lost message before EOB

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: s390 - Fix aes-cbc IV corruption

Neil Horman <nhorman@tuxdriver.com>
    crypto: ansi_cprng - Fix off by one error in non-block size request

Olivier Sobrie <olivier@sobrie.be>
    can: kvaser_usb: fix usb endpoints detection

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix tiocmget error handling

Bob Moore <robert.moore@intel.com>
    ACPICA: Fix for a Store->ArgX when ArgX contains a reference to a field.

Bob Moore <robert.moore@intel.com>
    ACPICA: Return error if DerefOf resolves to a null package element.

Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
    aacraid: prevent invalid pointer dereference

Dan Carpenter <dan.carpenter@oracle.com>
    libertas: potential oops in debugfs

Bob Moore <robert.moore@intel.com>
    ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and BufferField refs.


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/kvm/mmu.c                                 |  34 +++-
 arch/cris/include/asm/io.h                         |   1 +
 arch/ia64/include/asm/processor.h                  |   2 +-
 arch/powerpc/kernel/signal_32.c                    |  10 +-
 arch/powerpc/kernel/vio.c                          |   4 +-
 arch/powerpc/mm/slice.c                            |   2 +-
 arch/powerpc/platforms/52xx/Kconfig                |   2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |  12 +-
 arch/s390/crypto/aes_s390.c                        |  19 ++-
 arch/s390/kernel/smp.c                             |   4 +-
 arch/s390/kernel/vtime.c                           |   2 +-
 arch/x86/kernel/ftrace.c                           |  14 +-
 arch/x86/kernel/microcode_amd.c                    |   2 +-
 arch/x86/kernel/process.c                          |   6 +-
 arch/x86/kvm/emulate.c                             |   5 +-
 block/blk-core.c                                   |   1 +
 block/blk-settings.c                               |   1 +
 block/blk-timeout.c                                |   3 +-
 crypto/ansi_cprng.c                                |   4 +-
 drivers/acpi/acpica/exoparg1.c                     |  48 +++++-
 drivers/acpi/acpica/exstore.c                      | 166 ++++++++++++--------
 drivers/acpi/ec.c                                  |   3 +-
 drivers/acpi/pci_root.c                            |   5 +-
 drivers/acpi/processor_idle.c                      |  46 ++----
 drivers/acpi/scan.c                                |   2 -
 drivers/acpi/video.c                               |   2 +-
 drivers/block/brd.c                                |   2 +-
 drivers/block/loop.c                               |   2 +-
 drivers/firmware/dmi_scan.c                        |  12 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |  24 +++
 drivers/gpu/drm/nouveau/core/engine/disp/hdanva3.c |   2 +
 drivers/gpu/drm/nouveau/core/engine/disp/hdanvd0.c |   2 +
 drivers/gpu/drm/nouveau/core/engine/disp/sornv50.c |   8 -
 drivers/hwmon/lm90.c                               |  11 +-
 drivers/idle/intel_idle.c                          |   2 +-
 drivers/misc/mei/nfc.c                             |  10 +-
 drivers/net/can/c_can/c_can.c                      |   6 +-
 drivers/net/can/usb/kvaser_usb.c                   |  20 ++-
 drivers/net/wireless/libertas/debugfs.c            |   6 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |  11 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |  12 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |   3 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h            |   2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   7 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   4 +-
 drivers/pci/access.c                               |  19 +--
 drivers/scsi/aacraid/commctrl.c                    |   3 +-
 drivers/usb/core/hub.c                             |   5 +
 drivers/usb/serial/mos7840.c                       |   4 +
 fs/configfs/dir.c                                  |  16 +-
 fs/exec.c                                          |   6 +
 fs/nfs/nfs4proc.c                                  |  22 ++-
 fs/nfsd/export.c                                   |  15 +-
 fs/nfsd/vfs.c                                      | 173 ++++++++++++---------
 include/linux/binfmts.h                            |   3 -
 include/linux/mod_devicetable.h                    |   6 +-
 include/linux/sched.h                              |  82 +++++++++-
 include/linux/thread_info.h                        |   2 +
 include/sound/compress_driver.h                    |   9 ++
 ipc/shm.c                                          |  37 ++++-
 kernel/cpu/idle.c                                  |   9 +-
 kernel/ptrace.c                                    |   3 +-
 kernel/trace/trace_event_perf.c                    |   2 +-
 mm/slub.c                                          |   4 +-
 net/sunrpc/clnt.c                                  |   2 +-
 net/sunrpc/xprtsock.c                              |  28 +++-
 security/integrity/ima/ima_policy.c                |   1 -
 sound/core/compress_offload.c                      |  54 ++++++-
 sound/isa/msnd/msnd_pinnacle.c                     |   4 +-
 sound/pci/hda/hda_codec.c                          |   7 +-
 sound/pci/hda/hda_generic.c                        |   4 +-
 sound/pci/hda/patch_analog.c                       |   6 +-
 sound/pci/hda/patch_conexant.c                     |   3 +
 sound/pci/hda/patch_realtek.c                      |  83 +++++++++-
 sound/usb/6fire/chip.c                             |   2 +-
 virt/kvm/iommu.c                                   |   4 +
 77 files changed, 818 insertions(+), 350 deletions(-)


