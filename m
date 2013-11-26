Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab3KZSMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:12:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3KZSMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:12:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.11 00/36] 3.11.10-stable review
Date: Tue, 26 Nov 2013 10:12:10 -0800
Message-Id: <20131126181025.029404973@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------------------------------
NOTE:
  This is the LAST 3.11.x kernel I will be releasing.  Everyone should
  be moving to the 3.12.x series at this point in time.  After this
  kernel is released, 3.11 will be end-of-life.
---------------------------------

This is the start of the stable review cycle for the 3.11.10 release.
There are 36 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Nov 28 18:08:16 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.10-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.11.10-rc1

Kees Cook <keescook@chromium.org>
    exec/ptrace: fix get_dumpable() incorrect tests

Mimi Zohar <zohar@linux.vnet.ibm.com>
    Revert "ima: policy for RAMFS"

Hans de Goede <hdegoede@redhat.com>
    Bluetooth: revert: "Bluetooth: Add missing reset_resume dev_pm_ops"

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2x00: fix HT TX descriptor settings regression

Gabor Juhos <juhosg@openwrt.org>
    rt2x00: rt2800lib: fix VGC adjustment for RT5592

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2x00: check if device is still available on rt2x00mac_flush()

Felix Fietkau <nbd@openwrt.org>
    rt2x00: fix a crash bug in the HT descriptor handling fix

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Fix a bug in channel rescind code

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: avoid memleak for subdevice private

Rashika Kheria <rashika.kheria@gmail.com>
    Staging: zram: Fix access of NULL pointer

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

Takashi Iwai <tiwai@suse.de>
    thinkpad_acpi: Fix build error when CONFIG_SND_MAX_CARDS > 32

Ben Skeggs <bskeggs@redhat.com>
    drm/nvc0-/gr: fix a number of missing explicit array terminators...

Greg Thelen <gthelen@google.com>
    ipc,shm: fix shm_file deletion races

Jesper Nilsson <jesper.nilsson@axis.com>
    ipc,shm: correct error return value in shmctl (SHM_UNLOCK)

hahnjo <hahnjo@hahnjo.de>
    alx: Reset phy speed after resume

Markus Pargmann <mpa@pengutronix.de>
    can: c_can: Fix RX message handling, handle lost message before EOB

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: s390 - Fix aes-cbc IV corruption

Neil Horman <nhorman@tuxdriver.com>
    crypto: ansi_cprng - Fix off by one error in non-block size request

Josef Bacik <jbacik@fusionio.com>
    Btrfs: relocate csums properly with prealloc extents

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
 arch/ia64/include/asm/processor.h                  |   2 +-
 arch/s390/crypto/aes_s390.c                        |  19 ++-
 arch/x86/kernel/process.c                          |   6 +-
 crypto/ansi_cprng.c                                |   4 +-
 drivers/acpi/acpica/exoparg1.c                     |  48 +++++-
 drivers/acpi/acpica/exstore.c                      | 166 +++++++++++++--------
 drivers/acpi/ec.c                                  |   3 +-
 drivers/acpi/pci_root.c                            |   5 +-
 drivers/acpi/processor_idle.c                      |  46 ++----
 drivers/acpi/scan.c                                |   2 -
 drivers/acpi/video.c                               |   2 +-
 drivers/bluetooth/btusb.c                          |   1 -
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc1.c    |   4 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnvd7.c    |   1 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnvd9.c    |   1 +
 drivers/hv/channel_mgmt.c                          |   5 +-
 drivers/idle/intel_idle.c                          |   2 +-
 drivers/net/can/c_can/c_can.c                      |   6 +-
 drivers/net/can/usb/kvaser_usb.c                   |  20 ++-
 drivers/net/ethernet/atheros/alx/main.c            |   3 +
 drivers/net/wireless/libertas/debugfs.c            |   6 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |  11 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |   3 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h            |   2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   7 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   4 +-
 drivers/pci/access.c                               |  19 +--
 drivers/platform/x86/thinkpad_acpi.c               |   7 +-
 drivers/scsi/aacraid/commctrl.c                    |   3 +-
 drivers/staging/comedi/comedi_fops.c               |   5 +-
 drivers/staging/zram/zram_drv.c                    |   6 +-
 drivers/usb/serial/mos7840.c                       |   4 +
 fs/btrfs/relocation.c                              |  18 ++-
 fs/exec.c                                          |   6 +
 include/linux/binfmts.h                            |   3 -
 include/linux/sched.h                              |  82 +++++++++-
 include/linux/thread_info.h                        |   2 +
 ipc/shm.c                                          |  37 ++++-
 kernel/cpu/idle.c                                  |   9 +-
 kernel/ptrace.c                                    |   3 +-
 kernel/trace/trace_event_perf.c                    |   2 +-
 net/sunrpc/clnt.c                                  |   2 +-
 security/integrity/ima/ima_policy.c                |   1 -
 44 files changed, 396 insertions(+), 196 deletions(-)


