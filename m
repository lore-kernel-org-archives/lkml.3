Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaIVPHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:07:13 -0400
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:40902 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754021AbaIVPHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:07:09 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.co, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 0/5] media token resource framework 
Date: Mon, 22 Sep 2014 09:00:44 -0600
Message-Id: <cover.1411397045.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add media token device resource framework to allow sharing
resources such as tuner, dma, audio etc. across media drivers
and non-media sound drivers that control media hardware. The
Media token resource is created at the main struct device that
is common to all drivers that claim various pieces of the main
media device, which allows them to find the resource using the
main struct device. As an example, digital, analog, and
snd-usb-audio drivers can use the media token resource API
using the main struct device for the interface the media device
is attached to.

This patch series consists of media token resource framework
and changes to use it in dvb-core, v4l2-core, and au0828
driver.

With these changes dvb and v4l2 can share the tuner without
disrupting each other. Used tvtime, xawtv, kaffeine, and
vlc to during development to identify v4l2 vb2 and vb1 ioctls
and file operations that disrupt the digital stream and would
require changes to check tuner ownership prior to changing the
tuner configuration. vb2 changes are made in the v4l2-core and
vb1 changes are made in the au0828 driver to encourage porting
drivers to vb2 to advantage of the new media token resource
framework with changes in the core.

Shuah Khan (5):
  media: add media token device resource framework
  media: v4l2-core changes to use media tuner token api
  media: au0828-video changes to use media tuner token api
  media: dvb-core changes to use media tuner token api
  media: au0828-core changes to create and destroy media token res

 MAINTAINERS                             |    2 +
 drivers/media/dvb-core/dvb_frontend.c   |   10 +
 drivers/media/usb/au0828/au0828-core.c  |   23 ++
 drivers/media/usb/au0828/au0828-video.c |   43 +++-
 drivers/media/v4l2-core/v4l2-fh.c       |   16 ++
 drivers/media/v4l2-core/v4l2-ioctl.c    |   96 +++++++-
 include/linux/media_tknres.h            |   98 +++++++++
 lib/Makefile                            |    2 +
 lib/media_tknres.c                      |  361 +++++++++++++++++++++++++++++++
 9 files changed, 648 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/media_tknres.h
 create mode 100644 lib/media_tknres.c

-- 
1.7.10.4

