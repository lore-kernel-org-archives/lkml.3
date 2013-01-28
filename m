Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3A1EzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:55:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:44155 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab3A1EzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:55:15 -0500
Date: Sun, 27 Jan 2013 20:56:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.7.5
Message-ID: <20130128045658.GA3488@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.7.5 kernel.

All users of the 3.7 kernel series must upgrade.

The updated 3.7.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.7.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                   |    4=20
 arch/arm64/include/asm/elf.h               |    5=20
 arch/x86/kernel/cpu/perf_event.c           |    6 -
 arch/x86/kernel/step.c                     |    9 -
 drivers/acpi/processor_idle.c              |    4=20
 drivers/acpi/processor_perflib.c           |    7 +
 drivers/ata/ahci.c                         |    8 +
 drivers/ata/libahci.c                      |    6 -
 drivers/ata/libata-core.c                  |   22 ++--
 drivers/ata/libata-eh.c                    |    2=20
 drivers/block/virtio_blk.c                 |    7 +
 drivers/cpufreq/Kconfig.x86                |    2=20
 drivers/cpufreq/acpi-cpufreq.c             |    7 +
 drivers/dma/ioat/dma_v3.c                  |    2=20
 drivers/dma/tegra20-apb-dma.c              |    8 +
 drivers/firmware/dmi_scan.c                |   78 ++++++++++++---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   21 ++++
 drivers/gpu/drm/i915/i915_reg.h            |    1=20
 drivers/gpu/drm/i915/intel_pm.c            |    4=20
 drivers/i2c/busses/i2c-mxs.c               |    2=20
 drivers/idle/intel_idle.c                  |    3=20
 drivers/media/usb/gspca/kinect.c           |    1=20
 drivers/misc/ti-st/st_kim.c                |   37 +++++++
 drivers/pci/hotplug/pciehp.h               |    2=20
 drivers/pci/hotplug/pciehp_core.c          |   11 --
 drivers/pci/hotplug/pciehp_ctrl.c          |    8 -
 drivers/pci/hotplug/pciehp_hpc.c           |   11 +-
 drivers/pci/hotplug/shpchp.h               |    3=20
 drivers/pci/hotplug/shpchp_core.c          |   35 ++----
 drivers/pci/hotplug/shpchp_ctrl.c          |    6 -
 drivers/pci/pcie/aer/aerdrv_core.c         |    1=20
 drivers/pci/pcie/aspm.c                    |    3=20
 drivers/scsi/sd.c                          |   13 +-
 drivers/usb/dwc3/gadget.c                  |    1=20
 drivers/usb/gadget/f_fs.c                  |    6 -
 drivers/usb/host/uhci-hcd.c                |   15 +-
 drivers/usb/musb/cppi_dma.c                |    4=20
 drivers/vfio/pci/vfio_pci_rdwr.c           |    4=20
 include/linux/ata.h                        |    8 -
 include/linux/libata.h                     |    4=20
 include/linux/module.h                     |   10 -
 include/linux/sched.h                      |   11 +-
 init/do_mounts_initrd.c                    |    4=20
 init/main.c                                |    4=20
 kernel/async.c                             |   27 +++--
 kernel/debug/kdb/kdb_main.c                |    2=20
 kernel/module.c                            |  147 +++++++++++++++++++-----=
-----
 kernel/ptrace.c                            |   72 +++++++++++---
 kernel/sched/core.c                        |    3=20
 kernel/signal.c                            |   19 +--
 kernel/trace/ftrace.c                      |    2=20
 lib/bug.c                                  |    1=20
 security/integrity/evm/evm_crypto.c        |    4=20
 sound/pci/hda/patch_conexant.c             |    9 +
 sound/pci/hda/patch_realtek.c              |    1=20
 tools/perf/Makefile                        |    2=20
 56 files changed, 491 insertions(+), 208 deletions(-)

Al Viro (1):
      make sure that /linuxrc has std{in,out,err}

Alan Stern (1):
      USB: UHCI: fix IRQ race during initialization

Alex Williamson (1):
      vfio-pci: Fix buffer overfill

Alexander Graf (1):
      virtio-blk: Don't free ida when disk is in use

Benoit Goby (1):
      usb: gadget: FunctionFS: Fix missing braces in parse_opts

Betty Dall (1):
      PCI/AER: pci_get_domain_bus_and_slot() call missing required pci_dev_=
put()

Bian Yu (1):
      libata: ahci: Fix lack of command retry after a success error handler.

Bjorn Helgaas (2):
      PCI: shpchp: Handle push button event asynchronously
      PCI: shpchp: Use per-slot workqueues to avoid deadlock

Borislav Petkov (1):
      powernow-k8: Add a kconfig dependency on acpi-cpufreq

Chris Wilson (1):
      drm/i915: Invalidate the relocation presumed_offsets along the slow p=
ath

Colin Ian King (1):
      PCI: Allow pcie_aspm=3Dforce even when FADT indicates it is unsupport=
ed

Daniel Vetter (1):
      drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled

David Ahern (1):
      perf x86: revert 20b279 - require exclude_guest to use PEBS - kernel =
side

David Henningsson (1):
      ALSA: hda - Fix mute led for another HP machine

Dmitry Kasatkin (1):
      evm: checking if removexattr is not a NULL

Fabio Estevam (1):
      i2c: mxs: Fix type of error code

Greg Kroah-Hartman (1):
      Linux 3.7.5

Hugh Daschbach (1):
      libata: ahci: Add support for Enmotus Bobcat device.

Jacob Schloss (1):
      media: gspca_kinect: add Kinect for Windows USB id

Joel D. Diaz (1):
      SCSI: sd: Reshuffle init_sd to avoid crash

Konrad Rzeszutek Wilk (2):
      ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled
      intel_idle: Don't register CPU notifier if we are not running.

Laxman Dewangan (1):
      dma: tegra: implement flags parameters for cyclic transfer

Linus Torvalds (1):
      module: fix missing module_mutex unlock

Luciano Coelho (1):
      Revert "drivers/misc/ti-st: remove gpio handling"

Matthew Garrett (1):
      cpufreq: Add module aliases for acpi-cpufreq

Oleg Nesterov (3):
      ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()
      ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
      wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACE=
D task

Pratyush Anand (1):
      usb: dwc3: gadget: fix ep->maxburst for ep0

Rusty Russell (2):
      module: add new state MODULE_STATE_UNFORMED.
      module: put modules in list much earlier.

Sergei Shtylyov (1):
      usb: musb: cppi_dma: drop '__init' annotation

Shane Huang (1):
      libata: replace sata_settings with devslp_timing

Shuah Khan (1):
      ioat: Fix DMA memory sync direction correct flag

Stefan Bader (1):
      ACPI: Check MSR valid bit before using P-state frequencies

Steven Rostedt (1):
      ftrace: Be first to run code modification on modules

Takashi Iwai (1):
      ALSA: hda - Add Conexant CX20755/20756/20757 codec IDs

Tejun Heo (1):
      async: fix __lowest_in_progress()

Thomas Schlichter (1):
      ACPI / processor: Get power info before updating the C-states

Vineet Gupta (1):
      Ensure that kernel_init_freeable() is not inlined into non __init code

Will Deacon (2):
      arm64: makefile: fix uname munging when setting ARCH on native machine
      arm64: elf: fix core dumping to match what glibc expects

Yijing Wang (1):
      PCI: pciehp: Use per-slot workqueues to avoid deadlock

Zhenzhong Duan (2):
      drivers/firmware/dmi_scan.c: check dmi version when get system uuid
      drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exis=
ts


--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRBgUaAAoJEDjbvchgkmk+8FYQALFfdocKvbLaKDSJL1OgWGhT
FpoC6DYVgTdGxaRmZ7Tc2PAX7VDlp9snFTx6kZWAiCuoXoZ+yvjdOHH7i0AqelpE
yxBdSaIyRweOkDvuKpTeX/UtpeXvhRreeGmO/Sg6UYIcdosgu6wKhbZokDT4Xabh
PG3qi8uodYHoHM3Skf7CDcvGw8McAoBnzs7R91YRIW+u5GVNtZ2r9poeVVueu/Gs
VpphbdLW/TaMLdnQu38q8a0JQmcEs6J6MW5Y6bJTg/0XhCvKaqjRzE53IPX9q0RI
vnZtOwmriTp+CAd7naSY32Ict1cQwaRhNk28L32j+qZr0ubXzgVUo0JS+rRisBZJ
RFLEjV80w1MZvMZsbM1k957nVictufQf+lK337wl4i1kNWg5nsjn/ANklGbecuRR
TkAsGw7x5G/UIzkRmSUZaQy/SrWB/ejg8EVdUc4q0h5bFVXXABjCxq2xtg1LamA0
Ki4T2k08kGzOoFiL3Knm5LuFAleLYHh0qrORkiHtBKt8megZZN2OIAfjpb8jpj7T
GQEZ8gxm8ezMFdgGkcTDCTE5iHM76RP905cLC4JTCpaeQ6S9XGN+NAXSfyAg6srf
5Te9Ygm37KURoIODUEy3FS4e3z1V91XBAEC0uSMixVaBKSdZmE6wC/B+HZWG3f4t
ssqSRBprBUv7JjDHOYEK
=hRQi
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
