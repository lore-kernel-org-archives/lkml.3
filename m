Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaJ0S5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:57:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52331 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaJ0S5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.13.y.z extended stable] Linux 3.13.11.10 stable review
Date: Mon, 27 Oct 2014 11:55:35 -0700
Message-Id: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.13.11.10 stable kernel.

This version contains 105 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review

The review period for version 3.13.11.10 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.13.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 Documentation/ABI/removed/net_dma       |   8 +
 Documentation/lzo.txt                   | 164 +++++++++++++++++++
 Documentation/networking/ip-sysctl.txt  |   6 -
 Documentation/virtual/kvm/mmu.txt       |  14 ++
 arch/arm/boot/dts/at91sam9263.dtsi      |   2 +
 arch/arm/mach-at91/clock.c              |   1 +
 arch/m68k/mm/hwtest.c                   |   6 +
 arch/s390/kvm/interrupt.c               |   1 +
 arch/um/drivers/ubd_kern.c              |   5 +-
 arch/x86/ia32/ia32entry.S               |  18 +-
 arch/x86/include/asm/elf.h              |   5 +-
 arch/x86/include/asm/kvm_host.h         |   1 +
 arch/x86/kernel/cpu/common.c            |   2 +-
 arch/x86/kernel/cpu/intel.c             |  15 ++
 arch/x86/kernel/signal.c                |   5 +
 arch/x86/kernel/xsave.c                 |   7 +-
 arch/x86/kvm/mmu.c                      |  29 ++--
 arch/x86/kvm/vmx.c                      |  16 +-
 arch/x86/kvm/x86.h                      |  20 ++-
 block/blk-settings.c                    |   4 +-
 crypto/async_tx/async_xor.c             |   3 +-
 drivers/ata/libata-sff.c                |  20 +--
 drivers/ata/pata_serverworks.c          |  13 +-
 drivers/base/firmware_class.c           |   3 +
 drivers/base/regmap/regmap-debugfs.c    |   8 +-
 drivers/base/regmap/regmap.c            |   7 +-
 drivers/block/drbd/drbd_interval.c      |   4 +
 drivers/block/xen-blkback/blkback.c     |   1 +
 drivers/bluetooth/btusb.c               |   9 +
 drivers/bluetooth/hci_h5.c              |   2 +-
 drivers/crypto/caam/caamhash.c          |  28 ++--
 drivers/crypto/caam/sg_sw_sec4.h        |  54 ------
 drivers/dma/Kconfig                     |  12 --
 drivers/dma/Makefile                    |   1 -
 drivers/dma/dmaengine.c                 | 104 ------------
 drivers/dma/ioat/dma.c                  |   1 -
 drivers/dma/ioat/dma.h                  |   7 -
 drivers/dma/ioat/dma_v2.c               |   1 -
 drivers/dma/ioat/dma_v3.c               |   1 -
 drivers/dma/iovlock.c                   | 280 --------------------------------
 drivers/dma/pl330.c                     |  12 +-
 drivers/edac/mpc85xx_edac.c             |   2 +-
 drivers/gpu/drm/ast/ast_mode.c          |   4 +-
 drivers/hv/channel.c                    |  49 ++++--
 drivers/hv/connection.c                 |  17 +-
 drivers/hv/hv.c                         |  27 +--
 drivers/hv/hyperv_vmbus.h               |   4 +
 drivers/input/mouse/synaptics.c         |  22 ++-
 drivers/input/mouse/synaptics.h         |   8 +-
 drivers/input/serio/i8042-x86ia64io.h   |   6 +
 drivers/md/dm-bufio.c                   |   5 +-
 drivers/md/dm-log-userspace-transfer.c  |   2 +-
 drivers/media/common/siano/sms-cards.c  |   6 +
 drivers/media/common/siano/sms-cards.h  |   1 +
 drivers/media/usb/em28xx/em28xx-video.c |  15 +-
 drivers/media/usb/siano/smsusb.c        |   2 +
 drivers/media/usb/uvc/uvc_driver.c      |   9 +
 drivers/media/v4l2-core/v4l2-common.c   |   9 +-
 drivers/message/fusion/mptspi.c         |   5 +
 drivers/mfd/rtsx_pcr.c                  |   2 +-
 drivers/misc/mei/bus.c                  |   2 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c       |   7 +
 drivers/mmc/host/tmio_mmc_pio.c         |   9 +
 drivers/mtd/ubi/fastmap.c               |   1 +
 drivers/net/ppp/ppp_generic.c           |   2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c |   4 +
 drivers/net/wireless/rt2x00/rt2800.h    |   2 +-
 drivers/pci/host/pci-mvebu.c            |   6 +-
 drivers/pci/pci-sysfs.c                 |   2 +-
 drivers/pci/quirks.c                    |  20 +++
 drivers/power/charger-manager.c         |   5 +
 drivers/scsi/be2iscsi/be_mgmt.c         |  13 +-
 drivers/scsi/qla2xxx/qla_target.c       |   4 +-
 drivers/spi/spi-dw-mid.c                |   7 +-
 drivers/tty/serial/8250/8250_pci.c      |  21 +++
 drivers/tty/serial/omap-serial.c        |  12 +-
 drivers/usb/core/hub.c                  |   6 +-
 drivers/usb/core/quirks.c               |   4 +
 drivers/usb/serial/cp210x.c             |   2 +
 drivers/video/cfbcopyarea.c             |  13 +-
 drivers/video/console/bitblit.c         |   3 +-
 drivers/video/console/fbcon_ccw.c       |   3 +-
 drivers/video/console/fbcon_cw.c        |   3 +-
 drivers/video/console/fbcon_ud.c        |   3 +-
 drivers/virtio/virtio_pci.c             |  33 +++-
 fs/buffer.c                             |   5 +
 fs/dcache.c                             |   5 +
 fs/ecryptfs/inode.c                     |   2 +-
 fs/jffs2/jffs2_fs_sb.h                  |   2 -
 fs/jffs2/wbuf.c                         |  17 +-
 fs/lockd/mon.c                          |   6 +
 fs/namespace.c                          |   3 +
 fs/nfs/client.c                         |   2 +-
 fs/nfs/nfs4proc.c                       |   2 +-
 fs/nfs/nfs4renewd.c                     |  12 +-
 fs/nfs/nfs4state.c                      |  18 +-
 fs/notify/fanotify/fanotify_user.c      |   2 +-
 fs/pstore/inode.c                       |   4 +-
 fs/super.c                              |   2 +
 fs/ubifs/log.c                          |   8 +-
 fs/xfs/xfs_aops.c                       |  16 +-
 include/linux/blkdev.h                  |   5 +-
 include/linux/compiler-gcc5.h           |  66 ++++++++
 include/linux/dmaengine.h               |  22 +--
 include/linux/kvm_host.h                |   2 -
 include/linux/sched.h                   |   6 +-
 include/linux/skbuff.h                  |   8 +-
 include/linux/tcp.h                     |   8 -
 include/linux/usb/quirks.h              |   3 +
 include/net/netdma.h                    |  32 ----
 include/net/sock.h                      |  19 +--
 include/net/tcp.h                       |   8 -
 kernel/futex.c                          |   2 +
 kernel/module.c                         |   2 +
 kernel/sysctl_binary.c                  |   1 -
 lib/lzo/lzo1x_decompress_safe.c         | 103 ++++++------
 mm/percpu.c                             |   2 -
 net/bluetooth/smp.c                     |   5 +-
 net/ceph/messenger.c                    |   6 +-
 net/core/Makefile                       |   1 -
 net/core/dev.c                          |  10 --
 net/core/sock.c                         |   6 -
 net/core/user_dma.c                     | 131 ---------------
 net/dccp/proto.c                        |   4 +-
 net/ipv4/sysctl_net_ipv4.c              |   9 -
 net/ipv4/tcp.c                          | 147 ++---------------
 net/ipv4/tcp_input.c                    |  61 -------
 net/ipv4/tcp_ipv4.c                     |  18 +-
 net/ipv6/tcp_ipv6.c                     |  13 +-
 net/llc/af_llc.c                        |  10 +-
 net/netlink/af_netlink.c                |   2 +-
 security/selinux/hooks.c                |   2 +-
 sound/pci/emu10k1/emu10k1_callback.c    |   6 +-
 sound/soc/codecs/tlv320aic3x.c          |  13 ++
 sound/soc/soc-dapm.c                    |  25 +--
 virt/kvm/kvm_main.c                     |  33 +++-
 136 files changed, 953 insertions(+), 1226 deletions(-)

Al Viro (3):
      missing data dependency barrier in prepend_name()
      [jffs2] kill wbuf_queued/wbuf_dwork_lock
      fix misuses of f_count() in ppp and netlink

Alexander Usyskin (1):
      mei: bus: fix possible boundaries violation

Alexey Khoroshilov (1):
      dm log userspace: fix memory leak in dm_ulog_tfr_init failure path

Andreas Bomholtz (1):
      USB: cp210x: add support for Seluxit USB dongle

Andreas Henriksson (1):
      ARM: at91: fix at91sam9263ek DT mmc pinmuxing settings

Andy Adamson (1):
      NFSv4.1: Fix an NFSv4.1 state renewal regression

Andy Lutomirski (2):
      x86_64, entry: Filter RFLAGS.NT on entry from userspace
      x86,kvm,vmx: Preserve CR4 across VM entry

Andy Shevchenko (2):
      spi: dw-mid: respect 8 bit mode
      spi: dw-mid: terminate ongoing transfers at exit

Artem Bityutskiy (1):
      UBIFS: fix free log space calculation

Arun Easi (1):
      qla2xxx: Use correct offset to req-q-out for reserve calculation

Ben Hutchings (1):
      x86: Reject x32 executables if x32 ABI not supported

Benjamin Coddington (1):
      lockd: Try to reconnect if statd has moved

Benjamin Herrenschmidt (1):
      drm/ast: Fix HW cursor image

Borislav Petkov (1):
      mpc85xx_edac: Make L2 interrupt shared too

Bryan O'Donoghue (2):
      x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead
      serial: 8250: Add Quark X1000 to 8250_pci.c

Catalin Marinas (1):
      futex: Ensure get_futex_key_refs() always implies a barrier

Champion Chen (1):
      Bluetooth: Fix issue with USB suspend in btusb driver

Chao Yu (1):
      ecryptfs: avoid to access NULL pointer when write metadata in xattr

Chris Ball (1):
      mfd: rtsx_pcr: Fix MSI enable error handling

Chris J Arges (1):
      mptfusion: enable no_write_same for vmware scsi disks

Christian Borntraeger (1):
      KVM: s390: unintended fallthrough for external call

Cristian Stoica (2):
      crypto: caam - fix addressing of struct member
      crypto: caam - remove duplicated sg copy functions

Dan Williams (1):
      net_dma: simple removal

Daniel Mack (1):
      ASoC: soc-dapm: fix use after free

Dave Chinner (1):
      xfs: ensure WB_SYNC_ALL writeback handles partial pages correctly

David Matlack (3):
      kvm: fix potentially corrupt mmio cache
      kvm: x86: fix stale mmio cache bug
      kvm: don't take vcpu mutex for obviously invalid vcpu ioctls

Dmitry Lavnikevich (1):
      ASoC: tlv320aic3x: fix PLL D configuration

Dmitry Torokhov (1):
      Input: synaptics - gate forcepad support by DMI check

Douglas Lehr (1):
      PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size

Eric W. Biederman (1):
      mnt: Prevent pivot_root from creating a loop in the mount tree

Fabian Frederick (1):
      nfs: fix duplicate proc entries

Frank Schaefer (2):
      [media] em28xx-v4l: give back all active video buffers to the vb2 core properly on streaming stop
      [media] em28xx-v4l: fix video buffer field order reporting in progressive mode

Frans Klaver (1):
      tty: omap-serial: fix division by zero

Geert Uytterhoeven (1):
      m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()

Guenter Roeck (1):
      Revert "percpu: free percpu allocation info for uniprocessor system"

Hans de Goede (1):
      Input: i8042 - add noloop quirk for Asus X750LN

Ilya Dryomov (1):
      libceph: ceph-msgr workqueue needs a resque worker

Joe Savage (1):
      USB: serial: cp210x: added Ketra N1 wireless interface support

Joe Thornber (1):
      dm bufio: update last_accessed when relinking a buffer

Johan Hedberg (1):
      Bluetooth: Fix setting correct security level when initiating SMP

Junxiao Bi (1):
      mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set

K. Y. Srinivasan (6):
      Drivers: hv: vmbus: Cleanup vmbus_post_msg()
      Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
      Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
      Drivers: hv: vmbus: Fix a bug in vmbus_open()
      Drivers: hv: vmbus: Cleanup vmbus_close_internal()
      Drivers: hv: vmbus: Cleanup hv_post_message()

Kees Cook (1):
      firmware_class: make sure fw requests contain a name

Krzysztof Kozlowski (3):
      power: charger-manager: Fix NULL pointer exception with missing cm-fuel-gauge
      dmaengine: pl330: Fix NULL pointer dereference on probe failure
      dmaengine: pl330: Fix NULL pointer dereference on driver unbind

Lai Jiangshan (1):
      drbd: compute the end before rb_insert_augmented()

Loic Poulain (1):
      Bluetooth: Fix HCI H5 corrupted ack value

Lu Baolu (1):
      USB: Add device quirk for ASUS T100 Base Station keyboard

Ludovic Desroches (1):
      ARM: at91/PMC: don't forget to write PMC_PCDR register to disable clocks

Maciej Matraszek (1):
      [media] v4l2-common: fix overflow in v4l_bound_align_image()

Mauro Carvalho Chehab (1):
      [media] siano: add support for PCTV 77e

Michael S. Tsirkin (1):
      virtio_pci: fix virtio spec compliance on restore

Mike Christie (1):
      be2iscsi: check ip buffer before copying

Mike Snitzer (1):
      block: fix alignment_offset math that assumes io_min is a power-of-2

Mikulas Patocka (4):
      framebuffer: fix border color
      framebuffer: fix screen corruption when copying
      dm bufio: when done scanning return from __scan immediately
      fs: make cont_expand_zero interruptible

Oleg Nesterov (2):
      x86, fpu: shift drop_init_fpu() from save_xstate_sig() to handle_signal()
      x86, fpu: __restore_xstate_sig()->math_state_restore() needs preempt_disable()

Olga Kornievskaia (1):
      Fixing lease renewal

Ondrej Zary (1):
      libata-sff: Fix controllers with no ctl port

Oren Givon (1):
      iwlwifi: Add missing PCI IDs for the 7260 series

Pankaj Dubey (1):
      regmap: fix NULL pointer dereference in _regmap_write/read

Paolo Bonzini (1):
      KVM: do not bias the generation number in kvm_current_mmio_generation

Paul Fertser (1):
      [media] media: usb: uvc: add a quirk for Dell XPS M1330 webcam

Prarit Bhargava (1):
      modules, lock around setting of MODULE_STATE_UNFORMED

Ricardo Ribalda Delgado (1):
      PCI: Generate uppercase hex for modalias interface class

Richard Genoud (1):
      UBI: add missing kmem_cache_free() in process_pool_aeb error path

Roger Pau Monné (1):
      xen-blkback: fix leak on grant map error path

Roger Tseng (1):
      mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response

Sasha Levin (1):
      kernel: add support for gcc 5

Scott Carter (1):
      pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE Controller

Sergei Shtylyov (1):
      mmc: tmio: prevent endless loop in tmio_mmc_set_clock()

Stanislaw Gruszka (1):
      rt2800: correct BBP1_TX_POWER_CTRL mask

Stephen Smalley (1):
      selinux: fix inode security list corruption

Takashi Iwai (1):
      ALSA: emu10k1: Fix deadlock in synth voice lookup

Tetsuo Handa (1):
      fs: Fix theoretical division by 0 in super_cache_scan().

Thomas Petazzoni (1):
      PCI: mvebu: Fix uninitialized variable in mvebu_get_tgt_attr()

Thorsten Knabe (1):
      um: ubd: Fix for processes stuck in D state forever

Trond Myklebust (2):
      NFSv4: Fix lock recovery when CREATE_SESSION/SETCLIENTID_CONFIRM fails
      NFSv4: fix open/lock state recovery error handling

Valdis Kletnieks (1):
      pstore: Fix duplicate {console,ftrace}-efi entries

Willy Tarreau (3):
      Documentation: lzo: document part of the encoding
      Revert "lzo: properly check for overruns"
      lzo: check for length overrun in variable length encoding.

Xiubo Li (2):
      regmap: debugfs: fix possbile NULL pointer dereference
      regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.

Xuelin Shi (1):
      dmaengine: fix xor sources continuation

Yann Droneaud (1):
      fanotify: enable close-on-exec on events' fd when requested in fanotify_init()
