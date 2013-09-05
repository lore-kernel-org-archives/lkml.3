Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3IEOYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:24:52 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:55772 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3IEOYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:24:49 -0400
X-AuditID: cbfec372-b7fe76d000003347-37-5228942f9f4e
Date: Thu, 05 Sep 2013 11:24:41 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.12-rc1] media updates
Message-id: <20130905112441.0a8c81d2@samsung.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e9woK7+FI0gg933DS3mrF/DZnF51xw2
	i54NW1ktHvW9ZXdg8Tgx4zeLx+dNcgFMUVw2Kak5mWWpRfp2CVwZbTsesBRsnsBUsXHbddYG
	xs/HGLsYOTkkBEwk1jbNZoOwxSQu3FsPZHNxCAksYZRYO3UxK4TTwySxrrmBHaSKRUBVYvPB
	c2DdbAJGEq8aW1hBbBEg+/OLK2ANzAKLGSU+Pl8P1iAsoC+xctNVsAZeAUOJP0d3MHcxcgCt
	c5LYOtUXIiwo8WPyPRYQm1lAXWLSvEXMELa2xJN3F1gnMPLNQlI2C0nZLCRlCxiZVzGKlhYn
	FxQnpeca6hUn5haX5qXrJefnbmKEhF/RDsZnG6wOMQpwMCrx8HL0aAQJsSaWFVfmHmKU4GBW
	EuHdMQkoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgVF06qrN/xdsTXLctbc99JWwx99SuVbFy69E
	PglyX3+Qd/jg44tezFPzZqUJJhjLrHdyDZxkPGnC9xsh2Vs28mw41trKw1x65EYq56dMe/lH
	bLK3yp/5bBaurL8Xzm/22ekTi8hjKw61FaH/5mw+fG3ThYimufszco7zfW7+5sg0z2JLnv6B
	pzeVWIozEg21mIuKEwHuJ8oUHQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

This series contain:
	- Exynos s5p-mfc driver got support for VP8 encoder;
	- Some SoC drivers gained support for asynchronous registration
	  (needed for DT);
	- The RC subsystem gained support for RC activity LED;
	- New drivers added: a video decoder(adv7842), a video encoder (adv7511),
	  a new GSPCA driver (stk1135) and support for Renesas R-Car (vsp1). 
	- the first SDR kernel driver: mirics msi3101. Due to some troubles with
	  the driver, and because the API is still under discussion, it will be
	  merged at staging for 3.12. Need to rework on it;
	- usual new boards additions, fixes, cleanups and driver improvements.

Thanks!
Mauro

PS.: Some trivial conflicts are expected when merging with ARM tree 
(mach-shmobile), due to a few patches on this series with DT data for 
Reneseas R-Car. 

Also, a trivial conflict at s5p_mfc_dec.c and s5p_mfc_enc.c will happen as
a macro name got renamed from IS_MFCV6 to IS_MFCV6_PLUS.

Both are easy to solve. Also, all of them are solved at the linux-next tree.

-

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to f66b2a1c7f2ae3fb0d5b67d07ab4f5055fd3cf16:

  [media] cx88: Fix regression: CX88_AUDIO_WM8775 can't be 0 (2013-09-03 09:24:22 -0300)

----------------------------------------------------------------
Alban Browaeys (2):
      [media] em28xx: Fix vidioc fmt vid cap v4l2 compliance
      [media] em28xx: fix assignment of the eeprom data

Alexander Shiyan (1):
      [media] media: coda: Fix DT driver data pointer for i.MX27

Alexey Khoroshilov (4):
      [media] tlg2300: implement error handling in poseidon_probe()
      [media] tlg2300: fix checking firmware in poseidon_probe()
      [media] gspca: fix dev_open() error path
      [media] hdpvr: fix iteration over uninitialized lists in hdpvr_probe()

Andrzej Hajda (4):
      [media] V4L: s5c73m3: Add format propagation for TRY formats
      [media] exynos4-is: Ensure the FIMC gate clock is disabled at driver remove()
      [media] DocBook: upgrade media_api DocBook version to 4.2
      [media] v4l2: added missing mutex.h include to v4l2-ctrls.h

Andy Shevchenko (1):
      [media] smiapp: re-use clamp_t instead of min(..., max(...))

Antonio Ospite (1):
      [media] gspca-ov534: don't call sd_start() from sd_init()

Antti Palosaari (26):
      [media] dvb-usb-v2: fix Kconfig dependency when RC_CORE=m
      [media] e4000: implement DC offset correction
      [media] e4000: use swap() macro
      [media] e4000: make checkpatch.pl happy
      [media] e4000: change remaining pr_warn to dev_warn
      [media] lme2510: do not use bInterfaceNumber from dvb_usb_v2
      [media] dvb_usb_v2: get rid of deferred probe
      [media] Mirics MSi3101 SDR Dongle driver
      [media] msi3101: sample is correct term for sample
      [media] msi3101: fix sampling rate calculation
      [media] msi3101: add sampling mode control
      [media] msi3101: enhance sampling results
      [media] msi3101: fix stream re-start halt
      [media] msi3101: add 2040:d300 Hauppauge WinTV 133559 LF
      [media] msi3101: add debug dump for unknown stream data
      [media] msi3101: correct ADC sampling rate calc a little bit
      [media] msi3101: improve tuner synth calc step size
      [media] msi3101: add support for stream format "252" I+Q per frame
      [media] msi3101: init bits 23:20 on PLL register
      [media] msi3101: fix overflow in freq setting
      [media] msi3101: add stream format 336 I+Q pairs per frame
      [media] msi3101: changes for tuner PLL freq limits
      [media] msi3101: a lot of small cleanups
      [media] msi3101: implement stream format 504
      [media] msi3101: change stream format 384
      [media] msi3101: few improvements for RF tuner

Arun Kumar K (9):
      [media] s5p-mfc: Update v6 encoder buffer sizes
      [media] s5p-mfc: Rename IS_MFCV6 macro
      [media] s5p-mfc: Add register definition file for MFC v7
      [media] s5p-mfc: Core support for MFC v7
      [media] s5p-mfc: Update driver for v7 firmware
      [media] V4L: Add VP8 encoder controls
      [media] s5p-mfc: Add support for VP8 encoder
      [media] exynos4-is: Fix fimc-lite bayer formats
      [media] exynos-gsc: Register v4l2 device

Bjørn Mork (1):
      [media] siano: fix divide error on 0 counters

Dan Carpenter (5):
      [media] staging: lirc: clean error handling in probe()
      [media] exynos4-is: Print error message on timeout
      [media] s3c-camif: forever loop in camif_hw_set_source_format()
      [media] s5k6aa: off by one in s5k6aa_enum_frame_interval()
      [media] ov9650: off by one in ov965x_enum_frame_sizes()

Dean Anderson (1):
      [media] S2255: Removal of unnecessary videobuf_queue_is_busy

Ezequiel Garcia (2):
      [media] stk1160: Allow to change input while streaming
      [media] media: stk1160: Ignore unchanged standard set

Fabio Estevam (3):
      [media] coda: Fix error paths
      [media] coda: Check the return value from clk_prepare_enable()
      [media] coda: No need to check the return value of platform_get_resource()

Geert Uytterhoeven (1):
      [media] media/v4l2: VIDEO_SH_VEU should depend on HAS_DMA

Guennadi Liakhovetski (6):
      [media] V4L2: soc-camera: fix requesting regulators in synchronous case
      [media] V4L2: mx3_camera: convert to managed resource allocation
      [media] V4L2: mx3_camera: print V4L2_MBUS_FMT_* codes in hexadecimal format
      [media] V4L2: mx3_camera: add support for asynchronous subdevice registration
      [media] V4L2: mt9t031: don't Oops if asynchronous probing is attempted
      [media] V4L2: mt9m111: switch to asynchronous subdevice probing

Hans Verkuil (24):
      [media] v4l2-dv-timings.h: remove duplicate V4L2_DV_BT_DMT_1366X768P60
      [media] v4l2-dv-timings: add new helper module
      [media] v4l2: move dv-timings related code to v4l2-dv-timings.c
      [media] DocBook/media/v4l: il_* fields always 0 for progressive formats
      [media] videodev2.h: defines to calculate blanking and frame sizes
      [media] v4l2: use new V4L2_DV_BT_BLANKING/FRAME defines
      [media] v4l2: use new V4L2_DV_BT_BLANKING/FRAME defines
      [media] ths8200/ad9389b: use new dv_timings helpers
      [media] soc_camera: fix compiler warning
      [media] v4l2-dv-timings: add v4l2_print_dv_timings helper
      [media] ad9389b/adv7604/ths8200: use new v4l2_print_dv_timings helper
      [media] v4l2-dv-timings: rename v4l_match_dv_timings to v4l2_match_dv_timings
      [media] adv7604/ad9389b/ths8200: decrease min_pixelclock to 25MHz
      [media] v4l2-dv-timings: fill in type field
      [media] v4l2-dv-timings: export the timings list
      [media] v4l2-dv-timings: rename v4l2_dv_valid_timings to v4l2_valid_dv_timings
      [media] v4l2-dv-timings: add callback to handle exceptions
      [media] adv7604: set is_private only after successfully creating all controls
      [media] ad9389b: set is_private only after successfully creating all controls
      [media] adv7842: add new video decoder driver
      [media] adv7511: add new video encoder
      [media] MAINTAINERS: add entries for adv7511 and adv7842
      [media] ml86v7667: fix compile warning: 'ret' set but not used
      [media] cx88: Fix regression: CX88_AUDIO_WM8775 can't be 0

Hans de Goede (2):
      [media] radio-si470x-usb: Remove software version check
      [media] gspca_ov519: Fix support for the Terratec Terracam USB Pro

Johannes Erdfelt (1):
      [media] cx231xx: Add support for KWorld UB445-U

Johannes Koch (1):
      [media] cx23885: Fix TeVii S471 regression since introduction of ts2020

John Sheu (1):
      [media] s5p-mfc: Fix input/output format reporting

Jon Arne Jørgensen (3):
      [media] saa7115: Fix saa711x_set_v4lstd for gm7113c
      [media] saa7115: Do not load saa7115_init_misc for gm7113c
      [media] saa7115: Implement i2c_board_info.platform_data

Juergen Lock (1):
      [media] media: rc: rdev->open or rdev->close can be NULL

Julia Lawall (1):
      [media] marvell-ccic/mmp-driver.c: simplify use of devm_ioremap_resource

Katsuya Matsubara (2):
      [media] vsp1: Fix lack of the sink entity registration for enabled links
      [media] vsp1: Use the maximum number of entities defined in platform data

Lad, Prabhakar (15):
      [media] media: i2c: ths8200: support asynchronous probing
      [media] media: i2c: ths8200: add OF support
      [media] media: i2c: adv7343: add support for asynchronous probing
      [media] media: i2c: tvp7002: add support for asynchronous probing
      [media] media: i2c: tvp514x: add support for asynchronous probing
      [media] media: davinci: vpif: capture: add V4L2-async support
      [media] media: davinci: vpif: display: add V4L2-async support
      [media] media: davinci: vpbe_venc: convert to devm_* api
      [media] media: davinci: vpbe_osd: convert to devm_* api
      [media] media: davinci: vpbe_display: convert to devm* api
      [media] media: davinci: vpss: convert to devm* api
      [media] media: i2c: adv7343: make the platform data members as array
      [media] media: i2c: adv7343: add OF support
      [media] media: OF: add "sync-on-green-active" property
      [media] media: i2c: tvp7002: add OF support

Laurent Pinchart (20):
      [media] media: Add support for circular graph traversal
      [media] Documentation: media: Clarify the VIDIOC_CREATE_BUFS format requirements
      [media] media: vb2: Clarify queue_setup() and buf_prepare() usage documentation
      [media] media: vb2: Take queue or device lock in mmap-related vb2 ioctl handlers
      [media] v4l: Fix V4L2_MBUS_FMT_YUV10_1X30 media bus pixel code value
      [media] v4l: Add media format codes for ARGB8888 and AYUV8888 on 32-bit busses
      [media] v4l: Add V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV61M formats
      [media] v4l: Renesas R-Car VSP1 driver
      [media] videobuf2-core: Verify planes lengths for output buffers
      [media] v4l: of: Use of_get_child_by_name()
      [media] v4l: of: Drop acquired reference to node when getting next endpoint
      [media] v4l: Fix colorspace conversion error in sample code
      [media] v4l: async: Make it safe to unregister unregistered notifier
      [media] mt9v032: Use the common clock framework
      [media] media: vb2: Fix potential deadlock in vb2_prepare_buffer
      [media] media: vb2: Share code between vb2_prepare_buf and vb2_qbuf
      [media] MAINTAINERS: Add entry for the Aptina PLL library
      [media] v4l: vsp1: Initialize media device bus_info field
      [media] v4l: vsp1: Add support for RT clock
      [media] v4l: vsp1: Fix mutex double lock at streamon time

Libin Yang (7):
      [media] marvell-ccic: add MIPI support for marvell-ccic driver
      [media] marvell-ccic: add clock tree support for marvell-ccic driver
      [media] marvell-ccic: reset ccic phy when stop streaming for stability
      [media] marvell-ccic: refine mcam_set_contig_buffer function
      [media] marvell-ccic: add new formats support for marvell-ccic driver
      [media] marvell-ccic: add SOF / EOF pair check for marvell-ccic driver
      [media] marvell-ccic: switch to resource managed allocation and request

Libo Chen (1):
      [media] drivers/media/radio/radio-maxiradio: Convert to module_pci_driver

Lubomir Rintel (3):
      [media] usbtv: Add S-Video input support
      [media] usbtv: Fix deinterlacing
      [media] usbtv: Throw corrupted frames away

Luis Alves (2):
      [media] cx23885[v4]: Fix interrupt storm when enabling IR receiver
      [media] Fixed misleading error when handling IR interrupts

Martin Bugge (4):
      [media] v4l2-dv-timings: fix CVT calculation
      [media] adv7604: pixel-clock depends on deep-color-mode
      [media] ad9389b: trigger edid re-read by power-cycle chip
      [media] adv7604: corrected edid crc-calculation

Mats Randgaard (5):
      [media] adv7604: debounce "format change" notifications
      [media] adv7604: improve log_status for HDMI/DVI-D signals
      [media] adv7604: print flags and standards in timing information
      [media] ad9389b: no monitor if EDID is wrong
      [media] ad9389b: change initial register configuration in ad9389b_setup()

Mauro Carvalho Chehab (15):
      Merge tag 'v3.11-rc2' into patchwork
      [media] cx23885-video: fix two warnings
      [media] stk1160: Build as a module if SND is m and audio support is selected
      [media] saa7115: make multi-line comments compliant with CodingStyle
      sh_mobile_ceu_camera: Fix a compilation warning
      v4l2-common: warning fix (W=1): add a missed function prototype
      [media] cx23885-dvb: use a better approach to hook set_frontend
      [media] mb86a20s: Fix TS parallel mode
      [media] cx23885: Add DTV support for Mygica X8502/X8507 boards
      [media] Fix build errors on usbtv when driver is builtin
      [media] sms: fix randconfig building error
      [media] cx88: fix build when VP3054=m and CX88_DVB=y
      [media] sound/pci/Kconfig: select RADIO_ADAPTERS if needed
      [media] vsp1: Fix a sparse warning
      [media] msi3101: Fix compilation on i386

Maxim Levitsky (3):
      [media] ene_ir: Fix interrupt line passthrough to hardware
      [media] ene_ir: disable the device if wake is disabled
      [media] ene_ir: don't use pr_debug after all

Michael Krufky (1):
      [media] dib0700: add support for PCTV 2002e & PCTV 2002e SE

Ondrej Zary (7):
      [media] tea575x-tuner: move HW init to a separate function
      [media] bttv: stop abusing mbox_we for sw_status
      [media] radio-aztech: Convert to generic lm7000 implementation
      [media] radio-aztech: Implement signal strength detection and fix stereo detection
      [media] tea575x: Move header from sound to media
      [media] tea575x: Move from sound to media
      [media] introduce gspca-stk1135: Syntek STK1135 driver

Philipp Zabel (9):
      [media] mem2mem: add support for hardware buffered queue
      [media] coda: use vb2_set_plane_payload instead of setting v4l2_planes[0].bytesused directly
      [media] coda: dynamic IRAM setup for encoder
      [media] coda: do not allocate maximum number of framebuffers for encoder
      [media] coda: update CODA7541 to firmware 1.4.50
      [media] coda: add bitstream ringbuffer handling for decoder
      [media] coda: dynamic IRAM setup for decoder
      [media] coda: split encoder specific parts out of device_run and irq_handler
      [media] coda: add CODA7541 decoding support

Prathyush K (1):
      [media] exynos-gsc: fix s2r functionality

Ricardo Ribalda (1):
      [media] v4l2-dev: Fix race condition on __video_register_device

Sachin Kamat (4):
      [media] exynos4-is: Fix potential NULL pointer dereference
      [media] exynos4-is: Staticize local symbol
      [media] exynos4-is: Annotate unused functions
      [media] s5p-g2d: Fix registration failure

Sakari Ailus (3):
      [media] smiapp-pll: Add a few comments to PLL calculation
      [media] smiapp: Prepare and unprepare clocks correctly
      [media] smiapp: Call the clock "ext_clk"

Sean Young (9):
      [media] redrat3: errors on unplug
      [media] rc: allowed_protos now is a bit field
      [media] lirc: validate transmission ir data
      [media] lirc: make transmit interface consistent
      [media] redrat3: ensure whole packet is read
      [media] rc: add feedback led trigger for rc keypresses
      [media] redrat3: wire up rc feedback led
      [media] ttusbir: wire up rc feedback led
      [media] winbond: wire up rc feedback led

Shaik Ameer Basha (1):
      [media] v4l2-mem2mem: clear m2m context from job_queue before ctx streamoff

Srinivas Kandagatla (2):
      [media] media: rc: Add rc_open/close and use count to rc_dev
      [media] media: lirc: Allow lirc dev to talk to rc device

Sylwester Nawrocki (15):
      [media] V4L: Drop bus_type check in v4l2-async match functions
      [media] V4L: Rename v4l2_async_bus_* to v4l2_async_match_*
      [media] V4L: Add V4L2_ASYNC_MATCH_OF subdev matching type
      [media] V4L: Rename subdev field of struct v4l2_async_notifier
      [media] V4L: Merge struct v4l2_async_subdev_list with struct v4l2_subdev
      [media] DocBook: Fix typo in V4L2_CID_JPEG_COMPRESSION_QUALITY reference
      [media] V4L: Add support for integer menu controls with standard menu items
      [media] v4l2-async: Use proper list head for iteration over registered subdevs
      [media] v4l2-ctrl: Suppress build warning from v4l2_ctrl_new_std_menu()
      [media] exynos4-is: Initialize the ISP subdev sd->owner field
      [media] exynos4-is: Add missing MODULE_LICENSE for exynos-fimc-is.ko
      [media] exynos4-is: Add missing v4l2_device_unregister() call in fimc_md_remove()
      [media] exynos4-is: Simplify sclk_cam clocks handling
      [media] s5p-tv: Include missing v4l2-dv-timings.h header file
      [media] exynos4-is: Fix entity unregistration on error path

Tomasz Figa (1):
      [media] exynos4-is: Handle suspend/resume of fimc-is-i2c correctly

Vladimir Barinov (8):
      [media] ml86v7667: override default field interlace order
      [media] V4L2: soc_camera: Renesas R-Car VIN driver
      [media] ARM: shmobile: r8a7778: add VIN support
      [media] ARM: shmobile: BOCK-W: add VIN and ML86V7667 support
      [media] ARM: shmobile: BOCK-W: enable VIN and ML86V7667 in defconfig
      [media] ARM: shmobile: r8a7779: add VIN support
      [media] ARM: shmobile: Marzen: add VIN and ADV7180 support
      [media] ARM: shmobile: Marzen: enable VIN and ADV7180 in defconfig

Wei Yongjun (3):
      [media] usbtv: remove unused including <linux/version.h>
      [media] davinci: vpif_display: fix error return code in vpif_probe()
      [media] davinci: vpif_capture: fix error return code in vpif_probe()

 Documentation/DocBook/media/v4l/controls.xml       |  168 +-
 .../DocBook/media/v4l/lirc_device_interface.xml    |    4 +-
 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml   |  171 ++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    7 +-
 Documentation/DocBook/media/v4l/subdev-formats.xml |  611 ++--
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |   41 +-
 .../DocBook/media/v4l/vidioc-g-dv-timings.xml      |    6 +-
 .../DocBook/media/v4l/vidioc-g-jpegcomp.xml        |    4 +-
 Documentation/DocBook/media_api.tmpl               |   10 +-
 .../devicetree/bindings/media/i2c/adv7343.txt      |   48 +
 .../devicetree/bindings/media/i2c/ths8200.txt      |   19 +
 .../devicetree/bindings/media/i2c/tvp7002.txt      |   53 +
 .../devicetree/bindings/media/s5p-mfc.txt          |    1 +
 .../devicetree/bindings/media/video-interfaces.txt |    2 +
 Documentation/video4linux/v4l2-controls.txt        |   21 +-
 MAINTAINERS                                        |   26 +-
 arch/arm/configs/bockw_defconfig                   |    7 +
 arch/arm/configs/marzen_defconfig                  |    7 +
 arch/arm/mach-davinci/board-da850-evm.c            |    6 +-
 arch/arm/mach-shmobile/board-bockw.c               |   41 +
 arch/arm/mach-shmobile/board-marzen.c              |   44 +-
 arch/arm/mach-shmobile/clock-r8a7778.c             |    5 +
 arch/arm/mach-shmobile/clock-r8a7779.c             |   10 +
 arch/arm/mach-shmobile/include/mach/r8a7778.h      |    3 +
 arch/arm/mach-shmobile/include/mach/r8a7779.h      |    3 +
 arch/arm/mach-shmobile/setup-r8a7778.c             |   34 +
 arch/arm/mach-shmobile/setup-r8a7779.c             |   37 +
 drivers/media/common/siano/Kconfig                 |    2 +
 drivers/media/common/siano/smsdvb-main.c           |    3 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |    2 +
 drivers/media/dvb-frontends/mb86a20s.c             |   16 +-
 drivers/media/i2c/Kconfig                          |   23 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/ad9389b.c                        |  163 +-
 drivers/media/i2c/adv7343.c                        |   89 +-
 drivers/media/i2c/adv7511.c                        | 1198 ++++++++
 drivers/media/i2c/adv7604.c                        |  156 +-
 drivers/media/i2c/adv7842.c                        | 2946 ++++++++++++++++++++
 drivers/media/i2c/ml86v7667.c                      |    7 +-
 drivers/media/i2c/mt9v032.c                        |   17 +-
 drivers/media/i2c/ov9650.c                         |    2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |    5 +
 drivers/media/i2c/s5k6aa.c                         |    2 +-
 drivers/media/i2c/saa7115.c                        |  169 +-
 drivers/media/i2c/saa711x_regs.h                   |   19 +
 drivers/media/i2c/smiapp-pll.c                     |   17 +
 drivers/media/i2c/smiapp/smiapp-core.c             |   31 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |   38 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |    7 +-
 drivers/media/i2c/ths7303.c                        |    6 +-
 drivers/media/i2c/ths8200.c                        |  123 +-
 drivers/media/i2c/tvp514x.c                        |   20 +-
 drivers/media/i2c/tvp7002.c                        |   73 +-
 drivers/media/media-entity.c                       |   14 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |   26 +-
 drivers/media/pci/bt8xx/bttvp.h                    |    3 +
 drivers/media/pci/cx23885/Kconfig                  |    1 +
 drivers/media/pci/cx23885/cx23885-av.c             |   13 +
 drivers/media/pci/cx23885/cx23885-cards.c          |    6 +-
 drivers/media/pci/cx23885/cx23885-core.c           |    5 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   53 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    5 +-
 drivers/media/pci/cx23885/cx23885-video.h          |   26 +
 drivers/media/pci/cx23885/cx23885.h                |    2 +
 drivers/media/pci/cx88/Kconfig                     |   11 +-
 drivers/media/pci/cx88/cx88.h                      |    2 +-
 drivers/media/platform/Kconfig                     |   12 +-
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/blackfin/bfin_capture.c     |    9 +-
 drivers/media/platform/coda.c                      | 1508 ++++++++--
 drivers/media/platform/coda.h                      |  107 +-
 drivers/media/platform/davinci/vpbe_display.c      |   23 +-
 drivers/media/platform/davinci/vpbe_osd.c          |   45 +-
 drivers/media/platform/davinci/vpbe_venc.c         |   97 +-
 drivers/media/platform/davinci/vpif_capture.c      |  162 +-
 drivers/media/platform/davinci/vpif_capture.h      |    2 +
 drivers/media/platform/davinci/vpif_display.c      |  221 +-
 drivers/media/platform/davinci/vpif_display.h      |    3 +-
 drivers/media/platform/davinci/vpss.c              |   62 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |   22 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    1 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    1 +
 drivers/media/platform/exynos4-is/fimc-core.c      |    2 +
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |   33 +-
 drivers/media/platform/exynos4-is/fimc-is-param.c  |    4 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |    4 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |    1 +
 drivers/media/platform/exynos4-is/fimc-isp.c       |    2 +
 drivers/media/platform/exynos4-is/fimc-lite.c      |   17 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   17 +-
 drivers/media/platform/marvell-ccic/cafe-driver.c  |    4 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |  325 ++-
 drivers/media/platform/marvell-ccic/mcam-core.h    |   50 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c   |  278 +-
 drivers/media/platform/s3c-camif/camif-regs.c      |    8 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    1 +
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h       |    4 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h       |   61 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   32 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |    3 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   23 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   90 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  150 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  149 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |    3 +-
 drivers/media/platform/soc_camera/Kconfig          |    8 +
 drivers/media/platform/soc_camera/Makefile         |    1 +
 drivers/media/platform/soc_camera/mx3_camera.c     |   67 +-
 drivers/media/platform/soc_camera/rcar_vin.c       | 1486 ++++++++++
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    9 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   40 +-
 drivers/media/platform/vsp1/Makefile               |    5 +
 drivers/media/platform/vsp1/vsp1.h                 |   74 +
 drivers/media/platform/vsp1/vsp1_drv.c             |  527 ++++
 drivers/media/platform/vsp1/vsp1_entity.c          |  181 ++
 drivers/media/platform/vsp1/vsp1_entity.h          |   68 +
 drivers/media/platform/vsp1/vsp1_lif.c             |  238 ++
 drivers/media/platform/vsp1/vsp1_lif.h             |   37 +
 drivers/media/platform/vsp1/vsp1_regs.h            |  581 ++++
 drivers/media/platform/vsp1/vsp1_rpf.c             |  209 ++
 drivers/media/platform/vsp1/vsp1_rwpf.c            |  124 +
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   53 +
 drivers/media/platform/vsp1/vsp1_uds.c             |  346 +++
 drivers/media/platform/vsp1/vsp1_uds.h             |   40 +
 drivers/media/platform/vsp1/vsp1_video.c           | 1069 +++++++
 drivers/media/platform/vsp1/vsp1_video.h           |  144 +
 drivers/media/platform/vsp1/vsp1_wpf.c             |  233 ++
 drivers/media/radio/Kconfig                        |   12 +-
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-aztech.c                 |   81 +-
 drivers/media/radio/radio-maxiradio.c              |   15 +-
 drivers/media/radio/radio-sf16fmr2.c               |    2 +-
 drivers/media/radio/radio-shark.c                  |    2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |   11 -
 .../media/radio/tea575x.c                          |   21 +-
 drivers/media/rc/Kconfig                           |    3 +-
 drivers/media/rc/ene_ir.c                          |   30 +-
 drivers/media/rc/ene_ir.h                          |    2 +-
 drivers/media/rc/iguanair.c                        |    4 +-
 drivers/media/rc/ir-lirc-codec.c                   |   12 +-
 drivers/media/rc/lirc_dev.c                        |   10 +
 drivers/media/rc/rc-main.c                         |   52 +-
 drivers/media/rc/redrat3.c                         |  120 +-
 drivers/media/rc/ttusbir.c                         |    1 +
 drivers/media/rc/winbond-cir.c                     |   38 +-
 drivers/media/tuners/e4000.c                       |   82 +-
 drivers/media/tuners/e4000.h                       |    2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   40 +
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |    1 +
 drivers/media/usb/cx231xx/cx231xx.h                |    1 +
 drivers/media/usb/dvb-usb-v2/Kconfig               |    2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |    5 -
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |  134 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |    2 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |   12 +-
 drivers/media/usb/dvb-usb/m920x.c                  |    2 +-
 drivers/media/usb/em28xx/em28xx-i2c.c              |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    1 +
 drivers/media/usb/gspca/Kconfig                    |    9 +
 drivers/media/usb/gspca/Makefile                   |    2 +
 drivers/media/usb/gspca/gspca.c                    |    6 +-
 drivers/media/usb/gspca/ov519.c                    |   32 +-
 drivers/media/usb/gspca/ov534.c                    |    3 +-
 drivers/media/usb/gspca/stk1135.c                  |  685 +++++
 drivers/media/usb/gspca/stk1135.h                  |   57 +
 drivers/media/usb/hdpvr/hdpvr-core.c               |   11 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |    9 +-
 drivers/media/usb/s2255/s2255drv.c                 |    9 +-
 drivers/media/usb/stk1160/Kconfig                  |   16 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    6 +-
 drivers/media/usb/tlg2300/pd-main.c                |   37 +-
 drivers/media/usb/usbtv/Kconfig                    |    2 +-
 drivers/media/usb/usbtv/usbtv.c                    |  151 +-
 drivers/media/v4l2-core/Makefile                   |    1 +
 drivers/media/v4l2-core/v4l2-async.c               |  112 +-
 drivers/media/v4l2-core/v4l2-common.c              |  357 ---
 drivers/media/v4l2-core/v4l2-ctrls.c               |   67 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |    5 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  609 ++++
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   69 +-
 drivers/media/v4l2-core/v4l2-of.c                  |   13 +-
 drivers/media/v4l2-core/videobuf2-core.c           |  269 +-
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/lirc/lirc_igorplugusb.c      |   56 +-
 drivers/staging/media/msi3101/Kconfig              |    3 +
 drivers/staging/media/msi3101/Makefile             |    1 +
 drivers/staging/media/msi3101/sdr-msi3101.c        | 1931 +++++++++++++
 include/linux/platform_data/camera-mx3.h           |    4 +
 include/linux/platform_data/camera-rcar.h          |   25 +
 include/linux/platform_data/vsp1.h                 |   25 +
 include/media/adv7343.h                            |   20 +-
 include/media/adv7511.h                            |   48 +
 include/media/adv7842.h                            |  226 ++
 include/media/davinci/vpif_types.h                 |    4 +
 include/media/lirc_dev.h                           |    1 +
 include/media/media-entity.h                       |    4 +
 include/media/mt9v032.h                            |    4 -
 include/media/rc-core.h                            |    4 +
 include/media/saa7115.h                            |   77 +-
 include/media/smiapp.h                             |    1 -
 include/{sound/tea575x-tuner.h => media/tea575x.h} |    1 +
 include/media/v4l2-async.h                         |   36 +-
 include/media/v4l2-common.h                        |   14 +-
 include/media/v4l2-ctrls.h                         |    1 +
 include/media/v4l2-dv-timings.h                    |  161 ++
 include/media/v4l2-mediabus.h                      |    3 +
 include/media/v4l2-mem2mem.h                       |   13 +
 include/media/v4l2-subdev.h                        |   13 +-
 include/media/videobuf2-core.h                     |   11 +-
 include/uapi/linux/v4l2-controls.h                 |   29 +
 include/uapi/linux/v4l2-dv-timings.h               |    8 -
 include/uapi/linux/v4l2-mediabus.h                 |    6 +-
 include/uapi/linux/videodev2.h                     |   12 +
 sound/i2c/other/Makefile                           |    2 -
 sound/pci/Kconfig                                  |   12 +-
 sound/pci/es1968.c                                 |    2 +-
 sound/pci/fm801.c                                  |    2 +-
 221 files changed, 19059 insertions(+), 2730 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7343.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ths8200.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt
 create mode 100644 drivers/media/i2c/adv7511.c
 create mode 100644 drivers/media/i2c/adv7842.c
 create mode 100644 drivers/media/pci/cx23885/cx23885-video.h
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v7.h
 create mode 100644 drivers/media/platform/soc_camera/rcar_vin.c
 create mode 100644 drivers/media/platform/vsp1/Makefile
 create mode 100644 drivers/media/platform/vsp1/vsp1.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_drv.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_entity.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_entity.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_lif.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_lif.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_regs.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_rpf.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_uds.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_uds.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_video.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_video.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_wpf.c
 rename sound/i2c/other/tea575x-tuner.c => drivers/media/radio/tea575x.c (98%)
 create mode 100644 drivers/media/usb/gspca/stk1135.c
 create mode 100644 drivers/media/usb/gspca/stk1135.h
 create mode 100644 drivers/media/v4l2-core/v4l2-dv-timings.c
 create mode 100644 drivers/staging/media/msi3101/Kconfig
 create mode 100644 drivers/staging/media/msi3101/Makefile
 create mode 100644 drivers/staging/media/msi3101/sdr-msi3101.c
 create mode 100644 include/linux/platform_data/camera-rcar.h
 create mode 100644 include/linux/platform_data/vsp1.h
 create mode 100644 include/media/adv7511.h
 create mode 100644 include/media/adv7842.h
 rename include/{sound/tea575x-tuner.h => media/tea575x.h} (98%)
 create mode 100644 include/media/v4l2-dv-timings.h

-- 

Cheers,
Mauro
