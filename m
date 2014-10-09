Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbaJIRTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:19:04 -0400
Received: from lists.s-osg.org ([54.187.51.154]:40108 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaJIRSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:18:55 -0400
Date: Thu, 9 Oct 2014 14:18:49 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.18-rc1] media updates
Message-ID: <20141009141849.137e738d@recife.lan>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.18-rc1

For the media patches for v3.18-rc1:

- new IR driver: hix5hd2-ir

- the virtual test driver (vivi) was replaced by vivid, with has
  an almost complete set of features to emulate most v4l2 devices
  and properly test all sorts of userspace apps;

- the as102 driver had several bugs fixed and was properly split
  into a frontend and a core driver. With that, it got promoted from
  staging into mainstream;

- one new CI driver got added for CIMaX SP2/SP2HF (sp2 driver);

- one new frontend driver for Toshiba ISDB-T/ISDB-S demod (tc90522);

- one new PCI driver for ISDB-T/ISDB-S (pt3 driver);

- saa7134 driver got support for go7007-based devices;

- added a new PCI driver for Techwell 68xx chipsets (tw68);

- a new platform driver was added (coda);

- new tuner drivers: mxl301rf and qm1d1c0042;

- a new DVB USB driver was added for DVBSky S860 & similar devices;

- Added a new SDR driver (hackrf);

- usbtv got audio support;

- several platform drivers are now compiled with COMPILE_TEST;

- a series of compiler fixup patches, making sparse/spatch happier
  with the media stuff and removing several warnings, especially
  on those platform drivers that didn't use to compile on x86;

- Support for several new modern devices got added;

- lots of other fixes, improvements and cleanups.

Thanks!
Mauro

-


The following changes since commit bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9:

  Linux 3.17 (2014-10-05 12:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.18-rc1

for you to fetch changes up to a66d05d504a24894a8fdf11e4569752f313e5764:

  Merge branch 'patchwork' into v4l_for_linus (2014-10-09 14:00:54 -0300)

----------------------------------------------------------------

media updates for v3.18-rc1

----------------------------------------------------------------
Akihiro Tsukada (4):
      [media] mxl301rf: add driver for MaxLinear MxL301RF OFDM tuner
      [media] qm1d1c0042: add driver for Sharp QM1D1C0042 ISDB-S tuner
      [media] tc90522: add driver for Toshiba TC90522 quad demodulator
      [media] pt3: add support for Earthsoft PT3 ISDB-S/T receiver card

Alexey Khoroshilov (2):
      [media] mceusb: fix usbdev leak
      [media] imon: fix usbdev leaks

Amber Thrall (1):
      [media] Media: USB: usbtv: Fixed all coding style issues in usbtv source files

Andreas Ruprecht (1):
      [media] drivers: media: pci: Makefile: Remove duplicate subdirectory from obj-y

Andrey Utkin (1):
      [media] drivers/media/dvb-frontends/stv0900_sw.c: Fix break placement

Andy Shevchenko (1):
      [media] hdpvr: reduce memory footprint when debugging

Antonio Ospite (2):
      [media] trivial: drivers/media/usb/gspca/gspca.c: fix the indentation of a comment
      [media] trivial: drivers/media/usb/gspca/gspca.h: indent with TABs, not spaces

Antti Palosaari (72):
      [media] dvb-usb-v2: remove dvb_usb_device NULL check
      [media] msi2500: remove unneeded local pointer on msi2500_isoc_init()
      [media] m88ts2022: fix 32bit overflow on filter calc
      [media] m88ts2022: fix coding style issues
      [media] m88ds3103: change .set_voltage() implementation
      [media] m88ds3103: fix coding style issues
      [media] m88ts2022: rename device state (priv => dev)
      [media] m88ts2022: clean up logging
      [media] m88ts2022: convert to RegMap I2C API
      [media] m88ts2022: change parameter type of m88ts2022_cmd
      [media] airspy: fix error handling on start streaming
      [media] airspy: coding style issues
      [media] airspy: logging changes
      [media] airspy: remove unneeded spinlock irq flags initialization
      [media] airspy: enhance sample rate debug calculation precision
      [media] msi2500: logging changes
      [media] msi001: logging changes
      [media] msi2500: remove unneeded spinlock irq flags initialization
      [media] e4000: logging changes
      [media] rtl2832_sdr: remove unneeded spinlock irq flags initialization
      [media] rtl2832_sdr: enhance sample rate debug calculation precision
      [media] rtl2832_sdr: logging changes
      [media] tda18212: add support for slave chip version
      [media] af9033: provide dyn0_clk clock source
      [media] af9035: enable AF9033 demod clock source for IT9135
      [media] it913x: fix tuner sleep power leak
      [media] it913x: avoid division by zero on error case
      [media] it913x: fix IT9135 AX sleep
      [media] af9035: remove AVerMedia eeprom override
      [media] af9035: make checkpatch.pl happy
      [media] af9033: make checkpatch.pl happy
      [media] it913x: make checkpatch.pl happy
      [media] it913x: rename tuner_it913x => it913x
      [media] it913x: convert to I2C driver
      [media] it913x: change reg read/write routines more common
      [media] it913x: rename 'state' to 'dev'
      [media] it913x: convert to RegMap API
      [media] it913x: re-implement sleep
      [media] it913x: remove dead code
      [media] it913x: get rid of script loader and and private header file
      [media] it913x: refactor code largely
      [media] it913x: replace udelay polling with jiffies
      [media] af9033: fix firmware version logging
      [media] af9033: rename 'state' to 'dev'
      [media] af9033: convert to I2C client
      [media] af9033: clean up logging
      [media] af9035: few small I2C master xfer changes
      [media] af9033: remove I2C addr from config
      [media] af9035: replace PCTV device model numbers with name
      [media] MAINTAINERS: IT913X driver filenames
      [media] af9033: implement DVBv5 statistics for signal strength
      [media] af9033: implement DVBv5 statistics for CNR
      [media] af9033: wrap DVBv3 read SNR to DVBv5 CNR
      [media] af9033: implement DVBv5 stat block counters
      [media] af9033: implement DVBv5 post-Viterbi BER
      [media] af9033: wrap DVBv3 UCB to DVBv5 UCB stats
      [media] af9033: wrap DVBv3 BER to DVBv5 BER
      [media] af9033: remove all DVBv3 stat calculation logic
      [media] dvb-usb-v2: add frontend_detach callback
      [media] dvb-usb-v2: add tuner_detach callback
      [media] af9035: remove I2C client differently
      [media] af9033: init DVBv5 statistics
      [media] tda18212: prepare for I2C client conversion
      [media] anysee: convert tda18212 tuner to I2C client
      [media] em28xx: convert tda18212 tuner to I2C client
      [media] tda18212: convert driver to I2C binding
      [media] tda18212: clean logging
      [media] tda18212: rename state from 'priv' to 'dev'
      [media] tda18212: convert to RegMap API
      [media] hackrf: HackRF SDR driver
      [media] MAINTAINERS: add HackRF SDR driver
      [media] pt3: fix DTV FE I2C driver load error paths

Axel Lin (9):
      [media] saa6752hs: Convert to devm_kzalloc()
      [media] ov7670: Include media/v4l2-image-sizes.h
      [media] vs6624: Include media/v4l2-image-sizes.h
      [media] soc_camera: mt9t112: Include media/v4l2-image-sizes.h
      [media] soc_camera: ov772x: Include media/v4l2-image-sizes.h
      [media] tda7432: Fix setting TDA7432_MUTE bit for TDA7432_RF register
      [media] sh_veu: Include media/v4l2-image-sizes.h
      [media] via-camera: Include media/v4l2-image-sizes.h
      [media] tvp7002: Don't update device->streaming if write to register fails

Bartlomiej Zolnierkiewicz (1):
      [media] v4l: vsp1: fix driver dependencies

Bimow Chen (1):
      [media] get_dvb_firmware: Update firmware of ITEtech IT9135

Changbing Xiong (3):
      [media] media: fix kernel deadlock due to tuner pull-out while playing
      [media] media: correct return value in dvb_demux_poll
      [media] media: check status of dmxdev->exit in poll functions of demux&dvr

CrazyCat (1):
      [media] si2168: DVB-T2 PLP selection implemented

Dan Carpenter (9):
      [media] vmalloc_sg: off by one in error handling
      [media] staging: lirc: freeing ERR_PTRs
      [media] ttusb-dec: buffer overflow in ioctl
      [media] firewire: firedtv-avc: potential buffer overflow
      [media] dvb: si21xx: buffer overflow in si21_writeregs()
      [media] firewire: firedtv-avc: fix more potential buffer overflow
      [media] as102: remove some unneeded checks
      [media] davinci: remove an unneeded check
      [media] mx2-camera: potential negative underflow bug

Fabio Estevam (1):
      [media] coda: coda-bit: Include "<linux/slab.h>"

Federico Simoncelli (1):
      [media] usbtv: add audio support

Fengguang Wu (1):
      [media] vpfe_standards[] can be static

Frank Schaefer (8):
      [media] em28xx-v4l: give back all active video buffers to the vb2 core properly on streaming stop
      [media] em28xx-v4l: fix video buffer field order reporting in progressive mode
      [media] em28xx-input: i2c IR decoders: improve i2c_client handling
      [media] em28xx: check if a device has audio earlier"
      [media] em28xx: remove some unnecessary fields from struct em28xx_audio_mode
      [media] em28xx: simplify usb audio class handling
      [media] em28xx: get rid of field has_audio in struct em28xx_audio_mode
      [media] em28xx: remove dead code line from em28xx_audio_setup()

Geert Uytterhoeven (2):
      [media] cx25840: Spelling s/compuations/computations/
      [media] cx23885: Spelling s/compuations/computations/

Guennadi Liakhovetski (1):
      [media] v4l2: uvcvideo: Allow using larger buffers

Guoxiong Yan (2):
      [media] rc: Add DT bindings for hix5hd2
      [media] rc: Introduce hix5hd2 IR transmitter driver

Hans Verkuil (94):
      [media] videobuf2: fix lockdep warning
      [media] DocBook media: fix order of v4l2_edid fields
      [media] vb2: use pr_info instead of pr_debug
      [media] vb2: fix multiplanar read() with non-zero data_offset
      [media] vivid.txt: add documentation for the vivid driver
      [media] vivid: add core driver code
      [media] vivid: add the control handling code
      [media] vivid: add the video capture and output parts
      [media] vivid: add VBI capture and output code
      [media] vivid: add the kthread code that controls the video rate
      [media] vivid: add a simple framebuffer device for overlay testing
      [media] vivid: add the Test Pattern Generator
      [media] vivid: add support for radio receivers and transmitters
      [media] vivid: add support for software defined radio
      [media] vivid: enable the vivid driver
      [media] vivi: remove driver, it's replaced by vivid
      [media] cx23885: fix querycap
      [media] cx23885: fix audio input handling
      [media] cx23885: support v4l2_fh and g/s_priority
      [media] cx23885: use core locking, switch to unlocked_ioctl
      [media] cx23885: convert to the control framework
      [media] cx23885: convert 417 to the control framework
      [media] cx23885: fix format colorspace compliance error
      [media] cx23885: map invalid fields to a valid field
      [media] cx23885: drop radio-related dead code
      [media] cx23885: drop type field from struct cx23885_fh
      [media] cx23885: drop unused clip fields from struct cx23885_fh
      [media] cx23885: fmt, width and height are global, not per-fh
      [media] cx23885: drop videobuf abuse in cx23885-alsa
      [media] cx23885: use video_drvdata to get cx23885_dev pointer
      [media] cx23885: remove FSF address as per checkpatch
      [media] img-ir: fix sparse warnings
      [media] solo6x10: fix sparse warnings
      [media] dibusb: fix sparse warnings
      [media] af9015: fix sparse warning
      [media] radio-tea5764: fix sparse warnings
      [media] dw2102: fix sparse warnings
      [media] mxl111sf: fix sparse warnings
      [media] opera1: fix sparse warnings
      [media] pctv452e: fix sparse warnings
      [media] go7007: fix sparse warnings
      [media] dib7000p: fix sparse warning
      [media] kinect: fix sparse warnings
      [media] ddbridge: fix sparse warnings
      [media] ngene: fix sparse warnings
      [media] drxj: fix sparse warnings
      [media] uvc: fix sparse warning
      [media] usbtv: fix sparse warnings
      [media] mb86a16/mb86a20s: fix sparse warnings
      [media] mantis: fix sparse warnings
      [media] wl128x: fix sparse warnings
      [media] bcm3510: fix sparse warnings
      [media] s2255drv: fix sparse warning
      [media] dvb_usb_core: fix sparse warning
      [media] pwc: fix sparse warning
      [media] stv0367: fix sparse warnings
      [media] si2165: fix sparse warning
      [media] imon: fix sparse warnings
      [media] v4l2-ioctl: fix sparse warnings
      [media] lirc_dev: fix sparse warnings
      [media] via-camera: fix sparse warning
      [media] cx25821: fix sparse warning
      [media] cx231xx: fix sparse warnings
      [media] dm1105: fix sparse warning
      [media] cxusb: fix sparse warning
      [media] cx23885: fix sparse warning
      [media] ivtv: fix sparse warnings
      [media] cx18: fix sparse warnings
      [media] em28xx: fix sparse warnings
      [media] videodev2.h: add __user to v4l2_ext_control pointers
      [media] v4l2-compat-ioctl32: fix sparse warnings
      [media] mt2063: fix sparse warnings
      [media] tw68: add original tw68 code
      [media] tw68: refactor and cleanup the tw68 driver
      [media] MAINTAINERS: add tw68 entry
      [media] vivid: remove duplicate and unused g/s_edid functions
      [media] vivid: add missing includes
      [media] vivid: tpg_reset_source prototype mismatch
      [media] cx23885: convert to vb2
      [media] cx23885: fix field handling
      [media] cx23885: remove btcx-risc dependency
      [media] cx23885: Add busy checks before changing formats
      [media] tw68: simplify tw68_buffer_count
      [media] tw68: drop bogus cpu_to_le32() call
      [media] videobuf2-core: take mmap_sem before calling __qbuf_userptr
      [media] DocBook media: fix wrong prototype
      [media] vivid: add teletext support to VBI capture
      [media] v4l2-dv-timings: only check standards if non-zero
      [media] adv7604/adv7842: fix il_vbackporch typo and zero the struct
      [media] cx23885: fix VBI support
      [media] cx23885: fix size helper functions
      [media] v4l2-ioctl.c: fix inverted condition
      [media] saa7134: also capture the WSS signal for 50 Hz VBI capture
      [media] saa7134: add saa7134-go7007

Hans Wennborg (2):
      [media] dvb: remove 0x prefix from decimal value in printf
      [media] dvb: return the error from i2c_transfer if negative

Hans de Goede (1):
      [media] videobuf: Allow reqbufs(0) to free current buffers

Himangi Saraogi (3):
      [media] radio-si470x-usb: use USB API functions rather than constants
      [media] media/rc/imon.c: use USB API functions rather than constants
      [media] rc-core: use USB API functions rather than constants

Jacek Anaszewski (4):
      [media] s5p-jpeg: Avoid assigning readl result
      [media] s5p-jpeg: remove stray call to readl
      [media] s5p-jpeg: avoid overwriting JPEG_CNTL register settings
      [media] s5p-jpeg: fix HUF_TBL_EN bit clearing path

Jingoo Han (1):
      [media] v4l: ti-vpe: Remove casting the return value which is a void pointer

Joe Perches (1):
      [media] tda18271-common: Convert _tda_printk to return void

Julia Lawall (1):
      [media] v4l: ti-vpe: use c99 initializers in structures

Kamil Debski (1):
      [media] s5p-mfc: Fix sparse errors in the MFC driver

Kazunori Kobayashi (1):
      [media] soc_camera: Support VIDIOC_EXPBUF ioctl

Laurent Pinchart (26):
      [media] v4l: subdev: Extend default link validation to cover field order
      [media] omap3isp: Don't ignore subdev streamoff failures
      [media] omap3isp: Remove boilerplate disclaimer and FSF address
      [media] omap3isp: Move non-critical code out of the mutex-protected section
      [media] omap3isp: Default to progressive field order when setting the format
      [media] omap3isp: video: Validate the video node field order
      [media] omap3isp: ccdc: Simplify the configuration function
      [media] omap3isp: ccdc: Simplify the ccdc_isr_buffer() function
      [media] omap3isp: ccdc: Add basic support for interlaced video
      [media] omap3isp: ccdc: Support the interlaced field orders at the CCDC output
      [media] omap3isp: ccdc: Add support for BT.656 YUV format at the CCDC input
      [media] omap3isp: ccdc: Disable the video port when unused
      [media] omap3isp: ccdc: Only complete buffer when all fields are captured
      [media] omap3isp: ccdc: Rename __ccdc_handle_stopping to ccdc_handle_stopping
      [media] omap3isp: ccdc: Simplify ccdc_lsc_is_configured()
      [media] omap3isp: ccdc: Increment the frame number at VD0 time for BT.656
      [media] omap3isp: ccdc: Fix freeze when a short frame is received
      [media] omap3isp: ccdc: Don't timeout on stream off when the CCDC is stopped
      [media] omap3isp: ccdc: Restart the CCDC immediately after an underrun in BT.656
      [media] omap3isp: resizer: Remove needless variable initializations
      [media] omap3isp: resizer: Remove slow debugging message from interrupt handler
      [media] omap3isp: resizer: Protect against races when updating crop
      [media] media: Use strlcpy instead of custom code
      [media] v4l: Add ARGB555X and XRGB555X pixel formats
      [media] v4l: Fix ARGB32 fourcc value in the documentation
      [media] v4l: videobuf2: Fix typos in comments

Maciej Matraszek (1):
      [media] v4l2-common: fix overflow in v4l_bound_align_image()

Maks Naumov (1):
      [media] media: stv0367: fix frontend modulation initialization with FE_CAB_MOD_QAM256

Marek Szyprowski (1):
      [media] media: s5p-mfc: rename special clock to sclk_mfc

Martin Kepplinger (1):
      [media] staging: media: as102: replace custom dprintk() with dev_dbg()

Matthias Schwarzott (5):
      [media] si2165: Load driver for all hardware revisions
      [media] si2165: enable Si2161 support
      [media] cx231xx: Add support for Hauppauge WinTV-HVR-900H (111xxx)
      [media] cx231xx: Add support for Hauppauge WinTV-HVR-901H (1114xx)
      [media] mceusb: add support for more cx231xx devices

Mauro Carvalho Chehab (180):
      Merge tag 'v3.17-rc1' into patchwork
      [media] au0828: no need to sleep at the IR code
      [media] au0828: add an option to disable IR via modprobe parameter
      [media] au0828: Enable IR for HVR-850
      [media] au0828-input: Be sure that IR is enabled at polling
      [media] au0828: avoid race conditions at RC stop
      [media] au0828: handle IR int during suspend/resume
      [media] au0828: don't let the IR polling thread to run at suspend
      [media] au0828: be sure to reenable the bridge and GPIOs on resume
      [media] au0828: Add suspend code for DVB
      [media] au0828: properly handle stream on/off state
      [media] au0828: add suspend/resume code for V4L2
      [media] au0828: Remove a bad whitespace
      [media] au0828: use pr_foo macros
      [media] au0828: add pr_info to track au0828 suspend/resume code
      [media] dvb-frontend: add core support for tuner suspend/resume
      [media] xc5000: fix xc5000 suspend
      [media] au0828: move the code that sets DTV on a separate function
      [media] xc5000: Split config and set code for analog/radio
      [media] xc5000: add a resume function
      [media] xc5000: better name the functions
      [media] au0828: fix checks if dvb is initialized
      [media] au0828: Fix DVB resume when streaming
      [media] xc5000: be sure that the firmware is there before set params
      [media] siano: add support for PCTV 77e
      [media] as102: promote it out of staging
      [media] as102: get rid of FSF mail address
      [media] as102: CodingStyle fixes
      [media] as102: better name the unknown frontend
      [media] as102: Move ancillary routines to the beggining
      [media] as102: get rid of as102_fe_copy_tune_parameters()
      [media] as102: get rid of as10x_fe_copy_tps_parameters()
      [media] as102: prepare as102_fe to be compiled as a module
      [media] as102-fe: make it an independent driver
      [media] as102: add missing viterbi lock
      [media] as102-fe: Add a release function
      [media] usbtv: Make it dependent on ALSA
      [media] vpif_display: get rid of some unused vars
      [media] vpif_capture: get rid of some unused vars
      [media] dm644x_ccdc: declare some functions as static
      [media] dm355_ccdc: declare a function as static
      [media] gsc-core: Remove useless test
      [media] gsc-m2m: Remove an unused var.
      [media] ti-vpe: use %pad for dma address
      [media] ti-vpe: shut up a casting warning message
      [media] atmel-isi: tag dma_addr_t as such
      [media] atmel-isi: Fix a truncate warning
      [media] s5p_mfc: don't use an external symbol called 'debug'
      [media] vpif: don't cast pointers to int
      [media] dm644x_ccdc: use unsigned long for fpc_table_addr
      [media] dvb_frontend: estimate bandwidth also for DVB-S/S2/Turbo
      [media] gsc: Use %pad for dma_addr_t
      [media] omap: fix compilation if !VIDEO_OMAP2_VOUT_VRFB
      [media] omap_vout: Get rid of a few warnings
      [media] s5p-jpeg: get rid of some warnings
      [media] g2d: remove unused var
      [media] fimc-is-param: get rid of warnings
      [media] s5p_mfc_ctrl: add missing s5p_mfc_ctrl.h header
      [media] s5p_mfc: get rid of several warnings
      [media] mipi-csis: get rid of a warning
      [media] exynos4-is/media-dev: get rid of a warning for a dead code
      [media] mx2_camera: get rid of a warning
      [media] atmel-isi: get rid of a warning
      [media] s5p-jpeg: Get rid of a warning
      Revert "[media] staging: omap4iss: copy paste error in iss_get_clocks"
      [media] enable COMPILE_TEST for MX2 eMMa-PrP driver
      [media] enable COMPILE_TEST for ti-vbe
      [media] allow COMPILE_TEST for SAMSUNG_EXYNOS4_IS
      [media] enable COMPILE_TEST for OMAP2 vout
      [media] enable COMPILE_TEST for media drivers
      [media] be sure that HAS_DMA is enabled for vb2-dma-contig
      [media] omap: be sure that MMU is there for COMPILE_TEST
      [media] vivid: Don't mess with namespace adding a "get_format" function
      [media] vivid: add some missing headers
      [media] vivid: Don't declare .vidioc_overlay twice
      [media] vivid: comment the unused g_edid/s_edid functions
      [media] dmxdev: don't use before checking file->private_data
      [media] marvel-ccic: don't initialize static vars with 0
      [media] soc_camera: use kmemdup()
      [media] vivid-vid-out: use memdup_user()
      [media] s5k5baf: remove an uneeded semicolon
      [media] bttv-driver: remove an uneeded semicolon
      [media] soc_camera: remove uneeded semicolons
      [media] stv0900_core: don't allocate a temporary var
      [media] em28xx: use true/false for boolean vars
      [media] tuner-core: use true/false for boolean vars
      [media] af9013: use true/false for boolean vars
      [media] cxd2820r: use true/false for boolean vars
      [media] m88ds3103: use true/false for boolean vars
      [media] af9013: use true/false for boolean vars
      [media] tda10071: use true/false for boolean vars
      [media] smiapp-core: use true/false for boolean vars
      [media] ov9740: use true/false for boolean vars
      [media] omap3isp: use true/false for boolean vars
      [media] ti-vpe: use true/false for boolean vars
      [media] vivid-tpg: use true/false for boolean vars
      [media] radio: use true/false for boolean vars
      [media] ene_ir: use true/false for boolean vars
      [media] au0828-dvb: use true/false for boolean vars
      [media] lmedm04: use true/false for boolean vars
      [media] af9005: use true/false for boolean vars
      [media] msi2500: simplify boolean tests
      [media] drxk_hard: simplify test logic
      [media] lm3560: simplify boolean tests
      [media] lm3560: simplify a boolean test
      [media] omap: simplify test logic
      [media] via-camera: simplify boolean tests
      [media] e4000: simplify boolean tests
      [media] s5p-tv: Simplify the return logic
      [media] siano: just return 0 instead of using a var
      [media] stv0367: just return 0 instead of using a var
      [media] media-devnode: just return 0 instead of using a var
      [media] bt8xx: just return 0 instead of using a var
      [media] saa7164: just return 0 instead of using a var
      [media] davinci: just return 0 instead of using a var
      [media] marvel-ccic: just return 0 instead of using a var
      [media] fintek-cir: just return 0 instead of using a var
      [media] ite-cir: just return 0 instead of using a var
      [media] nuvoton-cir: just return 0 instead of using a var
      [media] mt2060: just return 0 instead of using a var
      [media] mxl5005s: just return 0 instead of using a var
      [media] cx231xx: just return 0 instead of using a var
      [media] xc4000: Fix bad alignments
      [media] tuner-xc2028: fix bad alignments
      [media] sp8870: fix bad alignments
      [media] drxd_hard: fix bad alignments
      [media] drxk_hard: fix bad alignments
      [media] tw68: make tw68_pci_tbl static and constify
      [media] ngene: properly handle __user ptr
      [media] disable COMPILE_TEST for omap1_camera
      [media] s5p-jpeg: Fix compilation with COMPILE_TEST
      [media] vpif: Fix compilation with allmodconfig
      Merge remote-tracking branch 'linus/master' into patchwork
      [media] hackrf: Fix a long constant
      [media] em28xx: Get rid of some unused modprobe parameters at vbi code
      [media] stv0367: Remove an unused parameter
      [media] au0828-cards: remove a comment about i2c clock stretching
      [media] au0828: explicitly identify boards with analog TV
      [media] au0828: fill tuner type on all boards
      [media] dib0700_devices: Use c99 initializers for structures.
      [media] saa7134: Fix compilation breakage when go7007 is not selected
      [media] saa7134: Remove some casting warnings
      [media] saa7134: Remove unused status var
      [media] tc90522: declare tc90522_functionality as static
      [media] pt3: make pt3_pm_ops() static
      [media] qm1d1c0042: fix compilation on 32 bits
      [media] tc90522: fix compilation on 32 bits
      [media] s5p_mfc: use static for some structs
      [media] s5p_mfc_opr_v5: fix smatch warnings
      [media] s5p_mfc_opr_v6: fix wrong type for registers
      [media] s5p_mfc_opr_v6: remove address space removal warnings
      [media] v4l2-dv-timings: fix a sparse warning
      [media] as102_drv.h: added a missing newline
      [media] dvb_frontend: Fix __user namespace
      [media] as102: fix endiannes casts
      [media] ir-hix5hd2: fix address space casting
      [media] st_rc: fix address space casting
      [media] sta2x11_vip: fix address space casting
      [media] saa7164-core: declare symbols as static
      [media] pms: Fix a bad usage of the stack
      [media] radio-sf16fmi: declare pnp_attached as static
      [media] radio-sf16fmr2: declare some structs as static
      [media] cx88: fix cards table CodingStyle
      [media] cx88: remove return after BUG()
      [media] saa7146: remove return after BUG()
      [media] drxd: remove a dead code
      [media] em28xx: Fix identation
      [media] s5p_mfc_opr_v5: Fix lots of warnings on x86_64
      [media] s5p_mfc_opr_v6: get rid of warnings when compiled with 64 bits
      [media] s3c-camif: fix dma_addr_t printks
      [media] ti-vpe: Fix typecast
      [media] s5p_mfc_opr: Fix warnings
      [media] s5p-mfc: Fix several printk warnings
      [media] dvb-frontends: use %zu instead of %zd
      [media] pci drivers: use %zu instead of %zd
      [media] usb drivers: use %zu instead of %zd
      [media] exynos4-is: fix some warnings when compiling on arm64
      Revert "[media] media: em28xx - remove reset_resume interface"
      [media] ir-hix5hd2: fix build on c6x arch
      Merge branch 'patchwork' into v4l_for_linus

Michael Olbrich (2):
      [media] coda: use CODA_MAX_FRAME_SIZE everywhere
      [media] coda: delay coda_fill_bitstream()

Morgan Phillips (2):
      [media] sn9c20x.c: fix checkpatch error: that open brace { should be on the previous line
      [media] sn9c20x: fix checkpatch warning: sizeof cmatrix should be sizeof(cmatrix)

Olli Salonen (20):
      [media] si2168: clean logging
      [media] si2157: clean logging
      [media] si2168: add ts_mode setting and move to si2168_init
      [media] em28xx: add ts mode setting for PCTV 292e
      [media] cxusb: add ts mode setting for TechnoTrend CT2-4400
      [media] sp2: Add I2C driver for CIMaX SP2 common interface module
      [media] cxusb: Add support for TechnoTrend TT-connect CT2-4650 CI
      [media] cxusb: Add read_mac_address for TT CT2-4400 and CT2-4650
      [media] si2157: Add support for delivery system SYS_ATSC
      [media] si2157: change command for sleep
      [media] si2157: avoid firmware loading if it has been loaded previously
      [media] si2168: avoid firmware loading if it has been loaded previously
      [media] MAINTAINERS: add sp2 entry
      [media] si2157: Add support for Si2147-A30 tuner
      [media] cx23885: add i2c client handling into dvb_unregister and state
      [media] cx23855: add frontend set voltage function into state
      [media] cx23855: add support for DVBSky T9580 DVB-C/T2/S2 tuner
      [media] af9035: Add possibility to define which I2C adapter to use
      [media] af9035: Add support for IT930x USB bridge
      [media] si2168: add FE_CAN_MULTISTREAM into caps

Paul Fertser (1):
      [media] media: usb: uvc: add a quirk for Dell XPS M1330 webcam

Philipp Zabel (32):
      [media] coda: fix CODA7541 hardware reset
      [media] coda: initialize hardware on pm runtime resume only if firmware available
      [media] coda: remove CAPTURE and OUTPUT caps
      [media] coda: remove VB2_USERPTR from queue io_modes
      [media] coda: lock capture frame size to output frame size when streaming
      [media] coda: split userspace interface into encoder and decoder device
      [media] coda: split format enumeration for encoder end decoder device
      [media] coda: default to h.264 decoder on invalid formats
      [media] coda: mark constant structures as such
      [media] coda: move coda driver into its own directory
      [media] coda: move defines, enums, and structs into shared header
      [media] coda: add context ops
      [media] coda: move BIT processor command execution out of pic_run_work
      [media] coda: add coda_bit_stream_set_flag helper
      [media] coda: move per-instance buffer allocation and cleanup
      [media] coda: move H.264 helper function into separate file
      [media] coda: move BIT specific functions into separate file
      [media] coda: include header for memcpy
      [media] coda: remove unnecessary peek at next destination buffer from coda_finish_decode
      [media] coda: request BIT processor interrupt by name
      [media] coda: dequeue buffers if start_streaming fails
      [media] coda: dequeue buffers on streamoff
      [media] coda: skip calling coda_find_codec in encoder try_fmt_vid_out
      [media] coda: allow running coda without iram on mx6dl
      [media] coda: increase max vertical frame size to 1088
      [media] coda: add an intermediate debug level
      [media] coda: improve allocation error messages
      [media] coda: fix timestamp list handling
      [media] coda: fix coda_s_fmt_vid_out
      [media] coda: set capture frame size with output S_FMT
      [media] coda: disable old cropping ioctls
      [media] coda: checkpatch cleanup

Prabhakar Lad (6):
      [media] media: davinci: vpif_display: drop setting of vb2 buffer state to ACTIVE
      [media] media: davinci: vpif_capture: drop setting of vb2 buffer state to ACTIVE
      [media] media: videobuf2-core.h: add a helper to get status of start_streaming()
      [media] media: davinci: vpif_display: fix the check on suspend/resume callbacks
      [media] media: davinci: vpif_capture: fix the check on suspend/resume callbacks
      [media] media: davinci: remove unneeded dependency ARCH_OMAP3

Randy Dunlap (1):
      [media] media: ttpci: fix av7110 build to be compatible with CONFIG_INPUT_EVDEV

Rasmus Villemoes (2):
      [media] drivers: media: b2c2: flexcop.h: Fix typo in include guard
      [media] drivers: media: i2c: adv7343_regs.h: Fix typo in #ifndef

Sakari Ailus (6):
      [media] v4l: Add test pattern colour component controls
      [media] smiapp: Add driver-specific test pattern menu item definitions
      [media] smiapp: Implement the test pattern control
      [media] smiapp: Use unlocked __v4l2_ctrl_modify_range()
      [media] smiapp: Set 64-bit integer control using v4l2_ctrl_s_ctrl_int64()
      [media] v4l: Event documentation fixes

Sergei Shtylyov (1):
      [media] rcar_vin: fix error message in rcar_vin_get_formats()

Shuah Khan (5):
      [media] au0828: add au0828_rc_*() stubs for VIDEO_AU0828_RC disabled case
      [media] au0828: remove CONFIG_VIDEO_AU0828_RC scope around au0828_rc_*()
      [media] media: fix au0828 dvb suspend/resume to call dvb_frontend_suspend/resume
      [media] media: tuner xc5000 - release firmwware from xc5000_release()
      [media] media: tuner xc5000 - try to avoid firmware load in resume path

Sjoerd Simons (1):
      [media] s5p-mfc: Use decode status instead of display status on MFCv5

Srinivas Kandagatla (3):
      [media] media: st-rc: move to using reset_control_get_optional
      [media] media: st-rc: move pm ops setup out of conditional compilation
      [media] media: st-rc: Remove .owner field for driver

Ulf Hansson (1):
      [media] coda: Improve runtime PM support

Ulrich Eckhardt (3):
      [media] imon: Define keytables per USB Device Id
      [media] imon: Add internal key table for 15c2:0034
      [media] imon: Fix not working front panel

Vincent Palatin (2):
      [media] v4l: Add camera pan/tilt speed controls
      [media] v4l: uvcvideo: Add support for pan/tilt speed controls

Vitaly Osipov (1):
      [media] staging: omap4iss: copy paste error in iss_get_clocks

William Manley (1):
      [media] uvcvideo: Work around buggy Logitech C920 firmware

Zhaowei Yuan (4):
      [media] media: s5p_mfc: Release ctx->ctx if failed to allocate ctx->shm
      [media] media: s5p-mfc: correct improper logs
      [media] s5p_mfc: correct the loop condition
      [media] s5p_mfc: unify variable naming style

ayaka (1):
      [media] s5p-mfc: fix enum_fmt for s5p-mfc

nibble.max (4):
      [media] m88ds3103: implement set voltage and TS clock
      [media] rc: add dvbsky rc keymap macro
      [media] dvbsky: new driver to support DVBSky S860/S960 devices
      [media] rc: add a map for DVBSky devices.

 Documentation/DocBook/media/v4l/compat.xml         |    6 +
 Documentation/DocBook/media/v4l/controls.xml       |   55 +
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |   52 +-
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |    7 +-
 Documentation/DocBook/media/v4l/vidioc-g-edid.xml  |   14 +-
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |    2 +-
 .../devicetree/bindings/media/hix5hd2-ir.txt       |   25 +
 Documentation/dvb/get_dvb_firmware                 |   24 +-
 Documentation/video4linux/vivid.txt                | 1111 ++++++
 MAINTAINERS                                        |   28 +-
 drivers/media/common/b2c2/flexcop.h                |    2 +-
 drivers/media/common/saa7146/saa7146_fops.c        |    3 -
 drivers/media/common/siano/sms-cards.c             |    6 +
 drivers/media/common/siano/sms-cards.h             |    1 +
 drivers/media/common/siano/smscoreapi.c            |    4 +-
 drivers/media/dvb-core/dmxdev.c                    |    7 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |    2 +
 drivers/media/dvb-core/dvb_frontend.c              |   45 +-
 drivers/media/dvb-core/dvb_frontend.h              |    2 +
 drivers/media/dvb-core/dvb_ringbuffer.c            |   26 +
 drivers/media/dvb-core/dvb_ringbuffer.h            |    2 +
 drivers/media/dvb-frontends/Kconfig                |   20 +
 drivers/media/dvb-frontends/Makefile               |    4 +-
 drivers/media/dvb-frontends/af9013.c               |   24 +-
 drivers/media/dvb-frontends/af9033.c               |  757 ++--
 drivers/media/dvb-frontends/af9033.h               |   58 +-
 drivers/media/dvb-frontends/af9033_priv.h          |    1 +
 drivers/media/dvb-frontends/as102_fe.c             |  480 +++
 drivers/media/dvb-frontends/as102_fe.h             |   29 +
 .../dvb-frontends/as102_fe_types.h}                |    6 -
 drivers/media/dvb-frontends/bcm3510.c              |    6 +-
 drivers/media/dvb-frontends/cxd2820r_c.c           |    4 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |    4 +-
 drivers/media/dvb-frontends/cxd2820r_t.c           |    4 +-
 drivers/media/dvb-frontends/dib7000p.c             |    2 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |   38 +-
 drivers/media/dvb-frontends/drxd_hard.c            |    9 +-
 drivers/media/dvb-frontends/drxk_hard.c            |   37 +-
 drivers/media/dvb-frontends/m88ds3103.c            |  101 +-
 drivers/media/dvb-frontends/m88ds3103.h            |   35 +-
 drivers/media/dvb-frontends/mb86a16.c              |    6 +-
 drivers/media/dvb-frontends/mb86a20s.c             |   14 +-
 drivers/media/dvb-frontends/mt312.c                |    2 +-
 drivers/media/dvb-frontends/or51211.c              |    2 +-
 drivers/media/dvb-frontends/rtl2832.c              |    2 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  118 +-
 drivers/media/dvb-frontends/si2165.c               |   63 +-
 drivers/media/dvb-frontends/si2165_priv.h          |    2 +-
 drivers/media/dvb-frontends/si2168.c               |  129 +-
 drivers/media/dvb-frontends/si2168.h               |    6 +
 drivers/media/dvb-frontends/si2168_priv.h          |    2 +
 drivers/media/dvb-frontends/si21xx.c               |    3 +
 drivers/media/dvb-frontends/sp2.c                  |  441 +++
 drivers/media/dvb-frontends/sp2.h                  |   53 +
 drivers/media/dvb-frontends/sp2_priv.h             |   50 +
 drivers/media/dvb-frontends/sp8870.c               |    3 +-
 drivers/media/dvb-frontends/stv0367.c              |   12 +-
 drivers/media/dvb-frontends/stv0900_core.c         |    7 +-
 drivers/media/dvb-frontends/stv0900_sw.c           |    3 +-
 drivers/media/dvb-frontends/tc90522.c              |  840 +++++
 drivers/media/dvb-frontends/tc90522.h              |   42 +
 drivers/media/dvb-frontends/tda10071.c             |    2 +-
 drivers/media/dvb-frontends/zl10039.c              |    2 +-
 drivers/media/firewire/firedtv-avc.c               |   10 +
 drivers/media/i2c/adv7343_regs.h                   |    2 +-
 drivers/media/i2c/adv7604.c                        |    2 +-
 drivers/media/i2c/adv7842.c                        |    4 +-
 drivers/media/i2c/cx25840/cx25840-ir.c             |    2 +-
 drivers/media/i2c/lm3560.c                         |    4 +-
 drivers/media/i2c/ov7670.c                         |   14 +-
 drivers/media/i2c/s5k5baf.c                        |    2 +-
 drivers/media/i2c/saa6752hs.c                      |    6 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  143 +-
 drivers/media/i2c/smiapp/smiapp.h                  |    4 +
 drivers/media/i2c/soc_camera/mt9t112.c             |    4 +-
 drivers/media/i2c/soc_camera/ov772x.c              |    5 +-
 drivers/media/i2c/soc_camera/ov9740.c              |    4 +-
 drivers/media/i2c/tda7432.c                        |    2 +-
 drivers/media/i2c/tvp7002.c                        |   21 +-
 drivers/media/i2c/vs6624.c                         |   14 +-
 drivers/media/media-device.c                       |    6 +-
 drivers/media/media-devnode.c                      |    3 +-
 drivers/media/parport/pms.c                        |    7 +-
 drivers/media/pci/Kconfig                          |    2 +
 drivers/media/pci/Makefile                         |    3 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |    5 +-
 drivers/media/pci/bt8xx/dst_ca.c                   |    4 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.c             |    2 +-
 drivers/media/pci/cx18/cx18-firmware.c             |    6 +-
 drivers/media/pci/cx18/cx18-queue.c                |    2 +-
 drivers/media/pci/cx23885/Kconfig                  |    9 +-
 drivers/media/pci/cx23885/Makefile                 |    1 -
 drivers/media/pci/cx23885/altera-ci.c              |    8 +-
 drivers/media/pci/cx23885/altera-ci.h              |    4 -
 drivers/media/pci/cx23885/cimax2.c                 |    4 -
 drivers/media/pci/cx23885/cimax2.h                 |    4 -
 drivers/media/pci/cx23885/cx23885-417.c            |  503 +--
 drivers/media/pci/cx23885/cx23885-alsa.c           |  109 +-
 drivers/media/pci/cx23885/cx23885-av.c             |    5 -
 drivers/media/pci/cx23885/cx23885-av.h             |    5 -
 drivers/media/pci/cx23885/cx23885-cards.c          |   32 +-
 drivers/media/pci/cx23885/cx23885-core.c           |  362 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |  323 +-
 drivers/media/pci/cx23885/cx23885-f300.c           |    4 -
 drivers/media/pci/cx23885/cx23885-i2c.c            |   12 -
 drivers/media/pci/cx23885/cx23885-input.c          |    5 -
 drivers/media/pci/cx23885/cx23885-input.h          |    5 -
 drivers/media/pci/cx23885/cx23885-ioctl.c          |   10 +-
 drivers/media/pci/cx23885/cx23885-ioctl.h          |    4 -
 drivers/media/pci/cx23885/cx23885-ir.c             |    5 -
 drivers/media/pci/cx23885/cx23885-ir.h             |    5 -
 drivers/media/pci/cx23885/cx23885-reg.h            |    4 -
 drivers/media/pci/cx23885/cx23885-vbi.c            |  284 +-
 drivers/media/pci/cx23885/cx23885-video.c          | 1294 ++-----
 drivers/media/pci/cx23885/cx23885-video.h          |    5 -
 drivers/media/pci/cx23885/cx23885.h                |  136 +-
 drivers/media/pci/cx23885/cx23888-ir.c             |    7 +-
 drivers/media/pci/cx23885/cx23888-ir.h             |    5 -
 drivers/media/pci/cx23885/netup-eeprom.c           |    4 -
 drivers/media/pci/cx23885/netup-eeprom.h           |    4 -
 drivers/media/pci/cx23885/netup-init.c             |    4 -
 drivers/media/pci/cx23885/netup-init.h             |    4 -
 drivers/media/pci/cx25821/cx25821-video-upstream.c |    5 +-
 drivers/media/pci/cx88/cx88-cards.c                |  632 ++--
 drivers/media/pci/cx88/cx88-video.c                |    3 -
 drivers/media/pci/ddbridge/ddbridge-core.c         |   30 +-
 drivers/media/pci/ddbridge/ddbridge.h              |   12 +-
 drivers/media/pci/dm1105/dm1105.c                  |    2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |    2 +-
 drivers/media/pci/ivtv/ivtv-firmware.c             |    4 +-
 drivers/media/pci/ivtv/ivtv-irq.c                  |   12 +-
 drivers/media/pci/mantis/hopper_vp3028.c           |    2 +-
 drivers/media/pci/mantis/mantis_common.h           |    2 +-
 drivers/media/pci/mantis/mantis_vp1033.c           |    4 +-
 drivers/media/pci/mantis/mantis_vp1034.c           |    2 +-
 drivers/media/pci/mantis/mantis_vp1041.c           |    4 +-
 drivers/media/pci/mantis/mantis_vp2033.c           |    4 +-
 drivers/media/pci/mantis/mantis_vp2040.c           |    4 +-
 drivers/media/pci/mantis/mantis_vp3030.c           |    4 +-
 drivers/media/pci/ngene/ngene-cards.c              |    2 +-
 drivers/media/pci/ngene/ngene-core.c               |   14 +-
 drivers/media/pci/ngene/ngene-dvb.c                |    7 +-
 drivers/media/pci/ngene/ngene.h                    |    2 +-
 drivers/media/pci/pt3/Kconfig                      |   10 +
 drivers/media/pci/pt3/Makefile                     |    8 +
 drivers/media/pci/pt3/pt3.c                        |  876 +++++
 drivers/media/pci/pt3/pt3.h                        |  186 +
 drivers/media/pci/pt3/pt3_dma.c                    |  225 ++
 drivers/media/pci/pt3/pt3_i2c.c                    |  240 ++
 drivers/media/pci/saa7134/Kconfig                  |    8 +
 drivers/media/pci/saa7134/Makefile                 |    2 +
 drivers/media/pci/saa7134/saa7134-cards.c          |   29 +
 drivers/media/pci/saa7134/saa7134-core.c           |   10 +-
 drivers/media/pci/saa7134/saa7134-go7007.c         |  531 +++
 drivers/media/pci/saa7134/saa7134-vbi.c            |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    2 +-
 drivers/media/pci/saa7134/saa7134.h                |    5 +
 drivers/media/pci/saa7164/saa7164-api.c            |    3 +-
 drivers/media/pci/saa7164/saa7164-core.c           |    6 +-
 drivers/media/pci/solo6x10/Kconfig                 |    1 +
 drivers/media/pci/solo6x10/solo6x10-disp.c         |    4 +-
 drivers/media/pci/solo6x10/solo6x10-eeprom.c       |    8 +-
 drivers/media/pci/solo6x10/solo6x10.h              |    4 +-
 drivers/media/pci/sta2x11/Kconfig                  |    1 +
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    2 +-
 drivers/media/pci/ttpci/Kconfig                    |    4 +
 drivers/media/pci/ttpci/Makefile                   |    2 +-
 drivers/media/pci/ttpci/av7110.c                   |    8 +-
 drivers/media/pci/tw68/Kconfig                     |   10 +
 drivers/media/pci/tw68/Makefile                    |    3 +
 drivers/media/pci/tw68/tw68-core.c                 |  434 +++
 drivers/media/pci/tw68/tw68-reg.h                  |  195 +
 drivers/media/pci/tw68/tw68-risc.c                 |  230 ++
 drivers/media/pci/tw68/tw68-video.c                | 1051 ++++++
 drivers/media/pci/tw68/tw68.h                      |  231 ++
 drivers/media/pci/zoran/zoran_device.c             |    2 +-
 drivers/media/platform/Kconfig                     |   54 +-
 drivers/media/platform/Makefile                    |    8 +-
 drivers/media/platform/blackfin/Kconfig            |    1 +
 drivers/media/platform/coda.c                      | 3933 --------------------
 drivers/media/platform/coda/Makefile               |    3 +
 drivers/media/platform/coda/coda-bit.c             | 1861 +++++++++
 drivers/media/platform/coda/coda-common.c          | 2052 ++++++++++
 drivers/media/platform/coda/coda-h264.c            |   37 +
 drivers/media/platform/coda/coda.h                 |  287 ++
 .../media/platform/{coda.h => coda/coda_regs.h}    |    0
 drivers/media/platform/davinci/Kconfig             |   18 +-
 drivers/media/platform/davinci/dm355_ccdc.c        |    2 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |   14 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   16 +-
 drivers/media/platform/davinci/vpif.c              |    1 +
 drivers/media/platform/davinci/vpif_capture.c      |   13 +-
 drivers/media/platform/davinci/vpif_display.c      |   22 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |    6 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    3 -
 drivers/media/platform/exynos-gsc/gsc-regs.c       |    8 +-
 drivers/media/platform/exynos4-is/Kconfig          |    5 +-
 drivers/media/platform/exynos4-is/fimc-is-errno.c  |    4 +-
 drivers/media/platform/exynos4-is/fimc-is-errno.h  |    4 +-
 drivers/media/platform/exynos4-is/fimc-is-param.c  |    2 -
 drivers/media/platform/exynos4-is/fimc-is.c        |   10 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    9 +-
 drivers/media/platform/exynos4-is/media-dev.c      |    4 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |    3 +-
 drivers/media/platform/marvell-ccic/Kconfig        |    2 +
 drivers/media/platform/marvell-ccic/mcam-core.c    |    2 +-
 drivers/media/platform/mx2_emmaprp.c               |    2 +-
 drivers/media/platform/omap/Kconfig                |    2 +-
 drivers/media/platform/omap/omap_vout.c            |   16 +-
 drivers/media/platform/omap/omap_vout_vrfb.c       |   10 +-
 drivers/media/platform/omap/omap_vout_vrfb.h       |   18 +-
 drivers/media/platform/omap3isp/cfa_coef_table.h   |   10 -
 drivers/media/platform/omap3isp/gamma_table.h      |   10 -
 drivers/media/platform/omap3isp/isp.c              |   20 +-
 drivers/media/platform/omap3isp/isp.h              |   10 -
 drivers/media/platform/omap3isp/ispccdc.c          |  424 ++-
 drivers/media/platform/omap3isp/ispccdc.h          |   21 +-
 drivers/media/platform/omap3isp/ispccp2.c          |   10 -
 drivers/media/platform/omap3isp/ispccp2.h          |   10 -
 drivers/media/platform/omap3isp/ispcsi2.c          |   10 -
 drivers/media/platform/omap3isp/ispcsi2.h          |   10 -
 drivers/media/platform/omap3isp/ispcsiphy.c        |   10 -
 drivers/media/platform/omap3isp/ispcsiphy.h        |   10 -
 drivers/media/platform/omap3isp/isph3a.h           |   10 -
 drivers/media/platform/omap3isp/isph3a_aewb.c      |   10 -
 drivers/media/platform/omap3isp/isph3a_af.c        |   10 -
 drivers/media/platform/omap3isp/isphist.c          |   10 -
 drivers/media/platform/omap3isp/isphist.h          |   10 -
 drivers/media/platform/omap3isp/isppreview.c       |   10 -
 drivers/media/platform/omap3isp/isppreview.h       |   10 -
 drivers/media/platform/omap3isp/ispreg.h           |   20 +-
 drivers/media/platform/omap3isp/ispresizer.c       |   80 +-
 drivers/media/platform/omap3isp/ispresizer.h       |   13 +-
 drivers/media/platform/omap3isp/ispstat.c          |   10 -
 drivers/media/platform/omap3isp/ispstat.h          |   10 -
 drivers/media/platform/omap3isp/ispvideo.c         |   59 +-
 drivers/media/platform/omap3isp/ispvideo.h         |   12 +-
 .../media/platform/omap3isp/luma_enhance_table.h   |   10 -
 .../media/platform/omap3isp/noise_filter_table.h   |   10 -
 drivers/media/platform/s3c-camif/camif-capture.c   |    4 +-
 drivers/media/platform/s3c-camif/camif-regs.c      |    4 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    7 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    2 +-
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.c   |    2 +
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c  |   11 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c      |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   83 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   27 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_debug.h     |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   54 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   67 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |  488 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |   31 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  491 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |    2 +-
 drivers/media/platform/s5p-tv/Kconfig              |    4 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |    2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |    2 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c        |    2 +-
 drivers/media/platform/sh_veu.c                    |    4 +-
 drivers/media/platform/soc_camera/Kconfig          |   16 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |   13 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    5 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |    2 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |    4 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   21 +-
 drivers/media/platform/ti-vpe/vpdma.c              |    4 +-
 drivers/media/platform/ti-vpe/vpe.c                |   20 +-
 drivers/media/platform/via-camera.c                |   13 +-
 drivers/media/platform/vivi.c                      | 1542 --------
 drivers/media/platform/vivid/Kconfig               |   19 +
 drivers/media/platform/vivid/Makefile              |    6 +
 drivers/media/platform/vivid/vivid-core.c          | 1390 +++++++
 drivers/media/platform/vivid/vivid-core.h          |  520 +++
 drivers/media/platform/vivid/vivid-ctrls.c         | 1502 ++++++++
 drivers/media/platform/vivid/vivid-ctrls.h         |   34 +
 drivers/media/platform/vivid/vivid-kthread-cap.c   |  886 +++++
 drivers/media/platform/vivid/vivid-kthread-cap.h   |   26 +
 drivers/media/platform/vivid/vivid-kthread-out.c   |  305 ++
 drivers/media/platform/vivid/vivid-kthread-out.h   |   26 +
 drivers/media/platform/vivid/vivid-osd.c           |  400 ++
 drivers/media/platform/vivid/vivid-osd.h           |   27 +
 drivers/media/platform/vivid/vivid-radio-common.c  |  189 +
 drivers/media/platform/vivid/vivid-radio-common.h  |   40 +
 drivers/media/platform/vivid/vivid-radio-rx.c      |  287 ++
 drivers/media/platform/vivid/vivid-radio-rx.h      |   31 +
 drivers/media/platform/vivid/vivid-radio-tx.c      |  141 +
 drivers/media/platform/vivid/vivid-radio-tx.h      |   29 +
 drivers/media/platform/vivid/vivid-rds-gen.c       |  166 +
 drivers/media/platform/vivid/vivid-rds-gen.h       |   53 +
 drivers/media/platform/vivid/vivid-sdr-cap.c       |  499 +++
 drivers/media/platform/vivid/vivid-sdr-cap.h       |   34 +
 drivers/media/platform/vivid/vivid-tpg-colors.c    |  310 ++
 drivers/media/platform/vivid/vivid-tpg-colors.h    |   64 +
 drivers/media/platform/vivid/vivid-tpg.c           | 1439 +++++++
 drivers/media/platform/vivid/vivid-tpg.h           |  439 +++
 drivers/media/platform/vivid/vivid-vbi-cap.c       |  371 ++
 drivers/media/platform/vivid/vivid-vbi-cap.h       |   40 +
 drivers/media/platform/vivid/vivid-vbi-gen.c       |  323 ++
 drivers/media/platform/vivid/vivid-vbi-gen.h       |   33 +
 drivers/media/platform/vivid/vivid-vbi-out.c       |  248 ++
 drivers/media/platform/vivid/vivid-vbi-out.h       |   34 +
 drivers/media/platform/vivid/vivid-vid-cap.c       | 1730 +++++++++
 drivers/media/platform/vivid/vivid-vid-cap.h       |   71 +
 drivers/media/platform/vivid/vivid-vid-common.c    |  571 +++
 drivers/media/platform/vivid/vivid-vid-common.h    |   61 +
 drivers/media/platform/vivid/vivid-vid-out.c       | 1146 ++++++
 drivers/media/platform/vivid/vivid-vid-out.h       |   56 +
 drivers/media/radio/radio-gemtek.c                 |    2 +-
 drivers/media/radio/radio-sf16fmi.c                |    6 +-
 drivers/media/radio/radio-sf16fmr2.c               |    4 +-
 drivers/media/radio/radio-tea5764.c                |   12 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    4 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |    4 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   11 +-
 drivers/media/radio/wl128x/fmdrv_rx.c              |   10 +-
 drivers/media/radio/wl128x/fmdrv_tx.c              |    2 +-
 drivers/media/rc/Kconfig                           |   15 +-
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/ene_ir.c                          |    2 +-
 drivers/media/rc/fintek-cir.c                      |    6 +-
 drivers/media/rc/img-ir/img-ir-hw.c                |    6 -
 drivers/media/rc/img-ir/img-ir-hw.h                |    6 +
 drivers/media/rc/imon.c                            |  304 +-
 drivers/media/rc/ir-hix5hd2.c                      |  351 ++
 drivers/media/rc/ite-cir.c                         |    3 +-
 drivers/media/rc/keymaps/Makefile                  |    1 +
 drivers/media/rc/keymaps/rc-dvbsky.c               |   78 +
 drivers/media/rc/lirc_dev.c                        |   14 +-
 drivers/media/rc/mceusb.c                          |   15 +-
 drivers/media/rc/nuvoton-cir.c                     |    6 +-
 drivers/media/rc/st_rc.c                           |   16 +-
 drivers/media/rc/streamzap.c                       |    6 +-
 drivers/media/tuners/Kconfig                       |   17 +
 drivers/media/tuners/Makefile                      |    4 +-
 drivers/media/tuners/e4000.c                       |   75 +-
 drivers/media/tuners/it913x.c                      |  478 +++
 drivers/media/tuners/{tuner_it913x.h => it913x.h}  |   41 +-
 drivers/media/tuners/m88ts2022.c                   |  355 +-
 drivers/media/tuners/m88ts2022_priv.h              |    5 +-
 drivers/media/tuners/msi001.c                      |   56 +-
 drivers/media/tuners/mt2060.c                      |    3 +-
 drivers/media/tuners/mt2063.c                      |   26 +-
 drivers/media/tuners/mxl301rf.c                    |  349 ++
 drivers/media/tuners/mxl301rf.h                    |   26 +
 drivers/media/tuners/mxl5005s.c                    |    3 +-
 drivers/media/tuners/qm1d1c0042.c                  |  448 +++
 drivers/media/tuners/qm1d1c0042.h                  |   37 +
 drivers/media/tuners/si2157.c                      |   86 +-
 drivers/media/tuners/si2157.h                      |    2 +-
 drivers/media/tuners/si2157_priv.h                 |    3 +-
 drivers/media/tuners/tda18212.c                    |  272 +-
 drivers/media/tuners/tda18212.h                    |   19 +-
 drivers/media/tuners/tda18271-common.c             |   19 +-
 drivers/media/tuners/tda18271-priv.h               |    4 +-
 drivers/media/tuners/tuner-xc2028.c                |   62 +-
 drivers/media/tuners/tuner_it913x.c                |  453 ---
 drivers/media/tuners/tuner_it913x_priv.h           |   78 -
 drivers/media/tuners/xc4000.c                      |   62 +-
 drivers/media/tuners/xc5000.c                      |  242 +-
 drivers/media/usb/Kconfig                          |    4 +-
 drivers/media/usb/Makefile                         |    4 +-
 drivers/media/usb/airspy/airspy.c                  |  222 +-
 drivers/{staging/media => media/usb}/as102/Kconfig |    0
 .../{staging/media => media/usb}/as102/Makefile    |    3 +-
 .../{staging/media => media/usb}/as102/as102_drv.c |  152 +-
 .../{staging/media => media/usb}/as102/as102_drv.h |   26 +-
 .../{staging/media => media/usb}/as102/as102_fw.c  |    4 -
 .../{staging/media => media/usb}/as102/as102_fw.h  |    4 -
 .../media => media/usb}/as102/as102_usb_drv.c      |   53 +-
 .../media => media/usb}/as102/as102_usb_drv.h      |    4 -
 .../{staging/media => media/usb}/as102/as10x_cmd.c |   23 +-
 .../{staging/media => media/usb}/as102/as10x_cmd.h |  108 +-
 .../media => media/usb}/as102/as10x_cmd_cfg.c      |    9 +-
 .../media => media/usb}/as102/as10x_cmd_stream.c   |    4 -
 .../media => media/usb}/as102/as10x_handle.h       |    7 +-
 drivers/media/usb/au0828/au0828-cards.c            |   36 +-
 drivers/media/usb/au0828/au0828-core.c             |   84 +-
 drivers/media/usb/au0828/au0828-dvb.c              |  110 +-
 drivers/media/usb/au0828/au0828-i2c.c              |   15 +-
 drivers/media/usb/au0828/au0828-input.c            |   36 +-
 drivers/media/usb/au0828/au0828-vbi.c              |    4 +-
 drivers/media/usb/au0828/au0828-video.c            |   90 +-
 drivers/media/usb/au0828/au0828.h                  |   34 +-
 drivers/media/usb/cx231xx/cx231xx-avcore.c         |   14 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   10 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |    2 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |    8 +-
 drivers/media/usb/dvb-usb-v2/Kconfig               |    7 +
 drivers/media/usb/dvb-usb-v2/Makefile              |    3 +
 drivers/media/usb/dvb-usb-v2/af9015.c              |    2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |  644 +++-
 drivers/media/usb/dvb-usb-v2/af9035.h              |   12 +-
 drivers/media/usb/dvb-usb-v2/anysee.c              |  185 +-
 drivers/media/usb/dvb-usb-v2/anysee.h              |    3 +
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |    3 +
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   28 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c         |    2 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |  460 +++
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |    2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |    8 +-
 drivers/media/usb/dvb-usb/Kconfig                  |    2 +-
 drivers/media/usb/dvb-usb/af9005.c                 |    2 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |  130 +-
 drivers/media/usb/dvb-usb/cxusb.h                  |    4 +
 drivers/media/usb/dvb-usb/dib0700_devices.c        |  383 +-
 drivers/media/usb/dvb-usb/dibusb-common.c          |   12 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |   14 +-
 drivers/media/usb/dvb-usb/opera1.c                 |    4 +-
 drivers/media/usb/dvb-usb/pctv452e.c               |    8 +-
 drivers/media/usb/em28xx/em28xx-audio.c            |   10 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   43 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   47 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   37 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   29 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |   11 -
 drivers/media/usb/em28xx/em28xx-video.c            |   29 +-
 drivers/media/usb/em28xx/em28xx.h                  |   19 +-
 drivers/media/usb/go7007/go7007-usb.c              |    4 +-
 drivers/media/usb/gspca/gspca.c                    |    5 +-
 drivers/media/usb/gspca/gspca.h                    |    2 +-
 drivers/media/usb/gspca/kinect.c                   |   12 +-
 drivers/media/usb/gspca/sn9c20x.c                  |   12 +-
 drivers/media/usb/hackrf/Kconfig                   |   10 +
 drivers/media/usb/hackrf/Makefile                  |    1 +
 drivers/media/usb/hackrf/hackrf.c                  | 1142 ++++++
 drivers/media/usb/hdpvr/hdpvr-control.c            |   21 +-
 drivers/media/usb/hdpvr/hdpvr-core.c               |   27 +-
 drivers/media/usb/msi2500/msi2500.c                |  174 +-
 drivers/media/usb/pwc/pwc-v4l.c                    |    2 +-
 drivers/media/usb/s2255/s2255drv.c                 |    2 +-
 drivers/media/usb/siano/smsusb.c                   |    6 +-
 drivers/media/usb/ttusb-dec/ttusbdecfe.c           |    3 +
 drivers/media/usb/usbtv/Kconfig                    |    3 +-
 drivers/media/usb/usbtv/Makefile                   |    3 +-
 drivers/media/usb/usbtv/usbtv-audio.c              |  385 ++
 drivers/media/usb/usbtv/usbtv-core.c               |   17 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   18 +-
 drivers/media/usb/usbtv/usbtv.h                    |   21 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   60 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   20 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |    1 +
 drivers/media/usb/uvc/uvc_video.c                  |   10 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    5 +-
 drivers/media/v4l2-core/tuner-core.c               |   10 +-
 drivers/media/v4l2-core/v4l2-common.c              |    9 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   30 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |    6 +
 drivers/media/v4l2-core/v4l2-dv-timings.c          |    3 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    6 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |    9 +
 drivers/media/v4l2-core/videobuf-core.c            |   11 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c          |    6 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   66 +-
 drivers/staging/media/Kconfig                      |    2 -
 drivers/staging/media/Makefile                     |    1 -
 drivers/staging/media/as102/as102_fe.c             |  571 ---
 drivers/staging/media/davinci_vpfe/Kconfig         |    1 +
 drivers/staging/media/dt3155v4l/Kconfig            |    1 +
 drivers/staging/media/lirc/lirc_imon.c             |    1 +
 drivers/staging/media/lirc/lirc_sasem.c            |    1 +
 drivers/staging/media/omap4iss/Kconfig             |    1 +
 include/media/davinci/dm644x_ccdc.h                |    2 +-
 include/media/omap3isp.h                           |    3 +
 include/media/rc-map.h                             |    1 +
 include/media/videobuf2-core.h                     |   15 +-
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/smiapp.h                        |   29 +
 include/uapi/linux/v4l2-controls.h                 |    6 +
 include/uapi/linux/v4l2-dv-timings.h               |    9 -
 include/uapi/linux/videodev2.h                     |   13 +-
 475 files changed, 36215 insertions(+), 13052 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/hix5hd2-ir.txt
 create mode 100644 Documentation/video4linux/vivid.txt
 create mode 100644 drivers/media/dvb-frontends/as102_fe.c
 create mode 100644 drivers/media/dvb-frontends/as102_fe.h
 rename drivers/{staging/media/as102/as10x_types.h => media/dvb-frontends/as102_fe_types.h} (95%)
 create mode 100644 drivers/media/dvb-frontends/sp2.c
 create mode 100644 drivers/media/dvb-frontends/sp2.h
 create mode 100644 drivers/media/dvb-frontends/sp2_priv.h
 create mode 100644 drivers/media/dvb-frontends/tc90522.c
 create mode 100644 drivers/media/dvb-frontends/tc90522.h
 create mode 100644 drivers/media/pci/pt3/Kconfig
 create mode 100644 drivers/media/pci/pt3/Makefile
 create mode 100644 drivers/media/pci/pt3/pt3.c
 create mode 100644 drivers/media/pci/pt3/pt3.h
 create mode 100644 drivers/media/pci/pt3/pt3_dma.c
 create mode 100644 drivers/media/pci/pt3/pt3_i2c.c
 create mode 100644 drivers/media/pci/saa7134/saa7134-go7007.c
 create mode 100644 drivers/media/pci/tw68/Kconfig
 create mode 100644 drivers/media/pci/tw68/Makefile
 create mode 100644 drivers/media/pci/tw68/tw68-core.c
 create mode 100644 drivers/media/pci/tw68/tw68-reg.h
 create mode 100644 drivers/media/pci/tw68/tw68-risc.c
 create mode 100644 drivers/media/pci/tw68/tw68-video.c
 create mode 100644 drivers/media/pci/tw68/tw68.h
 delete mode 100644 drivers/media/platform/coda.c
 create mode 100644 drivers/media/platform/coda/Makefile
 create mode 100644 drivers/media/platform/coda/coda-bit.c
 create mode 100644 drivers/media/platform/coda/coda-common.c
 create mode 100644 drivers/media/platform/coda/coda-h264.c
 create mode 100644 drivers/media/platform/coda/coda.h
 rename drivers/media/platform/{coda.h => coda/coda_regs.h} (100%)
 delete mode 100644 drivers/media/platform/vivi.c
 create mode 100644 drivers/media/platform/vivid/Kconfig
 create mode 100644 drivers/media/platform/vivid/Makefile
 create mode 100644 drivers/media/platform/vivid/vivid-core.c
 create mode 100644 drivers/media/platform/vivid/vivid-core.h
 create mode 100644 drivers/media/platform/vivid/vivid-ctrls.c
 create mode 100644 drivers/media/platform/vivid/vivid-ctrls.h
 create mode 100644 drivers/media/platform/vivid/vivid-kthread-cap.c
 create mode 100644 drivers/media/platform/vivid/vivid-kthread-cap.h
 create mode 100644 drivers/media/platform/vivid/vivid-kthread-out.c
 create mode 100644 drivers/media/platform/vivid/vivid-kthread-out.h
 create mode 100644 drivers/media/platform/vivid/vivid-osd.c
 create mode 100644 drivers/media/platform/vivid/vivid-osd.h
 create mode 100644 drivers/media/platform/vivid/vivid-radio-common.c
 create mode 100644 drivers/media/platform/vivid/vivid-radio-common.h
 create mode 100644 drivers/media/platform/vivid/vivid-radio-rx.c
 create mode 100644 drivers/media/platform/vivid/vivid-radio-rx.h
 create mode 100644 drivers/media/platform/vivid/vivid-radio-tx.c
 create mode 100644 drivers/media/platform/vivid/vivid-radio-tx.h
 create mode 100644 drivers/media/platform/vivid/vivid-rds-gen.c
 create mode 100644 drivers/media/platform/vivid/vivid-rds-gen.h
 create mode 100644 drivers/media/platform/vivid/vivid-sdr-cap.c
 create mode 100644 drivers/media/platform/vivid/vivid-sdr-cap.h
 create mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.c
 create mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.h
 create mode 100644 drivers/media/platform/vivid/vivid-tpg.c
 create mode 100644 drivers/media/platform/vivid/vivid-tpg.h
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-cap.c
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-cap.h
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-gen.c
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-gen.h
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-out.c
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-out.h
 create mode 100644 drivers/media/platform/vivid/vivid-vid-cap.c
 create mode 100644 drivers/media/platform/vivid/vivid-vid-cap.h
 create mode 100644 drivers/media/platform/vivid/vivid-vid-common.c
 create mode 100644 drivers/media/platform/vivid/vivid-vid-common.h
 create mode 100644 drivers/media/platform/vivid/vivid-vid-out.c
 create mode 100644 drivers/media/platform/vivid/vivid-vid-out.h
 create mode 100644 drivers/media/rc/ir-hix5hd2.c
 create mode 100644 drivers/media/rc/keymaps/rc-dvbsky.c
 create mode 100644 drivers/media/tuners/it913x.c
 rename drivers/media/tuners/{tuner_it913x.h => it913x.h} (67%)
 create mode 100644 drivers/media/tuners/mxl301rf.c
 create mode 100644 drivers/media/tuners/mxl301rf.h
 create mode 100644 drivers/media/tuners/qm1d1c0042.c
 create mode 100644 drivers/media/tuners/qm1d1c0042.h
 delete mode 100644 drivers/media/tuners/tuner_it913x.c
 delete mode 100644 drivers/media/tuners/tuner_it913x_priv.h
 rename drivers/{staging/media => media/usb}/as102/Kconfig (100%)
 rename drivers/{staging/media => media/usb}/as102/Makefile (65%)
 rename drivers/{staging/media => media/usb}/as102/as102_drv.c (66%)
 rename drivers/{staging/media => media/usb}/as102/as102_drv.h (75%)
 rename drivers/{staging/media => media/usb}/as102/as102_fw.c (96%)
 rename drivers/{staging/media => media/usb}/as102/as102_fw.h (83%)
 rename drivers/{staging/media => media/usb}/as102/as102_usb_drv.c (90%)
 rename drivers/{staging/media => media/usb}/as102/as102_usb_drv.h (90%)
 rename drivers/{staging/media => media/usb}/as102/as10x_cmd.c (92%)
 rename drivers/{staging/media => media/usb}/as102/as10x_cmd.h (89%)
 rename drivers/{staging/media => media/usb}/as102/as10x_cmd_cfg.c (93%)
 rename drivers/{staging/media => media/usb}/as102/as10x_cmd_stream.c (96%)
 rename drivers/{staging/media => media/usb}/as102/as10x_handle.h (88%)
 create mode 100644 drivers/media/usb/dvb-usb-v2/dvbsky.c
 create mode 100644 drivers/media/usb/hackrf/Kconfig
 create mode 100644 drivers/media/usb/hackrf/Makefile
 create mode 100644 drivers/media/usb/hackrf/hackrf.c
 create mode 100644 drivers/media/usb/usbtv/usbtv-audio.c
 delete mode 100644 drivers/staging/media/as102/as102_fe.c
 create mode 100644 include/uapi/linux/smiapp.h

