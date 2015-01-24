Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbbAXIE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 03:04:56 -0500
Received: from lists.s-osg.org ([54.187.51.154]:55794 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbbAXIEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 03:04:54 -0500
Date: Sat, 24 Jan 2015 06:04:49 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.19-rc6] media fixes
Message-ID: <20150124060449.42fca4ff@recife.lan>
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
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v3.19-4

For:
  - Fix some race conditions caused by a regression on videobuf2;
  - Fix a interrupt release bug on cx23885;
  - Fix support for Mygica T230 and HVR4400;
  - Fix compilation breakage when USB is not selected on tlg2300;
  - Fix capabilities report on ompa3isp, soc-camera, rcar_vin and pvrusb2;

Regards,
Mauro

PS.: e-mail resent, as I forgot to push the tag.

-

The following changes since commit 427ae153c65ad7a08288d86baf99000569627d03:

  [media] bq/c-qcam, w9966, pms: move to staging in preparation for removal (2014-12-16 23:21:44 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v3.19-4

for you to fetch changes up to 2c0108e1c02f9fc95f465adc4d2ce1ad8688290a:

  [media] omap3isp: Correctly set QUERYCAP capabilities (2015-01-21 21:09:11 -0200)

----------------------------------------------------------------
media fixes for v3.19-rc6

----------------------------------------------------------------
Guennadi Liakhovetski (1):
      [media] soc-camera: fix device capabilities in multiple camera host drivers

Hans Verkuil (3):
      [media] vb2: fix vb2_thread_stop race conditions
      [media] pvrusb2: fix missing device_caps in querycap
      [media] cx23885: fix free interrupt bug

Jonathan McDowell (1):
      [media] Fix Mygica T230 support

Matthias Schwarzott (1):
      [media] cx23885: Split Hauppauge WinTV Starburst from HVR4400 card entry

Mauro Carvalho Chehab (1):
      [media] tlg2300: Fix media dependencies

Nobuhiro Iwamatsu (1):
      [media] rcar_vin: Update device_caps and capabilities in querycap

Sakari Ailus (1):
      [media] omap3isp: Correctly set QUERYCAP capabilities

 drivers/media/pci/cx23885/cx23885-cards.c          | 23 +++++++++++++++------
 drivers/media/pci/cx23885/cx23885-core.c           |  4 ++--
 drivers/media/pci/cx23885/cx23885-dvb.c            | 11 ++++++++++
 drivers/media/pci/cx23885/cx23885.h                |  1 +
 drivers/media/platform/omap3isp/ispvideo.c         |  7 +++++--
 drivers/media/platform/soc_camera/atmel-isi.c      |  5 +++--
 drivers/media/platform/soc_camera/mx2_camera.c     |  3 ++-
 drivers/media/platform/soc_camera/mx3_camera.c     |  3 ++-
 drivers/media/platform/soc_camera/omap1_camera.c   |  3 ++-
 drivers/media/platform/soc_camera/pxa_camera.c     |  3 ++-
 drivers/media/platform/soc_camera/rcar_vin.c       |  4 +++-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  4 +++-
 drivers/media/usb/dvb-usb/cxusb.c                  |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           | 24 ++++++++++++----------
 drivers/media/v4l2-core/videobuf2-core.c           | 19 ++++++++---------
 drivers/staging/media/tlg2300/Kconfig              |  1 +
 16 files changed, 77 insertions(+), 40 deletions(-)

