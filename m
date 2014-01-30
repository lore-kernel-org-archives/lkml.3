Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaA3KCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 05:02:44 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:16002 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaA3KCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 05:02:37 -0500
X-AuditID: cbfec373-b7f4a6d000005e0a-bb-52ea233c5049
Date: Thu, 30 Jan 2014 08:02:28 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.14-rc1] media updates
Message-id: <20140130080228.2350c809.m.chehab@samsung.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e9wkK6N8qsgg68NrBZz1q9hs7i8aw6b
	Rc+GrawWj/resjuweJyY8ZvF4/MmuQCmKC6blNSczLLUIn27BK6M4y2zmQrmb2Gu+DjhCFMD
	46vjTF2MnBwSAiYSEzrnsEPYYhIX7q1n62Lk4hASWMIoceThFWYIp4FJYnvHVGaQKhYBVYk1
	Lw6AdbMJGEm8amxhBbFFgOzPL66wgjQwCyxmlPj4fD3YWGEBfYnHn5eygNi8AlYS2yYsAYpz
	AK1zkth9QAoiLCjxY/I9sBJmAS2JzduaWCFseYnNa94yT2Dkm4WkbBaSsllIyhYwMq9iFC0t
	Ti4oTkrPNdIrTswtLs1L10vOz93ECAm/4h2MLzZYHWIU4GBU4uFdMfllkBBrYllxZe4hRgkO
	ZiUR3hT5V0FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGLM3Tr6QkhDpN8tIfFev8xXz1e+m6v4/
	K72o6Plmj/eGZ//OYCxdotL7y+XPPD/1iD8bXt84555c6fgzytCzpPe9yf55x/4LJNUarH74
	4dn64BfCHyfozL7DX+nuIDJrv/cmw+N5s+ui0jS/swptZ62T7PB9zfrbdvohczO5mD8Hw9vC
	skzbi5VYijMSDbWYi4oTARmF4vAdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
	  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for:
	- a new jpeg codec driver for Samsung Exynos (jpeg-hw-exynos4);
	- a new dvb frontend for ds2103 chipset (m88ds2103);
	- a new sensor driver for Samsung S5K5BAF UXGA (s5k5baf);
	- new drivers for R-Car VSP1;
	- a new radio driver: radio-raremono;
	- a new tuner driver for ts2022 chipset (m88ts2022);
	- The analog part of em28xx is now a separate module that only load/runs
	  if the device is not a pure digital TV device;
	- added a staging driver for bcm2048 radio devices;
	- the omap 2 video driver (omap24xx) was moved to staging. This driver
	  is for an old hardware and uses a deprecated Kernel internal API.
	  If nobody cares enough to fix it, it would be removed on a couple
	  Kernel releases;
	- The sn9c102 driver was moved to staging. This driver was replaced by
	  gspca, and disabled on some distros, as almost all devices are known
	  to work properly with gspca. It should be removed from kernel on a
	  couple Kernel releases;
	- lots of driver fixes, improvements and cleanups.

Thanks!
Mauro
- 

The following changes since commit 64c832a4f79542809d6c10b8ec6225ff8b76092e:

  [media] videobuf2-dma-sg: fix possible memory leak (2013-12-10 05:40:57 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 6c3df5da67f1f53df78c7e20cd53a481dc28eade:

  [media] media: v4l2-dev: fix video device index assignment (2014-01-27 21:42:42 -0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      [media] as102: fix leaks at failure paths in as102_usb_probe()

Andrzej Hajda (2):
      [media] Add DT binding documentation for Samsung S5K5BAF camera sensor
      [media] Add driver for Samsung S5K5BAF camera sensor

Antonio Ospite (2):
      [media] Documentation/DocBook/media/v4l/subdev-formats.xml: fix a typo
      [media] Documentation/DocBook/media/v4l: fix typo, s/packet/packed/

Antti Palosaari (23):
      [media] rtl2830: add parent for I2C adapter
      [media] af9035: add [0413:6a05] Leadtek WinFast DTV Dongle Dual
      [media] em28xx: add support for Empia EM28178
      [media] a8293: add small sleep in order to settle LNB voltage
      [media] Montage M88DS3103 DVB-S/S2 demodulator driver
      [media] Montage M88TS2022 silicon tuner driver
      [media] em28xx: add support for PCTV DVB-S2 Stick (461e) [2013:0258]
      [media] MAINTAINERS: add M88DS3103
      [media] MAINTAINERS: add M88TS2022
      [media] m88ts2022: do not use dynamic stack allocation
      [media] m88ds3103: do not use dynamic stack allocation
      [media] m88ds3103: use I2C mux for tuner I2C adapter
      [media] m88ds3103: use kernel macro to round division
      [media] m88ds3103: fix TS mode config
      [media] m88ts2022: reimplement synthesizer calculations
      [media] m88ds3103: remove unneeded AGC from inittab
      [media] m88ds3103: add default value for reg 56
      [media] m88ds3103: I/O optimize inittab write
      [media] m88ts2022: convert to Kernel I2C driver model
      [media] m88ds3103: fix possible i2c deadlock
      [media] m88ds3103: fix some style issues reported by checkpatch.pl
      [media] m88ts2022: fix some style issues reported by checkpatch.pl
      [media] anysee: fix non-working E30 Combo Plus DVB-T

Archit Taneja (10):
      [media] v4l: ti-vpe: Fix the data_type value for UYVY VPDMA format
      [media] v4l: ti-vpe: make sure VPDMA line stride constraints are met
      [media] v4l: ti-vpe: create a scaler block library
      [media] v4l: ti-vpe: support loading of scaler coefficients
      [media] v4l: ti-vpe: make vpe driver load scaler coefficients
      [media] v4l: ti-vpe: enable basic scaler support
      [media] v4l: ti-vpe: create a color space converter block library
      [media] v4l: ti-vpe: Add helper to perform color conversion
      [media] v4l: ti-vpe: enable CSC support for VPE
      [media] v4l: ti-vpe: Add a type specifier to describe vpdma data format type

Arun Kumar K (1):
      [media] s5p-mfc: Add QP setting support for vp8 encoder

Dan Carpenter (6):
      [media] exynos4-is: Cleanup a define in mipi-csis driver
      [media] cx18: check for allocation failure in cx18_read_eeprom()
      [media] cxusb: unlock on error in cxusb_i2c_xfer()
      [media] dw2102: some missing unlocks on error
      [media] v4l: omap4iss: use snprintf() to make smatch happy
      [media] v4l: omap4iss: Restore irq flags correctly in omap4iss_video_buffer_next()

Daniel Jeong (1):
      [media] media: i2c: lm3560: fix missing unlock on error, fault handling

Dinesh Ram (8):
      [media] si4713: Reorganized drivers/media/radio directory
      [media] si4713: Modified i2c driver to handle cases where interrupts are not used
      [media] si4713: Reorganized includes in si4713.c/h
      [media] si4713: Bug fix for si4713_tx_tune_power() method in the i2c driver
      [media] si4713: HID blacklist Si4713 USB development board
      [media] si4713: Added the USB driver for Si4713
      [media] si4713: Added MAINTAINERS entry for radio-usb-si4713 driver
      [media] si4713: move supply list to si4713_platform_data

Eduardo Valentin (1):
      [media] si4713: print product number

Evgeny Plehov (2):
      [media] dw2102: Geniatech T220 support
      [media] dw2102: Use RC Core instead of the legacy RC (second edition)

Fengguang Wu (3):
      [media] fix coccinelle warnings
      [media] fix coccinelle warnings
      [media] em28xx: make 'em28xx_ctrl_ops' static

Frank Schaefer (18):
      [media] em28xx: add support for GPO controlled analog capturing LEDs
      [media] em28xx: extend the support for device buttons
      [media] em28xx: add debouncing mechanism for GPI-connected buttons
      [media] em28xx: prepare for supporting multiple LEDs
      [media] em28xx: add support for illumination button and LED
      [media] em28xx: add support for the SpeedLink Vicious And Devine Laplace webcams
      [media] em28xx: reduce the polling interval for GPI connected buttons
      [media] em28xx: fix I2S audio sample rate definitions and info output
      [media] em28xx-v4l: fix device initialization in em28xx_v4l2_open() for radio and VBI mode
      [media] em28xx: move usb buffer pre-allocation and transfer uninit from the core to the dvb extension
      [media] em28xx: move usb transfer uninit on device disconnect from the core to the v4l-extension
      [media] em28xx: move v4l2_device_disconnect() call from the core to the v4l extension
      [media] em28xx: move v4l2 dummy clock deregistration from the core to the v4l extension
      [media] em28xx-v4l: move v4l2_ctrl_handler freeing and v4l2_device unregistration to em28xx_v4l2_fini
      [media] em28xx: always call em28xx_release_resources() in the usb disconnect handler
      [media] em28xx-v4l: fix the freeing of the video devices memory
      [media] em28xx: fix usb alternate setting for analog and digital video endpoints > 0
      [media] em28xx: fix check for audio only usb interfaces when changing the usb alternate setting

Geert Uytterhoeven (1):
      [media] radio-shark: Mark shark_resume_leds() inline to kill compiler warning

Georg Kaindl (1):
      [media] usbtv: Add support for PAL video source

Hans Verkuil (45):
      [media] This adds support for the BCM2048 radio module found in Nokia N900
      [media] bcm2048: add TODO file for this staging driver
      [media] si4713: si4713_set_rds_radio_text overwrites terminating \0
      [media] si4713: coding style whitespace cleanups
      [media] si4713: coding style time-related cleanups
      [media] si470x: don't use buffer on the stack for USB transfers
      [media] si470x: add check to test if this is really a si470x
      [media] radio-raremono: add support for 'Thanko's Raremono' AM/FM/SW USB device
      [media] MAINTAINERS: add entry for new radio-raremono radio driver
      [media] sn9c102: prepare for removal by moving it to staging
      [media] omap24xx/tcm825x: move to staging for future removal
      [media] adv7604: adv7604_s_register clean up
      [media] adv7604: initialize timings to CEA 640x480p59.94
      [media] adv7842: support YCrCb analog input, receive CEA formats as RGB on VGA input
      [media] adv7842: set LLC DLL phase from platform_data
      [media] adv7842: initialize timings to CEA 640x480p59.94
      [media] adv7842: add drive strength enum and sync names with adv7604
      [media] v4l2: move tracepoints to video_usercopy
      [media] vb2: push the mmap semaphore down to __buf_prepare()
      [media] vb2: simplify qbuf/prepare_buf by removing callback
      [media] vb2: fix race condition between REQBUFS and QBUF/PREPARE_BUF
      [media] vb2: remove the 'fileio = NULL' hack
      [media] vb2: retry start_streaming in case of insufficient buffers
      [media] vb2: don't set index, don't start streaming for write()
      [media] vb2: return ENOBUFS in start_streaming in case of too few buffers
      [media] vb2: Improve file I/O emulation to handle buffers in any order
      [media] DocBook: drop the word 'only'
      [media] saa7134: move the queue data from saa7134_fh to saa7134_dev
      [media] saa7134: convert to the control framework
      [media] saa7134: cleanup radio/video/empress ioctl handling
      [media] saa7134: remove dev from saa7134_fh, use saa7134_fh for empress node
      [media] saa7134: share resource management between normal and empress nodes
      [media] saa7134: add support for control events
      [media] saa7134: use V4L2_IN_ST_NO_SIGNAL instead of NO_SYNC
      [media] saa6752hs: drop compat control code
      [media] saa6752hs: move to media/i2c
      [media] saa6752hs.h: drop empty header
      [media] saa7134: drop log_status for radio
      [media] saa6588: after calling CMD_CLOSE, CMD_POLL is broken
      [media] saa6588: remove unused CMD_OPEN
      [media] saa6588: add support for non-blocking mode
      [media] saa7134: don't set vfd->debug
      [media] davinci-vpfe: fix compile error
      [media] [for,v3.14] sn9c102: fix build dependency
      [media] solo6x10: fix broken PAL support

Hans de Goede (1):
      [media] radio-shark2: Mark shark_resume_leds() inline to kill compiler warning

Jacek Anaszewski (16):
      [media] s5p-jpeg: Reorder quantization tables
      [media] s5p-jpeg: Fix output YUV 4:2:0 fourcc for decoder
      [media] s5p-jpeg: Fix erroneous condition while validating bytesperline value
      [media] s5p-jpeg: Remove superfluous call to the jpeg_bound_align_image function
      [media] s5p-jpeg: Rename functions specific to the S5PC210 SoC accordingly
      [media] s5p-jpeg: Fix clock resource management
      [media] s5p-jpeg: Fix lack of spin_lock protection
      [media] s5p-jpeg: Synchronize cached controls with V4L2 core
      [media] s5p-jpeg: Split jpeg-hw.h to jpeg-hw-s5p.c and jpeg-hw-s5p.c
      [media] s5p-jpeg:  JPEG codec
      [media] s5p-jpeg: Retrieve "YCbCr subsampling" field from the jpeg header
      [media] s5p-jpeg: Ensure correct capture format for Exynos4x12
      [media] s5p-jpeg: Allow for wider JPEG subsampling scope for Exynos4x12 encoder
      [media] s5p-jpeg: Synchronize V4L2_CID_JPEG_CHROMA_SUBSAMPLING control value
      [media] s5p-jpeg: Ensure setting correct value of the chroma subsampling control
      [media] s5p-jpeg: Adjust g_volatile_ctrl callback to Exynos4x12 needs

Jassi Brar (1):
      [media] m2m-deinterlace: fix allocated struct type

Jingoo Han (1):
      [media] media: pci: remove DEFINE_PCI_DEVICE_TABLE macro

Joe Perches (1):
      [media] media: Remove OOM message after input_allocate_device

Jonathan McCrohan (1):
      [media] media_tree: Fix spelling errors

Josh Wu (2):
      [media] v4l: atmel-isi: remove SOF wait in start_streaming()
      [media] v4l: atmel-isi: Should clear bits before set the hardware register

Julia Lawall (2):
      [media] ec168: fix error return code
      [media] e4000: fix error return code

Kees Cook (1):
      [media] doc: no singing

Kiran AVND (1):
      [media] s5p-mfc: Add controls to set vp8 enc profile

Laurent Pinchart (71):
      [media] v4l: omap4iss: Add support for OMAP4 camera interface - Build system
      [media] v4l: omap4iss: Don't use v4l2_g_ext_ctrls() internally
      [media] v4l: omap4iss: Move common code out of switch...case
      [media] v4l: omap4iss: Report device caps in response to VIDIOC_QUERYCAP
      [media] v4l: omap4iss: Remove iss_video streaming field
      [media] v4l: omap4iss: Set the vb2 timestamp type
      [media] v4l: omap4iss: Remove duplicate video_is_registered() check
      [media] v4l: omap4iss: Remove unneeded status variable
      [media] v4l: omap4iss: Replace udelay/msleep with usleep_range
      [media] v4l: omap4iss: Make omap4iss_isp_subclk_(en|dis)able() functions void
      [media] v4l: omap4iss: Make loop counters unsigned where appropriate
      [media] v4l: omap4iss: Don't initialize fields to 0 manually
      [media] v4l: omap4iss: Simplify error paths
      [media] v4l: omap4iss: Don't check for missing get_fmt op on remote subdev
      [media] v4l: omap4iss: Translate -ENOIOCTLCMD to -ENOTTY
      [media] v4l: omap4iss: Move code out of mutex-protected section
      [media] v4l: omap4iss: Implement VIDIOC_S_INPUT
      [media] v4l: sh_vou: Enable driver compilation with COMPILE_TEST
      [media] v4l: vs6624: Fix warning due to unused function
      [media] v4l: omap4iss: Replace printk by dev_err
      [media] v4l: omap4iss: Don't split log strings on multiple lines
      [media] v4l: omap4iss: Restrict line lengths to 80 characters where possible
      [media] v4l: omap4iss: Remove double semicolon at end of line
      [media] v4l: omap4iss: Define more ISS and ISP IRQ register bits
      [media] v4l: omap4iss: isif: Define more VDINT registers
      [media] v4l: omap4iss: Enhance IRQ debugging
      [media] v4l: omap4iss: Don't make IRQ debugging functions inline
      [media] v4l: omap4iss: Fix operators precedence in ternary operators
      [media] v4l: omap4iss: isif: Ignore VD0 interrupts when no buffer is available
      [media] v4l: omap4iss: ipipeif: Shift input data according to the input format
      [media] v4l: omap4iss: csi2: Enable automatic ULP mode transition
      [media] v4l: omap4iss: Create and use register access functions
      [media] v4l: omap4iss: csi: Create and use register access functions
      [media] v4l: omap4iss: resizer: Stop the whole resizer to avoid FIFO overflows
      [media] v4l: omap4iss: Convert hexadecimal constants to lower case
      [media] v4l: omap4iss: Add description field to iss_format_info structure
      [media] v4l: omap4iss: Make __iss_video_get_format() return a v4l2_mbus_framefmt
      [media] v4l: omap4iss: Add enum_fmt_vid_cap ioctl support
      [media] v4l: omap4iss: Propagate stop timeouts from submodules to the driver core
      [media] v4l: omap4iss: Enable/disabling the ISP interrupts globally
      [media] v4l: omap4iss: Reset the ISS when the pipeline can't be stopped
      [media] v4l: omap4iss: csi2: Replace manual if statement with a subclk field
      [media] v4l: omap4iss: Cancel streaming when a fatal error occurs
      [media] v4l: omap4iss: resizer: Fix comment regarding bypass mode
      [media] mt9v032: Remove unused macro
      [media] mt9v032: Fix pixel array size
      [media] mt9v032: Fix binning configuration
      [media] mt9v032: Add support for monochrome models
      [media] mt9v032: Add support for model-specific parameters
      [media] mt9v032: Add support for the MT9V034
      [media] v4l: vsp1: Supply frames to the DU continuously
      [media] v4l: vsp1: Add cropping support
      [media] v4l: Add media format codes for AHSV8888 on 32-bit busses
      [media] v4l: vsp1: Add HST and HSI support
      [media] v4l: vsp1: Add SRU support
      [media] v4l: vsp1: Add LUT support
      [media] omap3isp: Use devm_ioremap_resource()
      [media] omap3isp: Fix buffer flags handling when querying buffer
      [media] v4l: of: Return an int in v4l2_of_parse_endpoint()
      [media] v4l: of: Remove struct v4l2_of_endpoint remote field
      [media] v4l: of: Drop endpoint node reference in v4l2_of_get_remote_port()
      [media] v4l: atmel-isi: Use devm_* managed allocators
      [media] v4l: atmel-isi: Defer clock (un)preparation to enable/disable time
      [media] v4l: atmel-isi: Reset the ISI when starting the stream
      [media] v4l: atmel-isi: Make the MCK clock optional
      [media] v4l: atmel-isi: Fix color component ordering
      [media] v4l: sh_vou: Fix warnings due to improper casts and printk formats
      [media] omap3isp: Cancel streaming when a fatal error occurs
      [media] omap3isp: Refactor modules stop failure handling
      [media] omap3isp: ccdc: Don't hang when the SBL fails to become idle
      [media] vb2: Fix comment in __qbuf_dmabuf

Libin Yang (2):
      [media] marvell-ccic: drop resource free in driver remove
      [media] media: marvell-ccic: use devm to release clk

Links (Markus) (1):
      [media] cx231xx: add support for a CX23103 Video Grabber USB

Lisa Nguyen (2):
      [media] staging: media: davinci_vpfe: Remove spaces before semicolons
      [media] staging: media: davinci_vpfe: Rewrite return statement in vpfe_video.c

Luis Alves (2):
      [media] cx24117: Add complete demod command list
      [media] cx24117: Fix LNB set_voltage function

Malcolm Priestley (6):
      [media] it913x: Add support for Avermedia H335 id 0x0335
      [media] m88rs2000: add m88rs2000_set_carrieroffset
      [media] m88rs2000: set symbol rate accurately
      [media] m88rs2000: correct read status lock value
      [media] m88rs2000: Correct m88rs2000_set_fec settings
      [media] m88rs2000: Correct m88rs2000_get_fec

Marek Szyprowski (2):
      [media] media: s5p_mfc: remove s5p_mfc_get_node_type() function
      [media] media: v4l2-dev: fix video device index assignment

Martin Bugge (27):
      [media] ad9389b: whitespace changes to improve readability
      [media] ad9389b: remove rx-sense irq dependency
      [media] ad9389b: retry setup if the state is inconsistent
      [media] adv7511: disable register reset by HPD
      [media] adv7511: add VIC and audio CTS/N values to log_status
      [media] adv7511: verify EDID header
      [media] adv7604: support 1366x768 DMT Reduced Blanking
      [media] adv7604: set restart_stdi_once flag when signal is lost
      [media] adv7604: sync polarities from platform data
      [media] adv7842: Re-worked query_dv_timings()
      [media] adv7842: corrected setting of cp-register 0x91 and 0x8f
      [media] adv7842: properly enable/disable the irqs
      [media] adv7842: save platform data in state struct
      [media] adv7842: added DE vertical position in SDP-io-sync
      [media] adv7842: set defaults spa-location
      [media] adv7842: 625/525 line standard jitter fix
      [media] adv7842: set default input in platform-data
      [media] adv7842: increase wait time
      [media] adv7842: clear edid, if no edid just disable Edid-DDC access
      [media] adv7842: restart STDI once if format is not found
      [media] adv7842: support g_edid ioctl
      [media] adv7842: i2c dummy clients registration
      [media] adv7842: enable HDMI/DVI mode irq
      [media] adv7842: composite sd-ram test, clear timings before setting
      [media] adv7842: obtain free-run mode from the platform_data
      [media] adv7842: Composite sync adjustment
      [media] adv7842: return 0 if no change in s_dv_timings

Mateusz Krawczuk (3):
      [media] s5p-tv: sdo: Restore vpll clock rate after streamoff
      [media] s5p-tv: sdo: Prepare for common clock framework
      [media] s5p-tv: mixer: Prepare for common clock framework

Mats Randgaard (16):
      [media] ad9389b: verify EDID header
      [media] adv7604: add support for all the digital input ports
      [media] adv7604: Receive CEA formats as RGB on VGA (RGB) input
      [media] adv7604: select YPbPr if RGB_RANGE_FULL/LIMITED is set for VGA_COMP inputs
      [media] adv7604: set CEC address (SPA) in EDID
      [media] adv7604: improve EDID handling
      [media] adv7604: remove connector type. Never used for anything useful
      [media] adv7604: return immediately if the new input is equal to what is configured
      [media] adv7604: remove debouncing of ADV7604_FMT_CHANGE events
      [media] adv7604: improve HDMI audio handling
      [media] adv7604: adjust gain and offset for DVI-D signals
      [media] adv7604: Enable HDMI_MODE interrupt
      [media] adv7604: return immediately if the new timings are equal to what is configured
      [media] adv7842: remove connector type. Never used for anything useful
      [media] adv7842: Use defines to select EDID port
      [media] adv7842: mute audio before switching inputs to avoid noise/pops

Matthias Schwarzott (4):
      [media] mceusb: Add Hauppauge WinTV-HVR-930C HD
      [media] cx231xx: Add missing selects for MEDIA_SUBDRV_AUTOSELECT
      [media] cx231xx: fix i2c debug prints
      [media] cx231xx: Add missing KERN_CONT to i2c debug prints

Mauro Carvalho Chehab (71):
      Merge tag 'v3.13-rc1' into patchwork
      [media] radio-bcm2048: fix signal of value
      Merge branch 'upstream-fixes' into patchwork
      [media] dib8000: make 32 bits read atomic
      [media] dib8000: Don't let tuner hang due to a call to get_frontend()
      [media] dib8000: improves the auto search mode check logic
      [media] dib8000: report Interleaving 4 correctly
      [media] dib8000: add DVBv5 stats
      [media] dib8000: estimate strength in dBm
      [media] dib8000: make a better estimation for dBm
      [media] dib8000: Fix UCB measure with DVBv5 stats
      [media] dib8000: be sure that stats are available before reading them
      [media] dib8000: improve block statistics
      [media] dib8000: fix compilation error
      [media] subdev autoselect only works if I2C and I2C_MUX is selected
      [media] tvp5150: make read operations atomic
      [media] tuner-xc2028: remove unused code
      [media] em28xx: move some video-specific functions to em28xx-video
      [media] em28xx: some cosmetic changes
      [media] em28xx: Fix em28xx deplock
      [media] em28xx: move analog-specific init to em28xx-video
      [media] em28xx: unregister i2c bus 0 if bus 1 fails to register
      [media] em28xx: make em28xx-video to be a separate module
      [media] em28xx: improve extension information messages
      [media] em28xx: check if a device has audio earlier
      [media] em28xx: unify module version
      [media] em28xx: prevent registering wrong interfaces for audio-only
      [media] em28xx: only initialize extensions on the main interface
      [media] videobuf2: Fix CodingStyle
      [media] export em28xx_release_resources() symbol
      [media] em28xx: use usb_alloc_coherent() for audio
      [media] em28xx-audio: allocate URBs at device driver init
      [media] tuner-xc2028: Don't try to sleep twice
      [media] tuner-xc2028: Don't read status if device is powered down
      [media] em28xx: properly implement AC97 wait code
      [media] em28xx: convert i2c wait completion logic to use jiffies
      [media] em28xx: rename I2C timeout to EM28XX_I2C_XFER_TIMEOUT
      [media] em28xx: use a better value for I2C timeouts
      [media] em28xx-i2c: Fix error code for I2C error transfers
      [media] em28xx-i2c: cleanup I2C debug messages
      [media] em28xx-i2c: add timeout debug information if i2c_debug enabled
      [media] em28xx-audio: use bInterval on em28xx-audio
      [media] em28xx-audio: Fix error path
      [media] em28xx-audio: don't hardcode audio URB calculus
      [media] em28xx-audio: fix the period size in bytes
      [media] em28xx-audio: don't wait for lock in non-block mode
      [media] em28xx-audio: split URB initialization code
      [media] em28xx-audio: return -ENODEV when the device is disconnected
      [media] nxt200x: increase write buffer size
      [media] em28xx: fix xc3028 demod and firmware setup on DVB
      [media] sh_vou: comment unused vars
      [media] radio-usb-si4713: make si4713_register_i2c_adapter static
      [media] dib8000: Properly represent long long integers
      [media] dib8000: Fix a few warnings when compiled for avr32
      [media] go7007-usb: only use go->dev after allocated
      [media] lirc_parallel: avoid name conflict on mn10300 arch
      [media] tea575x: Fix build with ARCH=c6x
      [media] em28xx-audio: fix return code on device disconnect
      [media] em28xx-audio: simplify error handling
      [media] em28xx-audio: disconnect before freeing URBs
      [media] em28xx: print a message at disconnect
      [media] em28xx: Fix usb diconnect logic
      [media] em28xx: push mutex down to extensions on .fini callback
      [media] em28xx: adjust period size at runtime
      [media] drxk: remove the option to load firmware asynchronously
      [media] em28xx-audio: flush work at .fini
      em28xx-alsa: Fix error patch for init/fini
      [media] em28xx-audio: provide an error code when URB submit fails
      Revert "[media] go7007-usb: only use go->dev after allocated"
      [media] em28xx-cards: properly initialize the device bitmap
      [media] rc-core: reuse device numbers

Mauro Dreissig (2):
      [media] staging: as102: Declare local variables as static
      [media] staging: as102: Remove ENTER/LEAVE debugging macros

Mikhail Khelik (1):
      [media] adv7604: add hdmi driver strength adjustment

Monam Agarwal (3):
      [media] Staging: media: Fix quoted string split across line in as102_fe.c
      [media] Staging: media: Fix line length exceeding 80 characters in as102_fe.c
      [media] Staging: media: Fix line length exceeding 80 characters in as102_drv.c

Olivier Grenie (1):
      [media] dib8000: fix regression with dib807x

Philipp Zabel (1):
      [media] videobuf2: Add support for file access mode flags for DMABUF exporting

Ricardo Ribalda (7):
      [media] em28xx-video: Swap release order to avoid lock nesting
      [media] ths7303: Declare as static a private function
      [media] videobuf2-dma-sg: Fix typo on debug message
      [media] vb2: Return 0 when streamon and streamoff are already on/off
      [media] videobuf2: Add missing lock held on vb2_fop_release
      [media] videobuf2-dma-sg: Support io userptr operations on io memory
      [media] videodev2: Set vb2_rect's width and height as unsigned

Ricardo Ribalda Delgado (1):
      [media] smiapp: Fix BUG_ON() on an impossible condition

Robert Backhaus (1):
      [media] Add USB IDs for Winfast DTV Dongle Mini-D

Roel Kluin (1):
      [media] exynos4-is: fimc-lite: Index out of bounds if no pixelcode found

Roland Scheidegger (1):
      [media] az6007: support Technisat Cablestar Combo HDCI (minus remote)

Sachin Kamat (4):
      [media] mt9p031: Include linux/of.h header
      [media] s5k5baf: Fix build warning
      [media] s5k5baf: Fix checkpatch error
      [media] s5k5baf: Fix potential NULL pointer dereferencing

Sakari Ailus (5):
      [media] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
      [media] media: Check for active links on pads with MEDIA_PAD_FL_MUST_CONNECT flag
      [media] omap3isp: Mark which pads must connect
      [media] omap3isp: Add resizer data rate configuration to resizer_link_validate
      [media] media: Include linux/kernel.h for DIV_ROUND_UP()

Sergio Aguirre (5):
      [media] v4l: omap4iss: Add support for OMAP4 camera interface - Core
      [media] v4l: omap4iss: Add support for OMAP4 camera interface - Video devices
      [media] v4l: omap4iss: Add support for OMAP4 camera interface - CSI receivers
      [media] v4l: omap4iss: Add support for OMAP4 camera interface - IPIPE(IF)
      [media] v4l: omap4iss: Add support for OMAP4 camera interface - Resizer

Seung-Woo Kim (2):
      [media] videobuf2: Add log for size checking error in __qbuf_dmabuf
      [media] s5p-jpeg: Fix encoder and decoder video dev names

Srinivas Kandagatla (1):
      [media] media: st-rc: Add reset support

Sylwester Nawrocki (14):
      [media] V4L: Add mem2mem ioctl and file operation helpers
      [media] mem2mem_testdev: Use mem-to-mem ioctl and vb2 helpers
      [media] exynos4-is: Use mem-to-mem ioctl helpers
      [media] s5p-jpeg: Use mem-to-mem ioctl helpers
      [media] s5p-g2d: Use mem-to-mem ioctl helpers
      [media] exynos4-is: Simplify fimc-is hardware polling helpers
      [media] s5p-jpeg: Add initial device tree support for S5PV210/Exynos4210 SoCs
      [media] omap3isp: Modify clocks registration to avoid circular references
      [media] exynos4-is: Leave FIMC clocks enabled when runtime PM is disabled
      [media] exynos4-is: Activate mipi-csis in probe() if runtime PM is disabled
      [media] exynos4-is: Enable FIMC-LITE clock if runtime PM is not used
      [media] exynos4-is: Correct clean up sequence on error path in fimc_is_probe()
      [media] exynos4-is: Enable fimc-is clocks in probe() if runtime PM is disabled
      [media] exynos4-is: Remove dependency on PM_RUNTIME from Kconfig

Tim Mester (2):
      [media] au8028: Fix cleanup on kzalloc fail
      [media] au0828: Add option to preallocate digital transfer buffers

Valentine Barshak (1):
      [media] media: soc_camera: rcar_vin: Add preliminary R-Car M2 support

Wade Farnsworth (1):
      [media] v4l2-dev: Add tracepoints for QBUF and DQBUF

Wei Yongjun (10):
      [media] v4l: ti-vpe: use module_platform_driver to simplify the code
      [media] v4l: ti-vpe: fix error return code in vpe_probe()
      [media] v4l: ti-vpe: fix return value check in vpe_probe()
      [media] media: i2c: lm3560: fix missing unlock on error in lm3560_set_ctrl()
      [media] media: i2c: lm3560: use correct clientdata in lm3560_remove()
      [media] cx88: use correct pci drvdata type in cx88_audio_finidev()
      [media] radio-bcm2048: fix missing unlock on error in bcm2048_rds_fifo_receive()
      [media] au0828: Fix sparse non static symbol warning
      [media] em28xx-audio: remove needless check before usb_free_coherent()
      [media] radio-usb-si4713: fix sparse non static symbol warnings

 Documentation/DocBook/media/v4l/compat.xml         |   12 +
 Documentation/DocBook/media/v4l/controls.xml       |   41 +
 Documentation/DocBook/media/v4l/dev-overlay.xml    |    9 +-
 .../DocBook/media/v4l/media-ioc-enum-links.xml     |    9 +
 Documentation/DocBook/media/v4l/subdev-formats.xml |  163 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |   10 +-
 Documentation/DocBook/media/v4l/vidioc-cropcap.xml |   10 +-
 .../DocBook/media/v4l/vidioc-streamon.xml          |    2 +-
 Documentation/cgroups/resource_counter.txt         |    2 +-
 .../bindings/media/exynos-jpeg-codec.txt           |   11 +
 .../devicetree/bindings/media/samsung-s5k5baf.txt  |   58 +
 Documentation/video4linux/omap4_camera.txt         |   60 +
 Documentation/video4linux/si476x.txt               |    2 +-
 MAINTAINERS                                        |   50 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    7 +
 arch/blackfin/mach-bf609/boards/ezkit.c            |    4 +-
 arch/score/lib/checksum.S                          |    2 +-
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    2 +
 drivers/media/Kconfig                              |    3 +
 drivers/media/dvb-core/dvb-usb-ids.h               |    3 +
 drivers/media/dvb-frontends/Kconfig                |    7 +
 drivers/media/dvb-frontends/Makefile               |    1 +
 drivers/media/dvb-frontends/a8293.c                |    2 +
 drivers/media/dvb-frontends/cx24117.c              |  121 +-
 drivers/media/dvb-frontends/dib8000.c              |  590 ++++-
 drivers/media/dvb-frontends/drxk.h                 |    2 -
 drivers/media/dvb-frontends/drxk_hard.c            |   24 +-
 drivers/media/dvb-frontends/m88ds3103.c            | 1311 ++++++++++
 drivers/media/dvb-frontends/m88ds3103.h            |  114 +
 drivers/media/dvb-frontends/m88ds3103_priv.h       |  215 ++
 drivers/media/dvb-frontends/m88rs2000.c            |  172 +-
 drivers/media/dvb-frontends/m88rs2000.h            |    2 +
 drivers/media/dvb-frontends/nxt200x.c              |    2 +-
 drivers/media/i2c/Kconfig                          |   27 +-
 drivers/media/i2c/Makefile                         |    3 +-
 drivers/media/i2c/ad9389b.c                        |  277 +-
 drivers/media/i2c/adv7511.c                        |   64 +-
 drivers/media/i2c/adv7604.c                        |  645 +++--
 drivers/media/i2c/adv7842.c                        |  646 +++--
 drivers/media/i2c/lm3560.c                         |   34 +-
 drivers/media/i2c/mt9m032.c                        |   16 +-
 drivers/media/i2c/mt9p031.c                        |   28 +-
 drivers/media/i2c/mt9t001.c                        |   26 +-
 drivers/media/i2c/mt9v032.c                        |  264 +-
 drivers/media/i2c/s5k5baf.c                        | 2045 +++++++++++++++
 drivers/media/i2c/saa6588.c                        |   50 +-
 drivers/media/{pci/saa7134 => i2c}/saa6752hs.c     |   19 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |    9 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |    4 +-
 drivers/media/i2c/tvp5150.c                        |   40 +-
 drivers/media/i2c/vs6624.c                         |    2 +
 drivers/media/media-entity.c                       |   41 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   10 +-
 drivers/media/pci/cx18/cx18-driver.c               |    5 +-
 drivers/media/pci/cx25821/cx25821-alsa.c           |    2 +-
 drivers/media/pci/cx25821/cx25821-core.c           |    2 +-
 drivers/media/pci/cx88/cx88-alsa.c                 |    4 +-
 drivers/media/pci/saa7134/Kconfig                  |    1 +
 drivers/media/pci/saa7134/Makefile                 |    2 +-
 drivers/media/pci/saa7134/saa7134-core.c           |   11 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |  359 +--
 drivers/media/pci/saa7134/saa7134-vbi.c            |   11 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  781 ++----
 drivers/media/pci/saa7134/saa7134.h                |   66 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    2 +-
 drivers/media/platform/Kconfig                     |   10 +-
 drivers/media/platform/Makefile                    |    3 -
 drivers/media/platform/davinci/vpbe_display.c      |    2 +-
 drivers/media/platform/davinci/vpif_capture.c      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |    2 +-
 drivers/media/platform/exynos4-is/Kconfig          |    2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |   29 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    2 -
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |   36 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.h   |    1 -
 drivers/media/platform/exynos4-is/fimc-is.c        |   29 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |    4 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   26 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  148 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   13 +-
 drivers/media/platform/m2m-deinterlace.c           |    2 +-
 drivers/media/platform/mem2mem_testdev.c           |  152 +-
 drivers/media/platform/omap3isp/isp.c              |  100 +-
 drivers/media/platform/omap3isp/isp.h              |    6 +-
 drivers/media/platform/omap3isp/ispccdc.c          |    5 +-
 drivers/media/platform/omap3isp/ispccp2.c          |    3 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |    3 +-
 drivers/media/platform/omap3isp/isppreview.c       |    3 +-
 drivers/media/platform/omap3isp/ispqueue.c         |    2 +
 drivers/media/platform/omap3isp/ispresizer.c       |   18 +-
 drivers/media/platform/omap3isp/ispstat.c          |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |  106 +-
 drivers/media/platform/omap3isp/ispvideo.h         |    2 +
 drivers/media/platform/s5p-g2d/g2d.c               |  124 +-
 drivers/media/platform/s5p-g2d/g2d.h               |    1 -
 drivers/media/platform/s5p-jpeg/Makefile           |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 1329 +++++++---
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   69 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c  |  279 ++
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h  |   42 +
 .../platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} |   82 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h      |   63 +
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  209 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   28 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   14 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   57 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |   26 +-
 drivers/media/platform/s5p-tv/mixer_drv.c          |   34 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |    2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |   39 +-
 drivers/media/platform/sh_vou.c                    |   16 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |  179 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    2 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |    7 +-
 drivers/media/platform/soc_camera/soc_scale_crop.c |    4 +-
 drivers/media/platform/ti-vpe/Makefile             |    2 +-
 drivers/media/platform/ti-vpe/csc.c                |  196 ++
 drivers/media/platform/ti-vpe/csc.h                |   68 +
 drivers/media/platform/ti-vpe/sc.c                 |  311 +++
 drivers/media/platform/ti-vpe/sc.h                 |  208 ++
 drivers/media/platform/ti-vpe/sc_coeff.h           | 1342 ++++++++++
 drivers/media/platform/ti-vpe/vpdma.c              |   40 +-
 drivers/media/platform/ti-vpe/vpdma.h              |   12 +-
 drivers/media/platform/ti-vpe/vpdma_priv.h         |    2 +-
 drivers/media/platform/ti-vpe/vpe.c                |  327 ++-
 drivers/media/platform/ti-vpe/vpe_regs.h           |  187 --
 drivers/media/platform/vsp1/Makefile               |    3 +-
 drivers/media/platform/vsp1/vsp1.h                 |    7 +
 drivers/media/platform/vsp1/vsp1_drv.c             |   39 +
 drivers/media/platform/vsp1/vsp1_entity.c          |    7 +
 drivers/media/platform/vsp1/vsp1_entity.h          |    4 +
 drivers/media/platform/vsp1/vsp1_hsit.c            |  222 ++
 drivers/media/platform/vsp1/vsp1_hsit.h            |   38 +
 drivers/media/platform/vsp1/vsp1_lut.c             |  252 ++
 drivers/media/platform/vsp1/vsp1_lut.h             |   38 +
 drivers/media/platform/vsp1/vsp1_regs.h            |   16 +
 drivers/media/platform/vsp1/vsp1_rpf.c             |   34 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |   96 +
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   10 +
 drivers/media/platform/vsp1/vsp1_sru.c             |  356 +++
 drivers/media/platform/vsp1/vsp1_sru.h             |   41 +
 drivers/media/platform/vsp1/vsp1_video.c           |   13 +
 drivers/media/platform/vsp1/vsp1_wpf.c             |   17 +-
 drivers/media/radio/Kconfig                        |   43 +-
 drivers/media/radio/Makefile                       |    4 +-
 drivers/media/radio/radio-raremono.c               |  387 +++
 drivers/media/radio/si470x/radio-si470x-usb.c      |   81 +-
 drivers/media/radio/si470x/radio-si470x.h          |    1 +
 drivers/media/radio/si4713/Kconfig                 |   40 +
 drivers/media/radio/si4713/Makefile                |    7 +
 .../radio-platform-si4713.c}                       |    0
 drivers/media/radio/si4713/radio-usb-si4713.c      |  540 ++++
 .../media/radio/{si4713-i2c.c => si4713/si4713.c}  |  279 +-
 .../media/radio/{si4713-i2c.h => si4713/si4713.h}  |    4 +-
 drivers/media/radio/tea575x.c                      |    2 +-
 drivers/media/rc/imon.c                            |    8 +-
 drivers/media/rc/keymaps/Makefile                  |    3 +-
 drivers/media/rc/keymaps/rc-su3000.c               |   75 +
 drivers/media/rc/mceusb.c                          |   10 +
 drivers/media/rc/rc-main.c                         |   20 +-
 drivers/media/rc/st_rc.c                           |   13 +
 drivers/media/tuners/Kconfig                       |    7 +
 drivers/media/tuners/Makefile                      |    1 +
 drivers/media/tuners/e4000.c                       |   16 +-
 drivers/media/tuners/m88ts2022.c                   |  674 +++++
 drivers/media/tuners/m88ts2022.h                   |   54 +
 drivers/media/tuners/m88ts2022_priv.h              |   34 +
 drivers/media/tuners/tuner-xc2028.c                |   38 +-
 drivers/media/usb/Kconfig                          |    1 -
 drivers/media/usb/Makefile                         |    1 -
 drivers/media/usb/au0828/au0828-core.c             |   13 +-
 drivers/media/usb/au0828/au0828-dvb.c              |  116 +-
 drivers/media/usb/au0828/au0828.h                  |    6 +
 drivers/media/usb/cx231xx/Kconfig                  |    2 +
 drivers/media/usb/cx231xx/cx231xx-cards.c          |    2 +
 drivers/media/usb/cx231xx/cx231xx-i2c.c            |   23 +-
 drivers/media/usb/dvb-usb-v2/anysee.c              |    3 +-
 drivers/media/usb/dvb-usb-v2/az6007.c              |   59 +
 drivers/media/usb/dvb-usb-v2/ec168.c               |    2 +-
 drivers/media/usb/dvb-usb-v2/it913x.c              |    3 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |    2 +
 drivers/media/usb/dvb-usb/cxusb.c                  |   21 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |  455 ++--
 drivers/media/usb/em28xx/Kconfig                   |    8 +-
 drivers/media/usb/em28xx/Makefile                  |    5 +-
 drivers/media/usb/em28xx/em28xx-audio.c            |  429 ++-
 drivers/media/usb/em28xx/em28xx-camera.c           |    1 +
 drivers/media/usb/em28xx/em28xx-cards.c            |  553 ++--
 drivers/media/usb/em28xx/em28xx-core.c             |  410 +--
 drivers/media/usb/em28xx/em28xx-dvb.c              |  112 +-
 drivers/media/usb/em28xx/em28xx-i2c.c              |  199 +-
 drivers/media/usb/em28xx/em28xx-input.c            |  209 +-
 drivers/media/usb/em28xx/em28xx-reg.h              |   11 +-
 drivers/media/usb/em28xx/em28xx-v4l.h              |   20 +
 drivers/media/usb/em28xx/em28xx-vbi.c              |    1 +
 drivers/media/usb/em28xx/em28xx-video.c            |  652 ++++-
 drivers/media/usb/em28xx/em28xx.h                  |  120 +-
 drivers/media/usb/pwc/pwc-if.c                     |    1 -
 drivers/media/v4l2-core/Kconfig                    |   11 -
 drivers/media/v4l2-core/Makefile                   |    1 -
 drivers/media/v4l2-core/v4l2-ctrls.c               |    5 +
 drivers/media/v4l2-core/v4l2-dev.c                 |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    9 +
 drivers/media/v4l2-core/v4l2-mem2mem.c             |  126 +
 drivers/media/v4l2-core/v4l2-of.c                  |   10 +-
 drivers/media/v4l2-core/videobuf2-core.c           |  480 ++--
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |   53 +-
 drivers/staging/media/Kconfig                      |    8 +
 drivers/staging/media/Makefile                     |    5 +
 drivers/staging/media/as102/as102_drv.c            |   13 +-
 drivers/staging/media/as102/as102_drv.h            |    8 -
 drivers/staging/media/as102/as102_fe.c             |   37 +-
 drivers/staging/media/as102/as102_fw.c             |   16 +-
 drivers/staging/media/as102/as102_usb_drv.c        |   36 +-
 drivers/staging/media/as102/as10x_cmd.c            |   21 -
 drivers/staging/media/as102/as10x_cmd_cfg.c        |    9 -
 drivers/staging/media/as102/as10x_cmd_stream.c     |   12 -
 drivers/staging/media/bcm2048/Kconfig              |   13 +
 drivers/staging/media/bcm2048/Makefile             |    1 +
 drivers/staging/media/bcm2048/TODO                 |   24 +
 drivers/staging/media/bcm2048/radio-bcm2048.c      | 2744 ++++++++++++++++++++
 drivers/staging/media/bcm2048/radio-bcm2048.h      |   30 +
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |    2 +-
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |    4 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |    3 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    4 +-
 drivers/staging/media/lirc/lirc_parallel.c         |    4 +-
 drivers/staging/media/lirc/lirc_serial.c           |    4 +-
 drivers/staging/media/omap24xx/Kconfig             |   35 +
 drivers/staging/media/omap24xx/Makefile            |    5 +
 .../media/omap24xx}/omap24xxcam-dma.c              |    0
 .../media/omap24xx}/omap24xxcam.c                  |    0
 .../media/omap24xx}/omap24xxcam.h                  |    2 +-
 .../i2c => staging/media/omap24xx}/tcm825x.c       |    2 +-
 .../i2c => staging/media/omap24xx}/tcm825x.h       |    2 +-
 .../media/omap24xx}/v4l2-int-device.c              |    2 +-
 .../staging/media/omap24xx}/v4l2-int-device.h      |    0
 drivers/staging/media/omap4iss/Kconfig             |   12 +
 drivers/staging/media/omap4iss/Makefile            |    6 +
 drivers/staging/media/omap4iss/TODO                |    4 +
 drivers/staging/media/omap4iss/iss.c               | 1563 +++++++++++
 drivers/staging/media/omap4iss/iss.h               |  236 ++
 drivers/staging/media/omap4iss/iss_csi2.c          | 1343 ++++++++++
 drivers/staging/media/omap4iss/iss_csi2.h          |  158 ++
 drivers/staging/media/omap4iss/iss_csiphy.c        |  279 ++
 drivers/staging/media/omap4iss/iss_csiphy.h        |   51 +
 drivers/staging/media/omap4iss/iss_ipipe.c         |  570 ++++
 drivers/staging/media/omap4iss/iss_ipipe.h         |   67 +
 drivers/staging/media/omap4iss/iss_ipipeif.c       |  849 ++++++
 drivers/staging/media/omap4iss/iss_ipipeif.h       |   92 +
 drivers/staging/media/omap4iss/iss_regs.h          |  901 +++++++
 drivers/staging/media/omap4iss/iss_resizer.c       |  893 +++++++
 drivers/staging/media/omap4iss/iss_resizer.h       |   75 +
 drivers/staging/media/omap4iss/iss_video.c         | 1226 +++++++++
 drivers/staging/media/omap4iss/iss_video.h         |  204 ++
 .../{media/usb => staging/media}/sn9c102/Kconfig   |    9 +-
 .../{media/usb => staging/media}/sn9c102/Makefile  |    0
 .../{media/usb => staging/media}/sn9c102/sn9c102.h |    0
 .../staging/media/sn9c102}/sn9c102.txt             |    0
 .../usb => staging/media}/sn9c102/sn9c102_config.h |    0
 .../usb => staging/media}/sn9c102/sn9c102_core.c   |    0
 .../media}/sn9c102/sn9c102_devtable.h              |    0
 .../media}/sn9c102/sn9c102_hv7131d.c               |    0
 .../media}/sn9c102/sn9c102_hv7131r.c               |    0
 .../usb => staging/media}/sn9c102/sn9c102_mi0343.c |    0
 .../usb => staging/media}/sn9c102/sn9c102_mi0360.c |    0
 .../media}/sn9c102/sn9c102_mt9v111.c               |    0
 .../usb => staging/media}/sn9c102/sn9c102_ov7630.c |    0
 .../usb => staging/media}/sn9c102/sn9c102_ov7660.c |    0
 .../media}/sn9c102/sn9c102_pas106b.c               |    0
 .../media}/sn9c102/sn9c102_pas202bcb.c             |    0
 .../usb => staging/media}/sn9c102/sn9c102_sensor.h |    0
 .../media}/sn9c102/sn9c102_tas5110c1b.c            |    0
 .../media}/sn9c102/sn9c102_tas5110d.c              |    0
 .../media}/sn9c102/sn9c102_tas5130d1b.c            |    0
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |    2 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2.c     |    7 +-
 drivers/staging/media/solo6x10/solo6x10.h          |    2 +-
 include/linux/platform_data/vsp1.h                 |    2 +
 include/media/adv7604.h                            |   38 +-
 include/media/adv7842.h                            |   59 +-
 include/media/atmel-isi.h                          |    2 +
 include/media/media-entity.h                       |    1 +
 include/media/omap4iss.h                           |   65 +
 include/media/rc-map.h                             |    1 +
 include/media/saa6588.h                            |    2 +-
 include/media/saa6752hs.h                          |   26 -
 include/media/si4713.h                             |    2 +
 include/media/v4l2-fh.h                            |    4 +
 include/media/v4l2-mem2mem.h                       |   24 +
 include/media/v4l2-of.h                            |    6 +-
 include/media/videobuf2-core.h                     |   18 +-
 include/trace/events/v4l2.h                        |  157 ++
 include/uapi/linux/media.h                         |    1 +
 include/uapi/linux/v4l2-controls.h                 |    9 +
 include/uapi/linux/v4l2-mediabus.h                 |    3 +
 include/uapi/linux/videodev2.h                     |    4 +-
 include/uapi/linux/vsp1.h                          |   34 +
 300 files changed, 29155 insertions(+), 5107 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
 create mode 100644 Documentation/video4linux/omap4_camera.txt
 create mode 100644 drivers/media/dvb-frontends/m88ds3103.c
 create mode 100644 drivers/media/dvb-frontends/m88ds3103.h
 create mode 100644 drivers/media/dvb-frontends/m88ds3103_priv.h
 create mode 100644 drivers/media/i2c/s5k5baf.c
 rename drivers/media/{pci/saa7134 => i2c}/saa6752hs.c (98%)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h
 rename drivers/media/platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} (70%)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h
 create mode 100644 drivers/media/platform/ti-vpe/csc.c
 create mode 100644 drivers/media/platform/ti-vpe/csc.h
 create mode 100644 drivers/media/platform/ti-vpe/sc.c
 create mode 100644 drivers/media/platform/ti-vpe/sc.h
 create mode 100644 drivers/media/platform/ti-vpe/sc_coeff.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_hsit.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hsit.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_lut.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_lut.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_sru.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_sru.h
 create mode 100644 drivers/media/radio/radio-raremono.c
 create mode 100644 drivers/media/radio/si4713/Kconfig
 create mode 100644 drivers/media/radio/si4713/Makefile
 rename drivers/media/radio/{radio-si4713.c => si4713/radio-platform-si4713.c} (100%)
 create mode 100644 drivers/media/radio/si4713/radio-usb-si4713.c
 rename drivers/media/radio/{si4713-i2c.c => si4713/si4713.c} (86%)
 rename drivers/media/radio/{si4713-i2c.h => si4713/si4713.h} (98%)
 create mode 100644 drivers/media/rc/keymaps/rc-su3000.c
 create mode 100644 drivers/media/tuners/m88ts2022.c
 create mode 100644 drivers/media/tuners/m88ts2022.h
 create mode 100644 drivers/media/tuners/m88ts2022_priv.h
 create mode 100644 drivers/media/usb/em28xx/em28xx-v4l.h
 create mode 100644 drivers/staging/media/bcm2048/Kconfig
 create mode 100644 drivers/staging/media/bcm2048/Makefile
 create mode 100644 drivers/staging/media/bcm2048/TODO
 create mode 100644 drivers/staging/media/bcm2048/radio-bcm2048.c
 create mode 100644 drivers/staging/media/bcm2048/radio-bcm2048.h
 create mode 100644 drivers/staging/media/omap24xx/Kconfig
 create mode 100644 drivers/staging/media/omap24xx/Makefile
 rename drivers/{media/platform => staging/media/omap24xx}/omap24xxcam-dma.c (100%)
 rename drivers/{media/platform => staging/media/omap24xx}/omap24xxcam.c (100%)
 rename drivers/{media/platform => staging/media/omap24xx}/omap24xxcam.h (99%)
 rename drivers/{media/i2c => staging/media/omap24xx}/tcm825x.c (99%)
 rename drivers/{media/i2c => staging/media/omap24xx}/tcm825x.h (99%)
 rename drivers/{media/v4l2-core => staging/media/omap24xx}/v4l2-int-device.c (99%)
 rename {include/media => drivers/staging/media/omap24xx}/v4l2-int-device.h (100%)
 create mode 100644 drivers/staging/media/omap4iss/Kconfig
 create mode 100644 drivers/staging/media/omap4iss/Makefile
 create mode 100644 drivers/staging/media/omap4iss/TODO
 create mode 100644 drivers/staging/media/omap4iss/iss.c
 create mode 100644 drivers/staging/media/omap4iss/iss.h
 create mode 100644 drivers/staging/media/omap4iss/iss_csi2.c
 create mode 100644 drivers/staging/media/omap4iss/iss_csi2.h
 create mode 100644 drivers/staging/media/omap4iss/iss_csiphy.c
 create mode 100644 drivers/staging/media/omap4iss/iss_csiphy.h
 create mode 100644 drivers/staging/media/omap4iss/iss_ipipe.c
 create mode 100644 drivers/staging/media/omap4iss/iss_ipipe.h
 create mode 100644 drivers/staging/media/omap4iss/iss_ipipeif.c
 create mode 100644 drivers/staging/media/omap4iss/iss_ipipeif.h
 create mode 100644 drivers/staging/media/omap4iss/iss_regs.h
 create mode 100644 drivers/staging/media/omap4iss/iss_resizer.c
 create mode 100644 drivers/staging/media/omap4iss/iss_resizer.h
 create mode 100644 drivers/staging/media/omap4iss/iss_video.c
 create mode 100644 drivers/staging/media/omap4iss/iss_video.h
 rename drivers/{media/usb => staging/media}/sn9c102/Kconfig (52%)
 rename drivers/{media/usb => staging/media}/sn9c102/Makefile (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102.h (100%)
 rename {Documentation/video4linux => drivers/staging/media/sn9c102}/sn9c102.txt (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_config.h (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_core.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_devtable.h (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_hv7131d.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_hv7131r.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_mi0343.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_mi0360.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_mt9v111.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_ov7630.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_ov7660.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_pas106b.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_pas202bcb.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_sensor.h (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5110c1b.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5110d.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5130d1b.c (100%)
 create mode 100644 include/media/omap4iss.h
 delete mode 100644 include/media/saa6752hs.h
 create mode 100644 include/trace/events/v4l2.h
 create mode 100644 include/uapi/linux/vsp1.h

