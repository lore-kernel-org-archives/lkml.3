Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab3KFW5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:57:36 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45542 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab3KFW5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:57:20 -0500
Date: Wed, 6 Nov 2013 14:52:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver patches for 3.13-rc1
Message-ID: <20131106225209.GA8450@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 31d141e3a666269a3b6fcccddb0351caf7454240:

  Linux 3.12-rc6 (2013-10-19 12:28:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.13-rc1

for you to fetch changes up to ed5d6ca0038f274aada1244358ad89b7941bdcbf:

  staging: drm/imx: fix return value check in ipu_add_subdevice_pdata() (2013-10-30 10:17:33 -0700)

----------------------------------------------------------------
Staging driver update for 3.13-rc1

Here's the big drivers/staging/ update for 3.13-rc1.

Nothing major here, just a _ton_ of fixes and cleanups, mostly driven by
the new round of OPW applicants, but also there are lots of other people
doing staging tree cleanups these days in order to help get the drivers
into mergable shape.

We also merge, and then revert, the ktap code, as Ingo and the other
perf/ftrace developers feel it should go into the "real" part of the
kernel with only a bit more work, so no need to put it in staging for
now.

All of this has been in linux-next for a while with no reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (38):
      staging: octeon-usb: delete redundant flags from cvmx_usb_initialize()
      staging: octeon-usb: delete cvmx_usb_isochronous_flags
      staging: octeon-usb: delete redundant flags from __cvmx_usb_submit_transaction()
      staging: octeon-usb: delete redundant flags from cvmx_usb_open_pipe()
      staging: octeon-usb: replace CVMX_CLZ with __fls()
      staging: octeon-usb: inline CVMX_PREFETCH0
      staging: octeon-usb: delete CVMX_PREFETCH128
      staging: octeon-usb: eliminate CVMX_PREFETCH_PREF0
      staging: octeon-usb: eliminate CVMX_PREFETCH_PREFX
      staging: octeon-usb: cvmx-usb: delete unused macros
      staging: octeon-usb: cvmx-usb.c: make comments to fit into 80 columns
      staging: octeon-usb: cvmx-usb.h: make comments to fit into 80 columns
      staging: octeon-usb: merge cvmx-usb into octeon-hcd
      staging: octeon-usb: eliminate cvmx_usb_internal_state
      staging: octeon-usb: inline cvmx_usb_set_status
      staging: octeon-usb: call port change callback directly
      staging: octeon-usb: call transfer completion callback directly
      staging: octeon-usb: replace generic transfer callback data with urb
      staging: octeon-usb: cvmx_usb_submit_bulk: get params from urb
      staging: octeon-usb: cvmx_usb_submit_control: get params from urb
      staging: octeon-usb: cvmx_usb_submit_interrupt: get params from urb
      staging: octeon-usb: cvmx_usb_submit_control: get params from urb
      staging: octeon-usb: clean up hcpriv usage
      staging: octeon-usb: eliminate pipe_handle
      staging: octeon-usb: eliminate submit_handle
      staging: octeon-usb: refactor __cvmx_usb_pipe_needs_split
      staging: octeon-ethernet: allow to set IRQ smp_affinity freely
      staging: octeon-ethernet: allow to use only 1 CPU for packet processing
      staging: octeon-usb: delete unused cvmx_usbnx_usbp_ctl_status definitions
      staging: octeon-usb: delete cvmx_usbnx_clk_ctl_cn50xx
      staging: octeon-usb: CN3xxx: program p_xenbn and p_rclk through p_rtype
      staging: octeon-usb: use a single .h file
      staging: octeon-usb: use dynamic allocation for transactions
      staging: octeon-usb: use dynamic allocation for pipes
      staging: octeon-usb: use list_del_init()
      staging: octeon-usb: use list_for_each_entry_safe()
      staging: octeon-usb: use list.h for pipes
      staging: octeon-usb: use list.h for transactions

Adam Rall (1):
      Staging: rtl8187se: fixed coding style issues

Aida Mynzhasova (1):
      iio: dac: ad5446: Add support for AD5641

Aldo Iljazi (2):
      Staging: bcm: nvm: fixed space prohibition
      Staging: ft1000: fixed two coding style issues

Alexey Khoroshilov (2):
      staging: gdm7240: alloc_mux_rx() does not need GFP_ATOMIC
      staging: gdm7240: fix memory leak on failure path

Andy Shevchenko (2):
      staging: silicom: introduce bp_dev_get_idx_bsf() and use it
      staging: rtl8712: re-use native mac_pton() helper

Angelo Compagnucci (1):
      iio: adc: Add driver for Microchip MCP3422/3/4 high resolution ADC

Archana kumari (15):
      Staging:cxt1e1: Fixes whitespace around commas in sbew_ioc.h
      staging:media:lirc: quoted string split across lines
      staging:netlogic:Fixes commenting style in xlr_net.c
      staging:dgnc:Fixes use of deprecated headers in dgnc_cls.c
      staging: vt6655: Fix Sparse Warning for Static Declarations
      staging: dgnc: braces {} are not necessary for single statement in dgnc_cls.c
      staging: vt6655:removed incorrect casting in hostap.c
      staging: wlags49_h2: fixed space prohibited warnings in hcf.h
      staging: wlags49_h2: Fixes the sparse warning in sta_h2.c
      staging: dgnc:Removed unecessary error messages in dgnc_driver.c
      staging: dgnc: braces {} are not necessary for single statement in dgnc_driver.c
      staging: vt6655: Fix C99 commenting style in michael.h
      staging: media: lirc: Replaced printk macro with dev_info(dev,....) in lirc_imon.c
      staging: vt6655: fixed use of unnecessary braces in baseband.c
      staging: rts5139: Replaced min() with min_t() in

Ashvini Varatharaj (16):
      Staging: xgifb: remove space before semicolon
      Staging: cxt1e1: moving { to the previous line
      Staging: cxt1e1: remove space between function name and '('
      Staging: rtl8192e: Replacing (u8*) with (u8 *)
      Staging: vt6656: adding spaces around '='
      Staging: wlan-ng: changing "* dev" to "*dev"
      Staging: sb105x: Removing trailing whitespaces
      Staging: speakup: removing jiffies comparison using time_after_eq()
      Staging: speakup: removing jiffies comparison in speakup_apollo.c
      Staging: dgnc: removing the comparison 'board<0'
      Staging: dgnc: avoiding buffer overflow
      Staging: speakup: replacing simple_strtoul with kstrtoul
      Staging: line6: replacing -EINVAL with retval
      Staging: line6: replacing -EINVAL with retval in driver.c
      Staging: winbond: removing CamelCase in core.h
      Staging: winbond: removing unused variables thread_count and link_name[]

Avinash Kumar (3):
      staging: bcm: InterfaceMisc.c: fixed styling issue in casting (foo*)->(foo *)
      staging: wlan-ng: hfa384x_usb.c: replaced printk() debugs with netdev_warn()/netdev_err()
      staging: wlan-ng: cfg80211.c: replaced printk() with netdev_warn()

Avinash kumar (1):
      drivers: staging: netlogic.h: removed WARNING: extern prototypes should be avoided in .h files

Baruch Siach (1):
      staging: xillybus: remove redundant Kconfig dependency

Ben Hutchings (1):
      Staging: speakup: Add dependencies for ISA card drivers

Beomho Seo (2):
      iio: cm36651: Add CM36651 proximity/light sensor
      DT: Add documentation for cm36651 proximity/light sensor

Bojan Prtvar (3):
      Staging: android: add __user annotation in binder.c
      Staging: android: Mark local functions in binder.c as static
      Staging: android: Remove extern from function prototypes in .h files

Chen Gang (3):
      drivers: staging: android: Kconfig: add depends on MMU for ANDROID_BINDER_IPC
      drivers: staging: dgap: move DG_NAME and DG_PART from "Makefile" to "dgap_driver.h"
      drivers: staging: rtl8188eu: use 'ccflags-y' instead of EXTRA_CFLAGS in Makefile

Christopher Brannon (1):
      staging: speakup: kobjects.c: Use correct values when changing voice.

Chuong Ngo (1):
      drivers: staging: bcm: Removed a developer debug statement.

Cruz Julian Bishop (4):
      staging/android: Persistent formatting of help Kconfig entries
      staging/android: Initial partial kernel-doc for ashmem.c
      staging/android: Add some more kerneldoc to ashmem.c
      staging/android: Add kerneldoc to one function in alarm-dev.c

Dan Carpenter (1):
      staging: rtl8712: remove unneeded NULL check

Denis CIOCCA (6):
      iio:accel: Register buffer also without specific trigger
      iio:gyro: Register buffer also without specific trigger
      iio:magn: Register buffer also without specific trigger
      iio:press: Register buffer also without specific trigger
      iio:trigger: fix sysfs name on list mutex
      iio:pressure: Adds LPS001WP support also on spi interface and Kconfig fix

Dom Cobley (1):
      staging: dwc2: add microframe scheduler from downstream Pi kernel

Dominik Paulus (2):
      staging: usbip: Fix build with --with-tcp-wrappers
      staging: usbip: Fix IPv6 support in usbipd

Dulshani Gunawardhana (16):
      staging/cxt1e1:Fixes suspect code indent warning
      staging/media/go7007:Replace kern_debug with pr_debug
      staging:go7007:Remove driver-specific debugging defines in favor of pr_debug
      staging:go7007:Replace KERN_ERR with pr_err
      staging:go7007 : Replace KERN_INFO with pr_info
      staging:go7007:Fix line over 80 character warning
      staging:go7007:Fix warning on quoted string on multiple lines
      staging:lustre: Remove space between function name and open parenthesis
      staging:lustre: Fix C99 style comments
      staging:lustre: Replace max() with max_t()
      staging:lustre: Fix space before open parenthesis
      staging:lustre: Fix externs should be avoided in .c files warning
      staging:lustre: replace foo* with foo *
      staging: media: Use dev_err() instead of pr_err()
      staging:media: Use dev_info() instead of pr_info()
      staging:media: Use dev_dbg() instead of pr_debug()

Ebru Akagunduz (40):
      Staging: tidspbridge: fix no space before tabs
      Staging: keucr: fix quoted string split across lines
      Staging: xillybus: quoted strings split across lines
      Staging: iio: iio_simple_dummy: fix line over 80 characters
      Staging: iio: space prohibited before semicolon
      Staging: iio: printk(KERN_INFO ...
      Staging: iio: adt7316-spi: fix quoted string split across lines
      Staging: iio: adt7316-i2c: quoted string split across lines
      Staging: xgifb: braces {} are not necessary for single statement in vb_setmode
      Staging: bcm: line over 80 characters in Bcmnet.c
      Staging: gdm724x: fix line over 80 characters in gdm_tty.c
      Staging: iio: fix sizeof *ring should be sizeof(*ring)
      Staging: wlan-ng: fix printk(KERN_DEBUG in p80211wep.c
      Staging: lustre: fix ERROR: do not initialise statics to 0 or NULL in module.c
      Staging: lustre: fix space prohibited between function name and open parenthesis '(' in module.c
      Staging: lustre: fix space prohibited between function name and open parenthesis '(' in lo.c
      Staging: lustre: fix return is not a function, parentheses are not required in lo.c
      Staging: rtl8187se: fix avoid unnecessary line continuations in r8185b_init.c
      Staging: rtl8187se: suspect code indent for conditional statements in r8185b_init.c
      Staging: octeon: quoted string split across lines in ethernet-spi.c
      Staging: octeon: fix quoted string split across lines in ethernet-tx.c
      Staging: octeon: fix line over 80 characters in ethernet-tx.c
      Staging: sm7xxfb: fix line over 80 characters in sm7xxfb.c
      Staging: ft1000: Fix Sparse Warning for Static Declarations in ft1000_hw.c
      Staging: ft1000: Fix Sparse Warning for Static Declarations in boot.h
      Staging: ft1000: remove unnecessary static function declarations in ft1000_hw.c
      Staging: vt6655: Fix Sparse Warning for Static Declarations in tkip.c
      Staging: vt6655: Fix Sparse Warning for Static Declarations in wpa.c
      Staging: iio: fix printk(KERN_ERR .. in lis3l02dq_core.c
      Staging: vt6656: Fix Sparse Warning: cast from restricted gfp_t in hostap.c
      Staging:line6: fix line over 80 characters
      Staging: rtl8187se: fix line over 80 characters in r8185b_init.c
      Staging: winbond: Fix Sparse Warnings in phy_calibration.c
      Staging: winbond: Fix Sparse Warnings in reg.c
      Staging: xgifb: fix braces {} are not necessary for any arm of this statement
      Staging: rtl8187se: fix please, no space before tabs in r8185b_init.c
      Staging: rtl8187se: fix trailing whitespace in r8185b_init.c
      Staging: rtl8187se: fix braces {} are not necessary for single statement blocks in r8185b_init.c
      Staging: rtl8187se: fix space prohibited after that open parenthesis '(' in r8185b_init.c
      Staging: rtl8187se: space prohibited before semicolon in r8185b_init.c

Elad Wexler (1):
      Staging: usbip: stub_dev: Fixed checkpatch warnings

Eli Billauer (4):
      staging: xillybus: Remember device pointer for use with dev_* functions
      staging: xillybus: Use dev_* functions instead of pr_* in xillybus_pcie
      staging: xillybus: Use dev_* functions instead of pr_* in xillybus_of
      staging: xillybus: Use dev_* functions instead of pr_* in xillybus_core

Fabio Estevam (5):
      iio: mxs-lradc: Fix the order of resources removal
      iio: mxs-lradc: Add MODULE_ALIAS
      staging: imx-drm: imx-ldb: Staticize of_get_data_mapping()
      imx-drm: imx-drm-core: Fix circular locking dependency
      imx-drm: ipuv3-crtc: Invert IPU DI0 clock polarity

Faris de Haan (2):
      Staging: rtl8188eu: checkpatch.pl warnings removed
      Staging: rtl8188eu: rtw_wlan_util.c: Fixed checkpatch.pl warnings.

Fengguang Wu (1):
      staging/lustre: fix coccinelle warnings

Greg Kroah-Hartman (14):
      Merge tag 'iio-for-3.13a' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.12-rc2 into staging-next.
      Merge tag 'iio-for-3.13b' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.12-rc3 into staging-next
      staging: lustre: remove ll_mrf_ret
      staging: lustre: fix bug with LL_MRF_RETURN in loop_make_request
      Merge tag 'iio-for-3.13c' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.12-rc4 into staging-next
      Revert "staging:media:lirc: quoted string split across lines"
      Revert "staging/olpc: fix dependencies to fix build errors"
      Merge tag 'iio-for-3.12d' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.12-rc6 into staging-next.
      Merge tag 'iio-for-3.13e' of git://git.kernel.org/.../jic23/iio into staging-next
      staging: ktap: remove code from tree

H Hartley Sweeten (143):
      staging: comedi: pcmad: use comedi_range_is_bipolar()
      staging: comedi: ni_labpc: use comedi_range_is_unipolar()
      staging: comedi: initialize subdevice s->io_bits in postconfig
      staging: comedi: drivers: introduce comedi_dio_update_state()
      staging: comedi: skel: use comedi_dio_update_state()
      staging: comedi: usbdux drivers: use comedi_dio_update_state()
      staging: comedi: drivers: use comedi_dio_update_state() for simple cases
      staging: comedi: drivers: use comedi_dio_update_state() for complex cases
      staging: comedi: ni_mio_common: use comedi_dio_update_state()
      staging: comedi: vmk80xx: use comedi_dio_update_state()
      staging: comedi: das08: remove do_bits from private data
      staging: comedi: das08: use s->state in das08_do_wbits()
      staging: comedi: das1800: remove do_bits from private data
      staging: comedi: das16m1: remove do_bits from private data
      staging: comedi: adq12b: remove digital_state from private data
      staging: comedi: ssv_dnp: use comedi_dio_update_state()
      staging: comedi: hwdrv_apci3120: use comedi_dio_update_state()
      staging: comedi: addi_apci_16xx: use comedi_dio_update_state()
      staging: comedi: addi_apci_3xxx: use comedi_dio_update_state()
      staging: comedi: ii_pci20kc: use comedi_dio_update_state()
      staging: comedi: me4000: use comedi_dio_update_state()
      staging: comedi: me_daq: use comedi_dio_update_state()
      staging: comedi: s626: use comedi_dio_update_state()
      staging: comedi: comedi_parport: tidy up the register map
      staging: comedi: comedi_parport: remove 'a_data' from private data
      staging: comedi: comedi_parport: tidy up parport_insn_a()
      staging: comedi: comedi_parport: fix parport_insn_config_a()
      staging: comedi: comedi_parport: tidy up parport_insn_b()
      staging: comedi: comedi_parport: tidy up parport_insn_c()
      staging: comedi: comedi_parport: remove 'c_data' from private data
      staging: comedi: comedi_parport: remove 'enable_irq' from private data
      staging: comedi: comedi_parport: don't fail attach if irq is not available
      staging: comedi: comedi_parport: tidy up parport_attach()
      staging: comedi: comedi_parport: tidy up multi-line comments
      staging: comedi: comedi_parport: reorder #include's
      staging: comedi: comedi_parport: rename parport_intr_insn()
      staging: comedi: comedi_parport: use dev->read_subdev in interrupt handler
      staging: comedi: comedi_parport: change MODULE_DESCRIPTION
      staging: comedi: adl_pci6208: save raw data for analog output readback
      staging: comedi: adl_pci6208: don't deadlock while waiting to write ao data
      staging: comedi: core: introduce comedi_offset_munge()
      staging: comedi: adl_pci6208: use comedi_offset_munge()
      staging: comedi: adl_pci6208: tidy up pci6208_ao_winsn()
      staging: comedi: adl_pci6208: tidy up pci6208_ao_rinsn()
      staging: comedi: adl_pci6208: remove board attach noise
      staging: comedi: adl_pci6208: tidy up multi-line comments
      staging: comedi: adl_pci6208: change MODULE_DESCRIPTION
      staging: comedi: pcl711: convert boardinfo declaration to C99 format
      staging: comedi: pcl711: remove all '= 0' boardinfo
      staging: comedi: pcl711: remove unused boardinfo
      staging: comedi: pcl711: convert boardinfo flags to bit-fields
      staging: comedi: pcl711: tidy up the comedi_lrange tables
      staging: comedi: pcl711: don't fail attach if irq is unavailable
      staging: comedi: pcl711: remove PCL711_SIZE
      staging: comedi: pcl711: tidy up the subdevice init
      staging: comedi: pcl711: save the irq for the pcl711b only when used
      staging: comedi: pcl711: tidy up the register map defines
      staging: comedi: pcl711: tidy up pcl711_ao_insn()
      staging: comedi: pcl711: tidy up pcl711_ao_insn_read()
      staging: comedi: pcl711: introduce pcl711_ai_get_sample()
      staging: comedi: pcl711: use dev->read_subdev in interrupt handler
      staging: comedi: pcl711: factor out the ai end-of-conversion wait
      staging: comedi: pcl711: fix pcl711_set_changain()
      staging: comedi: pcl711: add differential input support for 8112 boards
      staging: comedi: pcl711: define the mode register magic numbers
      staging: comedi: pcl711: remove unnecessary test of 'board->is_8112'
      staging: comedi: pcl711: fix software trigger for board->is_8112
      staging: comedi: pcl711: tidy up pcl711_ai_insn()
      staging: comedi: pcl711: remove 'is_8112' from boardinfo
      staging: comedi: pcl711: remove 'is_pcl711b' from boardinfo
      staging: comedi: pcl711: remove unused private data members
      staging: comedi: pcl711: use 8253.h helper to set the timers
      staging: comedi: pcl711: remove 'i8253_osc_base'
      staging: comedi: pcl711: no need to calc the timer values twice
      staging: comedi: pcl711: rename some of the register map defines
      staging: comedi: pcl711: tidy up multi line comments
      staging: comedi: pcl711: reorder includes
      staging: comedi: pcl711: change MODULE_DESCRIPTION
      staging: comedi: pcl726: convert boardinfo declaration to C99 format
      staging: comedi: core: introduce comedi_chan_range_is_{bi,uni}polar()
      staging: comedi: pcl726: remove 'bipolar' from the private data
      staging: comedi: pcl726: tidy up pcl726_ao_insn()
      staging: comedi: pcl726: tidy up pcl726_ao_insn_read()
      staging: comedi: pcl726: remove all '= 0' boardinfo
      staging: comedi: pcl726: enable the interrupt support code
      staging: comedi: pcl726: fix the analog output range_table_list initialization
      staging: comedi: pcl726: tidy up pcl726_attach()
      staging: comedi: pcl726: remove digital i/o register offsets from boardinfo
      staging: comedi: pcl726: tidy up the comedi_lrange code
      staging: comedi: pcl726: rename boardinfo 'IRQbits'
      staging: comedi: pcl726: remove unnecessary comments in boardinfo definition
      staging: comedi: pcl726: remove the *_SIZE defines
      staging: comedi: pcl726: final tidy up of boardinfo
      staging: comedi: pcl726: add support for the external interrupt signal
      staging: comedi: pcl726: tidy up multi-line comments
      staging: comedi: pcl726: update MODULE_DESCRIPTION
      staging: comedi: pcl726: rename 'boardtypes'
      staging: comedi: Kconfig: COMEDI_NI_ATMIO should select COMEDI_FC
      staging: comedi: dt2801: fix using uninitialized variable warnings
      staging: comedi: pcl726: rename interrupt (async cmd) support functions
      staging: comedi: 8253.h: tidy up the i8253_cascade_ns_to_timer*() users
      staging: comedi: ni_at_ao: fix namespace clash of 'RSI' define
      staging: comedi: ni_at_ao: remove ATAO_SIZE define
      staging: comedi: ni_at_ao: tidy up the register map defines
      staging: comedi: ni_at_ao: tidy up digital i/o register defines
      staging: comedi: ni_at_ao: tidy up CFG1 register defines
      staging: comedi: ni_at_ao: tidy up the STATUS register defines
      staging: comedi: ni_at_ao: remove 'cfg2' from private data
      staging: comedi: ni_at_ao: tidy up the calibration subdevice
      staging: comedi: ni_at_ao: tidy up the CFG3 register defines
      staging: comedi: ni_at_ao: use 8253.h helpers
      staging: comedi: ni_at_ao: rename the rest of the register map
      staging: comedi: ni_at_ao: move the boardinfo declaration
      staging: comedi: ni_at_ao: move the atao_reset() function
      staging: comedi: ni_at_ao: introduce atao_select_reg_group()
      staging: comedi: ni_at_ao: tidy up atao_ao_winsn()
      staging: comedi: ni_at_ao: tidy up atao_ao_rinsn()
      staging: comedi: ni_at_ao: tidy up atao_attach()
      staging: comedi: ni_at_ao: tidy up multi-line comments
      staging: comedi: ni_at_ao: change MODULE_DESCRIPTION
      staging: comedi: ni_at_ao: fix board names
      staging: comedi: ni_6527: remove DRIVER_NAME define
      staging: comedi: ni_6527: remove unused NI6527_*_SIZE defines
      staging: comedi: ni_6527: remove unused DEBUG* defines
      staging: comedi: ni_6527: remove extra probe noise
      staging: comedi: ni_6527: factor out the code that sets the filter interval
      staging: comedi: ni_6527: factor out the code that sets the filter enables
      staging: comedi: ni_6527: tidy up ni6527_di_insn_config()
      staging: comedi: ni_6527: tidy up ni6527_{di, do}_insn_bits()
      staging: comedi: ni_6527: use dev->read_subdev in interrupt handler
      staging: comedi: ni_6527: tidy up ni6527_interrupt()
      staging: comedi: ni_6527: rename CamelCase defines for the clear register
      staging: comedi: ni_6527: rename CamelCase defines for the control register
      staging: comedi: ni_6527: tidy up ni6527_intr_cmd()
      staging: comedi: ni_6527: tidy up ni6527_intr_cancel()
      staging: comedi: ni_6527: tidy up ni6527_intr_insn_config()
      staging: comedi: ni_6527: remove COMEDI_MITE dependancy
      staging: comedi: ni_6527: introduce ni6527_reset()
      staging: comedi: ni_6527: tidy up the interrupt subdevice
      staging: comedi: ni_6527: tidy up ni6527_auto_attach()
      staging: comedi: ni_6527: tidy up the comedi_driver declaration
      staging: comedi: ni_6527: tidy up multi-line comments
      staging: comedi: ni_6527: change MODULE_DESCRIPTION

Hanjun Guo (1):
      Staging / quickstart: remove reduplicate if(acpi_disabled) check

Himangi Saraogi (3):
      drivers/staging/lustre/lustre/osc/osc_io.c : remove space prohibited warning
      Stging: bcm: Adapter.h : removed typedef from struct _U_IP_ADDRESS and changed it to lowercase
      drivers/staging/nvec/Kconfig: remove trailing whitespace

Ian Abbott (83):
      staging: comedi: pcl711: add AI cancel handler
      staging: comedi: pcl711: handle cmd->stop_src and stop_arg
      staging: comedi: pcl711: put acquired data in buffer for AI command
      staging: comedi: dt9812: remove ifdefed out enums
      staging: comedi: remove unused 'channel flags' support
      staging: comedi: remove 'settling_time_0' from subdevice
      staging: comedi: avoid memleak for subdevice private
      staging: comedi: s626: tidy the header file a bit
      staging: comedi: s626: tidy up comments at top of file
      staging: comedi: s626: tidy up main source code file
      staging: comedi: s626: convert a printk()
      staging: comedi: s626: remove unused DMAHandle
      staging: comedi: s626: remove PCI ID defines
      staging: comedi: s626: rename ai_continous
      staging: comedi: s626: remove I2CR and I2CW macros
      staging: comedi: s626: remove duplicate macros I2C_B0, I2C_B1, I2C_B2
      staging: comedi: s626: replace CamelCase struct bufferDMA
      staging: comedi: s626: rename CamelCase in struct s626_private
      staging: comedi: s626: rename CamelCase in struct enc_private
      staging: comedi: s626: remove a variable from set_mode_a() and _b()
      staging: comedi: s626: rename CamelCase functions
      staging: comedi: s626: rename CamelCase variables
      staging: comedi: s626: remove encpriv macro
      staging: comedi: s626: move encoder functions part 1
      staging: comedi: s626: move encoder functions part 2
      staging: comedi: s626: move encoder functions part 3
      staging: comedi: s626: move s626_enc_chan_info[]
      staging: comedi: s626: remove TRUE and FALSE macros
      staging: comedi: s626: add mmiowb() calls
      staging: comedi: s626: make trimchan[] and trimadrs[] const
      staging: comedi: s626: move struct buffer_dma
      staging: comedi: s626: rename struct buffer_dma
      staging: comedi: s626: prefix function and variable names
      staging: comedi: s626: prefix macros in s626.c
      staging: comedi: s626: prefix macros in s626.h
      staging: comedi: use unsigned samples for comedi_buf_put()/get()
      staging: comedi: use unsigned sample in cfc_write_to_buffer()
      staging: comedi: 8255: sample types are unsigned
      staging: comedi: addi_apci_3120: sample types are unsigned
      staging: comedi: adl_pci9111: sample types are unsigned
      staging: comedi: adl_pci9118: sample types are unsigned
      staging: comedi: adv_pci1710: sample types are unsigned
      staging: comedi: adv_pci1723: sample types are unsigned
      staging: comedi: amplc_pci224: sample types are unsigned
      staging: comedi: amplc_pci230: sample types are unsigned
      staging: comedi: cb_pcidas: sample types are unsigned
      staging: comedi: cb_pcidas64: sample types are unsigned
      staging: comedi: das16: sample types are unsigned
      staging: comedi: das16m1: sample types are unsigned
      staging: comedi: das1800: sample types are unsigned
      staging: comedi: dt282x: sample types are unsigned
      staging: comedi: dt3000: sample types are unsigned
      staging: comedi: fl512: sample types are unsigned
      staging: comedi: icp_multi: sample types are unsigned
      staging: comedi: me4000: sample types are unsigned (and not long!)
      staging: comedi: ni_at_a2150: sample types are unsigned
      staging: comedi: ni_labpc: sample types are unsigned
      staging: comedi: ni_mio_common: sample types are unsigned
      staging: comedi: ni_pcidio: sample types are unsigned
      staging: comedi: pcl711: sample types are unsigned
      staging: comedi: pcl812: sample types are unsigned
      staging: comedi: pcl816: sample types are unsigned
      staging: comedi: pcl818: sample types are unsigned
      staging: comedi: pcmmio: sample types are unsigned
      staging: comedi: pcmuio: sample types are unsigned
      staging: comedi: quatech_daqp_cs: sample types are unsigned
      staging: comedi: rtd520: sample types are unsigned
      staging: comedi: s626: sample types are unsigned
      staging: comedi: usbdux: sample types are unsigned
      staging: comedi: usbduxsigma: sample types are unsigned
      staging: comedi: rtd520: use normal bitfield functions
      staging: comedi: s626: clock polarity and direction are the same
      staging: comedi: s626: specify bitshift for encoder A clock source
      staging: comedi: s626: correct a comment in s626_get_mode_b()
      staging: comedi: s626: distinguish counter src from encoder mode
      staging: comedi: s626: correct S626_CRAMSK_CLKPOL_A macro (unused)
      staging: comedi: s626: add missing bits for 'CRB' register
      staging: comedi: s626: bitfield manipulation macros for CRA, CRB and setup
      staging: comedi: adl_pci9118: fix a misaligned comment
      staging: comedi: s626: make CRA and CRB setup conversions more readable
      staging: comedi: s626: expand standardized IndxSrc values
      staging: comedi: s626: remove S626_BF_* macros
      staging: comedi: s626: replace S626_MULT_X? values

Iker Pedrosa (7):
      Staging: winbond: mto: removed function declaration
      Staging: winbond: mto: avoided use of extern functions
      Staging: winbond: mto: deleted extern functions
      Staging: winbond: phy_calibration: first of the patches that fixes lines over 80 characters
      Staging: winbond: phy_calibration: second of the patches that fixes lines over 80 characters
      Staging: winbond: reg: erased trailing whitespace
      Staging: winbond: reg: white space deleted

Jacek Anaszewski (2):
      DT: Add documentation for gp2ap020a00f sensor
      iio: gp2ap020a00f: Add a driver for the device

Jan Kara (3):
      lustre: Convert ll_get_user_pages() to use get_user_pages_fast()
      ced1401: Convert driver to use get_user_pages_fast()
      sep: Convert sep_lock_user_pages() to get_user_pages_fast()

Jesper Juhl (2):
      staging: lustre: Don't leak 'buffer' in cfs_get_environ()
      staging: vt6655: don't leak when returning -EOPNOTSUPP in vt6655_hostap_ioctl

Jingoo Han (4):
      staging: iio: replace strict_strto*() with kstrto*()
      staging: dgap: Remove casting the return value which is a void pointer
      staging: dgrp: Remove casting the return value which is a void pointer
      staging: dgnc: Remove casting the return value which is a void pointer

Joe Perches (5):
      Staging: Convert uses of compare_ether_addr to ether_addr_equal
      staging: vt6655: Remove commented out block with compare_ether_addr
      staging: Remove unnecessary semicolons
      staging: lustre: Use parenthesis around sizeof
      staging: Remove OOM message after input_allocate_device

Johannes Löthberg (2):
      Staging: vt6656: fix a brace coding style issue in power.c
      Staging: vt6656: fix code indenting error in power.c

John Stultz (1):
      staging: ashmem: Fix ASHMEM_PURGE_ALL_CACHES return value

Jon Bernard (7):
      Staging: fwserial: wrap a line that exceeds 80 characters
      Staging: lustre: fix assignment in if condition in fsfilt.c
      Staging: lustre: fix a brace coding style issue in fsfilt.c
      Staging: lustre: fix formatting mistake in Kconfig
      Staging: lustre: remove unnecessary braces
      Staging: lustre: remove assignment in if conditions
      Staging: lustre: fix switch case statement indenting

Jonathan Cameron (6):
      iio: drop info_mask from struct iio_dev
      iio: refactor info mask and ext_info attribute creation.
      iio: add info_mask_[shared_by_dir/shared_by_all]
      staging:iio: dummy driver additions to show shared_by_dir infomask usage
      iio:temperature:tmp006 put sampling_frequency in info_mask_shared_by_all
      iio:ti_am335x_adc ensure that IIO_KFIFO_BUF is not selected witout IIO_BUFFER

Josh Wu (3):
      iio: at91: ADC start-up time calculation changed since at91sam9x5
      iio: at91: move the num_channels from DT to driver itself
      iio: at91: introduce touch screen support in iio adc driver

Jovi Zhangwei (3):
      staging: ktap: add to the kernel tree
      staging: ktap: update email name in MAINTAINERS
      staging: ktap: remove unused <asm/syscall.h> header file

Juergen Beisert (9):
      Staging/iio/adc/touchscreen/MXS: add proper clock handling
      Staging/iio/adc/touchscreen/MXS: distinguish i.MX23's and i.MX28's LRADC
      Staging/iio/adc/touchscreen/MXS: separate i.MX28 specific register bits
      Staging/iio/adc/touchscreen/MXS: simplify register access
      Staging/iio/adc/touchscreen/MXS: add i.MX23 support to the LRADC touchscreen driver
      Staging/iio/adc/touchscreen/MXS: add interrupt driven touch detection
      Staging/iio/adc/touchscreen/MXS: remove old touchscreen detection implementation
      Staging/iio/adc/touchscreen/MXS: provide devicetree adaption
      Staging/iio: add TODO reminder

Kamlakant Patel (1):
      Staging: MTD: Micron SPINAND Driver support

Kelley Nielsen (24):
      staging: ft1000-usb: remove space between function name and open paren in ft1000_download.c
      staging: ft1000: change comment style
      staging: ft1000: remove braces from one-line conditional
      staging: ft1000: remove space before address operator
      staging: ft1000: remove space before closing paren
      staging: ft1000: convert formal function header to single line comment
      staging: ft1000: convert formal get_handshake() function header to single line comment
      staging: ft1000: change ft1000-download.c header to /* */ comment style
      staging: ft1000: convert formal put_handshake() header to single line comment
      staging: ft1000: remove formal get_request_type function header from ft1000-download.c
      staging: ft1000: remove formal get_request_value function header from ft1000-download.c
      staging: ft1000: change put_request_value() header to single line comment in ft1000_download.c
      staging: ft1000: change hdr_checksum() header to one line comment in ft1000_download.c
      staging: ft1000: change write_blk header to /* */ style in ft1000_download.c
      staging: ft1000: change write_block_fifo() header to /* */ style in ft1000_download.c
      staging: ft1000: change scram_dnldr() header to one line comment in ft1000_download.c
      staging: ft1000: function scram_start_dwnld extracted from scram_dnldr in ft1000_download.c
      staging: ft1000: function request_code_segment extracted
      staging: ft1000: duplicate code replaced with call to request_code_segment
      staging: ft1000: function write_dpram32_and_check extracted from write_blk
      staging: ft1000: style issues fixed in write_blk
      staging: ft1000: status variables changed to int in ft1000_download.c
      staging: ft1000: change values of status return variable in write_dpram32_and_check
      staging: ft1000: return values corrected in scram_start_dwnld

Kevin McKinney (1):
      Staging: bcm: Fix WARNING: space prohibited before semicolon.

Larry Finger (25):
      staging: r8188eu: Fix Smatch off-by-one warning in hal/rtl8188e_hal_init.c
      staging: r8188eu: Fix smatch error in core/rtw_mlme_ext.c
      staging: r8188eu: Fix smatch warning in os_dep/usb_intf.c
      staging: r8188eu: Fix smatch warning in core/rtw_ieee80211.
      staging: r8188eu: Remove unreachable code in core/rtw_br_ext.c
      staging: r8188eu: Fix some smatch errors in core/rtw_efuse.c
      staging: r8188eu: Fix a smatch warnings in core/rtw_recv.c
      staging: r8188eu: Fix smatch warning in os_dep/osdep_service.c
      staging: r8188eu: Fix smatch warning in hal/usb_ops_linux.c
      staging: r8188eu: Fix smatch warnings in os_dep/ioctl_linux.c
      staging: r8188eu: Fix smatch warning in os_dep/ioctl_linux.c
      staging: r8188eu: Fix smatch warnings for hal/rtl8188e_phycfg.c
      staging: r8188eu: Fix smatch warnings in core/rtw_xmit.c
      staging: r8188eu: Fix smatch warnings in odm_HWConfig.c
      staging: r8188eu: Fix smatch warning in core/rtw_wlan_util.c
      staging: r8188eu: Fix smatch warning in hal/HalPhyRf_8188e.c
      staging: r8188eu: Fix smatch warnings in core/rtw_recv.c
      staging: r8188eu: Fix smatch warning in rtl8188eu/core/rtw_xmit.c
      staging: r8188eu: Fix skb leak in usb_read_port_complete()
      staging: r8188eu: Convert driver to use external firmware
      staging: r8188eu: Set device type to wlan
      staging: r8188eu: Fix sparse warnings in rtw_ieee80211.c
      staging: r8188eu: Fix sparse warnings in rtl8188e.cmd.c
      staging: r8188eu: Fix sparse warnings in rtw_mlme_ext.c
      staging: r8188eu: Fix sparse warnings in rtl_p2p.c

Lars-Peter Clausen (117):
      iio:buffer: Simplify iio_buffer_is_active()
      iio:kfifo_buf: Use wake_up_interruptible_poll()
      iio:buffer_cb: Constify iio_cb_access
      iio: iio_push_to_buffers(): Change type of 'data' to const void *
      iio: Remove unnecessary casts for iio_push_to_buffers()
      staging:iio: Remove unnecessary casts for iio_push_to_buffers()
      iio:max1361: Use default triggered buffer setup ops
      iio: Add iio_push_buffers_with_timestamp() helper
      iio:bma180: Use iio_push_buffers_with_timestamp()
      iio:ad7266: Use iio_push_to_buffers_with_timestamp()
      iio:ad7298: Use iio_push_to_buffers_with_timestamp()
      iio:ad7476: Use iio_push_to_buffers_with_timestamp()
      iio:ad7887: Use iio_push_to_buffers_with_timestamp()
      iio:ad7923: Use iio_push_to_buffers_with_timestamp()
      iio:ad_sigma_delta: Use iio_push_to_buffers_with_timestamp()
      iio:at91_adc: Use iio_push_to_buffers_with_timestamp()
      iio:max1363: Use iio_push_to_buffers_with_timestamp()
      iio:st_sensors: Use iio_push_to_buffers_with_timestamp()
      iio:itg3200: Use iio_push_to_buffers_with_timestamp()
      iio:adis16400: Use iio_push_to_buffers_with_timestamp()
      iio:adis_lib: Use iio_push_to_buffers_with_timestamp()
      iio:mpu6050: Use iio_push_to_buffers_with_timestamp()
      iio:adjd_s311: Use iio_push_to_buffers_with_timestamp()
      iio:tcs3472: Use iio_push_to_buffers_with_timestamp()
      iio:gp2ap020a00f: Use iio_push_to_buffers_with_timestamp()
      staging:iio:lis3l02dq: Use iio_push_to_buffers_with_timestamp()
      staging:iio:ad7606: Use iio_push_to_buffers_with_timestamp()
      staging:iio:ad799x: Use iio_push_to_buffers_with_timestamp()
      staging:iio:mxs-lradc: Use iio_push_to_buffers_with_timestamp()
      staging:iio:dummy: Use iio_push_to_buffers_with_timestamp()
      staging:iio:ade7758: Use iio_push_to_buffers_with_timestamp()
      staging:iio:iio-trig-bfin-timer: Fix compile error
      iio:ad5064: Report scale as fractional value
      iio:ad5360: Report scale as fractional value
      iio:ad5380: Report scale as fractional value
      iio:ad5421: Report scale as fractional value
      iio:ad5446: Report scale as fractional value
      iio:ad5504: Report scale as fractional value
      iio:ad5624r: Report scale as fractional value
      iio:ad5686: Report scale as fractional value
      iio:ad5755: Report scale as fractional value
      iio:ad5764: Report scale as fractional value
      iio:ad5791: Report scale as fractional value
      iio:max517: Report scale as fractional value
      iio:mcp4725: Report scale as fractional value
      iio:ad7266: Report scale as fractional value
      iio:ad7476: Report scale as fractional value
      iio:ad7791: Report scale as fractional value
      iio:at91: Report scale as fractional value
      iio:max1363: Report scale as fractional value
      staging:iio:ad7280a: Report scale as fractional value
      staging:iio:ad7606: Report scale as fractional value
      staging:iio:ad7780: Report scale as fractional value
      staging:iio:ad799x: Report scale as fractional value
      staging:iio:ad7746: Report scale as fractional value
      staging:iio:spear_adc: Report scale as fractional value
      iio: Update unit of the voltage scale in the documentation
      iio:ad5449: Use spi_sync_transfer()
      iio:adis16080: Use spi_sync_transfer()
      iio:adxrs450: Use spi_sync_transfer()
      iio:adis16130: Use spi_sync_transfer()
      staging:iio:adis16220: Use spi_sync_transfer()
      staging:iio:ad9852: Use spi_sync_transfer()
      staging:iio:ad9910: Use spi_sync_transfer()
      staging:iio:ad9951: Use spi_sync_transfer()
      iio: Add reference counting for buffers
      iio: Return -ENODEV for file operations if the device has been unregistered
      iio: Wakeup poll and blocking reads when the device is unregistered
      iio:buffer: Add proper locking for iio_update_buffers()
      iio: Add a helper to free a list of IIO device attributes
      iio: Factor IIO value formating into its own function
      iio: Extend the event config interface
      iio:max1363: Switch to new event config interface
      iio:ad5421: Switch to new event config interface
      iio:gp2ap020a00f: Switch to new event config interface
      iio:tsl2563: Switch to new event config interface
      iio:apds9300: Use new event config interface
      staging:iio:lis3l02dq: Switch to new event config interface
      staging:iio:lis2l02dq: Share threshold value between axis
      staging:iio:sca3000: Switch to new config interface
      staging:iio:ad7291: Switch to new event config interface
      staging:iio:ad799x: Switch to new event config interface
      staging:iio:ad7150: Switch to new event config interface
      staging:iio:simple_dummy: Switch to new event config interface
      staging:iio:tsl2x7x: Switch to new event config interface
      iio: Add a hysteresis event info attribute
      staging:iio:ad799x: Simplify threshold register look-up
      staging:iio:ad799x: Use event spec for threshold hysteresis
      staging:iio:ad7291: Use event spec for threshold hysteresis
      iio:buffer: Ignore noop requests for iio_update_buffers()
      staging:iio:spear_adc: Remove unused variable
      staging:iio:spear_adc: Fix sparse warning
      staging:iio:mxs-lradc: Select STMP_DEVICE
      staging:iio: Allow to build SoC specific drivers when COMPILE_TEST is set
      iio:kfifo: Fix memory leak
      iio:kfifo: Protect against concurrent access from userspace
      iio:kfifo: Empty buffer on update
      iio:kfifo: Set update_needed to false after allocating a new buffer
      iio: Update buffer's bytes per datum after updating the scan mask
      iio:st_accel: Drop redundant call to iio_sw_buffer_preenable()
      iio:ad7266: Remove redundant call to iio_sw_preenable()
      iio:ad7887: Remove redundant call to iio_sw_buffer_preenable().
      iio:ad_sigma_delta: Remove redundant call to iio_sw_buffer_preenable().
      iio:ti_am335x: Remove redundant call to iio_sw_buffer_preenable()
      iio:st_gyro: Remove redundant call to iio_sw_buffer_preenable().
      iio:triggered-buffer: Remove redundant call to iio_sw_buffer_preenable().
      iio:st_magn: Remove redundant call to iio_sw_buffer_preenable().
      iio:st_pressure: Remove redundant call to iio_sw_buffer_preenable().
      iio:gp2ap020a00f: Remove redundant call to iio_sw_buffer_preenable()
      staging:iio:lis3l02dq: Remove redundant call to iio_sw_buffer_preenable().
      staging:iio:mxs-lradc: Remove redundant call to iio_sw_buffer_preenable()
      staging:iio:simple-dummy: Remove redundant call to iio_sw_buffer_preenable()
      staging:iio:ad5933: Remove redundant call to iio_sw_buffer_preenable()
      staging:iio:ade7758: Remove redundant call to iio_sw_buffer_preenable()
      iio: Remove unused iio_sw_buffer_preenable()
      staging:iio:lpc32xx_adc: Fix IRQ check
      staging:iio:spear_adc: Fix IRQ check

Lee Jones (15):
      iio: sensors-core: st: Allow full-scale to be an optional feature
      iio: sensors-core: st: Clean-up error handling in st_sensors_read_info_raw()
      iio: pressure-core: st: Describe LPS331AP defines by name
      iio: pressure-core: st: Expand and rename LPS331AP's channel descriptor
      iio: pressure-core: st: Allow for number of channels to vary
      iio: sensors-core: st: Support sensors which don't have a Data Ready pin
      iio: sensors-core: st: Clean-up error handling in st_sensors_init_sensor()
      iio: sensors-core: st: Clean-up error handling in st_sensors_read_axis_data()
      iio: pressure-core: st: Clean-up probe() function
      iio: pressure: st: Add support for new LPS001WP pressure sensor
      iio: accel-core: st: Clean up error handling in probe()
      iio: gyro-core: st: Clean up error handling in probe()
      iio: magn-core: st: Clean up error handling in probe()
      iio: pressure-core: st: Provide support for the Vdd power supply
      iio: pressure-core: st: Provide support for the Vdd_IO power supply

Lidza Louina (7):
      staging: dgnc: renames board_t to dgnc_board
      staging: dgnc: removes parentheses around return statements
      staging: dgnc: removes LINUX_VERSION_CODE conditionals
      staging: dgap: driver.c: removes smatch warning "redundant null check"
      staging: dgap: tty.c: removes smatch warning "ignoring unreachable code"
      staging: dgap: tty.c: removes smatch warnings "redundant null check"
      staging: dgnc: changes arguments in sizeof

Lisa Nguyen (23):
      staging/lustre/lnet/selftest: Fix trailing statements in brw_test.c
      staging/lustre/lnet/selftest: Remove unnecessary spaces in brw_test.c
      staging/lustre/lnet: Remove unnecessary whitespace in lib-move.c
      staging/lustre/lnet: Move open braces to previous lines in lib-move.c
      staging/lustre/lnet: Adjust lines to meet 80 column limit in lib-move.c
      staging/lustre/lnet: Remove () from return statements in lib-move.c
      staging/lustre/lnet: Reformat pointer variable in lib-move.c
      staging/lustre/lnet: Fix static initialization error in router_proc.c
      staging/lustre/lnet: Remove unnecessary spaces in router_proc.c
      staging: lustre: libcfs: Remove bitmap.h file
      staging: lustre: Remove typedef and update cfs_hash_lock union
      staging: lustre: Remove typedef and update cfs_hash_bucket struct
      staging: lustre: Remove typedef and update cfs_debug_limit_state struct
      staging: lustre: Remove typedef and update cfs_hash_bd struct
      staging: lustre: Remove typedef and update cfs_hash struct
      staging: lustre: lnet: Remove unnecessary spaces in lib-lnet.h
      staging: lustre: lnet: Remove unnecessary () from return statements
      staging: lustre: lnet: Reformat pointer variable in lib-lnet.h
      staging: lustre: lnet: Rewrite return statement in socklnd.c
      staging: sb105x: Remove unneeded semicolon in sb_pci_mp.c
      staging: bcm: Replace BOOLEAN with bool
      staging: bcm: Replace FALSE with false
      staging: bcm: Remove unnecessary pointer casting

Luis Ortega Perez de Villar (1):
      Staging: dwc2: core: coding style - indentation should use tabs

Luka Perkov (1):
      staging: octeon: drop redundant mac address check

Majunath Goudar (1):
      zsmalloc: Fix "map_vm_area" undefined reference errors.

Malcolm Priestley (30):
      staging: vt6656: desc.h remove typedef struct tagSTxBufHead to rxtx.h
      staging: vt6656: rxtx.c s_vGenerateTxParameter replace pTxBufHead void pointer.
      staging: vt6656: rxtx.c Create union of struct vnt_rrv_time* stuctures
      staging: vt6656: rxtx.c create structure to join vnt_tx_data_head with vnt_tx_head.
      staging: vt6656: rxtx.c s_vGenerateTxParameter Create vnt_mic_hdr structure
      staging: vt6656: rxtx.c Move rts_cts pointer assignment to s_vGenerateTxParameter
      staging: vt6656: rxtx.c remove dead code rts_cts void
      staging: vt6656: device.h convert sTimerCommand to delayed_work
      staging: vt6656: covert BSSvSecondCallBack to delayed_work.
      staging: vt6656: convert RXvWorkItem to work queue
      staging: vt6656: covert RXvMngWorkItem to work queue
      staging: vt6656: rxtx.c change tx functions to return u16
      staging: vt6656: rxtx.c Parse struct vnt_tx_datahead_g
      staging: vt6656: rxtx.c Parse struct vnt_tx_datahead_g_fb
      staging: vt6656: rxtx.c parse out struct vnt_tx_datahead_a_fb
      staging: vt6656: rxtx.c add no rts struct vnt_tx_datahead_a_fb
      staging: vt6656: rxtx.c parse out vnt_rxtx_datahead_ab
      staging: vt6656: rxtx.c add no rts struct vnt_tx_datahead_ab
      staging: vt6656: rxtx.c remove dead code s_uFillDataHead/pvTxDataHd.
      staging: vt6656: rxtx.c cleanup s_vGenerateTxParameter
      staging: vt6656: make pControlURB available life time of driver.
      staging: vt6656: main_usb.c correct pDevice->pControlURB goto
      staging: vt6656: return from workqueues on fMP_DISCONNECTED
      staging: vt6656: Remove 10 second timer and move to BSSvSecondCallBack
      staging: vt6656: return if pControlURB->hcpriv not NULL
      staging: vt6656: rxtx.c s_bPacketToWirelessUsb set fallback tx rates
      staging: vt6656: rxtx.c s_uGetRTSCTSDuration allow fall-through duplicates
      staging: vt6656: rxtx.c clean up s_uGetRTSCTSDuration
      staging: vt6656: rxtx.c s_vFillTxKey replace u8 *pbyBuf.
      staging: vt6656: call usb_device_reset before netdev registration

Mark Einon (4):
      staging: et131x: Remove unused spinlock
      staging: et131x: Remove unused rcv_pend_lock spinlock
      staging: et131x: Removing some unecessary braces
      staging: et131x: Add some items to the TODO list

Martin Berglund (2):
      Staging: vt6655: 80211mgr: Cleanup of brace coding style issues
      Staging: sm7xxfb: fixed line break coding style issues

Masanari Iida (12):
      staging: dwc2: Fix typo in staging/dwc2
      staging: dgnc: Fix typo in staging/dgnc
      staging: dgap: Fix typo in staging/dgap
      staging: lustre: Fix typo in lustre/libcfs
      staging: lustre: Fix typo in lustre/llite
      staging: octeon: Fix typo in staging/octeon
      staging: vt6655: vt6656: Fix typo in comments
      staging: rtl8192e: Fix typo in rtl8192e/dot11d.h
      staging: rtl8188eu: Fix typo in rtl8188eu/hal
      staging: rtl8188eu: Fix typo in rtl8188eu/os_dep
      staging: rtl8188eu: Fix typo in rtl8188eu/include
      staging: rtl8188eu: Fix typo in rtl8188eu/core

Matthijs Kooijman (1):
      staging: dwc2: Make dwc2_hw_params.host_channels large enough

Nandini Hanumanthagowda (17):
      staging: vt6656: Removed redundant code from iwctl file
      staging: vt6655: Removed C99 style comments
      staging: speakup: remove unnecessary space before semicolon
      staging: octeon: Fixed line over 80 chars warning
      staging: octeon: Removed space at start of line
      staging: vt6656: removed space related checkpatch warnings
      staging: vt6656: Removed checkpatch whitespace errors
      staging: vt6656: indentation and removal of unnecessary spaces
      staging: vt6656: removal of braces under if-control statement
      staging: vt6656: removed unnecessary parentheses in return statement
      staging: vt6656: removed C99-style comments
      staging: vt6656: removed line over 80 chars warning
      staging: lustre: added space before the open parenthesis
      staging: lustre: replaced C99 comment style by C89 style
      staging: vt6656: fixed indentation and unnecessary space errors
      staging: vt6656: removed braces from single line if-statement
      staging: vt6656: removed space after '*' in pointer declaration

Paul Zimmerman (2):
      staging: dwc2: validate urb->actual_length for OUT endpoints
      staging: dwc2: add TODO file

Peng Tao (3):
      lustre/fld: remove fld_thread_key
      staging/lustre/llite: fix mkdir endless loop
      staging/lustre: fix tv_usec build warning on parisc

Peter Meerwald (30):
      iio: Remove trailing ; from function definitions
      staging:iio:hmc5843: Use devm_iio_device_alloc
      iio: Add INT_TIME (integration time) channel info attribute
      iio: adjd_s311: Use INT_TIME channel info
      iio: Add tsl4531 ambient light sensor driver
      iio: Add tcs3472 color light sensor driver
      iio: Fix tcs3472 buffer size
      iio: Minor cleanups of industrialio-buffer
      iio: Make available scan_masks const in ad7266
      iio: Fix tcs3472 dev-to-indio_dev conversion in suspend/resume
      iio: Pass scan mask as unsigned long
      staging:iio:hmc5843: Add pointer to i2c client to data struct
      staging:iio:hmc5843: Rewrite init function
      staging:iio:hmc5843: Use INFO_SAMP_FREQ
      staging:iio:hmc5843: Remove unused LSB register #defines
      staging:iio:hmc5843: Tighten comments
      staging:iio:hmc5843: Introduce helper functions to show/check list of int pairs
      staging:iio:hmc5843: Use SCALE instead of magn_range
      staging:iio:hmc5843: Rename _check_samp_freq to get_samp_freq_index
      staging:iio:hmc5843: Always read all channels values otherwise no updates
      staging:iio:hmc5843: Add trigger handling
      staging:iio:hmc5843: Remove ability to change operating mode
      staging:iio:hmc5843: Rename _configure() to _set_mode()
      staging:iio:hmc5843: Reorganize _set_meas_conf()
      staging:iio:hmc5843: Rename _set_rate() to _set_samp_freq()
      staging:iio:hmc5843: Introduce _set_range_gain()
      staging:iio:hmc5843: Check initialization and chip identifier
      staging:iio:hmc5843: Trivial cleanup
      iio: Correct description how to convert microtesla to gauss
      iio: Add Freescale mag3110 magnetometer driver

Peter Senna Tschudin (4):
      staging: winbond: Change variable type to bool
      staging: vt6656: Change variable type to bool
      staging: rtl8187se: Change variable type to bool
      Staging: crystalhd: Fix assignment of 0/1 to bool variables

Philipp Zabel (9):
      staging: drm/imx: also allow to allocate only 2 DMFC slots for DP full plane
      staging: drm/imx: make struct ipu_rgb format definitions const
      staging: drm/imx: fix RGB formats, make ipu_cpmem_set_fmt take a drm_fourcc
      staging: drm/imx: add BGR565 format
      staging: drm/imx: Add 24-bit BGR support to DC
      staging: drm-imx: add DRM_FORMAT_BGR888 to ipu crtc driver
      staging: drm/imx: ipuv3-crtc: remove unused struct ipu_framebuffer
      staging: drm/imx: add drm plane support
      staging: drm/imx: Enable DRM PRIME support

Randy Dunlap (4):
      staging/olpc: fix dependencies to fix build errors
      staging/mt29f_spinand: fix build error when ONDIEECC not enabled
      staging/olpc_dcon: fix kconfig to fix build errors
      staging/iio/adc: MXS_LRADC depends on INPUT

Raphael S.Carvalho (1):
      staging/speakup/kobjects.c: Code improvement.

Rashika Kheria (52):
      Staging: btmtk_usb: Fix line length exceeding 80 characters
      Staging: btmtk_usb: Fix incorrect brace placement
      Staging: btmtk_usb: Removal of Unnecessary white spaces
      Staging: btmtk_usb: Fix indentation for conditional statement
      Staging: btmtk_usb: Fix line length exceeding 80 characters using min_t macro
      Staging: btmtk_usb: Fix Sparse Warning of incorrect casting
      Staging: btmtk_usb: Fix Sparse Warning of incorrect type in assignment
      Staging: vt6655: Fix Sparse Warning for Static Declarations
      Staging: vt6655: Removal of Unused Function
      Staging: lustre: Removal of Space between function name and parenthesis in conrpc.c
      Staging: lustre: Fix Space Requirement around ':' in conrpc.c
      Staging: lustre: Fix Space Prohibition before '++' in conrpc.c
      Staging: lustre: Fix quoted string split across lines in conrpc.c
      Staging: lustre: Removal of assignment in if condition in conrpc.c
      Staging: lustre: Removal of Space between function name and parenthesis in timer.c
      Staging: slicoss: Removal of if check since debugfs_remove(NULL) is safe
      Staging: slicoss: Replace printk() with pr_debug() or dev_dbg() as required
      Staging: slicoss: Refactor code by introducing new function slic_interrupt_card_up()
      Staging: slicoss: Fix quoted string split across lines
      Staging: sep: Fix Smatch Warning in sep_crypto.c
      Staging: sb105x: Remove redundant null check
      Staging: sb105x: Fix a possible null dereference
      Staging: lustre: Fix space prohibited between function name and open paranthesis
      Staging: lustre: Fix EXPORT_SYMBOL should immediately follow its function/variable
      Staging: lustre: Fix quoted strings split across lines
      Staging: lustre: Fix initialisation of statics to 0 or NULL
      Staging: lustre: Fix indentation of labels
      Staging: lustre: Fix space prohibited between function and open paranthesis
      Staging; lustre: Fix quoted string split across lines
      Staging: lustre: Fix initialisation of statics to NULL or 0
      Staging: lustre: Fix code indentation for conditional statements
      Staging: lustre: Fix no spaces at the start of the line
      Staging: lustre: Fix space required after ','
      Staging: lustre: Fix paranthesis not required around return
      Staging: lustre: Replace __FUNCTION__ with __func__
      Staging: lustre: Fix no use of assignment in if condition
      Staging: slicoss: Replace seq_printf with seq_puts
      Staging: line6: Fix Sparse warning of restricted __le16 degrades to integer
      Staging: line6: Fix Sparse Warning of restricted __le16 degrades to integer
      Staging: line6: Fix Sparse Warning of incorrect type
      Staging: et131x: Fix Smatch Warning of Buffer Overflow
      Staging: sbe-2t3e3: Fix smatch warning of function definition with external linkage
      Staging: dwc2: Fix conditional statement since urb->actual_length is never less than zero.
      Staging: dwc2: Fix return error value in dwc2_driver_probe()
      Staging: ft1000: Fix assignment of bool to non-0/1 constant in ft1000_usb.c
      Staging: ft1000: Fix assignment of bool to non-0/1 constant in ft1000_download.c
      Staging: ft1000: Fix assignment of bool to 0/1 in ft1000_hw.c
      Staging: ft1000: Fix comparsion of bool to 0/1 in ft1000_hw.c
      Staging: ft1000: Fix assignment of bool to 0/1 in ft1000_dnld.c
      Staging: dwc2: Fix variable dereferenced before check
      Staging: zram: Fix variable dereferenced before check
      Staging: zram: Fix access of NULL pointer

Sachin Kamat (84):
      staging: iio: ad7192: Use devm_* APIs and fix a memory leak
      staging: iio: ad7280a: Use devm_iio_device_alloc
      staging: iio: ad7291: Use devm_* APIs
      staging: iio: ad7606_core: Use devm_* APIs
      staging: iio: ad7780: Use devm_* APIs
      staging: iio: ad7816: Use devm_* APIs
      staging: iio: ad799x_core: Use devm_* APIs
      staging: iio: lpc32xx_adc: Use devm_* APIs
      staging: iio: adt7316: Use devm_* APIs
      staging: iio: ad5933: Use devm_* APIs
      staging: iio: tsl2583: Use devm_iio_device_alloc
      staging: iio: ad5930: Use devm_iio_device_alloc
      staging: iio: ad9832: Use devm_* APIs
      staging: iio: ad9834: Use devm_* APIs
      staging: iio: ad9850: Use devm_iio_device_alloc
      staging: iio: ad9852: Use devm_iio_device_alloc
      staging: iio: ad9910: Use devm_iio_device_alloc
      staging: iio: ad9951: Use devm_iio_device_alloc
      staging: iio: tsl2x7x_core: Use devm_* APIs
      staging: iio: tsl2x7x_core: Fix sparse warning
      staging: iio: hmc5843: Fix a trivial typo
      MAINTAINERS: Update Jonathan's email address
      iio: gyro: adis16130: Remove redundant break
      iio: gyro: adis16260: Remove redundant break
      iio: gyro: adxrs450: Remove redundant break
      iio: dac: ad5686: Remove redundant break
      staging: iio: tsl2x7x_core: Remove redundant break
      staging: iio: ad2s1200: Use devm_* APIs
      staging: iio: ad2s1200: Use dev_err instead of pr_err
      staging: iio: ad2s1210: Use devm_iio_device_alloc
      staging: iio: ad2s90: Use devm_iio_device_alloc
      staging: iio: ade7753: Use devm_iio_device_alloc
      staging: iio: ade7754: Use devm_iio_device_alloc
      staging: iio: ade7758_core: Use devm_iio_device_alloc
      staging: iio: ade7759: Use devm_iio_device_alloc
      staging: iio: ade7854: Use devm_iio_device_alloc
      staging: dgap: Remove version check in dgap_driver.c
      staging: dgap: Remove version check in dgap_kcompat.h
      staging: rtl8187se: Remove redundant pci_set_drvdata
      staging: vt6655: Remove redundant pci_set_drvdata
      staging: xgifb: Remove redundant pci_set_drvdata
      staging: sm7xxfb: Remove redundant pci_set_drvdata
      staging: rtl8192e: Remove redundant pci_set_drvdata
      staging: imx-drm: Remove redundant of_match_ptr
      staging: dgnc: Remove KERNEL_VERSION check
      staging: cxt1e1: musycc.c: Use NULL instead of 0
      staging: cxt1e1: sbecom_inline_linux.h: Return NULL instead of 0
      staging: cxt1e1: sbeid.c: Use NULL instead of 0
      staging: cxt1e1: linux.c: Use NULL instead of 0
      staging: cxt1e1: sbeproc.c: Use NULL instead of 0
      staging: cxt1e1: hwprobe.c: Use NULL instead of 0
      staging: cxt1e1: sbecrc.c: Use NULL instead of 0
      staging: cxt1e1: pmcc4_drv.c: Use NULL instead of 0
      staging: cxt1e1: musycc.c: Return negative error codes
      staging: cxt1e1: hwprobe.c: Return negative error codes
      staging: cxt1e1: linux.c: Return negative error codes
      staging: xillybus: Use module_platform_driver
      staging: mt29f_spinand: Use module_spi_driver
      staging: dgap: dgap_fep5: Remove braces around single line statements
      staging: dgap: dgap_fep5: Remove braces around return
      staging: dgap: dgap_fep5: Do not use 0 for NULL pointer
      staging: dgap: dgap_tty: Do not use 0 for pointers
      staging: line6: midi: Use NULL instead of 0 for pointers
      staging: lustre: Do not use 0 for NULL pointer in console.c
      staging: dgnc: dgnc_tty: Do not use 0 for NULL pointer
      staging: lirc: Do not use 0 for NULL pointer
      staging: rtl8192u: Use NULL instead of 0
      staging: vt6655: Use NULL instead of 0
      iio: adc: mcp3422: Include linux/of.h header
      iio: adc: nau7802: Include linux/of.h header
      iio: adc: ti-adc081c: Include linux/of.h header
      iio: light: gp2ap020a00f: Include linux/of.h header
      iio: adc: twl6030-gpadc: Remove redundant of_match_ptr
      iio: adc: nau7802: Remove redundant of_match_ptr
      iio: adc: ti_am335x_adc: Remove redundant of_match_ptr
      iio: core: Use pr_err instead of printk
      iio: core: Add misssing braces
      iio: accel: kxsd9: Remove redundant variable
      iio: adc: twl6030-gpadc: Remove redundant code
      iio: dac: ad5421: Remove redundant code
      iio: dac: ad5755: Remove redundant code
      iio: dac: max517: Remove redundant variable
      iio: dac: mcp4725: Remove redundant code
      iio: light: vcnl4000: Remove redundant code

Sascha Hauer (2):
      staging: drm/imx: make waiting for idle channel optional
      staging: drm/imx: fix pageflip events during device close

Sean Williams (1):
      Staging: comedi: ni_at_a2150: Remove a few superfluous braces

Sebastian Andrzej Siewior (1):
      staging: iio: generic_buffer: initialize ret

Shalin Mehta (2):
      Staging: bcm: PHSModule.c: Matching the function definition with function declaration
      staging: speakup: str initialization replaced with NULL where it was initialized with int

Srinivas Pandruvada (3):
      HID: Delay opening HID device
      IIO: call sensor hub open close function
      HID RTC: Open sensor hub open close

Teodora Baluta (32):
      Staging: wlan-ng: fix sparse warnings for static functions
      Staging: rtl8192u: fix sparse warnings for static functions
      Staging: rtl8192u: fix checkpatch.pl error
      Staging: rtl8192u: fix functions that should not be declared extern
      Staging: rtl8192u: use gfp_t instead of int
      staging: rtl8192u: fix sparse warning, make a function static
      staging: rtl8187se: use gfp_t instead of int
      staging: rtl8187se: add missing __iomem annotation
      staging: rtl8187se: fix static sparse warnings
      staging: rtl8187se: checkpatch cleanups
      staging: gdm724x: kzalloc should be used instead of kmalloc/memset
      staging: rtl8187se: (foo*) should be (foo *)
      staging: rtl8187se: use C89 comment style instead of C99-style
      staging: rtl8187se: fix checkpatch space and tab warnings
      staging: rtl8187se: open brace following function declarations go on the next line
      staging: rtl8187se: fix comments over 80 characters
      staging: rtl8187se: else should follow close brace '}
      staging: rtl8187se: fix conditional statement indent
      staging: rtl8187se: remove an unnecessary line continuation
      staging: rtl8187se: fixup multi-line comment
      staging: rtl8187se: fix lines over 80 characters
      staging: rtl8187se: prefer netdev_dbg to printk
      staging: rtl8187se: use netdev_info instead of printk
      staging: rtl8187se: use netdev_warn instead of printk
      staging: rtl8192u: use memdup_user to simplify code
      staging: rtl8187se: use memdup_user to simplify code
      staging: rtl8187se: fix assignment of bool to 0/1
      staging: rtl8187se: bool tests don't need comparisons
      staging: rtl8187se: fix code allignment
      staging: rtl8187se: delete duplicated argument to |
      staging: rtl8192e: use memdup_user to simplify code
      staging: comedi: use memdup_user to simplify code

Thomas Cort (1):
      Staging: rtl8712: fix spaces before semicolons

Thomas Meyer (1):
      iio: at91_adc: Cocci spatch "noderef"

Tobias Polzer (2):
      staging: usbip: Fix build on Debian ppc
      staging: usbip: Fix man-pages for usbip userspace utilities

Tugce Sirin (2):
      staging: nvec: fix space after if statement in nvec.c
      staging: silicom: fix space prohibited before semicolon

Valentina Manea (11):
      Staging: crystalhd: Fix sparse warnings regarding static functions
      staging: gdm724x: Fix sparse warnings regarding static functions/variables
      staging: r8188eu: Fix sparse warnings regarding static functions
      staging: lustre: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
      staging: drm/imx: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
      staging: imx-drm: use true and false for bool variables
      staging: rtl8188eu: do not use comparisons on bool tests
      staging: rtl8192e: do not use comparisons on bool tests
      staging: sep: do not use comparisons on bool tests
      staging: rtl8192e: use true and false for bool variables
      staging: rtl8192e: remove unneeded semicolons

Vivien Didelot (1):
      iio:adc:max1363 support SMBus for 8-bit devices

Wei Yongjun (5):
      staging: r8188eu: remove needless check before usb_free_urb()
      Staging: crystalhd: use vfree() instead of kfree()
      staging: sep: add missing misc_deregister() on error in sep_register_driver_with_fs()
      staging: drm/imx: fix return value check in imx_drm_init()
      staging: drm/imx: fix return value check in ipu_add_subdevice_pdata()

Xenia Ragiadakou (32):
      staging: rtl8192u: remove unused code from cmpk_message_handle_tx()
      staging: rtl8192u: remove cmpk_message_handle_tx()
      staging: rtl8192u: remove unused code in fw_download_code()
      staging: rtl8192u: check dev_alloc_skb() return value in fw_download_code()
      staging: rtl8192u: remove dm_check_rfctrl_gpio()
      staging: rtl8192u: remove #ifdef RTL8192U guard in r8192U_dm.c
      staging: rtl8192u: remove unused dm_gpio_change_rf_callback()
      staging: rtl8192u: remove code inside #ifdef RTL8190P/RTL8192E in r819xU_phy.c
      staging: rtl8192u: remove code inside #ifdef RTL8190P in r819xU_firmware.c
      staging: rtl8192u: remove code inside #ifdef RTL8190P in r8192U_dm.c
      staging: rtl8192u: remove #ifndef RTL8190P guard from r8192U_dm.c
      staging: rtl8192u: remove #ifndef RTL8192U and the code inside it
      staging: rtl8192u: remove code inside #ifdef RTL8190P in r8190_rtl8256.h
      staging: rt8192u: remove #ifdef RTL8192U in r8192U.h
      staging: rtl8192u: remove #ifdef JOHN_
      staging: rtl8192u: add space after } and , in r819xU_cmdpkt.h
      staging: rtl8192u: fix line size in r819xU_cmdpkt.h
      staging: rtl8192u: fix comments in r819xU_cmdpkt.h
      staging: rtl8192u: fix space at the start of lines in r819xU_cmdpkt.h
      staging: rtl8192u: fix space after ( in r819xU_cmdpkt.h
      staging: rtl8192u: fix alignment in r819xU_cmdpkt.h
      staging: rtl8192u: fix open brace position in r819xU_cmdpkt.h
      staging: rtl8192u: use __packed instead of __attribute__((packed))
      staging: rtl8192u: fix space around braces in r819xU_HTType.h
      staging: rtl8192u: fix comments in r819xU_HTType.h
      staging: rtl8192u: fix alignment in r819xU_HTType.h
      staging: rtl8192u: add space after ',' in r819xU_HTType.h
      staging: rtl8192u: add parenthesis around complex macros in r819xU_HTType.h
      staging: rtl8192u: fix line size in r819xU_HTType.h
      staging: rtl8192u: remove r8180_pm.c and r8180_pm.h
      staging: rtl8192u: remove ieee80211_crypt.h
      staging: rtl8192u: copy dot11d.h in ieee80211/dot11d.h and remove it

Xie XiuQi (2):
      staging:iio:adc:ad7606 remove unnecessary work pending test
      staging: olpc_dcon: remove unnecessary work pending test

Yann Droneaud (1):
      iio: use anon_inode_getfd() with O_CLOEXEC flag

Zubair Lutfullah (6):
      input: ti_am335x_tsc: Enable shared IRQ for TSC
      iio: ti_am335x_adc: optimize memory usage
      iio: ti_am335x_adc: Add continuous sampling support
      iio: ti_am335x_adc: fix static in function header
      iio: ti_am335x_adc: cleanup trigger related code
      iio: ti_am335x_adc: cleanup error case

navin patidar (3):
      staging: usbip: stub_main: correctly handle return value
      staging: usbip: vhci_hcd: correctly handle return value
      staging: usbip: vhci_hcd: remove check for dma

 Documentation/ABI/testing/sysfs-bus-iio            |   71 +-
 .../devicetree/bindings/arm/atmel-adc.txt          |    8 +-
 .../devicetree/bindings/iio/light/cm36651.txt      |   26 +
 .../devicetree/bindings/iio/light/gp2ap020a00f.txt |   21 +
 .../bindings/staging/iio/adc/mxs-lradc.txt         |   36 +-
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 MAINTAINERS                                        |   11 +-
 arch/arm/boot/dts/imx23.dtsi                       |    1 +
 arch/arm/boot/dts/imx28-evk.dts                    |    4 +
 arch/arm/boot/dts/imx28.dtsi                       |    1 +
 arch/arm/mach-at91/include/mach/at91_adc.h         |   34 +
 drivers/hid/hid-sensor-hub.c                       |   45 +-
 drivers/iio/accel/bma180.c                         |    7 +-
 drivers/iio/accel/hid-sensor-accel-3d.c            |    7 +-
 drivers/iio/accel/kxsd9.c                          |    7 +-
 drivers/iio/accel/st_accel_buffer.c                |   11 +-
 drivers/iio/accel/st_accel_core.c                  |   30 +-
 drivers/iio/adc/Kconfig                            |   12 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/ad7266.c                           |   46 +-
 drivers/iio/adc/ad7298.c                           |   10 +-
 drivers/iio/adc/ad7476.c                           |   16 +-
 drivers/iio/adc/ad7791.c                           |   18 +-
 drivers/iio/adc/ad7887.c                           |   15 +-
 drivers/iio/adc/ad7923.c                           |   10 +-
 drivers/iio/adc/ad_sigma_delta.c                   |    7 +-
 drivers/iio/adc/at91_adc.c                         |  469 ++-
 drivers/iio/adc/max1363.c                          |  299 +-
 drivers/iio/adc/mcp3422.c                          |  410 +++
 drivers/iio/adc/nau7802.c                          |    3 +-
 drivers/iio/adc/ti-adc081c.c                       |    1 +
 drivers/iio/adc/ti_am335x_adc.c                    |  225 +-
 drivers/iio/adc/twl6030-gpadc.c                    |    6 +-
 drivers/iio/buffer_cb.c                            |   27 +-
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |    6 +
 drivers/iio/common/st_sensors/st_sensors_buffer.c  |    7 +-
 drivers/iio/common/st_sensors/st_sensors_core.c    |   70 +-
 drivers/iio/dac/Kconfig                            |    2 +-
 drivers/iio/dac/ad5064.c                           |   10 +-
 drivers/iio/dac/ad5360.c                           |   11 +-
 drivers/iio/dac/ad5380.c                           |   44 +-
 drivers/iio/dac/ad5421.c                           |   86 +-
 drivers/iio/dac/ad5446.c                           |   18 +-
 drivers/iio/dac/ad5449.c                           |    7 +-
 drivers/iio/dac/ad5504.c                           |   13 +-
 drivers/iio/dac/ad5624r_spi.c                      |   13 +-
 drivers/iio/dac/ad5686.c                           |   14 +-
 drivers/iio/dac/ad5755.c                           |   26 +-
 drivers/iio/dac/ad5764.c                           |   10 +-
 drivers/iio/dac/ad5791.c                           |   11 +-
 drivers/iio/dac/ad7303.c                           |    1 +
 drivers/iio/dac/max517.c                           |   17 +-
 drivers/iio/dac/mcp4725.c                          |   19 +-
 drivers/iio/frequency/adf4350.c                    |    1 +
 drivers/iio/gyro/adis16080.c                       |    7 +-
 drivers/iio/gyro/adis16130.c                       |    8 +-
 drivers/iio/gyro/adis16260.c                       |    1 -
 drivers/iio/gyro/adxrs450.c                        |   13 +-
 drivers/iio/gyro/hid-sensor-gyro-3d.c              |    7 +-
 drivers/iio/gyro/itg3200_buffer.c                  |    5 +-
 drivers/iio/gyro/st_gyro_buffer.c                  |   11 +-
 drivers/iio/gyro/st_gyro_core.c                    |   30 +-
 drivers/iio/iio_core.h                             |    8 +-
 drivers/iio/imu/adis16400_buffer.c                 |    9 +-
 drivers/iio/imu/adis_buffer.c                      |    9 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c         |    6 +-
 drivers/iio/industrialio-buffer.c                  |  242 +-
 drivers/iio/industrialio-core.c                    |  275 +-
 drivers/iio/industrialio-event.c                   |  232 +-
 drivers/iio/industrialio-triggered-buffer.c        |    8 +-
 drivers/iio/kfifo_buf.c                            |   49 +-
 drivers/iio/light/Kconfig                          |   43 +
 drivers/iio/light/Makefile                         |    4 +
 drivers/iio/light/adjd_s311.c                      |   77 +-
 drivers/iio/light/apds9300.c                       |   53 +-
 drivers/iio/light/cm36651.c                        |  708 +++++
 drivers/iio/light/gp2ap020a00f.c                   | 1654 ++++++++++
 drivers/iio/light/hid-sensor-als.c                 |    7 +-
 drivers/iio/light/tcs3472.c                        |  367 +++
 drivers/iio/light/tsl2563.c                        |   53 +-
 drivers/iio/light/tsl4531.c                        |  258 ++
 drivers/iio/light/vcnl4000.c                       |    6 +-
 drivers/iio/magnetometer/Kconfig                   |   10 +
 drivers/iio/magnetometer/Makefile                  |    1 +
 drivers/iio/magnetometer/ak8975.c                  |    2 +-
 drivers/iio/magnetometer/hid-sensor-magn-3d.c      |    7 +-
 drivers/iio/magnetometer/mag3110.c                 |  401 +++
 drivers/iio/magnetometer/st_magn_buffer.c          |   11 +-
 drivers/iio/magnetometer/st_magn_core.c            |   31 +-
 drivers/iio/pressure/Kconfig                       |    2 +-
 drivers/iio/pressure/st_pressure.h                 |    1 +
 drivers/iio/pressure/st_pressure_buffer.c          |   11 +-
 drivers/iio/pressure/st_pressure_core.c            |  307 +-
 drivers/iio/pressure/st_pressure_i2c.c             |    1 +
 drivers/iio/pressure/st_pressure_spi.c             |    1 +
 drivers/iio/temperature/tmp006.c                   |   57 +-
 drivers/iio/trigger/iio-trig-sysfs.c               |   14 +-
 drivers/input/touchscreen/ti_am335x_tsc.c          |   12 +-
 drivers/rtc/rtc-hid-sensor-time.c                  |   15 +-
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/android/Kconfig                    |    7 +-
 drivers/staging/android/alarm-dev.c                |    8 +-
 drivers/staging/android/ashmem.c                   |  139 +-
 drivers/staging/android/binder.c                   |    9 +-
 drivers/staging/android/timed_output.h             |    4 +-
 drivers/staging/bcm/Adapter.h                      |  128 +-
 drivers/staging/bcm/Bcmchar.c                      |   49 +-
 drivers/staging/bcm/Bcmnet.c                       |    5 +-
 drivers/staging/bcm/CmHost.c                       |   70 +-
 drivers/staging/bcm/CmHost.h                       |    2 +-
 drivers/staging/bcm/DDRInit.c                      |    2 +-
 drivers/staging/bcm/HandleControlPacket.c          |   12 +-
 drivers/staging/bcm/IPv6Protocol.c                 |   30 +-
 drivers/staging/bcm/InterfaceDld.c                 |    8 +-
 drivers/staging/bcm/InterfaceIdleMode.c            |    4 +-
 drivers/staging/bcm/InterfaceInit.c                |   20 +-
 drivers/staging/bcm/InterfaceIsr.c                 |   12 +-
 drivers/staging/bcm/InterfaceMisc.c                |   10 +-
 drivers/staging/bcm/InterfaceRx.c                  |   22 +-
 drivers/staging/bcm/InterfaceRx.h                  |    2 +-
 drivers/staging/bcm/InterfaceTx.c                  |   28 +-
 drivers/staging/bcm/LeakyBucket.c                  |    8 +-
 drivers/staging/bcm/Misc.c                         |   68 +-
 drivers/staging/bcm/PHSModule.c                    |   46 +-
 drivers/staging/bcm/PHSModule.h                    |    4 +-
 drivers/staging/bcm/Prototypes.h                   |   12 +-
 drivers/staging/bcm/Qos.c                          |  102 +-
 drivers/staging/bcm/Transmit.c                     |    4 +-
 drivers/staging/bcm/Typedefs.h                     |    4 +-
 drivers/staging/bcm/led_control.c                  |   38 +-
 drivers/staging/bcm/nvm.c                          |  160 +-
 drivers/staging/bcm/vendorspecificextn.c           |    2 +-
 drivers/staging/bcm/vendorspecificextn.h           |    2 +-
 drivers/staging/btmtk_usb/btmtk_usb.c              |  317 +-
 drivers/staging/ced1401/ced_ioc.c                  |    5 +-
 drivers/staging/comedi/Kconfig                     |    3 +-
 drivers/staging/comedi/comedi_buf.c                |    8 +-
 drivers/staging/comedi/comedi_fops.c               |   52 +-
 drivers/staging/comedi/comedidev.h                 |   32 +-
 drivers/staging/comedi/drivers.c                   |   29 +
 drivers/staging/comedi/drivers/8253.h              |    9 +
 drivers/staging/comedi/drivers/8255.c              |   27 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |    2 -
 .../staging/comedi/drivers/addi-data/addi_common.h |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |    7 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |   19 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    7 +-
 drivers/staging/comedi/drivers/addi_apci_1516.c    |    8 +-
 drivers/staging/comedi/drivers/addi_apci_16xx.c    |   11 +-
 drivers/staging/comedi/drivers/addi_apci_2032.c    |    8 +-
 drivers/staging/comedi/drivers/addi_apci_2200.c    |    8 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c    |    2 -
 drivers/staging/comedi/drivers/addi_apci_3501.c    |    8 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |   17 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |  137 +-
 drivers/staging/comedi/drivers/adl_pci7x3x.c       |   13 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |   24 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |   46 +-
 drivers/staging/comedi/drivers/adq12b.c            |   32 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |   39 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |   15 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |   33 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |    4 +-
 .../staging/comedi/drivers/amplc_dio200_common.c   |   33 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |   17 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |   40 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |   21 +-
 drivers/staging/comedi/drivers/amplc_pci263.c      |   17 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |   21 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   49 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |   27 +-
 drivers/staging/comedi/drivers/comedi_fc.h         |    2 +-
 drivers/staging/comedi/drivers/comedi_parport.c    |  380 ++-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |   12 +-
 drivers/staging/comedi/drivers/das08.c             |   46 +-
 drivers/staging/comedi/drivers/das08.h             |    1 -
 drivers/staging/comedi/drivers/das16.c             |   46 +-
 drivers/staging/comedi/drivers/das16m1.c           |   46 +-
 drivers/staging/comedi/drivers/das1800.c           |   75 +-
 drivers/staging/comedi/drivers/das800.c            |   16 +-
 drivers/staging/comedi/drivers/dmm32at.c           |   70 +-
 drivers/staging/comedi/drivers/dt2801.c            |   21 +-
 drivers/staging/comedi/drivers/dt2811.c            |    8 +-
 drivers/staging/comedi/drivers/dt2817.c            |   51 +-
 drivers/staging/comedi/drivers/dt282x.c            |   22 +-
 drivers/staging/comedi/drivers/dt3000.c            |   11 +-
 drivers/staging/comedi/drivers/dt9812.c            |   19 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |   20 +-
 drivers/staging/comedi/drivers/fl512.c             |    3 +-
 drivers/staging/comedi/drivers/icp_multi.c         |   18 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |    7 +-
 drivers/staging/comedi/drivers/me4000.c            |   41 +-
 drivers/staging/comedi/drivers/me_daq.c            |    9 +-
 drivers/staging/comedi/drivers/multiq3.c           |    8 +-
 drivers/staging/comedi/drivers/ni_6527.c           |  473 +--
 drivers/staging/comedi/drivers/ni_660x.c           |    1 -
 drivers/staging/comedi/drivers/ni_670x.c           |   11 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |   11 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |  538 ++--
 drivers/staging/comedi/drivers/ni_atmio16d.c       |    9 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |   19 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |   35 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |   63 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |   21 +-
 drivers/staging/comedi/drivers/ni_stc.h            |    2 +-
 drivers/staging/comedi/drivers/pcl711.c            |  704 ++---
 drivers/staging/comedi/drivers/pcl726.c            |  592 ++--
 drivers/staging/comedi/drivers/pcl730.c            |   13 +-
 drivers/staging/comedi/drivers/pcl812.c            |   57 +-
 drivers/staging/comedi/drivers/pcl816.c            |   25 +-
 drivers/staging/comedi/drivers/pcl818.c            |   44 +-
 drivers/staging/comedi/drivers/pcmad.c             |    8 +-
 drivers/staging/comedi/drivers/pcmmio.c            |    7 +-
 drivers/staging/comedi/drivers/pcmuio.c            |    4 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |   11 +-
 drivers/staging/comedi/drivers/rtd520.c            |   62 +-
 drivers/staging/comedi/drivers/rti800.c            |    8 +-
 drivers/staging/comedi/drivers/s526.c              |    9 +-
 drivers/staging/comedi/drivers/s626.c              | 2844 ++++++++++--------
 drivers/staging/comedi/drivers/s626.h              | 1384 +++++----
 drivers/staging/comedi/drivers/skel.c              |   46 +-
 drivers/staging/comedi/drivers/ssv_dnp.c           |   48 +-
 drivers/staging/comedi/drivers/usbdux.c            |   41 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |   26 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |   35 +-
 drivers/staging/cptm1217/clearpad_tm1217.c         |    2 -
 drivers/staging/crystalhd/crystalhd_hw.c           |    8 +-
 drivers/staging/crystalhd/crystalhd_lnx.c          |   15 +-
 drivers/staging/cxt1e1/comet.c                     |   10 +-
 drivers/staging/cxt1e1/comet.h                     |    2 +-
 drivers/staging/cxt1e1/hwprobe.c                   |   14 +-
 drivers/staging/cxt1e1/linux.c                     |   28 +-
 drivers/staging/cxt1e1/musycc.c                    |   32 +-
 drivers/staging/cxt1e1/pmcc4_drv.c                 |   16 +-
 drivers/staging/cxt1e1/sbecom_inline_linux.h       |    4 +-
 drivers/staging/cxt1e1/sbecrc.c                    |    4 +-
 drivers/staging/cxt1e1/sbeid.c                     |    2 +-
 drivers/staging/cxt1e1/sbeproc.c                   |    2 +-
 drivers/staging/cxt1e1/sbew_ioc.h                  |   24 +-
 drivers/staging/dgap/Makefile                      |    2 -
 drivers/staging/dgap/dgap_downld.h                 |    2 +-
 drivers/staging/dgap/dgap_driver.c                 |   13 +-
 drivers/staging/dgap/dgap_driver.h                 |    5 +-
 drivers/staging/dgap/dgap_fep5.c                   |   53 +-
 drivers/staging/dgap/dgap_fep5.h                   |    2 +-
 drivers/staging/dgap/dgap_kcompat.h                |   29 -
 drivers/staging/dgap/dgap_parse.c                  |   10 +-
 drivers/staging/dgap/dgap_sysfs.c                  |   22 +-
 drivers/staging/dgap/dgap_tty.c                    |   41 +-
 drivers/staging/dgap/digi.h                        |    4 +-
 drivers/staging/dgap/downld.c                      |    4 +-
 drivers/staging/dgnc/dgnc_cls.c                    |   45 +-
 drivers/staging/dgnc/dgnc_driver.c                 |  145 +-
 drivers/staging/dgnc/dgnc_driver.h                 |   12 +-
 drivers/staging/dgnc/dgnc_kcompat.h                |   29 -
 drivers/staging/dgnc/dgnc_mgmt.c                   |   26 +-
 drivers/staging/dgnc/dgnc_neo.c                    |   32 +-
 drivers/staging/dgnc/dgnc_neo.h                    |    2 +-
 drivers/staging/dgnc/dgnc_sysfs.c                  |  188 +-
 drivers/staging/dgnc/dgnc_sysfs.h                  |    6 +-
 drivers/staging/dgnc/dgnc_tty.c                    |  337 +--
 drivers/staging/dgnc/dgnc_tty.h                    |    6 +-
 drivers/staging/dgnc/digi.h                        |    4 +-
 drivers/staging/dgrp/dgrp_sysfs.c                  |   30 +-
 drivers/staging/dwc2/TODO                          |   33 +
 drivers/staging/dwc2/core.c                        |   27 +-
 drivers/staging/dwc2/core.h                        |    9 +-
 drivers/staging/dwc2/hcd.c                         |   54 +-
 drivers/staging/dwc2/hcd.h                         |    3 +
 drivers/staging/dwc2/hcd_ddma.c                    |   13 +-
 drivers/staging/dwc2/hcd_intr.c                    |   46 +-
 drivers/staging/dwc2/hcd_queue.c                   |  203 +-
 drivers/staging/dwc2/pci.c                         |    1 +
 drivers/staging/dwc2/platform.c                    |    2 +-
 drivers/staging/et131x/Module.symvers              |    0
 drivers/staging/et131x/README                      |    7 +-
 drivers/staging/et131x/et131x.c                    |   22 +-
 drivers/staging/ft1000/ft1000-pcmcia/boot.h        |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |    4 +-
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |  574 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |  457 ++-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    6 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    2 +-
 drivers/staging/fwserial/fwserial.c                |    3 +-
 drivers/staging/gdm724x/gdm_lte.c                  |    6 +-
 drivers/staging/gdm724x/gdm_mux.c                  |   14 +-
 drivers/staging/gdm724x/gdm_tty.c                  |   12 +-
 drivers/staging/gdm724x/gdm_usb.c                  |    6 +-
 drivers/staging/iio/Documentation/iio_utils.h      |    2 +-
 drivers/staging/iio/TODO                           |   11 +
 drivers/staging/iio/accel/adis16220_core.c         |    6 +-
 drivers/staging/iio/accel/lis3l02dq_core.c         |   66 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |   14 +-
 drivers/staging/iio/accel/sca3000_core.c           |   66 +-
 drivers/staging/iio/accel/sca3000_ring.c           |   19 +-
 drivers/staging/iio/adc/Kconfig                    |    8 +-
 drivers/staging/iio/adc/ad7192.c                   |   15 +-
 drivers/staging/iio/adc/ad7280a.c                  |   21 +-
 drivers/staging/iio/adc/ad7291.c                   |  246 +-
 drivers/staging/iio/adc/ad7606_core.c              |   35 +-
 drivers/staging/iio/adc/ad7606_ring.c              |    8 +-
 drivers/staging/iio/adc/ad7780.c                   |   37 +-
 drivers/staging/iio/adc/ad7816.c                   |   59 +-
 drivers/staging/iio/adc/ad799x.h                   |   16 +-
 drivers/staging/iio/adc/ad799x_core.c              |  297 +-
 drivers/staging/iio/adc/ad799x_ring.c              |   10 +-
 drivers/staging/iio/adc/lpc32xx_adc.c              |   51 +-
 drivers/staging/iio/adc/mxs-lradc.c                |  996 ++++--
 drivers/staging/iio/adc/spear_adc.c                |   12 +-
 drivers/staging/iio/addac/adt7316-i2c.c            |    3 +-
 drivers/staging/iio/addac/adt7316-spi.c            |    3 +-
 drivers/staging/iio/addac/adt7316.c                |   86 +-
 drivers/staging/iio/cdc/ad7150.c                   |  165 +-
 drivers/staging/iio/cdc/ad7746.c                   |   13 +-
 drivers/staging/iio/frequency/ad5930.c             |   16 +-
 drivers/staging/iio/frequency/ad9832.c             |   36 +-
 drivers/staging/iio/frequency/ad9834.c             |   33 +-
 drivers/staging/iio/frequency/ad9850.c             |   16 +-
 drivers/staging/iio/frequency/ad9852.c             |   62 +-
 drivers/staging/iio/frequency/ad9910.c             |   98 +-
 drivers/staging/iio/frequency/ad9951.c             |   43 +-
 drivers/staging/iio/iio_simple_dummy.c             |   49 +-
 drivers/staging/iio/iio_simple_dummy.h             |   22 +-
 drivers/staging/iio/iio_simple_dummy_buffer.c      |   17 +-
 drivers/staging/iio/iio_simple_dummy_events.c      |   49 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |   44 +-
 drivers/staging/iio/light/isl29018.c               |   18 +-
 drivers/staging/iio/light/tsl2583.c                |   48 +-
 drivers/staging/iio/light/tsl2x7x_core.c           |  168 +-
 drivers/staging/iio/magnetometer/hmc5843.c         |  669 ++---
 drivers/staging/iio/meter/ade7753.c                |   31 +-
 drivers/staging/iio/meter/ade7754.c                |   31 +-
 drivers/staging/iio/meter/ade7758_core.c           |   32 +-
 drivers/staging/iio/meter/ade7758_ring.c           |   18 +-
 drivers/staging/iio/meter/ade7759.c                |   30 +-
 drivers/staging/iio/meter/ade7854-i2c.c            |    4 +-
 drivers/staging/iio/meter/ade7854-spi.c            |    4 +-
 drivers/staging/iio/meter/ade7854.c                |   22 +-
 drivers/staging/iio/resolver/ad2s1200.c            |   28 +-
 drivers/staging/iio/resolver/ad2s1210.c            |   34 +-
 drivers/staging/iio/resolver/ad2s90.c              |   16 +-
 drivers/staging/iio/trigger/iio-trig-bfin-timer.c  |   25 +-
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |    4 +-
 drivers/staging/imx-drm/Makefile                   |    2 +-
 drivers/staging/imx-drm/TODO                       |    1 -
 drivers/staging/imx-drm/imx-drm-core.c             |   45 +-
 drivers/staging/imx-drm/imx-drm.h                  |    2 +
 drivers/staging/imx-drm/imx-ldb.c                  |    9 +-
 drivers/staging/imx-drm/imx-tve.c                  |    6 +-
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h        |    4 +-
 drivers/staging/imx-drm/ipu-v3/ipu-common.c        |  175 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c            |   13 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c          |    8 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c            |    2 +-
 drivers/staging/imx-drm/ipuv3-crtc.c               |  211 +-
 drivers/staging/imx-drm/ipuv3-plane.c              |  375 +++
 drivers/staging/imx-drm/ipuv3-plane.h              |   55 +
 drivers/staging/keucr/usb.c                        |    4 +-
 drivers/staging/line6/driver.c                     |    8 +-
 drivers/staging/line6/midi.c                       |    4 +-
 drivers/staging/line6/playback.c                   |    5 +-
 drivers/staging/line6/toneport.c                   |   14 +-
 .../staging/lustre/include/linux/libcfs/bitmap.h   |  110 -
 .../lustre/include/linux/libcfs/libcfs_debug.h     |    8 +-
 .../lustre/include/linux/libcfs/libcfs_hash.h      |  264 +-
 .../staging/lustre/include/linux/lnet/lib-lnet.h   |   90 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    5 +-
 drivers/staging/lustre/lnet/lnet/acceptor.c        |   92 +-
 drivers/staging/lustre/lnet/lnet/config.c          |  102 +-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |  352 +--
 drivers/staging/lustre/lnet/lnet/lo.c              |   20 +-
 drivers/staging/lustre/lnet/lnet/module.c          |   10 +-
 drivers/staging/lustre/lnet/lnet/router_proc.c     |   22 +-
 drivers/staging/lustre/lnet/selftest/brw_test.c    |   91 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c      |   90 +-
 drivers/staging/lustre/lnet/selftest/console.c     |    2 +-
 drivers/staging/lustre/lnet/selftest/timer.c       |   34 +-
 drivers/staging/lustre/lustre/Kconfig              |    2 +-
 drivers/staging/lustre/lustre/fid/fid_request.c    |    4 +-
 drivers/staging/lustre/lustre/fld/fld_cache.c      |    2 +-
 drivers/staging/lustre/lustre/fld/fld_request.c    |    5 -
 drivers/staging/lustre/lustre/include/cl_object.h  |   12 +-
 drivers/staging/lustre/lustre/include/lclient.h    |    4 +-
 .../lustre/lustre/include/linux/lustre_compat25.h  |    3 -
 drivers/staging/lustre/lustre/include/lu_object.h  |    4 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      |   42 +-
 drivers/staging/lustre/lustre/include/lustre_dlm.h |    4 +-
 .../staging/lustre/lustre/include/lustre_export.h  |    4 +-
 drivers/staging/lustre/lustre/include/lustre_fid.h |    2 +-
 .../staging/lustre/lustre/include/lustre_lite.h    |    6 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |    6 +-
 drivers/staging/lustre/lustre/include/obd.h        |   12 +-
 .../staging/lustre/lustre/include/obd_support.h    |   18 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    2 +-
 drivers/staging/lustre/lustre/ldlm/interval_tree.c |   20 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_extent.c   |    2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |    6 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    6 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    6 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |   12 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   34 +-
 drivers/staging/lustre/lustre/libcfs/hash.c        |  250 +-
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |    6 +-
 .../lustre/lustre/libcfs/linux/linux-debug.c       |    2 +-
 drivers/staging/lustre/lustre/libcfs/prng.c        |    4 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |    2 +-
 drivers/staging/lustre/lustre/llite/dir.c          |    2 +-
 drivers/staging/lustre/lustre/llite/file.c         |   10 +-
 drivers/staging/lustre/lustre/llite/llite_close.c  |    2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    4 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |    6 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |    6 +-
 drivers/staging/lustre/lustre/llite/rw.c           |    2 +-
 drivers/staging/lustre/lustre/llite/rw26.c         |    7 +-
 drivers/staging/lustre/lustre/llite/statahead.c    |    2 +-
 drivers/staging/lustre/lustre/llite/vvp_dev.c      |    2 +-
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |   36 +-
 drivers/staging/lustre/lustre/lov/lov_dev.c        |   30 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |    4 +-
 drivers/staging/lustre/lustre/lov/lov_io.c         |    6 +-
 drivers/staging/lustre/lustre/lov/lov_lock.c       |   10 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c        |   36 +-
 drivers/staging/lustre/lustre/lov/lov_object.c     |    4 +-
 drivers/staging/lustre/lustre/lov/lov_pack.c       |   10 +-
 drivers/staging/lustre/lustre/lov/lov_pool.c       |    6 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |   10 +-
 drivers/staging/lustre/lustre/lvfs/fsfilt.c        |   12 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c      |    5 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |   72 +-
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |    6 +-
 drivers/staging/lustre/lustre/obdclass/cl_object.c |    6 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    2 +-
 drivers/staging/lustre/lustre/obdclass/genops.c    |    6 +-
 drivers/staging/lustre/lustre/obdclass/llog_test.c |    6 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |    8 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   53 +-
 .../staging/lustre/lustre/obdclass/obd_config.c    |   22 +-
 drivers/staging/lustre/lustre/obdclass/uuid.c      |    4 +-
 .../staging/lustre/lustre/obdecho/echo_client.c    |    2 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |    4 +-
 drivers/staging/lustre/lustre/osc/osc_io.c         |    2 +-
 drivers/staging/lustre/lustre/osc/osc_lock.c       |    2 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |    2 +-
 drivers/staging/lustre/lustre/osc/osc_quota.c      |    8 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/connection.c  |   10 +-
 drivers/staging/lustre/lustre/ptlrpc/import.c      |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |    8 +-
 drivers/staging/media/go7007/go7007-usb.c          |  109 +-
 drivers/staging/media/lirc/lirc_bt829.c            |    4 +-
 drivers/staging/media/lirc/lirc_imon.c             |    2 +-
 drivers/staging/mt29f_spinand/Kconfig              |   16 +
 drivers/staging/mt29f_spinand/Makefile             |    1 +
 drivers/staging/mt29f_spinand/TODO                 |   13 +
 drivers/staging/mt29f_spinand/mt29f_spinand.c      |  947 ++++++
 drivers/staging/mt29f_spinand/mt29f_spinand.h      |  107 +
 drivers/staging/netlogic/xlr_net.c                 |   34 +-
 drivers/staging/netlogic/xlr_net.h                 |    2 +-
 drivers/staging/nvec/Kconfig                       |    2 +-
 drivers/staging/nvec/nvec.c                        |    2 +-
 drivers/staging/octeon-usb/Makefile                |    4 +-
 drivers/staging/octeon-usb/cvmx-usb.c              | 3158 --------------------
 drivers/staging/octeon-usb/cvmx-usb.h              |  542 ----
 drivers/staging/octeon-usb/cvmx-usbnx-defs.h       |  885 ------
 drivers/staging/octeon-usb/octeon-hcd.c            | 3155 +++++++++++++++++--
 .../octeon-usb/{cvmx-usbcx-defs.h => octeon-hcd.h} |  331 +-
 drivers/staging/octeon/ethernet-rx.c               |   15 +-
 drivers/staging/octeon/ethernet-spi.c              |   92 +-
 drivers/staging/octeon/ethernet-tx.c               |   71 +-
 drivers/staging/octeon/ethernet.c                  |   24 +-
 drivers/staging/olpc_dcon/Kconfig                  |    3 +-
 drivers/staging/olpc_dcon/olpc_dcon.c              |    2 +-
 drivers/staging/quickstart/quickstart.c            |    4 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    2 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |   17 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |  232 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    5 +-
 drivers/staging/rtl8187se/r8180_core.c             |  112 +-
 drivers/staging/rtl8187se/r8180_dm.c               |   98 +-
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        |    6 +-
 drivers/staging/rtl8187se/r8180_wx.c               |   13 +-
 drivers/staging/rtl8187se/r8185b_init.c            |  428 ++-
 drivers/staging/rtl8188eu/Makefile                 |    5 +-
 drivers/staging/rtl8188eu/TODO                     |    1 -
 drivers/staging/rtl8188eu/core/rtw_ap.c            |    2 +-
 drivers/staging/rtl8188eu/core/rtw_br_ext.c        |    5 +-
 drivers/staging/rtl8188eu/core/rtw_cmd.c           |    6 +-
 drivers/staging/rtl8188eu/core/rtw_efuse.c         |   12 +-
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c     |    2 +-
 drivers/staging/rtl8188eu/core/rtw_mlme.c          |   20 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c      |   47 +-
 drivers/staging/rtl8188eu/core/rtw_p2p.c           |    8 +-
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c       |    2 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c          |   25 +-
 drivers/staging/rtl8188eu/core/rtw_security.c      |    2 +-
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c       |    7 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c     |   26 +-
 drivers/staging/rtl8188eu/core/rtw_xmit.c          |    7 +-
 drivers/staging/rtl8188eu/hal/Hal8188EFWImg_CE.c   | 1761 -----------
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |  429 +--
 drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c       |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c       |   16 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |   66 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |    8 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c    |   10 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c     |    2 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |   10 +-
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c      |   98 +-
 .../staging/rtl8188eu/include/Hal8188EFWImg_CE.h   |   28 -
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    2 +-
 drivers/staging/rtl8188eu/include/Hal8188EPhyReg.h |    2 +-
 drivers/staging/rtl8188eu/include/HalPhyRf_8188e.h |    2 -
 drivers/staging/rtl8188eu/include/ieee80211.h      |   16 +-
 drivers/staging/rtl8188eu/include/odm.h            |    4 +-
 drivers/staging/rtl8188eu/include/odm_HWConfig.h   |    4 +-
 drivers/staging/rtl8188eu/include/odm_debug.h      |    2 +-
 drivers/staging/rtl8188eu/include/odm_precomp.h    |    5 -
 drivers/staging/rtl8188eu/include/rtw_cmd.h        |    2 +-
 drivers/staging/rtl8188eu/include/rtw_led.h        |    4 +-
 drivers/staging/rtl8188eu/include/rtw_mlme.h       |   12 +-
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h   |    2 +-
 .../staging/rtl8188eu/include/rtw_mp_phy_regdef.h  |    2 +-
 drivers/staging/rtl8188eu/include/rtw_recv.h       |    2 +-
 drivers/staging/rtl8188eu/include/rtw_rf.h         |    2 +-
 drivers/staging/rtl8188eu/include/sta_info.h       |    2 +-
 drivers/staging/rtl8188eu/include/wifi.h           |    2 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |   23 +-
 drivers/staging/rtl8188eu/os_dep/os_intfs.c        |    7 +-
 drivers/staging/rtl8188eu/os_dep/osdep_service.c   |    5 +-
 drivers/staging/rtl8188eu/os_dep/recv_linux.c      |    6 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |    2 +-
 drivers/staging/rtl8192e/dot11d.c                  |    2 +-
 drivers/staging/rtl8192e/dot11d.h                  |    2 +-
 drivers/staging/rtl8192e/rtl8192e/r8190P_rtl8256.c |    6 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c     |   32 +-
 .../staging/rtl8192e/rtl8192e/r8192E_firmware.c    |    2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c     |    9 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   46 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c         |   17 +-
 drivers/staging/rtl8192e/rtl819x_TSProc.c          |    4 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |   19 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |   30 +-
 drivers/staging/rtl8192e/rtllib_tx.c               |    2 +-
 drivers/staging/rtl8192e/rtllib_wx.c               |    2 +-
 drivers/staging/rtl8192u/dot11d.h                  |  100 -
 drivers/staging/rtl8192u/ieee80211/dot11d.h        |   39 +-
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    3 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |   11 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |   20 +-
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    |    6 +-
 drivers/staging/rtl8192u/ieee80211_crypt.h         |   86 -
 drivers/staging/rtl8192u/r8180_pm.c                |   48 -
 drivers/staging/rtl8192u/r8180_pm.h                |   28 -
 drivers/staging/rtl8192u/r8190_rtl8256.h           |    4 -
 drivers/staging/rtl8192u/r8192U.h                  |   12 -
 drivers/staging/rtl8192u/r8192U_core.c             |   82 +-
 drivers/staging/rtl8192u/r8192U_dm.c               |  278 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |  200 +-
 drivers/staging/rtl8192u/r819xU_HTType.h           |  411 ++-
 drivers/staging/rtl8192u/r819xU_cmdpkt.c           |  103 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.h           |  230 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |   23 +-
 drivers/staging/rtl8192u/r819xU_phy.c              |    8 +-
 drivers/staging/rtl8192u/r819xU_phy.h              |    2 +-
 drivers/staging/rtl8712/os_intfs.c                 |    2 +-
 drivers/staging/rtl8712/rtl8712_cmd.c              |   12 +-
 drivers/staging/rtl8712/rtl8712_efuse.c            |    2 +-
 drivers/staging/rtl8712/rtl8712_recv.c             |    6 +-
 drivers/staging/rtl8712/rtl871x_cmd.c              |    2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |    8 +-
 drivers/staging/rtl8712/rtl871x_ioctl_rtl.c        |    6 +-
 drivers/staging/rtl8712/rtl871x_mlme.c             |    4 +-
 drivers/staging/rtl8712/rtl871x_mp.c               |    8 +-
 drivers/staging/rtl8712/rtl871x_security.c         |    6 +-
 drivers/staging/rtl8712/rtl871x_sta_mgt.c          |    4 +-
 drivers/staging/rtl8712/usb_intf.c                 |   16 +-
 drivers/staging/rtl8712/xmit_linux.c               |    2 +-
 drivers/staging/rts5139/rts51x_scsi.c              |    4 +-
 drivers/staging/sb105x/sb_mp_register.h            |    4 +-
 drivers/staging/sb105x/sb_pci_mp.c                 |   13 +-
 drivers/staging/sbe-2t3e3/cpld.c                   |    2 +-
 drivers/staging/sep/sep_crypto.c                   |    4 +-
 drivers/staging/sep/sep_main.c                     |   32 +-
 drivers/staging/silicom/bp_mod.h                   |    2 +-
 drivers/staging/silicom/bpctl_mod.c                |  188 +-
 drivers/staging/slicoss/slicoss.c                  |  172 +-
 drivers/staging/sm7xxfb/sm7xxfb.c                  |   16 +-
 drivers/staging/speakup/Kconfig                    |    4 +
 drivers/staging/speakup/kobjects.c                 |   80 +-
 drivers/staging/speakup/main.c                     |    2 +-
 drivers/staging/speakup/speakup_acntpc.c           |    2 +-
 drivers/staging/speakup/speakup_apollo.c           |    2 +-
 drivers/staging/speakup/speakup_audptr.c           |    2 +-
 drivers/staging/speakup/varhandlers.c              |    8 +-
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c      |    2 -
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |    4 +-
 drivers/staging/usbip/stub_dev.c                   |   26 +-
 drivers/staging/usbip/stub_main.c                  |    4 +-
 drivers/staging/usbip/userspace/configure.ac       |    1 -
 drivers/staging/usbip/userspace/doc/usbip.8        |    8 +-
 drivers/staging/usbip/userspace/doc/usbipd.8       |   27 +-
 .../staging/usbip/userspace/src/usbip_network.c    |   16 +
 .../staging/usbip/userspace/src/usbip_network.h    |    1 +
 drivers/staging/usbip/userspace/src/usbipd.c       |   69 +-
 drivers/staging/usbip/vhci_hcd.c                   |   10 +-
 drivers/staging/vt6655/80211mgr.c                  |   16 +-
 drivers/staging/vt6655/aes_ccmp.c                  |   20 +-
 drivers/staging/vt6655/baseband.c                  |    7 +-
 drivers/staging/vt6655/bssdb.c                     |   11 +-
 drivers/staging/vt6655/device_main.c               |    4 -
 drivers/staging/vt6655/dpc.c                       |    7 +-
 drivers/staging/vt6655/hostap.c                    |   27 +-
 drivers/staging/vt6655/iwctl.c                     |    6 +-
 drivers/staging/vt6655/key.c                       |   10 +-
 drivers/staging/vt6655/michael.h                   |   10 +-
 drivers/staging/vt6655/rf.c                        |   56 +-
 drivers/staging/vt6655/tkip.c                      |    4 +-
 drivers/staging/vt6655/vntwifi.c                   |   22 -
 drivers/staging/vt6655/wcmd.c                      |    2 +-
 drivers/staging/vt6655/wctl.c                      |    8 +-
 drivers/staging/vt6655/wmgr.c                      |    3 +-
 drivers/staging/vt6655/wpa.c                       |   12 +-
 drivers/staging/vt6655/wpactl.c                    |    2 +-
 drivers/staging/vt6655/wroute.c                    |    2 +-
 drivers/staging/vt6655/wroute.h                    |    2 +-
 drivers/staging/vt6656/aes_ccmp.c                  |   18 +-
 drivers/staging/vt6656/bssdb.c                     |   43 +-
 drivers/staging/vt6656/bssdb.h                     |    2 +-
 drivers/staging/vt6656/channel.c                   |    2 +-
 drivers/staging/vt6656/datarate.c                  |  370 ++-
 drivers/staging/vt6656/desc.h                      |    9 -
 drivers/staging/vt6656/device.h                    |   18 +-
 drivers/staging/vt6656/dpc.c                       |   31 +-
 drivers/staging/vt6656/dpc.h                       |    4 +-
 drivers/staging/vt6656/firmware.c                  |   92 +-
 drivers/staging/vt6656/hostap.c                    |    4 +-
 drivers/staging/vt6656/iwctl.c                     |   77 +-
 drivers/staging/vt6656/key.c                       |   10 +-
 drivers/staging/vt6656/main_usb.c                  |   52 +-
 drivers/staging/vt6656/power.c                     |   11 +-
 drivers/staging/vt6656/rxtx.c                      |  848 +++---
 drivers/staging/vt6656/rxtx.h                      |   47 +-
 drivers/staging/vt6656/usbpipe.c                   |    8 +-
 drivers/staging/vt6656/wcmd.c                      |   78 +-
 drivers/staging/vt6656/wcmd.h                      |   11 +-
 drivers/staging/vt6656/wctl.c                      |    7 +-
 drivers/staging/vt6656/wmgr.c                      |   34 +-
 drivers/staging/vt6656/wmgr.h                      |    3 -
 drivers/staging/vt6656/wpactl.c                    |    2 +-
 drivers/staging/winbond/core.h                     |    8 +-
 drivers/staging/winbond/mds.c                      |    4 +-
 drivers/staging/winbond/mto.c                      |    7 +-
 drivers/staging/winbond/mto.h                      |    8 +-
 drivers/staging/winbond/phy_calibration.c          |  369 +--
 drivers/staging/winbond/reg.c                      |  121 +-
 drivers/staging/winbond/wb35tx.c                   |    2 +-
 drivers/staging/winbond/wbusb.c                    |    6 +-
 drivers/staging/wlags49_h2/hcf.h                   |   22 +-
 drivers/staging/wlags49_h2/sta_h2.c                |    4 +-
 drivers/staging/wlan-ng/cfg80211.c                 |   65 +-
 drivers/staging/wlan-ng/hfa384x_usb.c              |   90 +-
 drivers/staging/wlan-ng/p80211netdev.h             |    2 +-
 drivers/staging/wlan-ng/p80211wep.c                |    6 +-
 drivers/staging/xgifb/XGI_main_26.c                |    1 -
 drivers/staging/xgifb/vb_setmode.c                 |   11 +-
 drivers/staging/xgifb/vb_table.h                   |    2 +-
 drivers/staging/xillybus/Kconfig                   |    4 +-
 drivers/staging/xillybus/xillybus_core.c           |  153 +-
 drivers/staging/xillybus/xillybus_of.c             |   27 +-
 drivers/staging/xillybus/xillybus_pcie.c           |   27 +-
 drivers/staging/zram/zram_drv.c                    |   15 +-
 drivers/staging/zsmalloc/Kconfig                   |    1 +
 include/linux/hid-sensor-hub.h                     |   18 +
 include/linux/iio/buffer.h                         |   61 +-
 include/linux/iio/common/st_sensors.h              |    6 +
 include/linux/iio/consumer.h                       |    2 +-
 include/linux/iio/events.h                         |   14 -
 include/linux/iio/iio.h                            |   93 +-
 include/linux/iio/sysfs.h                          |   15 +
 include/linux/iio/types.h                          |   20 +
 include/linux/mfd/ti_am335x_tscadc.h               |    9 +
 687 files changed, 24003 insertions(+), 22397 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/light/cm36651.txt
 create mode 100644 Documentation/devicetree/bindings/iio/light/gp2ap020a00f.txt
 create mode 100644 drivers/iio/adc/mcp3422.c
 create mode 100644 drivers/iio/light/cm36651.c
 create mode 100644 drivers/iio/light/gp2ap020a00f.c
 create mode 100644 drivers/iio/light/tcs3472.c
 create mode 100644 drivers/iio/light/tsl4531.c
 create mode 100644 drivers/iio/magnetometer/mag3110.c
 create mode 100644 drivers/staging/dwc2/TODO
 create mode 100644 drivers/staging/et131x/Module.symvers
 create mode 100644 drivers/staging/imx-drm/ipuv3-plane.c
 create mode 100644 drivers/staging/imx-drm/ipuv3-plane.h
 create mode 100644 drivers/staging/mt29f_spinand/Kconfig
 create mode 100644 drivers/staging/mt29f_spinand/Makefile
 create mode 100644 drivers/staging/mt29f_spinand/TODO
 create mode 100644 drivers/staging/mt29f_spinand/mt29f_spinand.c
 create mode 100644 drivers/staging/mt29f_spinand/mt29f_spinand.h
 delete mode 100644 drivers/staging/octeon-usb/cvmx-usb.c
 delete mode 100644 drivers/staging/octeon-usb/cvmx-usb.h
 delete mode 100644 drivers/staging/octeon-usb/cvmx-usbnx-defs.h
 rename drivers/staging/octeon-usb/{cvmx-usbcx-defs.h => octeon-hcd.h} (83%)
 delete mode 100644 drivers/staging/rtl8188eu/hal/Hal8188EFWImg_CE.c
 delete mode 100644 drivers/staging/rtl8188eu/include/Hal8188EFWImg_CE.h
 delete mode 100644 drivers/staging/rtl8192u/dot11d.h
 delete mode 100644 drivers/staging/rtl8192u/ieee80211_crypt.h
 delete mode 100644 drivers/staging/rtl8192u/r8180_pm.c
 delete mode 100644 drivers/staging/rtl8192u/r8180_pm.h
