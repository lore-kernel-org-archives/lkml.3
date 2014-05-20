Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaETRA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:00:28 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:52692 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaETRA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:00:26 -0400
X-AuditID: cbfec373-b7fd56d0000060dc-b6-537b8a283cf5
Date: Tue, 20 May 2014 14:00:19 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.15-rc6] media fixes
Message-id: <20140520140019.4bb688d3.m.chehab@samsung.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42I5/e9woK5GV3WwwYMX0hZz1q9hs7i8aw6b
	Rc+GrawWj/resjuweJyY8ZvF4/MmuQCmKC6blNSczLLUIn27BK6MZafWsxZ0SlYcmLuGsYHx
	unAXIweHhICJxLXbkV2MnECmmMSFe+vZuhi5OIQEljBK9DY9YIJwmpkkFn14xA5SxSKgKrHx
	+mdWEJtNwEjiVWMLmC0CZH9+cYUVpIFZYDGjxMfn68EahAV0JXqaDjODbOMVsJK4cVMMYpuT
	xKvXk5lAbF4BQYkfk++xgNjMAuoSk+YtYoawtSWevLvAOoGRbxaSsllIymYhKVvAyLyKUbS0
	OLmgOCk910ivODG3uDQvXS85P3cTIyTwincwvthgdYhRgINRiYdXQbEqWIg1say4MvcQowQH
	s5IIr31wdbAQb0piZVVqUX58UWlOavEhRiYOTqkGRt/cIA+hV6Eb4p/ItoieXuOmHH9l1byd
	M1t03BbUMmdl/LFQzlQwk7K4EPj8nneRiN08rd5PC9Y/jC6XlytP90h+PXvZzPdr+V0vzH7n
	Ef7ZbO4i9r73yh8PN51p+bFfZYVWvauhybwyFaY53b9uPXV/e55bdX5H1rKIw5VLDKuXHni2
	a4cLtxJLcUaioRZzUXEiAPEuQb8aAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus


Most of the changes are drivers fixes (rtl28xuu, fc2580, ov7670, davinci,
gspca, s5p-fimc and s5c73m3). There is also a compat32 fix and one infoleak
fixup at the media controller.

Thanks!
Mauro.

-

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 97d9d23dda6f37d90aefeec4ed619d52df525382:

  [media] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode (2014-05-13 20:03:31 -0300)

----------------------------------------------------------------
Antti Palosaari (3):
      [media] rtl28xxu: do not hard depend on staging SDR module
      [media] rtl28xxu: silence error log about disabled rtl2832_sdr module
      [media] fc2580: fix tuning failure on 32-bit arch

Guennadi Liakhovetski (2):
      [media] V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
      [media] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode

Jean Delvare (1):
      [media] Prefer gspca_sonixb over sn9c102 for all devices

Lad, Prabhakar (5):
      [media] media: davinci: vpif_capture: fix releasing of active buffers
      [media] media: davinci: vpif_display: fix releasing of active buffers
      [media] media: davinci: vpbe_display: fix releasing of active buffers
      [media] staging: media: davinci: vpfe: make sure all the buffers are released
      [media] media: davinci: vpfe: make sure all the buffers unmapped and released

Mauro Carvalho Chehab (1):
      Merge tag 'v3.15-rc1' into patchwork

Nicolas Dufresne (1):
      [media] s5p-fimc: Fix YUV422P depth

Salva Peiró (1):
      [media] media-device: fix infoleak in ioctl media_enum_entities()

Sylwester Nawrocki (1):
      [media] s5c73m3: Add missing rename of v4l2_of_get_next_endpoint() function

 drivers/media/i2c/ov7670.c                       |  2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c         |  2 +-
 drivers/media/media-device.c                     |  1 +
 drivers/media/platform/davinci/vpbe_display.c    | 16 +++++++-
 drivers/media/platform/davinci/vpfe_capture.c    |  2 +
 drivers/media/platform/davinci/vpif_capture.c    | 34 +++++++++++------
 drivers/media/platform/davinci/vpif_display.c    | 35 +++++++++++------
 drivers/media/platform/exynos4-is/fimc-core.c    |  2 +-
 drivers/media/tuners/fc2580.c                    |  6 +--
 drivers/media/tuners/fc2580_priv.h               |  1 +
 drivers/media/usb/dvb-usb-v2/Makefile            |  1 -
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c          | 48 +++++++++++++++++++++---
 drivers/media/usb/gspca/sonixb.c                 |  2 -
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c    | 12 +++---
 drivers/staging/media/davinci_vpfe/vpfe_video.c  | 13 ++++++-
 drivers/staging/media/sn9c102/sn9c102_devtable.h |  2 -
 16 files changed, 132 insertions(+), 47 deletions(-)

