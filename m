Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3GAK7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:59:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab3GAK7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:59:04 -0400
Date: Mon, 1 Jul 2013 07:58:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.11] media patches for v3.11
Message-ID: <20130701075856.6e8daa98.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For the media patches for Kernel v3.11.

This series contain:
	- new i2c video drivers: ml86v7667 (video decoder),
	 			 ths8200 (video encoder);
	- a new video driver for EasyCap cards based on Fushicai USBTV007;
	- Improved support for OF and embedded systems, with V4L2 async
	  initialization and a better support for clocks;
	- API cleanups on the ioctls used by the v4l2 debug tool;
	- Lots of cleanups;
	- As usual, several driver improvements and new cards additions.

Thanks!
Mauro

-

The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:

  Linux 3.10 (2013-06-30 15:13:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 253046e67443c6e7f891cad21d945c30b2e5e60c:

  Merge branch 'patchwork' into v4l_for_linus (2013-07-01 07:37:47 -0300)

----------------------------------------------------------------

Al Viro (1):
      [media] videobuf_vm_{open,close} race fixes

Alessandro Miceli (2):
      [media] Add support for 'Digital Dual TV Receiver CTVDIGDUAL v2
      [media] Add support for Crypto Redi PC50A device (rtl2832u + FC0012 tuner)

Alexey Khoroshilov (5):
      [media] wl128x: do not call copy_to_user() while holding spinlocks
      [media] staging/media: lirc_imon: fix leaks in imon_probe()
      [media] usbvision-video: fix memory leak of alt_max_pkt_size
      [media] go7007: fix return 0 for unsupported devices in go7007_usb_probe()
      [media] ttusb-budget: fix memory leak in ttusb_probe()

Andrzej Hajda (1):
      [media] media: Rename media_entity_remote_source to media_entity_remote_pad

Antti Palosaari (11):
      [media] af9035: implement I2C adapter read operation
      [media] af9035: make checkpatch.pl happy!
      [media] af9035: minor log writing changes
      [media] af9035: correct TS mode handling
      [media] rtl28xxu: reimplement rtl2832u remote controller
      [media] rtl28xxu: remove redundant IS_ENABLED macro
      [media] rtl28xxu: correct some device names
      [media] rtl28xxu: map remote for TerraTec Cinergy T Stick Black
      [media] rtl28xxu: use masked reg write where possible
      [media] rtl28xxu: correct latest device name
      [media] radio-keene: add delay in order to settle hardware

Arnd Bergmann (1):
      [media] omap3isp: include linux/mm_types.h

Dan Carpenter (1):
      [media] media: info leak in __media_device_enum_links()

Emil Goode (1):
      [media] saa7134: Fix sparse warnings by adding __user annotation

Frank Schaefer (4):
      [media] em28xx: extend GPIO register definitions for the em25xx, em276x/7x/8x, em2874/174/84
      [media] em28xx: improve em2820-em2873/83 GPIO port register definitions and descriptions
      [media] em28xx: move snapshot button bit definition for reg 0x0C from em28xx-input.c to em28xx.h
      [media] em28xx: remove GPIO register caching

Geert Uytterhoeven (1):
      [media] dib8000: Fix dib8000_set_frontend() never setting ret

Gianluca Gennari (4):
      [media] r820t: do not double-free fe->tuner_priv in r820t_release()
      [media] r820t: remove redundant initializations in r820t_attach()
      [media] r820t: avoid potential memcpy buffer overflow in shadow_store()
      [media] r820t: fix imr calibration

Guennadi Liakhovetski (29):
      [media] mt9p031: Power down the sensor if no supported device has been detected
      [media] V4L2: soc-camera: remove unneeded include path
      [media] soc-camera: move common code to soc_camera.c
      [media] soc-camera: add host clock callbacks to start and stop the master clock
      [media] pxa-camera: move interface activation and deactivation to clock callbacks
      [media] omap1-camera: move interface activation and deactivation to clock callbacks
      [media] atmel-isi: move interface activation and deactivation to clock callbacks
      [media] mx3-camera: move interface activation and deactivation to clock callbacks
      [media] mx2-camera: move interface activation and deactivation to clock callbacks
      [media] mx1-camera: move interface activation and deactivation to clock callbacks
      [media] sh-mobile-ceu-camera: move interface activation and deactivation to clock callbacks
      [media] soc-camera: make .clock_{start,stop} compulsory, .add / .remove optional
      [media] soc-camera: don't attach the client to the host during probing
      [media] sh-mobile-ceu-camera: add primitive OF support
      [media] sh-mobile-ceu-driver: support max width and height in DT
      [media] V4L2: add temporary clock helpers
      [media] V4L2: add a device pointer to struct v4l2_subdev
      [media] V4L2: support asynchronous subdevice registration
      [media] soc-camera: switch I2C subdevice drivers to use v4l2-clk
      [media] soc-camera: add V4L2-async support
      [media] sh_mobile_ceu_camera: add asynchronous subdevice probing support
      [media] imx074: support asynchronous probing
      [media] V4L2: sh_vou: add I2C build dependency
      [media] V4L2: fix compilation if CONFIG_I2C is undefined
      [media] V4L2: soc-camera: fix uninitialised use compiler warning
      [media] V4L2: add documentation for V4L2 clock helpers and asynchronous probing
      [media] V4L2: sh_mobile_ceu_camera: remove CEU specific data from generic functions
      [media] V4L2: soc-camera: move generic functions into a separate file
      [media] V4L2: soc-camera: remove several CEU references in the generic scaler

Hans Verkuil (121):
      [media] bttv: Add Adlink MPG24 entry to the bttv cardlist
      [media] CARDLIST.bttv: add new cards
      [media] bw-qcam: fix timestamp handling
      [media] hdpvr: fix querystd 'unknown format' return
      [media] hdpvr: code cleanup
      [media] hdpvr: improve error handling
      [media] ml86v7667: fix the querystd implementation
      [media] radio-keene: set initial frequency
      [media] v4l2-ioctl: dbg_g/s_register: only match BRIDGE and SUBDEV types
      [media] v4l2: remove g_chip_ident from bridge drivers where it is easy to do so
      [media] cx18: remove g_chip_ident support
      [media] saa7115: add back the dropped 'found' message
      [media] ivtv: remove g_chip_ident
      [media] cx23885: remove g_chip_ident
      [media] saa6752hs: drop obsolete g_chip_ident
      [media] gspca: remove g_chip_ident
      [media] cx231xx: remove g_chip_ident
      [media] marvell-ccic: remove g_chip_ident
      [media] tveeprom: remove v4l2-chip-ident.h include
      [media] au8522_decoder: remove g_chip_ident op
      [media] radio: remove g_chip_ident op
      [media] indycam: remove g_chip_ident op
      [media] soc_camera sensors: remove g_chip_ident op
      [media] media/i2c: remove g_chip_ident op
      [media] cx25840: remove the v4l2-chip-ident.h include
      [media] saa7134: check register address in g_register
      [media] mxb: check register address when reading/writing a register
      [media] vpbe_display: drop g/s_register ioctls
      [media] marvell-ccic: check register address
      [media] au0828: set reg->size
      [media] cx231xx: the reg->size field wasn't filled in
      [media] sn9c20x: the reg->size field wasn't filled in
      [media] pvrusb2: drop g/s_register ioctls
      [media] media/i2c: fill in missing reg->size fields
      [media] cx18: fix register range check
      [media] ivtv: fix register range check
      [media] DocBook/media/v4l: update VIDIOC_DBG_ documentation
      [media] v4l2-framework: replace g_chip_ident by g_std in the examples
      [media] saa7706h: convert to the control framework
      [media] sr030pc30: convert to the control framework
      [media] saa6752hs: convert to the control framework
      [media] radio-tea5764: add support for struct v4l2_device
      [media] radio-tea5764: embed struct video_device
      [media] radio-tea5764: convert to the control framework
      [media] radio-tea5764: audio and input ioctls do not apply to radio devices
      [media] radio-tea5764: add device_caps support
      [media] radio-tea5764: add prio and control event support
      [media] radio-tea5764: some cleanups and clamp frequency when out-of-range
      [media] radio-timb: add device_caps support, remove input/audio ioctls
      [media] radio-timb: convert to the control framework
      [media] radio-timb: actually load the requested subdevs
      [media] radio-timb: add control events and prio support
      [media] tef6862: clamp frequency
      [media] timblogiw: fix querycap
      [media] radio-sf16fmi: remove audio/input ioctls
      [media] radio-sf16fmi: add device_caps support to querycap
      [media] radio-sf16fmi: clamp frequency
      [media] radio-sf16fmi: convert to the control framework
      [media] radio-sf16fmi: add control event and prio support
      [media] mcam-core: replace current_norm by g_std
      [media] via-camera: replace current_norm by g_std
      [media] sh_vou: remove current_norm
      [media] soc_camera: remove use of current_norm
      [media] fsl-viu: remove current_norm
      [media] tm6000: remove deprecated current_norm
      [media] saa7164: replace current_norm by g_std
      [media] cx23885: remove use of deprecated current_norm
      [media] usbvision: replace current_norm by g_std
      [media] saa7134: drop deprecated current_norm
      [media] dt3155v4l: remove deprecated current_norm
      [media] v4l2: remove deprecated current_norm support completely
      [media] adv7183: fix querystd
      [media] bt819: fix querystd
      [media] ks0127: fix querystd
      [media] saa7110: fix querystd
      [media] saa7115: fix querystd
      [media] saa7191: fix querystd
      [media] tvp514x: fix querystd
      [media] vpx3220: fix querystd
      [media] bttv: fix querystd
      [media] zoran: remove bogus autodetect mode in set_norm
      [media] v4l2-ioctl: clarify querystd comment
      [media] DocBook/media/v4l: clarify the QUERYSTD documentation
      [media] tvp5150: fix s_std support
      [media] media: i2c: ths8200: driver for TI video encoder
      [media] saa7134: remove radio/type field from saa7134_fh
      [media] saa7134: move the overlay fields from saa7134_fh to saa7134_dev
      [media] saa7134: move fmt/width/height from saa7134_fh to saa7134_dev
      [media] saa7134: move qos_request from saa7134_fh to saa7134_dev
      [media] saa7134: fix format-related compliance issues
      [media] saa7134: fix empress format compliance bugs
      [media] ths8200: fix two compiler warnings
      [media] mxl111sf: don't redefine pr_err/info/debug
      [media] cx88: remove g_chip_ident
      [media] v4l2: remove obsolete v4l2_chip_match_host()
      [media] v4l2-common: remove unused v4l2_chip_match/ident_i2c_client functions
      [media] v4l2-int-device: remove unused chip_ident reference
      [media] v4l2-core: remove support for obsolete VIDIOC_DBG_G_CHIP_IDENT
      [media] DocBook: remove references to the dropped VIDIOC_DBG_G_CHIP_IDENT ioctl
      [media] DocBook: remove obsolete note from the dbg_g_register doc
      [media] cx88: fix register mask
      [media] v4l2-device: check if already unregistered
      [media] soc_camera: replace vdev->parent by vdev->v4l2_dev
      [media] cx23885-417: use v4l2_dev instead of the deprecated parent field
      [media] zoran: use v4l2_dev instead of the deprecated parent field
      [media] sn9c102_core: add v4l2_device and replace parent with v4l2_dev
      [media] saa7164: add v4l2_device and replace parent with v4l2_dev
      [media] pvrusb2: use v4l2_dev instead of the deprecated parent field
      [media] f_uvc: add v4l2_device and replace parent with v4l2_dev
      [media] omap24xxcam: add v4l2_device and replace parent with v4l2_dev
      [media] saa7134: use v4l2_dev instead of the deprecated parent field
      [media] v4l2: always require v4l2_dev, rename parent to dev_parent
      [media] cx88: set dev_parent to the correct parent PCI bus
      [media] v4l2-framework: update documentation
      [media] ml86v7667: fix compiler warning
      [media] bfin_capture: fix compiler warning
      [media] omap_vout: fix compiler warning
      [media] v4l2-controls.h: fix copy-and-paste error in comment
      [media] saa7164: fix compiler warning
      [media] wl128x: add missing struct v4l2_device
      [media] mem2mem: set missing v4l2_dev pointer

Ismael Luceno (3):
      [media] videodev2.h: Make V4L2_PIX_FMT_MPEG4 comment more specific about its usage
      [media] solo6x10: Approximate frame intervals with non-standard denominator
      [media] solo6x10: reimplement SAA712x setup routine

Jakob Haufe (2):
      [media] rc: Add rc-delock-61959
      [media] em28xx: Add support for 1b80:e1cc Delock 61959

Jakob Normark (1):
      [media] Missing break statement added in smsdvb-main.c

Jean Delvare (1):
      [media] sony-btf-mpx: Drop needless newline in param description

Jon Arne Jørgensen (1):
      [media] saa7115: Add register setup and config for gm7113c

Joseph Salisbury (1):
      [media] uvcvideo: quirk PROBE_DEF for Alienware X51 OmniVision webcam

Kamal Mostafa (1):
      [media] uvcvideo: quirk PROBE_DEF for Dell Studio / OmniVision webcam

Lad, Prabhakar (31):
      [media] media: davinci: vpif: remove unwanted header file inclusion
      [media] media: davinci: vpif_display: move displaying of error to approppraite place
      [media] media: davinci: vpbe: fix checkpatch warning for CamelCase
      [media] media: i2c: tvp7002: enable TVP7002 decoder for media controller based usage
      [media] videodev2.h: fix typos
      [media] media: i2c: tvp7002: remove duplicate define
      [media] media: i2c: tvp7002: rearrange description of structure members
      [media] media: i2c: remove duplicate checks for EPERM in dbg_g/s_register
      [media] media: dvb-frontends: remove duplicate checks for EPERM in dbg_g/s_register
      [media] media: usb: remove duplicate checks for EPERM in vidioc_g/s_register
      [media] media: pci: remove duplicate checks for EPERM
      [media] ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
      [media] media: i2c: ths7303: remove init_enable option from pdata
      [media] media: i2c: ths7303: remove unnecessary function ths7303_setup()
      [media] media: i2c: ths7303: make the pdata as a constant pointer
      [media] media: i2c: mt9p031: add OF support
      [media] media: davinci: vpif: remove unwanted header mach/hardware.h and sort the includes alphabetically
      [media] media: davinci: vpif: Convert to devm_* api
      [media] media: davinci: vpif: remove unnecessary braces around defines
      [media] media: davinci: vpif_capture: move the freeing of irq and global variables to remove()
      [media] media: davinci: vpif_capture: use module_platform_driver()
      [media] media: davinci: vpif_capture: Convert to devm_* api
      [media] media: davinci: vpif_capture: remove unnecessary loop for IRQ resource
      [media] media: davinci: vpif_display: move the freeing of irq and global variables to remove()
      [media] media: davinci: vpif_display: use module_platform_driver()
      [media] media: davinci: vpif_display: Convert to devm_* api
      [media] media: davinci: vpif_display: remove unnecessary loop for IRQ resource
      [media] media: i2c: tvp514x: add OF support
      [media] media: i2c: ths7303: remove unused member driver_data
      [media] media: i2c: tvp7002: remove manual setting of subdev name
      [media] media: i2c: tvp514x: remove manual setting of subdev name

Lars-Peter Clausen (2):
      [media] media:adv7180: Use dev_pm_ops
      [media] tvp514x: Fix init seqeunce

Laurent Pinchart (15):
      [media] mt9p031: Use gpio_is_valid()
      [media] mt9v032: Free control handler in cleanup paths
      [media] tvp514x: Fix double free
      [media] media: i2c: Convert to gpio_request_one()
      [media] media: i2c: Convert to devm_kzalloc()
      [media] media: i2c: Convert to devm_gpio_request_one()
      [media] media: i2c: Convert to devm_regulator_bulk_get()
      [media] m5mols: Convert to devm_request_irq()
      [media] s5c73m3: Convert to devm_gpio_request_one()
      [media] s5k6aa: Convert to devm_gpio_request_one()
      [media] uvcvideo: Fix open/close race condition
      [media] omap3isp: Defer probe when the IOMMU is not available
      [media] omap3isp: ccp2: Don't ignore the regulator_enable() return value
      [media] mt9p031: Use bulk regulator API
      [media] uvc: Depend on VIDEO_V4L2

Leonid Kegulskiy (3):
      [media] hdpvr: Removed unnecessary get_video_info() call from hdpvr_device_init()
      [media] hdpvr: Added some error handling in hdpvr_start_streaming()
      [media] hdpvr: Removed unnecessary use of kzalloc() in get_video_info()

Libo Chen (6):
      [media] drivers/media/pci/pt1/pt1: Convert to module_pci_driver
      [media] drivers/media/pci/dm1105/dm1105: Convert to module_pci_driver
      [media] drivers/media/pci/mantis/hopper_cards: Convert to module_pci_driver
      [media] drivers/media/pci/dm1105/dm1105: Convert to module_pci_driver
      [media] drivers/media/pci/pluto2/pluto2: Convert to module_pci_driver
      [media] drivers/media/pci/mantis/mantis_cards: Convert to module_pci_driver

Lubomir Rintel (1):
      [media] usbtv: Add driver for Fushicai USBTV007 video frame grabber

Mauro Carvalho Chehab (21):
      Merge tag 'v3.10-rc1' into patchwork
      [media] update saa7134 and tuner cardlists
      [media] saa7115: move the autodetection code out of the probe function
      [media] saa7115: add detection code for gm7113c
      [media] videobuf-dma-contig: use vm_iomap_memory()
      [media] saa7115: Don't use a dynamic array
      [media] drxk_hard: don't re-implement log10
      [media] drxk_hard: Don't use CamelCase
      [media] drxk_hard: use pr_info/pr_warn/pr_err/... macros
      [media] drxk_hard: don't split strings across lines
      [media] drxk_hard: use usleep_range()
      [media] drxk_hard.h: Remove some alien comment markups
      [media] drxk_hard.h: don't use more than 80 columns
      [media] drxk_hard: remove needless parenthesis
      [media] drxk_hard: Remove most 80-cols checkpatch warnings
      Properly handle tristate dependencies on USB/PCI menus
      Merge branch 'linus' into patchwork
      [media] pvrusb2: Remove unused variable
      Merge branch 'v4l_for_linus' into patchwork
      Merge tag 'v3.10' into v4l_for_linus
      Merge branch 'patchwork' into v4l_for_linus

Miroslav Šustek (1):
      [media] rtl28xxu: Add USB ID for Leadtek WinFast DTV Dongle mini

Ondrej Zary (4):
      [media] bttv: Add noname Bt848 capture card with 14MHz xtal
      [media] bttv: Add CyberVision CV06
      [media] radio-sf16fmi: Add module name to bus_info
      [media] radio-sf16fmi: Set frequency during init

Paul Bolle (1):
      [media] soc-camera: remove two unused configs

Phil Carmody (1):
      [media] exynos4-is: Simplify bitmask usage

Philipp Zabel (15):
      [media] coda: v4l2-compliance fix: add bus_info prefix 'platform'
      [media] coda: use devm_ioremap_resource
      [media] coda: enable dmabuf support
      [media] coda: set umask 0644 on debug module param
      [media] coda: fix error return value if v4l2_m2m_ctx_init fails
      [media] coda: do not use v4l2_dev in coda_timeout
      [media] coda: fix ENC_SEQ_OPTION for CODA7
      [media] coda: frame stride must be a multiple of 8
      [media] coda: stop setting bytesused in buf_prepare
      [media] coda: clear registers in coda_hw_init
      [media] coda: simplify parameter buffer setup code
      [media] coda: per-product list of codecs instead of list of formats
      [media] coda: add coda_encode_header helper function
      [media] coda: replace completion with mutex
      [media] coda: do not call v4l2_m2m_job_finish from .job_abort

Randy Dunlap (2):
      [media] media/usb: fix kconfig dependencies
      [media] media: fix hdpvr kconfig/build errors

Reinhard Nissl (1):
      [media] stb0899: remove commented value from IQ_SWAP_ON/OFF usages

Reinhard Nißl (7):
      [media] stb0899: sign extend raw CRL_FREQ value
      [media] stb0899: enable auto inversion handling unconditionally
      [media] stb0899: fix inversion enum values to match usage with CFR
      [media] stb0899: store successful inversion for next run
      [media] stb0899: store autodetected inversion while tuning in non S2 mode
      [media] stb0899: use autodetected inversion instead of configured inversion
      [media] stb0899: sign of CRL_FREQ doesn't depend on inversion

Roberto Alcântara (2):
      [media] smscoreapi: Make Siano firmware load more verbose
      [media] smscoreapi: memory leak fix

Rodrigo Tartajo (1):
      [media] rtl2832u: restore ir remote control support

Sachin Kamat (19):
      [media] timblogiw: Remove redundant platform_set_drvdata()
      [media] rc: gpio-ir-recv: Remove redundant platform_set_drvdata()
      [media] omap3isp: Remove redundant platform_set_drvdata()
      [media] s3c-camif: Staticize local symbols
      [media] s3c-camif: Use dev_info instead of printk
      [media] s5c73m3: Fix whitespace related warnings
      [media] exynos4-is: Remove redundant NULL check in fimc-lite.c
      [media] s3c-camif: Remove redundant NULL check
      [media] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in hdmi_drv.c
      [media] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL in mixer_drv.c
      [media] exynos-gsc: Remove redundant use of of_match_ptr macro
      [media] s5p-mfc: Remove redundant use of of_match_ptr macro
      [media] exynos4-is: Staticize local symbols
      [media] soc_camera: Constify dev_pm_ops in mt9t031.c
      [media] soc_camera: Fix checkpatch warning in ov9640.c
      [media] soc_camera/sh_mobile_csi2: Remove redundant platform_set_drvdata()
      [media] soc_camera_platform: Remove redundant platform_set_drvdata()
      [media] soc_camera: mt9t112: Remove empty function
      [media] soc_camera: tw9910: Remove empty function

Sakari Ailus (2):
      [media] davinci_vpfe: Clean up media entity after unregistering subdev
      [media] smiapp: Clean up media entity after unregistering subdev

Scott Jiang (2):
      [media] blackfin: add display support in ppi driver
      [media] bfin_capture: add query_dv_timings/enum_dv_timings support

Soeren Moch (1):
      [media] media: dmxdev: remove dvb_ringbuffer_flush() on writer side

Sylwester Nawrocki (37):
      [media] exynos4-is: Fix example dts in .../bindings/samsung-fimc.txt
      [media] exynos4-is: Remove platform_device_id table at fimc-lite driver
      [media] exynos4-is: Correct querycap ioctl handling at fimc-lite driver
      [media] s5c73m3: Do not ignore errors from regulator_enable()
      [media] exynos4-is: Move common functions to a separate module
      [media] exynos4-is: Add struct exynos_video_entity
      [media] exynos4-is: Preserve state of controls between /dev/video open/close
      [media] exynos4-is: Media graph/video device locking rework
      [media] exynos4-is: Do not use asynchronous runtime PM in release fop
      [media] exynos4-is: Use common exynos_media_pipeline data structure
      [media] exynos4-is: Remove WARN_ON() from __fimc_pipeline_close()
      [media] exynos4-is: Fix sensor subdev -> FIMC notification setup
      [media] exynos4-is: Add locking at fimc(-lite) subdev unregistered handler
      [media] exynos4-is: Remove leftovers of non-dt FIMC-LITE support
      [media] exynos4-is: Remove unused code
      [media] exynos4-is: Refactor vidioc_s_fmt, vidioc_try_fmt handlers
      [media] exynos4-is: Move __fimc_videoc_querycap() function to the common module
      [media] exynos4-is: Add isp_dbg() macro
      [media] media: Change media device link_notify behaviour
      [media] exynos4-is: Extend link_notify handler to support fimc-is/lite pipelines
      [media] s5p-tv: Don't ignore return value of regulator_enable() in sii9234_drv.c
      [media] s5p-tv: Do not ignore regulator/clk API return values in sdo_drv.c
      [media] s5p-tv: Don't ignore return value of regulator_bulk_enable() in hdmi_drv.c
      [media] media: Add a function removing all links of a media entity
      [media] V4L: Remove all links of the media entity when unregistering subdev
      [media] exynos4-is: Drop drvdata handling in fimc-lite for non-dt platforms
      [media] exynos4-is: Add Exynos5250 SoC support to fimc-lite driver
      [media] exynos4-is: Add support for Exynos5250 MIPI-CSIS
      [media] exynos4-is: Change fimc-is firmware file names
      [media] Documentation: Update driver's directory in video4linux/fimc.txt
      [media] MAINTAINERS: Update S5P/Exynos FIMC driver entry
      [media] exynos4-is: Fix format propagation on FIMC-LITE.n subdevs
      [media] exynos4-is: Set valid initial format at FIMC-LITE
      [media] exynos4-is: Fix format propagation on FIMC-IS-ISP subdev
      [media] exynos4-is: Set valid initial format on FIMC-IS-ISP subdev pads
      [media] exynos4-is: Set valid initial format on FIMC.n subdevs
      [media] exynos4-is: Correct colorspace handling at FIMC-LITE

Thomas Meyer (3):
      [media] dma-buf: Cocci spatch "ptr_ret.spatch"
      [media] pvrusb2: Cocci spatch "memdup.spatch"
      [media] media: Cocci spatch "ptr_ret.spatch"

Vladimir Barinov (2):
      [media] adv7180: add more subdev video ops
      [media] ML86V7667: new video decoder driver

Wei Yongjun (7):
      [media] v4l: vb2: fix error return code in __vb2_init_fileio()
      [media] vpif_display: fix error return code in vpif_probe()
      [media] vpif_capture: fix error return code in vpif_probe()
      [media] ad9389b: fix error return code in ad9389b_probe()
      [media] blackfin: fix error return code in bcap_probe()
      [media] sta2x11_vip: fix error return code in sta2x11_vip_init_one()
      [media] s5p-tv: fix error return code in mxr_acquire_video()

Zoran Turalija (2):
      [media] stb0899: allow minimum symbol rate of 1000000
      [media] stb0899: allow minimum symbol rate of 2000000

 Documentation/DocBook/media/v4l/compat.xml         |   14 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |   11 +-
 .../DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml  |  271 --
 .../DocBook/media/v4l/vidioc-dbg-g-chip-info.xml   |   20 +-
 .../DocBook/media/v4l/vidioc-dbg-g-register.xml    |   64 +-
 .../DocBook/media/v4l/vidioc-querystd.xml          |    3 +-
 .../devicetree/bindings/media/exynos-fimc-lite.txt |    6 +-
 .../devicetree/bindings/media/i2c/mt9p031.txt      |   40 +
 .../devicetree/bindings/media/i2c/tvp514x.txt      |   44 +
 .../devicetree/bindings/media/samsung-fimc.txt     |   26 +-
 .../bindings/media/samsung-mipi-csis.txt           |    4 +-
 .../devicetree/bindings/media/sh_mobile_ceu.txt    |   18 +
 Documentation/media-framework.txt                  |    2 +-
 Documentation/video4linux/CARDLIST.bttv            |    3 +
 Documentation/video4linux/CARDLIST.saa7134         |    1 +
 Documentation/video4linux/CARDLIST.tuner           |    6 +-
 Documentation/video4linux/fimc.txt                 |   21 +-
 Documentation/video4linux/v4l2-framework.txt       |  103 +-
 Documentation/zh_CN/video4linux/v4l2-framework.txt |   13 +-
 MAINTAINERS                                        |   18 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |    1 -
 drivers/base/dma-buf.c                             |    5 +-
 drivers/media/common/saa7146/saa7146_video.c       |   23 -
 drivers/media/common/siano/smscoreapi.c            |   23 +-
 drivers/media/common/siano/smsdvb-main.c           |    1 +
 drivers/media/common/tveeprom.c                    |  142 +-
 drivers/media/dvb-core/dmxdev.c                    |    8 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |    2 +
 drivers/media/dvb-frontends/au8522_decoder.c       |   21 -
 drivers/media/dvb-frontends/dib8000.c              |    4 +-
 drivers/media/dvb-frontends/drxk.h                 |    2 +-
 drivers/media/dvb-frontends/drxk_hard.c            | 3154 ++++++++++----------
 drivers/media/dvb-frontends/drxk_hard.h            |  277 +-
 drivers/media/dvb-frontends/stb0899_algo.c         |  105 +-
 drivers/media/dvb-frontends/stb0899_drv.c          |    7 +-
 drivers/media/dvb-frontends/stb0899_drv.h          |    5 +-
 drivers/media/i2c/Kconfig                          |   18 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/ad9389b.c                        |   35 +-
 drivers/media/i2c/adp1653.c                        |    5 +-
 drivers/media/i2c/adv7170.c                        |   16 +-
 drivers/media/i2c/adv7175.c                        |   12 +-
 drivers/media/i2c/adv7180.c                        |   79 +-
 drivers/media/i2c/adv7183.c                        |   80 +-
 drivers/media/i2c/adv7343.c                        |   10 -
 drivers/media/i2c/adv7393.c                        |   18 +-
 drivers/media/i2c/adv7604.c                        |   33 +-
 drivers/media/i2c/ak881x.c                         |   39 +-
 drivers/media/i2c/as3645a.c                        |    7 +-
 drivers/media/i2c/bt819.c                          |   26 +-
 drivers/media/i2c/bt856.c                          |   12 +-
 drivers/media/i2c/bt866.c                          |   16 +-
 drivers/media/i2c/cs5345.c                         |   25 +-
 drivers/media/i2c/cs53l32a.c                       |   14 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   72 +-
 drivers/media/i2c/cx25840/cx25840-core.h           |   34 +-
 drivers/media/i2c/cx25840/cx25840-ir.c             |    7 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |   10 +-
 drivers/media/i2c/ks0127.c                         |   36 +-
 drivers/media/i2c/m52790.c                         |   22 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |   43 +-
 drivers/media/i2c/ml86v7667.c                      |  431 +++
 drivers/media/i2c/msp3400-driver.c                 |   15 +-
 drivers/media/i2c/mt9m032.c                        |   13 +-
 drivers/media/i2c/mt9p031.c                        |   87 +-
 drivers/media/i2c/mt9t001.c                        |    4 +-
 drivers/media/i2c/mt9v011.c                        |   34 +-
 drivers/media/i2c/mt9v032.c                        |    8 +-
 drivers/media/i2c/noon010pc30.c                    |   41 +-
 drivers/media/i2c/ov7640.c                         |    6 +-
 drivers/media/i2c/ov7670.c                         |   26 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   88 +-
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |    4 +-
 drivers/media/i2c/s5k6aa.c                         |   73 +-
 drivers/media/i2c/saa6588.c                        |   19 +-
 drivers/media/i2c/saa7110.c                        |   17 +-
 drivers/media/i2c/saa7115.c                        |  297 +-
 drivers/media/i2c/saa7127.c                        |   55 +-
 drivers/media/i2c/saa717x.c                        |   16 +-
 drivers/media/i2c/saa7185.c                        |   12 +-
 drivers/media/i2c/saa7191.c                        |   28 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   20 +-
 drivers/media/i2c/soc_camera/imx074.c              |   51 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |   50 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |   53 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |   54 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |   35 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |   64 +-
 drivers/media/i2c/soc_camera/ov2640.c              |   35 +-
 drivers/media/i2c/soc_camera/ov5642.c              |   39 +-
 drivers/media/i2c/soc_camera/ov6650.c              |   29 +-
 drivers/media/i2c/soc_camera/ov772x.c              |   31 +-
 drivers/media/i2c/soc_camera/ov9640.c              |   35 +-
 drivers/media/i2c/soc_camera/ov9640.h              |    1 +
 drivers/media/i2c/soc_camera/ov9740.c              |   35 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   48 +-
 drivers/media/i2c/soc_camera/tw9910.c              |   33 +-
 drivers/media/i2c/sony-btf-mpx.c                   |    5 +-
 drivers/media/i2c/sr030pc30.c                      |  280 +-
 drivers/media/i2c/tda7432.c                        |    4 +-
 drivers/media/i2c/tda9840.c                        |   16 +-
 drivers/media/i2c/tea6415c.c                       |   16 +-
 drivers/media/i2c/tea6420.c                        |   16 +-
 drivers/media/i2c/ths7303.c                        |   81 +-
 drivers/media/i2c/ths8200.c                        |  556 ++++
 drivers/media/i2c/ths8200_regs.h                   |  161 +
 drivers/media/i2c/tlv320aic23b.c                   |    4 +-
 drivers/media/i2c/tvaudio.c                        |   14 +-
 drivers/media/i2c/tvp514x.c                        |   87 +-
 drivers/media/i2c/tvp5150.c                        |   50 +-
 drivers/media/i2c/tvp7002.c                        |  143 +-
 drivers/media/i2c/tw2804.c                         |    6 +-
 drivers/media/i2c/tw9903.c                         |    5 +-
 drivers/media/i2c/tw9906.c                         |    5 +-
 drivers/media/i2c/uda1342.c                        |    3 +-
 drivers/media/i2c/upd64031a.c                      |   24 +-
 drivers/media/i2c/upd64083.c                       |   24 +-
 drivers/media/i2c/vp27smpx.c                       |   12 +-
 drivers/media/i2c/vpx3220.c                        |   29 +-
 drivers/media/i2c/vs6624.c                         |   46 +-
 drivers/media/i2c/wm8739.c                         |   13 +-
 drivers/media/i2c/wm8775.c                         |   13 +-
 drivers/media/media-device.c                       |    3 +
 drivers/media/media-entity.c                       |   81 +-
 drivers/media/parport/bw-qcam.c                    |    2 +
 drivers/media/pci/Kconfig                          |    4 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |   13 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |   52 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   48 +-
 drivers/media/pci/bt8xx/bttv.h                     |    4 +
 drivers/media/pci/cx18/cx18-av-core.c              |   36 -
 drivers/media/pci/cx18/cx18-av-core.h              |    1 -
 drivers/media/pci/cx18/cx18-ioctl.c                |   82 +-
 drivers/media/pci/cx23885/cx23885-417.c            |    9 +-
 drivers/media/pci/cx23885/cx23885-ioctl.c          |  145 +-
 drivers/media/pci/cx23885/cx23885-ioctl.h          |    4 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    9 +-
 drivers/media/pci/cx23885/cx23888-ir.c             |   31 -
 drivers/media/pci/cx88/cx88-cards.c                |   12 +-
 drivers/media/pci/cx88/cx88-core.c                 |    7 +
 drivers/media/pci/cx88/cx88-video.c                |   25 +-
 drivers/media/pci/cx88/cx88.h                      |    8 +-
 drivers/media/pci/dm1105/dm1105.c                  |   13 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |    8 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |   45 +-
 drivers/media/pci/mantis/hopper_cards.c            |   13 +-
 drivers/media/pci/mantis/mantis_cards.c            |   13 +-
 drivers/media/pci/mantis/mantis_vp1041.c           |    2 +-
 drivers/media/pci/pluto2/pluto2.c                  |   13 +-
 drivers/media/pci/pt1/pt1.c                        |   15 +-
 drivers/media/pci/saa7134/saa6752hs.c              |  525 +---
 drivers/media/pci/saa7134/saa7134-empress.c        |   33 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  260 +-
 drivers/media/pci/saa7134/saa7134.h                |   17 +-
 drivers/media/pci/saa7146/mxb.c                    |   23 +-
 drivers/media/pci/saa7164/saa7164-core.c           |    8 +
 drivers/media/pci/saa7164/saa7164-encoder.c        |   58 +-
 drivers/media/pci/saa7164/saa7164-vbi.c            |   24 +-
 drivers/media/pci/saa7164/saa7164.h                |    5 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    3 +-
 drivers/media/pci/ttpci/budget-av.c                |    2 +-
 drivers/media/pci/ttpci/budget-ci.c                |    2 +-
 drivers/media/pci/zoran/zoran_card.c               |    2 +-
 drivers/media/pci/zoran/zoran_driver.c             |   23 -
 drivers/media/platform/Kconfig                     |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   81 +-
 drivers/media/platform/blackfin/ppi.c              |   12 +
 drivers/media/platform/coda.c                      |  635 ++--
 drivers/media/platform/coda.h                      |   11 +-
 drivers/media/platform/davinci/vpbe_display.c      |   31 +-
 drivers/media/platform/davinci/vpbe_osd.c          |   24 +-
 drivers/media/platform/davinci/vpif.c              |   45 +-
 drivers/media/platform/davinci/vpif_capture.c      |  160 +-
 drivers/media/platform/davinci/vpif_capture.h      |    5 +-
 drivers/media/platform/davinci/vpif_display.c      |  153 +-
 drivers/media/platform/davinci/vpif_display.h      |    5 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |    2 +-
 drivers/media/platform/exynos4-is/Kconfig          |    7 +-
 drivers/media/platform/exynos4-is/Makefile         |    5 +-
 drivers/media/platform/exynos4-is/common.c         |   53 +
 drivers/media/platform/exynos4-is/common.h         |   16 +
 drivers/media/platform/exynos4-is/fimc-capture.c   |  412 +--
 drivers/media/platform/exynos4-is/fimc-core.c      |   11 -
 drivers/media/platform/exynos4-is/fimc-core.h      |   15 +-
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-param.c  |   84 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |    4 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |   12 +-
 drivers/media/platform/exynos4-is/fimc-is.h        |   12 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |  130 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |   21 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |   55 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.h  |   10 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  321 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |   35 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    1 +
 drivers/media/platform/exynos4-is/fimc-reg.c       |    7 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  272 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   54 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   67 +-
 drivers/media/platform/fsl-viu.c                   |    2 +-
 drivers/media/platform/indycam.c                   |   12 -
 drivers/media/platform/m2m-deinterlace.c           |    1 +
 drivers/media/platform/marvell-ccic/cafe-driver.c  |    4 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   67 +-
 drivers/media/platform/marvell-ccic/mcam-core.h    |    9 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c   |    4 +-
 drivers/media/platform/mem2mem_testdev.c           |    3 +-
 drivers/media/platform/mx2_emmaprp.c               |    1 +
 drivers/media/platform/omap/omap_vout.c            |    3 +-
 drivers/media/platform/omap24xxcam.c               |    9 +-
 drivers/media/platform/omap24xxcam.h               |    3 +
 drivers/media/platform/omap3isp/isp.c              |   51 +-
 drivers/media/platform/omap3isp/ispccdc.c          |    2 +-
 drivers/media/platform/omap3isp/ispccp2.c          |   21 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |    2 +-
 drivers/media/platform/omap3isp/ispqueue.h         |    1 +
 drivers/media/platform/omap3isp/ispvideo.c         |    6 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    2 +-
 drivers/media/platform/s3c-camif/camif-core.c      |    6 +-
 drivers/media/platform/s3c-camif/camif-regs.c      |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   39 +-
 drivers/media/platform/s5p-tv/mixer_drv.c          |   22 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |    3 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |   22 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c        |    4 +-
 drivers/media/platform/sh_veu.c                    |    5 +-
 drivers/media/platform/sh_vou.c                    |   34 +-
 drivers/media/platform/soc_camera/Kconfig          |   12 +-
 drivers/media/platform/soc_camera/Makefile         |    6 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |   38 +-
 drivers/media/platform/soc_camera/mx1_camera.c     |   48 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |   41 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |   44 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |   41 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |   46 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  642 ++--
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |  161 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  737 ++++-
 .../platform/soc_camera/soc_camera_platform.c      |   14 +-
 drivers/media/platform/soc_camera/soc_scale_crop.c |  402 +++
 drivers/media/platform/soc_camera/soc_scale_crop.h |   47 +
 drivers/media/platform/timblogiw.c                 |   11 +-
 drivers/media/platform/via-camera.c                |   24 +-
 drivers/media/radio/radio-keene.c                  |    7 +-
 drivers/media/radio/radio-sf16fmi.c                |  127 +-
 drivers/media/radio/radio-si476x.c                 |   11 -
 drivers/media/radio/radio-tea5764.c                |  190 +-
 drivers/media/radio/radio-timb.c                   |   81 +-
 drivers/media/radio/saa7706h.c                     |   66 +-
 drivers/media/radio/tef6862.c                      |   24 +-
 drivers/media/radio/wl128x/fmdrv.h                 |    2 +
 drivers/media/radio/wl128x/fmdrv_common.c          |   24 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    8 +
 drivers/media/rc/gpio-ir-recv.c                    |    2 -
 drivers/media/rc/keymaps/Makefile                  |    1 +
 drivers/media/rc/keymaps/rc-delock-61959.c         |   83 +
 drivers/media/tuners/r820t.c                       |   18 +-
 drivers/media/usb/Kconfig                          |    5 +-
 drivers/media/usb/Makefile                         |    1 +
 drivers/media/usb/au0828/au0828-video.c            |   40 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |    1 -
 drivers/media/usb/cx231xx/cx231xx-avcore.c         |    1 -
 drivers/media/usb/cx231xx/cx231xx-cards.c          |    1 -
 drivers/media/usb/cx231xx/cx231xx-vbi.c            |    1 -
 drivers/media/usb/cx231xx/cx231xx-video.c          |  424 +--
 drivers/media/usb/cx231xx/cx231xx.h                |    2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |   66 +-
 drivers/media/usb/dvb-usb-v2/af9035.h              |   11 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |    2 +-
 drivers/media/usb/dvb-usb-v2/it913x.c              |    5 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c      |    8 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |   90 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |  180 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h            |    6 +
 drivers/media/usb/dvb-usb/az6027.c                 |    2 +-
 drivers/media/usb/dvb-usb/pctv452e.c               |    2 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |  239 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   27 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   73 +-
 drivers/media/usb/em28xx/em28xx-input.c            |    1 -
 drivers/media/usb/em28xx/em28xx-reg.h              |   23 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   66 +-
 drivers/media/usb/em28xx/em28xx.h                  |    7 +-
 drivers/media/usb/gspca/gspca.c                    |   32 +-
 drivers/media/usb/gspca/gspca.h                    |    6 +-
 drivers/media/usb/gspca/pac7302.c                  |   19 +-
 drivers/media/usb/gspca/sn9c20x.c                  |   69 +-
 drivers/media/usb/hdpvr/Kconfig                    |    2 +-
 drivers/media/usb/hdpvr/hdpvr-control.c            |   34 +-
 drivers/media/usb/hdpvr/hdpvr-core.c               |    8 -
 drivers/media/usb/hdpvr/hdpvr-video.c              |  110 +-
 drivers/media/usb/hdpvr/hdpvr.h                    |    3 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   42 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h            |   13 +-
 drivers/media/usb/pvrusb2/pvrusb2-io.c             |    4 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   43 +-
 drivers/media/usb/sn9c102/sn9c102.h                |    3 +
 drivers/media/usb/sn9c102/sn9c102_core.c           |   13 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |   41 -
 drivers/media/usb/tm6000/tm6000-cards.c            |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c            |   13 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  |    2 +
 drivers/media/usb/usbtv/Kconfig                    |   10 +
 drivers/media/usb/usbtv/Makefile                   |    1 +
 drivers/media/usb/usbtv/usbtv.c                    |  696 +++++
 drivers/media/usb/usbvision/usbvision-video.c      |   19 +-
 drivers/media/usb/uvc/Kconfig                      |    1 +
 drivers/media/usb/uvc/uvc_driver.c                 |   41 +-
 drivers/media/usb/uvc/uvc_status.c                 |   21 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   14 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    7 +-
 drivers/media/v4l2-core/Makefile                   |    3 +-
 drivers/media/v4l2-core/v4l2-async.c               |  284 ++
 drivers/media/v4l2-core/v4l2-clk.c                 |  242 ++
 drivers/media/v4l2-core/v4l2-common.c              |   60 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |    1 -
 drivers/media/v4l2-core/v4l2-dev.c                 |   40 +-
 drivers/media/v4l2-core/v4l2-device.c              |   13 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   83 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c      |   19 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c          |   10 +-
 drivers/media/v4l2-core/videobuf-vmalloc.c         |   10 +-
 drivers/media/v4l2-core/videobuf2-core.c           |    4 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |    4 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |    4 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |    4 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |   14 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   14 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |    1 -
 drivers/staging/media/go7007/go7007-usb.c          |    4 +-
 drivers/staging/media/lirc/lirc_imon.c             |    7 +-
 drivers/staging/media/solo6x10/solo6x10-tw28.c     |  112 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |   38 +-
 drivers/usb/gadget/f_uvc.c                         |    9 +-
 drivers/usb/gadget/uvc.h                           |    2 +
 include/media/davinci/vpbe_osd.h                   |    4 +-
 include/media/media-device.h                       |    9 +-
 include/media/media-entity.h                       |    5 +-
 include/media/rc-map.h                             |    1 +
 include/media/s5p_fimc.h                           |   58 +-
 include/media/sh_mobile_ceu.h                      |    2 +
 include/media/sh_mobile_csi2.h                     |    2 +-
 include/media/soc_camera.h                         |   43 +-
 include/media/ths7303.h                            |    2 -
 include/media/tveeprom.h                           |   11 +
 include/media/tvp7002.h                            |   46 +-
 include/media/v4l2-async.h                         |  105 +
 include/media/v4l2-chip-ident.h                    |  352 ---
 include/media/v4l2-clk.h                           |   54 +
 include/media/v4l2-common.h                        |   10 -
 include/media/v4l2-dev.h                           |    5 +-
 include/media/v4l2-int-device.h                    |    3 -
 include/media/v4l2-ioctl.h                         |    2 -
 include/media/v4l2-subdev.h                        |   14 +-
 include/uapi/linux/v4l2-controls.h                 |    4 +-
 include/uapi/linux/videodev2.h                     |   27 +-
 358 files changed, 10866 insertions(+), 9826 deletions(-)
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9p031.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp514x.txt
 create mode 100644 Documentation/devicetree/bindings/media/sh_mobile_ceu.txt
 create mode 100644 drivers/media/i2c/ml86v7667.c
 create mode 100644 drivers/media/i2c/ths8200.c
 create mode 100644 drivers/media/i2c/ths8200_regs.h
 create mode 100644 drivers/media/platform/exynos4-is/common.c
 create mode 100644 drivers/media/platform/exynos4-is/common.h
 create mode 100644 drivers/media/platform/soc_camera/soc_scale_crop.c
 create mode 100644 drivers/media/platform/soc_camera/soc_scale_crop.h
 create mode 100644 drivers/media/rc/keymaps/rc-delock-61959.c
 create mode 100644 drivers/media/usb/usbtv/Kconfig
 create mode 100644 drivers/media/usb/usbtv/Makefile
 create mode 100644 drivers/media/usb/usbtv/usbtv.c
 create mode 100644 drivers/media/v4l2-core/v4l2-async.c
 create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
 create mode 100644 include/media/v4l2-async.h
 delete mode 100644 include/media/v4l2-chip-ident.h
 create mode 100644 include/media/v4l2-clk.h

