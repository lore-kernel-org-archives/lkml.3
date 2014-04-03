Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaDCQMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:12:10 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:34387 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaDCQMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:12:03 -0400
X-AuditID: cbfec373-b7f4a6d000005e0a-2c-533d8851f925
Date: Thu, 03 Apr 2014 13:11:43 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.15-rc1] media updates
Message-id: <20140403131143.69f324c7@samsung.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e9wkG5gh22wwcM3lhZz1q9hs7i8aw6b
	Rc+GrawWj/resjuweJyY8ZvF4/MmuQCmKC6blNSczLLUIn27BK6MG2+usxX828NcceDvTeYG
	xjsHmboYOTkkBEwkPp6aB2WLSVy4t56ti5GLQ0hgCaPE2SXzWCGcPiaJT79ns4NUsQioSlz7
	Mx2sg03ASOJVYwsriC0CZH9+cQWsgVlgMaPEx+frwRqEBfQl9qzaxwxi8woYSvx8vw9qnZPE
	q9eTmSDighI/Jt9jAbGZBdQlJs1bxAxha0s8eXeBdQIj3ywkZbOQlM1CUraAkXkVo2hpcXJB
	cVJ6rpFecWJucWleul5yfu4mRkgAFu9gfLHB6hCjAAejEg8vR7ptsBBrYllxZe4hRgkOZiUR
	3tY2oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGuR1nV8xY7NB30vOKBO+Vw7c25j2a+t1ZYefa
	vD47VaPw07M+dPPwVt/5V/FDoPjeKdu6qbZsZwrE88StzLy5KnftkC0S/8Z9sjxx6fbP0+ff
	+n55HmPB3dl5tSctFYNWnjn25ZP09czXb7YGlNzVuc32hkOo9/TTY0FcmhPUfs9V79kycY+O
	vRJLcUaioRZzUXEiAOcXESceAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For the main set of series of patches for media subsystem, including:
	- Document RC sysfs class;
	- Added an API to setup scancode to allow waking up systems using
	  the Remote Controller;
	- Add API for SDR devices. Drivers are still on staging;
	- Some API improvements for getting EDID data from media
	  inputs/outputs;
	- New DVB frontend driver for drx-j (ATSC);
	- One driver (it913x/it9137) got removed, in favor of an improvement
	  on another driver (af9035);
	- Added a skeleton V4L2 PCI driver at documentation;
	- Added a dual flash driver (lm3646);
	- Added a new IR driver (img-ir);
	- Added an IR scancode decoder for the Sharp protocol;
	- Some improvements at the usbtv driver, to allow its core to be
	  reused.
	- Added a new SDR driver (rtl2832u_sdr);
	- Added a new tuner driver (msi001);
	- Several improvements at em28xx driver to fix PM support,
	  device removal and to split the V4L2 specific bits into a
	  separate sub-driver.
	- One driver got converted to videobuf2 (s2255drv);
	- The e4000 tuner driver now follows an improved binding model;
	- Some fixes at V4L2 compat32 code;
	- Several fixes and enhancements at videobuf2 code;
	- Some cleanups at V4L2 API documentation;
	- usual driver enhancements, new board additions and misc fixups.

Thanks!
Mauro

-

PS.: You'll find some minor conflicts between this changeset and upstream,
mainly due to some code that moved from V4L2 to OF subsystem.

I have a separate topic branch with the exynos5 changes that is
more affected by this. I'll send on a separate pull request, after
this one gets merged.


The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to a83b93a7480441a47856dc9104bea970e84cda87:

  [media] em28xx-dvb: fix PCTV 461e tuner I2C binding (2014-03-31 08:02:16 -0300)

----------------------------------------------------------------
Alexander Shiyan (1):
      [media] stb6100: fix buffer length check in stb6100_write_reg_range()

Alexey Khoroshilov (1):
      [media] adv7180: free an interrupt on failure paths in init_device()

Amit Grover (2):
      [media] v4l2: Add settings for Horizontal and Vertical MV Search Range
      [media] s5p-mfc: Add Horizontal and Vertical MV Search Range

Andy Shevchenko (3):
      [media] lm3560: remove FSF address from the license
      [media] lm3560: keep style for the comments
      [media] lm3560: prevent memory leak in case of pdata absence

Antonio Ospite (2):
      [media] gspca_kinect: fix kinect_read() error path
      [media] gspca_kinect: fix messages about kinect_read() return value

Antti Palosaari (75):
      [media] af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2
      [media] em28xx-dvb: fix PCTV 461e tuner I2C binding
      [media] tda10071: do not check tuner PLL lock on read_status()
      [media] tda10071: coding style issues
      [media] af9035: use default i2c slave address for af9035 too
      [media] devices.txt: add video4linux device for Software Defined Radio
      [media] v4l: add device type for Software Defined Radio
      [media] v4l: add new tuner types for SDR
      [media] v4l: 1 Hz resolution flag for tuners
      [media] v4l: add stream format for SDR receiver
      [media] v4l: define own IOCTL ops for SDR FMT
      [media] v4l: enable some IOCTLs for SDR receiver
      [media] v4l: add device capability flag for SDR receiver
      [media] DocBook: document 1 Hz flag
      [media] DocBook: Software Defined Radio Interface
      [media] DocBook: mark SDR API as Experimental
      [media] v4l2-framework.txt: add SDR device type
      [media] xc2028: silence compiler warnings
      [media] rtl28xxu: add module parameter to disable IR
      [media] rtl2832: remove unused if_dvbt config parameter
      [media] rtl2832: style changes and minor cleanup
      [media] rtl2832: provide muxed I2C adapter
      [media] rtl2832: add muxed I2C adapter for demod itself
      [media] rtl2832: implement delayed I2C gate close
      [media] DocBook: media: document V4L2_CTRL_CLASS_RF_TUNER
      [media] DocBook: document RF tuner gain controls
      [media] v4l: add RF tuner gain controls
      [media] m88ds3103: remove dead code
      [media] m88ds3103: remove dead code 2nd part
      [media] m88ds3103: possible uninitialized scalar variable
      [media] DocBook: document RF tuner bandwidth controls
      [media] v4l: define unit for V4L2_CID_RF_TUNER_BANDWIDTH
      [media] v4l: add RF tuner channel bandwidth control
      [media] v4l: reorganize RF tuner control ID numbers
      [media] DocBook: media: add some general info about RF tuners
      [media] DocBook: V4L: add V4L2_SDR_FMT_CU8 - 'CU08'
      [media] DocBook: V4L: add V4L2_SDR_FMT_CU16LE - 'CU16'
      [media] v4l: uapi: add SDR formats CU8 and CU16LE
      [media] v4l: add enum_freq_bands support to tuner sub-device
      [media] DocBook: media: document PLL lock control
      [media] v4l: add control for RF tuner PLL lock flag
      [media] msi3101: convert to SDR API
      [media] msi001: Mirics MSi001 silicon tuner driver
      [media] msi3101: use msi001 tuner driver
      [media] MAINTAINERS: add msi001 driver
      [media] MAINTAINERS: add msi3101 driver
      [media] msi3101: clamp mmap buffers to reasonable level
      [media] msi001: fix v4l2-compliance issues
      [media] msi3101: fix v4l2-compliance issues
      [media] v4l: rename v4l2_format_sdr to v4l2_sdr_format
      [media] e4000: convert DVB tuner to I2C driver model
      [media] e4000: implement controls via v4l2 control framework
      [media] e4000: fix PLL calc to allow higher frequencies
      [media] e4000: implement PLL lock v4l control
      [media] rtl2832_sdr: Realtek RTL2832 SDR driver module
      [media] rtl2832_sdr: expose e4000 controls to user
      [media] rtl28xxu: constify demod config structs
      [media] rtl28xxu: attach SDR extension module
      [media] rtl28xxu: fix switch-case style issue
      [media] rtl28xxu: depends on I2C_MUX
      [media] rtl28xxu: use muxed RTL2832 I2C adapters for E4000 and RTL2832_SDR
      [media] e4000: get rid of DVB i2c_gate_ctrl()
      [media] e4000: convert to Regmap API
      [media] e4000: rename some variables
      [media] rtl2832_sdr: clamp bandwidth to nearest legal value in automode
      [media] MAINTAINERS: add rtl2832_sdr driver
      [media] e4000: fix 32-bit build error
      [media] rtl2832_sdr: do not use dynamic stack allocation
      [media] af9033: implement PID filter
      [media] af9035: use af9033 PID filters
      [media] e4000: make VIDEO_V4L2 dependency optional
      [media] m88ds3103: fix bug on .set_tone()
      [media] em28xx-dvb: fix PCTV 461e tuner I2C binding
      [media] em28xx: fix PCTV 290e LNA oops
      [media] em28xx-dvb: fix PCTV 461e tuner I2C binding

Antti Seppälä (2):
      [media] nuvoton-cir: Don't touch PS/2 interrupts while initializing
      [media] nuvoton-cir: Activate PNP device when probing

Arnd Bergmann (3):
      [media] omap_vout: avoid sleep_on race
      [media] arv: fix sleep_on race
      [media] Sensoray 2255 uses videobuf2

Dan Carpenter (6):
      [media] tda10071: remove a duplicative test
      [media] gspca_stv06xx: remove an unneeded check
      [media] stv0900: remove an unneeded check
      [media] em28xx-cards: remove a wrong indent level
      [media] av7110_hw: fix a sanity check in av7110_fw_cmd()
      [media] ddbridge: remove unneeded an NULL check

Daniel Jeong (3):
      [media] controls.xml: Document addtional Flash fault bits
      [media] v4l2-controls.h: Add addtional Flash fault bits
      [media] lm3646: add new dual LED Flash driver

Dave Jones (1):
      [media] drx-d: add missing braces in drxd_hard.c:DRXD_init

Dean Anderson (7):
      [media] s2255drv: removal of s2255_dmaqueue structure
      [media] s2255drv: refactoring s2255_channel to s2255_vc
      [media] s2255drv: buffer setup fix
      [media] s2255drv: remove redundant parameter
      [media] s2255drv: dynamic memory allocation efficiency fix
      [media] s2255drv: fix for return code not checked
      [media] s2255drv: cleanup of s2255_fh

Devin Heitmueller (3):
      [media] au0828: rework GPIO management for HVR-950q
      [media] drx-j: add a driver for Trident drx-j frontend
      [media] drx-j: put under 3-clause BSD license

Edgar Thier (1):
      [media] uvcvideo: Add bayer 8-bit patterns to uvcvideo

Federico Simoncelli (1):
      [media] usbtv: split core and video implementation

Fengguang Wu (4):
      [media] em28xx-cards: em28xx_devused can be static
      [media] rc-core: ir_core_dev_number can be static
      [media] drx-j: drxj_default_aud_data_g can be static
      [media] drivers/media/usb/usbtv/usbtv-core.c:119:22: sparse: symbol 'usbtv_id_table' was not declared. Should it be static?

Florian Vaussard (1):
      [media] omap3isp: preview: Fix the crop margins

Frank Schaefer (7):
      [media] em28xx-audio: fix user counting in snd_em28xx_capture_open()
      [media] em28xx-video: do not unregister the v4l2 dummy clock before v4l2_device_unregister() has been called
      [media] em28xx-camera: fix return value checks on sensor probing
      [media] em28xx-v4l: do not call em28xx_init_camera() if the device has no sensor
      [media] em28xx-i2c: fix the i2c error description strings for -ENXIO
      [media] em28xx-i2c: fix the error code for unknown errors
      [media] em28xx-audio: make sure audio is unmuted on open()

Geert Uytterhoeven (1):
      [media] v4l: VIDEO_SH_VOU should depend on HAS_DMA

Georgi Chorbadzhiyski (1):
      [media] FE_READ_SNR and FE_READ_SIGNAL_STRENGTH docs

Gianluca Gennari (1):
      [media] drx39xyj: fix 64 bit division on 32 bit arch

Guennadi Liakhovetski (1):
      [media] MAINTAINERS: remove myself as a maintainer of VEU and VOU V4L2 drivers

Hans Verkuil (64):
      [media] usbtv: fix compiler error due to missing module.h
      [media] usbvision: drop unused define USBVISION_SAY_AND_WAIT
      [media] s3c-camif: Remove use of deprecated V4L2_CTRL_FLAG_DISABLED
      [media] v4l2-dv-timings.h: add new 4K DMT resolutions
      [media] v4l2-dv-timings: mention missing 'reduced blanking V2'
      [media] DocBook media: fix email addresses
      [media] DocBook media: update copyright years and Introduction
      [media] DocBook media: Cleanup some sections at common.xml
      [media] DocBook media: update three sections of common.xml
      [media] DocBook media: drop the old incorrect packed RGB table
      [media] DocBook media: add revision entry for 3.15
      [media] DocBook: partial rewrite of "Opening and Closing Devices"
      [media] radio-usb-si4713: make array of structs const
      [media] v4l2-subdev: Allow 32-bit compat ioctls
      [media] vivi: fix sequence counting
      [media] vivi: drop unused field
      [media] vivi: queue_setup improvements
      [media] radio-cadet: avoid interruptible_sleep_on race
      [media] v4l: do not allow modulator ioctls for non-radio devices
      [media] vb2: fix timecode and flags handling for output buffers
      [media] vb2: fix read/write regression
      [media] vb2: fix PREPARE_BUF regression
      [media] vb2: add debugging code to check for unbalanced ops
      [media] vb2: change result code of buf_finish to void
      [media] pwc: do not decompress the image unless the state is DONE
      [media] vb2: call buf_finish from __queue_cancel
      [media] vb2: consistent usage of periods in videobuf2-core.h
      [media] vb2: fix buf_init/buf_cleanup call sequences
      [media] vb2: rename queued_count to owned_by_drv_count
      [media] vb2: don't init the list if there are still buffers
      [media] vb2: only call start_streaming if sufficient buffers are queued
      [media] vb2: properly clean up PREPARED and QUEUED buffers
      [media] vb2: replace BUG by WARN_ON
      [media] vb2: fix streamoff handling if streamon wasn't called
      [media] vb2: call buf_finish after the state check
      [media] vivi: correctly cleanup after a start_streaming failure
      [media] vivi: fix ENUM_FRAMEINTERVALS implementation
      [media] v4l2-ctrls: replace BUG_ON by WARN_ON
      [media] media DocBook: fix NV16M description
      [media] v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32 support
      [media] v4l2: allow v4l2_subdev_edid to be used with video nodes
      [media] v4l2: add VIDIOC_G/S_EDID support to the v4l2 core
      [media] adv*: replace the deprecated v4l2_subdev_edid by v4l2_edid
      [media] DocBook v4l2: update the G/S_EDID documentation
      [media] mem2mem_testdev: use 40ms default transfer time
      [media] mem2mem_testdev: pick default format with try_fmt
      [media] mem2mem_testdev: set priv to 0
      [media] mem2mem_testdev: add USERPTR support
      [media] mem2mem_testdev: return pending buffers in stop_streaming()
      [media] mem2mem_testdev: fix field, sequence and time copying
      [media] mem2mem_testdev: improve field handling
      [media] DocBook media: update STREAMON/OFF documentation
      [media] DocBook: fix incorrect code example
      [media] DocBook media: clarify v4l2_buffer/plane fields
      [media] DocBook media: fix broken FIELD_ALTERNATE description
      [media] rtl2832_sdr: fixing v4l2-compliance issues
      [media] v4l2-pci-skeleton: add a V4L2 PCI skeleton driver
      [media] DocBook media: clarify v4l2_pix_format and v4l2_pix_format_mplane fields
      [media] DocBook media: v4l2_format_sdr was renamed to v4l2_sdr_format
      [media] si4713: fix Kconfig dependencies
      [media] saa6752hs: depends on CRC32
      [media] videodev2.h: add parenthesis around macro arguments
      [media] v4l2-dv-timings: add module name, description, license
      [media] saa7134: fix WARN_ON during resume

Hans de Goede (1):
      [media] gspca_topro: Add a couple of missing length check in the packet parsing code

Heinrich Schuchardt (1):
      [media] ds3000: fix reading array out of bound in ds3000_read_snr

James Hogan (27):
      [media] media: rc: only turn on LED if keypress generated
      [media] media: rc: document rc class sysfs API
      [media] media: rc: add Sharp infrared protocol
      [media] media: rc: add raw decoder for Sharp protocol
      [media] rc: ir-raw: Load ir-sharp-decoder module at init
      [media] media: rc: add sysfs scancode filtering interface
      [media] media: rc: change 32bit NEC scancode format
      [media] rc-main: store_filter: pass errors to userland
      [media] rc-main: add generic scancode filtering
      [media] rc: abstract access to allowed/enabled protocols
      [media] rc: add allowed/enabled wakeup protocol masks
      [media] rc: add wakeup_protocols sysfs file
      [media] rc-main: automatically refresh filter on protocol change
      [media] dt: binding: add binding for ImgTec IR block
      [media] rc: img-ir: add base driver
      [media] rc: img-ir: add raw driver
      [media] rc: img-ir: add hardware decoder driver
      [media] rc: img-ir: add to build
      [media] rc: img-ir: add NEC decoder module
      [media] rc: img-ir: add JVC decoder module
      [media] rc: img-ir: add Sony decoder module
      [media] rc: img-ir: add Sharp decoder module
      [media] rc: img-ir: add Sanyo decoder module
      [media] rc-main: fix missing unlock if no devno left
      [media] rc: img-ir: hw: Remove unnecessary semi-colon
      [media] rc: img-ir: jvc: Remove unused no-leader timings
      [media] rc: img-ir: hw: Fix min/max bits setup

Jan Vcelak (3):
      [media] rtl28xxu: add USB ID for Genius TVGo DVB-T03
      [media] rtl28xxu: add chipset version comments into device list
      [media] rtl28xxu: add USB ID for Genius TVGo DVB-T03

Joakim Hernberg (1):
      [media] cx23885: Fix tuning regression for TeVii S471

Jon Mason (1):
      [media] staging/dt3155v4l: use PCI_VENDOR_ID_INTEL

Joonyoung Shim (2):
      [media] s5p-mfc: Replaced commas with semicolons
      [media] au0828: fix i2c clock speed for DViCO FusionHDTV7

Kees Cook (1):
      [media] media: rc-core: use %s in rc_map_get() module load

Lad, Prabhakar (6):
      [media] mt9p031: Check return value of clk_prepare_enable/clk_set_rate
      [media] mt9v032: Check return value of clk_prepare_enable/clk_set_rate
      [media] omap3isp: Fix typos
      [media] omap3isp: ispccdc: Remove unwanted comments
      [media] omap3isp: Rename the variable names in description
      [media] media: davinci: vpbe: fix build warning

Lars-Peter Clausen (7):
      [media] adv7180: Fix remove order
      [media] adv7180: Free control handler on remove()
      [media] adv7180: Remove unnecessary v4l2_device_unregister_subdev() from probe error path
      [media] adv7180: Remove duplicated probe error message
      [media] adv7180: Use threaded IRQ instead of IRQ + workqueue
      [media] adv7180: Add support for async device registration
      [media] adv7180: Add support for power down

Laurent Pinchart (12):
      [media] omap3isp: Don't try to locate external subdev for mem-to-mem pipelines
      [media] omap3isp: Don't ignore failure to locate external subdev
      [media] ARM: omap2: cm-t35: Add regulators and clock for camera sensor
      [media] mt9t001: Add regulator support
      [media] mt9t001: Add clock support
      [media] mt9p031: Fix typo in comment
      [media] mt9p031: Add support for PLL bypass
      [media] uvcvideo: Remove duplicate check for number of buffers in queue_setup
      [media] uvcvideo: Support allocating buffers larger than the current frame size
      [media] v4l: of: Support empty port nodes
      [media] omap_vout: Add DVI display type support
      [media] v4l: vsp1: Update copyright notice

Levente Kurusa (1):
      [media] staging: davinci_vpfe: fix error check

Luis Alves (1):
      [media] rtl2832: Fix deadlock on i2c mux select function

Malcolm Priestley (9):
      [media] af9035: Move it913x single devices to af9035
      [media] af9035: add default 0x9135 slave I2C address
      [media] af9035: Add remaining it913x dual ids to af9035
      [media] it913x: dead code Remove driver
      [media] it913x-fe: Dead code remove driver
      [media] MAINTAINERS: Remove it913x* maintainers entries
      [media] get_dvb_firmware: it913x: Remove it9137 firmware files
      [media] m88rs2000: add caps FE_CAN_INVERSION_AUTO
      [media] m88rs2000: prevent frontend crash on continuous transponder scans

Marcus Folkesson (1):
      [media] media: i2c: Kconfig: create dependency to MEDIA_CONTROLLER for adv7*

Martin Bugge (7):
      [media] adv7842: adjust gain and offset for DVI-D signals
      [media] adv7842: pixelclock read-out
      [media] adv7842: log-status for Audio Video Info frames (AVI)
      [media] adv7842: platform-data for Hotplug Active (HPA) manual/auto
      [media] ths8200: Zero blanking level for RGB
      [media] ths8200: Corrected sync polarities setting
      [media] ths8200: Format adjustment

Masanari Iida (1):
      [media] DocBook: Fix typo in xml and template file

Mauro Carvalho Chehab (112):
      [media] DocBook/media_api: Better organize the DocBook
      [media] DocBook: Add a description for the Remote Controller interface
      [media, edac] Change my email address
      [media] em28xx_dvb: only call the software filter if data
      [media] em28xx: Display the used DVB alternate
      [media] dvb_frontend: better handle lna set errors
      [media] DocBook: document DVB DMX_[ADD|REMOVE]_PID
      [media] drx-j: CodingStyle fixes
      [media] drx-j: Fix compilation and un-comment it
      [media] drx-j: Fix CodingStyle
      [media] drx-j: get rid of the typedefs on bsp_i2c.h
      [media] drx-j: remove the "const" annotate on HICommand()
      [media] drx-j: get rid of the integer typedefs
      [media] drx-j: get rid of the other typedefs at bsp_types.h
      [media] drx-j: get rid of the bsp*.h headers
      [media] drx-j: get rid of most of the typedefs
      [media] drx-j: fix whitespacing on pointer parmameters
      [media] drx-j: Use checkpatch --fix to solve several issues
      [media] drx-j: Don't use CamelCase
      [media] drx-j: do more CodingStyle fixes
      [media] drx-j: remove the unused tuner_i2c_write_read() function
      [media] drx-j: Remove a bunch of unused but assigned vars
      [media] drx-j: Some minor CodingStyle fixes at headers
      [media] drx-j: make a few functions static
      [media] drx-j: Get rid of drx39xyj/bsp_tuner.h
      [media] drx-j: get rid of typedefs in drx_driver.h
      [media] drx-j: Get rid of typedefs on drxh.h
      [media] drx-j: a few more CodingStyle fixups
      [media] drx-j: Don't use buffer if an error occurs
      [media] drx-j: replace the ugly CHK_ERROR() macro
      [media] drx-j: don't use parenthesis on return
      [media] drx-j: Simplify logic expressions
      [media] drx-j: More CamelCase fixups
      [media] drx-j: Remove typedefs in drxj.c
      [media] drx-j: CodingStyle fixups on drxj.c
      [media] drx-j: Use the Linux error codes
      [media] drx-j: Replace printk's by pr_foo()
      [media] drx-j: get rid of some ugly macros
      [media] drx-j: remove typedefs at drx_driver.c
      [media] drx-j: remove drxj_options.h
      [media] drx-j: make checkpatch.pl happy
      [media] drx-j: remove the useless microcode_size
      [media] drx-j: Fix release and error path on drx39xxj.c
      [media] drx-j: Be sure that all allocated data are properly initialized
      [media] drx-j: dynamically load the firmware
      [media] drx-j: Split firmware size check from the main routine
      [media] em28xx: add support for PCTV 80e remote controller
      [media] drx-j: remove unused code from drx_driver.c
      [media] drx-j: get rid of its own be??_to_cpu() implementation
      [media] drx-j: reset the DVB scan configuration at powerup
      [media] drx-j: Allow standard selection
      [media] drx-j: Some cleanups at drx_driver.c source
      [media] drx-j: prepend function names with drx_ at drx_driver.c
      [media] drx-j: get rid of drx_driver.c
      [media] drx-j: Avoid any regressions by preserving old behavior
      [media] drx-j: Remove duplicated firmware upload code
      [media] drx-j: get rid of drx_ctrl
      [media] drx-j: get rid of the remaining drx generic functions
      [media] drx-j: move drx39xxj into drxj.c
      [media] drx-j: get rid of drxj_ctrl()
      [media] drx-j: comment or remove unused code
      [media] drx-j: remove some ugly bindings from drx39xxj_dummy.c
      [media] drx-j: get rid of tuner dummy get/set frequency
      [media] drx-j: be sure to use tuner's IF
      [media] drx-j: avoid calling power_down_foo twice
      [media] drx-j: call ctrl_set_standard even if a standard is powered
      [media] drx-j: use the proper timeout code on scu_command
      [media] drx-j: remove some unused data
      [media] drx-j: Fix qam/256 mode
      [media] drx-j: Get rid of I2C protocol version
      [media] drx-j: get rid of function prototypes at drx_dap_fasi.c
      [media] drx-j: get rid of drx_dap_fasi.c
      [media] drx-j: get rid of struct drx_dap_fasi_funct_g
      [media] drx-j: get rid of function wrappers
      [media] drx-j: Allow userspace control of LNA
      [media] drx-j: Use single master mode
      [media] drx-j: be sure to send the powerup command at device open
      [media] drx-j: be sure to do a full software reset
      [media] drx-j: disable OOB
      [media] drx-j: Properly initialize mpeg struct before using it
      [media] drx-j: set it to serial mode by default
      [media] em28xx: update CARDLIST.em28xx
      [media] Update CARDLIST.cx23885
      [media] tda18212: add support for ATSC and clearQAM on tda18272
      [media] em28xx: add support for Kworld UB435-Q version 3
      [media] em28xx: add support for DVB monitor led
      [media] em28xx: Add LED support for Kworld UB435-Q v3
      [media] DocBook: add Antti at the V4L2 revision list
      [media] DocBook: Fix a breakage at controls.xml
      Merge tag 'v3.14-rc5' into patchwork
      [media] em28xx: only enable PCTV 80e led when streaming
      [media] em28xx: Only deallocate struct em28xx after finishing all extensions
      [media] em28xx-dvb: remove one level of identation at fini callback
      [media] drx-j: Don't use 0 as NULL
      [media] drx-j: Fix dubious usage of "&" instead of "&&"
      [media] drx39xxj.h: Fix undefined reference to attach function
      [media] drx-j: don't use mc_info before checking if its not NULL
      [media] drx-j: get rid of dead code
      [media] drx-j: remove external symbols
      [media] drx-j: Fix usage of drxj_close()
      [media] drx-j: propagate returned error from request_firmware()
      [media] drx-j: get rid of some unused vars
      [media] drx-j: Don't use "state" for DVB lock state
      [media] drx-j: re-add get_sig_strength()
      [media] drx-j: Prepare to use DVBv5 stats
      [media] drx-j: properly handle bit counts on stats
      [media] drx-j: Fix detection of no signal
      [media] drx-j: enable DVBv5 stats
      drx-j: use ber_count var
      drx-j: Fix post-BER calculus on QAM modulation
      [media] af9033: Don't export functions for the hardware filter
      Revert "[media] em28xx-dvb: fix PCTV 461e tuner I2C binding"

Michael Opdenacker (1):
      [media] davinci: vpfe: remove deprecated IRQF_DISABLED

Ole Ernst (1):
      [media] dvb_frontend: Fix possible read out of bounds

Oleksij Rempel (1):
      [media] uvcvideo: Do not use usb_set_interface on bulk EP

Oliver Neukum (1):
      [media] uvcvideo: Simplify redundant check

Peter Meerwald (1):
      [media] omap3isp: Fix kerneldoc for _module_sync_is_stopping and isp_isr()

Phil Edworthy (1):
      [media] media: soc_camera: rcar_vin: Add support for 10-bit YUV cameras

Philipp Zabel (3):
      [media] uvcvideo: Enable VIDIOC_CREATE_BUFS
      [media] tvp5150: Fix type mismatch warning in clamp macro
      [media] tvp5150: Make debug module parameter visible in sysfs

Pojar George (1):
      [media] bttv: Add support for Kworld V-Stream Xpert TV PVR878

Ricardo Ribalda Delgado (1):
      [media] vb2: Check if there are buffers before streamon

Sachin Kamat (1):
      [media] radio-keene: Use module_usb_driver

Sakari Ailus (10):
      [media] v4l: Document timestamp behaviour to correspond to reality
      [media] v4l: Use full 32 bits for buffer flags
      [media] v4l: Rename vb2_queue.timestamp_type as timestamp_flags
      [media] v4l: Timestamp flags will soon contain timestamp source, not just type
      [media] v4l: Add timestamp source flags, mask and document them
      [media] v4l: Handle buffer timestamp flags correctly
      [media] uvcvideo: Tell the user space we're using start-of-exposure timestamps
      [media] exynos-gsc, m2m-deinterlace, mx2_emmaprp: Copy v4l2_buffer data from src to dst
      [media] v4l: Copy timestamp source flags to destination on m2m devices
      [media] v4l: Document timestamp buffer flag behaviour

Satoshi Nagahama (1):
      [media] Siano: smsusb - Add a device id for PX-S1UD

Sean Young (3):
      [media] iguanair: explain tx carrier setup
      [media] iguanair: simplify tx loop
      [media] mceusb: improve error logging

Seung-Woo Kim (1):
      [media] s5p-mfc: remove meaningless memory bank assignment

Shuah Khan (9):
      [media] em28xx: add suspend/resume to em28xx_ops
      [media] em28xx-audio: implement em28xx_ops: suspend/resume hooks
      [media] em28xx-dvb: implement em28xx_ops: suspend/resume hooks
      [media] em28xx-input: implement em28xx_ops: suspend/resume hooks
      [media] em28xx-video: implement em28xx_ops: suspend/resume hooks
      [media] em28xx: implement em28xx_usb_driver suspend, resume, reset_resume hooks
      [media] drx-j: fix pr_dbg undefined compile errors when DJH_DEBUG is defined
      [media] drx-j: remove return that prevents DJH_DEBUG code to run
      [media] drx-j: fix boot failure due to null pointer dereference

Thomas Pugliese (1):
      [media] uvcvideo: Update uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS devices

Till Dörges (1):
      [media] rtl28xxu: add ID [0ccd:00b4] TerraTec NOXON DAB Stick (rev 3)

Wolfram Sang (1):
      [media] media: gspca: sn9c20x: add ID for Genius Look 1320 V2

sensoray-dev (3):
      [media] s2255drv: checkpatch fix: coding style fix
      [media] s2255drv: upgrade to videobuf2
      [media] s2255drv: memory leak fix

 CREDITS                                            |     7 +
 Documentation/ABI/testing/sysfs-class-rc           |   111 +
 Documentation/DocBook/media/dvb/demux.xml          |    23 +-
 Documentation/DocBook/media/dvb/dvbapi.xml         |     4 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml    |     2 +-
 Documentation/DocBook/media/dvb/frontend.xml       |     8 +-
 Documentation/DocBook/media/v4l/common.xml         |   412 +-
 Documentation/DocBook/media/v4l/compat.xml         |    15 +-
 Documentation/DocBook/media/v4l/controls.xml       |   176 +
 Documentation/DocBook/media/v4l/dev-osd.xml        |    22 +-
 Documentation/DocBook/media/v4l/dev-sdr.xml        |   110 +
 Documentation/DocBook/media/v4l/io.xml             |   189 +-
 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml   |     9 +-
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |   513 +-
 .../DocBook/media/v4l/pixfmt-sdr-cu08.xml          |    44 +
 .../DocBook/media/v4l/pixfmt-sdr-cu16le.xml        |    46 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |    34 +-
 .../DocBook/media/v4l/remote_controllers.xml       |   143 +
 Documentation/DocBook/media/v4l/v4l2.xml           |    26 +-
 .../DocBook/media/v4l/vidioc-enum-freq-bands.xml   |     8 +-
 ...{vidioc-subdev-g-edid.xml => vidioc-g-edid.xml} |    36 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |     7 +-
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |     7 +
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |     5 +-
 .../DocBook/media/v4l/vidioc-g-modulator.xml       |     6 +-
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |    15 +-
 .../DocBook/media/v4l/vidioc-querycap.xml          |     6 +
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |     8 +-
 .../DocBook/media/v4l/vidioc-streamon.xml          |    28 +-
 Documentation/DocBook/media_api.tmpl               |    90 +-
 Documentation/devices.txt                          |     7 +
 .../devicetree/bindings/media/img-ir-rev1.txt      |    34 +
 Documentation/dvb/get_dvb_firmware                 |    22 +-
 Documentation/dvb/it9137.txt                       |     9 -
 Documentation/edac.txt                             |     2 +-
 Documentation/video4linux/CARDLIST.bttv            |     1 +
 Documentation/video4linux/CARDLIST.cx23885         |     5 +-
 Documentation/video4linux/CARDLIST.em28xx          |     6 +
 Documentation/video4linux/gspca.txt                |     1 +
 Documentation/video4linux/v4l2-framework.txt       |     5 +
 Documentation/video4linux/v4l2-pci-skeleton.c      |   913 ++
 MAINTAINERS                                        |    52 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |    16 +
 drivers/edac/edac_mc_sysfs.c                       |     2 +-
 drivers/edac/ghes_edac.c                           |     2 +-
 drivers/edac/i5400_edac.c                          |     4 +-
 drivers/edac/i7300_edac.c                          |     4 +-
 drivers/edac/i7core_edac.c                         |     4 +-
 drivers/edac/sb_edac.c                             |     4 +-
 drivers/hid/hid-picolcd_cir.c                      |     2 +-
 drivers/media/common/siano/smsdvb-debugfs.c        |     2 +-
 drivers/media/common/siano/smsir.c                 |     2 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |     1 +
 drivers/media/dvb-core/dvb_frontend.c              |    10 +-
 drivers/media/dvb-frontends/Kconfig                |    12 +-
 drivers/media/dvb-frontends/Makefile               |     2 +-
 drivers/media/dvb-frontends/af9033.c               |    59 +-
 drivers/media/dvb-frontends/af9033.h               |    34 +-
 drivers/media/dvb-frontends/drx39xyj/Kconfig       |     7 +
 drivers/media/dvb-frontends/drx39xyj/Makefile      |     6 +
 drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h     |   139 +
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h    |    45 +
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.h    |   256 +
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |  2343 +++
 .../dvb-frontends/drx39xyj/drx_driver_version.h    |    72 +
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 12400 +++++++++++++++
 drivers/media/dvb-frontends/drx39xyj/drxj.h        |   650 +
 drivers/media/dvb-frontends/drx39xyj/drxj_map.h    | 15055 +++++++++++++++++++
 drivers/media/dvb-frontends/drxd_hard.c            |     4 +-
 drivers/media/dvb-frontends/ds3000.c               |     2 +-
 drivers/media/dvb-frontends/it913x-fe-priv.h       |  1051 --
 drivers/media/dvb-frontends/it913x-fe.c            |  1045 --
 drivers/media/dvb-frontends/it913x-fe.h            |   237 -
 drivers/media/dvb-frontends/m88ds3103.c            |    30 +-
 drivers/media/dvb-frontends/m88rs2000.c            |    19 +-
 drivers/media/dvb-frontends/mb86a20s.c             |     4 +-
 drivers/media/dvb-frontends/mb86a20s.h             |     2 +-
 drivers/media/dvb-frontends/rtl2832.c              |   191 +-
 drivers/media/dvb-frontends/rtl2832.h              |    34 +-
 drivers/media/dvb-frontends/rtl2832_priv.h         |    54 +-
 drivers/media/dvb-frontends/s921.c                 |     4 +-
 drivers/media/dvb-frontends/s921.h                 |     2 +-
 drivers/media/dvb-frontends/stb6100.c              |     2 +-
 drivers/media/dvb-frontends/stv0900_sw.c           |     2 +-
 drivers/media/dvb-frontends/tda10071.c             |    68 +-
 drivers/media/dvb-frontends/tda10071.h             |     2 +-
 drivers/media/i2c/Kconfig                          |    16 +-
 drivers/media/i2c/Makefile                         |     1 +
 drivers/media/i2c/ad9389b.c                        |     2 +-
 drivers/media/i2c/adv7180.c                        |   118 +-
 drivers/media/i2c/adv7511.c                        |     2 +-
 drivers/media/i2c/adv7604.c                        |     4 +-
 drivers/media/i2c/adv7842.c                        |   153 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |     4 +-
 drivers/media/i2c/lm3560.c                         |    22 +-
 drivers/media/i2c/lm3646.c                         |   414 +
 drivers/media/i2c/mt9p031.c                        |    49 +-
 drivers/media/i2c/mt9t001.c                        |   229 +-
 drivers/media/i2c/mt9v011.c                        |     4 +-
 drivers/media/i2c/mt9v032.c                        |    10 +-
 drivers/media/i2c/sr030pc30.c                      |     2 +-
 drivers/media/i2c/ths8200.c                        |    26 +-
 drivers/media/i2c/tvp5150.c                        |     8 +-
 drivers/media/parport/bw-qcam.c                    |     8 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |    17 +-
 drivers/media/pci/bt8xx/bttv-input.c               |     1 +
 drivers/media/pci/bt8xx/bttv.h                     |     1 +
 drivers/media/pci/cx23885/cx23885-dvb.c            |     1 +
 drivers/media/pci/cx23885/cx23885-input.c          |     2 +-
 drivers/media/pci/cx88/cx88-input.c                |     2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |     6 +-
 drivers/media/pci/saa7134/saa7134-cards.c          |     4 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |     7 +-
 drivers/media/pci/ttpci/av7110_hw.c                |     2 +-
 drivers/media/platform/Kconfig                     |     2 +-
 drivers/media/platform/arv.c                       |     6 +-
 drivers/media/platform/blackfin/bfin_capture.c     |     2 +-
 drivers/media/platform/coda.c                      |     7 +-
 drivers/media/platform/davinci/vpbe_display.c      |     9 +-
 drivers/media/platform/davinci/vpif_capture.c      |     9 +-
 drivers/media/platform/davinci/vpif_display.c      |     9 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    12 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |     2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |     2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |     7 +-
 drivers/media/platform/m2m-deinterlace.c           |    11 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |     3 +-
 drivers/media/platform/mem2mem_testdev.c           |    95 +-
 drivers/media/platform/mx2_emmaprp.c               |    13 +-
 drivers/media/platform/omap/omap_vout.c            |     1 +
 drivers/media/platform/omap/omap_vout_vrfb.c       |     3 +-
 drivers/media/platform/omap3isp/isp.c              |     7 +-
 drivers/media/platform/omap3isp/isp.h              |    12 +-
 drivers/media/platform/omap3isp/ispccdc.c          |    10 +-
 drivers/media/platform/omap3isp/ispccdc.h          |     6 -
 drivers/media/platform/omap3isp/ispccp2.c          |     6 +-
 drivers/media/platform/omap3isp/isphist.c          |     4 +-
 drivers/media/platform/omap3isp/isppreview.c       |    22 +-
 drivers/media/platform/omap3isp/ispqueue.c         |     2 +-
 drivers/media/platform/omap3isp/ispresizer.c       |     6 +-
 drivers/media/platform/omap3isp/ispresizer.h       |     4 +-
 drivers/media/platform/omap3isp/ispstat.c          |     4 +-
 drivers/media/platform/omap3isp/ispvideo.c         |    12 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    17 +-
 drivers/media/platform/s5p-g2d/g2d.c               |     7 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |     7 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h       |     1 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    17 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |     2 +
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |     2 -
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    24 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |     8 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |     6 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |     2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |     2 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |     2 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |    11 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |     2 +-
 drivers/media/platform/ti-vpe/vpe.c                |     6 +-
 drivers/media/platform/vivi.c                      |    54 +-
 drivers/media/platform/vsp1/vsp1.h                 |     2 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |     2 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |     2 +-
 drivers/media/platform/vsp1/vsp1_entity.h          |     2 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |     2 +-
 drivers/media/platform/vsp1/vsp1_lif.h             |     2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |     2 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |     2 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |     2 +-
 drivers/media/platform/vsp1/vsp1_uds.c             |     2 +-
 drivers/media/platform/vsp1/vsp1_uds.h             |     2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |     4 +-
 drivers/media/platform/vsp1/vsp1_video.h           |     2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |     2 +-
 drivers/media/radio/radio-cadet.c                  |    46 +-
 drivers/media/radio/radio-keene.c                  |    19 +-
 drivers/media/radio/si4713/Kconfig                 |     6 +-
 drivers/media/radio/si4713/radio-usb-si4713.c      |     4 +-
 drivers/media/rc/Kconfig                           |    11 +
 drivers/media/rc/Makefile                          |     2 +
 drivers/media/rc/ati_remote.c                      |     2 +-
 drivers/media/rc/ene_ir.c                          |     2 +-
 drivers/media/rc/fintek-cir.c                      |     2 +-
 drivers/media/rc/gpio-ir-recv.c                    |     4 +-
 drivers/media/rc/iguanair.c                        |    31 +-
 drivers/media/rc/img-ir/Kconfig                    |    61 +
 drivers/media/rc/img-ir/Makefile                   |    11 +
 drivers/media/rc/img-ir/img-ir-core.c              |   176 +
 drivers/media/rc/img-ir/img-ir-hw.c                |  1053 ++
 drivers/media/rc/img-ir/img-ir-hw.h                |   269 +
 drivers/media/rc/img-ir/img-ir-jvc.c               |    81 +
 drivers/media/rc/img-ir/img-ir-nec.c               |   148 +
 drivers/media/rc/img-ir/img-ir-raw.c               |   151 +
 drivers/media/rc/img-ir/img-ir-raw.h               |    60 +
 drivers/media/rc/img-ir/img-ir-sanyo.c             |   122 +
 drivers/media/rc/img-ir/img-ir-sharp.c             |    99 +
 drivers/media/rc/img-ir/img-ir-sony.c              |   145 +
 drivers/media/rc/img-ir/img-ir.h                   |   166 +
 drivers/media/rc/imon.c                            |     7 +-
 drivers/media/rc/ir-jvc-decoder.c                  |     2 +-
 drivers/media/rc/ir-lirc-codec.c                   |     2 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |     2 +-
 drivers/media/rc/ir-nec-decoder.c                  |    11 +-
 drivers/media/rc/ir-raw.c                          |     5 +-
 drivers/media/rc/ir-rc5-decoder.c                  |    10 +-
 drivers/media/rc/ir-rc5-sz-decoder.c               |     4 +-
 drivers/media/rc/ir-rc6-decoder.c                  |     6 +-
 drivers/media/rc/ir-sanyo-decoder.c                |     6 +-
 drivers/media/rc/ir-sharp-decoder.c                |   200 +
 drivers/media/rc/ir-sony-decoder.c                 |    10 +-
 drivers/media/rc/ite-cir.c                         |     2 +-
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |     4 +-
 drivers/media/rc/keymaps/rc-apac-viewcomp.c        |     4 +-
 drivers/media/rc/keymaps/rc-asus-pc39.c            |     4 +-
 drivers/media/rc/keymaps/rc-asus-ps3-100.c         |     4 +-
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c |     4 +-
 drivers/media/rc/keymaps/rc-avermedia-a16d.c       |     4 +-
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |     4 +-
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |     4 +-
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |     4 +-
 .../media/rc/keymaps/rc-avermedia-m733a-rm-k6.c    |     2 +-
 drivers/media/rc/keymaps/rc-avermedia.c            |     4 +-
 drivers/media/rc/keymaps/rc-avertv-303.c           |     4 +-
 drivers/media/rc/keymaps/rc-behold-columbus.c      |     4 +-
 drivers/media/rc/keymaps/rc-behold.c               |     4 +-
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |     4 +-
 drivers/media/rc/keymaps/rc-cinergy-1400.c         |     4 +-
 drivers/media/rc/keymaps/rc-cinergy.c              |     4 +-
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |     4 +-
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          |     4 +-
 drivers/media/rc/keymaps/rc-dm1105-nec.c           |     4 +-
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |     4 +-
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c   |     4 +-
 drivers/media/rc/keymaps/rc-em-terratec.c          |     4 +-
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c    |     4 +-
 drivers/media/rc/keymaps/rc-encore-enltv.c         |     4 +-
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |     4 +-
 drivers/media/rc/keymaps/rc-evga-indtube.c         |     4 +-
 drivers/media/rc/keymaps/rc-eztv.c                 |     4 +-
 drivers/media/rc/keymaps/rc-flydvb.c               |     4 +-
 drivers/media/rc/keymaps/rc-flyvideo.c             |     4 +-
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c       |     4 +-
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c        |     4 +-
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c   |     4 +-
 drivers/media/rc/keymaps/rc-gotview7135.c          |     4 +-
 drivers/media/rc/keymaps/rc-hauppauge.c            |     4 +-
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c        |     4 +-
 drivers/media/rc/keymaps/rc-kaiomy.c               |     4 +-
 drivers/media/rc/keymaps/rc-kworld-315u.c          |     4 +-
 drivers/media/rc/keymaps/rc-kworld-pc150u.c        |     2 +-
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |     4 +-
 drivers/media/rc/keymaps/rc-manli.c                |     4 +-
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |     4 +-
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c       |     4 +-
 drivers/media/rc/keymaps/rc-nebula.c               |     4 +-
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |     6 +-
 drivers/media/rc/keymaps/rc-norwood.c              |     4 +-
 drivers/media/rc/keymaps/rc-npgtech.c              |     4 +-
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |     4 +-
 drivers/media/rc/keymaps/rc-pinnacle-color.c       |     4 +-
 drivers/media/rc/keymaps/rc-pinnacle-grey.c        |     4 +-
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     |     4 +-
 drivers/media/rc/keymaps/rc-pixelview-002t.c       |     4 +-
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |     4 +-
 drivers/media/rc/keymaps/rc-pixelview-new.c        |     4 +-
 drivers/media/rc/keymaps/rc-pixelview.c            |     4 +-
 .../media/rc/keymaps/rc-powercolor-real-angel.c    |     4 +-
 drivers/media/rc/keymaps/rc-proteus-2309.c         |     4 +-
 drivers/media/rc/keymaps/rc-purpletv.c             |     4 +-
 drivers/media/rc/keymaps/rc-pv951.c                |     4 +-
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |     4 +-
 drivers/media/rc/keymaps/rc-tbs-nec.c              |     4 +-
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c  |     4 +-
 drivers/media/rc/keymaps/rc-tevii-nec.c            |     4 +-
 drivers/media/rc/keymaps/rc-tivo.c                 |    86 +-
 drivers/media/rc/keymaps/rc-tt-1500.c              |     4 +-
 drivers/media/rc/keymaps/rc-videomate-s350.c       |     4 +-
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c     |     4 +-
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c |     4 +-
 drivers/media/rc/keymaps/rc-winfast.c              |     4 +-
 drivers/media/rc/mceusb.c                          |   184 +-
 drivers/media/rc/nuvoton-cir.c                     |    12 +-
 drivers/media/rc/nuvoton-cir.h                     |     1 -
 drivers/media/rc/rc-core-priv.h                    |    15 +-
 drivers/media/rc/rc-loopback.c                     |     2 +-
 drivers/media/rc/rc-main.c                         |   253 +-
 drivers/media/rc/redrat3.c                         |     2 +-
 drivers/media/rc/st_rc.c                           |     2 +-
 drivers/media/rc/streamzap.c                       |     2 +-
 drivers/media/rc/ttusbir.c                         |     2 +-
 drivers/media/rc/winbond-cir.c                     |     2 +-
 drivers/media/tuners/Kconfig                       |     1 +
 drivers/media/tuners/e4000.c                       |   608 +-
 drivers/media/tuners/e4000.h                       |    21 +-
 drivers/media/tuners/e4000_priv.h                  |    88 +-
 drivers/media/tuners/mt2063.c                      |     4 +-
 drivers/media/tuners/r820t.c                       |     4 +-
 drivers/media/tuners/tda18212.c                    |    12 +
 drivers/media/tuners/tda18212.h                    |     2 +
 drivers/media/tuners/tuner-xc2028.c                |     3 +
 drivers/media/usb/au0828/au0828-cards.c            |    23 +-
 drivers/media/usb/cx231xx/cx231xx-input.c          |     2 +-
 drivers/media/usb/dvb-usb-v2/Kconfig               |     9 +-
 drivers/media/usb/dvb-usb-v2/Makefile              |     4 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |   102 +-
 drivers/media/usb/dvb-usb-v2/af9035.h              |     2 +
 drivers/media/usb/dvb-usb-v2/az6007.c              |     4 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |     2 +-
 drivers/media/usb/dvb-usb-v2/it913x.c              |   828 -
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   123 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h            |     2 +
 drivers/media/usb/dvb-usb/dvb-usb-remote.c         |     2 +-
 drivers/media/usb/em28xx/Kconfig                   |     2 +
 drivers/media/usb/em28xx/em28xx-audio.c            |   103 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |     4 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   129 +-
 drivers/media/usb/em28xx/em28xx-core.c             |    54 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   193 +-
 drivers/media/usb/em28xx/em28xx-i2c.c              |    41 +-
 drivers/media/usb/em28xx/em28xx-input.c            |    55 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    56 +-
 drivers/media/usb/em28xx/em28xx.h                  |    15 +-
 drivers/media/usb/gspca/kinect.c                   |     7 +-
 drivers/media/usb/gspca/sn9c20x.c                  |     1 +
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c   |     2 +-
 drivers/media/usb/gspca/topro.c                    |    10 +-
 drivers/media/usb/pwc/pwc-if.c                     |    19 +-
 drivers/media/usb/s2255/Kconfig                    |     2 +-
 drivers/media/usb/s2255/s2255drv.c                 |  1271 +-
 drivers/media/usb/siano/smsusb.c                   |     2 +
 drivers/media/usb/stk1160/stk1160-v4l.c            |     2 +-
 drivers/media/usb/tm6000/tm6000-alsa.c             |     4 +-
 drivers/media/usb/tm6000/tm6000-dvb.c              |     2 +-
 drivers/media/usb/tm6000/tm6000-input.c            |     2 +-
 drivers/media/usb/tm6000/tm6000-stds.c             |     2 +-
 drivers/media/usb/usbtv/Makefile                   |     3 +
 drivers/media/usb/usbtv/usbtv-core.c               |   134 +
 drivers/media/usb/usbtv/{usbtv.c => usbtv-video.c} |   171 +-
 drivers/media/usb/usbtv/usbtv.h                    |    99 +
 drivers/media/usb/usbvision/usbvision.h            |     8 -
 drivers/media/usb/uvc/uvc_driver.c                 |    24 +-
 drivers/media/usb/uvc/uvc_queue.c                  |    29 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |    11 +
 drivers/media/usb/uvc/uvc_video.c                  |    23 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    16 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   133 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |    33 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |    32 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |     8 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |    91 +-
 drivers/media/v4l2-core/v4l2-of.c                  |    52 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |    18 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   658 +-
 drivers/staging/media/Kconfig                      |     2 +
 drivers/staging/media/Makefile                     |     2 +
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |     2 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |     6 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |     3 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |     5 +-
 drivers/staging/media/go7007/go7007-v4l2.c         |     5 +-
 drivers/staging/media/msi3101/Kconfig              |     7 +-
 drivers/staging/media/msi3101/Makefile             |     1 +
 drivers/staging/media/msi3101/msi001.c             |   500 +
 drivers/staging/media/msi3101/sdr-msi3101.c        |  1566 +-
 drivers/staging/media/omap4iss/iss_video.c         |     2 +-
 drivers/staging/media/rtl2832u_sdr/Kconfig         |     7 +
 drivers/staging/media/rtl2832u_sdr/Makefile        |     6 +
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c   |  1500 ++
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h   |    54 +
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |     2 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2.c     |     2 +-
 include/media/adv7842.h                            |     3 +
 include/media/lm3646.h                             |    87 +
 include/media/rc-core.h                            |    80 +-
 include/media/rc-map.h                             |     6 +-
 include/media/v4l2-dev.h                           |     3 +-
 include/media/v4l2-ioctl.h                         |    10 +
 include/media/v4l2-subdev.h                        |     9 +-
 include/media/videobuf2-core.h                     |   117 +-
 include/trace/events/v4l2.h                        |     1 +
 include/uapi/linux/v4l2-common.h                   |     8 +
 include/uapi/linux/v4l2-controls.h                 |    19 +
 include/uapi/linux/v4l2-dv-timings.h               |    17 +
 include/uapi/linux/v4l2-subdev.h                   |    14 +-
 include/uapi/linux/videodev2.h                     |    74 +-
 385 files changed, 44004 insertions(+), 7910 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-rc
 create mode 100644 Documentation/DocBook/media/v4l/dev-sdr.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml
 rename Documentation/DocBook/media/v4l/{vidioc-subdev-g-edid.xml => vidioc-g-edid.xml} (77%)
 create mode 100644 Documentation/devicetree/bindings/media/img-ir-rev1.txt
 delete mode 100644 Documentation/dvb/it9137.txt
 create mode 100644 Documentation/video4linux/v4l2-pci-skeleton.c
 create mode 100644 drivers/media/dvb-frontends/drx39xyj/Kconfig
 create mode 100644 drivers/media/dvb-frontends/drx39xyj/Makefile
 create mode 100644 drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
 create mode 100644 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
 create mode 100644 drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
 create mode 100644 drivers/media/dvb-frontends/drx39xyj/drx_driver.h
 create mode 100644 drivers/media/dvb-frontends/drx39xyj/drx_driver_version.h
 create mode 100644 drivers/media/dvb-frontends/drx39xyj/drxj.c
 create mode 100644 drivers/media/dvb-frontends/drx39xyj/drxj.h
 create mode 100644 drivers/media/dvb-frontends/drx39xyj/drxj_map.h
 delete mode 100644 drivers/media/dvb-frontends/it913x-fe-priv.h
 delete mode 100644 drivers/media/dvb-frontends/it913x-fe.c
 delete mode 100644 drivers/media/dvb-frontends/it913x-fe.h
 create mode 100644 drivers/media/i2c/lm3646.c
 create mode 100644 drivers/media/rc/img-ir/Kconfig
 create mode 100644 drivers/media/rc/img-ir/Makefile
 create mode 100644 drivers/media/rc/img-ir/img-ir-core.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-hw.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-hw.h
 create mode 100644 drivers/media/rc/img-ir/img-ir-jvc.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-nec.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-raw.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-raw.h
 create mode 100644 drivers/media/rc/img-ir/img-ir-sanyo.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-sharp.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-sony.c
 create mode 100644 drivers/media/rc/img-ir/img-ir.h
 create mode 100644 drivers/media/rc/ir-sharp-decoder.c
 delete mode 100644 drivers/media/usb/dvb-usb-v2/it913x.c
 create mode 100644 drivers/media/usb/usbtv/usbtv-core.c
 rename drivers/media/usb/usbtv/{usbtv.c => usbtv-video.c} (81%)
 create mode 100644 drivers/media/usb/usbtv/usbtv.h
 create mode 100644 drivers/staging/media/msi3101/msi001.c
 create mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
 create mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile
 create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
 create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h
 create mode 100644 include/media/lm3646.h



-- 

Regards,
Mauro
