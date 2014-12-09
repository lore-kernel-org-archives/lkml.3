Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbaLIQJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:09:49 -0500
Received: from lists.s-osg.org ([54.187.51.154]:50273 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242AbaLIQJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:09:46 -0500
Date: Tue, 9 Dec 2014 14:09:40 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.19-rc1] media updates
Message-ID: <20141209140940.685b9bd6@recife.lan>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.19-rc1


For:
  - Two new dvb frontend drivers: mn88472 and mn88473;
  - A new driver for some PCIe DVBSky cards;
  - A new remote controller driver: meson-ir;
  - One LIRC staging driver got rewritten and promoted to mainstream:
    igorplugusb;
  - A new tuner driver (m88rs6000t);
  - The old omap2 media driver got removed from staging. This driver uses
    an old DMA API and it is likely broken on recent kernels. Nobody cared
    enough to fix it;
  - Media bus format moved to a separate header, as DRM will also use the
    definitions there;
  - mem2mem_testdev were renamed to vim2m, in order to use the same naming
    convention taken by the other virtual test driver (vivid);
  - Added a new driver for coda SoC (coda-jpeg);
  - The cx88 driver got converted to use videobuf2 core;
  - Make DMABUF export buffer to work with DMA Scatter/Gather and Vmalloc
    cores;
  - Lots of other fixes, improvements and cleanups on the drivers.

Thanks!
Mauro

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.19-rc1

for you to fetch changes up to 71947828caef0c83d4245f7d1eaddc799b4ff1d1:

  [media] mn88473: One function call less in mn88473_init() after error (2014-12-04 16:00:47 -0200)

----------------------------------------------------------------
media updates for v3.19-rc1

----------------------------------------------------------------
Amber Thrall (1):
      [media] Staging: media: lirc: cleaned up packet dump in 2 files

Andreas Ruprecht (1):
      [media] media: pci: smipcie: Fix dependency for DVB_SMIPCIE

Andrey Utkin (4):
      [media] solo6x10: clean up properly in stop_streaming
      [media] solo6x10: free DMA allocation when releasing encoder
      [media] solo6x10: bind start & stop of encoded frames processing thread to device (de)init
      [media] solo6x10: don't turn off/on encoder interrupt in processing loop

Antti Palosaari (34):
      [media] si2168: do not print device is warm every-time when opened
      [media] af9033: fix AF9033 DVBv3 signal strength measurement
      [media] af9033: improve read_signal_strength error handling slightly
      [media] af9033: return 0.1 dB DVBv3 SNR for AF9030 family
      [media] af9033: continue polling unless critical IO error
      [media] mn88472: Panasonic MN88472 demod driver (DVB-C only)
      [media] mn88472: correct attach symbol name
      [media] mn88472: add small delay to wait DVB-C lock
      [media] mn88472: rename mn88472_c.c => mn88472.c
      [media] mn88472: rename state to dev
      [media] mn88472: convert driver to I2C client
      [media] mn88472: Convert driver to I2C RegMap API
      [media] mn88472: implement DVB-T and DVB-T2
      [media] mn88472: move to staging
      [media] mn88472: add staging TODO
      [media] MAINTAINERS: add mn88472 (Panasonic MN88472)
      [media] mn88473: Panasonic MN88473 DVB-T/T2/C demod driver
      [media] mn88473: add support for DVB-T2
      [media] mn88473: implement DVB-T mode
      [media] mn88473: improve IF frequency and BW handling
      [media] mn88473: convert driver to I2C binding
      [media] mn88473: convert to RegMap API
      [media] mn88473: move to staging
      [media] mn88473: add staging TODO
      [media] MAINTAINERS: add mn88473 (Panasonic MN88473)
      [media] r820t: add DVB-C config
      [media] rtl28xxu: enable demod ADC only when needed
      [media] rtl2832: implement option to bypass slave demod TS
      [media] rtl28xxu: add support for Panasonic MN88472 slave demod
      [media] rtl28xxu: add support for Panasonic MN88473 slave demod
      [media] rtl28xxu: rename tuner I2C client pointer
      [media] rtl28xxu: remove unused SDR attach logic
      [media] rtl28xxu: add SDR module for devices having R828D tuner
      [media] rtl2832_sdr: control ADC

Arun Mankuzhi (2):
      [media] s5p-mfc: modify mfc wakeup sequence for V8
      [media] s5p-mfc: De-init MFC when watchdog kicks in

Austin Lund (1):
      [media] media/rc: Send sync space information on the lirc device

Behan Webster (1):
      [media] ti-fpe: LLVMLinux: Remove nested function from ti-vpe

Beniamino Galvani (3):
      [media] media: rc: meson: document device tree bindings
      [media] media: rc: add driver for Amlogic Meson IR remote receiver
      [media] ARM: dts: meson: add IR receiver node

Bimow Chen (2):
      [media] af9033: fix DVBv3 signal strength value not correct issue
      [media] af9033: fix DVBv3 snr value not correct issue

Boris BREZILLON (10):
      [media] Move mediabus format definition to a more standard place
      [media] v4l: Update subdev-formats doc with new MEDIA_BUS_FMT values
      [media] Make use of the new media_bus_format definitions
      [media] i2c: Make use of media_bus_format enum
      [media] pci: Make use of MEDIA_BUS_FMT definitions
      [media] platform: Make use of media_bus_format enum
      [media] usb: Make use of media_bus_format enum
      [media] staging: media: Make use of MEDIA_BUS_FMT_ definitions
      [media] gpu: ipu-v3: Make use of media_bus_format enum
      [media] v4l: Forbid usage of V4L2_MBUS_FMT definitions inside the kernel

Christian Resell (1):
      [media] staging: media: bcm2048: fix coding style error

CrazyCat (3):
      [media] si2157: Si2148 support
      [media] si2168: TS clock inversion control
      [media] cxusb: Geniatech T230 support

Dan Carpenter (2):
      [media] media: dvb_core: replace a magic number by a macro
      [media] stv090x: remove indent levels in stv090x_get_coldlock()

Dmitry Torokhov (1):
      [media] exynos4-is: fix error handling of irq_of_parse_and_map

Dylan Rajaratnam (1):
      [media] img-ir/hw: Always read data to clear buffer

Fabio Estevam (2):
      [media] coda: Call v4l2_device_unregister() from a single location
      [media] coda: Unregister v4l2 upon alloc_workqueue() error

Felipe Balbi (1):
      [media] arm: omap2: rx51-peripherals: fix build warning

Frank Schaefer (1):
      [media] af9005: fix kernel panic on init if compiled without IR

Geert Uytterhoeven (1):
      [media] cx24117: Grammar s/if ... if/if ... is/

Guennadi Liakhovetski (1):
      [media] V4L2: fix VIDIOC_CREATE_BUFS 32-bit compatibility mode data copy-back

Hans Verkuil (66):
      [media] mem2mem_testdev: rename to vim2m
      [media] v4l2-ctrls: fix sparse warning
      [media] cx88: remove fmt from the buffer struct
      [media] cx88: drop the bogus 'queue' list in dmaqueue
      [media] cx88: drop videobuf abuse in cx88-alsa
      [media] cx88: convert to vb2
      [media] cx88: fix sparse warning
      [media] cx88: return proper errors during fw load
      [media] cx88: drop cx88_free_buffer
      [media] cx88: remove dependency on btcx-risc
      [media] cx88: increase API command timeout
      [media] cx88: don't pollute the kernel log
      [media] cx88: move width, height and field to core struct
      [media] cx88: drop mpeg_active field
      [media] cx88: don't allow changes while vb2_is_busy
      [media] cx88: consistently use UNSET for absent tuner
      [media] cx88: pci_disable_device comes after free_irq
      [media] cx88: fix VBI support
      [media] s5p-mfc: fix sparse error
      [media] bttv: fix sparse warning
      [media] videobuf: fix sparse warnings
      [media] smipcie: fix sparse warnings
      [media] stk1160: fix sparse warning
      [media] cxusb: fix sparse warnings
      [media] ti-vpe: fix sparse warnings
      [media] vivid: add test array controls
      [media] adv7842: fix G/S_EDID behavior
      [media] adv7511: fix G/S_EDID behavior
      [media] adv7604: Correct G/S_EDID behaviour
      [media] saa7164: fix sparse warnings
      [media] mach-omap2: remove deprecated VIDEO_OMAP2 support
      [media] omap24xx/tcm825x: remove deprecated omap2 camera drivers.
      [media] staging/media/Makefile: drop omap24xx reference
      [media] bttv/cx25821/cx88/ivtv: use sg_next instead of sg++
      [media] v4l2-dev: vdev->v4l2_dev is always set, so simplify code
      [media] v4l2-common: remove unused helper functions
      [media] v4l2-ctrl: move function prototypes from common.h to ctrls.h
      [media] v4l2-common: move v4l2_ctrl_check to cx2341x
      [media] videobuf2-core.h: improve documentation
      [media] vb2: replace 'write' by 'dma_dir'
      [media] vb2: add dma_dir to the alloc memop
      [media] vb2: don't free alloc context if it is ERR_PTR
      [media] vb2-dma-sg: add allocation context to dma-sg
      [media] vb2-dma-sg: move dma_(un)map_sg here
      [media] vb2-dma-sg: add dmabuf import support
      [media] vb2-dma-sg: add support for dmabuf exports
      [media] vb2-vmalloc: add support for dmabuf exports
      [media] vivid: enable vb2_expbuf support
      [media] vim2m: support expbuf
      [media] vb2: use dma_map_sg_attrs to prevent unnecessary sync
      [media] videodev2.h: improve colorspace support
      [media] v4l2-mediabus: improve colorspace support
      [media] v4l2-ioctl.c: log the new ycbcr_enc and quantization fields
      [media] DocBook media: rewrite the Colorspace chapter
      [media] vivid-tpg-colors: add AdobeRGB and BT.2020 support
      [media] vivid-tpg: improve colorspace support
      [media] vivid: add new colorspaces
      [media] vivid: add support for YCbCr encoding and quantization
      [media] adv7511: improve colorspace handling
      [media] cx18: add device_caps support
      [media] staging/media: fix querycap
      [media] media/usb,pci: fix querycap
      [media] media/radio: fix querycap
      [media] media/platform: fix querycap
      [media] media/platform: fix querycap
      [media] omap_vout: fix compile warnings

Ilja Friedel (1):
      [media] s5p-mfc: Only set timestamp/timecode for new frames

James Hogan (5):
      [media] img-ir/hw: Fix potential deadlock stopping timer
      [media] img-ir/hw: Drop [un]register_decoder declarations
      [media] img-ir: Depend on METAG or MIPS or COMPILE_TEST
      [media] img-ir: Don't set driver's module owner
      [media] MAINTAINERS: Add myself as img-ir maintainer

Joe Perches (3):
      [media] media: earthsoft: logging neatening
      [media] dvb-net: Fix probable mask then right shift defects
      [media] cx25840/cx18: Use standard ordering of mask and shift

Johann Klammer (1):
      [media] saa7146: turn bothersome error into a debug message

Jose Alberto Reguero (2):
      [media] [PATH,1/2] mxl5007 move reset to attach
      [media] [PATH,2/2] mxl5007 move loop_thru to attach

Josh Wu (2):
      [media] media: v4l2-image-sizes.h: add SVGA, XGA and UXGA size definitions
      [media] media: v4l2-image-sizes.h: correct the SVGA height definition

Kiran AVND (4):
      [media] s5p-mfc: support MIN_BUFFERS query for encoder
      [media] s5p-mfc: keep RISC ON during reset for V7/V8
      [media] s5p-mfc: check mfc bus ctrl before reset
      [media] s5p-mfc: flush dpbs when resolution changes

Laurent Pinchart (12):
      [media] v4l2: get/set prio using video_dev prio structure
      [media] uvcvideo: Move to video_ioctl2
      [media] uvcvideo: Set buffer field to V4L2_FIELD_NONE
      [media] uvcvideo: Separate video and queue enable/disable operations
      [media] uvcvideo: Add function to convert from queue to stream
      [media] uvcvideo: Implement vb2 queue start and stop stream operations
      [media] uvcvideo: Don't stop the stream twice at file handle release
      [media] uvcvideo: Rename uvc_alloc_buffers to uvc_request_buffers
      [media] uvcvideo: Rename and split uvc_queue_enable to uvc_queue_stream(on|off)
      [media] uvcvideo: Return all buffers to vb2 at stream stop and start failure
      [media] v4l: vb2: Fix race condition in vb2_fop_poll
      [media] v4l: vb2: Fix race condition in _vb2_fop_release

Markus Elfring (16):
      [media] DVB-frontends: Deletion of unnecessary checks before the function call "release_firmware"
      [media] m88ds3103: One function call less in m88ds3103_init() after error detection
      [media] si2168: One function call less in si2168_init() after error detection
      [media] firewire: Deletion of an unnecessary check before the function call "dvb_unregister_device"
      [media] i2c: Deletion of an unnecessary check before the function call "rc_unregister_device"
      [media] rc: Deletion of unnecessary checks before two function calls
      [media] platform: Deletion of unnecessary checks before two function calls
      [media] USB: Deletion of unnecessary checks before three function calls
      [media] siano: unnecessary check before rc_unregister_device()
      [media] V4L2: Deletion of an unnecessary check before the function call "vb2_put_vma"
      [media] tuners: remove uneeded checks before release_firmware()
      [media] si2157: One function call less in si2157_init() after error
      [media] ddbridge: remove unneeded check before dvb_unregister_device()
      [media] lirc_zilog: Deletion of unnecessary checks before vfree()
      [media] mn88473: Remove uneeded check before release_firmware()
      [media] mn88473: One function call less in mn88473_init() after error

Martin Kaiser (1):
      [media] lirc: use kfifo_initialized() on lirc_buffer's fifo

Matthias Schwarzott (16):
      [media] cx231xx: let i2c bus scanning use its own i2c_client
      [media] cx231xx: use own i2c_client for eeprom access
      [media] cx231xx: delete i2c_client per bus
      [media] cx231xx: give each master i2c bus a seperate name
      [media] cx231xx: Modifiy the symbolic constants for i2c ports and describe
      [media] cx231xx: Use symbolic constants for i2c ports instead of numbers
      [media] cx231xx: add wrapper to get the i2c_adapter pointer
      [media] cx231xx: remember status of i2c port_3 switch
      [media] cx231xx: let is_tuner check the real i2c port and not the i2c master number
      [media] cx231xx: change usage of I2C_1 to the real i2c port
      [media] cx231xx: register i2c mux adapters for bus 1
      [media] cx231xx: drop unconditional port3 switching
      [media] cx231xx: scan all four existing i2c busses instead of the 3 masters
      [media] cx231xx: remove direct register PWR_CTL_EN modification that switches port3
      [media] cx231xx: use 1 byte read for i2c scan
      [media] tveeprom: Update list of chips and extend serial number to 32bits

Mauro Carvalho Chehab (48):
      Merge tag 'v3.18-rc1' into patchwork
      Merge remote-tracking branch 'linus/master' into patchwork
      [media] s5p-mfc: declare s5p_mfc_bus_reset as static
      [media] dib7000p: get rid of an unused argument
      [media] Documentation: FE_SET_PROPERTY requires R/W
      [media] drxk: Fix debug printks
      [media] em28xx-dvb: remove unused mfe_sharing
      [media] sound: simplify au0828 quirk table
      [media] sound: Update au0828 quirks table
      [media] Update Documentation cardlist
      [media] fix a warning on avr32 arch
      [media] cx231xx: get rid of driver-defined printk macros
      [media] cx231xx: Fix identation
      [media] cx231xx: Cleanup printk at the driver
      [media] cx25840: Don't report an error if max size is adjusted
      [media] cx25840: convert max_buf_size var to lowercase
      [media] cx231xx: disable I2C errors during i2c_scan
      [media] cx231xx: convert from pr_foo to dev_foo
      [media] cx231xx: get rid of audio debug parameter
      [media] cx231xx: use dev_foo instead of printk
      [media] cx231xx: add addr for demod and make i2c_devs const
      [media] cx231xx: use dev_info() for extension load/unload
      [media] cx231xx: too much changes. Bump version number
      [media] cx231xx: simplify I2C scan debug messages
      [media] cx231xx: Improve the log message
      [media] cx23885-dvb: Fix some issues at the DVB error handling
      [media] smipcie: fix two small CodingStyle issues
      [media] cx231xx: Remove a bogus check for NULL
      [media] af0933: Don't go past arrays
      [media] stv090x: Fix delivery system setting
      [media] rc-main: Fix rc_type handling
      [media] stb0899: don't go past DiSEqC msg buffer
      [media] cx22700: Fix potential buffer overflow
      [media] cx24110: Fix a spatch warning
      [media] cx24110: Fix whitespaces at cx24110_set_fec()
      [media] cx23110: Fix return code for cx24110_set_fec()
      [media] cx24110: Simplify error handling at cx24110_set_fec()
      Merge tag 'v3.18-rc4' into patchwork
      [media] lmed04: add missing breaks
      Revert "[media] lmed04: add missing breaks"
      [media] omap: disable COMPILE_TEST
      [media] media: exynos-gsc: fix build warning
      [media] stv090x: remove export symbol for stv090x_set_gpio()
      [media] tda18271: Fix identation
      [media] em28xx: checkpatch cleanup: whitespaces/new lines cleanups
      [media] stv090x: Some whitespace cleanups
      [media] stv090x: Remove an unreachable code
      [media] stv090x: add an extra protetion against buffer overflow

Nibble Max (7):
      [media] cx23885: add DVBSky T982(Dual DVB-T2/T/C) support
      [media] dvb-usb-dvbsky: add T680CI dvb-t2/t/c usb ci box support
      [media] smipcie: use add_i2c_client and del_i2c_client functions
      [media] smipcie: add DVBSky T9580 V3 support
      [media] dvb-usb-dvbsky: add T330 dvb-t2/t/c usb stick support
      [media] cxusb: remove TechnoTrend CT2-4400 and CT2-4650 devices
      [media] dvb-usb-dvbsky: add TechnoTrend CT2-4400 and CT2-4650 devices support

Olli Salonen (19):
      [media] si2157: add support for SYS_DVBC_ANNEX_B
      [media] cx23855: add support for DVBSky T980C (no CI support)
      [media] sp2: fix incorrect struct
      [media] sp2: improve debug logging
      [media] cx23885: add I2C client for CI into state and handle unregistering
      [media] cx23855: add CI support for DVBSky T980C
      [media] dvbsky: don't print MAC address from read_mac_address
      [media] dvbsky: clean logging
      [media] dvbsky: add option to disable IR receiver
      [media] cxusb: TS mode setting for TT CT2-4400
      [media] cx23885: add support for TechnoTrend CT2-4500 CI
      [media] cxusb: initialize si2168_config struct
      [media] af9035: initialize si2168_config struct
      [media] em28xx: initialize si2168_config struct
      [media] si2157: Add support for Si2146-A10
      [media] em28xx: Add support for Terratec Cinergy T2 Stick HD
      [media] si2157: make checkpatch.pl happy (remove break after goto)
      [media] si2168: debug printout for firmware version
      [media] si2168: add support for firmware files in new format

Paul Bolle (1):
      [media] omap: Fix typo "HAS_MMU"

Pawel Osciak (5):
      [media] s5p-mfc: Fix REQBUFS(0) for encoder
      [media] s5p-mfc: Don't crash the kernel if the watchdog kicks in
      [media] s5p-mfc: Remove unused alloc field from private buffer struct
      [media] s5p-mfc: fix V4L2_CID_MIN_BUFFERS_FOR_CAPTURE on resolution change
      [media] s5p-mfc: fix a race in interrupt flags handling

Philipp Zabel (21):
      [media] coda: clear aborting flag in stop_streaming
      [media] coda: remove superfluous error message on devm_kzalloc failure
      [media] coda: add coda_write_base helper
      [media] coda: disable rotator if not needed
      [media] coda: simplify frame memory control register handling
      [media] coda: add support for partial interleaved YCbCr 4:2:0 (NV12) format
      [media] coda: add support for planar YCbCr 4:2:2 (YUV422P) format
      [media] coda: identify platform device earlier
      [media] coda: add coda_video_device descriptors
      [media] coda: split out encoder control setup to specify controls per video device
      [media] coda: add JPEG register definitions for CODA7541
      [media] coda: add CODA7541 JPEG support
      [media] coda: store bitstream buffer position with buffer metadata
      [media] coda: pad input stream for JPEG decoder
      [media] coda: try to only queue a single JPEG into the bitstream
      [media] coda: allow userspace to set compressed buffer size in a certain range
      [media] coda: set bitstream end flag in coda_release
      [media] coda: drop JPEG buffers not framed by SOI and EOI markers
      [media] coda: re-queue buffers if start_streaming fails
      [media] MAINTAINERS: add maintainer for CODA video4linux mem2mem driver
      [media] uvcvideo: Add quirk to force the Oculus DK2 IR tracker to grayscale

Prabhakar Lad (21):
      [media] media: davinci: vpbe: initialize vb2 queue and DMA context in probe
      [media] media: davinci: vpbe: drop buf_init() callback
      [media] media: davinci: vpbe: use vb2_ops_wait_prepare/finish helper functions
      [media] media: davinci: vpbe: drop buf_cleanup() callback
      [media] media: davinci: vpbe: improve vpbe_buffer_prepare() callback
      [media] media: davinci: vpbe: use vb2_fop_mmap/poll
      [media] media: davinci: vpbe: use fh handling provided by v4l
      [media] media: davinci: vpbe: use vb2_ioctl_* helpers
      [media] media: davinci: vpbe: add support for VB2_DMABUF
      [media] media: davinci: vpbe: add support for VIDIOC_EXPBUF
      [media] media: davinci: vpbe: use helpers provided by core if streaming is started
      [media] media: davinci: vpbe: drop unused member memory from vpbe_layer
      [media] media: davinci: vpbe: group v4l2_ioctl_ops
      [media] media: davinci: vpbe: return -ENODATA for *dv_timings/*_std calls
      [media] media: davinci: vpbe: add support for VIDIOC_CREATE_BUFS
      [media] media: vivid: use vb2_start_streaming_called() helper
      [media] media: cx88: use vb2_start_streaming_called() helper
      [media] media: vivid: use vb2_ops_wait_prepare/finish helper
      [media] media: marvell-ccic: use vb2_ops_wait_prepare/finish helper
      [media] media: blackfin: use vb2_ops_wait_prepare/finish helper
      [media] media: davinci: vpif_capture: use vb2_ops_wait_prepare/finish helper

Prathyush K (1):
      [media] s5p-mfc: clear 'enter_suspend' flag if suspend fails

Rasmus Villemoes (1):
      [media] s5p_mfc: Remove redundant casts

Richard Vollkommer (2):
      [media] xc5000: add IF output level control
      [media] au8522: improve lock performance with ZeeVee modulators

Sakari Ailus (25):
      [media] smiapp: Take mutex during PLL update in sensor initialisation
      [media] smiapp-pll: Correct clock debug prints
      [media] smiapp-pll: The clock tree values are unsigned --- fix debug prints
      [media] smiapp-pll: Separate bounds checking into a separate function
      [media] smiapp-pll: External clock frequency isn't an output value
      [media] smiapp-pll: Unify OP and VT PLL structs
      [media] smiapp-pll: Calculate OP clocks only for sensors that have them
      [media] smiapp-pll: Don't validate OP clocks if there are none
      [media] smiapp: The PLL calculator handles sensors with VT clocks only
      [media] smiapp: Remove validation of op_pix_clk_div
      [media] smiapp-pll: Add pixel rate in pixel array as output parameters
      [media] smiapp: Use actual pixel rate calculated by the PLL calculator
      [media] smiapp: Split calculating PLL with sensor's limits from updating it
      [media] smiapp: Gather information on valid link rate and BPP combinations
      [media] smiapp: Take valid link frequencies into account in supported mbus codes
      [media] smiapp: Clean up smiapp_set_format()
      [media] smiapp: Set valid link frequency range
      [media] smiapp: Update PLL when setting format
      [media] media: Print information on failed link validation
      [media] media: Fix a compiler warning in media_entity_pipeline_start()
      [media] v4l: Clean up sub-device format documentation
      [media] v4l: Add V4L2_SEL_TGT_NATIVE_SIZE selection target
      [media] v4l: Add input and output capability flags for native size setting
      [media] smiapp: Set left and top to zero for crop bounds selection
      [media] smiapp: Support V4L2_SEL_TGT_NATIVE_SIZE

Sean Young (3):
      [media] rc: port IgorPlug-USB to rc-core
      [media] lirc_igorplugusb: remove
      [media] redrat3: ensure dma is setup properly

Sebastian Reichel (8):
      [media] si4713: switch to devm regulator API
      [media] si4713: switch reset gpio to devm_gpiod API
      [media] si4713: use managed memory allocation
      [media] si4713: use managed irq request
      [media] si4713: add device tree support
      [media] si4713: add DT binding documentation
      [media] ARM: OMAP2: RX-51: update si4713 platform data
      [media] si4713: cleanup platform data

Shuah Khan (1):
      [media] media/au0828: Fix IR stop, poll to not access device during disconnect

Simon Farnsworth (1):
      [media] DocBook media: Clarify V4L2_FIELD_ANY for drivers

Sudip Mukherjee (1):
      [media] media: davinci: vpbe: missing clk_put

Takashi Iwai (1):
      [media] uvcvideo: Fix destruction order in uvc_delete()

Tomas Melin (1):
      [media] rc-main: fix lockdep splash for rc-main

Wilson Michaels (1):
      [media] add "lgdt330x" device name i2c_devs array

Witold Krecicki (1):
      [media] em28xx: add support for Leadtek VC100 USB capture device

ayaka (1):
      [media] s5p-mfc: correct the formats info for encoder

nibble.max (13):
      [media] cx23885: add IR for DVBSky T9580 Dual DVB-S2/T2/C PCIe card
      [media] dvb-usb-dvbsky: add s960ci dvb-s/s2 usb ci box support
      [media] cx23885: add DVBSky S950C dvb-s/s2 ci PCIe card support(no RC)
      [media] cx23885: add DVBSky S950C and T980C RC support
      [media] m88ts2022: return the err code in its probe function when error occurs
      [media] smipcie: SMI pcie bridge driver for DVBSky S950 V3 dvb-s/s2 cards
      [media] m88rs6000t: add new dvb-s/s2 tuner for integrated chip M88RS6000
      [media] m88ds3103: add support for the demod of M88RS6000
      [media] smipcie: add DVBSky S952 V3 support
      [media] cx23885: add DVBSky S950 support
      [media] cx23885: add DVBSky S952 support
      [media] m88ds3103: change ts clock config for serial mode
      [media] dvb-usb-dvbsky: fix i2c adapter for sp2 device

sensoray-dev (1):
      [media] s2255drv: fix spinlock issue

ほち (1):
      [media] dvb-frontends/Kconfig: better describe Toshiba TC90522

 Documentation/DocBook/media/dvb/dvbproperty.xml    |    4 +-
 Documentation/DocBook/media/v4l/biblio.xml         |   85 +
 Documentation/DocBook/media/v4l/dev-subdev.xml     |  109 +-
 Documentation/DocBook/media/v4l/io.xml             |    5 +-
 Documentation/DocBook/media/v4l/pixfmt.xml         | 1274 +++++++++----
 .../DocBook/media/v4l/selections-common.xml        |   16 +
 Documentation/DocBook/media/v4l/subdev-formats.xml |  308 ++--
 .../DocBook/media/v4l/vidioc-enuminput.xml         |    8 +
 .../DocBook/media/v4l/vidioc-enumoutput.xml        |    8 +
 .../devicetree/bindings/media/meson-ir.txt         |   14 +
 Documentation/devicetree/bindings/media/si4713.txt |   30 +
 Documentation/video4linux/CARDLIST.cx23885         |    2 +
 Documentation/video4linux/CARDLIST.em28xx          |    1 +
 Documentation/video4linux/CARDLIST.saa7134         |    1 +
 Documentation/video4linux/soc-camera.txt           |    2 +-
 MAINTAINERS                                        |   41 +
 arch/arm/boot/dts/meson.dtsi                       |    7 +
 arch/arm/mach-davinci/board-dm355-evm.c            |    2 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |    4 +-
 arch/arm/mach-davinci/dm355.c                      |    7 +-
 arch/arm/mach-davinci/dm365.c                      |    7 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   71 +-
 arch/arm/mach-omap2/devices.c                      |   31 -
 arch/arm/mach-shmobile/board-mackerel.c            |    2 +-
 arch/sh/boards/mach-ap325rxa/setup.c               |    2 +-
 drivers/gpu/ipu-v3/ipu-csi.c                       |   66 +-
 drivers/media/common/cx2341x.c                     |   29 +
 drivers/media/common/saa7146/saa7146_core.c        |    2 +-
 drivers/media/common/siano/smsir.c                 |    3 +-
 drivers/media/common/tveeprom.c                    |   36 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |    1 +
 drivers/media/dvb-core/dvb_net.c                   |    4 +-
 drivers/media/dvb-frontends/Kconfig                |    5 +-
 drivers/media/dvb-frontends/af9033.c               |  140 +-
 drivers/media/dvb-frontends/af9033_priv.h          |   11 +-
 drivers/media/dvb-frontends/au8522_dig.c           |  117 +-
 drivers/media/dvb-frontends/cx22700.c              |    3 +
 drivers/media/dvb-frontends/cx24110.c              |   50 +-
 drivers/media/dvb-frontends/cx24117.c              |    2 +-
 drivers/media/dvb-frontends/dib7000p.c             |    9 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |    3 +-
 drivers/media/dvb-frontends/drxk_hard.c            |    9 +-
 drivers/media/dvb-frontends/m88ds3103.c            |  267 ++-
 drivers/media/dvb-frontends/m88ds3103_priv.h       |  181 ++
 drivers/media/dvb-frontends/mn88472.h              |   38 +
 drivers/media/dvb-frontends/mn88473.h              |   38 +
 drivers/media/dvb-frontends/rtl2832.c              |   60 +-
 drivers/media/dvb-frontends/rtl2832.h              |   11 +
 drivers/media/dvb-frontends/rtl2832_sdr.c          |    8 +
 drivers/media/dvb-frontends/si2168.c               |   75 +-
 drivers/media/dvb-frontends/si2168.h               |    4 +
 drivers/media/dvb-frontends/si2168_priv.h          |    1 +
 drivers/media/dvb-frontends/sp2.c                  |   21 +-
 drivers/media/dvb-frontends/stb0899_drv.c          |    2 +-
 drivers/media/dvb-frontends/stv090x.c              |  196 +-
 drivers/media/dvb-frontends/stv090x.h              |   44 +-
 drivers/media/firewire/firedtv-ci.c                |    3 +-
 drivers/media/firewire/firedtv.h                   |    2 +-
 drivers/media/i2c/adv7170.c                        |   16 +-
 drivers/media/i2c/adv7175.c                        |   16 +-
 drivers/media/i2c/adv7180.c                        |    6 +-
 drivers/media/i2c/adv7183.c                        |    6 +-
 drivers/media/i2c/adv7511.c                        |  229 ++-
 drivers/media/i2c/adv7604.c                        |  109 +-
 drivers/media/i2c/adv7842.c                        |   40 +-
 drivers/media/i2c/ak881x.c                         |    8 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   14 +-
 drivers/media/i2c/cx25840/cx25840-firmware.c       |   11 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |    3 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |    6 +-
 drivers/media/i2c/ml86v7667.c                      |    6 +-
 drivers/media/i2c/mt9m032.c                        |    6 +-
 drivers/media/i2c/mt9p031.c                        |    8 +-
 drivers/media/i2c/mt9t001.c                        |    8 +-
 drivers/media/i2c/mt9v011.c                        |    6 +-
 drivers/media/i2c/mt9v032.c                        |   12 +-
 drivers/media/i2c/noon010pc30.c                    |   12 +-
 drivers/media/i2c/ov7670.c                         |   16 +-
 drivers/media/i2c/ov9650.c                         |   10 +-
 drivers/media/i2c/s5c73m3/s5c73m3.h                |    6 +-
 drivers/media/i2c/s5k4ecgx.c                       |    4 +-
 drivers/media/i2c/s5k5baf.c                        |   14 +-
 drivers/media/i2c/s5k6a3.c                         |    2 +-
 drivers/media/i2c/s5k6aa.c                         |    8 +-
 drivers/media/i2c/saa6752hs.c                      |    6 +-
 drivers/media/i2c/saa7115.c                        |    2 +-
 drivers/media/i2c/saa717x.c                        |    2 +-
 drivers/media/i2c/smiapp-pll.c                     |  280 +--
 drivers/media/i2c/smiapp-pll.h                     |   21 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  259 ++-
 drivers/media/i2c/smiapp/smiapp.h                  |    8 +
 drivers/media/i2c/soc_camera/imx074.c              |    8 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |   14 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |   70 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |   10 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |   22 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |   26 +-
 drivers/media/i2c/soc_camera/ov2640.c              |   54 +-
 drivers/media/i2c/soc_camera/ov5642.c              |    8 +-
 drivers/media/i2c/soc_camera/ov6650.c              |   58 +-
 drivers/media/i2c/soc_camera/ov772x.c              |   20 +-
 drivers/media/i2c/soc_camera/ov9640.c              |   40 +-
 drivers/media/i2c/soc_camera/ov9740.c              |   12 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   54 +-
 drivers/media/i2c/soc_camera/tw9910.c              |   10 +-
 drivers/media/i2c/sr030pc30.c                      |   14 +-
 drivers/media/i2c/tvp514x.c                        |   12 +-
 drivers/media/i2c/tvp5150.c                        |    6 +-
 drivers/media/i2c/tvp7002.c                        |   10 +-
 drivers/media/i2c/vs6624.c                         |   18 +-
 drivers/media/media-entity.c                       |   13 +-
 drivers/media/pci/Kconfig                          |    1 +
 drivers/media/pci/Makefile                         |    3 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |    6 +-
 drivers/media/pci/bt8xx/bttv-risc.c                |   12 +-
 drivers/media/pci/cx18/cx18-av-core.c              |   18 +-
 drivers/media/pci/cx18/cx18-cards.h                |    3 +-
 drivers/media/pci/cx18/cx18-controls.c             |    2 +-
 drivers/media/pci/cx18/cx18-driver.h               |    1 +
 drivers/media/pci/cx18/cx18-ioctl.c                |    9 +-
 drivers/media/pci/cx18/cx18-streams.c              |    9 +
 drivers/media/pci/cx23885/cx23885-417.c            |    4 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |  131 ++
 drivers/media/pci/cx23885/cx23885-core.c           |   15 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |  691 +++++--
 drivers/media/pci/cx23885/cx23885-input.c          |   31 +
 drivers/media/pci/cx23885/cx23885-vbi.c            |   10 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   12 +-
 drivers/media/pci/cx23885/cx23885.h                |    8 +
 drivers/media/pci/cx25821/cx25821-core.c           |   12 +-
 drivers/media/pci/cx88/Kconfig                     |    5 +-
 drivers/media/pci/cx88/Makefile                    |    1 -
 drivers/media/pci/cx88/cx88-alsa.c                 |  112 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |  565 +++---
 drivers/media/pci/cx88/cx88-cards.c                |   71 +-
 drivers/media/pci/cx88/cx88-core.c                 |  119 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |  158 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |  159 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |  216 ++-
 drivers/media/pci/cx88/cx88-video.c                |  871 +++------
 drivers/media/pci/cx88/cx88.h                      |  104 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |    3 +-
 drivers/media/pci/ivtv/ivtv-controls.c             |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |    2 +-
 drivers/media/pci/ivtv/ivtv-udma.c                 |    2 +-
 drivers/media/pci/meye/meye.c                      |    3 -
 drivers/media/pci/pt1/pt1.c                        |   13 +-
 drivers/media/pci/pt3/pt3.c                        |   75 +-
 drivers/media/pci/saa7134/saa7134-core.c           |   18 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |    5 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |   17 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |   16 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   16 +-
 drivers/media/pci/saa7134/saa7134.h                |    2 +-
 drivers/media/pci/saa7164/saa7164-buffer.c         |    4 +-
 drivers/media/pci/saa7164/saa7164-bus.c            |  101 +-
 drivers/media/pci/saa7164/saa7164-core.c           |   13 +-
 drivers/media/pci/saa7164/saa7164-fw.c             |    6 +-
 drivers/media/pci/saa7164/saa7164-types.h          |    4 +-
 drivers/media/pci/saa7164/saa7164.h                |    4 +-
 drivers/media/pci/smipcie/Kconfig                  |   17 +
 drivers/media/pci/smipcie/Makefile                 |    6 +
 drivers/media/pci/smipcie/smipcie.c                | 1099 ++++++++++++
 drivers/media/pci/smipcie/smipcie.h                |  299 ++++
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   88 +-
 drivers/media/pci/solo6x10/solo6x10.h              |    1 +
 drivers/media/pci/tw68/tw68-core.c                 |   15 +-
 drivers/media/pci/tw68/tw68-video.c                |    9 +-
 drivers/media/pci/tw68/tw68.h                      |    1 +
 drivers/media/pci/zoran/zoran_driver.c             |    5 +-
 drivers/media/platform/Kconfig                     |    4 +-
 drivers/media/platform/Makefile                    |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   34 +-
 drivers/media/platform/coda/Makefile               |    2 +-
 drivers/media/platform/coda/coda-bit.c             |  322 ++--
 drivers/media/platform/coda/coda-common.c          |  607 ++++---
 drivers/media/platform/coda/coda-jpeg.c            |  238 +++
 drivers/media/platform/coda/coda.h                 |   24 +-
 drivers/media/platform/coda/coda_regs.h            |    7 +
 drivers/media/platform/davinci/vpbe.c              |   21 +-
 drivers/media/platform/davinci/vpbe_display.c      |  617 ++-----
 drivers/media/platform/davinci/vpfe_capture.c      |    8 +-
 drivers/media/platform/davinci/vpif_capture.c      |    2 +
 drivers/media/platform/exynos-gsc/gsc-core.c       |   23 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |   14 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    4 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |   10 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   16 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |   26 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   14 +-
 drivers/media/platform/exynos4-is/fimc-reg.c       |   14 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   14 +-
 drivers/media/platform/fsl-viu.c                   |    3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   85 +-
 drivers/media/platform/marvell-ccic/mcam-core.h    |    3 +-
 drivers/media/platform/mx2_emmaprp.c               |    9 +-
 drivers/media/platform/omap/Kconfig                |    3 +-
 drivers/media/platform/omap/omap_vout.c            |   11 +-
 drivers/media/platform/omap3isp/ispccdc.c          |  112 +-
 drivers/media/platform/omap3isp/ispccp2.c          |   18 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |   42 +-
 drivers/media/platform/omap3isp/isppreview.c       |   60 +-
 drivers/media/platform/omap3isp/ispresizer.c       |   19 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   95 +-
 drivers/media/platform/omap3isp/ispvideo.h         |   10 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   10 +-
 drivers/media/platform/s3c-camif/camif-core.c      |    3 +-
 drivers/media/platform/s3c-camif/camif-regs.c      |    8 +-
 drivers/media/platform/s5p-g2d/g2d.c               |   10 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    9 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h       |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   49 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |  122 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   65 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |   13 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |   32 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |    2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |    2 +-
 drivers/media/platform/sh_vou.c                    |   11 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |   22 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |   26 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |    6 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |   36 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |   16 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |   14 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   20 +-
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |   38 +-
 drivers/media/platform/soc_camera/soc_camera.c     |    2 +-
 .../platform/soc_camera/soc_camera_platform.c      |    2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |   78 +-
 drivers/media/platform/ti-vpe/csc.c                |   10 +-
 drivers/media/platform/ti-vpe/sc.c                 |   10 +-
 drivers/media/platform/via-camera.c                |   12 +-
 .../media/platform/{mem2mem_testdev.c => vim2m.c}  |  222 +--
 drivers/media/platform/vino.c                      |    6 +-
 drivers/media/platform/vivid/vivid-core.c          |   21 +-
 drivers/media/platform/vivid/vivid-core.h          |   16 +-
 drivers/media/platform/vivid/vivid-ctrls.c         |  165 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |    4 +-
 drivers/media/platform/vivid/vivid-tpg-colors.c    |  704 +++++++-
 drivers/media/platform/vivid/vivid-tpg-colors.h    |    4 +-
 drivers/media/platform/vivid/vivid-tpg.c           |  327 ++--
 drivers/media/platform/vivid/vivid-tpg.h           |   38 +
 drivers/media/platform/vivid/vivid-vbi-cap.c       |    4 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |    4 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   38 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |    4 +
 drivers/media/platform/vivid/vivid-vid-out.c       |   29 +-
 drivers/media/platform/vsp1/vsp1_bru.c             |   14 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            |   12 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |   10 +-
 drivers/media/platform/vsp1/vsp1_lut.c             |   14 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |   10 +-
 drivers/media/platform/vsp1/vsp1_sru.c             |   12 +-
 drivers/media/platform/vsp1/vsp1_uds.c             |   10 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   42 +-
 drivers/media/radio/radio-wl1273.c                 |    4 +-
 drivers/media/radio/si4713/radio-platform-si4713.c |   28 +-
 drivers/media/radio/si4713/si4713.c                |  164 +-
 drivers/media/radio/si4713/si4713.h                |   15 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    4 +-
 drivers/media/rc/Kconfig                           |   26 +
 drivers/media/rc/Makefile                          |    2 +
 drivers/media/rc/igorplugusb.c                     |  261 +++
 drivers/media/rc/img-ir/Kconfig                    |    1 +
 drivers/media/rc/img-ir/img-ir-core.c              |    1 -
 drivers/media/rc/img-ir/img-ir-hw.c                |   28 +-
 drivers/media/rc/img-ir/img-ir-hw.h                |    6 +-
 drivers/media/rc/ir-lirc-codec.c                   |   12 +-
 drivers/media/rc/lirc_dev.c                        |    3 +-
 drivers/media/rc/meson-ir.c                        |  216 +++
 drivers/media/rc/rc-main.c                         |    8 +-
 drivers/media/rc/redrat3.c                         |    4 +-
 drivers/media/tuners/Kconfig                       |    8 +
 drivers/media/tuners/Makefile                      |    1 +
 drivers/media/tuners/m88rs6000t.c                  |  744 ++++++++
 drivers/media/tuners/m88rs6000t.h                  |   29 +
 drivers/media/tuners/m88ts2022.c                   |    2 +
 drivers/media/tuners/mxl5007t.c                    |   30 +-
 drivers/media/tuners/r820t.c                       |   12 +
 drivers/media/tuners/si2157.c                      |   44 +-
 drivers/media/tuners/si2157.h                      |    2 +-
 drivers/media/tuners/si2157_priv.h                 |    8 +-
 drivers/media/tuners/tda18271-common.c             |    2 +-
 drivers/media/tuners/xc5000.c                      |   17 +-
 drivers/media/tuners/xc5000.h                      |    1 +
 drivers/media/usb/au0828/au0828-cards.c            |    5 +
 drivers/media/usb/au0828/au0828-core.c             |    8 +
 drivers/media/usb/au0828/au0828-dvb.c              |    2 +
 drivers/media/usb/au0828/au0828-input.c            |   14 +-
 drivers/media/usb/cx231xx/Kconfig                  |    1 +
 drivers/media/usb/cx231xx/cx231xx-417.c            |   59 +-
 drivers/media/usb/cx231xx/cx231xx-audio.c          |   97 +-
 drivers/media/usb/cx231xx/cx231xx-avcore.c         |  331 ++--
 drivers/media/usb/cx231xx/cx231xx-cards.c          |  257 +--
 drivers/media/usb/cx231xx/cx231xx-core.c           |  165 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |  159 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c            |  132 +-
 drivers/media/usb/cx231xx/cx231xx-input.c          |    8 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c        |   47 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.c            |   48 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   89 +-
 drivers/media/usb/cx231xx/cx231xx.h                |   41 +-
 drivers/media/usb/dvb-usb-v2/Kconfig               |    3 +
 drivers/media/usb/dvb-usb-v2/af9035.c              |    1 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |  438 ++++-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |   22 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |  231 ++-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h            |    7 +-
 drivers/media/usb/dvb-usb/Kconfig                  |    1 -
 drivers/media/usb/dvb-usb/af9005.c                 |    3 +
 drivers/media/usb/dvb-usb/cxusb.c                  |  230 +--
 drivers/media/usb/dvb-usb/cxusb.h                  |    4 -
 drivers/media/usb/dvb-usb/technisat-usb2.c         |    5 +-
 drivers/media/usb/em28xx/em28xx-audio.c            |   19 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |    7 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   71 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   41 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   95 +-
 drivers/media/usb/em28xx/em28xx-i2c.c              |    6 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   17 +-
 drivers/media/usb/em28xx/em28xx-reg.h              |    3 -
 drivers/media/usb/em28xx/em28xx-v4l.h              |    1 -
 drivers/media/usb/em28xx/em28xx-vbi.c              |    1 -
 drivers/media/usb/em28xx/em28xx-video.c            |   98 +-
 drivers/media/usb/em28xx/em28xx.h                  |   27 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-context.c        |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |    2 +-
 drivers/media/usb/s2255/s2255drv.c                 |   25 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    2 +-
 drivers/media/usb/usbvision/usbvision-video.c      |    3 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   51 +-
 drivers/media/usb/uvc/uvc_queue.c                  |  161 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   | 1009 ++++++-----
 drivers/media/usb/uvc/uvc_video.c                  |   23 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   12 +-
 drivers/media/v4l2-core/v4l2-common.c              |  125 --
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   10 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   87 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |   34 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   15 +-
 drivers/media/v4l2-core/videobuf-core.c            |    6 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   49 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |   71 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |  425 ++++-
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |  194 +-
 drivers/staging/media/Kconfig                      |    4 +-
 drivers/staging/media/Makefile                     |    4 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c      |    7 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |   18 +-
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |   26 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  100 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |   90 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |   98 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |   18 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    8 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |    5 +-
 drivers/staging/media/lirc/Kconfig                 |    6 -
 drivers/staging/media/lirc/Makefile                |    1 -
 drivers/staging/media/lirc/lirc_igorplugusb.c      |  508 ------
 drivers/staging/media/lirc/lirc_imon.c             |   10 +-
 drivers/staging/media/lirc/lirc_sasem.c            |   10 +-
 drivers/staging/media/lirc/lirc_zilog.c            |    8 +-
 drivers/staging/media/mn88472/Kconfig              |    7 +
 drivers/staging/media/mn88472/Makefile             |    5 +
 drivers/staging/media/mn88472/TODO                 |   21 +
 drivers/staging/media/mn88472/mn88472.c            |  523 ++++++
 drivers/staging/media/mn88472/mn88472_priv.h       |   36 +
 drivers/staging/media/mn88473/Kconfig              |    7 +
 drivers/staging/media/mn88473/Makefile             |    5 +
 drivers/staging/media/mn88473/TODO                 |   21 +
 drivers/staging/media/mn88473/mn88473.c            |  464 +++++
 drivers/staging/media/mn88473/mn88473_priv.h       |   36 +
 drivers/staging/media/omap24xx/Kconfig             |   35 -
 drivers/staging/media/omap24xx/Makefile            |    5 -
 drivers/staging/media/omap24xx/omap24xxcam-dma.c   |  598 -------
 drivers/staging/media/omap24xx/omap24xxcam.c       | 1882 --------------------
 drivers/staging/media/omap24xx/omap24xxcam.h       |  596 -------
 drivers/staging/media/omap24xx/tcm825x.c           |  938 ----------
 drivers/staging/media/omap24xx/tcm825x.h           |  200 ---
 drivers/staging/media/omap24xx/v4l2-int-device.c   |  164 --
 drivers/staging/media/omap24xx/v4l2-int-device.h   |  305 ----
 drivers/staging/media/omap4iss/iss_csi2.c          |   62 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |   16 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |   28 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |   26 +-
 drivers/staging/media/omap4iss/iss_video.c         |   78 +-
 drivers/staging/media/omap4iss/iss_video.h         |   10 +-
 include/media/davinci/vpbe.h                       |    2 +-
 include/media/davinci/vpbe_display.h               |   21 -
 include/media/davinci/vpbe_venc.h                  |    5 +-
 include/media/exynos-fimc.h                        |    2 +-
 include/media/lirc_dev.h                           |    8 +-
 include/media/radio-si4713.h                       |   30 -
 include/media/si4713.h                             |    4 +-
 include/media/soc_camera.h                         |    2 +-
 include/media/soc_mediabus.h                       |    6 +-
 include/media/v4l2-common.h                        |   17 +-
 include/media/v4l2-ctrls.h                         |   25 +
 include/media/v4l2-image-sizes.h                   |    9 +
 include/media/v4l2-mediabus.h                      |    6 +-
 include/media/v4l2-subdev.h                        |    2 +-
 include/media/videobuf2-core.h                     |   42 +-
 include/media/videobuf2-dma-sg.h                   |    3 +
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/media-bus-format.h              |  125 ++
 include/uapi/linux/v4l2-common.h                   |    2 +
 include/uapi/linux/v4l2-mediabus.h                 |  219 ++-
 include/uapi/linux/v4l2-subdev.h                   |    6 +-
 include/uapi/linux/videodev2.h                     |  101 +-
 sound/usb/quirks-table.h                           |  166 +-
 416 files changed, 16517 insertions(+), 13239 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/meson-ir.txt
 create mode 100644 Documentation/devicetree/bindings/media/si4713.txt
 create mode 100644 drivers/media/dvb-frontends/mn88472.h
 create mode 100644 drivers/media/dvb-frontends/mn88473.h
 create mode 100644 drivers/media/pci/smipcie/Kconfig
 create mode 100644 drivers/media/pci/smipcie/Makefile
 create mode 100644 drivers/media/pci/smipcie/smipcie.c
 create mode 100644 drivers/media/pci/smipcie/smipcie.h
 create mode 100644 drivers/media/platform/coda/coda-jpeg.c
 rename drivers/media/platform/{mem2mem_testdev.c => vim2m.c} (81%)
 create mode 100644 drivers/media/rc/igorplugusb.c
 create mode 100644 drivers/media/rc/meson-ir.c
 create mode 100644 drivers/media/tuners/m88rs6000t.c
 create mode 100644 drivers/media/tuners/m88rs6000t.h
 delete mode 100644 drivers/staging/media/lirc/lirc_igorplugusb.c
 create mode 100644 drivers/staging/media/mn88472/Kconfig
 create mode 100644 drivers/staging/media/mn88472/Makefile
 create mode 100644 drivers/staging/media/mn88472/TODO
 create mode 100644 drivers/staging/media/mn88472/mn88472.c
 create mode 100644 drivers/staging/media/mn88472/mn88472_priv.h
 create mode 100644 drivers/staging/media/mn88473/Kconfig
 create mode 100644 drivers/staging/media/mn88473/Makefile
 create mode 100644 drivers/staging/media/mn88473/TODO
 create mode 100644 drivers/staging/media/mn88473/mn88473.c
 create mode 100644 drivers/staging/media/mn88473/mn88473_priv.h
 delete mode 100644 drivers/staging/media/omap24xx/Kconfig
 delete mode 100644 drivers/staging/media/omap24xx/Makefile
 delete mode 100644 drivers/staging/media/omap24xx/omap24xxcam-dma.c
 delete mode 100644 drivers/staging/media/omap24xx/omap24xxcam.c
 delete mode 100644 drivers/staging/media/omap24xx/omap24xxcam.h
 delete mode 100644 drivers/staging/media/omap24xx/tcm825x.c
 delete mode 100644 drivers/staging/media/omap24xx/tcm825x.h
 delete mode 100644 drivers/staging/media/omap24xx/v4l2-int-device.c
 delete mode 100644 drivers/staging/media/omap24xx/v4l2-int-device.h
 delete mode 100644 include/media/radio-si4713.h
 create mode 100644 include/uapi/linux/media-bus-format.h

