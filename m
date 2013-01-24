Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945910Ab3AXVQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:16:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:40611 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945891Ab3AXVPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:15:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/22] 3.4.28-stable review
Date: Thu, 24 Jan 2013 13:15:21 -0800
Message-Id: <20130124211504.701368763@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.28 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jan 26 21:13:38 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.28-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.28-rc1

Shuah Khan <shuah.khan@hp.com>
    ioat: Fix DMA memory sync direction correct flag

Thomas Schlichter <thomas.schlichter@web.de>
    ACPI / processor: Get power info before updating the C-states

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix regression by disconnection-race-fix patch

Alan Cox <alan@linux.intel.com>
    ahci: Add identifiers for ASM106x devices

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    drivers/firmware/dmi_scan.c: check dmi version when get system uuid

Joel D. Diaz <joeldiaz@us.ibm.com>
    SCSI: sd: Reshuffle init_sd to avoid crash

Pratyush Anand <pratyush.anand@st.com>
    usb: dwc3: gadget: fix ep->maxburst for ep0

Alan Stern <stern@rowland.harvard.edu>
    USB: UHCI: fix IRQ race during initialization

Bjorn Helgaas <bhelgaas@google.com>
    PCI: shpchp: Handle push button event asynchronously

Yijing Wang <wangyijing@huawei.com>
    PCI: pciehp: Use per-slot workqueues to avoid deadlock

Colin Ian King <colin.king@canonical.com>
    PCI: Allow pcie_aspm=force even when FADT indicates it is unsupported

Betty Dall <betty.dall@hp.com>
    PCI/AER: pci_get_domain_bus_and_slot() call missing required pci_dev_put()

Oleg Nesterov <oleg@redhat.com>
    wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACED task

Oleg Nesterov <oleg@redhat.com>
    ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL

Oleg Nesterov <oleg@redhat.com>
    ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()

Dmitry Kasatkin <dmitry.kasatkin@intel.com>
    evm: checking if removexattr is not a NULL

Steven Rostedt <srostedt@redhat.com>
    ftrace: Be first to run code modification on modules

Hugh Daschbach <hugh.daschbach@enmotus.com>
    libata: ahci: Add support for Enmotus Bobcat device.

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Invalidate the relocation presumed_offsets along the slow path


-------------

Diffstat:

 Makefile                                   |  4 +-
 drivers/acpi/processor_idle.c              |  4 ++
 drivers/ata/ahci.c                         | 13 +++++-
 drivers/dma/ioat/dma_v3.c                  |  2 +-
 drivers/firmware/dmi_scan.c                | 78 +++++++++++++++++++++++++-------
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 21 +++++++++
 drivers/gpu/drm/i915/i915_reg.h            |  3 ++
 drivers/gpu/drm/i915/intel_display.c       |  4 ++
 drivers/pci/hotplug/pciehp.h               |  2 +-
 drivers/pci/hotplug/pciehp_core.c          | 11 +----
 drivers/pci/hotplug/pciehp_ctrl.c          |  8 ++--
 drivers/pci/hotplug/pciehp_hpc.c           | 11 ++++-
 drivers/pci/hotplug/shpchp.h               |  1 -
 drivers/pci/hotplug/shpchp_core.c          | 10 ----
 drivers/pci/hotplug/shpchp_ctrl.c          |  2 +-
 drivers/pci/pcie/aer/aerdrv_core.c         |  1 +
 drivers/pci/pcie/aspm.c                    |  3 ++
 drivers/scsi/sd.c                          | 13 ++++--
 drivers/usb/dwc3/gadget.c                  |  1 +
 drivers/usb/host/uhci-hcd.c                | 15 +++---
 include/linux/sched.h                      | 11 ++++-
 kernel/ptrace.c                            | 72 +++++++++++++++++++++++------
 kernel/sched/core.c                        |  3 +-
 kernel/signal.c                            | 19 ++++----
 kernel/trace/ftrace.c                      |  2 +-
 security/integrity/evm/evm_crypto.c        |  4 +-
 sound/usb/endpoint.c                       |  6 +--
 27 files changed, 231 insertions(+), 93 deletions(-)


