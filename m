Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaLRNFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 08:05:41 -0500
Received: from lists.s-osg.org ([54.187.51.154]:40559 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbaLRNFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 08:05:39 -0500
Date: Thu, 18 Dec 2014 11:05:33 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.19-rc1] media updates
Message-ID: <20141218110533.5efd3353@recife.lan>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.19-2

For a second set of changes for 3.19, including:

- moves drivers for really old legacy hardware to staging. Those are
  using obsolete media kAPIs and are for hardware that nobody uses for years.
  Simply not worth porting them to the new kAPIs. Of course, if anyone pops up
  to fix, we can move them back from there;

- While not too late, do some API fixups at the new colorspace API, added
  for v3.19;

- Some improvements for rcar_vin driver;

- Some fixups at cx88 and vivid drivers;

- Some Documentation fixups; 

Thanks!
Mauro

The following changes since commit 71947828caef0c83d4245f7d1eaddc799b4ff1d1:

  [media] mn88473: One function call less in mn88473_init() after error (2014-12-04 16:00:47 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.19-2

for you to fetch changes up to 427ae153c65ad7a08288d86baf99000569627d03:

  [media] bq/c-qcam, w9966, pms: move to staging in preparation for removal (2014-12-16 23:21:44 -0200)

----------------------------------------------------------------
media updates for v3.19-rc1

----------------------------------------------------------------
Hans Verkuil (12):
      [media] v4l2-mediabus.h: use two __u16 instead of two __u32
      [media] DocBook media: add missing ycbcr_enc and quantization fields
      [media] vivid.txt: document new controls
      [media] DocBook media: update version number and document changes
      [media] vivid: fix CROP_BOUNDS typo for video output
      [media] v4l2-ioctl: WARN_ON if querycap didn't fill device_caps
      [media] cx88: add missing alloc_ctx support
      [media] cx88: remove leftover start_video_dma() call
      [media] MAINTAINERS: vivi -> vivid
      [media] vino/saa7191: move to staging in preparation for removal
      [media] tlg2300: move to staging in preparation for removal
      [media] bq/c-qcam, w9966, pms: move to staging in preparation for removal

Koji Matsuoka (4):
      [media] rcar_vin: Add YUYV capture format support
      [media] rcar_vin: Add scaling support
      [media] rcar_vin: Enable VSYNC field toggle mode
      [media] rcar_vin: Fix interrupt enable in progressive

Yoshihiro Kaneko (1):
      [media] rcar_vin: Add DT support for r8a7793 and r8a7794 SoCs

 Documentation/DocBook/media/v4l/compat.xml         |  12 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |  36 +-
 Documentation/DocBook/media/v4l/subdev-formats.xml |  18 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |  11 +-
 .../devicetree/bindings/media/rcar_vin.txt         |   2 +
 Documentation/video4linux/vivid.txt                |  15 +
 MAINTAINERS                                        |   4 +-
 drivers/media/Kconfig                              |   1 -
 drivers/media/Makefile                             |   2 +-
 drivers/media/i2c/Kconfig                          |   9 -
 drivers/media/i2c/Makefile                         |   1 -
 drivers/media/pci/cx88/cx88-blackbird.c            |   4 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |   4 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |  11 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |   9 +-
 drivers/media/pci/cx88/cx88-video.c                |  18 +-
 drivers/media/pci/cx88/cx88.h                      |   2 +
 drivers/media/platform/Kconfig                     |   8 -
 drivers/media/platform/Makefile                    |   3 -
 drivers/media/platform/soc_camera/rcar_vin.c       | 466 ++++++++++++++++++++-
 drivers/media/platform/vivid/vivid-vid-out.c       |   2 +-
 drivers/media/usb/Kconfig                          |   1 -
 drivers/media/usb/Makefile                         |   1 -
 drivers/media/v4l2-core/v4l2-ioctl.c               |   6 +
 drivers/staging/media/Kconfig                      |   6 +
 drivers/staging/media/Makefile                     |   3 +
 drivers/{ => staging}/media/parport/Kconfig        |  24 +-
 drivers/{ => staging}/media/parport/Makefile       |   0
 drivers/{ => staging}/media/parport/bw-qcam.c      |   0
 drivers/{ => staging}/media/parport/c-qcam.c       |   0
 drivers/{ => staging}/media/parport/pms.c          |   0
 drivers/{ => staging}/media/parport/w9966.c        |   0
 .../{media/usb => staging/media}/tlg2300/Kconfig   |   6 +-
 .../{media/usb => staging/media}/tlg2300/Makefile  |   0
 .../{media/usb => staging/media}/tlg2300/pd-alsa.c |   0
 .../usb => staging/media}/tlg2300/pd-common.h      |   0
 .../{media/usb => staging/media}/tlg2300/pd-dvb.c  |   0
 .../{media/usb => staging/media}/tlg2300/pd-main.c |   0
 .../usb => staging/media}/tlg2300/pd-radio.c       |   0
 .../usb => staging/media}/tlg2300/pd-video.c       |   0
 .../usb => staging/media}/tlg2300/vendorcmds.h     |   0
 drivers/staging/media/vino/Kconfig                 |  24 ++
 drivers/staging/media/vino/Makefile                |   3 +
 .../platform => staging/media/vino}/indycam.c      |   0
 .../platform => staging/media/vino}/indycam.h      |   0
 .../{media/i2c => staging/media/vino}/saa7191.c    |   0
 .../{media/i2c => staging/media/vino}/saa7191.h    |   0
 .../{media/platform => staging/media/vino}/vino.c  |   0
 .../{media/platform => staging/media/vino}/vino.h  |   0
 include/uapi/linux/v4l2-mediabus.h                 |   6 +-
 50 files changed, 640 insertions(+), 78 deletions(-)
 rename drivers/{ => staging}/media/parport/Kconfig (65%)
 rename drivers/{ => staging}/media/parport/Makefile (100%)
 rename drivers/{ => staging}/media/parport/bw-qcam.c (100%)
 rename drivers/{ => staging}/media/parport/c-qcam.c (100%)
 rename drivers/{ => staging}/media/parport/pms.c (100%)
 rename drivers/{ => staging}/media/parport/w9966.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/Kconfig (63%)
 rename drivers/{media/usb => staging/media}/tlg2300/Makefile (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-alsa.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-common.h (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-dvb.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-main.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-radio.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-video.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/vendorcmds.h (100%)
 create mode 100644 drivers/staging/media/vino/Kconfig
 create mode 100644 drivers/staging/media/vino/Makefile
 rename drivers/{media/platform => staging/media/vino}/indycam.c (100%)
 rename drivers/{media/platform => staging/media/vino}/indycam.h (100%)
 rename drivers/{media/i2c => staging/media/vino}/saa7191.c (100%)
 rename drivers/{media/i2c => staging/media/vino}/saa7191.h (100%)
 rename drivers/{media/platform => staging/media/vino}/vino.c (100%)
 rename drivers/{media/platform => staging/media/vino}/vino.h (100%)

