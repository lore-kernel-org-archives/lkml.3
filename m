Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277Ab3IBX4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 19:56:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab3IBX4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 19:56:19 -0400
Date: Mon, 2 Sep 2013 16:58:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver patches for 3.12-rc1
Message-ID: <20130902235853.GD4544@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.12-rc1

for you to fetch changes up to 91121c103ae93ef117e58712786864270d7f488e:

  staging: dwc2: make dwc2_core_params documentation more complete (2013-08-30 14:14:54 -0700)

----------------------------------------------------------------
staging tree merge for 3.12-rc1

Here's the bit staging tree pull request for 3.12-rc1.

Lots of staging driver updates, and fixes.  Lustre is finally enabled in
the build, and lots of cleanup started happening in it.  There's a new
wireless driver in here, and 2 new TTY drivers, which cause the overall
lines added/removed to be quite large on the "added" side.

The IIO driver updates are also coming through here, as they are tied to
the staging iio drivers.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (46):
      staging: xgifb: delete unused "rateindex" parameters
      staging: xgifb: delete unused "ModeNo" parameters
      staging: xgifb: delete unused "ModeIdIndex" parameters
      staging: xgifb: delete unused "HwDeviceExtension" parameters
      staging: xgifb: delete unused "RefreshRateTableIndex" parameters
      staging: xgifb: delete unused "pVBInfo" parameters
      staging: octeon-usb: depend on CAVIUM_OCTEON_SOC
      staging: octeon-usb: use correct board type for EdgeRouter Lite
      staging: octeon-usb: cvmx-usb: delete driver-specific tracing code
      staging: octeon-usb: cvmx-usb: delete redundant debug flags
      staging: octeon-usb: cvmx-usb: delete redundant example code
      staging: octeon-usb: cvmx-usb: delete __cplusplus
      staging: octeon-usb: cvmx-usb: utilize Linux error codes
      staging: octeon-usb: cvmx-usb: eliminate cvmx_likely/unlikely
      staging: octeon-usb: cvmx-usb: replace long udelays with mdelays
      staging: octeon-usb: cvmx-usb: replace cvmx_wait_usec with udelay
      staging: octeon-usb: cvmx-usb: replace cvmx_le16_to_cpu with le16_to_cpu
      staging: octeon-usb: cvmx-usb: delete __cvmx_usb_complete_to_string()
      staging: octeon-usb: cvmx-usb: fix whitespace issues
      staging: octeon-usb: cvmx-usb: reformat long comments
      staging: octeon-usb: cvmx-usb: delete @INTERNAL
      staging: octeon-usb: cvmx-usb: delete duplicated documentation from .h file
      staging: octeon-usb: cvmx-usb: convert @param
      staging: octeon-usb: cvmx-usb: convert @return
      staging: octeon-usb: cvmx-usb: delete CVS keyword markers
      staging: octeon-usb: cvmx-usb: reformat documentation
      staging: octeon-usb: cvmx_usb_speed_t -> enum cvmx_usb_speed
      staging: octeon-usb: cvmx_usb_transfer_t -> enum cvmx_usb_transfer
      staging: octeon-usb: cvmx_usb_direction_t -> enum cvmx_usb_direction
      staging: octeon-usb: cvmx_usb_complete_t -> enum cvmx_usb_complete
      staging: octeon-usb: cvmx_usb_callback_t -> enum cvmx_usb_callback
      staging: octeon-usb: cvmx_usb_initialize_flags_t -> enum cvmx_usb_initialize_flags
      staging: octeon-usb: cvmx_usb_pipe_flags_t -> enum cvmx_usb_pipe_flags
      staging: octeon-usb: cvmx_usb_isochronous_flags_t -> enum cvmx_usb_isochronous_flags
      staging: octeon-usb: cvmx_usb_transaction_flags_t -> enum cvmx_usb_transaction_flags
      staging: octeon-usb: cvmx_usb_stage_t -> enum cvmx_usb_stage
      staging: octeon-usb: cvmx_usb_port_status_t -> struct cvmx_usb_port_status
      staging: octeon-usb: cvmx_usb_iso_packet_t -> struct cvmx_usb_iso_packet
      staging: octeon-usb: cvmx_usb_state_t -> struct cvmx_usb_state
      staging: octeon-usb: cvmx_usb_transaction_t -> struct cvmx_usb_transaction
      staging: octeon-usb: cvmx_usb_pipe_t -> struct cvmx_usb_pipe
      staging: octeon-usb: cvmx_usb_pipe_list_t -> struct cvmx_usb_pipe_list
      staging: octeon-usb: cvmx_usb_tx_fifo_t -> struct cvmx_usb_tx_fifo
      staging: octeon-usb: cvmx_usb_internal_state_t -> struct cvmx_usb_internal_state
      staging: octeon-usb: cvmx_usb_control_header_t -> union cvmx_usb_control_header
      staging: octeon-usb: eliminate remaining typedef unions

Alexander Holler (4):
      iio: hid-sensor-accel-3d: add module alias for autoload
      iio: hid-sensor-gyro-3d: add module alias for autoload
      iio: hid-sensor-als: add module alias for autoload
      iio: hid-sensor-magn-3d: add module alias for autoload

Alexander.Boyko (1):
      staging/lustre/crypto: add crc32c module loading to libcfs

Alexandre Belloni (1):
      iio: Add Nuvoton NAU7802 ADC driver

Andrea Merello (1):
      staging: Update e-mail address for Andrea Merello

Andreas Dilger (2):
      staging/lustre/ldlm: print FID in lvbo_init(), lvbo_update
      staging/lustre/mdt: duplicate link names in directory

Andreas Werner (1):
      Staging: imx-drm: imx-tve.c Fixed 80 character line coding style issue

Andrew Morton (1):
      drivers/staging/comedi/drivers/das16.c: needs slab.h

Andriy Skulysh (1):
      staging/lustre/ldlm: Fix flock deadlock detection race

Andy Shevchenko (2):
      staging: rtl8712: return MAC in standard form
      staging: lustre: re-use kbasename() common helper

Anthony Foiani (7):
      staging: usbip: clean up checkpatch warnings in usbipd.c
      staging: usbip: use local variable while setting up socket
      staging: usbip: improve error reporting
      staging: usbip: add "-P" / "--pid" option to save usbipd process id
      staging: usbip: set usbipd server port via "-t" / "--tcp-port" option.
      staging: usbip: properly handle "-l" / "--log" option
      staging: usbip: fix up alignment in long options list

Bruce Korb (1):
      staging/lustre/dlmlock: compress out unused space

Bruno Faccini (1):
      staging/lustre/mdc: Keep resend FLocks

Chad Williamson (3):
      Staging: silicom: remove the bpctl_dev_t typdef
      Staging: silicom: remove the typedef for bpmod_info_t
      Staging: silicom: remove typedef for dev_desc_t

Chen Gang (1):
      staging: dgnc: Kconfig: add dependency PCI for it

Dan Carpenter (10):
      staging: ozwpan: Separate success & failure case for oz_hcd_pd_arrived()
      staging: comedi: usbdux: allocating too much data
      staging: comedi: dt282x: dt282x_ai_insn_read() always fails
      staging: comedi: pcl812: missing break statement
      staging: gdm7240: fix error handling of probe()
      staging: drm/imx: ipu-dc: signedness bug in ipu_dc_init_sync()
      staging: r8188eu: off by one bugs
      staging: rtl8188eu: || vs && typo
      staging: r8188eu: copying one byte too much
      staging: rtl8188eu: off by one in rtw_set_802_11_add_wep()

Daniel Vetter (1):
      drm/imx: kill firstopen callback

Denis CIOCCA (1):
      iio: Added ST-sensors platform data to select the DRDY interrupt pin

Dmitry Eremin (2):
      staging/lustre/llite: A not locked mutex can be unlocked.
      staging/lustre/ptlrpc: race in pinger (use-after-free situation)

Dragos Foianu (1):
      staging/lustre/libcfs: removed dead code from libcfs_string

Eli Billauer (4):
      staging: New driver: Xillybus generic interface for FPGA
      staging: xillybus: Multiple definition of xillyname resolved (bug fix)
      staging: xillybus: Removed dependency on OF_DEVICE in Kconfig
      staging: xillybus: Fixed sparse errors

Emil Goode (2):
      staging: lustre: Fix non-ANSI sparse warnings
      staging: lustre: Fix sparse warnings about use of obsolete initializer

Fabio Estevam (16):
      imx-drm: imx-drm-core: Export imx_drm_encoder_get_mux_id
      imx-drm: ipu-dp: Check the return value of devm_kzalloc()
      imx-drm: ipu-dp: Remove unneeded braces
      imx-drm: ipu-dp: Introduce IPUV3_NUM_FLOWS
      imx-drm: imx-tve: Provide __acquires/__releases annotation
      imx-drm: TODO: Remove LVDS support from missing features list.
      imx-drm: imx-tve: Remove unneeded check for platform_get_resource()
      imx-drm: ipu-common: Simplify the error path
      imx-drm: ipu-common: Check the return value from clk_prepare_enable()
      imx-drm: ipu-common: Add MODULE_ALIAS
      iio: mxs-lradc: Check the return value from stmp_reset_block()
      imx-drm: ipu-di: Check the return value from clk_prepare_enable()
      imx-drm: imx-ldb: Add MODULE_ALIAS()
      imx-drm: imx-tve: Add MODULE_ALIAS()
      imx-drm: parallel-display: Add MODULE_ALIAS()
      imx-drm: ipuv3-crtc: Add MODULE_ALIAS()

Fan Yong (3):
      staging/lustre/lfsck: LFSCK 1.5 technical debts (3)
      staging/lustre/llite: return valid fsid for statfs
      staging/lustre/scrub: purge inconsistenct objects after OI scrub

Fengguang Wu (2):
      staging: gdm7240: gdm_driver[] can be static
      staging: ozwpan: oz_pd_free() can be static

Geert Uytterhoeven (3):
      staging: comedi: Add missing #include <linux/slab.h>
      staging: lustre: Use proper constant types for L*_POISON values
      staging: dgap: Add missing #include <linux/slab.h>

Greg Kroah-Hartman (59):
      staging: lustre: remove unused "helper" macros
      staging: lustre: remove [f]printf() macros that aren't being used
      staging: lustre: don't use time() or CFS_CURRENT_TIME
      staging: lustre: a typedef for 'struct miscdevice'???
      staging: lustre: NR_CPUS is always defined
      staging: gdm724x: gdm_tty: fix tty api build warnings
      staging: gdm724x: add tty stuff to TODO file.
      staging: gdm724x: remove unneeded TO_HOST_SUCCESS enum
      staging: gdm724x: fix up line lengths in the .h files
      staging: gdm724x: prevent module from being built in
      staging: gdm724x: remove ioctl call
      staging: xillybus: force to be a module
      staging: asus_oled: delete driver
      Merge 3.11-rc3 into staging-next
      staging: gdm724x: depend on CONFIG_TTY
      staging: lustre: remove ll_blkdev_put()
      staging: lustre: remove ll_dentry_open()
      staging: lustre: remove ll_generic_file_llseek_size()
      staging: lustre: remove ll_permission()
      staging: lustre: remove ll_generic_permission()
      staging: lustre: remove ll_vfs_symlink()
      staging: lustre: remove ll_invalidate_bdev()
      staging: lustre: remove ENTRY/EXIT_NESTING stuff
      staging: lustre: remove ENTRY macro
      staging: lustre: remove RETURN_EXIT macro
      staging: lustre: remove EXIT macro
      staging: lustre: remove RETURN macro
      staging: lustre: remove cfs_register_sysctl_table macro
      staging: lustre: remove almost all crypto layer wrappers
      staging: lustre: remove ll_crypto_alloc_blkcipher
      staging: lustre: remove cfs_for_each_possible_cpu()
      staging: lustre: remove unused cfs_"symbol" macros
      staging: lustre: remove typedef for module_t
      staging: lustre: remove typedef for group_info_t
      staging: lustre: remove wrappers for two atomic functions
      staging: lustre: remove cfs_module() macro
      staging: lustre: remove unused cfs_ waitqueue wrappers
      staging: lustre: remove timer_list_t typedef
      staging: lustre: remove CFS_DECL_WAITQ() macro
      staging: lustre: remove cfs_task_state_t
      staging: lustre: remove task_t typedef
      staging: lustre: remove strange journal macros into the one file using them
      staging: lustre: remove proc_dir_entry_t typedef
      Merge tag 'iio-for-3.12a' of git://git.kernel.org/.../jic23/iio into staging-next
      Revert "iio: add configuration option for debug support"
      Merge 3.11-rc5 into staging-next
      staging: zcache: delete it
      Revert "staging: comedi: drivers: use comedi_dio_insn_config() for complex cases"
      Revert "staging: comedi: core: introduce comedi_dio_insn_config()"
      Revert "staging: comedi: skel: use comedi_dio_insn_config()"
      Merge tag 'iio-for-3.12b' of git://git.kernel.org/.../jic23/iio into staging-next
      staging: wlags49_h2: remove sysfs file
      staging: android: timed_output: fix sysfs file creation race
      staging: frontier: use better DEVICE_ATTR_ macros
      staging: keucr: be explicit to the sysfs file permissions
      staging: quickstart: fix up sysfs file permissions
      staging: line6: use default sysfs attribute macros
      staging: usbip: use DEVICE_ATTR_RO/RW for sysfs attributes
      Merge tag 'iio-for-3.12c' of git://git.kernel.org/.../jic23/iio into staging-next

Grygorii Strashko (1):
      iio: core: implement devm_iio_device_alloc/devm_iio_device_free

H Hartley Sweeten (160):
      staging: comedi: drivers: introduce comedi_alloc_devpriv()
      staging: comedi: use comedi_alloc_devpriv()
      staging: comedi: don't rely on comedidev.h to include headers
      staging: comedi: drivers do not need <linux/ioport.h>
      staging: comedi: do not include <linux/delay.h> if its not needed
      staging: comedi: ii_pci20kc: this is an ISA board not a PCI board
      staging: comedi: pcl724: add support for the PCM-IO48 PC/104 board
      staging: comedi: ni_mio_common: needs <linux/delay.h>
      staging: comedi: comedi_buf: needs <linux/vmalloc.h>
      staging: comedi: mite.h: needs <linux/slab.h>
      staging: comedi: usbdux: rename struct usbduxsub
      staging: comedi: usbdux: remove the usb_driver (*probe) noise
      staging: comedi: usbdux: tidy up usbdux_usb_probe()
      staging: comedi: usbdux: move usb buffer allocation into new function
      staging: comedi: usbdux: push usb (*disconnect) into comedi (*detach)
      staging: comedi: usbdux: push usb (*probe) into comedi (*auto_attach)
      staging: comedi: usbdux: remove unnecessary tidy_up() calls
      staging: comedi: usbdux: cleanup the (*detach)
      staging: comedi: usbdux: remove NOISY_DUX_DEBUGBUG
      staging: comedi: usbdux: tidy up usbdux_attach_common()
      staging: comedi: usbdux: absorb usbdux_attach_common into caller
      staging: comedi: usbdux: tidy up usbduxsub_ai_isoc_irq()
      staging: comedi: usbdux: tidy up usbduxsub_ao_isoc_irq()
      staging: comedi: usbdux: tidy up usbduxsub_pwm_irq()
      staging: comedi: usbdux: remove the SUBDEV_* defines
      staging: comedi: usbdux: tidy up the comedi_lrange tables
      staging: comedi: usbdux: remove dev_printk() noise
      staging: comedi: usbdux: tidy up usbduxsub_submit_inurbs()
      staging: comedi: usbdux: tidy up usbduxsub_submit_outurbs()
      staging: comedi: usbdux: tidy up usbduxsub_submit_pwm_urbs()
      staging: comedi: usbdux: remove 'comedidev' from private data
      staging: comedi: usbdux: remove 'interface' from private data
      staging: comedi: usbdux: tidy up send_dux_commands()
      staging: comedi: usbdux: tidy up receive_dux_commands()
      staging: comedi: usbdux: pass comedi_device pointer to usbdux_alloc_usb_buffers()
      staging: comedi: usbdux: remove usb_device back pointer from private data
      staging: comedi: usbdux: remove 'ifnum' from the private data
      staging: comedi: usbdux: make private data flags bit-fields
      staging: comedi: usbdux: tidy up usbdux_ai_stop()
      staging: comedi: usbdux: tidy up usbdux_ai_cancel()
      staging: comedi: usbdux: tidy up usbdux_ao_stop()
      staging: comedi: usbdux: tidy up usbdux_ao_cancel()
      staging: comedi: range: tidy up comedi_check_chanlist()
      staging: comedi: adv_pci1724: remove ao_range_list_1724
      staging: comedi: addi_apci_1710: fix some compile errors/warnings
      staging: comedi: addi_apci_1710: separate from addi_common.h
      staging: comedi: addi_apci_1710: delete driver
      staging: comedi: addi_common.h: cleanup after removal of addi_apci_1710
      staging: comedi: ii_pci20kc: use comedi_alloc_spriv()
      staging: comedi: ii_pci20kc: remove forward declarations 1
      staging: comedi: ii_pci20kc: remove forward declarations 2
      staging: comedi: ii_pci20kc: remove forward declarations 3
      staging: comedi: ii_pci20kc: move comedi_lrange tables
      staging: comedi: ii_pci20kc: remove CHAN macro
      staging: comedi: ii_pci20kc.c: cleanup the dio subdevice
      staging: comedi: ii_pci20kc.c: tidy up the subdevice module init
      staging: comedi: ii_pci20kc.c: remove 'iobase' from the subdevice private data
      staging: comedi: ii_pci20kc.c: break up the subdevice private data union
      staging: comedi: ii_pci20kc: cleanup the ao subdevice
      staging: comedi: ii_pci20kc: cleanup the ai subdevice
      staging: comedi: ii_pci20kc: cleanup final pieces
      staging: comedi: usbduxsigma: set *_cmd_running flags before submitting urbs
      staging: comedi: usbdux: tidy up usbdux_ai_inttrig()
      staging: comedi: usbdux: tidy up usbdux_ai_cmd()
      staging: comedi: usbdux: tidy up usbdux_ai_insn_read()
      staging: comedi: usbdux: clarify bipolar ai data
      staging: comedi: usbdux: tidy up usbdux_ao_insn_read()
      staging: comedi: usbdux: tidy up usbdux_ao_insn_write()
      staging: comedi: usbdux: tidy up usbdux_ao_inttrig()
      staging: comedi: usbdux: tidy up usbdux_ao_cmd()
      staging: comedi: usbdux: tidy up usbdux_dio_insn_config()
      staging: comedi: usbdux: tidy up usbdux_dio_insn_bits()
      staging: comedi: usbdux: fix usbdux_counter_read()
      staging: comedi: usbdux: fix usbdux_counter_write()
      staging: comedi: usbdux: tidy up usbdux_pwm_stop()
      staging: comedi: usbdux: fix usbdux_pwm_cancel()
      staging: comedi: usbdux: fix usbdux_pwm_start()
      staging: comedi: usbdux: tidy up unlink and stop helpers
      staging: comedi: usbdux: use the stop helpers in the detach
      staging: comedi: usbdux: remove the usb endpoint defines
      staging: comedi: usbdux: remove some unused defines
      staging: comedi: usbdux: move usbdux_firmware_upload()
      staging: comedi: usbdux: clarify bipolar ai data in usbduxsub_ai_isoc_irq()
      staging: comedi: usbdux: rename private data variables
      staging: comedi: usbdux: cleanup the private data 'outBuffer'
      staging: comedi: usbdux: simplify initializing the ao urb transfer_buffer
      staging: comedi: usbdux: remove unnecessary check in usbdux_ai_cmd()
      staging: comedi: usbdux: remove unnecessary check in usbdux_ao_cmd()
      staging: comedi: usbdux: 'dac_commands' does not need to be kzalloc()'d
      staging: comedi: usbdux: remove unused define
      staging: comedi: usbdux: move and rename the bulk transfer commands
      staging: comedi: usbdux: consolidate usbduxsub_unlink_{in, out}urbs()
      staging: comedi: das16: "timer_mode" is always used for DMA
      staging: comedi: das16: remove DMA irq support
      staging: comedi: das16: fix DMA init during board attach
      staging: comedi: das16: all supported board have analog inputs
      staging: comedi: das16: change boardinfo 'ai_nbits' to 'ai_maxdata'
      staging: comedi: das16: all supported board have digital inputs
      staging: comedi: das16: all supported board have digital outputs
      staging: comedi: das16: cleanup analog output subdevice
      staging: comedi: das16: tidy up the comedi_lrange tables
      staging: comedi: das16: remove unused struct definition
      staging: comedi: das16: remove 'ai_unipolar' and 'ai_singleended'
      staging: comedi: das16: remove reg_dump()
      staging: comedi: das16: remove DEBUG_PRINT macro
      staging: comedi: das16: remove 'volatile' on private data variables
      staging: comedi: das16: add a 'can_burst' flag to the private data
      staging: comedi: das16: remove unused DAS16_SIZE
      staging: comedi: das16: remove unused static const variable
      staging: comedi: das16: remove the register map comments
      staging: comedi: das16: introduce das16_ai_{en, dis}able() helpers
      staging: comedi: das16: tidy up das16_ai_insn_read()
      staging: comedi: das16: move some functions to improve readability
      staging: comedi: das16: remove unnecessary test in das16_interrupt()
      staging: comedi: das16: move boardinfo declaration
      staging: comedi: das16: remove 'i8254_offset' from boardinfo
      staging: comedi: das16: tidy up 8255 digital i/o subdevice
      staging: comedi: das16: tidy up the register map defines
      staging: comedi: das16: fail attach if board id is incorrect
      staging: comedi: das16: cleanup printk message in board attach
      staging: comedi: das16: absorb das1600_mode_detect() into caller
      staging: comedi: das16: fix a > 80 char line issue
      staging: comedi: das16: cleanup comedi_error() messages
      staging: comedi: das16: tidy up private data definition
      staging: comedi: das16: change MODULE_DESCRIPTION
      staging: comedi: das16: fix das16_detach()
      staging: comedi: das16: remove an unnecessary check in the attach
      staging: comedi: das16: tidy up user ai/ao range initialization
      staging: comedi: das16: remove some unnecessary parentheses
      staging: comedi: das16: tidy up multi-line comments
      staging: comedi: usbdux: generalize the usb_submit_urb functions
      staging: comedi: usbduxsigma: generalize the ai/ao usb_kill_urb()
      staging: comedi: usbduxsigma: remove the usb endpoint defines
      staging: comedi: usbdux: tidy up usbdux_pwm_period()
      staging: comedi: usbdux: tidy up usbdux_pwm_pattern()
      staging: comedi: usbdux: tidy up usbdux_pwm_write()
      staging: comedi: usbdux: remove usbdux_pwm_read()
      staging: comedi: usbdux: tidy up usbdux_pwm_config()
      staging: comedi: usbdux: return void from usbdux_pwm_pattern()
      staging: comedi: usbduxsigma: return void from usbduxsigma_pwm_pattern()
      staging: comedi: usbdux: tidy up usbdux_alloc_usb_buffers()
      staging: comedi: usbduxsigma: 'dac_commands' does not need to be kzalloc()'d
      staging: comedi: usbduxsigma: init 'pwm_buf_sz' in usbduxsigma_auto_attach()
      staging: comedi: usbduxsigma: move urb unlink into usbduxsigma_detach()
      staging: comedi: usbduxsigma: always clear the usb intfdata in (*detach)
      staging: comedi: usbdux: tidy up usbdux_detach()
      staging: comedi: usbdux: tidy up usbdux_free_usb_buffers()
      staging: comedi: usbduxsigma: absorb usbduxsigma_attach_common() into caller
      staging: comedi: allow ISA and PC/104 drivers on non-ISA systems
      staging: comedi: core: introduce comedi_dio_insn_config()
      staging: comedi: skel: use comedi_dio_insn_config()
      staging: comedi: drivers: use comedi_dio_insn_config() for complex cases
      staging: comedi: drivers: use comedi_dio_insn_config() for complex cases
      staging: comedi: drivers: introduce comedi_dio_insn_config()
      staging: comedi: skel: use comedi_dio_insn_config()
      staging: comedi: drivers: use comedi_dio_insn_config() for simple cases
      staging: comedi: dt2817: fix dt2817_dio_insn_config()
      staging: comedi: dt282x: fix dt282x_dio_insn_config()
      staging: comedi: dmm32at: fix dmm32at_dio_insn_config()
      staging: comedi: ni_atmio16d: fix atmio16d_dio_insn_config()

Hector Palacios (1):
      iio: mxs-lradc: change the realbits to 12

Hiroya Nozaki (1):
      staging/lustre/ptlrpc: Race between start and stop service threads

Ian Abbott (33):
      staging: comedi: return void from comedi_driver_unregister()
      staging: comedi: use a mutex when accessing driver list
      staging: comedi: ni_labpc: fix possible double-free of dma_buffer
      staging: comedi: ni_labpc: don't clear cmd3 bits explicitly in labpc_ai_cmd()
      staging: comedi: ni_labpc_isadma: new module for ISA DMA support
      staging: comedi: ni_labpc: migrate DMA channel init & free
      staging: comedi: ni_labpc_isadma: add labpc_have_dma_chan()
      staging: comedi: ni_labpc: use labpc_have_dma_chan()
      staging: comedi: ni_labpc: move register defs to new file
      staging: comedi: ni_labpc: migrate DMA transfer set-up
      staging: comedi: ni_labpc: migrate labpc_drain_dma()
      staging: comedi: ni_labpc: migrate DMA status handling
      staging: comedi: ni_labpc: tidy up after DMA code migration
      staging: comedi: COMEDI_NI_LABPC_ISA no longer depends on VIRT_TO_BUS
      staging: comedi: Kconfig: COMEDI_NI_ATMIO16D should not depend on ISAPNP
      staging: comedi: Kconfig: COMEDI_NI_ATMIO doesn't need to depend on ISAPNP
      staging: comedi: pcmmio: remove unneeded checks on detach
      staging: comedi: pcmuio: fix possible NULL deref on detach
      staging: comedi: comedi_bond: reformat some comments
      staging: comedi: comedi_bond: shorten module description
      staging: comedi: comedi_bond: rename CamelCase identifiers
      staging: comedi: comedi_bond: no need to initialize file[]
      staging: comedi: comedi_bond: return error code in do_dev_config()
      staging: comedi: comedi_bond: change return value of bonding_attach()
      staging: comedi: comedi_bond: use bitmap to record opened/closed minors
      staging: comedi: comedi_bond: don't map channels individually
      staging: comedi: comedi_bond: remove unused subdev_type
      staging: comedi: comedi_bond: no need to free dev->private on detach
      staging: comedi: comedi_bond: just check devprivs->devs once on detach
      staging: comedi: comedi_bond: get INSN_CONFIG_DIO_QUERY info from horse's mouth
      staging: comedi: comedi_bond: handle base channel for insn_bits
      staging: comedi: comedi_bond: use krealloc() and fix memory leak
      staging: comedi: comedi_bond: use correct minor device numbers in name

Iker Pedrosa (7):
      Staging: winbond: wb35reg: fixed some line over 80 characters
      Staging: winbond: wb35reg: white space deleted
      Staging: winbond: wb35reg: avoided use of extern function
      Staging: winbond: mds: fixed some lines over 80 characters
      Staging: winbond: mds_f: fixed lines over 80 characters
      Staging: winbond: mds_f: deleted extern function
      Staging: rtl8192e: rtllib_rx: checking NULL value after doing dev_alloc_skb

Jacek Anaszewski (2):
      iio: lps331ap: Modify in_temp_scale calculation way
      iio: trigger: implement devm_iio_trigger_alloc/devm_iio_triger_free

Jens Frederich (8):
      Staging: olpc_dcon: change to msleep to usleep_range
      staging: olpc_dcon: provide detailed FB_OLPC_DCON help section
      Staging: olpc_dcon: updating MAINTAINERS
      Staging: olpc_dcon: replace some magic numbers
      Staging: olpc_dcon: more big endian conformity
      Staging: olpc_dcon: fix typo in olpc_dcon.h
      Staging: olpc_dcon: Already completed TODO entry removed
      Staging: olpc_dcon: Removed more completed TODO entries

Jie Liu (1):
      staging/zcache: Fix memory leak while dropping an o2net_sock_container object

Jingoo Han (1):
      staging: imx-drm: add missing MFD_SYSCON dependency for LDB

Jinshan Xiong (1):
      staging/lustre/layout: introduce new layout for released files

Joe Perches (6):
      staging: ozwpan: Remove extra debug logs.
      staging: ozwpan: Replace oz_trace with oz_dbg
      staging: ozwpan: Remove old debug macro.
      staging: ozwpan: Convert macro to function.
      staging: ozwpan: Rename Kbuild to Makefile
      staging: gdm724x: Update logging

John L. Hammond (8):
      staging/lustre/llite: use READ, WRITE around ll_rw_stats_tally()
      staging/lustre/llite: check alloc in ll_file_data_get, ll_dir_ioctl
      staging/lustre/llite: check ll_prep_md_op_data() using IS_ERR()
      staging/lustre/md: fix lu_ucred.c boilerplate
      staging/lustre/llite: call simple_setattr() from ll_md_setattr()
      staging/lustre/procfs: return -ENOMEM from lprocfs_register()
      staging/lustre/llite: handle io init failure in ll_fault_io_init()
      staging/lustre/obdclass: use a dummy structure for lu_ref_link

Jonathan Cameron (1):
      iio:dac:mcp4725 wrong return type of attribute _show function

Josh Wu (2):
      iio: at91: introduce the multiple compatible string for different IPs.
      iio: at91: Use different prescal, startup mask in MR for different IP

Julien Delacou (1):
      staging: dwc2: fix value used in dwc2_set_all_params

Keith Mannthey (3):
      staging/lustre/osc: Check return code for lu_kmem_init
      staging/lustre/llite: error of listxattr when buffer is small
      staging/lustre/style: removes obsolete EXPORT_SYMTAB macros v2

Konrad Rzeszutek Wilk (1):
      staging: zram: Add auto loading of module if user opens /dev/zram.

Kumar Gaurav (2):
      Staging: xgifb: Fixed a warning of Space before semicolon
      Staging: zram: zram_drv.c: Fixed Error of trailing whitespace

Larry Finger (37):
      staging: r8188eu: Add source files for new driver - part 1
      staging: r8188eu: Add files for new driver - part 2
      staging: r8188eu: Add files for new driver - part 3
      staging: r8188eu: Add files for new driver - part 4
      staging: r8188eu: Add files for new driver - part 5
      staging: r8188eu: Add files for new driver - part 6
      staging: r8188eu: Add files for new driver - part 7
      staging: r8188eu: Add files for new driver - part 8
      staging: r8188eu: Add files for new driver - part 9
      staging: r8188eu: Add files for new driver - part 10
      staging: r8188eu: Add files for new driver - part 11
      staging: r8188eu: Add files for new driver - part 12
      staging: r8188eu: Add files for new driver - part 13
      staging: r8188eu: Add files for new driver - part 14
      staging: r8188eu: Add files for new driver - part 15
      staging: r8188eu: Add files for new driver - part 16
      staging: r8188eu: Add files for new driver - part 17
      staging: r8188eu: Add files for new driver - part 18
      staging: r8188eu: Add files for new driver - part 19
      staging: r8188eu: Add files for new driver - part 20
      staging: r8188eu: Add files for new driver - part 21
      staging: r8188eu: Add files for new driver - part 22
      staging: r8188eu: Add files for new driver - part 23
      staging: r8188eu: Add files for new driver - part 24
      staging: r8188eu: Add files for new driver - part 25
      staging: r8188eu: Add files for new driver - part 26
      staging: r8188eu: Add files for new driver - part 27
      staging: r8188eu: Add files for new driver - part 28
      staging: r8188eu: Add files for new driver - part 29
      staging: r8188eu: Add files for new driver - part 30
      staging: r8188eu: Insert Kconfig files for new driver
      staging: r8188eu: Add files for new driver - part 31
      staging: r8188eu: Turn on build of new driver
      staging: gdm724x: Remove tests of KERNELVERSION
      staging: r8188eu: Fix build errors for allyesconfig
      staging: r8188eu: Fix build error with random configuration
      staging: r8188eu: Fix compiler warnings in os_dep/ioctl_linux.c

Lars-Peter Clausen (20):
      iio: Add a comment to about alphabetical order to Kconfigs and Makefiles
      staging:iio:ad2s1210: Don't expose the chip reset to userspace
      staging:iio:adt7316: Don't expose the chip reset to userspace
      staging:iio:ade7xxx: Don't expose the chip reset to userspace
      iio: Remove IIO_DEV_ATTR_RESET macro
      staging:iio:adis16260: Fix reading calibscale
      staging:iio:adis16260: Drop unused 'negate' property
      staging:iio:adis16260: Remove support for orientation mapping
      staging:iio:adis16260: Don't set default scan mask
      staging:iio:adis16260: Remove separate header
      staging:iio:adis16260: Add value range check for calibscale/-bias
      staging:iio:adis16260: Use sign_extend32() instead of open-coding it
      staging:iio:adis16260: Simplify calibscale and caliboffset reading
      staging:iio:adis16260: Fix minor style issue
      staging:iio:adis16260: Remove 'SPS' suffix from samplerate attribute
      staging:iio:adis16260: Add scale for the inclination channel
      staging:iio:adis16260: Remove unused includes
      staging:iio:adis16260: Add proper range checks to write_frequency()
      staging:iio:adis16260: Remove sampling_frequency_available attribute
      staging:iio:adis16260: Move out of staging

Laurent Navet (1):
      staging: lustre: use ERR_CAST() function

Li Wei (1):
      staging/lustre/ptlrpc: Translate between host and network errnos

Li Zefan (2):
      Staging: rtl8192e: add missing single_release()
      Staging: rtl8192u/ieee80211: add missing single_release()

Lidza Louina (62):
      staging: dgnc: add dgnc digi driver
      staging: dgnc: removes Makefile.inc
      staging: dgnc: fixes termios error
      staging: dgnc: fixes tty_port and tty_struct params
      staging: dgnc: dereferences ts var in dgnc_tty_close()
      staging: dgcn: removes unnecessary commands in ioctl
      staging: dgnc: fixes ioctl param list
      staging: dgnc: removes read_cnt, real_raw, rawreadok and buf
      staging: dgnc: removes proc code
      staging: dgnc: driver.c: fixes warning about assigning pointer
      staging: dgnc: removes ifdef HAVE_UNLOCKED_IOCTL conditionals
      staging: dgnc: add driver to kernel build
      staging: dgnc: cls.c: removes trailing whitespace
      staging: dgnc: cls.h: removes trailing whitespace
      staging: dgnc: driver.c: removes trailing whitespace
      staging: dgnc: driver.h: removes trailing whitespace
      staging: dgnc: kcompat.h: removes trailing whitespace
      staging: dgnc: mgmt.c: removes trailing whitespace
      staging: dgnc: neo.c: removes trailing whitespace
      staging: dgnc: neo.h: removes trailing whitespace
      staging: dgnc: sysfs.c: removes trailing whitespace
      staging: dgnc: sysfs.h: removes trailing whitespace
      staging: dgnc: trace.c: removes trailing whitespace
      staging: dgnc: tty.c: removes trailing whitespace
      staging: dgnc: digi.h: removes trailing whitespace
      staging: dgnc: dpacompat.h: removes trailing whitespace
      staging: dgnc: removes CVS code from files
      staging: dgnc: tty.c: fixes pointer syntax
      staging: dgnc: fixes struct declaration
      staging: dgnc: driver.c: fixes code indent error
      staging: dgnc: driver.h: fixes code indent error
      staging: dgnc: neo.c: fixes code indent error
      staging: dgnc: sysfs.c: fixes code indent error
      staging: dgnc: tty.c: fixes code indent error
      staging: dgap: fixes incompatible type error
      staging: dgap: removes references to proc code
      staging: dgap: fep5.c: fixes errors with tty function calls
      staging: dgap: tty.c: fixes errors with tty function calls
      staging: dgap: tty.c: fixes termios error
      staging: dgap: tty.c: removes read_cnt, real_raw and rawreadok
      staging: dgap: tty.c: fixes ioctl param list
      staging: dgap: tty.c: fixes incompatible type error
      staging: dgap: mgmt.c: removes unused variable
      staging: dgap: ifdef HAVE_UNLOCKED_IOCTL conditionals
      staging: dgap: adds driver to kernel build
      staging: dgnc: driver.c: removes dgnc_mbuf function
      staging: dgap: removes references to mgmt code
      staging: dgap: removes mgmt.c
      staging: dgap: removes mgmt.h
      staging: dgap: removes references to proc code
      staging: dgap: removes proc.c
      staging: dgap: removes proc.h
      staging: dgnc: cls_uart_struct: adds marker and changes vars' types for sparse
      staging: dgnc: neo_uart_struct: adds marker and changes vars' types for sparse
      staging: dgnc: driver.h: changes a struct board_t var's type and marker for sparse
      staging: dgnc: cls.c: changes var in cls_vpd function for sparse
      staging: dgnc: neo.c: changes param in neo_read_eeprom function for sparse
      staging: dgnc: tty.c: edits var in init func for sparse
      staging: dgnc: tty.c: updates uart_struct declaration for sparse
      staging: dgnc: driver.c and tty.c: replaces dgnc_driver_kzmalloc with kzalloc
      staging: dgnc: driver.c and .h: removes dgnc_driver_kzmalloc func
      staging: dgnc: adds TODO

Lilis Iskandar (6):
      Staging: bcm: Qos: Fix some coding style issues
      Staging: bcm: LeakyBucket: Fixed spacing/tabing issues
      Staging: bcm: LeakyBucket: Fixed brace issues
      Staging: bcm: LeakyBucket: Fixed C99 comments
      Staging: bcm: LeakyBucket: Fixed code indent issues
      Staging: bcm: LeakyBucket: Fixed a pointer asterisk placement issue

Liu Xuezhao (3):
      staging/lustre/fid: prepare FID module for client server split
      staging/lustre/fld: prepare FLD module for client server split
      staging/lustre/obdclass: add obd_target.h

Malcolm Priestley (60):
      staging: vt6656: Remove dead code macro ASSERT
      staging: vt6656: remove dead code DBG_PORT80/VIAWET_DEBUG
      staging: vt6656: dead code wCTSDuration.
      staging: vt6656: device.h unused variables
      staging: vt6656: rxtx.c: s_vGetFreeContext use single tx memset.
      staging: vt6656: desc.h remove typedef struct tagSRTSData
      staging: vt6656: desc.h remove typedef struct tagSCTSData
      staging: vt6656: rxtx.c: s_uGetDataDuration remove First Frag or Mid Frag dead code.
      staging: vt6656: rxtx.c: s_uGetDataDuration remove dead variables.
      staging: vt6656: rxtx.c s_uFillDataHead remove dead variables.
      staging: vt6656: rxtx.h always pack BEACON_BUFFER/TX_BUFFER
      staging: vt6656: rxtx.h dead code typedef union tagUTX_BUFFER_CONTAINER
      staging: vt6656: rxtx.c s:_uGetDataDuration simplify structure.
      staging: vt6656: rxtx.c s_uGetRTSCTSDuration return endian u16
      staging: vt6656: rxtx.c remove typdef PTX_BUFFER
      staging: vt6656: rxtx.c : s_bPacketToWirelessUsb remove usbPacketBuf.
      staging: vt6656: rxtx.h : remove typedef struct tagSBEACON_BUFFER
      staging: vt6656: desc.h Remove typedef struct tagSRTS_* to new strutures in rxtx.h
      staging: vt6656: desc.h Move typedef struct tagSCTS* to new structures in rxtx.h
      staging: vt6656: desc.h: Move typedef tagSRrvTime_gRTS to new structure in rxtx.h
      staging: vt6656: desc.h: Move typedef struct tagSRrvTime_gCTS to new structure in rxtx.h
      staging: vt6656: desc.h remove typedef SRrvTime_ab to new structure.
      staging: vt6656: desc.h remove dead code typedef struct tagSRrvTime_atim.
      staging: vt6656: desc.h: remove typedef struct tagSTxDataHead_g to new structure in rxtx.h
      staging: vt6656: desc.h remove typedef tagSTxDataHead_g_FB to new structure in rxtx.h
      staging: vt6656: desc.h remove typedef tagSTxDataHead_ab to new structure in rxtx.h
      staging: vt6656: desc.h remove typedef tagSTxDataHead_a_FB to new structure in rxtx.h
      staging: vt6656: rxtx.c dead code TYPE_ATIMDMA/TYPE_BEACONDMA
      staging: vt6656: baseband.c BBvCalculateParameter pwPhyLen return endian corrected.
      staging: vt6656: baseband.c BBvCalculateParameter create structure for pwPhyLen, pbyPhySrv and pbyPhySgn
      staging: vt6656: rxtx.c s_uGetDataDuration return endian corrected u16.
      staging: vt6656: rxtx.c: s_uGetDataDuration Drop argument byDurType.
      staging: vt6656: s_uGetRTSCTSRsvTime return u16 endian corrected value.
      staging: vt6656: rxtx.c s_create new function to endian correct uGetTxRsvTime.
      staging: vt6656: rxtx.c endian correct wTimeStampOff
      staging: vt6656: desc.h Remove typedef struct tagSMICHDRHead to new structure in rxtx.h
      staging: vt6656: rxtx.c s_vFillTxKey fill structure vnt_mic_hdr
      staging: vt6656: device.h Remove dead code bSoftwareGenCrcErr.
      staging: vt6656: rxtx.c s_vFillRTSHead remove dead bDiscCRC
      staging: vt6656: rxtx.c s_vFillCTSHead remove dead code bDisCRC
      staging: vt6656: s_vGenerateTxParameter dead code bDisCRC
      staging: vt6656: s_vGenerateTxParameter pvRrvTime should never be NULL
      staging: vt6656: rxtx.c s_vFillRTSHead Parse out struct vnt_rts_g to new functions.
      staging: vt6656: rxtx.c s_vFillRTSHead Parse out struct vnt_rts_g_fb to new function.
      staging: vt6656: rxtx.c s_vFillRTSHead Parse out struct vnt_rts_ab to new function.
      staging: vt6656: rxtx.c s_vFillRTSHead Parse out struct vnt_rts_a_fb to new function.
      staging: vt6656: rxtx s_vFillRTSHead create union of vnt_rts*/vnt_cts* structures.
      staging: rxtx.c s_vFillRTSHead white space and formating clean up
      staging: vt6656: rxtx.c: s_vFillRTSHead change if/else to switch on byPktype
      staging: vt6656: rxtx.c s_vFillRTSHead PK_TYPE_11A allow fall through AUTO_FB_NONE
      staging: vt6656: rxtx.c s_vFillCTSHead Remove byPktType if
      staging: vt6656: s_vFillCTSHead join structures of vnt_cts* to union vnt_tx_data_head
      staging: vt6656: rxtx.c s_vGenerateTxParameter create argument bool need rts
      staging: vt6656: rxtx.c merge pvRTS and pvCTS/pCTS void pointers
      staging: vt6656: rxtx.c s_vFillRTSHead/s_vFillCTSHead move union vnt_tx_data_head up one level.
      staging: vt6656: rxtx.c s_vFillTxKey clean up format and white space.
      staging: vt6656: rxtx.c s_vFillTxKey use switch for pTransmitKey->byCipherSuite
      staging: vt6656: device.h replace typedef struct _USB_SEND_CONTEXT.
      staging: vt6656: baseband.h re: baseband.c:877:26: sparse: incorrect type in assignment (different base types)
      staging: vt6656: device.h Replace typedef struct _RCB

Marc Dietrich (1):
      staging: nvec: re-enable the clock on resume

Mark Einon (1):
      staging: et131x: Remove frame error TODO item

Masanari Iida (9):
      staging: lustre: Fix typo in printk
      staging: imx-drm: Fix typo in staging/imx-drm
      staging: xillybus: Fix typo in comment
      staging: usbip: Fix typo in comments within usbip
      staging: tidspbridge: Fix typos in comments
      staging: lustre: Fix typo in lustre/include
      staging: bcm: Fix typo in comments
      staging: gdm724x: Fix typo in comments
      staging: lustre: Fix typo in lustre/lnet

Matthijs Kooijman (16):
      staging: dwc2: disable dma when no dma_mask was setup
      staging: dwc2: when dma is disabled, clear hcd->self.uses_dma
      staging: dwc2: Don't touch the dma_mask when dma is disabled
      staging: dwc2: remove specific fifo size constants
      staging: dwc2: fix off-by-one in check for max_packet_count parameter
      staging: dwc2: unshift non-bool register value constants
      staging: dwc2: only read the snpsid register once
      staging: dwc2: simplify register shift expressions
      staging: dwc2: add missing shift
      staging: dwc2: simplify debug output in dwc_hc_init
      staging: dwc2: re-use hptxfsiz variable
      staging: dwc2: remove redundant register reads
      staging: dwc2: properly mask the GRXFSIZ register
      staging: dwc2: interpret all hwcfg and related register at init time
      staging: dwc2: validate the value for phy_utmi_width
      staging: dwc2: make dwc2_core_params documentation more complete

Minchan Kim (2):
      zram: fix invalid memory access
      zram: don't grab mutex in zram_slot_free_noity

Nathaniel Clark (1):
      staging/lustre/obdclass: be more careful processing server name

Ned Bass (1):
      staging/lustre/lmv: fix duplicate directory entries

Oleg Drokin (3):
      staging/lustre/ldlm: split client namespaces into active and inactive
      staging/lustre: Only wake up ldlm_poold as frequently as the check interval
      staging/lustre: Make quota namespace refcounting consistent

Oleksandr Kozaruk (2):
      iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver
      iio: adc: twl6030-gpadc: Use devm_* API family

Oleksandr Kravchenko (6):
      of: Add Avago Technologies vendor prefix
      iio: add APDS9300 ambilent light sensor driver
      Documentation: devres: add IIO device alloc/free functions to list
      iio: core: Avoid double minus in sysfs output
      staging: iio: Documentation sysfs-bus-iio add power_mode
      iio: add Bosch BMA180 acceleration sensor driver

Otavio Salvador (1):
      iio: add configuration option for debug support

Patrick Farrell (1):
      staging/lustre/llite: Anonymous dentry incorrectly identified as root

Paul Bolle (1):
      staging/lustre/libcfs: drop bogus Kconfig default

Paul McQuade (1):
      Staging:BCM:DDRInit.c:Renaming __FUNCTION__

Paul Zimmerman (8):
      staging: dwc2: refactor dwc2_host_complete()
      staging: dwc2: add calls to usb_hcd_link_urb_to_ep() and friends
      staging: dwc2: optimize dwc2_hc_handle_tt_clear() a bit
      staging: dwc2: fix dwc2_hcd_qtd_add()
      staging: dwc2: reduce noisy debug messages
      staging: dwc2: remove use of bus_to_virt()
      staging: dwc2: add driver parameter to set AHB config register value
      staging: dwc2: reorder some kernel doc comments and struct members

Peng Tao (19):
      staging/lustre: replace num_physpages with totalram_pages
      staging/lustre: fix Lustre code link order
      staging/lustre: don't assert module owner
      staging/lustre: don't assert ln_refcount in LNetGetId
      stating/lustre: only build if configured as module
      staging/lustre: remove HIPQUAD
      staging/lustre: fix build error when !CONFIG_SMP
      staging/lustre: fix build on s390
      staging/lustre/llite: add missing include file for prefetchw
      staging/lustre/llite: fix build erorr if CONFIG_FS_POSIX_ACL is off
      staging/lustre: fix build when CONFIG_UIDGID_STRICT_TYPE_CHECKS is on
      staging/lustre: fix build error on non-x86 platforms
      staging/lustre: fix build warnning on 32bit system
      staging/lustre/llite: fix for d_compare API change
      staging/lustre/llite: readdir convert to iterate
      staging/lustre: drop CONFIG_BROKEN
      staging/lustre: remove bogus ifndef EXPORT_SYMBOL
      staging/lustre/lnet: remove empty file lnet/lnet/api-errno.c
      staging/lustre: fix build on non-x86

Peter Meerwald (28):
      iio: fix typos in dac Kconfig
      iio: use I2C_FUNC_SMBUS_I2C_BLOCK macro
      iio: fix Kconfig typos
      iio: remove mention of ring buffer from CONFIG_IIO_KFIFO_BUF, CONFIG_IIO_TRIGGER description
      iio: reword help text of several IIO_ST drivers
      iio: add store_eeprom to mcp4725 dac driver
      iio: add powerdown to mcp4725 dac drive
      iio: add DAC 500kohm_to_gnd to possible powerdown_modes
      iio: move ABI specification for store_eeprom; is used by ad9523, mcp4725 and ds1077 devices
      iio: staging: fix device.txt documentation
      iio: fix typo, Documentation/ABI/testing/sysfs-bus-iio-frequency-adf4350
      iio: staging: fix typo in ade758_ring.c
      iio: fix semicolon in io_core_trigger.h
      iio:adjd_s311: Use devm_iio_device_alloc
      iio:vcnl4000: Use devm_iio_device_alloc
      iio:mcp4725: Use devm_iio_device_alloc
      iio: Fix documentation of devm_iio_device_free()
      staging:iio:hmc5843: Drop I2C detection code
      staging:iio:hmc5843: Remove id register #defines, not used anymore
      staging:iio:hmc5843: Implement timeout in read function
      staging:iio:hmc5843: 'add' is a poor abbreviation for address
      staging:iio:hmc5843: Device has 3 channels, no need to store separately
      staging:iio:hmc5843: Drop unneeded #includes
      staging:iio:hmc5843: Use i2c_smbus_read_word_swapped()
      iio: Add tmp006 IR temperature sensor
      iio: Restore alphabetic order in Makefile
      iio: Remove unnecessary _write_raw_get_fmt() in several hid-sensor drivers
      iio: adjd_s311: Cleanup unused #defines

Robert Foss (1):
      Staging: crystalhd: fixed whitespace and string style issues

Rupesh Gujare (42):
      staging: ozwpan: Fix coding style.
      staging: ozwpan: High resolution timers
      staging: ozwpan: Use kernel list function for managing interface list.
      staging: ozwpan: Mark string as const
      staging: ozwpan: Use kernel strncmp function.
      staging: ozwpan: Drop oldest ISOC frame instead of dropping latest.
      staging: ozwpan: Increase farewell report size.
      staging: ozwpan: Set farewell report length.
      staging: ozwpan: Fix build warning.
      staging: ozwpan: Fix farewell report.
      staging: ozwpan: Fixes crash due to invalid port aceess.
      staging: ozwpan: Reset port configuration number.
      staging: ozwpan: Return correct hub status.
      staging: ozwpan: Add a blank line between declaraction and code.
      staging: ozwpan: Add a blank line between functions & declarations.
      staging: ozwpan: Simply if condition
      staging: ozwpan: Fix coding style.
      staging: ozwpan: Remove unnecessary pointer check.
      staging: ozwpan: Make oz_hcd_pd_arrived() return a struct pointer
      staging: ozwpan: Make oz_hcd_pd_departed() take a struct pointer.
      staging: ozwpan: Remove unneeded initializers
      staging: ozwpan: Swap arguments of oz_ep_alloc() to match kmalloc()
      staging: ozwpan: Remove unneeded variable initializer
      staging: ozwpan: Remove extra variable.
      staging: ozwpan: Fix crash for race condition.
      staging: ozwpan: Check error condition before creating endpoint.
      staging: ozwpan: Increment reference counter.
      staging: ozwpan: Create deferred work to destroy PD object.
      staging: ozwpan: Remove memset
      staging: ozwpan: Fix wrong error check.
      staging: ozwpan: Fix Documentation style.
      staging: ozwpan: Check for correct config number.
      staging: ozwpan: Convert hard coded value to Macro
      staging: ozwpan: Increase interrupt end point buffer size
      staging: ozwpan: change variable type.
      staging: ozwpan: Fix error checking while transmitting frame.
      staging: ozwpan: change max. TX frame size supported.
      staging: ozwpan: Add debounce time before unregistering.
      staging: ozwpan: Reset PORT_ENABLE bit.
      staging: ozwpan: Increase ISOC IN buffer depth
      staging: ozwpan: Change error number.
      staging: ozwpan: Return error, if PD is not connected.

Sachin Kamat (141):
      staging: lustre: Remove version.h header inclusion in kp30.h
      staging: lustre: Remove version.h header inclusion in linux-cpu.h
      staging: lustre: Remove version.h header inclusion in linux-prim.h
      staging: lustre: Remove version.h header inclusion in linux-time.h
      staging: lustre: Remove version.h header inclusion in socklnd_lib-linux.h
      staging: lustre: Remove version.h header inclusion in lprocfs_status.h
      staging: lustre: Remove version.h header inclusion in lustre_handles.h
      staging: lustre: Remove version.h header inclusion in lustre_lite.h
      staging: lustre: Remove version.h header inclusion in lustre_net.h
      staging: lustre: Remove version.h header inclusion in lustre_quota.h
      staging: lustre: Remove version.h header inclusion in lustre_user.h
      staging: lustre: Remove version.h header inclusion in linux-debug.c
      staging: lustre: Remove version.h header inclusion in dir.c
      staging: lustre: Remove version.h header inclusion in llite_capa.c
      staging: lustre: Remove version.h header inclusion in llite_lib.c
      staging: lustre: Remove version.h header inclusion in llite_mmap.c
      staging: lustre: Remove version.h header inclusion in lproc_llite.c
      staging: lustre: Remove version.h header inclusion in remote_perm.c
      staging: lustre: Remove version.h header inclusion in super25.c
      staging: lustre: Remove version.h header inclusion in symlink.c
      staging: lustre: Remove version.h header inclusion in lproc_lmv.c
      staging: lustre: Remove version.h header inclusion in lproc_lov.c
      staging: lustre: Remove version.h header inclusion in fsfilt_ext3.c
      staging: lustre: Remove version.h header inclusion in lvfs_linux.c
      staging: lustre: Remove version.h header inclusion in lproc_mdc.c
      staging: lustre: Remove version.h header inclusion in lproc_mgc.c
      staging: lustre: Remove version.h header inclusion in capa.c
      staging: lustre: Remove version.h header inclusion in linux-sysctl.c
      staging: lustre: Remove version.h header inclusion in obd_mount.c
      staging: lustre: Remove version.h header inclusion in lproc_osc.c
      staging: lustre: o2iblnd: Remove duplicate inclusion of header file
      staging: lustre: socklnd: Remove duplicate inclusion of header files
      staging: lustre: obd: Remove duplicate inclusion of header file
      staging: lustre: linux-debug: Remove duplicate inclusion of header file
      staging: lustre: libcfs: Remove duplicate inclusion of header file
      staging: lustre: linux-tcpip: Remove duplicate header file inclusion
      staging: lustre: Remove duplicate header file inclusion in dir.c
      staging: lustre: Remove duplicate header file inclusion in llite_mmap.c
      staging: lustre: Remove duplicate header file inclusion in lloop.c
      staging: lustre: Remove duplicate header file inclusion in rw.c
      staging: lustre: Remove duplicate header file inclusion in rw26.c
      staging: lustre: Remove duplicate header file inclusion in lmv_fld.c
      staging: lustre: Remove duplicate header file inclusion in lmv_intent.c
      staging: lustre: Remove duplicate header file inclusion in lmv_obd.c
      staging: lustre: Remove duplicate header file inclusion in lvfs_linux.c
      staging: lustre: obdclass: Remove duplicate header file inclusion
      staging: gdm724x: Remove version.h header inclusion in gdm_lte.c
      staging: gdm724x: Remove version.h header inclusion in gdm_lte.h
      staging: gdm724x: Remove version.h header inclusion in gdm_mux.c
      staging: gdm724x: Remove version.h header inclusion in gdm_tty.c
      staging: gdm724x: Remove version.h header inclusion in gdm_tty.h
      staging: gdm724x: Remove version.h header inclusion in gdm_usb.c
      staging: gdm724x: Remove version.h header inclusion in gdm_usb.h
      staging: dgnc: Remove duplicate header file inclusion
      staging: dgnc: Remove version.h header inclusion in dgnc_cls.c
      staging: dgnc: Remove version.h header inclusion in dgnc_driver.h
      staging: dgnc: Include version.h header in dgnc_kcompat.h
      staging: dgnc: Remove version.h header inclusion in dgnc_mgmt.c
      staging: dgnc: Remove version.h header inclusion in dgnc_neo.c
      staging: dgnc: Remove version.h header inclusion in dgnc_sysfs.c
      staging: dgnc: Remove version.h header inclusion in dgnc_trace.c
      iio: adc: ad7266: Use devm_* APIs
      iio: adc: ad7298: Use devm_* APIs
      iio: adc: ad7476: Use devm_* APIs
      iio: adc: ad7791: Use devm_* APIs
      iio: adc: ad7793: Use devm_* APIs
      iio: adc: ad7887: Use devm_* APIs
      iio: adc: ad7923: Use devm_* APIs
      iio: adc: lp8788_adc: Use devm_* APIs
      iio: adc: mcp320x: Use devm_* APIs
      iio: adc: nau7802: Use devm_iio_device_alloc
      iio: adc: ti-adc081c: Use devm_* APIs
      iio: adc: viperboard_adc: Use devm_iio_device_alloc
      iio: at91: Use devm_iio_device_alloc
      iio: exynos_adc: Use devm_iio_device_alloc
      iio: max1363: Use devm_iio_device_alloc
      iio: frequency: adf4350: Use devm_* APIs
      staging: iio: mxs-lradc: Use devm_iio_device_alloc
      staging: iio: spear_adc: Use devm_iio_device_alloc
      staging: iio: light: isl29018: Use devm_iio_device_alloc
      staging: iio: light: isl29028: Use devm_iio_device_alloc
      iio: hid-sensor-accel-3d: Use devm_iio_device_alloc
      iio: accel: kxsd9: Use devm_iio_device_alloc
      iio: accel: st_accel: Use devm_iio_device_alloc
      iio: adc: ti_am335x_adc: Use devm_iio_device_alloc
      iio: adc: Update ti_am335x_adc Kconfig entry
      iio: magnetometer: hid-sensor-magn-3d: Use devm_iio_device_alloc
      iio: magnetometer: st_magn: Use devm_iio_device_alloc
      iio: imu: adis16400: Use devm_iio_device_alloc
      iio: imu: adis16480: Use devm_iio_device_alloc
      iio: imu: inv_mpu6050: Use devm_iio_device_alloc
      iio: light: hid-sensor-als: Use devm_iio_device_alloc
      iio: light: lm3533-als: Use devm_iio_device_alloc
      iio: light: tsl2563: Use devm_* APIs
      iio: amplifiers: ad8366: Use devm_* APIs
      iio: frequency: ad9523: Use devm_* APIs
      iio: pressure: st_pressure: Use devm_iio_device_alloc
      iio: gyro: adis16080: Use devm_iio_device_alloc
      iio: gyro: adis16130: Use devm_iio_device_alloc
      iio: gyro: adis16136: Use devm_iio_device_alloc
      iio: gyro: adis16260: Use devm_iio_device_alloc
      iio: hid-sensor-gyro-3d: Use devm_iio_device_alloc
      iio: gyro: adxrs450: Use devm_iio_device_alloc
      iio: gyro: itg3200_core: Use devm_iio_device_alloc
      iio: gyro: st_gyro: Use devm_iio_device_alloc
      iio: gyro: adis16060_core: Use devm_iio_device_alloc
      iio: dac: ad5064: Use devm_* APIs
      iio: dac: ad5360: Use devm_* APIs
      iio: dac: ad5380: Use devm_* APIs
      iio: dac: ad5421: Use devm_* APIs
      iio: dac: ad5446: Use devm_* APIs
      iio: dac: ad5449: Use devm_* APIs
      iio: dac: ad5504: Use devm_* APIs
      iio: dac: ad5624r_spi: Use devm_* APIs
      iio: dac: ad5686: Use devm_* APIs
      iio: dac: ad5755: Use devm_iio_device_alloc
      iio: dac: ad5764: Use devm_* APIs
      iio: dac: ad5791: Use devm_* APIs
      iio: dac: ad7303: Use devm_* APIs
      iio: dac: max517: Use devm_iio_device_alloc
      staging: xillybus: Remove duplicate inclusion of list.h
      staging: gdm724x: Remove version.h header inclusion in netlink_k.c
      staging: iio: adis16201: Use devm_iio_device_alloc
      staging: iio: adis16203: Use devm_iio_device_alloc
      staging: iio: adis16204: Use devm_iio_device_alloc
      staging: iio: adis16209: Use devm_iio_device_alloc
      staging: iio: adis16220: Use devm_iio_device_alloc
      staging: iio: adis16240: Use devm_iio_device_alloc
      staging: iio: lis3l02dq: Use devm_iio_device_alloc
      staging: iio: sca3000: Use devm_iio_device_alloc
      staging: iio: ad7150: Use devm_* APIs
      staging: iio: ad7152: Use devm_iio_device_alloc
      staging: iio: ad7746: Use devm_iio_device_alloc
      staging: dgap: Remove version.h header inclusion in dgap_parse.c
      staging: dgap: Remove version.h header inclusion in dgap_sysfs.c
      staging: dgap: Remove version.h header inclusion in dgap_trace.c
      staging: rtl8188eu: Remove version.h inclusion in osdep_service.h
      staging: rtl8188eu: Include version.h header in xmit_linux.c
      staging: rtl8188eu: Include version.h in usb_ops.h
      staging: rtl8188eu: Remove duplicate incusion in drv_types.h
      staging: rtl8188eu: Remove duplicate header inclusion in ioctl_linux.c

Scott_Kilau@digi.com (1):
      staging: dgap: adds dgap driver to staging

Sebastien Buisson (4):
      staging/lustre: fix 'program hangs' errors
      staging/lustre: fix 'code maintainability' errors
      staging/lustre: fix 'data race condition' issues in at_reset()
      staging/lustre/llite: fix 'data race condition' issues of lli_flags

Serban Constantinescu (6):
      staging: android: binder: modify struct binder_write_read to use size_t
      staging: android: binder: fix BINDER_SET_MAX_THREADS declaration
      staging: android: binder: fix BC_FREE_BUFFER ioctl declaration
      staging: android: binder: fix alignment issues
      staging: android: binder: replace types with portable ones
      staging: android: binder: fix binder interface for 64bit compat layer

Shaun Laing (4):
      staging: comedi: dt9812: Resolves sparse endian warnings.
      staging: comedi: dt9812: Resolve different base types warnings.
      staging: cxt1e1: Remove #define SBE_INCLUDE_SYMBOLS
      staging: crystalhd: Resolve sparse 'different base types' warnings.

Stephen Rothwell (1):
      staging/lustre: fix for invalidatepage() API change

Sunghan Suh (2):
      staging: zsmalloc: access page->private by using page_private macro
      zram: prevent data loss in error cases of function zram_bvec_write()

Thomas Leibovici (1):
      staging/lustre/lmv: support DNE with HSM.

Tushar Behera (1):
      staging: dgnc: driver.c: Need to include slab.h

Vladimir (1):
      Staging: silicom: Remove useless unneeded semicolons

Wei Yongjun (5):
      staging: gdm724x: use GFP_ATOMIC under spin lock
      staging: xillybus: remove duplicated include from xillybus_core.c
      staging: gdm724x: remove duplicated include from gdm_lte.c
      staging: comedi: dt9812: remove duplicated include from dt9812.c
      iio: adc: twl6030-gpadc: fix error return code in twl6030_gpadc_read_raw()

Won Kang (4):
      staging: gdm7240: adding LTE USB driver
      staging: gdm724x: Modified function name conflict set_endian
      staging: gdm7240: a TTY rewrite according to the latest TTY APIs
      staging: gdm7240: a TTY rewrite according to the latest TTY APIs

Xenia Ragiadakou (7):
      staging: rtl8192u: remove commented-out code in r819xU_cmdpkt.c
      staging: rtl8192u: fix braces in r819xU_cmdpkt.c
      staging: rtl8192u: fix whitespace in r819xU_cmdpkt.c
      staging: rtl8192u: fix comments in r819xU_cmdpkt.c
      staging: rtl8192u: remove unnecessary line continuations in r819xU_cmdpkt.c
      staging: rtl8192u: fix line size and identation in r819xU_cmdpkt.c
      staging: rtl8192u: remove unused macros r819xU_cmdpkt.c

Xiong Zhou (2):
      staging/lustre: add BLOCK depends in Kconfig
      staging/lustre: lloop depends on BLOCK

Yann Droneaud (2):
      android/sw_sync: use get_unused_fd_flags(O_CLOEXEC) instead of get_unused_fd()
      android/sync: use get_unused_fd_flags(O_CLOEXEC) instead of get_unused_fd()

Yijing Wang (1):
      vt6655/trivial: replace numeric with standard PM state macros

Zhao Hongjiang (1):
      staging/lustre: remove the second argument of ll_kmap_atomic()

jcl (5):
      staging/lustre/mdc: layout lock rpc must not take rpc_lock
      staging/lustre/mdt: add macros for fid string len
      staging/lustre/llapi: add user space method for lov_user_md
      staging/lustre/llite: force lvb_data update after layout change
      staging/lustre/mdt: HSM on disk actions record

navin patidar (4):
      staging: dgrp: add __init/__exit macros
      staging: rtl8187se: Remove pt_regs * irq handler parameter
      staging: rtl8192e: Remove pt_regs * irq handler parameter
      staging: bcm: remove Version.h file.

wang di (1):
      staging/lustre/llite: missing last bit in ll_have_md_lock

 Documentation/ABI/testing/sysfs-bus-iio            |   19 +
 .../ABI/testing/sysfs-bus-iio-frequency-ad9523     |    8 -
 .../ABI/testing/sysfs-bus-iio-frequency-adf4350    |    2 +-
 .../devicetree/bindings/arm/atmel-adc.txt          |    7 +-
 .../devicetree/bindings/iio/accel/bma180.txt       |   24 +
 .../bindings/iio/adc/nuvoton-nau7802.txt           |   18 +
 .../devicetree/bindings/iio/light/apds9300.txt     |   22 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/driver-model/devres.txt              |    6 +
 MAINTAINERS                                        |    6 +-
 arch/arm/mach-at91/include/mach/at91_adc.h         |   16 +-
 drivers/iio/Kconfig                                |    8 +-
 drivers/iio/Makefile                               |    3 +-
 drivers/iio/accel/Kconfig                          |   32 +-
 drivers/iio/accel/Makefile                         |    5 +-
 drivers/iio/accel/bma180.c                         |  676 ++
 drivers/iio/accel/hid-sensor-accel-3d.c            |   43 +-
 drivers/iio/accel/kxsd9.c                          |   17 +-
 drivers/iio/accel/st_accel.h                       |   11 +-
 drivers/iio/accel/st_accel_core.c                  |   28 +-
 drivers/iio/accel/st_accel_i2c.c                   |   17 +-
 drivers/iio/accel/st_accel_spi.c                   |   17 +-
 drivers/iio/adc/Kconfig                            |   61 +-
 drivers/iio/adc/Makefile                           |    3 +
 drivers/iio/adc/ad7266.c                           |   16 +-
 drivers/iio/adc/ad7298.c                           |   24 +-
 drivers/iio/adc/ad7476.c                           |   26 +-
 drivers/iio/adc/ad7791.c                           |   19 +-
 drivers/iio/adc/ad7793.c                           |   23 +-
 drivers/iio/adc/ad7887.c                           |   23 +-
 drivers/iio/adc/ad7923.c                           |   20 +-
 drivers/iio/adc/at91_adc.c                         |  113 +-
 drivers/iio/adc/exynos_adc.c                       |   23 +-
 drivers/iio/adc/lp8788_adc.c                       |    7 +-
 drivers/iio/adc/max1363.c                          |   15 +-
 drivers/iio/adc/mcp320x.c                          |   18 +-
 drivers/iio/adc/nau7802.c                          |  581 ++
 drivers/iio/adc/ti-adc081c.c                       |   18 +-
 drivers/iio/adc/ti_am335x_adc.c                    |   13 +-
 drivers/iio/adc/twl6030-gpadc.c                    | 1013 +++
 drivers/iio/adc/viperboard_adc.c                   |    9 +-
 drivers/iio/amplifiers/Kconfig                     |    2 +
 drivers/iio/amplifiers/Makefile                    |    1 +
 drivers/iio/amplifiers/ad8366.c                    |   13 +-
 drivers/iio/common/Makefile                        |    1 +
 drivers/iio/common/st_sensors/st_sensors_core.c    |   41 +-
 drivers/iio/dac/Kconfig                            |   44 +-
 drivers/iio/dac/Makefile                           |    1 +
 drivers/iio/dac/ad5064.c                           |   21 +-
 drivers/iio/dac/ad5360.c                           |   15 +-
 drivers/iio/dac/ad5380.c                           |   18 +-
 drivers/iio/dac/ad5421.c                           |   19 +-
 drivers/iio/dac/ad5446.c                           |   19 +-
 drivers/iio/dac/ad5449.c                           |   15 +-
 drivers/iio/dac/ad5504.c                           |   31 +-
 drivers/iio/dac/ad5624r_spi.c                      |   22 +-
 drivers/iio/dac/ad5686.c                           |   17 +-
 drivers/iio/dac/ad5755.c                           |   14 +-
 drivers/iio/dac/ad5764.c                           |   20 +-
 drivers/iio/dac/ad5791.c                           |   35 +-
 drivers/iio/dac/ad7303.c                           |   31 +-
 drivers/iio/dac/max517.c                           |   17 +-
 drivers/iio/dac/mcp4725.c                          |  177 +-
 drivers/iio/frequency/Kconfig                      |    1 +
 drivers/iio/frequency/Makefile                     |    1 +
 drivers/iio/frequency/ad9523.c                     |   17 +-
 drivers/iio/frequency/adf4350.c                    |   31 +-
 drivers/iio/gyro/Kconfig                           |   18 +-
 drivers/iio/gyro/Makefile                          |    2 +
 drivers/iio/gyro/adis16080.c                       |   21 +-
 drivers/iio/gyro/adis16130.c                       |   23 +-
 drivers/iio/gyro/adis16136.c                       |   10 +-
 .../gyro/adis16260_core.c => iio/gyro/adis16260.c} |  319 +-
 drivers/iio/gyro/adxrs450.c                        |   15 +-
 drivers/iio/gyro/hid-sensor-gyro-3d.c              |   41 +-
 drivers/iio/gyro/itg3200_core.c                    |   15 +-
 drivers/iio/gyro/st_gyro.h                         |   11 +-
 drivers/iio/gyro/st_gyro_core.c                    |   14 +-
 drivers/iio/gyro/st_gyro_i2c.c                     |   18 +-
 drivers/iio/gyro/st_gyro_spi.c                     |   18 +-
 drivers/iio/iio_core_trigger.h                     |    7 +-
 drivers/iio/imu/Kconfig                            |    2 +
 drivers/iio/imu/Makefile                           |    1 +
 drivers/iio/imu/adis16400_core.c                   |   10 +-
 drivers/iio/imu/adis16480.c                        |   10 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |   29 +-
 drivers/iio/industrialio-core.c                    |   51 +-
 drivers/iio/industrialio-trigger.c                 |   72 +-
 drivers/iio/light/Kconfig                          |   34 +-
 drivers/iio/light/Makefile                         |    4 +-
 drivers/iio/light/adjd_s311.c                      |   43 +-
 drivers/iio/light/apds9300.c                       |  512 ++
 drivers/iio/light/hid-sensor-als.c                 |   41 +-
 drivers/iio/light/lm3533-als.c                     |    7 +-
 drivers/iio/light/tsl2563.c                        |   25 +-
 drivers/iio/light/vcnl4000.c                       |   16 +-
 drivers/iio/magnetometer/Kconfig                   |    6 +-
 drivers/iio/magnetometer/Makefile                  |    1 +
 drivers/iio/magnetometer/hid-sensor-magn-3d.c      |   43 +-
 drivers/iio/magnetometer/st_magn.h                 |    3 +-
 drivers/iio/magnetometer/st_magn_core.c            |    6 +-
 drivers/iio/magnetometer/st_magn_i2c.c             |   17 +-
 drivers/iio/magnetometer/st_magn_spi.c             |   17 +-
 drivers/iio/pressure/Kconfig                       |   14 +-
 drivers/iio/pressure/Makefile                      |    1 +
 drivers/iio/pressure/st_pressure.h                 |   11 +-
 drivers/iio/pressure/st_pressure_core.c            |   21 +-
 drivers/iio/pressure/st_pressure_i2c.c             |   17 +-
 drivers/iio/pressure/st_pressure_spi.c             |   17 +-
 drivers/iio/temperature/Kconfig                    |   16 +
 drivers/iio/temperature/Makefile                   |    5 +
 drivers/iio/temperature/tmp006.c                   |  291 +
 drivers/iio/trigger/Kconfig                        |    4 +-
 drivers/iio/trigger/Makefile                       |    1 +
 drivers/staging/Kconfig                            |   14 +-
 drivers/staging/Makefile                           |    7 +-
 drivers/staging/android/binder.c                   |   32 +-
 drivers/staging/android/binder.h                   |   48 +-
 drivers/staging/android/sw_sync.c                  |    2 +-
 drivers/staging/android/sync.c                     |    2 +-
 drivers/staging/android/timed_output.c             |   27 +-
 drivers/staging/asus_oled/Kconfig                  |    6 -
 drivers/staging/asus_oled/Makefile                 |    1 -
 drivers/staging/asus_oled/README                   |  156 -
 drivers/staging/asus_oled/TODO                     |   10 -
 drivers/staging/asus_oled/asus_oled.c              |  847 --
 drivers/staging/asus_oled/linux.txt                |   33 -
 drivers/staging/asus_oled/linux_f.txt              |   18 -
 drivers/staging/asus_oled/linux_fr.txt             |   33 -
 drivers/staging/asus_oled/tux.txt                  |   33 -
 drivers/staging/asus_oled/tux_r.txt                |   33 -
 drivers/staging/asus_oled/tux_r2.txt               |   33 -
 drivers/staging/asus_oled/zig.txt                  |   33 -
 drivers/staging/bcm/Bcmchar.c                      |    4 +-
 drivers/staging/bcm/DDRInit.c                      |   54 +-
 drivers/staging/bcm/Ioctl.h                        |    2 +-
 drivers/staging/bcm/LeakyBucket.c                  |  262 +-
 drivers/staging/bcm/Misc.c                         |    2 +-
 drivers/staging/bcm/Qos.c                          |  538 +-
 drivers/staging/bcm/Version.h                      |   29 -
 drivers/staging/bcm/headers.h                      |    3 +-
 drivers/staging/bcm/nvm.c                          |    2 +-
 drivers/staging/comedi/Kconfig                     |   44 +-
 drivers/staging/comedi/comedi_buf.c                |    2 +
 drivers/staging/comedi/comedi_fops.c               |    1 -
 drivers/staging/comedi/comedi_internal.h           |    1 +
 drivers/staging/comedi/comedidev.h                 |   22 +-
 drivers/staging/comedi/comedilib.h                 |    7 +-
 drivers/staging/comedi/drivers.c                   |   94 +-
 drivers/staging/comedi/drivers/8255.c              |   45 +-
 drivers/staging/comedi/drivers/8255_pci.c          |    4 +-
 drivers/staging/comedi/drivers/Makefile            |    3 +-
 .../comedi/drivers/addi-data/APCI1710_82x54.c      | 1068 ---
 .../comedi/drivers/addi-data/APCI1710_Chrono.c     | 2050 -----
 .../comedi/drivers/addi-data/APCI1710_Dig_io.c     | 1037 ---
 .../comedi/drivers/addi-data/APCI1710_INCCPT.c     | 5461 -------------
 .../comedi/drivers/addi-data/APCI1710_Inp_cpt.c    |  866 --
 .../comedi/drivers/addi-data/APCI1710_Pwm.c        | 3582 ---------
 .../comedi/drivers/addi-data/APCI1710_Ssi.c        |  845 --
 .../comedi/drivers/addi-data/APCI1710_Tor.c        | 2065 -----
 .../comedi/drivers/addi-data/APCI1710_Ttl.c        | 1044 ---
 .../staging/comedi/drivers/addi-data/addi_common.c |    3 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |  169 -
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |    2 +
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      | 1314 ---
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |    2 +
 drivers/staging/comedi/drivers/addi_apci_035.c     |    1 +
 drivers/staging/comedi/drivers/addi_apci_1032.c    |    4 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c    |    1 +
 drivers/staging/comedi/drivers/addi_apci_1516.c    |    4 +-
 drivers/staging/comedi/drivers/addi_apci_1564.c    |    1 +
 drivers/staging/comedi/drivers/addi_apci_16xx.c    |   43 +-
 drivers/staging/comedi/drivers/addi_apci_1710.c    |   99 -
 drivers/staging/comedi/drivers/addi_apci_2032.c    |    2 +
 drivers/staging/comedi/drivers/addi_apci_2200.c    |    1 +
 drivers/staging/comedi/drivers/addi_apci_3120.c    |    4 +-
 drivers/staging/comedi/drivers/addi_apci_3200.c    |    1 +
 drivers/staging/comedi/drivers/addi_apci_3501.c    |    4 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |   40 +-
 drivers/staging/comedi/drivers/addi_watchdog.c     |    1 +
 drivers/staging/comedi/drivers/adl_pci6208.c       |    4 +-
 drivers/staging/comedi/drivers/adl_pci7x3x.c       |    1 +
 drivers/staging/comedi/drivers/adl_pci8164.c       |    1 +
 drivers/staging/comedi/drivers/adl_pci9111.c       |    4 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |    7 +-
 drivers/staging/comedi/drivers/adq12b.c            |    6 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |    4 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |   47 +-
 drivers/staging/comedi/drivers/adv_pci1724.c       |   11 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |    4 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |    5 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |    2 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |    6 +-
 .../staging/comedi/drivers/amplc_dio200_common.c   |   44 +-
 drivers/staging/comedi/drivers/amplc_dio200_pci.c  |    5 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |    7 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |    1 +
 drivers/staging/comedi/drivers/amplc_pci224.c      |    7 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |    4 +-
 drivers/staging/comedi/drivers/amplc_pci263.c      |    1 +
 drivers/staging/comedi/drivers/c6xdigio.c          |    2 -
 drivers/staging/comedi/drivers/cb_das16_cs.c       |   36 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |    4 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |   29 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |    4 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    5 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |    4 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |  367 +-
 drivers/staging/comedi/drivers/comedi_fc.c         |    1 +
 drivers/staging/comedi/drivers/comedi_parport.c    |    5 +-
 drivers/staging/comedi/drivers/comedi_test.c       |    4 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    1 +
 drivers/staging/comedi/drivers/daqboard2000.c      |    4 +-
 drivers/staging/comedi/drivers/das08.c             |    2 +-
 drivers/staging/comedi/drivers/das08_cs.c          |    6 +-
 drivers/staging/comedi/drivers/das08_isa.c         |    4 +-
 drivers/staging/comedi/drivers/das08_pci.c         |    4 +-
 drivers/staging/comedi/drivers/das16.c             | 2029 ++---
 drivers/staging/comedi/drivers/das16m1.c           |    5 +-
 drivers/staging/comedi/drivers/das1800.c           |    5 +-
 drivers/staging/comedi/drivers/das6402.c           |    6 +-
 drivers/staging/comedi/drivers/das800.c            |    5 +-
 drivers/staging/comedi/drivers/dmm32at.c           |   41 +-
 drivers/staging/comedi/drivers/dt2801.c            |   36 +-
 drivers/staging/comedi/drivers/dt2811.c            |    6 +-
 drivers/staging/comedi/drivers/dt2814.c            |    5 +-
 drivers/staging/comedi/drivers/dt2815.c            |    5 +-
 drivers/staging/comedi/drivers/dt2817.c            |   33 +-
 drivers/staging/comedi/drivers/dt282x.c            |   36 +-
 drivers/staging/comedi/drivers/dt3000.c            |   45 +-
 drivers/staging/comedi/drivers/dt9812.c            |   27 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |    5 +-
 drivers/staging/comedi/drivers/fl512.c             |    5 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |   37 +-
 drivers/staging/comedi/drivers/icp_multi.c         |    4 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        | 1015 +--
 drivers/staging/comedi/drivers/jr3_pci.c           |    4 +-
 drivers/staging/comedi/drivers/ke_counter.c        |    1 +
 drivers/staging/comedi/drivers/me4000.c            |  127 +-
 drivers/staging/comedi/drivers/me_daq.c            |   54 +-
 drivers/staging/comedi/drivers/mite.c              |    1 +
 drivers/staging/comedi/drivers/mite.h              |    1 +
 drivers/staging/comedi/drivers/mpc624.c            |    5 +-
 drivers/staging/comedi/drivers/multiq3.c           |    6 +-
 drivers/staging/comedi/drivers/ni_6527.c           |    4 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |    5 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    4 +-
 drivers/staging/comedi/drivers/ni_670x.c           |   30 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    7 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |   61 +-
 drivers/staging/comedi/drivers/ni_atmio.c          |    2 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |   28 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |   28 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |    1 +
 drivers/staging/comedi/drivers/ni_labpc.c          |  283 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c       |    5 +-
 drivers/staging/comedi/drivers/ni_labpc_isadma.c   |  226 +
 drivers/staging/comedi/drivers/ni_labpc_isadma.h   |   57 +
 drivers/staging/comedi/drivers/ni_labpc_pci.c      |    5 +-
 drivers/staging/comedi/drivers/ni_labpc_regs.h     |   75 +
 drivers/staging/comedi/drivers/ni_mio_common.c     |   61 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c         |    1 +
 drivers/staging/comedi/drivers/ni_pcidio.c         |   33 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |    1 +
 drivers/staging/comedi/drivers/ni_tio.c            |    3 +
 drivers/staging/comedi/drivers/ni_tiocmd.c         |    1 +
 drivers/staging/comedi/drivers/pcl711.c            |    5 +-
 drivers/staging/comedi/drivers/pcl724.c            |   13 +-
 drivers/staging/comedi/drivers/pcl726.c            |    6 +-
 drivers/staging/comedi/drivers/pcl730.c            |    3 +-
 drivers/staging/comedi/drivers/pcl812.c            |    6 +-
 drivers/staging/comedi/drivers/pcl816.c            |    5 +-
 drivers/staging/comedi/drivers/pcl818.c            |    5 +-
 drivers/staging/comedi/drivers/pcm3724.c           |   52 +-
 drivers/staging/comedi/drivers/pcmad.c             |    1 +
 drivers/staging/comedi/drivers/pcmda12.c           |    4 +-
 drivers/staging/comedi/drivers/pcmmio.c            |   86 +-
 drivers/staging/comedi/drivers/pcmuio.c            |   39 +-
 drivers/staging/comedi/drivers/poc.c               |    6 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |    4 +-
 drivers/staging/comedi/drivers/rtd520.c            |   24 +-
 drivers/staging/comedi/drivers/rti800.c            |    7 +-
 drivers/staging/comedi/drivers/rti802.c            |    6 +-
 drivers/staging/comedi/drivers/s526.c              |   50 +-
 drivers/staging/comedi/drivers/s626.c              |   27 +-
 drivers/staging/comedi/drivers/s626.h              |    2 -
 drivers/staging/comedi/drivers/serial2002.c        |    5 +-
 drivers/staging/comedi/drivers/skel.c              |   49 +-
 drivers/staging/comedi/drivers/ssv_dnp.c           |   79 +-
 drivers/staging/comedi/drivers/unioxx5.c           |    4 +-
 drivers/staging/comedi/drivers/usbdux.c            | 2485 ++----
 drivers/staging/comedi/drivers/usbduxfast.c        |    3 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |  317 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |    3 +-
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |   60 +-
 drivers/staging/comedi/proc.c                      |    2 +
 drivers/staging/comedi/range.c                     |   43 +-
 drivers/staging/crystalhd/crystalhd_cmds.c         |    3 +-
 drivers/staging/crystalhd/crystalhd_hw.c           |    7 +-
 drivers/staging/crystalhd/crystalhd_lnx.c          |    3 +-
 drivers/staging/crystalhd/crystalhd_misc.h         |    4 +-
 drivers/staging/cxt1e1/Makefile                    |    1 -
 drivers/staging/cxt1e1/comet.c                     |   23 +-
 drivers/staging/cxt1e1/functions.c                 |    9 +-
 drivers/staging/cxt1e1/hwprobe.c                   |    8 +-
 drivers/staging/cxt1e1/linux.c                     |   52 +-
 drivers/staging/cxt1e1/musycc.c                    |   15 +-
 drivers/staging/cxt1e1/pmc93x6_eeprom.c            |   15 +-
 drivers/staging/cxt1e1/pmcc4_drv.c                 |   11 +-
 drivers/staging/cxt1e1/sbeid.c                     |    7 -
 drivers/staging/dgap/Kconfig                       |    6 +
 drivers/staging/dgap/Makefile                      |    9 +
 drivers/staging/dgap/dgap_conf.h                   |  290 +
 drivers/staging/dgap/dgap_downld.h                 |   69 +
 drivers/staging/dgap/dgap_driver.c                 | 1048 +++
 drivers/staging/dgap/dgap_driver.h                 |  618 ++
 drivers/staging/dgap/dgap_fep5.c                   | 1953 +++++
 drivers/staging/dgap/dgap_fep5.h                   |  253 +
 drivers/staging/dgap/dgap_kcompat.h                |   93 +
 drivers/staging/dgap/dgap_parse.c                  | 1371 ++++
 drivers/staging/dgap/dgap_parse.h                  |   35 +
 drivers/staging/dgap/dgap_pci.h                    |   92 +
 drivers/staging/dgap/dgap_sysfs.c                  |  793 ++
 drivers/staging/dgap/dgap_sysfs.h                  |   48 +
 drivers/staging/dgap/dgap_trace.c                  |  185 +
 drivers/staging/dgap/dgap_trace.h                  |   36 +
 drivers/staging/dgap/dgap_tty.c                    | 3597 +++++++++
 drivers/staging/dgap/dgap_tty.h                    |   39 +
 drivers/staging/dgap/dgap_types.h                  |   36 +
 drivers/staging/dgap/digi.h                        |  376 +
 drivers/staging/dgap/downld.c                      |  798 ++
 drivers/staging/dgnc/Kconfig                       |    6 +
 drivers/staging/dgnc/Makefile                      |    7 +
 drivers/staging/dgnc/TODO                          |   17 +
 drivers/staging/dgnc/dgnc_cls.c                    | 1409 ++++
 drivers/staging/dgnc/dgnc_cls.h                    |   90 +
 drivers/staging/dgnc/dgnc_driver.c                 |  958 +++
 drivers/staging/dgnc/dgnc_driver.h                 |  563 ++
 drivers/staging/dgnc/dgnc_kcompat.h                |   93 +
 drivers/staging/dgnc/dgnc_mgmt.c                   |  305 +
 drivers/staging/dgnc/dgnc_mgmt.h                   |   31 +
 drivers/staging/dgnc/dgnc_neo.c                    | 1974 +++++
 drivers/staging/dgnc/dgnc_neo.h                    |  157 +
 drivers/staging/dgnc/dgnc_pci.h                    |   75 +
 drivers/staging/dgnc/dgnc_sysfs.c                  |  756 ++
 drivers/staging/dgnc/dgnc_sysfs.h                  |   49 +
 drivers/staging/dgnc/dgnc_trace.c                  |  184 +
 drivers/staging/dgnc/dgnc_trace.h                  |   44 +
 drivers/staging/dgnc/dgnc_tty.c                    | 3544 ++++++++
 drivers/staging/dgnc/dgnc_tty.h                    |   42 +
 drivers/staging/dgnc/dgnc_types.h                  |   36 +
 drivers/staging/dgnc/digi.h                        |  416 +
 drivers/staging/dgnc/dpacompat.h                   |  115 +
 drivers/staging/dgrp/dgrp_driver.c                 |   14 +-
 drivers/staging/dwc2/Kconfig                       |    1 -
 drivers/staging/dwc2/core.c                        |  449 +-
 drivers/staging/dwc2/core.h                        |  221 +-
 drivers/staging/dwc2/core_intr.c                   |    4 +-
 drivers/staging/dwc2/hcd.c                         |  281 +-
 drivers/staging/dwc2/hcd.h                         |   45 +-
 drivers/staging/dwc2/hcd_ddma.c                    |   31 +-
 drivers/staging/dwc2/hcd_intr.c                    |  129 +-
 drivers/staging/dwc2/hcd_queue.c                   |   22 +-
 drivers/staging/dwc2/hw.h                          |  156 +-
 drivers/staging/dwc2/pci.c                         |    4 +-
 drivers/staging/et131x/README                      |    1 -
 drivers/staging/frontier/tranzport.c               |   10 +-
 drivers/staging/gdm724x/Kconfig                    |   15 +
 drivers/staging/gdm724x/Makefile                   |    7 +
 drivers/staging/gdm724x/TODO                       |   16 +
 drivers/staging/gdm724x/gdm_endian.c               |   67 +
 drivers/staging/gdm724x/gdm_endian.h               |   49 +
 drivers/staging/gdm724x/gdm_lte.c                  |  877 ++
 drivers/staging/gdm724x/gdm_lte.h                  |   81 +
 drivers/staging/gdm724x/gdm_mux.c                  |  690 ++
 drivers/staging/gdm724x/gdm_mux.h                  |   95 +
 drivers/staging/gdm724x/gdm_tty.c                  |  343 +
 drivers/staging/gdm724x/gdm_tty.h                  |   71 +
 drivers/staging/gdm724x/gdm_usb.c                  | 1049 +++
 drivers/staging/gdm724x/gdm_usb.h                  |  109 +
 drivers/staging/gdm724x/hci.h                      |   55 +
 drivers/staging/gdm724x/hci_packet.h               |   93 +
 drivers/staging/gdm724x/netlink_k.c                |  149 +
 drivers/staging/gdm724x/netlink_k.h                |   25 +
 drivers/staging/iio/Documentation/device.txt       |    4 +-
 drivers/staging/iio/accel/adis16201_core.c         |   17 +-
 drivers/staging/iio/accel/adis16203_core.c         |   16 +-
 drivers/staging/iio/accel/adis16204_core.c         |   16 +-
 drivers/staging/iio/accel/adis16209_core.c         |   16 +-
 drivers/staging/iio/accel/adis16220_core.c         |   14 +-
 drivers/staging/iio/accel/adis16240_core.c         |   16 +-
 drivers/staging/iio/accel/lis3l02dq_core.c         |   15 +-
 drivers/staging/iio/accel/sca3000_core.c           |   15 +-
 drivers/staging/iio/adc/mxs-lradc.c                |   45 +-
 drivers/staging/iio/adc/spear_adc.c                |   30 +-
 drivers/staging/iio/addac/adt7316.c                |   27 -
 drivers/staging/iio/cdc/ad7150.c                   |   36 +-
 drivers/staging/iio/cdc/ad7152.c                   |   16 +-
 drivers/staging/iio/cdc/ad7746.c                   |   18 +-
 drivers/staging/iio/gyro/Kconfig                   |   12 -
 drivers/staging/iio/gyro/Makefile                  |    3 -
 drivers/staging/iio/gyro/adis16060_core.c          |   17 +-
 drivers/staging/iio/gyro/adis16260.h               |   98 -
 drivers/staging/iio/gyro/adis16260_platform_data.h |   19 -
 drivers/staging/iio/light/isl29018.c               |   16 +-
 drivers/staging/iio/light/isl29028.c               |   13 +-
 drivers/staging/iio/magnetometer/hmc5843.c         |   71 +-
 drivers/staging/iio/meter/ade7753.c                |   18 -
 drivers/staging/iio/meter/ade7754.c                |   19 -
 drivers/staging/iio/meter/ade7758_core.c           |   18 -
 drivers/staging/iio/meter/ade7758_ring.c           |    2 +-
 drivers/staging/iio/meter/ade7759.c                |   18 -
 drivers/staging/iio/meter/ade7854.c                |   19 -
 drivers/staging/iio/resolver/ad2s1210.c            |   18 -
 drivers/staging/imx-drm/Kconfig                    |    4 +-
 drivers/staging/imx-drm/TODO                       |    1 -
 drivers/staging/imx-drm/imx-drm-core.c             |   21 +-
 drivers/staging/imx-drm/imx-ldb.c                  |    3 +-
 drivers/staging/imx-drm/imx-tve.c                  |   25 +-
 drivers/staging/imx-drm/ipu-v3/ipu-common.c        |   17 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c            |    5 +-
 drivers/staging/imx-drm/ipu-v3/ipu-di.c            |    4 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c            |   13 +-
 drivers/staging/imx-drm/ipuv3-crtc.c               |    1 +
 drivers/staging/imx-drm/parallel-display.c         |    1 +
 drivers/staging/keucr/scsiglue.c                   |   13 +-
 drivers/staging/line6/driver.c                     |    9 -
 drivers/staging/line6/driver.h                     |    3 -
 drivers/staging/line6/pcm.c                        |   27 +-
 drivers/staging/line6/pod.c                        |   21 +-
 drivers/staging/lustre/Makefile                    |    2 +-
 .../staging/lustre/include/linux/libcfs/bitmap.h   |    4 +-
 .../staging/lustre/include/linux/libcfs/curproc.h  |    2 -
 .../staging/lustre/include/linux/libcfs/libcfs.h   |   46 -
 .../lustre/include/linux/libcfs/libcfs_cpu.h       |   46 +-
 .../lustre/include/linux/libcfs/libcfs_crypto.h    |    8 +-
 .../lustre/include/linux/libcfs/libcfs_debug.h     |   68 -
 .../lustre/include/linux/libcfs/libcfs_hash.h      |    2 +-
 .../lustre/include/linux/libcfs/libcfs_prim.h      |   24 +-
 .../lustre/include/linux/libcfs/libcfs_private.h   |    7 +-
 .../lustre/include/linux/libcfs/linux/kp30.h       |   59 +-
 .../lustre/include/linux/libcfs/linux/libcfs.h     |    3 -
 .../lustre/include/linux/libcfs/linux/linux-cpu.h  |    9 -
 .../lustre/include/linux/libcfs/linux/linux-lock.h |    2 +-
 .../lustre/include/linux/libcfs/linux/linux-mem.h  |    4 +-
 .../lustre/include/linux/libcfs/linux/linux-prim.h |  158 -
 .../include/linux/libcfs/linux/linux-tcpip.h       |   15 -
 .../lustre/include/linux/libcfs/linux/linux-time.h |    1 -
 .../include/linux/libcfs/linux/portals_compat25.h  |   15 -
 .../staging/lustre/include/linux/libcfs/lucache.h  |    2 +-
 .../lustre/include/linux/libcfs/params_tree.h      |    4 +-
 .../staging/lustre/include/linux/lnet/lib-types.h  |    6 +-
 drivers/staging/lustre/include/linux/lnet/lnetst.h |    2 +-
 drivers/staging/lustre/include/linux/lnet/ptllnd.h |    4 +-
 drivers/staging/lustre/lnet/Makefile               |    2 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |   10 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |    1 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |   14 +-
 .../lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c  |    2 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |   60 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |  112 +-
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.c  |   11 +-
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.h  |    3 -
 .../lustre/lnet/klnds/socklnd/socklnd_proto.c      |   62 +-
 drivers/staging/lustre/lnet/lnet/Makefile          |    2 +-
 drivers/staging/lustre/lnet/lnet/acceptor.c        |   62 +-
 drivers/staging/lustre/lnet/lnet/api-errno.c       |   39 -
 drivers/staging/lustre/lnet/lnet/api-ni.c          |    7 +-
 drivers/staging/lustre/lnet/lnet/lib-eq.c          |   14 +-
 drivers/staging/lustre/lnet/lnet/lib-msg.c         |   13 +-
 drivers/staging/lustre/lnet/lnet/module.c          |    9 +-
 drivers/staging/lustre/lnet/lnet/router_proc.c     |    2 +-
 drivers/staging/lustre/lnet/selftest/brw_test.c    |    2 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c      |    2 +-
 drivers/staging/lustre/lnet/selftest/console.c     |    2 +-
 drivers/staging/lustre/lnet/selftest/module.c      |    4 +-
 drivers/staging/lustre/lnet/selftest/rpc.c         |    6 +-
 drivers/staging/lustre/lnet/selftest/timer.c       |    2 +-
 drivers/staging/lustre/lustre/Kconfig              |   13 +-
 drivers/staging/lustre/lustre/Makefile             |    4 +-
 drivers/staging/lustre/lustre/fid/Makefile         |    2 +-
 drivers/staging/lustre/lustre/fid/fid_handler.c    |  661 --
 drivers/staging/lustre/lustre/fid/fid_internal.h   |   36 +-
 drivers/staging/lustre/lustre/fid/fid_lib.c        |   14 +-
 drivers/staging/lustre/lustre/fid/fid_request.c    |  164 +-
 drivers/staging/lustre/lustre/fid/fid_store.c      |  259 -
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |   28 +-
 drivers/staging/lustre/lustre/fld/Makefile         |    2 +-
 drivers/staging/lustre/lustre/fld/fld_cache.c      |   45 +-
 drivers/staging/lustre/lustre/fld/fld_handler.c    |  447 --
 drivers/staging/lustre/lustre/fld/fld_index.c      |  426 -
 drivers/staging/lustre/lustre/fld/fld_internal.h   |   31 +-
 drivers/staging/lustre/lustre/fld/fld_request.c    |   90 +-
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |  217 +-
 drivers/staging/lustre/lustre/include/cl_object.h  |   18 +-
 .../lustre/lustre/include/linux/lprocfs_status.h   |    1 -
 .../lustre/lustre/include/linux/lustre_compat25.h  |  103 -
 .../lustre/lustre/include/linux/lustre_fsfilt.h    |   12 +-
 .../lustre/lustre/include/linux/lustre_handles.h   |    1 -
 .../lustre/lustre/include/linux/lustre_lib.h       |   10 +-
 .../lustre/lustre/include/linux/lustre_lite.h      |    2 -
 .../lustre/lustre/include/linux/lustre_net.h       |    1 -
 .../lustre/include/linux/lustre_patchless_compat.h |    2 +-
 .../lustre/lustre/include/linux/lustre_quota.h     |    1 -
 .../lustre/lustre/include/linux/lustre_user.h      |   19 +-
 drivers/staging/lustre/lustre/include/linux/lvfs.h |    8 +-
 drivers/staging/lustre/lustre/include/linux/obd.h  |    5 +-
 .../staging/lustre/lustre/include/lprocfs_status.h |   73 +-
 drivers/staging/lustre/lustre/include/lu_object.h  |   25 +-
 drivers/staging/lustre/lustre/include/lu_ref.h     |   14 +-
 .../lustre/lustre/include/lustre/lustre_errno.h    |  215 +
 .../lustre/lustre/include/lustre/lustre_idl.h      |   82 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |   12 +
 drivers/staging/lustre/lustre/include/lustre_cfg.h |   30 +-
 .../staging/lustre/lustre/include/lustre_disk.h    |   56 +-
 drivers/staging/lustre/lustre/include/lustre_dlm.h |  204 +-
 .../lustre/lustre/include/lustre_dlm_flags.h       |  460 ++
 drivers/staging/lustre/lustre/include/lustre_fid.h |  125 +-
 drivers/staging/lustre/lustre/include/lustre_fld.h |   45 +-
 .../staging/lustre/lustre/include/lustre_idmap.h   |    4 +-
 .../staging/lustre/lustre/include/lustre_import.h  |    2 +
 drivers/staging/lustre/lustre/include/lustre_lib.h |    5 +-
 drivers/staging/lustre/lustre/include/lustre_log.h |   32 +-
 drivers/staging/lustre/lustre/include/lustre_mdc.h |   12 +-
 drivers/staging/lustre/lustre/include/lustre_mdt.h |   84 -
 drivers/staging/lustre/lustre/include/lustre_net.h |   47 +-
 .../staging/lustre/lustre/include/lustre_quota.h   |    2 +-
 drivers/staging/lustre/lustre/include/lustre_sec.h |    2 +-
 drivers/staging/lustre/lustre/include/md_object.h  |    7 +-
 drivers/staging/lustre/lustre/include/obd.h        |  185 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |  392 +-
 drivers/staging/lustre/lustre/include/obd_lov.h    |   10 -
 .../staging/lustre/lustre/include/obd_support.h    |    1 +
 drivers/staging/lustre/lustre/lclient/glimpse.c    |   19 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |   43 +-
 .../staging/lustre/lustre/lclient/lcommon_misc.c   |    8 +-
 drivers/staging/lustre/lustre/ldlm/interval_tree.c |   50 +-
 drivers/staging/lustre/lustre/ldlm/l_lock.c        |    8 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_extent.c   |   10 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   66 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_internal.h |   49 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |   79 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |  394 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |  120 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |  137 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |  181 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   95 +-
 drivers/staging/lustre/lustre/libcfs/Makefile      |    2 +-
 drivers/staging/lustre/lustre/libcfs/debug.c       |   19 +-
 drivers/staging/lustre/lustre/libcfs/hash.c        |   24 +-
 .../lustre/lustre/libcfs/kernel_user_comm.c        |   15 +-
 drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c  |    3 -
 drivers/staging/lustre/lustre/libcfs/libcfs_lock.c |    3 -
 drivers/staging/lustre/lustre/libcfs/libcfs_mem.c  |    3 -
 .../staging/lustre/lustre/libcfs/libcfs_string.c   |   49 -
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |   46 +-
 .../lustre/lustre/libcfs/linux/linux-crypto.c      |    2 +
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |   21 +-
 .../lustre/lustre/libcfs/linux/linux-debug.c       |   69 +-
 .../lustre/lustre/libcfs/linux/linux-module.c      |   31 +-
 .../lustre/lustre/libcfs/linux/linux-prim.c        |   21 +-
 .../lustre/lustre/libcfs/linux/linux-proc.c        |    4 +-
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |    5 +-
 .../lustre/lustre/libcfs/linux/linux-tracefile.c   |   16 +-
 drivers/staging/lustre/lustre/libcfs/module.c      |   28 +-
 drivers/staging/lustre/lustre/libcfs/nidstrings.c  |   14 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |   13 +-
 .../staging/lustre/lustre/libcfs/upcall_cache.c    |   22 +-
 drivers/staging/lustre/lustre/libcfs/watchdog.c    |  516 --
 drivers/staging/lustre/lustre/libcfs/workitem.c    |    3 +-
 drivers/staging/lustre/lustre/llite/Makefile       |    2 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |   80 +-
 drivers/staging/lustre/lustre/llite/dir.c          |  251 +-
 drivers/staging/lustre/lustre/llite/file.c         |  454 +-
 drivers/staging/lustre/lustre/llite/llite_capa.c   |   26 +-
 drivers/staging/lustre/lustre/llite/llite_close.c  |   23 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |   32 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |  172 +-
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |   67 +-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |   76 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |   15 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |   38 +-
 drivers/staging/lustre/lustre/llite/namei.c        |   97 +-
 drivers/staging/lustre/lustre/llite/remote_perm.c  |   27 +-
 drivers/staging/lustre/lustre/llite/rw.c           |   44 +-
 drivers/staging/lustre/lustre/llite/rw26.c         |   35 +-
 drivers/staging/lustre/lustre/llite/statahead.c    |   88 +-
 drivers/staging/lustre/lustre/llite/super25.c      |    3 +-
 drivers/staging/lustre/lustre/llite/symlink.c      |   16 +-
 drivers/staging/lustre/lustre/llite/vvp_dev.c      |    5 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   59 +-
 drivers/staging/lustre/lustre/llite/vvp_lock.c     |    3 +-
 drivers/staging/lustre/lustre/llite/vvp_object.c   |    8 +-
 drivers/staging/lustre/lustre/llite/vvp_page.c     |   10 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |   48 +-
 drivers/staging/lustre/lustre/lmv/lmv_fld.c        |    7 +-
 drivers/staging/lustre/lustre/lmv/lmv_intent.c     |   38 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |  634 +-
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |    1 -
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |   13 +-
 drivers/staging/lustre/lustre/lov/lov_dev.c        |   33 +-
 drivers/staging/lustre/lustre/lov/lov_ea.c         |   23 +-
 drivers/staging/lustre/lustre/lov/lov_io.c         |  111 +-
 drivers/staging/lustre/lustre/lov/lov_lock.c       |   69 +-
 drivers/staging/lustre/lustre/lov/lov_log.c        |   16 +-
 drivers/staging/lustre/lustre/lov/lov_merge.c      |   10 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c        |  300 +-
 drivers/staging/lustre/lustre/lov/lov_object.c     |  112 +-
 drivers/staging/lustre/lustre/lov/lov_offset.c     |    5 +-
 drivers/staging/lustre/lustre/lov/lov_pack.c       |   82 +-
 drivers/staging/lustre/lustre/lov/lov_page.c       |   13 +-
 drivers/staging/lustre/lustre/lov/lov_pool.c       |   40 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |  157 +-
 drivers/staging/lustre/lustre/lov/lovsub_dev.c     |   12 +-
 drivers/staging/lustre/lustre/lov/lovsub_lock.c    |   31 +-
 drivers/staging/lustre/lustre/lov/lovsub_object.c  |   14 +-
 drivers/staging/lustre/lustre/lov/lovsub_page.c    |    3 +-
 drivers/staging/lustre/lustre/lov/lproc_lov.c      |    1 -
 drivers/staging/lustre/lustre/lvfs/fsfilt.c        |    5 +-
 drivers/staging/lustre/lustre/lvfs/fsfilt_ext3.c   |    1 -
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |   15 +-
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |   10 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |   29 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |  151 +-
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |   46 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |  324 +-
 drivers/staging/lustre/lustre/mgc/libmgc.c         |   19 +-
 drivers/staging/lustre/lustre/mgc/lproc_mgc.c      |    1 -
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |  169 +-
 drivers/staging/lustre/lustre/obdclass/Makefile    |    2 +-
 drivers/staging/lustre/lustre/obdclass/acl.c       |   29 +-
 drivers/staging/lustre/lustre/obdclass/capa.c      |   61 +-
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |  152 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |  144 +-
 drivers/staging/lustre/lustre/obdclass/cl_object.c |   21 +-
 drivers/staging/lustre/lustre/obdclass/cl_page.c   |  108 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |   35 +-
 drivers/staging/lustre/lustre/obdclass/dt_object.c |   28 +-
 drivers/staging/lustre/lustre/obdclass/genops.c    |   79 +-
 drivers/staging/lustre/lustre/obdclass/idmap.c     |   21 +-
 .../lustre/lustre/obdclass/linux/linux-module.c    |   48 +-
 .../lustre/lustre/obdclass/linux/linux-obdo.c      |    4 +-
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |   10 +-
 drivers/staging/lustre/lustre/obdclass/llog.c      |  124 +-
 drivers/staging/lustre/lustre/obdclass/llog_cat.c  |   92 +-
 .../staging/lustre/lustre/obdclass/llog_ioctl.c    |   79 +-
 drivers/staging/lustre/lustre/obdclass/llog_lvfs.c |   99 +-
 drivers/staging/lustre/lustre/obdclass/llog_obd.c  |   37 +-
 drivers/staging/lustre/lustre/obdclass/llog_osd.c  |  121 +-
 drivers/staging/lustre/lustre/obdclass/llog_swab.c |   28 +-
 drivers/staging/lustre/lustre/obdclass/llog_test.c |   89 +-
 .../staging/lustre/lustre/obdclass/local_storage.c |   46 +-
 .../lustre/lustre/obdclass/lprocfs_jobstats.c      |  562 --
 .../lustre/lustre/obdclass/lprocfs_status.c        |   61 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   46 +-
 drivers/staging/lustre/lustre/obdclass/lu_ucred.c  |    8 +-
 .../lustre/lustre/obdclass/lustre_handles.c        |    8 +-
 .../staging/lustre/lustre/obdclass/lustre_peer.c   |    3 +-
 drivers/staging/lustre/lustre/obdclass/md_attrs.c  |   17 +-
 .../staging/lustre/lustre/obdclass/obd_config.c    |  148 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |  134 +-
 drivers/staging/lustre/lustre/obdclass/obdo.c      |   16 +-
 drivers/staging/lustre/lustre/obdecho/echo.c       |   47 +-
 .../staging/lustre/lustre/obdecho/echo_client.c    |  248 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |    3 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c      |  141 +-
 .../staging/lustre/lustre/osc/osc_cl_internal.h    |    4 +-
 drivers/staging/lustre/lustre/osc/osc_dev.c        |   11 +-
 drivers/staging/lustre/lustre/osc/osc_io.c         |   28 +-
 drivers/staging/lustre/lustre/osc/osc_lock.c       |  146 +-
 drivers/staging/lustre/lustre/osc/osc_object.c     |    3 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |   28 +-
 drivers/staging/lustre/lustre/osc/osc_quota.c      |   31 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |  326 +-
 drivers/staging/lustre/lustre/ptlrpc/Makefile      |    1 +
 drivers/staging/lustre/lustre/ptlrpc/client.c      |  161 +-
 drivers/staging/lustre/lustre/ptlrpc/connection.c  |   24 +-
 drivers/staging/lustre/lustre/ptlrpc/errno.c       |  380 +
 drivers/staging/lustre/lustre/ptlrpc/events.c      |   12 -
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_api.h |    2 +-
 .../staging/lustre/lustre/ptlrpc/gss/gss_bulk.c    |   54 +-
 .../lustre/lustre/ptlrpc/gss/gss_cli_upcall.c      |   27 +-
 .../staging/lustre/lustre/ptlrpc/gss/gss_keyring.c |   47 +-
 .../lustre/lustre/ptlrpc/gss/gss_krb5_mech.c       |  124 +-
 .../staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c  |   53 +-
 .../staging/lustre/lustre/ptlrpc/gss/gss_rawobj.c  |    2 +-
 .../lustre/lustre/ptlrpc/gss/gss_svc_upcall.c      |   12 +-
 .../staging/lustre/lustre/ptlrpc/gss/lproc_gss.c   |    6 +-
 drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c |  219 +-
 drivers/staging/lustre/lustre/ptlrpc/import.c      |   61 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_client.c |   11 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_net.c    |    3 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_server.c |   46 +-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |   15 +-
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |   38 +-
 drivers/staging/lustre/lustre/ptlrpc/nrs.c         |  105 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |   34 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |   82 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_module.c   |   11 +-
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |   37 +-
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |   23 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |  123 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c  |   47 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_gc.c      |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_plain.c   |   90 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |  170 +-
 drivers/staging/nvec/nvec.c                        |    5 -
 drivers/staging/octeon-usb/Kconfig                 |    2 +-
 drivers/staging/octeon-usb/cvmx-usb.c              | 5339 ++++++------
 drivers/staging/octeon-usb/cvmx-usb.h              | 1157 +--
 drivers/staging/octeon-usb/cvmx-usbcx-defs.h       |   23 -
 drivers/staging/octeon-usb/cvmx-usbnx-defs.h       |    2 -
 drivers/staging/octeon-usb/octeon-hcd.c            |   33 +-
 drivers/staging/olpc_dcon/Kconfig                  |   11 +-
 drivers/staging/olpc_dcon/TODO                     |   11 +-
 drivers/staging/olpc_dcon/olpc_dcon.c              |   24 +-
 drivers/staging/olpc_dcon/olpc_dcon.h              |   27 +-
 drivers/staging/ozwpan/{Kbuild => Makefile}        |    6 +-
 drivers/staging/ozwpan/ozcdev.c                    |  134 +-
 drivers/staging/ozwpan/ozconfig.h                  |   26 -
 drivers/staging/ozwpan/ozdbg.h                     |   54 +
 drivers/staging/ozwpan/ozeltbuf.c                  |   80 +-
 drivers/staging/ozwpan/ozhcd.c                     |  722 +-
 drivers/staging/ozwpan/ozhcd.h                     |    4 +-
 drivers/staging/ozwpan/ozmain.c                    |   18 +-
 drivers/staging/ozwpan/ozpd.c                      |  276 +-
 drivers/staging/ozwpan/ozpd.h                      |   21 +-
 drivers/staging/ozwpan/ozproto.c                   |  526 +-
 drivers/staging/ozwpan/ozproto.h                   |   32 +-
 drivers/staging/ozwpan/oztrace.c                   |   36 -
 drivers/staging/ozwpan/oztrace.h                   |   35 -
 drivers/staging/ozwpan/ozurbparanoia.c             |   23 +-
 drivers/staging/ozwpan/ozurbparanoia.h             |    4 +-
 drivers/staging/ozwpan/ozusbsvc.c                  |   76 +-
 drivers/staging/ozwpan/ozusbsvc1.c                 |   64 +-
 drivers/staging/quickstart/quickstart.c            |   21 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    2 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    2 +-
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/rtl8187se/r8180.h                  |    2 +-
 drivers/staging/rtl8187se/r8180_93cx6.h            |    2 +-
 drivers/staging/rtl8187se/r8180_core.c             |   10 +-
 drivers/staging/rtl8187se/r8180_hw.h               |    2 +-
 drivers/staging/rtl8187se/r8180_rtl8225.h          |    2 +-
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        |    2 +-
 drivers/staging/rtl8187se/r8180_wx.c               |    2 +-
 drivers/staging/rtl8187se/r8180_wx.h               |    2 +-
 drivers/staging/rtl8188eu/Kconfig                  |   29 +
 drivers/staging/rtl8188eu/Makefile                 |   70 +
 drivers/staging/rtl8188eu/TODO                     |   15 +
 drivers/staging/rtl8188eu/core/rtw_ap.c            | 1988 +++++
 drivers/staging/rtl8188eu/core/rtw_br_ext.c        | 1199 +++
 drivers/staging/rtl8188eu/core/rtw_cmd.c           | 2364 ++++++
 drivers/staging/rtl8188eu/core/rtw_debug.c         |  948 +++
 drivers/staging/rtl8188eu/core/rtw_efuse.c         |  875 ++
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c     | 1640 ++++
 drivers/staging/rtl8188eu/core/rtw_io.c            |  329 +
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c     | 1169 +++
 drivers/staging/rtl8188eu/core/rtw_iol.c           |  209 +
 drivers/staging/rtl8188eu/core/rtw_led.c           | 1692 ++++
 drivers/staging/rtl8188eu/core/rtw_mlme.c          | 2442 ++++++
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c      | 8481 ++++++++++++++++++++
 drivers/staging/rtl8188eu/core/rtw_mp.c            |  997 +++
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c      | 1508 ++++
 drivers/staging/rtl8188eu/core/rtw_p2p.c           | 2064 +++++
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c       |  662 ++
 drivers/staging/rtl8188eu/core/rtw_recv.c          | 2299 ++++++
 drivers/staging/rtl8188eu/core/rtw_rf.c            |   89 +
 drivers/staging/rtl8188eu/core/rtw_security.c      | 1779 ++++
 drivers/staging/rtl8188eu/core/rtw_sreset.c        |   79 +
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c       |  655 ++
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c     | 1689 ++++
 drivers/staging/rtl8188eu/core/rtw_xmit.c          | 2447 ++++++
 drivers/staging/rtl8188eu/hal/Hal8188EFWImg_CE.c   | 1761 ++++
 drivers/staging/rtl8188eu/hal/Hal8188EPwrSeq.c     |   86 +
 .../staging/rtl8188eu/hal/Hal8188ERateAdaptive.c   |  760 ++
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c   |  721 ++
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c  |  231 +
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c   |  269 +
 drivers/staging/rtl8188eu/hal/HalPhyRf.c           |   49 +
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     | 1928 +++++
 drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c       |  132 +
 drivers/staging/rtl8188eu/hal/hal_com.c            |  381 +
 drivers/staging/rtl8188eu/hal/hal_intf.c           |  464 ++
 drivers/staging/rtl8188eu/hal/odm.c                | 2171 +++++
 drivers/staging/rtl8188eu/hal/odm_HWConfig.c       |  596 ++
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c       |  399 +
 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c |  130 +
 drivers/staging/rtl8188eu/hal/odm_debug.c          |   32 +
 drivers/staging/rtl8188eu/hal/odm_interface.c      |  203 +
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c       |  779 ++
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c        |  268 +
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  | 2378 ++++++
 drivers/staging/rtl8188eu/hal/rtl8188e_mp.c        |  860 ++
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    | 1144 +++
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c    |  572 ++
 drivers/staging/rtl8188eu/hal/rtl8188e_rxdesc.c    |  202 +
 drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c    |   80 +
 drivers/staging/rtl8188eu/hal/rtl8188e_xmit.c      |   91 +
 drivers/staging/rtl8188eu/hal/rtl8188eu_led.c      |  111 +
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c     |  138 +
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c     |  706 ++
 drivers/staging/rtl8188eu/hal/usb_halinit.c        | 2346 ++++++
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c      |  726 ++
 .../staging/rtl8188eu/include/Hal8188EFWImg_CE.h   |   28 +
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |  276 +
 drivers/staging/rtl8188eu/include/Hal8188EPhyReg.h | 1094 +++
 drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h |  176 +
 .../rtl8188eu/include/Hal8188ERateAdaptive.h       |   75 +
 drivers/staging/rtl8188eu/include/Hal8188EReg.h    |   46 +
 .../staging/rtl8188eu/include/HalHWImg8188E_BB.h   |   44 +
 .../staging/rtl8188eu/include/HalHWImg8188E_FW.h   |   34 +
 .../staging/rtl8188eu/include/HalHWImg8188E_MAC.h  |   30 +
 .../staging/rtl8188eu/include/HalHWImg8188E_RF.h   |   30 +
 drivers/staging/rtl8188eu/include/HalPhyRf.h       |   30 +
 drivers/staging/rtl8188eu/include/HalPhyRf_8188e.h |   63 +
 drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h   |  128 +
 drivers/staging/rtl8188eu/include/HalVerDef.h      |  167 +
 drivers/staging/rtl8188eu/include/basic_types.h    |  184 +
 drivers/staging/rtl8188eu/include/cmd_osdep.h      |   32 +
 drivers/staging/rtl8188eu/include/drv_types.h      |  334 +
 .../staging/rtl8188eu/include/drv_types_linux.h    |   24 +
 drivers/staging/rtl8188eu/include/ethernet.h       |   42 +
 drivers/staging/rtl8188eu/include/h2clbk.h         |   35 +
 drivers/staging/rtl8188eu/include/hal_com.h        |  173 +
 drivers/staging/rtl8188eu/include/hal_intf.h       |  426 +
 drivers/staging/rtl8188eu/include/ieee80211.h      | 1274 +++
 drivers/staging/rtl8188eu/include/ieee80211_ext.h  |  290 +
 drivers/staging/rtl8188eu/include/if_ether.h       |  111 +
 drivers/staging/rtl8188eu/include/ioctl_cfg80211.h |  107 +
 drivers/staging/rtl8188eu/include/ip.h             |  126 +
 drivers/staging/rtl8188eu/include/mlme_osdep.h     |   35 +
 drivers/staging/rtl8188eu/include/mp_custom_oid.h  |  352 +
 drivers/staging/rtl8188eu/include/nic_spec.h       |   44 +
 drivers/staging/rtl8188eu/include/odm.h            | 1198 +++
 drivers/staging/rtl8188eu/include/odm_HWConfig.h   |  132 +
 drivers/staging/rtl8188eu/include/odm_RTL8188E.h   |   56 +
 .../staging/rtl8188eu/include/odm_RegConfig8188E.h |   43 +
 .../staging/rtl8188eu/include/odm_RegDefine11AC.h  |   54 +
 .../staging/rtl8188eu/include/odm_RegDefine11N.h   |  171 +
 drivers/staging/rtl8188eu/include/odm_debug.h      |  145 +
 drivers/staging/rtl8188eu/include/odm_interface.h  |  164 +
 drivers/staging/rtl8188eu/include/odm_precomp.h    |  104 +
 drivers/staging/rtl8188eu/include/odm_reg.h        |  119 +
 drivers/staging/rtl8188eu/include/odm_types.h      |   62 +
 drivers/staging/rtl8188eu/include/osdep_intf.h     |   83 +
 drivers/staging/rtl8188eu/include/osdep_service.h  |  547 ++
 drivers/staging/rtl8188eu/include/recv_osdep.h     |   56 +
 drivers/staging/rtl8188eu/include/rtl8188e_cmd.h   |  122 +
 drivers/staging/rtl8188eu/include/rtl8188e_dm.h    |   62 +
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h   |  487 ++
 drivers/staging/rtl8188eu/include/rtl8188e_led.h   |   35 +
 drivers/staging/rtl8188eu/include/rtl8188e_recv.h  |   69 +
 drivers/staging/rtl8188eu/include/rtl8188e_rf.h    |   36 +
 drivers/staging/rtl8188eu/include/rtl8188e_spec.h  | 1439 ++++
 .../staging/rtl8188eu/include/rtl8188e_sreset.h    |   31 +
 drivers/staging/rtl8188eu/include/rtl8188e_xmit.h  |  178 +
 drivers/staging/rtl8188eu/include/rtw_android.h    |   64 +
 drivers/staging/rtl8188eu/include/rtw_ap.h         |   65 +
 drivers/staging/rtl8188eu/include/rtw_br_ext.h     |   66 +
 drivers/staging/rtl8188eu/include/rtw_cmd.h        |  991 +++
 drivers/staging/rtl8188eu/include/rtw_debug.h      |  290 +
 drivers/staging/rtl8188eu/include/rtw_eeprom.h     |  130 +
 drivers/staging/rtl8188eu/include/rtw_efuse.h      |  150 +
 drivers/staging/rtl8188eu/include/rtw_event.h      |  115 +
 drivers/staging/rtl8188eu/include/rtw_ht.h         |   44 +
 drivers/staging/rtl8188eu/include/rtw_io.h         |  387 +
 drivers/staging/rtl8188eu/include/rtw_ioctl.h      |  124 +
 drivers/staging/rtl8188eu/include/rtw_ioctl_rtl.h  |   79 +
 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h  |   50 +
 drivers/staging/rtl8188eu/include/rtw_iol.h        |   84 +
 drivers/staging/rtl8188eu/include/rtw_led.h        |  197 +
 drivers/staging/rtl8188eu/include/rtw_mlme.h       |  655 ++
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h   |  877 ++
 drivers/staging/rtl8188eu/include/rtw_mp.h         |  495 ++
 drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h   |  340 +
 .../staging/rtl8188eu/include/rtw_mp_phy_regdef.h  | 1084 +++
 drivers/staging/rtl8188eu/include/rtw_p2p.h        |  135 +
 drivers/staging/rtl8188eu/include/rtw_pwrctrl.h    |  283 +
 drivers/staging/rtl8188eu/include/rtw_qos.h        |   30 +
 drivers/staging/rtl8188eu/include/rtw_recv.h       |  485 ++
 drivers/staging/rtl8188eu/include/rtw_rf.h         |  146 +
 drivers/staging/rtl8188eu/include/rtw_security.h   |  383 +
 drivers/staging/rtl8188eu/include/rtw_sreset.h     |   50 +
 drivers/staging/rtl8188eu/include/rtw_version.h    |    1 +
 drivers/staging/rtl8188eu/include/rtw_xmit.h       |  384 +
 drivers/staging/rtl8188eu/include/sta_info.h       |  384 +
 drivers/staging/rtl8188eu/include/usb_hal.h        |   26 +
 drivers/staging/rtl8188eu/include/usb_ops.h        |  115 +
 drivers/staging/rtl8188eu/include/usb_ops_linux.h  |   55 +
 drivers/staging/rtl8188eu/include/usb_osintf.h     |   45 +
 drivers/staging/rtl8188eu/include/usb_vendor_req.h |   52 +
 drivers/staging/rtl8188eu/include/wifi.h           | 1127 +++
 drivers/staging/rtl8188eu/include/wlan_bssdef.h    |  347 +
 drivers/staging/rtl8188eu/include/xmit_osdep.h     |   67 +
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     | 8222 +++++++++++++++++++
 drivers/staging/rtl8188eu/os_dep/mlme_linux.c      |  246 +
 drivers/staging/rtl8188eu/os_dep/os_intfs.c        | 1251 +++
 drivers/staging/rtl8188eu/os_dep/osdep_service.c   |  815 ++
 drivers/staging/rtl8188eu/os_dep/recv_linux.c      |  261 +
 drivers/staging/rtl8188eu/os_dep/rtw_android.c     |  293 +
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  892 ++
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c   |  288 +
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c      |  290 +
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c     |    2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.h     |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_cam.c        |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_cam.h        |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |    7 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.h       |    8 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.c     |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.h     |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_ethtool.c    |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_pci.c        |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_pci.h        |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_ps.c         |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_ps.h         |    2 +-
 drivers/staging/rtl8192e/rtllib.h                  |    2 +-
 drivers/staging/rtl8192e/rtllib_debug.h            |    2 +-
 drivers/staging/rtl8192e/rtllib_module.c           |    3 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |    6 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |    2 +-
 drivers/staging/rtl8192e/rtllib_softmac_wx.c       |    2 +-
 drivers/staging/rtl8192e/rtllib_tx.c               |    2 +-
 drivers/staging/rtl8192u/authors                   |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |    2 +-
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |    3 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    2 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    2 +-
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    2 +-
 drivers/staging/rtl8192u/r8180_93cx6.c             |    2 +-
 drivers/staging/rtl8192u/r8180_93cx6.h             |    2 +-
 drivers/staging/rtl8192u/r8180_pm.c                |    2 +-
 drivers/staging/rtl8192u/r8180_pm.h                |    2 +-
 drivers/staging/rtl8192u/r8190_rtl8256.h           |    2 +-
 drivers/staging/rtl8192u/r8192U.h                  |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |    2 +-
 drivers/staging/rtl8192u/r8192U_hw.h               |    2 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |    2 +-
 drivers/staging/rtl8192u/r8192U_wx.h               |    2 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.c           |  609 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |    8 +-
 drivers/staging/silicom/bpctl_mod.c                |  582 +-
 .../staging/tidspbridge/include/dspbridge/cmm.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/proc.h   |    2 +-
 drivers/staging/usbip/stub_dev.c                   |    6 +-
 drivers/staging/usbip/usbip_common.c               |   11 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |    2 +-
 drivers/staging/usbip/userspace/src/usbip.c        |   15 +-
 drivers/staging/usbip/userspace/src/usbip_attach.c |    6 +-
 drivers/staging/usbip/userspace/src/usbip_list.c   |    6 +-
 .../staging/usbip/userspace/src/usbip_network.c    |   30 +
 .../staging/usbip/userspace/src/usbip_network.h    |    5 +-
 drivers/staging/usbip/userspace/src/usbipd.c       |  141 +-
 drivers/staging/usbip/vhci_sysfs.c                 |    4 +-
 drivers/staging/vt6655/device_main.c               |    4 +-
 drivers/staging/vt6656/baseband.c                  |   80 +-
 drivers/staging/vt6656/baseband.h                  |   10 +-
 drivers/staging/vt6656/card.c                      |   78 +-
 drivers/staging/vt6656/desc.h                      |  224 -
 drivers/staging/vt6656/device.h                    |   51 +-
 drivers/staging/vt6656/device_cfg.h                |   14 -
 drivers/staging/vt6656/dpc.c                       |   16 +-
 drivers/staging/vt6656/dpc.h                       |    4 +-
 drivers/staging/vt6656/main_usb.c                  |   23 +-
 drivers/staging/vt6656/rxtx.c                      | 1536 ++--
 drivers/staging/vt6656/rxtx.h                      |  761 +-
 drivers/staging/vt6656/usbpipe.c                   |   12 +-
 drivers/staging/vt6656/usbpipe.h                   |    5 +-
 drivers/staging/vt6656/wmgr.c                      |    2 -
 drivers/staging/winbond/mds.c                      |   56 +-
 drivers/staging/winbond/mds_f.h                    |   13 +-
 drivers/staging/winbond/phy_calibration.h          |    1 +
 drivers/staging/winbond/wb35reg.c                  |   36 +-
 drivers/staging/wlags49_h2/Makefile                |    2 -
 drivers/staging/wlags49_h2/wl_cs.c                 |    4 -
 drivers/staging/wlags49_h2/wl_internal.h           |    1 -
 drivers/staging/wlags49_h2/wl_sysfs.c              |  138 -
 drivers/staging/wlags49_h2/wl_sysfs.h              |    7 -
 drivers/staging/wlags49_h25/Makefile               |    3 -
 drivers/staging/wlags49_h25/wl_sysfs.c             |    2 -
 drivers/staging/wlags49_h25/wl_sysfs.h             |    2 -
 drivers/staging/xgifb/XGI_main_26.c                |   12 +-
 drivers/staging/xgifb/vb_init.c                    |   36 +-
 drivers/staging/xgifb/vb_setmode.c                 |  333 +-
 drivers/staging/xgifb/vb_setmode.h                 |   11 +-
 drivers/staging/xillybus/Kconfig                   |   32 +
 drivers/staging/xillybus/Makefile                  |    7 +
 drivers/staging/xillybus/README                    |  403 +
 drivers/staging/xillybus/TODO                      |    5 +
 drivers/staging/xillybus/xillybus.h                |  182 +
 drivers/staging/xillybus/xillybus_core.c           | 2345 ++++++
 drivers/staging/xillybus/xillybus_of.c             |  212 +
 drivers/staging/xillybus/xillybus_pcie.c           |  262 +
 drivers/staging/zcache/Kconfig                     |   59 -
 drivers/staging/zcache/Makefile                    |    8 -
 drivers/staging/zcache/TODO                        |   64 -
 drivers/staging/zcache/debug.c                     |  107 -
 drivers/staging/zcache/debug.h                     |  305 -
 drivers/staging/zcache/ramster.h                   |   59 -
 drivers/staging/zcache/ramster/debug.c             |   68 -
 drivers/staging/zcache/ramster/debug.h             |  145 -
 drivers/staging/zcache/ramster/heartbeat.c         |  462 --
 drivers/staging/zcache/ramster/heartbeat.h         |   87 -
 drivers/staging/zcache/ramster/masklog.c           |  155 -
 drivers/staging/zcache/ramster/masklog.h           |  220 -
 drivers/staging/zcache/ramster/nodemanager.c       |  996 ---
 drivers/staging/zcache/ramster/nodemanager.h       |   88 -
 drivers/staging/zcache/ramster/r2net.c             |  414 -
 drivers/staging/zcache/ramster/ramster-howto.txt   |  366 -
 drivers/staging/zcache/ramster/ramster.c           |  925 ---
 drivers/staging/zcache/ramster/ramster.h           |  161 -
 .../staging/zcache/ramster/ramster_nodemanager.h   |   41 -
 drivers/staging/zcache/ramster/tcp.c               | 2248 ------
 drivers/staging/zcache/ramster/tcp.h               |  159 -
 drivers/staging/zcache/ramster/tcp_internal.h      |  248 -
 drivers/staging/zcache/tmem.c                      |  898 ---
 drivers/staging/zcache/tmem.h                      |  259 -
 drivers/staging/zcache/zbud.c                      | 1066 ---
 drivers/staging/zcache/zbud.h                      |   33 -
 drivers/staging/zcache/zcache-main.c               | 1943 -----
 drivers/staging/zcache/zcache.h                    |   53 -
 drivers/staging/zram/zram_drv.c                    |   95 +-
 drivers/staging/zram/zram_drv.h                    |   10 +
 drivers/staging/zsmalloc/zsmalloc-main.c           |    4 +-
 include/linux/iio/common/st_sensors.h              |   14 +-
 include/linux/iio/iio.h                            |   54 +
 include/linux/iio/sysfs.h                          |    5 -
 include/linux/olpc-ec.h                            |    1 +
 include/linux/platform_data/at91_adc.h             |    4 +
 include/linux/platform_data/st_sensors_pdata.h     |   24 +
 1035 files changed, 144660 insertions(+), 59605 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/accel/bma180.txt
 create mode 100644 Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt
 create mode 100644 Documentation/devicetree/bindings/iio/light/apds9300.txt
 create mode 100644 drivers/iio/accel/bma180.c
 create mode 100644 drivers/iio/adc/nau7802.c
 create mode 100644 drivers/iio/adc/twl6030-gpadc.c
 rename drivers/{staging/iio/gyro/adis16260_core.c => iio/gyro/adis16260.c} (52%)
 create mode 100644 drivers/iio/light/apds9300.c
 create mode 100644 drivers/iio/temperature/Kconfig
 create mode 100644 drivers/iio/temperature/Makefile
 create mode 100644 drivers/iio/temperature/tmp006.c
 delete mode 100644 drivers/staging/asus_oled/Kconfig
 delete mode 100644 drivers/staging/asus_oled/Makefile
 delete mode 100644 drivers/staging/asus_oled/README
 delete mode 100644 drivers/staging/asus_oled/TODO
 delete mode 100644 drivers/staging/asus_oled/asus_oled.c
 delete mode 100644 drivers/staging/asus_oled/linux.txt
 delete mode 100644 drivers/staging/asus_oled/linux_f.txt
 delete mode 100644 drivers/staging/asus_oled/linux_fr.txt
 delete mode 100644 drivers/staging/asus_oled/tux.txt
 delete mode 100644 drivers/staging/asus_oled/tux_r.txt
 delete mode 100644 drivers/staging/asus_oled/tux_r2.txt
 delete mode 100644 drivers/staging/asus_oled/zig.txt
 delete mode 100644 drivers/staging/bcm/Version.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
 delete mode 100644 drivers/staging/comedi/drivers/addi_apci_1710.c
 create mode 100644 drivers/staging/comedi/drivers/ni_labpc_isadma.c
 create mode 100644 drivers/staging/comedi/drivers/ni_labpc_isadma.h
 create mode 100644 drivers/staging/comedi/drivers/ni_labpc_regs.h
 create mode 100644 drivers/staging/dgap/Kconfig
 create mode 100644 drivers/staging/dgap/Makefile
 create mode 100644 drivers/staging/dgap/dgap_conf.h
 create mode 100644 drivers/staging/dgap/dgap_downld.h
 create mode 100644 drivers/staging/dgap/dgap_driver.c
 create mode 100644 drivers/staging/dgap/dgap_driver.h
 create mode 100644 drivers/staging/dgap/dgap_fep5.c
 create mode 100644 drivers/staging/dgap/dgap_fep5.h
 create mode 100644 drivers/staging/dgap/dgap_kcompat.h
 create mode 100644 drivers/staging/dgap/dgap_parse.c
 create mode 100644 drivers/staging/dgap/dgap_parse.h
 create mode 100644 drivers/staging/dgap/dgap_pci.h
 create mode 100644 drivers/staging/dgap/dgap_sysfs.c
 create mode 100644 drivers/staging/dgap/dgap_sysfs.h
 create mode 100644 drivers/staging/dgap/dgap_trace.c
 create mode 100644 drivers/staging/dgap/dgap_trace.h
 create mode 100644 drivers/staging/dgap/dgap_tty.c
 create mode 100644 drivers/staging/dgap/dgap_tty.h
 create mode 100644 drivers/staging/dgap/dgap_types.h
 create mode 100644 drivers/staging/dgap/digi.h
 create mode 100644 drivers/staging/dgap/downld.c
 create mode 100644 drivers/staging/dgnc/Kconfig
 create mode 100644 drivers/staging/dgnc/Makefile
 create mode 100644 drivers/staging/dgnc/TODO
 create mode 100644 drivers/staging/dgnc/dgnc_cls.c
 create mode 100644 drivers/staging/dgnc/dgnc_cls.h
 create mode 100644 drivers/staging/dgnc/dgnc_driver.c
 create mode 100644 drivers/staging/dgnc/dgnc_driver.h
 create mode 100644 drivers/staging/dgnc/dgnc_kcompat.h
 create mode 100644 drivers/staging/dgnc/dgnc_mgmt.c
 create mode 100644 drivers/staging/dgnc/dgnc_mgmt.h
 create mode 100644 drivers/staging/dgnc/dgnc_neo.c
 create mode 100644 drivers/staging/dgnc/dgnc_neo.h
 create mode 100644 drivers/staging/dgnc/dgnc_pci.h
 create mode 100644 drivers/staging/dgnc/dgnc_sysfs.c
 create mode 100644 drivers/staging/dgnc/dgnc_sysfs.h
 create mode 100644 drivers/staging/dgnc/dgnc_trace.c
 create mode 100644 drivers/staging/dgnc/dgnc_trace.h
 create mode 100644 drivers/staging/dgnc/dgnc_tty.c
 create mode 100644 drivers/staging/dgnc/dgnc_tty.h
 create mode 100644 drivers/staging/dgnc/dgnc_types.h
 create mode 100644 drivers/staging/dgnc/digi.h
 create mode 100644 drivers/staging/dgnc/dpacompat.h
 create mode 100644 drivers/staging/gdm724x/Kconfig
 create mode 100644 drivers/staging/gdm724x/Makefile
 create mode 100644 drivers/staging/gdm724x/TODO
 create mode 100644 drivers/staging/gdm724x/gdm_endian.c
 create mode 100644 drivers/staging/gdm724x/gdm_endian.h
 create mode 100644 drivers/staging/gdm724x/gdm_lte.c
 create mode 100644 drivers/staging/gdm724x/gdm_lte.h
 create mode 100644 drivers/staging/gdm724x/gdm_mux.c
 create mode 100644 drivers/staging/gdm724x/gdm_mux.h
 create mode 100644 drivers/staging/gdm724x/gdm_tty.c
 create mode 100644 drivers/staging/gdm724x/gdm_tty.h
 create mode 100644 drivers/staging/gdm724x/gdm_usb.c
 create mode 100644 drivers/staging/gdm724x/gdm_usb.h
 create mode 100644 drivers/staging/gdm724x/hci.h
 create mode 100644 drivers/staging/gdm724x/hci_packet.h
 create mode 100644 drivers/staging/gdm724x/netlink_k.c
 create mode 100644 drivers/staging/gdm724x/netlink_k.h
 delete mode 100644 drivers/staging/iio/gyro/adis16260.h
 delete mode 100644 drivers/staging/iio/gyro/adis16260_platform_data.h
 delete mode 100644 drivers/staging/lustre/lnet/lnet/api-errno.c
 delete mode 100644 drivers/staging/lustre/lustre/fid/fid_handler.c
 delete mode 100644 drivers/staging/lustre/lustre/fid/fid_store.c
 delete mode 100644 drivers/staging/lustre/lustre/fld/fld_handler.c
 delete mode 100644 drivers/staging/lustre/lustre/fld/fld_index.c
 create mode 100644 drivers/staging/lustre/lustre/include/lustre/lustre_errno.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre_mdt.h
 delete mode 100644 drivers/staging/lustre/lustre/libcfs/watchdog.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/errno.c
 rename drivers/staging/ozwpan/{Kbuild => Makefile} (93%)
 delete mode 100644 drivers/staging/ozwpan/ozconfig.h
 create mode 100644 drivers/staging/ozwpan/ozdbg.h
 delete mode 100644 drivers/staging/ozwpan/oztrace.c
 delete mode 100644 drivers/staging/ozwpan/oztrace.h
 create mode 100644 drivers/staging/rtl8188eu/Kconfig
 create mode 100644 drivers/staging/rtl8188eu/Makefile
 create mode 100644 drivers/staging/rtl8188eu/TODO
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_ap.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_br_ext.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_cmd.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_debug.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_efuse.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_ieee80211.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_io.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_iol.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_led.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_mlme.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_mp.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_p2p.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_recv.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_rf.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_security.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_sreset.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_wlan_util.c
 create mode 100644 drivers/staging/rtl8188eu/core/rtw_xmit.c
 create mode 100644 drivers/staging/rtl8188eu/hal/Hal8188EFWImg_CE.c
 create mode 100644 drivers/staging/rtl8188eu/hal/Hal8188EPwrSeq.c
 create mode 100644 drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c
 create mode 100644 drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c
 create mode 100644 drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c
 create mode 100644 drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
 create mode 100644 drivers/staging/rtl8188eu/hal/HalPhyRf.c
 create mode 100644 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
 create mode 100644 drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
 create mode 100644 drivers/staging/rtl8188eu/hal/hal_com.c
 create mode 100644 drivers/staging/rtl8188eu/hal/hal_intf.c
 create mode 100644 drivers/staging/rtl8188eu/hal/odm.c
 create mode 100644 drivers/staging/rtl8188eu/hal/odm_HWConfig.c
 create mode 100644 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
 create mode 100644 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
 create mode 100644 drivers/staging/rtl8188eu/hal/odm_debug.c
 create mode 100644 drivers/staging/rtl8188eu/hal/odm_interface.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_mp.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_rxdesc.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_xmit.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
 create mode 100644 drivers/staging/rtl8188eu/hal/usb_halinit.c
 create mode 100644 drivers/staging/rtl8188eu/hal/usb_ops_linux.c
 create mode 100644 drivers/staging/rtl8188eu/include/Hal8188EFWImg_CE.h
 create mode 100644 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
 create mode 100644 drivers/staging/rtl8188eu/include/Hal8188EPhyReg.h
 create mode 100644 drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h
 create mode 100644 drivers/staging/rtl8188eu/include/Hal8188ERateAdaptive.h
 create mode 100644 drivers/staging/rtl8188eu/include/Hal8188EReg.h
 create mode 100644 drivers/staging/rtl8188eu/include/HalHWImg8188E_BB.h
 create mode 100644 drivers/staging/rtl8188eu/include/HalHWImg8188E_FW.h
 create mode 100644 drivers/staging/rtl8188eu/include/HalHWImg8188E_MAC.h
 create mode 100644 drivers/staging/rtl8188eu/include/HalHWImg8188E_RF.h
 create mode 100644 drivers/staging/rtl8188eu/include/HalPhyRf.h
 create mode 100644 drivers/staging/rtl8188eu/include/HalPhyRf_8188e.h
 create mode 100644 drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h
 create mode 100644 drivers/staging/rtl8188eu/include/HalVerDef.h
 create mode 100644 drivers/staging/rtl8188eu/include/basic_types.h
 create mode 100644 drivers/staging/rtl8188eu/include/cmd_osdep.h
 create mode 100644 drivers/staging/rtl8188eu/include/drv_types.h
 create mode 100644 drivers/staging/rtl8188eu/include/drv_types_linux.h
 create mode 100644 drivers/staging/rtl8188eu/include/ethernet.h
 create mode 100644 drivers/staging/rtl8188eu/include/h2clbk.h
 create mode 100644 drivers/staging/rtl8188eu/include/hal_com.h
 create mode 100644 drivers/staging/rtl8188eu/include/hal_intf.h
 create mode 100644 drivers/staging/rtl8188eu/include/ieee80211.h
 create mode 100644 drivers/staging/rtl8188eu/include/ieee80211_ext.h
 create mode 100644 drivers/staging/rtl8188eu/include/if_ether.h
 create mode 100644 drivers/staging/rtl8188eu/include/ioctl_cfg80211.h
 create mode 100644 drivers/staging/rtl8188eu/include/ip.h
 create mode 100644 drivers/staging/rtl8188eu/include/mlme_osdep.h
 create mode 100644 drivers/staging/rtl8188eu/include/mp_custom_oid.h
 create mode 100644 drivers/staging/rtl8188eu/include/nic_spec.h
 create mode 100644 drivers/staging/rtl8188eu/include/odm.h
 create mode 100644 drivers/staging/rtl8188eu/include/odm_HWConfig.h
 create mode 100644 drivers/staging/rtl8188eu/include/odm_RTL8188E.h
 create mode 100644 drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
 create mode 100644 drivers/staging/rtl8188eu/include/odm_RegDefine11AC.h
 create mode 100644 drivers/staging/rtl8188eu/include/odm_RegDefine11N.h
 create mode 100644 drivers/staging/rtl8188eu/include/odm_debug.h
 create mode 100644 drivers/staging/rtl8188eu/include/odm_interface.h
 create mode 100644 drivers/staging/rtl8188eu/include/odm_precomp.h
 create mode 100644 drivers/staging/rtl8188eu/include/odm_reg.h
 create mode 100644 drivers/staging/rtl8188eu/include/odm_types.h
 create mode 100644 drivers/staging/rtl8188eu/include/osdep_intf.h
 create mode 100644 drivers/staging/rtl8188eu/include/osdep_service.h
 create mode 100644 drivers/staging/rtl8188eu/include/recv_osdep.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_cmd.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_dm.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_hal.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_led.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_recv.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_rf.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_spec.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_xmit.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_android.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_ap.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_br_ext.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_cmd.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_debug.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_eeprom.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_efuse.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_event.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_ht.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_io.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_ioctl.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_ioctl_rtl.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_iol.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_led.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_mlme.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_mp.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_mp_phy_regdef.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_p2p.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_pwrctrl.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_qos.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_recv.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_rf.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_security.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_sreset.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_version.h
 create mode 100644 drivers/staging/rtl8188eu/include/rtw_xmit.h
 create mode 100644 drivers/staging/rtl8188eu/include/sta_info.h
 create mode 100644 drivers/staging/rtl8188eu/include/usb_hal.h
 create mode 100644 drivers/staging/rtl8188eu/include/usb_ops.h
 create mode 100644 drivers/staging/rtl8188eu/include/usb_ops_linux.h
 create mode 100644 drivers/staging/rtl8188eu/include/usb_osintf.h
 create mode 100644 drivers/staging/rtl8188eu/include/usb_vendor_req.h
 create mode 100644 drivers/staging/rtl8188eu/include/wifi.h
 create mode 100644 drivers/staging/rtl8188eu/include/wlan_bssdef.h
 create mode 100644 drivers/staging/rtl8188eu/include/xmit_osdep.h
 create mode 100644 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
 create mode 100644 drivers/staging/rtl8188eu/os_dep/mlme_linux.c
 create mode 100644 drivers/staging/rtl8188eu/os_dep/os_intfs.c
 create mode 100644 drivers/staging/rtl8188eu/os_dep/osdep_service.c
 create mode 100644 drivers/staging/rtl8188eu/os_dep/recv_linux.c
 create mode 100644 drivers/staging/rtl8188eu/os_dep/rtw_android.c
 create mode 100644 drivers/staging/rtl8188eu/os_dep/usb_intf.c
 create mode 100644 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
 create mode 100644 drivers/staging/rtl8188eu/os_dep/xmit_linux.c
 delete mode 100644 drivers/staging/wlags49_h2/wl_sysfs.c
 delete mode 100644 drivers/staging/wlags49_h2/wl_sysfs.h
 delete mode 100644 drivers/staging/wlags49_h25/wl_sysfs.c
 delete mode 100644 drivers/staging/wlags49_h25/wl_sysfs.h
 create mode 100644 drivers/staging/xillybus/Kconfig
 create mode 100644 drivers/staging/xillybus/Makefile
 create mode 100644 drivers/staging/xillybus/README
 create mode 100644 drivers/staging/xillybus/TODO
 create mode 100644 drivers/staging/xillybus/xillybus.h
 create mode 100644 drivers/staging/xillybus/xillybus_core.c
 create mode 100644 drivers/staging/xillybus/xillybus_of.c
 create mode 100644 drivers/staging/xillybus/xillybus_pcie.c
 delete mode 100644 drivers/staging/zcache/Kconfig
 delete mode 100644 drivers/staging/zcache/Makefile
 delete mode 100644 drivers/staging/zcache/TODO
 delete mode 100644 drivers/staging/zcache/debug.c
 delete mode 100644 drivers/staging/zcache/debug.h
 delete mode 100644 drivers/staging/zcache/ramster.h
 delete mode 100644 drivers/staging/zcache/ramster/debug.c
 delete mode 100644 drivers/staging/zcache/ramster/debug.h
 delete mode 100644 drivers/staging/zcache/ramster/heartbeat.c
 delete mode 100644 drivers/staging/zcache/ramster/heartbeat.h
 delete mode 100644 drivers/staging/zcache/ramster/masklog.c
 delete mode 100644 drivers/staging/zcache/ramster/masklog.h
 delete mode 100644 drivers/staging/zcache/ramster/nodemanager.c
 delete mode 100644 drivers/staging/zcache/ramster/nodemanager.h
 delete mode 100644 drivers/staging/zcache/ramster/r2net.c
 delete mode 100644 drivers/staging/zcache/ramster/ramster-howto.txt
 delete mode 100644 drivers/staging/zcache/ramster/ramster.c
 delete mode 100644 drivers/staging/zcache/ramster/ramster.h
 delete mode 100644 drivers/staging/zcache/ramster/ramster_nodemanager.h
 delete mode 100644 drivers/staging/zcache/ramster/tcp.c
 delete mode 100644 drivers/staging/zcache/ramster/tcp.h
 delete mode 100644 drivers/staging/zcache/ramster/tcp_internal.h
 delete mode 100644 drivers/staging/zcache/tmem.c
 delete mode 100644 drivers/staging/zcache/tmem.h
 delete mode 100644 drivers/staging/zcache/zbud.c
 delete mode 100644 drivers/staging/zcache/zbud.h
 delete mode 100644 drivers/staging/zcache/zcache-main.c
 delete mode 100644 drivers/staging/zcache/zcache.h
 create mode 100644 include/linux/platform_data/st_sensors_pdata.h
