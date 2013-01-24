Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab3AXVS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:18:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:41077 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab3AXVSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:18:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/15] 3.0.61-stable review
Date: Thu, 24 Jan 2013 13:18:24 -0800
Message-Id: <20130124211723.489089115@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.61 release.
There are 15 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jan 26 21:16:11 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.61-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.61-rc1

Shuah Khan <shuah.khan@hp.com>
    ioat: Fix DMA memory sync direction correct flag

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled

Robin Holt <holt@sgi.com>
    SGI-XP: handle non-fatal traps

Kees Cook <keescook@chromium.org>
    x86: Use enum instead of literals for trap values [PARTIAL]

Alan Cox <alan@linux.intel.com>
    ahci: Add identifiers for ASM106x devices

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled

Bart Westgeest <bart@elbrys.com>
    staging: usbip: changed function return type to void

Jiri Slaby <jirislaby@gmail.com>
    serial: 8250, increase PASS_LIMIT

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    drivers/firmware/dmi_scan.c: check dmi version when get system uuid

Joel D. Diaz <joeldiaz@us.ibm.com>
    SCSI: sd: Reshuffle init_sd to avoid crash

Alan Stern <stern@rowland.harvard.edu>
    USB: UHCI: fix IRQ race during initialization

Colin Ian King <colin.king@canonical.com>
    PCI: Allow pcie_aspm=force even when FADT indicates it is unsupported

Steven Rostedt <srostedt@redhat.com>
    ftrace: Be first to run code modification on modules

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Invalidate the relocation presumed_offsets along the slow path


-------------

Diffstat:

 Makefile                                   |  4 +-
 arch/x86/include/asm/traps.h               | 26 +++++++++++
 drivers/acpi/processor_idle.c              |  3 ++
 drivers/ata/ahci.c                         |  6 +++
 drivers/dma/ioat/dma_v3.c                  |  2 +-
 drivers/firmware/dmi_scan.c                | 78 +++++++++++++++++++++++++-------
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 21 +++++++++
 drivers/gpu/drm/i915/i915_reg.h            |  3 ++
 drivers/gpu/drm/i915/intel_display.c       |  4 ++
 drivers/misc/sgi-xp/xpc_main.c             | 34 +++++++++++++-
 drivers/pci/pcie/aspm.c                    |  3 ++
 drivers/scsi/sd.c                          | 13 ++++--
 drivers/staging/usbip/usbip_common.c       | 11 ++---
 drivers/staging/usbip/usbip_common.h       |  2 +-
 drivers/staging/usbip/vhci_rx.c            |  3 +-
 drivers/tty/serial/8250.c                  |  2 +-
 drivers/usb/host/uhci-hcd.c                | 15 +++---
 include/linux/pci_ids.h                    |  2 +
 kernel/trace/ftrace.c                      |  2 +-
 19 files changed, 189 insertions(+), 45 deletions(-)


