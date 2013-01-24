Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197Ab3AXVNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:13:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:39835 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab3AXVN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:13:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/46] 3.7.5-stable review
Date: Thu, 24 Jan 2013 13:12:38 -0800
Message-Id: <20130124211135.862755794@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.7.5 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jan 26 21:09:21 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.7.5-rc1

Laxman Dewangan <ldewangan@nvidia.com>
    dma: tegra: implement flags parameters for cyclic transfer

Shuah Khan <shuah.khan@hp.com>
    ioat: Fix DMA memory sync direction correct flag

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    intel_idle: Don't register CPU notifier if we are not running.

Fabio Estevam <fabio.estevam@freescale.com>
    i2c: mxs: Fix type of error code

Stefan Bader <stefan.bader@canonical.com>
    ACPI: Check MSR valid bit before using P-state frequencies

Thomas Schlichter <thomas.schlichter@web.de>
    ACPI / processor: Get power info before updating the C-states

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled

Matthew Garrett <matthew.garrett@nebula.com>
    cpufreq: Add module aliases for acpi-cpufreq

Borislav Petkov <bp@suse.de>
    powernow-k8: Add a kconfig dependency on acpi-cpufreq

Linus Torvalds <torvalds@linux-foundation.org>
    module: fix missing module_mutex unlock

Rusty Russell <rusty@rustcorp.com.au>
    module: put modules in list much earlier.

Rusty Russell <rusty@rustcorp.com.au>
    module: add new state MODULE_STATE_UNFORMED.

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    drivers/firmware/dmi_scan.c: check dmi version when get system uuid

Joel D. Diaz <joeldiaz@us.ibm.com>
    SCSI: sd: Reshuffle init_sd to avoid crash

Sergei Shtylyov <sshtylyov@ru.mvista.com>
    usb: musb: cppi_dma: drop '__init' annotation

Benoit Goby <benoit@android.com>
    usb: gadget: FunctionFS: Fix missing braces in parse_opts

Pratyush Anand <pratyush.anand@st.com>
    usb: dwc3: gadget: fix ep->maxburst for ep0

Alan Stern <stern@rowland.harvard.edu>
    USB: UHCI: fix IRQ race during initialization

Jacob Schloss <jacob.schloss@unlimitedautomata.com>
    media: gspca_kinect: add Kinect for Windows USB id

Luciano Coelho <coelho@ti.com>
    Revert "drivers/misc/ti-st: remove gpio handling"

Bjorn Helgaas <bhelgaas@google.com>
    PCI: shpchp: Use per-slot workqueues to avoid deadlock

Bjorn Helgaas <bhelgaas@google.com>
    PCI: shpchp: Handle push button event asynchronously

Yijing Wang <wangyijing@huawei.com>
    PCI: pciehp: Use per-slot workqueues to avoid deadlock

Colin Ian King <colin.king@canonical.com>
    PCI: Allow pcie_aspm=force even when FADT indicates it is unsupported

Betty Dall <betty.dall@hp.com>
    PCI/AER: pci_get_domain_bus_and_slot() call missing required pci_dev_put()

Will Deacon <will.deacon@arm.com>
    arm64: elf: fix core dumping to match what glibc expects

Will Deacon <will.deacon@arm.com>
    arm64: makefile: fix uname munging when setting ARCH on native machine

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add Conexant CX20755/20756/20757 codec IDs

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Fix mute led for another HP machine

Oleg Nesterov <oleg@redhat.com>
    wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACED task

Oleg Nesterov <oleg@redhat.com>
    ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL

Oleg Nesterov <oleg@redhat.com>
    ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()

David Ahern <dsahern@gmail.com>
    perf x86: revert 20b279 - require exclude_guest to use PEBS - kernel side

Alex Williamson <alex.williamson@redhat.com>
    vfio-pci: Fix buffer overfill

Tejun Heo <tj@kernel.org>
    async: fix __lowest_in_progress()

Alexander Graf <agraf@suse.de>
    virtio-blk: Don't free ida when disk is in use

Dmitry Kasatkin <dmitry.kasatkin@intel.com>
    evm: checking if removexattr is not a NULL

Steven Rostedt <srostedt@redhat.com>
    ftrace: Be first to run code modification on modules

Shane Huang <shane.huang@amd.com>
    libata: replace sata_settings with devslp_timing

Hugh Daschbach <hugh.daschbach@enmotus.com>
    libata: ahci: Add support for Enmotus Bobcat device.

Bian Yu <bianyu@kedacom.com>
    libata: ahci: Fix lack of command retry after a success error handler.

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Invalidate the relocation presumed_offsets along the slow path

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    Ensure that kernel_init_freeable() is not inlined into non __init code

Al Viro <viro@zeniv.linux.org.uk>
    make sure that /linuxrc has std{in,out,err}


-------------

Diffstat:

 Makefile                                   |   6 +-
 arch/arm64/include/asm/elf.h               |   5 +-
 arch/x86/kernel/cpu/perf_event.c           |   6 --
 arch/x86/kernel/step.c                     |   9 +-
 drivers/acpi/processor_idle.c              |   4 +
 drivers/acpi/processor_perflib.c           |   7 ++
 drivers/ata/ahci.c                         |   8 +-
 drivers/ata/libahci.c                      |   6 +-
 drivers/ata/libata-core.c                  |  22 +++--
 drivers/ata/libata-eh.c                    |   2 +-
 drivers/block/virtio_blk.c                 |   7 +-
 drivers/cpufreq/Kconfig.x86                |   2 +-
 drivers/cpufreq/acpi-cpufreq.c             |   7 ++
 drivers/dma/ioat/dma_v3.c                  |   2 +-
 drivers/dma/tegra20-apb-dma.c              |   8 +-
 drivers/firmware/dmi_scan.c                |  78 ++++++++++++----
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |  21 +++++
 drivers/gpu/drm/i915/i915_reg.h            |   1 +
 drivers/gpu/drm/i915/intel_pm.c            |   4 +
 drivers/i2c/busses/i2c-mxs.c               |   2 +-
 drivers/idle/intel_idle.c                  |   3 +-
 drivers/media/usb/gspca/kinect.c           |   1 +
 drivers/misc/ti-st/st_kim.c                |  37 +++++++-
 drivers/pci/hotplug/pciehp.h               |   2 +-
 drivers/pci/hotplug/pciehp_core.c          |  11 +--
 drivers/pci/hotplug/pciehp_ctrl.c          |   8 +-
 drivers/pci/hotplug/pciehp_hpc.c           |  11 ++-
 drivers/pci/hotplug/shpchp.h               |   3 +-
 drivers/pci/hotplug/shpchp_core.c          |  35 +++-----
 drivers/pci/hotplug/shpchp_ctrl.c          |   6 +-
 drivers/pci/pcie/aer/aerdrv_core.c         |   1 +
 drivers/pci/pcie/aspm.c                    |   3 +
 drivers/scsi/sd.c                          |  13 +--
 drivers/usb/dwc3/gadget.c                  |   1 +
 drivers/usb/gadget/f_fs.c                  |   6 +-
 drivers/usb/host/uhci-hcd.c                |  15 ++--
 drivers/usb/musb/cppi_dma.c                |   4 +-
 drivers/vfio/pci/vfio_pci_rdwr.c           |   4 +-
 include/linux/ata.h                        |   8 +-
 include/linux/libata.h                     |   4 +-
 include/linux/module.h                     |  10 +--
 include/linux/sched.h                      |  11 ++-
 init/do_mounts_initrd.c                    |   4 +
 init/main.c                                |   4 +-
 kernel/async.c                             |  27 ++++--
 kernel/debug/kdb/kdb_main.c                |   2 +
 kernel/module.c                            | 147 +++++++++++++++++++++----------
 kernel/ptrace.c                            |  72 ++++++++++++---
 kernel/sched/core.c                        |   3 +-
 kernel/signal.c                            |  19 ++--
 kernel/trace/ftrace.c                      |   2 +-
 lib/bug.c                                  |   1 +
 security/integrity/evm/evm_crypto.c        |   4 +-
 sound/pci/hda/patch_conexant.c             |   9 ++
 sound/pci/hda/patch_realtek.c              |   1 +
 tools/perf/Makefile                        |   2 +-
 56 files changed, 492 insertions(+), 209 deletions(-)


