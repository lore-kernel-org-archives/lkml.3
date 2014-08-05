Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaHEV1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:27:01 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:56722 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaHEV05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:26:57 -0400
X-AuditID: cbfec373-b7f9d6d00000479f-42-53e14c1f6111
Date: Tue, 05 Aug 2014 18:26:49 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.17-rc1] media updates for next
Message-id: <20140805182649.5e3335b0.m.chehab@samsung.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e9wkK68z8Ngg2V3pSzmrF/DZnF51xw2
	i54NW1ktHvW9ZXdg8Tgx4zeLx+dNcgFMUVw2Kak5mWWpRfp2CVwZD54pFjxoYalY0/SLpYHx
	y1+mLkZODgkBE4ndyx+xQthiEhfurWfrYuTiEBJYwiix9OknJginmUliy4d+sCoWAVWJBbfW
	M4PYbAJGEq8aW8DiIkD25xdXWEEamAUWM0p8fL6eHSQhLGAuMXfpFzYQm1fASmLi8afMEOuc
	JX7OnMQIEReU+DH5HguIzSygLjFp3iJmCFtb4sm7C6wTGPlmISmbhaRsFpKyBYzMqxhFS4uT
	C4qT0nON9IoTc4tL89L1kvNzNzFCwq94B+OLDVaHGAU4GJV4eDNMHwYLsSaWFVfmHmKU4GBW
	EuFlv/0gWIg3JbGyKrUoP76oNCe1+BAjEwenVAPjApmIkLs2LIFMfL/esn1QvJZgtbbLzGHC
	3+xzdq/F9neeYstbwa8WHrXgS/RGu10F65gvL5kvfHHGHJXH03U+t8btOtT0b+qbXJuT6Uvv
	Nqcw/D91+ohl9FlnOUbmY0xMHV5fpF8YN92/eevWm8BFtdKZ7z6wHDDgsjp5Ta46+QfvxzrW
	ebm7lFiKMxINtZiLihMByVR5gB0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For:
- removal of sn9c102. This device driver was replaced a long 
  time ago by gspca;
- Webcam drivers moved from staging into mainstream:
  solo6x10 and go7007.
  Those were waiting for an API to allow setting the image detection
  matrix;
- SDR drivers moved from staging into mainstream:
  sdr-msi3101(renamed as msi2500) and rtl2832;
- Added SDR driver for airspy;
- Added demux driver: si2165;
- Rework at several RC subsystem, making the code for RC-5 SZ
  variant to be added at the standard RC5 decoder;
- Added decoder for the XMP IR protocol;
- Tuner driver moved from staging into mainstream: msi3101
  (renamed as msi001);
- Added documentation for some additional SDR pixfmt;
- Some device tree bindings documented;
- Added support for exynos3250 at s5p-jpeg;
- Remove the obsolete, unmaintained and broken mx1_camera driver;
- Added support for remote controllers at au0828 driver;
- Added a RC driver: sunxi-cir;
- Several driver fixes, enhancements and cleanups.

Thanks!
Mauro

-

The following changes since commit 67dd8f35c2d8ed80f26c9654b474cffc11c6674d:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2014-07-21 11:44:34 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 0f3bf3dc1ca394a8385079a5653088672b65c5c4:

  [media] cx23885: fix UNSET/TUNER_ABSENT confusion (2014-08-01 15:30:59 -0300)

----------------------------------------------------------------
Alan (1):
      [media] dvb-frontends: Add static

Alexander Bersenev (2):
      [media] dt: bindings: Add binding documentation for sunxi IR controller
      [media] rc: add sunxi-ir driver

Alexander Shiyan (3):
      [media] m2m-deinterlace: Convert to devm* API
      [media] media: mx1_camera: Remove driver
      [media] media: mx2_camera: Change Kconfig dependency

Alexey Khoroshilov (2):
      [media] usbtv: fix leak at failure path in usbtv_probe()
      [media] tlg2300: fix leak at failure path in poseidon_probe()

Andreas Weber (1):
      [media] DocBook media: fix number of bits filled with zeros for SRGBB12

Andrey Utkin (4):
      [media] solo6x10: expose encoder quantization setting as V4L2 control
      [media] solo6x10: update GOP size, QP immediately
      [media] media: pvrusb2: make logging code sane
      [media] staging/media/davinci_vpfe/dm365_ipipeif.c: fix negativity check

Anil Belur (1):
      [media] staging: media: bcm2048: radio-bcm2048.c - removed IRQF_DISABLED macro

Anthony DeStefano (2):
      [media] staging: rtl2832_sdr: fixup checkpatch/style issues
      [media] staging: solo6x10: fix for sparse warning message

Antonio Ospite (2):
      [media] gspca: provide a mechanism to select a specific transfer endpoint
      [media] gspca_kinect: add support for the depth stream

Antti Palosaari (50):
      [media] si2157: implement sleep
      [media] si2168: implement sleep
      [media] si2168: set cmd args using memcpy
      [media] si2168: implement CNR statistic
      [media] si2157: add read data support for fw cmd func
      [media] si2168: remove duplicate command
      [media] si2168: do not set values which are already on default
      [media] si2168: receive 4 bytes reply from cmd 0x14
      [media] si2168: advertise Si2168 A30 firmware
      [media] si2157: advertise Si2158 A20 firmware
      [media] si2168: few firmware download changes
      [media] si2157: rework firmware download logic a little bit
      [media] v4l: uapi: add SDR format RU12LE
      [media] DocBook: V4L: add V4L2_SDR_FMT_RU12LE - 'RU12'
      [media] airspy: AirSpy SDR driver
      [media] v4l: uapi: add SDR format CS8
      [media] DocBook: V4L: add V4L2_SDR_FMT_CS8 - 'CS08'
      [media] v4l: uapi: add SDR format CS14
      [media] DocBook: V4L: add V4L2_SDR_FMT_CS14LE - 'CS14'
      msi001: move out of staging
      [media] MAINTAINERS: update MSI001 driver location
      [media] Kconfig: add SDR support
      [media] Kconfig: sub-driver auto-select SPI bus
      rtl2832_sdr: move from staging to media
      [media] rtl2832_sdr: put complex U16 format behind module parameter
      [media] rtl2832_sdr: print notice to point SDR API is not 100% stable yet
      [media] MAINTAINERS: update RTL2832_SDR location
      [media] airspy: remove v4l2-compliance workaround
      [media] airspy: move out of staging into drivers/media/usb
      [media] airspy: print notice to point SDR API is not 100% stable yet
      [media] MAINTAINERS: add airspy driver
      [media] v4l: videodev2: add buffer size to SDR format
      [media] rtl2832_sdr: fill FMT buffer size
      [media] DocBook media: v4l2_sdr_format buffersize field
      [media] airspy: fill FMT buffer size
      msi2500: move msi3101 out of staging and rename
      [media] MAINTAINERS: update MSI3101 / MSI2500 driver location
      [media] msi2500: change supported formats
      [media] msi2500: print notice to point SDR API is not 100% stable yet
      [media] msi2500: fill FMT buffer size
      [media] rtl2832_sdr: remove plain 64-bit divisions
      [media] rtl2832_sdr: fix Kconfig dependencies
      [media] msi2500: correct style issues
      [media] msi2500: refactor USB stream copying
      [media] msi2500: rename namespace msi3101 => msi2500
      [media] m88ds3103: fix SNR reporting on 32-bit arch
      [media] m88ds3103: implement BER
      [media] Kconfig: fix tuners build warnings
      [media] Kconfig: rtl2832_sdr must depend on USB
      [media] af9035: override tuner for AVerMedia A835B devices

Arnd Bergmann (2):
      [media] v4l: omap4iss: tighten omap4iss dependencies
      [media] staging: lirc: remove sa1100 support

Arun Kumar K (3):
      [media] s5p-mfc: Remove duplicate function s5p_mfc_reload_firmware
      [media] s5p-mfc: Support multiple firmware sub-versions
      [media] s5p-mfc: Add init buffer cmd to MFCV6

Ben Dooks (3):
      [media] rcar_vin: copy flags from pdata
      [media] soc_camera: add support for dt binding soc_camera drivers
      [media] rcar_vin: add devicetree support

Benoit Taine (1):
      [media] drx-j: Use kmemdup instead of kmalloc + memcpy

Christopher Reimer (1):
      [media] ddbridge: Add IDs for several newer Digital Devices cards

CrazyCat (3):
      [media] technisat-sub2: Fix stream curruption on high bitrate
      [media] cxd2820r: TS clock inversion in config
      [media] dw2102: Geniatech T220 init fixed

Daeseok Youn (1):
      [media] staging: lirc: remove redundant NULL check in unregister_from_lirc()

Dan Carpenter (4):
      [media] cx18: remove duplicate CX18_ALSA_DBGFLG_WARN define
      [media] zoran: remove duplicate ZR050_MO_COMP define
      [media] davinci: vpfe: dm365: remove duplicate RSZ_LPF_INT_MASK
      [media] dvb-frontends: decimal vs hex typo in ChannelConfiguration()

David Härdeman (11):
      [media] bt8xx: fixup RC5 decoding
      [media] rc-core: improve ir-kbd-i2c get_key functions
      [media] dib0700: NEC scancode cleanup
      [media] rc-core: document the protocol type
      [media] saa7134: NEC scancode fix
      [media] rc-core: simplify sysfs code
      [media] rc-core: remove protocol arrays
      [media] rc-core: rename dev->scanmask to dev->scancode_mask
      [media] rc-core: merge rc5 and streamzap decoders
      [media] rc-core: rename ir-raw.c
      [media] rc-core: fix various sparse warnings

Emil Goode (2):
      [media] Remove checks of struct member addresses
      [media] Cleanup line > 80 character violations

Fabian Frederick (6):
      [media] r820t: remove unnecessary break after goto
      [media] xc2028: remove unnecessary break after goto
      [media] dvb-frontends: remove unnecessary break after goto
      [media] xc5000: remove unnecessary break after goto
      [media] xc4000: remove unnecessary break after goto
      [media] drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c: remove unnecessary null test before usb_free_urb

Fabio Estevam (2):
      [media] coda: Return the real error on platform_get_irq()
      [media] coda: Propagate the correct error on devm_request_threaded_irq()

Frank Schaefer (5):
      [media] em28xx-v4l: simplify some pointers in em28xx_init_camera()
      [media] em28xx-v4l: get rid of struct em28xx_fh
      [media] em28xx-v4l: simplify em28xx_v4l2_open() by using v4l2_fh_open()
      [media] em28xx-v4l: get rid of field "users" in struct em28xx_v4l2
      [media] em28xx-v4l: fix disabling ioctl VIDIOC_S_PARM for vbi devices

Geert Uytterhoeven (1):
      [media] staging/solo6x10: SOLO6X10 should select BITREVERSE

George Spelvin (10):
      [media] ati_remote: Check the checksum
      [media] ati_remote: Shrink ati_remote_tbl structure
      [media] ati_remote: Delete superfluous input_sync()
      [media] ati_remote: Generalize KIND_ACCEL to accept diagonals
      [media] ati_remote: Shrink the ati_remote_tbl even more
      [media] ati_remote: Merge some duplicate code
      [media] ati_remote: Use non-alomic __set_bit
      [media] ati_remote: Sort buttons in top-to-bottom order
      [media] ati_remote: Add comments to keycode table
      [media] ati_remote: Better default keycodes

Guennadi Liakhovetski (1):
      [media] V4L: soc-camera: explicitly free allocated managed memory on error

Hans Verkuil (79):
      [media] em28xx: add MSI Digivox Trio support
      [media] DocBook media: fix small typo
      [media] sn9c102: remove deprecated driver
      [media] v4l2-ctrls: increase internal min/max/step/def to 64 bit
      [media] v4l2-ctrls: use pr_info/cont instead of printk
      [media] videodev2.h: add initial support for compound controls
      [media] videodev2.h: add struct v4l2_query_ext_ctrl and VIDIOC_QUERY_EXT_CTRL
      [media] v4l2-ctrls: add support for compound types
      [media] v4l2: integrate support for VIDIOC_QUERY_EXT_CTRL
      [media] v4l2-ctrls: create type_ops
      [media] v4l2-ctrls: rewrite copy routines to operate on union v4l2_ctrl_ptr
      [media] v4l2-ctrls: compare values only once
      [media] v4l2-ctrls: use ptrs for all but the s32 type
      [media] v4l2-ctrls: prepare for array support
      [media] v4l2-ctrls: prepare for array support
      [media] v4l2-ctrls: type_ops can handle array elements
      [media] v4l2-ctrls: add array support
      [media] v4l2-ctrls: return elem_size instead of strlen
      [media] v4l2-ctrl: fix error return of copy_to/from_user
      [media] DocBook media: document VIDIOC_QUERY_EXT_CTRL
      [media] DocBook media: update VIDIOC_G/S/TRY_EXT_CTRLS
      [media] DocBook media: fix coding style in the control example code
      [media] DocBook media: improve control section
      [media] DocBook media: update control section
      [media] v4l2-controls.txt: update to the new way of accessing controls
      [media] v4l2-ctrls/videodev2.h: add u8 and u16 types
      [media] DocBook media: document new u8 and u16 control types
      [media] v4l2-ctrls: fix comments
      [media] v4l2-ctrls/v4l2-controls.h: add MD controls
      [media] DocBook media: document new motion detection controls
      [media] v4l2: add a motion detection event
      [media] DocBook: document new v4l motion detection event
      [media] solo6x10: implement the new motion detection controls
      [media] solo6x10: implement the motion detection event
      [media] solo6x10: fix 'dma from stack' warning
      [media] solo6x10: check dma_map_sg() return value
      [media] go7007: add motion detection support
      [media] DocBook improvement for U8 and U16 control types
      [media] Fix 64-bit division fall-out from 64-bit control ranges
      [media] DocBook media: fix wrong spacing
      [media] DocBook media: add missing dqevent src_change field
      [media] DocBook media: fix incorrect header reference
      [media] v4l2-ioctl.c: check vfl_type in ENUM_FMT
      [media] v4l2-ioctl.c: fix enum_freq_bands handling
      [media] v4l2-dev: streamon/off is only a valid ioctl for video, vbi and sdr
      [media] videodev2.h: add V4L2_FIELD_HAS_T_OR_B macro
      [media] v4l2-dev: don't debug poll unless the debug level > 2
      [media] v4l2-ioctl: remove pointless INFO_FL_CLEAR
      [media] v4l2-ioctl: clear reserved field of G/S_SELECTION
      [media] v4l2-ioctl: call g_selection before calling cropcap
      [media] v4l2-ioctl: clips, clipcount and bitmap should not be zeroed
      [media] cx23885: add support for Hauppauge ImpactVCB-e
      [media] hdpvr: fix reported HDTV colorspace
      [media] saa7146: fix compile warning
      [media] vb2: fix bytesused == 0 handling
      [media] DocBook media: fix incorrect note about packed RGB and colorspace
      [media] go7007: update the README, fix checkpatch warnings
      [media] solo6x10: a few checkpatch fixes
      [media] videodev2.h: add defines for the VBI field start lines
      [media] DocBook media: document new VBI defines
      [media] v4l2-ctrls: fix corner case in round-to-range code
      [media] DocBook media typo
      [media] v4l2-ioctl: set V4L2_CAP_EXT_PIX_FORMAT for device_caps
      [media] v4l2-ioctl: don't set PRIV_MAGIC unconditionally in g_fmt()
      [media] solo6x10: move out of staging into drivers/media/pci.
      [media] go7007: move out of staging into drivers/media/usb.
      [media] Docbook/media: improve data_offset/bytesused documentation
      [media] v4l2-ctrls: add support for setting string controls
      [media] vb2: fix videobuf2-core.h comments
      [media] vb2: fix vb2_poll for output streams
      [media] v4l2-ctrls: add new RDS TX controls
      [media] DocBook/media: document the new RDS TX controls
      [media] si4713: add the missing RDS functionality
      [media] v4l2-ctrls: add RX RDS controls
      [media] DocBook/media: document the new RDS RX controls
      [media] radio-miropcm20: add RDS support
      [media] v4l2-ctrls: fix rounding calculation
      [media] solo6x10: fix potential null dereference
      [media] cx23885: fix UNSET/TUNER_ABSENT confusion

Heinrich Schuchardt (3):
      [media] media: dib9000: avoid out of bound access
      [media] v4l: omap4iss: configuration using uninitialized variable
      [media] media: saa7134: remove if based on uninitialized variable

Himangi Saraogi (3):
      [media] saa7164-dvb: Remove unnecessary null test
      [media] dib7000m: Remove unnecessary null test
      [media] staging: lirc: Introduce the use of managed interfaces

Ian Molton (1):
      [media] adv7180: Remove duplicate unregister call

Jacek Anaszewski (9):
      [media] s5p-mfc: Fix selective sclk_mfc init
      [media] s5p-jpeg: Document sclk-jpeg clock for Exynos3250 SoC
      [media] s5p-jpeg: Add support for Exynos3250 SoC
      [media] s5p-jpeg: return error immediately after get_byte fails
      [media] s5p-jpeg: Adjust jpeg_bound_align_image to Exynos3250 needs
      [media] s5p-jpeg: fix g_selection op
      [media] s5p-jpeg: Assure proper crop rectangle initialization
      [media] s5p-jpeg: Prevent erroneous downscaling for Exynos3250 SoC
      [media] s5p-jpeg: add chroma subsampling adjustment for Exynos3250

James Harper (3):
      [media] Fix regression in some dib0700 based devices
      [media] vmalloc_sg: make sure all pages in vmalloc area are really DMA-ready
      [media] Add support for DViCO FusionHDTV DVB-T Dual Express2

James Hogan (1):
      [media] rc: img-ir: Expand copyright headers with GPL notices

Jean Delvare (2):
      [media] V4L2: soc_camera: add run-time dependencies to R-Car VIN driver
      [media] V4L2: soc_camera: Add run-time dependencies to sh_mobile drivers

Joe Perches (2):
      [media] MAINTAINERS: Update solo6x10 patterns
      [media] MAINTAINERS: Update go7007 pattern

Josh Wu (3):
      [media] media: atmel-isi: add v4l2 async probe support
      [media] media: atmel-isi: convert the pdata from pointer to structure
      [media] media: atmel-isi: add primary DT support

Lad, Prabhakar (4):
      [media] media: davinci: vpif_capture: drop unneeded module params
      [media] media: davinci: vpif_capture: fix v4l-compliance issues
      [media] staging: media: davinci_vpfe: fix checkpatch warning
      [media] media: davinci_vpfe: dm365_resizer: fix sparse warning

Lars-Peter Clausen (1):
      [media] adv7604: Update recommended writes for the adv7611

Laurent Pinchart (39):
      [media] v4l: vsp1: Remove the unneeded vsp1_video_buffer video field
      [media] v4l: Add ARGB and XRGB pixel formats
      [media] DocBook: media: Document ALPHA_COMPONENT control usage on output devices
      [media] v4l: Support extending the v4l2_pix_format structure
      [media] v4l: Add premultiplied alpha flag for pixel formats
      [media] v4l: vb2: Fix stream start and buffer completion race
      [media] v4l: vsp1: Fix routing cleanup when stopping the stream
      [media] v4l: vsp1: Release buffers at stream stop
      [media] v4l: vsp1: Fix pipeline stop timeout
      [media] v4l: vsp1: Fix typos
      [media] v4l: vsp1: Cleanup video nodes at removal time
      [media] v4l: vsp1: Propagate vsp1_device_get errors to the callers
      [media] v4l: vsp1: Setup control handler automatically at stream on time
      [media] v4l: vsp1: sru: Fix the intensity control default value
      [media] v4l: vsp1: sru: Make the intensity controllable during streaming
      [media] v4l: vsp1: wpf: Simplify cast to pipeline structure
      [media] v4l: vsp1: wpf: Clear RPF to WPF association at stream off time
      [media] v4l: vsp1: Switch to XRGB formats
      [media] v4l: vsp1: Add alpha channel support to the memory ports
      [media] v4l: vsp1: Add V4L2_CID_ALPHA_COMPONENT control support
      [media] v4l: vsp1: bru: Support premultiplied alpha at the BRU inputs
      [media] v4l: vsp1: bru: Support non-premultiplied colors at the BRU output
      [media] v4l: vsp1: bru: Make the background color configurable
      [media] v4l: vsp1: uds: Fix scaling of alpha layer
      [media] v4l: vb2: Don't return POLLERR during transient buffer underruns
      [media] v4l: vb2: Add fatal error condition flag
      [media] v4l: omap4iss: Don't reinitialize the video qlock at every streamon
      [media] v4l: omap4iss: Add module debug parameter
      [media] v4l: omap4iss: Use the devm_* managed allocators
      [media] v4l: omap4iss: Signal fatal errors to the vb2 queue
      [media] MAINTAINERS: Add the OMAP4 ISS driver
      [media] v4l: noon010p30: Return V4L2_FIELD_NONE from pad-level set format
      [media] v4l: s5k4ecgx: Return V4L2_FIELD_NONE from pad-level set format
      [media] v4l: s5k5baf: Return V4L2_FIELD_NONE from pad-level set format
      [media] v4l: s5k6a3: Return V4L2_FIELD_NONE from pad-level set format
      [media] v4l: smiapp: Return V4L2_FIELD_NONE from pad-level get/set format
      [media] v4l: s3c-camif: Return V4L2_FIELD_NONE from pad-level set format
      [media] tvp5150: Fix device ID kernel log message
      [media] tvp5150: Use i2c_smbus_(read|write)_byte_data

Luis Alves (4):
      [media] si2168: Set symbol rate for DVB-C
      [media] si2168: Fix i2c_add_mux_adapter return value
      [media] si2168: Remove testing for demod presence on probe
      [media] si2168: Support Si2168-A20 firmware downloading

Luke Hart (1):
      [media] radio-bcm2048.c: Fix some checkpatch.pl errors

Malcolm Priestley (1):
      [media] lmedm04: rs2000 check if interrupt urb is over due

Marcel J.E. Mol (1):
      [media] rc: Add support for decoding XMP protocol

Matthias Schwarzott (12):
      [media] cxusb: Prepare for si2157 driver getting more parameters
      [media] em28xx-dvb: Prepare for si2157 driver getting more parameters
      [media] si2157: Add support for spectral inversion
      [media] si2157: Add get_if_frequency callback
      [media] get_dvb_firmware: Add firmware extractor for si2165
      [media] si2165: Add demod driver for DVB-T only
      [media] cx23885: Add si2165 support for HVR-5500
      [media] cx231xx: prepare for i2c_client attachment
      [media] cx231xx: Add digital support for HVR 930c-HD model 1113xx
      [media] cx231xx: Add digital support for HVR930C-HD model 1114xx
      [media] cx231xx: Add support for PCTV QuatroStick 521e
      [media] cx231xx: Add support for PCTV QuatroStick 522e

Maurizio Lombardi (1):
      [media] s5p: fix error code path when failing to allocate DMA memory

Mauro Carvalho Chehab (70):
      Merge tag 'v3.16-rc1' into patchwork
      [media] drxd: get rid of EXPORT_SYMBOL(drxd_config_i2c)
      [media] dvbdev: add a dvb_detach() macro
      [media] dib7000p: rename dib7000p_attach to dib7000p_init
      [media] dib7000: export just one symbol
      [media] dib8000: rename dib8000_attach to dib8000_init
      [media] dib8000: export just one symbol
      [media] dib7000p: Add DVBv5 stats support
      [media] dib7000p: Callibrate signal strength
      [media] au0828: add missing tuner Kconfig dependency
      [media] au8522: move input_mode out one level
      [media] au8522: be sure that the setup will happen at streamon time
      [media] au8522: be sure that we'll setup audio routing at the right time
      [media] au8522: cleanup s-video settings at setup_decoder_defaults()
      [media] au8522: Fix demod analog mode setting
      [media] au0828/au8522: Add PAL-M support
      [media] au0828: Only alt setting logic when needed
      [media] au0828: don't hardcode height/width
      [media] dib8000: Fix handling of interleave bigger than 2
      [media] dib8000: Fix ADC OFF settings
      [media] dib8000: Fix alignments at dib8000_tune()
      [media] dib8000: Fix: add missing 4K FFT mode
      [media] dib8000: remove a double call for dib8000_get_symbol_duration()
      [media] dib8000: In auto-search, try first with partial reception enabled
      [media] dib8000: Restart sad during dib8000_reset
      [media] dib0700: better document struct init
      [media] dib8000: Fix the sleep time at the state machine
      [media] dib0090: Fix the sleep time at the state machine
      [media] dib8000: use jifies instead of current_kernel_time()
      [media] dib8000: Update the ADC gain table
      [media] dib8000: improve debug messages
      [media] dib8000: improve the message that reports per-layer locks
      Merge tag 'v3.16-rc5' into HEAD
      Merge branch 'sched_warn_fix' into patchwork
      staging/airspy: fix a compilation warning
      [media] v4l2-subdev: Fix compilation when !VIDEO_V4L2_SUBDEV_API
      Merge commit '67dd8f35c2d8ed80f26c9654b474cffc11c6674d' into patchwork
      [media] tuners/Kconfig: fix build when just DTV or SDR is enabled
      [media] si2168: Fix a badly solved merge conflict
      [media] mb86a20s: fix ISDB-T mode handling
      [media] mb86a20s: Fix Interleaving
      [media] mb86a20s: Fix the code that estimates the measurement interval
      [media] xc4000: Update firmware name
      [media] xc4000: add module meta-tag with the firmware names
      [media] xc5000: Fix get_frequency()
      [media] xc4000: Fix get_frequency()
      [media] DocBook: Fix ISDB-T Interleaving property
      [media] cxusb: increase buffer length to 80 bytes
      [media] radio-miropcm20: fix a compilation warning
      [media] rc-core: don't use dynamic_pr_debug for IR_dprintk()
      [media] cx23885 now needs to select dib0070
      [media] update cx23885 and em28xx cardlists
      [media] cx23885-dvb: remove previously overriden value
      [media] remove some new warnings on drxj
      [media] cx231xx: Fix the max number of interfaces
      [media] cx231xx: Don't let an interface number to go past the array
      [media] cx231xx: use devm_ functions to allocate memory
      [media] cx231xx: move analog init code to a separate function
      [media] cx231xx: return an error if it can't read PCB config
      [media] cx231xx: handle errors at read_eeprom()
      [media] mceusb: add support for newer cx231xx devices
      [media] mceusb: select default keytable based on vendor
      si2135: Declare the structs even if frontend is not enabled
      [media] au0828: improve I2C speed
      [media] rc-main: allow raw protocol drivers to restrict the allowed protos
      [media] ir-rc5-decoder: print where decoding fails
      [media] au0828: add support for IR on HVR-950Q
      [media] xc5000: Don't try forever to load the firmware
      [media] xc5000: optimize firmware retry logic
      [media] xc5000: always write at dmesg when it fails to upload firmware

Michael Olbrich (2):
      [media] v4l2-mem2mem: export v4l2_m2m_try_schedule
      [media] coda: try to schedule a decode run after a stop command

Olli Salonen (8):
      [media] si2168: Small typo fix (SI2157 -> SI2168)
      [media] si2168: Add support for chip revision Si2168 A30
      [media] si2157: Move chip initialization to si2157_init
      [media] si2157: Add support for Si2158 chip
      [media] si2157: Set delivery system and bandwidth before tuning
      [media] cxusb: TechnoTrend CT2-4400 USB DVB-T2/C tuner support
      [media] si2168: improve scanning performance
      [media] si2157: Use name si2157_ops instead of si2157_tuner_ops

Ovidiu Toader (1):
      [media] staging/media/rtl2832u_sdr: fix coding style problems by adding blank lines

Paul Bolle (2):
      [media] dm644x_ccdc: remove check for CONFIG_DM644X_VIDEO_PORT_ENABLE
      [media] sms: Remove CONFIG_ prefix from Kconfig symbols

Peter Meerwald (1):
      [media] media:platform: OMAP3 camera support needs VIDEOBUF2_DMA_CONTIG

Peter Senna Tschudin (2):
      [media] drivers/media/usb/usbvision/usbvision-core.c: Remove useless return variables
      [media] drivers/media: Remove useless return variables

Philipp Zabel (38):
      [media] mem2mem: make queue lock in v4l2_m2m_poll interruptible
      [media] videobuf2-dma-contig: allow to vmap contiguous dma buffers
      [media] coda: fix decoder I/P/B frame detection
      [media] coda: fix readback of CODA_RET_DEC_SEQ_FRAME_NEED
      [media] coda: fix h.264 quantization parameter range
      [media] coda: fix internal framebuffer allocation size
      [media] coda: simplify IRAM setup
      [media] mt9v032: fix hblank calculation
      [media] mt9v032: do not clear reserved bits in read mode register
      [media] mt9v032: add support for mt9v022 and mt9v024
      [media] mt9v032: register v4l2 asynchronous subdevice
      [media] mt9v032: use regmap
      [media] coda: Add encoder/decoder support for CODA960
      [media] coda: remove BUG() in get_q_data
      [media] coda: add selection API support for h.264 decoder
      [media] coda: add workqueue to serialize hardware commands
      [media] coda: Use mem-to-mem ioctl helpers
      [media] coda: use ctx->fh.m2m_ctx instead of ctx->m2m_ctx
      [media] coda: Add runtime pm support
      [media] coda: split firmware version check out of coda_hw_init
      [media] coda: select GENERIC_ALLOCATOR
      [media] coda: add h.264 min/max qp controls
      [media] coda: add h.264 deblocking filter controls
      [media] coda: add cyclic intra refresh control
      [media] coda: add decoder timestamp queue
      [media] coda: alert userspace about macroblock errors
      [media] coda: add sequence counter offset
      [media] coda: rename prescan_failed to hold and stop stream after timeout
      [media] coda: add reset control support
      [media] coda: add bytesperline to queue data
      [media] coda: allow odd width, but still round up bytesperline
      [media] coda: round up internal frames to multiples of macroblock size for h.264
      [media] coda: increase frame stride to 16 for h.264
      [media] coda: export auxiliary buffers via debugfs
      [media] coda: store per-context work buffer size in struct coda_devtype
      [media] coda: store global temporary buffer size in struct coda_devtype
      [media] coda: store IRAM size in struct coda_devtype
      [media] coda: fix build error by making reset control optional

Prabhakar Lad (1):
      [media] media: davinci: vpif: fix array out of bound warnings

Pranith Kumar (1):
      [media] update reference, kerneltrap.org no longer works

Raimonds Cicans (1):
      [media] Fix typo in comments

Ramakrishnan Muthukrishnan (4):
      [media] media: v4l2-core: remove the use of V4L2_FL_USE_FH_PRIO flag
      [media] media: remove the setting of the flag V4L2_FL_USE_FH_PRIO
      [media] media: v4l2-dev.h: remove V4L2_FL_USE_FH_PRIO flag
      [media] media: Documentation: remove V4L2_FL_USE_FH_PRIO flag

Raphael Poggi (2):
      [media] staging: lirc: fix checkpath errors: blank lines
      [media] staging: lirc: remove return void function

Rasmus Villemoes (1):
      [media] staging: omap4iss: Fix type of struct iss_device::crashed

Rickard Strandqvist (1):
      [media] media: usb: dvb-usb-v2: mxl111sf.c: Cleaning up uninitialized variables

Robert Jarzmik (4):
      [media] media: mt9m111: add device-tree documentation
      [media] media: soc_camera: pxa_camera documentation device-tree support
      [media] media: mt9m111: add device-tree suppport
      [media] media: pxa_camera device-tree support

Sakari Ailus (5):
      [media] smiapp: I2C address is the last part of the subdev name
      [media] v4l: ctrls: Move control lock/unlock above the control access functions
      [media] v4l: ctrls: Provide an unlocked variant of v4l2_ctrl_modify_range()
      [media] v4l: ctrls: Unlocked variants of v4l2_ctrl_s_ctrl{,_int64}()
      [media] v4l: subdev: Unify argument validation across IOCTLs

Salva Peiró (1):
      [media] media-device: Remove duplicated memset() in media_enum_entities()

Sebastian (1):
      [media] rtl28xxu: add [1b80:d3b0] Sveon STV21

Shuah Khan (11):
      [media] media: em28xx-dvb - fix em28xx_dvb_resume() to not unregister i2c and dvb
      [media] media: em28xx - add error handling for KWORLD dvb_attach failures
      [media] media: em28xx - remove reset_resume interface
      [media] media: em28xx - fix i2c_xfer to return -ENODEV when dev is removed
      [media] media: dvb-core move fe exit flag from fepriv to fe for driver access
      [media] media: em28xx-dvb update fe exit flag to indicate device disconnect
      [media] media: drx39xyj driver change to check fe exit flag from release
      [media] media: dvb-core add new flag exit flag value for resume
      [media] media: drx39xyj - add resume support
      [media] media: drx39xyj - fix to return actual error codes instead of -EIO
      [media] media: drx39xyj - use drxj_set_lna_state() and remove duplicate LNA code

Sonic Zhang (3):
      [media] media: blackfin: ppi: Pass device pointer to request peripheral pins
      [media] v4l2: bfin: Ensure delete and reinit list entry on NOMMU architecture
      [media] v4l2: blackfin: select proper pinctrl state in ppi_set_params if CONFIG_PINCTRL is enabled

Vitaly Osipov (1):
      [media] v4l: omap4iss: Copy paste error in iss_get_clocks

Wei Yongjun (1):
      [media] radio-miropcm20: fix sparse NULL pointer warning

Zhaowei Yuan (1):
      [media] s5p-mfc: remove unnecessary calling to function video_devdata()

Zheng Di (1):
      [media] staging: media: lirc_parallel.c: fix coding style

panpan liu (1):
      [media] s5p-mfc: limit the size of the CPB

 Documentation/DocBook/media/Makefile               |    2 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml    |   44 +-
 Documentation/DocBook/media/v4l/controls.xml       |  408 ++-
 Documentation/DocBook/media/v4l/dev-raw-vbi.xml    |   12 +-
 Documentation/DocBook/media/v4l/dev-sdr.xml        |   18 +-
 Documentation/DocBook/media/v4l/dev-sliced-vbi.xml |    9 +-
 Documentation/DocBook/media/v4l/io.xml             |    9 +-
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |  418 ++-
 .../DocBook/media/v4l/pixfmt-sdr-cs08.xml          |   44 +
 .../DocBook/media/v4l/pixfmt-sdr-cs14le.xml        |   47 +
 .../DocBook/media/v4l/pixfmt-sdr-ru12le.xml        |   40 +
 Documentation/DocBook/media/v4l/pixfmt-srggb12.xml |    2 +-
 Documentation/DocBook/media/v4l/pixfmt.xml         |   61 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |   95 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |    8 +
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   50 +
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   51 +-
 Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml  |   12 +-
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   40 +-
 .../DocBook/media/v4l/vidioc-querycap.xml          |    6 +
 .../DocBook/media/v4l/vidioc-queryctrl.xml         |  234 +-
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |    8 +
 .../devicetree/bindings/media/atmel-isi.txt        |   51 +
 .../bindings/media/exynos-jpeg-codec.txt           |   12 +-
 .../devicetree/bindings/media/i2c/mt9m111.txt      |   28 +
 .../devicetree/bindings/media/pxa-camera.txt       |   43 +
 .../devicetree/bindings/media/rcar_vin.txt         |   86 +
 .../devicetree/bindings/media/sunxi-ir.txt         |   23 +
 Documentation/dvb/get_dvb_firmware                 |   33 +-
 Documentation/video4linux/CARDLIST.cx23885         |    2 +
 Documentation/video4linux/CARDLIST.em28xx          |    2 +-
 Documentation/video4linux/v4l2-controls.txt        |   63 +-
 Documentation/video4linux/v4l2-framework.txt       |    8 +-
 Documentation/video4linux/v4l2-pci-skeleton.c      |    5 -
 Documentation/zh_CN/video4linux/v4l2-framework.txt |    7 +-
 MAINTAINERS                                        |   52 +-
 drivers/hid/hid-picolcd_cir.c                      |    2 +-
 drivers/media/Kconfig                              |   12 +-
 drivers/media/common/saa7146/saa7146_fops.c        |   14 +-
 drivers/media/common/siano/Kconfig                 |    3 +-
 drivers/media/common/siano/smsir.c                 |    2 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |    2 +
 drivers/media/dvb-core/dvb_frontend.c              |   36 +-
 drivers/media/dvb-core/dvb_frontend.h              |    6 +
 drivers/media/dvb-core/dvbdev.h                    |    4 +
 drivers/media/dvb-frontends/Kconfig                |   18 +
 drivers/media/dvb-frontends/Makefile               |    7 +
 drivers/media/dvb-frontends/af9013.c               |    1 -
 drivers/media/dvb-frontends/au8522_decoder.c       |  180 +-
 drivers/media/dvb-frontends/au8522_priv.h          |    2 +
 drivers/media/dvb-frontends/cxd2820r.h             |    6 +
 drivers/media/dvb-frontends/cxd2820r_c.c           |    1 +
 drivers/media/dvb-frontends/cxd2820r_t.c           |    1 +
 drivers/media/dvb-frontends/cxd2820r_t2.c          |    1 +
 drivers/media/dvb-frontends/dib0090.c              |   15 +-
 drivers/media/dvb-frontends/dib7000m.c             |    5 +-
 drivers/media/dvb-frontends/dib7000p.c             |  433 ++-
 drivers/media/dvb-frontends/dib7000p.h             |  131 +-
 drivers/media/dvb-frontends/dib8000.c              |  732 +++--
 drivers/media/dvb-frontends/dib8000.h              |  150 +-
 drivers/media/dvb-frontends/dib9000.c              |   13 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |  228 +-
 drivers/media/dvb-frontends/drxd.h                 |    1 -
 drivers/media/dvb-frontends/drxd_hard.c            |    3 +-
 drivers/media/dvb-frontends/m88ds3103.c            |   85 +-
 drivers/media/dvb-frontends/m88ds3103_priv.h       |    2 +
 drivers/media/dvb-frontends/mb86a20s.c             |   35 +-
 .../dvb-frontends}/rtl2832_sdr.c                   |  100 +-
 .../dvb-frontends}/rtl2832_sdr.h                   |    0
 drivers/media/dvb-frontends/si2165.c               | 1040 ++++++
 drivers/media/dvb-frontends/si2165.h               |   62 +
 drivers/media/dvb-frontends/si2165_priv.h          |   23 +
 drivers/media/dvb-frontends/si2168.c               |  266 +-
 drivers/media/dvb-frontends/si2168_priv.h          |    9 +-
 drivers/media/dvb-frontends/stb6100_cfg.h          |   42 +-
 drivers/media/dvb-frontends/stb6100_proc.h         |   34 +-
 drivers/media/dvb-frontends/stv0367.c              |    9 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |    2 +-
 drivers/media/dvb-frontends/tda18271c2dd_maps.h    |    8 +-
 drivers/media/dvb-frontends/tda8261_cfg.h          |   30 +-
 drivers/media/i2c/Kconfig                          |    1 +
 drivers/media/i2c/adv7180.c                        |    1 -
 drivers/media/i2c/adv7604.c                        |    5 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |   95 +-
 drivers/media/i2c/mt9v032.c                        |  170 +-
 drivers/media/i2c/noon010pc30.c                    |    1 +
 drivers/media/i2c/s5k4ecgx.c                       |    1 +
 drivers/media/i2c/s5k5baf.c                        |    2 +
 drivers/media/i2c/s5k6a3.c                         |    1 +
 drivers/media/i2c/smiapp/smiapp-core.c             |   17 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |    6 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |   12 +
 drivers/media/i2c/soc_camera/mt9t031.c             |    6 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |    4 +-
 drivers/media/i2c/tvp5150.c                        |   35 +-
 drivers/media/media-device.c                       |    2 -
 drivers/media/parport/bw-qcam.c                    |    3 -
 drivers/media/parport/c-qcam.c                     |    1 -
 drivers/media/parport/pms.c                        |    1 -
 drivers/media/parport/w9966.c                      |    1 -
 drivers/media/pci/Kconfig                          |    1 +
 drivers/media/pci/Makefile                         |    1 +
 drivers/media/pci/bt8xx/bttv-driver.c              |    1 -
 drivers/media/pci/bt8xx/bttv-input.c               |   78 +-
 drivers/media/pci/bt8xx/bttvp.h                    |    2 -
 drivers/media/pci/cx18/cx18-alsa.h                 |    1 -
 drivers/media/pci/cx18/cx18-ioctl.c                |    1 -
 drivers/media/pci/cx18/cx18-streams.c              |    1 -
 drivers/media/pci/cx23885/Kconfig                  |    2 +
 drivers/media/pci/cx23885/cx23885-417.c            |    8 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |   61 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |  175 +-
 drivers/media/pci/cx23885/cx23885-input.c          |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   11 +-
 drivers/media/pci/cx23885/cx23885.h                |    2 +
 drivers/media/pci/cx25821/cx25821-video.c          |    4 -
 drivers/media/pci/cx88/cx88-core.c                 |    1 -
 drivers/media/pci/cx88/cx88-input.c                |   38 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |   35 +-
 drivers/media/pci/dm1105/dm1105.c                  |    3 +-
 drivers/media/pci/ivtv/ivtv-controls.c             |    4 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |    9 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |    3 -
 drivers/media/pci/ivtv/ivtv-streams.c              |    1 -
 drivers/media/pci/meye/meye.c                      |    3 -
 drivers/media/pci/ngene/ngene-core.c               |    7 +-
 drivers/media/pci/saa7134/saa7134-core.c           |    1 -
 drivers/media/pci/saa7134/saa7134-empress.c        |    4 -
 drivers/media/pci/saa7134/saa7134-input.c          |   86 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    2 -
 drivers/media/pci/saa7164/saa7164-dvb.c            |   32 +-
 .../{staging/media => media/pci}/solo6x10/Kconfig  |    3 +-
 .../{staging/media => media/pci}/solo6x10/Makefile |    2 +-
 .../media => media/pci}/solo6x10/solo6x10-core.c   |    6 +-
 .../media => media/pci}/solo6x10/solo6x10-disp.c   |   20 +-
 .../media => media/pci}/solo6x10/solo6x10-eeprom.c |    4 -
 .../media => media/pci}/solo6x10/solo6x10-enc.c    |    4 -
 .../media => media/pci}/solo6x10/solo6x10-g723.c   |    4 -
 .../media => media/pci}/solo6x10/solo6x10-gpio.c   |    4 -
 .../media => media/pci}/solo6x10/solo6x10-i2c.c    |    4 -
 .../media => media/pci}/solo6x10/solo6x10-jpeg.h   |    6 +-
 .../pci}/solo6x10/solo6x10-offsets.h               |    4 -
 .../media => media/pci}/solo6x10/solo6x10-p2m.c    |    4 -
 .../media => media/pci}/solo6x10/solo6x10-regs.h   |    4 -
 .../media => media/pci}/solo6x10/solo6x10-tw28.c   |    5 +-
 .../media => media/pci}/solo6x10/solo6x10-tw28.h   |    4 -
 .../pci}/solo6x10/solo6x10-v4l2-enc.c              |  207 +-
 .../media => media/pci}/solo6x10/solo6x10-v4l2.c   |    9 +-
 .../media => media/pci}/solo6x10/solo6x10.h        |   30 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    2 -
 drivers/media/pci/ttpci/budget-ci.c                |   10 +-
 drivers/media/pci/zoran/zr36050.h                  |    1 -
 drivers/media/platform/Kconfig                     |    7 +-
 drivers/media/platform/arv.c                       |    1 -
 drivers/media/platform/blackfin/bfin_capture.c     |    9 +-
 drivers/media/platform/blackfin/ppi.c              |   25 +-
 drivers/media/platform/coda.c                      | 1518 ++++++---
 drivers/media/platform/coda.h                      |  115 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |    5 -
 drivers/media/platform/davinci/vpbe_display.c      |    1 -
 drivers/media/platform/davinci/vpfe_capture.c      |    1 -
 drivers/media/platform/davinci/vpif_capture.c      |  248 +-
 drivers/media/platform/davinci/vpif_capture.h      |   11 -
 drivers/media/platform/davinci/vpif_display.c      |    4 +-
 drivers/media/platform/m2m-deinterlace.c           |    7 +-
 drivers/media/platform/mem2mem_testdev.c           |    1 -
 drivers/media/platform/omap/omap_vout.c            |    2 -
 drivers/media/platform/s3c-camif/camif-capture.c   |    3 +-
 drivers/media/platform/s5p-jpeg/Makefile           |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  660 +++-
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   32 +-
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.c   |  487 +++
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.h   |   60 +
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  247 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   17 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   11 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   49 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    9 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |   24 +
 drivers/media/platform/s5p-tv/mixer_video.c        |    2 -
 drivers/media/platform/sh_veu.c                    |    2 -
 drivers/media/platform/soc_camera/Kconfig          |   18 +-
 drivers/media/platform/soc_camera/Makefile         |    1 -
 drivers/media/platform/soc_camera/atmel-isi.c      |   90 +-
 drivers/media/platform/soc_camera/mx1_camera.c     |  866 -----
 drivers/media/platform/soc_camera/pxa_camera.c     |   81 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |   82 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  141 +-
 drivers/media/platform/vino.c                      |    5 -
 drivers/media/platform/vivi.c                      |   11 +-
 drivers/media/platform/vsp1/vsp1.h                 |   14 +-
 drivers/media/platform/vsp1/vsp1_bru.c             |   85 +-
 drivers/media/platform/vsp1/vsp1_bru.h             |    9 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |   22 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |   42 +
 drivers/media/platform/vsp1/vsp1_entity.h          |   10 +
 drivers/media/platform/vsp1/vsp1_regs.h            |    2 +
 drivers/media/platform/vsp1/vsp1_rpf.c             |   72 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |    2 +
 drivers/media/platform/vsp1/vsp1_sru.c             |  107 +-
 drivers/media/platform/vsp1/vsp1_sru.h             |    1 -
 drivers/media/platform/vsp1/vsp1_uds.c             |   63 +-
 drivers/media/platform/vsp1/vsp1_uds.h             |    6 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  219 +-
 drivers/media/platform/vsp1/vsp1_video.h           |   11 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   72 +-
 drivers/media/radio/dsbr100.c                      |    1 -
 drivers/media/radio/radio-cadet.c                  |    1 -
 drivers/media/radio/radio-isa.c                    |    1 -
 drivers/media/radio/radio-keene.c                  |    3 +-
 drivers/media/radio/radio-ma901.c                  |    1 -
 drivers/media/radio/radio-miropcm20.c              |  304 +-
 drivers/media/radio/radio-mr800.c                  |    3 +-
 drivers/media/radio/radio-raremono.c               |    1 -
 drivers/media/radio/radio-sf16fmi.c                |    1 -
 drivers/media/radio/radio-si476x.c                 |    1 -
 drivers/media/radio/radio-tea5764.c                |    1 -
 drivers/media/radio/radio-tea5777.c                |    1 -
 drivers/media/radio/radio-timb.c                   |    1 -
 drivers/media/radio/si470x/radio-si470x-usb.c      |    1 -
 drivers/media/radio/si4713/radio-platform-si4713.c |    1 -
 drivers/media/radio/si4713/radio-usb-si4713.c      |    1 -
 drivers/media/radio/si4713/si4713.c                |   80 +-
 drivers/media/radio/si4713/si4713.h                |    9 +
 drivers/media/radio/tea575x.c                      |    1 -
 drivers/media/rc/Kconfig                           |   32 +-
 drivers/media/rc/Makefile                          |    5 +-
 drivers/media/rc/ati_remote.c                      |  159 +-
 drivers/media/rc/ene_ir.c                          |    2 +-
 drivers/media/rc/fintek-cir.c                      |    6 +-
 drivers/media/rc/gpio-ir-recv.c                    |    4 +-
 drivers/media/rc/iguanair.c                        |    2 +-
 drivers/media/rc/img-ir/img-ir-core.c              |    5 +
 drivers/media/rc/img-ir/img-ir-hw.c                |   31 +-
 drivers/media/rc/img-ir/img-ir-hw.h                |    8 +-
 drivers/media/rc/img-ir/img-ir-jvc.c               |    9 +-
 drivers/media/rc/img-ir/img-ir-nec.c               |    9 +-
 drivers/media/rc/img-ir/img-ir-raw.c               |    5 +
 drivers/media/rc/img-ir/img-ir-raw.h               |    5 +
 drivers/media/rc/img-ir/img-ir-sanyo.c             |    9 +-
 drivers/media/rc/img-ir/img-ir-sharp.c             |    9 +-
 drivers/media/rc/img-ir/img-ir-sony.c              |   17 +-
 drivers/media/rc/img-ir/img-ir.h                   |    5 +
 drivers/media/rc/imon.c                            |   20 +-
 drivers/media/rc/ir-jvc-decoder.c                  |    4 +-
 drivers/media/rc/ir-lirc-codec.c                   |    2 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |    2 +-
 drivers/media/rc/ir-nec-decoder.c                  |    4 +-
 drivers/media/rc/ir-rc5-decoder.c                  |   85 +-
 drivers/media/rc/ir-rc5-sz-decoder.c               |  154 -
 drivers/media/rc/ir-rc6-decoder.c                  |   43 +-
 drivers/media/rc/ir-sanyo-decoder.c                |    4 +-
 drivers/media/rc/ir-sharp-decoder.c                |    4 +-
 drivers/media/rc/ir-sony-decoder.c                 |   16 +-
 drivers/media/rc/ir-xmp-decoder.c                  |  225 ++
 drivers/media/rc/ite-cir.c                         |    6 +-
 drivers/media/rc/keymaps/rc-ati-x10.c              |   92 +-
 drivers/media/rc/keymaps/rc-behold.c               |   68 +-
 drivers/media/rc/keymaps/rc-nebula.c               |  112 +-
 drivers/media/rc/keymaps/rc-streamzap.c            |    4 +-
 drivers/media/rc/mceusb.c                          |   33 +-
 drivers/media/rc/nuvoton-cir.c                     |    6 +-
 drivers/media/rc/rc-core-priv.h                    |   20 +-
 drivers/media/rc/{ir-raw.c => rc-ir-raw.c}         |   12 +-
 drivers/media/rc/rc-loopback.c                     |    2 +-
 drivers/media/rc/rc-main.c                         |  301 +-
 drivers/media/rc/redrat3.c                         |    2 +-
 drivers/media/rc/st_rc.c                           |    2 +-
 drivers/media/rc/streamzap.c                       |   12 +-
 drivers/media/rc/sunxi-cir.c                       |  318 ++
 drivers/media/rc/ttusbir.c                         |    2 +-
 drivers/media/rc/winbond-cir.c                     |    2 +-
 drivers/media/tuners/Kconfig                       |   11 +-
 drivers/media/tuners/Makefile                      |    1 +
 .../media/msi3101 => media/tuners}/msi001.c        |    2 +-
 drivers/media/tuners/r820t.c                       |    3 +-
 drivers/media/tuners/si2157.c                      |  257 +-
 drivers/media/tuners/si2157.h                      |    7 +-
 drivers/media/tuners/si2157_priv.h                 |    9 +-
 drivers/media/tuners/tuner-xc2028.c                |    1 -
 drivers/media/tuners/xc4000.c                      |   48 +-
 drivers/media/tuners/xc5000.c                      |  164 +-
 drivers/media/usb/Kconfig                          |    7 +
 drivers/media/usb/Makefile                         |    3 +
 drivers/media/usb/airspy/Kconfig                   |   10 +
 drivers/media/usb/airspy/Makefile                  |    1 +
 drivers/media/usb/airspy/airspy.c                  | 1132 +++++++
 drivers/media/usb/au0828/Kconfig                   |    8 +
 drivers/media/usb/au0828/Makefile                  |    4 +
 drivers/media/usb/au0828/au0828-cards.c            |    7 +-
 drivers/media/usb/au0828/au0828-core.c             |   25 +-
 drivers/media/usb/au0828/au0828-i2c.c              |   37 +-
 drivers/media/usb/au0828/au0828-input.c            |  386 +++
 drivers/media/usb/au0828/au0828-video.c            |   62 +-
 drivers/media/usb/au0828/au0828.h                  |   11 +
 drivers/media/usb/cpia2/cpia2_v4l.c                |    1 -
 drivers/media/usb/cx231xx/Kconfig                  |    2 +
 drivers/media/usb/cx231xx/cx231xx-417.c            |    3 -
 drivers/media/usb/cx231xx/cx231xx-avcore.c         |    1 +
 drivers/media/usb/cx231xx/cx231xx-cards.c          |  403 ++-
 drivers/media/usb/cx231xx/cx231xx-core.c           |    3 +
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |  105 +
 drivers/media/usb/cx231xx/cx231xx-input.c          |   22 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c        |   10 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h        |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   14 +-
 drivers/media/usb/cx231xx/cx231xx.h                |    2 +
 drivers/media/usb/dvb-usb-v2/Kconfig               |    1 +
 drivers/media/usb/dvb-usb-v2/af9015.c              |   18 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |   28 +-
 drivers/media/usb/dvb-usb-v2/anysee.c              |    3 +-
 drivers/media/usb/dvb-usb-v2/az6007.c              |   25 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |    2 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |   34 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |    2 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   14 +-
 drivers/media/usb/dvb-usb/Kconfig                  |    3 +
 drivers/media/usb/dvb-usb/cxusb.c                  |  233 +-
 drivers/media/usb/dvb-usb/cxusb.h                  |    2 +
 drivers/media/usb/dvb-usb/dib0700_core.c           |   45 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |  636 ++--
 drivers/media/usb/dvb-usb/dibusb.h                 |    2 +-
 drivers/media/usb/dvb-usb/dvb-usb-remote.c         |    2 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |   21 +-
 drivers/media/usb/dvb-usb/m920x.c                  |    2 +-
 drivers/media/usb/dvb-usb/pctv452e.c               |    8 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |    2 +-
 drivers/media/usb/dvb-usb/ttusb2.c                 |    6 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |    4 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |    3 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   40 +-
 drivers/media/usb/em28xx/em28xx-i2c.c              |    6 +
 drivers/media/usb/em28xx/em28xx-input.c            |  106 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  116 +-
 drivers/media/usb/em28xx/em28xx.h                  |    8 -
 .../{staging/media => media/usb}/go7007/Kconfig    |    0
 .../{staging/media => media/usb}/go7007/Makefile   |    4 -
 .../media => media/usb}/go7007/go7007-driver.c     |  133 +-
 .../media => media/usb}/go7007/go7007-fw.c         |   32 +-
 .../media => media/usb}/go7007/go7007-i2c.c        |    4 -
 .../media => media/usb}/go7007/go7007-loader.c     |    4 -
 .../media => media/usb}/go7007/go7007-priv.h       |   20 +-
 .../media => media/usb}/go7007/go7007-usb.c        |    4 -
 .../media => media/usb}/go7007/go7007-v4l2.c       |  322 +-
 .../media => media/usb}/go7007/s2250-board.c       |    9 +-
 .../media => media/usb}/go7007/snd-go7007.c        |    4 -
 drivers/media/usb/gspca/autogain_functions.c       |    4 +-
 drivers/media/usb/gspca/gspca.c                    |   29 +-
 drivers/media/usb/gspca/gspca.h                    |    1 +
 drivers/media/usb/gspca/kinect.c                   |   98 +-
 drivers/media/usb/gspca/pac7302.c                  |    8 +-
 drivers/media/usb/gspca/sonixb.c                   |    2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |    4 +-
 drivers/media/usb/msi2500/Kconfig                  |    5 +
 drivers/media/usb/msi2500/Makefile                 |    1 +
 .../sdr-msi3101.c => media/usb/msi2500/msi2500.c}  |  818 ++---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   12 +-
 drivers/media/usb/pwc/pwc-if.c                     |    1 -
 drivers/media/usb/s2255/s2255drv.c                 |    1 -
 drivers/media/usb/stk1160/stk1160-v4l.c            |    1 -
 drivers/media/usb/stkwebcam/stk-webcam.c           |    3 -
 drivers/media/usb/tlg2300/pd-main.c                |    2 +
 drivers/media/usb/tlg2300/pd-radio.c               |    1 -
 drivers/media/usb/tlg2300/pd-video.c               |    1 -
 drivers/media/usb/tm6000/tm6000-input.c            |   55 +-
 drivers/media/usb/tm6000/tm6000-video.c            |    3 -
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  |    3 +-
 drivers/media/usb/usbtv/usbtv-core.c               |    2 +
 drivers/media/usb/usbtv/usbtv-video.c              |    1 -
 drivers/media/usb/usbvision/usbvision-core.c       |   16 +-
 drivers/media/usb/uvc/uvc_driver.c                 |    1 -
 drivers/media/usb/zr364xx/zr364xx.c                |    4 -
 drivers/media/v4l2-core/v4l2-common.c              |    6 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   19 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  971 ++++--
 drivers/media/v4l2-core/v4l2-dev.c                 |   14 +-
 drivers/media/v4l2-core/v4l2-fh.c                  |   13 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  239 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   11 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |  125 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c          |   62 +-
 drivers/media/v4l2-core/videobuf2-core.c           |  129 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |    8 +
 drivers/staging/media/Kconfig                      |   10 -
 drivers/staging/media/Makefile                     |    5 -
 drivers/staging/media/bcm2048/radio-bcm2048.c      |   22 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |    2 +
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.h    |    1 -
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |    5 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |    4 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    1 -
 drivers/staging/media/go7007/README                |  137 -
 drivers/staging/media/go7007/go7007.h              |   40 -
 drivers/staging/media/go7007/go7007.txt            |  478 ---
 drivers/staging/media/go7007/saa7134-go7007.c      |  567 ----
 drivers/staging/media/lirc/lirc_igorplugusb.c      |    6 -
 drivers/staging/media/lirc/lirc_imon.c             |    9 +-
 drivers/staging/media/lirc/lirc_parallel.c         |   32 +-
 drivers/staging/media/lirc/lirc_serial.c           |   37 +-
 drivers/staging/media/lirc/lirc_sir.c              |  301 +-
 drivers/staging/media/msi3101/Kconfig              |   10 -
 drivers/staging/media/msi3101/Makefile             |    2 -
 drivers/staging/media/omap4iss/iss.c               |   86 +-
 drivers/staging/media/omap4iss/iss.h               |    2 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |    2 +-
 drivers/staging/media/omap4iss/iss_video.c         |   22 +-
 drivers/staging/media/rtl2832u_sdr/Kconfig         |    7 -
 drivers/staging/media/rtl2832u_sdr/Makefile        |    6 -
 drivers/staging/media/sn9c102/Kconfig              |   17 -
 drivers/staging/media/sn9c102/Makefile             |   15 -
 drivers/staging/media/sn9c102/sn9c102.h            |  214 --
 drivers/staging/media/sn9c102/sn9c102.txt          |  592 ----
 drivers/staging/media/sn9c102/sn9c102_config.h     |   86 -
 drivers/staging/media/sn9c102/sn9c102_core.c       | 3465 --------------------
 drivers/staging/media/sn9c102/sn9c102_devtable.h   |  145 -
 drivers/staging/media/sn9c102/sn9c102_hv7131d.c    |  269 --
 drivers/staging/media/sn9c102/sn9c102_hv7131r.c    |  369 ---
 drivers/staging/media/sn9c102/sn9c102_mi0343.c     |  352 --
 drivers/staging/media/sn9c102/sn9c102_mi0360.c     |  453 ---
 drivers/staging/media/sn9c102/sn9c102_mt9v111.c    |  260 --
 drivers/staging/media/sn9c102/sn9c102_ov7630.c     |  634 ----
 drivers/staging/media/sn9c102/sn9c102_ov7660.c     |  546 ---
 drivers/staging/media/sn9c102/sn9c102_pas106b.c    |  308 --
 drivers/staging/media/sn9c102/sn9c102_pas202bcb.c  |  340 --
 drivers/staging/media/sn9c102/sn9c102_sensor.h     |  307 --
 drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c |  154 -
 drivers/staging/media/sn9c102/sn9c102_tas5110d.c   |  119 -
 drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c |  165 -
 drivers/staging/media/solo6x10/TODO                |   15 -
 include/media/atmel-isi.h                          |    4 +
 include/media/blackfin/ppi.h                       |    4 +-
 include/media/ir-kbd-i2c.h                         |    6 +-
 include/media/rc-core.h                            |   71 +-
 include/media/rc-map.h                             |   16 +-
 include/media/v4l2-ctrls.h                         |  222 +-
 include/media/v4l2-dev.h                           |    2 -
 include/media/v4l2-ioctl.h                         |    2 +
 include/media/v4l2-mem2mem.h                       |    2 +
 include/media/videobuf-dma-sg.h                    |    3 +
 include/media/videobuf2-core.h                     |   19 +-
 include/uapi/linux/v4l2-controls.h                 |   32 +
 include/uapi/linux/videodev2.h                     |  101 +-
 443 files changed, 16107 insertions(+), 17303 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cs08.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cs14le.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-ru12le.xml
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isi.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m111.txt
 create mode 100644 Documentation/devicetree/bindings/media/pxa-camera.txt
 create mode 100644 Documentation/devicetree/bindings/media/rcar_vin.txt
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-ir.txt
 rename drivers/{staging/media/rtl2832u_sdr => media/dvb-frontends}/rtl2832_sdr.c (94%)
 rename drivers/{staging/media/rtl2832u_sdr => media/dvb-frontends}/rtl2832_sdr.h (100%)
 create mode 100644 drivers/media/dvb-frontends/si2165.c
 create mode 100644 drivers/media/dvb-frontends/si2165.h
 create mode 100644 drivers/media/dvb-frontends/si2165_priv.h
 rename drivers/{staging/media => media/pci}/solo6x10/Kconfig (93%)
 rename drivers/{staging/media => media/pci}/solo6x10/Makefile (82%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-core.c (98%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-disp.c (95%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-eeprom.c (94%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-enc.c (97%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-g723.c (98%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-gpio.c (92%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-i2c.c (97%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-jpeg.h (96%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-offsets.h (93%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-p2m.c (97%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-regs.h (99%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.c (99%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.h (91%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2-enc.c (90%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2.c (98%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10.h (89%)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.h
 delete mode 100644 drivers/media/platform/soc_camera/mx1_camera.c
 delete mode 100644 drivers/media/rc/ir-rc5-sz-decoder.c
 create mode 100644 drivers/media/rc/ir-xmp-decoder.c
 rename drivers/media/rc/{ir-raw.c => rc-ir-raw.c} (97%)
 create mode 100644 drivers/media/rc/sunxi-cir.c
 rename drivers/{staging/media/msi3101 => media/tuners}/msi001.c (99%)
 create mode 100644 drivers/media/usb/airspy/Kconfig
 create mode 100644 drivers/media/usb/airspy/Makefile
 create mode 100644 drivers/media/usb/airspy/airspy.c
 create mode 100644 drivers/media/usb/au0828/au0828-input.c
 rename drivers/{staging/media => media/usb}/go7007/Kconfig (100%)
 rename drivers/{staging/media => media/usb}/go7007/Makefile (68%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-driver.c (86%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-fw.c (97%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-i2c.c (96%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-loader.c (94%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-priv.h (90%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-usb.c (99%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-v4l2.c (80%)
 rename drivers/{staging/media => media/usb}/go7007/s2250-board.c (98%)
 rename drivers/{staging/media => media/usb}/go7007/snd-go7007.c (97%)
 create mode 100644 drivers/media/usb/msi2500/Kconfig
 create mode 100644 drivers/media/usb/msi2500/Makefile
 rename drivers/{staging/media/msi3101/sdr-msi3101.c => media/usb/msi2500/msi2500.c} (60%)
 delete mode 100644 drivers/staging/media/go7007/README
 delete mode 100644 drivers/staging/media/go7007/go7007.h
 delete mode 100644 drivers/staging/media/go7007/go7007.txt
 delete mode 100644 drivers/staging/media/go7007/saa7134-go7007.c
 delete mode 100644 drivers/staging/media/msi3101/Kconfig
 delete mode 100644 drivers/staging/media/msi3101/Makefile
 delete mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
 delete mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile
 delete mode 100644 drivers/staging/media/sn9c102/Kconfig
 delete mode 100644 drivers/staging/media/sn9c102/Makefile
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102.h
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102.txt
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_config.h
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_core.c
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_devtable.h
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_hv7131d.c
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_hv7131r.c
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_mi0343.c
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_mi0360.c
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_mt9v111.c
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_ov7630.c
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_ov7660.c
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_pas106b.c
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_pas202bcb.c
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_sensor.h
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_tas5110d.c
 delete mode 100644 drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
 delete mode 100644 drivers/staging/media/solo6x10/TODO

