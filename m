Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaELJPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:15:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46424 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaELJP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:15:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.11.y.z extended stable] Linux 3.11.10.10
Date: Mon, 12 May 2014 10:15:22 +0100
Message-Id: <1399886123-7402-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.11.10.10 kernel.

The updated 3.11.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.11.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.11.y;a=shortlog

The diff from v3.11.10.9 is posted as a follow-up to this email.

The 3.11.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Documentation/i2c/busses/i2c-i801            |  2 +
 Makefile                                     |  2 +-
 arch/arc/include/asm/irqflags.h              |  7 ---
 arch/arc/kernel/entry.S                      | 12 +++--
 arch/arm/boot/dts/armada-370-xp.dtsi         |  1 +
 arch/arm/include/asm/div64.h                 |  2 +-
 arch/arm/include/asm/unistd.h                |  1 -
 arch/arm/kernel/machine_kexec.c              |  7 +++
 arch/arm/kvm/mmu.c                           | 15 +++---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c   |  4 +-
 arch/arm/mach-omap2/pm.h                     |  2 +-
 arch/arm/mm/mmap.c                           |  6 +--
 arch/mips/cavium-octeon/octeon-irq.c         |  2 +-
 arch/s390/kvm/kvm-s390.c                     |  3 +-
 arch/s390/net/bpf_jit_comp.c                 |  1 -
 arch/x86/kernel/ftrace.c                     |  2 +-
 crypto/crypto_wq.c                           |  2 +-
 drivers/ata/ahci.c                           | 18 +++----
 drivers/ata/libata-core.c                    | 21 +++++---
 drivers/ata/pata_at91.c                      | 11 ++--
 drivers/base/dd.c                            | 17 ++++++
 drivers/block/floppy.c                       | 11 ++--
 drivers/bluetooth/btusb.c                    |  1 +
 drivers/clocksource/exynos_mct.c             |  4 +-
 drivers/gpu/drm/i915/intel_display.c         | 23 ++++++--
 drivers/gpu/drm/i915/intel_drv.h             |  3 +-
 drivers/gpu/drm/radeon/cik.c                 |  2 +-
 drivers/gpu/drm/radeon/r600_dpm.c            | 22 ++++----
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |  7 +++
 drivers/gpu/drm/radeon/radeon_pm.c           | 28 +++++-----
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c      | 22 ++++++++
 drivers/i2c/busses/Kconfig                   |  2 +
 drivers/i2c/busses/i2c-i801.c                |  6 +++
 drivers/iio/industrialio-buffer.c            |  6 ++-
 drivers/infiniband/ulp/isert/ib_isert.c      | 31 +++++++----
 drivers/input/mouse/synaptics.c              | 42 +++++++++++++++
 drivers/irqchip/irq-gic.c                    |  8 ++-
 drivers/s390/cio/chsc.c                      | 22 ++++++--
 drivers/scsi/arcmsr/arcmsr_hba.c             |  7 ++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |  1 -
 drivers/scsi/qla2xxx/qla_os.c                |  6 +--
 drivers/scsi/virtio_scsi.c                   |  6 ++-
 drivers/tty/n_tty.c                          |  4 ++
 drivers/tty/serial/8250/8250_core.c          |  2 +-
 drivers/tty/serial/8250/8250_dma.c           |  9 +++-
 drivers/usb/gadget/zero.c                    |  2 +-
 drivers/usb/host/xhci-pci.c                  |  6 +--
 drivers/usb/host/xhci-ring.c                 | 64 +++++++++++-----------
 drivers/usb/host/xhci.c                      |  7 ++-
 drivers/usb/host/xhci.h                      |  2 -
 drivers/usb/serial/io_ti.c                   | 50 +++++++++++------
 drivers/usb/serial/option.c                  | 81 ++++++++++++++++++++++++++--
 drivers/usb/serial/qcserial.c                |  9 ++++
 drivers/usb/serial/usb-serial.c              |  4 +-
 fs/btrfs/inode-map.c                         | 18 +------
 fs/ext4/file.c                               |  2 +-
 fs/ext4/page-io.c                            |  5 +-
 fs/ext4/xattr.c                              | 23 ++++++--
 fs/locks.c                                   |  7 ++-
 fs/nfsd/nfs4callback.c                       |  4 +-
 include/linux/ftrace.h                       |  2 +
 include/linux/interrupt.h                    | 35 +++++++++++-
 include/linux/irq.h                          |  3 +-
 include/linux/libata.h                       |  1 +
 kernel/hrtimer.c                             | 22 ++++++++
 kernel/irq/manage.c                          | 17 +++---
 kernel/module.c                              |  3 ++
 kernel/timer.c                               |  2 +-
 kernel/trace/ftrace.c                        | 27 ++--------
 mm/memory.c                                  |  5 ++
 net/netfilter/nfnetlink_queue_core.c         | 31 +++++++----
 virt/kvm/arm/vgic.c                          |  1 +
 virt/kvm/ioapic.c                            |  2 +-
 73 files changed, 587 insertions(+), 261 deletions(-)

Alec Berg (1):
      iio: querying buffer scan_mask should return 0/1

Alex Deucher (3):
      drm/radeon: fix count in cik_sdma_ring_test()
      drm/radeon/pm: don't walk the crtc list before it has been initialized (v2)
      drm/radeon: fix ATPX detection on non-VGA GPUs

Alexander Gordeev (1):
      ahci: Do not receive interrupts sent by dummy ports

Bartlomiej Zolnierkiewicz (1):
      pata_at91: fix ata_host_activate() failure handling

Bjørn Mork (6):
      usb: qcserial: add Sierra Wireless EM7355
      usb: qcserial: add Sierra Wireless MC73xx
      usb: qcserial: add Sierra Wireless MC7305/MC7355
      usb: option: add Olivetti Olicard 500
      usb: option: add Alcatel L800MA
      usb: option: add and update a number of CMOTech devices

Chew, Kean ho (1):
      i2c: i801: enable Intel BayTrail SMBUS

Christian Borntraeger (1):
      KVM: s390: Optimize ucontrol path

Christopher Covington (1):
      ARM: 8007/1: Remove extraneous kcmp syscall ignore

Dan Carpenter (2):
      [SCSI] qla2xxx: fix error handling of qla2x00_mem_alloc()
      [SCSI] arcmsr: upper 32 of dma address lost

Dan Williams (1):
      libata/ahci: accommodate tag ordered controllers

Daniel Vetter (1):
      drm/i915: Don't check gmch state on inherited configs

David Cohen (1):
      usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM

David Milburn (1):
      ahci: do not request irq for dummy port

Denis Turischev (1):
      xhci: Switch Intel Lynx Point ports to EHCI on shutdown.

Fam Zheng (1):
      [SCSI] virtio-scsi: Skip setting affinity on uninitialized vq

Grant Likely (1):
      drivercore: deferral race condition fix

Haibin Wang (1):
      KVM: ARM: vgic: Fix sgi dispatch problem

Hans de Goede (1):
      Input: synaptics - add min/max quirk for ThinkPad T431s, L440, L540, S1 Yoga and X1

Igor Gnatenko (1):
      xhci: extend quirk for Renesas cards

James Ralston (1):
      i2c: i801: Add Device IDs for Intel Wildcat Point-LP PCH

Jan Kara (1):
      ext4: fix jbd2 warning under heavy xattr load

Jeff Layton (2):
      locks: allow __break_lease to sleep even when break_time is 0
      nfsd: set timeparms.to_maxval in setup_callback_client

Jiri Bohac (1):
      timer: Prevent overflow in apply_slack

Johan Hovold (2):
      USB: serial: fix sysfs-attribute removal deadlock
      USB: io_ti: fix firmware download on big-endian machines

Julius Werner (1):
      usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb

Krzysztof Kozlowski (1):
      clocksource: Exynos_mct: Register clock event after request_irq()

Leon Ma (1):
      hrtimer: Prevent remote enqueue of leftmost timers

Linus Torvalds (1):
      mm: make fixup_user_fault() check the vma access rights too

Liu Hua (1):
      ARM: 8030/1: ARM : kdump : add arch_crash_save_vmcoreinfo

Loic Poulain (2):
      8250_core: Fix unwanted TX chars write
      serial: 8250: Fix thread unsafe __dma_tx_complete function

Luis Henriques (1):
      Linux 3.11.10.10

Mark Salter (1):
      arm: KVM: fix possible misalignment of PGDs and bounce page

Martin Schwidefsky (1):
      s390/bpf,jit: initialize A register if 1st insn is BPF_S_LDX_B_MSH

Matthew Daley (2):
      floppy: ignore kernel-only members in FDRAWCMD ioctl input
      floppy: don't write kernel-only members to FDRAWCMD ioctl output

Matthew Wilcox (1):
      ext4: note the error in ext4_end_bio()

Miao Xie (1):
      Btrfs: fix inode caching vs tree log

Nicholas Bellinger (1):
      iser-target: Add missing se_cmd put for WRITE_PENDING in tx_comp_err

Nishanth Menon (1):
      ARM: OMAP4: Fix definition of IS_PM44XX_ERRATUM

Paolo Bonzini (1):
      KVM: ioapic: fix assignment of ioapic->rtc_status.pending_eoi (CVE-2014-0155)

Peter Hurley (1):
      n_tty: Fix n_tty_write crash when echoing in raw mode

Petr Mladek (1):
      ftrace/x86: One more missing sync after fixup of function modification failure

Roger Quadros (2):
      usb: gadget: zero: Fix SuperSpeed enumeration for alternate setting 1
      ARM: OMAP3: hwmod data: Correct clock domains for USB modules

Sebastian Ott (1):
      s390/chsc: fix SEI usage on old FW levels

Sergey Dyasly (1):
      ARM: 7840/1: LPAE: don't reject mapping /dev/mem above 4GB

Steven Rostedt (Red Hat) (1):
      ftrace/module: Hardcode ftrace_module_init() call into load_module()

Stuart Hayes (1):
      hrtimer: Prevent all reprogramming if hang detected

Tedd Ho-Jeong An (1):
      Bluetooth: Add support for Intel Bluetooth device [8087:0a2a]

Theodore Ts'o (1):
      ext4: use i_size_read in ext4_unaligned_aio()

Thomas Gleixner (2):
      genirq: Allow forcing cpu affinity of interrupts
      irqchip: Gic: Support forced affinity setting

Thomas Hellstrom (1):
      drm/vmwgfx: Make sure user-space can't DMA across buffer object boundaries v2

Thomas Petazzoni (1):
      ARM: mvebu: ensure the mdio node has a clock reference on Armada 370/XP

Tim Chen (1):
      crypto: crypto_wq - Fix late crypto work queue initialization

Tyler Stachecki (1):
      [SCSI] mpt2sas: Don't disable device twice at suspend.

Vineet Gupta (2):
      ARC: Entry Handler tweaks: Optimize away redundant IRQ_DISABLE_SAVE
      ARC: !PREEMPT: Ensure Return to kernel mode is IRQ safe

Xiangyu Lu (1):
      ARM: 8027/1: fix do_div() bug in big-endian systems

Zoltan Kiss (1):
      core, nfqueue, openvswitch: Orphan frags in skb_zerocopy and handle errors

