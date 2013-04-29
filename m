Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab3D2QXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:23:51 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:52652 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab3D2QXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:23:42 -0400
Date: Mon, 29 Apr 2013 09:22:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver patches for 3.10-rc1
Message-ID: <20130429162232.GA6935@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 41ef2d5678d83af030125550329b6ae8b74618fa:

  Linux 3.9-rc7 (2013-04-14 17:45:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.10-rc1

for you to fetch changes up to a0eeed40100b2eca57afdf99d76c57dedd218a8a:

  staging: comedi: ni_labpc: fix legacy driver build (2013-04-23 12:55:03 -0700)

----------------------------------------------------------------
Staging driver tree update for 3.10-rc1

Here's the big staging driver tree update for 3.10-rc1

This update contains loads of comedi driver cleanups and fixes in here,
iio updates, android driver changes, and other various staging driver
cleanups.

Thanks to some drivers being removed, and the comedi driver cleanups, we
have removed more code than we added:
 627 files changed, 65145 insertions(+), 76321 deletions(-)
which is always nice to see.

All of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (10):
      staging: xgifb: delete redundant IF_DEF_LVDS check
      staging: xgifb: eliminate IF_DEF_LVDS checks from vb_init
      staging: xgifb: delete IF_DEF_TRUMPION and IF_DEF_DSTN
      staging: xgifb: delete LCD_SetFlag
      staging: xgifb: delete XGI330_LCDCapStruct.PSC_Sx
      staging: xgifb: delete XGI330_LCDCapStruct.PWD_2x
      staging: xgifb: delete pXGINew_DRAMTypeDefinition
      staging: xgifb: XGINew_SetDRAMDefaultRegister340: inline the value of SR1B
      staging: xgifb: make SR15/SR13 arrays single dimensional
      staging: xgifb: rename SR15/SR13 arrays to SR18

Alexandre Belloni (1):
      iio: mxs-lradc: Do hardware initialization earlier

Alexandru Gheorghiu (1):
      Staging: silicom: bp_mod: Removed trailing whitespaces

Alexey Khoroshilov (1):
      staging: dgrp: implement error handling in dgrp_create_class_sysfs_files()

Andres More (10):
      staging: vt6656: replaced custom BYTE definition with u8
      staging: vt6656: replaced custom WORD definition with u16
      staging: vt6656: replaced custom DWORD definition with u32
      staging: vt6656: removed custom pointer definitions
      staging: vt6656: removed no longer useful ttype.h file
      staging: vt6656: removed usage of custom Ethernet header
      staging: vt6656: removed custom 802.11 header usage
      staging: vt6656: remove code placeholders
      staging: vt6656: remove unused functions
      staging: vt6656: remove consecutive newlines

Andrew Morton (1):
      drivers/staging/zcache/zcache-main.c: fix build

Andy Shevchenko (4):
      staging: speakup: reuse native kernel functions
      staging: speakup: use native error codes
      staging: speakup: fix a bug when translate octal numbers
      staging: rts5129: re-use kbasename()

Arnd Bergmann (3):
      staging/zsmalloc: don't use pgtable-mapping from modules
      staging: nvec: allow modular build
      staging: comedi/daqboard2000: use mdelay for large delays

Arve Hjønnevåg (2):
      staging: android: lowmemorykiller: Don't count reserved free memory
      staging: android: lowmemorykiller: Change default debug_level to 1

Bob Liu (2):
      drivers: staging: zcache: fix compile error
      drivers: staging: zcache: fix compile warning

Changlong Xie (1):
      staging: sw_sync: sw_sync_timeline_ops can be static

Charndeep Grewal (1):
      staging: android: logger: enforce GID and CAP check on log flush

Chen Gang (3):
      staging: sep: using strlcpy instead of strncpy
      staging: zcache: using strlcpy instead of strncpy
      Drivers: Staging: cxt1e1: strncpy issue, need set zero at the end.

Christophe Leroy (1):
      IIO ADC support for AD7923

Dan Carpenter (8):
      Staging: bcm: potential forever loop verifying firmware
      wlan-ng: clean up prism2sta_inf_chinforesults()
      wlan-ng: add a bounds check
      Staging: dwc2: remove a kfree(NULL)
      staging: csr: info leak in unifi_cfg_get_info()
      staging: slicoss: information leak in ETHTOOL_GSET
      staging: dgrp: info leak in dgrp_dpa_ioctl()
      staging/ozwpan: info leak in oz_cdev_ioctl()

Daniel Borkmann (1):
      staging: net: remove pc300 driver

Denis Ciocca (1):
      iio:common: Use spi_sync_transfer() in STMicroelectronics common library

Devendra Naga (7):
      staging: et131x: fix invalid fail after the call to eeprom_wait_ready
      staging: csr: fix compilation warning in unifi_siwscan
      staging: olpc_dcon: return NOTIFY_DONE instead of the 0.
      staging:tidspbridge: rmgr: fix checkpatch errors
      staging: tidspbridge: rmgr: proc.c: fix checkpatch errors
      staging: et131x: cancel_work when module gets unloaded
      staging: gdm72xx: cancel work when driver unloads

Dmitry Pervushin (1):
      staging: sync: Add compat_ioctl handlers to sync drivers

Dmitry Voytik (1):
      staging: android: lowmemorykiller: well-marked debug print

Doug Anderson (2):
      iio: adc: Add dt support for turning on the phy in exynos-adc
      iio: adc: Document the regulator/clocks for exynos-adc

Eduardo Valentin (86):
      staging: omap-thermal: standardize register nomenclature to use 'GPU'
      staging: omap-thermal: remove from register map soc and mode on OMAP5
      staging: omap-thermal: introduce new features of OMAP54xx
      staging: omap-thermal: update OMAP54xx clock sources
      staging: omap-thermal: update feature bitfield for OMAP54xx
      staging: omap-thermal: remove dedicated counter register for OMAP5
      staging: omap-thermal: introduze FREEZE_BIT feature
      staging: omap-thermal: update DT entry documentation
      staging: omap-thermal: add DT example for OMAP54xx devices
      staging: omap-thermal: Remove double conv_table reference
      staging: omap-thermal: name data files accordingly
      staging: omap-thermal: update clock prepare count
      staging: omap-thermal: use BIT() macro
      staging: omap-thermal: remove unused _SHIFT macros
      staging: omap-thermal: create header for register, bitfields and definitions
      staging: omap-thermal: update documentation of omap-bandgap.h
      staging: omap-thermal: style cleanup on omap-bandgap.c
      staging: omap-thermal: fix error checking
      staging: omap-thermal: introduce RMW_BITS macro
      staging: omap-thermal: add documentation for register access functions
      staging: omap-thermal: make a omap_bandgap_power with only one exit point
      staging: omap-thermal: add documentation for omap_bandgap_power
      staging: omap-thermal: add documentation for omap_bandgap_read_temp
      staging: omap-thermal: rename talert handler
      staging: omap-thermal: update documentation for talert irq handler
      staging: omap-thermal: update tshut IRQ handler documentation
      staging: omap-thermal: remove duplicated code
      staging: omap-thermal: read status only once inside alert IRQ
      staging: omap-thermal: add a section of register manipulation
      staging: omap-thermal: section of basic helpers
      staging: omap-thermal: IRQ handler section
      staging: omap-thermal: ADC section
      staging: omap-thermal: name adc_to_temp_conversion in a better way
      staging: omap-thermal: rewrite omap_bandgap_adc_to_mcelsius on kernel coding style
      staging: omap-thermal: add documentation for omap_bandgap_adc_to_mcelsius
      staging: omap-thermal: name temp_to_adc_conversion in a better way
      staging: omap-thermal: rewrite omap_bandgap_mcelsius_to_adc on kernel coding style
      staging: omap-thermal: move conv table limits out of sensor data
      staging: omap-thermal: add documentation for omap_bandgap_mcelsius_to_adc
      staging: omap-thermal: rename add_hyst to omap_bandgap_add_hyst
      staging: omap-thermal: document omap_bandgap_add_hyst function
      staging: omap-thermal: threshold manipulation section
      staging: omap-thermal: refactor temp_sensor_unmask_interrupts
      staging: omap-thermal: update omap_bandgap_unmask_interrupts documentation
      staging: omap-thermal: refactor APIs handling threshold values
      staging: omap-thermal: device initialization section
      staging: omap-thermal: section of device driver callbacks
      staging: omap-thermal: rename enable_continuous_mode
      staging: omap-thermal: update omap_bandgap_set_continous_mode documentation
      staging: omap-thermal: document omap_bandgap_force_single_read
      staging: omap-thermal: document omap_bandgap_update_alert_threshold function
      staging: omap-thermal: document _omap_bandgap_write_threshold function
      staging: omap-thermal: document _omap_bandgap_read_threshold function
      staging: omap-thermal: document omap_bandgap_tshut_init function
      staging: omap-thermal: document omap_bandgap_alert_init function
      staging: omap-thermal: document omap_bandgap_build function
      staging: omap-thermal: change Kconfig dependency method
      staging: omap-thermal: Add a MAINTAINERS entry for TI bandgap and thermal driver
      staging: omap-thermal: switch mutex to spinlock inside omap-bandgap
      staging: omap-thermal: remove TODO entry suggesting regmap usage
      staging: omap-thermal: remove TODO entry for exposed APIs
      staging: omap-thermal: add documentation for omap_bandgap_validate
      staging: omap-thermal: fix return value
      staging: omap-thermal: rename bg_ptr to bgp
      staging: rename omap-thermal driver to ti-soc-thermal
      staging: ti-soc-thermal: rename Kconfig options
      staging: ti-soc-thermal: rename symbols to use better prefix
      staging: ti-soc-thermal: make unexported functions local
      staging: ti-soc-thermal: split writable data from readonly data
      stating: ti-soc-thermal: use sizeof(*pointer) while allocating
      staging: ti-soc-thermal: fix several kernel-doc warnings and error
      staging: ti-soc-thermal: fix condition to apply hyst
      staging: ti-soc-thermal: fix bitfield writing while updating thresholds
      staging: ti-soc-thermal: propagate error code
      staging: ti-soc-thermal: return error in case power switch is not supported
      staging: ti-soc-thermal: expose ti_thermal_report_temperature
      staging: ti-soc-thermal: report alert events on OMAP4 devices
      staging: ti-soc-thermal: report alert events on OMAP5 devices
      staging: ti-soc-thermal: update TODO list
      staging: ti-soc-thermal: fix min/max TODO (already done)
      staging: ti-soc-thermal: Remove TC1/TC2 TODO (already done)
      staging: ti-soc-thermal: introduce OMAP4430 extrapolation constants
      staging: ti-soc-thermal: update OMAP5 extrapolation rules
      staging: ti-soc-thermal: remove extrapolation rules from TODO
      staging: ti-soc-thermal: defer probe if cpufreq is not ready
      staging: ti-soc-thermal: fix device removal

Emil Goode (1):
      staging: comedi: amplc_dio200: fix C99 array initializer warnings

Erik Gilling (26):
      staging: sync: Add synchronization framework
      staging: sw_sync: Add cpu based sync driver
      staging: sync: Add timestamps to sync_pts
      staging: sync: Add debugfs support
      staging: sw_sync: Add debug support
      staging: sync: Add ioctl to get fence data
      staging: sw_sync: Add fill_driver_data support
      staging: sync: Add poll support
      staging: sync: Allow async waits to be canceled
      staging: sync: Export sync API symbols
      staging: sw_sync: Export sw_sync API
      staging: sync: Reorder sync_fence_release
      staging: sync: Optimize fence merges
      staging: sync: Add internal refcounting to fences
      staging: sync: Add reference counting to timelines
      staging: sync: Change wait timeout to mirror poll semantics
      staging: sync: Dump sync state to console on timeout
      staging: sync: Improve timeout dump messages
      staging: sync: Dump sync state on fence errors
      staging: sync: Protect unlocked access to fence status
      staging: sync: Update new fence status with sync_fence_signal_pt
      staging: sync: Use proper barriers when waiting indefinitely
      staging: sync: Refactor sync debug printing
      staging: sw_sync: Convert to use new value_str debug ops
      staging: sync: Add tracepoint support
      staging: sync: Don't log wait timeouts when timeout = 0

Fabio Estevam (1):
      staging: imx-drm: ipu-common: Fix sparse warnings

Frank Mori Hess (1):
      staging: comedi: adv_pci1724: new driver

Ganesan Ramalingam (1):
      Staging: Netlogic XLR/XLS GMAC driver

Ge Gao (1):
      using kfifo_in_spinlocked instead of separate code.

Greg Kroah-Hartman (9):
      Staging: ccg: remove it from the build
      Staging: ccg: delete it from the tree
      Merge 3.9-rc3 into staging-next
      Merge tag 'iio-for-3.10a' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge tag 'iio-for-3.10b' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.9-rc5 into staging-next
      Merge tag 'iio-for-3.10c' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge tag 'iio-for-3.10d' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.9-rc7 into staging-next

Guenter Roeck (3):
      staging: dgrp: Drop unnecessary typecast
      iio: Add OF support
      staging/iio: iio_hwmon: Use device tree node name for hwmon name attribute

H Hartley Sweeten (378):
      staging: comedi: comedi_pci: change the comedi_pci_auto_config() 'context'
      staging: comedi: 8255_pci: use the pci id_table 'driver_data'
      staging: comedi: addi_apci_1516: use the pci id_table 'driver_data'
      staging: comedi: addi_apci_16xx: use the pci id_table 'driver_data'
      staging: comedi: addi_apci_16xx: remove the boardinfo from the comedi_driver
      staging: comedi: addi_apci_3120: use the pci id_table 'driver_data'
      staging: comedi: adl_pci6208: use the pci id_table 'driver_data'
      staging: comedi: adl_pci7x3x: use the pci id_table 'driver_data'
      staging: comedi: adv_pci1710: use the pci id_table 'driver_data'
      staging: comedi: adv_pci_dio: use the pci id_table 'driver_data'
      staging: comedi: cb_pcidas: use the pci id_table 'driver_data'
      staging: comedi: cb_pcidas64: use the pci id_table 'driver_data'
      staging: comedi: cb_pcidas64: cleanup the boardinfo
      staging: comedi: cb_pcidda: use the pci id_table 'driver_data'
      staging: comedi: dt3000: use the pci id_table 'driver_data'
      staging: comedi: me4000: use the pci id_table 'driver_data'
      staging: comedi: me_daq: use the pci id_table 'driver_data'
      staging: comedi: ni_6527: cleanup pci_driver declaration
      staging: comedi: ni_6527: use the pci id_table 'driver_data'
      staging: comedi: ni_65xx: cleanup pci_driver declaration
      staging: comedi: ni_65xx: use the pci id_table 'driver_data'
      staging: comedi: ni_65xx: remove board() helper function
      staging: comedi: ni_65xx: remove n_ni_65xx_boards macro
      staging: comedi: ni_65xx: cleanup the boardinfo
      staging: comedi: ni_660x: use the pci id_table 'driver_data'
      staging: comedi: ni_660x: cleanup the boardinfo
      staging: comedi: ni_670x: use the pci id_table 'driver_data'
      staging: comedi: ni_pcidio: use the pci id_table 'driver_data'
      staging: comedi: ni_pcidio: remove n_ndio_boards macro
      staging: comedi: ni_pcidio: remove this_board macro
      staging: comedi: ni_pcimio: use the pci id_table 'driver_data'
      staging: comedi: ni_stc.h: remove boardtype macro
      staging: comedi: ni_stc.h: remove n_ni_boards macro
      staging: comedi: ni_pcimio: cleanup the boardinfo
      staging: comedi: rtd520: use the pci id_table 'driver_data'
      staging: comedi: skel: cleanup pci_driver declaration
      staging: comedi: skel: use the pci id_table 'driver_data'
      staging: comedi: skel: cleanup the boardinfo
      staging: comedi: addi_common: allow driver to set the board_ptr
      staging: comedi: addi_apci_035: set board_ptr before calling addi_auto_attach()
      staging: comedi: addi_apci_1500: set board_ptr before calling addi_auto_attach()
      staging: comedi: addi_apci_1564: set board_ptr before calling addi_auto_attach()
      staging: comedi: addi_apci_3200: use the pci id_table 'driver_data'
      staging: comedi: addi_apci_3xxx: use the pci id_table 'driver_data'
      staging: comedi: addi_common: remove addi_find_boardinfo()
      staging: comedi: addi_apci_1710: remove 'interrupt' from boardinfo
      staging: comedi: addi_apci_1710: remove boardinfo
      staging: comedi: addi_common: remove 'i_VendorId' and 'i_Device Id'
      staging: comedi: das08: remove 'id' from boardinfo
      staging: comedi: adl_pci8164: remove buggy dev_dbg()
      staging: comedi: adl_pci8164: simplify axis register determination
      staging: comedi: adl_pci8164: simplify (*insn_{read,write})
      staging: comedi: adl_pci8164: remove PCI_DEVICE_ID_* define
      staging: comedi: adl_pci8164: remove unnecessary includes
      staging: comedi: adl_pci8164: cleanup multi-line comments
      staging: comedi: ni_atmio: fix build errors
      staging: comedi_pci: make comedi_pci_disable() safe to call
      staging: comedi_pci: pass comedi_device to comedi_pci_enable()
      staging: comedi: addi_apci_1710: only pci bar 2 is used
      staging: comedi: ni_atmio: fix build error due to missing '; '
      staging: comedi: ni_labpc: rename labpc_board_struct
      staging: comedi: ni_labpc: remove thisboard macro
      staging: comedi: ni_labpc: add some whitespace to the *_driver declarations
      staging: comedi: ni_labpc: remove forward declarations 1
      staging: comedi: ni_labpc: remove forward declarations 2
      staging: comedi: ni_labpc: move the analog output support functions
      staging: comedi: ni_labpc: remove forward declarations 3
      staging: comedi: ni_labpc: remove forward declarations 4
      staging: comedi: ni_labpc: remove boardinfo data that is set to '0'
      staging: comedi: ni_labpc: remove "dummy" pci boardinfo entry
      staging: comedi: ni_labpc: cleanup the boardinfo
      staging: comedi: ni_labpc: remove 'volatile' from private data
      staging: comedi: ni_labpc: rename some of the private data variables
      staging: comedi: ni_labpc: tidy up range table declarations
      staging: comedi: ni_labpc: rename local var 'thisboard'
      staging: comedi: ni_labpc: rename boardinfo 'memory_mapped_io'
      staging: comedi: ni_labpc: introduce labpc_range_is_unipolar()
      staging: comedi: ni_labpc: rename subdevice (*insn_{read, write}) functions
      staging: comedi: ni_labpc: fix command support with analog input subdevice
      staging: comedi: ni_labpc: fix 8255 dio subdevice init
      staging: comedi: ni_labpc: tidy up subdevice init
      staging: comedi: ni_labpc: move declaration of local var 'dma_flags'
      staging: comedi: ni_labpc: use dev->board_name instead of DRV_NAME
      staging: comedi: ni_labpc: remove DRV_NAME
      staging: comedi: ni_labpc: move declaration of local var 'irq_flags'
      staging: comedi: ni_labpc: remove unnecessary test of dev->irq
      staging: comedi: ni_labpc: cleanup local var declarations in labpc_ai_cmd()
      staging: comedi: ni_labpc: cleanup local var declarations in labpc_ai_insn_read()
      staging: comedi: ni_labpc: introduce labpc_ai_set_chan_and_gain()
      staging: comedi: ni_labpc:use labpc_cancel() to remove some common code
      staging: comedi: ni_labpc: introduce labpc_setup_cmd6_reg()
      staging: comedi: ni_labpc: introduce labpc_read_adc_fifo()
      staging: comedi: ni_labpc: introduce labpc_ai_wait_for_data()
      staging: comedi: ni_labpc: fix a > 80 char line issue
      staging: comedi: ni_labpc: clean up multi-line comments
      staging: comedi: ni_labpc: clean up register map
      staging: comedi: ni_labpc: move a couple of the #define's
      staging: comedi: ni_labpc: remove inline from labpc_counter_load()
      staging: comedi: ni_labpc: introduce labpc_counter_set_mode()
      staging: comedi: ni_labpc: cleanup labpc_counter_load() usage
      staging: comedi: ni_labpc: return error from labpc_counter_set_mode()
      staging: comedi: ni_labpc: allow board to attach without interrupt
      staging: comedi: ni_labpc: allow board to attach without dma
      staging: comedi: ni_labpc: dma requires an interrupt
      staging: comedi: ni_labpc: remove board attach noise
      staging: comedi: ni_labpc: cleanup trigger setting in labpc_ai_cmd()
      staging: comedi: ni_labpc: return bool from labpc_use_continuous_mode()
      staging: comedi: ni_labpc: fix labpc_eeprom_insn_read()
      staging: comedi: s626: simplify dio register access
      staging: comedi: s626: factor dio interrupt handling from s626_irq_handler()
      staging: comedi: s626: cleanup "subdevice" and "cmd" in s626_irq_handler()
      staging: comedi: s626: use a local var for the s->async in s626_irq_handler()
      staging: comedi: s626: factor eos interrupt handling from s626_irq_handler()
      staging: comedi: s626: factor counter interrupt handling from s626_irq_handler()
      staging: comedi: s626: cleanup comedi_lrange table
      staging: comedi: s626: #ifdef out a block of unused code
      staging: comedi: s626: remove MC_ENABLE macro
      staging: comedi: s626: remove MC_DISABLE macro
      staging: comedi: ni_labpc: fix labpc_eeprom_insn_write()
      staging: comedi: ni_labpc: simplify labpc_range_is_unipolar()
      staging: comedi: ni_labpc: fix labpc_calib_insn_read()
      staging: comedi: ni_labpc: fix labpc_calib_insn_write()
      staging: comedi: s626: remove MC_TEST macro
      staging: comedi: s626: remove WR7146 and SETVECT macros
      staging: comedi: s626: remove RR7146 macro
      staging: comedi: s626: rename private data 'base_addr' variable
      staging: comedi: s626: remove the uint16_t casts of the bit values
      staging: comedi: s626: cleanup s626_dio_insn_config()
      staging: comedi: s626: cleanup s626_dio_insn_bits()
      staging: comedi: s626: remove subdevice pointer math
      staging: comedi: s626: cleanup subdevice init
      staging: comedi: s626: remove the ai (*insn_config) function
      staging: comedi: s626: async commands require an interrupt
      staging: comedi: s626: remove the "interrupt call test"
      staging: comedi: rtd520: use plx register map from plx9080.h
      staging: comedi: rtd520: use pci_ioremap_bar()
      staging: comedi: rtd520: cleanup rtd_dio_insn_bits()
      staging: comedi: rtd520: cleanup rtd_dio_insn_config()
      staging: comedi: rtd520: cleanup multi-line comments
      staging: comedi: rtd520: merge private header into driver
      staging: comedi: rtd520: remove dioStatus from private data
      staging: comedi: rtd520: remove intMask from private data
      staging: comedi: rtd520: remove intClearMask from private data
      staging: comedi: rtd520: remove utcCtrl from private data
      staging: comedi: rtd520: remove utcGate from private data
      staging: comedi: rtd520: cleanup rtd_dio_insn_config()
      staging: comedi: rtd520: rename CamelCase rtdPrivate
      staging: comedi: rtd520: rename CamelCase aoValue
      staging: comedi: rtd520: rename CamelCase transCount
      staging: comedi: rtd520: rename CamelCase fifoLen
      staging: comedi: rtd520: rename CamelCase in rtd_interrupt()
      staging: comedi: rtd520: rename CamelCase aiCount
      staging: comedi: rtd520: rename CamelCase rtdBoard
      staging: comedi: rtd520: rename CamelCase in rtdConvertChanGain()
      staging: comedi: rtd520: rename CamelCase chanBipolar
      staging: comedi: rtd520: rename thisboard variable
      staging: comedi: cb_pcidas64: use comedi provided range_bipolar10
      staging: comedi: das1800: use comedi provided range_bipolar10
      staging: comedi: das800: use comedi provided range_bipolar5
      staging: comedi: dt9812: use comedi provided range_bipolar10
      staging: comedi: range: introduce range_unipolar2_5
      staging: comedi: dt9812: use comedi provided range_unipolar2_5
      staging: comedi: ni_pcimio: use comedi provided range_bipolar10
      staging: comedi: ni_mio_common: use comedi provided range_bipolar5
      staging: comedi: usbduxsigma: use comedi provided range_unipolar2_5
      staging: comedi: range: introduce some simple mA ranges
      staging: comedi: serial2002: fix different address space sparse warnings
      staging: comedi: serial2002: factor (*poll) busy wait out of tty_read()
      staging: comedi: serial2002: cleanup tty_setspeed()
      staging: comedi: serial2002: cleanup serial_read()
      staging: comedi: serial2002: split up serial_2002_open()
      staging: comedi: serial2002: cleanup serial2002_setup_subdevs()
      staging: comedi: serial2002: don't assume the number of subdevices to detach
      staging: comedi: serial2002: add some whitespace to the subdevice init
      staging: comedi: serial2002: remove attach dev_dbg() noise
      staging: comedi: serial2002: return 0 after successful attach
      staging: comedi: serial2002: hookup the (*open) and (*close) last
      staging: comedi: serial2002: rename all the static functions
      staging: comedi: serial2002: remove pr_err() noise in serial2002_read()
      staging: comedi: serial2002: remove #if 0'ed out code
      staging: comedi: das1800: remove 'thisboard' macro
      staging: comedi: das800: remove 'thisboard' macro
      staging: comedi: dt2801: remove 'boardtype' macro
      staging: comedi: dt282x: remove 'boardtype' macro
      staging: comedi: ni_at_a2150: remove 'thisboard' macro
      staging: comedi: drivers: rename 'comedi_dev' in comedi_auto_config()
      staging: comedi: drivers: set dev->board_name before attaching
      staging: comedi: drivers: dev->board_name is always valid
      staging: comedi: comedi_pci: dev->board_name is always valid
      staging: comedi: remove unnecessary dev->board_name initialization
      staging: comedi: acl7225b: cleanup boardinfo
      staging: comedi: acl7225b: remove board attach kernel noise
      staging: comedi: acl7225b: cleanup dev->board_name usage
      staging: comedi: acl7225b: remove local var in acl7225b_attach()
      staging: comedi: acl7225b: dev->irq is already '0'
      staging: comedi: acl7225b: add some whitespace to the subdevice init
      staging: comedi: acl7225b: rename the (*insn_bits) subdevice functions
      staging: comedi: acl7225b: cleanup acl7225b_do_insn_bits()
      staging: comedi: acl7225b: cleanup acl7225b_di_insn_bits()
      staging: comedi: acl7225b: Update the MODULE_DESCRIPTION
      staging: comedi: rti800: cleanup comedi_lrange tables
      staging: comedi: rti800: remove forward declaration
      staging: comedi: rti800: cleanup boardinfo
      staging: comedi: rti800: remove '0' boardinfo data
      staging: comedi: rti800: remove the 'fingerprint' debug printk
      staging: comedi: rti800: remove board attach kernel noise
      staging: comedi: rti800: cleanup dev->board_name usage
      staging: comedi: rti800: remove interrupt code
      staging: comedi: rti800: move the comedi_alloc_subdevices()
      staging: comedi: rti800: remove adc_mux from private data
      staging: comedi: rti800: remove adc_range from private data
      staging: comedi: rti800: remove dac[01]_range from private data
      staging: comedi: rti800: use arrays to hold the ai/ao ranges
      staging: comedi: rti800: add some whitespace to the subdevice init
      staging: comedi: rti800: tidy up rti800_do_insn_bits()
      staging: comedi: rti800: tidy up rti800_di_insn_bits()
      staging: comedi: rti800: fix rti800_ao_insn_write()
      staging: comedi: rti800: tidy up rti800_ao_insn_read()
      staging: comedi: rti800: tidy up CR_{CHAN,RANGE} usage
      staging: comedi: rti800: tidy up analog input 'muxgain'
      staging: comedi: rti800: factor out "ai wait for conversion"
      staging: comedi: rti800: tidy up ai two's complement support
      staging: comedi: rti800: swap val and mask when reading ai data
      staging: comedi: rti800: change return of rti800_ai_insn_read()
      staging: comedi: rti800: remove am9513.h header
      staging: comedi: rti800: cleanup multi-line comments
      staging: comedi: rti800: update the MODULE_DESCRIPTION
      staging: comedi: rti800: tidy up the register map defines
      staging: comedi: drivers: introduce comedi_request_region()
      staging: comedi: pcl711: cleanup dev->board_name usage
      staging: comedi: pcl711: use comedi_request_region()
      staging: comedi: pcl724: cleanup dev->board_name usage
      staging: comedi: pcl724: use comedi_request_region()
      staging: comedi: pcl725: use comedi_request_region()
      staging: comedi: pcl726: cleanup dev->board_name usage
      staging: comedi: pcl726: use comedi_request_region()
      staging: comedi: pcl730: cleanup dev->board_name usage
      staging: comedi: pcl730: use comedi_request_region()
      staging: comedi: pcl812: cleanup dev->board_name usage
      staging: comedi: pcl812: use comedi_request_region()
      staging: comedi: pcl816: cleanup dev->board_name usage
      staging: comedi: pcl816: use comedi_request_region()
      staging: comedi: pcl818: cleanup dev->board_name usage
      staging: comedi: pcl818: use comedi_request_region()
      staging: comedi: pcl3724: use comedi_request_region()
      staging: comedi: pcl3730: use comedi_request_region()
      staging: comedi: amplc_dio200: cleanup dev->board_name usage
      staging: comedi: ampcl_dio200: use comedi_request_region()
      staging: comedi: ampcl_pc236: use comedi_request_region()
      staging: comedi: ampcl_pc263: use comedi_request_region()
      staging: comedi: rti802: use comedi_request_region()
      staging: comedi: das16m1: use comedi_request_region()
      staging: comedi: das08_isa: use comedi_request_region()
      staging: comedi: das16: cleanup dev->board_name usage
      staging: comedi: das16: use comedi_request_region()
      staging: comedi: das800: use comedi_request_region()
      staging: comedi: das1800: use comedi_request_region()
      staging: comedi: das6402: use comedi_request_region()
      staging: comedi: dt2801: use comedi_request_region()
      staging: comedi: dt2811: cleanup dev->board_name usage
      staging: comedi: dt2811: use comedi_request_region()
      staging: comedi: dt2814: use comedi_request_region()
      staging: comedi: dt2815: use comedi_request_region()
      staging: comedi: dt2817: use comedi_request_region()
      staging: comedi: dt282x: cleanup dev->board_name usage
      staging: comedi: dt282x: use comedi_request_region()
      staging: comedi: dmm32at: use comedi_request_region()
      staging: comedi: fl512: use comedi_request_region()
      staging: comedi: aio_aio12_8: cleanup dev->board_name usage
      staging: comedi: aio_aio12_8: use comedi_request_region()
      staging: comedi: aio_iiro_16: use comedi_request_region()
      staging: comedi: c6xdigio: board does not use interrupts
      staging: comedi: c6xdigio: remove usless comment
      staging: comedi: c6xdigio: use comedi_request_region()
      staging: comedi: mpc624: use comedi_request_region()
      staging: comedi: adq12b: use comedi_request_region()
      staging: comedi: adq12b: remove need for some local variables
      staging: comedi: ni_at_a2150: use comedi_request_region()
      staging: comedi: ni_atmio: use comedi_request_region()
      staging: comedi: ni_atmio16d: cleanup dev->board_name usage
      staging: comedi: ni_atmio16d: use comedi_request_region()
      staging: comedi: pcmad: cleanup dev->board_name usage
      staging: comedi: pcmad: use comedi_request_region()
      staging: comedi: pcmda12: use comedi_request_region()
      staging: comedi: pcmmio: use comedi_request_region()
      staging: comedi: pcmuio: cleanup dev->board_name usage
      staging: comedi: pcmuio: use comedi_request_region()
      staging: comedi: multiq3: board does not use interrupts
      staging: comedi: multiq3: remove usless comment
      staging: comedi: multiq3: use comedi_request_region()
      staging: comedi: poc: cleanup dev->board_name usage
      staging: comedi: poc: use comedi_request_region()
      staging: comedi: drivers: refactor comedi_request_region()
      staging: comedi: 8255: use __comedi_request_region()
      staging: comedi: das16: use __comedi_request_region()
      staging: comedi: das16m1: use __comedi_request_region()
      staging: comedi: pcl816: use __comedi_request_region()
      staging: comedi: pcl818: use __comedi_request_region()
      staging: comedi: comedi_parport: use comedi_request_region()
      staging: comedi: unionxx5: refactor subdevice init
      staging: comedi: s526: use comedi_request_region()
      staging: comedi: ni_at_ao: cleanup dev->board_name usage
      staging: comedi: ni_at_ao: use comedi_request_region()
      staging: comedi: ni_labpc: cleanup dev->board_name usage
      staging: comedi: ni_labpc: only ISA boards need to request_region()
      staging: comedi: ni_labpc: use comedi_request_region()
      staging: comedi: das1800: use __comedi_request_region()
      staging: comedi: acl7225b: use comedi_request_region()
      staging: comedi: rti800: use comedi_request_region()
      staging: comedi: daqboard2000: use pci_ioremap_bar()
      staging: comedi: gsc_hpdi: remove the base_address_regions enum
      staging: comedi: gsc_hpdi: use pci_ioremap_bar()
      staging: comedi: me_daq: use pci_ioremap_bar()
      staging: comedi: s626: use pci_ioremap_bar()
      staging: comedi: cb_pcidas64: remove the base_address_regions enum
      staging: comedi: cb_pcidas64: use pci_ioremap_bar()
      staging: comedi: cb_pcidas64: tidy up the *phys_iobase
      staging: comedi: dt3000: use pci_ioremap_bar()
      staging: comedi: 8255_pci: use pci_ioremap_bar()
      staging: comedi: icp_multi: use pci_ioremap_bar()
      staging: comedi: mite: use pci_ioremap_bar()
      staging: comedi: jr3_pci: use pci_ioremap_bar()
      staging: comedi: addi_common: use pci_ioremap_bar()
      staging: comedi: addi_common: remove i_IorangeBase3 from boardinfo
      staging: comedi: addi_common: remove i_IorangeBase2 from boardinfo
      staging: comedi: addi_common: remove i_IorangeBase0 from boardinfo
      staging: comedi: ii_pci20kc: remove comment about 2.4 kernels
      staging: comedi: unionxx5: allocate 'usp' before using it
      staging: comedi: use EXPORT_SYMBOL_GPL() for all exported symbols
      staging: comedi: cb_pcimdas: remove unused include
      staging: comedi: plx9052: tidy up the register defines
      staging: comedi: adl_pci9111: use plx9052.h defines
      staging: comedi: me4000: use plx9052.h defines
      staging: comedi: plx9052.h: document the CNTRL register
      staging: comedi: me_daq: use plx9052.h defines
      staging: comedi: unionxx5: fix memory leak during subdevice init
      staging: comedi: introduce, and use, comedi_spriv_free()
      staging: comedi: drivers: introduce comedi_legacy_detach()
      staging: comedi: pcl812: use comedi_legacy_detach()
      staging: comedi: das16: use comedi_legacy_detach()
      staging: comedi: das16m1: use comedi_legacy_detach()
      staging: comedi: das16m1: check for subdev_8255_init() failure
      staging: comedi: das1800: use comedi_legacy_detach()
      staging: comedi: drivers: use comedi_legacy_detach() in simple drivers
      staging: comedi: amplc_dio200: use comedi_legacy_detach()
      staging: comedi: skel: use comedi_legacy_detach()
      staging: comedi: drivers: use comedi_legacy_detach()
      staging: comedi: drivers: free_irq() in comedi_legacy_detach()
      staging: comedi: pcl818: remove unused RTC dma support
      staging: comedi: pcl816: remove unused RTC dma support
      staging: comedi: ni_labpc: split out PCI support
      staging: comedi: ni_labpc: move DMA init out of the common attach
      staging: comedi: ni_labpc: pass the isr_flags to labpc_common_attach()
      staging: comedi: ni_labpc: remove unnecessary 'bustype' check
      staging: comedi: ni_labpc: remove 'bustype' from boardinfo
      staging: comedi: das800: move module_{init, exit} to end of file
      staging: comedi: das800: move das800_attach()
      staging: comedi: das800: move das800_probe()
      staging: comedi: das800: move das800_set_frequency()
      staging: comedi: das800: remove forward declarations
      staging: comedi: das800: introduce das800_ind_{write, read}()
      staging: comedi: das800: cleanup range table declarations
      staging: comedi: das800: cleanup the boardinfo
      staging: comedi: das800: remove 'volatile' on private data variables
      staging: comedi: das800: tidy up das800_ai_do_cmdtest()
      staging: comedi: das800: interrupts are required for async command support
      staging: comedi: das800: allow attaching without interrupt support
      staging: comedi: das800: tidy up subdevice init
      staging: comedi: das800: rename {enable,disable}_das800
      staging: comedi: das800: remove extra divisor calculation call
      staging: comedi: das800: tidy up das800_do_insn_bits()
      staging: comedi: das800: tidy up das800_di_insn_bits()
      staging: comedi: das800: tidy up das800_ai_insn_read()
      staging: comedi: das800: tidy up das800_interrupt()
      staging: comedi: das800: tidy up the private data
      staging: comedi: das800: rename CamelCase vars in das800_ai_do_cmd()
      staging: comedi: das800: cleanup the cio-das802/16 fifo comments
      staging: comedi: ni_labpc: fix legacy driver build

Haksu Jeong (1):
      staging: rtl8192u: fix coding style

Ian Abbott (64):
      staging: comedi: adv_pci1710: restore PCI-1710HG support
      staging: comedi: adv_pci1710: remove iorange member
      staging: comedi: adv_pci_dio: restore PCI-1753E support
      staging: comedi: ni_660x: reformat driver description comment
      staging: comedi: ni_660x: support NI PXI-6624
      staging: comedi: make 'dev->attached' a bool bit-field
      staging: comedi: make 'in_request_module' a bool bit-field
      staging: comedi: add 'ioenabled' flag to device
      staging: comedi: remove unneeded settings of `dev->iobase`
      staging: comedi: ni_labpc: fix common detach
      staging: comedi: amplc_dio200: split dio200_boards[] into ISA & PCI
      staging: comedi: amplc_dio200: don't check bus type in attach
      staging: comedi: amplc_dio200: Simplify PCI board look-up
      staging: comedi: amplc_dio200: embed board layout in board structure
      staging: comedi: amplc_dio200: shrink struct dio200_subdev_intr
      staging: comedi: amplc_dio200: dio200_common_attach() return 0
      staging: comedi: amplc_dio200: set board_name before common attach
      staging: comedi: amplc_dio200: remove DIO200_DRIVER_NAME
      staging: comedi: amplc_dio200: remove dio200_report_attach()
      staging: comedi: amplc_dio200: don't check bus-type in dio200_common_attach()
      staging: comedi: amplc_dio200: refactor dio200_handle_read_intr()
      staging: comedi: amplc_dio200: split into ISA, PCI and common
      staging: comedi: Kconfig: update CONFIG_AMPLC_DIO200_PCI help text
      staging: comedi: check comedi_auto_config() params
      staging: comedi: no need to zero out comedi_file_info_table[]
      staging: comedi: remove memset() call from comedi_device_init()
      staging: comedi: adjust module count on device cleanup
      staging: comedi: refactor comedi_free_board_minor()
      staging: comedi: add comedi_release_hardware_device()
      staging: comedi: call comedi_release_hardware_device() on error
      staging: comedi: make comedi_free_board_minor() static
      staging: comedi: change comedi_alloc_board_minor() to return pointer
      staging: comedi: pre-lock mutex on creation of comedi device
      staging: comedi: avoid releasing legacy minors automatically
      staging: comedi: no need to evade comedi_auto_unconfig()
      staging: comedi: remove manually unconfigured dynamic devices
      staging: comedi: avoid forward declarations
      staging: comedi: simplify driver module counting
      staging: comedi: put module _after_ detach
      staging: comedi: replace __comedi_device_detach()
      staging: comedi: move detach out of post-config
      staging: comedi: set hw_dev in comedi_alloc_board_minor()
      staging: comedi: change comedi_file_info_table_lock to mutex
      staging: comedi: move COMEDI_NUM_MINORS and COMEDI_FIRST_SUBDEVICE_MINOR
      staging: comedi: remove COMEDI_FIRST_SUBDEVICE_MINOR
      staging: comedi: separate board and subdevice minor tables
      staging: comedi: remove comedi_clear_minor()
      staging: comedi: remove hardware_device from struct comedi_device_info
      staging: comedi: rename dev parameter of device attribute functions
      staging: comedi: get mutex before subdevice in attribute functions
      staging: comedi: use minor device number in attribute functions
      staging: comedi: change comedi_read/write_subdevice() parameters
      staging: comedi: reduce use of struct comedi_file_info
      staging: comedi: refactor comedi_dev_from_minor()
      staging: comedi: remove comedi_clear_subdevice_minor()
      staging: comedi: remove comedi_file_info_from_board_minor()
      staging: comedi: simplify comedi_subdevice_minor_table[]
      staging: comedi: simplify comedi_board_minor_table[]
      staging: comedi: remove struct comedi_file_info
      staging: comedi: add comedi_clear_board_dev()
      staging: comedi: amplc_pc263: split out PCI support
      staging: comedi: addi_apci_*: replace ADDIDATA_OLD with AMCC
      staging: comedi: 8255_pci: check BAR resource type directly
      staging: comedi: amplc_dio200_pci: use pci_ioremap_bar()

J Keerthy (9):
      staging: ti-soc-thermal: Add counter_delay_mask field to temp_sensor_registers struct
      staging: ti-soc-thermal: Initialise counter_delay field for OMAP5 sensors
      staging: ti-soc-thermal: Introduce HAS_COUNTER_DELAY feature for bandgap
      staging: ti-soc-thermal: Enable COUNTER_DELAY feature for OMAP5
      staging: ti-soc-thermal: Modify update_interval r/w functions to incorporate the OMAP5 feature of COUNTER_DELAY.
      staging: ti-soc-thermal: Introduce HAS_HISTORY_BUFFER feature for bandgap
      staging: ti-soc-thermal: Enable HISTORY_BUFFER Feature for OMAP5
      staging: ti-soc-thermal:Introduce ti_bandgap_get_trend function for OMAP5
      staging: ti-soc-thermal: Add get_trend support

Jacob Garber (1):
      Staging: comedi: Fixed camel case style issue in usbdux.c

Jamie Gennis (1):
      staging: sync: Fix timeout = 0 wait behavior

Jean-Christophe PLAGNIOL-VILLARD (2):
      iio: at91_adc: add sleep mode support
      iio: at91_adc: fix missing Sample and Hold time

Jin Feng (1):
      staging:iio:dummy: Fix mismatch and export sysfs entry

Joe Perches (49):
      staging: slicoss: Remove dma_addr_t cast compilation warnings
      staging:vt6655:80211hdr: Whitespace cleanups
      staging:vt6655:80211mgr: Whitespace cleanups
      staging:vt6655:IEEE11h: Whitespace cleanups
      staging:vt6655:aes_ccmp: Whitespace cleanups
      staging:vt6655:baseband: Whitespace cleanups
      staging:vt6655:bssdb: Whitespace cleanups
      staging:vt6655:card: Whitespace cleanups
      staging:vt6655:channel: Whitespace cleanups
      staging:vt6655:country: Whitespace cleanups
      staging:vt6655:datarate: Whitespace cleanups
      staging:vt6655:desc: Whitespace cleanups
      staging:vt6655:device: Whitespace cleanups
      staging:vt6655:device_cfg: Whitespace cleanups
      staging:vt6655:device_main: Whitespace cleanups
      staging:vt6655:dpc: Whitespace cleanups
      staging:vt6655:hostap: Whitespace cleanups
      staging:vt6655:iocmd: Whitespace cleanups
      staging:vt6655:ioctl: Whitespace cleanups
      staging:vt6655:iowpa: Whitespace cleanups
      staging:vt6655:iwctl: Whitespace cleanups
      staging:vt6655:key: Whitespace cleanups
      staging:vt6655:mac: Whitespace cleanups
      staging:vt6655:mib: Whitespace cleanups
      staging:vt6655:michael: Whitespace cleanups
      staging:vt6655:power: Whitespace cleanups
      staging:vt6655:rc4: Whitespace cleanups
      staging:vt6655:rf: Whitespace cleanups
      staging:vt6655:rxtx: Whitespace cleanups
      staging:vt6655:srom: Whitespace cleanups
      staging:vt6655:tcrc: Whitespace cleanups
      staging:vt6655:tether: Whitespace cleanups
      staging:vt6655:tkip: Whitespace cleanups
      staging:vt6655:ttype: Whitespace cleanups
      staging:vt6655:upc: Whitespace cleanups
      staging:vt6655:vntwifi: Whitespace cleanups
      staging:vt6655:wcmd: Whitespace cleanups
      staging:vt6655:wctl: Whitespace cleanups
      staging:vt6655:wmgr: Whitespace cleanups
      staging:vt6655:wpa: Whitespace cleanups
      staging:vt6655:wpa2: Whitespace cleanups
      staging:vt6655:wpactl: Whitespace cleanups
      staging:vt6655:wroute: Whitespace cleanups
      staging: vt6655: Remove commented out printks
      staging: vt6655: Convert to kernel brace style
      staging: vt6655: Remove unnecessary parentheses from returns
      staging: vt6655: Remove commented out if()s
      staging: vt6655: Fix macro definitions
      staging: vt6655: Remove unnecessary blank lines

Joerg Roedel (1):
      staging: zsmalloc: Fix link error on ARM

Jonathan Cameron (77):
      iio: Add broken out info_mask fields for shared_by_type and separate
      iio:adc:max1363 move to info_mask_(shared_by_type/separate)
      staging:iio:dummy move to info_mask_(shared_by_type/separate)
      iio:hid_sensors move to info_mask_(shared_by_type/separate)
      iio:accel:kxsd9 move to info_mask_(shared_by_type/separate)
      iio:st_sensors move to info_mask_(shared_by_type/separate)
      iio:adc:ad_sigma_delta move to info_mask_(shared_by_type/separate)
      iio:adc:ad7266 move to info_mask_(shared_by_type/separate)
      iio:adc:ad7298 move to info_mask_(shared_by_type/separate)
      iio:adc:ad7476 move to info_mask_(shared_by_type/separate)
      iio:adc:ad7887 move to info_mask_(shared_by_type/separate)
      iio:adc:at91_adc move to info_mask_(shared_by_type/separate)
      iio:adc:lp8778_adc move to info_mask_(shared_by_type/separate)
      iio:adc:ti-adc081 move to info_mask_(shared_by_type/separate)
      iio:adc:ti_am335x_adc move to info_mask_(shared_by_type/separate)
      iio:adc:viperboard_adc move to info_mask_(shared_by_type/separate)
      iio:amplifiers:ad8366 move to info_mask_(shared_by_type/separate)
      iio:dac:ad5064 move to info_mask_(shared_by_type/separate)
      iio:dac:ad5360 move to info_mask_(shared_by_type/separate)
      iio:dac:ad5380 move to info_mask_(shared_by_type/separate)
      iio:dac:ad5421 move to info_mask_(shared_by_type/separate)
      iio:dac:ad5446 move to info_mask_(shared_by_type/separate)
      iio:dac:ad5449 move to info_mask_(shared_by_type/separate)
      iio:dac:ad5504 move to info_mask_(shared_by_type/separate)
      iio:dac:ad5624r move to info_mask_(shared_by_type/separate)
      iio:dac:ad5686 move to info_mask_(shared_by_type/separate)
      iio:dac:ad5755 move to info_mask_(shared_by_type/separate)
      iio:dac:ad5764 move to info_mask_(shared_by_type/separate)
      iio:dac:ad5791 move to info_mask_(shared_by_type/separate)
      iio:dac:max517 move to info_mask_(shared_by_type/separate)
      iio:dac:mcp4725 move to info_mask_(shared_by_type/separate)
      iio:freq:ad9523 move to info_mask_(shared_by_type/separate)
      iio:gyro:adis16080 move to info_mask_(shared_by_type/separate)
      iio:gyro:adis16136 move to info_mask_(shared_by_type/separate)
      iio:gyro:adxrs450 move to info_mask_(shared_by_type/separate)
      iio:gyro:itg3200_core move to info_mask_(shared_by_type/separate)
      iio:imu:adis16400 move to info_mask_(shared_by_type/separate)
      iio:imu:adis16480 move to info_mask_(shared_by_type/separate)
      iio:imu:mpu6050 move to info_mask_(shared_by_type/separate)
      iio:light:adjd_s311 move to info_mask_(shared_by_type/separate)
      iio:light:lm3533 move to info_mask_(shared_by_type/separate)
      iio:light:tsl2563 move to info_mask_(shared_by_type/separate)
      iio:light:vcnl4000 move to info_mask_(shared_by_type/separate)
      staging:iio:accel:adis move to info_mask_(shared_by_type/separate)
      staging:iio:accel:adis16220 move to info_mask_(shared_by_type/separate)
      staging:iio:accel:lis3l02dq move to info_mask_(shared_by_type/separate)
      staging:iio:accel:sca3000 move to info_mask_(shared_by_type/separate)
      staging:iio:adc:ad7280a move to info_mask_(shared_by_type/separate)
      staging:iio:adc:ad7291 move to info_mask_(shared_by_type/separate)
      staging:iio:adc:ad7606 move to info_mask_(shared_by_type/separate)
      staging:iio:adc:ad799x move to info_mask_(shared_by_type/separate)
      staging:iio:cdc:ad7150 move to info_mask_(shared_by_type/separate)
      staging:iio:cdc:ad7152 move to info_mask_(shared_by_type/separate)
      staging:iio:cdc:ad7746 move to info_mask_(shared_by_type/separate)
      staging:iio:gyro:adis16060 move to info_mask_(shared_by_type/separate)
      staging:iio:gyro:adis16130 move to info_mask_(shared_by_type/separate)
      staging:iio:impedance:ad5933 move to info_mask_(shared_by_type/separate)
      staging:iio:light:isl29018 move to info_mask_(shared_by_type/separate)
      staging:iio:light:isl29028 move to info_mask_(shared_by_type/separate)
      staging:iio:light:tsl2x7x move to info_mask_(shared_by_type/separate)
      staging:iio:mag:ak8975 move to info_mask_(shared_by_type/separate)
      staging:iio:magnetometer:hmc5843 move to info_mask_(shared_by_type/separate)
      staging:iio:meter:ade7758 move to info_mask_(shared_by_type/separate)
      staging:iio:resolver:ad2s1200 move to info_mask_(shared_by_type/separate)
      staging:iio:resolver:ad2s1210 move to info_mask_(shared_by_type/separate)
      staging:iio:resolver:ad2s90 move to info_mask_(shared_by_type/separate)
      iio:adc:exynos move to info_mask_(shared_by_type/separate)
      iio:adc:ad7923 move to info_mask_(shared_by_type/separate)
      staging:iio:adc:spear move to info_mask_(shared_by_type/separate)
      staging:iio:adc:mxs move to info_mask_(shared_by_type/separate)
      staging:iio:adc:lpc32xx move to info_mask_(shared_by_type/separate)
      iio:core drop info_mask from struct iio_info
      hwmon: Move the IIO client driver for hwmon out of staging
      staging:iio:magnetometer:ak8975 drop unused eoc_irq
      staging:iio:magnetometer:ak8975 drop I2C_M_NOSTART flag in read_data
      staging:iio:magnetometer:ak8975 use standard i2c_smbus read functions.
      iio:magnetometer:ak8975 move driver out of staging

Kevin McKinney (4):
      Staging: bcm: Fix all white space issues in PHSModule.c
      Staging: bcm: Properly format braces in PHSModule.c
      Staging: bcm: Properly format comments in PHSModule.c
      Staging: bcm: Fix spelling error in PHSModule.c

Konrad Rzeszutek Wilk (12):
      zcache: s/int/bool/ on the various options.
      zcache: Provide accessory functions for counter increase
      zcache: Provide accessory functions for counter decrease.
      zcache: The last of the atomic reads has now an accessory function.
      zcache: Make the debug code use pr_debug
      zcache: Move debugfs code out of zcache-main.c file.
      zcache/debug: Use an array to initialize/use debugfs attributes.
      zcache: Move the last of the debugfs counters out
      zcache: Module license is defined twice.
      zcache/debug: Coalesce all debug under CONFIG_ZCACHE_DEBUG
      staging: zcache/debug: compiler failure on PPC64 and revert commit.
      zcache/TODO: Update on two items.

Kumar Amit Mehta (1):
      staging: vme: fix for a potential NULL pointer dereference

Kurt Kanzenbach (18):
      staging: usbip: userspace: libsrc: fix indention
      staging: usbip: userspace: libsrc: do not init static/globals to 0
      staging: usbip: userspace: libsrc: spaces required around that '='
      staging: usbip: userspace: libsrc: (foo*) should be (foo *)
      staging: usbip: userspace: libsrc: replaced lines over 80 characters
      staging: usbip: userspace: libsrc: removed assignments in if conditions
      staging: usbip: userspace: libsrc: added missing space
      staging: usbip: removed lines over 80 characters
      staging: usbip: reformat function stub_recv_cmd_unlink()
      staging: usbip: removed enumeration of comments
      staging: usbip: simplified errorhandling
      staging: usbip: removed unnecessary if-else-statements
      staging: usbip: removed unnecessary for loop
      staging: usbip: simplified cleanup function
      staging: usbip: userspace: removed unnecessary code
      staging: usbip: userspace: libsrc: cleanup parsing
      staging: usbip: userspace: unified command line arguments
      staging: usbip: userspace: show product name in `list -l' command

Lars-Peter Clausen (14):
      staging:iio: Remove adt7410 driver
      iio: events: Make iio_push_event() IRQ context save
      iio:ad7923: Return error if we didn't get the expected result
      iio:ad7923: Implement scale reporting
      iio:adc:ad7923: Add support for the ad7904/ad7914/ad7924
      iio:trigger: Introduce iio_tigger_{set,get}_drvdata
      iio:trigger: Use dev_{set,get}_drvdata for private data management
      staging:iio:ad799x: Remove unused ad799x_state fields
      staging:iio:ad799x: Remove internal reference support
      staging:iio:ad799x: Use i2c_smbus_{read,write}_word_data_swapped
      staging:iio:ad799x: Add helper macro for channel initialization
      staging:iio:ad799x: Set IIO_CHAN_INFO_SCALE mask
      staging:iio:ad799x: Preallocate sample buffer
      staging: cptm1217: Use dev_pm_ops

Laurent Navet (1):
      staging: line6: pod.c: fix checkpatch warning

Ludovic Desroches (1):
      iio: at91_adc: add low and high res support

Malcolm Priestley (1):
      staging: vt6656: Fix stuck in scanning with variable uScanChannel.

Marek Vasut (2):
      staging: imx-drm: Make IPU KMS parse display-timings
      staging: video: imx: Add BGR666 support for parallel display

Masanari Iida (7):
      staging: comedi: Fix typo in comedi
      staging: sb105x: Fix typo in comments and printk
      staging: csr: Fix typos in csr
      staging: davinci: Fix typo in staging/media/davinci
      staging: sep: Fix typo in printk within sep driver
      staging:csr: Fix typos in comment and printk
      staging:csr: Fix typo in staging/csr driver

Matthijs Kooijman (7):
      staging: dwc2: always release host channel after dequeueing
      staging: dwc2: toggle periodic debugging output separately
      staging: dwc2: don't pass IRQ_LEVEL to devm_request_irq
      staging: dwc2: register common irq handler in dwc2_core_init
      staging: dwc2: set the driver name to "dwc2"
      staging: dwc2: Make dwc2_set_uninitialized more specific
      staging: dwc2: add platform device bindings

Mihnea Dobrescu-Balaur (1):
      staging: bcm: don't cast kzalloc() return value

Mirsal Ennaime (4):
      drivers: android: binder: Move the node release code to a separate function
      drivers: android: binder: Fix code style in binder_deferred_release
      drivers: android: binder: Remove excessive indentation
      drivers: android: binder: Use __func__ in debug messages

Nathan Zimmer (1):
      staging: dgrp: cleanup sparse warnings

Naveen Krishna Chatradhi (2):
      iio: adc: add exynos adc driver under iio framwork
      iio: adc: Kconfig: exynos_adc depends on CONFIG_OF

Nick Kralevich (1):
      staging: android: logger: Allow a UID to read it's own log entries

Nick Østergaard (1):
      staging: wlan-ng: prism2usb.c: fix printk(KERN_ERR... to dev_err(dev, ...

Niklas Söderlund (4):
      rtl8712: remove unused functions from rtl871x_recv.h
      rtl8712: remove dead function prototypes from rtl871x_recv.h
      rtl8712: remove unused definitions from rtl871x_recv.h
      rtl8712: remove redundant if statement

Nishanth Menon (1):
      staging: ti-soc-thermal: remove kernel-doc warnings reported with -v

Paul Bolle (2):
      staging: android: remove dependency on TINY_SHMEM
      staging: sb105x: Remove obsolete CONFIG_M386

Paul Zimmerman (12):
      staging: Core files for the DWC2 driver
      staging: HCD files for the DWC2 driver
      staging: HCD descriptor DMA support for the DWC2 driver
      staging: PCI bus interface for the DWC2 driver
      staging: Add a MAINTAINERS entry for the DWC2 driver
      staging: Hook the DWC2 driver into the build system
      staging: dwc2: fix compiler warnings
      staging: dwc2: remove unneeded arguments from two functions
      staging: dwc2: fix wrong setting of DMA masks
      staging: dwc2: fix potential null pointer access
      staging: dwc2: add missing newlines to debug messages
      staging: dwc2: check for null pointer before dereferencing it

Peter Huewe (11):
      staging/sep: Fix smatch false positive about potential NULL dereference in sep_main.c
      staging/sep: Check pointers before dereferencing (fix smatch warning)
      staging/slicoss: Check pointer before dereferencing
      staging/slicoss: Remove always true if statement
      staging/slicoss: Fix operation may be undefined warning
      staging/slicoss: Fix buffer possible overflow in slic_card_locate
      staging/slicoss: Use ether_crc for mac hash calculation
      staging/sm7xxfb: Convert to SIMPLE_DEV_PM_OPS
      staging/gdm72xx: Include corresponding header file (fix sparse warning)
      staging/gdm72xx: Remove unused variable in gdm_qos.c
      staging/gdm72xx: Remove duplicated code in gdm_qos.c

Philipp Zabel (7):
      staging: drm/imx: ipu-dc: add 24-bit GBR support to DC
      staging: drm/imx: ipuv3-crtc: use external clock for TV Encoder
      staging: drm/imx: ipu-di: add comments explaining signal generator configuration
      staging: drm/imx: Add support for VGA via TVE on i.MX53
      staging: drm/imx: ipu-dc: add WCLK/WRG opcodes
      staging: drm/imx: ipu-dc: force black output during blanking
      staging: drm/imx: Add support for Television Encoder (TVEv2)

Radhesh Fadnis (2):
      staging: omap-thermal: introduce clock feature flag
      staging: omap-thermal: update OMAP54xx conv_table

Randy Dunlap (1):
      staging: fix all sparse warnings in silicom/bypasslib/

Rebecca Schultz Zavin (2):
      staging: sync: Fix error paths
      staging: sw_sync: Fix error paths

Ruslan Ruslichenko (1):
      staging: omap-thermal: Add print when TSHUT temperature reached

Sachin Kamat (3):
      staging: ste_rmi4: Make synaptics_rmi4_touchpad_config symbol static
      iio: exynos_adc: Remove redundant of_match_ptr macro
      iio: exynos-adc: Fix typo in DT documentation

Sascha Hauer (1):
      staging: drm/imx: update TODO file

SeongJae Park (1):
      staging: csr: csr_time.c: Fix coding style

Serban Constantinescu (2):
      staging: android: ashmem: Add support for 32bit ashmem calls in a 64bit kernel
      staging: android: binder: replace IOCTL types with user-exportable types

Shankar Brahadeeswaran (1):
      staging: android: ashmem: get_name,set_name not to hold ashmem_mutex

Shawn Guo (1):
      staging: rts5139: device_reset() can be static

Silviu-Mihai Popescu (1):
      imx_drm: ipu_v3: fix invalid free of devm_* allocated data

Stefan Reif (7):
      staging: usbip: remove unnecessary braces
      staging: usbip: userspace: fix whitespace errors
      staging: usbip: userspace: libsrc: replace numbers by ascii
      staging: usbip: reformat function pickup_urb_and_free_priv
      staging: usbip: remove unnused, broken macro
      staging: usbip: simple indent fix
      staging: usbip: userspace: avoid memory leaks

Stephen Rothwell (2):
      staging: zcache: disable ZCACHE_DEBUG due to build error
      staging: the DWC2 driver uses bus_to_virt

Syam Sidhardhan (1):
      staging: silicom: Remove redundant NULL check before kfree

Tony Luck (1):
      staging:iio:adt7316 Fix some 'interesting' string operations

Valentin Ilie (2):
      staging: speakup: selection.c fix typo in comment
      staging/fwserial: Replace seq_printf with seq_puts

Wanpeng Li (19):
      staging: zcache: introduce zero filled pages handler
      zram: fix zram_bvec_read duplicate dump failure message and stat accumulation
      staging: zcache: introduce zero-filled pages handler
      staging: zcache: zero-filled pages awareness
      staging: zcache: handle zcache_[eph|pers]_zpages for zero-filled page
      staging: zcache: fix pers_pageframes|_max aren't exported in debugfs
      staging: zcache: fix zcache writeback in debugfs
      staging: zcache: fix static variables defined in debug.h but used in mutiple C files
      staging: zcache: introduce zero-filled page stat count
      staging: zcache: clean TODO list
      staging: zcache: fix account foregin counters against zero-filled pages
      staging: ramster: Provide accessory functions for counter increase
      staging: ramster: Provide accessory functions for counter decrease
      staging: ramster: decrease foregin pers pages when count < 0
      staging: ramster: Move debugfs code out of ramster.c file
      staging: ramster/debug: Use an array to initialize/use debugfs attributes
      staging: ramster: Add incremental accessory counters
      staging: ramster/debug: Add CONFIG_RAMSTER_DEBUG Kconfig entry
      staging: zcache/debug: fix coding style

Wei Yongjun (6):
      staging: comedi: remove duplicated include from ni_pcimio.c
      staging: sync: fix return value check in sync_fence_alloc()
      Staging: netlogic: remove unused variable in xlr_net_start_xmit()
      staging: sep: fix possible memory leak in sep_prepare_input_dma_table()
      staging: nvec: fix the '&&' vs '&' typo in nvec_toggle_global_events()
      staging: dwc2: fix error return code in dwc2_hcd_init()

Xi Wang (1):
      Staging: bcm: avoid use-after-free in bcm_char_ioctl()

Zhang Yanfei (1):
      driver: staging: csr: remove cast for kmalloc return value

Ørjan Eide (1):
      staging: sync: Fix race condition between merge and signal

 .../devicetree/bindings/arm/atmel-adc.txt          |   13 +
 .../devicetree/bindings/arm/samsung/exynos-adc.txt |   60 +
 .../devicetree/bindings/iio/iio-bindings.txt       |   97 +
 Documentation/devicetree/bindings/staging/dwc2.txt |   15 +
 .../bindings/staging/imx-drm/fsl-imx-drm.txt       |    2 +-
 MAINTAINERS                                        |   12 +
 drivers/hwmon/Kconfig                              |    9 +
 drivers/hwmon/Makefile                             |    1 +
 drivers/{staging/iio => hwmon}/iio_hwmon.c         |    8 +-
 drivers/iio/accel/hid-sensor-accel-3d.c            |   24 +-
 drivers/iio/accel/kxsd9.c                          |    6 +-
 drivers/iio/accel/st_accel_buffer.c                |    2 +-
 drivers/iio/adc/Kconfig                            |   20 +
 drivers/iio/adc/Makefile                           |    2 +
 drivers/iio/adc/ad7266.c                           |   12 +-
 drivers/iio/adc/ad7298.c                           |   10 +-
 drivers/iio/adc/ad7476.c                           |   10 +-
 drivers/iio/adc/ad7887.c                           |    8 +-
 drivers/iio/adc/ad7923.c                           |  383 +
 drivers/iio/adc/ad_sigma_delta.c                   |    2 +-
 drivers/iio/adc/at91_adc.c                         |   98 +-
 drivers/iio/adc/exynos_adc.c                       |  452 ++
 drivers/iio/adc/lp8788_adc.c                       |    4 +-
 drivers/iio/adc/max1363.c                          |    9 +-
 drivers/iio/adc/ti-adc081c.c                       |    4 +-
 drivers/iio/adc/ti_am335x_adc.c                    |    2 +-
 drivers/iio/adc/viperboard_adc.c                   |    2 +-
 drivers/iio/amplifiers/ad8366.c                    |    2 +-
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |    4 +-
 drivers/iio/common/st_sensors/st_sensors_spi.c     |   11 +-
 drivers/iio/common/st_sensors/st_sensors_trigger.c |    2 +-
 drivers/iio/dac/ad5064.c                           |    4 +-
 drivers/iio/dac/ad5360.c                           |   10 +-
 drivers/iio/dac/ad5380.c                           |    8 +-
 drivers/iio/dac/ad5421.c                           |   10 +-
 drivers/iio/dac/ad5446.c                           |    4 +-
 drivers/iio/dac/ad5449.c                           |    4 +-
 drivers/iio/dac/ad5504.c                           |    4 +-
 drivers/iio/dac/ad5624r_spi.c                      |    4 +-
 drivers/iio/dac/ad5686.c                           |    6 +-
 drivers/iio/dac/ad5755.c                           |   10 +-
 drivers/iio/dac/ad5764.c                           |   10 +-
 drivers/iio/dac/ad5791.c                           |    6 +-
 drivers/iio/dac/max517.c                           |    4 +-
 drivers/iio/dac/mcp4725.c                          |    4 +-
 drivers/iio/frequency/ad9523.c                     |    8 +-
 drivers/iio/gyro/adis16080.c                       |   22 +-
 drivers/iio/gyro/adis16136.c                       |   13 +-
 drivers/iio/gyro/adxrs450.c                        |   22 +-
 drivers/iio/gyro/hid-sensor-gyro-3d.c              |   24 +-
 drivers/iio/gyro/itg3200_buffer.c                  |    4 +-
 drivers/iio/gyro/itg3200_core.c                    |   13 +-
 drivers/iio/gyro/st_gyro_buffer.c                  |    2 +-
 drivers/iio/iio_core.h                             |    1 +
 drivers/iio/imu/adis16400_core.c                   |   49 +-
 drivers/iio/imu/adis16480.c                        |   32 +-
 drivers/iio/imu/adis_trigger.c                     |    4 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |   10 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c         |    5 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c      |    4 +-
 drivers/iio/industrialio-core.c                    |   35 +-
 drivers/iio/industrialio-event.c                   |   29 +-
 drivers/iio/inkern.c                               |  171 +
 drivers/iio/light/adjd_s311.c                      |    4 +-
 drivers/iio/light/hid-sensor-als.c                 |    8 +-
 drivers/iio/light/lm3533-als.c                     |    6 +-
 drivers/iio/light/tsl2563.c                        |   10 +-
 drivers/iio/light/vcnl4000.c                       |    6 +-
 drivers/iio/magnetometer/Kconfig                   |   11 +
 drivers/iio/magnetometer/Makefile                  |    1 +
 drivers/{staging => }/iio/magnetometer/ak8975.c    |   73 +-
 drivers/iio/magnetometer/hid-sensor-magn-3d.c      |   24 +-
 drivers/staging/Kconfig                            |   10 +-
 drivers/staging/Makefile                           |    6 +-
 drivers/staging/android/Kconfig                    |   29 +-
 drivers/staging/android/Makefile                   |    2 +
 drivers/staging/android/ashmem.c                   |   66 +-
 drivers/staging/android/ashmem.h                   |    7 +
 drivers/staging/android/binder.c                   |  138 +-
 drivers/staging/android/binder.h                   |    8 +-
 drivers/staging/android/logger.c                   |  196 +-
 drivers/staging/android/logger.h                   |   40 +-
 drivers/staging/android/lowmemorykiller.c          |    9 +-
 drivers/staging/android/sw_sync.c                  |  264 +
 drivers/staging/android/sw_sync.h                  |   58 +
 drivers/staging/android/sync.c                     | 1017 +++
 drivers/staging/android/sync.h                     |  426 ++
 drivers/staging/android/trace/sync.h               |   82 +
 drivers/staging/bcm/Bcmchar.c                      |    2 +-
 drivers/staging/bcm/InterfaceDld.c                 |   32 +-
 drivers/staging/bcm/PHSModule.c                    | 1906 +++--
 drivers/staging/bcm/nvm.c                          |   14 +-
 drivers/staging/ccg/Kconfig                        |   25 -
 drivers/staging/ccg/Makefile                       |    2 -
 drivers/staging/ccg/TODO                           |    6 -
 drivers/staging/ccg/ccg.c                          | 1292 ----
 drivers/staging/ccg/composite.c                    | 1688 -----
 drivers/staging/ccg/composite.h                    |  395 -
 drivers/staging/ccg/config.c                       |  158 -
 drivers/staging/ccg/epautoconf.c                   |  393 -
 drivers/staging/ccg/f_acm.c                        |  814 --
 drivers/staging/ccg/f_fs.c                         | 2456 ------
 drivers/staging/ccg/f_mass_storage.c               | 3135 --------
 drivers/staging/ccg/f_rndis.c                      |  918 ---
 drivers/staging/ccg/gadget_chips.h                 |  150 -
 drivers/staging/ccg/ndis.h                         |   47 -
 drivers/staging/ccg/rndis.c                        | 1175 ---
 drivers/staging/ccg/rndis.h                        |  222 -
 drivers/staging/ccg/storage_common.c               |  893 ---
 drivers/staging/ccg/sysfs-class-ccg_usb            |  158 -
 drivers/staging/ccg/u_ether.c                      |  986 ---
 drivers/staging/ccg/u_ether.h                      |  154 -
 drivers/staging/ccg/u_serial.c                     | 1339 ----
 drivers/staging/ccg/u_serial.h                     |   65 -
 drivers/staging/ccg/usbstring.c                    |   71 -
 drivers/staging/comedi/Kconfig                     |   60 +-
 drivers/staging/comedi/comedi_buf.c                |   18 +-
 drivers/staging/comedi/comedi_fops.c               |  545 +-
 drivers/staging/comedi/comedi_internal.h           |    5 +-
 drivers/staging/comedi/comedi_pci.c                |   34 +-
 drivers/staging/comedi/comedidev.h                 |   31 +-
 drivers/staging/comedi/drivers.c                   |  182 +-
 drivers/staging/comedi/drivers/8255.c              |   23 +-
 drivers/staging/comedi/drivers/8255.h              |    1 -
 drivers/staging/comedi/drivers/8255_pci.c          |  210 +-
 drivers/staging/comedi/drivers/Makefile            |    9 +-
 drivers/staging/comedi/drivers/acl7225b.c          |  141 +-
 .../comedi/drivers/addi-data/APCI1710_Ssi.c        |    4 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |   34 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |    5 -
 drivers/staging/comedi/drivers/addi_apci_035.c     |   20 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c    |   15 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c    |   23 +-
 drivers/staging/comedi/drivers/addi_apci_1516.c    |   66 +-
 drivers/staging/comedi/drivers/addi_apci_1564.c    |   20 +-
 drivers/staging/comedi/drivers/addi_apci_16xx.c    |   69 +-
 drivers/staging/comedi/drivers/addi_apci_1710.c    |   64 +-
 drivers/staging/comedi/drivers/addi_apci_2032.c    |   18 +-
 drivers/staging/comedi/drivers/addi_apci_2200.c    |   18 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c    |   52 +-
 drivers/staging/comedi/drivers/addi_apci_3200.c    |   55 +-
 drivers/staging/comedi/drivers/addi_apci_3501.c    |   15 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |  300 +-
 drivers/staging/comedi/drivers/addi_watchdog.c     |    6 -
 drivers/staging/comedi/drivers/addi_watchdog.h     |    1 -
 drivers/staging/comedi/drivers/adl_pci6208.c       |   63 +-
 drivers/staging/comedi/drivers/adl_pci7x3x.c       |   95 +-
 drivers/staging/comedi/drivers/adl_pci8164.c       |  346 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |   64 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |   19 +-
 drivers/staging/comedi/drivers/adq12b.c            |   48 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |  142 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |   20 +-
 drivers/staging/comedi/drivers/adv_pci1724.c       |  409 +
 drivers/staging/comedi/drivers/adv_pci_dio.c       |  178 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |   22 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |   26 +-
 drivers/staging/comedi/drivers/am9513.h            |   79 -
 drivers/staging/comedi/drivers/amplc_dio200.c      | 1980 +----
 drivers/staging/comedi/drivers/amplc_dio200.h      |   95 +
 .../staging/comedi/drivers/amplc_dio200_common.c   | 1271 ++++
 drivers/staging/comedi/drivers/amplc_dio200_pci.c  |  486 ++
 drivers/staging/comedi/drivers/amplc_pc236.c       |   91 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |  303 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |   21 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |   26 +-
 drivers/staging/comedi/drivers/amplc_pci263.c      |  127 +
 drivers/staging/comedi/drivers/c6xdigio.c          |   39 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   98 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |  970 ++-
 drivers/staging/comedi/drivers/cb_pcidda.c         |   96 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |   16 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |   19 +-
 drivers/staging/comedi/drivers/comedi_fc.c         |    6 +-
 drivers/staging/comedi/drivers/comedi_parport.c    |   29 +-
 drivers/staging/comedi/drivers/comedi_test.c       |    2 -
 drivers/staging/comedi/drivers/contec_pci_dio.c    |   21 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |   40 +-
 drivers/staging/comedi/drivers/das08.c             |    3 +-
 drivers/staging/comedi/drivers/das08.h             |    1 -
 drivers/staging/comedi/drivers/das08_cs.c          |    1 -
 drivers/staging/comedi/drivers/das08_isa.c         |   14 +-
 drivers/staging/comedi/drivers/das08_pci.c         |   13 +-
 drivers/staging/comedi/drivers/das16.c             |   67 +-
 drivers/staging/comedi/drivers/das16m1.c           |   46 +-
 drivers/staging/comedi/drivers/das1800.c           |   92 +-
 drivers/staging/comedi/drivers/das6402.c           |   27 +-
 drivers/staging/comedi/drivers/das800.c            |  999 ++-
 drivers/staging/comedi/drivers/dmm32at.c           |   28 +-
 drivers/staging/comedi/drivers/dt2801.c            |   36 +-
 drivers/staging/comedi/drivers/dt2811.c            |   29 +-
 drivers/staging/comedi/drivers/dt2814.c            |   22 +-
 drivers/staging/comedi/drivers/dt2815.c            |   29 +-
 drivers/staging/comedi/drivers/dt2817.c            |   22 +-
 drivers/staging/comedi/drivers/dt282x.c            |   59 +-
 drivers/staging/comedi/drivers/dt3000.c            |  103 +-
 drivers/staging/comedi/drivers/dt9812.c            |   30 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |   15 +-
 drivers/staging/comedi/drivers/fl512.c             |   31 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |   30 +-
 drivers/staging/comedi/drivers/icp_multi.c         |   23 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |    4 -
 drivers/staging/comedi/drivers/jr3_pci.c           |   18 +-
 drivers/staging/comedi/drivers/ke_counter.c        |   21 +-
 drivers/staging/comedi/drivers/me4000.c            |  213 +-
 drivers/staging/comedi/drivers/me_daq.c            |   84 +-
 drivers/staging/comedi/drivers/mite.c              |   76 +-
 drivers/staging/comedi/drivers/mpc624.c            |   39 +-
 drivers/staging/comedi/drivers/multiq3.c           |   45 +-
 drivers/staging/comedi/drivers/ni_6527.c           |   82 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |  394 +-
 drivers/staging/comedi/drivers/ni_660x.c           |  144 +-
 drivers/staging/comedi/drivers/ni_670x.c           |   64 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |   47 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |   24 +-
 drivers/staging/comedi/drivers/ni_atmio.c          |   29 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |   30 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |    2 -
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |    5 +-
 drivers/staging/comedi/drivers/ni_labpc.c          | 2602 +++----
 drivers/staging/comedi/drivers/ni_labpc.h          |   30 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c       |    6 +-
 drivers/staging/comedi/drivers/ni_labpc_pci.c      |  142 +
 drivers/staging/comedi/drivers/ni_mio_common.c     |  355 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |   68 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         | 2056 +++--
 drivers/staging/comedi/drivers/ni_stc.h            |    4 -
 drivers/staging/comedi/drivers/pcl711.c            |   30 +-
 drivers/staging/comedi/drivers/pcl724.c            |   37 +-
 drivers/staging/comedi/drivers/pcl725.c            |   21 +-
 drivers/staging/comedi/drivers/pcl726.c            |   36 +-
 drivers/staging/comedi/drivers/pcl730.c            |   26 +-
 drivers/staging/comedi/drivers/pcl812.c            |   65 +-
 drivers/staging/comedi/drivers/pcl816.c            |  180 +-
 drivers/staging/comedi/drivers/pcl818.c            |  481 +-
 drivers/staging/comedi/drivers/pcm3724.c           |   31 +-
 drivers/staging/comedi/drivers/pcm3730.c           |   22 +-
 drivers/staging/comedi/drivers/pcmad.c             |   26 +-
 drivers/staging/comedi/drivers/pcmda12.c           |   26 +-
 drivers/staging/comedi/drivers/pcmmio.c            |   26 +-
 drivers/staging/comedi/drivers/pcmuio.c            |   26 +-
 drivers/staging/comedi/drivers/plx9052.h           |  106 +-
 drivers/staging/comedi/drivers/poc.c               |   34 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |    2 -
 drivers/staging/comedi/drivers/rtd520.c            |  716 +-
 drivers/staging/comedi/drivers/rtd520.h            |  381 -
 drivers/staging/comedi/drivers/rti800.c            |  575 +-
 drivers/staging/comedi/drivers/rti802.c            |   21 +-
 drivers/staging/comedi/drivers/s526.c              |   22 +-
 drivers/staging/comedi/drivers/s626.c              | 1209 ++-
 drivers/staging/comedi/drivers/s626.h              |  101 +-
 drivers/staging/comedi/drivers/serial2002.c        |  895 +--
 drivers/staging/comedi/drivers/skel.c              |  136 +-
 drivers/staging/comedi/drivers/ssv_dnp.c           |    2 -
 drivers/staging/comedi/drivers/unioxx5.c           |   64 +-
 drivers/staging/comedi/drivers/usbdux.c            |  408 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |    2 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |   12 +-
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |   12 +-
 drivers/staging/comedi/range.c                     |   22 +-
 drivers/staging/cptm1217/clearpad_tm1217.c         |   16 +-
 drivers/staging/csr/bh.c                           |    2 +-
 drivers/staging/csr/csr_log.h                      |    6 +-
 drivers/staging/csr/csr_sdio.h                     |   24 +-
 drivers/staging/csr/csr_time.c                     |    8 +-
 drivers/staging/csr/csr_wifi_fsm.h                 |    6 +-
 drivers/staging/csr/csr_wifi_hip_card_sdio.c       |    8 +-
 drivers/staging/csr/csr_wifi_hip_card_sdio_intr.c  |   10 +-
 drivers/staging/csr/csr_wifi_hip_chiphelper.h      |    4 +-
 drivers/staging/csr/csr_wifi_hip_unifi.h           |   20 +-
 drivers/staging/csr/drv.c                          |    4 +-
 drivers/staging/csr/netdev.c                       |    2 +-
 drivers/staging/csr/sdio_mmc.c                     |    3 +-
 drivers/staging/csr/sme_native.c                   |    2 +-
 drivers/staging/csr/sme_wext.c                     |    3 -
 drivers/staging/csr/unifi_pdu_processing.c         |   20 +-
 drivers/staging/csr/unifi_sme.c                    |    2 +
 drivers/staging/cxt1e1/pmcc4_drv.c                 |    1 +
 drivers/staging/dgrp/dgrp_common.h                 |    2 +-
 drivers/staging/dgrp/dgrp_dpa_ops.c                |    3 +-
 drivers/staging/dgrp/dgrp_driver.c                 |    6 +-
 drivers/staging/dgrp/dgrp_mon_ops.c                |    2 +-
 drivers/staging/dgrp/dgrp_net_ops.c                |    4 +-
 drivers/staging/dgrp/dgrp_ports_ops.c              |    2 +-
 drivers/staging/dgrp/dgrp_specproc.c               |    6 +-
 drivers/staging/dgrp/dgrp_sysfs.c                  |   30 +-
 drivers/staging/dwc2/Kconfig                       |   54 +
 drivers/staging/dwc2/Makefile                      |   25 +
 drivers/staging/dwc2/core.c                        | 2759 +++++++
 drivers/staging/dwc2/core.h                        |  662 ++
 drivers/staging/dwc2/core_intr.c                   |  505 ++
 drivers/staging/dwc2/hcd.c                         | 2981 ++++++++
 drivers/staging/dwc2/hcd.h                         |  765 ++
 drivers/staging/dwc2/hcd_ddma.c                    | 1196 +++
 drivers/staging/dwc2/hcd_intr.c                    | 2130 ++++++
 drivers/staging/dwc2/hcd_queue.c                   |  677 ++
 drivers/staging/dwc2/hw.h                          |  811 ++
 drivers/staging/dwc2/pci.c                         |  180 +
 drivers/staging/dwc2/platform.c                    |  145 +
 drivers/staging/et131x/et131x.c                    |    5 +-
 drivers/staging/fwserial/fwserial.c                |    6 +-
 drivers/staging/gdm72xx/gdm_qos.c                  |   47 +-
 drivers/staging/gdm72xx/gdm_sdio.c                 |    1 +
 drivers/staging/gdm72xx/netlink_k.c                |    1 +
 drivers/staging/gdm72xx/sdio_boot.c                |    1 +
 drivers/staging/iio/Documentation/trigger.txt      |    3 -
 drivers/staging/iio/Kconfig                        |    8 -
 drivers/staging/iio/Makefile                       |    2 -
 drivers/staging/iio/accel/adis16201_core.c         |    8 +-
 drivers/staging/iio/accel/adis16203_core.c         |    2 +-
 drivers/staging/iio/accel/adis16204_core.c         |    8 +-
 drivers/staging/iio/accel/adis16209_core.c         |    4 +-
 drivers/staging/iio/accel/adis16220_core.c         |   26 +-
 drivers/staging/iio/accel/adis16240_core.c         |    9 +-
 drivers/staging/iio/accel/lis3l02dq_core.c         |   11 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |    6 +-
 drivers/staging/iio/accel/sca3000_core.c           |    5 +-
 drivers/staging/iio/adc/Kconfig                    |    7 -
 drivers/staging/iio/adc/Makefile                   |    1 -
 drivers/staging/iio/adc/ad7280a.c                  |   12 +-
 drivers/staging/iio/adc/ad7291.c                   |   10 +-
 drivers/staging/iio/adc/ad7606_core.c              |    4 +-
 drivers/staging/iio/adc/ad799x.h                   |    7 +-
 drivers/staging/iio/adc/ad799x_core.c              |  417 +-
 drivers/staging/iio/adc/ad799x_ring.c              |   16 +-
 drivers/staging/iio/adc/adt7410.c                  | 1102 ---
 drivers/staging/iio/adc/lpc32xx_adc.c              |    2 +-
 drivers/staging/iio/adc/mxs-lradc.c                |   12 +-
 drivers/staging/iio/adc/spear_adc.c                |    4 +-
 drivers/staging/iio/addac/adt7316.c                |   26 +-
 drivers/staging/iio/cdc/ad7150.c                   |    8 +-
 drivers/staging/iio/cdc/ad7152.c                   |   32 +-
 drivers/staging/iio/cdc/ad7746.c                   |   48 +-
 drivers/staging/iio/gyro/adis16060_core.c          |   11 +-
 drivers/staging/iio/gyro/adis16130_core.c          |    4 +-
 drivers/staging/iio/gyro/adis16260_core.c          |    4 +-
 drivers/staging/iio/iio_simple_dummy.c             |   44 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |   10 +-
 drivers/staging/iio/light/isl29018.c               |    8 +-
 drivers/staging/iio/light/isl29028.c               |   10 +-
 drivers/staging/iio/light/tsl2x7x_core.c           |   40 +-
 drivers/staging/iio/magnetometer/Kconfig           |   11 -
 drivers/staging/iio/magnetometer/Makefile          |    1 -
 drivers/staging/iio/magnetometer/hmc5843.c         |    4 +-
 drivers/staging/iio/meter/ade7758_core.c           |   60 +-
 drivers/staging/iio/meter/ade7758_trigger.c        |    6 +-
 drivers/staging/iio/resolver/ad2s1200.c            |    4 +-
 drivers/staging/iio/resolver/ad2s1210.c            |    4 +-
 drivers/staging/iio/resolver/ad2s90.c              |    2 +-
 drivers/staging/iio/trigger/iio-trig-bfin-timer.c  |    8 +-
 drivers/staging/iio/trigger/iio-trig-gpio.c        |    6 +-
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |   12 +-
 drivers/staging/iio/trigger/iio-trig-sysfs.c       |    4 +-
 drivers/staging/imx-drm/Kconfig                    |    7 +
 drivers/staging/imx-drm/Makefile                   |    1 +
 drivers/staging/imx-drm/TODO                       |    3 +
 drivers/staging/imx-drm/imx-drm-core.c             |   15 +-
 drivers/staging/imx-drm/imx-drm.h                  |   14 +-
 drivers/staging/imx-drm/imx-tve.c                  |  755 ++
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h        |    6 +-
 drivers/staging/imx-drm/ipu-v3/ipu-common.c        |    3 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c            |   64 +-
 drivers/staging/imx-drm/ipu-v3/ipu-di.c            |  100 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c            |    1 -
 drivers/staging/imx-drm/ipuv3-crtc.c               |   11 +-
 drivers/staging/imx-drm/parallel-display.c         |   12 +
 drivers/staging/line6/pod.c                        |    3 +-
 .../staging/media/davinci_vpfe/davinci-vpfe-mc.txt |    2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |    6 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    8 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |    2 +-
 drivers/staging/net/Kconfig                        |   38 -
 drivers/staging/net/Makefile                       |    5 -
 drivers/staging/net/TODO                           |    5 -
 drivers/staging/net/pc300-falc-lh.h                | 1238 ---
 drivers/staging/net/pc300.h                        |  436 --
 drivers/staging/net/pc300_drv.c                    | 3670 ---------
 drivers/staging/net/pc300_tty.c                    | 1079 ---
 drivers/staging/netlogic/Kconfig                   |    7 +
 drivers/staging/netlogic/Makefile                  |    1 +
 drivers/staging/netlogic/TODO                      |   12 +
 drivers/staging/netlogic/platform_net.c            |  223 +
 drivers/staging/netlogic/platform_net.h            |   46 +
 drivers/staging/netlogic/xlr_net.c                 | 1114 +++
 drivers/staging/netlogic/xlr_net.h                 | 1099 +++
 drivers/staging/nvec/Kconfig                       |   10 +-
 drivers/staging/nvec/nvec.c                        |    8 +-
 drivers/staging/olpc_dcon/olpc_dcon.c              |    4 +-
 drivers/staging/omap-thermal/Makefile              |    5 -
 drivers/staging/omap-thermal/TODO                  |   28 -
 drivers/staging/omap-thermal/omap-bandgap.c        | 1174 ---
 drivers/staging/omap-thermal/omap-bandgap.h        |  432 --
 drivers/staging/omap-thermal/omap-thermal-common.c |  338 -
 drivers/staging/omap-thermal/omap5-thermal.c       |  297 -
 drivers/staging/ozwpan/ozcdev.c                    |    1 +
 drivers/staging/rtl8192u/r8192U_dm.h               |   77 +-
 drivers/staging/rtl8712/rtl8712_led.c              |    8 +-
 drivers/staging/rtl8712/rtl871x_recv.h             |  108 -
 drivers/staging/rts5139/rts51x_scsi.c              |    2 +-
 drivers/staging/rts5139/rts51x_scsi.h              |    1 -
 drivers/staging/rts5139/trace.h                    |   24 +-
 drivers/staging/sb105x/sb_mp_register.h            |    4 +-
 drivers/staging/sb105x/sb_pci_mp.c                 |    4 +-
 drivers/staging/sb105x/sb_pci_mp.h                 |    2 +-
 drivers/staging/sep/sep_crypto.c                   |    4 +-
 drivers/staging/sep/sep_driver_config.h            |    2 +-
 drivers/staging/sep/sep_main.c                     |    9 +-
 drivers/staging/sep/sep_trace_events.h             |   11 +-
 drivers/staging/silicom/bp_mod.c                   |   10 +-
 drivers/staging/silicom/bypasslib/bypass.c         |   94 +-
 drivers/staging/slicoss/slicoss.c                  |  133 +-
 drivers/staging/sm7xxfb/sm7xxfb.c                  |   10 +-
 drivers/staging/speakup/kobjects.c                 |    8 +-
 drivers/staging/speakup/main.c                     |    2 +-
 drivers/staging/speakup/selection.c                |    2 +-
 drivers/staging/speakup/speakup.h                  |    6 -
 drivers/staging/speakup/varhandlers.c              |   60 +-
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c      |    2 +-
 .../{omap-thermal => ti-soc-thermal}/Kconfig       |   22 +-
 drivers/staging/ti-soc-thermal/Makefile            |    5 +
 drivers/staging/ti-soc-thermal/TODO                |   12 +
 .../omap4-thermal-data.c}                          |   86 +-
 drivers/staging/ti-soc-thermal/omap4xxx-bandgap.h  |  175 +
 .../staging/ti-soc-thermal/omap5-thermal-data.c    |  359 +
 drivers/staging/ti-soc-thermal/omap5xxx-bandgap.h  |  200 +
 drivers/staging/ti-soc-thermal/ti-bandgap.c        | 1546 ++++
 drivers/staging/ti-soc-thermal/ti-bandgap.h        |  403 +
 drivers/staging/ti-soc-thermal/ti-thermal-common.c |  367 +
 .../omap-thermal.h => ti-soc-thermal/ti-thermal.h} |   61 +-
 .../ti_soc_thermal.txt}                            |   36 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |   12 +-
 drivers/staging/tidspbridge/rmgr/strm.c            |    6 +-
 drivers/staging/usbip/stub_dev.c                   |   38 +-
 drivers/staging/usbip/stub_main.c                  |   34 +-
 drivers/staging/usbip/stub_rx.c                    |  100 +-
 drivers/staging/usbip/usbip_common.c               |    2 +-
 drivers/staging/usbip/userspace/README             |    4 +-
 drivers/staging/usbip/userspace/doc/usbip.8        |    4 +-
 drivers/staging/usbip/userspace/libsrc/names.c     |  521 +-
 drivers/staging/usbip/userspace/libsrc/names.h     |   24 +-
 .../staging/usbip/userspace/libsrc/usbip_common.c  |   28 +-
 .../staging/usbip/userspace/libsrc/usbip_common.h  |   11 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |   40 +-
 drivers/staging/usbip/userspace/src/usbip_attach.c |   12 +-
 drivers/staging/usbip/userspace/src/usbip_detach.c |    2 +-
 drivers/staging/usbip/userspace/src/usbip_list.c   |   12 +
 .../staging/usbip/userspace/src/usbip_network.c    |    6 +-
 .../staging/usbip/userspace/src/usbip_network.h    |    4 +-
 drivers/staging/usbip/userspace/src/usbipd.c       |   15 +-
 drivers/staging/usbip/vhci.h                       |    1 -
 drivers/staging/usbip/vhci_hcd.c                   |    5 +-
 drivers/staging/usbip/vhci_rx.c                    |   56 +-
 drivers/staging/vme/devices/vme_user.c             |    4 +
 drivers/staging/vt6655/80211hdr.h                  |   71 +-
 drivers/staging/vt6655/80211mgr.c                  | 1166 ++-
 drivers/staging/vt6655/80211mgr.h                  |  698 +-
 drivers/staging/vt6655/IEEE11h.c                   |  115 +-
 drivers/staging/vt6655/IEEE11h.h                   |    6 +-
 drivers/staging/vt6655/aes_ccmp.c                  |  563 +-
 drivers/staging/vt6655/baseband.c                  | 4855 ++++++------
 drivers/staging/vt6655/baseband.h                  |   56 +-
 drivers/staging/vt6655/bssdb.c                     | 2665 ++++---
 drivers/staging/vt6655/bssdb.h                     |  411 +-
 drivers/staging/vt6655/card.c                      | 2842 ++++---
 drivers/staging/vt6655/card.h                      |  137 +-
 drivers/staging/vt6655/channel.c                   |  767 +-
 drivers/staging/vt6655/channel.h                   |   16 +-
 drivers/staging/vt6655/country.h                   |  238 +-
 drivers/staging/vt6655/datarate.c                  |  469 +-
 drivers/staging/vt6655/datarate.h                  |   49 +-
 drivers/staging/vt6655/desc.h                      |  504 +-
 drivers/staging/vt6655/device.h                    |  999 ++-
 drivers/staging/vt6655/device_cfg.h                |   31 +-
 drivers/staging/vt6655/device_main.c               | 4931 ++++++------
 drivers/staging/vt6655/dpc.c                       | 2425 +++---
 drivers/staging/vt6655/dpc.h                       |   11 +-
 drivers/staging/vt6655/hostap.c                    |  690 +-
 drivers/staging/vt6655/hostap.h                    |    4 -
 drivers/staging/vt6655/iocmd.h                     |  246 +-
 drivers/staging/vt6655/ioctl.c                     |   16 +-
 drivers/staging/vt6655/ioctl.h                     |   16 +-
 drivers/staging/vt6655/iowpa.h                     |   54 +-
 drivers/staging/vt6655/iwctl.c                     | 2213 +++---
 drivers/staging/vt6655/iwctl.h                     |  208 +-
 drivers/staging/vt6655/key.c                       | 1150 ++-
 drivers/staging/vt6655/key.h                       |  171 +-
 drivers/staging/vt6655/mac.c                       | 1657 ++--
 drivers/staging/vt6655/mac.h                       |  773 +-
 drivers/staging/vt6655/mib.c                       |  698 +-
 drivers/staging/vt6655/mib.h                       |  507 +-
 drivers/staging/vt6655/michael.c                   |  164 +-
 drivers/staging/vt6655/michael.h                   |    8 +-
 drivers/staging/vt6655/power.c                     |  484 +-
 drivers/staging/vt6655/power.h                     |   33 +-
 drivers/staging/vt6655/rc4.c                       |   78 +-
 drivers/staging/vt6655/rc4.h                       |    6 +-
 drivers/staging/vt6655/rf.c                        | 1480 ++--
 drivers/staging/vt6655/rf.h                        |   26 +-
 drivers/staging/vt6655/rxtx.c                      | 5545 +++++++-------
 drivers/staging/vt6655/rxtx.h                      |   56 +-
 drivers/staging/vt6655/srom.c                      |  269 +-
 drivers/staging/vt6655/srom.h                      |   60 +-
 drivers/staging/vt6655/tcrc.c                      |  163 +-
 drivers/staging/vt6655/tcrc.h                      |    3 -
 drivers/staging/vt6655/tether.c                    |   50 +-
 drivers/staging/vt6655/tether.h                    |   42 +-
 drivers/staging/vt6655/tkip.c                      |  331 +-
 drivers/staging/vt6655/tkip.h                      |   15 +-
 drivers/staging/vt6655/tmacro.h                    |    2 -
 drivers/staging/vt6655/ttype.h                     |   14 +-
 drivers/staging/vt6655/upc.h                       |  187 +-
 drivers/staging/vt6655/vntwifi.c                   |  925 ++-
 drivers/staging/vt6655/vntwifi.h                   |  278 +-
 drivers/staging/vt6655/wcmd.c                      | 1747 ++---
 drivers/staging/vt6655/wcmd.h                      |  118 +-
 drivers/staging/vt6655/wctl.c                      |  244 +-
 drivers/staging/vt6655/wctl.h                      |   76 +-
 drivers/staging/vt6655/wmgr.c                      | 8006 ++++++++++----------
 drivers/staging/vt6655/wmgr.h                      |  552 +-
 drivers/staging/vt6655/wpa.c                       |  340 +-
 drivers/staging/vt6655/wpa.h                       |   23 +-
 drivers/staging/vt6655/wpa2.c                      |  504 +-
 drivers/staging/vt6655/wpa2.h                      |   29 +-
 drivers/staging/vt6655/wpactl.c                    |  903 ++-
 drivers/staging/vt6655/wpactl.h                    |    8 +-
 drivers/staging/vt6655/wroute.c                    |  257 +-
 drivers/staging/vt6655/wroute.h                    |    5 +-
 drivers/staging/vt6656/80211hdr.h                  |  130 +-
 drivers/staging/vt6656/80211mgr.c                  |  224 +-
 drivers/staging/vt6656/80211mgr.h                  |  335 +-
 drivers/staging/vt6656/TODO                        |    2 +-
 drivers/staging/vt6656/aes_ccmp.c                  |  131 +-
 drivers/staging/vt6656/aes_ccmp.h                  |   13 +-
 drivers/staging/vt6656/baseband.c                  |  183 +-
 drivers/staging/vt6656/baseband.h                  |   23 +-
 drivers/staging/vt6656/bssdb.c                     |   70 +-
 drivers/staging/vt6656/bssdb.h                     |  124 +-
 drivers/staging/vt6656/card.c                      |  127 +-
 drivers/staging/vt6656/card.h                      |   18 +-
 drivers/staging/vt6656/channel.c                   |   53 +-
 drivers/staging/vt6656/channel.h                   |   14 +-
 drivers/staging/vt6656/control.c                   |   10 -
 drivers/staging/vt6656/control.h                   |   10 -
 drivers/staging/vt6656/country.h                   |    1 -
 drivers/staging/vt6656/datarate.c                  |   85 +-
 drivers/staging/vt6656/datarate.h                  |   27 +-
 drivers/staging/vt6656/desc.h                      |  230 +-
 drivers/staging/vt6656/device.h                    |   56 +-
 drivers/staging/vt6656/device_cfg.h                |    2 -
 drivers/staging/vt6656/dpc.c                       |  262 +-
 drivers/staging/vt6656/dpc.h                       |    9 -
 drivers/staging/vt6656/firmware.c                  |   17 +-
 drivers/staging/vt6656/firmware.h                  |    9 -
 drivers/staging/vt6656/hostap.c                    |   29 +-
 drivers/staging/vt6656/hostap.h                    |    9 -
 drivers/staging/vt6656/int.c                       |   27 +-
 drivers/staging/vt6656/int.h                       |   46 +-
 drivers/staging/vt6656/iocmd.h                     |   18 -
 drivers/staging/vt6656/iowpa.h                     |   13 -
 drivers/staging/vt6656/iwctl.c                     |   27 +-
 drivers/staging/vt6656/iwctl.h                     |    8 -
 drivers/staging/vt6656/key.c                       |  111 +-
 drivers/staging/vt6656/key.h                       |   43 +-
 drivers/staging/vt6656/mac.c                       |  132 +-
 drivers/staging/vt6656/mac.h                       |   19 -
 drivers/staging/vt6656/main_usb.c                  |   63 +-
 drivers/staging/vt6656/mib.c                       |  131 +-
 drivers/staging/vt6656/mib.h                       |  294 +-
 drivers/staging/vt6656/michael.c                   |   49 +-
 drivers/staging/vt6656/michael.h                   |   12 +-
 drivers/staging/vt6656/power.c                     |   13 +-
 drivers/staging/vt6656/power.h                     |   12 -
 drivers/staging/vt6656/rc4.c                       |   22 +-
 drivers/staging/vt6656/rc4.h                       |   10 +-
 drivers/staging/vt6656/rf.c                        |   49 +-
 drivers/staging/vt6656/rf.h                        |   10 -
 drivers/staging/vt6656/rndis.h                     |   90 +-
 drivers/staging/vt6656/rxtx.c                      |  610 +-
 drivers/staging/vt6656/rxtx.h                      |  691 +-
 drivers/staging/vt6656/srom.h                      |   71 +-
 drivers/staging/vt6656/tcrc.c                      |   28 +-
 drivers/staging/vt6656/tcrc.h                      |   20 +-
 drivers/staging/vt6656/tether.c                    |   53 +-
 drivers/staging/vt6656/tether.h                    |   61 +-
 drivers/staging/vt6656/tkip.c                      |   37 +-
 drivers/staging/vt6656/tkip.h                      |   22 +-
 drivers/staging/vt6656/tmacro.h                    |   14 +-
 drivers/staging/vt6656/ttype.h                     |   55 -
 drivers/staging/vt6656/usbpipe.c                   |   29 -
 drivers/staging/vt6656/usbpipe.h                   |    9 -
 drivers/staging/vt6656/wcmd.c                      |   63 +-
 drivers/staging/vt6656/wcmd.h                      |   18 +-
 drivers/staging/vt6656/wctl.c                      |   56 +-
 drivers/staging/vt6656/wctl.h                      |   49 +-
 drivers/staging/vt6656/wmgr.c                      |  228 +-
 drivers/staging/vt6656/wmgr.h                      |   35 -
 drivers/staging/vt6656/wpa.c                       |   32 +-
 drivers/staging/vt6656/wpa.h                       |   16 +-
 drivers/staging/vt6656/wpa2.c                      |  165 +-
 drivers/staging/vt6656/wpa2.h                      |   17 +-
 drivers/staging/vt6656/wpactl.c                    |   33 +-
 drivers/staging/vt6656/wpactl.h                    |   10 -
 drivers/staging/wlan-ng/prism2sta.c                |   51 +-
 drivers/staging/wlan-ng/prism2usb.c                |   12 +-
 drivers/staging/xgifb/vb_def.h                     |    4 -
 drivers/staging/xgifb/vb_init.c                    |   64 +-
 drivers/staging/xgifb/vb_setmode.c                 |    4 +-
 drivers/staging/xgifb/vb_struct.h                  |   16 +-
 drivers/staging/xgifb/vb_table.h                   |   98 +-
 drivers/staging/zcache/Kconfig                     |   16 +
 drivers/staging/zcache/Makefile                    |    2 +
 drivers/staging/zcache/TODO                        |    9 +-
 drivers/staging/zcache/debug.c                     |  107 +
 drivers/staging/zcache/debug.h                     |  305 +
 drivers/staging/zcache/ramster/debug.c             |   66 +
 drivers/staging/zcache/ramster/debug.h             |  145 +
 drivers/staging/zcache/ramster/ramster.c           |  141 +-
 drivers/staging/zcache/zbud.c                      |    7 +-
 drivers/staging/zcache/zcache-main.c               |  526 +-
 drivers/staging/zram/zram_drv.c                    |    5 +-
 drivers/staging/zsmalloc/Kconfig                   |    2 +-
 drivers/staging/zsmalloc/zsmalloc-main.c           |    7 +-
 include/linux/iio/adc/ad_sigma_delta.h             |    6 +-
 include/linux/iio/common/st_sensors.h              |    5 +-
 include/linux/iio/iio.h                            |   79 +-
 include/linux/iio/imu/adis.h                       |   34 +-
 include/linux/iio/trigger.h                        |   26 +-
 627 files changed, 65145 insertions(+), 76321 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
 create mode 100644 Documentation/devicetree/bindings/iio/iio-bindings.txt
 create mode 100644 Documentation/devicetree/bindings/staging/dwc2.txt
 rename drivers/{staging/iio => hwmon}/iio_hwmon.c (96%)
 create mode 100644 drivers/iio/adc/ad7923.c
 create mode 100644 drivers/iio/adc/exynos_adc.c
 rename drivers/{staging => }/iio/magnetometer/ak8975.c (89%)
 create mode 100644 drivers/staging/android/sw_sync.c
 create mode 100644 drivers/staging/android/sw_sync.h
 create mode 100644 drivers/staging/android/sync.c
 create mode 100644 drivers/staging/android/sync.h
 create mode 100644 drivers/staging/android/trace/sync.h
 delete mode 100644 drivers/staging/ccg/Kconfig
 delete mode 100644 drivers/staging/ccg/Makefile
 delete mode 100644 drivers/staging/ccg/TODO
 delete mode 100644 drivers/staging/ccg/ccg.c
 delete mode 100644 drivers/staging/ccg/composite.c
 delete mode 100644 drivers/staging/ccg/composite.h
 delete mode 100644 drivers/staging/ccg/config.c
 delete mode 100644 drivers/staging/ccg/epautoconf.c
 delete mode 100644 drivers/staging/ccg/f_acm.c
 delete mode 100644 drivers/staging/ccg/f_fs.c
 delete mode 100644 drivers/staging/ccg/f_mass_storage.c
 delete mode 100644 drivers/staging/ccg/f_rndis.c
 delete mode 100644 drivers/staging/ccg/gadget_chips.h
 delete mode 100644 drivers/staging/ccg/ndis.h
 delete mode 100644 drivers/staging/ccg/rndis.c
 delete mode 100644 drivers/staging/ccg/rndis.h
 delete mode 100644 drivers/staging/ccg/storage_common.c
 delete mode 100644 drivers/staging/ccg/sysfs-class-ccg_usb
 delete mode 100644 drivers/staging/ccg/u_ether.c
 delete mode 100644 drivers/staging/ccg/u_ether.h
 delete mode 100644 drivers/staging/ccg/u_serial.c
 delete mode 100644 drivers/staging/ccg/u_serial.h
 delete mode 100644 drivers/staging/ccg/usbstring.c
 create mode 100644 drivers/staging/comedi/drivers/adv_pci1724.c
 delete mode 100644 drivers/staging/comedi/drivers/am9513.h
 create mode 100644 drivers/staging/comedi/drivers/amplc_dio200.h
 create mode 100644 drivers/staging/comedi/drivers/amplc_dio200_common.c
 create mode 100644 drivers/staging/comedi/drivers/amplc_dio200_pci.c
 create mode 100644 drivers/staging/comedi/drivers/amplc_pci263.c
 create mode 100644 drivers/staging/comedi/drivers/ni_labpc_pci.c
 delete mode 100644 drivers/staging/comedi/drivers/rtd520.h
 create mode 100644 drivers/staging/dwc2/Kconfig
 create mode 100644 drivers/staging/dwc2/Makefile
 create mode 100644 drivers/staging/dwc2/core.c
 create mode 100644 drivers/staging/dwc2/core.h
 create mode 100644 drivers/staging/dwc2/core_intr.c
 create mode 100644 drivers/staging/dwc2/hcd.c
 create mode 100644 drivers/staging/dwc2/hcd.h
 create mode 100644 drivers/staging/dwc2/hcd_ddma.c
 create mode 100644 drivers/staging/dwc2/hcd_intr.c
 create mode 100644 drivers/staging/dwc2/hcd_queue.c
 create mode 100644 drivers/staging/dwc2/hw.h
 create mode 100644 drivers/staging/dwc2/pci.c
 create mode 100644 drivers/staging/dwc2/platform.c
 delete mode 100644 drivers/staging/iio/adc/adt7410.c
 create mode 100644 drivers/staging/imx-drm/imx-tve.c
 delete mode 100644 drivers/staging/net/Kconfig
 delete mode 100644 drivers/staging/net/Makefile
 delete mode 100644 drivers/staging/net/TODO
 delete mode 100644 drivers/staging/net/pc300-falc-lh.h
 delete mode 100644 drivers/staging/net/pc300.h
 delete mode 100644 drivers/staging/net/pc300_drv.c
 delete mode 100644 drivers/staging/net/pc300_tty.c
 create mode 100644 drivers/staging/netlogic/Kconfig
 create mode 100644 drivers/staging/netlogic/Makefile
 create mode 100644 drivers/staging/netlogic/TODO
 create mode 100644 drivers/staging/netlogic/platform_net.c
 create mode 100644 drivers/staging/netlogic/platform_net.h
 create mode 100644 drivers/staging/netlogic/xlr_net.c
 create mode 100644 drivers/staging/netlogic/xlr_net.h
 delete mode 100644 drivers/staging/omap-thermal/Makefile
 delete mode 100644 drivers/staging/omap-thermal/TODO
 delete mode 100644 drivers/staging/omap-thermal/omap-bandgap.c
 delete mode 100644 drivers/staging/omap-thermal/omap-bandgap.h
 delete mode 100644 drivers/staging/omap-thermal/omap-thermal-common.c
 delete mode 100644 drivers/staging/omap-thermal/omap5-thermal.c
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/Kconfig (70%)
 create mode 100644 drivers/staging/ti-soc-thermal/Makefile
 create mode 100644 drivers/staging/ti-soc-thermal/TODO
 rename drivers/staging/{omap-thermal/omap4-thermal.c => ti-soc-thermal/omap4-thermal-data.c} (82%)
 create mode 100644 drivers/staging/ti-soc-thermal/omap4xxx-bandgap.h
 create mode 100644 drivers/staging/ti-soc-thermal/omap5-thermal-data.c
 create mode 100644 drivers/staging/ti-soc-thermal/omap5xxx-bandgap.h
 create mode 100644 drivers/staging/ti-soc-thermal/ti-bandgap.c
 create mode 100644 drivers/staging/ti-soc-thermal/ti-bandgap.h
 create mode 100644 drivers/staging/ti-soc-thermal/ti-thermal-common.c
 rename drivers/staging/{omap-thermal/omap-thermal.h => ti-soc-thermal/ti-thermal.h} (55%)
 rename drivers/staging/{omap-thermal/omap_bandgap.txt => ti-soc-thermal/ti_soc_thermal.txt} (50%)
 delete mode 100644 drivers/staging/vt6656/ttype.h
 create mode 100644 drivers/staging/zcache/debug.c
 create mode 100644 drivers/staging/zcache/debug.h
 create mode 100644 drivers/staging/zcache/ramster/debug.c
 create mode 100644 drivers/staging/zcache/ramster/debug.h
