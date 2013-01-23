Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3AWVGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 16:06:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3AWVF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 16:05:59 -0500
Date: Wed, 23 Jan 2013 19:05:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.8-rc5] media fixes
Message-ID: <20130123190545.781e4468@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For some fixes:
	- gspca: add needed delay for I2C traffic for sonixb/sonixj cameras;
	- gspca: add one missing Kinect USB ID;
	- usbvideo: some regression fixes;
	- omap3isp: fix some build issues;
	- videobuf2: fix video output handling;
	- exynos s5p/m5mols: a few regression fixes.

Thank you!
Mauro

-
The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 68d6f84ba0c47e658beff3a4bf0c43acee4b4690:

  [media] uvcvideo: Set error_idx properly for S_EXT_CTRLS failures (2013-01-11 13:30:27 -0200)

----------------------------------------------------------------
Hans de Goede (2):
      [media] gspca_sonixb: Properly wait between i2c writes
      [media] gspca_sonixj: Add a small delay after i2c_w1

Jacob Schloss (1):
      [media] gspca_kinect: add Kinect for Windows USB id

Kamil Debski (1):
      [media] s5p-mfc: Fix interrupt error handling routine

Laurent Pinchart (6):
      [media] [FOR,v3.8] omap3isp: Don't include deleted OMAP plat/ header files
      [media] v4l: vb2: Set data_offset to 0 for single-plane output buffers
      [media] omap3isp: Don't include <plat/cpu.h>
      [media] uvcvideo: Return -EACCES when trying to set a read-only control
      [media] uvcvideo: Cleanup leftovers of partial revert
      [media] uvcvideo: Set error_idx properly for S_EXT_CTRLS failures

Mauro Carvalho Chehab (1):
      Merge tag 'v3.8-rc3' into v4l_for_linus

Sylwester Nawrocki (2):
      [media] m5mols: Fix typo in get_fmt callback
      [media] s5p-fimc: Fix return value of __fimc_md_create_flite_source_links()

 drivers/media/i2c/m5mols/m5mols_core.c         |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c     |  3 -
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c       | 88 +++++++++++---------------
 drivers/media/usb/gspca/kinect.c               |  1 +
 drivers/media/usb/gspca/sonixb.c               | 13 ++--
 drivers/media/usb/gspca/sonixj.c               |  1 +
 drivers/media/usb/uvc/uvc_ctrl.c               |  4 +-
 drivers/media/usb/uvc/uvc_v4l2.c               |  6 +-
 drivers/media/v4l2-core/videobuf2-core.c       |  4 +-
 10 files changed, 57 insertions(+), 67 deletions(-)

