Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632Ab3D3NCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:02:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760220Ab3D3NCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:02:25 -0400
Date: Tue, 30 Apr 2013 10:02:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.10-rc1] media updates
Message-ID: <20130430100209.00b23cbd@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For the media stuff for 3.10, with includes:

	- OF documentation and patches at core and drivers, to be used by
	  for embedded media systems;
	- some I2C drivers used on go7007 were rewritten/promoted from staging:
	  sony-btf-mpx, tw2804, tw9903, tw9906, wis-ov7640, wis-uda1342;
	- add fimc-is driver (Exynos);
	- add a new radio driver: radio-si476x;
	- add a two new tuners r820t and tuner_it913x;
	- split camera code on em28xx driver and add more models;
	- the cypress firmware load is used outside dvb usb drivers. So,
	  move it to a common directory to make easier to re-use it;
	- siano media driver updated to work with sms2270 devices;
	- several work done in order to promote go7007 and solo6x1x out of
	  staging (still, there are some pending issues);
	- several API compliance fixes at v4l2 drivers that don't behave as
	  expected;
	- as usual, lots of driver fixes, improvements, cleanups and new
	  device addition at the existing drivers.

Regards,
Mauro

-

The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:

  Linux 3.9 (2013-04-28 17:36:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to df90e2258950fd631cdbf322c1ee1f22068391aa:

  Merge branch 'devel-for-v3.10' into v4l_for_linus (2013-04-30 09:01:04 -0300)

----------------------------------------------------------------

Alexander Shiyan (1):
      [media] staging: lirc_sir: remove dead code

Alexandru Gheorghiu (1):
      [media] Drivers: staging: media: davinci_vpfe: Use resource_size function

Alexey Khoroshilov (2):
      [media] stv090x: do not unlock unheld mutex in stv090x_sleep()
      [media] cx88: Fix unsafe locking in suspend-resume

Alexey Klimov (1):
      [media] radio-mr800: move clamp_t check inside amradio_set_freq()

Andrei Andreyanau (1):
      [media] mt9v022 driver: send valid HORIZONTAL_BLANKING values to mt9v024 soc camera

Andrey Pavlenko (1):
      [media] [1/1,dvb-usb] GOTVIEW SatelliteHD card support

Andrey Smirnov (10):
      [media] mfd: Add commands abstraction layer for SI476X MFD
      [media] mfd: Add the main bulk of core driver for SI476x code
      [media] mfd: Add chip properties handling code for SI476X MFD
      [media] mfd: Add header files and Kbuild plumbing for SI476x MFD core
      [media] v4l2: Fix the type of V4L2_CID_TUNE_PREEMPHASIS in the documentation
      [media] v4l2: Add standard controls for FM receivers
      [media] v4l2: Add documentation for the FM RX controls
      [media] v4l2: Add private controls base for SI476X
      [media] v4l2: Add a V4L2 driver for SI476X MFD
      [media] v4l2: Add a V4L2 driver for SI476X MFD

Andrzej Hajda (1):
      [media] s5p-fimc: Add error checks for pipeline stream on callbacks

Andy Walls (1):
      [media] v4l2-ctrls: eliminate lockdep false alarms for struct v4l2_ctrl_handler.lock

Antti Palosaari (57):
      [media] dvb_usb_v2: locked versions of USB bulk IO functions
      [media] af9015: do not use buffers from stack for usb_bulk_msg()
      [media] af9035: do not use buffers from stack for usb_bulk_msg()
      [media] anysee: do not use buffers from stack for usb_bulk_msg()
      [media] anysee: coding style changes
      [media] ITE IT913X silicon tuner driver
      [media] af9033: support for it913x tuners
      [media] af9035: add support for 1st gen it9135
      [media] af9035: add auto configuration heuristic for it9135
      [media] af9035: fix af9033 demod sampling frequency
      [media] af9015: reject device TerraTec Cinergy T Stick Dual RC (rev. 2)
      [media] af9035: [0ccd:0099] TerraTec Cinergy T Stick Dual RC (rev. 2)
      [media] af9035: constify clock tables
      [media] af9035: USB1.1 support (== PID filters)
      [media] af9035: merge af9035 and it9135 eeprom read routines
      [media] af9035: basic support for IT9135 v2 chips
      [media] af9033: IT9135 v2 supported related changes
      [media] af9035: IT9135 dual tuner related changes
      [media] it913x: merge it913x_fe_start() to it913x_init_tuner()
      [media] it913x: merge it913x_fe_suspend() to it913x_fe_sleep()
      [media] it913x: rename functions and variables
      [media] it913x: tuner power up routines
      [media] it913x: get rid of it913x config struct
      [media] it913x: remove unused variables
      [media] it913x: include tuner IDs from af9033.h
      [media] it913x: use dev_foo() logging
      [media] af9033: add IT9135 demod reg init tables
      [media] it913x: remove demod init reg tables
      [media] af9035: select firmware loader according to firmware
      [media] af9035: use already detected eeprom base addr
      [media] af9035: set demod TS mode config in read_config()
      [media] af9035: enable remote controller for IT9135 too
      [media] af9035: change dual mode boolean to bit field
      [media] af9033: add IT9135 tuner config "38" init table
      [media] af9033: add IT9135 tuner config "51" init table
      [media] af9033: add IT9135 tuner config "52" init table
      [media] af9033: add IT9135 tuner config "60" init table
      [media] af9033: add IT9135 tuner config "61" init table
      [media] af9033: add IT9135 tuner config "62" init table
      [media] it913x: remove unused af9033 demod tuner config inits
      [media] af9033: move code from it913x to af9033
      [media] af9033: sleep on attach()
      [media] af9033: implement i/o optimized reg table writer
      [media] af9035: check I/O errors on IR polling
      [media] af9035: style changes for remote controller polling
      [media] MAINTAINERS: add drivers/media/tuners/it913x*
      [media] dvb_usb_v2: replace Kernel userspace lock with wait queue
      [media] dvb_usb_v2: make checkpatch.pl happy
      [media] cypress_firmware: make checkpatch.pl happy
      [media] dvb_usb_v2: rework USB streaming logic
      [media] it913x: fix pid filter
      [media] MAINTAINERS: update CYPRESS_FIRMWARE media driver
      [media] MAINTAINERS: add DVB_USB_GL861
      [media] MAINTAINERS: add RTL2832 media driver
      [media] rc: add rc-reddo
      [media] em28xx: map remote for 1b80:e425
      [media] rc: fix single line indentation of keymaps/Makefile

Arnd Bergmann (1):
      [media] exynos: remove unnecessary header inclusions

Benoît Thébaudeau (1):
      [media] soc-camera: mt9m111: Fix auto-exposure control

Cesar Eduardo Barros (3):
      [media] MAINTAINERS: fix drivers/media/i2c/cx2341x.c
      [media] MAINTAINERS: fix Documentation/video4linux/saa7134/
      [media] MAINTAINERS: remove include/media/sh_veu.h

Chen Gang (3):
      [media] drivers/staging/media/as102: using ccflags-y instead of EXTRA_FLAGS in Makefile
      [media] drivers/staging/media/go7007: using strlcpy instead of strncpy
      [media] go7007: using strlcpy instead of strncpy

Dan Carpenter (5):
      [media] lg2160: dubious one-bit signed bitfield
      [media] go7007: dubious one-bit signed bitfields
      [media] media: info leak in media_device_enum_entities()
      [media] r820t: precendence bug in r820t_xtal_check()
      [media] r820t: memory leak in release()

David Howells (1):
      [media] zoran: Don't print proc_dir_entry data in debug [RFC]

David Härdeman (3):
      [media] rc-core: initialize rc-core earlier if built-in
      [media] rc-core: rename ir_input_class to rc_class
      [media] rc-core: don't treat dev->rc_map.rc_type as a bitmap

Dmitri Belimov (1):
      [media] xc5000: fix incorrect debug printnk

Dmitry Torokhov (1):
      [media] Media: remove incorrect __init/__exit markups

Eduardo Valentin (5):
      [media] MAINTAINERS: Add maintainer entry for si4713 FM transmitter driver
      [media] media: radio: CodingStyle changes on si4713
      [media] media: radio: correct module license (==> GPL v2)
      [media] media: radio: add driver owner entry for radio-si4713
      [media] media: radio: add module alias entry for radio-si4713

Evgeny Plehov (1):
      [media] cxd2820r_t2: Multistream support (MultiPLP)

Fabio Porcedda (2):
      [media] drivers: media: use module_platform_driver_probe()
      [media] mx2_camera: use module_platform_driver_probe()

Fabrizio Gazzato (2):
      [media] rtl28xxu: Add USB ID for MaxMedia HU394-T
      [media] af9035: add ID [0ccd:00aa] TerraTec Cinergy T Stick (rev. 2)

Federico Fuga (1):
      [media] Corrected Oops on omap_vout when no manager is connected

Fengguang Wu (1):
      [media] r820t: quiet gcc warning on n_ring

Frank Schaefer (67):
      [media] em28xx: use v4l2_disable_ioctl() to disable ioctls VIDIOC_QUERYSTD, VIDIOC_G/S_STD
      [media] em28xx: disable tuner related ioctls for video and VBI devices without tuner
      [media] em28xx: use v4l2_disable_ioctl() to disable ioctls VIDIOC_G_AUDIO and VIDIOC_S_AUDIO
      [media] em28xx: use v4l2_disable_ioctl() to disable ioctl VIDIOC_S_PARM
      [media] em28xx: disable ioctl VIDIOC_S_PARM for VBI devices
      [media] em28xx: make ioctls VIDIOC_G/S_PARM working for VBI devices
      [media] em28xx: remove ioctl VIDIOC_CROPCAP
      [media] em28xx: get rid of duplicate function vidioc_s_fmt_vbi_cap()
      [media] em28xx: VIDIOC_G_TUNER: remove unneeded setting of tuner type
      [media] em28xx: remove obsolete device state checks from the ioctl functions
      [media] em28xx: make ioctl VIDIOC_DBG_G_CHIP_IDENT available without CONFIG_VIDEO_ADV_DEBUG selected
      [media] em28xx: make ioctl VIDIOC_DBG_G_CHIP_IDENT available for radio devices
      [media] em28xx: do not claim VBI support if the device is a camera
      [media] em28xx: introduce #define for maximum supported scaling values (register 0x30-0x33)
      [media] em28xx: rename function get_scale() to size_to_scale()
      [media] em28xx: add function scale_to_size()
      [media] em28xx: VIDIOC_ENUM_FRAMESIZES: consider the scaler limits when calculating the minimum frame size
      [media] em28xx: remove unused image quality control functions
      [media] em28xx: remove unused ac97 v4l2_ctrl_handler
      [media] em28xx: introduce #defines for the image quality default settings
      [media] em28xx: add image quality bridge controls
      [media] em28xx: remove some obsolete function declarations
      [media] em28xx: fix spacing and some comments in em28xx.h
      [media] em28xx: bump driver version to 0.2.0
      [media] em28xx-i2c: get rid of the dprintk2 macro
      [media] em28xx-i2c: replace printk() with the corresponding em28xx macros
      [media] em28xx-i2c: also print debug messages at debug level 1
      [media] em28xx: do not interpret eeprom content if eeprom key is invalid
      [media] em28xx: fix eeprom data endianess
      [media] em28xx: add basic support for eeproms with 16 bit address width
      [media] em28xx: add helper function for reading data blocks from i2c clients
      [media] em28xx: do not store eeprom content permanently
      [media] em28xx: extract the device configuration dataset from eeproms with 16 bit address width
      [media] em28xx: enable tveeprom for device Hauppauge HVR-930C
      [media] bttv: make remote controls of devices with i2c ir decoder working
      [media] bttv: move fini_bttv_i2c() from bttv-input.c to bttv-i2c.c
      [media] em28xx: set the timestamp type for video and vbi vb2_queues
      [media] em28xx-i2c: relax error check in em28xx_i2c_recv_bytes()
      [media] bttv: audio_mux(): use a local variable "gpio_mute" instead of modifying the function parameter "mute"
      [media] bttv: audio_mux(): do not change the value of the v4l2 mute control
      [media] bttv: do not save the audio input in audio_mux()
      [media] bttv: rename field 'audio' in struct 'bttv' to 'audio_input'
      [media] bttv: separate GPIO part from function audio_mux()
      [media] bttv: untangle audio input and mute setting
      [media] bttv: do not unmute the device before the first open
      [media] bttv: apply mute settings on open
      [media] em28xx-i2c: do not break strings across lines
      [media] em28xx-i2c: fix coding style of multi line comments
      [media] em28xx: add support for em25xx i2c bus B read/write/check device operations
      [media] em28xx: add chip id of the em2765
      [media] em28xx: add support for em25xx/em276x/em277x/em278x frame data processing
      [media] em28xx: make em28xx_set_outfmt() working with EM25xx family bridges
      [media] em28xx: write output frame resolution to regs 0x34+0x35 for em25xx family bridges
      [media] em28xx: ignore isoc DVB USB endpoints with wMaxPacketSize = 0 bytes for all alt settings
      [media] em28xx: fix and separate the board hints for sensor devices
      [media] em28xx: separate sensor detection and initialization/configuration
      [media] em28xx: rename em28xx_hint_sensor() to em28xx_detect_sensor()
      [media] em28xx: move sensor code to a separate source code file em28xx-camera.c
      [media] em28xx: detect further Micron sensors
      [media] em28xx: move the probing of Micron sensors to a separate function
      [media] em28xx: add probing procedure for OmniVision sensors
      [media] em28xx: add comment about Samsung and Kodak sensor probing addresses
      [media] em28xx: add basic support for OmniVision OV2640 sensors
      [media] em28xx: fix snapshot button support
      [media] em28xx: improve em2710/em2820 distinction
      [media] em28xx: add a missing le16_to_cpu conversion
      [media] em28xx: save isoc endpoint number for DVB only if endpoint has alt settings with xMaxPacketSize != 0

Geert Uytterhoeven (3):
      [media] media/v4l2: VIDEOBUF2_DMA_CONTIG should depend on HAS_DMA
      [media] anysee: Initialize ret = 0 in anysee_frontend_attach()
      [media] anysee: Grammar s/report the/report to/

Gianluca Gennari (2):
      [media] cx231xx: fix undefined function cx231xx_g_chip_ident()
      [media] s5c73m3: fix indentation of the help section in Kconfig

Guennadi Liakhovetski (6):
      [media] mt9m111: fix Oops - initialise context before dereferencing
      [media] Add common video interfaces OF bindings documentation
      [media] Add a V4L2 OF parser
      [media] soc-camera: protect against racing open(2) and rmmod
      [media] soc-camera: fix typos in the default format-conversion table
      [media] DT: export of_get_next_parent() for use by modules: fix modular V4L2

Hans Verkuil (286):
      [media] tlg2300: use correct device parent
      [media] tlg2300: fix tuner and frequency handling of the radio device
      [media] tlg2300: switch to unlocked_ioctl
      [media] tlg2300: remove ioctls that are invalid for radio devices
      [media] tlg2300: embed video_device instead of allocating it
      [media] tlg2300: add control handler for radio device node
      [media] tlg2300: switch to v4l2_fh
      [media] tlg2300: fix radio querycap
      [media] tlg2300: add missing video_unregister_device
      [media] tlg2300: embed video_device
      [media] tlg2300: fix querycap
      [media] tlg2300: fix frequency handling
      [media] tlg2300: fix missing audioset
      [media] tlg2300: implement the control framework
      [media] tlg2300: remove empty vidioc_try_fmt_vid_cap, add missing g_std
      [media] tlg2300: allow multiple opens
      [media] tlg2300: Remove logs() macro
      [media] tlg2300: update MAINTAINERS file
      [media] bttv: fix querycap and radio v4l2-compliance issues
      [media] bttv: add VIDIOC_DBG_G_CHIP_IDENT
      [media] bttv: fix ENUM_INPUT and S_INPUT
      [media] bttv: disable g/s_tuner and g/s_freq when no tuner present, fix return codes
      [media] bttv: set initial tv/radio frequencies
      [media] bttv: G_PARM: set readbuffers
      [media] bttv: fill in colorspace
      [media] bttv: fill in fb->flags for VIDIOC_G_FBUF
      [media] bttv: fix field handling inside TRY_FMT
      [media] tda7432: convert to the control framework
      [media] bttv: convert to the control framework
      [media] bttv: add support for control events
      [media] bttv: fix priority handling
      [media] bttv: use centralized std and implement g_std
      [media] bttv: there may be multiple tvaudio/tda7432 devices
      [media] bttv: fix g_tuner capabilities override
      [media] bttv: fix try_fmt_vid_overlay and setup initial overlay size
      [media] bttv: do not switch to the radio tuner unless it is accessed
      [media] bttv: remove g/s_audio since there is only one audio input
      [media] cx231xx: add device_caps support to QUERYCAP
      [media] cx231xx: add required VIDIOC_DBG_G_CHIP_IDENT support
      [media] cx231xx: clean up radio support
      [media] cx231xx: remove broken audio input support from the driver
      [media] cx231xx: fix tuner compliance issues
      [media] cx231xx: zero priv field and use right width in try_fmt
      [media] cx231xx: fix frequency clamping
      [media] cx231xx: fix vbi compliance issues
      [media] cx231xx: convert to the control framework
      [media] cx231xx: add struct v4l2_fh to get prio and event support
      [media] cx231xx: remove current_norm usage
      [media] cx231xx: replace ioctl by unlocked_ioctl
      [media] cx231xx: get rid of a bunch of unused cx231xx_fh fields
      [media] cx231xx: improve std handling
      [media] cx231xx-417: remove empty functions
      [media] cx231xx-417: use one querycap for all device nodes
      [media] cx231xx-417: fix g/try_fmt compliance problems
      [media] cx231xx-417: checkpatch cleanups
      [media] cx231xx-417: share ioctls with cx231xx-video
      [media] cx231xx-417: convert to the control framework
      [media] cx231xx: remove bogus driver prefix in log messages
      [media] cx231xx: disable 417 support from the Conexant video grabber
      [media] cx231xx: don't reset width/height on first open
      [media] cx231xx: don't use port 3 on the Conexant video grabber
      [media] cx231xx: fix big-endian problems
      [media] cx231xx: fix gpio big-endian problems
      [media] stk-webcam: add ASUS F3JC to upside-down list
      [media] stk-webcam: remove bogus STD support
      [media] stk-webcam: add support for struct v4l2_device
      [media] stk-webcam: convert to the control framework
      [media] stk-webcam: don't use private_data, use video_drvdata
      [media] stk-webcam: add support for control events and prio handling
      [media] stk-webcam: fix querycap and simplify s_input
      [media] stk-webcam: zero the priv field of v4l2_pix_format
      [media] stk-webcam: enable core-locking
      [media] stk-webcam: fix read() handling when reqbufs was already called
      [media] stk-webcam: s_fmt shouldn't grab ownership
      [media] stk-webcam: implement support for count == 0 when calling REQBUFS
      [media] gspca_sonixj: Convert to the control framework
      [media] gspca_sonixb: Remove querymenu function (dead code)
      [media] radio-isa: fix querycap capabilities code
      [media] radio-rtrack2: fix mute bug
      [media] s2255: convert to the control framework
      [media] s2255: add V4L2_CID_JPEG_COMPRESSION_QUALITY
      [media] s2255: add support for control events and prio handling
      [media] s2255: add device_caps support to querycap
      [media] s2255: fixes in the way standards are handled
      [media] s2255: zero priv and set colorspace
      [media] s2255: fix field handling
      [media] s2255: don't zero struct v4l2_streamparm
      [media] s2255: Add ENUM_FRAMESIZES support
      [media] s2255: choose YUYV as the default format, not YUV422P
      [media] s2255: fix big-endian support
      [media] tvp7002: replace 'preset' by 'timings' in various structs/variables
      [media] tvp7002: use dv_timings structs instead of presets
      [media] tvp7002: remove dv_preset support
      [media] davinci_vpfe: fix copy-paste errors in several comments
      [media] davinci: remove VPBE_ENC_DV_PRESET and rename VPBE_ENC_CUSTOM_TIMINGS
      [media] davinci: replace V4L2_OUT_CAP_CUSTOM_TIMINGS by V4L2_OUT_CAP_DV_TIMINGS
      [media] davinci/vpfe_capture: convert to the control framework
      [media] davinci/vpbe_display: remove deprecated current_norm
      [media] davinci/vpfe_capture: remove current_norm
      [media] davinci/dm644x_ccdc: fix compiler warning
      [media] davinci: more gama -> gamma typo fixes
      [media] blackfin: replace V4L2_IN/OUT_CAP_CUSTOM_TIMINGS by DV_TIMINGS
      [media] videobuf2: add gfp_flags
      [media] vb2-dma-sg: add debug module option
      [media] em28xx: tuner setup is broken after algo_data change
      [media] s5p-tv: add dv_timings support for hdmiphy
      [media] s5p-tv: add dv_timings support for hdmi
      [media] s5p-tv: add dv_timings support for mixer_video
      [media] s5p-tv: remove dv_preset support from mixer_video
      [media] s5p-tv: remove the dv_preset API from hdmi
      [media] s5p-tv: remove the dv_preset API from hdmiphy
      [media] v4l2: add const to argument of write-only s_frequency ioctl
      [media] v4l2: add const to argument of write-only s_tuner ioctl
      [media] v4l2: pass std by value to the write-only s_std ioctl
      [media] v4l2-ioctl: add precision when printing names
      [media] ivtv: prepare ivtv for adding const to s_register
      [media] v4l2: add const to argument of write-only s_register ioctl
      [media] v4l2-ioctl: simplify debug code
      [media] v4l2-core: add code to check for specific ops
      [media] v4l2-ioctl: check if an ioctl is valid
      [media] v4l2-ctrls: add V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER control
      [media] saa7115: add config flag to change the IDQ polarity
      [media] saa7115: improve querystd handling for the saa7115
      [media] saa7115: add support for double-rate ASCLK
      [media] go7007: fix i2c_xfer return codes
      [media] tuner: add Sony BTF tuners
      [media] sony-btf-mpx: the MPX driver for the sony BTF PAL/SECAM tuner
      [media] ov7640: add new ov7640 driver
      [media] uda1342: add new uda1342 audio codec driver
      [media] tw9903: add new tw9903 video decoder
      [media] tw2804: add support for the Techwell tw2804
      [media] go7007: switch to standard tuner/i2c subdevs
      [media] go7007: remove all wis* drivers
      [media] go7007: add audio input ioctls
      [media] s2250-loader: use usbv2_cypress_load_firmware
      [media] go7007: go7007: add device_caps and bus_info support to querycap
      [media] go7007: remove current_norm
      [media] go7007: fix DMA related errors
      [media] go7007: remember boot firmware
      [media] go7007: fix unregister/disconnect handling
      [media] go7007: convert to the control framework and remove obsolete JPEGCOMP support
      [media] s2250: convert to the control framework
      [media] go7007: add prio and control event support
      [media] go7007: add log_status support
      [media] go7007: tuner/std related fixes
      [media] go7007: standardize MPEG handling support
      [media] go7007: simplify the PX-TV402U board ID handling
      [media] go7007: set up the saa7115 audio clock correctly
      [media] go7007: drop struct go7007_file
      [media] go7007: convert to core locking and vb2
      [media] go7007: embed struct video_device
      [media] go7007: remove cropping functions
      [media] s2250: add comment describing the hardware
      [media] go7007-loader: renamed from s2250-loader
      [media] go7007-loader: add support for the other devices and move fw files
      [media] MAINTAINERS: add the go7007 driver
      [media] go7007: a small improvement to querystd handling
      [media] go7007: add back 'repeat sequence header' control
      [media] go7007: correct a header check: MPEG4 has a different GOP code
      [media] go7007: drop firmware name in board config, make configs const
      [media] tw9906: add Techwell tw9906 video decoder
      [media] go7007: add support for ADS Tech DVD Xpress DX2
      [media] v4l2-common: remove obsolete v4l_fill_dv_preset_info
      [media] v4l2-subdev: remove obsolete dv_preset ops
      [media] v4l2 core: remove the obsolete dv_preset support
      [media] DocBook/media/v4l: remove the documentation of the obsolete dv_preset API
      [media] videodev2.h: remove obsolete DV_PRESET API
      [media] DocBook/media/v4l: Update version number and document 3.10 changes
      [media] vivi: add v4l2_ctrl_modify_range test case
      [media] saa7134-go7007: convert to a subdev and the control framework
      [media] go7007: update the README
      [media] go7007: don't continue if firmware can't be loaded
      [media] tw9603/6.c: use two separate const tables for the 50/60hz setup
      [media] solo6x10: sync to latest code from Bluecherry's git repo
      [media] solo6x10: fix querycap and update driver version
      [media] solo6x10: add v4l2_device
      [media] solo6x10: add control framework
      [media] solo6x10: fix various format-related compliancy issues
      [media] solo6x10: add support for prio and control event handling
      [media] solo6x10: move global fields in solo_dev_fh to solo_dev
      [media] solo6x10: move global fields in solo_enc_fh to solo_enc_dev
      [media] solo6x10: convert encoder nodes to vb2
      [media] solo6x10: convert the display node to vb2
      [media] solo6x10: fix 'BUG: key ffff88081a2a9b58 not in .data!'
      [media] solo6x10: add call to pci_dma_mapping_error
      [media] solo6x10: drop video_type and add proper s_std support
      [media] solo6x10: also stop DMA if the SOLO_PCI_ERR_P2M_DESC is raised
      [media] solo6x10: small big-endian fix
      [media] solo6x10: use V4L2_PIX_FMT_MPEG4, not _FMT_MPEG
      [media] solo6x10: fix sequence handling
      [media] solo6x10: disable the 'priv' abuse
      [media] solo6x10: clean up motion detection handling
      [media] solo6x10: rename headers
      [media] solo6x10: prefix sources with 'solo6x10-'
      [media] v4l2-common: remove obsolete check for ' at the end of a driver name
      [media] DocBook media: fix syntax problems in dvbproperty.xml
      [media] v4l2: add new VIDIOC_DBG_G_CHIP_NAME ioctl
      [media] stk1160: remove V4L2_CHIP_MATCH_AC97 placeholder
      [media] em28xx: add support for g_chip_name
      [media] DocBook media: add VIDIOC_DBG_G_CHIP_NAME documentation
      [media] DocBook media: document 3.10 changes
      [media] au8522_decoder: convert to the control framework
      [media] au0828: fix querycap
      [media] au0828: frequency handling fixes
      [media] au0828: fix intendation coding style issue
      [media] au0828: fix audio input handling
      [media] au0828: convert to the control framework
      [media] au0828: add prio, control event and log_status support
      [media] au0828: add try_fmt_vbi support, zero vbi.reserved, pix.priv
      [media] au0828: replace deprecated current_norm by g_std
      [media] au8522_decoder: remove obsolete control ops
      [media] au0828: fix disconnect sequence
      [media] au0828: simplify i2c_gate_ctrl
      [media] au0828: don't change global state information on open()
      [media] au0828: fix initial video routing
      [media] au0828: improve firmware loading & locking
      [media] tuner-core: don't set has_signal/get_afc if not supported
      [media] Fix undefined reference to `au8522_attach'
      [media] solo6x10: The size of the thresholds ioctls was too large
      [media] media: move dvb-usb-v2/cypress_firmware.c to media/common
      [media] v4l2-controls.h: update private control ranges to prevent overlap
      [media] em28xx: fix typo in scale_to_size()
      [media] si476x: Fix some config dependencies and a compile warnings
      [media] s5c73m3: Fix s5c73m3-core.c compiler warning
      [media] tuner-core/tda9887: get_afc can be tuner mode specific
      [media] tuner-core/simple: get_rf_strength can be tuner mode specific
      [media] v4l2: put VIDIOC_DBG_G_CHIP_NAME under ADV_DEBUG
      [media] v4l2: drop V4L2_CHIP_MATCH_SUBDEV_NAME
      [media] v4l2-ioctl: fill in name before calling vidioc_g_chip_name
      [media] v4l2: rename VIDIOC_DBG_G_CHIP_NAME to _CHIP_INFO
      [media] videodev2.h: increase size of 'reserved' array
      [media] em28xx: fix kernel oops when watching digital TV
      [media] radio-si4713: remove audout ioctls
      [media] radio-si4713: embed struct video_device instead of allocating it
      [media] radio-si4713: improve querycap
      [media] radio-si4713: use V4L2 core lock
      [media] radio-si4713: fix g/s_frequency
      [media] radio-si4713: convert to the control framework
      [media] radio-si4713: add prio checking and control events
      [media] videodev2.h: fix incorrect V4L2_DV_FL_HALF_LINE bitmask
      [media] v4l2-dv-timings.h: add 480i59.94 and 576i50 CEA-861-E timings
      [media] hdpvr: convert to the control framework
      [media] hdpvr: remove hdpvr_fh and just use v4l2_fh
      [media] hdpvr: add prio and control event support
      [media] hdpvr: support device_caps in querycap
      [media] hdpvr: small fixes
      [media] hdpvr: register the video node at the end of probe
      [media] hdpvr: recognize firmware version 0x1e
      [media] hdpvr: add g/querystd, remove deprecated current_norm
      [media] hdpvr: add dv_timings support
      [media] hdpvr: allow g/s/enum/querystd when in legacy mode
      [media] MAINTAINERS: add hdpvr entry
      [media] dt3155v4l: fix incorrect mutex locking
      [media] dt3155v4l: fix timestamp handling
      [media] cx25821: do not expose broken video output streams
      [media] cx25821: the audio channel was registered as a video node
      [media] cx25821: fix compiler warning
      [media] cx25821: remove bogus radio/vbi/'video-ioctl' support
      [media] cx25821: remove unused fields, ioctls
      [media] cx25821: fix log_status, querycap
      [media] cx25821: make cx25821_sram_channels const
      [media] cx25821: remove unnecessary global devlist
      [media] cx25821: s_input didn't check for invalid input
      [media] cx25821: make lots of externals static
      [media] cx25821: remove cropping ioctls
      [media] cx25821: remove bogus dependencies
      [media] cx25821: embed video_device, clean up some kernel log spam
      [media] cx25821: convert to the control framework
      [media] cx25821: remove TRUE/FALSE/STATUS_(UN)SUCCESSFUL defines
      [media] cx25821: remove unnecessary debug messages
      [media] cx25821: use core locking
      [media] cx25821: remove 'type' field from cx25821_fh
      [media] cx25821: move vidq from cx25821_fh to cx25821_channel
      [media] cx25821: replace resource management functions with fh ownership
      [media] cx25821: switch to v4l2_fh, add event and prio handling
      [media] cx25821: g/s/try/enum_fmt related fixes and cleanups
      [media] cx25821: remove custom ioctls that duplicate v4l2 ioctls
      [media] cx25821: remove references to subdevices that aren't there
      [media] cx25821: setup output nodes correctly
      [media] cx25821: group all fmt functions together
      [media] cx25821: prepare querycap for output support
      [media] cx25821: add output format ioctls
      [media] cx25821: drop cx25821-video-upstream-ch2.c/h
      [media] cx25821: replace custom ioctls with write()
      [media] cx25821: remove cx25821-audio-upstream.c from the Makefile
      [media] mem2mem_testdev: set timestamp_type and add debug param

Hans de Goede (4):
      [media] gscpa_gl860: Convert to the control framework
      [media] gscpa_m5602: Convert to the control framework
      [media] gscpa: Remove autogain_functions.h
      [media] gspca: Remove old control code now that all drivers are converted

Igor M. Liplianin (1):
      [media] media: Terratec Cinergy S2 USB HD Rev.2

Ismael Luceno (4):
      [media] solo6x10: Maintainer change
      [media] solo6x10: Update TODO (maintainer change)
      [media] solo6x10: Update the encoder mode on VIDIOC_S_FMT
      [media] solo6x10: Fix pixelformat accepted/reported by the encoder

Jean Delvare (2):
      [media] drxk_hard: Drop unused parameter
      [media] m920x: Fix uninitialized variable warning

Jiri Slaby (1):
      [media] MEDIA: ttusbir, fix double free

John Sheu (2):
      [media] v4l2-mem2mem: use CAPTURE queue lock
      [media] v4l2-mem2mem: drop rdy_queue on STREAMOFF

John Smith (1):
      [media] dvb_demux: Transport stream continuity check fix

Jose Alberto Reguero (1):
      [media] [PATH] enable dual tuner to Avermedia Twinstar in af9035 driver

Kamil Debski (10):
      [media] v4l: Define video buffer flag for the COPY timestamp type
      [media] vb2: Add support for non monotonic timestamps
      [media] s5p-mfc: Add support for EOS command and EOS event in video decoder
      [media] s5p-g2d: Add copy time stamp handling
      [media] s5p-jpeg: Add copy time stamp handling
      [media] s5p-mfc: Optimize copy time stamp handling
      [media] coda: Add copy time stamp handling
      [media] exynos-gsc: Add copy time stamp handling
      [media] m2m-deinterlace: Add copy time stamp handling
      [media] mx2-emmaprp: Add copy time stamp handling

Kevin Baradon (5):
      [media] media/rc/imon.c: make send_packet() delay larger for 15c2:0036
      [media] media/rc/imon.c: avoid flooding syslog with "unknown keypress" when keypad is pressed
      [media] imon: Use large delays earlier
      [media] media/rc/imon.c: do not try to register 2nd intf if 1st intf failed
      [media] media/rc/imon.c: kill urb when send_packet() is interrupted

Lad, Prabhakar (13):
      [media] davinci: vpbe: fix module build
      [media] media: ths7353: add support for ths7353 video amplifier
      [media] davinci: vpif: Fix module build for capture and display
      [media] davinci: vpif: add pm_runtime support
      [media] media: davinci: vpss: enable vpss clocks
      [media] media: davinci: vpbe: venc: move the enabling of vpss clocks to driver
      [media] davinic: vpss: trivial cleanup
      [media] ARM: davinci: dm365: add support for v4l2 video display
      [media] ARM: davinci: dm365 EVM: add support for VPBE display
      [media] ARM: davinci: dm355: add support for v4l2 video display
      [media] ARM: davinci: dm355 EVM: add support for VPBE display
      [media] ARM: daVinci: dm644x/dm355/dm365: replace V4L2_STD_525_60/625_50 with V4L2_STD_NTSC/PAL
      [media] MAINTAINERS: change entry for davinci media driver

Laurent Pinchart (7):
      [media] uvcvideo: Return -EINVAL when setting a menu control to an invalid value
      [media] mt9m032: Fix PLL setup
      [media] mt9m032: Define MT9M032_READ_MODE1 bits
      [media] mt9p031: Use devm_* managed helpers
      [media] mt9p031: Add support for regulators
      [media] mt9p031: Use the common clock framework
      [media] MAINTAINERS: Mark the SH VOU driver as Odd Fixes

Manjunath Hadli (2):
      [media] media: add support for decoder as one of media entity types
      [media] media: tvp514x: enable TVP514X for media controller based usage

Masanari Iida (2):
      [media] documentation: DocBook/media : Fix typo in dvbproperty.xml
      [media] staging: davinci: Fix typo in staging/media/davinci

Matt Gomboc (1):
      [media] cx231xx : Add support for OTG102 aka EZGrabber2

Mauro Carvalho Chehab (164):
      Merge tag 'v3.9-rc1' into staging/for_v3.9
      [media] mb86a20s: don't pollute dmesg with debug messages
      [media] mb86a20s: adjust IF based on what's set on the tuner
      [media] mb86a20s: provide CNR stats before FE_HAS_SYNC
      [media] mb86a20s: Fix signal strength calculus
      [media] mb86a20s: don't allow updating signal strength too fast
      [media] mb86a20s: change AGC tuning parameters
      [media] mb86a20s: Always reset the frontend with set_frontend
      [media] mb86a20s: Don't reset strength with the other stats
      [media] mb86a20s: cleanup the status at set_frontend()
      [media] cx231xx: Improve signal reception for PV SBTVD
      [media] em28xx-dvb: Don't put device in suspend mode at feed stop
      [media] mb86a20s: Implement set_frontend cache logic
      [media] mb86a20s: Don't assume a 32.57142MHz clock
      [media] em28xx: Prepare to support 2 different I2C buses
      [media] em28xx: Add a separate config dir for secondary bus
      [media] em28xx: add support for registering multiple i2c buses
      [media] dvb-frontend: split set_delivery_system()
      [media] dvb_frontend: Simplify the emulation logic
      [media] em28xx: Add ISDB support for c3tech Digital duo
      [media] em28xx: update cardlist
      [media] siano: Change GPIO voltage setting names
      [media] siano: Add the new voltage definitions for GPIO
      [media] siano: remove a duplicated structure definition
      [media] siano: update message macros
      [media] siano: better debug send/receive messages
      [media] siano: add the remaining new defines from new driver
      [media] siano: Properly initialize board information
      [media] siano: add additional attributes to cards entries
      [media] siano: use USB endpoint descriptors for in/out endp
      [media] siano: store firmware version
      [media] siano: make load firmware logic to work with newer firmwares
      [media] siano: report the choosed firmware in debug
      [media] siano: fix the debug message
      [media] siano: always load smsdvb
      [media] siano: cleanups at smscoreapi.c
      [media] siano: add some new messages to the smscoreapi
      [media] siano: use a separate completion for stats
      [media] siano: add support for ISDB-T full-seg
      [media] siano: add support for LNA on ISDB-T
      [media] siano: use the newer stats message for recent firmwares
      [media] siano: add new devices to the Siano Driver
      [media] siano: Configure board's mtu and xtal
      [media] siano: call MSG_SMS_INIT_DEVICE_REQ
      [media] siano: simplify message endianness logic
      [media] siano: split get_frontend into per-std functions
      [media] siano: split debug logic from the status update routine
      [media] siano: Convert it to report DVBv5 stats
      [media] siano: fix start of statistics
      [media] siano: allow showing the complete statistics via debugfs
      [media] siano: split debugfs code into a separate file
      [media] siano: add two missing fields to ISDB-T stats debugfs
      [media] siano: don't request statistics too fast
      [media] siano: fix signal strength and CNR stats measurements
      [media] siano: fix PER/BER report on DVBv5
      [media] siano: Fix bandwidth report
      [media] siano: Only feed DVB data when there's a feed
      [media] siano: fix status report with old firmware and ISDB-T
      [media] siano: add support for .poll on debugfs
      [media] siano: simplify firmware lookup logic
      [media] siano: honour per-card default mode
      [media] siano: remove the bogus firmware lookup code
      [media] siano: reorder smscore_get_fw_filename() function
      [media] siano: add a MAINTAINERS entry for it
      [media] siano: remove a bogus printk line
      [media] siano: remove doubled new line
      [media] siano: Remove bogus complain about MSG_SMS_DVBT_BDA_DATA
      [media] siano: use defines for firmware names
      [media] siano: add MODULE_FIRMWARE() macros
      [media] siano: get rid of CammelCase from smscoreapi.h
      [media] siano: convert structure names to lowercase
      [media] siano: fix checkpatch.pl compliants on smscoreapi.h
      [media] siano: remove the remaining CamelCase compliants
      [media] siano: Fix the remaining checkpatch.pl compliants
      [media] siano: make some functions static
      [media] drxk: remove dummy BER read code
      [media] drxk: Add pre/post BER and PER/UCB stats
      [media] drxk: use a better calculus for RF strength
      [media] drxk: Fix bogus signal strength indicator
      [media] dvb-core: don't clear stats at DTV_CLEAR
      [media] siano: use do_div() for 64-bits division
      [media] drxk: fix CNR calculus
      [media] siano: remove the ir protocol field
      [media] m5602_ov7660: return error at ov7660_init()
      [media] em28xx: Only change I2C bus inside em28xx-i2c
      [media] hdpvr-video: Use the proper check for I2C support
      [media] dvb-frontends: use IS_ENABLED
      [media] tuners: use IS_ENABLED
      [media] cx23885: use IS_ENABLED
      [media] dvb-usb/dvb-usb-v2: use IS_ENABLED
      [media] sony-btf-mpx: v4l2_tuner struct is now constant
      [media] tuner-core: return afc instead of zero
      [media] tuner-core: Remove the now uneeded checks at fe_has_signal/get_afc
      [media] tuner-core: handle errors when getting signal strength/afc
      [media] ioctl numbers are unsigned int
      [media] radio-si476x: vidioc_s* now uses a const parameter
      Merge tag 'v3.9-rc5' into patchwork
      [media] siano: Fix array boundary at smscore_translate_msg()
      [media] demux.h: Remove duplicated enum
      [media] cx88: kernel bz#9476: Fix tone setting for Nova-S+ model 92001
      [media] mb86a20s: Use a macro for the number of layers
      [media] mb86a20s: fix audio sub-channel check
      [media] mb86a20s: Use 'layer' instead of 'i' on all places
      [media] mb86a20s: Fix estimate_rate setting
      [media] mb86a20s: better name temp vars at mb86a20s_layer_bitrate()
      [media] cx24123: improve precision when calculating symbol rate ratio
      [media] cxd2820r_t2: Fix a warning: stream_id is unsigned
      [media] it913x: rename its tuner driver to tuner_it913x
      [media] sta2x11_vip: Fix compilation if I2C is not set
      [media] r820t: Add a tuner driver for Rafael Micro R820T silicon tuner
      [media] rtl28xxu: add support for Rafael Micro r820t
      [media] r820t: Give a better estimation of the signal strength
      [media] r820t: Set gain mode to auto
      [media] rtl28xxu: use r820t to obtain the signal strength
      [media] r820t: proper lock and set the I2C gate
      [media] rtl820t: Add a debug msg when PLL gets locked
      [media] r820t: Fix IF scale
      [media] rtl2832: add code to bind r820t on it
      [media] r820t: use the right IF for the selected TV standard
      [media] rtl2832: properly set en_bbin for r820t
      [media] r820t: Invert bits for read ops
      [media] r820t: use the second table for 7MHz
      [media] r820t: Show the read data in the bit-reversed order
      [media] r820t: add support for diplexer
      [media] r820t: better report signal strength
      [media] r820t: split the function that read cached regs
      [media] r820t: fix prefix of the r820t_read() function
      [media] r820t: use usleep_range()
      [media] r820t: proper initialize the PLL register
      [media] r820t: add IMR calibrate code
      [media] r820t: add a commented code for GPIO
      [media] r820t: Allow disabling IMR callibration
      [media] r820t: avoid rewrite all regs when not needed
      [media] r820t: Don't put it in standby if not initialized yet
      [media] r820t: fix PLL calculus
      [media] r820t: Fix hp_cor filter mask
      [media] r820t: put it into automatic gain mode
      [media] rtl2832: Fix IF calculus
      [media] r820t: disable auto gain/VGA setting
      [media] r820t: Don't divide the IF by two
      Revert "[media] v4l2: Add a V4L2 driver for SI476X MFD"
      Revert "[media] mfd: Add header files and Kbuild plumbing for SI476x MFD core"
      Revert "[media] mfd: Add commands abstraction layer for SI476X MFD"
      Revert "[media] mfd: Add the main bulk of core driver for SI476x code"
      Revert "[media] mfd: Add chip properties handling code for SI476X MFD"
      [media] videobuf-dma-contig: remove support for cached mem
      [media] media: videobuf2: fix the length check for mmap
      Merge branch 'topic/r820t' into patchwork
      Merge branch 'topic/si476x' into patchwork
      Merge branch 'topic/cx25821' into patchwork
      [media] videodev2.h: Remove the unused old V4L1 buffer types
      [media] dib8000: warning fix: declare internal functions as static
      [media] dib8000: store dtv_property_cache in a temp var
      [media] dib8000: Fix sub-channel range
      [media] dib8000: fix a warning
      [media] dib0090: Fix a warning at dib0090_set_EFUSE
      [media] r820t: Remove a warning for an unused value
      [media] cx25821-video: remove maxw from cx25821_vidioc_try_fmt_vid_cap
      [media] cx25821-video: declare cx25821_vidioc_s_std as static
      [media] cx25821-alsa: get rid of a __must_check warning
      [media] em28xx: fix oops at em28xx_dvb_bus_ctrl()
      [media] cx88: make core less verbose
      Merge tag 'v3.9' into v4l_for_linus
      Merge branch 'devel-for-v3.10' into v4l_for_linus

Michal Marek (1):
      [media] em28xx: Put remaining .vidioc_g_chip_info instance under ADV_DEBUG

Olivier Grenie (5):
      [media] dib7000p: enhancement
      [media] dib0090: enhancement
      [media] dib8096: enhancement
      [media] dib7090p: remove the support for the dib7090E
      [media] dib7090p: improve the support of the dib7090 and dib7790

Ondrej Zary (13):
      [media] tda8290: Allow disabling I2C gate
      [media] tda8290: Allow custom std_map for tda18271
      [media] tuner-core: Change config from unsigned int to void *
      [media] saa7134: Add AverMedia A706 AverTV Satellite Hybrid+FM
      [media] tda8290: change magic LNA config values to enum
      [media] saa7134: v4l2-compliance: implement V4L2_CAP_DEVICE_CAPS
      [media] saa7134: v4l2-compliance: don't report invalid audio modes for radio
      [media] saa7134: v4l2-compliance: use v4l2_fh to fix priority handling
      [media] saa7134: v4l2-compliance: return real frequency
      [media] saa7134: v4l2-compliance: fix g_tuner/s_tuner
      [media] saa7134: v4l2-compliance: remove bogus audio input support
      [media] saa7134: v4l2-compliance: remove bogus g_parm
      [media] saa7134: v4l2-compliance: clear reserved part of VBI structure

Patrick Boettcher (1):
      [media] dib8000: enhancement

Paul Bolle (4):
      [media] m920x: let GCC see 'ret' is used initialized
      [media] ts2020: use customise option correctly
      [media] soc_camera: remove two outdated selects
      [media] gspca: remove obsolete Kconfig macros

Peter Senna Tschudin (1):
      [media] cx25821: Cleanup filename assignment code

Peter Wiese (1):
      [media] budget: Add support for Philips Semi Sylt PCI ref. design

Phil Edworthy (1):
      [media] soc_camera: Add RGB666 & RGB888 formats

Randy Dunlap (2):
      [media] media: Fix randconfig error
      [media] staging/media: fix go7007 dependencies and build

Sachin Kamat (26):
      [media] s5p-g2d: Add DT based discovery support
      [media] timblogiw: Fix sparse warning
      [media] s5p-mfc: Staticize some symbols in s5p_mfc_cmd_v6.c
      [media] s5p-mfc: Staticize some symbols in s5p_mfc_cmd_v5.c
      [media] s5p-mfc: Staticize symbols in s5p_mfc_opr_v6.c
      [media] s5p-mfc: Staticize symbols in s5p_mfc_opr_v5.c
      [media] davinci_vpfe: Use module_platform_driver macro
      [media] soc_camera/sh_mobile_ceu_camera: Convert to devm_ioremap_resource()
      [media] soc_camera/sh_mobile_csi2: Convert to devm_ioremap_resource()
      [media] soc_camera/pxa_camera: Convert to devm_ioremap_resource()
      [media] sh_veu.c: Convert to devm_ioremap_resource()
      [media] soc_camera/mx1_camera: Use module_platform_driver_probe macro
      [media] sh_veu: Use module_platform_driver_probe macro
      [media] sh_vou: Use module_platform_driver_probe macro
      [media] dvb-usb/dw2102: Remove duplicate inclusion of ts2020.h
      [media] tw9906: Remove unneeded version.h header include
      [media] go7007: Remove unneeded version.h header include
      [media] soc_camera/mx1_camera: Fix warnings related to spacing
      [media] soc_camera/mx2_camera: Fix warnings related to spacing
      [media] soc_camera/mx3_camera: Fix warning related to spacing
      [media] soc_camera/pxa_camera: Fix warning related to spacing
      [media] soc_camera/pxa_camera: Constify struct dev_pm_ops
      [media] soc_camera/sh_mobile_ceu_camera: Fix warning related to spacing
      [media] soc_camera/soc_camera_platform: Fix warning related to spacing
      [media] exynos4-is: Fix potential null pointer dereferencing
      [media] exynos4-is: Convert index variable to signed

Sakari Ailus (2):
      [media] media: Add 64--32 bit compat ioctl handler
      [media] media: implement 32-on-64 bit compat IOCTL handling

Sean Young (3):
      [media] redrat3: limit periods to hardware limits
      [media] redrat3: remove memcpys and fix unaligned memory access
      [media] redrat3: missing endian conversions and warnings

Sekhar Nori (1):
      [media] media: davinci: kconfig: fix incorrect selects

Seung-Woo Kim (1):
      [media] media: vb2: add length check for mmap

Silviu-Mihai Popescu (1):
      [media] drivers: staging: davinci_vpfe: use resource_size()

Syam Sidhardhan (7):
      [media] lmedm04: Fix possible NULL pointer dereference
      [media] hdpvr: Fix memory leak
      [media] siano: Remove redundant NULL check before kfree
      [media] media: ivtv: Remove redundant NULL check before kfree
      [media] media: tuners: Remove redundant NULL check before kfree
      [media] dvb-usb: Remove redundant NULL check before kfree
      [media] lmedm04: Remove redundant NULL check before kfree

Sylwester Nawrocki (57):
      [media] s3c-camif: Fail on insufficient number of allocated buffers
      [media] s5p-fimc: Use video entity for marking media pipeline as streaming
      [media] s5p-fimc: Use vb2 ioctl/fop helpers in FIMC capture driver
      [media] s5p-fimc: Use vb2 ioctl helpers in fimc-lite
      [media] s5p-csis: Add device tree support
      [media] s5p-fimc: Add device tree support for FIMC device driver
      [media] s5p-fimc: Add device tree support for FIMC-LITE device driver
      [media] s5p-fimc: Add device tree support for the media device driver
      [media] s5p-fimc: Add device tree based sensors registration
      [media] s5p-fimc: Use pinctrl API for camera ports configuration
      [media] V4L: Add MATRIX option to V4L2_CID_EXPOSURE_METERING control
      [media] s5p-fimc: Update graph traversal for entities with multiple source pads
      [media] s5p-fimc: Add support for PIXELASYNCMx clocks
      [media] s5p-fimc: Add support for ISP Writeback data input bus type
      [media] s5p-fimc: Ensure CAMCLK clock can be enabled by FIMC-LITE devices
      [media] s5p-fimc: Ensure proper s_stream() call order in the ISP datapaths
      [media] s5p-fimc: Ensure proper s_power() call order in the ISP datapaths
      [media] s5p-fimc: Remove dependency on fimc-core.h in fimc-lite driver
      [media] s5p-fimc: Change the driver directory name to exynos4-is
      [media] exynos4-is: Remove dependency on SYSCON for non-dt platforms
      [media] exynos4-is: Correct clock properties description at the DT binding documentation
      [media] V4L: Remove incorrect EXPORT_SYMBOL() usage at v4l2-of.c
      [media] exynos4-is: Add Exynos4x12 FIMC-IS driver
      [media] exynos4-is: Add FIMC-IS ISP I2C bus driver
      [media] exynos4-is: Add FIMC-IS parameter region definitions
      [media] exynos4-is: Add common FIMC-IS image sensor driver
      [media] exynos4-is: Add Exynos4x12 FIMC-IS device tree binding documentation
      [media] exynos4-is: Add fimc-is subdevs registration
      [media] exynos4-is: Create media links for the FIMC-IS entities
      [media] exynos4-is: Remove static driver data for Exynos4210 FIMC variants
      [media] exynos4-is: Use common driver data for all FIMC-LITE IP instances
      [media] exynos4-is: Allow colorspace conversion at FIMC-LITE
      [media] exynos4-is: Correct input DMA YUV order configuration
      [media] exynos4-is: Ensure proper media pipeline state on device close
      [media] s5p-mfc: Remove potential uninitialized variable usage
      [media] exynos4-is: Move the subdev group ID definitions to public header
      [media] exynos4-is: Make fimc-lite independent of the pipeline->subdevs array
      [media] exynos4-is: Make fimc-lite independent of struct fimc_sensor_info
      [media] exynos4-is: Improve the ISP chain parameter count calculation
      [media] exynos4-is: Rename the ISP chain configuration data structure
      [media] exynos4-is: Remove meaningless test before bit setting
      [media] exynos4-is: Disable debug trace by default in fimc-isp.c
      [media] s5c73m3: Fix remove() callback to free requested resources
      [media] s5c73m3: Add missing subdev .unregistered callback
      [media] exynos4-is: Remove redundant MODULE_DEVICE_TABLE entries
      [media] exynos4-is: Fix initialization of subdev 'flags' field
      [media] exynos4-is: Fix regulator/gpio resource releasing on the driver removal
      [media] exynos4-is: Don't overwrite subdevdata in the fimc-is sensor driver
      [media] exynos4-is: Unregister fimc-is subdevs from the media device properly
      [media] exynos4-is: Set fimc-lite subdev owner module
      [media] exynos4-is: Remove redundant module_put() for MIPI-CSIS module
      [media] exynos4-is: Remove debugfs entries properly
      [media] exynos4-is: Change function call order in fimc_is_module_exit()
      [media] exynos4-is: Fix runtime PM handling on fimc-is probe error path
      [media] exynos4-is: Fix driver name reported in vidioc_querycap
      [media] exynos4-is: Fix TRY format propagation at MIPI-CSIS subdev
      [media] exynos4-is: Copy timestamps from M2M OUTPUT to CAPTURE buffer queue

Theodore Kilgore (1):
      [media] gspca: Remove gspca-specific debug magic

Thiago Farina (1):
      [media] media/usb: cx231xx-pcb-cfg.h: Remove unused enum _true_false

Tushar Behera (2):
      [media] videobuf2-core: print current state of buffer in vb2_buffer_done
      [media] atmel-isi: Update error check for unsigned variables

Vladimir Barinov (1):
      [media] adv7180: fix querystd() method for no input signal

Volokh Konstantin (4):
      [media] tw2804: modify ADC power control
      [media] go7007: i2c initialization changes for tw2804
      [media] go7007: Restore b_frame control
      [media] tw2804: Revert ADC Control commit 523a4f7fbcf856fb1c2a4850f44edea6738ee37b

Wei Yongjun (10):
      [media] dvb_usb_v2: make local function dvb_usb_v2_generic_io() static
      [media] gspca: remove needless check before usb_free_coherent()
      [media] davinci: vpfe: fix return value check in vpfe_enable_clock()
      [media] af9035: fix missing unlock on error in af9035_ctrl_msg()
      [media] go7007: fix invalid use of sizeof in go7007_usb_i2c_master_xfer()
      [media] rc: winbond-cir: fix potential double free in wbcir_probe()
      [media] rc: ite-cir: fix potential double free in ite_probe()
      [media] rc: nuvoton-cir: fix potential double free in nvt_probe()
      [media] rc: ene_ir: fix potential double free in ene_probe()
      [media] s5p-mfc: fix error return code in s5p_mfc_probe()

William Steidtmann (1):
      [media] mceusb: add some missing cmd sizes

 Documentation/DocBook/media/dvb/dvbproperty.xml    |   52 +-
 Documentation/DocBook/media/v4l/common.xml         |   14 -
 Documentation/DocBook/media/v4l/compat.xml         |   24 +-
 Documentation/DocBook/media/v4l/controls.xml       |   87 +-
 Documentation/DocBook/media/v4l/io.xml             |    6 +
 .../DocBook/media/v4l/media-ioc-enum-entities.xml  |   10 +
 Documentation/DocBook/media/v4l/subdev-formats.xml |  206 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |   19 +-
 .../DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml  |    9 +-
 .../DocBook/media/v4l/vidioc-dbg-g-chip-info.xml   |  223 ++
 .../DocBook/media/v4l/vidioc-dbg-g-register.xml    |   29 +-
 .../DocBook/media/v4l/vidioc-enum-dv-presets.xml   |  240 --
 .../DocBook/media/v4l/vidioc-enuminput.xml         |    5 -
 .../DocBook/media/v4l/vidioc-enumoutput.xml        |    5 -
 .../DocBook/media/v4l/vidioc-g-dv-preset.xml       |  113 -
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    9 +
 .../DocBook/media/v4l/vidioc-query-dv-preset.xml   |   78 -
 Documentation/DocBook/media_api.tmpl               |    1 +
 .../devicetree/bindings/media/exynos-fimc-lite.txt |   14 +
 .../devicetree/bindings/media/exynos4-fimc-is.txt  |   49 +
 .../devicetree/bindings/media/samsung-fimc.txt     |  197 ++
 .../bindings/media/samsung-mipi-csis.txt           |   81 +
 .../devicetree/bindings/media/video-interfaces.txt |  228 ++
 Documentation/video4linux/CARDLIST.em28xx          |    3 +-
 Documentation/video4linux/CARDLIST.tuner           |    3 +
 Documentation/video4linux/si476x.txt               |  187 ++
 MAINTAINERS                                        |  100 +-
 arch/arm/mach-davinci/board-dm355-evm.c            |   71 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |  166 +-
 arch/arm/mach-davinci/board-dm644x-evm.c           |    8 +-
 arch/arm/mach-davinci/board-dm646x-evm.c           |    2 +-
 arch/arm/mach-davinci/davinci.h                    |   11 +-
 arch/arm/mach-davinci/dm355.c                      |  174 +-
 arch/arm/mach-davinci/dm365.c                      |  195 +-
 arch/arm/mach-davinci/dm644x.c                     |   11 +-
 arch/arm/mach-davinci/pm_domain.c                  |    2 +-
 arch/blackfin/mach-bf609/boards/ezkit.c            |    8 +-
 drivers/media/common/Kconfig                       |    4 +
 drivers/media/common/Makefile                      |    1 +
 drivers/media/common/b2c2/flexcop-fe-tuner.c       |    4 +-
 .../{usb/dvb-usb-v2 => common}/cypress_firmware.c  |   82 +-
 .../{usb/dvb-usb-v2 => common}/cypress_firmware.h  |    9 +-
 drivers/media/common/saa7146/saa7146_video.c       |    4 +-
 drivers/media/common/siano/Kconfig                 |   12 +
 drivers/media/common/siano/Makefile                |    5 +
 drivers/media/common/siano/sms-cards.c             |  115 +-
 drivers/media/common/siano/sms-cards.h             |   14 +
 drivers/media/common/siano/smscoreapi.c            | 1298 ++++++++---
 drivers/media/common/siano/smscoreapi.h            | 1007 ++++++---
 drivers/media/common/siano/smsdvb-debugfs.c        |  551 +++++
 drivers/media/common/siano/smsdvb-main.c           | 1230 ++++++++++
 drivers/media/common/siano/smsdvb.c                | 1078 ---------
 drivers/media/common/siano/smsdvb.h                |  130 ++
 drivers/media/common/siano/smsendian.c             |   44 +-
 drivers/media/common/siano/smsir.h                 |    1 -
 drivers/media/dvb-core/demux.h                     |   39 -
 drivers/media/dvb-core/dmxdev.c                    |    5 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |    3 +-
 drivers/media/dvb-core/dvb_demux.c                 |   30 +-
 drivers/media/dvb-core/dvb_demux.h                 |    4 +-
 drivers/media/dvb-core/dvb_frontend.c              |  333 +--
 drivers/media/dvb-core/dvb_frontend.h              |    4 +-
 drivers/media/dvb-core/dvb_net.c                   |    2 +-
 drivers/media/dvb-frontends/Kconfig                |    2 +-
 drivers/media/dvb-frontends/a8293.h                |    5 +-
 drivers/media/dvb-frontends/af9013.h               |    4 +-
 drivers/media/dvb-frontends/af9033.c               |  138 +-
 drivers/media/dvb-frontends/af9033.h               |   20 +-
 drivers/media/dvb-frontends/af9033_priv.h          | 1506 ++++++++++++-
 drivers/media/dvb-frontends/atbm8830.h             |    4 +-
 drivers/media/dvb-frontends/au8522.h               |    4 +-
 drivers/media/dvb-frontends/au8522_decoder.c       |  125 +-
 drivers/media/dvb-frontends/au8522_priv.h          |    6 +-
 drivers/media/dvb-frontends/cx22702.h              |    4 +-
 drivers/media/dvb-frontends/cx24113.h              |    5 +-
 drivers/media/dvb-frontends/cx24116.h              |    4 +-
 drivers/media/dvb-frontends/cx24123.c              |   28 +-
 drivers/media/dvb-frontends/cx24123.h              |    4 +-
 drivers/media/dvb-frontends/cxd2820r.h             |    4 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |    3 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c          |   17 +
 drivers/media/dvb-frontends/dib0090.c              |  434 ++--
 drivers/media/dvb-frontends/dib3000mc.h            |    5 +-
 drivers/media/dvb-frontends/dib7000m.h             |    5 +-
 drivers/media/dvb-frontends/dib7000p.c             |   17 +-
 drivers/media/dvb-frontends/dib7000p.h             |   12 +-
 drivers/media/dvb-frontends/dib8000.c              | 2268 +++++++++++--------
 drivers/media/dvb-frontends/dib8000.h              |    6 +-
 drivers/media/dvb-frontends/dibx000_common.h       |    3 +-
 drivers/media/dvb-frontends/drxd.h                 |    4 +-
 drivers/media/dvb-frontends/drxk.h                 |    4 +-
 drivers/media/dvb-frontends/drxk_hard.c            |  309 ++-
 drivers/media/dvb-frontends/drxk_hard.h            |    2 +
 drivers/media/dvb-frontends/drxk_map.h             |    3 +
 drivers/media/dvb-frontends/ds3000.h               |    4 +-
 drivers/media/dvb-frontends/dvb_dummy_fe.h         |    4 +-
 drivers/media/dvb-frontends/ec100.h                |    4 +-
 drivers/media/dvb-frontends/hd29l2.h               |    4 +-
 drivers/media/dvb-frontends/isl6421.c              |   28 +-
 drivers/media/dvb-frontends/isl6421.h              |    4 +-
 drivers/media/dvb-frontends/it913x-fe.h            |    4 +-
 drivers/media/dvb-frontends/ix2505v.h              |    4 +-
 drivers/media/dvb-frontends/lg2160.h               |    8 +-
 drivers/media/dvb-frontends/lgdt3305.h             |    4 +-
 drivers/media/dvb-frontends/lgs8gl5.h              |    4 +-
 drivers/media/dvb-frontends/lgs8gxx.h              |    4 +-
 drivers/media/dvb-frontends/lnbh24.h               |    5 +-
 drivers/media/dvb-frontends/lnbp21.h               |    5 +-
 drivers/media/dvb-frontends/lnbp22.h               |    5 +-
 drivers/media/dvb-frontends/m88rs2000.h            |    4 +-
 drivers/media/dvb-frontends/mb86a20s.c             |  505 +++--
 drivers/media/dvb-frontends/mb86a20s.h             |   12 +-
 drivers/media/dvb-frontends/rtl2830.h              |    4 +-
 drivers/media/dvb-frontends/rtl2832.c              |   85 +-
 drivers/media/dvb-frontends/rtl2832.h              |    5 +-
 drivers/media/dvb-frontends/rtl2832_priv.h         |   28 +
 drivers/media/dvb-frontends/s5h1409.h              |    4 +-
 drivers/media/dvb-frontends/s5h1411.h              |    4 +-
 drivers/media/dvb-frontends/s5h1432.h              |    4 +-
 drivers/media/dvb-frontends/s921.h                 |    4 +-
 drivers/media/dvb-frontends/si21xx.h               |    4 +-
 drivers/media/dvb-frontends/stb6000.h              |    4 +-
 drivers/media/dvb-frontends/stv0288.h              |    4 +-
 drivers/media/dvb-frontends/stv0367.h              |    4 +-
 drivers/media/dvb-frontends/stv0900.h              |    4 +-
 drivers/media/dvb-frontends/stv090x.c              |   22 +-
 drivers/media/dvb-frontends/stv6110.h              |    4 +-
 drivers/media/dvb-frontends/tda10048.h             |    4 +-
 drivers/media/dvb-frontends/tda10071.h             |    4 +-
 drivers/media/dvb-frontends/tda18271c2dd.h         |    6 +-
 drivers/media/dvb-frontends/ts2020.h               |    4 +-
 drivers/media/dvb-frontends/zl10036.h              |    4 +-
 drivers/media/dvb-frontends/zl10039.h              |    5 +-
 drivers/media/firewire/firedtv-dvb.c               |   14 +-
 drivers/media/i2c/Kconfig                          |   70 +-
 drivers/media/i2c/Makefile                         |    8 +-
 drivers/media/i2c/ad9389b.c                        |    2 +-
 drivers/media/i2c/adp1653.c                        |    4 +-
 drivers/media/i2c/adv7180.c                        |    4 +
 drivers/media/i2c/adv7183.c                        |    2 +-
 drivers/media/i2c/adv7604.c                        |    2 +-
 drivers/media/i2c/ak881x.c                         |    2 +-
 drivers/media/i2c/cs5345.c                         |    2 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |    6 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |   14 +-
 drivers/media/i2c/m52790.c                         |    2 +-
 drivers/media/i2c/msp3400-driver.c                 |    4 +-
 drivers/media/i2c/mt9m032.c                        |   48 +-
 drivers/media/i2c/mt9p031.c                        |   58 +-
 drivers/media/i2c/mt9v011.c                        |    2 +-
 .../go7007/wis-ov7640.c => media/i2c/ov7640.c}     |   70 +-
 drivers/media/i2c/ov7670.c                         |    2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   23 +-
 drivers/media/i2c/saa6588.c                        |    2 +-
 drivers/media/i2c/saa7115.c                        |   80 +-
 drivers/media/i2c/saa7127.c                        |    2 +-
 drivers/media/i2c/saa717x.c                        |    4 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |    4 +-
 drivers/media/i2c/soc_camera/Kconfig               |    2 -
 drivers/media/i2c/soc_camera/mt9m001.c             |    2 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |   11 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |    2 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |    2 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |   21 +-
 drivers/media/i2c/soc_camera/ov2640.c              |    2 +-
 drivers/media/i2c/soc_camera/ov5642.c              |    2 +-
 drivers/media/i2c/soc_camera/ov6650.c              |    2 +-
 drivers/media/i2c/soc_camera/ov772x.c              |    2 +-
 drivers/media/i2c/soc_camera/ov9640.c              |    2 +-
 drivers/media/i2c/soc_camera/ov9740.c              |    2 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |    2 +-
 drivers/media/i2c/soc_camera/tw9910.c              |    2 +-
 drivers/media/i2c/sony-btf-mpx.c                   |  399 ++++
 drivers/media/i2c/tda7432.c                        |  276 +--
 drivers/media/i2c/tda9840.c                        |    2 +-
 drivers/media/i2c/ths7303.c                        |  351 ++-
 drivers/media/i2c/tvaudio.c                        |    6 +-
 drivers/media/i2c/tvp514x.c                        |  163 +-
 drivers/media/i2c/tvp5150.c                        |    2 +-
 drivers/media/i2c/tvp7002.c                        |  184 +-
 drivers/media/i2c/tw2804.c                         |  453 ++++
 drivers/media/i2c/tw9903.c                         |  279 +++
 drivers/media/i2c/tw9906.c                         |  247 ++
 .../go7007/wis-uda1342.c => media/i2c/uda1342.c}   |   83 +-
 drivers/media/i2c/upd64031a.c                      |    4 +-
 drivers/media/i2c/upd64083.c                       |    2 +-
 drivers/media/i2c/vp27smpx.c                       |    2 +-
 drivers/media/i2c/vs6624.c                         |    2 +-
 drivers/media/i2c/wm8775.c                         |    2 +-
 drivers/media/media-device.c                       |  111 +-
 drivers/media/media-devnode.c                      |   31 +-
 drivers/media/mmc/siano/smssdio.c                  |   27 +-
 drivers/media/parport/pms.c                        |    4 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |   21 +-
 drivers/media/pci/bt8xx/bttv-driver.c              | 1226 +++++-----
 drivers/media/pci/bt8xx/bttv-i2c.c                 |    8 +
 drivers/media/pci/bt8xx/bttv-input.c               |   30 +-
 drivers/media/pci/bt8xx/bttv.h                     |    3 +
 drivers/media/pci/bt8xx/bttvp.h                    |   38 +-
 drivers/media/pci/cx18/cx18-av-core.c              |    6 +-
 drivers/media/pci/cx18/cx18-driver.c               |    2 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |   52 +-
 drivers/media/pci/cx18/cx18-ioctl.h                |    4 +-
 drivers/media/pci/cx23885/altera-ci.h              |    5 +-
 drivers/media/pci/cx23885/cx23885-417.c            |   10 +-
 drivers/media/pci/cx23885/cx23885-ioctl.c          |    9 +-
 drivers/media/pci/cx23885/cx23885-ioctl.h          |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   14 +-
 drivers/media/pci/cx23885/cx23885.h                |    2 +-
 drivers/media/pci/cx23885/cx23888-ir.c             |    2 +-
 drivers/media/pci/cx25821/Kconfig                  |    7 +-
 drivers/media/pci/cx25821/Makefile                 |    7 +-
 drivers/media/pci/cx25821/cx25821-alsa.c           |   83 +-
 drivers/media/pci/cx25821/cx25821-audio-upstream.c |   43 +-
 drivers/media/pci/cx25821/cx25821-cards.c          |   23 -
 drivers/media/pci/cx25821/cx25821-core.c           |  133 +-
 drivers/media/pci/cx25821/cx25821-gpio.c           |    1 +
 drivers/media/pci/cx25821/cx25821-i2c.c            |    3 +-
 drivers/media/pci/cx25821/cx25821-medusa-video.c   |   46 +-
 .../media/pci/cx25821/cx25821-video-upstream-ch2.c |  800 -------
 .../media/pci/cx25821/cx25821-video-upstream-ch2.h |  138 --
 drivers/media/pci/cx25821/cx25821-video-upstream.c |  519 ++---
 drivers/media/pci/cx25821/cx25821-video.c          | 1842 ++++-----------
 drivers/media/pci/cx25821/cx25821-video.h          |  125 +-
 drivers/media/pci/cx25821/cx25821.h                |  304 +--
 drivers/media/pci/cx88/cx88-blackbird.c            |    8 +-
 drivers/media/pci/cx88/cx88-cards.c                |   30 +-
 drivers/media/pci/cx88/cx88-core.c                 |   12 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |   16 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |   10 +-
 drivers/media/pci/cx88/cx88-video.c                |   35 +-
 drivers/media/pci/cx88/cx88.h                      |    5 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |    4 +-
 drivers/media/pci/ivtv/ivtv-firmware.c             |    4 +-
 drivers/media/pci/ivtv/ivtv-gpio.c                 |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |   57 +-
 drivers/media/pci/ivtv/ivtv-ioctl.h                |    6 +-
 drivers/media/pci/ivtv/ivtvfb.c                    |    3 +-
 drivers/media/pci/meye/meye.c                      |    2 +-
 drivers/media/pci/saa7134/saa7134-cards.c          |   94 +-
 drivers/media/pci/saa7134/saa7134-core.c           |    3 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |   31 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |    2 +-
 drivers/media/pci/saa7134/saa7134-i2c.c            |    1 +
 drivers/media/pci/saa7134/saa7134-input.c          |    3 +
 drivers/media/pci/saa7134/saa7134-tvaudio.c        |    1 +
 drivers/media/pci/saa7134/saa7134-video.c          |  189 +-
 drivers/media/pci/saa7134/saa7134.h                |   11 +-
 drivers/media/pci/saa7146/mxb.c                    |    9 +-
 drivers/media/pci/saa7164/saa7164-encoder.c        |   14 +-
 drivers/media/pci/saa7164/saa7164-vbi.c            |   12 +-
 drivers/media/pci/sta2x11/Kconfig                  |    1 +
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   18 +-
 drivers/media/pci/ttpci/av7110.c                   |    6 +-
 drivers/media/pci/ttpci/av7110_v4l.c               |    4 +-
 drivers/media/pci/ttpci/budget.c                   |   12 +
 drivers/media/pci/zoran/zoran_driver.c             |    4 +-
 drivers/media/pci/zoran/zoran_procfs.c             |    2 +-
 drivers/media/platform/Kconfig                     |    2 +-
 drivers/media/platform/Makefile                    |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   13 +-
 drivers/media/platform/coda.c                      |    5 +
 drivers/media/platform/davinci/Kconfig             |  103 +-
 drivers/media/platform/davinci/Makefile            |   17 +-
 drivers/media/platform/davinci/dm355_ccdc.c        |   49 +-
 drivers/media/platform/davinci/dm355_ccdc_regs.h   |    2 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |   57 +-
 drivers/media/platform/davinci/dm644x_ccdc_regs.h  |    2 +-
 drivers/media/platform/davinci/isif.c              |   30 +-
 drivers/media/platform/davinci/isif_regs.h         |    4 +-
 drivers/media/platform/davinci/vpbe.c              |   16 +-
 drivers/media/platform/davinci/vpbe_display.c      |   17 +-
 drivers/media/platform/davinci/vpbe_osd.c          |    3 +
 drivers/media/platform/davinci/vpbe_venc.c         |   36 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   62 +-
 drivers/media/platform/davinci/vpif.c              |   32 +-
 drivers/media/platform/davinci/vpif.h              |    2 +-
 drivers/media/platform/davinci/vpif_capture.c      |   12 +-
 drivers/media/platform/davinci/vpif_display.c      |   16 +-
 drivers/media/platform/davinci/vpss.c              |   36 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    5 +
 drivers/media/platform/exynos-gsc/gsc-regs.c       |    1 -
 .../platform/{s5p-fimc => exynos4-is}/Kconfig      |   21 +-
 .../platform/{s5p-fimc => exynos4-is}/Makefile     |    5 +-
 .../{s5p-fimc => exynos4-is}/fimc-capture.c        |  411 ++--
 .../platform/{s5p-fimc => exynos4-is}/fimc-core.c  |  312 +--
 .../platform/{s5p-fimc => exynos4-is}/fimc-core.h  |   86 +-
 .../media/platform/exynos4-is/fimc-is-command.h    |  137 ++
 drivers/media/platform/exynos4-is/fimc-is-errno.c  |  272 +++
 drivers/media/platform/exynos4-is/fimc-is-errno.h  |  248 +++
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |  126 ++
 drivers/media/platform/exynos4-is/fimc-is-i2c.h    |   15 +
 drivers/media/platform/exynos4-is/fimc-is-param.c  |  900 ++++++++
 drivers/media/platform/exynos4-is/fimc-is-param.h  | 1020 +++++++++
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |  243 ++
 drivers/media/platform/exynos4-is/fimc-is-regs.h   |  164 ++
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |  305 +++
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |   89 +
 drivers/media/platform/exynos4-is/fimc-is.c        | 1007 +++++++++
 drivers/media/platform/exynos4-is/fimc-is.h        |  345 +++
 drivers/media/platform/exynos4-is/fimc-isp.c       |  703 ++++++
 drivers/media/platform/exynos4-is/fimc-isp.h       |  181 ++
 .../{s5p-fimc => exynos4-is}/fimc-lite-reg.c       |    4 +-
 .../{s5p-fimc => exynos4-is}/fimc-lite-reg.h       |    8 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-lite.c  |  429 ++--
 .../platform/{s5p-fimc => exynos4-is}/fimc-lite.h  |   20 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-m2m.c   |   40 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-reg.c   |   87 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-reg.h   |   27 +-
 .../fimc-mdevice.c => exynos4-is/media-dev.c}      |  725 ++++--
 .../fimc-mdevice.h => exynos4-is/media-dev.h}      |   54 +-
 .../platform/{s5p-fimc => exynos4-is}/mipi-csis.c  |  169 +-
 .../platform/{s5p-fimc => exynos4-is}/mipi-csis.h  |    1 +
 drivers/media/platform/fsl-viu.c                   |    6 +-
 drivers/media/platform/m2m-deinterlace.c           |    5 +
 drivers/media/platform/marvell-ccic/mcam-core.c    |    4 +-
 drivers/media/platform/mem2mem_testdev.c           |   12 +-
 drivers/media/platform/mx2_emmaprp.c               |    5 +
 drivers/media/platform/omap/omap_vout.c            |   14 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   16 +-
 drivers/media/platform/s5p-g2d/g2d.c               |   36 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    5 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   19 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c    |   12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |   12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   76 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |  112 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  122 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |  129 +-
 drivers/media/platform/s5p-tv/hdmiphy_drv.c        |   55 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   52 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c        |    3 -
 drivers/media/platform/sh_veu.c                    |   20 +-
 drivers/media/platform/sh_vou.c                    |   27 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |   16 +-
 drivers/media/platform/soc_camera/mx1_camera.c     |   17 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    8 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |    3 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |    6 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |   12 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   12 +-
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |    9 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   48 +-
 .../platform/soc_camera/soc_camera_platform.c      |    2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |   46 +-
 drivers/media/platform/timblogiw.c                 |    8 +-
 drivers/media/platform/via-camera.c                |    2 +-
 drivers/media/platform/vino.c                      |   10 +-
 drivers/media/platform/vivi.c                      |   10 +
 drivers/media/radio/Kconfig                        |   16 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/dsbr100.c                      |    4 +-
 drivers/media/radio/radio-cadet.c                  |   48 +-
 drivers/media/radio/radio-isa.c                    |   15 +-
 drivers/media/radio/radio-keene.c                  |    8 +-
 drivers/media/radio/radio-ma901.c                  |    4 +-
 drivers/media/radio/radio-miropcm20.c              |   12 +-
 drivers/media/radio/radio-mr800.c                  |   14 +-
 drivers/media/radio/radio-rtrack2.c                |    5 +-
 drivers/media/radio/radio-sf16fmi.c                |    4 +-
 drivers/media/radio/radio-si4713.c                 |  204 +-
 drivers/media/radio/radio-si476x.c                 | 1599 +++++++++++++
 drivers/media/radio/radio-tea5764.c                |    4 +-
 drivers/media/radio/radio-tea5777.c                |    9 +-
 drivers/media/radio/radio-timb.c                   |    4 +-
 drivers/media/radio/radio-wl1273.c                 |    4 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    4 +-
 drivers/media/radio/si4713-i2c.c                   | 1049 ++-------
 drivers/media/radio/si4713-i2c.h                   |   66 +-
 drivers/media/radio/tef6862.c                      |    4 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    8 +-
 drivers/media/rc/ene_ir.c                          |    1 +
 drivers/media/rc/imon.c                            |   46 +-
 drivers/media/rc/ir-jvc-decoder.c                  |    2 +-
 drivers/media/rc/ir-lirc-codec.c                   |    2 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |    2 +-
 drivers/media/rc/ir-nec-decoder.c                  |    2 +-
 drivers/media/rc/ir-raw.c                          |    2 +-
 drivers/media/rc/ir-rc5-decoder.c                  |    6 +-
 drivers/media/rc/ir-rc5-sz-decoder.c               |    2 +-
 drivers/media/rc/ir-rc6-decoder.c                  |    2 +-
 drivers/media/rc/ir-rx51.c                         |    4 +-
 drivers/media/rc/ir-sanyo-decoder.c                |    2 +-
 drivers/media/rc/ir-sony-decoder.c                 |    8 +-
 drivers/media/rc/ite-cir.c                         |    1 +
 drivers/media/rc/keymaps/Makefile                  |    3 +-
 drivers/media/rc/keymaps/rc-reddo.c                |   86 +
 drivers/media/rc/mceusb.c                          |   11 +-
 drivers/media/rc/nuvoton-cir.c                     |    1 +
 drivers/media/rc/rc-core-priv.h                    |    1 -
 drivers/media/rc/rc-main.c                         |   46 +-
 drivers/media/rc/redrat3.c                         |  457 ++--
 drivers/media/rc/ttusbir.c                         |    1 +
 drivers/media/rc/winbond-cir.c                     |    1 +
 drivers/media/tuners/Kconfig                       |   14 +
 drivers/media/tuners/Makefile                      |    2 +
 drivers/media/tuners/e4000.h                       |    4 +-
 drivers/media/tuners/fc0011.h                      |    4 +-
 drivers/media/tuners/fc0012.h                      |    4 +-
 drivers/media/tuners/fc0013.h                      |    4 +-
 drivers/media/tuners/fc2580.h                      |    4 +-
 drivers/media/tuners/max2165.h                     |    5 +-
 drivers/media/tuners/mc44s803.h                    |    5 +-
 drivers/media/tuners/mxl5005s.h                    |    5 +-
 drivers/media/tuners/r820t.c                       | 2355 ++++++++++++++++++++
 drivers/media/tuners/r820t.h                       |   59 +
 drivers/media/tuners/tda18212.h                    |    4 +-
 drivers/media/tuners/tda18218.h                    |    4 +-
 drivers/media/tuners/tda18271-fe.c                 |    9 +-
 drivers/media/tuners/tda827x.c                     |   10 +-
 drivers/media/tuners/tda827x.h                     |    3 +-
 drivers/media/tuners/tda8290.c                     |   75 +-
 drivers/media/tuners/tda8290.h                     |   12 +-
 drivers/media/tuners/tda9887.c                     |   14 +-
 drivers/media/tuners/tua9001.h                     |    4 +-
 drivers/media/tuners/tuner-simple.c                |    5 +-
 drivers/media/tuners/tuner-types.c                 |   69 +
 drivers/media/tuners/tuner-xc2028.c                |    3 +-
 drivers/media/tuners/tuner_it913x.c                |  447 ++++
 drivers/media/tuners/tuner_it913x.h                |   45 +
 drivers/media/tuners/tuner_it913x_priv.h           |   78 +
 drivers/media/tuners/xc5000.c                      |   20 +-
 drivers/media/tuners/xc5000.h                      |    4 +-
 drivers/media/usb/au0828/au0828-core.c             |   61 +-
 drivers/media/usb/au0828/au0828-video.c            |  299 ++-
 drivers/media/usb/au0828/au0828.h                  |    7 +
 drivers/media/usb/cx231xx/cx231xx-417.c            | 1182 ++++------
 drivers/media/usb/cx231xx/cx231xx-audio.c          |    8 +-
 drivers/media/usb/cx231xx/cx231xx-avcore.c         |   85 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   59 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |    2 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |    4 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c        |    2 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h        |    5 -
 drivers/media/usb/cx231xx/cx231xx-vbi.c            |   25 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |  601 ++---
 drivers/media/usb/cx231xx/cx231xx.h                |   55 +-
 drivers/media/usb/dvb-usb-v2/Kconfig               |    8 +-
 drivers/media/usb/dvb-usb-v2/Makefile              |    5 +-
 drivers/media/usb/dvb-usb-v2/af9015.c              |   79 +-
 drivers/media/usb/dvb-usb-v2/af9015.h              |    2 +
 drivers/media/usb/dvb-usb-v2/af9035.c              |  600 +++--
 drivers/media/usb/dvb-usb-v2/af9035.h              |   49 +-
 drivers/media/usb/dvb-usb-v2/anysee.c              |   48 +-
 drivers/media/usb/dvb-usb-v2/anysee.h              |    3 +-
 drivers/media/usb/dvb-usb-v2/az6007.c              |    2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |    9 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |  311 +--
 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c         |   43 +-
 drivers/media/usb/dvb-usb-v2/it913x.c              |    1 +
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |    8 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h      |    4 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h      |    5 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   36 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h            |    1 +
 drivers/media/usb/dvb-usb-v2/usb_urb.c             |   36 +-
 drivers/media/usb/dvb-usb/cinergyT2-fe.c           |    3 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |  465 ++--
 drivers/media/usb/dvb-usb/dibusb-common.c          |    5 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |   19 +-
 drivers/media/usb/dvb-usb/m920x.c                  |   10 +-
 drivers/media/usb/em28xx/Kconfig                   |    1 +
 drivers/media/usb/em28xx/Makefile                  |    2 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |  434 ++++
 drivers/media/usb/em28xx/em28xx-cards.c            |  366 ++-
 drivers/media/usb/em28xx/em28xx-core.c             |   45 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |  125 +-
 drivers/media/usb/em28xx/em28xx-i2c.c              |  691 ++++--
 drivers/media/usb/em28xx/em28xx-input.c            |    5 +-
 drivers/media/usb/em28xx/em28xx-reg.h              |   35 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  415 ++--
 drivers/media/usb/em28xx/em28xx.h                  |  231 +-
 drivers/media/usb/gspca/autogain_functions.h       |  183 --
 drivers/media/usb/gspca/benq.c                     |    2 +-
 drivers/media/usb/gspca/conex.c                    |   12 +-
 drivers/media/usb/gspca/cpia1.c                    |   33 +-
 drivers/media/usb/gspca/etoms.c                    |   12 +-
 drivers/media/usb/gspca/gl860/gl860.c              |  224 +-
 drivers/media/usb/gspca/gspca.c                    |  240 +-
 drivers/media/usb/gspca/gspca.h                    |   70 +-
 drivers/media/usb/gspca/jeilinj.c                  |    2 +-
 drivers/media/usb/gspca/konica.c                   |   28 +-
 drivers/media/usb/gspca/m5602/m5602_bridge.h       |   27 +-
 drivers/media/usb/gspca/m5602/m5602_core.c         |   22 +-
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c      |  404 +---
 drivers/media/usb/gspca/m5602/m5602_mt9m111.h      |    2 +
 drivers/media/usb/gspca/m5602/m5602_ov7660.c       |  312 +--
 drivers/media/usb/gspca/m5602/m5602_ov7660.h       |    3 +
 drivers/media/usb/gspca/m5602/m5602_ov9650.c       |  469 +---
 drivers/media/usb/gspca/m5602/m5602_ov9650.h       |    2 +
 drivers/media/usb/gspca/m5602/m5602_po1030.c       |  471 +---
 drivers/media/usb/gspca/m5602/m5602_po1030.h       |    2 +
 drivers/media/usb/gspca/m5602/m5602_s5k4aa.c       |  352 +--
 drivers/media/usb/gspca/m5602/m5602_s5k4aa.h       |    2 +
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c       |  291 +--
 drivers/media/usb/gspca/m5602/m5602_s5k83a.h       |    9 +-
 drivers/media/usb/gspca/m5602/m5602_sensor.h       |    3 +
 drivers/media/usb/gspca/mr97310a.c                 |    8 +-
 drivers/media/usb/gspca/ov519.c                    |   81 +-
 drivers/media/usb/gspca/ov534.c                    |    2 +-
 drivers/media/usb/gspca/pac207.c                   |    2 +-
 drivers/media/usb/gspca/pac7302.c                  |    9 +-
 drivers/media/usb/gspca/pac7311.c                  |    5 +-
 drivers/media/usb/gspca/pac_common.h               |    2 +-
 drivers/media/usb/gspca/sn9c2028.c                 |    4 +-
 drivers/media/usb/gspca/sn9c20x.c                  |    2 +-
 drivers/media/usb/gspca/sonixb.c                   |   22 -
 drivers/media/usb/gspca/sonixj.c                   |  556 ++---
 drivers/media/usb/gspca/spca1528.c                 |    4 +-
 drivers/media/usb/gspca/spca500.c                  |   36 +-
 drivers/media/usb/gspca/spca501.c                  |   44 +-
 drivers/media/usb/gspca/spca505.c                  |   42 +-
 drivers/media/usb/gspca/spca508.c                  |   41 +-
 drivers/media/usb/gspca/spca561.c                  |   70 +-
 drivers/media/usb/gspca/sq905.c                    |    2 +-
 drivers/media/usb/gspca/sq905c.c                   |    6 +-
 drivers/media/usb/gspca/sq930x.c                   |    4 +-
 drivers/media/usb/gspca/stv0680.c                  |   14 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |   17 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c     |    8 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c   |   14 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c   |    2 +
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c   |   10 +-
 drivers/media/usb/gspca/sunplus.c                  |   27 +-
 drivers/media/usb/gspca/vc032x.c                   |    9 +-
 drivers/media/usb/gspca/w996Xcf.c                  |    5 +-
 drivers/media/usb/gspca/zc3xx.c                    |    3 +-
 drivers/media/usb/hdpvr/hdpvr-core.c               |   15 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |  945 ++++----
 drivers/media/usb/hdpvr/hdpvr.h                    |   19 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h            |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   10 +-
 drivers/media/usb/pwc/pwc-if.c                     |    1 +
 drivers/media/usb/s2255/s2255drv.c                 |  441 ++--
 drivers/media/usb/siano/smsusb.c                   |  158 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |   14 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |  309 +--
 drivers/media/usb/stkwebcam/stk-webcam.h           |    8 +-
 drivers/media/usb/tlg2300/pd-common.h              |   26 +-
 drivers/media/usb/tlg2300/pd-main.c                |   16 +-
 drivers/media/usb/tlg2300/pd-radio.c               |  229 +-
 drivers/media/usb/tlg2300/pd-video.c               |  303 +--
 drivers/media/usb/tm6000/tm6000-video.c            |   16 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  |   10 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |   20 +-
 drivers/media/usb/usbvision/usbvision-video.c      |   10 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |    2 +-
 drivers/media/usb/uvc/uvc_queue.c                  |    1 +
 drivers/media/v4l2-core/Kconfig                    |    1 +
 drivers/media/v4l2-core/Makefile                   |    3 +
 drivers/media/v4l2-core/tuner-core.c               |   72 +-
 drivers/media/v4l2-core/v4l2-common.c              |   54 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |    4 -
 drivers/media/v4l2-core/v4l2-ctrls.c               |   25 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |    9 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  219 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   34 +-
 drivers/media/v4l2-core/v4l2-of.c                  |  266 +++
 drivers/media/v4l2-core/videobuf-dma-contig.c      |  130 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   32 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |    8 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |   25 +-
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |    4 +-
 drivers/of/base.c                                  |    1 +
 drivers/staging/media/as102/Makefile               |    2 +-
 .../staging/media/davinci_vpfe/davinci-vpfe-mc.txt |    2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |    2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |    3 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |   10 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |    2 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |   24 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   26 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |    2 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |   11 +-
 drivers/staging/media/go7007/Kconfig               |  103 +-
 drivers/staging/media/go7007/Makefile              |   23 +-
 drivers/staging/media/go7007/README                |  142 +-
 drivers/staging/media/go7007/go7007-driver.c       |  390 ++--
 drivers/staging/media/go7007/go7007-fw.c           |   88 +-
 drivers/staging/media/go7007/go7007-i2c.c          |   21 +-
 drivers/staging/media/go7007/go7007-loader.c       |  144 ++
 drivers/staging/media/go7007/go7007-priv.h         |  104 +-
 drivers/staging/media/go7007/go7007-usb.c          |  394 ++--
 drivers/staging/media/go7007/go7007-v4l2.c         | 1747 ++++-----------
 drivers/staging/media/go7007/go7007.h              |   74 -
 drivers/staging/media/go7007/s2250-board.c         |  171 +-
 drivers/staging/media/go7007/s2250-loader.c        |  169 --
 drivers/staging/media/go7007/s2250-loader.h        |   24 -
 drivers/staging/media/go7007/saa7134-go7007.c      |  171 +-
 drivers/staging/media/go7007/snd-go7007.c          |   11 +-
 drivers/staging/media/go7007/wis-i2c.h             |   42 -
 drivers/staging/media/go7007/wis-saa7113.c         |  324 ---
 drivers/staging/media/go7007/wis-saa7115.c         |  457 ----
 drivers/staging/media/go7007/wis-sony-tuner.c      |  707 ------
 drivers/staging/media/go7007/wis-tw2804.c          |  348 ---
 drivers/staging/media/go7007/wis-tw9903.c          |  328 ---
 drivers/staging/media/lirc/lirc_sir.c              |   10 -
 drivers/staging/media/solo6x10/Kconfig             |    3 +-
 drivers/staging/media/solo6x10/Makefile            |    4 +-
 drivers/staging/media/solo6x10/TODO                |   39 +-
 drivers/staging/media/solo6x10/core.c              |  321 ---
 drivers/staging/media/solo6x10/offsets.h           |   74 -
 drivers/staging/media/solo6x10/osd-font.h          |  154 --
 drivers/staging/media/solo6x10/p2m.c               |  306 ---
 drivers/staging/media/solo6x10/solo6x10-core.c     |  709 ++++++
 .../media/solo6x10/{disp.c => solo6x10-disp.c}     |  129 +-
 drivers/staging/media/solo6x10/solo6x10-eeprom.c   |  154 ++
 .../media/solo6x10/{enc.c => solo6x10-enc.c}       |  239 +-
 .../media/solo6x10/{g723.c => solo6x10-g723.c}     |   94 +-
 .../media/solo6x10/{gpio.c => solo6x10-gpio.c}     |   13 +-
 .../media/solo6x10/{i2c.c => solo6x10-i2c.c}       |   26 +-
 drivers/staging/media/solo6x10/solo6x10-jpeg.h     |   94 +-
 drivers/staging/media/solo6x10/solo6x10-offsets.h  |   85 +
 drivers/staging/media/solo6x10/solo6x10-p2m.c      |  333 +++
 .../solo6x10/{registers.h => solo6x10-regs.h}      |   88 +-
 .../media/solo6x10/{tw28.c => solo6x10-tw28.c}     |  187 +-
 .../media/solo6x10/{tw28.h => solo6x10-tw28.h}     |   12 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 1385 ++++++++++++
 drivers/staging/media/solo6x10/solo6x10-v4l2.c     |  734 ++++++
 drivers/staging/media/solo6x10/solo6x10.h          |  265 ++-
 drivers/staging/media/solo6x10/v4l2-enc.c          | 1829 ---------------
 drivers/staging/media/solo6x10/v4l2.c              |  961 --------
 include/media/davinci/dm355_ccdc.h                 |    6 +-
 include/media/davinci/dm644x_ccdc.h                |   24 +-
 include/media/davinci/vpbe.h                       |    2 +-
 include/media/davinci/vpbe_types.h                 |    3 +-
 include/media/media-devnode.h                      |    1 +
 include/media/mt9p031.h                            |    2 -
 include/media/rc-core.h                            |    2 +
 include/media/rc-map.h                             |    1 +
 include/media/s5p_fimc.h                           |   64 +
 include/media/saa7115.h                            |   32 +-
 include/media/si476x.h                             |   37 +
 include/media/soc_camera.h                         |    7 +-
 include/media/soc_mediabus.h                       |    3 +
 include/media/ths7303.h                            |   42 +
 include/media/tuner.h                              |    6 +-
 include/media/uda1342.h                            |   29 +
 include/media/v4l2-chip-ident.h                    |   11 +
 include/media/v4l2-common.h                        |    1 -
 include/media/v4l2-ctrls.h                         |   29 +-
 include/media/v4l2-device.h                        |   13 +
 include/media/v4l2-ioctl.h                         |   22 +-
 include/media/v4l2-of.h                            |  111 +
 include/media/v4l2-subdev.h                        |   25 +-
 include/media/videobuf-dma-contig.h                |   10 -
 include/media/videobuf2-core.h                     |   11 +-
 include/uapi/linux/dvb/dmx.h                       |    2 +-
 include/uapi/linux/media.h                         |    2 +
 include/uapi/linux/v4l2-controls.h                 |   28 +
 include/uapi/linux/v4l2-dv-timings.h               |   18 +
 include/uapi/linux/v4l2-mediabus.h                 |    6 +-
 include/uapi/linux/videodev2.h                     |  111 +-
 sound/i2c/other/tea575x-tuner.c                    |    6 +-
 655 files changed, 40833 insertions(+), 28655 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
 create mode 100644 Documentation/devicetree/bindings/media/exynos-fimc-lite.txt
 create mode 100644 Documentation/devicetree/bindings/media/exynos4-fimc-is.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-fimc.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-mipi-csis.txt
 create mode 100644 Documentation/devicetree/bindings/media/video-interfaces.txt
 create mode 100644 Documentation/video4linux/si476x.txt
 rename drivers/media/{usb/dvb-usb-v2 => common}/cypress_firmware.c (84%)
 rename drivers/media/{usb/dvb-usb-v2 => common}/cypress_firmware.h (68%)
 create mode 100644 drivers/media/common/siano/smsdvb-debugfs.c
 create mode 100644 drivers/media/common/siano/smsdvb-main.c
 delete mode 100644 drivers/media/common/siano/smsdvb.c
 create mode 100644 drivers/media/common/siano/smsdvb.h
 rename drivers/{staging/media/go7007/wis-ov7640.c => media/i2c/ov7640.c} (53%)
 create mode 100644 drivers/media/i2c/sony-btf-mpx.c
 create mode 100644 drivers/media/i2c/tw2804.c
 create mode 100644 drivers/media/i2c/tw9903.c
 create mode 100644 drivers/media/i2c/tw9906.c
 rename drivers/{staging/media/go7007/wis-uda1342.c => media/i2c/uda1342.c} (52%)
 delete mode 100644 drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
 delete mode 100644 drivers/media/pci/cx25821/cx25821-video-upstream-ch2.h
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/Kconfig (69%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/Makefile (58%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-capture.c (87%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-core.c (85%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-core.h (92%)
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-command.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-errno.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-errno.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-i2c.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-i2c.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-param.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-param.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-regs.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-regs.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-sensor.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-sensor.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp.h
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite-reg.c (98%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite-reg.h (96%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite.c (86%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite.h (95%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-m2m.c (95%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-reg.c (91%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-reg.h (93%)
 rename drivers/media/platform/{s5p-fimc/fimc-mdevice.c => exynos4-is/media-dev.c} (59%)
 rename drivers/media/platform/{s5p-fimc/fimc-mdevice.h => exynos4-is/media-dev.h} (69%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/mipi-csis.c (85%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/mipi-csis.h (93%)
 create mode 100644 drivers/media/radio/radio-si476x.c
 create mode 100644 drivers/media/rc/keymaps/rc-reddo.c
 create mode 100644 drivers/media/tuners/r820t.c
 create mode 100644 drivers/media/tuners/r820t.h
 create mode 100644 drivers/media/tuners/tuner_it913x.c
 create mode 100644 drivers/media/tuners/tuner_it913x.h
 create mode 100644 drivers/media/tuners/tuner_it913x_priv.h
 create mode 100644 drivers/media/usb/em28xx/em28xx-camera.c
 delete mode 100644 drivers/media/usb/gspca/autogain_functions.h
 create mode 100644 drivers/media/v4l2-core/v4l2-of.c
 create mode 100644 drivers/staging/media/go7007/go7007-loader.c
 delete mode 100644 drivers/staging/media/go7007/s2250-loader.c
 delete mode 100644 drivers/staging/media/go7007/s2250-loader.h
 delete mode 100644 drivers/staging/media/go7007/wis-i2c.h
 delete mode 100644 drivers/staging/media/go7007/wis-saa7113.c
 delete mode 100644 drivers/staging/media/go7007/wis-saa7115.c
 delete mode 100644 drivers/staging/media/go7007/wis-sony-tuner.c
 delete mode 100644 drivers/staging/media/go7007/wis-tw2804.c
 delete mode 100644 drivers/staging/media/go7007/wis-tw9903.c
 delete mode 100644 drivers/staging/media/solo6x10/core.c
 delete mode 100644 drivers/staging/media/solo6x10/offsets.h
 delete mode 100644 drivers/staging/media/solo6x10/osd-font.h
 delete mode 100644 drivers/staging/media/solo6x10/p2m.c
 create mode 100644 drivers/staging/media/solo6x10/solo6x10-core.c
 rename drivers/staging/media/solo6x10/{disp.c => solo6x10-disp.c} (74%)
 create mode 100644 drivers/staging/media/solo6x10/solo6x10-eeprom.c
 rename drivers/staging/media/solo6x10/{enc.c => solo6x10-enc.c} (50%)
 rename drivers/staging/media/solo6x10/{g723.c => solo6x10-g723.c} (83%)
 rename drivers/staging/media/solo6x10/{gpio.c => solo6x10-gpio.c} (91%)
 rename drivers/staging/media/solo6x10/{i2c.c => solo6x10-i2c.c} (92%)
 create mode 100644 drivers/staging/media/solo6x10/solo6x10-offsets.h
 create mode 100644 drivers/staging/media/solo6x10/solo6x10-p2m.c
 rename drivers/staging/media/solo6x10/{registers.h => solo6x10-regs.h} (90%)
 rename drivers/staging/media/solo6x10/{tw28.c => solo6x10-tw28.c} (84%)
 rename drivers/staging/media/solo6x10/{tw28.h => solo6x10-tw28.h} (88%)
 create mode 100644 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
 create mode 100644 drivers/staging/media/solo6x10/solo6x10-v4l2.c
 delete mode 100644 drivers/staging/media/solo6x10/v4l2-enc.c
 delete mode 100644 drivers/staging/media/solo6x10/v4l2.c
 create mode 100644 include/media/si476x.h
 create mode 100644 include/media/ths7303.h
 create mode 100644 include/media/uda1342.h
 create mode 100644 include/media/v4l2-of.h

