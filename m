Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3GARSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:18:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3GARSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:18:00 -0400
Date: Mon, 1 Jul 2013 10:17:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver patches for 3.11-rc1
Message-ID: <20130701171759.GA25767@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ staging-next

for you to fetch changes up to 0ad1ea69545b1965be4c93ee03fdc685c6beb23d:

  Revert "Revert "Revert "staging/lustre: drop CONFIG_BROKEN dependency""" (2013-06-24 16:47:45 -0700)

----------------------------------------------------------------
Staging tree merge for 3.11-rc1

Here's the large staging tree merge for 3.11-rc1

Huge thing here is the Lustre client code.  Unfortunatly, due to it not
building properly on a wide variety of different architectures (this was
production code???), it is currently disabled from the build so as to
not annoy people.

Other than Lustre, there are loads of comedi patches, working to clean
up that subsystem, iio updates and new drivers, and a load of cleanups
from the OPW applicants in their quest to get a summer internship.

All of these have been in the linux-next releases for a while (hence the
Lustre code being disabled.)

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (46):
      staging: xgifb: refactor XGI_BridgeIsOn()
      staging: xgifb: XGI_GetVBType(): delete IF_DEF_LVDS check
      staging: xgifb: call XGI_GetVBType from InitTo330Pointer
      staging: xgifb: XGI_AjustCRT2Rate(): delete IF_DEF_LVDS check
      staging: xgifb: XGI_GetRatePtrCRT2(): delete IF_DEF_LVDS check
      staging: xgifb: XGI_SetCRT1VCLK(): avoid copy-paste
      staging: xgifb: SetFlag: delete GatingCRT
      staging: xgifb: SetFlag: delete DisableChB
      staging: xgifb: SetFlag: delete EnableChB
      staging: xgifb: SetFlag: delete DisableChA
      staging: xgifb: SetFlag: delete EnableChA
      staging: xgifb: XGI_EnableChISLCD(): delete trivial function
      staging: xgifb: XGI_DisableBridge(): delete redundant checks
      staging: xgifb: delete redundant return statements
      staging: xgifb: vb_setmode: delete IF_DEF_YPbPr checks
      staging: xgifb: vb_setmode: delete IF_DEF_HiVision checks
      staging: xgifb: vb_setmode: delete IF_DEF_CRT2Monitor checks
      staging: MIPS: add Octeon USB HCD support
      staging: octeon-usb: cvmx-usbcx-defs.h: delete unused data types
      staging: octeon-usb: cvmx-usbcx-defs.h: delete unused union members
      staging: octeon-usb: cvmx-usbcx-defs.h: fix brace placement
      staging: octeon-usb: cvmx-usbcx-defs.h: fix struct indentation
      staging: octeon-usb: cvmx-usbcx-defs.h: fix comment style
      staging: octeon-usb: cvmx-usbcx-defs.h: delete unused macros
      staging: octeon-usb: cvmx-usbcx-defs.h: clean up macros
      staging: octeon-usb: cvmx-usbcx-defs.h: avoid long lines in comments
      staging: octeon-usb: cvmx-usbcx-defs.h: delete CVS keyword marker
      staging: octeon-usb: cvmx-usbcx-defs.h: reformat license text to fit 80 cols
      staging: octeon-usb: cvmx-usbnx-defs.h: delete unused data types
      staging: octeon-usb: cvmx-usbnx-defs.h: delete unused union members
      staging: octeon-usb: cvmx-usbnx-defs.h: fix brace placement
      staging: octeon-usb: cvmx-usbnx-defs.h: fix struct indentation
      staging: octeon-usb: cvmx-usbnx-defs.h: fix comment style
      staging: octeon-usb: cvmx-usbnx-defs.h: delete unused macros
      staging: octeon-usb: cvmx-usbnx-defs.h: clean up macros
      staging: octeon-usb: cvmx-usbnx-defs.h: delete CVS keyword marker
      staging: octeon-usb: cvmx-usbnx-defs.h: reformat license text to fit 80 cols
      staging: octeon-usb: cvmx-usbnx-defs.h: reformat a comment
      staging: octeon-usb: octeon-hcd: use tabs for code indent
      staging: octeon-usb: octeon-hcd: add missing braces
      staging: octeon-usb: octeon-hcd: fix some includes
      staging: octeon-usb: octeon-hcd: make internal variable static
      staging: octeon-usb: octeon-hcd: use dev_dbg
      staging: octeon-usb: octeon-hcd: reformat long comments
      staging: octeon-usb: octeon-hcd: delete commented-out code
      staging: octeon-usb: octeon-hcd: eliminate printk()s

Aida Mynzhasova (1):
      staging:iio:adc: Use kstrtol()/kstrtoul()

Aldo Iljazi (1):
      Staging: ft1000-pcmcia: ft1000_dnld.c: fixed four checkpatch

Alex Zhuravlev (1):
      staging/lustre/fids: fix compilation error with gcc 4.7.2

Alexandre Relange (2):
      iio: Correct HID light sensor name in comments
      iio: ABI doc: update scan_elements sysfs paths

Alexey Khoroshilov (2):
      staging: wlags49_h2: fix error handling in pcmcia probe function
      staging: ft1000: fix memory leak on error path in ft1000_probe()

Amarjargal Gundjalam (20):
      staging/crystalhd: Fixes line over 80 characters warning in crystalhd_fw_if.h
      staging/crystalhd: Fixes line over 80 characters warning in crystalhd_cmds.*
      staging/crystalhd: Fixes line over 80 characters warning in crystalhd_lnx.*
      staging/crystalhd: Fixes line over 80 characters warning in crystalhd_misc.*
      staging/crystalhd: Fixes line over 80 characters warning in crystalhd_hw.*
      staging/crystalhd: Fixes line over 80 characters warning in bc_dts_glob_lnx.h
      keucr: Fixes return is not a function error in smilmain.c
      keucr: fixes open brace should be on the previous line error
      keucr: fixes else should follow close brace error
      keucr: fixes open brace go on the next line error
      keucr: fixes space required after error
      keucr: fixes space required before open parenthesis error
      keurc: fixes spaces required around error
      keucr: fixed space prohibited between warning
      keucr: fixes space prohibited before warning
      keucr: removes unused code from smilmain.c
      keucr: fixes do not use C99 // comments error
      keucr: fixes no spaces at the start of a line warning
      keucr: fixes trailing whitespace error
      keucr: fixes line over 80 characters warning

Andreas Dilger (4):
      staging/lustre/debug: quiet noisy console error messages
      staging/lustre/lov: only dump header in lsm_lmm_verify
      staging/lustre/changelog: fix CL_LAYOUT, accept all types
      staging/lustre/changelog: fix CL_LAYOUT comment, string

Andres More (1):
      staging: vt6656: remove unused definitions

Arnd Bergmann (1):
      staging: line6: avoid __sync_fetch_and_{and,or}

Artem Blagodarenko (1):
      staging/lustre/ost: Ensure dirty flushed on fiemap ioctl

Ben Chan (2):
      staging: gdm72xx: WIMAX_GDM72XX should depend on either USB or MMC
      staging: gdm72xx: fix typos in Kconfig

Bernd Bassimir (2):
      staging: serqt_usb2: Fixed coding style CamelCases
      staging: serqt_usb2: lines over 80 characters fixed

Bobi Jam (1):
      staging/lustre/osc: some cleanup to reduce stack overflow chance

Chad Williamson (9):
      Staging: silicom: remove the EXPORT_SYMBOL_NOVERS macro
      Staging: silicom: move symbol exports beneath definitions in bypass.c
      Staging: silicom: move symbol exports beneath definitions in bpctl_mod.c
      Staging: silicom: remove unnecessary braces in bpctl_mod.c
      Staging: silicom: move assignments out of if conditions
      Staging: silicom: move more assignments out of if conditions
      Staging: silicom: remove bp_media_type enum typedef
      Staging: silicom: capitalize labels in the bp_media_type enum
      Staging: silicom: remove the board_t typedef in bpctl_mod.c

Chen Gang (4):
      staging: wlags49_h2: strncpy, need checking the memory length
      staging: for dgrp, let nd_ps_desc always NUL terminated string within MAX_DESC_LEN length
      staging: wlags49_h2: fix up "205179d staging: wlags49_h2: strncpy, need checking the memory length" for avoiding warnings
      drivers: staging: dgrp: using time_is_before_jiffies() instead of open coding 'jiffies'

Cho, Yu-Chen (1):
      Staging: add USB MTK bluetooth driver

Cyril Roelandt (1):
      staging: lustre: fix return type of lo_release.

Dan Carpenter (7):
      staging: speakup: cleanup spk_var_header_by_name()
      Staging: rtl8192e: delete some dead cruft
      Staging: rtl8192e: printing the wrong array
      Staging: rtl8192e: fix an endian bug
      Staging: crystalhd: remove an unneeded NULL check
      Staging: rtl8192u: fix a reversed test
      staging: vt6655: info leak in ioctl

Dave Jones (2):
      staging/rtl8187se: Convert __list_for_each use to list_for_each
      staging/rtl8192u: remove commented out __list_for_each usage

Davis Abubakr-Sadik Nii Nai (3):
      Staging: csr: fix indentation style issue in bh.c
      staging: csr: fix indentation code style issue in csr_framework_ext.c
      staging: csr: fix indentation coding style issue in csr_framework_ext.h

Denis CIOCCA (3):
      iio:common: ST_SENSORS_LSM_CHANNELS macro changed
      iio:common: Removed stuff macros, added num_data_channels on st_sensors struct and added support on one-shot sysfs reads to 3 byte channel
      iio:pressure: Add STMicroelectronics pressures driver

Devendra Naga (8):
      staging: btmtk_usb: check for a valid io_buf pointer
      staging: btmtk_usb: use GFP_KERNEL inplace of GFP_ATOMIC in _probe path
      staging: octeon-usb: place opening braces of structs, enums on top
      staging: octeon-usb: fix checkpatch error
      staging: octeon-usb: more checkpatch fixes
      staging: octeon-usb: fix more checkpatch errors/warns
      staging: octeon-usb: check return value of platform_device_register_simple
      staging: octeon-usb: call device_unregister when platform_device_register_simple fails

Dulshani Gunawardhana (6):
      Staging: cxt1e1: Replacing asm/io.h with linux/io.h
      Staging/cxt1e1/comet.c:Fixes space between function name and parenthesis
      Staging/cxt1e1/comet.c:Fixes indentation errors
      Staging/cxt1e1/comet.c:Modifying comment style and intentation
      Staging/cxt1e1:Fixing foo * bar should be foo *bar
      Staging/cxt1e1:Removing parantheses surrounding return argument

Dylan Socolobsky (2):
      Staging: ft1000: fix brace coding style in ft1000_dnld.c
      Staging: ft1000: Change C99 comments in ft1000_dnld.c

Eduardo Valentin (2):
      staging: ti-soc-thermal: update DT reference for OMAP5430
      staging: ti-soc-thermal: remove external heat while extrapolating hotspot

Elena Ufimtseva (10):
      staging: ced1401: Fixes checkpatch warnings about pointer format
      Staging: ced1401: Fixes C99 // comments.
      Staging: ced1401: Fixes C pointer format warnings
      Staging: ced1401: Fixes white spaces and indentations.
      Staging: ced1401: Fixes 'open brace should be on the previous line'.
      Staging: ced1401: Fixes trailing whitespace checkpath warning.
      Staging: ced1401: Patch fixes missing parentheses in macro definitions.
      Staging: ced1401: Patch removes typedef unsigned short WORD.
      Staging: ced1401: Patch removes typedef unsigned int DWORD.
      Staging: ced1401: Patch removes unused typedefs.

Emil Goode (1):
      staging: speakup: fix warnings by adding __user annotations

Emoly Liu (1):
      staging/lustre/mdt: set ATTR_xTIME_SET to make atime update properly

Fabio Estevam (2):
      imx-drm: imx-tve: Let device core handle pinctrl
      imx-drm: parallel-display: Let device core handle pinctrl

Federico Vaga (1):
      staging: dwc2/pci.c: add STMICRO vendor and device ID for STA2X11 board

Greg Kroah-Hartman (13):
      Merge tag 'iio-for-3.11a' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.10-rc3 into staging-next
      staging: android: sync: fix up a sparse warning
      Revert "ozwpan: replace kfree_skb with dev_kfree_skb in ozproto.c"
      Revert "ozwpan: replace kfree_skb with dev_kfree_skb in ozpd.c"
      Revert "ozwpan: replace alloc_skb with dev_alloc_skb in ozproto.c"
      Revert "ozwpan: replace alloc_skb with dev_alloc_skb in ozpd.c"
      Revert "staging/lustre: drop CONFIG_BROKEN dependency"
      Merge tag 'iio-for-3.11b' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.10-rc5 into staging-next
      Merge tag 'iio-for-3.11c' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.10-rc6 into staging-next
      Revert "Revert "Revert "staging/lustre: drop CONFIG_BROKEN dependency"""

Güngör Erseymen (2):
      staging: comedi: remove 'bc.subdevice < 0' check in do_bufconfig_ioctl()
      staging: comedi: remove 'bi.subdevice < 0' check in do_bufinfo_ioctl()

H Hartley Sweeten (317):
      staging: comedi: ni_labpc: remove 'device_id' from boardinfo
      staging: comedi: ni_labpc: cleanup true/false flags in boardinfo
      staging: comedi: ni_labpc: remove range_labpc_1200_ai export
      staging: comedi: remove FSF address from boilerplate text
      staging: comedi: ni_labpc: remove *_ai_gain_bits tables
      staging: comedi: usbduxfast: request firmware synchronously
      staging: comedi: usbduxfast: remove COMEDI_DEBUG noise in usb (*probe)
      staging: comedi: usbduxfast: use a local var for the usbduxfastsub_s
      staging: comedi: usbduxfast: rename usb_interface variables
      staging: comedi: usbduxfast: rename usb_device variables
      staging: comedi: usbduxfast: rename usbduxfastsub_s variables
      staging: comedi: usbduxfast: remove 'owner' from usb_driver
      staging: comedi: usbduxfast: tidy up usbduxfast_attach_common()
      staging: comedi: usbduxfast: remove all COMEDI_DEBUG messages
      staging: comedi: usbduxfast: tidy up usbduxfastsub_ai_Irq()
      staging: comedi: usbduxfast: Use comedi_usb_auto_unconfig() for (*disconnect)
      staging: comedi: usbduxfast: Move usb_driver (*probe) into comedi_driver
      staging: comedi: usbduxfast: remove some unused defines
      staging: comedi: usbduxfast: absorb tidy_up() into the (*detach)
      staging: comedi: usbduxfast: remove 'probed' from private data
      staging: comedi: usbduxfast: remove 'attached' from private data
      staging: comedi: usbduxfast: remove 'ifnum' from private data
      staging: comedi: usbduxfast: don't pass the private data directly
      staging: comedi: usbduxfast: remove 'comedidev' from the private data
      staging: comedi: usbduxfast: use dev->class_dev for all dev_{level} messages
      staging: comedi: usbduxfast: remove 'intf' from the private data
      staging: comedi: usbduxfast: remove 'usb' from the private data
      staging: comedi: usbduxfast: rename 'urbIn' in private data
      staging: comedi: usbduxfast: rename 'insnBuffer' from private data
      staging: comedi: usbduxfast: rename 'transfer_buffer' in private data
      staging: comedi: usbduxfast: rename 'dux_commands' in private data
      staging: comedi: usbduxfast: remove extra dev_err() messages
      staging: comedi: usbduxfast: tidy up send_dux_commands()
      staging: comedi: usbduxfast: tidy up usbduxfastsub_unlink_InURBs()
      staging: comedi: usbduxfast: tidy up usbduxfast_ai_stop()
      staging: comedi: usbduxfast: tidy up usbduxfast_ai_cancel()
      staging: comedi: usbduxfast: fix a > 80 char line issue
      staging: comedi: usbduxfast: tidy up firmwareUpload()
      staging: comedi: usbduxfast: move usbduxfast_upload_firmware()
      staging: comedi: usbduxfast: consolidate the firmware upload
      staging: comedi: usbduxfast: rename CamelCase 'minSamplPer'
      staging: comedi: usbduxfast: rename usbduxfastsub_submit_InURBs()
      staging: comedi: usbduxfast: introduce usbduxfast_cmd_data()
      staging: comedi: usbduxfast: tidy up usbduxfast_ai_insn_read()
      staging: comedi: dt9812: move the usb framework functions to EOF
      staging: comedi: dt9812: rename the private data struct
      staging: comedi: dt9812: rename 'comedi' variable in struct slot_dt9812
      staging: comedi: dt9812: remove attaching by serial number
      staging: comedi: dt9812: tidy up usb_bulk_msg() calls
      staging: comedi: dt9812: pass the comedi_device * to dt9812_digital_in()
      staging: comedi: dt9812: pass the comedi_device * to dt9812_digital_out()
      staging: comedi: dt9812: pass the comedi_device * to dt9812_digital_out_shadow()
      staging: comedi: dt9812: pass the comedi_device * to dt9812_analog_in()
      staging: comedi: dt9812: pass the comedi_device * to dt9812_configure_gain()
      staging: comedi: dt9812: pass the comedi_device * to dt9812_configure_mux()
      staging: comedi: dt9812: pass the comedi_device * to dt9812_analog_out()
      staging: comedi: dt9812: tidy up the usb endpoint enumeration
      staging: comedi: dt9812: pass the comedi_device * to dt9812_analog_out_shadow()
      staging: comedi: dt9812: move the sempaphore used by the comedi_driver
      staging: comedi: dt9812: use module_comedi_usb_driver()
      staging: comedi: dt9812: move shadow values to private data
      staging: comedi: dt9812: remove 'interface' from usb private data
      staging: comedi: dt9812: factor the endpoint setup out of dt9812_probe()
      staging: comedi: dt9812: factor the device reset out of dt9812_probe()
      staging: comedi: dt9812: convert to use comedi (*auto_attach)
      staging: comedi: dt9812: remove unused variables from private data
      staging: comedi: dt9812: convert digital in subdevice to (*insn_bits)
      staging: comedi: dt9812: convert digital out subdevice to (*insn_bits)
      staging: comedi: dt9812: cleanup analog in subdevice (*insn_read)
      staging: comedi: dt9812: cleanup analog out subdevice (*insn_read)
      staging: comedi: dt9812: cleanup analog out subdevice (*insn_write)
      staging: comedi: dt9812: remove pr_fmt()
      staging: comedi: dt9812: use dev->class_dev for all dev_{level} messages
      staging: comedi: dt9812: remove some #if 0'ed out code
      staging: comedi: dt9812: usb_bulk_msg() timeout is in milliseconds
      staging: comedi: dt9812: default the analog input gain to 1
      staging: comedi: dt9812: do not allow attaching to unsupported devices
      staging: comedi: jr3_pci: use kasprintf
      staging: comedi: jr3_pci: tidy up comedi_load_firmware()
      staging: comedi: drivers: generalize comedi_load_firmware()
      staging: comedi: daqboard2000: use comedi_load_firmware()
      staging: comedi: me_daq: use comedi_load_firmware()
      staging: comedi: ni_pcidio: use comedi_load_firmware()
      staging: comedi: introduce comedi_to_usb_dev()
      staging: comedi: usbduxfast: use comedi_to_usb_dev()
      staging: comedi: vmk80xx: don't pass the private data directly
      staging: comedi: vmk80xx: use comedi_to_usb_dev()
      staging: comedi: vmk80xx: remove usb_interface from private data
      staging: comedi: dt9812: use comedi_to_usb_dev()
      staging: comedi: usbduxfast: use comedi_load_firmware()
      staging: comedi: usbdux: request firmware synchronously
      staging: comedi: usbdux: consolidate the firmware upload
      staging: comedi: usbdux: move firmware request/upload into (*auto_attach)
      staging: comedi: usbdux: use comedi_load_firmware()
      staging: comedi: usbduxsigma: request firmware synchronously
      staging: comedi: usbduxsigma: consolidate the firmware upload
      staging: comedi: usbduxsigma: move firmware request/upload into (*auto_attach)
      staging: comedi: usbduxsigma: use comedi_load_firmware()
      staging: comedi: usbduxsigma: remove function trace noise
      staging: comedi: usbduxsigma: remove unlink urb debug messages
      staging: comedi: usbduxsigma: cleanup the unlink urb functions
      staging: comedi: usbduxsigma: cleanup the stop functions
      staging: comedi: usbduxsigma: change return type of the stop functions
      staging: comedi: usbduxsigma: remove check of 'probed' in (*cancel) functions
      staging: comedi: usbduxsigma: cleanup the (*cancel) functions
      staging: comedi: usbduxsigma: use usbdux_ai_stop() to force unlink all urbs
      staging: comedi: usbduxsigma: absorb usbduxsub_unlink_InURBs() into caller
      staging: comedi: usbduxsigma: use usbdux_ao_stop() to force unlink all urbs
      staging: comedi: usbduxsigma: absorb usbduxsub_unlink_OutURBs() into caller
      staging: comedi: usbduxsigma: use usbdux_pwm_stop() to force unlink urb
      staging: comedi: usbduxsigma: absorb usbduxsub_unlink_PwmURBs() into caller
      staging: comedi: usbduxsigma: tidy up usbduxsub_ai_IsocIrq()
      staging: comedi: usbduxsigma: tidy up usbduxsub_ao_IsocIrq()
      staging: comedi: usbduxsigma: remove dev_{level} messages in submit urbs functions
      staging: comedi: usbduxsigma: generalize the usb_submit_urb functions
      staging: comedi: usbduxsigma: remove 'probed' checks in comedi functions
      staging: comedi: usbduxsigma: tidy up usbduxsub_pwm_irq()
      staging: comedi: usbduxsigma: rename the private data struct
      staging: comedi: usbduxsigma: tidy up usbduxsigma_usb_probe()
      staging: comedi: usbduxsigma: factor usb buffer allocation out of (*probe)
      staging: comedi: usbduxsigma: push usb (*disconnect) into comedi (*detach)
      staging: comedi: usbduxsigma: push usb (*probe) into comedi (*auto_attach)
      staging: comedi: usbduxsigma: remove NOISY_DUX_DEBUGBUG
      staging: comedi: usbduxsigma: tidy up send_dux_commands()
      staging: comedi: usbduxsigma: tidy up receive_dux_commands()
      staging: comedi: usbduxsigma: tidy up usbduxsub_submit_PwmURBs()
      staging: comedi: usbduxsigma: remove 'comedidev' from the private data
      staging: comedi: usbduxsigma: remove 'usbdev' from the private data
      staging: comedi: usbduxsigma: tidy up firmware upload error messages
      staging: comedi: usbduxsigma: remove private data sanity checks
      staging: comedi: usbduxsigma: tidy up usbdux_ao_inttrig()
      staging: comedi: usbduxsigma: tidy up usbdux_ai_inttrig()
      staging: comedi: usbduxsigma: remove unnecessary check in usbdux_ai_cmd()
      staging: comedi: usbduxsigma: remove unnecessary check in usbdux_ao_cmd()
      staging: comedi: usbduxsigma: remove SUBDEV_* defines
      staging: comedi: usbduxsigma: tidy up usbduxsigma_attach_common()
      staging: comedi: usbduxsigma: tidy up usbdux_getstatusinfo()
      staging: comedi: usbduxsigma: remove tidy_up() from (*auto_attach)
      staging: comedi: usbduxsigma: move usb_set_intfdata(intf, NULL) to (*detach)
      staging: comedi: usbduxsigma: kill all urbs before freeing them
      staging: comedi: usbduxsigma: tidy up tidy_up()
      staging: comedi: usbduxsigma: remove an extra ';'
      staging: comedi: usbduxsigma: move usbduxsigma_firmware_upload()
      staging: comedi: usbduxsigma: tidy up usbduxsigma_pwm_config()
      staging: comedi: usbduxsigma: remove usbdux_pwm_read()
      staging: comedi: usbduxsigma: tidy up usbdux_pwm_write()
      staging: comedi: usbduxsigma: tidy up usbdux_pwm_pattern()
      staging: comedi: usbduxsigma: tidy up usbdux_pwm_start()
      staging: comedi: usbduxsigma: tidy up usbdux_dio_insn_bits()
      staging: comedi: usbduxsigma: tidy up usbdux_dio_insn_config()
      staging: comedi: usbduxsigma: remove some dev_{level} noise
      staging: comedi: usbduxsigma: remove 'interface' from the private data
      staging: comedi: usbduxsigma: change private data flags to bit fields
      staging: comedi: usbduxsigma: tidy up usbdux_pwm_period()
      staging: comedi: usbduxsigma: rename usbdux_pwm_irq()
      staging: comedi: usbduxsigma: rename usbdux_pwm_cancel()
      staging: comedi: usbduxsigma: rename usbdux_pwm_stop()
      staging: comedi: usbduxsigma: tidy up analog output command support
      staging: comedi: usbduxsigma: tidy up analog output (*insn_{read, write})
      staging: comedi: usbduxsigma: cleanup the private data 'outBuffer'
      staging: comedi: usbduxsigma: tidy up usbdux_ai_insn_read()
      staging: comedi: usbduxsigma: tidy up analog input command support
      staging: comedi: usbduxsigma: check for invalid 'ao_timer' in all cases
      staging: comedi: usbduxsigma: rename {send,receive}_dux_commands()
      staging: comedi: usbduxsigma: rename the urb completion handlers
      staging: comedi: usbduxsigma: rename the (*cancel) functions
      staging: comedi: usbduxsigma: rename usbdux_{ai,ao}_stop() functions
      staging: comedi: usbduxsigma: cleanup comedi_lrange table
      staging: comedi: usbduxsigma: tidy up the usb endpoint defines
      staging: comedi: usbduxsigma: remove some unused defines
      staging: comedi: usbduxsigma: rename CamelCase vars in private data
      staging: comedi: usbduxsigma: add missing spaces reported by checkpatch.pl
      staging: comedi: usbduxsigma: tidy up chanToInterval()
      staging: comedi: usbduxsigma: remove a space before tab
      staging: comedi: usbduxsigma: tidy up the multi-line comments
      staging: comedi: Kconfig: COMEDI_S526 is a PC/104 board not a PCI board
      staging: comedi: ni_daq_700: fix some trailing whitespace errors
      staging: comedi: pcmuio: remove 'subpriv' macro
      staging: comedi: pcmuio: refactor interrupt_pcmuio()
      staging: comedi: pcmuio: tidy up the multi-line comments
      staging: comedi: pcmuio: remove 'CALC_N_SUBDEVS' macro
      staging: comedi: pcmuio: tidy up driver #define's
      staging: comedi: pcmuio: tidy up the boardinfo
      staging: comedi: pcmuio: remove some boilerplate comments
      staging: comedi: pcmuio: fix > 80 char line warnings
      staging: comedi: pcmuio: remove the pcmuio_dio_insn_bits() debug noise
      staging: comedi: pcmuio: fix the last > 80 char line warning
      staging: comedi: pcmda12: remove 'BITS' define
      staging: comedi: pcmda12: tidy up comedi_lrange table
      staging: comedi: pcmda12: tidy up subdevice init
      staging: comedi: pcmda12: rename the analog output (*insn_{read, write}) functions
      staging: comedi: pcmda12: cleanup pcmda12_ao_insn_read()
      staging: comedi: pcmda12: cleanup pcmda12_ao_insn_write()
      staging: comedi: pcmda12: remove {LSB,MSB}_PORT macros
      staging: comedi: pcmda12: tidy up zero_chans()
      staging: comedi: pcmda12: remove 'IOSIZE' define
      staging: comedi: pcmda12: return 0 for successful attach
      staging: comedi: pcmda12: tidy up multi-line comments
      staging: comedi: pcmad: tidy up multi-line comments
      staging: comedi: pcmad: move the boardinfo
      staging: comedi: pcmad: return errno if AI conversion times out
      staging: comedi: pcmad: remove need for boardinfo in pcmad_ai_insn_read()
      staging: comedi: pcmad: tidy up pcmad_ai_insn_read()
      staging: comedi: pcmad: tidy up pcmad_attach()
      staging: comedi: pcmad: change boardinfo 'n_ai_bits' to 'ai_maxdata'
      staging: comedi: pcmad: properly handle single/diff input configuration
      staging: comedi: pcmad: properly handle analog input encoding configuration
      staging: comedi: pcmad: fix analog input data on pcmad12
      staging: comedi: pcmad: remove unnecessary includes
      staging: comedi: introduce comedi_range_is_{bi,uni}polar()
      staging: comedi: pcl730: tidy up the boardinfo
      staging: comedi: pcl730: tidy up pcl730_do_insn()
      staging: comedi: pcl730: tidy up pcl730_di_insn()
      staging: comedi: pcl730: tidy up pcl730_attach()
      staging: comedi: pcl730: rename the boardinfo table
      staging: comedi: pcl730: tidy up multi-line comment
      staging: comedi: pcl730: add support for the PCM-3730 PC/104 board
      staging: comedi: pcl730: add support for the PCL-725 ISA board
      staging: comedi: pcl730: add support for the PCL-733 ISA board
      staging: comedi: pcl730: add support for the PCL-734 ISA board
      staging: comedi: pcl730: add support for the ACL-7225b ISA board
      staging: comedi: pcl730: add support for the P8R8-DIO ISA board
      staging: comedi: pcl730: clean up the register map documentation
      staging: comedi: pcl724: remove interrupt support
      staging: comedi: pcl724: tidy up the boardinfo
      staging: comedi: pcl724: remove all '= 0' boardinfo
      staging: comedi: pcl724: tidy up the boardinfo struct definition
      staging: comedi: pcl724: tidy up subdev_8255_init() calls
      staging: comedi: pcl724: tidy up pcl724_attach()
      staging: comedi: pcl724: remove 'dio' from boardinfo
      staging: comedi: pcl724: tidy up multi-line comments
      staging: comedi: pcl724: fix 96 DIO configuration option
      staging: comedi: pcl724: update the MODULE_DESCRIPTION
      staging: comedi: drivers: let core handle freeing s->private
      staging: comedi: addi_apci_3xxx: clean up i_APCI3XXX_Reset()
      staging: comedi: addi_apci_3xxx: separate from addi_common.c
      staging: comedi: addi_apci_3xxx: absorb apci3xxx_reset()
      staging: comedi: addi_apci_3xxx: absorb apci3xxx_do_insn_bits()
      staging: comedi: addi_apci_3xxx: absorb apci3xxx_di_insn_bits()
      staging: comedi: addi_apci_3xxx: tidy up v_APCI3XXX_Interrupt()
      staging: comedi: addi_apci_3xxx: absorb v_APCI3XXX_Interrupt()
      staging: comedi: addi_apci_3xxx: absorb the private comedi_lrange tables
      staging: comedi: addi_apci_3xxx: simplify the PCI bar reading
      staging: comedi: addi_apci_3xxx: driver does not use dma
      staging: comedi: addi_apci_3xxx: boards do not have a timer
      staging: comedi: addi_apci_3xxx: boards do not have an eeprom
      staging: comedi: addi_apci_3xxx: digital output 'maxdata' is always '1'
      staging: comedi: addi_apci_3xxx: remove need for s_EeParameters
      staging: comedi: addi_apci_3xxx: remove (*insn_*) callbacks from boardinfo
      staging: comedi: addi_apci_3xxx: introduce a private boardinfo definition
      staging: comedi: addi_apci_3xxx: introduce a local private data definition
      staging: comedi: addi_apci_3xxx: remove COMEDI_SUBD_TTLIO
      staging: comedi: addi_apci_3xxx: remove some unused includes
      staging: comedi: addi_apci_3xxx: move the copyright info to the driver
      staging: comedi: addi_apci_3xxx: remove 'i_IorangeBase1' from boardinfo
      staging: comedi: addi_apci_3xxx: refactor 'i_NbrD[io]Channel' boardinfo
      staging: comedi: addi_apci_3xxx: refactor 'i_NbrTTLChannel' boardinfo
      staging: comedi: addi_apci_3xxx: analog output 'maxdata' is always 12-bit
      staging: comedi: addi_apci_3xxx: tidy up the digital in and out subdevice init
      staging: comedi: addi_apci_3xxx: tidy up the ttl digital i/o subdevice init
      staging: comedi: addi_apci_3xxx: refactor i_APCI3XXX_InsnWriteAnalogOutput()
      staging: comedi: addi_apci_3xxx: refactor 'i_NbrAoChannel' boardinfo
      staging: comedi: addi_apci_3xxx: absorb i_APCI3XXX_InsnWriteAnalogOutput()
      staging: comedi: addi_apci_3xxx: refactor the ttl digital i/o support
      staging: comedi: addi_apci_3xxx: remove unused define
      staging: comedi: addi_apci_3xxx: remove 'b_AiInitialisation' from private data
      staging: comedi: addi_apci_3xxx: remove sanity checks in i_APCI3XXX_InsnReadAnalogInput()
      staging: comedi: addi_apci_3xxx: tidy up i_APCI3XXX_InsnReadAnalogInput()
      staging: comedi: addi_apci_3xxx: remove 'i_IobaseReserved' from private data
      staging: comedi: addi_apci_3xxx: remove 'iobase' from private data
      staging: comedi: addi_apci_3xxx: rename 'dw_AiBase' in private data
      staging: comedi: addi_apci_3xxx: remove 'tsk_Current' from private data
      staging: comedi: addi_apci_3xxx: remove 'i_AiChannelList' from the boardinfo
      staging: comedi: addi_apci_3xxx: rename boardinfo 'pc_DriverName'
      staging: comedi: addi_apci_3xxx: rename boardinfo 'i_AiMaxData'
      staging: comedi: addi_apci_3xxx: properly set the analog input subdev_flags
      staging: comedi: addi_apci_3xxx: tidy up i_APCI3XXX_InsnConfigAnalogInput()
      staging: comedi: addi_apci_3xxx: tidy up i_APCI3XXX_AnalogInputConfigOperatingMode()
      staging: comedi: addi_apci_3xxx: clarify 'b_AvailableConvertUnit'
      staging: comedi: addi_apci_3xxx: rename 'ui_MinAcquisitiontimeNs'
      staging: comedi: addi_apci_3xxx: rename 'i_NbrAiChannel'
      staging: comedi: addi_apci_3xxx: remove 'i_NbrAiChannelDiff' boardinfo
      staging: comedi: addi_apci_3xxx: remove 'b_SingleDiff' private data
      staging: comedi: addi_apci_3xxx: tidy up analog input subdevice init
      staging: comedi: addi_apci_3xxx: stub in analog input command support
      staging: comedi: addi_apci_3xxx: fix the analog input subdevice
      staging: comedi: addi_apci_3xxx: only allocate needed subdevices
      staging: comedi: addi-data: remove unused vars from private data
      staging: comedi: addi-data: simplify the PCI bar reading
      staging: comedi: addi-data: remove unused defines in addi_common.h
      staging: comedi: addi-data: remove unused vars from boardinfo
      staging: comedi: addi-data: remove unused 'i_Dma' present flag
      staging: comedi: addi-data: remove unused 'i_NbrTTLChannel' boardinfo
      staging: comedi: have comedi_set_spriv() allocate the memory
      staging: comedi: pcmuio: remove unused {lock,unlock}_port()
      staging: comedi: pcmuio: tidy up the register map defines
      staging: comedi: pcmuio: tidy up switch_page()
      staging: comedi: pcmuio: introduce pcmuio_write()
      staging: comedi: pcmuio: remove unused private data variables
      staging: comedi: pcmuio: remove 'first_chan'
      staging: comedi: pcmuio: remove 'num_asic_chans'
      staging: comedi: pcmuio: remove 'asic_chan'
      staging: comedi: pcmuio: kzalloc'ed data does not need cleared
      staging: comedi: pcmuio: remove unused boardinfo
      staging: comedi: pcmuio: simplify 'n_subdevs' and 's->n_chan'
      staging: comedi: pcmuio: remove 'iobase' from private data
      staging: comedi: pcmuio: remove 'iobases' from subdevice private data
      staging: comedi: pcmuio: simplify interrupt subdevice init
      staging: comedi: pcmuio: introduce pcmuio_read()
      staging: comedi: pcmuio: cleanup DIO subdevice (*insn_{bits,config})
      staging: comedi: pcmuio: cleanup remaining #define's
      staging: comedi: pcmuio: use preferred form for passing the size of a struct
      staging: comedi: pcmuio: remove dev_dbg() noise during attach
      staging: comedi: pcmuio: return 0 for successful attach
      staging: comedi: pcmuio: fix namespace for all private functions
      staging: comedi: unioxx5: fix unioxx5_detach()
      staging: comedi: unioxx5: use comedi_alloc_spriv()

Harsh Kumar (3):
      Staging: winbond: usb_free_urb(NULL) is safe
      Staging: winbond: Made local functions static
      Staging: winbond: Check for unsuccessful allocation immediately

Hema Prathaban (8):
      staging: android: Remove unnecessary braces
      staging: android: Replace seq_printf with seq_puts
      staging: goldfish: Fixed Trailing Whitespace
      staging: goldfish: Fixed line over 80 characters
      staging: rtl8192e: Fix potential null dereference
      staging: rtl8192e: Use kmemdup for duplicating memory
      staging: vt6655: use free_netdev instead of kfree
      staging: vt6655: Use alloc_etherdev() for kzalloc

Hongchao Zhang (1):
      staging/lustre/osc: check ostid if no OBD_CONNECT_FID

JC Lafoucriere (1):
      staging/lustre/ldlm: suppress useless lock RPC for layout

Jacek Anaszewski (2):
      iio:ak8975 Add support for gpios DT property
      iio:ak8975 Implement data ready interrupt handling

Jake Champlin (1):
      Staging: Panel: panel: Fixed checkpatch line length warnings

Jeff Mahoney (1):
      staging/sb105x: remove asm/segment.h dependency

Jiada Wang (1):
      staging: imx-drm: Add MODULE_DEVICE_TABLE to parallel display

Jian Yu (1):
      staging/lustre/tests: check nr_local in ofd_preprw()

Jiang Liu (10):
      zram: avoid invalid memory access in zram_exit()
      zram: use zram->lock to protect zram_free_page() in swap free notify path
      zram: destroy all devices on error recovery path in zram_init()
      zram: avoid double free in function zram_bvec_write()
      zram: avoid access beyond the zram device
      zram: protect sysfs handler from invalid memory access
      zram: simplify and optimize dev_to_zram()
      zram: kill unused zram_get_num_devices()
      zram: optimize memory operations with clear_page()/copy_page()
      zram: use atomic64_xxx() to replace zram_stat64_xxx()

Jingoo Han (1):
      iio: replace strict_strtoul() with kstrtoul()

Jinshan Xiong (1):
      staging/lustre/osc: fixed a typo in osc_cache_truncate_start

Joe Perches (1):
      staging: fwserial: Use normal logging styles

Johannes Schilling (3):
      keucr: remove some unneccesary typedefs
      keucr: use more specific max_t(int, ..
      keucr: fix some alignment- and whitespace-problems

John B. Wyatt IV (1):
      Staging: vt6655: aes_ccmp: fixed a brace coding style

John L. Hammond (2):
      staging/lustre/lprocfs: use stats counter index for *pos
      staging/lustre/lprocfs: interpret result of dt_statfs() correctly

Jonathan Cameron (6):
      iio:trigger:sysfs Move out of staging.
      staging:iio:trigger:gpio bug in release of gpio in error path
      staging:iio:triggers: rename iio-trig-gpio to iio-trig-interrupt
      staging:iio:triggers:interrupt trigger - one per platform device.
      iio:triggers:interrupt trigger - move out of staging.
      iio:trigger:interrupt fix formatting of rsize variable in name

Katja Collier (5):
      staging: improved comment style in ft1000_debug.c
      staging: improved comment style in ft1000_ioctl.h
      staging: open braces in ft1000_debug.c and ioctl.h
      staging: fixed spaces around parens in ft1000
      staging: fixed else format in ft1000_debug.c

Katrina Prosise (1):
      Staging: keucr: fixed CamelCase warning

Lars-Peter Clausen (12):
      iio:dac: Add support for the AD7303
      staging:iio:adis16130: Remove unused includes
      staging:iio:adis16130: Fix sample reading
      staging:iio:adis16130: Report scale and offset
      staging:iio:adis16130: Move out of staging
      staging:iio:ad7291: Use IIO_VAL_FRACTIONAL_LOG2
      staging:iio:ad7291: Remove userspace reset
      staging:iio:ad7291: Remove unnecessary dev_info() from probe()
      staging:iio:ad7291: Simplify threshold register lookup
      staging:iio:ad7291: Use i2c_smbus_{read,write}_word_swapped instead of open-coding it
      staging:iio:ad7291: Use sign_extend32 instead of open-coding it
      staging:iio:ad7291: Rework regulator handling

Laura Lawniczak (4):
      keucr: migrate printk to dev_dbg/info/warn/err
      keucr: more readable and friendly error messages
      keucr: moved function to other file
      staging: keucr: removed unnecessary variables and comments

Laurent Navet (2):
      staging: dwc2: use devm_ioremap_resource()
      staging: imx-drm: use devm_ioremap_resource()

Leon Romanovsky (1):
      staging: nvec: Convert to use devm_input_allocate

Li RongQing (1):
      staging: csr: fix the reset of skb mac header

Lidza Louina (17):
      staging: sb105x: Fixes pointer format in sb_pci_mp.c
      Staging:csr - Fixes whitespace around commas in csr_wifi_nme_ap_sef.c.
      Staging:csr - Fixes whitespace around commas in drv.c.
      Staging:csr - Fixes whitespace around commas in io.c.
      Staging:csr - Fixes whitespace around commas in netdev.c.
      Staging:csr - Fixes whitespace around commas in sdio_mmc.c.
      Staging:csr - Fixes whitespace around commas in sme_blocking.c.
      Staging:csr - Fixes whitespace around commas in sme_native.c.
      Staging:csr - Fixes whitespace around commas in sme_userspace.c.
      Staging:csr - Fixes whitespace around commas in sme_sys.c.
      Staging:csr - Fixes whitespace around commas in sme_wext.c.
      Staging:csr - Fixes whitespace around commas in ul_int.c.
      Staging:csr - Fixes whitespace around commas in unifi_event.c.
      Staging:csr - Fixes whitespace around commas in unifi_pdu_processing.c.
      Staging:csr - Fixes whitespace around commas in unifi_priv.h.
      Staging:csr - Fixes whitespace around commas in unifi_sme.c.
      Staging:csr - Fixes whitespace around commas in unifi_sme.h.

Lisa Nguyen (14):
      vme/devices: Fixed camel-case variable names
      staging: usbip: Renaming pr_warning function
      staging: echo: Fixed camel-case variable names
      staging/speakup: Reformatted pointer variables
      staging/speakup: Replaced deprecated function
      staging/speakup: Remove trailing whitespace in Kconfig
      staging/speakup: Changed parameters in kstrtol()
      staging/silicom/bypasslib: Reformat comments
      staging/silicom/bypasslib: Fix code indentation errors
      staging/silicom/bypasslib: Add space around ==
      staging/silicom/bypasslib: Add space around &&
      staging/silicom/bypasslib: Add space around ||
      staging/silicom/bypasslib: Remove extra space before line
      staging/silicom/bypasslib: Move opening brace to previous line

Lorenz Haspel (3):
      silicom: checkpatch: fixed whitespace errors
      silicom: checkpatch: trailing statements
      silicom: checkpatch: errors caused by macros

Malcolm Priestley (8):
      staging: vt6656: rf.c: RFbSetPower Remove camel case and clean up.
      staging: vt6656: rf.c: RFbRawSetPower Remove camel case and cleanup.
      staging: vt6656: rf.c: RFvRSSITodBm Remove camel case and clean up.
      staging: vt6656: rf.c: RFbRFTableDownload: Remove camel case and clean up.
      staging: vt6656: rf.c: Remove camel case from local variables
      staging: vt6656: mac.c pbyData Remove magic number array size
      staging: vt6656: mac.c Remove commented out dead code
      staging: vt6656: mac.c MACvDisableKeyEntry remove dead code wOffset

Marc Dietrich (5):
      staging: nvec: add missing module aliases
      staging: nvec: implement unregistering of notifiers
      staging: nvec: cleanup childs on remove
      staging: nvec: remove instantiating via platform device
      staging: nvec: move device tree parsing to its own function

Marcus Overhagen (2):
      staging: rts5139: Fix SD card detection on Samsung NP730U3E Ultrabook
      staging: rts5139: Use correct USB transfer interval to fix syslog spamming

Markus Niebel (4):
      staging: drm/imx: set correct sync pins for display
      staging: drm/imx: fix spelling error for vsync flag config
      staging: drm/imx: revert vsync_cnt for di->id 1
      staging: imx_drm: imx_ldb: fix 18 bit format

Marlies Ruck (4):
      staging: android: Fixed line over 80 char
      Staging: Fixes string split across lines in zsmalloc zsmalloc-main
      staging: Fix lines over 80 chars in android sw_sync
      Staging: Fixes string split across lines in zram

Masanari Iida (3):
      staging: frontier: Fix typo in staging/frontier
      staging: android: Fix typo in staging/android
      staging: netlogic: Fix typo in staging/netlogic

Matthias Schid (2):
      staging/asus_oled fixed alignment in defines
      staging/asus_oled fixed linebreak and printk issue

Matthijs Kooijman (10):
      staging: dwc2: do not use IRQF_DISABLED
      staging: dwc2: use irq_return_t for interrupt handlers
      staging: dwc2: rename dwc2_hcd_intr() to dwc2_handle_hcd_intr()
      staging: dwc2: remove dummy interrupt handling
      staging: dwc2: replace some magic numbers by constants
      staging: dwc2: use dwc2_hcd_get_frame_number where possible
      staging: dwc2: add helper variable to simplify code
      staging: dwc2: remove some device-mode related debug code
      staging: dwc2: remove unneeded check
      staging: dwc2: remove some useless debug prints

Michael Hennerich (3):
      iio: frequency: adf4350: cast value to unsigned to make code checkers happy
      iio: frequency: adf4350: Add support for clock consumer framework
      iio: frequency: adf4350: Add support for dt bindings

Michał Mirosław (2):
      iio: buffer: cleanup messages in iio_update_buffers()
      staging/iio/mxs-lradc: cleanup masklength

Mikhail Pershin (2):
      staging/lustre/obdclass: remove obsoleted md_local_file.c
      staging/lustre/obdclass: use common way to store lastid

Niu Yawei (1):
      staging/lustre/clio: don't ignore layout on writeback

Oleg Drokin (1):
      staging/lustre: Revert "LU-2139 osc: Track and limit "unstable" pages"

Oskar Andero (1):
      iio: adc: add driver for MCP3204/08 12-bit ADC

Paul Bolle (1):
      iio: STMicroelectronics: remove three useless selects

Paul Zimmerman (2):
      staging: dwc2: change some dev_dbg() messages to dev_vdbg()
      staging: dwc2: fix thinko in dwc2_hc_set_even_odd_frame()

Peng Tao (24):
      staging: add Lustre file system client support
      staging/lustre: fix build error
      staging/lustre: adapt proc_dir_entry change
      staging/lustre: fix LBUG and inode refcount bug
      staging/lustre: remove enum config_flags and obd_mount_server.c
      staging/lustre: drop CONFIG_BROKEN dependency
      staging/lustre: remove empty file lustre/ptlrpc/nrs_orr.c
      staging/lustre: silence lockdep warning in ll_md_blocking_ast
      staging/lustre: llite: add module alias
      staging/lustre: clean up and remove libcfs/linux/linux-fs.c
      staging/lustre: silence gcc build warning
      staging/lustre: remove empty file libcfs/linux/linux-sync.c
      staging/lustre: remove libcfs/linux/linux-utils.c
      staging/lustre: remove empty file libcfs/linux/linux-lock.c
      staging/lustre: clean up and remove libcfs/linux/linux-mem.c
      staging/lustre: call set_cpus_allowed_ptr instead of set_cpus_allowed
      staging/lustre: remove lu_context_keys_dump and lu_debugging_setup
      staging/lustre/libcfs: restore LINVRNT
      staging/lustre: surround module_refcount with CONFIG_MODULE_UNLOAD
      staging/lustre/libcfs: cleanup linux-crypto
      Revert "Revert "staging/lustre: drop CONFIG_BROKEN dependency""
      staging/lustre/mdc: fix procfs fops
      staging/lustre/libcfs: cleanup libcfs_kkuc_msg_put a bit
      staging/lustre/lnet: fix build error on i386

Peter Huewe (8):
      staging/xgifb: Remove uneccessary/simply if in XGINew_GetXG20DRAMType
      staging/xgifb: Remove unnecessary cases in XGINew_SenseLCD
      staging/xgifb: Consolidate function almost identical calls in XGINew_GetXG21Sense
      staging/xgifb: Remove unnecessary binary calculation in GetXG27FPBits
      staging/xgifb: Fix always false condition in vb_setmode.c (smatch)
      staging/xgifb: Remove dead assignments/increments
      staging/btmtk_usb: use module_usb_driver to register driver
      staging/btmtk_usb: Mark local functions as static

Philipp Zabel (8):
      staging: drm/imx: fix number of IPU IRQs
      staging: drm/imx: convert IPU irq driver to irq_domain_add_linear
      staging: drm/imx: remove unused variables
      staging: drm/imx: ipu-dmfc: fix bandwidth allocation
      staging: drm/imx: ipuv3-crtc: immediately update crtc->fb in ipu_page_flip
      staging: drm/imx: ipu-dmfc: use defines for ipu channel numbers
      staging: drm/imx: use generic irqchip
      staging: drm/imx: use generic irq chip unused field to block out invalid irqs

Rupesh Gujare (1):
      staging: ozwpan: remove event tracing code.

Sachin Kamat (17):
      Staging: speakup: Return NULL instead of 0 in speakup_decpc.c
      Staging: speakup: Fix sparse warning in varhandlers.c
      Staging: speakup: Fix return value in synth.c
      adc: exynos_adc: Convert to devm_ioremap_resource()
      Staging: ced1401: Use NULL instead of 0 for pointers
      Staging: ced1401: Staticize local symbols
      Staging: speakup/speakup_acntpc: Return NULL instead of 0
      Staging: speakup/speakup_dtlk: Return NULL instead of 0
      Staging: speakup/speakup_keypc: Return NULL instead of 0
      Staging: speakup/main: Use NULL instead of 0
      Staging: speakup/kobjects: Use NULL instead of 0
      Staging: speakup/main: Staticize local symbols
      iio: at91_adc: Add missing CONFIG_OF macro
      staging: iio: ad7606_par: Remove redundant platform_set_drvdata()
      staging: iio: spear_adc: Remove redundant platform_set_drvdata()
      staging: iio: lpc32xx_adc: Remove redundant platform_set_drvdata()
      staging: iio: spear_adc: Add missing CONFIG_OF macro

Sara Bird (4):
      staging/asus_oled: Fixed up incorrect formatted comments.
      staging/zsmalloc: Fixed up incorrect formatted comments
      staging/frontier: Fixed up incorrect formatted comments
      staging/goldfish: Fixed up incorrect formatted comments.

Sascha Hauer (1):
      staging: drm/imx: Add LDB support

Sergey Senozhatsky (2):
      zram: remove zram_sysfs file (v2)
      zram: allow request end to coincide with disksize

Severin Gsponer (3):
      Staging: bcm: Fix of a litte white space error in Bcmchar.c
      Staging: bcm: Change comment style to C89 in vendorspecificextn.c
      Staging: bcm: fix checkpatch errors and warnings in Version.h

Stephen Warren (1):
      staging: dwc2: add const to handling of dwc2_core_params

Tobias Polzer (1):
      staging: csr: Fix obvious logic error in staging/csr

Tushar Behera (1):
      Staging: netlogic: Convert to use devm_ioremap_resource

Tülin İzer (29):
      Staging: asus_oled: fixed warning 'default case should have 'break'.
      Staging: bcm: fixed warning 'space required after ',' '
      Staging: bcm: fixed warning 'space reqires around '==' '
      staging: dgrp: Fixed warning 'space prohibited before semicolon'
      Staging: bcm: Fixed warning about pointer position.
      Staging: bcm: Fixed warning about C99 comments.
      Staging: bcm: Fixed warning 'space required around '=''.
      Staging: bcm: Fixed error 'that open brace { should be on the previous line'.
      Staging: bcm: Fixed warning 'braces {} are not necessary for single statement blocks'.
      Staging: bcm: Fixed error 'else should follow close brace '}''.
      Staging: bcm: Fixed warning 'space required before the open parenthesis '(''.
      Staging: silicom: Fixed error 'do not initialise statics to 0 or NULL'.
      Staging: silicom: Fixed warning 'space prohibited before semicolon'.
      Staging: silicom : Fixed error 'exactly one space required after that #ifdef'
      Staging: silicom: Fixed warning 'please, no space before tabs'.
      Staging: silicom: Fixed error 'space required after that ',''.
      Staging: silicom: Fixed error 'space prohibited before that close parenthesis ')''
      Staging: vt6655: Fixed ERROR: do not use C99 // comments in 80211mgr.c
      Staging: vt6655: Fixed ERROR: do not use C99 // comments in vt6655/80211mgr.h
      Staging: vt6655: Fixed ERROR: do not use C99 // comments in vt6655/aes_ccmp.c
      Staging: vt6655: Fixed ERROR: do not use C99 // comments in vt6655/aes_ccmp.h.
      Staging: vt6655: Fixed ERROR: do not use C99 // comments in vt6655/80211hdr.h
      Staging: silicom: Fixed warning 'preferred seq_puts instead of seq_printf'.
      Staging: tidspbridge: _tiomap.h: fixed warning 'space prohibited before semicolon'.
      Staging: tidspbridge: _tiomap_pwr.h: fixed indentation warning.
      Staging: tidspbridge: ue_deh.c: fixed space formatting issue.
      Staging: tidspbridge: wdt.c: fixed indentation warning.
      Staging: tidspbridge: tiomap3430_pwr.c: fixed indentation warning.
      Staging: tidspbridge: _tiomap.h: fixed indentation warning.

Wei Yongjun (13):
      staging: vme: fix error return code in vme_user_probe()
      staging: cptm1217: don't call input_free_device() after input_unregister_device()
      staging: slicoss: fix error return code in slic_entry_probe()
      staging: ozwpan: fix error return code in oz_cdev_register()
      staging: wlags49_h2: fix error return code in wl_adapter_insert()
      staging: lustre: fix to use list_for_each_entry_safe() when delete items
      staging: btmtk_usb: remove unused including <linux/version.h>
      staging: keucr: remove needless check before usb_free_coherent()
      Staging: vt6655: add missing free_netdev() on error in hostap_enable_hostapd()
      staging/lustre: fix return value check in libcfs_sock_ioctl()
      staging: octeon-usb: remove duplicated include from octeon-hcd.c
      staging: tidspbridge: fix error return code in omap34_xx_bridge_probe()
      Staging: netlogic: fix missing free_netdev() on error in xlr_net_probe()

William Hubbs (18):
      staging: speakup: update Kirk's email address
      staging: speakup: kobjects: remove custom locking macros
      staging: speakup: devsynth: remove custom locking macros
      staging: speakup: i18n: remove custom locking macros
      staging: speakup: main: remove custom locking macros
      staging: speakup: remove spk_trylock macro definition
      staging: speakup: serialio: remove custom locking macros
      staging: speakup: acntpc: remove custom locking macros
      staging: speakup: apollo: remove custom locking macros
      staging: speakup: decext: remove custom locking macros
      staging: speakup: decpc: remove custom locking macros
      staging: speakup: dectlk: remove custom locking macros
      staging: speakup: dtlk: remove custom locking macros
      staging: speakup: keypc: remove custom locking macros
      staging: speakup: soft: remove custom locking macros
      staging: speakup: thread: remove custom locking macros
      staging: speakup: synth: remove custom locking macros
      staging: speakup: remove custom locking macro definitions

Wolfram Sang (2):
      drivers/staging/dwc2: don't check resource with devm_ioremap_resource
      drivers/staging/nvec: don't check resource with devm_ioremap_resource

Xenia Ragiadakou (100):
      STAGING: rtl8192u: fix checkpatch error about pointer position in r8192U_core.c
      STAGING: rtl8192u: fix checkpatch error about pointer position in r8192U_dm.c
      STAGING: rtl8192u: fix checkpatch error about pointer position in r819xU_cmdpkt
      STAGING: rtl8192u: fix checkpatch error about pointer position in r819xU_firmware.c
      STAGING: rtl8192u: fix checkpatch error about pointer position in r819xU_phy
      STAGING: rtl8192u: fix checkpatch error about pointer position in r8190_rtl8256
      STAGING: rtl8192u: fix checkpatch error about pointer position in r8192U_wx.c
      STAGING: rtl8192u: fix checkpatch error about pointer position in r8192U.h
      STAGING: rtl8192u/ieee20811: fix checkpatch error about pointer position in ieee20811.h
      STAGING: rtl8192u/ieee80211: fix checkpatch error about pointer position in ieee80211_crypt
      STAGING: rtl8192u/ieee80211: fix checkpatch error about pointer position in ieee80211_crypt_ccmp.c
      STAGING: rtl8192u/ieee80211: fix checkpatch error about pointer position in ieee80211_crypt_tkip.c
      STAGING: rtl8192u/ieee80211: fix checkpatch error about pointer position in ieee80211_crypt_wep.c
      STAGING: rtl8192u/ieee80211: fix checkpatch error about pointer position in ieee80211_rx.c
      STAGING: rtl8192u/ieee80211: fix checkpatch error about pointer position in ieee80211_softmac.c
      STAGING: rtl8192u/ieee80211: fix checkpatch error about pointer position in ieee80211_tx.c
      STAGING: rtl8192u/ieee80211: fix checkpatch error about pointer position in dot11d
      STAGING: rtl8192u/ieee80211: fix checkpatch error about pointer position in rtl819x_BAProc.c
      STAGING: rtl8192u/ieee80211: fix checkpatch error about pointer position in rtl819x_HTProc.c
      STAGING: rtl8192u/ieee80211: fix checkpatch error about pointer position in rtl819x_Qos.h
      STAGING: rtl8192u/ieee80211: fix checkpatch error about pointer position in tl819x_TSProc.c
      STAGING: rtl8192u: fix checkpatch error by adding space after switch
      wlan-ng: replace calls to kmalloc and memcpy with kmemdup
      rtl8192u: fix whitespace around if statements in r8180_93cx6.c
      rtl8192u: fix whitespace around if statements in r8192U.h
      rtl8192u: fix whitespace around if statements in r819xU_cmdpkt.c
      rtl8192u: fix whitespace around if statements in r819xU_firmware.c
      rtl8192u: fix whitespace around ~ in r8180_93cx6.c
      rtl8192u: fix whitespace around ~ in r8192U_core.c
      rtl8192u: fix whitespace around ~ in r8192U_dm.c
      rtl8192u: remove whitespace after '(' and before ')' in r8190_rtl8256.c
      rtl8192u: remove whitespace after '(' and before ')' in r8192U.h
      rtl8192u: remove whitespace after '(' and before ')' in r8192U_dm.c
      staging: ozwpan: fix access byteorder for wMaxPacketSize in ozhcd.c
      ozwpan: replace alloc_skb with dev_alloc_skb in ozpd.c
      ozwpan: replace alloc_skb with dev_alloc_skb in ozproto.c
      ozwpan: replace kfree_skb with dev_kfree_skb in ozpd.c
      ozwpan: replace kfree_skb with dev_kfree_skb in ozproto.c
      gdm72xx: remove unnecessary cast in gdm_wimax.c
      rtl8192u: fix whitespace around 'if' in r8192U_core.c
      rtl8192u: fix whitespace around 'for' in r8192U_core.c
      rtl8192u: fix whitespace around 'while' in r8192U_core.c
      rtl8192u: fix whitespace around '=' in r8192U_core.c
      rtl8192u: fix whitespace around relational operators in r8192U_core.c
      rtl8192u: fix whitespace around ';' in r8192U_core.c
      rtl8192u: fix whitespace after '(' and before ')' in r8192U_core.c
      rtl8192u: fix whitespace around ',' in r8192U_core.c
      rtl8192u: remove space between function name and '(' in r8192U_core.c
      rtl8192u: replace __FUNCTION__ with __func__ in r8192U_core.c
      rtl8192u: add space after '}' in r8192U_core.c
      staging: ozwpan: Revert last changes
      ozwpan: replace alloc_skb with dev_alloc_skb in ozpd.c
      ozwpan: replace alloc_skb with dev_alloc_skb in ozproto.c
      ozwpan: replace kfree_skb with dev_kfree_skb in ozpd.c
      ozwpan: replace kfree_skb with dev_kfree_skb in ozproto.c
      rtl8192u: fix printk calls in r8192U_core.c
      staging: rtl8192u: remove dead and commented-out code in r8192U_core.c
      staging: rtl8192u: fix braces in r8192U_core.c
      staging: rtl8192u: fix function definitions' style in r8192U_core.c
      staging: rtl8192u: remove unnecessary line continuations in r8192U_core.c
      staging: rtl8192u: fix identation in r8192U_core.c
      staging: rtl8192u: fix spaces in array indexing in r8192U_core.c
      staging: rtl8192u: fix return statements in r8192U_core.c
      staging: rtl8192u: add spaces around ?:&&|| in r8192U_core.c
      staging: rtl8192u: remove space after reference '&' in r8192U_core.c
      staging: rtl8192u: remove space before '++' in r8192U_core.c
      staging: rtl8192u: remove trailing whitespace in r8192U_core.c
      staging: rtl8192u: replace macro rx_hal_is_cck_rate() in r8192U_core.c
      staging: rtl8192u: fix read_nic_* functions
      staging: rtl8192u: remove commented-out code in r8192U.h
      staging: rtl8192u: fix comments in r8192U.h
      staging: rtl8192u: fix braces in r8192U.h
      staging: rtl8192u: fix whitespace around '(=<, ' in r8192U.h
      staging: rtl8192u: fix macros in r8192U.h
      staging: rtl8192u: fix bitshift calculation in r819xU_phy.c
      staging: rtl8192u: fix braces in r819xU_phy.c
      staging: rtl8192u: fix return statements in r819xU_phy.c
      staging: rtl8192u: fix spaces around 'if' in r819xU_phy.c
      staging: rtl8192u: fix spaces around for and while in r819xU_phy.c
      staging: rtl8192u: remove commented-out code in r819xU_phy.c
      staging: rtl8192u: fix spaces around ( and ) in r819xU_phy.c
      staging: rtl8192u: fix function arguments position in r819xU_phy.c
      staging: rtl8192u: fix spaces around '=' in r819xU_phy.c
      staging: rtl8192u: fix spaces around ';' in r819xU_phy.c
      staging: rtl8192u: fix spaces around relational operators in r819xU_phy.c
      staging: rtl8192u: replace *Value variables in r819xU_phy.c
      staging: rtl8192u: rename *BitMask variables in r819xU_phy.c
      staging: rtl8192u: rename general variables in r819xU_phy.c
      staging: rtl8192u: remove variable 'Ret' in r819xU_phy.c
      staging: rtl8192u: fix spaces around ',' in r819xU_phy.c
      staging: rtl8192u: fix comments in r819xU_phy.c
      staging: rtl8192u: limit line size in r819xU_phy.c
      staging: rtl8192u: replace __FUNCTION__ in r819xU_phy.c
      staging: rtl8192u: rename dwRegRead and rtStatus in r819xU_phy.c
      staging: rtl8192u: replace msleep(1) with usleep_range() in r819xU_phy.c
      staging: rtl8192u: fix newlines in r819xU_phy.c
      staging: rtl8192u: fix whitespace in r819xU_phy.h
      staging: rtl8192u: fix comments in r819xU_phy.h
      staging: rtl8192u: rename variables in r819xU_phy.h
      staging: rtl8192u: fix line length in r819xU_phy.h

Yijing Wang (1):
      staging: dwc2: remove redundant D0 power state set

wang di (5):
      staging/lustre/ofd: refill env in ofd_get_info
      staging/lustre/utils: missing setting echo seq for getattr/setattr
      staging/lustre/llog: Do not use ostid swab for llogid
      staging/lustre/ost: check pre 2.4 echo client in obdo validation
      staging/lustre/llite: Always build 64bit ino internally

 Documentation/ABI/testing/sysfs-bus-iio            |   90 +-
 .../devicetree/bindings/iio/dac/ad7303.txt         |   23 +
 .../devicetree/bindings/iio/frequency/adf4350.txt  |   86 +
 .../bindings/iio/magnetometer/ak8975.txt           |   18 +
 .../devicetree/bindings/staging/imx-drm/ldb.txt    |   99 +
 MAINTAINERS                                        |    2 +-
 drivers/iio/Kconfig                                |    4 +
 drivers/iio/Makefile                               |    2 +
 drivers/iio/accel/Kconfig                          |    1 -
 drivers/iio/accel/st_accel_core.c                  |   39 +-
 drivers/iio/adc/Kconfig                            |   10 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/at91_adc.c                         |    2 +
 drivers/iio/adc/exynos_adc.c                       |   12 +-
 drivers/iio/adc/max1363.c                          |    2 +-
 drivers/iio/adc/mcp320x.c                          |  257 ++
 drivers/iio/common/st_sensors/st_sensors_buffer.c  |   61 +-
 drivers/iio/common/st_sensors/st_sensors_core.c    |   34 +-
 drivers/iio/dac/Kconfig                            |   10 +
 drivers/iio/dac/Makefile                           |    1 +
 drivers/iio/dac/ad7303.c                           |  315 ++
 drivers/iio/frequency/adf4350.c                    |  186 +-
 drivers/iio/gyro/Kconfig                           |    8 +-
 drivers/iio/gyro/Makefile                          |    1 +
 .../gyro/adis16130_core.c => iio/gyro/adis16130.c} |   65 +-
 drivers/iio/gyro/st_gyro_core.c                    |   24 +-
 drivers/iio/industrialio-buffer.c                  |   10 +-
 drivers/iio/light/hid-sensor-als.c                 |    2 +-
 drivers/iio/magnetometer/Kconfig                   |    1 -
 drivers/iio/magnetometer/ak8975.c                  |  103 +-
 drivers/iio/magnetometer/st_magn_core.c            |   39 +-
 drivers/iio/pressure/Kconfig                       |   35 +
 drivers/iio/pressure/Makefile                      |   10 +
 drivers/iio/pressure/st_pressure.h                 |   39 +
 drivers/iio/pressure/st_pressure_buffer.c          |  105 +
 drivers/iio/pressure/st_pressure_core.c            |  272 ++
 drivers/iio/pressure/st_pressure_i2c.c             |   77 +
 drivers/iio/pressure/st_pressure_spi.c             |   76 +
 drivers/iio/trigger/Kconfig                        |   26 +
 drivers/iio/trigger/Makefile                       |    6 +
 drivers/iio/trigger/iio-trig-interrupt.c           |  121 +
 drivers/{staging => }/iio/trigger/iio-trig-sysfs.c |    4 +-
 drivers/staging/Kconfig                            |    6 +
 drivers/staging/Makefile                           |    3 +
 drivers/staging/android/ashmem.c                   |    3 +-
 drivers/staging/android/binder.c                   |    2 +-
 drivers/staging/android/sw_sync.c                  |    6 +-
 drivers/staging/android/sync.c                     |   22 +-
 drivers/staging/asus_oled/asus_oled.c              |   38 +-
 drivers/staging/bcm/Bcmchar.c                      |    2 +-
 drivers/staging/bcm/InterfaceIdleMode.c            |  199 +-
 drivers/staging/bcm/Version.h                      |    8 +-
 drivers/staging/bcm/vendorspecificextn.c           |  198 +-
 drivers/staging/btmtk_usb/Kconfig                  |   11 +
 drivers/staging/btmtk_usb/Makefile                 |    1 +
 drivers/staging/btmtk_usb/README                   |   14 +
 drivers/staging/btmtk_usb/TODO                     |   10 +
 drivers/staging/btmtk_usb/btmtk_usb.c              | 1784 ++++++++
 drivers/staging/btmtk_usb/btmtk_usb.h              |  138 +
 drivers/staging/ced1401/ced_ioc.c                  |  665 ++-
 drivers/staging/ced1401/ced_ioctl.h                |    2 +-
 drivers/staging/ced1401/machine.h                  |   32 +-
 drivers/staging/ced1401/usb1401.c                  |  613 ++-
 drivers/staging/ced1401/usb1401.h                  |  285 +-
 drivers/staging/ced1401/use1401.h                  |  201 +-
 drivers/staging/ced1401/use14_ioc.h                |  503 ++-
 drivers/staging/ced1401/userspace/use1401.c        |  152 +-
 drivers/staging/comedi/Kconfig                     |   61 +-
 drivers/staging/comedi/comedi.h                    |    5 -
 drivers/staging/comedi/comedi_buf.c                |    4 -
 drivers/staging/comedi/comedi_compat32.c           |    5 -
 drivers/staging/comedi/comedi_compat32.h           |    5 -
 drivers/staging/comedi/comedi_fops.c               |   26 +-
 drivers/staging/comedi/comedi_pci.c                |    4 -
 drivers/staging/comedi/comedi_pcmcia.c             |    4 -
 drivers/staging/comedi/comedi_usb.c                |   16 +-
 drivers/staging/comedi/comedidev.h                 |   30 +-
 drivers/staging/comedi/comedilib.h                 |    5 -
 drivers/staging/comedi/drivers.c                   |   52 +-
 drivers/staging/comedi/drivers/8253.h              |    5 -
 drivers/staging/comedi/drivers/8255.c              |   11 +-
 drivers/staging/comedi/drivers/8255.h              |    5 -
 drivers/staging/comedi/drivers/8255_pci.c          |    7 -
 drivers/staging/comedi/drivers/Makefile            |    5 +-
 drivers/staging/comedi/drivers/acl7225b.c          |  136 -
 .../comedi/drivers/addi-data/APCI1710_Chrono.c     |    4 -
 .../comedi/drivers/addi-data/APCI1710_Dig_io.c     |    4 -
 .../comedi/drivers/addi-data/APCI1710_INCCPT.c     |    4 -
 .../comedi/drivers/addi-data/APCI1710_Inp_cpt.c    |    4 -
 .../comedi/drivers/addi-data/APCI1710_Pwm.c        |    4 -
 .../comedi/drivers/addi-data/APCI1710_Ssi.c        |    4 -
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    4 -
 .../comedi/drivers/addi-data/APCI1710_Ttl.c        |    4 -
 .../staging/comedi/drivers/addi-data/addi_common.c |   61 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |   44 -
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |    9 +-
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |    4 -
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |    4 -
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    4 -
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |    4 -
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |   10 -
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    4 -
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.c      | 1376 ------
 drivers/staging/comedi/drivers/addi_apci_1032.c    |    7 -
 drivers/staging/comedi/drivers/addi_apci_1516.c    |    8 -
 drivers/staging/comedi/drivers/addi_apci_16xx.c    |    7 -
 drivers/staging/comedi/drivers/addi_apci_2032.c    |    8 -
 drivers/staging/comedi/drivers/addi_apci_2200.c    |    8 -
 drivers/staging/comedi/drivers/addi_apci_3120.c    |    5 -
 drivers/staging/comedi/drivers/addi_apci_3501.c    |    7 -
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    | 1409 +++---
 drivers/staging/comedi/drivers/addi_watchdog.c     |    8 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |    4 -
 drivers/staging/comedi/drivers/adl_pci7x3x.c       |    4 -
 drivers/staging/comedi/drivers/adl_pci8164.c       |    4 -
 drivers/staging/comedi/drivers/adl_pci9111.c       |    4 -
 drivers/staging/comedi/drivers/adq12b.c            |    5 -
 drivers/staging/comedi/drivers/adv_pci1723.c       |    9 +-
 drivers/staging/comedi/drivers/adv_pci1724.c       |    7 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |    8 -
 drivers/staging/comedi/drivers/aio_aio12_8.c       |   12 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |    4 -
 drivers/staging/comedi/drivers/amplc_dio200.c      |    5 -
 drivers/staging/comedi/drivers/amplc_dio200.h      |    5 -
 .../staging/comedi/drivers/amplc_dio200_common.c   |   33 +-
 drivers/staging/comedi/drivers/amplc_dio200_pci.c  |    5 -
 drivers/staging/comedi/drivers/amplc_pc236.c       |    6 -
 drivers/staging/comedi/drivers/amplc_pc263.c       |    5 -
 drivers/staging/comedi/drivers/amplc_pci224.c      |    5 -
 drivers/staging/comedi/drivers/amplc_pci230.c      |    5 -
 drivers/staging/comedi/drivers/amplc_pci263.c      |    5 -
 drivers/staging/comedi/drivers/c6xdigio.c          |    5 -
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    4 -
 drivers/staging/comedi/drivers/cb_pcidas.c         |    7 -
 drivers/staging/comedi/drivers/cb_pcidas64.c       |    8 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |   13 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    5 -
 drivers/staging/comedi/drivers/cb_pcimdda.c        |   13 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |    5 -
 drivers/staging/comedi/drivers/comedi_fc.c         |    7 +-
 drivers/staging/comedi/drivers/comedi_fc.h         |    7 +-
 drivers/staging/comedi/drivers/comedi_parport.c    |    5 -
 drivers/staging/comedi/drivers/comedi_test.c       |    7 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    5 -
 drivers/staging/comedi/drivers/daqboard2000.c      |   30 +-
 drivers/staging/comedi/drivers/das08.c             |   12 -
 drivers/staging/comedi/drivers/das08.h             |    6 -
 drivers/staging/comedi/drivers/das08_cs.c          |   15 +-
 drivers/staging/comedi/drivers/das08_isa.c         |   12 +-
 drivers/staging/comedi/drivers/das08_pci.c         |   12 +-
 drivers/staging/comedi/drivers/das16.c             |    7 -
 drivers/staging/comedi/drivers/das16m1.c           |    7 -
 drivers/staging/comedi/drivers/das1800.c           |    6 -
 drivers/staging/comedi/drivers/das6402.c           |    5 -
 drivers/staging/comedi/drivers/das800.c            |    6 -
 drivers/staging/comedi/drivers/dmm32at.c           |    5 -
 drivers/staging/comedi/drivers/dt2811.c            |    4 -
 drivers/staging/comedi/drivers/dt2814.c            |    5 -
 drivers/staging/comedi/drivers/dt2815.c            |    5 -
 drivers/staging/comedi/drivers/dt2817.c            |    5 -
 drivers/staging/comedi/drivers/dt282x.c            |    5 -
 drivers/staging/comedi/drivers/dt3000.c            |    5 -
 drivers/staging/comedi/drivers/dt9812.c            | 1031 ++---
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |    4 -
 drivers/staging/comedi/drivers/gsc_hpdi.c          |    7 +-
 drivers/staging/comedi/drivers/icp_multi.c         |    5 -
 drivers/staging/comedi/drivers/jr3_pci.c           |   51 +-
 drivers/staging/comedi/drivers/ke_counter.c        |    5 -
 drivers/staging/comedi/drivers/me4000.c            |    5 -
 drivers/staging/comedi/drivers/me_daq.c            |   28 +-
 drivers/staging/comedi/drivers/mite.c              |    5 -
 drivers/staging/comedi/drivers/mite.h              |    5 -
 drivers/staging/comedi/drivers/mpc624.c            |    5 -
 drivers/staging/comedi/drivers/multiq3.c           |    5 -
 drivers/staging/comedi/drivers/ni_6527.c           |    5 -
 drivers/staging/comedi/drivers/ni_65xx.c           |   36 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    4 -
 drivers/staging/comedi/drivers/ni_670x.c           |    5 -
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    6 -
 drivers/staging/comedi/drivers/ni_at_ao.c          |    5 -
 drivers/staging/comedi/drivers/ni_atmio.c          |    4 -
 drivers/staging/comedi/drivers/ni_atmio16d.c       |    6 -
 drivers/staging/comedi/drivers/ni_daq_700.c        |    9 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |   14 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |   74 +-
 drivers/staging/comedi/drivers/ni_labpc.h          |   29 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c       |   19 +-
 drivers/staging/comedi/drivers/ni_labpc_pci.c      |   12 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |    6 -
 drivers/staging/comedi/drivers/ni_mio_cs.c         |    5 -
 drivers/staging/comedi/drivers/ni_pcidio.c         |   30 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |    4 -
 drivers/staging/comedi/drivers/ni_stc.h            |    5 -
 drivers/staging/comedi/drivers/ni_tio.c            |    4 -
 drivers/staging/comedi/drivers/ni_tio.h            |    5 -
 drivers/staging/comedi/drivers/ni_tio_internal.h   |    5 -
 drivers/staging/comedi/drivers/ni_tiocmd.c         |    4 -
 drivers/staging/comedi/drivers/pcl711.c            |    5 -
 drivers/staging/comedi/drivers/pcl724.c            |  219 +-
 drivers/staging/comedi/drivers/pcl725.c            |   91 -
 drivers/staging/comedi/drivers/pcl726.c            |    5 -
 drivers/staging/comedi/drivers/pcl730.c            |  332 +-
 drivers/staging/comedi/drivers/pcm3724.c           |   11 +-
 drivers/staging/comedi/drivers/pcm3730.c           |  136 -
 drivers/staging/comedi/drivers/pcmad.c             |  197 +-
 drivers/staging/comedi/drivers/pcmda12.c           |  245 +-
 drivers/staging/comedi/drivers/pcmmio.c            |    4 -
 drivers/staging/comedi/drivers/pcmuio.c            |  961 ++---
 drivers/staging/comedi/drivers/plx9052.h           |    5 -
 drivers/staging/comedi/drivers/poc.c               |   58 +-
 drivers/staging/comedi/drivers/rtd520.c            |    4 -
 drivers/staging/comedi/drivers/rti800.c            |    4 -
 drivers/staging/comedi/drivers/rti802.c            |    5 -
 drivers/staging/comedi/drivers/s526.c              |    5 -
 drivers/staging/comedi/drivers/s626.c              |    5 -
 drivers/staging/comedi/drivers/s626.h              |    5 -
 drivers/staging/comedi/drivers/serial2002.c        |    5 -
 drivers/staging/comedi/drivers/skel.c              |    5 -
 drivers/staging/comedi/drivers/ssv_dnp.c           |    5 -
 drivers/staging/comedi/drivers/unioxx5.c           |   25 +-
 drivers/staging/comedi/drivers/usbdux.c            |  236 +-
 drivers/staging/comedi/drivers/usbduxfast.c        | 1282 ++----
 drivers/staging/comedi/drivers/usbduxsigma.c       | 2960 +++++--------
 drivers/staging/comedi/drivers/vmk80xx.c           |   88 +-
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |    5 -
 drivers/staging/comedi/proc.c                      |    5 -
 drivers/staging/comedi/range.c                     |    5 -
 drivers/staging/cptm1217/clearpad_tm1217.c         |    4 +-
 drivers/staging/crystalhd/bc_dts_glob_lnx.h        |   19 +-
 drivers/staging/crystalhd/crystalhd_cmds.c         |   28 +-
 drivers/staging/crystalhd/crystalhd_cmds.h         |   19 +-
 drivers/staging/crystalhd/crystalhd_fw_if.h        |   81 +-
 drivers/staging/crystalhd/crystalhd_hw.c           |  231 +-
 drivers/staging/crystalhd/crystalhd_hw.h           |  121 +-
 drivers/staging/crystalhd/crystalhd_lnx.c          |   33 +-
 drivers/staging/crystalhd/crystalhd_lnx.h          |    4 +-
 drivers/staging/crystalhd/crystalhd_misc.c         |   39 +-
 drivers/staging/crystalhd/crystalhd_misc.h         |   37 +-
 drivers/staging/csr/bh.c                           |  213 +-
 drivers/staging/csr/csr_framework_ext.c            |   16 +-
 drivers/staging/csr/csr_framework_ext.h            |    8 +-
 drivers/staging/csr/csr_wifi_nme_ap_sef.c          |    4 +-
 drivers/staging/csr/drv.c                          |    6 +-
 drivers/staging/csr/io.c                           |   18 +-
 drivers/staging/csr/monitor.c                      |    2 +-
 drivers/staging/csr/netdev.c                       |  100 +-
 drivers/staging/csr/sdio_mmc.c                     |    4 +-
 drivers/staging/csr/sme_blocking.c                 |   24 +-
 drivers/staging/csr/sme_native.c                   |    2 +-
 drivers/staging/csr/sme_sys.c                      |  148 +-
 drivers/staging/csr/sme_userspace.c                |    4 +-
 drivers/staging/csr/sme_wext.c                     |  116 +-
 drivers/staging/csr/ul_int.c                       |    2 +-
 drivers/staging/csr/unifi_event.c                  |   20 +-
 drivers/staging/csr/unifi_pdu_processing.c         |  492 +--
 drivers/staging/csr/unifi_priv.h                   |   30 +-
 drivers/staging/csr/unifi_sme.c                    |   24 +-
 drivers/staging/csr/unifi_sme.h                    |    8 +-
 drivers/staging/cxt1e1/comet.c                     |  819 ++--
 drivers/staging/cxt1e1/functions.c                 |   10 +-
 drivers/staging/cxt1e1/hwprobe.c                   |    6 +-
 drivers/staging/cxt1e1/linux.c                     |   64 +-
 drivers/staging/cxt1e1/musycc.c                    |   42 +-
 drivers/staging/cxt1e1/pmcc4.h                     |   10 +-
 drivers/staging/cxt1e1/pmcc4_drv.c                 |   52 +-
 drivers/staging/cxt1e1/sbecom_inline_linux.h       |    6 +-
 drivers/staging/cxt1e1/sbeid.c                     |    6 +-
 drivers/staging/cxt1e1/sbeproc.h                   |    4 +-
 drivers/staging/dgrp/dgrp_dpa_ops.c                |    2 +-
 drivers/staging/dgrp/dgrp_net_ops.c                |    6 +-
 drivers/staging/dgrp/drp.h                         |    2 +-
 drivers/staging/dwc2/core.c                        |   44 +-
 drivers/staging/dwc2/core_intr.c                   |   15 +-
 drivers/staging/dwc2/hcd.c                         |   17 +-
 drivers/staging/dwc2/hcd.h                         |   12 +-
 drivers/staging/dwc2/hcd_intr.c                    |   26 +-
 drivers/staging/dwc2/pci.c                         |   19 +-
 drivers/staging/echo/echo.c                        |   78 +-
 drivers/staging/echo/echo.h                        |   26 +-
 drivers/staging/frontier/alphatrack.c              |   51 +-
 drivers/staging/frontier/alphatrack.h              |    6 +-
 drivers/staging/frontier/tranzport.c               |   20 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |   43 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   |  439 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h   |  156 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   10 +-
 drivers/staging/fwserial/fwserial.c                |  135 +-
 drivers/staging/fwserial/fwserial.h                |    2 -
 drivers/staging/gdm72xx/Kconfig                    |   10 +-
 drivers/staging/gdm72xx/gdm_wimax.c                |    3 +-
 drivers/staging/goldfish/goldfish_audio.c          |   30 +-
 drivers/staging/goldfish/goldfish_nand.c           |   11 +-
 drivers/staging/goldfish/goldfish_nand_reg.h       |   35 +-
 drivers/staging/iio/adc/ad7192.c                   |    2 +-
 drivers/staging/iio/adc/ad7280a.c                  |    2 +-
 drivers/staging/iio/adc/ad7291.c                   |  217 +-
 drivers/staging/iio/adc/ad7291.h                   |   12 +
 drivers/staging/iio/adc/ad7606_core.c              |   12 +-
 drivers/staging/iio/adc/ad7606_par.c               |    2 -
 drivers/staging/iio/adc/ad7816.c                   |    8 +-
 drivers/staging/iio/adc/ad799x_core.c              |    4 +-
 drivers/staging/iio/adc/lpc32xx_adc.c              |    1 -
 drivers/staging/iio/adc/mxs-lradc.c                |    8 +-
 drivers/staging/iio/adc/spear_adc.c                |    3 +-
 drivers/staging/iio/gyro/Kconfig                   |    7 -
 drivers/staging/iio/gyro/Makefile                  |    3 -
 drivers/staging/iio/trigger/Kconfig                |   17 -
 drivers/staging/iio/trigger/Makefile               |    2 -
 drivers/staging/iio/trigger/iio-trig-gpio.c        |  167 -
 drivers/staging/imx-drm/Kconfig                    |    8 +
 drivers/staging/imx-drm/Makefile                   |    1 +
 drivers/staging/imx-drm/TODO                       |    1 -
 drivers/staging/imx-drm/imx-drm-core.c             |    5 +-
 drivers/staging/imx-drm/imx-ldb.c                  |  625 +++
 drivers/staging/imx-drm/imx-tve.c                  |   18 +-
 drivers/staging/imx-drm/ipu-v3/ipu-common.c        |  125 +-
 drivers/staging/imx-drm/ipu-v3/ipu-di.c            |   13 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c          |   22 +-
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h           |    4 +-
 drivers/staging/imx-drm/ipuv3-crtc.c               |    7 +-
 drivers/staging/imx-drm/parallel-display.c         |   11 +-
 drivers/staging/keucr/init.c                       |  116 +-
 drivers/staging/keucr/scsiglue.c                   |   19 +-
 drivers/staging/keucr/smil.h                       |   28 +-
 drivers/staging/keucr/smilmain.c                   | 1937 ++-------
 drivers/staging/keucr/smilsub.c                    |   52 +-
 drivers/staging/keucr/smscsi.c                     |   38 +-
 drivers/staging/keucr/transport.c                  |   49 +-
 drivers/staging/keucr/transport.h                  |    3 +-
 drivers/staging/keucr/usb.c                        |   67 +-
 drivers/staging/keucr/usb.h                        |  119 +-
 drivers/staging/line6/pcm.c                        |   23 +-
 drivers/staging/lustre/Kconfig                     |    3 +
 drivers/staging/lustre/Makefile                    |    4 +
 drivers/staging/lustre/TODO                        |   13 +
 .../staging/lustre/include/linux/libcfs/bitmap.h   |  111 +
 .../staging/lustre/include/linux/libcfs/curproc.h  |  110 +
 .../staging/lustre/include/linux/libcfs/libcfs.h   |  234 +
 .../lustre/include/linux/libcfs/libcfs_cpu.h       |  214 +
 .../lustre/include/linux/libcfs/libcfs_crypto.h    |  201 +
 .../lustre/include/linux/libcfs/libcfs_debug.h     |  350 ++
 .../lustre/include/linux/libcfs/libcfs_fail.h      |  170 +
 .../lustre/include/linux/libcfs/libcfs_hash.h      |  851 ++++
 .../lustre/include/linux/libcfs/libcfs_heap.h      |  200 +
 .../lustre/include/linux/libcfs/libcfs_ioctl.h     |  222 +
 .../include/linux/libcfs/libcfs_kernelcomm.h       |  117 +
 .../lustre/include/linux/libcfs/libcfs_prim.h      |  101 +
 .../lustre/include/linux/libcfs/libcfs_private.h   |  577 +++
 .../lustre/include/linux/libcfs/libcfs_string.h    |  137 +
 .../lustre/include/linux/libcfs/libcfs_time.h      |  132 +
 .../lustre/include/linux/libcfs/libcfs_workitem.h  |  110 +
 .../lustre/include/linux/libcfs/linux/kp30.h       |  286 ++
 .../lustre/include/linux/libcfs/linux/libcfs.h     |  125 +
 .../include/linux/libcfs/linux/linux-bitops.h      |   38 +
 .../lustre/include/linux/libcfs/linux/linux-cpu.h  |  175 +
 .../include/linux/libcfs/linux/linux-crypto.h      |   49 +
 .../lustre/include/linux/libcfs/linux/linux-fs.h   |   92 +
 .../lustre/include/linux/libcfs/linux/linux-lock.h |  204 +
 .../lustre/include/linux/libcfs/linux/linux-mem.h  |  120 +
 .../lustre/include/linux/libcfs/linux/linux-prim.h |  241 ++
 .../include/linux/libcfs/linux/linux-tcpip.h       |   87 +
 .../lustre/include/linux/libcfs/linux/linux-time.h |  275 ++
 .../include/linux/libcfs/linux/linux-types.h       |   36 +
 .../include/linux/libcfs/linux/portals_compat25.h  |  114 +
 .../staging/lustre/include/linux/libcfs/lucache.h  |  162 +
 .../lustre/include/linux/libcfs/params_tree.h      |  166 +
 .../lustre/include/linux/lnet/api-support.h        |   44 +
 drivers/staging/lustre/include/linux/lnet/api.h    |  220 +
 .../staging/lustre/include/linux/lnet/lib-lnet.h   |  874 ++++
 .../staging/lustre/include/linux/lnet/lib-types.h  |  765 ++++
 .../lustre/include/linux/lnet/linux/api-support.h  |   43 +
 .../lustre/include/linux/lnet/linux/lib-lnet.h     |   72 +
 .../lustre/include/linux/lnet/linux/lib-types.h    |   45 +
 .../staging/lustre/include/linux/lnet/linux/lnet.h |   56 +
 .../lustre/include/linux/lnet/lnet-sysctl.h        |   51 +
 drivers/staging/lustre/include/linux/lnet/lnet.h   |   51 +
 .../staging/lustre/include/linux/lnet/lnetctl.h    |   80 +
 drivers/staging/lustre/include/linux/lnet/lnetst.h |  491 +++
 drivers/staging/lustre/include/linux/lnet/ptllnd.h |   94 +
 .../lustre/include/linux/lnet/ptllnd_wire.h        |  124 +
 .../staging/lustre/include/linux/lnet/socklnd.h    |  103 +
 drivers/staging/lustre/include/linux/lnet/types.h  |  503 +++
 drivers/staging/lustre/lnet/Kconfig                |   40 +
 drivers/staging/lustre/lnet/Makefile               |    1 +
 drivers/staging/lustre/lnet/klnds/Makefile         |    1 +
 drivers/staging/lustre/lnet/klnds/o2iblnd/Makefile |    5 +
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    | 3259 ++++++++++++++
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    | 1057 +++++
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c | 3529 +++++++++++++++
 .../lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c  |  493 +++
 drivers/staging/lustre/lnet/klnds/socklnd/Makefile |    7 +
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    | 2902 +++++++++++++
 .../staging/lustre/lnet/klnds/socklnd/socklnd.h    |  602 +++
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c | 2664 ++++++++++++
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.c  | 1088 +++++
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.h  |   91 +
 .../lustre/lnet/klnds/socklnd/socklnd_modparams.c  |  198 +
 .../lustre/lnet/klnds/socklnd/socklnd_proto.c      |  797 ++++
 drivers/staging/lustre/lnet/lnet/Makefile          |    8 +
 drivers/staging/lustre/lnet/lnet/acceptor.c        |  527 +++
 drivers/staging/lustre/lnet/lnet/api-errno.c       |   39 +
 drivers/staging/lustre/lnet/lnet/api-ni.c          | 1941 +++++++++
 drivers/staging/lustre/lnet/lnet/config.c          | 1264 ++++++
 drivers/staging/lustre/lnet/lnet/lib-eq.c          |  447 ++
 drivers/staging/lustre/lnet/lnet/lib-md.c          |  451 ++
 drivers/staging/lustre/lnet/lnet/lib-me.c          |  297 ++
 drivers/staging/lustre/lnet/lnet/lib-move.c        | 2441 +++++++++++
 drivers/staging/lustre/lnet/lnet/lib-msg.c         |  650 +++
 drivers/staging/lustre/lnet/lnet/lib-ptl.c         |  938 ++++
 drivers/staging/lustre/lnet/lnet/lo.c              |  120 +
 drivers/staging/lustre/lnet/lnet/module.c          |  154 +
 drivers/staging/lustre/lnet/lnet/peer.c            |  337 ++
 drivers/staging/lustre/lnet/lnet/router.c          | 1694 ++++++++
 drivers/staging/lustre/lnet/lnet/router_proc.c     |  950 +++++
 drivers/staging/lustre/lnet/selftest/Makefile      |    6 +
 drivers/staging/lustre/lnet/selftest/brw_test.c    |  499 +++
 drivers/staging/lustre/lnet/selftest/conctl.c      |  931 ++++
 drivers/staging/lustre/lnet/selftest/conrpc.c      | 1397 ++++++
 drivers/staging/lustre/lnet/selftest/conrpc.h      |  146 +
 drivers/staging/lustre/lnet/selftest/console.c     | 2071 +++++++++
 drivers/staging/lustre/lnet/selftest/console.h     |  232 +
 drivers/staging/lustre/lnet/selftest/framework.c   | 1814 ++++++++
 drivers/staging/lustre/lnet/selftest/module.c      |  169 +
 drivers/staging/lustre/lnet/selftest/ping_test.c   |  229 +
 drivers/staging/lustre/lnet/selftest/rpc.c         | 1666 ++++++++
 drivers/staging/lustre/lnet/selftest/rpc.h         |  302 ++
 drivers/staging/lustre/lnet/selftest/selftest.h    |  611 +++
 drivers/staging/lustre/lnet/selftest/timer.c       |  253 ++
 drivers/staging/lustre/lnet/selftest/timer.h       |   53 +
 drivers/staging/lustre/lustre/Kconfig              |   51 +
 drivers/staging/lustre/lustre/Makefile             |    2 +
 drivers/staging/lustre/lustre/fid/Makefile         |    5 +
 drivers/staging/lustre/lustre/fid/fid_handler.c    |  661 +++
 drivers/staging/lustre/lustre/fid/fid_internal.h   |   84 +
 drivers/staging/lustre/lustre/fid/fid_lib.c        |   97 +
 drivers/staging/lustre/lustre/fid/fid_request.c    |  522 +++
 drivers/staging/lustre/lustre/fid/fid_store.c      |  259 ++
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |  222 +
 drivers/staging/lustre/lustre/fld/Makefile         |    5 +
 drivers/staging/lustre/lustre/fld/fld_cache.c      |  566 +++
 drivers/staging/lustre/lustre/fld/fld_handler.c    |  447 ++
 drivers/staging/lustre/lustre/fld/fld_index.c      |  426 ++
 drivers/staging/lustre/lustre/fld/fld_internal.h   |  223 +
 drivers/staging/lustre/lustre/fld/fld_request.c    |  519 +++
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |  373 ++
 drivers/staging/lustre/lustre/include/cl_object.h  | 3279 ++++++++++++++
 drivers/staging/lustre/lustre/include/dt_object.h  | 1498 +++++++
 .../staging/lustre/lustre/include/interval_tree.h  |  124 +
 drivers/staging/lustre/lustre/include/ioctl.h      |  106 +
 drivers/staging/lustre/lustre/include/lclient.h    |  437 ++
 .../lustre/lustre/include/linux/lprocfs_status.h   |   58 +
 .../lustre/lustre/include/linux/lustre_acl.h       |   66 +
 .../lustre/lustre/include/linux/lustre_common.h    |   22 +
 .../lustre/lustre/include/linux/lustre_compat25.h  |  349 ++
 .../lustre/lustre/include/linux/lustre_debug.h     |   47 +
 .../lustre/lustre/include/linux/lustre_dlm.h       |   46 +
 .../lustre/lustre/include/linux/lustre_fsfilt.h    |  181 +
 .../lustre/lustre/include/linux/lustre_handles.h   |   53 +
 .../lustre/lustre/include/linux/lustre_intent.h    |   62 +
 .../lustre/lustre/include/linux/lustre_lib.h       |   87 +
 .../lustre/lustre/include/linux/lustre_lite.h      |  100 +
 .../lustre/lustre/include/linux/lustre_log.h       |   57 +
 .../lustre/lustre/include/linux/lustre_net.h       |   50 +
 .../lustre/include/linux/lustre_patchless_compat.h |   85 +
 .../lustre/lustre/include/linux/lustre_quota.h     |   47 +
 .../lustre/lustre/include/linux/lustre_user.h      |   67 +
 drivers/staging/lustre/lustre/include/linux/lvfs.h |  134 +
 .../lustre/lustre/include/linux/lvfs_linux.h       |   66 +
 drivers/staging/lustre/lustre/include/linux/obd.h  |  128 +
 .../lustre/lustre/include/linux/obd_class.h        |   58 +
 .../lustre/lustre/include/linux/obd_support.h      |   63 +
 .../staging/lustre/lustre/include/lprocfs_status.h | 1043 +++++
 drivers/staging/lustre/lustre/include/lu_object.h  | 1346 ++++++
 drivers/staging/lustre/lustre/include/lu_ref.h     |  170 +
 drivers/staging/lustre/lustre/include/lu_target.h  |   91 +
 .../staging/lustre/lustre/include/lustre/libiam.h  |  145 +
 .../lustre/lustre/include/lustre/liblustreapi.h    |   43 +
 .../lustre/lustre/include/lustre/ll_fiemap.h       |  121 +
 .../lustre/include/lustre/lustre_build_version.h   |    2 +
 .../lustre/lustre/include/lustre/lustre_idl.h      | 3653 ++++++++++++++++
 .../lustre/include/lustre/lustre_lfsck_user.h      |   95 +
 .../lustre/lustre/include/lustre/lustre_user.h     | 1145 +++++
 .../lustre/lustre/include/lustre/lustreapi.h       |  310 ++
 drivers/staging/lustre/lustre/include/lustre_acl.h |   42 +
 .../staging/lustre/lustre/include/lustre_capa.h    |  305 ++
 drivers/staging/lustre/lustre/include/lustre_cfg.h |  299 ++
 .../staging/lustre/lustre/include/lustre_debug.h   |   76 +
 .../staging/lustre/lustre/include/lustre_disk.h    |  543 +++
 drivers/staging/lustre/lustre/include/lustre_dlm.h | 1671 ++++++++
 .../staging/lustre/lustre/include/lustre_eacl.h    |   95 +
 .../staging/lustre/lustre/include/lustre_export.h  |  389 ++
 drivers/staging/lustre/lustre/include/lustre_fid.h |  762 ++++
 drivers/staging/lustre/lustre/include/lustre_fld.h |  202 +
 .../staging/lustre/lustre/include/lustre_fsfilt.h  |   48 +
 drivers/staging/lustre/lustre/include/lustre_ha.h  |   67 +
 .../staging/lustre/lustre/include/lustre_handles.h |   93 +
 .../staging/lustre/lustre/include/lustre_idmap.h   |  104 +
 .../staging/lustre/lustre/include/lustre_import.h  |  367 ++
 drivers/staging/lustre/lustre/include/lustre_lib.h |  667 +++
 .../staging/lustre/lustre/include/lustre_linkea.h  |   57 +
 .../staging/lustre/lustre/include/lustre_lite.h    |  147 +
 drivers/staging/lustre/lustre/include/lustre_log.h |  576 +++
 drivers/staging/lustre/lustre/include/lustre_mdc.h |  176 +
 drivers/staging/lustre/lustre/include/lustre_mds.h |   81 +
 drivers/staging/lustre/lustre/include/lustre_mdt.h |   84 +
 drivers/staging/lustre/lustre/include/lustre_net.h | 3451 +++++++++++++++
 .../staging/lustre/lustre/include/lustre_param.h   |  121 +
 .../staging/lustre/lustre/include/lustre_quota.h   |  239 ++
 .../lustre/lustre/include/lustre_req_layout.h      |  334 ++
 drivers/staging/lustre/lustre/include/lustre_sec.h | 1145 +++++
 .../staging/lustre/lustre/include/lustre_update.h  |  189 +
 drivers/staging/lustre/lustre/include/lustre_ver.h |   24 +
 drivers/staging/lustre/lustre/include/lvfs.h       |   57 +
 drivers/staging/lustre/lustre/include/md_object.h  |  908 ++++
 drivers/staging/lustre/lustre/include/obd.h        | 1677 ++++++++
 drivers/staging/lustre/lustre/include/obd_cache.h  |   39 +
 drivers/staging/lustre/lustre/include/obd_cksum.h  |  176 +
 drivers/staging/lustre/lustre/include/obd_class.h  | 2281 ++++++++++
 drivers/staging/lustre/lustre/include/obd_lov.h    |  126 +
 drivers/staging/lustre/lustre/include/obd_ost.h    |   96 +
 .../staging/lustre/lustre/include/obd_support.h    |  851 ++++
 drivers/staging/lustre/lustre/lclient/glimpse.c    |  274 ++
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 1325 ++++++
 .../staging/lustre/lustre/lclient/lcommon_misc.c   |  194 +
 drivers/staging/lustre/lustre/ldlm/interval_tree.c |  764 ++++
 drivers/staging/lustre/lustre/ldlm/l_lock.c        |   76 +
 drivers/staging/lustre/lustre/ldlm/ldlm_extent.c   |  242 ++
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |  849 ++++
 .../staging/lustre/lustre/ldlm/ldlm_inodebits.c    |   75 +
 drivers/staging/lustre/lustre/ldlm/ldlm_internal.h |  276 ++
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |  868 ++++
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     | 2429 +++++++++++
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    | 1238 ++++++
 drivers/staging/lustre/lustre/ldlm/ldlm_plain.c    |   72 +
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     | 1384 ++++++
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  | 2333 ++++++++++
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c | 1409 ++++++
 drivers/staging/lustre/lustre/libcfs/Makefile      |   21 +
 drivers/staging/lustre/lustre/libcfs/debug.c       |  476 +++
 drivers/staging/lustre/lustre/libcfs/fail.c        |  137 +
 drivers/staging/lustre/lustre/libcfs/hash.c        | 2123 ++++++++++
 drivers/staging/lustre/lustre/libcfs/heap.c        |  475 +++
 .../lustre/lustre/libcfs/kernel_user_comm.c        |  346 ++
 drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c  |  204 +
 drivers/staging/lustre/lustre/libcfs/libcfs_lock.c |  192 +
 drivers/staging/lustre/lustre/libcfs/libcfs_mem.c  |  205 +
 .../staging/lustre/lustre/libcfs/libcfs_string.c   |  647 +++
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c | 1085 +++++
 .../lustre/libcfs/linux/linux-crypto-adler.c       |  144 +
 .../lustre/lustre/libcfs/linux/linux-crypto.c      |  289 ++
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |  339 ++
 .../lustre/lustre/libcfs/linux/linux-debug.c       |  264 ++
 .../lustre/lustre/libcfs/linux/linux-module.c      |  183 +
 .../lustre/lustre/libcfs/linux/linux-prim.c        |  259 ++
 .../lustre/lustre/libcfs/linux/linux-proc.c        |  580 +++
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |  659 +++
 .../lustre/lustre/libcfs/linux/linux-tracefile.c   |  275 ++
 .../lustre/lustre/libcfs/linux/linux-tracefile.h   |   48 +
 drivers/staging/lustre/lustre/libcfs/lwt.c         |  266 ++
 drivers/staging/lustre/lustre/libcfs/module.c      |  498 +++
 drivers/staging/lustre/lustre/libcfs/nidstrings.c  |  867 ++++
 drivers/staging/lustre/lustre/libcfs/prng.c        |  139 +
 drivers/staging/lustre/lustre/libcfs/tracefile.c   | 1195 ++++++
 drivers/staging/lustre/lustre/libcfs/tracefile.h   |  340 ++
 .../staging/lustre/lustre/libcfs/upcall_cache.c    |  462 ++
 drivers/staging/lustre/lustre/libcfs/watchdog.c    |  516 +++
 drivers/staging/lustre/lustre/libcfs/workitem.c    |  475 +++
 drivers/staging/lustre/lustre/llite/Makefile       |   13 +
 drivers/staging/lustre/lustre/llite/dcache.c       |  675 +++
 drivers/staging/lustre/lustre/llite/dir.c          | 1978 +++++++++
 drivers/staging/lustre/lustre/llite/file.c         | 3198 ++++++++++++++
 drivers/staging/lustre/lustre/llite/llite_capa.c   |  661 +++
 drivers/staging/lustre/lustre/llite/llite_close.c  |  412 ++
 .../staging/lustre/lustre/llite/llite_internal.h   | 1576 +++++++
 drivers/staging/lustre/lustre/llite/llite_lib.c    | 2408 +++++++++++
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |  507 +++
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |  319 ++
 drivers/staging/lustre/lustre/llite/llite_rmtacl.c |  301 ++
 drivers/staging/lustre/lustre/llite/lloop.c        |  867 ++++
 drivers/staging/lustre/lustre/llite/lproc_llite.c  | 1370 ++++++
 drivers/staging/lustre/lustre/llite/namei.c        | 1279 ++++++
 drivers/staging/lustre/lustre/llite/remote_perm.c  |  333 ++
 drivers/staging/lustre/lustre/llite/rw.c           | 1314 ++++++
 drivers/staging/lustre/lustre/llite/rw26.c         |  586 +++
 drivers/staging/lustre/lustre/llite/statahead.c    | 1722 ++++++++
 drivers/staging/lustre/lustre/llite/super25.c      |  226 +
 drivers/staging/lustre/lustre/llite/symlink.c      |  192 +
 drivers/staging/lustre/lustre/llite/vvp_dev.c      |  546 +++
 drivers/staging/lustre/lustre/llite/vvp_internal.h |   62 +
 drivers/staging/lustre/lustre/llite/vvp_io.c       | 1186 ++++++
 drivers/staging/lustre/lustre/llite/vvp_lock.c     |   85 +
 drivers/staging/lustre/lustre/llite/vvp_object.c   |  186 +
 drivers/staging/lustre/lustre/llite/vvp_page.c     |  558 +++
 drivers/staging/lustre/lustre/llite/xattr.c        |  578 +++
 drivers/staging/lustre/lustre/lmv/Makefile         |    5 +
 drivers/staging/lustre/lustre/lmv/lmv_fld.c        |   88 +
 drivers/staging/lustre/lustre/lmv/lmv_intent.c     |  328 ++
 drivers/staging/lustre/lustre/lmv/lmv_internal.h   |  159 +
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        | 2727 ++++++++++++
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |  235 +
 drivers/staging/lustre/lustre/lov/Makefile         |    9 +
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |  820 ++++
 drivers/staging/lustre/lustre/lov/lov_dev.c        |  533 +++
 drivers/staging/lustre/lustre/lov/lov_ea.c         |  333 ++
 drivers/staging/lustre/lustre/lov/lov_internal.h   |  323 ++
 drivers/staging/lustre/lustre/lov/lov_io.c         |  967 +++++
 drivers/staging/lustre/lustre/lov/lov_lock.c       | 1253 ++++++
 drivers/staging/lustre/lustre/lov/lov_log.c        |  278 ++
 drivers/staging/lustre/lustre/lov/lov_merge.c      |  218 +
 drivers/staging/lustre/lustre/lov/lov_obd.c        | 2916 +++++++++++++
 drivers/staging/lustre/lustre/lov/lov_object.c     |  942 +++++
 drivers/staging/lustre/lustre/lov/lov_offset.c     |  267 ++
 drivers/staging/lustre/lustre/lov/lov_pack.c       |  678 +++
 drivers/staging/lustre/lustre/lov/lov_page.c       |  235 +
 drivers/staging/lustre/lustre/lov/lov_pool.c       |  681 +++
 drivers/staging/lustre/lustre/lov/lov_request.c    | 1551 +++++++
 drivers/staging/lustre/lustre/lov/lovsub_dev.c     |  211 +
 drivers/staging/lustre/lustre/lov/lovsub_io.c      |   55 +
 drivers/staging/lustre/lustre/lov/lovsub_lock.c    |  485 +++
 drivers/staging/lustre/lustre/lov/lovsub_object.c  |  170 +
 drivers/staging/lustre/lustre/lov/lovsub_page.c    |   72 +
 drivers/staging/lustre/lustre/lov/lproc_lov.c      |  302 ++
 drivers/staging/lustre/lustre/lvfs/Makefile        |    6 +
 drivers/staging/lustre/lustre/lvfs/fsfilt.c        |  138 +
 drivers/staging/lustre/lustre/lvfs/fsfilt_ext3.c   |  761 ++++
 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c      |  173 +
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |  295 ++
 drivers/staging/lustre/lustre/mdc/Makefile         |    5 +
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |  219 +
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |  180 +
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |  564 +++
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      | 1229 ++++++
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |  489 +++
 drivers/staging/lustre/lustre/mdc/mdc_request.c    | 2753 ++++++++++++
 drivers/staging/lustre/lustre/mgc/Makefile         |    5 +
 drivers/staging/lustre/lustre/mgc/libmgc.c         |  166 +
 drivers/staging/lustre/lustre/mgc/lproc_mgc.c      |   84 +
 drivers/staging/lustre/lustre/mgc/mgc_internal.h   |   73 +
 drivers/staging/lustre/lustre/mgc/mgc_request.c    | 1860 ++++++++
 drivers/staging/lustre/lustre/obdclass/Makefile    |   13 +
 drivers/staging/lustre/lustre/obdclass/acl.c       |  546 +++
 drivers/staging/lustre/lustre/obdclass/capa.c      |  401 ++
 .../staging/lustre/lustre/obdclass/cl_internal.h   |  121 +
 drivers/staging/lustre/lustre/obdclass/cl_io.c     | 1753 ++++++++
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   | 2304 ++++++++++
 drivers/staging/lustre/lustre/obdclass/cl_object.c | 1148 +++++
 drivers/staging/lustre/lustre/obdclass/cl_page.c   | 1605 +++++++
 drivers/staging/lustre/lustre/obdclass/class_obd.c |  689 +++
 drivers/staging/lustre/lustre/obdclass/debug.c     |  124 +
 drivers/staging/lustre/lustre/obdclass/dt_object.c | 1055 +++++
 drivers/staging/lustre/lustre/obdclass/genops.c    | 1853 ++++++++
 drivers/staging/lustre/lustre/obdclass/idmap.c     |  474 +++
 drivers/staging/lustre/lustre/obdclass/linkea.c    |  194 +
 .../lustre/lustre/obdclass/linux/linux-module.c    |  408 ++
 .../lustre/lustre/obdclass/linux/linux-obdo.c      |  222 +
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |  445 ++
 drivers/staging/lustre/lustre/obdclass/llog.c      |  966 +++++
 drivers/staging/lustre/lustre/obdclass/llog_cat.c  |  833 ++++
 .../staging/lustre/lustre/obdclass/llog_internal.h |   98 +
 .../staging/lustre/lustre/obdclass/llog_ioctl.c    |  427 ++
 drivers/staging/lustre/lustre/obdclass/llog_lvfs.c |  862 ++++
 drivers/staging/lustre/lustre/obdclass/llog_obd.c  |  319 ++
 drivers/staging/lustre/lustre/obdclass/llog_osd.c  | 1323 ++++++
 drivers/staging/lustre/lustre/obdclass/llog_swab.c |  407 ++
 drivers/staging/lustre/lustre/obdclass/llog_test.c | 1087 +++++
 .../staging/lustre/lustre/obdclass/local_storage.c |  903 ++++
 .../staging/lustre/lustre/obdclass/local_storage.h |   88 +
 .../lustre/lustre/obdclass/lprocfs_jobstats.c      |  562 +++
 .../lustre/lustre/obdclass/lprocfs_status.c        | 1985 +++++++++
 drivers/staging/lustre/lustre/obdclass/lu_object.c | 2185 ++++++++++
 drivers/staging/lustre/lustre/obdclass/lu_ref.c    |   50 +
 drivers/staging/lustre/lustre/obdclass/lu_ucred.c  |  107 +
 .../lustre/lustre/obdclass/lustre_handles.c        |  263 ++
 .../staging/lustre/lustre/obdclass/lustre_peer.c   |  218 +
 drivers/staging/lustre/lustre/obdclass/md_attrs.c  |  202 +
 drivers/staging/lustre/lustre/obdclass/mea.c       |  112 +
 .../staging/lustre/lustre/obdclass/obd_config.c    | 1904 +++++++++
 drivers/staging/lustre/lustre/obdclass/obd_mount.c | 1321 ++++++
 drivers/staging/lustre/lustre/obdclass/obdo.c      |  362 ++
 .../staging/lustre/lustre/obdclass/statfs_pack.c   |   75 +
 drivers/staging/lustre/lustre/obdclass/uuid.c      |   82 +
 drivers/staging/lustre/lustre/obdecho/Makefile     |    5 +
 drivers/staging/lustre/lustre/obdecho/echo.c       |  679 +++
 .../staging/lustre/lustre/obdecho/echo_client.c    | 3223 ++++++++++++++
 .../staging/lustre/lustre/obdecho/echo_internal.h  |   47 +
 drivers/staging/lustre/lustre/obdecho/lproc_echo.c |   57 +
 drivers/staging/lustre/lustre/osc/Makefile         |    7 +
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |  728 ++++
 drivers/staging/lustre/lustre/osc/osc_cache.c      | 2916 +++++++++++++
 .../staging/lustre/lustre/osc/osc_cl_internal.h    |  677 +++
 drivers/staging/lustre/lustre/osc/osc_dev.c        |  261 ++
 drivers/staging/lustre/lustre/osc/osc_internal.h   |  208 +
 drivers/staging/lustre/lustre/osc/osc_io.c         |  836 ++++
 drivers/staging/lustre/lustre/osc/osc_lock.c       | 1663 ++++++++
 drivers/staging/lustre/lustre/osc/osc_object.c     |  275 ++
 drivers/staging/lustre/lustre/osc/osc_page.c       |  927 ++++
 drivers/staging/lustre/lustre/osc/osc_quota.c      |  332 ++
 drivers/staging/lustre/lustre/osc/osc_request.c    | 3708 ++++++++++++++++
 drivers/staging/lustre/lustre/ptlrpc/Makefile      |   23 +
 drivers/staging/lustre/lustre/ptlrpc/client.c      | 3059 +++++++++++++
 drivers/staging/lustre/lustre/ptlrpc/connection.c  |  248 ++
 drivers/staging/lustre/lustre/ptlrpc/events.c      |  595 +++
 drivers/staging/lustre/lustre/ptlrpc/gss/Makefile  |    8 +
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_api.h |  179 +
 .../staging/lustre/lustre/ptlrpc/gss/gss_asn1.h    |   84 +
 .../staging/lustre/lustre/ptlrpc/gss/gss_bulk.c    |  512 +++
 .../lustre/lustre/ptlrpc/gss/gss_cli_upcall.c      |  447 ++
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_err.h |  193 +
 .../lustre/lustre/ptlrpc/gss/gss_generic_token.c   |  285 ++
 .../lustre/lustre/ptlrpc/gss/gss_internal.h        |  526 +++
 .../staging/lustre/lustre/ptlrpc/gss/gss_keyring.c | 1424 +++++++
 .../staging/lustre/lustre/ptlrpc/gss/gss_krb5.h    |  163 +
 .../lustre/lustre/ptlrpc/gss/gss_krb5_mech.c       | 1786 ++++++++
 .../lustre/lustre/ptlrpc/gss/gss_mech_switch.c     |  359 ++
 .../staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c  | 1252 ++++++
 .../staging/lustre/lustre/ptlrpc/gss/gss_rawobj.c  |  242 ++
 .../lustre/lustre/ptlrpc/gss/gss_svc_upcall.c      | 1099 +++++
 .../staging/lustre/lustre/ptlrpc/gss/lproc_gss.c   |  219 +
 drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c | 2916 +++++++++++++
 drivers/staging/lustre/lustre/ptlrpc/import.c      | 1613 +++++++
 drivers/staging/lustre/lustre/ptlrpc/layout.c      | 2396 +++++++++++
 drivers/staging/lustre/lustre/ptlrpc/llog_client.c |  354 ++
 drivers/staging/lustre/lustre/ptlrpc/llog_net.c    |   75 +
 drivers/staging/lustre/lustre/ptlrpc/llog_server.c |  466 ++
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    | 1345 ++++++
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |  728 ++++
 drivers/staging/lustre/lustre/ptlrpc/nrs.c         | 1790 ++++++++
 drivers/staging/lustre/lustre/ptlrpc/nrs_crr.c     |   40 +
 drivers/staging/lustre/lustre/ptlrpc/nrs_fifo.c    |  270 ++
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    | 2575 +++++++++++
 drivers/staging/lustre/lustre/ptlrpc/pers.c        |   75 +
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |  763 ++++
 .../staging/lustre/lustre/ptlrpc/ptlrpc_internal.h |  302 ++
 .../staging/lustre/lustre/ptlrpc/ptlrpc_module.c   |  154 +
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |  827 ++++
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |  357 ++
 drivers/staging/lustre/lustre/ptlrpc/sec.c         | 2465 +++++++++++
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |  880 ++++
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c  | 1233 ++++++
 drivers/staging/lustre/lustre/ptlrpc/sec_gc.c      |  250 ++
 drivers/staging/lustre/lustre/ptlrpc/sec_lproc.c   |  199 +
 drivers/staging/lustre/lustre/ptlrpc/sec_null.c    |  464 ++
 drivers/staging/lustre/lustre/ptlrpc/sec_plain.c   | 1021 +++++
 drivers/staging/lustre/lustre/ptlrpc/service.c     | 3129 ++++++++++++++
 drivers/staging/lustre/lustre/ptlrpc/wirehdr.c     |   47 +
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    | 4474 ++++++++++++++++++++
 drivers/staging/netlogic/xlr_net.c                 |   11 +-
 drivers/staging/nvec/nvec.c                        |   50 +-
 drivers/staging/nvec/nvec.h                        |   25 -
 drivers/staging/nvec/nvec_kbd.c                    |   10 +-
 drivers/staging/octeon-usb/Kconfig                 |   10 +
 drivers/staging/octeon-usb/Makefile                |    3 +
 drivers/staging/octeon-usb/TODO                    |   11 +
 drivers/staging/octeon-usb/cvmx-usb.c              | 3229 ++++++++++++++
 drivers/staging/octeon-usb/cvmx-usb.h              | 1085 +++++
 drivers/staging/octeon-usb/cvmx-usbcx-defs.h       | 1551 +++++++
 drivers/staging/octeon-usb/cvmx-usbnx-defs.h       |  887 ++++
 drivers/staging/octeon-usb/octeon-hcd.c            |  832 ++++
 drivers/staging/ozwpan/Kbuild                      |    3 +-
 drivers/staging/ozwpan/ozappif.h                   |    2 -
 drivers/staging/ozwpan/ozcdev.c                    |    7 +-
 drivers/staging/ozwpan/ozconfig.h                  |    1 -
 drivers/staging/ozwpan/ozevent.c                   |  195 -
 drivers/staging/ozwpan/ozevent.h                   |   32 -
 drivers/staging/ozwpan/ozeventdef.h                |   40 -
 drivers/staging/ozwpan/ozhcd.c                     |   49 +-
 drivers/staging/ozwpan/ozmain.c                    |    9 -
 drivers/staging/ozwpan/ozpd.c                      |   23 +-
 drivers/staging/ozwpan/ozproto.c                   |   17 -
 drivers/staging/ozwpan/ozusbsvc.c                  |    5 -
 drivers/staging/ozwpan/ozusbsvc1.c                 |    5 -
 drivers/staging/panel/panel.c                      |   25 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    4 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c  |   51 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c     |    5 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |    2 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |    5 +-
 drivers/staging/rtl8192u/ieee80211/dot11d.c        |   14 +-
 drivers/staging/rtl8192u/ieee80211/dot11d.h        |   10 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |   94 +-
 .../staging/rtl8192u/ieee80211/ieee80211_crypt.c   |    4 +-
 .../staging/rtl8192u/ieee80211/ieee80211_crypt.h   |    2 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c      |   14 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |    8 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c       |    4 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |   37 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |   78 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |   26 +-
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    |  106 +-
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    |   82 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h   |   10 +-
 .../staging/rtl8192u/ieee80211/rtl819x_TSProc.c    |   30 +-
 drivers/staging/rtl8192u/r8180_93cx6.c             |   44 +-
 drivers/staging/rtl8192u/r8190_rtl8256.c           |   22 +-
 drivers/staging/rtl8192u/r8190_rtl8256.h           |   10 +-
 drivers/staging/rtl8192u/r8192U.h                  |  808 ++--
 drivers/staging/rtl8192u/r8192U_core.c             | 3590 +++++++---------
 drivers/staging/rtl8192u/r8192U_dm.c               |  144 +-
 drivers/staging/rtl8192u/r8192U_hw.h               |    9 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |   36 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.c           |   38 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.h           |    6 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |   54 +-
 drivers/staging/rtl8192u/r819xU_phy.c              | 2390 ++++++-----
 drivers/staging/rtl8192u/r819xU_phy.h              |   88 +-
 drivers/staging/rts5139/rts51x_transport.c         |    8 +-
 drivers/staging/sb105x/sb_pci_mp.c                 |   34 +-
 drivers/staging/sb105x/sb_pci_mp.h                 |    1 -
 drivers/staging/serqt_usb2/serqt_usb2.c            |  288 +-
 drivers/staging/silicom/bp_mod.h                   |    2 -
 drivers/staging/silicom/bpctl_mod.c                |  483 ++-
 drivers/staging/silicom/bypasslib/bp_ioctl.h       |   64 +-
 drivers/staging/silicom/bypasslib/bplibk.h         |   12 +-
 drivers/staging/silicom/bypasslib/bypass.c         |   89 +-
 drivers/staging/slicoss/slicoss.c                  |   18 +-
 drivers/staging/speakup/Kconfig                    |   32 +-
 drivers/staging/speakup/devsynth.c                 |   14 +-
 drivers/staging/speakup/i18n.c                     |   12 +-
 drivers/staging/speakup/kobjects.c                 |   48 +-
 drivers/staging/speakup/main.c                     |   79 +-
 drivers/staging/speakup/serialio.c                 |    4 +-
 drivers/staging/speakup/speakup_acntpc.c           |   22 +-
 drivers/staging/speakup/speakup_apollo.c           |   20 +-
 drivers/staging/speakup/speakup_decext.c           |   20 +-
 drivers/staging/speakup/speakup_decpc.c            |   22 +-
 drivers/staging/speakup/speakup_dectlk.c           |   20 +-
 drivers/staging/speakup/speakup_dtlk.c             |   22 +-
 drivers/staging/speakup/speakup_keypc.c            |   22 +-
 drivers/staging/speakup/speakup_soft.c             |   34 +-
 drivers/staging/speakup/spk_priv.h                 |   13 -
 drivers/staging/speakup/synth.c                    |   38 +-
 drivers/staging/speakup/thread.c                   |    4 +-
 drivers/staging/speakup/varhandlers.c              |   19 +-
 drivers/staging/ti-soc-thermal/ti-thermal-common.c |   30 +-
 drivers/staging/ti-soc-thermal/ti_soc_thermal.txt  |    1 +
 drivers/staging/tidspbridge/core/_tiomap.h         |    6 +-
 drivers/staging/tidspbridge/core/_tiomap_pwr.h     |   10 +-
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |   10 +-
 drivers/staging/tidspbridge/core/ue_deh.c          |    2 +-
 drivers/staging/tidspbridge/core/wdt.c             |    4 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    1 +
 drivers/staging/usbip/usbip_event.c                |    2 +-
 drivers/staging/vme/devices/vme_user.c             |    6 +-
 drivers/staging/vme/devices/vme_user.h             |   12 +-
 drivers/staging/vt6655/80211hdr.h                  |    2 +-
 drivers/staging/vt6655/80211mgr.c                  |   72 +-
 drivers/staging/vt6655/80211mgr.h                  |  107 +-
 drivers/staging/vt6655/aes_ccmp.c                  |   37 +-
 drivers/staging/vt6655/aes_ccmp.h                  |    2 +-
 drivers/staging/vt6655/hostap.c                    |    6 +-
 drivers/staging/vt6655/ioctl.c                     |    9 +-
 drivers/staging/vt6656/mac.c                       |   51 +-
 drivers/staging/vt6656/rf.c                        |  657 ++-
 drivers/staging/vt6656/tether.h                    |   10 -
 drivers/staging/vt6656/tmacro.h                    |    6 -
 drivers/staging/winbond/phy_calibration.c          |    2 +-
 drivers/staging/winbond/reg.c                      |   25 +-
 drivers/staging/winbond/wb35reg.c                  |  265 +-
 drivers/staging/winbond/wb35rx.c                   |    3 +-
 drivers/staging/wlags49_h2/wl_cs.c                 |   16 +-
 drivers/staging/wlags49_h2/wl_cs.h                 |    4 +-
 drivers/staging/wlags49_h2/wl_main.c               |    4 +-
 drivers/staging/wlan-ng/prism2sta.c                |    3 +-
 drivers/staging/xgifb/vb_def.h                     |    5 -
 drivers/staging/xgifb/vb_init.c                    |   92 +-
 drivers/staging/xgifb/vb_setmode.c                 |  433 +-
 drivers/staging/xgifb/vb_setmode.h                 |    1 -
 drivers/staging/zram/Makefile                      |    2 +-
 drivers/staging/zram/zram_drv.c                    |  569 ++-
 drivers/staging/zram/zram_drv.h                    |   36 +-
 drivers/staging/zram/zram_sysfs.c                  |  227 -
 drivers/staging/zsmalloc/zsmalloc-main.c           |    7 +-
 drivers/staging/zsmalloc/zsmalloc.h                |    2 +-
 include/linux/iio/common/st_sensors.h              |   24 +-
 include/linux/iio/frequency/adf4350.h              |    4 +-
 include/linux/platform_data/ad7303.h               |   21 +
 876 files changed, 280728 insertions(+), 21135 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/dac/ad7303.txt
 create mode 100644 Documentation/devicetree/bindings/iio/frequency/adf4350.txt
 create mode 100644 Documentation/devicetree/bindings/iio/magnetometer/ak8975.txt
 create mode 100644 Documentation/devicetree/bindings/staging/imx-drm/ldb.txt
 create mode 100644 drivers/iio/adc/mcp320x.c
 create mode 100644 drivers/iio/dac/ad7303.c
 rename drivers/{staging/iio/gyro/adis16130_core.c => iio/gyro/adis16130.c} (77%)
 create mode 100644 drivers/iio/pressure/Kconfig
 create mode 100644 drivers/iio/pressure/Makefile
 create mode 100644 drivers/iio/pressure/st_pressure.h
 create mode 100644 drivers/iio/pressure/st_pressure_buffer.c
 create mode 100644 drivers/iio/pressure/st_pressure_core.c
 create mode 100644 drivers/iio/pressure/st_pressure_i2c.c
 create mode 100644 drivers/iio/pressure/st_pressure_spi.c
 create mode 100644 drivers/iio/trigger/Kconfig
 create mode 100644 drivers/iio/trigger/Makefile
 create mode 100644 drivers/iio/trigger/iio-trig-interrupt.c
 rename drivers/{staging => }/iio/trigger/iio-trig-sysfs.c (98%)
 create mode 100644 drivers/staging/btmtk_usb/Kconfig
 create mode 100644 drivers/staging/btmtk_usb/Makefile
 create mode 100644 drivers/staging/btmtk_usb/README
 create mode 100644 drivers/staging/btmtk_usb/TODO
 create mode 100644 drivers/staging/btmtk_usb/btmtk_usb.c
 create mode 100644 drivers/staging/btmtk_usb/btmtk_usb.h
 delete mode 100644 drivers/staging/comedi/drivers/acl7225b.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
 delete mode 100644 drivers/staging/comedi/drivers/pcl725.c
 delete mode 100644 drivers/staging/comedi/drivers/pcm3730.c
 create mode 100644 drivers/staging/iio/adc/ad7291.h
 delete mode 100644 drivers/staging/iio/trigger/iio-trig-gpio.c
 create mode 100644 drivers/staging/imx-drm/imx-ldb.c
 create mode 100644 drivers/staging/lustre/Kconfig
 create mode 100644 drivers/staging/lustre/Makefile
 create mode 100644 drivers/staging/lustre/TODO
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/bitmap.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/curproc.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_cpu.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_crypto.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_fail.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_hash.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_heap.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_kernelcomm.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_string.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_time.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_workitem.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/libcfs.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-bitops.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-cpu.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-crypto.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-lock.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-prim.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-tcpip.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-time.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-types.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/portals_compat25.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/lucache.h
 create mode 100644 drivers/staging/lustre/include/linux/libcfs/params_tree.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/api-support.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/api.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/lib-lnet.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/lib-types.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/linux/api-support.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/linux/lib-lnet.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/linux/lib-types.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/linux/lnet.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/lnet-sysctl.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/lnet.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/lnetctl.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/lnetst.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/ptllnd.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/ptllnd_wire.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/socklnd.h
 create mode 100644 drivers/staging/lustre/include/linux/lnet/types.h
 create mode 100644 drivers/staging/lustre/lnet/Kconfig
 create mode 100644 drivers/staging/lustre/lnet/Makefile
 create mode 100644 drivers/staging/lustre/lnet/klnds/Makefile
 create mode 100644 drivers/staging/lustre/lnet/klnds/o2iblnd/Makefile
 create mode 100644 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
 create mode 100644 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
 create mode 100644 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
 create mode 100644 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c
 create mode 100644 drivers/staging/lustre/lnet/klnds/socklnd/Makefile
 create mode 100644 drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
 create mode 100644 drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
 create mode 100644 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
 create mode 100644 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
 create mode 100644 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.h
 create mode 100644 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_modparams.c
 create mode 100644 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/Makefile
 create mode 100644 drivers/staging/lustre/lnet/lnet/acceptor.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/api-errno.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/api-ni.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/config.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/lib-eq.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/lib-md.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/lib-me.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/lib-move.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/lib-msg.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/lib-ptl.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/lo.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/module.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/peer.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/router.c
 create mode 100644 drivers/staging/lustre/lnet/lnet/router_proc.c
 create mode 100644 drivers/staging/lustre/lnet/selftest/Makefile
 create mode 100644 drivers/staging/lustre/lnet/selftest/brw_test.c
 create mode 100644 drivers/staging/lustre/lnet/selftest/conctl.c
 create mode 100644 drivers/staging/lustre/lnet/selftest/conrpc.c
 create mode 100644 drivers/staging/lustre/lnet/selftest/conrpc.h
 create mode 100644 drivers/staging/lustre/lnet/selftest/console.c
 create mode 100644 drivers/staging/lustre/lnet/selftest/console.h
 create mode 100644 drivers/staging/lustre/lnet/selftest/framework.c
 create mode 100644 drivers/staging/lustre/lnet/selftest/module.c
 create mode 100644 drivers/staging/lustre/lnet/selftest/ping_test.c
 create mode 100644 drivers/staging/lustre/lnet/selftest/rpc.c
 create mode 100644 drivers/staging/lustre/lnet/selftest/rpc.h
 create mode 100644 drivers/staging/lustre/lnet/selftest/selftest.h
 create mode 100644 drivers/staging/lustre/lnet/selftest/timer.c
 create mode 100644 drivers/staging/lustre/lnet/selftest/timer.h
 create mode 100644 drivers/staging/lustre/lustre/Kconfig
 create mode 100644 drivers/staging/lustre/lustre/Makefile
 create mode 100644 drivers/staging/lustre/lustre/fid/Makefile
 create mode 100644 drivers/staging/lustre/lustre/fid/fid_handler.c
 create mode 100644 drivers/staging/lustre/lustre/fid/fid_internal.h
 create mode 100644 drivers/staging/lustre/lustre/fid/fid_lib.c
 create mode 100644 drivers/staging/lustre/lustre/fid/fid_request.c
 create mode 100644 drivers/staging/lustre/lustre/fid/fid_store.c
 create mode 100644 drivers/staging/lustre/lustre/fid/lproc_fid.c
 create mode 100644 drivers/staging/lustre/lustre/fld/Makefile
 create mode 100644 drivers/staging/lustre/lustre/fld/fld_cache.c
 create mode 100644 drivers/staging/lustre/lustre/fld/fld_handler.c
 create mode 100644 drivers/staging/lustre/lustre/fld/fld_index.c
 create mode 100644 drivers/staging/lustre/lustre/fld/fld_internal.h
 create mode 100644 drivers/staging/lustre/lustre/fld/fld_request.c
 create mode 100644 drivers/staging/lustre/lustre/fld/lproc_fld.c
 create mode 100644 drivers/staging/lustre/lustre/include/cl_object.h
 create mode 100644 drivers/staging/lustre/lustre/include/dt_object.h
 create mode 100644 drivers/staging/lustre/lustre/include/interval_tree.h
 create mode 100644 drivers/staging/lustre/lustre/include/ioctl.h
 create mode 100644 drivers/staging/lustre/lustre/include/lclient.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lprocfs_status.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_acl.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_common.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_debug.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_dlm.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_handles.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_intent.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_lib.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_lite.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_log.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_net.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_quota.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_user.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lvfs.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/lvfs_linux.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/obd.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/obd_class.h
 create mode 100644 drivers/staging/lustre/lustre/include/linux/obd_support.h
 create mode 100644 drivers/staging/lustre/lustre/include/lprocfs_status.h
 create mode 100644 drivers/staging/lustre/lustre/include/lu_object.h
 create mode 100644 drivers/staging/lustre/lustre/include/lu_ref.h
 create mode 100644 drivers/staging/lustre/lustre/include/lu_target.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre/libiam.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre/liblustreapi.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre/ll_fiemap.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre/lustre_build_version.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre/lustre_lfsck_user.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre/lustre_user.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre/lustreapi.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_acl.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_capa.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_cfg.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_debug.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_disk.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_dlm.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_eacl.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_export.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_fid.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_fld.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_fsfilt.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_ha.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_handles.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_idmap.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_import.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_lib.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_linkea.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_lite.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_log.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_mdc.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_mds.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_mdt.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_net.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_param.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_quota.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_req_layout.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_sec.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_update.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_ver.h
 create mode 100644 drivers/staging/lustre/lustre/include/lvfs.h
 create mode 100644 drivers/staging/lustre/lustre/include/md_object.h
 create mode 100644 drivers/staging/lustre/lustre/include/obd.h
 create mode 100644 drivers/staging/lustre/lustre/include/obd_cache.h
 create mode 100644 drivers/staging/lustre/lustre/include/obd_cksum.h
 create mode 100644 drivers/staging/lustre/lustre/include/obd_class.h
 create mode 100644 drivers/staging/lustre/lustre/include/obd_lov.h
 create mode 100644 drivers/staging/lustre/lustre/include/obd_ost.h
 create mode 100644 drivers/staging/lustre/lustre/include/obd_support.h
 create mode 100644 drivers/staging/lustre/lustre/lclient/glimpse.c
 create mode 100644 drivers/staging/lustre/lustre/lclient/lcommon_cl.c
 create mode 100644 drivers/staging/lustre/lustre/lclient/lcommon_misc.c
 create mode 100644 drivers/staging/lustre/lustre/ldlm/interval_tree.c
 create mode 100644 drivers/staging/lustre/lustre/ldlm/l_lock.c
 create mode 100644 drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
 create mode 100644 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
 create mode 100644 drivers/staging/lustre/lustre/ldlm/ldlm_inodebits.c
 create mode 100644 drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
 create mode 100644 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
 create mode 100644 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
 create mode 100644 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
 create mode 100644 drivers/staging/lustre/lustre/ldlm/ldlm_plain.c
 create mode 100644 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
 create mode 100644 drivers/staging/lustre/lustre/ldlm/ldlm_request.c
 create mode 100644 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/Makefile
 create mode 100644 drivers/staging/lustre/lustre/libcfs/debug.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/fail.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/hash.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/heap.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/kernel_user_comm.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/libcfs_lock.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/libcfs_mem.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/libcfs_string.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/linux/linux-crypto-adler.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.h
 create mode 100644 drivers/staging/lustre/lustre/libcfs/lwt.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/module.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/nidstrings.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/prng.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/tracefile.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/tracefile.h
 create mode 100644 drivers/staging/lustre/lustre/libcfs/upcall_cache.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/watchdog.c
 create mode 100644 drivers/staging/lustre/lustre/libcfs/workitem.c
 create mode 100644 drivers/staging/lustre/lustre/llite/Makefile
 create mode 100644 drivers/staging/lustre/lustre/llite/dcache.c
 create mode 100644 drivers/staging/lustre/lustre/llite/dir.c
 create mode 100644 drivers/staging/lustre/lustre/llite/file.c
 create mode 100644 drivers/staging/lustre/lustre/llite/llite_capa.c
 create mode 100644 drivers/staging/lustre/lustre/llite/llite_close.c
 create mode 100644 drivers/staging/lustre/lustre/llite/llite_internal.h
 create mode 100644 drivers/staging/lustre/lustre/llite/llite_lib.c
 create mode 100644 drivers/staging/lustre/lustre/llite/llite_mmap.c
 create mode 100644 drivers/staging/lustre/lustre/llite/llite_nfs.c
 create mode 100644 drivers/staging/lustre/lustre/llite/llite_rmtacl.c
 create mode 100644 drivers/staging/lustre/lustre/llite/lloop.c
 create mode 100644 drivers/staging/lustre/lustre/llite/lproc_llite.c
 create mode 100644 drivers/staging/lustre/lustre/llite/namei.c
 create mode 100644 drivers/staging/lustre/lustre/llite/remote_perm.c
 create mode 100644 drivers/staging/lustre/lustre/llite/rw.c
 create mode 100644 drivers/staging/lustre/lustre/llite/rw26.c
 create mode 100644 drivers/staging/lustre/lustre/llite/statahead.c
 create mode 100644 drivers/staging/lustre/lustre/llite/super25.c
 create mode 100644 drivers/staging/lustre/lustre/llite/symlink.c
 create mode 100644 drivers/staging/lustre/lustre/llite/vvp_dev.c
 create mode 100644 drivers/staging/lustre/lustre/llite/vvp_internal.h
 create mode 100644 drivers/staging/lustre/lustre/llite/vvp_io.c
 create mode 100644 drivers/staging/lustre/lustre/llite/vvp_lock.c
 create mode 100644 drivers/staging/lustre/lustre/llite/vvp_object.c
 create mode 100644 drivers/staging/lustre/lustre/llite/vvp_page.c
 create mode 100644 drivers/staging/lustre/lustre/llite/xattr.c
 create mode 100644 drivers/staging/lustre/lustre/lmv/Makefile
 create mode 100644 drivers/staging/lustre/lustre/lmv/lmv_fld.c
 create mode 100644 drivers/staging/lustre/lustre/lmv/lmv_intent.c
 create mode 100644 drivers/staging/lustre/lustre/lmv/lmv_internal.h
 create mode 100644 drivers/staging/lustre/lustre/lmv/lmv_obd.c
 create mode 100644 drivers/staging/lustre/lustre/lmv/lproc_lmv.c
 create mode 100644 drivers/staging/lustre/lustre/lov/Makefile
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_cl_internal.h
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_dev.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_ea.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_internal.h
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_io.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_lock.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_log.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_merge.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_obd.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_object.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_offset.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_pack.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_page.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_pool.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lov_request.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lovsub_dev.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lovsub_io.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lovsub_lock.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lovsub_object.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lovsub_page.c
 create mode 100644 drivers/staging/lustre/lustre/lov/lproc_lov.c
 create mode 100644 drivers/staging/lustre/lustre/lvfs/Makefile
 create mode 100644 drivers/staging/lustre/lustre/lvfs/fsfilt.c
 create mode 100644 drivers/staging/lustre/lustre/lvfs/fsfilt_ext3.c
 create mode 100644 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
 create mode 100644 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
 create mode 100644 drivers/staging/lustre/lustre/mdc/Makefile
 create mode 100644 drivers/staging/lustre/lustre/mdc/lproc_mdc.c
 create mode 100644 drivers/staging/lustre/lustre/mdc/mdc_internal.h
 create mode 100644 drivers/staging/lustre/lustre/mdc/mdc_lib.c
 create mode 100644 drivers/staging/lustre/lustre/mdc/mdc_locks.c
 create mode 100644 drivers/staging/lustre/lustre/mdc/mdc_reint.c
 create mode 100644 drivers/staging/lustre/lustre/mdc/mdc_request.c
 create mode 100644 drivers/staging/lustre/lustre/mgc/Makefile
 create mode 100644 drivers/staging/lustre/lustre/mgc/libmgc.c
 create mode 100644 drivers/staging/lustre/lustre/mgc/lproc_mgc.c
 create mode 100644 drivers/staging/lustre/lustre/mgc/mgc_internal.h
 create mode 100644 drivers/staging/lustre/lustre/mgc/mgc_request.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/Makefile
 create mode 100644 drivers/staging/lustre/lustre/obdclass/acl.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/capa.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/cl_internal.h
 create mode 100644 drivers/staging/lustre/lustre/obdclass/cl_io.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/cl_lock.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/cl_object.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/cl_page.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/class_obd.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/debug.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/dt_object.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/genops.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/idmap.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/linkea.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/linux/linux-obdo.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/llog.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/llog_cat.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/llog_internal.h
 create mode 100644 drivers/staging/lustre/lustre/obdclass/llog_ioctl.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/llog_lvfs.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/llog_obd.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/llog_osd.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/llog_swab.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/llog_test.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/local_storage.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/local_storage.h
 create mode 100644 drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/lu_object.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/lu_ref.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/lu_ucred.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/lustre_handles.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/lustre_peer.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/md_attrs.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/mea.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/obd_config.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/obd_mount.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/obdo.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/statfs_pack.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/uuid.c
 create mode 100644 drivers/staging/lustre/lustre/obdecho/Makefile
 create mode 100644 drivers/staging/lustre/lustre/obdecho/echo.c
 create mode 100644 drivers/staging/lustre/lustre/obdecho/echo_client.c
 create mode 100644 drivers/staging/lustre/lustre/obdecho/echo_internal.h
 create mode 100644 drivers/staging/lustre/lustre/obdecho/lproc_echo.c
 create mode 100644 drivers/staging/lustre/lustre/osc/Makefile
 create mode 100644 drivers/staging/lustre/lustre/osc/lproc_osc.c
 create mode 100644 drivers/staging/lustre/lustre/osc/osc_cache.c
 create mode 100644 drivers/staging/lustre/lustre/osc/osc_cl_internal.h
 create mode 100644 drivers/staging/lustre/lustre/osc/osc_dev.c
 create mode 100644 drivers/staging/lustre/lustre/osc/osc_internal.h
 create mode 100644 drivers/staging/lustre/lustre/osc/osc_io.c
 create mode 100644 drivers/staging/lustre/lustre/osc/osc_lock.c
 create mode 100644 drivers/staging/lustre/lustre/osc/osc_object.c
 create mode 100644 drivers/staging/lustre/lustre/osc/osc_page.c
 create mode 100644 drivers/staging/lustre/lustre/osc/osc_quota.c
 create mode 100644 drivers/staging/lustre/lustre/osc/osc_request.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/Makefile
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/client.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/connection.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/events.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/Makefile
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_api.h
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_asn1.h
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_bulk.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_cli_upcall.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_err.h
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_generic_token.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_internal.h
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_keyring.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5.h
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_mech_switch.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_rawobj.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_svc_upcall.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/lproc_gss.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/import.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/layout.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/llog_client.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/llog_net.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/llog_server.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/niobuf.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/nrs.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/nrs_crr.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/nrs_fifo.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/pers.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/pinger.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/ptlrpc_module.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/recover.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/sec.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/sec_config.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/sec_gc.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/sec_lproc.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/sec_null.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/sec_plain.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/service.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/wirehdr.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/wiretest.c
 create mode 100644 drivers/staging/octeon-usb/Kconfig
 create mode 100644 drivers/staging/octeon-usb/Makefile
 create mode 100644 drivers/staging/octeon-usb/TODO
 create mode 100644 drivers/staging/octeon-usb/cvmx-usb.c
 create mode 100644 drivers/staging/octeon-usb/cvmx-usb.h
 create mode 100644 drivers/staging/octeon-usb/cvmx-usbcx-defs.h
 create mode 100644 drivers/staging/octeon-usb/cvmx-usbnx-defs.h
 create mode 100644 drivers/staging/octeon-usb/octeon-hcd.c
 delete mode 100644 drivers/staging/ozwpan/ozevent.c
 delete mode 100644 drivers/staging/ozwpan/ozevent.h
 delete mode 100644 drivers/staging/ozwpan/ozeventdef.h
 delete mode 100644 drivers/staging/zram/zram_sysfs.c
 create mode 100644 include/linux/platform_data/ad7303.h
