Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbaJNO7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:59:23 -0400
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:60320 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932145AbaJNO7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:59:22 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.com, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, tiwai@suse.de, prabhakar.csengg@gmail.com,
        tim.gardner@canonical.com, linux@eikelenboom.it
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] media token resource framework 
Date: Tue, 14 Oct 2014 08:58:36 -0600
Message-Id: <cover.1413246370.git.shuahkh@osg.samsung.com>
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
and changes to use it in dvb-core, v4l2-core, au0828 driver,
and snd-usb-audio driver.

With these changes dvb and v4l2 can share the tuner without
disrupting each other. Used tvtime, xawtv, kaffeine, and vlc,
vlc audio capture option, arecord/aplay during development to
identify v4l2 vb2 and vb1 ioctls and file operations that
disrupt the digital stream and would require changes to check
tuner ownership prior to changing the tuner configuration.
vb2 changes are made in the v4l2-core and vb1 changes are made
in the au0828 driver to encourage porting drivers to vb2 to
advantage of the new media token resource framework with changes
in the core.

In this patch v2 series, fixed problems identified in the
patch v1 series. Important ones are changing snd-usb-audio
to use media tokens, holding tuner lock in VIDIOC_ENUMINPUT,
and VIDIOC_QUERYSTD.

Shuah Khan (6):
  media: add media token device resource framework
  media: v4l2-core changes to use media token api
  media: au0828-video changes to use media token api
  media: dvb-core changes to use media token api
  sound/usb: pcm changes to use media token api
  media: au0828-core changes to create and destroy media

 MAINTAINERS                             |    2 +
 drivers/media/dvb-core/dvb_frontend.c   |   14 +-
 drivers/media/usb/au0828/au0828-core.c  |   23 +++
 drivers/media/usb/au0828/au0828-video.c |   42 +++++-
 drivers/media/v4l2-core/v4l2-fh.c       |    7 +
 drivers/media/v4l2-core/v4l2-ioctl.c    |   61 ++++++++
 include/linux/media_tknres.h            |   50 +++++++
 lib/Makefile                            |    2 +
 lib/media_tknres.c                      |  237 +++++++++++++++++++++++++++++++
 sound/usb/pcm.c                         |    9 ++
 10 files changed, 445 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/media_tknres.h
 create mode 100644 lib/media_tknres.c

-- 
1.7.10.4

