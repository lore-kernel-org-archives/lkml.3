Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaHDTHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:07:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaHDTHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:07:10 -0400
Date: Mon, 4 Aug 2014 12:07:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc driver patches for 3.17-rc1
Message-ID: <20140804190709.GA27091@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.17-rc1

for you to fetch changes up to 16eb2bfc65ef86d3ac6420d50ddc2c48f0023cee:

  Merge tag 'extcon-next-for-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon into char-misc-next (2014-07-27 23:11:14 -0700)

----------------------------------------------------------------
Char / Misc driver patches for 3.17-rc1

Here's the big driver misc / char pull request for 3.17-rc1.

Lots of things in here, the thunderbolt support for Apple laptops, some
other new drivers, testing fixes, and other good things.  All have been
in linux-next for a long time.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Shiyan (4):
      w1: mxc_w1: Fix incorrect "presence" status
      w1: mxc_w1: Optimize mxc_w1_ds2_reset_bus()
      w1: mxc_w1: Perform a software reset at startup
      w1: mxc_w1: Optimize mxc_w1_ds2_touch_bit()

Alexander Usyskin (7):
      mei: move from misc to char device
      mei: add WPT second mei interface
      mei: reset client connection state on timeout
      mei: start disconnect request timer consistently
      mei: don't schedule suspend in pm idle
      mei: fix return value on disconnect timeout
      mei: drop unused hw dependent fw status functions

Andre Heider (1):
      uio: uio_pruss: use struct device

Andreas Noever (23):
      thunderbolt: Add initial cactus ridge NHI support
      thunderbolt: Add control channel interface
      thunderbolt: Setup control channel
      thunderbolt: Add tb_regs.h
      thunderbolt: Initialize root switch and ports
      thunderbolt: Add thunderbolt capability handling
      thunderbolt: Enable plug events
      thunderbolt: Scan for downstream switches
      thunderbolt: Handle hotplug events
      thunderbolt: Add path setup code.
      thunderbolt: Add support for simple pci tunnels
      PCI: Add pci_fixup_suspend_late quirk pass
      PCI: Suspend/resume quirks for Apple thunderbolt
      thunderbolt: Read switch uid from EEPROM
      thunderbolt: Add suspend/hibernate support
      thunderbolt: Read port configuration from eeprom.
      thunderbolt: Fix nontrivial endpoint devices.
      thunderbolt: Add casts to prevent endianness warnings
      thunderbolt: Fix header declaration of tb_find_cap
      thunderbolt: Make enum tb_drom_entry_type unsigned
      thunderbolt: Make tb_eeprom_get_drom_offset static
      thunderbolt: select CRC32 in Kconfig
      MAINTAINERS: Add thunderbolt driver

Andrey Utkin (1):
      drivers/char/dsp56k.c: drop check for negativity of unsigned parameter

Arnd Bergmann (6):
      thunderbolt: add PCI dependency
      thunderbolt: fix format string for size_t
      w1: select crc16 library for ds2406
      pcmcia: sa1100: H3100 and H3600 share a driver
      pcmcia: pxa2xx: fix logic for lubbock
      pcmcia: journada720: use sa1100 pin interfaces correctly

Benoit Taine (1):
      ipack: Replace DEFINE_PCI_DEVICE_TABLE macro use

Chanwoo Choi (7):
      extcon: Reorder the sequence of extcon device driver alphabetically
      extcon: Set parent device of extcon device using prameter of devm_extcon_dev_allocate
      Merge tag 'mfd-extcon-regulator-v3.17' of git://git.kernel.org/.../lee/mfd into extcon-next
      extcon: sm5502: Add support new SM5502 extcon device driver
      extcon: sm5502: Detect cable state after completing platform booting
      extcon: sm5502: Change internal hardware switch according to cable type
      dt-bindings: extcon: Add support for SM5502 MUIC device

Charles Keepax (4):
      extcon: arizona: Remove duplicate set of input parent device
      extcon: arizona: Correct typo to disable regulation for button detection
      extcon: arizona: Update manual headphone detection calculation
      extcon: arizona: Get MICVDD against extcon device

Dan Carpenter (3):
      VME: remove duplicate CA91CX42_DCTL_VDW_M define
      char: xilinx_hwicap: missing error code if ioremap() fails
      mfd: vexpress: fix error handling vexpress_syscfg_regmap_init()

Enric Balletbo i Serra (1):
      drivers/misc/ti-st: Load firmware from ti-connectivity directory.

Fabian Frederick (1):
      drivers/misc/carma/carma-fpga.c: use PTR_ERR_OR_ZERO

Federico Vaga (2):
      ipoctal: protect only the real critical section
      ipoctal: request_irq after configuration

Fjodor Schelichow (3):
      w1/slaves: use pr_* instead of printk
      w1: use pr_* instead of printk
      w1/masters: use pr_* instead of printk

Greg Kroah-Hartman (4):
      Merge 3.16-rc5 into char-misc-next
      misc: remove DEFINE_PCI_DEVICE_TABLE usage
      pcmcia: remove DEFINE_PCI_DEVICE_TABLE usage
      Merge tag 'extcon-next-for-3.17' of git://git.kernel.org/.../chanwoo/extcon into char-misc-next

Guenter Roeck (4):
      i8k: Drop all labels
      i8k: Add support for configurable maximum fan speed value
      i8k: uapi: Introduce define for new highest fan speed
      i8k: Add support for Dell Precision 490 and Latitude D520

Himangi Saraogi (5):
      thunderbolt: Correct the size argument to devm_kzalloc
      thunderbolt: Use kcalloc
      misc: mic: Introduce the managed version of ioremap
      misc: bh1770glc: Use managed functions
      misc: bh1780: Introduce the use of devm_kzalloc

Jason Wang (1):
      hyperv: remove meaningless pr_err() in vmbus_recvpacket_raw()

Jean-Michel Hautbois (1):
      Lattice ECP3 FPGA: Correct endianness

Jingoo Han (1):
      extcon: Remove unnecessary OOM messages

Kees Cook (1):
      bsr: avoid format string leaking into device name

Kleber Sacilotto de Souza (5):
      GenWQE: Add sysfs interface for bitstream reload
      GenWQE: Add support for EEH error recovery
      GenWQE: Improve hardware error recovery
      GenWQE: Increase driver version number
      GenWQE: Remove unnecessary include

Krzysztof Kozlowski (1):
      extcon: palmas: Make of_device_id array const

Nikesh Oswal (1):
      extcon: arizona: Use extcon cable API with index of extcon cable instead of string

Richard Fitzgerald (1):
      extcon: arizona: support inverted jack detect switch

Robert Baldyga (2):
      mfd: max77693: Remove unnecessary wrapper functions
      mfd: max77693: Handle IRQs using regmap

Robin van der Gracht (1):
      ti-st: st-kim: Dont let probe fail when debugfs is disabled

Sachin Kamat (7):
      thunderbolt: Fix build error in eeprom.c
      thunderbolt: Fix build error in switch.c
      thunderbolt: Use NULL instead of 0 in switch.c
      thunderbolt: Use NULL instead of 0 in ctl.c
      thunderbolt: Use NULL instead of 0 in nhi.c
      thunderbolt: Staticize nhi_ids
      spmi: Remove duplicate inclusion of module.h

Scott Alfter (1):
      w1: new w1_ds2406 driver

Sebastian Ott (1):
      misc/GenWQE: fix pci_enable_msi usage

Shuah Khan (7):
      tools: memory-hotplug fix unexpected operator error
      tools: cpu-hotplug fix unexpected operator error
      tools: fix mq_perf_tests compile warnings
      tools: fix mq_open_tests compile warnings
      tools: Fix mqueue Makefile compile linking order
      tools: fix kcmp_test compile warnings
      tools: selftests - create a separate hotplug target for full range test

Siva Yerramreddy (7):
      misc: mic: Add mic bus and dma driver documentation
      misc: mic: add threaded irq support in host driver
      misc: mic: add dma support in host driver
      misc: mic: add threaded irq support in card driver
      misc: mic: add dma support in card driver
      misc: mic: add support for loading/unloading dma driver
      dma: MIC X100 DMA Driver

Sudeep Dutt (2):
      misc: mic: add a bus driver for virtual MIC devices
      dma: Fix MIC X100 DMA Driver Kconfig option

Terry Chia (1):
      Add MODULE_DESCRIPTION to dummy-irq.c and lkdtm.c in drivers/misc

Thomas Wood (1):
      drivers/w1/w1_int.c: Fix style errors.

Tomas Winkler (1):
      mei: sysfs: add Documentation mei class attributes

Wei Yongjun (1):
      misc: vexpress: Fix sparse non static symbol warnings

Yue Zhang (1):
      Tools: hv: fix file overwriting of hv_fcopy_daemon

 Documentation/ABI/testing/sysfs-class-mei          |  16 +
 Documentation/ABI/testing/sysfs-driver-genwqe      |   9 +
 .../devicetree/bindings/extcon/extcon-sm5502.txt   |  23 +
 Documentation/mic/mic_overview.txt                 |  67 +-
 Documentation/mic/mpssd/mpss                       |  14 +-
 Documentation/w1/slaves/w1_ds2406                  |  25 +
 MAINTAINERS                                        |   5 +
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/char/bsr.c                                 |   2 +-
 drivers/char/dsp56k.c                              |   2 +-
 drivers/char/i8k.c                                 | 123 ++--
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |   1 +
 drivers/dma/Kconfig                                |  18 +
 drivers/dma/Makefile                               |   1 +
 drivers/dma/mic_x100_dma.c                         | 774 +++++++++++++++++++++
 drivers/dma/mic_x100_dma.h                         | 286 ++++++++
 drivers/extcon/Kconfig                             |  38 +-
 drivers/extcon/Makefile                            |   7 +-
 drivers/extcon/extcon-adc-jack.c                   |   1 -
 drivers/extcon/extcon-arizona.c                    |  74 +-
 drivers/extcon/extcon-class.c                      |   2 +
 drivers/extcon/extcon-gpio.c                       |   1 -
 drivers/extcon/extcon-max14577.c                   |   5 +-
 drivers/extcon/extcon-max77693.c                   |  41 +-
 drivers/extcon/extcon-max8997.c                    |   5 +-
 drivers/extcon/extcon-palmas.c                     |   3 +-
 drivers/extcon/extcon-sm5502.c                     | 724 +++++++++++++++++++
 drivers/hv/channel.c                               |   6 +-
 drivers/ipack/carriers/tpci200.c                   |   2 +-
 drivers/ipack/devices/ipoctal.c                    |  20 +-
 drivers/mfd/Kconfig                                |   1 +
 drivers/mfd/Makefile                               |   2 +-
 drivers/mfd/max77693-irq.c                         | 336 ---------
 drivers/mfd/max77693.c                             | 210 ++++--
 drivers/misc/bh1770glc.c                           |  35 +-
 drivers/misc/bh1780gli.c                           |  33 +-
 drivers/misc/carma/carma-fpga.c                    |   5 +-
 drivers/misc/dummy-irq.c                           |   1 +
 drivers/misc/genwqe/Kconfig                        |   6 +
 drivers/misc/genwqe/card_base.c                    | 217 +++++-
 drivers/misc/genwqe/card_base.h                    |   2 +
 drivers/misc/genwqe/card_ddcb.c                    |  28 +-
 drivers/misc/genwqe/card_debugfs.c                 |   7 +
 drivers/misc/genwqe/card_dev.c                     |   5 +
 drivers/misc/genwqe/card_sysfs.c                   |  25 +
 drivers/misc/genwqe/card_utils.c                   |  20 +-
 drivers/misc/genwqe/genwqe_driver.h                |   2 +-
 drivers/misc/lattice-ecp3-config.c                 |  16 +-
 drivers/misc/lkdtm.c                               |   1 +
 drivers/misc/mei/client.c                          |  17 +-
 drivers/misc/mei/hw-me-regs.h                      |   1 +
 drivers/misc/mei/hw-me.c                           |  54 --
 drivers/misc/mei/hw-txe.c                          |  32 -
 drivers/misc/mei/main.c                            | 148 +++-
 drivers/misc/mei/mei_dev.h                         |  12 +-
 drivers/misc/mei/pci-me.c                          |   6 +-
 drivers/misc/mei/pci-txe.c                         |   4 +-
 drivers/misc/mic/Kconfig                           |  21 +-
 drivers/misc/mic/Makefile                          |   1 +
 drivers/misc/mic/bus/Makefile                      |   5 +
 drivers/misc/mic/bus/mic_bus.c                     | 218 ++++++
 drivers/misc/mic/card/mic_device.c                 |  23 +-
 drivers/misc/mic/card/mic_device.h                 |   9 +-
 drivers/misc/mic/card/mic_virtio.c                 |   7 +-
 drivers/misc/mic/card/mic_x100.c                   |  62 +-
 drivers/misc/mic/host/mic_boot.c                   |  83 ++-
 drivers/misc/mic/host/mic_device.h                 |  24 +
 drivers/misc/mic/host/mic_intr.c                   | 121 ++--
 drivers/misc/mic/host/mic_intr.h                   |  27 +-
 drivers/misc/mic/host/mic_main.c                   |   7 +-
 drivers/misc/mic/host/mic_virtio.c                 | 187 ++++-
 drivers/misc/mic/host/mic_virtio.h                 |  21 +-
 drivers/misc/mic/host/mic_x100.c                   |   8 +
 drivers/misc/ti-st/st_kim.c                        |   8 +-
 drivers/misc/vexpress-syscfg.c                     |   4 +-
 drivers/misc/vmw_vmci/vmci_guest.c                 |   2 +-
 drivers/pci/pci-driver.c                           |  18 +-
 drivers/pci/quirks.c                               | 104 +++
 drivers/pcmcia/Kconfig                             |   2 +-
 drivers/pcmcia/Makefile                            |   1 +
 drivers/pcmcia/bcm63xx_pcmcia.c                    |   2 +-
 drivers/pcmcia/i82092.c                            |   2 +-
 drivers/pcmcia/pd6729.c                            |   2 +-
 drivers/pcmcia/sa1111_jornada720.c                 |  10 +-
 drivers/pcmcia/vrc4173_cardu.c                     |   2 +-
 drivers/pcmcia/yenta_socket.c                      |   2 +-
 drivers/regulator/max77693.c                       |  12 +-
 drivers/spmi/spmi.c                                |   1 -
 drivers/thunderbolt/Kconfig                        |  13 +
 drivers/thunderbolt/Makefile                       |   3 +
 drivers/thunderbolt/cap.c                          | 116 +++
 drivers/thunderbolt/ctl.c                          | 731 +++++++++++++++++++
 drivers/thunderbolt/ctl.h                          |  75 ++
 drivers/thunderbolt/eeprom.c                       | 449 ++++++++++++
 drivers/thunderbolt/nhi.c                          | 675 ++++++++++++++++++
 drivers/thunderbolt/nhi.h                          | 114 +++
 drivers/thunderbolt/nhi_regs.h                     | 101 +++
 drivers/thunderbolt/path.c                         | 215 ++++++
 drivers/thunderbolt/switch.c                       | 507 ++++++++++++++
 drivers/thunderbolt/tb.c                           | 436 ++++++++++++
 drivers/thunderbolt/tb.h                           | 271 ++++++++
 drivers/thunderbolt/tb_regs.h                      | 213 ++++++
 drivers/thunderbolt/tunnel_pci.c                   | 232 ++++++
 drivers/thunderbolt/tunnel_pci.h                   |  30 +
 drivers/uio/uio_pruss.c                            |  37 +-
 drivers/vme/bridges/vme_ca91cx42.h                 |   1 -
 drivers/w1/masters/ds1wm.c                         |   2 +-
 drivers/w1/masters/ds2482.c                        |   2 +-
 drivers/w1/masters/ds2490.c                        |  50 +-
 drivers/w1/masters/mxc_w1.c                        |  64 +-
 drivers/w1/slaves/Kconfig                          |   8 +
 drivers/w1/slaves/Makefile                         |   1 +
 drivers/w1/slaves/w1_ds2406.c                      | 168 +++++
 drivers/w1/slaves/w1_ds2760.c                      |   3 +-
 drivers/w1/w1.c                                    |  10 +-
 drivers/w1/w1_family.c                             |   2 +-
 drivers/w1/w1_family.h                             |   1 +
 drivers/w1/w1_int.c                                |  19 +-
 drivers/w1/w1_log.h                                |   4 +-
 drivers/w1/w1_netlink.c                            |   3 +-
 include/asm-generic/vmlinux.lds.h                  |   3 +
 include/linux/extcon/sm5502.h                      | 287 ++++++++
 include/linux/mfd/arizona/pdata.h                  |   3 +
 include/linux/mfd/max77693-private.h               |  54 +-
 include/linux/mic_bus.h                            | 110 +++
 include/linux/pci.h                                |  12 +-
 include/uapi/linux/genwqe/genwqe_card.h            |   1 +
 include/uapi/linux/i8k.h                           |   3 +-
 tools/hv/hv_fcopy_daemon.c                         |   3 +-
 tools/testing/selftests/Makefile                   |  18 +
 tools/testing/selftests/README.txt                 |  27 +-
 tools/testing/selftests/cpu-hotplug/Makefile       |   3 +
 tools/testing/selftests/cpu-hotplug/on-off-test.sh |  52 +-
 tools/testing/selftests/kcmp/kcmp_test.c           |   2 +-
 tools/testing/selftests/memory-hotplug/Makefile    |   3 +
 .../selftests/memory-hotplug/on-off-test.sh        |   8 +
 tools/testing/selftests/mqueue/Makefile            |   4 +-
 tools/testing/selftests/mqueue/mq_open_tests.c     |  20 +-
 tools/testing/selftests/mqueue/mq_perf_tests.c     |  40 +-
 140 files changed, 8646 insertions(+), 1083 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-mei
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-sm5502.txt
 create mode 100644 Documentation/w1/slaves/w1_ds2406
 create mode 100644 drivers/dma/mic_x100_dma.c
 create mode 100644 drivers/dma/mic_x100_dma.h
 create mode 100644 drivers/extcon/extcon-sm5502.c
 delete mode 100644 drivers/mfd/max77693-irq.c
 create mode 100644 drivers/misc/mic/bus/Makefile
 create mode 100644 drivers/misc/mic/bus/mic_bus.c
 create mode 100644 drivers/thunderbolt/Kconfig
 create mode 100644 drivers/thunderbolt/Makefile
 create mode 100644 drivers/thunderbolt/cap.c
 create mode 100644 drivers/thunderbolt/ctl.c
 create mode 100644 drivers/thunderbolt/ctl.h
 create mode 100644 drivers/thunderbolt/eeprom.c
 create mode 100644 drivers/thunderbolt/nhi.c
 create mode 100644 drivers/thunderbolt/nhi.h
 create mode 100644 drivers/thunderbolt/nhi_regs.h
 create mode 100644 drivers/thunderbolt/path.c
 create mode 100644 drivers/thunderbolt/switch.c
 create mode 100644 drivers/thunderbolt/tb.c
 create mode 100644 drivers/thunderbolt/tb.h
 create mode 100644 drivers/thunderbolt/tb_regs.h
 create mode 100644 drivers/thunderbolt/tunnel_pci.c
 create mode 100644 drivers/thunderbolt/tunnel_pci.h
 create mode 100644 drivers/w1/slaves/w1_ds2406.c
 create mode 100644 include/linux/extcon/sm5502.h
 create mode 100644 include/linux/mic_bus.h
