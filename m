Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaIXKsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:48:36 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37363 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaIXKsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:48:35 -0400
Date: Wed, 24 Sep 2014 07:48:28 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.17] media fixes
Message-ID: <20140924074828.3ddf50c1@recife.lan>
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
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.17-rc7

For some last time fixes:
	- a regression detected on Kernel 3.16 related to VBI Teletext
	  application breakage on drivers using videobuf2
	 (https://bugzilla.kernel.org/show_bug.cgi?id=84401).
	 The bug was noticed on saa7134 (migrated to VB2 on 3.16), but
	 also affects em28xx (migrated on 3.9 to VB2);
	- two additional sanity checks at videobuf2;
	- two fixups to restore proper VBI support at the em28xx driver;
	- two Kernel oops fixups (at cx24123 and cx2341x drivers);
	- a bug at adv7604 where an if was doing just the opposite as
	  it would be expected;
	- some documentation fixups to match the behavior defined at
	  the Kernel.

The following changes since commit a04646c045cab08a9e62b9be8f01ecbb0632d24e:

  [media] af9035: new IDs: add support for PCTV 78e and PCTV 79e (2014-09-04 12:24:19 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.17-rc7

for you to fetch changes up to 8e2c8717c1812628b5538c05250057b37c66fdbe:

  [media] em28xx-v4l: get rid of field "users" in struct em28xx_v4l2" (2014-09-21 21:27:57 -0300)

----------------------------------------------------------------
media fixes for v3.17-rc7

----------------------------------------------------------------
Frank Schaefer (1):
      [media] em28xx-v4l: get rid of field "users" in struct em28xx_v4l2"

Hans Verkuil (12):
      [media] videobuf2-dma-sg: fix for wrong GFP mask to sg_alloc_table_from_pages
      [media] videobuf2-core: add comments before the WARN_ON
      [media] videobuf2-core.h: fix comment
      [media] vb2: fix vb2 state check when start_streaming fails
      [media] DocBook media: fix fieldname in struct v4l2_subdev_selection
      [media] DocBook media: update version number and V4L2 changes
      [media] adv7604: fix inverted condition
      [media] cx24123: fix kernel oops due to missing parent pointer
      [media] cx2341x: fix kernel oops
      [media] vb2: fix VBI/poll regression
      [media] DocBook media: fix the poll() 'no QBUF' documentation
      [media] DocBook media: improve the poll() documentation

Mauro Carvalho Chehab (1):
      [media] em28xx: fix VBI handling logic

Randy Dunlap (1):
      [media] media/radio: fix radio-miropcm20.c build with io.h header file

Zhaowei Yuan (1):
      [media] vb2: fix plane index sanity check in vb2_plane_cookie()

 Documentation/DocBook/media/v4l/compat.xml         | 24 +++++++++++
 Documentation/DocBook/media/v4l/func-poll.xml      | 35 +++++++++++++---
 Documentation/DocBook/media/v4l/v4l2.xml           | 11 ++---
 .../media/v4l/vidioc-subdev-g-selection.xml        |  2 +-
 drivers/media/common/cx2341x.c                     |  1 +
 drivers/media/dvb-frontends/cx24123.c              |  1 +
 drivers/media/i2c/adv7604.c                        |  2 +-
 drivers/media/radio/radio-miropcm20.c              |  1 +
 drivers/media/usb/em28xx/em28xx-video.c            | 25 +++++------
 drivers/media/usb/em28xx/em28xx.h                  |  1 +
 drivers/media/v4l2-core/videobuf2-core.c           | 48 +++++++++++++++++-----
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |  2 +-
 include/media/videobuf2-core.h                     |  6 ++-
 13 files changed, 119 insertions(+), 40 deletions(-)

